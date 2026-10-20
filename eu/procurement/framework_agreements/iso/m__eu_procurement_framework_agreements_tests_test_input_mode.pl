:- module(m__eu_procurement_framework_agreements_tests_test_input_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_procurement_framework_agreements_framework_agreements, [framework_agreements_status/2, call_off_route/2, framework_term_within_limit/3, call_off_award_window_status/4]).
:- use_module(m__eu_procurement_framework_agreements_fixtures, [framework_agreements_profile_for/2]).
:- use_module(formalize_lib, [not_member/2]).

framework_agreements_status_never(Profile, Route) :-
    findall(Found, framework_agreements_status(Profile, Found), FoundRoutes),
    not_member(Route, FoundRoutes).

framework_term_within_limit_never(StartDate, EndDate, Status) :-
    findall(Found, framework_term_within_limit(StartDate, EndDate, Found), FoundStatuses),
    not_member(Status, FoundStatuses).

call_off_award_window_status_never(StartDate, EndDate, AwardDate, Status) :-
    findall(Found, call_off_award_window_status(StartDate, EndDate, AwardDate, Found), FoundStatuses),
    not_member(Status, FoundStatuses).

test('input mode: single-operator route holds with the verdict bound') :-
    framework_agreements_profile_for("single_op_lawful", Profile),
    framework_agreements_status(Profile, single_operator_direct_award).
test('input mode: wrong bound route is rejected') :-
    framework_agreements_profile_for("single_op_lawful", Profile),
    framework_agreements_status_never(Profile, multi_operator_reopened_competition).
test('input mode: multi-operator direct route holds with the verdict bound') :-
    framework_agreements_profile_for("multi_direct_all_lawful", Profile),
    framework_agreements_status(Profile, multi_operator_direct_award_all_terms_set_out).
test('input mode: no_lawful_route holds for single-operator reopening') :-
    framework_agreements_profile_for("no_route_single_reopen", Profile),
    framework_agreements_status(Profile, no_lawful_route).
test('input mode: within_four_year_limit holds for a 3-year term') :-
    framework_term_within_limit(date(2024, 1, 1), date(2027, 1, 1), within_four_year_limit).
test('input mode: exceeds_four_year_limit is rejected for a 3-year term') :-
    framework_term_within_limit_never(date(2024, 1, 1), date(2027, 1, 1), exceeds_four_year_limit).
test('input mode: award date within term holds') :-
    call_off_award_window_status(date(2024, 1, 1), date(2027, 1, 1), date(2025, 6, 15), award_date_within_framework_term).
test('input mode: award date outside term is rejected for an in-term date') :-
    call_off_award_window_status_never(date(2024, 1, 1), date(2027, 1, 1), date(2025, 6, 15), award_date_outside_framework_term).

cp_test_names(['input mode: single-operator route holds with the verdict bound', 'input mode: wrong bound route is rejected', 'input mode: multi-operator direct route holds with the verdict bound', 'input mode: no_lawful_route holds for single-operator reopening', 'input mode: within_four_year_limit holds for a 3-year term', 'input mode: exceeds_four_year_limit is rejected for a 3-year term', 'input mode: award date within term holds', 'input mode: award date outside term is rejected for an in-term date']).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
