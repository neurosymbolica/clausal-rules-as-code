% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_compensation_and_liability_tests_test_input_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_compensation_and_liability_gdpr_compensation_and_liability, [compensation_liability/4, gdpr_compensation_and_liability_status/2]).
:- use_module(m__eu_data_protection_gdpr_compensation_and_liability_kernel, [gdpr_compensation_and_liability_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_compensation_and_liability_fixtures, [gdpr_compensation_and_liability_profile_for/2]).

test(the_baseline_holds_with_liable_bound) :-
    gdpr_compensation_and_liability_profile_for(todo_baseline_subject, Profile),
    gdpr_compensation_and_liability_status(Profile, liable_for_damage).
test(the_full_liable_answer_holds_bound) :-
    gdpr_compensation_and_liability_profile_for(liable_controller, Profile),
    compensation_liability(Profile, liable_for_damage, [outside_fact(not_in_any_way_responsible_for_the_event, attested(false, attestation(host, at, reason, none)))], [cite(eu_reg_2016_679_art_82_1), cite(eu_reg_2016_679_art_82_2), cite(eu_reg_2016_679_art_82_3)]).
test(the_full_exempt_answer_holds_bound) :-
    gdpr_compensation_and_liability_profile_for(exempt_controller, Profile),
    compensation_liability(Profile, exempt_from_liability, [outside_fact(not_in_any_way_responsible_for_the_event, attested(true, attestation(host, at, reason, document(upload_identifier, checksum))))], [cite(eu_reg_2016_679_art_82_2), cite(eu_reg_2016_679_art_82_3)]).
test(the_not_liable_answer_holds_bound) :-
    gdpr_compensation_and_liability_profile_for(not_liable_processor, Profile),
    compensation_liability(Profile, not_liable_for_damage, [], [cite(eu_reg_2016_679_art_82_2)]).
test(the_right_not_established_answer_holds_bound) :-
    gdpr_compensation_and_liability_profile_for(right_not_established_no_damage, Profile),
    compensation_liability(Profile, right_not_established, [], [cite(eu_reg_2016_679_art_82_1)]).
test(the_judgement_indeterminate_holds_bound) :-
    gdpr_compensation_and_liability_profile_for(indeterminate_judgement_absent, Profile),
    compensation_liability(Profile, indeterminate([damage_resulted_from_the_infringement]), [], []).
test(the_role_indeterminate_holds_bound) :-
    gdpr_compensation_and_liability_profile_for(indeterminate_role_absent, Profile),
    compensation_liability(Profile, indeterminate([party_role]), [], []).
test(the_outside_referral_holds_bound) :-
    gdpr_compensation_and_liability_profile_for(referred_outside_unsure, Profile),
    compensation_liability(Profile, needs_legal_review(open_textured(infringement_of_the_regulation_occurred, cite(eu_reg_2016_679_art_82_1)), [inputs_relied_on([damage_suffered - true, infringement_of_the_regulation_occurred - unsure, damage_resulted_from_the_infringement - true])]), [], []).
test(the_cross_reference_referral_holds_bound) :-
    gdpr_compensation_and_liability_profile_for(referred_statement_absent, Profile),
    compensation_liability(Profile, needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_82_3), cite(non_responsibility_statement)), [resolution(cite(non_responsibility_statement), not_attempted), inputs_relied_on([damage_suffered - true, infringement_of_the_regulation_occurred - true, damage_resulted_from_the_infringement - true, not_in_any_way_responsible_for_the_event - absent])]), [], []).
test(the_inside_referral_holds_bound) :-
    gdpr_compensation_and_liability_profile_for(referred_inside_unsure, Profile),
    compensation_liability(Profile, needs_legal_review(open_textured(damage_suffered, cite(eu_reg_2016_679_art_82_1)), [inputs_relied_on([damage_suffered - unsure, infringement_of_the_regulation_occurred - true, damage_resulted_from_the_infringement - true])]), [], []).
test(the_input_problem_holds_bound) :-
    gdpr_compensation_and_liability_profile_for(input_problem_wrong_type, Profile),
    compensation_liability(Profile, input_problems([wrong_type(involved_in_the_processing)]), [], []).
test(an_unbound_profile_is_not_an_attribute_list) :-
    gdpr_compensation_and_liability_input_problems('$VAR'(0), Problems),
    Problems == [wrong_type(profile)].
test(an_unbound_profile_gets_the_input_problem_answer) :-
    compensation_liability('$VAR'(0), Result, Basis, Citations),
    Result == input_problems([wrong_type(profile)]),
    Basis == [],
    Citations == [].
test(a_partial_list_is_not_an_attribute_list) :-
    gdpr_compensation_and_liability_input_problems([attribute(damage_suffered, true)|'$VAR'(0)], Problems),
    Problems == [wrong_type(profile)].
test(a_list_holding_an_unbound_element_is_not_an_attribute_list) :-
    gdpr_compensation_and_liability_input_problems([attribute(damage_suffered, true), '$VAR'(0)], Problems),
    Problems == [wrong_type(profile)].
test(a_list_holding_a_bare_atom_is_refused_alone) :-
    gdpr_compensation_and_liability_input_problems([attribute(colour, blue), colour], [wrong_type(profile)]).
test(a_compound_term_is_not_a_profile) :-
    findall(Problems, gdpr_compensation_and_liability_input_problems(profile(damage_suffered), Problems), Solutions),
    Solutions == [[wrong_type(profile)]].
test(a_number_key_is_unknown) :-
    gdpr_compensation_and_liability_input_problems([attribute(42, true)], [unknown_key(42)]).
