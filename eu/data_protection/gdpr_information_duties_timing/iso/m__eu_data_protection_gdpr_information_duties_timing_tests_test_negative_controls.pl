% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_information_duties_timing_tests_test_negative_controls, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_information_duties_timing_queries, [information_timing_verdict/3, information_deadline_basis/2]).
:- use_module(m__eu_data_protection_gdpr_information_duties_timing_fixtures, [gdpr_information_duties_timing_profile_for/2]).

verdict_of(Subject, Verdict) :-
    gdpr_information_duties_timing_profile_for(Subject, Profile),
    information_timing_verdict(Profile, Verdict, _).

test(art13_on_the_obtaining_day_is_timely) :-
    verdict_of(art13_on_obtaining_day, timely).
test(art13_the_day_after_is_late) :-
    verdict_of(art13_day_after_obtaining, late).
test(the_art14_route_reads_the_event_flags) :-
    information_timing_verdict([attribute(personal_data_collected_from_data_subject, false), attribute(obtaining_date, date(2026, 3, 10)), attribute(provision_date, date(2026, 3, 10))], indeterminate([data_used_for_communication_with_data_subject, disclosure_to_another_recipient_envisaged]), []).
test(limb_a_on_the_last_day_is_timely) :-
    verdict_of(art14_limb_a_last_day, timely).
test(limb_a_the_day_after_is_late) :-
    verdict_of(art14_limb_a_day_after, late).
test(limb_b_on_the_first_communication_is_timely) :-
    verdict_of(art14_first_communication_day, timely).
test(limb_b_the_day_after_is_late) :-
    verdict_of(art14_day_after_first_communication, late).
test(limb_b_fixes_the_basis) :-
    gdpr_information_duties_timing_profile_for(art14_first_communication_day, Profile),
    information_deadline_basis(Profile, art14_3_b).
test(limb_c_on_the_first_disclosure_is_timely) :-
    verdict_of(art14_first_disclosure_day, timely).
test(limb_c_the_day_after_is_late) :-
    verdict_of(art14_day_after_first_disclosure, late).
test(holiday_shift_day_is_timely) :-
    verdict_of(art14_attested_holiday_shift, timely).
test(holiday_shift_the_day_after_is_late) :-
    verdict_of(art14_day_after_attested_holiday_shift, late).
test(leap_day_is_timely) :-
    verdict_of(art14_leap_day, timely).
test(the_first_of_march_after_the_leap_day_is_late) :-
    verdict_of(art14_day_after_leap_day, late).
test(holidays_absent_on_a0_is_timely) :-
    verdict_of(art14_holidays_absent_on_limb_a_day, timely).
test(holidays_absent_after_a0_is_referred) :-
    verdict_of(art14_holidays_absent_after_limb_a_day, needs_legal_review(cross_reference_unresolved(cite(eu_reg_1971_1182_art_3_4), cite(public_holidays_applicable_to_the_period)), _)).
test(a_false_judgement_is_late) :-
    verdict_of(art14_reasonable_period_false, late).
test(an_unsure_judgement_is_handed_to_the_user) :-
    verdict_of(art14_reasonable_period_unsure, needs_legal_review(open_textured(provided_within_reasonable_period, cite(eu_reg_2016_679_art_14_3_a)), [inputs_relied_on([provided_within_reasonable_period - unsure])])).
test(an_unknown_route_is_named) :-
    verdict_of(route_unknown, indeterminate([personal_data_collected_from_data_subject])).
test(a_duplicate_key_is_an_input_problem) :-
    verdict_of(route_key_duplicated, input_problems([duplicate_key(personal_data_collected_from_data_subject)])).

test(art13_on_the_obtaining_day_is_not_late, fail) :-
    verdict_of(art13_on_obtaining_day, late).
test(art13_the_day_after_is_not_timely, fail) :-
    verdict_of(art13_day_after_obtaining, timely).
test(the_art14_route_is_not_the_art13_verdict, fail) :-
    information_timing_verdict([attribute(personal_data_collected_from_data_subject, false), attribute(obtaining_date, date(2026, 3, 10)), attribute(provision_date, date(2026, 3, 10))], timely, _).
