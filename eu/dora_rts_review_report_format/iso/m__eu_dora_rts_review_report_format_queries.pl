% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_rts_review_report_format_queries, [dora_rts_review_report_format_profile_keys/1, dora_rts_review_report_format_what_if/4, dora_rts_review_report_format_compliance_check/3, complete/0, incomplete/0, none_outstanding/0, simplified_framework_entity/0, framework_review_report_not_requested/0, unsure/0, required/1, outstanding/1, indeterminate/1, needs_legal_review/2, open_textured/2, inputs_relied_on/1, provenance/2, input_problems/1, wrong_type/1, duplicate_key/1, financial_entity_is_article_16_1_entity/0, authority_requested_framework_review_report/0, financial_entity_is_microenterprise/0, review_initiated_following_supervisory_instructions_or_testing_or_audit_conclusions/0, review_initiated_following_ict_related_incidents/0, identified_weaknesses_not_subject_to_corrective_measures/0, past_corrective_measures_proved_ineffective_or_created_unexpected_challenges/0, review_report_in_searchable_electronic_format/0, review_report_identifies_entity_and_group_structure/0, review_report_describes_context/0, review_report_summarises_changes_since_previous_report/0, review_report_gives_executive_summary/0, review_report_states_approval_date/0, review_report_describes_reason_for_review/0, review_report_references_initiating_instructions_or_conclusions/0, review_report_lists_incidents_with_root_cause_analysis/0, review_report_states_review_period_dates/0, review_report_indicates_responsible_function/0, review_report_describes_major_changes_and_improvements/0, review_report_analyses_impact_of_changes/0, review_report_summarises_findings_and_severity/0, review_report_summarises_remediation_measures/0, review_report_gives_measure_dates_and_progress/0, review_report_gives_measure_tools_and_functions/0, review_report_describes_resource_impact/0, review_report_informs_on_authority_information_process/0, review_report_explains_residual_risk_acceptance/0, review_report_informs_on_planned_developments/0, review_report_states_conclusions/0, review_report_lists_past_reviews/0, review_report_states_corrective_measure_implementation/0, review_report_describes_corrective_measure_improvements/0, review_report_uses_internal_audit_results/0, review_report_uses_compliance_assessments/0, review_report_uses_resilience_testing_results/0, review_report_uses_external_sources/0, report_in_searchable_electronic_format/0, report_identifies_entity_and_group_structure/0, report_describes_context/0, report_summarises_changes_since_previous_report/0, report_gives_executive_summary/0, report_states_approval_date/0, report_describes_reason_for_review/0, report_references_initiating_instructions_or_conclusions/0, report_lists_incidents_with_root_cause_analysis/0, report_states_review_period_dates/0, report_indicates_responsible_function/0, report_describes_major_changes_and_improvements/0, report_analyses_impact_of_changes/0, report_summarises_findings_and_severity/0, report_summarises_remediation_measures/0, report_gives_measure_dates_and_progress/0, report_gives_measure_tools_and_functions/0, report_describes_resource_impact/0, report_informs_on_authority_information_process/0, report_explains_residual_risk_acceptance/0, report_informs_on_planned_developments/0, report_states_conclusions/0, report_lists_past_reviews/0, report_states_corrective_measure_implementation/0, report_describes_corrective_measure_improvements/0, report_uses_internal_audit_results/0, report_uses_compliance_assessments/0, report_uses_resilience_testing_results/0, report_uses_external_sources/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_lists_extra, [clausal_is_list/1]).
:- use_module(m__eu_dora_rts_review_report_format_kernel, [dora_rts_review_report_format_input_problems/2]).
:- use_module(m__eu_dora_rts_review_report_format_citations, [implements/1]).
:- use_module(m__eu_dora_rts_review_report_format_dora_rts_review_report_format, [dora_rts_review_report_format_status/2, ict_risk_framework_review_report_duties_complete/3]).

