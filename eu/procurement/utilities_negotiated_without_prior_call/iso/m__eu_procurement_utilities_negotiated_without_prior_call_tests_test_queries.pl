:- module(m__eu_procurement_utilities_negotiated_without_prior_call_tests_test_queries, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(library(clpz)).
:- use_module(m__eu_procurement_utilities_negotiated_without_prior_call_queries, [utilities_negotiated_without_prior_call_profile_keys/1, utilities_negotiated_without_prior_call_what_if/4]).
:- use_module(m__eu_procurement_utilities_negotiated_without_prior_call_utilities_negotiated_without_prior_call, [utilities_negotiated_without_prior_call_checklist/2, utilities_negotiated_without_prior_call_unmet_count/2]).
:- use_module(m__eu_procurement_utilities_negotiated_without_prior_call_fixtures, [utilities_negotiated_without_prior_call_profile_for/2]).

test('justification: a_lawful checklist has two items both met') :-
    utilities_negotiated_without_prior_call_profile_for("a_lawful", Profile),
    utilities_negotiated_without_prior_call_checklist(Profile, Checklist),
    length(Checklist, 2).
test('justification: d_lawful checklist has three items') :-
    utilities_negotiated_without_prior_call_profile_for("d_lawful", Profile),
    utilities_negotiated_without_prior_call_checklist(Profile, Checklist),
    length(Checklist, 3).
test('justification: e_lawful checklist includes type-gate item') :-
    utilities_negotiated_without_prior_call_profile_for("e_lawful", Profile),
    utilities_negotiated_without_prior_call_checklist(Profile, Checklist),
    length(Checklist, 3).
test('calculation: a_lawful has zero unmet conditions') :-
    utilities_negotiated_without_prior_call_profile_for("a_lawful", Profile),
    utilities_negotiated_without_prior_call_unmet_count(Profile, 0).
test('calculation: a_near_miss has exactly one unmet condition') :-
    utilities_negotiated_without_prior_call_profile_for("a_near_miss", Profile),
    utilities_negotiated_without_prior_call_unmet_count(Profile, 1).
test('calculation: d_near_miss has exactly one unmet condition') :-
    utilities_negotiated_without_prior_call_profile_for("d_near_miss", Profile),
    utilities_negotiated_without_prior_call_unmet_count(Profile, 1).
test('calculation: e_near_miss (type-gate) has at least one unmet') :-
    utilities_negotiated_without_prior_call_profile_for("e_near_miss", Profile),
    utilities_negotiated_without_prior_call_unmet_count(Profile, Count),
    Count #>= 1.
test('what_if: flipping initial_conditions to false makes a_lawful unlawful') :-
    utilities_negotiated_without_prior_call_profile_for("a_lawful", Profile),
    utilities_negotiated_without_prior_call_what_if(Profile, initial_conditions_not_substantially_altered, false, use_unlawful).
test('what_if: flipping initial_conditions to true restores a_near_miss to lawful') :-
    utilities_negotiated_without_prior_call_profile_for("a_near_miss", Profile),
    utilities_negotiated_without_prior_call_what_if(Profile, initial_conditions_not_substantially_altered, true, use_lawful).
test('what_if: overriding contract_type to services on e_lawful makes it unlawful') :-
    utilities_negotiated_without_prior_call_profile_for("e_lawful", Profile),
    utilities_negotiated_without_prior_call_what_if(Profile, contract_type_key, services, use_unlawful).
test('profile keys: pleaded_ground_key is in the declared key list') :-
    utilities_negotiated_without_prior_call_profile_keys(Keys),
    member(pleaded_ground_key, Keys).
test('profile keys: contract_type_key is in the declared key list') :-
    utilities_negotiated_without_prior_call_profile_keys(Keys),
    member(contract_type_key, Keys).
test('profile keys: the list has 27 entries') :-
    utilities_negotiated_without_prior_call_profile_keys(Keys),
    length(Keys, 27).

cp_test_names(['justification: a_lawful checklist has two items both met', 'justification: d_lawful checklist has three items', 'justification: e_lawful checklist includes type-gate item', 'calculation: a_lawful has zero unmet conditions', 'calculation: a_near_miss has exactly one unmet condition', 'calculation: d_near_miss has exactly one unmet condition', 'calculation: e_near_miss (type-gate) has at least one unmet', 'what_if: flipping initial_conditions to false makes a_lawful unlawful', 'what_if: flipping initial_conditions to true restores a_near_miss to lawful', 'what_if: overriding contract_type to services on e_lawful makes it unlawful', 'profile keys: pleaded_ground_key is in the declared key list', 'profile keys: contract_type_key is in the declared key list', 'profile keys: the list has 27 entries']).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
