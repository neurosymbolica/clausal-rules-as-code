% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_ai_act_transparency_art50_queries, [transparency_art50_profile_keys/1, transparency_art50_what_if/4, intended_to_interact_directly_with_natural_persons/0, interaction_obvious_to_a_reasonably_well_informed_observant_and_circumspect_person/0, generates_synthetic_audio_image_video_or_text_content/0, performs_an_assistive_function_for_standard_editing/0, does_not_substantially_alter_the_input_data_or_its_semantics/0, emotion_recognition_or_biometric_categorisation_system/0, permitted_by_law_to_detect_prevent_or_investigate_criminal_offences/0, generates_or_manipulates_deep_fake_image_audio_or_video_content/0, generates_or_manipulates_text_published_to_inform_the_public_on_matters_of_public_interest/0, used_in_a_personal_non_professional_activity/0, authorised_by_law_to_detect_prevent_investigate_or_prosecute_criminal_offences/0, available_for_the_public_to_report_a_criminal_offence/0, content_underwent_human_review_or_editorial_control/0, natural_or_legal_person_holds_editorial_responsibility/0, ai_system/0, part_of_an_evidently_artistic_creative_satirical_fictional_or_analogous_work/0, placed_on_the_market_before_2_august_2026/0, required_information_given/0, disclosure_of_existence_appropriate_and_does_not_hamper_the_work/0, information_timing/0, provided_in_a_clear_and_distinguishable_manner/0, conforms_to_the_applicable_accessibility_requirements/0, outputs_marked_machine_readable_and_detectable_as_artificially_generated/0, at_or_before_first_interaction_or_exposure/0, after_first_interaction_or_exposure/0, unsure/0, interaction_information/0, machine_readable_marking/0, emotion_recognition_or_biometric_categorisation_information/0, deep_fake_disclosure/0, public_interest_text_disclosure/0, duty_applies/0, limited_disclosure_applies/0, duty_does_not_apply/0, not_applicable_on_date/0, not_an_ai_system/0, in_transitional_period/0, compliant/0, not_compliant/0, indeterminate/1, needs_legal_review/2, provenance/2, input_problems/1, unknown_key/1, wrong_type/1, duplicate_key/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_lists_extra, [last/2, is_list/1]).
:- use_module(library(reif), [memberd_t/3]).
:- use_module(formalize_lib, [not_member/2]).
:- use_module(m__eu_ai_act_transparency_art50_kernel, [transparency_art50_input_problems/2]).
:- use_module(m__eu_ai_act_transparency_art50_citations, [citation_vocabulary/1]).
:- use_module(m__eu_ai_act_transparency_art50_transparency_art50, [transparency_art50_status/2]).

transparency_art50_profile_keys([intended_to_interact_directly_with_natural_persons, interaction_obvious_to_a_reasonably_well_informed_observant_and_circumspect_person, generates_synthetic_audio_image_video_or_text_content, performs_an_assistive_function_for_standard_editing, does_not_substantially_alter_the_input_data_or_its_semantics, emotion_recognition_or_biometric_categorisation_system, permitted_by_law_to_detect_prevent_or_investigate_criminal_offences, generates_or_manipulates_deep_fake_image_audio_or_video_content, generates_or_manipulates_text_published_to_inform_the_public_on_matters_of_public_interest, used_in_a_personal_non_professional_activity, authorised_by_law_to_detect_prevent_investigate_or_prosecute_criminal_offences, available_for_the_public_to_report_a_criminal_offence, content_underwent_human_review_or_editorial_control, natural_or_legal_person_holds_editorial_responsibility, ai_system, part_of_an_evidently_artistic_creative_satirical_fictional_or_analogous_work, placed_on_the_market_before_2_august_2026, required_information_given, disclosure_of_existence_appropriate_and_does_not_hamper_the_work, information_timing, provided_in_a_clear_and_distinguishable_manner, conforms_to_the_applicable_accessibility_requirements, outputs_marked_machine_readable_and_detectable_as_artificially_generated]).

transparency_art50_what_if(transparency_question(QueryKind, Profile, DutyName, AssessmentDate), ProfileKey, NewValue, NewResult) :-
    override_attribute(Profile, ProfileKey, NewValue, Hypothesis),
    transparency_art50_status(transparency_question(QueryKind, Hypothesis, DutyName, AssessmentDate), NewResult).

