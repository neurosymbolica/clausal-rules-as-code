% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_ict_third_party_entity_duties_tests_test_properties, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_dora_ict_third_party_entity_duties_dora_ict_third_party_entity_duties, [decide_dora_ict_third_party_entity_duties/2, entity_duties_required/3, entity_duties_complete/3, entity_duties_outstanding/3, ict_third_party_strategy_required/3, dora_ict_third_party_entity_duties_checklist/2]).
:- use_module(m__eu_dora_ict_third_party_entity_duties_kernel, [dora_ict_third_party_entity_duties_input_problems/2]).
:- use_module(m__eu_dora_ict_third_party_entity_duties_fixtures, [dora_ict_third_party_entity_duties_subject/1, dora_ict_third_party_entity_duties_profile_for/2]).

subjects(Subjects) :-
    findall(Subject, dora_ict_third_party_entity_duties_subject(Subject), Subjects).

subject_classifies(Subject) :-
    dora_ict_third_party_entity_duties_subject(Subject),
    dora_ict_third_party_entity_duties_profile_for(Subject, Profile),
    decide_dora_ict_third_party_entity_duties(Profile, _Verdict).

one_query_answer(Query, Subject) :-
    dora_ict_third_party_entity_duties_profile_for(Subject, Profile),
    findall(Result - Citations, call(Query, Profile, Result, Citations), Answers),
    length(Answers, 1).

one_input_check_answer(Subject) :-
    dora_ict_third_party_entity_duties_profile_for(Subject, Profile),
    findall(Problems, dora_ict_third_party_entity_duties_input_problems(Profile, Problems), AllProblems),
    length(AllProblems, 1).

one_checklist(Subject) :-
    dora_ict_third_party_entity_duties_profile_for(Subject, Profile),
    findall(Items, dora_ict_third_party_entity_duties_checklist(Profile, Items), AllItems),
    length(AllItems, 1).

answer_shape(Query, Subject) :-
    dora_ict_third_party_entity_duties_profile_for(Subject, Profile),
    call(Query, Profile, Result, Citations),
    citation_shape(Result, Citations).

citation_shape(indeterminate([Key]), []) :-
    atom(Key).
citation_shape(needs_legal_review(open_textured(Key, cite(_)), [inputs_relied_on(_)]), []) :-
    atom(Key).
citation_shape(input_problems([_|_]), []).
citation_shape(required([_|_]), [_|_]).
citation_shape(complete, [_, _, _, _, _, _]).
citation_shape(incomplete, [_, _, _, _, _, _]).
citation_shape(none_outstanding, [_, _, _, _, _, _]).
citation_shape(outstanding([_|_]), [_|_]).
citation_shape(strategy_required, [cite(eu_reg_2022_2554_art_28_2)]).
citation_shape(strategy_not_required, [cite(eu_reg_2022_2554_art_28_2)]).

all_duties([assessment_of_critical_or_important_function, assessment_of_supervisory_conditions, risk_identification_and_assessment, due_diligence_on_provider, conflicts_of_interest_assessment, provider_with_appropriate_information_security_standards, consideration_of_most_up_to_date_information_security_standards, predetermined_audit_frequency_and_areas, verification_of_auditor_skills, exit_strategy, exit_without_business_disruption, exit_without_limiting_regulatory_compliance, exit_without_detriment_to_client_services, tested_and_reviewed_exit_plans, alternative_solutions_and_transition_plans, contingency_measures, concentration_risk_consideration, weighing_of_alternative_solutions, weighing_of_subcontracting_benefits_and_risks, consideration_of_insolvency_law_and_data_recovery, consideration_of_third_country_data_protection_and_enforcement, assessment_of_subcontracting_chains]).

subsequence([], _).
subsequence([Element|Elements], [Element|Others]) :-
    subsequence(Elements, Others).
subsequence([Element|Elements], [Other|Others]) :-
    dif(Element, Other),
    subsequence([Element|Elements], Others).

in_duty_order(Duties) :-
    all_duties(All),
    subsequence(Duties, All).

duty_list_ordered(Query, Subject) :-
    dora_ict_third_party_entity_duties_profile_for(Subject, Profile),
    call(Query, Profile, Result, _),
    result_duties_ordered(Result).

