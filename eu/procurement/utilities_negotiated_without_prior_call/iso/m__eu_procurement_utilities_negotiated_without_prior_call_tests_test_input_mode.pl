:- module(m__eu_procurement_utilities_negotiated_without_prior_call_tests_test_input_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_procurement_utilities_negotiated_without_prior_call_utilities_negotiated_without_prior_call, [utilities_negotiated_without_prior_call_status/2]).
:- use_module(m__eu_procurement_utilities_negotiated_without_prior_call_fixtures, [utilities_negotiated_without_prior_call_profile_for/2]).
:- use_module(formalize_lib, [not_member/2]).

utilities_negotiated_without_prior_call_status_never(Profile, Status) :-
    findall(Found, utilities_negotiated_without_prior_call_status(Profile, Found), FoundStatuses),
    not_member(Status, FoundStatuses).

test('input mode: a_lawful profile yields use_lawful when bound') :-
    utilities_negotiated_without_prior_call_profile_for("a_lawful", Profile),
    utilities_negotiated_without_prior_call_status(Profile, use_lawful).
test('input mode: a_lawful profile rejects use_unlawful') :-
    utilities_negotiated_without_prior_call_profile_for("a_lawful", Profile),
    utilities_negotiated_without_prior_call_status_never(Profile, use_unlawful).
test('input mode: a_near_miss profile yields use_unlawful when bound') :-
    utilities_negotiated_without_prior_call_profile_for("a_near_miss", Profile),
    utilities_negotiated_without_prior_call_status(Profile, use_unlawful).
test('input mode: a_near_miss profile rejects use_lawful') :-
    utilities_negotiated_without_prior_call_profile_for("a_near_miss", Profile),
    utilities_negotiated_without_prior_call_status_never(Profile, use_lawful).
test('input mode: e_lawful (supplies) yields use_lawful') :-
    utilities_negotiated_without_prior_call_profile_for("e_lawful", Profile),
    utilities_negotiated_without_prior_call_status(Profile, use_lawful).
test('input mode: e_near_miss (works type-gate) yields use_unlawful') :-
    utilities_negotiated_without_prior_call_profile_for("e_near_miss", Profile),
    utilities_negotiated_without_prior_call_status(Profile, use_unlawful).
test('input mode: j_lawful (services) yields use_lawful') :-
    utilities_negotiated_without_prior_call_profile_for("j_lawful", Profile),
    utilities_negotiated_without_prior_call_status(Profile, use_lawful).
test('input mode: j_near_miss (supplies type-gate) yields use_unlawful') :-
    utilities_negotiated_without_prior_call_profile_for("j_near_miss", Profile),
    utilities_negotiated_without_prior_call_status(Profile, use_unlawful).

cp_test_names(['input mode: a_lawful profile yields use_lawful when bound', 'input mode: a_lawful profile rejects use_unlawful', 'input mode: a_near_miss profile yields use_unlawful when bound', 'input mode: a_near_miss profile rejects use_lawful', 'input mode: e_lawful (supplies) yields use_lawful', 'input mode: e_near_miss (works type-gate) yields use_unlawful', 'input mode: j_lawful (services) yields use_lawful', 'input mode: j_near_miss (supplies type-gate) yields use_unlawful']).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
