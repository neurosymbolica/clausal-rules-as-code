% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_data_subject_rights_response_duties_tests_test_negative_controls, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_data_subject_rights_response_duties_gdpr_data_subject_rights_response_duties, [gdpr_data_subject_rights_response_duties_status/2, gdpr_data_subject_rights_response_duties_status_values/1, request_response_deadline/2, response_duties/2, recipient_notification/2]).
:- use_module(m__eu_data_protection_gdpr_data_subject_rights_response_duties_fixtures, [gdpr_data_subject_rights_response_duties_profile_for/2]).

status_of(Subject, Status) :-
    gdpr_data_subject_rights_response_duties_profile_for(Subject, Profile),
    gdpr_data_subject_rights_response_duties_status(Profile, Status).

deadline_of(Subject, Deadline) :-
    gdpr_data_subject_rights_response_duties_profile_for(Subject, Profile),
    request_response_deadline(Profile, Deadline).

test(the_near_miss_verdict_atoms_are_real_verdict_atoms) :-
    gdpr_data_subject_rights_response_duties_status_values(StatusValues),
    member(must_comply, StatusValues),
    member(need_not_comply, StatusValues).
test(excessive_request_need_not_comply) :-
    status_of(access_excessive, need_not_comply).
test(not_excessive_request_must_comply) :-
    status_of(access_not_excessive, must_comply).
test(unable_to_identify_need_not_comply) :-
    status_of(access_unable_to_identify, need_not_comply).
test(without_the_showing_must_comply) :-
    status_of(access_basic, must_comply).
test(unconfirmed_identity_suspends) :-
    status_of(access_identity_suspended, suspended(art12_6_identity_not_confirmed)).
test(confirmed_identity_must_comply) :-
    status_of(access_identity_confirmed, must_comply).
test(attested_restriction_need_not_comply) :-
    status_of(access_restricted_by_law, need_not_comply).
test(attested_no_restriction_must_comply) :-
    status_of(access_not_restricted_by_law, must_comply).
test(inaccurate_data_must_comply) :-
    status_of(rectification_inaccurate, must_comply).
test(accurate_complete_data_need_not_comply) :-
    status_of(rectification_nothing_wrong, need_not_comply).
test(no_longer_necessary_must_comply) :-
    status_of(erasure_no_longer_necessary, must_comply).
test(legal_claims_exception_need_not_comply) :-
    status_of(erasure_legal_claims_exception, need_not_comply).
test(contested_accuracy_must_comply) :-
    status_of(restriction_accuracy_contested, must_comply).
test(no_ground_need_not_comply) :-
    status_of(restriction_no_ground, need_not_comply).
test(portability_engaged_must_comply) :-
    status_of(portability_engaged, must_comply).
test(portability_not_automated_need_not_comply) :-
    status_of(portability_not_automated, need_not_comply).
test(portability_public_task_need_not_comply) :-
    status_of(portability_public_task, need_not_comply).
test(direct_marketing_objection_must_comply) :-
    status_of(objection_marketing, must_comply).
test(not_marketing_objection_need_not_comply) :-
    status_of(objection_not_marketing, need_not_comply).
test(compelling_grounds_need_not_comply) :-
    status_of(objection_art21_1_compelling, need_not_comply).
test(explicit_consent_relieves) :-
    status_of(automated_decision_consent, need_not_comply).
test(no_consent_must_comply) :-
    status_of(automated_decision_no_consent, must_comply).
test(special_category_bar_removes_the_consent_exception) :-
    status_of(automated_decision_special_bar, must_comply).
test(necessary_extension_gives_three_months) :-
    deadline_of(extension_necessary, date(2026, 4, 30)).
test(unnecessary_extension_gives_one_month) :-
    deadline_of(extension_not_necessary, date(2026, 3, 2)).
test(unsure_extension_is_referred) :-
    deadline_of(extension_unsure, needs_legal_review(open_textured(extension_necessary_for_complexity_and_number, cite(eu_reg_2016_679_art_12_3)), [inputs_relied_on([extension_necessary_for_complexity_and_number - unsure])])).
test(public_holiday_moves_the_deadline) :-
    deadline_of(holiday_shift, date(2026, 12, 1)).
test(no_holiday_leaves_the_working_day) :-
    deadline_of(no_holiday_shift, date(2026, 11, 30)).
