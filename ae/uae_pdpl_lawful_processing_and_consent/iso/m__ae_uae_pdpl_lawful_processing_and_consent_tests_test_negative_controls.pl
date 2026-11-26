% SPDX-License-Identifier: EUPL-1.2
:- module(m__ae_uae_pdpl_lawful_processing_and_consent_tests_test_negative_controls, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__ae_uae_pdpl_lawful_processing_and_consent_uae_pdpl_lawful_processing_and_consent, [pdpl_processing_lawful_basis/3, pdpl_consent_valid/3, pdpl_processing_controls/3, uae_pdpl_lawful_processing_and_consent_status_values/1]).
:- use_module(m__ae_uae_pdpl_lawful_processing_and_consent_fixtures, [uae_pdpl_lawful_processing_and_consent_profile_for/2]).

lawful(Subject, Result) :-
    uae_pdpl_lawful_processing_and_consent_profile_for(Subject, Profile),
    pdpl_processing_lawful_basis(Profile, Result, _).

consent(Subject, Result) :-
    uae_pdpl_lawful_processing_and_consent_profile_for(Subject, Profile),
    pdpl_consent_valid(Profile, Result, _).

controls(Subject, Result) :-
    uae_pdpl_lawful_processing_and_consent_profile_for(Subject, Profile),
    pdpl_processing_controls(Profile, Result, _).

test(the_status_table_names_the_final_atoms) :-
    uae_pdpl_lawful_processing_and_consent_status_values(StatusValues),
    member(allowed_with_consent, StatusValues),
    member(not_allowed, StatusValues),
    member(not_in_force, StatusValues).
test(commencement_positive_day_before_is_not_in_force) :-
    lawful(day_before_commencement, not_in_force).
test(commencement_near_miss_first_day_is_allowed_with_consent) :-
    lawful(commencement_day, allowed_with_consent).
test(consent_route_positive) :-
    lawful(valid_consent_no_case, allowed_with_consent).
test(consent_route_near_miss_withdrawn_is_not_allowed) :-
    lawful(consent_fails_withdrawn, not_allowed).
test(consent_route_wins_over_a_true_case) :-
    lawful(valid_consent_and_public_interest, allowed_with_consent).
test(case_route_positive) :-
    lawful(consent_refused_case_contract, allowed_without_consent(contract_with_data_subject)).
test(case_route_first_true_case_wins) :-
    lawful(consent_refused_two_cases, allowed_without_consent(legal_claims_and_judicial_or_security_procedures)).
test(not_allowed_positive) :-
    lawful(consent_fails_given, not_allowed).
test(not_allowed_near_miss_gives_the_case) :-
    lawful(consent_refused_case_other_laws, allowed_without_consent(obligations_under_other_laws)).
test(valid_positive) :-
    consent(valid_consent_no_case, valid).
test(valid_near_miss_names_the_definition) :-
    consent(consent_fails_specific, not_valid(consent_not_specific_clear_and_unambiguous)).
test(valid_near_miss_proof_names_the_proof) :-
    consent(consent_fails_proof, not_valid(controller_cannot_prove_consent)).
test(controls_positive) :-
    controls(valid_consent_no_case, meets_listed_controls).
test(controls_near_miss_names_retention) :-
    controls(control_fails_retention, fails_control(control_7_not_kept_after_purpose_exhausted)).
test(missing_date_positive) :-
    lawful(processing_date_unstated, indeterminate([processing_date])).
test(missing_consent_key_positive) :-
    consent(proof_of_consent_unstated, indeterminate([controller_able_to_prove_consent])).
test(control_referral_positive) :-
    controls(unsure_fairness_before_failing_purpose, needs_legal_review(open_textured(processed_fairly_transparently_and_lawfully, cite(uae_pdpl_art_5_1)), [inputs_relied_on([processed_fairly_transparently_and_lawfully - unsure])])).
test(control_referral_near_miss_names_the_absent_key) :-
    controls(unsure_fairness_next_control_unstated, indeterminate([collected_for_specific_and_clear_purpose])).
test(lawful_consent_referral_positive) :-
    lawful(unsure_specific_consent_with_true_case, needs_legal_review(open_textured(consent_specific_clear_and_unambiguous, cite(uae_pdpl_art_1_consent)), [inputs_relied_on([consent_specific_clear_and_unambiguous - unsure])])).
test(lawful_consent_referral_near_miss_names_the_first_case) :-
    lawful(unsure_specific_consent_cases_unstated, indeterminate([necessary_to_protect_public_interest])).
