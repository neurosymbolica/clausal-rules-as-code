:- module(m__eu_procurement_life_cycle_costing_life_cycle_costing, [decide_lcc_method_validity/2, decide_lcc_mandatory_method/2, decide_lcc_computation/2, lcc_method_validity_limb_status/4, lcc_externality_assessment/2, lcc_mandatory_method_status/3, lcc_union_act_listing/2, lcc_total/2, lcc_component_admissibility/3, lcc_cost_category/1, life_cycle_costing_input_problem/3]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_dicts, [dict_keys/2, get/3]).
:- use_module(clausal_lists_extra, [is_list/1]).
:- use_module(library(clpz)).
:- use_module(m__eu_procurement_life_cycle_costing_citations, [implements/1]).
:- use_module(formalize_lib, [profile_lacks/2, not_member/2]).

lcc_cost_category(acquisition_cost).
lcc_cost_category(use_cost).
lcc_cost_category(maintenance_cost).
lcc_cost_category(end_of_life_cost).
lcc_cost_category(other_cost_borne_by_authority_or_users).
lcc_cost_category(environmental_externality_cost).

lcc_cost_category_citation(acquisition_cost, cite(eu_dir_2014_24_art_68_1_a_i)).
lcc_cost_category_citation(use_cost, cite(eu_dir_2014_24_art_68_1_a_ii)).
lcc_cost_category_citation(maintenance_cost, cite(eu_dir_2014_24_art_68_1_a_iii)).
lcc_cost_category_citation(end_of_life_cost, cite(eu_dir_2014_24_art_68_1_a_iv)).
lcc_cost_category_citation(other_cost_borne_by_authority_or_users, cite(eu_dir_2014_24_art_68_1_a)).

lcc_union_act_id(directive_2009_33_ec).
lcc_union_act_id(other_union_act).
lcc_union_act_id(no_union_common_method).

annex_xiii_act(directive_2009_33_ec).

lcc_defect_order(externality_cost_monetary_value_not_determinable).
lcc_defect_order(tenderer_data_not_indicated).
lcc_defect_order(costing_method_not_indicated).
lcc_defect_order(externality_method_criteria_not_objectively_verifiable).
lcc_defect_order(externality_method_criteria_discriminatory).
lcc_defect_order(undue_favour_or_disadvantage_of_economic_operators).
lcc_defect_order(externality_method_not_accessible).
lcc_defect_order(externality_data_not_obtainable_with_reasonable_effort).
lcc_defect_order(externality_data_not_obtainable_by_gpa_operators).

lcc_first_alinea_limb(tenderer_data_not_indicated).
lcc_first_alinea_limb(costing_method_not_indicated).

lcc_externality_limb(externality_cost_monetary_value_not_determinable).
lcc_externality_limb(externality_method_criteria_not_objectively_verifiable).
lcc_externality_limb(externality_method_criteria_discriminatory).
lcc_externality_limb(undue_favour_or_disadvantage_of_economic_operators).
lcc_externality_limb(externality_method_not_accessible).
lcc_externality_limb(externality_data_not_obtainable_with_reasonable_effort).
lcc_externality_limb(externality_data_not_obtainable_by_gpa_operators).

lcc_simple_boolean_limb(tenderer_data_not_indicated, tenderer_data_indicated_in_procurement_documents).
lcc_simple_boolean_limb(costing_method_not_indicated, costing_method_indicated_in_procurement_documents).
lcc_simple_boolean_limb(externality_method_criteria_not_objectively_verifiable, externality_method_criteria_objectively_verifiable).
lcc_simple_boolean_limb(externality_method_criteria_discriminatory, externality_method_criteria_non_discriminatory).
lcc_simple_boolean_limb(externality_method_not_accessible, externality_method_accessible_to_all_interested_parties).
lcc_simple_boolean_limb(externality_data_not_obtainable_with_reasonable_effort, externality_data_obtainable_with_reasonable_effort).
lcc_simple_boolean_limb(externality_data_not_obtainable_by_gpa_operators, externality_data_obtainable_by_third_country_gpa_operators).

