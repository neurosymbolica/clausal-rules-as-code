% SPDX-License-Identifier: EUPL-1.2
:- module(m__ch_swiss_fadp_art24_breach_notification_tests_test_input_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__ch_swiss_fadp_art24_breach_notification_swiss_fadp_art24_breach_notification, [swiss_fadp_art24_breach_notification_status/2, swiss_controller_report_to_commissioner/3, swiss_processor_report_to_controller/3, swiss_information_of_data_subject/3, eu_controller_notification_to_supervisory_authority/3, compare_swiss_eu_authority_notification/5]).
:- use_module(m__ch_swiss_fadp_art24_breach_notification_kernel, [swiss_fadp_art24_breach_notification_input_problems/2]).
:- use_module(m__ch_swiss_fadp_art24_breach_notification_fixtures, [swiss_fadp_art24_breach_notification_profile_for/2]).

test(controller_required_with_answer_bound) :-
    swiss_fadp_art24_breach_notification_profile_for(high_risk_breach_all_duties, Profile),
    swiss_controller_report_to_commissioner(Profile, authority_notification_required, [cite(ch_fadp_art_5_h), cite(ch_fadp_art_24_1)]).
test(processor_not_required_with_answer_bound) :-
    swiss_fadp_art24_breach_notification_profile_for(no_breach, Profile),
    swiss_processor_report_to_controller(Profile, report_to_controller_not_required, [cite(ch_fadp_art_5_h), cite(ch_fadp_art_24_3)]).
test(information_may_be_restricted_with_answer_bound) :-
    swiss_fadp_art24_breach_notification_profile_for(information_commissioner_request_with_public_announcement, Profile),
    swiss_information_of_data_subject(Profile, information_of_data_subject_may_be_restricted_deferred_or_omitted, [cite(ch_fadp_art_5_h), cite(ch_fadp_art_24_4), cite(ch_fadp_art_24_5)]).
test(eu_not_required_with_answer_bound) :-
    swiss_fadp_art24_breach_notification_profile_for(eu_unlikely_risk_settles_absent_breach, Profile),
    eu_controller_notification_to_supervisory_authority(Profile, authority_notification_not_required, [cite(eu_reg_2016_679_art_33_1)]).
test(comparison_differs_with_answers_bound) :-
    swiss_fadp_art24_breach_notification_profile_for(swiss_and_eu_both_true_thresholds, Profile),
    compare_swiss_eu_authority_notification(Profile, authority_notification_required, authority_notification_not_required, differs, [cite(ch_fadp_art_24_1), cite(eu_reg_2016_679_art_33_1)]).
test(missing_key_with_answer_bound) :-
    swiss_fadp_art24_breach_notification_profile_for(breach_only, Profile),
    swiss_controller_report_to_commissioner(Profile, indeterminate([breach_likely_to_lead_to_high_risk_to_personality_or_fundamental_rights]), []).
test(referral_with_answer_bound) :-
    swiss_fadp_art24_breach_notification_profile_for(controller_unsure_breach, Profile),
    swiss_controller_report_to_commissioner(Profile, needs_legal_review(open_textured(breach_of_data_security, cite(ch_fadp_art_5_h)), [inputs_relied_on([breach_of_data_security - unsure, breach_likely_to_lead_to_high_risk_to_personality_or_fundamental_rights - true])]), []).
test(status_with_answer_bound) :-
    swiss_fadp_art24_breach_notification_profile_for(high_risk_breach_all_duties, Profile),
    swiss_fadp_art24_breach_notification_status(Profile, authority_notification_required).
test(input_check_with_problems_bound) :-
    swiss_fadp_art24_breach_notification_profile_for(duplicate_and_unknown_keys, Profile),
    swiss_fadp_art24_breach_notification_input_problems(Profile, [duplicate_key(breach_of_data_security), unknown_key(colour)]).
test(key_order_in_the_profile_does_not_matter) :-
    findall(Result, swiss_controller_report_to_commissioner([attribute(breach_likely_to_lead_to_high_risk_to_personality_or_fundamental_rights, true), attribute(breach_of_data_security, true)], Result, _), Results),
    Results == [authority_notification_required].
test(an_unbound_profile_is_wrong_type) :-
    findall(Problems, swiss_fadp_art24_breach_notification_input_problems(_, Problems), ProblemLists),
    ProblemLists == [[wrong_type(profile)]].
