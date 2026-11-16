% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dma_art_3_gatekeeper_order_fixtures, [dma_art_3_gatekeeper_order_subject/1, dma_art_3_gatekeeper_order_profile_for/2, dma_art_3_gatekeeper_order_assess/2]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_dma_art_3_gatekeeper_order_dma_art_3_gatekeeper_order, [decide_dma_art_3_gatekeeper_order/2]).

dma_art_3_gatekeeper_order_subject(all_thresholds_at_boundary).
dma_art_3_gatekeeper_order_subject(member_states_two).
dma_art_3_gatekeeper_order_subject(turnover_at_threshold).
dma_art_3_gatekeeper_order_subject(turnover_one_euro_below).
dma_art_3_gatekeeper_order_subject(market_capitalisation_at_threshold).
dma_art_3_gatekeeper_order_subject(market_capitalisation_one_euro_below).
dma_art_3_gatekeeper_order_subject(end_users_one_below).
dma_art_3_gatekeeper_order_subject(business_users_one_below).
dma_art_3_gatekeeper_order_subject(end_users_third_year_one_below).
dma_art_3_gatekeeper_order_subject(business_users_third_year_one_below).
dma_art_3_gatekeeper_order_subject(presumed_arguments_unstated).
dma_art_3_gatekeeper_order_subject(presumed_rebuttal_accepted).
dma_art_3_gatekeeper_order_subject(presumed_rebuttal_rejected).
dma_art_3_gatekeeper_order_subject(presumed_rebuttal_conclusion_not_shown).
dma_art_3_gatekeeper_order_subject(below_thresholds_all_judgements_true).
dma_art_3_gatekeeper_order_subject(below_thresholds_one_judgement_false).
dma_art_3_gatekeeper_order_subject(below_thresholds_judgement_unsure).
dma_art_3_gatekeeper_order_subject(below_thresholds_judgement_absent).
dma_art_3_gatekeeper_order_subject(designated_attested_true).
dma_art_3_gatekeeper_order_subject(designated_attested_false).
dma_art_3_gatekeeper_order_subject(malformed_float_turnover).

threshold_base_pairs([market_capitalisation_eur_most_recent_financial_year - 75000000000, member_states_where_core_platform_service_provided - 3, union_turnover_eur_most_recent_financial_year - 7500000000, union_turnover_eur_second_most_recent_financial_year - 7500000000, union_turnover_eur_third_most_recent_financial_year - 7500000000, monthly_active_end_users_most_recent_financial_year - 45000000, monthly_active_end_users_second_most_recent_financial_year - 45000000, monthly_active_end_users_third_most_recent_financial_year - 45000000, yearly_active_business_users_most_recent_financial_year - 10000, yearly_active_business_users_second_most_recent_financial_year - 10000, yearly_active_business_users_third_most_recent_financial_year - 10000, significant_impact_on_internal_market - false]).

