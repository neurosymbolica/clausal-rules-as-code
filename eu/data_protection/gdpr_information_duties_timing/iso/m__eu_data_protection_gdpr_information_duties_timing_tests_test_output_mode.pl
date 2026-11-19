% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_information_duties_timing_tests_test_output_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_information_duties_timing_queries, [information_deadline/2, information_deadline_basis/2, information_timing_verdict/3]).
:- use_module(m__eu_data_protection_gdpr_information_duties_timing_fixtures, [gdpr_information_duties_timing_profile_for/2]).

expected_verdict(art13_on_obtaining_day, timely, [cite(eu_reg_2016_679_art_13_1)]).
expected_verdict(art13_day_after_obtaining, late, [cite(eu_reg_2016_679_art_13_1)]).
expected_verdict(art13_with_unread_keys, timely, [cite(eu_reg_2016_679_art_13_1)]).
expected_verdict(art14_limb_a_last_day, timely, [cite(eu_reg_2016_679_art_14_3_a)]).
expected_verdict(art14_limb_a_day_after, late, [cite(eu_reg_2016_679_art_14_3_a)]).
expected_verdict(art14_first_communication_day, timely, [cite(eu_reg_2016_679_art_14_3_b)]).
expected_verdict(art14_day_after_first_communication, late, [cite(eu_reg_2016_679_art_14_3_b)]).
expected_verdict(art14_first_disclosure_day, timely, [cite(eu_reg_2016_679_art_14_3_c)]).
expected_verdict(art14_day_after_first_disclosure, late, [cite(eu_reg_2016_679_art_14_3_c)]).
expected_verdict(art14_attested_holiday_shift, timely, [cite(eu_reg_2016_679_art_14_3_a)]).
expected_verdict(art14_day_after_attested_holiday_shift, late, [cite(eu_reg_2016_679_art_14_3_a)]).
expected_verdict(art14_leap_day, timely, [cite(eu_reg_2016_679_art_14_3_a)]).
expected_verdict(art14_day_after_leap_day, late, [cite(eu_reg_2016_679_art_14_3_a)]).
expected_verdict(art14_holidays_absent_on_limb_a_day, timely, [cite(eu_reg_2016_679_art_14_3_a)]).
expected_verdict(art14_holidays_absent_after_limb_a_day, needs_legal_review(cross_reference_unresolved(cite(eu_reg_1971_1182_art_3_4), cite(public_holidays_applicable_to_the_period)), [resolution(cite(public_holidays_applicable_to_the_period), not_attempted), inputs_relied_on([provided_within_reasonable_period - true])]), []).
expected_verdict(art14_reasonable_period_false, late, [cite(eu_reg_2016_679_art_14_3_a)]).
expected_verdict(art14_reasonable_period_unsure, needs_legal_review(open_textured(provided_within_reasonable_period, cite(eu_reg_2016_679_art_14_3_a)), [inputs_relied_on([provided_within_reasonable_period - unsure])]), []).
expected_verdict(route_unknown, indeterminate([personal_data_collected_from_data_subject]), []).
expected_verdict(items_provided_wrong_type, input_problems([wrong_type(items_provided)]), []).
expected_verdict(route_key_duplicated, input_problems([duplicate_key(personal_data_collected_from_data_subject)]), []).

expected_deadline(art13_on_obtaining_day, date(2026, 3, 10)).
expected_deadline(art14_limb_a_last_day, date(2026, 2, 16)).
expected_deadline(art14_first_communication_day, date(2026, 1, 20)).
expected_deadline(art14_first_disclosure_day, date(2026, 2, 1)).
expected_deadline(art14_attested_holiday_shift, date(2027, 2, 2)).
expected_deadline(art14_leap_day, date(2028, 2, 29)).
expected_deadline(art14_holidays_absent_on_limb_a_day, needs_legal_review(cross_reference_unresolved(cite(eu_reg_1971_1182_art_3_4), cite(public_holidays_applicable_to_the_period)), [resolution(cite(public_holidays_applicable_to_the_period), not_attempted), inputs_relied_on([])])).
expected_deadline(route_unknown, indeterminate([personal_data_collected_from_data_subject])).
expected_deadline(items_provided_wrong_type, input_problems([wrong_type(items_provided)])).

expected_basis(art13_on_obtaining_day, art13_1).
expected_basis(art14_limb_a_last_day, art14_3_a).
expected_basis(art14_first_communication_day, art14_3_b).
expected_basis(art14_first_disclosure_day, art14_3_c).
expected_basis(art14_attested_holiday_shift, art14_3_a).
expected_basis(art14_holidays_absent_on_limb_a_day, art14_3_a).
expected_basis(route_unknown, indeterminate([personal_data_collected_from_data_subject])).
expected_basis(route_key_duplicated, input_problems([duplicate_key(personal_data_collected_from_data_subject)])).

verdict_matches(Subject) :-
    expected_verdict(Subject, Verdict, Citations),
    gdpr_information_duties_timing_profile_for(Subject, Profile),
    findall(Got - GotCitations, information_timing_verdict(Profile, Got, GotCitations), Answers),
    Answers == [Verdict - Citations].

deadline_matches(Subject) :-
    expected_deadline(Subject, Deadline),
    gdpr_information_duties_timing_profile_for(Subject, Profile),
    findall(Got, information_deadline(Profile, Got), Answers),
    Answers == [Deadline].

basis_matches(Subject) :-
    expected_basis(Subject, Basis),
    gdpr_information_duties_timing_profile_for(Subject, Profile),
    findall(Got, information_deadline_basis(Profile, Got), Answers),
    Answers == [Basis].

test(every_fixture_yields_exactly_its_verdict_once) :-
    findall(Subject, expected_verdict(Subject, _, _), Subjects),
    findall(Subject, verdict_matches(Subject), Matched),
    Matched == Subjects.
test(every_listed_fixture_yields_exactly_its_deadline_once) :-
    findall(Subject, expected_deadline(Subject, _), Subjects),
    findall(Subject, deadline_matches(Subject), Matched),
    Matched == Subjects.
test(every_listed_fixture_yields_exactly_its_basis_once) :-
    findall(Subject, expected_basis(Subject, _), Subjects),
    findall(Subject, basis_matches(Subject), Matched),
    Matched == Subjects.
test(the_limb_a_last_day_is_timely_and_the_next_day_late) :-
    gdpr_information_duties_timing_profile_for(art14_limb_a_last_day, OnTheDay),
    information_timing_verdict(OnTheDay, OnTheDayVerdict, _),
    OnTheDayVerdict == timely,
    gdpr_information_duties_timing_profile_for(art14_limb_a_day_after, DayAfter),
    information_timing_verdict(DayAfter, DayAfterVerdict, _),
    DayAfterVerdict == late.
test(the_holiday_shift_moves_the_deadline_past_the_attested_day) :-
    gdpr_information_duties_timing_profile_for(art14_attested_holiday_shift, Profile),
    information_deadline(Profile, Deadline),
    Deadline == date(2027, 2, 2).
test(the_missing_keys_of_an_empty_profile) :-
    information_timing_verdict([], Verdict, Citations),
    Verdict == indeterminate([personal_data_collected_from_data_subject, obtaining_date, provision_date]),
    Citations == [].

cp_test_names([every_fixture_yields_exactly_its_verdict_once, every_listed_fixture_yields_exactly_its_deadline_once, every_listed_fixture_yields_exactly_its_basis_once, the_limb_a_last_day_is_timely_and_the_next_day_late, the_holiday_shift_moves_the_deadline_past_the_attested_day, the_missing_keys_of_an_empty_profile]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
