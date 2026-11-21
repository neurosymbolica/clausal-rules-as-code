% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dma_art_6_9_10_portability_and_business_data_order_tests_test_queries, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_dma_art_6_9_10_portability_and_business_data_order_queries, [dma_art_6_9_10_portability_and_business_data_order_profile_keys/1, dma_art_6_9_10_portability_and_business_data_order_what_if/4, designated_as_gatekeeper_for_core_platform_service/0, portability_requested_by_end_user_or_authorised_third_party/0, data_provided_by_or_generated_through_activity_of_end_user/0, end_user_data_portability_free_of_charge/0, end_user_data_portability_effective/0, end_user_data_portability_tools_provided/0, end_user_data_continuous_real_time_access_provided/0, data_access_requested_by_business_user_or_authorised_third_party/0, data_provided_or_generated_in_use_by_business_user_and_its_end_users/0, requested_business_user_data_are_personal_data/0, personal_data_directly_connected_with_end_user_use_of_business_user_offer/0, end_users_opted_in_to_sharing_by_consent/0, business_user_data_access_free_of_charge/0, business_user_data_access_and_use_effective_and_high_quality/0, business_user_data_access_continuous_and_real_time/0, unsure/0, absent/0, not_attempted/0, article_6_obligations_apply/0, article_6_obligations_do_not_apply/0, portability_not_requested/0, data_outside_article_6_9/0, portability_duty_met/0, portability_duty_not_met/0, data_access_not_requested/0, data_outside_article_6_10/0, personal_data_access_not_required/0, personal_data_access_duty_met/0, personal_data_access_duty_not_met/0, data_access_duty_met/0, data_access_duty_not_met/0, indeterminate/1, needs_legal_review/2, input_problems/1]).
:- use_module(m__eu_dma_art_6_9_10_portability_and_business_data_order_kernel, [dma_art_6_9_10_portability_and_business_data_order_input_problems/2]).
:- use_module(m__eu_dma_art_6_9_10_portability_and_business_data_order_fixtures, [dma_art_6_9_10_portability_and_business_data_order_profile_for/2]).

consent_refused_statement(attested(false, attestation(host_operator, '2026-11-19T10:00:00Z', end_users_did_not_opt_in, none))).

test(profile_keys_are_the_contract_keys) :-
    dma_art_6_9_10_portability_and_business_data_order_profile_keys(ProfileKeys),
    ProfileKeys == [designated_as_gatekeeper_for_core_platform_service, portability_requested_by_end_user_or_authorised_third_party, data_provided_by_or_generated_through_activity_of_end_user, end_user_data_portability_free_of_charge, end_user_data_portability_effective, end_user_data_portability_tools_provided, end_user_data_continuous_real_time_access_provided, data_access_requested_by_business_user_or_authorised_third_party, data_provided_or_generated_in_use_by_business_user_and_its_end_users, requested_business_user_data_are_personal_data, personal_data_directly_connected_with_end_user_use_of_business_user_offer, end_users_opted_in_to_sharing_by_consent, business_user_data_access_free_of_charge, business_user_data_access_and_use_effective_and_high_quality, business_user_data_access_continuous_and_real_time].
test(root_key_atoms_are_exported) :-
    designated_as_gatekeeper_for_core_platform_service,
    portability_requested_by_end_user_or_authorised_third_party,
    data_provided_by_or_generated_through_activity_of_end_user,
    end_user_data_portability_free_of_charge,
    end_user_data_portability_effective,
    end_user_data_portability_tools_provided,
    end_user_data_continuous_real_time_access_provided,
    data_access_requested_by_business_user_or_authorised_third_party,
    data_provided_or_generated_in_use_by_business_user_and_its_end_users,
    requested_business_user_data_are_personal_data,
    personal_data_directly_connected_with_end_user_use_of_business_user_offer,
    end_users_opted_in_to_sharing_by_consent,
    business_user_data_access_free_of_charge,
    business_user_data_access_and_use_effective_and_high_quality,
    business_user_data_access_continuous_and_real_time.
