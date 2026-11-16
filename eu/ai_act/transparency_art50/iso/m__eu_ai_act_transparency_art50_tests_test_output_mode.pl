% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_ai_act_transparency_art50_tests_test_output_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_ai_act_transparency_art50_transparency_art50, [decide_transparency_art50/2, transparency_duty_status/5, transparency_compliance/5, transparency_art50_checklist/2]).
:- use_module(m__eu_ai_act_transparency_art50_fixtures, [transparency_art50_profile_for/2]).

query_answer(duty_status, Profile, DutyName, AssessmentDate, Result, Citations) :-
    transparency_duty_status(Profile, DutyName, AssessmentDate, Result, Citations).
query_answer(compliance, Profile, DutyName, AssessmentDate, Result, Citations) :-
    transparency_compliance(Profile, DutyName, AssessmentDate, Result, Citations).

subject_answers(QueryKind, Subject, DutyName, AssessmentDate, Answers) :-
    transparency_art50_profile_for(Subject, Profile),
    findall(Result - Citations, query_answer(QueryKind, Profile, DutyName, AssessmentDate, Result, Citations), Answers).

profile_answers(QueryKind, Profile, DutyName, AssessmentDate, Answers) :-
    findall(Result - Citations, query_answer(QueryKind, Profile, DutyName, AssessmentDate, Result, Citations), Answers).

test(the_day_before_application_reads_no_key) :-
    subject_answers(duty_status, conversational_assistant_duty_applies, interaction_information, date(2026, 8, 1), Answers),
    Answers == [not_applicable_on_date - [cite(eu_reg_2024_1689_art_113)]].
test(the_first_day_of_application_has_the_duty) :-
    subject_answers(duty_status, conversational_assistant_duty_applies, interaction_information, date(2026, 8, 2), Answers),
    Answers == [duty_applies - [cite(eu_reg_2024_1689_art_50_1)]].
test(the_compliance_query_before_application_is_not_applicable_on_date) :-
    subject_answers(compliance, assistant_informed_on_time, interaction_information, date(2026, 8, 1), Answers),
    Answers == [not_applicable_on_date - [cite(eu_reg_2024_1689_art_113)]].
test(the_window_opens_on_the_day_of_application) :-
    subject_answers(duty_status, marking_legacy_last_transitional_day, machine_readable_marking, date(2026, 8, 2), Answers),
    Answers == [in_transitional_period - [cite(eu_reg_2024_1689_art_50_2), cite(eu_reg_2024_1689_art_111_4)]].
test(the_last_transitional_day_is_in_the_window) :-
    subject_answers(duty_status, marking_legacy_last_transitional_day, machine_readable_marking, date(2026, 12, 1), Answers),
    Answers == [in_transitional_period - [cite(eu_reg_2024_1689_art_50_2), cite(eu_reg_2024_1689_art_111_4)]].
test(the_marking_duty_binds_from_2_december_2026) :-
    subject_answers(duty_status, marking_legacy_last_transitional_day, machine_readable_marking, date(2026, 12, 2), Answers),
    Answers == [duty_applies - [cite(eu_reg_2024_1689_art_50_2)]].
test(the_compliance_query_passes_the_window_through) :-
    subject_answers(compliance, marking_outputs_marked, machine_readable_marking, date(2026, 12, 1), Answers),
    Answers == [in_transitional_period - [cite(eu_reg_2024_1689_art_50_2), cite(eu_reg_2024_1689_art_111_4)]].
test(the_compliance_query_after_the_window_reads_the_marking) :-
    subject_answers(compliance, marking_outputs_marked, machine_readable_marking, date(2026, 12, 2), Answers),
    Answers == [compliant - [cite(eu_reg_2024_1689_art_50_2)]].
test(placement_unknown_in_the_window_is_asked_for) :-
    subject_answers(compliance, marking_placement_unknown_in_window, machine_readable_marking, date(2026, 9, 1), Answers),
    Answers == [indeterminate([placed_on_the_market_before_2_august_2026]) - []].
test(placement_is_not_read_after_the_window) :-
    subject_answers(duty_status, marking_placement_unknown_in_window, machine_readable_marking, date(2027, 1, 1), Answers),
    Answers == [duty_applies - [cite(eu_reg_2024_1689_art_50_2)]].
test(each_duty_names_its_first_key_on_an_empty_profile) :-
    profile_answers(duty_status, [], interaction_information, date(2027, 1, 1), InteractionAnswers),
    InteractionAnswers == [indeterminate([intended_to_interact_directly_with_natural_persons]) - []],
    profile_answers(duty_status, [], machine_readable_marking, date(2027, 1, 1), MarkingAnswers),
    MarkingAnswers == [indeterminate([generates_synthetic_audio_image_video_or_text_content]) - []],
    profile_answers(duty_status, [], emotion_recognition_or_biometric_categorisation_information, date(2027, 1, 1), EmotionAnswers),
    EmotionAnswers == [indeterminate([emotion_recognition_or_biometric_categorisation_system]) - []],
    profile_answers(duty_status, [], deep_fake_disclosure, date(2027, 1, 1), DeepFakeAnswers),
    DeepFakeAnswers == [indeterminate([generates_or_manipulates_deep_fake_image_audio_or_video_content]) - []],
    profile_answers(compliance, [], public_interest_text_disclosure, date(2027, 1, 1), TextAnswers),
    TextAnswers == [indeterminate([generates_or_manipulates_text_published_to_inform_the_public_on_matters_of_public_interest]) - []].
