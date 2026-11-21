% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_state_aid_gber_general_conditions_gber_general_conditions, [decide_gber_general_conditions/2, gber_general_conditions_status/2, gber_general_conditions_checklist/2, gber_general_conditions_decision_resolvable/1, gber_general_conditions_status_values/1, gber_scope/3, gber_notification_threshold/4, gber_transparency/3, gber_incentive_effect/5, gber_cumulation/7, gber_chapter_i_conditions/10]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(library(pairs), [pairs_values/2]).
:- use_module(clausal_lists_extra, [clausal_msort/2]).
:- use_module(library(clpz)).
:- use_module(library(reif), [memberd_t/3]).
:- use_module(formalize_lib, [profile_get/3]).
:- use_module(m__eu_state_aid_gber_general_conditions_kernel, [gber_general_conditions_query_problems/3, date_earlier_t/3, conjunctions_met_t/3, condition_state/4, way_possible_t/3, pick_missing_key/3, pairs_relied_on/3]).
:- use_module(m__eu_state_aid_gber_general_conditions_citations, [implements/1, scope_citations/1, transparency_citations/1, incentive_citations/1, chapter_i_met_citations/1, chapter_i_not_met_citations/1, threshold_row_citation/2]).

gber_general_conditions_status_values([tested_chapter_i_conditions_met, chapter_i_conditions_not_met, chapter_i_conditions_partly_untested]).

threshold_figure(sme_investment, FigureCents, cite(eu_reg_651_2014_art_4_1_c)) :-
    implements(eu_reg_651_2014_art_4_1_c),
    FigureCents #= 825000000.
threshold_figure(sme_consultancy, FigureCents, cite(eu_reg_651_2014_art_4_1_d)) :-
    implements(eu_reg_651_2014_art_4_1_d),
    FigureCents #= 220000000.
threshold_figure(sme_fair_participation, FigureCents, cite(eu_reg_651_2014_art_4_1_e)) :-
    implements(eu_reg_651_2014_art_4_1_e),
    FigureCents #= 220000000.
threshold_figure(fundamental_research, FigureCents, cite(eu_reg_651_2014_art_4_1_i_i)) :-
    implements(eu_reg_651_2014_art_4_1_i_i),
    FigureCents #= 5500000000.
threshold_figure(industrial_research, FigureCents, cite(eu_reg_651_2014_art_4_1_i_ii)) :-
    implements(eu_reg_651_2014_art_4_1_i_ii),
    FigureCents #= 3500000000.
threshold_figure(experimental_development, FigureCents, cite(eu_reg_651_2014_art_4_1_i_iii)) :-
    implements(eu_reg_651_2014_art_4_1_i_iii),
    FigureCents #= 2500000000.
threshold_figure(feasibility_study, FigureCents, cite(eu_reg_651_2014_art_4_1_i_vi)) :-
    implements(eu_reg_651_2014_art_4_1_i_vi),
    FigureCents #= 825000000.
threshold_figure(sme_innovation, FigureCents, cite(eu_reg_651_2014_art_4_1_l)) :-
    implements(eu_reg_651_2014_art_4_1_l),
    FigureCents #= 1000000000.
threshold_figure(process_and_organisational_innovation, FigureCents, cite(eu_reg_651_2014_art_4_1_m)) :-
    implements(eu_reg_651_2014_art_4_1_m),
    FigureCents #= 1250000000.
threshold_figure(training, FigureCents, cite(eu_reg_651_2014_art_4_1_n)) :-
    implements(eu_reg_651_2014_art_4_1_n),
    FigureCents #= 300000000.
threshold_figure(environmental_investment, FigureCents, cite(eu_reg_651_2014_art_4_1_s)) :-
    implements(eu_reg_651_2014_art_4_1_s),
    FigureCents #= 3000000000.

doubled_figure(Category, DoubledCents) :-
    implements(eu_reg_651_2014_art_4_1_i_iv),
    threshold_figure(Category, FigureCents, _),
    DoubledCents #= 2 * FigureCents.

research_category_t(Category, Truth) :-
    implements(eu_reg_651_2014_art_4_1_i),
    memberd_t(Category, [fundamental_research, industrial_research, experimental_development], Truth).

definition_read(date_of_granting, cite(eu_reg_651_2014_art_2_28)).
definition_read(small_and_medium_sized_enterprises, cite(eu_reg_651_2014_art_2_2)).
definition_read(large_enterprises, cite(eu_reg_651_2014_art_2_24)).
definition_read(start_of_works, cite(eu_reg_651_2014_art_2_23)).
definition_read(aid_intensity, cite(eu_reg_651_2014_art_2_26)).

size_class_reading(micro_enterprise, small_or_medium_sized, cite(eu_reg_651_2014_art_2_2)).
size_class_reading(small_enterprise, small_or_medium_sized, cite(eu_reg_651_2014_art_2_2)).
size_class_reading(medium_sized_enterprise, small_or_medium_sized, cite(eu_reg_651_2014_art_2_2)).
size_class_reading(large_enterprise, large, cite(eu_reg_651_2014_art_2_24)).
size_class_reading(not_sme_public_control, large, cite(eu_reg_651_2014_art_2_24)).