override_attribute(Profile, ProfileKey, NewValue, Hypothesis) :-
    attributes_without(Profile, ProfileKey, Remaining),
    append(Remaining, [attribute(ProfileKey, NewValue)], Hypothesis).

attributes_without([], _, []).
attributes_without([attribute(OtherKey, Given)|Elements], ProfileKey, [attribute(OtherKey, Given)|Remaining]) :-
    OtherKey \== ProfileKey,
    attributes_without(Elements, ProfileKey, Remaining).
attributes_without([attribute(OtherKey, _)|Elements], ProfileKey, Remaining) :-
    OtherKey == ProfileKey,
    attributes_without(Elements, ProfileKey, Remaining).

indeterminate([Key]) :-
    transparency_art50_profile_keys(ProfileKeys),
    memberd_t(Key, ProfileKeys, true).

needs_legal_review(open_textured(Key, cite(CitationKey)), [inputs_relied_on(Pairs)]) :-
    transparency_art50_profile_keys(ProfileKeys),
    memberd_t(Key, ProfileKeys, true),
    citation_vocabulary(CitationKey),
    is_list(Pairs).

input_problems([Problem|Problems]) :-
    maplist(problem_term, [Problem|Problems]).

problem_term(unknown_key(Key)) :-
    unknown_key(Key).
problem_term(wrong_type(Key)) :-
    wrong_type(Key).
problem_term(duplicate_key(Key)) :-
    duplicate_key(Key).

unknown_key(Key) :-
    transparency_art50_profile_keys(ProfileKeys),
    not_member(Key, ProfileKeys).

wrong_type(Key) :-
    transparency_art50_profile_keys(ProfileKeys),
    append(ProfileKeys, [profile, duty, assessment_date], TypedNames),
    memberd_t(Key, TypedNames, true).

duplicate_key(Key) :-
    transparency_art50_profile_keys(ProfileKeys),
    memberd_t(Key, ProfileKeys, true).

intended_to_interact_directly_with_natural_persons.

interaction_obvious_to_a_reasonably_well_informed_observant_and_circumspect_person.

generates_synthetic_audio_image_video_or_text_content.

performs_an_assistive_function_for_standard_editing.

does_not_substantially_alter_the_input_data_or_its_semantics.

emotion_recognition_or_biometric_categorisation_system.

permitted_by_law_to_detect_prevent_or_investigate_criminal_offences.

generates_or_manipulates_deep_fake_image_audio_or_video_content.

generates_or_manipulates_text_published_to_inform_the_public_on_matters_of_public_interest.

used_in_a_personal_non_professional_activity.

authorised_by_law_to_detect_prevent_investigate_or_prosecute_criminal_offences.

available_for_the_public_to_report_a_criminal_offence.

content_underwent_human_review_or_editorial_control.

natural_or_legal_person_holds_editorial_responsibility.

ai_system.

part_of_an_evidently_artistic_creative_satirical_fictional_or_analogous_work.

placed_on_the_market_before_2_august_2026.

required_information_given.

disclosure_of_existence_appropriate_and_does_not_hamper_the_work.

information_timing.

provided_in_a_clear_and_distinguishable_manner.

conforms_to_the_applicable_accessibility_requirements.

outputs_marked_machine_readable_and_detectable_as_artificially_generated.

at_or_before_first_interaction_or_exposure.

after_first_interaction_or_exposure.

unsure.

interaction_information.

machine_readable_marking.

emotion_recognition_or_biometric_categorisation_information.

deep_fake_disclosure.

public_interest_text_disclosure.

duty_applies.

limited_disclosure_applies.

duty_does_not_apply.

not_applicable_on_date.

not_an_ai_system.

in_transitional_period.

compliant.

not_compliant.

provenance(_Clause, Citations) :-
    var(Citations),
    Citations = [].
provenance(_Clause, Citations) :-
    nonvar(Citations).

assistant_question(transparency_question(duty_status, [attribute(intended_to_interact_directly_with_natural_persons, true), attribute(interaction_obvious_to_a_reasonably_well_informed_observant_and_circumspect_person, false), attribute(authorised_by_law_to_detect_prevent_investigate_or_prosecute_criminal_offences, false), attribute(ai_system, true)], interaction_information, date(2027, 1, 1))).

