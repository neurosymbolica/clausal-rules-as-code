% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_arts33_34_breach_notification_tests_test_properties, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_arts33_34_breach_notification_breach_notification_verdict, [breach_notification_verdict/4, notification_obligation/2, authority_notification_deadline/3]).
:- use_module(m__eu_data_protection_gdpr_arts33_34_breach_notification_fixtures, [gdpr_arts33_34_breach_notification_subject/1, gdpr_arts33_34_breach_notification_profile_for/2, gdpr_arts33_34_breach_notification_assess/2]).

has_one_answer(Subject) :-
    findall(Result, gdpr_arts33_34_breach_notification_assess(Subject, Result), [_]).

test(totality_and_determinism_every_subject_has_one_answer) :-
    findall(Subject, gdpr_arts33_34_breach_notification_subject(Subject), Subjects),
    Subjects = [_|_],
    maplist(has_one_answer, Subjects).
test(determinism_over_the_hours) :-
    findall(Profile, gdpr_arts33_34_breach_notification_profile_for(_, Profile), Profiles),
    numlist(0, 100, HoursList),
    maplist(one_verdict_at_every_hour(HoursList), Profiles).
test(every_fixture_gives_its_stated_verdict) :-
    findall(Subject, gdpr_arts33_34_breach_notification_subject(Subject), Subjects),
    maplist(fixture_matches, Subjects).
test(citations_are_complete_for_every_subject) :-
    findall(Subject, gdpr_arts33_34_breach_notification_subject(Subject), Subjects),
    maplist(citations_complete, Subjects).
test(an_unlikely_risk_is_ineligible_at_every_hour) :-
    findall(Verdict, (between(0, 150, HoursElapsed), breach_notification_verdict([attribute(breach_unlikely_to_result_in_risk, true)], HoursElapsed, Verdict, _)), Verdicts),
    length(Verdicts, 151),
    sort(Verdicts, [ineligible]).
test(a_late_notification_gets_a_verdict) :-
    breach_notification_verdict([attribute(breach_unlikely_to_result_in_risk, false), attribute(notification_accompanied_by_reasons_for_delay, true), attribute(delay_justified_by_reasons, false)], 200, Verdict, _),
    Verdict = needs_legal_review(_, _).
test(hours_are_always_72) :-
    maplist(hours_are_72, [date(2025, 10, 31), date(2032, 2, 29), date(2025, 2, 29), date(9999, 12, 30), not_a_date]).
test(every_final_controller_list_holds_one_article_34_term) :-
    findall(Profile, settled_controller_profile(Profile), Profiles),
    length(Profiles, 144),
    maplist(one_article_34_term, Profiles).

one_verdict_at(Profile, HoursElapsed) :-
    findall(Verdict, breach_notification_verdict(Profile, HoursElapsed, Verdict, _), [_]).

one_verdict_at_every_hour(HoursList, Profile) :-
    maplist(one_verdict_at(Profile), HoursList).

expected_fixture_status(timely_at_the_period_end, eligible).
expected_fixture_status(late_one_hour_past_without_reasons, notification_requirement_not_met(reasons_for_delay)).
expected_fixture_status(unlikely_risk_notified_late, ineligible).
expected_fixture_status(risk_notified_late_with_justified_reasons, eligible).
expected_fixture_status(late_with_unjustified_reasons, needs_legal_review(open_textured(delay_justified_by_reasons, cite(eu_reg_2016_679_art_33_1)), _)).
expected_fixture_status(notified_inside_the_period_without_undue_delay, eligible).
expected_fixture_status(notified_inside_the_period_with_undue_delay, notification_requirement_not_met(without_undue_delay)).
expected_fixture_status(risk_judgement_missing, indeterminate([breach_unlikely_to_result_in_risk])).
expected_fixture_status(risk_judgement_unsure, needs_legal_review(open_textured(breach_unlikely_to_result_in_risk, cite(eu_reg_2016_679_art_33_1)), _)).
expected_fixture_status(negative_hours_elapsed, input_problems([wrong_type(hours_elapsed)])).
expected_fixture_status(contradictory_risk_judgements, input_problems([contradictory_inputs([breach_unlikely_to_result_in_risk, breach_likely_to_result_in_high_risk])])).

fixture_matches(Subject) :-
    expected_fixture_status(Subject, Expected),
    gdpr_arts33_34_breach_notification_assess(Subject, breach_notification_verdict_verdict(Status, _)),
    Status = Expected.

expected_citations(eligible, [cite(eu_reg_2016_679_art_33_1)]).
expected_citations(ineligible, [cite(eu_reg_2016_679_art_33_1)]).
expected_citations(notification_requirement_not_met(_), [cite(eu_reg_2016_679_art_33_1)]).
expected_citations(indeterminate(_), []).
expected_citations(needs_legal_review(_, _), []).
expected_citations(input_problems(_), []).

citations_complete(Subject) :-
    gdpr_arts33_34_breach_notification_assess(Subject, breach_notification_verdict_verdict(Status, Citations)),
    expected_citations(Status, Expected),
    Citations == Expected.

test(lateness_alone_is_never_ineligible, fail) :-
    between(73, 200, HoursElapsed),
    member(Justified, [true, false, unsure]),
    breach_notification_verdict([attribute(breach_unlikely_to_result_in_risk, false), attribute(notification_accompanied_by_reasons_for_delay, true), attribute(delay_justified_by_reasons, Justified)], HoursElapsed, ineligible, _).

hours_are_72(Aware) :-
    authority_notification_deadline(Aware, _, Hours),
    Hours == 72.

risk_judgements(true, false).
risk_judgements(false, false).
risk_judgements(false, true).

authority_items([]).
authority_items([attribute(supervisory_authority_decision_on_communication, Decision)]) :-
    member(Decision, [no_decision, required_communication, decided_point_a_condition_met, decided_point_b_condition_met, decided_point_c_condition_met]).

settled_controller_profile([attribute(party_role, controller), attribute(breach_unlikely_to_result_in_risk, Risk), attribute(breach_likely_to_result_in_high_risk, HighRisk), attribute(appropriate_protection_measures_applied_to_affected_data, Protection), attribute(subsequent_measures_ensure_high_risk_no_longer_likely, Subsequent), attribute(communication_would_involve_disproportionate_effort, Effort)|AuthorityItems]) :-
    risk_judgements(Risk, HighRisk),
    authority_items(AuthorityItems),
    member(Protection, [true, false]),
    member(Subsequent, [true, false]),
    member(Effort, [true, false]).

article_33_term(no_notification_required(cite(eu_reg_2016_679_art_33_1))).
article_33_term(notify_supervisory_authority(cite(eu_reg_2016_679_art_33_1))).

article_34_term(communicate_to_data_subject(_)).
article_34_term(no_communication_required(_)).
article_34_term(public_communication_or_similar_measure(_)).

one_article_34_term(Profile) :-
    findall(Obligation, notification_obligation(Profile, Obligation), [[Article33Term, document_breach(cite(eu_reg_2016_679_art_33_5))|Rest]]),
    article_33_term(Article33Term),
    findall(Term, (member(Term, Rest), article_34_term(Term)), [_]).

cp_test_names([totality_and_determinism_every_subject_has_one_answer, determinism_over_the_hours, every_fixture_gives_its_stated_verdict, citations_are_complete_for_every_subject, an_unlikely_risk_is_ineligible_at_every_hour, a_late_notification_gets_a_verdict, hours_are_always_72, every_final_controller_list_holds_one_article_34_term]).
cp_test_fail_names([lateness_alone_is_never_ineligible]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
