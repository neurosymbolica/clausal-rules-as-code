% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_incident_classification_thresholds_tests_test_public_interface, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_dora_incident_classification_thresholds_dora_incident_classification_thresholds, [decide_dora_incident_classification_thresholds/2, dora_incident_classification_thresholds_status/2, dora_incident_classification_thresholds_checklist/2, dora_incident_classification_thresholds_decision_resolvable/1, dora_incident_classification_thresholds_status_values/1, dora_incident_threshold_status/4, dora_final_report_timeliness/5]).
:- use_module(m__eu_dora_incident_classification_thresholds_fixtures, [dora_incident_classification_thresholds_subject/1, dora_incident_classification_thresholds_profile_for/2, dora_incident_classification_thresholds_assess/2]).

subject_status(Subject, Status) :-
    dora_incident_classification_thresholds_assess(Subject, dora_incident_classification_thresholds_verdict(Status, _)).

subject_citations(Subject, Citations) :-
    dora_incident_classification_thresholds_assess(Subject, dora_incident_classification_thresholds_verdict(_, Citations)).

exactly_one_verdict(Subject) :-
    findall(Verdict, dora_incident_classification_thresholds_assess(Subject, Verdict), Verdicts),
    length(Verdicts, 1).

test(status_values_are_the_final_threshold_answers) :-
    dora_incident_classification_thresholds_status_values(StatusValues),
    StatusValues == [met, not_met].
test(every_subject_is_named_once) :-
    findall(Subject, dora_incident_classification_thresholds_subject(Subject), Subjects),
    sort(Subjects, Sorted),
    length(Subjects, Count),
    length(Sorted, Count),
    Count > 0.
test(every_subject_has_exactly_one_verdict) :-
    findall(Subject, dora_incident_classification_thresholds_subject(Subject), Subjects),
    maplist(exactly_one_verdict, Subjects).
test(critical_services_one_point_true_is_met) :-
    subject_status(critical_services_one_point_true, Status),
    Status == met,
    subject_citations(critical_services_one_point_true, Citations),
    Citations == [cite(eu_reg_2022_2554_art_18_1), cite(eu_reg_2024_1772_art_8_1), cite(eu_reg_2024_1772_art_6)].
test(critical_services_all_points_false_is_not_met) :-
    subject_status(critical_services_all_points_false, Status),
    Status == not_met.
test(critical_services_unsure_is_referred) :-
    subject_status(critical_services_unsure_referred, Status),
    Status == needs_legal_review(open_textured(affects_ict_services_supporting_critical_or_important_functions, cite(eu_reg_2024_1772_art_6)), [inputs_relied_on([affects_ict_services_supporting_critical_or_important_functions - unsure, affects_authorised_registered_or_supervised_financial_services - false, successful_malicious_unauthorised_access - false])]),
    subject_citations(critical_services_unsure_referred, Citations),
    Citations == [].
test(malicious_access_both_true_is_met) :-
    subject_status(malicious_access_both_true, Status),
    Status == met,
    subject_citations(malicious_access_both_true, Citations),
    Citations == [cite(eu_reg_2022_2554_art_18_1), cite(eu_reg_2024_1772_art_9_5_b)].
test(malicious_access_data_losses_false_is_not_met) :-
    subject_status(malicious_access_data_losses_false, Status),
    Status == not_met.
test(clients_over_absolute_limit_is_met) :-
    subject_status(clients_over_absolute_limit, Status),
    Status == met,
    subject_citations(clients_over_absolute_limit, Citations),
    Citations == [cite(eu_reg_2022_2554_art_18_1), cite(eu_reg_2024_1772_art_9_1), cite(eu_reg_2024_1772_art_1)].
test(clients_at_absolute_limit_is_not_met) :-
    subject_status(clients_at_absolute_limit, Status),
    Status == not_met.
test(clients_share_above_ten_percent_is_met) :-
    subject_status(clients_share_above_ten_percent, Status),
    Status == met.
test(clients_share_at_ten_percent_is_not_met) :-
    subject_status(clients_share_at_ten_percent, Status),
    Status == not_met.
test(counterparts_share_above_thirty_percent_is_met) :-
    subject_status(counterparts_share_above_thirty_percent, Status),
    Status == met.
test(counterparts_share_at_thirty_percent_is_not_met) :-
    subject_status(counterparts_share_at_thirty_percent, Status),
    Status == not_met.
test(transactions_above_daily_average_share_is_met) :-
    subject_status(transactions_above_daily_average_share, Status),
    Status == met.
test(transactions_at_daily_average_share_is_not_met) :-
    subject_status(transactions_at_daily_average_share, Status),
    Status == not_met.
test(transactions_zero_total_with_one_day_is_met) :-
    subject_status(transactions_zero_total_with_one_day, Status),
    Status == met.
