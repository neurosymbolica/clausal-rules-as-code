% SPDX-License-Identifier: EUPL-1.2
:- module(m__us_colorado_cpa_tests_test_input_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__us_colorado_cpa_kernel, [colorado_cpa_input_problems/2]).
:- use_module(m__us_colorado_cpa_colorado_cpa, [applicability_status/3, minors_duties_applicability/3, response_deadline/4, extended_response_deadline/4, appeal_response_deadline/4, extended_appeal_response_deadline/4, cure_period_last_day/4, attorney_general_action_status/5, universal_opt_out_recognition_date/4, colorado_cpa_status/2]).
:- use_module(m__us_colorado_cpa_fixtures, [colorado_cpa_profile_for/2]).

test(bound_in_scope_at_one_hundred_thousand) :-
    colorado_cpa_profile_for(large_linked_controller, Profile),
    applicability_status(Profile, in_scope, [cite(us_co_crs_6_1_1304_1_a), cite(us_co_crs_6_1_1304_1_a_i_a), cite(us_co_crs_6_1_1304_1_a_i_b)]).
test(bound_in_scope_at_twenty_five_thousand_with_sale_revenue) :-
    colorado_cpa_profile_for(sale_controller_at_threshold, Profile),
    applicability_status(Profile, in_scope, _).
test(bound_out_of_scope_just_below_the_general_threshold) :-
    colorado_cpa_profile_for(controller_just_below_general_threshold, Profile),
    applicability_status(Profile, out_of_scope, [cite(us_co_crs_6_1_1304_1_a), cite(us_co_crs_6_1_1304_1_a_i_a), cite(us_co_crs_6_1_1304_1_a_i_b), cite(us_co_crs_6_1_1304_1_a_ii)]).
test(bound_biometric_only_without_the_business_link) :-
    colorado_cpa_profile_for(unlinked_controller_with_biometric_data, Profile),
    applicability_status(Profile, biometric_only_scope, [cite(us_co_crs_6_1_1304_1_a), cite(us_co_crs_6_1_1304_1_a_i_a), cite(us_co_crs_6_1_1304_1_a_i_b), cite(us_co_crs_6_1_1304_1_a_ii)]).
test(bound_exempt_glba_institution) :-
    colorado_cpa_profile_for(glba_financial_institution, Profile),
    applicability_status(Profile, exempt_entity, [cite(us_co_crs_6_1_1304_2_q)]).
test(bound_exempt_securities_association) :-
    colorado_cpa_profile_for(registered_securities_association, Profile),
    applicability_status(Profile, exempt_entity, [cite(us_co_crs_6_1_1304_2_m)]).
test(bound_missing_entity_category) :-
    colorado_cpa_profile_for(controller_without_entity_category, Profile),
    applicability_status(Profile, indeterminate([entity_category]), []).
test(bound_missing_revenue_for_a_middle_count) :-
    colorado_cpa_profile_for(middle_count_controller_without_revenue_fact, Profile),
    applicability_status(Profile, indeterminate([revenue_or_discount_from_sale]), []).
test(bound_unsure_link_with_biometric_unknown_names_biometric) :-
    colorado_cpa_profile_for(controller_with_unsure_link_and_biometric_data_unknown, Profile),
    applicability_status(Profile, indeterminate([processes_biometric_data]), []).
test(bound_unsure_link_goes_to_review) :-
    colorado_cpa_profile_for(controller_with_unsure_link, Profile),
    applicability_status(Profile, needs_legal_review(open_textured(colorado_link_for_general_duties, cite(us_co_crs_6_1_1304_1_a_i_a)), [inputs_relied_on([colorado_link_for_general_duties - unsure])]), []).
test(bound_facade_status) :-
    colorado_cpa_profile_for(regulated_air_carrier, Profile),
    colorado_cpa_status(Profile, exempt_entity).
