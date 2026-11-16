% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_ai_act_small_items_tests_test_properties, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(library(reif), [memberd_t/3]).
:- use_module(m__eu_ai_act_small_items_small_items, [small_items_status_values/1, bias_data_processing_status/4, sandbox_personal_data_processing_status/4, real_world_testing_status/4, informed_consent_status/4, sme_simplified_compliance_status/4, explanation_right_status/4]).
:- use_module(m__eu_ai_act_small_items_fixtures, [small_items_subject/1, small_items_assess/2]).
:- use_module(m__eu_ai_act_small_items_citations, [citation/2]).

registered_subjects(Subjects) :-
    findall(Subject, small_items_subject(Subject), Subjects).

exactly_one_verdict(Subject) :-
    findall(Verdict, small_items_assess(Subject, Verdict), Verdicts),
    length(Verdicts, 1).

verdict_is_well_shaped(StatusValues, small_items_verdict(Status, Citations)) :-
    memberd_t(Status, StatusValues, IsFinal),
    citations_fit(IsFinal, Citations).

citations_fit(true, [_|_]).
citations_fit(false, []).

subject_is_well_shaped(StatusValues, Subject) :-
    small_items_assess(Subject, Verdict),
    verdict_is_well_shaped(StatusValues, Verdict).

recorded_citation(cite(Key)) :-
    citation(Key, _Record).

set_like(Citations) :-
    sort(Citations, Sorted),
    length(Citations, Count),
    length(Sorted, Count).

subject_citations_recorded(Subject) :-
    small_items_assess(Subject, small_items_verdict(_Status, Citations)),
    maplist(recorded_citation, Citations),
    set_like(Citations).

same_citations_either_way(Positive - Negative) :-
    small_items_assess(Positive, small_items_verdict(_PositiveStatus, PositiveCitations)),
    small_items_assess(Negative, small_items_verdict(_NegativeStatus, NegativeCitations)),
    sort(PositiveCitations, Sorted),
    sort(NegativeCitations, Sorted).

query_answer_count(Query, Profile, AssessmentDate, Count) :-
    findall(Result - Citations, call(Query, Profile, AssessmentDate, Result, Citations), Answers),
    length(Answers, Count).

six_queries([bias_data_processing_status, sandbox_personal_data_processing_status, real_world_testing_status, informed_consent_status, sme_simplified_compliance_status, explanation_right_status]).

answers_once_on_empty_profile(AssessmentDate, Query) :-
    query_answer_count(Query, [], AssessmentDate, 1).

not_applicable_before_application(Query) :-
    call(Query, [], date(2025, 1, 1), not_applicable_on_date, [_]).

test(totality_every_subject_classifies) :-
    registered_subjects(Subjects),
    sort(Subjects, SubjectSet),
    findall(Subject, (small_items_subject(Subject), small_items_assess(Subject, _Verdict)), ClassifiedSubjects),
    sort(ClassifiedSubjects, SubjectSet).
test(subjects_are_registered_once_each) :-
    registered_subjects(Subjects),
    sort(Subjects, SubjectSet),
    length(Subjects, Count),
    length(SubjectSet, Count).
test(determinism_every_subject_yields_exactly_one_verdict) :-
    registered_subjects(Subjects),
    Subjects = [_|_],
    maplist(exactly_one_verdict, Subjects).
test(final_answers_cite_and_open_answers_do_not) :-
    small_items_status_values(StatusValues),
    registered_subjects(Subjects),
    maplist(subject_is_well_shaped(StatusValues), Subjects).
test(every_returned_citation_is_recorded_and_set_like) :-
    registered_subjects(Subjects),
    maplist(subject_citations_recorded, Subjects).
test(citations_do_not_depend_on_whether_the_conditions_are_met) :-
    maplist(same_citations_either_way, [bias_provider_all_conditions_met - bias_provider_without_records_of_reasons, sandbox_outside_law_enforcement - sandbox_none_of_the_listed_areas, testing_annex_iii_all_conditions_met - testing_longer_than_twelve_months, consent_meets_all_conditions - consent_without_copy, sme_independent - sme_with_linked_enterprises, explanation_all_conditions_met - explanation_point_2_system]).
test(every_query_answers_once_on_an_empty_profile) :-
    six_queries(Queries),
    maplist(answers_once_on_empty_profile(date(2026, 12, 1)), Queries).
test(every_query_answers_once_before_it_applies) :-
    six_queries(Queries),
    maplist(answers_once_on_empty_profile(date(2025, 1, 1)), Queries).
test(every_query_is_not_applicable_before_it_applies) :-
    six_queries(Queries),
    maplist(not_applicable_before_application, Queries).
test(the_first_absent_key_in_decision_order_is_named) :-
    informed_consent_status([], date(2026, 12, 1), indeterminate([consent_freely_given]), []),
    sme_simplified_compliance_status([], date(2026, 12, 1), indeterminate([is_an_sme_including_a_start_up]), []),
    explanation_right_status([], date(2026, 12, 1), indeterminate([affected_person_subject_to_a_deployer_decision_based_on_the_system_output]), []).

cp_test_names([totality_every_subject_classifies, subjects_are_registered_once_each, determinism_every_subject_yields_exactly_one_verdict, final_answers_cite_and_open_answers_do_not, every_returned_citation_is_recorded_and_set_like, citations_do_not_depend_on_whether_the_conditions_are_met, every_query_answers_once_on_an_empty_profile, every_query_answers_once_before_it_applies, every_query_is_not_applicable_before_it_applies, the_first_absent_key_in_decision_order_is_named]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
