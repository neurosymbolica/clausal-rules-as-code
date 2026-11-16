% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_ai_act_penalties_tests_test_negative_controls, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_ai_act_penalties_penalties, [maximum_fine/4, penalties_status_values/1]).
:- use_module(m__eu_ai_act_penalties_fixtures, [penalties_assess/2]).

test(the_near_miss_statuses_are_real_verdict_atoms) :-
    penalties_status_values(StatusValues),
    member(union_maximum_determined, StatusValues),
    member(no_union_maximum_determined, StatusValues),
    member(information_missing, StatusValues),
    member(legal_review_needed, StatusValues),
    member(input_rejected, StatusValues).
test(the_day_before_the_pinned_text_is_the_earlier_version) :-
    penalties_assess(earlier_version_day_before_pinned_text, penalties_verdict(no_union_maximum_determined, earlier_version_applies, [])).
test(the_pinned_text_start_day_is_capped) :-
    penalties_assess(pinned_text_start_day, penalties_verdict(union_maximum_determined, fine_maximum(7000000000, turnover_percentage), _)).
test(a_deferred_prohibition_on_the_first_of_december_is_not_applicable) :-
    penalties_assess(deferred_prohibition_day_before_application, penalties_verdict(no_union_maximum_determined, not_applicable_on_date, [cite(eu_reg_2024_1689_art_113_a)])).
test(a_deferred_prohibition_on_the_second_of_december_is_capped) :-
    penalties_assess(deferred_prohibition_application_day, penalties_verdict(union_maximum_determined, fine_maximum(7000000000, turnover_percentage), _)).
test(the_deferral_comes_before_article_99_8) :-
    penalties_assess(deferred_prohibition_public_authority_day_before, penalties_verdict(no_union_maximum_determined, not_applicable_on_date, _)).
test(a_public_authority_from_december_is_for_member_state_rules) :-
    maximum_fine([attribute(offender_category, public_authority_or_body), attribute(infringement, prohibited_practice_under_article_5_1_ba_bb_1a_or_1b)], date(2026, 12, 2), set_by_member_state_rules, [cite(eu_reg_2024_1689_art_99_8)]).
test(a_public_authority_is_for_member_state_rules) :-
    penalties_assess(public_authority_operator_breach, penalties_verdict(no_union_maximum_determined, set_by_member_state_rules, [cite(eu_reg_2024_1689_art_99_8)])).
test(an_undertaking_with_the_same_breach_needs_the_turnover) :-
    maximum_fine([attribute(offender_category, other_undertaking), attribute(infringement, deployer_obligations_under_article_26)], date(2026, 9, 1), indeterminate([worldwide_annual_turnover_eur]), []).
test(a_public_authority_from_december_without_infringement_is_for_member_state_rules) :-
    penalties_assess(public_authority_absent_infringement_december_day, penalties_verdict(no_union_maximum_determined, set_by_member_state_rules, _)).
test(a_public_authority_before_december_without_infringement_names_it) :-
    penalties_assess(public_authority_absent_infringement_day_before_december, penalties_verdict(information_missing, indeterminate([infringement]), [])).
test(an_absent_category_is_named) :-
    penalties_assess(offender_category_absent, penalties_verdict(information_missing, indeterminate([offender_category]), [])).
test(a_union_institution_prohibition_takes_article_100_2) :-
    penalties_assess(union_institution_prohibition, penalties_verdict(union_maximum_determined, fine_maximum(150000000, fixed_amount), _)).
test(a_union_institution_information_breach_takes_article_100_3) :-
    penalties_assess(union_institution_incorrect_information, penalties_verdict(union_maximum_determined, fine_maximum(75000000, fixed_amount), _)).
test(another_provision_has_no_union_maximum) :-
    penalties_assess(other_infringement_undertaking, penalties_verdict(no_union_maximum_determined, no_union_maximum, _)).
test(an_offender_not_an_undertaking_takes_the_fixed_amount) :-
    penalties_assess(not_an_undertaking_provider_obligations, penalties_verdict(union_maximum_determined, fine_maximum(1500000000, fixed_amount), _)).
test(an_undertaking_with_that_turnover_takes_the_turnover_amount) :-
    maximum_fine([attribute(offender_category, other_undertaking), attribute(infringement, provider_obligations_under_article_16), attribute(worldwide_annual_turnover_eur, 100000000000)], date(2026, 9, 1), fine_maximum(300000000000, turnover_percentage), _).
