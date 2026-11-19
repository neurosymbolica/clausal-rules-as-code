% SPDX-License-Identifier: EUPL-1.2
:- module(m__uk_uk_complaints_to_the_commissioner_tests_test_public_interface, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__uk_uk_complaints_to_the_commissioner_uk_complaints_to_the_commissioner, [decide_uk_complaints_to_the_commissioner/2, uk_complaints_to_the_commissioner_status/2, uk_complaints_to_the_commissioner_checklist/2, uk_complaints_to_the_commissioner_decision_resolvable/1, uk_complaints_to_the_commissioner_status_values/1, controller_complaint_right/3, commission_complaint_right/3, acknowledgement_last_day/3]).
:- use_module(m__uk_uk_complaints_to_the_commissioner_fixtures, [uk_complaints_to_the_commissioner_subject/1, uk_complaints_to_the_commissioner_profile_for/2, uk_complaints_to_the_commissioner_assess/2]).
:- use_module(m__uk_uk_complaints_to_the_commissioner_kernel, [uk_complaints_to_the_commissioner_input_problems/2]).
:- use_module(m__uk_uk_complaints_to_the_commissioner_queries, [uk_complaints_to_the_commissioner_what_if/4, uk_complaints_to_the_commissioner_profile_keys/1]).

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

subject_controller_matches(Subject) :-
    expected_controller(Subject, ExpectedResult, ExpectedCitations),
    uk_complaints_to_the_commissioner_profile_for(Subject, Profile),
    findall(Result - Citations, controller_complaint_right(Profile, Result, Citations), Answers),
    Answers == [ExpectedResult - ExpectedCitations].

subject_commission_matches(Subject) :-
    expected_commission(Subject, ExpectedResult, ExpectedCitations),
    uk_complaints_to_the_commissioner_profile_for(Subject, Profile),
    findall(Result - Citations, commission_complaint_right(Profile, Result, Citations), Answers),
    Answers == [ExpectedResult - ExpectedCitations].

subject_assess_matches(Subject) :-
    expected_controller(Subject, ExpectedResult, ExpectedCitations),
    findall(Verdict, uk_complaints_to_the_commissioner_assess(Subject, Verdict), Verdicts),
    Verdicts == [uk_complaints_to_the_commissioner_verdict(ExpectedResult, ExpectedCitations)].

subject_checklist_is_cited(Subject) :-
    uk_complaints_to_the_commissioner_profile_for(Subject, Profile),
    findall(Items, uk_complaints_to_the_commissioner_checklist(Profile, Items), Checklists),
    Checklists = [[FirstItem|OtherItems]],
    maplist(item_is_cited, [FirstItem|OtherItems]).

item_is_cited(item(_, _, cite(uk_dpa_2018_s_164a_1))).

test(every_subject_has_an_expectation) :-
    findall(Subject, uk_complaints_to_the_commissioner_subject(Subject), Subjects),
    Subjects = [_|_],
    maplist(subject_controller_matches, Subjects).
test(every_subject_resolves_to_its_expected_controller_answer_once) :-
    findall(Subject, uk_complaints_to_the_commissioner_subject(Subject), Subjects),
    maplist(subject_controller_matches, Subjects).
test(every_subject_resolves_to_its_expected_commission_answer_once) :-
    findall(Subject, uk_complaints_to_the_commissioner_subject(Subject), Subjects),
    maplist(subject_commission_matches, Subjects).
test(every_subject_assesses_to_its_expected_verdict_once) :-
    findall(Subject, uk_complaints_to_the_commissioner_subject(Subject), Subjects),
    maplist(subject_assess_matches, Subjects).
test(every_subject_has_a_non_empty_cited_checklist) :-
    findall(Subject, uk_complaints_to_the_commissioner_subject(Subject), Subjects),
    maplist(subject_checklist_is_cited, Subjects).
test(every_subject_is_resolvable) :-
    findall(Subject, uk_complaints_to_the_commissioner_subject(Subject), Subjects),
    maplist(subject_is_resolvable, Subjects).
test(gdpr_complaint_to_controller_is_a_complaint_under_section_164a) :-
    uk_complaints_to_the_commissioner_assess(gdpr_complaint_to_controller, uk_complaints_to_the_commissioner_verdict(complaint_under_section_164a, [cite(uk_dpa_2018_s_164a_1)])).
test(part_3_complaint_to_controller_is_a_complaint_under_section_164a) :-
    uk_complaints_to_the_commissioner_assess(part_3_complaint_to_controller, uk_complaints_to_the_commissioner_verdict(complaint_under_section_164a, [cite(uk_dpa_2018_s_164a_1)])).
