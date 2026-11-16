% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_information_duties_timing_tests_test_negative_controls, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_information_duties_timing_information_deadline_basis, [information_deadline/2, information_deadline_basis/2, information_deadline_basis_status_values/1]).
:- use_module(m__eu_data_protection_gdpr_information_duties_timing_information_timing_verdict, [information_timing_verdict/3, information_timing_verdict_status_values/1]).
:- use_module(m__eu_data_protection_gdpr_information_duties_timing_fixtures, [gdpr_information_duties_timing_profile_for/2]).

test(timely_and_late_are_real_verdict_atoms) :-
    information_timing_verdict_status_values(StatusValues),
    member(timely, StatusValues),
    member(late, StatusValues).
test(the_basis_atoms_are_real_basis_atoms) :-
    information_deadline_basis_status_values(StatusValues),
    member(art14_3_a, StatusValues),
    member(art14_3_b, StatusValues).
test(art13_on_the_obtaining_day_is_timely) :-
    gdpr_information_duties_timing_profile_for(art13_provided_on_obtaining_day, Profile),
    information_timing_verdict(Profile, timely, [cite(eu_reg_2016_679_art_13_1)]).
test(art13_the_day_after_is_late) :-
    gdpr_information_duties_timing_profile_for(art13_provided_day_after_obtaining, Profile),
    information_timing_verdict(Profile, late, [cite(eu_reg_2016_679_art_13_1)]).
test(art14_a_on_the_last_day_is_timely) :-
    gdpr_information_duties_timing_profile_for(art14_one_month_last_day, Profile),
    information_timing_verdict(Profile, timely, [cite(eu_reg_2016_679_art_14_3_a)]).
test(art14_a_the_day_after_is_late) :-
    gdpr_information_duties_timing_profile_for(art14_one_month_day_after, Profile),
    information_timing_verdict(Profile, late, [cite(eu_reg_2016_679_art_14_3_a)]).
test(art14_holiday_attested_moves_the_deadline_so_timely) :-
    gdpr_information_duties_timing_profile_for(art14_holiday_shift_last_day, Profile),
    information_timing_verdict(Profile, timely, [cite(eu_reg_2016_679_art_14_3_a)]).
test(art14_holiday_not_attested_leaves_the_monday_so_late) :-
    information_timing_verdict([attribute(personal_data_collected_from_data_subject, false), attribute(obtaining_date, date(2026, 12, 31)), attribute(provision_date, date(2027, 2, 2)), attribute(data_used_for_communication_with_data_subject, false), attribute(disclosure_to_another_recipient_envisaged, false), attribute(provided_within_reasonable_period, true)], late, [cite(eu_reg_2016_679_art_14_3_a)]).
test(art14_holiday_not_attested_gives_the_monday) :-
    information_deadline([attribute(personal_data_collected_from_data_subject, false), attribute(obtaining_date, date(2026, 12, 31)), attribute(data_used_for_communication_with_data_subject, false), attribute(disclosure_to_another_recipient_envisaged, false)], date(2027, 2, 1)).
test(art14_b_on_the_first_communication_is_timely) :-
    gdpr_information_duties_timing_profile_for(art14_first_communication_on_day, Profile),
    information_timing_verdict(Profile, timely, [cite(eu_reg_2016_679_art_14_3_b)]).
test(art14_b_the_day_after_is_late) :-
    gdpr_information_duties_timing_profile_for(art14_first_communication_day_after, Profile),
    information_timing_verdict(Profile, late, [cite(eu_reg_2016_679_art_14_3_b)]).
test(art14_c_on_the_first_disclosure_is_timely) :-
    gdpr_information_duties_timing_profile_for(art14_first_disclosure_on_day, Profile),
    information_timing_verdict(Profile, timely, [cite(eu_reg_2016_679_art_14_3_c)]).
test(art14_c_the_day_after_is_late) :-
    gdpr_information_duties_timing_profile_for(art14_first_disclosure_day_after, Profile),
    information_timing_verdict(Profile, late, [cite(eu_reg_2016_679_art_14_3_c)]).
test(a_tie_is_limb_a) :-
    gdpr_information_duties_timing_profile_for(art14_tie_with_communication_last_day, Profile),
    information_deadline_basis(Profile, art14_3_a).
test(a_communication_three_days_earlier_is_limb_b) :-
    information_deadline_basis([attribute(personal_data_collected_from_data_subject, false), attribute(obtaining_date, date(2026, 1, 15)), attribute(data_used_for_communication_with_data_subject, true), attribute(first_communication_date, date(2026, 2, 13)), attribute(disclosure_to_another_recipient_envisaged, false)], art14_3_b).
