% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_rts_simplified_testing_continuity_and_report_tests_test_output_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_lists_extra, [last/2]).
:- use_module(m__eu_dora_rts_simplified_testing_continuity_and_report_dora_rts_simplified_testing_continuity_and_report, [simplified_testing_continuity_and_report_duties_required/3, simplified_testing_continuity_and_report_duties_complete/3, simplified_testing_continuity_and_report_duties_outstanding/3, decide_dora_rts_simplified_testing_continuity_and_report/2, dora_rts_simplified_testing_continuity_and_report_status/2, dora_rts_simplified_testing_continuity_and_report_checklist/2]).
:- use_module(m__eu_dora_rts_simplified_testing_continuity_and_report_fixtures, [dora_rts_simplified_testing_continuity_and_report_profile_for/2]).

articles_36_to_40_duties([ict_security_testing_plan, review_and_testing_of_security_measures, evaluation_of_security_test_results, acquisition_development_and_maintenance_procedure, requirements_specified_before_acquisition, testing_and_approval_before_use, manipulation_risk_measures, ict_project_management_procedure, ict_change_management_procedure, continuity_plans_based_on_disruption_analysis, management_body_approval_of_continuity_plans, continuity_plans_documented_and_accessible, continuity_plan_resources, recovery_levels_and_timeframes, activation_conditions_and_actions, restoration_and_recovery_measures, backup_procedures, alternative_options, communication_arrangements, updating_of_continuity_plans, testing_of_continuity_plans, continuity_testing_demonstrates_viability, continuity_test_results_and_deficiencies]).

fixed_citation_set([cite(eu_reg_2022_2554_art_16_1), cite(eu_reg_2024_1774_art_36_1), cite(eu_reg_2024_1774_art_36_2), cite(eu_reg_2024_1774_art_36_3), cite(eu_reg_2024_1774_art_37), cite(eu_reg_2024_1774_art_38_1), cite(eu_reg_2024_1774_art_38_2), cite(eu_reg_2024_1774_art_39_1), cite(eu_reg_2024_1774_art_39_2), cite(eu_reg_2024_1774_art_40_1), cite(eu_reg_2024_1774_art_40_2), cite(eu_reg_2024_1774_art_40_3), cite(eu_reg_2024_1774_art_41_1), cite(eu_reg_2024_1774_art_41_2)]).

test(the_baseline_profile_yields_exactly_one_status) :-
    dora_rts_simplified_testing_continuity_and_report_profile_for(todo_baseline_subject, Profile),
    findall(Status, dora_rts_simplified_testing_continuity_and_report_status(Profile, Status), Statuses),
    Statuses == [complete].
test(the_verdict_carries_the_fixed_citations) :-
    dora_rts_simplified_testing_continuity_and_report_profile_for(todo_baseline_subject, Profile),
    decide_dora_rts_simplified_testing_continuity_and_report(Profile, dora_rts_simplified_testing_continuity_and_report_verdict(complete, Citations)),
    sort(Citations, CitationSet),
    fixed_citation_set(Expected),
    sort(Expected, CitationSet).
test(required_without_request_lists_the_twenty_three_in_duty_order) :-
    dora_rts_simplified_testing_continuity_and_report_profile_for(all_performed_without_request, Profile),
    simplified_testing_continuity_and_report_duties_required(Profile, required(Duties), Citations),
    articles_36_to_40_duties(Expected),
    Duties == Expected,
    sort(Citations, CitationSet),
    sort([cite(eu_reg_2022_2554_art_16_1), cite(eu_reg_2024_1774_art_36_1), cite(eu_reg_2024_1774_art_36_2), cite(eu_reg_2024_1774_art_36_3), cite(eu_reg_2024_1774_art_37), cite(eu_reg_2024_1774_art_38_1), cite(eu_reg_2024_1774_art_38_2), cite(eu_reg_2024_1774_art_39_1), cite(eu_reg_2024_1774_art_39_2), cite(eu_reg_2024_1774_art_40_1), cite(eu_reg_2024_1774_art_40_2), cite(eu_reg_2024_1774_art_40_3)], CitationSet).
