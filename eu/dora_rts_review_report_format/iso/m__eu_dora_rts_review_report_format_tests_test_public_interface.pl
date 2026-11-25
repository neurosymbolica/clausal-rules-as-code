% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_rts_review_report_format_tests_test_public_interface, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_dora_rts_review_report_format_dora_rts_review_report_format, [decide_dora_rts_review_report_format/2, dora_rts_review_report_format_status/2, dora_rts_review_report_format_checklist/2, dora_rts_review_report_format_decision_resolvable/1, dora_rts_review_report_format_status_values/1]).
:- use_module(m__eu_dora_rts_review_report_format_fixtures, [dora_rts_review_report_format_subject/1, dora_rts_review_report_format_profile_for/2, dora_rts_review_report_format_assess/2]).
:- use_module(m__eu_dora_rts_review_report_format_dora_rts_review_report_format, [ict_risk_framework_review_report_duties_required/3, ict_risk_framework_review_report_duties_complete/3, ict_risk_framework_review_report_duties_outstanding/3]).
:- use_module(m__eu_dora_rts_review_report_format_kernel, [dora_rts_review_report_format_input_problems/2]).
:- use_module(m__eu_dora_rts_review_report_format_queries, [dora_rts_review_report_format_what_if/4, dora_rts_review_report_format_compliance_check/3]).

status_of(Subject, Status) :-
    dora_rts_review_report_format_assess(Subject, dora_rts_review_report_format_verdict(Status, _)).

citations_of(Subject, Citations) :-
    dora_rts_review_report_format_assess(Subject, dora_rts_review_report_format_verdict(_, Citations)).

required_of(Subject, Result, Citations) :-
    dora_rts_review_report_format_profile_for(Subject, Profile),
    ict_risk_framework_review_report_duties_required(Profile, Result, Citations).

complete_of(Subject, Result, Citations) :-
    dora_rts_review_report_format_profile_for(Subject, Profile),
    ict_risk_framework_review_report_duties_complete(Profile, Result, Citations).

outstanding_of(Subject, Result, Citations) :-
    dora_rts_review_report_format_profile_for(Subject, Profile),
    ict_risk_framework_review_report_duties_outstanding(Profile, Result, Citations).

fixed_citations([cite(eu_reg_2024_1774_art_27_1), cite(eu_reg_2024_1774_art_27_2)]).

answers_once(Subject) :-
    findall(Result, dora_rts_review_report_format_assess(Subject, Result), Results),
    length(Results, 1).

complete_answers_once(Subject) :-
    findall(Result - Citations, complete_of(Subject, Result, Citations), Answers),
    length(Answers, 1).

has_checklist(Subject) :-
    dora_rts_review_report_format_profile_for(Subject, Profile),
    dora_rts_review_report_format_checklist(Profile, [_|_]).

resolvable(Subject) :-
    dora_rts_review_report_format_profile_for(Subject, Profile),
    dora_rts_review_report_format_decision_resolvable(Profile).

all_subjects(Subjects) :-
    findall(Subject, dora_rts_review_report_format_subject(Subject), Subjects).

test(every_subject_answers_exactly_once) :-
    all_subjects(Subjects),
    length(Subjects, 26),
    maplist(answers_once, Subjects).
test(every_subject_answers_the_completeness_query_once) :-
    all_subjects(Subjects),
    maplist(complete_answers_once, Subjects).
test(every_subject_has_a_non_empty_checklist) :-
    all_subjects(Subjects),
    maplist(has_checklist, Subjects).
test(every_subject_is_resolvable) :-
    all_subjects(Subjects),
    maplist(resolvable, Subjects).
test(duties_complete_gives_complete) :-
    complete_of(scheduled_review_complete, Result, Citations),
    Result == complete,
    fixed_citations(Fixed),
    sort(Citations, Fixed).
test(duties_complete_gives_incomplete) :-
    complete_of(missing_executive_summary, Result, Citations),
    Result == incomplete,
    fixed_citations(Fixed),
    sort(Citations, Fixed).
test(duties_complete_gives_simplified_framework_entity) :-
    complete_of(article_16_1_entity, Result, Citations),
    Result == simplified_framework_entity,
    Citations == [cite(eu_reg_2022_2554_art_16_1)].
test(duties_complete_gives_not_requested) :-
    complete_of(not_requested, Result, Citations),
    Result == framework_review_report_not_requested,
    Citations == [].
