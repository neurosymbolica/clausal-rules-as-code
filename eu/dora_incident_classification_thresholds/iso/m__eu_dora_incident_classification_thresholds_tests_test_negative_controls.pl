% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_incident_classification_thresholds_tests_test_negative_controls, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_dora_incident_classification_thresholds_dora_incident_classification_thresholds, [dora_incident_threshold_status/4, dora_incident_classification_thresholds_status_values/1]).
:- use_module(m__eu_dora_incident_classification_thresholds_fixtures, [dora_incident_classification_thresholds_assess/2]).

status_of(Subject, Status) :-
    dora_incident_classification_thresholds_assess(Subject, dora_incident_classification_thresholds_verdict(Status, _Citations)).

test(the_status_table_holds_both_final_atoms) :-
    dora_incident_classification_thresholds_status_values(StatusValues),
    StatusValues == [met, not_met].
test(article_6_one_point_true_is_met) :-
    status_of(critical_services_one_point_true, met).
test(article_6_all_points_false_is_not_met) :-
    status_of(critical_services_all_points_false, not_met).
test(article_9_5_b_both_true_is_met) :-
    status_of(malicious_access_both_true, met).
test(article_9_5_b_data_losses_false_is_not_met) :-
    status_of(malicious_access_data_losses_false, not_met).
test(article_9_1_b_over_limit_is_met) :-
    status_of(clients_over_absolute_limit, met).
test(article_9_1_b_at_limit_is_not_met) :-
    status_of(clients_at_absolute_limit, not_met).
test(article_9_1_a_above_ten_percent_is_met) :-
    status_of(clients_share_above_ten_percent, met).
test(article_9_1_a_at_ten_percent_is_not_met) :-
    status_of(clients_share_at_ten_percent, not_met).
test(article_9_1_c_above_thirty_percent_is_met) :-
    status_of(counterparts_share_above_thirty_percent, met).
test(article_9_1_c_at_thirty_percent_is_not_met) :-
    status_of(counterparts_share_at_thirty_percent, not_met).
test(article_9_1_d_above_daily_average_share_is_met) :-
    status_of(transactions_above_daily_average_share, met).
test(article_9_1_d_at_daily_average_share_is_not_met) :-
    status_of(transactions_at_daily_average_share, not_met).
test(article_9_1_d_zero_total_with_one_day_is_met) :-
    status_of(transactions_zero_total_with_one_day, met).
test(article_9_1_d_zero_days_is_not_met) :-
    status_of(transactions_zero_days_closed, not_met).
test(article_9_1_f_relevant_clients_is_met) :-
    status_of(relevant_clients_affected, met).
test(article_9_1_f_relevant_clients_false_is_not_met) :-
    dora_incident_threshold_status([attribute(affected_clients, 0), attribute(affected_financial_counterparts, 0), attribute(reference_period_days, 0), attribute(relevant_clients_or_financial_counterparts_affected, false)], clients_financial_counterparts_and_transactions_threshold_met, not_met, _).
test(article_9_2_media_is_met) :-
    status_of(reputational_media_true, met).
test(article_9_2_all_false_is_not_met) :-
    status_of(reputational_all_false, not_met).
test(article_9_3_a_over_a_day_is_met) :-
    status_of(duration_over_twenty_four_hours, met).
test(article_9_3_b_over_two_hours_is_met) :-
    status_of(downtime_over_two_hours, met).
test(article_9_3_at_both_limits_is_not_met) :-
    status_of(duration_and_downtime_at_limits, not_met).
test(article_9_4_two_member_states_is_met) :-
    status_of(geographical_two_member_states, met).
test(article_9_4_one_member_state_is_not_met) :-
    status_of(geographical_one_member_state, not_met).
test(article_9_5_a_adverse_and_integrity_is_met) :-
    status_of(data_impact_adverse_and_integrity, met).
test(article_9_5_a_not_adverse_is_not_met) :-
    status_of(data_impact_not_adverse, not_met).
test(article_9_6_one_cent_over_is_met) :-
    status_of(economic_one_cent_over_limit, met).
test(article_9_6_likely_to_exceed_is_met) :-
    status_of(economic_likely_to_exceed, met).
test(article_9_6_exactly_at_limit_is_not_met) :-
    status_of(economic_exactly_at_limit, not_met).
test(missing_reference_period_days_is_named) :-
    status_of(clients_reference_period_days_named, indeterminate([reference_period_days])).
