% SPDX-License-Identifier: EUPL-1.2
:- module(m__cn_pipl_individual_rights_tests_test_output_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__cn_pipl_individual_rights_pipl_individual_rights, [restriction_or_refusal_right/3, access_and_copy_duty/3, portability_duty/3, correction_duty/3, deletion_duty/3, explanation_duty/3, deceased_person_rights/3, request_mechanism/3, refusal_status/3, decide_pipl_individual_rights/2, pipl_individual_rights_status/2, pipl_individual_rights_checklist/2]).
:- use_module(m__cn_pipl_individual_rights_fixtures, [pipl_individual_rights_profile_for/2]).

subject_answers(Subject, Query, Answers) :-
    pipl_individual_rights_profile_for(Subject, Profile),
    findall(Result - Citations, call(Query, Profile, Result, Citations), Answers).

met_item(item(_, met, cite(_))).

test(baseline_restriction_read_out) :-
    subject_answers(baseline_all_rights_engaged, restriction_or_refusal_right, Answers),
    Answers == [right_available - [cite(cn_pipl_art_44_p1)]].
test(baseline_access_read_out) :-
    subject_answers(baseline_all_rights_engaged, access_and_copy_duty, Answers),
    Answers == [provide_in_time - [cite(cn_pipl_art_45_p1), cite(cn_pipl_art_45_p2)]].
test(baseline_portability_read_out) :-
    subject_answers(baseline_all_rights_engaged, portability_duty, Answers),
    Answers == [provide_transfer_route - [cite(cn_pipl_art_45_p3)]].
test(baseline_correction_read_out) :-
    subject_answers(baseline_all_rights_engaged, correction_duty, Answers),
    Answers == [correct_or_supplement_in_time - [cite(cn_pipl_art_46_p1), cite(cn_pipl_art_46_p2)]].
test(baseline_deletion_read_out) :-
    subject_answers(baseline_all_rights_engaged, deletion_duty, Answers),
    Answers == [delete_personal_information - [cite(cn_pipl_art_47_p1), cite(cn_pipl_art_47_p1_i1), cite(cn_pipl_art_47_p1_i2), cite(cn_pipl_art_47_p1_i3), cite(cn_pipl_art_47_p1_i4), cite(cn_pipl_art_47_p1_i5), cite(cn_pipl_art_47_p2)]].
test(baseline_explanation_read_out) :-
    subject_answers(baseline_all_rights_engaged, explanation_duty, Answers),
    Answers == [explain_processing_rules - [cite(cn_pipl_art_48_p1)]].
test(baseline_deceased_read_out) :-
    subject_answers(baseline_all_rights_engaged, deceased_person_rights, Answers),
    Answers == [near_relative_may_exercise - [cite(cn_pipl_art_49_p1)]].
test(baseline_mechanism_read_out) :-
    subject_answers(baseline_all_rights_engaged, request_mechanism, Answers),
    Answers == [requirement_met - [cite(cn_pipl_art_50_p1)]].
test(baseline_refusal_read_out) :-
    subject_answers(baseline_all_rights_engaged, refusal_status, Answers),
    Answers == [refused_with_reasons - [cite(cn_pipl_art_50_p1), cite(cn_pipl_art_50_p2)]].
test(deletion_no_case_read_out_without_47_2) :-
    subject_answers(deletion_no_case_holds, deletion_duty, Answers),
    Answers == [not_owed - [cite(cn_pipl_art_47_p1), cite(cn_pipl_art_47_p1_i1), cite(cn_pipl_art_47_p1_i2), cite(cn_pipl_art_47_p1_i3), cite(cn_pipl_art_47_p1_i4), cite(cn_pipl_art_47_p1_i5)]].
test(deletion_difficulty_unsure_read_out) :-
    subject_answers(deletion_difficulty_unsure, deletion_duty, Answers),
    Answers == [needs_legal_review(open_textured(deletion_technically_difficult, cite(cn_pipl_art_47_p2)), [inputs_relied_on([purpose_achieved_impossible_or_unnecessary - false, processing_violates_law_or_agreement - false, deletion_technically_difficult - unsure])]) - []].
