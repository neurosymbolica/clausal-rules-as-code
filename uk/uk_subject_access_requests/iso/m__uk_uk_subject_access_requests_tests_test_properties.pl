% SPDX-License-Identifier: EUPL-1.2
:- module(m__uk_uk_subject_access_requests_tests_test_properties, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(library(clpz)).
:- use_module(m__uk_uk_subject_access_requests_uk_subject_access_requests, [decide_uk_subject_access_requests/2, uk_access_entitlement/3, uk_applicable_time_period/3, uk_clock_stop/3, uk_time_rules_regime/3, uk_relevant_time/5, uk_paused_days/4, uk_response_deadline/5, compare_uk_eu_response_deadline/6]).
:- use_module(m__uk_uk_subject_access_requests_citations, [citation/2]).
:- use_module(m__uk_uk_subject_access_requests_fixtures, [uk_subject_access_requests_subject/1, uk_subject_access_requests_profile_for/2, uk_subject_access_requests_date_fixture/2]).

subject_classifies(Subject) :-
    uk_subject_access_requests_subject(Subject),
    uk_subject_access_requests_profile_for(Subject, Profile),
    decide_uk_subject_access_requests(Profile, _Verdict).

subject_profile_answers(Subject, AccessAnswers, PeriodAnswers, ClockAnswers) :-
    uk_subject_access_requests_profile_for(Subject, Profile),
    findall(AccessResult - AccessCitations, uk_access_entitlement(Profile, AccessResult, AccessCitations), AccessAnswers),
    findall(Period - PeriodCitations, uk_applicable_time_period(Profile, Period, PeriodCitations), PeriodAnswers),
    findall(ClockResult - ClockCitations, uk_clock_stop(Profile, ClockResult, ClockCitations), ClockAnswers).

subject_is_deterministic(Subject) :-
    uk_subject_access_requests_subject(Subject),
    subject_profile_answers(Subject, AccessAnswers, PeriodAnswers, ClockAnswers),
    length(AccessAnswers, 1),
    length(PeriodAnswers, 1),
    length(ClockAnswers, 1).

subject_answer(Answer, Citations) :-
    uk_subject_access_requests_subject(Subject),
    subject_profile_answers(Subject, AccessAnswers, PeriodAnswers, ClockAnswers),
    append([AccessAnswers, PeriodAnswers, ClockAnswers], AllAnswers),
    member(Answer - Citations, AllAnswers).

date_case_answers(regime_case(Receipt), Answers) :-
    findall(Regime - Citations, uk_time_rules_regime(Receipt, Regime, Citations), Answers).
date_case_answers(relevant_time_case(Receipt, Identity, Fee), Answers) :-
    findall(Relevant - Citations, uk_relevant_time(Receipt, Identity, Fee, Relevant, Citations), Answers).
date_case_answers(paused_days_case(RequestDate, ReceivedDate), Answers) :-
    findall(Days - Citations, uk_paused_days(RequestDate, ReceivedDate, Days, Citations), Answers).
date_case_answers(deadline_case(Relevant, Period, PausedDays), Answers) :-
    findall(Deadline - Citations, uk_response_deadline(Relevant, Period, PausedDays, Deadline, Citations), Answers).
date_case_answers(comparison_case(Receipt, Period), Answers) :-
    findall(answer(UkDeadline, EuDeadline, Difference, Citations), compare_uk_eu_response_deadline(Receipt, Period, UkDeadline, EuDeadline, Difference, Citations), Answers).

answer_citation_list(_Value - Citations, Citations).
answer_citation_list(answer(_UkDeadline, _EuDeadline, _Difference, Citations), Citations).

date_case_is_deterministic(Case) :-
    uk_subject_access_requests_date_fixture(Case, CaseTerm),
    date_case_answers(CaseTerm, Answers),
    length(Answers, 1).

subject_cited_key(Key) :-
    subject_answer(_Answer, Citations),
    member(cite(Key), Citations).

date_cited_key(Key) :-
    uk_subject_access_requests_date_fixture(_Case, CaseTerm),
    date_case_answers(CaseTerm, Answers),
    member(Answer, Answers),
    answer_citation_list(Answer, Citations),
    member(cite(Key), Citations).

not_final(indeterminate(_MissingKeys)).
not_final(needs_legal_review(_Reason, _Context)).
not_final(input_problems(_Problems)).

test(totality_every_subject_classifies) :-
    findall(Subject, uk_subject_access_requests_subject(Subject), Subjects),
    sort(Subjects, SubjectSet),
    findall(Subject, subject_classifies(Subject), ClassifiedSubjects),
    sort(ClassifiedSubjects, SubjectSet).
test(determinism_every_subject_one_answer_per_query) :-
    findall(Subject, uk_subject_access_requests_subject(Subject), Subjects),
    sort(Subjects, SubjectSet),
    findall(Subject, subject_is_deterministic(Subject), DeterministicSubjects),
    sort(DeterministicSubjects, DeterministicSet),
    DeterministicSet == SubjectSet.
test(determinism_every_date_case_one_answer) :-
    findall(Case, uk_subject_access_requests_date_fixture(Case, _CaseTerm), Cases),
    findall(Case, date_case_is_deterministic(Case), DeterministicCases),
    DeterministicCases == Cases.
test(every_cited_key_is_recorded) :-
    findall(Key, subject_cited_key(Key), SubjectKeys),
    findall(Key, date_cited_key(Key), DateKeys),
    append(SubjectKeys, DateKeys, AllKeys),
    sort(AllKeys, CitedKeys),
    CitedKeys = [_FirstKey|_LaterKeys],
    findall(Key, (member(Key, CitedKeys), citation(Key, _Record)), RecordedKeys),
    sort(RecordedKeys, CitedKeys).
test(some_subject_answer_is_not_final) :-
    subject_answer(Answer, []),
    not_final(Answer).
test(final_answers_carry_citations) :-
    subject_answer(item_due, [_FirstCitation|_LaterCitations]).
test(unread_keys_do_not_change_the_access_answer) :-
    uk_subject_access_requests_profile_for(access_item_due, Profile),
    findall(Result - Citations, uk_access_entitlement(Profile, Result, Citations), Plain),
    append(Profile, [attribute(extension_notice_given, true), attribute(request_made_under_article_15, false), attribute(further_information_reasonably_required, unsure)], Extended),
    findall(Result - Citations, uk_access_entitlement(Extended, Result, Citations), WithUnread),
    WithUnread == Plain.
test(unread_keys_do_not_change_the_clock_answer) :-
    uk_subject_access_requests_profile_for(clock_stop_applies, Profile),
    findall(Result - Citations, uk_clock_stop(Profile, Result, Citations), Plain),
    append(Profile, [attribute(item_described_in_article_15_1, false), attribute(extension_notice_given, false)], Extended),
    findall(Result - Citations, uk_clock_stop(Extended, Result, Citations), WithUnread),
    WithUnread == Plain.
test(uk_earlier_and_same_both_occur) :-
    compare_uk_eu_response_deadline(date(2026, 2, 5), one_month, _UkEarlierDeadline, _EuLaterDeadline, uk_earlier, _EarlierCitations),
    compare_uk_eu_response_deadline(date(2026, 3, 31), one_month, _UkSameDeadline, _EuSameDeadline, same, _SameCitations).
test(paused_days_move_the_deadline_later) :-
    uk_response_deadline(date(2026, 2, 5), one_month, 0, PlainDeadline, _PlainCitations),
    uk_response_deadline(date(2026, 2, 5), one_month, 5, PausedDeadline, _PausedCitations),
    PlainDeadline == date(2026, 3, 4),
    PausedDeadline == date(2026, 3, 9).

test(not_final_answers_have_no_citations, fail) :-
    subject_answer(Answer, [_FirstCitation|_LaterCitations]),
    not_final(Answer).
test(uk_deadline_is_never_after_eu_deadline, fail) :-
    member(Period, [one_month, three_months]),
    between(2026, 2027, Year),
    between(1, 12, Month),
    between(1, 31, Day),
    compare_uk_eu_response_deadline(date(Year, Month, Day), Period, _UkDeadline, _EuDeadline, uk_later, _Citations).
test(deadline_is_never_before_relevant_time, fail) :-
    between(2026, 2028, Year),
    between(1, 12, Month),
    between(1, 31, Day),
    uk_response_deadline(date(Year, Month, Day), one_month, 0, date(DeadlineYear, DeadlineMonth, DeadlineDay), _Citations),
    DeadlineYear * 10000 + DeadlineMonth * 100 + DeadlineDay #< Year * 10000 + Month * 100 + Day.
test(three_months_never_earlier_than_one_month, fail) :-
    between(1, 12, Month),
    between(1, 28, Day),
    uk_response_deadline(date(2027, Month, Day), one_month, 0, date(OneYear, OneMonth, OneDay), _OneCitations),
    uk_response_deadline(date(2027, Month, Day), three_months, 0, date(ThreeYear, ThreeMonth, ThreeDay), _ThreeCitations),
    ThreeYear * 10000 + ThreeMonth * 100 + ThreeDay #=< OneYear * 10000 + OneMonth * 100 + OneDay.

cp_test_names([totality_every_subject_classifies, determinism_every_subject_one_answer_per_query, determinism_every_date_case_one_answer, every_cited_key_is_recorded, some_subject_answer_is_not_final, final_answers_carry_citations, unread_keys_do_not_change_the_access_answer, unread_keys_do_not_change_the_clock_answer, uk_earlier_and_same_both_occur, paused_days_move_the_deadline_later]).
cp_test_fail_names([not_final_answers_have_no_citations, uk_deadline_is_never_after_eu_deadline, deadline_is_never_before_relevant_time, three_months_never_earlier_than_one_month]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
