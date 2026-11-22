% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_arts33_34_breach_notification_tests_test_queries, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_arts33_34_breach_notification_queries, [gdpr_arts33_34_breach_notification_profile_keys/1, gdpr_arts33_34_breach_notification_what_if/4]).
:- use_module(m__eu_data_protection_gdpr_arts33_34_breach_notification_kernel, [gdpr_arts33_34_breach_notification_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_arts33_34_breach_notification_breach_notification_verdict, [breach_notification_verdict/4, notification_obligation/2, authority_notification_deadline/3]).
:- use_module(m__eu_data_protection_gdpr_arts33_34_breach_notification_fixtures, [gdpr_arts33_34_breach_notification_profile_for/2]).

test(profile_keys_are_the_contract_keys) :-
    gdpr_arts33_34_breach_notification_profile_keys(ProfileKeys),
    ProfileKeys == [breach_unlikely_to_result_in_risk, breach_likely_to_result_in_high_risk, delay_justified_by_reasons, party_role, notification_made_without_undue_delay, notification_accompanied_by_reasons_for_delay, supervisory_authority_decision_on_communication, appropriate_protection_measures_applied_to_affected_data, subsequent_measures_ensure_high_risk_no_longer_likely, communication_would_involve_disproportionate_effort, notification_describes_nature_of_breach, notification_gives_categories_and_approximate_numbers, categories_and_approximate_numbers_possible, notification_gives_contact_point, notification_describes_likely_consequences, notification_describes_measures_taken_or_proposed, notification_describes_mitigation_measures, mitigation_measures_appropriate, information_not_possible_to_provide_at_the_same_time, communication_made_without_undue_delay, communication_describes_nature_in_clear_and_plain_language, communication_gives_contact_point, communication_describes_likely_consequences, communication_describes_measures_taken_or_proposed, communication_describes_mitigation_measures].
test(the_reexported_input_check_passes_a_good_profile) :-
    gdpr_arts33_34_breach_notification_input_problems([attribute(party_role, controller)], Problems),
    Problems == [].
test(the_reexported_input_check_refuses_a_non_list) :-
    gdpr_arts33_34_breach_notification_input_problems(profile, Problems),
    Problems == [wrong_type(profile)].
test(what_if_the_hours_cross_the_period_end) :-
    gdpr_arts33_34_breach_notification_profile_for(timely_at_the_period_end, Profile),
    gdpr_arts33_34_breach_notification_what_if(case(Profile, 72), hours_elapsed, 73, Status),
    Status == indeterminate([notification_accompanied_by_reasons_for_delay]).
test(what_if_the_hours_stay_inside_the_period) :-
    gdpr_arts33_34_breach_notification_profile_for(timely_at_the_period_end, Profile),
    gdpr_arts33_34_breach_notification_what_if(case(Profile, 72), hours_elapsed, 0, Status),
    Status == eligible.
test(what_if_the_justification_becomes_unsure) :-
    gdpr_arts33_34_breach_notification_what_if(case([attribute(breach_unlikely_to_result_in_risk, false), attribute(notification_accompanied_by_reasons_for_delay, true), attribute(delay_justified_by_reasons, true)], 100), delay_justified_by_reasons, unsure, Status),
    Status == needs_legal_review(open_textured(delay_justified_by_reasons, cite(eu_reg_2016_679_art_33_1)), [inputs_relied_on([hours_elapsed - 100, breach_unlikely_to_result_in_risk - false, delay_justified_by_reasons - unsure])]).
test(what_if_creates_a_contradiction) :-
    gdpr_arts33_34_breach_notification_what_if(case([attribute(breach_unlikely_to_result_in_risk, false), attribute(notification_accompanied_by_reasons_for_delay, false)], 100), delay_justified_by_reasons, true, Status),
    Status == input_problems([contradictory_inputs([delay_justified_by_reasons, notification_accompanied_by_reasons_for_delay])]).
test(what_if_replaces_a_duplicated_key) :-
    gdpr_arts33_34_breach_notification_what_if(case([attribute(breach_unlikely_to_result_in_risk, false), attribute(breach_unlikely_to_result_in_risk, true)], 10), breach_unlikely_to_result_in_risk, true, Status),
    Status == ineligible.
test(what_if_has_one_answer_per_override) :-
    findall(Status, gdpr_arts33_34_breach_notification_what_if(case([attribute(breach_unlikely_to_result_in_risk, false)], 10), hours_elapsed, 20, Status), Statuses),
    Statuses == [indeterminate([notification_made_without_undue_delay])].
test(query_type_2_eligibility_answers) :-
    breach_notification_verdict([attribute(breach_unlikely_to_result_in_risk, true)], 10, Verdict, Citations),
    Verdict == ineligible,
    Citations == [cite(eu_reg_2016_679_art_33_1)].
test(query_type_14_obligation_answers) :-
    notification_obligation([attribute(party_role, processor)], Obligation),
    Obligation == [notify_controller(cite(eu_reg_2016_679_art_33_2))].
test(query_type_15_deadline_answers) :-
    authority_notification_deadline(date(2025, 10, 31), Deadline, Hours),
    Deadline = date(2025, 11, 3),
    Hours == 72.

cp_test_names([profile_keys_are_the_contract_keys, the_reexported_input_check_passes_a_good_profile, the_reexported_input_check_refuses_a_non_list, what_if_the_hours_cross_the_period_end, what_if_the_hours_stay_inside_the_period, what_if_the_justification_becomes_unsure, what_if_creates_a_contradiction, what_if_replaces_a_duplicated_key, what_if_has_one_answer_per_override, query_type_2_eligibility_answers, query_type_14_obligation_answers, query_type_15_deadline_answers]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
