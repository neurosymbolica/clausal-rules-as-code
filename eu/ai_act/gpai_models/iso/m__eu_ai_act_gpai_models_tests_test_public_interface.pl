% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_ai_act_gpai_models_tests_test_public_interface, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_lists_extra, [is_list/1]).
:- use_module(clausal_lists, [msort/2]).
:- use_module(m__eu_ai_act_gpai_models_gpai_models, [decide_gpai_models/2, gpai_models_status/2, gpai_models_checklist/2, gpai_models_decision_resolvable/1, gpai_models_status_values/1, systemic_risk_classification_status/4, systemic_risk_notification_status/5, provider_obligation_status/5, documentation_elements/3]).
:- use_module(m__eu_ai_act_gpai_models_fixtures, [gpai_models_subject/1, gpai_models_profile_for/2, gpai_models_assess/2]).
:- use_module(m__eu_ai_act_gpai_models_queries, [gpai_models_what_if/4]).
:- use_module(m__eu_ai_act_gpai_models_kernel, [gpai_models_input_problems/2]).

expected_status(classification_above_threshold, general_purpose_ai_model_with_systemic_risk).
expected_status(classification_at_threshold, general_purpose_ai_model_without_systemic_risk).
expected_status(classification_high_impact_judged, general_purpose_ai_model_with_systemic_risk).
expected_status(classification_designated_despite_accepted_arguments, general_purpose_ai_model_with_systemic_risk).
expected_status(classification_arguments_accepted, general_purpose_ai_model_without_systemic_risk).
expected_status(classification_research_model, not_a_general_purpose_ai_model).
expected_status(classification_not_a_model_judged, not_a_general_purpose_ai_model).
expected_status(classification_on_application_day, general_purpose_ai_model_with_systemic_risk).
expected_status(classification_day_before_application, not_applicable_on_date).
expected_status(classification_missing_model_key, indeterminate([general_purpose_ai_model])).
expected_status(classification_unsure_model, needs_legal_review(open_textured(general_purpose_ai_model, cite(eu_reg_2024_1689_art_3_63)), [inputs_relied_on([general_purpose_ai_model - unsure, high_impact_capabilities - false])])).
expected_status(classification_model_judged_true, general_purpose_ai_model_without_systemic_risk).
expected_status(classification_bad_assessment_date, input_problems([wrong_type(assessment_date)])).
expected_status(notification_on_two_week_day, notification_within_the_time_limit).
expected_status(notification_day_after_two_week_day, notification_after_the_time_limit).
expected_status(notification_early_trigger_last_day, notification_within_the_time_limit).
expected_status(notification_early_trigger_day_after, notification_after_the_time_limit).
expected_status(notification_legacy_model_on_transition_end, notification_within_the_time_limit).
expected_status(notification_legacy_model_day_after_transition_end, notification_after_the_time_limit).
expected_status(notification_at_threshold, no_notification_duty).
expected_status(notification_high_impact_judged, notification_within_the_time_limit).
expected_status(notification_not_a_model, not_a_general_purpose_ai_model).
expected_status(notification_research_key_not_read, notification_within_the_time_limit).
expected_status(notification_before_trigger, input_problems([wrong_type(notification_date)])).
expected_status(obligation_open_source_technical_documentation, obligation_does_not_apply).
expected_status(obligation_parameters_not_public_technical_documentation, obligation_applies).
expected_status(obligation_open_source_with_systemic_risk_technical_documentation, obligation_applies).
expected_status(obligation_open_source_downstream_information, obligation_does_not_apply).
expected_status(obligation_parameters_not_public_downstream_information, obligation_applies).
expected_status(obligation_open_source_copyright_policy, obligation_applies).
expected_status(obligation_open_source_training_content_summary, obligation_applies).
expected_status(obligation_open_source_cooperation, obligation_applies).
expected_status(obligation_union_provider_representative, obligation_does_not_apply).
expected_status(obligation_third_country_provider_representative, obligation_applies).
expected_status(obligation_open_source_third_country_representative, obligation_does_not_apply).
expected_status(obligation_systemic_third_country_representative, obligation_applies).
expected_status(obligation_model_evaluation_with_systemic_risk, obligation_applies).
expected_status(obligation_model_evaluation_at_threshold, obligation_does_not_apply).
expected_status(obligation_risk_assessment_with_systemic_risk, obligation_applies).
expected_status(obligation_incident_reporting_with_systemic_risk, obligation_applies).
expected_status(obligation_cybersecurity_with_systemic_risk, obligation_applies).
expected_status(obligation_cybersecurity_without_systemic_risk, obligation_does_not_apply).
expected_status(obligation_legacy_day_before_transition_end, compliance_required_by_2_august_2027).
expected_status(obligation_legacy_on_transition_end, obligation_applies).
expected_status(obligation_day_before_application, not_applicable_on_date).
expected_status(obligation_on_application_day, obligation_applies).
expected_status(obligation_research_model, not_a_general_purpose_ai_model).
expected_status(obligation_unsure_licence_technical_documentation, needs_legal_review(open_textured(released_under_a_free_and_open_source_licence_allowing_access_usage_modification_and_distribution, cite(eu_reg_2024_1689_art_53_2)), [inputs_relied_on([general_purpose_ai_model - true, high_impact_capabilities - false, released_under_a_free_and_open_source_licence_allowing_access_usage_modification_and_distribution - unsure])])).
expected_status(obligation_unsure_licence_copyright_policy, obligation_applies).
expected_status(obligation_missing_placed_key, indeterminate([placed_on_the_market_before_2_august_2025])).
expected_status(obligation_missing_placed_key_after_transition, obligation_applies).
expected_status(obligation_unknown_obligation, input_problems([wrong_type(obligation)])).
expected_status(documentation_technical, [intended_tasks_and_type_and_nature_of_ai_systems_for_integration, acceptable_use_policies, date_of_release_and_methods_of_distribution, architecture_and_number_of_parameters, modality_and_format_of_inputs_and_outputs, licence, technical_means_required_for_integration, design_specifications_of_the_model_and_training_process, detailed_information_on_training_testing_and_validation_data, computational_resources_used_for_training, known_or_estimated_energy_consumption]).
expected_status(documentation_additional, [evaluation_strategies_and_results, adversarial_testing_and_model_adaptation_measures, system_architecture]).
expected_status(documentation_downstream, [intended_tasks_and_type_and_nature_of_ai_systems_for_integration, acceptable_use_policies, date_of_release_and_methods_of_distribution, interaction_with_hardware_or_software_outside_the_model, versions_of_relevant_software, architecture_and_number_of_parameters, modality_and_format_of_inputs_and_outputs, licence, technical_means_required_for_integration, modality_format_and_maximum_size_of_inputs_and_outputs, information_on_training_testing_and_validation_data]).
expected_status(documentation_unknown, input_problems([wrong_type(document)])).

