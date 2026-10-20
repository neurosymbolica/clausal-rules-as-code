:- module(m__eu_procurement_utilities_negotiated_without_prior_call_tests_test_load, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_procurement_utilities_negotiated_without_prior_call_citations, [citation/2, implements/1]).

test('verdict atoms are distinct') :-
    dif(use_lawful, use_unlawful),
    dif(use_lawful, n_a),
    dif(use_unlawful, n_a).
test('result constructor builds and destructures') :-
    Verdict = utilities_negotiated_verdict(use_lawful, n_a, [cite(eu_dir_2014_25_art_50_chapeau)]),
    Verdict = utilities_negotiated_verdict(Status, Ground, Citations),
    Status = use_lawful,
    Ground = n_a,
    Citations = [cite(eu_dir_2014_25_art_50_chapeau)].
test('one real citation record resolves') :-
    citation(eu_dir_2014_25_art_50_chapeau, _Metadata),
    implements(eu_dir_2014_25_art_50_chapeau).

cp_test_names(['verdict atoms are distinct', 'result constructor builds and destructures', 'one real citation record resolves']).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
