% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_state_aid_gber_general_conditions_queries, [gber_general_conditions_profile_keys/1, gber_general_conditions_what_if/4, within_scope/0, excluded_from_scope/0, within_threshold/0, threshold_exceeded/0, threshold_not_formalised/0, transparent_aid/0, not_transparent_aid/0, incentive_effect/0, no_incentive_effect/0, cumulation_allowed/0, cumulation_not_allowed/0, cumulation_not_formalised/0, tested_chapter_i_conditions_met/0, chapter_i_conditions_not_met/0, chapter_i_conditions_partly_untested/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_state_aid_gber_general_conditions_kernel, [gber_general_conditions_input_problems/2]).
:- use_module(m__eu_state_aid_gber_general_conditions_gber_general_conditions, [decide_gber_general_conditions/2]).

within_scope.

excluded_from_scope.

within_threshold.

threshold_exceeded.

threshold_not_formalised.

transparent_aid.

not_transparent_aid.

incentive_effect.

no_incentive_effect.

cumulation_allowed.

cumulation_not_allowed.

cumulation_not_formalised.

tested_chapter_i_conditions_met.

chapter_i_conditions_not_met.

chapter_i_conditions_partly_untested.

gber_general_conditions_profile_keys([scheme_excluded_by_article_1_2_a_or_b, export_or_domestic_goods_aid, aided_sector, sector_exception_applies, price_or_pass_on_condition, article_13_regional_aid_category, also_active_in_excluded_sector, separation_of_activities_or_costs_ensured, recovery_order_exclusion_applies, undertaking_in_difficulty, difficulty_exception_applies, difficulty_2020_2021_derogation, non_severable_violation_of_union_law, article_4_category, research_project_doubled, aid_form, form_transparency_condition_met, category_transparency_condition_met, transparent_under_article_5_1, article_6_5_category_conditions_met, tax_measure_conditions_met, application_contains_required_information, aid_type, size_class, large_enterprise_verification_done, identifiable_eligible_costs]).

gber_general_conditions_what_if(gber_case(Profile, ProjectAidCents, ApplicationDate, WorkStartDate, EligibleCostsCents, SameCostsAidCents, SameCostsDeMinimisCents, MaxIntensityBasisPoints), OverriddenKey, NewValue, Verdict) :-
    override_profile_key(Profile, OverriddenKey, NewValue, Hypothesis),
    decide_gber_general_conditions(gber_case(Hypothesis, ProjectAidCents, ApplicationDate, WorkStartDate, EligibleCostsCents, SameCostsAidCents, SameCostsDeMinimisCents, MaxIntensityBasisPoints), Verdict).

override_profile_key(Profile, OverriddenKey, Value, Hypothesis) :-
    profile_without_key(Profile, OverriddenKey, Remaining),
    append(Remaining, [attribute(OverriddenKey, Value)], Hypothesis).

profile_without_key([], _, []).
profile_without_key([attribute(ElementKey, _)|Elements], OverriddenKey, Remaining) :-
    ElementKey == OverriddenKey,
    profile_without_key(Elements, OverriddenKey, Remaining).
profile_without_key([attribute(ElementKey, ElementValue)|Elements], OverriddenKey, [attribute(ElementKey, ElementValue)|Remaining]) :-
    ElementKey \== OverriddenKey,
    profile_without_key(Elements, OverriddenKey, Remaining).

test(the_schema_has_twenty_six_keys) :-
    gber_general_conditions_profile_keys(ProfileKeys),
    length(ProfileKeys, 26).
test(an_override_replaces_the_key) :-
    override_profile_key([attribute(aid_form, grant), attribute(aid_type, scheme)], aid_form, loan, [attribute(aid_type, scheme), attribute(aid_form, loan)]).
test(an_override_adds_an_absent_key) :-
    override_profile_key([], aid_form, grant, [attribute(aid_form, grant)]).
test(what_if_a_recovery_order_settles_against) :-
    gber_general_conditions_what_if(gber_case([attribute(recovery_order_exclusion_applies, false)], 1, date(2024, 1, 1), date(2024, 2, 1), 1000, 100, 0, 5000), recovery_order_exclusion_applies, true, gber_general_conditions_verdict(chapter_i_conditions_not_met, _)).
test(what_if_the_first_scope_key_is_given_the_next_is_asked) :-
    gber_general_conditions_what_if(gber_case([], 1, date(2024, 1, 1), date(2024, 2, 1), 1000, 100, 0, 5000), scheme_excluded_by_article_1_2_a_or_b, false, gber_general_conditions_verdict(indeterminate([export_or_domestic_goods_aid]), [])).
test(a_result_atom_is_a_fact) :-
    within_scope.

test(what_if_a_recovery_order_is_not_met_otherwise, fail) :-
    gber_general_conditions_what_if(gber_case([attribute(recovery_order_exclusion_applies, false)], 1, date(2024, 1, 1), date(2024, 2, 1), 1000, 100, 0, 5000), recovery_order_exclusion_applies, true, gber_general_conditions_verdict(tested_chapter_i_conditions_met, _)).
