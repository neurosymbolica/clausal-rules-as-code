% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_ict_risk_learning_and_evolving_tests_test_input_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_lists_extra, [clausal_msort/2]).
:- use_module(m__eu_dora_ict_risk_learning_and_evolving_dora_ict_risk_learning_and_evolving, [ict_risk_learning_and_evolving_duties_required/3, ict_risk_learning_and_evolving_duties_complete/3, ict_risk_learning_and_evolving_duties_outstanding/3, dora_ict_risk_learning_and_evolving_status/2, dora_ict_risk_learning_and_evolving_status_values/1]).
:- use_module(m__eu_dora_ict_risk_learning_and_evolving_kernel, [dora_ict_risk_learning_and_evolving_input_problems/2]).
:- use_module(m__eu_dora_ict_risk_learning_and_evolving_fixtures, [dora_ict_risk_learning_and_evolving_profile_for/2]).

full_duty_order([threat_and_incident_information_capability, post_incident_reviews, communication_of_post_incident_changes, review_of_procedures_and_actions, review_of_response_promptness, review_of_forensic_analysis, review_of_incident_escalation, review_of_internal_and_external_communication, lessons_incorporated_into_ict_risk_assessment, findings_basis_for_framework_reviews, monitoring_of_resilience_strategy_effectiveness, mapping_of_ict_risk_evolution, analysis_of_ict_related_incidents, enhancement_of_cyber_maturity, yearly_report_to_management_body, compulsory_awareness_and_training_modules, training_for_all_staff_commensurate_to_remit, third_party_providers_in_training, monitoring_of_technological_developments, up_to_date_ict_risk_management_processes]).

seven_paragraphs([cite(eu_reg_2022_2554_art_13_1), cite(eu_reg_2022_2554_art_13_2), cite(eu_reg_2022_2554_art_13_3), cite(eu_reg_2022_2554_art_13_4), cite(eu_reg_2022_2554_art_13_5), cite(eu_reg_2022_2554_art_13_6), cite(eu_reg_2022_2554_art_13_7)]).

test(complete_holds_with_the_verdict_bound) :-
    dora_ict_risk_learning_and_evolving_profile_for(non_microenterprise_incident_request_all_performed, Profile),
    dora_ict_risk_learning_and_evolving_status(Profile, complete).
test(incomplete_holds_with_the_verdict_bound) :-
    dora_ict_risk_learning_and_evolving_profile_for(communication_after_request_not_performed, Profile),
    dora_ict_risk_learning_and_evolving_status(Profile, incomplete).
test(simplified_framework_entity_holds_with_the_verdict_bound) :-
    dora_ict_risk_learning_and_evolving_profile_for(article_16_1_entity_simplified_framework, Profile),
    dora_ict_risk_learning_and_evolving_status(Profile, simplified_framework_entity).
test(gate_answer_bound_with_its_citation) :-
    dora_ict_risk_learning_and_evolving_profile_for(article_16_1_entity_simplified_framework, Profile),
    ict_risk_learning_and_evolving_duties_outstanding(Profile, simplified_framework_entity, [cite(eu_reg_2022_2554_art_16_1)]).
test(required_full_list_bound) :-
    dora_ict_risk_learning_and_evolving_profile_for(non_microenterprise_incident_request_all_performed, Profile),
    full_duty_order(FullDuties),
    ict_risk_learning_and_evolving_duties_required(Profile, required(FullDuties), Citations),
    clausal_msort(Citations, SortedCitations),
    seven_paragraphs(SortedCitations).
test(outstanding_bound_with_its_citation) :-
    dora_ict_risk_learning_and_evolving_profile_for(communication_after_request_not_performed, Profile),
    ict_risk_learning_and_evolving_duties_outstanding(Profile, outstanding([communication_of_post_incident_changes]), [cite(eu_reg_2022_2554_art_13_2)]).
