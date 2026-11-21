% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_art6_lawful_basis_tests_test_input_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_art6_lawful_basis_gdpr_art6_lawful_basis, [lawful_basis_status/4, purpose_compatibility/4, gdpr_art6_lawful_basis_status/2, gdpr_art6_lawful_basis_status_values/1]).
:- use_module(m__eu_data_protection_gdpr_art6_lawful_basis_kernel, [gdpr_art6_lawful_basis_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_art6_lawful_basis_fixtures, [gdpr_art6_lawful_basis_profile_for/2]).

test(contract_holds_with_eligible_bound) :-
    gdpr_art6_lawful_basis_profile_for(claimed_contract_holds, Profile),
    lawful_basis_status(Profile, eligible, [], _).
test(consent_refused_with_ineligible_bound) :-
    gdpr_art6_lawful_basis_profile_for(claimed_consent_refused, Profile),
    member(attribute(consent_given_and_conditions_met, Statement), Profile),
    lawful_basis_status(Profile, ineligible, [outside_fact(consent_given_and_conditions_met, Statement)], _).
test(empty_profile_with_the_missing_key_bound) :-
    lawful_basis_status([], indeterminate([contract_necessary]), [], []).
test(absent_consent_statement_with_the_referral_bound) :-
    gdpr_art6_lawful_basis_profile_for(claimed_consent_statement_absent, Profile),
    lawful_basis_status(Profile, needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_6_1_a), cite(consent_basis_statement)), [resolution(cite(consent_basis_statement), not_attempted), inputs_relied_on([consent_given_and_conditions_met - absent])]), [], []).
test(absent_public_task_law_with_the_referral_bound) :-
    gdpr_art6_lawful_basis_profile_for(claimed_public_interest_task_law_absent, Profile),
    lawful_basis_status(Profile, needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_6_3), cite(public_interest_task_law_statement)), [resolution(cite(public_interest_task_law_statement), not_attempted), inputs_relied_on([public_interest_task_laid_down_by_law - absent])]), [], []).
test(unsure_contract_with_the_open_textured_reason_bound) :-
    gdpr_art6_lawful_basis_profile_for(only_unsure_contract_left, Profile),
    lawful_basis_status(Profile, needs_legal_review(open_textured(contract_necessary, cite(eu_reg_2016_679_art_6_1_b)), [inputs_relied_on(_)]), [], []).
test(purpose_compatible_bound) :-
    gdpr_art6_lawful_basis_profile_for(purpose_compatible, Profile),
    purpose_compatibility(Profile, purpose_compatible, [], [cite(eu_reg_2016_679_art_6_4)]).
test(purpose_not_engaged_bound) :-
    gdpr_art6_lawful_basis_profile_for(purpose_test_not_engaged, Profile),
    purpose_compatibility(Profile, compatibility_test_not_engaged, [], [cite(eu_reg_2016_679_art_6_4)]).
test(purpose_factor_left_out_with_not_ascertained_bound) :-
    gdpr_art6_lawful_basis_profile_for(purpose_factor_left_out, Profile),
    purpose_compatibility(Profile, compatibility_not_ascertained, [], _).
test(duplicate_key_bound) :-
    gdpr_art6_lawful_basis_profile_for(input_duplicate_key, Profile),
    gdpr_art6_lawful_basis_input_problems(Profile, [duplicate_key(contract_necessary)]).
test(attested_judgement_is_wrong_type) :-
    gdpr_art6_lawful_basis_profile_for(input_attested_judgement, Profile),
    gdpr_art6_lawful_basis_input_problems(Profile, [wrong_type(contract_necessary)]).
test(bare_outside_fact_is_wrong_type) :-
    gdpr_art6_lawful_basis_profile_for(input_bare_outside_fact, Profile),
    gdpr_art6_lawful_basis_input_problems(Profile, [wrong_type(consent_given_and_conditions_met)]).
test(unbound_attestation_argument_is_wrong_type) :-
    gdpr_art6_lawful_basis_profile_for(input_attestation_argument_unbound, Profile),
    gdpr_art6_lawful_basis_input_problems(Profile, [wrong_type(special_category)]).
