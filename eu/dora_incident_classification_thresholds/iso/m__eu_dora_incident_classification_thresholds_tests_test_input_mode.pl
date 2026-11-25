% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_incident_classification_thresholds_tests_test_input_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_dora_incident_classification_thresholds_dora_incident_classification_thresholds, [dora_incident_threshold_status/4, dora_final_report_timeliness/5, dora_incident_classification_thresholds_status/2, dora_incident_classification_thresholds_status_values/1]).
:- use_module(m__eu_dora_incident_classification_thresholds_kernel, [dora_incident_classification_thresholds_input_problems/2]).
:- use_module(m__eu_dora_incident_classification_thresholds_fixtures, [dora_incident_classification_thresholds_profile_for/2]).

test(met_holds_with_status_and_citations_bound) :-
    dora_incident_classification_thresholds_profile_for(geographical_two_member_states, Profile),
    dora_incident_threshold_status(Profile, geographical_spread_threshold_met, met, [cite(eu_reg_2022_2554_art_18_1), cite(eu_reg_2024_1772_art_9_4), cite(eu_reg_2024_1772_art_4)]).
test(not_met_holds_with_status_bound) :-
    dora_incident_classification_thresholds_profile_for(geographical_one_member_state, Profile),
    dora_incident_classification_thresholds_status(threshold_query(Profile, geographical_spread_threshold_met), not_met).
test(indeterminate_holds_with_the_key_bound) :-
    dora_incident_threshold_status([], geographical_spread_threshold_met, indeterminate([member_states_with_impact]), []).
test(referral_holds_with_the_whole_term_bound) :-
    dora_incident_classification_thresholds_profile_for(critical_services_unsure_referred, Profile),
    dora_incident_threshold_status(Profile, critical_services_affected, needs_legal_review(open_textured(affects_ict_services_supporting_critical_or_important_functions, cite(eu_reg_2024_1772_art_6)), [inputs_relied_on([affects_ict_services_supporting_critical_or_important_functions - unsure, affects_authorised_registered_or_supervised_financial_services - false, successful_malicious_unauthorised_access - false])]), []).
test(on_time_holds_with_the_result_bound) :-
    dora_final_report_timeliness([], date(2025, 12, 15), date(2026, 1, 15), on_time, [cite(eu_reg_2025_301_art_5_1_c)]).
test(late_holds_with_the_result_bound) :-
    dora_final_report_timeliness([attribute(final_report_weekend_extension, false)], date(2024, 1, 31), date(2024, 3, 1), late(month_limit), _).
test(a_well_formed_profile_has_no_problem) :-
    dora_incident_classification_thresholds_input_problems([attribute(affected_clients, 3), attribute(incident_reflected_in_media, unsure), attribute(final_report_weekend_extension, true)], []).
test(an_unbound_profile_is_not_an_attribute_list) :-
    dora_incident_classification_thresholds_input_problems(_UnboundProfile, Problems),
    Problems == [wrong_type(profile)].
test(a_partial_list_is_not_an_attribute_list) :-
    dora_incident_classification_thresholds_input_problems([attribute(affected_clients, 1)|_OpenTail], Problems),
    Problems == [wrong_type(profile)].
test(a_foreign_element_is_not_an_attribute_list) :-
    dora_incident_classification_thresholds_input_problems([attribute(affected_clients, 1), colour - red], Problems),
    Problems == [wrong_type(profile)].
test(contract_problems_come_before_unknown_keys) :-
    dora_incident_classification_thresholds_input_problems([attribute(colour, red), attribute(staff_costs_cents, 12.5)], Problems),
    Problems == [wrong_type(staff_costs_cents), unknown_key(colour)].
test(a_duplicate_key_is_never_also_wrong_type) :-
    dora_incident_classification_thresholds_input_problems([attribute(affected_clients, 1), attribute(affected_clients, wrong)], Problems),
    Problems == [duplicate_key(affected_clients)].
test(an_unbound_key_is_named_as_given) :-
    dora_incident_classification_thresholds_input_problems([attribute(UnboundKey, 1)], Problems),
    Problems = [unknown_key(NamedKey)],
    NamedKey == UnboundKey.
test(two_unbound_keys_are_two_unknown_keys) :-
    dora_incident_classification_thresholds_input_problems([attribute(FirstKey, 1), attribute(SecondKey, 2)], Problems),
    Problems = [unknown_key(FirstNamed), unknown_key(SecondNamed)],
    FirstNamed == FirstKey,
    SecondNamed == SecondKey.
