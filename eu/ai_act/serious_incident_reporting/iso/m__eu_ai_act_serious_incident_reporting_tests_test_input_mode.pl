% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_ai_act_serious_incident_reporting_tests_test_input_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_ai_act_serious_incident_reporting_kernel, [serious_incident_reporting_input_problems/2]).
:- use_module(m__eu_ai_act_serious_incident_reporting_queries, [serious_incident_report_duty/4, serious_incident_report_timeliness/5]).
:- use_module(m__eu_ai_act_serious_incident_reporting_fixtures, [serious_incident_reporting_profile_for/2, serious_incident_reporting_assess/2]).

follow_up_list([perform_necessary_investigations_without_delay, risk_assessment_of_the_incident, corrective_action, cooperate_with_competent_authorities, inform_authorities_before_altering_the_system]).

test(the_duty_holds_with_the_whole_answer_bound) :-
    serious_incident_reporting_profile_for(on_annex_iii_application_date, Profile),
    follow_up_list(FollowUpDuties),
    serious_incident_report_duty(Profile, date(2027, 12, 2), report_due(market_surveillance_authority_of_member_state_where_incident_occurred, 10, date(2027, 12, 12), FollowUpDuties), [cite(eu_reg_2024_1689_art_73_1), cite(eu_reg_2024_1689_art_73_4), cite(eu_reg_2024_1689_art_73_6)]).
test(the_timeliness_holds_with_the_verdict_bound) :-
    serious_incident_reporting_profile_for(report_on_last_day_made_immediately, Profile),
    serious_incident_report_timeliness(Profile, date(2028, 1, 1), date(2028, 1, 11), report_in_time, [_|_]).
test(the_fixture_answer_holds_bound) :-
    serious_incident_reporting_assess(no_qualifying_harm, serious_incident_reporting_verdict(not_a_serious_incident, [cite(eu_reg_2024_1689_art_3_49)])).
test(an_unbound_profile_is_wrong_type_profile) :-
    findall(Problems, serious_incident_reporting_input_problems(_Profile, Problems), Answers),
    Answers == [[wrong_type(profile)]].
test(a_partial_list_is_wrong_type_profile) :-
    findall(Problems, serious_incident_reporting_input_problems([attribute(high_risk_classification, annex_iii_high_risk)|_Tail], Problems), Answers),
    Answers == [[wrong_type(profile)]].
test(an_element_that_is_not_an_attribute_is_wrong_type_profile) :-
    serious_incident_reporting_input_problems([attribute(high_risk_classification, annex_iii_high_risk), foo], [wrong_type(profile)]).
test(an_unbound_element_is_wrong_type_profile) :-
    findall(Problems, serious_incident_reporting_input_problems([_Element], Problems), Answers),
    Answers == [[wrong_type(profile)]].
test(an_empty_profile_has_no_problem) :-
    serious_incident_reporting_input_problems([], []).
test(a_number_key_is_an_unknown_key) :-
    serious_incident_reporting_input_problems([attribute(42, value)], [unknown_key(42)]).
test(a_compound_key_is_an_unknown_key_as_given) :-
    serious_incident_reporting_input_problems([attribute(colour(red), value)], [unknown_key(colour(red))]).
test(an_unbound_value_is_wrong_type) :-
    findall(Problems, serious_incident_reporting_input_problems([attribute(harm_to_health, _Value)], Problems), Answers),
    Answers == [[wrong_type(harm_to_health)]].
test(a_crisp_key_given_unsure_is_wrong_type) :-
    serious_incident_reporting_input_problems([attribute(medical_device_or_safety_component_of_one, unsure)], [wrong_type(medical_device_or_safety_component_of_one)]).
test(a_judgement_given_unsure_is_well_formed) :-
    serious_incident_reporting_input_problems([attribute(widespread_infringement, unsure)], []).
