% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_ai_act_transparency_art50_fixtures, [transparency_art50_subject/1, transparency_art50_profile_for/2, transparency_art50_assess/2]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_lists, [msort/2]).
:- use_module(m__eu_ai_act_transparency_art50_transparency_art50, [decide_transparency_art50/2]).

transparency_art50_subject(interaction_before_application_day).
transparency_art50_subject(interaction_first_day_of_application).
transparency_art50_subject(conversational_assistant_duty_applies).
transparency_art50_subject(conversational_assistant_obvious).
transparency_art50_subject(police_system_exception).
transparency_art50_subject(police_reporting_portal).
transparency_art50_subject(rule_based_assistant_outside_definition).
transparency_art50_subject(assistant_system_status_unknown).
transparency_art50_subject(assistant_informed_on_time).
transparency_art50_subject(assistant_information_not_given).
transparency_art50_subject(marking_legacy_last_transitional_day).
transparency_art50_subject(marking_legacy_first_binding_day).
transparency_art50_subject(marking_new_system_last_transitional_day).
transparency_art50_subject(marking_assistive_editing).
transparency_art50_subject(marking_placement_unknown_in_window).
transparency_art50_subject(marking_outputs_marked).
transparency_art50_subject(marking_outputs_unmarked).
transparency_art50_subject(marking_compliance_in_transition).
transparency_art50_subject(emotion_recognition_duty_applies).
transparency_art50_subject(emotion_recognition_personal_use).
transparency_art50_subject(emotion_recognition_informed_on_time).
transparency_art50_subject(emotion_recognition_informed_late).
transparency_art50_subject(deep_fake_duty_applies).
transparency_art50_subject(deep_fake_artistic_work).
transparency_art50_subject(deep_fake_artistic_disclosure_appropriate).
transparency_art50_subject(deep_fake_artistic_disclosure_hampering).
transparency_art50_subject(deep_fake_artistic_judgement_unsure).
transparency_art50_subject(public_interest_text_duty_applies).
transparency_art50_subject(public_interest_text_edited_with_responsibility).
transparency_art50_subject(public_interest_text_reviewed_without_responsibility).
transparency_art50_subject(public_interest_text_disclosed_clearly).
transparency_art50_subject(public_interest_text_disclosed_unclearly).
transparency_art50_subject(unsure_judgement_not_deciding).
transparency_art50_subject(unsure_judgement_missing_fact).
transparency_art50_subject(unsure_judgement_outside_query).
transparency_art50_subject(empty_profile_first_key).
transparency_art50_subject(input_unknown_key).
transparency_art50_subject(input_duplicate_key).
transparency_art50_subject(input_crisp_key_unsure).
transparency_art50_subject(input_unknown_duty).
transparency_art50_subject(input_impossible_date).
transparency_art50_subject(input_several_problems).