test(duties_complete_gives_indeterminate) :-
    complete_of(absent_format, Result, Citations),
    Result == indeterminate([review_report_in_searchable_electronic_format]),
    Citations == [].
test(duties_complete_gives_needs_legal_review) :-
    complete_of(unsure_format, Result, Citations),
    Result = needs_legal_review(open_textured(review_report_in_searchable_electronic_format, cite(eu_reg_2024_1774_art_27_1)), [inputs_relied_on(Pairs)]),
    length(Pairs, 36),
    Citations == [].
test(duties_complete_gives_input_problems) :-
    complete_of(not_attribute_list, Result, Citations),
    Result == input_problems([wrong_type(profile)]),
    Citations == [].
test(referral_context_holds_only_the_inputs_relied_on) :-
    complete_of(unsure_format, needs_legal_review(_, Context), _),
    Context = [inputs_relied_on(_)|Rest],
    Rest == [].
test(outstanding_referral_context_holds_only_the_inputs_relied_on) :-
    outstanding_of(unsure_format, needs_legal_review(_, Context), _),
    Context = [inputs_relied_on(_)|Rest],
    Rest == [].
test(scheduled_review_is_complete) :-
    status_of(scheduled_review_complete, Status),
    Status == complete,
    citations_of(scheduled_review_complete, Citations),
    fixed_citations(Fixed),
    sort(Citations, Fixed).
test(complete_is_a_final_status_value) :-
    status_of(scheduled_review_complete, Status),
    dora_rts_review_report_format_status_values(StatusValues),
    member(Status, StatusValues).
test(scheduled_review_requires_twenty_five_duties) :-
    required_of(scheduled_review_complete, required(Duties), Citations),
    length(Duties, 25),
    Duties = [report_in_searchable_electronic_format|_],
    member(cite(eu_reg_2024_1774_art_27_2_l_i), Citations).
test(scheduled_review_has_none_outstanding) :-
    outstanding_of(scheduled_review_complete, Result, Citations),
    Result == none_outstanding,
    fixed_citations(Fixed),
    sort(Citations, Fixed).
test(missing_executive_summary_is_incomplete) :-
    status_of(missing_executive_summary, Status),
    Status == incomplete,
    citations_of(missing_executive_summary, Citations),
    fixed_citations(Fixed),
    sort(Citations, Fixed).
test(missing_executive_summary_is_outstanding) :-
    outstanding_of(missing_executive_summary, Result, Citations),
    Result == outstanding([report_gives_executive_summary]),
    Citations == [cite(eu_reg_2024_1774_art_27_2_a_iv)].
test(article_16_1_entity_is_simplified) :-
    status_of(article_16_1_entity, Status),
    Status == simplified_framework_entity,
    citations_of(article_16_1_entity, Citations),
    Citations == [cite(eu_reg_2022_2554_art_16_1)].
test(article_16_1_entity_required_is_simplified) :-
    required_of(article_16_1_entity, Result, Citations),
    Result == simplified_framework_entity,
    Citations == [cite(eu_reg_2022_2554_art_16_1)].
test(not_requested_is_not_requested) :-
    status_of(not_requested, Status),
    Status == framework_review_report_not_requested,
    citations_of(not_requested, Citations),
    Citations == [].
test(not_requested_outstanding_is_not_requested) :-
    outstanding_of(not_requested, Result, []),
    Result == framework_review_report_not_requested.
test(gate_absent_names_the_gate) :-
    status_of(gate_absent, Status),
    Status == indeterminate([financial_entity_is_article_16_1_entity]),
    citations_of(gate_absent, Citations),
    Citations == [].
test(gate_absent_required_names_the_gate) :-
    required_of(gate_absent, Result, []),
    Result == indeterminate([financial_entity_is_article_16_1_entity]).
test(request_absent_names_the_request) :-
    status_of(request_absent, Status),
    Status == indeterminate([authority_requested_framework_review_report]).
test(request_absent_outstanding_names_the_request) :-
    outstanding_of(request_absent, Result, []),
    Result == indeterminate([authority_requested_framework_review_report]).
test(microenterprise_absent_required_names_the_trigger) :-
    required_of(microenterprise_absent, Result, []),
    Result == indeterminate([financial_entity_is_microenterprise]).
test(microenterprise_absent_with_audit_true_is_complete) :-
    status_of(microenterprise_absent, Status),
    Status == complete.
test(microenterprise_absent_with_audit_true_has_none_outstanding) :-
    outstanding_of(microenterprise_absent, Result, _),
    Result == none_outstanding.
