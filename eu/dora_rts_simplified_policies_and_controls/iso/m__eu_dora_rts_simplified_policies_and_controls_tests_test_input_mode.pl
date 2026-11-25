% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_rts_simplified_policies_and_controls_tests_test_input_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_dora_rts_simplified_policies_and_controls_dora_rts_simplified_policies_and_controls, [simplified_policies_and_controls_duties_required/3, simplified_policies_and_controls_duties_complete/3, simplified_policies_and_controls_duties_outstanding/3, dora_rts_simplified_policies_and_controls_status/2, dora_rts_simplified_policies_and_controls_status_values/1]).
:- use_module(m__eu_dora_rts_simplified_policies_and_controls_kernel, [dora_rts_simplified_policies_and_controls_input_problems/2]).
:- use_module(m__eu_dora_rts_simplified_policies_and_controls_fixtures, [dora_rts_simplified_policies_and_controls_profile_for/2]).

expected_fixed_citations([cite(eu_reg_2022_2554_art_16_1), cite(eu_reg_2024_1774_art_28_1), cite(eu_reg_2024_1774_art_28_2), cite(eu_reg_2024_1774_art_28_4), cite(eu_reg_2024_1774_art_28_5), cite(eu_reg_2024_1774_art_28_6), cite(eu_reg_2024_1774_art_29_1), cite(eu_reg_2024_1774_art_29_2), cite(eu_reg_2024_1774_art_30_1), cite(eu_reg_2024_1774_art_30_2), cite(eu_reg_2024_1774_art_31_1), cite(eu_reg_2024_1774_art_31_2), cite(eu_reg_2024_1774_art_31_3), cite(eu_reg_2024_1774_art_31_4), cite(eu_reg_2024_1774_art_32_1), cite(eu_reg_2024_1774_art_32_2), cite(eu_reg_2024_1774_art_32_3), cite(eu_reg_2024_1774_art_33), cite(eu_reg_2024_1774_art_34), cite(eu_reg_2024_1774_art_35)]).

profile(Subject, Profile) :-
    dora_rts_simplified_policies_and_controls_profile_for(Subject, Profile).

test(status_holds_with_the_verdict_bound) :-
    profile(all_duties_performed, Profile),
    findall(Status, dora_rts_simplified_policies_and_controls_status(Profile, Status), [BaselineStatus]),
    dora_rts_simplified_policies_and_controls_status(Profile, BaselineStatus).
test(complete_bound_with_the_fixed_citations) :-
    profile(all_duties_performed, Profile),
    expected_fixed_citations(Fixed),
    simplified_policies_and_controls_duties_complete(Profile, complete, Fixed).
test(incomplete_bound_with_the_fixed_citations) :-
    profile(one_duty_not_performed, Profile),
    expected_fixed_citations(Fixed),
    simplified_policies_and_controls_duties_complete(Profile, incomplete, Fixed).
test(none_outstanding_bound) :-
    profile(all_duties_performed, Profile),
    expected_fixed_citations(Fixed),
    simplified_policies_and_controls_duties_outstanding(Profile, none_outstanding, Fixed).
test(outstanding_bound_with_the_duty_citations) :-
    profile(one_duty_not_performed, Profile),
    simplified_policies_and_controls_duties_outstanding(Profile, outstanding([protection_of_premises_and_data_centres]), [cite(eu_reg_2024_1774_art_32_2), cite(eu_reg_2024_1774_art_32_3)]).
test(required_bound_with_the_fixed_citations) :-
    profile(all_duties_performed, Profile),
    expected_fixed_citations(Fixed),
    simplified_policies_and_controls_duties_required(Profile, required([internal_governance_and_control_framework|_]), Fixed).
test(not_article_16_1_entity_bound_in_every_query) :-
    profile(gate_false_entity, Profile),
    simplified_policies_and_controls_duties_required(Profile, not_article_16_1_entity, [cite(eu_reg_2022_2554_art_16_1)]),
    simplified_policies_and_controls_duties_complete(Profile, not_article_16_1_entity, [cite(eu_reg_2022_2554_art_16_1)]),
    simplified_policies_and_controls_duties_outstanding(Profile, not_article_16_1_entity, [cite(eu_reg_2022_2554_art_16_1)]).
test(gate_indeterminate_bound_in_every_query) :-
    profile(gate_absent_entity, Profile),
    simplified_policies_and_controls_duties_required(Profile, indeterminate([financial_entity_is_article_16_1_entity]), []),
    simplified_policies_and_controls_duties_complete(Profile, indeterminate([financial_entity_is_article_16_1_entity]), []),
    simplified_policies_and_controls_duties_outstanding(Profile, indeterminate([financial_entity_is_article_16_1_entity]), []).
test(referral_bound) :-
    profile(one_duty_unsure, Profile),
    simplified_policies_and_controls_duties_complete(Profile, needs_legal_review(open_textured(cyber_threat_information_monitored, cite(eu_reg_2024_1774_art_34)), [inputs_relied_on([financial_entity_is_article_16_1_entity - true|_])]), []).
test(input_problems_bound) :-
    profile(numeric_value_wrong_type, Profile),
    simplified_policies_and_controls_duties_required(Profile, input_problems([wrong_type(secure_data_deletion_process_in_place)]), []).
