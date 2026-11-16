% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_nis2_supervision_fines_tests_test_negative_controls, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_nis2_supervision_fines_nis2_supervision_fines, [nis2_supervision_fines_status/2, nis2_supervision_fines_status_values/1, fine_ceiling_floor/3, minimum_powers/2, escalation_powers_exercisable/3, fine_barred_by_gdpr_fine/3, data_protection_authority_information/2]).
:- use_module(m__eu_nis2_supervision_fines_kernel, [nis2_supervision_fines_input_problems/2]).
:- use_module(m__eu_nis2_supervision_fines_fixtures, [nis2_supervision_fines_profile_for/2]).

test(the_verdict_atoms_are_real_verdict_atoms) :-
    nis2_supervision_fines_status_values(StatusValues),
    member(eligible, StatusValues),
    member(ineligible, StatusValues).
test(exercisable_profile_is_eligible) :-
    nis2_supervision_fines_profile_for(escalation_exercisable, Profile),
    nis2_supervision_fines_status(Profile, eligible).
test(action_taken_gives_its_reason) :-
    nis2_supervision_fines_profile_for(escalation_action_taken_within_deadline, Profile),
    escalation_powers_exercisable(Profile, not_exercisable(action_taken_within_deadline), _).
test(public_administration_gives_its_reason) :-
    nis2_supervision_fines_profile_for(escalation_public_administration_entity, Profile),
    escalation_powers_exercisable(Profile, not_exercisable(public_administration_entity), _).
test(effective_measures_give_their_reason) :-
    nis2_supervision_fines_profile_for(escalation_measures_not_ineffective, Profile),
    escalation_powers_exercisable(Profile, not_exercisable(measures_not_ineffective), _).
test(no_deadline_gives_its_reason) :-
    nis2_supervision_fines_profile_for(escalation_no_deadline_set, Profile),
    escalation_powers_exercisable(Profile, not_exercisable(no_deadline_set), _).
test(unsure_measures_refer) :-
    nis2_supervision_fines_profile_for(escalation_measures_unsure, Profile),
    escalation_powers_exercisable(Profile, needs_legal_review(open_textured(earlier_measures_ineffective, cite(eu_dir_2022_2555_art_32_5)), _), []).
test(essential_above_tie_is_turnover_percentage) :-
    nis2_supervision_fines_profile_for(essential_fine_above_tie, Profile),
    fine_ceiling_floor(Profile, minimum_national_maximum(10000001, turnover_percentage), _).
test(important_above_tie_is_turnover_percentage) :-
    nis2_supervision_fines_profile_for(important_fine_above_tie, Profile),
    fine_ceiling_floor(Profile, minimum_national_maximum(7000001, turnover_percentage), _).
test(other_infringement_has_no_union_minimum) :-
    nis2_supervision_fines_profile_for(other_infringement, Profile),
    fine_ceiling_floor(Profile, no_union_minimum, _).
test(essential_non_public_administration_has_escalation_powers) :-
    minimum_powers([attribute(entity_class, essential), attribute(entity_is_public_administration, false)], Powers),
    member(power(escalation, suspend_certification_or_authorisation, cite(eu_dir_2022_2555_art_32_5_a)), Powers).
test(essential_has_a_monitoring_officer) :-
    minimum_powers([attribute(entity_class, essential), attribute(entity_is_public_administration, true)], Powers),
    member(power(enforcement, monitoring_officer, cite(eu_dir_2022_2555_art_32_4_g)), Powers).
test(same_conduct_bars_the_fine) :-
    nis2_supervision_fines_profile_for(gdpr_fine_barred, Profile),
    fine_barred_by_gdpr_fine(Profile, fine_barred, _).
test(not_same_conduct_is_not_barred) :-
    nis2_supervision_fines_profile_for(gdpr_not_same_conduct, Profile),
    fine_barred_by_gdpr_fine(Profile, fine_not_barred, [cite(eu_dir_2022_2555_art_35_2)]).
test(other_member_state_adds_the_own_authority) :-
    nis2_supervision_fines_profile_for(information_other_member_state, Profile),
    data_protection_authority_information(Profile, [_, inform_supervisory_authority_in_own_member_state(cite(eu_dir_2022_2555_art_35_3))]).
test(own_member_state_duty) :-
    nis2_supervision_fines_profile_for(information_own_member_state, Profile),
    data_protection_authority_information(Profile, [inform_gdpr_supervisory_authorities(cite(eu_dir_2022_2555_art_35_1))]).