fixture_question(interaction_before_application_day, duty_status, interaction_information, date(2026, 8, 1)).
fixture_question(interaction_first_day_of_application, duty_status, interaction_information, date(2026, 8, 2)).
fixture_question(conversational_assistant_duty_applies, duty_status, interaction_information, date(2027, 1, 1)).
fixture_question(conversational_assistant_obvious, duty_status, interaction_information, date(2027, 1, 1)).
fixture_question(police_system_exception, duty_status, interaction_information, date(2027, 1, 1)).
fixture_question(police_reporting_portal, duty_status, interaction_information, date(2027, 1, 1)).
fixture_question(rule_based_assistant_outside_definition, duty_status, interaction_information, date(2027, 1, 1)).
fixture_question(assistant_system_status_unknown, duty_status, interaction_information, date(2027, 1, 1)).
fixture_question(assistant_informed_on_time, compliance, interaction_information, date(2027, 1, 1)).
fixture_question(assistant_information_not_given, compliance, interaction_information, date(2027, 1, 1)).
fixture_question(marking_legacy_last_transitional_day, duty_status, machine_readable_marking, date(2026, 12, 1)).
fixture_question(marking_legacy_first_binding_day, duty_status, machine_readable_marking, date(2026, 12, 2)).
fixture_question(marking_new_system_last_transitional_day, duty_status, machine_readable_marking, date(2026, 12, 1)).
fixture_question(marking_assistive_editing, duty_status, machine_readable_marking, date(2027, 1, 1)).
fixture_question(marking_placement_unknown_in_window, duty_status, machine_readable_marking, date(2026, 9, 1)).
fixture_question(marking_outputs_marked, compliance, machine_readable_marking, date(2026, 12, 2)).
fixture_question(marking_outputs_unmarked, compliance, machine_readable_marking, date(2026, 12, 2)).
fixture_question(marking_compliance_in_transition, compliance, machine_readable_marking, date(2026, 12, 1)).
fixture_question(emotion_recognition_duty_applies, duty_status, emotion_recognition_or_biometric_categorisation_information, date(2027, 1, 1)).
fixture_question(emotion_recognition_personal_use, duty_status, emotion_recognition_or_biometric_categorisation_information, date(2027, 1, 1)).
fixture_question(emotion_recognition_informed_on_time, compliance, emotion_recognition_or_biometric_categorisation_information, date(2027, 1, 1)).
fixture_question(emotion_recognition_informed_late, compliance, emotion_recognition_or_biometric_categorisation_information, date(2027, 1, 1)).
fixture_question(deep_fake_duty_applies, duty_status, deep_fake_disclosure, date(2027, 1, 1)).
fixture_question(deep_fake_artistic_work, duty_status, deep_fake_disclosure, date(2027, 1, 1)).
fixture_question(deep_fake_artistic_disclosure_appropriate, compliance, deep_fake_disclosure, date(2027, 1, 1)).
fixture_question(deep_fake_artistic_disclosure_hampering, compliance, deep_fake_disclosure, date(2027, 1, 1)).
fixture_question(deep_fake_artistic_judgement_unsure, duty_status, deep_fake_disclosure, date(2027, 1, 1)).
fixture_question(public_interest_text_duty_applies, duty_status, public_interest_text_disclosure, date(2027, 1, 1)).
fixture_question(public_interest_text_edited_with_responsibility, duty_status, public_interest_text_disclosure, date(2027, 1, 1)).
fixture_question(public_interest_text_reviewed_without_responsibility, duty_status, public_interest_text_disclosure, date(2027, 1, 1)).
fixture_question(public_interest_text_disclosed_clearly, compliance, public_interest_text_disclosure, date(2027, 1, 1)).
fixture_question(public_interest_text_disclosed_unclearly, compliance, public_interest_text_disclosure, date(2027, 1, 1)).
fixture_question(unsure_judgement_not_deciding, duty_status, interaction_information, date(2027, 1, 1)).
fixture_question(unsure_judgement_missing_fact, duty_status, interaction_information, date(2027, 1, 1)).
fixture_question(unsure_judgement_outside_query, duty_status, interaction_information, date(2027, 1, 1)).
fixture_question(empty_profile_first_key, duty_status, interaction_information, date(2027, 1, 1)).
fixture_question(input_unknown_key, duty_status, interaction_information, date(2027, 1, 1)).
fixture_question(input_duplicate_key, duty_status, interaction_information, date(2027, 1, 1)).
fixture_question(input_crisp_key_unsure, compliance, interaction_information, date(2027, 1, 1)).
fixture_question(input_unknown_duty, duty_status, unknown_duty, date(2027, 1, 1)).
fixture_question(input_impossible_date, compliance, deep_fake_disclosure, date(2026, 2, 30)).
fixture_question(input_several_problems, duty_status, unknown_duty, date(2027, 1, 1)).

interaction_facts(Obvious, Authorised, [attribute(intended_to_interact_directly_with_natural_persons, true), attribute(interaction_obvious_to_a_reasonably_well_informed_observant_and_circumspect_person, Obvious), attribute(authorised_by_law_to_detect_prevent_investigate_or_prosecute_criminal_offences, Authorised)]).

