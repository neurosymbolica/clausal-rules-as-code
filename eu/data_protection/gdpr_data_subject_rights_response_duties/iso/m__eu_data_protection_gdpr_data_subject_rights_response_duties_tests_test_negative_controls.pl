% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_data_subject_rights_response_duties_tests_test_negative_controls, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_data_subject_rights_response_duties_gdpr_data_subject_rights_response_duties, [gdpr_data_subject_rights_response_duties_status/2, request_response_deadline/2, response_duties/2, recipient_notification/2]).
:- use_module(m__eu_data_protection_gdpr_data_subject_rights_response_duties_fixtures, [gdpr_data_subject_rights_response_duties_profile_for/2]).

status_of(Subject, Status) :-
    gdpr_data_subject_rights_response_duties_profile_for(Subject, Profile),
    gdpr_data_subject_rights_response_duties_status(Profile, Status).

deadline_of(Subject, Deadline) :-
    gdpr_data_subject_rights_response_duties_profile_for(Subject, Profile),
    request_response_deadline(Profile, Deadline).

duties_of(Subject, Duties) :-
    gdpr_data_subject_rights_response_duties_profile_for(Subject, Profile),
    response_duties(Profile, Duties).

recipients_of(Subject, Duties) :-
    gdpr_data_subject_rights_response_duties_profile_for(Subject, Profile),
    recipient_notification(Profile, Duties).

test(plain_access_must_comply) :-
    status_of(access_plain_must_comply, must_comply).
test(manifestly_excessive_access_need_not_comply) :-
    status_of(access_manifestly_excessive_refused, need_not_comply).
test(holiday_on_the_last_day_shifts) :-
    deadline_of(access_public_holiday_shift, date(2026, 12, 1)).
test(holiday_elsewhere_keeps_monday) :-
    deadline_of(access_holiday_elsewhere_no_shift, date(2026, 11, 30)).
test(necessary_extension_gives_three_months) :-
    deadline_of(access_extension_necessary, date(2026, 4, 30)).
test(unnecessary_extension_gives_the_first_period) :-
    deadline_of(access_extension_not_necessary, date(2026, 3, 2)).
test(unconfirmed_identity_is_suspended) :-
    status_of(access_identity_doubts_suspended, suspended).
test(confirmed_identity_must_comply) :-
    status_of(access_identity_confirmed_complies, must_comply).
test(attested_restriction_relieves) :-
    status_of(access_legislative_restriction_attested, need_not_comply).
test(denied_restriction_must_comply) :-
    status_of(access_legislative_restriction_denied, must_comply).
test(refused_erasure_needs_no_communication) :-
    recipients_of(erasure_legal_claims_exception, [recipient_notification_not_applicable(cite(eu_reg_2016_679_art_19))]).
test(erasure_carried_out_is_communicated) :-
    recipients_of(erasure_without_exception_complies, [communicate_to_each_recipient(cite(eu_reg_2016_679_art_19))]).
test(absent_erasure_obligation_refers) :-
    status_of(erasure_legal_obligation_not_attested, needs_legal_review).
test(attested_erasure_obligation_must_comply) :-
    status_of(erasure_legal_obligation_attested, must_comply).
test(rectification_communicates) :-
    recipients_of(rectification_recipients_informed, [communicate_to_each_recipient(cite(eu_reg_2016_679_art_19)), inform_data_subject_of_recipients(cite(eu_reg_2016_679_art_19))]).
test(excused_rectification_is_excused) :-
    recipients_of(rectification_recipients_excused, [recipient_notification_excused(cite(eu_reg_2016_679_art_19))]).
test(contested_accuracy_engages_restriction) :-
    status_of(restriction_accuracy_contested, must_comply).
test(no_point_of_article_18_need_not_comply) :-
    status_of(restriction_not_engaged, need_not_comply).
test(portability_engaged_owes_the_response) :-
    duties_of(portability_engaged, [respond_with_action_taken(first_period, cite(eu_reg_2016_679_art_12_3))]).
test(rights_of_others_owe_reasons) :-
    duties_of(portability_rights_of_others, [inform_of_reasons_and_remedies(first_period, cite(eu_reg_2016_679_art_12_4))]).
test(direct_marketing_objection_must_comply) :-
    status_of(objection_direct_marketing, must_comply).
test(no_direct_marketing_need_not_comply) :-
    status_of(objection_not_direct_marketing, need_not_comply).
test(explicit_consent_relieves) :-
    status_of(automated_decision_explicit_consent, need_not_comply).
