% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_rts_change_management_tests_test_negative_controls, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_dora_rts_change_management_dora_rts_change_management, [ict_change_management_duties_required/3, ict_change_management_duties_outstanding/3, dora_rts_change_management_status/2, dora_rts_change_management_status_values/1]).
:- use_module(m__eu_dora_rts_change_management_fixtures, [dora_rts_change_management_profile_for/2]).

test(the_near_miss_atoms_are_verdict_atoms) :-
    dora_rts_change_management_status_values(StatusValues),
    StatusValues == [complete, incomplete, simplified_framework_entity].
test(gate_true_is_a_simplified_framework_entity) :-
    dora_rts_change_management_profile_for(article_16_1_entity, Profile),
    dora_rts_change_management_status(Profile, simplified_framework_entity).
test(gate_false_near_miss_is_incomplete) :-
    dora_rts_change_management_profile_for(article_16_1_entity, [_|OtherAttributes]),
    dora_rts_change_management_status([attribute(financial_entity_is_article_16_1_entity, false)|OtherAttributes], incomplete).
test(gate_absent_is_indeterminate) :-
    dora_rts_change_management_profile_for(article_16_1_status_unstated, Profile),
    dora_rts_change_management_status(Profile, indeterminate([financial_entity_is_article_16_1_entity])).
test(gate_stated_near_miss_is_complete) :-
    dora_rts_change_management_profile_for(article_16_1_status_unstated, Profile),
    dora_rts_change_management_status([attribute(financial_entity_is_article_16_1_entity, false)|Profile], complete).
test(element_false_is_incomplete) :-
    dora_rts_change_management_profile_for(credit_institution_verification_not_performed, Profile),
    dora_rts_change_management_status(Profile, incomplete).
test(element_true_near_miss_is_complete) :-
    dora_rts_change_management_profile_for(credit_institution_all_elements_performed, Profile),
    dora_rts_change_management_status(Profile, complete).
test(central_counterparty_with_parties_is_complete) :-
    dora_rts_change_management_profile_for(central_counterparty_tested_with_parties, Profile),
    dora_rts_change_management_status(Profile, complete).
test(central_counterparty_without_parties_is_incomplete) :-
    dora_rts_change_management_profile_for(central_counterparty_parties_not_involved, Profile),
    dora_rts_change_management_status(Profile, incomplete).
test(depository_without_significant_changes_is_complete) :-
    dora_rts_change_management_profile_for(central_securities_depository_without_significant_changes, Profile),
    dora_rts_change_management_status(Profile, complete).
test(depository_with_significant_changes_asks_for_involvement) :-
    dora_rts_change_management_profile_for(central_securities_depository_involvement_unstated, Profile),
    dora_rts_change_management_status(Profile, indeterminate([users_service_providers_and_other_parties_involved_in_testing])).
test(the_trigger_false_requires_no_testing) :-
    dora_rts_change_management_profile_for(central_securities_depository_without_significant_changes, Profile),
    ict_change_management_duties_required(Profile, required(Duties), _),
    length(Duties, 13).
test(an_unsure_element_is_referred) :-
    dora_rts_change_management_profile_for(credit_institution_verification_unsure, Profile),
    dora_rts_change_management_status(Profile, needs_legal_review(open_textured(change_procedures_verify_whether_ict_security_requirements_met, cite(eu_reg_2024_1774_art_17_1)), _)).
test(entity_type_unstated_is_indeterminate) :-
    dora_rts_change_management_profile_for(entity_type_unstated, Profile),
    dora_rts_change_management_status(Profile, indeterminate([dora_entity_type])).
test(investment_firm_near_miss_is_complete) :-
    dora_rts_change_management_profile_for(investment_firm_trigger_unstated, Profile),
    dora_rts_change_management_status(Profile, complete).
test(a_failing_element_is_outstanding) :-
    dora_rts_change_management_profile_for(credit_institution_verification_not_performed, Profile),
    ict_change_management_duties_outstanding(Profile, outstanding([verification_of_ict_security_requirements]), _).
test(all_performed_is_none_outstanding) :-
    dora_rts_change_management_profile_for(credit_institution_all_elements_performed, Profile),
    ict_change_management_duties_outstanding(Profile, none_outstanding, _).
