% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_nis2_implementing_regulation_significant_incidents_tests_test_load, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_nis2_implementing_regulation_significant_incidents_kernel, [nis2_implementing_regulation_significant_incidents_input_problems/2, significant/0, not_significant/0, indeterminate/1, needs_legal_review/2, open_textured/2, inputs_relied_on/1, input_problems/1, unknown_key/1, wrong_type/1, duplicate_key/1]).
:- use_module(m__eu_nis2_implementing_regulation_significant_incidents_citations, [citation/2, implements/1]).

test(the_result_atoms_are_defined) :-
    significant,
    not_significant.
test(the_result_atoms_are_distinct) :-
    dif(significant, not_significant).
test(the_result_constructors_are_defined) :-
    indeterminate([scheduled_interruption_or_maintenance]),
    needs_legal_review(open_textured(death_of_natural_person, cite(eu_reg_2024_2690_art_3_1_c)), [inputs_relied_on([death_of_natural_person - unsure])]),
    open_textured(death_of_natural_person, cite(eu_reg_2024_2690_art_3_1_c)),
    inputs_relied_on([death_of_natural_person - unsure]),
    input_problems([unknown_key(colour)]),
    unknown_key(colour),
    wrong_type(profile),
    duplicate_key(death_of_natural_person).
test(the_significant_verdict_term_carries_status_and_citations) :-
    Verdict = nis2_implementing_regulation_significant_incidents_verdict(significant, [cite(eu_reg_2024_2690_art_3_1)]),
    Verdict = nis2_implementing_regulation_significant_incidents_verdict(Status, Citations),
    Status == significant,
    Citations == [cite(eu_reg_2024_2690_art_3_1)].
test(the_not_significant_verdict_term_carries_both_citations) :-
    Verdict = nis2_implementing_regulation_significant_incidents_verdict(not_significant, [cite(eu_reg_2024_2690_art_3_1), cite(eu_reg_2024_2690_art_3_2)]),
    Verdict = nis2_implementing_regulation_significant_incidents_verdict(Status, Citations),
    Status == not_significant,
    length(Citations, 2).
test(the_indeterminate_status_names_one_bare_key) :-
    Verdict = nis2_implementing_regulation_significant_incidents_verdict(indeterminate([scheduled_interruption_or_maintenance]), []),
    Verdict = nis2_implementing_regulation_significant_incidents_verdict(indeterminate(MissingKeys), Citations),
    MissingKeys == [scheduled_interruption_or_maintenance],
    Citations == [].
test(the_referral_status_destructures) :-
    Status = needs_legal_review(open_textured(data_compromised, cite(eu_reg_2024_2690_art_3_1_g)), [inputs_relied_on([data_compromised - unsure])]),
    Status = needs_legal_review(open_textured(Key, cite(Cite)), [inputs_relied_on(Pairs)]),
    Key == data_compromised,
    Cite == eu_reg_2024_2690_art_3_1_g,
    Pairs == [data_compromised - unsure].
test(an_empty_profile_has_no_problem) :-
    findall(Problems, nis2_implementing_regulation_significant_incidents_input_problems([], Problems), Answers),
    Answers == [[]].
test(a_well_formed_profile_has_no_problem) :-
    nis2_implementing_regulation_significant_incidents_input_problems([attribute(scheduled_interruption_or_maintenance, false), attribute(relevant_entity_type, trust_service_provider), attribute(death_of_natural_person, unsure), attribute(direct_financial_loss_euro_cents, 50000001)], Problems),
    Problems == [].
test(an_unknown_key_is_named) :-
    nis2_implementing_regulation_significant_incidents_input_problems([attribute(colour, red)], Problems),
    Problems == [unknown_key(colour)].
test(a_judgement_outside_its_type_is_wrong_type) :-
    nis2_implementing_regulation_significant_incidents_input_problems([attribute(death_of_natural_person, maybe)], Problems),
    Problems == [wrong_type(death_of_natural_person)].
test(a_repeated_key_is_a_duplicate_only) :-
    nis2_implementing_regulation_significant_incidents_input_problems([attribute(death_of_natural_person, true), attribute(death_of_natural_person, maybe)], Problems),
    Problems == [duplicate_key(death_of_natural_person)].
test(a_term_that_is_not_an_attribute_list_is_wrong_type_profile) :-
    findall(Problems, nis2_implementing_regulation_significant_incidents_input_problems(not_a_profile, Problems), Answers),
    Answers == [[wrong_type(profile)]].
test(the_art_3_1_citation_is_recorded) :-
    citation(eu_reg_2024_2690_art_3_1, _Record).
test(the_art_3_2_citation_is_recorded) :-
    citation(eu_reg_2024_2690_art_3_2, _Record).
test(a_recorded_key_is_implemented) :-
    implements(eu_reg_2024_2690_art_3_1_g).

test(an_unrecorded_key_is_not_implemented, fail) :-
    implements(eu_todo_primary_source).

cp_test_names([the_result_atoms_are_defined, the_result_atoms_are_distinct, the_result_constructors_are_defined, the_significant_verdict_term_carries_status_and_citations, the_not_significant_verdict_term_carries_both_citations, the_indeterminate_status_names_one_bare_key, the_referral_status_destructures, an_empty_profile_has_no_problem, a_well_formed_profile_has_no_problem, an_unknown_key_is_named, a_judgement_outside_its_type_is_wrong_type, a_repeated_key_is_a_duplicate_only, a_term_that_is_not_an_attribute_list_is_wrong_type_profile, the_art_3_1_citation_is_recorded, the_art_3_2_citation_is_recorded, a_recorded_key_is_implemented]).
cp_test_fail_names([an_unrecorded_key_is_not_implemented]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
