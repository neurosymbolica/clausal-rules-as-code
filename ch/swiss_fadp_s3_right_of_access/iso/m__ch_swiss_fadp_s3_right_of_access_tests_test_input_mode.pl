% SPDX-License-Identifier: EUPL-1.2
:- module(m__ch_swiss_fadp_s3_right_of_access_tests_test_input_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__ch_swiss_fadp_s3_right_of_access_swiss_fadp_s3_right_of_access, [swiss_access_request_answer/3, swiss_access_cost_contribution/3, swiss_access_deadline/3, swiss_access_deadline_after_cost_notice/3, eu_access_response_deadline/3, compare_swiss_eu_access_deadline/5, swiss_fadp_s3_right_of_access_status/2]).
:- use_module(m__ch_swiss_fadp_s3_right_of_access_kernel, [swiss_fadp_s3_right_of_access_input_problems/2]).
:- use_module(m__ch_swiss_fadp_s3_right_of_access_fixtures, [swiss_fadp_s3_right_of_access_profile_for/2]).

subject_status(Subject, Status) :-
    swiss_fadp_s3_right_of_access_profile_for(Subject, Profile),
    swiss_fadp_s3_right_of_access_status(Profile, Status).

test(bound_obligation_holds) :-
    subject_status(written_request_no_ground, access_must_be_given).
test(bound_permission_holds_with_a_ground) :-
    subject_status(written_request_third_party_interests, access_may_be_refused_restricted_or_deferred).
test(bound_form_failure_holds) :-
    subject_status(oral_request_without_agreement, access_request_not_in_required_form).
test(bound_form_failure_holds_even_with_a_ground) :-
    subject_status(oral_request_without_agreement_with_ground, access_request_not_in_required_form).
test(bound_first_missing_key_holds) :-
    subject_status(empty_profile, indeterminate([request_form])).
test(bound_missing_category_holds) :-
    subject_status(category_absent_private_letter_only, indeterminate([controller_category])).
test(bound_citations_of_the_form_failure) :-
    swiss_fadp_s3_right_of_access_profile_for(oral_request_without_agreement, Profile),
    swiss_access_request_answer(Profile, access_request_not_in_required_form, [cite(ch_fadp_art_25_1), cite(ch_fadp_ord_art_16_1), cite(ch_fadp_ord_art_16_3)]).
test(bound_citations_of_the_obligation) :-
    swiss_fadp_s3_right_of_access_profile_for(written_request_no_ground, Profile),
    swiss_access_request_answer(Profile, access_must_be_given, [cite(ch_fadp_art_25_1), cite(ch_fadp_ord_art_16_1), cite(ch_fadp_ord_art_16_3), cite(ch_fadp_art_26_1), cite(ch_fadp_art_26_1_a), cite(ch_fadp_art_26_1_b), cite(ch_fadp_art_26_1_c), cite(ch_fadp_art_26_2), cite(ch_fadp_art_26_2_a), cite(ch_fadp_art_26_2_a_1), cite(ch_fadp_art_26_2_a_2), cite(ch_fadp_art_26_2_b), cite(ch_fadp_art_26_2_b_1), cite(ch_fadp_art_26_2_b_2), cite(ch_fadp_art_26_3), cite(ch_fadp_art_27_1), cite(ch_fadp_art_27_1_a), cite(ch_fadp_art_27_1_b), cite(ch_fadp_art_27_1_c), cite(ch_fadp_art_27_2)]).
test(bound_not_final_answer_has_no_citations) :-
    swiss_access_request_answer([], indeterminate([request_form]), []).
test(bound_free_of_charge_holds) :-
    swiss_access_cost_contribution([attribute(access_involves_disproportionate_effort, false)], access_free_of_charge, [cite(ch_fadp_art_25_6), cite(ch_fadp_ord_art_19_1)]).
test(bound_contribution_holds) :-
    swiss_access_cost_contribution([attribute(access_involves_disproportionate_effort, true)], cost_contribution_may_be_requested, [cite(ch_fadp_art_25_6), cite(ch_fadp_ord_art_19_1), cite(ch_fadp_ord_art_19_2), cite(ch_fadp_ord_art_19_3)]).
test(bound_swiss_deadline_holds) :-
    swiss_access_deadline(date(2026, 3, 1), date(2026, 3, 31), [cite(ch_fadp_art_25_7), cite(ch_fadp_ord_art_18_1)]).
test(bound_cost_notice_deadline_holds) :-
    swiss_access_deadline_after_cost_notice(date(2026, 3, 1), date(2026, 4, 10), [cite(ch_fadp_art_25_7), cite(ch_fadp_ord_art_18_1), cite(ch_fadp_ord_art_19_3)]).
