% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_cbam_de_minimis___init__, [root_export/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_cbam_de_minimis_kernel, [de_minimis_input_problems/2]).
:- use_module(m__eu_cbam_de_minimis_citations, [citation/2, implements/1]).
:- use_module(m__eu_cbam_de_minimis_de_minimis, [de_minimis_checklist/2, de_minimis_decision_resolvable/1, de_minimis_exemption/3, de_minimis_goods_status/3, de_minimis_status/2, de_minimis_status_values/1, decide_de_minimis/2]).
:- use_module(m__eu_cbam_de_minimis_queries, [counted_toward_threshold/0, de_minimis_exemption_applies/0, de_minimis_exemption_does_not_apply/0, de_minimis_profile_keys/1, de_minimis_what_if/4, duplicate_key/1, indeterminate/1, input_problems/1, inputs_relied_on/1, needs_legal_review/2, not_goods_of_this_regulation/0, open_textured/2, outside_de_minimis_exemption/0, provenance/2, unknown_key/1, wrong_type/1]).
:- use_module(m__eu_cbam_de_minimis_fixtures, [de_minimis_assess/2, de_minimis_profile_for/2, de_minimis_subject/1]).

root_export(acceptance_of_the_customs_declaration).
root_export(counted_toward_threshold).
root_export(de_minimis_exemption_applies).
root_export(de_minimis_exemption_does_not_apply).
root_export(electricity).
root_export(goods_kind).
root_export(goods_not_listed_in_annex_i).
root_export(hydrogen).
root_export(net_mass_kg_by_acceptance_date).
root_export(net_mass_kg_by_release_date).
root_export(not_goods_of_this_regulation).
root_export(other_annex_i_goods).
root_export(outside_de_minimis_exemption).
root_export(release_for_free_circulation).
root_export(single_mass_based_threshold_tonnes).
root_export(unsure).
root_export(year_date_basis).