test(part_4_complaint_to_controller_is_not_a_complaint_under_section_164a) :-
    uk_complaints_to_the_commissioner_assess(part_4_complaint_to_controller, uk_complaints_to_the_commissioner_verdict(not_a_complaint_under_section_164a, [cite(uk_dpa_2018_s_164a_1)])).
test(complaint_to_processor_is_not_a_complaint_under_section_164a) :-
    uk_complaints_to_the_commissioner_assess(complaint_to_processor, uk_complaints_to_the_commissioner_verdict(not_a_complaint_under_section_164a, _)).
test(third_party_complaint_is_not_a_complaint_under_section_164a) :-
    uk_complaints_to_the_commissioner_assess(third_party_complaint, uk_complaints_to_the_commissioner_verdict(not_a_complaint_under_section_164a, _)).
test(no_infringement_considered_is_not_a_complaint_under_section_164a) :-
    uk_complaints_to_the_commissioner_assess(no_infringement_considered, uk_complaints_to_the_commissioner_verdict(not_a_complaint_under_section_164a, _)).
test(recipient_not_stated_names_the_controller_key) :-
    uk_complaints_to_the_commissioner_status_of(recipient_not_stated, indeterminate([complaint_made_to_the_controller])).
test(empty_profile_names_the_first_key) :-
    uk_complaints_to_the_commissioner_status_of(empty_profile, indeterminate([complaint_by_data_subject_about_own_personal_data])).
test(badly_typed_profile_gives_input_problems) :-
    uk_complaints_to_the_commissioner_status_of(badly_typed_profile, input_problems([wrong_type(infringement_considered), unknown_key(colour)])).
test(duplicated_key_profile_gives_duplicate_key) :-
    uk_complaints_to_the_commissioner_status_of(duplicated_key_profile, input_problems([duplicate_key(infringement_considered)])).
test(near_miss_part_4_flips_the_controller_verdict) :-
    uk_complaints_to_the_commissioner_status_of(gdpr_complaint_to_controller, complaint_under_section_164a),
    uk_complaints_to_the_commissioner_status_of(part_4_complaint_to_controller, not_a_complaint_under_section_164a).
test(near_miss_processor_flips_the_controller_verdict) :-
    uk_complaints_to_the_commissioner_status_of(gdpr_complaint_to_controller, complaint_under_section_164a),
    uk_complaints_to_the_commissioner_status_of(complaint_to_processor, not_a_complaint_under_section_164a).
test(near_miss_third_party_flips_the_commission_verdict) :-
    uk_complaints_to_the_commissioner_profile_for(gdpr_complaint_to_controller, PositiveProfile),
    uk_complaints_to_the_commissioner_profile_for(third_party_complaint, NegativeProfile),
    commission_complaint_right(PositiveProfile, complaint_under_section_165_2, _),
    commission_complaint_right(NegativeProfile, not_a_complaint_under_section_165_2, _).
test(near_miss_no_infringement_flips_the_commission_verdict) :-
    uk_complaints_to_the_commissioner_profile_for(part_4_complaint_to_controller, PositiveProfile),
    uk_complaints_to_the_commissioner_profile_for(no_infringement_considered, NegativeProfile),
    commission_complaint_right(PositiveProfile, complaint_under_section_165_2, _),
    commission_complaint_right(NegativeProfile, not_a_complaint_under_section_165_2, _).
test(commission_ignores_the_recipient_of_the_complaint) :-
    findall(Result, commission_complaint_right([attribute(complaint_by_data_subject_about_own_personal_data, true), attribute(infringement_considered, dpa_2018_part_4), attribute(complaint_made_to_the_controller, false)], Result, _), FalseResults),
    findall(Result, commission_complaint_right([attribute(complaint_by_data_subject_about_own_personal_data, true), attribute(infringement_considered, dpa_2018_part_4)], Result, _), AbsentResults),
    FalseResults == [complaint_under_section_165_2],
    AbsentResults == [complaint_under_section_165_2].
test(a_deciding_false_settles_before_a_missing_key) :-
    findall(Result - Citations, controller_complaint_right([attribute(complaint_made_to_the_controller, false)], Result, Citations), Answers),
    Answers == [not_a_complaint_under_section_164a - [cite(uk_dpa_2018_s_164a_1)]].
test(a_deciding_part_4_settles_the_controller_query) :-
    findall(Result, controller_complaint_right([attribute(infringement_considered, dpa_2018_part_4)], Result, _), Results),
    Results == [not_a_complaint_under_section_164a].
