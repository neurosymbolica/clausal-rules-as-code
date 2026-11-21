% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_ict_risk_protection_and_detection_tests_test_negative_controls, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_dora_ict_risk_protection_and_detection_dora_ict_risk_protection_and_detection, [ict_risk_protection_and_detection_duties_required/3, ict_risk_protection_and_detection_duties_complete/3, ict_risk_protection_and_detection_duties_outstanding/3, dora_ict_risk_protection_and_detection_status/2, dora_ict_risk_protection_and_detection_status_values/1]).
:- use_module(m__eu_dora_ict_risk_protection_and_detection_fixtures, [dora_ict_risk_protection_and_detection_profile_for/2]).

status_of(Subject, Status) :-
    dora_ict_risk_protection_and_detection_profile_for(Subject, Profile),
    dora_ict_risk_protection_and_detection_status(Profile, Status).

with_value(Key, Value, Profile, [attribute(Key, Value)|Rest]) :-
    select(attribute(Key, _), Profile, Rest).

without_key(Key, Profile, Rest) :-
    select(attribute(Key, _), Profile, Rest).

false_and_absent_profile(Profile) :-
    dora_ict_risk_protection_and_detection_profile_for(credit_institution_all_duties_performed, Base),
    with_value(patch_and_update_policies_documented, false, Base, WithPatch),
    without_key(anomaly_detection_mechanisms_in_place, WithPatch, Profile).

test(the_status_table_has_a_near_miss_atom) :-
    dora_ict_risk_protection_and_detection_status_values(StatusValues),
    StatusValues = [_, _|_].
test(the_baseline_profile_yields_exactly_one_status) :-
    dora_ict_risk_protection_and_detection_profile_for(credit_institution_all_duties_performed, Profile),
    findall(Status, dora_ict_risk_protection_and_detection_status(Profile, Status), [_]).
test(all_performed_is_complete) :-
    status_of(credit_institution_all_duties_performed, complete).
test(one_duty_not_performed_is_incomplete) :-
    status_of(credit_institution_patch_policies_not_documented, incomplete).
test(trade_report_duty_binds_a_data_reporting_service_provider) :-
    status_of(data_reporting_provider_trade_report_checking_not_in_place, incomplete).
test(trade_report_duty_does_not_bind_a_credit_institution) :-
    status_of(credit_institution_trade_report_checking_not_in_place, complete).
test(trade_report_unsure_is_complete_for_a_credit_institution) :-
    status_of(credit_institution_trade_report_checking_unsure, complete).
test(required_lists_the_trade_report_duty_for_a_provider) :-
    dora_ict_risk_protection_and_detection_profile_for(data_reporting_provider_all_duties_performed, Profile),
    ict_risk_protection_and_detection_duties_required(Profile, required(Duties), _),
    member(trade_report_checking_systems, Duties).
test(gate_true_is_simplified_framework_entity) :-
    status_of(article_16_1_entity_with_duties_not_performed, simplified_framework_entity).
test(gate_absent_is_asked_first) :-
    status_of(article_16_1_status_unanswered, indeterminate([financial_entity_is_article_16_1_entity])).
test(an_absent_always_duty_key_comes_before_the_trigger) :-
    status_of(entity_type_monitoring_and_trade_report_checking_unanswered, indeterminate([monitors_and_controls_security_and_functioning_of_ict_systems])).
test(trade_report_false_puts_the_trigger_first) :-
    status_of(entity_type_and_monitoring_unanswered_trade_report_checking_not_in_place, indeterminate([dora_entity_type])).
test(the_trigger_comes_before_the_trade_report_key) :-
    status_of(entity_type_and_trade_report_checking_unanswered, indeterminate([dora_entity_type])).
test(trade_report_true_makes_the_trigger_irrelevant) :-
    status_of(entity_type_unanswered_trade_report_checking_in_place, complete).
test(outstanding_names_the_trigger_first) :-
    dora_ict_risk_protection_and_detection_profile_for(entity_type_monitoring_and_trade_report_checking_unanswered, Profile),
    ict_risk_protection_and_detection_duties_outstanding(Profile, indeterminate([dora_entity_type]), []).