not_final(indeterminate(_)).
not_final(needs_legal_review(_, _)).
not_final(input_problems(_)).

same_citation_set(ActualCitations, ExpectedCitations) :-
    sort(ActualCitations, SortedCitations),
    sort(ExpectedCitations, SortedCitations).

resolves_to_expected(Subject) :-
    expected_status(Subject, ExpectedStatus),
    findall(Status, gpai_models_assess(Subject, gpai_models_verdict(Status, _)), Statuses),
    Statuses == [ExpectedStatus].

subject_citations(Subject, Citations) :-
    gpai_models_assess(Subject, gpai_models_verdict(_, Citations)).

final_subject_cited(Subject) :-
    expected_status(Subject, ExpectedStatus),
    final_or_not(ExpectedStatus, Subject).

final_or_not(indeterminate(_), Subject) :-
    subject_citations(Subject, []).
final_or_not(needs_legal_review(_, _), Subject) :-
    subject_citations(Subject, []).
final_or_not(input_problems(_), Subject) :-
    subject_citations(Subject, []).
final_or_not(ExpectedStatus, Subject) :-
    atom(ExpectedStatus),
    subject_citations(Subject, [_|_]).
final_or_not(ExpectedStatus, Subject) :-
    is_list(ExpectedStatus),
    subject_citations(Subject, [_|_]).

