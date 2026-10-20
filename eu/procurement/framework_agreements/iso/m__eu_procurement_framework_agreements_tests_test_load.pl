:- module(m__eu_procurement_framework_agreements_tests_test_load, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(library(clpz)).
:- use_module(m__eu_procurement_framework_agreements_kernel).
:- use_module(m__eu_procurement_framework_agreements_citations, [citation/2]).
:- use_module(m__eu_procurement_framework_agreements_framework_agreements, [framework_term_limit_years/1]).
:- use_module(m__eu_procurement_framework_agreements_parameters, [parameter_source/2]).

test('kernel verdict atoms are pairwise distinct') :-
    dif(satisfied, not_satisfied),
    dif(satisfied, overall),
    dif(satisfied, as_of_date),
    dif(not_satisfied, overall),
    dif(not_satisfied, as_of_date),
    dif(overall, as_of_date).
test('framework_term_verdict builds and destructures') :-
    Verdict = framework_term_verdict(satisfied, [], []),
    Verdict = framework_term_verdict(Status, DefectIds, Citations),
    Status = satisfied,
    DefectIds = [],
    Citations = [].
test('call_off_verdict builds and destructures') :-
    Verdict = call_off_verdict(satisfied, overall, [], []),
    Verdict = call_off_verdict(Status, Route, DefectIds, Citations),
    Status = satisfied,
    Route = overall,
    DefectIds = [],
    Citations = [].
test('framework_agreements_verdict builds and destructures') :-
    Verdict = framework_agreements_verdict(satisfied, []),
    Verdict = framework_agreements_verdict(Status, Citations),
    Status = satisfied,
    Citations = [].
test('cite constructor builds a ground term') :-
    C = cite(eu_dir_2014_24_art_33_1),
    ground(C).
test('real citation record resolves with non-empty label') :-
    citation(eu_dir_2014_24_art_33_1, Metadata),
    member(label - Label, Metadata),
    dif(Label, '').
test('parameter framework_term_limit_years resolves to 4') :-
    framework_term_limit_years(Years),
    Years #= 4.
test('parameter_source record resolves for framework_term_limit_years') :-
    parameter_source(framework_term_limit_years, Metadata),
    member(label - Label, Metadata),
    dif(Label, '').

cp_test_names(['kernel verdict atoms are pairwise distinct', 'framework_term_verdict builds and destructures', 'call_off_verdict builds and destructures', 'framework_agreements_verdict builds and destructures', 'cite constructor builds a ground term', 'real citation record resolves with non-empty label', 'parameter framework_term_limit_years resolves to 4', 'parameter_source record resolves for framework_term_limit_years']).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
