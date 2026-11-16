% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_joint_controllers_tests_test_queries, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_joint_controllers_queries, [gdpr_joint_controllers_profile_keys/1, gdpr_joint_controllers_what_if/4, controllers_jointly_determine_purposes_and_means/0, responsible_under_article_82_2_and_3/0, other_responsible_parties/0, full_compensation_paid/0, unsure/0, absent/0, not_attempted/0]).
:- use_module(m__eu_data_protection_gdpr_joint_controllers_kernel, [gdpr_joint_controllers_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_joint_controllers_gdpr_joint_controllers, [gdpr_joint_controllers_status/2, gdpr_joint_controllers_checklist/2]).
:- use_module(m__eu_data_protection_gdpr_joint_controllers_fixtures, [gdpr_joint_controllers_profile_for/2]).

item_cited(item(_, _, cite(_))).

test(profile_keys_are_the_contract_keys) :-
    gdpr_joint_controllers_profile_keys(ProfileKeys),
    ProfileKeys == [controllers_jointly_determine_purposes_and_means, responsible_under_article_82_2_and_3, other_responsible_parties, full_compensation_paid].
test(root_atoms_are_served) :-
    controllers_jointly_determine_purposes_and_means,
    responsible_under_article_82_2_and_3,
    other_responsible_parties,
    full_compensation_paid,
    unsure,
    absent,
    not_attempted.
test(input_check_reexport_accepts_a_good_profile) :-
    gdpr_joint_controllers_profile_for(joint_processor_entitled_to_claim_back, Profile),
    gdpr_joint_controllers_input_problems(Profile, []).
test(input_check_reexport_rejects_a_non_list) :-
    gdpr_joint_controllers_input_problems(not_a_profile, Problems),
    Problems == [wrong_type(profile)].
test(eligibility_status_for_the_entitled_fixture) :-
    gdpr_joint_controllers_profile_for(joint_processor_entitled_to_claim_back, Profile),
    findall(Status, gdpr_joint_controllers_status(Profile, Status), Statuses),
    Statuses == [eligible].
test(justification_every_row_is_cited) :-
    gdpr_joint_controllers_profile_for(sole_responsible_party_near_miss, Profile),
    gdpr_joint_controllers_checklist(Profile, Items),
    Items = [_|_],
    maplist(item_cited, Items).
test(justification_names_the_unmet_condition) :-
    gdpr_joint_controllers_profile_for(sole_responsible_party_near_miss, Profile),
    gdpr_joint_controllers_checklist(Profile, Items),
    member(item(other_responsible_party_listed, unmet(no_other_responsible_party), cite(eu_reg_2016_679_art_82_4)), Items).
test(what_if_full_payment_makes_the_claim_back_eligible) :-
    gdpr_joint_controllers_profile_for(partial_payment_near_miss, Profile),
    findall(Status, gdpr_joint_controllers_what_if(Profile, full_compensation_paid, true, Status), Statuses),
    Statuses == [eligible].
test(what_if_partial_payment_makes_it_ineligible) :-
    gdpr_joint_controllers_profile_for(joint_processor_entitled_to_claim_back, Profile),
    gdpr_joint_controllers_what_if(Profile, full_compensation_paid, false, ineligible).
test(what_if_unsure_payment_is_referred) :-
    gdpr_joint_controllers_profile_for(joint_processor_entitled_to_claim_back, Profile),
    gdpr_joint_controllers_what_if(Profile, full_compensation_paid, unsure, referred_for_legal_review).
test(what_if_empty_list_makes_it_ineligible) :-
    gdpr_joint_controllers_profile_for(joint_processor_entitled_to_claim_back, Profile),
    gdpr_joint_controllers_what_if(Profile, other_responsible_parties, [], ineligible).
test(what_if_leaves_the_original_profile_alone) :-
    gdpr_joint_controllers_profile_for(partial_payment_near_miss, Profile),
    gdpr_joint_controllers_what_if(Profile, full_compensation_paid, true, eligible),
    gdpr_joint_controllers_status(Profile, ineligible).

test(what_if_full_payment_is_not_ineligible, fail) :-
    gdpr_joint_controllers_profile_for(partial_payment_near_miss, Profile),
    gdpr_joint_controllers_what_if(Profile, full_compensation_paid, true, ineligible).

cp_test_names([profile_keys_are_the_contract_keys, root_atoms_are_served, input_check_reexport_accepts_a_good_profile, input_check_reexport_rejects_a_non_list, eligibility_status_for_the_entitled_fixture, justification_every_row_is_cited, justification_names_the_unmet_condition, what_if_full_payment_makes_the_claim_back_eligible, what_if_partial_payment_makes_it_ineligible, what_if_unsure_payment_is_referred, what_if_empty_list_makes_it_ineligible, what_if_leaves_the_original_profile_alone]).
cp_test_fail_names([what_if_full_payment_is_not_ineligible]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
