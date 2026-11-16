% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_nis2_implementing_regulation_significant_incidents_tests_test_input_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_nis2_implementing_regulation_significant_incidents_nis2_implementing_regulation_significant_incidents, [significant_incident_criteria/3, nis2_implementing_regulation_significant_incidents_status/2, nis2_implementing_regulation_significant_incidents_status_values/1]).
:- use_module(m__eu_nis2_implementing_regulation_significant_incidents_kernel, [nis2_implementing_regulation_significant_incidents_input_problems/2]).
:- use_module(m__eu_nis2_implementing_regulation_significant_incidents_fixtures, [nis2_implementing_regulation_significant_incidents_profile_for/2]).

test(significant_holds_with_result_and_citations_bound) :-
    nis2_implementing_regulation_significant_incidents_profile_for(loss_above_floor_not_scheduled, Profile),
    significant_incident_criteria(Profile, significant, [cite(eu_reg_2024_2690_art_3_1)]).
test(not_significant_holds_with_result_and_citations_bound) :-
    nis2_implementing_regulation_significant_incidents_profile_for(scheduled_maintenance_with_loss, Profile),
    significant_incident_criteria(Profile, not_significant, [cite(eu_reg_2024_2690_art_3_1), cite(eu_reg_2024_2690_art_3_2)]).
test(indeterminate_holds_with_the_missing_key_bound) :-
    nis2_implementing_regulation_significant_incidents_profile_for(loss_above_floor_scheduled_absent, Profile),
    significant_incident_criteria(Profile, indeterminate([scheduled_interruption_or_maintenance]), []).
test(referral_holds_with_the_judgement_bound) :-
    nis2_implementing_regulation_significant_incidents_profile_for(death_unsure_decisive, Profile),
    nis2_implementing_regulation_significant_incidents_status(Profile, needs_legal_review(open_textured(death_of_natural_person, cite(eu_reg_2024_2690_art_3_1_c)), _)).
test(only_the_baseline_status_of_the_table_holds) :-
    nis2_implementing_regulation_significant_incidents_profile_for(loss_above_floor_not_scheduled, Profile),
    nis2_implementing_regulation_significant_incidents_status_values(StatusValues),
    findall(Status, (member(Status, StatusValues), nis2_implementing_regulation_significant_incidents_status(Profile, Status)), HeldStatuses),
    HeldStatuses == [significant].
test(unbound_profile_is_not_an_attribute_list) :-
    findall(Result - Citations, significant_incident_criteria(_UnboundProfile, Result, Citations), Answers),
    Answers == [input_problems([wrong_type(profile)]) - []].
test(unbound_profile_gives_exactly_one_answer) :-
    findall(Result - Citations, significant_incident_criteria(_UnboundProfile, Result, Citations), Answers),
    length(Answers, 1).
test(partial_list_is_not_an_attribute_list) :-
    findall(Problems, nis2_implementing_regulation_significant_incidents_input_problems([attribute(death_of_natural_person, true)|_Tail], Problems), Answers),
    Answers == [[wrong_type(profile)]].
test(non_attribute_element_is_not_an_attribute_list) :-
    nis2_implementing_regulation_significant_incidents_profile_for(profile_not_attribute_list, Profile),
    significant_incident_criteria(Profile, Result, Citations),
    Result == input_problems([wrong_type(profile)]),
    Citations == [].
test(an_atom_is_not_an_attribute_list) :-
    nis2_implementing_regulation_significant_incidents_input_problems(not_a_profile, Problems),
    Problems == [wrong_type(profile)].
test(unbound_value_is_wrong_type) :-
    findall(Problems, nis2_implementing_regulation_significant_incidents_input_problems([attribute(death_of_natural_person, _UnboundValue)], Problems), Answers),
    Answers == [[wrong_type(death_of_natural_person)]].
test(non_atom_key_is_unknown_as_given) :-
    nis2_implementing_regulation_significant_incidents_input_problems([attribute(42, true)], Problems),
    Problems == [unknown_key(42)].
test(crisp_key_given_unsure_is_wrong_type) :-
    nis2_implementing_regulation_significant_incidents_input_problems([attribute(scheduled_interruption_or_maintenance, unsure)], Problems),
    Problems == [wrong_type(scheduled_interruption_or_maintenance)].
test(negative_figure_is_wrong_type) :-
    nis2_implementing_regulation_significant_incidents_input_problems([attribute(complete_unavailability_seconds, -1)], Problems),
    Problems == [wrong_type(complete_unavailability_seconds)].
test(float_figure_is_wrong_type) :-
    nis2_implementing_regulation_significant_incidents_profile_for(wrong_type_float_loss, Profile),
    significant_incident_criteria(Profile, Result, Citations),
    Result == input_problems([wrong_type(direct_financial_loss_euro_cents)]),
    Citations == [].
test(entity_type_outside_its_atoms_is_wrong_type) :-
    nis2_implementing_regulation_significant_incidents_input_problems([attribute(relevant_entity_type, bank)], Problems),
    Problems == [wrong_type(relevant_entity_type)].
test(judgement_outside_its_atoms_is_wrong_type) :-
    nis2_implementing_regulation_significant_incidents_input_problems([attribute(data_compromised, maybe)], Problems),
    Problems == [wrong_type(data_compromised)].
