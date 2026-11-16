% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_nis2_scope_entity_class_tests_test_properties, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_nis2_scope_entity_class_nis2_scope_entity_class, [decide_nis2_scope_entity_class/2, size_class/3, scope_decision/3, entity_class/3]).
:- use_module(m__eu_nis2_scope_entity_class_fixtures, [nis2_scope_entity_class_subject/1, nis2_scope_entity_class_profile_for/2]).

subject_classifies(Subject) :-
    nis2_scope_entity_class_subject(Subject),
    nis2_scope_entity_class_profile_for(Subject, Profile),
    decide_nis2_scope_entity_class(Profile, _Verdict).

exactly_one_answer(Subject) :-
    nis2_scope_entity_class_profile_for(Subject, Profile),
    findall(Size, size_class(Profile, Size, _), Sizes),
    length(Sizes, 1),
    findall(Result, scope_decision(Profile, Result, _), Results),
    length(Results, 1),
    findall(Class, entity_class(Profile, Class, _), Classes),
    length(Classes, 1),
    findall(Verdict, decide_nis2_scope_entity_class(Profile, Verdict), Verdicts),
    length(Verdicts, 1).

profile_count(Subject) :-
    findall(Profile, nis2_scope_entity_class_profile_for(Subject, Profile), Profiles),
    length(Profiles, 1).

class_agrees(in_scope, essential_entity).
class_agrees(in_scope, important_entity).
class_agrees(in_scope, indeterminate(_)).
class_agrees(in_scope, needs_legal_review(_, _)).
class_agrees(out_of_scope, out_of_scope).
class_agrees(indeterminate(Keys), indeterminate(Keys)).
class_agrees(needs_legal_review(Reason, Context), needs_legal_review(Reason, Context)).
class_agrees(input_problems(Problems), input_problems(Problems)).

scope_class_agree(Subject) :-
    nis2_scope_entity_class_profile_for(Subject, Profile),
    scope_decision(Profile, ScopeResult, _),
    entity_class(Profile, Class, _),
    class_agrees(ScopeResult, Class).

resolved_has_citation(Subject) :-
    nis2_scope_entity_class_profile_for(Subject, Profile),
    scope_decision(Profile, Result, Citations),
    resolved_citation(Result, Citations).

resolved_citation(in_scope, [cite(_)|_]).
resolved_citation(out_of_scope, [cite(_)|_]).
resolved_citation(indeterminate(_), []).
resolved_citation(needs_legal_review(_, _), []).
resolved_citation(input_problems(_), []).

test(totality_every_subject_classifies) :-
    findall(Subject, nis2_scope_entity_class_subject(Subject), Subjects),
    sort(Subjects, SubjectSet),
    findall(Subject, subject_classifies(Subject), ClassifiedSubjects),
    sort(ClassifiedSubjects, SubjectSet).
test(determinism_every_subject_has_one_profile) :-
    findall(Subject, nis2_scope_entity_class_subject(Subject), Subjects),
    findall(Subject, (nis2_scope_entity_class_subject(Subject), profile_count(Subject)), Counted),
    Counted == Subjects.
test(determinism_every_query_has_exactly_one_solution) :-
    findall(Subject, nis2_scope_entity_class_subject(Subject), Subjects),
    findall(Subject, (nis2_scope_entity_class_subject(Subject), exactly_one_answer(Subject)), Good),
    Good == Subjects.
test(invariant_scope_and_class_agree) :-
    findall(Subject, nis2_scope_entity_class_subject(Subject), Subjects),
    findall(Subject, (nis2_scope_entity_class_subject(Subject), scope_class_agree(Subject)), Good),
    Good == Subjects.
test(invariant_resolved_scope_answers_carry_citations) :-
    findall(Subject, nis2_scope_entity_class_subject(Subject), Subjects),
    findall(Subject, (nis2_scope_entity_class_subject(Subject), resolved_has_citation(Subject)), Good),
    Good == Subjects.

cp_test_names([totality_every_subject_classifies, determinism_every_subject_has_one_profile, determinism_every_query_has_exactly_one_solution, invariant_scope_and_class_agree, invariant_resolved_scope_answers_carry_citations]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
