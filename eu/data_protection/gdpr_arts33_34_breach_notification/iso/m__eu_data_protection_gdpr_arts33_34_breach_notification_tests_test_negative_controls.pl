% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_arts33_34_breach_notification_tests_test_negative_controls, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_arts33_34_breach_notification_breach_notification_verdict, [breach_notification_verdict_status/2, breach_notification_verdict_status_values/1, notification_obligation/2, authority_notification_period_end/3, authority_notification_content_check/2, data_subject_communication_check/2]).
:- use_module(m__eu_data_protection_gdpr_arts33_34_breach_notification_fixtures, [gdpr_arts33_34_breach_notification_profile_for/2]).

subject_status(Subject, Status) :-
    gdpr_arts33_34_breach_notification_profile_for(Subject, Request),
    breach_notification_verdict_status(Request, Status).

test(the_near_miss_verdict_is_a_real_verdict_atom) :-
    breach_notification_verdict_status_values(StatusValues),
    member(ineligible, StatusValues),
    member(eligible, StatusValues).
test(at_72_hours_it_is_eligible) :-
    subject_status(timely_notification_eligible, eligible).
test(at_73_hours_without_reasons_the_reasons_are_not_met) :-
    subject_status(one_hour_late_without_reasons, notification_requirement_not_met(reasons_for_delay)).
test(an_unduly_delayed_notification_is_not_met) :-
    subject_status(inside_period_unduly_delayed, notification_requirement_not_met(without_undue_delay)).
test(an_unlikely_risk_is_ineligible) :-
    subject_status(unlikely_risk_ineligible, ineligible).
test(a_risk_not_unlikely_with_justified_reasons_is_eligible) :-
    subject_status(risk_not_unlikely_control, eligible).
test(late_with_justified_reasons_is_eligible) :-
    subject_status(late_with_justified_reasons_eligible, eligible).
test(late_with_unjustified_reasons_refers) :-
    subject_status(late_with_unjustified_reasons_referral, needs_legal_review(open_textured(delay_justified_by_reasons, cite(eu_reg_2016_679_art_33_1)), _)).
test(a_missing_risk_judgement_is_indeterminate) :-
    subject_status(risk_judgement_missing, indeterminate([breach_unlikely_to_result_in_risk])).
test(a_stated_risk_judgement_is_eligible) :-
    subject_status(risk_judgement_stated_control, eligible).
test(an_unsure_risk_judgement_refers) :-
    subject_status(unsure_risk_referral, needs_legal_review(open_textured(breach_unlikely_to_result_in_risk, cite(eu_reg_2016_679_art_33_1)), [inputs_relied_on([breach_unlikely_to_result_in_risk - unsure])])).
test(contradictory_risk_inputs_are_refused) :-
    subject_status(contradictory_risk_inputs, input_problems([contradictory_inputs([breach_unlikely_to_result_in_risk, breach_likely_to_result_in_high_risk])])).
test(an_unsure_high_risk_beside_an_unlikely_risk_is_ineligible) :-
    subject_status(consistent_risk_inputs_control, ineligible).
test(minus_one_hour_is_refused) :-
    subject_status(negative_hours_input_problem, input_problems([wrong_type(hours_elapsed)])).
test(zero_hours_is_eligible) :-
    subject_status(zero_hours_eligible, eligible).
test(the_processor_notifies_the_controller) :-
    notification_obligation([attribute(party_role, processor)], [notify_controller(cite(eu_reg_2016_679_art_33_2))]).
test(the_controller_notifies_the_authority_on_its_requirement) :-
    notification_obligation([attribute(party_role, controller), attribute(breach_unlikely_to_result_in_risk, false), attribute(supervisory_authority_decision_on_communication, required_communication)], [notify_supervisory_authority(cite(eu_reg_2016_679_art_33_1)), document_breach(cite(eu_reg_2016_679_art_33_5)), communicate_to_data_subject(cite(eu_reg_2016_679_art_34_4))]).
test(an_unlikely_risk_only_documents) :-
    notification_obligation([attribute(party_role, controller), attribute(breach_unlikely_to_result_in_risk, true), attribute(supervisory_authority_decision_on_communication, no_decision)], [no_notification_required(cite(eu_reg_2016_679_art_33_1)), document_breach(cite(eu_reg_2016_679_art_33_5))]).
