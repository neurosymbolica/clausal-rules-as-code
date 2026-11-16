% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_nis2_implementing_regulation_significant_incidents_fixtures, [nis2_implementing_regulation_significant_incidents_subject/1, nis2_implementing_regulation_significant_incidents_profile_for/2, nis2_implementing_regulation_significant_incidents_assess/2]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_nis2_implementing_regulation_significant_incidents_nis2_implementing_regulation_significant_incidents, [decide_nis2_implementing_regulation_significant_incidents/2]).

nis2_implementing_regulation_significant_incidents_subject(scheduled_maintenance_with_loss).
nis2_implementing_regulation_significant_incidents_subject(loss_above_floor_not_scheduled).
nis2_implementing_regulation_significant_incidents_subject(loss_above_floor_scheduled_absent).
nis2_implementing_regulation_significant_incidents_subject(all_criteria_closed_dns).
nis2_implementing_regulation_significant_incidents_subject(trade_secret_exfiltration_true).
nis2_implementing_regulation_significant_incidents_subject(loss_equal_floor_turnover_large).
nis2_implementing_regulation_significant_incidents_subject(loss_one_cent_above_floor_turnover_large).
nis2_implementing_regulation_significant_incidents_subject(loss_above_five_percent_of_small_turnover).
nis2_implementing_regulation_significant_incidents_subject(loss_at_five_percent_of_small_turnover).
nis2_implementing_regulation_significant_incidents_subject(loss_below_floor_turnover_absent).
nis2_implementing_regulation_significant_incidents_subject(recurring_twice_same_cause_collective_loss).
nis2_implementing_regulation_significant_incidents_subject(recurring_once_same_cause_collective_loss).
nis2_implementing_regulation_significant_incidents_subject(dns_outage_exactly_thirty_minutes).
nis2_implementing_regulation_significant_incidents_subject(dns_outage_thirty_minutes_one_second).
nis2_implementing_regulation_significant_incidents_subject(dns_misconfiguration_exception_applies).
nis2_implementing_regulation_significant_incidents_subject(dns_misconfiguration_one_percent_exceeded).
nis2_implementing_regulation_significant_incidents_subject(dns_misconfiguration_thousand_names).
nis2_implementing_regulation_significant_incidents_subject(dns_misconfiguration_nine_hundred_ninety_nine_names).
nis2_implementing_regulation_significant_incidents_subject(tld_any_complete_unavailability).
nis2_implementing_regulation_significant_incidents_subject(tld_no_complete_unavailability).
nis2_implementing_regulation_significant_incidents_subject(cloud_limited_availability_users_total_absent).
nis2_implementing_regulation_significant_incidents_subject(cloud_limited_availability_above_five_percent).
nis2_implementing_regulation_significant_incidents_subject(cloud_limited_availability_at_five_percent).
nis2_implementing_regulation_significant_incidents_subject(cloud_limited_availability_exactly_one_hour).
nis2_implementing_regulation_significant_incidents_subject(cloud_limited_availability_over_one_million).
nis2_implementing_regulation_significant_incidents_subject(cloud_limited_availability_one_million_large_base).
nis2_implementing_regulation_significant_incidents_subject(data_centre_physical_access).
nis2_implementing_regulation_significant_incidents_subject(data_centre_no_physical_access).
nis2_implementing_regulation_significant_incidents_subject(marketplace_complete_unavailability_over_one_million).
nis2_implementing_regulation_significant_incidents_subject(marketplace_complete_unavailability_one_million_large_base).
nis2_implementing_regulation_significant_incidents_subject(trust_unavailable_twenty_minutes).
nis2_implementing_regulation_significant_incidents_subject(trust_unavailable_twenty_minutes_one_second).
nis2_implementing_regulation_significant_incidents_subject(trust_weekly_unavailability_one_hour).
nis2_implementing_regulation_significant_incidents_subject(trust_weekly_unavailability_one_hour_one_second).
nis2_implementing_regulation_significant_incidents_subject(trust_limited_availability_over_two_hundred_thousand).
nis2_implementing_regulation_significant_incidents_subject(trust_limited_availability_two_hundred_thousand_large_base).
nis2_implementing_regulation_significant_incidents_subject(trust_data_compromise_over_one_hundred_users).
nis2_implementing_regulation_significant_incidents_subject(trust_data_compromise_one_hundred_users_large_base).
nis2_implementing_regulation_significant_incidents_subject(entity_type_absent_all_types_closed).
nis2_implementing_regulation_significant_incidents_subject(entity_type_absent_open).
nis2_implementing_regulation_significant_incidents_subject(death_unsure_decisive).
nis2_implementing_regulation_significant_incidents_subject(death_unsure_count_absent).
nis2_implementing_regulation_significant_incidents_subject(data_compromised_unsure_tld).
nis2_implementing_regulation_significant_incidents_subject(unsure_irrelevant_loss_met).
nis2_implementing_regulation_significant_incidents_subject(wrong_type_float_loss).
nis2_implementing_regulation_significant_incidents_subject(duplicate_and_unknown_keys).
nis2_implementing_regulation_significant_incidents_subject(profile_not_attribute_list).

