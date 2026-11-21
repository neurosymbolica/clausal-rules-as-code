% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_nis2_supervision_fines_tests_test_negative_controls, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_nis2_supervision_fines_nis2_supervision_fines, [nis2_supervision_fines_status/2, nis2_supervision_fines_status_values/1, fine_ceiling_floor/3, minimum_powers/2, escalation_powers_exercisable/3, fine_barred_by_gdpr_fine/3, data_protection_authority_information/2]).
:- use_module(m__eu_nis2_supervision_fines_fixtures, [nis2_supervision_fines_profile_for/2]).

test(the_near_miss_atoms_are_table_statuses) :-
    nis2_supervision_fines_status_values(StatusValues),
    member(eligible, StatusValues),
    member(ineligible, StatusValues),
    member(indeterminate, StatusValues),
    member(invalid_profile, StatusValues).
test(route_exercisable_positive) :-
    nis2_supervision_fines_profile_for(escalation_exercisable, Profile),
    escalation_powers_exercisable(Profile, exercisable, [cite(eu_dir_2022_2555_art_32_5)]).
test(route_exercisable_near_miss_action_taken_is_ineligible) :-
    nis2_supervision_fines_profile_for(escalation_action_taken_within_deadline, Profile),
    nis2_supervision_fines_status(Profile, ineligible).
test(route_public_administration_positive) :-
    nis2_supervision_fines_profile_for(escalation_public_administration_entity, Profile),
    escalation_powers_exercisable(Profile, not_exercisable(public_administration_entity), _).
test(route_important_entity_positive) :-
    nis2_supervision_fines_profile_for(escalation_important_entity, Profile),
    escalation_powers_exercisable(Profile, not_exercisable(important_entity), [cite(eu_dir_2022_2555_art_32_5)]).
test(route_measures_not_ineffective_positive) :-
    nis2_supervision_fines_profile_for(escalation_measures_not_ineffective, Profile),
    escalation_powers_exercisable(Profile, not_exercisable(measures_not_ineffective), _).
test(route_no_deadline_positive) :-
    nis2_supervision_fines_profile_for(escalation_no_deadline_set, Profile),
    escalation_powers_exercisable(Profile, not_exercisable(no_deadline_set), _).
test(route_referral_positive) :-
    nis2_supervision_fines_profile_for(escalation_measures_unsure, Profile),
    escalation_powers_exercisable(Profile, needs_legal_review(open_textured(earlier_measures_ineffective, cite(eu_dir_2022_2555_art_32_5)), _), []).
test(route_absent_class_positive) :-
    nis2_supervision_fines_profile_for(escalation_class_absent, Profile),
    escalation_powers_exercisable(Profile, indeterminate([entity_class]), []).
test(route_absent_class_near_miss_failing_condition_settles) :-
    nis2_supervision_fines_profile_for(escalation_class_absent_action_taken, Profile),
    escalation_powers_exercisable(Profile, not_exercisable(action_taken_within_deadline), _).
test(route_absent_deadline_positive) :-
    nis2_supervision_fines_profile_for(escalation_deadline_absent, Profile),
    escalation_powers_exercisable(Profile, indeterminate([deadline_set_for_necessary_action]), []).
test(route_essential_tie_is_fixed_amount) :-
    nis2_supervision_fines_profile_for(fine_floor_essential_at_tie, Profile),
    fine_ceiling_floor(Profile, minimum_national_maximum(10000000, fixed_amount), _).
test(route_essential_one_euro_above_is_turnover_percentage) :-
    nis2_supervision_fines_profile_for(fine_floor_essential_one_euro_above_tie, Profile),
    fine_ceiling_floor(Profile, minimum_national_maximum(10000001, turnover_percentage), _).
test(route_important_tie_is_fixed_amount) :-
    nis2_supervision_fines_profile_for(fine_floor_important_at_tie, Profile),
    fine_ceiling_floor(Profile, minimum_national_maximum(7000000, fixed_amount), [cite(eu_dir_2022_2555_art_34_5)]).
test(route_important_one_euro_above_is_turnover_percentage) :-
    nis2_supervision_fines_profile_for(fine_floor_important_one_euro_above_tie, Profile),
    fine_ceiling_floor(Profile, minimum_national_maximum(7000001, turnover_percentage), _).
test(route_other_provision_has_no_union_minimum) :-
    nis2_supervision_fines_profile_for(fine_floor_other_provision, Profile),
    fine_ceiling_floor(Profile, no_union_minimum, _).
