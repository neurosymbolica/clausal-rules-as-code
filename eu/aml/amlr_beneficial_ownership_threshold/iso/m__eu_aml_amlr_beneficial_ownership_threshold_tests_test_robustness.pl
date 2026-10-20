:- module(m__eu_aml_amlr_beneficial_ownership_threshold_tests_test_robustness, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_dicts, [dict_pairs/2]).
:- use_module(m__eu_aml_amlr_beneficial_ownership_threshold_beneficial_ownership, [amlr_bo_decision/2, amlr_bo_status/2, assess_amlr_bo/3, amlr_bo_effective_holding/2]).
:- use_module(m__eu_aml_amlr_beneficial_ownership_threshold_fixtures, [amlr_bo_subject/1, amlr_bo_profile_for/2, amlr_bo_assess/2]).
:- use_module(m__eu_aml_amlr_beneficial_ownership_threshold_beneficial_ownership, [amlr_bo_input_problem/2]).
:- use_module(m__eu_aml_amlr_beneficial_ownership_threshold_beneficial_ownership, [amlr_bo_checklist/2]).
:- use_module(m__eu_aml_amlr_beneficial_ownership_threshold_queries, [amlr_bo_what_if/3, amlr_bo_gap_to_threshold/2]).

no_definite_decision(Profile) :-
    findall(D, amlr_bo_decision(Profile, D), Decisions),
    maplist(dif(eligible), Decisions),
    maplist(dif(ineligible), Decisions).

no_definite_status(Chains) :-
    findall(S, amlr_bo_status(Chains, S), Statuses),
    maplist(dif(eligible), Statuses),
    maplist(dif(ineligible), Statuses).

exactly_one_decision(Profile) :-
    findall(D, amlr_bo_decision(Profile, D), Decisions),
    length(Decisions, 1).

test('control: direct 30 percent is eligible') :-
    dict_pairs(Profile, [ownership_chains - [[3000]]]),
    amlr_bo_decision(Profile, eligible).
test('control: 50 x 49.99 chain is ineligible') :-
    dict_pairs(Profile, [ownership_chains - [[5000, 4999]]]),
    amlr_bo_decision(Profile, ineligible).
test('missing ownership_chains: indeterminate, exactly once') :-
    dict_pairs(Profile, []),
    amlr_bo_decision(Profile, indeterminate),
    dict_pairs(Profile2, []),
    exactly_one_decision(Profile2).
test('ownership_chains misspelled as another key: indeterminate') :-
    dict_pairs(Profile, ['ownership' - [[3000]]]),
    amlr_bo_decision(Profile, indeterminate).
test('KNOWN DEFECT: an empty ownership chain [[]] is counted as 100 percent and yields a definite decision') :-
    dict_pairs(Profile, [ownership_chains - [[]]]),
    no_definite_decision(Profile).
test('KNOWN DEFECT: an empty chain beside a 10 percent chain lifts the person over the threshold') :-
    dict_pairs(Profile, [ownership_chains - [[1000], []]]),
    no_definite_decision(Profile).
test('KNOWN DEFECT: amlr_bo_status counts an empty chain [[]] as 100 percent') :-
    no_definite_status([[]]).
test('KNOWN DEFECT: assess_amlr_bo reports a definite decision for an empty chain [[]]') :-
    dict_pairs(Profile, [ownership_chains - [[]]]),
    assess_amlr_bo("subject", Profile, Result),
    Result = assessment(_, Decision, _),
    Decision = indeterminate.
test('FAILS OPEN: ownership_chains given as a number yields ineligible') :-
    dict_pairs(Profile, [ownership_chains - 3000]),
    no_definite_decision(Profile).
test('FAILS OPEN: ownership_chains given as an atom yields ineligible') :-
    dict_pairs(Profile, [ownership_chains - 'thirty']),
    no_definite_decision(Profile).
test('FAILS OPEN: ownership_chains given as a string yields ineligible') :-
    dict_pairs(Profile, [ownership_chains - "3000"]),
    no_definite_decision(Profile).
test('FAILS OPEN: ownership_chains given as the boolean atom true yields ineligible') :-
    dict_pairs(Profile, [ownership_chains - 'true']),
    no_definite_decision(Profile).
test('FAILS OPEN: ownership_chains given as a flat list of numbers yields ineligible') :-
    dict_pairs(Profile, [ownership_chains - [3000]]),
    no_definite_decision(Profile).
test('FAILS OPEN: amlr_bo_status on chains given as an atom yields ineligible') :-
    no_definite_status('thirty').
test('CRASH: a chain level given as a string raises a CLP domain error') :-
    dict_pairs(Profile, [ownership_chains - [["3000"]]]),
    no_definite_decision(Profile).
test('CRASH: a string on the second level of a chain raises a CLP domain error') :-
    dict_pairs(Profile, [ownership_chains - [[5000, "5000"]]]),
    no_definite_decision(Profile).
