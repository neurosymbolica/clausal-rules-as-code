% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_arts33_34_breach_notification_tests_test_queries, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_lists_extra, [last/2]).
:- use_module(m__eu_data_protection_gdpr_arts33_34_breach_notification_queries, [gdpr_arts33_34_breach_notification_profile_keys/1, gdpr_arts33_34_breach_notification_what_if/4]).
:- use_module(m__eu_data_protection_gdpr_arts33_34_breach_notification_kernel, [gdpr_arts33_34_breach_notification_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_arts33_34_breach_notification_fixtures, [gdpr_arts33_34_breach_notification_profile_for/2]).

test(profile_keys_are_the_contract_keys) :-
    gdpr_arts33_34_breach_notification_profile_keys(ProfileKeys),
    ProfileKeys == [breach_unlikely_to_result_in_risk, breach_likely_to_result_in_high_risk, delay_justified_by_reasons, party_role, notification_made_without_undue_delay, notification_accompanied_by_reasons_for_delay, supervisory_authority_decision_on_communication, appropriate_protection_measures_applied_to_affected_data, subsequent_measures_ensure_high_risk_no_longer_likely, communication_would_involve_disproportionate_effort, notification_describes_nature_of_breach, notification_gives_categories_and_approximate_numbers, categories_and_approximate_numbers_possible, notification_gives_contact_point, notification_describes_likely_consequences, notification_describes_measures_taken_or_proposed, notification_describes_mitigation_measures, mitigation_measures_appropriate, information_not_possible_to_provide_at_the_same_time, communication_made_without_undue_delay, communication_describes_nature_in_clear_and_plain_language, communication_gives_contact_point, communication_describes_likely_consequences, communication_describes_measures_taken_or_proposed, communication_describes_mitigation_measures].
test(every_schema_key_is_checked_by_the_input_check) :-
    gdpr_arts33_34_breach_notification_profile_keys(ProfileKeys),
    findall(Problems, (member(Key, ProfileKeys), gdpr_arts33_34_breach_notification_input_problems([attribute(Key, false)], Problems)), AllProblems),
    length(AllProblems, 25).
test(the_re_exported_input_check_names_an_unknown_key) :-
    gdpr_arts33_34_breach_notification_input_problems([attribute(colour, red)], [unknown_key(colour)]).
test(the_re_exported_input_check_accepts_a_well_formed_profile) :-
    gdpr_arts33_34_breach_notification_input_problems([attribute(party_role, controller), attribute(breach_unlikely_to_result_in_risk, unsure)], []).
test(what_if_one_hour_later_needs_the_reasons) :-
    gdpr_arts33_34_breach_notification_profile_for(timely_notification_eligible, Request),
    findall(Status, gdpr_arts33_34_breach_notification_what_if(Request, hours_elapsed, 73, Status), Statuses),
    Statuses == [indeterminate([notification_accompanied_by_reasons_for_delay])].
test(what_if_the_risk_were_unlikely_is_ineligible) :-
    gdpr_arts33_34_breach_notification_profile_for(timely_notification_eligible, Request),
    gdpr_arts33_34_breach_notification_what_if(Request, breach_unlikely_to_result_in_risk, true, ineligible).
test(what_if_the_same_value_keeps_the_verdict) :-
    gdpr_arts33_34_breach_notification_profile_for(inside_period_unduly_delayed, Request),
    gdpr_arts33_34_breach_notification_what_if(Request, notification_made_without_undue_delay, false, notification_requirement_not_met(without_undue_delay)).
test(what_if_reasons_were_given_the_late_notice_needs_their_weight) :-
    gdpr_arts33_34_breach_notification_profile_for(one_hour_late_without_reasons, Request),
    gdpr_arts33_34_breach_notification_what_if(Request, notification_accompanied_by_reasons_for_delay, true, indeterminate([delay_justified_by_reasons])).
test(what_if_adds_a_missing_key) :-
    gdpr_arts33_34_breach_notification_profile_for(risk_judgement_missing, Request),
    gdpr_arts33_34_breach_notification_what_if(Request, breach_unlikely_to_result_in_risk, false, indeterminate([notification_made_without_undue_delay])).
test(what_if_a_mistyped_value_is_refused) :-
    gdpr_arts33_34_breach_notification_profile_for(timely_notification_eligible, Request),
    gdpr_arts33_34_breach_notification_what_if(Request, breach_unlikely_to_result_in_risk, maybe, input_problems([wrong_type(breach_unlikely_to_result_in_risk)])).
test(what_if_a_negative_hour_count_is_refused) :-
    gdpr_arts33_34_breach_notification_profile_for(timely_notification_eligible, Request),
    gdpr_arts33_34_breach_notification_what_if(Request, hours_elapsed, -5, input_problems([wrong_type(hours_elapsed)])).
test(what_if_scan_finds_the_72_hour_flip_point) :-
    gdpr_arts33_34_breach_notification_profile_for(timely_notification_eligible, Request),
    findall(HoursElapsed, (between(60, 90, HoursElapsed), gdpr_arts33_34_breach_notification_what_if(Request, hours_elapsed, HoursElapsed, eligible)), EligibleHours),
    length(EligibleHours, 13),
    last(EligibleHours, 72).

test(no_schema_key_is_unknown_to_the_input_check, fail) :-
    gdpr_arts33_34_breach_notification_profile_keys(ProfileKeys),
    member(Key, ProfileKeys),
    gdpr_arts33_34_breach_notification_input_problems([attribute(Key, false)], Problems),
    member(unknown_key(_), Problems).
test(what_if_after_the_flip_point_is_not_eligible, fail) :-
    gdpr_arts33_34_breach_notification_profile_for(timely_notification_eligible, Request),
    gdpr_arts33_34_breach_notification_what_if(Request, hours_elapsed, 73, eligible).

cp_test_names([profile_keys_are_the_contract_keys, every_schema_key_is_checked_by_the_input_check, the_re_exported_input_check_names_an_unknown_key, the_re_exported_input_check_accepts_a_well_formed_profile, what_if_one_hour_later_needs_the_reasons, what_if_the_risk_were_unlikely_is_ineligible, what_if_the_same_value_keeps_the_verdict, what_if_reasons_were_given_the_late_notice_needs_their_weight, what_if_adds_a_missing_key, what_if_a_mistyped_value_is_refused, what_if_a_negative_hour_count_is_refused, what_if_scan_finds_the_72_hour_flip_point]).
cp_test_fail_names([no_schema_key_is_unknown_to_the_input_check, what_if_after_the_flip_point_is_not_eligible]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
