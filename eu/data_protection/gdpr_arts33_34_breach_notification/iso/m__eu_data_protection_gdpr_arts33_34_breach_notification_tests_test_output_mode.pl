% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_arts33_34_breach_notification_tests_test_output_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_arts33_34_breach_notification_breach_notification_verdict, [decide_breach_notification_verdict/2, breach_notification_verdict/4, notification_obligation/2, authority_notification_deadline/3, authority_notification_period_end/3, authority_notification_content_check/2, data_subject_communication_check/2]).
:- use_module(m__eu_data_protection_gdpr_arts33_34_breach_notification_fixtures, [gdpr_arts33_34_breach_notification_profile_for/2]).

request_of(Subject, Profile, HoursElapsed) :-
    gdpr_arts33_34_breach_notification_profile_for(Subject, breach_notification_request(Profile, HoursElapsed)).

verdict_answers(Subject, Answers) :-
    request_of(Subject, Profile, HoursElapsed),
    findall(Verdict - Citations, breach_notification_verdict(Profile, HoursElapsed, Verdict, Citations), Answers).

obligation_answers(Profile, Answers) :-
    findall(Obligation, notification_obligation(Profile, Obligation), Answers).

notification_content_answers(Profile, Answers) :-
    findall(Result, authority_notification_content_check(Profile, Result), Answers).

communication_answers(Profile, Answers) :-
    findall(Result, data_subject_communication_check(Profile, Result), Answers).

test(eligible_inside_the_period) :-
    verdict_answers(timely_notification_eligible, Answers),
    Answers == [eligible - [cite(eu_reg_2016_679_art_33_1)]].
test(unduly_delayed_inside_the_period) :-
    verdict_answers(timely_notification_unduly_delayed, Answers),
    Answers == [notification_requirement_not_met(without_undue_delay) - [cite(eu_reg_2016_679_art_33_1)]].
test(the_72nd_hour_is_in_time) :-
    verdict_answers(seventy_two_hours_in_time, Answers),
    Answers == [eligible - [cite(eu_reg_2016_679_art_33_1)]].
test(the_73rd_hour_without_reasons) :-
    verdict_answers(seventy_three_hours_without_reasons, Answers),
    Answers == [notification_requirement_not_met(reasons_for_delay) - [cite(eu_reg_2016_679_art_33_1)]].
test(the_73rd_hour_with_justified_reasons) :-
    verdict_answers(seventy_three_hours_with_justified_reasons, Answers),
    Answers == [eligible - [cite(eu_reg_2016_679_art_33_1)]].
test(the_73rd_hour_with_unjustified_reasons_refers) :-
    verdict_answers(seventy_three_hours_with_unjustified_reasons, Answers),
    Answers == [needs_legal_review(open_textured(delay_justified_by_reasons, cite(eu_reg_2016_679_art_33_1)), [inputs_relied_on([hours_elapsed - 73, breach_unlikely_to_result_in_risk - false, delay_justified_by_reasons - false])]) - []].
test(unlikely_risk_after_the_period_is_ineligible) :-
    verdict_answers(unlikely_risk_ineligible_after_the_period, Answers),
    Answers == [ineligible - [cite(eu_reg_2016_679_art_33_1)]].
test(an_unsure_risk_refers_on_the_risk) :-
    verdict_answers(unsure_risk_referred, Answers),
    Answers == [needs_legal_review(open_textured(breach_unlikely_to_result_in_risk, cite(eu_reg_2016_679_art_33_1)), [inputs_relied_on([breach_unlikely_to_result_in_risk - unsure])]) - []].
test(an_unsure_risk_names_the_absent_timing_key) :-
    verdict_answers(unsure_risk_missing_undue_delay, Answers),
    Answers == [indeterminate([notification_made_without_undue_delay]) - []].
test(the_contradictory_risk_pair_is_refused) :-
    verdict_answers(contradictory_risk_inputs, Answers),
    Answers == [input_problems([contradictory_inputs([breach_unlikely_to_result_in_risk, breach_likely_to_result_in_high_risk])]) - []].
test(a_negative_count_is_refused) :-
    verdict_answers(negative_hours_elapsed, Answers),
    Answers == [input_problems([wrong_type(hours_elapsed)]) - []].
