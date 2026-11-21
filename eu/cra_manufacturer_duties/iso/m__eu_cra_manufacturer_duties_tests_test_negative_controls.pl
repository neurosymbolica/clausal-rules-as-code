% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_cra_manufacturer_duties_tests_test_negative_controls, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_cra_manufacturer_duties_cra_manufacturer_duties, [requirements_applicability/4, support_period_minimum/4, retention_end_date/5, cra_manufacturer_duties_status_values/1]).

test(the_near_miss_atoms_are_verdict_names) :-
    cra_manufacturer_duties_status_values(StatusValues),
    member(not_yet_applicable, StatusValues),
    member(article_14_only, StatusValues),
    member(subject_to_requirements, StatusValues),
    member(indeterminate, StatusValues),
    member(needs_legal_review, StatusValues),
    member(minimum_support_period, StatusValues),
    member(keep_until, StatusValues),
    member(not_applicable_outside_support_period, StatusValues),
    member(input_problems, StatusValues).
test(a1_positive_the_day_before_article_14) :-
    requirements_applicability([], date(2026, 9, 10), not_yet_applicable, [cite(eu_reg_2024_2847_art_71_2)]).
test(a2_positive_the_last_day_of_the_window) :-
    requirements_applicability([attribute(placing_on_market_date, date(2028, 1, 10))], date(2027, 12, 10), article_14_only, [cite(eu_reg_2024_2847_art_71_2)]).
test(a3_positive_placing_date_absent) :-
    requirements_applicability([], date(2027, 12, 11), indeterminate([placing_on_market_date]), []).
test(a4_positive_placed_on_the_application_date) :-
    requirements_applicability([attribute(placing_on_market_date, date(2027, 12, 11)), attribute(substantially_modified_on_or_after_application_date, false)], date(2028, 3, 1), subject_to_requirements, [cite(eu_reg_2024_2847_art_71_2)]).
test(a5_positive_modified_is_subject) :-
    requirements_applicability([attribute(placing_on_market_date, date(2025, 5, 5)), attribute(substantially_modified_on_or_after_application_date, true)], date(2028, 3, 1), subject_to_requirements, [cite(eu_reg_2024_2847_art_69_2)]).
test(a5_positive_not_modified_is_article_14_only) :-
    requirements_applicability([attribute(placing_on_market_date, date(2025, 5, 5)), attribute(substantially_modified_on_or_after_application_date, false)], date(2028, 3, 1), article_14_only, [cite(eu_reg_2024_2847_art_69_2), cite(eu_reg_2024_2847_art_69_3)]).
test(a5_positive_absent_judgement_is_asked) :-
    requirements_applicability([attribute(placing_on_market_date, date(2025, 5, 5))], date(2028, 3, 1), indeterminate([substantially_modified_on_or_after_application_date]), []).
test(a5_positive_unsure_goes_to_a_lawyer) :-
    requirements_applicability([attribute(placing_on_market_date, date(2025, 5, 5)), attribute(substantially_modified_on_or_after_application_date, unsure)], date(2028, 3, 1), needs_legal_review(_, _), []).
test(a0_positive_unknown_key_is_refused) :-
    requirements_applicability([attribute(colour, red)], date(2028, 3, 1), input_problems([unknown_key(colour)]), []).
test(b1_positive_the_day_before_application) :-
    support_period_minimum([attribute(expected_use_time_in_months, 72)], date(2027, 12, 10), not_yet_applicable, [cite(eu_reg_2024_2847_art_71_2)]).
test(b2_positive_use_time_absent) :-
    support_period_minimum([], date(2028, 3, 1), indeterminate([expected_use_time_in_months]), []).
test(b3_positive_sixty_months_at_the_floor) :-
    support_period_minimum([attribute(expected_use_time_in_months, 60)], date(2028, 3, 1), minimum_support_period(60), [cite(eu_reg_2024_2847_art_13_8)]).
test(b3_positive_short_use_time_is_the_floor) :-
    support_period_minimum([attribute(expected_use_time_in_months, 59)], date(2028, 3, 1), minimum_support_period(59), [cite(eu_reg_2024_2847_art_13_8)]).
test(c1_positive_the_day_before_application) :-
    retention_end_date([], date(2027, 12, 10), security_update, not_yet_applicable, [cite(eu_reg_2024_2847_art_71_2)]).
