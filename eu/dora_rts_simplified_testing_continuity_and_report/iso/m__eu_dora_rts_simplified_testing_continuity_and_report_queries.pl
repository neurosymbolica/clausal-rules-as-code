% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_rts_simplified_testing_continuity_and_report_queries, [dora_rts_simplified_testing_continuity_and_report_profile_keys/1, dora_rts_simplified_testing_continuity_and_report_what_if/4, dora_rts_simplified_testing_continuity_and_report_compliance_check/3, complete/0, incomplete/0, none_outstanding/0, not_article_16_1_entity/0, unsure/0, financial_entity_is_article_16_1_entity/0, authority_requested_framework_review_report/0, framework_review_initiated_following_supervisory_instructions/0, framework_review_initiated_following_ict_related_incidents/0, ict_security_testing_plan_established_and_implemented/0, ict_security_measures_reviewed_assessed_and_tested/0, security_test_results_evaluated_and_measures_updated/0, ict_systems_acquisition_and_development_procedure_in_place/0, requirements_specified_and_approved_before_acquisition/0, ict_systems_tested_and_approved_before_use_and_changes/0, alteration_and_manipulation_risk_measures_identified/0, ict_project_management_procedure_in_place/0, ict_change_management_procedure_in_place/0, continuity_plans_developed_on_disruption_and_scenario_analysis/0, continuity_plans_approved_by_management_body/0, continuity_plans_documented_and_readily_accessible/0, continuity_plans_allocate_sufficient_resources/0, continuity_plans_establish_recovery_levels_and_timeframes/0, continuity_plans_identify_activation_conditions_and_actions/0, continuity_plans_identify_restoration_and_recovery_measures/0, continuity_plans_identify_backup_procedures_scope_and_frequency/0, continuity_plans_consider_alternative_options/0, continuity_plans_specify_communication_and_escalation/0, continuity_plans_updated_with_lessons_learned/0, continuity_plans_tested_yearly_and_on_major_change/0, continuity_plan_testing_demonstrates_viability_and_finds_deficiencies/0, continuity_test_results_documented_and_deficiencies_reported/0, review_report_submitted_in_searchable_electronic_format/0, review_report_describes_context/0, review_report_has_executive_summary/0, review_report_informs_on_reported_area/0, review_report_summarises_major_framework_changes/0, review_report_describes_impact_of_major_changes/0, review_report_states_approval_date_where_applicable/0, review_report_describes_reasons_for_review/0, review_report_gives_evidence_of_supervisory_instructions/0, review_report_lists_incidents_with_root_cause_analysis/0, review_report_states_review_period/0, review_report_names_person_responsible/0, review_report_summarises_findings_and_self_assessment/0, review_report_states_remedying_measures/0, review_report_states_overall_conclusions/0, ict_security_testing_plan/0, review_and_testing_of_security_measures/0, evaluation_of_security_test_results/0, acquisition_development_and_maintenance_procedure/0, requirements_specified_before_acquisition/0, testing_and_approval_before_use/0, manipulation_risk_measures/0, ict_project_management_procedure/0, ict_change_management_procedure/0, continuity_plans_based_on_disruption_analysis/0, management_body_approval_of_continuity_plans/0, continuity_plans_documented_and_accessible/0, continuity_plan_resources/0, recovery_levels_and_timeframes/0, activation_conditions_and_actions/0, restoration_and_recovery_measures/0, backup_procedures/0, alternative_options/0, communication_arrangements/0, updating_of_continuity_plans/0, testing_of_continuity_plans/0, continuity_testing_demonstrates_viability/0, continuity_test_results_and_deficiencies/0, review_report_in_searchable_electronic_format/0, report_context_description/0, report_executive_summary/0, report_reported_area/0, report_major_framework_changes/0, report_impact_of_major_changes/0, report_approval_date/0, report_reasons_for_review/0, report_evidence_of_supervisory_instructions/0, report_incidents_and_root_cause_analysis/0, report_review_period/0, report_person_responsible/0, report_findings_and_self_assessment/0, report_remedying_measures/0, report_overall_conclusions/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_hof, [include/3, exclude/3]).
:- use_module(library(reif), [memberd_t/3]).
:- use_module(formalize_lib, [profile_lacks/2]).
:- use_module(m__eu_dora_rts_simplified_testing_continuity_and_report_kernel, [dora_rts_simplified_testing_continuity_and_report_input_problems/2]).
:- use_module(m__eu_dora_rts_simplified_testing_continuity_and_report_citations, [implements/1]).
:- use_module(m__eu_dora_rts_simplified_testing_continuity_and_report_dora_rts_simplified_testing_continuity_and_report, [simplified_testing_continuity_and_report_duties_required/3, simplified_testing_continuity_and_report_duties_outstanding/3, dora_rts_simplified_testing_continuity_and_report_status/2, dora_rts_simplified_testing_continuity_and_report_checklist/2]).

