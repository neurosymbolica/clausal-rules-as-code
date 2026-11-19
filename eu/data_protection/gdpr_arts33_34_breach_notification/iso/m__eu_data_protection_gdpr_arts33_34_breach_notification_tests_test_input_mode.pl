% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_arts33_34_breach_notification_tests_test_input_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_arts33_34_breach_notification_breach_notification_verdict, [breach_notification_verdict/4, breach_notification_verdict_status/2, notification_obligation/2, authority_notification_deadline/3, authority_notification_period_end/3, authority_notification_content_check/2, data_subject_communication_check/2]).
:- use_module(m__eu_data_protection_gdpr_arts33_34_breach_notification_kernel, [gdpr_arts33_34_breach_notification_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_arts33_34_breach_notification_fixtures, [gdpr_arts33_34_breach_notification_profile_for/2]).

request_of(Subject, Profile, HoursElapsed) :-
    gdpr_arts33_34_breach_notification_profile_for(Subject, breach_notification_request(Profile, HoursElapsed)).

test(eligible_holds_with_the_verdict_bound) :-
    request_of(timely_notification_eligible, Profile, HoursElapsed),
    breach_notification_verdict(Profile, HoursElapsed, eligible, [cite(eu_reg_2016_679_art_33_1)]).
test(ineligible_holds_with_the_verdict_bound) :-
    request_of(unlikely_risk_ineligible, Profile, HoursElapsed),
    breach_notification_verdict(Profile, HoursElapsed, ineligible, [cite(eu_reg_2016_679_art_33_1)]).
test(undue_delay_holds_with_the_verdict_bound) :-
    request_of(timely_notification_unduly_delayed, Profile, HoursElapsed),
    breach_notification_verdict(Profile, HoursElapsed, notification_requirement_not_met(without_undue_delay), [cite(eu_reg_2016_679_art_33_1)]).
test(missing_reasons_hold_with_the_verdict_bound) :-
    request_of(seventy_three_hours_without_reasons, Profile, HoursElapsed),
    breach_notification_verdict(Profile, HoursElapsed, notification_requirement_not_met(reasons_for_delay), [cite(eu_reg_2016_679_art_33_1)]).
test(an_unjustified_delay_referral_holds_bound) :-
    request_of(seventy_three_hours_with_unjustified_reasons, Profile, HoursElapsed),
    breach_notification_verdict(Profile, HoursElapsed, needs_legal_review(open_textured(delay_justified_by_reasons, cite(eu_reg_2016_679_art_33_1)), [inputs_relied_on([hours_elapsed - 73, breach_unlikely_to_result_in_risk - false, delay_justified_by_reasons - false])]), []).
test(a_missing_risk_judgement_holds_bound) :-
    request_of(missing_risk_judgement, Profile, HoursElapsed),
    breach_notification_verdict(Profile, HoursElapsed, indeterminate([breach_unlikely_to_result_in_risk]), []).
test(the_status_projection_holds_bound) :-
    request_of(seventy_two_hours_in_time, Profile, HoursElapsed),
    breach_notification_verdict_status(breach_notification_request(Profile, HoursElapsed), eligible).
test(the_processor_obligation_holds_bound) :-
    request_of(processor_notifies_controller, Profile, _),
    notification_obligation(Profile, [notify_controller(cite(eu_reg_2016_679_art_33_2))]).
test(the_hours_output_is_bound_to_72) :-
    authority_notification_deadline(date(2025, 10, 31), _, 72).
test(a_non_list_profile_is_refused) :-
    breach_notification_verdict(controller, 10, input_problems([wrong_type(profile)]), []).
test(an_integer_profile_is_refused) :-
    breach_notification_verdict(42, 10, Verdict, Citations),
    Verdict == input_problems([wrong_type(profile)]),
    Citations == [].
test(a_list_with_a_bare_key_is_refused) :-
    notification_obligation([attribute(party_role, controller), breach_unlikely_to_result_in_risk], input_problems([wrong_type(profile)])).
test(a_quoted_string_value_is_wrong_type) :-
    breach_notification_verdict([attribute(breach_unlikely_to_result_in_risk, "false")], 10, input_problems([wrong_type(breach_unlikely_to_result_in_risk)]), []).
test(an_integer_value_is_wrong_type) :-
    notification_obligation([attribute(party_role, 7)], Obligation),
    Obligation == input_problems([wrong_type(party_role)]).
test(an_unknown_key_is_refused_by_the_obligation) :-
    notification_obligation([attribute(party_role, processor), attribute(as_of_date, today)], input_problems([unknown_key(as_of_date)])).
test(a_duplicate_key_is_refused_by_the_content_check) :-
    authority_notification_content_check([attribute(notification_gives_contact_point, true), attribute(notification_gives_contact_point, true)], input_problems([duplicate_key(notification_gives_contact_point)])).
test(a_fractional_hour_count_is_wrong_type) :-
    breach_notification_verdict([attribute(breach_unlikely_to_result_in_risk, false)], 72.5, input_problems([wrong_type(hours_elapsed)]), []).
test(an_atom_hour_count_is_wrong_type) :-
    breach_notification_verdict([attribute(breach_unlikely_to_result_in_risk, false)], seventy, input_problems([wrong_type(hours_elapsed)]), []).
test(profile_problems_come_before_argument_problems) :-
    breach_notification_verdict([attribute(party_role, auditor)], -1, input_problems([wrong_type(party_role), wrong_type(hours_elapsed)]), []).
test(a_key_the_verdict_does_not_read_is_still_checked) :-
    breach_notification_verdict([attribute(breach_unlikely_to_result_in_risk, true), attribute(communication_gives_contact_point, unsure)], 10, input_problems([wrong_type(communication_gives_contact_point)]), []).
test(the_reasons_pair_is_refused_by_the_content_check) :-
    authority_notification_content_check([attribute(delay_justified_by_reasons, true), attribute(notification_accompanied_by_reasons_for_delay, false)], input_problems([contradictory_inputs([delay_justified_by_reasons, notification_accompanied_by_reasons_for_delay])])).
test(the_risk_pair_is_refused_by_the_obligation) :-
    notification_obligation([attribute(party_role, controller), attribute(breach_unlikely_to_result_in_risk, true), attribute(breach_likely_to_result_in_high_risk, true)], input_problems([contradictory_inputs([breach_unlikely_to_result_in_risk, breach_likely_to_result_in_high_risk])])).
test(the_risk_pair_is_refused_by_the_communication_check) :-
    data_subject_communication_check([attribute(breach_unlikely_to_result_in_risk, true), attribute(breach_likely_to_result_in_high_risk, true)], input_problems([contradictory_inputs([breach_unlikely_to_result_in_risk, breach_likely_to_result_in_high_risk])])).
test(the_input_check_is_empty_for_a_fixture_profile) :-
    request_of(public_communication_substitute, Profile, _),
    gdpr_arts33_34_breach_notification_input_problems(Profile, []).
test(a_string_awareness_date_is_wrong_type_with_72_hours) :-
    authority_notification_deadline("2025-10-31", input_problems([wrong_type(awareness_date)]), 72).
test(a_non_leap_29_february_is_wrong_type) :-
    authority_notification_deadline(date(2025, 2, 29), input_problems([wrong_type(awareness_date)]), 72).
test(a_thirteenth_month_awareness_date_is_wrong_type) :-
    authority_notification_deadline(date(2025, 13, 1), Deadline, Hours),
    Deadline == input_problems([wrong_type(awareness_date)]),
    Hours == 72.
test(an_hour_of_24_is_wrong_type) :-
    authority_notification_period_end(date(2025, 10, 31), 24, input_problems([wrong_type(awareness_hour)])).
test(a_negative_hour_is_wrong_type) :-
    authority_notification_period_end(date(2025, 10, 31), -1, input_problems([wrong_type(awareness_hour)])).
test(a_string_hour_is_wrong_type) :-
    authority_notification_period_end(date(2025, 10, 31), "10", input_problems([wrong_type(awareness_hour)])).

test(the_eligible_profile_rejects_ineligible, fail) :-
    request_of(timely_notification_eligible, Profile, HoursElapsed),
    breach_notification_verdict(Profile, HoursElapsed, ineligible, _).
test(the_ineligible_profile_rejects_eligible, fail) :-
    request_of(unlikely_risk_ineligible, Profile, HoursElapsed),
    breach_notification_verdict(Profile, HoursElapsed, eligible, _).
test(the_missing_reasons_are_not_the_undue_delay, fail) :-
    request_of(seventy_three_hours_without_reasons, Profile, HoursElapsed),
    breach_notification_verdict(Profile, HoursElapsed, notification_requirement_not_met(without_undue_delay), _).
test(an_unjustified_delay_is_never_ineligible, fail) :-
    request_of(seventy_three_hours_with_unjustified_reasons, Profile, HoursElapsed),
    breach_notification_verdict(Profile, HoursElapsed, ineligible, _).
test(the_bare_atom_indeterminate_is_never_written, fail) :-
    request_of(missing_risk_judgement, Profile, HoursElapsed),
    breach_notification_verdict(Profile, HoursElapsed, indeterminate, _).
test(the_processor_owes_no_documentation_duty, fail) :-
    request_of(processor_notifies_controller, Profile, _),
    notification_obligation(Profile, [_, document_breach(_)|_]).
test(the_hours_output_is_never_48, fail) :-
    authority_notification_deadline(date(2025, 10, 31), _, 48).

cp_test_names([eligible_holds_with_the_verdict_bound, ineligible_holds_with_the_verdict_bound, undue_delay_holds_with_the_verdict_bound, missing_reasons_hold_with_the_verdict_bound, an_unjustified_delay_referral_holds_bound, a_missing_risk_judgement_holds_bound, the_status_projection_holds_bound, the_processor_obligation_holds_bound, the_hours_output_is_bound_to_72, a_non_list_profile_is_refused, an_integer_profile_is_refused, a_list_with_a_bare_key_is_refused, a_quoted_string_value_is_wrong_type, an_integer_value_is_wrong_type, an_unknown_key_is_refused_by_the_obligation, a_duplicate_key_is_refused_by_the_content_check, a_fractional_hour_count_is_wrong_type, an_atom_hour_count_is_wrong_type, profile_problems_come_before_argument_problems, a_key_the_verdict_does_not_read_is_still_checked, the_reasons_pair_is_refused_by_the_content_check, the_risk_pair_is_refused_by_the_obligation, the_risk_pair_is_refused_by_the_communication_check, the_input_check_is_empty_for_a_fixture_profile, a_string_awareness_date_is_wrong_type_with_72_hours, a_non_leap_29_february_is_wrong_type, a_thirteenth_month_awareness_date_is_wrong_type, an_hour_of_24_is_wrong_type, a_negative_hour_is_wrong_type, a_string_hour_is_wrong_type]).
cp_test_fail_names([the_eligible_profile_rejects_ineligible, the_ineligible_profile_rejects_eligible, the_missing_reasons_are_not_the_undue_delay, an_unjustified_delay_is_never_ineligible, the_bare_atom_indeterminate_is_never_written, the_processor_owes_no_documentation_duty, the_hours_output_is_never_48]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