scope_condition(a1, [cite(eu_reg_651_2014_art_1_2), cite(eu_reg_651_2014_art_1_2_a), cite(eu_reg_651_2014_art_1_2_b)], [[key_allows(scheme_excluded_by_article_1_2_a_or_b, [true])]], [[key_allows(scheme_excluded_by_article_1_2_a_or_b, [false])]]).
scope_condition(a2, [cite(eu_reg_651_2014_art_1_2), cite(eu_reg_651_2014_art_1_2_c), cite(eu_reg_651_2014_art_1_2_d)], [[key_allows(export_or_domestic_goods_aid, [true])]], [[key_allows(export_or_domestic_goods_aid, [false])]]).
scope_condition(a3, [cite(eu_reg_651_2014_art_1_3), cite(eu_reg_651_2014_art_1_3_a), cite(eu_reg_651_2014_art_1_3_b), cite(eu_reg_651_2014_art_1_3_c), cite(eu_reg_651_2014_art_1_3_c_i), cite(eu_reg_651_2014_art_1_3_c_ii), cite(eu_reg_651_2014_art_1_3_d)], [[key_allows(aided_sector, [fishery_and_aquaculture, primary_agricultural_production]), key_allows(sector_exception_applies, [false])], [key_allows(aided_sector, [processing_and_marketing_of_agricultural_products]), key_allows(price_or_pass_on_condition, [true])], [key_allows(aided_sector, [closure_of_uncompetitive_coal_mines])]], [[key_allows(aided_sector, [other_sector])], [key_allows(aided_sector, [fishery_and_aquaculture, primary_agricultural_production]), key_allows(sector_exception_applies, [true])], [key_allows(aided_sector, [processing_and_marketing_of_agricultural_products]), key_allows(price_or_pass_on_condition, [false])]]).
scope_condition(a4, [cite(eu_reg_651_2014_art_1_3), cite(eu_reg_651_2014_art_1_3_e)], [[key_allows(article_13_regional_aid_category, [true])]], [[key_allows(article_13_regional_aid_category, [false])]]).
scope_condition(a5, [cite(eu_reg_651_2014_art_1_t1)], [[key_allows(also_active_in_excluded_sector, [true]), key_allows(separation_of_activities_or_costs_ensured, [false])]], [[key_allows(also_active_in_excluded_sector, [false])], [key_allows(separation_of_activities_or_costs_ensured, [true])]]).
scope_condition(a6, [cite(eu_reg_651_2014_art_1_4), cite(eu_reg_651_2014_art_1_4_a), cite(eu_reg_651_2014_art_1_4_b)], [[key_allows(recovery_order_exclusion_applies, [true])]], [[key_allows(recovery_order_exclusion_applies, [false])]]).
scope_condition(a7, [cite(eu_reg_651_2014_art_1_4), cite(eu_reg_651_2014_art_1_4_c), cite(eu_reg_651_2014_art_2_18)], [[key_allows(undertaking_in_difficulty, [true]), key_allows(difficulty_exception_applies, [false]), key_allows(difficulty_2020_2021_derogation, [false])]], [[key_allows(undertaking_in_difficulty, [false])], [key_allows(difficulty_exception_applies, [true])], [key_allows(difficulty_2020_2021_derogation, [true])]]).
scope_condition(a8, [cite(eu_reg_651_2014_art_1_5), cite(eu_reg_651_2014_art_1_5_a), cite(eu_reg_651_2014_art_1_5_b), cite(eu_reg_651_2014_art_1_5_c)], [[key_allows(non_severable_violation_of_union_law, [true])]], [[key_allows(non_severable_violation_of_union_law, [false])]]).

transparency_condition(c1, [cite(eu_reg_651_2014_art_5_2), cite(eu_reg_651_2014_art_5_2_a), cite(eu_reg_651_2014_art_5_2_b), cite(eu_reg_651_2014_art_5_2_c), cite(eu_reg_651_2014_art_5_2_c_i), cite(eu_reg_651_2014_art_5_2_c_ii), cite(eu_reg_651_2014_art_5_2_d), cite(eu_reg_651_2014_art_5_2_j), cite(eu_reg_651_2014_art_5_2_k)], [[key_allows(aid_form, [grant, interest_rate_subsidy])], [key_allows(aid_form, [loan, guarantee, tax_advantage, repayable_advance, sale_or_lease_of_tangible_assets]), key_allows(form_transparency_condition_met, [true])]], [[key_allows(aid_form, [other_form])], [key_allows(aid_form, [loan, guarantee, tax_advantage, repayable_advance, sale_or_lease_of_tangible_assets]), key_allows(form_transparency_condition_met, [false])]]).
transparency_condition(c2, [cite(eu_reg_651_2014_art_5_2)], [[key_allows(category_transparency_condition_met, [true])]], [[key_allows(category_transparency_condition_met, [false])]]).
transparency_condition(c3, [cite(eu_reg_651_2014_art_5_1)], [[key_allows(transparent_under_article_5_1, [true])]], [[key_allows(transparent_under_article_5_1, [false])]]).

incentive_condition(d1, _, [cite(eu_reg_651_2014_art_6_5)], [[key_allows(article_6_5_category_conditions_met, [true])]], [[key_allows(article_6_5_category_conditions_met, [false])]]).
incentive_condition(d2, _, [cite(eu_reg_651_2014_art_6_4), cite(eu_reg_651_2014_art_6_4_a), cite(eu_reg_651_2014_art_6_4_b)], [[key_allows(tax_measure_conditions_met, [true])]], [[key_allows(tax_measure_conditions_met, [false])]]).
incentive_condition(d3, true, [cite(eu_reg_651_2014_art_6_2), cite(eu_reg_651_2014_art_6_3), cite(eu_reg_651_2014_art_6_3_a), cite(eu_reg_651_2014_art_6_3_b)], [[key_allows(application_contains_required_information, [true]), key_allows(aid_type, [scheme, individual_aid_under_scheme])], [key_allows(application_contains_required_information, [true]), key_allows(size_class, [micro_enterprise, small_enterprise, medium_sized_enterprise])], [key_allows(application_contains_required_information, [true]), key_allows(large_enterprise_verification_done, [true])]], [[key_allows(application_contains_required_information, [false])], [key_allows(aid_type, [ad_hoc_aid]), key_allows(size_class, [large_enterprise, not_sme_public_control]), key_allows(large_enterprise_verification_done, [false])]]).
incentive_condition(d3, false, [cite(eu_reg_651_2014_art_6_2), cite(eu_reg_651_2014_art_6_3), cite(eu_reg_651_2014_art_6_3_a), cite(eu_reg_651_2014_art_6_3_b)], [], [[]]).

referral_row(scope, a1, scheme_excluded_by_article_1_2_a_or_b, eu_reg_651_2014_art_1_2, [scheme_excluded_by_article_1_2_a_or_b]) :-
    implements(eu_reg_651_2014_art_1_2).
referral_row(scope, a2, export_or_domestic_goods_aid, eu_reg_651_2014_art_1_2, [export_or_domestic_goods_aid]) :-
    implements(eu_reg_651_2014_art_1_2).
referral_row(scope, a5, separation_of_activities_or_costs_ensured, eu_reg_651_2014_art_1_t1, [also_active_in_excluded_sector, separation_of_activities_or_costs_ensured]) :-
    implements(eu_reg_651_2014_art_1_t1).
referral_row(scope, a7, undertaking_in_difficulty, eu_reg_651_2014_art_1_4_c, [undertaking_in_difficulty, difficulty_exception_applies, difficulty_2020_2021_derogation]) :-
    implements(eu_reg_651_2014_art_1_4_c).
referral_row(scope, a8, non_severable_violation_of_union_law, eu_reg_651_2014_art_1_5, [non_severable_violation_of_union_law]) :-
    implements(eu_reg_651_2014_art_1_5).