test(number_key_is_unknown) :-
    gdpr_art6_lawful_basis_profile_for(input_unknown_number_key, Profile),
    gdpr_art6_lawful_basis_input_problems(Profile, [unknown_key(42)]).
test(partial_list_is_not_a_profile) :-
    gdpr_art6_lawful_basis_profile_for(input_partial_list, Profile),
    gdpr_art6_lawful_basis_input_problems(Profile, [wrong_type(profile)]).
test(an_atom_is_not_a_profile) :-
    gdpr_art6_lawful_basis_input_problems(profile, [wrong_type(profile)]).
test(a_list_with_a_bare_atom_is_not_a_profile) :-
    gdpr_art6_lawful_basis_input_problems([contract_necessary], [wrong_type(profile)]).
test(an_unbound_value_is_wrong_type) :-
    gdpr_art6_lawful_basis_input_problems([attribute(contract_necessary, _)], [wrong_type(contract_necessary)]).
test(an_unbound_key_is_unknown_as_given) :-
    gdpr_art6_lawful_basis_input_problems([attribute(GivenKey, true)], [unknown_key(NamedKey)]),
    NamedKey == GivenKey.
test(crisp_key_unsure_is_wrong_type) :-
    gdpr_art6_lawful_basis_input_problems([attribute(new_purpose_processing, unsure)], [wrong_type(new_purpose_processing)]).
test(unlisted_basis_is_wrong_type) :-
    gdpr_art6_lawful_basis_input_problems([attribute(basis_claimed, public_interest)], [wrong_type(basis_claimed)]).
test(unbound_profile_answers_input_problems) :-
    lawful_basis_status(_, input_problems([wrong_type(profile)]), [], []).
test(unbound_profile_answers_input_problems_for_purpose) :-
    purpose_compatibility(_, input_problems([wrong_type(profile)]), [], []).

test(contract_holds_with_ineligible_bound, fail) :-
    gdpr_art6_lawful_basis_profile_for(claimed_contract_holds, Profile),
    lawful_basis_status(Profile, ineligible, _, _).
test(every_other_bound_status_is_rejected, fail) :-
    gdpr_art6_lawful_basis_profile_for(claimed_contract_holds, Profile),
    gdpr_art6_lawful_basis_status_values(StatusValues),
    member(Other, StatusValues),
    dif(Other, eligible),
    gdpr_art6_lawful_basis_status(Profile, Other).
test(empty_profile_with_another_missing_key_bound, fail) :-
    lawful_basis_status([], indeterminate([vital_interests_necessary]), _, _).
test(purpose_factor_left_out_with_compatible_bound, fail) :-
    gdpr_art6_lawful_basis_profile_for(purpose_factor_left_out, Profile),
    purpose_compatibility(Profile, purpose_compatible, _, _).

cp_test_names([contract_holds_with_eligible_bound, consent_refused_with_ineligible_bound, empty_profile_with_the_missing_key_bound, absent_consent_statement_with_the_referral_bound, absent_public_task_law_with_the_referral_bound, unsure_contract_with_the_open_textured_reason_bound, purpose_compatible_bound, purpose_not_engaged_bound, purpose_factor_left_out_with_not_ascertained_bound, duplicate_key_bound, attested_judgement_is_wrong_type, bare_outside_fact_is_wrong_type, unbound_attestation_argument_is_wrong_type, number_key_is_unknown, partial_list_is_not_a_profile, an_atom_is_not_a_profile, a_list_with_a_bare_atom_is_not_a_profile, an_unbound_value_is_wrong_type, an_unbound_key_is_unknown_as_given, crisp_key_unsure_is_wrong_type, unlisted_basis_is_wrong_type, unbound_profile_answers_input_problems, unbound_profile_answers_input_problems_for_purpose]).
cp_test_fail_names([contract_holds_with_ineligible_bound, every_other_bound_status_is_rejected, empty_profile_with_another_missing_key_bound, purpose_factor_left_out_with_compatible_bound]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
