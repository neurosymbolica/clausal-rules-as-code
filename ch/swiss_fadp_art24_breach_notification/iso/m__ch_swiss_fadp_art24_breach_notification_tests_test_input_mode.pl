% SPDX-License-Identifier: EUPL-1.2
:- module(m__ch_swiss_fadp_art24_breach_notification_tests_test_input_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__ch_swiss_fadp_art24_breach_notification_swiss_fadp_art24_breach_notification, [swiss_controller_report_to_commissioner/3, swiss_processor_report_to_controller/3, swiss_information_of_data_subject/3, eu_controller_notification_to_supervisory_authority/3, compare_swiss_eu_authority_notification/5, swiss_fadp_art24_breach_notification_status/2, swiss_fadp_art24_breach_notification_status_values/1]).
:- use_module(m__ch_swiss_fadp_art24_breach_notification_kernel, [swiss_fadp_art24_breach_notification_input_problems/2]).
:- use_module(m__ch_swiss_fadp_art24_breach_notification_fixtures, [swiss_fadp_art24_breach_notification_profile_for/2]).

test(status_holds_with_the_verdict_bound) :-
    swiss_fadp_art24_breach_notification_profile_for(all_duties_owed, Profile),
    swiss_fadp_art24_breach_notification_status(Profile, authority_notification_required).
test(every_other_bound_status_is_rejected) :-
    swiss_fadp_art24_breach_notification_profile_for(all_duties_owed, Profile),
    swiss_fadp_art24_breach_notification_status_values(StatusValues),
    findall(Status, (member(Status, StatusValues), swiss_fadp_art24_breach_notification_status(Profile, Status)), HeldStatuses),
    HeldStatuses == [authority_notification_required].
test(controller_report_with_answer_and_citations_bound) :-
    swiss_fadp_art24_breach_notification_profile_for(all_duties_owed, Profile),
    swiss_controller_report_to_commissioner(Profile, authority_notification_required, [cite(ch_fadp_art_5_h), cite(ch_fadp_art_24_1)]).
test(processor_report_with_answer_bound) :-
    swiss_fadp_art24_breach_notification_profile_for(no_breach, Profile),
    swiss_processor_report_to_controller(Profile, report_to_controller_not_required, [cite(ch_fadp_art_5_h), cite(ch_fadp_art_24_3)]).
test(information_with_answer_bound) :-
    swiss_fadp_art24_breach_notification_profile_for(public_announcement_exception, Profile),
    swiss_information_of_data_subject(Profile, information_of_data_subject_may_be_restricted_deferred_or_omitted, [cite(ch_fadp_art_5_h), cite(ch_fadp_art_24_4), cite(ch_fadp_art_24_5)]).
test(eu_notification_with_answer_bound) :-
    swiss_fadp_art24_breach_notification_profile_for(both_risk_judgements_true, Profile),
    eu_controller_notification_to_supervisory_authority(Profile, authority_notification_not_required, [cite(eu_reg_2016_679_art_33_1)]).
test(comparison_with_every_output_bound) :-
    swiss_fadp_art24_breach_notification_profile_for(high_risk_false_control, Profile),
    compare_swiss_eu_authority_notification(Profile, authority_notification_not_required, authority_notification_required, differs, [cite(ch_fadp_art_24_1), cite(eu_reg_2016_679_art_33_1)]).
test(indeterminate_with_answer_bound) :-
    swiss_fadp_art24_breach_notification_profile_for(high_risk_absent, Profile),
    swiss_controller_report_to_commissioner(Profile, indeterminate([breach_likely_to_lead_to_high_risk_to_personality_or_fundamental_rights]), []).
test(referral_with_answer_bound) :-
    swiss_fadp_art24_breach_notification_profile_for(breach_unsure, Profile),
    swiss_controller_report_to_commissioner(Profile, needs_legal_review(open_textured(breach_of_data_security, cite(ch_fadp_art_5_h)), [inputs_relied_on([breach_of_data_security - unsure, breach_likely_to_lead_to_high_risk_to_personality_or_fundamental_rights - true])]), []).
test(an_unbound_profile_is_not_an_attribute_list) :-
    findall(Problems, swiss_fadp_art24_breach_notification_input_problems(_, Problems), Answers),
    Answers == [[wrong_type(profile)]].
