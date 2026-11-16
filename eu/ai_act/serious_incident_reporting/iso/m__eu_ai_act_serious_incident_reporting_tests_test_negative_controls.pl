% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_ai_act_serious_incident_reporting_tests_test_negative_controls, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_ai_act_serious_incident_reporting_serious_incident_reporting, [serious_incident_reporting_status_values/1]).
:- use_module(m__eu_ai_act_serious_incident_reporting_fixtures, [serious_incident_reporting_assess/2]).

answer_status(Subject, Status) :-
    serious_incident_reporting_assess(Subject, serious_incident_reporting_verdict(Status, _)).

real_status_atom(Status) :-
    serious_incident_reporting_status_values(StatusValues),
    member(Status, StatusValues).

test(the_near_miss_atoms_are_real_answer_atoms) :-
    real_status_atom(not_applicable_on_date),
    real_status_atom(not_a_high_risk_ai_system),
    real_status_atom(not_covered_placed_before_application_date),
    real_status_atom(not_a_serious_incident),
    real_status_atom(not_a_reportable_incident),
    real_status_atom(report_in_time),
    real_status_atom(report_after_time_limit),
    real_status_atom(report_not_immediate).
test(before_the_annex_iii_date_is_not_applicable) :-
    answer_status(before_annex_iii_application_date, not_applicable_on_date).
test(on_the_annex_iii_date_a_report_is_due) :-
    answer_status(on_annex_iii_application_date, report_due(_, 10, _, _)).
test(annex_i_before_its_date_is_not_applicable) :-
    answer_status(annex_i_before_application_date, not_applicable_on_date).
test(annex_i_on_its_date_a_report_is_due) :-
    answer_status(annex_i_on_application_date, report_due(_, 2, _, _)).
test(a_system_not_high_risk_has_no_duty) :-
    answer_status(not_high_risk_system, not_a_high_risk_ai_system).
test(a_missing_classification_is_indeterminate) :-
    answer_status(classification_missing, indeterminate([high_risk_classification])).
test(an_early_unchanged_system_is_not_covered) :-
    answer_status(early_unchanged_public_day_before_2030, not_covered_placed_before_application_date).
test(no_qualifying_harm_is_not_serious) :-
    answer_status(no_qualifying_harm, not_a_serious_incident).
test(harm_to_property_gets_a_report) :-
    answer_status(harm_to_property, report_due(_, 15, _, _)).
test(a_device_without_point_c_is_not_reportable) :-
    answer_status(device_without_point_c, not_a_reportable_incident).
test(a_device_report_goes_to_the_national_authority) :-
    answer_status(device_with_point_c, report_due(national_competent_authority_chosen_by_member_state_where_incident_occurred, _, _, _)).
test(equivalent_obligations_without_point_c_are_not_reportable) :-
    answer_status(equivalent_obligations_without_point_c, not_a_reportable_incident).
test(a_death_gives_ten_days) :-
    answer_status(on_annex_iii_application_date, report_due(_, 10, date(2027, 12, 12), _)).
test(a_report_on_the_last_day_is_in_time) :-
    answer_status(report_on_last_day_made_immediately, report_in_time).
test(a_report_the_day_after_is_late) :-
    answer_status(report_day_after_last_day, report_after_time_limit).
test(a_report_not_made_immediately_is_not_immediate) :-
    answer_status(report_on_last_day_not_immediate, report_not_immediate).
test(an_unsure_change_on_an_early_system_goes_to_a_lawyer) :-
    answer_status(significant_change_unsure_placed_early, needs_legal_review(open_textured(significant_change_in_design_since_that_date, _), _)).
test(an_unsure_change_on_a_late_system_is_settled) :-
    answer_status(significant_change_unsure_placed_late, report_due(_, 10, _, _)).
test(an_unsure_widespread_infringement_that_turns_the_limit_goes_to_a_lawyer) :-
    answer_status(widespread_unsure_turns_the_limit, needs_legal_review(open_textured(widespread_infringement, cite(eu_reg_2024_1689_art_3_61)), _)).
test(an_unsure_widespread_infringement_beside_critical_infrastructure_gives_two_days) :-
    answer_status(widespread_unsure_with_critical_infrastructure, report_due(_, 2, _, _)).
test(a_missing_fact_beside_an_unsure_judgement_is_named) :-
    answer_status(widespread_unsure_health_missing, indeterminate([harm_to_health])).
test(an_unsure_equivalence_without_point_c_goes_to_a_lawyer) :-
    answer_status(equivalence_unsure_without_point_c, needs_legal_review(open_textured(provider_subject_to_equivalent_union_reporting_obligations, _), _)).
test(a_late_report_with_unsure_immediacy_is_late) :-
    answer_status(late_report_immediacy_unsure, report_after_time_limit).
test(a_crisp_key_given_unsure_is_an_input_problem) :-
    answer_status(crisp_key_given_unsure, input_problems([wrong_type(critical_infrastructure_disruption)])).
test(a_duplicate_key_is_an_input_problem) :-
    answer_status(duplicate_classification, input_problems([duplicate_key(high_risk_classification)])).
test(an_unknown_key_is_an_input_problem) :-
    answer_status(unknown_key_present, input_problems([unknown_key(colour)])).

test(on_the_annex_iii_date_is_not_not_applicable, fail) :-
    answer_status(on_annex_iii_application_date, not_applicable_on_date).
test(annex_i_on_its_date_is_not_not_applicable, fail) :-
    answer_status(annex_i_on_application_date, not_applicable_on_date).