test(an_unsure_undue_delay_refers_with_the_timing_context) :-
    findall(Verdict - Citations, breach_notification_verdict([attribute(breach_unlikely_to_result_in_risk, false), attribute(notification_made_without_undue_delay, unsure)], 30, Verdict, Citations), Answers),
    Answers == [needs_legal_review(open_textured(notification_made_without_undue_delay, cite(eu_reg_2016_679_art_33_1)), [inputs_relied_on([hours_elapsed - 30, breach_unlikely_to_result_in_risk - false, notification_made_without_undue_delay - unsure])]) - []].
test(an_absent_justification_is_named_after_the_period) :-
    findall(Verdict - Citations, breach_notification_verdict([attribute(breach_unlikely_to_result_in_risk, false), attribute(notification_accompanied_by_reasons_for_delay, true)], 90, Verdict, Citations), Answers),
    Answers == [indeterminate([delay_justified_by_reasons]) - []].
test(an_unsure_risk_without_reasons_refers_on_the_risk) :-
    findall(Verdict - Citations, breach_notification_verdict([attribute(breach_unlikely_to_result_in_risk, unsure), attribute(notification_accompanied_by_reasons_for_delay, false)], 90, Verdict, Citations), Answers),
    Answers == [needs_legal_review(open_textured(breach_unlikely_to_result_in_risk, cite(eu_reg_2016_679_art_33_1)), [inputs_relied_on([breach_unlikely_to_result_in_risk - unsure])]) - []].
test(the_facade_verdict_carries_its_citation) :-
    request_of(timely_notification_eligible, Profile, HoursElapsed),
    findall(Verdict, decide_breach_notification_verdict(breach_notification_request(Profile, HoursElapsed), Verdict), Verdicts),
    Verdicts == [breach_notification_verdict_verdict(eligible, [cite(eu_reg_2016_679_art_33_1)])].
test(the_order_example_is_one_list) :-
    request_of(public_communication_substitute, Profile, _),
    obligation_answers(Profile, Answers),
    Answers == [[notify_supervisory_authority(cite(eu_reg_2016_679_art_33_1)), document_breach(cite(eu_reg_2016_679_art_33_5)), public_communication_or_similar_measure(cite(eu_reg_2016_679_art_34_3_c))]].
test(the_direct_communication_is_owed) :-
    request_of(direct_communication_owed, Profile, _),
    obligation_answers(Profile, Answers),
    Answers == [[notify_supervisory_authority(cite(eu_reg_2016_679_art_33_1)), document_breach(cite(eu_reg_2016_679_art_33_5)), communicate_to_data_subject(cite(eu_reg_2016_679_art_34_1))]].
test(the_authority_requirement_governs) :-
    request_of(authority_required_communication, Profile, _),
    obligation_answers(Profile, Answers),
    Answers == [[no_notification_required(cite(eu_reg_2016_679_art_33_1)), document_breach(cite(eu_reg_2016_679_art_33_5)), communicate_to_data_subject(cite(eu_reg_2016_679_art_34_4))]].
test(no_decision_and_unlikely_risk_lists_no_article_34_term) :-
    request_of(authority_no_decision_unlikely_risk, Profile, _),
    obligation_answers(Profile, Answers),
    Answers == [[no_notification_required(cite(eu_reg_2016_679_art_33_1)), document_breach(cite(eu_reg_2016_679_art_33_5))]].
test(the_processor_list_is_one_duty) :-
    request_of(processor_notifies_controller, Profile, _),
    obligation_answers(Profile, Answers),
    Answers == [[notify_controller(cite(eu_reg_2016_679_art_33_2))]].
test(a_decided_point_a_condition_lists_no_communication) :-
    obligation_answers([attribute(party_role, controller), attribute(breach_unlikely_to_result_in_risk, false), attribute(supervisory_authority_decision_on_communication, decided_point_a_condition_met)], Answers),
    Answers == [[notify_supervisory_authority(cite(eu_reg_2016_679_art_33_1)), document_breach(cite(eu_reg_2016_679_art_33_5)), no_communication_required(cite(eu_reg_2016_679_art_34_4))]].
