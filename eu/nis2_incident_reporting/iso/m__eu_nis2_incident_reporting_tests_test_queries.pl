% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_nis2_incident_reporting_tests_test_queries, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_nis2_incident_reporting_queries, [nis2_incident_reporting_profile_keys/1, nis2_incident_reporting_what_if/4, early_warning/0, unsure/0]).
:- use_module(m__eu_nis2_incident_reporting_nis2_incident_reporting, [nis2_incident_reporting_checklist/2]).
:- use_module(m__eu_nis2_incident_reporting_fixtures, [nis2_incident_reporting_profile_for/2]).

test(profile_keys_are_the_contract_keys) :-
    nis2_incident_reporting_profile_keys(ProfileKeys),
    ProfileKeys == [severe_operational_disruption_or_financial_loss, considerable_damage_to_other_persons, trust_service_provider_incident_affects_trust_services, incident_ongoing_at_final_report_due, early_warning_without_undue_delay, incident_notification_without_undue_delay].
test(what_if_flips_limb_a_to_not_significant) :-
    nis2_incident_reporting_profile_for(limb_a_met, Profile),
    nis2_incident_reporting_what_if(Profile, severe_operational_disruption_or_financial_loss, false, not_significant).
test(what_if_resolves_unsure_limb) :-
    nis2_incident_reporting_profile_for(limb_a_unsure, Profile),
    nis2_incident_reporting_what_if(Profile, severe_operational_disruption_or_financial_loss, true, significant).
test(what_if_adds_an_absent_key) :-
    nis2_incident_reporting_what_if([], considerable_damage_to_other_persons, true, significant).
test(what_if_single_answer) :-
    nis2_incident_reporting_profile_for(limb_a_met, Profile),
    findall(Status, nis2_incident_reporting_what_if(Profile, considerable_damage_to_other_persons, true, Status), Statuses),
    Statuses == [significant].
test(checklist_rows_for_limb_a) :-
    nis2_incident_reporting_profile_for(limb_a_met, Profile),
    nis2_incident_reporting_checklist(Profile, [item(significance_operational_or_financial, met, cite(eu_dir_2022_2555_art_23_3_a)), item(significance_damage_to_others, unmet(limb_not_met), cite(eu_dir_2022_2555_art_23_3_b))]).
test(root_atoms_are_exported) :-
    early_warning,
    unsure.

test(what_if_does_not_keep_the_old_status, fail) :-
    nis2_incident_reporting_profile_for(limb_a_met, Profile),
    nis2_incident_reporting_what_if(Profile, severe_operational_disruption_or_financial_loss, false, significant).

cp_test_names([profile_keys_are_the_contract_keys, what_if_flips_limb_a_to_not_significant, what_if_resolves_unsure_limb, what_if_adds_an_absent_key, what_if_single_answer, checklist_rows_for_limb_a, root_atoms_are_exported]).
cp_test_fail_names([what_if_does_not_keep_the_old_status]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