harm_judgements_closed([attribute(trade_secret_exfiltration, false), attribute(death_of_natural_person, false), attribute(considerable_damage_to_natural_person_health, false), attribute(suspectedly_malicious_unauthorised_access_capable_of_severe_operational_disruption, false)]).

general_criteria_closed(Attributes) :-
    harm_judgements_closed(Harms),
    append([[attribute(scheduled_interruption_or_maintenance, false), attribute(direct_financial_loss_euro_cents, 0)], Harms, [attribute(recurring_incidents_within_six_months, 1)]], Attributes).

with_article(ArticleAttributes, Profile) :-
    general_criteria_closed(General),
    append(General, ArticleAttributes, Profile).

dns_article_closed([attribute(relevant_entity_type, dns_service_provider), attribute(complete_unavailability_seconds, 0), attribute(average_response_time_above_ten_seconds_seconds, 0), attribute(data_compromised, false)]).

money_profile(MoneyAttributes, Profile) :-
    harm_judgements_closed(Harms),
    dns_article_closed(Article),
    append([[attribute(scheduled_interruption_or_maintenance, false)], MoneyAttributes, Harms, Article], Profile).

nis2_implementing_regulation_significant_incidents_profile_for(scheduled_maintenance_with_loss, [attribute(scheduled_interruption_or_maintenance, true), attribute(direct_financial_loss_euro_cents, 60000000)]).
nis2_implementing_regulation_significant_incidents_profile_for(loss_above_floor_not_scheduled, [attribute(scheduled_interruption_or_maintenance, false), attribute(direct_financial_loss_euro_cents, 50000001)]).
nis2_implementing_regulation_significant_incidents_profile_for(loss_above_floor_scheduled_absent, [attribute(direct_financial_loss_euro_cents, 50000001)]).
nis2_implementing_regulation_significant_incidents_profile_for(all_criteria_closed_dns, Profile) :-
    dns_article_closed(Article),
    with_article(Article, Profile).
nis2_implementing_regulation_significant_incidents_profile_for(trade_secret_exfiltration_true, Profile) :-
    dns_article_closed(Article),
    append([[attribute(scheduled_interruption_or_maintenance, false), attribute(direct_financial_loss_euro_cents, 0), attribute(trade_secret_exfiltration, true), attribute(death_of_natural_person, false), attribute(considerable_damage_to_natural_person_health, false), attribute(suspectedly_malicious_unauthorised_access_capable_of_severe_operational_disruption, false), attribute(recurring_incidents_within_six_months, 1)], Article], Profile).
nis2_implementing_regulation_significant_incidents_profile_for(loss_equal_floor_turnover_large, Profile) :-
    money_profile([attribute(direct_financial_loss_euro_cents, 50000000), attribute(annual_turnover_preceding_financial_year_euro_cents, 2000000000), attribute(recurring_incidents_within_six_months, 1)], Profile).
