% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_rts_simplified_policies_and_controls_tests_test_output_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_lists_extra, [last/2]).
:- use_module(m__eu_dora_rts_simplified_policies_and_controls_dora_rts_simplified_policies_and_controls, [simplified_policies_and_controls_duties_required/3, simplified_policies_and_controls_duties_complete/3, simplified_policies_and_controls_duties_outstanding/3, decide_dora_rts_simplified_policies_and_controls/2, dora_rts_simplified_policies_and_controls_status/2]).
:- use_module(m__eu_dora_rts_simplified_policies_and_controls_fixtures, [dora_rts_simplified_policies_and_controls_profile_for/2]).

profile(Subject, Profile) :-
    dora_rts_simplified_policies_and_controls_profile_for(Subject, Profile).

expected_complete(all_duties_performed, complete).
expected_complete(one_duty_not_performed, incomplete).
expected_complete(gate_false_entity, not_article_16_1_entity).
expected_complete(gate_false_with_duty_not_performed, not_article_16_1_entity).
expected_complete(gate_absent_entity, indeterminate([financial_entity_is_article_16_1_entity])).
expected_complete(one_duty_absent, indeterminate([access_operations_and_change_events_logged])).
expected_complete(false_and_absent, incomplete).
expected_complete(false_and_unsure, incomplete).
expected_complete(absent_before_unsure, indeterminate([teleworking_and_private_device_measures_implemented])).
expected_complete(several_duties_not_performed, incomplete).
expected_complete(gate_unsure_wrong_type, input_problems([wrong_type(financial_entity_is_article_16_1_entity)])).
expected_complete(duplicate_contract_key, input_problems([duplicate_key(user_accountability_ensured)])).
expected_complete(microenterprise_key_unknown, input_problems([unknown_key(financial_entity_is_microenterprise)])).
expected_complete(numeric_value_wrong_type, input_problems([wrong_type(secure_data_deletion_process_in_place)])).

expected_outstanding(all_duties_performed, none_outstanding).
expected_outstanding(one_duty_not_performed, outstanding([protection_of_premises_and_data_centres])).
expected_outstanding(gate_false_entity, not_article_16_1_entity).
expected_outstanding(gate_false_with_duty_not_performed, not_article_16_1_entity).
expected_outstanding(gate_absent_entity, indeterminate([financial_entity_is_article_16_1_entity])).
expected_outstanding(one_duty_absent, indeterminate([access_operations_and_change_events_logged])).
expected_outstanding(false_and_absent, indeterminate([access_operations_and_change_events_logged])).
expected_outstanding(absent_before_unsure, indeterminate([teleworking_and_private_device_measures_implemented])).
expected_outstanding(several_duties_not_performed, outstanding([internal_governance_and_control_framework, protection_of_premises_and_data_centres, user_accountability])).
expected_outstanding(gate_unsure_wrong_type, input_problems([wrong_type(financial_entity_is_article_16_1_entity)])).
expected_outstanding(duplicate_contract_key, input_problems([duplicate_key(user_accountability_ensured)])).
expected_outstanding(microenterprise_key_unknown, input_problems([unknown_key(financial_entity_is_microenterprise)])).
expected_outstanding(numeric_value_wrong_type, input_problems([wrong_type(secure_data_deletion_process_in_place)])).

expected_required(gate_false_entity, not_article_16_1_entity).
expected_required(gate_false_with_duty_not_performed, not_article_16_1_entity).
expected_required(gate_absent_entity, indeterminate([financial_entity_is_article_16_1_entity])).
expected_required(gate_unsure_wrong_type, input_problems([wrong_type(financial_entity_is_article_16_1_entity)])).
expected_required(duplicate_contract_key, input_problems([duplicate_key(user_accountability_ensured)])).
expected_required(microenterprise_key_unknown, input_problems([unknown_key(financial_entity_is_microenterprise)])).
expected_required(numeric_value_wrong_type, input_problems([wrong_type(secure_data_deletion_process_in_place)])).

subject_matches(Query, Subject, Expected) :-
    profile(Subject, Profile),
    findall(Result, call(Query, Profile, Result, _), Results),
    Results == [Expected].

complete_matches(Subject) :-
    expected_complete(Subject, Expected),
    subject_matches(simplified_policies_and_controls_duties_complete, Subject, Expected).

outstanding_matches(Subject) :-
    expected_outstanding(Subject, Expected),
    subject_matches(simplified_policies_and_controls_duties_outstanding, Subject, Expected).

required_matches(Subject) :-
    expected_required(Subject, Expected),
    subject_matches(simplified_policies_and_controls_duties_required, Subject, Expected).

