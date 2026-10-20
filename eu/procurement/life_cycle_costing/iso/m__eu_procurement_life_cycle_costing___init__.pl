:- module(m__eu_procurement_life_cycle_costing___init__, []).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_procurement_life_cycle_costing_citations, [citation/2, implements/1]).
:- use_module(m__eu_procurement_life_cycle_costing_life_cycle_costing, [decide_lcc_computation/2, decide_lcc_mandatory_method/2, decide_lcc_method_validity/2, lcc_component_admissibility/3, lcc_cost_category/1, lcc_externality_assessment/2, lcc_mandatory_method_status/3, lcc_method_validity_limb_status/4, lcc_total/2, lcc_union_act_listing/2, life_cycle_costing_input_problem/3]).
:- use_module(m__eu_procurement_life_cycle_costing_queries, [life_cycle_costing_calculation/2, life_cycle_costing_checklist/2, life_cycle_costing_defect_enumeration/2, life_cycle_costing_eligibility/2, life_cycle_costing_profile_keys/1, life_cycle_costing_status/2, life_cycle_costing_what_if/4]).
:- use_module(m__eu_procurement_life_cycle_costing_fixtures, [life_cycle_costing_assess/2, life_cycle_costing_profile_for/2, life_cycle_costing_subject/1]).
