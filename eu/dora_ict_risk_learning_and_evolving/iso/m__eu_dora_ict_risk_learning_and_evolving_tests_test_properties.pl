% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_ict_risk_learning_and_evolving_tests_test_properties, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_lists_extra, [subtract/3, clausal_msort/2]).
:- use_module(m__eu_dora_ict_risk_learning_and_evolving_dora_ict_risk_learning_and_evolving, [ict_risk_learning_and_evolving_duties_required/3, ict_risk_learning_and_evolving_duties_complete/3, ict_risk_learning_and_evolving_duties_outstanding/3, decide_dora_ict_risk_learning_and_evolving/2]).
:- use_module(m__eu_dora_ict_risk_learning_and_evolving_kernel, [dora_ict_risk_learning_and_evolving_input_problems/2]).
:- use_module(m__eu_dora_ict_risk_learning_and_evolving_fixtures, [dora_ict_risk_learning_and_evolving_subject/1, dora_ict_risk_learning_and_evolving_profile_for/2]).

subject_classifies(Subject) :-
    dora_ict_risk_learning_and_evolving_subject(Subject),
    dora_ict_risk_learning_and_evolving_profile_for(Subject, Profile),
    decide_dora_ict_risk_learning_and_evolving(Profile, _Verdict).

test(totality_every_subject_classifies) :-
    findall(Subject, dora_ict_risk_learning_and_evolving_subject(Subject), Subjects),
    sort(Subjects, SubjectSet),
    findall(Subject, subject_classifies(Subject), ClassifiedSubjects),
    sort(ClassifiedSubjects, SubjectSet).
test(determinism_every_query_answers_every_subject_exactly_once) :-
    findall(Subject, dora_ict_risk_learning_and_evolving_subject(Subject), Subjects),
    maplist(answers_once, Subjects).
test(every_answer_has_citations_of_its_shape) :-
    findall(Subject, dora_ict_risk_learning_and_evolving_subject(Subject), Subjects),
    maplist(query_citations_fit, Subjects).
test(completeness_and_outstanding_agree_on_every_subject) :-
    findall(Subject, dora_ict_risk_learning_and_evolving_subject(Subject), Subjects),
    maplist(queries_agree, Subjects).
test(complete_and_incomplete_cite_the_same_seven_paragraphs_for_every_entity) :-
    maplist(complete_cites_seven_paragraphs, [non_microenterprise_incident_request_all_performed, microenterprise_without_incident_all_performed, size_class_unanswered_all_performed, communication_after_request_not_performed, microenterprise_yearly_report_not_performed]).
test(outstanding_duties_are_duties_that_apply) :-
    maplist(outstanding_within_required, [communication_after_request_not_performed, microenterprise_yearly_report_not_performed]).
test(required_lists_are_in_duty_order) :-
    maplist(required_in_duty_order, [non_microenterprise_incident_request_all_performed, communication_after_request_not_performed, microenterprise_communication_not_performed, incident_without_request_communication_unanswered, incident_with_request_communication_unanswered, microenterprise_without_incident_all_performed, microenterprise_yearly_report_not_performed, capabilities_judgement_unsure]).

answers_once(Subject) :-
    dora_ict_risk_learning_and_evolving_profile_for(Subject, Profile),
    findall(RequiredResult - RequiredCitations, ict_risk_learning_and_evolving_duties_required(Profile, RequiredResult, RequiredCitations), [_]),
    findall(CompleteResult - CompleteCitations, ict_risk_learning_and_evolving_duties_complete(Profile, CompleteResult, CompleteCitations), [_]),
    findall(OutstandingResult - OutstandingCitations, ict_risk_learning_and_evolving_duties_outstanding(Profile, OutstandingResult, OutstandingCitations), [_]),
    findall(Problems, dora_ict_risk_learning_and_evolving_input_problems(Profile, Problems), [_]).

citations_fit(required(_), [_|_]).
citations_fit(complete, [_|_]).
citations_fit(incomplete, [_|_]).
citations_fit(none_outstanding, [_|_]).
citations_fit(outstanding(_), [_|_]).
citations_fit(simplified_framework_entity, [cite(eu_reg_2022_2554_art_16_1)]).
citations_fit(indeterminate([_]), []).
citations_fit(needs_legal_review(_, _), []).
citations_fit(input_problems(_), []).