test(transactions_zero_days_closes_the_points) :-
    subject_status(transactions_zero_days_closed, Status),
    Status == not_met.
test(clients_reference_period_days_is_named_first) :-
    subject_status(clients_reference_period_days_named, Status),
    Status == indeterminate([reference_period_days]),
    subject_citations(clients_reference_period_days_named, Citations),
    Citations == [].
test(relevant_clients_affected_is_met) :-
    subject_status(relevant_clients_affected, Status),
    Status == met.
test(reputational_media_true_is_met) :-
    subject_status(reputational_media_true, Status),
    Status == met,
    subject_citations(reputational_media_true, Citations),
    Citations == [cite(eu_reg_2022_2554_art_18_1), cite(eu_reg_2024_1772_art_9_2), cite(eu_reg_2024_1772_art_2)].
test(reputational_all_false_is_not_met) :-
    subject_status(reputational_all_false, Status),
    Status == not_met.
test(duration_over_twenty_four_hours_is_met) :-
    subject_status(duration_over_twenty_four_hours, Status),
    Status == met,
    subject_citations(duration_over_twenty_four_hours, Citations),
    Citations == [cite(eu_reg_2022_2554_art_18_1), cite(eu_reg_2024_1772_art_9_3), cite(eu_reg_2024_1772_art_3)].
test(downtime_over_two_hours_is_met) :-
    subject_status(downtime_over_two_hours, Status),
    Status == met.
test(duration_and_downtime_at_limits_is_not_met) :-
    subject_status(duration_and_downtime_at_limits, Status),
    Status == not_met.
test(geographical_two_member_states_is_met) :-
    subject_status(geographical_two_member_states, Status),
    Status == met,
    subject_citations(geographical_two_member_states, Citations),
    Citations == [cite(eu_reg_2022_2554_art_18_1), cite(eu_reg_2024_1772_art_9_4), cite(eu_reg_2024_1772_art_4)].
test(geographical_one_member_state_is_not_met) :-
    subject_status(geographical_one_member_state, Status),
    Status == not_met.
test(data_impact_adverse_and_integrity_is_met) :-
    subject_status(data_impact_adverse_and_integrity, Status),
    Status == met,
    subject_citations(data_impact_adverse_and_integrity, Citations),
    Citations == [cite(eu_reg_2022_2554_art_18_1), cite(eu_reg_2024_1772_art_9_5_a), cite(eu_reg_2024_1772_art_5)].
test(data_impact_not_adverse_is_not_met) :-
    subject_status(data_impact_not_adverse, Status),
    Status == not_met.
test(data_impact_absent_key_is_named_before_referral) :-
    subject_status(data_impact_authenticity_named, Status),
    Status == indeterminate([data_authenticity_impact]).
test(data_impact_unsure_adverse_is_referred) :-
    subject_status(data_impact_adverse_referred, Status),
    Status == needs_legal_review(open_textured(data_impact_adverse_to_business_objectives_or_regulatory_requirements, cite(eu_reg_2024_1772_art_9_5_a)), [inputs_relied_on([data_impact_adverse_to_business_objectives_or_regulatory_requirements - unsure, data_availability_impact - true, data_authenticity_impact - false, data_integrity_impact - false, data_confidentiality_impact - false])]),
    subject_citations(data_impact_adverse_referred, Citations),
    Citations == [].
test(economic_one_cent_over_limit_is_met) :-
    subject_status(economic_one_cent_over_limit, Status),
    Status == met,
    subject_citations(economic_one_cent_over_limit, Citations),
    Citations == [cite(eu_reg_2022_2554_art_18_1), cite(eu_reg_2024_1772_art_9_6), cite(eu_reg_2024_1772_art_7)].
test(economic_exactly_at_limit_is_not_met) :-
    subject_status(economic_exactly_at_limit, Status),
    Status == not_met.
test(economic_likely_to_exceed_is_met) :-
    subject_status(economic_likely_to_exceed, Status),
    Status == met.
test(economic_first_amount_is_named) :-
    subject_status(economic_first_amount_named, Status),
    Status == indeterminate([expropriated_funds_and_assets_cents]).
test(wrong_type_and_unknown_key_are_input_problems) :-
    subject_status(input_unknown_key_and_wrong_type, Status),
    Status == input_problems([wrong_type(staff_costs_cents), unknown_key(colour)]),
    subject_citations(input_unknown_key_and_wrong_type, Citations),
    Citations == [].
test(a_bad_threshold_is_an_input_problem) :-
    subject_status(input_bad_threshold, Status),
    Status == input_problems([wrong_type(threshold)]).