test(bound_minors_in_scope) :-
    colorado_cpa_profile_for(minors_linked_controller, Profile),
    minors_duties_applicability(Profile, in_scope, [cite(us_co_crs_6_1_1304_1_b)]).
test(bound_minors_out_of_scope) :-
    colorado_cpa_profile_for(minors_unlinked_controller, Profile),
    minors_duties_applicability(Profile, out_of_scope, [cite(us_co_crs_6_1_1304_1_b)]).
test(bound_minors_missing_link) :-
    minors_duties_applicability([attribute(entity_category, none_of_the_exempt_categories)], indeterminate([colorado_link_for_minors_duties]), []).
test(bound_minors_air_carrier_exempt) :-
    minors_duties_applicability([attribute(entity_category, air_carrier)], exempt_entity, [cite(us_co_crs_6_1_1304_2_l)]).
test(bound_response_deadline) :-
    response_deadline([], date(2026, 1, 1), date(2026, 2, 15), [cite(us_co_crs_6_1_1306_2_a), cite(us_co_crs_6_1_1306_2_b)]).
test(bound_response_deadline_across_a_leap_day) :-
    response_deadline([], date(2028, 2, 1), date(2028, 3, 17), _).
test(bound_extended_response_deadline) :-
    colorado_cpa_profile_for(response_extension_granted, Profile),
    extended_response_deadline(Profile, date(2026, 1, 1), date(2026, 4, 1), [cite(us_co_crs_6_1_1306_2_a)]).
test(bound_extended_response_no_extension) :-
    colorado_cpa_profile_for(response_extension_notice_late, Profile),
    extended_response_deadline(Profile, date(2026, 1, 1), no_extension_available, [cite(us_co_crs_6_1_1306_2_a)]).
test(bound_extended_response_review) :-
    colorado_cpa_profile_for(response_extension_necessity_unsure, Profile),
    extended_response_deadline(Profile, date(2026, 1, 1), needs_legal_review(open_textured(extension_reasonably_necessary, cite(us_co_crs_6_1_1306_2_a)), [inputs_relied_on([extension_reasonably_necessary - unsure])]), []).
test(bound_extended_response_missing_necessity) :-
    extended_response_deadline([], date(2026, 1, 1), indeterminate([extension_reasonably_necessary]), []).
test(bound_appeal_response_deadline) :-
    appeal_response_deadline([], date(2026, 3, 1), date(2026, 4, 15), [cite(us_co_crs_6_1_1306_3_b)]).
test(bound_extended_appeal_response_deadline) :-
    colorado_cpa_profile_for(appeal_extension_granted, Profile),
    extended_appeal_response_deadline(Profile, date(2026, 3, 1), date(2026, 6, 14), [cite(us_co_crs_6_1_1306_3_b)]).
test(bound_extended_appeal_not_necessary) :-
    colorado_cpa_profile_for(appeal_extension_not_necessary, Profile),
    extended_appeal_response_deadline(Profile, date(2026, 3, 1), no_extension_available, [cite(us_co_crs_6_1_1306_3_b)]).
test(bound_extended_appeal_review) :-
    colorado_cpa_profile_for(appeal_extension_necessity_unsure, Profile),
    extended_appeal_response_deadline(Profile, date(2026, 3, 1), needs_legal_review(open_textured(appeal_extension_reasonably_necessary, cite(us_co_crs_6_1_1306_3_b)), [inputs_relied_on([appeal_extension_reasonably_necessary - unsure])]), []).
test(bound_cure_period_last_day_on_the_first_day_in_force) :-
    cure_period_last_day([], date(2025, 10, 1), date(2025, 11, 30), [cite(us_co_crs_6_1_1311_1_d_ii)]).
test(bound_cure_period_last_day_after_the_repeal) :-
    cure_period_last_day([], date(2027, 1, 5), cure_provision_not_in_force, [cite(us_co_crs_6_1_1311_1_d_ii)]).
