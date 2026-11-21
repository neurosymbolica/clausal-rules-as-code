% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_state_aid_gber_general_conditions_tests_test_output_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_lists_extra, [clausal_msort/2]).
:- use_module(m__eu_state_aid_gber_general_conditions_gber_general_conditions, [decide_gber_general_conditions/2, gber_general_conditions_status/2, gber_scope/3, gber_notification_threshold/4, gber_transparency/3, gber_incentive_effect/5, gber_cumulation/7]).
:- use_module(m__eu_state_aid_gber_general_conditions_fixtures, [gber_general_conditions_profile_for/2]).

same_citations(Actual, Expected) :-
    clausal_msort(Actual, Sorted),
    clausal_msort(Expected, Sorted).

subject_verdicts(Subject, Verdicts) :-
    gber_general_conditions_profile_for(Subject, SubjectCase),
    findall(Verdict, decide_gber_general_conditions(SubjectCase, Verdict), Verdicts).

threshold_answers(Profile, ProjectAidCents, Answers) :-
    findall(Result - Citations, gber_notification_threshold(Profile, ProjectAidCents, Result, Citations), Answers).

in_scope_profile([attribute(scheme_excluded_by_article_1_2_a_or_b, false), attribute(export_or_domestic_goods_aid, false), attribute(aided_sector, other_sector), attribute(article_13_regional_aid_category, false), attribute(also_active_in_excluded_sector, false), attribute(recovery_order_exclusion_applies, false), attribute(undertaking_in_difficulty, false), attribute(non_severable_violation_of_union_law, false)]).

processing_profile([attribute(scheme_excluded_by_article_1_2_a_or_b, false), attribute(export_or_domestic_goods_aid, false), attribute(aided_sector, processing_and_marketing_of_agricultural_products), attribute(article_13_regional_aid_category, false), attribute(also_active_in_excluded_sector, false), attribute(recovery_order_exclusion_applies, false), attribute(undertaking_in_difficulty, false), attribute(non_severable_violation_of_union_law, false)]).

test(the_compliant_case_yields_exactly_one_met_verdict) :-
    subject_verdicts(compliant_sme_grant, Verdicts),
    Verdicts == [gber_general_conditions_verdict(tested_chapter_i_conditions_met, [cite(eu_reg_651_2014_art_3_t1)])].
test(a_not_met_verdict_carries_the_fixed_list) :-
    subject_verdicts(threshold_one_cent_over, [gber_general_conditions_verdict(chapter_i_conditions_not_met, Citations)]),
    same_citations(Citations, [cite(eu_reg_651_2014_art_3_t1), cite(eu_reg_651_2014_art_1_2), cite(eu_reg_651_2014_art_1_3), cite(eu_reg_651_2014_art_1_4), cite(eu_reg_651_2014_art_1_5), cite(eu_reg_651_2014_art_4_1), cite(eu_reg_651_2014_art_5_1), cite(eu_reg_651_2014_art_6_1), cite(eu_reg_651_2014_art_8_3), cite(eu_reg_651_2014_art_8_5)]).
test(a_partly_untested_verdict_cites_article_3) :-
    subject_verdicts(other_category_row, Verdicts),
    Verdicts == [gber_general_conditions_verdict(chapter_i_conditions_partly_untested, [cite(eu_reg_651_2014_art_3_t1)])].
test(the_empty_profile_asks_for_the_first_scope_key) :-
    subject_verdicts(empty_profile, Verdicts),
    Verdicts == [gber_general_conditions_verdict(indeterminate([scheme_excluded_by_article_1_2_a_or_b]), [])].
test(an_unsure_difficulty_is_referred_with_its_pairs) :-
    subject_verdicts(difficulty_unsure, Verdicts),
    Verdicts == [gber_general_conditions_verdict(needs_legal_review(open_textured(undertaking_in_difficulty, cite(eu_reg_651_2014_art_1_4_c)), [inputs_relied_on([undertaking_in_difficulty - unsure, difficulty_exception_applies - false, difficulty_2020_2021_derogation - false])]), [])].
test(a_size_outside_the_contract_is_an_input_problem) :-
    subject_verdicts(not_an_enterprise_size, Verdicts),
    Verdicts == [gber_general_conditions_verdict(input_problems([wrong_type(size_class)]), [])].
test(the_status_projection_yields_one_status) :-
    gber_general_conditions_profile_for(de_minimis_at_intensity, SubjectCase),
    findall(Status, gber_general_conditions_status(SubjectCase, Status), Statuses),
    Statuses == [tested_chapter_i_conditions_met].
