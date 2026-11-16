% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_nis2_implementing_regulation_significant_incidents_nis2_implementing_regulation_significant_incidents, [significant_incident_criteria/3, decide_nis2_implementing_regulation_significant_incidents/2, nis2_implementing_regulation_significant_incidents_status/2, nis2_implementing_regulation_significant_incidents_checklist/2, nis2_implementing_regulation_significant_incidents_decision_resolvable/1, nis2_implementing_regulation_significant_incidents_status_values/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(library(pairs), [pairs_values/2]).
:- use_module(library(clpz)).
:- use_module(library(reif), [memberd_t/3]).
:- use_module(formalize_lib, [profile_get/3, profile_keys/2]).
:- use_module(m__eu_nis2_implementing_regulation_significant_incidents_kernel, [nis2_implementing_regulation_significant_incidents_input_problems/2]).
:- use_module(m__eu_nis2_implementing_regulation_significant_incidents_citations, [implements/1]).

nis2_implementing_regulation_significant_incidents_status_values([significant, not_significant]).

result_citations(significant, [cite(eu_reg_2024_2690_art_3_1)]).
result_citations(not_significant, [cite(eu_reg_2024_2690_art_3_1), cite(eu_reg_2024_2690_art_3_2)]).

duration_limit(no_duration, 0, cite(eu_reg_2024_2690_art_3_1_g)).
duration_limit(twenty_minutes, 1200, cite(eu_reg_2024_2690_art_14_a)).
duration_limit(thirty_minutes, 1800, cite(eu_reg_2024_2690_art_3_1_g)).
duration_limit(one_hour, 3600, cite(eu_reg_2024_2690_art_3_1_g)).

smaller_of_threshold(loss_five_percent_of_turnover_or_five_hundred_thousand_euro, threshold(5, 100, 50000000), cite(eu_reg_2024_2690_art_3_1_a)).
smaller_of_threshold(five_percent_or_one_million_users, threshold(5, 100, 1000000), cite(eu_reg_2024_2690_art_3_1_g)).
smaller_of_threshold(one_percent_or_two_hundred_thousand_users, threshold(1, 100, 200000), cite(eu_reg_2024_2690_art_14_c)).
smaller_of_threshold(tenth_of_one_percent_or_one_hundred_users, threshold(1, 1000, 100), cite(eu_reg_2024_2690_art_14_e)).

domain_name_exception(threshold(1, 100, 1000), cite(eu_reg_2024_2690_art_5_c)).

recurring_incident_minimum(2, cite(eu_reg_2024_2690_art_4_a)).

entity_article(dns_service_provider, article_five, cite(eu_reg_2024_2690_art_5)).
entity_article(tld_name_registry, article_six, cite(eu_reg_2024_2690_art_6)).
entity_article(cloud_computing_service_provider, article_seven, cite(eu_reg_2024_2690_art_7)).
entity_article(data_centre_service_provider, article_eight, cite(eu_reg_2024_2690_art_8)).
entity_article(content_delivery_network_provider, article_nine, cite(eu_reg_2024_2690_art_9)).
entity_article(managed_service_provider, article_ten, cite(eu_reg_2024_2690_art_10)).
entity_article(managed_security_service_provider, article_ten, cite(eu_reg_2024_2690_art_10)).
entity_article(online_marketplace_provider, article_eleven, cite(eu_reg_2024_2690_art_11)).
entity_article(online_search_engine_provider, article_twelve, cite(eu_reg_2024_2690_art_12)).
entity_article(social_networking_services_platform_provider, article_thirteen, cite(eu_reg_2024_2690_art_13)).
entity_article(trust_service_provider, article_fourteen, cite(eu_reg_2024_2690_art_14)).

referral_citation(trade_secret_exfiltration, cite(eu_reg_2024_2690_art_3_1_b)).
referral_citation(death_of_natural_person, cite(eu_reg_2024_2690_art_3_1_c)).
referral_citation(considerable_damage_to_natural_person_health, cite(eu_reg_2024_2690_art_3_1_d)).
referral_citation(suspectedly_malicious_unauthorised_access_capable_of_severe_operational_disruption, cite(eu_reg_2024_2690_art_3_1_e)).
referral_citation(same_apparent_root_cause, cite(eu_reg_2024_2690_art_4_b)).
referral_citation(data_compromised, cite(eu_reg_2024_2690_art_3_1_g)).
referral_citation(data_compromise_suspectedly_malicious, cite(eu_reg_2024_2690_art_3_1_g)).
referral_citation(physical_access_compromised, cite(eu_reg_2024_2690_art_3_1_g)).

profile_key_order([scheduled_interruption_or_maintenance, relevant_entity_type, direct_financial_loss_euro_cents, annual_turnover_preceding_financial_year_euro_cents, trade_secret_exfiltration, death_of_natural_person, considerable_damage_to_natural_person_health, suspectedly_malicious_unauthorised_access_capable_of_severe_operational_disruption, recurring_incidents_within_six_months, same_apparent_root_cause, recurring_collective_direct_financial_loss_euro_cents, complete_unavailability_seconds, average_response_time_above_ten_seconds_seconds, limited_availability_seconds, weekly_unavailability_seconds, complete_unavailability_users, limited_availability_users, data_compromise_users, service_users_in_union, data_compromised, data_compromise_suspectedly_malicious, physical_access_compromised, incorrect_data_only_by_misconfiguration, incorrect_domain_names, managed_domain_names]).

key_kind(scheduled_interruption_or_maintenance, crisp).
key_kind(relevant_entity_type, entity_type).
key_kind(direct_financial_loss_euro_cents, figure).
key_kind(annual_turnover_preceding_financial_year_euro_cents, figure).
key_kind(trade_secret_exfiltration, judgement).
key_kind(death_of_natural_person, judgement).
key_kind(considerable_damage_to_natural_person_health, judgement).
key_kind(suspectedly_malicious_unauthorised_access_capable_of_severe_operational_disruption, judgement).
key_kind(recurring_incidents_within_six_months, figure).
key_kind(same_apparent_root_cause, judgement).
key_kind(recurring_collective_direct_financial_loss_euro_cents, figure).
key_kind(complete_unavailability_seconds, figure).
key_kind(average_response_time_above_ten_seconds_seconds, figure).
key_kind(limited_availability_seconds, figure).
key_kind(weekly_unavailability_seconds, figure).
key_kind(complete_unavailability_users, figure).
key_kind(limited_availability_users, figure).
key_kind(data_compromise_users, figure).
key_kind(service_users_in_union, figure).
key_kind(data_compromised, judgement).
key_kind(data_compromise_suspectedly_malicious, judgement).
key_kind(physical_access_compromised, judgement).
key_kind(incorrect_data_only_by_misconfiguration, crisp).
key_kind(incorrect_domain_names, figure).
key_kind(managed_domain_names, figure).

significant_incident_criteria(Profile, Result, Citations) :-
    decide_nis2_implementing_regulation_significant_incidents(Profile, nis2_implementing_regulation_significant_incidents_verdict(Result, Citations)).

decide_nis2_implementing_regulation_significant_incidents(Profile, nis2_implementing_regulation_significant_incidents_verdict(input_problems([Problem|Problems]), [])) :-
    nis2_implementing_regulation_significant_incidents_input_problems(Profile, [Problem|Problems]).
decide_nis2_implementing_regulation_significant_incidents(Profile, nis2_implementing_regulation_significant_incidents_verdict(Result, Citations)) :-
    implements(eu_reg_2024_2690_art_3_1),
    nis2_implementing_regulation_significant_incidents_input_problems(Profile, []),
    profile_readings(Profile, Readings),
    unsure_rule_answer(Readings, Result, Citations).

profile_readings(Profile, Readings) :-
    profile_key_order(Keys),
    profile_keys(Profile, PresentKeys),
    maplist(key_reading(Profile, PresentKeys), Keys, Readings).

key_reading(Profile, PresentKeys, Key, Key - Reading) :-
    memberd_t(Key, PresentKeys, IsPresent),
    present_reading(IsPresent, Profile, Key, Reading).

present_reading(true, Profile, Key, present(Value)) :-
    profile_get(Profile, Key, Value).
present_reading(false, _, _, absent).

entry_value(Key, [EntryKey - EntryValue|_], Value) :-
    Key == EntryKey,
    Value = EntryValue.
entry_value(Key, [EntryKey - _|Entries], Value) :-
    Key \== EntryKey,
    entry_value(Key, Entries, Value).

truth_condition(Key, Readings, Status) :-
    implements(eu_reg_2024_2690_art_3_1),
    entry_value(Key, Readings, Reading),
    truth_status(Reading, Key, Status).

truth_status(present(true), _, holds).
truth_status(present(false), _, fails).
truth_status(present(unsure), _, open([])).
truth_status(absent, Key, open([Key])).

more_condition(Key, Limit, Readings, Status) :-
    implements(eu_reg_2024_2690_art_3_1),
    entry_value(Key, Readings, Reading),
    more_status(Reading, Key, Limit, Status).

more_status(absent, Key, _, open([Key])).
more_status(present(Value), _, Limit, holds) :-
    Value #> Limit.
more_status(present(Value), _, Limit, fails) :-
    Value #=< Limit.

at_least_condition(Key, Minimum, Readings, Status) :-
    implements(eu_reg_2024_2690_art_4_a),
    entry_value(Key, Readings, Reading),
    at_least_status(Reading, Key, Minimum, Status).

at_least_status(absent, Key, _, open([Key])).
at_least_status(present(Value), _, Minimum, holds) :-
    Value #>= Minimum.
at_least_status(present(Value), _, Minimum, fails) :-
    Value #< Minimum.

smaller_of_condition(UserKey, TotalKey, ThresholdName, Readings, Status) :-
    implements(eu_reg_2024_2690_art_3_1),
    smaller_of_threshold(ThresholdName, Threshold, _Citation),
    entry_value(UserKey, Readings, UserReading),
    entry_value(TotalKey, Readings, TotalReading),
    smaller_of_status(UserReading, TotalReading, UserKey, TotalKey, Threshold, Status).

smaller_of_status(present(Count), _, _, _, threshold(_, _, Floor), holds) :-
    Count #> Floor.
smaller_of_status(present(0), _, _, _, _, fails).
smaller_of_status(present(Count), present(Total), _, _, threshold(Numerator, Denominator, Floor), holds) :-
    Count #> 0,
    Count #=< Floor,
    Count * Denominator #> Total * Numerator.
smaller_of_status(present(Count), present(Total), _, _, threshold(Numerator, Denominator, Floor), fails) :-
    Count #> 0,
    Count #=< Floor,
    Count * Denominator #=< Total * Numerator.
smaller_of_status(present(Count), absent, _, TotalKey, threshold(_, _, Floor), open([TotalKey])) :-
    Count #> 0,
    Count #=< Floor.
smaller_of_status(absent, present(_), UserKey, _, _, open([UserKey])).
smaller_of_status(absent, absent, UserKey, TotalKey, _, open([UserKey, TotalKey])).

not_excepted_condition(Readings, Status) :-
    implements(eu_reg_2024_2690_art_5_c),
    domain_name_exception(Threshold, _Citation),
    entry_value(incorrect_data_only_by_misconfiguration, Readings, MisconfigurationReading),
    entry_value(incorrect_domain_names, Readings, IncorrectReading),
    entry_value(managed_domain_names, Readings, ManagedReading),
    incorrect_names_class(IncorrectReading, ManagedReading, Threshold, NamesClass),
    exception_status(MisconfigurationReading, NamesClass, Status).

incorrect_names_class(absent, present(_), _, count_unknown_total_known) :-
    implements(eu_reg_2024_2690_art_5_c).
incorrect_names_class(absent, absent, _, count_unknown_total_unknown) :-
    implements(eu_reg_2024_2690_art_5_c).
incorrect_names_class(present(0), _, _, no_names) :-
    implements(eu_reg_2024_2690_art_5_c).
incorrect_names_class(present(Incorrect), _, threshold(_, _, NameFloor), many_names) :-
    implements(eu_reg_2024_2690_art_5_c),
    Incorrect #>= NameFloor.
incorrect_names_class(present(Incorrect), present(Managed), threshold(Numerator, Denominator, NameFloor), few_names_above_share) :-
    implements(eu_reg_2024_2690_art_5_c),
    Incorrect #> 0,
    Incorrect #< NameFloor,
    Incorrect * Denominator #> Managed * Numerator.
incorrect_names_class(present(Incorrect), present(Managed), threshold(Numerator, Denominator, NameFloor), few_names_within_share) :-
    implements(eu_reg_2024_2690_art_5_c),
    Incorrect #> 0,
    Incorrect #< NameFloor,
    Incorrect * Denominator #=< Managed * Numerator.
incorrect_names_class(present(Incorrect), absent, threshold(_, _, NameFloor), few_names_total_unknown) :-
    implements(eu_reg_2024_2690_art_5_c),
    Incorrect #> 0,
    Incorrect #< NameFloor.

exception_status(present(false), _, holds).
exception_status(present(true), many_names, holds).
exception_status(absent, many_names, holds).
exception_status(present(true), few_names_above_share, holds).
exception_status(absent, few_names_above_share, holds).
exception_status(present(true), no_names, fails).
exception_status(present(true), few_names_within_share, fails).
exception_status(absent, no_names, open([incorrect_data_only_by_misconfiguration])).
exception_status(absent, few_names_within_share, open([incorrect_data_only_by_misconfiguration])).
exception_status(absent, few_names_total_unknown, open([incorrect_data_only_by_misconfiguration, managed_domain_names])).
exception_status(absent, count_unknown_total_known, open([incorrect_data_only_by_misconfiguration, incorrect_domain_names])).
exception_status(absent, count_unknown_total_unknown, open([incorrect_data_only_by_misconfiguration, incorrect_domain_names, managed_domain_names])).
exception_status(present(true), count_unknown_total_known, open([incorrect_domain_names])).
exception_status(present(true), count_unknown_total_unknown, open([incorrect_domain_names, managed_domain_names])).
exception_status(present(true), few_names_total_unknown, open([managed_domain_names])).

way_status(Conditions, Status) :-
    foldl(join_condition, Conditions, met, Status).

join_condition(holds, met, met).
join_condition(holds, closed, closed).
join_condition(holds, open(Keys), open(Keys)).
join_condition(fails, _, closed).
join_condition(open(NewKeys), met, open(NewKeys)).
join_condition(open(_), closed, closed).
join_condition(open(NewKeys), open(Keys), open(MergedKeys)) :-
    append_new_keys(Keys, NewKeys, MergedKeys).

append_new_keys(Keys, [], Keys).
append_new_keys(Keys, [NewKey|NewKeys], MergedKeys) :-
    memberd_t(NewKey, Keys, IsKnown),
    add_new_key(IsKnown, Keys, NewKey, NextKeys),
    append_new_keys(NextKeys, NewKeys, MergedKeys).

add_new_key(true, Keys, _, Keys).
add_new_key(false, Keys, NewKey, ExtendedKeys) :-
    append(Keys, [NewKey], ExtendedKeys).

either_outcome(Statuses, Outcome) :-
    foldl(either_step, Statuses, closed, Outcome).

either_step(met, _, met).
either_step(closed, Outcome, Outcome).
either_step(open(_), met, met).
either_step(open(_), closed, open).
either_step(open(_), open, open).

general_way(point_a, Readings, Status) :-
    implements(eu_reg_2024_2690_art_3_1_a),
    smaller_of_condition(direct_financial_loss_euro_cents, annual_turnover_preceding_financial_year_euro_cents, loss_five_percent_of_turnover_or_five_hundred_thousand_euro, Readings, LossCondition),
    way_status([LossCondition], Status).
general_way(point_b, Readings, Status) :-
    implements(eu_reg_2024_2690_art_3_1_b),
    truth_condition(trade_secret_exfiltration, Readings, Condition),
    way_status([Condition], Status).
general_way(point_c, Readings, Status) :-
    implements(eu_reg_2024_2690_art_3_1_c),
    truth_condition(death_of_natural_person, Readings, Condition),
    way_status([Condition], Status).
general_way(point_d, Readings, Status) :-
    implements(eu_reg_2024_2690_art_3_1_d),
    truth_condition(considerable_damage_to_natural_person_health, Readings, Condition),
    way_status([Condition], Status).
general_way(point_e, Readings, Status) :-
    implements(eu_reg_2024_2690_art_3_1_e),
    truth_condition(suspectedly_malicious_unauthorised_access_capable_of_severe_operational_disruption, Readings, Condition),
    way_status([Condition], Status).
general_way(point_f, Readings, Status) :-
    implements(eu_reg_2024_2690_art_3_1_f),
    implements(eu_reg_2024_2690_art_4),
    implements(eu_reg_2024_2690_art_4_a),
    implements(eu_reg_2024_2690_art_4_b),
    implements(eu_reg_2024_2690_art_4_c),
    recurring_incident_minimum(Minimum, _Citation),
    at_least_condition(recurring_incidents_within_six_months, Minimum, Readings, CountCondition),
    truth_condition(same_apparent_root_cause, Readings, CauseCondition),
    smaller_of_condition(recurring_collective_direct_financial_loss_euro_cents, annual_turnover_preceding_financial_year_euro_cents, loss_five_percent_of_turnover_or_five_hundred_thousand_euro, Readings, LossCondition),
    way_status([CountCondition, CauseCondition, LossCondition], Status).

criteria_way_statuses(Readings, Statuses) :-
    general_way(point_a, Readings, LossStatus),
    general_way(point_b, Readings, TradeSecretStatus),
    general_way(point_c, Readings, DeathStatus),
    general_way(point_d, Readings, HealthStatus),
    general_way(point_e, Readings, AccessStatus),
    general_way(point_f, Readings, RecurringStatus),
    entry_value(relevant_entity_type, Readings, TypeReading),
    entity_article_way_statuses(TypeReading, Readings, ArticleStatuses),
    append([LossStatus, TradeSecretStatus, DeathStatus, HealthStatus, AccessStatus, RecurringStatus], ArticleStatuses, Statuses).

entity_article_way_statuses(present(EntityType), Readings, Statuses) :-
    implements(eu_reg_2024_2690_art_3_1_g),
    implements(eu_reg_2024_2690_art_1),
    entity_article(EntityType, Article, _Citation),
    article_way_statuses(Article, Readings, Statuses).
entity_article_way_statuses(absent, Readings, [Status]) :-
    implements(eu_reg_2024_2690_art_3_1_g),
    implements(eu_reg_2024_2690_art_1),
    findall(Outcome, entity_type_outcome(Readings, Outcome), Outcomes),
    every_type_outcome(Outcomes, Status).

entity_type_outcome(Readings, Outcome) :-
    entity_article(_EntityType, Article, _Citation),
    article_way_statuses(Article, Readings, Statuses),
    either_outcome(Statuses, Outcome).

article_way_statuses(Article, Readings, Statuses) :-
    findall(Status, article_way(Article, _Point, Readings, Status), Statuses).

every_type_outcome(Outcomes, met) :-
    implements(eu_reg_2024_2690_art_3_1_g),
    sort(Outcomes, [met]).
every_type_outcome(Outcomes, closed) :-
    implements(eu_reg_2024_2690_art_3_1_g),
    sort(Outcomes, [closed]).
every_type_outcome(Outcomes, open([relevant_entity_type])) :-
    implements(eu_reg_2024_2690_art_3_1_g),
    sort(Outcomes, [open]).
every_type_outcome(Outcomes, open([relevant_entity_type])) :-
    implements(eu_reg_2024_2690_art_3_1_g),
    sort(Outcomes, [_, _|_]).

duration_way(Key, LimitName, Readings, Status) :-
    implements(eu_reg_2024_2690_art_3_1_g),
    duration_limit(LimitName, Limit, _Citation),
    more_condition(Key, Limit, Readings, Condition),
    way_status([Condition], Status).

limited_availability_for_users_way(Readings, Status) :-
    implements(eu_reg_2024_2690_art_3_1_g),
    duration_limit(one_hour, Limit, _Citation),
    more_condition(limited_availability_seconds, Limit, Readings, DurationCondition),
    smaller_of_condition(limited_availability_users, service_users_in_union, five_percent_or_one_million_users, Readings, UsersCondition),
    way_status([DurationCondition, UsersCondition], Status).

users_way(UserKey, ThresholdName, Readings, Status) :-
    implements(eu_reg_2024_2690_art_3_1_g),
    smaller_of_condition(UserKey, service_users_in_union, ThresholdName, Readings, Condition),
    way_status([Condition], Status).

judgement_way(Key, Readings, Status) :-
    implements(eu_reg_2024_2690_art_3_1_g),
    truth_condition(Key, Readings, Condition),
    way_status([Condition], Status).

malicious_data_compromise_way(Readings, Status) :-
    implements(eu_reg_2024_2690_art_3_1_g),
    truth_condition(data_compromised, Readings, DataCondition),
    truth_condition(data_compromise_suspectedly_malicious, Readings, MaliciousCondition),
    way_status([DataCondition, MaliciousCondition], Status).

data_compromise_for_users_way(ThresholdName, Readings, Status) :-
    implements(eu_reg_2024_2690_art_3_1_g),
    truth_condition(data_compromised, Readings, DataCondition),
    smaller_of_condition(data_compromise_users, service_users_in_union, ThresholdName, Readings, UsersCondition),
    way_status([DataCondition, UsersCondition], Status).

domain_name_data_compromise_way(Readings, Status) :-
    implements(eu_reg_2024_2690_art_5_c),
    truth_condition(data_compromised, Readings, DataCondition),
    not_excepted_condition(Readings, ExceptionCondition),
    way_status([DataCondition, ExceptionCondition], Status).

article_way(article_five, point_a, Readings, Status) :-
    implements(eu_reg_2024_2690_art_3_1_g),
    implements(eu_reg_2024_2690_art_5),
    implements(eu_reg_2024_2690_art_5_a),
    duration_way(complete_unavailability_seconds, thirty_minutes, Readings, Status).
article_way(article_five, point_b, Readings, Status) :-
    implements(eu_reg_2024_2690_art_3_1_g),
    implements(eu_reg_2024_2690_art_5),
    implements(eu_reg_2024_2690_art_5_b),
    duration_way(average_response_time_above_ten_seconds_seconds, one_hour, Readings, Status).
article_way(article_five, point_c, Readings, Status) :-
    implements(eu_reg_2024_2690_art_3_1_g),
    implements(eu_reg_2024_2690_art_5),
    implements(eu_reg_2024_2690_art_5_c),
    domain_name_data_compromise_way(Readings, Status).
article_way(article_six, point_a, Readings, Status) :-
    implements(eu_reg_2024_2690_art_3_1_g),
    implements(eu_reg_2024_2690_art_6),
    implements(eu_reg_2024_2690_art_6_a),
    duration_way(complete_unavailability_seconds, no_duration, Readings, Status).
article_way(article_six, point_b, Readings, Status) :-
    implements(eu_reg_2024_2690_art_3_1_g),
    implements(eu_reg_2024_2690_art_6),
    implements(eu_reg_2024_2690_art_6_b),
    duration_way(average_response_time_above_ten_seconds_seconds, one_hour, Readings, Status).
article_way(article_six, point_c, Readings, Status) :-
    implements(eu_reg_2024_2690_art_3_1_g),
    implements(eu_reg_2024_2690_art_6),
    implements(eu_reg_2024_2690_art_6_c),
    judgement_way(data_compromised, Readings, Status).
article_way(article_seven, point_a, Readings, Status) :-
    implements(eu_reg_2024_2690_art_3_1_g),
    implements(eu_reg_2024_2690_art_7),
    implements(eu_reg_2024_2690_art_7_a),
    duration_way(complete_unavailability_seconds, thirty_minutes, Readings, Status).
article_way(article_seven, point_b, Readings, Status) :-
    implements(eu_reg_2024_2690_art_3_1_g),
    implements(eu_reg_2024_2690_art_7),
    implements(eu_reg_2024_2690_art_7_b),
    limited_availability_for_users_way(Readings, Status).
article_way(article_seven, point_c, Readings, Status) :-
    implements(eu_reg_2024_2690_art_3_1_g),
    implements(eu_reg_2024_2690_art_7),
    implements(eu_reg_2024_2690_art_7_c),
    malicious_data_compromise_way(Readings, Status).
article_way(article_seven, point_d, Readings, Status) :-
    implements(eu_reg_2024_2690_art_3_1_g),
    implements(eu_reg_2024_2690_art_7),
    implements(eu_reg_2024_2690_art_7_d),
    data_compromise_for_users_way(five_percent_or_one_million_users, Readings, Status).
article_way(article_eight, point_a, Readings, Status) :-
    implements(eu_reg_2024_2690_art_3_1_g),
    implements(eu_reg_2024_2690_art_8),
    implements(eu_reg_2024_2690_art_8_a),
    duration_way(complete_unavailability_seconds, no_duration, Readings, Status).
article_way(article_eight, point_b, Readings, Status) :-
    implements(eu_reg_2024_2690_art_3_1_g),
    implements(eu_reg_2024_2690_art_8),
    implements(eu_reg_2024_2690_art_8_b),
    duration_way(limited_availability_seconds, one_hour, Readings, Status).
article_way(article_eight, point_c, Readings, Status) :-
    implements(eu_reg_2024_2690_art_3_1_g),
    implements(eu_reg_2024_2690_art_8),
    implements(eu_reg_2024_2690_art_8_c),
    malicious_data_compromise_way(Readings, Status).
article_way(article_eight, point_d, Readings, Status) :-
    implements(eu_reg_2024_2690_art_3_1_g),
    implements(eu_reg_2024_2690_art_8),
    implements(eu_reg_2024_2690_art_8_d),
    judgement_way(physical_access_compromised, Readings, Status).
article_way(article_nine, point_a, Readings, Status) :-
    implements(eu_reg_2024_2690_art_3_1_g),
    implements(eu_reg_2024_2690_art_9),
    implements(eu_reg_2024_2690_art_9_a),
    duration_way(complete_unavailability_seconds, thirty_minutes, Readings, Status).
article_way(article_nine, point_b, Readings, Status) :-
    implements(eu_reg_2024_2690_art_3_1_g),
    implements(eu_reg_2024_2690_art_9),
    implements(eu_reg_2024_2690_art_9_b),
    limited_availability_for_users_way(Readings, Status).
article_way(article_nine, point_c, Readings, Status) :-
    implements(eu_reg_2024_2690_art_3_1_g),
    implements(eu_reg_2024_2690_art_9),
    implements(eu_reg_2024_2690_art_9_c),
    malicious_data_compromise_way(Readings, Status).
article_way(article_nine, point_d, Readings, Status) :-
    implements(eu_reg_2024_2690_art_3_1_g),
    implements(eu_reg_2024_2690_art_9),
    implements(eu_reg_2024_2690_art_9_d),
    data_compromise_for_users_way(five_percent_or_one_million_users, Readings, Status).
article_way(article_ten, point_a, Readings, Status) :-
    implements(eu_reg_2024_2690_art_3_1_g),
    implements(eu_reg_2024_2690_art_10),
    implements(eu_reg_2024_2690_art_10_a),
    duration_way(complete_unavailability_seconds, thirty_minutes, Readings, Status).
article_way(article_ten, point_b, Readings, Status) :-
    implements(eu_reg_2024_2690_art_3_1_g),
    implements(eu_reg_2024_2690_art_10),
    implements(eu_reg_2024_2690_art_10_b),
    limited_availability_for_users_way(Readings, Status).
article_way(article_ten, point_c, Readings, Status) :-
    implements(eu_reg_2024_2690_art_3_1_g),
    implements(eu_reg_2024_2690_art_10),
    implements(eu_reg_2024_2690_art_10_c),
    malicious_data_compromise_way(Readings, Status).
article_way(article_ten, point_d, Readings, Status) :-
    implements(eu_reg_2024_2690_art_3_1_g),
    implements(eu_reg_2024_2690_art_10),
    implements(eu_reg_2024_2690_art_10_d),
    data_compromise_for_users_way(five_percent_or_one_million_users, Readings, Status).
article_way(article_eleven, point_a, Readings, Status) :-
    implements(eu_reg_2024_2690_art_3_1_g),
    implements(eu_reg_2024_2690_art_11),
    implements(eu_reg_2024_2690_art_11_a),
    users_way(complete_unavailability_users, five_percent_or_one_million_users, Readings, Status).
article_way(article_eleven, point_b, Readings, Status) :-
    implements(eu_reg_2024_2690_art_3_1_g),
    implements(eu_reg_2024_2690_art_11),
    implements(eu_reg_2024_2690_art_11_b),
    users_way(limited_availability_users, five_percent_or_one_million_users, Readings, Status).
article_way(article_eleven, point_c, Readings, Status) :-
    implements(eu_reg_2024_2690_art_3_1_g),
    implements(eu_reg_2024_2690_art_11),
    implements(eu_reg_2024_2690_art_11_c),
    malicious_data_compromise_way(Readings, Status).
article_way(article_eleven, point_d, Readings, Status) :-
    implements(eu_reg_2024_2690_art_3_1_g),
    implements(eu_reg_2024_2690_art_11),
    implements(eu_reg_2024_2690_art_11_d),
    data_compromise_for_users_way(five_percent_or_one_million_users, Readings, Status).
article_way(article_twelve, point_a, Readings, Status) :-
    implements(eu_reg_2024_2690_art_3_1_g),
    implements(eu_reg_2024_2690_art_12),
    implements(eu_reg_2024_2690_art_12_a),
    users_way(complete_unavailability_users, five_percent_or_one_million_users, Readings, Status).
article_way(article_twelve, point_b, Readings, Status) :-
    implements(eu_reg_2024_2690_art_3_1_g),
    implements(eu_reg_2024_2690_art_12),
    implements(eu_reg_2024_2690_art_12_b),
    users_way(limited_availability_users, five_percent_or_one_million_users, Readings, Status).
article_way(article_twelve, point_c, Readings, Status) :-
    implements(eu_reg_2024_2690_art_3_1_g),
    implements(eu_reg_2024_2690_art_12),
    implements(eu_reg_2024_2690_art_12_c),
    malicious_data_compromise_way(Readings, Status).
article_way(article_twelve, point_d, Readings, Status) :-
    implements(eu_reg_2024_2690_art_3_1_g),
    implements(eu_reg_2024_2690_art_12),
    implements(eu_reg_2024_2690_art_12_d),
    data_compromise_for_users_way(five_percent_or_one_million_users, Readings, Status).
article_way(article_thirteen, point_a, Readings, Status) :-
    implements(eu_reg_2024_2690_art_3_1_g),
    implements(eu_reg_2024_2690_art_13),
    implements(eu_reg_2024_2690_art_13_a),
    users_way(complete_unavailability_users, five_percent_or_one_million_users, Readings, Status).
article_way(article_thirteen, point_b, Readings, Status) :-
    implements(eu_reg_2024_2690_art_3_1_g),
    implements(eu_reg_2024_2690_art_13),
    implements(eu_reg_2024_2690_art_13_b),
    users_way(limited_availability_users, five_percent_or_one_million_users, Readings, Status).
article_way(article_thirteen, point_c, Readings, Status) :-
    implements(eu_reg_2024_2690_art_3_1_g),
    implements(eu_reg_2024_2690_art_13),
    implements(eu_reg_2024_2690_art_13_c),
    malicious_data_compromise_way(Readings, Status).
article_way(article_thirteen, point_d, Readings, Status) :-
    implements(eu_reg_2024_2690_art_3_1_g),
    implements(eu_reg_2024_2690_art_13),
    implements(eu_reg_2024_2690_art_13_d),
    data_compromise_for_users_way(five_percent_or_one_million_users, Readings, Status).
article_way(article_fourteen, point_a, Readings, Status) :-
    implements(eu_reg_2024_2690_art_3_1_g),
    implements(eu_reg_2024_2690_art_14),
    implements(eu_reg_2024_2690_art_14_a),
    duration_way(complete_unavailability_seconds, twenty_minutes, Readings, Status).
article_way(article_fourteen, point_b, Readings, Status) :-
    implements(eu_reg_2024_2690_art_3_1_g),
    implements(eu_reg_2024_2690_art_14),
    implements(eu_reg_2024_2690_art_14_b),
    duration_way(weekly_unavailability_seconds, one_hour, Readings, Status).
article_way(article_fourteen, point_c, Readings, Status) :-
    implements(eu_reg_2024_2690_art_3_1_g),
    implements(eu_reg_2024_2690_art_14),
    implements(eu_reg_2024_2690_art_14_c),
    users_way(limited_availability_users, one_percent_or_two_hundred_thousand_users, Readings, Status).
article_way(article_fourteen, point_d, Readings, Status) :-
    implements(eu_reg_2024_2690_art_3_1_g),
    implements(eu_reg_2024_2690_art_14),
    implements(eu_reg_2024_2690_art_14_d),
    judgement_way(physical_access_compromised, Readings, Status).
article_way(article_fourteen, point_e, Readings, Status) :-
    implements(eu_reg_2024_2690_art_3_1_g),
    implements(eu_reg_2024_2690_art_14),
    implements(eu_reg_2024_2690_art_14_e),
    data_compromise_for_users_way(tenth_of_one_percent_or_one_hundred_users, Readings, Status).

ladder_result(Readings, Result) :-
    entry_value(scheduled_interruption_or_maintenance, Readings, ScheduledReading),
    scheduled_ladder(ScheduledReading, Readings, Result).

scheduled_ladder(present(true), _, not_significant) :-
    implements(eu_reg_2024_2690_art_3_2).
scheduled_ladder(present(false), Readings, Result) :-
    implements(eu_reg_2024_2690_art_3_1),
    criteria_ladder(present(false), Readings, Result).
scheduled_ladder(absent, Readings, Result) :-
    implements(eu_reg_2024_2690_art_3_1),
    criteria_ladder(absent, Readings, Result).

criteria_ladder(ScheduledReading, Readings, Result) :-
    criteria_way_statuses(Readings, Statuses),
    either_outcome(Statuses, Outcome),
    outcome_ladder(Outcome, ScheduledReading, Statuses, Result).

outcome_ladder(met, present(false), _, significant) :-
    implements(eu_reg_2024_2690_art_3_1).
outcome_ladder(met, absent, _, indeterminate([scheduled_interruption_or_maintenance])) :-
    implements(eu_reg_2024_2690_art_3_2).
outcome_ladder(closed, _, _, not_significant) :-
    implements(eu_reg_2024_2690_art_3_1).
outcome_ladder(open, absent, _, indeterminate([scheduled_interruption_or_maintenance])) :-
    implements(eu_reg_2024_2690_art_3_2).
outcome_ladder(open, present(false), Statuses, indeterminate([MissingKey])) :-
    implements(eu_reg_2024_2690_art_3_1),
    fewest_needed_first_key(Statuses, MissingKey).

fewest_needed_first_key(Statuses, MissingKey) :-
    implements(eu_reg_2024_2690_art_3_1),
    open_way_keys(Statuses, [FirstKeys|OtherKeys]),
    foldl(fewer_needed_keys, OtherKeys, FirstKeys, [MissingKey|_]).

open_way_keys([], []).
open_way_keys([open(Keys)|Statuses], [Keys|KeyLists]) :-
    open_way_keys(Statuses, KeyLists).
open_way_keys([met|Statuses], KeyLists) :-
    open_way_keys(Statuses, KeyLists).
open_way_keys([closed|Statuses], KeyLists) :-
    open_way_keys(Statuses, KeyLists).

fewer_needed_keys(CandidateKeys, CurrentKeys, CandidateKeys) :-
    length(CandidateKeys, CandidateCount),
    length(CurrentKeys, CurrentCount),
    CandidateCount #< CurrentCount.
fewer_needed_keys(CandidateKeys, CurrentKeys, CurrentKeys) :-
    length(CandidateKeys, CandidateCount),
    length(CurrentKeys, CurrentCount),
    CandidateCount #>= CurrentCount.

unsure_rule_answer(Readings, Result, Citations) :-
    unsure_judgement_keys(Readings, UnsureKeys),
    findall(Assignment - SettingResult, setting_result(Readings, UnsureKeys, Assignment, SettingResult), Settings),
    pairs_values(Settings, SettingResults),
    named_missing_keys(SettingResults, NamedKeys),
    unsure_route(NamedKeys, SettingResults, Settings, UnsureKeys, Readings, Result, Citations).

unsure_judgement_keys([], []).
unsure_judgement_keys([Key - present(unsure)|Readings], [Key|Keys]) :-
    unsure_judgement_keys(Readings, Keys).
unsure_judgement_keys([_ - Reading|Readings], Keys) :-
    dif(Reading, present(unsure)),
    unsure_judgement_keys(Readings, Keys).

setting_result(Readings, UnsureKeys, Assignment, SettingResult) :-
    unsure_assignment(UnsureKeys, Assignment),
    settle_readings(Readings, Assignment, SettingReadings),
    ladder_result(SettingReadings, SettingResult).

unsure_assignment([], []).
unsure_assignment([Key|Keys], [Key - Value|Assignment]) :-
    member(Value, [true, false]),
    unsure_assignment(Keys, Assignment).

settle_readings([], [], []).
settle_readings([Key - present(unsure)|Readings], [Key - Value|Assignment], [Key - present(Value)|Settled]) :-
    settle_readings(Readings, Assignment, Settled).
settle_readings([Key - Reading|Readings], Assignment, [Key - Reading|Settled]) :-
    dif(Reading, present(unsure)),
    settle_readings(Readings, Assignment, Settled).

named_missing_keys([], []).
named_missing_keys([indeterminate([Key])|Results], [Key|Keys]) :-
    named_missing_keys(Results, Keys).
named_missing_keys([significant|Results], Keys) :-
    named_missing_keys(Results, Keys).
named_missing_keys([not_significant|Results], Keys) :-
    named_missing_keys(Results, Keys).

unsure_route([NamedKey|NamedKeys], _, _, _, _, indeterminate([MissingKey]), []) :-
    implements(eu_reg_2024_2690_art_3_1),
    profile_key_order(KeyOrder),
    first_in_order(KeyOrder, [NamedKey|NamedKeys], MissingKey).
unsure_route([], SettingResults, _, _, _, Result, Citations) :-
    implements(eu_reg_2024_2690_art_3_1),
    sort(SettingResults, [Result]),
    result_citations(Result, Citations).
unsure_route([], SettingResults, Settings, UnsureKeys, Readings, needs_legal_review(open_textured(TurningKey, Citation), [inputs_relied_on(Pairs)]), []) :-
    implements(eu_reg_2024_2690_art_3_1),
    sort(SettingResults, [_, _|_]),
    first_turning_key(UnsureKeys, Settings, TurningKey),
    referral_citation(TurningKey, Citation),
    relied_judgement_pairs(Readings, Pairs).

first_in_order([Key|Keys], NamedKeys, MissingKey) :-
    memberd_t(Key, NamedKeys, IsNamed),
    first_in_order_choice(IsNamed, Key, Keys, NamedKeys, MissingKey).

first_in_order_choice(true, Key, _, _, Key).
first_in_order_choice(false, _, Keys, NamedKeys, MissingKey) :-
    first_in_order(Keys, NamedKeys, MissingKey).

first_turning_key([UnsureKey|UnsureKeys], Settings, TurningKey) :-
    turns_answer(UnsureKey, Settings, Settings, Turns),
    turning_choice(Turns, UnsureKey, UnsureKeys, Settings, TurningKey).

turning_choice(true, UnsureKey, _, _, UnsureKey).
turning_choice(false, _, UnsureKeys, Settings, TurningKey) :-
    first_turning_key(UnsureKeys, Settings, TurningKey).

turns_answer(_, [], _, false).
turns_answer(UnsureKey, [Assignment - Result|Pending], Settings, Turns) :-
    entry_value(UnsureKey, Assignment, Value),
    flip_differs(Value, UnsureKey, Assignment, Result, Settings, Differs),
    turns_continue(Differs, UnsureKey, Pending, Settings, Turns).

flip_differs(false, _, _, _, _, false).
flip_differs(true, UnsureKey, Assignment, Result, Settings, Differs) :-
    flip_assignment(Assignment, UnsureKey, Flipped),
    setting_lookup(Flipped, Settings, FlippedResult),
    results_differ(Result, FlippedResult, Differs).

turns_continue(true, _, _, _, true).
turns_continue(false, UnsureKey, Pending, Settings, Turns) :-
    turns_answer(UnsureKey, Pending, Settings, Turns).

flip_assignment([], _, []).
flip_assignment([EntryKey - EntryValue|Entries], Key, [EntryKey - FlippedValue|Flipped]) :-
    flip_entry(EntryKey, EntryValue, Key, FlippedValue),
    flip_assignment(Entries, Key, Flipped).

flip_entry(EntryKey, true, Key, false) :-
    EntryKey == Key.
flip_entry(EntryKey, false, Key, true) :-
    EntryKey == Key.
flip_entry(EntryKey, Value, Key, Value) :-
    EntryKey \== Key.

setting_lookup(Assignment, [Other - Result|_], Found) :-
    Assignment == Other,
    Found = Result.
setting_lookup(Assignment, [Other - _|Settings], Found) :-
    Assignment \== Other,
    setting_lookup(Assignment, Settings, Found).

results_differ(Result, Other, true) :-
    Result \== Other.
results_differ(Result, Other, false) :-
    Result == Other.

relied_judgement_pairs([], []).
relied_judgement_pairs([Key - Reading|Readings], Pairs) :-
    key_kind(Key, Kind),
    relied_pair(Kind, Key, Reading, Pairs, LaterPairs),
    relied_judgement_pairs(Readings, LaterPairs).

relied_pair(judgement, Key, present(Value), [Key - Value|LaterPairs], LaterPairs).
relied_pair(judgement, _, absent, LaterPairs, LaterPairs).
relied_pair(Kind, _, _, LaterPairs, LaterPairs) :-
    dif(Kind, judgement).

nis2_implementing_regulation_significant_incidents_status(Profile, Status) :-
    decide_nis2_implementing_regulation_significant_incidents(Profile, nis2_implementing_regulation_significant_incidents_verdict(Status, _Citations)).

nis2_implementing_regulation_significant_incidents_checklist(Profile, [item(input_check, unmet([Problem|Problems]), cite(eu_reg_2024_2690_art_3_1))]) :-
    nis2_implementing_regulation_significant_incidents_input_problems(Profile, [Problem|Problems]).
nis2_implementing_regulation_significant_incidents_checklist(Profile, Items) :-
    nis2_implementing_regulation_significant_incidents_input_problems(Profile, []),
    profile_readings(Profile, Readings),
    criteria_checklist(Readings, Items).

criteria_checklist(Readings, [item(scheduled_interruption_or_maintenance, ScheduledStatus, cite(eu_reg_2024_2690_art_3_2)), item(direct_financial_loss, LossStatus, cite(eu_reg_2024_2690_art_3_1_a)), item(trade_secret_exfiltration, TradeSecretStatus, cite(eu_reg_2024_2690_art_3_1_b)), item(death_of_natural_person, DeathStatus, cite(eu_reg_2024_2690_art_3_1_c)), item(considerable_damage_to_natural_person_health, HealthStatus, cite(eu_reg_2024_2690_art_3_1_d)), item(suspectedly_malicious_unauthorised_access, AccessStatus, cite(eu_reg_2024_2690_art_3_1_e)), item(recurring_incidents, RecurringStatus, cite(eu_reg_2024_2690_art_3_1_f)), item(criteria_of_the_entity_article, ArticleStatus, cite(eu_reg_2024_2690_art_3_1_g))]) :-
    entry_value(scheduled_interruption_or_maintenance, Readings, ScheduledReading),
    scheduled_item_status(ScheduledReading, ScheduledStatus),
    general_way(point_a, Readings, LossWay),
    way_item_status(LossWay, LossStatus),
    general_way(point_b, Readings, TradeSecretWay),
    way_item_status(TradeSecretWay, TradeSecretStatus),
    general_way(point_c, Readings, DeathWay),
    way_item_status(DeathWay, DeathStatus),
    general_way(point_d, Readings, HealthWay),
    way_item_status(HealthWay, HealthStatus),
    general_way(point_e, Readings, AccessWay),
    way_item_status(AccessWay, AccessStatus),
    general_way(point_f, Readings, RecurringWay),
    way_item_status(RecurringWay, RecurringStatus),
    entry_value(relevant_entity_type, Readings, TypeReading),
    entity_article_way_statuses(TypeReading, Readings, ArticleWays),
    article_item_status(ArticleWays, ArticleStatus).

scheduled_item_status(present(false), met).
scheduled_item_status(present(true), unmet(scheduled_interruption_or_maintenance)).
scheduled_item_status(absent, unknown([scheduled_interruption_or_maintenance])).

way_item_status(met, met).
way_item_status(closed, unmet(not_fulfilled)).
way_item_status(open(Keys), unknown(Keys)).

article_item_status(Ways, Status) :-
    either_outcome(Ways, Outcome),
    foldl(merge_open_keys, Ways, [], Keys),
    article_outcome_status(Outcome, Keys, Status).

merge_open_keys(met, Keys, Keys).
merge_open_keys(closed, Keys, Keys).
merge_open_keys(open(NewKeys), Keys, MergedKeys) :-
    append_new_keys(Keys, NewKeys, MergedKeys).

article_outcome_status(met, _, met).
article_outcome_status(closed, _, unmet(not_fulfilled)).
article_outcome_status(open, Keys, unknown(Keys)).

nis2_implementing_regulation_significant_incidents_decision_resolvable(Profile) :-
    decide_nis2_implementing_regulation_significant_incidents(Profile, _Verdict).

quiet_dns_profile([attribute(scheduled_interruption_or_maintenance, false), attribute(relevant_entity_type, dns_service_provider), attribute(direct_financial_loss_euro_cents, 0), attribute(trade_secret_exfiltration, false), attribute(death_of_natural_person, false), attribute(considerable_damage_to_natural_person_health, false), attribute(suspectedly_malicious_unauthorised_access_capable_of_severe_operational_disruption, false), attribute(recurring_incidents_within_six_months, 1), attribute(complete_unavailability_seconds, 0), attribute(average_response_time_above_ten_seconds_seconds, 0), attribute(data_compromised, false)]).

unsure_death_profile([attribute(scheduled_interruption_or_maintenance, false), attribute(relevant_entity_type, dns_service_provider), attribute(direct_financial_loss_euro_cents, 0), attribute(trade_secret_exfiltration, false), attribute(death_of_natural_person, unsure), attribute(considerable_damage_to_natural_person_health, false), attribute(suspectedly_malicious_unauthorised_access_capable_of_severe_operational_disruption, false), attribute(recurring_incidents_within_six_months, 1), attribute(complete_unavailability_seconds, 0), attribute(average_response_time_above_ten_seconds_seconds, 0), attribute(data_compromised, false)]).

test(empty_profile_asks_for_the_scheduled_key_first) :-
    significant_incident_criteria([], Result, Citations),
    Result == indeterminate([scheduled_interruption_or_maintenance]),
    Citations == [].
test(scheduled_interruption_is_not_significant) :-
    significant_incident_criteria([attribute(scheduled_interruption_or_maintenance, true)], Result, Citations),
    Result == not_significant,
    Citations == [cite(eu_reg_2024_2690_art_3_1), cite(eu_reg_2024_2690_art_3_2)].
test(loss_above_five_hundred_thousand_euro_is_significant) :-
    significant_incident_criteria([attribute(scheduled_interruption_or_maintenance, false), attribute(direct_financial_loss_euro_cents, 50000001)], Result, Citations),
    Result == significant,
    Citations == [cite(eu_reg_2024_2690_art_3_1)].
test(met_criterion_without_scheduled_key_asks_for_it) :-
    significant_incident_criteria([attribute(direct_financial_loss_euro_cents, 50000001)], Result, _),
    Result == indeterminate([scheduled_interruption_or_maintenance]).
test(loss_at_the_limit_names_the_first_single_key_way) :-
    significant_incident_criteria([attribute(scheduled_interruption_or_maintenance, false), attribute(direct_financial_loss_euro_cents, 50000000), attribute(annual_turnover_preceding_financial_year_euro_cents, 2000000000)], Result, Citations),
    Result == indeterminate([trade_secret_exfiltration]),
    Citations == [].
test(every_criterion_closed_is_not_significant) :-
    quiet_dns_profile(Profile),
    significant_incident_criteria(Profile, Result, Citations),
    Result == not_significant,
    Citations == [cite(eu_reg_2024_2690_art_3_1), cite(eu_reg_2024_2690_art_3_2)].
test(unsure_judgement_that_turns_goes_to_a_lawyer) :-
    unsure_death_profile(Profile),
    significant_incident_criteria(Profile, Result, Citations),
    Result == needs_legal_review(open_textured(death_of_natural_person, cite(eu_reg_2024_2690_art_3_1_c)), [inputs_relied_on([trade_secret_exfiltration - false, death_of_natural_person - unsure, considerable_damage_to_natural_person_health - false, suspectedly_malicious_unauthorised_access_capable_of_severe_operational_disruption - false, data_compromised - false])]),
    Citations == [].
test(unsure_judgement_gives_exactly_one_answer) :-
    unsure_death_profile(Profile),
    findall(Result - Citations, significant_incident_criteria(Profile, Result, Citations), Answers),
    length(Answers, 1).
test(unsure_judgement_still_names_a_missing_key) :-
    significant_incident_criteria([attribute(scheduled_interruption_or_maintenance, false), attribute(death_of_natural_person, unsure)], Result, _),
    Result == indeterminate([trade_secret_exfiltration]).
test(entity_type_absent_is_named) :-
    significant_incident_criteria([attribute(scheduled_interruption_or_maintenance, false), attribute(direct_financial_loss_euro_cents, 0), attribute(trade_secret_exfiltration, false), attribute(death_of_natural_person, false), attribute(considerable_damage_to_natural_person_health, false), attribute(suspectedly_malicious_unauthorised_access_capable_of_severe_operational_disruption, false), attribute(recurring_incidents_within_six_months, 0)], Result, _),
    Result == indeterminate([relevant_entity_type]).
test(trust_service_data_compromise_above_one_hundred_users) :-
    significant_incident_criteria([attribute(scheduled_interruption_or_maintenance, false), attribute(relevant_entity_type, trust_service_provider), attribute(data_compromised, true), attribute(data_compromise_users, 101)], Result, _),
    Result == significant.
test(dns_misconfiguration_exception_applies) :-
    quiet_dns_profile(Quiet),
    append(Quiet, [attribute(incorrect_data_only_by_misconfiguration, true), attribute(incorrect_domain_names, 5), attribute(managed_domain_names, 1000)], Profile),
    significant_incident_criteria(Profile, Result, _),
    Result == not_significant.
test(dns_misconfiguration_exception_does_not_apply_above_one_percent) :-
    significant_incident_criteria([attribute(scheduled_interruption_or_maintenance, false), attribute(relevant_entity_type, dns_service_provider), attribute(data_compromised, true), attribute(incorrect_data_only_by_misconfiguration, true), attribute(incorrect_domain_names, 5), attribute(managed_domain_names, 400)], Result, _),
    Result == significant.
test(unknown_key_is_an_input_problem) :-
    significant_incident_criteria([attribute(colour, blue)], Result, Citations),
    Result == input_problems([unknown_key(colour)]),
    Citations == [].
test(checklist_has_one_row_per_ground) :-
    quiet_dns_profile(Profile),
    nis2_implementing_regulation_significant_incidents_checklist(Profile, Items),
    length(Items, 8).

test(scheduled_interruption_is_never_significant, fail) :-
    significant_incident_criteria([attribute(scheduled_interruption_or_maintenance, true), attribute(death_of_natural_person, true)], significant, _).
test(every_criterion_closed_is_not_significant_alone, fail) :-
    quiet_dns_profile(Profile),
    significant_incident_criteria(Profile, significant, _).
