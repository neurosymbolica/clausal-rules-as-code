% SPDX-License-Identifier: EUPL-1.2
:- module(m__ind_dpdp_research_state_processing_tests_test_negative_controls, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__ind_dpdp_research_state_processing_dpdp_research_state_processing, [research_exemption/3, state_processing_standards/3, state_processing_disapplied_provisions/3, dpdp_research_state_processing_status_values/1]).
:- use_module(m__ind_dpdp_research_state_processing_fixtures, [dpdp_research_state_processing_profile_for/2]).

research(Subject, Result) :-
    dpdp_research_state_processing_profile_for(Subject, Profile),
    research_exemption(Profile, Result, _).

standards(Subject, Result) :-
    dpdp_research_state_processing_profile_for(Subject, Profile),
    state_processing_standards(Profile, Result, _).

disapplied(Subject, Result) :-
    dpdp_research_state_processing_profile_for(Subject, Profile),
    state_processing_disapplied_provisions(Profile, Result, _).

test(every_named_atom_is_in_the_status_table) :-
    dpdp_research_state_processing_status_values(StatusValues),
    member(exempt_from_act, StatusValues),
    member(not_exempt, StatusValues),
    member(not_in_force, StatusValues),
    member(follows_second_schedule, StatusValues),
    member(does_not_follow_second_schedule, StatusValues),
    member(not_applicable, StatusValues),
    member(sections_8_7_12_2_and_12_3_do_not_apply, StatusValues),
    member(sections_8_7_and_12_3_do_not_apply, StatusValues).
test(the_complete_profile_answers_each_query) :-
    research(complete_processing, exempt_from_act),
    standards(complete_processing, follows_second_schedule),
    disapplied(complete_processing, sections_8_7_12_2_and_12_3_do_not_apply).
test(section_seventeen_not_in_force_is_not_in_force) :-
    research(section_seventeen_not_in_force, not_in_force).
test(the_day_before_commencement_is_not_in_force) :-
    research(reference_day_before_commencement, not_in_force).
test(the_commencement_day_is_exempt) :-
    research(reference_day_on_commencement, exempt_from_act).
test(processing_not_for_research_is_not_exempt) :-
    research(not_research_purpose, not_exempt).
test(a_decision_specific_use_is_not_exempt) :-
    research(decision_specific_to_data_principal, not_exempt).
test(a_research_standard_not_observed_is_not_exempt) :-
    research(lawful_manner_not_observed, not_exempt).
test(the_intimation_is_not_a_research_standard) :-
    research(intimation_not_given, exempt_from_act).
test(an_unsure_research_purpose_is_referred) :-
    research(research_purpose_unsure, needs_legal_review(open_textured(processing_necessary_for_research_archiving_or_statistical_purposes, cite(in_dpdp_act_2023_s_17_2_b)), [inputs_relied_on([processing_necessary_for_research_archiving_or_statistical_purposes - unsure])])).
test(a_missing_standard_is_named_before_the_referral) :-
    research(lawful_manner_missing_with_research_purpose_unsure, indeterminate([lawful_manner])).
test(section_seven_not_in_force_is_not_in_force) :-
    standards(section_seven_not_in_force, not_in_force).
test(the_day_before_commencement_standards_are_not_in_force) :-
    standards(reference_day_before_commencement, not_in_force).
test(the_commencement_day_standards_are_followed) :-
    standards(reference_day_on_commencement, follows_second_schedule).
test(processing_outside_section_7_b_is_not_applicable) :-
    standards(not_section_seven_b_use, not_applicable).
test(an_unsure_state_use_is_referred) :-
    standards(state_use_unsure, needs_legal_review(open_textured(processing_for_section_7_b_use, cite(in_dpdp_act_2023_s_7_b)), [inputs_relied_on([processing_for_section_7_b_use - unsure])])).
test(a_standard_not_observed_does_not_follow) :-
    standards(intimation_not_given, does_not_follow_second_schedule).
test(an_unsure_state_use_with_a_false_standard_is_referred_at_once) :-
    standards(state_use_unsure_with_intimation_not_given, needs_legal_review(open_textured(processing_for_section_7_b_use, cite(in_dpdp_act_2023_s_7_b)), [inputs_relied_on([processing_for_section_7_b_use - unsure])])).
test(an_unsure_other_standard_is_referred) :-
    standards(other_applicable_standards_unsure, needs_legal_review(open_textured(consistent_with_other_applicable_standards, cite(in_dpdp_rules_2025_sch_2_g_iii)), [inputs_relied_on([consistent_with_other_applicable_standards - unsure])])).
test(section_seventeen_not_in_force_disapplies_nothing) :-
    disapplied(section_seventeen_not_in_force, not_in_force).
test(processing_not_by_the_state_is_not_applicable) :-
    disapplied(not_state_or_instrumentality, not_applicable).
test(an_unsure_state_body_is_referred) :-
    disapplied(state_body_unsure, needs_legal_review(open_textured(processing_by_state_or_instrumentality, cite(in_dpdp_act_2023_s_17_4)), [inputs_relied_on([processing_by_state_or_instrumentality - unsure])])).
test(a_decision_purpose_keeps_section_12_2) :-
    disapplied(purpose_includes_affecting_decision, sections_8_7_and_12_3_do_not_apply).
test(an_unsure_decision_purpose_is_referred) :-
    disapplied(decision_purpose_unsure, needs_legal_review(open_textured(purpose_includes_decision_affecting_data_principal, cite(in_dpdp_act_2023_s_17_4)), [inputs_relied_on([purpose_includes_decision_affecting_data_principal - unsure])])).