test(a_risk_without_high_risk_notifies_and_documents) :-
    notification_obligation([attribute(party_role, controller), attribute(breach_unlikely_to_result_in_risk, false), attribute(breach_likely_to_result_in_high_risk, false), attribute(supervisory_authority_decision_on_communication, no_decision)], [notify_supervisory_authority(cite(eu_reg_2016_679_art_33_1)), document_breach(cite(eu_reg_2016_679_art_33_5))]).
test(point_a_exempts_the_communication) :-
    notification_obligation([attribute(party_role, controller), attribute(breach_unlikely_to_result_in_risk, false), attribute(breach_likely_to_result_in_high_risk, true), attribute(supervisory_authority_decision_on_communication, no_decision), attribute(appropriate_protection_measures_applied_to_affected_data, true)], [notify_supervisory_authority(cite(eu_reg_2016_679_art_33_1)), document_breach(cite(eu_reg_2016_679_art_33_5)), no_communication_required(cite(eu_reg_2016_679_art_34_3_a))]).
test(without_any_exemption_the_data_subject_is_told) :-
    notification_obligation([attribute(party_role, controller), attribute(breach_unlikely_to_result_in_risk, false), attribute(breach_likely_to_result_in_high_risk, true), attribute(supervisory_authority_decision_on_communication, no_decision), attribute(appropriate_protection_measures_applied_to_affected_data, false), attribute(subsequent_measures_ensure_high_risk_no_longer_likely, false), attribute(communication_would_involve_disproportionate_effort, false)], [_, _, communicate_to_data_subject(cite(eu_reg_2016_679_art_34_1))]).
test(the_authority_decision_on_point_c_calls_for_a_public_communication) :-
    notification_obligation([attribute(party_role, controller), attribute(breach_unlikely_to_result_in_risk, false), attribute(supervisory_authority_decision_on_communication, decided_point_c_condition_met)], [notify_supervisory_authority(cite(eu_reg_2016_679_art_33_1)), document_breach(cite(eu_reg_2016_679_art_33_5)), public_communication_or_similar_measure(cite(eu_reg_2016_679_art_34_4))]).
test(a_missing_role_is_indeterminate) :-
    notification_obligation([], indeterminate([party_role])).
test(the_period_ends_an_hour_after_the_hour_of_awareness) :-
    authority_notification_period_end(date(2025, 10, 31), 10, period_end(date(2025, 11, 3), 11)).
test(missing_information_may_follow_in_phases) :-
    authority_notification_content_check([attribute(notification_describes_nature_of_breach, false), attribute(notification_gives_categories_and_approximate_numbers, true), attribute(notification_gives_contact_point, true), attribute(notification_describes_likely_consequences, true), attribute(notification_describes_measures_taken_or_proposed, true), attribute(notification_describes_mitigation_measures, true), attribute(information_not_possible_to_provide_at_the_same_time, true)], information_to_follow_in_phases([nature_of_breach])).
test(without_phases_the_requirement_is_not_met) :-
    authority_notification_content_check([attribute(notification_describes_nature_of_breach, false), attribute(notification_gives_categories_and_approximate_numbers, true), attribute(notification_gives_contact_point, true), attribute(notification_describes_likely_consequences, true), attribute(notification_describes_measures_taken_or_proposed, true), attribute(notification_describes_mitigation_measures, true), attribute(information_not_possible_to_provide_at_the_same_time, false)], requirements_not_met([nature_of_breach])).
test(a_categories_item_that_was_not_possible_is_not_missing) :-
    authority_notification_content_check([attribute(notification_describes_nature_of_breach, true), attribute(notification_gives_categories_and_approximate_numbers, false), attribute(categories_and_approximate_numbers_possible, false), attribute(notification_gives_contact_point, true), attribute(notification_describes_likely_consequences, true), attribute(notification_describes_measures_taken_or_proposed, true), attribute(notification_describes_mitigation_measures, true)], all_requirements_met).