test(a_false_key_settles_completeness) :-
    false_and_absent_profile(Profile),
    ict_risk_protection_and_detection_duties_complete(Profile, incomplete, _).
test(a_false_key_does_not_settle_the_outstanding_list) :-
    false_and_absent_profile(Profile),
    ict_risk_protection_and_detection_duties_outstanding(Profile, indeterminate([anomaly_detection_mechanisms_in_place]), []).
test(an_unsure_duty_is_referred) :-
    status_of(security_tools_deployment_unsure, needs_legal_review(open_textured(deploys_ict_security_tools_policies_and_procedures, cite(eu_reg_2022_2554_art_9_1)), [inputs_relied_on(_)])).
test(a_false_duty_decides_before_the_unsure_one) :-
    status_of(security_tools_deployment_unsure_patch_policies_not_documented, incomplete).
test(an_absent_key_is_named_before_the_unsure_one) :-
    status_of(security_tools_deployment_unsure_anomaly_detection_unanswered, indeterminate([anomaly_detection_mechanisms_in_place])).
test(an_ict_third_party_service_provider_is_answered_as_any_type) :-
    status_of(ict_third_party_service_provider_all_duties_performed, complete).
test(an_unsure_gate_is_wrong_type) :-
    status_of(article_16_1_status_given_as_unsure, input_problems([wrong_type(financial_entity_is_article_16_1_entity)])).
test(an_unknown_key_is_named) :-
    status_of(unknown_key_given, input_problems([unknown_key(colour)])).
test(a_repeated_key_is_a_duplicate) :-
    status_of(anomaly_detection_given_twice, input_problems([duplicate_key(anomaly_detection_mechanisms_in_place)])).

test(the_baseline_profile_yields_no_other_table_status, fail) :-
    dora_ict_risk_protection_and_detection_profile_for(credit_institution_all_duties_performed, Profile),
    findall(Status, dora_ict_risk_protection_and_detection_status(Profile, Status), [BaselineStatus]),
    dora_ict_risk_protection_and_detection_status_values(StatusValues),
    member(Other, StatusValues),
    dif(Other, BaselineStatus),
    dora_ict_risk_protection_and_detection_status(Profile, Other).
test(all_performed_is_not_incomplete, fail) :-
    status_of(credit_institution_all_duties_performed, incomplete).
test(one_duty_not_performed_is_not_complete, fail) :-
    status_of(credit_institution_patch_policies_not_documented, complete).
test(trade_report_duty_not_performed_is_not_incomplete_for_a_credit_institution, fail) :-
    status_of(credit_institution_trade_report_checking_not_in_place, incomplete).
test(trade_report_unsure_is_not_referred_for_a_credit_institution, fail) :-
    status_of(credit_institution_trade_report_checking_unsure, needs_legal_review(_, _)).
test(required_does_not_list_the_trade_report_duty_for_a_credit_institution, fail) :-
    dora_ict_risk_protection_and_detection_profile_for(credit_institution_all_duties_performed, Profile),
    ict_risk_protection_and_detection_duties_required(Profile, required(Duties), _),
    member(trade_report_checking_systems, Duties).
test(required_does_not_cite_art_10_4_for_a_credit_institution, fail) :-
    dora_ict_risk_protection_and_detection_profile_for(credit_institution_all_duties_performed, Profile),
    ict_risk_protection_and_detection_duties_required(Profile, required(_), Citations),
    member(cite(eu_reg_2022_2554_art_10_4), Citations).
test(gate_false_is_not_simplified_framework_entity, fail) :-
    status_of(credit_institution_all_duties_performed, simplified_framework_entity).
test(gate_present_is_not_asked, fail) :-
    status_of(credit_institution_all_duties_performed, indeterminate(_)).
test(the_trigger_is_behind_an_absent_always_duty_key, fail) :-
    status_of(entity_type_monitoring_and_trade_report_checking_unanswered, indeterminate([dora_entity_type])).
