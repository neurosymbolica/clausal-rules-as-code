% SPDX-License-Identifier: EUPL-1.2
:- module(m__ind_dpdp_appeal_information_tests_test_public_interface, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_lists_extra, [clausal_msort/2]).
:- use_module(m__ind_dpdp_appeal_information_dpdp_appeal_information, [appeal_period/3, appeal_filing_requirements/3, appeal_disposal_target/3, information_call_status/3, non_disclosure_status/3, decide_dpdp_appeal_information/2, dpdp_appeal_information_status/2, dpdp_appeal_information_checklist/2, dpdp_appeal_information_decision_resolvable/1, dpdp_appeal_information_status_values/1]).
:- use_module(m__ind_dpdp_appeal_information_kernel, [dpdp_appeal_information_input_problems/2]).
:- use_module(m__ind_dpdp_appeal_information_fixtures, [dpdp_appeal_information_subject/1, dpdp_appeal_information_profile_for/2, dpdp_appeal_information_assess/2]).
:- use_module(m__ind_dpdp_appeal_information_queries, [needs_legal_review/2]).

expected_status(appeal_filed_on_last_day, eligible).
expected_status(appeal_filed_day_after_last_day, ineligible).
expected_status(appeal_across_year_on_last_day, eligible).
expected_status(appeal_across_year_day_after_last_day, ineligible).
expected_status(appeal_last_day_in_year_ten_thousand, eligible).
expected_status(section_29_not_in_force, ineligible).
expected_status(section_29_unstated, indeterminate).
expected_status(order_not_of_board, ineligible).
expected_status(appellant_not_aggrieved, ineligible).
expected_status(board_order_unsure, indeterminate).
expected_status(appellant_aggrieved_unsure, indeterminate).
expected_status(receipt_date_missing, indeterminate).
expected_status(filing_date_missing, indeterminate).
expected_status(filed_on_day_rules_start, eligible).
expected_status(filed_day_before_rules_start, eligible).
expected_status(disposed_within_target_leap_february, indeterminate).
expected_status(reference_on_target_day, indeterminate).
expected_status(reference_day_after_target_day, indeterminate).
expected_status(scheduled_call_on_day_rules_start, indeterminate).
expected_status(call_day_before_rules_start, indeterminate).
expected_status(call_to_board, indeterminate).
expected_status(call_to_other_recipient, indeterminate).
expected_status(section_36_not_in_force, indeterminate).
expected_status(call_outside_schedule, indeterminate).
expected_status(call_not_through_authorised_person, indeterminate).
expected_status(schedule_purpose_unsure, indeterminate).
expected_status(authorised_person_unsure, indeterminate).
expected_status(disclosure_barred, indeterminate).
expected_status(disclosure_permitted, indeterminate).
expected_status(non_disclosure_not_required, indeterminate).
expected_status(non_disclosure_call_before_rules, indeterminate).
expected_status(malformed_profile, indeterminate).
expected_status(duplicate_call_date, indeterminate).

near_miss_pair(appeal_filed_on_last_day, appeal_filed_day_after_last_day).
near_miss_pair(appeal_across_year_on_last_day, appeal_across_year_day_after_last_day).
near_miss_pair(appeal_filed_on_last_day, section_29_not_in_force).
near_miss_pair(appeal_filed_on_last_day, order_not_of_board).
near_miss_pair(appeal_filed_on_last_day, appellant_not_aggrieved).
near_miss_pair(appeal_filed_on_last_day, board_order_unsure).
near_miss_pair(appeal_filed_on_last_day, appellant_aggrieved_unsure).

subject_status(Subject, Status) :-
    dpdp_appeal_information_profile_for(Subject, Profile),
    dpdp_appeal_information_status(Profile, Status).

resolves_to_expected(Subject) :-
    expected_status(Subject, Expected),
    findall(Status, subject_status(Subject, Status), Statuses),
    Statuses == [Expected].

