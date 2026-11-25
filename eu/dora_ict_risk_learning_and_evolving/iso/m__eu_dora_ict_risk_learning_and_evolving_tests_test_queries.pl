% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_ict_risk_learning_and_evolving_tests_test_queries, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(library(pairs), [pairs_values/2]).
:- use_module(m__eu_dora_ict_risk_learning_and_evolving_queries, [dora_ict_risk_learning_and_evolving_profile_keys/1, dora_ict_risk_learning_and_evolving_what_if/4, dora_ict_risk_learning_and_evolving_compliance_check/3]).
:- use_module(m__eu_dora_ict_risk_learning_and_evolving_kernel, [dora_ict_risk_learning_and_evolving_input_problems/2]).
:- use_module(m__eu_dora_ict_risk_learning_and_evolving_fixtures, [dora_ict_risk_learning_and_evolving_profile_for/2]).

test(profile_keys_are_the_contract_keys) :-
    dora_ict_risk_learning_and_evolving_profile_keys(ProfileKeys),
    ProfileKeys == [financial_entity_is_article_16_1_entity, financial_entity_is_microenterprise, major_ict_related_incident_disrupted_core_activities, competent_authority_requested_post_incident_review_changes, capabilities_and_staff_to_gather_and_analyse_threat_and_incident_information, post_ict_related_incident_reviews_put_in_place, post_incident_review_changes_communicated_to_competent_authorities, post_incident_reviews_determine_procedures_followed_and_actions_effective, post_incident_reviews_cover_promptness_of_response_and_impact_determination, post_incident_reviews_cover_quality_and_speed_of_forensic_analysis, post_incident_reviews_cover_effectiveness_of_incident_escalation, post_incident_reviews_cover_effectiveness_of_internal_and_external_communication, lessons_incorporated_into_ict_risk_assessment_process, findings_form_basis_for_reviews_of_ict_risk_management_framework, effectiveness_of_resilience_strategy_implementation_monitored, evolution_of_ict_risk_mapped_over_time, frequency_types_magnitude_and_evolution_of_incidents_analysed, cyber_maturity_and_preparedness_enhanced, senior_ict_staff_report_findings_and_recommendations_at_least_yearly, awareness_programmes_and_resilience_training_compulsory_in_staff_training, programmes_and_training_apply_to_all_staff_at_commensurate_complexity, ict_third_party_service_providers_included_in_training_where_appropriate, relevant_technological_developments_monitored_continuously, kept_up_to_date_with_latest_ict_risk_management_processes].
test(the_reexported_input_check_accepts_a_fixture) :-
    dora_ict_risk_learning_and_evolving_profile_for(communication_after_request_not_performed, Profile),
    dora_ict_risk_learning_and_evolving_input_problems(Profile, []).
test(what_if_performing_the_communication_completes_the_duties) :-
    dora_ict_risk_learning_and_evolving_profile_for(communication_after_request_not_performed, Profile),
    dora_ict_risk_learning_and_evolving_what_if(Profile, post_incident_review_changes_communicated_to_competent_authorities, true, Status),
    Status == complete.
test(what_if_withdrawing_the_request_completes_the_duties) :-
    dora_ict_risk_learning_and_evolving_profile_for(communication_after_request_not_performed, Profile),
    dora_ict_risk_learning_and_evolving_what_if(Profile, competent_authority_requested_post_incident_review_changes, false, Status),
    Status == complete.
test(what_if_the_entity_is_an_article_16_1_entity) :-
    dora_ict_risk_learning_and_evolving_profile_for(non_microenterprise_incident_request_all_performed, Profile),
    dora_ict_risk_learning_and_evolving_what_if(Profile, financial_entity_is_article_16_1_entity, true, Status),
    Status == simplified_framework_entity.
test(what_if_resolves_a_duplicated_gate) :-
    dora_ict_risk_learning_and_evolving_profile_for(gate_key_given_twice, Profile),
    dora_ict_risk_learning_and_evolving_what_if(Profile, financial_entity_is_article_16_1_entity, false, Status),
    Status == complete.
test(what_if_yields_exactly_one_status) :-
    dora_ict_risk_learning_and_evolving_profile_for(size_class_unanswered_technology_monitoring_not_performed, Profile),
    findall(Status, dora_ict_risk_learning_and_evolving_what_if(Profile, financial_entity_is_microenterprise, false, Status), Statuses),
    Statuses == [incomplete].
test(what_if_with_a_bad_value_is_refused) :-
    dora_ict_risk_learning_and_evolving_profile_for(non_microenterprise_incident_request_all_performed, Profile),
    dora_ict_risk_learning_and_evolving_what_if(Profile, financial_entity_is_microenterprise, unsure, Status),
    Status == input_problems([wrong_type(financial_entity_is_microenterprise)]).