dora_rts_simplified_testing_continuity_and_report_profile_keys([financial_entity_is_article_16_1_entity, authority_requested_framework_review_report, framework_review_initiated_following_supervisory_instructions, framework_review_initiated_following_ict_related_incidents, ict_security_testing_plan_established_and_implemented, ict_security_measures_reviewed_assessed_and_tested, security_test_results_evaluated_and_measures_updated, ict_systems_acquisition_and_development_procedure_in_place, requirements_specified_and_approved_before_acquisition, ict_systems_tested_and_approved_before_use_and_changes, alteration_and_manipulation_risk_measures_identified, ict_project_management_procedure_in_place, ict_change_management_procedure_in_place, continuity_plans_developed_on_disruption_and_scenario_analysis, continuity_plans_approved_by_management_body, continuity_plans_documented_and_readily_accessible, continuity_plans_allocate_sufficient_resources, continuity_plans_establish_recovery_levels_and_timeframes, continuity_plans_identify_activation_conditions_and_actions, continuity_plans_identify_restoration_and_recovery_measures, continuity_plans_identify_backup_procedures_scope_and_frequency, continuity_plans_consider_alternative_options, continuity_plans_specify_communication_and_escalation, continuity_plans_updated_with_lessons_learned, continuity_plans_tested_yearly_and_on_major_change, continuity_plan_testing_demonstrates_viability_and_finds_deficiencies, continuity_test_results_documented_and_deficiencies_reported, review_report_submitted_in_searchable_electronic_format, review_report_describes_context, review_report_has_executive_summary, review_report_informs_on_reported_area, review_report_summarises_major_framework_changes, review_report_describes_impact_of_major_changes, review_report_states_approval_date_where_applicable, review_report_describes_reasons_for_review, review_report_gives_evidence_of_supervisory_instructions, review_report_lists_incidents_with_root_cause_analysis, review_report_states_review_period, review_report_names_person_responsible, review_report_summarises_findings_and_self_assessment, review_report_states_remedying_measures, review_report_states_overall_conclusions]).

condition_trigger_keys([authority_requested_framework_review_report, framework_review_initiated_following_supervisory_instructions, framework_review_initiated_following_ict_related_incidents]).

complete.

incomplete.

none_outstanding.

not_article_16_1_entity.

unsure.

result_kind(required(_), final).
result_kind(outstanding(_), final).
result_kind(complete, final).
result_kind(incomplete, final).
result_kind(none_outstanding, final).
result_kind(not_article_16_1_entity, final).
result_kind(indeterminate([_]), status).
result_kind(needs_legal_review(open_textured(_, cite(_)), [inputs_relied_on(_)|_]), status).
result_kind(input_problems(_), status).

financial_entity_is_article_16_1_entity.

authority_requested_framework_review_report.

framework_review_initiated_following_supervisory_instructions.

framework_review_initiated_following_ict_related_incidents.

ict_security_testing_plan_established_and_implemented.

ict_security_measures_reviewed_assessed_and_tested.

security_test_results_evaluated_and_measures_updated.

ict_systems_acquisition_and_development_procedure_in_place.

requirements_specified_and_approved_before_acquisition.

ict_systems_tested_and_approved_before_use_and_changes.

alteration_and_manipulation_risk_measures_identified.

ict_project_management_procedure_in_place.

ict_change_management_procedure_in_place.

continuity_plans_developed_on_disruption_and_scenario_analysis.

continuity_plans_approved_by_management_body.

continuity_plans_documented_and_readily_accessible.

continuity_plans_allocate_sufficient_resources.

continuity_plans_establish_recovery_levels_and_timeframes.

continuity_plans_identify_activation_conditions_and_actions.

continuity_plans_identify_restoration_and_recovery_measures.

continuity_plans_identify_backup_procedures_scope_and_frequency.

continuity_plans_consider_alternative_options.

continuity_plans_specify_communication_and_escalation.

continuity_plans_updated_with_lessons_learned.

continuity_plans_tested_yearly_and_on_major_change.

continuity_plan_testing_demonstrates_viability_and_finds_deficiencies.

continuity_test_results_documented_and_deficiencies_reported.

review_report_submitted_in_searchable_electronic_format.

review_report_describes_context.

review_report_has_executive_summary.

review_report_informs_on_reported_area.

review_report_summarises_major_framework_changes.

review_report_describes_impact_of_major_changes.

review_report_states_approval_date_where_applicable.

review_report_describes_reasons_for_review.

review_report_gives_evidence_of_supervisory_instructions.

review_report_lists_incidents_with_root_cause_analysis.

review_report_states_review_period.

review_report_names_person_responsible.

review_report_summarises_findings_and_self_assessment.

review_report_states_remedying_measures.

