% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_consent_conditions_tests_test_load, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_consent_conditions_kernel, [gdpr_consent_conditions_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_consent_conditions_citations, [citation/2, implements/1]).

test(a_well_formed_profile_has_no_input_problems) :-
    gdpr_consent_conditions_input_problems([attribute(processing_based_on_consent, true)], Problems),
    Problems == [].
test(a_bare_value_for_an_outside_fact_is_a_wrong_type) :-
    gdpr_consent_conditions_input_problems([attribute(consent_demonstrable, true)], Problems),
    Problems == [wrong_type(consent_demonstrable)].
test(a_term_that_is_not_a_list_is_not_a_profile) :-
    gdpr_consent_conditions_input_problems(not_a_list, Problems),
    Problems == [wrong_type(profile)].
test(the_verdict_atoms_are_distinct) :-
    dif(conditions_met, conditions_not_met).
test(the_verdict_term_builds_and_destructures) :-
    Verdict = gdpr_consent_conditions_verdict(conditions_met, [cite(eu_reg_2016_679_art_7_1)]),
    Verdict = gdpr_consent_conditions_verdict(Status, Citations),
    Status == conditions_met,
    Citations == [cite(eu_reg_2016_679_art_7_1)].
test(a_real_citation_record_resolves) :-
    citation(eu_reg_2016_679_art_7_1, _Record).
test(implements_succeeds_for_a_recorded_key) :-
    implements(eu_reg_2016_679_art_11_2).

test(implements_fails_for_an_unrecorded_key, fail) :-
    implements(eu_todo_primary_source).

cp_test_names([a_well_formed_profile_has_no_input_problems, a_bare_value_for_an_outside_fact_is_a_wrong_type, a_term_that_is_not_a_list_is_not_a_profile, the_verdict_atoms_are_distinct, the_verdict_term_builds_and_destructures, a_real_citation_record_resolves, implements_succeeds_for_a_recorded_key]).
cp_test_fail_names([implements_fails_for_an_unrecorded_key]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
