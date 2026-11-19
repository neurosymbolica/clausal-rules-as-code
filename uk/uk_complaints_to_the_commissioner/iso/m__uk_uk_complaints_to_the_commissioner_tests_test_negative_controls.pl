% SPDX-License-Identifier: EUPL-1.2
:- module(m__uk_uk_complaints_to_the_commissioner_tests_test_negative_controls, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__uk_uk_complaints_to_the_commissioner_uk_complaints_to_the_commissioner, [controller_complaint_right/3, commission_complaint_right/3, acknowledgement_last_day/3, uk_complaints_to_the_commissioner_status_values/1]).
:- use_module(m__uk_uk_complaints_to_the_commissioner_fixtures, [uk_complaints_to_the_commissioner_profile_for/2]).

test(the_status_table_holds_both_atoms) :-
    uk_complaints_to_the_commissioner_status_values(StatusValues),
    StatusValues == [complaint_under_section_164a, not_a_complaint_under_section_164a].
test(controller_uk_gdpr_is_a_complaint) :-
    uk_complaints_to_the_commissioner_profile_for(gdpr_complaint_to_controller, Profile),
    controller_complaint_right(Profile, complaint_under_section_164a, _).
test(controller_part_4_is_not_a_complaint) :-
    uk_complaints_to_the_commissioner_profile_for(part_4_complaint_to_controller, Profile),
    controller_complaint_right(Profile, not_a_complaint_under_section_164a, _).
test(controller_part_3_is_a_complaint) :-
    uk_complaints_to_the_commissioner_profile_for(part_3_complaint_to_controller, Profile),
    controller_complaint_right(Profile, complaint_under_section_164a, _).
test(controller_to_processor_is_not_a_complaint) :-
    uk_complaints_to_the_commissioner_profile_for(complaint_to_processor, Profile),
    controller_complaint_right(Profile, not_a_complaint_under_section_164a, _).
test(controller_third_party_is_not_a_complaint) :-
    uk_complaints_to_the_commissioner_profile_for(third_party_complaint, Profile),
    controller_complaint_right(Profile, not_a_complaint_under_section_164a, _).
test(controller_no_infringement_is_not_a_complaint) :-
    uk_complaints_to_the_commissioner_profile_for(no_infringement_considered, Profile),
    controller_complaint_right(Profile, not_a_complaint_under_section_164a, _).
test(controller_recipient_missing_is_indeterminate) :-
    uk_complaints_to_the_commissioner_profile_for(recipient_not_stated, Profile),
    controller_complaint_right(Profile, indeterminate([complaint_made_to_the_controller]), []).
test(controller_recipient_given_is_final) :-
    controller_complaint_right([attribute(complaint_by_data_subject_about_own_personal_data, true), attribute(infringement_considered, uk_gdpr), attribute(complaint_made_to_the_controller, true)], complaint_under_section_164a, _).
test(commission_part_4_is_a_complaint) :-
    uk_complaints_to_the_commissioner_profile_for(part_4_complaint_to_controller, Profile),
    commission_complaint_right(Profile, complaint_under_section_165_2, _).
test(commission_none_is_not_a_complaint) :-
    uk_complaints_to_the_commissioner_profile_for(no_infringement_considered, Profile),
    commission_complaint_right(Profile, not_a_complaint_under_section_165_2, _).
test(commission_third_party_is_not_a_complaint) :-
    uk_complaints_to_the_commissioner_profile_for(third_party_complaint, Profile),
    commission_complaint_right(Profile, not_a_complaint_under_section_165_2, _).
test(commission_to_processor_is_a_complaint) :-
    uk_complaints_to_the_commissioner_profile_for(complaint_to_processor, Profile),
    commission_complaint_right(Profile, complaint_under_section_165_2, _).
test(acknowledgement_on_commencement_gives_a_date) :-
    acknowledgement_last_day(date(2026, 6, 19), date(2026, 7, 18), _).
test(acknowledgement_before_commencement_duty_does_not_apply) :-
    acknowledgement_last_day(date(2026, 6, 18), acknowledgement_duty_does_not_apply, _).
test(acknowledgement_counts_the_day_of_receipt) :-
    acknowledgement_last_day(date(2026, 10, 1), date(2026, 10, 30), _).
test(acknowledgement_leap_day_is_valid) :-
    acknowledgement_last_day(date(2028, 2, 29), date(2028, 3, 29), _).
test(acknowledgement_common_year_february_29_is_a_problem) :-
    acknowledgement_last_day(date(2027, 2, 29), input_problems([wrong_type(receipt_date)]), []).
test(acknowledgement_last_year_of_range_is_valid) :-
    acknowledgement_last_day(date(2199, 1, 1), date(2199, 1, 30), _).
test(acknowledgement_year_past_range_is_a_problem) :-
    acknowledgement_last_day(date(2200, 1, 1), input_problems([wrong_type(receipt_date)]), []).
test(badly_typed_profile_gives_input_problems) :-
    uk_complaints_to_the_commissioner_profile_for(badly_typed_profile, Profile),
    controller_complaint_right(Profile, input_problems([wrong_type(infringement_considered), unknown_key(colour)]), []).
test(corrected_profile_gives_a_verdict) :-
    controller_complaint_right([attribute(infringement_considered, dpa_2018_part_4)], not_a_complaint_under_section_164a, _).