lcc_limb_citation(externality_cost_monetary_value_not_determinable, cite(eu_dir_2014_24_art_68_1_b)).
lcc_limb_citation(tenderer_data_not_indicated, cite(eu_dir_2014_24_art_68_2)).
lcc_limb_citation(costing_method_not_indicated, cite(eu_dir_2014_24_art_68_2)).
lcc_limb_citation(externality_method_criteria_not_objectively_verifiable, cite(eu_dir_2014_24_art_68_2_a)).
lcc_limb_citation(externality_method_criteria_discriminatory, cite(eu_dir_2014_24_art_68_2_a)).
lcc_limb_citation(undue_favour_or_disadvantage_of_economic_operators, cite(eu_dir_2014_24_art_68_2_a)).
lcc_limb_citation(externality_method_not_accessible, cite(eu_dir_2014_24_art_68_2_b)).
lcc_limb_citation(externality_data_not_obtainable_with_reasonable_effort, cite(eu_dir_2014_24_art_68_2_c)).
lcc_limb_citation(externality_data_not_obtainable_by_gpa_operators, cite(eu_dir_2014_24_art_68_2_c)).

lcc_has_externality_category([], no_externality).
lcc_has_externality_category([[environmental_externality_cost, _, _]|_], has_externality).
lcc_has_externality_category([[Category, _, _]|Rest], Status) :-
    dif(Category, environmental_externality_cost),
    lcc_has_externality_category(Rest, Status).

lcc_has_externality_not_determinable([], no_not_determinable).
lcc_has_externality_not_determinable([[environmental_externality_cost, _, 0]|_], has_not_determinable).
lcc_has_externality_not_determinable([[environmental_externality_cost, _, 1]|Rest], Status) :-
    lcc_has_externality_not_determinable(Rest, Status).
lcc_has_externality_not_determinable([[Category, _, _]|Rest], Status) :-
    dif(Category, environmental_externality_cost),
    lcc_has_externality_not_determinable(Rest, Status).

lcc_has_negative_amount([], no_negative).
lcc_has_negative_amount([[_Category, AmountEurCents, _]|_Rest], has_negative) :-
    AmountEurCents #< 0.
lcc_has_negative_amount([[_Category, AmountEurCents, _]|Rest], Status) :-
    AmountEurCents #>= 0,
    lcc_has_negative_amount(Rest, Status).

lcc_total_acc([], Acc, Acc).
lcc_total_acc([[CostCategory, AmountEurCents, Determinable]|Rest], Acc, TotalEurCents) :-
    AmountEurCents #>= 0,
    lcc_component_admissibility(CostCategory, Determinable, component_included),
    NewAcc #= Acc + AmountEurCents,
    lcc_total_acc(Rest, NewAcc, TotalEurCents).
lcc_total_acc([[CostCategory, AmountEurCents, Determinable]|Rest], Acc, TotalEurCents) :-
    AmountEurCents #>= 0,
    lcc_component_admissibility(CostCategory, Determinable, component_excluded),
    lcc_total_acc(Rest, Acc, TotalEurCents).

lcc_category_excluded_present([[Category, _AmountEurCents, Determinable]|_Rest], Category) :-
    lcc_component_admissibility(Category, Determinable, component_excluded).
lcc_category_excluded_present([[Category, _AmountEurCents, Determinable]|Rest], Category) :-
    lcc_component_admissibility(Category, Determinable, component_included),
    lcc_category_excluded_present(Rest, Category).
lcc_category_excluded_present([[OtherCategory, _AmountEurCents, _Determinable]|Rest], Category) :-
    dif(OtherCategory, Category),
    lcc_category_excluded_present(Rest, Category).

lcc_excluded_categories(CostComponents, ExcludedCategories) :-
    implements(eu_dir_2014_24_art_68_1_a),
    implements(eu_dir_2014_24_art_68_1_a_i),
    implements(eu_dir_2014_24_art_68_1_a_ii),
    implements(eu_dir_2014_24_art_68_1_a_iii),
    implements(eu_dir_2014_24_art_68_1_a_iv),
    findall(Category, (lcc_cost_category(Category), lcc_category_excluded_present(CostComponents, Category)), ExcludedCategories).

