% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_cra_manufacturer_duties_tests_test_load, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_cra_manufacturer_duties_kernel, [cra_manufacturer_duties_input_problems/2, real_calendar_day/1, date_earlier/2, date_not_earlier/2, date_later_of/3]).
:- use_module(m__eu_cra_manufacturer_duties_citations, [citation/2, implements/1]).

test(the_verdict_term_carries_verdict_and_citations) :-
    Verdict = cra_manufacturer_duties_verdict(subject_to_requirements, [cite(eu_reg_2024_2847_art_71_2)]),
    Verdict = cra_manufacturer_duties_verdict(Status, Citations),
    Status == subject_to_requirements,
    Citations == [cite(eu_reg_2024_2847_art_71_2)].
test(the_minimum_support_period_carries_a_bare_integer) :-
    Verdict = minimum_support_period(60),
    Verdict = minimum_support_period(Months),
    integer(Months),
    Months =:= 60.
test(the_keep_until_term_carries_a_bare_date) :-
    Verdict = keep_until(date(2038, 2, 1)),
    Verdict = keep_until(date(Year, Month, Day)),
    Year == 2038,
    Month == 2,
    Day == 1.
test(the_indeterminate_status_names_one_key) :-
    Verdict = indeterminate([placing_on_market_date]),
    Verdict = indeterminate(MissingKeys),
    MissingKeys == [placing_on_market_date].
test(the_legal_review_status_destructures) :-
    Verdict = needs_legal_review(open_textured(substantially_modified_on_or_after_application_date, cite(eu_reg_2024_2847_art_69_2)), [inputs_relied_on([substantially_modified_on_or_after_application_date - unsure])]),
    Verdict = needs_legal_review(open_textured(Key, cite(Citation)), [inputs_relied_on(Pairs)]),
    Key == substantially_modified_on_or_after_application_date,
    Citation == eu_reg_2024_2847_art_69_2,
    Pairs == [substantially_modified_on_or_after_application_date - unsure].
test(the_input_problems_status_destructures) :-
    Verdict = input_problems([duplicate_key(placing_on_market_date), wrong_type(assessment_date), unknown_key(colour)]),
    Verdict = input_problems(Problems),
    Problems == [duplicate_key(placing_on_market_date), wrong_type(assessment_date), unknown_key(colour)].
test(the_verdict_atoms_are_distinct) :-
    dif(subject_to_requirements, article_14_only),
    dif(subject_to_requirements, not_yet_applicable),
    dif(article_14_only, not_yet_applicable),
    dif(not_yet_applicable, not_applicable_outside_support_period),
    dif(article_14_only, not_applicable_outside_support_period).
test(the_item_atoms_are_distinct) :-
    dif(technical_documentation_and_declaration_of_conformity, information_and_instructions_to_the_user),
    dif(technical_documentation_and_declaration_of_conformity, security_update),
    dif(information_and_instructions_to_the_user, security_update).
test(the_dates_of_application_citation_is_recorded) :-
    citation(eu_reg_2024_2847_art_71_2, _Record).
test(the_support_period_floor_citation_is_recorded) :-
    citation(eu_reg_2024_2847_art_13_8, _Record).
test(every_result_citation_implements) :-
    implements(eu_reg_2024_2847_art_71_2),
    implements(eu_reg_2024_2847_art_69_2),
    implements(eu_reg_2024_2847_art_69_3),
    implements(eu_reg_2024_2847_art_13_8),
    implements(eu_reg_2024_2847_art_13_9),
    implements(eu_reg_2024_2847_art_13_13),
    implements(eu_reg_2024_2847_art_13_18).
test(the_application_date_is_a_real_day) :-
    real_calendar_day(date(2027, 12, 11)).
test(the_window_start_is_earlier_than_the_application_date) :-
    date_earlier(date(2026, 9, 11), date(2027, 12, 11)).
test(the_application_date_is_not_earlier_than_itself) :-
    date_not_earlier(date(2027, 12, 11), date(2027, 12, 11)).
test(the_later_of_two_dates_is_one_answer) :-
    findall(LaterDate, date_later_of(date(2038, 2, 28), date(2035, 6, 30), LaterDate), LaterDates),
    LaterDates == [date(2038, 2, 28)].
test(an_empty_profile_has_no_problem) :-
    findall(Problems, cra_manufacturer_duties_input_problems([], Problems), Answers),
    Answers == [[]].
test(an_unbound_profile_is_wrong_type) :-
    findall(Problems, cra_manufacturer_duties_input_problems(_Profile, Problems), Answers),
    Answers == [[wrong_type(profile)]].
test(a_judgement_outside_its_atoms_is_wrong_type) :-
    cra_manufacturer_duties_input_problems([attribute(substantially_modified_on_or_after_application_date, maybe)], Problems),
    Problems == [wrong_type(substantially_modified_on_or_after_application_date)].
test(an_unsure_judgement_is_well_formed) :-
    cra_manufacturer_duties_input_problems([attribute(substantially_modified_on_or_after_application_date, unsure)], Problems),
    Problems == [].

test(the_placeholder_citation_is_not_recorded, fail) :-
    citation(eu_todo_primary_source, _Record).
test(the_thirtieth_of_february_is_not_a_real_day, fail) :-
    real_calendar_day(date(2028, 2, 30)).

cp_test_names([the_verdict_term_carries_verdict_and_citations, the_minimum_support_period_carries_a_bare_integer, the_keep_until_term_carries_a_bare_date, the_indeterminate_status_names_one_key, the_legal_review_status_destructures, the_input_problems_status_destructures, the_verdict_atoms_are_distinct, the_item_atoms_are_distinct, the_dates_of_application_citation_is_recorded, the_support_period_floor_citation_is_recorded, every_result_citation_implements, the_application_date_is_a_real_day, the_window_start_is_earlier_than_the_application_date, the_application_date_is_not_earlier_than_itself, the_later_of_two_dates_is_one_answer, an_empty_profile_has_no_problem, an_unbound_profile_is_wrong_type, a_judgement_outside_its_atoms_is_wrong_type, an_unsure_judgement_is_well_formed]).
cp_test_fail_names([the_placeholder_citation_is_not_recorded, the_thirtieth_of_february_is_not_a_real_day]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