test(microenterprise_absent_with_audit_missing_names_the_trigger) :-
    status_of(microenterprise_absent_audit_missing, Status),
    Status == indeterminate([financial_entity_is_microenterprise]).
test(microenterprise_without_internal_audit_is_complete) :-
    status_of(microenterprise_without_internal_audit, Status),
    Status == complete.
test(microenterprise_requires_twenty_four_duties) :-
    required_of(microenterprise_without_internal_audit, required(Duties), Citations),
    length(Duties, 24),
    dif(Citations, []).
test(other_entity_without_internal_audit_is_incomplete) :-
    status_of(other_entity_without_internal_audit, Status),
    Status == incomplete.
test(other_entity_without_internal_audit_is_outstanding) :-
    outstanding_of(other_entity_without_internal_audit, Result, Citations),
    Result == outstanding([report_uses_internal_audit_results]),
    Citations == [cite(eu_reg_2024_1774_art_27_2_l_i)].
test(all_conditions_complete_is_complete) :-
    status_of(all_conditions_complete, Status),
    Status == complete.
test(all_conditions_require_twenty_nine_duties) :-
    required_of(all_conditions_complete, required(Duties), Citations),
    length(Duties, 29),
    member(cite(eu_reg_2024_1774_art_27_2_h_vi), Citations),
    member(cite(eu_reg_2024_1774_art_27_2_k_iii), Citations),
    length(Citations, 27).
test(supervisory_initiation_references_missing_is_incomplete) :-
    status_of(supervisory_initiation_references_missing, Status),
    Status == incomplete.
test(supervisory_initiation_references_missing_is_outstanding) :-
    outstanding_of(supervisory_initiation_references_missing, Result, Citations),
    Result == outstanding([report_references_initiating_instructions_or_conclusions]),
    sort(Citations, [cite(eu_reg_2024_1774_art_27_2), cite(eu_reg_2024_1774_art_27_2_c)]).
test(scheduled_review_references_missing_is_complete) :-
    status_of(scheduled_review_references_missing, Status),
    Status == complete.
test(incident_initiation_list_missing_is_incomplete) :-
    status_of(incident_initiation_list_missing, Status),
    Status == incomplete.
test(incident_initiation_list_missing_is_outstanding) :-
    outstanding_of(incident_initiation_list_missing, Result, _),
    Result == outstanding([report_lists_incidents_with_root_cause_analysis]).
test(scheduled_review_incident_list_missing_is_complete) :-
    status_of(scheduled_review_incident_list_missing, Status),
    Status == complete.
test(uncorrected_weaknesses_explanation_missing_is_incomplete) :-
    status_of(uncorrected_weaknesses_explanation_missing, Status),
    Status == incomplete.
test(uncorrected_weaknesses_explanation_missing_is_outstanding) :-
    outstanding_of(uncorrected_weaknesses_explanation_missing, Result, Citations),
    Result == outstanding([report_explains_residual_risk_acceptance]),
    Citations == [cite(eu_reg_2024_1774_art_27_2_h_vi)].
test(corrected_weaknesses_explanation_missing_is_complete) :-
    status_of(corrected_weaknesses_explanation_missing, Status),
    Status == complete.
test(ineffective_measures_improvements_missing_is_incomplete) :-
    status_of(ineffective_measures_improvements_missing, Status),
    Status == incomplete.
test(ineffective_measures_improvements_missing_is_outstanding) :-
    outstanding_of(ineffective_measures_improvements_missing, Result, Citations),
    Result == outstanding([report_describes_corrective_measure_improvements]),
    Citations == [cite(eu_reg_2024_1774_art_27_2_k_iii)].
test(effective_measures_improvements_missing_is_complete) :-
    status_of(effective_measures_improvements_missing, Status),
    Status == complete.
test(unsure_format_goes_to_a_lawyer) :-
    status_of(unsure_format, Status),
    Status = needs_legal_review(open_textured(review_report_in_searchable_electronic_format, cite(eu_reg_2024_1774_art_27_1)), [inputs_relied_on(Pairs)]),
    length(Pairs, 36),
    Pairs = [financial_entity_is_article_16_1_entity - false|_],
    member(review_report_in_searchable_electronic_format - unsure, Pairs),
    citations_of(unsure_format, Citations),
    Citations == [].
test(unsure_format_outstanding_goes_to_a_lawyer) :-
    outstanding_of(unsure_format, needs_legal_review(open_textured(review_report_in_searchable_electronic_format, cite(eu_reg_2024_1774_art_27_1)), _), []).
