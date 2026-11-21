% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_cra_manufacturer_duties_tests_test_input_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_cra_manufacturer_duties_kernel, [cra_manufacturer_duties_input_problems/2]).
:- use_module(m__eu_cra_manufacturer_duties_cra_manufacturer_duties, [requirements_applicability/4, support_period_minimum/4, retention_end_date/5, cra_manufacturer_duties_status/2]).
:- use_module(m__eu_cra_manufacturer_duties_fixtures, [cra_manufacturer_duties_profile_for/2]).

test(bound_not_yet_applicable_before_article_14) :-
    requirements_applicability([], date(2026, 9, 10), not_yet_applicable, [cite(eu_reg_2024_2847_art_71_2)]).
test(bound_article_14_only_in_the_window) :-
    requirements_applicability([], date(2027, 6, 1), article_14_only, [cite(eu_reg_2024_2847_art_71_2)]).
test(bound_subject_to_requirements_for_a_new_product) :-
    requirements_applicability([attribute(placing_on_market_date, date(2028, 1, 10))], date(2028, 3, 1), subject_to_requirements, [cite(eu_reg_2024_2847_art_71_2)]).
test(bound_article_14_only_for_an_unmodified_legacy_product) :-
    requirements_applicability([attribute(placing_on_market_date, date(2025, 5, 5)), attribute(substantially_modified_on_or_after_application_date, false)], date(2028, 3, 1), article_14_only, [cite(eu_reg_2024_2847_art_69_2), cite(eu_reg_2024_2847_art_69_3)]).
test(bound_needs_legal_review_for_an_unsure_judgement) :-
    requirements_applicability([attribute(placing_on_market_date, date(2025, 5, 5)), attribute(substantially_modified_on_or_after_application_date, unsure)], date(2028, 3, 1), needs_legal_review(open_textured(substantially_modified_on_or_after_application_date, cite(eu_reg_2024_2847_art_69_2)), [inputs_relied_on([substantially_modified_on_or_after_application_date - unsure])]), []).
test(bound_minimum_support_period_by_value) :-
    support_period_minimum([attribute(expected_use_time_in_months, 59)], date(2028, 3, 1), minimum_support_period(Months), [cite(eu_reg_2024_2847_art_13_8)]),
    Months =:= 59.
test(bound_keep_until_date) :-
    retention_end_date([attribute(placing_on_market_date, date(2028, 2, 1)), attribute(support_period_end_date, date(2033, 2, 1))], date(2028, 3, 1), technical_documentation_and_declaration_of_conformity, keep_until(date(2038, 2, 1)), [cite(eu_reg_2024_2847_art_13_13)]).
test(bound_not_applicable_outside_support_period) :-
    retention_end_date([attribute(security_update_issue_date, date(2031, 1, 2)), attribute(support_period_end_date, date(2031, 1, 1))], date(2031, 2, 1), security_update, not_applicable_outside_support_period, [cite(eu_reg_2024_2847_art_13_9)]).
test(bound_status_from_a_fixture) :-
    cra_manufacturer_duties_profile_for(legacy_product_unmodified, Question),
    cra_manufacturer_duties_status(Question, article_14_only).
test(an_empty_profile_has_no_problem) :-
    cra_manufacturer_duties_input_problems([], Problems),
    Problems == [].
test(an_unbound_profile_is_not_an_attribute_list) :-
    cra_manufacturer_duties_input_problems(_, Problems),
    Problems == [wrong_type(profile)].
test(a_partial_list_is_not_an_attribute_list) :-
    cra_manufacturer_duties_input_problems([attribute(colour, red)|_], Problems),
    Problems == [wrong_type(profile)].
test(an_unbound_element_is_not_an_attribute_list) :-
    cra_manufacturer_duties_input_problems([attribute(colour, red), _], Problems),
    Problems == [wrong_type(profile)].
test(a_foreign_element_is_not_an_attribute_list) :-
    cra_manufacturer_duties_input_problems([attribute(colour, red), colour], Problems),
    Problems == [wrong_type(profile)].
test(a_compound_key_is_an_unknown_key_as_given) :-
    cra_manufacturer_duties_input_problems([attribute(colour(red), 1)], Problems),
    Problems == [unknown_key(colour(red))].
test(a_number_key_is_an_unknown_key) :-
    cra_manufacturer_duties_input_problems([attribute(7, red)], Problems),
    Problems == [unknown_key(7)].
test(a_repeated_unknown_key_is_named_once) :-
    cra_manufacturer_duties_input_problems([attribute(colour, red), attribute(colour, blue)], Problems),
    Problems == [unknown_key(colour)].