test(route_article_21_near_miss_has_a_computed_floor) :-
    nis2_supervision_fines_profile_for(escalation_exercisable, Profile),
    fine_ceiling_floor(Profile, minimum_national_maximum(_, _), _).
test(route_private_essential_powers_include_escalation) :-
    nis2_supervision_fines_profile_for(escalation_exercisable, Profile),
    minimum_powers(Profile, Powers),
    member(power(escalation, suspend_certification_or_authorisation, cite(eu_dir_2022_2555_art_32_5_a)), Powers).
test(route_essential_powers_have_a_monitoring_officer) :-
    nis2_supervision_fines_profile_for(escalation_exercisable, Profile),
    minimum_powers(Profile, Powers),
    member(power(enforcement, monitoring_officer, cite(eu_dir_2022_2555_art_32_4_g)), Powers).
test(route_gdpr_bar_positive) :-
    nis2_supervision_fines_profile_for(gdpr_fine_bars_nis2_fine, Profile),
    fine_barred_by_gdpr_fine(Profile, fine_barred, _).
test(route_gdpr_bar_near_miss_other_conduct) :-
    nis2_supervision_fines_profile_for(gdpr_fine_for_other_conduct, Profile),
    fine_barred_by_gdpr_fine(Profile, fine_not_barred, _).
test(route_duty_two_authorities_positive) :-
    nis2_supervision_fines_profile_for(information_duty_two_authorities, Profile),
    data_protection_authority_information(Profile, DutyList),
    member(inform_supervisory_authority_in_own_member_state(cite(eu_dir_2022_2555_art_35_3)), DutyList).
test(route_duty_one_authority_near_miss) :-
    nis2_supervision_fines_profile_for(escalation_exercisable, Profile),
    data_protection_authority_information(Profile, [inform_gdpr_supervisory_authorities(cite(eu_dir_2022_2555_art_35_1))]).
test(route_input_problems_positive) :-
    nis2_supervision_fines_profile_for(invalid_crisp_key_unsure, Profile),
    nis2_supervision_fines_status(Profile, invalid_profile).
test(route_input_problems_near_miss_crisp_false_is_eligible) :-
    nis2_supervision_fines_profile_for(escalation_exercisable, Profile),
    nis2_supervision_fines_status(Profile, eligible).

test(route_exercisable_near_miss_action_taken_is_not_eligible, fail) :-
    nis2_supervision_fines_profile_for(escalation_action_taken_within_deadline, Profile),
    nis2_supervision_fines_status(Profile, eligible).
test(route_public_administration_is_not_exercisable, fail) :-
    nis2_supervision_fines_profile_for(escalation_public_administration_entity, Profile),
    escalation_powers_exercisable(Profile, exercisable, _).
test(route_public_administration_near_miss_private_has_no_such_reason, fail) :-
    nis2_supervision_fines_profile_for(escalation_exercisable, Profile),
    escalation_powers_exercisable(Profile, not_exercisable(public_administration_entity), _).
test(route_important_entity_is_not_eligible, fail) :-
    nis2_supervision_fines_profile_for(escalation_important_entity, Profile),
    nis2_supervision_fines_status(Profile, eligible).
test(route_measures_not_ineffective_is_not_exercisable, fail) :-
    nis2_supervision_fines_profile_for(escalation_measures_not_ineffective, Profile),
    escalation_powers_exercisable(Profile, exercisable, _).
test(route_no_deadline_is_not_exercisable, fail) :-
    nis2_supervision_fines_profile_for(escalation_no_deadline_set, Profile),
    escalation_powers_exercisable(Profile, exercisable, _).
test(route_referral_is_not_exercisable_outright, fail) :-
    nis2_supervision_fines_profile_for(escalation_measures_unsure, Profile),
    escalation_powers_exercisable(Profile, exercisable, _).
test(route_absent_class_near_miss_is_not_indeterminate, fail) :-
    nis2_supervision_fines_profile_for(escalation_class_absent_action_taken, Profile),
    escalation_powers_exercisable(Profile, indeterminate(_), _).
test(route_absent_deadline_is_not_exercisable, fail) :-
    nis2_supervision_fines_profile_for(escalation_deadline_absent, Profile),
    escalation_powers_exercisable(Profile, exercisable, _).
