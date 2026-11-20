% SPDX-License-Identifier: EUPL-1.2
:- module(m__sg_tax_gst_registration_tests_test_properties, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__sg_tax_gst_registration_gst_registration, [decide_gst_registration/2, gst_registration_status/2]).
:- use_module(m__sg_tax_gst_registration_fixtures, [gst_registration_subject/1, gst_registration_profile_for/2]).

subject_status(Subject, Status) :-
    gst_registration_subject(Subject),
    gst_registration_profile_for(Subject, Profile),
    gst_registration_status(Profile, Status).

subject_has_one_status(Subject) :-
    gst_registration_subject(Subject),
    gst_registration_profile_for(Subject, Profile),
    findall(Status, gst_registration_status(Profile, Status), Statuses),
    length(Statuses, 1).

test(totality_every_subject_classifies) :-
    findall(Subject, gst_registration_subject(Subject), AllSubjects),
    sort(AllSubjects, SubjectSet),
    findall(Subject, subject_status(Subject, _Status), ClassifiedSubjects),
    sort(ClassifiedSubjects, SubjectSet).
test(determinism_every_subject_has_one_status) :-
    findall(Subject, gst_registration_subject(Subject), AllSubjects),
    sort(AllSubjects, SubjectSet),
    findall(Subject, subject_has_one_status(Subject), DeterministicSubjects),
    sort(DeterministicSubjects, SubjectSet).
test(retrospective_at_threshold_is_ineligible) :-
    gst_registration_profile_for(retrospective_not_liable_at_threshold, Profile),
    gst_registration_status(Profile, ineligible).
test(retrospective_one_cent_above_is_eligible) :-
    gst_registration_profile_for(retrospective_liable_just_above_threshold, Profile),
    gst_registration_status(Profile, eligible).
test(prospective_at_threshold_is_ineligible) :-
    gst_registration_profile_for(prospective_not_liable_at_threshold_pre_cutover, Profile),
    gst_registration_status(Profile, ineligible).
test(prospective_one_cent_above_is_eligible) :-
    gst_registration_profile_for(prospective_liable_pre_cutover_just_above_threshold, Profile),
    gst_registration_status(Profile, eligible).
test(liable_decide_has_citations) :-
    gst_registration_profile_for(retrospective_liable_just_above_threshold, Profile),
    decide_gst_registration(Profile, gst_registration_verdict(eligible, Citations)),
    Citations \= [].
test(indeterminate_decide_has_no_citations) :-
    gst_registration_profile_for(retrospective_indeterminate_missing_taxable_supplies, Profile),
    decide_gst_registration(Profile, gst_registration_verdict(indeterminate, [])).

cp_test_names([totality_every_subject_classifies, determinism_every_subject_has_one_status, retrospective_at_threshold_is_ineligible, retrospective_one_cent_above_is_eligible, prospective_at_threshold_is_ineligible, prospective_one_cent_above_is_eligible, liable_decide_has_citations, indeterminate_decide_has_no_citations]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
