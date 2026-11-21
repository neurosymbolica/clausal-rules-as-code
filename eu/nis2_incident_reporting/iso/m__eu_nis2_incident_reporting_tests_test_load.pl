% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_nis2_incident_reporting_tests_test_load, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_nis2_incident_reporting_kernel, [nis2_incident_reporting_input_problems/2]).
:- use_module(m__eu_nis2_incident_reporting_citations, [citation/2, implements/1]).

test(the_significance_atoms_are_distinct) :-
    dif(significant, not_significant).
test(the_timeliness_atoms_are_distinct) :-
    dif(on_time, late(hour_limit)),
    dif(late(hour_limit), late(without_undue_delay)).
test(the_judgement_values_are_distinct) :-
    dif(true, unsure),
    dif(false, unsure),
    dif(true, false).
test(the_verdict_term_carries_status_and_citations) :-
    Verdict = nis2_incident_reporting_verdict(significant, [cite(eu_dir_2022_2555_art_23_3_a)]),
    Verdict = nis2_incident_reporting_verdict(Status, Citations),
    Status == significant,
    Citations == [cite(eu_dir_2022_2555_art_23_3_a)].
test(the_step_due_term_destructures) :-
    StepDue = step_due(incident_notification, hours_after_awareness(72), cite(eu_dir_2022_2555_art_23_4_b)),
    StepDue = step_due(Step, hours_after_awareness(Hours), cite(Key)),
    Step == incident_notification,
    Hours == 72,
    Key == eu_dir_2022_2555_art_23_4_b.
test(the_referral_term_destructures) :-
    Referral = needs_legal_review(open_textured(severe_operational_disruption_or_financial_loss, cite(eu_dir_2022_2555_art_23_3_a)), [inputs_relied_on([severe_operational_disruption_or_financial_loss - unsure])]),
    Referral = needs_legal_review(open_textured(Input, cite(Citation)), [inputs_relied_on(Pairs)]),
    Input == severe_operational_disruption_or_financial_loss,
    Citation == eu_dir_2022_2555_art_23_3_a,
    Pairs == [severe_operational_disruption_or_financial_loss - unsure].
test(the_indeterminate_compound_holds_one_key) :-
    Status = indeterminate([considerable_damage_to_other_persons]),
    Status = indeterminate(MissingKeys),
    length(MissingKeys, 1).
test(the_first_significance_limb_is_recorded) :-
    citation(eu_dir_2022_2555_art_23_3_a, _Record).
test(the_trust_service_provider_derogation_is_recorded) :-
    citation(eu_dir_2022_2555_art_23_4, _Record).
test(the_ongoing_incident_point_is_recorded) :-
    citation(eu_dir_2022_2555_art_23_4_e, _Record).
test(a_recorded_key_is_implemented) :-
    implements(eu_dir_2022_2555_art_23_1).
test(the_empty_profile_has_no_problem) :-
    findall(Problems, nis2_incident_reporting_input_problems([], Problems), Answers),
    Answers == [[]].
test(a_full_profile_has_no_problem) :-
    findall(Problems, nis2_incident_reporting_input_problems([attribute(severe_operational_disruption_or_financial_loss, unsure), attribute(considerable_damage_to_other_persons, false), attribute(trust_service_provider_incident_affects_trust_services, true), attribute(incident_ongoing_at_final_report_due, false), attribute(early_warning_without_undue_delay, true), attribute(incident_notification_without_undue_delay, unsure)], Problems), Answers),
    Answers == [[]].
test(a_crisp_key_given_unsure_is_wrong_type) :-
    findall(Problems, nis2_incident_reporting_input_problems([attribute(trust_service_provider_incident_affects_trust_services, unsure)], Problems), Answers),
    Answers == [[wrong_type(trust_service_provider_incident_affects_trust_services)]].
test(a_repeated_key_is_a_duplicate_only) :-
    findall(Problems, nis2_incident_reporting_input_problems([attribute(considerable_damage_to_other_persons, true), attribute(considerable_damage_to_other_persons, maybe)], Problems), Answers),
    Answers == [[duplicate_key(considerable_damage_to_other_persons)]].
test(an_unknown_key_is_named_once) :-
    findall(Problems, nis2_incident_reporting_input_problems([attribute(colour, red), attribute(colour, blue)], Problems), Answers),
    Answers == [[unknown_key(colour)]].
test(contract_problems_come_before_unknown_keys) :-
    findall(Problems, nis2_incident_reporting_input_problems([attribute(colour, red), attribute(early_warning_without_undue_delay, yes)], Problems), Answers),
    Answers == [[wrong_type(early_warning_without_undue_delay), unknown_key(colour)]].
test(a_non_list_is_not_a_profile) :-
    findall(Problems, nis2_incident_reporting_input_problems(profile, Problems), Answers),
    Answers == [[wrong_type(profile)]].
test(a_list_with_a_stray_element_is_not_a_profile) :-
    findall(Problems, nis2_incident_reporting_input_problems([attribute(severe_operational_disruption_or_financial_loss, true), stray], Problems), Answers),
    Answers == [[wrong_type(profile)]].
test(a_well_formed_profile_has_the_empty_list) :-
    nis2_incident_reporting_input_problems([attribute(severe_operational_disruption_or_financial_loss, true)], []).

test(an_unrecorded_key_is_not_implemented, fail) :-
    implements(eu_todo_primary_source).
test(a_well_formed_profile_is_not_wrong_type, fail) :-
    nis2_incident_reporting_input_problems([attribute(severe_operational_disruption_or_financial_loss, true)], [wrong_type(profile)]).

cp_test_names([the_significance_atoms_are_distinct, the_timeliness_atoms_are_distinct, the_judgement_values_are_distinct, the_verdict_term_carries_status_and_citations, the_step_due_term_destructures, the_referral_term_destructures, the_indeterminate_compound_holds_one_key, the_first_significance_limb_is_recorded, the_trust_service_provider_derogation_is_recorded, the_ongoing_incident_point_is_recorded, a_recorded_key_is_implemented, the_empty_profile_has_no_problem, a_full_profile_has_no_problem, a_crisp_key_given_unsure_is_wrong_type, a_repeated_key_is_a_duplicate_only, an_unknown_key_is_named_once, contract_problems_come_before_unknown_keys, a_non_list_is_not_a_profile, a_list_with_a_stray_element_is_not_a_profile, a_well_formed_profile_has_the_empty_list]).
cp_test_fail_names([an_unrecorded_key_is_not_implemented, a_well_formed_profile_is_not_wrong_type]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
