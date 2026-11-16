% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_nis2_incident_reporting_tests_test_result_constructors, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_nis2_incident_reporting_nis2_incident_reporting, [incident_significance/3, incident_reporting_steps/2, reporting_step_timeliness/4]).
:- use_module(m__eu_nis2_incident_reporting_kernel, [nis2_incident_reporting_input_problems/2]).

test(duplicate_key_with_equal_values_is_named) :-
    nis2_incident_reporting_input_problems([attribute(incident_ongoing_at_final_report_due, true), attribute(incident_ongoing_at_final_report_due, true)], Problems),
    Problems == [duplicate_key(incident_ongoing_at_final_report_due)].
test(duplicate_key_with_different_values_is_not_wrong_type) :-
    nis2_incident_reporting_input_problems([attribute(early_warning_without_undue_delay, true), attribute(early_warning_without_undue_delay, false)], Problems),
    Problems == [duplicate_key(early_warning_without_undue_delay)].
test(duplicate_key_reaches_incident_significance) :-
    incident_significance([attribute(severe_operational_disruption_or_financial_loss, true), attribute(severe_operational_disruption_or_financial_loss, true)], Status, Citations),
    Status == input_problems([duplicate_key(severe_operational_disruption_or_financial_loss)]),
    Citations == [].
test(duplicate_key_reaches_incident_reporting_steps) :-
    incident_reporting_steps([attribute(trust_service_provider_incident_affects_trust_services, true), attribute(trust_service_provider_incident_affects_trust_services, false)], Steps),
    Steps == input_problems([duplicate_key(trust_service_provider_incident_affects_trust_services)]).
test(duplicate_key_reaches_reporting_step_timeliness) :-
    reporting_step_timeliness([attribute(incident_notification_without_undue_delay, true), attribute(incident_notification_without_undue_delay, true)], incident_notification, 10, Result),
    Result == input_problems([duplicate_key(incident_notification_without_undue_delay)]).
test(a_single_key_has_no_problem) :-
    nis2_incident_reporting_input_problems([attribute(incident_ongoing_at_final_report_due, true)], []).
test(provenance_term_builds_and_destructures) :-
    Marker = provenance(significance_operational_or_financial, [cite(eu_dir_2022_2555_art_23_3_a)]),
    Marker = provenance(Clause, Citations),
    Clause == significance_operational_or_financial,
    Citations == [cite(eu_dir_2022_2555_art_23_3_a)].
test(provenance_is_an_optional_context_item) :-
    Context = [inputs_relied_on([severe_operational_disruption_or_financial_loss - unsure]), provenance(significance_operational_or_financial, [cite(eu_dir_2022_2555_art_23_3_a)])],
    Context = [inputs_relied_on(Pairs), provenance(_Clause, _Citations)],
    Pairs == [severe_operational_disruption_or_financial_loss - unsure].
test(referral_context_is_inputs_relied_on_without_provenance) :-
    incident_significance([attribute(severe_operational_disruption_or_financial_loss, unsure), attribute(considerable_damage_to_other_persons, false)], Status, _Citations),
    Status = needs_legal_review(_Reason, [inputs_relied_on(_Pairs)]).

test(a_single_key_is_no_duplicate, fail) :-
    nis2_incident_reporting_input_problems([attribute(incident_ongoing_at_final_report_due, true)], [duplicate_key(incident_ongoing_at_final_report_due)]).
test(provenance_differs_from_inputs_relied_on, fail) :-
    provenance(a, []) = inputs_relied_on([]).

cp_test_names([duplicate_key_with_equal_values_is_named, duplicate_key_with_different_values_is_not_wrong_type, duplicate_key_reaches_incident_significance, duplicate_key_reaches_incident_reporting_steps, duplicate_key_reaches_reporting_step_timeliness, a_single_key_has_no_problem, provenance_term_builds_and_destructures, provenance_is_an_optional_context_item, referral_context_is_inputs_relied_on_without_provenance]).
cp_test_fail_names([a_single_key_is_no_duplicate, provenance_differs_from_inputs_relied_on]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
