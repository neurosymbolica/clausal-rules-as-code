% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_nis2_supervision_fines_tests_test_input_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_nis2_supervision_fines_kernel, [nis2_supervision_fines_input_problems/2]).
:- use_module(m__eu_nis2_supervision_fines_nis2_supervision_fines, [nis2_supervision_fines_status/2, fine_ceiling_floor/3, minimum_powers/2, escalation_powers_exercisable/3, fine_barred_by_gdpr_fine/3, data_protection_authority_information/2]).
:- use_module(m__eu_nis2_supervision_fines_fixtures, [nis2_supervision_fines_profile_for/2]).

test(the_exercisable_baseline_holds_with_eligible_bound) :-
    nis2_supervision_fines_profile_for(escalation_exercisable, Profile),
    nis2_supervision_fines_status(Profile, eligible).
test(an_important_entity_holds_with_ineligible_bound) :-
    nis2_supervision_fines_profile_for(escalation_important_entity, Profile),
    nis2_supervision_fines_status(Profile, ineligible).
test(an_unsure_judgement_holds_with_indeterminate_bound) :-
    nis2_supervision_fines_profile_for(escalation_measures_unsure, Profile),
    nis2_supervision_fines_status(Profile, indeterminate).
test(a_badly_formed_profile_holds_with_invalid_profile_bound) :-
    nis2_supervision_fines_profile_for(invalid_crisp_key_unsure, Profile),
    nis2_supervision_fines_status(Profile, invalid_profile).
test(the_escalation_reason_holds_bound) :-
    nis2_supervision_fines_profile_for(escalation_no_deadline_set, Profile),
    escalation_powers_exercisable(Profile, not_exercisable(no_deadline_set), [cite(eu_dir_2022_2555_art_32_5)]).
test(the_ceiling_holds_bound) :-
    nis2_supervision_fines_profile_for(fine_floor_essential_at_tie, Profile),
    fine_ceiling_floor(Profile, minimum_national_maximum(10000000, fixed_amount), [cite(eu_dir_2022_2555_art_34_4)]).
test(the_gdpr_bar_holds_bound) :-
    nis2_supervision_fines_profile_for(gdpr_fine_bars_nis2_fine, Profile),
    fine_barred_by_gdpr_fine(Profile, fine_barred, [cite(eu_dir_2022_2555_art_35_2)]).
test(the_duty_holds_bound) :-
    nis2_supervision_fines_profile_for(information_duty_two_authorities, Profile),
    data_protection_authority_information(Profile, [inform_gdpr_supervisory_authorities(cite(eu_dir_2022_2555_art_35_1)), inform_supervisory_authority_in_own_member_state(cite(eu_dir_2022_2555_art_35_3))]).
test(the_powers_hold_bound_for_an_important_entity) :-
    nis2_supervision_fines_profile_for(escalation_important_entity, Profile),
    minimum_powers(Profile, [power(supervision, on_site_inspections_and_off_site_ex_post_supervision, cite(eu_dir_2022_2555_art_33_2_a))|_]).
test(the_attribute_order_does_not_change_the_verdict) :-
    nis2_supervision_fines_profile_for(escalation_exercisable, Profile),
    reverse(Profile, ReversedProfile),
    nis2_supervision_fines_status(ReversedProfile, eligible).
test(the_empty_profile_asks_for_the_infringed_provision_first) :-
    fine_ceiling_floor([], indeterminate([infringed_provision]), []).
test(the_empty_profile_asks_for_the_entity_class_for_powers) :-
    minimum_powers([], indeterminate([entity_class])).
test(the_empty_profile_asks_for_the_entity_class_for_escalation) :-
    escalation_powers_exercisable([], indeterminate([entity_class]), []).
test(the_empty_profile_asks_for_the_infringed_provision_for_the_gdpr_bar) :-
    fine_barred_by_gdpr_fine([], indeterminate([infringed_provision]), []).
test(the_empty_profile_asks_for_the_infringed_provision_for_the_duty) :-
    data_protection_authority_information([], indeterminate([infringed_provision])).
test(a_number_is_not_a_profile) :-
    nis2_supervision_fines_input_problems(42, [wrong_type(profile)]).
test(a_non_list_profile_gets_input_problems_from_a_query) :-
    fine_ceiling_floor(not_a_list, input_problems([wrong_type(profile)]), []).
test(a_compound_value_is_wrong_type) :-
    nis2_supervision_fines_input_problems([attribute(entity_class, kind(essential))], [wrong_type(entity_class)]).
test(a_float_turnover_is_wrong_type) :-
    nis2_supervision_fines_input_problems([attribute(worldwide_annual_turnover_eur, 1.5)], [wrong_type(worldwide_annual_turnover_eur)]).
