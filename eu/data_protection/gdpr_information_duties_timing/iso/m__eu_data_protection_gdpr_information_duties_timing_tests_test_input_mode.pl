% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_information_duties_timing_tests_test_input_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_information_duties_timing_information_deadline_basis, [information_deadline_basis_status/2, information_deadline/2, information_deadline_basis/2]).
:- use_module(m__eu_data_protection_gdpr_information_duties_timing_information_timing_verdict, [information_timing_verdict/3]).
:- use_module(m__eu_data_protection_gdpr_information_duties_timing_fixtures, [gdpr_information_duties_timing_profile_for/2]).

test(art13_status_holds_with_the_basis_bound) :-
    gdpr_information_duties_timing_profile_for(art13_provided_on_obtaining_day, Profile),
    information_deadline_basis_status(Profile, art13_1).
test(art13_timely_holds_with_the_verdict_bound) :-
    gdpr_information_duties_timing_profile_for(art13_provided_on_obtaining_day, Profile),
    information_timing_verdict(Profile, timely, [cite(eu_reg_2016_679_art_13_1)]).
test(art14_deadline_holds_with_the_date_bound) :-
    gdpr_information_duties_timing_profile_for(art14_one_month_last_day, Profile),
    information_deadline(Profile, date(2026, 2, 16)).
test(art14_deadline_read_element_wise_as_integers) :-
    gdpr_information_duties_timing_profile_for(art14_holiday_shift_last_day, Profile),
    information_deadline(Profile, date(Year, Month, DayNumber)),
    integer(Year),
    integer(Month),
    integer(DayNumber),
    Year =:= 2027,
    Month =:= 2,
    DayNumber =:= 2.
test(art14_basis_bound_to_limb_b) :-
    gdpr_information_duties_timing_profile_for(art14_first_communication_on_day, Profile),
    information_deadline_basis(Profile, art14_3_b).
test(art14_basis_bound_to_limb_c) :-
    gdpr_information_duties_timing_profile_for(art14_first_disclosure_on_day, Profile),
    information_deadline_basis(Profile, art14_3_c).
test(art14_unsure_judgement_bound_to_its_referral) :-
    gdpr_information_duties_timing_profile_for(art14_reasonable_period_unsure, Profile),
    information_timing_verdict(Profile, needs_legal_review(open_textured(provided_within_reasonable_period, cite(eu_reg_2016_679_art_14_3_a)), [inputs_relied_on([provided_within_reasonable_period - unsure])|_]), []).
test(a_term_that_is_not_a_list_is_wrong_type_profile) :-
    information_timing_verdict(profile, input_problems([wrong_type(profile)]), []).
test(a_number_is_wrong_type_profile_for_the_deadline) :-
    information_deadline(42, input_problems([wrong_type(profile)])).
test(a_list_of_bare_atoms_is_wrong_type_profile) :-
    information_deadline_basis([obtaining_date], input_problems([wrong_type(profile)])).
test(an_unknown_key_is_an_input_problem) :-
    information_deadline([attribute(as_of_date, date(2026, 1, 1))], input_problems([unknown_key(as_of_date)])).
test(a_float_inside_a_date_is_wrong_type) :-
    information_timing_verdict([attribute(personal_data_collected_from_data_subject, true), attribute(obtaining_date, date(2026.0, 3, 10)), attribute(provision_date, date(2026, 3, 10))], input_problems([wrong_type(obtaining_date)]), []).
test(a_crisp_flag_given_yes_is_wrong_type) :-
    information_timing_verdict([attribute(personal_data_collected_from_data_subject, yes)], input_problems([wrong_type(personal_data_collected_from_data_subject)]), []).
test(a_duplicate_key_is_named_once_and_not_typed) :-
    information_deadline_basis([attribute(provision_date, date(2026, 3, 10)), attribute(provision_date, wrong)], input_problems([duplicate_key(provision_date)])).
test(an_outside_fact_given_bare_is_wrong_type) :-
    information_deadline([attribute(public_holidays, [date(2027, 2, 1)])], input_problems([wrong_type(public_holidays)])).

test(art13_the_wrong_bound_basis_is_rejected, fail) :-
    gdpr_information_duties_timing_profile_for(art13_provided_on_obtaining_day, Profile),
    information_deadline_basis_status(Profile, art14_3_a).
test(art13_late_bound_on_a_timely_profile_is_rejected, fail) :-
    gdpr_information_duties_timing_profile_for(art13_provided_on_obtaining_day, Profile),
    information_timing_verdict(Profile, late, _).
test(art14_deadline_bound_to_the_sunday_is_rejected, fail) :-
    gdpr_information_duties_timing_profile_for(art14_one_month_last_day, Profile),
    information_deadline(Profile, date(2026, 2, 15)).
test(art14_basis_bound_to_limb_a_is_rejected_when_limb_b_binds, fail) :-
    gdpr_information_duties_timing_profile_for(art14_first_communication_on_day, Profile),
    information_deadline_basis(Profile, art14_3_a).
test(an_unknown_key_gets_no_deadline, fail) :-
    information_deadline([attribute(personal_data_collected_from_data_subject, true), attribute(obtaining_date, date(2026, 3, 10)), attribute(as_of_date, date(2026, 1, 1))], date(2026, 3, 10)).

cp_test_names([art13_status_holds_with_the_basis_bound, art13_timely_holds_with_the_verdict_bound, art14_deadline_holds_with_the_date_bound, art14_deadline_read_element_wise_as_integers, art14_basis_bound_to_limb_b, art14_basis_bound_to_limb_c, art14_unsure_judgement_bound_to_its_referral, a_term_that_is_not_a_list_is_wrong_type_profile, a_number_is_wrong_type_profile_for_the_deadline, a_list_of_bare_atoms_is_wrong_type_profile, an_unknown_key_is_an_input_problem, a_float_inside_a_date_is_wrong_type, a_crisp_flag_given_yes_is_wrong_type, a_duplicate_key_is_named_once_and_not_typed, an_outside_fact_given_bare_is_wrong_type]).
cp_test_fail_names([art13_the_wrong_bound_basis_is_rejected, art13_late_bound_on_a_timely_profile_is_rejected, art14_deadline_bound_to_the_sunday_is_rejected, art14_basis_bound_to_limb_a_is_rejected_when_limb_b_binds, an_unknown_key_gets_no_deadline]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