test(bound_action_may_be_brought) :-
    colorado_cpa_profile_for(minors_enforcement_uncured, Profile),
    attorney_general_action_status(Profile, date(2026, 3, 1), date(2026, 5, 1), action_may_be_brought, [cite(us_co_crs_6_1_1311_1_d_ii)]).
test(bound_no_action_for_cured_violation) :-
    colorado_cpa_profile_for(minors_enforcement_cured, Profile),
    attorney_general_action_status(Profile, date(2026, 3, 1), date(2026, 5, 1), no_action_for_cured_violation, [cite(us_co_crs_6_1_1311_1_d_ii)]).
test(bound_cure_requirement_not_applicable) :-
    colorado_cpa_profile_for(minors_enforcement_cure_impossible, Profile),
    attorney_general_action_status(Profile, date(2026, 3, 1), date(2026, 5, 1), cure_requirement_not_applicable, [cite(us_co_crs_6_1_1311_1_d_ii)]).
test(bound_missing_cure_fact) :-
    colorado_cpa_profile_for(minors_enforcement_cure_unknown, Profile),
    attorney_general_action_status(Profile, date(2026, 3, 1), date(2026, 5, 1), indeterminate([cured_within_cure_period]), []).
test(bound_recognition_date) :-
    colorado_cpa_profile_for(targeted_advertising_controller, Profile),
    universal_opt_out_recognition_date(Profile, date(2025, 1, 15), date(2025, 7, 15), [cite(us_co_crs_6_1_1306_1_a_iv_b), cite(us_co_ccr_904_3_rule_5_08_a), cite(us_co_ccr_904_3_rule_5_08_a_3), cite(us_co_ccr_904_3_rule_5_07_f)]).
test(bound_no_recognition_duty) :-
    colorado_cpa_profile_for(controller_without_targeted_advertising, Profile),
    universal_opt_out_recognition_date(Profile, date(2025, 1, 15), no_recognition_duty, [cite(us_co_crs_6_1_1306_1_a_iv_b)]).
test(bound_recognition_missing_key) :-
    universal_opt_out_recognition_date([], date(2025, 1, 15), indeterminate([processes_for_targeted_advertising_or_sale]), []).
test(an_empty_profile_has_no_problem) :-
    colorado_cpa_input_problems([], []).
test(a_non_list_profile_is_wrong_type) :-
    colorado_cpa_input_problems(nonsense, [wrong_type(profile)]).
test(a_list_with_a_foreign_element_is_wrong_type_alone) :-
    colorado_cpa_input_problems([attribute(foo, 1), consumer_count - 5], [wrong_type(profile)]).
test(a_negative_count_is_wrong_type) :-
    colorado_cpa_input_problems([attribute(consumer_count, -1)], [wrong_type(consumer_count)]).
test(a_float_count_is_wrong_type) :-
    colorado_cpa_input_problems([attribute(consumer_count, 1.5)], [wrong_type(consumer_count)]).
test(a_zero_count_is_accepted) :-
    colorado_cpa_input_problems([attribute(consumer_count, 0)], []).
test(unsure_is_wrong_type_for_a_crisp_key) :-
    colorado_cpa_input_problems([attribute(cure_deemed_possible, unsure)], [wrong_type(cure_deemed_possible)]).
test(unsure_is_accepted_for_a_judgement) :-
    colorado_cpa_input_problems([attribute(extension_reasonably_necessary, unsure)], []).
test(an_unlisted_category_is_wrong_type) :-
    colorado_cpa_profile_for(controller_with_unlisted_entity_category, Profile),
    colorado_cpa_input_problems(Profile, [wrong_type(entity_category)]).
test(a_repeated_key_is_a_duplicate_only) :-
    colorado_cpa_profile_for(controller_with_duplicated_count, Profile),
    colorado_cpa_input_problems(Profile, [duplicate_key(consumer_count)]).
