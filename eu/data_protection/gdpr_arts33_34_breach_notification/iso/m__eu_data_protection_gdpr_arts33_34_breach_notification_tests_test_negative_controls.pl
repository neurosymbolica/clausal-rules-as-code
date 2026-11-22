% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_arts33_34_breach_notification_tests_test_negative_controls, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_arts33_34_breach_notification_breach_notification_verdict, [breach_notification_verdict/4, breach_notification_verdict_status_values/1, notification_obligation/2, authority_notification_deadline/3, authority_notification_content_check/2, data_subject_communication_check/2]).

test(the_status_table_has_a_near_miss_atom) :-
    breach_notification_verdict_status_values(StatusValues),
    StatusValues == [eligible, ineligible].
test(unlikely_risk_is_ineligible) :-
    breach_notification_verdict([attribute(breach_unlikely_to_result_in_risk, true)], 10, ineligible, _).
test(a_risk_is_eligible_when_timely) :-
    breach_notification_verdict([attribute(breach_unlikely_to_result_in_risk, false), attribute(notification_made_without_undue_delay, true)], 10, eligible, _).
test(seventy_two_hours_is_eligible) :-
    breach_notification_verdict([attribute(breach_unlikely_to_result_in_risk, false), attribute(notification_made_without_undue_delay, true)], 72, eligible, _).
test(seventy_three_hours_needs_the_reasons) :-
    breach_notification_verdict([attribute(breach_unlikely_to_result_in_risk, false), attribute(notification_made_without_undue_delay, true)], 73, indeterminate([notification_accompanied_by_reasons_for_delay]), _).
test(undue_delay_is_not_met) :-
    breach_notification_verdict([attribute(breach_unlikely_to_result_in_risk, false), attribute(notification_made_without_undue_delay, false)], 10, notification_requirement_not_met(without_undue_delay), _).
test(no_reasons_is_not_met) :-
    breach_notification_verdict([attribute(breach_unlikely_to_result_in_risk, false), attribute(notification_accompanied_by_reasons_for_delay, false)], 80, notification_requirement_not_met(reasons_for_delay), _).
test(justified_reasons_are_eligible) :-
    breach_notification_verdict([attribute(breach_unlikely_to_result_in_risk, false), attribute(notification_accompanied_by_reasons_for_delay, true), attribute(delay_justified_by_reasons, true)], 80, eligible, _).
test(unjustified_reasons_refer) :-
    breach_notification_verdict([attribute(breach_unlikely_to_result_in_risk, false), attribute(notification_accompanied_by_reasons_for_delay, true), attribute(delay_justified_by_reasons, false)], 80, needs_legal_review(open_textured(delay_justified_by_reasons, _), _), []).
test(an_absent_risk_judgement_is_indeterminate) :-
    breach_notification_verdict([attribute(notification_made_without_undue_delay, true)], 10, indeterminate([breach_unlikely_to_result_in_risk]), []).
test(an_unsure_risk_judgement_refers) :-
    breach_notification_verdict([attribute(breach_unlikely_to_result_in_risk, unsure), attribute(notification_made_without_undue_delay, true)], 10, needs_legal_review(open_textured(breach_unlikely_to_result_in_risk, _), _), []).
test(a_negative_hour_count_is_refused) :-
    breach_notification_verdict([attribute(breach_unlikely_to_result_in_risk, false)], -1, input_problems(_), []).
test(a_processor_notifies_the_controller) :-
    notification_obligation([attribute(party_role, processor)], [notify_controller(cite(eu_reg_2016_679_art_33_2))]).
test(an_absent_decision_is_shown) :-
    notification_obligation([attribute(party_role, controller), attribute(breach_unlikely_to_result_in_risk, true)], [_, _, _, inputs_relied_on([supervisory_authority_decision_on_communication - no_decision])]).
test(disproportionate_effort_calls_for_a_public_communication) :-
    notification_obligation([attribute(party_role, controller), attribute(breach_unlikely_to_result_in_risk, false), attribute(breach_likely_to_result_in_high_risk, true), attribute(supervisory_authority_decision_on_communication, no_decision), attribute(appropriate_protection_measures_applied_to_affected_data, false), attribute(subsequent_measures_ensure_high_risk_no_longer_likely, false), attribute(communication_would_involve_disproportionate_effort, true)], [_, _, public_communication_or_similar_measure(cite(eu_reg_2016_679_art_34_3_c))]).
test(a_required_communication_governs) :-
    notification_obligation([attribute(party_role, controller), attribute(breach_unlikely_to_result_in_risk, true), attribute(supervisory_authority_decision_on_communication, required_communication)], [_, _, communicate_to_data_subject(cite(eu_reg_2016_679_art_34_4))]).
test(a_real_day_has_a_deadline) :-
    authority_notification_deadline(date(2025, 2, 28), Deadline, _),
    Deadline = date(2025, 3, 3).
test(phases_allowed_follow_in_phases) :-
    authority_notification_content_check([attribute(notification_describes_nature_of_breach, true), attribute(notification_gives_categories_and_approximate_numbers, true), attribute(notification_gives_contact_point, false), attribute(notification_describes_likely_consequences, true), attribute(notification_describes_measures_taken_or_proposed, true), attribute(notification_describes_mitigation_measures, true), attribute(information_not_possible_to_provide_at_the_same_time, true)], information_to_follow_in_phases([contact_point])).
test(a_mitigation_that_is_not_appropriate_is_not_missing) :-
    data_subject_communication_check([attribute(communication_made_without_undue_delay, true), attribute(communication_describes_nature_in_clear_and_plain_language, true), attribute(communication_gives_contact_point, true), attribute(communication_describes_likely_consequences, true), attribute(communication_describes_measures_taken_or_proposed, true), attribute(mitigation_measures_appropriate, false)], all_requirements_met).

