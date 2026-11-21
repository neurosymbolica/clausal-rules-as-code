% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_cra_manufacturer_duties_tests_test_queries, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_lists_extra, [min_list/2]).
:- use_module(m__eu_cra_manufacturer_duties_queries, [cra_manufacturer_duties_profile_keys/1, cra_manufacturer_duties_what_if/4, subject_to_requirements/0, article_14_only/0, not_yet_applicable/0, not_applicable_outside_support_period/0, placing_on_market_date/0, substantially_modified_on_or_after_application_date/0, expected_use_time_in_months/0, security_update_issue_date/0, support_period_end_date/0, technical_documentation_and_declaration_of_conformity/0, information_and_instructions_to_the_user/0, security_update/0, unsure/0]).
:- use_module(m__eu_cra_manufacturer_duties_kernel, [cra_manufacturer_duties_input_problems/2]).
:- use_module(m__eu_cra_manufacturer_duties_cra_manufacturer_duties, [requirements_applicability/4, support_period_minimum/4, retention_end_date/5, cra_manufacturer_duties_status/2, cra_manufacturer_duties_checklist/2]).
:- use_module(m__eu_cra_manufacturer_duties_fixtures, [cra_manufacturer_duties_profile_for/2]).

floor_reaches_sixty(ExpectedMonths) :-
    support_period_minimum([attribute(expected_use_time_in_months, ExpectedMonths)], date(2028, 3, 1), minimum_support_period(FloorMonths), _),
    FloorMonths =:= 60.

test(profile_keys_are_the_contract_keys) :-
    cra_manufacturer_duties_profile_keys(ProfileKeys),
    ProfileKeys == [placing_on_market_date, substantially_modified_on_or_after_application_date, expected_use_time_in_months, security_update_issue_date, support_period_end_date].
test(the_root_atoms_are_served) :-
    subject_to_requirements,
    article_14_only,
    not_yet_applicable,
    not_applicable_outside_support_period,
    placing_on_market_date,
    substantially_modified_on_or_after_application_date,
    expected_use_time_in_months,
    security_update_issue_date,
    support_period_end_date,
    technical_documentation_and_declaration_of_conformity,
    information_and_instructions_to_the_user,
    security_update,
    unsure.
test(the_result_constructors_build_as_data) :-
    functor(minimum_support_period(60), FloorName, FloorArity),
    FloorName == minimum_support_period,
    FloorArity == 1,
    keep_until(date(2038, 2, 1)) = keep_until(date(Year, Month, Day)),
    Year == 2038,
    Month == 2,
    Day == 1.
test(the_input_check_is_re_exported) :-
    cra_manufacturer_duties_input_problems([attribute(colour, red)], Problems),
    Problems == [unknown_key(colour)].
test(status_of_a_new_product) :-
    cra_manufacturer_duties_profile_for(placed_on_application_day, Question),
    findall(Status, cra_manufacturer_duties_status(Question, Status), Statuses),
    Statuses == [subject_to_requirements].
test(status_in_the_window) :-
    findall(Verdict, requirements_applicability([], date(2027, 1, 15), Verdict, _), Verdicts),
    Verdicts == [article_14_only].
test(the_floor_is_reached_first_at_sixty_months) :-
    findall(ExpectedMonths, (between(0, 120, ExpectedMonths), floor_reaches_sixty(ExpectedMonths)), ReachingMonths),
    min_list(ReachingMonths, FirstMonths),
    FirstMonths =:= 60.
test(the_floor_is_an_integer) :-
    support_period_minimum([attribute(expected_use_time_in_months, 24)], date(2028, 3, 1), minimum_support_period(FloorMonths), _),
    integer(FloorMonths),
    FloorMonths =:= 24.
test(the_retention_date_is_computed) :-
    findall(Verdict, retention_end_date([attribute(security_update_issue_date, date(2030, 7, 15)), attribute(support_period_end_date, date(2033, 7, 14))], date(2030, 8, 1), security_update, Verdict, _), Verdicts),
    Verdicts == [keep_until(date(2040, 7, 15))].
test(the_support_checklist_cites_each_ground) :-
    findall(Items, cra_manufacturer_duties_checklist(support_period_minimum([attribute(expected_use_time_in_months, 59)], date(2028, 3, 1)), Items), Checklists),
    Checklists == [[item(regulation_applies_at_assessment_date, met, cite(eu_reg_2024_2847_art_71_2)), item(expected_use_time_at_least_five_years, unmet(expected_use_time_below_five_years), cite(eu_reg_2024_2847_art_13_8))]].
test(the_retention_checklist_cites_each_ground) :-
    cra_manufacturer_duties_profile_for(documentation_ten_years_wins, Question),
    findall(Items, cra_manufacturer_duties_checklist(Question, Items), Checklists),
    Checklists == [[item(regulation_applies_at_assessment_date, met, cite(eu_reg_2024_2847_art_71_2)), item(technical_documentation_and_declaration_of_conformity, met, cite(eu_reg_2024_2847_art_13_13))]].
test(what_if_the_use_time_crosses_the_floor) :-
    cra_manufacturer_duties_what_if(support_period_minimum([attribute(expected_use_time_in_months, 59)], date(2028, 3, 1)), expected_use_time_in_months, 60, Verdict),
    Verdict == minimum_support_period(60).
test(what_if_the_update_moves_after_the_support_period) :-
    findall(Verdict, cra_manufacturer_duties_what_if(retention_end_date([attribute(security_update_issue_date, date(2031, 1, 1)), attribute(support_period_end_date, date(2031, 1, 1))], date(2031, 2, 1), security_update), security_update_issue_date, date(2031, 1, 2), Verdict), Verdicts),
    Verdicts == [not_applicable_outside_support_period].
test(what_if_the_judgement_becomes_unsure) :-
    cra_manufacturer_duties_what_if(requirements_applicability([attribute(placing_on_market_date, date(2025, 5, 5)), attribute(substantially_modified_on_or_after_application_date, false)], date(2028, 3, 1)), substantially_modified_on_or_after_application_date, unsure, Verdict),
    Verdict = needs_legal_review(_, _).
test(what_if_a_bad_value_is_an_input_problem) :-
    cra_manufacturer_duties_what_if(support_period_minimum([], date(2028, 3, 1)), expected_use_time_in_months, -1, Verdict),
    Verdict == input_problems([wrong_type(expected_use_time_in_months)]).

cp_test_names([profile_keys_are_the_contract_keys, the_root_atoms_are_served, the_result_constructors_build_as_data, the_input_check_is_re_exported, status_of_a_new_product, status_in_the_window, the_floor_is_reached_first_at_sixty_months, the_floor_is_an_integer, the_retention_date_is_computed, the_support_checklist_cites_each_ground, the_retention_checklist_cites_each_ground, what_if_the_use_time_crosses_the_floor, what_if_the_update_moves_after_the_support_period, what_if_the_judgement_becomes_unsure, what_if_a_bad_value_is_an_input_problem]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
