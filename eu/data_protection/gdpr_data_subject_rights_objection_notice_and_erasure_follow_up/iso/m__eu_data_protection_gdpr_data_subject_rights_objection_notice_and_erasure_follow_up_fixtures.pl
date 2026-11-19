% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_data_subject_rights_objection_notice_and_erasure_follow_up_fixtures, [gdpr_data_subject_rights_objection_notice_and_erasure_follow_up_subject/1, gdpr_data_subject_rights_objection_notice_and_erasure_follow_up_profile_for/2, gdpr_data_subject_rights_objection_notice_and_erasure_follow_up_assess/2, gdpr_data_subject_rights_objection_notice_and_erasure_follow_up_expected/3]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_data_subject_rights_objection_notice_and_erasure_follow_up_gdpr_data_subject_rights_objection_notice_and_erasure_follow_up, [decide_gdpr_data_subject_rights_objection_notice_and_erasure_follow_up/2]).

fixture_row(duties_fulfilled, complying, met).
fixture_row(clarity_failed_near_miss, clarity_failed, met).
fixture_row(separation_failed_near_miss, separation_failed, met).
fixture_row(explicit_failed_near_miss, explicit_failed, met).
fixture_row(no_right_to_object, no_right, met).
fixture_row(first_communication_pending, first_communication_pending, met).
fixture_row(explicit_not_stated, explicit_not_stated, met).
fixture_row(clarity_unsure, clarity_unsure, met).
fixture_row(right_not_attested, right_not_attested, met).
fixture_row(first_communication_not_stated, first_communication_not_stated, met).
fixture_row(steps_failed_near_miss, complying, steps_failed).
fixture_row(data_not_public, complying, not_public).
fixture_row(no_obligation_to_erase, complying, no_obligation).
fixture_row(steps_unsure, complying, steps_unsure).
fixture_row(obligation_not_attested, complying, obligation_not_attested).
fixture_row(publication_not_stated, complying, publication_not_stated).
fixture_row(steps_not_stated, complying, steps_not_stated).
fixture_row(empty_profile, nothing_stated, nothing_stated).

malformed_fixture(bare_outside_fact_value, [attribute(right_to_object_applies, true)]).
malformed_fixture(unknown_key_present, [attribute(marketing_channel, email)]).
malformed_fixture(duplicate_key_present, [attribute(first_communication_with_data_subject_has_taken_place, true), attribute(first_communication_with_data_subject_has_taken_place, false)]).

malformed_fixture_expected(bare_outside_fact_value, input_problems([wrong_type(right_to_object_applies)])).
malformed_fixture_expected(unknown_key_present, input_problems([unknown_key(marketing_channel)])).
malformed_fixture_expected(duplicate_key_present, input_problems([duplicate_key(first_communication_with_data_subject_has_taken_place)])).

gdpr_data_subject_rights_objection_notice_and_erasure_follow_up_subject(Subject) :-
    fixture_row(Subject, _, _).
gdpr_data_subject_rights_objection_notice_and_erasure_follow_up_subject(Subject) :-
    malformed_fixture(Subject, _).

gdpr_data_subject_rights_objection_notice_and_erasure_follow_up_profile_for(Subject, Profile) :-
    fixture_row(Subject, NoticeKind, FollowUpKind),
    notice_part(NoticeKind, NoticePart),
    follow_up_part(FollowUpKind, FollowUpPart),
    append(NoticePart, FollowUpPart, Profile).
gdpr_data_subject_rights_objection_notice_and_erasure_follow_up_profile_for(Subject, Profile) :-
    malformed_fixture(Subject, Profile).

