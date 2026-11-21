% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_ict_risk_protection_and_detection_dora_ict_risk_protection_and_detection, [ict_risk_protection_and_detection_duties_required/3, ict_risk_protection_and_detection_duties_complete/3, ict_risk_protection_and_detection_duties_outstanding/3, decide_dora_ict_risk_protection_and_detection/2, dora_ict_risk_protection_and_detection_status/2, dora_ict_risk_protection_and_detection_checklist/2, dora_ict_risk_protection_and_detection_decision_resolvable/1, dora_ict_risk_protection_and_detection_status_values/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(library(pairs), [pairs_keys_values/3]).
:- use_module(clausal_lists_extra, [last/2]).
:- use_module(formalize_lib, [profile_get/3, profile_has/2, profile_lacks/2]).
:- use_module(m__eu_dora_ict_risk_protection_and_detection_kernel, [dora_ict_risk_protection_and_detection_input_problems/2]).
:- use_module(m__eu_dora_ict_risk_protection_and_detection_citations, [implements/1]).

dora_ict_risk_protection_and_detection_status_values([complete, incomplete, simplified_framework_entity, indeterminate, needs_legal_review, input_problems]).

duty_row(monitoring_and_control_of_ict_systems, monitors_and_controls_security_and_functioning_of_ict_systems, cite(eu_reg_2022_2554_art_9_1), always).
duty_row(ict_security_tools_policies_and_procedures, deploys_ict_security_tools_policies_and_procedures, cite(eu_reg_2022_2554_art_9_1), always).
duty_row(ict_security_policies_procedures_protocols_and_tools, ict_security_policies_procedures_protocols_and_tools_implemented, cite(eu_reg_2022_2554_art_9_2), always).
duty_row(appropriate_ict_solutions_and_processes, uses_appropriate_ict_solutions_and_processes, cite(eu_reg_2022_2554_art_9_3), always).
duty_row(security_of_data_transfer, ict_solutions_ensure_security_of_data_transfer, cite(eu_reg_2022_2554_art_9_3_a), always).
duty_row(minimised_data_corruption_loss_and_unauthorised_access, ict_solutions_minimise_data_corruption_loss_unauthorised_access_and_flaws, cite(eu_reg_2022_2554_art_9_3_b), always).
duty_row(prevention_of_unavailability_impairment_breaches_and_loss, ict_solutions_prevent_unavailability_impairment_breaches_and_data_loss, cite(eu_reg_2022_2554_art_9_3_c), always).
duty_row(protection_from_data_management_risks, ict_solutions_protect_data_from_data_management_risks, cite(eu_reg_2022_2554_art_9_3_d), always).
duty_row(information_security_policy, information_security_policy_developed_and_documented, cite(eu_reg_2022_2554_art_9_4_a), always).
duty_row(network_and_infrastructure_management, network_and_infrastructure_management_structure_established, cite(eu_reg_2022_2554_art_9_4_b), always).
duty_row(access_control_policies, access_limiting_policies_and_access_rights_controls_implemented, cite(eu_reg_2022_2554_art_9_4_c), always).
duty_row(strong_authentication_and_cryptographic_key_protection, strong_authentication_and_cryptographic_key_protection_implemented, cite(eu_reg_2022_2554_art_9_4_d), always).
duty_row(ict_change_management, ict_change_management_policies_procedures_and_controls_implemented, cite(eu_reg_2022_2554_art_9_4_e), always).
duty_row(patch_and_update_policies, patch_and_update_policies_documented, cite(eu_reg_2022_2554_art_9_4_f), always).
duty_row(severable_network_connection_infrastructure, network_connection_infrastructure_can_be_severed_or_segmented, cite(eu_reg_2022_2554_art_9_4), always).
duty_row(approved_ict_change_management_process, ict_change_management_process_approved_with_specific_protocols, cite(eu_reg_2022_2554_art_9_4), always).
duty_row(anomaly_detection_mechanisms, anomaly_detection_mechanisms_in_place, cite(eu_reg_2022_2554_art_10_1), always).
duty_row(single_point_of_failure_identification, mechanisms_to_identify_single_points_of_failure_in_place, cite(eu_reg_2022_2554_art_10_1), always).
duty_row(regular_testing_of_detection_mechanisms, detection_mechanisms_regularly_tested, cite(eu_reg_2022_2554_art_10_1), always).
duty_row(detection_control_layers_alert_thresholds_and_automatic_alerts, detection_mechanisms_enable_control_layers_alert_thresholds_and_automatic_alerts, cite(eu_reg_2022_2554_art_10_2), always).
duty_row(resources_to_monitor_user_activity_anomalies_and_incidents, sufficient_resources_devoted_to_monitoring_user_activity_anomalies_and_incidents, cite(eu_reg_2022_2554_art_10_3), always).
duty_row(trade_report_checking_systems, trade_report_checking_systems_in_place, cite(eu_reg_2022_2554_art_10_4), data_reporting_service_provider_only).

root_keys([financial_entity_is_article_16_1_entity, dora_entity_type|DutyKeys]) :-
    findall(Key, duty_row(_, Key, _, _), DutyKeys).

key_state(Profile, Key, absent) :-
    profile_lacks(Profile, Key).
key_state(Profile, Key, given(Value)) :-
    profile_has(Profile, Key),
    profile_get(Profile, Key, Value).

gate_state(Profile, absent) :-
    implements(eu_reg_2022_2554_art_16_1),
    profile_lacks(Profile, financial_entity_is_article_16_1_entity).
gate_state(Profile, true) :-
    implements(eu_reg_2022_2554_art_16_1),
    profile_has(Profile, financial_entity_is_article_16_1_entity),
    profile_get(Profile, financial_entity_is_article_16_1_entity, true).
gate_state(Profile, false) :-
    implements(eu_reg_2022_2554_art_16_1),
    profile_has(Profile, financial_entity_is_article_16_1_entity),
    profile_get(Profile, financial_entity_is_article_16_1_entity, false).

trigger_state(Profile, absent) :-
    implements(eu_reg_2022_2554_art_10_4),
    profile_lacks(Profile, dora_entity_type).
trigger_state(Profile, true) :-
    implements(eu_reg_2022_2554_art_10_4),
    profile_has(Profile, dora_entity_type),
    profile_get(Profile, dora_entity_type, data_reporting_service_provider).
trigger_state(Profile, false) :-
    implements(eu_reg_2022_2554_art_10_4),
    profile_has(Profile, dora_entity_type),
    profile_get(Profile, dora_entity_type, EntityType),
    dif(EntityType, data_reporting_service_provider).

duty_applicability(always, _, yes) :-
    implements(eu_reg_2022_2554_art_9_1).
duty_applicability(data_reporting_service_provider_only, true, yes) :-
    implements(eu_reg_2022_2554_art_10_4).
duty_applicability(data_reporting_service_provider_only, false, no) :-
    implements(eu_reg_2022_2554_art_10_4).
duty_applicability(data_reporting_service_provider_only, absent, maybe) :-
    implements(eu_reg_2022_2554_art_10_4).

duty_view(Profile, Trigger, duty_view(Duty, Key, Citation, Applies, State)) :-
    duty_row(Duty, Key, Citation, Scope),
    duty_applicability(Scope, Trigger, Applies),
    key_state(Profile, Key, State).

duty_views(Profile, Trigger, Views) :-
    findall(View, duty_view(Profile, Trigger, View), Views).

failing_duties(Views, Failing) :-
    findall(Duty - Citation, member(duty_view(Duty, _, Citation, yes, given(false)), Views), Failing).

open_applicability(yes).
open_applicability(maybe).

open_decides_alone(yes, true).
open_decides_alone(maybe, false).

trigger_candidates(absent, absent, [dora_entity_type - false]).
trigger_candidates(absent, given(unsure), [dora_entity_type - false]).
trigger_candidates(absent, given(false), [dora_entity_type - true]).
trigger_candidates(absent, given(true), []).
trigger_candidates(true, _, []).
trigger_candidates(false, _, []).

absent_candidates(Profile, Trigger, Views, Candidates) :-
    implements(eu_reg_2022_2554_art_10_4),
    key_state(Profile, trade_report_checking_systems_in_place, TradeState),
    trigger_candidates(Trigger, TradeState, TriggerCandidates),
    findall(Key - DecidesAlone, open_absent_key(Views, Key, DecidesAlone), DutyCandidates),
    append(TriggerCandidates, DutyCandidates, Candidates).

open_absent_key(Views, Key, DecidesAlone) :-
    member(duty_view(_, Key, _, Applies, absent), Views),
    open_decides_alone(Applies, DecidesAlone).

named_behind_candidate(Candidates, Named) :-
    findall(Key, member(Key - true, Candidates), Alone),
    pick_candidate(Alone, Candidates, Named).

pick_candidate([Key|_], _, key(Key)).
pick_candidate([], [Key - _|_], key(Key)).
pick_candidate([], [], none).

head_candidate([Key - _|_], key(Key)).
head_candidate([], none).

open_unsure_keys(Views, Keys) :-
    findall(Key, open_unsure_key(Views, Key), Keys).

open_unsure_key(Views, Key) :-
    member(duty_view(_, Key, _, Applies, given(unsure)), Views),
    open_applicability(Applies).

referral_citation(Key, Citation) :-
    duty_row(_, Key, Citation, _).

relied_pairs(Profile, Pairs) :-
    root_keys(Keys),
    findall(Key - Value, present_pair(Profile, Keys, Key, Value), Pairs).

present_pair(Profile, Keys, Key, Value) :-
    member(Key, Keys),
    profile_has(Profile, Key),
    profile_get(Profile, Key, Value).

ict_risk_protection_and_detection_duties_required(Profile, input_problems([Problem|Problems]), []) :-
    dora_ict_risk_protection_and_detection_input_problems(Profile, [Problem|Problems]).
ict_risk_protection_and_detection_duties_required(Profile, Result, Citations) :-
    dora_ict_risk_protection_and_detection_input_problems(Profile, []),
    gate_state(Profile, Gate),
    required_by_gate(Gate, Profile, Result, Citations).

required_by_gate(true, _, simplified_framework_entity, [cite(eu_reg_2022_2554_art_16_1)]) :-
    implements(eu_reg_2022_2554_art_16_1).
required_by_gate(absent, _, indeterminate([financial_entity_is_article_16_1_entity]), []) :-
    implements(eu_reg_2022_2554_art_16_1).
required_by_gate(false, Profile, Result, Citations) :-
    implements(eu_reg_2022_2554_art_16_1),
    trigger_state(Profile, Trigger),
    required_by_trigger(Trigger, Profile, Result, Citations).

required_by_trigger(absent, _, indeterminate([dora_entity_type]), []) :-
    implements(eu_reg_2022_2554_art_10_4).
required_by_trigger(true, Profile, required(Duties), [cite(eu_reg_2022_2554_art_9_1), cite(eu_reg_2022_2554_art_9_2), cite(eu_reg_2022_2554_art_9_3), cite(eu_reg_2022_2554_art_9_4), cite(eu_reg_2022_2554_art_10_1), cite(eu_reg_2022_2554_art_10_2), cite(eu_reg_2022_2554_art_10_3), cite(eu_reg_2022_2554_art_10_4)]) :-
    implements(eu_reg_2022_2554_art_10_4),
    applicable_duties(Profile, true, Duties).
required_by_trigger(false, Profile, required(Duties), [cite(eu_reg_2022_2554_art_9_1), cite(eu_reg_2022_2554_art_9_2), cite(eu_reg_2022_2554_art_9_3), cite(eu_reg_2022_2554_art_9_4), cite(eu_reg_2022_2554_art_10_1), cite(eu_reg_2022_2554_art_10_2), cite(eu_reg_2022_2554_art_10_3)]) :-
    implements(eu_reg_2022_2554_art_9_1),
    applicable_duties(Profile, false, Duties).

applicable_duties(Profile, Trigger, Duties) :-
    duty_views(Profile, Trigger, Views),
    findall(Duty, member(duty_view(Duty, _, _, yes, _), Views), Duties).

ict_risk_protection_and_detection_duties_complete(Profile, input_problems([Problem|Problems]), []) :-
    dora_ict_risk_protection_and_detection_input_problems(Profile, [Problem|Problems]).
ict_risk_protection_and_detection_duties_complete(Profile, Result, Citations) :-
    dora_ict_risk_protection_and_detection_input_problems(Profile, []),
    gate_state(Profile, Gate),
    complete_by_gate(Gate, Profile, Result, Citations).

complete_by_gate(true, _, simplified_framework_entity, [cite(eu_reg_2022_2554_art_16_1)]) :-
    implements(eu_reg_2022_2554_art_16_1).
complete_by_gate(absent, _, indeterminate([financial_entity_is_article_16_1_entity]), []) :-
    implements(eu_reg_2022_2554_art_16_1).
complete_by_gate(false, Profile, Result, Citations) :-
    implements(eu_reg_2022_2554_art_16_1),
    trigger_state(Profile, Trigger),
    duty_views(Profile, Trigger, Views),
    failing_duties(Views, Failing),
    complete_after_failures(Failing, Profile, Trigger, Views, Result, Citations).

complete_after_failures([_|_], _, _, _, incomplete, [cite(eu_reg_2022_2554_art_9_1), cite(eu_reg_2022_2554_art_9_2), cite(eu_reg_2022_2554_art_9_3), cite(eu_reg_2022_2554_art_9_4), cite(eu_reg_2022_2554_art_10_1), cite(eu_reg_2022_2554_art_10_2), cite(eu_reg_2022_2554_art_10_3), cite(eu_reg_2022_2554_art_10_4)]) :-
    implements(eu_reg_2022_2554_art_9_1).
complete_after_failures([], Profile, Trigger, Views, Result, Citations) :-
    implements(eu_reg_2022_2554_art_9_1),
    absent_candidates(Profile, Trigger, Views, Candidates),
    named_behind_candidate(Candidates, Named),
    complete_after_absent(Named, Profile, Views, Result, Citations).

complete_after_absent(key(Key), _, _, indeterminate([Key]), []).
complete_after_absent(none, Profile, Views, Result, Citations) :-
    open_unsure_keys(Views, UnsureKeys),
    complete_after_unsure(UnsureKeys, Profile, Result, Citations).

complete_after_unsure([Key|_], Profile, needs_legal_review(open_textured(Key, Citation), [inputs_relied_on(Pairs)]), []) :-
    implements(eu_reg_2022_2554_art_9_1),
    referral_citation(Key, Citation),
    relied_pairs(Profile, Pairs).
complete_after_unsure([], _, complete, [cite(eu_reg_2022_2554_art_9_1), cite(eu_reg_2022_2554_art_9_2), cite(eu_reg_2022_2554_art_9_3), cite(eu_reg_2022_2554_art_9_4), cite(eu_reg_2022_2554_art_10_1), cite(eu_reg_2022_2554_art_10_2), cite(eu_reg_2022_2554_art_10_3), cite(eu_reg_2022_2554_art_10_4)]) :-
    implements(eu_reg_2022_2554_art_9_1).

ict_risk_protection_and_detection_duties_outstanding(Profile, input_problems([Problem|Problems]), []) :-
    dora_ict_risk_protection_and_detection_input_problems(Profile, [Problem|Problems]).
ict_risk_protection_and_detection_duties_outstanding(Profile, Result, Citations) :-
    dora_ict_risk_protection_and_detection_input_problems(Profile, []),
    gate_state(Profile, Gate),
    outstanding_by_gate(Gate, Profile, Result, Citations).

outstanding_by_gate(true, _, simplified_framework_entity, [cite(eu_reg_2022_2554_art_16_1)]) :-
    implements(eu_reg_2022_2554_art_16_1).
outstanding_by_gate(absent, _, indeterminate([financial_entity_is_article_16_1_entity]), []) :-
    implements(eu_reg_2022_2554_art_16_1).
outstanding_by_gate(false, Profile, Result, Citations) :-
    implements(eu_reg_2022_2554_art_16_1),
    trigger_state(Profile, Trigger),
    duty_views(Profile, Trigger, Views),
    absent_candidates(Profile, Trigger, Views, Candidates),
    head_candidate(Candidates, Named),
    outstanding_after_absent(Named, Profile, Views, Result, Citations).

outstanding_after_absent(key(Key), _, _, indeterminate([Key]), []).
outstanding_after_absent(none, Profile, Views, Result, Citations) :-
    open_unsure_keys(Views, UnsureKeys),
    outstanding_after_unsure(UnsureKeys, Profile, Views, Result, Citations).

outstanding_after_unsure([Key|_], Profile, _, needs_legal_review(open_textured(Key, Citation), [inputs_relied_on(Pairs)]), []) :-
    implements(eu_reg_2022_2554_art_9_1),
    referral_citation(Key, Citation),
    relied_pairs(Profile, Pairs).
outstanding_after_unsure([], _, Views, Result, Citations) :-
    failing_duties(Views, Failing),
    outstanding_final(Failing, Result, Citations).

outstanding_final([], none_outstanding, [cite(eu_reg_2022_2554_art_9_1), cite(eu_reg_2022_2554_art_9_2), cite(eu_reg_2022_2554_art_9_3), cite(eu_reg_2022_2554_art_9_4), cite(eu_reg_2022_2554_art_10_1), cite(eu_reg_2022_2554_art_10_2), cite(eu_reg_2022_2554_art_10_3), cite(eu_reg_2022_2554_art_10_4)]) :-
    implements(eu_reg_2022_2554_art_9_1).
outstanding_final([Failure|Failures], outstanding(Duties), Citations) :-
    implements(eu_reg_2022_2554_art_9_1),
    pairs_keys_values([Failure|Failures], Duties, DutyCitations),
    sort(DutyCitations, Citations).

decide_dora_ict_risk_protection_and_detection(Profile, dora_ict_risk_protection_and_detection_verdict(Status, Citations)) :-
    ict_risk_protection_and_detection_duties_complete(Profile, Status, Citations).

dora_ict_risk_protection_and_detection_status(Profile, Status) :-
    decide_dora_ict_risk_protection_and_detection(Profile, dora_ict_risk_protection_and_detection_verdict(Status, _Citations)).

dora_ict_risk_protection_and_detection_decision_resolvable(Profile) :-
    decide_dora_ict_risk_protection_and_detection(Profile, _Verdict).

dora_ict_risk_protection_and_detection_checklist(Profile, [item(input_check, unmet(input_problems([Problem|Problems])), cite(eu_reg_2022_2554_art_9_1))]) :-
    dora_ict_risk_protection_and_detection_input_problems(Profile, [Problem|Problems]).
dora_ict_risk_protection_and_detection_checklist(Profile, [item(article_16_1_entity, GateStatus, cite(eu_reg_2022_2554_art_16_1))|DutyItems]) :-
    dora_ict_risk_protection_and_detection_input_problems(Profile, []),
    gate_state(Profile, Gate),
    gate_item_status(Gate, GateStatus),
    trigger_state(Profile, Trigger),
    duty_views(Profile, Trigger, Views),
    findall(Item, duty_item(Views, Item), DutyItems).

gate_item_status(false, met).
gate_item_status(true, unmet(simplified_framework_entity)).
gate_item_status(absent, unknown([financial_entity_is_article_16_1_entity])).

duty_item(Views, item(Duty, Status, Citation)) :-
    member(duty_view(Duty, Key, Citation, Applies, State), Views),
    duty_item_status(Applies, State, Key, Status).

duty_item_status(no, _, _, inapplicable).
duty_item_status(yes, given(true), _, met).
duty_item_status(yes, given(false), _, unmet(not_performed)).
duty_item_status(yes, given(unsure), Key, unknown([Key])).
duty_item_status(yes, absent, Key, unknown([Key])).
duty_item_status(maybe, given(true), _, met).
duty_item_status(maybe, given(false), _, unknown([dora_entity_type])).
duty_item_status(maybe, given(unsure), Key, unknown([dora_entity_type, Key])).
duty_item_status(maybe, absent, Key, unknown([dora_entity_type, Key])).

test_base(EntityType, [attribute(financial_entity_is_article_16_1_entity, false), attribute(dora_entity_type, EntityType)|DutyAttributes]) :-
    findall(attribute(Key, true), duty_row(_, Key, _, _), DutyAttributes).

test_replace(Key, Value, Attributes, [attribute(Key, Value)|Rest]) :-
    select(attribute(Key, _), Attributes, Rest).

test_remove(Key, Attributes, Rest) :-
    select(attribute(Key, _), Attributes, Rest).

test(all_performed_is_complete) :-
    test_base(credit_institution, Profile),
    ict_risk_protection_and_detection_duties_complete(Profile, complete, _).
test(exactly_one_solution) :-
    test_base(credit_institution, Profile),
    findall(Result - Citations, ict_risk_protection_and_detection_duties_complete(Profile, Result, Citations), Answers),
    length(Answers, 1).
test(twenty_one_duties_for_a_credit_institution) :-
    test_base(credit_institution, Profile),
    ict_risk_protection_and_detection_duties_required(Profile, required(Duties), Citations),
    length(Duties, 21),
    length(Citations, 7).
test(twenty_two_duties_for_a_data_reporting_service_provider) :-
    test_base(data_reporting_service_provider, Profile),
    ict_risk_protection_and_detection_duties_required(Profile, required(Duties), _),
    length(Duties, 22),
    last(Duties, trade_report_checking_systems).
test(gate_true_is_simplified_framework_entity) :-
    test_base(credit_institution, Base),
    test_replace(financial_entity_is_article_16_1_entity, true, Base, Profile),
    ict_risk_protection_and_detection_duties_outstanding(Profile, simplified_framework_entity, [cite(eu_reg_2022_2554_art_16_1)]).
test(gate_absent_is_asked_first) :-
    test_base(credit_institution, Base),
    test_remove(financial_entity_is_article_16_1_entity, Base, Profile),
    ict_risk_protection_and_detection_duties_required(Profile, indeterminate([financial_entity_is_article_16_1_entity]), []).
test(a_false_duty_decides_incomplete_before_absent_keys) :-
    test_base(credit_institution, Base),
    test_remove(dora_entity_type, Base, WithoutType),
    test_remove(monitors_and_controls_security_and_functioning_of_ict_systems, WithoutType, WithoutMonitoring),
    test_replace(patch_and_update_policies_documented, false, WithoutMonitoring, Profile),
    ict_risk_protection_and_detection_duties_complete(Profile, incomplete, _).
test(trade_key_false_puts_the_trigger_first) :-
    test_base(credit_institution, Base),
    test_remove(dora_entity_type, Base, WithoutType),
    test_remove(monitors_and_controls_security_and_functioning_of_ict_systems, WithoutType, WithoutMonitoring),
    test_replace(trade_report_checking_systems_in_place, false, WithoutMonitoring, Profile),
    ict_risk_protection_and_detection_duties_complete(Profile, indeterminate([dora_entity_type]), []).
test(trigger_is_behind_an_absent_always_duty_key) :-
    test_base(credit_institution, Base),
    test_remove(dora_entity_type, Base, WithoutType),
    test_remove(monitors_and_controls_security_and_functioning_of_ict_systems, WithoutType, WithoutMonitoring),
    test_remove(trade_report_checking_systems_in_place, WithoutMonitoring, Profile),
    ict_risk_protection_and_detection_duties_complete(Profile, indeterminate([monitors_and_controls_security_and_functioning_of_ict_systems]), []).
test(outstanding_names_the_trigger_first) :-
    test_base(credit_institution, Base),
    test_remove(dora_entity_type, Base, WithoutType),
    test_remove(monitors_and_controls_security_and_functioning_of_ict_systems, WithoutType, WithoutMonitoring),
    test_remove(trade_report_checking_systems_in_place, WithoutMonitoring, Profile),
    ict_risk_protection_and_detection_duties_outstanding(Profile, indeterminate([dora_entity_type]), []).
test(outstanding_lists_failing_duties_in_duty_order) :-
    test_base(credit_institution, Base),
    test_replace(patch_and_update_policies_documented, false, Base, WithPatch),
    test_replace(monitors_and_controls_security_and_functioning_of_ict_systems, false, WithPatch, Profile),
    ict_risk_protection_and_detection_duties_outstanding(Profile, outstanding([monitoring_and_control_of_ict_systems, patch_and_update_policies]), Citations),
    sort(Citations, [cite(eu_reg_2022_2554_art_9_1), cite(eu_reg_2022_2554_art_9_4_f)]).
test(trade_key_not_read_for_other_types) :-
    test_base(credit_institution, Base),
    test_replace(trade_report_checking_systems_in_place, false, Base, Profile),
    ict_risk_protection_and_detection_duties_outstanding(Profile, none_outstanding, _).
test(unsure_duty_goes_to_a_lawyer) :-
    test_base(credit_institution, Base),
    test_replace(deploys_ict_security_tools_policies_and_procedures, unsure, Base, Profile),
    ict_risk_protection_and_detection_duties_complete(Profile, needs_legal_review(open_textured(deploys_ict_security_tools_policies_and_procedures, cite(eu_reg_2022_2554_art_9_1)), [inputs_relied_on(Pairs)]), []),
    length(Pairs, 24).
test(unknown_key_is_an_input_problem) :-
    ict_risk_protection_and_detection_duties_complete([attribute(colour, true)], input_problems([unknown_key(colour)]), []).

test(all_performed_is_not_incomplete, fail) :-
    test_base(credit_institution, Profile),
    ict_risk_protection_and_detection_duties_complete(Profile, incomplete, _).
test(unknown_key_is_not_complete, fail) :-
    ict_risk_protection_and_detection_duties_complete([attribute(colour, true)], complete, _).
