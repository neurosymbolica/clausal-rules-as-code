% SPDX-License-Identifier: EUPL-1.2
:- module(m__ch_swiss_fadp_s2_information_duties_and_dpia_tests_test_properties, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__ch_swiss_fadp_s2_information_duties_and_dpia_swiss_fadp_s2_information_duties_and_dpia, [decide_swiss_fadp_s2_information_duties_and_dpia/2, swiss_information_duty/3, swiss_minimum_information_item/4, swiss_automated_decision_information/3, swiss_automated_decision_review/3, swiss_automated_decision_marking/3, swiss_impact_assessment/3, eu_information_duty/3, eu_automated_decision_information/3, eu_impact_assessment/3, compare_swiss_eu_information_duty/5, compare_swiss_eu_automated_decision_information/5, compare_swiss_eu_impact_assessment/5]).
:- use_module(m__ch_swiss_fadp_s2_information_duties_and_dpia_citations, [citation/2]).
:- use_module(m__ch_swiss_fadp_s2_information_duties_and_dpia_fixtures, [swiss_fadp_s2_information_duties_and_dpia_subject/1, swiss_fadp_s2_information_duties_and_dpia_profile_for/2]).

property_subject(private_controller_must_inform).
property_subject(already_informed_unsure).
property_subject(malformed_federal_body_value).
property_subject(federal_automated_decision_without_hearing).
property_subject(certified_system_may_omit_assessment).
property_subject(automated_decision_eu_already_informed).

subject_classifies(Subject) :-
    swiss_fadp_s2_information_duties_and_dpia_subject(Subject),
    swiss_fadp_s2_information_duties_and_dpia_profile_for(Subject, Profile),
    decide_swiss_fadp_s2_information_duties_and_dpia(Profile, _Verdict).

single_query(swiss_information_duty).
single_query(swiss_automated_decision_information).
single_query(swiss_automated_decision_review).
single_query(swiss_automated_decision_marking).
single_query(swiss_impact_assessment).
single_query(eu_information_duty).
single_query(eu_automated_decision_information).
single_query(eu_impact_assessment).

comparison_query(compare_swiss_eu_information_duty).
comparison_query(compare_swiss_eu_automated_decision_information).
comparison_query(compare_swiss_eu_impact_assessment).

item_atom(identity_and_contact_details_of_controller).
item_atom(processing_purpose).
item_atom(recipients_or_categories_of_recipients).
item_atom(categories_of_personal_data_processed).
item_atom(state_or_international_body).
item_atom(safeguards_or_exception_relied_on).

single_answers(swiss_information_duty, Profile, Answers) :-
    findall(Result - Citations, swiss_information_duty(Profile, Result, Citations), Answers).
single_answers(swiss_automated_decision_information, Profile, Answers) :-
    findall(Result - Citations, swiss_automated_decision_information(Profile, Result, Citations), Answers).
single_answers(swiss_automated_decision_review, Profile, Answers) :-
    findall(Result - Citations, swiss_automated_decision_review(Profile, Result, Citations), Answers).
single_answers(swiss_automated_decision_marking, Profile, Answers) :-
    findall(Result - Citations, swiss_automated_decision_marking(Profile, Result, Citations), Answers).
single_answers(swiss_impact_assessment, Profile, Answers) :-
    findall(Result - Citations, swiss_impact_assessment(Profile, Result, Citations), Answers).
single_answers(eu_information_duty, Profile, Answers) :-
    findall(Result - Citations, eu_information_duty(Profile, Result, Citations), Answers).
single_answers(eu_automated_decision_information, Profile, Answers) :-
    findall(Result - Citations, eu_automated_decision_information(Profile, Result, Citations), Answers).
single_answers(eu_impact_assessment, Profile, Answers) :-
    findall(Result - Citations, eu_impact_assessment(Profile, Result, Citations), Answers).

comparison_answers(compare_swiss_eu_information_duty, Profile, Answers) :-
    findall(answer(Swiss, Eu, Difference, ChangedBy), compare_swiss_eu_information_duty(Profile, Swiss, Eu, Difference, ChangedBy), Answers).
comparison_answers(compare_swiss_eu_automated_decision_information, Profile, Answers) :-
    findall(answer(Swiss, Eu, Difference, ChangedBy), compare_swiss_eu_automated_decision_information(Profile, Swiss, Eu, Difference, ChangedBy), Answers).
comparison_answers(compare_swiss_eu_impact_assessment, Profile, Answers) :-
    findall(answer(Swiss, Eu, Difference, ChangedBy), compare_swiss_eu_impact_assessment(Profile, Swiss, Eu, Difference, ChangedBy), Answers).

one_single_answer(Subject, Query) :-
    swiss_fadp_s2_information_duties_and_dpia_profile_for(Subject, Profile),
    single_answers(Query, Profile, Answers),
    length(Answers, 1).

