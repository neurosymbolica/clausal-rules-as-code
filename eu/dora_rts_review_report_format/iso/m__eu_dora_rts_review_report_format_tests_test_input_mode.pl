% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_rts_review_report_format_tests_test_input_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_dora_rts_review_report_format_dora_rts_review_report_format, [dora_rts_review_report_format_status/2, dora_rts_review_report_format_status_values/1, ict_risk_framework_review_report_duties_required/3, ict_risk_framework_review_report_duties_complete/3, ict_risk_framework_review_report_duties_outstanding/3]).
:- use_module(m__eu_dora_rts_review_report_format_fixtures, [dora_rts_review_report_format_profile_for/2]).
:- use_module(m__eu_dora_rts_review_report_format_kernel, [dora_rts_review_report_format_input_problems/2]).

test(status_holds_with_the_verdict_bound) :-
    dora_rts_review_report_format_profile_for(scheduled_review_complete, Profile),
    dora_rts_review_report_format_status(Profile, complete).
test(complete_with_its_fixed_citations_bound) :-
    dora_rts_review_report_format_profile_for(scheduled_review_complete, Profile),
    ict_risk_framework_review_report_duties_complete(Profile, complete, [cite(eu_reg_2024_1774_art_27_1), cite(eu_reg_2024_1774_art_27_2)]).
test(incomplete_with_its_fixed_citations_bound) :-
    dora_rts_review_report_format_profile_for(missing_executive_summary, Profile),
    ict_risk_framework_review_report_duties_complete(Profile, incomplete, [cite(eu_reg_2024_1774_art_27_1), cite(eu_reg_2024_1774_art_27_2)]).
test(the_gate_bound_in_every_query) :-
    dora_rts_review_report_format_profile_for(article_16_1_entity, Profile),
    ict_risk_framework_review_report_duties_required(Profile, simplified_framework_entity, [cite(eu_reg_2022_2554_art_16_1)]),
    ict_risk_framework_review_report_duties_complete(Profile, simplified_framework_entity, [cite(eu_reg_2022_2554_art_16_1)]),
    ict_risk_framework_review_report_duties_outstanding(Profile, simplified_framework_entity, [cite(eu_reg_2022_2554_art_16_1)]).
test(the_request_false_bound_in_every_query) :-
    dora_rts_review_report_format_profile_for(not_requested, Profile),
    ict_risk_framework_review_report_duties_required(Profile, framework_review_report_not_requested, []),
    ict_risk_framework_review_report_duties_complete(Profile, framework_review_report_not_requested, []),
    ict_risk_framework_review_report_duties_outstanding(Profile, framework_review_report_not_requested, []).
test(the_missing_gate_bound) :-
    dora_rts_review_report_format_profile_for(gate_absent, Profile),
    ict_risk_framework_review_report_duties_complete(Profile, indeterminate([financial_entity_is_article_16_1_entity]), []).
test(the_missing_request_bound) :-
    dora_rts_review_report_format_profile_for(request_absent, Profile),
    ict_risk_framework_review_report_duties_required(Profile, indeterminate([authority_requested_framework_review_report]), []).
test(the_referral_bound) :-
    dora_rts_review_report_format_profile_for(unsure_format, Profile),
    ict_risk_framework_review_report_duties_complete(Profile, needs_legal_review(open_textured(review_report_in_searchable_electronic_format, cite(eu_reg_2024_1774_art_27_1)), [inputs_relied_on(_)]), []).
test(the_microenterprise_list_bound) :-
    dora_rts_review_report_format_profile_for(microenterprise_without_internal_audit, Profile),
    ict_risk_framework_review_report_duties_required(Profile, required([report_in_searchable_electronic_format, report_identifies_entity_and_group_structure, report_describes_context, report_summarises_changes_since_previous_report, report_gives_executive_summary, report_states_approval_date, report_describes_reason_for_review, report_states_review_period_dates, report_indicates_responsible_function, report_describes_major_changes_and_improvements, report_analyses_impact_of_changes, report_summarises_findings_and_severity, report_summarises_remediation_measures, report_gives_measure_dates_and_progress, report_gives_measure_tools_and_functions, report_describes_resource_impact, report_informs_on_authority_information_process, report_informs_on_planned_developments, report_states_conclusions, report_lists_past_reviews, report_states_corrective_measure_implementation, report_uses_compliance_assessments, report_uses_resilience_testing_results, report_uses_external_sources]), _).
test(the_outstanding_duty_bound) :-
    dora_rts_review_report_format_profile_for(missing_executive_summary, Profile),
    ict_risk_framework_review_report_duties_outstanding(Profile, outstanding([report_gives_executive_summary]), [cite(eu_reg_2024_1774_art_27_2_a_iv)]).
test(none_outstanding_bound) :-
    dora_rts_review_report_format_profile_for(scheduled_review_complete, Profile),
    ict_risk_framework_review_report_duties_outstanding(Profile, none_outstanding, [cite(eu_reg_2024_1774_art_27_1), cite(eu_reg_2024_1774_art_27_2)]).
test(the_input_problems_bound) :-
    dora_rts_review_report_format_profile_for(input_duplicate_and_unknown, Profile),
    dora_rts_review_report_format_input_problems(Profile, [duplicate_key(financial_entity_is_article_16_1_entity), unknown_key(colour)]),
    ict_risk_framework_review_report_duties_complete(Profile, input_problems([duplicate_key(financial_entity_is_article_16_1_entity), unknown_key(colour)]), []).

test(every_other_bound_status_is_rejected, fail) :-
    dora_rts_review_report_format_profile_for(scheduled_review_complete, Profile),
    findall(Status, dora_rts_review_report_format_status(Profile, Status), [BaselineStatus]),
    dora_rts_review_report_format_status_values(StatusValues),
    member(Other, StatusValues),
    dif(Other, BaselineStatus),
    dora_rts_review_report_format_status(Profile, Other).
test(a_complete_report_is_not_bound_as_incomplete, fail) :-
    dora_rts_review_report_format_profile_for(scheduled_review_complete, Profile),
    ict_risk_framework_review_report_duties_complete(Profile, incomplete, _).
test(a_well_formed_profile_is_not_bound_to_problems, fail) :-
    dora_rts_review_report_format_profile_for(scheduled_review_complete, Profile),
    dora_rts_review_report_format_input_problems(Profile, [_|_]).

cp_test_names([status_holds_with_the_verdict_bound, complete_with_its_fixed_citations_bound, incomplete_with_its_fixed_citations_bound, the_gate_bound_in_every_query, the_request_false_bound_in_every_query, the_missing_gate_bound, the_missing_request_bound, the_referral_bound, the_microenterprise_list_bound, the_outstanding_duty_bound, none_outstanding_bound, the_input_problems_bound]).
cp_test_fail_names([every_other_bound_status_is_rejected, a_complete_report_is_not_bound_as_incomplete, a_well_formed_profile_is_not_bound_to_problems]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
