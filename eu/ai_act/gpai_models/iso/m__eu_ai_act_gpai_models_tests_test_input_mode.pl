% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_ai_act_gpai_models_tests_test_input_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_ai_act_gpai_models_gpai_models, [systemic_risk_classification_status/4, systemic_risk_notification_status/5, provider_obligation_status/5, documentation_elements/3, gpai_models_status/2]).
:- use_module(m__eu_ai_act_gpai_models_kernel, [gpai_models_input_problems/2]).
:- use_module(m__eu_ai_act_gpai_models_fixtures, [gpai_models_profile_for/2]).

test(classification_holds_with_systemic_risk_bound) :-
    gpai_models_profile_for(classification_above_threshold, systemic_risk_classification(Profile, AssessmentDate)),
    systemic_risk_classification_status(Profile, AssessmentDate, general_purpose_ai_model_with_systemic_risk, [_|_]).
test(classification_holds_without_systemic_risk_bound_at_threshold) :-
    gpai_models_profile_for(classification_at_threshold, systemic_risk_classification(Profile, AssessmentDate)),
    systemic_risk_classification_status(Profile, AssessmentDate, general_purpose_ai_model_without_systemic_risk, [_|_]).
test(notification_holds_within_bound_on_the_two_week_day) :-
    gpai_models_profile_for(notification_on_two_week_day, systemic_risk_notification(Profile, TriggerDate, NotificationDate)),
    systemic_risk_notification_status(Profile, TriggerDate, NotificationDate, notification_within_the_time_limit, [cite(eu_reg_2024_1689_art_52_1), cite(eu_reg_2024_1689_art_111_3), cite(eu_reg_2024_1689_art_113_b)]).
test(obligation_does_not_apply_bound_for_open_source_documentation) :-
    gpai_models_profile_for(obligation_open_source_technical_documentation, provider_obligation(Profile, Obligation, AssessmentDate)),
    provider_obligation_status(Profile, Obligation, AssessmentDate, obligation_does_not_apply, [cite(eu_reg_2024_1689_art_53_1), cite(eu_reg_2024_1689_art_53_1_a), cite(eu_reg_2024_1689_art_53_2)]).
test(facade_status_bound_compliance_by_2_august_2027) :-
    gpai_models_profile_for(obligation_legacy_day_before_transition_end, Request),
    gpai_models_status(Request, compliance_required_by_2_august_2027).
test(documentation_bound_list_in_annex_order) :-
    documentation_elements(additional_technical_documentation_for_models_with_systemic_risk, [evaluation_strategies_and_results, adversarial_testing_and_model_adaptation_measures, system_architecture], [_|_]).
test(an_empty_profile_has_no_problem) :-
    findall(Problems, gpai_models_input_problems([], Problems), Answers),
    Answers == [[]].
test(an_unbound_profile_is_not_an_attribute_list) :-
    findall(Problems, gpai_models_input_problems(_UnboundProfile, Problems), Answers),
    Answers == [[wrong_type(profile)]].
test(a_partial_list_is_not_an_attribute_list) :-
    findall(Problems, gpai_models_input_problems([attribute(general_purpose_ai_model, true)|_OpenTail], Problems), Answers),
    Answers == [[wrong_type(profile)]].
test(a_list_with_a_foreign_element_is_not_an_attribute_list) :-
    findall(Problems, gpai_models_input_problems([attribute(general_purpose_ai_model, true), stray], Problems), Answers),
    Answers == [[wrong_type(profile)]].
test(a_list_with_an_unbound_element_is_not_an_attribute_list) :-
    findall(Problems, gpai_models_input_problems([attribute(general_purpose_ai_model, true), _UnboundElement], Problems), Answers),
    Answers == [[wrong_type(profile)]].
test(an_atom_is_not_an_attribute_list) :-
    gpai_models_input_problems(not_a_list, [wrong_type(profile)]).
test(a_key_outside_the_contract_is_named_once) :-
    findall(Problems, gpai_models_input_problems([attribute(colour, red), attribute(colour, blue)], Problems), Answers),
    Answers == [[unknown_key(colour)]].
test(a_number_key_is_an_unknown_key) :-
    gpai_models_input_problems([attribute(42, true)], [unknown_key(42)]).
