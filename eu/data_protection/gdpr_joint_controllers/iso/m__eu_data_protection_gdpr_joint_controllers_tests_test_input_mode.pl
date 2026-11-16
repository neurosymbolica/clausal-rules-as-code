% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_joint_controllers_tests_test_input_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_joint_controllers_gdpr_joint_controllers, [gdpr_joint_controllers_status/2, rights_against_each_joint_controller/3, liability_for_the_entire_damage/4, recourse_after_full_compensation/4]).
:- use_module(m__eu_data_protection_gdpr_joint_controllers_kernel, [gdpr_joint_controllers_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_joint_controllers_fixtures, [gdpr_joint_controllers_profile_for/2]).

attested_statement(Truth, attested(Truth, attestation(registry_host, moment, stated_reason, none))).

test(entitled_fixture_is_eligible_bound) :-
    gdpr_joint_controllers_profile_for(joint_processor_entitled_to_claim_back, Profile),
    gdpr_joint_controllers_status(Profile, eligible).
test(partial_payment_is_ineligible_bound) :-
    gdpr_joint_controllers_profile_for(partial_payment_near_miss, Profile),
    gdpr_joint_controllers_status(Profile, ineligible).
test(payment_not_yet_stated_is_unresolved_bound) :-
    gdpr_joint_controllers_profile_for(payment_not_yet_stated, Profile),
    gdpr_joint_controllers_status(Profile, unresolved).
test(statement_absent_is_referred_bound) :-
    gdpr_joint_controllers_profile_for(statement_absent_referred, Profile),
    gdpr_joint_controllers_status(Profile, referred_for_legal_review).
test(malformed_statement_is_malformed_input_bound) :-
    gdpr_joint_controllers_profile_for(malformed_bare_statement, Profile),
    gdpr_joint_controllers_status(Profile, malformed_input).
test(rights_bound_exercisable) :-
    gdpr_joint_controllers_profile_for(joint_processor_entitled_to_claim_back, Profile),
    rights_against_each_joint_controller(Profile, rights_exercisable_against_this_controller, [cite(eu_reg_2016_679_art_26_3), cite(eu_reg_2016_679_art_28_10)]).
test(liability_bound_entire_damage) :-
    gdpr_joint_controllers_profile_for(joint_processor_entitled_to_claim_back, Profile),
    liability_for_the_entire_damage(Profile, liable_for_the_entire_damage, [outside_fact(responsible_under_article_82_2_and_3, _)], [cite(eu_reg_2016_679_art_82_4)]).
test(recourse_bound_parties_as_given) :-
    gdpr_joint_controllers_profile_for(joint_processor_entitled_to_claim_back, Profile),
    recourse_after_full_compensation(Profile, entitled_to_claim_back([controller_b, processor_c]), _, [cite(eu_reg_2016_679_art_82_5)]).
test(key_order_does_not_change_the_answer) :-
    attested_statement(true, Attested),
    findall(Result, recourse_after_full_compensation([attribute(full_compensation_paid, true), attribute(other_responsible_parties, [controller_b]), attribute(responsible_under_article_82_2_and_3, Attested), attribute(controllers_jointly_determine_purposes_and_means, false)], Result, _, _), Results),
    Results == [entitled_to_claim_back([controller_b])].
test(well_formed_profile_has_no_problem) :-
    gdpr_joint_controllers_profile_for(joint_processor_entitled_to_claim_back, Profile),
    gdpr_joint_controllers_input_problems(Profile, []).
test(empty_profile_has_no_problem) :-
    gdpr_joint_controllers_input_problems([], []).
test(empty_party_list_is_well_formed) :-
    gdpr_joint_controllers_input_problems([attribute(other_responsible_parties, [])], []).
test(repeated_party_is_well_formed) :-
    gdpr_joint_controllers_input_problems([attribute(other_responsible_parties, [controller_b, controller_b])], []).
test(unbound_profile_is_wrong_type) :-
    findall(Problems, gdpr_joint_controllers_input_problems(_, Problems), Answers),
    Answers == [[wrong_type(profile)]].
test(partial_list_profile_is_wrong_type) :-
    findall(Problems, gdpr_joint_controllers_input_problems([attribute(full_compensation_paid, true)|_], Problems), Answers),
    Answers == [[wrong_type(profile)]].
test(non_attribute_element_is_wrong_type) :-
    gdpr_joint_controllers_input_problems([attribute(full_compensation_paid, true), loose_element], Problems),
    Problems == [wrong_type(profile)].
test(atom_profile_is_wrong_type) :-
    gdpr_joint_controllers_input_problems(not_a_profile, Problems),
    Problems == [wrong_type(profile)].
test(unbound_value_is_wrong_type) :-
    findall(Problems, gdpr_joint_controllers_input_problems([attribute(full_compensation_paid, _)], Problems), Answers),
    Answers == [[wrong_type(full_compensation_paid)]].
test(number_key_is_unknown_as_given) :-
    gdpr_joint_controllers_input_problems([attribute(42, true)], Problems),
    Problems == [unknown_key(42)].
test(number_judgement_is_wrong_type) :-
    gdpr_joint_controllers_input_problems([attribute(controllers_jointly_determine_purposes_and_means, 1)], Problems),
    Problems == [wrong_type(controllers_jointly_determine_purposes_and_means)].
test(attested_judgement_is_wrong_type) :-
    attested_statement(true, Attested),
    gdpr_joint_controllers_input_problems([attribute(full_compensation_paid, Attested)], Problems),
    Problems == [wrong_type(full_compensation_paid)].
test(bare_unsure_statement_is_wrong_type) :-
    gdpr_joint_controllers_input_problems([attribute(responsible_under_article_82_2_and_3, unsure)], Problems),
    Problems == [wrong_type(responsible_under_article_82_2_and_3)].
test(nested_list_party_is_wrong_type) :-
    gdpr_joint_controllers_input_problems([attribute(other_responsible_parties, [[controller_b]])], Problems),
    Problems == [wrong_type(other_responsible_parties)].
test(non_list_parties_is_wrong_type) :-
    gdpr_joint_controllers_input_problems([attribute(other_responsible_parties, controller_b)], Problems),
    Problems == [wrong_type(other_responsible_parties)].
test(problems_in_contract_order_then_unknown) :-
    gdpr_joint_controllers_input_problems([attribute(extra_key, x), attribute(full_compensation_paid, maybe), attribute(controllers_jointly_determine_purposes_and_means, yes), attribute(extra_key, y)], Problems),
    Problems == [wrong_type(controllers_jointly_determine_purposes_and_means), wrong_type(full_compensation_paid), unknown_key(extra_key)].
test(duplicate_key_is_never_also_wrong_type) :-
    gdpr_joint_controllers_input_problems([attribute(full_compensation_paid, maybe), attribute(full_compensation_paid, true)], Problems),
    Problems == [duplicate_key(full_compensation_paid)].

test(entitled_fixture_is_not_ineligible_bound, fail) :-
    gdpr_joint_controllers_profile_for(joint_processor_entitled_to_claim_back, Profile),
    gdpr_joint_controllers_status(Profile, ineligible).
test(partial_payment_is_not_eligible_bound, fail) :-
    gdpr_joint_controllers_profile_for(partial_payment_near_miss, Profile),
    gdpr_joint_controllers_status(Profile, eligible).
test(statement_absent_is_not_unresolved_bound, fail) :-
    gdpr_joint_controllers_profile_for(statement_absent_referred, Profile),
    gdpr_joint_controllers_status(Profile, unresolved).
test(rights_bound_not_joint_controllers_rejected, fail) :-
    gdpr_joint_controllers_profile_for(joint_processor_entitled_to_claim_back, Profile),
    rights_against_each_joint_controller(Profile, not_joint_controllers, _).
test(recourse_bound_reordered_parties_rejected, fail) :-
    gdpr_joint_controllers_profile_for(joint_processor_entitled_to_claim_back, Profile),
    recourse_after_full_compensation(Profile, entitled_to_claim_back([processor_c, controller_b]), _, _).

cp_test_names([entitled_fixture_is_eligible_bound, partial_payment_is_ineligible_bound, payment_not_yet_stated_is_unresolved_bound, statement_absent_is_referred_bound, malformed_statement_is_malformed_input_bound, rights_bound_exercisable, liability_bound_entire_damage, recourse_bound_parties_as_given, key_order_does_not_change_the_answer, well_formed_profile_has_no_problem, empty_profile_has_no_problem, empty_party_list_is_well_formed, repeated_party_is_well_formed, unbound_profile_is_wrong_type, partial_list_profile_is_wrong_type, non_attribute_element_is_wrong_type, atom_profile_is_wrong_type, unbound_value_is_wrong_type, number_key_is_unknown_as_given, number_judgement_is_wrong_type, attested_judgement_is_wrong_type, bare_unsure_statement_is_wrong_type, nested_list_party_is_wrong_type, non_list_parties_is_wrong_type, problems_in_contract_order_then_unknown, duplicate_key_is_never_also_wrong_type]).
cp_test_fail_names([entitled_fixture_is_not_ineligible_bound, partial_payment_is_not_eligible_bound, statement_absent_is_not_unresolved_bound, rights_bound_not_joint_controllers_rejected, recourse_bound_reordered_parties_rejected]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