test('CRASH: a chain level given as an atom raises a CLP domain error') :-
    dict_pairs(Profile, [ownership_chains - [['thirty']]]),
    no_definite_decision(Profile).
test('CRASH: a chain level given as a list raises a CLP domain error') :-
    dict_pairs(Profile, [ownership_chains - [[[3000]]]]),
    no_definite_decision(Profile).
test('CRASH: a chain level given as the boolean atom true raises a CLP domain error') :-
    dict_pairs(Profile, [ownership_chains - [['true']]]),
    no_definite_decision(Profile).
test('profile given as an atom: no definite decision') :-
    no_definite_decision('profile').
test('profile given as a list: no definite decision') :-
    no_definite_decision([]).
test('profile given as a number: no definite decision') :-
    no_definite_decision(42).
test('empty profile: indeterminate, no crash') :-
    dict_pairs(Profile, []),
    no_definite_decision(Profile).
test('empty list of chains (by design, NOTES section 2): ineligible, exactly once') :-
    dict_pairs(Profile, [ownership_chains - []]),
    amlr_bo_decision(Profile, ineligible),
    dict_pairs(Profile2, [ownership_chains - []]),
    exactly_one_decision(Profile2),
    amlr_bo_effective_holding([], 0).
test('exactly one decision: every fixture subject') :-
    findall(S, amlr_bo_subject(S), Subjects),
    length(Subjects, 3),
    findall(S, (member(S, Subjects), amlr_bo_profile_for(S, P), exactly_one_decision(P)), Single),
    length(Single, 3).
test('exactly one assessment: every fixture subject') :-
    findall(S, amlr_bo_subject(S), Subjects),
    findall(S, (member(S, Subjects), findall(R, amlr_bo_assess(S, R), Results), length(Results, 1)), Single),
    length(Single, 3).
test('boundary: 2499 bp is ineligible') :-
    dict_pairs(Profile, [ownership_chains - [[2499]]]),
    amlr_bo_decision(Profile, ineligible).
test('boundary: 2500 bp is eligible') :-
    dict_pairs(Profile, [ownership_chains - [[2500]]]),
    amlr_bo_decision(Profile, eligible).
test('boundary: 2501 bp is eligible') :-
    dict_pairs(Profile, [ownership_chains - [[2501]]]),
    amlr_bo_decision(Profile, eligible).
test('boundary: parallel chains 1000 + 1499 bp is ineligible') :-
    dict_pairs(Profile, [ownership_chains - [[1000], [1499]]]),
    amlr_bo_decision(Profile, ineligible).
test('input check: a valid profile has no problem') :-
    dict_pairs(Profile, [ownership_chains - [[5000, 4999], [3000]]]),
    findall(P, amlr_bo_input_problem(Profile, P), []).
test('input check: exactly one problem term is reported') :-
    dict_pairs(Profile, [ownership_chains - [[], ['thirty'], [-1]]]),
    findall(P, amlr_bo_input_problem(Profile, P), Problems),
    length(Problems, 1).
test('input check reports not_ground for an unbound ownership_chains value') :-
    dict_pairs(Profile, [ownership_chains - _]),
    amlr_bo_input_problem(Profile, not_ground).
test('input check reports not_ground for an unbound level inside a chain') :-
    dict_pairs(Profile, [ownership_chains - [[5000, _]]]),
    amlr_bo_input_problem(Profile, not_ground).
test('input check reports not_a_profile for an atom profile') :-
    amlr_bo_input_problem('profile', not_a_profile).
test('input check reports missing_key for the empty profile') :-
    dict_pairs(Profile, []),
    amlr_bo_input_problem(Profile, missing_key(ownership_chains)).
test('input check reports not_a_list for ownership_chains given as a number') :-
    dict_pairs(Profile, [ownership_chains - 3000]),
    amlr_bo_input_problem(Profile, not_a_list(ownership_chains)).
test('input check reports not_a_list for a chain given as a number') :-
    dict_pairs(Profile, [ownership_chains - [3000]]),
    amlr_bo_input_problem(Profile, not_a_list(3000)).
test('input check reports empty_chain for [[]]') :-
    dict_pairs(Profile, [ownership_chains - [[]]]),
    amlr_bo_input_problem(Profile, empty_chain).
test('input check reports wrong_type expected_integer for a string level') :-
    dict_pairs(Profile, [ownership_chains - [["3000"]]]),
    amlr_bo_input_problem(Profile, wrong_type("3000", expected_integer)).
test('input check reports out_of_range for a negative level') :-
    dict_pairs(Profile, [ownership_chains - [[-1]]]),
    amlr_bo_input_problem(Profile, out_of_range(-1)).
test('input check reports out_of_range above 10000 basis points') :-
    dict_pairs(Profile, [ownership_chains - [[10001]]]),
    amlr_bo_input_problem(Profile, out_of_range(10001)).