checklist_non_empty(Subject) :-
    gpai_models_profile_for(Subject, Request),
    gpai_models_checklist(Request, [_|_]).

cited_item(item(_, _, cite(_))).

referral_context_shape([inputs_relied_on(Pairs)]) :-
    is_list(Pairs).
referral_context_shape([inputs_relied_on(Pairs), provenance(Clause, Citations)]) :-
    is_list(Pairs),
    atom(Clause),
    is_list(Citations).

test(every_subject_has_an_expectation) :-
    findall(Subject, gpai_models_subject(Subject), Subjects),
    findall(Expected, expected_status(Expected, _), ExpectedSubjects),
    msort(Subjects, SortedSubjects),
    msort(ExpectedSubjects, SortedSubjects).
test(every_subject_resolves_once_to_its_expected_status) :-
    findall(Subject, gpai_models_subject(Subject), Subjects),
    maplist(resolves_to_expected, Subjects).
test(final_answers_cite_and_not_final_answers_do_not) :-
    findall(Subject, gpai_models_subject(Subject), Subjects),
    maplist(final_subject_cited, Subjects).
test(every_subject_has_a_non_empty_checklist) :-
    findall(Subject, gpai_models_subject(Subject), Subjects),
    maplist(checklist_non_empty, Subjects).
test(every_subject_is_resolvable) :-
    findall(Request, (gpai_models_subject(Subject), gpai_models_profile_for(Subject, Request)), Requests),
    maplist(gpai_models_decision_resolvable, Requests).
test(final_status_atoms_are_in_the_status_vocabulary) :-
    gpai_models_status_values(StatusValues),
    gpai_models_assess(obligation_legacy_day_before_transition_end, gpai_models_verdict(Status, _)),
    member(Status, StatusValues).
test(above_threshold_has_systemic_risk_with_its_citations) :-
    gpai_models_assess(classification_above_threshold, gpai_models_verdict(general_purpose_ai_model_with_systemic_risk, Citations)),
    same_citation_set(Citations, [cite(eu_reg_2024_1689_art_51_1), cite(eu_reg_2024_1689_art_51_1_a), cite(eu_reg_2024_1689_art_51_1_b), cite(eu_reg_2024_1689_art_51_2), cite(eu_reg_2024_1689_art_52_3), cite(eu_reg_2024_1689_art_52_4)]).
test(at_threshold_has_no_systemic_risk_with_its_citations) :-
    gpai_models_assess(classification_at_threshold, gpai_models_verdict(general_purpose_ai_model_without_systemic_risk, Citations)),
    same_citation_set(Citations, [cite(eu_reg_2024_1689_art_51_1), cite(eu_reg_2024_1689_art_51_1_a), cite(eu_reg_2024_1689_art_51_1_b), cite(eu_reg_2024_1689_art_51_2), cite(eu_reg_2024_1689_art_52_2)]).
test(accepted_arguments_take_the_model_out_of_point_a) :-
    gpai_models_status(classification_arguments_accepted_request_placeholder, _) ; gpai_models_assess(classification_arguments_accepted, gpai_models_verdict(general_purpose_ai_model_without_systemic_risk, _)).
test(designation_wins_over_accepted_arguments) :-
    gpai_models_assess(classification_designated_despite_accepted_arguments, gpai_models_verdict(general_purpose_ai_model_with_systemic_risk, _)).
test(application_day_applies) :-
    gpai_models_profile_for(classification_on_application_day, Request),
    gpai_models_status(Request, general_purpose_ai_model_with_systemic_risk).
test(day_before_application_is_not_applicable) :-
    gpai_models_assess(classification_day_before_application, gpai_models_verdict(not_applicable_on_date, [cite(eu_reg_2024_1689_art_113_b)])).
test(research_model_is_not_a_general_purpose_model) :-
    gpai_models_assess(classification_research_model, gpai_models_verdict(not_a_general_purpose_ai_model, [cite(eu_reg_2024_1689_art_3_63)])).
