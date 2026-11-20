% SPDX-License-Identifier: EUPL-1.2
:- module(m__sg_data_protection_pdpa_data_breach_notification_tests_test_properties, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__sg_data_protection_pdpa_data_breach_notification_pdpa_data_breach_notification, [decide_pdpa_data_breach_notification/2, pdpa_data_breach_notification_checklist/2, data_breach_notifiability/3, individual_notification/3, breach_response_duty/3, pdpa_breach_assessment/2]).
:- use_module(m__sg_data_protection_pdpa_data_breach_notification_fixtures, [pdpa_data_breach_notification_subject/1, pdpa_data_breach_notification_profile_for/2]).

harm_result(Profile, Result, Citations) :-
    pdpa_data_breach_notification_checklist(Profile, [item(significant_harm, Result, Citations)|_]).

scale_result(Profile, Result, Citations) :-
    pdpa_data_breach_notification_checklist(Profile, [_, item(significant_scale, Result, Citations)|_]).

query_name(harm_result).
query_name(scale_result).
query_name(data_breach_notifiability).
query_name(individual_notification).
query_name(breach_response_duty).

nonfinal_result(indeterminate(_)).
nonfinal_result(needs_legal_review(_, _)).
nonfinal_result(input_problems(_)).

final_result(significant_harm).
final_result(no_significant_harm).
final_result(significant_scale).
final_result(no_significant_scale).
final_result(notifiable).
final_result(not_notifiable).
final_result(not_applicable).
final_result(required).
final_result(not_required).
final_result(prohibited).
final_result(waived).
final_result(assessment_required).
final_result(notify_organisation_without_undue_delay).
final_result(notify_public_agency_without_undue_delay).
final_result(no_duty_triggered).

subject_classifies(Subject) :-
    pdpa_data_breach_notification_subject(Subject),
    pdpa_data_breach_notification_profile_for(Subject, Profile),
    decide_pdpa_data_breach_notification(Profile, _Verdict).

subject_verdict_count(Subject, Count) :-
    pdpa_data_breach_notification_profile_for(Subject, Profile),
    findall(Verdict, decide_pdpa_data_breach_notification(Profile, Verdict), Verdicts),
    length(Verdicts, Count).

subject_query_count(Subject, QueryName, Count) :-
    pdpa_data_breach_notification_profile_for(Subject, Profile),
    findall(Result - Citations, call(QueryName, Profile, Result, Citations), Answers),
    length(Answers, Count).

test(totality_every_subject_classifies) :-
    findall(Subject, pdpa_data_breach_notification_subject(Subject), Subjects),
    sort(Subjects, SubjectSet),
    findall(Subject, subject_classifies(Subject), ClassifiedSubjects),
    sort(ClassifiedSubjects, SubjectSet).
test(determinism_every_subject_has_exactly_one_verdict) :-
    findall(Subject, pdpa_data_breach_notification_subject(Subject), Subjects),
    findall(Subject, (pdpa_data_breach_notification_subject(Subject), subject_verdict_count(Subject, 1)), SingleVerdictSubjects),
    SingleVerdictSubjects == Subjects.
test(determinism_every_query_has_exactly_one_answer_per_subject) :-
    findall(Subject - QueryName, (pdpa_data_breach_notification_subject(Subject), query_name(QueryName)), Cases),
    findall(Subject - QueryName, (pdpa_data_breach_notification_subject(Subject), query_name(QueryName), subject_query_count(Subject, QueryName, 1)), SingleAnswerCases),
    SingleAnswerCases == Cases.
test(a_status_compound_does_occur_with_empty_citations) :-
    pdpa_data_breach_notification_profile_for(missing_breach_date, Profile),
    data_breach_notifiability(Profile, Result, []),
    nonfinal_result(Result).
test(a_final_result_does_occur_with_citations) :-
    pdpa_data_breach_notification_profile_for(account_pair_breach, Profile),
    data_breach_notifiability(Profile, Result, [_|_]),
    final_result(Result).
test(the_assessment_decision_does_match_notifiability) :-
    pdpa_data_breach_notification_profile_for(affected_count_at_prescribed_number, Profile),
    pdpa_breach_assessment(Profile, pdpa_breach(Decision, _, _, _, _)),
    data_breach_notifiability(Profile, Decision, _).

test(a_status_compound_never_carries_citations, fail) :-
    pdpa_data_breach_notification_subject(Subject),
    pdpa_data_breach_notification_profile_for(Subject, Profile),
    query_name(QueryName),
    call(QueryName, Profile, Result, [_|_]),
    nonfinal_result(Result).
test(a_final_result_always_carries_citations, fail) :-
    pdpa_data_breach_notification_subject(Subject),
    pdpa_data_breach_notification_profile_for(Subject, Profile),
    query_name(QueryName),
    call(QueryName, Profile, Result, []),
    final_result(Result).
test(the_assessment_decision_is_never_another_than_notifiability, fail) :-
    pdpa_data_breach_notification_subject(Subject),
    pdpa_data_breach_notification_profile_for(Subject, Profile),
    pdpa_breach_assessment(Profile, pdpa_breach(Decision, _, _, _, _)),
    data_breach_notifiability(Profile, NotifiabilityResult, _),
    dif(Decision, NotifiabilityResult).

cp_test_names([totality_every_subject_classifies, determinism_every_subject_has_exactly_one_verdict, determinism_every_query_has_exactly_one_answer_per_subject, a_status_compound_does_occur_with_empty_citations, a_final_result_does_occur_with_citations, the_assessment_decision_does_match_notifiability]).
cp_test_fail_names([a_status_compound_never_carries_citations, a_final_result_always_carries_citations, the_assessment_decision_is_never_another_than_notifiability]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
