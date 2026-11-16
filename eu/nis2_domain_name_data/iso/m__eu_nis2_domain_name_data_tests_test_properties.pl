% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_nis2_domain_name_data_tests_test_properties, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_nis2_domain_name_data_nis2_domain_name_data, [decide_nis2_domain_name_data/2, provider_duties/2, required_registration_data/2, publication_duty/3, access_duty/3, access_reply_timeliness/3]).
:- use_module(m__eu_nis2_domain_name_data_fixtures, [nis2_domain_name_data_subject/1, nis2_domain_name_data_profile_for/2]).

subject_classifies(Subject) :-
    nis2_domain_name_data_subject(Subject),
    nis2_domain_name_data_profile_for(Subject, Profile),
    decide_nis2_domain_name_data(Profile, _Verdict).

subject_has_one_verdict(Subject) :-
    nis2_domain_name_data_subject(Subject),
    nis2_domain_name_data_profile_for(Subject, Profile),
    findall(Verdict, decide_nis2_domain_name_data(Profile, Verdict), Verdicts),
    length(Verdicts, 1).

subject_has_one_answer_everywhere(Subject) :-
    nis2_domain_name_data_subject(Subject),
    nis2_domain_name_data_profile_for(Subject, Profile),
    findall(Duties, provider_duties(Profile, Duties), DutySolutions),
    length(DutySolutions, 1),
    findall(Fields, required_registration_data(Profile, Fields), FieldSolutions),
    length(FieldSolutions, 1),
    findall(Result, publication_duty(Profile, Result, _), PublicationSolutions),
    length(PublicationSolutions, 1),
    findall(Result, access_duty(Profile, Result, _), AccessSolutions),
    length(AccessSolutions, 1),
    findall(Result, access_reply_timeliness(Profile, 30, Result), ReplySolutions),
    length(ReplySolutions, 1).

test(totality_every_subject_classifies) :-
    findall(Subject, nis2_domain_name_data_subject(Subject), Subjects),
    sort(Subjects, SubjectSet),
    findall(Subject, subject_classifies(Subject), ClassifiedSubjects),
    sort(ClassifiedSubjects, SubjectSet).
test(determinism_every_subject_has_exactly_one_verdict) :-
    findall(Subject, nis2_domain_name_data_subject(Subject), Subjects),
    sort(Subjects, SubjectSet),
    findall(Subject, subject_has_one_verdict(Subject), SingleSubjects),
    sort(SingleSubjects, SubjectSet).
test(determinism_every_query_has_exactly_one_answer_for_every_subject) :-
    findall(Subject, nis2_domain_name_data_subject(Subject), Subjects),
    sort(Subjects, SubjectSet),
    findall(Subject, subject_has_one_answer_everywhere(Subject), SingleSubjects),
    sort(SingleSubjects, SubjectSet).
test(invariant_every_addressed_provider_type_gets_the_same_duties) :-
    provider_duties([attribute(provider_type, tld_name_registry)], Duties),
    provider_duties([attribute(provider_type, domain_name_registration_service_entity)], Duties).
test(invariant_reply_beyond_the_limit_ignores_every_key) :-
    access_reply_timeliness([attribute(reply_without_undue_delay, true)], 73, late(hour_limit)),
    access_reply_timeliness([attribute(reply_without_undue_delay, unsure)], 73, late(hour_limit)),
    access_reply_timeliness([], 73, late(hour_limit)).
test(invariant_reply_does_not_read_the_access_keys) :-
    access_reply_timeliness([attribute(reply_without_undue_delay, true), attribute(requester_is_legitimate_access_seeker, false)], 5, on_time).
test(invariant_a_false_access_key_decides_whatever_the_other_is) :-
    access_duty([attribute(request_is_lawful_and_duly_substantiated, false)], no_duty_to_provide_access, [cite(eu_dir_2022_2555_art_28_5)]),
    access_duty([attribute(request_is_lawful_and_duly_substantiated, false), attribute(requester_is_legitimate_access_seeker, unsure)], no_duty_to_provide_access, [cite(eu_dir_2022_2555_art_28_5)]).

cp_test_names([totality_every_subject_classifies, determinism_every_subject_has_exactly_one_verdict, determinism_every_query_has_exactly_one_answer_for_every_subject, invariant_every_addressed_provider_type_gets_the_same_duties, invariant_reply_beyond_the_limit_ignores_every_key, invariant_reply_does_not_read_the_access_keys, invariant_a_false_access_key_decides_whatever_the_other_is]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
