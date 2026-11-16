% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_nis2_implementing_regulation_significant_incidents_tests_test_negative_controls, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_nis2_implementing_regulation_significant_incidents_nis2_implementing_regulation_significant_incidents, [significant_incident_criteria/3, nis2_implementing_regulation_significant_incidents_status_values/1]).
:- use_module(m__eu_nis2_implementing_regulation_significant_incidents_fixtures, [nis2_implementing_regulation_significant_incidents_profile_for/2]).

result_of(Subject, Result) :-
    nis2_implementing_regulation_significant_incidents_profile_for(Subject, Profile),
    significant_incident_criteria(Profile, Result, _Citations).

test(the_status_table_holds_both_result_atoms) :-
    nis2_implementing_regulation_significant_incidents_status_values(StatusValues),
    StatusValues == [significant, not_significant].
test(scheduled_route_positive) :-
    result_of(scheduled_maintenance_with_loss, not_significant).
test(scheduled_route_near_miss) :-
    result_of(loss_above_floor_not_scheduled, significant).
test(met_with_scheduled_absent_asks_for_it) :-
    result_of(loss_above_floor_scheduled_absent, indeterminate([scheduled_interruption_or_maintenance])).
test(money_floor_positive) :-
    result_of(loss_one_cent_above_floor_turnover_large, significant).
test(money_floor_near_miss) :-
    result_of(loss_equal_floor_turnover_large, not_significant).
test(money_share_positive) :-
    result_of(loss_above_five_percent_of_small_turnover, significant).
test(money_share_near_miss) :-
    result_of(loss_at_five_percent_of_small_turnover, not_significant).
test(money_turnover_missing_is_named) :-
    result_of(loss_below_floor_turnover_absent, indeterminate([annual_turnover_preceding_financial_year_euro_cents])).
test(trade_secret_positive) :-
    result_of(trade_secret_exfiltration_true, significant).
test(every_criterion_closed_near_miss) :-
    result_of(all_criteria_closed_dns, not_significant).
test(recurring_positive) :-
    result_of(recurring_twice_same_cause_collective_loss, significant).
test(recurring_near_miss) :-
    result_of(recurring_once_same_cause_collective_loss, not_significant).
test(dns_outage_positive) :-
    result_of(dns_outage_thirty_minutes_one_second, significant).
test(dns_outage_near_miss) :-
    result_of(dns_outage_exactly_thirty_minutes, not_significant).
test(dns_exception_share_positive) :-
    result_of(dns_misconfiguration_one_percent_exceeded, significant).
test(dns_exception_share_near_miss) :-
    result_of(dns_misconfiguration_exception_applies, not_significant).
test(dns_exception_count_positive) :-
    result_of(dns_misconfiguration_thousand_names, significant).
test(dns_exception_count_near_miss) :-
    result_of(dns_misconfiguration_nine_hundred_ninety_nine_names, not_significant).
test(tld_outage_positive) :-
    result_of(tld_any_complete_unavailability, significant).
test(tld_outage_near_miss) :-
    result_of(tld_no_complete_unavailability, not_significant).
test(cloud_share_positive) :-
    result_of(cloud_limited_availability_above_five_percent, significant).
test(cloud_share_near_miss) :-
    result_of(cloud_limited_availability_at_five_percent, not_significant).
test(cloud_duration_near_miss) :-
    result_of(cloud_limited_availability_exactly_one_hour, not_significant).
test(cloud_floor_positive) :-
    result_of(cloud_limited_availability_over_one_million, significant).
test(cloud_floor_near_miss) :-
    result_of(cloud_limited_availability_one_million_large_base, not_significant).
test(cloud_total_missing_is_named) :-
    result_of(cloud_limited_availability_users_total_absent, indeterminate([service_users_in_union])).
test(data_centre_positive) :-
    result_of(data_centre_physical_access, significant).
test(data_centre_near_miss) :-
    result_of(data_centre_no_physical_access, not_significant).
test(marketplace_positive) :-
    result_of(marketplace_complete_unavailability_over_one_million, significant).
test(marketplace_near_miss) :-
    result_of(marketplace_complete_unavailability_one_million_large_base, not_significant).
test(trust_outage_positive) :-
    result_of(trust_unavailable_twenty_minutes_one_second, significant).
test(trust_outage_near_miss) :-
    result_of(trust_unavailable_twenty_minutes, not_significant).
