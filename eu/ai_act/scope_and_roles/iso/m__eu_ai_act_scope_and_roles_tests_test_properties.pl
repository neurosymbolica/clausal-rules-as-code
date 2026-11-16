% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_ai_act_scope_and_roles_tests_test_properties, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_lists_extra, [subtract/3]).
:- use_module(m__eu_ai_act_scope_and_roles_scope_and_roles, [regulation_scope_status/4]).
:- use_module(m__eu_ai_act_scope_and_roles_kernel, [scope_and_roles_input_problems/2]).
:- use_module(m__eu_ai_act_scope_and_roles_queries, [scope_and_roles_what_if/4]).
:- use_module(m__eu_ai_act_scope_and_roles_fixtures, [scope_and_roles_subject/1, scope_and_roles_profile_for/2, scope_and_roles_assess/2]).

all_subjects(SubjectSet) :-
    findall(Subject, scope_and_roles_subject(Subject), Subjects),
    sort(Subjects, SubjectSet).

well_formed_subject(Subject) :-
    scope_and_roles_subject(Subject),
    scope_and_roles_profile_for(Subject, Profile),
    scope_and_roles_input_problems(Profile, []).

exactly_one_verdict(Subject) :-
    findall(Verdict, scope_and_roles_assess(Subject, Verdict), Verdicts),
    length(Verdicts, 1).

verdict_citations_fit(Subject) :-
    scope_and_roles_assess(Subject, scope_and_roles_verdict(Status, Citations)),
    citations_fit(Status, Citations).

citations_fit(Status, Citations) :-
    atom(Status),
    Citations = [_|_],
    sort(Citations, Citations),
    maplist(cite_term, Citations).
citations_fit(Status, []) :-
    compound(Status).

cite_term(cite(Key)) :-
    atom(Key).

not_an_ai_system_is_out_of_scope(Subject) :-
    scope_and_roles_profile_for(Subject, Profile),
    findall(Status, scope_and_roles_what_if(case(Profile, date(2026, 8, 1)), ai_system, false, Status), Statuses),
    Statuses == [out_of_scope].

not_applicable_before_february_2025(Subject) :-
    scope_and_roles_profile_for(Subject, Profile),
    findall(Result - Citations, regulation_scope_status(Profile, date(2025, 2, 1), Result, Citations), Answers),
    Answers == [not_applicable_on_date - [cite(eu_reg_2024_1689_art_113_a)]].

test(totality_and_determinism_every_subject_answers_once) :-
    all_subjects(Subjects),
    maplist(exactly_one_verdict, Subjects).
test(every_answer_has_citations_of_its_kind) :-
    all_subjects(Subjects),
    maplist(verdict_citations_fit, Subjects).
test(the_subject_set_is_not_empty) :-
    all_subjects([_, _|_]).
test(only_the_malformed_fixture_fails_the_input_check) :-
    all_subjects(Subjects),
    findall(Subject, well_formed_subject(Subject), WellFormed),
    sort(WellFormed, WellFormedSet),
    subtract(Subjects, WellFormedSet, Rejected),
    Rejected == [malformed_judgement_input_problem].
test(not_an_ai_system_settles_out_of_scope_for_every_subject) :-
    all_subjects(Subjects),
    maplist(not_an_ai_system_is_out_of_scope, Subjects).
test(article_2_never_applies_before_february_2025) :-
    findall(Subject, well_formed_subject(Subject), Subjects),
    maplist(not_applicable_before_february_2025, Subjects).
test(a_malformed_profile_is_answered_before_the_date) :-
    scope_and_roles_profile_for(malformed_judgement_input_problem, Profile),
    findall(Result, regulation_scope_status(Profile, date(2025, 2, 1), Result, _), Answers),
    Answers == [input_problems([wrong_type(ai_system)])].

cp_test_names([totality_and_determinism_every_subject_answers_once, every_answer_has_citations_of_its_kind, the_subject_set_is_not_empty, only_the_malformed_fixture_fails_the_input_check, not_an_ai_system_settles_out_of_scope_for_every_subject, article_2_never_applies_before_february_2025, a_malformed_profile_is_answered_before_the_date]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