test(an_unbound_profile_is_wrong_type) :-
    dora_rts_simplified_policies_and_controls_input_problems(_, Problems),
    Problems == [wrong_type(profile)].
test(a_partial_list_is_wrong_type) :-
    dora_rts_simplified_policies_and_controls_input_problems([attribute(user_accountability_ensured, true)|_], Problems),
    Problems == [wrong_type(profile)].
test(a_non_attribute_element_is_wrong_type) :-
    dora_rts_simplified_policies_and_controls_input_problems([attribute(user_accountability_ensured, true), widget], Problems),
    Problems == [wrong_type(profile)].
test(an_atom_profile_is_wrong_type) :-
    dora_rts_simplified_policies_and_controls_input_problems(widget, Problems),
    Problems == [wrong_type(profile)].
test(an_empty_profile_has_no_problem) :-
    dora_rts_simplified_policies_and_controls_input_problems([], Problems),
    Problems == [].
test(an_empty_profile_asks_for_the_gate) :-
    simplified_policies_and_controls_duties_required([], indeterminate([financial_entity_is_article_16_1_entity]), []).
test(an_unbound_key_is_named_as_given) :-
    dora_rts_simplified_policies_and_controls_input_problems([attribute(Unbound, true)], Problems),
    Problems = [unknown_key(Named)],
    Named == Unbound.
test(two_distinct_unbound_keys_are_two_keys) :-
    dora_rts_simplified_policies_and_controls_input_problems([attribute(First, true), attribute(Second, true)], Problems),
    Problems = [unknown_key(NamedFirst), unknown_key(NamedSecond)],
    NamedFirst == First,
    NamedSecond == Second.
test(the_same_unbound_key_twice_is_one_key) :-
    dora_rts_simplified_policies_and_controls_input_problems([attribute(Unbound, true), attribute(Unbound, false)], Problems),
    Problems = [unknown_key(Named)],
    Named == Unbound.
test(an_integer_and_a_float_key_are_two_keys) :-
    dora_rts_simplified_policies_and_controls_input_problems([attribute(7, true), attribute(7.0, true)], Problems),
    Problems == [unknown_key(7), unknown_key(7.0)].
test(an_unbound_value_of_a_contract_key_is_wrong_type) :-
    dora_rts_simplified_policies_and_controls_input_problems([attribute(user_accountability_ensured, _)], Problems),
    Problems == [wrong_type(user_accountability_ensured)].
test(unsure_is_wrong_type_for_the_gate_only) :-
    dora_rts_simplified_policies_and_controls_input_problems([attribute(financial_entity_is_article_16_1_entity, unsure), attribute(user_accountability_ensured, unsure)], Problems),
    Problems == [wrong_type(financial_entity_is_article_16_1_entity)].
test(problems_come_in_the_order_the_check_fixes) :-
    dora_rts_simplified_policies_and_controls_input_problems([attribute(widget_key, 1), attribute(secure_data_deletion_process_in_place, 1), attribute(financial_entity_is_article_16_1_entity, true), attribute(financial_entity_is_article_16_1_entity, true), attribute(widget_key, 2)], Problems),
    Problems == [duplicate_key(financial_entity_is_article_16_1_entity), wrong_type(secure_data_deletion_process_in_place), unknown_key(widget_key)].
test(a_duplicate_key_is_never_also_wrong_type) :-
    dora_rts_simplified_policies_and_controls_input_problems([attribute(user_accountability_ensured, 5), attribute(user_accountability_ensured, widget)], Problems),
    Problems == [duplicate_key(user_accountability_ensured)].
test(an_unknown_key_value_is_never_checked) :-
    dora_rts_simplified_policies_and_controls_input_problems([attribute(dora_entity_type, _)], Problems),
    Problems == [unknown_key(dora_entity_type)].

test(every_other_bound_status_is_rejected, fail) :-
    profile(all_duties_performed, Profile),
    findall(Status, dora_rts_simplified_policies_and_controls_status(Profile, Status), [BaselineStatus]),
    dora_rts_simplified_policies_and_controls_status_values(StatusValues),
    member(Other, StatusValues),
    dif(Other, BaselineStatus),
    dora_rts_simplified_policies_and_controls_status(Profile, Other).

cp_test_names([status_holds_with_the_verdict_bound, complete_bound_with_the_fixed_citations, incomplete_bound_with_the_fixed_citations, none_outstanding_bound, outstanding_bound_with_the_duty_citations, required_bound_with_the_fixed_citations, not_article_16_1_entity_bound_in_every_query, gate_indeterminate_bound_in_every_query, referral_bound, input_problems_bound, an_unbound_profile_is_wrong_type, a_partial_list_is_wrong_type, a_non_attribute_element_is_wrong_type, an_atom_profile_is_wrong_type, an_empty_profile_has_no_problem, an_empty_profile_asks_for_the_gate, an_unbound_key_is_named_as_given, two_distinct_unbound_keys_are_two_keys, the_same_unbound_key_twice_is_one_key, an_integer_and_a_float_key_are_two_keys, an_unbound_value_of_a_contract_key_is_wrong_type, unsure_is_wrong_type_for_the_gate_only, problems_come_in_the_order_the_check_fixes, a_duplicate_key_is_never_also_wrong_type, an_unknown_key_value_is_never_checked]).
cp_test_fail_names([every_other_bound_status_is_rejected]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
