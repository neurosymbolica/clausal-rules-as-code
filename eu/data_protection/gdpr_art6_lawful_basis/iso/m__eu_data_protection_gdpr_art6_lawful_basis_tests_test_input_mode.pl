% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_art6_lawful_basis_tests_test_input_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_art6_lawful_basis_gdpr_art6_lawful_basis, [lawful_basis_status/4, purpose_compatibility/4, gdpr_art6_lawful_basis_status/2]).
:- use_module(m__eu_data_protection_gdpr_art6_lawful_basis_kernel, [gdpr_art6_lawful_basis_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_art6_lawful_basis_fixtures, [gdpr_art6_lawful_basis_profile_for/2]).

subject_profile(Subject, Profile) :-
    gdpr_art6_lawful_basis_profile_for(Subject, Profile).

test(eligible_bound_on_claimed_contract) :-
    subject_profile(contract_claimed_necessary, Profile),
    lawful_basis_status(Profile, eligible, [], Citations),
    sort(Citations, [cite(eu_reg_2016_679_art_6_1), cite(eu_reg_2016_679_art_6_1_b)]).
test(eligible_bound_with_the_copied_consent_statement) :-
    subject_profile(consent_claimed_attested_true, Profile),
    member(attribute(consent_given_and_conditions_met, Consent), Profile),
    lawful_basis_status(Profile, eligible, [outside_fact(consent_given_and_conditions_met, Consent)], _).
test(ineligible_bound_on_refused_consent) :-
    subject_profile(consent_claimed_attested_false, Profile),
    member(attribute(consent_given_and_conditions_met, Refused), Profile),
    lawful_basis_status(Profile, ineligible, [outside_fact(consent_given_and_conditions_met, Refused)], _).
test(indeterminate_bound_on_the_empty_profile) :-
    lawful_basis_status([], indeterminate([contract_necessary]), [], []).
test(consent_referral_bound) :-
    subject_profile(consent_statement_absent_for_last_open_way, Profile),
    lawful_basis_status(Profile, needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_6_1_a), cite(consent_basis_statement)), [resolution(cite(consent_basis_statement), not_attempted), inputs_relied_on([consent_given_and_conditions_met - absent])]), [], []).
test(open_textured_bound_on_the_legal_obligation) :-
    subject_profile(legal_obligation_unsure_law_statement_attested, Profile),
    member(attribute(legal_obligation_laid_down_by_law, LawStated), Profile),
    lawful_basis_status(Profile, needs_legal_review(open_textured(legal_obligation_necessary, cite(eu_reg_2016_679_art_6_1_c)), [inputs_relied_on([basis_claimed - legal_obligation, legal_obligation_necessary - unsure, legal_obligation_laid_down_by_law - LawStated])]), [], []).
test(input_problems_bound) :-
    lawful_basis_status([attribute(contract_necessary, maybe)], input_problems([wrong_type(contract_necessary)]), [], []).
test(status_projection_bound) :-
    subject_profile(vital_interests_claimed_necessary, Profile),
    gdpr_art6_lawful_basis_status(Profile, eligible).
test(compatibility_bound) :-
    subject_profile(new_purpose_compatible, Profile),
    purpose_compatibility(Profile, purpose_compatible, [], [cite(eu_reg_2016_679_art_6_4)]).
test(an_unbound_profile_is_not_an_attribute_list) :-
    findall(Problems, gdpr_art6_lawful_basis_input_problems(_UnboundProfile, Problems), Answers),
    Answers == [[wrong_type(profile)]].
test(an_unbound_profile_gets_one_status) :-
    findall(Result - Basis - Citations, lawful_basis_status(_UnboundProfile, Result, Basis, Citations), Answers),
    Answers == [input_problems([wrong_type(profile)]) - [] - []].
test(an_atom_is_not_an_attribute_list) :-
    gdpr_art6_lawful_basis_input_problems(not_a_list, [wrong_type(profile)]).
test(a_foreign_element_makes_the_profile_wrong) :-
    gdpr_art6_lawful_basis_input_problems([attribute(contract_necessary, true), contract_necessary], [wrong_type(profile)]).
test(a_number_element_makes_the_profile_wrong) :-
    gdpr_art6_lawful_basis_input_problems([attribute(contract_necessary, true), 42], [wrong_type(profile)]).
test(an_improper_list_is_refused) :-
    purpose_compatibility([attribute(contract_necessary, true)|not_a_list], input_problems([wrong_type(profile)]), [], []).