test(a_compound_key_is_an_unknown_key_as_given) :-
    findall(Problems, gpai_models_input_problems([attribute(colour(red), true)], Problems), Answers),
    Answers == [[unknown_key(colour(red))]].
test(a_repeated_contract_key_is_a_duplicate_whatever_its_values) :-
    findall(Problems, gpai_models_input_problems([attribute(placed_on_the_market_before_2_august_2025, true), attribute(placed_on_the_market_before_2_august_2025, true)], Problems), Answers),
    Answers == [[duplicate_key(placed_on_the_market_before_2_august_2025)]].
test(a_repeated_key_with_a_bad_value_is_only_a_duplicate) :-
    gpai_models_input_problems([attribute(general_purpose_ai_model, true), attribute(general_purpose_ai_model, maybe)], [duplicate_key(general_purpose_ai_model)]).
test(a_crisp_key_given_unsure_is_wrong_type) :-
    gpai_models_input_problems([attribute(provider_established_in_a_third_country, unsure)], [wrong_type(provider_established_in_a_third_country)]).
test(a_judgement_key_given_unsure_is_well_formed) :-
    gpai_models_input_problems([attribute(high_impact_capabilities, unsure)], []).
test(a_negative_computation_is_wrong_type) :-
    gpai_models_input_problems([attribute(cumulative_training_computation_in_floating_point_operations, -1)], [wrong_type(cumulative_training_computation_in_floating_point_operations)]).
test(a_float_computation_is_wrong_type) :-
    gpai_models_input_problems([attribute(cumulative_training_computation_in_floating_point_operations, 1.5)], [wrong_type(cumulative_training_computation_in_floating_point_operations)]).
test(a_very_large_integer_computation_is_well_formed) :-
    gpai_models_input_problems([attribute(cumulative_training_computation_in_floating_point_operations, 10000000000000000000000001)], []).
test(problems_follow_the_contract_order_then_unknown_keys) :-
    findall(Problems, gpai_models_input_problems([attribute(zebra, 1), attribute(high_impact_capabilities, 7), attribute(general_purpose_ai_model, maybe)], Problems), Answers),
    Answers == [[wrong_type(general_purpose_ai_model), wrong_type(high_impact_capabilities), unknown_key(zebra)]].
test(classification_profile_problems_come_before_the_date) :-
    findall(Result - Citations, systemic_risk_classification_status([attribute(colour, red)], tomorrow, Result, Citations), Answers),
    Answers == [input_problems([unknown_key(colour), wrong_type(assessment_date)]) - []].
test(classification_impossible_day_is_wrong_type) :-
    systemic_risk_classification_status([], date(2025, 2, 29), input_problems([wrong_type(assessment_date)]), []).
test(classification_leap_day_is_a_real_day) :-
    systemic_risk_classification_status([], date(2028, 2, 29), indeterminate([general_purpose_ai_model]), []).
test(classification_float_date_part_is_wrong_type) :-
    systemic_risk_classification_status([], date(2026.0, 1, 15), input_problems([wrong_type(assessment_date)]), []).
test(notification_both_dates_bad_in_order) :-
    findall(Result - Citations, systemic_risk_notification_status([], yesterday, tomorrow, Result, Citations), Answers),
    Answers == [input_problems([wrong_type(trigger_date), wrong_type(notification_date)]) - []].
test(notification_before_trigger_is_wrong_type) :-
    systemic_risk_notification_status([], date(2026, 3, 1), date(2026, 2, 28), input_problems([wrong_type(notification_date)]), []).
test(notification_on_the_trigger_day_is_well_formed) :-
    systemic_risk_notification_status([], date(2026, 3, 1), date(2026, 3, 1), indeterminate([general_purpose_ai_model]), []).
test(notification_checks_a_key_it_does_not_read) :-
    systemic_risk_notification_status([attribute(provider_established_in_a_third_country, maybe)], date(2026, 3, 1), date(2026, 3, 2), input_problems([wrong_type(provider_established_in_a_third_country)]), []).
test(obligation_unbound_is_wrong_type) :-
    findall(Result - Citations, provider_obligation_status([], _UnboundObligation, date(2026, 1, 15), Result, Citations), Answers),
    Answers == [input_problems([wrong_type(obligation)]) - []].
test(obligation_all_three_problems_in_order) :-
    findall(Result - Citations, provider_obligation_status(not_a_list, swimming, tomorrow, Result, Citations), Answers),
    Answers == [input_problems([wrong_type(profile), wrong_type(obligation), wrong_type(assessment_date)]) - []].