test(incomplete_bound_with_the_fixed_citations) :-
    dora_ict_risk_learning_and_evolving_profile_for(microenterprise_yearly_report_not_performed, Profile),
    ict_risk_learning_and_evolving_duties_complete(Profile, incomplete, Citations),
    clausal_msort(Citations, SortedCitations),
    seven_paragraphs(SortedCitations).
test(a_well_formed_profile_has_no_problem) :-
    dora_ict_risk_learning_and_evolving_profile_for(communication_after_request_not_performed, Profile),
    dora_ict_risk_learning_and_evolving_input_problems(Profile, []).
test(an_empty_profile_has_no_problem) :-
    dora_ict_risk_learning_and_evolving_input_problems([], []).
test(an_unknown_key_is_named) :-
    dora_ict_risk_learning_and_evolving_profile_for(unknown_key_given, Profile),
    dora_ict_risk_learning_and_evolving_input_problems(Profile, [unknown_key(colour)]).
test(a_term_that_is_not_a_list_is_not_a_profile) :-
    dora_ict_risk_learning_and_evolving_input_problems(not_an_attribute_list, [wrong_type(profile)]).
test(an_unbound_profile_is_not_a_profile) :-
    dora_ict_risk_learning_and_evolving_input_problems(_UnboundProfile, [wrong_type(profile)]).
test(a_partial_list_is_not_a_profile) :-
    dora_ict_risk_learning_and_evolving_input_problems([attribute(financial_entity_is_article_16_1_entity, false)|_Rest], [wrong_type(profile)]).
test(a_list_with_a_foreign_element_is_not_a_profile) :-
    dora_ict_risk_learning_and_evolving_input_problems([attribute(financial_entity_is_article_16_1_entity, false), stray], [wrong_type(profile)]).
test(an_unbound_value_is_wrong_type) :-
    dora_ict_risk_learning_and_evolving_input_problems([attribute(financial_entity_is_microenterprise, _UnboundValue)], [wrong_type(financial_entity_is_microenterprise)]).
test(a_number_value_is_wrong_type) :-
    dora_ict_risk_learning_and_evolving_input_problems([attribute(capabilities_and_staff_to_gather_and_analyse_threat_and_incident_information, 1)], [wrong_type(capabilities_and_staff_to_gather_and_analyse_threat_and_incident_information)]).
test(unsure_is_wrong_type_for_a_fact_key) :-
    dora_ict_risk_learning_and_evolving_input_problems([attribute(major_ict_related_incident_disrupted_core_activities, unsure)], [wrong_type(major_ict_related_incident_disrupted_core_activities)]).
test(unsure_is_in_type_for_a_judgement_key) :-
    dora_ict_risk_learning_and_evolving_input_problems([attribute(evolution_of_ict_risk_mapped_over_time, unsure)], []).
test(a_number_key_is_unknown) :-
    dora_ict_risk_learning_and_evolving_input_problems([attribute(7, true)], [unknown_key(7)]).
test(an_unbound_key_is_unknown_as_given) :-
    dora_ict_risk_learning_and_evolving_input_problems([attribute(GivenKey, true)], [unknown_key(NamedKey)]),
    NamedKey == GivenKey.
test(a_repeated_key_with_equal_values_is_a_duplicate) :-
    dora_ict_risk_learning_and_evolving_input_problems([attribute(financial_entity_is_microenterprise, true), attribute(financial_entity_is_microenterprise, true)], [duplicate_key(financial_entity_is_microenterprise)]).
test(a_duplicate_is_never_also_wrong_type) :-
    dora_ict_risk_learning_and_evolving_input_problems([attribute(financial_entity_is_microenterprise, maybe), attribute(financial_entity_is_microenterprise, true)], [duplicate_key(financial_entity_is_microenterprise)]).
