% SPDX-License-Identifier: EUPL-1.2
:- module(m__sg_securities_sfa_offer_exemptions_tests_test_load, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__sg_securities_sfa_offer_exemptions_citations, [citation/2]).

test(the_result_term_builds_and_destructures) :-
    Result = offer_exemption(exempt, [s274, s275_1], 500000000, 10, [sg_sfa_2001_s274, sg_sfa_2001_s275_1]),
    Result = offer_exemption(Decision, CoveredBy, WindowAmountCents, WindowPersons, Citations),
    Decision == exempt,
    CoveredBy == [s274, s275_1],
    WindowAmountCents == 500000000,
    WindowPersons == 10,
    Citations == [sg_sfa_2001_s274, sg_sfa_2001_s275_1].
test(the_verdict_atoms_are_distinct) :-
    dif(exempt, prospectus_required),
    dif(exempt, indeterminate),
    dif(prospectus_required, indeterminate).
test(the_real_citation_is_recorded) :-
    citation(sg_sfa_2001_s274, _Record).

cp_test_names([the_result_term_builds_and_destructures, the_verdict_atoms_are_distinct, the_real_citation_is_recorded]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