test(an_atom_turnover_is_wrong_type) :-
    nis2_supervision_fines_input_problems([attribute(worldwide_annual_turnover_eur, large)], [wrong_type(worldwide_annual_turnover_eur)]).
test(a_zero_turnover_is_well_formed) :-
    nis2_supervision_fines_input_problems([attribute(worldwide_annual_turnover_eur, 0)], []).
test(a_judgement_key_accepts_unsure) :-
    nis2_supervision_fines_input_problems([attribute(gdpr_fine_for_same_conduct, unsure)], []).
test(a_crisp_key_rejects_unsure) :-
    nis2_supervision_fines_input_problems([attribute(gdpr_fine_imposed_under_art_58_2_i, unsure)], [wrong_type(gdpr_fine_imposed_under_art_58_2_i)]).
test(a_duplicate_with_equal_values_is_a_duplicate_only) :-
    nis2_supervision_fines_input_problems([attribute(entity_class, essential), attribute(entity_class, essential)], [duplicate_key(entity_class)]).
test(unknown_keys_are_named_once_in_first_occurrence_order) :-
    nis2_supervision_fines_input_problems([attribute(zeta, 1), attribute(alpha, 2), attribute(zeta, 3)], [unknown_key(zeta), unknown_key(alpha)]).
test(a_pair_is_not_an_attribute) :-
    nis2_supervision_fines_input_problems([entity_class - essential], [wrong_type(profile)]).
test(a_key_the_query_does_not_read_is_still_checked) :-
    minimum_powers([attribute(entity_class, important), attribute(gdpr_fine_for_same_conduct, maybe)], input_problems([wrong_type(gdpr_fine_for_same_conduct)])).
test(every_query_answers_input_problems_for_an_unknown_key) :-
    fine_ceiling_floor([attribute(colour, red)], input_problems([unknown_key(colour)]), []),
    minimum_powers([attribute(colour, red)], input_problems([unknown_key(colour)])),
    escalation_powers_exercisable([attribute(colour, red)], input_problems([unknown_key(colour)]), []),
    fine_barred_by_gdpr_fine([attribute(colour, red)], input_problems([unknown_key(colour)]), []),
    data_protection_authority_information([attribute(colour, red)], input_problems([unknown_key(colour)])).

test(the_exercisable_baseline_rejects_ineligible_bound, fail) :-
    nis2_supervision_fines_profile_for(escalation_exercisable, Profile),
    nis2_supervision_fines_status(Profile, ineligible).
test(the_exercisable_baseline_rejects_indeterminate_bound, fail) :-
    nis2_supervision_fines_profile_for(escalation_exercisable, Profile),
    nis2_supervision_fines_status(Profile, indeterminate).
test(a_wrong_escalation_reason_is_rejected_bound, fail) :-
    nis2_supervision_fines_profile_for(escalation_no_deadline_set, Profile),
    escalation_powers_exercisable(Profile, not_exercisable(action_taken_within_deadline), _).

cp_test_names([the_exercisable_baseline_holds_with_eligible_bound, an_important_entity_holds_with_ineligible_bound, an_unsure_judgement_holds_with_indeterminate_bound, a_badly_formed_profile_holds_with_invalid_profile_bound, the_escalation_reason_holds_bound, the_ceiling_holds_bound, the_gdpr_bar_holds_bound, the_duty_holds_bound, the_powers_hold_bound_for_an_important_entity, the_attribute_order_does_not_change_the_verdict, the_empty_profile_asks_for_the_infringed_provision_first, the_empty_profile_asks_for_the_entity_class_for_powers, the_empty_profile_asks_for_the_entity_class_for_escalation, the_empty_profile_asks_for_the_infringed_provision_for_the_gdpr_bar, the_empty_profile_asks_for_the_infringed_provision_for_the_duty, a_number_is_not_a_profile, a_non_list_profile_gets_input_problems_from_a_query, a_compound_value_is_wrong_type, a_float_turnover_is_wrong_type, an_atom_turnover_is_wrong_type, a_zero_turnover_is_well_formed, a_judgement_key_accepts_unsure, a_crisp_key_rejects_unsure, a_duplicate_with_equal_values_is_a_duplicate_only, unknown_keys_are_named_once_in_first_occurrence_order, a_pair_is_not_an_attribute, a_key_the_query_does_not_read_is_still_checked, every_query_answers_input_problems_for_an_unknown_key]).
cp_test_fail_names([the_exercisable_baseline_rejects_ineligible_bound, the_exercisable_baseline_rejects_indeterminate_bound, a_wrong_escalation_reason_is_rejected_bound]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