test(final_report_leap_year_on_due_is_on_time) :-
    subject_status(final_report_leap_year_on_due, Status),
    Status == on_time,
    subject_citations(final_report_leap_year_on_due, Citations),
    Citations == [cite(eu_reg_2025_301_art_5_1_c)].
test(final_report_leap_year_day_after_is_late) :-
    subject_status(final_report_leap_year_day_after, Status),
    Status == late(month_limit).
test(final_report_february_on_due_is_on_time) :-
    subject_status(final_report_february_on_due, Status),
    Status == on_time.
test(final_report_february_day_after_is_late) :-
    subject_status(final_report_february_day_after, Status),
    Status == late(month_limit),
    subject_citations(final_report_february_day_after, Citations),
    Citations == [cite(eu_reg_2025_301_art_5_1_c), cite(eu_reg_2025_301_art_5_4), cite(eu_reg_2025_301_art_5_5), cite(eu_reg_2025_301_art_5_6)].
test(final_report_weekend_extension_true_is_on_time) :-
    subject_status(final_report_weekend_extension_true, Status),
    Status == on_time,
    subject_citations(final_report_weekend_extension_true, Citations),
    Citations == [cite(eu_reg_2025_301_art_5_1_c), cite(eu_reg_2025_301_art_5_4), cite(eu_reg_2025_301_art_5_5), cite(eu_reg_2025_301_art_5_6)].
test(final_report_weekend_extension_false_is_late) :-
    subject_status(final_report_weekend_extension_false, Status),
    Status == late(month_limit).
test(final_report_december_on_due_is_on_time) :-
    subject_status(final_report_december_on_due, Status),
    Status == on_time.
test(final_report_december_day_after_needs_the_weekend_key) :-
    subject_status(final_report_december_extension_needed, Status),
    Status == indeterminate([final_report_weekend_extension]),
    subject_citations(final_report_december_extension_needed, Citations),
    Citations == [].
test(final_report_not_a_date_is_an_input_problem) :-
    subject_status(final_report_not_a_date, Status),
    Status == input_problems([wrong_type(latest_intermediate_date)]).
test(direct_critical_services_affected_met) :-
    findall(Status - Citations, dora_incident_threshold_status([attribute(affects_ict_services_supporting_critical_or_important_functions, true)], critical_services_affected, Status, Citations), Answers),
    Answers == [met - [cite(eu_reg_2022_2554_art_18_1), cite(eu_reg_2024_1772_art_8_1), cite(eu_reg_2024_1772_art_6)]].
test(direct_critical_services_affected_not_met) :-
    Profile = [attribute(affects_ict_services_supporting_critical_or_important_functions, false), attribute(affects_authorised_registered_or_supervised_financial_services, false), attribute(successful_malicious_unauthorised_access, false)],
    dora_incident_threshold_status(Profile, critical_services_affected, Status, _),
    Status == not_met.
test(direct_critical_services_affected_indeterminate) :-
    dora_incident_threshold_status([], critical_services_affected, Status, Citations),
    Status == indeterminate([affects_ict_services_supporting_critical_or_important_functions]),
    Citations == [].
test(direct_critical_services_affected_referred) :-
    Profile = [attribute(affects_ict_services_supporting_critical_or_important_functions, false), attribute(affects_authorised_registered_or_supervised_financial_services, unsure), attribute(successful_malicious_unauthorised_access, false)],
    dora_incident_threshold_status(Profile, critical_services_affected, Status, Citations),
    Status == needs_legal_review(open_textured(affects_authorised_registered_or_supervised_financial_services, cite(eu_reg_2024_1772_art_6)), [inputs_relied_on([affects_ict_services_supporting_critical_or_important_functions - false, affects_authorised_registered_or_supervised_financial_services - unsure, successful_malicious_unauthorised_access - false])]),
    Citations == [].
test(direct_data_losses_malicious_access_threshold_met_met) :-
    Profile = [attribute(successful_malicious_unauthorised_access, true), attribute(access_may_result_in_data_losses, true)],
    dora_incident_threshold_status(Profile, data_losses_malicious_access_threshold_met, Status, Citations),
    Status == met,
    Citations == [cite(eu_reg_2022_2554_art_18_1), cite(eu_reg_2024_1772_art_9_5_b)].
test(direct_data_losses_malicious_access_threshold_met_not_met) :-
    dora_incident_threshold_status([attribute(successful_malicious_unauthorised_access, false)], data_losses_malicious_access_threshold_met, Status, _),
    Status == not_met.
test(direct_data_losses_malicious_access_threshold_met_indeterminate) :-
    dora_incident_threshold_status([attribute(successful_malicious_unauthorised_access, true)], data_losses_malicious_access_threshold_met, Status, Citations),
    Status == indeterminate([access_may_result_in_data_losses]),
    Citations == [].
