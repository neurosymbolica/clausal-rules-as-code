% SPDX-License-Identifier: EUPL-1.2
:- module(m__sg_data_protection_pdpa_data_breach_notification_tests_test_negative_controls, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__sg_data_protection_pdpa_data_breach_notification_pdpa_data_breach_notification, [pdpa_data_breach_notification_status/2, pdpa_data_breach_notification_status_values/1, pdpa_data_breach_notification_checklist/2, individual_notification/3, breach_response_duty/3]).
:- use_module(m__sg_data_protection_pdpa_data_breach_notification_fixtures, [pdpa_data_breach_notification_profile_for/2]).

harm_result(Profile, Result, Citations) :-
    pdpa_data_breach_notification_checklist(Profile, [item(significant_harm, Result, Citations)|_]).

scale_result(Profile, Result, Citations) :-
    pdpa_data_breach_notification_checklist(Profile, [_, item(significant_scale, Result, Citations)|_]).

test(the_near_miss_verdicts_are_real_verdict_atoms) :-
    pdpa_data_breach_notification_status_values(StatusValues),
    member(notifiable, StatusValues),
    member(not_notifiable, StatusValues),
    member(not_applicable, StatusValues).
test(a_breach_on_the_commencement_day_is_notifiable) :-
    pdpa_data_breach_notification_profile_for(commencement_day_breach, Profile),
    pdpa_data_breach_notification_status(Profile, notifiable).
test(a_breach_the_day_before_commencement_is_not_applicable) :-
    pdpa_data_breach_notification_profile_for(pre_commencement_breach, Profile),
    pdpa_data_breach_notification_status(Profile, not_applicable).
test(account_identifier_with_credential_is_deemed_harm) :-
    pdpa_data_breach_notification_profile_for(account_pair_breach, Profile),
    harm_result(Profile, significant_harm, Citations),
    Citations == [cite(sg_pdpa_2012_s26b_2_a), cite(sg_pdpa_2012_s64_2021_reg_3_1_b)].
test(a_credential_alone_is_no_significant_harm) :-
    pdpa_data_breach_notification_profile_for(credential_only_breach, Profile),
    harm_result(Profile, no_significant_harm, _).
test(a_bank_account_number_with_credential_is_deemed_harm) :-
    pdpa_data_breach_notification_profile_for(bank_account_number_breach, Profile),
    harm_result(Profile, significant_harm, Citations),
    member(cite(sg_pdpa_2012_s64_2021_reg_3_2), Citations).
test(a_bank_account_number_without_credential_is_no_significant_harm) :-
    harm_result([attribute(breached_data, [bank_or_finance_company_account_number]), attribute(assessed_likely_significant_harm, false)], no_significant_harm, _).
test(identity_with_a_schedule_item_is_deemed_harm) :-
    pdpa_data_breach_notification_profile_for(identity_with_schedule_data, Profile),
    harm_result(Profile, significant_harm, Citations),
    member(cite(sg_pdpa_2012_s64_2021_sched_1_item_3), Citations).
test(a_publicly_available_schedule_item_is_no_significant_harm) :-
    pdpa_data_breach_notification_profile_for(schedule_data_publicly_available, Profile),
    harm_result(Profile, no_significant_harm, _).
test(five_hundred_is_significant_scale) :-
    pdpa_data_breach_notification_profile_for(affected_count_at_prescribed_number, Profile),
    scale_result(Profile, significant_scale, Citations),
    Citations == [cite(sg_pdpa_2012_s26b_3_a), cite(sg_pdpa_2012_s64_2021_reg_4)].
test(four_hundred_ninety_nine_is_no_significant_scale) :-
    pdpa_data_breach_notification_profile_for(affected_count_below_prescribed_number, Profile),
    scale_result(Profile, no_significant_scale, _).
test(within_organisation_access_is_not_notifiable) :-
    pdpa_data_breach_notification_profile_for(within_organisation_access_excluded, Profile),
    pdpa_data_breach_notification_status(Profile, not_notifiable).
