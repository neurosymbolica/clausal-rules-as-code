% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dsa_art_14_terms_and_conditions_order_tests_test_negative_controls, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_dsa_art_14_terms_and_conditions_order_dsa_art_14_terms_and_conditions_order, [art_14_1_terms_and_conditions_content_status/4, art_14_2_significant_change_information_status/4, art_14_3_minors_explanation_status/4, art_14_4_restriction_enforcement_status/4, art_14_5_terms_and_conditions_summary_status/4, art_14_6_official_languages_status/4, dsa_art_14_terms_and_conditions_order_status/2]).
:- use_module(m__eu_dsa_art_14_terms_and_conditions_order_kernel, [dsa_art_14_terms_and_conditions_order_input_problems/2]).
:- use_module(m__eu_dsa_art_14_terms_and_conditions_order_fixtures, [dsa_art_14_terms_and_conditions_order_profile_for/2]).

result_of(art_14_1, Subject, Result) :-
    dsa_art_14_terms_and_conditions_order_profile_for(Subject, Profile),
    art_14_1_terms_and_conditions_content_status(Profile, Result, _, _).
result_of(art_14_2, Subject, Result) :-
    dsa_art_14_terms_and_conditions_order_profile_for(Subject, Profile),
    art_14_2_significant_change_information_status(Profile, Result, _, _).
result_of(art_14_3, Subject, Result) :-
    dsa_art_14_terms_and_conditions_order_profile_for(Subject, Profile),
    art_14_3_minors_explanation_status(Profile, Result, _, _).
result_of(art_14_4, Subject, Result) :-
    dsa_art_14_terms_and_conditions_order_profile_for(Subject, Profile),
    art_14_4_restriction_enforcement_status(Profile, Result, _, _).
result_of(art_14_5, Subject, Result) :-
    dsa_art_14_terms_and_conditions_order_profile_for(Subject, Profile),
    art_14_5_terms_and_conditions_summary_status(Profile, Result, _, _).
result_of(art_14_6, Subject, Result) :-
    dsa_art_14_terms_and_conditions_order_profile_for(Subject, Profile),
    art_14_6_official_languages_status(Profile, Result, _, _).

test(art_14_1_items_met_is_compliant) :-
    result_of(art_14_1, small_hosting_service_no_complaint_system, art_14_1_terms_and_conditions_compliant).
test(art_14_1_no_moderation_information_is_not_compliant) :-
    result_of(art_14_1, missing_content_moderation_information, art_14_1_terms_and_conditions_not_compliant).
test(art_14_1_system_without_rules_is_not_compliant) :-
    result_of(art_14_1, complaint_system_without_rules, art_14_1_terms_and_conditions_not_compliant).
test(art_14_1_unsure_language_goes_to_a_lawyer) :-
    result_of(art_14_1, unsure_language_judgement, needs_legal_review(open_textured(terms_and_conditions_in_clear_plain_intelligible_user_friendly_and_unambiguous_language, _), _)).
test(art_14_2_informed_significant_change_is_compliant) :-
    result_of(art_14_2, fully_compliant_very_large_platform, art_14_2_change_information_compliant).
test(art_14_2_uninformed_significant_change_is_not_compliant) :-
    result_of(art_14_2, significant_change_not_notified, art_14_2_change_information_not_compliant).
test(art_14_2_insignificant_change_is_not_required) :-
    result_of(art_14_2, insignificant_change_not_notified, art_14_2_change_information_not_required).
test(art_14_3_explained_for_minors_is_compliant) :-
    result_of(art_14_3, fully_compliant_very_large_platform, art_14_3_minors_explanation_compliant).
test(art_14_3_unclear_for_minors_is_not_compliant) :-
    result_of(art_14_3, minors_service_unclear_explanation, art_14_3_minors_explanation_not_compliant).
test(art_14_3_service_not_for_minors_is_not_required) :-
    result_of(art_14_3, service_not_for_minors, art_14_3_minors_explanation_not_required).
test(art_14_4_proportionate_enforcement_is_compliant) :-
    result_of(art_14_4, fully_compliant_very_large_platform, art_14_4_restriction_enforcement_compliant).
