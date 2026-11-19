% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_cbam_origin_exclusions_tests_test_properties, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_lists_extra, [clausal_msort/2]).
:- use_module(m__eu_cbam_origin_exclusions_origin_exclusions, [origin_exclusion/3, origin_exclusions_status_values/1]).
:- use_module(m__eu_cbam_origin_exclusions_queries, [origin_exclusions_profile_keys/1, origin_exclusions_eligibility/2]).
:- use_module(m__eu_cbam_origin_exclusions_kernel, [origin_exclusions_input_problems/2]).
:- use_module(m__eu_cbam_origin_exclusions_fixtures, [origin_exclusions_subject/1, origin_exclusions_profile_for/2]).

citation_vocabulary_keys([eu_reg_2023_956_art_2_1, eu_reg_2023_956_art_2_3, eu_reg_2023_956_art_2_3a, eu_reg_2023_956_art_2_3a_a, eu_reg_2023_956_art_2_3a_b, eu_reg_2023_956_art_2_4, eu_reg_2023_956_art_2_5, eu_reg_2023_956_art_3_7, eu_reg_2023_956_art_3_8, eu_reg_2023_956_art_3_9, eu_reg_2023_956_annex_3_1]).

all_subjects(Subjects) :-
    findall(Subject, origin_exclusions_subject(Subject), Subjects).

subject_answers(Subject, Answers) :-
    origin_exclusions_profile_for(Subject, Profile),
    findall(Result - Citations, origin_exclusion(Profile, Result, Citations), Answers).

exactly_one_answer(Subject) :-
    subject_answers(Subject, Answers),
    length(Answers, 1).

exactly_one_eligibility(Subject) :-
    origin_exclusions_profile_for(Subject, Profile),
    findall(Eligibility, origin_exclusions_eligibility(Profile, Eligibility), Eligibilities),
    length(Eligibilities, 1).

exactly_one_problem_list(Subject) :-
    origin_exclusions_profile_for(Subject, Profile),
    findall(Problems, origin_exclusions_input_problems(Profile, Problems), ProblemLists),
    length(ProblemLists, 1).

vocabulary_citation(cite(CitationKey)) :-
    citation_vocabulary_keys(VocabularyKeys),
    member(CitationKey, VocabularyKeys).

result_shape(Result, Citations) :-
    atom(Result),
    origin_exclusions_status_values(StatusValues),
    member(Result, StatusValues),
    Citations = [_|_],
    maplist(vocabulary_citation, Citations),
    sort(Citations, DistinctCitations),
    length(DistinctCitations, CitationCount),
    length(Citations, CitationCount).
result_shape(indeterminate([MissingKey]), []) :-
    origin_exclusions_profile_keys(ProfileKeys),
    member(MissingKey, ProfileKeys).
result_shape(input_problems([_|_]), []).

answer_well_formed(Subject) :-
    subject_answers(Subject, [Result - Citations]),
    result_shape(Result, Citations).

test(the_subject_set_is_not_empty) :-
    all_subjects([_|_]).
test(totality_and_determinism_every_subject_has_exactly_one_answer) :-
    all_subjects(Subjects),
    maplist(exactly_one_answer, Subjects).
test(every_subject_has_exactly_one_eligibility) :-
    all_subjects(Subjects),
    maplist(exactly_one_eligibility, Subjects).
test(the_input_check_has_exactly_one_answer_for_every_subject) :-
    all_subjects(Subjects),
    maplist(exactly_one_problem_list, Subjects).
test(every_answer_has_the_contract_shape) :-
    all_subjects(Subjects),
    maplist(answer_well_formed, Subjects).
test(the_status_table_holds_the_six_result_atoms) :-
    origin_exclusions_status_values(StatusValues),
    clausal_msort(StatusValues, SortedValues),
    SortedValues == [excluded_electricity_continental_shelf_or_eez, excluded_hydrogen_continental_shelf_or_eez, excluded_military_activities, excluded_origin_annex_iii_point_1, no_origin_exclusion, not_third_country_origin].

test(the_shape_check_rejects_a_bare_indeterminate, fail) :-
    result_shape(indeterminate, []).
test(the_shape_check_rejects_an_invented_citation, fail) :-
    result_shape(excluded_military_activities, [cite(art_2_3)]).

cp_test_names([the_subject_set_is_not_empty, totality_and_determinism_every_subject_has_exactly_one_answer, every_subject_has_exactly_one_eligibility, the_input_check_has_exactly_one_answer_for_every_subject, every_answer_has_the_contract_shape, the_status_table_holds_the_six_result_atoms]).
cp_test_fail_names([the_shape_check_rejects_a_bare_indeterminate, the_shape_check_rejects_an_invented_citation]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
