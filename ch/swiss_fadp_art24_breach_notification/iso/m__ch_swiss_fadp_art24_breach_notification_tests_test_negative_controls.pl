% SPDX-License-Identifier: EUPL-1.2
:- module(m__ch_swiss_fadp_art24_breach_notification_tests_test_negative_controls, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__ch_swiss_fadp_art24_breach_notification_swiss_fadp_art24_breach_notification, [swiss_controller_report_to_commissioner/3, swiss_processor_report_to_controller/3, swiss_information_of_data_subject/3, eu_controller_notification_to_supervisory_authority/3, compare_swiss_eu_authority_notification/5, swiss_fadp_art24_breach_notification_status_values/1]).
:- use_module(m__ch_swiss_fadp_art24_breach_notification_kernel, [swiss_fadp_art24_breach_notification_input_problems/2]).
:- use_module(m__ch_swiss_fadp_art24_breach_notification_fixtures, [swiss_fadp_art24_breach_notification_profile_for/2]).

test(the_status_table_holds_both_controller_atoms) :-
    swiss_fadp_art24_breach_notification_status_values(StatusValues),
    member(authority_notification_required, StatusValues),
    member(authority_notification_not_required, StatusValues).
test(controller_required_positive) :-
    swiss_fadp_art24_breach_notification_profile_for(all_duties_owed, Profile),
    swiss_controller_report_to_commissioner(Profile, authority_notification_required, _).
test(controller_near_miss_gets_not_required) :-
    swiss_fadp_art24_breach_notification_profile_for(high_risk_false_control, Profile),
    swiss_controller_report_to_commissioner(Profile, authority_notification_not_required, _).
test(controller_no_breach_positive) :-
    swiss_fadp_art24_breach_notification_profile_for(no_breach, Profile),
    swiss_controller_report_to_commissioner(Profile, authority_notification_not_required, _).
test(controller_indeterminate_positive) :-
    swiss_fadp_art24_breach_notification_profile_for(high_risk_absent, Profile),
    swiss_controller_report_to_commissioner(Profile, indeterminate([breach_likely_to_lead_to_high_risk_to_personality_or_fundamental_rights]), []).
test(controller_review_positive) :-
    swiss_fadp_art24_breach_notification_profile_for(breach_unsure, Profile),
    swiss_controller_report_to_commissioner(Profile, needs_legal_review(open_textured(breach_of_data_security, cite(ch_fadp_art_5_h)), _), []).
test(controller_review_near_miss_gets_indeterminate) :-
    swiss_fadp_art24_breach_notification_profile_for(breach_unsure_high_risk_absent, Profile),
    swiss_controller_report_to_commissioner(Profile, indeterminate([breach_likely_to_lead_to_high_risk_to_personality_or_fundamental_rights]), []).
test(processor_required_positive) :-
    swiss_fadp_art24_breach_notification_profile_for(high_risk_false_control, Profile),
    swiss_processor_report_to_controller(Profile, report_to_controller_required, _).
test(processor_near_miss_gets_not_required) :-
    swiss_fadp_art24_breach_notification_profile_for(no_breach, Profile),
    swiss_processor_report_to_controller(Profile, report_to_controller_not_required, _).
test(information_exception_positive) :-
    swiss_fadp_art24_breach_notification_profile_for(public_announcement_exception, Profile),
    swiss_information_of_data_subject(Profile, information_of_data_subject_may_be_restricted_deferred_or_omitted, _).
test(information_exception_near_miss_gets_required) :-
    swiss_fadp_art24_breach_notification_profile_for(public_announcement_false_control, Profile),
    swiss_information_of_data_subject(Profile, information_of_data_subject_required, _).
test(information_request_with_exception_positive) :-
    swiss_fadp_art24_breach_notification_profile_for(commissioner_request_with_exception, Profile),
    swiss_information_of_data_subject(Profile, information_of_data_subject_may_be_restricted_deferred_or_omitted, _).
test(information_request_near_miss_gets_required) :-
    swiss_fadp_art24_breach_notification_profile_for(commissioner_request_only, Profile),
    swiss_information_of_data_subject(Profile, information_of_data_subject_required, _).
test(information_ground_failed_positive) :-
    swiss_fadp_art24_breach_notification_profile_for(ground_failed, Profile),
    swiss_information_of_data_subject(Profile, information_of_data_subject_not_required, _).
test(information_review_positive) :-
    swiss_fadp_art24_breach_notification_profile_for(necessity_unsure, Profile),
    swiss_information_of_data_subject(Profile, needs_legal_review(open_textured(information_necessary_for_protection_of_data_subject, cite(ch_fadp_art_24_4)), _), []).
test(information_review_near_miss_gets_required) :-
    swiss_fadp_art24_breach_notification_profile_for(necessity_unsure_request_met, Profile),
    swiss_information_of_data_subject(Profile, information_of_data_subject_required, _).
test(eu_required_positive) :-
    swiss_fadp_art24_breach_notification_profile_for(all_duties_owed, Profile),
    eu_controller_notification_to_supervisory_authority(Profile, authority_notification_required, _).
test(eu_near_miss_gets_not_required) :-
    swiss_fadp_art24_breach_notification_profile_for(both_risk_judgements_true, Profile),
    eu_controller_notification_to_supervisory_authority(Profile, authority_notification_not_required, _).
test(eu_review_positive) :-
    swiss_fadp_art24_breach_notification_profile_for(eu_unsure, Profile),
    eu_controller_notification_to_supervisory_authority(Profile, needs_legal_review(open_textured(personal_data_breach, cite(eu_reg_2016_679_art_33_1)), _), []).