lcc_component_admissibility(acquisition_cost, _Determinable, component_included).
lcc_component_admissibility(use_cost, _Determinable, component_included).
lcc_component_admissibility(maintenance_cost, _Determinable, component_included).
lcc_component_admissibility(end_of_life_cost, _Determinable, component_included).
lcc_component_admissibility(other_cost_borne_by_authority_or_users, _Determinable, component_included).
lcc_component_admissibility(environmental_externality_cost, 1, component_included).
lcc_component_admissibility(environmental_externality_cost, 0, component_excluded).

lcc_total(CostComponents, TotalEurCents) :-
    implements(eu_dir_2014_24_art_68_1),
    ground(CostComponents),
    lcc_cost_components_acceptable(CostComponents),
    lcc_total_acc(CostComponents, 0, TotalEurCents).

lcc_externality_assessment(CostComponents, externality_costs_assessed) :-
    implements(eu_dir_2014_24_art_68_1_b),
    ground(CostComponents),
    lcc_cost_components_acceptable(CostComponents),
    lcc_has_externality_category(CostComponents, has_externality).
lcc_externality_assessment(CostComponents, externality_costs_not_assessed) :-
    implements(eu_dir_2014_24_art_68_1_b),
    ground(CostComponents),
    lcc_cost_components_acceptable(CostComponents),
    lcc_has_externality_category(CostComponents, no_externality).

lcc_mandatory_method_status(no_union_common_method, _Applied, no_union_common_method_mandatory).
lcc_mandatory_method_status(directive_2009_33_ec, 1, union_common_method_mandatory_and_applied).
lcc_mandatory_method_status(directive_2009_33_ec, 0, union_common_method_mandatory_and_not_applied).
lcc_mandatory_method_status(other_union_act, 1, union_common_method_mandatory_and_applied).
lcc_mandatory_method_status(other_union_act, 0, union_common_method_mandatory_and_not_applied).

lcc_union_act_listing(no_union_common_method, no_union_act) :-
    implements(eu_dir_2014_24_annex_xiii).
lcc_union_act_listing(UnionActKey, listed_in_annex_xiii) :-
    implements(eu_dir_2014_24_annex_xiii),
    dif(UnionActKey, no_union_common_method),
    annex_xiii_act(UnionActKey).
lcc_union_act_listing(UnionActKey, not_listed_in_annex_xiii) :-
    implements(eu_dir_2014_24_annex_xiii),
    dif(UnionActKey, no_union_common_method),
    lcc_outside_annex_xiii(UnionActKey).

lcc_outside_annex_xiii(UnionActKey) :-
    findall(Act, annex_xiii_act(Act), AnnexXiiiActs),
    not_member(UnionActKey, AnnexXiiiActs).

lcc_limb_gate(LimbId, Profile, gate_open) :-
    lcc_first_alinea_limb(LimbId),
    get(Profile, cost_components, CostComponents),
    dif(CostComponents, []).
lcc_limb_gate(LimbId, Profile, gate_closed) :-
    lcc_first_alinea_limb(LimbId),
    get(Profile, cost_components, CostComponents),
    CostComponents = [].
lcc_limb_gate(LimbId, Profile, gate_open) :-
    lcc_externality_limb(LimbId),
    get(Profile, cost_components, CostComponents),
    dif(CostComponents, []),
    lcc_has_externality_category(CostComponents, has_externality).
lcc_limb_gate(LimbId, Profile, gate_closed) :-
    lcc_externality_limb(LimbId),
    get(Profile, cost_components, CostComponents),
    CostComponents = [].
lcc_limb_gate(LimbId, Profile, gate_closed) :-
    lcc_externality_limb(LimbId),
    get(Profile, cost_components, CostComponents),
    dif(CostComponents, []),
    lcc_has_externality_category(CostComponents, no_externality).

lcc_limb_defect(DefectId, Profile, defect_present) :-
    lcc_simple_boolean_limb(DefectId, ProfileKey),
    implements(eu_dir_2014_24_art_68_2),
    implements(eu_dir_2014_24_art_68_2_a),
    implements(eu_dir_2014_24_art_68_2_b),
    implements(eu_dir_2014_24_art_68_2_c),
    get(Profile, ProfileKey, Flag),
    Flag = false.