test(two_deciding_values_still_answer_once) :-
    findall(Result, controller_complaint_right([attribute(complaint_by_data_subject_about_own_personal_data, false), attribute(infringement_considered, none_of_the_three), attribute(complaint_made_to_the_controller, false)], Result, _), Results),
    Results == [not_a_complaint_under_section_164a].
test(positive_checklist_is_all_met_and_cited) :-
    uk_complaints_to_the_commissioner_profile_for(gdpr_complaint_to_controller, Profile),
    uk_complaints_to_the_commissioner_checklist(Profile, Items),
    Items == [item(data_subject_about_own_personal_data, met, cite(uk_dpa_2018_s_164a_1)), item(infringement_of_uk_gdpr_or_part_3_considered, met, cite(uk_dpa_2018_s_164a_1)), item(complaint_made_to_the_controller, met, cite(uk_dpa_2018_s_164a_1))].
test(processor_checklist_marks_the_recipient_unmet) :-
    uk_complaints_to_the_commissioner_profile_for(complaint_to_processor, Profile),
    uk_complaints_to_the_commissioner_checklist(Profile, Items),
    member(item(complaint_made_to_the_controller, unmet(complaint_not_made_to_the_controller), cite(uk_dpa_2018_s_164a_1)), Items).
test(recipient_not_stated_checklist_marks_the_key_unknown) :-
    uk_complaints_to_the_commissioner_profile_for(recipient_not_stated, Profile),
    uk_complaints_to_the_commissioner_checklist(Profile, Items),
    member(item(complaint_made_to_the_controller, unknown([complaint_made_to_the_controller]), cite(uk_dpa_2018_s_164a_1)), Items).
test(receipt_on_commencement_day_gives_its_last_day_once) :-
    findall(LastDay - Citations, acknowledgement_last_day(date(2026, 6, 19), LastDay, Citations), Answers),
    Answers == [date(2026, 7, 18) - [cite(uk_dpa_2018_s_164a_3), cite(uk_si_2026_82_reg_3), cite(uk_si_2026_82_reg_3_a), cite(uk_si_2026_82_reg_7)]].
test(receipt_the_day_before_commencement_gives_no_duty_once) :-
    findall(LastDay - Citations, acknowledgement_last_day(date(2026, 6, 18), LastDay, Citations), Answers),
    Answers == [acknowledgement_duty_does_not_apply - [cite(uk_si_2026_82_reg_3), cite(uk_si_2026_82_reg_3_a), cite(uk_si_2026_82_reg_7)]].
test(last_day_carries_into_the_next_year) :-
    acknowledgement_last_day(date(2026, 12, 15), date(2027, 1, 13), _).
test(last_day_carries_over_a_leap_february) :-
    acknowledgement_last_day(date(2028, 2, 10), date(2028, 3, 10), _).
test(last_day_carries_over_a_common_february) :-
    acknowledgement_last_day(date(2027, 2, 10), date(2027, 3, 11), _).
test(last_day_carries_over_a_century_february) :-
    acknowledgement_last_day(date(2100, 2, 10), date(2100, 3, 11), _).
test(an_impossible_day_is_wrong_type_once) :-
    findall(LastDay - Citations, acknowledgement_last_day(date(2027, 2, 29), LastDay, Citations), Answers),
    Answers == [input_problems([wrong_type(receipt_date)]) - []].
test(a_leap_day_is_a_valid_receipt) :-
    acknowledgement_last_day(date(2028, 2, 29), date(2028, 3, 29), _).
test(a_month_out_of_range_is_wrong_type) :-
    acknowledgement_last_day(date(2026, 13, 1), input_problems([wrong_type(receipt_date)]), []).
test(a_year_below_the_range_is_wrong_type) :-
    acknowledgement_last_day(date(1899, 12, 31), input_problems([wrong_type(receipt_date)]), []).
test(the_first_year_of_the_range_is_valid) :-
    acknowledgement_last_day(date(1900, 1, 1), acknowledgement_duty_does_not_apply, _).
test(a_year_above_the_range_is_wrong_type) :-
    acknowledgement_last_day(date(2200, 1, 1), input_problems([wrong_type(receipt_date)]), []).
test(the_last_year_of_the_range_is_valid) :-
    acknowledgement_last_day(date(2199, 12, 31), date(2200, 1, 29), _).
test(an_unbound_receipt_is_wrong_type_once) :-
    findall(LastDay, acknowledgement_last_day(_, LastDay, _), Answers),
    Answers == [input_problems([wrong_type(receipt_date)])].
test(a_non_integer_day_is_wrong_type) :-
    acknowledgement_last_day(date(2026, 6, a), input_problems([wrong_type(receipt_date)]), []).
