% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_ai_act_transparency_art50_tests_test_public_interface, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_lists, [msort/2]).
:- use_module(m__eu_ai_act_transparency_art50_transparency_art50, [decide_transparency_art50/2, transparency_art50_status/2, transparency_art50_checklist/2, transparency_art50_decision_resolvable/1, transparency_art50_status_values/1, transparency_duty_status/5, transparency_compliance/5]).
:- use_module(m__eu_ai_act_transparency_art50_queries, [provenance/2]).
:- use_module(m__eu_ai_act_transparency_art50_fixtures, [transparency_art50_subject/1, transparency_art50_profile_for/2, transparency_art50_assess/2]).

expected_verdict(interaction_before_application_day, not_applicable_on_date, [cite(eu_reg_2024_1689_art_113)]).
expected_verdict(interaction_first_day_of_application, duty_applies, [cite(eu_reg_2024_1689_art_50_1)]).
expected_verdict(conversational_assistant_duty_applies, duty_applies, [cite(eu_reg_2024_1689_art_50_1)]).
expected_verdict(conversational_assistant_obvious, duty_does_not_apply, [cite(eu_reg_2024_1689_art_50_1)]).
expected_verdict(police_system_exception, duty_does_not_apply, [cite(eu_reg_2024_1689_art_50_1)]).
expected_verdict(police_reporting_portal, duty_applies, [cite(eu_reg_2024_1689_art_50_1)]).
expected_verdict(rule_based_assistant_outside_definition, not_an_ai_system, [cite(eu_reg_2024_1689_art_3_1)]).
expected_verdict(assistant_system_status_unknown, indeterminate([ai_system]), []).
expected_verdict(assistant_informed_on_time, compliant, [cite(eu_reg_2024_1689_art_50_1), cite(eu_reg_2024_1689_art_50_5)]).
expected_verdict(assistant_information_not_given, not_compliant, [cite(eu_reg_2024_1689_art_50_1), cite(eu_reg_2024_1689_art_50_5)]).
expected_verdict(marking_legacy_last_transitional_day, in_transitional_period, [cite(eu_reg_2024_1689_art_50_2), cite(eu_reg_2024_1689_art_111_4)]).
expected_verdict(marking_legacy_first_binding_day, duty_applies, [cite(eu_reg_2024_1689_art_50_2)]).
expected_verdict(marking_new_system_last_transitional_day, duty_applies, [cite(eu_reg_2024_1689_art_50_2)]).
expected_verdict(marking_assistive_editing, duty_does_not_apply, [cite(eu_reg_2024_1689_art_50_2)]).
expected_verdict(marking_placement_unknown_in_window, indeterminate([placed_on_the_market_before_2_august_2026]), []).
expected_verdict(marking_outputs_marked, compliant, [cite(eu_reg_2024_1689_art_50_2)]).
expected_verdict(marking_outputs_unmarked, not_compliant, [cite(eu_reg_2024_1689_art_50_2)]).
expected_verdict(marking_compliance_in_transition, in_transitional_period, [cite(eu_reg_2024_1689_art_50_2), cite(eu_reg_2024_1689_art_111_4)]).
expected_verdict(emotion_recognition_duty_applies, duty_applies, [cite(eu_reg_2024_1689_art_50_3)]).
expected_verdict(emotion_recognition_personal_use, duty_does_not_apply, [cite(eu_reg_2024_1689_art_50_3), cite(eu_reg_2024_1689_art_3_4)]).
expected_verdict(emotion_recognition_informed_on_time, compliant, [cite(eu_reg_2024_1689_art_50_3), cite(eu_reg_2024_1689_art_50_5)]).
expected_verdict(emotion_recognition_informed_late, not_compliant, [cite(eu_reg_2024_1689_art_50_3), cite(eu_reg_2024_1689_art_50_5)]).
expected_verdict(deep_fake_duty_applies, duty_applies, [cite(eu_reg_2024_1689_art_50_4)]).
expected_verdict(deep_fake_artistic_work, limited_disclosure_applies, [cite(eu_reg_2024_1689_art_50_4)]).
expected_verdict(deep_fake_artistic_disclosure_appropriate, compliant, [cite(eu_reg_2024_1689_art_50_4), cite(eu_reg_2024_1689_art_50_5)]).
expected_verdict(deep_fake_artistic_disclosure_hampering, not_compliant, [cite(eu_reg_2024_1689_art_50_4), cite(eu_reg_2024_1689_art_50_5)]).
expected_verdict(deep_fake_artistic_judgement_unsure, needs_legal_review(open_textured(part_of_an_evidently_artistic_creative_satirical_fictional_or_analogous_work, cite(eu_reg_2024_1689_art_50_4)), [inputs_relied_on([generates_or_manipulates_deep_fake_image_audio_or_video_content - true, ai_system - true, part_of_an_evidently_artistic_creative_satirical_fictional_or_analogous_work - unsure])]), []).
expected_verdict(public_interest_text_duty_applies, duty_applies, [cite(eu_reg_2024_1689_art_50_4)]).
expected_verdict(public_interest_text_edited_with_responsibility, duty_does_not_apply, [cite(eu_reg_2024_1689_art_50_4), cite(eu_reg_2024_1689_art_3_4)]).
expected_verdict(public_interest_text_reviewed_without_responsibility, duty_applies, [cite(eu_reg_2024_1689_art_50_4)]).
expected_verdict(public_interest_text_disclosed_clearly, compliant, [cite(eu_reg_2024_1689_art_50_4), cite(eu_reg_2024_1689_art_50_5)]).
expected_verdict(public_interest_text_disclosed_unclearly, not_compliant, [cite(eu_reg_2024_1689_art_50_4), cite(eu_reg_2024_1689_art_50_5)]).
expected_verdict(unsure_judgement_not_deciding, duty_does_not_apply, [cite(eu_reg_2024_1689_art_50_1)]).
expected_verdict(unsure_judgement_missing_fact, indeterminate([authorised_by_law_to_detect_prevent_investigate_or_prosecute_criminal_offences]), []).
expected_verdict(unsure_judgement_outside_query, duty_applies, [cite(eu_reg_2024_1689_art_50_1)]).
expected_verdict(empty_profile_first_key, indeterminate([intended_to_interact_directly_with_natural_persons]), []).
expected_verdict(input_unknown_key, input_problems([unknown_key(colour)]), []).
expected_verdict(input_duplicate_key, input_problems([duplicate_key(ai_system)]), []).
expected_verdict(input_crisp_key_unsure, input_problems([wrong_type(required_information_given)]), []).
expected_verdict(input_unknown_duty, input_problems([wrong_type(duty)]), []).
expected_verdict(input_impossible_date, input_problems([wrong_type(assessment_date)]), []).
expected_verdict(input_several_problems, input_problems([wrong_type(ai_system), unknown_key(colour), wrong_type(duty)]), []).