test(comparison_same_positive) :-
    swiss_fadp_art24_breach_notification_profile_for(all_duties_owed, Profile),
    compare_swiss_eu_authority_notification(Profile, _, _, same, []).
test(comparison_near_miss_gets_differs) :-
    swiss_fadp_art24_breach_notification_profile_for(high_risk_false_control, Profile),
    compare_swiss_eu_authority_notification(Profile, _, _, differs, [cite(ch_fadp_art_24_1), cite(eu_reg_2016_679_art_33_1)]).
test(input_problem_positive_crisp_unsure) :-
    swiss_fadp_art24_breach_notification_profile_for(crisp_unsure, Profile),
    swiss_controller_report_to_commissioner(Profile, input_problems([wrong_type(commissioner_requested_information_of_data_subject)]), []).
test(input_problem_near_miss_is_well_formed) :-
    swiss_fadp_art24_breach_notification_profile_for(crisp_true_control, Profile),
    swiss_fadp_art24_breach_notification_input_problems(Profile, []).

test(controller_required_near_miss_high_risk_false, fail) :-
    swiss_fadp_art24_breach_notification_profile_for(high_risk_false_control, Profile),
    swiss_controller_report_to_commissioner(Profile, authority_notification_required, _).
test(controller_no_breach_near_miss_breach_true, fail) :-
    swiss_fadp_art24_breach_notification_profile_for(all_duties_owed, Profile),
    swiss_controller_report_to_commissioner(Profile, authority_notification_not_required, _).
test(controller_indeterminate_near_miss_key_present, fail) :-
    swiss_fadp_art24_breach_notification_profile_for(all_duties_owed, Profile),
    swiss_controller_report_to_commissioner(Profile, indeterminate(_), _).
test(controller_review_near_miss_other_key_absent, fail) :-
    swiss_fadp_art24_breach_notification_profile_for(breach_unsure_high_risk_absent, Profile),
    swiss_controller_report_to_commissioner(Profile, needs_legal_review(_, _), _).
test(processor_required_near_miss_no_breach, fail) :-
    swiss_fadp_art24_breach_notification_profile_for(no_breach, Profile),
    swiss_processor_report_to_controller(Profile, report_to_controller_required, _).
test(information_exception_near_miss_announcement_false, fail) :-
    swiss_fadp_art24_breach_notification_profile_for(public_announcement_false_control, Profile),
    swiss_information_of_data_subject(Profile, information_of_data_subject_may_be_restricted_deferred_or_omitted, _).
test(information_request_near_miss_no_exception, fail) :-
    swiss_fadp_art24_breach_notification_profile_for(commissioner_request_only, Profile),
    swiss_information_of_data_subject(Profile, information_of_data_subject_may_be_restricted_deferred_or_omitted, _).
test(information_ground_failed_near_miss_request_true, fail) :-
    swiss_fadp_art24_breach_notification_profile_for(commissioner_request_only, Profile),
    swiss_information_of_data_subject(Profile, information_of_data_subject_not_required, _).
test(information_review_near_miss_request_met, fail) :-
    swiss_fadp_art24_breach_notification_profile_for(necessity_unsure_request_met, Profile),
    swiss_information_of_data_subject(Profile, needs_legal_review(_, _), _).
test(eu_required_near_miss_risk_unlikely, fail) :-
    swiss_fadp_art24_breach_notification_profile_for(both_risk_judgements_true, Profile),
    eu_controller_notification_to_supervisory_authority(Profile, authority_notification_required, _).
test(eu_review_near_miss_breach_true, fail) :-
    swiss_fadp_art24_breach_notification_profile_for(all_duties_owed, Profile),
    eu_controller_notification_to_supervisory_authority(Profile, needs_legal_review(_, _), _).
test(comparison_same_near_miss_high_risk_false, fail) :-
    swiss_fadp_art24_breach_notification_profile_for(high_risk_false_control, Profile),
    compare_swiss_eu_authority_notification(Profile, _, _, same, _).
test(input_problem_near_miss_crisp_true, fail) :-
    swiss_fadp_art24_breach_notification_profile_for(crisp_true_control, Profile),
    swiss_controller_report_to_commissioner(Profile, input_problems(_), _).

cp_test_names([the_status_table_holds_both_controller_atoms, controller_required_positive, controller_near_miss_gets_not_required, controller_no_breach_positive, controller_indeterminate_positive, controller_review_positive, controller_review_near_miss_gets_indeterminate, processor_required_positive, processor_near_miss_gets_not_required, information_exception_positive, information_exception_near_miss_gets_required, information_request_with_exception_positive, information_request_near_miss_gets_required, information_ground_failed_positive, information_review_positive, information_review_near_miss_gets_required, eu_required_positive, eu_near_miss_gets_not_required, eu_review_positive, comparison_same_positive, comparison_near_miss_gets_differs, input_problem_positive_crisp_unsure, input_problem_near_miss_is_well_formed]).
cp_test_fail_names([controller_required_near_miss_high_risk_false, controller_no_breach_near_miss_breach_true, controller_indeterminate_near_miss_key_present, controller_review_near_miss_other_key_absent, processor_required_near_miss_no_breach, information_exception_near_miss_announcement_false, information_request_near_miss_no_exception, information_ground_failed_near_miss_request_true, information_review_near_miss_request_met, eu_required_near_miss_risk_unlikely, eu_review_near_miss_breach_true, comparison_same_near_miss_high_risk_false, input_problem_near_miss_crisp_true]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
