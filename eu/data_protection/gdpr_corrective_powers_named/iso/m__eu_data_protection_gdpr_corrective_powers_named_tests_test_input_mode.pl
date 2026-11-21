% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_corrective_powers_named_tests_test_input_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_corrective_powers_named_gdpr_corrective_powers_named, [corrective_powers_named/3, corrective_power_named/4, gdpr_corrective_powers_named_status/2]).
:- use_module(m__eu_data_protection_gdpr_corrective_powers_named_kernel, [gdpr_corrective_powers_named_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_corrective_powers_named_fixtures, [gdpr_corrective_powers_named_profile_for/2]).

test(the_list_answer_holds_with_the_result_bound) :-
    gdpr_corrective_powers_named_profile_for(past_infringement, Profile),
    corrective_powers_named(Profile, powers_named([power(reprimand, [controller, processor]), power(limitation_or_ban_on_processing, []), power(administrative_fine, [])], authority_discretion), _Citations).
test(the_single_answer_holds_with_everything_bound) :-
    gdpr_corrective_powers_named_profile_for(past_infringement, Profile),
    corrective_power_named(Profile, administrative_fine, named([], authority_discretion), [cite(eu_reg_2016_679_art_58_2), cite(eu_reg_2016_679_art_58_2_i)]).
test(not_named_holds_with_the_result_bound) :-
    gdpr_corrective_powers_named_profile_for(all_false, Profile),
    corrective_power_named(Profile, warning, not_named, [cite(eu_reg_2016_679_art_58_2), cite(eu_reg_2016_679_art_58_2_a)]).
test(the_status_holds_with_the_verdict_bound) :-
    gdpr_corrective_powers_named_profile_for(missing_flows, Profile),
    gdpr_corrective_powers_named_status(Profile, indeterminate([data_flows_to_third_country_or_international_organisation])).
test(an_unbound_profile_is_wrong_type) :-
    findall(Problems, gdpr_corrective_powers_named_input_problems(_Profile, Problems), Answers),
    Answers == [[wrong_type(profile)]].
test(a_partial_list_is_wrong_type) :-
    findall(Problems, gdpr_corrective_powers_named_input_problems([attribute(processing_has_infringed, true)|_Rest], Problems), Answers),
    Answers == [[wrong_type(profile)]].
test(an_unbound_element_is_wrong_type) :-
    findall(Problems, gdpr_corrective_powers_named_input_problems([attribute(processing_has_infringed, true), _Element], Problems), Answers),
    Answers == [[wrong_type(profile)]].
test(a_foreign_element_is_wrong_type_alone) :-
    findall(Problems, gdpr_corrective_powers_named_input_problems([attribute(personal_data_breach_occurred, unsure), processing_has_infringed - true], Problems), Answers),
    Answers == [[wrong_type(profile)]].
test(an_atom_is_not_a_profile) :-
    findall(Problems, gdpr_corrective_powers_named_input_problems(profile, Problems), Answers),
    Answers == [[wrong_type(profile)]].
test(the_empty_profile_has_no_problem) :-
    findall(Problems, gdpr_corrective_powers_named_input_problems([], Problems), Answers),
    Answers == [[]].
test(a_number_key_is_unknown_as_given) :-
    gdpr_corrective_powers_named_input_problems([attribute(42, true)], Problems),
    Problems == [unknown_key(42)].
test(a_compound_key_is_unknown_as_given) :-
    gdpr_corrective_powers_named_input_problems([attribute(key(processing_has_infringed), true)], Problems),
    Problems == [unknown_key(key(processing_has_infringed))].
test(an_unbound_key_is_unknown_as_that_variable) :-
    findall(Key - Problems, gdpr_corrective_powers_named_input_problems([attribute(Key, true)], Problems), [FoundKey - FoundProblems]),
    FoundProblems = [unknown_key(Named)],
    Named == FoundKey.
test(two_unbound_keys_are_two_unknown_keys) :-
    gdpr_corrective_powers_named_input_problems([attribute(FirstKey, true), attribute(SecondKey, false)], Problems),
    Problems = [unknown_key(FirstNamed), unknown_key(SecondNamed)],
    FirstNamed == FirstKey,
    SecondNamed == SecondKey.
test(a_repeated_unknown_key_is_named_once) :-
    gdpr_corrective_powers_named_input_problems([attribute(colour, red), attribute(colour, blue)], Problems),
    Problems == [unknown_key(colour)].
test(an_unbound_value_is_wrong_type) :-
    gdpr_corrective_powers_named_input_problems([attribute(processing_has_infringed, _Value)], Problems),
    Problems == [wrong_type(processing_has_infringed)].
test(unsure_for_a_crisp_key_is_wrong_type) :-
    gdpr_corrective_powers_named_input_problems([attribute(personal_data_breach_occurred, unsure)], Problems),
    Problems == [wrong_type(personal_data_breach_occurred)].
test(unsure_for_a_judgement_key_is_well_typed) :-
    gdpr_corrective_powers_named_input_problems([attribute(processing_not_in_compliance, unsure)], Problems),
    Problems == [].
test(an_attested_judgement_is_wrong_type) :-
    gdpr_corrective_powers_named_input_problems([attribute(processing_has_infringed, attested(true))], Problems),
    Problems == [wrong_type(processing_has_infringed)].
test(a_duplicate_with_equal_values_is_only_duplicate) :-
    gdpr_corrective_powers_named_input_problems([attribute(processing_has_infringed, true), attribute(processing_has_infringed, true)], Problems),
    Problems == [duplicate_key(processing_has_infringed)].
test(a_duplicate_with_bad_values_is_never_also_wrong_type) :-
    gdpr_corrective_powers_named_input_problems([attribute(personal_data_breach_occurred, unsure), attribute(personal_data_breach_occurred, maybe)], Problems),
    Problems == [duplicate_key(personal_data_breach_occurred)].
test(contract_problems_come_before_unknown_keys) :-
    gdpr_corrective_powers_named_input_problems([attribute(colour, red), attribute(personal_data_breach_occurred, unsure)], Problems),
    Problems == [wrong_type(personal_data_breach_occurred), unknown_key(colour)].
test(the_list_refuses_an_unbound_profile) :-
    findall(Result - Citations, corrective_powers_named(_Profile, Result, Citations), Answers),
    Answers == [input_problems([wrong_type(profile)]) - []].
test(the_lookup_names_a_number_measure) :-
    findall(Result - Citations, corrective_power_named([], 7, Result, Citations), Answers),
    Answers == [input_problems([wrong_type(measure)]) - []].
test(the_lookup_names_a_compound_measure) :-
    findall(Result, corrective_power_named([], warning(controller), Result, _Citations), Results),
    Results == [input_problems([wrong_type(measure)])].
test(the_lookup_refuses_a_malformed_profile_with_a_good_measure) :-
    findall(Result, corrective_power_named(profile, warning, Result, _Citations), Results),
    Results == [input_problems([wrong_type(profile)])].
test(the_lookup_puts_the_measure_last) :-
    findall(Result, corrective_power_named([attribute(colour, red)], caution, Result, _Citations), Results),
    Results == [input_problems([unknown_key(colour), wrong_type(measure)])].

test(a_wrong_bound_list_is_rejected, fail) :-
    gdpr_corrective_powers_named_profile_for(past_infringement, Profile),
    corrective_powers_named(Profile, powers_named([], authority_discretion), _Citations).
test(a_bound_not_named_is_rejected_for_a_named_power, fail) :-
    gdpr_corrective_powers_named_profile_for(past_infringement, Profile),
    corrective_power_named(Profile, administrative_fine, not_named, _Citations).
test(a_bound_named_is_rejected_for_a_power_not_named, fail) :-
    gdpr_corrective_powers_named_profile_for(all_false, Profile),
    corrective_power_named(Profile, warning, named(_Addressees, authority_discretion), _Citations).
test(another_missing_key_is_rejected_when_bound, fail) :-
    gdpr_corrective_powers_named_profile_for(missing_flows, Profile),
    gdpr_corrective_powers_named_status(Profile, indeterminate([certification_issued_or_applied_for])).

cp_test_names([the_list_answer_holds_with_the_result_bound, the_single_answer_holds_with_everything_bound, not_named_holds_with_the_result_bound, the_status_holds_with_the_verdict_bound, an_unbound_profile_is_wrong_type, a_partial_list_is_wrong_type, an_unbound_element_is_wrong_type, a_foreign_element_is_wrong_type_alone, an_atom_is_not_a_profile, the_empty_profile_has_no_problem, a_number_key_is_unknown_as_given, a_compound_key_is_unknown_as_given, an_unbound_key_is_unknown_as_that_variable, two_unbound_keys_are_two_unknown_keys, a_repeated_unknown_key_is_named_once, an_unbound_value_is_wrong_type, unsure_for_a_crisp_key_is_wrong_type, unsure_for_a_judgement_key_is_well_typed, an_attested_judgement_is_wrong_type, a_duplicate_with_equal_values_is_only_duplicate, a_duplicate_with_bad_values_is_never_also_wrong_type, contract_problems_come_before_unknown_keys, the_list_refuses_an_unbound_profile, the_lookup_names_a_number_measure, the_lookup_names_a_compound_measure, the_lookup_refuses_a_malformed_profile_with_a_good_measure, the_lookup_puts_the_measure_last]).
cp_test_fail_names([a_wrong_bound_list_is_rejected, a_bound_not_named_is_rejected_for_a_named_power, a_bound_named_is_rejected_for_a_power_not_named, another_missing_key_is_rejected_when_bound]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