test(direct_data_losses_malicious_access_threshold_met_referred) :-
    Profile = [attribute(successful_malicious_unauthorised_access, true), attribute(access_may_result_in_data_losses, unsure)],
    dora_incident_threshold_status(Profile, data_losses_malicious_access_threshold_met, Status, Citations),
    Status == needs_legal_review(open_textured(access_may_result_in_data_losses, cite(eu_reg_2024_1772_art_9_5_b)), [inputs_relied_on([successful_malicious_unauthorised_access - true, access_may_result_in_data_losses - unsure])]),
    Citations == [].
test(direct_clients_financial_counterparts_and_transactions_threshold_met_met) :-
    dora_incident_threshold_status([attribute(affected_clients, 100001)], clients_financial_counterparts_and_transactions_threshold_met, Status, Citations),
    Status == met,
    Citations == [cite(eu_reg_2022_2554_art_18_1), cite(eu_reg_2024_1772_art_9_1), cite(eu_reg_2024_1772_art_1)].
test(direct_clients_financial_counterparts_and_transactions_threshold_met_not_met) :-
    Profile = [attribute(affected_clients, 0), attribute(affected_financial_counterparts, 0), attribute(reference_period_days, 0), attribute(relevant_clients_or_financial_counterparts_affected, false)],
    dora_incident_threshold_status(Profile, clients_financial_counterparts_and_transactions_threshold_met, Status, _),
    Status == not_met.
test(direct_clients_financial_counterparts_and_transactions_threshold_met_indeterminate) :-
    dora_incident_threshold_status([attribute(affected_clients, 0)], clients_financial_counterparts_and_transactions_threshold_met, Status, Citations),
    Status == indeterminate([relevant_clients_or_financial_counterparts_affected]),
    Citations == [].
test(direct_reputational_impact_threshold_met_met) :-
    dora_incident_threshold_status([attribute(regulatory_requirements_likely_not_met, true)], reputational_impact_threshold_met, Status, Citations),
    Status == met,
    Citations == [cite(eu_reg_2022_2554_art_18_1), cite(eu_reg_2024_1772_art_9_2), cite(eu_reg_2024_1772_art_2)].
test(direct_reputational_impact_threshold_met_not_met) :-
    Profile = [attribute(incident_reflected_in_media, false), attribute(repetitive_complaints_from_different_clients_or_counterparts, false), attribute(regulatory_requirements_likely_not_met, false), attribute(material_loss_of_clients_or_counterparts_likely, false)],
    dora_incident_threshold_status(Profile, reputational_impact_threshold_met, Status, _),
    Status == not_met.
test(direct_reputational_impact_threshold_met_indeterminate) :-
    Profile = [attribute(repetitive_complaints_from_different_clients_or_counterparts, false), attribute(regulatory_requirements_likely_not_met, false), attribute(material_loss_of_clients_or_counterparts_likely, false)],
    dora_incident_threshold_status(Profile, reputational_impact_threshold_met, Status, Citations),
    Status == indeterminate([incident_reflected_in_media]),
    Citations == [].
test(direct_reputational_impact_threshold_met_referred) :-
    Profile = [attribute(incident_reflected_in_media, unsure), attribute(repetitive_complaints_from_different_clients_or_counterparts, false), attribute(regulatory_requirements_likely_not_met, false), attribute(material_loss_of_clients_or_counterparts_likely, false)],
    dora_incident_threshold_status(Profile, reputational_impact_threshold_met, Status, Citations),
    Status == needs_legal_review(open_textured(incident_reflected_in_media, cite(eu_reg_2024_1772_art_9_2)), [inputs_relied_on([incident_reflected_in_media - unsure, repetitive_complaints_from_different_clients_or_counterparts - false, regulatory_requirements_likely_not_met - false, material_loss_of_clients_or_counterparts_likely - false])]),
    Citations == [].
test(direct_duration_and_service_downtime_threshold_met_met) :-
    dora_incident_threshold_status([attribute(incident_duration_seconds, 86401)], duration_and_service_downtime_threshold_met, Status, Citations),
    Status == met,
    Citations == [cite(eu_reg_2022_2554_art_18_1), cite(eu_reg_2024_1772_art_9_3), cite(eu_reg_2024_1772_art_3)].
test(direct_duration_and_service_downtime_threshold_met_not_met) :-
    Profile = [attribute(incident_duration_seconds, 86400), attribute(critical_or_important_function_service_downtime_seconds, 7200)],
    dora_incident_threshold_status(Profile, duration_and_service_downtime_threshold_met, Status, _),
    Status == not_met.
test(direct_duration_and_service_downtime_threshold_met_indeterminate) :-
    dora_incident_threshold_status([attribute(incident_duration_seconds, 100)], duration_and_service_downtime_threshold_met, Status, Citations),
    Status == indeterminate([critical_or_important_function_service_downtime_seconds]),
    Citations == [].
