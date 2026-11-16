% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_compensation_and_liability_tests_test_input_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_compensation_and_liability_gdpr_compensation_and_liability, [compensation_liability/4, gdpr_compensation_and_liability_status/2]).
:- use_module(m__eu_data_protection_gdpr_compensation_and_liability_kernel, [gdpr_compensation_and_liability_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_compensation_and_liability_fixtures, [gdpr_compensation_and_liability_profile_for/2]).

test(liable_holds_with_the_verdict_bound) :-
    gdpr_compensation_and_liability_profile_for(controller_liable, Profile),
    gdpr_compensation_and_liability_status(Profile, liable_for_damage).
test(exempt_holds_with_basis_and_citations_bound) :-
    gdpr_compensation_and_liability_profile_for(controller_exempt, Profile),
    compensation_liability(Profile, exempt_from_liability, [outside_fact(not_in_any_way_responsible_for_the_event, attested(true, attestation(host_operator, recorded_at, reason_given, url(evidence_address, retrieved_at))))], [cite(eu_reg_2016_679_art_82_2), cite(eu_reg_2016_679_art_82_3)]).
test(not_liable_holds_with_the_verdict_bound) :-
    gdpr_compensation_and_liability_profile_for(controller_not_involved, Profile),
    compensation_liability(Profile, not_liable_for_damage, [], [cite(eu_reg_2016_679_art_82_2)]).
test(right_not_established_holds_with_the_verdict_bound) :-
    gdpr_compensation_and_liability_profile_for(causation_false, Profile),
    compensation_liability(Profile, right_not_established, [], [cite(eu_reg_2016_679_art_82_1)]).
test(indeterminate_holds_with_the_key_bound) :-
    gdpr_compensation_and_liability_profile_for(role_absent, Profile),
    compensation_liability(Profile, indeterminate([party_role]), [], []).
test(a_referral_holds_with_the_reason_bound) :-
    gdpr_compensation_and_liability_profile_for(inside_unsure, Profile),
    compensation_liability(Profile, needs_legal_review(open_textured(damage_resulted_from_the_infringement, cite(eu_reg_2016_679_art_82_1)), _Context), [], []).
test(a_well_formed_profile_has_no_problem) :-
    gdpr_compensation_and_liability_profile_for(controller_liable, Profile),
    gdpr_compensation_and_liability_input_problems(Profile, []).
test(an_unsure_judgement_is_well_typed) :-
    gdpr_compensation_and_liability_input_problems([attribute(damage_suffered, unsure)], []).
test(an_unbound_profile_is_not_an_attribute_list) :-
    findall(Result, compensation_liability(_UnboundProfile, Result, _, _), Results),
    Results == [input_problems([wrong_type(profile)])].
test(a_partial_list_is_not_an_attribute_list) :-
    findall(Result, compensation_liability([attribute(damage_suffered, true)|_Tail], Result, _, _), Results),
    Results == [input_problems([wrong_type(profile)])].
test(a_pair_list_is_not_an_attribute_list) :-
    gdpr_compensation_and_liability_input_problems([damage_suffered - true], [wrong_type(profile)]).
test(a_number_key_is_an_unknown_key) :-
    gdpr_compensation_and_liability_input_problems([attribute(42, true)], [unknown_key(42)]).
test(a_compound_key_is_an_unknown_key) :-
    gdpr_compensation_and_liability_input_problems([attribute(colour(red), true)], [unknown_key(colour(red))]).
test(a_repeated_unknown_key_is_named_once) :-
    gdpr_compensation_and_liability_input_problems([attribute(colour, red), attribute(colour, blue)], [unknown_key(colour)]).
test(a_crisp_key_given_unsure_is_wrong_type) :-
    gdpr_compensation_and_liability_input_problems([attribute(involved_in_the_processing, unsure)], [wrong_type(involved_in_the_processing)]).
test(a_role_outside_the_enumeration_is_wrong_type) :-
    gdpr_compensation_and_liability_input_problems([attribute(party_role, data_subject)], [wrong_type(party_role)]).
test(a_bare_boolean_outside_fact_is_wrong_type) :-
    gdpr_compensation_and_liability_input_problems([attribute(not_in_any_way_responsible_for_the_event, true)], [wrong_type(not_in_any_way_responsible_for_the_event)]).
test(an_attestation_with_three_arguments_is_wrong_type) :-
    gdpr_compensation_and_liability_input_problems([attribute(not_in_any_way_responsible_for_the_event, attested(true, attestation(host_operator, recorded_at, none)))], [wrong_type(not_in_any_way_responsible_for_the_event)]).
test(an_attested_unsure_is_wrong_type) :-
    gdpr_compensation_and_liability_input_problems([attribute(not_in_any_way_responsible_for_the_event, attested(unsure, attestation(host_operator, recorded_at, reason_given, none)))], [wrong_type(not_in_any_way_responsible_for_the_event)]).
test(an_unbound_value_is_wrong_type) :-
    findall(Problems, gdpr_compensation_and_liability_input_problems([attribute(damage_suffered, _UnboundValue)], Problems), Answers),
    Answers == [[wrong_type(damage_suffered)]].
test(problems_come_in_contract_order_then_unknown_keys) :-
    gdpr_compensation_and_liability_input_problems([attribute(colour, red), attribute(damage_suffered, maybe), attribute(party_role, controller), attribute(party_role, processor)], Problems),
    Problems == [duplicate_key(party_role), wrong_type(damage_suffered), unknown_key(colour)].
test(a_duplicate_key_is_never_also_wrong_type) :-
    gdpr_compensation_and_liability_input_problems([attribute(damage_suffered, maybe), attribute(damage_suffered, never)], [duplicate_key(damage_suffered)]).
test(the_input_check_yields_exactly_one_solution) :-
    findall(Problems, gdpr_compensation_and_liability_input_problems([attribute(colour, red), attribute(damage_suffered, true)], Problems), Solutions),
    Solutions == [[unknown_key(colour)]].

test(the_wrong_bound_verdict_is_rejected, fail) :-
    gdpr_compensation_and_liability_profile_for(controller_liable, Profile),
    gdpr_compensation_and_liability_status(Profile, exempt_from_liability).
test(indeterminate_names_only_one_key, fail) :-
    gdpr_compensation_and_liability_profile_for(role_absent, Profile),
    compensation_liability(Profile, indeterminate([party_role, involved_in_the_processing]), [], []).
test(a_referral_cites_the_provision_not_the_judgement_key, fail) :-
    gdpr_compensation_and_liability_profile_for(inside_unsure, Profile),
    compensation_liability(Profile, needs_legal_review(open_textured(damage_resulted_from_the_infringement, cite(damage_resulted_from_the_infringement)), _Context), [], []).
test(an_input_problem_gives_no_final_answer, fail) :-
    gdpr_compensation_and_liability_profile_for(input_wrong_type_crisp_unsure, Profile),
    compensation_liability(Profile, right_not_established, _, _).

cp_test_names([liable_holds_with_the_verdict_bound, exempt_holds_with_basis_and_citations_bound, not_liable_holds_with_the_verdict_bound, right_not_established_holds_with_the_verdict_bound, indeterminate_holds_with_the_key_bound, a_referral_holds_with_the_reason_bound, a_well_formed_profile_has_no_problem, an_unsure_judgement_is_well_typed, an_unbound_profile_is_not_an_attribute_list, a_partial_list_is_not_an_attribute_list, a_pair_list_is_not_an_attribute_list, a_number_key_is_an_unknown_key, a_compound_key_is_an_unknown_key, a_repeated_unknown_key_is_named_once, a_crisp_key_given_unsure_is_wrong_type, a_role_outside_the_enumeration_is_wrong_type, a_bare_boolean_outside_fact_is_wrong_type, an_attestation_with_three_arguments_is_wrong_type, an_attested_unsure_is_wrong_type, an_unbound_value_is_wrong_type, problems_come_in_contract_order_then_unknown_keys, a_duplicate_key_is_never_also_wrong_type, the_input_check_yields_exactly_one_solution]).
cp_test_fail_names([the_wrong_bound_verdict_is_rejected, indeterminate_names_only_one_key, a_referral_cites_the_provision_not_the_judgement_key, an_input_problem_gives_no_final_answer]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
