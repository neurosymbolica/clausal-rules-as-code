:- module(m__eu_procurement_life_cycle_costing___init__, [root_export/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_procurement_life_cycle_costing_citations, [citation/2, implements/1]).
:- use_module(m__eu_procurement_life_cycle_costing_life_cycle_costing, [decide_lcc_computation/2, decide_lcc_mandatory_method/2, decide_lcc_method_validity/2, lcc_component_admissibility/3, lcc_cost_category/1, lcc_externality_assessment/2, lcc_mandatory_method_status/3, lcc_method_validity_limb_status/4, lcc_total/2, lcc_union_act_listing/2, life_cycle_costing_input_problem/3]).
:- use_module(m__eu_procurement_life_cycle_costing_queries, [life_cycle_costing_calculation/2, life_cycle_costing_checklist/2, life_cycle_costing_defect_enumeration/2, life_cycle_costing_eligibility/2, life_cycle_costing_profile_keys/1, life_cycle_costing_status/2, life_cycle_costing_what_if/4]).
:- use_module(m__eu_procurement_life_cycle_costing_fixtures, [life_cycle_costing_assess/2, life_cycle_costing_profile_for/2, life_cycle_costing_subject/1]).

root_export(acquisition_cost).
root_export(cost_components).
root_export(costing_method_indicated_in_procurement_documents).
root_export(costing_method_not_indicated).
root_export(directive_2009_33_ec).
root_export(end_of_life_cost).
root_export(environmental_externality_cost).
root_export(externality_cost_monetary_value_not_determinable).
root_export(externality_data_not_obtainable_by_gpa_operators).
root_export(externality_data_not_obtainable_with_reasonable_effort).
root_export(externality_data_obtainable_by_third_country_gpa_operators).
root_export(externality_data_obtainable_with_reasonable_effort).
root_export(externality_method_accessible_to_all_interested_parties).
root_export(externality_method_criteria_discriminatory).
root_export(externality_method_criteria_non_discriminatory).
root_export(externality_method_criteria_not_objectively_verifiable).
root_export(externality_method_criteria_objectively_verifiable).
root_export(externality_method_established_for_repeated_or_continuous_application).
root_export(externality_method_not_accessible).
root_export(externality_method_unduly_favours_or_disadvantages_operators).
root_export(lcc_computation_verdict).
root_export(lcc_mandatory_method_verdict).
root_export(lcc_method_validity_verdict).
root_export(maintenance_cost).
root_export(no_union_common_method).
root_export(other_cost_borne_by_authority_or_users).
root_export(other_union_act).
root_export(tenderer_data_indicated_in_procurement_documents).
root_export(tenderer_data_not_indicated).
root_export(undue_favour_or_disadvantage_of_economic_operators).
root_export(union_common_method_act_key).
root_export(union_common_method_applied).
root_export(use_cost).
