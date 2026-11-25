% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_incident_classification_thresholds_fixtures, [dora_incident_classification_thresholds_subject/1, dora_incident_classification_thresholds_profile_for/2, dora_incident_classification_thresholds_assess/2]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_dora_incident_classification_thresholds_dora_incident_classification_thresholds, [decide_dora_incident_classification_thresholds/2]).

subject_query(critical_services_one_point_true, threshold(critical_services_affected)).
subject_query(critical_services_all_points_false, threshold(critical_services_affected)).
subject_query(critical_services_unsure_referred, threshold(critical_services_affected)).
subject_query(malicious_access_both_true, threshold(data_losses_malicious_access_threshold_met)).
subject_query(malicious_access_data_losses_false, threshold(data_losses_malicious_access_threshold_met)).
subject_query(clients_over_absolute_limit, threshold(clients_financial_counterparts_and_transactions_threshold_met)).
subject_query(clients_at_absolute_limit, threshold(clients_financial_counterparts_and_transactions_threshold_met)).
subject_query(clients_share_above_ten_percent, threshold(clients_financial_counterparts_and_transactions_threshold_met)).
subject_query(clients_share_at_ten_percent, threshold(clients_financial_counterparts_and_transactions_threshold_met)).
subject_query(counterparts_share_above_thirty_percent, threshold(clients_financial_counterparts_and_transactions_threshold_met)).
subject_query(counterparts_share_at_thirty_percent, threshold(clients_financial_counterparts_and_transactions_threshold_met)).
subject_query(transactions_above_daily_average_share, threshold(clients_financial_counterparts_and_transactions_threshold_met)).
subject_query(transactions_at_daily_average_share, threshold(clients_financial_counterparts_and_transactions_threshold_met)).
subject_query(transactions_zero_total_with_one_day, threshold(clients_financial_counterparts_and_transactions_threshold_met)).
subject_query(transactions_zero_days_closed, threshold(clients_financial_counterparts_and_transactions_threshold_met)).
subject_query(clients_reference_period_days_named, threshold(clients_financial_counterparts_and_transactions_threshold_met)).
subject_query(relevant_clients_affected, threshold(clients_financial_counterparts_and_transactions_threshold_met)).
subject_query(reputational_media_true, threshold(reputational_impact_threshold_met)).
subject_query(reputational_all_false, threshold(reputational_impact_threshold_met)).
subject_query(duration_over_twenty_four_hours, threshold(duration_and_service_downtime_threshold_met)).
subject_query(downtime_over_two_hours, threshold(duration_and_service_downtime_threshold_met)).
subject_query(duration_and_downtime_at_limits, threshold(duration_and_service_downtime_threshold_met)).
subject_query(geographical_two_member_states, threshold(geographical_spread_threshold_met)).
subject_query(geographical_one_member_state, threshold(geographical_spread_threshold_met)).
subject_query(data_impact_adverse_and_integrity, threshold(data_losses_impact_threshold_met)).
subject_query(data_impact_not_adverse, threshold(data_losses_impact_threshold_met)).
subject_query(data_impact_authenticity_named, threshold(data_losses_impact_threshold_met)).
subject_query(data_impact_adverse_referred, threshold(data_losses_impact_threshold_met)).
subject_query(economic_one_cent_over_limit, threshold(economic_impact_threshold_met)).
subject_query(economic_exactly_at_limit, threshold(economic_impact_threshold_met)).
subject_query(economic_likely_to_exceed, threshold(economic_impact_threshold_met)).
subject_query(economic_first_amount_named, threshold(economic_impact_threshold_met)).
subject_query(input_unknown_key_and_wrong_type, threshold(economic_impact_threshold_met)).
subject_query(input_bad_threshold, threshold(major)).
subject_query(final_report_leap_year_on_due, final_report(date(2024, 1, 31), date(2024, 2, 29))).
subject_query(final_report_leap_year_day_after, final_report(date(2024, 1, 31), date(2024, 3, 1))).
subject_query(final_report_february_on_due, final_report(date(2025, 1, 31), date(2025, 2, 28))).
subject_query(final_report_february_day_after, final_report(date(2025, 1, 31), date(2025, 3, 1))).
subject_query(final_report_weekend_extension_true, final_report(date(2025, 5, 31), date(2025, 7, 1))).
subject_query(final_report_weekend_extension_false, final_report(date(2025, 5, 31), date(2025, 7, 1))).
subject_query(final_report_december_on_due, final_report(date(2025, 12, 15), date(2026, 1, 15))).
subject_query(final_report_december_extension_needed, final_report(date(2025, 12, 15), date(2026, 1, 16))).
subject_query(final_report_not_a_date, final_report(date(2025, 2, 29), date(2025, 3, 1))).

dora_incident_classification_thresholds_subject(Subject) :-
    subject_query(Subject, _).