test(an_undertaking_without_turnover_is_indeterminate) :-
    penalties_assess(undertaking_provider_obligations_without_turnover, penalties_verdict(information_missing, indeterminate([worldwide_annual_turnover_eur]), [])).
test(equal_amounts_give_the_fixed_amount) :-
    penalties_assess(prohibition_turnover_at_boundary, penalties_verdict(_, fine_maximum(3500000000, fixed_amount), _)).
test(an_sme_below_the_boundary_takes_the_lower_turnover_amount) :-
    penalties_assess(small_or_medium_enterprise_prohibition_below_boundary, penalties_verdict(_, fine_maximum(3499999993, turnover_percentage), _)).
test(an_smc_with_the_same_prohibition_takes_the_higher_fixed_amount) :-
    penalties_assess(small_mid_cap_prohibition_below_boundary, penalties_verdict(_, fine_maximum(3500000000, fixed_amount), [cite(eu_reg_2024_1689_art_99_3)])).
test(an_smc_importer_takes_the_lower_amount) :-
    penalties_assess(small_mid_cap_importer_below_boundary, penalties_verdict(_, fine_maximum(1499999997, turnover_percentage), _)).
test(a_duplicate_key_is_rejected) :-
    penalties_assess(duplicate_infringement_key, penalties_verdict(input_rejected, input_problems([duplicate_key(infringement)]), [])).
test(a_model_fine_on_the_first_of_august_is_not_applicable) :-
    penalties_assess(model_fine_day_before_application, penalties_verdict(no_union_maximum_determined, not_applicable_on_date, _)).
test(no_intent_or_negligence_gives_no_commission_fine) :-
    penalties_assess(model_fine_no_intent_or_negligence, penalties_verdict(no_union_maximum_determined, no_commission_fine, [cite(eu_reg_2024_1689_art_101_1)])).
test(an_unsure_judgement_goes_to_review) :-
    penalties_assess(model_fine_intent_unsure, penalties_verdict(legal_review_needed, needs_legal_review(_, _), [])).
test(a_missing_act_is_named_before_an_unsure_judgement) :-
    penalties_assess(model_fine_intent_unsure_act_absent, penalties_verdict(information_missing, indeterminate([general_purpose_ai_model_infringement]), [])).
test(a_model_fine_ignores_the_sme_category) :-
    penalties_assess(model_fine_ignores_small_or_medium_category, penalties_verdict(_, fine_maximum(1500000000, fixed_amount), _)).

test(the_pinned_text_start_day_is_not_the_earlier_version, fail) :-
    penalties_assess(pinned_text_start_day, penalties_verdict(_, earlier_version_applies, _)).
test(a_deferred_prohibition_on_the_second_of_december_is_applicable, fail) :-
    penalties_assess(deferred_prohibition_application_day, penalties_verdict(_, not_applicable_on_date, _)).
test(a_public_authority_from_december_is_not_deferred, fail) :-
    maximum_fine([attribute(offender_category, public_authority_or_body), attribute(infringement, prohibited_practice_under_article_5_1_ba_bb_1a_or_1b)], date(2026, 12, 2), not_applicable_on_date, _).
test(an_undertaking_with_the_same_breach_is_not_for_member_state_rules, fail) :-
    maximum_fine([attribute(offender_category, other_undertaking), attribute(infringement, deployer_obligations_under_article_26)], date(2026, 9, 1), set_by_member_state_rules, _).
test(a_public_authority_before_december_without_infringement_is_not_settled, fail) :-
    penalties_assess(public_authority_absent_infringement_day_before_december, penalties_verdict(_, set_by_member_state_rules, _)).
test(a_present_category_is_not_named, fail) :-
    penalties_assess(pinned_text_start_day, penalties_verdict(information_missing, _, _)).
test(a_union_institution_information_breach_does_not_take_article_100_2, fail) :-
    penalties_assess(union_institution_incorrect_information, penalties_verdict(_, fine_maximum(150000000, _), _)).
test(a_union_institution_prohibition_does_not_take_article_100_3, fail) :-
    penalties_assess(union_institution_prohibition, penalties_verdict(_, fine_maximum(75000000, _), _)).
test(a_listed_provision_has_a_union_maximum, fail) :-
    penalties_assess(distributor_undertaking, penalties_verdict(_, no_union_maximum, _)).
test(an_undertaking_with_that_turnover_does_not_take_the_fixed_amount, fail) :-
    maximum_fine([attribute(offender_category, other_undertaking), attribute(infringement, provider_obligations_under_article_16), attribute(worldwide_annual_turnover_eur, 100000000000)], date(2026, 9, 1), fine_maximum(_, fixed_amount), _).