test(required_with_both_reasons_lists_all_thirty_eight) :-
    dora_rts_simplified_testing_continuity_and_report_profile_for(all_performed_with_request_for_both_reasons, Profile),
    simplified_testing_continuity_and_report_duties_required(Profile, required(Duties), Citations),
    length(Duties, 38),
    articles_36_to_40_duties(Earlier),
    append(Earlier, Later, Duties),
    Later = [review_report_in_searchable_electronic_format|_],
    last(Duties, report_overall_conclusions),
    sort(Citations, CitationSet),
    fixed_citation_set(Expected),
    sort(Expected, CitationSet).
test(required_drops_only_the_evidence_duty_without_supervisory_instructions) :-
    simplified_testing_continuity_and_report_duties_required([attribute(financial_entity_is_article_16_1_entity, true), attribute(authority_requested_framework_review_report, true), attribute(framework_review_initiated_following_supervisory_instructions, false), attribute(framework_review_initiated_following_ict_related_incidents, true)], required(Duties), _),
    length(Duties, 37),
    member(report_incidents_and_root_cause_analysis, Duties).
test(the_referral_carries_every_present_pair_in_root_order) :-
    dora_rts_simplified_testing_continuity_and_report_profile_for(backup_procedures_unsure_without_request, Profile),
    simplified_testing_continuity_and_report_duties_complete(Profile, needs_legal_review(open_textured(continuity_plans_identify_backup_procedures_scope_and_frequency, cite(eu_reg_2024_1774_art_39_2)), [inputs_relied_on(KeyPairs)]), []),
    length(KeyPairs, 25),
    KeyPairs = [financial_entity_is_article_16_1_entity - true, authority_requested_framework_review_report - false, ict_security_testing_plan_established_and_implemented - true|_],
    member(continuity_plans_identify_backup_procedures_scope_and_frequency - unsure, KeyPairs).
test(outstanding_refers_the_same_unsure_judgement) :-
    dora_rts_simplified_testing_continuity_and_report_profile_for(backup_procedures_unsure_without_request, Profile),
    simplified_testing_continuity_and_report_duties_outstanding(Profile, needs_legal_review(open_textured(continuity_plans_identify_backup_procedures_scope_and_frequency, cite(eu_reg_2024_1774_art_39_2)), [inputs_relied_on(_)]), []).
test(outstanding_cites_only_the_failing_duty) :-
    dora_rts_simplified_testing_continuity_and_report_profile_for(incident_list_missing_with_request_for_both_reasons, Profile),
    simplified_testing_continuity_and_report_duties_outstanding(Profile, outstanding([report_incidents_and_root_cause_analysis]), [cite(eu_reg_2024_1774_art_41_2)]).
test(none_outstanding_carries_the_fixed_citations) :-
    dora_rts_simplified_testing_continuity_and_report_profile_for(all_performed_without_request, Profile),
    simplified_testing_continuity_and_report_duties_outstanding(Profile, none_outstanding, Citations),
    sort(Citations, CitationSet),
    fixed_citation_set(Expected),
    sort(Expected, CitationSet).
test(the_checklist_cites_each_duty) :-
    dora_rts_simplified_testing_continuity_and_report_profile_for(all_performed_without_request, Profile),
    dora_rts_simplified_testing_continuity_and_report_checklist(Profile, Items),
    member(item(ict_security_testing_plan, met, [cite(eu_reg_2024_1774_art_36_1)]), Items),
    member(item(report_overall_conclusions, inapplicable, [cite(eu_reg_2024_1774_art_41_2)]), Items).

test(required_without_supervisory_instructions_has_no_evidence_duty, fail) :-
    simplified_testing_continuity_and_report_duties_required([attribute(financial_entity_is_article_16_1_entity, true), attribute(authority_requested_framework_review_report, true), attribute(framework_review_initiated_following_supervisory_instructions, false), attribute(framework_review_initiated_following_ict_related_incidents, true)], required(Duties), _),
    member(report_evidence_of_supervisory_instructions, Duties).

cp_test_names([the_baseline_profile_yields_exactly_one_status, the_verdict_carries_the_fixed_citations, required_without_request_lists_the_twenty_three_in_duty_order, required_with_both_reasons_lists_all_thirty_eight, required_drops_only_the_evidence_duty_without_supervisory_instructions, the_referral_carries_every_present_pair_in_root_order, outstanding_refers_the_same_unsure_judgement, outstanding_cites_only_the_failing_duty, none_outstanding_carries_the_fixed_citations, the_checklist_cites_each_duty]).
cp_test_fail_names([required_without_supervisory_instructions_has_no_evidence_duty]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