lcc_limb_defect(DefectId, Profile, defect_absent) :-
    lcc_simple_boolean_limb(DefectId, ProfileKey),
    implements(eu_dir_2014_24_art_68_2),
    implements(eu_dir_2014_24_art_68_2_a),
    implements(eu_dir_2014_24_art_68_2_b),
    implements(eu_dir_2014_24_art_68_2_c),
    get(Profile, ProfileKey, Flag),
    Flag = true.
lcc_limb_defect(externality_cost_monetary_value_not_determinable, Profile, defect_present) :-
    implements(eu_dir_2014_24_art_68_1_b),
    get(Profile, cost_components, CostComponents),
    lcc_has_externality_not_determinable(CostComponents, has_not_determinable).
lcc_limb_defect(externality_cost_monetary_value_not_determinable, Profile, defect_absent) :-
    implements(eu_dir_2014_24_art_68_1_b),
    get(Profile, cost_components, CostComponents),
    lcc_has_externality_not_determinable(CostComponents, no_not_determinable).
lcc_limb_defect(undue_favour_or_disadvantage_of_economic_operators, Profile, defect_present) :-
    implements(eu_dir_2014_24_art_68_2_a),
    get(Profile, externality_method_established_for_repeated_or_continuous_application, Established),
    Established = false,
    get(Profile, externality_method_unduly_favours_or_disadvantages_operators, Undue),
    Undue = true.
lcc_limb_defect(undue_favour_or_disadvantage_of_economic_operators, Profile, defect_absent) :-
    implements(eu_dir_2014_24_art_68_2_a),
    get(Profile, externality_method_established_for_repeated_or_continuous_application, Established),
    Established = true.
lcc_limb_defect(undue_favour_or_disadvantage_of_economic_operators, Profile, defect_absent) :-
    implements(eu_dir_2014_24_art_68_2_a),
    get(Profile, externality_method_established_for_repeated_or_continuous_application, Established),
    Established = false,
    get(Profile, externality_method_unduly_favours_or_disadvantages_operators, Undue),
    Undue = false.

lcc_limb_status(LimbId, Profile, satisfied) :-
    lcc_limb_gate(LimbId, Profile, gate_closed).
lcc_limb_status(LimbId, Profile, satisfied) :-
    lcc_limb_gate(LimbId, Profile, gate_open),
    lcc_limb_defect(LimbId, Profile, defect_absent).
lcc_limb_status(LimbId, Profile, not_satisfied) :-
    lcc_limb_gate(LimbId, Profile, gate_open),
    lcc_limb_defect(LimbId, Profile, defect_present).

lcc_limb_row(LimbId, Profile, Status, Citation) :-
    lcc_limb_citation(LimbId, Citation),
    lcc_limb_status(LimbId, Profile, Status).

lcc_method_validity_limb_status(LimbId, Profile, Status, Citation) :-
    lcc_input_acceptable(method_validity, Profile),
    lcc_limb_row(LimbId, Profile, Status, Citation).

lcc_method_validity_defects(Profile, DefectIds) :-
    findall(DefectId, (lcc_defect_order(DefectId), lcc_limb_row(DefectId, Profile, not_satisfied, _Citation)), DefectIds).

lcc_method_validity_citations(DefectIds, Citations) :-
    findall(Citation, (lcc_defect_order(DefectId), member(DefectId, DefectIds), lcc_limb_citation(DefectId, Citation)), Citations).

lcc_method_validity_checklist(Profile, Checklist) :-
    findall(Item, (lcc_defect_order(LimbId), lcc_limb_row(LimbId, Profile, Status, Citation), Item = item(LimbId, Status, Citation)), Checklist).

lcc_decide_method_validity(Profile, lcc_method_validity_verdict(valid_lcc_method, [], [])) :-
    implements(eu_dir_2014_24_art_68_2),
    lcc_method_validity_defects(Profile, DefectIds),
    DefectIds = [].
