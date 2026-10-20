:- module(m__eu_procurement_life_cycle_costing_tests_test_negative_controls, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_procurement_life_cycle_costing_life_cycle_costing, [decide_lcc_method_validity/2, decide_lcc_mandatory_method/2, decide_lcc_computation/2, lcc_method_validity_limb_status/4, lcc_component_admissibility/3, lcc_externality_assessment/2]).
:- use_module(m__eu_procurement_life_cycle_costing_fixtures, [life_cycle_costing_profile_for/2]).

test('NC1 positive: empty list with all flags True yields valid') :-
    life_cycle_costing_profile_for("no_lcc_approach", Profile),
    decide_lcc_method_validity(Profile, lcc_method_validity_verdict(valid_lcc_method, [], [])).
test('NC1 near-miss: empty list with one flag False STILL yields valid (gate voids all)') :-
    life_cycle_costing_profile_for("no_lcc_approach_flag_false", Profile),
    decide_lcc_method_validity(Profile, lcc_method_validity_verdict(valid_lcc_method, [], [])).
test('NC2 positive: tenderer data indicated yields satisfied') :-
    life_cycle_costing_profile_for("basic_compliant", Profile),
    lcc_method_validity_limb_status(tenderer_data_not_indicated, Profile, satisfied, _Citation).
test('NC2 near-miss: tenderer data NOT indicated yields not_satisfied') :-
    life_cycle_costing_profile_for("basic_tenderer_missing", Profile),
    lcc_method_validity_limb_status(tenderer_data_not_indicated, Profile, not_satisfied, _Citation).
test('NC3 positive: no externality category yields satisfied (gate closed)') :-
    life_cycle_costing_profile_for("basic_compliant", Profile),
    lcc_method_validity_limb_status(externality_cost_monetary_value_not_determinable, Profile, satisfied, _Citation).
test('NC3 near-miss: externality present with determinable=0 yields not_satisfied') :-
    life_cycle_costing_profile_for("externality_not_determinable", Profile),
    lcc_method_validity_limb_status(externality_cost_monetary_value_not_determinable, Profile, not_satisfied, _Citation).
test('NC4 positive: established method with undue=True still yields satisfied') :-
    life_cycle_costing_profile_for("externality_established", Profile),
    lcc_method_validity_limb_status(undue_favour_or_disadvantage_of_economic_operators, Profile, satisfied, _Citation).
test('NC4 near-miss: not established + undue=True yields not_satisfied') :-
    life_cycle_costing_profile_for("externality_undue_favour", Profile),
    lcc_method_validity_limb_status(undue_favour_or_disadvantage_of_economic_operators, Profile, not_satisfied, _Citation).
test('NC5 positive: directive applied yields no defect') :-
    life_cycle_costing_profile_for("mandatory_applied", Profile),
    decide_lcc_mandatory_method(Profile, lcc_mandatory_method_verdict(union_common_method_mandatory_and_applied, [], [])).
test('NC5 near-miss: directive NOT applied yields defect') :-
    life_cycle_costing_profile_for("mandatory_not_applied", Profile),
    decide_lcc_mandatory_method(Profile, lcc_mandatory_method_verdict(union_common_method_mandatory_and_not_applied, [mandatory_union_common_method_not_applied], [cite(eu_dir_2014_24_art_68_3)])).
test('NC6 positive: zero amount yields lcc_computed with total 0') :-
    life_cycle_costing_profile_for("zero_amount", Profile),
    decide_lcc_computation(Profile, lcc_computation_verdict(lcc_computed, 0, [])).
test('NC6 near-miss: negative amount yields lcc_indeterminate') :-
    life_cycle_costing_profile_for("negative_amount", Profile),
    decide_lcc_computation(Profile, lcc_computation_verdict(lcc_indeterminate, 0, [])).
test('NC7 positive: externality with determinable=1 is included') :-
    lcc_component_admissibility(environmental_externality_cost, 1, component_included).
test('NC7 near-miss: externality with determinable=0 is excluded') :-
    lcc_component_admissibility(environmental_externality_cost, 0, component_excluded).
test('NC8 positive: list with externality yields assessed') :-
    lcc_externality_assessment([[environmental_externality_cost, 100, 1]], externality_costs_assessed).
test('NC8 near-miss: list without externality yields not_assessed') :-
    lcc_externality_assessment([[acquisition_cost, 100, 1]], externality_costs_not_assessed).
test('NC9 positive: two first-alinea defects reported in pinned order') :-
    life_cycle_costing_profile_for("two_first_alinea_defects", Profile),
    decide_lcc_method_validity(Profile, lcc_method_validity_verdict(invalid_lcc_method, [tenderer_data_not_indicated, costing_method_not_indicated], [cite(eu_dir_2014_24_art_68_2), cite(eu_dir_2014_24_art_68_2)])).
test('NC9 near-miss: only one first-alinea defect when costing method is indicated') :-
    life_cycle_costing_profile_for("basic_tenderer_missing", Profile),
    decide_lcc_method_validity(Profile, lcc_method_validity_verdict(invalid_lcc_method, [tenderer_data_not_indicated], [cite(eu_dir_2014_24_art_68_2)])).

cp_test_names(['NC1 positive: empty list with all flags True yields valid', 'NC1 near-miss: empty list with one flag False STILL yields valid (gate voids all)', 'NC2 positive: tenderer data indicated yields satisfied', 'NC2 near-miss: tenderer data NOT indicated yields not_satisfied', 'NC3 positive: no externality category yields satisfied (gate closed)', 'NC3 near-miss: externality present with determinable=0 yields not_satisfied', 'NC4 positive: established method with undue=True still yields satisfied', 'NC4 near-miss: not established + undue=True yields not_satisfied', 'NC5 positive: directive applied yields no defect', 'NC5 near-miss: directive NOT applied yields defect', 'NC6 positive: zero amount yields lcc_computed with total 0', 'NC6 near-miss: negative amount yields lcc_indeterminate', 'NC7 positive: externality with determinable=1 is included', 'NC7 near-miss: externality with determinable=0 is excluded', 'NC8 positive: list with externality yields assessed', 'NC8 near-miss: list without externality yields not_assessed', 'NC9 positive: two first-alinea defects reported in pinned order', 'NC9 near-miss: only one first-alinea defect when costing method is indicated']).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