test(the_compliance_test_names_its_first_key) :-
    subject_answers(compliance, conversational_assistant_duty_applies, interaction_information, date(2027, 1, 1), Answers),
    Answers == [indeterminate([required_information_given]) - []].
test(the_marking_compliance_test_names_the_marking_key) :-
    subject_answers(compliance, marking_legacy_first_binding_day, machine_readable_marking, date(2027, 1, 1), Answers),
    Answers == [indeterminate([outputs_marked_machine_readable_and_detectable_as_artificially_generated]) - []].
test(the_artistic_judgement_is_not_read_by_the_compliance_gate) :-
    subject_answers(compliance, deep_fake_artistic_work, deep_fake_disclosure, date(2027, 1, 1), Answers),
    Answers == [indeterminate([required_information_given]) - []].
test(an_unsure_ai_system_judgement_that_turns_the_answer_goes_to_a_lawyer) :-
    profile_answers(duty_status, [attribute(intended_to_interact_directly_with_natural_persons, true), attribute(interaction_obvious_to_a_reasonably_well_informed_observant_and_circumspect_person, false), attribute(authorised_by_law_to_detect_prevent_investigate_or_prosecute_criminal_offences, false), attribute(ai_system, unsure)], interaction_information, date(2027, 1, 1), Answers),
    Answers == [needs_legal_review(open_textured(ai_system, cite(eu_reg_2024_1689_art_3_1)), [inputs_relied_on([interaction_obvious_to_a_reasonably_well_informed_observant_and_circumspect_person - false, ai_system - unsure])]) - []].
test(an_unsure_judgement_before_the_date_does_not_matter) :-
    profile_answers(duty_status, [attribute(ai_system, unsure)], deep_fake_disclosure, date(2026, 8, 1), Answers),
    Answers == [not_applicable_on_date - [cite(eu_reg_2024_1689_art_113)]].
test(the_verdict_is_read_out_once) :-
    transparency_art50_profile_for(deep_fake_duty_applies, Profile),
    findall(Verdict, decide_transparency_art50(transparency_question(duty_status, Profile, deep_fake_disclosure, date(2027, 1, 1)), Verdict), Verdicts),
    Verdicts == [transparency_art50_verdict(duty_applies, [cite(eu_reg_2024_1689_art_50_4)])].
test(the_status_checklist_has_a_cited_row_per_item) :-
    transparency_art50_profile_for(conversational_assistant_duty_applies, Profile),
    transparency_art50_checklist(transparency_question(duty_status, Profile, interaction_information, date(2027, 1, 1)), ChecklistItems),
    length(ChecklistItems, 5),
    maplist(cited_item, ChecklistItems),
    maplist(met_item, ChecklistItems).
test(the_compliance_checklist_adds_the_compliance_rows) :-
    transparency_art50_profile_for(assistant_informed_on_time, Profile),
    transparency_art50_checklist(transparency_question(compliance, Profile, interaction_information, date(2027, 1, 1)), ChecklistItems),
    length(ChecklistItems, 9),
    maplist(cited_item, ChecklistItems),
    maplist(met_item, ChecklistItems).
test(the_checklist_of_a_bad_profile_is_one_input_row) :-
    transparency_art50_checklist(transparency_question(duty_status, [attribute(colour, red)], interaction_information, date(2027, 1, 1)), ChecklistItems),
    ChecklistItems == [item(input_check, unmet(input_problems([unknown_key(colour)])), [])].
test(the_checklist_marks_the_date_unmet_before_application) :-
    transparency_art50_checklist(transparency_question(duty_status, [], interaction_information, date(2026, 8, 1)), [FirstItem|_]),
    FirstItem == item(date_of_application, unmet(not_applicable_on_date), cite(eu_reg_2024_1689_art_113)).

cited_item(item(_, _, cite(_))).

met_item(item(_, met, _)).

cp_test_names([the_day_before_application_reads_no_key, the_first_day_of_application_has_the_duty, the_compliance_query_before_application_is_not_applicable_on_date, the_window_opens_on_the_day_of_application, the_last_transitional_day_is_in_the_window, the_marking_duty_binds_from_2_december_2026, the_compliance_query_passes_the_window_through, the_compliance_query_after_the_window_reads_the_marking, placement_unknown_in_the_window_is_asked_for, placement_is_not_read_after_the_window, each_duty_names_its_first_key_on_an_empty_profile, the_compliance_test_names_its_first_key, the_marking_compliance_test_names_the_marking_key, the_artistic_judgement_is_not_read_by_the_compliance_gate, an_unsure_ai_system_judgement_that_turns_the_answer_goes_to_a_lawyer, an_unsure_judgement_before_the_date_does_not_matter, the_verdict_is_read_out_once, the_status_checklist_has_a_cited_row_per_item, the_compliance_checklist_adds_the_compliance_rows, the_checklist_of_a_bad_profile_is_one_input_row, the_checklist_marks_the_date_unmet_before_application]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
