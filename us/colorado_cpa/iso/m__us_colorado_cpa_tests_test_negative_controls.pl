% SPDX-License-Identifier: EUPL-1.2
:- module(m__us_colorado_cpa_tests_test_negative_controls, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__us_colorado_cpa_colorado_cpa, [applicability_status/3, minors_duties_applicability/3, extended_response_deadline/4, extended_appeal_response_deadline/4, cure_period_last_day/4, attorney_general_action_status/5, universal_opt_out_recognition_date/4, colorado_cpa_status_values/1]).
:- use_module(m__us_colorado_cpa_fixtures, [colorado_cpa_profile_for/2]).

test(the_status_table_has_near_miss_atoms) :-
    colorado_cpa_status_values(StatusValues),
    StatusValues == [in_scope, biometric_only_scope, out_of_scope, exempt_entity].
test(general_threshold_positive) :-
    colorado_cpa_profile_for(large_linked_controller, Profile),
    applicability_status(Profile, in_scope, _).
test(general_threshold_near_miss_is_out_of_scope) :-
    colorado_cpa_profile_for(controller_just_below_general_threshold, Profile),
    applicability_status(Profile, out_of_scope, _).
test(sale_threshold_positive) :-
    colorado_cpa_profile_for(sale_controller_at_threshold, Profile),
    applicability_status(Profile, in_scope, _).
test(sale_threshold_near_miss_is_out_of_scope) :-
    colorado_cpa_profile_for(sale_controller_just_below_threshold, Profile),
    applicability_status(Profile, out_of_scope, _).
test(no_sale_revenue_at_twenty_five_thousand_is_out_of_scope) :-
    applicability_status([attribute(entity_category, none_of_the_exempt_categories), attribute(colorado_link_for_general_duties, true), attribute(consumer_count, 25000), attribute(revenue_or_discount_from_sale, false), attribute(processes_biometric_data, false)], out_of_scope, _).
test(no_business_link_is_out_of_scope) :-
    colorado_cpa_profile_for(unlinked_controller_without_biometric_data, Profile),
    applicability_status(Profile, out_of_scope, _).
test(biometric_data_gives_biometric_only_scope) :-
    colorado_cpa_profile_for(unlinked_controller_with_biometric_data, Profile),
    applicability_status(Profile, biometric_only_scope, _).
test(an_air_carrier_is_exempt) :-
    colorado_cpa_profile_for(regulated_air_carrier, Profile),
    applicability_status(Profile, exempt_entity, [cite(us_co_crs_6_1_1304_2_l)]).
test(a_non_exempt_controller_with_the_same_facts_is_in_scope) :-
    applicability_status([attribute(entity_category, none_of_the_exempt_categories), attribute(colorado_link_for_general_duties, true), attribute(consumer_count, 500000)], in_scope, _).
test(a_glba_institution_is_exempt_from_the_minors_sections) :-
    colorado_cpa_profile_for(glba_financial_institution, Profile),
    minors_duties_applicability(Profile, exempt_entity, [cite(us_co_crs_6_1_1304_2_q)]).
test(minors_link_positive) :-
    colorado_cpa_profile_for(minors_linked_controller, Profile),
    minors_duties_applicability(Profile, in_scope, _).
test(minors_link_near_miss_is_out_of_scope) :-
    colorado_cpa_profile_for(minors_unlinked_controller, Profile),
    minors_duties_applicability(Profile, out_of_scope, _).
test(timely_notice_gives_the_extended_date) :-
    colorado_cpa_profile_for(response_extension_granted, Profile),
    extended_response_deadline(Profile, date(2026, 1, 1), date(2026, 4, 1), _).
test(late_notice_gives_no_extension) :-
    colorado_cpa_profile_for(response_extension_notice_late, Profile),
    extended_response_deadline(Profile, date(2026, 1, 1), no_extension_available, _).
test(an_unnecessary_extension_gives_no_extension) :-
    extended_response_deadline([attribute(extension_reasonably_necessary, false), attribute(extension_notice_given_within_initial_period, true)], date(2026, 1, 1), no_extension_available, _).
test(a_necessary_appeal_extension_gives_the_extended_date) :-
    colorado_cpa_profile_for(appeal_extension_granted, Profile),
    extended_appeal_response_deadline(Profile, date(2026, 3, 1), date(2026, 6, 14), _).
test(an_unnecessary_appeal_extension_gives_no_extension) :-
    colorado_cpa_profile_for(appeal_extension_not_necessary, Profile),
    extended_appeal_response_deadline(Profile, date(2026, 3, 1), no_extension_available, _).
test(a_notice_on_the_last_day_in_force_has_a_cure_period) :-
    cure_period_last_day([], date(2026, 12, 30), date(2027, 2, 28), _).