test(trade_report_false_does_not_put_the_always_key_first, fail) :-
    status_of(entity_type_and_monitoring_unanswered_trade_report_checking_not_in_place, indeterminate([monitors_and_controls_security_and_functioning_of_ict_systems])).
test(the_trade_report_key_is_not_named_before_the_trigger, fail) :-
    status_of(entity_type_and_trade_report_checking_unanswered, indeterminate([trade_report_checking_systems_in_place])).
test(trade_report_true_does_not_ask_the_trigger, fail) :-
    status_of(entity_type_unanswered_trade_report_checking_in_place, indeterminate(_)).
test(outstanding_does_not_name_the_always_key_first, fail) :-
    dora_ict_risk_protection_and_detection_profile_for(entity_type_monitoring_and_trade_report_checking_unanswered, Profile),
    ict_risk_protection_and_detection_duties_outstanding(Profile, indeterminate([monitors_and_controls_security_and_functioning_of_ict_systems]), []).
test(the_outstanding_list_is_not_given_with_a_key_absent, fail) :-
    false_and_absent_profile(Profile),
    ict_risk_protection_and_detection_duties_outstanding(Profile, outstanding(_), _).
test(an_unsure_duty_is_not_complete, fail) :-
    status_of(security_tools_deployment_unsure, complete).
test(a_false_duty_is_not_referred, fail) :-
    status_of(security_tools_deployment_unsure_patch_policies_not_documented, needs_legal_review(_, _)).
test(an_absent_key_is_not_referred, fail) :-
    status_of(security_tools_deployment_unsure_anomaly_detection_unanswered, needs_legal_review(_, _)).
test(a_repeated_key_is_not_judged, fail) :-
    status_of(anomaly_detection_given_twice, incomplete).
test(a_well_formed_profile_has_no_input_problem, fail) :-
    status_of(credit_institution_all_duties_performed, input_problems(_)).

cp_test_names([the_status_table_has_a_near_miss_atom, the_baseline_profile_yields_exactly_one_status, all_performed_is_complete, one_duty_not_performed_is_incomplete, trade_report_duty_binds_a_data_reporting_service_provider, trade_report_duty_does_not_bind_a_credit_institution, trade_report_unsure_is_complete_for_a_credit_institution, required_lists_the_trade_report_duty_for_a_provider, gate_true_is_simplified_framework_entity, gate_absent_is_asked_first, an_absent_always_duty_key_comes_before_the_trigger, trade_report_false_puts_the_trigger_first, the_trigger_comes_before_the_trade_report_key, trade_report_true_makes_the_trigger_irrelevant, outstanding_names_the_trigger_first, a_false_key_settles_completeness, a_false_key_does_not_settle_the_outstanding_list, an_unsure_duty_is_referred, a_false_duty_decides_before_the_unsure_one, an_absent_key_is_named_before_the_unsure_one, an_ict_third_party_service_provider_is_answered_as_any_type, an_unsure_gate_is_wrong_type, an_unknown_key_is_named, a_repeated_key_is_a_duplicate]).
cp_test_fail_names([the_baseline_profile_yields_no_other_table_status, all_performed_is_not_incomplete, one_duty_not_performed_is_not_complete, trade_report_duty_not_performed_is_not_incomplete_for_a_credit_institution, trade_report_unsure_is_not_referred_for_a_credit_institution, required_does_not_list_the_trade_report_duty_for_a_credit_institution, required_does_not_cite_art_10_4_for_a_credit_institution, gate_false_is_not_simplified_framework_entity, gate_present_is_not_asked, the_trigger_is_behind_an_absent_always_duty_key, trade_report_false_does_not_put_the_always_key_first, the_trade_report_key_is_not_named_before_the_trigger, trade_report_true_does_not_ask_the_trigger, outstanding_does_not_name_the_always_key_first, the_outstanding_list_is_not_given_with_a_key_absent, an_unsure_duty_is_not_complete, a_false_duty_is_not_referred, an_absent_key_is_not_referred, a_repeated_key_is_not_judged, a_well_formed_profile_has_no_input_problem]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
