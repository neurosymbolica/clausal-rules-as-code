% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_arts33_34_breach_notification_tests_test_output_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_arts33_34_breach_notification_breach_notification_verdict, [decide_breach_notification_verdict/2, breach_notification_verdict_status/2, breach_notification_verdict_checklist/2, notification_obligation/2, authority_notification_deadline/3, authority_notification_period_end/3, authority_notification_content_check/2, data_subject_communication_check/2]).
:- use_module(m__eu_data_protection_gdpr_arts33_34_breach_notification_fixtures, [gdpr_arts33_34_breach_notification_profile_for/2]).

subject_statuses(Subject, Statuses) :-
    gdpr_arts33_34_breach_notification_profile_for(Subject, Request),
    findall(Status, breach_notification_verdict_status(Request, Status), Statuses).

test(the_end_of_the_72nd_hour_is_in_time) :-
    subject_statuses(timely_notification_eligible, Statuses),
    Statuses == [eligible].
test(the_end_of_the_hour_of_awareness_is_in_time) :-
    subject_statuses(zero_hours_eligible, Statuses),
    Statuses == [eligible].
test(the_73rd_hour_without_reasons_is_not_met) :-
    subject_statuses(one_hour_late_without_reasons, Statuses),
    Statuses == [notification_requirement_not_met(reasons_for_delay)].
test(an_undue_delay_inside_the_period_is_not_met) :-
    subject_statuses(inside_period_unduly_delayed, Statuses),
    Statuses == [notification_requirement_not_met(without_undue_delay)].
test(an_unlikely_risk_is_ineligible) :-
    subject_statuses(unlikely_risk_ineligible, Statuses),
    Statuses == [ineligible].
test(late_with_justified_reasons_is_eligible) :-
    subject_statuses(late_with_justified_reasons_eligible, Statuses),
    Statuses == [eligible].
test(late_with_unjustified_reasons_refers_with_the_hours) :-
    subject_statuses(late_with_unjustified_reasons_referral, Statuses),
    Statuses == [needs_legal_review(open_textured(delay_justified_by_reasons, cite(eu_reg_2016_679_art_33_1)), [inputs_relied_on([hours_elapsed - 73, breach_unlikely_to_result_in_risk - false, delay_justified_by_reasons - false])])].
test(a_missing_risk_judgement_is_named) :-
    subject_statuses(risk_judgement_missing, Statuses),
    Statuses == [indeterminate([breach_unlikely_to_result_in_risk])].
test(an_unsure_risk_judgement_refers_without_the_hours) :-
    subject_statuses(unsure_risk_referral, Statuses),
    Statuses == [needs_legal_review(open_textured(breach_unlikely_to_result_in_risk, cite(eu_reg_2016_679_art_33_1)), [inputs_relied_on([breach_unlikely_to_result_in_risk - unsure])])].
test(contradictory_risk_inputs_are_input_problems) :-
    subject_statuses(contradictory_risk_inputs, Statuses),
    Statuses == [input_problems([contradictory_inputs([breach_unlikely_to_result_in_risk, breach_likely_to_result_in_high_risk])])].
test(negative_hours_are_input_problems) :-
    subject_statuses(negative_hours_input_problem, Statuses),
    Statuses == [input_problems([wrong_type(hours_elapsed)])].
test(the_final_verdict_carries_its_citation) :-
    gdpr_arts33_34_breach_notification_profile_for(timely_notification_eligible, Request),
    findall(Decision, decide_breach_notification_verdict(Request, Decision), Decisions),
    Decisions == [breach_notification_verdict(eligible, [cite(eu_reg_2016_679_art_33_1)])].
test(a_status_carries_no_citation) :-
    gdpr_arts33_34_breach_notification_profile_for(risk_judgement_missing, Request),
    findall(Decision, decide_breach_notification_verdict(Request, Decision), Decisions),
    Decisions == [breach_notification_verdict(indeterminate([breach_unlikely_to_result_in_risk]), [])].
