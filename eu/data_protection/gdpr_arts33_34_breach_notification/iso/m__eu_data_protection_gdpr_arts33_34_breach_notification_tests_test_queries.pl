% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_arts33_34_breach_notification_tests_test_queries, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_arts33_34_breach_notification_queries, [gdpr_arts33_34_breach_notification_profile_keys/1, gdpr_arts33_34_breach_notification_what_if/4]).
:- use_module(m__eu_data_protection_gdpr_arts33_34_breach_notification_kernel, [gdpr_arts33_34_breach_notification_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_arts33_34_breach_notification_breach_notification_verdict, [breach_notification_verdict/4, breach_notification_verdict_checklist/2, notification_obligation/2, authority_notification_deadline/3, authority_notification_period_end/3]).

boundary_request(HoursElapsed, breach_notification_request([attribute(breach_unlikely_to_result_in_risk, false), attribute(notification_made_without_undue_delay, true), attribute(notification_accompanied_by_reasons_for_delay, false)], HoursElapsed)).

test(profile_keys_are_the_contract_keys) :-
    gdpr_arts33_34_breach_notification_profile_keys(ProfileKeys),
    ProfileKeys == [breach_unlikely_to_result_in_risk, breach_likely_to_result_in_high_risk, delay_justified_by_reasons, party_role, notification_made_without_undue_delay, notification_accompanied_by_reasons_for_delay, supervisory_authority_decision_on_communication, appropriate_protection_measures_applied_to_affected_data, subsequent_measures_ensure_high_risk_no_longer_likely, communication_would_involve_disproportionate_effort, notification_describes_nature_of_breach, notification_gives_categories_and_approximate_numbers, categories_and_approximate_numbers_possible, notification_gives_contact_point, notification_describes_likely_consequences, notification_describes_measures_taken_or_proposed, notification_describes_mitigation_measures, mitigation_measures_appropriate, information_not_possible_to_provide_at_the_same_time, communication_made_without_undue_delay, communication_describes_nature_in_clear_and_plain_language, communication_gives_contact_point, communication_describes_likely_consequences, communication_describes_measures_taken_or_proposed, communication_describes_mitigation_measures].
test(the_reexported_input_check_finds_an_unknown_key) :-
    gdpr_arts33_34_breach_notification_input_problems([attribute(as_of_date, today)], [unknown_key(as_of_date)]).
test(the_reexported_input_check_has_one_answer) :-
    findall(Problems, gdpr_arts33_34_breach_notification_input_problems([attribute(party_role, controller)], Problems), Answers),
    Answers == [[]].
test(what_if_one_hour_later_flips_to_missing_reasons) :-
    boundary_request(72, Request),
    gdpr_arts33_34_breach_notification_what_if(Request, hours_elapsed, 73, Status),
    Status == notification_requirement_not_met(reasons_for_delay).
test(what_if_the_72nd_hour_stays_eligible) :-
    boundary_request(10, Request),
    gdpr_arts33_34_breach_notification_what_if(Request, hours_elapsed, 72, Status),
    Status == eligible.
test(what_if_reasons_were_given_reads_the_justification) :-
    boundary_request(73, Request),
    gdpr_arts33_34_breach_notification_what_if(Request, notification_accompanied_by_reasons_for_delay, true, Status),
    Status == indeterminate([delay_justified_by_reasons]).
test(what_if_an_absent_key_is_added) :-
    gdpr_arts33_34_breach_notification_what_if(breach_notification_request([attribute(notification_made_without_undue_delay, true)], 10), breach_unlikely_to_result_in_risk, true, Status),
    Status == ineligible.
test(what_if_party_role_does_not_change_the_verdict) :-
    boundary_request(10, Request),
    gdpr_arts33_34_breach_notification_what_if(Request, party_role, processor, Status),
    Status == eligible.
test(what_if_a_contradictory_value_is_refused) :-
    gdpr_arts33_34_breach_notification_what_if(breach_notification_request([attribute(breach_unlikely_to_result_in_risk, false), attribute(breach_likely_to_result_in_high_risk, true)], 10), breach_unlikely_to_result_in_risk, true, Status),
    Status == input_problems([contradictory_inputs([breach_unlikely_to_result_in_risk, breach_likely_to_result_in_high_risk])]).
test(what_if_a_negative_hour_count_is_refused) :-
    boundary_request(10, Request),
    gdpr_arts33_34_breach_notification_what_if(Request, hours_elapsed, -5, Status),
    Status == input_problems([wrong_type(hours_elapsed)]).
test(what_if_has_exactly_one_solution) :-
    boundary_request(72, Request),
    findall(Status, gdpr_arts33_34_breach_notification_what_if(Request, hours_elapsed, 73, Status), Statuses),
    length(Statuses, 1).
test(the_eligibility_verdict_is_one_solution) :-
    boundary_request(72, breach_notification_request(Profile, HoursElapsed)),
    findall(Verdict - Citations, breach_notification_verdict(Profile, HoursElapsed, Verdict, Citations), Answers),
    Answers == [eligible - [cite(eu_reg_2016_679_art_33_1)]].
test(the_checklist_names_the_late_row) :-
    boundary_request(73, Request),
    breach_notification_verdict_checklist(Request, Items),
    Items == [item(notification_duty_arises, met, cite(eu_reg_2016_679_art_33_1)), item(notified_within_the_period, unmet(notified_after_the_period), cite(eu_reg_2016_679_art_33_1)), item(timing_requirement_met, unmet(reasons_for_delay), cite(eu_reg_2016_679_art_33_1))].
test(the_obligation_is_one_list) :-
    findall(Obligation, notification_obligation([attribute(party_role, controller), attribute(breach_unlikely_to_result_in_risk, false), attribute(breach_likely_to_result_in_high_risk, false), attribute(supervisory_authority_decision_on_communication, no_decision)], Obligation), Answers),
    Answers == [[notify_supervisory_authority(cite(eu_reg_2016_679_art_33_1)), document_breach(cite(eu_reg_2016_679_art_33_5))]].
test(the_deadline_crosses_a_year_end) :-
    authority_notification_deadline(date(2025, 12, 30), date(DeadlineYear, DeadlineMonth, DeadlineDay), Hours),
    DeadlineYear == 2026,
    DeadlineMonth == 1,
    DeadlineDay == 2,
    Hours == 72.
test(the_period_end_is_the_next_full_hour) :-
    authority_notification_period_end(date(2032, 2, 26), 10, period_end(date(EndYear, EndMonth, EndDay), EndHour)),
    EndYear == 2032,
    EndMonth == 2,
    EndDay == 29,
    EndHour == 11.

cp_test_names([profile_keys_are_the_contract_keys, the_reexported_input_check_finds_an_unknown_key, the_reexported_input_check_has_one_answer, what_if_one_hour_later_flips_to_missing_reasons, what_if_the_72nd_hour_stays_eligible, what_if_reasons_were_given_reads_the_justification, what_if_an_absent_key_is_added, what_if_party_role_does_not_change_the_verdict, what_if_a_contradictory_value_is_refused, what_if_a_negative_hour_count_is_refused, what_if_has_exactly_one_solution, the_eligibility_verdict_is_one_solution, the_checklist_names_the_late_row, the_obligation_is_one_list, the_deadline_crosses_a_year_end, the_period_end_is_the_next_full_hour]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