test(controller_part_4_near_miss_is_not_positive, fail) :-
    uk_complaints_to_the_commissioner_profile_for(part_4_complaint_to_controller, Profile),
    controller_complaint_right(Profile, complaint_under_section_164a, _).
test(controller_part_3_is_not_negative, fail) :-
    uk_complaints_to_the_commissioner_profile_for(part_3_complaint_to_controller, Profile),
    controller_complaint_right(Profile, not_a_complaint_under_section_164a, _).
test(controller_to_processor_near_miss_is_not_positive, fail) :-
    uk_complaints_to_the_commissioner_profile_for(complaint_to_processor, Profile),
    controller_complaint_right(Profile, complaint_under_section_164a, _).
test(controller_third_party_near_miss_is_not_positive, fail) :-
    uk_complaints_to_the_commissioner_profile_for(third_party_complaint, Profile),
    controller_complaint_right(Profile, complaint_under_section_164a, _).
test(controller_no_infringement_near_miss_is_not_positive, fail) :-
    uk_complaints_to_the_commissioner_profile_for(no_infringement_considered, Profile),
    controller_complaint_right(Profile, complaint_under_section_164a, _).
test(controller_recipient_given_is_not_indeterminate, fail) :-
    controller_complaint_right([attribute(complaint_by_data_subject_about_own_personal_data, true), attribute(infringement_considered, uk_gdpr), attribute(complaint_made_to_the_controller, true)], indeterminate(_), _).
test(controller_deciding_false_is_not_indeterminate, fail) :-
    controller_complaint_right([attribute(complaint_by_data_subject_about_own_personal_data, true), attribute(infringement_considered, dpa_2018_part_4)], indeterminate(_), _).
test(commission_none_near_miss_is_not_positive, fail) :-
    uk_complaints_to_the_commissioner_profile_for(no_infringement_considered, Profile),
    commission_complaint_right(Profile, complaint_under_section_165_2, _).
test(commission_part_4_is_not_negative, fail) :-
    uk_complaints_to_the_commissioner_profile_for(part_4_complaint_to_controller, Profile),
    commission_complaint_right(Profile, not_a_complaint_under_section_165_2, _).
test(commission_third_party_near_miss_is_not_positive, fail) :-
    uk_complaints_to_the_commissioner_profile_for(third_party_complaint, Profile),
    commission_complaint_right(Profile, complaint_under_section_165_2, _).
test(commission_to_processor_is_not_negative, fail) :-
    uk_complaints_to_the_commissioner_profile_for(complaint_to_processor, Profile),
    commission_complaint_right(Profile, not_a_complaint_under_section_165_2, _).
test(acknowledgement_on_commencement_duty_applies, fail) :-
    acknowledgement_last_day(date(2026, 6, 19), acknowledgement_duty_does_not_apply, _).
test(acknowledgement_before_commencement_gives_no_date, fail) :-
    acknowledgement_last_day(date(2026, 6, 18), date(_, _, _), _).
test(acknowledgement_does_not_count_from_the_next_day, fail) :-
    acknowledgement_last_day(date(2026, 10, 1), date(2026, 10, 31), _).
test(acknowledgement_leap_day_is_not_a_problem, fail) :-
    acknowledgement_last_day(date(2028, 2, 29), input_problems(_), _).
test(corrected_profile_has_no_input_problems, fail) :-
    controller_complaint_right([attribute(infringement_considered, dpa_2018_part_4)], input_problems(_), _).

cp_test_names([the_status_table_holds_both_atoms, controller_uk_gdpr_is_a_complaint, controller_part_4_is_not_a_complaint, controller_part_3_is_a_complaint, controller_to_processor_is_not_a_complaint, controller_third_party_is_not_a_complaint, controller_no_infringement_is_not_a_complaint, controller_recipient_missing_is_indeterminate, controller_recipient_given_is_final, commission_part_4_is_a_complaint, commission_none_is_not_a_complaint, commission_third_party_is_not_a_complaint, commission_to_processor_is_a_complaint, acknowledgement_on_commencement_gives_a_date, acknowledgement_before_commencement_duty_does_not_apply, acknowledgement_counts_the_day_of_receipt, acknowledgement_leap_day_is_valid, acknowledgement_common_year_february_29_is_a_problem, acknowledgement_last_year_of_range_is_valid, acknowledgement_year_past_range_is_a_problem, badly_typed_profile_gives_input_problems, corrected_profile_gives_a_verdict]).
cp_test_fail_names([controller_part_4_near_miss_is_not_positive, controller_part_3_is_not_negative, controller_to_processor_near_miss_is_not_positive, controller_third_party_near_miss_is_not_positive, controller_no_infringement_near_miss_is_not_positive, controller_recipient_given_is_not_indeterminate, controller_deciding_false_is_not_indeterminate, commission_none_near_miss_is_not_positive, commission_part_4_is_not_negative, commission_third_party_near_miss_is_not_positive, commission_to_processor_is_not_negative, acknowledgement_on_commencement_duty_applies, acknowledgement_before_commencement_gives_no_date, acknowledgement_does_not_count_from_the_next_day, acknowledgement_leap_day_is_not_a_problem, corrected_profile_has_no_input_problems]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
