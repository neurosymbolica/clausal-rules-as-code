:- module(m__eu_procurement_life_cycle_costing_tests_test_public_interface, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_procurement_life_cycle_costing_life_cycle_costing, [decide_lcc_method_validity/2, decide_lcc_mandatory_method/2, decide_lcc_computation/2, lcc_method_validity_limb_status/4, lcc_externality_assessment/2, lcc_mandatory_method_status/3, lcc_union_act_listing/2, lcc_total/2, lcc_component_admissibility/3]).
:- use_module(m__eu_procurement_life_cycle_costing_fixtures, [life_cycle_costing_subject/1, life_cycle_costing_profile_for/2, life_cycle_costing_assess/2]).
:- use_module(m__eu_procurement_life_cycle_costing_queries, [life_cycle_costing_checklist/2, life_cycle_costing_eligibility/2, life_cycle_costing_status/2, life_cycle_costing_defect_enumeration/2, life_cycle_costing_calculation/2, life_cycle_costing_what_if/4, life_cycle_costing_profile_keys/1]).

test('no_lcc_approach: valid method, empty defects') :-
    life_cycle_costing_profile_for("no_lcc_approach", Profile),
    decide_lcc_method_validity(Profile, lcc_method_validity_verdict(valid_lcc_method, [], [])).
test('no_lcc_approach_flag_false: still valid (outer gate voids all limbs)') :-
    life_cycle_costing_profile_for("no_lcc_approach_flag_false", Profile),
    decide_lcc_method_validity(Profile, lcc_method_validity_verdict(valid_lcc_method, [], [])).
test('basic_compliant: valid method, no defects') :-
    life_cycle_costing_profile_for("basic_compliant", Profile),
    decide_lcc_method_validity(Profile, lcc_method_validity_verdict(valid_lcc_method, [], [])).
test('basic_tenderer_missing: invalid, tenderer_data_not_indicated') :-
    life_cycle_costing_profile_for("basic_tenderer_missing", Profile),
    decide_lcc_method_validity(Profile, lcc_method_validity_verdict(invalid_lcc_method, [tenderer_data_not_indicated], [cite(eu_dir_2014_24_art_68_2)])).
test('externality_compliant: valid method, no defects') :-
    life_cycle_costing_profile_for("externality_compliant", Profile),
    decide_lcc_method_validity(Profile, lcc_method_validity_verdict(valid_lcc_method, [], [])).
test('externality_not_determinable: invalid, monetary value defect') :-
    life_cycle_costing_profile_for("externality_not_determinable", Profile),
    decide_lcc_method_validity(Profile, lcc_method_validity_verdict(invalid_lcc_method, [externality_cost_monetary_value_not_determinable], [cite(eu_dir_2014_24_art_68_1_b)])).
test('externality_undue_favour: invalid, undue favour defect') :-
    life_cycle_costing_profile_for("externality_undue_favour", Profile),
    decide_lcc_method_validity(Profile, lcc_method_validity_verdict(invalid_lcc_method, [undue_favour_or_disadvantage_of_economic_operators], [cite(eu_dir_2014_24_art_68_2_a)])).
test('externality_established: valid (established method cannot breach limb 6)') :-
    life_cycle_costing_profile_for("externality_established", Profile),
    decide_lcc_method_validity(Profile, lcc_method_validity_verdict(valid_lcc_method, [], [])).
test('mandatory_applied: union_common_method_mandatory_and_applied') :-
    life_cycle_costing_profile_for("mandatory_applied", Profile),
    decide_lcc_mandatory_method(Profile, lcc_mandatory_method_verdict(union_common_method_mandatory_and_applied, [], [])).
test('mandatory_not_applied: union_common_method_mandatory_and_not_applied with defect') :-
    life_cycle_costing_profile_for("mandatory_not_applied", Profile),
    decide_lcc_mandatory_method(Profile, lcc_mandatory_method_verdict(union_common_method_mandatory_and_not_applied, [mandatory_union_common_method_not_applied], [cite(eu_dir_2014_24_art_68_3)])).
