% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_cbam_origin_exclusions___init__, [root_export/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_cbam_origin_exclusions_kernel, [origin_exclusions_input_problems/2]).
:- use_module(m__eu_cbam_origin_exclusions_citations, [citation/2, implements/1]).
:- use_module(m__eu_cbam_origin_exclusions_origin_exclusions, [decide_origin_exclusions/2, excluded_electricity_continental_shelf_or_eez/0, excluded_hydrogen_continental_shelf_or_eez/0, excluded_military_activities/0, excluded_origin_annex_iii_point_1/0, indeterminate/1, input_problems/1, no_origin_exclusion/0, not_third_country_origin/0, origin_exclusion/3, origin_exclusions_checklist/2, origin_exclusions_decision_resolvable/1, origin_exclusions_status/2, origin_exclusions_status_values/1]).
:- use_module(m__eu_cbam_origin_exclusions_queries, [origin_exclusions_eligibility/2, origin_exclusions_profile_keys/1, origin_exclusions_what_if/4]).
:- use_module(m__eu_cbam_origin_exclusions_fixtures, [origin_exclusions_assess/2, origin_exclusions_profile_for/2, origin_exclusions_subject/1]).

root_export(busingen).
root_export(ceuta).
root_export(continental_shelf_or_eez_of).
root_export(duplicate_key).
root_export(electricity).
root_export(excluded_electricity_continental_shelf_or_eez).
root_export(excluded_hydrogen_continental_shelf_or_eez).
root_export(excluded_military_activities).
root_export(excluded_origin_annex_iii_point_1).
root_export(goods_kind).
root_export(heligoland).
root_export(hydrogen).
root_export(iceland).
root_export(liechtenstein).
root_export(livigno).
root_export(melilla).
root_export(member_state).
root_export(military_activities).
root_export(no).
root_export(no_origin_exclusion).
root_export(non_preferential_origin).
root_export(norway).
root_export(not_on_continental_shelf_or_eez).
root_export(not_third_country_origin).
root_export(other_annex_i_goods).
root_export(other_third_country).
root_export(switzerland).
root_export(unknown_key).
root_export(unsure).
root_export(wrong_type).
root_export(yes).
