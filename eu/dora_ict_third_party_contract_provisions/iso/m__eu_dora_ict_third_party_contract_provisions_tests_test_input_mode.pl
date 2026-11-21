% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_ict_third_party_contract_provisions_tests_test_input_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_dora_ict_third_party_contract_provisions_dora_ict_third_party_contract_provisions, [contract_provisions_required/3, contract_provisions_sufficient/3, contract_provisions_missing/3, dora_ict_third_party_contract_provisions_status/2]).
:- use_module(m__eu_dora_ict_third_party_contract_provisions_kernel, [dora_ict_third_party_contract_provisions_input_problems/2]).
:- use_module(m__eu_dora_ict_third_party_contract_provisions_fixtures, [dora_ict_third_party_contract_provisions_profile_for/2]).

test(sufficient_holds_with_the_verdict_bound) :-
    dora_ict_third_party_contract_provisions_profile_for(critical_all_met, Profile),
    contract_provisions_sufficient(Profile, sufficient, _).
test(insufficient_holds_with_the_verdict_bound) :-
    dora_ict_third_party_contract_provisions_profile_for(critical_exit_strategy_false, Profile),
    contract_provisions_sufficient(Profile, insufficient, _).
test(the_missing_list_holds_with_its_citations_bound) :-
    dora_ict_third_party_contract_provisions_profile_for(critical_exit_strategy_false, Profile),
    contract_provisions_missing(Profile, missing([exit_strategy_and_transition_period]), [cite(eu_reg_2022_2554_art_30_3_f)]).
test(none_missing_holds_with_the_verdict_bound) :-
    dora_ict_third_party_contract_provisions_profile_for(critical_all_met, Profile),
    contract_provisions_missing(Profile, none_missing, _).
test(the_base_list_holds_with_the_verdict_bound) :-
    dora_ict_third_party_contract_provisions_profile_for(not_critical_all_met, Profile),
    contract_provisions_required(Profile, required([termination_for_significant_breach, termination_for_circumstances_altering_performance, termination_for_risk_management_weaknesses, termination_where_supervision_impeded, single_written_document, description_of_functions_services_and_subcontracting, service_and_data_locations, data_protection_provisions, data_access_recovery_and_return, service_level_descriptions, incident_assistance, cooperation_with_authorities, termination_rights_and_notice_periods, security_awareness_and_training_participation]), _).
test(the_status_holds_with_the_verdict_bound) :-
    dora_ict_third_party_contract_provisions_profile_for(not_critical_all_met, Profile),
    dora_ict_third_party_contract_provisions_status(Profile, sufficient).
test(an_empty_profile_has_no_problem) :-
    dora_ict_third_party_contract_provisions_input_problems([], Problems),
    Problems == [].
test(an_empty_profile_asks_for_the_first_base_key) :-
    contract_provisions_sufficient([], Result, Citations),
    Result == indeterminate([contract_provides_termination_for_significant_breach]),
    Citations == [].
test(an_empty_profile_asks_required_for_the_critical_function) :-
    contract_provisions_required([], Result, Citations),
    Result == indeterminate([supports_critical_or_important_function]),
    Citations == [].
test(an_unbound_profile_is_not_an_attribute_list) :-
    findall(Problems, dora_ict_third_party_contract_provisions_input_problems(_Unbound, Problems), Answers),
    Answers == [[wrong_type(profile)]].
test(a_partial_list_is_not_an_attribute_list) :-
    dora_ict_third_party_contract_provisions_input_problems([attribute(contract_is_single_written_document, true)|_Tail], Problems),
    Problems == [wrong_type(profile)].
test(an_atom_is_not_an_attribute_list) :-
    dora_ict_third_party_contract_provisions_input_problems(not_a_profile, Problems),
    Problems == [wrong_type(profile)].
test(an_item_that_is_not_an_attribute_spoils_the_list) :-
    dora_ict_third_party_contract_provisions_input_problems([attribute(supports_critical_or_important_function, true), colour], Problems),
    Problems == [wrong_type(profile)].
test(an_unbound_item_spoils_the_list) :-
    dora_ict_third_party_contract_provisions_input_problems([attribute(supports_critical_or_important_function, true), _Unbound], Problems),
    Problems == [wrong_type(profile)].
test(a_number_key_is_unknown) :-
    dora_ict_third_party_contract_provisions_input_problems([attribute(7, true)], Problems),
    Problems == [unknown_key(7)].
test(a_compound_key_is_unknown_as_given) :-
    dora_ict_third_party_contract_provisions_input_problems([attribute(colour(blue), true)], Problems),
    Problems == [unknown_key(colour(blue))].
test(a_repeated_unknown_key_is_named_once) :-
    dora_ict_third_party_contract_provisions_input_problems([attribute(colour, blue), attribute(colour, red)], Problems),
    Problems == [unknown_key(colour)].
