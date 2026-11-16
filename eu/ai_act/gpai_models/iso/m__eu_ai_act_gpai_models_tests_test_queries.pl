% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_ai_act_gpai_models_tests_test_queries, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_ai_act_gpai_models_queries, [gpai_models_profile_keys/1, gpai_models_what_if/4, date/3, indeterminate/1, needs_legal_review/2, open_textured/2, inputs_relied_on/1, provenance/2, input_problems/1, unknown_key/1, wrong_type/1, duplicate_key/1, general_purpose_ai_model/0, placed_on_the_market_before_2_august_2025/0, technical_documentation/0, cybersecurity_protection/0, additional_technical_documentation_for_models_with_systemic_risk/0, unsure/0]).
:- use_module(m__eu_ai_act_gpai_models_kernel, [gpai_models_input_problems/2]).
:- use_module(m__eu_ai_act_gpai_models_gpai_models, [gpai_models_status/2, gpai_models_checklist/2, systemic_risk_classification_status/4, systemic_risk_notification_status/5, provider_obligation_status/5, documentation_elements/3]).
:- use_module(m__eu_ai_act_gpai_models_fixtures, [gpai_models_profile_for/2]).

cited_item(item(_, _, cite(CitationKey))) :-
    atom(CitationKey).

unknown_item(item(ProfileKey, unknown([ProfileKey]), cite(_))).

test(profile_keys_are_the_contract_keys) :-
    gpai_models_profile_keys(ProfileKeys),
    ProfileKeys == [general_purpose_ai_model, used_for_research_development_or_prototyping_before_being_placed_on_the_market, cumulative_training_computation_in_floating_point_operations, high_impact_capabilities, designated_by_a_commission_decision_as_a_model_with_systemic_risk, commission_accepted_the_providers_arguments_that_the_model_presents_no_systemic_risks, released_under_a_free_and_open_source_licence_allowing_access_usage_modification_and_distribution, parameters_weights_architecture_and_usage_information_made_publicly_available, provider_established_in_a_third_country, placed_on_the_market_before_2_august_2025].
test(re_exported_input_check_answers_once) :-
    findall(Problems, gpai_models_input_problems([attribute(colour, red)], Problems), Answers),
    Answers == [[unknown_key(colour)]].
test(an_unbound_value_is_wrong_type) :-
    findall(Problems, gpai_models_input_problems([attribute(general_purpose_ai_model, _UnboundValue)], Problems), Answers),
    Answers == [[wrong_type(general_purpose_ai_model)]].
test(result_constructors_are_callable) :-
    date(2025, 8, 2),
    indeterminate([general_purpose_ai_model]),
    needs_legal_review(open_textured(high_impact_capabilities, cite(eu_reg_2024_1689_art_51_1_a)), [inputs_relied_on([high_impact_capabilities - unsure])]),
    open_textured(high_impact_capabilities, cite(eu_reg_2024_1689_art_51_1_a)),
    inputs_relied_on([general_purpose_ai_model - true]),
    provenance(classification_answer, [cite(eu_reg_2024_1689_art_3_63)]),
    input_problems([wrong_type(assessment_date)]),
    unknown_key(colour),
    wrong_type(assessment_date),
    duplicate_key(general_purpose_ai_model).
test(date_constructor_holds_for_a_ground_date) :-
    date(2027, 8, 2).
test(indeterminate_constructor_holds_for_one_key) :-
    indeterminate([placed_on_the_market_before_2_august_2025]).
test(needs_legal_review_constructor_allows_a_trailing_provenance) :-
    needs_legal_review(open_textured(general_purpose_ai_model, cite(eu_reg_2024_1689_art_3_63)), [inputs_relied_on([general_purpose_ai_model - unsure]), provenance(classification_answer, [cite(eu_reg_2024_1689_art_3_63)])]).
test(provenance_constructor_holds) :-
    provenance(notification_answer, [cite(eu_reg_2024_1689_art_52_1)]).
test(input_problems_constructor_holds) :-
    input_problems([duplicate_key(general_purpose_ai_model), unknown_key(colour)]).
test(unknown_key_constructor_holds_for_a_number) :-
    unknown_key(42).
test(duplicate_key_constructor_holds) :-
    duplicate_key(high_impact_capabilities).
test(query_three_classification_answers_once) :-
    gpai_models_profile_for(classification_high_impact_judged, systemic_risk_classification(Profile, AssessmentDate)),
    findall(Result, systemic_risk_classification_status(Profile, AssessmentDate, Result, _), Results),
    Results == [general_purpose_ai_model_with_systemic_risk].
test(query_fourteen_obligation_answers_once) :-
    gpai_models_profile_for(obligation_third_country_provider_representative, provider_obligation(Profile, Obligation, AssessmentDate)),
    findall(Result - Citations, provider_obligation_status(Profile, Obligation, AssessmentDate, Result, Citations), Answers),
    Answers == [obligation_applies - [cite(eu_reg_2024_1689_art_54_1), cite(eu_reg_2024_1689_art_54_2)]].
test(query_fifteen_deadline_answers_once) :-
    gpai_models_profile_for(notification_early_trigger_day_after, systemic_risk_notification(Profile, TriggerDate, NotificationDate)),
    findall(Result, systemic_risk_notification_status(Profile, TriggerDate, NotificationDate, Result, _), Results),
    Results == [notification_after_the_time_limit].
