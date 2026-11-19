% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_data_subject_rights_response_duties_tests_test_output_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_data_subject_rights_response_duties_gdpr_data_subject_rights_response_duties, [request_response_deadline/2, response_duties/2, recipient_notification/2, gdpr_data_subject_rights_response_duties_status/2]).
:- use_module(m__eu_data_protection_gdpr_data_subject_rights_response_duties_fixtures, [gdpr_data_subject_rights_response_duties_profile_for/2]).

deadlines(Subject, Answers) :-
    gdpr_data_subject_rights_response_duties_profile_for(Subject, Profile),
    findall(Answer, request_response_deadline(Profile, Answer), Answers).

duties(Subject, Answers) :-
    gdpr_data_subject_rights_response_duties_profile_for(Subject, Profile),
    findall(Answer, response_duties(Profile, Answer), Answers).

recipients(Subject, Answers) :-
    gdpr_data_subject_rights_response_duties_profile_for(Subject, Profile),
    findall(Answer, recipient_notification(Profile, Answer), Answers).

statuses(Subject, Answers) :-
    gdpr_data_subject_rights_response_duties_profile_for(Subject, Profile),
    findall(Answer, gdpr_data_subject_rights_response_duties_status(Profile, Answer), Answers).

test(first_period_sunday_end_moves_to_monday) :-
    deadlines(access_plain_must_comply, Answers),
    Answers == [date(2026, 11, 30)].
test(attested_holiday_on_the_last_day_moves_it) :-
    deadlines(access_public_holiday_shift, Answers),
    Answers == [date(2026, 12, 1)].
test(holiday_elsewhere_moves_nothing) :-
    deadlines(access_holiday_elsewhere_no_shift, Answers),
    Answers == [date(2026, 11, 30)].
test(necessary_extension_counts_three_months_from_receipt) :-
    deadlines(access_extension_necessary, Answers),
    Answers == [date(2026, 4, 30)].
test(unnecessary_extension_keeps_the_first_period) :-
    deadlines(access_extension_not_necessary, Answers),
    Answers == [date(2026, 3, 2)].
test(unsure_extension_refers) :-
    deadlines(access_extension_unsure, Answers),
    Answers == [needs_legal_review(open_textured(extension_necessary_for_complexity_and_number, cite(eu_reg_2016_679_art_12_3)), [inputs_relied_on([extension_necessary_for_complexity_and_number - unsure])])].
test(unconfirmed_identity_suspends_the_clock) :-
    deadlines(access_identity_doubts_suspended, Answers),
    Answers == [suspended(art12_6_identity_not_confirmed)].
test(confirmed_identity_runs_the_clock) :-
    deadlines(access_identity_confirmed_complies, Answers),
    Answers == [date(2026, 11, 30)].
test(refusal_without_receipt_names_the_receipt) :-
    deadlines(access_legislative_restriction_attested, Answers),
    Answers == [indeterminate([request_received_on])].
test(common_exception_without_request_type_gives_the_first_period) :-
    deadlines(request_type_absent_manifestly_excessive, Answers),
    Answers == [date(2026, 11, 30)].
test(access_owes_the_response_in_the_first_period) :-
    duties(access_plain_must_comply, Answers),
    Answers == [[respond_with_action_taken(first_period, cite(eu_reg_2016_679_art_12_3))]].
test(extension_adds_the_notice_within_the_first_month) :-
    duties(access_extension_necessary, Answers),
    Answers == [[inform_of_extension_with_reasons(first_period, cite(eu_reg_2016_679_art_12_3)), respond_with_action_taken(extended_period, cite(eu_reg_2016_679_art_12_3))]].
test(refusal_owes_reasons_and_remedies) :-
    duties(access_unable_to_identify_refused, Answers),
    Answers == [[inform_of_reasons_and_remedies(first_period, cite(eu_reg_2016_679_art_12_4))]].
test(suspension_suspends_the_duties) :-
    duties(access_identity_doubts_suspended, Answers),
    Answers == [suspended(art12_6_identity_not_confirmed)].
test(missing_rectification_grounds_are_all_named) :-
    duties(rectification_grounds_missing, Answers),
    Answers == [indeterminate([personal_data_inaccurate, personal_data_incomplete_in_light_of_purposes])].
