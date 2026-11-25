% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_rts_logging_and_network_security_tests_test_input_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_dora_rts_logging_and_network_security_dora_rts_logging_and_network_security, [dora_rts_logging_and_network_security_status/2, dora_rts_logging_and_network_security_status_values/1, rts_logging_and_network_security_duties_required/3, rts_logging_and_network_security_duties_complete/3, rts_logging_and_network_security_duties_outstanding/3]).
:- use_module(m__eu_dora_rts_logging_and_network_security_kernel, [dora_rts_logging_and_network_security_input_problems/2]).
:- use_module(m__eu_dora_rts_logging_and_network_security_fixtures, [dora_rts_logging_and_network_security_profile_for/2]).

test(status_holds_with_the_verdict_bound) :-
    dora_rts_logging_and_network_security_profile_for(all_performed_larger_entity_with_critical_systems, Profile),
    dora_rts_logging_and_network_security_status(Profile, complete).
test(bound_incomplete_holds) :-
    dora_rts_logging_and_network_security_profile_for(encryption_not_performed_larger_entity, Profile),
    rts_logging_and_network_security_duties_complete(Profile, incomplete, _).
test(bound_simplified_framework_entity_holds_in_every_query) :-
    dora_rts_logging_and_network_security_profile_for(article_16_1_entity, Profile),
    rts_logging_and_network_security_duties_required(Profile, simplified_framework_entity, [cite(eu_reg_2022_2554_art_16_1)]),
    rts_logging_and_network_security_duties_complete(Profile, simplified_framework_entity, [cite(eu_reg_2022_2554_art_16_1)]),
    rts_logging_and_network_security_duties_outstanding(Profile, simplified_framework_entity, [cite(eu_reg_2022_2554_art_16_1)]).
test(bound_indeterminate_gate_holds) :-
    dora_rts_logging_and_network_security_profile_for(gate_not_stated, Profile),
    rts_logging_and_network_security_duties_complete(Profile, indeterminate([financial_entity_is_article_16_1_entity]), []).
test(bound_needs_legal_review_holds) :-
    dora_rts_logging_and_network_security_profile_for(encryption_unsure, Profile),
    rts_logging_and_network_security_duties_complete(Profile, needs_legal_review(open_textured(network_connections_encrypted, cite(eu_reg_2024_1774_art_13_e)), [inputs_relied_on(_)]), []).
test(bound_outstanding_list_holds) :-
    dora_rts_logging_and_network_security_profile_for(encryption_not_performed_larger_entity, Profile),
    rts_logging_and_network_security_duties_outstanding(Profile, outstanding([encryption_of_network_connections]), [cite(eu_reg_2024_1774_art_13_e)]).
test(bound_none_outstanding_holds) :-
    dora_rts_logging_and_network_security_profile_for(all_performed_microenterprise_without_critical_systems, Profile),
    rts_logging_and_network_security_duties_outstanding(Profile, none_outstanding, _).
test(bound_input_problems_holds) :-
    dora_rts_logging_and_network_security_profile_for(unknown_key_present, Profile),
    rts_logging_and_network_security_duties_required(Profile, input_problems([unknown_key(colour)]), []).
test(an_unbound_profile_is_wrong_type_profile) :-
    rts_logging_and_network_security_duties_complete(_, Result, Citations),
    Result == input_problems([wrong_type(profile)]),
    Citations == [].
test(a_partial_list_is_wrong_type_profile) :-
    dora_rts_logging_and_network_security_input_problems([attribute(financial_entity_is_article_16_1_entity, false)|_], Problems),
    Problems == [wrong_type(profile)].
test(an_unbound_element_is_wrong_type_profile) :-
    dora_rts_logging_and_network_security_input_problems([_], Problems),
    Problems == [wrong_type(profile)].
test(an_element_that_is_not_an_attribute_is_wrong_type_profile) :-
    dora_rts_logging_and_network_security_input_problems([attribute(colour, blue), entry(colour, blue)], Problems),
    Problems == [wrong_type(profile)].
test(an_atom_profile_is_wrong_type_profile) :-
    dora_rts_logging_and_network_security_input_problems(profile, [wrong_type(profile)]).
test(an_unbound_key_is_named_as_given) :-
    Profile = [attribute(UnboundKey, true)],
    dora_rts_logging_and_network_security_input_problems(Profile, [unknown_key(Found)]),
    Found == UnboundKey.
test(two_distinct_unbound_keys_are_two_keys) :-
    Profile = [attribute(FirstKey, true), attribute(SecondKey, false)],
    dora_rts_logging_and_network_security_input_problems(Profile, [unknown_key(FirstFound), unknown_key(SecondFound)]),
    FirstFound == FirstKey,
    SecondFound == SecondKey.