query_citations_fit(Subject) :-
    dora_ict_risk_learning_and_evolving_profile_for(Subject, Profile),
    ict_risk_learning_and_evolving_duties_required(Profile, RequiredResult, RequiredCitations),
    citations_fit(RequiredResult, RequiredCitations),
    ict_risk_learning_and_evolving_duties_complete(Profile, CompleteResult, CompleteCitations),
    citations_fit(CompleteResult, CompleteCitations),
    ict_risk_learning_and_evolving_duties_outstanding(Profile, OutstandingResult, OutstandingCitations),
    citations_fit(OutstandingResult, OutstandingCitations).

consistent_pair(complete, none_outstanding).
consistent_pair(incomplete, outstanding(_)).
consistent_pair(incomplete, needs_legal_review(_, _)).
consistent_pair(incomplete, indeterminate(_)).
consistent_pair(simplified_framework_entity, simplified_framework_entity).
consistent_pair(input_problems(Problems), input_problems(Problems)).
consistent_pair(indeterminate(_), indeterminate(_)).
consistent_pair(needs_legal_review(_, _), needs_legal_review(_, _)).
consistent_pair(needs_legal_review(_, _), indeterminate(_)).

queries_agree(Subject) :-
    dora_ict_risk_learning_and_evolving_profile_for(Subject, Profile),
    ict_risk_learning_and_evolving_duties_complete(Profile, CompleteResult, _),
    ict_risk_learning_and_evolving_duties_outstanding(Profile, OutstandingResult, _),
    consistent_pair(CompleteResult, OutstandingResult).

seven_paragraphs([cite(eu_reg_2022_2554_art_13_1), cite(eu_reg_2022_2554_art_13_2), cite(eu_reg_2022_2554_art_13_3), cite(eu_reg_2022_2554_art_13_4), cite(eu_reg_2022_2554_art_13_5), cite(eu_reg_2022_2554_art_13_6), cite(eu_reg_2022_2554_art_13_7)]).

complete_cites_seven_paragraphs(Subject) :-
    dora_ict_risk_learning_and_evolving_profile_for(Subject, Profile),
    ict_risk_learning_and_evolving_duties_complete(Profile, _Result, Citations),
    clausal_msort(Citations, SortedCitations),
    seven_paragraphs(SortedCitations).

outstanding_within_required(Subject) :-
    dora_ict_risk_learning_and_evolving_profile_for(Subject, Profile),
    ict_risk_learning_and_evolving_duties_required(Profile, required(RequiredDuties), _),
    ict_risk_learning_and_evolving_duties_outstanding(Profile, outstanding(OutstandingDuties), _),
    subtract(OutstandingDuties, RequiredDuties, []).

duty_order([threat_and_incident_information_capability, post_incident_reviews, communication_of_post_incident_changes, review_of_procedures_and_actions, review_of_response_promptness, review_of_forensic_analysis, review_of_incident_escalation, review_of_internal_and_external_communication, lessons_incorporated_into_ict_risk_assessment, findings_basis_for_framework_reviews, monitoring_of_resilience_strategy_effectiveness, mapping_of_ict_risk_evolution, analysis_of_ict_related_incidents, enhancement_of_cyber_maturity, yearly_report_to_management_body, compulsory_awareness_and_training_modules, training_for_all_staff_commensurate_to_remit, third_party_providers_in_training, monitoring_of_technological_developments, up_to_date_ict_risk_management_processes]).

in_duty_order([], _).
in_duty_order([Duty|Duties], Order) :-
    append(_Before, [Duty|After], Order),
    in_duty_order(Duties, After).

required_in_duty_order(Subject) :-
    dora_ict_risk_learning_and_evolving_profile_for(Subject, Profile),
    ict_risk_learning_and_evolving_duties_required(Profile, required(Duties), _),
    duty_order(Order),
    in_duty_order(Duties, Order).

cp_test_names([totality_every_subject_classifies, determinism_every_query_answers_every_subject_exactly_once, every_answer_has_citations_of_its_shape, completeness_and_outstanding_agree_on_every_subject, complete_and_incomplete_cite_the_same_seven_paragraphs_for_every_entity, outstanding_duties_are_duties_that_apply, required_lists_are_in_duty_order]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
