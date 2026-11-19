% SPDX-License-Identifier: EUPL-1.2
:- module(m__uk_uk_complaints_to_the_commissioner_tests_test_input_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__uk_uk_complaints_to_the_commissioner_uk_complaints_to_the_commissioner, [controller_complaint_right/3, commission_complaint_right/3, acknowledgement_last_day/3, uk_complaints_to_the_commissioner_status/2]).
:- use_module(m__uk_uk_complaints_to_the_commissioner_kernel, [uk_complaints_to_the_commissioner_input_problems/2]).
:- use_module(m__uk_uk_complaints_to_the_commissioner_fixtures, [uk_complaints_to_the_commissioner_profile_for/2]).

test(controller_positive_with_result_bound) :-
    uk_complaints_to_the_commissioner_profile_for(gdpr_complaint_to_controller, Profile),
    controller_complaint_right(Profile, complaint_under_section_164a, [cite(uk_dpa_2018_s_164a_1)]).
test(controller_negative_with_result_bound) :-
    uk_complaints_to_the_commissioner_profile_for(complaint_to_processor, Profile),
    controller_complaint_right(Profile, not_a_complaint_under_section_164a, [cite(uk_dpa_2018_s_164a_1)]).
test(controller_indeterminate_with_result_bound) :-
    uk_complaints_to_the_commissioner_profile_for(recipient_not_stated, Profile),
    controller_complaint_right(Profile, indeterminate([complaint_made_to_the_controller]), []).
test(commission_positive_with_result_bound) :-
    uk_complaints_to_the_commissioner_profile_for(part_4_complaint_to_controller, Profile),
    commission_complaint_right(Profile, complaint_under_section_165_2, [cite(uk_dpa_2018_s_165_2)]).
test(commission_negative_with_result_bound) :-
    uk_complaints_to_the_commissioner_profile_for(third_party_complaint, Profile),
    commission_complaint_right(Profile, not_a_complaint_under_section_165_2, [cite(uk_dpa_2018_s_165_2)]).
test(acknowledgement_date_with_result_bound) :-
    acknowledgement_last_day(date(2026, 6, 19), date(2026, 7, 18), [cite(uk_dpa_2018_s_164a_3), cite(uk_si_2026_82_reg_3), cite(uk_si_2026_82_reg_3_a), cite(uk_si_2026_82_reg_7)]).
test(acknowledgement_not_applying_with_result_bound) :-
    acknowledgement_last_day(date(2026, 6, 18), acknowledgement_duty_does_not_apply, [cite(uk_si_2026_82_reg_3), cite(uk_si_2026_82_reg_3_a), cite(uk_si_2026_82_reg_7)]).
test(status_with_result_bound) :-
    uk_complaints_to_the_commissioner_profile_for(part_3_complaint_to_controller, Profile),
    uk_complaints_to_the_commissioner_status(Profile, complaint_under_section_164a).
test(attribute_order_does_not_matter) :-
    controller_complaint_right([attribute(complaint_made_to_the_controller, true), attribute(infringement_considered, uk_gdpr), attribute(complaint_by_data_subject_about_own_personal_data, true)], complaint_under_section_164a, [cite(uk_dpa_2018_s_164a_1)]).
test(a_string_value_is_wrong_type) :-
    findall(Result - Citations, controller_complaint_right([attribute(complaint_made_to_the_controller, "true")], Result, Citations), Answers),
    Answers == [input_problems([wrong_type(complaint_made_to_the_controller)]) - []].
test(an_unbound_value_is_wrong_type) :-
    findall(Problems, uk_complaints_to_the_commissioner_input_problems([attribute(infringement_considered, _)], Problems), Answers),
    Answers == [[wrong_type(infringement_considered)]].
test(a_number_key_is_unknown) :-
    uk_complaints_to_the_commissioner_input_problems([attribute(42, true)], [unknown_key(42)]).
test(a_compound_key_is_unknown_as_given) :-
    findall(Problems, uk_complaints_to_the_commissioner_input_problems([attribute(infringement(considered), true)], Problems), Answers),
    Answers == [[unknown_key(infringement(considered))]].
test(an_unbound_profile_is_not_an_attribute_list) :-
    findall(Problems, uk_complaints_to_the_commissioner_input_problems(_, Problems), Answers),
    Answers == [[wrong_type(profile)]].
test(a_partial_list_is_not_an_attribute_list) :-
    findall(Problems, uk_complaints_to_the_commissioner_input_problems([attribute(infringement_considered, uk_gdpr)|_], Problems), Answers),
    Answers == [[wrong_type(profile)]].
test(a_foreign_element_is_not_an_attribute_list) :-
    commission_complaint_right([attribute(infringement_considered, uk_gdpr), uk_gdpr], input_problems([wrong_type(profile)]), []).