test(trust_weekly_positive) :-
    result_of(trust_weekly_unavailability_one_hour_one_second, significant).
test(trust_weekly_near_miss) :-
    result_of(trust_weekly_unavailability_one_hour, not_significant).
test(trust_limited_positive) :-
    result_of(trust_limited_availability_over_two_hundred_thousand, significant).
test(trust_limited_near_miss) :-
    result_of(trust_limited_availability_two_hundred_thousand_large_base, not_significant).
test(trust_data_positive) :-
    result_of(trust_data_compromise_over_one_hundred_users, significant).
test(trust_data_near_miss) :-
    result_of(trust_data_compromise_one_hundred_users_large_base, not_significant).
test(entity_type_absent_closed_positive) :-
    result_of(entity_type_absent_all_types_closed, not_significant).
test(entity_type_absent_near_miss) :-
    result_of(entity_type_absent_open, indeterminate([relevant_entity_type])).
test(unsure_decisive_goes_to_a_lawyer) :-
    result_of(death_unsure_decisive, needs_legal_review(open_textured(death_of_natural_person, cite(eu_reg_2024_2690_art_3_1_c)), _)).
test(unsure_irrelevant_near_miss_is_final) :-
    result_of(unsure_irrelevant_loss_met, significant).
test(unsure_with_missing_key_names_the_key) :-
    result_of(death_unsure_count_absent, indeterminate([recurring_incidents_within_six_months])).
test(shared_judgement_cites_point_g) :-
    result_of(data_compromised_unsure_tld, needs_legal_review(open_textured(data_compromised, cite(eu_reg_2024_2690_art_3_1_g)), _)).
test(input_problem_positive) :-
    result_of(wrong_type_float_loss, input_problems([wrong_type(direct_financial_loss_euro_cents)])).
test(input_problem_near_miss_is_judged) :-
    result_of(loss_above_floor_not_scheduled, significant).

test(scheduled_route_is_not_significant_never_significant, fail) :-
    result_of(scheduled_maintenance_with_loss, significant).
test(scheduled_route_near_miss_is_not_not_significant, fail) :-
    result_of(loss_above_floor_not_scheduled, not_significant).
test(met_with_scheduled_absent_is_not_final, fail) :-
    result_of(loss_above_floor_scheduled_absent, significant).
test(money_floor_positive_is_not_not_significant, fail) :-
    result_of(loss_one_cent_above_floor_turnover_large, not_significant).
test(money_floor_near_miss_is_not_significant, fail) :-
    result_of(loss_equal_floor_turnover_large, significant).
test(money_share_near_miss_is_not_significant, fail) :-
    result_of(loss_at_five_percent_of_small_turnover, significant).
test(money_turnover_missing_is_not_final, fail) :-
    result_of(loss_below_floor_turnover_absent, not_significant).
test(trade_secret_positive_is_not_not_significant, fail) :-
    result_of(trade_secret_exfiltration_true, not_significant).
test(every_criterion_closed_is_not_significant, fail) :-
    result_of(all_criteria_closed_dns, significant).
test(recurring_near_miss_is_not_significant, fail) :-
    result_of(recurring_once_same_cause_collective_loss, significant).
test(dns_outage_near_miss_is_not_significant, fail) :-
    result_of(dns_outage_exactly_thirty_minutes, significant).
test(dns_exception_share_near_miss_is_not_significant, fail) :-
    result_of(dns_misconfiguration_exception_applies, significant).
test(dns_exception_count_near_miss_is_not_significant, fail) :-
    result_of(dns_misconfiguration_nine_hundred_ninety_nine_names, significant).
test(tld_outage_near_miss_is_not_significant, fail) :-
    result_of(tld_no_complete_unavailability, significant).
test(cloud_share_near_miss_is_not_significant, fail) :-
    result_of(cloud_limited_availability_at_five_percent, significant).
test(cloud_duration_near_miss_is_not_significant, fail) :-
    result_of(cloud_limited_availability_exactly_one_hour, significant).
test(cloud_floor_near_miss_is_not_significant, fail) :-
    result_of(cloud_limited_availability_one_million_large_base, significant).
test(data_centre_near_miss_is_not_significant, fail) :-
    result_of(data_centre_no_physical_access, significant).