test(judgement_unsure_is_well_formed) :-
    nis2_implementing_regulation_significant_incidents_input_problems([attribute(data_compromised, unsure)], Problems),
    Problems == [].
test(duplicate_with_equal_values_is_duplicate_only) :-
    nis2_implementing_regulation_significant_incidents_input_problems([attribute(death_of_natural_person, true), attribute(death_of_natural_person, true)], Problems),
    Problems == [duplicate_key(death_of_natural_person)].
test(duplicate_with_bad_values_is_never_also_wrong_type) :-
    nis2_implementing_regulation_significant_incidents_input_problems([attribute(death_of_natural_person, maybe), attribute(death_of_natural_person, 7)], Problems),
    Problems == [duplicate_key(death_of_natural_person)].
test(repeated_unknown_key_is_named_once) :-
    nis2_implementing_regulation_significant_incidents_input_problems([attribute(colour, blue), attribute(colour, red)], Problems),
    Problems == [unknown_key(colour)].
test(problems_follow_contract_order_then_unknown_keys) :-
    nis2_implementing_regulation_significant_incidents_input_problems([attribute(colour, blue), attribute(managed_domain_names, -1), attribute(scheduled_interruption_or_maintenance, unsure)], Problems),
    Problems == [wrong_type(scheduled_interruption_or_maintenance), wrong_type(managed_domain_names), unknown_key(colour)].
test(duplicate_and_unknown_keys_in_the_result_position) :-
    nis2_implementing_regulation_significant_incidents_profile_for(duplicate_and_unknown_keys, Profile),
    significant_incident_criteria(Profile, Result, Citations),
    Result == input_problems([duplicate_key(scheduled_interruption_or_maintenance), unknown_key(colour)]),
    Citations == [].
test(input_check_gives_the_bare_list) :-
    nis2_implementing_regulation_significant_incidents_input_problems([attribute(colour, blue)], Problems),
    Problems == [unknown_key(colour)].
test(well_formed_profile_has_no_problem) :-
    nis2_implementing_regulation_significant_incidents_profile_for(all_criteria_closed_dns, Profile),
    nis2_implementing_regulation_significant_incidents_input_problems(Profile, Problems),
    Problems == [].
test(empty_profile_has_no_problem) :-
    nis2_implementing_regulation_significant_incidents_input_problems([], Problems),
    Problems == [].

test(significant_profile_rejects_not_significant_bound, fail) :-
    nis2_implementing_regulation_significant_incidents_profile_for(loss_above_floor_not_scheduled, Profile),
    significant_incident_criteria(Profile, not_significant, _).
test(significant_profile_rejects_the_not_significant_citations, fail) :-
    nis2_implementing_regulation_significant_incidents_profile_for(loss_above_floor_not_scheduled, Profile),
    significant_incident_criteria(Profile, significant, [cite(eu_reg_2024_2690_art_3_1), cite(eu_reg_2024_2690_art_3_2)]).
test(scheduled_profile_rejects_significant_bound, fail) :-
    nis2_implementing_regulation_significant_incidents_profile_for(scheduled_maintenance_with_loss, Profile),
    significant_incident_criteria(Profile, significant, _).
test(indeterminate_rejects_another_missing_key_bound, fail) :-
    nis2_implementing_regulation_significant_incidents_profile_for(loss_above_floor_scheduled_absent, Profile),
    nis2_implementing_regulation_significant_incidents_status(Profile, indeterminate([annual_turnover_preceding_financial_year_euro_cents])).
test(referral_rejects_another_judgement_bound, fail) :-
    nis2_implementing_regulation_significant_incidents_profile_for(death_unsure_decisive, Profile),
    nis2_implementing_regulation_significant_incidents_status(Profile, needs_legal_review(open_textured(considerable_damage_to_natural_person_health, _), _)).

cp_test_names([significant_holds_with_result_and_citations_bound, not_significant_holds_with_result_and_citations_bound, indeterminate_holds_with_the_missing_key_bound, referral_holds_with_the_judgement_bound, only_the_baseline_status_of_the_table_holds, unbound_profile_is_not_an_attribute_list, unbound_profile_gives_exactly_one_answer, partial_list_is_not_an_attribute_list, non_attribute_element_is_not_an_attribute_list, an_atom_is_not_an_attribute_list, unbound_value_is_wrong_type, non_atom_key_is_unknown_as_given, crisp_key_given_unsure_is_wrong_type, negative_figure_is_wrong_type, float_figure_is_wrong_type, entity_type_outside_its_atoms_is_wrong_type, judgement_outside_its_atoms_is_wrong_type, judgement_unsure_is_well_formed, duplicate_with_equal_values_is_duplicate_only, duplicate_with_bad_values_is_never_also_wrong_type, repeated_unknown_key_is_named_once, problems_follow_contract_order_then_unknown_keys, duplicate_and_unknown_keys_in_the_result_position, input_check_gives_the_bare_list, well_formed_profile_has_no_problem, empty_profile_has_no_problem]).
cp_test_fail_names([significant_profile_rejects_not_significant_bound, significant_profile_rejects_the_not_significant_citations, scheduled_profile_rejects_significant_bound, indeterminate_rejects_another_missing_key_bound, referral_rejects_another_judgement_bound]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
