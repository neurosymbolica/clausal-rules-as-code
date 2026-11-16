% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_child_consent_age_verdict_tests_test_properties, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_child_consent_age_verdict_child_consent_ground, [decide_child_consent/2, child_consent_ground/2]).
:- use_module(m__eu_data_protection_gdpr_child_consent_age_verdict_fixtures, [gdpr_child_consent_age_verdict_subject/1, gdpr_child_consent_age_verdict_profile_for/2]).

subjects_each_once([]).
subjects_each_once([Subject|Subjects]) :-
    gdpr_child_consent_age_verdict_profile_for(Subject, Profile),
    findall(Verdict, decide_child_consent(Profile, Verdict), Verdicts),
    length(Verdicts, 1),
    subjects_each_once(Subjects).

subjects_each_ground([]).
subjects_each_ground([Subject|Subjects]) :-
    gdpr_child_consent_age_verdict_profile_for(Subject, Profile),
    decide_child_consent(Profile, Verdict),
    ground(Verdict),
    subjects_each_ground(Subjects).

subjects_each_one_ground([]).
subjects_each_one_ground([Subject|Subjects]) :-
    gdpr_child_consent_age_verdict_profile_for(Subject, Profile),
    findall(Ground, child_consent_ground(Profile, Ground), Grounds),
    length(Grounds, 1),
    subjects_each_one_ground(Subjects).

status_ground_consistent(eligible, Ground) :-
    dif(Ground, none).
status_ground_consistent(ineligible, Ground) :-
    dif(Ground, none).
status_ground_consistent(indeterminate(_), none).
status_ground_consistent(needs_legal_review(_, _), none).
status_ground_consistent(input_problems(_), none).

subjects_each_consistent([]).
subjects_each_consistent([Subject|Subjects]) :-
    gdpr_child_consent_age_verdict_profile_for(Subject, Profile),
    decide_child_consent(Profile, gdpr_child_consent_verdict(Status, Ground, _Verification, _Citations)),
    status_ground_consistent(Status, Ground),
    subjects_each_consistent(Subjects).

citations_nonempty_unless_problems(input_problems(_), []).
citations_nonempty_unless_problems(eligible, [_|_]).
citations_nonempty_unless_problems(ineligible, [_|_]).
citations_nonempty_unless_problems(indeterminate(_), [_|_]).
citations_nonempty_unless_problems(needs_legal_review(_, _), [_|_]).

subjects_each_cited([]).
subjects_each_cited([Subject|Subjects]) :-
    gdpr_child_consent_age_verdict_profile_for(Subject, Profile),
    decide_child_consent(Profile, gdpr_child_consent_verdict(Status, _Ground, _Verification, Citations)),
    citations_nonempty_unless_problems(Status, Citations),
    subjects_each_cited(Subjects).

all_subjects(SubjectSet) :-
    findall(Subject, gdpr_child_consent_age_verdict_subject(Subject), Subjects),
    sort(Subjects, SubjectSet).

test(totality_and_determinism_every_subject_has_exactly_one_verdict) :-
    all_subjects(SubjectSet),
    subjects_each_once(SubjectSet).
test(the_ground_field_is_single_valued) :-
    all_subjects(SubjectSet),
    subjects_each_one_ground(SubjectSet).
test(every_verdict_is_ground) :-
    all_subjects(SubjectSet),
    subjects_each_ground(SubjectSet).
test(status_and_ground_agree) :-
    all_subjects(SubjectSet),
    subjects_each_consistent(SubjectSet).
test(citations_are_never_empty_except_for_input_problems) :-
    all_subjects(SubjectSet),
    subjects_each_cited(SubjectSet).
test(the_subject_registry_is_not_empty) :-
    all_subjects([_|_]).
test(a_non_list_profile_still_gets_one_verdict) :-
    findall(Verdict, decide_child_consent(not_a_profile, Verdict), Verdicts),
    Verdicts == [gdpr_child_consent_verdict(input_problems([wrong_type(profile)]), none, not_reached, [])].

cp_test_names([totality_and_determinism_every_subject_has_exactly_one_verdict, the_ground_field_is_single_valued, every_verdict_is_ground, status_and_ground_agree, citations_are_never_empty_except_for_input_problems, the_subject_registry_is_not_empty, a_non_list_profile_still_gets_one_verdict]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