test(the_checklist_reads_out_both_items) :-
    findall(Items, breach_notification_verdict_checklist(case([attribute(breach_unlikely_to_result_in_risk, false), attribute(notification_made_without_undue_delay, true)], 72), Items), Answers),
    Answers == [[item(notification_duty_arises, met, cite(eu_reg_2016_679_art_33_1)), item(notification_within_72_hours, met, cite(eu_reg_2016_679_art_33_1))]].
test(the_checklist_marks_the_73rd_hour) :-
    breach_notification_verdict_checklist(case([attribute(breach_unlikely_to_result_in_risk, false)], 73), [_, item(notification_within_72_hours, Status, _)]),
    Status == unmet(notification_after_72_hours).
test(the_deadline_reads_out_element_wise) :-
    findall(Year - Month - Day - Hours, authority_notification_deadline(date(2025, 10, 31), date(Year, Month, Day), Hours), Answers),
    Answers == [2025 - 11 - 3 - 72].
test(the_deadline_crosses_a_year_end) :-
    findall(Deadline - Hours, authority_notification_deadline(date(2025, 12, 30), Deadline, Hours), Answers),
    Answers == [date(2026, 1, 2) - 72].
test(the_deadline_reaches_a_saturday_and_stays) :-
    authority_notification_deadline(date(2026, 11, 11), Deadline, 72),
    Deadline == date(2026, 11, 14).
test(a_wrong_date_still_gives_seventy_two_hours) :-
    findall(Deadline - Hours, authority_notification_deadline(nonsense, Deadline, Hours), Answers),
    Answers == [input_problems([wrong_type(awareness_date)]) - 72].
test(the_period_end_reads_out) :-
    findall(PeriodEnd, authority_notification_period_end(date(2032, 2, 27), 10, PeriodEnd), Answers),
    Answers == [period_end(date(2032, 3, 1), 11)].
test(the_period_end_of_the_last_hour_is_the_end_of_the_day) :-
    authority_notification_period_end(date(2025, 12, 30), 23, PeriodEnd),
    PeriodEnd == period_end(date(2026, 1, 2), 24).
test(the_obligation_is_one_list) :-
    findall(Obligation, notification_obligation([attribute(party_role, controller), attribute(breach_unlikely_to_result_in_risk, false), attribute(breach_likely_to_result_in_high_risk, true), attribute(supervisory_authority_decision_on_communication, no_decision), attribute(appropriate_protection_measures_applied_to_affected_data, false), attribute(subsequent_measures_ensure_high_risk_no_longer_likely, false), attribute(communication_would_involve_disproportionate_effort, false)], Obligation), Answers),
    Answers == [[notify_supervisory_authority(cite(eu_reg_2016_679_art_33_1)), document_breach(cite(eu_reg_2016_679_art_33_5)), communicate_to_data_subject(cite(eu_reg_2016_679_art_34_1))]].
test(point_b_decides_while_point_a_is_absent) :-
    findall(Obligation, notification_obligation([attribute(party_role, controller), attribute(breach_unlikely_to_result_in_risk, false), attribute(breach_likely_to_result_in_high_risk, true), attribute(supervisory_authority_decision_on_communication, no_decision), attribute(subsequent_measures_ensure_high_risk_no_longer_likely, true)], Obligation), Answers),
    Answers == [[notify_supervisory_authority(cite(eu_reg_2016_679_art_33_1)), document_breach(cite(eu_reg_2016_679_art_33_5)), no_communication_required(cite(eu_reg_2016_679_art_34_3_b))]].
