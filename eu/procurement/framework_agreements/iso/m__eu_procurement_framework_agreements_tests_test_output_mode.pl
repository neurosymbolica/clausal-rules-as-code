:- module(m__eu_procurement_framework_agreements_tests_test_output_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_procurement_framework_agreements_framework_agreements, [call_off_route/2, framework_term_limit_date/2, framework_term_within_limit/3, call_off_award_window_status/4, decide_call_off/2]).
:- use_module(m__eu_procurement_framework_agreements_fixtures, [framework_agreements_profile_for/2]).

test('output mode: single-operator profile yields exactly one route') :-
    framework_agreements_profile_for("single_op_lawful", Profile),
    findall(Route, call_off_route(Profile, Route), Routes),
    Routes = [single_operator_direct_award].
test('output mode: multi-operator direct-all profile yields exactly one route') :-
    framework_agreements_profile_for("multi_direct_all_lawful", Profile),
    findall(Route, call_off_route(Profile, Route), Routes),
    Routes = [multi_operator_direct_award_all_terms_set_out].
test('output mode: multi-operator split profile yields exactly one route') :-
    framework_agreements_profile_for("multi_direct_split_lawful", Profile),
    findall(Route, call_off_route(Profile, Route), Routes),
    Routes = [multi_operator_direct_award_under_split_framework].
test('output mode: multi-operator reopened profile yields exactly one route') :-
    framework_agreements_profile_for("multi_reopen_lawful", Profile),
    findall(Route, call_off_route(Profile, Route), Routes),
    Routes = [multi_operator_reopened_competition].
test('output mode: no-route profile yields exactly one route') :-
    framework_agreements_profile_for("no_route_single_reopen", Profile),
    findall(Route, call_off_route(Profile, Route), Routes),
    Routes = [no_lawful_route].
test('output mode: framework_term_limit_date yields a triple') :-
    framework_term_limit_date(date(2024, 1, 1), date(2028, 1, 1)).
test('output mode: framework_term_limit_date 29-Feb clamp') :-
    framework_term_limit_date(date(2024, 2, 29), date(2028, 2, 29)).
test('output mode: within_limit for exactly 4 years') :-
    findall(Status, framework_term_within_limit(date(2024, 1, 1), date(2028, 1, 1), Status), Statuses),
    Statuses = [within_four_year_limit].
test('output mode: exceeds for 4 years plus 1 day') :-
    findall(Status, framework_term_within_limit(date(2024, 1, 1), date(2028, 1, 2), Status), Statuses),
    Statuses = [exceeds_four_year_limit].
test('output mode: award window status is unique') :-
    findall(Status, call_off_award_window_status(date(2024, 1, 1), date(2027, 1, 1), date(2025, 6, 15), Status), Statuses),
    Statuses = [award_date_within_framework_term].
test('output mode: decide_call_off yields exactly one verdict for lawful profile') :-
    framework_agreements_profile_for("single_op_lawful", Profile),
    findall(Verdict, decide_call_off(Profile, Verdict), Verdicts),
    length(Verdicts, 1).
test('output mode: decide_call_off yields exactly one verdict for unlawful profile') :-
    framework_agreements_profile_for("single_op_outside_term", Profile),
    findall(Verdict, decide_call_off(Profile, Verdict), Verdicts),
    length(Verdicts, 1).

cp_test_names(['output mode: single-operator profile yields exactly one route', 'output mode: multi-operator direct-all profile yields exactly one route', 'output mode: multi-operator split profile yields exactly one route', 'output mode: multi-operator reopened profile yields exactly one route', 'output mode: no-route profile yields exactly one route', 'output mode: framework_term_limit_date yields a triple', 'output mode: framework_term_limit_date 29-Feb clamp', 'output mode: within_limit for exactly 4 years', 'output mode: exceeds for 4 years plus 1 day', 'output mode: award window status is unique', 'output mode: decide_call_off yields exactly one verdict for lawful profile', 'output mode: decide_call_off yields exactly one verdict for unlawful profile']).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
