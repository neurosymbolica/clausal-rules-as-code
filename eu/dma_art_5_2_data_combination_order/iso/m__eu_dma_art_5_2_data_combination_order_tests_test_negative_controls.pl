% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dma_art_5_2_data_combination_order_tests_test_negative_controls, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_dma_art_5_2_data_combination_order_kernel, [dma_art_5_2_data_combination_order_input_problems/2]).
:- use_module(m__eu_dma_art_5_2_data_combination_order_dma_art_5_2_data_combination_order, [article_5_application_status/4, consent_request_repetition_status/6, dma_art_5_2_data_combination_order_status/2, dma_art_5_2_data_combination_order_status_values/1]).
:- use_module(m__eu_dma_art_5_2_data_combination_order_fixtures, [dma_art_5_2_data_combination_order_profile_for/2]).

subject_status(Subject, Status) :-
    dma_art_5_2_data_combination_order_profile_for(Subject, Profile),
    dma_art_5_2_data_combination_order_status(Profile, Status).

repetition_result(Subject, RequestDate, Result) :-
    dma_art_5_2_data_combination_order_profile_for(Subject, Profile),
    consent_request_repetition_status(Profile, date(2025, 3, 10), RequestDate, Result, _, _).

test(the_status_table_has_a_near_miss_atom) :-
    dma_art_5_2_data_combination_order_status_values(StatusValues),
    StatusValues = [_, _|_].
test(the_near_miss_atoms_are_table_atoms) :-
    dma_art_5_2_data_combination_order_status_values(StatusValues),
    member(practice_allowed_with_consent, StatusValues),
    member(practice_allowed_on_other_legal_basis, StatusValues),
    member(practice_prohibited, StatusValues),
    member(practice_outside_article_5_2, StatusValues),
    member(article_5_obligations_do_not_apply, StatusValues).
test(consent_route_positive) :-
    subject_status(listed_combining_with_consent, practice_allowed_with_consent).
test(consent_route_near_miss_is_prohibited) :-
    subject_status(listed_combining_consent_refused_control, practice_prohibited).
test(other_basis_route_positive) :-
    subject_status(listed_cross_use_no_choice_legal_obligation, practice_allowed_on_other_legal_basis).
test(other_basis_route_near_miss_is_prohibited) :-
    subject_status(listed_cross_use_no_choice_no_basis_control, practice_prohibited).
test(prohibited_route_positive) :-
    subject_status(listed_sign_in_consent_refused_no_basis, practice_prohibited).
test(prohibited_route_near_miss_is_allowed_with_consent) :-
    subject_status(listed_sign_in_consent_given_control, practice_allowed_with_consent).
test(outside_route_positive) :-
    subject_status(listed_none_of_the_four, practice_outside_article_5_2).
test(outside_route_near_miss_is_allowed_with_consent) :-
    subject_status(listed_advertising_with_consent_control, practice_allowed_with_consent).
test(not_listed_route_positive) :-
    subject_status(not_listed_everything_unsure, article_5_obligations_do_not_apply).
test(not_listed_route_near_miss_goes_to_a_lawyer) :-
    subject_status(listed_everything_unsure_control, needs_legal_review(open_textured(practice_under_article_5_2, cite(eu_reg_2022_1925_art_5_2)), _)).
test(choice_named_route_positive) :-
    subject_status(choice_missing, indeterminate([end_user_presented_with_specific_choice])).
test(choice_named_route_near_miss_is_allowed_on_other_basis) :-
    subject_status(choice_missing_consent_refused_basis_true, practice_allowed_on_other_legal_basis).
test(consent_referral_route_positive) :-
    subject_status(consent_absent, needs_legal_review(cross_reference_unresolved(cite(eu_reg_2022_1925_art_5_2), cite(digital_markets_end_user_consent_statement)), _)).
test(consent_referral_route_near_miss_is_prohibited) :-
    subject_status(consent_absent_choice_false_control, practice_prohibited).
test(basis_referral_route_positive) :-
    subject_status(basis_absent, needs_legal_review(cross_reference_unresolved(cite(eu_reg_2022_1925_art_5_2), cite(digital_markets_article_6_1_c_d_e_basis_statement)), _)).
test(basis_referral_route_near_miss_is_allowed_on_other_basis) :-
    subject_status(basis_given_control, practice_allowed_on_other_legal_basis).
test(application_route_positive) :-
    dma_art_5_2_data_combination_order_profile_for(repeat_listed_not_yet_repeated, Profile),
    article_5_application_status(Profile, article_5_obligations_apply, _, _).
test(application_route_near_miss_is_do_not_apply) :-
    dma_art_5_2_data_combination_order_profile_for(repeat_not_listed, Profile),
    article_5_application_status(Profile, article_5_obligations_do_not_apply, _, _).
test(within_period_route_positive) :-
    repetition_result(repeat_listed_not_yet_repeated, date(2026, 3, 9), repeated_request_permitted).