test(route_essential_tie_is_not_turnover_percentage, fail) :-
    nis2_supervision_fines_profile_for(fine_floor_essential_at_tie, Profile),
    fine_ceiling_floor(Profile, minimum_national_maximum(_, turnover_percentage), _).
test(route_essential_one_euro_above_is_not_fixed_amount, fail) :-
    nis2_supervision_fines_profile_for(fine_floor_essential_one_euro_above_tie, Profile),
    fine_ceiling_floor(Profile, minimum_national_maximum(_, fixed_amount), _).
test(route_important_tie_does_not_cite_article_34_4, fail) :-
    nis2_supervision_fines_profile_for(fine_floor_important_at_tie, Profile),
    fine_ceiling_floor(Profile, _, [cite(eu_dir_2022_2555_art_34_4)]).
test(route_important_one_euro_above_is_not_fixed_amount, fail) :-
    nis2_supervision_fines_profile_for(fine_floor_important_one_euro_above_tie, Profile),
    fine_ceiling_floor(Profile, minimum_national_maximum(_, fixed_amount), _).
test(route_other_provision_has_no_computed_floor, fail) :-
    nis2_supervision_fines_profile_for(fine_floor_other_provision, Profile),
    fine_ceiling_floor(Profile, minimum_national_maximum(_, _), _).
test(route_public_administration_powers_exclude_escalation, fail) :-
    nis2_supervision_fines_profile_for(escalation_public_administration_entity, Profile),
    minimum_powers(Profile, Powers),
    member(power(escalation, _, _), Powers).
test(route_important_powers_have_no_monitoring_officer, fail) :-
    nis2_supervision_fines_profile_for(escalation_important_entity, Profile),
    minimum_powers(Profile, Powers),
    member(power(_, monitoring_officer, _), Powers).
test(route_gdpr_bar_near_miss_is_not_barred, fail) :-
    nis2_supervision_fines_profile_for(gdpr_fine_for_other_conduct, Profile),
    fine_barred_by_gdpr_fine(Profile, fine_barred, _).
test(route_duty_one_authority_has_no_own_member_state_item, fail) :-
    nis2_supervision_fines_profile_for(escalation_exercisable, Profile),
    data_protection_authority_information(Profile, DutyList),
    member(inform_supervisory_authority_in_own_member_state(_), DutyList).
test(route_input_problems_has_no_decision, fail) :-
    nis2_supervision_fines_profile_for(invalid_crisp_key_unsure, Profile),
    nis2_supervision_fines_status(Profile, eligible).

cp_test_names([the_near_miss_atoms_are_table_statuses, route_exercisable_positive, route_exercisable_near_miss_action_taken_is_ineligible, route_public_administration_positive, route_important_entity_positive, route_measures_not_ineffective_positive, route_no_deadline_positive, route_referral_positive, route_absent_class_positive, route_absent_class_near_miss_failing_condition_settles, route_absent_deadline_positive, route_essential_tie_is_fixed_amount, route_essential_one_euro_above_is_turnover_percentage, route_important_tie_is_fixed_amount, route_important_one_euro_above_is_turnover_percentage, route_other_provision_has_no_union_minimum, route_article_21_near_miss_has_a_computed_floor, route_private_essential_powers_include_escalation, route_essential_powers_have_a_monitoring_officer, route_gdpr_bar_positive, route_gdpr_bar_near_miss_other_conduct, route_duty_two_authorities_positive, route_duty_one_authority_near_miss, route_input_problems_positive, route_input_problems_near_miss_crisp_false_is_eligible]).
cp_test_fail_names([route_exercisable_near_miss_action_taken_is_not_eligible, route_public_administration_is_not_exercisable, route_public_administration_near_miss_private_has_no_such_reason, route_important_entity_is_not_eligible, route_measures_not_ineffective_is_not_exercisable, route_no_deadline_is_not_exercisable, route_referral_is_not_exercisable_outright, route_absent_class_near_miss_is_not_indeterminate, route_absent_deadline_is_not_exercisable, route_essential_tie_is_not_turnover_percentage, route_essential_one_euro_above_is_not_fixed_amount, route_important_tie_does_not_cite_article_34_4, route_important_one_euro_above_is_not_fixed_amount, route_other_provision_has_no_computed_floor, route_public_administration_powers_exclude_escalation, route_important_powers_have_no_monitoring_officer, route_gdpr_bar_near_miss_is_not_barred, route_duty_one_authority_has_no_own_member_state_item, route_input_problems_has_no_decision]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