assistant_question_without_system_judgement(transparency_question(duty_status, [attribute(intended_to_interact_directly_with_natural_persons, true), attribute(interaction_obvious_to_a_reasonably_well_informed_observant_and_circumspect_person, false), attribute(authorised_by_law_to_detect_prevent_investigate_or_prosecute_criminal_offences, false)], interaction_information, date(2027, 1, 1))).

test(the_assistant_question_has_the_duty) :-
    assistant_question(Question),
    transparency_art50_status(Question, duty_applies).
test(an_obvious_interaction_takes_the_duty_out) :-
    assistant_question(Question),
    transparency_art50_what_if(Question, interaction_obvious_to_a_reasonably_well_informed_observant_and_circumspect_person, true, duty_does_not_apply).
test(a_system_outside_the_definition_is_not_an_ai_system) :-
    assistant_question(Question),
    transparency_art50_what_if(Question, ai_system, false, not_an_ai_system).
test(the_what_if_gives_one_answer) :-
    assistant_question(Question),
    findall(NewResult, transparency_art50_what_if(Question, ai_system, false, NewResult), Results),
    Results == [not_an_ai_system].
test(the_override_adds_an_absent_key) :-
    assistant_question_without_system_judgement(Question),
    transparency_art50_status(Question, indeterminate([ai_system])),
    transparency_art50_what_if(Question, ai_system, true, duty_applies).
test(an_overridden_value_outside_its_type_is_an_input_problem) :-
    assistant_question(Question),
    transparency_art50_what_if(Question, ai_system, maybe, input_problems([wrong_type(ai_system)])).
test(the_profile_keys_are_the_twenty_three_of_the_contract) :-
    transparency_art50_profile_keys(ProfileKeys),
    length(ProfileKeys, 23),
    ProfileKeys = [intended_to_interact_directly_with_natural_persons|_],
    last(ProfileKeys, outputs_marked_machine_readable_and_detectable_as_artificially_generated).
test(the_input_check_is_re_exported) :-
    transparency_art50_input_problems([attribute(colour, red)], [unknown_key(colour)]).
test(the_vocabulary_is_named) :-
    duty_applies,
    compliant,
    interaction_information.
test(the_provenance_constructor_gives_one_ground_answer) :-
    findall(Citations, provenance(deciding_clause, Citations), Answers),
    Answers == [[]].
test(the_root_export_atoms_are_named) :-
    ai_system,
    information_timing,
    at_or_before_first_interaction_or_exposure,
    after_first_interaction_or_exposure,
    unsure,
    outputs_marked_machine_readable_and_detectable_as_artificially_generated.
test(an_indeterminate_answer_names_one_contract_key) :-
    indeterminate([ai_system]).
test(a_referral_has_its_shape) :-
    needs_legal_review(open_textured(ai_system, cite(eu_reg_2024_1689_art_3_1)), [inputs_relied_on([ai_system - unsure])]).
test(an_input_problem_list_has_its_shape) :-
    input_problems([wrong_type(ai_system), unknown_key(colour), wrong_type(duty)]).
test(a_key_outside_the_contract_is_an_unknown_key) :-
    unknown_key(colour).
test(the_duty_argument_can_have_a_wrong_type) :-
    wrong_type(duty),
    wrong_type(assessment_date),
    wrong_type(information_timing).
test(a_contract_key_can_be_a_duplicate) :-
    duplicate_key(ai_system).

test(an_obvious_interaction_does_not_keep_the_duty, fail) :-
    assistant_question(Question),
    transparency_art50_what_if(Question, interaction_obvious_to_a_reasonably_well_informed_observant_and_circumspect_person, true, duty_applies).
test(an_indeterminate_answer_never_names_two_keys, fail) :-
    indeterminate([ai_system, information_timing]).
test(a_referral_with_a_shortened_citation_is_not_its_shape, fail) :-
    ShortenedCitation =.. [cite, shortened_article_key],
    needs_legal_review(open_textured(ai_system, ShortenedCitation), [inputs_relied_on([ai_system - unsure])]).
test(an_empty_input_problem_list_is_not_its_shape, fail) :-
    input_problems([]).
test(a_contract_key_is_not_an_unknown_key, fail) :-
    unknown_key(ai_system).
test(an_unknown_name_is_not_a_wrong_type, fail) :-
    wrong_type(colour).
test(an_unknown_name_is_not_a_duplicate_key, fail) :-
    duplicate_key(colour).