subject_plan(all_thresholds_at_boundary, [], [rebuttal_arguments_presented - false]).
subject_plan(member_states_two, [member_states_where_core_platform_service_provided - 2], [rebuttal_arguments_presented - false]).
subject_plan(turnover_at_threshold, [market_capitalisation_eur_most_recent_financial_year - 74999999999], [rebuttal_arguments_presented - false]).
subject_plan(turnover_one_euro_below, [market_capitalisation_eur_most_recent_financial_year - 74999999999, union_turnover_eur_third_most_recent_financial_year - 7499999999], [rebuttal_arguments_presented - false]).
subject_plan(market_capitalisation_at_threshold, [union_turnover_eur_most_recent_financial_year - 7499999999], [rebuttal_arguments_presented - false]).
subject_plan(market_capitalisation_one_euro_below, [union_turnover_eur_most_recent_financial_year - 7499999999, market_capitalisation_eur_most_recent_financial_year - 74999999999], [rebuttal_arguments_presented - false]).
subject_plan(end_users_one_below, [monthly_active_end_users_most_recent_financial_year - 44999999], [rebuttal_arguments_presented - false]).
subject_plan(business_users_one_below, [yearly_active_business_users_most_recent_financial_year - 9999], [rebuttal_arguments_presented - false]).
subject_plan(end_users_third_year_one_below, [monthly_active_end_users_third_most_recent_financial_year - 44999999], [rebuttal_arguments_presented - false]).
subject_plan(business_users_third_year_one_below, [yearly_active_business_users_third_most_recent_financial_year - 9999], [rebuttal_arguments_presented - false]).
subject_plan(presumed_arguments_unstated, [], []).
subject_plan(presumed_rebuttal_accepted, [], [rebuttal_arguments_presented - true, rebuttal_accepted_by_commission - attested(true, attestation(european_commission, at_2026_09_06, rebuttal_conclusion, none))]).
subject_plan(presumed_rebuttal_rejected, [], [rebuttal_arguments_presented - true, rebuttal_accepted_by_commission - attested(false, attestation(european_commission, at_2026_09_06, rebuttal_conclusion, none))]).
subject_plan(presumed_rebuttal_conclusion_not_shown, [], [rebuttal_arguments_presented - true]).
subject_plan(designated_attested_true, [], [rebuttal_arguments_presented - false, designated_as_gatekeeper_for_core_platform_service - attested(true, attestation(european_commission, at_2026_09_06, designation_decision, none))]).
subject_plan(designated_attested_false, [], [rebuttal_arguments_presented - false, designated_as_gatekeeper_for_core_platform_service - attested(false, attestation(european_commission, at_2026_09_06, designation_decision, none))]).
subject_plan(malformed_float_turnover, [union_turnover_eur_most_recent_financial_year - 15000000001/2], [rebuttal_arguments_presented - false]).

dma_art_3_gatekeeper_order_profile_for(Subject, Profile) :-
    subject_plan(Subject, Overrides, Extras),
    threshold_profile(Overrides, Extras, Profile).
dma_art_3_gatekeeper_order_profile_for(below_thresholds_all_judgements_true, Profile) :-
    pairs_to_attributes([member_states_where_core_platform_service_provided - 1, significant_impact_on_internal_market - true, core_platform_service_is_important_gateway - true, entrenched_and_durable_position - true], Profile).
dma_art_3_gatekeeper_order_profile_for(below_thresholds_one_judgement_false, Profile) :-
    pairs_to_attributes([member_states_where_core_platform_service_provided - 1, significant_impact_on_internal_market - true, core_platform_service_is_important_gateway - true, entrenched_and_durable_position - false], Profile).
dma_art_3_gatekeeper_order_profile_for(below_thresholds_judgement_unsure, Profile) :-
    pairs_to_attributes([member_states_where_core_platform_service_provided - 1, significant_impact_on_internal_market - true, core_platform_service_is_important_gateway - unsure, entrenched_and_durable_position - true], Profile).
dma_art_3_gatekeeper_order_profile_for(below_thresholds_judgement_absent, Profile) :-
    pairs_to_attributes([member_states_where_core_platform_service_provided - 1, significant_impact_on_internal_market - true, entrenched_and_durable_position - true], Profile).

threshold_profile(Overrides, Extras, Profile) :-
    threshold_base_pairs(BasePairs),
    apply_overrides(BasePairs, Overrides, OverriddenPairs),
    append(OverriddenPairs, Extras, AllPairs),
    pairs_to_attributes(AllPairs, Profile).

apply_overrides([], _, []).
apply_overrides([ProfileKey - Default|BasePairs], Overrides, [ProfileKey - Value|LaterPairs]) :-
    override_lookup(Overrides, ProfileKey, Default, Value),
    apply_overrides(BasePairs, Overrides, LaterPairs).

override_lookup([], _, Default, Default).
override_lookup([OverrideKey - Value|_], WantedKey, _, Value) :-
    OverrideKey == WantedKey.
override_lookup([OverrideKey - _|LaterOverrides], WantedKey, Default, Value) :-
    OverrideKey \== WantedKey,
    override_lookup(LaterOverrides, WantedKey, Default, Value).

pairs_to_attributes([], []).
pairs_to_attributes([ProfileKey - Value|Pairs], [attribute(ProfileKey, Value)|Attributes]) :-
    pairs_to_attributes(Pairs, Attributes).

dma_art_3_gatekeeper_order_assess(Subject, Result) :-
    dma_art_3_gatekeeper_order_profile_for(Subject, Profile),
    decide_dma_art_3_gatekeeper_order(Profile, Result).
