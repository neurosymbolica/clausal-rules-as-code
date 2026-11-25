% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_nis2_lex_specialis_and_definitions_tests_test_output_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_nis2_lex_specialis_and_definitions_nis2_lex_specialis_and_definitions, [nis2_risk_management_provisions_status/3, nis2_incident_notification_provisions_status/3, decide_nis2_lex_specialis_and_definitions/2, nis2_lex_specialis_and_definitions_status/2]).
:- use_module(m__eu_nis2_lex_specialis_and_definitions_kernel, [nis2_lex_specialis_and_definitions_input_problems/2]).
:- use_module(m__eu_nis2_lex_specialis_and_definitions_fixtures, [nis2_lex_specialis_and_definitions_subject/1, nis2_lex_specialis_and_definitions_profile_for/2]).

expected_status(essential_all_equivalent, nis2_groups(nis2_provisions_disapplied, nis2_provisions_disapplied)).
expected_status(essential_risk_not_equivalent, nis2_groups(nis2_provisions_apply, nis2_provisions_disapplied)).
expected_status(important_only_point_a_met, nis2_groups(nis2_provisions_disapplied, nis2_provisions_apply)).
expected_status(important_requirements_not_equivalent, nis2_groups(nis2_provisions_disapplied, nis2_provisions_apply)).
expected_status(out_of_scope_entity, nis2_groups(out_of_scope, out_of_scope)).
expected_status(essential_judgements_missing, nis2_groups(indeterminate([dora_risk_management_measures_at_least_equivalent_in_effect]), indeterminate([dora_gives_immediate_access_to_incident_notifications]))).
expected_status(class_missing, nis2_groups(indeterminate([entity_class]), indeterminate([entity_class]))).
expected_status(class_given_all_unsure, nis2_groups(needs_legal_review(open_textured(dora_risk_management_measures_at_least_equivalent_in_effect, cite(eu_dir_2022_2555_art_4_2_a)), [inputs_relied_on([entity_class - essential_entity, dora_risk_management_measures_at_least_equivalent_in_effect - unsure])]), needs_legal_review(open_textured(dora_gives_immediate_access_to_incident_notifications, cite(eu_dir_2022_2555_art_4_2_b)), [inputs_relied_on([entity_class - essential_entity, dora_gives_immediate_access_to_incident_notifications - unsure, dora_incident_notification_requirements_at_least_equivalent_in_effect - unsure])]))).
expected_status(unsure_risk_measures, nis2_groups(needs_legal_review(open_textured(dora_risk_management_measures_at_least_equivalent_in_effect, cite(eu_dir_2022_2555_art_4_2_a)), [inputs_relied_on([entity_class - essential_entity, dora_risk_management_measures_at_least_equivalent_in_effect - unsure])]), nis2_provisions_apply)).
expected_status(access_missing_requirements_unsure, nis2_groups(indeterminate([dora_risk_management_measures_at_least_equivalent_in_effect]), indeterminate([dora_gives_immediate_access_to_incident_notifications]))).
expected_status(access_unsure_requirements_missing, nis2_groups(nis2_provisions_disapplied, indeterminate([dora_incident_notification_requirements_at_least_equivalent_in_effect]))).
expected_status(access_true_requirements_unsure, nis2_groups(nis2_provisions_disapplied, needs_legal_review(open_textured(dora_incident_notification_requirements_at_least_equivalent_in_effect, cite(eu_dir_2022_2555_art_4_2_b)), [inputs_relied_on([entity_class - essential_entity, dora_gives_immediate_access_to_incident_notifications - true, dora_incident_notification_requirements_at_least_equivalent_in_effect - unsure])]))).
expected_status(malformed_duplicate_and_unknown, nis2_groups(input_problems([duplicate_key(entity_class), unknown_key(sector)]), input_problems([duplicate_key(entity_class), unknown_key(sector)]))).
expected_status(malformed_wrong_type, nis2_groups(input_problems([wrong_type(entity_class)]), input_problems([wrong_type(entity_class)]))).

status_as_expected(Subject) :-
    expected_status(Subject, Expected),
    nis2_lex_specialis_and_definitions_profile_for(Subject, Profile),
    findall(Status, nis2_lex_specialis_and_definitions_status(Profile, Status), Statuses),
    Statuses == [Expected].

test(every_fixture_gives_exactly_its_expected_status) :-
    findall(Subject, expected_status(Subject, _), Subjects),
    Subjects = [_|_],
    maplist(status_as_expected, Subjects).
test(every_registered_subject_has_an_expectation) :-
    findall(Subject, nis2_lex_specialis_and_definitions_subject(Subject), Registered),
    sort(Registered, RegisteredSet),
    findall(Subject, expected_status(Subject, _), Expected),
    sort(Expected, ExpectedSet),
    RegisteredSet == ExpectedSet.
test(risk_final_answer_carries_the_fixed_list) :-
    nis2_lex_specialis_and_definitions_profile_for(essential_risk_not_equivalent, Profile),
    findall(Result - Citations, nis2_risk_management_provisions_status(Profile, Result, Citations), Answers),
    Answers == [nis2_provisions_apply - [cite(eu_dir_2022_2555_art_4_1), cite(eu_dir_2022_2555_art_4_2), cite(eu_dir_2022_2555_art_4_2_a), cite(eu_reg_2022_2554_art_1_2)]].
test(notification_out_of_scope_carries_the_fixed_list) :-
    nis2_lex_specialis_and_definitions_profile_for(out_of_scope_entity, Profile),
    findall(Result - Citations, nis2_incident_notification_provisions_status(Profile, Result, Citations), Answers),
    Answers == [out_of_scope - [cite(eu_dir_2022_2555_art_4_1), cite(eu_dir_2022_2555_art_4_2), cite(eu_dir_2022_2555_art_4_2_b), cite(eu_reg_2022_2554_art_1_2)]].