same_citations(Actual, Expected) :-
    msort(Actual, Sorted),
    msort(Expected, Sorted).

resolves_as_expected(Subject) :-
    expected_verdict(Subject, ExpectedResult, ExpectedCitations),
    findall(Result - Citations, transparency_art50_assess(Subject, transparency_art50_verdict(Result, Citations)), Answers),
    Answers = [ActualResult - ActualCitations],
    ActualResult == ExpectedResult,
    same_citations(ActualCitations, ExpectedCitations).

subject_resolvable(Subject) :-
    transparency_art50_profile_for(Subject, Profile),
    question_of(Subject, Profile, Question),
    transparency_art50_decision_resolvable(Question).

question_of(Subject, Profile, transparency_question(compliance, Profile, deep_fake_disclosure, date(2027, 1, 1))) :-
    dif(Subject, none).

item_has_citation(item(_, _, cite(_))).

item_is_met(item(_, met, _)).

in_vocabulary(StatusValues, Atom) :-
    member(Atom, StatusValues).

registered_subjects(Subjects) :-
    findall(Subject, transparency_art50_subject(Subject), Subjects).

artistic_question(Subject, transparency_question(compliance, Profile, deep_fake_disclosure, date(2027, 1, 1))) :-
    transparency_art50_profile_for(Subject, Profile).

