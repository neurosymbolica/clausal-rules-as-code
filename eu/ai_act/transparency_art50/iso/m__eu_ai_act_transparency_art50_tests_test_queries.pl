% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_ai_act_transparency_art50_tests_test_queries, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_ai_act_transparency_art50_queries, [transparency_art50_profile_keys/1, transparency_art50_what_if/4, ai_system/0, information_timing/0, at_or_before_first_interaction_or_exposure/0, after_first_interaction_or_exposure/0, unsure/0, indeterminate/1, needs_legal_review/2, input_problems/1, unknown_key/1, wrong_type/1, duplicate_key/1]).
:- use_module(m__eu_ai_act_transparency_art50_kernel, [transparency_art50_input_problems/2]).
:- use_module(m__eu_ai_act_transparency_art50_transparency_art50, [transparency_duty_status/5, transparency_compliance/5, transparency_art50_checklist/2]).
:- use_module(m__eu_ai_act_transparency_art50_fixtures, [transparency_art50_profile_for/2]).

test(profile_keys_are_the_contract_keys) :-
    transparency_art50_profile_keys(ProfileKeys),
    ProfileKeys == [intended_to_interact_directly_with_natural_persons, interaction_obvious_to_a_reasonably_well_informed_observant_and_circumspect_person, generates_synthetic_audio_image_video_or_text_content, performs_an_assistive_function_for_standard_editing, does_not_substantially_alter_the_input_data_or_its_semantics, emotion_recognition_or_biometric_categorisation_system, permitted_by_law_to_detect_prevent_or_investigate_criminal_offences, generates_or_manipulates_deep_fake_image_audio_or_video_content, generates_or_manipulates_text_published_to_inform_the_public_on_matters_of_public_interest, used_in_a_personal_non_professional_activity, authorised_by_law_to_detect_prevent_investigate_or_prosecute_criminal_offences, available_for_the_public_to_report_a_criminal_offence, content_underwent_human_review_or_editorial_control, natural_or_legal_person_holds_editorial_responsibility, ai_system, part_of_an_evidently_artistic_creative_satirical_fictional_or_analogous_work, placed_on_the_market_before_2_august_2026, required_information_given, disclosure_of_existence_appropriate_and_does_not_hamper_the_work, information_timing, provided_in_a_clear_and_distinguishable_manner, conforms_to_the_applicable_accessibility_requirements, outputs_marked_machine_readable_and_detectable_as_artificially_generated].
test(profile_keys_are_distinct) :-
    transparency_art50_profile_keys(ProfileKeys),
    sort(ProfileKeys, KeySet),
    length(KeySet, 23).
test(no_profile_key_is_an_unknown_key) :-
    transparency_art50_profile_keys(ProfileKeys),
    findall(attribute(ProfileKey, false), member(ProfileKey, ProfileKeys), Attributes),
    transparency_art50_input_problems(Attributes, Problems),
    Problems == [wrong_type(information_timing)].
test(the_status_query_answers_once) :-
    transparency_art50_profile_for(public_interest_text_duty_applies, Profile),
    findall(Result - Citations, transparency_duty_status(Profile, public_interest_text_disclosure, date(2027, 1, 1), Result, Citations), Answers),
    Answers == [duty_applies - [cite(eu_reg_2024_1689_art_50_4)]].
test(the_compliance_query_answers_once) :-
    transparency_art50_profile_for(deep_fake_artistic_disclosure_appropriate, Profile),
    findall(Result - Citations, transparency_compliance(Profile, deep_fake_disclosure, date(2027, 1, 1), Result, Citations), Answers),
    Answers == [compliant - [cite(eu_reg_2024_1689_art_50_4), cite(eu_reg_2024_1689_art_50_5)]].
test(the_checklist_carries_cite_provenance_per_item) :-
    transparency_art50_profile_for(assistant_information_not_given, Profile),
    transparency_art50_checklist(transparency_question(compliance, Profile, interaction_information, date(2027, 1, 1)), ChecklistItems),
    maplist(cited_item, ChecklistItems),
    member(item(required_information_given, unmet(fails), cite(eu_reg_2024_1689_art_50_5)), ChecklistItems).
test(a_public_reporting_channel_brings_the_duty_back) :-
    transparency_art50_profile_for(police_system_exception, Profile),
    transparency_art50_what_if(transparency_question(duty_status, Profile, interaction_information, date(2027, 1, 1)), available_for_the_public_to_report_a_criminal_offence, true, duty_applies).