test(bound_eu_deadline_holds) :-
    eu_access_response_deadline(date(2026, 10, 29), date(2026, 11, 30), [cite(eu_reg_2016_679_art_12_3), cite(eu_reg_1971_1182_art_3_1), cite(eu_reg_1971_1182_art_3_2_c), cite(eu_reg_1971_1182_art_3_4)]).
test(bound_comparison_same_holds) :-
    compare_swiss_eu_access_deadline(date(2026, 4, 15), date(2026, 5, 15), date(2026, 5, 15), same, []).
test(an_unbound_profile_is_not_an_attribute_list) :-
    findall(Result - Citations, swiss_access_request_answer(_, Result, Citations), Answers),
    Answers == [input_problems([wrong_type(profile)]) - []].
test(an_atom_profile_is_not_an_attribute_list) :-
    swiss_access_request_answer(nonsense, input_problems([wrong_type(profile)]), []).
test(a_list_with_a_stray_element_is_not_an_attribute_list) :-
    swiss_fadp_s3_right_of_access_input_problems([attribute(request_form, written), stray], [wrong_type(profile)]).
test(a_partial_list_is_not_an_attribute_list) :-
    findall(Problems, swiss_fadp_s3_right_of_access_input_problems([attribute(request_form, written)|_], Problems), Answers),
    Answers == [[wrong_type(profile)]].
test(a_list_with_an_unbound_element_is_not_an_attribute_list) :-
    findall(Problems, swiss_fadp_s3_right_of_access_input_problems([attribute(request_form, written), _], Problems), Answers),
    Answers == [[wrong_type(profile)]].
test(an_empty_profile_has_no_problem) :-
    swiss_fadp_s3_right_of_access_input_problems([], []).
test(an_unknown_key_is_named) :-
    swiss_access_request_answer([attribute(colour, red)], input_problems([unknown_key(colour)]), []).
test(a_number_key_is_an_unknown_key) :-
    swiss_fadp_s3_right_of_access_input_problems([attribute(42, true)], [unknown_key(42)]).
test(an_unknown_key_repeated_is_named_once) :-
    swiss_fadp_s3_right_of_access_input_problems([attribute(colour, red), attribute(colour, blue)], [unknown_key(colour)]).
test(an_unbound_value_is_a_wrong_type) :-
    findall(Problems, swiss_fadp_s3_right_of_access_input_problems([attribute(formal_law_provides_for_restriction, _)], Problems), Answers),
    Answers == [[wrong_type(formal_law_provides_for_restriction)]].
test(a_crisp_key_given_unsure_is_a_wrong_type) :-
    swiss_fadp_s3_right_of_access_input_problems([attribute(controller_agreed_to_oral_request, unsure)], [wrong_type(controller_agreed_to_oral_request)]).
test(a_judgement_given_unsure_is_well_formed) :-
    swiss_fadp_s3_right_of_access_input_problems([attribute(formal_law_provides_for_restriction, unsure)], []).
test(a_string_value_is_a_wrong_type) :-
    swiss_fadp_s3_right_of_access_input_problems([attribute(request_form, "written")], [wrong_type(request_form)]).
test(a_duplicate_key_is_named_once_and_not_typed) :-
    swiss_fadp_s3_right_of_access_input_problems([attribute(request_form, written), attribute(request_form, letter)], [duplicate_key(request_form)]).
test(problems_come_in_contract_order_then_unknown_keys) :-
    swiss_fadp_s3_right_of_access_input_problems([attribute(colour, red), attribute(controller_category, private_person), attribute(request_form, letter), attribute(controller_category, federal_body)], [wrong_type(request_form), duplicate_key(controller_category), unknown_key(colour)]).
test(the_cost_query_reports_a_problem_on_a_key_it_does_not_read) :-
    swiss_access_cost_contribution([attribute(request_form, letter), attribute(access_involves_disproportionate_effort, true)], input_problems([wrong_type(request_form)]), []).
test(an_unbound_receipt_date_is_refused) :-
    findall(Deadline - Citations, swiss_access_deadline(_, Deadline, Citations), Answers),
    Answers == [input_problems([wrong_type(receipt_date)]) - []].
test(an_atom_receipt_date_is_refused) :-
    eu_access_response_deadline('2026-03-01', input_problems([wrong_type(receipt_date)]), []).
test(a_thirteenth_month_is_refused) :-
    swiss_access_deadline(date(2026, 13, 1), input_problems([wrong_type(receipt_date)]), []).
test(a_nonexistent_leap_day_is_refused) :-
    eu_access_response_deadline(date(2026, 2, 29), input_problems([wrong_type(receipt_date)]), []).