test(every_subject_has_one_expected_verdict) :-
    registered_subjects(Subjects),
    findall(Subject, expected_verdict(Subject, _, _), Expected),
    msort(Subjects, Sorted),
    msort(Expected, Sorted).
test(every_subject_resolves_to_its_expected_verdict) :-
    registered_subjects(Subjects),
    maplist(resolves_as_expected, Subjects).
test(every_subject_profile_is_resolvable) :-
    registered_subjects(Subjects),
    maplist(subject_resolvable, Subjects).
test(every_final_atom_is_in_the_status_vocabulary) :-
    transparency_art50_status_values(StatusValues),
    findall(Result, (expected_verdict(_, Result, _), atom(Result)), Atoms),
    sort(Atoms, Distinct),
    maplist(in_vocabulary(StatusValues), Distinct).
test(the_duty_status_query_answers_once_with_the_limited_duty) :-
    transparency_art50_profile_for(deep_fake_artistic_work, Profile),
    findall(Result - Citations, transparency_duty_status(Profile, deep_fake_disclosure, date(2027, 1, 1), Result, Citations), Answers),
    Answers == [limited_disclosure_applies - [cite(eu_reg_2024_1689_art_50_4)]].
test(the_duty_status_query_before_application_is_not_applicable_on_date) :-
    transparency_duty_status([], deep_fake_disclosure, date(2026, 8, 1), not_applicable_on_date, [cite(eu_reg_2024_1689_art_113)]).
test(the_duty_status_query_gives_duty_does_not_apply) :-
    transparency_art50_profile_for(emotion_recognition_personal_use, Profile),
    transparency_duty_status(Profile, emotion_recognition_or_biometric_categorisation_information, date(2027, 1, 1), duty_does_not_apply, Citations),
    same_citations(Citations, [cite(eu_reg_2024_1689_art_50_3), cite(eu_reg_2024_1689_art_3_4)]).
test(the_duty_status_query_gives_not_an_ai_system) :-
    transparency_art50_profile_for(rule_based_assistant_outside_definition, Profile),
    transparency_duty_status(Profile, interaction_information, date(2027, 1, 1), not_an_ai_system, [cite(eu_reg_2024_1689_art_3_1)]).
test(the_duty_status_query_gives_in_transitional_period) :-
    transparency_art50_profile_for(marking_legacy_last_transitional_day, Profile),
    transparency_duty_status(Profile, machine_readable_marking, date(2026, 12, 1), in_transitional_period, Citations),
    same_citations(Citations, [cite(eu_reg_2024_1689_art_50_2), cite(eu_reg_2024_1689_art_111_4)]).
test(the_duty_status_query_gives_duty_applies) :-
    transparency_art50_profile_for(deep_fake_duty_applies, Profile),
    transparency_duty_status(Profile, deep_fake_disclosure, date(2027, 1, 1), duty_applies, [cite(eu_reg_2024_1689_art_50_4)]).
test(the_duty_status_query_names_the_first_missing_key) :-
    transparency_duty_status([], public_interest_text_disclosure, date(2027, 1, 1), indeterminate([generates_or_manipulates_text_published_to_inform_the_public_on_matters_of_public_interest]), []).
test(the_duty_status_query_reports_input_problems) :-
    transparency_duty_status([attribute(colour, red)], interaction_information, date(2027, 1, 1), input_problems([unknown_key(colour)]), []).
test(the_compliance_query_answers_once_compliant) :-
    transparency_art50_profile_for(deep_fake_artistic_disclosure_appropriate, Profile),
    findall(Result - Citations, transparency_compliance(Profile, deep_fake_disclosure, date(2027, 1, 1), Result, Citations), Answers),
    Answers = [compliant - Citations],
    same_citations(Citations, [cite(eu_reg_2024_1689_art_50_4), cite(eu_reg_2024_1689_art_50_5)]).
test(the_compliance_query_gives_not_compliant) :-
    transparency_art50_profile_for(marking_outputs_unmarked, Profile),
    transparency_compliance(Profile, machine_readable_marking, date(2026, 12, 2), not_compliant, [cite(eu_reg_2024_1689_art_50_2)]).