marking_facts(Assistive, [attribute(generates_synthetic_audio_image_video_or_text_content, true), attribute(performs_an_assistive_function_for_standard_editing, Assistive), attribute(does_not_substantially_alter_the_input_data_or_its_semantics, false), attribute(authorised_by_law_to_detect_prevent_investigate_or_prosecute_criminal_offences, false), attribute(ai_system, true)]).

emotion_facts(PersonalUse, [attribute(emotion_recognition_or_biometric_categorisation_system, true), attribute(permitted_by_law_to_detect_prevent_or_investigate_criminal_offences, false), attribute(used_in_a_personal_non_professional_activity, PersonalUse), attribute(ai_system, true)]).

deep_fake_facts(Artistic, [attribute(generates_or_manipulates_deep_fake_image_audio_or_video_content, true), attribute(used_in_a_personal_non_professional_activity, false), attribute(authorised_by_law_to_detect_prevent_investigate_or_prosecute_criminal_offences, false), attribute(ai_system, true), attribute(part_of_an_evidently_artistic_creative_satirical_fictional_or_analogous_work, Artistic)]).

public_text_facts(Review, Responsibility, [attribute(generates_or_manipulates_text_published_to_inform_the_public_on_matters_of_public_interest, true), attribute(used_in_a_personal_non_professional_activity, false), attribute(authorised_by_law_to_detect_prevent_investigate_or_prosecute_criminal_offences, false), attribute(content_underwent_human_review_or_editorial_control, Review), attribute(natural_or_legal_person_holds_editorial_responsibility, Responsibility), attribute(ai_system, true)]).

information_facts(Given, Timing, Clear, Accessible, [attribute(required_information_given, Given), attribute(information_timing, Timing), attribute(provided_in_a_clear_and_distinguishable_manner, Clear), attribute(conforms_to_the_applicable_accessibility_requirements, Accessible)]).

transparency_art50_profile_for(interaction_before_application_day, Profile) :-
    interaction_facts(false, false, Facts),
    append(Facts, [attribute(ai_system, true)], Profile).
transparency_art50_profile_for(interaction_first_day_of_application, Profile) :-
    interaction_facts(false, false, Facts),
    append(Facts, [attribute(ai_system, true)], Profile).
transparency_art50_profile_for(conversational_assistant_duty_applies, Profile) :-
    interaction_facts(false, false, Facts),
    append(Facts, [attribute(ai_system, true)], Profile).
transparency_art50_profile_for(conversational_assistant_obvious, Profile) :-
    interaction_facts(true, false, Facts),
    append(Facts, [attribute(ai_system, true)], Profile).
transparency_art50_profile_for(police_system_exception, Profile) :-
    interaction_facts(false, true, Facts),
    append(Facts, [attribute(available_for_the_public_to_report_a_criminal_offence, false), attribute(ai_system, true)], Profile).
transparency_art50_profile_for(police_reporting_portal, Profile) :-
    interaction_facts(false, true, Facts),
    append(Facts, [attribute(available_for_the_public_to_report_a_criminal_offence, true), attribute(ai_system, true)], Profile).
transparency_art50_profile_for(rule_based_assistant_outside_definition, Profile) :-
    interaction_facts(false, false, Facts),
    append(Facts, [attribute(ai_system, false)], Profile).
transparency_art50_profile_for(assistant_system_status_unknown, Profile) :-
    interaction_facts(false, false, Profile).
transparency_art50_profile_for(assistant_informed_on_time, Profile) :-
    interaction_facts(false, false, Facts),
    information_facts(true, at_or_before_first_interaction_or_exposure, true, true, Information),
    append([Facts, [attribute(ai_system, true)], Information], Profile).
