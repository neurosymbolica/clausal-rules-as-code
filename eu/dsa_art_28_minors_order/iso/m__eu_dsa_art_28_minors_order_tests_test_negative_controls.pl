% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dsa_art_28_minors_order_tests_test_negative_controls, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_dsa_art_28_minors_order_dsa_art_28_minors_order, [section_3_application_status/4, art_28_1_obligation_status/4, art_28_1_compliance_status/4, art_28_2_advertising_status/4, dsa_art_28_minors_order_status/2, dsa_art_28_minors_order_status_values/1]).
:- use_module(m__eu_dsa_art_28_minors_order_queries, [dsa_art_28_minors_order_what_if/4]).
:- use_module(m__eu_dsa_art_28_minors_order_fixtures, [dsa_art_28_minors_order_profile_for/2]).

subject_status(Subject, Status) :-
    dsa_art_28_minors_order_profile_for(Subject, Profile),
    dsa_art_28_minors_order_status(Profile, Status).

test(the_status_table_holds_every_near_miss_atom) :-
    dsa_art_28_minors_order_status_values(StatusValues),
    member(dsa_art_28_minors_order_breached, StatusValues),
    member(dsa_art_28_minors_order_complied, StatusValues),
    member(dsa_art_28_minors_order_not_engaged, StatusValues).
test(adequate_measures_comply) :-
    subject_status(medium_provider_accessible_platform_measures_adequate, dsa_art_28_minors_order_complied).
test(inadequate_measures_breach) :-
    subject_status(medium_provider_accessible_platform_measures_inadequate, dsa_art_28_minors_order_breached).
test(a_platform_not_accessible_to_minors_is_not_engaged) :-
    subject_status(medium_provider_platform_not_accessible_to_minors, dsa_art_28_minors_order_not_engaged).
test(not_accessible_has_no_obligation) :-
    dsa_art_28_minors_order_profile_for(medium_provider_platform_not_accessible_to_minors, Profile),
    art_28_1_obligation_status(Profile, art_28_1_obligation_not_applicable, [], _).
test(profiled_advertising_to_a_known_minor_is_prohibited) :-
    dsa_art_28_minors_order_profile_for(profiled_advertising_to_recipient_known_minor, Profile),
    art_28_2_advertising_status(Profile, art_28_2_presentation_prohibited, [], _).
test(without_awareness_presentation_is_not_prohibited) :-
    dsa_art_28_minors_order_profile_for(profiled_advertising_recipient_not_known_minor, Profile),
    art_28_2_advertising_status(Profile, art_28_2_presentation_not_prohibited, [], _).
test(art_28_2_binds_a_platform_not_accessible_to_minors) :-
    subject_status(profiled_advertising_to_recipient_known_minor, dsa_art_28_minors_order_breached).
test(accessibility_true_leaves_the_ban_in_place) :-
    dsa_art_28_minors_order_profile_for(profiled_advertising_to_recipient_known_minor, Profile),
    dsa_art_28_minors_order_what_if(Profile, platform_accessible_to_minors, true, dsa_art_28_minors_order_breached).
test(a_small_enterprise_stated_not_designated_is_outside_section_3) :-
    dsa_art_28_minors_order_profile_for(small_enterprise_stated_not_designated, Profile),
    section_3_application_status(Profile, section_3_not_applicable, [_], _).
test(a_small_enterprise_stated_designated_is_inside_section_3) :-
    dsa_art_28_minors_order_profile_for(small_enterprise_stated_designated, Profile),
    section_3_application_status(Profile, section_3_applies, [], _).
test(the_exempt_small_enterprise_is_not_engaged) :-
    subject_status(small_enterprise_stated_not_designated, dsa_art_28_minors_order_not_engaged).
test(the_designated_small_enterprise_is_in_breach) :-
    subject_status(small_enterprise_stated_designated, dsa_art_28_minors_order_breached).
test(within_the_twelve_months_is_not_engaged) :-
    subject_status(provider_within_twelve_months_stated_not_designated, dsa_art_28_minors_order_not_engaged).
test(past_the_twelve_months_complies) :-
    subject_status(provider_past_twelve_months_medium_enterprise, dsa_art_28_minors_order_complied).
test(an_absent_designation_is_referred_on) :-
    dsa_art_28_minors_order_profile_for(small_enterprise_designation_not_shown, Profile),
    section_3_application_status(Profile, needs_legal_review(cross_reference_unresolved(_, _), _), [], []).
test(an_attested_designation_settles_section_3) :-
    dsa_art_28_minors_order_profile_for(designated_provider_enterprise_facts_absent, Profile),
    section_3_application_status(Profile, section_3_applies, [], _).
test(attesting_the_designation_turns_the_referral_into_a_breach) :-
    dsa_art_28_minors_order_profile_for(small_enterprise_designation_not_shown, Profile),
    dsa_art_28_minors_order_what_if(Profile, designated_as_very_large_online_platform, attested(true, attestation(host_user, recorded_moment, commission_list_checked, none)), dsa_art_28_minors_order_breached).
