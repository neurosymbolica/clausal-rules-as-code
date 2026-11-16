% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_data_subject_rights_articles_20_to_22_decision_and_exception_tests_test_properties, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_lists, [msort/2]).
:- use_module(m__eu_data_protection_gdpr_data_subject_rights_articles_20_to_22_decision_and_exception_queries, [request_decision/2, request_exception/2]).
:- use_module(m__eu_data_protection_gdpr_data_subject_rights_articles_20_to_22_decision_and_exception_request_exception, [decide_request_exception/2]).
:- use_module(m__eu_data_protection_gdpr_data_subject_rights_articles_20_to_22_decision_and_exception_fixtures, [gdpr_data_subject_rights_articles_20_to_22_decision_and_exception_subject/1, gdpr_data_subject_rights_articles_20_to_22_decision_and_exception_profile_for/2]).

subject_count(Subject, Goal, Count) :-
    gdpr_data_subject_rights_articles_20_to_22_decision_and_exception_subject(Subject),
    gdpr_data_subject_rights_articles_20_to_22_decision_and_exception_profile_for(Subject, Profile),
    findall(Answer, call(Goal, Profile, Answer), Answers),
    length(Answers, Count).

single_answer(_ - 1).

comply_domain(must_comply).
comply_domain(need_not_comply).
comply_domain(indeterminate(_)).
comply_domain(needs_legal_review(_, _)).
comply_domain(suspended(art12_6_identity_not_confirmed)).
comply_domain(input_problems(_)).

in_comply_domain(Subject) :-
    gdpr_data_subject_rights_articles_20_to_22_decision_and_exception_subject(Subject),
    gdpr_data_subject_rights_articles_20_to_22_decision_and_exception_profile_for(Subject, Profile),
    request_decision(Profile, Comply),
    comply_domain(Comply).

test(there_are_subjects) :-
    findall(Subject, gdpr_data_subject_rights_articles_20_to_22_decision_and_exception_subject(Subject), Subjects),
    length(Subjects, Count),
    Count > 30.
test(totality_decision_one_answer_per_subject) :-
    findall(Subject - Count, subject_count(Subject, request_decision, Count), Pairs),
    Pairs = [_|_],
    maplist(single_answer, Pairs).
test(totality_exception_one_answer_per_subject) :-
    findall(Subject - Count, subject_count(Subject, request_exception, Count), Pairs),
    Pairs = [_|_],
    maplist(single_answer, Pairs).
test(totality_slice_verdict_one_answer_per_subject) :-
    findall(Subject - Count, subject_count(Subject, decide_request_exception, Count), Pairs),
    Pairs = [_|_],
    maplist(single_answer, Pairs).
test(every_decision_is_in_the_vocabulary) :-
    findall(Subject, gdpr_data_subject_rights_articles_20_to_22_decision_and_exception_subject(Subject), Subjects),
    findall(Subject, in_comply_domain(Subject), InDomain),
    msort(Subjects, Sorted),
    msort(InDomain, Sorted).
test(unread_keys_do_not_change_the_answer) :-
    gdpr_data_subject_rights_articles_20_to_22_decision_and_exception_profile_for(objection_art21_2_engaged, Plain),
    gdpr_data_subject_rights_articles_20_to_22_decision_and_exception_profile_for(objection_art21_2_no_balancing, Padded),
    request_decision(Plain, Answer),
    request_decision(Padded, Answer),
    request_exception(Plain, Exception),
    request_exception(Padded, Exception).
test(absent_blocking_outside_fact_positive_control) :-
    gdpr_data_subject_rights_articles_20_to_22_decision_and_exception_profile_for(portability_engaged, Profile),
    request_decision(Profile, must_comply).

test(absent_blocking_outside_fact_leaves_the_answer, fail) :-
    gdpr_data_subject_rights_articles_20_to_22_decision_and_exception_profile_for(portability_engaged, Profile),
    request_exception(Profile, art23_legislative_restriction).

cp_test_names([there_are_subjects, totality_decision_one_answer_per_subject, totality_exception_one_answer_per_subject, totality_slice_verdict_one_answer_per_subject, every_decision_is_in_the_vocabulary, unread_keys_do_not_change_the_answer, absent_blocking_outside_fact_positive_control]).
cp_test_fail_names([absent_blocking_outside_fact_leaves_the_answer]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