referral_row(transparency, c3, transparent_under_article_5_1, eu_reg_651_2014_art_5_1, [transparent_under_article_5_1]) :-
    implements(eu_reg_651_2014_art_5_1).

test_class(within_scope, for).
test_class(excluded_from_scope, against).
test_class(within_threshold, for).
test_class(threshold_exceeded, against).
test_class(threshold_not_formalised, untested).
test_class(transparent_aid, for).
test_class(not_transparent_aid, against).
test_class(incentive_effect, for).
test_class(no_incentive_effect, against).
test_class(cumulation_allowed, for).
test_class(cumulation_not_allowed, against).
test_class(cumulation_not_formalised, untested).
test_class(indeterminate(_), open).
test_class(needs_legal_review(_, _), open).

scope_condition_rows(ConditionRows) :-
    implements(eu_reg_651_2014_art_1_2),
    findall(condition(ConditionId, Holds, Fails), scope_condition(ConditionId, _, Holds, Fails), ConditionRows).

transparency_condition_rows(ConditionRows) :-
    implements(eu_reg_651_2014_art_5_2),
    findall(condition(ConditionId, Holds, Fails), transparency_condition(ConditionId, _, Holds, Fails), ConditionRows).

incentive_condition_rows(ApplicationBefore, ConditionRows) :-
    implements(eu_reg_651_2014_art_6_1),
    findall(condition(ConditionId, Holds, Fails), incentive_condition(ConditionId, ApplicationBefore, _, Holds, Fails), ConditionRows).

application_before_t(no_application, _, false) :-
    implements(eu_reg_651_2014_art_6_2).
application_before_t(date(Year, Month, Day), WorkStartDate, Truth) :-
    implements(eu_reg_651_2014_art_6_2),
    date_earlier_t(date(Year, Month, Day), WorkStartDate, Truth).

condition_state_pairs(_, [], []).
condition_state_pairs(Profile, [condition(ConditionId, Holds, Fails)|ConditionRows], [ConditionId - ConditionState|StatePairs]) :-
    condition_state(Profile, Holds, Fails, ConditionState),
    condition_state_pairs(Profile, ConditionRows, StatePairs).

pairs_summary(StatePairs, Summary) :-
    pairs_values(StatePairs, States),
    memberd_t(holds, States, AnyHolds),
    memberd_t(open, States, AnyOpen),
    summary_from_truths(AnyHolds, AnyOpen, Summary).

summary_from_truths(true, _, holds).
summary_from_truths(false, true, open).
summary_from_truths(false, false, fails).

holds_way_of(condition(_, Holds, _), conjunction_way(Holds)).

holds_list_of(condition(_, Holds, _), Holds).

fails_list_of(condition(_, _, Fails), Fails).

rows_all_fail_way(ConditionRows, all_fail_way(FailsLists)) :-
    maplist(fails_list_of, ConditionRows, FailsLists).

rows_holds_union_way(ConditionRows, conjunction_way(AllHolds)) :-
    maplist(holds_list_of, ConditionRows, HoldsLists),
    append(HoldsLists, AllHolds).

set_candidate_ways(ConditionRows, CandidateWays) :-
    maplist(holds_way_of, ConditionRows, HoldsWays),
    rows_all_fail_way(ConditionRows, AllFailWay),
    append(HoldsWays, [AllFailWay], CandidateWays).

referrals_for(open, ReferralSet, Referrals) :-
    findall(referral(ConditionId, InputKey, CitationKey, Inputs), referral_row(ReferralSet, ConditionId, InputKey, CitationKey, Inputs), Referrals).
referrals_for(TestClass, _, []) :-
    dif(TestClass, open).

pick_answer(key(MissingKey), _, _, _, indeterminate([MissingKey])).
pick_answer(no_key, Profile, StatePairs, Referrals, Review) :-
    first_referral(Profile, StatePairs, Referrals, Review).

first_referral(Profile, StatePairs, [referral(ConditionId, InputKey, CitationKey, Inputs)|LaterReferrals], Review) :-
    member(ConditionId - ConditionState, StatePairs),
    referral_fires_t(Profile, ConditionState, InputKey, Fires),
    referral_choice(Fires, Profile, StatePairs, referral(ConditionId, InputKey, CitationKey, Inputs), LaterReferrals, Review).

referral_fires_t(Profile, open, InputKey, Fires) :-
    findall(Value, profile_get(Profile, InputKey, Value), Values),
    memberd_t(unsure, Values, Fires).
referral_fires_t(_, holds, _, false).
referral_fires_t(_, fails, _, false).

referral_choice(true, Profile, _, referral(_, InputKey, CitationKey, Inputs), _, needs_legal_review(open_textured(InputKey, cite(CitationKey)), [inputs_relied_on(Pairs)])) :-
    pairs_relied_on(Profile, Inputs, Pairs).
referral_choice(false, Profile, StatePairs, _, LaterReferrals, Review) :-
    first_referral(Profile, StatePairs, LaterReferrals, Review).

gber_scope(Profile, input_problems([Problem|Problems]), []) :-
    gber_general_conditions_query_problems(Profile, [], [Problem|Problems]).
gber_scope(Profile, Result, Citations) :-
    gber_general_conditions_query_problems(Profile, [], []),
    scope_answer(Profile, Result, Citations).

scope_answer(Profile, Result, Citations) :-
    scope_condition_rows(ConditionRows),
    condition_state_pairs(Profile, ConditionRows, StatePairs),
    pairs_summary(StatePairs, Summary),
    scope_from_summary(Summary, Profile, ConditionRows, StatePairs, Result, Citations).

scope_from_summary(holds, _, _, _, excluded_from_scope, Citations) :-
    implements(eu_reg_651_2014_art_1_2),
    scope_citations(Citations).
scope_from_summary(fails, _, _, _, within_scope, Citations) :-
    implements(eu_reg_651_2014_art_1_2),
    scope_citations(Citations).
scope_from_summary(open, Profile, ConditionRows, StatePairs, Result, []) :-
    implements(eu_reg_651_2014_art_1_2),
    set_candidate_ways(ConditionRows, CandidateWays),
    pick_missing_key(Profile, CandidateWays, PickResult),
    referrals_for(open, scope, Referrals),
    pick_answer(PickResult, Profile, StatePairs, Referrals, Result).

gber_notification_threshold(Profile, ProjectAidCents, input_problems([Problem|Problems]), []) :-
    gber_general_conditions_query_problems(Profile, [project_aid_cents - ProjectAidCents], [Problem|Problems]).
