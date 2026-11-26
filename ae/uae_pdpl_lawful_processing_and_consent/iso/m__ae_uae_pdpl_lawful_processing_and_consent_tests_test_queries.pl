% SPDX-License-Identifier: EUPL-1.2
:- module(m__ae_uae_pdpl_lawful_processing_and_consent_tests_test_queries, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__ae_uae_pdpl_lawful_processing_and_consent_queries, [uae_pdpl_lawful_processing_and_consent_profile_keys/1, uae_pdpl_lawful_processing_and_consent_eligibility/3, uae_pdpl_lawful_processing_and_consent_justification/4, uae_pdpl_lawful_processing_and_consent_what_if/4, allowed_without_consent/1, not_valid/1, fails_control/1]).
:- use_module(m__ae_uae_pdpl_lawful_processing_and_consent_fixtures, [uae_pdpl_lawful_processing_and_consent_profile_for/2]).

labels_of(Subject, Labels) :-
    uae_pdpl_lawful_processing_and_consent_profile_for(Subject, Profile),
    findall(Label, uae_pdpl_lawful_processing_and_consent_eligibility(Profile, Label, _), Labels).

requirement_row_cites(item(_, _, [cite(Key)|_])) :-
    atom(Key).

test(profile_keys_are_the_contract_keys) :-
    uae_pdpl_lawful_processing_and_consent_profile_keys(ProfileKeys),
    ProfileKeys == [processing_date, consent_given, consent_specific_clear_and_unambiguous, controller_able_to_prove_consent, consent_clear_simple_unambiguous_and_easily_accessible, consent_includes_right_to_withdraw_easily, consent_withdrawn_before_processing, necessary_to_protect_public_interest, personal_data_made_available_and_known_to_all_by_data_subject, necessary_for_legal_claims_defence_of_rights_or_judicial_or_security_procedures, necessary_for_occupational_or_preventive_medicine_or_health_or_social_care, necessary_to_protect_public_health, necessary_for_archival_purposes_or_scientific_historical_or_statistical_studies, necessary_to_protect_interests_of_data_subject, necessary_for_employment_social_security_or_social_protection_obligations_and_rights, necessary_for_contract_with_data_subject, necessary_for_specific_obligations_of_controller_under_other_laws, processed_fairly_transparently_and_lawfully, collected_for_specific_and_clear_purpose, later_processing_compatible_with_purpose, sufficient_and_limited_to_what_is_necessary, accurate_correct_and_updated, measures_taken_to_delete_or_correct_incorrect_data, kept_securely, not_kept_after_purpose_exhausted].
test(eligibility_valid_consent_is_eligible) :-
    labels_of(valid_consent_no_case, Labels),
    Labels == [eligible].
test(eligibility_a_case_is_eligible) :-
    labels_of(consent_refused_case_public_health, Labels),
    Labels == [eligible].
test(eligibility_no_basis_is_ineligible) :-
    labels_of(consent_fails_given, Labels),
    Labels == [ineligible].
test(eligibility_before_force_is_ineligible) :-
    labels_of(day_before_commencement, Labels),
    Labels == [ineligible].
test(eligibility_a_missing_date_is_indeterminate) :-
    labels_of(processing_date_unstated, Labels),
    Labels == [indeterminate].
test(eligibility_a_referral_is_indeterminate) :-
    labels_of(unsure_public_interest_before_true_case, Labels),
    Labels == [indeterminate].
test(eligibility_checklist_rows_all_cite) :-
    uae_pdpl_lawful_processing_and_consent_profile_for(valid_consent_no_case, Profile),
    uae_pdpl_lawful_processing_and_consent_eligibility(Profile, eligible, [item(overall, allowed_with_consent, _)|Rows]),
    length(Rows, 25),
    maplist(requirement_row_cites, Rows).
test(justification_failing_consent_row) :-
    uae_pdpl_lawful_processing_and_consent_profile_for(consent_fails_given, Profile),
    uae_pdpl_lawful_processing_and_consent_justification(Profile, consent_given, unmet(consent_not_given), [cite(uae_pdpl_art_1_consent), cite(uae_pdpl_art_6_1)]).
