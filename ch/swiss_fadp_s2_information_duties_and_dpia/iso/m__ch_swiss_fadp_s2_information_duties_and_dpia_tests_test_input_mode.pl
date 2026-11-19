% SPDX-License-Identifier: EUPL-1.2
:- module(m__ch_swiss_fadp_s2_information_duties_and_dpia_tests_test_input_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__ch_swiss_fadp_s2_information_duties_and_dpia_swiss_fadp_s2_information_duties_and_dpia, [swiss_fadp_s2_information_duties_and_dpia_status/2, swiss_information_duty/3, swiss_minimum_information_item/4, swiss_automated_decision_information/3, swiss_automated_decision_review/3, swiss_impact_assessment/3, eu_information_duty/3, eu_automated_decision_information/3, eu_impact_assessment/3, compare_swiss_eu_information_duty/5, compare_swiss_eu_automated_decision_information/5]).
:- use_module(m__ch_swiss_fadp_s2_information_duties_and_dpia_kernel, [swiss_fadp_s2_information_duties_and_dpia_input_problems/2]).
:- use_module(m__ch_swiss_fadp_s2_information_duties_and_dpia_fixtures, [swiss_fadp_s2_information_duties_and_dpia_profile_for/2]).

test(baseline_bound_information_required) :-
    swiss_fadp_s2_information_duties_and_dpia_profile_for(private_controller_must_inform, Profile),
    swiss_fadp_s2_information_duties_and_dpia_status(Profile, information_required).
test(exception_bound_information_not_required) :-
    swiss_fadp_s2_information_duties_and_dpia_profile_for(already_informed_exception, Profile),
    swiss_fadp_s2_information_duties_and_dpia_status(Profile, information_not_required).
test(restriction_bound_may_be_restricted) :-
    swiss_fadp_s2_information_duties_and_dpia_profile_for(third_party_interests_restriction, Profile),
    swiss_fadp_s2_information_duties_and_dpia_status(Profile, information_may_be_restricted_deferred_or_omitted).
test(certified_system_bound_may_be_omitted) :-
    swiss_fadp_s2_information_duties_and_dpia_profile_for(certified_system_may_omit_assessment, Profile),
    swiss_impact_assessment(Profile, impact_assessment_may_be_omitted, [cite(ch_fadp_art_22_1), cite(ch_fadp_art_22_5), cite(ch_fadp_art_22_5_a), cite(ch_fadp_art_22_5_b), cite(ch_fadp_art_22_5_c)]).
test(automated_decision_bound_required) :-
    swiss_fadp_s2_information_duties_and_dpia_profile_for(automated_decision_private_controller, Profile),
    swiss_automated_decision_information(Profile, automated_decision_information_required, _).
test(private_automated_decision_review_rights_apply) :-
    swiss_automated_decision_review([attribute(controller_is_federal_body, false), attribute(decision_based_solely_on_automated_processing, true), attribute(decision_has_legal_consequence_or_significantly_impairs_data_subject, true), attribute(decision_directly_related_to_contract_with_data_subject, false), attribute(data_subject_request_granted, false), attribute(data_subject_explicitly_consented_to_automated_decision, false), attribute(data_subject_need_not_be_heard_before_decision, false)], view_and_review_rights_apply, [cite(ch_fadp_art_21_1), cite(ch_fadp_art_21_2), cite(ch_fadp_art_21_3), cite(ch_fadp_art_21_3_a), cite(ch_fadp_art_21_3_b), cite(ch_fadp_art_21_4)]).
test(eu_direct_collection_automated_decision_must_be_disclosed) :-
    eu_automated_decision_information([attribute(personal_data_collected_from_data_subject, true), attribute(eu_data_subject_already_has_information, false), attribute(eu_decision_based_solely_on_automated_processing, true), attribute(eu_decision_has_legal_or_similarly_significant_effects, true)], automated_decision_information_required, [cite(eu_reg_2016_679_art_13_2), cite(eu_reg_2016_679_art_13_2_f), cite(eu_reg_2016_679_art_13_4), cite(eu_reg_2016_679_art_14_2), cite(eu_reg_2016_679_art_14_2_g), cite(eu_reg_2016_679_art_14_5), cite(eu_reg_2016_679_art_14_5_a), cite(eu_reg_2016_679_art_14_5_b), cite(eu_reg_2016_679_art_14_5_c), cite(eu_reg_2016_679_art_14_5_d), cite(eu_reg_2016_679_art_22_1)]).