gber_notification_threshold(Profile, ProjectAidCents, Result, Citations) :-
    gber_general_conditions_query_problems(Profile, [project_aid_cents - ProjectAidCents], []),
    threshold_answer(Profile, ProjectAidCents, Result, Citations).

category_threshold_conjunction(ProjectAidCents, Category, ThresholdKind, Conjunction) :-
    research_category_t(Category, IsResearch),
    threshold_figure(Category, FigureCents, _),
    row_conjunction(IsResearch, Category, ProjectAidCents, FigureCents, ThresholdKind, Conjunction).

row_conjunction(false, Category, ProjectAidCents, FigureCents, exceeded, [key_allows(article_4_category, [Category])]) :-
    implements(eu_reg_651_2014_art_4_1),
    ProjectAidCents #> FigureCents.
row_conjunction(false, Category, ProjectAidCents, FigureCents, within, [key_allows(article_4_category, [Category])]) :-
    implements(eu_reg_651_2014_art_4_1),
    ProjectAidCents #=< FigureCents.
row_conjunction(true, Category, ProjectAidCents, FigureCents, within, [key_allows(article_4_category, [Category])]) :-
    implements(eu_reg_651_2014_art_4_1_i),
    ProjectAidCents #=< FigureCents.
row_conjunction(true, Category, ProjectAidCents, _, exceeded, [key_allows(article_4_category, [Category])]) :-
    implements(eu_reg_651_2014_art_4_1_i_iv),
    doubled_figure(Category, DoubledCents),
    ProjectAidCents #> DoubledCents.
row_conjunction(true, Category, ProjectAidCents, FigureCents, within, [key_allows(article_4_category, [Category]), key_allows(research_project_doubled, [true])]) :-
    implements(eu_reg_651_2014_art_4_1_i_iv),
    doubled_figure(Category, DoubledCents),
    ProjectAidCents #> FigureCents,
    ProjectAidCents #=< DoubledCents.
row_conjunction(true, Category, ProjectAidCents, FigureCents, exceeded, [key_allows(article_4_category, [Category]), key_allows(research_project_doubled, [false])]) :-
    implements(eu_reg_651_2014_art_4_1_i_iv),
    doubled_figure(Category, DoubledCents),
    ProjectAidCents #> FigureCents,
    ProjectAidCents #=< DoubledCents.

threshold_conjunctions(ProjectAidCents, ThresholdKind, Conjunctions) :-
    findall(Conjunction, (threshold_row_citation(Category, _), category_threshold_conjunction(ProjectAidCents, Category, ThresholdKind, Conjunction)), Conjunctions).

threshold_conjunction_lists(ProjectAidCents, Exceeded, Within, [[key_allows(article_4_category, [other_category])]]) :-
    implements(eu_reg_651_2014_art_8_1),
    threshold_conjunctions(ProjectAidCents, exceeded, Exceeded),
    threshold_conjunctions(ProjectAidCents, within, Within).

threshold_answer(Profile, ProjectAidCents, Result, Citations) :-
    threshold_conjunction_lists(ProjectAidCents, Exceeded, Within, Untested),
    conjunctions_met_t(Profile, Exceeded, ExceededMet),
    conjunctions_met_t(Profile, Within, WithinMet),
    conjunctions_met_t(Profile, Untested, UntestedMet),
    threshold_state_from_truths(ExceededMet, WithinMet, UntestedMet, ThresholdState),
    threshold_from_state(ThresholdState, Profile, ProjectAidCents, threshold_lists(Exceeded, Within, Untested), Result, Citations).

threshold_state_from_truths(true, _, _, exceeded).
threshold_state_from_truths(false, true, _, within).
threshold_state_from_truths(false, false, true, untested).
threshold_state_from_truths(false, false, false, open).

threshold_from_state(exceeded, Profile, _, _, threshold_exceeded, [cite(eu_reg_651_2014_art_4_1), RowCitation, cite(eu_reg_651_2014_art_8_1)|ExtraCitations]) :-
    implements(eu_reg_651_2014_art_4_1),
    profile_get(Profile, article_4_category, Category),
    threshold_row_citation(Category, RowCitation),
    research_category_t(Category, IsResearch),
    exceeded_extra_citations(IsResearch, ExtraCitations).
threshold_from_state(within, Profile, ProjectAidCents, _, within_threshold, [cite(eu_reg_651_2014_art_4_1), RowCitation, cite(eu_reg_651_2014_art_8_1)|ExtraCitations]) :-
    implements(eu_reg_651_2014_art_4_1),
    profile_get(Profile, article_4_category, Category),
    threshold_row_citation(Category, RowCitation),
    research_category_t(Category, IsResearch),
    within_extra_citations(IsResearch, Category, ProjectAidCents, ExtraCitations).
threshold_from_state(untested, _, _, _, threshold_not_formalised, []) :-
    implements(eu_reg_651_2014_art_4_1).
threshold_from_state(open, Profile, _, threshold_lists(Exceeded, Within, Untested), Result, []) :-
    implements(eu_reg_651_2014_art_4_1),
    pick_missing_key(Profile, [conjunction_way(Exceeded), conjunction_way(Within), conjunction_way(Untested)], PickResult),
    pick_answer(PickResult, Profile, [], [], Result).

exceeded_extra_citations(true, [cite(eu_reg_651_2014_art_4_1_i)]).
exceeded_extra_citations(false, []).

within_extra_citations(false, _, _, []).
within_extra_citations(true, Category, ProjectAidCents, [cite(eu_reg_651_2014_art_4_1_i)]) :-
    implements(eu_reg_651_2014_art_4_1_i),
    threshold_figure(Category, FigureCents, _),
    ProjectAidCents #=< FigureCents.
within_extra_citations(true, Category, ProjectAidCents, [cite(eu_reg_651_2014_art_4_1_i), cite(eu_reg_651_2014_art_4_1_i_iv)]) :-
    implements(eu_reg_651_2014_art_4_1_i_iv),
    threshold_figure(Category, FigureCents, _),
    ProjectAidCents #> FigureCents.

gber_transparency(Profile, input_problems([Problem|Problems]), []) :-
    gber_general_conditions_query_problems(Profile, [], [Problem|Problems]).
gber_transparency(Profile, Result, Citations) :-
    gber_general_conditions_query_problems(Profile, [], []),
    transparency_answer(Profile, Result, Citations).

transparency_answer(Profile, Result, Citations) :-
    transparency_condition_rows(ConditionRows),
    condition_state_pairs(Profile, ConditionRows, StatePairs),
    pairs_summary(StatePairs, Summary),
    transparency_from_summary(Summary, Profile, ConditionRows, StatePairs, Result, Citations).

