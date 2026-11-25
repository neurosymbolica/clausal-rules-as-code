% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_information_sharing_arrangements_tests_test_queries, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_dora_information_sharing_arrangements_queries, [dora_information_sharing_arrangements_profile_keys/1, dora_information_sharing_arrangements_what_if/4]).
:- use_module(m__eu_dora_information_sharing_arrangements_kernel, [dora_information_sharing_arrangements_input_problems/2]).
:- use_module(m__eu_dora_information_sharing_arrangements_dora_information_sharing_arrangements, [dora_information_sharing_arrangements_status/2, dora_information_sharing_arrangements_checklist/2]).
:- use_module(m__eu_dora_information_sharing_arrangements_fixtures, [dora_information_sharing_arrangements_profile_for/2]).

test(profile_keys_are_the_contract_keys) :-
    dora_information_sharing_arrangements_profile_keys(ProfileKeys),
    ProfileKeys == [information_is_cyber_threat_information_and_intelligence, sharing_aims_to_enhance_digital_operational_resilience, sharing_takes_place_within_trusted_community_of_financial_entities, arrangement_protects_sensitive_information_and_has_rules_of_conduct, arrangement_defines_participation_conditions_and_appropriate_details, membership_event, arrangement_is_information_sharing_arrangement_referred_to_in_article_45_1].
test(eligibility_status_is_one_atom) :-
    dora_information_sharing_arrangements_profile_for(all_conditions_met, Profile),
    findall(Status, dora_information_sharing_arrangements_status(Profile, Status), Statuses),
    Statuses == [sharing_within_article_45].
test(justification_checklist_cites_each_item) :-
    dora_information_sharing_arrangements_profile_for(paragraph_2_false, Profile),
    dora_information_sharing_arrangements_checklist(Profile, Items),
    length(Items, 5),
    member(item(arrangement_defines_participation_conditions_and_appropriate_details, unmet(judged_false), cite(eu_reg_2022_2554_art_45_2)), Items).
test(what_if_one_condition_false_flips_to_outside) :-
    dora_information_sharing_arrangements_profile_for(all_conditions_met, Profile),
    dora_information_sharing_arrangements_what_if(Profile, sharing_takes_place_within_trusted_community_of_financial_entities, false, NewStatus),
    NewStatus == sharing_outside_article_45.
test(what_if_restoring_the_condition_flips_back_to_within) :-
    dora_information_sharing_arrangements_profile_for(paragraph_2_false, Profile),
    dora_information_sharing_arrangements_what_if(Profile, arrangement_defines_participation_conditions_and_appropriate_details, true, NewStatus),
    NewStatus == sharing_within_article_45.
test(what_if_unsure_is_referred_not_decided) :-
    dora_information_sharing_arrangements_profile_for(all_conditions_met, Profile),
    dora_information_sharing_arrangements_what_if(Profile, information_is_cyber_threat_information_and_intelligence, unsure, NewStatus),
    NewStatus = needs_legal_review(open_textured(information_is_cyber_threat_information_and_intelligence, cite(eu_reg_2022_2554_art_45_1)), _Context).
test(input_problems_reexport_matches_the_kernel_check) :-
    dora_information_sharing_arrangements_input_problems([attribute(entity_size, large)], [unknown_key(entity_size)]),
    dora_information_sharing_arrangements_input_problems([], []).

cp_test_names([profile_keys_are_the_contract_keys, eligibility_status_is_one_atom, justification_checklist_cites_each_item, what_if_one_condition_false_flips_to_outside, what_if_restoring_the_condition_flips_back_to_within, what_if_unsure_is_referred_not_decided, input_problems_reexport_matches_the_kernel_check]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
