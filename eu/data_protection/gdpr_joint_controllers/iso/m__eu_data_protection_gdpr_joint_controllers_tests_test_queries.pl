% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_joint_controllers_tests_test_queries, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_joint_controllers_queries, [gdpr_joint_controllers_profile_keys/1, gdpr_joint_controllers_what_if/4]).
:- use_module(m__eu_data_protection_gdpr_joint_controllers_kernel, [gdpr_joint_controllers_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_joint_controllers_gdpr_joint_controllers, [gdpr_joint_controllers_status/2, gdpr_joint_controllers_checklist/2]).
:- use_module(m__eu_data_protection_gdpr_joint_controllers_fixtures, [gdpr_joint_controllers_profile_for/2]).

test(profile_keys_are_the_contract_keys) :-
    gdpr_joint_controllers_profile_keys(ProfileKeys),
    ProfileKeys == [controllers_jointly_determine_purposes_and_means, responsible_under_article_82_2_and_3, other_responsible_parties, full_compensation_paid].
test(the_reexported_input_check_accepts_the_fixture) :-
    gdpr_joint_controllers_profile_for(claim_back_after_full_payment, Profile),
    gdpr_joint_controllers_input_problems(Profile, []).
test(the_reexported_input_check_names_an_unknown_key) :-
    gdpr_joint_controllers_profile_for(arrangement_key_supplied, Profile),
    gdpr_joint_controllers_input_problems(Profile, [unknown_key(arrangement_terms)]).
test(eligibility_verdict_for_a_full_payment) :-
    gdpr_joint_controllers_profile_for(claim_back_after_full_payment, Profile),
    findall(Status, gdpr_joint_controllers_status(Profile, Status), Statuses),
    Statuses == [eligible].
test(justification_items_each_carry_a_citation) :-
    gdpr_joint_controllers_profile_for(claim_back_after_partial_payment, Profile),
    gdpr_joint_controllers_checklist(Profile, Items),
    Items == [item(responsible_under_article_82, met, cite(eu_reg_2016_679_art_82_4)), item(other_responsible_party_listed, met, cite(eu_reg_2016_679_art_82_4)), item(full_compensation_paid, unmet(full_compensation_not_paid), cite(eu_reg_2016_679_art_82_5))].
test(justification_is_empty_for_a_malformed_profile) :-
    gdpr_joint_controllers_profile_for(duplicate_payment_key, Profile),
    gdpr_joint_controllers_checklist(Profile, []).
test(what_if_a_full_payment_flips_a_partial_payment_to_eligible) :-
    gdpr_joint_controllers_profile_for(claim_back_after_partial_payment, Profile),
    gdpr_joint_controllers_what_if(Profile, full_compensation_paid, true, eligible).
test(what_if_an_unsure_payment_goes_back_to_indeterminate) :-
    gdpr_joint_controllers_profile_for(claim_back_after_full_payment, Profile),
    gdpr_joint_controllers_what_if(Profile, full_compensation_paid, unsure, indeterminate).
test(what_if_a_supplied_statement_resolves_the_referral) :-
    gdpr_joint_controllers_profile_for(responsibility_statement_absent, Profile),
    gdpr_joint_controllers_what_if(Profile, responsible_under_article_82_2_and_3, attested(true, attestation(host_service, attested_moment, stated_reason, none)), eligible).
test(what_if_an_override_clears_a_duplicate_key) :-
    gdpr_joint_controllers_profile_for(duplicate_payment_key, Profile),
    gdpr_joint_controllers_what_if(Profile, full_compensation_paid, true, eligible).
test(what_if_an_empty_list_leaves_no_claim_back) :-
    gdpr_joint_controllers_profile_for(claim_back_after_full_payment, Profile),
    gdpr_joint_controllers_what_if(Profile, other_responsible_parties, [], ineligible).
test(what_if_an_unknown_key_is_indeterminate) :-
    gdpr_joint_controllers_profile_for(claim_back_after_full_payment, Profile),
    gdpr_joint_controllers_what_if(Profile, arrangement_terms, allocated, indeterminate).
test(what_if_yields_exactly_one_status) :-
    gdpr_joint_controllers_profile_for(claim_back_after_partial_payment, Profile),
    findall(Status, gdpr_joint_controllers_what_if(Profile, full_compensation_paid, true, Status), Statuses),
    Statuses == [eligible].

test(what_if_a_full_payment_is_not_ineligible, fail) :-
    gdpr_joint_controllers_profile_for(claim_back_after_partial_payment, Profile),
    gdpr_joint_controllers_what_if(Profile, full_compensation_paid, true, ineligible).

cp_test_names([profile_keys_are_the_contract_keys, the_reexported_input_check_accepts_the_fixture, the_reexported_input_check_names_an_unknown_key, eligibility_verdict_for_a_full_payment, justification_items_each_carry_a_citation, justification_is_empty_for_a_malformed_profile, what_if_a_full_payment_flips_a_partial_payment_to_eligible, what_if_an_unsure_payment_goes_back_to_indeterminate, what_if_a_supplied_statement_resolves_the_referral, what_if_an_override_clears_a_duplicate_key, what_if_an_empty_list_leaves_no_claim_back, what_if_an_unknown_key_is_indeterminate, what_if_yields_exactly_one_status]).
cp_test_fail_names([what_if_a_full_payment_is_not_ineligible]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