test(a_real_leap_day_is_accepted) :-
    swiss_access_deadline(date(2028, 2, 29), date(2028, 3, 30), _).
test(a_year_before_the_bound_is_refused) :-
    swiss_access_deadline(date(1899, 12, 31), input_problems([wrong_type(receipt_date)]), []).
test(the_last_accepted_day_computes_into_2200) :-
    swiss_access_deadline_after_cost_notice(date(2199, 12, 31), date(2200, 2, 9), _).
test(a_cost_notice_date_problem_names_its_argument) :-
    swiss_access_deadline_after_cost_notice(date(2026, 4, 31), input_problems([wrong_type(cost_notice_date)]), []).
test(a_date_with_an_unbound_part_is_refused) :-
    findall(SwissDeadline - EuDeadline - Difference - ChangedBy, compare_swiss_eu_access_deadline(date(2026, _, 1), SwissDeadline, EuDeadline, Difference, ChangedBy), Answers),
    Answers == [input_problems([wrong_type(receipt_date)]) - input_problems([wrong_type(receipt_date)]) - input_problems([wrong_type(receipt_date)]) - []].

test(bound_permission_is_rejected_without_a_ground, fail) :-
    subject_status(written_request_no_ground, access_may_be_refused_restricted_or_deferred).
test(bound_form_failure_is_rejected_for_a_written_request, fail) :-
    subject_status(written_request_no_ground, access_request_not_in_required_form).
test(bound_obligation_is_rejected_with_a_ground, fail) :-
    subject_status(written_request_third_party_interests, access_must_be_given).
test(bound_permission_is_rejected_when_the_form_fails, fail) :-
    subject_status(oral_request_without_agreement_with_ground, access_may_be_refused_restricted_or_deferred).
test(bound_wrong_missing_key_is_rejected, fail) :-
    subject_status(empty_profile, indeterminate([controller_agreed_to_oral_request])).
test(bound_contribution_is_rejected_without_effort, fail) :-
    swiss_access_cost_contribution([attribute(access_involves_disproportionate_effort, false)], cost_contribution_may_be_requested, _).
test(bound_wrong_swiss_deadline_is_rejected, fail) :-
    swiss_access_deadline(date(2026, 3, 1), date(2026, 3, 30), _).
test(bound_comparison_same_is_not_swiss_earlier, fail) :-
    compare_swiss_eu_access_deadline(date(2026, 4, 15), _, _, swiss_earlier, _).

cp_test_names([bound_obligation_holds, bound_permission_holds_with_a_ground, bound_form_failure_holds, bound_form_failure_holds_even_with_a_ground, bound_first_missing_key_holds, bound_missing_category_holds, bound_citations_of_the_form_failure, bound_citations_of_the_obligation, bound_not_final_answer_has_no_citations, bound_free_of_charge_holds, bound_contribution_holds, bound_swiss_deadline_holds, bound_cost_notice_deadline_holds, bound_eu_deadline_holds, bound_comparison_same_holds, an_unbound_profile_is_not_an_attribute_list, an_atom_profile_is_not_an_attribute_list, a_list_with_a_stray_element_is_not_an_attribute_list, a_partial_list_is_not_an_attribute_list, a_list_with_an_unbound_element_is_not_an_attribute_list, an_empty_profile_has_no_problem, an_unknown_key_is_named, a_number_key_is_an_unknown_key, an_unknown_key_repeated_is_named_once, an_unbound_value_is_a_wrong_type, a_crisp_key_given_unsure_is_a_wrong_type, a_judgement_given_unsure_is_well_formed, a_string_value_is_a_wrong_type, a_duplicate_key_is_named_once_and_not_typed, problems_come_in_contract_order_then_unknown_keys, the_cost_query_reports_a_problem_on_a_key_it_does_not_read, an_unbound_receipt_date_is_refused, an_atom_receipt_date_is_refused, a_thirteenth_month_is_refused, a_nonexistent_leap_day_is_refused, a_real_leap_day_is_accepted, a_year_before_the_bound_is_refused, the_last_accepted_day_computes_into_2200, a_cost_notice_date_problem_names_its_argument, a_date_with_an_unbound_part_is_refused]).
cp_test_fail_names([bound_permission_is_rejected_without_a_ground, bound_form_failure_is_rejected_for_a_written_request, bound_obligation_is_rejected_with_a_ground, bound_permission_is_rejected_when_the_form_fails, bound_wrong_missing_key_is_rejected, bound_contribution_is_rejected_without_effort, bound_wrong_swiss_deadline_is_rejected, bound_comparison_same_is_not_swiss_earlier]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