pair_differs(Positive - Control) :-
    subject_status(Positive, PositiveStatus),
    subject_status(Control, ControlStatus),
    PositiveStatus \== ControlStatus.

subject_result(Query, Subject, Result, Citations) :-
    dpdp_appeal_information_profile_for(Subject, Profile),
    call(Query, Profile, Result, Citations).

query_names([appeal_period, appeal_filing_requirements, appeal_disposal_target, information_call_status, non_disclosure_status]).

one_answer(Subject, Query) :-
    dpdp_appeal_information_profile_for(Subject, Profile),
    findall(Result - Citations, call(Query, Profile, Result, Citations), Answers),
    length(Answers, 1).

one_answer_each(Subject) :-
    query_names(Queries),
    maplist(one_answer(Subject), Queries).

well_formed_subject(Subject) :-
    dpdp_appeal_information_subject(Subject),
    dpdp_appeal_information_profile_for(Subject, Profile),
    dpdp_appeal_information_input_problems(Profile, []).

item_cited(item(_RequirementName, _ItemStatus, cite(_CitationKey))).

item_met(item(_RequirementName, met, cite(_CitationKey))).

has_cited_checklist(Subject) :-
    dpdp_appeal_information_profile_for(Subject, Profile),
    dpdp_appeal_information_checklist(Profile, [FirstItem|OtherItems]),
    maplist(item_cited, [FirstItem|OtherItems]).

is_resolvable(Subject) :-
    dpdp_appeal_information_profile_for(Subject, Profile),
    dpdp_appeal_information_decision_resolvable(Profile).

test(every_subject_resolves_to_its_expected_verdict) :-
    findall(Subject, dpdp_appeal_information_subject(Subject), Subjects),
    Subjects = [_|_],
    maplist(resolves_to_expected, Subjects).
test(every_subject_has_one_profile) :-
    findall(Subject, dpdp_appeal_information_subject(Subject), Subjects),
    findall(Subject, (dpdp_appeal_information_subject(Subject), dpdp_appeal_information_profile_for(Subject, _)), Profiled),
    Subjects == Profiled.
test(near_miss_controls_get_the_opposite_verdict) :-
    findall(Positive - Control, near_miss_pair(Positive, Control), Pairs),
    maplist(pair_differs, Pairs).
test(filed_on_last_day_is_eligible) :-
    dpdp_appeal_information_assess(appeal_filed_on_last_day, dpdp_appeal_information_verdict(eligible, Citations)),
    clausal_msort(Citations, [cite(in_dpdp_act_2023_s_29_1), cite(in_dpdp_act_2023_s_29_2)]).
test(filed_day_after_last_day_is_ineligible) :-
    dpdp_appeal_information_assess(appeal_filed_day_after_last_day, dpdp_appeal_information_verdict(ineligible, _)).
test(an_unsure_judgement_is_indeterminate_with_no_citations) :-
    dpdp_appeal_information_assess(board_order_unsure, dpdp_appeal_information_verdict(indeterminate, [])).
test(the_status_values_are_the_three_verdicts) :-
    dpdp_appeal_information_status_values([eligible, ineligible, indeterminate]).
test(every_subject_is_resolvable) :-
    findall(Subject, dpdp_appeal_information_subject(Subject), Subjects),
    maplist(is_resolvable, Subjects).
test(appeal_on_last_day_is_in_time) :-
    subject_result(appeal_period, appeal_filed_on_last_day, in_time(date(2027, 3, 11)), Citations),
    clausal_msort(Citations, [cite(in_dpdp_act_2023_s_29_1), cite(in_dpdp_act_2023_s_29_2)]).
test(appeal_day_after_last_day_needs_sufficient_cause) :-
    subject_result(appeal_period, appeal_filed_day_after_last_day, out_of_time_sufficient_cause_needed(date(2027, 3, 11)), Citations),
    clausal_msort(Citations, [cite(in_dpdp_act_2023_s_29_2), cite(in_dpdp_act_2023_s_29_3)]).
