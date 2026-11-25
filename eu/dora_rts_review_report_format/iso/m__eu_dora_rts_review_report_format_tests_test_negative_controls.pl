% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_rts_review_report_format_tests_test_negative_controls, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_dora_rts_review_report_format_dora_rts_review_report_format, [dora_rts_review_report_format_status/2, dora_rts_review_report_format_status_values/1, ict_risk_framework_review_report_duties_required/3, ict_risk_framework_review_report_duties_outstanding/3]).
:- use_module(m__eu_dora_rts_review_report_format_fixtures, [dora_rts_review_report_format_profile_for/2]).

subject_status(Subject, Status) :-
    dora_rts_review_report_format_profile_for(Subject, Profile),
    dora_rts_review_report_format_status(Profile, Status).

subject_required(Subject, Result) :-
    dora_rts_review_report_format_profile_for(Subject, Profile),
    ict_risk_framework_review_report_duties_required(Profile, Result, _).

subject_outstanding(Subject, Result) :-
    dora_rts_review_report_format_profile_for(Subject, Profile),
    ict_risk_framework_review_report_duties_outstanding(Profile, Result, _).

test(the_status_table_names_every_final_answer) :-
    dora_rts_review_report_format_status_values(StatusValues),
    StatusValues == [complete, incomplete, simplified_framework_entity, framework_review_report_not_requested].
test(the_baseline_profile_yields_exactly_one_status) :-
    dora_rts_review_report_format_profile_for(scheduled_review_complete, Profile),
    findall(Status, dora_rts_review_report_format_status(Profile, Status), [_]).
test(complete_route_positive) :-
    subject_status(scheduled_review_complete, complete).
test(incomplete_route_positive) :-
    subject_status(missing_executive_summary, incomplete).
test(gate_route_positive) :-
    subject_status(article_16_1_entity, simplified_framework_entity).
test(gate_absent_positive) :-
    subject_status(gate_absent, indeterminate([financial_entity_is_article_16_1_entity])).
test(request_route_positive) :-
    subject_status(not_requested, framework_review_report_not_requested).
test(request_absent_positive) :-
    subject_status(request_absent, indeterminate([authority_requested_framework_review_report])).
test(supervisory_initiation_positive) :-
    subject_status(supervisory_initiation_references_missing, incomplete).
test(incident_initiation_positive) :-
    subject_status(incident_initiation_list_missing, incomplete).
test(uncorrected_weaknesses_positive) :-
    subject_status(uncorrected_weaknesses_explanation_missing, incomplete).
test(ineffective_measures_positive) :-
    subject_status(ineffective_measures_improvements_missing, incomplete).
test(non_microenterprise_positive) :-
    subject_status(other_entity_without_internal_audit, incomplete).
test(internal_audit_required_for_other_entities) :-
    subject_required(other_entity_without_internal_audit, required(Duties)),
    member(report_uses_internal_audit_results, Duties).
test(required_names_the_absent_trigger) :-
    subject_required(microenterprise_absent, indeterminate([financial_entity_is_microenterprise])).
test(trigger_over_a_false_duty_is_named) :-
    subject_status(microenterprise_absent_audit_missing, indeterminate([financial_entity_is_microenterprise])).
test(referral_positive) :-
    subject_status(unsure_format, needs_legal_review(open_textured(review_report_in_searchable_electronic_format, cite(eu_reg_2024_1774_art_27_1)), _)).
test(missing_key_positive) :-
    subject_status(absent_format, indeterminate([review_report_in_searchable_electronic_format])).
test(outstanding_positive) :-
    subject_outstanding(missing_executive_summary, outstanding([report_gives_executive_summary])).
test(none_outstanding_positive) :-
    subject_outstanding(scheduled_review_complete, none_outstanding).
test(input_problems_positive) :-
    subject_status(input_wrong_type_fact, input_problems([wrong_type(financial_entity_is_microenterprise)])).
test(not_an_attribute_list_positive) :-
    subject_status(not_attribute_list, input_problems([wrong_type(profile)])).

test(the_baseline_profile_yields_no_other_table_status, fail) :-
    dora_rts_review_report_format_profile_for(scheduled_review_complete, Profile),
    findall(Status, dora_rts_review_report_format_status(Profile, Status), [BaselineStatus]),
    dora_rts_review_report_format_status_values(StatusValues),
    member(Other, StatusValues),
    dif(Other, BaselineStatus),
    dora_rts_review_report_format_status(Profile, Other).
