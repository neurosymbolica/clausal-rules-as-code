% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dma_art_6_9_10_portability_and_business_data_order_tests_test_input_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_dma_art_6_9_10_portability_and_business_data_order_kernel, [dma_art_6_9_10_portability_and_business_data_order_input_problems/2]).
:- use_module(m__eu_dma_art_6_9_10_portability_and_business_data_order_dma_art_6_9_10_portability_and_business_data_order, [article_6_application_status/4, end_user_data_portability_status/4, business_user_data_access_status/4, dma_art_6_9_10_portability_and_business_data_order_status/2]).
:- use_module(m__eu_dma_art_6_9_10_portability_and_business_data_order_fixtures, [dma_art_6_9_10_portability_and_business_data_order_profile_for/2]).

listed_statement(attested(true, attestation(host_operator, '2026-11-19T10:00:00Z', listed_in_designation_decision, none))).

consent_given_statement(attested(true, attestation(host_operator, '2026-11-19T10:00:00Z', end_users_opted_in, none))).

test(application_bound_answer_holds) :-
    listed_statement(Listed),
    dma_art_6_9_10_portability_and_business_data_order_profile_for(application_listed, Profile),
    article_6_application_status(Profile, article_6_obligations_apply, [outside_fact(designated_as_gatekeeper_for_core_platform_service, Listed)], [cite(eu_reg_2022_1925_art_6_1)]).
test(portability_bound_answer_holds) :-
    listed_statement(Listed),
    dma_art_6_9_10_portability_and_business_data_order_profile_for(portability_duty_met_subject, Profile),
    end_user_data_portability_status(Profile, portability_duty_met, [outside_fact(designated_as_gatekeeper_for_core_platform_service, Listed)], [cite(eu_reg_2022_1925_art_6_1), cite(eu_reg_2022_1925_art_6_9)]).
test(portability_bound_indeterminate_holds) :-
    dma_art_6_9_10_portability_and_business_data_order_profile_for(portability_effective_absent, Profile),
    end_user_data_portability_status(Profile, indeterminate([end_user_data_portability_effective]), [], []).
test(business_bound_answer_holds) :-
    listed_statement(Listed),
    consent_given_statement(Consent),
    dma_art_6_9_10_portability_and_business_data_order_profile_for(business_personal_met, Profile),
    business_user_data_access_status(Profile, personal_data_access_duty_met, [outside_fact(designated_as_gatekeeper_for_core_platform_service, Listed), outside_fact(end_users_opted_in_to_sharing_by_consent, Consent)], [cite(eu_reg_2022_1925_art_6_1), cite(eu_reg_2022_1925_art_6_10), cite(eu_reg_2022_1925_art_2_25), cite(eu_reg_2022_1925_art_2_32)]).
test(status_holds_with_the_verdict_bound) :-
    dma_art_6_9_10_portability_and_business_data_order_profile_for(todo_baseline_subject, Profile),
    dma_art_6_9_10_portability_and_business_data_order_status(Profile, answers(article_6_obligations_apply, portability_duty_met, indeterminate([data_access_requested_by_business_user_or_authorised_third_party]))).
test(empty_profile_has_no_problem) :-
    dma_art_6_9_10_portability_and_business_data_order_input_problems([], Problems),
    Problems == [].
test(unbound_profile_is_wrong_type) :-
    dma_art_6_9_10_portability_and_business_data_order_input_problems(_, Problems),
    Problems == [wrong_type(profile)].
test(partial_list_is_wrong_type) :-
    dma_art_6_9_10_portability_and_business_data_order_input_problems([attribute(colour, blue)|_], Problems),
    Problems == [wrong_type(profile)].
test(non_attribute_element_is_wrong_type_alone) :-
    dma_art_6_9_10_portability_and_business_data_order_input_problems([attribute(colour, blue), colour], Problems),
    Problems == [wrong_type(profile)].
test(non_list_is_wrong_type) :-
    dma_art_6_9_10_portability_and_business_data_order_input_problems(colour, Problems),
    Problems == [wrong_type(profile)].
test(compound_key_is_unknown_key_as_given) :-
    dma_art_6_9_10_portability_and_business_data_order_input_problems([attribute(key(colour), true)], Problems),
    Problems == [unknown_key(key(colour))].
test(two_distinct_compound_keys_are_two_unknown_keys) :-
    dma_art_6_9_10_portability_and_business_data_order_input_problems([attribute(key(first), true), attribute(key(second), false)], Problems),
    Problems == [unknown_key(key(first)), unknown_key(key(second))].
test(number_key_is_unknown_key) :-
    dma_art_6_9_10_portability_and_business_data_order_input_problems([attribute(7, true)], Problems),
    Problems == [unknown_key(7)].
test(repeated_unknown_key_named_once) :-
    dma_art_6_9_10_portability_and_business_data_order_input_problems([attribute(colour, blue), attribute(colour, red)], Problems),
    Problems == [unknown_key(colour)].
test(unbound_value_is_wrong_type) :-
    dma_art_6_9_10_portability_and_business_data_order_input_problems([attribute(end_user_data_portability_free_of_charge, _)], Problems),
    Problems == [wrong_type(end_user_data_portability_free_of_charge)].
test(crisp_key_unsure_is_wrong_type) :-
    dma_art_6_9_10_portability_and_business_data_order_input_problems([attribute(data_access_requested_by_business_user_or_authorised_third_party, unsure)], Problems),
    Problems == [wrong_type(data_access_requested_by_business_user_or_authorised_third_party)].
test(judgement_key_unsure_is_accepted) :-
    dma_art_6_9_10_portability_and_business_data_order_input_problems([attribute(end_user_data_portability_effective, unsure)], Problems),
    Problems == [].
