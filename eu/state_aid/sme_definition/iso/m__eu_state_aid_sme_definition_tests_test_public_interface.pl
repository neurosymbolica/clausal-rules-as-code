% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_state_aid_sme_definition_tests_test_public_interface, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_lists, [msort/2]).
:- use_module(m__eu_state_aid_sme_definition_sme_definition, [decide_sme_definition/2, sme_definition_status/2, sme_definition_checklist/2, sme_definition_decision_resolvable/1, sme_definition_status_values/1, period_size_class/4, size_class/4, sme_status/4, relationship_type/4, provenance/2]).
:- use_module(m__eu_state_aid_sme_definition_fixtures, [sme_definition_subject/1, sme_definition_profile_for/2, sme_definition_assess/2]).

expected_result(micro_staff_just_below_ceiling, micro_enterprise).
expected_result(micro_staff_at_ceiling, small_enterprise).
expected_result(micro_turnover_at_ceiling, micro_enterprise).
expected_result(micro_turnover_one_cent_above_ceiling, small_enterprise).
expected_result(micro_balance_sheet_at_ceiling, micro_enterprise).
expected_result(micro_balance_sheet_one_cent_above_ceiling, small_enterprise).
expected_result(small_staff_just_below_ceiling, small_enterprise).
expected_result(small_staff_at_ceiling, medium_sized_enterprise).
expected_result(small_turnover_at_ceiling, small_enterprise).
expected_result(small_turnover_one_cent_above_ceiling, medium_sized_enterprise).
expected_result(small_balance_sheet_at_ceiling, small_enterprise).
expected_result(small_balance_sheet_one_cent_above_ceiling, medium_sized_enterprise).
expected_result(medium_staff_just_below_ceiling, medium_sized_enterprise).
expected_result(medium_staff_at_ceiling, large_enterprise).
expected_result(medium_turnover_at_ceiling, medium_sized_enterprise).
expected_result(medium_turnover_one_cent_above_ceiling, large_enterprise).
expected_result(medium_balance_sheet_at_ceiling, medium_sized_enterprise).
expected_result(medium_balance_sheet_one_cent_above_ceiling, large_enterprise).
expected_result(partner_share_lifts_staff_to_ceiling, small_enterprise).
expected_result(partner_share_one_point_below, micro_enterprise).
expected_result(linked_staff_lifts_to_ceiling, small_enterprise).
expected_result(linked_staff_one_hundredth_below, micro_enterprise).
expected_result(linked_list_not_given, indeterminate([linked_enterprises])).
expected_result(entity_not_an_enterprise, not_an_enterprise).
expected_result(enterprise_status_unsure_under_public_control, needs_legal_review(open_textured(is_enterprise, cite(eu_rec_2003_361_annex_art_1_t1)), [inputs_relied_on([is_enterprise - unsure])])).
expected_result(public_body_control_reached, not_sme_public_control).
expected_result(public_body_control_not_reached, micro_enterprise).
expected_result(two_periods_held_micro_kept, micro_enterprise).
expected_result(two_periods_held_small_kept, small_enterprise).
expected_result(two_periods_both_small, small_enterprise).
expected_result(sme_staff_just_below_medium_ceiling, sme).
expected_result(sme_staff_at_medium_ceiling, not_sme).
expected_result(sme_under_public_control, not_sme).
expected_result(staff_just_below_small_ceiling_is_below_medium, below_medium).
expected_result(staff_at_small_ceiling_is_at_least_medium, at_least_medium).
expected_result(majority_of_voting_rights_links, linked_enterprise).
expected_result(holding_at_partner_threshold, partner_enterprise).
expected_result(holding_one_point_below_partner_threshold, neither_partner_nor_linked).
expected_result(business_angels_one_cent_below_limit, neither_partner_nor_linked).
expected_result(business_angels_at_limit, partner_enterprise).
expected_result(local_authority_within_limits, neither_partner_nor_linked).
expected_result(local_authority_inhabitants_at_limit, partner_enterprise).
expected_result(local_authority_budget_at_limit, partner_enterprise).
expected_result(presumed_investor_not_involved_in_management, neither_partner_nor_linked).
expected_result(investor_involved_in_management_links, linked_enterprise).
expected_result(natural_persons_in_same_market, linked_enterprise).
expected_result(natural_persons_in_other_market, neither_partner_nor_linked).
expected_result(dominant_influence_unsure, needs_legal_review(open_textured(dominant_influence_by_contract_or_articles, cite(eu_reg_651_2014_annex_i_art_3_3_c)), [inputs_relied_on([dominant_influence_by_contract_or_articles - unsure])])).
expected_result(unknown_text, input_problems([wrong_type(text)])).

