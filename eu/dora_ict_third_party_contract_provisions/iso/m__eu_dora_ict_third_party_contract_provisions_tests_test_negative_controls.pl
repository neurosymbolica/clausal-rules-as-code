% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_ict_third_party_contract_provisions_tests_test_negative_controls, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_dora_ict_third_party_contract_provisions_dora_ict_third_party_contract_provisions, [contract_provisions_required/3, contract_provisions_sufficient/3, contract_provisions_missing/3, dora_ict_third_party_contract_provisions_status_values/1]).
:- use_module(m__eu_dora_ict_third_party_contract_provisions_fixtures, [dora_ict_third_party_contract_provisions_profile_for/2]).

subject_required(Subject, Result) :-
    dora_ict_third_party_contract_provisions_profile_for(Subject, Profile),
    contract_provisions_required(Profile, Result, _).

subject_sufficient(Subject, Result) :-
    dora_ict_third_party_contract_provisions_profile_for(Subject, Profile),
    contract_provisions_sufficient(Profile, Result, _).

subject_missing(Subject, Result) :-
    dora_ict_third_party_contract_provisions_profile_for(Subject, Profile),
    contract_provisions_missing(Profile, Result, _).

test(the_status_table_names_both_final_answers) :-
    dora_ict_third_party_contract_provisions_status_values(StatusValues),
    StatusValues == [sufficient, insufficient].
test(a_non_critical_arrangement_requires_fourteen_elements) :-
    subject_required(not_critical_all_met, required(Elements)),
    length(Elements, 14).
test(a_critical_arrangement_requires_twenty_one) :-
    subject_required(critical_all_met, required(Elements)),
    length(Elements, 21).
test(required_asks_when_the_critical_function_is_absent) :-
    subject_required(critical_absent_art_30_3_met, indeterminate([supports_critical_or_important_function])).
test(required_asks_for_the_absent_microenterprise_fact) :-
    subject_required(critical_unsure_microenterprise_absent, indeterminate([financial_entity_is_microenterprise])).
test(required_refers_an_unsure_critical_function) :-
    subject_required(critical_unsure, needs_legal_review(open_textured(supports_critical_or_important_function, _), _)).
test(a_false_base_element_is_insufficient) :-
    subject_sufficient(not_critical_incident_assistance_false, insufficient).
test(the_same_contract_with_the_element_is_sufficient) :-
    subject_sufficient(not_critical_all_met, sufficient).
test(a_false_art_30_3_element_is_insufficient_for_a_critical_function) :-
    subject_sufficient(critical_exit_strategy_false, insufficient).
test(a_false_art_30_3_element_is_sufficient_without_a_critical_function) :-
    subject_sufficient(not_critical_art_30_3_false, sufficient).
test(a_microenterprise_delegation_meets_the_monitoring_requirement) :-
    subject_sufficient(microenterprise_delegation, sufficient).
test(a_refused_delegation_is_insufficient) :-
    subject_sufficient(microenterprise_delegation_refused, insufficient).
test(a_delegation_outside_a_microenterprise_is_insufficient) :-
    subject_sufficient(not_microenterprise_delegation, insufficient).
test(an_absent_critical_function_is_asked_when_art_30_3_is_open) :-
    subject_sufficient(critical_absent_art_30_3_open, indeterminate([supports_critical_or_important_function])).
test(an_absent_critical_function_does_not_matter_when_art_30_3_is_met) :-
    subject_sufficient(critical_absent_art_30_3_met, sufficient).
test(an_unsure_document_is_referred) :-
    subject_sufficient(document_unsure, needs_legal_review(open_textured(contract_is_single_written_document, _), _)).
test(the_missing_list_waits_for_an_absent_base_key) :-
    subject_missing(base_false_and_absent, indeterminate([contract_provides_termination_for_significant_breach])).
test(with_every_key_given_the_missing_list_is_final) :-
    subject_missing(not_critical_incident_assistance_false, missing([incident_assistance])).
test(a_microenterprise_misses_the_delegated_assurance) :-
    subject_missing(microenterprise_delegation_refused, missing([monitoring_rights_of_the_financial_entity_or_delegated_assurance])).
test(another_entity_misses_its_own_monitoring_rights) :-
    subject_missing(not_microenterprise_delegation, missing([monitoring_rights_of_the_financial_entity])).
