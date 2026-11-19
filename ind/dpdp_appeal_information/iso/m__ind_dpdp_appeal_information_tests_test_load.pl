% SPDX-License-Identifier: EUPL-1.2
:- module(m__ind_dpdp_appeal_information_tests_test_load, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__ind_dpdp_appeal_information_kernel, [dpdp_appeal_information_input_problems/2]).
:- use_module(m__ind_dpdp_appeal_information_citations, [citation/2, implements/1]).

test(the_in_time_term_carries_its_last_day) :-
    Result = in_time(date(2027, 3, 11)),
    Result = in_time(LastDay),
    LastDay == date(2027, 3, 11).
test(the_out_of_time_term_carries_its_last_day) :-
    Result = out_of_time_sufficient_cause_needed(date(2028, 1, 30)),
    Result = out_of_time_sufficient_cause_needed(LastDay),
    LastDay == date(2028, 1, 30).
test(the_filing_requirements_term_carries_its_items_in_order) :-
    Result = filing_requirements([digital_form, fee_as_for_trai_act_appeal_unless_reduced_or_waived, fee_paid_by_upi_or_rbi_authorised_payment_system]),
    Result = filing_requirements(Items),
    Items == [digital_form, fee_as_for_trai_act_appeal_unless_reduced_or_waived, fee_paid_by_upi_or_rbi_authorised_payment_system].
test(the_disposal_target_terms_carry_their_target_day) :-
    Within = disposed_within_target(date(2027, 9, 11)),
    Within = disposed_within_target(WithinDay),
    WithinDay == date(2027, 9, 11),
    Running = disposal_target_not_yet_passed(date(2028, 2, 29)),
    Running = disposal_target_not_yet_passed(RunningDay),
    RunningDay == date(2028, 2, 29),
    Passed = reasons_in_writing_required(date(2029, 2, 28)),
    Passed = reasons_in_writing_required(PassedDay),
    PassedDay == date(2029, 2, 28).
test(the_indeterminate_term_names_one_key) :-
    Result = indeterminate([section_29_in_force_on_filing_date]),
    Result = indeterminate([MissingKey]),
    MissingKey == section_29_in_force_on_filing_date.
test(the_open_textured_referral_destructures) :-
    Result = needs_legal_review(open_textured(appellant_aggrieved, cite(in_dpdp_act_2023_s_29_1)), [inputs_relied_on([appeal_against_board_order_or_direction - true, appellant_aggrieved - unsure])]),
    Result = needs_legal_review(open_textured(Input, Citation), [inputs_relied_on(Pairs)]),
    Input == appellant_aggrieved,
    Citation == cite(in_dpdp_act_2023_s_29_1),
    Pairs == [appeal_against_board_order_or_direction - true, appellant_aggrieved - unsure].
test(the_not_governed_here_referral_destructures) :-
    Result = needs_legal_review(not_governed_here([cite(in_dpdp_rules_2025_r_23_1), cite(in_dpdp_act_2023_s_36)]), [inputs_relied_on([call_for_seventh_schedule_purpose - false])]),
    Result = needs_legal_review(not_governed_here(Citations), [inputs_relied_on(Pairs)]),
    Citations == [cite(in_dpdp_rules_2025_r_23_1), cite(in_dpdp_act_2023_s_36)],
    Pairs == [call_for_seventh_schedule_purpose - false].
test(the_appeal_period_atoms_are_distinct) :-
    dif(not_appealable, not_in_force).
test(the_filing_atoms_are_distinct) :-
    dif(not_yet_prescribed, not_in_force).
test(the_information_call_atoms_are_distinct) :-
    dif(required_to_furnish_within_specified_period, required_to_furnish_under_section_36),
    dif(required_to_furnish_under_section_36, not_covered),
    dif(not_covered, not_in_force).
test(the_non_disclosure_atoms_are_distinct) :-
    dif(disclosure_barred_without_written_permission, disclosure_permitted_by_written_permission),
    dif(disclosure_permitted_by_written_permission, not_barred_by_rule_23),
    dif(not_barred_by_rule_23, not_in_force).
