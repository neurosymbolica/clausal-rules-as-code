% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_ai_act_gpai_models_tests_test_negative_controls, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_ai_act_gpai_models_gpai_models, [gpai_models_status_values/1]).
:- use_module(m__eu_ai_act_gpai_models_fixtures, [gpai_models_assess/2]).

in_status_values(StatusValues, Status) :-
    member(Status, StatusValues).

status_of(Subject, Status) :-
    gpai_models_assess(Subject, gpai_models_verdict(Status, _)).

test(every_near_miss_atom_is_a_verdict_atom) :-
    gpai_models_status_values(StatusValues),
    maplist(in_status_values(StatusValues), [not_applicable_on_date, not_a_general_purpose_ai_model, general_purpose_ai_model_with_systemic_risk, general_purpose_ai_model_without_systemic_risk, no_notification_duty, notification_after_the_time_limit, notification_within_the_time_limit, obligation_does_not_apply, compliance_required_by_2_august_2027, obligation_applies]).
test(above_the_threshold_has_systemic_risk) :-
    status_of(classification_above_threshold, general_purpose_ai_model_with_systemic_risk).
test(at_the_threshold_has_no_systemic_risk) :-
    status_of(classification_at_threshold, general_purpose_ai_model_without_systemic_risk).
test(judged_high_impact_has_systemic_risk) :-
    status_of(classification_high_impact_judged, general_purpose_ai_model_with_systemic_risk).
test(without_judged_high_impact_has_no_systemic_risk) :-
    status_of(classification_model_judged_true, general_purpose_ai_model_without_systemic_risk).
test(a_designation_wins_over_accepted_arguments) :-
    status_of(classification_designated_despite_accepted_arguments, general_purpose_ai_model_with_systemic_risk).
test(accepted_arguments_without_designation_remove_point_a) :-
    status_of(classification_arguments_accepted, general_purpose_ai_model_without_systemic_risk).
test(a_research_model_is_not_a_general_purpose_ai_model) :-
    status_of(classification_research_model, not_a_general_purpose_ai_model).
test(a_model_judged_false_is_not_a_general_purpose_ai_model) :-
    status_of(classification_not_a_model_judged, not_a_general_purpose_ai_model).
test(the_day_before_application_is_not_applicable) :-
    status_of(classification_day_before_application, not_applicable_on_date).
test(the_application_day_applies) :-
    status_of(classification_on_application_day, general_purpose_ai_model_with_systemic_risk).
test(obligation_day_before_application_is_not_applicable) :-
    status_of(obligation_day_before_application, not_applicable_on_date).
test(obligation_on_application_day_applies) :-
    status_of(obligation_on_application_day, obligation_applies).
test(notification_on_the_two_week_day_is_within) :-
    status_of(notification_on_two_week_day, notification_within_the_time_limit).
test(notification_the_day_after_is_late) :-
    status_of(notification_day_after_two_week_day, notification_after_the_time_limit).
test(early_trigger_last_day_is_within) :-
    status_of(notification_early_trigger_last_day, notification_within_the_time_limit).
test(early_trigger_day_after_is_late) :-
    status_of(notification_early_trigger_day_after, notification_after_the_time_limit).
test(legacy_notification_on_2_august_2027_is_within) :-
    status_of(notification_legacy_model_on_transition_end, notification_within_the_time_limit).
test(legacy_notification_on_3_august_2027_is_late) :-
    status_of(notification_legacy_model_day_after_transition_end, notification_after_the_time_limit).
test(at_the_threshold_no_notification_is_due) :-
    status_of(notification_at_threshold, no_notification_duty).
test(a_judged_model_must_notify) :-
    status_of(notification_high_impact_judged, notification_within_the_time_limit).
test(a_model_judged_false_needs_no_notification_answer) :-
    status_of(notification_not_a_model, not_a_general_purpose_ai_model).
test(open_source_relieves_technical_documentation) :-
    status_of(obligation_open_source_technical_documentation, obligation_does_not_apply).
test(parameters_not_public_keep_technical_documentation) :-
    status_of(obligation_parameters_not_public_technical_documentation, obligation_applies).
test(systemic_risk_keeps_technical_documentation) :-
    status_of(obligation_open_source_with_systemic_risk_technical_documentation, obligation_applies).
test(open_source_relieves_downstream_information) :-
    status_of(obligation_open_source_downstream_information, obligation_does_not_apply).
test(parameters_not_public_keep_downstream_information) :-
    status_of(obligation_parameters_not_public_downstream_information, obligation_applies).
test(open_source_keeps_the_copyright_policy) :-
    status_of(obligation_open_source_copyright_policy, obligation_applies).
test(open_source_keeps_the_training_content_summary) :-
    status_of(obligation_open_source_training_content_summary, obligation_applies).