test(the_same_unbound_key_twice_is_one_key) :-
    Profile = [attribute(UnboundKey, true), attribute(UnboundKey, false)],
    dora_rts_logging_and_network_security_input_problems(Profile, [unknown_key(Found)]),
    Found == UnboundKey.
test(a_compound_key_is_an_unknown_key) :-
    dora_rts_logging_and_network_security_input_problems([attribute(entity(colour), true)], [unknown_key(entity(colour))]).
test(a_repeated_unknown_key_is_named_once) :-
    dora_rts_logging_and_network_security_input_problems([attribute(colour, blue), attribute(colour, red)], Problems),
    Problems == [unknown_key(colour)].
test(an_unbound_value_of_a_contract_key_is_wrong_type) :-
    dora_rts_logging_and_network_security_input_problems([attribute(network_connections_encrypted, _)], Problems),
    Problems == [wrong_type(network_connections_encrypted)].
test(a_float_is_wrong_type) :-
    dora_rts_logging_and_network_security_input_problems([attribute(financial_entity_is_microenterprise, 1.0)], Problems),
    Problems == [wrong_type(financial_entity_is_microenterprise)].
test(an_integer_is_wrong_type_for_a_judgement) :-
    dora_rts_logging_and_network_security_input_problems([attribute(network_connections_encrypted, 1)], Problems),
    Problems == [wrong_type(network_connections_encrypted)].
test(problems_follow_the_contract_order_then_unknown_keys) :-
    dora_rts_logging_and_network_security_input_problems([attribute(colour, blue), attribute(network_connections_encrypted, maybe), attribute(financial_entity_is_article_16_1_entity, 3)], Problems),
    Problems == [wrong_type(financial_entity_is_article_16_1_entity), wrong_type(network_connections_encrypted), unknown_key(colour)].
test(a_duplicate_contract_key_is_not_also_wrong_type) :-
    dora_rts_logging_and_network_security_input_problems([attribute(financial_entity_is_article_16_1_entity, false), attribute(financial_entity_is_article_16_1_entity, 9)], Problems),
    Problems == [duplicate_key(financial_entity_is_article_16_1_entity)].
test(a_present_duty_key_is_checked_by_the_required_query) :-
    rts_logging_and_network_security_duties_required([attribute(financial_entity_is_article_16_1_entity, false), attribute(network_connections_encrypted, maybe)], input_problems([wrong_type(network_connections_encrypted)]), []).
test(the_gate_true_with_duty_keys_present_is_not_a_problem) :-
    dora_rts_logging_and_network_security_profile_for(article_16_1_entity, Profile),
    dora_rts_logging_and_network_security_input_problems(Profile, []).
test(an_absent_key_is_not_a_problem) :-
    dora_rts_logging_and_network_security_input_problems([attribute(financial_entity_is_article_16_1_entity, false)], []).

test(every_other_bound_status_is_rejected, fail) :-
    dora_rts_logging_and_network_security_profile_for(all_performed_larger_entity_with_critical_systems, Profile),
    dora_rts_logging_and_network_security_status_values(StatusValues),
    member(Other, StatusValues),
    dif(Other, complete),
    dora_rts_logging_and_network_security_status(Profile, Other).
test(bound_complete_is_rejected_for_a_failed_duty, fail) :-
    dora_rts_logging_and_network_security_profile_for(encryption_not_performed_larger_entity, Profile),
    rts_logging_and_network_security_duties_complete(Profile, complete, _).

cp_test_names([status_holds_with_the_verdict_bound, bound_incomplete_holds, bound_simplified_framework_entity_holds_in_every_query, bound_indeterminate_gate_holds, bound_needs_legal_review_holds, bound_outstanding_list_holds, bound_none_outstanding_holds, bound_input_problems_holds, an_unbound_profile_is_wrong_type_profile, a_partial_list_is_wrong_type_profile, an_unbound_element_is_wrong_type_profile, an_element_that_is_not_an_attribute_is_wrong_type_profile, an_atom_profile_is_wrong_type_profile, an_unbound_key_is_named_as_given, two_distinct_unbound_keys_are_two_keys, the_same_unbound_key_twice_is_one_key, a_compound_key_is_an_unknown_key, a_repeated_unknown_key_is_named_once, an_unbound_value_of_a_contract_key_is_wrong_type, a_float_is_wrong_type, an_integer_is_wrong_type_for_a_judgement, problems_follow_the_contract_order_then_unknown_keys, a_duplicate_contract_key_is_not_also_wrong_type, a_present_duty_key_is_checked_by_the_required_query, the_gate_true_with_duty_keys_present_is_not_a_problem, an_absent_key_is_not_a_problem]).
cp_test_fail_names([every_other_bound_status_is_rejected, bound_complete_is_rejected_for_a_failed_duty]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