nis2_implementing_regulation_significant_incidents_profile_for(loss_one_cent_above_floor_turnover_large, Profile) :-
    money_profile([attribute(direct_financial_loss_euro_cents, 50000001), attribute(annual_turnover_preceding_financial_year_euro_cents, 2000000000), attribute(recurring_incidents_within_six_months, 1)], Profile).
nis2_implementing_regulation_significant_incidents_profile_for(loss_above_five_percent_of_small_turnover, Profile) :-
    money_profile([attribute(direct_financial_loss_euro_cents, 5000001), attribute(annual_turnover_preceding_financial_year_euro_cents, 100000000), attribute(recurring_incidents_within_six_months, 1)], Profile).
nis2_implementing_regulation_significant_incidents_profile_for(loss_at_five_percent_of_small_turnover, Profile) :-
    money_profile([attribute(direct_financial_loss_euro_cents, 5000000), attribute(annual_turnover_preceding_financial_year_euro_cents, 100000000), attribute(recurring_incidents_within_six_months, 1)], Profile).
nis2_implementing_regulation_significant_incidents_profile_for(loss_below_floor_turnover_absent, Profile) :-
    money_profile([attribute(direct_financial_loss_euro_cents, 1000), attribute(recurring_incidents_within_six_months, 1)], Profile).
nis2_implementing_regulation_significant_incidents_profile_for(recurring_twice_same_cause_collective_loss, Profile) :-
    money_profile([attribute(direct_financial_loss_euro_cents, 0), attribute(recurring_incidents_within_six_months, 2), attribute(same_apparent_root_cause, true), attribute(recurring_collective_direct_financial_loss_euro_cents, 50000001)], Profile).
nis2_implementing_regulation_significant_incidents_profile_for(recurring_once_same_cause_collective_loss, Profile) :-
    money_profile([attribute(direct_financial_loss_euro_cents, 0), attribute(recurring_incidents_within_six_months, 1), attribute(same_apparent_root_cause, true), attribute(recurring_collective_direct_financial_loss_euro_cents, 50000001)], Profile).
nis2_implementing_regulation_significant_incidents_profile_for(dns_outage_exactly_thirty_minutes, Profile) :-
    with_article([attribute(relevant_entity_type, dns_service_provider), attribute(complete_unavailability_seconds, 1800), attribute(average_response_time_above_ten_seconds_seconds, 0), attribute(data_compromised, false)], Profile).
nis2_implementing_regulation_significant_incidents_profile_for(dns_outage_thirty_minutes_one_second, Profile) :-
    with_article([attribute(relevant_entity_type, dns_service_provider), attribute(complete_unavailability_seconds, 1801), attribute(average_response_time_above_ten_seconds_seconds, 0), attribute(data_compromised, false)], Profile).
nis2_implementing_regulation_significant_incidents_profile_for(dns_misconfiguration_exception_applies, Profile) :-
    with_article([attribute(relevant_entity_type, dns_service_provider), attribute(complete_unavailability_seconds, 0), attribute(average_response_time_above_ten_seconds_seconds, 0), attribute(data_compromised, true), attribute(incorrect_data_only_by_misconfiguration, true), attribute(incorrect_domain_names, 10), attribute(managed_domain_names, 1000)], Profile).
nis2_implementing_regulation_significant_incidents_profile_for(dns_misconfiguration_one_percent_exceeded, Profile) :-
    with_article([attribute(relevant_entity_type, dns_service_provider), attribute(complete_unavailability_seconds, 0), attribute(average_response_time_above_ten_seconds_seconds, 0), attribute(data_compromised, true), attribute(incorrect_data_only_by_misconfiguration, true), attribute(incorrect_domain_names, 11), attribute(managed_domain_names, 1000)], Profile).
nis2_implementing_regulation_significant_incidents_profile_for(dns_misconfiguration_thousand_names, Profile) :-
    with_article([attribute(relevant_entity_type, dns_service_provider), attribute(complete_unavailability_seconds, 0), attribute(average_response_time_above_ten_seconds_seconds, 0), attribute(data_compromised, true), attribute(incorrect_data_only_by_misconfiguration, true), attribute(incorrect_domain_names, 1000), attribute(managed_domain_names, 1000000)], Profile).
