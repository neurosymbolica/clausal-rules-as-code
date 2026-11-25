% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_rts_review_report_format_tests_test_queries, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_dora_rts_review_report_format_queries, [dora_rts_review_report_format_profile_keys/1, dora_rts_review_report_format_what_if/4, dora_rts_review_report_format_compliance_check/3, complete/0, incomplete/0, none_outstanding/0, simplified_framework_entity/0, framework_review_report_not_requested/0, unsure/0, required/1, outstanding/1, indeterminate/1, input_problems/1, financial_entity_is_article_16_1_entity/0, review_report_uses_external_sources/0, report_in_searchable_electronic_format/0, report_uses_external_sources/0]).
:- use_module(m__eu_dora_rts_review_report_format_kernel, [dora_rts_review_report_format_input_problems/2]).
:- use_module(m__eu_dora_rts_review_report_format_dora_rts_review_report_format, [dora_rts_review_report_format_status/2, dora_rts_review_report_format_checklist/2]).
:- use_module(m__eu_dora_rts_review_report_format_fixtures, [dora_rts_review_report_format_profile_for/2]).

test(profile_keys_are_the_contract_keys) :-
    dora_rts_review_report_format_profile_keys(ProfileKeys),
    ProfileKeys == [financial_entity_is_article_16_1_entity, authority_requested_framework_review_report, financial_entity_is_microenterprise, review_initiated_following_supervisory_instructions_or_testing_or_audit_conclusions, review_initiated_following_ict_related_incidents, identified_weaknesses_not_subject_to_corrective_measures, past_corrective_measures_proved_ineffective_or_created_unexpected_challenges, review_report_in_searchable_electronic_format, review_report_identifies_entity_and_group_structure, review_report_describes_context, review_report_summarises_changes_since_previous_report, review_report_gives_executive_summary, review_report_states_approval_date, review_report_describes_reason_for_review, review_report_references_initiating_instructions_or_conclusions, review_report_lists_incidents_with_root_cause_analysis, review_report_states_review_period_dates, review_report_indicates_responsible_function, review_report_describes_major_changes_and_improvements, review_report_analyses_impact_of_changes, review_report_summarises_findings_and_severity, review_report_summarises_remediation_measures, review_report_gives_measure_dates_and_progress, review_report_gives_measure_tools_and_functions, review_report_describes_resource_impact, review_report_informs_on_authority_information_process, review_report_explains_residual_risk_acceptance, review_report_informs_on_planned_developments, review_report_states_conclusions, review_report_lists_past_reviews, review_report_states_corrective_measure_implementation, review_report_describes_corrective_measure_improvements, review_report_uses_internal_audit_results, review_report_uses_compliance_assessments, review_report_uses_resilience_testing_results, review_report_uses_external_sources].
test(status_of_the_baseline) :-
    dora_rts_review_report_format_profile_for(scheduled_review_complete, Profile),
    dora_rts_review_report_format_status(Profile, Status),
    Status == complete.
test(checklist_marks_the_missing_item_unmet) :-
    dora_rts_review_report_format_profile_for(missing_executive_summary, Profile),
    dora_rts_review_report_format_checklist(Profile, Items),
    member(item(report_gives_executive_summary, Status, Citations), Items),
    Status == unmet(review_report_gives_executive_summary),
    Citations == [cite(eu_reg_2024_1774_art_27_2_a_iv)].
test(checklist_marks_an_excluded_duty_inapplicable) :-
    dora_rts_review_report_format_profile_for(microenterprise_without_internal_audit, Profile),
    dora_rts_review_report_format_checklist(Profile, Items),
    member(item(report_uses_internal_audit_results, Status, _), Items),
    Status == inapplicable.
test(a_complete_report_is_compliant) :-
    dora_rts_review_report_format_profile_for(scheduled_review_complete, Profile),
    dora_rts_review_report_format_compliance_check(Profile, submit_review_report, Verdict),
    Verdict == compliant.
test(an_incomplete_report_is_non_compliant) :-
    dora_rts_review_report_format_profile_for(missing_executive_summary, Profile),
    dora_rts_review_report_format_compliance_check(Profile, submit_review_report, Verdict),
    Verdict == non_compliant.