test(missing_model_key_is_named_directly) :-
    gpai_models_profile_for(classification_missing_model_key, systemic_risk_classification(Profile, AssessmentDate)),
    findall(Result - Citations, systemic_risk_classification_status(Profile, AssessmentDate, Result, Citations), Answers),
    Answers == [indeterminate([general_purpose_ai_model]) - []].
test(unsure_model_goes_to_a_lawyer) :-
    gpai_models_assess(classification_unsure_model, gpai_models_verdict(Status, [])),
    Status == needs_legal_review(open_textured(general_purpose_ai_model, cite(eu_reg_2024_1689_art_3_63)), [inputs_relied_on([general_purpose_ai_model - unsure, high_impact_capabilities - false])]).
test(model_judged_true_settles) :-
    gpai_models_assess(classification_model_judged_true, gpai_models_verdict(general_purpose_ai_model_without_systemic_risk, [_|_])).
test(impossible_date_is_an_input_problem) :-
    gpai_models_assess(classification_bad_assessment_date, gpai_models_verdict(input_problems([wrong_type(assessment_date)]), [])).
test(referral_context_has_the_allowed_shape) :-
    gpai_models_assess(classification_unsure_model, gpai_models_verdict(needs_legal_review(open_textured(_, cite(_)), Context), [])),
    referral_context_shape(Context).
test(provenance_is_the_optional_trailing_context_constructor) :-
    Element = provenance(classification_answer, [cite(eu_reg_2024_1689_art_3_63)]),
    functor(Element, provenance, 2),
    referral_context_shape([inputs_relied_on([general_purpose_ai_model - unsure]), Element]).
test(notification_on_two_week_day_is_within) :-
    gpai_models_assess(notification_on_two_week_day, gpai_models_verdict(notification_within_the_time_limit, Citations)),
    same_citation_set(Citations, [cite(eu_reg_2024_1689_art_52_1), cite(eu_reg_2024_1689_art_111_3), cite(eu_reg_2024_1689_art_113_b)]).
test(notification_day_after_is_late) :-
    gpai_models_assess(notification_day_after_two_week_day, gpai_models_verdict(notification_after_the_time_limit, _)).
test(early_trigger_runs_from_application_day) :-
    gpai_models_assess(notification_early_trigger_last_day, gpai_models_verdict(notification_within_the_time_limit, _)).
test(early_trigger_day_after_is_late) :-
    gpai_models_assess(notification_early_trigger_day_after, gpai_models_verdict(notification_after_the_time_limit, _)).
test(legacy_model_in_time_on_transition_end) :-
    gpai_models_assess(notification_legacy_model_on_transition_end, gpai_models_verdict(notification_within_the_time_limit, _)).
test(legacy_model_late_after_transition_end) :-
    gpai_models_assess(notification_legacy_model_day_after_transition_end, gpai_models_verdict(notification_after_the_time_limit, _)).
test(at_threshold_owes_no_notification) :-
    gpai_models_assess(notification_at_threshold, gpai_models_verdict(no_notification_duty, Citations)),
    same_citation_set(Citations, [cite(eu_reg_2024_1689_art_51_1_a), cite(eu_reg_2024_1689_art_51_2), cite(eu_reg_2024_1689_art_52_1)]).
test(research_key_is_not_read_by_the_notification) :-
    gpai_models_assess(notification_research_key_not_read, gpai_models_verdict(notification_within_the_time_limit, _)).
test(notification_before_trigger_is_an_input_problem) :-
    gpai_models_profile_for(notification_before_trigger, systemic_risk_notification(Profile, TriggerDate, NotificationDate)),
    findall(Result - Citations, systemic_risk_notification_status(Profile, TriggerDate, NotificationDate, Result, Citations), Answers),
    Answers == [input_problems([wrong_type(notification_date)]) - []].
test(open_source_relieves_technical_documentation) :-
    gpai_models_assess(obligation_open_source_technical_documentation, gpai_models_verdict(obligation_does_not_apply, Citations)),
    same_citation_set(Citations, [cite(eu_reg_2024_1689_art_53_1), cite(eu_reg_2024_1689_art_53_1_a), cite(eu_reg_2024_1689_art_53_2)]).