test(an_unbound_value_is_wrong_type) :-
    cra_manufacturer_duties_input_problems([attribute(expected_use_time_in_months, _)], Problems),
    Problems == [wrong_type(expected_use_time_in_months)].
test(an_equal_duplicate_is_duplicate_key_only) :-
    cra_manufacturer_duties_input_problems([attribute(support_period_end_date, date(2033, 1, 1)), attribute(support_period_end_date, date(2033, 1, 1))], Problems),
    Problems == [duplicate_key(support_period_end_date)].
test(problems_follow_the_contract_order_then_unknown_keys) :-
    cra_manufacturer_duties_input_problems([attribute(colour, red), attribute(support_period_end_date, nope), attribute(placing_on_market_date, date(2027, 2, 29))], Problems),
    Problems == [wrong_type(placing_on_market_date), wrong_type(support_period_end_date), unknown_key(colour)].
test(a_judgement_outside_the_three_atoms_is_wrong_type) :-
    cra_manufacturer_duties_input_problems([attribute(substantially_modified_on_or_after_application_date, yes)], Problems),
    Problems == [wrong_type(substantially_modified_on_or_after_application_date)].
test(an_unbound_profile_query_is_refused) :-
    findall(Verdict - Citations, support_period_minimum(_, date(2028, 3, 1), Verdict, Citations), Answers),
    Answers == [input_problems([wrong_type(profile)]) - []].
test(a_float_year_is_a_wrong_assessment_date) :-
    findall(Verdict - Citations, requirements_applicability([], date(2028.0, 1, 1), Verdict, Citations), Answers),
    Answers == [input_problems([wrong_type(assessment_date)]) - []].
test(an_unbound_item_is_wrong_type) :-
    findall(Verdict, retention_end_date([], date(2028, 3, 1), _, Verdict, _), Verdicts),
    Verdicts == [input_problems([wrong_type(item)])].
test(an_unread_key_is_still_checked) :-
    findall(Verdict, requirements_applicability([attribute(expected_use_time_in_months, -5)], date(2026, 9, 10), Verdict, _), Verdicts),
    Verdicts == [input_problems([wrong_type(expected_use_time_in_months)])].

test(bound_wrong_citation_is_rejected, fail) :-
    requirements_applicability([attribute(placing_on_market_date, date(2028, 1, 10))], date(2028, 3, 1), subject_to_requirements, [cite(eu_reg_2024_2847_art_69_2)]).
test(bound_wrong_month_count_is_rejected, fail) :-
    support_period_minimum([attribute(expected_use_time_in_months, 59)], date(2028, 3, 1), minimum_support_period(60), _).
test(bound_wrong_keep_until_date_is_rejected, fail) :-
    retention_end_date([attribute(placing_on_market_date, date(2028, 2, 1)), attribute(support_period_end_date, date(2033, 2, 1))], date(2028, 3, 1), technical_documentation_and_declaration_of_conformity, keep_until(date(2033, 2, 1)), _).
test(bound_other_status_from_a_fixture_is_rejected, fail) :-
    cra_manufacturer_duties_profile_for(legacy_product_unmodified, Question),
    cra_manufacturer_duties_status(Question, subject_to_requirements).

cp_test_names([bound_not_yet_applicable_before_article_14, bound_article_14_only_in_the_window, bound_subject_to_requirements_for_a_new_product, bound_article_14_only_for_an_unmodified_legacy_product, bound_needs_legal_review_for_an_unsure_judgement, bound_minimum_support_period_by_value, bound_keep_until_date, bound_not_applicable_outside_support_period, bound_status_from_a_fixture, an_empty_profile_has_no_problem, an_unbound_profile_is_not_an_attribute_list, a_partial_list_is_not_an_attribute_list, an_unbound_element_is_not_an_attribute_list, a_foreign_element_is_not_an_attribute_list, a_compound_key_is_an_unknown_key_as_given, a_number_key_is_an_unknown_key, a_repeated_unknown_key_is_named_once, an_unbound_value_is_wrong_type, an_equal_duplicate_is_duplicate_key_only, problems_follow_the_contract_order_then_unknown_keys, a_judgement_outside_the_three_atoms_is_wrong_type, an_unbound_profile_query_is_refused, a_float_year_is_a_wrong_assessment_date, an_unbound_item_is_wrong_type, an_unread_key_is_still_checked]).
cp_test_fail_names([bound_wrong_citation_is_rejected, bound_wrong_month_count_is_rejected, bound_wrong_keep_until_date_is_rejected, bound_other_status_from_a_fixture_is_rejected]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