transparency_from_summary(holds, _, _, _, transparent_aid, Citations) :-
    implements(eu_reg_651_2014_art_5_1),
    transparency_citations(Citations).
transparency_from_summary(fails, _, _, _, not_transparent_aid, Citations) :-
    implements(eu_reg_651_2014_art_5_1),
    transparency_citations(Citations).
transparency_from_summary(open, Profile, ConditionRows, StatePairs, Result, []) :-
    implements(eu_reg_651_2014_art_5_1),
    set_candidate_ways(ConditionRows, CandidateWays),
    pick_missing_key(Profile, CandidateWays, PickResult),
    referrals_for(open, transparency, Referrals),
    pick_answer(PickResult, Profile, StatePairs, Referrals, Result).

gber_incentive_effect(Profile, ApplicationDate, WorkStartDate, input_problems([Problem|Problems]), []) :-
    gber_general_conditions_query_problems(Profile, [application_date - ApplicationDate, work_start_date - WorkStartDate], [Problem|Problems]).
gber_incentive_effect(Profile, ApplicationDate, WorkStartDate, Result, Citations) :-
    gber_general_conditions_query_problems(Profile, [application_date - ApplicationDate, work_start_date - WorkStartDate], []),
    incentive_answer(Profile, ApplicationDate, WorkStartDate, Result, Citations).

incentive_answer(Profile, ApplicationDate, WorkStartDate, Result, Citations) :-
    application_before_t(ApplicationDate, WorkStartDate, ApplicationBefore),
    incentive_condition_rows(ApplicationBefore, ConditionRows),
    condition_state_pairs(Profile, ConditionRows, StatePairs),
    pairs_summary(StatePairs, Summary),
    incentive_from_summary(Summary, Profile, ConditionRows, StatePairs, Result, Citations).

incentive_from_summary(holds, _, _, _, incentive_effect, Citations) :-
    implements(eu_reg_651_2014_art_6_1),
    incentive_citations(Citations).
incentive_from_summary(fails, _, _, _, no_incentive_effect, Citations) :-
    implements(eu_reg_651_2014_art_6_1),
    incentive_citations(Citations).
incentive_from_summary(open, Profile, ConditionRows, StatePairs, Result, []) :-
    implements(eu_reg_651_2014_art_6_1),
    set_candidate_ways(ConditionRows, CandidateWays),
    pick_missing_key(Profile, CandidateWays, PickResult),
    pick_answer(PickResult, Profile, StatePairs, [], Result).

gber_cumulation(Profile, EligibleCostsCents, SameCostsAidCents, SameCostsDeMinimisCents, MaxIntensityBasisPoints, input_problems([Problem|Problems]), []) :-
    gber_general_conditions_query_problems(Profile, [eligible_costs_cents - EligibleCostsCents, same_costs_aid_cents - SameCostsAidCents, same_costs_de_minimis_cents - SameCostsDeMinimisCents, max_intensity_basis_points - MaxIntensityBasisPoints], [Problem|Problems]).
gber_cumulation(Profile, EligibleCostsCents, SameCostsAidCents, SameCostsDeMinimisCents, MaxIntensityBasisPoints, Result, Citations) :-
    gber_general_conditions_query_problems(Profile, [eligible_costs_cents - EligibleCostsCents, same_costs_aid_cents - SameCostsAidCents, same_costs_de_minimis_cents - SameCostsDeMinimisCents, max_intensity_basis_points - MaxIntensityBasisPoints], []),
    findall(Value, profile_get(Profile, identifiable_eligible_costs, Value), Values),
    cumulation_from_values(Values, cumulation_figures(EligibleCostsCents, SameCostsAidCents, SameCostsDeMinimisCents, MaxIntensityBasisPoints), Result, Citations).

cumulation_from_values([], _, indeterminate([identifiable_eligible_costs]), []).
cumulation_from_values([false], _, cumulation_not_formalised, []) :-
    implements(eu_reg_651_2014_art_8_3).
cumulation_from_values([true], Figures, Result, Citations) :-
    cumulation_exceeds_t(Figures, Exceeds),
    cumulation_from_exceeds(Exceeds, Figures, Result, Citations).

cumulation_exceeds_t(cumulation_figures(EligibleCostsCents, SameCostsAidCents, SameCostsDeMinimisCents, MaxIntensityBasisPoints), true) :-
    implements(eu_reg_651_2014_art_8_3_b),
    (SameCostsAidCents + SameCostsDeMinimisCents) * 10000 #> MaxIntensityBasisPoints * EligibleCostsCents.
cumulation_exceeds_t(cumulation_figures(EligibleCostsCents, SameCostsAidCents, SameCostsDeMinimisCents, MaxIntensityBasisPoints), false) :-
    implements(eu_reg_651_2014_art_2_26),
    (SameCostsAidCents + SameCostsDeMinimisCents) * 10000 #=< MaxIntensityBasisPoints * EligibleCostsCents.

cumulation_from_exceeds(true, cumulation_figures(EligibleCostsCents, SameCostsAidCents, SameCostsDeMinimisCents, MaxIntensityBasisPoints), cumulation_not_allowed, Citations) :-
    implements(eu_reg_651_2014_art_8_3_b),
    aid_alone_citations(EligibleCostsCents, SameCostsAidCents, MaxIntensityBasisPoints, AidCitations),
    de_minimis_citations(SameCostsDeMinimisCents, DeMinimisCitations),
    append(AidCitations, DeMinimisCitations, Citations).
cumulation_from_exceeds(false, cumulation_figures(_, _, SameCostsDeMinimisCents, _), cumulation_allowed, [cite(eu_reg_651_2014_art_8_3), cite(eu_reg_651_2014_art_8_3_a), cite(eu_reg_651_2014_art_8_3_b)|DeMinimisCitations]) :-
    implements(eu_reg_651_2014_art_8_3),
    de_minimis_citations(SameCostsDeMinimisCents, DeMinimisCitations).

aid_alone_citations(EligibleCostsCents, SameCostsAidCents, MaxIntensityBasisPoints, [cite(eu_reg_651_2014_art_8_3), cite(eu_reg_651_2014_art_8_3_b)]) :-
    implements(eu_reg_651_2014_art_8_3_b),
    SameCostsAidCents * 10000 #> MaxIntensityBasisPoints * EligibleCostsCents.
