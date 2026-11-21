% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_nis2_supervision_fines_tests_test_queries, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_nis2_supervision_fines_queries, [nis2_supervision_fines_profile_keys/1, nis2_supervision_fines_what_if/4, entity_class/0, essential/0, important/0, other/0, unsure/0]).
:- use_module(m__eu_nis2_supervision_fines_kernel, [nis2_supervision_fines_input_problems/2]).
:- use_module(m__eu_nis2_supervision_fines_fixtures, [nis2_supervision_fines_profile_for/2]).

test(profile_keys_are_the_contract_keys) :-
    nis2_supervision_fines_profile_keys(ProfileKeys),
    ProfileKeys == [entity_class, infringed_provision, worldwide_annual_turnover_eur, entity_is_public_administration, earlier_measures_ineffective, deadline_set_for_necessary_action, required_action_taken_within_deadline, infringement_may_entail_notifiable_personal_data_breach, authority_became_aware_in_supervision_or_enforcement, data_protection_authority_in_other_member_state, gdpr_fine_imposed_under_art_58_2_i, gdpr_fine_for_same_conduct].
test(root_export_atoms_are_reachable) :-
    entity_class,
    essential,
    important,
    other,
    unsure.
test(the_reexported_input_check_passes_a_fixture) :-
    nis2_supervision_fines_profile_for(escalation_exercisable, Profile),
    nis2_supervision_fines_input_problems(Profile, []).
test(what_if_a_public_administration_entity_flips_to_ineligible) :-
    what_if_statuses(escalation_exercisable, entity_is_public_administration, true, Statuses),
    Statuses == [ineligible].
test(what_if_the_unsure_judgement_is_decided_resolves_to_eligible) :-
    what_if_statuses(escalation_measures_unsure, earlier_measures_ineffective, true, Statuses),
    Statuses == [eligible].
test(what_if_the_judgement_turns_unsure_is_indeterminate) :-
    what_if_statuses(escalation_exercisable, earlier_measures_ineffective, unsure, Statuses),
    Statuses == [indeterminate].
test(what_if_the_absent_class_is_important_is_ineligible) :-
    what_if_statuses(escalation_class_absent, entity_class, important, Statuses),
    Statuses == [ineligible].
test(what_if_repairs_a_wrong_type) :-
    what_if_statuses(invalid_crisp_key_unsure, entity_is_public_administration, false, Statuses),
    Statuses == [eligible].
test(what_if_cannot_edit_a_non_list) :-
    what_if_statuses(invalid_not_a_list, entity_class, essential, Statuses),
    Statuses == [invalid_profile].
test(what_if_adding_an_unknown_key_is_invalid_profile) :-
    what_if_statuses(escalation_exercisable, colour, red, Statuses),
    Statuses == [invalid_profile].
test(what_if_repairs_a_duplicate_key) :-
    findall(Status, nis2_supervision_fines_what_if([attribute(entity_class, important), attribute(entity_class, essential), attribute(entity_is_public_administration, false), attribute(earlier_measures_ineffective, true), attribute(deadline_set_for_necessary_action, true), attribute(required_action_taken_within_deadline, false)], entity_class, essential, Status), Statuses),
    Statuses == [eligible].

what_if_statuses(Subject, OverriddenKey, NewValue, Statuses) :-
    nis2_supervision_fines_profile_for(Subject, Profile),
    findall(Status, nis2_supervision_fines_what_if(Profile, OverriddenKey, NewValue, Status), Statuses).

test(what_if_a_public_administration_entity_is_not_eligible, fail) :-
    nis2_supervision_fines_profile_for(escalation_exercisable, Profile),
    nis2_supervision_fines_what_if(Profile, entity_is_public_administration, true, eligible).

cp_test_names([profile_keys_are_the_contract_keys, root_export_atoms_are_reachable, the_reexported_input_check_passes_a_fixture, what_if_a_public_administration_entity_flips_to_ineligible, what_if_the_unsure_judgement_is_decided_resolves_to_eligible, what_if_the_judgement_turns_unsure_is_indeterminate, what_if_the_absent_class_is_important_is_ineligible, what_if_repairs_a_wrong_type, what_if_cannot_edit_a_non_list, what_if_adding_an_unknown_key_is_invalid_profile, what_if_repairs_a_duplicate_key]).
cp_test_fail_names([what_if_a_public_administration_entity_is_not_eligible]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