test(the_gate_passes_through_the_compliance_check) :-
    dora_rts_review_report_format_profile_for(article_16_1_entity, Profile),
    dora_rts_review_report_format_compliance_check(Profile, submit_review_report, Verdict),
    Verdict == simplified_framework_entity.
test(a_referral_passes_through_the_compliance_check) :-
    dora_rts_review_report_format_profile_for(unsure_format, Profile),
    dora_rts_review_report_format_compliance_check(Profile, submit_review_report, Verdict),
    Verdict = needs_legal_review(open_textured(review_report_in_searchable_electronic_format, _), _).
test(the_compliance_check_answers_once) :-
    dora_rts_review_report_format_profile_for(scheduled_review_complete, Profile),
    findall(Verdict, dora_rts_review_report_format_compliance_check(Profile, submit_review_report, Verdict), Verdicts),
    Verdicts == [compliant].
test(what_if_an_item_were_missing) :-
    dora_rts_review_report_format_profile_for(scheduled_review_complete, Profile),
    dora_rts_review_report_format_what_if(Profile, review_report_gives_executive_summary, false, Status),
    Status == incomplete.
test(what_if_the_missing_item_were_supplied) :-
    dora_rts_review_report_format_profile_for(missing_executive_summary, Profile),
    dora_rts_review_report_format_what_if(Profile, review_report_gives_executive_summary, true, Status),
    Status == complete.
test(what_if_the_microenterprise_were_not_one) :-
    dora_rts_review_report_format_profile_for(microenterprise_without_internal_audit, Profile),
    dora_rts_review_report_format_what_if(Profile, financial_entity_is_microenterprise, false, Status),
    Status == incomplete.
test(what_if_removes_a_duplicate) :-
    dora_rts_review_report_format_profile_for(input_duplicate_and_unknown, Profile),
    dora_rts_review_report_format_what_if(Profile, financial_entity_is_article_16_1_entity, false, Status),
    Status == input_problems([unknown_key(colour)]).
test(what_if_answers_once) :-
    dora_rts_review_report_format_profile_for(scheduled_review_complete, Profile),
    findall(Status, dora_rts_review_report_format_what_if(Profile, review_report_describes_context, unsure, Status), Statuses),
    Statuses = [needs_legal_review(open_textured(review_report_describes_context, cite(eu_reg_2024_1774_art_27_2_a_ii)), _)].
test(the_re_exported_input_check) :-
    dora_rts_review_report_format_input_problems([attribute(colour, red)], Problems),
    Problems == [unknown_key(colour)].
test(the_root_atoms_are_defined) :-
    complete,
    incomplete,
    none_outstanding,
    simplified_framework_entity,
    framework_review_report_not_requested,
    unsure,
    financial_entity_is_article_16_1_entity,
    review_report_uses_external_sources,
    report_in_searchable_electronic_format,
    report_uses_external_sources.
test(the_constructors_accept_lists) :-
    required([report_in_searchable_electronic_format]),
    outstanding([report_uses_external_sources]),
    indeterminate([financial_entity_is_article_16_1_entity]),
    input_problems([wrong_type(profile)]).

test(an_incomplete_report_is_not_compliant, fail) :-
    dora_rts_review_report_format_profile_for(missing_executive_summary, Profile),
    dora_rts_review_report_format_compliance_check(Profile, submit_review_report, compliant).
test(a_constructor_refuses_a_non_list, fail) :-
    required(report_in_searchable_electronic_format).

cp_test_names([profile_keys_are_the_contract_keys, status_of_the_baseline, checklist_marks_the_missing_item_unmet, checklist_marks_an_excluded_duty_inapplicable, a_complete_report_is_compliant, an_incomplete_report_is_non_compliant, the_gate_passes_through_the_compliance_check, a_referral_passes_through_the_compliance_check, the_compliance_check_answers_once, what_if_an_item_were_missing, what_if_the_missing_item_were_supplied, what_if_the_microenterprise_were_not_one, what_if_removes_a_duplicate, what_if_answers_once, the_re_exported_input_check, the_root_atoms_are_defined, the_constructors_accept_lists]).
cp_test_fail_names([an_incomplete_report_is_not_compliant, a_constructor_refuses_a_non_list]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
