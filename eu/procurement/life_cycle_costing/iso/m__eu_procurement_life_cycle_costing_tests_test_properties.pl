:- module(m__eu_procurement_life_cycle_costing_tests_test_properties, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_dicts, [dict_pairs/2, get/3]).
:- use_module(m__eu_procurement_life_cycle_costing_life_cycle_costing, [decide_lcc_method_validity/2, decide_lcc_mandatory_method/2, decide_lcc_computation/2, lcc_cost_category/1]).
:- use_module(m__eu_procurement_life_cycle_costing_fixtures, [life_cycle_costing_subject/1, life_cycle_costing_profile_for/2]).

method_validity_total(Subject) :-
    life_cycle_costing_subject(Subject),
    life_cycle_costing_profile_for(Subject, Profile),
    findall(Verdict, decide_lcc_method_validity(Profile, Verdict), VerdictList),
    length(VerdictList, 1).

mandatory_method_total(Subject) :-
    life_cycle_costing_subject(Subject),
    life_cycle_costing_profile_for(Subject, Profile),
    findall(Verdict, decide_lcc_mandatory_method(Profile, Verdict), VerdictList),
    length(VerdictList, 1).

computation_total(Subject) :-
    life_cycle_costing_subject(Subject),
    life_cycle_costing_profile_for(Subject, Profile),
    findall(Verdict, decide_lcc_computation(Profile, Verdict), VerdictList),
    length(VerdictList, 1).

test('P1 totality: every subject yields exactly one method-validity verdict') :-
    findall(Subject, life_cycle_costing_subject(Subject), SubjectList),
    length(SubjectList, SubjectCount),
    findall(Subject, method_validity_total(Subject), ClassifiedList),
    length(ClassifiedList, SubjectCount).
test('P1 totality: every subject yields exactly one mandatory-method verdict') :-
    findall(Subject, life_cycle_costing_subject(Subject), SubjectList),
    length(SubjectList, SubjectCount),
    findall(Subject, mandatory_method_total(Subject), ClassifiedList),
    length(ClassifiedList, SubjectCount).
test('P1 totality: every subject yields exactly one computation verdict') :-
    findall(Subject, life_cycle_costing_subject(Subject), SubjectList),
    length(SubjectList, SubjectCount),
    findall(Subject, computation_total(Subject), ClassifiedList),
    length(ClassifiedList, SubjectCount).
test('P2 determinism: method-validity verdict is deterministic') :-
    findall(Subject, life_cycle_costing_subject(Subject), SubjectList),
    length(SubjectList, SubjectCount),
    findall(Subject, determinism_check(Subject), DeterministicList),
    length(DeterministicList, SubjectCount).
test('P3 invariant: empty cost_components always yields valid_lcc_method') :-
    findall(Subject, life_cycle_costing_subject(Subject), _SubjectList),
    findall(Subject, empty_list_valid(Subject), ValidList),
    length(ValidList, 2).
test('P4 invariant: two first-alinea defects in pinned order') :-
    dict_pairs(Profile, [cost_components - [[acquisition_cost, 10000, 1]], tenderer_data_indicated_in_procurement_documents - false, costing_method_indicated_in_procurement_documents - false, externality_method_criteria_objectively_verifiable - true, externality_method_criteria_non_discriminatory - true, externality_method_established_for_repeated_or_continuous_application - true, externality_method_unduly_favours_or_disadvantages_operators - false, externality_method_accessible_to_all_interested_parties - true, externality_data_obtainable_with_reasonable_effort - true, externality_data_obtainable_by_third_country_gpa_operators - true, union_common_method_act_key - no_union_common_method, union_common_method_applied - false]),
    decide_lcc_method_validity(Profile, lcc_method_validity_verdict(invalid_lcc_method, [tenderer_data_not_indicated, costing_method_not_indicated], [cite(eu_dir_2014_24_art_68_2), cite(eu_dir_2014_24_art_68_2)])).