test(problems_follow_contract_order_then_unknown_keys) :-
    dora_ict_risk_learning_and_evolving_input_problems([attribute(colour, red), attribute(capabilities_and_staff_to_gather_and_analyse_threat_and_incident_information, maybe), attribute(financial_entity_is_microenterprise, unsure), attribute(colour, blue)], Problems),
    Problems == [wrong_type(financial_entity_is_microenterprise), wrong_type(capabilities_and_staff_to_gather_and_analyse_threat_and_incident_information), unknown_key(colour)].
test(every_query_refuses_a_malformed_profile_first) :-
    ict_risk_learning_and_evolving_duties_required(not_an_attribute_list, RequiredResult, RequiredCitations),
    RequiredResult == input_problems([wrong_type(profile)]),
    RequiredCitations == [],
    ict_risk_learning_and_evolving_duties_complete(not_an_attribute_list, CompleteResult, []),
    CompleteResult == input_problems([wrong_type(profile)]),
    ict_risk_learning_and_evolving_duties_outstanding(not_an_attribute_list, OutstandingResult, []),
    OutstandingResult == input_problems([wrong_type(profile)]).
test(a_present_duty_key_is_checked_even_by_the_required_query) :-
    ict_risk_learning_and_evolving_duties_required([attribute(financial_entity_is_article_16_1_entity, false), attribute(cyber_maturity_and_preparedness_enhanced, yes)], Result, []),
    Result == input_problems([wrong_type(cyber_maturity_and_preparedness_enhanced)]).

test(complete_subject_rejects_every_other_table_status, fail) :-
    dora_ict_risk_learning_and_evolving_profile_for(non_microenterprise_incident_request_all_performed, Profile),
    dora_ict_risk_learning_and_evolving_status_values(StatusValues),
    member(OtherStatus, StatusValues),
    dif(OtherStatus, complete),
    dora_ict_risk_learning_and_evolving_status(Profile, OtherStatus).
test(incomplete_subject_rejects_complete_bound, fail) :-
    dora_ict_risk_learning_and_evolving_profile_for(communication_after_request_not_performed, Profile),
    dora_ict_risk_learning_and_evolving_status(Profile, complete).
test(simplified_framework_entity_rejects_complete_bound, fail) :-
    dora_ict_risk_learning_and_evolving_profile_for(article_16_1_entity_simplified_framework, Profile),
    dora_ict_risk_learning_and_evolving_status(Profile, complete).
test(required_list_in_another_order_is_rejected, fail) :-
    dora_ict_risk_learning_and_evolving_profile_for(non_microenterprise_incident_request_all_performed, Profile),
    full_duty_order([FirstDuty, SecondDuty|OtherDuties]),
    ict_risk_learning_and_evolving_duties_required(Profile, required([SecondDuty, FirstDuty|OtherDuties]), _).

cp_test_names([complete_holds_with_the_verdict_bound, incomplete_holds_with_the_verdict_bound, simplified_framework_entity_holds_with_the_verdict_bound, gate_answer_bound_with_its_citation, required_full_list_bound, outstanding_bound_with_its_citation, incomplete_bound_with_the_fixed_citations, a_well_formed_profile_has_no_problem, an_empty_profile_has_no_problem, an_unknown_key_is_named, a_term_that_is_not_a_list_is_not_a_profile, an_unbound_profile_is_not_a_profile, a_partial_list_is_not_a_profile, a_list_with_a_foreign_element_is_not_a_profile, an_unbound_value_is_wrong_type, a_number_value_is_wrong_type, unsure_is_wrong_type_for_a_fact_key, unsure_is_in_type_for_a_judgement_key, a_number_key_is_unknown, an_unbound_key_is_unknown_as_given, a_repeated_key_with_equal_values_is_a_duplicate, a_duplicate_is_never_also_wrong_type, problems_follow_contract_order_then_unknown_keys, every_query_refuses_a_malformed_profile_first, a_present_duty_key_is_checked_even_by_the_required_query]).
cp_test_fail_names([complete_subject_rejects_every_other_table_status, incomplete_subject_rejects_complete_bound, simplified_framework_entity_rejects_complete_bound, required_list_in_another_order_is_rejected]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