near_miss(micro_staff_just_below_ceiling, micro_staff_at_ceiling).
near_miss(micro_turnover_at_ceiling, micro_turnover_one_cent_above_ceiling).
near_miss(micro_balance_sheet_at_ceiling, micro_balance_sheet_one_cent_above_ceiling).
near_miss(small_staff_just_below_ceiling, small_staff_at_ceiling).
near_miss(small_turnover_at_ceiling, small_turnover_one_cent_above_ceiling).
near_miss(small_balance_sheet_at_ceiling, small_balance_sheet_one_cent_above_ceiling).
near_miss(medium_staff_just_below_ceiling, medium_staff_at_ceiling).
near_miss(medium_turnover_at_ceiling, medium_turnover_one_cent_above_ceiling).
near_miss(medium_balance_sheet_at_ceiling, medium_balance_sheet_one_cent_above_ceiling).
near_miss(partner_share_lifts_staff_to_ceiling, partner_share_one_point_below).
near_miss(linked_staff_lifts_to_ceiling, linked_staff_one_hundredth_below).
near_miss(public_body_control_reached, public_body_control_not_reached).
near_miss(two_periods_held_micro_kept, two_periods_held_small_kept).
near_miss(sme_staff_just_below_medium_ceiling, sme_staff_at_medium_ceiling).
near_miss(staff_just_below_small_ceiling_is_below_medium, staff_at_small_ceiling_is_at_least_medium).
near_miss(holding_at_partner_threshold, holding_one_point_below_partner_threshold).
near_miss(business_angels_one_cent_below_limit, business_angels_at_limit).
near_miss(local_authority_within_limits, local_authority_inhabitants_at_limit).
near_miss(local_authority_within_limits, local_authority_budget_at_limit).
near_miss(presumed_investor_not_involved_in_management, investor_involved_in_management_links).
near_miss(natural_persons_in_same_market, natural_persons_in_other_market).

result_of(Subject, Expected) :-
    findall(Result, sme_definition_assess(Subject, sme_definition_verdict(Result, _)), Results),
    Results == [Expected].

resolves_as_expected(Subject) :-
    expected_result(Subject, Expected),
    result_of(Subject, Expected).

citations_of(Subject, ExpectedCitations) :-
    sme_definition_assess(Subject, sme_definition_verdict(_, Citations)),
    sort(ExpectedCitations, SortedCitations),
    Citations == SortedCitations.

has_checklist(Subject) :-
    sme_definition_profile_for(Subject, Request),
    sme_definition_checklist(Request, [item(determination, _, _)|_]).

is_resolvable(Subject) :-
    sme_definition_profile_for(Subject, Request),
    sme_definition_decision_resolvable(Request).

control_differs(Positive - Control) :-
    expected_result(Positive, PositiveResult),
    expected_result(Control, ControlResult),
    result_of(Positive, PositiveResult),
    result_of(Control, ControlResult),
    PositiveResult \== ControlResult.

final_atom_is_a_status_value(Subject) :-
    expected_result(Subject, Result),
    atom(Result),
    sme_definition_status_values(StatusValues),
    member(Result, StatusValues).

autonomous_profile(Staff, Turnover, Balance, [attribute(own_staff_annual_work_units_hundredths, Staff), attribute(own_annual_turnover_cents, Turnover), attribute(own_annual_balance_sheet_total_cents, Balance), attribute(partner_enterprises, []), attribute(linked_enterprises, [])]).

estimate_profile(Staff, Turnover, Balance, Profile) :-
    autonomous_profile(Staff, Turnover, Balance, Figures),
    append([attribute(is_enterprise, true), attribute(public_bodies_control_25_percent_or_more, false), attribute(accounting_basis, bona_fide_estimate)], Figures, Profile).

unlinked_profile(Holding, Profile) :-
    Profile = [attribute(majority_of_voting_rights, false), attribute(right_to_appoint_or_remove_majority_of_board, false), attribute(majority_of_voting_rights_by_shareholder_agreement, false), attribute(relationship_only_through_natural_persons, false), attribute(dominant_influence_by_contract_or_articles, false), attribute(holding_basis_points, Holding), attribute(investor_category, not_a_listed_investor)].

