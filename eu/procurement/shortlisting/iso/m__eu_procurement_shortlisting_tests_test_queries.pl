:- module(m__eu_procurement_shortlisting_tests_test_queries, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(library(clpz)).
:- use_module(m__eu_procurement_shortlisting_queries, [shortlisting_profile_keys/1, shortlisting_what_if/4, shortlisting_threshold_flip/5, shortlisting_floor_comparison/7]).
:- use_module(m__eu_procurement_shortlisting_fixtures, [shortlisting_profile_for/2]).

test('profile keys: all ten keys are declared') :-
    shortlisting_profile_keys(ProfileKeys),
    length(ProfileKeys, 10).
test('what_if: overriding declared_minimum below statutory creates a defect') :-
    shortlisting_profile_for("restricted_all_clear", Profile),
    shortlisting_what_if(Profile, declared_minimum_candidates, 3, limitation_prohibited).
test('what_if: overriding qualified below declared triggers continuation') :-
    shortlisting_profile_for("restricted_all_clear", Profile),
    shortlisting_what_if(Profile, qualified_candidates, 3, continuation_permitted).
test('what_if: overriding qualified above declared keeps limitation_permitted') :-
    shortlisting_profile_for("restricted_all_clear", Profile),
    shortlisting_what_if(Profile, qualified_candidates, 12, limitation_permitted).
test('threshold_flip: finding the boundary for qualified_candidates') :-
    shortlisting_profile_for("restricted_all_clear", Profile),
    shortlisting_threshold_flip(Profile, qualified_candidates, 0, 20, Boundary),
    Boundary #>= 0.
test('floor_comparison: same procedure different inputs') :-
    shortlisting_floor_comparison(restricted_procedure, 5, 10, 5, 4, FloorA, FloorB),
    FloorA #= 5,
    FloorB #= 4.
test('floor_comparison: below statutory returns qualified count') :-
    shortlisting_floor_comparison(restricted_procedure, 3, 7, 5, 10, FloorA, FloorB),
    FloorA #= 7,
    FloorB #= 5.
test('floor_comparison: CPWN statutory boundary') :-
    shortlisting_floor_comparison(competitive_procedure_with_negotiation, 3, 8, 3, 2, FloorA, FloorB),
    FloorA #= 3,
    FloorB #= 2.

cp_test_names(['profile keys: all ten keys are declared', 'what_if: overriding declared_minimum below statutory creates a defect', 'what_if: overriding qualified below declared triggers continuation', 'what_if: overriding qualified above declared keeps limitation_permitted', 'threshold_flip: finding the boundary for qualified_candidates', 'floor_comparison: same procedure different inputs', 'floor_comparison: below statutory returns qualified count', 'floor_comparison: CPWN statutory boundary']).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