dora_rts_review_report_format_profile_keys([financial_entity_is_article_16_1_entity, authority_requested_framework_review_report, financial_entity_is_microenterprise, review_initiated_following_supervisory_instructions_or_testing_or_audit_conclusions, review_initiated_following_ict_related_incidents, identified_weaknesses_not_subject_to_corrective_measures, past_corrective_measures_proved_ineffective_or_created_unexpected_challenges, review_report_in_searchable_electronic_format, review_report_identifies_entity_and_group_structure, review_report_describes_context, review_report_summarises_changes_since_previous_report, review_report_gives_executive_summary, review_report_states_approval_date, review_report_describes_reason_for_review, review_report_references_initiating_instructions_or_conclusions, review_report_lists_incidents_with_root_cause_analysis, review_report_states_review_period_dates, review_report_indicates_responsible_function, review_report_describes_major_changes_and_improvements, review_report_analyses_impact_of_changes, review_report_summarises_findings_and_severity, review_report_summarises_remediation_measures, review_report_gives_measure_dates_and_progress, review_report_gives_measure_tools_and_functions, review_report_describes_resource_impact, review_report_informs_on_authority_information_process, review_report_explains_residual_risk_acceptance, review_report_informs_on_planned_developments, review_report_states_conclusions, review_report_lists_past_reviews, review_report_states_corrective_measure_implementation, review_report_describes_corrective_measure_improvements, review_report_uses_internal_audit_results, review_report_uses_compliance_assessments, review_report_uses_resilience_testing_results, review_report_uses_external_sources]).

dora_rts_review_report_format_what_if(Profile, OverriddenKey, NewValue, NewStatus) :-
    profile_without_key(Profile, OverriddenKey, Remaining),
    append(Remaining, [attribute(OverriddenKey, NewValue)], Hypothesis),
    dora_rts_review_report_format_status(Hypothesis, NewStatus).

profile_without_key([], _, []).
profile_without_key([attribute(ProfileKey, _)|Elements], ProfileKey, Remaining) :-
    profile_without_key(Elements, ProfileKey, Remaining).
profile_without_key([attribute(OtherKey, OtherValue)|Elements], ProfileKey, [attribute(OtherKey, OtherValue)|Remaining]) :-
    dif(OtherKey, ProfileKey),
    profile_without_key(Elements, ProfileKey, Remaining).

dora_rts_review_report_format_compliance_check(Profile, submit_review_report, Verdict) :-
    ict_risk_framework_review_report_duties_complete(Profile, Result, _),
    compliance_verdict(Result, Verdict).

compliance_verdict(complete, compliant) :-
    implements(eu_reg_2024_1774_art_27_2).
compliance_verdict(incomplete, non_compliant) :-
    implements(eu_reg_2024_1774_art_27_2).
compliance_verdict(Result, Result) :-
    dif(Result, complete),
    dif(Result, incomplete).

complete.

incomplete.

none_outstanding.

simplified_framework_entity.

framework_review_report_not_requested.

unsure.

required(Duties) :-
    clausal_is_list(Duties).

outstanding(Duties) :-
    clausal_is_list(Duties).

indeterminate(MissingKeys) :-
    clausal_is_list(MissingKeys).

needs_legal_review(Reason, Context) :-
    compound(Reason),
    clausal_is_list(Context).

open_textured(ProfileKey, Citation) :-
    atom(ProfileKey),
    compound(Citation).

inputs_relied_on(Pairs) :-
    clausal_is_list(Pairs).

provenance(Clause, Citations) :-
    callable(Clause),
    clausal_is_list(Citations).

input_problems(Problems) :-
    clausal_is_list(Problems).

wrong_type(ProfileKey) :-
    nonvar(ProfileKey).

duplicate_key(ProfileKey) :-
    nonvar(ProfileKey).

financial_entity_is_article_16_1_entity.

authority_requested_framework_review_report.

financial_entity_is_microenterprise.

review_initiated_following_supervisory_instructions_or_testing_or_audit_conclusions.

review_initiated_following_ict_related_incidents.

