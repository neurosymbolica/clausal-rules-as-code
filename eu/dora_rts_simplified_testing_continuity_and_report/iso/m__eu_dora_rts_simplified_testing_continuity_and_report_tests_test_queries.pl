% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_rts_simplified_testing_continuity_and_report_tests_test_queries, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_dora_rts_simplified_testing_continuity_and_report_queries, [dora_rts_simplified_testing_continuity_and_report_profile_keys/1, dora_rts_simplified_testing_continuity_and_report_what_if/4, dora_rts_simplified_testing_continuity_and_report_compliance_check/3, complete/0, incomplete/0, none_outstanding/0, not_article_16_1_entity/0, unsure/0]).
:- use_module(m__eu_dora_rts_simplified_testing_continuity_and_report_dora_rts_simplified_testing_continuity_and_report, [decide_dora_rts_simplified_testing_continuity_and_report/2, dora_rts_simplified_testing_continuity_and_report_checklist/2]).
:- use_module(m__eu_dora_rts_simplified_testing_continuity_and_report_fixtures, [dora_rts_simplified_testing_continuity_and_report_profile_for/2]).

test(profile_keys_are_the_contract_keys) :-
    dora_rts_simplified_testing_continuity_and_report_profile_keys(ProfileKeys),
    ProfileKeys == [financial_entity_is_article_16_1_entity, authority_requested_framework_review_report, framework_review_initiated_following_supervisory_instructions, framework_review_initiated_following_ict_related_incidents, ict_security_testing_plan_established_and_implemented, ict_security_measures_reviewed_assessed_and_tested, security_test_results_evaluated_and_measures_updated, ict_systems_acquisition_and_development_procedure_in_place, requirements_specified_and_approved_before_acquisition, ict_systems_tested_and_approved_before_use_and_changes, alteration_and_manipulation_risk_measures_identified, ict_project_management_procedure_in_place, ict_change_management_procedure_in_place, continuity_plans_developed_on_disruption_and_scenario_analysis, continuity_plans_approved_by_management_body, continuity_plans_documented_and_readily_accessible, continuity_plans_allocate_sufficient_resources, continuity_plans_establish_recovery_levels_and_timeframes, continuity_plans_identify_activation_conditions_and_actions, continuity_plans_identify_restoration_and_recovery_measures, continuity_plans_identify_backup_procedures_scope_and_frequency, continuity_plans_consider_alternative_options, continuity_plans_specify_communication_and_escalation, continuity_plans_updated_with_lessons_learned, continuity_plans_tested_yearly_and_on_major_change, continuity_plan_testing_demonstrates_viability_and_finds_deficiencies, continuity_test_results_documented_and_deficiencies_reported, review_report_submitted_in_searchable_electronic_format, review_report_describes_context, review_report_has_executive_summary, review_report_informs_on_reported_area, review_report_summarises_major_framework_changes, review_report_describes_impact_of_major_changes, review_report_states_approval_date_where_applicable, review_report_describes_reasons_for_review, review_report_gives_evidence_of_supervisory_instructions, review_report_lists_incidents_with_root_cause_analysis, review_report_states_review_period, review_report_names_person_responsible, review_report_summarises_findings_and_self_assessment, review_report_states_remedying_measures, review_report_states_overall_conclusions].
test(the_root_result_atoms_are_served) :-
    complete,
    incomplete,
    none_outstanding,
    not_article_16_1_entity,
    unsure.
test(the_eligibility_verdict_is_complete_for_the_baseline) :-
    dora_rts_simplified_testing_continuity_and_report_profile_for(all_performed_without_request, Profile),
    decide_dora_rts_simplified_testing_continuity_and_report(Profile, dora_rts_simplified_testing_continuity_and_report_verdict(complete, [_|_])).
