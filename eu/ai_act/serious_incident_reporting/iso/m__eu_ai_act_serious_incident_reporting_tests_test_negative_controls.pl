% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_ai_act_serious_incident_reporting_tests_test_negative_controls, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_lists_extra, [subtract/3]).
:- use_module(m__eu_ai_act_serious_incident_reporting_serious_incident_reporting, [serious_incident_reporting_status/2, serious_incident_reporting_status_values/1]).
:- use_module(m__eu_ai_act_serious_incident_reporting_fixtures, [serious_incident_reporting_profile_for/2]).

status_of(Subject, Status) :-
    serious_incident_reporting_profile_for(Subject, Case),
    serious_incident_reporting_status(Case, Status).

test(every_atom_used_here_is_a_table_status) :-
    serious_incident_reporting_status_values(StatusValues),
    subtract([not_applicable_on_date, not_a_high_risk_ai_system, not_covered_placed_before_application_date, not_a_serious_incident, not_a_reportable_incident, report_in_time, report_after_time_limit, report_not_immediate], StatusValues, Missing),
    Missing == [].
test(before_the_first_date_is_not_applicable) :-
    status_of(awareness_before_first_application_date, not_applicable_on_date).
test(on_the_first_date_a_report_is_due) :-
    status_of(awareness_on_first_application_date, report_due(_, 10, _, _)).
test(annex_i_before_its_date_is_not_applicable) :-
    status_of(annex_i_awareness_before_application_date, not_applicable_on_date).
test(annex_i_on_its_date_a_report_is_due) :-
    status_of(annex_i_awareness_on_application_date, report_due(_, _, _, _)).
test(a_system_not_high_risk_has_no_duty) :-
    status_of(system_not_high_risk, not_a_high_risk_ai_system).
test(an_absent_classification_is_indeterminate) :-
    status_of(classification_absent, indeterminate([high_risk_classification])).
test(an_early_unchanged_system_is_not_covered) :-
    status_of(placed_early_without_significant_change, not_covered_placed_before_application_date).
test(an_early_changed_system_reports) :-
    status_of(placed_early_with_significant_change, report_due(_, 10, _, _)).
test(a_public_authority_system_the_day_before_is_not_covered) :-
    status_of(public_authority_system_before_compliance_date, not_covered_placed_before_application_date).
test(a_public_authority_system_on_the_day_reports) :-
    status_of(public_authority_system_on_compliance_date, report_due(_, _, _, _)).
test(equivalent_obligations_without_point_c_are_not_reportable) :-
    status_of(equivalent_obligations_without_fundamental_rights, not_a_reportable_incident).
test(equivalent_obligations_with_point_c_report) :-
    status_of(equivalent_obligations_with_fundamental_rights, report_due(market_surveillance_authority_of_member_state_where_incident_occurred, 10, _, _)).
test(a_device_without_point_c_is_not_reportable) :-
    status_of(device_without_fundamental_rights, not_a_reportable_incident).
test(a_device_with_point_c_reports_to_the_national_authority) :-
    status_of(device_with_fundamental_rights, report_due(national_competent_authority_chosen_by_member_state_where_incident_occurred, _, _, _)).
test(a_system_under_the_ai_office_reports_to_it) :-
    status_of(device_under_ai_office, report_due(ai_office, _, _, _)).
test(a_system_not_under_the_ai_office_reports_nationally) :-
    status_of(device_not_under_ai_office, report_due(national_competent_authority_chosen_by_member_state_where_incident_occurred, _, _, _)).
test(no_listed_harm_is_not_a_serious_incident) :-
    status_of(no_listed_harm, not_a_serious_incident).
test(property_harm_reports_in_fifteen_days) :-
    status_of(property_harm_only, report_due(_, 15, _, _)).
test(critical_infrastructure_gives_two_days) :-
    status_of(critical_infrastructure_disrupted_in_leap_year, report_due(_, 2, _, _)).
test(a_death_alone_gives_ten_days) :-
    status_of(death_in_leap_year, report_due(_, 10, _, _)).
test(a_widespread_infringement_gives_two_days) :-
    status_of(widespread_infringement_with_health_harm, report_due(_, 2, _, _)).
test(without_widespread_infringement_it_is_fifteen_days) :-
    status_of(health_harm_without_widespread_infringement, report_due(_, 15, _, _)).
test(a_report_on_the_last_day_is_in_time) :-
    status_of(report_on_last_day_made_immediately, report_in_time).
test(a_report_the_day_after_is_late) :-
    status_of(report_day_after_last_day, report_after_time_limit).
test(a_report_not_made_immediately_is_not_immediate) :-
    status_of(report_in_time_not_immediate, report_not_immediate).
test(an_unsure_immediacy_in_time_is_referred) :-
    status_of(report_immediacy_unsure, needs_legal_review(open_textured(report_made_immediately, _), _)).