test(an_unbound_value_is_a_wrong_type) :-
    dora_ict_third_party_contract_provisions_input_problems([attribute(contract_is_single_written_document, _UnboundValue)], Problems),
    Problems == [wrong_type(contract_is_single_written_document)].
test(unsure_is_a_wrong_type_for_the_microenterprise_fact) :-
    dora_ict_third_party_contract_provisions_profile_for(microenterprise_unsure, Profile),
    dora_ict_third_party_contract_provisions_input_problems(Profile, Problems),
    Problems == [wrong_type(financial_entity_is_microenterprise)].
test(unsure_is_a_good_judgement_value) :-
    dora_ict_third_party_contract_provisions_input_problems([attribute(contract_provides_incident_assistance, unsure)], Problems),
    Problems == [].
test(a_repeated_key_is_a_duplicate_whatever_its_values) :-
    dora_ict_third_party_contract_provisions_input_problems([attribute(contract_provides_incident_assistance, true), attribute(contract_provides_incident_assistance, banana)], Problems),
    Problems == [duplicate_key(contract_provides_incident_assistance)].
test(the_problems_come_in_contract_order_then_unknown_keys) :-
    Profile = [attribute(zebra, stripes), attribute(financial_entity_is_microenterprise, unsure), attribute(contract_provides_termination_for_significant_breach, maybe), attribute(zebra, again), attribute(contract_is_single_written_document, true), attribute(contract_is_single_written_document, false)],
    dora_ict_third_party_contract_provisions_input_problems(Profile, Problems),
    Problems == [wrong_type(contract_provides_termination_for_significant_breach), duplicate_key(contract_is_single_written_document), wrong_type(financial_entity_is_microenterprise), unknown_key(zebra)].
test(every_query_refuses_a_badly_formed_profile_first) :-
    contract_provisions_required(not_a_profile, RequiredResult, RequiredCitations),
    RequiredResult == input_problems([wrong_type(profile)]),
    RequiredCitations == [],
    contract_provisions_sufficient(not_a_profile, SufficientResult, SufficientCitations),
    SufficientResult == input_problems([wrong_type(profile)]),
    SufficientCitations == [],
    contract_provisions_missing(not_a_profile, MissingResult, MissingCitations),
    MissingResult == input_problems([wrong_type(profile)]),
    MissingCitations == [].
test(an_unread_microenterprise_key_is_still_checked) :-
    contract_provisions_required([attribute(supports_critical_or_important_function, false), attribute(financial_entity_is_microenterprise, unsure)], Result, []),
    Result == input_problems([wrong_type(financial_entity_is_microenterprise)]).

test(insufficient_is_rejected_for_a_complete_contract, fail) :-
    dora_ict_third_party_contract_provisions_profile_for(critical_all_met, Profile),
    contract_provisions_sufficient(Profile, insufficient, _).
test(sufficient_is_rejected_for_a_contract_without_exit_strategy, fail) :-
    dora_ict_third_party_contract_provisions_profile_for(critical_exit_strategy_false, Profile),
    contract_provisions_sufficient(Profile, sufficient, _).
test(the_status_rejects_the_other_final_answer, fail) :-
    dora_ict_third_party_contract_provisions_profile_for(not_critical_all_met, Profile),
    dora_ict_third_party_contract_provisions_status(Profile, insufficient).

cp_test_names([sufficient_holds_with_the_verdict_bound, insufficient_holds_with_the_verdict_bound, the_missing_list_holds_with_its_citations_bound, none_missing_holds_with_the_verdict_bound, the_base_list_holds_with_the_verdict_bound, the_status_holds_with_the_verdict_bound, an_empty_profile_has_no_problem, an_empty_profile_asks_for_the_first_base_key, an_empty_profile_asks_required_for_the_critical_function, an_unbound_profile_is_not_an_attribute_list, a_partial_list_is_not_an_attribute_list, an_atom_is_not_an_attribute_list, an_item_that_is_not_an_attribute_spoils_the_list, an_unbound_item_spoils_the_list, a_number_key_is_unknown, a_compound_key_is_unknown_as_given, a_repeated_unknown_key_is_named_once, an_unbound_value_is_a_wrong_type, unsure_is_a_wrong_type_for_the_microenterprise_fact, unsure_is_a_good_judgement_value, a_repeated_key_is_a_duplicate_whatever_its_values, the_problems_come_in_contract_order_then_unknown_keys, every_query_refuses_a_badly_formed_profile_first, an_unread_microenterprise_key_is_still_checked]).
cp_test_fail_names([insufficient_is_rejected_for_a_complete_contract, sufficient_is_rejected_for_a_contract_without_exit_strategy, the_status_rejects_the_other_final_answer]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