test(a_possible_categories_item_is_missing) :-
    authority_notification_content_check([attribute(notification_describes_nature_of_breach, true), attribute(notification_gives_categories_and_approximate_numbers, false), attribute(categories_and_approximate_numbers_possible, true), attribute(notification_gives_contact_point, true), attribute(notification_describes_likely_consequences, true), attribute(notification_describes_measures_taken_or_proposed, true), attribute(notification_describes_mitigation_measures, true), attribute(information_not_possible_to_provide_at_the_same_time, false)], requirements_not_met([categories_and_approximate_numbers])).
test(a_late_communication_is_not_met) :-
    data_subject_communication_check([attribute(communication_made_without_undue_delay, false), attribute(communication_describes_nature_in_clear_and_plain_language, true), attribute(communication_gives_contact_point, true), attribute(communication_describes_likely_consequences, true), attribute(communication_describes_measures_taken_or_proposed, true), attribute(communication_describes_mitigation_measures, true)], requirements_not_met([without_undue_delay])).
test(a_prompt_complete_communication_meets_every_requirement) :-
    data_subject_communication_check([attribute(communication_made_without_undue_delay, true), attribute(communication_describes_nature_in_clear_and_plain_language, true), attribute(communication_gives_contact_point, true), attribute(communication_describes_likely_consequences, true), attribute(communication_describes_measures_taken_or_proposed, true), attribute(communication_describes_mitigation_measures, true)], all_requirements_met).

test(at_73_hours_without_reasons_it_is_not_eligible, fail) :-
    subject_status(one_hour_late_without_reasons, eligible).
test(a_prompt_notification_is_not_unduly_delayed, fail) :-
    subject_status(timely_notification_eligible, notification_requirement_not_met(without_undue_delay)).
test(a_risk_not_unlikely_is_not_ineligible, fail) :-
    subject_status(risk_not_unlikely_control, ineligible).
test(late_with_unjustified_reasons_is_not_eligible, fail) :-
    subject_status(late_with_unjustified_reasons_referral, eligible).
test(late_with_unjustified_reasons_is_never_ineligible, fail) :-
    subject_status(late_with_unjustified_reasons_referral, ineligible).
test(a_stated_risk_judgement_is_not_indeterminate, fail) :-
    subject_status(risk_judgement_stated_control, indeterminate(_)).
test(an_unsure_risk_judgement_is_not_eligible, fail) :-
    subject_status(unsure_risk_referral, eligible).
test(an_unsure_high_risk_is_not_refused, fail) :-
    subject_status(consistent_risk_inputs_control, input_problems(_)).
test(zero_hours_is_not_refused, fail) :-
    subject_status(zero_hours_eligible, input_problems(_)).
test(the_controller_does_not_notify_the_controller, fail) :-
    notification_obligation([attribute(party_role, controller), attribute(breach_unlikely_to_result_in_risk, false), attribute(supervisory_authority_decision_on_communication, required_communication)], [notify_controller(_)]).
test(a_risk_without_high_risk_is_not_exempt_from_notification, fail) :-
    notification_obligation([attribute(party_role, controller), attribute(breach_unlikely_to_result_in_risk, false), attribute(breach_likely_to_result_in_high_risk, false), attribute(supervisory_authority_decision_on_communication, no_decision)], [no_notification_required(_)|_]).
test(without_point_a_the_communication_is_not_exempt, fail) :-
    notification_obligation([attribute(party_role, controller), attribute(breach_unlikely_to_result_in_risk, false), attribute(breach_likely_to_result_in_high_risk, true), attribute(supervisory_authority_decision_on_communication, no_decision), attribute(appropriate_protection_measures_applied_to_affected_data, false), attribute(subsequent_measures_ensure_high_risk_no_longer_likely, false), attribute(communication_would_involve_disproportionate_effort, false)], [_, _, no_communication_required(_)]).
test(no_decision_with_no_high_risk_calls_for_no_public_communication, fail) :-
    notification_obligation([attribute(party_role, controller), attribute(breach_unlikely_to_result_in_risk, false), attribute(breach_likely_to_result_in_high_risk, false), attribute(supervisory_authority_decision_on_communication, no_decision)], [_, _, public_communication_or_similar_measure(_)]).
