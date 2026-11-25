% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_rts_incident_policy_and_detection_tests_test_public_interface, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_lists_extra, [clausal_msort/2]).
:- use_module(m__eu_dora_rts_incident_policy_and_detection_dora_rts_incident_policy_and_detection, [decide_dora_rts_incident_policy_and_detection/2, dora_rts_incident_policy_and_detection_status/2, dora_rts_incident_policy_and_detection_checklist/2, dora_rts_incident_policy_and_detection_decision_resolvable/1, dora_rts_incident_policy_and_detection_status_values/1]).
:- use_module(m__eu_dora_rts_incident_policy_and_detection_fixtures, [dora_rts_incident_policy_and_detection_subject/1, dora_rts_incident_policy_and_detection_profile_for/2, dora_rts_incident_policy_and_detection_assess/2]).
:- use_module(m__eu_dora_rts_incident_policy_and_detection_dora_rts_incident_policy_and_detection, [rts_incident_policy_and_detection_duties_required/3, rts_incident_policy_and_detection_duties_complete/3, rts_incident_policy_and_detection_duties_outstanding/3]).
:- use_module(m__eu_dora_rts_incident_policy_and_detection_kernel, [dora_rts_incident_policy_and_detection_input_problems/2]).
:- use_module(m__eu_dora_rts_incident_policy_and_detection_queries, [dora_rts_incident_policy_and_detection_what_if/4]).

expected_status(complete_entity, complete).
expected_status(simplified_entity, simplified_framework_entity).
expected_status(simplified_entity_with_failures, simplified_framework_entity).
expected_status(gate_not_stated, indeterminate).
expected_status(gate_not_stated_with_failures, indeterminate).
expected_status(prioritisation_not_performed, incomplete).
expected_status(secure_retention_not_performed, incomplete).
expected_status(automated_alerts_not_performed, incomplete).
expected_status(several_duties_not_performed, incomplete).
expected_status(retention_not_answered, indeterminate).
expected_status(failure_beside_unanswered, incomplete).
expected_status(prioritisation_unsure, needs_legal_review).
expected_status(unsure_beside_unanswered, indeterminate).
expected_status(unsure_beside_failure, incomplete).
expected_status(two_duties_unsure, needs_legal_review).
expected_status(unknown_key_present, input_problems).
expected_status(gate_unsure, input_problems).
expected_status(duplicate_duty_key, input_problems).
expected_status(numeric_judgement_value, input_problems).
expected_status(several_input_problems, input_problems).
expected_status(not_an_attribute_list, input_problems).

fixed_citations_sorted(SortedCitations) :-
    clausal_msort([cite(eu_reg_2024_1774_art_22), cite(eu_reg_2024_1774_art_23_1), cite(eu_reg_2024_1774_art_23_2), cite(eu_reg_2024_1774_art_23_3), cite(eu_reg_2024_1774_art_23_4), cite(eu_reg_2024_1774_art_23_5), cite(eu_reg_2024_1774_art_23_6)], SortedCitations).

all_duties([ict_related_incident_policy, documentation_of_incident_management_process, list_of_relevant_contacts, incident_management_mechanisms, retention_of_incident_evidence, analysis_of_significant_or_recurring_incidents, secure_retention_of_incident_evidence, detection_and_response_roles_and_responsibilities, collection_monitoring_and_analysis, identification_of_anomalies_and_alerting_tools, prioritisation_of_alerts, recording_and_evaluation_of_anomalous_activities, automated_alerts_on_data_source_and_log_integrity, protection_of_records_of_anomalous_activities, logging_of_detected_anomalous_activities, consideration_of_incident_detection_criteria, consideration_of_criticality_of_affected_services]).

subject_status(Subject, Status) :-
    dora_rts_incident_policy_and_detection_assess(Subject, dora_rts_incident_policy_and_detection_verdict(Status, _Citations)).

single_verdict(Subject) :-
    findall(Verdict, dora_rts_incident_policy_and_detection_assess(Subject, Verdict), Verdicts),
    length(Verdicts, 1).

single_answer_per_query(Subject) :-
    dora_rts_incident_policy_and_detection_profile_for(Subject, Profile),
    findall(Result - Citations, rts_incident_policy_and_detection_duties_required(Profile, Result, Citations), RequiredAnswers),
    length(RequiredAnswers, 1),
    findall(Result - Citations, rts_incident_policy_and_detection_duties_complete(Profile, Result, Citations), CompleteAnswers),
    length(CompleteAnswers, 1),
    findall(Result - Citations, rts_incident_policy_and_detection_duties_outstanding(Profile, Result, Citations), OutstandingAnswers),
    length(OutstandingAnswers, 1),
    findall(Problems, dora_rts_incident_policy_and_detection_input_problems(Profile, Problems), ProblemAnswers),
    length(ProblemAnswers, 1).