test(a_missing_classification_is_not_not_high_risk, fail) :-
    answer_status(classification_missing, not_a_high_risk_ai_system).
test(an_early_public_system_on_2_august_2030_is_covered, fail) :-
    answer_status(early_unchanged_public_on_2030, not_covered_placed_before_application_date).
test(an_early_changed_system_is_covered, fail) :-
    answer_status(early_significantly_changed, not_covered_placed_before_application_date).
test(harm_to_property_is_serious, fail) :-
    answer_status(harm_to_property, not_a_serious_incident).
test(a_device_with_point_c_is_reportable, fail) :-
    answer_status(device_with_point_c, not_a_reportable_incident).
test(a_device_report_does_not_go_to_market_surveillance, fail) :-
    answer_status(device_with_point_c, report_due(market_surveillance_authority_of_member_state_where_incident_occurred, _, _, _)).
test(equivalent_obligations_with_point_c_are_reportable, fail) :-
    answer_status(equivalent_obligations_with_point_c, not_a_reportable_incident).
test(a_death_does_not_give_fifteen_days, fail) :-
    answer_status(on_annex_iii_application_date, report_due(_, 15, _, _)).
test(serious_harm_without_death_does_not_give_ten_days, fail) :-
    answer_status(year_crossing_general_limit, report_due(_, 10, _, _)).
test(critical_infrastructure_does_not_give_fifteen_days, fail) :-
    answer_status(leap_day_critical_infrastructure, report_due(_, 15, _, _)).
test(a_report_the_day_after_is_not_in_time, fail) :-
    answer_status(report_day_after_last_day, report_in_time).
test(a_report_on_the_last_day_is_not_late, fail) :-
    answer_status(report_on_last_day_made_immediately, report_after_time_limit).
test(a_report_not_made_immediately_is_not_in_time, fail) :-
    answer_status(report_on_last_day_not_immediate, report_in_time).
test(an_unsure_change_on_a_late_system_does_not_go_to_a_lawyer, fail) :-
    answer_status(significant_change_unsure_placed_late, needs_legal_review(_, _)).
test(an_unsure_widespread_infringement_beside_critical_infrastructure_is_settled, fail) :-
    answer_status(widespread_unsure_with_critical_infrastructure, needs_legal_review(_, _)).
test(a_missing_fact_beside_an_unsure_judgement_is_not_referred, fail) :-
    answer_status(widespread_unsure_health_missing, needs_legal_review(_, _)).
test(an_unsure_equivalence_with_point_c_is_not_referred, fail) :-
    answer_status(equivalence_unsure_with_point_c, needs_legal_review(_, _)).
test(a_late_report_with_unsure_immediacy_is_not_referred, fail) :-
    answer_status(late_report_immediacy_unsure, needs_legal_review(_, _)).
test(a_real_leap_day_is_not_an_input_problem, fail) :-
    answer_status(awareness_on_leap_day, input_problems(_)).
test(an_unknown_key_profile_is_not_decided, fail) :-
    answer_status(unknown_key_present, not_a_high_risk_ai_system).

cp_test_names([the_near_miss_atoms_are_real_answer_atoms, before_the_annex_iii_date_is_not_applicable, on_the_annex_iii_date_a_report_is_due, annex_i_before_its_date_is_not_applicable, annex_i_on_its_date_a_report_is_due, a_system_not_high_risk_has_no_duty, a_missing_classification_is_indeterminate, an_early_unchanged_system_is_not_covered, no_qualifying_harm_is_not_serious, harm_to_property_gets_a_report, a_device_without_point_c_is_not_reportable, a_device_report_goes_to_the_national_authority, equivalent_obligations_without_point_c_are_not_reportable, a_death_gives_ten_days, a_report_on_the_last_day_is_in_time, a_report_the_day_after_is_late, a_report_not_made_immediately_is_not_immediate, an_unsure_change_on_an_early_system_goes_to_a_lawyer, an_unsure_change_on_a_late_system_is_settled, an_unsure_widespread_infringement_that_turns_the_limit_goes_to_a_lawyer, an_unsure_widespread_infringement_beside_critical_infrastructure_gives_two_days, a_missing_fact_beside_an_unsure_judgement_is_named, an_unsure_equivalence_without_point_c_goes_to_a_lawyer, a_late_report_with_unsure_immediacy_is_late, a_crisp_key_given_unsure_is_an_input_problem, a_duplicate_key_is_an_input_problem, an_unknown_key_is_an_input_problem]).
cp_test_fail_names([on_the_annex_iii_date_is_not_not_applicable, annex_i_on_its_date_is_not_not_applicable, a_missing_classification_is_not_not_high_risk, an_early_public_system_on_2_august_2030_is_covered, an_early_changed_system_is_covered, harm_to_property_is_serious, a_device_with_point_c_is_reportable, a_device_report_does_not_go_to_market_surveillance, equivalent_obligations_with_point_c_are_reportable, a_death_does_not_give_fifteen_days, serious_harm_without_death_does_not_give_ten_days, critical_infrastructure_does_not_give_fifteen_days, a_report_the_day_after_is_not_in_time, a_report_on_the_last_day_is_not_late, a_report_not_made_immediately_is_not_in_time, an_unsure_change_on_a_late_system_does_not_go_to_a_lawyer, an_unsure_widespread_infringement_beside_critical_infrastructure_is_settled, a_missing_fact_beside_an_unsure_judgement_is_not_referred, an_unsure_equivalence_with_point_c_is_not_referred, a_late_report_with_unsure_immediacy_is_not_referred, a_real_leap_day_is_not_an_input_problem, an_unknown_key_profile_is_not_decided]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
