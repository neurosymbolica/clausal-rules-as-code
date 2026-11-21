% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dma_art_5_2_data_combination_order_tests_test_queries, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_dma_art_5_2_data_combination_order_queries, [dma_art_5_2_data_combination_order_profile_keys/1, dma_art_5_2_data_combination_order_what_if/4, practice_allowed_with_consent/0, repeated_request_permitted/0, designated_as_gatekeeper_for_core_platform_service/0, signing_in_end_users_to_combine_personal_data/0]).
:- use_module(m__eu_dma_art_5_2_data_combination_order_kernel, [dma_art_5_2_data_combination_order_input_problems/2]).
:- use_module(m__eu_dma_art_5_2_data_combination_order_fixtures, [dma_art_5_2_data_combination_order_profile_for/2]).

stated(Truth, attested(Truth, attestation(host_operator, attested_on_2026_11_19, caller_statement, none))).

test(profile_keys_are_the_contract_keys) :-
    dma_art_5_2_data_combination_order_profile_keys(ProfileKeys),
    ProfileKeys == [designated_as_gatekeeper_for_core_platform_service, practice_under_article_5_2, end_user_presented_with_specific_choice, end_user_consent_given, gatekeeper_may_rely_on_article_6_1_c_d_or_e, consent_request_already_repeated_in_period].
test(the_input_check_is_re_exported) :-
    dma_art_5_2_data_combination_order_input_problems([attribute(colour, red)], Problems),
    Problems == [unknown_key(colour)].
test(what_if_consent_given_allows_the_practice) :-
    dma_art_5_2_data_combination_order_profile_for(listed_combining_consent_refused_control, Profile),
    stated(true, Consent),
    dma_art_5_2_data_combination_order_what_if(Profile, end_user_consent_given, Consent, Status),
    Status == practice_allowed_with_consent.
test(what_if_unlisted_service_is_not_bound) :-
    dma_art_5_2_data_combination_order_profile_for(listed_combining_with_consent, Profile),
    stated(false, Designation),
    dma_art_5_2_data_combination_order_what_if(Profile, designated_as_gatekeeper_for_core_platform_service, Designation, Status),
    Status == article_5_obligations_do_not_apply.
test(what_if_adds_an_absent_key) :-
    dma_art_5_2_data_combination_order_profile_for(practice_missing, Profile),
    dma_art_5_2_data_combination_order_what_if(Profile, practice_under_article_5_2, none_of_the_four_practices, Status),
    Status == practice_outside_article_5_2.
test(what_if_has_one_answer) :-
    dma_art_5_2_data_combination_order_profile_for(basis_absent, Profile),
    stated(true, OtherBasis),
    findall(Status, dma_art_5_2_data_combination_order_what_if(Profile, gatekeeper_may_rely_on_article_6_1_c_d_or_e, OtherBasis, Status), Statuses),
    Statuses == [practice_allowed_on_other_legal_basis].
test(what_if_a_wrong_value_gives_input_problems) :-
    dma_art_5_2_data_combination_order_what_if([], practice_under_article_5_2, maybe, Status),
    Status == input_problems([wrong_type(practice_under_article_5_2)]).
test(the_root_vocabulary_is_served) :-
    practice_allowed_with_consent,
    repeated_request_permitted,
    designated_as_gatekeeper_for_core_platform_service,
    signing_in_end_users_to_combine_personal_data.

test(what_if_on_a_non_list_has_no_answer, fail) :-
    dma_art_5_2_data_combination_order_what_if(nothing, practice_under_article_5_2, unsure, _).

cp_test_names([profile_keys_are_the_contract_keys, the_input_check_is_re_exported, what_if_consent_given_allows_the_practice, what_if_unlisted_service_is_not_bound, what_if_adds_an_absent_key, what_if_has_one_answer, what_if_a_wrong_value_gives_input_problems, the_root_vocabulary_is_served]).
cp_test_fail_names([what_if_on_a_non_list_has_no_answer]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
