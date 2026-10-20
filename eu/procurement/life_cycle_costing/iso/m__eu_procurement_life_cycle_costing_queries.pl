:- module(m__eu_procurement_life_cycle_costing_queries, [life_cycle_costing_profile_keys/1, life_cycle_costing_what_if/4, life_cycle_costing_eligibility/2, life_cycle_costing_status/2, life_cycle_costing_defect_enumeration/2, life_cycle_costing_checklist/2, life_cycle_costing_calculation/2]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_dicts, [get/3]).
:- use_module(m__eu_procurement_life_cycle_costing_life_cycle_costing, [decide_lcc_method_validity/2, decide_lcc_mandatory_method/2, decide_lcc_computation/2, lcc_method_validity_limb_status/4, lcc_total/2, life_cycle_costing_input_problem/3]).
:- use_module(query_combinators, [override_key/4]).

life_cycle_costing_profile_keys([cost_components, tenderer_data_indicated_in_procurement_documents, costing_method_indicated_in_procurement_documents, externality_method_criteria_objectively_verifiable, externality_method_criteria_non_discriminatory, externality_method_established_for_repeated_or_continuous_application, externality_method_unduly_favours_or_disadvantages_operators, externality_method_accessible_to_all_interested_parties, externality_data_obtainable_with_reasonable_effort, externality_data_obtainable_by_third_country_gpa_operators, union_common_method_act_key, union_common_method_applied]).

life_cycle_costing_eligibility(Profile, Verdict) :-
    decide_lcc_method_validity(Profile, Verdict).

life_cycle_costing_status(Profile, Status) :-
    decide_lcc_mandatory_method(Profile, lcc_mandatory_method_verdict(Status, _, _)).

life_cycle_costing_defect_enumeration(Profile, DefectIds) :-
    decide_lcc_method_validity(Profile, lcc_method_validity_verdict(_, DefectIds, _)).

life_cycle_costing_checklist(Profile, Checklist) :-
    findall(Item, (member(LimbId, [externality_cost_monetary_value_not_determinable, tenderer_data_not_indicated, costing_method_not_indicated, externality_method_criteria_not_objectively_verifiable, externality_method_criteria_discriminatory, undue_favour_or_disadvantage_of_economic_operators, externality_method_not_accessible, externality_data_not_obtainable_with_reasonable_effort, externality_data_not_obtainable_by_gpa_operators]), lcc_method_validity_limb_status(LimbId, Profile, Status, Citation), Item = item(LimbId, Status, Citation)), Checklist).

life_cycle_costing_calculation(Profile, TotalEurCents) :-
    findall(Problem, life_cycle_costing_input_problem(computation, Profile, Problem), []),
    get(Profile, cost_components, CostComponents),
    lcc_total(CostComponents, TotalEurCents).

life_cycle_costing_what_if(Profile, OverriddenKey, NewValue, NewVerdict) :-
    override_key(Profile, OverriddenKey, NewValue, Hypothesis),
    decide_lcc_method_validity(Hypothesis, NewVerdict).