lcc_decide_method_validity(Profile, lcc_method_validity_verdict(invalid_lcc_method, DefectIds, Citations)) :-
    implements(eu_dir_2014_24_art_68_2),
    lcc_method_validity_defects(Profile, DefectIds),
    dif(DefectIds, []),
    lcc_method_validity_citations(DefectIds, Citations).

lcc_decide_mandatory_method(Profile, lcc_mandatory_method_verdict(no_union_common_method_mandatory, [], [])) :-
    implements(eu_dir_2014_24_art_68_3),
    get(Profile, union_common_method_act_key, no_union_common_method).
lcc_decide_mandatory_method(Profile, lcc_mandatory_method_verdict(union_common_method_mandatory_and_applied, [], [])) :-
    implements(eu_dir_2014_24_art_68_3),
    get(Profile, union_common_method_act_key, ActKey),
    get(Profile, union_common_method_applied, AppliedBool),
    AppliedBool = true,
    lcc_mandatory_method_status(ActKey, 1, union_common_method_mandatory_and_applied).
lcc_decide_mandatory_method(Profile, lcc_mandatory_method_verdict(union_common_method_mandatory_and_not_applied, [mandatory_union_common_method_not_applied], [cite(eu_dir_2014_24_art_68_3)])) :-
    implements(eu_dir_2014_24_art_68_3),
    get(Profile, union_common_method_act_key, ActKey),
    get(Profile, union_common_method_applied, AppliedBool),
    AppliedBool = false,
    lcc_mandatory_method_status(ActKey, 0, union_common_method_mandatory_and_not_applied).

lcc_decide_computation(Profile, lcc_computation_verdict(lcc_no_costs_declared, 0, [])) :-
    implements(eu_dir_2014_24_art_68_1),
    get(Profile, cost_components, CostComponents),
    CostComponents = [].
lcc_decide_computation(Profile, lcc_computation_verdict(lcc_indeterminate, 0, [])) :-
    implements(eu_dir_2014_24_art_68_1),
    get(Profile, cost_components, CostComponents),
    dif(CostComponents, []),
    lcc_has_negative_amount(CostComponents, has_negative).
lcc_decide_computation(Profile, lcc_computation_verdict(lcc_computed, TotalEurCents, ExcludedCategories)) :-
    implements(eu_dir_2014_24_art_68_1),
    get(Profile, cost_components, CostComponents),
    dif(CostComponents, []),
    lcc_has_negative_amount(CostComponents, no_negative),
    lcc_total(CostComponents, TotalEurCents),
    lcc_excluded_categories(CostComponents, ExcludedCategories).

life_cycle_costing_input_problem(Determination, Profile, Problem) :-
    lcc_input_problems(Determination, Profile, [Problem|_]).

lcc_input_acceptable(Determination, Profile) :-
    lcc_input_problems(Determination, Profile, []).

lcc_input_problems(_Determination, Profile, [not_ground]) :-
    term_variables(Profile, [_|_]).
lcc_input_problems(_Determination, Profile, [wrong_type(profile, expected_dict)]) :-
    ground(Profile),
    \+ dict_keys(Profile, _).
lcc_input_problems(Determination, Profile, Problems) :-
    ground(Profile),
    dict_keys(Profile, _),
    findall(Problem, lcc_profile_problem(Determination, Profile, Problem), Problems).

lcc_reads_cost_components(method_validity).
lcc_reads_cost_components(computation).

lcc_first_alinea_key(tenderer_data_indicated_in_procurement_documents).
lcc_first_alinea_key(costing_method_indicated_in_procurement_documents).

lcc_externality_key(externality_method_criteria_objectively_verifiable).
lcc_externality_key(externality_method_criteria_non_discriminatory).
lcc_externality_key(externality_method_established_for_repeated_or_continuous_application).
lcc_externality_key(externality_method_accessible_to_all_interested_parties).
lcc_externality_key(externality_data_obtainable_with_reasonable_effort).
lcc_externality_key(externality_data_obtainable_by_third_country_gpa_operators).