test(within_organisation_with_disposal_is_notifiable) :-
    pdpa_data_breach_notification_profile_for(within_organisation_with_disposal, Profile),
    pdpa_data_breach_notification_status(Profile, notifiable).
test(a_judged_data_breach_is_notifiable) :-
    pdpa_data_breach_notification_profile_for(account_pair_breach, Profile),
    pdpa_data_breach_notification_status(Profile, notifiable).
test(an_incident_judged_no_data_breach_is_not_notifiable) :-
    pdpa_data_breach_notification_profile_for(not_a_data_breach, Profile),
    pdpa_data_breach_notification_status(Profile, not_notifiable).
test(no_exception_requires_notice) :-
    pdpa_data_breach_notification_profile_for(no_exception_applies, Profile),
    individual_notification(Profile, required, [cite(sg_pdpa_2012_s26d_2)]).
test(a_law_enforcement_instruction_prohibits_notice) :-
    pdpa_data_breach_notification_profile_for(law_enforcement_and_waiver, Profile),
    individual_notification(Profile, prohibited, [cite(sg_pdpa_2012_s26d_6_a)]).
test(a_waiver_alone_waives_notice) :-
    pdpa_data_breach_notification_profile_for(waiver_only, Profile),
    individual_notification(Profile, waived, [cite(sg_pdpa_2012_s26d_7)]).
test(remedial_action_makes_notice_not_required) :-
    pdpa_data_breach_notification_profile_for(remedial_action_taken, Profile),
    individual_notification(Profile, not_required, [cite(sg_pdpa_2012_s26d_5_a)]).
test(a_scale_only_breach_owes_no_notice) :-
    pdpa_data_breach_notification_profile_for(affected_count_at_prescribed_number, Profile),
    individual_notification(Profile, not_required, [cite(sg_pdpa_2012_s26d_2), cite(sg_pdpa_2012_s26b_1_a)]).
test(an_organisation_notified_by_an_intermediary_must_assess) :-
    pdpa_data_breach_notification_profile_for(organisation_notified_by_intermediary, Profile),
    breach_response_duty(Profile, assessment_required, [cite(sg_pdpa_2012_s26c_3_b)]).
test(an_organisation_without_possession_has_no_duty) :-
    pdpa_data_breach_notification_profile_for(organisation_without_possession, Profile),
    breach_response_duty(Profile, no_duty_triggered, [cite(sg_pdpa_2012_s26c_2)]).
test(a_public_agency_intermediary_must_notify_without_a_date) :-
    pdpa_data_breach_notification_profile_for(public_agency_intermediary_without_date, Profile),
    breach_response_duty(Profile, notify_public_agency_without_undue_delay, _).
test(an_intermediary_after_commencement_must_notify) :-
    pdpa_data_breach_notification_profile_for(intermediary_for_organisation, Profile),
    breach_response_duty(Profile, notify_organisation_without_undue_delay, _).
test(an_intermediary_before_commencement_is_not_applicable) :-
    pdpa_data_breach_notification_profile_for(intermediary_before_commencement, Profile),
    breach_response_duty(Profile, not_applicable, [cite(sg_pdpa_2012_s26c_1)]).

test(a_breach_the_day_before_commencement_is_not_notifiable, fail) :-
    pdpa_data_breach_notification_profile_for(pre_commencement_breach, Profile),
    pdpa_data_breach_notification_status(Profile, notifiable).
test(a_credential_alone_is_not_deemed_harm, fail) :-
    pdpa_data_breach_notification_profile_for(credential_only_breach, Profile),
    harm_result(Profile, significant_harm, _).
test(a_bank_account_number_without_credential_is_not_deemed_harm, fail) :-
    harm_result([attribute(breached_data, [bank_or_finance_company_account_number]), attribute(assessed_likely_significant_harm, false)], significant_harm, _).
test(a_publicly_available_schedule_item_is_not_deemed_harm, fail) :-
    pdpa_data_breach_notification_profile_for(schedule_data_publicly_available, Profile),
    harm_result(Profile, significant_harm, _).
test(four_hundred_ninety_nine_is_not_significant_scale, fail) :-
    pdpa_data_breach_notification_profile_for(affected_count_below_prescribed_number, Profile),
    scale_result(Profile, significant_scale, _).