test(appeal_across_year_on_last_day_is_in_time) :-
    subject_result(appeal_period, appeal_across_year_on_last_day, in_time(date(2028, 1, 30)), _).
test(appeal_across_year_day_after_is_out_of_time) :-
    subject_result(appeal_period, appeal_across_year_day_after_last_day, out_of_time_sufficient_cause_needed(date(2028, 1, 30)), _).
test(last_day_may_fall_in_year_ten_thousand) :-
    subject_result(appeal_period, appeal_last_day_in_year_ten_thousand, in_time(date(10000, 2, 29)), _).
test(section_29_not_in_force_settles_first) :-
    subject_result(appeal_period, section_29_not_in_force, not_in_force, [cite(in_dpdp_act_2023_s_29_1)]).
test(section_29_unstated_is_named) :-
    subject_result(appeal_period, section_29_unstated, indeterminate([section_29_in_force_on_filing_date]), []).
test(not_a_board_order_is_not_appealable) :-
    subject_result(appeal_period, order_not_of_board, not_appealable, [cite(in_dpdp_act_2023_s_29_1)]).
test(not_aggrieved_is_not_appealable) :-
    subject_result(appeal_period, appellant_not_aggrieved, not_appealable, [cite(in_dpdp_act_2023_s_29_1)]).
test(board_order_unsure_goes_to_a_lawyer) :-
    subject_result(appeal_period, board_order_unsure, needs_legal_review(open_textured(appeal_against_board_order_or_direction, cite(in_dpdp_act_2023_s_29_1)), [inputs_relied_on([appeal_against_board_order_or_direction - unsure, appellant_aggrieved - true])]), []).
test(appellant_unsure_goes_to_a_lawyer) :-
    subject_result(appeal_period, appellant_aggrieved_unsure, needs_legal_review(open_textured(appellant_aggrieved, cite(in_dpdp_act_2023_s_29_1)), [inputs_relied_on([appeal_against_board_order_or_direction - true, appellant_aggrieved - unsure])]), []).
test(missing_receipt_date_is_named) :-
    subject_result(appeal_period, receipt_date_missing, indeterminate([order_receipt_date]), []).
test(missing_filing_date_is_named) :-
    subject_result(appeal_period, filing_date_missing, indeterminate([appeal_filing_date]), []).
test(filing_on_rules_start_day_lists_the_three_items) :-
    subject_result(appeal_filing_requirements, filed_on_day_rules_start, filing_requirements([digital_form, fee_as_for_trai_act_appeal_unless_reduced_or_waived, fee_paid_by_upi_or_rbi_authorised_payment_system]), Citations),
    clausal_msort(Citations, Sorted),
    clausal_msort([cite(in_dpdp_act_2023_s_29_2), cite(in_dpdp_rules_2025_r_22_1), cite(in_dpdp_rules_2025_r_22_2), cite(in_dpdp_rules_2025_r_1_4)], Sorted).
test(filing_day_before_rules_start_is_not_yet_prescribed) :-
    subject_result(appeal_filing_requirements, filed_day_before_rules_start, not_yet_prescribed, Citations),
    clausal_msort(Citations, Sorted),
    clausal_msort([cite(in_dpdp_act_2023_s_29_2), cite(in_dpdp_rules_2025_r_1_4)], Sorted).
test(filing_requirements_when_section_29_not_in_force) :-
    subject_result(appeal_filing_requirements, section_29_not_in_force, not_in_force, [cite(in_dpdp_act_2023_s_29_2)]).
test(disposed_within_target_reaches_leap_february) :-
    subject_result(appeal_disposal_target, disposed_within_target_leap_february, disposed_within_target(date(2028, 2, 29)), [cite(in_dpdp_act_2023_s_29_6)]).
test(reference_on_target_day_has_not_passed) :-
    subject_result(appeal_disposal_target, reference_on_target_day, disposal_target_not_yet_passed(date(2027, 9, 11)), [cite(in_dpdp_act_2023_s_29_6)]).