test(erasure_with_recipients_communicates) :-
    gdpr_data_subject_rights_response_duties_profile_for(erasure_no_longer_necessary, Profile),
    recipient_notification(Profile, [communicate_to_each_recipient(_)|_]).
test(excused_effort_is_excused) :-
    gdpr_data_subject_rights_response_duties_profile_for(erasure_effort_excused, Profile),
    recipient_notification(Profile, [recipient_notification_excused(cite(eu_reg_2016_679_art_19))]).
test(no_disclosure_is_not_applicable) :-
    gdpr_data_subject_rights_response_duties_profile_for(rectification_inaccurate, Profile),
    recipient_notification(Profile, [recipient_notification_not_applicable(cite(eu_reg_2016_679_art_19))]).
test(refusal_has_no_recipient_duty) :-
    gdpr_data_subject_rights_response_duties_profile_for(erasure_legal_claims_exception, Profile),
    recipient_notification(Profile, [recipient_notification_not_applicable(cite(eu_reg_2016_679_art_19))]).

test(not_excessive_request_is_not_refused, fail) :-
    status_of(access_not_excessive, need_not_comply).
test(without_the_showing_not_refused, fail) :-
    status_of(access_basic, need_not_comply).
test(confirmed_identity_is_not_suspended, fail) :-
    status_of(access_identity_confirmed, suspended(_)).
test(no_restriction_is_not_a_refusal, fail) :-
    status_of(access_not_restricted_by_law, need_not_comply).
test(accurate_complete_data_is_not_must_comply, fail) :-
    status_of(rectification_nothing_wrong, must_comply).
test(legal_claims_exception_is_not_must_comply, fail) :-
    status_of(erasure_legal_claims_exception, must_comply).
test(no_ground_is_not_must_comply, fail) :-
    status_of(restriction_no_ground, must_comply).
test(portability_not_automated_is_not_must_comply, fail) :-
    status_of(portability_not_automated, must_comply).
test(not_marketing_objection_is_not_must_comply, fail) :-
    status_of(objection_not_marketing, must_comply).
test(special_category_bar_is_not_a_refusal, fail) :-
    status_of(automated_decision_special_bar, need_not_comply).
test(unnecessary_extension_is_not_three_months, fail) :-
    deadline_of(extension_not_necessary, date(2026, 4, 30)).
test(no_holiday_is_not_shifted_again, fail) :-
    deadline_of(no_holiday_shift, date(2026, 12, 1)).
test(excused_effort_is_not_communicated, fail) :-
    gdpr_data_subject_rights_response_duties_profile_for(erasure_effort_excused, Profile),
    recipient_notification(Profile, [communicate_to_each_recipient(_)|_]).

cp_test_names([the_near_miss_verdict_atoms_are_real_verdict_atoms, excessive_request_need_not_comply, not_excessive_request_must_comply, unable_to_identify_need_not_comply, without_the_showing_must_comply, unconfirmed_identity_suspends, confirmed_identity_must_comply, attested_restriction_need_not_comply, attested_no_restriction_must_comply, inaccurate_data_must_comply, accurate_complete_data_need_not_comply, no_longer_necessary_must_comply, legal_claims_exception_need_not_comply, contested_accuracy_must_comply, no_ground_need_not_comply, portability_engaged_must_comply, portability_not_automated_need_not_comply, portability_public_task_need_not_comply, direct_marketing_objection_must_comply, not_marketing_objection_need_not_comply, compelling_grounds_need_not_comply, explicit_consent_relieves, no_consent_must_comply, special_category_bar_removes_the_consent_exception, necessary_extension_gives_three_months, unnecessary_extension_gives_one_month, unsure_extension_is_referred, public_holiday_moves_the_deadline, no_holiday_leaves_the_working_day, erasure_with_recipients_communicates, excused_effort_is_excused, no_disclosure_is_not_applicable, refusal_has_no_recipient_duty]).
cp_test_fail_names([not_excessive_request_is_not_refused, without_the_showing_not_refused, confirmed_identity_is_not_suspended, no_restriction_is_not_a_refusal, accurate_complete_data_is_not_must_comply, legal_claims_exception_is_not_must_comply, no_ground_is_not_must_comply, portability_not_automated_is_not_must_comply, not_marketing_objection_is_not_must_comply, special_category_bar_is_not_a_refusal, unnecessary_extension_is_not_three_months, no_holiday_is_not_shifted_again, excused_effort_is_not_communicated]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
