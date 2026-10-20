:- module(m__eu_procurement_life_cycle_costing_tests_test_queries, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_procurement_life_cycle_costing_queries, [life_cycle_costing_profile_keys/1, life_cycle_costing_what_if/4, life_cycle_costing_eligibility/2, life_cycle_costing_status/2, life_cycle_costing_defect_enumeration/2, life_cycle_costing_checklist/2, life_cycle_costing_calculation/2]).
:- use_module(m__eu_procurement_life_cycle_costing_fixtures, [life_cycle_costing_profile_for/2]).

test('query: profile_keys returns 12 keys') :-
    life_cycle_costing_profile_keys(ProfileKeys),
    length(ProfileKeys, 12).
test('query: eligibility returns valid for compliant profile') :-
    life_cycle_costing_profile_for("basic_compliant", Profile),
    life_cycle_costing_eligibility(Profile, lcc_method_validity_verdict(valid_lcc_method, [], [])).
test('query: eligibility returns invalid for non-compliant profile') :-
    life_cycle_costing_profile_for("basic_tenderer_missing", Profile),
    life_cycle_costing_eligibility(Profile, lcc_method_validity_verdict(invalid_lcc_method, [tenderer_data_not_indicated], [cite(eu_dir_2014_24_art_68_2)])).
test('query: status returns no_union_common_method_mandatory') :-
    life_cycle_costing_profile_for("basic_compliant", Profile),
    life_cycle_costing_status(Profile, no_union_common_method_mandatory).
test('query: status returns mandatory_and_applied for directive') :-
    life_cycle_costing_profile_for("mandatory_applied", Profile),
    life_cycle_costing_status(Profile, union_common_method_mandatory_and_applied).
test('query: defect_enumeration returns the defect for tenderer missing') :-
    life_cycle_costing_profile_for("basic_tenderer_missing", Profile),
    life_cycle_costing_defect_enumeration(Profile, [tenderer_data_not_indicated]).
test('query: defect_enumeration returns empty list for compliant profile') :-
    life_cycle_costing_profile_for("basic_compliant", Profile),
    life_cycle_costing_defect_enumeration(Profile, []).
test('query: checklist returns 9 items for basic_compliant') :-
    life_cycle_costing_profile_for("basic_compliant", Profile),
    life_cycle_costing_checklist(Profile, Checklist),
    length(Checklist, 9).
test('query: checklist items carry cite terms') :-
    life_cycle_costing_profile_for("basic_compliant", Profile),
    life_cycle_costing_checklist(Profile, Checklist),
    member(item(tenderer_data_not_indicated, satisfied, cite(eu_dir_2014_24_art_68_2)), Checklist).
test('query: calculation returns 10000 for basic_compliant') :-
    life_cycle_costing_profile_for("basic_compliant", Profile),
    life_cycle_costing_calculation(Profile, 10000).
test('query: calculation returns 15000 for externality_compliant') :-
    life_cycle_costing_profile_for("externality_compliant", Profile),
    life_cycle_costing_calculation(Profile, 15000).
test('query: what_if flipping tenderer_data yields invalid') :-
    life_cycle_costing_profile_for("basic_compliant", Profile),
    life_cycle_costing_what_if(Profile, tenderer_data_indicated_in_procurement_documents, false, lcc_method_validity_verdict(invalid_lcc_method, [tenderer_data_not_indicated], [cite(eu_dir_2014_24_art_68_2)])).
test('query: what_if keeping tenderer_data True stays valid') :-
    life_cycle_costing_profile_for("basic_compliant", Profile),
    life_cycle_costing_what_if(Profile, tenderer_data_indicated_in_procurement_documents, true, lcc_method_validity_verdict(valid_lcc_method, [], [])).

cp_test_names(['query: profile_keys returns 12 keys', 'query: eligibility returns valid for compliant profile', 'query: eligibility returns invalid for non-compliant profile', 'query: status returns no_union_common_method_mandatory', 'query: status returns mandatory_and_applied for directive', 'query: defect_enumeration returns the defect for tenderer missing', 'query: defect_enumeration returns empty list for compliant profile', 'query: checklist returns 9 items for basic_compliant', 'query: checklist items carry cite terms', 'query: calculation returns 10000 for basic_compliant', 'query: calculation returns 15000 for externality_compliant', 'query: what_if flipping tenderer_data yields invalid', 'query: what_if keeping tenderer_data True stays valid']).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