test(reference_day_after_target_requires_reasons) :-
    subject_result(appeal_disposal_target, reference_day_after_target_day, reasons_in_writing_required(date(2027, 9, 11)), Citations),
    clausal_msort(Citations, [cite(in_dpdp_act_2023_s_29_6), cite(in_dpdp_act_2023_s_29_7)]).
test(scheduled_call_on_rules_start_day_must_be_answered_in_period) :-
    subject_result(information_call_status, scheduled_call_on_day_rules_start, required_to_furnish_within_specified_period, Citations),
    clausal_msort(Citations, Sorted),
    clausal_msort([cite(in_dpdp_act_2023_s_36), cite(in_dpdp_rules_2025_r_23_1), cite(in_dpdp_rules_2025_r_1_4), cite(in_dpdp_rules_2025_sch_7_1), cite(in_dpdp_rules_2025_sch_7_2), cite(in_dpdp_rules_2025_sch_7_2_i), cite(in_dpdp_rules_2025_sch_7_2_ii), cite(in_dpdp_rules_2025_sch_7_3)], Sorted).
test(call_day_before_rules_start_binds_under_section_36) :-
    subject_result(information_call_status, call_day_before_rules_start, required_to_furnish_under_section_36, [cite(in_dpdp_act_2023_s_36)]).
test(the_board_furnishes_under_section_36) :-
    subject_result(information_call_status, call_to_board, required_to_furnish_under_section_36, [cite(in_dpdp_act_2023_s_36)]).
test(other_recipient_is_not_covered) :-
    subject_result(information_call_status, call_to_other_recipient, not_covered, Citations),
    clausal_msort(Citations, Sorted),
    clausal_msort([cite(in_dpdp_act_2023_s_36), cite(in_dpdp_rules_2025_r_23_1)], Sorted).
test(section_36_not_in_force_settles_the_call) :-
    subject_result(information_call_status, section_36_not_in_force, not_in_force, [cite(in_dpdp_act_2023_s_36)]).
test(call_outside_schedule_is_referred) :-
    subject_result(information_call_status, call_outside_schedule, needs_legal_review(not_governed_here([cite(in_dpdp_rules_2025_r_23_1), cite(in_dpdp_act_2023_s_36)]), [inputs_relied_on([call_for_seventh_schedule_purpose - false, called_through_authorised_person - true])]), []).
test(call_not_through_authorised_person_is_referred) :-
    subject_result(information_call_status, call_not_through_authorised_person, needs_legal_review(not_governed_here([cite(in_dpdp_rules_2025_r_23_1), cite(in_dpdp_act_2023_s_36)]), [inputs_relied_on([call_for_seventh_schedule_purpose - true, called_through_authorised_person - false])]), []).
test(schedule_purpose_unsure_goes_to_a_lawyer) :-
    subject_result(information_call_status, schedule_purpose_unsure, needs_legal_review(open_textured(call_for_seventh_schedule_purpose, cite(in_dpdp_rules_2025_r_23_1)), [inputs_relied_on([call_for_seventh_schedule_purpose - unsure, called_through_authorised_person - true])]), []).
test(authorised_person_unsure_goes_to_a_lawyer) :-
    subject_result(information_call_status, authorised_person_unsure, needs_legal_review(open_textured(called_through_authorised_person, cite(in_dpdp_rules_2025_r_23_1)), [inputs_relied_on([call_for_seventh_schedule_purpose - true, called_through_authorised_person - unsure])]), []).
test(disclosure_is_barred_without_permission) :-
    subject_result(non_disclosure_status, disclosure_barred, disclosure_barred_without_written_permission, [cite(in_dpdp_rules_2025_r_23_2)]).
test(disclosure_is_permitted_with_permission) :-
    subject_result(non_disclosure_status, disclosure_permitted, disclosure_permitted_by_written_permission, [cite(in_dpdp_rules_2025_r_23_2)]).