test(query_one_lookup_shares_atoms_across_annexes) :-
    documentation_elements(technical_documentation, TechnicalElements, _),
    documentation_elements(information_for_downstream_providers, DownstreamElements, _),
    member(licence, TechnicalElements),
    member(licence, DownstreamElements),
    member(modality_format_and_maximum_size_of_inputs_and_outputs, DownstreamElements).
test(query_seven_checklist_cites_every_item) :-
    gpai_models_profile_for(classification_above_threshold, Request),
    gpai_models_checklist(Request, [item(verdict, general_purpose_ai_model_with_systemic_risk, [_|_])|KeyItems]),
    length(KeyItems, 6),
    maplist(cited_item, KeyItems).
test(query_seven_checklist_marks_absent_keys_unknown) :-
    gpai_models_profile_for(classification_missing_model_key, Request),
    gpai_models_checklist(Request, [item(verdict, indeterminate([general_purpose_ai_model]), [])|KeyItems]),
    length(KeyItems, 6),
    maplist(unknown_item, KeyItems).
test(query_two_status_projection) :-
    gpai_models_profile_for(obligation_cybersecurity_with_systemic_risk, Request),
    findall(Status, gpai_models_status(Request, Status), Statuses),
    Statuses == [obligation_applies].
test(what_if_one_more_operation_flips_the_classification) :-
    gpai_models_profile_for(classification_at_threshold, Request),
    findall(NewStatus, gpai_models_what_if(Request, cumulative_training_computation_in_floating_point_operations, 10000000000000000000000001, NewStatus), NewStatuses),
    NewStatuses == [general_purpose_ai_model_with_systemic_risk].
test(what_if_the_same_value_keeps_the_classification) :-
    gpai_models_profile_for(classification_at_threshold, Request),
    gpai_models_what_if(Request, cumulative_training_computation_in_floating_point_operations, 10000000000000000000000000, general_purpose_ai_model_without_systemic_risk).
test(what_if_parameters_withheld_restores_the_documentation_duty) :-
    gpai_models_profile_for(obligation_open_source_technical_documentation, Request),
    gpai_models_what_if(Request, parameters_weights_architecture_and_usage_information_made_publicly_available, false, obligation_applies).
test(what_if_fills_a_missing_key) :-
    gpai_models_profile_for(obligation_missing_placed_key, Request),
    gpai_models_what_if(Request, placed_on_the_market_before_2_august_2025, true, compliance_required_by_2_august_2027).
test(what_if_a_designation_classifies) :-
    gpai_models_profile_for(classification_arguments_accepted, Request),
    gpai_models_what_if(Request, designated_by_a_commission_decision_as_a_model_with_systemic_risk, true, general_purpose_ai_model_with_systemic_risk).
test(what_if_a_bad_value_is_an_input_problem) :-
    gpai_models_profile_for(classification_at_threshold, Request),
    gpai_models_what_if(Request, high_impact_capabilities, perhaps, input_problems([wrong_type(high_impact_capabilities)])).
test(what_if_leaves_a_documentation_request_unchanged) :-
    gpai_models_profile_for(documentation_additional, Request),
    gpai_models_what_if(Request, general_purpose_ai_model, false, [evaluation_strategies_and_results, adversarial_testing_and_model_adaptation_measures, system_architecture]).
test(root_atoms_are_callable) :-
    general_purpose_ai_model,
    placed_on_the_market_before_2_august_2025,
    technical_documentation,
    cybersecurity_protection,
    additional_technical_documentation_for_models_with_systemic_risk,
    unsure.

test(date_constructor_rejects_a_month_out_of_range, fail) :-
    date(2025, 13, 1).
test(indeterminate_constructor_rejects_two_keys, fail) :-
    indeterminate([general_purpose_ai_model, high_impact_capabilities]).
test(query_one_lookup_keeps_differently_worded_atoms_apart, fail) :-
    documentation_elements(technical_documentation, TechnicalElements, _),
    member(modality_format_and_maximum_size_of_inputs_and_outputs, TechnicalElements).

cp_test_names([profile_keys_are_the_contract_keys, re_exported_input_check_answers_once, an_unbound_value_is_wrong_type, result_constructors_are_callable, date_constructor_holds_for_a_ground_date, indeterminate_constructor_holds_for_one_key, needs_legal_review_constructor_allows_a_trailing_provenance, provenance_constructor_holds, input_problems_constructor_holds, unknown_key_constructor_holds_for_a_number, duplicate_key_constructor_holds, query_three_classification_answers_once, query_fourteen_obligation_answers_once, query_fifteen_deadline_answers_once, query_one_lookup_shares_atoms_across_annexes, query_seven_checklist_cites_every_item, query_seven_checklist_marks_absent_keys_unknown, query_two_status_projection, what_if_one_more_operation_flips_the_classification, what_if_the_same_value_keeps_the_classification, what_if_parameters_withheld_restores_the_documentation_duty, what_if_fills_a_missing_key, what_if_a_designation_classifies, what_if_a_bad_value_is_an_input_problem, what_if_leaves_a_documentation_request_unchanged, root_atoms_are_callable]).
cp_test_fail_names([date_constructor_rejects_a_month_out_of_range, indeterminate_constructor_rejects_two_keys, query_one_lookup_keeps_differently_worded_atoms_apart]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
