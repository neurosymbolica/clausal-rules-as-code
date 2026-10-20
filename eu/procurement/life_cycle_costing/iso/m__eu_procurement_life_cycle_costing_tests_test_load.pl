:- module(m__eu_procurement_life_cycle_costing_tests_test_load, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_procurement_life_cycle_costing_kernel).
:- use_module(m__eu_procurement_life_cycle_costing_citations, [citation/2, implements/1]).

test('kernel verdict atoms are pairwise distinct') :-
    dif(valid_lcc_method, invalid_lcc_method),
    dif(union_common_method_mandatory_and_applied, union_common_method_mandatory_and_not_applied),
    dif(union_common_method_mandatory_and_applied, no_union_common_method_mandatory),
    dif(union_common_method_mandatory_and_not_applied, no_union_common_method_mandatory),
    dif(lcc_computed, lcc_no_costs_declared),
    dif(lcc_computed, lcc_indeterminate),
    dif(lcc_no_costs_declared, lcc_indeterminate),
    dif(satisfied, not_satisfied).
test('lcc_method_validity_verdict builds and destructures') :-
    Verdict = lcc_method_validity_verdict(valid_lcc_method, [], []),
    Verdict = lcc_method_validity_verdict(Status, DefectIds, Citations),
    Status = valid_lcc_method,
    DefectIds = [],
    Citations = [].
test('lcc_mandatory_method_verdict builds and destructures') :-
    Verdict = lcc_mandatory_method_verdict(no_union_common_method_mandatory, [], []),
    Verdict = lcc_mandatory_method_verdict(Status, DefectIds, Citations),
    Status = no_union_common_method_mandatory,
    DefectIds = [],
    Citations = [].
test('lcc_computation_verdict builds and destructures') :-
    Verdict = lcc_computation_verdict(lcc_computed, 0, []),
    Verdict = lcc_computation_verdict(Status, TotalEurCents, ExcludedCategories),
    Status = lcc_computed,
    TotalEurCents = 0,
    ExcludedCategories = [].
test('scaffold life_cycle_costing_verdict builds and destructures') :-
    Verdict = life_cycle_costing_verdict(satisfied, []),
    Verdict = life_cycle_costing_verdict(Status, Citations),
    Status = satisfied,
    Citations = [].
test('citation record resolves for eu_dir_2014_24_art_68_1') :-
    citation(eu_dir_2014_24_art_68_1, _Metadata),
    implements(eu_dir_2014_24_art_68_1).
test('cite term builds and destructures for eu_dir_2014_24_art_68_2') :-
    C = cite(eu_dir_2014_24_art_68_2),
    C = cite(Key),
    Key = eu_dir_2014_24_art_68_2.
test('implements succeeds for eu_dir_2014_24_annex_xiii') :-
    implements(eu_dir_2014_24_annex_xiii).

cp_test_names(['kernel verdict atoms are pairwise distinct', 'lcc_method_validity_verdict builds and destructures', 'lcc_mandatory_method_verdict builds and destructures', 'lcc_computation_verdict builds and destructures', 'scaffold life_cycle_costing_verdict builds and destructures', 'citation record resolves for eu_dir_2014_24_art_68_1', 'cite term builds and destructures for eu_dir_2014_24_art_68_2', 'implements succeeds for eu_dir_2014_24_annex_xiii']).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