period_result(Staff, Turnover, Balance, Result) :-
    autonomous_profile(Staff, Turnover, Balance, Profile),
    findall(Answer, period_size_class(recommendation_2003_361_annex, Profile, Answer, _), Answers),
    Answers == [Result].

test(every_subject_resolves_to_its_expected_result) :-
    findall(Subject, sme_definition_subject(Subject), Subjects),
    Subjects = [_|_],
    maplist(resolves_as_expected, Subjects).
test(every_expected_result_names_a_subject) :-
    findall(Subject, expected_result(Subject, _), ExpectedSubjects),
    findall(Subject, sme_definition_subject(Subject), Subjects),
    msort(ExpectedSubjects, SortedExpected),
    msort(Subjects, SortedSubjects),
    SortedExpected == SortedSubjects.
test(every_subject_has_a_non_empty_checklist) :-
    findall(Subject, sme_definition_subject(Subject), Subjects),
    maplist(has_checklist, Subjects).
test(every_subject_is_resolvable) :-
    findall(Subject, sme_definition_subject(Subject), Subjects),
    maplist(is_resolvable, Subjects).
test(every_near_miss_control_gets_another_result) :-
    findall(Positive - Control, near_miss(Positive, Control), Pairs),
    maplist(control_differs, Pairs).
test(every_final_result_is_a_status_value) :-
    findall(Subject, (expected_result(Subject, Result), atom(Result)), Subjects),
    maplist(final_atom_is_a_status_value, Subjects).
test(micro_staff_just_below_ceiling_is_micro) :-
    result_of(micro_staff_just_below_ceiling, micro_enterprise).
test(micro_staff_at_ceiling_is_small) :-
    result_of(micro_staff_at_ceiling, small_enterprise).
test(medium_turnover_at_ceiling_is_medium) :-
    result_of(medium_turnover_at_ceiling, medium_sized_enterprise).
test(medium_turnover_one_cent_above_is_large) :-
    result_of(medium_turnover_one_cent_above_ceiling, large_enterprise).
test(holding_at_threshold_is_partner) :-
    result_of(holding_at_partner_threshold, partner_enterprise).
test(holding_below_threshold_is_neither) :-
    result_of(holding_one_point_below_partner_threshold, neither_partner_nor_linked).
test(staff_at_medium_ceiling_is_not_sme_status) :-
    result_of(sme_staff_at_medium_ceiling, not_sme).
test(micro_staff_cites_article_two_three_five_and_six_one) :-
    citations_of(micro_staff_just_below_ceiling, [cite(eu_rec_2003_361_annex_art_2_3), cite(eu_rec_2003_361_annex_art_5), cite(eu_rec_2003_361_annex_art_6_1)]).
test(partner_aggregation_cites_article_six_two) :-
    citations_of(partner_share_lifts_staff_to_ceiling, [cite(eu_rec_2003_361_annex_art_2_2), cite(eu_rec_2003_361_annex_art_5), cite(eu_rec_2003_361_annex_art_6_2), cite(eu_rec_2003_361_annex_art_6_t3)]).
test(held_micro_class_cites_the_two_period_rule) :-
    citations_of(two_periods_held_micro_kept, [cite(eu_rec_2003_361_annex_art_2_3), cite(eu_rec_2003_361_annex_art_5), cite(eu_rec_2003_361_annex_art_6_1), cite(eu_rec_2003_361_annex_art_4_1), cite(eu_rec_2003_361_annex_art_4_2)]).
test(business_angels_below_limit_cite_point_a_under_gber) :-
    citations_of(business_angels_one_cent_below_limit, [cite(eu_reg_651_2014_annex_i_art_3_1), cite(eu_reg_651_2014_annex_i_art_3_t1), cite(eu_reg_651_2014_annex_i_art_3_2_a)]).
test(presumed_investor_cites_the_presumption) :-
    citations_of(presumed_investor_not_involved_in_management, [cite(eu_rec_2003_361_annex_art_3_1), cite(eu_rec_2003_361_annex_art_3_t3), cite(eu_rec_2003_361_annex_art_3_t6), cite(eu_rec_2003_361_annex_art_3_t13)]).
test(natural_persons_in_same_market_cite_point_a_and_markets) :-
    citations_of(natural_persons_in_same_market, [cite(eu_rec_2003_361_annex_art_3_3), cite(eu_rec_2003_361_annex_art_3_t9), cite(eu_rec_2003_361_annex_art_3_t15), cite(eu_rec_2003_361_annex_art_3_t16)]).