test(a_notice_on_the_repeal_day_is_not_in_force) :-
    cure_period_last_day([], date(2026, 12, 31), cure_provision_not_in_force, _).
test(a_notice_on_the_first_day_in_force_has_a_cure_period) :-
    cure_period_last_day([], date(2025, 10, 1), date(2025, 11, 30), _).
test(a_notice_the_day_before_is_not_in_force) :-
    cure_period_last_day([], date(2025, 9, 30), cure_provision_not_in_force, _).
test(the_sixty_first_day_allows_an_action_on_an_uncured_violation) :-
    colorado_cpa_profile_for(minors_enforcement_uncured, Profile),
    attorney_general_action_status(Profile, date(2026, 3, 1), date(2026, 5, 1), action_may_be_brought, _).
test(the_sixtieth_day_is_still_running) :-
    colorado_cpa_profile_for(minors_enforcement_uncured, Profile),
    attorney_general_action_status(Profile, date(2026, 3, 1), date(2026, 4, 30), cure_period_running, _).
test(a_cured_violation_bars_the_action) :-
    colorado_cpa_profile_for(minors_enforcement_cured, Profile),
    attorney_general_action_status(Profile, date(2026, 3, 1), date(2026, 5, 1), no_action_for_cured_violation, _).
test(no_cure_possible_needs_no_notice) :-
    colorado_cpa_profile_for(minors_enforcement_cure_impossible, Profile),
    attorney_general_action_status(Profile, date(2026, 3, 1), date(2026, 3, 15), cure_requirement_not_applicable, _).
test(the_repeal_day_is_outside_the_provision) :-
    colorado_cpa_profile_for(minors_enforcement_uncured, Profile),
    attorney_general_action_status(Profile, date(2026, 10, 1), date(2026, 12, 31), cure_provision_not_in_force, _).
test(the_last_day_in_force_allows_an_action) :-
    colorado_cpa_profile_for(minors_enforcement_uncured, Profile),
    attorney_general_action_status(Profile, date(2026, 10, 1), date(2026, 12, 30), action_may_be_brought, _).
test(targeted_advertising_gives_a_recognition_date) :-
    colorado_cpa_profile_for(targeted_advertising_controller, Profile),
    universal_opt_out_recognition_date(Profile, date(2025, 1, 15), date(2025, 7, 15), _).
test(no_targeted_advertising_gives_no_recognition_duty) :-
    colorado_cpa_profile_for(controller_without_targeted_advertising, Profile),
    universal_opt_out_recognition_date(Profile, date(2025, 1, 15), no_recognition_duty, _).
test(an_early_listing_waits_for_the_effective_day) :-
    universal_opt_out_recognition_date([attribute(processes_for_targeted_advertising_or_sale, true)], date(2023, 6, 1), date(2024, 7, 1), _).

test(general_threshold_near_miss_is_not_in_scope, fail) :-
    colorado_cpa_profile_for(controller_just_below_general_threshold, Profile),
    applicability_status(Profile, in_scope, _).
test(sale_threshold_near_miss_is_not_in_scope, fail) :-
    colorado_cpa_profile_for(sale_controller_just_below_threshold, Profile),
    applicability_status(Profile, in_scope, _).
test(no_sale_revenue_at_twenty_five_thousand_is_not_in_scope, fail) :-
    applicability_status([attribute(entity_category, none_of_the_exempt_categories), attribute(colorado_link_for_general_duties, true), attribute(consumer_count, 25000), attribute(revenue_or_discount_from_sale, false), attribute(processes_biometric_data, false)], in_scope, _).
test(no_business_link_is_not_in_scope, fail) :-
    colorado_cpa_profile_for(unlinked_controller_without_biometric_data, Profile),
    applicability_status(Profile, in_scope, _).
test(no_biometric_data_is_not_biometric_only, fail) :-
    colorado_cpa_profile_for(unlinked_controller_without_biometric_data, Profile),
    applicability_status(Profile, biometric_only_scope, _).
test(a_non_exempt_controller_is_not_exempt, fail) :-
    applicability_status([attribute(entity_category, none_of_the_exempt_categories), attribute(colorado_link_for_general_duties, true), attribute(consumer_count, 500000)], exempt_entity, _).
test(a_glba_institution_is_not_in_scope_of_the_minors_sections, fail) :-
    colorado_cpa_profile_for(glba_financial_institution, Profile),
    minors_duties_applicability(Profile, in_scope, _).
test(minors_link_near_miss_is_not_in_scope, fail) :-
    colorado_cpa_profile_for(minors_unlinked_controller, Profile),
    minors_duties_applicability(Profile, in_scope, _).