non_empty_checklist(Subject) :-
    dora_rts_incident_policy_and_detection_profile_for(Subject, Profile),
    dora_rts_incident_policy_and_detection_checklist(Profile, [_FirstItem|_OtherItems]).

cited_item(item(_, _, cite(_))).

referral_context([inputs_relied_on(_)]).
referral_context([inputs_relied_on(_), provenance(_, _)]).

duty_complete(Subject, Result, Citations) :-
    dora_rts_incident_policy_and_detection_profile_for(Subject, Profile),
    rts_incident_policy_and_detection_duties_complete(Profile, Result, Citations).

duty_outstanding(Subject, Result, Citations) :-
    dora_rts_incident_policy_and_detection_profile_for(Subject, Profile),
    rts_incident_policy_and_detection_duties_outstanding(Profile, Result, Citations).

duty_required(Subject, Result, Citations) :-
    dora_rts_incident_policy_and_detection_profile_for(Subject, Profile),
    rts_incident_policy_and_detection_duties_required(Profile, Result, Citations).

test(each_subject_gets_its_expected_status) :-
    findall(Subject - Status, (dora_rts_incident_policy_and_detection_subject(Subject), subject_status(Subject, Status)), Obtained),
    findall(Subject - Status, (dora_rts_incident_policy_and_detection_subject(Subject), expected_status(Subject, Status)), Expected),
    Obtained == Expected.
test(each_subject_has_exactly_one_verdict) :-
    findall(Subject, dora_rts_incident_policy_and_detection_subject(Subject), Subjects),
    maplist(single_verdict, Subjects).
test(each_query_answers_exactly_once_for_each_subject) :-
    findall(Subject, dora_rts_incident_policy_and_detection_subject(Subject), Subjects),
    maplist(single_answer_per_query, Subjects).
test(each_subject_has_a_non_empty_checklist) :-
    findall(Subject, dora_rts_incident_policy_and_detection_subject(Subject), Subjects),
    maplist(non_empty_checklist, Subjects).
test(each_status_is_in_the_status_vocabulary) :-
    dora_rts_incident_policy_and_detection_status_values(StatusValues),
    findall(Status, (dora_rts_incident_policy_and_detection_subject(Subject), subject_status(Subject, Status)), Statuses),
    sort(Statuses, DistinctStatuses),
    clausal_msort(StatusValues, SortedValues),
    DistinctStatuses == SortedValues.
test(each_subject_is_resolvable) :-
    findall(Subject, dora_rts_incident_policy_and_detection_subject(Subject), Subjects),
    maplist(dora_rts_incident_policy_and_detection_profile_for, Subjects, Profiles),
    maplist(dora_rts_incident_policy_and_detection_decision_resolvable, Profiles).
test(complete_entity_is_complete) :-
    subject_status(complete_entity, complete).
test(complete_entity_cites_the_fixed_citations) :-
    dora_rts_incident_policy_and_detection_assess(complete_entity, dora_rts_incident_policy_and_detection_verdict(complete, Citations)),
    clausal_msort(Citations, SortedCitations),
    fixed_citations_sorted(SortedCitations).
test(complete_entity_has_none_outstanding) :-
    duty_outstanding(complete_entity, none_outstanding, Citations),
    clausal_msort(Citations, SortedCitations),
    fixed_citations_sorted(SortedCitations).
test(complete_entity_is_required_every_duty_in_duty_order) :-
    duty_required(complete_entity, required(Duties), Citations),
    all_duties(Duties),
    clausal_msort(Citations, SortedCitations),
    fixed_citations_sorted(SortedCitations).
test(complete_entity_checklist_cites_every_item) :-
    dora_rts_incident_policy_and_detection_profile_for(complete_entity, Profile),
    dora_rts_incident_policy_and_detection_checklist(Profile, Items),
    length(Items, 18),
    maplist(cited_item, Items),
    member(item(consideration_of_criticality_of_affected_services, met, cite(eu_reg_2024_1774_art_23_6)), Items).
test(complete_entity_has_no_input_problems) :-
    dora_rts_incident_policy_and_detection_profile_for(complete_entity, Profile),
    dora_rts_incident_policy_and_detection_input_problems(Profile, []).
test(simplified_entity_is_simplified_framework_entity) :-
    duty_complete(simplified_entity, simplified_framework_entity, [cite(eu_reg_2022_2554_art_16_1)]).
