% SPDX-License-Identifier: EUPL-1.2
:- module(m__ae_uae_pdpl_lawful_processing_and_consent_tests_test_load, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__ae_uae_pdpl_lawful_processing_and_consent_kernel, [uae_pdpl_lawful_processing_and_consent_input_problems/2]).
:- use_module(m__ae_uae_pdpl_lawful_processing_and_consent_citations, [citation/2, implements/1]).

test(the_input_check_loads_and_answers_once_for_an_empty_profile) :-
    findall(Problems, uae_pdpl_lawful_processing_and_consent_input_problems([], Problems), Answers),
    Answers == [[]].
test(the_input_check_accepts_a_well_formed_profile) :-
    uae_pdpl_lawful_processing_and_consent_input_problems([attribute(processing_date, date(2023, 6, 1)), attribute(consent_given, true), attribute(consent_specific_clear_and_unambiguous, unsure)], Problems),
    Problems == [].
test(the_input_check_names_an_unknown_key) :-
    uae_pdpl_lawful_processing_and_consent_input_problems([attribute(colour, red)], Problems),
    Problems == [unknown_key(colour)].
test(a_crisp_key_given_unsure_is_wrong_type) :-
    uae_pdpl_lawful_processing_and_consent_input_problems([attribute(consent_given, unsure)], Problems),
    Problems == [wrong_type(consent_given)].
test(a_non_list_profile_is_wrong_type) :-
    uae_pdpl_lawful_processing_and_consent_input_problems(not_a_profile, Problems),
    Problems == [wrong_type(profile)].
test(the_lawful_basis_atoms_are_distinct) :-
    dif(allowed_with_consent, not_allowed),
    dif(allowed_with_consent, not_in_force),
    dif(not_allowed, not_in_force).
test(the_consent_and_control_atoms_are_distinct) :-
    dif(valid, not_in_force),
    dif(meets_listed_controls, not_in_force),
    dif(valid, meets_listed_controls).
test(the_case_atoms_are_distinct) :-
    Cases = [public_interest, data_made_public_by_data_subject, legal_claims_and_judicial_or_security_procedures, occupational_or_preventive_medicine_and_health_or_social_care, public_health, archival_scientific_historical_or_statistical_purposes, interests_of_data_subject, employment_social_security_and_social_protection, contract_with_data_subject, obligations_under_other_laws],
    sort(Cases, Sorted),
    length(Cases, CaseCount),
    length(Sorted, SortedCount),
    CaseCount == 10,
    SortedCount == 10.
test(the_consent_failure_atoms_are_distinct) :-
    Atoms = [consent_not_given, consent_not_specific_clear_and_unambiguous, controller_cannot_prove_consent, consent_not_clear_simple_and_easily_accessible, consent_omits_easy_withdrawal_right, consent_withdrawn],
    sort(Atoms, Sorted),
    length(Sorted, SortedCount),
    SortedCount == 6.
test(the_control_failure_atoms_are_distinct) :-
    Atoms = [control_1_fair_transparent_and_lawful, control_2_specific_and_clear_purpose, control_2_no_incompatible_later_processing, control_3_sufficient_and_limited, control_4_accurate_and_updated, control_5_incorrect_data_deleted_or_corrected, control_6_kept_securely, control_7_not_kept_after_purpose_exhausted],
    sort(Atoms, Sorted),
    length(Sorted, SortedCount),
    SortedCount == 8.
test(the_allowed_without_consent_compound_destructures) :-
    Result = allowed_without_consent(contract_with_data_subject),
    Result = allowed_without_consent(Case),
    Case == contract_with_data_subject,
    functor(Result, Name, Arity),
    Name == allowed_without_consent,
    Arity == 1.
test(the_not_valid_compound_destructures) :-
    Result = not_valid(consent_withdrawn),
    Result = not_valid(Atom),
    Atom == consent_withdrawn.
test(the_fails_control_compound_destructures) :-
    Result = fails_control(control_6_kept_securely),
    Result = fails_control(Atom),
    Atom == control_6_kept_securely.
test(the_indeterminate_status_names_one_key) :-
    Result = indeterminate([processing_date]),
    Result = indeterminate([Key]),
    Key == processing_date.
test(the_needs_legal_review_status_destructures) :-
    Result = needs_legal_review(open_textured(kept_securely, cite(uae_pdpl_art_5_6)), [inputs_relied_on([kept_securely - unsure])]),
    Result = needs_legal_review(open_textured(Key, cite(CitationKey)), [inputs_relied_on(Pairs)]),
    Key == kept_securely,
    CitationKey == uae_pdpl_art_5_6,
    Pairs == [kept_securely - unsure].
test(the_slice_verdict_term_carries_result_and_citations) :-
    Verdict = uae_pdpl_lawful_processing_and_consent_verdict(not_in_force, [cite(uae_pdpl_art_31)]),
    Verdict = uae_pdpl_lawful_processing_and_consent_verdict(Result, Citations),
    Result == not_in_force,
    Citations == [cite(uae_pdpl_art_31)].
test(the_consent_definition_citation_is_recorded) :-
    citation(uae_pdpl_art_1_consent, _Record).
test(the_load_bearing_citations_implement) :-
    implements(uae_pdpl_art_4),
    implements(uae_pdpl_art_4_1),
    implements(uae_pdpl_art_5),
    implements(uae_pdpl_art_5_7),
    implements(uae_pdpl_art_6_1),
    implements(uae_pdpl_art_6_1_a),
    implements(uae_pdpl_art_6_1_b),
    implements(uae_pdpl_art_6_1_c),
    implements(uae_pdpl_art_6_2).

test(a_well_formed_profile_has_no_wrong_type, fail) :-
    uae_pdpl_lawful_processing_and_consent_input_problems([attribute(consent_given, true)], [wrong_type(consent_given)]).
test(a_compound_status_is_not_its_bare_atom, fail) :-
    indeterminate([processing_date]) = indeterminate.
test(an_unrecorded_citation_does_not_resolve, fail) :-
    citation(ae_todo_primary_source, _Record).

cp_test_names([the_input_check_loads_and_answers_once_for_an_empty_profile, the_input_check_accepts_a_well_formed_profile, the_input_check_names_an_unknown_key, a_crisp_key_given_unsure_is_wrong_type, a_non_list_profile_is_wrong_type, the_lawful_basis_atoms_are_distinct, the_consent_and_control_atoms_are_distinct, the_case_atoms_are_distinct, the_consent_failure_atoms_are_distinct, the_control_failure_atoms_are_distinct, the_allowed_without_consent_compound_destructures, the_not_valid_compound_destructures, the_fails_control_compound_destructures, the_indeterminate_status_names_one_key, the_needs_legal_review_status_destructures, the_slice_verdict_term_carries_result_and_citations, the_consent_definition_citation_is_recorded, the_load_bearing_citations_implement]).
cp_test_fail_names([a_well_formed_profile_has_no_wrong_type, a_compound_status_is_not_its_bare_atom, an_unrecorded_citation_does_not_resolve]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