test(a_well_formed_profile_has_no_problems) :-
    uk_complaints_to_the_commissioner_profile_for(gdpr_complaint_to_controller, Profile),
    findall(Problems, uk_complaints_to_the_commissioner_input_problems(Profile, Problems), Answers),
    Answers == [[]].
test(an_absent_key_is_not_a_problem) :-
    uk_complaints_to_the_commissioner_input_problems([], []).
test(a_non_list_profile_is_wrong_type) :-
    findall(Problems, uk_complaints_to_the_commissioner_input_problems(nothing, Problems), Answers),
    Answers == [[wrong_type(profile)]].
test(an_unbound_profile_is_wrong_type) :-
    findall(Problems, uk_complaints_to_the_commissioner_input_problems(_, Problems), Answers),
    Answers == [[wrong_type(profile)]].
test(a_partial_list_is_wrong_type) :-
    findall(Problems, uk_complaints_to_the_commissioner_input_problems([attribute(infringement_considered, uk_gdpr)|_], Problems), Answers),
    Answers == [[wrong_type(profile)]].
test(a_non_attribute_element_is_wrong_type) :-
    uk_complaints_to_the_commissioner_input_problems([attribute(infringement_considered, uk_gdpr), colour], [wrong_type(profile)]).
test(an_unbound_value_is_wrong_type) :-
    findall(Problems, uk_complaints_to_the_commissioner_input_problems([attribute(complaint_made_to_the_controller, _)], Problems), Answers),
    Answers == [[wrong_type(complaint_made_to_the_controller)]].
test(a_repeated_unknown_key_is_named_once) :-
    uk_complaints_to_the_commissioner_input_problems([attribute(colour, red), attribute(colour, blue)], [unknown_key(colour)]).
test(a_non_atom_key_is_unknown_as_given) :-
    uk_complaints_to_the_commissioner_input_problems([attribute(42, true)], [unknown_key(42)]).
test(an_unequal_duplicate_is_not_also_wrong_type) :-
    uk_complaints_to_the_commissioner_input_problems([attribute(complaint_made_to_the_controller, maybe), attribute(complaint_made_to_the_controller, true)], [duplicate_key(complaint_made_to_the_controller)]).
test(what_if_the_recipient_was_a_processor) :-
    uk_complaints_to_the_commissioner_profile_for(gdpr_complaint_to_controller, Profile),
    findall(Status, uk_complaints_to_the_commissioner_what_if(Profile, complaint_made_to_the_controller, false, Status), Statuses),
    Statuses == [not_a_complaint_under_section_164a].
test(what_if_part_4_were_uk_gdpr) :-
    uk_complaints_to_the_commissioner_profile_for(part_4_complaint_to_controller, Profile),
    uk_complaints_to_the_commissioner_what_if(Profile, infringement_considered, uk_gdpr, complaint_under_section_164a).
test(what_if_the_missing_recipient_is_stated) :-
    uk_complaints_to_the_commissioner_profile_for(recipient_not_stated, Profile),
    uk_complaints_to_the_commissioner_what_if(Profile, complaint_made_to_the_controller, true, complaint_under_section_164a).
test(what_if_a_bad_value_gives_input_problems) :-
    uk_complaints_to_the_commissioner_profile_for(gdpr_complaint_to_controller, Profile),
    uk_complaints_to_the_commissioner_what_if(Profile, complaint_made_to_the_controller, maybe, input_problems([wrong_type(complaint_made_to_the_controller)])).
test(the_profile_key_schema_is_the_contract_order) :-
    uk_complaints_to_the_commissioner_profile_keys(Keys),
    Keys == [complaint_by_data_subject_about_own_personal_data, infringement_considered, complaint_made_to_the_controller].
test(the_status_values_are_the_section_164a_atoms) :-
    uk_complaints_to_the_commissioner_status_values(StatusValues),
    StatusValues == [complaint_under_section_164a, not_a_complaint_under_section_164a].
test(the_decision_equals_the_controller_query) :-
    uk_complaints_to_the_commissioner_profile_for(part_3_complaint_to_controller, Profile),
    decide_uk_complaints_to_the_commissioner(Profile, uk_complaints_to_the_commissioner_verdict(Status, Citations)),
    controller_complaint_right(Profile, Status, Citations).

subject_is_resolvable(Subject) :-
    uk_complaints_to_the_commissioner_profile_for(Subject, Profile),
    uk_complaints_to_the_commissioner_decision_resolvable(Profile).