test(late_notice_gives_no_date, fail) :-
    colorado_cpa_profile_for(response_extension_notice_late, Profile),
    extended_response_deadline(Profile, date(2026, 1, 1), date(_, _, _), _).
test(an_unnecessary_extension_gives_no_date, fail) :-
    extended_response_deadline([attribute(extension_reasonably_necessary, false), attribute(extension_notice_given_within_initial_period, true)], date(2026, 1, 1), date(_, _, _), _).
test(an_unnecessary_appeal_extension_gives_no_date, fail) :-
    colorado_cpa_profile_for(appeal_extension_not_necessary, Profile),
    extended_appeal_response_deadline(Profile, date(2026, 3, 1), date(_, _, _), _).
test(a_notice_on_the_repeal_day_has_no_cure_period, fail) :-
    cure_period_last_day([], date(2026, 12, 31), date(_, _, _), _).
test(a_notice_the_day_before_has_no_cure_period, fail) :-
    cure_period_last_day([], date(2025, 9, 30), date(_, _, _), _).
test(the_sixtieth_day_allows_no_action, fail) :-
    colorado_cpa_profile_for(minors_enforcement_uncured, Profile),
    attorney_general_action_status(Profile, date(2026, 3, 1), date(2026, 4, 30), action_may_be_brought, _).
test(a_cured_violation_does_not_allow_an_action, fail) :-
    colorado_cpa_profile_for(minors_enforcement_cured, Profile),
    attorney_general_action_status(Profile, date(2026, 3, 1), date(2026, 5, 1), action_may_be_brought, _).
test(no_cure_possible_is_not_running, fail) :-
    colorado_cpa_profile_for(minors_enforcement_cure_impossible, Profile),
    attorney_general_action_status(Profile, date(2026, 3, 1), date(2026, 3, 15), cure_period_running, _).
test(no_targeted_advertising_gives_no_date, fail) :-
    colorado_cpa_profile_for(controller_without_targeted_advertising, Profile),
    universal_opt_out_recognition_date(Profile, date(2025, 1, 15), date(_, _, _), _).
test(an_early_listing_is_not_six_months_later, fail) :-
    universal_opt_out_recognition_date([attribute(processes_for_targeted_advertising_or_sale, true)], date(2023, 6, 1), date(2023, 12, 1), _).

cp_test_names([the_status_table_has_near_miss_atoms, general_threshold_positive, general_threshold_near_miss_is_out_of_scope, sale_threshold_positive, sale_threshold_near_miss_is_out_of_scope, no_sale_revenue_at_twenty_five_thousand_is_out_of_scope, no_business_link_is_out_of_scope, biometric_data_gives_biometric_only_scope, an_air_carrier_is_exempt, a_non_exempt_controller_with_the_same_facts_is_in_scope, a_glba_institution_is_exempt_from_the_minors_sections, minors_link_positive, minors_link_near_miss_is_out_of_scope, timely_notice_gives_the_extended_date, late_notice_gives_no_extension, an_unnecessary_extension_gives_no_extension, a_necessary_appeal_extension_gives_the_extended_date, an_unnecessary_appeal_extension_gives_no_extension, a_notice_on_the_last_day_in_force_has_a_cure_period, a_notice_on_the_repeal_day_is_not_in_force, a_notice_on_the_first_day_in_force_has_a_cure_period, a_notice_the_day_before_is_not_in_force, the_sixty_first_day_allows_an_action_on_an_uncured_violation, the_sixtieth_day_is_still_running, a_cured_violation_bars_the_action, no_cure_possible_needs_no_notice, the_repeal_day_is_outside_the_provision, the_last_day_in_force_allows_an_action, targeted_advertising_gives_a_recognition_date, no_targeted_advertising_gives_no_recognition_duty, an_early_listing_waits_for_the_effective_day]).
cp_test_fail_names([general_threshold_near_miss_is_not_in_scope, sale_threshold_near_miss_is_not_in_scope, no_sale_revenue_at_twenty_five_thousand_is_not_in_scope, no_business_link_is_not_in_scope, no_biometric_data_is_not_biometric_only, a_non_exempt_controller_is_not_exempt, a_glba_institution_is_not_in_scope_of_the_minors_sections, minors_link_near_miss_is_not_in_scope, late_notice_gives_no_date, an_unnecessary_extension_gives_no_date, an_unnecessary_appeal_extension_gives_no_date, a_notice_on_the_repeal_day_has_no_cure_period, a_notice_the_day_before_has_no_cure_period, the_sixtieth_day_allows_no_action, a_cured_violation_does_not_allow_an_action, no_cure_possible_is_not_running, no_targeted_advertising_gives_no_date, an_early_listing_is_not_six_months_later]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
