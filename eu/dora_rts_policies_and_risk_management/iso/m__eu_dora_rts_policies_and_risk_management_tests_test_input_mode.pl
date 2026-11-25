% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_rts_policies_and_risk_management_tests_test_input_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_dora_rts_policies_and_risk_management_dora_rts_policies_and_risk_management, [dora_rts_policies_and_risk_management_status/2, dora_rts_policies_and_risk_management_status_values/1, rts_policies_and_risk_management_duties_required/3, rts_policies_and_risk_management_duties_complete/3, rts_policies_and_risk_management_duties_outstanding/3]).
:- use_module(m__eu_dora_rts_policies_and_risk_management_kernel, [dora_rts_policies_and_risk_management_input_problems/2]).
:- use_module(m__eu_dora_rts_policies_and_risk_management_fixtures, [dora_rts_policies_and_risk_management_profile_for/2]).

test(complete_holds_with_the_verdict_bound) :-
    dora_rts_policies_and_risk_management_profile_for(all_duties_performed, Profile),
    dora_rts_policies_and_risk_management_status(Profile, complete).
test(incomplete_holds_with_the_verdict_bound) :-
    dora_rts_policies_and_risk_management_profile_for(one_duty_not_performed, Profile),
    dora_rts_policies_and_risk_management_status(Profile, incomplete).
test(simplified_framework_entity_holds_with_the_verdict_bound) :-
    dora_rts_policies_and_risk_management_profile_for(simplified_framework_entity_with_duties_performed, Profile),
    dora_rts_policies_and_risk_management_status(Profile, simplified_framework_entity).
test(the_gate_is_asked_with_the_status_bound) :-
    dora_rts_policies_and_risk_management_profile_for(gate_unanswered, Profile),
    dora_rts_policies_and_risk_management_status(Profile, indeterminate([financial_entity_is_article_16_1_entity])).
test(an_absent_duty_is_asked_with_the_status_bound) :-
    dora_rts_policies_and_risk_management_profile_for(duty_unanswered, Profile),
    dora_rts_policies_and_risk_management_status(Profile, indeterminate([security_policies_contain_safeguards_against_intrusions_and_data_misuse])).
test(an_unsure_duty_is_referred_with_the_reason_bound) :-
    dora_rts_policies_and_risk_management_profile_for(duty_judgement_unsure, Profile),
    dora_rts_policies_and_risk_management_status(Profile, needs_legal_review(open_textured(security_policies_contain_indicators_and_measures_for_implementation_and_exceptions, cite(eu_reg_2024_1774_art_2_2_c)), [inputs_relied_on(_Pairs)])).
test(input_problems_hold_with_the_status_bound) :-
    dora_rts_policies_and_risk_management_profile_for(unknown_key_present, Profile),
    dora_rts_policies_and_risk_management_status(Profile, input_problems([unknown_key(colour)])).
test(required_holds_with_the_result_and_citations_bound) :-
    dora_rts_policies_and_risk_management_profile_for(all_duties_performed, Profile),
    rts_policies_and_risk_management_duties_required(Profile, required([risk_profile_and_complexity_consideration|_]), [cite(eu_reg_2024_1774_art_1), cite(eu_reg_2024_1774_art_2_1), cite(eu_reg_2024_1774_art_2_2), cite(eu_reg_2024_1774_art_3)]).
test(outstanding_holds_with_the_list_bound) :-
    dora_rts_policies_and_risk_management_profile_for(second_paragraph_duty_not_performed, Profile),
    rts_policies_and_risk_management_duties_outstanding(Profile, outstanding([monitoring_of_treatment_effectiveness]), [cite(eu_reg_2024_1774_art_3_a_run2)]).
test(none_outstanding_holds_with_the_result_bound) :-
    dora_rts_policies_and_risk_management_profile_for(all_duties_performed, Profile),
    rts_policies_and_risk_management_duties_outstanding(Profile, none_outstanding, _Citations).
test(status_holds_with_the_verdict_bound) :-
    dora_rts_policies_and_risk_management_profile_for(all_duties_performed, Profile),
    findall(Status, dora_rts_policies_and_risk_management_status(Profile, Status), [BaselineStatus]),
    dora_rts_policies_and_risk_management_status(Profile, BaselineStatus).
test(attribute_order_does_not_matter) :-
    dora_rts_policies_and_risk_management_profile_for(all_duties_performed, Profile),
    reverse(Profile, ReversedProfile),
    rts_policies_and_risk_management_duties_complete(ReversedProfile, complete, _Citations).
test(an_unbound_profile_is_wrong_type) :-
    findall(Result - Citations, rts_policies_and_risk_management_duties_complete(_Profile, Result, Citations), Answers),
    Answers == [input_problems([wrong_type(profile)]) - []].
test(a_list_with_a_foreign_item_is_wrong_type) :-
    dora_rts_policies_and_risk_management_input_problems([attribute(financial_entity_is_article_16_1_entity, false), colour], [wrong_type(profile)]).
