% SPDX-License-Identifier: EUPL-1.2
:- module(m__ch_swiss_fadp_art24_breach_notification_tests_test_properties, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_lists_extra, [subtract/3]).
:- use_module(m__ch_swiss_fadp_art24_breach_notification_swiss_fadp_art24_breach_notification, [decide_swiss_fadp_art24_breach_notification/2, swiss_controller_report_to_commissioner/3, swiss_processor_report_to_controller/3, swiss_information_of_data_subject/3, eu_controller_notification_to_supervisory_authority/3, compare_swiss_eu_authority_notification/5]).
:- use_module(m__ch_swiss_fadp_art24_breach_notification_fixtures, [swiss_fadp_art24_breach_notification_subject/1, swiss_fadp_art24_breach_notification_profile_for/2]).

subject_classifies(Subject) :-
    swiss_fadp_art24_breach_notification_subject(Subject),
    swiss_fadp_art24_breach_notification_profile_for(Subject, Profile),
    decide_swiss_fadp_art24_breach_notification(Profile, _Verdict).

query_name(controller_report).
query_name(processor_report).
query_name(data_subject_information).
query_name(eu_notification).
query_name(comparison).

cited_query(controller_report).
cited_query(processor_report).
cited_query(data_subject_information).
cited_query(eu_notification).

query_vocabulary(controller_report, [cite(ch_fadp_art_5_h), cite(ch_fadp_art_24_1)]).
query_vocabulary(processor_report, [cite(ch_fadp_art_5_h), cite(ch_fadp_art_24_3)]).
query_vocabulary(data_subject_information, [cite(ch_fadp_art_5_h), cite(ch_fadp_art_24_4), cite(ch_fadp_art_24_5), cite(ch_fadp_art_24_5_a), cite(ch_fadp_art_24_5_b), cite(ch_fadp_art_24_5_c)]).
query_vocabulary(eu_notification, [cite(eu_reg_2016_679_art_33_1)]).

query_answers(controller_report, Profile, Answers) :-
    findall(Result - Citations, swiss_controller_report_to_commissioner(Profile, Result, Citations), Answers).
query_answers(processor_report, Profile, Answers) :-
    findall(Result - Citations, swiss_processor_report_to_controller(Profile, Result, Citations), Answers).
query_answers(data_subject_information, Profile, Answers) :-
    findall(Result - Citations, swiss_information_of_data_subject(Profile, Result, Citations), Answers).
query_answers(eu_notification, Profile, Answers) :-
    findall(Result - Citations, eu_controller_notification_to_supervisory_authority(Profile, Result, Citations), Answers).
query_answers(comparison, Profile, Answers) :-
    findall(answer(Swiss, Union, Difference, Changed), compare_swiss_eu_authority_notification(Profile, Swiss, Union, Difference, Changed), Answers).

all_subject_queries(QueryGoal, PairSet) :-
    findall(Subject - Query, (swiss_fadp_art24_breach_notification_subject(Subject), call(QueryGoal, Query)), Pairs),
    sort(Pairs, PairSet).

deterministic(Subject, Query) :-
    swiss_fadp_art24_breach_notification_subject(Subject),
    query_name(Query),
    swiss_fadp_art24_breach_notification_profile_for(Subject, Profile),
    query_answers(Query, Profile, [_OneAnswer]).

well_cited(Result, [_|_]) :-
    atom(Result).
well_cited(Result, []) :-
    compound(Result).

cited(Subject, Query) :-
    swiss_fadp_art24_breach_notification_subject(Subject),
    cited_query(Query),
    swiss_fadp_art24_breach_notification_profile_for(Subject, Profile),
    query_answers(Query, Profile, [Result - Citations]),
    well_cited(Result, Citations).

in_vocabulary(Subject, Query) :-
    swiss_fadp_art24_breach_notification_subject(Subject),
    cited_query(Query),
    swiss_fadp_art24_breach_notification_profile_for(Subject, Profile),
    query_answers(Query, Profile, [_Result - Citations]),
    query_vocabulary(Query, Allowed),
    subtract(Citations, Allowed, Outside),
    Outside == [],
    sort(Citations, SortedCitations),
    same_length(Citations, SortedCitations).