nis2_implementing_regulation_significant_incidents_profile_for(dns_misconfiguration_nine_hundred_ninety_nine_names, Profile) :-
    with_article([attribute(relevant_entity_type, dns_service_provider), attribute(complete_unavailability_seconds, 0), attribute(average_response_time_above_ten_seconds_seconds, 0), attribute(data_compromised, true), attribute(incorrect_data_only_by_misconfiguration, true), attribute(incorrect_domain_names, 999), attribute(managed_domain_names, 1000000)], Profile).
nis2_implementing_regulation_significant_incidents_profile_for(tld_any_complete_unavailability, Profile) :-
    with_article([attribute(relevant_entity_type, tld_name_registry), attribute(complete_unavailability_seconds, 1), attribute(average_response_time_above_ten_seconds_seconds, 0), attribute(data_compromised, false)], Profile).
nis2_implementing_regulation_significant_incidents_profile_for(tld_no_complete_unavailability, Profile) :-
    with_article([attribute(relevant_entity_type, tld_name_registry), attribute(complete_unavailability_seconds, 0), attribute(average_response_time_above_ten_seconds_seconds, 0), attribute(data_compromised, false)], Profile).
nis2_implementing_regulation_significant_incidents_profile_for(cloud_limited_availability_users_total_absent, Profile) :-
    with_article([attribute(relevant_entity_type, cloud_computing_service_provider), attribute(complete_unavailability_seconds, 0), attribute(limited_availability_seconds, 3601), attribute(limited_availability_users, 500), attribute(data_compromised, false)], Profile).
nis2_implementing_regulation_significant_incidents_profile_for(cloud_limited_availability_above_five_percent, Profile) :-
    with_article([attribute(relevant_entity_type, cloud_computing_service_provider), attribute(complete_unavailability_seconds, 0), attribute(limited_availability_seconds, 3601), attribute(limited_availability_users, 501), attribute(service_users_in_union, 10000), attribute(data_compromised, false)], Profile).
nis2_implementing_regulation_significant_incidents_profile_for(cloud_limited_availability_at_five_percent, Profile) :-
    with_article([attribute(relevant_entity_type, cloud_computing_service_provider), attribute(complete_unavailability_seconds, 0), attribute(limited_availability_seconds, 3601), attribute(limited_availability_users, 500), attribute(service_users_in_union, 10000), attribute(data_compromised, false)], Profile).
nis2_implementing_regulation_significant_incidents_profile_for(cloud_limited_availability_exactly_one_hour, Profile) :-
    with_article([attribute(relevant_entity_type, cloud_computing_service_provider), attribute(complete_unavailability_seconds, 0), attribute(limited_availability_seconds, 3600), attribute(limited_availability_users, 501), attribute(service_users_in_union, 10000), attribute(data_compromised, false)], Profile).
nis2_implementing_regulation_significant_incidents_profile_for(cloud_limited_availability_over_one_million, Profile) :-
    with_article([attribute(relevant_entity_type, cloud_computing_service_provider), attribute(complete_unavailability_seconds, 0), attribute(limited_availability_seconds, 3601), attribute(limited_availability_users, 1000001), attribute(data_compromised, false)], Profile).
nis2_implementing_regulation_significant_incidents_profile_for(cloud_limited_availability_one_million_large_base, Profile) :-
    with_article([attribute(relevant_entity_type, cloud_computing_service_provider), attribute(complete_unavailability_seconds, 0), attribute(limited_availability_seconds, 3601), attribute(limited_availability_users, 1000000), attribute(service_users_in_union, 100000000), attribute(data_compromised, false)], Profile).
nis2_implementing_regulation_significant_incidents_profile_for(data_centre_physical_access, Profile) :-
    with_article([attribute(relevant_entity_type, data_centre_service_provider), attribute(complete_unavailability_seconds, 0), attribute(limited_availability_seconds, 0), attribute(data_compromised, false), attribute(physical_access_compromised, true)], Profile).
