% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_codes_and_certification_tests_test_input_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_codes_and_certification_gdpr_codes_and_certification, [certification_status/5, code_monitoring_status/3, accreditation_status/6, gdpr_codes_and_certification_status/2, gdpr_codes_and_certification_status_values/1]).
:- use_module(m__eu_data_protection_gdpr_codes_and_certification_kernel, [gdpr_codes_and_certification_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_codes_and_certification_fixtures, [gdpr_codes_and_certification_profile_for/2]).

test(certification_result_holds_when_bound) :-
    gdpr_codes_and_certification_profile_for(certification_in_force, Profile),
    certification_status(Profile, date(2024, 1, 15), date(2026, 6, 1), certification_result(within_maximum_period, not_relied_on_for_transfers), _).
test(code_result_holds_when_bound) :-
    gdpr_codes_and_certification_profile_for(code_monitored_and_relied_on_for_transfers, Profile),
    code_monitoring_status(Profile, code_result(monitoring_by_accredited_body([take_appropriate_action_on_infringement, inform_supervisory_authority_of_actions_and_reasons]), transfer_conditions_met), _).
test(accreditation_atom_holds_when_bound) :-
    gdpr_codes_and_certification_profile_for(certification_body_conditions_met, Profile),
    accreditation_status(Profile, certification_body, date(2020, 1, 1), date(2024, 6, 1), accreditation_conditions_met, _).
test(status_holds_with_the_verdict_bound) :-
    gdpr_codes_and_certification_profile_for(code_monitored_and_relied_on_for_transfers, Profile),
    gdpr_codes_and_certification_status(Profile, code_result).
test(an_unread_key_does_not_change_the_answer) :-
    gdpr_codes_and_certification_profile_for(certification_in_force, Profile),
    append(Profile, [attribute(monitoring_body_accredited, false), attribute(code_has_general_validity, false)], Extended),
    certification_status(Extended, date(2024, 1, 15), date(2026, 6, 1), certification_result(within_maximum_period, not_relied_on_for_transfers), _).
test(an_empty_profile_has_no_problem) :-
    gdpr_codes_and_certification_input_problems([], []).
test(an_unbound_profile_is_not_an_attribute_list) :-
    gdpr_codes_and_certification_input_problems(_, [wrong_type(profile)]).
test(a_partial_list_is_not_an_attribute_list) :-
    gdpr_codes_and_certification_input_problems([attribute(certification_withdrawn, true)|_], [wrong_type(profile)]).
test(an_item_that_is_not_an_attribute_is_wrong_type_profile_alone) :-
    gdpr_codes_and_certification_input_problems([attribute(colour, blue), certification_withdrawn - true], [wrong_type(profile)]).
test(an_unbound_item_is_wrong_type_profile) :-
    gdpr_codes_and_certification_input_problems([attribute(certification_withdrawn, true), _], [wrong_type(profile)]).
test(a_compound_key_holding_a_variable_is_wrong_type_profile) :-
    gdpr_codes_and_certification_input_problems([attribute(wrapped(_), true)], [wrong_type(profile)]).
test(a_number_key_is_unknown_as_given) :-
    gdpr_codes_and_certification_input_problems([attribute(42, true)], [unknown_key(42)]).
test(a_ground_compound_key_is_unknown_as_given) :-
    gdpr_codes_and_certification_input_problems([attribute(wrapped(colour), true)], [unknown_key(wrapped(colour))]).
test(an_unbound_key_is_unknown_as_that_variable) :-
    gdpr_codes_and_certification_input_problems([attribute(Key, true)], Problems),
    Problems = [unknown_key(Found)],
    Found == Key.
test(two_different_unbound_keys_are_two_keys) :-
    gdpr_codes_and_certification_input_problems([attribute(FirstKey, true), attribute(SecondKey, true)], Problems),
    Problems = [unknown_key(FoundFirst), unknown_key(FoundSecond)],
    FoundFirst == FirstKey,
    FoundSecond == SecondKey.
test(the_same_unbound_key_twice_is_one_key) :-
    gdpr_codes_and_certification_input_problems([attribute(Key, true), attribute(Key, false)], Problems),
    Problems = [unknown_key(Found)],
    Found == Key.
test(an_unknown_key_value_is_never_checked) :-
    gdpr_codes_and_certification_input_problems([attribute(colour, _), attribute(colour, attested(x))], [unknown_key(colour)]).
test(an_unbound_contract_value_is_wrong_type) :-
    gdpr_codes_and_certification_input_problems([attribute(certification_withdrawn, _)], [wrong_type(certification_withdrawn)]).
test(a_crisp_key_given_unsure_is_wrong_type) :-
    gdpr_codes_and_certification_input_problems([attribute(code_has_general_validity, unsure)], [wrong_type(code_has_general_validity)]).
test(a_judgement_key_given_unsure_is_well_typed) :-
    gdpr_codes_and_certification_input_problems([attribute(monitoring_body_actions_infringe_regulation, unsure)], []).
test(an_enumeration_value_outside_its_atoms_is_wrong_type) :-
    gdpr_codes_and_certification_input_problems([attribute(certification_body_accrediting_entity, ministry)], [wrong_type(certification_body_accrediting_entity)]).
test(an_attested_judgement_is_wrong_type) :-
    gdpr_codes_and_certification_input_problems([attribute(certification_requirements_not_met, attested(true))], [wrong_type(certification_requirements_not_met)]).
test(a_duplicate_key_with_equal_values_is_only_duplicate) :-
    gdpr_codes_and_certification_input_problems([attribute(certification_withdrawn, true), attribute(certification_withdrawn, true)], [duplicate_key(certification_withdrawn)]).
test(a_duplicate_key_with_bad_values_is_never_wrong_type) :-
    gdpr_codes_and_certification_input_problems([attribute(certification_withdrawn, maybe), attribute(certification_withdrawn, _)], [duplicate_key(certification_withdrawn)]).
test(problems_follow_contract_order_then_unknown_keys) :-
    gdpr_codes_and_certification_input_problems([attribute(colour, blue), attribute(certification_body_actions_infringe_regulation, maybe), attribute(certification_issuer, nobody)], [wrong_type(certification_issuer), wrong_type(certification_body_actions_infringe_regulation), unknown_key(colour)]).
test(a_profile_problem_comes_before_every_other_step) :-
    code_monitoring_status([attribute(colour, blue), attribute(processing_by_public_authority_or_body, true)], input_problems([unknown_key(colour)]), []).
test(an_unbound_check_date_is_wrong_type) :-
    certification_status([], date(2024, 1, 15), _, input_problems([wrong_type(check_date)]), []).
test(an_atom_check_date_is_wrong_type) :-
    certification_status([], date(2024, 1, 15), not_a_date, input_problems([wrong_type(check_date)]), []).
test(year_zero_is_not_a_calendar_day) :-
    certification_status([], date(0, 1, 15), date(2024, 1, 15), input_problems([wrong_type(issued_on)]), []).
test(a_float_year_is_not_a_calendar_day) :-
    certification_status([], date(2024.0, 1, 15), date(2024, 1, 15), input_problems([wrong_type(issued_on)]), []).
test(the_thirtieth_of_february_is_not_a_calendar_day) :-
    accreditation_status([], monitoring_body, date(2024, 2, 30), date(2024, 3, 1), input_problems([wrong_type(accredited_on)]), []).
test(an_unknown_body_is_wrong_type) :-
    accreditation_status([], registry_body, date(2020, 1, 1), date(2021, 1, 1), input_problems([wrong_type(body)]), []).
test(argument_problems_follow_the_profile_problems_in_order) :-
    accreditation_status([attribute(colour, blue)], registry_body, date(2023, 2, 29), date(2023, 13, 1), input_problems([unknown_key(colour), wrong_type(body), wrong_type(accredited_on), wrong_type(check_date)]), []).

test(another_validity_bound_is_rejected, fail) :-
    gdpr_codes_and_certification_profile_for(certification_in_force, Profile),
    certification_status(Profile, date(2024, 1, 15), date(2026, 6, 1), certification_result(withdrawn, _), _).
test(another_transfer_bound_is_rejected, fail) :-
    gdpr_codes_and_certification_profile_for(code_monitored_and_relied_on_for_transfers, Profile),
    code_monitoring_status(Profile, code_result(_, not_relied_on_for_transfers), _).
test(a_monitoring_body_never_has_a_maximum_period, fail) :-
    gdpr_codes_and_certification_profile_for(monitoring_body_conditions_met, Profile),
    accreditation_status(Profile, monitoring_body, date(2020, 1, 1), date(2030, 1, 1), maximum_period_ended, _).
test(every_other_bound_status_is_rejected, fail) :-
    gdpr_codes_and_certification_profile_for(code_monitored_and_relied_on_for_transfers, Profile),
    gdpr_codes_and_certification_status_values(StatusValues),
    member(Other, StatusValues),
    dif(Other, code_result),
    gdpr_codes_and_certification_status(Profile, Other).

cp_test_names([certification_result_holds_when_bound, code_result_holds_when_bound, accreditation_atom_holds_when_bound, status_holds_with_the_verdict_bound, an_unread_key_does_not_change_the_answer, an_empty_profile_has_no_problem, an_unbound_profile_is_not_an_attribute_list, a_partial_list_is_not_an_attribute_list, an_item_that_is_not_an_attribute_is_wrong_type_profile_alone, an_unbound_item_is_wrong_type_profile, a_compound_key_holding_a_variable_is_wrong_type_profile, a_number_key_is_unknown_as_given, a_ground_compound_key_is_unknown_as_given, an_unbound_key_is_unknown_as_that_variable, two_different_unbound_keys_are_two_keys, the_same_unbound_key_twice_is_one_key, an_unknown_key_value_is_never_checked, an_unbound_contract_value_is_wrong_type, a_crisp_key_given_unsure_is_wrong_type, a_judgement_key_given_unsure_is_well_typed, an_enumeration_value_outside_its_atoms_is_wrong_type, an_attested_judgement_is_wrong_type, a_duplicate_key_with_equal_values_is_only_duplicate, a_duplicate_key_with_bad_values_is_never_wrong_type, problems_follow_contract_order_then_unknown_keys, a_profile_problem_comes_before_every_other_step, an_unbound_check_date_is_wrong_type, an_atom_check_date_is_wrong_type, year_zero_is_not_a_calendar_day, a_float_year_is_not_a_calendar_day, the_thirtieth_of_february_is_not_a_calendar_day, an_unknown_body_is_wrong_type, argument_problems_follow_the_profile_problems_in_order]).
cp_test_fail_names([another_validity_bound_is_rejected, another_transfer_bound_is_rejected, a_monitoring_body_never_has_a_maximum_period, every_other_bound_status_is_rejected]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
