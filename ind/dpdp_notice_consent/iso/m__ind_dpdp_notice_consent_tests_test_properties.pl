% SPDX-License-Identifier: EUPL-1.2
:- module(m__ind_dpdp_notice_consent_tests_test_properties, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_lists_extra, [clausal_is_list/1]).
:- use_module(m__ind_dpdp_notice_consent_dpdp_notice_consent, [consent_ground/3, legitimate_use_ground/3, consent_notice/3, withdrawal_effect/3, consent_manager_status/3, provision_lists/2, decide_dpdp_notice_consent/2, dpdp_notice_consent_status/2]).
:- use_module(m__ind_dpdp_notice_consent_fixtures, [dpdp_notice_consent_subject/1, dpdp_notice_consent_profile_for/2]).
:- use_module(m__ind_dpdp_notice_consent_citations, [citation/2]).

profile_query_name(consent_ground).
profile_query_name(legitimate_use_ground).
profile_query_name(consent_notice).
profile_query_name(withdrawal_effect).
profile_query_name(consent_manager_status).

profile_query(consent_ground, Profile, Result, Citations) :-
    consent_ground(Profile, Result, Citations).
profile_query(legitimate_use_ground, Profile, Result, Citations) :-
    legitimate_use_ground(Profile, Result, Citations).
profile_query(consent_notice, Profile, Result, Citations) :-
    consent_notice(Profile, Result, Citations).
profile_query(withdrawal_effect, Profile, Result, Citations) :-
    withdrawal_effect(Profile, Result, Citations).
profile_query(consent_manager_status, Profile, Result, Citations) :-
    consent_manager_status(Profile, Result, Citations).

fixture_answer(Result - Citations) :-
    dpdp_notice_consent_subject(Subject),
    dpdp_notice_consent_profile_for(Subject, Profile),
    profile_query_name(QueryName),
    profile_query(QueryName, Profile, Result, Citations).

final_result(lawful_on_consent).
final_result(not_lawful_on_consent).
final_result(not_in_force).
final_result(lawful_on_legitimate_use).
final_result(not_lawful_on_legitimate_use).
final_result(notice_with_request_required).
final_result(notice_with_request_required_before_rule_3).
final_result(notice_for_earlier_consent_required).
final_result(notice_for_earlier_consent_required_before_rule_3).
final_result(not_required).
final_result(cease_processing_required).
final_result(processing_may_continue_without_consent).
final_result(may_act_as_consent_manager).
final_result(may_not_act_as_consent_manager).

recorded_citation(cite(CitationKey)) :-
    citation(CitationKey, _).

answer_well_formed(indeterminate([KeyName]) - []) :-
    atom(KeyName).
answer_well_formed(needs_legal_review(open_textured(KeyName, cite(CitationKey)), [inputs_relied_on(Pairs)]) - []) :-
    atom(KeyName),
    recorded_citation(cite(CitationKey)),
    clausal_is_list(Pairs).
answer_well_formed(input_problems([_|_]) - []).
answer_well_formed(Result - [FirstCitation|OtherCitations]) :-
    final_result(Result),
    maplist(recorded_citation, [FirstCitation|OtherCitations]).

no_repeated_citation(_ - Citations) :-
    sort(Citations, CitationSet),
    same_length(CitationSet, Citations).

subject_classifies(Subject) :-
    dpdp_notice_consent_subject(Subject),
    dpdp_notice_consent_profile_for(Subject, Profile),
    decide_dpdp_notice_consent(Profile, _Verdict).

test(totality_every_subject_classifies) :-
    findall(Subject, dpdp_notice_consent_subject(Subject), Subjects),
    sort(Subjects, SubjectSet),
    findall(Subject, subject_classifies(Subject), ClassifiedSubjects),
    sort(ClassifiedSubjects, SubjectSet).
test(determinism_every_profile_query_answers_once_per_subject) :-
    findall(Count, (dpdp_notice_consent_subject(Subject), dpdp_notice_consent_profile_for(Subject, Profile), profile_query_name(QueryName), findall(Result - Citations, profile_query(QueryName, Profile, Result, Citations), Answers), length(Answers, Count)), Counts),
    Counts = [_|_],
    sort(Counts, [1]).
test(determinism_the_facade_answers_once_per_subject) :-
    findall(Count, (dpdp_notice_consent_subject(Subject), dpdp_notice_consent_profile_for(Subject, Profile), findall(Verdict, decide_dpdp_notice_consent(Profile, Verdict), Verdicts), length(Verdicts, Count)), Counts),
    Counts = [_|_],
    sort(Counts, [1]).