test(false_beats_unsure_is_incomplete) :-
    status_of(false_beats_unsure, Status),
    Status == incomplete.
test(absent_format_names_the_format_key) :-
    status_of(absent_format, Status),
    Status == indeterminate([review_report_in_searchable_electronic_format]).
test(absent_format_outstanding_names_the_format_key) :-
    outstanding_of(absent_format, Result, []),
    Result == indeterminate([review_report_in_searchable_electronic_format]).
test(absent_beats_unsure_names_the_absent_key) :-
    status_of(absent_beats_unsure, Status),
    Status == indeterminate([review_report_gives_executive_summary]).
test(input_duplicate_and_unknown_are_refused) :-
    status_of(input_duplicate_and_unknown, Status),
    Status == input_problems([duplicate_key(financial_entity_is_article_16_1_entity), unknown_key(colour)]),
    citations_of(input_duplicate_and_unknown, Citations),
    Citations == [].
test(input_duplicate_and_unknown_problems) :-
    dora_rts_review_report_format_profile_for(input_duplicate_and_unknown, Profile),
    dora_rts_review_report_format_input_problems(Profile, Problems),
    Problems == [duplicate_key(financial_entity_is_article_16_1_entity), unknown_key(colour)].
test(input_wrong_type_fact_is_refused) :-
    status_of(input_wrong_type_fact, Status),
    Status == input_problems([wrong_type(financial_entity_is_microenterprise)]).
test(input_wrong_type_fact_required_is_refused) :-
    required_of(input_wrong_type_fact, Result, []),
    Result == input_problems([wrong_type(financial_entity_is_microenterprise)]).
test(not_attribute_list_is_refused) :-
    status_of(not_attribute_list, Status),
    Status == input_problems([wrong_type(profile)]).
test(the_baseline_has_no_input_problem) :-
    dora_rts_review_report_format_profile_for(scheduled_review_complete, Profile),
    dora_rts_review_report_format_input_problems(Profile, Problems),
    Problems == [].
test(status_projects_the_verdict) :-
    dora_rts_review_report_format_profile_for(missing_executive_summary, Profile),
    dora_rts_review_report_format_status(Profile, Status),
    Status == incomplete.
test(decide_gives_the_verdict_term) :-
    dora_rts_review_report_format_profile_for(scheduled_review_complete, Profile),
    decide_dora_rts_review_report_format(Profile, dora_rts_review_report_format_verdict(Status, _)),
    Status == complete.
test(what_if_the_executive_summary_is_missing) :-
    dora_rts_review_report_format_profile_for(scheduled_review_complete, Profile),
    dora_rts_review_report_format_what_if(Profile, review_report_gives_executive_summary, false, Status),
    Status == incomplete.
test(what_if_the_summary_is_added) :-
    dora_rts_review_report_format_profile_for(missing_executive_summary, Profile),
    dora_rts_review_report_format_what_if(Profile, review_report_gives_executive_summary, true, Status),
    Status == complete.
test(what_if_the_entity_is_an_article_16_1_entity) :-
    dora_rts_review_report_format_profile_for(scheduled_review_complete, Profile),
    dora_rts_review_report_format_what_if(Profile, financial_entity_is_article_16_1_entity, true, Status),
    Status == simplified_framework_entity.
test(submitting_the_complete_report_is_compliant) :-
    dora_rts_review_report_format_profile_for(scheduled_review_complete, Profile),
    dora_rts_review_report_format_compliance_check(Profile, submit_review_report, Verdict),
    Verdict == compliant.
test(submitting_the_incomplete_report_is_non_compliant) :-
    dora_rts_review_report_format_profile_for(missing_executive_summary, Profile),
    dora_rts_review_report_format_compliance_check(Profile, submit_review_report, Verdict),
    Verdict == non_compliant.
test(compliance_passes_the_gate_through) :-
    dora_rts_review_report_format_profile_for(article_16_1_entity, Profile),
    dora_rts_review_report_format_compliance_check(Profile, submit_review_report, Verdict),
    Verdict == simplified_framework_entity.

test(duties_complete_incomplete_is_not_complete, fail) :-
    complete_of(missing_executive_summary, complete, _).
test(referral_context_carries_no_provenance_item, fail) :-
    complete_of(unsure_format, needs_legal_review(_, Context), _),
    member(provenance(_, _), Context).
test(outstanding_referral_context_carries_no_provenance_item, fail) :-
    outstanding_of(unsure_format, needs_legal_review(_, Context), _),
    member(provenance(_, _), Context).