test(open_source_keeps_cooperation) :-
    status_of(obligation_open_source_cooperation, obligation_applies).
test(a_union_provider_needs_no_representative) :-
    status_of(obligation_union_provider_representative, obligation_does_not_apply).
test(a_third_country_provider_needs_a_representative) :-
    status_of(obligation_third_country_provider_representative, obligation_applies).
test(open_source_relieves_a_third_country_provider) :-
    status_of(obligation_open_source_third_country_representative, obligation_does_not_apply).
test(systemic_risk_keeps_the_representative) :-
    status_of(obligation_systemic_third_country_representative, obligation_applies).
test(model_evaluation_applies_with_systemic_risk) :-
    status_of(obligation_model_evaluation_with_systemic_risk, obligation_applies).
test(model_evaluation_does_not_apply_at_the_threshold) :-
    status_of(obligation_model_evaluation_at_threshold, obligation_does_not_apply).
test(risk_assessment_applies_with_systemic_risk) :-
    status_of(obligation_risk_assessment_with_systemic_risk, obligation_applies).
test(incident_reporting_applies_with_systemic_risk) :-
    status_of(obligation_incident_reporting_with_systemic_risk, obligation_applies).
test(cybersecurity_applies_with_systemic_risk) :-
    status_of(obligation_cybersecurity_with_systemic_risk, obligation_applies).
test(cybersecurity_does_not_apply_without_systemic_risk) :-
    status_of(obligation_cybersecurity_without_systemic_risk, obligation_does_not_apply).
test(legacy_model_has_until_2_august_2027) :-
    status_of(obligation_legacy_day_before_transition_end, compliance_required_by_2_august_2027).
test(legacy_model_obligation_applies_on_2_august_2027) :-
    status_of(obligation_legacy_on_transition_end, obligation_applies).
test(a_research_model_owes_no_obligation_answer) :-
    status_of(obligation_research_model, not_a_general_purpose_ai_model).
test(a_missing_placed_key_is_named_before_2_august_2027) :-
    status_of(obligation_missing_placed_key, indeterminate([placed_on_the_market_before_2_august_2025])).
test(a_missing_placed_key_does_not_matter_from_2_august_2027) :-
    status_of(obligation_missing_placed_key_after_transition, obligation_applies).
test(an_unsure_licence_is_referred_for_documentation) :-
    status_of(obligation_unsure_licence_technical_documentation, needs_legal_review(open_textured(released_under_a_free_and_open_source_licence_allowing_access_usage_modification_and_distribution, cite(eu_reg_2024_1689_art_53_2)), _)).
test(an_unsure_licence_does_not_matter_for_the_copyright_policy) :-
    status_of(obligation_unsure_licence_copyright_policy, obligation_applies).
test(an_empty_profile_asks_for_the_model_key) :-
    status_of(classification_missing_model_key, indeterminate([general_purpose_ai_model])).
test(an_unsure_model_goes_to_a_lawyer) :-
    status_of(classification_unsure_model, needs_legal_review(open_textured(general_purpose_ai_model, cite(eu_reg_2024_1689_art_3_63)), _)).
test(an_unknown_obligation_is_an_input_problem) :-
    status_of(obligation_unknown_obligation, input_problems([wrong_type(obligation)])).
test(an_impossible_assessment_date_is_an_input_problem) :-
    status_of(classification_bad_assessment_date, input_problems([wrong_type(assessment_date)])).
test(a_notification_before_its_trigger_is_an_input_problem) :-
    status_of(notification_before_trigger, input_problems([wrong_type(notification_date)])).
test(an_unknown_document_is_an_input_problem) :-
    status_of(documentation_unknown, input_problems([wrong_type(document)])).

test(at_the_threshold_is_not_systemic, fail) :-
    status_of(classification_at_threshold, general_purpose_ai_model_with_systemic_risk).
test(without_judged_high_impact_is_not_systemic, fail) :-
    status_of(classification_model_judged_true, general_purpose_ai_model_with_systemic_risk).
test(accepted_arguments_without_designation_are_not_systemic, fail) :-
    status_of(classification_arguments_accepted, general_purpose_ai_model_with_systemic_risk).
test(a_research_model_is_not_classified, fail) :-
    status_of(classification_research_model, general_purpose_ai_model_without_systemic_risk).
test(the_application_day_is_not_before_application, fail) :-
    status_of(classification_on_application_day, not_applicable_on_date).
test(notification_on_the_two_week_day_is_not_late, fail) :-
    status_of(notification_on_two_week_day, notification_after_the_time_limit).
test(legacy_notification_on_2_august_2027_is_not_late, fail) :-
    status_of(notification_legacy_model_on_transition_end, notification_after_the_time_limit).
test(at_the_threshold_no_notification_is_within, fail) :-
    status_of(notification_at_threshold, notification_within_the_time_limit).