test(the_compliance_query_passes_the_transition_through_directly) :-
    transparency_art50_profile_for(marking_compliance_in_transition, Profile),
    transparency_compliance(Profile, machine_readable_marking, date(2026, 12, 1), in_transitional_period, Citations),
    same_citations(Citations, [cite(eu_reg_2024_1689_art_50_2), cite(eu_reg_2024_1689_art_111_4)]).
test(the_compliance_query_reports_an_impossible_date) :-
    transparency_compliance([], deep_fake_disclosure, date(2026, 2, 30), input_problems([wrong_type(assessment_date)]), []).
test(the_provenance_constructor_is_named) :-
    provenance(deciding_clause, [cite(eu_reg_2024_1689_art_50_4)]).
test(the_first_day_of_application_has_the_duty) :-
    transparency_art50_assess(interaction_first_day_of_application, transparency_art50_verdict(duty_applies, [cite(eu_reg_2024_1689_art_50_1)])).
test(the_day_before_application_is_not_applicable_on_date) :-
    transparency_art50_assess(interaction_before_application_day, transparency_art50_verdict(not_applicable_on_date, [cite(eu_reg_2024_1689_art_113)])).
test(a_conversational_assistant_has_the_duty) :-
    transparency_art50_assess(conversational_assistant_duty_applies, transparency_art50_verdict(duty_applies, _)).
test(an_obvious_assistant_has_no_duty) :-
    transparency_art50_assess(conversational_assistant_obvious, transparency_art50_verdict(duty_does_not_apply, _)).
test(an_authorised_police_system_is_excepted) :-
    transparency_art50_assess(police_system_exception, transparency_art50_verdict(duty_does_not_apply, _)).
test(a_public_reporting_portal_keeps_the_duty) :-
    transparency_art50_assess(police_reporting_portal, transparency_art50_verdict(duty_applies, _)).
test(a_system_outside_the_definition_is_not_an_ai_system) :-
    transparency_art50_assess(rule_based_assistant_outside_definition, transparency_art50_verdict(not_an_ai_system, [cite(eu_reg_2024_1689_art_3_1)])).
test(an_absent_system_judgement_is_asked_for) :-
    transparency_art50_assess(assistant_system_status_unknown, transparency_art50_verdict(indeterminate([ai_system]), [])).
test(a_legacy_system_on_the_last_transitional_day_is_in_transition) :-
    transparency_art50_assess(marking_legacy_last_transitional_day, transparency_art50_verdict(in_transitional_period, Citations)),
    same_citations(Citations, [cite(eu_reg_2024_1689_art_50_2), cite(eu_reg_2024_1689_art_111_4)]).
test(a_legacy_system_on_the_first_binding_day_has_the_duty) :-
    transparency_art50_assess(marking_legacy_first_binding_day, transparency_art50_verdict(duty_applies, [cite(eu_reg_2024_1689_art_50_2)])).
test(a_system_placed_later_has_the_duty_inside_the_window) :-
    transparency_art50_assess(marking_new_system_last_transitional_day, transparency_art50_verdict(duty_applies, _)).
test(assistive_editing_takes_the_marking_duty_out) :-
    transparency_art50_assess(marking_assistive_editing, transparency_art50_verdict(duty_does_not_apply, _)).
test(marked_outputs_are_compliant) :-
    transparency_art50_assess(marking_outputs_marked, transparency_art50_verdict(compliant, [cite(eu_reg_2024_1689_art_50_2)])).
test(unmarked_outputs_are_not_compliant) :-
    transparency_art50_assess(marking_outputs_unmarked, transparency_art50_verdict(not_compliant, [cite(eu_reg_2024_1689_art_50_2)])).
test(the_compliance_query_passes_the_transition_through) :-
    transparency_art50_assess(marking_compliance_in_transition, transparency_art50_verdict(in_transitional_period, _)).
test(an_emotion_recognition_deployer_has_the_duty) :-
    transparency_art50_assess(emotion_recognition_duty_applies, transparency_art50_verdict(duty_applies, [cite(eu_reg_2024_1689_art_50_3)])).
