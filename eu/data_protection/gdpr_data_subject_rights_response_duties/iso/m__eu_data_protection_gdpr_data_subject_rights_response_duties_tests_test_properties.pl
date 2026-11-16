% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_data_subject_rights_response_duties_tests_test_properties, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_data_subject_rights_response_duties_gdpr_data_subject_rights_response_duties, [decide_gdpr_data_subject_rights_response_duties/2, request_response_deadline/2, response_duties/2, recipient_notification/2]).
:- use_module(m__eu_data_protection_gdpr_data_subject_rights_response_duties_fixtures, [gdpr_data_subject_rights_response_duties_subject/1, gdpr_data_subject_rights_response_duties_profile_for/2]).

subject_classifies(Subject) :-
    gdpr_data_subject_rights_response_duties_subject(Subject),
    gdpr_data_subject_rights_response_duties_profile_for(Subject, Profile),
    decide_gdpr_data_subject_rights_response_duties(Profile, _Verdict).

test(totality_every_subject_classifies) :-
    findall(Subject, gdpr_data_subject_rights_response_duties_subject(Subject), Subjects),
    sort(Subjects, SubjectSet),
    findall(Subject, subject_classifies(Subject), ClassifiedSubjects),
    sort(ClassifiedSubjects, SubjectSet).
test(determinism_of_the_decision) :-
    all_subjects(Subjects),
    all_single(decide_gdpr_data_subject_rights_response_duties, Subjects).
test(determinism_of_the_deadline) :-
    all_subjects(Subjects),
    all_single(request_response_deadline, Subjects).
test(determinism_of_the_duties) :-
    all_subjects(Subjects),
    all_single(response_duties, Subjects).
test(determinism_of_the_recipient_notification) :-
    all_subjects(Subjects),
    all_single(recipient_notification, Subjects).
test(every_verdict_has_a_known_shape_and_consistent_fields) :-
    all_subjects(Subjects),
    all_invariant(Subjects).
test(refusal_duty_matches_the_verdict) :-
    gdpr_data_subject_rights_response_duties_profile_for(access_excessive, Profile),
    response_duties(Profile, [inform_of_reasons_and_remedies(first_period, _)]),
    decide_gdpr_data_subject_rights_response_duties(Profile, gdpr_data_subject_request_verdict(need_not_comply, _, _, _, _)).

single_answer(Query, Profile) :-
    findall(Answer, call(Query, Profile, Answer), Answers),
    length(Answers, 1).

all_single(_, []).
all_single(Query, [Subject|Subjects]) :-
    gdpr_data_subject_rights_response_duties_profile_for(Subject, Profile),
    single_answer(Query, Profile),
    all_single(Query, Subjects).

all_subjects(Subjects) :-
    findall(Subject, gdpr_data_subject_rights_response_duties_subject(Subject), Subjects).

invariant_holds(gdpr_data_subject_request_verdict(must_comply, Basis, Exception, [], _)) :-
    dif(Basis, none),
    Exception == none.
invariant_holds(gdpr_data_subject_request_verdict(need_not_comply, _, _, _, _)).
invariant_holds(gdpr_data_subject_request_verdict(indeterminate([_|_]), none, none, [], [])).
invariant_holds(gdpr_data_subject_request_verdict(needs_legal_review(_, _), none, none, [], [])).
invariant_holds(gdpr_data_subject_request_verdict(suspended(art12_6_identity_not_confirmed), none, none, [], [])).
invariant_holds(gdpr_data_subject_request_verdict(input_problems([_|_]), none, none, [], [])).

all_invariant([]).
all_invariant([Subject|Subjects]) :-
    gdpr_data_subject_rights_response_duties_profile_for(Subject, Profile),
    decide_gdpr_data_subject_rights_response_duties(Profile, Verdict),
    invariant_holds(Verdict),
    all_invariant(Subjects).

cp_test_names([totality_every_subject_classifies, determinism_of_the_decision, determinism_of_the_deadline, determinism_of_the_duties, determinism_of_the_recipient_notification, every_verdict_has_a_known_shape_and_consistent_fields, refusal_duty_matches_the_verdict]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
