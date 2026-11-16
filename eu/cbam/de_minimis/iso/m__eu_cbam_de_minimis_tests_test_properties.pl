% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_cbam_de_minimis_tests_test_properties, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_cbam_de_minimis_de_minimis, [decide_de_minimis/2, de_minimis_exemption/3, de_minimis_goods_status/3]).
:- use_module(m__eu_cbam_de_minimis_kernel, [de_minimis_input_problems/2]).
:- use_module(m__eu_cbam_de_minimis_fixtures, [de_minimis_subject/1, de_minimis_profile_for/2]).

subject_classifies(Subject) :-
    de_minimis_subject(Subject),
    de_minimis_profile_for(Subject, Profile),
    decide_de_minimis(Profile, _Verdict).

exemption_count(Subject, Count) :-
    de_minimis_profile_for(Subject, Profile),
    findall(Result - Citations, de_minimis_exemption(Profile, Result, Citations), Answers),
    length(Answers, Count).

goods_count(Subject, Count) :-
    de_minimis_profile_for(Subject, Profile),
    findall(Result - Citations, de_minimis_goods_status(Profile, Result, Citations), Answers),
    length(Answers, Count).

problems_count(Subject, Count) :-
    de_minimis_profile_for(Subject, Profile),
    findall(Problems, de_minimis_input_problems(Profile, Problems), Answers),
    length(Answers, Count).

exemption_shaped(de_minimis_exemption_applies, [_|_]).
exemption_shaped(de_minimis_exemption_does_not_apply, [_|_]).
exemption_shaped(indeterminate([MissingKey]), []) :-
    atom(MissingKey).
exemption_shaped(needs_legal_review(open_textured(year_date_basis, cite(eu_reg_2023_956_art_2a_1)), [inputs_relied_on([year_date_basis - unsure])]), []).
exemption_shaped(input_problems([_|_]), []).

goods_shaped(outside_de_minimis_exemption, [_|_]).
goods_shaped(counted_toward_threshold, [_|_]).
goods_shaped(not_goods_of_this_regulation, [_|_]).
goods_shaped(indeterminate([goods_kind]), []).
goods_shaped(input_problems([_|_]), []).

well_shaped_exemption_subject(Subject) :-
    de_minimis_subject(Subject),
    de_minimis_profile_for(Subject, Profile),
    de_minimis_exemption(Profile, Result, Citations),
    exemption_shaped(Result, Citations).

well_shaped_goods_subject(Subject) :-
    de_minimis_subject(Subject),
    de_minimis_profile_for(Subject, Profile),
    de_minimis_goods_status(Profile, Result, Citations),
    goods_shaped(Result, Citations).

test(totality_every_subject_classifies) :-
    findall(Subject, de_minimis_subject(Subject), Subjects),
    sort(Subjects, SubjectSet),
    findall(Subject, subject_classifies(Subject), ClassifiedSubjects),
    sort(ClassifiedSubjects, SubjectSet).
test(determinism_every_subject_has_exactly_one_exemption_answer) :-
    findall(Subject - Count, (de_minimis_subject(Subject), exemption_count(Subject, Count)), Counts),
    findall(Subject - 1, de_minimis_subject(Subject), Expected),
    Counts == Expected.
test(determinism_every_subject_has_exactly_one_goods_answer) :-
    findall(Subject - Count, (de_minimis_subject(Subject), goods_count(Subject, Count)), Counts),
    findall(Subject - 1, de_minimis_subject(Subject), Expected),
    Counts == Expected.
test(determinism_every_subject_has_exactly_one_problem_list) :-
    findall(Subject - Count, (de_minimis_subject(Subject), problems_count(Subject, Count)), Counts),
    findall(Subject - 1, de_minimis_subject(Subject), Expected),
    Counts == Expected.
test(every_exemption_answer_has_its_contract_shape) :-
    findall(Subject, de_minimis_subject(Subject), Subjects),
    findall(Subject, well_shaped_exemption_subject(Subject), ShapedSubjects),
    ShapedSubjects == Subjects.
test(every_goods_answer_has_its_contract_shape) :-
    findall(Subject, de_minimis_subject(Subject), Subjects),
    findall(Subject, well_shaped_goods_subject(Subject), ShapedSubjects),
    ShapedSubjects == Subjects.
test(the_exemption_cites_only_its_vocabulary) :-
    findall(Key, (de_minimis_subject(Subject), de_minimis_profile_for(Subject, Profile), de_minimis_exemption(Profile, _, Citations), member(cite(Key), Citations)), Keys),
    sort(Keys, KeySet),
    KeySet == [eu_reg_2023_956_annex_vii_1, eu_reg_2023_956_art_2a_1, eu_reg_2023_956_art_2a_2, eu_reg_2023_956_art_3_15].
test(the_goods_status_cites_only_its_vocabulary) :-
    findall(Key, (de_minimis_subject(Subject), de_minimis_profile_for(Subject, Profile), de_minimis_goods_status(Profile, _, Citations), member(cite(Key), Citations)), Keys),
    sort(Keys, KeySet),
    KeySet == [eu_reg_2023_956_annex_i_1, eu_reg_2023_956_annex_i_electricity, eu_reg_2023_956_art_2_1, eu_reg_2023_956_art_2a_1, eu_reg_2023_956_art_2a_4].
test(citation_lists_are_set_like) :-
    findall(Citations, (de_minimis_subject(Subject), de_minimis_profile_for(Subject, Profile), de_minimis_exemption(Profile, _, Citations)), CitationLists),
    findall(Citations, (member(Citations, CitationLists), sort(Citations, Sorted), length(Sorted, SortedLength), length(Citations, SortedLength)), SetLikeLists),
    SetLikeLists == CitationLists.

cp_test_names([totality_every_subject_classifies, determinism_every_subject_has_exactly_one_exemption_answer, determinism_every_subject_has_exactly_one_goods_answer, determinism_every_subject_has_exactly_one_problem_list, every_exemption_answer_has_its_contract_shape, every_goods_answer_has_its_contract_shape, the_exemption_cites_only_its_vocabulary, the_goods_status_cites_only_its_vocabulary, citation_lists_are_set_like]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