test(parameters_not_public_keep_technical_documentation) :-
    gpai_models_assess(obligation_parameters_not_public_technical_documentation, gpai_models_verdict(obligation_applies, Citations)),
    same_citation_set(Citations, [cite(eu_reg_2024_1689_art_53_1), cite(eu_reg_2024_1689_art_53_1_a)]).
test(open_source_relieves_downstream_information) :-
    gpai_models_assess(obligation_open_source_downstream_information, gpai_models_verdict(obligation_does_not_apply, Citations)),
    same_citation_set(Citations, [cite(eu_reg_2024_1689_art_53_1), cite(eu_reg_2024_1689_art_53_1_b), cite(eu_reg_2024_1689_art_53_2)]).
test(downstream_information_applying_citations) :-
    gpai_models_assess(obligation_parameters_not_public_downstream_information, gpai_models_verdict(obligation_applies, Citations)),
    same_citation_set(Citations, [cite(eu_reg_2024_1689_art_53_1), cite(eu_reg_2024_1689_art_53_1_b), cite(eu_reg_2024_1689_art_53_1_b_i), cite(eu_reg_2024_1689_art_53_1_b_ii)]).
test(cooperation_has_no_exception) :-
    gpai_models_assess(obligation_open_source_cooperation, gpai_models_verdict(obligation_applies, [cite(eu_reg_2024_1689_art_53_3)])).
test(union_provider_needs_no_representative) :-
    gpai_models_assess(obligation_union_provider_representative, gpai_models_verdict(obligation_does_not_apply, Citations)),
    same_citation_set(Citations, [cite(eu_reg_2024_1689_art_54_1), cite(eu_reg_2024_1689_art_54_6)]).
test(third_country_provider_needs_a_representative) :-
    gpai_models_assess(obligation_third_country_provider_representative, gpai_models_verdict(obligation_applies, Citations)),
    same_citation_set(Citations, [cite(eu_reg_2024_1689_art_54_1), cite(eu_reg_2024_1689_art_54_2)]).
test(model_evaluation_at_threshold_does_not_apply) :-
    gpai_models_assess(obligation_model_evaluation_at_threshold, gpai_models_verdict(obligation_does_not_apply, Citations)),
    same_citation_set(Citations, [cite(eu_reg_2024_1689_art_55_1), cite(eu_reg_2024_1689_art_55_1_a), cite(eu_reg_2024_1689_art_51_1)]).
test(model_evaluation_above_threshold_applies) :-
    gpai_models_assess(obligation_model_evaluation_with_systemic_risk, gpai_models_verdict(obligation_applies, Citations)),
    same_citation_set(Citations, [cite(eu_reg_2024_1689_art_55_1), cite(eu_reg_2024_1689_art_55_1_a)]).
test(legacy_model_has_until_transition_end) :-
    gpai_models_assess(obligation_legacy_day_before_transition_end, gpai_models_verdict(compliance_required_by_2_august_2027, Citations)),
    same_citation_set(Citations, [cite(eu_reg_2024_1689_art_111_3), cite(eu_reg_2024_1689_art_53_1), cite(eu_reg_2024_1689_art_53_1_c)]).
test(obligation_before_application_is_not_applicable) :-
    provider_obligation_status([], copyright_policy, date(2025, 8, 1), not_applicable_on_date, [cite(eu_reg_2024_1689_art_113_b)]).
test(unsure_licence_matters_for_technical_documentation) :-
    gpai_models_assess(obligation_unsure_licence_technical_documentation, gpai_models_verdict(needs_legal_review(open_textured(released_under_a_free_and_open_source_licence_allowing_access_usage_modification_and_distribution, cite(eu_reg_2024_1689_art_53_2)), _), [])).
test(unsure_licence_never_matters_for_copyright) :-
    gpai_models_assess(obligation_unsure_licence_copyright_policy, gpai_models_verdict(obligation_applies, [_|_])).
test(missing_placed_key_is_named) :-
    gpai_models_assess(obligation_missing_placed_key, gpai_models_verdict(indeterminate([placed_on_the_market_before_2_august_2025]), [])).