test(simplified_entity_with_failures_is_still_simplified) :-
    duty_outstanding(simplified_entity_with_failures, simplified_framework_entity, [cite(eu_reg_2022_2554_art_16_1)]),
    duty_required(simplified_entity_with_failures, simplified_framework_entity, [cite(eu_reg_2022_2554_art_16_1)]).
test(gate_not_stated_is_asked_first) :-
    duty_complete(gate_not_stated, indeterminate([financial_entity_is_article_16_1_entity]), []),
    duty_required(gate_not_stated, indeterminate([financial_entity_is_article_16_1_entity]), []).
test(gate_not_stated_with_failures_asks_the_gate) :-
    duty_outstanding(gate_not_stated_with_failures, indeterminate([financial_entity_is_article_16_1_entity]), []).
test(prioritisation_not_performed_is_incomplete) :-
    duty_complete(prioritisation_not_performed, incomplete, Citations),
    clausal_msort(Citations, SortedCitations),
    fixed_citations_sorted(SortedCitations).
test(prioritisation_not_performed_is_outstanding) :-
    duty_outstanding(prioritisation_not_performed, outstanding([prioritisation_of_alerts]), [cite(eu_reg_2024_1774_art_23_2_c)]).
test(prioritisation_not_performed_checklist_marks_the_duty) :-
    dora_rts_incident_policy_and_detection_profile_for(prioritisation_not_performed, Profile),
    dora_rts_incident_policy_and_detection_checklist(Profile, Items),
    member(item(prioritisation_of_alerts, unmet(not_performed), cite(eu_reg_2024_1774_art_23_2_c)), Items).
test(secure_retention_is_cited_by_article_22) :-
    duty_outstanding(secure_retention_not_performed, outstanding([secure_retention_of_incident_evidence]), [cite(eu_reg_2024_1774_art_22)]).
test(automated_alerts_are_cited_by_article_23_2) :-
    duty_outstanding(automated_alerts_not_performed, outstanding([automated_alerts_on_data_source_and_log_integrity]), [cite(eu_reg_2024_1774_art_23_2)]).
test(several_duties_are_outstanding_in_duty_order) :-
    duty_outstanding(several_duties_not_performed, outstanding(Duties), Citations),
    Duties == [ict_related_incident_policy, secure_retention_of_incident_evidence, consideration_of_criticality_of_affected_services],
    clausal_msort(Citations, SortedCitations),
    SortedCitations == [cite(eu_reg_2024_1774_art_22), cite(eu_reg_2024_1774_art_23_6)].
test(several_duties_not_performed_is_incomplete) :-
    duty_complete(several_duties_not_performed, incomplete, _).
test(retention_not_answered_names_the_key) :-
    duty_complete(retention_not_answered, indeterminate([incident_evidence_retained_for_a_period_no_longer_than_necessary]), []),
    duty_outstanding(retention_not_answered, indeterminate([incident_evidence_retained_for_a_period_no_longer_than_necessary]), []).
test(retention_not_answered_is_still_required_everything) :-
    duty_required(retention_not_answered, required(Duties), _),
    all_duties(Duties).
test(a_failure_decides_before_an_absent_key_in_complete) :-
    duty_complete(failure_beside_unanswered, incomplete, _).
test(a_failure_does_not_end_the_outstanding_query) :-
    duty_outstanding(failure_beside_unanswered, indeterminate([incident_evidence_retained_for_a_period_no_longer_than_necessary]), []).
test(prioritisation_unsure_is_referred_with_every_pair) :-
    duty_complete(prioritisation_unsure, needs_legal_review(open_textured(alerts_prioritised_within_expected_resolution_time, cite(eu_reg_2024_1774_art_23_2_c)), [inputs_relied_on(Pairs)]), []),
    length(Pairs, 18),
    Pairs = [financial_entity_is_article_16_1_entity - false|_],
    member(alerts_prioritised_within_expected_resolution_time - unsure, Pairs).
test(prioritisation_unsure_is_referred_by_outstanding) :-
    duty_outstanding(prioritisation_unsure, needs_legal_review(open_textured(alerts_prioritised_within_expected_resolution_time, cite(eu_reg_2024_1774_art_23_2_c)), [inputs_relied_on(_)]), []).
test(the_referral_context_is_inputs_relied_on_with_an_optional_provenance) :-
    duty_complete(prioritisation_unsure, needs_legal_review(open_textured(alerts_prioritised_within_expected_resolution_time, cite(eu_reg_2024_1774_art_23_2_c)), ReferralContext), []),
    referral_context(ReferralContext).
