:- module(m__eu_procurement_utilities_negotiated_without_prior_call_tests_test_negative_controls, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_procurement_utilities_negotiated_without_prior_call_utilities_negotiated_without_prior_call, [utilities_negotiated_without_prior_call_status/2]).
:- use_module(m__eu_procurement_utilities_negotiated_without_prior_call_fixtures, [utilities_negotiated_without_prior_call_profile_for/2]).

test('route a positive: all conditions met -> use_lawful') :-
    utilities_negotiated_without_prior_call_profile_for("a_lawful", Profile),
    utilities_negotiated_without_prior_call_status(Profile, use_lawful).
test('route a near-miss: initial_conditions flipped -> use_unlawful') :-
    utilities_negotiated_without_prior_call_profile_for("a_near_miss", Profile),
    utilities_negotiated_without_prior_call_status(Profile, use_unlawful).
test('route b positive: all three conditions met -> use_lawful') :-
    utilities_negotiated_without_prior_call_profile_for("b_lawful", Profile),
    utilities_negotiated_without_prior_call_status(Profile, use_lawful).
test('route b near-miss: no-prejudice flipped -> use_unlawful') :-
    utilities_negotiated_without_prior_call_profile_for("b_near_miss", Profile),
    utilities_negotiated_without_prior_call_status(Profile, use_unlawful).
test('route c-art positive: only particular operator -> use_lawful') :-
    utilities_negotiated_without_prior_call_profile_for("c_art_lawful", Profile),
    utilities_negotiated_without_prior_call_status(Profile, use_lawful).
test('route c-art near-miss: only_particular_operator flipped -> use_unlawful') :-
    utilities_negotiated_without_prior_call_profile_for("c_art_near_miss", Profile),
    utilities_negotiated_without_prior_call_status(Profile, use_unlawful).
test('route c-tech positive: all three conditions met -> use_lawful') :-
    utilities_negotiated_without_prior_call_profile_for("c_tech_lawful", Profile),
    utilities_negotiated_without_prior_call_status(Profile, use_lawful).
test('route c-tech near-miss: not-artificially-narrowed flipped -> use_unlawful') :-
    utilities_negotiated_without_prior_call_profile_for("c_tech_near_miss", Profile),
    utilities_negotiated_without_prior_call_status(Profile, use_unlawful).
test('route c-rights positive: all three conditions met -> use_lawful') :-
    utilities_negotiated_without_prior_call_profile_for("c_rights_lawful", Profile),
    utilities_negotiated_without_prior_call_status(Profile, use_lawful).
test('route c-rights near-miss: no-reasonable-alternative flipped -> use_unlawful') :-
    utilities_negotiated_without_prior_call_profile_for("c_rights_near_miss", Profile),
    utilities_negotiated_without_prior_call_status(Profile, use_unlawful).
test('route d positive: all three conditions met -> use_lawful') :-
    utilities_negotiated_without_prior_call_profile_for("d_lawful", Profile),
    utilities_negotiated_without_prior_call_status(Profile, use_lawful).
test('route d near-miss: not-attributable flipped -> use_unlawful') :-
    utilities_negotiated_without_prior_call_profile_for("d_near_miss", Profile),
    utilities_negotiated_without_prior_call_status(Profile, use_unlawful).
test('route e positive: supplies type + both conditions -> use_lawful') :-
    utilities_negotiated_without_prior_call_profile_for("e_lawful", Profile),
    utilities_negotiated_without_prior_call_status(Profile, use_lawful).
test('route e near-miss: works type-gate violated -> use_unlawful') :-
    utilities_negotiated_without_prior_call_profile_for("e_near_miss", Profile),
    utilities_negotiated_without_prior_call_status(Profile, use_unlawful).
test('route f positive: services type + all four conditions -> use_lawful') :-
    utilities_negotiated_without_prior_call_profile_for("f_lawful", Profile),
    utilities_negotiated_without_prior_call_status(Profile, use_lawful).
test('route f near-miss: supplies type-gate violated -> use_unlawful') :-
    utilities_negotiated_without_prior_call_profile_for("f_near_miss", Profile),
    utilities_negotiated_without_prior_call_status(Profile, use_unlawful).
test('route g positive: supplies type + condition met -> use_lawful') :-
    utilities_negotiated_without_prior_call_profile_for("g_lawful", Profile),
    utilities_negotiated_without_prior_call_status(Profile, use_lawful).
test('route g near-miss: services type-gate violated -> use_unlawful') :-
    utilities_negotiated_without_prior_call_profile_for("g_near_miss", Profile),
    utilities_negotiated_without_prior_call_status(Profile, use_unlawful).
test('route h positive: supplies type + both conditions -> use_lawful') :-
    utilities_negotiated_without_prior_call_profile_for("h_lawful", Profile),
    utilities_negotiated_without_prior_call_status(Profile, use_lawful).
test('route h near-miss: price condition flipped -> use_unlawful') :-
    utilities_negotiated_without_prior_call_profile_for("h_near_miss", Profile),
    utilities_negotiated_without_prior_call_status(Profile, use_unlawful).
test('route i positive: services type + both conditions -> use_lawful') :-
    utilities_negotiated_without_prior_call_profile_for("i_lawful", Profile),
    utilities_negotiated_without_prior_call_status(Profile, use_lawful).
test('route i near-miss: works type-gate violated -> use_unlawful') :-
    utilities_negotiated_without_prior_call_profile_for("i_near_miss", Profile),
    utilities_negotiated_without_prior_call_status(Profile, use_unlawful).
test('route j positive: services type + both conditions -> use_lawful') :-
    utilities_negotiated_without_prior_call_profile_for("j_lawful", Profile),
    utilities_negotiated_without_prior_call_status(Profile, use_lawful).
test('route j near-miss: supplies type-gate violated -> use_unlawful') :-
    utilities_negotiated_without_prior_call_profile_for("j_near_miss", Profile),
    utilities_negotiated_without_prior_call_status(Profile, use_unlawful).

cp_test_names(['route a positive: all conditions met -> use_lawful', 'route a near-miss: initial_conditions flipped -> use_unlawful', 'route b positive: all three conditions met -> use_lawful', 'route b near-miss: no-prejudice flipped -> use_unlawful', 'route c-art positive: only particular operator -> use_lawful', 'route c-art near-miss: only_particular_operator flipped -> use_unlawful', 'route c-tech positive: all three conditions met -> use_lawful', 'route c-tech near-miss: not-artificially-narrowed flipped -> use_unlawful', 'route c-rights positive: all three conditions met -> use_lawful', 'route c-rights near-miss: no-reasonable-alternative flipped -> use_unlawful', 'route d positive: all three conditions met -> use_lawful', 'route d near-miss: not-attributable flipped -> use_unlawful', 'route e positive: supplies type + both conditions -> use_lawful', 'route e near-miss: works type-gate violated -> use_unlawful', 'route f positive: services type + all four conditions -> use_lawful', 'route f near-miss: supplies type-gate violated -> use_unlawful', 'route g positive: supplies type + condition met -> use_lawful', 'route g near-miss: services type-gate violated -> use_unlawful', 'route h positive: supplies type + both conditions -> use_lawful', 'route h near-miss: price condition flipped -> use_unlawful', 'route i positive: services type + both conditions -> use_lawful', 'route i near-miss: works type-gate violated -> use_unlawful', 'route j positive: services type + both conditions -> use_lawful', 'route j near-miss: supplies type-gate violated -> use_unlawful']).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
