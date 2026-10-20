:- module(m__eu_procurement_life_cycle_costing_tests_test_output_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_procurement_life_cycle_costing_life_cycle_costing, [decide_lcc_method_validity/2, decide_lcc_mandatory_method/2, decide_lcc_computation/2, lcc_total/2, lcc_externality_assessment/2, lcc_method_validity_limb_status/4, lcc_component_admissibility/3, lcc_mandatory_method_status/3, lcc_union_act_listing/2]).
:- use_module(m__eu_procurement_life_cycle_costing_fixtures, [life_cycle_costing_profile_for/2]).

test('output mode: compliant profile yields valid_lcc_method') :-
    life_cycle_costing_profile_for("basic_compliant", Profile),
    findall(Verdict, decide_lcc_method_validity(Profile, Verdict), VerdictList),
    VerdictList = [lcc_method_validity_verdict(valid_lcc_method, [], [])].
test('output mode: non-compliant profile yields invalid_lcc_method with defect') :-
    life_cycle_costing_profile_for("basic_tenderer_missing", Profile),
    findall(Verdict, decide_lcc_method_validity(Profile, Verdict), VerdictList),
    VerdictList = [lcc_method_validity_verdict(invalid_lcc_method, [tenderer_data_not_indicated], [cite(eu_dir_2014_24_art_68_2)])].
test('output mode: two first-alinea defects in pinned statutory order') :-
    life_cycle_costing_profile_for("two_first_alinea_defects", Profile),
    findall(Verdict, decide_lcc_method_validity(Profile, Verdict), VerdictList),
    VerdictList = [lcc_method_validity_verdict(invalid_lcc_method, [tenderer_data_not_indicated, costing_method_not_indicated], [cite(eu_dir_2014_24_art_68_2), cite(eu_dir_2014_24_art_68_2)])].
test('output mode: no union act yields no_union_common_method_mandatory') :-
    life_cycle_costing_profile_for("basic_compliant", Profile),
    findall(Verdict, decide_lcc_mandatory_method(Profile, Verdict), VerdictList),
    VerdictList = [lcc_mandatory_method_verdict(no_union_common_method_mandatory, [], [])].
test('output mode: directive applied yields mandatory_and_applied') :-
    life_cycle_costing_profile_for("mandatory_applied", Profile),
    findall(Verdict, decide_lcc_mandatory_method(Profile, Verdict), VerdictList),
    VerdictList = [lcc_mandatory_method_verdict(union_common_method_mandatory_and_applied, [], [])].
test('output mode: directive not applied yields mandatory_and_not_applied with defect') :-
    life_cycle_costing_profile_for("mandatory_not_applied", Profile),
    findall(Verdict, decide_lcc_mandatory_method(Profile, Verdict), VerdictList),
    VerdictList = [lcc_mandatory_method_verdict(union_common_method_mandatory_and_not_applied, [mandatory_union_common_method_not_applied], [cite(eu_dir_2014_24_art_68_3)])].
test('output mode: empty components yields lcc_no_costs_declared') :-
    life_cycle_costing_profile_for("no_lcc_approach", Profile),
    findall(Verdict, decide_lcc_computation(Profile, Verdict), VerdictList),
    VerdictList = [lcc_computation_verdict(lcc_no_costs_declared, 0, [])].
test('output mode: positive amount yields lcc_computed with correct total') :-
    life_cycle_costing_profile_for("basic_compliant", Profile),
    findall(Verdict, decide_lcc_computation(Profile, Verdict), VerdictList),
    VerdictList = [lcc_computation_verdict(lcc_computed, 10000, [])].
test('output mode: negative amount yields lcc_indeterminate') :-
    life_cycle_costing_profile_for("negative_amount", Profile),
    findall(Verdict, decide_lcc_computation(Profile, Verdict), VerdictList),
    VerdictList = [lcc_computation_verdict(lcc_indeterminate, 0, [])].
test('output mode: lcc_total yields one solution for valid list') :-
    findall(Total, lcc_total([[acquisition_cost, 10000, 1]], Total), TotalList),
    TotalList = [10000].
test('output mode: lcc_total yields zero solutions for negative amount') :-
    findall(Total, lcc_total([[acquisition_cost, -100, 1]], Total), TotalList),
    TotalList = [].
test('output mode: externality_assessment yields one solution for empty list') :-
    findall(Assessment, lcc_externality_assessment([], Assessment), AssessmentList),
    AssessmentList = [externality_costs_not_assessed].
test('output mode: externality_assessment yields one solution for externality present') :-
    findall(Assessment, lcc_externality_assessment([[environmental_externality_cost, 5000, 1]], Assessment), AssessmentList),
    AssessmentList = [externality_costs_assessed].
test('output mode: limb_status yields satisfied with citation for compliant limb') :-
    life_cycle_costing_profile_for("basic_compliant", Profile),
    findall(_Result, lcc_method_validity_limb_status(tenderer_data_not_indicated, Profile, _Status, _Citation), ResultList),
    length(ResultList, 1).
test('output mode: component_admissibility yields one solution') :-
    findall(Status, lcc_component_admissibility(acquisition_cost, 1, Status), StatusList),
    StatusList = [component_included].
test('output mode: mandatory_method_status yields one solution') :-
    findall(Status, lcc_mandatory_method_status(no_union_common_method, 0, Status), StatusList),
    StatusList = [no_union_common_method_mandatory].
test('output mode: union_act_listing yields one solution for no_union') :-
    findall(Listing, lcc_union_act_listing(no_union_common_method, Listing), ListingList),
    ListingList = [no_union_act].

cp_test_names(['output mode: compliant profile yields valid_lcc_method', 'output mode: non-compliant profile yields invalid_lcc_method with defect', 'output mode: two first-alinea defects in pinned statutory order', 'output mode: no union act yields no_union_common_method_mandatory', 'output mode: directive applied yields mandatory_and_applied', 'output mode: directive not applied yields mandatory_and_not_applied with defect', 'output mode: empty components yields lcc_no_costs_declared', 'output mode: positive amount yields lcc_computed with correct total', 'output mode: negative amount yields lcc_indeterminate', 'output mode: lcc_total yields one solution for valid list', 'output mode: lcc_total yields zero solutions for negative amount', 'output mode: externality_assessment yields one solution for empty list', 'output mode: externality_assessment yields one solution for externality present', 'output mode: limb_status yields satisfied with citation for compliant limb', 'output mode: component_admissibility yields one solution', 'output mode: mandatory_method_status yields one solution', 'output mode: union_act_listing yields one solution for no_union']).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