test(the_checklist_has_the_gate_and_every_duty) :-
    dora_rts_simplified_testing_continuity_and_report_profile_for(all_performed_with_request_for_both_reasons, Profile),
    dora_rts_simplified_testing_continuity_and_report_checklist(Profile, Items),
    length(Items, 39),
    Items = [item(article_16_1_entity, met, [cite(eu_reg_2022_2554_art_16_1)])|_].
test(the_checklist_marks_a_failing_duty_unmet) :-
    dora_rts_simplified_testing_continuity_and_report_profile_for(one_testing_duty_not_performed_without_request, Profile),
    dora_rts_simplified_testing_continuity_and_report_checklist(Profile, Items),
    member(item(ict_security_testing_plan, unmet(ict_security_testing_plan_established_and_implemented), [cite(eu_reg_2024_1774_art_36_1)]), Items).
test(omitting_a_report_duty_on_request_is_prohibited) :-
    dora_rts_simplified_testing_continuity_and_report_profile_for(conclusions_missing_with_request, Profile),
    dora_rts_simplified_testing_continuity_and_report_compliance_check(Profile, omit(report_overall_conclusions), prohibited).
test(omitting_a_report_duty_without_request_is_permitted) :-
    dora_rts_simplified_testing_continuity_and_report_profile_for(conclusions_missing_without_request, Profile),
    dora_rts_simplified_testing_continuity_and_report_compliance_check(Profile, omit(report_overall_conclusions), permitted).
test(omitting_the_evidence_without_supervisory_instructions_is_permitted) :-
    dora_rts_simplified_testing_continuity_and_report_profile_for(evidence_missing_without_supervisory_instructions, Profile),
    dora_rts_simplified_testing_continuity_and_report_compliance_check(Profile, omit(report_evidence_of_supervisory_instructions), permitted).
test(what_if_one_testing_duty_is_not_performed) :-
    dora_rts_simplified_testing_continuity_and_report_profile_for(all_performed_without_request, Profile),
    dora_rts_simplified_testing_continuity_and_report_what_if(Profile, ict_security_testing_plan_established_and_implemented, false, incomplete).
test(what_if_the_request_is_made_the_report_keys_are_asked) :-
    dora_rts_simplified_testing_continuity_and_report_profile_for(all_performed_without_request, Profile),
    dora_rts_simplified_testing_continuity_and_report_what_if(Profile, authority_requested_framework_review_report, true, indeterminate).
test(what_if_the_request_is_withdrawn_conclusions_do_not_matter) :-
    dora_rts_simplified_testing_continuity_and_report_profile_for(conclusions_missing_with_request, Profile),
    dora_rts_simplified_testing_continuity_and_report_what_if(Profile, authority_requested_framework_review_report, false, complete).
test(what_if_a_bad_value_is_an_input_problem) :-
    dora_rts_simplified_testing_continuity_and_report_profile_for(all_performed_without_request, Profile),
    dora_rts_simplified_testing_continuity_and_report_what_if(Profile, financial_entity_is_article_16_1_entity, unsure, input_problems).

test(omitting_a_report_duty_without_request_is_not_prohibited, fail) :-
    dora_rts_simplified_testing_continuity_and_report_profile_for(conclusions_missing_without_request, Profile),
    dora_rts_simplified_testing_continuity_and_report_compliance_check(Profile, omit(report_overall_conclusions), prohibited).

cp_test_names([profile_keys_are_the_contract_keys, the_root_result_atoms_are_served, the_eligibility_verdict_is_complete_for_the_baseline, the_checklist_has_the_gate_and_every_duty, the_checklist_marks_a_failing_duty_unmet, omitting_a_report_duty_on_request_is_prohibited, omitting_a_report_duty_without_request_is_permitted, omitting_the_evidence_without_supervisory_instructions_is_permitted, what_if_one_testing_duty_is_not_performed, what_if_the_request_is_made_the_report_keys_are_asked, what_if_the_request_is_withdrawn_conclusions_do_not_matter, what_if_a_bad_value_is_an_input_problem]).
cp_test_fail_names([omitting_a_report_duty_without_request_is_not_prohibited]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
