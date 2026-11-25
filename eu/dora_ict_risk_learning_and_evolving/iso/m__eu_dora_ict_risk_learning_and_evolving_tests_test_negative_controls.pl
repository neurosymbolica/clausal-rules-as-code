% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_ict_risk_learning_and_evolving_tests_test_negative_controls, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_dora_ict_risk_learning_and_evolving_dora_ict_risk_learning_and_evolving, [ict_risk_learning_and_evolving_duties_required/3, ict_risk_learning_and_evolving_duties_outstanding/3, dora_ict_risk_learning_and_evolving_status/2, dora_ict_risk_learning_and_evolving_status_values/1]).
:- use_module(m__eu_dora_ict_risk_learning_and_evolving_fixtures, [dora_ict_risk_learning_and_evolving_profile_for/2]).

subject_status(Subject, Status) :-
    dora_ict_risk_learning_and_evolving_profile_for(Subject, Profile),
    dora_ict_risk_learning_and_evolving_status(Profile, Status).

test(the_status_table_names_the_final_atoms) :-
    dora_ict_risk_learning_and_evolving_status_values(StatusValues),
    StatusValues == [complete, incomplete, simplified_framework_entity].
test(gate_true_gives_simplified_framework_entity) :-
    subject_status(article_16_1_entity_simplified_framework, simplified_framework_entity).
test(gate_false_near_miss_is_complete) :-
    subject_status(non_microenterprise_incident_request_all_performed, complete).
test(gate_absent_asks_for_the_gate) :-
    subject_status(gate_unanswered, indeterminate([financial_entity_is_article_16_1_entity])).
test(communication_not_performed_after_request_is_incomplete) :-
    subject_status(communication_after_request_not_performed, incomplete).
test(microenterprise_near_miss_is_complete) :-
    subject_status(microenterprise_communication_not_performed, complete).
test(request_made_communication_unanswered_is_asked) :-
    subject_status(incident_with_request_communication_unanswered, indeterminate([post_incident_review_changes_communicated_to_competent_authorities])).
test(no_request_near_miss_is_complete) :-
    subject_status(incident_without_request_communication_unanswered, complete).
test(yearly_report_not_performed_is_incomplete) :-
    subject_status(microenterprise_yearly_report_not_performed, incomplete).
test(yearly_report_performed_near_miss_is_complete) :-
    subject_status(microenterprise_without_incident_all_performed, complete).
test(size_class_asked_when_technology_monitoring_not_performed) :-
    subject_status(size_class_unanswered_technology_monitoring_not_performed, indeterminate([financial_entity_is_microenterprise])).
test(monitoring_performed_near_miss_is_complete) :-
    subject_status(size_class_unanswered_all_performed, complete).
test(unsure_capabilities_judgement_is_referred) :-
    subject_status(capabilities_judgement_unsure, needs_legal_review(open_textured(capabilities_and_staff_to_gather_and_analyse_threat_and_incident_information, cite(eu_reg_2022_2554_art_13_1)), _Context)).
test(a_false_duty_near_miss_settles_incomplete) :-
    subject_status(capabilities_judgement_unsure_yearly_report_not_performed, incomplete).
test(unknown_key_is_refused) :-
    subject_status(unknown_key_given, input_problems([unknown_key(colour)])).
test(fact_key_given_unsure_is_refused) :-
    subject_status(fact_key_given_unsure, input_problems([wrong_type(financial_entity_is_microenterprise)])).
test(gate_given_twice_is_refused) :-
    subject_status(gate_key_given_twice, input_problems([duplicate_key(financial_entity_is_article_16_1_entity)])).
test(required_for_a_non_microenterprise_includes_technology_monitoring) :-
    dora_ict_risk_learning_and_evolving_profile_for(non_microenterprise_incident_request_all_performed, Profile),
    ict_risk_learning_and_evolving_duties_required(Profile, required(Duties), _),
    member(monitoring_of_technological_developments, Duties).
test(required_after_an_incident_includes_the_reviews) :-
    dora_ict_risk_learning_and_evolving_profile_for(microenterprise_communication_not_performed, Profile),
    ict_risk_learning_and_evolving_duties_required(Profile, required(Duties), _),
    member(review_of_incident_escalation, Duties).
