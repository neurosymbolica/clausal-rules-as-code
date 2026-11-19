% SPDX-License-Identifier: EUPL-1.2
:- module(m__ind_dpdp_transfer_tests_test_input_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__ind_dpdp_transfer_queries, [restriction_status/4]).
:- use_module(m__ind_dpdp_transfer_kernel, [dpdp_transfer_input_problems/2]).
:- use_module(m__ind_dpdp_transfer_fixtures, [dpdp_transfer_profile_for/2]).

test(bound_restricted_see_notification_holds) :-
    dpdp_transfer_profile_for(notified_destination_restricted, restriction_request(Restriction, Profile)),
    restriction_status(Restriction, Profile, restricted_see_notification, [cite(in_dpdp_act_2023_s_16_1)]).
test(bound_requirements_apply_see_order_holds) :-
    dpdp_transfer_profile_for(foreign_state_requirements_apply_on_commencement_day, restriction_request(Restriction, Profile)),
    restriction_status(Restriction, Profile, requirements_apply_see_order, [cite(in_dpdp_rules_2025_r_15)]).
test(bound_not_in_force_holds_day_before) :-
    dpdp_transfer_profile_for(foreign_state_day_before_commencement, restriction_request(Restriction, Profile)),
    restriction_status(Restriction, Profile, not_in_force, _).
test(bound_indeterminate_names_reference_date) :-
    dpdp_transfer_profile_for(foreign_state_reference_date_unstated, restriction_request(Restriction, Profile)),
    restriction_status(Restriction, Profile, indeterminate([reference_date]), []).
test(empty_profile_has_no_problem) :-
    findall(Problems, dpdp_transfer_input_problems([], Problems), Answers),
    Answers == [[]].
test(unbound_profile_is_wrong_type) :-
    findall(Problems, dpdp_transfer_input_problems(_Profile, Problems), Answers),
    Answers == [[wrong_type(profile)]].
test(partial_list_is_wrong_type) :-
    findall(Problems, dpdp_transfer_input_problems([attribute(reference_date, date(2027, 5, 13))|_Rest], Problems), Answers),
    Answers == [[wrong_type(profile)]].
test(unbound_element_is_wrong_type) :-
    findall(Problems, dpdp_transfer_input_problems([_Element], Problems), Answers),
    Answers == [[wrong_type(profile)]].
test(non_attribute_element_is_wrong_type_alone) :-
    findall(Problems, dpdp_transfer_input_problems([attribute(colour, blue), section_16_in_force_on_reference_date - true], Problems), Answers),
    Answers == [[wrong_type(profile)]].
test(atom_profile_is_wrong_type) :-
    findall(Problems, dpdp_transfer_input_problems(not_a_list, Problems), Answers),
    Answers == [[wrong_type(profile)]].
test(unbound_value_is_wrong_type) :-
    findall(Problems, dpdp_transfer_input_problems([attribute(foreign_state_requirements_specified, _Value)], Problems), Answers),
    Answers == [[wrong_type(foreign_state_requirements_specified)]].
test(number_key_is_unknown) :-
    findall(Problems, dpdp_transfer_input_problems([attribute(42, true)], Problems), Answers),
    Answers == [[unknown_key(42)]].
test(compound_key_is_unknown) :-
    findall(Problems, dpdp_transfer_input_problems([attribute(key(reference_date), true)], Problems), Answers),
    Answers == [[unknown_key(key(reference_date))]].
test(unknown_key_named_once) :-
    findall(Problems, dpdp_transfer_input_problems([attribute(colour, blue), attribute(colour, red)], Problems), Answers),
    Answers == [[unknown_key(colour)]].
test(duplicate_key_reads_no_value) :-
    findall(Problems, dpdp_transfer_input_problems([attribute(reference_date, date(2027, 5, 13)), attribute(reference_date, not_a_date)], Problems), Answers),
    Answers == [[duplicate_key(reference_date)]].
test(problems_in_contract_order_then_unknown) :-
    findall(Problems, dpdp_transfer_input_problems([attribute(colour, blue), attribute(reference_date, date(2027, 2, 29)), attribute(section_16_in_force_on_reference_date, unsure)], Problems), Answers),
    Answers == [[wrong_type(section_16_in_force_on_reference_date), wrong_type(reference_date), unknown_key(colour)]].
test(judgement_accepts_unsure) :-
    findall(Problems, dpdp_transfer_input_problems([attribute(destination_restricted_by_notification, unsure), attribute(recipient_is_foreign_state_or_its_entity, unsure)], Problems), Answers),
    Answers == [[]].
