% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_data_subject_rights_response_period_tests_test_properties, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_data_subject_rights_response_period_gdpr_data_subject_rights_response_period, [decide_gdpr_data_subject_rights_response_period/2, gdpr_data_subject_rights_response_period_status/2, gdpr_data_subject_rights_response_period_status_values/1, applicable_response_period/2, response_deadline/3, request_outside_facts/2]).
:- use_module(m__eu_data_protection_gdpr_data_subject_rights_response_period_fixtures, [gdpr_data_subject_rights_response_period_subject/1, gdpr_data_subject_rights_response_period_profile_for/2]).

subject_classifies(Subject) :-
    gdpr_data_subject_rights_response_period_subject(Subject),
    gdpr_data_subject_rights_response_period_profile_for(Subject, Profile),
    decide_gdpr_data_subject_rights_response_period(Profile, _Verdict).

subject_answer_counts(Subject, counts(VerdictCount, PeriodCount, OutsideCount)) :-
    gdpr_data_subject_rights_response_period_profile_for(Subject, Profile),
    findall(Verdict, decide_gdpr_data_subject_rights_response_period(Profile, Verdict), Verdicts),
    length(Verdicts, VerdictCount),
    findall(Period, applicable_response_period(Profile, Period), Periods),
    length(Periods, PeriodCount),
    findall(OutsideFacts, request_outside_facts(Profile, OutsideFacts), OutsideAnswers),
    length(OutsideAnswers, OutsideCount).

subject_status_in_vocabulary(Subject) :-
    gdpr_data_subject_rights_response_period_subject(Subject),
    gdpr_data_subject_rights_response_period_profile_for(Subject, Profile),
    gdpr_data_subject_rights_response_period_status(Profile, Status),
    gdpr_data_subject_rights_response_period_status_values(StatusValues),
    member(Status, StatusValues).

sample_receipt(date(2026, 1, 31)).
sample_receipt(date(2026, 2, 28)).
sample_receipt(date(2026, 10, 29)).
sample_receipt(date(2026, 11, 30)).
sample_receipt(date(2026, 12, 31)).
sample_receipt(date(2028, 1, 31)).
sample_receipt(date(2100, 1, 29)).
sample_receipt(date(2000, 1, 30)).

receipt_deadline_counts(Receipt, counts(FirstCount, ExtendedCount)) :-
    findall(Deadline, response_deadline(Receipt, first_period, Deadline), FirstDeadlines),
    length(FirstDeadlines, FirstCount),
    findall(Deadline, response_deadline(Receipt, extended_period, Deadline), ExtendedDeadlines),
    length(ExtendedDeadlines, ExtendedCount).

test(totality_every_subject_classifies) :-
    findall(Subject, gdpr_data_subject_rights_response_period_subject(Subject), Subjects),
    sort(Subjects, SubjectSet),
    findall(Subject, subject_classifies(Subject), ClassifiedSubjects),
    sort(ClassifiedSubjects, SubjectSet).
test(determinism_every_subject_has_exactly_one_answer_per_query) :-
    findall(Subject - Counts, (gdpr_data_subject_rights_response_period_subject(Subject), subject_answer_counts(Subject, Counts)), Pairs),
    findall(Subject - counts(1, 1, 1), gdpr_data_subject_rights_response_period_subject(Subject), Pairs).
test(every_status_is_in_the_vocabulary) :-
    findall(Subject, gdpr_data_subject_rights_response_period_subject(Subject), Subjects),
    findall(Subject, subject_status_in_vocabulary(Subject), Subjects).
test(determinism_every_deadline_has_exactly_one_answer) :-
    findall(Receipt - Counts, (sample_receipt(Receipt), receipt_deadline_counts(Receipt, Counts)), Pairs),
    findall(Receipt - counts(1, 1), sample_receipt(Receipt), Pairs).
test(unread_keys_do_not_change_the_period) :-
    gdpr_data_subject_rights_response_period_profile_for(unread_keys_present, UnreadProfile),
    gdpr_data_subject_rights_response_period_profile_for(claimed_and_necessary, PlainProfile),
    findall(Period, applicable_response_period(UnreadProfile, Period), UnreadPeriods),
    findall(Period, applicable_response_period(PlainProfile, Period), PlainPeriods),
    UnreadPeriods == PlainPeriods.
test(the_extended_deadline_differs_from_the_first) :-
    response_deadline(date(2026, 10, 29), first_period, FirstDeadline),
    response_deadline(date(2026, 10, 29), extended_period, ExtendedDeadline),
    dif(FirstDeadline, ExtendedDeadline).
test(a_century_not_divisible_by_four_hundred_is_common) :-
    response_deadline(date(2100, 1, 29), first_period, date(2100, 3, 1)).
test(a_century_divisible_by_four_hundred_is_leap) :-
    response_deadline(date(2000, 1, 30), first_period, date(2000, 2, 29)).

cp_test_names([totality_every_subject_classifies, determinism_every_subject_has_exactly_one_answer_per_query, every_status_is_in_the_vocabulary, determinism_every_deadline_has_exactly_one_answer, unread_keys_do_not_change_the_period, the_extended_deadline_differs_from_the_first, a_century_not_divisible_by_four_hundred_is_common, a_century_divisible_by_four_hundred_is_leap]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