test(a_duplicate_key_reads_none_of_its_values) :-
    serious_incident_reporting_input_problems([attribute(harm_to_health, death_of_a_person), attribute(harm_to_health, maybe)], [duplicate_key(harm_to_health)]).
test(problems_come_in_contract_order_then_unknown_keys) :-
    serious_incident_reporting_input_problems([attribute(colour, red), attribute(widespread_infringement, maybe), attribute(high_risk_classification, other), attribute(colour, blue)], [wrong_type(high_risk_classification), wrong_type(widespread_infringement), unknown_key(colour)]).
test(a_day_that_does_not_exist_is_wrong_type_awareness_date) :-
    serious_incident_report_duty([], date(2027, 2, 29), input_problems([wrong_type(awareness_date)]), []).
test(a_thirteenth_month_is_wrong_type_awareness_date) :-
    serious_incident_report_duty([], date(2028, 13, 1), input_problems([wrong_type(awareness_date)]), []).
test(profile_problems_come_before_both_date_problems) :-
    serious_incident_report_timeliness([attribute(colour, red)], not_a_date, date(2028, 2, 30), input_problems([unknown_key(colour), wrong_type(awareness_date), wrong_type(report_date)]), []).
test(an_unbound_report_date_is_wrong_type_report_date) :-
    findall(Verdict - Citations, serious_incident_report_timeliness([], date(2028, 1, 1), _ReportDate, Verdict, Citations), Answers),
    Answers == [input_problems([wrong_type(report_date)]) - []].

test(a_wrong_bound_period_is_rejected, fail) :-
    serious_incident_reporting_profile_for(on_annex_iii_application_date, Profile),
    serious_incident_report_duty(Profile, date(2027, 12, 2), report_due(_, 15, _, _), _).
test(a_wrong_bound_last_day_is_rejected, fail) :-
    serious_incident_reporting_profile_for(on_annex_iii_application_date, Profile),
    serious_incident_report_duty(Profile, date(2027, 12, 2), report_due(_, 10, date(2027, 12, 13), _), _).
test(a_wrong_bound_timeliness_verdict_is_rejected, fail) :-
    serious_incident_reporting_profile_for(report_on_last_day_made_immediately, Profile),
    serious_incident_report_timeliness(Profile, date(2028, 1, 1), date(2028, 1, 11), report_after_time_limit, _).
test(the_fixture_answer_rejects_another_status, fail) :-
    serious_incident_reporting_assess(no_qualifying_harm, serious_incident_reporting_verdict(not_a_reportable_incident, _)).
test(a_problem_profile_gets_no_duty, fail) :-
    serious_incident_report_duty([attribute(harm_to_health, maybe)], date(2028, 1, 10), not_a_serious_incident, _).

cp_test_names([the_duty_holds_with_the_whole_answer_bound, the_timeliness_holds_with_the_verdict_bound, the_fixture_answer_holds_bound, an_unbound_profile_is_wrong_type_profile, a_partial_list_is_wrong_type_profile, an_element_that_is_not_an_attribute_is_wrong_type_profile, an_unbound_element_is_wrong_type_profile, an_empty_profile_has_no_problem, a_number_key_is_an_unknown_key, a_compound_key_is_an_unknown_key_as_given, an_unbound_value_is_wrong_type, a_crisp_key_given_unsure_is_wrong_type, a_judgement_given_unsure_is_well_formed, a_duplicate_key_reads_none_of_its_values, problems_come_in_contract_order_then_unknown_keys, a_day_that_does_not_exist_is_wrong_type_awareness_date, a_thirteenth_month_is_wrong_type_awareness_date, profile_problems_come_before_both_date_problems, an_unbound_report_date_is_wrong_type_report_date]).
cp_test_fail_names([a_wrong_bound_period_is_rejected, a_wrong_bound_last_day_is_rejected, a_wrong_bound_timeliness_verdict_is_rejected, the_fixture_answer_rejects_another_status, a_problem_profile_gets_no_duty]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
