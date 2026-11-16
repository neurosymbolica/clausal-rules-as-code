% SPDX-License-Identifier: EUPL-1.2
:- module(m__ch_swiss_fadp_art24_breach_notification_tests_test_negative_controls, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__ch_swiss_fadp_art24_breach_notification_swiss_fadp_art24_breach_notification, [swiss_fadp_art24_breach_notification_status_values/1, swiss_controller_report_to_commissioner/3, swiss_processor_report_to_controller/3, swiss_information_of_data_subject/3, eu_controller_notification_to_supervisory_authority/3, compare_swiss_eu_authority_notification/5]).
:- use_module(m__ch_swiss_fadp_art24_breach_notification_kernel, [swiss_fadp_art24_breach_notification_input_problems/2]).
:- use_module(m__ch_swiss_fadp_art24_breach_notification_fixtures, [swiss_fadp_art24_breach_notification_profile_for/2]).

test(near_miss_atoms_are_status_values) :-
    swiss_fadp_art24_breach_notification_status_values(StatusValues),
    member(authority_notification_required, StatusValues),
    member(authority_notification_not_required, StatusValues),
    member(report_to_controller_required, StatusValues),
    member(report_to_controller_not_required, StatusValues),
    member(information_of_data_subject_required, StatusValues),
    member(information_of_data_subject_not_required, StatusValues),
    member(information_of_data_subject_may_be_restricted_deferred_or_omitted, StatusValues).
test(controller_report_required_positive) :-
    swiss_fadp_art24_breach_notification_profile_for(high_risk_breach_all_duties, Profile),
    swiss_controller_report_to_commissioner(Profile, authority_notification_required, _).
test(controller_report_near_miss_not_required) :-
    swiss_fadp_art24_breach_notification_profile_for(breach_without_high_risk, Profile),
    swiss_controller_report_to_commissioner(Profile, authority_notification_not_required, _).
test(controller_referral_positive) :-
    swiss_fadp_art24_breach_notification_profile_for(controller_unsure_breach, Profile),
    swiss_controller_report_to_commissioner(Profile, needs_legal_review(open_textured(breach_of_data_security, cite(ch_fadp_art_5_h)), _), []).
test(controller_referral_near_miss_settled) :-
    swiss_fadp_art24_breach_notification_profile_for(controller_unsure_breach_settled_by_risk, Profile),
    swiss_controller_report_to_commissioner(Profile, authority_notification_not_required, _).
test(processor_report_required_positive) :-
    swiss_fadp_art24_breach_notification_profile_for(breach_only, Profile),
    swiss_processor_report_to_controller(Profile, report_to_controller_required, _).
test(processor_report_near_miss_not_required) :-
    swiss_fadp_art24_breach_notification_profile_for(no_breach, Profile),
    swiss_processor_report_to_controller(Profile, report_to_controller_not_required, _).
test(processor_report_required_without_high_risk) :-
    swiss_fadp_art24_breach_notification_profile_for(breach_without_high_risk, Profile),
    swiss_processor_report_to_controller(Profile, report_to_controller_required, _).
test(information_may_be_restricted_positive) :-
    swiss_fadp_art24_breach_notification_profile_for(information_commissioner_request_with_public_announcement, Profile),
    swiss_information_of_data_subject(Profile, information_of_data_subject_may_be_restricted_deferred_or_omitted, _).
test(information_near_miss_without_exception_required) :-
    swiss_fadp_art24_breach_notification_profile_for(information_commissioner_request_without_exception, Profile),
    swiss_information_of_data_subject(Profile, information_of_data_subject_required, _).
test(information_near_miss_ground_failed_not_required) :-
    swiss_fadp_art24_breach_notification_profile_for(information_ground_failed, Profile),
    swiss_information_of_data_subject(Profile, information_of_data_subject_not_required, _).
test(information_referral_positive) :-
    swiss_fadp_art24_breach_notification_profile_for(information_exception_unsure, Profile),
    swiss_information_of_data_subject(Profile, needs_legal_review(open_textured(information_impossible_or_requires_disproportionate_effort, cite(ch_fadp_art_24_5_b)), _), []).
test(information_referral_near_miss_settled) :-
    swiss_fadp_art24_breach_notification_profile_for(information_exception_unsure_settled_by_announcement, Profile),
    swiss_information_of_data_subject(Profile, information_of_data_subject_may_be_restricted_deferred_or_omitted, _).
test(eu_not_required_positive) :-
    swiss_fadp_art24_breach_notification_profile_for(eu_unlikely_risk_settles_absent_breach, Profile),
    eu_controller_notification_to_supervisory_authority(Profile, authority_notification_not_required, _).
test(eu_near_miss_names_missing_breach) :-
    swiss_fadp_art24_breach_notification_profile_for(eu_not_unlikely_risk_absent_breach, Profile),
    eu_controller_notification_to_supervisory_authority(Profile, indeterminate([personal_data_breach]), []).
test(eu_required_positive) :-
    swiss_fadp_art24_breach_notification_profile_for(high_risk_breach_all_duties, Profile),
    eu_controller_notification_to_supervisory_authority(Profile, authority_notification_required, _).