test(attesting_non_designation_turns_the_referral_into_not_engaged) :-
    dsa_art_28_minors_order_profile_for(small_enterprise_designation_not_shown, Profile),
    dsa_art_28_minors_order_what_if(Profile, designated_as_very_large_online_platform, attested(false, attestation(host_user, recorded_moment, commission_list_checked, none)), dsa_art_28_minors_order_not_engaged).
test(an_empty_profile_names_the_first_enterprise_key) :-
    dsa_art_28_minors_order_profile_for(empty_profile, Profile),
    section_3_application_status(Profile, indeterminate([provider_qualifies_as_micro_or_small_enterprise]), [], []).
test(the_absent_run_off_fact_is_named) :-
    dsa_art_28_minors_order_profile_for(enterprise_run_off_fact_absent, Profile),
    art_28_1_compliance_status(Profile, indeterminate([provider_within_12_months_after_losing_micro_or_small_status]), [], []).
test(supplying_the_run_off_fact_settles_compliance) :-
    dsa_art_28_minors_order_profile_for(enterprise_run_off_fact_absent, Profile),
    dsa_art_28_minors_order_what_if(Profile, provider_within_12_months_after_losing_micro_or_small_status, false, dsa_art_28_minors_order_complied).
test(unsure_accessibility_goes_to_a_lawyer) :-
    dsa_art_28_minors_order_profile_for(accessibility_judgement_unsure, Profile),
    art_28_1_obligation_status(Profile, needs_legal_review(open_textured(platform_accessible_to_minors, cite(eu_reg_2022_2065_art_28_1)), [inputs_relied_on([platform_accessible_to_minors - unsure])]), [], []).
test(settled_accessibility_complies) :-
    dsa_art_28_minors_order_profile_for(accessibility_judgement_unsure, Profile),
    dsa_art_28_minors_order_what_if(Profile, platform_accessible_to_minors, true, dsa_art_28_minors_order_complied).
test(unsure_measures_go_to_a_lawyer) :-
    dsa_art_28_minors_order_profile_for(measures_judgement_unsure, Profile),
    art_28_1_compliance_status(Profile, needs_legal_review(open_textured(measures_appropriate_and_proportionate_for_high_level_of_privacy_safety_and_security_of_minors, cite(eu_reg_2022_2065_art_28_1)), _), [], []).
test(settled_measures_comply) :-
    dsa_art_28_minors_order_profile_for(measures_judgement_unsure, Profile),
    dsa_art_28_minors_order_what_if(Profile, measures_appropriate_and_proportionate_for_high_level_of_privacy_safety_and_security_of_minors, true, dsa_art_28_minors_order_complied).
test(unsure_profiling_goes_to_a_lawyer) :-
    dsa_art_28_minors_order_profile_for(profiling_judgement_unsure, Profile),
    art_28_2_advertising_status(Profile, needs_legal_review(open_textured(advertisements_based_on_profiling_of_recipient, cite(eu_reg_2022_2065_art_28_2)), _), [], []).
test(settled_profiling_is_a_breach) :-
    dsa_art_28_minors_order_profile_for(profiling_judgement_unsure, Profile),
    dsa_art_28_minors_order_what_if(Profile, advertisements_based_on_profiling_of_recipient, true, dsa_art_28_minors_order_breached).
test(unsure_awareness_goes_to_a_lawyer) :-
    dsa_art_28_minors_order_profile_for(awareness_judgement_unsure, Profile),
    art_28_2_advertising_status(Profile, needs_legal_review(open_textured(aware_with_reasonable_certainty_recipient_is_minor, cite(eu_reg_2022_2065_art_28_2)), _), [], []).
test(no_awareness_is_not_engaged) :-
    dsa_art_28_minors_order_profile_for(awareness_judgement_unsure, Profile),
    dsa_art_28_minors_order_what_if(Profile, aware_with_reasonable_certainty_recipient_is_minor, false, dsa_art_28_minors_order_not_engaged).
test(an_unknown_key_is_an_input_problem) :-
    subject_status(profile_with_unknown_key, input_problems([unknown_key(colour)])).
test(a_duplicate_key_is_named_alone) :-
    subject_status(profile_with_duplicate_key, input_problems([duplicate_key(provider_qualifies_as_micro_or_small_enterprise)])).

test(inadequate_measures_do_not_comply, fail) :-
    subject_status(medium_provider_accessible_platform_measures_inadequate, dsa_art_28_minors_order_complied).
test(an_accessible_platform_is_engaged, fail) :-
    subject_status(medium_provider_accessible_platform_measures_adequate, dsa_art_28_minors_order_not_engaged).
test(not_accessible_does_not_carry_the_obligation, fail) :-
    dsa_art_28_minors_order_profile_for(medium_provider_platform_not_accessible_to_minors, Profile),
    art_28_1_obligation_status(Profile, art_28_1_obligation_applies, _, _).