test('no_lcc_approach: no_union_common_method_mandatory') :-
    life_cycle_costing_profile_for("no_lcc_approach", Profile),
    decide_lcc_mandatory_method(Profile, lcc_mandatory_method_verdict(no_union_common_method_mandatory, [], [])).
test('no_lcc_approach: lcc_no_costs_declared') :-
    life_cycle_costing_profile_for("no_lcc_approach", Profile),
    decide_lcc_computation(Profile, lcc_computation_verdict(lcc_no_costs_declared, 0, [])).
test('basic_compliant: lcc_computed, total 10000') :-
    life_cycle_costing_profile_for("basic_compliant", Profile),
    decide_lcc_computation(Profile, lcc_computation_verdict(lcc_computed, 10000, [])).
test('externality_compliant: lcc_computed, total 15000') :-
    life_cycle_costing_profile_for("externality_compliant", Profile),
    decide_lcc_computation(Profile, lcc_computation_verdict(lcc_computed, 15000, [])).
test('externality_not_determinable: lcc_computed, total 10000, externality excluded') :-
    life_cycle_costing_profile_for("externality_not_determinable", Profile),
    decide_lcc_computation(Profile, lcc_computation_verdict(lcc_computed, 10000, [environmental_externality_cost])).
test('negative_amount: lcc_indeterminate') :-
    life_cycle_costing_profile_for("negative_amount", Profile),
    decide_lcc_computation(Profile, lcc_computation_verdict(lcc_indeterminate, 0, [])).
test('zero_amount: lcc_computed, total 0') :-
    life_cycle_costing_profile_for("zero_amount", Profile),
    decide_lcc_computation(Profile, lcc_computation_verdict(lcc_computed, 0, [])).
test('checklist has exactly 9 items on basic_compliant') :-
    life_cycle_costing_profile_for("basic_compliant", Profile),
    life_cycle_costing_checklist(Profile, Checklist),
    length(Checklist, 9).
test('checklist has exactly 9 items on externality_compliant') :-
    life_cycle_costing_profile_for("externality_compliant", Profile),
    life_cycle_costing_checklist(Profile, Checklist),
    length(Checklist, 9).
test('checklist non-empty on no_lcc_approach') :-
    life_cycle_costing_profile_for("no_lcc_approach", Profile),
    life_cycle_costing_checklist(Profile, Checklist),
    length(Checklist, 9).
test('acquisition_cost always included') :-
    lcc_component_admissibility(acquisition_cost, 1, component_included).
test('acquisition_cost included even with 0') :-
    lcc_component_admissibility(acquisition_cost, 0, component_included).
test('environmental_externality_cost included when determinable') :-
    lcc_component_admissibility(environmental_externality_cost, 1, component_included).
test('environmental_externality_cost excluded when not determinable') :-
    lcc_component_admissibility(environmental_externality_cost, 0, component_excluded).
test('no_union_common_method: no method mandatory') :-
    lcc_mandatory_method_status(no_union_common_method, 1, no_union_common_method_mandatory).
test('directive_2009_33_ec applied: mandatory and applied') :-
    lcc_mandatory_method_status(directive_2009_33_ec, 1, union_common_method_mandatory_and_applied).
test('directive_2009_33_ec not applied: mandatory and not applied') :-
    lcc_mandatory_method_status(directive_2009_33_ec, 0, union_common_method_mandatory_and_not_applied).
test('other_union_act applied: mandatory and applied') :-
    lcc_mandatory_method_status(other_union_act, 1, union_common_method_mandatory_and_applied).
test('directive_2009_33_ec listed in annex xiii') :-
    lcc_union_act_listing(directive_2009_33_ec, listed_in_annex_xiii).
test('other_union_act not listed in annex xiii') :-
    lcc_union_act_listing(other_union_act, not_listed_in_annex_xiii).
test('no_union_common_method: no_union_act') :-
    lcc_union_act_listing(no_union_common_method, no_union_act).
