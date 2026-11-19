% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_arts33_34_breach_notification_tests_test_properties, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_arts33_34_breach_notification_breach_notification_verdict, [decide_breach_notification_verdict/2, breach_notification_verdict/4, notification_obligation/2, authority_notification_deadline/3, authority_notification_period_end/3]).
:- use_module(m__eu_data_protection_gdpr_arts33_34_breach_notification_kernel, [gdpr_arts33_34_breach_notification_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_arts33_34_breach_notification_fixtures, [gdpr_arts33_34_breach_notification_subject/1, gdpr_arts33_34_breach_notification_profile_for/2]).

all_subjects(Subjects) :-
    findall(Subject, gdpr_arts33_34_breach_notification_subject(Subject), Subjects).

subject_classifies(Subject) :-
    gdpr_arts33_34_breach_notification_subject(Subject),
    gdpr_arts33_34_breach_notification_profile_for(Subject, Request),
    decide_breach_notification_verdict(Request, _Verdict).

subject_has_one_verdict(Subject) :-
    gdpr_arts33_34_breach_notification_profile_for(Subject, Request),
    findall(Verdict, decide_breach_notification_verdict(Request, Verdict), Verdicts),
    length(Verdicts, 1).

subject_has_one_input_check(Subject) :-
    gdpr_arts33_34_breach_notification_profile_for(Subject, breach_notification_request(Profile, _)),
    findall(Problems, gdpr_arts33_34_breach_notification_input_problems(Profile, Problems), Answers),
    length(Answers, 1).

subject_has_one_obligation(Subject) :-
    gdpr_arts33_34_breach_notification_profile_for(Subject, breach_notification_request(Profile, _)),
    findall(Obligation, notification_obligation(Profile, Obligation), Answers),
    length(Answers, 1).

subject_citations_fit(Subject) :-
    gdpr_arts33_34_breach_notification_profile_for(Subject, breach_notification_request(Profile, HoursElapsed)),
    breach_notification_verdict(Profile, HoursElapsed, Verdict, Citations),
    citations_fit_verdict(Verdict, Citations).

citations_fit_verdict(eligible, [cite(eu_reg_2016_679_art_33_1)]).
citations_fit_verdict(ineligible, [cite(eu_reg_2016_679_art_33_1)]).
citations_fit_verdict(notification_requirement_not_met(_), [cite(eu_reg_2016_679_art_33_1)]).
citations_fit_verdict(indeterminate([_|_]), []).
citations_fit_verdict(needs_legal_review(open_textured(_, cite(_)), [inputs_relied_on(_)|_]), []).
citations_fit_verdict(input_problems([_|_]), []).

ineligible_at(HoursElapsed) :-
    breach_notification_verdict([attribute(breach_unlikely_to_result_in_risk, true)], HoursElapsed, ineligible, [cite(eu_reg_2016_679_art_33_1)]).

boundary_verdict_at(HoursElapsed, Verdict) :-
    breach_notification_verdict([attribute(breach_unlikely_to_result_in_risk, false), attribute(notification_made_without_undue_delay, true), attribute(notification_accompanied_by_reasons_for_delay, false)], HoursElapsed, Verdict, _).

documents_the_breach_second(Subject) :-
    gdpr_arts33_34_breach_notification_profile_for(Subject, breach_notification_request(Profile, _)),
    notification_obligation(Profile, [_, document_breach(cite(eu_reg_2016_679_art_33_5))|_]).

hours_always_72(Aware) :-
    authority_notification_deadline(Aware, _, Hours),
    Hours == 72.

end_hour_follows(AwarenessHour) :-
    authority_notification_period_end(date(2025, 6, 10), AwarenessHour, period_end(_, EndHour)),
    EndHour =:= AwarenessHour + 1.

test(totality_every_subject_classifies) :-
    all_subjects(Subjects),
    sort(Subjects, SubjectSet),
    findall(Subject, subject_classifies(Subject), ClassifiedSubjects),
    sort(ClassifiedSubjects, SubjectSet).
test(determinism_every_subject_has_exactly_one_verdict) :-
    all_subjects(Subjects),
    maplist(subject_has_one_verdict, Subjects).
test(determinism_every_subject_has_exactly_one_input_check) :-
    all_subjects(Subjects),
    maplist(subject_has_one_input_check, Subjects).
test(determinism_every_subject_has_exactly_one_obligation) :-
    all_subjects(Subjects),
    maplist(subject_has_one_obligation, Subjects).
test(citation_completeness_over_every_subject) :-
    all_subjects(Subjects),
    maplist(subject_citations_fit, Subjects).
test(unlikely_risk_is_ineligible_whatever_the_hours) :-
    maplist(ineligible_at, [0, 1, 71, 72, 73, 500]).
test(the_verdict_flips_exactly_after_the_72nd_hour) :-
    numlist(70, 75, HourCounts),
    maplist(boundary_verdict_at, HourCounts, Verdicts),
    Verdicts == [eligible, eligible, eligible, notification_requirement_not_met(reasons_for_delay), notification_requirement_not_met(reasons_for_delay), notification_requirement_not_met(reasons_for_delay)].
test(every_final_controller_list_documents_the_breach_second) :-
    maplist(documents_the_breach_second, [public_communication_substitute, direct_communication_owed, authority_required_communication, authority_no_decision_unlikely_risk]).
test(hours_is_72_for_every_awareness_date) :-
    maplist(hours_always_72, [date(2025, 1, 1), date(2025, 2, 30), nothing, "2025-01-01"]).
test(the_end_hour_follows_every_hour_of_awareness) :-
    numlist(0, 23, AwarenessHours),
    maplist(end_hour_follows, AwarenessHours).
test(a_deadline_on_a_saturday_is_not_moved) :-
    authority_notification_deadline(date(2025, 12, 24), date(DeadlineYear, DeadlineMonth, DeadlineDay), _),
    DeadlineYear == 2025,
    DeadlineMonth == 12,
    DeadlineDay == 27.

cp_test_names([totality_every_subject_classifies, determinism_every_subject_has_exactly_one_verdict, determinism_every_subject_has_exactly_one_input_check, determinism_every_subject_has_exactly_one_obligation, citation_completeness_over_every_subject, unlikely_risk_is_ineligible_whatever_the_hours, the_verdict_flips_exactly_after_the_72nd_hour, every_final_controller_list_documents_the_breach_second, hours_is_72_for_every_awareness_date, the_end_hour_follows_every_hour_of_awareness, a_deadline_on_a_saturday_is_not_moved]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