test(filling_reference_period_days_settles_not_met) :-
    dora_incident_threshold_status([attribute(affected_clients, 0), attribute(relevant_clients_or_financial_counterparts_affected, false), attribute(affected_financial_counterparts, 0), attribute(reference_period_days, 0)], clients_financial_counterparts_and_transactions_threshold_met, not_met, _).
test(absent_key_named_before_an_unsure_judgement) :-
    status_of(data_impact_authenticity_named, indeterminate([data_authenticity_impact])).
test(unsure_adverse_impact_is_referred) :-
    status_of(data_impact_adverse_referred, needs_legal_review(open_textured(data_impact_adverse_to_business_objectives_or_regulatory_requirements, cite(eu_reg_2024_1772_art_9_5_a)), _)).
test(decided_adverse_impact_is_met) :-
    dora_incident_threshold_status([attribute(data_impact_adverse_to_business_objectives_or_regulatory_requirements, true), attribute(data_availability_impact, true), attribute(data_authenticity_impact, false), attribute(data_integrity_impact, false), attribute(data_confidentiality_impact, false)], data_losses_impact_threshold_met, met, _).
test(a_bad_profile_gives_input_problems) :-
    status_of(input_unknown_key_and_wrong_type, input_problems([wrong_type(staff_costs_cents), unknown_key(colour)])).
test(a_bad_threshold_gives_input_problems) :-
    status_of(input_bad_threshold, input_problems([wrong_type(threshold)])).
test(the_corrected_profile_is_judged) :-
    dora_incident_threshold_status([attribute(staff_costs_cents, 12500000)], economic_impact_threshold_met, met, _).
test(final_report_on_due_in_a_leap_year_is_on_time) :-
    status_of(final_report_leap_year_on_due, on_time).
test(final_report_day_after_due_in_a_leap_year_is_late) :-
    status_of(final_report_leap_year_day_after, late(month_limit)).
test(final_report_on_february_due_is_on_time) :-
    status_of(final_report_february_on_due, on_time).
test(final_report_day_after_february_due_is_late) :-
    status_of(final_report_february_day_after, late(month_limit)).
test(weekend_extension_true_is_on_time) :-
    status_of(final_report_weekend_extension_true, on_time).
test(weekend_extension_false_is_late) :-
    status_of(final_report_weekend_extension_false, late(month_limit)).
test(final_report_on_december_due_is_on_time) :-
    status_of(final_report_december_on_due, on_time).
test(final_report_after_december_due_needs_the_weekend_key) :-
    status_of(final_report_december_extension_needed, indeterminate([final_report_weekend_extension])).
test(final_report_impossible_date_gives_input_problems) :-
    status_of(final_report_not_a_date, input_problems([wrong_type(latest_intermediate_date)])).

test(article_6_all_points_false_is_never_met, fail) :-
    status_of(critical_services_all_points_false, met).
test(article_9_5_b_data_losses_false_is_never_met, fail) :-
    status_of(malicious_access_data_losses_false, met).
test(article_9_1_b_at_limit_is_never_met, fail) :-
    status_of(clients_at_absolute_limit, met).
test(article_9_1_a_at_ten_percent_is_never_met, fail) :-
    status_of(clients_share_at_ten_percent, met).
test(article_9_1_c_at_thirty_percent_is_never_met, fail) :-
    status_of(counterparts_share_at_thirty_percent, met).
test(article_9_1_d_at_daily_average_share_is_never_met, fail) :-
    status_of(transactions_at_daily_average_share, met).
test(article_9_1_d_zero_days_is_never_met, fail) :-
    status_of(transactions_zero_days_closed, met).
test(article_9_1_f_relevant_clients_false_is_never_met, fail) :-
    dora_incident_threshold_status([attribute(affected_clients, 0), attribute(affected_financial_counterparts, 0), attribute(reference_period_days, 0), attribute(relevant_clients_or_financial_counterparts_affected, false)], clients_financial_counterparts_and_transactions_threshold_met, met, _).
test(article_9_2_all_false_is_never_met, fail) :-
    status_of(reputational_all_false, met).
test(article_9_3_at_both_limits_is_never_met, fail) :-
    status_of(duration_and_downtime_at_limits, met).
test(article_9_4_one_member_state_is_never_met, fail) :-
    status_of(geographical_one_member_state, met).
test(article_9_5_a_not_adverse_is_never_met, fail) :-
    status_of(data_impact_not_adverse, met).
test(article_9_6_exactly_at_limit_is_never_met, fail) :-
    status_of(economic_exactly_at_limit, met).