test(documentation_unbound_is_wrong_type) :-
    findall(Elements - Citations, documentation_elements(_UnboundDocument, Elements, Citations), Answers),
    Answers == [input_problems([wrong_type(document)]) - []].
test(documentation_compound_is_wrong_type) :-
    documentation_elements(document(technical_documentation), input_problems([wrong_type(document)]), []).

test(classification_rejects_without_systemic_risk_bound_above_threshold, fail) :-
    gpai_models_profile_for(classification_above_threshold, systemic_risk_classification(Profile, AssessmentDate)),
    systemic_risk_classification_status(Profile, AssessmentDate, general_purpose_ai_model_without_systemic_risk, _).
test(classification_rejects_with_systemic_risk_bound_at_threshold, fail) :-
    gpai_models_profile_for(classification_at_threshold, systemic_risk_classification(Profile, AssessmentDate)),
    systemic_risk_classification_status(Profile, AssessmentDate, general_purpose_ai_model_with_systemic_risk, _).
test(notification_rejects_late_bound_on_the_two_week_day, fail) :-
    gpai_models_profile_for(notification_on_two_week_day, systemic_risk_notification(Profile, TriggerDate, NotificationDate)),
    systemic_risk_notification_status(Profile, TriggerDate, NotificationDate, notification_after_the_time_limit, _).
test(obligation_applies_bound_is_rejected_for_open_source_documentation, fail) :-
    gpai_models_profile_for(obligation_open_source_technical_documentation, provider_obligation(Profile, Obligation, AssessmentDate)),
    provider_obligation_status(Profile, Obligation, AssessmentDate, obligation_applies, _).
test(facade_status_bound_obligation_applies_is_rejected_before_2_august_2027, fail) :-
    gpai_models_profile_for(obligation_legacy_day_before_transition_end, Request),
    gpai_models_status(Request, obligation_applies).
test(documentation_bound_list_in_another_order_is_rejected, fail) :-
    documentation_elements(additional_technical_documentation_for_models_with_systemic_risk, [system_architecture, evaluation_strategies_and_results, adversarial_testing_and_model_adaptation_measures], _).

cp_test_names([classification_holds_with_systemic_risk_bound, classification_holds_without_systemic_risk_bound_at_threshold, notification_holds_within_bound_on_the_two_week_day, obligation_does_not_apply_bound_for_open_source_documentation, facade_status_bound_compliance_by_2_august_2027, documentation_bound_list_in_annex_order, an_empty_profile_has_no_problem, an_unbound_profile_is_not_an_attribute_list, a_partial_list_is_not_an_attribute_list, a_list_with_a_foreign_element_is_not_an_attribute_list, a_list_with_an_unbound_element_is_not_an_attribute_list, an_atom_is_not_an_attribute_list, a_key_outside_the_contract_is_named_once, a_number_key_is_an_unknown_key, a_compound_key_is_an_unknown_key_as_given, a_repeated_contract_key_is_a_duplicate_whatever_its_values, a_repeated_key_with_a_bad_value_is_only_a_duplicate, a_crisp_key_given_unsure_is_wrong_type, a_judgement_key_given_unsure_is_well_formed, a_negative_computation_is_wrong_type, a_float_computation_is_wrong_type, a_very_large_integer_computation_is_well_formed, problems_follow_the_contract_order_then_unknown_keys, classification_profile_problems_come_before_the_date, classification_impossible_day_is_wrong_type, classification_leap_day_is_a_real_day, classification_float_date_part_is_wrong_type, notification_both_dates_bad_in_order, notification_before_trigger_is_wrong_type, notification_on_the_trigger_day_is_well_formed, notification_checks_a_key_it_does_not_read, obligation_unbound_is_wrong_type, obligation_all_three_problems_in_order, documentation_unbound_is_wrong_type, documentation_compound_is_wrong_type]).
cp_test_fail_names([classification_rejects_without_systemic_risk_bound_above_threshold, classification_rejects_with_systemic_risk_bound_at_threshold, notification_rejects_late_bound_on_the_two_week_day, obligation_applies_bound_is_rejected_for_open_source_documentation, facade_status_bound_obligation_applies_is_rejected_before_2_august_2027, documentation_bound_list_in_another_order_is_rejected]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