test(a_partial_list_is_wrong_type) :-
    dora_rts_policies_and_risk_management_input_problems([attribute(financial_entity_is_article_16_1_entity, false)|_Rest], [wrong_type(profile)]).
test(an_unbound_value_is_wrong_type) :-
    dora_rts_policies_and_risk_management_input_problems([attribute(security_policies_ensure_security_of_networks, _Value)], [wrong_type(security_policies_ensure_security_of_networks)]).
test(a_number_is_wrong_type_for_a_judgement) :-
    dora_rts_policies_and_risk_management_input_problems([attribute(security_policies_ensure_security_of_networks, 1)], [wrong_type(security_policies_ensure_security_of_networks)]).
test(a_float_is_wrong_type_for_the_gate) :-
    dora_rts_policies_and_risk_management_input_problems([attribute(financial_entity_is_article_16_1_entity, 1.0)], [wrong_type(financial_entity_is_article_16_1_entity)]).
test(unsure_is_accepted_for_a_judgement) :-
    dora_rts_policies_and_risk_management_input_problems([attribute(risk_management_policies_contain_residual_risk_provisions, unsure)], []).
test(an_unbound_key_is_unknown_as_given) :-
    dora_rts_policies_and_risk_management_input_problems([attribute(ProfileKey, true)], [unknown_key(Found)]),
    Found == ProfileKey.
test(two_distinct_unbound_keys_are_two_unknown_keys) :-
    dora_rts_policies_and_risk_management_input_problems([attribute(FirstKey, true), attribute(SecondKey, true)], [unknown_key(FoundFirst), unknown_key(FoundSecond)]),
    FoundFirst == FirstKey,
    FoundSecond == SecondKey.
test(an_unknown_key_value_is_never_checked) :-
    dora_rts_policies_and_risk_management_input_problems([attribute(colour, _Value), attribute(colour, 3)], [unknown_key(colour)]).
test(a_duplicate_key_is_only_duplicate) :-
    dora_rts_policies_and_risk_management_input_problems([attribute(financial_entity_is_article_16_1_entity, false), attribute(financial_entity_is_article_16_1_entity, false)], [duplicate_key(financial_entity_is_article_16_1_entity)]).
test(contract_problems_follow_contract_order) :-
    dora_rts_policies_and_risk_management_input_problems([attribute(colour, red), attribute(risk_treatment_procedure_ensures_assessment_of_corrective_actions, maybe), attribute(financial_entity_is_article_16_1_entity, unsure)], [wrong_type(financial_entity_is_article_16_1_entity), wrong_type(risk_treatment_procedure_ensures_assessment_of_corrective_actions), unknown_key(colour)]).
test(a_present_duty_key_is_checked_even_in_required) :-
    findall(Result - Citations, rts_policies_and_risk_management_duties_required([attribute(financial_entity_is_article_16_1_entity, false), attribute(security_policies_ensure_security_of_networks, maybe)], Result, Citations), Answers),
    Answers == [input_problems([wrong_type(security_policies_ensure_security_of_networks)]) - []].
test(the_gate_true_with_duty_keys_is_no_problem) :-
    dora_rts_policies_and_risk_management_profile_for(simplified_framework_entity_with_duties_performed, Profile),
    dora_rts_policies_and_risk_management_input_problems(Profile, []).

test(every_other_bound_status_is_rejected, fail) :-
    dora_rts_policies_and_risk_management_profile_for(all_duties_performed, Profile),
    findall(Status, dora_rts_policies_and_risk_management_status(Profile, Status), [BaselineStatus]),
    dora_rts_policies_and_risk_management_status_values(StatusValues),
    member(Other, StatusValues),
    dif(Other, BaselineStatus),
    dora_rts_policies_and_risk_management_status(Profile, Other).

cp_test_names([complete_holds_with_the_verdict_bound, incomplete_holds_with_the_verdict_bound, simplified_framework_entity_holds_with_the_verdict_bound, the_gate_is_asked_with_the_status_bound, an_absent_duty_is_asked_with_the_status_bound, an_unsure_duty_is_referred_with_the_reason_bound, input_problems_hold_with_the_status_bound, required_holds_with_the_result_and_citations_bound, outstanding_holds_with_the_list_bound, none_outstanding_holds_with_the_result_bound, status_holds_with_the_verdict_bound, attribute_order_does_not_matter, an_unbound_profile_is_wrong_type, a_list_with_a_foreign_item_is_wrong_type, a_partial_list_is_wrong_type, an_unbound_value_is_wrong_type, a_number_is_wrong_type_for_a_judgement, a_float_is_wrong_type_for_the_gate, unsure_is_accepted_for_a_judgement, an_unbound_key_is_unknown_as_given, two_distinct_unbound_keys_are_two_unknown_keys, an_unknown_key_value_is_never_checked, a_duplicate_key_is_only_duplicate, contract_problems_follow_contract_order, a_present_duty_key_is_checked_even_in_required, the_gate_true_with_duty_keys_is_no_problem]).
cp_test_fail_names([every_other_bound_status_is_rejected]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
