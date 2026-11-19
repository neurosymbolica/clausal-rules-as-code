% SPDX-License-Identifier: EUPL-1.2
:- module(m__uk_uk_complaints_to_the_commissioner_tests_test_output_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__uk_uk_complaints_to_the_commissioner_uk_complaints_to_the_commissioner, [decide_uk_complaints_to_the_commissioner/2, uk_complaints_to_the_commissioner_status/2, uk_complaints_to_the_commissioner_checklist/2, controller_complaint_right/3, commission_complaint_right/3, acknowledgement_last_day/3]).
:- use_module(m__uk_uk_complaints_to_the_commissioner_fixtures, [uk_complaints_to_the_commissioner_subject/1, uk_complaints_to_the_commissioner_profile_for/2]).

expected_controller(gdpr_complaint_to_controller, complaint_under_section_164a, [cite(uk_dpa_2018_s_164a_1)]).
expected_controller(part_3_complaint_to_controller, complaint_under_section_164a, [cite(uk_dpa_2018_s_164a_1)]).
expected_controller(part_4_complaint_to_controller, not_a_complaint_under_section_164a, [cite(uk_dpa_2018_s_164a_1)]).
expected_controller(complaint_to_processor, not_a_complaint_under_section_164a, [cite(uk_dpa_2018_s_164a_1)]).
expected_controller(third_party_complaint, not_a_complaint_under_section_164a, [cite(uk_dpa_2018_s_164a_1)]).
expected_controller(no_infringement_considered, not_a_complaint_under_section_164a, [cite(uk_dpa_2018_s_164a_1)]).
expected_controller(recipient_not_stated, indeterminate([complaint_made_to_the_controller]), []).
expected_controller(empty_profile, indeterminate([complaint_by_data_subject_about_own_personal_data]), []).
expected_controller(badly_typed_profile, input_problems([wrong_type(infringement_considered), unknown_key(colour)]), []).
expected_controller(duplicated_key_profile, input_problems([duplicate_key(infringement_considered)]), []).

expected_commission(gdpr_complaint_to_controller, complaint_under_section_165_2, [cite(uk_dpa_2018_s_165_2)]).
expected_commission(part_3_complaint_to_controller, complaint_under_section_165_2, [cite(uk_dpa_2018_s_165_2)]).
expected_commission(part_4_complaint_to_controller, complaint_under_section_165_2, [cite(uk_dpa_2018_s_165_2)]).
expected_commission(complaint_to_processor, complaint_under_section_165_2, [cite(uk_dpa_2018_s_165_2)]).
expected_commission(third_party_complaint, not_a_complaint_under_section_165_2, [cite(uk_dpa_2018_s_165_2)]).
expected_commission(no_infringement_considered, not_a_complaint_under_section_165_2, [cite(uk_dpa_2018_s_165_2)]).
expected_commission(recipient_not_stated, complaint_under_section_165_2, [cite(uk_dpa_2018_s_165_2)]).
expected_commission(empty_profile, indeterminate([complaint_by_data_subject_about_own_personal_data]), []).
expected_commission(badly_typed_profile, input_problems([wrong_type(infringement_considered), unknown_key(colour)]), []).
expected_commission(duplicated_key_profile, input_problems([duplicate_key(infringement_considered)]), []).

controller_answers_match(Subject) :-
    expected_controller(Subject, ExpectedResult, ExpectedCitations),
    uk_complaints_to_the_commissioner_profile_for(Subject, Profile),
    findall(Result - Citations, controller_complaint_right(Profile, Result, Citations), Answers),
    Answers == [ExpectedResult - ExpectedCitations].

commission_answers_match(Subject) :-
    expected_commission(Subject, ExpectedResult, ExpectedCitations),
    uk_complaints_to_the_commissioner_profile_for(Subject, Profile),
    findall(Result - Citations, commission_complaint_right(Profile, Result, Citations), Answers),
    Answers == [ExpectedResult - ExpectedCitations].

test(every_fixture_reads_out_its_controller_answer) :-
    findall(Subject, uk_complaints_to_the_commissioner_subject(Subject), Subjects),
    findall(Subject, controller_answers_match(Subject), Matching),
    Matching == Subjects.
test(every_fixture_reads_out_its_commission_answer) :-
    findall(Subject, uk_complaints_to_the_commissioner_subject(Subject), Subjects),
    findall(Subject, commission_answers_match(Subject), Matching),
    Matching == Subjects.
test(the_verdict_wrapper_reads_out_the_controller_answer) :-
    uk_complaints_to_the_commissioner_profile_for(gdpr_complaint_to_controller, Profile),
    findall(Verdict, decide_uk_complaints_to_the_commissioner(Profile, Verdict), Verdicts),
    Verdicts == [uk_complaints_to_the_commissioner_verdict(complaint_under_section_164a, [cite(uk_dpa_2018_s_164a_1)])].