test(every_fixture_answer_is_well_formed) :-
    findall(Answer, fixture_answer(Answer), Answers),
    Answers = [_|_],
    maplist(answer_well_formed, Answers).
test(every_citation_list_is_set_like) :-
    findall(Answer, fixture_answer(Answer), Answers),
    maplist(no_repeated_citation, Answers).
test(the_facade_status_follows_consent_ground) :-
    findall(Subject, dpdp_notice_consent_subject(Subject), Subjects),
    maplist(facade_matches_ground, Subjects).
test(input_problems_come_before_every_route_of_every_query) :-
    findall(Result, (member(Subject, [consent_wrong_type, consent_duplicate_key, consent_unknown_key]), dpdp_notice_consent_profile_for(Subject, Profile), profile_query_name(QueryName), profile_query(QueryName, Profile, Result, [])), Results),
    length(Results, 15),
    maplist(is_input_problems, Results).
test(each_settling_value_settles_consent_ground_alone) :-
    maplist(settles_consent_ground_alone, [lawful_purpose - false, consent_given - false, consent_withdrawn - true, consent_meets_section_6_1 - false]).
test(each_settling_value_settles_legitimate_use_alone) :-
    maplist(settles_legitimate_use_alone, [lawful_purpose - false, legitimate_use_clause - no_listed_use, legitimate_use_conditions_met - false]).
test(rule_3_flips_on_13_may_2027_and_stays_flipped) :-
    maplist(request_notice_on(notice_with_request_required_before_rule_3), [date(2025, 11, 13), date(2026, 12, 31), date(2027, 5, 12)]),
    maplist(request_notice_on(notice_with_request_required), [date(2027, 5, 13), date(2027, 5, 14), date(2030, 1, 1)]).
test(each_topic_gives_one_list_of_cited_items) :-
    maplist(topic_list_shape, [notice_with_request - 4, notice_for_earlier_consent - 4, rule_3_notice - 7, consent_request - 3, legitimate_uses - 9, state_use_standards - 11, consent_manager_conditions - 10, consent_manager_obligations - 22]).

ground_status(lawful_on_consent, eligible).
ground_status(not_lawful_on_consent, ineligible).
ground_status(not_in_force, ineligible).
ground_status(indeterminate(_), indeterminate).
ground_status(needs_legal_review(_, _), indeterminate).
ground_status(input_problems(_), indeterminate).

facade_matches_ground(Subject) :-
    dpdp_notice_consent_profile_for(Subject, Profile),
    consent_ground(Profile, Result, _),
    dpdp_notice_consent_status(Profile, Status),
    ground_status(Result, Status).

is_input_problems(input_problems([_|_])).

settles_consent_ground_alone(KeyName - Value) :-
    findall(Result, consent_ground([attribute(sections_4_to_7_in_force, true), attribute(KeyName, Value)], Result, _), Results),
    Results == [not_lawful_on_consent].

settles_legitimate_use_alone(KeyName - Value) :-
    findall(Result, legitimate_use_ground([attribute(sections_4_to_7_in_force, true), attribute(KeyName, Value)], Result, _), Results),
    Results == [not_lawful_on_legitimate_use].

request_notice_on(Expected, QuestionDate) :-
    findall(Result, consent_notice([attribute(sections_4_to_7_in_force, true), attribute(question_date, QuestionDate), attribute(acts_as_data_fiduciary, true), attribute(notice_occasion, request_for_consent)], Result, _), Results),
    Results == [Expected].

cited_item(content_item(Name, cite(CitationKey))) :-
    atom(Name),
    citation(CitationKey, _).

topic_list_shape(Topic - Expected) :-
    findall(ItemList, provision_lists(Topic, ItemList), Lists),
    Lists = [OnlyList],
    length(OnlyList, Expected),
    maplist(cited_item, OnlyList).

cp_test_names([totality_every_subject_classifies, determinism_every_profile_query_answers_once_per_subject, determinism_the_facade_answers_once_per_subject, every_fixture_answer_is_well_formed, every_citation_list_is_set_like, the_facade_status_follows_consent_ground, input_problems_come_before_every_route_of_every_query, each_settling_value_settles_consent_ground_alone, each_settling_value_settles_legitimate_use_alone, rule_3_flips_on_13_may_2027_and_stays_flipped, each_topic_gives_one_list_of_cited_items]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