test(without_awareness_presentation_is_not_held_prohibited, fail) :-
    dsa_art_28_minors_order_profile_for(profiled_advertising_recipient_not_known_minor, Profile),
    art_28_2_advertising_status(Profile, art_28_2_presentation_prohibited, _, _).
test(without_awareness_the_provider_is_not_in_breach, fail) :-
    subject_status(profiled_advertising_recipient_not_known_minor, dsa_art_28_minors_order_breached).
test(a_designated_small_enterprise_is_not_outside_section_3, fail) :-
    dsa_art_28_minors_order_profile_for(small_enterprise_stated_designated, Profile),
    section_3_application_status(Profile, section_3_not_applicable, _, _).
test(the_designated_small_enterprise_is_engaged, fail) :-
    subject_status(small_enterprise_stated_designated, dsa_art_28_minors_order_not_engaged).
test(past_the_twelve_months_is_engaged, fail) :-
    subject_status(provider_past_twelve_months_medium_enterprise, dsa_art_28_minors_order_not_engaged).
test(past_the_twelve_months_the_statement_is_not_the_basis, fail) :-
    dsa_art_28_minors_order_profile_for(provider_past_twelve_months_medium_enterprise, Profile),
    section_3_application_status(Profile, _, [_|_], _).
test(an_absent_designation_does_not_give_section_3_applies, fail) :-
    dsa_art_28_minors_order_profile_for(small_enterprise_designation_not_shown, Profile),
    section_3_application_status(Profile, section_3_applies, _, _).
test(the_absent_run_off_fact_does_not_give_compliance, fail) :-
    dsa_art_28_minors_order_profile_for(enterprise_run_off_fact_absent, Profile),
    art_28_1_compliance_status(Profile, art_28_1_measures_compliant, _, _).
test(unsure_measures_are_not_held_compliant, fail) :-
    dsa_art_28_minors_order_profile_for(measures_judgement_unsure, Profile),
    art_28_1_compliance_status(Profile, art_28_1_measures_compliant, _, _).
test(unsure_awareness_is_not_held_prohibited, fail) :-
    dsa_art_28_minors_order_profile_for(awareness_judgement_unsure, Profile),
    art_28_2_advertising_status(Profile, art_28_2_presentation_prohibited, _, _).
test(a_duplicate_key_is_never_also_wrong_type, fail) :-
    subject_status(profile_with_duplicate_key, input_problems([duplicate_key(provider_qualifies_as_micro_or_small_enterprise), wrong_type(provider_qualifies_as_micro_or_small_enterprise)])).
test(a_well_formed_profile_has_no_input_problem, fail) :-
    subject_status(medium_provider_accessible_platform_measures_adequate, input_problems(_)).

cp_test_names([the_status_table_holds_every_near_miss_atom, adequate_measures_comply, inadequate_measures_breach, a_platform_not_accessible_to_minors_is_not_engaged, not_accessible_has_no_obligation, profiled_advertising_to_a_known_minor_is_prohibited, without_awareness_presentation_is_not_prohibited, art_28_2_binds_a_platform_not_accessible_to_minors, accessibility_true_leaves_the_ban_in_place, a_small_enterprise_stated_not_designated_is_outside_section_3, a_small_enterprise_stated_designated_is_inside_section_3, the_exempt_small_enterprise_is_not_engaged, the_designated_small_enterprise_is_in_breach, within_the_twelve_months_is_not_engaged, past_the_twelve_months_complies, an_absent_designation_is_referred_on, an_attested_designation_settles_section_3, attesting_the_designation_turns_the_referral_into_a_breach, attesting_non_designation_turns_the_referral_into_not_engaged, an_empty_profile_names_the_first_enterprise_key, the_absent_run_off_fact_is_named, supplying_the_run_off_fact_settles_compliance, unsure_accessibility_goes_to_a_lawyer, settled_accessibility_complies, unsure_measures_go_to_a_lawyer, settled_measures_comply, unsure_profiling_goes_to_a_lawyer, settled_profiling_is_a_breach, unsure_awareness_goes_to_a_lawyer, no_awareness_is_not_engaged, an_unknown_key_is_an_input_problem, a_duplicate_key_is_named_alone]).
cp_test_fail_names([inadequate_measures_do_not_comply, an_accessible_platform_is_engaged, not_accessible_does_not_carry_the_obligation, without_awareness_presentation_is_not_held_prohibited, without_awareness_the_provider_is_not_in_breach, a_designated_small_enterprise_is_not_outside_section_3, the_designated_small_enterprise_is_engaged, past_the_twelve_months_is_engaged, past_the_twelve_months_the_statement_is_not_the_basis, an_absent_designation_does_not_give_section_3_applies, the_absent_run_off_fact_does_not_give_compliance, unsure_measures_are_not_held_compliant, unsure_awareness_is_not_held_prohibited, a_duplicate_key_is_never_also_wrong_type, a_well_formed_profile_has_no_input_problem]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