test(what_if_keeps_a_malformed_profile_refused) :-
    dora_ict_risk_learning_and_evolving_what_if(not_an_attribute_list, financial_entity_is_article_16_1_entity, false, Status),
    Status == input_problems([wrong_type(profile)]).
test(compliance_check_covers_every_duty_once) :-
    dora_ict_risk_learning_and_evolving_profile_for(non_microenterprise_incident_request_all_performed, Profile),
    findall(DutyAtom - Verdict, dora_ict_risk_learning_and_evolving_compliance_check(Profile, DutyAtom, Verdict), DutyVerdicts),
    length(DutyVerdicts, 20),
    pairs_values(DutyVerdicts, Verdicts),
    sort(Verdicts, VerdictSet),
    VerdictSet == [compliant].
test(compliance_check_non_compliant) :-
    dora_ict_risk_learning_and_evolving_profile_for(communication_after_request_not_performed, Profile),
    findall(Verdict, dora_ict_risk_learning_and_evolving_compliance_check(Profile, communication_of_post_incident_changes, Verdict), Verdicts),
    Verdicts == [non_compliant].
test(compliance_check_not_applicable_for_a_microenterprise) :-
    dora_ict_risk_learning_and_evolving_profile_for(microenterprise_communication_not_performed, Profile),
    dora_ict_risk_learning_and_evolving_compliance_check(Profile, communication_of_post_incident_changes, Verdict),
    Verdict == not_applicable.
test(compliance_check_simplified_framework_entity) :-
    dora_ict_risk_learning_and_evolving_profile_for(article_16_1_entity_simplified_framework, Profile),
    dora_ict_risk_learning_and_evolving_compliance_check(Profile, yearly_report_to_management_body, Verdict),
    Verdict == simplified_framework_entity.
test(compliance_check_asks_for_the_gate) :-
    dora_ict_risk_learning_and_evolving_profile_for(gate_unanswered, Profile),
    dora_ict_risk_learning_and_evolving_compliance_check(Profile, yearly_report_to_management_body, Verdict),
    Verdict == indeterminate([financial_entity_is_article_16_1_entity]).
test(compliance_check_asks_for_an_absent_duty_key) :-
    dora_ict_risk_learning_and_evolving_profile_for(incident_with_request_communication_unanswered, Profile),
    dora_ict_risk_learning_and_evolving_compliance_check(Profile, communication_of_post_incident_changes, Verdict),
    Verdict == indeterminate([post_incident_review_changes_communicated_to_competent_authorities]).
test(compliance_check_asks_for_an_open_condition) :-
    dora_ict_risk_learning_and_evolving_profile_for(size_class_unanswered_technology_monitoring_not_performed, Profile),
    dora_ict_risk_learning_and_evolving_compliance_check(Profile, monitoring_of_technological_developments, Verdict),
    Verdict == indeterminate([financial_entity_is_microenterprise]).
test(compliance_check_refers_an_unsure_judgement) :-
    dora_ict_risk_learning_and_evolving_profile_for(capabilities_judgement_unsure, Profile),
    dora_ict_risk_learning_and_evolving_compliance_check(Profile, threat_and_incident_information_capability, needs_legal_review(Reason, [inputs_relied_on(Pairs)])),
    Reason == open_textured(capabilities_and_staff_to_gather_and_analyse_threat_and_incident_information, cite(eu_reg_2022_2554_art_13_1)),
    length(Pairs, 23).
test(compliance_check_refuses_a_malformed_profile) :-
    dora_ict_risk_learning_and_evolving_profile_for(unknown_key_given, Profile),
    dora_ict_risk_learning_and_evolving_compliance_check(Profile, yearly_report_to_management_body, Verdict),
    Verdict == input_problems([unknown_key(colour)]).

test(compliance_check_knows_no_other_duty, fail) :-
    dora_ict_risk_learning_and_evolving_profile_for(non_microenterprise_incident_request_all_performed, Profile),
    dora_ict_risk_learning_and_evolving_compliance_check(Profile, invented_duty, _).

cp_test_names([profile_keys_are_the_contract_keys, the_reexported_input_check_accepts_a_fixture, what_if_performing_the_communication_completes_the_duties, what_if_withdrawing_the_request_completes_the_duties, what_if_the_entity_is_an_article_16_1_entity, what_if_resolves_a_duplicated_gate, what_if_yields_exactly_one_status, what_if_with_a_bad_value_is_refused, what_if_keeps_a_malformed_profile_refused, compliance_check_covers_every_duty_once, compliance_check_non_compliant, compliance_check_not_applicable_for_a_microenterprise, compliance_check_simplified_framework_entity, compliance_check_asks_for_the_gate, compliance_check_asks_for_an_absent_duty_key, compliance_check_asks_for_an_open_condition, compliance_check_refers_an_unsure_judgement, compliance_check_refuses_a_malformed_profile]).
cp_test_fail_names([compliance_check_knows_no_other_duty]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