test(an_unsure_exemption_refers_with_its_pairs) :-
    findall(Obligation, notification_obligation([attribute(party_role, controller), attribute(breach_unlikely_to_result_in_risk, false), attribute(breach_likely_to_result_in_high_risk, true), attribute(supervisory_authority_decision_on_communication, no_decision), attribute(appropriate_protection_measures_applied_to_affected_data, unsure), attribute(subsequent_measures_ensure_high_risk_no_longer_likely, false), attribute(communication_would_involve_disproportionate_effort, false)], Obligation), Answers),
    Answers == [needs_legal_review(open_textured(appropriate_protection_measures_applied_to_affected_data, cite(eu_reg_2016_679_art_34_3_a)), [inputs_relied_on([breach_unlikely_to_result_in_risk - false, breach_likely_to_result_in_high_risk - true, appropriate_protection_measures_applied_to_affected_data - unsure])])].
test(a_missing_authority_decision_is_named) :-
    findall(Obligation, notification_obligation([attribute(party_role, controller), attribute(breach_unlikely_to_result_in_risk, false)], Obligation), Answers),
    Answers == [indeterminate([supervisory_authority_decision_on_communication])].
test(a_notification_missing_an_item_reads_out_the_item) :-
    findall(Result, authority_notification_content_check([attribute(notification_describes_nature_of_breach, false), attribute(notification_gives_categories_and_approximate_numbers, true), attribute(notification_gives_contact_point, true), attribute(notification_describes_likely_consequences, true), attribute(notification_describes_measures_taken_or_proposed, true), attribute(notification_describes_mitigation_measures, true), attribute(information_not_possible_to_provide_at_the_same_time, false)], Result), Answers),
    Answers == [requirements_not_met([nature_of_breach])].
test(a_communication_meeting_every_requirement) :-
    findall(Result, data_subject_communication_check([attribute(communication_made_without_undue_delay, true), attribute(communication_describes_nature_in_clear_and_plain_language, true), attribute(communication_gives_contact_point, true), attribute(communication_describes_likely_consequences, true), attribute(communication_describes_measures_taken_or_proposed, true), attribute(communication_describes_mitigation_measures, true)], Result), Answers),
    Answers == [all_requirements_met].
test(an_unsure_communication_timing_refers) :-
    findall(Result, data_subject_communication_check([attribute(communication_made_without_undue_delay, unsure), attribute(communication_describes_nature_in_clear_and_plain_language, true), attribute(communication_gives_contact_point, true), attribute(communication_describes_likely_consequences, true), attribute(communication_describes_measures_taken_or_proposed, true), attribute(communication_describes_mitigation_measures, true)], Result), Answers),
    Answers == [needs_legal_review(open_textured(communication_made_without_undue_delay, cite(eu_reg_2016_679_art_34_1)), [inputs_relied_on([communication_made_without_undue_delay - unsure])])].

cp_test_names([the_end_of_the_72nd_hour_is_in_time, the_end_of_the_hour_of_awareness_is_in_time, the_73rd_hour_without_reasons_is_not_met, an_undue_delay_inside_the_period_is_not_met, an_unlikely_risk_is_ineligible, late_with_justified_reasons_is_eligible, late_with_unjustified_reasons_refers_with_the_hours, a_missing_risk_judgement_is_named, an_unsure_risk_judgement_refers_without_the_hours, contradictory_risk_inputs_are_input_problems, negative_hours_are_input_problems, the_final_verdict_carries_its_citation, a_status_carries_no_citation, the_checklist_reads_out_both_items, the_checklist_marks_the_73rd_hour, the_deadline_reads_out_element_wise, the_deadline_crosses_a_year_end, the_deadline_reaches_a_saturday_and_stays, a_wrong_date_still_gives_seventy_two_hours, the_period_end_reads_out, the_period_end_of_the_last_hour_is_the_end_of_the_day, the_obligation_is_one_list, point_b_decides_while_point_a_is_absent, an_unsure_exemption_refers_with_its_pairs, a_missing_authority_decision_is_named, a_notification_missing_an_item_reads_out_the_item, a_communication_meeting_every_requirement, an_unsure_communication_timing_refers]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