test('P5 DEFECT_IDS order: seven defects in pinned order') :-
    dict_pairs(Profile, [cost_components - [[acquisition_cost, 10000, 1], [environmental_externality_cost, 5000, 0]], tenderer_data_indicated_in_procurement_documents - false, costing_method_indicated_in_procurement_documents - false, externality_method_criteria_objectively_verifiable - false, externality_method_criteria_non_discriminatory - true, externality_method_established_for_repeated_or_continuous_application - true, externality_method_unduly_favours_or_disadvantages_operators - false, externality_method_accessible_to_all_interested_parties - false, externality_data_obtainable_with_reasonable_effort - false, externality_data_obtainable_by_third_country_gpa_operators - false, union_common_method_act_key - no_union_common_method, union_common_method_applied - false]),
    decide_lcc_method_validity(Profile, lcc_method_validity_verdict(invalid_lcc_method, [externality_cost_monetary_value_not_determinable, tenderer_data_not_indicated, costing_method_not_indicated, externality_method_criteria_not_objectively_verifiable, externality_method_not_accessible, externality_data_not_obtainable_with_reasonable_effort, externality_data_not_obtainable_by_gpa_operators], [cite(eu_dir_2014_24_art_68_1_b), cite(eu_dir_2014_24_art_68_2), cite(eu_dir_2014_24_art_68_2), cite(eu_dir_2014_24_art_68_2_a), cite(eu_dir_2014_24_art_68_2_b), cite(eu_dir_2014_24_art_68_2_c), cite(eu_dir_2014_24_art_68_2_c)])).
test('P6 lcc_cost_category table in pinned order') :-
    findall(Cat, lcc_cost_category(Cat), Cats),
    Cats = [acquisition_cost, use_cost, maintenance_cost, end_of_life_cost, other_cost_borne_by_authority_or_users, environmental_externality_cost].
test('P7 DEFECT_IDS order: three non-adjacent externality limbs in pinned order') :-
    dict_pairs(Profile, [cost_components - [[environmental_externality_cost, 5000, 1]], tenderer_data_indicated_in_procurement_documents - true, costing_method_indicated_in_procurement_documents - true, externality_method_criteria_objectively_verifiable - false, externality_method_criteria_non_discriminatory - true, externality_method_established_for_repeated_or_continuous_application - true, externality_method_unduly_favours_or_disadvantages_operators - false, externality_method_accessible_to_all_interested_parties - false, externality_data_obtainable_with_reasonable_effort - true, externality_data_obtainable_by_third_country_gpa_operators - false, union_common_method_act_key - no_union_common_method, union_common_method_applied - false]),
    decide_lcc_method_validity(Profile, lcc_method_validity_verdict(invalid_lcc_method, [externality_method_criteria_not_objectively_verifiable, externality_method_not_accessible, externality_data_not_obtainable_by_gpa_operators], [cite(eu_dir_2014_24_art_68_2_a), cite(eu_dir_2014_24_art_68_2_b), cite(eu_dir_2014_24_art_68_2_c)])).

determinism_check(Subject) :-
    life_cycle_costing_subject(Subject),
    life_cycle_costing_profile_for(Subject, Profile),
    findall(V1, decide_lcc_method_validity(Profile, V1), List1),
    findall(V2, decide_lcc_method_validity(Profile, V2), List2),
    List1 = List2.

empty_list_valid(Subject) :-
    life_cycle_costing_subject(Subject),
    life_cycle_costing_profile_for(Subject, Profile),
    get(Profile, cost_components, CostComponents),
    CostComponents = [],
    decide_lcc_method_validity(Profile, lcc_method_validity_verdict(valid_lcc_method, [], [])).

cp_test_names(['P1 totality: every subject yields exactly one method-validity verdict', 'P1 totality: every subject yields exactly one mandatory-method verdict', 'P1 totality: every subject yields exactly one computation verdict', 'P2 determinism: method-validity verdict is deterministic', 'P3 invariant: empty cost_components always yields valid_lcc_method', 'P4 invariant: two first-alinea defects in pinned order', 'P5 DEFECT_IDS order: seven defects in pinned order', 'P6 lcc_cost_category table in pinned order', 'P7 DEFECT_IDS order: three non-adjacent externality limbs in pinned order']).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