test(the_status_reads_out_one_atom) :-
    uk_complaints_to_the_commissioner_profile_for(part_4_complaint_to_controller, Profile),
    findall(Status, uk_complaints_to_the_commissioner_status(Profile, Status), Statuses),
    Statuses == [not_a_complaint_under_section_164a].
test(the_commencement_day_reads_out_its_last_day) :-
    last_day_answers(date(2026, 6, 19), Answers),
    Answers == [date(2026, 7, 18) - [cite(uk_dpa_2018_s_164a_3), cite(uk_si_2026_82_reg_3), cite(uk_si_2026_82_reg_3_a), cite(uk_si_2026_82_reg_7)]].
test(the_day_before_commencement_reads_out_no_duty) :-
    last_day_answers(date(2026, 6, 18), Answers),
    Answers == [acknowledgement_duty_does_not_apply - [cite(uk_si_2026_82_reg_3), cite(uk_si_2026_82_reg_3_a), cite(uk_si_2026_82_reg_7)]].
test(the_last_day_carries_into_the_next_year) :-
    acknowledgement_last_day(date(2026, 12, 15), LastDay, _),
    LastDay == date(2027, 1, 13).
test(the_last_day_in_a_leap_year) :-
    acknowledgement_last_day(date(2028, 2, 10), LastDay, _),
    LastDay == date(2028, 3, 10).
test(the_last_day_in_a_common_year) :-
    acknowledgement_last_day(date(2027, 2, 10), LastDay, _),
    LastDay == date(2027, 3, 11).
test(the_last_day_from_a_leap_day) :-
    acknowledgement_last_day(date(2028, 2, 29), LastDay, _),
    LastDay == date(2028, 3, 29).
test(the_last_day_from_the_end_of_january) :-
    acknowledgement_last_day(date(2027, 1, 31), LastDay, _),
    LastDay == date(2027, 3, 1).
test(the_last_day_is_three_bare_integers) :-
    acknowledgement_last_day(date(2026, 9, 1), date(LastYear, LastMonth, LastDayOfMonth), _),
    integer(LastYear),
    integer(LastMonth),
    integer(LastDayOfMonth),
    LastYear =:= 2026,
    LastMonth =:= 9,
    LastDayOfMonth =:= 30.
test(the_last_input_year_carries_past_the_range) :-
    acknowledgement_last_day(date(2199, 12, 31), LastDay, _),
    LastDay == date(2200, 1, 29).
test(an_impossible_day_reads_out_its_problem) :-
    last_day_answers(date(2027, 2, 29), Answers),
    Answers == [input_problems([wrong_type(receipt_date)]) - []].
test(the_checklist_carries_a_citation_per_item) :-
    uk_complaints_to_the_commissioner_profile_for(gdpr_complaint_to_controller, Profile),
    uk_complaints_to_the_commissioner_checklist(Profile, Items),
    length(Items, 3),
    findall(Cite, member(item(_, _, Cite), Items), Cites),
    sort(Cites, [cite(uk_dpa_2018_s_164a_1)]),
    findall(Status, member(item(_, Status, _), Items), Statuses),
    Statuses == [met, met, met].
test(the_checklist_names_the_unmet_recipient) :-
    uk_complaints_to_the_commissioner_profile_for(complaint_to_processor, Profile),
    uk_complaints_to_the_commissioner_checklist(Profile, Items),
    member(item(complaint_made_to_the_controller, unmet(complaint_not_made_to_the_controller), cite(uk_dpa_2018_s_164a_1)), Items).
test(the_checklist_reports_input_problems) :-
    uk_complaints_to_the_commissioner_profile_for(badly_typed_profile, Profile),
    findall(Items, uk_complaints_to_the_commissioner_checklist(Profile, Items), Answers),
    Answers == [[item(input_check, unmet(input_problems([wrong_type(infringement_considered), unknown_key(colour)])), cite(uk_dpa_2018_s_164a_1))]].

last_day_answers(Receipt, Answers) :-
    findall(LastDay - Citations, acknowledgement_last_day(Receipt, LastDay, Citations), Answers).

cp_test_names([every_fixture_reads_out_its_controller_answer, every_fixture_reads_out_its_commission_answer, the_verdict_wrapper_reads_out_the_controller_answer, the_status_reads_out_one_atom, the_commencement_day_reads_out_its_last_day, the_day_before_commencement_reads_out_no_duty, the_last_day_carries_into_the_next_year, the_last_day_in_a_leap_year, the_last_day_in_a_common_year, the_last_day_from_a_leap_day, the_last_day_from_the_end_of_january, the_last_day_is_three_bare_integers, the_last_input_year_carries_past_the_range, an_impossible_day_reads_out_its_problem, the_checklist_carries_a_citation_per_item, the_checklist_names_the_unmet_recipient, the_checklist_reports_input_problems]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