test(a_partial_list_is_wrong_type) :-
    findall(Problems, swiss_fadp_art24_breach_notification_input_problems([attribute(breach_of_data_security, true)|_], Problems), ProblemLists),
    ProblemLists == [[wrong_type(profile)]].
test(an_unbound_value_is_wrong_type) :-
    findall(Problems, swiss_fadp_art24_breach_notification_input_problems([attribute(breach_of_data_security, _)], Problems), ProblemLists),
    ProblemLists == [[wrong_type(breach_of_data_security)]].
test(a_number_key_is_unknown) :-
    findall(Problems, swiss_fadp_art24_breach_notification_input_problems([attribute(42, true)], Problems), ProblemLists),
    ProblemLists == [[unknown_key(42)]].
test(a_non_attribute_element_is_wrong_type) :-
    findall(Problems, swiss_fadp_art24_breach_notification_input_problems([breach_of_data_security - true], Problems), ProblemLists),
    ProblemLists == [[wrong_type(profile)]].
test(an_empty_profile_has_no_problem) :-
    swiss_fadp_art24_breach_notification_input_problems([], []).

test(controller_required_rejects_bound_not_required, fail) :-
    swiss_fadp_art24_breach_notification_profile_for(high_risk_breach_all_duties, Profile),
    swiss_controller_report_to_commissioner(Profile, authority_notification_not_required, _).
test(processor_not_required_rejects_bound_required, fail) :-
    swiss_fadp_art24_breach_notification_profile_for(no_breach, Profile),
    swiss_processor_report_to_controller(Profile, report_to_controller_required, _).
test(information_may_be_restricted_rejects_bound_required, fail) :-
    swiss_fadp_art24_breach_notification_profile_for(information_commissioner_request_with_public_announcement, Profile),
    swiss_information_of_data_subject(Profile, information_of_data_subject_required, _).
test(eu_not_required_rejects_bound_required, fail) :-
    swiss_fadp_art24_breach_notification_profile_for(eu_unlikely_risk_settles_absent_breach, Profile),
    eu_controller_notification_to_supervisory_authority(Profile, authority_notification_required, _).
test(comparison_differs_rejects_bound_same, fail) :-
    swiss_fadp_art24_breach_notification_profile_for(swiss_and_eu_both_true_thresholds, Profile),
    compare_swiss_eu_authority_notification(Profile, _, _, same, _).
test(missing_key_rejects_a_present_key, fail) :-
    swiss_fadp_art24_breach_notification_profile_for(breach_only, Profile),
    swiss_controller_report_to_commissioner(Profile, indeterminate([breach_of_data_security]), _).
test(referral_rejects_a_wrong_citation, fail) :-
    swiss_fadp_art24_breach_notification_profile_for(controller_unsure_breach, Profile),
    swiss_controller_report_to_commissioner(Profile, needs_legal_review(open_textured(breach_of_data_security, cite(ch_fadp_art_24_1)), _), _).
test(input_check_rejects_problems_out_of_order, fail) :-
    swiss_fadp_art24_breach_notification_profile_for(duplicate_and_unknown_keys, Profile),
    swiss_fadp_art24_breach_notification_input_problems(Profile, [unknown_key(colour), duplicate_key(breach_of_data_security)]).

cp_test_names([controller_required_with_answer_bound, processor_not_required_with_answer_bound, information_may_be_restricted_with_answer_bound, eu_not_required_with_answer_bound, comparison_differs_with_answers_bound, missing_key_with_answer_bound, referral_with_answer_bound, status_with_answer_bound, input_check_with_problems_bound, key_order_in_the_profile_does_not_matter, an_unbound_profile_is_wrong_type, a_partial_list_is_wrong_type, an_unbound_value_is_wrong_type, a_number_key_is_unknown, a_non_attribute_element_is_wrong_type, an_empty_profile_has_no_problem]).
cp_test_fail_names([controller_required_rejects_bound_not_required, processor_not_required_rejects_bound_required, information_may_be_restricted_rejects_bound_required, eu_not_required_rejects_bound_required, comparison_differs_rejects_bound_same, missing_key_rejects_a_present_key, referral_rejects_a_wrong_citation, input_check_rejects_problems_out_of_order]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
