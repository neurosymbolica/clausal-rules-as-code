% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_nis2_incident_reporting_tests_test_input_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_nis2_incident_reporting_nis2_incident_reporting, [incident_significance/3, incident_reporting_steps/2, reporting_step_timeliness/4, nis2_incident_reporting_status/2]).
:- use_module(m__eu_nis2_incident_reporting_kernel, [nis2_incident_reporting_input_problems/2]).
:- use_module(m__eu_nis2_incident_reporting_fixtures, [nis2_incident_reporting_profile_for/2]).

test(limb_a_met_holds_with_the_status_bound) :-
    nis2_incident_reporting_profile_for(severe_disruption_met, Profile),
    incident_significance(Profile, significant, [cite(eu_dir_2022_2555_art_23_3_a)]).
test(neither_limb_holds_not_significant_bound) :-
    nis2_incident_reporting_profile_for(neither_limb_met, Profile),
    incident_significance(Profile, not_significant, [cite(eu_dir_2022_2555_art_23_3_a), cite(eu_dir_2022_2555_art_23_3_b)]).
test(limb_b_met_beside_unsure_a_cites_b_bound) :-
    nis2_incident_reporting_profile_for(damage_met_disruption_unsure, Profile),
    incident_significance(Profile, significant, [cite(eu_dir_2022_2555_art_23_3_b)]).
test(absent_a_is_named_bound) :-
    nis2_incident_reporting_profile_for(disruption_unanswered, Profile),
    incident_significance(Profile, indeterminate([severe_operational_disruption_or_financial_loss]), []).
test(absent_b_before_unsure_a_bound) :-
    nis2_incident_reporting_profile_for(damage_unanswered_disruption_unsure, Profile),
    incident_significance(Profile, indeterminate([considerable_damage_to_other_persons]), []).
test(unsure_a_refers_bound) :-
    nis2_incident_reporting_profile_for(disruption_unsure_damage_not_met, Profile),
    incident_significance(Profile, needs_legal_review(open_textured(severe_operational_disruption_or_financial_loss, cite(eu_dir_2022_2555_art_23_3_a)), [inputs_relied_on([severe_operational_disruption_or_financial_loss - unsure, considerable_damage_to_other_persons - false])]), []).
test(status_facade_holds_bound) :-
    nis2_incident_reporting_profile_for(damage_met_disruption_unsure, Profile),
    nis2_incident_reporting_status(Profile, significant).
test(steps_for_an_ordinary_provider_bound) :-
    nis2_incident_reporting_profile_for(ordinary_provider_settled_prompt, Profile),
    incident_reporting_steps(Profile, [step_due(early_warning, hours_after_awareness(24), cite(eu_dir_2022_2555_art_23_4_a)), step_due(incident_notification, hours_after_awareness(72), cite(eu_dir_2022_2555_art_23_4_b)), step_due(intermediate_report, on_request_of_csirt_or_competent_authority, cite(eu_dir_2022_2555_art_23_4_c)), step_due(final_report, months_after_notification(1), cite(eu_dir_2022_2555_art_23_4_d))]).
test(steps_name_the_absent_ongoing_key_bound) :-
    nis2_incident_reporting_profile_for(significant_ongoing_unanswered, Profile),
    incident_reporting_steps(Profile, indeterminate([incident_ongoing_at_final_report_due])).
test(timeliness_late_without_undue_delay_bound) :-
    nis2_incident_reporting_profile_for(ordinary_provider_delayed, Profile),
    reporting_step_timeliness(Profile, early_warning, 10, late(without_undue_delay)).
test(duplicate_and_unknown_keys_bound) :-
    nis2_incident_reporting_profile_for(duplicate_and_unknown_keys, Profile),
    nis2_incident_reporting_input_problems(Profile, [duplicate_key(severe_operational_disruption_or_financial_loss), unknown_key(unrelated_key)]).
test(crisp_key_given_unsure_bound) :-
    nis2_incident_reporting_profile_for(crisp_key_given_unsure, Profile),
    nis2_incident_reporting_input_problems(Profile, [wrong_type(trust_service_provider_incident_affects_trust_services)]).
test(steps_report_input_problems_bound) :-
    nis2_incident_reporting_profile_for(crisp_key_given_unsure, Profile),
    incident_reporting_steps(Profile, input_problems([wrong_type(trust_service_provider_incident_affects_trust_services)])).
test(significance_reports_input_problems_bound) :-
    nis2_incident_reporting_profile_for(duplicate_and_unknown_keys, Profile),
    incident_significance(Profile, input_problems([duplicate_key(severe_operational_disruption_or_financial_loss), unknown_key(unrelated_key)]), []).
test(a_non_list_profile_bound) :-
    nis2_incident_reporting_input_problems(not_a_list, [wrong_type(profile)]).
test(a_non_attribute_element_bound) :-
    nis2_incident_reporting_input_problems([attribute(severe_operational_disruption_or_financial_loss, true), stray], [wrong_type(profile)]).
test(profile_problems_come_before_argument_problems_bound) :-
    nis2_incident_reporting_profile_for(crisp_key_given_unsure, Profile),
    reporting_step_timeliness(Profile, final_report, -3, input_problems([wrong_type(trust_service_provider_incident_affects_trust_services), wrong_type(step), wrong_type(hours_elapsed)])).

test(limb_a_met_rejects_not_significant, fail) :-
    nis2_incident_reporting_profile_for(severe_disruption_met, Profile),
    incident_significance(Profile, not_significant, _).
test(neither_limb_rejects_significant, fail) :-
    nis2_incident_reporting_profile_for(neither_limb_met, Profile),
    incident_significance(Profile, significant, _).
test(limb_b_met_beside_unsure_a_does_not_cite_a, fail) :-
    nis2_incident_reporting_profile_for(damage_met_disruption_unsure, Profile),
    incident_significance(Profile, significant, [cite(eu_dir_2022_2555_art_23_3_a)]).
test(steps_for_an_ordinary_provider_reject_the_trust_limit, fail) :-
    nis2_incident_reporting_profile_for(ordinary_provider_settled_prompt, Profile),
    incident_reporting_steps(Profile, [_, step_due(incident_notification, hours_after_awareness(24), _)|_]).
test(timeliness_delayed_rejects_on_time, fail) :-
    nis2_incident_reporting_profile_for(ordinary_provider_delayed, Profile),
    reporting_step_timeliness(Profile, early_warning, 10, on_time).

cp_test_names([limb_a_met_holds_with_the_status_bound, neither_limb_holds_not_significant_bound, limb_b_met_beside_unsure_a_cites_b_bound, absent_a_is_named_bound, absent_b_before_unsure_a_bound, unsure_a_refers_bound, status_facade_holds_bound, steps_for_an_ordinary_provider_bound, steps_name_the_absent_ongoing_key_bound, timeliness_late_without_undue_delay_bound, duplicate_and_unknown_keys_bound, crisp_key_given_unsure_bound, steps_report_input_problems_bound, significance_reports_input_problems_bound, a_non_list_profile_bound, a_non_attribute_element_bound, profile_problems_come_before_argument_problems_bound]).
cp_test_fail_names([limb_a_met_rejects_not_significant, neither_limb_rejects_significant, limb_b_met_beside_unsure_a_does_not_cite_a, steps_for_an_ordinary_provider_reject_the_trust_limit, timeliness_delayed_rejects_on_time]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