review_report_states_overall_conclusions.

ict_security_testing_plan.

review_and_testing_of_security_measures.

evaluation_of_security_test_results.

acquisition_development_and_maintenance_procedure.

requirements_specified_before_acquisition.

testing_and_approval_before_use.

manipulation_risk_measures.

ict_project_management_procedure.

ict_change_management_procedure.

continuity_plans_based_on_disruption_analysis.

management_body_approval_of_continuity_plans.

continuity_plans_documented_and_accessible.

continuity_plan_resources.

recovery_levels_and_timeframes.

activation_conditions_and_actions.

restoration_and_recovery_measures.

backup_procedures.

alternative_options.

communication_arrangements.

updating_of_continuity_plans.

testing_of_continuity_plans.

continuity_testing_demonstrates_viability.

continuity_test_results_and_deficiencies.

review_report_in_searchable_electronic_format.

report_context_description.

report_executive_summary.

report_reported_area.

report_major_framework_changes.

report_impact_of_major_changes.

report_approval_date.

report_reasons_for_review.

report_evidence_of_supervisory_instructions.

report_incidents_and_root_cause_analysis.

report_review_period.

report_person_responsible.

report_findings_and_self_assessment.

report_remedying_measures.

report_overall_conclusions.

dora_rts_simplified_testing_continuity_and_report_what_if(Profile, OverriddenKey, NewValue, NewStatus) :-
    replace_attribute(Profile, OverriddenKey, NewValue, Hypothesis),
    dora_rts_simplified_testing_continuity_and_report_status(Hypothesis, NewStatus).

replace_attribute(Profile, OverriddenKey, NewValue, Hypothesis) :-
    exclude(same_attribute_key(OverriddenKey), Profile, OtherAttributes),
    append(OtherAttributes, [attribute(OverriddenKey, NewValue)], Hypothesis).

same_attribute_key(OverriddenKey, attribute(ElementKey, _)) :-
    ElementKey == OverriddenKey.

dora_rts_simplified_testing_continuity_and_report_compliance_check(Profile, omit(DutyAtom), Verdict) :-
    dora_rts_simplified_testing_continuity_and_report_checklist(Profile, Items),
    compliance_by_items(Items, DutyAtom, Profile, Verdict).

compliance_by_items([item(input_check, unmet(input_problems(Problems)), [])], _, _, input_problems(Problems)).
compliance_by_items([item(article_16_1_entity, unmet(not_article_16_1_entity), [cite(eu_reg_2022_2554_art_16_1)])], _, _, permitted) :-
    implements(eu_reg_2022_2554_art_16_1).
compliance_by_items([item(article_16_1_entity, unknown(MissingKeys), [cite(eu_reg_2022_2554_art_16_1)])], _, _, indeterminate(MissingKeys)) :-
    implements(eu_reg_2022_2554_art_16_1).
compliance_by_items([item(article_16_1_entity, met, [cite(eu_reg_2022_2554_art_16_1)])|DutyItems], DutyAtom, Profile, Verdict) :-
    implements(eu_reg_2022_2554_art_16_1),
    member(item(DutyAtom, ItemStatus, [cite(CitationKey)]), DutyItems),
    omission_verdict(ItemStatus, CitationKey, Profile, Verdict).

omission_verdict(met, _, _, prohibited) :-
    implements(eu_reg_2022_2554_art_16_1).
omission_verdict(unmet(_), _, _, prohibited) :-
    implements(eu_reg_2022_2554_art_16_1).
omission_verdict(inapplicable, _, _, permitted) :-
    implements(eu_reg_2022_2554_art_16_2).
omission_verdict(unknown([FirstKey|OtherKeys]), _, Profile, Verdict) :-
    implements(eu_reg_2022_2554_art_16_1),
    condition_trigger_keys(TriggerKeys),
    memberd_t(FirstKey, TriggerKeys, IsTrigger),
    pending_verdict(IsTrigger, [FirstKey|OtherKeys], Profile, Verdict).

pending_verdict(false, _, _, prohibited).
pending_verdict(true, ConditionKeys, Profile, indeterminate([OpenKey])) :-
    implements(eu_reg_2022_2554_art_16_2),
    include(profile_lacks(Profile), ConditionKeys, OpenKeys),
    first_open_key(OpenKeys, OpenKey).

first_open_key([OpenKey|_], OpenKey).

test(the_schema_has_forty_two_keys) :-
    dora_rts_simplified_testing_continuity_and_report_profile_keys(ProfileKeys),
    length(ProfileKeys, 42).
test(the_result_atoms_are_defined) :-
    complete,
    incomplete,
    none_outstanding,
    not_article_16_1_entity,
    unsure.