test(direct_geographical_spread_threshold_met_met) :-
    dora_incident_threshold_status([attribute(member_states_with_impact, 2)], geographical_spread_threshold_met, Status, _),
    Status == met.
test(direct_geographical_spread_threshold_met_not_met) :-
    dora_incident_threshold_status([attribute(member_states_with_impact, 1)], geographical_spread_threshold_met, Status, _),
    Status == not_met.
test(direct_geographical_spread_threshold_met_indeterminate) :-
    dora_incident_threshold_status([], geographical_spread_threshold_met, Status, Citations),
    Status == indeterminate([member_states_with_impact]),
    Citations == [].
test(direct_data_losses_impact_threshold_met_met) :-
    Profile = [attribute(data_impact_adverse_to_business_objectives_or_regulatory_requirements, true), attribute(data_confidentiality_impact, true)],
    dora_incident_threshold_status(Profile, data_losses_impact_threshold_met, Status, Citations),
    Status == met,
    Citations == [cite(eu_reg_2022_2554_art_18_1), cite(eu_reg_2024_1772_art_9_5_a), cite(eu_reg_2024_1772_art_5)].
test(direct_data_losses_impact_threshold_met_not_met) :-
    dora_incident_threshold_status([attribute(data_impact_adverse_to_business_objectives_or_regulatory_requirements, false)], data_losses_impact_threshold_met, Status, _),
    Status == not_met.
test(direct_data_losses_impact_threshold_met_indeterminate) :-
    dora_incident_threshold_status([], data_losses_impact_threshold_met, Status, Citations),
    Status == indeterminate([data_impact_adverse_to_business_objectives_or_regulatory_requirements]),
    Citations == [].
test(direct_data_losses_impact_threshold_met_referred) :-
    Profile = [attribute(data_impact_adverse_to_business_objectives_or_regulatory_requirements, unsure), attribute(data_availability_impact, true), attribute(data_authenticity_impact, false), attribute(data_integrity_impact, false), attribute(data_confidentiality_impact, false)],
    dora_incident_threshold_status(Profile, data_losses_impact_threshold_met, Status, Citations),
    Status = needs_legal_review(open_textured(Key, cite(CitationKey)), [inputs_relied_on(_)|_]),
    Key == data_impact_adverse_to_business_objectives_or_regulatory_requirements,
    CitationKey == eu_reg_2024_1772_art_9_5_a,
    Citations == [].
test(direct_economic_impact_threshold_met_met) :-
    dora_incident_threshold_status([attribute(staff_costs_cents, 10000001)], economic_impact_threshold_met, Status, Citations),
    Status == met,
    Citations == [cite(eu_reg_2022_2554_art_18_1), cite(eu_reg_2024_1772_art_9_6), cite(eu_reg_2024_1772_art_7)].
test(direct_economic_impact_threshold_met_not_met) :-
    Profile = [attribute(expropriated_funds_and_assets_cents, 0), attribute(replacement_and_relocation_costs_cents, 0), attribute(staff_costs_cents, 0), attribute(contractual_non_compliance_fees_cents, 0), attribute(redress_and_compensation_costs_cents, 0), attribute(forgone_revenue_losses_cents, 0), attribute(communication_costs_cents, 0), attribute(advisory_costs_cents, 10000000), attribute(costs_and_losses_likely_to_exceed_threshold, false)],
    dora_incident_threshold_status(Profile, economic_impact_threshold_met, Status, _),
    Status == not_met.
test(direct_economic_impact_threshold_met_indeterminate) :-
    dora_incident_threshold_status([], economic_impact_threshold_met, Status, Citations),
    Status == indeterminate([expropriated_funds_and_assets_cents]),
    Citations == [].
test(direct_economic_impact_threshold_met_referred) :-
    Profile = [attribute(expropriated_funds_and_assets_cents, 0), attribute(replacement_and_relocation_costs_cents, 0), attribute(staff_costs_cents, 0), attribute(contractual_non_compliance_fees_cents, 0), attribute(redress_and_compensation_costs_cents, 0), attribute(forgone_revenue_losses_cents, 0), attribute(communication_costs_cents, 0), attribute(advisory_costs_cents, 10000000), attribute(costs_and_losses_likely_to_exceed_threshold, unsure)],
    dora_incident_threshold_status(Profile, economic_impact_threshold_met, Status, Citations),
    Status = needs_legal_review(open_textured(Key, cite(CitationKey)), _),
    Key == costs_and_losses_likely_to_exceed_threshold,
    CitationKey == eu_reg_2024_1772_art_9_6,
    Citations == [].