test(an_absent_key_is_named_before_an_unsure_one) :-
    duty_complete(unsure_beside_unanswered, indeterminate([criticality_of_affected_services_considered]), []),
    duty_outstanding(unsure_beside_unanswered, indeterminate([criticality_of_affected_services_considered]), []).
test(a_failure_decides_before_an_unsure_key_in_complete) :-
    duty_complete(unsure_beside_failure, incomplete, _).
test(an_unsure_key_is_referred_before_the_outstanding_list) :-
    duty_outstanding(unsure_beside_failure, needs_legal_review(open_textured(alerts_prioritised_within_expected_resolution_time, cite(eu_reg_2024_1774_art_23_2_c)), [inputs_relied_on(_)]), []).
test(the_first_unsure_key_in_key_order_is_referred) :-
    duty_complete(two_duties_unsure, needs_legal_review(open_textured(ict_related_incident_policy_developed_documented_and_implemented, cite(eu_reg_2024_1774_art_22)), [inputs_relied_on(_)]), []).
test(an_unknown_key_is_refused) :-
    duty_complete(unknown_key_present, input_problems([unknown_key(financial_entity_is_microenterprise)]), []).
test(an_unsure_gate_is_wrong_type) :-
    duty_required(gate_unsure, input_problems([wrong_type(financial_entity_is_article_16_1_entity)]), []).
test(a_duplicate_key_is_only_duplicate_key) :-
    duty_outstanding(duplicate_duty_key, input_problems([duplicate_key(alerts_prioritised_within_expected_resolution_time)]), []).
test(a_number_is_not_a_judgement) :-
    duty_complete(numeric_judgement_value, input_problems([wrong_type(criticality_of_affected_services_considered)]), []).
test(several_problems_come_in_the_check_order) :-
    dora_rts_incident_policy_and_detection_profile_for(several_input_problems, Profile),
    dora_rts_incident_policy_and_detection_input_problems(Profile, Problems),
    Problems == [wrong_type(financial_entity_is_article_16_1_entity), duplicate_key(alerts_prioritised_within_expected_resolution_time), unknown_key(financial_entity_is_microenterprise)].
test(a_list_of_other_terms_is_not_a_profile) :-
    duty_complete(not_an_attribute_list, input_problems([wrong_type(profile)]), []).
test(an_unbound_profile_is_not_a_profile) :-
    rts_incident_policy_and_detection_duties_required(_UnboundProfile, input_problems([wrong_type(profile)]), []).
test(an_unbound_key_is_unknown_as_given) :-
    dora_rts_incident_policy_and_detection_input_problems([attribute(UnboundKey, true)], Problems),
    Problems = [unknown_key(ReportedKey)],
    ReportedKey == UnboundKey.
test(what_if_one_duty_fails) :-
    dora_rts_incident_policy_and_detection_profile_for(complete_entity, Profile),
    dora_rts_incident_policy_and_detection_what_if(Profile, alerts_prioritised_within_expected_resolution_time, false, incomplete).
test(what_if_the_failing_duty_is_performed) :-
    dora_rts_incident_policy_and_detection_profile_for(prioritisation_not_performed, Profile),
    dora_rts_incident_policy_and_detection_what_if(Profile, alerts_prioritised_within_expected_resolution_time, true, complete).
test(what_if_the_entity_is_an_article_16_1_entity) :-
    dora_rts_incident_policy_and_detection_profile_for(complete_entity, Profile),
    dora_rts_incident_policy_and_detection_what_if(Profile, financial_entity_is_article_16_1_entity, true, simplified_framework_entity).
test(facade_status_matches_the_verdict) :-
    dora_rts_incident_policy_and_detection_profile_for(two_duties_unsure, Profile),
    dora_rts_incident_policy_and_detection_status(Profile, needs_legal_review),
    decide_dora_rts_incident_policy_and_detection(Profile, dora_rts_incident_policy_and_detection_verdict(needs_legal_review, [])).

test(complete_entity_is_not_incomplete, fail) :-
    subject_status(complete_entity, incomplete).
test(simplified_entity_is_not_complete, fail) :-
    subject_status(simplified_entity, complete).
test(simplified_entity_with_failures_is_not_incomplete, fail) :-
    subject_status(simplified_entity_with_failures, incomplete).
test(gate_not_stated_with_failures_is_not_incomplete, fail) :-
    subject_status(gate_not_stated_with_failures, incomplete).
test(prioritisation_not_performed_is_not_complete, fail) :-
    subject_status(prioritisation_not_performed, complete).