test(c2_positive_start_key_asked_first) :-
    retention_end_date([], date(2028, 3, 1), security_update, indeterminate([security_update_issue_date]), []).
test(c2_positive_support_end_asked_next) :-
    retention_end_date([attribute(placing_on_market_date, date(2028, 2, 1))], date(2028, 3, 1), information_and_instructions_to_the_user, indeterminate([support_period_end_date]), []).
test(c3_positive_update_the_day_after) :-
    retention_end_date([attribute(security_update_issue_date, date(2031, 1, 2)), attribute(support_period_end_date, date(2031, 1, 1))], date(2031, 2, 1), security_update, not_applicable_outside_support_period, [cite(eu_reg_2024_2847_art_13_9)]).
test(c4_positive_support_end_one_day_longer_wins) :-
    retention_end_date([attribute(placing_on_market_date, date(2028, 2, 1)), attribute(support_period_end_date, date(2038, 2, 2))], date(2028, 3, 1), technical_documentation_and_declaration_of_conformity, keep_until(date(2038, 2, 2)), [cite(eu_reg_2024_2847_art_13_13)]).
test(c4_positive_leap_day_moves_to_the_twenty_eighth) :-
    retention_end_date([attribute(security_update_issue_date, date(2028, 2, 29)), attribute(support_period_end_date, date(2030, 1, 1))], date(2028, 3, 1), security_update, keep_until(date(2038, 2, 28)), [cite(eu_reg_2024_2847_art_13_9)]).
test(c4_positive_instructions_cite_article_13_18) :-
    retention_end_date([attribute(placing_on_market_date, date(2028, 2, 1)), attribute(support_period_end_date, date(2033, 2, 1))], date(2028, 3, 1), information_and_instructions_to_the_user, keep_until(date(2038, 2, 1)), [cite(eu_reg_2024_2847_art_13_18)]).

test(a1_near_miss_on_the_article_14_date, fail) :-
    requirements_applicability([], date(2026, 9, 11), not_yet_applicable, _).
test(a2_near_miss_on_the_application_date, fail) :-
    requirements_applicability([attribute(placing_on_market_date, date(2028, 1, 10))], date(2027, 12, 11), article_14_only, _).
test(a3_near_miss_placing_date_present, fail) :-
    requirements_applicability([attribute(placing_on_market_date, date(2027, 12, 11))], date(2027, 12, 11), indeterminate([placing_on_market_date]), _).
test(a4_near_miss_placed_the_day_before, fail) :-
    requirements_applicability([attribute(placing_on_market_date, date(2027, 12, 10)), attribute(substantially_modified_on_or_after_application_date, false)], date(2028, 3, 1), subject_to_requirements, _).
test(a5_near_miss_not_modified_is_not_subject, fail) :-
    requirements_applicability([attribute(placing_on_market_date, date(2025, 5, 5)), attribute(substantially_modified_on_or_after_application_date, false)], date(2028, 3, 1), subject_to_requirements, _).
test(a5_near_miss_modified_is_not_article_14_only, fail) :-
    requirements_applicability([attribute(placing_on_market_date, date(2025, 5, 5)), attribute(substantially_modified_on_or_after_application_date, true)], date(2028, 3, 1), article_14_only, _).
test(a5_near_miss_new_product_does_not_ask_the_judgement, fail) :-
    requirements_applicability([attribute(placing_on_market_date, date(2027, 12, 11))], date(2028, 3, 1), indeterminate([substantially_modified_on_or_after_application_date]), _).
test(a5_near_miss_true_does_not_go_to_a_lawyer, fail) :-
    requirements_applicability([attribute(placing_on_market_date, date(2025, 5, 5)), attribute(substantially_modified_on_or_after_application_date, true)], date(2028, 3, 1), needs_legal_review(_, _), _).
test(a5_near_miss_unsure_in_the_window_does_not_go_to_a_lawyer, fail) :-
    requirements_applicability([attribute(placing_on_market_date, date(2025, 5, 5)), attribute(substantially_modified_on_or_after_application_date, unsure)], date(2027, 12, 10), needs_legal_review(_, _), _).
test(a0_near_miss_a_contract_key_is_not_refused, fail) :-
    requirements_applicability([attribute(placing_on_market_date, date(2028, 1, 1))], date(2028, 3, 1), input_problems(_), _).
test(b1_near_miss_on_the_application_date, fail) :-
    support_period_minimum([attribute(expected_use_time_in_months, 72)], date(2027, 12, 11), not_yet_applicable, _).
