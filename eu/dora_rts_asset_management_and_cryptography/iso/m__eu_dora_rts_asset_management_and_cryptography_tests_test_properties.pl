% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_rts_asset_management_and_cryptography_tests_test_properties, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_dora_rts_asset_management_and_cryptography_dora_rts_asset_management_and_cryptography, [decide_dora_rts_asset_management_and_cryptography/2, rts_asset_management_and_cryptography_duties_required/3, rts_asset_management_and_cryptography_duties_complete/3, rts_asset_management_and_cryptography_duties_outstanding/3]).
:- use_module(m__eu_dora_rts_asset_management_and_cryptography_fixtures, [dora_rts_asset_management_and_cryptography_subject/1, dora_rts_asset_management_and_cryptography_profile_for/2]).
:- use_module(m__eu_dora_rts_asset_management_and_cryptography_kernel, [dora_rts_asset_management_and_cryptography_input_problems/2]).

all_subjects(Subjects) :-
    findall(Subject, dora_rts_asset_management_and_cryptography_subject(Subject), Subjects).

subject_classifies(Subject) :-
    dora_rts_asset_management_and_cryptography_subject(Subject),
    dora_rts_asset_management_and_cryptography_profile_for(Subject, Profile),
    decide_dora_rts_asset_management_and_cryptography(Profile, _Verdict).

one_solution_each(Subject) :-
    dora_rts_asset_management_and_cryptography_profile_for(Subject, Profile),
    findall(Result - Citations, rts_asset_management_and_cryptography_duties_required(Profile, Result, Citations), [_]),
    findall(Result - Citations, rts_asset_management_and_cryptography_duties_complete(Profile, Result, Citations), [_]),
    findall(Result - Citations, rts_asset_management_and_cryptography_duties_outstanding(Profile, Result, Citations), [_]),
    findall(Problems, dora_rts_asset_management_and_cryptography_input_problems(Profile, Problems), [_]).

status_citations(indeterminate([_]), []).
status_citations(needs_legal_review(open_textured(_, cite(_)), [inputs_relied_on(_)]), []).
status_citations(input_problems([_|_]), []).
status_citations(complete, [_|_]).
status_citations(incomplete, [_|_]).
status_citations(simplified_framework_entity, [cite(eu_reg_2022_2554_art_16_1)]).

citations_fit_the_result(Subject) :-
    dora_rts_asset_management_and_cryptography_profile_for(Subject, Profile),
    rts_asset_management_and_cryptography_duties_complete(Profile, Result, Citations),
    status_citations(Result, Citations).

required_shape(required([_|_])).
required_shape(simplified_framework_entity).
required_shape(indeterminate([_])).
required_shape(input_problems([_|_])).

required_is_well_shaped(Subject) :-
    dora_rts_asset_management_and_cryptography_profile_for(Subject, Profile),
    rts_asset_management_and_cryptography_duties_required(Profile, Result, _),
    required_shape(Result).

agree(complete, none_outstanding).
agree(incomplete, outstanding([_|_])).
agree(incomplete, indeterminate([_])).
agree(simplified_framework_entity, simplified_framework_entity).
agree(indeterminate([_]), indeterminate([_])).
agree(needs_legal_review(_, _), needs_legal_review(_, _)).
agree(input_problems(Problems), input_problems(Problems)).

queries_agree(Subject) :-
    dora_rts_asset_management_and_cryptography_profile_for(Subject, Profile),
    rts_asset_management_and_cryptography_duties_complete(Profile, CompleteResult, _),
    rts_asset_management_and_cryptography_duties_outstanding(Profile, OutstandingResult, _),
    agree(CompleteResult, OutstandingResult).

allowed_citation(cite(eu_reg_2024_1774_art_4_1)).
allowed_citation(cite(eu_reg_2024_1774_art_4_2)).
allowed_citation(cite(eu_reg_2024_1774_art_5_1)).
allowed_citation(cite(eu_reg_2024_1774_art_5_2)).
allowed_citation(cite(eu_reg_2024_1774_art_6_1)).
allowed_citation(cite(eu_reg_2024_1774_art_6_2)).
allowed_citation(cite(eu_reg_2024_1774_art_6_3)).
allowed_citation(cite(eu_reg_2024_1774_art_6_4)).
allowed_citation(cite(eu_reg_2024_1774_art_6_5)).
allowed_citation(cite(eu_reg_2024_1774_art_7_1)).
allowed_citation(cite(eu_reg_2024_1774_art_7_2)).
allowed_citation(cite(eu_reg_2024_1774_art_7_3)).
allowed_citation(cite(eu_reg_2024_1774_art_7_4)).
allowed_citation(cite(eu_reg_2024_1774_art_7_5)).
allowed_citation(cite(eu_reg_2024_1774_art_4_2_a)).
allowed_citation(cite(eu_reg_2024_1774_art_4_2_b)).
allowed_citation(cite(eu_reg_2024_1774_art_4_2_c)).
allowed_citation(cite(eu_reg_2024_1774_art_6_2_a)).
allowed_citation(cite(eu_reg_2024_1774_art_6_2_b)).
allowed_citation(cite(eu_reg_2024_1774_art_6_2_c)).
allowed_citation(cite(eu_reg_2024_1774_art_6_2_d)).
allowed_citation(cite(eu_reg_2022_2554_art_16_1)).

citations_in_vocabulary(Subject) :-
    dora_rts_asset_management_and_cryptography_profile_for(Subject, Profile),
    rts_asset_management_and_cryptography_duties_required(Profile, _, RequiredCitations),
    rts_asset_management_and_cryptography_duties_complete(Profile, _, CompleteCitations),
    rts_asset_management_and_cryptography_duties_outstanding(Profile, _, OutstandingCitations),
    maplist(allowed_citation, RequiredCitations),
    maplist(allowed_citation, CompleteCitations),
    maplist(allowed_citation, OutstandingCitations),
    sort(OutstandingCitations, SortedOutstanding),
    length(OutstandingCitations, OutstandingCount),
    length(SortedOutstanding, OutstandingCount).

test(totality_every_subject_classifies) :-
    all_subjects(Subjects),
    sort(Subjects, SubjectSet),
    findall(Subject, subject_classifies(Subject), ClassifiedSubjects),
    sort(ClassifiedSubjects, SubjectSet).
test(determinism_every_query_yields_one_solution) :-
    all_subjects(Subjects),
    maplist(one_solution_each, Subjects).
test(status_compounds_cite_nothing) :-
    all_subjects(Subjects),
    maplist(citations_fit_the_result, Subjects).
test(required_is_never_an_empty_list) :-
    all_subjects(Subjects),
    maplist(required_is_well_shaped, Subjects).
test(complete_and_outstanding_agree) :-
    all_subjects(Subjects),
    maplist(queries_agree, Subjects).
test(every_citation_is_in_the_vocabulary_and_written_once) :-
    all_subjects(Subjects),
    maplist(citations_in_vocabulary, Subjects).

cp_test_names([totality_every_subject_classifies, determinism_every_query_yields_one_solution, status_compounds_cite_nothing, required_is_never_an_empty_list, complete_and_outstanding_agree, every_citation_is_in_the_vocabulary_and_written_once]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
