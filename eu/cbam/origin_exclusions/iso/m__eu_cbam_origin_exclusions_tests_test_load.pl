% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_cbam_origin_exclusions_tests_test_load, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_cbam_origin_exclusions_kernel, [origin_exclusions_input_problems/2]).
:- use_module(m__eu_cbam_origin_exclusions_citations, [citation/2, implements/1]).

test(the_result_atoms_are_pairwise_distinct) :-
    Results = [excluded_military_activities, excluded_origin_annex_iii_point_1, excluded_electricity_continental_shelf_or_eez, excluded_hydrogen_continental_shelf_or_eez, not_third_country_origin, no_origin_exclusion],
    sort(Results, Sorted),
    length(Results, ResultCount),
    length(Sorted, SortedCount),
    ResultCount == SortedCount,
    ResultCount == 6.
test(military_and_annex_exclusions_are_distinct) :-
    dif(excluded_military_activities, excluded_origin_annex_iii_point_1).
test(electricity_and_hydrogen_exclusions_are_distinct) :-
    dif(excluded_electricity_continental_shelf_or_eez, excluded_hydrogen_continental_shelf_or_eez).
test(no_exclusion_is_not_third_country_origin) :-
    dif(no_origin_exclusion, not_third_country_origin).
test(the_problem_constructors_are_distinct) :-
    dif(unknown_key(goods_kind), wrong_type(goods_kind)),
    dif(wrong_type(goods_kind), duplicate_key(goods_kind)),
    dif(unknown_key(goods_kind), duplicate_key(goods_kind)).
test(the_verdict_term_carries_status_and_citations) :-
    Verdict = origin_exclusions_verdict(excluded_military_activities, [cite(eu_reg_2023_956_art_2_3)]),
    Verdict = origin_exclusions_verdict(Status, Citations),
    Status == excluded_military_activities,
    Citations == [cite(eu_reg_2023_956_art_2_3)].
test(the_indeterminate_status_holds_one_bare_key) :-
    Result = indeterminate([military_activities]),
    Result = indeterminate(MissingKeys),
    MissingKeys == [military_activities],
    functor(Result, Name, Arity),
    Name == indeterminate,
    Arity == 1.
test(the_input_problems_status_holds_the_flat_list) :-
    Result = input_problems([wrong_type(goods_kind), unknown_key(colour)]),
    Result = input_problems(Problems),
    Problems == [wrong_type(goods_kind), unknown_key(colour)].
test(the_military_activities_citation_is_recorded) :-
    citation(eu_reg_2023_956_art_2_3, _Record).
test(the_annex_iii_point_1_citation_is_recorded) :-
    citation(eu_reg_2023_956_annex_3_1, _Record).
test(every_vocabulary_citation_is_recorded) :-
    Keys = [eu_reg_2023_956_art_2_1, eu_reg_2023_956_art_2_3, eu_reg_2023_956_art_2_3a, eu_reg_2023_956_art_2_3a_a, eu_reg_2023_956_art_2_3a_b, eu_reg_2023_956_art_2_4, eu_reg_2023_956_art_2_5, eu_reg_2023_956_art_3_7, eu_reg_2023_956_art_3_8, eu_reg_2023_956_art_3_9, eu_reg_2023_956_annex_3_1],
    maplist(implements, Keys).
test(a_citation_record_has_label_ref_verbatim) :-
    citation(eu_reg_2023_956_art_2_4, Record),
    Record = [label - _, ref - _, verbatim - _].
test(the_marker_holds_for_a_recorded_key) :-
    implements(eu_reg_2023_956_art_2_5).
test(an_empty_profile_has_no_problem) :-
    findall(Problems, origin_exclusions_input_problems([], Problems), Answers),
    Answers == [[]].
test(a_full_good_profile_has_no_problem) :-
    Profile = [attribute(military_activities, no), attribute(non_preferential_origin, norway), attribute(goods_kind, hydrogen), attribute(continental_shelf_or_eez_of, norway)],
    findall(Problems, origin_exclusions_input_problems(Profile, Problems), Answers),
    Answers == [[]].
