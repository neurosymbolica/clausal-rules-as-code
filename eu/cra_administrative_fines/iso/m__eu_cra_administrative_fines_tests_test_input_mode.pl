% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_cra_administrative_fines_tests_test_input_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_cra_administrative_fines_cra_administrative_fines, [administrative_fine_maximum/4, cra_administrative_fines_status/2]).
:- use_module(m__eu_cra_administrative_fines_kernel, [cra_administrative_fines_input_problems/2]).
:- use_module(m__eu_cra_administrative_fines_fixtures, [cra_administrative_fines_profile_for/2]).

test(bound_not_yet_applicable) :-
    administrative_fine_maximum([attribute(infringed_provision, article_14)], date(2027, 12, 10), not_yet_applicable, [cite(eu_reg_2024_2847_art_71_2)]).
test(bound_missing_turnover_on_the_application_day) :-
    administrative_fine_maximum([attribute(infringed_provision, article_14)], date(2027, 12, 11), indeterminate([offender_is_undertaking]), []).
test(bound_missing_provision) :-
    administrative_fine_maximum([], date(2028, 1, 1), indeterminate([infringed_provision]), []).
test(bound_not_listed) :-
    administrative_fine_maximum([attribute(infringed_provision, other_provision)], date(2028, 1, 1), not_listed_in_article_64, [cite(eu_reg_2024_2847_art_64_1), cite(eu_reg_2024_2847_art_64_2), cite(eu_reg_2024_2847_art_64_3), cite(eu_reg_2024_2847_art_64_4)]).
test(bound_fine_excluded) :-
    administrative_fine_maximum([attribute(infringed_provision, article_41), attribute(offender_is_open_source_software_steward, true)], date(2028, 1, 1), fine_excluded(open_source_software_steward), [cite(eu_reg_2024_2847_art_64_10_b)]).
test(bound_fixed_amount_for_non_undertaking) :-
    administrative_fine_maximum([attribute(infringed_provision, article_13), attribute(offender_is_undertaking, false)], date(2028, 1, 1), fine_maximum(highest_maximum_tier, fixed_amount_for_non_undertaking, 1500000000), [cite(eu_reg_2024_2847_art_64_2)]).
test(bound_percentage_cap_with_the_half_cent_dropped) :-
    administrative_fine_maximum([attribute(infringed_provision, article_14), attribute(offender_is_undertaking, true), attribute(total_worldwide_annual_turnover_in_euros, 600000001)], date(2028, 1, 1), fine_maximum(highest_maximum_tier, percentage_of_turnover, 1500000002), [cite(eu_reg_2024_2847_art_64_2)]).
test(bound_lowest_tier_tie_is_the_fixed_amount) :-
    administrative_fine_maximum([attribute(infringed_provision, incorrect_incomplete_or_misleading_information_in_reply_to_request), attribute(offender_is_open_source_software_steward, false), attribute(offender_is_undertaking, true), attribute(total_worldwide_annual_turnover_in_euros, 0)], date(2028, 1, 1), fine_maximum(lowest_maximum_tier, fixed_amount, 500000000), [cite(eu_reg_2024_2847_art_64_4)]).
test(bound_undertaking_referral_in_the_middle_tier) :-
    administrative_fine_maximum([attribute(infringed_provision, article_19), attribute(offender_is_open_source_software_steward, false), attribute(offender_is_undertaking, unsure), attribute(total_worldwide_annual_turnover_in_euros, 5)], date(2028, 1, 1), needs_legal_review(open_textured(offender_is_undertaking, cite(eu_reg_2024_2847_art_64_3)), [inputs_relied_on([offender_is_open_source_software_steward - false, offender_is_undertaking - unsure])]), []).
test(bound_steward_referral) :-
    administrative_fine_maximum([attribute(infringed_provision, article_47), attribute(offender_is_open_source_software_steward, unsure), attribute(offender_is_undertaking, false)], date(2028, 1, 1), needs_legal_review(open_textured(offender_is_open_source_software_steward, cite(eu_reg_2024_2847_art_64_10_b)), [inputs_relied_on([offender_is_open_source_software_steward - unsure, offender_is_undertaking - false])]), []).
test(bound_input_problems) :-
    administrative_fine_maximum([attribute(infringed_provision, article_99)], date(2028, 1, 1), input_problems([wrong_type(infringed_provision)]), []).
test(status_holds_with_the_verdict_bound) :-
    cra_administrative_fines_profile_for(steward_middle_tier, Request),
    cra_administrative_fines_status(Request, fine_excluded(open_source_software_steward)).