nis2_implementing_regulation_significant_incidents_profile_for(data_centre_no_physical_access, Profile) :-
    with_article([attribute(relevant_entity_type, data_centre_service_provider), attribute(complete_unavailability_seconds, 0), attribute(limited_availability_seconds, 0), attribute(data_compromised, false), attribute(physical_access_compromised, false)], Profile).
nis2_implementing_regulation_significant_incidents_profile_for(marketplace_complete_unavailability_over_one_million, Profile) :-
    with_article([attribute(relevant_entity_type, online_marketplace_provider), attribute(complete_unavailability_users, 1000001), attribute(limited_availability_users, 0), attribute(data_compromised, false)], Profile).
nis2_implementing_regulation_significant_incidents_profile_for(marketplace_complete_unavailability_one_million_large_base, Profile) :-
    with_article([attribute(relevant_entity_type, online_marketplace_provider), attribute(complete_unavailability_users, 1000000), attribute(limited_availability_users, 0), attribute(service_users_in_union, 100000000), attribute(data_compromised, false)], Profile).
nis2_implementing_regulation_significant_incidents_profile_for(trust_unavailable_twenty_minutes, Profile) :-
    with_article([attribute(relevant_entity_type, trust_service_provider), attribute(complete_unavailability_seconds, 1200), attribute(weekly_unavailability_seconds, 0), attribute(limited_availability_users, 0), attribute(data_compromised, false), attribute(physical_access_compromised, false)], Profile).
nis2_implementing_regulation_significant_incidents_profile_for(trust_unavailable_twenty_minutes_one_second, Profile) :-
    with_article([attribute(relevant_entity_type, trust_service_provider), attribute(complete_unavailability_seconds, 1201), attribute(weekly_unavailability_seconds, 0), attribute(limited_availability_users, 0), attribute(data_compromised, false), attribute(physical_access_compromised, false)], Profile).
nis2_implementing_regulation_significant_incidents_profile_for(trust_weekly_unavailability_one_hour, Profile) :-
    with_article([attribute(relevant_entity_type, trust_service_provider), attribute(complete_unavailability_seconds, 0), attribute(weekly_unavailability_seconds, 3600), attribute(limited_availability_users, 0), attribute(data_compromised, false), attribute(physical_access_compromised, false)], Profile).
nis2_implementing_regulation_significant_incidents_profile_for(trust_weekly_unavailability_one_hour_one_second, Profile) :-
    with_article([attribute(relevant_entity_type, trust_service_provider), attribute(complete_unavailability_seconds, 0), attribute(weekly_unavailability_seconds, 3601), attribute(limited_availability_users, 0), attribute(data_compromised, false), attribute(physical_access_compromised, false)], Profile).
nis2_implementing_regulation_significant_incidents_profile_for(trust_limited_availability_over_two_hundred_thousand, Profile) :-
    with_article([attribute(relevant_entity_type, trust_service_provider), attribute(complete_unavailability_seconds, 0), attribute(weekly_unavailability_seconds, 0), attribute(limited_availability_users, 200001), attribute(data_compromised, false), attribute(physical_access_compromised, false)], Profile).
nis2_implementing_regulation_significant_incidents_profile_for(trust_limited_availability_two_hundred_thousand_large_base, Profile) :-
    with_article([attribute(relevant_entity_type, trust_service_provider), attribute(complete_unavailability_seconds, 0), attribute(weekly_unavailability_seconds, 0), attribute(limited_availability_users, 200000), attribute(service_users_in_union, 100000000), attribute(data_compromised, false), attribute(physical_access_compromised, false)], Profile).
nis2_implementing_regulation_significant_incidents_profile_for(trust_data_compromise_over_one_hundred_users, Profile) :-
    with_article([attribute(relevant_entity_type, trust_service_provider), attribute(complete_unavailability_seconds, 0), attribute(weekly_unavailability_seconds, 0), attribute(limited_availability_users, 0), attribute(data_compromise_users, 101), attribute(data_compromised, true), attribute(physical_access_compromised, false)], Profile).