test(public_body_control_cites_article_three_four) :-
    citations_of(public_body_control_reached, [cite(eu_reg_651_2014_annex_i_art_3_4)]).
test(a_non_final_result_has_no_citations) :-
    citations_of(linked_list_not_given, []).
test(the_checklist_carries_the_citation_per_item) :-
    sme_definition_profile_for(micro_staff_just_below_ceiling, Request),
    sme_definition_checklist(Request, Checklist),
    member(item(determination, micro_enterprise, _), Checklist),
    member(item(eu_rec_2003_361_annex_art_2_3, met, cite(eu_rec_2003_361_annex_art_2_3)), Checklist).
test(the_status_is_the_verdict_result) :-
    sme_definition_profile_for(two_periods_both_small, Request),
    sme_definition_status(Request, Status),
    Status == small_enterprise.
test(the_text_changes_only_the_citations) :-
    sme_definition_profile_for(micro_staff_just_below_ceiling, query(Query, _, Profile)),
    decide_sme_definition(query(Query, recommendation_2003_361_annex, Profile), sme_definition_verdict(RecommendationResult, RecommendationCitations)),
    decide_sme_definition(query(Query, gber_annex_i, Profile), sme_definition_verdict(RegulationResult, RegulationCitations)),
    RecommendationResult == RegulationResult,
    RecommendationCitations \== RegulationCitations.
test(period_size_class_micro) :-
    period_result(999, 100000000, 100000000, micro_enterprise).
test(period_size_class_small) :-
    period_result(4999, 500000000, 500000000, small_enterprise).
test(period_size_class_medium) :-
    period_result(24999, 3000000000, 3000000000, medium_sized_enterprise).
test(period_size_class_large) :-
    period_result(25000, 3000000000, 3000000000, large_enterprise).
test(period_size_class_cites_under_gber) :-
    autonomous_profile(999, 100000000, 100000000, Profile),
    period_size_class(gber_annex_i, Profile, micro_enterprise, Citations),
    sort([cite(eu_reg_651_2014_annex_i_art_2_3), cite(eu_reg_651_2014_annex_i_art_5), cite(eu_reg_651_2014_annex_i_art_6_1)], Expected),
    Citations == Expected.
test(period_size_class_absent_list_is_indeterminate) :-
    period_size_class(recommendation_2003_361_annex, [attribute(own_staff_annual_work_units_hundredths, 500), attribute(own_annual_turnover_cents, 100000000), attribute(own_annual_balance_sheet_total_cents, 100000000), attribute(partner_enterprises, [])], Result, Citations),
    Result == indeterminate([linked_enterprises]),
    Citations == [].
test(period_size_class_malformed_item_is_an_input_problem) :-
    period_size_class(recommendation_2003_361_annex, [attribute(partner_enterprises, [partner_enterprise_data(2500, 100)])], Result, Citations),
    Result == input_problems([wrong_type(partner_enterprises)]),
    Citations == [].
test(size_class_not_an_enterprise) :-
    size_class(recommendation_2003_361_annex, [attribute(is_enterprise, false)], Result, Citations),
    Result == not_an_enterprise,
    Citations == [cite(eu_rec_2003_361_annex_art_1_t1)].
test(size_class_not_sme_public_control) :-
    size_class(gber_annex_i, [attribute(is_enterprise, true), attribute(public_bodies_control_25_percent_or_more, true)], Result, Citations),
    Result == not_sme_public_control,
    Citations == [cite(eu_reg_651_2014_annex_i_art_3_4)].
test(size_class_micro_from_an_estimate) :-
    estimate_profile(999, 100000000, 100000000, Profile),
    findall(Result, size_class(recommendation_2003_361_annex, Profile, Result, _), Results),
    Results == [micro_enterprise].
test(size_class_small_from_an_estimate) :-
    estimate_profile(4999, 500000000, 500000000, Profile),
    size_class(recommendation_2003_361_annex, Profile, small_enterprise, _).
test(size_class_medium_from_an_estimate) :-
    estimate_profile(24999, 3000000000, 3000000000, Profile),
    size_class(recommendation_2003_361_annex, Profile, medium_sized_enterprise, _).
test(size_class_large_from_an_estimate) :-
    estimate_profile(25000, 3000000000, 3000000000, Profile),
    size_class(recommendation_2003_361_annex, Profile, large_enterprise, _).
test(size_class_absent_public_control_is_indeterminate) :-
    size_class(recommendation_2003_361_annex, [attribute(is_enterprise, true)], Result, Citations),
    Result = indeterminate([_]),
    Citations == [].
