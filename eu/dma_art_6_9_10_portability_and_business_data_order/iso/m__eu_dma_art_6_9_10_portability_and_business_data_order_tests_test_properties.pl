% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dma_art_6_9_10_portability_and_business_data_order_tests_test_properties, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(library(pairs), [pairs_keys/2]).
:- use_module(m__eu_dma_art_6_9_10_portability_and_business_data_order_dma_art_6_9_10_portability_and_business_data_order, [article_6_application_status/4, end_user_data_portability_status/4, business_user_data_access_status/4, decide_dma_art_6_9_10_portability_and_business_data_order/2, dma_art_6_9_10_portability_and_business_data_order_checklist/2, dma_art_6_9_10_portability_and_business_data_order_status_values/1]).
:- use_module(m__eu_dma_art_6_9_10_portability_and_business_data_order_fixtures, [dma_art_6_9_10_portability_and_business_data_order_subject/1, dma_art_6_9_10_portability_and_business_data_order_profile_for/2]).

subject_classifies(Subject) :-
    dma_art_6_9_10_portability_and_business_data_order_subject(Subject),
    dma_art_6_9_10_portability_and_business_data_order_profile_for(Subject, Profile),
    decide_dma_art_6_9_10_portability_and_business_data_order(Profile, _Verdict).

all_subjects(Subjects) :-
    findall(Subject, dma_art_6_9_10_portability_and_business_data_order_subject(Subject), Subjects).

one_answer_per_query(Subject) :-
    dma_art_6_9_10_portability_and_business_data_order_profile_for(Subject, Profile),
    findall(ApplicationResult, article_6_application_status(Profile, ApplicationResult, _, _), ApplicationResults),
    length(ApplicationResults, 1),
    findall(PortabilityResult, end_user_data_portability_status(Profile, PortabilityResult, _, _), PortabilityResults),
    length(PortabilityResults, 1),
    findall(BusinessResult, business_user_data_access_status(Profile, BusinessResult, _, _), BusinessResults),
    length(BusinessResults, 1).

query_answer(Profile, Result, Basis, Citations) :-
    article_6_application_status(Profile, Result, Basis, Citations).
query_answer(Profile, Result, Basis, Citations) :-
    end_user_data_portability_status(Profile, Result, Basis, Citations).
query_answer(Profile, Result, Basis, Citations) :-
    business_user_data_access_status(Profile, Result, Basis, Citations).

all_answers(Answers) :-
    findall(Result - Basis - Citations, (dma_art_6_9_10_portability_and_business_data_order_subject(Subject), dma_art_6_9_10_portability_and_business_data_order_profile_for(Subject, Profile), query_answer(Profile, Result, Basis, Citations)), Answers).

answer_shape(Result - [_|_] - [_|_]) :-
    atom(Result),
    dma_art_6_9_10_portability_and_business_data_order_status_values(StatusValues),
    member(Result, StatusValues).
answer_shape(Result - [] - []) :-
    compound(Result).

basis_keys([], []).
basis_keys([outside_fact(FactKey, _)|Facts], [FactKey|FactKeys]) :-
    basis_keys(Facts, FactKeys).

vocabulary_citation(cite(eu_reg_2022_1925_art_6_1)).
vocabulary_citation(cite(eu_reg_2022_1925_art_6_9)).
vocabulary_citation(cite(eu_reg_2022_1925_art_6_10)).
vocabulary_citation(cite(eu_reg_2022_1925_art_2_25)).
vocabulary_citation(cite(eu_reg_2022_1925_art_2_32)).

cited_item(item(_, _, [cite(_)|_])).

keys_unique(Pairs) :-
    sort(Pairs, UniquePairs),
    pairs_keys(UniquePairs, Keys),
    sort(Keys, KeySet),
    length(Keys, KeyCount),
    length(KeySet, KeyCount).

test(totality_every_subject_classifies) :-
    all_subjects(Subjects),
    sort(Subjects, SubjectSet),
    findall(Subject, subject_classifies(Subject), ClassifiedSubjects),
    sort(ClassifiedSubjects, SubjectSet).
test(determinism_every_subject_one_answer_per_query) :-
    all_subjects(Subjects),
    maplist(one_answer_per_query, Subjects).
test(determinism_one_verdict_per_subject) :-
    all_subjects(Subjects),
    findall(Subject - Verdict, (member(Subject, Subjects), dma_art_6_9_10_portability_and_business_data_order_profile_for(Subject, Profile), decide_dma_art_6_9_10_portability_and_business_data_order(Profile, Verdict)), Verdicts),
    length(Subjects, SubjectCount),
    length(Verdicts, SubjectCount).
test(every_answer_has_its_shape) :-
    all_answers(Answers),
    maplist(answer_shape, Answers).
test(one_citation_list_per_final_result) :-
    all_answers(Answers),
    findall(Result - SortedCitations, (member(Result - [_|_] - Citations, Answers), sort(Citations, SortedCitations)), Pairs),
    keys_unique(Pairs).
test(one_basis_per_final_result) :-
    all_answers(Answers),
    findall(Result - FactKeys, (member(Result - [Fact|Facts] - _, Answers), basis_keys([Fact|Facts], FactKeys)), Pairs),
    keys_unique(Pairs).
test(every_citation_is_vocabulary) :-
    all_answers(Answers),
    findall(Citation, (member(_ - _ - Citations, Answers), member(Citation, Citations)), AllCitations),
    maplist(vocabulary_citation, AllCitations).
test(every_checklist_row_is_cited) :-
    findall(Items, (dma_art_6_9_10_portability_and_business_data_order_subject(Subject), dma_art_6_9_10_portability_and_business_data_order_profile_for(Subject, Profile), dma_art_6_9_10_portability_and_business_data_order_checklist(Profile, Items)), AllItems),
    append(AllItems, FlatItems),
    FlatItems = [_|_],
    maplist(cited_item, FlatItems).

cp_test_names([totality_every_subject_classifies, determinism_every_subject_one_answer_per_query, determinism_one_verdict_per_subject, every_answer_has_its_shape, one_citation_list_per_final_result, one_basis_per_final_result, every_citation_is_vocabulary, every_checklist_row_is_cited]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