nis2_implementing_regulation_significant_incidents_profile_for(trust_data_compromise_one_hundred_users_large_base, Profile) :-
    with_article([attribute(relevant_entity_type, trust_service_provider), attribute(complete_unavailability_seconds, 0), attribute(weekly_unavailability_seconds, 0), attribute(limited_availability_users, 0), attribute(data_compromise_users, 100), attribute(service_users_in_union, 1000000), attribute(data_compromised, true), attribute(physical_access_compromised, false)], Profile).
nis2_implementing_regulation_significant_incidents_profile_for(entity_type_absent_all_types_closed, Profile) :-
    with_article([attribute(complete_unavailability_seconds, 0), attribute(average_response_time_above_ten_seconds_seconds, 0), attribute(limited_availability_seconds, 0), attribute(weekly_unavailability_seconds, 0), attribute(complete_unavailability_users, 0), attribute(limited_availability_users, 0), attribute(data_compromised, false), attribute(physical_access_compromised, false)], Profile).
nis2_implementing_regulation_significant_incidents_profile_for(entity_type_absent_open, Profile) :-
    with_article([attribute(complete_unavailability_seconds, 1), attribute(average_response_time_above_ten_seconds_seconds, 0), attribute(limited_availability_seconds, 0), attribute(weekly_unavailability_seconds, 0), attribute(complete_unavailability_users, 0), attribute(limited_availability_users, 0), attribute(data_compromised, false), attribute(physical_access_compromised, false)], Profile).
nis2_implementing_regulation_significant_incidents_profile_for(death_unsure_decisive, Profile) :-
    dns_article_closed(Article),
    append([[attribute(scheduled_interruption_or_maintenance, false), attribute(direct_financial_loss_euro_cents, 0), attribute(trade_secret_exfiltration, false), attribute(death_of_natural_person, unsure), attribute(considerable_damage_to_natural_person_health, false), attribute(suspectedly_malicious_unauthorised_access_capable_of_severe_operational_disruption, false), attribute(recurring_incidents_within_six_months, 1)], Article], Profile).
nis2_implementing_regulation_significant_incidents_profile_for(death_unsure_count_absent, Profile) :-
    dns_article_closed(Article),
    append([[attribute(scheduled_interruption_or_maintenance, false), attribute(direct_financial_loss_euro_cents, 0), attribute(trade_secret_exfiltration, false), attribute(death_of_natural_person, unsure), attribute(considerable_damage_to_natural_person_health, false), attribute(suspectedly_malicious_unauthorised_access_capable_of_severe_operational_disruption, false)], Article], Profile).
nis2_implementing_regulation_significant_incidents_profile_for(data_compromised_unsure_tld, Profile) :-
    with_article([attribute(relevant_entity_type, tld_name_registry), attribute(complete_unavailability_seconds, 0), attribute(average_response_time_above_ten_seconds_seconds, 0), attribute(data_compromised, unsure)], Profile).
nis2_implementing_regulation_significant_incidents_profile_for(unsure_irrelevant_loss_met, [attribute(scheduled_interruption_or_maintenance, false), attribute(direct_financial_loss_euro_cents, 50000001), attribute(death_of_natural_person, unsure)]).
nis2_implementing_regulation_significant_incidents_profile_for(wrong_type_float_loss, [attribute(scheduled_interruption_or_maintenance, false), attribute(direct_financial_loss_euro_cents, -150)]).
nis2_implementing_regulation_significant_incidents_profile_for(duplicate_and_unknown_keys, [attribute(scheduled_interruption_or_maintenance, false), attribute(scheduled_interruption_or_maintenance, true), attribute(colour, blue)]).
nis2_implementing_regulation_significant_incidents_profile_for(profile_not_attribute_list, [scheduled_interruption_or_maintenance - false]).

nis2_implementing_regulation_significant_incidents_assess(Subject, Result) :-
    nis2_implementing_regulation_significant_incidents_profile_for(Subject, Profile),
    decide_nis2_implementing_regulation_significant_incidents(Profile, Result).
