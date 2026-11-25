% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_ai_act_serious_incident_reporting_tests_test_input_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_ai_act_serious_incident_reporting_serious_incident_reporting, [serious_incident_report_duty/4, serious_incident_report_timeliness/5, serious_incident_reporting_status/2, serious_incident_reporting_status_values/1]).
:- use_module(m__eu_ai_act_serious_incident_reporting_kernel, [serious_incident_reporting_input_problems/2]).
:- use_module(m__eu_ai_act_serious_incident_reporting_fixtures, [serious_incident_reporting_profile_for/2]).

input_base_profile([attribute(high_risk_classification, annex_iii_high_risk), attribute(placed_before_chapter_iii_application_date, false), attribute(medical_device_or_safety_component_of_one, false), attribute(provider_subject_to_equivalent_union_reporting_obligations, false), attribute(harm_to_health, death_of_a_person), attribute(critical_infrastructure_disruption, false), attribute(fundamental_rights_obligations_infringed, false), attribute(serious_harm_to_property_or_environment, false), attribute(widespread_infringement, false)]).

follow_up_list([perform_necessary_investigations_without_delay, risk_assessment_of_the_incident, corrective_action, cooperate_with_competent_authorities, inform_authorities_before_altering_the_system]).

test(bound_not_applicable_before_the_first_date) :-
    serious_incident_reporting_profile_for(awareness_before_first_application_date, Case),
    serious_incident_reporting_status(Case, not_applicable_on_date).
test(bound_ten_day_report_on_the_first_date) :-
    input_base_profile(Profile),
    follow_up_list(FollowUp),
    serious_incident_report_duty(Profile, date(2027, 12, 2), report_due(market_surveillance_authority_of_member_state_where_incident_occurred, 10, date(2027, 12, 12), FollowUp), _).
test(bound_not_a_high_risk_ai_system) :-
    serious_incident_reporting_profile_for(system_not_high_risk, Case),
    serious_incident_reporting_status(Case, not_a_high_risk_ai_system).
test(bound_not_covered_placed_early) :-
    serious_incident_reporting_profile_for(placed_early_without_significant_change, Case),
    serious_incident_reporting_status(Case, not_covered_placed_before_application_date).
test(bound_not_a_serious_incident) :-
    serious_incident_reporting_profile_for(no_listed_harm, Case),
    serious_incident_reporting_status(Case, not_a_serious_incident).
test(bound_not_a_reportable_incident) :-
    serious_incident_reporting_profile_for(device_without_fundamental_rights, Case),
    serious_incident_reporting_status(Case, not_a_reportable_incident).
test(bound_indeterminate_names_one_key) :-
    serious_incident_reporting_profile_for(device_status_absent, Case),
    serious_incident_reporting_status(Case, indeterminate([medical_device_or_safety_component_of_one])).
test(bound_report_in_time) :-
    serious_incident_reporting_profile_for(report_on_last_day_made_immediately, Case),
    serious_incident_reporting_status(Case, report_in_time).
test(bound_report_after_time_limit) :-
    serious_incident_reporting_profile_for(report_day_after_last_day, Case),
    serious_incident_reporting_status(Case, report_after_time_limit).
test(bound_report_not_immediate) :-
    serious_incident_reporting_profile_for(report_in_time_not_immediate, Case),
    serious_incident_reporting_status(Case, report_not_immediate).
test(bound_referral_on_an_unsure_widespread_infringement) :-
    serious_incident_reporting_profile_for(widespread_infringement_unsure, Case),
    serious_incident_reporting_status(Case, needs_legal_review(open_textured(widespread_infringement, cite(eu_reg_2024_1689_art_3_61)), [inputs_relied_on([provider_subject_to_equivalent_union_reporting_obligations - false, widespread_infringement - unsure])])).
test(the_baseline_holds_with_the_verdict_bound) :-
    serious_incident_reporting_profile_for(awareness_before_first_application_date, Case),
    findall(Status, serious_incident_reporting_status(Case, Status), [BaselineStatus]),
    serious_incident_reporting_status(Case, BaselineStatus).
test(an_unbound_profile_is_not_an_attribute_list) :-
    serious_incident_reporting_input_problems(_, [wrong_type(profile)]).
test(a_partial_list_is_not_an_attribute_list) :-
    serious_incident_reporting_input_problems([attribute(harm_to_health, death_of_a_person)|_], [wrong_type(profile)]).
test(an_element_that_is_not_an_attribute_is_wrong_type_alone) :-
    serious_incident_reporting_input_problems([attribute(colour, blue), colour], [wrong_type(profile)]).
test(an_unbound_element_is_wrong_type_alone) :-
    serious_incident_reporting_input_problems([attribute(harm_to_health, death_of_a_person), _], [wrong_type(profile)]).
test(an_unbound_key_is_unknown_as_given) :-
    serious_incident_reporting_input_problems([attribute(Key, blue)], [unknown_key(Found)]),
    Found == Key.
test(the_same_unbound_key_twice_is_one_key) :-
    serious_incident_reporting_input_problems([attribute(Key, blue), attribute(Key, red)], Problems),
    length(Problems, 1).