test(a_stated_role_is_not_indeterminate_on_the_role, fail) :-
    notification_obligation([attribute(party_role, processor)], indeterminate([party_role])).
test(the_period_does_not_end_at_the_hour_of_awareness, fail) :-
    authority_notification_period_end(date(2025, 10, 31), 10, period_end(_, 10)).
test(without_phases_the_missing_information_does_not_follow_in_phases, fail) :-
    authority_notification_content_check([attribute(notification_describes_nature_of_breach, false), attribute(notification_gives_categories_and_approximate_numbers, true), attribute(notification_gives_contact_point, true), attribute(notification_describes_likely_consequences, true), attribute(notification_describes_measures_taken_or_proposed, true), attribute(notification_describes_mitigation_measures, true), attribute(information_not_possible_to_provide_at_the_same_time, false)], information_to_follow_in_phases(_)).
test(a_possible_categories_item_is_not_all_met, fail) :-
    authority_notification_content_check([attribute(notification_describes_nature_of_breach, true), attribute(notification_gives_categories_and_approximate_numbers, false), attribute(categories_and_approximate_numbers_possible, true), attribute(notification_gives_contact_point, true), attribute(notification_describes_likely_consequences, true), attribute(notification_describes_measures_taken_or_proposed, true), attribute(notification_describes_mitigation_measures, true), attribute(information_not_possible_to_provide_at_the_same_time, false)], all_requirements_met).
test(a_prompt_communication_is_not_unmet, fail) :-
    data_subject_communication_check([attribute(communication_made_without_undue_delay, true), attribute(communication_describes_nature_in_clear_and_plain_language, true), attribute(communication_gives_contact_point, true), attribute(communication_describes_likely_consequences, true), attribute(communication_describes_measures_taken_or_proposed, true), attribute(communication_describes_mitigation_measures, true)], requirements_not_met(_)).

cp_test_names([the_near_miss_verdict_is_a_real_verdict_atom, at_72_hours_it_is_eligible, at_73_hours_without_reasons_the_reasons_are_not_met, an_unduly_delayed_notification_is_not_met, an_unlikely_risk_is_ineligible, a_risk_not_unlikely_with_justified_reasons_is_eligible, late_with_justified_reasons_is_eligible, late_with_unjustified_reasons_refers, a_missing_risk_judgement_is_indeterminate, a_stated_risk_judgement_is_eligible, an_unsure_risk_judgement_refers, contradictory_risk_inputs_are_refused, an_unsure_high_risk_beside_an_unlikely_risk_is_ineligible, minus_one_hour_is_refused, zero_hours_is_eligible, the_processor_notifies_the_controller, the_controller_notifies_the_authority_on_its_requirement, an_unlikely_risk_only_documents, a_risk_without_high_risk_notifies_and_documents, point_a_exempts_the_communication, without_any_exemption_the_data_subject_is_told, the_authority_decision_on_point_c_calls_for_a_public_communication, a_missing_role_is_indeterminate, the_period_ends_an_hour_after_the_hour_of_awareness, missing_information_may_follow_in_phases, without_phases_the_requirement_is_not_met, a_categories_item_that_was_not_possible_is_not_missing, a_possible_categories_item_is_missing, a_late_communication_is_not_met, a_prompt_complete_communication_meets_every_requirement]).
cp_test_fail_names([at_73_hours_without_reasons_it_is_not_eligible, a_prompt_notification_is_not_unduly_delayed, a_risk_not_unlikely_is_not_ineligible, late_with_unjustified_reasons_is_not_eligible, late_with_unjustified_reasons_is_never_ineligible, a_stated_risk_judgement_is_not_indeterminate, an_unsure_risk_judgement_is_not_eligible, an_unsure_high_risk_is_not_refused, zero_hours_is_not_refused, the_controller_does_not_notify_the_controller, a_risk_without_high_risk_is_not_exempt_from_notification, without_point_a_the_communication_is_not_exempt, no_decision_with_no_high_risk_calls_for_no_public_communication, a_stated_role_is_not_indeterminate_on_the_role, the_period_does_not_end_at_the_hour_of_awareness, without_phases_the_missing_information_does_not_follow_in_phases, a_possible_categories_item_is_not_all_met, a_prompt_communication_is_not_unmet]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
