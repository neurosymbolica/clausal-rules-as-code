% SPDX-License-Identifier: EUPL-1.2
:- module(m__ind_dpdp_research_state_processing_tests_test_queries, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__ind_dpdp_research_state_processing_queries, [dpdp_research_state_processing_profile_keys/1, dpdp_research_state_processing_what_if/4, indeterminate/1, needs_legal_review/2, open_textured/2, inputs_relied_on/1, input_problems/1, wrong_type/1, duplicate_key/1]).
:- use_module(m__ind_dpdp_research_state_processing_kernel, [dpdp_research_state_processing_input_problems/2]).
:- use_module(m__ind_dpdp_research_state_processing_dpdp_research_state_processing, [dpdp_research_state_processing_status/2, dpdp_research_state_processing_checklist/2]).
:- use_module(m__ind_dpdp_research_state_processing_fixtures, [dpdp_research_state_processing_profile_for/2]).

test(profile_keys_are_the_contract_keys) :-
    dpdp_research_state_processing_profile_keys(ProfileKeys),
    ProfileKeys == [section_7_in_force_on_reference_date, section_17_in_force_on_reference_date, reference_date, processing_necessary_for_research_archiving_or_statistical_purposes, personal_data_to_be_used_for_decision_specific_to_data_principal, processing_for_section_7_b_use, lawful_manner, limited_to_necessary_personal_data, completeness_accuracy_and_consistency, retention_only_while_required, reasonable_security_safeguards, intimation_to_data_principal, business_contact_for_questions, link_and_means_to_exercise_rights, consistent_with_other_applicable_standards, accountability_for_observance, processing_by_state_or_instrumentality, purpose_includes_decision_affecting_data_principal].
test(the_re_exported_input_check_answers) :-
    dpdp_research_state_processing_input_problems([attribute(colour, red)], [unknown_key(colour)]).
test(what_if_a_standard_is_not_observed) :-
    dpdp_research_state_processing_profile_for(complete_processing, Profile),
    dpdp_research_state_processing_what_if(Profile, lawful_manner, false, determinations(not_exempt, does_not_follow_second_schedule, sections_8_7_12_2_and_12_3_do_not_apply)).
test(what_if_the_purpose_includes_a_decision) :-
    dpdp_research_state_processing_profile_for(complete_processing, Profile),
    dpdp_research_state_processing_what_if(Profile, purpose_includes_decision_affecting_data_principal, true, determinations(exempt_from_act, follows_second_schedule, sections_8_7_and_12_3_do_not_apply)).
test(what_if_the_day_moves_before_commencement) :-
    dpdp_research_state_processing_profile_for(complete_processing, Profile),
    dpdp_research_state_processing_what_if(Profile, reference_date, date(2027, 5, 12), determinations(not_in_force, not_in_force, sections_8_7_12_2_and_12_3_do_not_apply)).
test(what_if_an_unsure_judgement_stays_unsure_and_is_referred) :-
    dpdp_research_state_processing_profile_for(complete_processing, Profile),
    dpdp_research_state_processing_what_if(Profile, lawful_manner, unsure, determinations(Referral, Referral, sections_8_7_12_2_and_12_3_do_not_apply)),
    Referral == needs_legal_review(open_textured(lawful_manner, cite(in_dpdp_rules_2025_sch_2_a)), [inputs_relied_on([lawful_manner - unsure])]).
test(what_if_adds_an_absent_key) :-
    dpdp_research_state_processing_what_if([], section_17_in_force_on_reference_date, false, determinations(not_in_force, indeterminate([section_7_in_force_on_reference_date]), not_in_force)).
test(what_if_a_value_outside_its_type_is_an_input_problem) :-
    dpdp_research_state_processing_profile_for(complete_processing, Profile),
    dpdp_research_state_processing_what_if(Profile, lawful_manner, maybe, determinations(input_problems([wrong_type(lawful_manner)]), input_problems([wrong_type(lawful_manner)]), input_problems([wrong_type(lawful_manner)]))).
test(what_if_yields_exactly_one_status) :-
    dpdp_research_state_processing_profile_for(complete_processing, Profile),
    findall(Status, dpdp_research_state_processing_what_if(Profile, intimation_to_data_principal, false, Status), Statuses),
    Statuses == [determinations(exempt_from_act, does_not_follow_second_schedule, sections_8_7_12_2_and_12_3_do_not_apply)].
test(what_if_the_same_value_keeps_the_status) :-
    dpdp_research_state_processing_profile_for(complete_processing, Profile),
    dpdp_research_state_processing_status(Profile, Status),
    dpdp_research_state_processing_what_if(Profile, lawful_manner, true, Status).
test(the_checklist_cites_each_row) :-
    dpdp_research_state_processing_profile_for(complete_processing, Profile),
    dpdp_research_state_processing_checklist(Profile, [item(research_exemption, exempt_from_act, [_|_]), item(state_processing_standards, follows_second_schedule, [_|_]), item(state_processing_disapplied_provisions, sections_8_7_12_2_and_12_3_do_not_apply, [cite(in_dpdp_act_2023_s_17_4)])]).
test(the_status_is_one_verdict) :-
    dpdp_research_state_processing_profile_for(not_state_or_instrumentality, Profile),
    findall(Status, dpdp_research_state_processing_status(Profile, Status), Statuses),
    Statuses == [determinations(exempt_from_act, follows_second_schedule, not_applicable)].
test(the_constructors_recognise_their_terms) :-
    indeterminate([reference_date]),
    open_textured(lawful_manner, cite(in_dpdp_rules_2025_sch_2_a)),
    inputs_relied_on([lawful_manner - unsure]),
    needs_legal_review(open_textured(lawful_manner, cite(in_dpdp_rules_2025_sch_2_a)), [inputs_relied_on([lawful_manner - unsure])]),
    input_problems([wrong_type(lawful_manner)]),
    wrong_type(lawful_manner),
    duplicate_key(lawful_manner).

test(indeterminate_takes_a_list, fail) :-
    indeterminate(reference_date).

cp_test_names([profile_keys_are_the_contract_keys, the_re_exported_input_check_answers, what_if_a_standard_is_not_observed, what_if_the_purpose_includes_a_decision, what_if_the_day_moves_before_commencement, what_if_an_unsure_judgement_stays_unsure_and_is_referred, what_if_adds_an_absent_key, what_if_a_value_outside_its_type_is_an_input_problem, what_if_yields_exactly_one_status, what_if_the_same_value_keeps_the_status, the_checklist_cites_each_row, the_status_is_one_verdict, the_constructors_recognise_their_terms]).
cp_test_fail_names([indeterminate_takes_a_list]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