test(marketplace_near_miss_is_not_significant, fail) :-
    result_of(marketplace_complete_unavailability_one_million_large_base, significant).
test(trust_outage_near_miss_is_not_significant, fail) :-
    result_of(trust_unavailable_twenty_minutes, significant).
test(trust_weekly_near_miss_is_not_significant, fail) :-
    result_of(trust_weekly_unavailability_one_hour, significant).
test(trust_limited_near_miss_is_not_significant, fail) :-
    result_of(trust_limited_availability_two_hundred_thousand_large_base, significant).
test(trust_data_near_miss_is_not_significant, fail) :-
    result_of(trust_data_compromise_one_hundred_users_large_base, significant).
test(entity_type_absent_near_miss_is_not_final, fail) :-
    result_of(entity_type_absent_open, not_significant).
test(unsure_decisive_is_not_final, fail) :-
    result_of(death_unsure_decisive, significant).
test(unsure_irrelevant_is_not_referred, fail) :-
    result_of(unsure_irrelevant_loss_met, needs_legal_review(_, _)).
test(unsure_with_missing_key_is_not_referred, fail) :-
    result_of(death_unsure_count_absent, needs_legal_review(_, _)).
test(shared_judgement_never_cites_the_article, fail) :-
    result_of(data_compromised_unsure_tld, needs_legal_review(open_textured(data_compromised, cite(eu_reg_2024_2690_art_6_c)), _)).
test(input_problem_is_not_judged, fail) :-
    result_of(wrong_type_float_loss, not_significant).
test(input_problem_near_miss_has_no_problem, fail) :-
    result_of(loss_above_floor_not_scheduled, input_problems(_)).

cp_test_names([the_status_table_holds_both_result_atoms, scheduled_route_positive, scheduled_route_near_miss, met_with_scheduled_absent_asks_for_it, money_floor_positive, money_floor_near_miss, money_share_positive, money_share_near_miss, money_turnover_missing_is_named, trade_secret_positive, every_criterion_closed_near_miss, recurring_positive, recurring_near_miss, dns_outage_positive, dns_outage_near_miss, dns_exception_share_positive, dns_exception_share_near_miss, dns_exception_count_positive, dns_exception_count_near_miss, tld_outage_positive, tld_outage_near_miss, cloud_share_positive, cloud_share_near_miss, cloud_duration_near_miss, cloud_floor_positive, cloud_floor_near_miss, cloud_total_missing_is_named, data_centre_positive, data_centre_near_miss, marketplace_positive, marketplace_near_miss, trust_outage_positive, trust_outage_near_miss, trust_weekly_positive, trust_weekly_near_miss, trust_limited_positive, trust_limited_near_miss, trust_data_positive, trust_data_near_miss, entity_type_absent_closed_positive, entity_type_absent_near_miss, unsure_decisive_goes_to_a_lawyer, unsure_irrelevant_near_miss_is_final, unsure_with_missing_key_names_the_key, shared_judgement_cites_point_g, input_problem_positive, input_problem_near_miss_is_judged]).
cp_test_fail_names([scheduled_route_is_not_significant_never_significant, scheduled_route_near_miss_is_not_not_significant, met_with_scheduled_absent_is_not_final, money_floor_positive_is_not_not_significant, money_floor_near_miss_is_not_significant, money_share_near_miss_is_not_significant, money_turnover_missing_is_not_final, trade_secret_positive_is_not_not_significant, every_criterion_closed_is_not_significant, recurring_near_miss_is_not_significant, dns_outage_near_miss_is_not_significant, dns_exception_share_near_miss_is_not_significant, dns_exception_count_near_miss_is_not_significant, tld_outage_near_miss_is_not_significant, cloud_share_near_miss_is_not_significant, cloud_duration_near_miss_is_not_significant, cloud_floor_near_miss_is_not_significant, data_centre_near_miss_is_not_significant, marketplace_near_miss_is_not_significant, trust_outage_near_miss_is_not_significant, trust_weekly_near_miss_is_not_significant, trust_limited_near_miss_is_not_significant, trust_data_near_miss_is_not_significant, entity_type_absent_near_miss_is_not_final, unsure_decisive_is_not_final, unsure_irrelevant_is_not_referred, unsure_with_missing_key_is_not_referred, shared_judgement_never_cites_the_article, input_problem_is_not_judged, input_problem_near_miss_has_no_problem]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