test(a_reasonable_period_true_is_timely) :-
    gdpr_information_duties_timing_profile_for(art14_one_month_last_day, Profile),
    information_timing_verdict(Profile, timely, _).
test(a_reasonable_period_false_is_late) :-
    gdpr_information_duties_timing_profile_for(art14_reasonable_period_false, Profile),
    information_timing_verdict(Profile, late, [cite(eu_reg_2016_679_art_14_3_a)]).
test(the_same_dates_on_the_article_13_route_are_late) :-
    information_timing_verdict([attribute(personal_data_collected_from_data_subject, true), attribute(obtaining_date, date(2026, 1, 15)), attribute(provision_date, date(2026, 2, 16)), attribute(data_used_for_communication_with_data_subject, false), attribute(disclosure_to_another_recipient_envisaged, false), attribute(provided_within_reasonable_period, true)], late, [cite(eu_reg_2016_679_art_13_1)]).

test(art13_the_day_after_is_not_timely, fail) :-
    gdpr_information_duties_timing_profile_for(art13_provided_day_after_obtaining, Profile),
    information_timing_verdict(Profile, timely, _).
test(art14_a_the_day_after_is_not_timely, fail) :-
    gdpr_information_duties_timing_profile_for(art14_one_month_day_after, Profile),
    information_timing_verdict(Profile, timely, _).
test(art14_holiday_not_attested_is_not_timely, fail) :-
    information_timing_verdict([attribute(personal_data_collected_from_data_subject, false), attribute(obtaining_date, date(2026, 12, 31)), attribute(provision_date, date(2027, 2, 2)), attribute(data_used_for_communication_with_data_subject, false), attribute(disclosure_to_another_recipient_envisaged, false), attribute(provided_within_reasonable_period, true)], timely, _).
test(art14_b_the_day_after_is_not_timely, fail) :-
    gdpr_information_duties_timing_profile_for(art14_first_communication_day_after, Profile),
    information_timing_verdict(Profile, timely, _).
test(art14_c_the_day_after_is_not_timely, fail) :-
    gdpr_information_duties_timing_profile_for(art14_first_disclosure_day_after, Profile),
    information_timing_verdict(Profile, timely, _).
test(a_communication_three_days_earlier_is_not_limb_a, fail) :-
    information_deadline_basis([attribute(personal_data_collected_from_data_subject, false), attribute(obtaining_date, date(2026, 1, 15)), attribute(data_used_for_communication_with_data_subject, true), attribute(first_communication_date, date(2026, 2, 13)), attribute(disclosure_to_another_recipient_envisaged, false)], art14_3_a).
test(a_reasonable_period_false_is_not_timely, fail) :-
    gdpr_information_duties_timing_profile_for(art14_reasonable_period_false, Profile),
    information_timing_verdict(Profile, timely, _).
test(the_same_dates_on_the_article_13_route_are_not_timely, fail) :-
    information_timing_verdict([attribute(personal_data_collected_from_data_subject, true), attribute(obtaining_date, date(2026, 1, 15)), attribute(provision_date, date(2026, 2, 16)), attribute(data_used_for_communication_with_data_subject, false), attribute(disclosure_to_another_recipient_envisaged, false), attribute(provided_within_reasonable_period, true)], timely, _).

cp_test_names([timely_and_late_are_real_verdict_atoms, the_basis_atoms_are_real_basis_atoms, art13_on_the_obtaining_day_is_timely, art13_the_day_after_is_late, art14_a_on_the_last_day_is_timely, art14_a_the_day_after_is_late, art14_holiday_attested_moves_the_deadline_so_timely, art14_holiday_not_attested_leaves_the_monday_so_late, art14_holiday_not_attested_gives_the_monday, art14_b_on_the_first_communication_is_timely, art14_b_the_day_after_is_late, art14_c_on_the_first_disclosure_is_timely, art14_c_the_day_after_is_late, a_tie_is_limb_a, a_communication_three_days_earlier_is_limb_b, a_reasonable_period_true_is_timely, a_reasonable_period_false_is_late, the_same_dates_on_the_article_13_route_are_late]).
cp_test_fail_names([art13_the_day_after_is_not_timely, art14_a_the_day_after_is_not_timely, art14_holiday_not_attested_is_not_timely, art14_b_the_day_after_is_not_timely, art14_c_the_day_after_is_not_timely, a_communication_three_days_earlier_is_not_limb_a, a_reasonable_period_false_is_not_timely, the_same_dates_on_the_article_13_route_are_not_timely]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
