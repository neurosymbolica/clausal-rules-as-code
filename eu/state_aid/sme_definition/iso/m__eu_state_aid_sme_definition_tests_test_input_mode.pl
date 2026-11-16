% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_state_aid_sme_definition_tests_test_input_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_state_aid_sme_definition_kernel, [sme_definition_input_problems/2]).
:- use_module(m__eu_state_aid_sme_definition_sme_definition, [size_class/4, sme_status/4, at_least_medium/4, period_size_class/4, relationship_type/4, sme_definition_status/2, partner_enterprise_data/4, linked_enterprise_data/3, indeterminate/1, needs_legal_review/2, input_problems/1, unknown_key/1, wrong_type/1, duplicate_key/1]).
:- use_module(m__eu_state_aid_sme_definition_fixtures, [sme_definition_profile_for/2]).

micro_profile([attribute(own_staff_annual_work_units_hundredths, 500), attribute(own_annual_turnover_cents, 100000000), attribute(own_annual_balance_sheet_total_cents, 100000000), attribute(partner_enterprises, []), attribute(linked_enterprises, [])]).

large_estimate_profile([attribute(is_enterprise, true), attribute(public_bodies_control_25_percent_or_more, false), attribute(own_staff_annual_work_units_hundredths, 30000), attribute(accounting_basis, bona_fide_estimate)]).

test(period_class_holds_with_the_answer_bound) :-
    micro_profile(Profile),
    sort([cite(eu_rec_2003_361_annex_art_2_3), cite(eu_rec_2003_361_annex_art_5), cite(eu_rec_2003_361_annex_art_6_1)], Citations),
    period_size_class(recommendation_2003_361_annex, Profile, micro_enterprise, Citations).
test(not_an_enterprise_holds_with_the_answer_bound) :-
    size_class(gber_annex_i, [attribute(is_enterprise, false)], not_an_enterprise, [cite(eu_reg_651_2014_annex_i_art_1_t1)]).
test(not_sme_holds_with_the_answer_bound) :-
    large_estimate_profile(Profile),
    sort([cite(eu_rec_2003_361_annex_art_2_1), cite(eu_rec_2003_361_annex_art_5), cite(eu_rec_2003_361_annex_art_4_3)], Citations),
    sme_status(recommendation_2003_361_annex, Profile, not_sme, Citations).
test(at_least_medium_holds_with_the_answer_bound) :-
    sme_definition_profile_for(staff_at_small_ceiling_is_at_least_medium, query(_, Text, Profile)),
    at_least_medium(Text, Profile, at_least_medium, _).
test(linked_holds_with_the_answer_bound) :-
    sort([cite(eu_rec_2003_361_annex_art_3_3), cite(eu_rec_2003_361_annex_art_3_t9)], Citations),
    relationship_type(recommendation_2003_361_annex, [attribute(majority_of_voting_rights, true), attribute(relationship_only_through_natural_persons, false)], linked_enterprise, Citations).
test(partner_status_holds_with_the_answer_bound) :-
    sme_definition_profile_for(holding_at_partner_threshold, Request),
    sme_definition_status(Request, partner_enterprise).
test(an_indeterminate_answer_holds_bound) :-
    period_size_class(recommendation_2003_361_annex, [attribute(own_staff_annual_work_units_hundredths, 500), attribute(own_annual_turnover_cents, 100000000), attribute(own_annual_balance_sheet_total_cents, 100000000), attribute(partner_enterprises, [])], indeterminate([linked_enterprises]), []).
test(an_atom_profile_is_wrong_type) :-
    sme_definition_input_problems(not_a_list, [wrong_type(profile)]).
test(a_non_attribute_element_is_wrong_type_alone) :-
    sme_definition_input_problems([attribute(colour, red), colour], [wrong_type(profile)]).
test(a_float_figure_is_wrong_type) :-
    sme_definition_input_problems([attribute(own_staff_annual_work_units_hundredths, 1.5)], [wrong_type(own_staff_annual_work_units_hundredths)]).
test(a_negative_holding_is_wrong_type) :-
    sme_definition_input_problems([attribute(holding_basis_points, -1)], [wrong_type(holding_basis_points)]).
test(unsure_is_not_a_boolean_value) :-
    sme_definition_input_problems([attribute(public_bodies_control_25_percent_or_more, unsure)], [wrong_type(public_bodies_control_25_percent_or_more)]).
test(unsure_is_a_judgement_value) :-
    sme_definition_input_problems([attribute(same_or_adjacent_market, unsure)], []).
