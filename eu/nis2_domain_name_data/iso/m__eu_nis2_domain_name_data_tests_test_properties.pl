% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_nis2_domain_name_data_tests_test_properties, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_nis2_domain_name_data_nis2_domain_name_data, [decide_nis2_domain_name_data/2, provider_duties/2, required_registration_data/2, publication_duty/3, access_duty/3, access_reply_timeliness/3]).
:- use_module(m__eu_nis2_domain_name_data_kernel, [nis2_domain_name_data_input_problems/2]).
:- use_module(m__eu_nis2_domain_name_data_fixtures, [nis2_domain_name_data_subject/1, nis2_domain_name_data_profile_for/2, nis2_domain_name_data_hours_for/2]).

all_subjects(SubjectSet) :-
    findall(Subject, nis2_domain_name_data_subject(Subject), Subjects),
    sort(Subjects, SubjectSet).

subject_answers_once(Subject) :-
    nis2_domain_name_data_subject(Subject),
    nis2_domain_name_data_profile_for(Subject, Profile),
    findall(Duties, provider_duties(Profile, Duties), [_]),
    findall(Fields, required_registration_data(Profile, Fields), [_]),
    findall(PublicationResult - PublicationCitations, publication_duty(Profile, PublicationResult, PublicationCitations), [_]),
    findall(AccessResult - AccessCitations, access_duty(Profile, AccessResult, AccessCitations), [_]),
    findall(Verdict, decide_nis2_domain_name_data(Profile, Verdict), [_]),
    findall(Problems, nis2_domain_name_data_input_problems(Profile, Problems), [_]).

subject_replies_once_at(Subject, HoursElapsed) :-
    nis2_domain_name_data_profile_for(Subject, Profile),
    findall(Result, access_reply_timeliness(Profile, HoursElapsed, Result), [_]).

subject_replies_once(Subject) :-
    nis2_domain_name_data_subject(Subject),
    subject_replies_once_at(Subject, 0),
    subject_replies_once_at(Subject, 72),
    subject_replies_once_at(Subject, 73).

status_compound(indeterminate(_)).
status_compound(needs_legal_review(_, _)).
status_compound(input_problems(_)).

final_result(must_publish_without_undue_delay).
final_result(no_publication_duty).
final_result(must_provide_access).
final_result(no_duty_to_provide_access).

citations_fit(Result, []) :-
    status_compound(Result).
citations_fit(Result, [cite(_)]) :-
    final_result(Result).

subject_citations_fit(Subject) :-
    nis2_domain_name_data_subject(Subject),
    nis2_domain_name_data_profile_for(Subject, Profile),
    publication_duty(Profile, PublicationResult, PublicationCitations),
    citations_fit(PublicationResult, PublicationCitations),
    access_duty(Profile, AccessResult, AccessCitations),
    citations_fit(AccessResult, AccessCitations).

test(totality_every_subject_classifies_once_per_query) :-
    all_subjects(SubjectSet),
    findall(Subject, subject_answers_once(Subject), AnsweringSubjects),
    sort(AnsweringSubjects, SubjectSet).
test(determinism_every_subject_replies_once_at_each_boundary) :-
    all_subjects(SubjectSet),
    findall(Subject, subject_replies_once(Subject), ReplyingSubjects),
    sort(ReplyingSubjects, SubjectSet).
test(determinism_every_reply_subject_replies_once_at_its_hours) :-
    findall(Subject, nis2_domain_name_data_hours_for(Subject, _), ReplySubjects),
    findall(Subject, (nis2_domain_name_data_hours_for(Subject, HoursElapsed), subject_replies_once_at(Subject, HoursElapsed)), OnceSubjects),
    OnceSubjects == ReplySubjects.
test(non_final_results_carry_no_citation_and_final_ones_one) :-
    all_subjects(SubjectSet),
    findall(Subject, subject_citations_fit(Subject), FittingSubjects),
    sort(FittingSubjects, SubjectSet).
test(every_duty_cites_a_paragraph_of_article_28) :-
    provider_duties([attribute(provider_type, tld_name_registry)], Duties),
    findall(Key, (member(duty(_, cite(Key)), Duties), member(Key, [eu_dir_2022_2555_art_28_1, eu_dir_2022_2555_art_28_2, eu_dir_2022_2555_art_28_3, eu_dir_2022_2555_art_28_4, eu_dir_2022_2555_art_28_5, eu_dir_2022_2555_art_28_6])), CitedKeys),
    length(CitedKeys, 9).
test(the_duties_are_nine_distinct_atoms) :-
    provider_duties([attribute(provider_type, domain_name_registration_service_entity)], Duties),
    findall(DutyName, member(duty(DutyName, _), Duties), DutyNames),
    sort(DutyNames, DistinctNames),
    length(DistinctNames, 9).
test(every_hour_up_to_seventy_two_is_on_time) :-
    findall(HoursElapsed, (between(0, 72, HoursElapsed), access_reply_timeliness([attribute(reply_without_undue_delay, true)], HoursElapsed, on_time)), OnTimeHours),
    length(OnTimeHours, 73).
test(every_hour_from_seventy_three_is_late) :-
    findall(HoursElapsed, (between(73, 200, HoursElapsed), access_reply_timeliness([attribute(reply_without_undue_delay, true)], HoursElapsed, late(hour_limit))), LateHours),
    length(LateHours, 128).
test(another_entity_gets_the_access_answer_of_an_addressed_provider) :-
    nis2_domain_name_data_profile_for(access_both_true, Profile),
    select(attribute(provider_type, _), Profile, Remaining),
    access_duty([attribute(provider_type, other)|Remaining], must_provide_access, [cite(eu_dir_2022_2555_art_28_5)]),
    provider_duties([attribute(provider_type, other)|Remaining], []).
test(an_absent_provider_type_does_not_block_publication) :-
    nis2_domain_name_data_profile_for(provider_type_absent, Profile),
    publication_duty(Profile, must_publish_without_undue_delay, [cite(eu_dir_2022_2555_art_28_4)]).

cp_test_names([totality_every_subject_classifies_once_per_query, determinism_every_subject_replies_once_at_each_boundary, determinism_every_reply_subject_replies_once_at_its_hours, non_final_results_carry_no_citation_and_final_ones_one, every_duty_cites_a_paragraph_of_article_28, the_duties_are_nine_distinct_atoms, every_hour_up_to_seventy_two_is_on_time, every_hour_from_seventy_three_is_late, another_entity_gets_the_access_answer_of_an_addressed_provider, an_absent_provider_type_does_not_block_publication]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