lcc_boolean_key(tenderer_data_indicated_in_procurement_documents).
lcc_boolean_key(costing_method_indicated_in_procurement_documents).
lcc_boolean_key(externality_method_criteria_objectively_verifiable).
lcc_boolean_key(externality_method_criteria_non_discriminatory).
lcc_boolean_key(externality_method_established_for_repeated_or_continuous_application).
lcc_boolean_key(externality_method_unduly_favours_or_disadvantages_operators).
lcc_boolean_key(externality_method_accessible_to_all_interested_parties).
lcc_boolean_key(externality_data_obtainable_with_reasonable_effort).
lcc_boolean_key(externality_data_obtainable_by_third_country_gpa_operators).
lcc_boolean_key(union_common_method_applied).

lcc_boolean(true).
lcc_boolean(false).

lcc_determinability_flag(0).
lcc_determinability_flag(1).

lcc_three_element_record([_Category, _AmountEurCents, _Determinable]).

lcc_profile_problem(Determination, Profile, missing_key(cost_components)) :-
    lcc_reads_cost_components(Determination),
    profile_lacks(Profile, cost_components).
lcc_profile_problem(_Determination, Profile, Problem) :-
    get(Profile, cost_components, CostComponents),
    lcc_cost_components_problem(CostComponents, Problem).
lcc_profile_problem(computation, Profile, negative_amount(Component)) :-
    get(Profile, cost_components, CostComponents),
    is_list(CostComponents),
    member(Component, CostComponents),
    Component = [_Category, AmountEurCents, _Determinable],
    integer(AmountEurCents),
    AmountEurCents #< 0.
lcc_profile_problem(_Determination, Profile, wrong_type(Key, expected_boolean)) :-
    lcc_boolean_key(Key),
    get(Profile, Key, Value),
    dif(Value, true),
    dif(Value, false).
lcc_profile_problem(_Determination, Profile, wrong_value(union_common_method_act_key, expected_union_act_atom)) :-
    get(Profile, union_common_method_act_key, Value),
    findall(ActKey, lcc_union_act_id(ActKey), ActKeys),
    not_member(Value, ActKeys).
lcc_profile_problem(_Determination, Profile, incoherent_input(union_common_method_applied_without_union_act)) :-
    get(Profile, union_common_method_act_key, no_union_common_method),
    get(Profile, union_common_method_applied, true).
lcc_profile_problem(method_validity, Profile, missing_key(Key)) :-
    get(Profile, cost_components, CostComponents),
    dif(CostComponents, []),
    lcc_first_alinea_key(Key),
    profile_lacks(Profile, Key).
lcc_profile_problem(method_validity, Profile, missing_key(Key)) :-
    get(Profile, cost_components, CostComponents),
    lcc_list_has_externality(CostComponents),
    lcc_externality_key(Key),
    profile_lacks(Profile, Key).
lcc_profile_problem(method_validity, Profile, missing_key(externality_method_unduly_favours_or_disadvantages_operators)) :-
    get(Profile, cost_components, CostComponents),
    lcc_list_has_externality(CostComponents),
    get(Profile, externality_method_established_for_repeated_or_continuous_application, false),
    profile_lacks(Profile, externality_method_unduly_favours_or_disadvantages_operators).
lcc_profile_problem(mandatory_method, Profile, missing_key(union_common_method_act_key)) :-
    profile_lacks(Profile, union_common_method_act_key).
lcc_profile_problem(mandatory_method, Profile, missing_key(union_common_method_applied)) :-
    get(Profile, union_common_method_act_key, ActKey),
    dif(ActKey, no_union_common_method),
    profile_lacks(Profile, union_common_method_applied).

lcc_cost_components_acceptable(CostComponents) :-
    findall(Problem, lcc_cost_components_problem(CostComponents, Problem), []).

lcc_cost_components_problem(CostComponents, not_a_list(cost_components)) :-
    lcc_improper_list(CostComponents).
lcc_cost_components_problem(CostComponents, Problem) :-
    is_list(CostComponents),
    member(Component, CostComponents),
    lcc_component_problem(Component, Problem).

lcc_component_problem(Component, malformed_cost_component(Component)) :-
    lcc_shape_differs(Component, [_, _, _]).