test(a_decided_point_c_condition_lists_the_public_communication) :-
    obligation_answers([attribute(party_role, controller), attribute(breach_unlikely_to_result_in_risk, false), attribute(supervisory_authority_decision_on_communication, decided_point_c_condition_met)], Answers),
    Answers == [[notify_supervisory_authority(cite(eu_reg_2016_679_art_33_1)), document_breach(cite(eu_reg_2016_679_art_33_5)), public_communication_or_similar_measure(cite(eu_reg_2016_679_art_34_4))]].
test(a_decision_with_an_unsure_risk_refers_on_the_risk) :-
    obligation_answers([attribute(party_role, controller), attribute(breach_unlikely_to_result_in_risk, unsure), attribute(supervisory_authority_decision_on_communication, required_communication)], Answers),
    Answers == [needs_legal_review(open_textured(breach_unlikely_to_result_in_risk, cite(eu_reg_2016_679_art_33_1)), [inputs_relied_on([breach_unlikely_to_result_in_risk - unsure])])].
test(no_high_risk_lists_no_article_34_term) :-
    obligation_answers([attribute(party_role, controller), attribute(breach_unlikely_to_result_in_risk, false), attribute(breach_likely_to_result_in_high_risk, false), attribute(supervisory_authority_decision_on_communication, no_decision)], Answers),
    Answers == [[notify_supervisory_authority(cite(eu_reg_2016_679_art_33_1)), document_breach(cite(eu_reg_2016_679_art_33_5))]].
test(an_unsure_high_risk_refers_with_both_risk_pairs) :-
    obligation_answers([attribute(party_role, controller), attribute(breach_unlikely_to_result_in_risk, false), attribute(breach_likely_to_result_in_high_risk, unsure), attribute(supervisory_authority_decision_on_communication, no_decision), attribute(appropriate_protection_measures_applied_to_affected_data, false), attribute(subsequent_measures_ensure_high_risk_no_longer_likely, false), attribute(communication_would_involve_disproportionate_effort, false)], Answers),
    Answers == [needs_legal_review(open_textured(breach_likely_to_result_in_high_risk, cite(eu_reg_2016_679_art_34_1)), [inputs_relied_on([breach_unlikely_to_result_in_risk - false, breach_likely_to_result_in_high_risk - unsure])])].
test(a_true_point_a_exempts) :-
    obligation_answers([attribute(party_role, controller), attribute(breach_unlikely_to_result_in_risk, false), attribute(breach_likely_to_result_in_high_risk, true), attribute(supervisory_authority_decision_on_communication, no_decision), attribute(appropriate_protection_measures_applied_to_affected_data, true)], Answers),
    Answers == [[notify_supervisory_authority(cite(eu_reg_2016_679_art_33_1)), document_breach(cite(eu_reg_2016_679_art_33_5)), no_communication_required(cite(eu_reg_2016_679_art_34_3_a))]].
test(the_first_absent_exemption_key_is_named_alone) :-
    obligation_answers([attribute(party_role, controller), attribute(breach_unlikely_to_result_in_risk, false), attribute(breach_likely_to_result_in_high_risk, true), attribute(supervisory_authority_decision_on_communication, no_decision)], Answers),
    Answers == [indeterminate([appropriate_protection_measures_applied_to_affected_data])].
test(an_absent_point_b_is_named_beside_an_unsure_point_a) :-
    obligation_answers([attribute(party_role, controller), attribute(breach_unlikely_to_result_in_risk, false), attribute(breach_likely_to_result_in_high_risk, true), attribute(supervisory_authority_decision_on_communication, no_decision), attribute(appropriate_protection_measures_applied_to_affected_data, unsure)], Answers),
    Answers == [indeterminate([subsequent_measures_ensure_high_risk_no_longer_likely])].
test(an_unsure_point_a_refers_with_its_pairs) :-
    obligation_answers([attribute(party_role, controller), attribute(breach_unlikely_to_result_in_risk, false), attribute(breach_likely_to_result_in_high_risk, true), attribute(supervisory_authority_decision_on_communication, no_decision), attribute(appropriate_protection_measures_applied_to_affected_data, unsure), attribute(subsequent_measures_ensure_high_risk_no_longer_likely, false), attribute(communication_would_involve_disproportionate_effort, false)], Answers),
    Answers == [needs_legal_review(open_textured(appropriate_protection_measures_applied_to_affected_data, cite(eu_reg_2016_679_art_34_3_a)), [inputs_relied_on([breach_unlikely_to_result_in_risk - false, breach_likely_to_result_in_high_risk - true, appropriate_protection_measures_applied_to_affected_data - unsure])])].