test(justification_holding_case_row) :-
    uae_pdpl_lawful_processing_and_consent_profile_for(consent_refused_case_public_health, Profile),
    uae_pdpl_lawful_processing_and_consent_justification(Profile, public_health, met, [cite(uae_pdpl_art_4), cite(uae_pdpl_art_4_5)]).
test(justification_failing_control_row) :-
    uae_pdpl_lawful_processing_and_consent_profile_for(control_fails_security, Profile),
    uae_pdpl_lawful_processing_and_consent_justification(Profile, kept_securely, unmet(control_6_kept_securely), [cite(uae_pdpl_art_5), cite(uae_pdpl_art_5_6)]).
test(justification_overall_row) :-
    uae_pdpl_lawful_processing_and_consent_profile_for(consent_fails_given, Profile),
    uae_pdpl_lawful_processing_and_consent_justification(Profile, overall, not_allowed, [cite(uae_pdpl_art_4)|_]).
test(what_if_withdrawal_leaves_no_basis) :-
    uae_pdpl_lawful_processing_and_consent_profile_for(valid_consent_no_case, Profile),
    findall(Status, uae_pdpl_lawful_processing_and_consent_what_if(Profile, consent_withdrawn_before_processing, true, Status), Statuses),
    Statuses == [not_allowed].
test(what_if_consent_given_restores_consent) :-
    uae_pdpl_lawful_processing_and_consent_profile_for(consent_fails_given, Profile),
    uae_pdpl_lawful_processing_and_consent_what_if(Profile, consent_given, true, allowed_with_consent).
test(what_if_moving_to_the_commencement_day) :-
    uae_pdpl_lawful_processing_and_consent_profile_for(day_before_commencement, Profile),
    uae_pdpl_lawful_processing_and_consent_what_if(Profile, processing_date, date(2022, 1, 2), allowed_with_consent).
test(what_if_a_wrong_value_is_an_input_problem) :-
    uae_pdpl_lawful_processing_and_consent_profile_for(valid_consent_no_case, Profile),
    uae_pdpl_lawful_processing_and_consent_what_if(Profile, consent_given, unsure, input_problems([wrong_type(consent_given)])).
test(recognisers_accept_their_atoms) :-
    allowed_without_consent(contract_with_data_subject),
    not_valid(consent_withdrawn),
    fails_control(control_6_kept_securely).

test(eligibility_no_basis_is_not_eligible, fail) :-
    uae_pdpl_lawful_processing_and_consent_profile_for(consent_fails_given, Profile),
    uae_pdpl_lawful_processing_and_consent_eligibility(Profile, eligible, _).
test(justification_failing_row_is_not_met, fail) :-
    uae_pdpl_lawful_processing_and_consent_profile_for(consent_fails_given, Profile),
    uae_pdpl_lawful_processing_and_consent_justification(Profile, consent_given, met, _).
test(what_if_withdrawal_is_not_allowed_with_consent, fail) :-
    uae_pdpl_lawful_processing_and_consent_profile_for(valid_consent_no_case, Profile),
    uae_pdpl_lawful_processing_and_consent_what_if(Profile, consent_withdrawn_before_processing, true, allowed_with_consent).
test(recognisers_refuse_a_foreign_atom, fail) :-
    not_valid(control_6_kept_securely).

cp_test_names([profile_keys_are_the_contract_keys, eligibility_valid_consent_is_eligible, eligibility_a_case_is_eligible, eligibility_no_basis_is_ineligible, eligibility_before_force_is_ineligible, eligibility_a_missing_date_is_indeterminate, eligibility_a_referral_is_indeterminate, eligibility_checklist_rows_all_cite, justification_failing_consent_row, justification_holding_case_row, justification_failing_control_row, justification_overall_row, what_if_withdrawal_leaves_no_basis, what_if_consent_given_restores_consent, what_if_moving_to_the_commencement_day, what_if_a_wrong_value_is_an_input_problem, recognisers_accept_their_atoms]).
cp_test_fail_names([eligibility_no_basis_is_not_eligible, justification_failing_row_is_not_met, what_if_withdrawal_is_not_allowed_with_consent, recognisers_refuse_a_foreign_atom]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