lcc_component_problem([Category, _AmountEurCents, _Determinable], unknown_cost_category(Category)) :-
    findall(Known, lcc_cost_category(Known), KnownCategories),
    not_member(Category, KnownCategories).
lcc_component_problem([Category, AmountEurCents, Determinable], wrong_type(cost_component([Category, AmountEurCents, Determinable]), expected_integer_euro_cents)) :-
    lcc_not_an_integer(AmountEurCents).
lcc_component_problem([Category, AmountEurCents, Determinable], wrong_type(cost_component([Category, AmountEurCents, Determinable]), expected_zero_or_one)) :-
    lcc_not_an_integer(Determinable).
lcc_component_problem([Category, AmountEurCents, Determinable], wrong_type(cost_component([Category, AmountEurCents, Determinable]), expected_zero_or_one)) :-
    integer(Determinable),
    findall(Flag, lcc_determinability_flag(Flag), Flags),
    not_member(Determinable, Flags).

lcc_list_has_externality(CostComponents) :-
    is_list(CostComponents),
    lcc_contains_externality(CostComponents).

lcc_contains_externality([Component|_]) :-
    Component = [environmental_externality_cost, _AmountEurCents, _Determinable].
lcc_contains_externality([Component|Rest]) :-
    lcc_not_externality_record(Component),
    lcc_contains_externality(Rest).

lcc_not_externality_record(Component) :-
    lcc_shape_differs(Component, [_, _, _]).
lcc_not_externality_record([Category, _AmountEurCents, _Determinable]) :-
    dif(Category, environmental_externality_cost).

lcc_not_an_integer(Value) :-
    atom(Value).
lcc_not_an_integer(Value) :-
    float(Value).
lcc_not_an_integer(Value) :-
    compound(Value).
lcc_not_an_integer(Value) :-
    dict_keys(Value, _).

lcc_non_list_term(Term) :-
    atomic(Term),
    dif(Term, []).
lcc_non_list_term(Term) :-
    dict_keys(Term, _),
    dif(Term, []).
lcc_non_list_term(Term) :-
    compound(Term),
    functor(Term, Name, Arity),
    functor([list_cell], ListName, ListArity),
    dif(Name/Arity, ListName/ListArity).

lcc_improper_list(Term) :-
    lcc_non_list_term(Term).
lcc_improper_list([_|Tail]) :-
    lcc_improper_list(Tail).

lcc_shape_differs(Term, _Skeleton) :-
    lcc_non_list_term(Term).
lcc_shape_differs([], [_|_]).
lcc_shape_differs([_|_], []).
lcc_shape_differs([_|Tail], [_|SkeletonTail]) :-
    lcc_shape_differs(Tail, SkeletonTail).

no_statute("lcc_input_acceptable", 2, "computation_helper").
no_statute("lcc_outside_annex_xiii", 1, "computation_helper").
no_statute("lcc_cost_components_acceptable", 1, "computation_helper").
no_statute("lcc_contains_externality", 1, "computation_helper").
no_statute("lcc_not_externality_record", 1, "computation_helper").
no_statute("lcc_not_an_integer", 1, "computation_helper").
no_statute("lcc_non_list_term", 1, "computation_helper").
no_statute("lcc_improper_list", 1, "computation_helper").
no_statute("lcc_shape_differs", 2, "computation_helper").

decide_lcc_method_validity(Profile, Verdict) :-
    lcc_input_acceptable(method_validity, Profile),
    lcc_decide_method_validity(Profile, Verdict).

decide_lcc_mandatory_method(Profile, Verdict) :-
    lcc_input_acceptable(mandatory_method, Profile),
    lcc_decide_mandatory_method(Profile, Verdict).

decide_lcc_computation(Profile, lcc_computation_verdict(lcc_indeterminate, 0, [])) :-
    implements(eu_dir_2014_24_art_68_1),
    life_cycle_costing_input_problem(computation, Profile, _Problem).
decide_lcc_computation(Profile, Verdict) :-
    lcc_input_acceptable(computation, Profile),
    lcc_decide_computation(Profile, Verdict).