test(b2_near_miss_use_time_present, fail) :-
    support_period_minimum([attribute(expected_use_time_in_months, 0)], date(2028, 3, 1), indeterminate(_), _).
test(b3_near_miss_fifty_nine_is_not_sixty, fail) :-
    support_period_minimum([attribute(expected_use_time_in_months, 59)], date(2028, 3, 1), minimum_support_period(60), _).
test(b3_near_miss_long_use_time_is_not_itself, fail) :-
    support_period_minimum([attribute(expected_use_time_in_months, 61)], date(2028, 3, 1), minimum_support_period(61), _).
test(c1_near_miss_on_the_application_date, fail) :-
    retention_end_date([], date(2027, 12, 11), security_update, not_yet_applicable, _).
test(c2_near_miss_the_placing_date_is_not_the_update_start, fail) :-
    retention_end_date([attribute(placing_on_market_date, date(2028, 2, 1))], date(2028, 3, 1), security_update, indeterminate([support_period_end_date]), _).
test(c3_near_miss_update_on_the_last_day, fail) :-
    retention_end_date([attribute(security_update_issue_date, date(2031, 1, 1)), attribute(support_period_end_date, date(2031, 1, 1))], date(2031, 2, 1), security_update, not_applicable_outside_support_period, _).
test(c4_near_miss_support_end_one_day_shorter_does_not_win, fail) :-
    retention_end_date([attribute(placing_on_market_date, date(2028, 2, 1)), attribute(support_period_end_date, date(2038, 1, 31))], date(2028, 3, 1), technical_documentation_and_declaration_of_conformity, keep_until(date(2038, 1, 31)), _).
test(c4_near_miss_leap_day_does_not_move_to_march, fail) :-
    retention_end_date([attribute(security_update_issue_date, date(2028, 2, 29)), attribute(support_period_end_date, date(2030, 1, 1))], date(2028, 3, 1), security_update, keep_until(date(2038, 3, 1)), _).
test(c4_near_miss_instructions_do_not_cite_article_13_13, fail) :-
    retention_end_date([attribute(placing_on_market_date, date(2028, 2, 1)), attribute(support_period_end_date, date(2033, 2, 1))], date(2028, 3, 1), information_and_instructions_to_the_user, _, [cite(eu_reg_2024_2847_art_13_13)]).

cp_test_names([the_near_miss_atoms_are_verdict_names, a1_positive_the_day_before_article_14, a2_positive_the_last_day_of_the_window, a3_positive_placing_date_absent, a4_positive_placed_on_the_application_date, a5_positive_modified_is_subject, a5_positive_not_modified_is_article_14_only, a5_positive_absent_judgement_is_asked, a5_positive_unsure_goes_to_a_lawyer, a0_positive_unknown_key_is_refused, b1_positive_the_day_before_application, b2_positive_use_time_absent, b3_positive_sixty_months_at_the_floor, b3_positive_short_use_time_is_the_floor, c1_positive_the_day_before_application, c2_positive_start_key_asked_first, c2_positive_support_end_asked_next, c3_positive_update_the_day_after, c4_positive_support_end_one_day_longer_wins, c4_positive_leap_day_moves_to_the_twenty_eighth, c4_positive_instructions_cite_article_13_18]).
cp_test_fail_names([a1_near_miss_on_the_article_14_date, a2_near_miss_on_the_application_date, a3_near_miss_placing_date_present, a4_near_miss_placed_the_day_before, a5_near_miss_not_modified_is_not_subject, a5_near_miss_modified_is_not_article_14_only, a5_near_miss_new_product_does_not_ask_the_judgement, a5_near_miss_true_does_not_go_to_a_lawyer, a5_near_miss_unsure_in_the_window_does_not_go_to_a_lawyer, a0_near_miss_a_contract_key_is_not_refused, b1_near_miss_on_the_application_date, b2_near_miss_use_time_present, b3_near_miss_fifty_nine_is_not_sixty, b3_near_miss_long_use_time_is_not_itself, c1_near_miss_on_the_application_date, c2_near_miss_the_placing_date_is_not_the_update_start, c3_near_miss_update_on_the_last_day, c4_near_miss_support_end_one_day_shorter_does_not_win, c4_near_miss_leap_day_does_not_move_to_march, c4_near_miss_instructions_do_not_cite_article_13_13]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