test(judgement_key_other_atom_is_wrong_type) :-
    dma_art_6_9_10_portability_and_business_data_order_input_problems([attribute(end_user_data_portability_effective, maybe)], Problems),
    Problems == [wrong_type(end_user_data_portability_effective)].
test(plain_boolean_outside_fact_is_wrong_type) :-
    dma_art_6_9_10_portability_and_business_data_order_input_problems([attribute(designated_as_gatekeeper_for_core_platform_service, true)], Problems),
    Problems == [wrong_type(designated_as_gatekeeper_for_core_platform_service)].
test(attested_unsure_is_wrong_type) :-
    dma_art_6_9_10_portability_and_business_data_order_input_problems([attribute(end_users_opted_in_to_sharing_by_consent, attested(unsure, attestation(host_operator, at, reason, none)))], Problems),
    Problems == [wrong_type(end_users_opted_in_to_sharing_by_consent)].
test(attestation_holding_a_variable_is_wrong_type) :-
    dma_art_6_9_10_portability_and_business_data_order_input_problems([attribute(designated_as_gatekeeper_for_core_platform_service, attested(true, attestation(host_operator, at, reason(_), none)))], Problems),
    Problems == [wrong_type(designated_as_gatekeeper_for_core_platform_service)].
test(attestation_with_three_arguments_is_wrong_type) :-
    dma_art_6_9_10_portability_and_business_data_order_input_problems([attribute(designated_as_gatekeeper_for_core_platform_service, attested(true, attestation(host_operator, at, reason)))], Problems),
    Problems == [wrong_type(designated_as_gatekeeper_for_core_platform_service)].
test(duplicate_key_with_equal_values_is_only_duplicate) :-
    dma_art_6_9_10_portability_and_business_data_order_input_problems([attribute(end_user_data_portability_free_of_charge, unsure), attribute(end_user_data_portability_free_of_charge, unsure)], Problems),
    Problems == [duplicate_key(end_user_data_portability_free_of_charge)].
test(problems_in_contract_order_then_unknown_keys) :-
    dma_art_6_9_10_portability_and_business_data_order_input_problems([attribute(colour, blue), attribute(business_user_data_access_free_of_charge, unsure), attribute(portability_requested_by_end_user_or_authorised_third_party, maybe)], Problems),
    Problems == [wrong_type(portability_requested_by_end_user_or_authorised_third_party), wrong_type(business_user_data_access_free_of_charge), unknown_key(colour)].
test(input_check_has_exactly_one_answer_for_an_unbound_profile) :-
    findall(Problems, dma_art_6_9_10_portability_and_business_data_order_input_problems(_, Problems), AllProblems),
    length(AllProblems, 1).
test(every_query_gives_bound_input_problems) :-
    article_6_application_status([attribute(colour, blue)], input_problems([unknown_key(colour)]), [], []),
    end_user_data_portability_status([attribute(colour, blue)], input_problems([unknown_key(colour)]), [], []),
    business_user_data_access_status([attribute(colour, blue)], input_problems([unknown_key(colour)]), [], []).
test(query_names_a_compound_key_as_given) :-
    business_user_data_access_status([attribute(key(colour), true)], Result, Basis, Citations),
    Result == input_problems([unknown_key(key(colour))]),
    Basis == [],
    Citations == [].

test(application_other_bound_answer_rejected, fail) :-
    dma_art_6_9_10_portability_and_business_data_order_profile_for(application_listed, Profile),
    article_6_application_status(Profile, article_6_obligations_do_not_apply, _, _).
test(portability_bound_answer_wrong_basis_rejected, fail) :-
    dma_art_6_9_10_portability_and_business_data_order_profile_for(portability_duty_met_subject, Profile),
    end_user_data_portability_status(Profile, portability_duty_met, [], _).
test(business_not_personal_answer_rejected_for_personal_data, fail) :-
    dma_art_6_9_10_portability_and_business_data_order_profile_for(business_personal_met, Profile),
    business_user_data_access_status(Profile, data_access_duty_met, _, _).
test(status_other_bound_verdict_rejected, fail) :-
    dma_art_6_9_10_portability_and_business_data_order_profile_for(todo_baseline_subject, Profile),
    dma_art_6_9_10_portability_and_business_data_order_status(Profile, answers(article_6_obligations_apply, portability_duty_not_met, _)).

cp_test_names([application_bound_answer_holds, portability_bound_answer_holds, portability_bound_indeterminate_holds, business_bound_answer_holds, status_holds_with_the_verdict_bound, empty_profile_has_no_problem, unbound_profile_is_wrong_type, partial_list_is_wrong_type, non_attribute_element_is_wrong_type_alone, non_list_is_wrong_type, compound_key_is_unknown_key_as_given, two_distinct_compound_keys_are_two_unknown_keys, number_key_is_unknown_key, repeated_unknown_key_named_once, unbound_value_is_wrong_type, crisp_key_unsure_is_wrong_type, judgement_key_unsure_is_accepted, judgement_key_other_atom_is_wrong_type, plain_boolean_outside_fact_is_wrong_type, attested_unsure_is_wrong_type, attestation_holding_a_variable_is_wrong_type, attestation_with_three_arguments_is_wrong_type, duplicate_key_with_equal_values_is_only_duplicate, problems_in_contract_order_then_unknown_keys, input_check_has_exactly_one_answer_for_an_unbound_profile, every_query_gives_bound_input_problems, query_names_a_compound_key_as_given]).
cp_test_fail_names([application_other_bound_answer_rejected, portability_bound_answer_wrong_basis_rejected, business_not_personal_answer_rejected_for_personal_data, status_other_bound_verdict_rejected]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