test(limb_a_on_the_last_day_is_not_late, fail) :-
    verdict_of(art14_limb_a_last_day, late).
test(limb_a_the_day_after_is_not_timely, fail) :-
    verdict_of(art14_limb_a_day_after, timely).
test(limb_b_on_the_first_communication_is_not_late, fail) :-
    verdict_of(art14_first_communication_day, late).
test(limb_b_the_day_after_is_not_timely, fail) :-
    verdict_of(art14_day_after_first_communication, timely).
test(limb_b_basis_is_not_limb_c, fail) :-
    gdpr_information_duties_timing_profile_for(art14_first_communication_day, Profile),
    information_deadline_basis(Profile, art14_3_c).
test(limb_c_on_the_first_disclosure_is_not_late, fail) :-
    verdict_of(art14_first_disclosure_day, late).
test(limb_c_the_day_after_is_not_timely, fail) :-
    verdict_of(art14_day_after_first_disclosure, timely).
test(holiday_shift_day_is_not_late, fail) :-
    verdict_of(art14_attested_holiday_shift, late).
test(holiday_shift_the_day_after_is_not_timely, fail) :-
    verdict_of(art14_day_after_attested_holiday_shift, timely).
test(leap_day_is_not_late, fail) :-
    verdict_of(art14_leap_day, late).
test(the_first_of_march_after_the_leap_day_is_not_timely, fail) :-
    verdict_of(art14_day_after_leap_day, timely).
test(holidays_absent_on_a0_is_not_referred, fail) :-
    verdict_of(art14_holidays_absent_on_limb_a_day, needs_legal_review(_, _)).
test(holidays_absent_after_a0_is_not_late, fail) :-
    verdict_of(art14_holidays_absent_after_limb_a_day, late).
test(a_false_judgement_is_not_timely, fail) :-
    verdict_of(art14_reasonable_period_false, timely).
test(an_unsure_judgement_is_not_timely, fail) :-
    verdict_of(art14_reasonable_period_unsure, timely).
test(an_unknown_route_is_not_timely, fail) :-
    verdict_of(route_unknown, timely).
test(a_duplicate_key_gets_no_verdict, fail) :-
    verdict_of(route_key_duplicated, timely).

cp_test_names([art13_on_the_obtaining_day_is_timely, art13_the_day_after_is_late, the_art14_route_reads_the_event_flags, limb_a_on_the_last_day_is_timely, limb_a_the_day_after_is_late, limb_b_on_the_first_communication_is_timely, limb_b_the_day_after_is_late, limb_b_fixes_the_basis, limb_c_on_the_first_disclosure_is_timely, limb_c_the_day_after_is_late, holiday_shift_day_is_timely, holiday_shift_the_day_after_is_late, leap_day_is_timely, the_first_of_march_after_the_leap_day_is_late, holidays_absent_on_a0_is_timely, holidays_absent_after_a0_is_referred, a_false_judgement_is_late, an_unsure_judgement_is_handed_to_the_user, an_unknown_route_is_named, a_duplicate_key_is_an_input_problem]).
cp_test_fail_names([art13_on_the_obtaining_day_is_not_late, art13_the_day_after_is_not_timely, the_art14_route_is_not_the_art13_verdict, limb_a_on_the_last_day_is_not_late, limb_a_the_day_after_is_not_timely, limb_b_on_the_first_communication_is_not_late, limb_b_the_day_after_is_not_timely, limb_b_basis_is_not_limb_c, limb_c_on_the_first_disclosure_is_not_late, limb_c_the_day_after_is_not_timely, holiday_shift_day_is_not_late, holiday_shift_the_day_after_is_not_timely, leap_day_is_not_late, the_first_of_march_after_the_leap_day_is_not_timely, holidays_absent_on_a0_is_not_referred, holidays_absent_after_a0_is_not_late, a_false_judgement_is_not_timely, an_unsure_judgement_is_not_timely, an_unknown_route_is_not_timely, a_duplicate_key_gets_no_verdict]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
