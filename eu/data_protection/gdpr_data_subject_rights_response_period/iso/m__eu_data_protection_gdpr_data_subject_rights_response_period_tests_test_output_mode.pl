% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_data_subject_rights_response_period_tests_test_output_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_data_subject_rights_response_period_gdpr_data_subject_rights_response_period, [decide_gdpr_data_subject_rights_response_period/2, gdpr_data_subject_rights_response_period_status/2, applicable_response_period/2, response_deadline/3, request_outside_facts/2]).
:- use_module(m__eu_data_protection_gdpr_data_subject_rights_response_period_kernel, [gdpr_data_subject_rights_response_period_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_data_subject_rights_response_period_fixtures, [gdpr_data_subject_rights_response_period_profile_for/2]).

test(claimed_and_necessary_yields_exactly_one_status) :-
    gdpr_data_subject_rights_response_period_profile_for(claimed_and_necessary, Profile),
    findall(Status, gdpr_data_subject_rights_response_period_status(Profile, Status), Statuses),
    Statuses == [extended_period].
test(the_verdict_carries_a_citation) :-
    gdpr_data_subject_rights_response_period_profile_for(claimed_and_necessary, Profile),
    decide_gdpr_data_subject_rights_response_period(Profile, Verdict),
    Verdict == gdpr_data_subject_rights_response_period_verdict(extended_period, [cite(eu_reg_2016_679_art_12_3)]).
test(an_input_problem_verdict_carries_no_citation) :-
    gdpr_data_subject_rights_response_period_profile_for(unknown_key_given, Profile),
    decide_gdpr_data_subject_rights_response_period(Profile, Verdict),
    Verdict == gdpr_data_subject_rights_response_period_verdict(input_problems, []).
test(deadline_is_read_out_element_wise) :-
    findall(date(Year, Month, Day), response_deadline(date(2026, 10, 29), first_period, date(Year, Month, Day)), Deadlines),
    Deadlines == [date(2026, 11, 30)],
    response_deadline(date(2026, 10, 29), first_period, date(DeadlineYear, DeadlineMonth, DeadlineDay)),
    integer(DeadlineYear),
    integer(DeadlineMonth),
    integer(DeadlineDay).
test(a_friday_deadline_stays) :-
    findall(Deadline, response_deadline(date(2026, 10, 27), first_period, Deadline), Deadlines),
    Deadlines == [date(2026, 11, 27)].
test(a_saturday_deadline_moves_to_monday) :-
    findall(Deadline, response_deadline(date(2026, 10, 28), first_period, Deadline), Deadlines),
    Deadlines == [date(2026, 11, 30)].
test(a_last_day_equal_to_the_month_length_is_kept) :-
    findall(Deadline, response_deadline(date(2026, 11, 30), first_period, Deadline), Deadlines),
    Deadlines == [date(2026, 12, 30)].
test(a_day_beyond_the_month_is_clipped_then_shifted) :-
    findall(Deadline, response_deadline(date(2026, 1, 31), first_period, Deadline), Deadlines),
    Deadlines == [date(2026, 3, 2)].
test(the_year_carries_over) :-
    findall(Deadline, response_deadline(date(2026, 12, 31), first_period, Deadline), Deadlines),
    Deadlines == [date(2027, 2, 1)].
test(leap_year_february_has_twenty_nine_days) :-
    findall(Deadline, response_deadline(date(2028, 1, 31), first_period, Deadline), Deadlines),
    Deadlines == [date(2028, 2, 29)].
test(extended_period_counts_three_months_from_receipt) :-
    findall(Deadline, response_deadline(date(2026, 1, 31), extended_period, Deadline), Deadlines),
    Deadlines == [date(2026, 4, 30)].
test(extended_period_sunday_moves_to_monday) :-
    findall(Deadline, response_deadline(date(2026, 11, 30), extended_period, Deadline), Deadlines),
    Deadlines == [date(2027, 3, 1)].
test(an_unbound_period_is_one_input_problem) :-
    findall(Deadline, response_deadline(date(2026, 1, 31), _Period, Deadline), Deadlines),
    Deadlines == [input_problems([wrong_type(response_period)])].
test(an_impossible_receipt_is_one_input_problem) :-
    findall(Deadline, response_deadline(date(2026, 2, 29), extended_period, Deadline), Deadlines),
    Deadlines == [input_problems([wrong_type(receipt_date)])].
test(both_arguments_wrong_in_order) :-
    findall(Deadline, response_deadline(yesterday, third_period, Deadline), Deadlines),
    Deadlines == [input_problems([wrong_type(receipt_date), wrong_type(response_period)])].
test(problems_are_listed_contract_keys_first_then_unknown_keys) :-
    findall(Problems, gdpr_data_subject_rights_response_period_input_problems([attribute(colour, blue), attribute(extension_claimed, unsure), attribute(colour, red)], Problems), ProblemLists),
    ProblemLists == [[wrong_type(extension_claimed), unknown_key(colour)]].
test(outside_facts_are_read_out_in_table_order) :-
    gdpr_data_subject_rights_response_period_profile_for(unread_keys_present, Profile),
    findall(OutsideFacts, request_outside_facts(Profile, OutsideFacts), Answers),
    Answers == [[outside_fact(erasure_required_by_union_or_member_state_law, absent), outside_fact(processing_required_by_union_or_member_state_law, absent), outside_fact(decision_authorised_by_union_or_member_state_law, absent), outside_fact(legislative_restriction_applies_to_the_right, absent), outside_fact(public_holidays, attested([date(2026, 11, 30)], attestation(by, at, reason, none)))]].
test(applicable_period_is_read_out_once) :-
    gdpr_data_subject_rights_response_period_profile_for(claimed_not_necessary, Profile),
    findall(Period, applicable_response_period(Profile, Period), Periods),
    Periods == [first_period].

cp_test_names([claimed_and_necessary_yields_exactly_one_status, the_verdict_carries_a_citation, an_input_problem_verdict_carries_no_citation, deadline_is_read_out_element_wise, a_friday_deadline_stays, a_saturday_deadline_moves_to_monday, a_last_day_equal_to_the_month_length_is_kept, a_day_beyond_the_month_is_clipped_then_shifted, the_year_carries_over, leap_year_february_has_twenty_nine_days, extended_period_counts_three_months_from_receipt, extended_period_sunday_moves_to_monday, an_unbound_period_is_one_input_problem, an_impossible_receipt_is_one_input_problem, both_arguments_wrong_in_order, problems_are_listed_contract_keys_first_then_unknown_keys, outside_facts_are_read_out_in_table_order, applicable_period_is_read_out_once]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