test(size_class_unsure_enterprise_is_referred) :-
    size_class(recommendation_2003_361_annex, [attribute(is_enterprise, unsure), attribute(public_bodies_control_25_percent_or_more, true)], Result, Citations),
    Result == needs_legal_review(open_textured(is_enterprise, cite(eu_rec_2003_361_annex_art_1_t1)), [inputs_relied_on([is_enterprise - unsure])]),
    Citations == [].
test(size_class_wrong_text_is_an_input_problem) :-
    size_class(directive_unknown, [], Result, Citations),
    Result == input_problems([wrong_type(text)]),
    Citations == [].
test(sme_status_not_an_enterprise) :-
    sme_status(recommendation_2003_361_annex, [attribute(is_enterprise, false)], Result, Citations),
    Result == not_an_enterprise,
    Citations == [cite(eu_rec_2003_361_annex_art_1_t1)].
test(sme_status_sme) :-
    estimate_profile(24999, 3000000000, 3000000000, Profile),
    findall(Result, sme_status(recommendation_2003_361_annex, Profile, Result, _), Results),
    Results == [sme].
test(sme_status_not_sme_above_the_ceilings) :-
    estimate_profile(25000, 3000000000, 3000000000, Profile),
    sme_status(recommendation_2003_361_annex, Profile, not_sme, _).
test(sme_status_not_sme_under_public_control) :-
    sme_status(gber_annex_i, [attribute(is_enterprise, true), attribute(public_bodies_control_25_percent_or_more, true)], Result, Citations),
    Result == not_sme,
    Citations == [cite(eu_reg_651_2014_annex_i_art_3_4)].
test(sme_status_estimate_above_ceilings_cites_article_four_three) :-
    sme_status(recommendation_2003_361_annex, [attribute(is_enterprise, true), attribute(public_bodies_control_25_percent_or_more, false), attribute(own_staff_annual_work_units_hundredths, 30000), attribute(accounting_basis, bona_fide_estimate)], Result, Citations),
    Result == not_sme,
    sort([cite(eu_rec_2003_361_annex_art_2_1), cite(eu_rec_2003_361_annex_art_5), cite(eu_rec_2003_361_annex_art_4_3)], Expected),
    Citations == Expected.
test(relationship_type_linked) :-
    relationship_type(recommendation_2003_361_annex, [attribute(majority_of_voting_rights, true), attribute(relationship_only_through_natural_persons, false)], Result, Citations),
    Result == linked_enterprise,
    sort([cite(eu_rec_2003_361_annex_art_3_3), cite(eu_rec_2003_361_annex_art_3_t9)], Expected),
    Citations == Expected.
test(relationship_type_partner_at_threshold) :-
    unlinked_profile(2500, Profile),
    relationship_type(recommendation_2003_361_annex, Profile, Result, Citations),
    Result == partner_enterprise,
    Citations == [cite(eu_rec_2003_361_annex_art_3_2)].
test(relationship_type_neither_below_threshold) :-
    unlinked_profile(2499, Profile),
    relationship_type(recommendation_2003_361_annex, Profile, Result, Citations),
    Result == neither_partner_nor_linked,
    Citations == [cite(eu_rec_2003_361_annex_art_3_1)].
test(relationship_type_unsure_dominant_influence_is_referred) :-
    relationship_type(gber_annex_i, [attribute(majority_of_voting_rights, false), attribute(right_to_appoint_or_remove_majority_of_board, false), attribute(majority_of_voting_rights_by_shareholder_agreement, false), attribute(relationship_only_through_natural_persons, false), attribute(dominant_influence_by_contract_or_articles, unsure), attribute(holding_basis_points, 3000), attribute(investor_category, not_a_listed_investor)], Result, Citations),
    Result == needs_legal_review(open_textured(dominant_influence_by_contract_or_articles, cite(eu_reg_651_2014_annex_i_art_3_3_c)), [inputs_relied_on([dominant_influence_by_contract_or_articles - unsure])]),
    Citations == [].
test(relationship_type_absent_holding_is_indeterminate) :-
    relationship_type(recommendation_2003_361_annex, [attribute(majority_of_voting_rights, false), attribute(right_to_appoint_or_remove_majority_of_board, false), attribute(majority_of_voting_rights_by_shareholder_agreement, false), attribute(relationship_only_through_natural_persons, false), attribute(dominant_influence_by_contract_or_articles, unsure), attribute(investor_category, not_a_listed_investor)], Result, Citations),
    Result == indeterminate([holding_basis_points]),
    Citations == [].
