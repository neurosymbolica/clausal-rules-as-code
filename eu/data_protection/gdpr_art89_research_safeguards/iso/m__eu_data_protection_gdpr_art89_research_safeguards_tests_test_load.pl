% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_art89_research_safeguards_tests_test_load, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_art89_research_safeguards_kernel, [gdpr_art89_research_safeguards_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_art89_research_safeguards_citations, [citation/2, implements/1]).

test(a_wellformed_profile_has_no_problem) :-
    gdpr_art89_research_safeguards_input_problems([attribute(purpose, scientific_research)], []).
test(an_unsure_judgement_is_wellformed) :-
    gdpr_art89_research_safeguards_input_problems([attribute(safeguards_appropriate, unsure)], []).
test(unsure_is_wrong_for_a_crisp_key) :-
    gdpr_art89_research_safeguards_input_problems([attribute(identifiable_data_processed, unsure)], [wrong_type(identifiable_data_processed)]).
test(a_duplicate_key_is_named) :-
    gdpr_art89_research_safeguards_input_problems([attribute(purpose, statistical), attribute(purpose, other_purpose)], [duplicate_key(purpose)]).
test(an_unknown_key_is_named) :-
    gdpr_art89_research_safeguards_input_problems([attribute(colour, red)], [unknown_key(colour)]).
test(a_non_list_is_not_a_profile) :-
    gdpr_art89_research_safeguards_input_problems(not_a_list, [wrong_type(profile)]).
test(the_verdict_term_builds_and_destructures) :-
    Verdict = gdpr_art89_verdict(in_accordance, [], [cite(eu_reg_2016_679_art_89_1)]),
    Verdict = gdpr_art89_verdict(Status, Unmet, Citations),
    Status == in_accordance,
    Unmet == [],
    Citations == [cite(eu_reg_2016_679_art_89_1)].
test(the_verdict_atoms_are_distinct) :-
    dif(in_accordance, not_in_accordance),
    dif(not_in_accordance, not_applicable).
test(the_real_citation_is_recorded) :-
    citation(eu_reg_2016_679_art_89_1, _Record).
test(the_real_citation_is_implemented) :-
    implements(eu_reg_2016_679_art_89_1).

cp_test_names([a_wellformed_profile_has_no_problem, an_unsure_judgement_is_wellformed, unsure_is_wrong_for_a_crisp_key, a_duplicate_key_is_named, an_unknown_key_is_named, a_non_list_is_not_a_profile, the_verdict_term_builds_and_destructures, the_verdict_atoms_are_distinct, the_real_citation_is_recorded, the_real_citation_is_implemented]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