test(personal_use_takes_the_deployer_duty_out) :-
    transparency_art50_assess(emotion_recognition_personal_use, transparency_art50_verdict(duty_does_not_apply, Citations)),
    same_citations(Citations, [cite(eu_reg_2024_1689_art_50_3), cite(eu_reg_2024_1689_art_3_4)]).
test(information_on_time_is_compliant) :-
    transparency_art50_assess(emotion_recognition_informed_on_time, transparency_art50_verdict(compliant, _)).
test(late_information_is_not_compliant) :-
    transparency_art50_assess(emotion_recognition_informed_late, transparency_art50_verdict(not_compliant, _)).
test(a_deep_fake_has_the_full_duty) :-
    transparency_art50_assess(deep_fake_duty_applies, transparency_art50_verdict(duty_applies, [cite(eu_reg_2024_1689_art_50_4)])).
test(an_artistic_deep_fake_has_the_limited_duty) :-
    transparency_art50_assess(deep_fake_artistic_work, transparency_art50_verdict(limited_disclosure_applies, [cite(eu_reg_2024_1689_art_50_4)])).
test(an_appropriate_disclosure_is_compliant) :-
    transparency_art50_assess(deep_fake_artistic_disclosure_appropriate, transparency_art50_verdict(compliant, _)).
test(a_hampering_disclosure_is_not_compliant) :-
    transparency_art50_assess(deep_fake_artistic_disclosure_hampering, transparency_art50_verdict(not_compliant, _)).
test(an_unsure_artistic_judgement_goes_to_a_lawyer) :-
    transparency_art50_assess(deep_fake_artistic_judgement_unsure, transparency_art50_verdict(needs_legal_review(open_textured(JudgementKey, cite(CitationKey)), _), [])),
    JudgementKey == part_of_an_evidently_artistic_creative_satirical_fictional_or_analogous_work,
    CitationKey == eu_reg_2024_1689_art_50_4.
test(public_interest_text_has_the_duty) :-
    transparency_art50_assess(public_interest_text_duty_applies, transparency_art50_verdict(duty_applies, [cite(eu_reg_2024_1689_art_50_4)])).
test(edited_text_with_responsibility_is_excepted) :-
    transparency_art50_assess(public_interest_text_edited_with_responsibility, transparency_art50_verdict(duty_does_not_apply, _)).
test(reviewed_text_without_responsibility_keeps_the_duty) :-
    transparency_art50_assess(public_interest_text_reviewed_without_responsibility, transparency_art50_verdict(duty_applies, _)).
test(a_clear_disclosure_is_compliant) :-
    transparency_art50_assess(public_interest_text_disclosed_clearly, transparency_art50_verdict(compliant, _)).
test(an_unclear_disclosure_is_not_compliant) :-
    transparency_art50_assess(public_interest_text_disclosed_unclearly, transparency_art50_verdict(not_compliant, _)).
test(an_unsure_judgement_that_does_not_matter_gives_the_answer) :-
    transparency_art50_assess(unsure_judgement_not_deciding, transparency_art50_verdict(duty_does_not_apply, [cite(eu_reg_2024_1689_art_50_1)])).
test(a_missing_fact_is_named_before_a_referral) :-
    transparency_art50_assess(unsure_judgement_missing_fact, transparency_art50_verdict(indeterminate([authorised_by_law_to_detect_prevent_investigate_or_prosecute_criminal_offences]), [])).
test(an_unsure_judgement_outside_the_query_is_never_read) :-
    transparency_art50_assess(unsure_judgement_outside_query, transparency_art50_verdict(duty_applies, _)).
test(an_unknown_key_is_an_input_problem) :-
    transparency_art50_assess(input_unknown_key, transparency_art50_verdict(input_problems([unknown_key(colour)]), [])).
test(the_problems_come_in_contract_order_then_the_duty) :-
    transparency_art50_assess(input_several_problems, transparency_art50_verdict(input_problems([wrong_type(ai_system), unknown_key(colour), wrong_type(duty)]), [])).