test(outstanding_names_the_unperformed_communication) :-
    dora_ict_risk_learning_and_evolving_profile_for(communication_after_request_not_performed, Profile),
    ict_risk_learning_and_evolving_duties_outstanding(Profile, outstanding([communication_of_post_incident_changes]), _).
test(microenterprise_near_miss_has_none_outstanding) :-
    dora_ict_risk_learning_and_evolving_profile_for(microenterprise_communication_not_performed, Profile),
    ict_risk_learning_and_evolving_duties_outstanding(Profile, none_outstanding, _).

test(gate_false_near_miss_is_not_simplified_framework_entity, fail) :-
    subject_status(non_microenterprise_incident_request_all_performed, simplified_framework_entity).
test(gate_given_near_miss_asks_for_nothing, fail) :-
    subject_status(non_microenterprise_incident_request_all_performed, indeterminate(_)).
test(microenterprise_near_miss_is_not_incomplete, fail) :-
    subject_status(microenterprise_communication_not_performed, incomplete).
test(no_request_near_miss_asks_for_nothing, fail) :-
    subject_status(incident_without_request_communication_unanswered, indeterminate(_)).
test(yearly_report_performed_near_miss_is_not_incomplete, fail) :-
    subject_status(microenterprise_without_incident_all_performed, incomplete).
test(monitoring_performed_near_miss_asks_for_nothing, fail) :-
    subject_status(size_class_unanswered_all_performed, indeterminate(_)).
test(a_false_duty_near_miss_is_not_referred, fail) :-
    subject_status(capabilities_judgement_unsure_yearly_report_not_performed, needs_legal_review(_, _)).
test(the_profile_without_the_unknown_key_is_not_refused, fail) :-
    subject_status(microenterprise_without_incident_all_performed, input_problems(_)).
test(required_for_a_microenterprise_excludes_technology_monitoring, fail) :-
    dora_ict_risk_learning_and_evolving_profile_for(microenterprise_without_incident_all_performed, Profile),
    ict_risk_learning_and_evolving_duties_required(Profile, required(Duties), _),
    member(monitoring_of_technological_developments, Duties).
test(required_without_an_incident_excludes_the_reviews, fail) :-
    dora_ict_risk_learning_and_evolving_profile_for(microenterprise_without_incident_all_performed, Profile),
    ict_risk_learning_and_evolving_duties_required(Profile, required(Duties), _),
    member(review_of_incident_escalation, Duties).
test(microenterprise_near_miss_has_nothing_outstanding, fail) :-
    dora_ict_risk_learning_and_evolving_profile_for(microenterprise_communication_not_performed, Profile),
    ict_risk_learning_and_evolving_duties_outstanding(Profile, outstanding(_), _).

cp_test_names([the_status_table_names_the_final_atoms, gate_true_gives_simplified_framework_entity, gate_false_near_miss_is_complete, gate_absent_asks_for_the_gate, communication_not_performed_after_request_is_incomplete, microenterprise_near_miss_is_complete, request_made_communication_unanswered_is_asked, no_request_near_miss_is_complete, yearly_report_not_performed_is_incomplete, yearly_report_performed_near_miss_is_complete, size_class_asked_when_technology_monitoring_not_performed, monitoring_performed_near_miss_is_complete, unsure_capabilities_judgement_is_referred, a_false_duty_near_miss_settles_incomplete, unknown_key_is_refused, fact_key_given_unsure_is_refused, gate_given_twice_is_refused, required_for_a_non_microenterprise_includes_technology_monitoring, required_after_an_incident_includes_the_reviews, outstanding_names_the_unperformed_communication, microenterprise_near_miss_has_none_outstanding]).
cp_test_fail_names([gate_false_near_miss_is_not_simplified_framework_entity, gate_given_near_miss_asks_for_nothing, microenterprise_near_miss_is_not_incomplete, no_request_near_miss_asks_for_nothing, yearly_report_performed_near_miss_is_not_incomplete, monitoring_performed_near_miss_asks_for_nothing, a_false_duty_near_miss_is_not_referred, the_profile_without_the_unknown_key_is_not_refused, required_for_a_microenterprise_excludes_technology_monitoring, required_without_an_incident_excludes_the_reviews, microenterprise_near_miss_has_nothing_outstanding]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