test(within_scope_cites_the_fixed_list_of_twenty_three) :-
    in_scope_profile(Profile),
    findall(Result - Citations, gber_scope(Profile, Result, Citations), [within_scope - Citations]),
    length(Citations, 23),
    sort(Citations, Sorted),
    length(Sorted, 23),
    member(cite(eu_reg_651_2014_art_2_18), Citations),
    member(cite(eu_reg_651_2014_art_1_t1), Citations).
test(a_coal_mine_closure_is_excluded_with_the_same_list) :-
    findall(Result - Citations, gber_scope([attribute(aided_sector, closure_of_uncompetitive_coal_mines)], Result, Citations), [excluded_from_scope - Citations]),
    length(Citations, 23).
test(processing_without_the_price_case_is_still_open) :-
    processing_profile(Profile),
    findall(Result, gber_scope(Profile, Result, _), Results),
    Results == [indeterminate([price_or_pass_on_condition])].
test(processing_alone_asks_for_the_first_scope_key) :-
    findall(Result, gber_scope([attribute(aided_sector, processing_and_marketing_of_agricultural_products)], Result, _), Results),
    Results == [indeterminate([scheme_excluded_by_article_1_2_a_or_b])].
test(the_sme_investment_figure_is_within_with_its_row) :-
    threshold_answers([attribute(article_4_category, sme_investment)], 825000000, [within_threshold - Citations]),
    same_citations(Citations, [cite(eu_reg_651_2014_art_4_1), cite(eu_reg_651_2014_art_4_1_c), cite(eu_reg_651_2014_art_8_1)]).
test(one_cent_over_the_sme_investment_figure_is_exceeded) :-
    threshold_answers([attribute(article_4_category, sme_investment)], 825000001, [threshold_exceeded - Citations]),
    same_citations(Citations, [cite(eu_reg_651_2014_art_4_1), cite(eu_reg_651_2014_art_4_1_c), cite(eu_reg_651_2014_art_8_1)]).
test(a_research_project_at_its_figure_does_not_cite_the_doubling) :-
    threshold_answers([attribute(article_4_category, industrial_research)], 3500000000, [within_threshold - Citations]),
    same_citations(Citations, [cite(eu_reg_651_2014_art_4_1), cite(eu_reg_651_2014_art_4_1_i_ii), cite(eu_reg_651_2014_art_8_1), cite(eu_reg_651_2014_art_4_1_i)]).
test(a_doubled_research_project_cites_point_iv) :-
    threshold_answers([attribute(article_4_category, industrial_research), attribute(research_project_doubled, true)], 7000000000, [within_threshold - Citations]),
    same_citations(Citations, [cite(eu_reg_651_2014_art_4_1), cite(eu_reg_651_2014_art_4_1_i_ii), cite(eu_reg_651_2014_art_8_1), cite(eu_reg_651_2014_art_4_1_i), cite(eu_reg_651_2014_art_4_1_i_iv)]).
test(one_cent_over_twice_the_figure_is_exceeded_without_the_doubling_key) :-
    threshold_answers([attribute(article_4_category, industrial_research)], 7000000001, [threshold_exceeded - Citations]),
    same_citations(Citations, [cite(eu_reg_651_2014_art_4_1), cite(eu_reg_651_2014_art_4_1_i_ii), cite(eu_reg_651_2014_art_8_1), cite(eu_reg_651_2014_art_4_1_i)]).
test(feasibility_studies_are_not_doubled) :-
    threshold_answers([attribute(article_4_category, feasibility_study), attribute(research_project_doubled, true)], 825000001, [threshold_exceeded - _]).
test(an_absent_category_is_asked_for) :-
    threshold_answers([], 100, Answers),
    Answers == [indeterminate([article_4_category]) - []].
test(another_category_is_not_formalised_with_no_citation) :-
    threshold_answers([attribute(article_4_category, other_category)], 100, Answers),
    Answers == [threshold_not_formalised - []].
test(an_empty_profile_asks_for_the_form) :-
    findall(Result - Citations, gber_transparency([], Result, Citations), Answers),
    Answers == [indeterminate([aid_form]) - []].
test(another_form_asks_for_the_category_point) :-
    findall(Result, gber_transparency([attribute(aid_form, other_form)], Result, _), Results),
    Results == [indeterminate([category_transparency_condition_met])].
test(a_loan_without_its_condition_and_no_other_way_is_not_transparent) :-
    findall(Result - Citations, gber_transparency([attribute(aid_form, loan), attribute(form_transparency_condition_met, false), attribute(category_transparency_condition_met, false), attribute(transparent_under_article_5_1, false)], Result, Citations), [not_transparent_aid - Citations]),
    length(Citations, 10).