test(the_required_result_is_a_final_answer) :-
    simplified_testing_continuity_and_report_duties_required([attribute(financial_entity_is_article_16_1_entity, true), attribute(authority_requested_framework_review_report, false)], Result, _),
    result_kind(Result, final),
    Result = required([ict_security_testing_plan|_]).
test(the_outstanding_result_with_an_absent_key_is_a_status) :-
    simplified_testing_continuity_and_report_duties_outstanding([attribute(financial_entity_is_article_16_1_entity, true)], Result, []),
    result_kind(Result, status),
    Result = indeterminate([authority_requested_framework_review_report]).
test(an_outstanding_list_is_a_final_answer) :-
    result_kind(outstanding([backup_procedures]), final).
test(a_referral_is_a_status) :-
    result_kind(needs_legal_review(open_textured(continuity_plans_identify_backup_procedures_scope_and_frequency, cite(eu_reg_2024_1774_art_39_2)), [inputs_relied_on([])]), status).
test(omitting_an_article_36_duty_is_prohibited) :-
    dora_rts_simplified_testing_continuity_and_report_compliance_check([attribute(financial_entity_is_article_16_1_entity, true)], omit(ict_security_testing_plan), prohibited).
test(omitting_an_article_41_duty_without_a_request_is_permitted) :-
    dora_rts_simplified_testing_continuity_and_report_compliance_check([attribute(financial_entity_is_article_16_1_entity, true), attribute(authority_requested_framework_review_report, false)], omit(report_overall_conclusions), permitted).
test(omitting_an_article_41_duty_with_a_request_is_prohibited) :-
    dora_rts_simplified_testing_continuity_and_report_compliance_check([attribute(financial_entity_is_article_16_1_entity, true), attribute(authority_requested_framework_review_report, true)], omit(report_overall_conclusions), prohibited).
test(an_unanswered_request_is_named) :-
    dora_rts_simplified_testing_continuity_and_report_compliance_check([attribute(financial_entity_is_article_16_1_entity, true)], omit(report_overall_conclusions), indeterminate([authority_requested_framework_review_report])).
test(an_unanswered_reason_is_named_after_the_request) :-
    dora_rts_simplified_testing_continuity_and_report_compliance_check([attribute(financial_entity_is_article_16_1_entity, true), attribute(authority_requested_framework_review_report, true)], omit(report_evidence_of_supervisory_instructions), indeterminate([framework_review_initiated_following_supervisory_instructions])).
test(a_false_gate_permits_every_omission) :-
    dora_rts_simplified_testing_continuity_and_report_compliance_check([attribute(financial_entity_is_article_16_1_entity, false)], omit(ict_security_testing_plan), permitted).
test(an_absent_gate_is_named) :-
    dora_rts_simplified_testing_continuity_and_report_compliance_check([], omit(ict_security_testing_plan), indeterminate([financial_entity_is_article_16_1_entity])).
test(a_malformed_profile_is_refused) :-
    dora_rts_simplified_testing_continuity_and_report_compliance_check([attribute(dora_entity_type, credit_institution)], omit(ict_security_testing_plan), input_problems([unknown_key(dora_entity_type)])).
test(the_compliance_check_answers_once) :-
    findall(Verdict, dora_rts_simplified_testing_continuity_and_report_compliance_check([attribute(financial_entity_is_article_16_1_entity, true)], omit(backup_procedures), Verdict), Verdicts),
    Verdicts == [prohibited].
test(what_if_a_false_duty_makes_it_incomplete) :-
    dora_rts_simplified_testing_continuity_and_report_what_if([attribute(financial_entity_is_article_16_1_entity, true), attribute(ict_security_testing_plan_established_and_implemented, true)], ict_security_testing_plan_established_and_implemented, false, incomplete).
test(what_if_a_false_gate_is_not_an_article_16_1_entity) :-
    dora_rts_simplified_testing_continuity_and_report_what_if([attribute(financial_entity_is_article_16_1_entity, true)], financial_entity_is_article_16_1_entity, false, not_article_16_1_entity).

test(a_referral_is_not_a_final_answer, fail) :-
    result_kind(needs_legal_review(open_textured(continuity_plans_identify_backup_procedures_scope_and_frequency, cite(eu_reg_2024_1774_art_39_2)), [inputs_relied_on([])]), final).
test(omitting_an_article_41_duty_without_a_request_is_not_prohibited, fail) :-
    dora_rts_simplified_testing_continuity_and_report_compliance_check([attribute(financial_entity_is_article_16_1_entity, true), attribute(authority_requested_framework_review_report, false)], omit(report_overall_conclusions), prohibited).
test(what_if_a_true_duty_is_not_incomplete, fail) :-
    dora_rts_simplified_testing_continuity_and_report_what_if([attribute(financial_entity_is_article_16_1_entity, true), attribute(ict_security_testing_plan_established_and_implemented, false)], ict_security_testing_plan_established_and_implemented, true, incomplete).
