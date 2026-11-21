% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_nis2_scope_entity_class_tests_test_properties, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_nis2_scope_entity_class_nis2_scope_entity_class, [size_class/3, scope_decision/3, entity_class/3, decide_nis2_scope_entity_class/2]).
:- use_module(m__eu_nis2_scope_entity_class_fixtures, [nis2_scope_entity_class_subject/1, nis2_scope_entity_class_profile_for/2]).

all_subjects(Subjects) :-
    findall(Subject, nis2_scope_entity_class_subject(Subject), Subjects).

subject_answers_once(Subject) :-
    nis2_scope_entity_class_profile_for(Subject, Profile),
    findall(Size - SizeCitations, size_class(Profile, Size, SizeCitations), SizeAnswers),
    length(SizeAnswers, 1),
    findall(Result - ScopeCitations, scope_decision(Profile, Result, ScopeCitations), ScopeAnswers),
    length(ScopeAnswers, 1),
    findall(Class - ClassCitations, entity_class(Profile, Class, ClassCitations), ClassAnswers),
    length(ClassAnswers, 1),
    findall(Verdict, decide_nis2_scope_entity_class(Profile, Verdict), Verdicts),
    length(Verdicts, 1).

subject_answers_well_shaped(Subject) :-
    nis2_scope_entity_class_profile_for(Subject, Profile),
    size_class(Profile, Size, SizeCitations),
    answer_shape(Size, SizeCitations),
    scope_decision(Profile, Result, ScopeCitations),
    answer_shape(Result, ScopeCitations),
    entity_class(Profile, Class, ClassCitations),
    answer_shape(Class, ClassCitations).

answer_shape(Answer, Citations) :-
    answer_kind(Answer, Kind),
    citations_of_kind(Kind, Citations).

answer_kind(microenterprise, final).
answer_kind(small_enterprise, final).
answer_kind(medium_sized_enterprise, final).
answer_kind(large_enterprise, final).
answer_kind(in_scope, final).
answer_kind(out_of_scope, final).
answer_kind(essential_entity, final).
answer_kind(important_entity, final).
answer_kind(indeterminate([Key]), status) :-
    atom(Key).
answer_kind(needs_legal_review(open_textured(Key, cite(Citation)), [inputs_relied_on(Pairs)|_]), status) :-
    atom(Key),
    atom(Citation),
    maplist(key_value_pair, Pairs).
answer_kind(input_problems([_|_]), status).

key_value_pair(Key - Value) :-
    atom(Key),
    atom(Value).

citations_of_kind(final, Citations) :-
    Citations = [_|_],
    maplist(cite_term, Citations),
    sort(Citations, Unique),
    same_length(Citations, Unique).
citations_of_kind(status, []).

cite_term(cite(Key)) :-
    atom(Key).

subject_scope_and_class_agree(Subject) :-
    nis2_scope_entity_class_profile_for(Subject, Profile),
    scope_decision(Profile, Result, _),
    entity_class(Profile, Class, _),
    scope_class_agree(Result, Class).

scope_class_agree(in_scope, essential_entity).
scope_class_agree(in_scope, important_entity).
scope_class_agree(in_scope, indeterminate(_)).
scope_class_agree(in_scope, needs_legal_review(_, _)).
scope_class_agree(out_of_scope, out_of_scope).
scope_class_agree(indeterminate(_), _).
scope_class_agree(needs_legal_review(_, _), _).
scope_class_agree(input_problems(Problems), input_problems(Problems)).

size_at_headcount(Headcount, Size) :-
    size_class([attribute(staff_headcount, Headcount), attribute(annual_turnover_eur, 1000000), attribute(annual_balance_sheet_total_eur, 1000000)], Size, _).

test(totality_and_determinism_every_subject_answers_each_query_once) :-
    all_subjects(Subjects),
    Subjects = [_|_],
    maplist(subject_answers_once, Subjects).
test(every_answer_has_the_result_form) :-
    all_subjects(Subjects),
    maplist(subject_answers_well_shaped, Subjects).
test(the_class_agrees_with_the_scope) :-
    all_subjects(Subjects),
    maplist(subject_scope_and_class_agree, Subjects).
test(the_size_category_rises_with_the_headcount) :-
    maplist(size_at_headcount, [5, 30, 100, 300], Sizes),
    Sizes == [microenterprise, small_enterprise, medium_sized_enterprise, large_enterprise].
test(an_empty_profile_answers_once_per_query) :-
    findall(Size, size_class([], Size, _), Sizes),
    length(Sizes, 1),
    findall(Result, scope_decision([], Result, _), Results),
    length(Results, 1),
    findall(Class, entity_class([], Class, _), Classes),
    length(Classes, 1).

cp_test_names([totality_and_determinism_every_subject_answers_each_query_once, every_answer_has_the_result_form, the_class_agrees_with_the_scope, the_size_category_rises_with_the_headcount, an_empty_profile_answers_once_per_query]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