test(a_referral_has_no_citations) :-
    nis2_lex_specialis_and_definitions_profile_for(class_given_all_unsure, Profile),
    findall(Citations, nis2_incident_notification_provisions_status(Profile, _, Citations), CitationLists),
    CitationLists == [[]].
test(the_verdict_unions_both_citation_lists) :-
    nis2_lex_specialis_and_definitions_profile_for(essential_all_equivalent, Profile),
    findall(Citations, decide_nis2_lex_specialis_and_definitions(Profile, nis2_lex_specialis_and_definitions_verdict(_, Citations)), CitationLists),
    CitationLists == [[cite(eu_dir_2022_2555_art_4_1), cite(eu_dir_2022_2555_art_4_2), cite(eu_dir_2022_2555_art_4_2_a), cite(eu_dir_2022_2555_art_4_2_b), cite(eu_reg_2022_2554_art_1_2)]].
test(the_verdict_of_two_statuses_has_no_citation) :-
    nis2_lex_specialis_and_definitions_profile_for(class_missing, Profile),
    findall(Citations, decide_nis2_lex_specialis_and_definitions(Profile, nis2_lex_specialis_and_definitions_verdict(_, Citations)), CitationLists),
    CitationLists == [[]].
test(input_check_yields_exactly_one_solution) :-
    findall(Problems, nis2_lex_specialis_and_definitions_input_problems([attribute(entity_class, essential_entity)], Problems), Solutions),
    Solutions == [[]].
test(contract_problems_come_in_contract_order_before_unknown_keys) :-
    nis2_lex_specialis_and_definitions_input_problems([attribute(colour, blue), attribute(dora_incident_notification_requirements_at_least_equivalent_in_effect, maybe), attribute(entity_class, large)], Problems),
    Problems == [wrong_type(entity_class), wrong_type(dora_incident_notification_requirements_at_least_equivalent_in_effect), unknown_key(colour)].
test(a_duplicate_key_is_never_also_wrong_type) :-
    nis2_lex_specialis_and_definitions_input_problems([attribute(entity_class, large), attribute(entity_class, large)], Problems),
    Problems == [duplicate_key(entity_class)].
test(an_unbound_key_is_named_as_that_variable) :-
    nis2_lex_specialis_and_definitions_input_problems([attribute(UnboundKey, anything)], Problems),
    Problems = [unknown_key(Named)],
    Named == UnboundKey.
test(two_distinct_unbound_keys_are_two_keys) :-
    nis2_lex_specialis_and_definitions_input_problems([attribute(FirstKey, one), attribute(SecondKey, two)], Problems),
    Problems = [unknown_key(FirstNamed), unknown_key(SecondNamed)],
    FirstNamed == FirstKey,
    SecondNamed == SecondKey.
test(the_same_unbound_key_twice_is_one_key) :-
    nis2_lex_specialis_and_definitions_input_problems([attribute(SameKey, one), attribute(SameKey, two)], Problems),
    Problems = [unknown_key(Named)],
    Named == SameKey.
test(an_integer_and_a_float_key_are_two_keys) :-
    nis2_lex_specialis_and_definitions_input_problems([attribute(7, one), attribute(7.0, two)], Problems),
    Problems == [unknown_key(7), unknown_key(7.0)].
test(an_unknown_key_value_is_not_checked) :-
    nis2_lex_specialis_and_definitions_input_problems([attribute(colour, _AnyValue)], Problems),
    Problems == [unknown_key(colour)].
test(an_unbound_contract_value_is_wrong_type) :-
    nis2_lex_specialis_and_definitions_input_problems([attribute(entity_class, _AnyValue)], Problems),
    Problems == [wrong_type(entity_class)].
test(a_number_judgement_is_wrong_type) :-
    nis2_lex_specialis_and_definitions_input_problems([attribute(dora_risk_management_measures_at_least_equivalent_in_effect, 1.0)], Problems),
    Problems == [wrong_type(dora_risk_management_measures_at_least_equivalent_in_effect)].
test(a_partial_list_is_not_a_profile) :-
    nis2_lex_specialis_and_definitions_input_problems([attribute(entity_class, essential_entity)|_], Problems),
    Problems == [wrong_type(profile)].
test(a_stray_element_is_not_a_profile) :-
    nis2_lex_specialis_and_definitions_input_problems([attribute(entity_class, essential_entity), colour], Problems),
    Problems == [wrong_type(profile)].
test(an_unbound_profile_is_not_a_profile) :-
    nis2_lex_specialis_and_definitions_input_problems(_AnyProfile, Problems),
    Problems == [wrong_type(profile)].

cp_test_names([every_fixture_gives_exactly_its_expected_status, every_registered_subject_has_an_expectation, risk_final_answer_carries_the_fixed_list, notification_out_of_scope_carries_the_fixed_list, a_referral_has_no_citations, the_verdict_unions_both_citation_lists, the_verdict_of_two_statuses_has_no_citation, input_check_yields_exactly_one_solution, contract_problems_come_in_contract_order_before_unknown_keys, a_duplicate_key_is_never_also_wrong_type, an_unbound_key_is_named_as_that_variable, two_distinct_unbound_keys_are_two_keys, the_same_unbound_key_twice_is_one_key, an_integer_and_a_float_key_are_two_keys, an_unknown_key_value_is_not_checked, an_unbound_contract_value_is_wrong_type, a_number_judgement_is_wrong_type, a_partial_list_is_not_a_profile, a_stray_element_is_not_a_profile, an_unbound_profile_is_not_a_profile]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