transparency_art50_profile_for(assistant_information_not_given, Profile) :-
    interaction_facts(false, false, Facts),
    information_facts(false, at_or_before_first_interaction_or_exposure, true, true, Information),
    append([Facts, [attribute(ai_system, true)], Information], Profile).
transparency_art50_profile_for(marking_legacy_last_transitional_day, Profile) :-
    marking_facts(false, Facts),
    append(Facts, [attribute(placed_on_the_market_before_2_august_2026, true)], Profile).
transparency_art50_profile_for(marking_legacy_first_binding_day, Profile) :-
    marking_facts(false, Facts),
    append(Facts, [attribute(placed_on_the_market_before_2_august_2026, true)], Profile).
transparency_art50_profile_for(marking_new_system_last_transitional_day, Profile) :-
    marking_facts(false, Facts),
    append(Facts, [attribute(placed_on_the_market_before_2_august_2026, false)], Profile).
transparency_art50_profile_for(marking_assistive_editing, Profile) :-
    marking_facts(true, Facts),
    append(Facts, [attribute(placed_on_the_market_before_2_august_2026, false)], Profile).
transparency_art50_profile_for(marking_placement_unknown_in_window, Profile) :-
    marking_facts(false, Profile).
transparency_art50_profile_for(marking_outputs_marked, Profile) :-
    marking_facts(false, Facts),
    append(Facts, [attribute(placed_on_the_market_before_2_august_2026, true), attribute(outputs_marked_machine_readable_and_detectable_as_artificially_generated, true)], Profile).
transparency_art50_profile_for(marking_outputs_unmarked, Profile) :-
    marking_facts(false, Facts),
    append(Facts, [attribute(placed_on_the_market_before_2_august_2026, true), attribute(outputs_marked_machine_readable_and_detectable_as_artificially_generated, false)], Profile).
transparency_art50_profile_for(marking_compliance_in_transition, Profile) :-
    marking_facts(false, Facts),
    append(Facts, [attribute(placed_on_the_market_before_2_august_2026, true), attribute(outputs_marked_machine_readable_and_detectable_as_artificially_generated, false)], Profile).
transparency_art50_profile_for(emotion_recognition_duty_applies, Profile) :-
    emotion_facts(false, Profile).
transparency_art50_profile_for(emotion_recognition_personal_use, Profile) :-
    emotion_facts(true, Profile).
transparency_art50_profile_for(emotion_recognition_informed_on_time, Profile) :-
    emotion_facts(false, Facts),
    information_facts(true, at_or_before_first_interaction_or_exposure, true, true, Information),
    append(Facts, Information, Profile).
transparency_art50_profile_for(emotion_recognition_informed_late, Profile) :-
    emotion_facts(false, Facts),
    information_facts(true, after_first_interaction_or_exposure, true, true, Information),
    append(Facts, Information, Profile).
transparency_art50_profile_for(deep_fake_duty_applies, Profile) :-
    deep_fake_facts(false, Profile).
transparency_art50_profile_for(deep_fake_artistic_work, Profile) :-
    deep_fake_facts(true, Profile).
transparency_art50_profile_for(deep_fake_artistic_disclosure_appropriate, Profile) :-
    deep_fake_facts(true, Facts),
    information_facts(true, at_or_before_first_interaction_or_exposure, true, true, Information),
    append([Facts, Information, [attribute(disclosure_of_existence_appropriate_and_does_not_hamper_the_work, true)]], Profile).
transparency_art50_profile_for(deep_fake_artistic_disclosure_hampering, Profile) :-
    deep_fake_facts(true, Facts),
    information_facts(true, at_or_before_first_interaction_or_exposure, true, true, Information),
    append([Facts, Information, [attribute(disclosure_of_existence_appropriate_and_does_not_hamper_the_work, false)]], Profile).
transparency_art50_profile_for(deep_fake_artistic_judgement_unsure, Profile) :-
    deep_fake_facts(unsure, Profile).
transparency_art50_profile_for(public_interest_text_duty_applies, Profile) :-
    public_text_facts(false, false, Profile).