test(a_hampering_disclosure_makes_the_deep_fake_not_compliant) :-
    transparency_art50_profile_for(deep_fake_artistic_disclosure_appropriate, Profile),
    transparency_art50_what_if(transparency_question(compliance, Profile, deep_fake_disclosure, date(2027, 1, 1)), disclosure_of_existence_appropriate_and_does_not_hamper_the_work, false, not_compliant).
test(a_later_placement_ends_the_window) :-
    transparency_art50_profile_for(marking_legacy_last_transitional_day, Profile),
    transparency_art50_what_if(transparency_question(duty_status, Profile, machine_readable_marking, date(2026, 12, 1)), placed_on_the_market_before_2_august_2026, false, duty_applies).
test(late_information_makes_the_text_disclosure_not_compliant) :-
    transparency_art50_profile_for(public_interest_text_disclosed_clearly, Profile),
    findall(NewResult, transparency_art50_what_if(transparency_question(compliance, Profile, public_interest_text_disclosure, date(2027, 1, 1)), information_timing, after_first_interaction_or_exposure, NewResult), Results),
    Results == [not_compliant].
test(the_override_replaces_every_occurrence_of_a_duplicate) :-
    transparency_art50_profile_for(input_duplicate_key, Profile),
    transparency_art50_what_if(transparency_question(duty_status, Profile, interaction_information, date(2027, 1, 1)), ai_system, true, indeterminate([intended_to_interact_directly_with_natural_persons])).
test(an_unsure_override_that_turns_the_answer_is_referred) :-
    transparency_art50_profile_for(conversational_assistant_duty_applies, Profile),
    transparency_art50_what_if(transparency_question(duty_status, Profile, interaction_information, date(2027, 1, 1)), ai_system, unsure, needs_legal_review(open_textured(ai_system, cite(eu_reg_2024_1689_art_3_1)), _Context)).
test(the_input_check_names_an_unknown_key) :-
    transparency_art50_input_problems([attribute(colour, red)], [unknown_key(colour)]).
test(the_root_export_atoms_are_callable) :-
    ai_system,
    information_timing,
    at_or_before_first_interaction_or_exposure,
    after_first_interaction_or_exposure,
    unsure.
test(indeterminate_names_one_contract_key) :-
    indeterminate([placed_on_the_market_before_2_august_2026]).
test(needs_legal_review_has_its_shape) :-
    needs_legal_review(open_textured(part_of_an_evidently_artistic_creative_satirical_fictional_or_analogous_work, cite(eu_reg_2024_1689_art_50_4)), [inputs_relied_on([ai_system - true])]).
test(input_problems_has_its_shape) :-
    input_problems([duplicate_key(ai_system), unknown_key(colour)]).
test(unknown_key_is_outside_the_contract) :-
    unknown_key(colour).
test(wrong_type_names_a_contract_key_or_an_argument) :-
    wrong_type(required_information_given),
    wrong_type(duty),
    wrong_type(assessment_date),
    wrong_type(profile).
test(duplicate_key_names_a_contract_key) :-
    duplicate_key(information_timing).

cited_item(item(_, _, cite(_))).

test(indeterminate_never_names_an_unknown_key, fail) :-
    indeterminate([colour]).
test(input_problems_rejects_a_foreign_term, fail) :-
    input_problems([missing_key(ai_system)]).
test(unknown_key_is_never_a_contract_key, fail) :-
    unknown_key(information_timing).
test(wrong_type_never_names_an_unknown_key, fail) :-
    wrong_type(colour).
test(duplicate_key_never_names_the_duty, fail) :-
    duplicate_key(duty).

cp_test_names([profile_keys_are_the_contract_keys, profile_keys_are_distinct, no_profile_key_is_an_unknown_key, the_status_query_answers_once, the_compliance_query_answers_once, the_checklist_carries_cite_provenance_per_item, a_public_reporting_channel_brings_the_duty_back, a_hampering_disclosure_makes_the_deep_fake_not_compliant, a_later_placement_ends_the_window, late_information_makes_the_text_disclosure_not_compliant, the_override_replaces_every_occurrence_of_a_duplicate, an_unsure_override_that_turns_the_answer_is_referred, the_input_check_names_an_unknown_key, the_root_export_atoms_are_callable, indeterminate_names_one_contract_key, needs_legal_review_has_its_shape, input_problems_has_its_shape, unknown_key_is_outside_the_contract, wrong_type_names_a_contract_key_or_an_argument, duplicate_key_names_a_contract_key]).
cp_test_fail_names([indeterminate_never_names_an_unknown_key, input_problems_rejects_a_foreign_term, unknown_key_is_never_a_contract_key, wrong_type_never_names_an_unknown_key, duplicate_key_never_names_the_duty]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