test(the_recipient_kinds_are_distinct) :-
    dif(data_fiduciary_or_intermediary, board),
    dif(board, other_recipient),
    dif(data_fiduciary_or_intermediary, other_recipient).
test(the_section_29_1_citation_is_recorded) :-
    citation(in_dpdp_act_2023_s_29_1, _Record).
test(the_section_36_citation_is_recorded) :-
    citation(in_dpdp_act_2023_s_36, _Record).
test(the_rule_1_4_citation_is_recorded) :-
    citation(in_dpdp_rules_2025_r_1_4, _Record).
test(the_citation_record_has_label_ref_verbatim) :-
    citation(in_dpdp_rules_2025_r_23_2, [label - _Label, ref - _Reference, verbatim - _Verbatim]).
test(a_recorded_key_is_implemented) :-
    implements(in_dpdp_rules_2025_sch_7_3).
test(an_empty_profile_has_no_problem) :-
    findall(Problems, dpdp_appeal_information_input_problems([], Problems), Answers),
    Answers == [[]].
test(a_well_formed_profile_has_no_problem) :-
    dpdp_appeal_information_input_problems([attribute(section_29_in_force_on_filing_date, true), attribute(appellant_aggrieved, unsure), attribute(order_receipt_date, date(2027, 1, 10)), attribute(recipient_kind, board)], []).
test(an_unknown_key_is_named) :-
    dpdp_appeal_information_input_problems([attribute(colour, red)], [unknown_key(colour)]).
test(a_wrong_judgement_value_is_named) :-
    dpdp_appeal_information_input_problems([attribute(appellant_aggrieved, maybe)], [wrong_type(appellant_aggrieved)]).
test(an_unsure_crisp_key_is_wrong_type) :-
    dpdp_appeal_information_input_problems([attribute(non_disclosure_required, unsure)], [wrong_type(non_disclosure_required)]).
test(a_day_that_does_not_exist_is_wrong_type) :-
    dpdp_appeal_information_input_problems([attribute(call_date, date(2027, 2, 29))], [wrong_type(call_date)]).
test(a_leap_day_is_a_real_day) :-
    dpdp_appeal_information_input_problems([attribute(call_date, date(2028, 2, 29))], []).
test(a_repeated_key_is_duplicate) :-
    dpdp_appeal_information_input_problems([attribute(recipient_kind, board), attribute(recipient_kind, board)], [duplicate_key(recipient_kind)]).
test(a_term_that_is_not_an_attribute_list_is_wrong_type_profile) :-
    dpdp_appeal_information_input_problems(not_a_profile, [wrong_type(profile)]).

test(an_unrecorded_key_is_not_implemented, fail) :-
    implements(ind_todo_primary_source).
test(a_well_formed_profile_is_not_flagged, fail) :-
    dpdp_appeal_information_input_problems([attribute(section_29_in_force_on_filing_date, true)], [_|_]).

cp_test_names([the_in_time_term_carries_its_last_day, the_out_of_time_term_carries_its_last_day, the_filing_requirements_term_carries_its_items_in_order, the_disposal_target_terms_carry_their_target_day, the_indeterminate_term_names_one_key, the_open_textured_referral_destructures, the_not_governed_here_referral_destructures, the_appeal_period_atoms_are_distinct, the_filing_atoms_are_distinct, the_information_call_atoms_are_distinct, the_non_disclosure_atoms_are_distinct, the_recipient_kinds_are_distinct, the_section_29_1_citation_is_recorded, the_section_36_citation_is_recorded, the_rule_1_4_citation_is_recorded, the_citation_record_has_label_ref_verbatim, a_recorded_key_is_implemented, an_empty_profile_has_no_problem, a_well_formed_profile_has_no_problem, an_unknown_key_is_named, a_wrong_judgement_value_is_named, an_unsure_crisp_key_is_wrong_type, a_day_that_does_not_exist_is_wrong_type, a_leap_day_is_a_real_day, a_repeated_key_is_duplicate, a_term_that_is_not_an_attribute_list_is_wrong_type_profile]).
cp_test_fail_names([an_unrecorded_key_is_not_implemented, a_well_formed_profile_is_not_flagged]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