test(unsure_completeness_refers_on_article_16) :-
    duties(judgement_given_unsure_refers, Answers),
    Answers == [needs_legal_review(open_textured(personal_data_incomplete_in_light_of_purposes, cite(eu_reg_2016_679_art_16)), [inputs_relied_on([request_type - rectification, personal_data_incomplete_in_light_of_purposes - unsure])])].
test(absent_erasure_obligation_refers_as_a_cross_reference) :-
    duties(erasure_legal_obligation_not_attested, [Answer]),
    Answer = needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_17_1_e), cite(union_or_member_state_law_requiring_erasure)), [resolution(cite(union_or_member_state_law_requiring_erasure), not_attempted), inputs_relied_on(_)]).
test(attested_erasure_obligation_engages_the_right) :-
    duties(erasure_legal_obligation_attested, Answers),
    Answers == [[respond_with_action_taken(first_period, cite(eu_reg_2016_679_art_12_3))]].
test(missing_objection_ground_is_named) :-
    duties(objection_ground_missing, Answers),
    Answers == [indeterminate([objection_ground_claimed])].
test(missing_request_type_is_named) :-
    duties(request_type_absent_not_excessive, Answers),
    Answers == [indeterminate([request_type])].
test(rectification_communicates_and_names_the_recipients) :-
    recipients(rectification_recipients_informed, Answers),
    Answers == [[communicate_to_each_recipient(cite(eu_reg_2016_679_art_19)), inform_data_subject_of_recipients(cite(eu_reg_2016_679_art_19))]].
test(disproportionate_effort_excuses_alone) :-
    recipients(rectification_recipients_excused, Answers),
    Answers == [[recipient_notification_excused(cite(eu_reg_2016_679_art_19))]].
test(erasure_carried_out_is_communicated) :-
    recipients(erasure_without_exception_complies, Answers),
    Answers == [[communicate_to_each_recipient(cite(eu_reg_2016_679_art_19))]].
test(refused_erasure_is_not_communicated) :-
    recipients(erasure_legal_claims_exception, Answers),
    Answers == [[recipient_notification_not_applicable(cite(eu_reg_2016_679_art_19))]].
test(open_erasure_names_the_disclosure_key) :-
    recipients(erasure_legal_obligation_not_attested, Answers),
    Answers == [indeterminate([personal_data_disclosed_to_recipients])].
test(restriction_without_recipients_needs_no_communication) :-
    recipients(restriction_accuracy_contested, Answers),
    Answers == [[recipient_notification_not_applicable(cite(eu_reg_2016_679_art_19))]].
test(portability_never_triggers_article_19) :-
    recipients(portability_engaged, Answers),
    Answers == [[recipient_notification_not_applicable(cite(eu_reg_2016_679_art_19))]].
test(one_status_for_the_special_category_bar) :-
    statuses(automated_decision_special_category_bar, Answers),
    Answers == [must_comply].
test(one_status_for_the_explicit_consent_relief) :-
    statuses(automated_decision_explicit_consent, Answers),
    Answers == [need_not_comply].

cp_test_names([first_period_sunday_end_moves_to_monday, attested_holiday_on_the_last_day_moves_it, holiday_elsewhere_moves_nothing, necessary_extension_counts_three_months_from_receipt, unnecessary_extension_keeps_the_first_period, unsure_extension_refers, unconfirmed_identity_suspends_the_clock, confirmed_identity_runs_the_clock, refusal_without_receipt_names_the_receipt, common_exception_without_request_type_gives_the_first_period, access_owes_the_response_in_the_first_period, extension_adds_the_notice_within_the_first_month, refusal_owes_reasons_and_remedies, suspension_suspends_the_duties, missing_rectification_grounds_are_all_named, unsure_completeness_refers_on_article_16, absent_erasure_obligation_refers_as_a_cross_reference, attested_erasure_obligation_engages_the_right, missing_objection_ground_is_named, missing_request_type_is_named, rectification_communicates_and_names_the_recipients, disproportionate_effort_excuses_alone, erasure_carried_out_is_communicated, refused_erasure_is_not_communicated, open_erasure_names_the_disclosure_key, restriction_without_recipients_needs_no_communication, portability_never_triggers_article_19, one_status_for_the_special_category_bar, one_status_for_the_explicit_consent_relief]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