test(no_automated_decision_on_either_side_compares_same) :-
    compare_swiss_eu_automated_decision_information([attribute(decision_based_solely_on_automated_processing, false), attribute(eu_decision_based_solely_on_automated_processing, false)], automated_decision_information_not_required, automated_decision_information_not_required, same, []).
test(eu_listed_case_bound_required) :-
    swiss_fadp_s2_information_duties_and_dpia_profile_for(eu_listed_case_without_exemption, Profile),
    eu_impact_assessment(Profile, impact_assessment_required, _).
test(eu_direct_collection_settled_with_few_keys) :-
    eu_information_duty([attribute(personal_data_collected_from_data_subject, true), attribute(eu_data_subject_already_has_information, false)], information_required, Citations),
    member(cite(eu_reg_2016_679_art_13_4), Citations).
test(comparison_bound_same) :-
    swiss_fadp_s2_information_duties_and_dpia_profile_for(private_controller_must_inform, Profile),
    compare_swiss_eu_information_duty(Profile, information_required, information_required, same, []).
test(reversed_attribute_order_gives_the_same_answer) :-
    swiss_fadp_s2_information_duties_and_dpia_profile_for(third_party_interests_restriction, Profile),
    reverse(Profile, Reversed),
    swiss_information_duty(Reversed, information_may_be_restricted_deferred_or_omitted, _).
test(unsure_judgement_is_not_an_input_problem) :-
    swiss_fadp_s2_information_duties_and_dpia_input_problems([attribute(data_subject_already_has_information, unsure)], []).
test(unsure_crisp_key_is_wrong_type) :-
    swiss_fadp_s2_information_duties_and_dpia_input_problems([attribute(controller_is_federal_body, unsure)], [wrong_type(controller_is_federal_body)]).
test(atom_profile_is_wrong_type_profile) :-
    swiss_fadp_s2_information_duties_and_dpia_input_problems(not_a_profile, [wrong_type(profile)]).
test(atom_profile_headline_is_wrong_type_profile) :-
    swiss_information_duty(not_a_profile, input_problems([wrong_type(profile)]), []).
test(non_attribute_element_is_wrong_type_profile) :-
    swiss_fadp_s2_information_duties_and_dpia_input_problems([attribute(controller_is_federal_body, true), stray_element], [wrong_type(profile)]).
test(duplicate_key_is_named_once_without_wrong_type) :-
    swiss_fadp_s2_information_duties_and_dpia_input_problems([attribute(controller_is_federal_body, true), attribute(controller_is_federal_body, maybe)], [duplicate_key(controller_is_federal_body)]).
test(problems_come_in_contract_order_then_unknown_keys) :-
    swiss_fadp_s2_information_duties_and_dpia_input_problems([attribute(zeta_key, true), attribute(controller_is_federal_body, maybe), attribute(alpha_key, true), attribute(zeta_key, false)], [wrong_type(controller_is_federal_body), unknown_key(zeta_key), unknown_key(alpha_key)]).
test(non_atom_key_is_unknown_as_given) :-
    swiss_fadp_s2_information_duties_and_dpia_input_problems([attribute(42, true)], [unknown_key(42)]).
test(item_problem_follows_profile_problems) :-
    swiss_minimum_information_item([attribute(foreign_key_name, true)], unlisted_item, input_problems([unknown_key(foreign_key_name), wrong_type(information_item)]), []).
test(comparison_with_problems_fills_every_answer_position) :-
    compare_swiss_eu_information_duty([attribute(controller_is_federal_body, maybe)], input_problems([wrong_type(controller_is_federal_body)]), input_problems([wrong_type(controller_is_federal_body)]), input_problems([wrong_type(controller_is_federal_body)]), []).