test(an_unsure_general_test_is_referred) :-
    findall(Result, gber_transparency([attribute(aid_form, other_form), attribute(category_transparency_condition_met, false), attribute(transparent_under_article_5_1, unsure)], Result, _), Results),
    Results == [needs_legal_review(open_textured(transparent_under_article_5_1, cite(eu_reg_651_2014_art_5_1)), [inputs_relied_on([transparent_under_article_5_1 - unsure])])].
test(an_application_on_the_same_day_has_no_incentive_effect) :-
    findall(Result - Citations, gber_incentive_effect([attribute(article_6_5_category_conditions_met, false), attribute(tax_measure_conditions_met, false), attribute(application_contains_required_information, true), attribute(aid_type, scheme)], date(2024, 2, 1), date(2024, 2, 1), Result, Citations), [no_incentive_effect - Citations]),
    same_citations(Citations, [cite(eu_reg_651_2014_art_6_1), cite(eu_reg_651_2014_art_6_2), cite(eu_reg_651_2014_art_6_3), cite(eu_reg_651_2014_art_6_3_a), cite(eu_reg_651_2014_art_6_3_b), cite(eu_reg_651_2014_art_6_4), cite(eu_reg_651_2014_art_6_4_a), cite(eu_reg_651_2014_art_6_4_b), cite(eu_reg_651_2014_art_6_5)]).
test(an_empty_profile_asks_for_the_article_6_5_category) :-
    findall(Result, gber_incentive_effect([], date(2024, 1, 1), date(2024, 2, 1), Result, _), Results),
    Results == [indeterminate([article_6_5_category_conditions_met])].
test(a_tax_measure_has_an_incentive_effect_after_work_started) :-
    findall(Result, gber_incentive_effect([attribute(tax_measure_conditions_met, true)], date(2024, 3, 1), date(2024, 2, 1), Result, _), Results),
    Results == [incentive_effect].
test(aid_alone_over_the_intensity_with_de_minimis_cites_both) :-
    findall(Result - Citations, gber_cumulation([attribute(identifiable_eligible_costs, true)], 1000, 600, 1, 5000, Result, Citations), [cumulation_not_allowed - Citations]),
    same_citations(Citations, [cite(eu_reg_651_2014_art_8_3), cite(eu_reg_651_2014_art_8_3_b), cite(eu_reg_651_2014_art_8_5)]).
test(a_total_at_the_intensity_with_de_minimis_is_allowed) :-
    findall(Result - Citations, gber_cumulation([attribute(identifiable_eligible_costs, true)], 1000, 400, 100, 5000, Result, Citations), [cumulation_allowed - Citations]),
    same_citations(Citations, [cite(eu_reg_651_2014_art_8_3), cite(eu_reg_651_2014_art_8_3_a), cite(eu_reg_651_2014_art_8_3_b), cite(eu_reg_651_2014_art_8_5)]).
test(aid_without_identifiable_costs_is_not_formalised) :-
    findall(Result - Citations, gber_cumulation([attribute(identifiable_eligible_costs, false)], 1000, 900, 0, 5000, Result, Citations), Answers),
    Answers == [cumulation_not_formalised - []].

cp_test_names([the_compliant_case_yields_exactly_one_met_verdict, a_not_met_verdict_carries_the_fixed_list, a_partly_untested_verdict_cites_article_3, the_empty_profile_asks_for_the_first_scope_key, an_unsure_difficulty_is_referred_with_its_pairs, a_size_outside_the_contract_is_an_input_problem, the_status_projection_yields_one_status, within_scope_cites_the_fixed_list_of_twenty_three, a_coal_mine_closure_is_excluded_with_the_same_list, processing_without_the_price_case_is_still_open, processing_alone_asks_for_the_first_scope_key, the_sme_investment_figure_is_within_with_its_row, one_cent_over_the_sme_investment_figure_is_exceeded, a_research_project_at_its_figure_does_not_cite_the_doubling, a_doubled_research_project_cites_point_iv, one_cent_over_twice_the_figure_is_exceeded_without_the_doubling_key, feasibility_studies_are_not_doubled, an_absent_category_is_asked_for, another_category_is_not_formalised_with_no_citation, an_empty_profile_asks_for_the_form, another_form_asks_for_the_category_point, a_loan_without_its_condition_and_no_other_way_is_not_transparent, an_unsure_general_test_is_referred, an_application_on_the_same_day_has_no_incentive_effect, an_empty_profile_asks_for_the_article_6_5_category, a_tax_measure_has_an_incentive_effect_after_work_started, aid_alone_over_the_intensity_with_de_minimis_cites_both, a_total_at_the_intensity_with_de_minimis_is_allowed, aid_without_identifiable_costs_is_not_formalised]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