test(crisp_rejects_unsure) :-
    findall(Problems, dpdp_transfer_input_problems([attribute(foreign_state_requirements_specified, unsure)], Problems), Answers),
    Answers == [[wrong_type(foreign_state_requirements_specified)]].
test(judgement_rejects_other_atom) :-
    findall(Problems, dpdp_transfer_input_problems([attribute(recipient_is_foreign_state_or_its_entity, yes)], Problems), Answers),
    Answers == [[wrong_type(recipient_is_foreign_state_or_its_entity)]].
test(year_zero_is_wrong_type) :-
    findall(Problems, dpdp_transfer_input_problems([attribute(reference_date, date(0, 1, 1))], Problems), Answers),
    Answers == [[wrong_type(reference_date)]].
test(month_thirteen_is_wrong_type) :-
    findall(Problems, dpdp_transfer_input_problems([attribute(reference_date, date(2027, 13, 1))], Problems), Answers),
    Answers == [[wrong_type(reference_date)]].
test(float_year_is_wrong_type) :-
    findall(Problems, dpdp_transfer_input_problems([attribute(reference_date, date(2027.0, 5, 13))], Problems), Answers),
    Answers == [[wrong_type(reference_date)]].
test(century_non_leap_day_is_wrong_type) :-
    findall(Problems, dpdp_transfer_input_problems([attribute(reference_date, date(1900, 2, 29))], Problems), Answers),
    Answers == [[wrong_type(reference_date)]].
test(four_century_leap_day_is_real) :-
    findall(Problems, dpdp_transfer_input_problems([attribute(reference_date, date(2000, 2, 29))], Problems), Answers),
    Answers == [[]].
test(date_list_is_wrong_type) :-
    findall(Problems, dpdp_transfer_input_problems([attribute(reference_date, [2027, 5, 13])], Problems), Answers),
    Answers == [[wrong_type(reference_date)]].
test(unread_key_is_still_checked) :-
    findall(Result - Citations, restriction_status(notified_destination, [attribute(section_16_in_force_on_reference_date, true), attribute(destination_restricted_by_notification, true), attribute(reference_date, date(2027, 2, 29))], Result, Citations), Answers),
    Answers == [input_problems([wrong_type(reference_date)]) - []].
test(unbound_profile_query_gives_input_problems) :-
    findall(Result - Citations, restriction_status(foreign_state_requirements, _Profile, Result, Citations), Answers),
    Answers == [input_problems([wrong_type(profile)]) - []].

test(bound_not_restricted_rejected_for_restricted, fail) :-
    dpdp_transfer_profile_for(notified_destination_restricted, restriction_request(Restriction, Profile)),
    restriction_status(Restriction, Profile, not_restricted, _).
test(bound_not_in_force_rejected_on_commencement_day, fail) :-
    dpdp_transfer_profile_for(foreign_state_requirements_apply_on_commencement_day, restriction_request(Restriction, Profile)),
    restriction_status(Restriction, Profile, not_in_force, _).
test(bound_indeterminate_wrong_key_rejected, fail) :-
    dpdp_transfer_profile_for(foreign_state_reference_date_unstated, restriction_request(Restriction, Profile)),
    restriction_status(Restriction, Profile, indeterminate([section_16_in_force_on_reference_date]), _).
test(bound_wrong_citations_rejected, fail) :-
    dpdp_transfer_profile_for(notified_destination_no_notification, restriction_request(Restriction, Profile)),
    restriction_status(Restriction, Profile, not_restricted, [cite(in_dpdp_act_2023_s_16_1)]).

cp_test_names([bound_restricted_see_notification_holds, bound_requirements_apply_see_order_holds, bound_not_in_force_holds_day_before, bound_indeterminate_names_reference_date, empty_profile_has_no_problem, unbound_profile_is_wrong_type, partial_list_is_wrong_type, unbound_element_is_wrong_type, non_attribute_element_is_wrong_type_alone, atom_profile_is_wrong_type, unbound_value_is_wrong_type, number_key_is_unknown, compound_key_is_unknown, unknown_key_named_once, duplicate_key_reads_no_value, problems_in_contract_order_then_unknown, judgement_accepts_unsure, crisp_rejects_unsure, judgement_rejects_other_atom, year_zero_is_wrong_type, month_thirteen_is_wrong_type, float_year_is_wrong_type, century_non_leap_day_is_wrong_type, four_century_leap_day_is_real, date_list_is_wrong_type, unread_key_is_still_checked, unbound_profile_query_gives_input_problems]).
cp_test_fail_names([bound_not_restricted_rejected_for_restricted, bound_not_in_force_rejected_on_commencement_day, bound_indeterminate_wrong_key_rejected, bound_wrong_citations_rejected]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
