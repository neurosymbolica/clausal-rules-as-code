% SPDX-License-Identifier: EUPL-1.2
:- module(m__ind_dpdp_appeal_information_tests_test_queries, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__ind_dpdp_appeal_information_queries, [dpdp_appeal_information_profile_keys/1, dpdp_appeal_information_what_if/4, filing_requirements/1, not_governed_here/1, not_in_force/0, indeterminate/1]).
:- use_module(m__ind_dpdp_appeal_information_kernel, [dpdp_appeal_information_input_problems/2]).
:- use_module(m__ind_dpdp_appeal_information_fixtures, [dpdp_appeal_information_profile_for/2]).

test(profile_keys_are_the_contract_keys) :-
    dpdp_appeal_information_profile_keys(ProfileKeys),
    ProfileKeys == [section_29_in_force_on_filing_date, appeal_against_board_order_or_direction, appellant_aggrieved, order_receipt_date, appeal_filing_date, appeal_disposed_of_within_six_months, reference_date, section_36_in_force_on_call_date, call_date, recipient_kind, call_for_seventh_schedule_purpose, called_through_authorised_person, non_disclosure_required, written_permission_to_disclose].
test(a_good_profile_has_no_input_problem) :-
    dpdp_appeal_information_profile_for(appeal_filed_on_last_day, Profile),
    dpdp_appeal_information_input_problems(Profile, []).
test(a_malformed_profile_has_its_problems) :-
    dpdp_appeal_information_profile_for(malformed_profile, Profile),
    dpdp_appeal_information_input_problems(Profile, [wrong_type(appellant_aggrieved), unknown_key(colour)]).
test(what_if_a_later_filing_day_makes_the_appeal_ineligible) :-
    dpdp_appeal_information_profile_for(appeal_filed_on_last_day, Profile),
    findall(Status, dpdp_appeal_information_what_if(Profile, appeal_filing_date, date(2027, 3, 12), Status), Statuses),
    Statuses == [ineligible].
test(what_if_the_same_filing_day_stays_eligible) :-
    dpdp_appeal_information_profile_for(appeal_filed_on_last_day, Profile),
    dpdp_appeal_information_what_if(Profile, appeal_filing_date, date(2027, 3, 11), eligible).
test(what_if_supplies_a_missing_key) :-
    dpdp_appeal_information_profile_for(section_29_unstated, Profile),
    dpdp_appeal_information_what_if(Profile, section_29_in_force_on_filing_date, true, eligible).
test(what_if_a_resolved_judgement_settles_an_unsure_one) :-
    dpdp_appeal_information_profile_for(board_order_unsure, Profile),
    dpdp_appeal_information_what_if(Profile, appeal_against_board_order_or_direction, false, ineligible).
test(the_filing_requirements_constructor_lists_the_items_in_order) :-
    filing_requirements(Items),
    Items == [digital_form, fee_as_for_trai_act_appeal_unless_reduced_or_waived, fee_paid_by_upi_or_rbi_authorised_payment_system].
test(the_not_governed_here_constructor_holds_its_citations_in_order) :-
    not_governed_here(Citations),
    Citations == [cite(in_dpdp_rules_2025_r_23_1), cite(in_dpdp_act_2023_s_36)].
test(the_bare_result_atoms_resolve) :-
    not_in_force.
test(indeterminate_names_exactly_one_key) :-
    indeterminate([call_date]).

test(indeterminate_never_names_two_keys, fail) :-
    indeterminate([call_date, recipient_kind]).

cp_test_names([profile_keys_are_the_contract_keys, a_good_profile_has_no_input_problem, a_malformed_profile_has_its_problems, what_if_a_later_filing_day_makes_the_appeal_ineligible, what_if_the_same_filing_day_stays_eligible, what_if_supplies_a_missing_key, what_if_a_resolved_judgement_settles_an_unsure_one, the_filing_requirements_constructor_lists_the_items_in_order, the_not_governed_here_constructor_holds_its_citations_in_order, the_bare_result_atoms_resolve, indeterminate_names_exactly_one_key]).
cp_test_fail_names([indeterminate_never_names_two_keys]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