test(special_category_bar_must_comply) :-
    status_of(automated_decision_special_category_bar, must_comply).
test(common_exception_settles_duties_without_request_type) :-
    duties_of(request_type_absent_manifestly_excessive, [inform_of_reasons_and_remedies(first_period, cite(eu_reg_2016_679_art_12_4))]).
test(no_exception_names_the_request_type) :-
    duties_of(request_type_absent_not_excessive, indeterminate([request_type])).
test(unsure_judgement_refers) :-
    status_of(judgement_given_unsure_refers, needs_legal_review).
test(unsure_crisp_key_is_an_input_problem) :-
    status_of(crisp_key_given_unsure, input_problems).

test(manifestly_excessive_access_is_not_must_comply, fail) :-
    status_of(access_manifestly_excessive_refused, must_comply).
test(holiday_elsewhere_does_not_shift, fail) :-
    deadline_of(access_holiday_elsewhere_no_shift, date(2026, 12, 1)).
test(unnecessary_extension_does_not_give_three_months, fail) :-
    deadline_of(access_extension_not_necessary, date(2026, 4, 30)).
test(confirmed_identity_is_not_suspended, fail) :-
    status_of(access_identity_confirmed_complies, suspended).
test(denied_restriction_does_not_relieve, fail) :-
    status_of(access_legislative_restriction_denied, need_not_comply).
test(erasure_carried_out_is_not_left_uncommunicated, fail) :-
    recipients_of(erasure_without_exception_complies, [recipient_notification_not_applicable(cite(eu_reg_2016_679_art_19))]).
test(attested_erasure_obligation_does_not_refer, fail) :-
    status_of(erasure_legal_obligation_attested, needs_legal_review).
test(excused_rectification_does_not_communicate, fail) :-
    recipients_of(rectification_recipients_excused, [communicate_to_each_recipient(cite(eu_reg_2016_679_art_19)), inform_data_subject_of_recipients(cite(eu_reg_2016_679_art_19))]).
test(no_point_of_article_18_does_not_engage, fail) :-
    status_of(restriction_not_engaged, must_comply).
test(rights_of_others_do_not_owe_the_response, fail) :-
    duties_of(portability_rights_of_others, [respond_with_action_taken(first_period, cite(eu_reg_2016_679_art_12_3))]).
test(no_direct_marketing_does_not_engage, fail) :-
    status_of(objection_not_direct_marketing, must_comply).
test(special_category_bar_removes_the_relief, fail) :-
    status_of(automated_decision_special_category_bar, need_not_comply).
test(no_exception_does_not_settle_duties_without_request_type, fail) :-
    duties_of(request_type_absent_not_excessive, [inform_of_reasons_and_remedies(first_period, cite(eu_reg_2016_679_art_12_4))]).
test(unsure_crisp_key_does_not_refer, fail) :-
    status_of(crisp_key_given_unsure, needs_legal_review).

cp_test_names([plain_access_must_comply, manifestly_excessive_access_need_not_comply, holiday_on_the_last_day_shifts, holiday_elsewhere_keeps_monday, necessary_extension_gives_three_months, unnecessary_extension_gives_the_first_period, unconfirmed_identity_is_suspended, confirmed_identity_must_comply, attested_restriction_relieves, denied_restriction_must_comply, refused_erasure_needs_no_communication, erasure_carried_out_is_communicated, absent_erasure_obligation_refers, attested_erasure_obligation_must_comply, rectification_communicates, excused_rectification_is_excused, contested_accuracy_engages_restriction, no_point_of_article_18_need_not_comply, portability_engaged_owes_the_response, rights_of_others_owe_reasons, direct_marketing_objection_must_comply, no_direct_marketing_need_not_comply, explicit_consent_relieves, special_category_bar_must_comply, common_exception_settles_duties_without_request_type, no_exception_names_the_request_type, unsure_judgement_refers, unsure_crisp_key_is_an_input_problem]).
cp_test_fail_names([manifestly_excessive_access_is_not_must_comply, holiday_elsewhere_does_not_shift, unnecessary_extension_does_not_give_three_months, confirmed_identity_is_not_suspended, denied_restriction_does_not_relieve, erasure_carried_out_is_not_left_uncommunicated, attested_erasure_obligation_does_not_refer, excused_rectification_does_not_communicate, no_point_of_article_18_does_not_engage, rights_of_others_do_not_owe_the_response, no_direct_marketing_does_not_engage, special_category_bar_removes_the_relief, no_exception_does_not_settle_duties_without_request_type, unsure_crisp_key_does_not_refer]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