test(every_complete_expectation_holds_exactly_once) :-
    findall(Subject, expected_complete(Subject, _), Expected),
    findall(Subject, complete_matches(Subject), Held),
    Held == Expected.
test(every_outstanding_expectation_holds_exactly_once) :-
    findall(Subject, expected_outstanding(Subject, _), Expected),
    findall(Subject, outstanding_matches(Subject), Held),
    Held == Expected.
test(every_required_expectation_holds_exactly_once) :-
    findall(Subject, expected_required(Subject, _), Expected),
    findall(Subject, required_matches(Subject), Held),
    Held == Expected.
test(required_lists_the_fifty_one_duties_in_duty_order) :-
    profile(one_duty_not_performed, Profile),
    findall(Result, simplified_policies_and_controls_duties_required(Profile, Result, _), [required(Duties)]),
    length(Duties, 51),
    Duties = [internal_governance_and_control_framework, management_body_overall_responsibility, ict_roles_and_responsibilities|_],
    last(Duties, teleworking_and_private_devices),
    sort(Duties, DistinctDuties),
    length(DistinctDuties, 51).
test(an_unsure_duty_is_read_out_as_a_referral) :-
    profile(one_duty_unsure, Profile),
    findall(Result - Citations, simplified_policies_and_controls_duties_complete(Profile, Result, Citations), [Review - ReviewCitations]),
    Review = needs_legal_review(open_textured(Key, Citation), [inputs_relied_on(Pairs)]),
    Key == cyber_threat_information_monitored,
    Citation == cite(eu_reg_2024_1774_art_34),
    ReviewCitations == [],
    length(Pairs, 52),
    Pairs = [financial_entity_is_article_16_1_entity - true|_],
    member(cyber_threat_information_monitored - unsure, Pairs).
test(outstanding_refers_after_a_false_duty_with_every_pair) :-
    profile(false_and_unsure, Profile),
    findall(Result, simplified_policies_and_controls_duties_outstanding(Profile, Result, _), [needs_legal_review(open_textured(cyber_threat_information_monitored, cite(eu_reg_2024_1774_art_34)), [inputs_relied_on(Pairs)])]),
    member(user_accountability_ensured - false, Pairs),
    length(Pairs, 52).
test(the_first_unsure_key_in_root_order_is_referred) :-
    profile(all_duties_performed, Base),
    findall(attribute(Key, Value), (member(attribute(Key, BaseValue), Base), unsure_for(Key, BaseValue, Value)), Profile),
    findall(Result, simplified_policies_and_controls_duties_complete(Profile, Result, _), [needs_legal_review(open_textured(Referred, cite(eu_reg_2024_1774_art_28_6)), _)]),
    Referred == critical_ict_audit_findings_verified_and_remediated.
test(outstanding_citations_are_each_written_once) :-
    profile(several_duties_not_performed, Profile),
    findall(Citations, simplified_policies_and_controls_duties_outstanding(Profile, _, Citations), [Citations]),
    sort(Citations, Distinct),
    Distinct == [cite(eu_reg_2024_1774_art_28_1), cite(eu_reg_2024_1774_art_32_2), cite(eu_reg_2024_1774_art_32_3), cite(eu_reg_2024_1774_art_33)],
    length(Citations, 4).
test(the_baseline_profile_yields_exactly_one_status) :-
    profile(all_duties_performed, Profile),
    findall(Status, dora_rts_simplified_policies_and_controls_status(Profile, Status), Statuses),
    Statuses == [complete].
test(the_verdict_carries_a_citation) :-
    profile(all_duties_performed, Profile),
    decide_dora_rts_simplified_policies_and_controls(Profile, dora_rts_simplified_policies_and_controls_verdict(complete, [_FirstCitation|_OtherCitations])).

unsure_for(critical_ict_audit_findings_verified_and_remediated, _, unsure).
unsure_for(teleworking_and_private_device_measures_implemented, _, unsure).
unsure_for(Key, BaseValue, BaseValue) :-
    dif(Key, critical_ict_audit_findings_verified_and_remediated),
    dif(Key, teleworking_and_private_device_measures_implemented).

cp_test_names([every_complete_expectation_holds_exactly_once, every_outstanding_expectation_holds_exactly_once, every_required_expectation_holds_exactly_once, required_lists_the_fifty_one_duties_in_duty_order, an_unsure_duty_is_read_out_as_a_referral, outstanding_refers_after_a_false_duty_with_every_pair, the_first_unsure_key_in_root_order_is_referred, outstanding_citations_are_each_written_once, the_baseline_profile_yields_exactly_one_status, the_verdict_carries_a_citation]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