test(direct_threshold_status_input_problems) :-
    dora_incident_threshold_status([attribute(colour, blue)], not_a_condition, Status, Citations),
    Status == input_problems([unknown_key(colour), wrong_type(threshold)]),
    Citations == [].
test(direct_threshold_status_has_exactly_one_solution) :-
    findall(Status, dora_incident_threshold_status([], clients_financial_counterparts_and_transactions_threshold_met, Status, _), Statuses),
    length(Statuses, 1).
test(direct_final_report_timeliness_on_time) :-
    findall(Result - Citations, dora_final_report_timeliness([], date(2025, 1, 31), date(2025, 2, 28), Result, Citations), Answers),
    Answers == [on_time - [cite(eu_reg_2025_301_art_5_1_c)]].
test(direct_final_report_timeliness_late) :-
    dora_final_report_timeliness([attribute(final_report_weekend_extension, false)], date(2025, 1, 31), date(2025, 3, 1), Result, Citations),
    Result == late(month_limit),
    Citations == [cite(eu_reg_2025_301_art_5_1_c), cite(eu_reg_2025_301_art_5_4), cite(eu_reg_2025_301_art_5_5), cite(eu_reg_2025_301_art_5_6)].
test(direct_final_report_timeliness_on_time_by_extension) :-
    dora_final_report_timeliness([attribute(final_report_weekend_extension, true)], date(2025, 5, 31), date(2025, 7, 1), Result, _),
    Result == on_time.
test(direct_final_report_timeliness_indeterminate) :-
    dora_final_report_timeliness([], date(2025, 12, 15), date(2026, 1, 16), Result, Citations),
    Result == indeterminate([final_report_weekend_extension]),
    Citations == [].
test(direct_final_report_timeliness_input_problems) :-
    dora_final_report_timeliness([], date(2025, 2, 29), date(2024.0, 1, 1), Result, Citations),
    Result == input_problems([wrong_type(latest_intermediate_date), wrong_type(final_date)]),
    Citations == [].
test(provenance_item_may_follow_inputs_relied_on) :-
    Context = [inputs_relied_on([incident_reflected_in_media - unsure]), provenance(reputational_impact_threshold_met, [cite(eu_reg_2024_1772_art_9_2)])],
    Context = [inputs_relied_on(Pairs), provenance(Clause, ProvenanceCitations)],
    Pairs == [incident_reflected_in_media - unsure],
    Clause == reputational_impact_threshold_met,
    ProvenanceCitations == [cite(eu_reg_2024_1772_art_9_2)].
test(referral_context_opens_with_inputs_relied_on_not_provenance) :-
    Profile = [attribute(incident_reflected_in_media, unsure), attribute(repetitive_complaints_from_different_clients_or_counterparts, false), attribute(regulatory_requirements_likely_not_met, false), attribute(material_loss_of_clients_or_counterparts_likely, false)],
    dora_incident_threshold_status(Profile, reputational_impact_threshold_met, needs_legal_review(_, [FirstItem|_]), _),
    FirstItem = inputs_relied_on(_),
    dif(FirstItem, provenance(_, _)).
test(status_projection_agrees_with_the_verdict) :-
    dora_incident_classification_thresholds_profile_for(geographical_two_member_states, Profile),
    dora_incident_classification_thresholds_status(threshold_query(Profile, geographical_spread_threshold_met), Status),
    Status == met.
test(decide_gives_the_verdict_term) :-
    dora_incident_classification_thresholds_profile_for(geographical_one_member_state, Profile),
    decide_dora_incident_classification_thresholds(threshold_query(Profile, geographical_spread_threshold_met), dora_incident_classification_thresholds_verdict(Status, _)),
    Status == not_met.
test(checklist_is_cited_and_has_one_row_per_condition) :-
    dora_incident_classification_thresholds_profile_for(clients_over_absolute_limit, Profile),
    dora_incident_classification_thresholds_checklist(Profile, [FirstItem|OtherItems]),
    length([FirstItem|OtherItems], 8),
    member(item(clients_financial_counterparts_and_transactions_threshold_met, ClientsStatus, ClientsCitations), [FirstItem|OtherItems]),
    ClientsStatus == met,
    ClientsCitations == [cite(eu_reg_2022_2554_art_18_1), cite(eu_reg_2024_1772_art_9_1), cite(eu_reg_2024_1772_art_1)].
test(decision_is_resolvable_on_a_fixture) :-
    dora_incident_classification_thresholds_profile_for(final_report_february_on_due, Profile),
    dora_incident_classification_thresholds_decision_resolvable(final_report_query(Profile, date(2025, 1, 31), date(2025, 2, 28))).

test(critical_services_one_point_true_is_not_not_met, fail) :-
    subject_status(critical_services_one_point_true, not_met).
