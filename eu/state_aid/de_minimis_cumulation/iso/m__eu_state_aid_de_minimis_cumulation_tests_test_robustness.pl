:- module(m__eu_state_aid_de_minimis_cumulation_tests_test_robustness, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(library(clpz)).
:- use_module(m__eu_state_aid_de_minimis_cumulation_cumulation, [de_minimis_ceiling/1, de_minimis_aid_in_window/3, de_minimis_verdict/3]).
:- use_module(m__eu_state_aid_de_minimis_cumulation_queries, [de_minimis_qualifying_grants/3, de_minimis_compare_refs/4, de_minimis_headroom/3, de_minimis_gap_to_ineligible/3, de_minimis_what_if/4]).
:- use_module(m__eu_state_aid_de_minimis_cumulation_cumulation, [de_minimis_input_problem/3]).

valid_grants([[date(2023, 1, 1), 5000000], [date(2022, 1, 1), 10000000]]).

valid_reference_date(date(2024, 1, 1)).

all_verdicts(Grants, ReferenceDate, Verdicts) :-
    findall(V, de_minimis_verdict(Grants, ReferenceDate, V), Verdicts).

all_totals(Grants, ReferenceDate, Totals) :-
    findall(T, de_minimis_aid_in_window(Grants, ReferenceDate, T), Totals).

verdict_is_indeterminate(Grants, ReferenceDate) :-
    all_verdicts(Grants, ReferenceDate, Verdicts),
    Verdicts = [indeterminate].

no_total(Grants, ReferenceDate) :-
    all_totals(Grants, ReferenceDate, Totals),
    Totals = [].

exactly_one_answer(Grants, ReferenceDate) :-
    all_verdicts(Grants, ReferenceDate, Verdicts),
    length(Verdicts, 1),
    all_totals(Grants, ReferenceDate, Totals),
    length(Totals, 1).

total_is(Grants, ReferenceDate, Expected) :-
    all_totals(Grants, ReferenceDate, Totals),
    Totals = [Expected].

test('control: valid base case is eligible with total 15000000') :-
    valid_grants(Grants),
    valid_reference_date(ReferenceDate),
    all_verdicts(Grants, ReferenceDate, Verdicts),
    Verdicts = [eligible],
    total_is(Grants, ReferenceDate, 15000000).
test('unbound reference date gives indeterminate, not an instantiation error from days_between') :-
    valid_grants(Grants),
    verdict_is_indeterminate(Grants, _).
test('unbound reference date gives no window total, not an instantiation error from days_between') :-
    valid_grants(Grants),
    no_total(Grants, _).
test('unbound grant date gives indeterminate, not an instantiation error from days_between') :-
    verdict_is_indeterminate([[_, 5000000]], date(2024, 1, 1)).
test('unbound grant amount gives indeterminate, not a Python TypeError') :-
    verdict_is_indeterminate([[date(2023, 1, 1), _]], date(2024, 1, 1)).
test('unbound grant amount gives no window total, not an unbound total') :-
    no_total([[date(2023, 1, 1), _]], date(2024, 1, 1)).
test('empty grants list is the default zero history: total 0, eligible') :-
    total_is([], date(2024, 1, 1), 0),
    all_verdicts([], date(2024, 1, 1), Verdicts),
    Verdicts = [eligible].
test('reference date as an atom gives indeterminate') :-
    valid_grants(Grants),
    verdict_is_indeterminate(Grants, 'not_a_date'),
    no_total(Grants, 'not_a_date').
test('reference date as an ISO string gives indeterminate') :-
    valid_grants(Grants),
    verdict_is_indeterminate(Grants, "2024-01-01"),
    no_total(Grants, "2024-01-01").
test('reference date as a number gives indeterminate') :-
    valid_grants(Grants),
    verdict_is_indeterminate(Grants, 20240101),
    no_total(Grants, 20240101).
test('reference date as a [Y, M, D] list gives indeterminate') :-
    valid_grants(Grants),
    verdict_is_indeterminate(Grants, [2024, 1, 1]),
    no_total(Grants, [2024, 1, 1]).
test('grant date as a [Y, M, D] list gives indeterminate') :-
    verdict_is_indeterminate([[[2023, 1, 1], 5000000]], date(2024, 1, 1)),
    no_total([[[2023, 1, 1], 5000000]], date(2024, 1, 1)).
test('grant date as an atom gives indeterminate') :-
    verdict_is_indeterminate([['not_a_date', 5000000]], date(2024, 1, 1)),
    no_total([['not_a_date', 5000000]], date(2024, 1, 1)).
test('grant date as an ISO string gives indeterminate') :-
    verdict_is_indeterminate([["2023-01-01", 5000000]], date(2024, 1, 1)),
    no_total([["2023-01-01", 5000000]], date(2024, 1, 1)).
test('one unreadable grant date among valid grants still gives indeterminate') :-
    verdict_is_indeterminate([[date(2023, 1, 1), 5000000], ['not_a_date', 5000000]], date(2024, 1, 1)).
test('grant amount as an atom gives indeterminate, not a clpz domain error inside the sum') :-
    verdict_is_indeterminate([[date(2023, 1, 1), 'large']], date(2024, 1, 1)).
test('grant amount as a string gives indeterminate, not a clpz domain error inside the sum') :-
    verdict_is_indeterminate([[date(2023, 1, 1), "5000000"]], date(2024, 1, 1)).
test('grant amount as a boolean gives indeterminate, not a clpz domain error inside the sum') :-
    verdict_is_indeterminate([[date(2023, 1, 1), true]], date(2024, 1, 1)).
test('grant amount as a list gives indeterminate, not a clpz domain error inside the sum') :-
    verdict_is_indeterminate([[date(2023, 1, 1), [5000000]]], date(2024, 1, 1)).
test('grant amount as a float is not integer cents and gives indeterminate, not a definite verdict') :-
    verdict_is_indeterminate([[date(2023, 1, 1), 5000000.5]], date(2024, 1, 1)).
test('grant amount as a float gives no window total') :-
    no_total([[date(2023, 1, 1), 5000000.5]], date(2024, 1, 1)).
test('negative grant amount gives indeterminate, not a definite verdict that offsets other aid') :-
    verdict_is_indeterminate([[date(2023, 1, 1), 31000000], [date(2023, 6, 1), -2000000]], date(2024, 1, 1)).
test('grants given as an atom gives indeterminate, not eligible with total 0') :-
    verdict_is_indeterminate('no_grants', date(2024, 1, 1)),
    no_total('no_grants', date(2024, 1, 1)).
test('grants given as a number gives indeterminate, not eligible with total 0') :-
    verdict_is_indeterminate(31000000, date(2024, 1, 1)),
    no_total(31000000, date(2024, 1, 1)).
test('a grant with three elements gives indeterminate, not silently dropped from the total') :-
    verdict_is_indeterminate([[date(2023, 1, 1), 31000000, 'extra']], date(2024, 1, 1)).
test('a grant written as grant(DATE, AMOUNT) gives indeterminate, not silently dropped from the total') :-
    verdict_is_indeterminate([grant(date(2023, 1, 1), 31000000)], date(2024, 1, 1)).
test('a bare amount in place of a grant pair gives indeterminate, not silently dropped from the total') :-
    verdict_is_indeterminate([31000000], date(2024, 1, 1)).
test('empty grants list with unbound reference date gives indeterminate') :-
    verdict_is_indeterminate([], _).
test('window: grant exactly three calendar years before the reference date is excluded') :-
    total_is([[date(2022, 6, 1), 100]], date(2025, 6, 1), 0).
test('window: grant one day after the three-year start is included') :-
    total_is([[date(2022, 6, 2), 100]], date(2025, 6, 1), 100).
test('window: grant one day before the three-year start is excluded') :-
    total_is([[date(2022, 5, 31), 100]], date(2025, 6, 1), 0).
test('window: grant on the reference date is included') :-
    total_is([[date(2025, 6, 1), 100]], date(2025, 6, 1), 100).
test('window: grant one day after the reference date is excluded') :-
    total_is([[date(2025, 6, 2), 100]], date(2025, 6, 1), 0).
test('window: grant 1095 days before the reference date, on the calendar start, is excluded') :-
    total_is([[date(2020, 6, 1), 100]], date(2023, 6, 1), 0).
test('window: grant 1094 days before the reference date, one day inside the calendar start, is included') :-
    total_is([[date(2020, 6, 2), 100]], date(2023, 6, 1), 100).
test('window: reference date 29 February excludes a grant on 28 February three years earlier') :-
    total_is([[date(2021, 2, 28), 100]], date(2024, 2, 29), 0).
test('window: reference date 29 February includes a grant on 1 March three years earlier') :-
    total_is([[date(2021, 3, 1), 100]], date(2024, 2, 29), 100).
test('window: reference date 29 February excludes a grant on 27 February three years earlier') :-
    total_is([[date(2021, 2, 27), 100]], date(2024, 2, 29), 0).
test('window: grant on 29 February is included from reference date 28 February three years later') :-
    total_is([[date(2024, 2, 29), 100]], date(2027, 2, 28), 100).
test('window: grant on 29 February is excluded from reference date 1 March three years later') :-
    total_is([[date(2024, 2, 29), 100]], date(2027, 3, 1), 0).
test('window: reference date 1 March excludes a grant on 1 March three years earlier') :-
    total_is([[date(2022, 3, 1), 100]], date(2025, 3, 1), 0).
test('window: reference date 1 March includes a grant on 2 March three years earlier') :-
    total_is([[date(2022, 3, 2), 100]], date(2025, 3, 1), 100).
test('window: rolling the reference date one day past the start drops the grant out') :-
    total_is([[date(2022, 6, 2), 100]], date(2025, 6, 1), 100),
    total_is([[date(2022, 6, 2), 100]], date(2025, 6, 2), 0).
test('ceiling: one cent below the ceiling is eligible') :-
    all_verdicts([[date(2023, 1, 1), 29999999]], date(2024, 1, 1), Verdicts),
    Verdicts = [eligible].
test('ceiling: exactly at the ceiling is eligible') :-
    all_verdicts([[date(2023, 1, 1), 30000000]], date(2024, 1, 1), Verdicts),
    Verdicts = [eligible].
test('ceiling: one cent above the ceiling is ineligible') :-
    all_verdicts([[date(2023, 1, 1), 30000001]], date(2024, 1, 1), Verdicts),
    Verdicts = [ineligible].
test('ceiling: two grants summing to one cent above the ceiling are ineligible') :-
    all_verdicts([[date(2023, 1, 1), 15000000], [date(2022, 1, 2), 15000001]], date(2024, 1, 1), Verdicts),
    Verdicts = [ineligible].
test('ceiling: aid that would breach it but sits outside the window is ignored') :-
    all_verdicts([[date(2023, 1, 1), 30000000], [date(2021, 1, 1), 1]], date(2024, 1, 1), Verdicts),
    Verdicts = [eligible].
test('one answer: public-interface three-grant fixture') :-
    exactly_one_answer([[date(2023, 1, 1), 5000000], [date(2022, 1, 1), 10000000], [date(2020, 1, 1), 20000000]], date(2024, 1, 1)).
test('one answer: public-interface over-ceiling fixture') :-
    exactly_one_answer([[date(2023, 1, 1), 20000000], [date(2022, 6, 1), 15000000]], date(2024, 1, 1)).
test('one answer: public-interface at-ceiling fixture') :-
    exactly_one_answer([[date(2023, 1, 1), 30000000]], date(2024, 1, 1)).
test('one answer: empty grants list') :-
    exactly_one_answer([], date(2024, 1, 1)).
test('one answer: queries mixed in-and-out-of-window fixture') :-
    exactly_one_answer([[date(2024, 1, 1), 15000000], [date(2022, 6, 2), 5000000], [date(2022, 6, 1), 4000000], [date(2020, 1, 1), 20000000]], date(2025, 6, 1)).
test('one answer: queries small-headroom fixture') :-
    exactly_one_answer([[date(2024, 1, 1), 29999950]], date(2025, 6, 1)).
test('one answer: reference date 29 February') :-
    exactly_one_answer([[date(2021, 3, 1), 100]], date(2024, 2, 29)).
test('one answer: an unreadable reference date gives exactly one indeterminate') :-
    valid_grants(Grants),
    all_verdicts(Grants, 'not_a_date', Verdicts),
    length(Verdicts, 1).
test('headroom: unreadable reference date gives no headroom') :-
    valid_grants(Grants),
    findall(H, de_minimis_headroom(Grants, 'not_a_date', H), L),
    L = [].
test('headroom: grants given as an atom gives no headroom, not the full ceiling') :-
    findall(H, de_minimis_headroom('no_grants', date(2024, 1, 1), H), L),
    L = [].
test('headroom: a grant with three elements gives no headroom, not the full ceiling') :-
    findall(H, de_minimis_headroom([[date(2023, 1, 1), 31000000, 'extra']], date(2024, 1, 1), H), L),
    L = [].
test('gap: unreadable reference date gives no gap') :-
    valid_grants(Grants),
    findall(G, de_minimis_gap_to_ineligible(Grants, 'not_a_date', G), L),
    L = [].
test('qualifying: unreadable grant date gives no qualifying list') :-
    findall(Q, de_minimis_qualifying_grants([['not_a_date', 100]], date(2024, 1, 1), Q), L),
    L = [].
test('qualifying: a grant with three elements gives no qualifying list, not an empty one') :-
    findall(Q, de_minimis_qualifying_grants([[date(2023, 1, 1), 100, 'extra']], date(2024, 1, 1), Q), L),
    L = [].
test('compare: one unreadable reference date gives no comparison') :-
    valid_grants(Grants),
    findall(R, de_minimis_compare_refs(Grants, date(2024, 1, 1), 'not_a_date', R), L),
    L = [].
test('what-if: unreadable reference date gives indeterminate') :-
    valid_grants(Grants),
    findall(V, de_minimis_what_if(Grants, 'not_a_date', 100, V), L),
    L = [indeterminate].
test('what-if: new amount as an atom gives indeterminate, not a clpz domain error inside the sum') :-
    valid_grants(Grants),
    findall(V, de_minimis_what_if(Grants, date(2024, 1, 1), 'large', V), L),
    L = [indeterminate].
test('what-if: new amount as a float gives indeterminate, not a definite verdict') :-
    valid_grants(Grants),
    findall(V, de_minimis_what_if(Grants, date(2024, 1, 1), 100.5, V), L),
    L = [indeterminate].
test('what-if: unbound new amount gives indeterminate, not a Python TypeError') :-
    valid_grants(Grants),
    findall(V, de_minimis_what_if(Grants, date(2024, 1, 1), _, V), L),
    L = [indeterminate].
test('unbound grants list gives indeterminate') :-
    verdict_is_indeterminate(_, date(2024, 1, 1)),
    no_total(_, date(2024, 1, 1)).
test('both inputs unbound give indeterminate') :-
    verdict_is_indeterminate(_, _),
    no_total(_, _).
test('partial grants list gives indeterminate') :-
    verdict_is_indeterminate([[date(2023, 1, 1), 100]|_], date(2024, 1, 1)),
    no_total([[date(2023, 1, 1), 100]|_], date(2024, 1, 1)).
test('what-if: unbound grants list gives indeterminate') :-
    findall(V, de_minimis_what_if(_, date(2024, 1, 1), 100, V), L),
    L = [indeterminate].
test('problem: a well-formed input has no problem') :-
    valid_grants(Grants),
    valid_reference_date(ReferenceDate),
    findall(P, de_minimis_input_problem(Grants, ReferenceDate, P), []),
    findall(P, de_minimis_input_problem([], ReferenceDate, P), []).
test('problem: unbound grants list is reported as not_ground(grants)') :-
    problem_is(_, date(2024, 1, 1), not_ground(grants)).
test('problem: a grant with an unbound amount is reported as not_ground(grants)') :-
    problem_is([[date(2023, 1, 1), _]], date(2024, 1, 1), not_ground(grants)).
test('problem: unbound reference date is reported as not_ground(reference_date)') :-
    valid_grants(Grants),
    problem_is(Grants, _, not_ground(reference_date)).
test('problem: reference date as a list is reported as wrong_type(reference_date, expected_date)') :-
    valid_grants(Grants),
    problem_is(Grants, [2024, 1, 1], wrong_type(reference_date, expected_date)).
test('problem: grants as an atom is reported as not_a_list(grants)') :-
    problem_is('no_grants', date(2024, 1, 1), not_a_list(grants)).
test('problem: a three-element grant is reported as malformed_grant') :-
    problem_is([[date(2023, 1, 1), 100, 'extra']], date(2024, 1, 1), malformed_grant([date(2023, 1, 1), 100, 'extra'])).
test('problem: a bare amount in place of a grant is reported as malformed_grant') :-
    problem_is([31000000], date(2024, 1, 1), malformed_grant(31000000)).
test('problem: grant date as an atom is reported as wrong_type(grant_date, expected_date)') :-
    problem_is([['not_a_date', 100]], date(2024, 1, 1), wrong_type(grant_date, expected_date)).
test('problem: grant amount as a float is reported as wrong_type(grant_amount, expected_integer)') :-
    problem_is([[date(2023, 1, 1), 100.5]], date(2024, 1, 1), wrong_type(grant_amount, expected_integer)).
test('problem: grant amount as a boolean is reported as wrong_type(grant_amount, expected_integer)') :-
    problem_is([[date(2023, 1, 1), true]], date(2024, 1, 1), wrong_type(grant_amount, expected_integer)).
test('problem: a negative amount is reported as negative_amount(grant_amount)') :-
    problem_is([[date(2023, 1, 1), -100]], date(2024, 1, 1), negative_amount(grant_amount)).
test('problem: a zero amount is not a problem') :-
    findall(P, de_minimis_input_problem([[date(2023, 1, 1), 0]], date(2024, 1, 1), P), []).
test('problem: only the first of several problems is reported') :-
    problem_is([[date(2023, 1, 1), -100], ['not_a_date', 100]], date(2024, 1, 1), negative_amount(grant_amount)).

problem_is(Grants, ReferenceDate, Expected) :-
    findall(P, de_minimis_input_problem(Grants, ReferenceDate, P), Problems),
    Problems = [Expected].

cp_test_names(['control: valid base case is eligible with total 15000000', 'unbound reference date gives indeterminate, not an instantiation error from days_between', 'unbound reference date gives no window total, not an instantiation error from days_between', 'unbound grant date gives indeterminate, not an instantiation error from days_between', 'unbound grant amount gives indeterminate, not a Python TypeError', 'unbound grant amount gives no window total, not an unbound total', 'empty grants list is the default zero history: total 0, eligible', 'reference date as an atom gives indeterminate', 'reference date as an ISO string gives indeterminate', 'reference date as a number gives indeterminate', 'reference date as a [Y, M, D] list gives indeterminate', 'grant date as a [Y, M, D] list gives indeterminate', 'grant date as an atom gives indeterminate', 'grant date as an ISO string gives indeterminate', 'one unreadable grant date among valid grants still gives indeterminate', 'grant amount as an atom gives indeterminate, not a clpz domain error inside the sum', 'grant amount as a string gives indeterminate, not a clpz domain error inside the sum', 'grant amount as a boolean gives indeterminate, not a clpz domain error inside the sum', 'grant amount as a list gives indeterminate, not a clpz domain error inside the sum', 'grant amount as a float is not integer cents and gives indeterminate, not a definite verdict', 'grant amount as a float gives no window total', 'negative grant amount gives indeterminate, not a definite verdict that offsets other aid', 'grants given as an atom gives indeterminate, not eligible with total 0', 'grants given as a number gives indeterminate, not eligible with total 0', 'a grant with three elements gives indeterminate, not silently dropped from the total', 'a grant written as grant(DATE, AMOUNT) gives indeterminate, not silently dropped from the total', 'a bare amount in place of a grant pair gives indeterminate, not silently dropped from the total', 'empty grants list with unbound reference date gives indeterminate', 'window: grant exactly three calendar years before the reference date is excluded', 'window: grant one day after the three-year start is included', 'window: grant one day before the three-year start is excluded', 'window: grant on the reference date is included', 'window: grant one day after the reference date is excluded', 'window: grant 1095 days before the reference date, on the calendar start, is excluded', 'window: grant 1094 days before the reference date, one day inside the calendar start, is included', 'window: reference date 29 February excludes a grant on 28 February three years earlier', 'window: reference date 29 February includes a grant on 1 March three years earlier', 'window: reference date 29 February excludes a grant on 27 February three years earlier', 'window: grant on 29 February is included from reference date 28 February three years later', 'window: grant on 29 February is excluded from reference date 1 March three years later', 'window: reference date 1 March excludes a grant on 1 March three years earlier', 'window: reference date 1 March includes a grant on 2 March three years earlier', 'window: rolling the reference date one day past the start drops the grant out', 'ceiling: one cent below the ceiling is eligible', 'ceiling: exactly at the ceiling is eligible', 'ceiling: one cent above the ceiling is ineligible', 'ceiling: two grants summing to one cent above the ceiling are ineligible', 'ceiling: aid that would breach it but sits outside the window is ignored', 'one answer: public-interface three-grant fixture', 'one answer: public-interface over-ceiling fixture', 'one answer: public-interface at-ceiling fixture', 'one answer: empty grants list', 'one answer: queries mixed in-and-out-of-window fixture', 'one answer: queries small-headroom fixture', 'one answer: reference date 29 February', 'one answer: an unreadable reference date gives exactly one indeterminate', 'headroom: unreadable reference date gives no headroom', 'headroom: grants given as an atom gives no headroom, not the full ceiling', 'headroom: a grant with three elements gives no headroom, not the full ceiling', 'gap: unreadable reference date gives no gap', 'qualifying: unreadable grant date gives no qualifying list', 'qualifying: a grant with three elements gives no qualifying list, not an empty one', 'compare: one unreadable reference date gives no comparison', 'what-if: unreadable reference date gives indeterminate', 'what-if: new amount as an atom gives indeterminate, not a clpz domain error inside the sum', 'what-if: new amount as a float gives indeterminate, not a definite verdict', 'what-if: unbound new amount gives indeterminate, not a Python TypeError', 'unbound grants list gives indeterminate', 'both inputs unbound give indeterminate', 'partial grants list gives indeterminate', 'what-if: unbound grants list gives indeterminate', 'problem: a well-formed input has no problem', 'problem: unbound grants list is reported as not_ground(grants)', 'problem: a grant with an unbound amount is reported as not_ground(grants)', 'problem: unbound reference date is reported as not_ground(reference_date)', 'problem: reference date as a list is reported as wrong_type(reference_date, expected_date)', 'problem: grants as an atom is reported as not_a_list(grants)', 'problem: a three-element grant is reported as malformed_grant', 'problem: a bare amount in place of a grant is reported as malformed_grant', 'problem: grant date as an atom is reported as wrong_type(grant_date, expected_date)', 'problem: grant amount as a float is reported as wrong_type(grant_amount, expected_integer)', 'problem: grant amount as a boolean is reported as wrong_type(grant_amount, expected_integer)', 'problem: a negative amount is reported as negative_amount(grant_amount)', 'problem: a zero amount is not a problem', 'problem: only the first of several problems is reported']).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