test(a_value_outside_its_type_is_wrong_type) :-
    findall(Problems, origin_exclusions_input_problems([attribute(goods_kind, coal)], Problems), Answers),
    Answers == [[wrong_type(goods_kind)]].
test(contract_problems_come_before_unknown_keys) :-
    Profile = [attribute(colour, red), attribute(goods_kind, coal)],
    findall(Problems, origin_exclusions_input_problems(Profile, Problems), Answers),
    Answers == [[wrong_type(goods_kind), unknown_key(colour)]].
test(a_repeated_key_is_duplicate_key_only) :-
    Profile = [attribute(goods_kind, coal), attribute(goods_kind, electricity)],
    findall(Problems, origin_exclusions_input_problems(Profile, Problems), Answers),
    Answers == [[duplicate_key(goods_kind)]].
test(a_repeated_unknown_key_is_named_once) :-
    Profile = [attribute(colour, red), attribute(colour, blue)],
    findall(Problems, origin_exclusions_input_problems(Profile, Problems), Answers),
    Answers == [[unknown_key(colour)]].
test(a_term_that_is_not_a_list_is_wrong_type_profile) :-
    findall(Problems, origin_exclusions_input_problems(norway, Problems), Answers),
    Answers == [[wrong_type(profile)]].
test(an_unbound_profile_is_wrong_type_profile) :-
    findall(Problems, origin_exclusions_input_problems(_Profile, Problems), Answers),
    Answers == [[wrong_type(profile)]].
test(a_list_with_a_stray_element_is_wrong_type_profile) :-
    Profile = [attribute(goods_kind, electricity), goods_kind],
    findall(Problems, origin_exclusions_input_problems(Profile, Problems), Answers),
    Answers == [[wrong_type(profile)]].
test(an_unbound_value_is_wrong_type) :-
    findall(Problems, origin_exclusions_input_problems([attribute(military_activities, _Value)], Problems), Answers),
    Answers == [[wrong_type(military_activities)]].
test(unsure_is_in_the_type_of_military_activities) :-
    findall(Problems, origin_exclusions_input_problems([attribute(military_activities, unsure)], Problems), Answers),
    Answers == [[]].

test(the_indeterminate_status_is_not_the_bare_atom, fail) :-
    indeterminate([military_activities]) = indeterminate.
test(the_marker_fails_for_an_unrecorded_key, fail) :-
    implements(eu_reg_2023_956_art_2_5_typo).
test(a_good_value_is_not_wrong_type, fail) :-
    origin_exclusions_input_problems([attribute(goods_kind, electricity)], [wrong_type(goods_kind)]).

cp_test_names([the_result_atoms_are_pairwise_distinct, military_and_annex_exclusions_are_distinct, electricity_and_hydrogen_exclusions_are_distinct, no_exclusion_is_not_third_country_origin, the_problem_constructors_are_distinct, the_verdict_term_carries_status_and_citations, the_indeterminate_status_holds_one_bare_key, the_input_problems_status_holds_the_flat_list, the_military_activities_citation_is_recorded, the_annex_iii_point_1_citation_is_recorded, every_vocabulary_citation_is_recorded, a_citation_record_has_label_ref_verbatim, the_marker_holds_for_a_recorded_key, an_empty_profile_has_no_problem, a_full_good_profile_has_no_problem, a_value_outside_its_type_is_wrong_type, contract_problems_come_before_unknown_keys, a_repeated_key_is_duplicate_key_only, a_repeated_unknown_key_is_named_once, a_term_that_is_not_a_list_is_wrong_type_profile, an_unbound_profile_is_wrong_type_profile, a_list_with_a_stray_element_is_wrong_type_profile, an_unbound_value_is_wrong_type, unsure_is_in_the_type_of_military_activities]).
cp_test_fail_names([the_indeterminate_status_is_not_the_bare_atom, the_marker_fails_for_an_unrecorded_key, a_good_value_is_not_wrong_type]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
