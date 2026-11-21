% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_art6_lawful_basis_tests_test_queries, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_art6_lawful_basis_queries, [gdpr_art6_lawful_basis_profile_keys/1, gdpr_art6_lawful_basis_what_if/4, eligible/0, ineligible/0, purpose_compatible/0, purpose_not_compatible/0, compatibility_test_not_engaged/0, compatibility_not_ascertained/0]).
:- use_module(m__eu_data_protection_gdpr_art6_lawful_basis_kernel, [gdpr_art6_lawful_basis_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_art6_lawful_basis_kernel, [gdpr_art6_lawful_basis_root_keys/1]).
:- use_module(m__eu_data_protection_gdpr_art6_lawful_basis_fixtures, [gdpr_art6_lawful_basis_profile_for/2]).

test(profile_keys_are_the_contract_keys) :-
    gdpr_art6_lawful_basis_profile_keys(ProfileKeys),
    ProfileKeys == [basis_claimed, consent_given_and_conditions_met, contract_necessary, legal_obligation_necessary, legal_obligation_laid_down_by_law, vital_interests_necessary, public_interest_task_necessary, public_interest_task_laid_down_by_law, processing_by_public_authority_in_its_tasks, legitimate_interests_pursued, interests_overridden, child_data_subject, special_category, new_purpose_processing, compatible_purpose, link_between_purposes_taken_into_account, collection_context_taken_into_account, nature_of_data_taken_into_account, possible_consequences_taken_into_account, appropriate_safeguards_taken_into_account].
test(profile_keys_follow_the_root_order) :-
    gdpr_art6_lawful_basis_profile_keys(ProfileKeys),
    gdpr_art6_lawful_basis_root_keys(RootKeys),
    ProfileKeys == RootKeys.
test(input_check_is_reachable_from_the_query_layer) :-
    gdpr_art6_lawful_basis_input_problems([attribute(colour, blue)], [unknown_key(colour)]).
test(what_if_supplies_the_consent_statement) :-
    gdpr_art6_lawful_basis_profile_for(claimed_consent_statement_absent, Profile),
    gdpr_art6_lawful_basis_what_if(Profile, consent_given_and_conditions_met, attested(true, attestation(host_system, recorded_moment, stated_reason, none)), eligible).
test(what_if_supplies_the_law_statement) :-
    gdpr_art6_lawful_basis_profile_for(claimed_legal_obligation_law_refused, Profile),
    gdpr_art6_lawful_basis_what_if(Profile, legal_obligation_laid_down_by_law, attested(true, attestation(host_system, recorded_moment, stated_reason, none)), eligible).
test(what_if_the_balance_comes_out_for_the_controller) :-
    gdpr_art6_lawful_basis_profile_for(claimed_legitimate_interests_overridden, Profile),
    gdpr_art6_lawful_basis_what_if(Profile, interests_overridden, false, eligible).
test(what_if_the_balance_is_unsure) :-
    gdpr_art6_lawful_basis_profile_for(claimed_legitimate_interests_overridden, Profile),
    gdpr_art6_lawful_basis_what_if(Profile, interests_overridden, unsure, needs_legal_review(open_textured(interests_overridden, cite(eu_reg_2016_679_art_6_1_f)), _)).
test(what_if_the_claim_is_removed) :-
    gdpr_art6_lawful_basis_profile_for(claimed_contract_not_necessary, Profile),
    gdpr_art6_lawful_basis_what_if(Profile, basis_claimed, absent, indeterminate([vital_interests_necessary])).
test(what_if_a_wrong_value_reports_it) :-
    gdpr_art6_lawful_basis_what_if([], new_purpose_processing, unsure, input_problems([wrong_type(new_purpose_processing)])).
test(what_if_gives_exactly_one_solution) :-
    gdpr_art6_lawful_basis_profile_for(claimed_legitimate_interests_holds, Profile),
    findall(NewStatus, gdpr_art6_lawful_basis_what_if(Profile, processing_by_public_authority_in_its_tasks, true, NewStatus), Statuses),
    Statuses == [ineligible].
test(result_atoms_are_defined) :-
    eligible,
    ineligible,
    purpose_compatible,
    purpose_not_compatible,
    compatibility_test_not_engaged,
    compatibility_not_ascertained.

cp_test_names([profile_keys_are_the_contract_keys, profile_keys_follow_the_root_order, input_check_is_reachable_from_the_query_layer, what_if_supplies_the_consent_statement, what_if_supplies_the_law_statement, what_if_the_balance_comes_out_for_the_controller, what_if_the_balance_is_unsure, what_if_the_claim_is_removed, what_if_a_wrong_value_reports_it, what_if_gives_exactly_one_solution, result_atoms_are_defined]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