test('input check accepts the range ends 0 and 10000 basis points') :-
    dict_pairs(Profile, [ownership_chains - [[0], [10000]]]),
    findall(P, amlr_bo_input_problem(Profile, P), []).
test('the checklist item names the problem as its unknown reason') :-
    dict_pairs(Profile, [ownership_chains - [[]]]),
    amlr_bo_checklist(Profile, Checklist),
    Checklist = [item(required_ownership_threshold, unknown([empty_chain]), _)].
test('an unbound ownership_chains value is indeterminate and terminates (formerly did not terminate)') :-
    dict_pairs(Profile, [ownership_chains - _]),
    amlr_bo_decision(Profile, indeterminate),
    dict_pairs(Profile2, [ownership_chains - _]),
    exactly_one_decision(Profile2).
test('amlr_bo_status with unbound chains is indeterminate and terminates (formerly did not terminate)') :-
    findall(S, amlr_bo_status(_, S), [indeterminate]).
test('an unbound profile is indeterminate') :-
    amlr_bo_decision(_, indeterminate).
test('a level above 100 percent is indeterminate') :-
    dict_pairs(Profile, [ownership_chains - [[20000]]]),
    amlr_bo_decision(Profile, indeterminate).
test('a negative level is indeterminate') :-
    dict_pairs(Profile, [ownership_chains - [[-5000], [8000]]]),
    amlr_bo_decision(Profile, indeterminate).
test('effective holding: an empty chain gives no total') :-
    findall(T, amlr_bo_effective_holding([[]], T), []).
test('gap to threshold: an empty chain gives no gap') :-
    findall(G, amlr_bo_gap_to_threshold([[]], G), []).
test('what-if: a profile given as an atom gives no answer and no error') :-
    findall(C, amlr_bo_what_if('profile', [[3000]], C), []).

cp_test_names(['control: direct 30 percent is eligible', 'control: 50 x 49.99 chain is ineligible', 'missing ownership_chains: indeterminate, exactly once', 'ownership_chains misspelled as another key: indeterminate', 'KNOWN DEFECT: an empty ownership chain [[]] is counted as 100 percent and yields a definite decision', 'KNOWN DEFECT: an empty chain beside a 10 percent chain lifts the person over the threshold', 'KNOWN DEFECT: amlr_bo_status counts an empty chain [[]] as 100 percent', 'KNOWN DEFECT: assess_amlr_bo reports a definite decision for an empty chain [[]]', 'FAILS OPEN: ownership_chains given as a number yields ineligible', 'FAILS OPEN: ownership_chains given as an atom yields ineligible', 'FAILS OPEN: ownership_chains given as a string yields ineligible', 'FAILS OPEN: ownership_chains given as the boolean atom true yields ineligible', 'FAILS OPEN: ownership_chains given as a flat list of numbers yields ineligible', 'FAILS OPEN: amlr_bo_status on chains given as an atom yields ineligible', 'CRASH: a chain level given as a string raises a CLP domain error', 'CRASH: a string on the second level of a chain raises a CLP domain error', 'CRASH: a chain level given as an atom raises a CLP domain error', 'CRASH: a chain level given as a list raises a CLP domain error', 'CRASH: a chain level given as the boolean atom true raises a CLP domain error', 'profile given as an atom: no definite decision', 'profile given as a list: no definite decision', 'profile given as a number: no definite decision', 'empty profile: indeterminate, no crash', 'empty list of chains (by design, NOTES section 2): ineligible, exactly once', 'exactly one decision: every fixture subject', 'exactly one assessment: every fixture subject', 'boundary: 2499 bp is ineligible', 'boundary: 2500 bp is eligible', 'boundary: 2501 bp is eligible', 'boundary: parallel chains 1000 + 1499 bp is ineligible', 'input check: a valid profile has no problem', 'input check: exactly one problem term is reported', 'input check reports not_ground for an unbound ownership_chains value', 'input check reports not_ground for an unbound level inside a chain', 'input check reports not_a_profile for an atom profile', 'input check reports missing_key for the empty profile', 'input check reports not_a_list for ownership_chains given as a number', 'input check reports not_a_list for a chain given as a number', 'input check reports empty_chain for [[]]', 'input check reports wrong_type expected_integer for a string level', 'input check reports out_of_range for a negative level', 'input check reports out_of_range above 10000 basis points', 'input check accepts the range ends 0 and 10000 basis points', 'the checklist item names the problem as its unknown reason', 'an unbound ownership_chains value is indeterminate and terminates (formerly did not terminate)', 'amlr_bo_status with unbound chains is indeterminate and terminates (formerly did not terminate)', 'an unbound profile is indeterminate', 'a level above 100 percent is indeterminate', 'a negative level is indeterminate', 'effective holding: an empty chain gives no total', 'gap to threshold: an empty chain gives no gap', 'what-if: a profile given as an atom gives no answer and no error']).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