comparison_copies(Subject) :-
    swiss_fadp_art24_breach_notification_subject(Subject),
    swiss_fadp_art24_breach_notification_profile_for(Subject, Profile),
    swiss_controller_report_to_commissioner(Profile, SwissResult, _SwissCitations),
    eu_controller_notification_to_supervisory_authority(Profile, EuResult, _EuCitations),
    compare_swiss_eu_authority_notification(Profile, CopiedSwiss, CopiedEu, Difference, Changed),
    CopiedSwiss == SwissResult,
    CopiedEu == EuResult,
    difference_consistent(Difference, Changed).

difference_consistent(differs, [cite(ch_fadp_art_24_1), cite(eu_reg_2016_679_art_33_1)]).
difference_consistent(same, []).
difference_consistent(not_comparable, []).

controller_required(Subject) :-
    swiss_fadp_art24_breach_notification_subject(Subject),
    swiss_fadp_art24_breach_notification_profile_for(Subject, Profile),
    swiss_controller_report_to_commissioner(Profile, authority_notification_required, _Citations).

processor_also_required(Subject) :-
    controller_required(Subject),
    swiss_fadp_art24_breach_notification_profile_for(Subject, Profile),
    swiss_processor_report_to_controller(Profile, report_to_controller_required, _Citations).

test(totality_every_subject_classifies) :-
    findall(Subject, swiss_fadp_art24_breach_notification_subject(Subject), Subjects),
    sort(Subjects, SubjectSet),
    findall(Subject, subject_classifies(Subject), ClassifiedSubjects),
    sort(ClassifiedSubjects, SubjectSet).
test(determinism_every_query_yields_one_solution_per_subject) :-
    all_subject_queries(query_name, PairSet),
    findall(Subject - Query, deterministic(Subject, Query), DeterministicPairs),
    sort(DeterministicPairs, PairSet).
test(citation_completeness_final_cited_not_final_empty) :-
    all_subject_queries(cited_query, PairSet),
    findall(Subject - Query, cited(Subject, Query), CitedPairs),
    sort(CitedPairs, PairSet).
test(citations_come_from_the_vocabulary_each_once) :-
    all_subject_queries(cited_query, PairSet),
    findall(Subject - Query, in_vocabulary(Subject, Query), VocabularyPairs),
    sort(VocabularyPairs, PairSet).
test(comparison_copies_each_side_and_changed_by_only_on_differs) :-
    findall(Subject, swiss_fadp_art24_breach_notification_subject(Subject), Subjects),
    sort(Subjects, SubjectSet),
    findall(Subject, comparison_copies(Subject), CopyingSubjects),
    sort(CopyingSubjects, SubjectSet).
test(processor_report_owed_whenever_controller_report_is) :-
    findall(Subject, controller_required(Subject), RequiredSubjects),
    sort(RequiredSubjects, RequiredSet),
    RequiredSet = [_|_],
    findall(Subject, processor_also_required(Subject), AlsoSubjects),
    sort(AlsoSubjects, RequiredSet).
test(citations_are_fixed_per_answer_whichever_key_decided) :-
    swiss_fadp_art24_breach_notification_profile_for(no_breach, NoBreachProfile),
    swiss_fadp_art24_breach_notification_profile_for(high_risk_false_control, HighRiskFalseProfile),
    swiss_controller_report_to_commissioner(NoBreachProfile, authority_notification_not_required, NoBreachCitations),
    swiss_controller_report_to_commissioner(HighRiskFalseProfile, authority_notification_not_required, HighRiskFalseCitations),
    NoBreachCitations == HighRiskFalseCitations.

cp_test_names([totality_every_subject_classifies, determinism_every_query_yields_one_solution_per_subject, citation_completeness_final_cited_not_final_empty, citations_come_from_the_vocabulary_each_once, comparison_copies_each_side_and_changed_by_only_on_differs, processor_report_owed_whenever_controller_report_is, citations_are_fixed_per_answer_whichever_key_decided]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
