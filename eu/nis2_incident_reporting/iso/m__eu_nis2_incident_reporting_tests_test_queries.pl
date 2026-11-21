% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_nis2_incident_reporting_tests_test_queries, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_nis2_incident_reporting_queries, [nis2_incident_reporting_profile_keys/1, nis2_incident_reporting_what_if/4]).
:- use_module(m__eu_nis2_incident_reporting_kernel, [nis2_incident_reporting_input_problems/2]).
:- use_module(m__eu_nis2_incident_reporting_nis2_incident_reporting, [incident_significance/3, reporting_step_timeliness/4]).
:- use_module(m__eu_nis2_incident_reporting_fixtures, [nis2_incident_reporting_profile_for/2]).

test(profile_keys_are_the_contract_keys) :-
    nis2_incident_reporting_profile_keys(ProfileKeys),
    ProfileKeys == [severe_operational_disruption_or_financial_loss, considerable_damage_to_other_persons, trust_service_provider_incident_affects_trust_services, incident_ongoing_at_final_report_due, early_warning_without_undue_delay, incident_notification_without_undue_delay].
test(input_check_is_reexported) :-
    nis2_incident_reporting_input_problems([attribute(unrelated_key, true)], [unknown_key(unrelated_key)]).
test(what_if_flips_a_present_limb) :-
    nis2_incident_reporting_profile_for(neither_limb_met, Profile),
    findall(Status, nis2_incident_reporting_what_if(Profile, severe_operational_disruption_or_financial_loss, true, Status), Statuses),
    Statuses == [significant].
test(what_if_fills_an_absent_limb) :-
    nis2_incident_reporting_profile_for(disruption_unanswered, Profile),
    nis2_incident_reporting_what_if(Profile, severe_operational_disruption_or_financial_loss, false, not_significant).
test(what_if_resolves_a_duplicate_key) :-
    nis2_incident_reporting_profile_for(duplicate_and_unknown_keys, Profile),
    nis2_incident_reporting_what_if(Profile, severe_operational_disruption_or_financial_loss, true, input_problems([unknown_key(unrelated_key)])).
test(eligibility_query_type_answers) :-
    nis2_incident_reporting_profile_for(severe_disruption_met, Profile),
    findall(Status, incident_significance(Profile, Status, _), Statuses),
    Statuses == [significant].
test(deadline_query_type_answers_the_consequence_of_missing_the_limit) :-
    findall(Result, reporting_step_timeliness([], incident_notification, 100, Result), Results),
    Results == [late(hour_limit)].

test(what_if_does_not_invent_significance, fail) :-
    nis2_incident_reporting_profile_for(neither_limb_met, Profile),
    nis2_incident_reporting_what_if(Profile, trust_service_provider_incident_affects_trust_services, true, significant).

cp_test_names([profile_keys_are_the_contract_keys, input_check_is_reexported, what_if_flips_a_present_limb, what_if_fills_an_absent_limb, what_if_resolves_a_duplicate_key, eligibility_query_type_answers, deadline_query_type_answers_the_consequence_of_missing_the_limit]).
cp_test_fail_names([what_if_does_not_invent_significance]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