test(a_risk_is_not_ineligible, fail) :-
    breach_notification_verdict([attribute(breach_unlikely_to_result_in_risk, false), attribute(notification_made_without_undue_delay, true)], 10, ineligible, _).
test(seventy_three_hours_is_not_eligible_on_timing_alone, fail) :-
    breach_notification_verdict([attribute(breach_unlikely_to_result_in_risk, false), attribute(notification_made_without_undue_delay, true)], 73, eligible, _).
test(no_undue_delay_is_not_a_failure, fail) :-
    breach_notification_verdict([attribute(breach_unlikely_to_result_in_risk, false), attribute(notification_made_without_undue_delay, true)], 10, notification_requirement_not_met(_), _).
test(justified_reasons_are_not_a_failure, fail) :-
    breach_notification_verdict([attribute(breach_unlikely_to_result_in_risk, false), attribute(notification_accompanied_by_reasons_for_delay, true), attribute(delay_justified_by_reasons, true)], 80, notification_requirement_not_met(_), _).
test(unjustified_reasons_are_not_eligible, fail) :-
    breach_notification_verdict([attribute(breach_unlikely_to_result_in_risk, false), attribute(notification_accompanied_by_reasons_for_delay, true), attribute(delay_justified_by_reasons, false)], 80, eligible, _).
test(an_unsure_risk_judgement_is_not_indeterminate, fail) :-
    breach_notification_verdict([attribute(breach_unlikely_to_result_in_risk, unsure), attribute(notification_made_without_undue_delay, true)], 10, indeterminate(_), _).
test(a_zero_hour_count_is_not_refused, fail) :-
    breach_notification_verdict([attribute(breach_unlikely_to_result_in_risk, false), attribute(notification_made_without_undue_delay, true)], 0, input_problems(_), _).
test(a_controller_does_not_notify_the_controller, fail) :-
    notification_obligation([attribute(party_role, controller), attribute(breach_unlikely_to_result_in_risk, true)], [notify_controller(_)|_]).
test(a_present_no_decision_is_not_shown, fail) :-
    notification_obligation([attribute(party_role, controller), attribute(breach_unlikely_to_result_in_risk, true), attribute(supervisory_authority_decision_on_communication, no_decision)], [_, _, _, inputs_relied_on(_)]).
test(no_disproportionate_effort_calls_for_no_public_communication, fail) :-
    notification_obligation([attribute(party_role, controller), attribute(breach_unlikely_to_result_in_risk, false), attribute(breach_likely_to_result_in_high_risk, true), attribute(supervisory_authority_decision_on_communication, no_decision), attribute(appropriate_protection_measures_applied_to_affected_data, false), attribute(subsequent_measures_ensure_high_risk_no_longer_likely, false), attribute(communication_would_involve_disproportionate_effort, false)], [_, _, public_communication_or_similar_measure(_)]).
test(no_decision_and_no_risk_needs_no_communication, fail) :-
    notification_obligation([attribute(party_role, controller), attribute(breach_unlikely_to_result_in_risk, true), attribute(supervisory_authority_decision_on_communication, no_decision)], [_, _, communicate_to_data_subject(_)]).
test(a_day_that_does_not_exist_has_no_deadline_day, fail) :-
    authority_notification_deadline(date(2025, 2, 29), date(_, _, _), _).
test(phases_not_allowed_do_not_follow_in_phases, fail) :-
    authority_notification_content_check([attribute(notification_describes_nature_of_breach, true), attribute(notification_gives_categories_and_approximate_numbers, true), attribute(notification_gives_contact_point, false), attribute(notification_describes_likely_consequences, true), attribute(notification_describes_measures_taken_or_proposed, true), attribute(notification_describes_mitigation_measures, true), attribute(information_not_possible_to_provide_at_the_same_time, false)], information_to_follow_in_phases(_)).
test(a_late_communication_does_not_meet_all_requirements, fail) :-
    data_subject_communication_check([attribute(communication_made_without_undue_delay, false), attribute(communication_describes_nature_in_clear_and_plain_language, true), attribute(communication_gives_contact_point, true), attribute(communication_describes_likely_consequences, true), attribute(communication_describes_measures_taken_or_proposed, true), attribute(mitigation_measures_appropriate, false)], all_requirements_met).

cp_test_names([the_status_table_has_a_near_miss_atom, unlikely_risk_is_ineligible, a_risk_is_eligible_when_timely, seventy_two_hours_is_eligible, seventy_three_hours_needs_the_reasons, undue_delay_is_not_met, no_reasons_is_not_met, justified_reasons_are_eligible, unjustified_reasons_refer, an_absent_risk_judgement_is_indeterminate, an_unsure_risk_judgement_refers, a_negative_hour_count_is_refused, a_processor_notifies_the_controller, an_absent_decision_is_shown, disproportionate_effort_calls_for_a_public_communication, a_required_communication_governs, a_real_day_has_a_deadline, phases_allowed_follow_in_phases, a_mitigation_that_is_not_appropriate_is_not_missing]).
cp_test_fail_names([a_risk_is_not_ineligible, seventy_three_hours_is_not_eligible_on_timing_alone, no_undue_delay_is_not_a_failure, justified_reasons_are_not_a_failure, unjustified_reasons_are_not_eligible, an_unsure_risk_judgement_is_not_indeterminate, a_zero_hour_count_is_not_refused, a_controller_does_not_notify_the_controller, a_present_no_decision_is_not_shown, no_disproportionate_effort_calls_for_no_public_communication, no_decision_and_no_risk_needs_no_communication, a_day_that_does_not_exist_has_no_deadline_day, phases_not_allowed_do_not_follow_in_phases, a_late_communication_does_not_meet_all_requirements]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