test(the_status_projection_gives_the_result) :-
    transparency_art50_profile_for(deep_fake_artistic_work, Profile),
    transparency_art50_status(transparency_question(duty_status, Profile, deep_fake_disclosure, date(2027, 1, 1)), limited_disclosure_applies).
test(the_decision_gives_the_verdict_term) :-
    transparency_art50_profile_for(deep_fake_artistic_disclosure_appropriate, Profile),
    decide_transparency_art50(transparency_question(compliance, Profile, deep_fake_disclosure, date(2027, 1, 1)), transparency_art50_verdict(compliant, Citations)),
    same_citations(Citations, [cite(eu_reg_2024_1689_art_50_4), cite(eu_reg_2024_1689_art_50_5)]).
test(the_checklist_carries_a_citation_on_every_item) :-
    artistic_question(deep_fake_artistic_disclosure_appropriate, Question),
    transparency_art50_checklist(Question, Items),
    Items = [_|_],
    length(Items, 10),
    maplist(item_has_citation, Items).
test(a_compliant_checklist_has_every_item_met) :-
    artistic_question(deep_fake_artistic_disclosure_appropriate, Question),
    transparency_art50_checklist(Question, Items),
    maplist(item_is_met, Items).
test(a_hampering_checklist_names_the_failing_item) :-
    artistic_question(deep_fake_artistic_disclosure_hampering, Question),
    transparency_art50_checklist(Question, Items),
    member(item(not_both(part_of_an_evidently_artistic_creative_satirical_fictional_or_analogous_work, disclosure_of_existence_appropriate_and_does_not_hamper_the_work), unmet(fails), cite(eu_reg_2024_1689_art_50_5)), Items).
test(the_status_checklist_has_the_duty_items_only) :-
    transparency_art50_profile_for(conversational_assistant_duty_applies, Profile),
    transparency_art50_checklist(transparency_question(duty_status, Profile, interaction_information, date(2027, 1, 1)), Items),
    length(Items, 5),
    maplist(item_has_citation, Items).

test(the_duty_status_query_is_not_the_full_duty_for_an_artistic_work, fail) :-
    transparency_art50_profile_for(deep_fake_artistic_work, Profile),
    transparency_duty_status(Profile, deep_fake_disclosure, date(2027, 1, 1), duty_applies, _).
test(the_compliance_query_is_not_compliant_for_unmarked_outputs, fail) :-
    transparency_art50_profile_for(marking_outputs_unmarked, Profile),
    transparency_compliance(Profile, machine_readable_marking, date(2026, 12, 2), compliant, _).
test(the_day_before_application_has_no_duty, fail) :-
    transparency_art50_assess(interaction_before_application_day, transparency_art50_verdict(duty_applies, _)).
test(an_obvious_assistant_is_not_under_the_duty, fail) :-
    transparency_art50_assess(conversational_assistant_obvious, transparency_art50_verdict(duty_applies, _)).
test(a_public_reporting_portal_is_not_excepted, fail) :-
    transparency_art50_assess(police_reporting_portal, transparency_art50_verdict(duty_does_not_apply, _)).
test(an_absent_system_judgement_is_not_final, fail) :-
    transparency_art50_assess(assistant_system_status_unknown, transparency_art50_verdict(not_an_ai_system, _)).
test(a_legacy_system_on_the_first_binding_day_is_not_in_transition, fail) :-
    transparency_art50_assess(marking_legacy_first_binding_day, transparency_art50_verdict(in_transitional_period, _)).
test(unmarked_outputs_are_never_compliant, fail) :-
    transparency_art50_assess(marking_outputs_unmarked, transparency_art50_verdict(compliant, _)).
test(late_information_is_never_compliant, fail) :-
    transparency_art50_assess(emotion_recognition_informed_late, transparency_art50_verdict(compliant, _)).
test(an_artistic_deep_fake_is_not_under_the_full_duty, fail) :-
    transparency_art50_assess(deep_fake_artistic_work, transparency_art50_verdict(duty_applies, _)).
test(reviewed_text_without_responsibility_is_not_excepted, fail) :-
    transparency_art50_assess(public_interest_text_reviewed_without_responsibility, transparency_art50_verdict(duty_does_not_apply, _)).
