% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_cra_art14_manufacturer_reporting_tests_test_load, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_cra_art14_manufacturer_reporting_kernel, [cra_art14_manufacturer_reporting_input_problems/2]).
:- use_module(m__eu_cra_art14_manufacturer_reporting_citations, [citation/2, implements/1]).

test(the_severity_atoms_are_distinct) :-
    dif(severe, not_severe).
test(the_timeliness_results_are_distinct) :-
    dif(on_time, late(hour_limit)),
    dif(late(hour_limit), late(without_undue_delay)).
test(the_step_atoms_are_distinct) :-
    dif(early_warning, notification),
    dif(notification, final_report),
    dif(final_report, intermediate_report),
    dif(early_warning, intermediate_report).
test(the_event_atoms_are_distinct) :-
    dif(actively_exploited_vulnerability, incident_impacting_product_security).
test(the_verdict_term_carries_status_and_citations) :-
    Verdict = cra_art14_manufacturer_reporting_verdict(severe, [cite(eu_reg_2024_2847_art_14_5)]),
    Verdict = cra_art14_manufacturer_reporting_verdict(Status, Citations),
    Status == severe,
    Citations == [cite(eu_reg_2024_2847_art_14_5)].
test(the_step_term_carries_step_limit_and_citation) :-
    StepTerm = step_due(early_warning, hours_after_awareness(24), cite(eu_reg_2024_2847_art_14_2_a)),
    StepTerm = step_due(Step, hours_after_awareness(Hours), cite(Key)),
    Step == early_warning,
    Hours == 24,
    Key == eu_reg_2024_2847_art_14_2_a.
test(the_referral_term_carries_reason_and_context) :-
    Referral = needs_legal_review(open_textured(early_warning_without_undue_delay, cite(eu_reg_2024_2847_art_14_4_a)), [inputs_relied_on([early_warning_without_undue_delay - unsure])]),
    Referral = needs_legal_review(open_textured(Input, cite(Key)), [inputs_relied_on(Pairs)]),
    Input == early_warning_without_undue_delay,
    Key == eu_reg_2024_2847_art_14_4_a,
    Pairs == [early_warning_without_undue_delay - unsure].
test(the_indeterminate_term_holds_one_key) :-
    Status = indeterminate([affects_protection_of_sensitive_or_important_data_or_functions]),
    Status = indeterminate([Key]),
    Key == affects_protection_of_sensitive_or_important_data_or_functions.
test(the_severity_citation_is_recorded) :-
    citation(eu_reg_2024_2847_art_14_5, _Record).
test(every_answer_citation_is_recorded) :-
    maplist(implements, [eu_reg_2024_2847_art_14_2_a, eu_reg_2024_2847_art_14_2_b, eu_reg_2024_2847_art_14_2_c, eu_reg_2024_2847_art_14_4_a, eu_reg_2024_2847_art_14_4_b, eu_reg_2024_2847_art_14_4_c, eu_reg_2024_2847_art_14_5, eu_reg_2024_2847_art_14_5_a, eu_reg_2024_2847_art_14_5_b, eu_reg_2024_2847_art_14_6]).
test(every_marker_citation_is_recorded) :-
    maplist(implements, [eu_reg_2024_2847_art_14_1, eu_reg_2024_2847_art_14_3, eu_reg_2024_2847_art_71_2]).
test(the_application_marker_is_recorded) :-
    implements(eu_reg_2024_2847_art_71_2).
test(an_empty_profile_has_no_problem) :-
    findall(Problems, cra_art14_manufacturer_reporting_input_problems([], Problems), Answers),
    Answers == [[]].
test(a_well_formed_profile_has_no_problem) :-
    findall(Problems, cra_art14_manufacturer_reporting_input_problems([attribute(affects_protection_of_sensitive_or_important_data_or_functions, true), attribute(leads_to_malicious_code_in_product_or_user_systems, unsure)], Problems), Answers),
    Answers == [[]].
test(an_unknown_key_is_named) :-
    findall(Problems, cra_art14_manufacturer_reporting_input_problems([attribute(product_category, true)], Problems), Answers),
    Answers == [[unknown_key(product_category)]].
test(a_value_outside_the_judgement_is_wrong_type) :-
    findall(Problems, cra_art14_manufacturer_reporting_input_problems([attribute(notification_without_undue_delay, maybe)], Problems), Answers),
    Answers == [[wrong_type(notification_without_undue_delay)]].
test(a_repeated_key_is_a_duplicate) :-
    findall(Problems, cra_art14_manufacturer_reporting_input_problems([attribute(early_warning_without_undue_delay, true), attribute(early_warning_without_undue_delay, maybe)], Problems), Answers),
    Answers == [[duplicate_key(early_warning_without_undue_delay)]].
test(a_term_that_is_not_a_list_is_wrong_type_profile) :-
    findall(Problems, cra_art14_manufacturer_reporting_input_problems(profile, Problems), Answers),
    Answers == [[wrong_type(profile)]].
test(an_unbound_profile_is_wrong_type_profile) :-
    findall(Problems, cra_art14_manufacturer_reporting_input_problems(_Profile, Problems), Answers),
    Answers = [[wrong_type(profile)]].

test(an_unrecorded_key_is_no_marker, fail) :-
    implements(eu_todo_primary_source).
test(a_well_formed_profile_has_a_problem, fail) :-
    cra_art14_manufacturer_reporting_input_problems([attribute(affects_protection_of_sensitive_or_important_data_or_functions, false)], [_|_]).

cp_test_names([the_severity_atoms_are_distinct, the_timeliness_results_are_distinct, the_step_atoms_are_distinct, the_event_atoms_are_distinct, the_verdict_term_carries_status_and_citations, the_step_term_carries_step_limit_and_citation, the_referral_term_carries_reason_and_context, the_indeterminate_term_holds_one_key, the_severity_citation_is_recorded, every_answer_citation_is_recorded, every_marker_citation_is_recorded, the_application_marker_is_recorded, an_empty_profile_has_no_problem, a_well_formed_profile_has_no_problem, an_unknown_key_is_named, a_value_outside_the_judgement_is_wrong_type, a_repeated_key_is_a_duplicate, a_term_that_is_not_a_list_is_wrong_type_profile, an_unbound_profile_is_wrong_type_profile]).
cp_test_fail_names([an_unrecorded_key_is_no_marker, a_well_formed_profile_has_a_problem]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
