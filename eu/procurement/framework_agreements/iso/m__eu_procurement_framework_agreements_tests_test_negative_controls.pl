:- module(m__eu_procurement_framework_agreements_tests_test_negative_controls, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_procurement_framework_agreements_framework_agreements, [decide_call_off/2, call_off_route/2]).
:- use_module(m__eu_procurement_framework_agreements_fixtures, [framework_agreements_profile_for/2]).

test('R1 positive: single-operator direct award is lawful') :-
    framework_agreements_profile_for("single_op_lawful", Profile),
    decide_call_off(Profile, call_off_verdict(call_off_lawful, single_operator_direct_award, _, _)).
test('R1 near-miss: award outside term flips to unlawful') :-
    framework_agreements_profile_for("single_op_outside_term", Profile),
    decide_call_off(Profile, call_off_verdict(call_off_unlawful, single_operator_direct_award, _, _)).
test('R2 positive: multi-operator direct all-terms is lawful') :-
    framework_agreements_profile_for("multi_direct_all_lawful", Profile),
    decide_call_off(Profile, call_off_verdict(call_off_lawful, multi_operator_direct_award_all_terms_set_out, _, _)).
test('R2 near-miss: missing objective conditions flips to unlawful') :-
    framework_agreements_profile_for("multi_direct_all_no_conditions", Profile),
    decide_call_off(Profile, call_off_verdict(call_off_unlawful, multi_operator_direct_award_all_terms_set_out, _, _)).
test('R3 positive: multi-operator split direct is lawful') :-
    framework_agreements_profile_for("multi_direct_split_lawful", Profile),
    decide_call_off(Profile, call_off_verdict(call_off_lawful, multi_operator_direct_award_under_split_framework, _, _)).
test('R3 near-miss: terms subject to reopening not specified flips to unlawful') :-
    framework_agreements_profile_for("multi_direct_split_no_terms_spec", Profile),
    decide_call_off(Profile, call_off_verdict(call_off_unlawful, multi_operator_direct_award_under_split_framework, _, _)).
test('R4 positive: multi-operator reopened competition is lawful') :-
    framework_agreements_profile_for("multi_reopen_lawful", Profile),
    decide_call_off(Profile, call_off_verdict(call_off_lawful, multi_operator_reopened_competition, _, _)).
test('R4 near-miss: time limit not sufficiently long flips to unlawful') :-
    framework_agreements_profile_for("multi_reopen_short_time", Profile),
    decide_call_off(Profile, call_off_verdict(call_off_unlawful, multi_operator_reopened_competition, _, _)).
test('R5 positive: no_lawful_route is always unlawful') :-
    framework_agreements_profile_for("no_route_single_reopen", Profile),
    decide_call_off(Profile, call_off_verdict(call_off_unlawful, no_lawful_route, _, _)).
test('R5 near-miss: a multi-operator reopening with NOT all terms IS lawful (different route)') :-
    framework_agreements_profile_for("multi_reopen_lawful", Profile),
    decide_call_off(Profile, call_off_verdict(call_off_lawful, multi_operator_reopened_competition, _, _)).
test('R5 near-miss: multi-operator all-terms no-split reopening is unlawful') :-
    framework_agreements_profile_for("no_route_multi_all_nosplit", Profile),
    decide_call_off(Profile, call_off_verdict(call_off_unlawful, no_lawful_route, _, _)).

cp_test_names(['R1 positive: single-operator direct award is lawful', 'R1 near-miss: award outside term flips to unlawful', 'R2 positive: multi-operator direct all-terms is lawful', 'R2 near-miss: missing objective conditions flips to unlawful', 'R3 positive: multi-operator split direct is lawful', 'R3 near-miss: terms subject to reopening not specified flips to unlawful', 'R4 positive: multi-operator reopened competition is lawful', 'R4 near-miss: time limit not sufficiently long flips to unlawful', 'R5 positive: no_lawful_route is always unlawful', 'R5 near-miss: a multi-operator reopening with NOT all terms IS lawful (different route)', 'R5 near-miss: multi-operator all-terms no-split reopening is unlawful']).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
