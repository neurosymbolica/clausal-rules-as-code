% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_arts33_34_breach_notification_tests_test_input_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_arts33_34_breach_notification_breach_notification_verdict, [breach_notification_verdict/4, breach_notification_verdict_status/2, notification_obligation/2, authority_notification_deadline/3, authority_notification_period_end/3, authority_notification_content_check/2, data_subject_communication_check/2]).
:- use_module(m__eu_data_protection_gdpr_arts33_34_breach_notification_fixtures, [gdpr_arts33_34_breach_notification_profile_for/2]).

test(status_holds_with_the_verdict_bound) :-
    gdpr_arts33_34_breach_notification_profile_for(timely_notification_eligible, Request),
    breach_notification_verdict_status(Request, eligible).
test(the_late_verdict_holds_bound) :-
    gdpr_arts33_34_breach_notification_profile_for(one_hour_late_without_reasons, Request),
    breach_notification_verdict_status(Request, notification_requirement_not_met(reasons_for_delay)).
test(the_ineligible_verdict_holds_bound_with_its_citation) :-
    breach_notification_verdict([attribute(breach_unlikely_to_result_in_risk, true)], 0, ineligible, [cite(eu_reg_2016_679_art_33_1)]).
test(a_bound_obligation_list_holds) :-
    notification_obligation([attribute(party_role, processor)], [notify_controller(cite(eu_reg_2016_679_art_33_2))]).
test(a_bound_deadline_holds) :-
    authority_notification_deadline(date(2025, 10, 31), date(2025, 11, 3), 72).
test(a_profile_that_is_not_a_list_is_refused) :-
    breach_notification_verdict(profile, 10, input_problems([wrong_type(profile)]), []).
test(both_argument_faults_are_named_in_order) :-
    breach_notification_verdict(profile, -1, input_problems([wrong_type(profile), wrong_type(hours_elapsed)]), []).
test(an_element_that_is_not_an_attribute_is_refused) :-
    notification_obligation([attribute(party_role, controller), party_role], input_problems([wrong_type(profile)])).
test(an_unknown_key_is_refused) :-
    notification_obligation([attribute(party_role, processor), attribute(colour, red)], input_problems([unknown_key(colour)])).
test(a_duplicate_key_is_refused) :-
    authority_notification_content_check([attribute(notification_gives_contact_point, true), attribute(notification_gives_contact_point, false)], input_problems([duplicate_key(notification_gives_contact_point)])).
test(an_unsure_crisp_key_is_refused) :-
    data_subject_communication_check([attribute(communication_gives_contact_point, unsure)], input_problems([wrong_type(communication_gives_contact_point)])).
test(an_unknown_enumeration_atom_is_refused) :-
    notification_obligation([attribute(party_role, controller), attribute(supervisory_authority_decision_on_communication, maybe_later)], input_problems([wrong_type(supervisory_authority_decision_on_communication)])).
test(the_contradictory_risk_pair_is_refused_by_the_obligation) :-
    notification_obligation([attribute(party_role, controller), attribute(breach_unlikely_to_result_in_risk, true), attribute(breach_likely_to_result_in_high_risk, true)], input_problems([contradictory_inputs([breach_unlikely_to_result_in_risk, breach_likely_to_result_in_high_risk])])).
test(the_contradictory_reasons_pair_is_refused_by_a_content_check) :-
    data_subject_communication_check([attribute(delay_justified_by_reasons, true), attribute(notification_accompanied_by_reasons_for_delay, false)], input_problems([contradictory_inputs([delay_justified_by_reasons, notification_accompanied_by_reasons_for_delay])])).
test(a_fractional_hour_count_is_refused) :-
    breach_notification_verdict([attribute(breach_unlikely_to_result_in_risk, false)], 1.5, input_problems([wrong_type(hours_elapsed)]), []).
test(an_atom_hour_count_is_refused) :-
    breach_notification_verdict([attribute(breach_unlikely_to_result_in_risk, true)], many, input_problems([wrong_type(hours_elapsed)]), []).
test(the_twenty_ninth_of_february_1900_is_refused) :-
    authority_notification_deadline(date(1900, 2, 29), input_problems([wrong_type(awareness_date)]), 72).
test(the_twenty_ninth_of_february_2000_is_accepted) :-
    authority_notification_deadline(date(2000, 2, 29), date(2000, 3, 3), 72).
test(month_thirteen_is_refused) :-
    authority_notification_deadline(date(2025, 13, 1), input_problems([wrong_type(awareness_date)]), 72).
test(hour_twenty_four_is_refused) :-
    authority_notification_period_end(date(2025, 10, 31), 24, input_problems([wrong_type(awareness_hour)])).
test(a_negative_hour_is_refused) :-
    authority_notification_period_end(date(2025, 10, 31), -1, input_problems([wrong_type(awareness_hour)])).
test(an_atom_hour_is_refused) :-
    authority_notification_period_end(date(2025, 10, 31), ten, input_problems([wrong_type(awareness_hour)])).
test(hour_zero_is_accepted) :-
    authority_notification_period_end(date(2025, 10, 31), 0, period_end(date(2025, 11, 3), 1)).

test(the_wrong_bound_status_is_rejected, fail) :-
    gdpr_arts33_34_breach_notification_profile_for(timely_notification_eligible, Request),
    breach_notification_verdict_status(Request, ineligible).
test(the_late_verdict_is_not_the_undue_delay_verdict, fail) :-
    gdpr_arts33_34_breach_notification_profile_for(one_hour_late_without_reasons, Request),
    breach_notification_verdict_status(Request, notification_requirement_not_met(without_undue_delay)).
test(a_wrong_bound_deadline_is_rejected, fail) :-
    authority_notification_deadline(date(2025, 10, 31), date(2025, 11, 4), 72).

cp_test_names([status_holds_with_the_verdict_bound, the_late_verdict_holds_bound, the_ineligible_verdict_holds_bound_with_its_citation, a_bound_obligation_list_holds, a_bound_deadline_holds, a_profile_that_is_not_a_list_is_refused, both_argument_faults_are_named_in_order, an_element_that_is_not_an_attribute_is_refused, an_unknown_key_is_refused, a_duplicate_key_is_refused, an_unsure_crisp_key_is_refused, an_unknown_enumeration_atom_is_refused, the_contradictory_risk_pair_is_refused_by_the_obligation, the_contradictory_reasons_pair_is_refused_by_a_content_check, a_fractional_hour_count_is_refused, an_atom_hour_count_is_refused, the_twenty_ninth_of_february_1900_is_refused, the_twenty_ninth_of_february_2000_is_accepted, month_thirteen_is_refused, hour_twenty_four_is_refused, a_negative_hour_is_refused, an_atom_hour_is_refused, hour_zero_is_accepted]).
cp_test_fail_names([the_wrong_bound_status_is_rejected, the_late_verdict_is_not_the_undue_delay_verdict, a_wrong_bound_deadline_is_rejected]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