test(filled_reference_period_days_is_never_indeterminate, fail) :-
    dora_incident_threshold_status([attribute(affected_clients, 0), attribute(relevant_clients_or_financial_counterparts_affected, false), attribute(affected_financial_counterparts, 0), attribute(reference_period_days, 0)], clients_financial_counterparts_and_transactions_threshold_met, indeterminate(_), _).
test(decided_adverse_impact_is_never_referred, fail) :-
    dora_incident_threshold_status([attribute(data_impact_adverse_to_business_objectives_or_regulatory_requirements, true), attribute(data_availability_impact, true), attribute(data_authenticity_impact, false), attribute(data_integrity_impact, false), attribute(data_confidentiality_impact, false)], data_losses_impact_threshold_met, needs_legal_review(_, _), _).
test(the_corrected_profile_has_no_input_problems, fail) :-
    dora_incident_threshold_status([attribute(staff_costs_cents, 12500000)], economic_impact_threshold_met, input_problems(_), _).
test(final_report_day_after_due_is_never_on_time, fail) :-
    status_of(final_report_leap_year_day_after, on_time).
test(weekend_extension_false_is_never_on_time, fail) :-
    status_of(final_report_weekend_extension_false, on_time).
test(final_report_after_december_due_is_never_on_time_without_the_key, fail) :-
    status_of(final_report_december_extension_needed, on_time).

cp_test_names([the_status_table_holds_both_final_atoms, article_6_one_point_true_is_met, article_6_all_points_false_is_not_met, article_9_5_b_both_true_is_met, article_9_5_b_data_losses_false_is_not_met, article_9_1_b_over_limit_is_met, article_9_1_b_at_limit_is_not_met, article_9_1_a_above_ten_percent_is_met, article_9_1_a_at_ten_percent_is_not_met, article_9_1_c_above_thirty_percent_is_met, article_9_1_c_at_thirty_percent_is_not_met, article_9_1_d_above_daily_average_share_is_met, article_9_1_d_at_daily_average_share_is_not_met, article_9_1_d_zero_total_with_one_day_is_met, article_9_1_d_zero_days_is_not_met, article_9_1_f_relevant_clients_is_met, article_9_1_f_relevant_clients_false_is_not_met, article_9_2_media_is_met, article_9_2_all_false_is_not_met, article_9_3_a_over_a_day_is_met, article_9_3_b_over_two_hours_is_met, article_9_3_at_both_limits_is_not_met, article_9_4_two_member_states_is_met, article_9_4_one_member_state_is_not_met, article_9_5_a_adverse_and_integrity_is_met, article_9_5_a_not_adverse_is_not_met, article_9_6_one_cent_over_is_met, article_9_6_likely_to_exceed_is_met, article_9_6_exactly_at_limit_is_not_met, missing_reference_period_days_is_named, filling_reference_period_days_settles_not_met, absent_key_named_before_an_unsure_judgement, unsure_adverse_impact_is_referred, decided_adverse_impact_is_met, a_bad_profile_gives_input_problems, a_bad_threshold_gives_input_problems, the_corrected_profile_is_judged, final_report_on_due_in_a_leap_year_is_on_time, final_report_day_after_due_in_a_leap_year_is_late, final_report_on_february_due_is_on_time, final_report_day_after_february_due_is_late, weekend_extension_true_is_on_time, weekend_extension_false_is_late, final_report_on_december_due_is_on_time, final_report_after_december_due_needs_the_weekend_key, final_report_impossible_date_gives_input_problems]).
cp_test_fail_names([article_6_all_points_false_is_never_met, article_9_5_b_data_losses_false_is_never_met, article_9_1_b_at_limit_is_never_met, article_9_1_a_at_ten_percent_is_never_met, article_9_1_c_at_thirty_percent_is_never_met, article_9_1_d_at_daily_average_share_is_never_met, article_9_1_d_zero_days_is_never_met, article_9_1_f_relevant_clients_false_is_never_met, article_9_2_all_false_is_never_met, article_9_3_at_both_limits_is_never_met, article_9_4_one_member_state_is_never_met, article_9_5_a_not_adverse_is_never_met, article_9_6_exactly_at_limit_is_never_met, filled_reference_period_days_is_never_indeterminate, decided_adverse_impact_is_never_referred, the_corrected_profile_has_no_input_problems, final_report_day_after_due_is_never_on_time, weekend_extension_false_is_never_on_time, final_report_after_december_due_is_never_on_time_without_the_key]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