aid_alone_citations(EligibleCostsCents, SameCostsAidCents, MaxIntensityBasisPoints, []) :-
    implements(eu_reg_651_2014_art_8_3_b),
    SameCostsAidCents * 10000 #=< MaxIntensityBasisPoints * EligibleCostsCents.

de_minimis_citations(SameCostsDeMinimisCents, [cite(eu_reg_651_2014_art_8_5)]) :-
    implements(eu_reg_651_2014_art_8_5),
    SameCostsDeMinimisCents #> 0.
de_minimis_citations(SameCostsDeMinimisCents, []) :-
    implements(eu_reg_651_2014_art_8_5),
    SameCostsDeMinimisCents #= 0.

cumulation_conjunction_lists(Figures, NotAllowed, Allowed, [[key_allows(identifiable_eligible_costs, [false])]]) :-
    implements(eu_reg_651_2014_art_8_3),
    cumulation_exceeds_t(Figures, Exceeds),
    cumulation_kind_lists(Exceeds, NotAllowed, Allowed).

cumulation_kind_lists(true, [[key_allows(identifiable_eligible_costs, [true])]], []).
cumulation_kind_lists(false, [], [[key_allows(identifiable_eligible_costs, [true])]]).

gber_chapter_i_conditions(Profile, ProjectAidCents, ApplicationDate, WorkStartDate, EligibleCostsCents, SameCostsAidCents, SameCostsDeMinimisCents, MaxIntensityBasisPoints, input_problems([Problem|Problems]), []) :-
    gber_general_conditions_query_problems(Profile, [project_aid_cents - ProjectAidCents, application_date - ApplicationDate, work_start_date - WorkStartDate, eligible_costs_cents - EligibleCostsCents, same_costs_aid_cents - SameCostsAidCents, same_costs_de_minimis_cents - SameCostsDeMinimisCents, max_intensity_basis_points - MaxIntensityBasisPoints], [Problem|Problems]).
gber_chapter_i_conditions(Profile, ProjectAidCents, ApplicationDate, WorkStartDate, EligibleCostsCents, SameCostsAidCents, SameCostsDeMinimisCents, MaxIntensityBasisPoints, Result, Citations) :-
    gber_general_conditions_query_problems(Profile, [project_aid_cents - ProjectAidCents, application_date - ApplicationDate, work_start_date - WorkStartDate, eligible_costs_cents - EligibleCostsCents, same_costs_aid_cents - SameCostsAidCents, same_costs_de_minimis_cents - SameCostsDeMinimisCents, max_intensity_basis_points - MaxIntensityBasisPoints], []),
    chapter_answer(chapter_inputs(Profile, ProjectAidCents, ApplicationDate, WorkStartDate, cumulation_figures(EligibleCostsCents, SameCostsAidCents, SameCostsDeMinimisCents, MaxIntensityBasisPoints)), Result, Citations).

chapter_answer(chapter_inputs(Profile, ProjectAidCents, ApplicationDate, WorkStartDate, cumulation_figures(EligibleCostsCents, SameCostsAidCents, SameCostsDeMinimisCents, MaxIntensityBasisPoints)), Result, Citations) :-
    gber_scope(Profile, ScopeResult, _),
    gber_notification_threshold(Profile, ProjectAidCents, ThresholdResult, _),
    gber_transparency(Profile, TransparencyResult, _),
    gber_incentive_effect(Profile, ApplicationDate, WorkStartDate, IncentiveResult, _),
    gber_cumulation(Profile, EligibleCostsCents, SameCostsAidCents, SameCostsDeMinimisCents, MaxIntensityBasisPoints, CumulationResult, _),
    maplist(test_class, [ScopeResult, ThresholdResult, TransparencyResult, IncentiveResult, CumulationResult], Classes),
    Classes = [ScopeClass, _, TransparencyClass, _, _],
    memberd_t(against, Classes, AnyAgainst),
    memberd_t(untested, Classes, AnyUntested),
    memberd_t(open, Classes, AnyOpen),
    chapter_from_classes(AnyAgainst, AnyUntested, AnyOpen, chapter_context(Profile, ProjectAidCents, ApplicationDate, WorkStartDate, cumulation_figures(EligibleCostsCents, SameCostsAidCents, SameCostsDeMinimisCents, MaxIntensityBasisPoints), ScopeClass, TransparencyClass), Result, Citations).

chapter_from_classes(true, _, _, _, chapter_i_conditions_not_met, Citations) :-
    implements(eu_reg_651_2014_art_3_t1),
    chapter_i_not_met_citations(Citations).
chapter_from_classes(false, false, false, _, tested_chapter_i_conditions_met, Citations) :-
    implements(eu_reg_651_2014_art_3_t1),
    chapter_i_met_citations(Citations).
chapter_from_classes(false, true, _, Context, Result, Citations) :-
    chapter_unsettled(Context, Result, Citations).
chapter_from_classes(false, false, true, Context, Result, Citations) :-
    chapter_unsettled(Context, Result, Citations).

chapter_unsettled(chapter_context(Profile, ProjectAidCents, ApplicationDate, WorkStartDate, Figures, ScopeClass, TransparencyClass), Result, Citations) :-
    implements(eu_reg_651_2014_art_3_t1),
    scope_condition_rows(ScopeRows),
    transparency_condition_rows(TransparencyRows),
    application_before_t(ApplicationDate, WorkStartDate, ApplicationBefore),
    incentive_condition_rows(ApplicationBefore, IncentiveRows),
    threshold_conjunction_lists(ProjectAidCents, Exceeded, Within, ThresholdUntested),
    cumulation_conjunction_lists(Figures, NotAllowed, Allowed, CumulationUntested),
    rows_holds_union_way(ScopeRows, ScopeAgainst),
    rows_all_fail_way(ScopeRows, ScopeFor),
    rows_all_fail_way(TransparencyRows, TransparencyAgainst),
    rows_holds_union_way(TransparencyRows, TransparencyFor),
    rows_all_fail_way(IncentiveRows, IncentiveAgainst),
    rows_holds_union_way(IncentiveRows, IncentiveFor),
    append(Within, ThresholdUntested, ThresholdReached),
    append(Allowed, CumulationUntested, CumulationReached),
    maplist(way_possible_t(Profile), [ScopeAgainst, conjunction_way(Exceeded), TransparencyAgainst, IncentiveAgainst, conjunction_way(NotAllowed)], AgainstTruths),
    maplist(way_possible_t(Profile), [ScopeFor, conjunction_way(Within), TransparencyFor, IncentiveFor, conjunction_way(Allowed)], ForTruths),
    memberd_t(true, AgainstTruths, AnyAgainstPossible),
    memberd_t(false, ForTruths, SomeForImpossible),
    maplist(holds_way_of, ScopeRows, ScopeHoldsWays),
    append(ScopeHoldsWays, [conjunction_way(Exceeded), TransparencyAgainst, IncentiveAgainst, conjunction_way(NotAllowed)], CandidatePrefix),
    append(ScopeRows, TransparencyRows, ReferralRows),
    condition_state_pairs(Profile, ReferralRows, StatePairs),
    referrals_for(ScopeClass, scope, ScopeReferrals),
    referrals_for(TransparencyClass, transparency, TransparencyReferrals),
    append(ScopeReferrals, TransparencyReferrals, Referrals),
    chapter_open_route(AnyAgainstPossible, SomeForImpossible, chapter_pick_data(Profile, CandidatePrefix, AgainstTruths, [ScopeFor, conjunction_way(ThresholdReached), TransparencyFor, IncentiveFor, conjunction_way(CumulationReached)], StatePairs, Referrals), Result, Citations).

