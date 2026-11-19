% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_data_subject_rights_response_duties_tests_test_properties, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_data_subject_rights_response_duties_gdpr_data_subject_rights_response_duties, [decide_gdpr_data_subject_rights_response_duties/2, gdpr_data_subject_rights_response_duties_status/2, request_response_deadline/2, response_duties/2, recipient_notification/2]).
:- use_module(m__eu_data_protection_gdpr_data_subject_rights_response_duties_kernel, [gdpr_data_subject_rights_response_duties_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_data_subject_rights_response_duties_fixtures, [gdpr_data_subject_rights_response_duties_subject/1, gdpr_data_subject_rights_response_duties_profile_for/2]).

all_subjects(Subjects) :-
    findall(Subject, gdpr_data_subject_rights_response_duties_subject(Subject), Subjects).

exactly_one_answer(Subject) :-
    gdpr_data_subject_rights_response_duties_profile_for(Subject, Profile),
    findall(Verdict, decide_gdpr_data_subject_rights_response_duties(Profile, Verdict), Verdicts),
    length(Verdicts, 1),
    findall(Deadline, request_response_deadline(Profile, Deadline), Deadlines),
    length(Deadlines, 1),
    findall(Duties, response_duties(Profile, Duties), DutyAnswers),
    length(DutyAnswers, 1),
    findall(Duties, recipient_notification(Profile, Duties), RecipientAnswers),
    length(RecipientAnswers, 1).

non_empty_duties(Subject) :-
    gdpr_data_subject_rights_response_duties_profile_for(Subject, Profile),
    response_duties(Profile, Duties),
    Duties \== [],
    recipient_notification(Profile, RecipientDuties),
    RecipientDuties \== [].

refused_subject(Subject) :-
    gdpr_data_subject_rights_response_duties_subject(Subject),
    gdpr_data_subject_rights_response_duties_profile_for(Subject, Profile),
    gdpr_data_subject_rights_response_duties_status(Profile, need_not_comply).

refusal_answers(Subject) :-
    gdpr_data_subject_rights_response_duties_profile_for(Subject, Profile),
    response_duties(Profile, Duties),
    Duties == [inform_of_reasons_and_remedies(first_period, cite(eu_reg_2016_679_art_12_4))],
    recipient_notification(Profile, RecipientDuties),
    RecipientDuties == [recipient_notification_not_applicable(cite(eu_reg_2016_679_art_19))].

problem_subject(Subject) :-
    gdpr_data_subject_rights_response_duties_subject(Subject),
    gdpr_data_subject_rights_response_duties_profile_for(Subject, Profile),
    gdpr_data_subject_rights_response_duties_input_problems(Profile, [_|_]).

problems_reach_queries(Subject) :-
    gdpr_data_subject_rights_response_duties_profile_for(Subject, Profile),
    gdpr_data_subject_rights_response_duties_input_problems(Profile, Problems),
    request_response_deadline(Profile, Deadline),
    Deadline == input_problems(Problems),
    response_duties(Profile, Duties),
    Duties == input_problems(Problems),
    recipient_notification(Profile, RecipientDuties),
    RecipientDuties == input_problems(Problems).

test(totality_every_subject_classifies) :-
    all_subjects(Subjects),
    sort(Subjects, SubjectSet),
    findall(Subject, (member(Subject, Subjects), gdpr_data_subject_rights_response_duties_profile_for(Subject, Profile), decide_gdpr_data_subject_rights_response_duties(Profile, _)), ClassifiedSubjects),
    sort(ClassifiedSubjects, SubjectSet).
test(determinism_every_query_answers_exactly_once) :-
    all_subjects(Subjects),
    maplist(exactly_one_answer, Subjects).
test(no_duty_list_is_empty) :-
    all_subjects(Subjects),
    maplist(non_empty_duties, Subjects).
test(every_refusal_owes_reasons_and_no_communication) :-
    findall(Subject, refused_subject(Subject), Refused),
    Refused = [_|_],
    maplist(refusal_answers, Refused).
test(input_problems_reach_every_query_unchanged) :-
    findall(Subject, problem_subject(Subject), ProblemSubjects),
    ProblemSubjects = [_|_],
    maplist(problems_reach_queries, ProblemSubjects).

cp_test_names([totality_every_subject_classifies, determinism_every_query_answers_exactly_once, no_duty_list_is_empty, every_refusal_owes_reasons_and_no_communication, input_problems_reach_every_query_unchanged]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