test(two_unbound_keys_are_two_keys) :-
    serious_incident_reporting_input_problems([attribute(_, blue), attribute(_, red)], Problems),
    length(Problems, 2).
test(a_number_key_is_unknown) :-
    serious_incident_reporting_input_problems([attribute(42, blue)], [unknown_key(42)]).
test(an_unbound_value_is_wrong_type) :-
    serious_incident_reporting_input_problems([attribute(harm_to_health, _)], [wrong_type(harm_to_health)]).
test(an_unknown_key_with_an_unbound_value_is_only_unknown) :-
    serious_incident_reporting_input_problems([attribute(colour, _)], [unknown_key(colour)]).
test(duplicates_with_different_values_are_only_duplicates) :-
    serious_incident_reporting_input_problems([attribute(harm_to_health, bad_value), attribute(harm_to_health, death_of_a_person)], [duplicate_key(harm_to_health)]).
test(an_attested_value_on_a_crisp_key_is_wrong_type) :-
    serious_incident_reporting_input_problems([attribute(critical_infrastructure_disruption, attested(true, attestation(host, stamp, reason, none)))], [wrong_type(critical_infrastructure_disruption)]).
test(an_attestation_holding_a_variable_is_wrong_type) :-
    serious_incident_reporting_input_problems([attribute(system_under_the_exclusive_competence_of_the_ai_office, attested(true, attestation(host, _, reason, none)))], [wrong_type(system_under_the_exclusive_competence_of_the_ai_office)]).
test(an_unsure_judgement_is_well_typed) :-
    serious_incident_reporting_input_problems([attribute(report_made_immediately, unsure)], []).
test(the_input_check_yields_one_solution) :-
    findall(Problems, serious_incident_reporting_input_problems([attribute(colour, blue), attribute(harm_to_health, wrong)], Problems), [OnlyProblems]),
    OnlyProblems == [wrong_type(harm_to_health), unknown_key(colour)].
test(an_atom_awareness_date_is_wrong_type) :-
    serious_incident_report_duty([], foo, input_problems([wrong_type(awareness_date)]), []).
test(an_unbound_awareness_date_is_wrong_type) :-
    serious_incident_report_duty([], _, input_problems([wrong_type(awareness_date)]), []).
test(a_date_with_an_unbound_year_is_wrong_type) :-
    serious_incident_report_duty([], date(_, 1, 1), input_problems([wrong_type(awareness_date)]), []).
test(profile_problems_come_before_the_date_problem) :-
    serious_incident_report_duty([attribute(colour, blue)], date(2027, 2, 29), input_problems([unknown_key(colour), wrong_type(awareness_date)]), []).
test(both_bad_dates_are_named_in_order) :-
    serious_incident_report_timeliness([], date(2027, 2, 29), date(2028, 13, 1), input_problems([wrong_type(awareness_date), wrong_type(report_date)]), []).

test(every_other_bound_status_is_rejected, fail) :-
    serious_incident_reporting_profile_for(awareness_before_first_application_date, Case),
    serious_incident_reporting_status_values(StatusValues),
    member(Other, StatusValues),
    dif(Other, not_applicable_on_date),
    serious_incident_reporting_status(Case, Other).
test(a_wrong_bound_duty_is_rejected, fail) :-
    input_base_profile(Profile),
    serious_incident_report_duty(Profile, date(2027, 12, 2), report_due(_, 15, _, _), _).
test(an_input_problem_is_not_a_final_answer, fail) :-
    serious_incident_report_duty(foo, date(2028, 1, 10), not_applicable_on_date, _).

cp_test_names([bound_not_applicable_before_the_first_date, bound_ten_day_report_on_the_first_date, bound_not_a_high_risk_ai_system, bound_not_covered_placed_early, bound_not_a_serious_incident, bound_not_a_reportable_incident, bound_indeterminate_names_one_key, bound_report_in_time, bound_report_after_time_limit, bound_report_not_immediate, bound_referral_on_an_unsure_widespread_infringement, the_baseline_holds_with_the_verdict_bound, an_unbound_profile_is_not_an_attribute_list, a_partial_list_is_not_an_attribute_list, an_element_that_is_not_an_attribute_is_wrong_type_alone, an_unbound_element_is_wrong_type_alone, an_unbound_key_is_unknown_as_given, the_same_unbound_key_twice_is_one_key, two_unbound_keys_are_two_keys, a_number_key_is_unknown, an_unbound_value_is_wrong_type, an_unknown_key_with_an_unbound_value_is_only_unknown, duplicates_with_different_values_are_only_duplicates, an_attested_value_on_a_crisp_key_is_wrong_type, an_attestation_holding_a_variable_is_wrong_type, an_unsure_judgement_is_well_typed, the_input_check_yields_one_solution, an_atom_awareness_date_is_wrong_type, an_unbound_awareness_date_is_wrong_type, a_date_with_an_unbound_year_is_wrong_type, profile_problems_come_before_the_date_problem, both_bad_dates_are_named_in_order]).
cp_test_fail_names([every_other_bound_status_is_rejected, a_wrong_bound_duty_is_rejected, an_input_problem_is_not_a_final_answer]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