test(deletion_violation_unsure_read_out) :-
    subject_answers(deletion_violation_unsure, deletion_duty, Answers),
    Answers == [needs_legal_review(open_textured(processing_violates_law_or_agreement, cite(cn_pipl_art_47_p1_i4)), [inputs_relied_on([purpose_achieved_impossible_or_unnecessary - false, processing_violates_law_or_agreement - unsure, deletion_technically_difficult - false])]) - []].
test(deletion_retention_unstated_read_out) :-
    subject_answers(deletion_retention_unstated, deletion_duty, Answers),
    Answers == [indeterminate([legal_retention_period_unexpired]) - []].
test(deletion_purpose_unstated_read_out) :-
    subject_answers(deletion_purpose_unstated, deletion_duty, Answers),
    Answers == [indeterminate([purpose_achieved_impossible_or_unnecessary]) - []].
test(deceased_interests_unsure_read_out) :-
    subject_answers(deceased_interests_unsure, deceased_person_rights, Answers),
    Answers == [needs_legal_review(open_textured(for_requester_own_lawful_and_legitimate_interests, cite(cn_pipl_art_49_p1)), [inputs_relied_on([for_requester_own_lawful_and_legitimate_interests - unsure])]) - []].
test(text_not_in_force_read_out) :-
    subject_answers(text_not_in_force, refusal_status, Answers),
    Answers == [pinned_text_not_applicable - []].
test(text_in_force_unstated_read_out) :-
    subject_answers(text_in_force_unstated, access_and_copy_duty, Answers),
    Answers == [indeterminate([pinned_text_in_force_on_reference_day]) - []].
test(input_problems_read_out) :-
    subject_answers(input_wrong_type_and_unknown_key, portability_duty, Answers),
    Answers == [input_problems([wrong_type(article_35_case), unknown_key(colour)]) - []].
test(the_baseline_profile_yields_exactly_one_status) :-
    pipl_individual_rights_profile_for(baseline_all_rights_engaged, Profile),
    findall(Status, pipl_individual_rights_status(Profile, Status), Statuses),
    Statuses == [eligible].
test(the_verdict_carries_a_cited_checklist) :-
    pipl_individual_rights_profile_for(baseline_all_rights_engaged, Profile),
    findall(Verdict, decide_pipl_individual_rights(Profile, Verdict), [pipl_individual_rights_verdict(eligible, Items)]),
    length(Items, 9),
    maplist(met_item, Items).
test(the_checklist_rows_are_in_order) :-
    pipl_individual_rights_profile_for(baseline_all_rights_engaged, Profile),
    pipl_individual_rights_checklist(Profile, Items),
    findall(RowIdentifier, member(item(RowIdentifier, _, _), Items), RowIdentifiers),
    RowIdentifiers == [article_44_restriction_or_refusal, article_45_access_and_copy, article_45_portability, article_46_correction, article_47_deletion, article_48_explanation, article_49_deceased_person, article_50_request_mechanism, article_50_refusal].
test(a_refusal_without_reasons_row_is_unmet) :-
    pipl_individual_rights_profile_for(refusal_without_reasons, Profile),
    pipl_individual_rights_checklist(Profile, Items),
    member(item(article_50_refusal, unmet(refused_without_reasons), cite(cn_pipl_art_50_p1)), Items).
test(an_empty_profile_rows_are_unknown) :-
    pipl_individual_rights_checklist([], Items),
    member(item(article_44_restriction_or_refusal, unknown([pinned_text_in_force_on_reference_day]), cite(cn_pipl_art_44_p1)), Items).

cp_test_names([baseline_restriction_read_out, baseline_access_read_out, baseline_portability_read_out, baseline_correction_read_out, baseline_deletion_read_out, baseline_explanation_read_out, baseline_deceased_read_out, baseline_mechanism_read_out, baseline_refusal_read_out, deletion_no_case_read_out_without_47_2, deletion_difficulty_unsure_read_out, deletion_violation_unsure_read_out, deletion_retention_unstated_read_out, deletion_purpose_unstated_read_out, deceased_interests_unsure_read_out, text_not_in_force_read_out, text_in_force_unstated_read_out, input_problems_read_out, the_baseline_profile_yields_exactly_one_status, the_verdict_carries_a_cited_checklist, the_checklist_rows_are_in_order, a_refusal_without_reasons_row_is_unmet, an_empty_profile_rows_are_unknown]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