dora_incident_classification_thresholds_profile_for(critical_services_one_point_true, [attribute(affects_authorised_registered_or_supervised_financial_services, true)]).
dora_incident_classification_thresholds_profile_for(critical_services_all_points_false, [attribute(affects_ict_services_supporting_critical_or_important_functions, false), attribute(affects_authorised_registered_or_supervised_financial_services, false), attribute(successful_malicious_unauthorised_access, false)]).
dora_incident_classification_thresholds_profile_for(critical_services_unsure_referred, [attribute(successful_malicious_unauthorised_access, false), attribute(affects_authorised_registered_or_supervised_financial_services, false), attribute(affects_ict_services_supporting_critical_or_important_functions, unsure)]).
dora_incident_classification_thresholds_profile_for(malicious_access_both_true, [attribute(successful_malicious_unauthorised_access, true), attribute(access_may_result_in_data_losses, true)]).
dora_incident_classification_thresholds_profile_for(malicious_access_data_losses_false, [attribute(successful_malicious_unauthorised_access, true), attribute(access_may_result_in_data_losses, false)]).
dora_incident_classification_thresholds_profile_for(clients_over_absolute_limit, [attribute(affected_clients, 100001)]).
dora_incident_classification_thresholds_profile_for(clients_at_absolute_limit, [attribute(affected_clients, 100000), attribute(clients_using_affected_service, 1000000), attribute(affected_financial_counterparts, 0), attribute(affected_transactions_number, 0), attribute(affected_transactions_amount, 0), attribute(relevant_clients_or_financial_counterparts_affected, false)]).
dora_incident_classification_thresholds_profile_for(clients_share_above_ten_percent, [attribute(affected_clients, 11), attribute(clients_using_affected_service, 100)]).
dora_incident_classification_thresholds_profile_for(clients_share_at_ten_percent, [attribute(affected_clients, 10), attribute(clients_using_affected_service, 100), attribute(affected_financial_counterparts, 0), attribute(affected_transactions_number, 0), attribute(affected_transactions_amount, 0), attribute(relevant_clients_or_financial_counterparts_affected, false)]).
dora_incident_classification_thresholds_profile_for(counterparts_share_above_thirty_percent, [attribute(affected_financial_counterparts, 4), attribute(financial_counterparts_of_affected_service, 10)]).
dora_incident_classification_thresholds_profile_for(counterparts_share_at_thirty_percent, [attribute(affected_clients, 0), attribute(affected_financial_counterparts, 3), attribute(financial_counterparts_of_affected_service, 10), attribute(affected_transactions_number, 0), attribute(affected_transactions_amount, 0), attribute(relevant_clients_or_financial_counterparts_affected, false)]).
dora_incident_classification_thresholds_profile_for(transactions_above_daily_average_share, [attribute(affected_clients, 0), attribute(affected_financial_counterparts, 0), attribute(affected_transactions_number, 11), attribute(affected_transactions_amount, 0), attribute(reference_period_transactions_number, 3000), attribute(reference_period_days, 30), attribute(relevant_clients_or_financial_counterparts_affected, false)]).
dora_incident_classification_thresholds_profile_for(transactions_at_daily_average_share, [attribute(affected_clients, 0), attribute(affected_financial_counterparts, 0), attribute(affected_transactions_number, 10), attribute(affected_transactions_amount, 0), attribute(reference_period_transactions_number, 3000), attribute(reference_period_days, 30), attribute(relevant_clients_or_financial_counterparts_affected, false)]).
dora_incident_classification_thresholds_profile_for(transactions_zero_total_with_one_day, [attribute(affected_transactions_number, 1), attribute(reference_period_transactions_number, 0), attribute(reference_period_days, 1)]).
dora_incident_classification_thresholds_profile_for(transactions_zero_days_closed, [attribute(affected_clients, 0), attribute(affected_financial_counterparts, 0), attribute(affected_transactions_number, 1), attribute(reference_period_transactions_number, 0), attribute(reference_period_days, 0), attribute(relevant_clients_or_financial_counterparts_affected, false)]).
dora_incident_classification_thresholds_profile_for(clients_reference_period_days_named, [attribute(affected_clients, 0), attribute(relevant_clients_or_financial_counterparts_affected, false), attribute(affected_financial_counterparts, 0)]).
dora_incident_classification_thresholds_profile_for(relevant_clients_affected, [attribute(relevant_clients_or_financial_counterparts_affected, true)]).
dora_incident_classification_thresholds_profile_for(reputational_media_true, [attribute(incident_reflected_in_media, true)]).
dora_incident_classification_thresholds_profile_for(reputational_all_false, [attribute(incident_reflected_in_media, false), attribute(repetitive_complaints_from_different_clients_or_counterparts, false), attribute(regulatory_requirements_likely_not_met, false), attribute(material_loss_of_clients_or_counterparts_likely, false)]).
dora_incident_classification_thresholds_profile_for(duration_over_twenty_four_hours, [attribute(incident_duration_seconds, 86401)]).
dora_incident_classification_thresholds_profile_for(downtime_over_two_hours, [attribute(incident_duration_seconds, 86400), attribute(critical_or_important_function_service_downtime_seconds, 7201)]).
dora_incident_classification_thresholds_profile_for(duration_and_downtime_at_limits, [attribute(incident_duration_seconds, 86400), attribute(critical_or_important_function_service_downtime_seconds, 7200)]).
dora_incident_classification_thresholds_profile_for(geographical_two_member_states, [attribute(member_states_with_impact, 2)]).
dora_incident_classification_thresholds_profile_for(geographical_one_member_state, [attribute(member_states_with_impact, 1)]).
dora_incident_classification_thresholds_profile_for(data_impact_adverse_and_integrity, [attribute(data_impact_adverse_to_business_objectives_or_regulatory_requirements, true), attribute(data_integrity_impact, true)]).
dora_incident_classification_thresholds_profile_for(data_impact_not_adverse, [attribute(data_impact_adverse_to_business_objectives_or_regulatory_requirements, false), attribute(data_integrity_impact, true)]).
dora_incident_classification_thresholds_profile_for(data_impact_authenticity_named, [attribute(data_impact_adverse_to_business_objectives_or_regulatory_requirements, unsure), attribute(data_availability_impact, unsure)]).
dora_incident_classification_thresholds_profile_for(data_impact_adverse_referred, [attribute(data_impact_adverse_to_business_objectives_or_regulatory_requirements, unsure), attribute(data_availability_impact, true), attribute(data_authenticity_impact, false), attribute(data_integrity_impact, false), attribute(data_confidentiality_impact, false)]).
dora_incident_classification_thresholds_profile_for(economic_one_cent_over_limit, [attribute(expropriated_funds_and_assets_cents, 0), attribute(replacement_and_relocation_costs_cents, 0), attribute(staff_costs_cents, 0), attribute(contractual_non_compliance_fees_cents, 0), attribute(redress_and_compensation_costs_cents, 0), attribute(forgone_revenue_losses_cents, 0), attribute(communication_costs_cents, 1), attribute(advisory_costs_cents, 10000000), attribute(costs_and_losses_likely_to_exceed_threshold, false)]).
dora_incident_classification_thresholds_profile_for(economic_exactly_at_limit, [attribute(expropriated_funds_and_assets_cents, 0), attribute(replacement_and_relocation_costs_cents, 0), attribute(staff_costs_cents, 0), attribute(contractual_non_compliance_fees_cents, 0), attribute(redress_and_compensation_costs_cents, 0), attribute(forgone_revenue_losses_cents, 0), attribute(communication_costs_cents, 0), attribute(advisory_costs_cents, 10000000), attribute(costs_and_losses_likely_to_exceed_threshold, false)]).
dora_incident_classification_thresholds_profile_for(economic_likely_to_exceed, [attribute(costs_and_losses_likely_to_exceed_threshold, true)]).
dora_incident_classification_thresholds_profile_for(economic_first_amount_named, []).
dora_incident_classification_thresholds_profile_for(input_unknown_key_and_wrong_type, [attribute(staff_costs_cents, -5), attribute(colour, red)]).
dora_incident_classification_thresholds_profile_for(input_bad_threshold, []).
dora_incident_classification_thresholds_profile_for(final_report_leap_year_on_due, []).
dora_incident_classification_thresholds_profile_for(final_report_leap_year_day_after, [attribute(final_report_weekend_extension, false)]).
dora_incident_classification_thresholds_profile_for(final_report_february_on_due, []).
dora_incident_classification_thresholds_profile_for(final_report_february_day_after, [attribute(final_report_weekend_extension, false)]).
dora_incident_classification_thresholds_profile_for(final_report_weekend_extension_true, [attribute(final_report_weekend_extension, true)]).
dora_incident_classification_thresholds_profile_for(final_report_weekend_extension_false, [attribute(final_report_weekend_extension, false)]).
dora_incident_classification_thresholds_profile_for(final_report_december_on_due, []).
dora_incident_classification_thresholds_profile_for(final_report_december_extension_needed, []).
dora_incident_classification_thresholds_profile_for(final_report_not_a_date, []).

query_request(threshold(Threshold), Profile, threshold_query(Profile, Threshold)).
query_request(final_report(LatestIntermediateDate, FinalDate), Profile, final_report_query(Profile, LatestIntermediateDate, FinalDate)).

subject_request(Subject, Request) :-
    subject_query(Subject, Query),
    dora_incident_classification_thresholds_profile_for(Subject, Profile),
    query_request(Query, Profile, Request).

dora_incident_classification_thresholds_assess(Subject, Result) :-
    subject_request(Subject, Request),
    decide_dora_incident_classification_thresholds(Request, Result).