test(case_referral_positive) :-
    lawful(unsure_public_interest_before_true_case, needs_legal_review(open_textured(necessary_to_protect_public_interest, cite(uae_pdpl_art_4_1)), [inputs_relied_on([necessary_to_protect_public_interest - unsure])])).
test(input_problem_positive_year_zero) :-
    lawful(year_zero, input_problems([wrong_type(processing_date)])).
test(input_problem_crisp_key_unsure) :-
    consent(crisp_consent_given_unsure, input_problems([wrong_type(consent_given)])).

test(commencement_near_miss_first_day_is_not_not_in_force, fail) :-
    lawful(commencement_day, not_in_force).
test(consent_route_near_miss_withdrawn_is_not_allowed_with_consent, fail) :-
    lawful(consent_fails_withdrawn, allowed_with_consent).
test(consent_route_true_case_is_not_named_with_valid_consent, fail) :-
    lawful(valid_consent_and_public_interest, allowed_without_consent(_)).
test(case_route_near_miss_no_case_gives_no_case, fail) :-
    lawful(consent_fails_given, allowed_without_consent(_)).
test(case_route_later_true_case_is_not_named, fail) :-
    lawful(consent_refused_two_cases, allowed_without_consent(contract_with_data_subject)).
test(not_allowed_near_miss_one_case_holds, fail) :-
    lawful(consent_refused_case_other_laws, not_allowed).
test(valid_near_miss_definition_failing_is_not_valid, fail) :-
    consent(consent_fails_specific, valid).
test(valid_near_miss_proof_is_not_named_as_withdrawn, fail) :-
    consent(consent_fails_proof, not_valid(consent_withdrawn)).
test(controls_near_miss_retention_does_not_meet, fail) :-
    controls(control_fails_retention, meets_listed_controls).
test(missing_date_near_miss_stated_date_is_not_indeterminate, fail) :-
    lawful(commencement_day, indeterminate(_)).
test(missing_consent_key_near_miss_stated, fail) :-
    consent(valid_consent_no_case, indeterminate(_)).
test(control_referral_near_miss_a_later_key_absent, fail) :-
    controls(unsure_fairness_next_control_unstated, needs_legal_review(_, _)).
test(lawful_consent_referral_near_miss_cases_unstated, fail) :-
    lawful(unsure_specific_consent_cases_unstated, needs_legal_review(_, _)).
test(case_referral_near_miss_next_case_unstated, fail) :-
    lawful(unsure_public_interest_next_case_unstated, needs_legal_review(_, _)).
test(input_problem_near_miss_year_9999_is_well_formed, fail) :-
    lawful(last_calendar_year, input_problems(_)).
test(input_problem_near_miss_judgement_unsure_is_well_formed, fail) :-
    consent(unsure_specific_consent_with_true_case, input_problems(_)).

cp_test_names([the_status_table_names_the_final_atoms, commencement_positive_day_before_is_not_in_force, commencement_near_miss_first_day_is_allowed_with_consent, consent_route_positive, consent_route_near_miss_withdrawn_is_not_allowed, consent_route_wins_over_a_true_case, case_route_positive, case_route_first_true_case_wins, not_allowed_positive, not_allowed_near_miss_gives_the_case, valid_positive, valid_near_miss_names_the_definition, valid_near_miss_proof_names_the_proof, controls_positive, controls_near_miss_names_retention, missing_date_positive, missing_consent_key_positive, control_referral_positive, control_referral_near_miss_names_the_absent_key, lawful_consent_referral_positive, lawful_consent_referral_near_miss_names_the_first_case, case_referral_positive, input_problem_positive_year_zero, input_problem_crisp_key_unsure]).
cp_test_fail_names([commencement_near_miss_first_day_is_not_not_in_force, consent_route_near_miss_withdrawn_is_not_allowed_with_consent, consent_route_true_case_is_not_named_with_valid_consent, case_route_near_miss_no_case_gives_no_case, case_route_later_true_case_is_not_named, not_allowed_near_miss_one_case_holds, valid_near_miss_definition_failing_is_not_valid, valid_near_miss_proof_is_not_named_as_withdrawn, controls_near_miss_retention_does_not_meet, missing_date_near_miss_stated_date_is_not_indeterminate, missing_consent_key_near_miss_stated, control_referral_near_miss_a_later_key_absent, lawful_consent_referral_near_miss_cases_unstated, case_referral_near_miss_next_case_unstated, input_problem_near_miss_year_9999_is_well_formed, input_problem_near_miss_judgement_unsure_is_well_formed]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