chapter_open_route(false, true, _, chapter_i_conditions_partly_untested, Citations) :-
    implements(eu_reg_651_2014_art_3_t1),
    chapter_i_met_citations(Citations).
chapter_open_route(true, SomeForImpossible, PickData, Result, []) :-
    chapter_pick(SomeForImpossible, PickData, Result).
chapter_open_route(false, false, PickData, Result, []) :-
    chapter_pick(false, PickData, Result).

chapter_pick(SomeForImpossible, chapter_pick_data(Profile, CandidatePrefix, AgainstTruths, MetParts, StatePairs, Referrals), Result) :-
    maplist(adjust_part(SomeForImpossible), AgainstTruths, MetParts, AdjustedParts),
    append(CandidatePrefix, [sum_way(AdjustedParts)], CandidateWays),
    pick_missing_key(Profile, CandidateWays, PickResult),
    pick_answer(PickResult, Profile, StatePairs, Referrals, Result).

adjust_part(false, _, MetPart, MetPart).
adjust_part(true, true, MetPart, MetPart).
adjust_part(true, false, _, conjunction_way([[]])).

decide_gber_general_conditions(gber_case(Profile, ProjectAidCents, ApplicationDate, WorkStartDate, EligibleCostsCents, SameCostsAidCents, SameCostsDeMinimisCents, MaxIntensityBasisPoints), gber_general_conditions_verdict(Status, Citations)) :-
    gber_chapter_i_conditions(Profile, ProjectAidCents, ApplicationDate, WorkStartDate, EligibleCostsCents, SameCostsAidCents, SameCostsDeMinimisCents, MaxIntensityBasisPoints, Status, Citations).

gber_general_conditions_status(Case, Status) :-
    decide_gber_general_conditions(Case, gber_general_conditions_verdict(Status, _Citations)).

gber_general_conditions_checklist(gber_case(Profile, ProjectAidCents, ApplicationDate, WorkStartDate, EligibleCostsCents, SameCostsAidCents, SameCostsDeMinimisCents, MaxIntensityBasisPoints), [item(scope, ScopeResult, ScopeCitations), item(notification_threshold, ThresholdResult, ThresholdCitations), item(transparency, TransparencyResult, TransparencyCitations), item(incentive_effect, IncentiveResult, IncentiveCitations), item(cumulation, CumulationResult, CumulationCitations)]) :-
    gber_scope(Profile, ScopeResult, ScopeCitations),
    gber_notification_threshold(Profile, ProjectAidCents, ThresholdResult, ThresholdCitations),
    gber_transparency(Profile, TransparencyResult, TransparencyCitations),
    gber_incentive_effect(Profile, ApplicationDate, WorkStartDate, IncentiveResult, IncentiveCitations),
    gber_cumulation(Profile, EligibleCostsCents, SameCostsAidCents, SameCostsDeMinimisCents, MaxIntensityBasisPoints, CumulationResult, CumulationCitations).

gber_general_conditions_decision_resolvable(Case) :-
    decide_gber_general_conditions(Case, _Verdict).

fixture_in_scope_profile([attribute(scheme_excluded_by_article_1_2_a_or_b, false), attribute(export_or_domestic_goods_aid, false), attribute(aided_sector, other_sector), attribute(article_13_regional_aid_category, false), attribute(also_active_in_excluded_sector, false), attribute(recovery_order_exclusion_applies, false), attribute(undertaking_in_difficulty, false), attribute(non_severable_violation_of_union_law, false)]).

fixture_full_profile(Category, Profile) :-
    fixture_in_scope_profile(ScopeProfile),
    append(ScopeProfile, [attribute(article_4_category, Category), attribute(aid_form, grant), attribute(application_contains_required_information, true), attribute(aid_type, scheme), attribute(identifiable_eligible_costs, true)], Profile).

test(the_scope_conditions_read_the_scope_provisions) :-
    findall(Citations, scope_condition(_, Citations, _, _), CitationLists),
    append(CitationLists, AllCitations),
    sort(AllCitations, Sorted),
    scope_citations(ScopeCitations),
    sort(ScopeCitations, Sorted).
test(the_transparency_conditions_read_the_transparency_provisions) :-
    findall(Citations, transparency_condition(_, Citations, _, _), CitationLists),
    append(CitationLists, AllCitations),
    sort(AllCitations, Sorted),
    transparency_citations(TransparencyCitations),
    sort(TransparencyCitations, Sorted).
test(every_size_class_has_one_reading) :-
    findall(SizeClass, size_class_reading(SizeClass, _, _), SizeClasses),
    sort(SizeClasses, Sorted),
    length(Sorted, 5),
    length(SizeClasses, 5).
test(not_sme_public_control_is_read_as_large) :-
    size_class_reading(not_sme_public_control, large, cite(eu_reg_651_2014_art_2_24)).
test(five_definitions_are_read) :-
    findall(Term, definition_read(Term, _), Terms),
    length(Terms, 5).
test(six_referral_rows_are_recorded) :-
    findall(InputKey, referral_row(_, _, InputKey, _, _), InputKeys),
    length(InputKeys, 6).
test(an_empty_profile_asks_for_the_first_scope_key) :-
    gber_scope([], indeterminate([scheme_excluded_by_article_1_2_a_or_b]), []).
test(every_exclusion_ruled_out_is_within_scope) :-
    fixture_in_scope_profile(Profile),
    gber_scope(Profile, within_scope, Citations),
    length(Citations, 23).