notice_part(complying, [attribute(right_to_object_applies, attested(true, attestation(fixture_host, fixture_time, fixture_reason, none))), attribute(first_communication_with_data_subject_has_taken_place, true), attribute(right_explicitly_brought_to_attention_by_first_communication, true), attribute(right_presented_separately_from_other_information, true), attribute(right_presented_clearly, true)]).
notice_part(clarity_failed, [attribute(right_to_object_applies, attested(true, attestation(fixture_host, fixture_time, fixture_reason, none))), attribute(first_communication_with_data_subject_has_taken_place, true), attribute(right_explicitly_brought_to_attention_by_first_communication, true), attribute(right_presented_separately_from_other_information, true), attribute(right_presented_clearly, false)]).
notice_part(separation_failed, [attribute(right_to_object_applies, attested(true, attestation(fixture_host, fixture_time, fixture_reason, none))), attribute(first_communication_with_data_subject_has_taken_place, true), attribute(right_explicitly_brought_to_attention_by_first_communication, true), attribute(right_presented_separately_from_other_information, false), attribute(right_presented_clearly, true)]).
notice_part(explicit_failed, [attribute(right_to_object_applies, attested(true, attestation(fixture_host, fixture_time, fixture_reason, none))), attribute(first_communication_with_data_subject_has_taken_place, true), attribute(right_explicitly_brought_to_attention_by_first_communication, false), attribute(right_presented_separately_from_other_information, true), attribute(right_presented_clearly, true)]).
notice_part(no_right, [attribute(right_to_object_applies, attested(false, attestation(fixture_host, fixture_time, fixture_reason, none))), attribute(first_communication_with_data_subject_has_taken_place, true), attribute(right_explicitly_brought_to_attention_by_first_communication, true), attribute(right_presented_separately_from_other_information, true), attribute(right_presented_clearly, true)]).
notice_part(first_communication_pending, [attribute(right_to_object_applies, attested(true, attestation(fixture_host, fixture_time, fixture_reason, none))), attribute(first_communication_with_data_subject_has_taken_place, false), attribute(right_explicitly_brought_to_attention_by_first_communication, true), attribute(right_presented_separately_from_other_information, true), attribute(right_presented_clearly, true)]).
notice_part(explicit_not_stated, [attribute(right_to_object_applies, attested(true, attestation(fixture_host, fixture_time, fixture_reason, none))), attribute(first_communication_with_data_subject_has_taken_place, true), attribute(right_presented_separately_from_other_information, true), attribute(right_presented_clearly, true)]).
notice_part(clarity_unsure, [attribute(right_to_object_applies, attested(true, attestation(fixture_host, fixture_time, fixture_reason, none))), attribute(first_communication_with_data_subject_has_taken_place, true), attribute(right_explicitly_brought_to_attention_by_first_communication, true), attribute(right_presented_separately_from_other_information, true), attribute(right_presented_clearly, unsure)]).
notice_part(right_not_attested, [attribute(first_communication_with_data_subject_has_taken_place, true), attribute(right_explicitly_brought_to_attention_by_first_communication, true), attribute(right_presented_separately_from_other_information, true), attribute(right_presented_clearly, true)]).
notice_part(first_communication_not_stated, [attribute(right_to_object_applies, attested(true, attestation(fixture_host, fixture_time, fixture_reason, none))), attribute(right_explicitly_brought_to_attention_by_first_communication, true), attribute(right_presented_separately_from_other_information, true), attribute(right_presented_clearly, true)]).
notice_part(nothing_stated, []).

follow_up_part(met, [attribute(controller_made_personal_data_public, true), attribute(controller_obliged_to_erase_under_article_17_1, attested(true, attestation(fixture_host, fixture_time, fixture_reason, none))), attribute(reasonable_steps_taken_to_inform_other_controllers, true)]).
follow_up_part(steps_failed, [attribute(controller_made_personal_data_public, true), attribute(controller_obliged_to_erase_under_article_17_1, attested(true, attestation(fixture_host, fixture_time, fixture_reason, none))), attribute(reasonable_steps_taken_to_inform_other_controllers, false)]).
follow_up_part(not_public, [attribute(controller_made_personal_data_public, false), attribute(controller_obliged_to_erase_under_article_17_1, attested(true, attestation(fixture_host, fixture_time, fixture_reason, none))), attribute(reasonable_steps_taken_to_inform_other_controllers, true)]).
follow_up_part(no_obligation, [attribute(controller_made_personal_data_public, true), attribute(controller_obliged_to_erase_under_article_17_1, attested(false, attestation(fixture_host, fixture_time, fixture_reason, none))), attribute(reasonable_steps_taken_to_inform_other_controllers, true)]).
follow_up_part(steps_unsure, [attribute(controller_made_personal_data_public, true), attribute(controller_obliged_to_erase_under_article_17_1, attested(true, attestation(fixture_host, fixture_time, fixture_reason, none))), attribute(reasonable_steps_taken_to_inform_other_controllers, unsure)]).
follow_up_part(obligation_not_attested, [attribute(controller_made_personal_data_public, true), attribute(reasonable_steps_taken_to_inform_other_controllers, true)]).
follow_up_part(publication_not_stated, [attribute(controller_obliged_to_erase_under_article_17_1, attested(true, attestation(fixture_host, fixture_time, fixture_reason, none))), attribute(reasonable_steps_taken_to_inform_other_controllers, true)]).
follow_up_part(steps_not_stated, [attribute(controller_made_personal_data_public, true), attribute(controller_obliged_to_erase_under_article_17_1, attested(true, attestation(fixture_host, fixture_time, fixture_reason, none)))]).
follow_up_part(nothing_stated, []).

