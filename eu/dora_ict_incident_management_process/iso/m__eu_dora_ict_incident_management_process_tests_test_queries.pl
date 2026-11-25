% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_ict_incident_management_process_tests_test_queries, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_dora_ict_incident_management_process_queries, [dora_ict_incident_management_process_profile_keys/1, dora_ict_incident_management_process_what_if/4, dora_ict_incident_management_process_compliance/3, complete/0, incomplete/0, none_outstanding/0, unsure/0]).
:- use_module(m__eu_dora_ict_incident_management_process_kernel, [dora_ict_incident_management_process_input_problems/2]).
:- use_module(m__eu_dora_ict_incident_management_process_dora_ict_incident_management_process, [dora_ict_incident_management_process_status/2, dora_ict_incident_management_process_checklist/2]).
:- use_module(m__eu_dora_ict_incident_management_process_fixtures, [dora_ict_incident_management_process_profile_for/2]).

test(profile_keys_are_the_contract_keys) :-
    dora_ict_incident_management_process_profile_keys(ProfileKeys),
    ProfileKeys == [ict_related_incident_management_process_defined_established_and_implemented, all_ict_related_incidents_and_significant_cyber_threats_recorded, procedures_for_monitoring_handling_follow_up_and_root_causes_established, early_warning_indicators_put_in_place, procedures_to_identify_track_log_categorise_and_classify_incidents_established, roles_and_responsibilities_for_incident_types_and_scenarios_assigned, communication_notification_escalation_and_counterpart_information_plans_set_out, major_incidents_reported_to_senior_management_and_management_body_informed, incident_response_procedures_established, cyber_threats_classified_as_significant_on_the_article_18_2_criteria].
test(the_re_exported_input_check_answers) :-
    dora_ict_incident_management_process_input_problems([attribute(colour, red)], [unknown_key(colour)]),
    dora_ict_incident_management_process_input_problems([], []).
test(eligibility_status_of_the_baseline) :-
    dora_ict_incident_management_process_profile_for(all_duties_performed, Profile),
    dora_ict_incident_management_process_status(Profile, complete).
test(justification_items_are_cited) :-
    dora_ict_incident_management_process_profile_for(all_duties_performed, Profile),
    dora_ict_incident_management_process_checklist(Profile, Items),
    length(Items, 10),
    maplist(cited_item, Items).
test(compliance_omitting_a_duty_is_prohibited) :-
    dora_ict_incident_management_process_profile_for(all_duties_performed, Profile),
    findall(Verdict, dora_ict_incident_management_process_compliance(Profile, omit(reporting_to_senior_management_and_management_body), Verdict), Verdicts),
    Verdicts == [permission(prohibited, [cite(eu_reg_2022_2554_art_17_3_e)])].
test(compliance_performing_a_duty_is_allowed) :-
    dora_ict_incident_management_process_compliance([], perform(incident_management_process), permission(allowed, [cite(eu_reg_2022_2554_art_17_1)])).
test(compliance_unrelated_action_is_not_regulated) :-
    dora_ict_incident_management_process_compliance([], perform(annual_party), permission(not_regulated, [])).
test(compliance_refuses_a_bad_profile) :-
    dora_ict_incident_management_process_compliance([attribute(colour, red)], omit(early_warning_indicators), input_problems([unknown_key(colour)])).
test(what_if_a_duty_is_not_performed) :-
    dora_ict_incident_management_process_profile_for(all_duties_performed, Profile),
    dora_ict_incident_management_process_what_if(Profile, early_warning_indicators_put_in_place, false, incomplete).
test(what_if_a_duty_is_unsure) :-
    dora_ict_incident_management_process_profile_for(all_duties_performed, Profile),
    dora_ict_incident_management_process_what_if(Profile, incident_response_procedures_established, unsure, needs_legal_review).
test(what_if_the_missing_duty_is_performed) :-
    dora_ict_incident_management_process_profile_for(early_warning_indicators_not_performed, Profile),
    dora_ict_incident_management_process_what_if(Profile, early_warning_indicators_put_in_place, true, complete).
test(the_root_exports_are_served) :-
    complete,
    incomplete,
    none_outstanding,
    unsure.

cited_item(item(_, _, cite(_))).

test(compliance_omitting_is_not_allowed, fail) :-
    dora_ict_incident_management_process_compliance([], omit(incident_management_process), permission(allowed, _)).
test(what_if_a_performed_duty_stays_complete, fail) :-
    dora_ict_incident_management_process_profile_for(all_duties_performed, Profile),
    dora_ict_incident_management_process_what_if(Profile, early_warning_indicators_put_in_place, false, complete).

cp_test_names([profile_keys_are_the_contract_keys, the_re_exported_input_check_answers, eligibility_status_of_the_baseline, justification_items_are_cited, compliance_omitting_a_duty_is_prohibited, compliance_performing_a_duty_is_allowed, compliance_unrelated_action_is_not_regulated, compliance_refuses_a_bad_profile, what_if_a_duty_is_not_performed, what_if_a_duty_is_unsure, what_if_the_missing_duty_is_performed, the_root_exports_are_served]).
cp_test_fail_names([compliance_omitting_is_not_allowed, what_if_a_performed_duty_stays_complete]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
