% SPDX-License-Identifier: EUPL-1.2
:- module(m__ae_uae_pdpl_scope_and_exclusions_tests_test_load, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__ae_uae_pdpl_scope_and_exclusions_kernel, [uae_pdpl_scope_and_exclusions_input_problems/2]).
:- use_module(m__ae_uae_pdpl_scope_and_exclusions_citations, [citation/2, implements/1]).

test(the_applies_atoms_are_distinct) :-
    dif(applies, does_not_apply),
    dif(applies, not_in_force),
    dif(does_not_apply, not_in_force).
test(the_in_force_atoms_are_distinct) :-
    dif(in_force, not_in_force).
test(the_judgement_values_are_distinct) :-
    dif(unsure, true),
    dif(unsure, false),
    dif(true, false).
test(the_facade_verdict_term_carries_status_and_citations) :-
    Verdict = uae_pdpl_scope_and_exclusions_verdict(not_in_force, [cite(uae_pdpl_art_31)]),
    Verdict = uae_pdpl_scope_and_exclusions_verdict(Status, Citations),
    Status == not_in_force,
    Citations == [cite(uae_pdpl_art_31)].
test(the_missing_key_status_names_one_key) :-
    Result = indeterminate([processing_date]),
    Result = indeterminate([MissingKey]),
    MissingKey == processing_date.
test(the_referral_status_destructures) :-
    Result = needs_legal_review(open_textured(personal_data_is_government_data, cite(uae_pdpl_art_2_2_a)), [inputs_relied_on([processing_date - date(2023, 5, 1), personal_data_is_government_data - unsure])]),
    Result = needs_legal_review(open_textured(Key, cite(CitationKey)), [inputs_relied_on(Pairs)]),
    Key == personal_data_is_government_data,
    CitationKey == uae_pdpl_art_2_2_a,
    Pairs == [processing_date - date(2023, 5, 1), personal_data_is_government_data - unsure].
test(the_input_problems_status_destructures) :-
    Result = input_problems([wrong_type(processing_date), unknown_key(colour)]),
    Result = input_problems(Problems),
    Problems == [wrong_type(processing_date), unknown_key(colour)].
test(the_scope_citations_are_recorded) :-
    citation(uae_pdpl_art_2_1, _),
    citation(uae_pdpl_art_2_2, _),
    citation(uae_pdpl_art_1_personal_data, _),
    implements(uae_pdpl_art_2_2_g).
test(a_full_well_formed_profile_has_no_problem) :-
    uae_pdpl_scope_and_exclusions_input_problems([attribute(processing_date, date(2022, 1, 2)), attribute(activity_is_processing_of_personal_data, true), attribute(personal_data_is_government_data, false), attribute(governmental_entity_controls_or_processes, false), attribute(personal_data_held_by_security_or_judicial_authorities, false), attribute(data_subject_processing_own_data_for_personal_purposes, false), attribute(personal_health_data_with_own_protection_legislation, false), attribute(personal_banking_or_credit_data_with_own_protection_legislation, false), attribute(free_zone_company_or_establishment_with_own_data_protection_legislation, unsure), attribute(data_subject_resides_or_has_place_of_business_in_state, true), attribute(controller_or_processor_resides_in_state, false), attribute(data_subject_inside_state, false)], []).
test(an_unknown_key_is_named) :-
    uae_pdpl_scope_and_exclusions_input_problems([attribute(colour, red)], [unknown_key(colour)]).

test(a_referral_status_is_not_a_missing_key_status, fail) :-
    needs_legal_review(open_textured(activity_is_processing_of_personal_data, cite(uae_pdpl_art_1_personal_data)), [inputs_relied_on([])]) = indeterminate(_).
test(a_shortened_citation_key_is_not_recorded, fail) :-
    citation(pdpl_art_31, _).
test(an_unknown_key_is_not_well_formed, fail) :-
    uae_pdpl_scope_and_exclusions_input_problems([attribute(colour, red)], []).

cp_test_names([the_applies_atoms_are_distinct, the_in_force_atoms_are_distinct, the_judgement_values_are_distinct, the_facade_verdict_term_carries_status_and_citations, the_missing_key_status_names_one_key, the_referral_status_destructures, the_input_problems_status_destructures, the_scope_citations_are_recorded, a_full_well_formed_profile_has_no_problem, an_unknown_key_is_named]).
cp_test_fail_names([a_referral_status_is_not_a_missing_key_status, a_shortened_citation_key_is_not_recorded, an_unknown_key_is_not_well_formed]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