test(an_unbound_contract_value_is_wrong_type) :-
    dora_incident_classification_thresholds_input_problems([attribute(member_states_with_impact, _UnboundValue)], Problems),
    Problems == [wrong_type(member_states_with_impact)].
test(an_unknown_key_value_is_never_checked) :-
    dora_incident_classification_thresholds_input_problems([attribute(colour, _UnboundValue)], Problems),
    Problems == [unknown_key(colour)].
test(a_float_duration_is_wrong_type) :-
    dora_incident_classification_thresholds_input_problems([attribute(incident_duration_seconds, 86401.0)], Problems),
    Problems == [wrong_type(incident_duration_seconds)].
test(unsure_is_wrong_type_for_the_fact_key) :-
    dora_incident_classification_thresholds_input_problems([attribute(final_report_weekend_extension, unsure)], Problems),
    Problems == [wrong_type(final_report_weekend_extension)].
test(a_negative_count_is_wrong_type) :-
    dora_incident_classification_thresholds_input_problems([attribute(affected_clients, -1)], Problems),
    Problems == [wrong_type(affected_clients)].
test(an_unbound_threshold_is_wrong_type) :-
    dora_incident_threshold_status([], _UnboundThreshold, Status, Citations),
    Status == input_problems([wrong_type(threshold)]),
    Citations == [].
test(threshold_problem_follows_profile_problems) :-
    dora_incident_threshold_status([attribute(colour, red)], major, Status, []),
    Status == input_problems([unknown_key(colour), wrong_type(threshold)]).
test(threshold_problem_follows_a_bad_profile) :-
    dora_incident_threshold_status(not_a_list, major, Status, []),
    Status == input_problems([wrong_type(profile), wrong_type(threshold)]).
test(an_impossible_month_is_not_a_date) :-
    dora_final_report_timeliness([], date(2025, 13, 1), date(2026, 1, 1), Result, []),
    Result == input_problems([wrong_type(latest_intermediate_date)]).
test(an_unbound_final_date_is_wrong_type) :-
    dora_final_report_timeliness([], date(2025, 1, 1), _UnboundDate, Result, []),
    Result == input_problems([wrong_type(final_date)]).

test(not_met_profile_rejects_bound_met, fail) :-
    dora_incident_classification_thresholds_profile_for(geographical_one_member_state, Profile),
    dora_incident_classification_thresholds_status(threshold_query(Profile, geographical_spread_threshold_met), met).
test(every_other_bound_status_is_rejected, fail) :-
    dora_incident_classification_thresholds_profile_for(reputational_media_true, Profile),
    dora_incident_classification_thresholds_status_values(StatusValues),
    member(Other, StatusValues),
    dif(Other, met),
    dora_incident_classification_thresholds_status(threshold_query(Profile, reputational_impact_threshold_met), Other).
test(indeterminate_rejects_another_key, fail) :-
    dora_incident_threshold_status([], geographical_spread_threshold_met, indeterminate([affected_clients]), _).
test(late_report_rejects_bound_on_time, fail) :-
    dora_final_report_timeliness([attribute(final_report_weekend_extension, false)], date(2024, 1, 31), date(2024, 3, 1), on_time, _).

cp_test_names([met_holds_with_status_and_citations_bound, not_met_holds_with_status_bound, indeterminate_holds_with_the_key_bound, referral_holds_with_the_whole_term_bound, on_time_holds_with_the_result_bound, late_holds_with_the_result_bound, a_well_formed_profile_has_no_problem, an_unbound_profile_is_not_an_attribute_list, a_partial_list_is_not_an_attribute_list, a_foreign_element_is_not_an_attribute_list, contract_problems_come_before_unknown_keys, a_duplicate_key_is_never_also_wrong_type, an_unbound_key_is_named_as_given, two_unbound_keys_are_two_unknown_keys, an_unbound_contract_value_is_wrong_type, an_unknown_key_value_is_never_checked, a_float_duration_is_wrong_type, unsure_is_wrong_type_for_the_fact_key, a_negative_count_is_wrong_type, an_unbound_threshold_is_wrong_type, threshold_problem_follows_profile_problems, threshold_problem_follows_a_bad_profile, an_impossible_month_is_not_a_date, an_unbound_final_date_is_wrong_type]).
cp_test_fail_names([not_met_profile_rejects_bound_met, every_other_bound_status_is_rejected, indeterminate_rejects_another_key, late_report_rejects_bound_on_time]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
