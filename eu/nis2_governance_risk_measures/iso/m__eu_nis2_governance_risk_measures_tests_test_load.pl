% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_nis2_governance_risk_measures_tests_test_load, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_nis2_governance_risk_measures_kernel, [nis2_governance_risk_measures_input_problems/2]).
:- use_module(m__eu_nis2_governance_risk_measures_citations, [citation/2, implements/1]).

test(the_kernel_input_check_accepts_an_empty_profile) :-
    nis2_governance_risk_measures_input_problems([], []).
test(the_kernel_input_check_names_an_unknown_key) :-
    nis2_governance_risk_measures_input_problems([attribute(no_such_key, true)], [unknown_key(no_such_key)]).
test(the_kernel_input_check_names_a_wrong_type) :-
    nis2_governance_risk_measures_input_problems([attribute(entity_class, maybe)], [wrong_type(entity_class)]).
test(the_result_atoms_are_distinct) :-
    dif(must_take_corrective_measures_without_undue_delay, no_corrective_measures_duty).
test(the_entity_class_atoms_are_distinct) :-
    dif(essential_entity, important_entity),
    dif(important_entity, out_of_scope),
    dif(essential_entity, out_of_scope).
test(the_verdict_term_carries_status_and_citations) :-
    Verdict = nis2_governance_risk_measures_verdict(duties_apply, [cite(eu_dir_2022_2555_art_20_1)]),
    Verdict = nis2_governance_risk_measures_verdict(Status, Citations),
    Status == duties_apply,
    Citations == [cite(eu_dir_2022_2555_art_20_1)].
test(the_duty_term_destructures) :-
    Duty = duty(approve_the_cybersecurity_risk_management_measures, cite(eu_dir_2022_2555_art_20_1)),
    Duty = duty(Name, cite(Key)),
    Name == approve_the_cybersecurity_risk_management_measures,
    Key == eu_dir_2022_2555_art_20_1.
test(the_status_compound_destructures) :-
    Status = needs_legal_review(open_textured(multi_factor_authentication_and_secured_communications_appropriate, cite(eu_dir_2022_2555_art_21_2_j)), [inputs_relied_on([multi_factor_authentication_and_secured_communications_appropriate - unsure])]),
    Status = needs_legal_review(open_textured(Input, cite(Key)), [inputs_relied_on(Pairs)]),
    Input == multi_factor_authentication_and_secured_communications_appropriate,
    Key == eu_dir_2022_2555_art_21_2_j,
    Pairs == [multi_factor_authentication_and_secured_communications_appropriate - unsure].
test(a_real_citation_record_resolves) :-
    citation(eu_dir_2022_2555_art_21_1, _Record).
test(the_corrective_measures_citation_resolves) :-
    citation(eu_dir_2022_2555_art_21_4, [label - _Label|_Rest]).
test(implements_succeeds_for_a_recorded_key) :-
    implements(eu_dir_2022_2555_art_21_2_j).

test(implements_fails_for_an_unrecorded_key, fail) :-
    implements(eu_dir_2022_2555_art_99_9).

cp_test_names([the_kernel_input_check_accepts_an_empty_profile, the_kernel_input_check_names_an_unknown_key, the_kernel_input_check_names_a_wrong_type, the_result_atoms_are_distinct, the_entity_class_atoms_are_distinct, the_verdict_term_carries_status_and_citations, the_duty_term_destructures, the_status_compound_destructures, a_real_citation_record_resolves, the_corrective_measures_citation_resolves, implements_succeeds_for_a_recorded_key]).
cp_test_fail_names([implements_fails_for_an_unrecorded_key]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