test(an_unknown_key_is_an_input_problem) :-
    dora_rts_change_management_profile_for(profile_with_unknown_key, Profile),
    dora_rts_change_management_status(Profile, input_problems([unknown_key(colour)])).
test(the_unknown_key_removed_is_complete) :-
    dora_rts_change_management_profile_for(profile_with_unknown_key, [_|OtherAttributes]),
    dora_rts_change_management_status(OtherAttributes, complete).

test(gate_false_near_miss_is_not_simplified, fail) :-
    dora_rts_change_management_profile_for(article_16_1_entity, [_|OtherAttributes]),
    dora_rts_change_management_status([attribute(financial_entity_is_article_16_1_entity, false)|OtherAttributes], simplified_framework_entity).
test(gate_absent_is_not_complete, fail) :-
    dora_rts_change_management_profile_for(article_16_1_status_unstated, Profile),
    dora_rts_change_management_status(Profile, complete).
test(element_false_is_not_complete, fail) :-
    dora_rts_change_management_profile_for(credit_institution_verification_not_performed, Profile),
    dora_rts_change_management_status(Profile, complete).
test(element_true_near_miss_is_not_incomplete, fail) :-
    dora_rts_change_management_profile_for(credit_institution_all_elements_performed, Profile),
    dora_rts_change_management_status(Profile, incomplete).
test(central_counterparty_without_parties_is_not_complete, fail) :-
    dora_rts_change_management_profile_for(central_counterparty_parties_not_involved, Profile),
    dora_rts_change_management_status(Profile, complete).
test(depository_with_significant_changes_is_not_complete, fail) :-
    dora_rts_change_management_profile_for(central_securities_depository_involvement_unstated, Profile),
    dora_rts_change_management_status(Profile, complete).
test(the_trigger_false_never_requires_stringent_testing, fail) :-
    dora_rts_change_management_profile_for(central_securities_depository_without_significant_changes, Profile),
    ict_change_management_duties_required(Profile, required(Duties), _),
    member(stringent_testing_after_significant_changes, Duties).
test(an_unsure_element_is_not_complete, fail) :-
    dora_rts_change_management_profile_for(credit_institution_verification_unsure, Profile),
    dora_rts_change_management_status(Profile, complete).
test(entity_type_unstated_is_not_complete, fail) :-
    dora_rts_change_management_profile_for(entity_type_unstated, Profile),
    dora_rts_change_management_status(Profile, complete).
test(a_failing_element_is_not_none_outstanding, fail) :-
    dora_rts_change_management_profile_for(credit_institution_verification_not_performed, Profile),
    ict_change_management_duties_outstanding(Profile, none_outstanding, _).
test(an_unknown_key_is_not_complete, fail) :-
    dora_rts_change_management_profile_for(profile_with_unknown_key, Profile),
    dora_rts_change_management_status(Profile, complete).

cp_test_names([the_near_miss_atoms_are_verdict_atoms, gate_true_is_a_simplified_framework_entity, gate_false_near_miss_is_incomplete, gate_absent_is_indeterminate, gate_stated_near_miss_is_complete, element_false_is_incomplete, element_true_near_miss_is_complete, central_counterparty_with_parties_is_complete, central_counterparty_without_parties_is_incomplete, depository_without_significant_changes_is_complete, depository_with_significant_changes_asks_for_involvement, the_trigger_false_requires_no_testing, an_unsure_element_is_referred, entity_type_unstated_is_indeterminate, investment_firm_near_miss_is_complete, a_failing_element_is_outstanding, all_performed_is_none_outstanding, an_unknown_key_is_an_input_problem, the_unknown_key_removed_is_complete]).
cp_test_fail_names([gate_false_near_miss_is_not_simplified, gate_absent_is_not_complete, element_false_is_not_complete, element_true_near_miss_is_not_incomplete, central_counterparty_without_parties_is_not_complete, depository_with_significant_changes_is_not_complete, the_trigger_false_never_requires_stringent_testing, an_unsure_element_is_not_complete, entity_type_unstated_is_not_complete, a_failing_element_is_not_none_outstanding, an_unknown_key_is_not_complete]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
