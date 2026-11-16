% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_nis2_supervision_fines_tests_test_input_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_nis2_supervision_fines_nis2_supervision_fines, [nis2_supervision_fines_status/2, fine_ceiling_floor/3, minimum_powers/2, escalation_powers_exercisable/3, fine_barred_by_gdpr_fine/3, data_protection_authority_information/2]).
:- use_module(m__eu_nis2_supervision_fines_kernel, [nis2_supervision_fines_input_problems/2]).
:- use_module(m__eu_nis2_supervision_fines_fixtures, [nis2_supervision_fines_profile_for/2]).

test(status_holds_with_the_verdict_bound) :-
    nis2_supervision_fines_profile_for(escalation_exercisable, Profile),
    nis2_supervision_fines_status(Profile, eligible).
test(near_miss_status_bound_ineligible) :-
    nis2_supervision_fines_profile_for(escalation_action_taken_within_deadline, Profile),
    nis2_supervision_fines_status(Profile, ineligible).
test(ceiling_bound_at_the_essential_tie) :-
    nis2_supervision_fines_profile_for(essential_fine_at_tie, Profile),
    fine_ceiling_floor(Profile, minimum_national_maximum(10000000, fixed_amount), [cite(eu_dir_2022_2555_art_34_4)]).
test(escalation_bound_reason) :-
    nis2_supervision_fines_profile_for(escalation_no_deadline_set, Profile),
    escalation_powers_exercisable(Profile, not_exercisable(no_deadline_set), [cite(eu_dir_2022_2555_art_32_5)]).
test(fine_bar_bound) :-
    nis2_supervision_fines_profile_for(gdpr_fine_barred, Profile),
    fine_barred_by_gdpr_fine(Profile, fine_barred, [cite(eu_dir_2022_2555_art_35_2)]).
test(duty_bound_empty_when_not_aware) :-
    nis2_supervision_fines_profile_for(information_not_aware, Profile),
    data_protection_authority_information(Profile, []).
test(an_atom_profile_is_not_a_profile) :-
    escalation_powers_exercisable(not_a_profile, input_problems([wrong_type(profile)]), []).
test(a_compound_value_is_wrong_type) :-
    nis2_supervision_fines_input_problems([attribute(entity_class, essential(entity))], [wrong_type(entity_class)]).
test(a_non_list_profile_is_refused_by_every_query) :-
    fine_ceiling_floor(essential, input_problems([wrong_type(profile)]), []),
    minimum_powers(essential, input_problems([wrong_type(profile)])),
    escalation_powers_exercisable(essential, input_problems([wrong_type(profile)]), []),
    fine_barred_by_gdpr_fine(essential, input_problems([wrong_type(profile)]), []),
    data_protection_authority_information(essential, input_problems([wrong_type(profile)])).
test(a_key_the_query_does_not_read_is_still_checked) :-
    escalation_powers_exercisable([attribute(entity_class, important), attribute(gdpr_fine_for_same_conduct, banana)], input_problems([wrong_type(gdpr_fine_for_same_conduct)]), []).
test(a_string_boolean_is_wrong_type) :-
    nis2_supervision_fines_input_problems([attribute(deadline_set_for_necessary_action, yes)], [wrong_type(deadline_set_for_necessary_action)]).
test(attribute_order_does_not_change_the_answer) :-
    escalation_powers_exercisable([attribute(required_action_taken_within_deadline, false), attribute(deadline_set_for_necessary_action, true), attribute(earlier_measures_ineffective, true), attribute(entity_is_public_administration, false), attribute(entity_class, essential)], exercisable, [cite(eu_dir_2022_2555_art_32_5)]).
test(duplicate_key_with_equal_values_is_a_problem) :-
    fine_barred_by_gdpr_fine([attribute(infringed_provision, other), attribute(infringed_provision, other)], input_problems([duplicate_key(infringed_provision)]), []).

test(the_wrong_bound_status_is_rejected, fail) :-
    nis2_supervision_fines_profile_for(escalation_exercisable, Profile),
    nis2_supervision_fines_status(Profile, ineligible).
test(ceiling_bound_with_the_wrong_basis_is_rejected, fail) :-
    nis2_supervision_fines_profile_for(essential_fine_at_tie, Profile),
    fine_ceiling_floor(Profile, minimum_national_maximum(_, turnover_percentage), _).

cp_test_names([status_holds_with_the_verdict_bound, near_miss_status_bound_ineligible, ceiling_bound_at_the_essential_tie, escalation_bound_reason, fine_bar_bound, duty_bound_empty_when_not_aware, an_atom_profile_is_not_a_profile, a_compound_value_is_wrong_type, a_non_list_profile_is_refused_by_every_query, a_key_the_query_does_not_read_is_still_checked, a_string_boolean_is_wrong_type, attribute_order_does_not_change_the_answer, duplicate_key_with_equal_values_is_a_problem]).
cp_test_fail_names([the_wrong_bound_status_is_rejected, ceiling_bound_with_the_wrong_basis_is_rejected]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