test(complete_route_near_miss_one_missing_item, fail) :-
    subject_status(missing_executive_summary, complete).
test(incomplete_route_near_miss_item_present, fail) :-
    subject_status(scheduled_review_complete, incomplete).
test(gate_route_near_miss_gate_false, fail) :-
    subject_status(scheduled_review_complete, simplified_framework_entity).
test(gate_absent_near_miss_gate_true, fail) :-
    subject_status(article_16_1_entity, indeterminate(_)).
test(request_route_near_miss_request_true, fail) :-
    subject_status(scheduled_review_complete, framework_review_report_not_requested).
test(request_absent_near_miss_request_false, fail) :-
    subject_status(not_requested, indeterminate(_)).
test(supervisory_initiation_near_miss_scheduled_review, fail) :-
    subject_status(scheduled_review_references_missing, incomplete).
test(incident_initiation_near_miss_scheduled_review, fail) :-
    subject_status(scheduled_review_incident_list_missing, incomplete).
test(uncorrected_weaknesses_near_miss_all_corrected, fail) :-
    subject_status(corrected_weaknesses_explanation_missing, incomplete).
test(ineffective_measures_near_miss_effective, fail) :-
    subject_status(effective_measures_improvements_missing, incomplete).
test(non_microenterprise_near_miss_microenterprise, fail) :-
    subject_status(microenterprise_without_internal_audit, incomplete).
test(internal_audit_not_required_for_a_microenterprise, fail) :-
    subject_required(microenterprise_without_internal_audit, required(Duties)),
    member(report_uses_internal_audit_results, Duties).
test(required_with_every_trigger_gives_a_list, fail) :-
    subject_required(scheduled_review_complete, indeterminate(_)).
test(trigger_over_a_true_duty_is_not_named, fail) :-
    subject_status(microenterprise_absent, indeterminate(_)).
test(referral_near_miss_a_false_duty_decides, fail) :-
    subject_status(false_beats_unsure, needs_legal_review(_, _)).
test(referral_near_miss_an_absent_key_comes_first, fail) :-
    subject_status(absent_beats_unsure, needs_legal_review(_, _)).
test(missing_key_near_miss_key_present, fail) :-
    subject_status(scheduled_review_complete, indeterminate(_)).
test(outstanding_near_miss_item_present, fail) :-
    subject_outstanding(scheduled_review_complete, outstanding(_)).
test(none_outstanding_near_miss_item_missing, fail) :-
    subject_outstanding(missing_executive_summary, none_outstanding).
test(input_problems_near_miss_well_formed, fail) :-
    subject_status(scheduled_review_complete, input_problems(_)).

cp_test_names([the_status_table_names_every_final_answer, the_baseline_profile_yields_exactly_one_status, complete_route_positive, incomplete_route_positive, gate_route_positive, gate_absent_positive, request_route_positive, request_absent_positive, supervisory_initiation_positive, incident_initiation_positive, uncorrected_weaknesses_positive, ineffective_measures_positive, non_microenterprise_positive, internal_audit_required_for_other_entities, required_names_the_absent_trigger, trigger_over_a_false_duty_is_named, referral_positive, missing_key_positive, outstanding_positive, none_outstanding_positive, input_problems_positive, not_an_attribute_list_positive]).
cp_test_fail_names([the_baseline_profile_yields_no_other_table_status, complete_route_near_miss_one_missing_item, incomplete_route_near_miss_item_present, gate_route_near_miss_gate_false, gate_absent_near_miss_gate_true, request_route_near_miss_request_true, request_absent_near_miss_request_false, supervisory_initiation_near_miss_scheduled_review, incident_initiation_near_miss_scheduled_review, uncorrected_weaknesses_near_miss_all_corrected, ineffective_measures_near_miss_effective, non_microenterprise_near_miss_microenterprise, internal_audit_not_required_for_a_microenterprise, required_with_every_trigger_gives_a_list, trigger_over_a_true_duty_is_not_named, referral_near_miss_a_false_duty_decides, referral_near_miss_an_absent_key_comes_first, missing_key_near_miss_key_present, outstanding_near_miss_item_present, none_outstanding_near_miss_item_missing, input_problems_near_miss_well_formed]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