test(within_organisation_access_is_not_notifiable_bound_wrongly, fail) :-
    pdpa_data_breach_notification_profile_for(within_organisation_access_excluded, Profile),
    pdpa_data_breach_notification_status(Profile, notifiable).
test(within_organisation_with_disposal_is_not_excluded, fail) :-
    pdpa_data_breach_notification_profile_for(within_organisation_with_disposal, Profile),
    pdpa_data_breach_notification_status(Profile, not_notifiable).
test(an_incident_judged_no_data_breach_is_never_notifiable, fail) :-
    pdpa_data_breach_notification_profile_for(not_a_data_breach, Profile),
    pdpa_data_breach_notification_status(Profile, notifiable).
test(no_exception_is_not_not_required, fail) :-
    pdpa_data_breach_notification_profile_for(no_exception_applies, Profile),
    individual_notification(Profile, not_required, _).
test(a_law_enforcement_instruction_wins_over_a_waiver, fail) :-
    pdpa_data_breach_notification_profile_for(law_enforcement_and_waiver, Profile),
    individual_notification(Profile, waived, _).
test(remedial_action_is_not_required_notice, fail) :-
    pdpa_data_breach_notification_profile_for(remedial_action_taken, Profile),
    individual_notification(Profile, required, _).
test(a_scale_only_breach_does_not_require_notice, fail) :-
    pdpa_data_breach_notification_profile_for(affected_count_at_prescribed_number, Profile),
    individual_notification(Profile, required, _).
test(an_organisation_without_possession_need_not_assess, fail) :-
    pdpa_data_breach_notification_profile_for(organisation_without_possession, Profile),
    breach_response_duty(Profile, assessment_required, _).
test(an_intermediary_before_commencement_need_not_notify, fail) :-
    pdpa_data_breach_notification_profile_for(intermediary_before_commencement, Profile),
    breach_response_duty(Profile, notify_organisation_without_undue_delay, _).

cp_test_names([the_near_miss_verdicts_are_real_verdict_atoms, a_breach_on_the_commencement_day_is_notifiable, a_breach_the_day_before_commencement_is_not_applicable, account_identifier_with_credential_is_deemed_harm, a_credential_alone_is_no_significant_harm, a_bank_account_number_with_credential_is_deemed_harm, a_bank_account_number_without_credential_is_no_significant_harm, identity_with_a_schedule_item_is_deemed_harm, a_publicly_available_schedule_item_is_no_significant_harm, five_hundred_is_significant_scale, four_hundred_ninety_nine_is_no_significant_scale, within_organisation_access_is_not_notifiable, within_organisation_with_disposal_is_notifiable, a_judged_data_breach_is_notifiable, an_incident_judged_no_data_breach_is_not_notifiable, no_exception_requires_notice, a_law_enforcement_instruction_prohibits_notice, a_waiver_alone_waives_notice, remedial_action_makes_notice_not_required, a_scale_only_breach_owes_no_notice, an_organisation_notified_by_an_intermediary_must_assess, an_organisation_without_possession_has_no_duty, a_public_agency_intermediary_must_notify_without_a_date, an_intermediary_after_commencement_must_notify, an_intermediary_before_commencement_is_not_applicable]).
cp_test_fail_names([a_breach_the_day_before_commencement_is_not_notifiable, a_credential_alone_is_not_deemed_harm, a_bank_account_number_without_credential_is_not_deemed_harm, a_publicly_available_schedule_item_is_not_deemed_harm, four_hundred_ninety_nine_is_not_significant_scale, within_organisation_access_is_not_notifiable_bound_wrongly, within_organisation_with_disposal_is_not_excluded, an_incident_judged_no_data_breach_is_never_notifiable, no_exception_is_not_not_required, a_law_enforcement_instruction_wins_over_a_waiver, remedial_action_is_not_required_notice, a_scale_only_breach_does_not_require_notice, an_organisation_without_possession_need_not_assess, an_intermediary_before_commencement_need_not_notify]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
