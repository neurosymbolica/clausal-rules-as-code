% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_rts_continuity_testing_and_recovery_tests_test_properties, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_dora_rts_continuity_testing_and_recovery_dora_rts_continuity_testing_and_recovery, [rts_continuity_testing_and_recovery_duties_required/3, rts_continuity_testing_and_recovery_duties_complete/3, rts_continuity_testing_and_recovery_duties_outstanding/3, decide_dora_rts_continuity_testing_and_recovery/2, dora_rts_continuity_testing_and_recovery_checklist/2]).
:- use_module(m__eu_dora_rts_continuity_testing_and_recovery_fixtures, [dora_rts_continuity_testing_and_recovery_subject/1, dora_rts_continuity_testing_and_recovery_profile_for/2]).

query_names([rts_continuity_testing_and_recovery_duties_required, rts_continuity_testing_and_recovery_duties_complete, rts_continuity_testing_and_recovery_duties_outstanding]).

duty_order([testing_informed_by_business_impact_analysis_and_ict_risk_assessment, assessment_of_continuity_of_critical_or_important_functions, testing_on_disruption_scenarios, testing_of_ict_third_party_services, testing_of_switchover_scenarios, testing_challenges_plan_assumptions, testing_verifies_ability_to_respond, involvement_of_central_counterparty_parties_in_testing, involvement_of_central_securities_depository_parties_in_testing, documentation_of_test_results, handling_of_test_deficiencies, response_and_recovery_plans_informed_by_business_impact_analysis, activation_and_deactivation_conditions, actions_for_critical_or_important_ict_systems_and_services, design_to_meet_recovery_objectives, documentation_and_availability_of_plans, short_and_long_term_recovery_options, plan_objectives_and_success_conditions, identification_of_relevant_scenarios, scenarios_based_on_threats_and_lessons_learned, listed_disruption_scenarios, alternative_recovery_options, continuity_measures_for_ict_third_party_service_provider_failures]).

ordered_subsequence([], _).
ordered_subsequence([DutyAtom|LaterDuties], [DutyAtom|LaterOrder]) :-
    ordered_subsequence(LaterDuties, LaterOrder).
ordered_subsequence([DutyAtom|LaterDuties], [OrderAtom|LaterOrder]) :-
    dif(DutyAtom, OrderAtom),
    ordered_subsequence([DutyAtom|LaterDuties], LaterOrder).

in_duty_order(Duties) :-
    duty_order(Order),
    ordered_subsequence(Duties, Order).

query_answers(Subject, QueryName, Answers) :-
    dora_rts_continuity_testing_and_recovery_profile_for(Subject, Profile),
    findall(Result - Citations, call(QueryName, Profile, Result, Citations), Answers).

single_answer(Subject, QueryName, Result, Citations) :-
    dora_rts_continuity_testing_and_recovery_subject(Subject),
    query_names(QueryNames),
    member(QueryName, QueryNames),
    query_answers(Subject, QueryName, [Result - Citations]).

status_compound(indeterminate(_)).
status_compound(needs_legal_review(_, _)).
status_compound(input_problems(_)).

well_formed_citation(cite(CitationKey)) :-
    atom(CitationKey),
    sub_atom(CitationKey, 0, _, _, eu_reg_20).

subject_classifies(Subject) :-
    dora_rts_continuity_testing_and_recovery_subject(Subject),
    dora_rts_continuity_testing_and_recovery_profile_for(Subject, Profile),
    decide_dora_rts_continuity_testing_and_recovery(Profile, _Verdict).

subject_count(SubjectCount) :-
    findall(Subject, dora_rts_continuity_testing_and_recovery_subject(Subject), Subjects),
    length(Subjects, SubjectCount).

test(totality_every_subject_classifies) :-
    findall(Subject, dora_rts_continuity_testing_and_recovery_subject(Subject), Subjects),
    sort(Subjects, SubjectSet),
    findall(Subject, subject_classifies(Subject), ClassifiedSubjects),
    sort(ClassifiedSubjects, SubjectSet).
test(determinism_every_subject_answers_each_query_exactly_once) :-
    findall(Subject - QueryName, single_answer(Subject, QueryName, _, _), Singles),
    length(Singles, SingleCount),
    subject_count(SubjectCount),
    SingleCount =:= SubjectCount * 3.
test(determinism_every_subject_has_one_checklist) :-
    findall(Subject, one_checklist(Subject), Subjects),
    length(Subjects, CheckedCount),
    subject_count(SubjectCount),
    CheckedCount =:= SubjectCount.
test(some_subject_gives_a_status_compound_with_no_citations) :-
    single_answer(gate_absent, rts_continuity_testing_and_recovery_duties_complete, indeterminate(_), []).
test(every_citation_is_a_canonical_key) :-
    findall(Subject - QueryName, (single_answer(Subject, QueryName, _, Citations), maplist(well_formed_citation, Citations)), WellFormed),
    findall(Subject - QueryName, single_answer(Subject, QueryName, _, _), Every),
    WellFormed == Every.
test(every_required_list_is_in_duty_order_and_non_empty) :-
    findall(Subject, single_answer(Subject, rts_continuity_testing_and_recovery_duties_required, required(_), _), Listed),
    findall(Subject, (single_answer(Subject, rts_continuity_testing_and_recovery_duties_required, required([FirstDuty|LaterDuties]), _), in_duty_order([FirstDuty|LaterDuties])), Ordered),
    Listed == Ordered,
    length(Listed, ListedCount),
    ListedCount > 0.
test(a_complete_subject_has_none_outstanding) :-
    single_answer(credit_institution_all_performed, rts_continuity_testing_and_recovery_duties_complete, complete, _),
    single_answer(credit_institution_all_performed, rts_continuity_testing_and_recovery_duties_outstanding, none_outstanding, _).

test(no_subject_has_zero_or_several_answers_to_a_query, fail) :-
    dora_rts_continuity_testing_and_recovery_subject(Subject),
    query_names(QueryNames),
    member(QueryName, QueryNames),
    query_answers(Subject, QueryName, Answers),
    length(Answers, AnswerCount),
    dif(AnswerCount, 1).
test(no_status_compound_carries_citations, fail) :-
    single_answer(_, _, Result, Citations),
    status_compound(Result),
    dif(Citations, []).
test(no_complete_subject_has_outstanding_duties, fail) :-
    single_answer(Subject, rts_continuity_testing_and_recovery_duties_complete, complete, _),
    single_answer(Subject, rts_continuity_testing_and_recovery_duties_outstanding, outstanding(_), _).
test(no_incomplete_subject_has_none_outstanding, fail) :-
    single_answer(Subject, rts_continuity_testing_and_recovery_duties_complete, incomplete, _),
    single_answer(Subject, rts_continuity_testing_and_recovery_duties_outstanding, none_outstanding, _).

one_checklist(Subject) :-
    dora_rts_continuity_testing_and_recovery_subject(Subject),
    dora_rts_continuity_testing_and_recovery_profile_for(Subject, Profile),
    findall(Checklist, dora_rts_continuity_testing_and_recovery_checklist(Profile, Checklist), [_]).

cp_test_names([totality_every_subject_classifies, determinism_every_subject_answers_each_query_exactly_once, determinism_every_subject_has_one_checklist, some_subject_gives_a_status_compound_with_no_citations, every_citation_is_a_canonical_key, every_required_list_is_in_duty_order_and_non_empty, a_complete_subject_has_none_outstanding]).
cp_test_fail_names([no_subject_has_zero_or_several_answers_to_a_query, no_status_compound_carries_citations, no_complete_subject_has_outstanding_duties, no_incomplete_subject_has_none_outstanding]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