test(art_14_4_disproportionate_enforcement_is_not_compliant) :-
    result_of(art_14_4, disproportionate_enforcement, art_14_4_restriction_enforcement_not_compliant).
test(art_14_4_no_enforcement_is_not_required) :-
    result_of(art_14_4, no_restriction_enforced, art_14_4_restriction_enforcement_not_required).
test(art_14_5_designated_with_summary_is_compliant) :-
    result_of(art_14_5, fully_compliant_very_large_platform, art_14_5_summary_compliant).
test(art_14_5_designated_without_summary_is_not_compliant) :-
    result_of(art_14_5, very_large_platform_without_summary, art_14_5_summary_not_compliant).
test(art_14_5_not_designated_is_not_required) :-
    result_of(art_14_5, designation_attested_false, art_14_5_summary_not_required).
test(art_14_5_designation_turned_true_is_not_compliant) :-
    result_of(art_14_5, designation_attested_true, art_14_5_summary_not_compliant).
test(art_14_6_designated_and_published_is_compliant) :-
    result_of(art_14_6, fully_compliant_very_large_platform, art_14_6_official_languages_compliant).
test(art_14_6_not_designated_is_not_required) :-
    result_of(art_14_6, designation_attested_false, art_14_6_official_languages_not_required).
test(art_14_6_designation_turned_true_is_not_compliant) :-
    result_of(art_14_6, designation_attested_true, art_14_6_official_languages_not_compliant).
test(designated_unsure_summary_is_open_textured) :-
    result_of(art_14_5, designated_summary_unsure, needs_legal_review(open_textured(_, _), _)).
test(absent_designation_is_a_cross_reference) :-
    result_of(art_14_5, designation_absent_summary_unsure, needs_legal_review(cross_reference_unresolved(_, _), _)).
test(a_well_formed_profile_has_no_problem) :-
    dsa_art_14_terms_and_conditions_order_profile_for(well_formed_change_only, Profile),
    dsa_art_14_terms_and_conditions_order_input_problems(Profile, []).
test(a_duplicated_key_is_a_problem) :-
    dsa_art_14_terms_and_conditions_order_profile_for(malformed_duplicate_and_unknown_keys, Profile),
    dsa_art_14_terms_and_conditions_order_input_problems(Profile, [duplicate_key(terms_and_conditions_changed), unknown_key(stray_key)]).
test(facade_all_duties_met_is_compliant) :-
    dsa_art_14_terms_and_conditions_order_profile_for(fully_compliant_very_large_platform, Profile),
    dsa_art_14_terms_and_conditions_order_status(Profile, dsa_art_14_terms_and_conditions_order_compliant).
test(facade_one_missing_summary_is_not_compliant) :-
    dsa_art_14_terms_and_conditions_order_profile_for(very_large_platform_without_summary, Profile),
    dsa_art_14_terms_and_conditions_order_status(Profile, dsa_art_14_terms_and_conditions_order_not_compliant).

test(art_14_1_items_met_is_not_not_compliant, fail) :-
    result_of(art_14_1, small_hosting_service_no_complaint_system, art_14_1_terms_and_conditions_not_compliant).
test(art_14_1_no_moderation_information_is_not_compliant_not_compliant, fail) :-
    result_of(art_14_1, missing_content_moderation_information, art_14_1_terms_and_conditions_compliant).
test(art_14_1_system_without_rules_is_not_compliant_route_flips, fail) :-
    result_of(art_14_1, complaint_system_without_rules, art_14_1_terms_and_conditions_compliant).
test(art_14_1_unsure_language_is_not_compliant_invented, fail) :-
    result_of(art_14_1, unsure_language_judgement, art_14_1_terms_and_conditions_compliant).
test(art_14_2_uninformed_significant_change_is_not_compliant_route_flips, fail) :-
    result_of(art_14_2, significant_change_not_notified, art_14_2_change_information_compliant).
test(art_14_2_insignificant_change_is_not_a_breach, fail) :-
    result_of(art_14_2, insignificant_change_not_notified, art_14_2_change_information_not_compliant).