test('empty list: externality_costs_not_assessed') :-
    lcc_externality_assessment([], externality_costs_not_assessed).
test('acquisition only: externality_costs_not_assessed') :-
    lcc_externality_assessment([[acquisition_cost, 100, 1]], externality_costs_not_assessed).
test('with externality: externality_costs_assessed') :-
    lcc_externality_assessment([[environmental_externality_cost, 100, 1]], externality_costs_assessed).
test('lcc_total: single acquisition 10000') :-
    lcc_total([[acquisition_cost, 10000, 1]], 10000).
test('lcc_total: two components sum to 15000') :-
    lcc_total([[acquisition_cost, 10000, 1], [use_cost, 5000, 1]], 15000).
test('lcc_total: externality excluded, only acquisition counted') :-
    lcc_total([[acquisition_cost, 10000, 1], [environmental_externality_cost, 5000, 0]], 10000).
test('lcc_total: empty list sums to 0') :-
    lcc_total([], 0).
test('profile_keys has 12 entries') :-
    life_cycle_costing_profile_keys(Keys),
    length(Keys, 12).
test('what_if: flipping tenderer_data to False makes method invalid') :-
    life_cycle_costing_profile_for("basic_compliant", Profile),
    life_cycle_costing_what_if(Profile, tenderer_data_indicated_in_procurement_documents, false, lcc_method_validity_verdict(invalid_lcc_method, [tenderer_data_not_indicated], [cite(eu_dir_2014_24_art_68_2)])).
test('what_if: flipping tenderer_data to True on basic_tenderer_missing restores validity') :-
    life_cycle_costing_profile_for("basic_tenderer_missing", Profile),
    life_cycle_costing_what_if(Profile, tenderer_data_indicated_in_procurement_documents, true, lcc_method_validity_verdict(valid_lcc_method, [], [])).

cp_test_names(['no_lcc_approach: valid method, empty defects', 'no_lcc_approach_flag_false: still valid (outer gate voids all limbs)', 'basic_compliant: valid method, no defects', 'basic_tenderer_missing: invalid, tenderer_data_not_indicated', 'externality_compliant: valid method, no defects', 'externality_not_determinable: invalid, monetary value defect', 'externality_undue_favour: invalid, undue favour defect', 'externality_established: valid (established method cannot breach limb 6)', 'mandatory_applied: union_common_method_mandatory_and_applied', 'mandatory_not_applied: union_common_method_mandatory_and_not_applied with defect', 'no_lcc_approach: no_union_common_method_mandatory', 'no_lcc_approach: lcc_no_costs_declared', 'basic_compliant: lcc_computed, total 10000', 'externality_compliant: lcc_computed, total 15000', 'externality_not_determinable: lcc_computed, total 10000, externality excluded', 'negative_amount: lcc_indeterminate', 'zero_amount: lcc_computed, total 0', 'checklist has exactly 9 items on basic_compliant', 'checklist has exactly 9 items on externality_compliant', 'checklist non-empty on no_lcc_approach', 'acquisition_cost always included', 'acquisition_cost included even with 0', 'environmental_externality_cost included when determinable', 'environmental_externality_cost excluded when not determinable', 'no_union_common_method: no method mandatory', 'directive_2009_33_ec applied: mandatory and applied', 'directive_2009_33_ec not applied: mandatory and not applied', 'other_union_act applied: mandatory and applied', 'directive_2009_33_ec listed in annex xiii', 'other_union_act not listed in annex xiii', 'no_union_common_method: no_union_act', 'empty list: externality_costs_not_assessed', 'acquisition only: externality_costs_not_assessed', 'with externality: externality_costs_assessed', 'lcc_total: single acquisition 10000', 'lcc_total: two components sum to 15000', 'lcc_total: externality excluded, only acquisition counted', 'lcc_total: empty list sums to 0', 'profile_keys has 12 entries', 'what_if: flipping tenderer_data to False makes method invalid', 'what_if: flipping tenderer_data to True on basic_tenderer_missing restores validity']).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