test(missing_executive_summary_is_not_complete, fail) :-
    status_of(missing_executive_summary, complete).
test(article_16_1_entity_is_not_complete, fail) :-
    status_of(article_16_1_entity, complete).
test(not_requested_is_not_complete, fail) :-
    status_of(not_requested, complete).
test(microenterprise_does_not_need_internal_audit, fail) :-
    required_of(microenterprise_without_internal_audit, required(Duties), _),
    member(report_uses_internal_audit_results, Duties).
test(scheduled_review_references_missing_is_not_incomplete, fail) :-
    status_of(scheduled_review_references_missing, incomplete).
test(unsure_format_is_not_complete, fail) :-
    status_of(unsure_format, complete).
test(submitting_the_incomplete_report_is_not_compliant, fail) :-
    dora_rts_review_report_format_profile_for(missing_executive_summary, Profile),
    dora_rts_review_report_format_compliance_check(Profile, submit_review_report, compliant).

cp_test_names([every_subject_answers_exactly_once, every_subject_answers_the_completeness_query_once, every_subject_has_a_non_empty_checklist, every_subject_is_resolvable, duties_complete_gives_complete, duties_complete_gives_incomplete, duties_complete_gives_simplified_framework_entity, duties_complete_gives_not_requested, duties_complete_gives_indeterminate, duties_complete_gives_needs_legal_review, duties_complete_gives_input_problems, referral_context_holds_only_the_inputs_relied_on, outstanding_referral_context_holds_only_the_inputs_relied_on, scheduled_review_is_complete, complete_is_a_final_status_value, scheduled_review_requires_twenty_five_duties, scheduled_review_has_none_outstanding, missing_executive_summary_is_incomplete, missing_executive_summary_is_outstanding, article_16_1_entity_is_simplified, article_16_1_entity_required_is_simplified, not_requested_is_not_requested, not_requested_outstanding_is_not_requested, gate_absent_names_the_gate, gate_absent_required_names_the_gate, request_absent_names_the_request, request_absent_outstanding_names_the_request, microenterprise_absent_required_names_the_trigger, microenterprise_absent_with_audit_true_is_complete, microenterprise_absent_with_audit_true_has_none_outstanding, microenterprise_absent_with_audit_missing_names_the_trigger, microenterprise_without_internal_audit_is_complete, microenterprise_requires_twenty_four_duties, other_entity_without_internal_audit_is_incomplete, other_entity_without_internal_audit_is_outstanding, all_conditions_complete_is_complete, all_conditions_require_twenty_nine_duties, supervisory_initiation_references_missing_is_incomplete, supervisory_initiation_references_missing_is_outstanding, scheduled_review_references_missing_is_complete, incident_initiation_list_missing_is_incomplete, incident_initiation_list_missing_is_outstanding, scheduled_review_incident_list_missing_is_complete, uncorrected_weaknesses_explanation_missing_is_incomplete, uncorrected_weaknesses_explanation_missing_is_outstanding, corrected_weaknesses_explanation_missing_is_complete, ineffective_measures_improvements_missing_is_incomplete, ineffective_measures_improvements_missing_is_outstanding, effective_measures_improvements_missing_is_complete, unsure_format_goes_to_a_lawyer, unsure_format_outstanding_goes_to_a_lawyer, false_beats_unsure_is_incomplete, absent_format_names_the_format_key, absent_format_outstanding_names_the_format_key, absent_beats_unsure_names_the_absent_key, input_duplicate_and_unknown_are_refused, input_duplicate_and_unknown_problems, input_wrong_type_fact_is_refused, input_wrong_type_fact_required_is_refused, not_attribute_list_is_refused, the_baseline_has_no_input_problem, status_projects_the_verdict, decide_gives_the_verdict_term, what_if_the_executive_summary_is_missing, what_if_the_summary_is_added, what_if_the_entity_is_an_article_16_1_entity, submitting_the_complete_report_is_compliant, submitting_the_incomplete_report_is_non_compliant, compliance_passes_the_gate_through]).
cp_test_fail_names([duties_complete_incomplete_is_not_complete, referral_context_carries_no_provenance_item, outstanding_referral_context_carries_no_provenance_item, missing_executive_summary_is_not_complete, article_16_1_entity_is_not_complete, not_requested_is_not_complete, microenterprise_does_not_need_internal_audit, scheduled_review_references_missing_is_not_incomplete, unsure_format_is_not_complete, submitting_the_incomplete_report_is_not_compliant]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