test(a_compound_key_is_unknown_as_given) :-
    gdpr_compensation_and_liability_input_problems([attribute(key(damage_suffered), true)], [unknown_key(key(damage_suffered))]).
test(an_unbound_key_is_unknown_as_given) :-
    gdpr_compensation_and_liability_input_problems([attribute('$VAR'(0), true)], Problems),
    Problems == [unknown_key('$VAR'(0))].
test(an_unbound_value_is_a_wrong_type) :-
    gdpr_compensation_and_liability_input_problems([attribute(damage_suffered, '$VAR'(0))], Problems),
    Problems == [wrong_type(damage_suffered)].
test(a_repeated_unknown_key_is_named_once) :-
    gdpr_compensation_and_liability_input_problems([attribute(colour, blue), attribute(colour, red)], [unknown_key(colour)]).
test(a_duplicate_with_different_values_is_a_duplicate_only) :-
    gdpr_compensation_and_liability_input_problems([attribute(party_role, controller), attribute(party_role, admin)], [duplicate_key(party_role)]).
test(problems_come_in_contract_order_then_unknown_keys) :-
    gdpr_compensation_and_liability_input_problems([attribute(colour, blue), attribute(damage_suffered, maybe), attribute(party_role, admin), attribute(size, large)], [wrong_type(party_role), wrong_type(damage_suffered), unknown_key(colour), unknown_key(size)]).
test(an_unknown_role_is_a_wrong_type) :-
    gdpr_compensation_and_liability_input_problems([attribute(party_role, joint_controller)], [wrong_type(party_role)]).
test(an_unsure_processor_ground_is_a_wrong_type) :-
    gdpr_compensation_and_liability_input_problems([attribute(processor_acted_outside_or_contrary_to_lawful_instructions, unsure)], [wrong_type(processor_acted_outside_or_contrary_to_lawful_instructions)]).
test(a_bare_boolean_statement_is_a_wrong_type) :-
    gdpr_compensation_and_liability_input_problems([attribute(not_in_any_way_responsible_for_the_event, true)], [wrong_type(not_in_any_way_responsible_for_the_event)]).
test(an_attestation_of_three_arguments_is_a_wrong_type) :-
    gdpr_compensation_and_liability_input_problems([attribute(not_in_any_way_responsible_for_the_event, attested(true, attestation(host, at, reason)))], [wrong_type(not_in_any_way_responsible_for_the_event)]).
test(an_unsure_attested_value_is_a_wrong_type) :-
    gdpr_compensation_and_liability_input_problems([attribute(not_in_any_way_responsible_for_the_event, attested(unsure, attestation(host, at, reason, none)))], [wrong_type(not_in_any_way_responsible_for_the_event)]).
test(url_and_document_evidence_are_well_formed) :-
    gdpr_compensation_and_liability_input_problems([attribute(not_in_any_way_responsible_for_the_event, attested(false, attestation(host, at, reason, url(address, retrieved_at))))], []),
    gdpr_compensation_and_liability_input_problems([attribute(not_in_any_way_responsible_for_the_event, attested(true, attestation(host, at, reason, document(upload_identifier, checksum))))], []).
test(a_key_the_answer_does_not_read_is_still_checked) :-
    compensation_liability([attribute(damage_suffered, false), attribute(processor_breached_obligations_directed_to_processors, unsure)], input_problems([wrong_type(processor_breached_obligations_directed_to_processors)]), [], []).
test(an_absent_key_is_never_a_problem) :-
    gdpr_compensation_and_liability_input_problems([attribute(damage_suffered, true)], []).

test(the_baseline_rejects_exempt_bound, fail) :-
    gdpr_compensation_and_liability_profile_for(todo_baseline_subject, Profile),
    gdpr_compensation_and_liability_status(Profile, exempt_from_liability).
test(a_key_the_answer_does_not_read_blocks_the_final_answer, fail) :-
    compensation_liability([attribute(damage_suffered, false), attribute(processor_breached_obligations_directed_to_processors, unsure)], right_not_established, _, _).

cp_test_names([the_baseline_holds_with_liable_bound, the_full_liable_answer_holds_bound, the_full_exempt_answer_holds_bound, the_not_liable_answer_holds_bound, the_right_not_established_answer_holds_bound, the_judgement_indeterminate_holds_bound, the_role_indeterminate_holds_bound, the_outside_referral_holds_bound, the_cross_reference_referral_holds_bound, the_inside_referral_holds_bound, the_input_problem_holds_bound, an_unbound_profile_is_not_an_attribute_list, an_unbound_profile_gets_the_input_problem_answer, a_partial_list_is_not_an_attribute_list, a_list_holding_an_unbound_element_is_not_an_attribute_list, a_list_holding_a_bare_atom_is_refused_alone, a_compound_term_is_not_a_profile, a_number_key_is_unknown, a_compound_key_is_unknown_as_given, an_unbound_key_is_unknown_as_given, an_unbound_value_is_a_wrong_type, a_repeated_unknown_key_is_named_once, a_duplicate_with_different_values_is_a_duplicate_only, problems_come_in_contract_order_then_unknown_keys, an_unknown_role_is_a_wrong_type, an_unsure_processor_ground_is_a_wrong_type, a_bare_boolean_statement_is_a_wrong_type, an_attestation_of_three_arguments_is_a_wrong_type, an_unsure_attested_value_is_a_wrong_type, url_and_document_evidence_are_well_formed, a_key_the_answer_does_not_read_is_still_checked, an_absent_key_is_never_a_problem]).
cp_test_fail_names([the_baseline_rejects_exempt_bound, a_key_the_answer_does_not_read_blocks_the_final_answer]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