test(part_4_complaint_to_controller_is_not_positive, fail) :-
    uk_complaints_to_the_commissioner_assess(part_4_complaint_to_controller, uk_complaints_to_the_commissioner_verdict(complaint_under_section_164a, _)).
test(complaint_to_processor_is_not_positive, fail) :-
    uk_complaints_to_the_commissioner_assess(complaint_to_processor, uk_complaints_to_the_commissioner_verdict(complaint_under_section_164a, _)).
test(third_party_complaint_is_not_positive, fail) :-
    uk_complaints_to_the_commissioner_assess(third_party_complaint, uk_complaints_to_the_commissioner_verdict(complaint_under_section_164a, _)).
test(no_infringement_is_not_a_commission_complaint, fail) :-
    uk_complaints_to_the_commissioner_profile_for(no_infringement_considered, Profile),
    commission_complaint_right(Profile, complaint_under_section_165_2, _).
test(receipt_the_day_before_commencement_gives_no_date, fail) :-
    acknowledgement_last_day(date(2026, 6, 18), date(_, _, _), _).
test(receipt_on_commencement_day_is_not_exempt, fail) :-
    acknowledgement_last_day(date(2026, 6, 19), acknowledgement_duty_does_not_apply, _).

uk_complaints_to_the_commissioner_status_of(Subject, Status) :-
    uk_complaints_to_the_commissioner_profile_for(Subject, Profile),
    uk_complaints_to_the_commissioner_status(Profile, Status).

cp_test_names([every_subject_has_an_expectation, every_subject_resolves_to_its_expected_controller_answer_once, every_subject_resolves_to_its_expected_commission_answer_once, every_subject_assesses_to_its_expected_verdict_once, every_subject_has_a_non_empty_cited_checklist, every_subject_is_resolvable, gdpr_complaint_to_controller_is_a_complaint_under_section_164a, part_3_complaint_to_controller_is_a_complaint_under_section_164a, part_4_complaint_to_controller_is_not_a_complaint_under_section_164a, complaint_to_processor_is_not_a_complaint_under_section_164a, third_party_complaint_is_not_a_complaint_under_section_164a, no_infringement_considered_is_not_a_complaint_under_section_164a, recipient_not_stated_names_the_controller_key, empty_profile_names_the_first_key, badly_typed_profile_gives_input_problems, duplicated_key_profile_gives_duplicate_key, near_miss_part_4_flips_the_controller_verdict, near_miss_processor_flips_the_controller_verdict, near_miss_third_party_flips_the_commission_verdict, near_miss_no_infringement_flips_the_commission_verdict, commission_ignores_the_recipient_of_the_complaint, a_deciding_false_settles_before_a_missing_key, a_deciding_part_4_settles_the_controller_query, two_deciding_values_still_answer_once, positive_checklist_is_all_met_and_cited, processor_checklist_marks_the_recipient_unmet, recipient_not_stated_checklist_marks_the_key_unknown, receipt_on_commencement_day_gives_its_last_day_once, receipt_the_day_before_commencement_gives_no_duty_once, last_day_carries_into_the_next_year, last_day_carries_over_a_leap_february, last_day_carries_over_a_common_february, last_day_carries_over_a_century_february, an_impossible_day_is_wrong_type_once, a_leap_day_is_a_valid_receipt, a_month_out_of_range_is_wrong_type, a_year_below_the_range_is_wrong_type, the_first_year_of_the_range_is_valid, a_year_above_the_range_is_wrong_type, the_last_year_of_the_range_is_valid, an_unbound_receipt_is_wrong_type_once, a_non_integer_day_is_wrong_type, a_well_formed_profile_has_no_problems, an_absent_key_is_not_a_problem, a_non_list_profile_is_wrong_type, an_unbound_profile_is_wrong_type, a_partial_list_is_wrong_type, a_non_attribute_element_is_wrong_type, an_unbound_value_is_wrong_type, a_repeated_unknown_key_is_named_once, a_non_atom_key_is_unknown_as_given, an_unequal_duplicate_is_not_also_wrong_type, what_if_the_recipient_was_a_processor, what_if_part_4_were_uk_gdpr, what_if_the_missing_recipient_is_stated, what_if_a_bad_value_gives_input_problems, the_profile_key_schema_is_the_contract_order, the_status_values_are_the_section_164a_atoms, the_decision_equals_the_controller_query]).
cp_test_fail_names([part_4_complaint_to_controller_is_not_positive, complaint_to_processor_is_not_positive, third_party_complaint_is_not_positive, no_infringement_is_not_a_commission_complaint, receipt_the_day_before_commencement_gives_no_date, receipt_on_commencement_day_is_not_exempt]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
