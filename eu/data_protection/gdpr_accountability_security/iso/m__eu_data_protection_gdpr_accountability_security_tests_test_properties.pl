% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_accountability_security_tests_test_properties, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_accountability_security_gdpr_accountability_security, [decide_gdpr_accountability_security/2, gdpr_accountability_security_checklist/2, duty_status/5, non_binding_items/3, joint_controller_arrangement/3, joint_controller_arrangement_content/4]).
:- use_module(m__eu_data_protection_gdpr_accountability_security_kernel, [gdpr_accountability_security_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_accountability_security_citations, [citation/2]).
:- use_module(m__eu_data_protection_gdpr_accountability_security_fixtures, [gdpr_accountability_security_subject/1, gdpr_accountability_security_profile_for/2]).

duty_atom(accountability).
duty_atom(controller_measures).
duty_atom(data_protection_policies).
duty_atom(data_protection_by_design).
duty_atom(data_protection_by_default).
duty_atom(security_of_processing).
duty_atom(processing_on_instructions).

topic_atom(accountability_principles).
topic_atom(security_measures).

subject_profile(Subject, Profile) :-
    gdpr_accountability_security_subject(Subject),
    gdpr_accountability_security_profile_for(Subject, Profile).

subject_classifies(Subject) :-
    subject_profile(Subject, Profile),
    decide_gdpr_accountability_security(Profile, _Verdict).

test(totality_every_subject_classifies) :-
    findall(Subject, gdpr_accountability_security_subject(Subject), Subjects),
    sort(Subjects, SubjectSet),
    findall(Subject, subject_classifies(Subject), ClassifiedSubjects),
    sort(ClassifiedSubjects, SubjectSet).
test(determinism_every_subject_yields_one_verdict) :-
    findall(Subject - Count, (subject_profile(Subject, Profile), findall(Verdict, decide_gdpr_accountability_security(Profile, Verdict), Verdicts), length(Verdicts, Count)), Counts),
    findall(Subject - 1, gdpr_accountability_security_subject(Subject), Expected),
    Counts == Expected.
test(determinism_every_duty_answers_once_for_every_subject) :-
    findall(Count, duty_answer_count(Count), Counts),
    Counts = [_|_],
    sort(Counts, [1]).
test(determinism_every_topic_answers_once_for_every_subject) :-
    findall(Count, topic_answer_count(Count), Counts),
    Counts = [_|_],
    sort(Counts, [1]).
test(determinism_the_arrangement_answers_once_for_every_subject) :-
    findall(Count, arrangement_answer_count(Count), Counts),
    Counts = [_|_],
    sort(Counts, [1]).
test(determinism_the_content_answers_once_for_every_subject) :-
    findall(Count, content_answer_count(Count), Counts),
    Counts = [_|_],
    sort(Counts, [1]).
test(every_checklist_citation_is_recorded) :-
    checklist_citation_keys(Keys),
    Keys = [_|_],
    findall(Key, (member(Key, Keys), citation(Key, _)), Recorded),
    sort(Recorded, Keys).
test(the_non_binding_lists_do_not_depend_on_the_profile) :-
    non_binding_items([], accountability_principles, Principles),
    non_binding_items([], security_measures, Examples),
    findall(Topic - Items, well_formed_items(Topic, Items), Pairs),
    Pairs = [_|_],
    sort(Pairs, [accountability_principles - Principles, security_measures - Examples]).
test(true_optional_keys_change_no_answer) :-
    by_default_answer(all_statements_true, Baseline),
    by_default_answer(by_default_all_aspects_true, Baseline),
    by_default_answer(by_default_crisp_fact_true, Baseline).
test(a_profile_with_problems_gets_only_input_problems) :-
    findall(Verdict, problem_verdict(Verdict), Verdicts),
    length(Verdicts, 3),
    findall(Verdict, (member(Verdict, Verdicts), Verdict = gdpr_accountability_security_verdict(input_problems([_|_]), [])), Verdicts).

duty_answer_count(Count) :-
    subject_profile(_, Profile),
    duty_atom(Duty),
    findall(Result - Basis - Citations, duty_status(Profile, Duty, Result, Basis, Citations), Answers),
    length(Answers, Count).

topic_answer_count(Count) :-
    subject_profile(_, Profile),
    topic_atom(Topic),
    findall(Items, non_binding_items(Profile, Topic, Items), Answers),
    length(Answers, Count).

arrangement_answer_count(Count) :-
    subject_profile(_, Profile),
    findall(Result - Citations, joint_controller_arrangement(Profile, Result, Citations), Answers),
    length(Answers, Count).

content_answer_count(Count) :-
    subject_profile(_, Profile),
    findall(Result - Basis - Citations, joint_controller_arrangement_content(Profile, Result, Basis, Citations), Answers),
    length(Answers, Count).

checklist_citation_keys(Keys) :-
    findall(Key, (subject_profile(_, Profile), gdpr_accountability_security_checklist(Profile, Items), member(item(_, _, cite(Key)), Items)), Collected),
    sort(Collected, Keys).

well_formed_items(Topic, Items) :-
    subject_profile(_, Profile),
    gdpr_accountability_security_input_problems(Profile, []),
    topic_atom(Topic),
    non_binding_items(Profile, Topic, Items).

by_default_answer(Subject, Answer) :-
    gdpr_accountability_security_profile_for(Subject, Profile),
    findall(Result - Basis - Citations, duty_status(Profile, data_protection_by_default, Result, Basis, Citations), Answer).

problem_verdict(Verdict) :-
    subject_profile(_, Profile),
    gdpr_accountability_security_input_problems(Profile, [_|_]),
    decide_gdpr_accountability_security(Profile, Verdict).

cp_test_names([totality_every_subject_classifies, determinism_every_subject_yields_one_verdict, determinism_every_duty_answers_once_for_every_subject, determinism_every_topic_answers_once_for_every_subject, determinism_the_arrangement_answers_once_for_every_subject, determinism_the_content_answers_once_for_every_subject, every_checklist_citation_is_recorded, the_non_binding_lists_do_not_depend_on_the_profile, true_optional_keys_change_no_answer, a_profile_with_problems_gets_only_input_problems]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