test(missing_placed_key_does_not_matter_after_transition) :-
    gpai_models_assess(obligation_missing_placed_key_after_transition, gpai_models_verdict(obligation_applies, [_|_])).
test(unknown_obligation_is_an_input_problem) :-
    gpai_models_assess(obligation_unknown_obligation, gpai_models_verdict(input_problems([wrong_type(obligation)]), [])).
test(technical_documentation_lists_annex_xi_section_one) :-
    expected_status(documentation_technical, ExpectedElements),
    findall(Elements, documentation_elements(technical_documentation, Elements, _), Answers),
    Answers == [ExpectedElements].
test(downstream_information_cites_annex_xii) :-
    documentation_elements(information_for_downstream_providers, _, Citations),
    member(cite(eu_reg_2024_1689_annex_xii_2_c), Citations).
test(unknown_document_is_an_input_problem) :-
    documentation_elements(annual_report, input_problems([wrong_type(document)]), []).
test(checklist_opens_with_the_verdict_row) :-
    gpai_models_profile_for(classification_at_threshold, Request),
    gpai_models_checklist(Request, [item(verdict, general_purpose_ai_model_without_systemic_risk, [_|_])|_]).
test(checklist_key_items_carry_citations) :-
    gpai_models_profile_for(obligation_open_source_technical_documentation, Request),
    gpai_models_checklist(Request, [_|KeyItems]),
    KeyItems = [_|_],
    maplist(cited_item, KeyItems).
test(what_if_crossing_the_threshold_flips_the_classification) :-
    gpai_models_profile_for(classification_at_threshold, Request),
    gpai_models_what_if(Request, cumulative_training_computation_in_floating_point_operations, 10000000000000000000000001, Status),
    Status == general_purpose_ai_model_with_systemic_risk.
test(what_if_withdrawing_the_designation_keeps_point_b_off) :-
    gpai_models_profile_for(classification_designated_despite_accepted_arguments, Request),
    gpai_models_what_if(Request, designated_by_a_commission_decision_as_a_model_with_systemic_risk, false, Status),
    Status == general_purpose_ai_model_without_systemic_risk.
test(well_formed_profile_has_no_problem) :-
    gpai_models_profile_for(obligation_open_source_copyright_policy, provider_obligation(Profile, _, _)),
    gpai_models_input_problems(Profile, []).
test(duplicate_key_is_named_once) :-
    gpai_models_input_problems([attribute(general_purpose_ai_model, true), attribute(general_purpose_ai_model, false)], [duplicate_key(general_purpose_ai_model)]).
test(negative_computation_is_a_wrong_type) :-
    gpai_models_input_problems([attribute(cumulative_training_computation_in_floating_point_operations, -1)], [wrong_type(cumulative_training_computation_in_floating_point_operations)]).
test(crisp_key_given_unsure_is_a_wrong_type) :-
    gpai_models_input_problems([attribute(provider_established_in_a_third_country, unsure)], [wrong_type(provider_established_in_a_third_country)]).
test(unknown_key_is_named) :-
    gpai_models_input_problems([attribute(colour, red)], [unknown_key(colour)]).
test(non_list_profile_is_a_wrong_type) :-
    gpai_models_input_problems(not_a_profile, [wrong_type(profile)]).

test(at_threshold_is_not_systemic, fail) :-
    gpai_models_assess(classification_at_threshold, gpai_models_verdict(general_purpose_ai_model_with_systemic_risk, _)).
test(accepted_arguments_are_not_systemic, fail) :-
    gpai_models_assess(classification_arguments_accepted, gpai_models_verdict(general_purpose_ai_model_with_systemic_risk, _)).
test(day_before_application_is_not_classified, fail) :-
    gpai_models_assess(classification_day_before_application, gpai_models_verdict(general_purpose_ai_model_with_systemic_risk, _)).
test(research_model_is_not_classified_without_risk, fail) :-
    gpai_models_assess(classification_research_model, gpai_models_verdict(general_purpose_ai_model_without_systemic_risk, _)).
test(referral_context_carries_no_provenance_element, fail) :-
    gpai_models_assess(classification_unsure_model, gpai_models_verdict(needs_legal_review(_, Context), [])),
    Context = [inputs_relied_on(_), provenance(_, _)].