test(root_result_atoms_are_exported) :-
    article_6_obligations_apply,
    article_6_obligations_do_not_apply,
    portability_not_requested,
    data_outside_article_6_9,
    portability_duty_met,
    portability_duty_not_met,
    data_access_not_requested,
    data_outside_article_6_10,
    personal_data_access_not_required,
    personal_data_access_duty_met,
    personal_data_access_duty_not_met,
    data_access_duty_met,
    data_access_duty_not_met.
test(root_value_atoms_are_exported) :-
    unsure,
    absent,
    not_attempted.
test(result_constructors_accept_their_shapes) :-
    indeterminate([end_user_data_portability_effective]),
    needs_legal_review(open_textured(end_user_data_portability_effective, cite(eu_reg_2022_1925_art_6_9)), [inputs_relied_on([])]),
    input_problems([unknown_key(colour)]).
test(input_check_reexported) :-
    dma_art_6_9_10_portability_and_business_data_order_input_problems([attribute(colour, blue)], Problems),
    Problems == [unknown_key(colour)].
test(what_if_supplying_the_absent_element_meets_the_duty) :-
    dma_art_6_9_10_portability_and_business_data_order_profile_for(portability_effective_absent, Profile),
    findall(Status, dma_art_6_9_10_portability_and_business_data_order_what_if(Profile, end_user_data_portability_effective, true, Status), Statuses),
    Statuses == [answers(article_6_obligations_apply, portability_duty_met, indeterminate([data_access_requested_by_business_user_or_authorised_third_party]))].
test(what_if_withdrawing_the_request) :-
    dma_art_6_9_10_portability_and_business_data_order_profile_for(portability_duty_met_subject, Profile),
    findall(Status, dma_art_6_9_10_portability_and_business_data_order_what_if(Profile, portability_requested_by_end_user_or_authorised_third_party, false, Status), Statuses),
    Statuses = [answers(article_6_obligations_apply, portability_not_requested, _)].
test(what_if_consent_refused_makes_access_not_required) :-
    consent_refused_statement(Refused),
    dma_art_6_9_10_portability_and_business_data_order_profile_for(business_personal_met, Profile),
    findall(Status, dma_art_6_9_10_portability_and_business_data_order_what_if(Profile, end_users_opted_in_to_sharing_by_consent, Refused, Status), Statuses),
    Statuses = [answers(article_6_obligations_apply, _, personal_data_access_not_required)].
test(what_if_an_ill_typed_value_gives_input_problems) :-
    findall(Status, dma_art_6_9_10_portability_and_business_data_order_what_if([], business_user_data_access_free_of_charge, unsure, Status), Statuses),
    Statuses == [answers(input_problems([wrong_type(business_user_data_access_free_of_charge)]), input_problems([wrong_type(business_user_data_access_free_of_charge)]), input_problems([wrong_type(business_user_data_access_free_of_charge)]))].

test(what_if_consent_refused_is_not_duty_met, fail) :-
    consent_refused_statement(Refused),
    dma_art_6_9_10_portability_and_business_data_order_profile_for(business_personal_met, Profile),
    dma_art_6_9_10_portability_and_business_data_order_what_if(Profile, end_users_opted_in_to_sharing_by_consent, Refused, answers(_, _, personal_data_access_duty_met)).

cp_test_names([profile_keys_are_the_contract_keys, root_key_atoms_are_exported, root_result_atoms_are_exported, root_value_atoms_are_exported, result_constructors_accept_their_shapes, input_check_reexported, what_if_supplying_the_absent_element_meets_the_duty, what_if_withdrawing_the_request, what_if_consent_refused_makes_access_not_required, what_if_an_ill_typed_value_gives_input_problems]).
cp_test_fail_names([what_if_consent_refused_is_not_duty_met]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