test(duplicate_and_unknown_keys_are_refused) :-
    subject_sufficient(duplicate_and_unknown_keys, input_problems([duplicate_key(supports_critical_or_important_function), unknown_key(colour)])).

test(a_non_critical_arrangement_does_not_require_twenty_one, fail) :-
    subject_required(not_critical_all_met, required(Elements)),
    length(Elements, 21).
test(a_critical_arrangement_does_not_require_only_fourteen, fail) :-
    subject_required(critical_all_met, required(Elements)),
    length(Elements, 14).
test(required_does_not_ask_when_the_critical_function_is_given, fail) :-
    subject_required(critical_all_met, indeterminate(_)).
test(required_does_not_ask_once_the_microenterprise_fact_is_given, fail) :-
    subject_required(critical_unsure, indeterminate(_)).
test(required_does_not_refer_while_a_key_is_absent, fail) :-
    subject_required(critical_unsure_microenterprise_absent, needs_legal_review(_, _)).
test(required_does_not_refer_a_decided_critical_function, fail) :-
    subject_required(critical_all_met, needs_legal_review(_, _)).
test(the_same_contract_with_the_element_is_not_insufficient, fail) :-
    subject_sufficient(not_critical_all_met, insufficient).
test(a_false_art_30_3_element_is_not_insufficient_without_a_critical_function, fail) :-
    subject_sufficient(not_critical_art_30_3_false, insufficient).
test(a_refused_delegation_is_not_sufficient, fail) :-
    subject_sufficient(microenterprise_delegation_refused, sufficient).
test(a_delegation_outside_a_microenterprise_is_not_sufficient, fail) :-
    subject_sufficient(not_microenterprise_delegation, sufficient).
test(an_absent_critical_function_is_not_asked_when_art_30_3_is_met, fail) :-
    subject_sufficient(critical_absent_art_30_3_met, indeterminate(_)).
test(a_decided_document_is_not_referred, fail) :-
    subject_sufficient(critical_all_met, needs_legal_review(_, _)).
test(with_every_key_given_the_missing_list_does_not_wait, fail) :-
    subject_missing(not_critical_incident_assistance_false, indeterminate(_)).
test(another_entity_is_not_offered_the_delegated_assurance, fail) :-
    subject_missing(not_microenterprise_delegation, missing([monitoring_rights_of_the_financial_entity_or_delegated_assurance])).
test(the_well_formed_baseline_is_not_refused, fail) :-
    subject_sufficient(not_critical_all_met, input_problems(_)).

cp_test_names([the_status_table_names_both_final_answers, a_non_critical_arrangement_requires_fourteen_elements, a_critical_arrangement_requires_twenty_one, required_asks_when_the_critical_function_is_absent, required_asks_for_the_absent_microenterprise_fact, required_refers_an_unsure_critical_function, a_false_base_element_is_insufficient, the_same_contract_with_the_element_is_sufficient, a_false_art_30_3_element_is_insufficient_for_a_critical_function, a_false_art_30_3_element_is_sufficient_without_a_critical_function, a_microenterprise_delegation_meets_the_monitoring_requirement, a_refused_delegation_is_insufficient, a_delegation_outside_a_microenterprise_is_insufficient, an_absent_critical_function_is_asked_when_art_30_3_is_open, an_absent_critical_function_does_not_matter_when_art_30_3_is_met, an_unsure_document_is_referred, the_missing_list_waits_for_an_absent_base_key, with_every_key_given_the_missing_list_is_final, a_microenterprise_misses_the_delegated_assurance, another_entity_misses_its_own_monitoring_rights, duplicate_and_unknown_keys_are_refused]).
cp_test_fail_names([a_non_critical_arrangement_does_not_require_twenty_one, a_critical_arrangement_does_not_require_only_fourteen, required_does_not_ask_when_the_critical_function_is_given, required_does_not_ask_once_the_microenterprise_fact_is_given, required_does_not_refer_while_a_key_is_absent, required_does_not_refer_a_decided_critical_function, the_same_contract_with_the_element_is_not_insufficient, a_false_art_30_3_element_is_not_insufficient_without_a_critical_function, a_refused_delegation_is_not_sufficient, a_delegation_outside_a_microenterprise_is_not_sufficient, an_absent_critical_function_is_not_asked_when_art_30_3_is_met, a_decided_document_is_not_referred, with_every_key_given_the_missing_list_does_not_wait, another_entity_is_not_offered_the_delegated_assurance, the_well_formed_baseline_is_not_refused]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
