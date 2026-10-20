:- module(m__eu_procurement_life_cycle_costing_tests_test_input_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_procurement_life_cycle_costing_life_cycle_costing, [lcc_component_admissibility/3, lcc_mandatory_method_status/3, lcc_union_act_listing/2, lcc_externality_assessment/2, lcc_method_validity_limb_status/4]).
:- use_module(m__eu_procurement_life_cycle_costing_fixtures, [life_cycle_costing_profile_for/2]).
:- use_module(formalize_lib, [not_member/2]).

component_admissibility_never(CostCategory, Determinable, Status) :-
    findall(Found, lcc_component_admissibility(CostCategory, Determinable, Found), FoundStatuses),
    not_member(Status, FoundStatuses).

limb_status_never(LimbId, Profile, Status) :-
    findall(Found, lcc_method_validity_limb_status(LimbId, Profile, Found, _Citation), FoundStatuses),
    not_member(Status, FoundStatuses).

test('input mode: component_admissibility bound to included succeeds for acquisition_cost') :-
    lcc_component_admissibility(acquisition_cost, 1, component_included).
test('input mode: component_admissibility bound to excluded fails for acquisition_cost') :-
    component_admissibility_never(acquisition_cost, 1, component_excluded).
test('input mode: component_admissibility bound to excluded succeeds for externality with 0') :-
    lcc_component_admissibility(environmental_externality_cost, 0, component_excluded).
test('input mode: mandatory_method_status bound to no_union succeeds') :-
    lcc_mandatory_method_status(no_union_common_method, 0, no_union_common_method_mandatory).
test('input mode: mandatory_method_status bound to applied succeeds for directive') :-
    lcc_mandatory_method_status(directive_2009_33_ec, 1, union_common_method_mandatory_and_applied).
test('input mode: union_act_listing bound to no_union_act succeeds') :-
    lcc_union_act_listing(no_union_common_method, no_union_act).
test('input mode: union_act_listing bound to listed succeeds for directive') :-
    lcc_union_act_listing(directive_2009_33_ec, listed_in_annex_xiii).
test('input mode: externality_assessment bound to not_assessed succeeds for empty list') :-
    lcc_externality_assessment([], externality_costs_not_assessed).
test('input mode: externality_assessment bound to assessed succeeds for externality present') :-
    lcc_externality_assessment([[environmental_externality_cost, 100, 1]], externality_costs_assessed).
test('input mode: limb_status bound to satisfied succeeds for compliant profile') :-
    life_cycle_costing_profile_for("basic_compliant", Profile),
    lcc_method_validity_limb_status(tenderer_data_not_indicated, Profile, satisfied, _Citation).
test('input mode: limb_status bound to not_satisfied fails for compliant profile') :-
    life_cycle_costing_profile_for("basic_compliant", Profile),
    limb_status_never(tenderer_data_not_indicated, Profile, not_satisfied).

cp_test_names(['input mode: component_admissibility bound to included succeeds for acquisition_cost', 'input mode: component_admissibility bound to excluded fails for acquisition_cost', 'input mode: component_admissibility bound to excluded succeeds for externality with 0', 'input mode: mandatory_method_status bound to no_union succeeds', 'input mode: mandatory_method_status bound to applied succeeds for directive', 'input mode: union_act_listing bound to no_union_act succeeds', 'input mode: union_act_listing bound to listed succeeds for directive', 'input mode: externality_assessment bound to not_assessed succeeds for empty list', 'input mode: externality_assessment bound to assessed succeeds for externality present', 'input mode: limb_status bound to satisfied succeeds for compliant profile', 'input mode: limb_status bound to not_satisfied fails for compliant profile']).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