test(an_undertaking_with_turnover_is_not_indeterminate, fail) :-
    penalties_assess(distributor_undertaking, penalties_verdict(information_missing, _, _)).
test(one_euro_above_the_boundary_is_not_the_fixed_amount, fail) :-
    penalties_assess(prohibition_turnover_above_boundary, penalties_verdict(_, fine_maximum(_, fixed_amount), _)).
test(an_smc_with_the_same_prohibition_does_not_take_the_lower_amount, fail) :-
    penalties_assess(small_mid_cap_prohibition_below_boundary, penalties_verdict(_, fine_maximum(_, turnover_percentage), _)).
test(a_single_key_is_not_rejected, fail) :-
    maximum_fine([attribute(infringement, prohibited_practice)], date(2026, 9, 1), input_problems(_), _).
test(a_model_fine_on_the_second_of_august_is_applicable, fail) :-
    penalties_assess(model_fine_application_day, penalties_verdict(_, not_applicable_on_date, _)).
test(settled_intent_does_not_give_no_commission_fine, fail) :-
    penalties_assess(model_fine_intent_settled, penalties_verdict(_, no_commission_fine, _)).
test(a_settled_judgement_does_not_go_to_review, fail) :-
    penalties_assess(model_fine_intent_settled, penalties_verdict(legal_review_needed, _, _)).
test(a_complete_unsure_case_is_not_missing_information, fail) :-
    penalties_assess(model_fine_intent_unsure, penalties_verdict(information_missing, _, _)).
test(a_model_fine_is_not_lowered_for_an_sme, fail) :-
    penalties_assess(model_fine_ignores_small_or_medium_category, penalties_verdict(_, fine_maximum(300000000, turnover_percentage), _)).

cp_test_names([the_near_miss_statuses_are_real_verdict_atoms, the_day_before_the_pinned_text_is_the_earlier_version, the_pinned_text_start_day_is_capped, a_deferred_prohibition_on_the_first_of_december_is_not_applicable, a_deferred_prohibition_on_the_second_of_december_is_capped, the_deferral_comes_before_article_99_8, a_public_authority_from_december_is_for_member_state_rules, a_public_authority_is_for_member_state_rules, an_undertaking_with_the_same_breach_needs_the_turnover, a_public_authority_from_december_without_infringement_is_for_member_state_rules, a_public_authority_before_december_without_infringement_names_it, an_absent_category_is_named, a_union_institution_prohibition_takes_article_100_2, a_union_institution_information_breach_takes_article_100_3, another_provision_has_no_union_maximum, an_offender_not_an_undertaking_takes_the_fixed_amount, an_undertaking_with_that_turnover_takes_the_turnover_amount, an_undertaking_without_turnover_is_indeterminate, equal_amounts_give_the_fixed_amount, an_sme_below_the_boundary_takes_the_lower_turnover_amount, an_smc_with_the_same_prohibition_takes_the_higher_fixed_amount, an_smc_importer_takes_the_lower_amount, a_duplicate_key_is_rejected, a_model_fine_on_the_first_of_august_is_not_applicable, no_intent_or_negligence_gives_no_commission_fine, an_unsure_judgement_goes_to_review, a_missing_act_is_named_before_an_unsure_judgement, a_model_fine_ignores_the_sme_category]).
cp_test_fail_names([the_pinned_text_start_day_is_not_the_earlier_version, a_deferred_prohibition_on_the_second_of_december_is_applicable, a_public_authority_from_december_is_not_deferred, an_undertaking_with_the_same_breach_is_not_for_member_state_rules, a_public_authority_before_december_without_infringement_is_not_settled, a_present_category_is_not_named, a_union_institution_information_breach_does_not_take_article_100_2, a_union_institution_prohibition_does_not_take_article_100_3, a_listed_provision_has_a_union_maximum, an_undertaking_with_that_turnover_does_not_take_the_fixed_amount, an_undertaking_with_turnover_is_not_indeterminate, one_euro_above_the_boundary_is_not_the_fixed_amount, an_smc_with_the_same_prohibition_does_not_take_the_lower_amount, a_single_key_is_not_rejected, a_model_fine_on_the_second_of_august_is_applicable, settled_intent_does_not_give_no_commission_fine, a_settled_judgement_does_not_go_to_review, a_complete_unsure_case_is_not_missing_information, a_model_fine_is_not_lowered_for_an_sme]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
