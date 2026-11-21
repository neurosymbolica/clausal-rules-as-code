% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_state_aid_gber_general_conditions___init__, [root_export/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_state_aid_gber_general_conditions_kernel, [argument_problems/2, condition_state/4, conjunction_state/3, conjunctions_met_t/3, date_earlier_t/3, gber_general_conditions_input_problems/2, gber_general_conditions_key_order/1, gber_general_conditions_query_problems/3, pairs_relied_on/3, pick_missing_key/3, way_possible_t/3, way_state/3]).
:- use_module(m__eu_state_aid_gber_general_conditions_citations, [chapter_i_met_citations/1, chapter_i_not_met_citations/1, citation/2, citation_vocabulary/1, implements/1, incentive_citations/1, scope_citations/1, threshold_row_citation/2, transparency_citations/1]).
:- use_module(m__eu_state_aid_gber_general_conditions_gber_general_conditions, [decide_gber_general_conditions/2, gber_chapter_i_conditions/10, gber_cumulation/7, gber_general_conditions_checklist/2, gber_general_conditions_decision_resolvable/1, gber_general_conditions_status/2, gber_general_conditions_status_values/1, gber_incentive_effect/5, gber_notification_threshold/4, gber_scope/3, gber_transparency/3]).
:- use_module(m__eu_state_aid_gber_general_conditions_queries, [chapter_i_conditions_not_met/0, chapter_i_conditions_partly_untested/0, cumulation_allowed/0, cumulation_not_allowed/0, cumulation_not_formalised/0, excluded_from_scope/0, gber_general_conditions_profile_keys/1, gber_general_conditions_what_if/4, incentive_effect/0, no_incentive_effect/0, not_transparent_aid/0, tested_chapter_i_conditions_met/0, threshold_exceeded/0, threshold_not_formalised/0, transparent_aid/0, within_scope/0, within_threshold/0]).
:- use_module(m__eu_state_aid_gber_general_conditions_fixtures, [gber_general_conditions_assess/2, gber_general_conditions_profile_for/2, gber_general_conditions_subject/1]).

root_export(ad_hoc_aid).
root_export(aid_form).
root_export(aid_type).
root_export(aided_sector).
root_export(also_active_in_excluded_sector).
root_export(application_contains_required_information).
root_export(article_13_regional_aid_category).
root_export(article_4_category).
root_export(article_6_5_category_conditions_met).
root_export(category_transparency_condition_met).
root_export(chapter_i_conditions_not_met).
root_export(chapter_i_conditions_partly_untested).
root_export(closure_of_uncompetitive_coal_mines).
root_export(cumulation_allowed).
root_export(cumulation_not_allowed).
root_export(cumulation_not_formalised).
root_export(date).
root_export(difficulty_2020_2021_derogation).
root_export(difficulty_exception_applies).
root_export(duplicate_key).
root_export(environmental_investment).
root_export(excluded_from_scope).
root_export(experimental_development).
root_export(export_or_domestic_goods_aid).
root_export(feasibility_study).
root_export(fishery_and_aquaculture).
root_export(form_transparency_condition_met).
root_export(fundamental_research).
root_export(grant).
root_export(guarantee).
root_export(identifiable_eligible_costs).
root_export(incentive_effect).
root_export(indeterminate).
root_export(individual_aid_under_scheme).
root_export(industrial_research).
root_export(input_problems).
root_export(inputs_relied_on).
root_export(interest_rate_subsidy).
root_export(large_enterprise).
root_export(large_enterprise_verification_done).
root_export(loan).
root_export(medium_sized_enterprise).
root_export(micro_enterprise).
root_export(needs_legal_review).
root_export(no_application).
root_export(no_incentive_effect).
root_export(non_severable_violation_of_union_law).
root_export(not_sme_public_control).
root_export(not_transparent_aid).
root_export(open_textured).
root_export(other_category).
root_export(other_form).
root_export(other_sector).
root_export(price_or_pass_on_condition).
root_export(primary_agricultural_production).
root_export(process_and_organisational_innovation).
root_export(processing_and_marketing_of_agricultural_products).
root_export(provenance).
root_export(recovery_order_exclusion_applies).
root_export(repayable_advance).
root_export(research_project_doubled).
root_export(sale_or_lease_of_tangible_assets).
root_export(scheme).
root_export(scheme_excluded_by_article_1_2_a_or_b).
root_export(sector_exception_applies).
root_export(separation_of_activities_or_costs_ensured).
root_export(size_class).
root_export(small_enterprise).
root_export(sme_consultancy).
root_export(sme_fair_participation).
root_export(sme_innovation).
root_export(sme_investment).
root_export(tax_advantage).
root_export(tax_measure_conditions_met).
root_export(tested_chapter_i_conditions_met).
root_export(threshold_exceeded).
root_export(threshold_not_formalised).
root_export(training).
root_export(transparent_aid).
root_export(transparent_under_article_5_1).
root_export(undertaking_in_difficulty).
root_export(unknown_key).
root_export(unsure).
root_export(within_scope).
root_export(within_threshold).
root_export(wrong_type).