test(an_unsure_immediacy_on_a_late_report_is_late) :-
    status_of(late_report_immediacy_unsure, report_after_time_limit).
test(a_day_that_does_not_exist_is_an_input_problem) :-
    status_of(awareness_date_not_a_calendar_day, input_problems([wrong_type(awareness_date)])).
test(a_leap_day_gets_a_report) :-
    status_of(awareness_on_leap_day, report_due(_, 10, _, _)).

test(on_the_first_date_is_not_not_applicable, fail) :-
    status_of(awareness_on_first_application_date, not_applicable_on_date).
test(annex_i_on_its_date_is_not_not_applicable, fail) :-
    status_of(annex_i_awareness_on_application_date, not_applicable_on_date).
test(an_absent_classification_is_not_not_high_risk, fail) :-
    status_of(classification_absent, not_a_high_risk_ai_system).
test(an_early_changed_system_is_not_not_covered, fail) :-
    status_of(placed_early_with_significant_change, not_covered_placed_before_application_date).
test(a_public_authority_system_on_the_day_is_not_not_covered, fail) :-
    status_of(public_authority_system_on_compliance_date, not_covered_placed_before_application_date).
test(equivalent_obligations_with_point_c_are_not_unreportable, fail) :-
    status_of(equivalent_obligations_with_fundamental_rights, not_a_reportable_incident).
test(a_device_with_point_c_is_not_unreportable, fail) :-
    status_of(device_with_fundamental_rights, not_a_reportable_incident).
test(a_system_not_under_the_ai_office_does_not_report_to_it, fail) :-
    status_of(device_not_under_ai_office, report_due(ai_office, _, _, _)).
test(property_harm_is_not_not_serious, fail) :-
    status_of(property_harm_only, not_a_serious_incident).
test(a_death_alone_is_not_two_days, fail) :-
    status_of(death_in_leap_year, report_due(_, 2, _, _)).
test(without_widespread_infringement_it_is_not_two_days, fail) :-
    status_of(health_harm_without_widespread_infringement, report_due(_, 2, _, _)).
test(a_report_the_day_after_is_not_in_time, fail) :-
    status_of(report_day_after_last_day, report_in_time).
test(a_report_made_immediately_is_not_not_immediate, fail) :-
    status_of(report_on_last_day_made_immediately, report_not_immediate).
test(an_unsure_immediacy_on_a_late_report_is_not_referred, fail) :-
    status_of(late_report_immediacy_unsure, needs_legal_review(_, _)).
test(a_leap_day_is_not_an_input_problem, fail) :-
    status_of(awareness_on_leap_day, input_problems(_)).

cp_test_names([every_atom_used_here_is_a_table_status, before_the_first_date_is_not_applicable, on_the_first_date_a_report_is_due, annex_i_before_its_date_is_not_applicable, annex_i_on_its_date_a_report_is_due, a_system_not_high_risk_has_no_duty, an_absent_classification_is_indeterminate, an_early_unchanged_system_is_not_covered, an_early_changed_system_reports, a_public_authority_system_the_day_before_is_not_covered, a_public_authority_system_on_the_day_reports, equivalent_obligations_without_point_c_are_not_reportable, equivalent_obligations_with_point_c_report, a_device_without_point_c_is_not_reportable, a_device_with_point_c_reports_to_the_national_authority, a_system_under_the_ai_office_reports_to_it, a_system_not_under_the_ai_office_reports_nationally, no_listed_harm_is_not_a_serious_incident, property_harm_reports_in_fifteen_days, critical_infrastructure_gives_two_days, a_death_alone_gives_ten_days, a_widespread_infringement_gives_two_days, without_widespread_infringement_it_is_fifteen_days, a_report_on_the_last_day_is_in_time, a_report_the_day_after_is_late, a_report_not_made_immediately_is_not_immediate, an_unsure_immediacy_in_time_is_referred, an_unsure_immediacy_on_a_late_report_is_late, a_day_that_does_not_exist_is_an_input_problem, a_leap_day_gets_a_report]).
cp_test_fail_names([on_the_first_date_is_not_not_applicable, annex_i_on_its_date_is_not_not_applicable, an_absent_classification_is_not_not_high_risk, an_early_changed_system_is_not_not_covered, a_public_authority_system_on_the_day_is_not_not_covered, equivalent_obligations_with_point_c_are_not_unreportable, a_device_with_point_c_is_not_unreportable, a_system_not_under_the_ai_office_does_not_report_to_it, property_harm_is_not_not_serious, a_death_alone_is_not_two_days, without_widespread_infringement_it_is_not_two_days, a_report_the_day_after_is_not_in_time, a_report_made_immediately_is_not_not_immediate, an_unsure_immediacy_on_a_late_report_is_not_referred, a_leap_day_is_not_an_input_problem]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