test(a_partial_list_is_not_an_attribute_list) :-
    findall(Problems, swiss_fadp_art24_breach_notification_input_problems([attribute(breach_of_data_security, true)|_], Problems), Answers),
    Answers == [[wrong_type(profile)]].
test(a_list_with_a_foreign_element_is_not_an_attribute_list) :-
    swiss_fadp_art24_breach_notification_profile_for(not_attribute_list, Profile),
    swiss_fadp_art24_breach_notification_input_problems(Profile, Problems),
    Problems == [wrong_type(profile)].
test(an_unbound_value_is_wrong_type) :-
    findall(Problems, swiss_fadp_art24_breach_notification_input_problems([attribute(personal_data_breach, _)], Problems), Answers),
    Answers == [[wrong_type(personal_data_breach)]].
test(a_string_value_is_wrong_type) :-
    swiss_fadp_art24_breach_notification_input_problems([attribute(breach_of_data_security, "true")], Problems),
    Problems == [wrong_type(breach_of_data_security)].
test(a_number_key_is_an_unknown_key) :-
    swiss_fadp_art24_breach_notification_input_problems([attribute(42, true)], Problems),
    Problems == [unknown_key(42)].
test(an_unbound_key_is_an_unknown_key_as_given) :-
    swiss_fadp_art24_breach_notification_input_problems([attribute(incident(severity), true)], Problems),
    Problems == [unknown_key(incident(severity))].
test(the_crisp_key_refuses_unsure) :-
    swiss_fadp_art24_breach_notification_profile_for(crisp_unsure, Profile),
    swiss_fadp_art24_breach_notification_input_problems(Profile, Problems),
    Problems == [wrong_type(commissioner_requested_information_of_data_subject)].
test(input_problems_reach_a_three_place_query) :-
    swiss_fadp_art24_breach_notification_profile_for(crisp_unsure, Profile),
    findall(Result - Citations, swiss_information_of_data_subject(Profile, Result, Citations), Answers),
    Answers == [input_problems([wrong_type(commissioner_requested_information_of_data_subject)]) - []].
test(input_problems_reach_the_comparison) :-
    swiss_fadp_art24_breach_notification_profile_for(duplicate_and_unknown, Profile),
    findall(answer(Swiss, Union, Difference, Changed), compare_swiss_eu_authority_notification(Profile, Swiss, Union, Difference, Changed), Answers),
    Answers == [answer(input_problems([duplicate_key(breach_of_data_security), wrong_type(breach_unlikely_to_result_in_risk), unknown_key(severity)]), input_problems([duplicate_key(breach_of_data_security), wrong_type(breach_unlikely_to_result_in_risk), unknown_key(severity)]), not_comparable, [])].

test(controller_report_rejects_the_opposite_bound_answer, fail) :-
    swiss_fadp_art24_breach_notification_profile_for(all_duties_owed, Profile),
    swiss_controller_report_to_commissioner(Profile, authority_notification_not_required, _).
test(information_rejects_required_when_an_exception_holds, fail) :-
    swiss_fadp_art24_breach_notification_profile_for(public_announcement_exception, Profile),
    swiss_information_of_data_subject(Profile, information_of_data_subject_required, _).

cp_test_names([status_holds_with_the_verdict_bound, every_other_bound_status_is_rejected, controller_report_with_answer_and_citations_bound, processor_report_with_answer_bound, information_with_answer_bound, eu_notification_with_answer_bound, comparison_with_every_output_bound, indeterminate_with_answer_bound, referral_with_answer_bound, an_unbound_profile_is_not_an_attribute_list, a_partial_list_is_not_an_attribute_list, a_list_with_a_foreign_element_is_not_an_attribute_list, an_unbound_value_is_wrong_type, a_string_value_is_wrong_type, a_number_key_is_an_unknown_key, an_unbound_key_is_an_unknown_key_as_given, the_crisp_key_refuses_unsure, input_problems_reach_a_three_place_query, input_problems_reach_the_comparison]).
cp_test_fail_names([controller_report_rejects_the_opposite_bound_answer, information_rejects_required_when_an_exception_holds]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