test(a_clean_profile_has_no_problem) :-
    nis2_supervision_fines_profile_for(escalation_exercisable, Profile),
    nis2_supervision_fines_input_problems(Profile, []).

test(action_taken_is_not_eligible, fail) :-
    nis2_supervision_fines_profile_for(escalation_action_taken_within_deadline, Profile),
    nis2_supervision_fines_status(Profile, eligible).
test(public_administration_is_not_exercisable, fail) :-
    nis2_supervision_fines_profile_for(escalation_public_administration_entity, Profile),
    escalation_powers_exercisable(Profile, exercisable, _).
test(effective_measures_are_not_exercisable, fail) :-
    nis2_supervision_fines_profile_for(escalation_measures_not_ineffective, Profile),
    escalation_powers_exercisable(Profile, exercisable, _).
test(no_deadline_is_not_exercisable, fail) :-
    nis2_supervision_fines_profile_for(escalation_no_deadline_set, Profile),
    escalation_powers_exercisable(Profile, exercisable, _).
test(unsure_measures_are_not_eligible, fail) :-
    nis2_supervision_fines_profile_for(escalation_measures_unsure, Profile),
    nis2_supervision_fines_status(Profile, eligible).
test(essential_at_tie_is_not_turnover_percentage, fail) :-
    nis2_supervision_fines_profile_for(essential_fine_at_tie, Profile),
    fine_ceiling_floor(Profile, minimum_national_maximum(_, turnover_percentage), _).
test(important_at_tie_is_not_turnover_percentage, fail) :-
    nis2_supervision_fines_profile_for(important_fine_at_tie, Profile),
    fine_ceiling_floor(Profile, minimum_national_maximum(_, turnover_percentage), _).
test(art_21_infringement_has_a_union_minimum, fail) :-
    nis2_supervision_fines_profile_for(important_fine_above_tie, Profile),
    fine_ceiling_floor(Profile, no_union_minimum, _).
test(essential_public_administration_has_no_escalation_power, fail) :-
    minimum_powers([attribute(entity_class, essential), attribute(entity_is_public_administration, true)], Powers),
    member(power(escalation, _, _), Powers).
test(important_has_no_monitoring_officer, fail) :-
    minimum_powers([attribute(entity_class, important)], Powers),
    member(power(enforcement, monitoring_officer, _), Powers).
test(not_same_conduct_does_not_bar, fail) :-
    nis2_supervision_fines_profile_for(gdpr_not_same_conduct, Profile),
    fine_barred_by_gdpr_fine(Profile, fine_barred, _).
test(own_member_state_has_one_duty_only, fail) :-
    nis2_supervision_fines_profile_for(information_own_member_state, Profile),
    data_protection_authority_information(Profile, [_, _]).
test(not_aware_has_no_duty_to_inform, fail) :-
    nis2_supervision_fines_profile_for(information_not_aware, Profile),
    data_protection_authority_information(Profile, [_|_]).
test(a_duplicated_key_is_not_clean, fail) :-
    nis2_supervision_fines_profile_for(duplicate_entity_class, Profile),
    nis2_supervision_fines_input_problems(Profile, []).

cp_test_names([the_verdict_atoms_are_real_verdict_atoms, exercisable_profile_is_eligible, action_taken_gives_its_reason, public_administration_gives_its_reason, effective_measures_give_their_reason, no_deadline_gives_its_reason, unsure_measures_refer, essential_above_tie_is_turnover_percentage, important_above_tie_is_turnover_percentage, other_infringement_has_no_union_minimum, essential_non_public_administration_has_escalation_powers, essential_has_a_monitoring_officer, same_conduct_bars_the_fine, not_same_conduct_is_not_barred, other_member_state_adds_the_own_authority, own_member_state_duty, a_clean_profile_has_no_problem]).
cp_test_fail_names([action_taken_is_not_eligible, public_administration_is_not_exercisable, effective_measures_are_not_exercisable, no_deadline_is_not_exercisable, unsure_measures_are_not_eligible, essential_at_tie_is_not_turnover_percentage, important_at_tie_is_not_turnover_percentage, art_21_infringement_has_a_union_minimum, essential_public_administration_has_no_escalation_power, important_has_no_monitoring_officer, not_same_conduct_does_not_bar, own_member_state_has_one_duty_only, not_aware_has_no_duty_to_inform, a_duplicated_key_is_not_clean]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