test(provenance_alone_is_not_a_referral_context, fail) :-
    referral_context_shape([provenance(classification_answer, [cite(eu_reg_2024_1689_art_3_63)])]).
test(notification_day_after_is_not_within, fail) :-
    gpai_models_assess(notification_day_after_two_week_day, gpai_models_verdict(notification_within_the_time_limit, _)).
test(legacy_model_on_transition_end_is_not_late, fail) :-
    gpai_models_assess(notification_legacy_model_on_transition_end, gpai_models_verdict(notification_after_the_time_limit, _)).
test(systemic_risk_removes_the_open_source_exception, fail) :-
    gpai_models_assess(obligation_open_source_with_systemic_risk_technical_documentation, gpai_models_verdict(obligation_does_not_apply, _)).
test(third_country_provider_is_not_relieved, fail) :-
    gpai_models_assess(obligation_third_country_provider_representative, gpai_models_verdict(obligation_does_not_apply, _)).
test(legacy_model_on_transition_end_is_not_delayed, fail) :-
    gpai_models_assess(obligation_legacy_on_transition_end, gpai_models_verdict(compliance_required_by_2_august_2027, _)).

cp_test_names([every_subject_has_an_expectation, every_subject_resolves_once_to_its_expected_status, final_answers_cite_and_not_final_answers_do_not, every_subject_has_a_non_empty_checklist, every_subject_is_resolvable, final_status_atoms_are_in_the_status_vocabulary, above_threshold_has_systemic_risk_with_its_citations, at_threshold_has_no_systemic_risk_with_its_citations, accepted_arguments_take_the_model_out_of_point_a, designation_wins_over_accepted_arguments, application_day_applies, day_before_application_is_not_applicable, research_model_is_not_a_general_purpose_model, missing_model_key_is_named_directly, unsure_model_goes_to_a_lawyer, model_judged_true_settles, impossible_date_is_an_input_problem, referral_context_has_the_allowed_shape, provenance_is_the_optional_trailing_context_constructor, notification_on_two_week_day_is_within, notification_day_after_is_late, early_trigger_runs_from_application_day, early_trigger_day_after_is_late, legacy_model_in_time_on_transition_end, legacy_model_late_after_transition_end, at_threshold_owes_no_notification, research_key_is_not_read_by_the_notification, notification_before_trigger_is_an_input_problem, open_source_relieves_technical_documentation, parameters_not_public_keep_technical_documentation, open_source_relieves_downstream_information, downstream_information_applying_citations, cooperation_has_no_exception, union_provider_needs_no_representative, third_country_provider_needs_a_representative, model_evaluation_at_threshold_does_not_apply, model_evaluation_above_threshold_applies, legacy_model_has_until_transition_end, obligation_before_application_is_not_applicable, unsure_licence_matters_for_technical_documentation, unsure_licence_never_matters_for_copyright, missing_placed_key_is_named, missing_placed_key_does_not_matter_after_transition, unknown_obligation_is_an_input_problem, technical_documentation_lists_annex_xi_section_one, downstream_information_cites_annex_xii, unknown_document_is_an_input_problem, checklist_opens_with_the_verdict_row, checklist_key_items_carry_citations, what_if_crossing_the_threshold_flips_the_classification, what_if_withdrawing_the_designation_keeps_point_b_off, well_formed_profile_has_no_problem, duplicate_key_is_named_once, negative_computation_is_a_wrong_type, crisp_key_given_unsure_is_a_wrong_type, unknown_key_is_named, non_list_profile_is_a_wrong_type]).
cp_test_fail_names([at_threshold_is_not_systemic, accepted_arguments_are_not_systemic, day_before_application_is_not_classified, research_model_is_not_classified_without_risk, referral_context_carries_no_provenance_element, provenance_alone_is_not_a_referral_context, notification_day_after_is_not_within, legacy_model_on_transition_end_is_not_late, systemic_risk_removes_the_open_source_exception, third_country_provider_is_not_relieved, legacy_model_on_transition_end_is_not_delayed]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
