% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_ai_act_penalties_tests_test_input_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_ai_act_penalties_penalties, [maximum_fine/4, general_purpose_ai_model_maximum_fine/4, penalties_status/2]).
:- use_module(m__eu_ai_act_penalties_fixtures, [penalties_profile_for/2]).
:- use_module(m__eu_ai_act_penalties_kernel, [penalties_input_problems/2]).

test(the_earlier_version_status_holds_bound) :-
    penalties_profile_for(earlier_version_day_before_pinned_text, Request),
    penalties_status(Request, no_union_maximum_determined).
test(a_determined_maximum_status_holds_bound) :-
    penalties_profile_for(pinned_text_start_day, Request),
    penalties_status(Request, union_maximum_determined).
test(a_missing_key_status_holds_bound) :-
    penalties_profile_for(offender_category_absent, Request),
    penalties_status(Request, information_missing).
test(a_review_status_holds_bound) :-
    penalties_profile_for(model_fine_intent_unsure, Request),
    penalties_status(Request, legal_review_needed).
test(a_rejected_status_holds_bound) :-
    penalties_profile_for(duplicate_infringement_key, Request),
    penalties_status(Request, input_rejected).
test(the_boundary_fixed_amount_holds_bound) :-
    maximum_fine([attribute(offender_category, other_undertaking), attribute(infringement, prohibited_practice), attribute(worldwide_annual_turnover_eur, 500000000)], date(2026, 9, 1), fine_maximum(3500000000, fixed_amount), [cite(eu_reg_2024_1689_art_99_3)]).
test(an_sme_lower_amount_holds_bound) :-
    maximum_fine([attribute(offender_category, micro_small_or_medium_sized_enterprise), attribute(infringement, prohibited_practice), attribute(worldwide_annual_turnover_eur, 499999999)], date(2026, 9, 1), fine_maximum(3499999993, turnover_percentage), [cite(eu_reg_2024_1689_art_99_3), cite(eu_reg_2024_1689_art_99_6)]).
test(a_public_authority_answer_holds_bound) :-
    maximum_fine([attribute(offender_category, public_authority_or_body), attribute(infringement, transparency_obligations_under_article_50)], date(2026, 9, 1), set_by_member_state_rules, [cite(eu_reg_2024_1689_art_99_8)]).
test(a_union_institution_cap_holds_bound) :-
    maximum_fine([attribute(offender_category, union_institution_body_office_or_agency), attribute(infringement, importer_obligations_under_article_23)], date(2026, 9, 1), fine_maximum(75000000, fixed_amount), [cite(eu_reg_2024_1689_art_100_1), cite(eu_reg_2024_1689_art_100_3)]).
test(a_model_fine_holds_bound) :-
    general_purpose_ai_model_maximum_fine([attribute(offender_is_general_purpose_ai_model_provider, true), attribute(general_purpose_ai_model_infringement, access_for_evaluation_under_article_92_not_given), attribute(provider_acted_intentionally_or_negligently, true), attribute(worldwide_annual_turnover_eur, 1000)], date(2026, 9, 1), fine_maximum(1500000000, fixed_amount), [cite(eu_reg_2024_1689_art_101_1), cite(eu_reg_2024_1689_art_101_1_d)]).
test(an_unbound_date_is_one_input_problem) :-
    findall(Maximum - Citations, maximum_fine([], _, Maximum, Citations), Answers),
    Answers == [input_problems([wrong_type(infringement_date)]) - []].
test(a_date_list_is_one_input_problem) :-
    findall(Maximum - Citations, general_purpose_ai_model_maximum_fine([], [2026, 9, 1], Maximum, Citations), Answers),
    Answers == [input_problems([wrong_type(infringement_date)]) - []].
test(an_unbound_profile_is_rejected_once) :-
    findall(Maximum, maximum_fine(_, date(2026, 9, 1), Maximum, _), Answers),
    Answers == [input_problems([wrong_type(profile)])].
test(a_partial_profile_is_rejected_once) :-
    findall(Maximum, general_purpose_ai_model_maximum_fine([attribute(offender_is_general_purpose_ai_model_provider, true)|_], date(2026, 9, 1), Maximum, _), Answers),
    Answers == [input_problems([wrong_type(profile)])].
test(an_unbound_value_is_wrong_type) :-
    findall(Maximum, maximum_fine([attribute(offender_category, _)], date(2026, 9, 1), Maximum, _), Answers),
    Answers == [input_problems([wrong_type(offender_category)])].
test(an_unread_key_is_still_checked) :-
    findall(Maximum, maximum_fine([attribute(offender_category, other_undertaking), attribute(infringement, prohibited_practice), attribute(provider_acted_intentionally_or_negligently, maybe)], date(2026, 9, 1), Maximum, _), Answers),
    Answers == [input_problems([wrong_type(provider_acted_intentionally_or_negligently)])].
test(a_string_value_is_wrong_type) :-
    penalties_input_problems([attribute(infringement, other)], Problems),
    Problems == [wrong_type(infringement)].
test(the_key_order_of_the_profile_does_not_matter) :-
    findall(Maximum, maximum_fine([attribute(worldwide_annual_turnover_eur, 1000000000), attribute(infringement, prohibited_practice), attribute(offender_category, other_undertaking)], date(2026, 9, 1), Maximum, _), Answers),
    Answers == [fine_maximum(7000000000, turnover_percentage)].

test(the_earlier_version_is_not_a_determined_maximum, fail) :-
    penalties_profile_for(earlier_version_day_before_pinned_text, Request),
    penalties_status(Request, union_maximum_determined).
test(a_review_is_not_a_determined_maximum, fail) :-
    penalties_profile_for(model_fine_intent_unsure, Request),
    penalties_status(Request, union_maximum_determined).
test(the_boundary_is_not_the_turnover_basis, fail) :-
    maximum_fine([attribute(offender_category, other_undertaking), attribute(infringement, prohibited_practice), attribute(worldwide_annual_turnover_eur, 500000000)], date(2026, 9, 1), fine_maximum(3500000000, turnover_percentage), _).
test(a_model_fine_is_not_the_sme_lower_amount, fail) :-
    general_purpose_ai_model_maximum_fine([attribute(offender_category, micro_small_or_medium_sized_enterprise), attribute(offender_is_general_purpose_ai_model_provider, true), attribute(general_purpose_ai_model_infringement, infringed_relevant_provisions), attribute(provider_acted_intentionally_or_negligently, true), attribute(worldwide_annual_turnover_eur, 100000000)], date(2026, 9, 1), fine_maximum(300000000, turnover_percentage), _).

cp_test_names([the_earlier_version_status_holds_bound, a_determined_maximum_status_holds_bound, a_missing_key_status_holds_bound, a_review_status_holds_bound, a_rejected_status_holds_bound, the_boundary_fixed_amount_holds_bound, an_sme_lower_amount_holds_bound, a_public_authority_answer_holds_bound, a_union_institution_cap_holds_bound, a_model_fine_holds_bound, an_unbound_date_is_one_input_problem, a_date_list_is_one_input_problem, an_unbound_profile_is_rejected_once, a_partial_profile_is_rejected_once, an_unbound_value_is_wrong_type, an_unread_key_is_still_checked, a_string_value_is_wrong_type, the_key_order_of_the_profile_does_not_matter]).
cp_test_fail_names([the_earlier_version_is_not_a_determined_maximum, a_review_is_not_a_determined_maximum, the_boundary_is_not_the_turnover_basis, a_model_fine_is_not_the_sme_lower_amount]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