test(critical_services_all_points_false_is_not_met_only, fail) :-
    subject_status(critical_services_all_points_false, met).
test(malicious_access_data_losses_false_is_not_met_only, fail) :-
    subject_status(malicious_access_data_losses_false, met).
test(clients_at_absolute_limit_is_not_met_only, fail) :-
    subject_status(clients_at_absolute_limit, met).
test(clients_share_at_ten_percent_is_not_met_only, fail) :-
    subject_status(clients_share_at_ten_percent, met).
test(counterparts_share_at_thirty_percent_is_not_met_only, fail) :-
    subject_status(counterparts_share_at_thirty_percent, met).
test(transactions_at_daily_average_share_is_not_met_only, fail) :-
    subject_status(transactions_at_daily_average_share, met).
test(transactions_zero_days_is_not_met_only, fail) :-
    subject_status(transactions_zero_days_closed, met).
test(reputational_all_false_is_not_met_only, fail) :-
    subject_status(reputational_all_false, met).
test(duration_and_downtime_at_limits_is_not_met_only, fail) :-
    subject_status(duration_and_downtime_at_limits, met).
test(geographical_one_member_state_is_not_met_only, fail) :-
    subject_status(geographical_one_member_state, met).
test(data_impact_not_adverse_is_not_met_only, fail) :-
    subject_status(data_impact_not_adverse, met).
test(economic_exactly_at_limit_is_not_met_only, fail) :-
    subject_status(economic_exactly_at_limit, met).
test(final_report_leap_year_day_after_is_not_on_time, fail) :-
    subject_status(final_report_leap_year_day_after, on_time).
test(final_report_weekend_extension_false_is_not_on_time, fail) :-
    subject_status(final_report_weekend_extension_false, on_time).
test(direct_critical_services_affected_not_met_is_not_met_only, fail) :-
    Profile = [attribute(affects_ict_services_supporting_critical_or_important_functions, false), attribute(affects_authorised_registered_or_supervised_financial_services, false), attribute(successful_malicious_unauthorised_access, false)],
    dora_incident_threshold_status(Profile, critical_services_affected, met, _).
test(direct_data_losses_malicious_access_threshold_met_not_met_only, fail) :-
    dora_incident_threshold_status([attribute(successful_malicious_unauthorised_access, false)], data_losses_malicious_access_threshold_met, met, _).
test(direct_reputational_impact_threshold_met_not_met_only, fail) :-
    Profile = [attribute(incident_reflected_in_media, false), attribute(repetitive_complaints_from_different_clients_or_counterparts, false), attribute(regulatory_requirements_likely_not_met, false), attribute(material_loss_of_clients_or_counterparts_likely, false)],
    dora_incident_threshold_status(Profile, reputational_impact_threshold_met, met, _).
test(direct_duration_and_service_downtime_threshold_met_not_met_only, fail) :-
    Profile = [attribute(incident_duration_seconds, 86400), attribute(critical_or_important_function_service_downtime_seconds, 7200)],
    dora_incident_threshold_status(Profile, duration_and_service_downtime_threshold_met, met, _).
test(direct_data_losses_impact_threshold_met_not_met_only, fail) :-
    dora_incident_threshold_status([attribute(data_impact_adverse_to_business_objectives_or_regulatory_requirements, false)], data_losses_impact_threshold_met, met, _).
test(direct_economic_impact_threshold_met_not_met_only, fail) :-
    Profile = [attribute(expropriated_funds_and_assets_cents, 0), attribute(replacement_and_relocation_costs_cents, 0), attribute(staff_costs_cents, 0), attribute(contractual_non_compliance_fees_cents, 0), attribute(redress_and_compensation_costs_cents, 0), attribute(forgone_revenue_losses_cents, 0), attribute(communication_costs_cents, 0), attribute(advisory_costs_cents, 10000000), attribute(costs_and_losses_likely_to_exceed_threshold, false)],
    dora_incident_threshold_status(Profile, economic_impact_threshold_met, met, _).
test(direct_final_report_timeliness_late_is_not_on_time, fail) :-
    dora_final_report_timeliness([attribute(final_report_weekend_extension, false)], date(2025, 1, 31), date(2025, 3, 1), on_time, _).