test(within_period_route_near_miss_is_after_the_period) :-
    repetition_result(repeat_listed_not_yet_repeated, date(2026, 3, 10), request_after_one_year_period).
test(limit_route_positive) :-
    repetition_result(repeat_listed_already_repeated, date(2025, 9, 1), repeated_request_not_permitted).
test(limit_route_near_miss_is_permitted) :-
    repetition_result(repeat_listed_not_yet_repeated, date(2025, 9, 1), repeated_request_permitted).
test(repetition_not_listed_positive) :-
    repetition_result(repeat_not_listed, date(2025, 9, 1), article_5_obligations_do_not_apply).
test(input_route_positive) :-
    dma_art_5_2_data_combination_order_input_problems([attribute(practice_under_article_5_2, combining_personal_data)], Problems),
    Problems == [].
test(input_route_near_miss_is_a_duplicate) :-
    dma_art_5_2_data_combination_order_input_problems([attribute(practice_under_article_5_2, combining_personal_data), attribute(practice_under_article_5_2, combining_personal_data)], [duplicate_key(practice_under_article_5_2)]).

test(consent_route_near_miss_is_not_allowed, fail) :-
    subject_status(listed_combining_consent_refused_control, practice_allowed_with_consent).
test(other_basis_route_near_miss_is_not_allowed, fail) :-
    subject_status(listed_cross_use_no_choice_no_basis_control, practice_allowed_on_other_legal_basis).
test(prohibited_route_near_miss_is_not_prohibited, fail) :-
    subject_status(listed_sign_in_consent_given_control, practice_prohibited).
test(outside_route_near_miss_is_not_outside, fail) :-
    subject_status(listed_advertising_with_consent_control, practice_outside_article_5_2).
test(not_listed_route_near_miss_applies, fail) :-
    subject_status(listed_everything_unsure_control, article_5_obligations_do_not_apply).
test(choice_named_route_near_miss_does_not_name_it, fail) :-
    subject_status(choice_missing_consent_refused_basis_true, indeterminate([end_user_presented_with_specific_choice])).
test(consent_referral_route_near_miss_is_not_referred, fail) :-
    subject_status(consent_absent_choice_false_control, needs_legal_review(_, _)).
test(basis_referral_route_near_miss_is_not_referred, fail) :-
    subject_status(basis_given_control, needs_legal_review(_, _)).
test(application_route_near_miss_does_not_apply, fail) :-
    dma_art_5_2_data_combination_order_profile_for(repeat_not_listed, Profile),
    article_5_application_status(Profile, article_5_obligations_apply, _, _).
test(within_period_route_near_miss_is_not_permitted, fail) :-
    repetition_result(repeat_listed_not_yet_repeated, date(2026, 3, 10), repeated_request_permitted).
test(limit_route_near_miss_is_not_refused, fail) :-
    repetition_result(repeat_listed_not_yet_repeated, date(2025, 9, 1), repeated_request_not_permitted).
test(repetition_not_listed_near_miss_applies, fail) :-
    repetition_result(repeat_listed_not_yet_repeated, date(2025, 9, 1), article_5_obligations_do_not_apply).
test(input_route_near_miss_has_problems, fail) :-
    dma_art_5_2_data_combination_order_input_problems([attribute(practice_under_article_5_2, combining_personal_data), attribute(practice_under_article_5_2, combining_personal_data)], []).

cp_test_names([the_status_table_has_a_near_miss_atom, the_near_miss_atoms_are_table_atoms, consent_route_positive, consent_route_near_miss_is_prohibited, other_basis_route_positive, other_basis_route_near_miss_is_prohibited, prohibited_route_positive, prohibited_route_near_miss_is_allowed_with_consent, outside_route_positive, outside_route_near_miss_is_allowed_with_consent, not_listed_route_positive, not_listed_route_near_miss_goes_to_a_lawyer, choice_named_route_positive, choice_named_route_near_miss_is_allowed_on_other_basis, consent_referral_route_positive, consent_referral_route_near_miss_is_prohibited, basis_referral_route_positive, basis_referral_route_near_miss_is_allowed_on_other_basis, application_route_positive, application_route_near_miss_is_do_not_apply, within_period_route_positive, within_period_route_near_miss_is_after_the_period, limit_route_positive, limit_route_near_miss_is_permitted, repetition_not_listed_positive, input_route_positive, input_route_near_miss_is_a_duplicate]).
cp_test_fail_names([consent_route_near_miss_is_not_allowed, other_basis_route_near_miss_is_not_allowed, prohibited_route_near_miss_is_not_prohibited, outside_route_near_miss_is_not_outside, not_listed_route_near_miss_applies, choice_named_route_near_miss_does_not_name_it, consent_referral_route_near_miss_is_not_referred, basis_referral_route_near_miss_is_not_referred, application_route_near_miss_does_not_apply, within_period_route_near_miss_is_not_permitted, limit_route_near_miss_is_not_refused, repetition_not_listed_near_miss_applies, input_route_near_miss_has_problems]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