identified_weaknesses_not_subject_to_corrective_measures.

past_corrective_measures_proved_ineffective_or_created_unexpected_challenges.

review_report_in_searchable_electronic_format.

review_report_identifies_entity_and_group_structure.

review_report_describes_context.

review_report_summarises_changes_since_previous_report.

review_report_gives_executive_summary.

review_report_states_approval_date.

review_report_describes_reason_for_review.

review_report_references_initiating_instructions_or_conclusions.

review_report_lists_incidents_with_root_cause_analysis.

review_report_states_review_period_dates.

review_report_indicates_responsible_function.

review_report_describes_major_changes_and_improvements.

review_report_analyses_impact_of_changes.

review_report_summarises_findings_and_severity.

review_report_summarises_remediation_measures.

review_report_gives_measure_dates_and_progress.

review_report_gives_measure_tools_and_functions.

review_report_describes_resource_impact.

review_report_informs_on_authority_information_process.

review_report_explains_residual_risk_acceptance.

review_report_informs_on_planned_developments.

review_report_states_conclusions.

review_report_lists_past_reviews.

review_report_states_corrective_measure_implementation.

review_report_describes_corrective_measure_improvements.

review_report_uses_internal_audit_results.

review_report_uses_compliance_assessments.

review_report_uses_resilience_testing_results.

review_report_uses_external_sources.

report_in_searchable_electronic_format.

report_identifies_entity_and_group_structure.

report_describes_context.

report_summarises_changes_since_previous_report.

report_gives_executive_summary.

report_states_approval_date.

report_describes_reason_for_review.

report_references_initiating_instructions_or_conclusions.

report_lists_incidents_with_root_cause_analysis.

report_states_review_period_dates.

report_indicates_responsible_function.

report_describes_major_changes_and_improvements.

report_analyses_impact_of_changes.

report_summarises_findings_and_severity.

report_summarises_remediation_measures.

report_gives_measure_dates_and_progress.

report_gives_measure_tools_and_functions.

report_describes_resource_impact.

report_informs_on_authority_information_process.

report_explains_residual_risk_acceptance.

report_informs_on_planned_developments.

report_states_conclusions.

report_lists_past_reviews.

report_states_corrective_measure_implementation.

report_describes_corrective_measure_improvements.

report_uses_internal_audit_results.

report_uses_compliance_assessments.

report_uses_resilience_testing_results.

report_uses_external_sources.

test(thirty_six_profile_keys) :-
    dora_rts_review_report_format_profile_keys(ProfileKeys),
    length(ProfileKeys, 36).
test(an_empty_profile_passes_the_missing_gate_through) :-
    dora_rts_review_report_format_compliance_check([], submit_review_report, Verdict),
    Verdict == indeterminate([financial_entity_is_article_16_1_entity]).
test(what_if_the_gate_is_true) :-
    dora_rts_review_report_format_what_if([], financial_entity_is_article_16_1_entity, true, Status),
    Status == simplified_framework_entity.
test(what_if_replaces_the_given_value) :-
    dora_rts_review_report_format_what_if([attribute(financial_entity_is_article_16_1_entity, true)], financial_entity_is_article_16_1_entity, false, Status),
    Status == indeterminate([authority_requested_framework_review_report]).
test(the_result_atoms_are_defined) :-
    complete,
    incomplete,
    none_outstanding,
    simplified_framework_entity,
    framework_review_report_not_requested,
    unsure.
test(the_constructors_accept_their_shapes) :-
    required([report_in_searchable_electronic_format]),
    outstanding([report_uses_external_sources]),
    indeterminate([financial_entity_is_article_16_1_entity]),
    needs_legal_review(open_textured(review_report_describes_context, cite(eu_reg_2024_1774_art_27_2_a_ii)), [inputs_relied_on([])]),
    input_problems([unknown_key(colour)]).

test(an_empty_profile_is_not_compliant, fail) :-
    dora_rts_review_report_format_compliance_check([], submit_review_report, compliant).