test(eu_required_near_miss_not_required) :-
    swiss_fadp_art24_breach_notification_profile_for(swiss_and_eu_both_true_thresholds, Profile),
    eu_controller_notification_to_supervisory_authority(Profile, authority_notification_not_required, _).
test(comparison_differs_positive) :-
    swiss_fadp_art24_breach_notification_profile_for(swiss_and_eu_both_true_thresholds, Profile),
    compare_swiss_eu_authority_notification(Profile, _, _, differs, [cite(ch_fadp_art_24_1), cite(eu_reg_2016_679_art_33_1)]).
test(comparison_near_miss_same) :-
    swiss_fadp_art24_breach_notification_profile_for(high_risk_breach_all_duties, Profile),
    compare_swiss_eu_authority_notification(Profile, _, _, same, []).
test(input_check_positive_crisp_unsure) :-
    swiss_fadp_art24_breach_notification_profile_for(crisp_key_unsure, Profile),
    swiss_fadp_art24_breach_notification_input_problems(Profile, [wrong_type(commissioner_requested_information_of_data_subject)]).
test(input_check_near_miss_crisp_true) :-
    swiss_fadp_art24_breach_notification_profile_for(crisp_key_true, Profile),
    swiss_fadp_art24_breach_notification_input_problems(Profile, []).

test(controller_report_near_miss_is_not_required_answer, fail) :-
    swiss_fadp_art24_breach_notification_profile_for(breach_without_high_risk, Profile),
    swiss_controller_report_to_commissioner(Profile, authority_notification_required, _).
test(controller_referral_near_miss_is_not_referred, fail) :-
    swiss_fadp_art24_breach_notification_profile_for(controller_unsure_breach_settled_by_risk, Profile),
    swiss_controller_report_to_commissioner(Profile, needs_legal_review(_, _), _).
test(processor_report_near_miss_is_not_required_answer, fail) :-
    swiss_fadp_art24_breach_notification_profile_for(no_breach, Profile),
    swiss_processor_report_to_controller(Profile, report_to_controller_required, _).
test(information_near_miss_without_exception_is_not_restricted, fail) :-
    swiss_fadp_art24_breach_notification_profile_for(information_commissioner_request_without_exception, Profile),
    swiss_information_of_data_subject(Profile, information_of_data_subject_may_be_restricted_deferred_or_omitted, _).
test(information_near_miss_ground_failed_is_not_required_answer, fail) :-
    swiss_fadp_art24_breach_notification_profile_for(information_ground_failed, Profile),
    swiss_information_of_data_subject(Profile, information_of_data_subject_required, _).
test(information_referral_near_miss_is_not_referred, fail) :-
    swiss_fadp_art24_breach_notification_profile_for(information_exception_unsure_settled_by_announcement, Profile),
    swiss_information_of_data_subject(Profile, needs_legal_review(_, _), _).
test(eu_near_miss_is_not_settled, fail) :-
    swiss_fadp_art24_breach_notification_profile_for(eu_not_unlikely_risk_absent_breach, Profile),
    eu_controller_notification_to_supervisory_authority(Profile, authority_notification_not_required, _).
test(eu_required_near_miss_is_not_required_answer, fail) :-
    swiss_fadp_art24_breach_notification_profile_for(swiss_and_eu_both_true_thresholds, Profile),
    eu_controller_notification_to_supervisory_authority(Profile, authority_notification_required, _).
test(comparison_near_miss_does_not_differ, fail) :-
    swiss_fadp_art24_breach_notification_profile_for(high_risk_breach_all_duties, Profile),
    compare_swiss_eu_authority_notification(Profile, _, _, differs, _).
test(input_check_near_miss_gets_no_input_problems_answer, fail) :-
    swiss_fadp_art24_breach_notification_profile_for(crisp_key_true, Profile),
    swiss_controller_report_to_commissioner(Profile, input_problems(_), _).

cp_test_names([near_miss_atoms_are_status_values, controller_report_required_positive, controller_report_near_miss_not_required, controller_referral_positive, controller_referral_near_miss_settled, processor_report_required_positive, processor_report_near_miss_not_required, processor_report_required_without_high_risk, information_may_be_restricted_positive, information_near_miss_without_exception_required, information_near_miss_ground_failed_not_required, information_referral_positive, information_referral_near_miss_settled, eu_not_required_positive, eu_near_miss_names_missing_breach, eu_required_positive, eu_required_near_miss_not_required, comparison_differs_positive, comparison_near_miss_same, input_check_positive_crisp_unsure, input_check_near_miss_crisp_true]).
cp_test_fail_names([controller_report_near_miss_is_not_required_answer, controller_referral_near_miss_is_not_referred, processor_report_near_miss_is_not_required_answer, information_near_miss_without_exception_is_not_restricted, information_near_miss_ground_failed_is_not_required_answer, information_referral_near_miss_is_not_referred, eu_near_miss_is_not_settled, eu_required_near_miss_is_not_required_answer, comparison_near_miss_does_not_differ, input_check_near_miss_gets_no_input_problems_answer]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