test(art_14_3_unclear_for_minors_route_flips, fail) :-
    result_of(art_14_3, minors_service_unclear_explanation, art_14_3_minors_explanation_compliant).
test(art_14_3_service_not_for_minors_is_not_a_breach, fail) :-
    result_of(art_14_3, service_not_for_minors, art_14_3_minors_explanation_not_compliant).
test(art_14_4_disproportionate_enforcement_route_flips, fail) :-
    result_of(art_14_4, disproportionate_enforcement, art_14_4_restriction_enforcement_compliant).
test(art_14_4_no_enforcement_is_not_a_breach, fail) :-
    result_of(art_14_4, no_restriction_enforced, art_14_4_restriction_enforcement_not_compliant).
test(art_14_5_designated_without_summary_route_flips, fail) :-
    result_of(art_14_5, very_large_platform_without_summary, art_14_5_summary_compliant).
test(art_14_5_not_designated_is_not_a_breach, fail) :-
    result_of(art_14_5, designation_attested_false, art_14_5_summary_not_compliant).
test(art_14_6_designation_turned_true_is_not_not_required, fail) :-
    result_of(art_14_6, designation_attested_true, art_14_6_official_languages_not_required).
test(absent_designation_is_not_open_textured, fail) :-
    result_of(art_14_5, designation_absent_summary_unsure, needs_legal_review(open_textured(_, _), _)).
test(a_duplicated_key_is_not_well_formed, fail) :-
    dsa_art_14_terms_and_conditions_order_profile_for(malformed_duplicate_and_unknown_keys, Profile),
    dsa_art_14_terms_and_conditions_order_input_problems(Profile, []).
test(facade_one_missing_summary_is_not_compliant_route_flips, fail) :-
    dsa_art_14_terms_and_conditions_order_profile_for(very_large_platform_without_summary, Profile),
    dsa_art_14_terms_and_conditions_order_status(Profile, dsa_art_14_terms_and_conditions_order_compliant).

cp_test_names([art_14_1_items_met_is_compliant, art_14_1_no_moderation_information_is_not_compliant, art_14_1_system_without_rules_is_not_compliant, art_14_1_unsure_language_goes_to_a_lawyer, art_14_2_informed_significant_change_is_compliant, art_14_2_uninformed_significant_change_is_not_compliant, art_14_2_insignificant_change_is_not_required, art_14_3_explained_for_minors_is_compliant, art_14_3_unclear_for_minors_is_not_compliant, art_14_3_service_not_for_minors_is_not_required, art_14_4_proportionate_enforcement_is_compliant, art_14_4_disproportionate_enforcement_is_not_compliant, art_14_4_no_enforcement_is_not_required, art_14_5_designated_with_summary_is_compliant, art_14_5_designated_without_summary_is_not_compliant, art_14_5_not_designated_is_not_required, art_14_5_designation_turned_true_is_not_compliant, art_14_6_designated_and_published_is_compliant, art_14_6_not_designated_is_not_required, art_14_6_designation_turned_true_is_not_compliant, designated_unsure_summary_is_open_textured, absent_designation_is_a_cross_reference, a_well_formed_profile_has_no_problem, a_duplicated_key_is_a_problem, facade_all_duties_met_is_compliant, facade_one_missing_summary_is_not_compliant]).
cp_test_fail_names([art_14_1_items_met_is_not_not_compliant, art_14_1_no_moderation_information_is_not_compliant_not_compliant, art_14_1_system_without_rules_is_not_compliant_route_flips, art_14_1_unsure_language_is_not_compliant_invented, art_14_2_uninformed_significant_change_is_not_compliant_route_flips, art_14_2_insignificant_change_is_not_a_breach, art_14_3_unclear_for_minors_route_flips, art_14_3_service_not_for_minors_is_not_a_breach, art_14_4_disproportionate_enforcement_route_flips, art_14_4_no_enforcement_is_not_a_breach, art_14_5_designated_without_summary_route_flips, art_14_5_not_designated_is_not_a_breach, art_14_6_designation_turned_true_is_not_not_required, absent_designation_is_not_open_textured, a_duplicated_key_is_not_well_formed, facade_one_missing_summary_is_not_compliant_route_flips]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