test(an_absent_key_is_not_a_problem) :-
    cra_administrative_fines_input_problems([attribute(infringed_provision, article_13)], []).
test(an_unbound_profile_is_wrong_type) :-
    cra_administrative_fines_input_problems(_, [wrong_type(profile)]).
test(a_partial_list_is_wrong_type) :-
    cra_administrative_fines_input_problems([attribute(infringed_provision, article_13)|_], [wrong_type(profile)]).
test(a_list_with_an_unbound_element_is_wrong_type) :-
    cra_administrative_fines_input_problems([attribute(infringed_provision, article_13), _], [wrong_type(profile)]).
test(a_compound_key_is_unknown_as_given) :-
    cra_administrative_fines_input_problems([attribute(colour(red), 1)], Problems),
    Problems == [unknown_key(colour(red))].
test(an_unbound_value_is_wrong_type) :-
    cra_administrative_fines_input_problems([attribute(offender_is_undertaking, _)], [wrong_type(offender_is_undertaking)]).
test(a_duplicate_with_different_values_is_only_a_duplicate) :-
    cra_administrative_fines_input_problems([attribute(offender_is_undertaking, true), attribute(offender_is_undertaking, 7)], Problems),
    Problems == [duplicate_key(offender_is_undertaking)].
test(an_integer_and_a_float_key_are_two_unknown_keys) :-
    cra_administrative_fines_input_problems([attribute(7, a), attribute(7.0, b), attribute(7, c)], Problems),
    Problems == [unknown_key(7), unknown_key(7.0)].
test(a_quoted_string_judgement_is_wrong_type) :-
    cra_administrative_fines_input_problems([attribute(offender_is_open_source_software_steward, "true")], [wrong_type(offender_is_open_source_software_steward)]).
test(a_present_steward_is_checked_even_in_the_highest_tier) :-
    administrative_fine_maximum([attribute(infringed_provision, article_13), attribute(offender_is_open_source_software_steward, maybe), attribute(offender_is_undertaking, false)], date(2028, 1, 1), input_problems([wrong_type(offender_is_open_source_software_steward)]), []).
test(an_unbound_date_is_wrong_type) :-
    administrative_fine_maximum([], _, input_problems([wrong_type(infringement_date)]), []).
test(a_float_year_is_wrong_type) :-
    administrative_fine_maximum([], date(2028.0, 1, 1), input_problems([wrong_type(infringement_date)]), []).
test(the_date_problem_follows_the_profile_problems) :-
    administrative_fine_maximum([attribute(colour, red)], date(2027, 2, 29), input_problems([unknown_key(colour), wrong_type(infringement_date)]), []).

test(bound_not_yet_applicable_rejected_on_the_application_day, fail) :-
    administrative_fine_maximum([attribute(infringed_provision, article_14)], date(2027, 12, 11), not_yet_applicable, _).
test(bound_percentage_cap_rounded_up_is_rejected, fail) :-
    administrative_fine_maximum([attribute(infringed_provision, article_14), attribute(offender_is_undertaking, true), attribute(total_worldwide_annual_turnover_in_euros, 600000001)], date(2028, 1, 1), fine_maximum(highest_maximum_tier, percentage_of_turnover, 1500000003), _).
test(another_bound_status_is_rejected, fail) :-
    cra_administrative_fines_profile_for(steward_middle_tier, Request),
    cra_administrative_fines_status(Request, fine_maximum(_, _, _)).

cp_test_names([bound_not_yet_applicable, bound_missing_turnover_on_the_application_day, bound_missing_provision, bound_not_listed, bound_fine_excluded, bound_fixed_amount_for_non_undertaking, bound_percentage_cap_with_the_half_cent_dropped, bound_lowest_tier_tie_is_the_fixed_amount, bound_undertaking_referral_in_the_middle_tier, bound_steward_referral, bound_input_problems, status_holds_with_the_verdict_bound, an_absent_key_is_not_a_problem, an_unbound_profile_is_wrong_type, a_partial_list_is_wrong_type, a_list_with_an_unbound_element_is_wrong_type, a_compound_key_is_unknown_as_given, an_unbound_value_is_wrong_type, a_duplicate_with_different_values_is_only_a_duplicate, an_integer_and_a_float_key_are_two_unknown_keys, a_quoted_string_judgement_is_wrong_type, a_present_steward_is_checked_even_in_the_highest_tier, an_unbound_date_is_wrong_type, a_float_year_is_wrong_type, the_date_problem_follows_the_profile_problems]).
cp_test_fail_names([bound_not_yet_applicable_rejected_on_the_application_day, bound_percentage_cap_rounded_up_is_rejected, another_bound_status_is_rejected]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