test(no_requirement_means_not_barred) :-
    subject_result(non_disclosure_status, non_disclosure_not_required, not_barred_by_rule_23, [cite(in_dpdp_rules_2025_r_23_2)]).
test(call_before_rule_23_starts_is_not_in_force) :-
    subject_result(non_disclosure_status, non_disclosure_call_before_rules, not_in_force, Citations),
    clausal_msort(Citations, Sorted),
    clausal_msort([cite(in_dpdp_act_2023_s_36), cite(in_dpdp_rules_2025_r_23_2), cite(in_dpdp_rules_2025_r_1_4)], Sorted).
test(the_board_is_not_barred_by_rule_23) :-
    subject_result(non_disclosure_status, call_to_board, not_barred_by_rule_23, [cite(in_dpdp_rules_2025_r_23_2)]).
test(needs_legal_review_takes_a_referral_context) :-
    needs_legal_review(not_governed_here([cite(in_dpdp_rules_2025_r_23_1), cite(in_dpdp_act_2023_s_36)]), [inputs_relied_on([call_for_seventh_schedule_purpose - false])]).
test(malformed_profile_lists_its_problems_in_order) :-
    dpdp_appeal_information_profile_for(malformed_profile, Profile),
    dpdp_appeal_information_input_problems(Profile, [wrong_type(appellant_aggrieved), unknown_key(colour)]).
test(malformed_profile_is_answered_with_its_problems) :-
    subject_result(appeal_period, malformed_profile, input_problems([wrong_type(appellant_aggrieved), unknown_key(colour)]), []).
test(duplicate_key_is_an_input_problem_for_every_query) :-
    query_names(Queries),
    maplist(duplicate_answer, Queries).
test(a_non_list_profile_is_wrong_type) :-
    dpdp_appeal_information_input_problems(not_a_profile, [wrong_type(profile)]).
test(only_the_two_malformed_subjects_have_problems) :-
    findall(Subject, dpdp_appeal_information_subject(Subject), Subjects),
    findall(Subject, well_formed_subject(Subject), WellFormed),
    length(Subjects, Total),
    length(WellFormed, WellFormedCount),
    WellFormedCount =:= Total - 2.
test(every_well_formed_subject_has_a_cited_checklist) :-
    findall(Subject, well_formed_subject(Subject), Subjects),
    Subjects = [_|_],
    maplist(has_cited_checklist, Subjects).
test(an_eligible_subject_meets_every_item) :-
    dpdp_appeal_information_profile_for(appeal_filed_on_last_day, Profile),
    dpdp_appeal_information_checklist(Profile, Items),
    length(Items, 4),
    maplist(item_met, Items).
test(a_late_appeal_fails_the_sixty_day_item) :-
    dpdp_appeal_information_profile_for(appeal_filed_day_after_last_day, Profile),
    dpdp_appeal_information_checklist(Profile, Items),
    member(item(filed_within_sixty_days, unmet(filed_after_last_day), cite(in_dpdp_act_2023_s_29_2)), Items).
test(an_unsure_judgement_is_an_unknown_item) :-
    dpdp_appeal_information_profile_for(board_order_unsure, Profile),
    dpdp_appeal_information_checklist(Profile, Items),
    member(item(board_order_or_direction, unknown([appeal_against_board_order_or_direction]), cite(in_dpdp_act_2023_s_29_1)), Items).
test(every_query_yields_one_solution_for_every_subject) :-
    findall(Subject, dpdp_appeal_information_subject(Subject), Subjects),
    maplist(one_answer_each, Subjects).

test(filed_day_after_last_day_is_not_eligible, fail) :-
    dpdp_appeal_information_assess(appeal_filed_day_after_last_day, dpdp_appeal_information_verdict(eligible, _)).