test(an_unknown_key_repeated_is_named_once) :-
    uk_complaints_to_the_commissioner_input_problems([attribute(colour, red), attribute(colour, blue)], [unknown_key(colour)]).
test(duplicate_values_are_not_read) :-
    uk_complaints_to_the_commissioner_input_problems([attribute(complaint_made_to_the_controller, true), attribute(complaint_made_to_the_controller, maybe)], [duplicate_key(complaint_made_to_the_controller)]).
test(an_absent_key_is_not_a_problem) :-
    uk_complaints_to_the_commissioner_input_problems([], []).
test(a_present_unread_key_is_still_checked) :-
    commission_complaint_right([attribute(complaint_by_data_subject_about_own_personal_data, true), attribute(infringement_considered, uk_gdpr), attribute(complaint_made_to_the_controller, perhaps)], input_problems([wrong_type(complaint_made_to_the_controller)]), []).
test(a_float_year_is_wrong_type) :-
    acknowledgement_last_day(date(2026.0, 6, 19), input_problems([wrong_type(receipt_date)]), []).
test(a_month_outside_the_year_is_wrong_type) :-
    acknowledgement_last_day(date(2026, 13, 1), input_problems([wrong_type(receipt_date)]), []).
test(day_zero_is_wrong_type) :-
    acknowledgement_last_day(date(2026, 7, 0), input_problems([wrong_type(receipt_date)]), []).
test(a_year_below_the_range_is_wrong_type) :-
    acknowledgement_last_day(date(1899, 12, 31), input_problems([wrong_type(receipt_date)]), []).
test(the_first_year_of_the_range_is_valid) :-
    acknowledgement_last_day(date(1900, 1, 1), acknowledgement_duty_does_not_apply, _).
test(a_partly_unbound_date_is_wrong_type) :-
    findall(LastDay, acknowledgement_last_day(date(2026, _, 19), LastDay, _), Answers),
    Answers == [input_problems([wrong_type(receipt_date)])].
test(a_date_of_wrong_arity_is_wrong_type) :-
    acknowledgement_last_day(date(2026, 6), input_problems([wrong_type(receipt_date)]), []).

test(controller_positive_rejects_the_negative_result, fail) :-
    uk_complaints_to_the_commissioner_profile_for(gdpr_complaint_to_controller, Profile),
    controller_complaint_right(Profile, not_a_complaint_under_section_164a, _).
test(controller_negative_rejects_the_positive_result, fail) :-
    uk_complaints_to_the_commissioner_profile_for(complaint_to_processor, Profile),
    controller_complaint_right(Profile, complaint_under_section_164a, _).
test(controller_indeterminate_names_no_other_key, fail) :-
    uk_complaints_to_the_commissioner_profile_for(recipient_not_stated, Profile),
    controller_complaint_right(Profile, indeterminate([infringement_considered]), _).
test(commission_negative_rejects_the_positive_result, fail) :-
    uk_complaints_to_the_commissioner_profile_for(third_party_complaint, Profile),
    commission_complaint_right(Profile, complaint_under_section_165_2, _).
test(acknowledgement_wrong_bound_date_is_rejected, fail) :-
    acknowledgement_last_day(date(2026, 6, 19), date(2026, 7, 19), _).

cp_test_names([controller_positive_with_result_bound, controller_negative_with_result_bound, controller_indeterminate_with_result_bound, commission_positive_with_result_bound, commission_negative_with_result_bound, acknowledgement_date_with_result_bound, acknowledgement_not_applying_with_result_bound, status_with_result_bound, attribute_order_does_not_matter, a_string_value_is_wrong_type, an_unbound_value_is_wrong_type, a_number_key_is_unknown, a_compound_key_is_unknown_as_given, an_unbound_profile_is_not_an_attribute_list, a_partial_list_is_not_an_attribute_list, a_foreign_element_is_not_an_attribute_list, an_unknown_key_repeated_is_named_once, duplicate_values_are_not_read, an_absent_key_is_not_a_problem, a_present_unread_key_is_still_checked, a_float_year_is_wrong_type, a_month_outside_the_year_is_wrong_type, day_zero_is_wrong_type, a_year_below_the_range_is_wrong_type, the_first_year_of_the_range_is_valid, a_partly_unbound_date_is_wrong_type, a_date_of_wrong_arity_is_wrong_type]).
cp_test_fail_names([controller_positive_rejects_the_negative_result, controller_negative_rejects_the_positive_result, controller_indeterminate_names_no_other_key, commission_negative_rejects_the_positive_result, acknowledgement_wrong_bound_date_is_rejected]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