transparency_art50_profile_for(public_interest_text_edited_with_responsibility, Profile) :-
    public_text_facts(true, true, Profile).
transparency_art50_profile_for(public_interest_text_reviewed_without_responsibility, Profile) :-
    public_text_facts(true, false, Profile).
transparency_art50_profile_for(public_interest_text_disclosed_clearly, Profile) :-
    public_text_facts(false, false, Facts),
    information_facts(true, at_or_before_first_interaction_or_exposure, true, true, Information),
    append(Facts, Information, Profile).
transparency_art50_profile_for(public_interest_text_disclosed_unclearly, Profile) :-
    public_text_facts(false, false, Facts),
    information_facts(true, at_or_before_first_interaction_or_exposure, false, true, Information),
    append(Facts, Information, Profile).
transparency_art50_profile_for(unsure_judgement_not_deciding, [attribute(intended_to_interact_directly_with_natural_persons, false), attribute(interaction_obvious_to_a_reasonably_well_informed_observant_and_circumspect_person, unsure)]).
transparency_art50_profile_for(unsure_judgement_missing_fact, [attribute(intended_to_interact_directly_with_natural_persons, true), attribute(interaction_obvious_to_a_reasonably_well_informed_observant_and_circumspect_person, unsure)]).
transparency_art50_profile_for(unsure_judgement_outside_query, Profile) :-
    interaction_facts(false, false, Facts),
    append(Facts, [attribute(ai_system, true), attribute(outputs_marked_machine_readable_and_detectable_as_artificially_generated, unsure)], Profile).
transparency_art50_profile_for(empty_profile_first_key, []).
transparency_art50_profile_for(input_unknown_key, [attribute(colour, red)]).
transparency_art50_profile_for(input_duplicate_key, [attribute(ai_system, true), attribute(ai_system, false)]).
transparency_art50_profile_for(input_crisp_key_unsure, [attribute(required_information_given, unsure)]).
transparency_art50_profile_for(input_unknown_duty, []).
transparency_art50_profile_for(input_impossible_date, []).
transparency_art50_profile_for(input_several_problems, [attribute(colour, red), attribute(ai_system, maybe)]).

transparency_art50_assess(Subject, Verdict) :-
    fixture_question(Subject, QueryKind, DutyName, AssessmentDate),
    transparency_art50_profile_for(Subject, Profile),
    decide_transparency_art50(transparency_question(QueryKind, Profile, DutyName, AssessmentDate), Verdict).

registered_subjects(Subjects) :-
    findall(Subject, transparency_art50_subject(Subject), Subjects).

subject_is_complete(Subject) :-
    findall(QueryKind, fixture_question(Subject, QueryKind, _, _), QueryKinds),
    length(QueryKinds, 1),
    findall(Profile, transparency_art50_profile_for(Subject, Profile), Profiles),
    length(Profiles, 1).

subject_assesses_once(Subject) :-
    findall(Verdict, transparency_art50_assess(Subject, Verdict), Verdicts),
    length(Verdicts, 1).

test(every_subject_has_one_question_and_one_profile) :-
    registered_subjects(Subjects),
    maplist(subject_is_complete, Subjects).
test(every_question_belongs_to_a_registered_subject) :-
    registered_subjects(Subjects),
    findall(Subject, fixture_question(Subject, _, _, _), Asked),
    msort(Subjects, Sorted),
    msort(Asked, Sorted).
test(every_subject_assesses_once) :-
    registered_subjects(Subjects),
    maplist(subject_assesses_once, Subjects).
test(the_first_day_of_application_has_the_duty) :-
    transparency_art50_assess(interaction_first_day_of_application, transparency_art50_verdict(duty_applies, [cite(eu_reg_2024_1689_art_50_1)])).

test(the_day_before_application_has_no_duty, fail) :-
    transparency_art50_assess(interaction_before_application_day, transparency_art50_verdict(duty_applies, _)).