result_duties_ordered(required(Duties)) :-
    in_duty_order(Duties).
result_duties_ordered(outstanding(Duties)) :-
    in_duty_order(Duties).
result_duties_ordered(none_outstanding).
result_duties_ordered(indeterminate(_)).
result_duties_ordered(needs_legal_review(_, _)).
result_duties_ordered(input_problems(_)).

complete_and_outstanding_agree(Subject) :-
    dora_ict_third_party_entity_duties_profile_for(Subject, Profile),
    entity_duties_complete(Profile, CompleteResult, _),
    entity_duties_outstanding(Profile, OutstandingResult, _),
    agree(CompleteResult, OutstandingResult).

agree(complete, none_outstanding).
agree(incomplete, outstanding([_|_])).
agree(incomplete, indeterminate([_])).
agree(indeterminate([_]), indeterminate([_])).
agree(needs_legal_review(_, _), indeterminate([_])).
agree(needs_legal_review(_, _), needs_legal_review(_, _)).
agree(input_problems(Problems), input_problems(Problems)).

test(totality_every_subject_classifies) :-
    subjects(Subjects),
    sort(Subjects, SubjectSet),
    findall(Subject, subject_classifies(Subject), ClassifiedSubjects),
    sort(ClassifiedSubjects, SubjectSet).
test(determinism_entity_duties_required) :-
    subjects(Subjects),
    maplist(one_query_answer(entity_duties_required), Subjects).
test(determinism_entity_duties_complete) :-
    subjects(Subjects),
    maplist(one_query_answer(entity_duties_complete), Subjects).
test(determinism_entity_duties_outstanding) :-
    subjects(Subjects),
    maplist(one_query_answer(entity_duties_outstanding), Subjects).
test(determinism_ict_third_party_strategy_required) :-
    subjects(Subjects),
    maplist(one_query_answer(ict_third_party_strategy_required), Subjects).
test(determinism_input_check) :-
    subjects(Subjects),
    maplist(one_input_check_answer, Subjects).
test(determinism_checklist) :-
    subjects(Subjects),
    maplist(one_checklist, Subjects).
test(citation_shape_entity_duties_required) :-
    subjects(Subjects),
    maplist(answer_shape(entity_duties_required), Subjects).
test(citation_shape_entity_duties_complete) :-
    subjects(Subjects),
    maplist(answer_shape(entity_duties_complete), Subjects).
test(citation_shape_entity_duties_outstanding) :-
    subjects(Subjects),
    maplist(answer_shape(entity_duties_outstanding), Subjects).
test(citation_shape_ict_third_party_strategy_required) :-
    subjects(Subjects),
    maplist(answer_shape(ict_third_party_strategy_required), Subjects).
test(required_lists_are_in_duty_order) :-
    subjects(Subjects),
    maplist(duty_list_ordered(entity_duties_required), Subjects).
test(outstanding_lists_are_in_duty_order) :-
    subjects(Subjects),
    maplist(duty_list_ordered(entity_duties_outstanding), Subjects).
test(complete_and_outstanding_agree_on_every_subject) :-
    subjects(Subjects),
    maplist(complete_and_outstanding_agree, Subjects).
test(a_list_in_duty_order_is_accepted) :-
    in_duty_order([assessment_of_critical_or_important_function, exit_strategy]).

test(a_list_out_of_duty_order_is_rejected, fail) :-
    in_duty_order([exit_strategy, assessment_of_critical_or_important_function]).

cp_test_names([totality_every_subject_classifies, determinism_entity_duties_required, determinism_entity_duties_complete, determinism_entity_duties_outstanding, determinism_ict_third_party_strategy_required, determinism_input_check, determinism_checklist, citation_shape_entity_duties_required, citation_shape_entity_duties_complete, citation_shape_entity_duties_outstanding, citation_shape_ict_third_party_strategy_required, required_lists_are_in_duty_order, outstanding_lists_are_in_duty_order, complete_and_outstanding_agree_on_every_subject, a_list_in_duty_order_is_accepted]).
cp_test_fail_names([a_list_out_of_duty_order_is_rejected]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
