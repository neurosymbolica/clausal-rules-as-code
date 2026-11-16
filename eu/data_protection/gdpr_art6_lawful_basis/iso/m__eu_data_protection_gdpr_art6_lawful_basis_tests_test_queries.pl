% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_art6_lawful_basis_tests_test_queries, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_art6_lawful_basis_queries, [gdpr_art6_lawful_basis_profile_keys/1, gdpr_art6_lawful_basis_what_if/4, eligible/0, ineligible/0, purpose_compatible/0, purpose_not_compatible/0, compatibility_test_not_engaged/0]).
:- use_module(m__eu_data_protection_gdpr_art6_lawful_basis_kernel, [gdpr_art6_lawful_basis_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_art6_lawful_basis_fixtures, [gdpr_art6_lawful_basis_profile_for/2]).

test(profile_keys_are_the_contract_keys) :-
    gdpr_art6_lawful_basis_profile_keys(ProfileKeys),
    ProfileKeys == [basis_claimed, consent_given_and_conditions_met, contract_necessary, legal_obligation_necessary, legal_obligation_laid_down_by_law, vital_interests_necessary, public_interest_task_necessary, public_interest_task_laid_down_by_law, processing_by_public_authority_in_its_tasks, legitimate_interests_pursued, interests_overridden, child_data_subject, special_category, new_purpose_processing, compatible_purpose].
test(the_re_exported_input_check_answers) :-
    gdpr_art6_lawful_basis_input_problems([attribute(favourite_colour, blue)], [unknown_key(favourite_colour)]).
test(what_if_supplies_the_asked_key) :-
    gdpr_art6_lawful_basis_profile_for(empty_profile, Profile),
    findall(Status, gdpr_art6_lawful_basis_what_if(Profile, contract_necessary, true, Status), Answers),
    Answers == [eligible].
test(what_if_stating_the_public_authority_key_reaches_a_lawyer) :-
    gdpr_art6_lawful_basis_profile_for(public_authority_question_missing_beside_unsure, Profile),
    gdpr_art6_lawful_basis_what_if(Profile, processing_by_public_authority_in_its_tasks, true, needs_legal_review(open_textured(public_interest_task_necessary, cite(eu_reg_2016_679_art_6_1_e)), _)).
test(what_if_balance_for_the_controller_is_eligible) :-
    gdpr_art6_lawful_basis_profile_for(legitimate_interests_balance_unsure, Profile),
    gdpr_art6_lawful_basis_what_if(Profile, interests_overridden, false, eligible).
test(what_if_balance_against_the_controller_is_ineligible) :-
    gdpr_art6_lawful_basis_profile_for(legitimate_interests_balance_unsure, Profile),
    gdpr_art6_lawful_basis_what_if(Profile, interests_overridden, true, ineligible).
test(what_if_withdrawing_a_duplicate_clears_the_problem) :-
    gdpr_art6_lawful_basis_profile_for(duplicate_contract_key, Profile),
    gdpr_art6_lawful_basis_what_if(Profile, contract_necessary, false, indeterminate([vital_interests_necessary])).
test(what_if_a_bad_value_is_an_input_problem) :-
    gdpr_art6_lawful_basis_what_if([], contract_necessary, maybe, input_problems([wrong_type(contract_necessary)])).
test(result_atoms_are_served) :-
    eligible,
    ineligible,
    purpose_compatible,
    purpose_not_compatible,
    compatibility_test_not_engaged.
test(result_constructors_build_and_destructure) :-
    Referral = needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_6_3), cite(legal_obligation_law_statement)), [resolution(cite(legal_obligation_law_statement), not_attempted), inputs_relied_on([legal_obligation_laid_down_by_law - absent])]),
    Referral = needs_legal_review(cross_reference_unresolved(Citation, Target), [resolution(Resolved, Status), inputs_relied_on(Pairs)]),
    Citation == cite(eu_reg_2016_679_art_6_3),
    Target == cite(legal_obligation_law_statement),
    Resolved == Target,
    Status == not_attempted,
    Pairs == [legal_obligation_laid_down_by_law - absent],
    Basis = [outside_fact(consent_given_and_conditions_met, attested(true, attestation(host_system, recorded_moment, stated_by_host, none)))],
    Basis = [outside_fact(FactKey, attested(AttestedValue, attestation(_, _, _, Evidence)))],
    FactKey == consent_given_and_conditions_met,
    AttestedValue == true,
    Evidence == none,
    Problems = input_problems([duplicate_key(contract_necessary), wrong_type(basis_claimed), unknown_key(favourite_colour)]),
    Problems = input_problems([duplicate_key(DuplicateKey), wrong_type(WrongKey), unknown_key(UnknownKey)]),
    DuplicateKey == contract_necessary,
    WrongKey == basis_claimed,
    UnknownKey == favourite_colour.

test(what_if_balance_against_the_controller_is_not_eligible, fail) :-
    gdpr_art6_lawful_basis_profile_for(legitimate_interests_balance_unsure, Profile),
    gdpr_art6_lawful_basis_what_if(Profile, interests_overridden, true, eligible).
test(what_if_a_bad_value_is_not_eligible, fail) :-
    gdpr_art6_lawful_basis_what_if([], contract_necessary, maybe, eligible).

cp_test_names([profile_keys_are_the_contract_keys, the_re_exported_input_check_answers, what_if_supplies_the_asked_key, what_if_stating_the_public_authority_key_reaches_a_lawyer, what_if_balance_for_the_controller_is_eligible, what_if_balance_against_the_controller_is_ineligible, what_if_withdrawing_a_duplicate_clears_the_problem, what_if_a_bad_value_is_an_input_problem, result_atoms_are_served, result_constructors_build_and_destructure]).
cp_test_fail_names([what_if_balance_against_the_controller_is_not_eligible, what_if_a_bad_value_is_not_eligible]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
