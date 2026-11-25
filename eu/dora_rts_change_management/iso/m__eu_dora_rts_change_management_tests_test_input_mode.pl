% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_rts_change_management_tests_test_input_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_dora_rts_change_management_dora_rts_change_management, [ict_change_management_duties_required/3, ict_change_management_duties_complete/3, ict_change_management_duties_outstanding/3, dora_rts_change_management_status/2, dora_rts_change_management_status_values/1]).
:- use_module(m__eu_dora_rts_change_management_kernel, [dora_rts_change_management_input_problems/2]).
:- use_module(m__eu_dora_rts_change_management_fixtures, [dora_rts_change_management_profile_for/2]).

test(complete_holds_with_the_verdict_bound) :-
    dora_rts_change_management_profile_for(credit_institution_all_elements_performed, Profile),
    dora_rts_change_management_status(Profile, complete).
test(incomplete_holds_with_the_verdict_bound) :-
    dora_rts_change_management_profile_for(credit_institution_verification_not_performed, Profile),
    dora_rts_change_management_status(Profile, incomplete).
test(simplified_framework_entity_holds_with_the_verdict_bound) :-
    dora_rts_change_management_profile_for(article_16_1_entity, Profile),
    dora_rts_change_management_status(Profile, simplified_framework_entity).
test(complete_with_its_fixed_citations_bound) :-
    dora_rts_change_management_profile_for(credit_institution_all_elements_performed, Profile),
    ict_change_management_duties_complete(Profile, complete, [cite(eu_reg_2024_1774_art_17_1), cite(eu_reg_2024_1774_art_17_2)]).
test(gate_true_with_its_citation_bound) :-
    dora_rts_change_management_profile_for(article_16_1_entity, Profile),
    ict_change_management_duties_required(Profile, simplified_framework_entity, [cite(eu_reg_2022_2554_art_16_1)]).
test(outstanding_with_its_list_bound) :-
    dora_rts_change_management_profile_for(central_counterparty_parties_not_involved, Profile),
    ict_change_management_duties_outstanding(Profile, outstanding([central_counterparty_involvement_of_parties_in_testing]), [cite(eu_reg_2024_1774_art_17_2)]).
test(missing_gate_bound) :-
    dora_rts_change_management_profile_for(article_16_1_status_unstated, Profile),
    ict_change_management_duties_outstanding(Profile, indeterminate([financial_entity_is_article_16_1_entity]), []).
test(a_well_formed_profile_has_no_problem) :-
    dora_rts_change_management_profile_for(credit_institution_all_elements_performed, Profile),
    dora_rts_change_management_input_problems(Profile, []).
test(the_empty_profile_has_no_problem) :-
    dora_rts_change_management_input_problems([], []).
test(an_unbound_profile_is_not_an_attribute_list) :-
    dora_rts_change_management_input_problems(_, Problems),
    Problems == [wrong_type(profile)].
test(a_partial_list_is_not_an_attribute_list) :-
    dora_rts_change_management_input_problems([attribute(dora_entity_type, central_counterparty)|_], Problems),
    Problems == [wrong_type(profile)].
test(a_foreign_element_is_not_an_attribute_list) :-
    dora_rts_change_management_input_problems([attribute(dora_entity_type, central_counterparty), colour], Problems),
    Problems == [wrong_type(profile)].
test(an_unbound_value_is_wrong_type) :-
    dora_rts_change_management_input_problems([attribute(dora_entity_type, _)], Problems),
    Problems == [wrong_type(dora_entity_type)].
test(a_number_value_is_wrong_type) :-
    dora_rts_change_management_input_problems([attribute(financial_entity_is_article_16_1_entity, 1)], Problems),
    Problems == [wrong_type(financial_entity_is_article_16_1_entity)].
test(unsure_is_wrong_type_for_the_trigger) :-
    dora_rts_change_management_input_problems([attribute(significant_changes_made_to_ict_systems, unsure)], Problems),
    Problems == [wrong_type(significant_changes_made_to_ict_systems)].
test(unsure_is_a_judgement_value) :-
    dora_rts_change_management_input_problems([attribute(change_procedures_verify_whether_ict_security_requirements_met, unsure)], []).
test(an_unbound_key_is_named_as_given) :-
    dora_rts_change_management_input_problems([attribute(UnboundKey, true)], Problems),
    Problems = [unknown_key(NamedKey)],
    NamedKey == UnboundKey.
test(the_same_unbound_key_twice_is_one_key) :-
    dora_rts_change_management_input_problems([attribute(UnboundKey, true), attribute(UnboundKey, false)], Problems),
    Problems = [unknown_key(NamedKey)],
    NamedKey == UnboundKey.
test(contract_problems_come_before_unknown_keys) :-
    dora_rts_change_management_input_problems([attribute(colour, blue), attribute(dora_entity_type, bank)], Problems),
    Problems == [wrong_type(dora_entity_type), unknown_key(colour)].
test(a_duplicate_key_is_never_also_wrong_type) :-
    dora_rts_change_management_input_problems([attribute(dora_entity_type, bank), attribute(dora_entity_type, bank)], Problems),
    Problems == [duplicate_key(dora_entity_type)].
test(input_problems_come_first_for_every_query) :-
    dora_rts_change_management_profile_for(profile_with_unknown_key, Profile),
    ict_change_management_duties_required(Profile, input_problems([unknown_key(colour)]), []),
    ict_change_management_duties_complete(Profile, input_problems([unknown_key(colour)]), []),
    ict_change_management_duties_outstanding(Profile, input_problems([unknown_key(colour)]), []).

test(complete_profile_rejects_incomplete_bound, fail) :-
    dora_rts_change_management_profile_for(credit_institution_all_elements_performed, Profile),
    dora_rts_change_management_status(Profile, incomplete).
test(every_other_bound_status_is_rejected, fail) :-
    dora_rts_change_management_profile_for(credit_institution_all_elements_performed, Profile),
    dora_rts_change_management_status_values(StatusValues),
    member(Other, StatusValues),
    dif(Other, complete),
    dora_rts_change_management_status(Profile, Other).

cp_test_names([complete_holds_with_the_verdict_bound, incomplete_holds_with_the_verdict_bound, simplified_framework_entity_holds_with_the_verdict_bound, complete_with_its_fixed_citations_bound, gate_true_with_its_citation_bound, outstanding_with_its_list_bound, missing_gate_bound, a_well_formed_profile_has_no_problem, the_empty_profile_has_no_problem, an_unbound_profile_is_not_an_attribute_list, a_partial_list_is_not_an_attribute_list, a_foreign_element_is_not_an_attribute_list, an_unbound_value_is_wrong_type, a_number_value_is_wrong_type, unsure_is_wrong_type_for_the_trigger, unsure_is_a_judgement_value, an_unbound_key_is_named_as_given, the_same_unbound_key_twice_is_one_key, contract_problems_come_before_unknown_keys, a_duplicate_key_is_never_also_wrong_type, input_problems_come_first_for_every_query]).
cp_test_fail_names([complete_profile_rejects_incomplete_bound, every_other_bound_status_is_rejected]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