test(a_missing_fact_case_is_not_referred, fail) :-
    transparency_art50_assess(unsure_judgement_missing_fact, transparency_art50_verdict(needs_legal_review(_, _), _)).
test(an_input_problem_is_never_a_final_answer, fail) :-
    transparency_art50_assess(input_duplicate_key, transparency_art50_verdict(duty_applies, _)).
test(a_hampering_checklist_is_not_all_met, fail) :-
    artistic_question(deep_fake_artistic_disclosure_hampering, Question),
    transparency_art50_checklist(Question, Items),
    maplist(item_is_met, Items).

cp_test_names([every_subject_has_one_expected_verdict, every_subject_resolves_to_its_expected_verdict, every_subject_profile_is_resolvable, every_final_atom_is_in_the_status_vocabulary, the_duty_status_query_answers_once_with_the_limited_duty, the_duty_status_query_before_application_is_not_applicable_on_date, the_duty_status_query_gives_duty_does_not_apply, the_duty_status_query_gives_not_an_ai_system, the_duty_status_query_gives_in_transitional_period, the_duty_status_query_gives_duty_applies, the_duty_status_query_names_the_first_missing_key, the_duty_status_query_reports_input_problems, the_compliance_query_answers_once_compliant, the_compliance_query_gives_not_compliant, the_compliance_query_passes_the_transition_through_directly, the_compliance_query_reports_an_impossible_date, the_provenance_constructor_is_named, the_first_day_of_application_has_the_duty, the_day_before_application_is_not_applicable_on_date, a_conversational_assistant_has_the_duty, an_obvious_assistant_has_no_duty, an_authorised_police_system_is_excepted, a_public_reporting_portal_keeps_the_duty, a_system_outside_the_definition_is_not_an_ai_system, an_absent_system_judgement_is_asked_for, a_legacy_system_on_the_last_transitional_day_is_in_transition, a_legacy_system_on_the_first_binding_day_has_the_duty, a_system_placed_later_has_the_duty_inside_the_window, assistive_editing_takes_the_marking_duty_out, marked_outputs_are_compliant, unmarked_outputs_are_not_compliant, the_compliance_query_passes_the_transition_through, an_emotion_recognition_deployer_has_the_duty, personal_use_takes_the_deployer_duty_out, information_on_time_is_compliant, late_information_is_not_compliant, a_deep_fake_has_the_full_duty, an_artistic_deep_fake_has_the_limited_duty, an_appropriate_disclosure_is_compliant, a_hampering_disclosure_is_not_compliant, an_unsure_artistic_judgement_goes_to_a_lawyer, public_interest_text_has_the_duty, edited_text_with_responsibility_is_excepted, reviewed_text_without_responsibility_keeps_the_duty, a_clear_disclosure_is_compliant, an_unclear_disclosure_is_not_compliant, an_unsure_judgement_that_does_not_matter_gives_the_answer, a_missing_fact_is_named_before_a_referral, an_unsure_judgement_outside_the_query_is_never_read, an_unknown_key_is_an_input_problem, the_problems_come_in_contract_order_then_the_duty, the_status_projection_gives_the_result, the_decision_gives_the_verdict_term, the_checklist_carries_a_citation_on_every_item, a_compliant_checklist_has_every_item_met, a_hampering_checklist_names_the_failing_item, the_status_checklist_has_the_duty_items_only]).
cp_test_fail_names([the_duty_status_query_is_not_the_full_duty_for_an_artistic_work, the_compliance_query_is_not_compliant_for_unmarked_outputs, the_day_before_application_has_no_duty, an_obvious_assistant_is_not_under_the_duty, a_public_reporting_portal_is_not_excepted, an_absent_system_judgement_is_not_final, a_legacy_system_on_the_first_binding_day_is_not_in_transition, unmarked_outputs_are_never_compliant, late_information_is_never_compliant, an_artistic_deep_fake_is_not_under_the_full_duty, reviewed_text_without_responsibility_is_not_excepted, a_missing_fact_case_is_not_referred, an_input_problem_is_never_a_final_answer, a_hampering_checklist_is_not_all_met]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