test(baseline_bound_not_required_is_rejected, fail) :-
    swiss_fadp_s2_information_duties_and_dpia_profile_for(private_controller_must_inform, Profile),
    swiss_fadp_s2_information_duties_and_dpia_status(Profile, information_not_required).
test(baseline_bound_restriction_is_rejected, fail) :-
    swiss_fadp_s2_information_duties_and_dpia_profile_for(private_controller_must_inform, Profile),
    swiss_fadp_s2_information_duties_and_dpia_status(Profile, information_may_be_restricted_deferred_or_omitted).
test(exception_bound_required_is_rejected, fail) :-
    swiss_fadp_s2_information_duties_and_dpia_profile_for(already_informed_exception, Profile),
    swiss_fadp_s2_information_duties_and_dpia_status(Profile, information_required).
test(restriction_bound_required_is_rejected, fail) :-
    swiss_fadp_s2_information_duties_and_dpia_profile_for(third_party_interests_restriction, Profile),
    swiss_fadp_s2_information_duties_and_dpia_status(Profile, information_required).
test(certified_system_bound_required_is_rejected, fail) :-
    swiss_fadp_s2_information_duties_and_dpia_profile_for(certified_system_may_omit_assessment, Profile),
    swiss_impact_assessment(Profile, impact_assessment_required, _).
test(private_automated_decision_review_rights_are_not_denied, fail) :-
    swiss_automated_decision_review([attribute(controller_is_federal_body, false), attribute(decision_based_solely_on_automated_processing, true), attribute(decision_has_legal_consequence_or_significantly_impairs_data_subject, true), attribute(decision_directly_related_to_contract_with_data_subject, false), attribute(data_subject_request_granted, false), attribute(data_subject_explicitly_consented_to_automated_decision, false), attribute(data_subject_need_not_be_heard_before_decision, false)], view_and_review_rights_do_not_apply, _).
test(eu_direct_collection_automated_decision_is_not_exempt, fail) :-
    eu_automated_decision_information([attribute(personal_data_collected_from_data_subject, true), attribute(eu_data_subject_already_has_information, false), attribute(eu_decision_based_solely_on_automated_processing, true), attribute(eu_decision_has_legal_or_similarly_significant_effects, true)], automated_decision_information_not_required, _).
test(no_automated_decision_on_either_side_does_not_differ, fail) :-
    compare_swiss_eu_automated_decision_information([attribute(decision_based_solely_on_automated_processing, false), attribute(eu_decision_based_solely_on_automated_processing, false)], _, _, differs, _).

cp_test_names([baseline_bound_information_required, exception_bound_information_not_required, restriction_bound_may_be_restricted, certified_system_bound_may_be_omitted, automated_decision_bound_required, private_automated_decision_review_rights_apply, eu_direct_collection_automated_decision_must_be_disclosed, no_automated_decision_on_either_side_compares_same, eu_listed_case_bound_required, eu_direct_collection_settled_with_few_keys, comparison_bound_same, reversed_attribute_order_gives_the_same_answer, unsure_judgement_is_not_an_input_problem, unsure_crisp_key_is_wrong_type, atom_profile_is_wrong_type_profile, atom_profile_headline_is_wrong_type_profile, non_attribute_element_is_wrong_type_profile, duplicate_key_is_named_once_without_wrong_type, problems_come_in_contract_order_then_unknown_keys, non_atom_key_is_unknown_as_given, item_problem_follows_profile_problems, comparison_with_problems_fills_every_answer_position]).
cp_test_fail_names([baseline_bound_not_required_is_rejected, baseline_bound_restriction_is_rejected, exception_bound_required_is_rejected, restriction_bound_required_is_rejected, certified_system_bound_required_is_rejected, private_automated_decision_review_rights_are_not_denied, eu_direct_collection_automated_decision_is_not_exempt, no_automated_decision_on_either_side_does_not_differ]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
