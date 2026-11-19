% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_information_duties_timing_tests_test_properties, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_information_duties_timing_queries, [information_deadline/2, information_deadline_basis/2, information_timing_verdict/3]).
:- use_module(m__eu_data_protection_gdpr_information_duties_timing_fixtures, [gdpr_information_duties_timing_subject/1, gdpr_information_duties_timing_profile_for/2]).

subject_set(SubjectSet) :-
    findall(Subject, gdpr_information_duties_timing_subject(Subject), Subjects),
    sort(Subjects, SubjectSet).

one_verdict(Subject) :-
    gdpr_information_duties_timing_subject(Subject),
    gdpr_information_duties_timing_profile_for(Subject, Profile),
    findall(Verdict - Citations, information_timing_verdict(Profile, Verdict, Citations), Answers),
    length(Answers, 1).

one_deadline(Subject) :-
    gdpr_information_duties_timing_subject(Subject),
    gdpr_information_duties_timing_profile_for(Subject, Profile),
    findall(Deadline, information_deadline(Profile, Deadline), Answers),
    length(Answers, 1).

one_basis(Subject) :-
    gdpr_information_duties_timing_subject(Subject),
    gdpr_information_duties_timing_profile_for(Subject, Profile),
    findall(Basis, information_deadline_basis(Profile, Basis), Answers),
    length(Answers, 1).

verdict_citations_consistent(timely, [cite(Key)]) :-
    member(Key, [eu_reg_2016_679_art_13_1, eu_reg_2016_679_art_14_3_a, eu_reg_2016_679_art_14_3_b, eu_reg_2016_679_art_14_3_c]).
verdict_citations_consistent(late, [cite(Key)]) :-
    member(Key, [eu_reg_2016_679_art_13_1, eu_reg_2016_679_art_14_3_a, eu_reg_2016_679_art_14_3_b, eu_reg_2016_679_art_14_3_c]).
verdict_citations_consistent(Verdict, []) :-
    compound(Verdict).

citations_consistent(Subject) :-
    gdpr_information_duties_timing_subject(Subject),
    gdpr_information_duties_timing_profile_for(Subject, Profile),
    information_timing_verdict(Profile, Verdict, Citations),
    verdict_citations_consistent(Verdict, Citations).

deadline_shape(date(Year, Month, Day)) :-
    integer(Year),
    integer(Month),
    integer(Day).
deadline_shape(indeterminate([_|_])).
deadline_shape(input_problems([_|_])).
deadline_shape(needs_legal_review(cross_reference_unresolved(_, _), _)).

well_shaped_deadline(Subject) :-
    gdpr_information_duties_timing_subject(Subject),
    gdpr_information_duties_timing_profile_for(Subject, Profile),
    information_deadline(Profile, Deadline),
    deadline_shape(Deadline).

test(totality_and_determinism_of_the_verdict) :-
    subject_set(SubjectSet),
    findall(Subject, one_verdict(Subject), Subjects),
    sort(Subjects, SubjectSet).
test(totality_and_determinism_of_the_deadline) :-
    subject_set(SubjectSet),
    findall(Subject, one_deadline(Subject), Subjects),
    sort(Subjects, SubjectSet).
test(totality_and_determinism_of_the_basis) :-
    subject_set(SubjectSet),
    findall(Subject, one_basis(Subject), Subjects),
    sort(Subjects, SubjectSet).
test(cites_are_given_exactly_for_final_verdicts) :-
    subject_set(SubjectSet),
    findall(Subject, citations_consistent(Subject), Subjects),
    sort(Subjects, SubjectSet).
test(every_deadline_is_a_date_or_a_status) :-
    subject_set(SubjectSet),
    findall(Subject, well_shaped_deadline(Subject), Subjects),
    sort(Subjects, SubjectSet).
test(unread_keys_do_not_change_the_answer) :-
    gdpr_information_duties_timing_profile_for(art13_on_obtaining_day, Plain),
    gdpr_information_duties_timing_profile_for(art13_with_unread_keys, WithUnreadKeys),
    information_timing_verdict(Plain, PlainVerdict, PlainCitations),
    information_timing_verdict(WithUnreadKeys, OtherVerdict, OtherCitations),
    PlainVerdict == OtherVerdict,
    PlainCitations == OtherCitations.
test(the_art13_route_never_reads_public_holidays) :-
    gdpr_information_duties_timing_profile_for(art13_on_obtaining_day, Plain),
    information_deadline([attribute(public_holidays, attested([date(2026, 3, 10)], attestation(by, at, reason, none)))|Plain], Deadline),
    Deadline == date(2026, 3, 10).

cp_test_names([totality_and_determinism_of_the_verdict, totality_and_determinism_of_the_deadline, totality_and_determinism_of_the_basis, cites_are_given_exactly_for_final_verdicts, every_deadline_is_a_date_or_a_status, unread_keys_do_not_change_the_answer, the_art13_route_never_reads_public_holidays]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
