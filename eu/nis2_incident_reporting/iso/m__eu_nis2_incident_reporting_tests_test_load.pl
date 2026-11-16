% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_nis2_incident_reporting_tests_test_load, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_nis2_incident_reporting_kernel, [nis2_incident_reporting_input_problems/2]).
:- use_module(m__eu_nis2_incident_reporting_citations, [citation/2, implements/1]).

test(the_verdict_atoms_are_distinct) :-
    dif(significant, not_significant).
test(the_timeliness_results_are_distinct) :-
    dif(on_time, late(hour_limit)),
    dif(late(hour_limit), late(without_undue_delay)).
test(the_verdict_term_carries_status_and_citations) :-
    Verdict = nis2_incident_reporting_verdict(significant, [cite(eu_dir_2022_2555_art_23_3_a)]),
    Verdict = nis2_incident_reporting_verdict(Status, Citations),
    Status == significant,
    Citations == [cite(eu_dir_2022_2555_art_23_3_a)].
test(the_step_term_builds_and_destructures) :-
    Step = step_due(early_warning, hours_after_awareness(24), cite(eu_dir_2022_2555_art_23_4_a)),
    Step = step_due(Name, hours_after_awareness(Hours), cite(Key)),
    Name == early_warning,
    Hours == 24,
    Key == eu_dir_2022_2555_art_23_4_a.
test(a_real_citation_record_resolves) :-
    citation(eu_dir_2022_2555_art_23_4_a, Record),
    Record = [label - _, ref - _, verbatim - _].
test(the_implements_marker_succeeds_for_a_recorded_key) :-
    implements(eu_dir_2022_2555_art_23_3_b).
test(the_input_check_accepts_an_empty_profile) :-
    nis2_incident_reporting_input_problems([], Problems),
    Problems == [].
test(the_input_check_names_an_unknown_key) :-
    nis2_incident_reporting_input_problems([attribute(not_a_contract_key, true)], Problems),
    Problems == [unknown_key(not_a_contract_key)].
test(the_input_check_names_a_wrong_type) :-
    nis2_incident_reporting_input_problems([attribute(incident_ongoing_at_final_report_due, unsure)], Problems),
    Problems == [wrong_type(incident_ongoing_at_final_report_due)].
test(the_input_check_rejects_a_non_list_profile) :-
    nis2_incident_reporting_input_problems(not_a_profile, Problems),
    Problems == [wrong_type(profile)].

test(an_unrecorded_key_does_not_resolve, fail) :-
    citation(eu_dir_2022_2555_art_99_9, _Record).

cp_test_names([the_verdict_atoms_are_distinct, the_timeliness_results_are_distinct, the_verdict_term_carries_status_and_citations, the_step_term_builds_and_destructures, a_real_citation_record_resolves, the_implements_marker_succeeds_for_a_recorded_key, the_input_check_accepts_an_empty_profile, the_input_check_names_an_unknown_key, the_input_check_names_a_wrong_type, the_input_check_rejects_a_non_list_profile]).
cp_test_fail_names([an_unrecorded_key_does_not_resolve]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