test(appeal_day_after_last_day_is_not_in_time, fail) :-
    subject_result(appeal_period, appeal_filed_day_after_last_day, in_time(_), _).
test(filing_day_before_rules_start_lists_no_items, fail) :-
    subject_result(appeal_filing_requirements, filed_day_before_rules_start, filing_requirements(_), _).
test(reference_day_after_target_has_not_still_running, fail) :-
    subject_result(appeal_disposal_target, reference_day_after_target_day, disposal_target_not_yet_passed(_), _).
test(call_day_before_rules_start_is_not_under_rule_23, fail) :-
    subject_result(information_call_status, call_day_before_rules_start, required_to_furnish_within_specified_period, _).
test(disclosure_with_permission_is_not_barred, fail) :-
    subject_result(non_disclosure_status, disclosure_permitted, disclosure_barred_without_written_permission, _).
test(a_late_appeal_does_not_meet_every_item, fail) :-
    dpdp_appeal_information_profile_for(appeal_filed_day_after_last_day, Profile),
    dpdp_appeal_information_checklist(Profile, Items),
    maplist(item_met, Items).

duplicate_answer(Query) :-
    subject_result(Query, duplicate_call_date, input_problems([duplicate_key(call_date)]), []).

cp_test_names([every_subject_resolves_to_its_expected_verdict, every_subject_has_one_profile, near_miss_controls_get_the_opposite_verdict, filed_on_last_day_is_eligible, filed_day_after_last_day_is_ineligible, an_unsure_judgement_is_indeterminate_with_no_citations, the_status_values_are_the_three_verdicts, every_subject_is_resolvable, appeal_on_last_day_is_in_time, appeal_day_after_last_day_needs_sufficient_cause, appeal_across_year_on_last_day_is_in_time, appeal_across_year_day_after_is_out_of_time, last_day_may_fall_in_year_ten_thousand, section_29_not_in_force_settles_first, section_29_unstated_is_named, not_a_board_order_is_not_appealable, not_aggrieved_is_not_appealable, board_order_unsure_goes_to_a_lawyer, appellant_unsure_goes_to_a_lawyer, missing_receipt_date_is_named, missing_filing_date_is_named, filing_on_rules_start_day_lists_the_three_items, filing_day_before_rules_start_is_not_yet_prescribed, filing_requirements_when_section_29_not_in_force, disposed_within_target_reaches_leap_february, reference_on_target_day_has_not_passed, reference_day_after_target_requires_reasons, scheduled_call_on_rules_start_day_must_be_answered_in_period, call_day_before_rules_start_binds_under_section_36, the_board_furnishes_under_section_36, other_recipient_is_not_covered, section_36_not_in_force_settles_the_call, call_outside_schedule_is_referred, call_not_through_authorised_person_is_referred, schedule_purpose_unsure_goes_to_a_lawyer, authorised_person_unsure_goes_to_a_lawyer, disclosure_is_barred_without_permission, disclosure_is_permitted_with_permission, no_requirement_means_not_barred, call_before_rule_23_starts_is_not_in_force, the_board_is_not_barred_by_rule_23, needs_legal_review_takes_a_referral_context, malformed_profile_lists_its_problems_in_order, malformed_profile_is_answered_with_its_problems, duplicate_key_is_an_input_problem_for_every_query, a_non_list_profile_is_wrong_type, only_the_two_malformed_subjects_have_problems, every_well_formed_subject_has_a_cited_checklist, an_eligible_subject_meets_every_item, a_late_appeal_fails_the_sixty_day_item, an_unsure_judgement_is_an_unknown_item, every_query_yields_one_solution_for_every_subject]).
cp_test_fail_names([filed_day_after_last_day_is_not_eligible, appeal_day_after_last_day_is_not_in_time, filing_day_before_rules_start_lists_no_items, reference_day_after_target_has_not_still_running, call_day_before_rules_start_is_not_under_rule_23, disclosure_with_permission_is_not_barred, a_late_appeal_does_not_meet_every_item]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
