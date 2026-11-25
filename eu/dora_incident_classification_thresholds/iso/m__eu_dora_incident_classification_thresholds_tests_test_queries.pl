% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_incident_classification_thresholds_tests_test_queries, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_dora_incident_classification_thresholds_queries, [dora_incident_classification_thresholds_profile_keys/1, dora_incident_classification_thresholds_what_if/4, met/0, not_met/0, on_time/0, month_limit/0, unsure/0, critical_services_affected/0, economic_impact_threshold_met/0, affected_clients/0, final_report_weekend_extension/0, late/1]).
:- use_module(m__eu_dora_incident_classification_thresholds_kernel, [dora_incident_classification_thresholds_input_problems/2]).
:- use_module(m__eu_dora_incident_classification_thresholds_dora_incident_classification_thresholds, [dora_incident_classification_thresholds_status/2]).

test(profile_keys_are_the_contract_keys) :-
    dora_incident_classification_thresholds_profile_keys(ProfileKeys),
    ProfileKeys == [affects_ict_services_supporting_critical_or_important_functions, affects_authorised_registered_or_supervised_financial_services, successful_malicious_unauthorised_access, access_may_result_in_data_losses, affected_clients, clients_using_affected_service, affected_financial_counterparts, financial_counterparts_of_affected_service, affected_transactions_number, affected_transactions_amount, reference_period_transactions_number, reference_period_transactions_amount, reference_period_days, relevant_clients_or_financial_counterparts_affected, incident_reflected_in_media, repetitive_complaints_from_different_clients_or_counterparts, regulatory_requirements_likely_not_met, material_loss_of_clients_or_counterparts_likely, incident_duration_seconds, critical_or_important_function_service_downtime_seconds, member_states_with_impact, data_impact_adverse_to_business_objectives_or_regulatory_requirements, data_availability_impact, data_authenticity_impact, data_integrity_impact, data_confidentiality_impact, expropriated_funds_and_assets_cents, replacement_and_relocation_costs_cents, staff_costs_cents, contractual_non_compliance_fees_cents, redress_and_compensation_costs_cents, forgone_revenue_losses_cents, communication_costs_cents, advisory_costs_cents, costs_and_losses_likely_to_exceed_threshold, final_report_weekend_extension].
test(profile_keys_number_thirty_six) :-
    dora_incident_classification_thresholds_profile_keys(ProfileKeys),
    length(ProfileKeys, 36).
test(the_reexported_input_check_accepts_a_good_profile) :-
    dora_incident_classification_thresholds_input_problems([attribute(member_states_with_impact, 2)], []).
test(the_reexported_input_check_names_an_unknown_key) :-
    dora_incident_classification_thresholds_input_problems([attribute(colour, red)], Problems),
    Problems == [unknown_key(colour)].
test(what_if_flips_geographical_spread_to_met) :-
    Request = threshold_query([attribute(member_states_with_impact, 1)], geographical_spread_threshold_met),
    dora_incident_classification_thresholds_status(Request, not_met),
    findall(NewStatus, dora_incident_classification_thresholds_what_if(Request, member_states_with_impact, 2, NewStatus), NewStatuses),
    NewStatuses == [met].
test(what_if_keeps_the_answer_below_the_limit) :-
    Request = threshold_query([attribute(member_states_with_impact, 1)], geographical_spread_threshold_met),
    dora_incident_classification_thresholds_what_if(Request, member_states_with_impact, 0, NewStatus),
    NewStatus == not_met.
test(what_if_flips_the_weekend_extension_to_on_time) :-
    Request = final_report_query([attribute(final_report_weekend_extension, false)], date(2025, 5, 31), date(2025, 7, 1)),
    dora_incident_classification_thresholds_status(Request, late(month_limit)),
    findall(NewStatus, dora_incident_classification_thresholds_what_if(Request, final_report_weekend_extension, true, NewStatus), NewStatuses),
    NewStatuses == [on_time].
test(what_if_with_a_wrong_value_gives_input_problems) :-
    Request = threshold_query([attribute(member_states_with_impact, 1)], geographical_spread_threshold_met),
    dora_incident_classification_thresholds_what_if(Request, member_states_with_impact, two, NewStatus),
    NewStatus == input_problems([wrong_type(member_states_with_impact)]).
test(root_atoms_are_exported) :-
    met,
    not_met,
    on_time,
    month_limit,
    unsure,
    critical_services_affected,
    economic_impact_threshold_met,
    affected_clients,
    final_report_weekend_extension.
test(late_carries_the_month_limit) :-
    late(month_limit).

cp_test_names([profile_keys_are_the_contract_keys, profile_keys_number_thirty_six, the_reexported_input_check_accepts_a_good_profile, the_reexported_input_check_names_an_unknown_key, what_if_flips_geographical_spread_to_met, what_if_keeps_the_answer_below_the_limit, what_if_flips_the_weekend_extension_to_on_time, what_if_with_a_wrong_value_gives_input_problems, root_atoms_are_exported, late_carries_the_month_limit]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