test(problems_follow_contract_order_then_unknown_keys_in_profile_order) :-
    colorado_cpa_input_problems([attribute(zeta, 1), attribute(consumer_count, x), attribute(entity_category, bogus), attribute(alpha, 2), attribute(zeta, 3)], Problems),
    Problems == [wrong_type(entity_category), wrong_type(consumer_count), unknown_key(zeta), unknown_key(alpha)].
test(a_number_key_is_unknown_as_given) :-
    colorado_cpa_input_problems([attribute(7, true)], [unknown_key(7)]).
test(a_query_lists_profile_then_date_problems) :-
    response_deadline([attribute(foo, 1)], date(2026, 2, 30), input_problems([unknown_key(foo), wrong_type(received_date)]), []).
test(the_action_status_names_both_dates_in_signature_order) :-
    attorney_general_action_status(nonsense, x, date(1999, 1, 1), input_problems([wrong_type(profile), wrong_type(notice_received_date), wrong_type(reference_date)]), []).
test(a_year_after_twenty_one_hundred_is_wrong_type) :-
    universal_opt_out_recognition_date([], date(2101, 1, 1), input_problems([wrong_type(list_added_date)]), []).
test(the_year_twenty_one_hundred_is_accepted) :-
    appeal_response_deadline([], date(2100, 1, 1), date(2100, 2, 15), _).
test(an_unread_key_is_still_checked) :-
    response_deadline([attribute(consumer_count, -5)], date(2026, 1, 1), input_problems([wrong_type(consumer_count)]), []).
test(an_applicability_query_with_problems_cites_nothing) :-
    applicability_status([attribute(entity_category, 3)], input_problems([wrong_type(entity_category)]), []).

test(bound_wrong_status_is_rejected, fail) :-
    colorado_cpa_profile_for(large_linked_controller, Profile),
    applicability_status(Profile, out_of_scope, _).

cp_test_names([bound_in_scope_at_one_hundred_thousand, bound_in_scope_at_twenty_five_thousand_with_sale_revenue, bound_out_of_scope_just_below_the_general_threshold, bound_biometric_only_without_the_business_link, bound_exempt_glba_institution, bound_exempt_securities_association, bound_missing_entity_category, bound_missing_revenue_for_a_middle_count, bound_unsure_link_with_biometric_unknown_names_biometric, bound_unsure_link_goes_to_review, bound_facade_status, bound_minors_in_scope, bound_minors_out_of_scope, bound_minors_missing_link, bound_minors_air_carrier_exempt, bound_response_deadline, bound_response_deadline_across_a_leap_day, bound_extended_response_deadline, bound_extended_response_no_extension, bound_extended_response_review, bound_extended_response_missing_necessity, bound_appeal_response_deadline, bound_extended_appeal_response_deadline, bound_extended_appeal_not_necessary, bound_extended_appeal_review, bound_cure_period_last_day_on_the_first_day_in_force, bound_cure_period_last_day_after_the_repeal, bound_action_may_be_brought, bound_no_action_for_cured_violation, bound_cure_requirement_not_applicable, bound_missing_cure_fact, bound_recognition_date, bound_no_recognition_duty, bound_recognition_missing_key, an_empty_profile_has_no_problem, a_non_list_profile_is_wrong_type, a_list_with_a_foreign_element_is_wrong_type_alone, a_negative_count_is_wrong_type, a_float_count_is_wrong_type, a_zero_count_is_accepted, unsure_is_wrong_type_for_a_crisp_key, unsure_is_accepted_for_a_judgement, an_unlisted_category_is_wrong_type, a_repeated_key_is_a_duplicate_only, problems_follow_contract_order_then_unknown_keys_in_profile_order, a_number_key_is_unknown_as_given, a_query_lists_profile_then_date_problems, the_action_status_names_both_dates_in_signature_order, a_year_after_twenty_one_hundred_is_wrong_type, the_year_twenty_one_hundred_is_accepted, an_unread_key_is_still_checked, an_applicability_query_with_problems_cites_nothing]).
cp_test_fail_names([bound_wrong_status_is_rejected]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