notice_expected(complying, notice_complies).
notice_expected(clarity_failed, notice_does_not_comply).
notice_expected(separation_failed, notice_does_not_comply).
notice_expected(explicit_failed, notice_does_not_comply).
notice_expected(no_right, notice_not_owed).
notice_expected(first_communication_pending, notice_not_yet_due).
notice_expected(explicit_not_stated, indeterminate([right_explicitly_brought_to_attention_by_first_communication])).
notice_expected(clarity_unsure, needs_legal_review(open_textured(right_presented_clearly, cite(eu_reg_2016_679_art_21_4)), [inputs_relied_on([right_presented_clearly - unsure])])).
notice_expected(right_not_attested, needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_21_4), cite(article_21_right_to_object_statement)), [resolution(cite(article_21_right_to_object_statement), not_attempted), inputs_relied_on([right_to_object_applies - absent])])).
notice_expected(first_communication_not_stated, indeterminate([first_communication_with_data_subject_has_taken_place])).
notice_expected(nothing_stated, indeterminate([first_communication_with_data_subject_has_taken_place])).

follow_up_expected(met, follow_up_duty_met).
follow_up_expected(steps_failed, follow_up_duty_not_met).
follow_up_expected(not_public, follow_up_duty_does_not_apply).
follow_up_expected(no_obligation, follow_up_duty_does_not_apply).
follow_up_expected(steps_unsure, needs_legal_review(open_textured(reasonable_steps_taken_to_inform_other_controllers, cite(eu_reg_2016_679_art_17_2)), [inputs_relied_on([reasonable_steps_taken_to_inform_other_controllers - unsure])])).
follow_up_expected(obligation_not_attested, needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_17_2), cite(article_17_1_erasure_obligation_statement)), [resolution(cite(article_17_1_erasure_obligation_statement), not_attempted), inputs_relied_on([controller_obliged_to_erase_under_article_17_1 - absent])])).
follow_up_expected(publication_not_stated, indeterminate([controller_made_personal_data_public])).
follow_up_expected(steps_not_stated, indeterminate([reasonable_steps_taken_to_inform_other_controllers])).
follow_up_expected(nothing_stated, indeterminate([controller_made_personal_data_public])).

gdpr_data_subject_rights_objection_notice_and_erasure_follow_up_expected(Subject, NoticeResult, FollowUpResult) :-
    fixture_row(Subject, NoticeKind, FollowUpKind),
    notice_expected(NoticeKind, NoticeResult),
    follow_up_expected(FollowUpKind, FollowUpResult).
gdpr_data_subject_rights_objection_notice_and_erasure_follow_up_expected(Subject, Result, Result) :-
    malformed_fixture_expected(Subject, Result).

gdpr_data_subject_rights_objection_notice_and_erasure_follow_up_assess(Subject, Result) :-
    gdpr_data_subject_rights_objection_notice_and_erasure_follow_up_profile_for(Subject, Profile),
    decide_gdpr_data_subject_rights_objection_notice_and_erasure_follow_up(Profile, Result).
