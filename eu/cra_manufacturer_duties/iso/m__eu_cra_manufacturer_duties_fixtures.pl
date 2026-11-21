% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_cra_manufacturer_duties_fixtures, [cra_manufacturer_duties_subject/1, cra_manufacturer_duties_profile_for/2, cra_manufacturer_duties_assess/2]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_cra_manufacturer_duties_cra_manufacturer_duties, [decide_cra_manufacturer_duties/2]).

cra_manufacturer_duties_subject(before_article_14_date).
cra_manufacturer_duties_subject(article_14_window_opens).
cra_manufacturer_duties_subject(article_14_window_last_day).
cra_manufacturer_duties_subject(missing_placing_date).
cra_manufacturer_duties_subject(placed_on_application_day).
cra_manufacturer_duties_subject(placed_day_before_application_unmodified).
cra_manufacturer_duties_subject(legacy_product_modified).
cra_manufacturer_duties_subject(legacy_product_unmodified).
cra_manufacturer_duties_subject(legacy_product_unsure).
cra_manufacturer_duties_subject(legacy_product_judgement_missing).
cra_manufacturer_duties_subject(unknown_key_in_profile).
cra_manufacturer_duties_subject(duplicate_and_unknown_keys).
cra_manufacturer_duties_subject(impossible_assessment_date).
cra_manufacturer_duties_subject(support_floor_day_before_application).
cra_manufacturer_duties_subject(support_floor_on_application_day).
cra_manufacturer_duties_subject(long_lived_router).
cra_manufacturer_duties_subject(use_time_at_floor).
cra_manufacturer_duties_subject(use_time_just_below_floor).
cra_manufacturer_duties_subject(use_time_zero).
cra_manufacturer_duties_subject(missing_use_time).
cra_manufacturer_duties_subject(negative_use_time).
cra_manufacturer_duties_subject(retention_day_before_application).
cra_manufacturer_duties_subject(documentation_ten_years_wins).
cra_manufacturer_duties_subject(documentation_equal_dates).
cra_manufacturer_duties_subject(documentation_support_period_one_day_longer).
cra_manufacturer_duties_subject(instructions_support_period_wins).
cra_manufacturer_duties_subject(instructions_ten_years_wins).
cra_manufacturer_duties_subject(leap_day_update).
cra_manufacturer_duties_subject(day_after_leap_day_update).
cra_manufacturer_duties_subject(update_on_last_day).
cra_manufacturer_duties_subject(update_day_after_last_day).
cra_manufacturer_duties_subject(retention_missing_start).
cra_manufacturer_duties_subject(retention_missing_end).
cra_manufacturer_duties_subject(unknown_item).