test(a_duplicate_key_is_an_input_problem) :-
    research(duplicate_key_given, input_problems([duplicate_key(lawful_manner)])).
test(year_zero_is_an_input_problem) :-
    standards(year_zero, input_problems([wrong_type(reference_date)])).
test(year_ten_thousand_is_answered) :-
    standards(year_ten_thousand, follows_second_schedule).
test(february_twenty_ninth_in_a_common_year_is_an_input_problem) :-
    disapplied(february_twenty_ninth_common_year, input_problems([wrong_type(reference_date)])).
test(february_twenty_ninth_in_a_leap_year_is_answered) :-
    disapplied(february_twenty_ninth_leap_year, sections_8_7_12_2_and_12_3_do_not_apply).

test(section_seventeen_in_force_is_not_not_in_force, fail) :-
    research(complete_processing, not_in_force).
test(the_commencement_day_is_not_not_in_force, fail) :-
    research(reference_day_on_commencement, not_in_force).
test(processing_for_research_is_not_not_exempt, fail) :-
    research(complete_processing, not_exempt).
test(a_decision_specific_use_is_not_exempt_from_the_act, fail) :-
    research(decision_specific_to_data_principal, exempt_from_act).
test(the_intimation_not_given_does_not_make_research_not_exempt, fail) :-
    research(intimation_not_given, not_exempt).
test(a_missing_standard_is_not_referred, fail) :-
    research(lawful_manner_missing_with_research_purpose_unsure, needs_legal_review(_, _)).
test(section_seventeen_not_in_force_leaves_the_standards_in_force, fail) :-
    standards(section_seventeen_not_in_force, not_in_force).
test(the_commencement_day_standards_are_not_not_in_force, fail) :-
    standards(reference_day_on_commencement, not_in_force).
test(an_unsure_state_use_is_not_not_applicable, fail) :-
    standards(state_use_unsure, not_applicable).
test(all_standards_observed_is_not_does_not_follow, fail) :-
    standards(complete_processing, does_not_follow_second_schedule).
test(an_unsure_state_use_with_a_false_standard_is_not_settled, fail) :-
    standards(state_use_unsure_with_intimation_not_given, does_not_follow_second_schedule).
test(an_unsure_other_standard_does_not_follow_the_schedule, fail) :-
    standards(other_applicable_standards_unsure, follows_second_schedule).
test(s_17_4_reads_no_reference_day, fail) :-
    disapplied(reference_day_before_commencement, not_in_force).
test(an_unsure_state_body_is_not_not_applicable, fail) :-
    disapplied(state_body_unsure, not_applicable).
test(a_decision_purpose_does_not_disapply_section_12_2, fail) :-
    disapplied(purpose_includes_affecting_decision, sections_8_7_12_2_and_12_3_do_not_apply).
test(no_decision_purpose_does_not_keep_section_12_2, fail) :-
    disapplied(complete_processing, sections_8_7_and_12_3_do_not_apply).
test(a_well_formed_profile_has_no_input_problem, fail) :-
    research(complete_processing, input_problems(_)).
test(year_ten_thousand_is_not_an_input_problem, fail) :-
    standards(year_ten_thousand, input_problems(_)).
test(february_twenty_ninth_in_a_leap_year_is_not_an_input_problem, fail) :-
    disapplied(february_twenty_ninth_leap_year, input_problems(_)).

cp_test_names([every_named_atom_is_in_the_status_table, the_complete_profile_answers_each_query, section_seventeen_not_in_force_is_not_in_force, the_day_before_commencement_is_not_in_force, the_commencement_day_is_exempt, processing_not_for_research_is_not_exempt, a_decision_specific_use_is_not_exempt, a_research_standard_not_observed_is_not_exempt, the_intimation_is_not_a_research_standard, an_unsure_research_purpose_is_referred, a_missing_standard_is_named_before_the_referral, section_seven_not_in_force_is_not_in_force, the_day_before_commencement_standards_are_not_in_force, the_commencement_day_standards_are_followed, processing_outside_section_7_b_is_not_applicable, an_unsure_state_use_is_referred, a_standard_not_observed_does_not_follow, an_unsure_state_use_with_a_false_standard_is_referred_at_once, an_unsure_other_standard_is_referred, section_seventeen_not_in_force_disapplies_nothing, processing_not_by_the_state_is_not_applicable, an_unsure_state_body_is_referred, a_decision_purpose_keeps_section_12_2, an_unsure_decision_purpose_is_referred, a_duplicate_key_is_an_input_problem, year_zero_is_an_input_problem, year_ten_thousand_is_answered, february_twenty_ninth_in_a_common_year_is_an_input_problem, february_twenty_ninth_in_a_leap_year_is_answered]).
cp_test_fail_names([section_seventeen_in_force_is_not_not_in_force, the_commencement_day_is_not_not_in_force, processing_for_research_is_not_not_exempt, a_decision_specific_use_is_not_exempt_from_the_act, the_intimation_not_given_does_not_make_research_not_exempt, a_missing_standard_is_not_referred, section_seventeen_not_in_force_leaves_the_standards_in_force, the_commencement_day_standards_are_not_not_in_force, an_unsure_state_use_is_not_not_applicable, all_standards_observed_is_not_does_not_follow, an_unsure_state_use_with_a_false_standard_is_not_settled, an_unsure_other_standard_does_not_follow_the_schedule, s_17_4_reads_no_reference_day, an_unsure_state_body_is_not_not_applicable, a_decision_purpose_does_not_disapply_section_12_2, no_decision_purpose_does_not_keep_section_12_2, a_well_formed_profile_has_no_input_problem, year_ten_thousand_is_not_an_input_problem, february_twenty_ninth_in_a_leap_year_is_not_an_input_problem]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