one_comparison_answer(Subject, Query) :-
    swiss_fadp_s2_information_duties_and_dpia_profile_for(Subject, Profile),
    comparison_answers(Query, Profile, Answers),
    length(Answers, 1).

one_item_answer(Subject, Item) :-
    swiss_fadp_s2_information_duties_and_dpia_profile_for(Subject, Profile),
    findall(Result - Citations, swiss_minimum_information_item(Profile, Item, Result, Citations), Answers),
    length(Answers, 1).

shape_ok(Result, [_|_]) :-
    atom(Result).
shape_ok(Result, []) :-
    compound(Result).

well_shaped(Subject, Query) :-
    swiss_fadp_s2_information_duties_and_dpia_profile_for(Subject, Profile),
    single_answers(Query, Profile, [Result - Citations]),
    shape_ok(Result, Citations).

citations_recorded([]).
citations_recorded([cite(Key)|Citations]) :-
    citation(Key, _),
    citations_recorded(Citations).

citations_complete(Subject, Query) :-
    swiss_fadp_s2_information_duties_and_dpia_profile_for(Subject, Profile),
    single_answers(Query, Profile, [_ - Citations]),
    citations_recorded(Citations).

test(totality_every_subject_classifies) :-
    findall(Subject, swiss_fadp_s2_information_duties_and_dpia_subject(Subject), Subjects),
    sort(Subjects, SubjectSet),
    findall(Subject, subject_classifies(Subject), ClassifiedSubjects),
    sort(ClassifiedSubjects, SubjectSet).
test(determinism_every_single_query_answers_once_per_subject) :-
    findall(Subject - Query, (property_subject(Subject), single_query(Query)), Pairs),
    findall(Subject - Query, (property_subject(Subject), single_query(Query), one_single_answer(Subject, Query)), SinglePairs),
    Pairs == SinglePairs.
test(determinism_every_comparison_answers_once_per_subject) :-
    findall(Subject - Query, (property_subject(Subject), comparison_query(Query)), Pairs),
    findall(Subject - Query, (property_subject(Subject), comparison_query(Query), one_comparison_answer(Subject, Query)), SinglePairs),
    Pairs == SinglePairs.
test(determinism_every_item_answers_once_per_subject) :-
    findall(Subject - Item, (property_subject(Subject), item_atom(Item)), Pairs),
    findall(Subject - Item, (property_subject(Subject), item_atom(Item), one_item_answer(Subject, Item)), SinglePairs),
    Pairs == SinglePairs.
test(every_answer_has_the_contract_shape) :-
    findall(Subject - Query, (property_subject(Subject), single_query(Query)), Pairs),
    findall(Subject - Query, (property_subject(Subject), single_query(Query), well_shaped(Subject, Query)), ShapedPairs),
    Pairs == ShapedPairs.
test(every_final_citation_is_recorded) :-
    findall(Subject - Query, (property_subject(Subject), single_query(Query)), Pairs),
    findall(Subject - Query, (property_subject(Subject), single_query(Query), citations_complete(Subject, Query)), CompletePairs),
    Pairs == CompletePairs.
test(comparisons_agree_with_their_final_sides) :-
    findall(Subject - Query, (property_subject(Subject), comparison_query(Query)), Pairs),
    findall(Subject - Query, (property_subject(Subject), comparison_query(Query), consistent_comparison(Subject, Query)), ConsistentPairs),
    Pairs = [_|_],
    Pairs == ConsistentPairs.

consistent_difference(Swiss, Eu, same, []) :-
    Swiss == Eu.
consistent_difference(Swiss, Eu, differs, [_|_]) :-
    dif(Swiss, Eu).

comparison_consistent(Swiss, Eu, Difference, ChangedBy) :-
    atom(Swiss),
    atom(Eu),
    consistent_difference(Swiss, Eu, Difference, ChangedBy).
comparison_consistent(Swiss, _, _, _) :-
    compound(Swiss).
comparison_consistent(Swiss, Eu, _, _) :-
    atom(Swiss),
    compound(Eu).

consistent_comparison(Subject, Query) :-
    swiss_fadp_s2_information_duties_and_dpia_profile_for(Subject, Profile),
    comparison_answers(Query, Profile, [answer(Swiss, Eu, Difference, ChangedBy)]),
    comparison_consistent(Swiss, Eu, Difference, ChangedBy).

cp_test_names([totality_every_subject_classifies, determinism_every_single_query_answers_once_per_subject, determinism_every_comparison_answers_once_per_subject, determinism_every_item_answers_once_per_subject, every_answer_has_the_contract_shape, every_final_citation_is_recorded, comparisons_agree_with_their_final_sides]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