test(an_absent_authority_decision_is_named) :-
    obligation_answers([attribute(party_role, controller), attribute(breach_unlikely_to_result_in_risk, true)], Answers),
    Answers == [indeterminate([supervisory_authority_decision_on_communication])].
test(the_deadline_is_one_solution_element_wise) :-
    findall(Deadline - Hours, authority_notification_deadline(date(2025, 10, 31), Deadline, Hours), Answers),
    Answers = [date(DeadlineYear, DeadlineMonth, DeadlineDay) - PeriodHours],
    DeadlineYear == 2025,
    DeadlineMonth == 11,
    DeadlineDay == 3,
    PeriodHours == 72.
test(the_period_end_passes_a_leap_day) :-
    findall(PeriodEnd, authority_notification_period_end(date(2032, 2, 27), 10, PeriodEnd), Answers),
    Answers = [period_end(date(EndYear, EndMonth, EndDay), EndHour)],
    EndYear == 2032,
    EndMonth == 3,
    EndDay == 1,
    EndHour == 11.
test(the_period_end_from_hour_zero_ends_at_one) :-
    authority_notification_period_end(date(2026, 1, 1), 0, period_end(date(EndYear, EndMonth, EndDay), EndHour)),
    EndYear == 2026,
    EndMonth == 1,
    EndDay == 4,
    EndHour == 1.
test(an_empty_notification_profile_names_every_key_read) :-
    notification_content_answers([], Answers),
    Answers == [indeterminate([notification_describes_nature_of_breach, notification_gives_categories_and_approximate_numbers, notification_gives_contact_point, notification_describes_likely_consequences, notification_describes_measures_taken_or_proposed, notification_describes_mitigation_measures, information_not_possible_to_provide_at_the_same_time])].
test(two_absent_crisp_keys_also_name_the_phases_key) :-
    notification_content_answers([attribute(notification_gives_categories_and_approximate_numbers, true), attribute(notification_describes_likely_consequences, true), attribute(notification_describes_measures_taken_or_proposed, true), attribute(notification_describes_mitigation_measures, true)], Answers),
    Answers == [indeterminate([notification_describes_nature_of_breach, notification_gives_contact_point, information_not_possible_to_provide_at_the_same_time])].
test(one_absent_crisp_key_is_named_alone) :-
    notification_content_answers([attribute(notification_gives_categories_and_approximate_numbers, true), attribute(notification_gives_contact_point, true), attribute(notification_describes_likely_consequences, true), attribute(notification_describes_measures_taken_or_proposed, true), attribute(notification_describes_mitigation_measures, true)], Answers),
    Answers == [indeterminate([notification_describes_nature_of_breach])].
test(missing_possible_categories_are_not_met) :-
    notification_content_answers([attribute(notification_describes_nature_of_breach, true), attribute(notification_gives_categories_and_approximate_numbers, false), attribute(categories_and_approximate_numbers_possible, true), attribute(notification_gives_contact_point, true), attribute(notification_describes_likely_consequences, true), attribute(notification_describes_measures_taken_or_proposed, true), attribute(notification_describes_mitigation_measures, true), attribute(information_not_possible_to_provide_at_the_same_time, false)], Answers),
    Answers == [requirements_not_met([categories_and_approximate_numbers])].
test(an_inappropriate_mitigation_is_not_missing) :-
    notification_content_answers([attribute(notification_describes_nature_of_breach, true), attribute(notification_gives_categories_and_approximate_numbers, true), attribute(notification_gives_contact_point, true), attribute(notification_describes_likely_consequences, true), attribute(notification_describes_measures_taken_or_proposed, true), attribute(notification_describes_mitigation_measures, false), attribute(mitigation_measures_appropriate, false)], Answers),
    Answers == [all_requirements_met].