test(provenance_constructor_holds) :-
    provenance(size_class, [cite(eu_rec_2003_361_annex_art_2_3)]).

test(micro_staff_at_ceiling_is_not_micro, fail) :-
    sme_definition_assess(micro_staff_at_ceiling, sme_definition_verdict(micro_enterprise, _)).
test(medium_turnover_one_cent_above_is_not_medium, fail) :-
    sme_definition_assess(medium_turnover_one_cent_above_ceiling, sme_definition_verdict(medium_sized_enterprise, _)).
test(holding_below_threshold_is_not_partner, fail) :-
    sme_definition_assess(holding_one_point_below_partner_threshold, sme_definition_verdict(partner_enterprise, _)).
test(staff_at_medium_ceiling_is_not_sme, fail) :-
    sme_definition_assess(sme_staff_at_medium_ceiling, sme_definition_verdict(sme, _)).
test(period_size_class_staff_at_micro_ceiling_is_not_micro, fail) :-
    period_result(1000, 100000000, 100000000, micro_enterprise).
test(size_class_large_is_not_medium, fail) :-
    estimate_profile(25000, 3000000000, 3000000000, Profile),
    size_class(recommendation_2003_361_annex, Profile, medium_sized_enterprise, _).
test(sme_status_above_the_ceilings_is_not_sme_status_sme, fail) :-
    estimate_profile(25000, 3000000000, 3000000000, Profile),
    sme_status(recommendation_2003_361_annex, Profile, sme, _).
test(relationship_type_below_threshold_is_not_partner, fail) :-
    unlinked_profile(2499, Profile),
    relationship_type(recommendation_2003_361_annex, Profile, partner_enterprise, _).
test(provenance_constructor_needs_a_citation_list, fail) :-
    provenance(size_class, cite(eu_rec_2003_361_annex_art_2_3)).

cp_test_names([every_subject_resolves_to_its_expected_result, every_expected_result_names_a_subject, every_subject_has_a_non_empty_checklist, every_subject_is_resolvable, every_near_miss_control_gets_another_result, every_final_result_is_a_status_value, micro_staff_just_below_ceiling_is_micro, micro_staff_at_ceiling_is_small, medium_turnover_at_ceiling_is_medium, medium_turnover_one_cent_above_is_large, holding_at_threshold_is_partner, holding_below_threshold_is_neither, staff_at_medium_ceiling_is_not_sme_status, micro_staff_cites_article_two_three_five_and_six_one, partner_aggregation_cites_article_six_two, held_micro_class_cites_the_two_period_rule, business_angels_below_limit_cite_point_a_under_gber, presumed_investor_cites_the_presumption, natural_persons_in_same_market_cite_point_a_and_markets, public_body_control_cites_article_three_four, a_non_final_result_has_no_citations, the_checklist_carries_the_citation_per_item, the_status_is_the_verdict_result, the_text_changes_only_the_citations, period_size_class_micro, period_size_class_small, period_size_class_medium, period_size_class_large, period_size_class_cites_under_gber, period_size_class_absent_list_is_indeterminate, period_size_class_malformed_item_is_an_input_problem, size_class_not_an_enterprise, size_class_not_sme_public_control, size_class_micro_from_an_estimate, size_class_small_from_an_estimate, size_class_medium_from_an_estimate, size_class_large_from_an_estimate, size_class_absent_public_control_is_indeterminate, size_class_unsure_enterprise_is_referred, size_class_wrong_text_is_an_input_problem, sme_status_not_an_enterprise, sme_status_sme, sme_status_not_sme_above_the_ceilings, sme_status_not_sme_under_public_control, sme_status_estimate_above_ceilings_cites_article_four_three, relationship_type_linked, relationship_type_partner_at_threshold, relationship_type_neither_below_threshold, relationship_type_unsure_dominant_influence_is_referred, relationship_type_absent_holding_is_indeterminate, provenance_constructor_holds]).
cp_test_fail_names([micro_staff_at_ceiling_is_not_micro, medium_turnover_one_cent_above_is_not_medium, holding_below_threshold_is_not_partner, staff_at_medium_ceiling_is_not_sme, period_size_class_staff_at_micro_ceiling_is_not_micro, size_class_large_is_not_medium, sme_status_above_the_ceilings_is_not_sme_status_sme, relationship_type_below_threshold_is_not_partner, provenance_constructor_needs_a_citation_list]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