test(an_unknown_enumeration_atom_is_wrong_type) :-
    sme_definition_input_problems([attribute(investor_category, hedge_fund)], [wrong_type(investor_category)]).
test(a_number_key_is_unknown) :-
    sme_definition_input_problems([attribute(42, x)], [unknown_key(42)]).
test(an_unknown_key_repeated_is_named_once) :-
    sme_definition_input_problems([attribute(colour, red), attribute(colour, blue)], [unknown_key(colour)]).
test(equal_duplicate_values_are_still_a_duplicate) :-
    sme_definition_input_problems([attribute(is_enterprise, true), attribute(is_enterprise, true)], [duplicate_key(is_enterprise)]).
test(problems_come_in_contract_order_then_unknown_keys) :-
    sme_definition_input_problems([attribute(colour, red), attribute(holding_basis_points, -1), attribute(is_enterprise, maybe)], Problems),
    Problems == [wrong_type(is_enterprise), wrong_type(holding_basis_points), unknown_key(colour)].
test(an_unbound_profile_is_wrong_type) :-
    findall(Problems, sme_definition_input_problems(_, Problems), Answers),
    Answers == [[wrong_type(profile)]].
test(a_partial_list_profile_is_wrong_type) :-
    findall(Problems, sme_definition_input_problems([attribute(is_enterprise, true)|_], Problems), Answers),
    Answers == [[wrong_type(profile)]].
test(a_partner_list_with_an_unbound_tail_is_wrong_type) :-
    findall(Problems, sme_definition_input_problems([attribute(partner_enterprises, [partner_enterprise_data(2500, 100, 1000, 1000)|_])], Problems), Answers),
    Answers == [[wrong_type(partner_enterprises)]].
test(an_unbound_value_is_wrong_type) :-
    findall(Problems, sme_definition_input_problems([attribute(is_enterprise, _)], Problems), Answers),
    Answers == [[wrong_type(is_enterprise)]].
test(a_wrong_text_comes_first) :-
    size_class(directive_unknown, [attribute(is_enterprise, maybe)], input_problems([wrong_type(text), wrong_type(is_enterprise)]), []).
test(an_unbound_text_is_wrong_type) :-
    findall(Result - Citations, size_class(_, [], Result, Citations), Answers),
    Answers == [input_problems([wrong_type(text)]) - []].
test(a_duplicate_key_is_an_input_problem_of_the_query) :-
    size_class(recommendation_2003_361_annex, [attribute(is_enterprise, false), attribute(is_enterprise, true)], input_problems([duplicate_key(is_enterprise)]), []).
test(input_problems_come_before_a_settled_answer) :-
    size_class(recommendation_2003_361_annex, [attribute(is_enterprise, false), attribute(colour, red)], input_problems([unknown_key(colour)]), []).
test(a_key_the_query_does_not_read_is_still_checked) :-
    period_size_class(recommendation_2003_361_annex, [attribute(investor_category, hedge_fund)], input_problems([wrong_type(investor_category)]), []).
test(the_partner_item_constructor_holds) :-
    partner_enterprise_data(2500, 100, 1000, 2000).
test(the_linked_item_constructor_holds) :-
    linked_enterprise_data(10, 20, 30).
test(the_indeterminate_constructor_holds) :-
    indeterminate([accounting_basis]).
test(the_referral_constructor_holds) :-
    needs_legal_review(open_textured(is_enterprise, cite(eu_rec_2003_361_annex_art_1_t1)), [inputs_relied_on([is_enterprise - unsure])]).
test(the_input_problems_constructor_holds) :-
    input_problems([wrong_type(text)]).
test(the_unknown_key_constructor_holds) :-
    unknown_key(colour).
test(the_wrong_type_constructor_holds) :-
    wrong_type(is_enterprise).
test(the_duplicate_key_constructor_holds) :-
    duplicate_key(is_enterprise).

test(the_wrong_bound_period_class_is_rejected, fail) :-
    micro_profile(Profile),
    period_size_class(recommendation_2003_361_annex, Profile, small_enterprise, _).
test(not_an_enterprise_is_not_a_class, fail) :-
    size_class(gber_annex_i, [attribute(is_enterprise, false)], micro_enterprise, _).
test(the_recommendation_citation_is_rejected_under_gber, fail) :-
    size_class(gber_annex_i, [attribute(is_enterprise, false)], not_an_enterprise, [cite(eu_rec_2003_361_annex_art_1_t1)]).