test(an_unsure_phases_judgement_refers) :-
    notification_content_answers([attribute(notification_describes_nature_of_breach, false), attribute(notification_gives_categories_and_approximate_numbers, true), attribute(notification_gives_contact_point, true), attribute(notification_describes_likely_consequences, true), attribute(notification_describes_measures_taken_or_proposed, true), attribute(notification_describes_mitigation_measures, true), attribute(information_not_possible_to_provide_at_the_same_time, unsure)], Answers),
    Answers == [needs_legal_review(open_textured(information_not_possible_to_provide_at_the_same_time, cite(eu_reg_2016_679_art_33_4)), [inputs_relied_on([information_not_possible_to_provide_at_the_same_time - unsure])])].
test(an_empty_communication_profile_names_every_key_read) :-
    communication_answers([], Answers),
    Answers == [indeterminate([communication_made_without_undue_delay, communication_describes_nature_in_clear_and_plain_language, communication_gives_contact_point, communication_describes_likely_consequences, communication_describes_measures_taken_or_proposed, communication_describes_mitigation_measures])].
test(an_unsure_plain_language_refers) :-
    communication_answers([attribute(communication_made_without_undue_delay, true), attribute(communication_describes_nature_in_clear_and_plain_language, unsure), attribute(communication_gives_contact_point, true), attribute(communication_describes_likely_consequences, true), attribute(communication_describes_measures_taken_or_proposed, true), attribute(communication_describes_mitigation_measures, true)], Answers),
    Answers == [needs_legal_review(open_textured(communication_describes_nature_in_clear_and_plain_language, cite(eu_reg_2016_679_art_34_2)), [inputs_relied_on([communication_made_without_undue_delay - true, communication_describes_nature_in_clear_and_plain_language - unsure])])].
test(two_missing_communication_items_in_order) :-
    communication_answers([attribute(communication_made_without_undue_delay, true), attribute(communication_describes_nature_in_clear_and_plain_language, true), attribute(communication_gives_contact_point, false), attribute(communication_describes_likely_consequences, false), attribute(communication_describes_measures_taken_or_proposed, true), attribute(communication_describes_mitigation_measures, true)], Answers),
    Answers == [requirements_not_met([contact_point, likely_consequences])].

cp_test_names([eligible_inside_the_period, unduly_delayed_inside_the_period, the_72nd_hour_is_in_time, the_73rd_hour_without_reasons, the_73rd_hour_with_justified_reasons, the_73rd_hour_with_unjustified_reasons_refers, unlikely_risk_after_the_period_is_ineligible, an_unsure_risk_refers_on_the_risk, an_unsure_risk_names_the_absent_timing_key, the_contradictory_risk_pair_is_refused, a_negative_count_is_refused, an_unsure_undue_delay_refers_with_the_timing_context, an_absent_justification_is_named_after_the_period, an_unsure_risk_without_reasons_refers_on_the_risk, the_facade_verdict_carries_its_citation, the_order_example_is_one_list, the_direct_communication_is_owed, the_authority_requirement_governs, no_decision_and_unlikely_risk_lists_no_article_34_term, the_processor_list_is_one_duty, a_decided_point_a_condition_lists_no_communication, a_decided_point_c_condition_lists_the_public_communication, a_decision_with_an_unsure_risk_refers_on_the_risk, no_high_risk_lists_no_article_34_term, an_unsure_high_risk_refers_with_both_risk_pairs, a_true_point_a_exempts, the_first_absent_exemption_key_is_named_alone, an_absent_point_b_is_named_beside_an_unsure_point_a, an_unsure_point_a_refers_with_its_pairs, an_absent_authority_decision_is_named, the_deadline_is_one_solution_element_wise, the_period_end_passes_a_leap_day, the_period_end_from_hour_zero_ends_at_one, an_empty_notification_profile_names_every_key_read, two_absent_crisp_keys_also_name_the_phases_key, one_absent_crisp_key_is_named_alone, missing_possible_categories_are_not_met, an_inappropriate_mitigation_is_not_missing, an_unsure_phases_judgement_refers, an_empty_communication_profile_names_every_key_read, an_unsure_plain_language_refers, two_missing_communication_items_in_order]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