test(a_recovery_order_excludes) :-
    gber_scope([attribute(recovery_order_exclusion_applies, true)], excluded_from_scope, _).
test(an_unsure_difficulty_goes_to_a_lawyer) :-
    gber_scope([attribute(scheme_excluded_by_article_1_2_a_or_b, false), attribute(export_or_domestic_goods_aid, false), attribute(aided_sector, other_sector), attribute(article_13_regional_aid_category, false), attribute(also_active_in_excluded_sector, false), attribute(recovery_order_exclusion_applies, false), attribute(undertaking_in_difficulty, unsure), attribute(difficulty_exception_applies, false), attribute(difficulty_2020_2021_derogation, false), attribute(non_severable_violation_of_union_law, false)], needs_legal_review(open_textured(undertaking_in_difficulty, cite(eu_reg_651_2014_art_1_4_c)), [inputs_relied_on([undertaking_in_difficulty - unsure, difficulty_exception_applies - false, difficulty_2020_2021_derogation - false])]), []).
test(a_malformed_profile_is_an_input_problem) :-
    gber_scope(not_a_list, input_problems([wrong_type(profile)]), []).
test(the_sme_investment_figure_is_within) :-
    gber_notification_threshold([attribute(article_4_category, sme_investment)], 825000000, within_threshold, _).
test(one_cent_over_the_figure_is_exceeded) :-
    gber_notification_threshold([attribute(article_4_category, sme_investment)], 825000001, threshold_exceeded, _).
test(a_research_project_over_the_figure_asks_for_the_doubling) :-
    gber_notification_threshold([attribute(article_4_category, fundamental_research)], 6000000000, indeterminate([research_project_doubled]), []).
test(a_doubled_research_project_cites_point_iv) :-
    gber_notification_threshold([attribute(article_4_category, fundamental_research), attribute(research_project_doubled, true)], 6000000000, within_threshold, Citations),
    clausal_msort(Citations, Sorted),
    clausal_msort([cite(eu_reg_651_2014_art_4_1), cite(eu_reg_651_2014_art_4_1_i_i), cite(eu_reg_651_2014_art_8_1), cite(eu_reg_651_2014_art_4_1_i), cite(eu_reg_651_2014_art_4_1_i_iv)], Sorted).
test(another_category_is_not_formalised) :-
    gber_notification_threshold([attribute(article_4_category, other_category)], 1, threshold_not_formalised, []).
test(a_grant_is_transparent) :-
    gber_transparency([attribute(aid_form, grant)], transparent_aid, _).
test(an_unsure_general_test_goes_to_a_lawyer) :-
    gber_transparency([attribute(aid_form, other_form), attribute(category_transparency_condition_met, false), attribute(transparent_under_article_5_1, unsure)], needs_legal_review(open_textured(transparent_under_article_5_1, cite(eu_reg_651_2014_art_5_1)), [inputs_relied_on([transparent_under_article_5_1 - unsure])]), []).
test(an_application_the_day_before_has_an_incentive_effect) :-
    gber_incentive_effect([attribute(application_contains_required_information, true), attribute(aid_type, scheme)], date(2024, 1, 31), date(2024, 2, 1), incentive_effect, _).
test(an_application_on_the_same_day_has_none) :-
    gber_incentive_effect([attribute(article_6_5_category_conditions_met, false), attribute(tax_measure_conditions_met, false), attribute(application_contains_required_information, true), attribute(aid_type, scheme)], date(2024, 2, 1), date(2024, 2, 1), no_incentive_effect, _).
test(a_total_at_the_intensity_is_allowed) :-
    gber_cumulation([attribute(identifiable_eligible_costs, true)], 1000, 500, 0, 5000, cumulation_allowed, [cite(eu_reg_651_2014_art_8_3), cite(eu_reg_651_2014_art_8_3_a), cite(eu_reg_651_2014_art_8_3_b)]).
test(de_minimis_over_the_intensity_is_not_allowed) :-
    gber_cumulation([attribute(identifiable_eligible_costs, true)], 1000, 500, 1, 5000, cumulation_not_allowed, [cite(eu_reg_651_2014_art_8_5)]).
test(absent_eligible_costs_are_asked_for) :-
    gber_cumulation([], 1000, 500, 0, 5000, indeterminate([identifiable_eligible_costs]), []).
test(every_tested_condition_met) :-
    fixture_full_profile(sme_investment, Profile),
    gber_chapter_i_conditions(Profile, 100000000, date(2024, 1, 1), date(2024, 3, 1), 1000000, 400000, 0, 5000, tested_chapter_i_conditions_met, [cite(eu_reg_651_2014_art_3_t1)]).
test(another_category_is_partly_untested) :-
    fixture_full_profile(other_category, Profile),
    gber_chapter_i_conditions(Profile, 100000000, date(2024, 1, 1), date(2024, 3, 1), 1000000, 400000, 0, 5000, chapter_i_conditions_partly_untested, [cite(eu_reg_651_2014_art_3_t1)]).
test(an_exceeded_threshold_is_not_met) :-
    fixture_full_profile(sme_investment, Profile),
    gber_chapter_i_conditions(Profile, 900000000, date(2024, 1, 1), date(2024, 3, 1), 1000000, 400000, 0, 5000, chapter_i_conditions_not_met, _).
test(the_facade_status_projects_the_answer) :-
    fixture_full_profile(sme_investment, Profile),
    gber_general_conditions_status(gber_case(Profile, 100000000, date(2024, 1, 1), date(2024, 3, 1), 1000000, 400000, 0, 5000), tested_chapter_i_conditions_met).
test(the_joined_query_answers_once) :-
    fixture_full_profile(sme_investment, Profile),
    findall(Result, gber_chapter_i_conditions(Profile, 100000000, date(2024, 1, 1), date(2024, 3, 1), 1000000, 400000, 0, 5000, Result, _), Results),
    length(Results, 1).

test(a_recovery_order_is_not_within_scope, fail) :-
    gber_scope([attribute(recovery_order_exclusion_applies, true)], within_scope, _).
test(one_cent_over_the_figure_is_not_within, fail) :-
    gber_notification_threshold([attribute(article_4_category, sme_investment)], 825000001, within_threshold, _).
test(an_application_on_the_same_day_is_not_an_incentive, fail) :-
    gber_incentive_effect([attribute(article_6_5_category_conditions_met, false), attribute(tax_measure_conditions_met, false), attribute(application_contains_required_information, true), attribute(aid_type, scheme)], date(2024, 2, 1), date(2024, 2, 1), incentive_effect, _).