test(retention_not_answered_is_not_complete, fail) :-
    subject_status(retention_not_answered, complete).
test(failure_beside_unanswered_is_not_indeterminate, fail) :-
    subject_status(failure_beside_unanswered, indeterminate).
test(prioritisation_unsure_is_not_complete, fail) :-
    subject_status(prioritisation_unsure, complete).
test(the_referral_context_carries_at_most_one_provenance, fail) :-
    duty_complete(prioritisation_unsure, needs_legal_review(open_textured(alerts_prioritised_within_expected_resolution_time, cite(eu_reg_2024_1774_art_23_2_c)), ReferralContext), []),
    ReferralContext = [inputs_relied_on(_), provenance(_, _), provenance(_, _)|_].
test(unsure_beside_unanswered_is_not_referred, fail) :-
    subject_status(unsure_beside_unanswered, needs_legal_review).
test(the_later_unsure_key_is_not_referred, fail) :-
    duty_complete(two_duties_unsure, needs_legal_review(open_textured(clear_roles_and_responsibilities_for_detection_and_response_set, _), _), _).
test(an_unknown_key_is_not_complete, fail) :-
    subject_status(unknown_key_present, complete).
test(an_unsure_gate_is_not_simplified, fail) :-
    subject_status(gate_unsure, simplified_framework_entity).
test(a_duplicate_key_is_not_incomplete, fail) :-
    subject_status(duplicate_duty_key, incomplete).
test(what_if_the_failing_duty_is_performed_is_not_incomplete, fail) :-
    dora_rts_incident_policy_and_detection_profile_for(prioritisation_not_performed, Profile),
    dora_rts_incident_policy_and_detection_what_if(Profile, alerts_prioritised_within_expected_resolution_time, true, incomplete).

cp_test_names([each_subject_gets_its_expected_status, each_subject_has_exactly_one_verdict, each_query_answers_exactly_once_for_each_subject, each_subject_has_a_non_empty_checklist, each_status_is_in_the_status_vocabulary, each_subject_is_resolvable, complete_entity_is_complete, complete_entity_cites_the_fixed_citations, complete_entity_has_none_outstanding, complete_entity_is_required_every_duty_in_duty_order, complete_entity_checklist_cites_every_item, complete_entity_has_no_input_problems, simplified_entity_is_simplified_framework_entity, simplified_entity_with_failures_is_still_simplified, gate_not_stated_is_asked_first, gate_not_stated_with_failures_asks_the_gate, prioritisation_not_performed_is_incomplete, prioritisation_not_performed_is_outstanding, prioritisation_not_performed_checklist_marks_the_duty, secure_retention_is_cited_by_article_22, automated_alerts_are_cited_by_article_23_2, several_duties_are_outstanding_in_duty_order, several_duties_not_performed_is_incomplete, retention_not_answered_names_the_key, retention_not_answered_is_still_required_everything, a_failure_decides_before_an_absent_key_in_complete, a_failure_does_not_end_the_outstanding_query, prioritisation_unsure_is_referred_with_every_pair, prioritisation_unsure_is_referred_by_outstanding, the_referral_context_is_inputs_relied_on_with_an_optional_provenance, an_absent_key_is_named_before_an_unsure_one, a_failure_decides_before_an_unsure_key_in_complete, an_unsure_key_is_referred_before_the_outstanding_list, the_first_unsure_key_in_key_order_is_referred, an_unknown_key_is_refused, an_unsure_gate_is_wrong_type, a_duplicate_key_is_only_duplicate_key, a_number_is_not_a_judgement, several_problems_come_in_the_check_order, a_list_of_other_terms_is_not_a_profile, an_unbound_profile_is_not_a_profile, an_unbound_key_is_unknown_as_given, what_if_one_duty_fails, what_if_the_failing_duty_is_performed, what_if_the_entity_is_an_article_16_1_entity, facade_status_matches_the_verdict]).
cp_test_fail_names([complete_entity_is_not_incomplete, simplified_entity_is_not_complete, simplified_entity_with_failures_is_not_incomplete, gate_not_stated_with_failures_is_not_incomplete, prioritisation_not_performed_is_not_complete, retention_not_answered_is_not_complete, failure_beside_unanswered_is_not_indeterminate, prioritisation_unsure_is_not_complete, the_referral_context_carries_at_most_one_provenance, unsure_beside_unanswered_is_not_referred, the_later_unsure_key_is_not_referred, an_unknown_key_is_not_complete, an_unsure_gate_is_not_simplified, a_duplicate_key_is_not_incomplete, what_if_the_failing_duty_is_performed_is_not_incomplete]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