test(an_unbound_key_is_named_as_given) :-
    gdpr_art6_lawful_basis_input_problems([attribute(7, true)], Problems),
    Problems == [unknown_key(7)].
test(a_compound_key_is_unknown) :-
    gdpr_art6_lawful_basis_input_problems([attribute(contract(necessary), true)], [unknown_key(contract(necessary))]).
test(a_compound_value_is_a_wrong_type) :-
    gdpr_art6_lawful_basis_input_problems([attribute(contract_necessary, true(maybe))], [wrong_type(contract_necessary)]).
test(an_attestation_with_three_arguments_is_a_wrong_type) :-
    gdpr_art6_lawful_basis_input_problems([attribute(consent_given_and_conditions_met, attested(true, attestation(host_system, stated_by_host, none)))], [wrong_type(consent_given_and_conditions_met)]).
test(a_duplicate_with_equal_values_is_only_a_duplicate) :-
    gdpr_art6_lawful_basis_input_problems([attribute(contract_necessary, true), attribute(contract_necessary, true)], [duplicate_key(contract_necessary)]).
test(a_duplicate_with_bad_values_is_not_a_wrong_type) :-
    gdpr_art6_lawful_basis_input_problems([attribute(contract_necessary, maybe), attribute(contract_necessary, perhaps)], [duplicate_key(contract_necessary)]).
test(problems_come_in_contract_order_then_unknown_keys) :-
    gdpr_art6_lawful_basis_input_problems([attribute(favourite_colour, blue), attribute(compatible_purpose, maybe), attribute(basis_claimed, public_task)], [wrong_type(basis_claimed), wrong_type(compatible_purpose), unknown_key(favourite_colour)]).
test(an_evidence_url_is_accepted) :-
    gdpr_art6_lawful_basis_input_problems([attribute(special_category, attested(false, attestation(host_system, recorded_moment, stated_by_host, url(location, retrieved_moment))))], []).
test(an_evidence_document_is_accepted) :-
    gdpr_art6_lawful_basis_input_problems([attribute(child_data_subject, attested(true, attestation(host_system, recorded_moment, stated_by_host, document(upload_identifier, digest_value))))], []).
test(an_absent_key_is_never_a_problem) :-
    gdpr_art6_lawful_basis_input_problems([], []).

test(ineligible_bound_is_rejected_on_claimed_contract, fail) :-
    subject_profile(contract_claimed_necessary, Profile),
    lawful_basis_status(Profile, ineligible, _, _).
test(eligible_bound_with_an_empty_basis_is_rejected_on_consent, fail) :-
    subject_profile(consent_claimed_attested_true, Profile),
    lawful_basis_status(Profile, eligible, [], _).
test(another_missing_key_bound_is_rejected, fail) :-
    lawful_basis_status([], indeterminate([vital_interests_necessary]), _, _).
test(compatibility_other_answer_bound_is_rejected, fail) :-
    subject_profile(new_purpose_compatible, Profile),
    purpose_compatibility(Profile, purpose_not_compatible, _, _).

cp_test_names([eligible_bound_on_claimed_contract, eligible_bound_with_the_copied_consent_statement, ineligible_bound_on_refused_consent, indeterminate_bound_on_the_empty_profile, consent_referral_bound, open_textured_bound_on_the_legal_obligation, input_problems_bound, status_projection_bound, compatibility_bound, an_unbound_profile_is_not_an_attribute_list, an_unbound_profile_gets_one_status, an_atom_is_not_an_attribute_list, a_foreign_element_makes_the_profile_wrong, a_number_element_makes_the_profile_wrong, an_improper_list_is_refused, an_unbound_key_is_named_as_given, a_compound_key_is_unknown, a_compound_value_is_a_wrong_type, an_attestation_with_three_arguments_is_a_wrong_type, a_duplicate_with_equal_values_is_only_a_duplicate, a_duplicate_with_bad_values_is_not_a_wrong_type, problems_come_in_contract_order_then_unknown_keys, an_evidence_url_is_accepted, an_evidence_document_is_accepted, an_absent_key_is_never_a_problem]).
cp_test_fail_names([ineligible_bound_is_rejected_on_claimed_contract, eligible_bound_with_an_empty_basis_is_rejected_on_consent, another_missing_key_bound_is_rejected, compatibility_other_answer_bound_is_rejected]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