cp_test_names([status_values_are_the_final_threshold_answers, every_subject_is_named_once, every_subject_has_exactly_one_verdict, critical_services_one_point_true_is_met, critical_services_all_points_false_is_not_met, critical_services_unsure_is_referred, malicious_access_both_true_is_met, malicious_access_data_losses_false_is_not_met, clients_over_absolute_limit_is_met, clients_at_absolute_limit_is_not_met, clients_share_above_ten_percent_is_met, clients_share_at_ten_percent_is_not_met, counterparts_share_above_thirty_percent_is_met, counterparts_share_at_thirty_percent_is_not_met, transactions_above_daily_average_share_is_met, transactions_at_daily_average_share_is_not_met, transactions_zero_total_with_one_day_is_met, transactions_zero_days_closes_the_points, clients_reference_period_days_is_named_first, relevant_clients_affected_is_met, reputational_media_true_is_met, reputational_all_false_is_not_met, duration_over_twenty_four_hours_is_met, downtime_over_two_hours_is_met, duration_and_downtime_at_limits_is_not_met, geographical_two_member_states_is_met, geographical_one_member_state_is_not_met, data_impact_adverse_and_integrity_is_met, data_impact_not_adverse_is_not_met, data_impact_absent_key_is_named_before_referral, data_impact_unsure_adverse_is_referred, economic_one_cent_over_limit_is_met, economic_exactly_at_limit_is_not_met, economic_likely_to_exceed_is_met, economic_first_amount_is_named, wrong_type_and_unknown_key_are_input_problems, a_bad_threshold_is_an_input_problem, final_report_leap_year_on_due_is_on_time, final_report_leap_year_day_after_is_late, final_report_february_on_due_is_on_time, final_report_february_day_after_is_late, final_report_weekend_extension_true_is_on_time, final_report_weekend_extension_false_is_late, final_report_december_on_due_is_on_time, final_report_december_day_after_needs_the_weekend_key, final_report_not_a_date_is_an_input_problem, direct_critical_services_affected_met, direct_critical_services_affected_not_met, direct_critical_services_affected_indeterminate, direct_critical_services_affected_referred, direct_data_losses_malicious_access_threshold_met_met, direct_data_losses_malicious_access_threshold_met_not_met, direct_data_losses_malicious_access_threshold_met_indeterminate, direct_data_losses_malicious_access_threshold_met_referred, direct_clients_financial_counterparts_and_transactions_threshold_met_met, direct_clients_financial_counterparts_and_transactions_threshold_met_not_met, direct_clients_financial_counterparts_and_transactions_threshold_met_indeterminate, direct_reputational_impact_threshold_met_met, direct_reputational_impact_threshold_met_not_met, direct_reputational_impact_threshold_met_indeterminate, direct_reputational_impact_threshold_met_referred, direct_duration_and_service_downtime_threshold_met_met, direct_duration_and_service_downtime_threshold_met_not_met, direct_duration_and_service_downtime_threshold_met_indeterminate, direct_geographical_spread_threshold_met_met, direct_geographical_spread_threshold_met_not_met, direct_geographical_spread_threshold_met_indeterminate, direct_data_losses_impact_threshold_met_met, direct_data_losses_impact_threshold_met_not_met, direct_data_losses_impact_threshold_met_indeterminate, direct_data_losses_impact_threshold_met_referred, direct_economic_impact_threshold_met_met, direct_economic_impact_threshold_met_not_met, direct_economic_impact_threshold_met_indeterminate, direct_economic_impact_threshold_met_referred, direct_threshold_status_input_problems, direct_threshold_status_has_exactly_one_solution, direct_final_report_timeliness_on_time, direct_final_report_timeliness_late, direct_final_report_timeliness_on_time_by_extension, direct_final_report_timeliness_indeterminate, direct_final_report_timeliness_input_problems, provenance_item_may_follow_inputs_relied_on, referral_context_opens_with_inputs_relied_on_not_provenance, status_projection_agrees_with_the_verdict, decide_gives_the_verdict_term, checklist_is_cited_and_has_one_row_per_condition, decision_is_resolvable_on_a_fixture]).
cp_test_fail_names([critical_services_one_point_true_is_not_not_met, critical_services_all_points_false_is_not_met_only, malicious_access_data_losses_false_is_not_met_only, clients_at_absolute_limit_is_not_met_only, clients_share_at_ten_percent_is_not_met_only, counterparts_share_at_thirty_percent_is_not_met_only, transactions_at_daily_average_share_is_not_met_only, transactions_zero_days_is_not_met_only, reputational_all_false_is_not_met_only, duration_and_downtime_at_limits_is_not_met_only, geographical_one_member_state_is_not_met_only, data_impact_not_adverse_is_not_met_only, economic_exactly_at_limit_is_not_met_only, final_report_leap_year_day_after_is_not_on_time, final_report_weekend_extension_false_is_not_on_time, direct_critical_services_affected_not_met_is_not_met_only, direct_data_losses_malicious_access_threshold_met_not_met_only, direct_reputational_impact_threshold_met_not_met_only, direct_duration_and_service_downtime_threshold_met_not_met_only, direct_data_losses_impact_threshold_met_not_met_only, direct_economic_impact_threshold_met_not_met_only, direct_final_report_timeliness_late_is_not_on_time]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