test(parameters_not_public_do_not_relieve, fail) :-
    status_of(obligation_parameters_not_public_technical_documentation, obligation_does_not_apply).
test(open_source_does_not_relieve_the_copyright_policy, fail) :-
    status_of(obligation_open_source_copyright_policy, obligation_does_not_apply).
test(a_third_country_provider_is_not_relieved, fail) :-
    status_of(obligation_third_country_provider_representative, obligation_does_not_apply).
test(model_evaluation_at_the_threshold_does_not_apply_as_a_duty, fail) :-
    status_of(obligation_model_evaluation_at_threshold, obligation_applies).
test(legacy_model_is_not_in_transition_on_2_august_2027, fail) :-
    status_of(obligation_legacy_on_transition_end, compliance_required_by_2_august_2027).
test(a_missing_placed_key_is_not_named_from_2_august_2027, fail) :-
    status_of(obligation_missing_placed_key_after_transition, indeterminate(_)).
test(an_unsure_licence_is_not_referred_for_the_copyright_policy, fail) :-
    status_of(obligation_unsure_licence_copyright_policy, needs_legal_review(_, _)).
test(a_known_obligation_is_not_an_input_problem, fail) :-
    status_of(obligation_open_source_copyright_policy, input_problems(_)).
test(a_known_document_is_not_an_input_problem, fail) :-
    status_of(documentation_technical, input_problems(_)).

cp_test_names([every_near_miss_atom_is_a_verdict_atom, above_the_threshold_has_systemic_risk, at_the_threshold_has_no_systemic_risk, judged_high_impact_has_systemic_risk, without_judged_high_impact_has_no_systemic_risk, a_designation_wins_over_accepted_arguments, accepted_arguments_without_designation_remove_point_a, a_research_model_is_not_a_general_purpose_ai_model, a_model_judged_false_is_not_a_general_purpose_ai_model, the_day_before_application_is_not_applicable, the_application_day_applies, obligation_day_before_application_is_not_applicable, obligation_on_application_day_applies, notification_on_the_two_week_day_is_within, notification_the_day_after_is_late, early_trigger_last_day_is_within, early_trigger_day_after_is_late, legacy_notification_on_2_august_2027_is_within, legacy_notification_on_3_august_2027_is_late, at_the_threshold_no_notification_is_due, a_judged_model_must_notify, a_model_judged_false_needs_no_notification_answer, open_source_relieves_technical_documentation, parameters_not_public_keep_technical_documentation, systemic_risk_keeps_technical_documentation, open_source_relieves_downstream_information, parameters_not_public_keep_downstream_information, open_source_keeps_the_copyright_policy, open_source_keeps_the_training_content_summary, open_source_keeps_cooperation, a_union_provider_needs_no_representative, a_third_country_provider_needs_a_representative, open_source_relieves_a_third_country_provider, systemic_risk_keeps_the_representative, model_evaluation_applies_with_systemic_risk, model_evaluation_does_not_apply_at_the_threshold, risk_assessment_applies_with_systemic_risk, incident_reporting_applies_with_systemic_risk, cybersecurity_applies_with_systemic_risk, cybersecurity_does_not_apply_without_systemic_risk, legacy_model_has_until_2_august_2027, legacy_model_obligation_applies_on_2_august_2027, a_research_model_owes_no_obligation_answer, a_missing_placed_key_is_named_before_2_august_2027, a_missing_placed_key_does_not_matter_from_2_august_2027, an_unsure_licence_is_referred_for_documentation, an_unsure_licence_does_not_matter_for_the_copyright_policy, an_empty_profile_asks_for_the_model_key, an_unsure_model_goes_to_a_lawyer, an_unknown_obligation_is_an_input_problem, an_impossible_assessment_date_is_an_input_problem, a_notification_before_its_trigger_is_an_input_problem, an_unknown_document_is_an_input_problem]).
cp_test_fail_names([at_the_threshold_is_not_systemic, without_judged_high_impact_is_not_systemic, accepted_arguments_without_designation_are_not_systemic, a_research_model_is_not_classified, the_application_day_is_not_before_application, notification_on_the_two_week_day_is_not_late, legacy_notification_on_2_august_2027_is_not_late, at_the_threshold_no_notification_is_within, parameters_not_public_do_not_relieve, open_source_does_not_relieve_the_copyright_policy, a_third_country_provider_is_not_relieved, model_evaluation_at_the_threshold_does_not_apply_as_a_duty, legacy_model_is_not_in_transition_on_2_august_2027, a_missing_placed_key_is_not_named_from_2_august_2027, an_unsure_licence_is_not_referred_for_the_copyright_policy, a_known_obligation_is_not_an_input_problem, a_known_document_is_not_an_input_problem]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
