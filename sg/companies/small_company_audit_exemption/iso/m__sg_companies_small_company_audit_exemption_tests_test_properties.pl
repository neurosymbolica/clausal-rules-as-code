% SPDX-License-Identifier: EUPL-1.2
:- module(m__sg_companies_small_company_audit_exemption_tests_test_properties, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__sg_companies_small_company_audit_exemption_small_company_audit_exemption, [decide_small_company_audit_exemption/2, small_company_audit_exemption_status/2]).
:- use_module(m__sg_companies_small_company_audit_exemption_fixtures, [small_company_audit_exemption_subject/1, small_company_audit_exemption_profile_for/2]).

subject_classifies(Subject) :-
    small_company_audit_exemption_subject(Subject),
    small_company_audit_exemption_profile_for(Subject, Profile),
    decide_small_company_audit_exemption(Profile, _).

test(totality_every_subject_classifies) :-
    findall(Subject, small_company_audit_exemption_subject(Subject), Subjects),
    sort(Subjects, SubjectSet),
    findall(Subject, subject_classifies(Subject), ClassifiedSubjects),
    sort(ClassifiedSubjects, SubjectSet).
test(determinism_exempt_profile) :-
    small_company_audit_exemption_profile_for(small_company_exempt, Profile),
    findall(Status, small_company_audit_exemption_status(Profile, Status), Statuses),
    Statuses == [exempt].
test(determinism_not_exempt_profile) :-
    small_company_audit_exemption_profile_for(two_criteria_above, Profile),
    findall(Status, small_company_audit_exemption_status(Profile, Status), Statuses),
    Statuses == [not_exempt].
test(determinism_fy_before_2015) :-
    small_company_audit_exemption_profile_for(fy_before_2015, Profile),
    findall(Status, small_company_audit_exemption_status(Profile, Status), Statuses),
    Statuses == [not_exempt].
test(determinism_audit_notice) :-
    small_company_audit_exemption_profile_for(audit_notice_in_window, Profile),
    findall(Status, small_company_audit_exemption_status(Profile, Status), Statuses),
    Statuses == [not_exempt].
test(determinism_parent_not_small_group) :-
    small_company_audit_exemption_profile_for(parent_not_small_group, Profile),
    findall(Status, small_company_audit_exemption_status(Profile, Status), Statuses),
    Statuses == [not_exempt].
test(determinism_parent_small_group) :-
    small_company_audit_exemption_profile_for(parent_small_group, Profile),
    findall(Status, small_company_audit_exemption_status(Profile, Status), Statuses),
    Statuses == [exempt].

cp_test_names([totality_every_subject_classifies, determinism_exempt_profile, determinism_not_exempt_profile, determinism_fy_before_2015, determinism_audit_notice, determinism_parent_not_small_group, determinism_parent_small_group]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
