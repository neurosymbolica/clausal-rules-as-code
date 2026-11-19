% SPDX-License-Identifier: EUPL-1.2
:- module(m__ind_dpdp_security_retention_tests_test_properties, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_lists_extra, [subtract/3, clausal_msort/2]).
:- use_module(m__ind_dpdp_security_retention_dpdp_security_retention, [security_safeguards_duty/3, accuracy_duty/3, erasure_duty/3, third_schedule_deemed_no_longer_served/3, third_schedule_period_end/2, decide_dpdp_security_retention/2, dpdp_security_retention_status/2, dpdp_security_retention_status_values/1]).
:- use_module(m__ind_dpdp_security_retention_fixtures, [dpdp_security_retention_subject/1, dpdp_security_retention_profile_for/2]).

profile_query(security_safeguards_duty).
profile_query(accuracy_duty).
profile_query(erasure_duty).
profile_query(third_schedule_deemed_no_longer_served).

fixture_query_answer(Subject, Query, Result, Citations) :-
    dpdp_security_retention_subject(Subject),
    dpdp_security_retention_profile_for(Subject, Profile),
    profile_query(Query),
    call(Query, Profile, Result, Citations).

nonfinal_result(indeterminate(_)).
nonfinal_result(needs_legal_review(_, _)).
nonfinal_result(input_problems(_)).

final_result(Result) :-
    member(Result, [required_with_rule_6_minimum, required_minimum_not_prescribed, not_required, not_in_force, required, erase, erase_and_cause_data_processor_to_erase, retain_until_minimum_retention_period_end, retain_as_required_by_other_law, not_yet_required, deemed_no_longer_served, not_yet_deemed, not_listed]).

subject_classifies(Subject) :-
    dpdp_security_retention_subject(Subject),
    dpdp_security_retention_profile_for(Subject, Profile),
    decide_dpdp_security_retention(Profile, _Verdict).

subject_verdict_count(Subject, Count) :-
    dpdp_security_retention_profile_for(Subject, Profile),
    findall(Verdict, decide_dpdp_security_retention(Profile, Verdict), Verdicts),
    length(Verdicts, Count).

query_answer_count(Subject, Query, Count) :-
    dpdp_security_retention_profile_for(Subject, Profile),
    findall(Result - Citations, call(Query, Profile, Result, Citations), Answers),
    length(Answers, Count).

test(totality_every_subject_classifies) :-
    findall(Subject, dpdp_security_retention_subject(Subject), Subjects),
    sort(Subjects, SubjectSet),
    findall(Subject, subject_classifies(Subject), ClassifiedSubjects),
    sort(ClassifiedSubjects, SubjectSet).
test(determinism_every_subject_one_verdict) :-
    findall(Subject - Count, (dpdp_security_retention_subject(Subject), subject_verdict_count(Subject, Count)), Counts),
    findall(Subject - 1, dpdp_security_retention_subject(Subject), Expected),
    Counts == Expected.
test(determinism_every_query_one_answer_per_subject) :-
    findall(Subject - Query - Count, (dpdp_security_retention_subject(Subject), profile_query(Query), query_answer_count(Subject, Query, Count)), Counts),
    findall(Subject - Query - 1, (dpdp_security_retention_subject(Subject), profile_query(Query)), Expected),
    Counts == Expected.
test(every_status_is_in_the_status_table) :-
    findall(Status, (dpdp_security_retention_subject(Subject), dpdp_security_retention_profile_for(Subject, Profile), dpdp_security_retention_status(Profile, Status)), Statuses),
    sort(Statuses, StatusSet),
    dpdp_security_retention_status_values(StatusValues),
    subtract(StatusSet, StatusValues, ExtraStatuses),
    ExtraStatuses == [].
test(the_fixtures_reach_every_status) :-
    findall(Status, (dpdp_security_retention_subject(Subject), dpdp_security_retention_profile_for(Subject, Profile), dpdp_security_retention_status(Profile, Status)), Statuses),
    sort(Statuses, StatusSet),
    dpdp_security_retention_status_values(StatusValues),
    clausal_msort(StatusValues, SortedValues),
    StatusSet == SortedValues.
test(a_nonfinal_answer_with_empty_citations_exists) :-
    fixture_query_answer(fiduciary_unsure_with_day, security_safeguards_duty, Result, []),
    nonfinal_result(Result).
test(a_final_answer_with_citations_exists) :-
    fixture_query_answer(marketplace_after_sale, erasure_duty, Result, [_|_]),
    final_result(Result).
test(every_answer_is_a_known_result) :-
    findall(Result, (fixture_query_answer(_, _, Result, _), final_result(Result)), FinalResults),
    findall(Result, (fixture_query_answer(_, _, Result, _), nonfinal_result(Result)), NonfinalResults),
    findall(Result, fixture_query_answer(_, _, Result, _), AllResults),
    length(FinalResults, FinalCount),
    length(NonfinalResults, NonfinalCount),
    length(AllResults, AllCount),
    AllCount =:= FinalCount + NonfinalCount.
test(registered_users_axis_is_monotone_for_gaming) :-
    findall(UserCount - Result, (member(UserCount, [0, 4999999, 5000000, 6000000, 30000000]), gaming_result(UserCount, Result)), Answers),
    Answers == [0 - not_listed, 4999999 - not_listed, 5000000 - deemed_no_longer_served, 6000000 - deemed_no_longer_served, 30000000 - deemed_no_longer_served].
test(no_period_end_before_2030_05_13) :-
    findall(PeriodEnd, (member(ApproachDate, [date(2001, 1, 1), date(2025, 11, 13), date(2027, 5, 12), date(2027, 5, 13)]), third_schedule_period_end(ApproachDate, PeriodEnd)), PeriodEnds),
    PeriodEnds == [date(2030, 5, 13), date(2030, 5, 13), date(2030, 5, 13), date(2030, 5, 13)].

test(no_nonfinal_answer_carries_a_citation, fail) :-
    fixture_query_answer(_, _, Result, [_|_]),
    nonfinal_result(Result).
test(no_final_answer_lacks_a_citation, fail) :-
    fixture_query_answer(_, _, Result, []),
    final_result(Result).
test(citations_are_set_like, fail) :-
    fixture_query_answer(_, _, _, Citations),
    sort(Citations, CitationSet),
    length(Citations, ListLength),
    length(CitationSet, SetLength),
    dif(ListLength, SetLength).

gaming_profile(UserCount, [attribute(section_8_8_in_force, true), attribute(assessment_date, date(2030, 6, 2)), attribute(third_schedule_class, online_gaming_intermediary), attribute(registered_users_in_india, UserCount), attribute(third_schedule_purpose_excepted, false), attribute(last_approached_date, date(2027, 6, 1))]).

gaming_result(UserCount, Result) :-
    gaming_profile(UserCount, Profile),
    third_schedule_deemed_no_longer_served(Profile, Result, _).

cp_test_names([totality_every_subject_classifies, determinism_every_subject_one_verdict, determinism_every_query_one_answer_per_subject, every_status_is_in_the_status_table, the_fixtures_reach_every_status, a_nonfinal_answer_with_empty_citations_exists, a_final_answer_with_citations_exists, every_answer_is_a_known_result, registered_users_axis_is_monotone_for_gaming, no_period_end_before_2030_05_13]).
cp_test_fail_names([no_nonfinal_answer_carries_a_citation, no_final_answer_lacks_a_citation, citations_are_set_like]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