cra_manufacturer_duties_profile_for(before_article_14_date, requirements_applicability([], date(2026, 9, 10))).
cra_manufacturer_duties_profile_for(article_14_window_opens, requirements_applicability([], date(2026, 9, 11))).
cra_manufacturer_duties_profile_for(article_14_window_last_day, requirements_applicability([attribute(placing_on_market_date, date(2028, 1, 10))], date(2027, 12, 10))).
cra_manufacturer_duties_profile_for(missing_placing_date, requirements_applicability([], date(2027, 12, 11))).
cra_manufacturer_duties_profile_for(placed_on_application_day, requirements_applicability([attribute(placing_on_market_date, date(2027, 12, 11))], date(2028, 3, 1))).
cra_manufacturer_duties_profile_for(placed_day_before_application_unmodified, requirements_applicability([attribute(placing_on_market_date, date(2027, 12, 10)), attribute(substantially_modified_on_or_after_application_date, false)], date(2028, 3, 1))).
cra_manufacturer_duties_profile_for(legacy_product_modified, requirements_applicability([attribute(placing_on_market_date, date(2025, 5, 5)), attribute(substantially_modified_on_or_after_application_date, true)], date(2028, 3, 1))).
cra_manufacturer_duties_profile_for(legacy_product_unmodified, requirements_applicability([attribute(placing_on_market_date, date(2025, 5, 5)), attribute(substantially_modified_on_or_after_application_date, false)], date(2028, 3, 1))).
cra_manufacturer_duties_profile_for(legacy_product_unsure, requirements_applicability([attribute(placing_on_market_date, date(2025, 5, 5)), attribute(substantially_modified_on_or_after_application_date, unsure)], date(2028, 3, 1))).
cra_manufacturer_duties_profile_for(legacy_product_judgement_missing, requirements_applicability([attribute(placing_on_market_date, date(2025, 5, 5))], date(2028, 3, 1))).
cra_manufacturer_duties_profile_for(unknown_key_in_profile, requirements_applicability([attribute(colour, red)], date(2028, 3, 1))).
cra_manufacturer_duties_profile_for(duplicate_and_unknown_keys, requirements_applicability([attribute(placing_on_market_date, date(2028, 1, 10)), attribute(placing_on_market_date, date(2028, 1, 11)), attribute(colour, red)], date(2028, 3, 1))).
cra_manufacturer_duties_profile_for(impossible_assessment_date, requirements_applicability([], date(2027, 2, 30))).
cra_manufacturer_duties_profile_for(support_floor_day_before_application, support_period_minimum([attribute(expected_use_time_in_months, 72)], date(2027, 12, 10))).
cra_manufacturer_duties_profile_for(support_floor_on_application_day, support_period_minimum([attribute(expected_use_time_in_months, 72)], date(2027, 12, 11))).
cra_manufacturer_duties_profile_for(long_lived_router, support_period_minimum([attribute(expected_use_time_in_months, 120)], date(2028, 3, 1))).
cra_manufacturer_duties_profile_for(use_time_at_floor, support_period_minimum([attribute(expected_use_time_in_months, 60)], date(2028, 3, 1))).
cra_manufacturer_duties_profile_for(use_time_just_below_floor, support_period_minimum([attribute(expected_use_time_in_months, 59)], date(2028, 3, 1))).
cra_manufacturer_duties_profile_for(use_time_zero, support_period_minimum([attribute(expected_use_time_in_months, 0)], date(2028, 3, 1))).
cra_manufacturer_duties_profile_for(missing_use_time, support_period_minimum([], date(2028, 3, 1))).
cra_manufacturer_duties_profile_for(negative_use_time, support_period_minimum([attribute(expected_use_time_in_months, -1)], date(2028, 3, 1))).
cra_manufacturer_duties_profile_for(retention_day_before_application, retention_end_date([], date(2027, 12, 10), technical_documentation_and_declaration_of_conformity)).
cra_manufacturer_duties_profile_for(documentation_ten_years_wins, retention_end_date([attribute(placing_on_market_date, date(2028, 2, 1)), attribute(support_period_end_date, date(2033, 2, 1))], date(2028, 3, 1), technical_documentation_and_declaration_of_conformity)).
cra_manufacturer_duties_profile_for(documentation_equal_dates, retention_end_date([attribute(placing_on_market_date, date(2028, 2, 1)), attribute(support_period_end_date, date(2038, 2, 1))], date(2028, 3, 1), technical_documentation_and_declaration_of_conformity)).
cra_manufacturer_duties_profile_for(documentation_support_period_one_day_longer, retention_end_date([attribute(placing_on_market_date, date(2028, 2, 1)), attribute(support_period_end_date, date(2038, 2, 2))], date(2028, 3, 1), technical_documentation_and_declaration_of_conformity)).
cra_manufacturer_duties_profile_for(instructions_support_period_wins, retention_end_date([attribute(placing_on_market_date, date(2028, 2, 1)), attribute(support_period_end_date, date(2040, 6, 30))], date(2028, 3, 1), information_and_instructions_to_the_user)).
cra_manufacturer_duties_profile_for(instructions_ten_years_wins, retention_end_date([attribute(placing_on_market_date, date(2028, 2, 1)), attribute(support_period_end_date, date(2033, 2, 1))], date(2028, 3, 1), information_and_instructions_to_the_user)).
cra_manufacturer_duties_profile_for(leap_day_update, retention_end_date([attribute(security_update_issue_date, date(2028, 2, 29)), attribute(support_period_end_date, date(2030, 1, 1))], date(2028, 3, 1), security_update)).
cra_manufacturer_duties_profile_for(day_after_leap_day_update, retention_end_date([attribute(security_update_issue_date, date(2028, 3, 1)), attribute(support_period_end_date, date(2030, 1, 1))], date(2028, 3, 2), security_update)).
cra_manufacturer_duties_profile_for(update_on_last_day, retention_end_date([attribute(security_update_issue_date, date(2031, 1, 1)), attribute(support_period_end_date, date(2031, 1, 1))], date(2031, 2, 1), security_update)).
cra_manufacturer_duties_profile_for(update_day_after_last_day, retention_end_date([attribute(security_update_issue_date, date(2031, 1, 2)), attribute(support_period_end_date, date(2031, 1, 1))], date(2031, 2, 1), security_update)).
cra_manufacturer_duties_profile_for(retention_missing_start, retention_end_date([attribute(support_period_end_date, date(2033, 2, 1))], date(2028, 3, 1), technical_documentation_and_declaration_of_conformity)).
cra_manufacturer_duties_profile_for(retention_missing_end, retention_end_date([attribute(placing_on_market_date, date(2028, 2, 1))], date(2028, 3, 1), technical_documentation_and_declaration_of_conformity)).
cra_manufacturer_duties_profile_for(unknown_item, retention_end_date([], date(2028, 3, 1), manual)).

cra_manufacturer_duties_assess(Subject, Result) :-
    cra_manufacturer_duties_profile_for(Subject, Question),
    decide_cra_manufacturer_duties(Question, Result).