test(sme_is_rejected_above_the_staff_ceiling, fail) :-
    large_estimate_profile(Profile),
    sme_status(recommendation_2003_361_annex, Profile, sme, _).
test(below_medium_is_rejected_at_the_small_staff_ceiling, fail) :-
    sme_definition_profile_for(staff_at_small_ceiling_is_at_least_medium, query(_, Text, Profile)),
    at_least_medium(Text, Profile, below_medium, _).
test(partner_is_rejected_for_a_majority_of_voting_rights, fail) :-
    relationship_type(recommendation_2003_361_annex, [attribute(majority_of_voting_rights, true), attribute(relationship_only_through_natural_persons, false)], partner_enterprise, _).
test(neither_is_rejected_at_the_partner_threshold, fail) :-
    sme_definition_profile_for(holding_at_partner_threshold, Request),
    sme_definition_status(Request, neither_partner_nor_linked).
test(another_missing_key_is_not_named, fail) :-
    period_size_class(recommendation_2003_361_annex, [attribute(own_staff_annual_work_units_hundredths, 500), attribute(own_annual_turnover_cents, 100000000), attribute(own_annual_balance_sheet_total_cents, 100000000), attribute(partner_enterprises, [])], indeterminate([partner_enterprises]), _).
test(a_profile_with_a_problem_gets_no_class, fail) :-
    size_class(recommendation_2003_361_annex, [attribute(is_enterprise, false), attribute(colour, red)], not_an_enterprise, _).
test(the_partner_item_constructor_needs_integers, fail) :-
    partner_enterprise_data(2500, 100, 1000, 2.5).
test(the_linked_item_constructor_needs_integers, fail) :-
    linked_enterprise_data(10, 20, 3.5).
test(the_indeterminate_constructor_needs_a_list, fail) :-
    indeterminate(accounting_basis).
test(the_referral_constructor_needs_a_context_list, fail) :-
    needs_legal_review(open_textured(is_enterprise, cite(eu_rec_2003_361_annex_art_1_t1)), inputs_relied_on([is_enterprise - unsure])).
test(the_input_problems_constructor_needs_a_list, fail) :-
    input_problems(wrong_type(text)).
test(the_duplicate_key_constructor_needs_an_atom, fail) :-
    duplicate_key(42).

cp_test_names([period_class_holds_with_the_answer_bound, not_an_enterprise_holds_with_the_answer_bound, not_sme_holds_with_the_answer_bound, at_least_medium_holds_with_the_answer_bound, linked_holds_with_the_answer_bound, partner_status_holds_with_the_answer_bound, an_indeterminate_answer_holds_bound, an_atom_profile_is_wrong_type, a_non_attribute_element_is_wrong_type_alone, a_float_figure_is_wrong_type, a_negative_holding_is_wrong_type, unsure_is_not_a_boolean_value, unsure_is_a_judgement_value, an_unknown_enumeration_atom_is_wrong_type, a_number_key_is_unknown, an_unknown_key_repeated_is_named_once, equal_duplicate_values_are_still_a_duplicate, problems_come_in_contract_order_then_unknown_keys, an_unbound_profile_is_wrong_type, a_partial_list_profile_is_wrong_type, a_partner_list_with_an_unbound_tail_is_wrong_type, an_unbound_value_is_wrong_type, a_wrong_text_comes_first, an_unbound_text_is_wrong_type, a_duplicate_key_is_an_input_problem_of_the_query, input_problems_come_before_a_settled_answer, a_key_the_query_does_not_read_is_still_checked, the_partner_item_constructor_holds, the_linked_item_constructor_holds, the_indeterminate_constructor_holds, the_referral_constructor_holds, the_input_problems_constructor_holds, the_unknown_key_constructor_holds, the_wrong_type_constructor_holds, the_duplicate_key_constructor_holds]).
cp_test_fail_names([the_wrong_bound_period_class_is_rejected, not_an_enterprise_is_not_a_class, the_recommendation_citation_is_rejected_under_gber, sme_is_rejected_above_the_staff_ceiling, below_medium_is_rejected_at_the_small_staff_ceiling, partner_is_rejected_for_a_majority_of_voting_rights, neither_is_rejected_at_the_partner_threshold, another_missing_key_is_not_named, a_profile_with_a_problem_gets_no_class, the_partner_item_constructor_needs_integers, the_linked_item_constructor_needs_integers, the_indeterminate_constructor_needs_a_list, the_referral_constructor_needs_a_context_list, the_input_problems_constructor_needs_a_list, the_duplicate_key_constructor_needs_an_atom]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
