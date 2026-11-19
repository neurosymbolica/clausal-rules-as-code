% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_procedural_regulation_tests_test_negative_controls, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_procedural_regulation_gdpr_procedural_regulation, [complaint_admissibility/3, prior_request_condition/3, early_resolution/3, simple_cooperation_procedure/4, draft_decision_time_limit/4, late_step_effect/4, procedural_time_limit/4, temporal_application/5, gdpr_procedural_regulation_status_values/1]).
:- use_module(m__eu_data_protection_gdpr_procedural_regulation_fixtures, [gdpr_procedural_regulation_profile_for/2]).

fixture(Subject, Profile) :-
    gdpr_procedural_regulation_profile_for(Subject, Profile).

test(the_status_table_has_a_near_miss_atom) :-
    gdpr_procedural_regulation_status_values(StatusValues),
    StatusValues == [admissible, inadmissible].
test(data_subject_complaint_is_admissible) :-
    fixture(admissible_data_subject_complaint, Profile),
    complaint_admissibility(Profile, admissible, _).
test(complaint_without_description_is_inadmissible) :-
    fixture(data_subject_complaint_without_description, Profile),
    complaint_admissibility(Profile, inadmissible, _).
test(article_80_1_body_complaint_is_admissible) :-
    fixture(admissible_article_80_1_body_complaint, Profile),
    complaint_admissibility(Profile, admissible, _).
test(article_80_1_body_complaint_without_mandate_is_inadmissible) :-
    fixture(article_80_1_body_complaint_without_mandate, Profile),
    complaint_admissibility(Profile, inadmissible, _).
test(article_80_2_body_complaint_is_admissible) :-
    fixture(admissible_article_80_2_body_complaint, Profile),
    complaint_admissibility(Profile, admissible, _).
test(article_80_2_body_complaint_without_constitution_is_inadmissible) :-
    fixture(article_80_2_body_complaint_without_constitution, Profile),
    complaint_admissibility(Profile, inadmissible, _).
test(complaint_without_lodger_names_the_lodger) :-
    fixture(complaint_without_lodger, Profile),
    complaint_admissibility(Profile, indeterminate([complaint_lodged_by]), []).
test(prior_request_made_is_made) :-
    fixture(prior_request_made_complaint, Profile),
    prior_request_condition(Profile, prior_request_made, _).
test(prior_request_not_made_is_not_made) :-
    fixture(prior_request_not_made_complaint, Profile),
    prior_request_condition(Profile, prior_request_not_made, _).
test(prior_request_not_required_when_right_is_not_by_request) :-
    fixture(right_not_exercised_by_request_complaint, Profile),
    prior_request_condition(Profile, prior_request_not_required, _).
test(prior_request_unclear_goes_to_a_lawyer) :-
    fixture(right_exercised_by_request_unclear_complaint, Profile),
    prior_request_condition(Profile, needs_legal_review(open_textured(_, _), _), []).
test(outside_chapter_iii_rights_is_not_available) :-
    fixture(complaint_outside_chapter_iii_rights, Profile),
    early_resolution(Profile, early_resolution_not_available, _).
test(not_devoid_of_purpose_case) :-
    fixture(complaint_not_devoid_of_purpose_case, Profile),
    early_resolution(Profile, complaint_not_devoid_of_purpose, _).
test(objected_case_is_objected) :-
    fixture(early_resolution_objected_case, Profile),
    early_resolution(Profile, early_resolution_objected, _).
test(receiving_authority_resolution) :-
    fixture(early_resolution_before_receiving_authority, Profile),
    early_resolution(Profile, resolution_established_by_receiving_authority, _).
test(lead_authority_resolution) :-
    fixture(early_resolution_before_lead_authority, Profile),
    early_resolution(Profile, draft_decision_establishing_resolution, _).
test(local_case_is_outside_chapter_iii) :-
    fixture(local_case_under_article_56_2, Profile),
    simple_cooperation_procedure(Profile, chapter_iii_not_applicable, _, _).
test(open_case_is_available) :-
    fixture(simple_procedure_open_case, Profile),
    simple_cooperation_procedure(Profile, simple_procedure_available, _, _).
test(objected_case_is_excluded) :-
    fixture(simple_procedure_objected_case, Profile),
    simple_cooperation_procedure(Profile, simple_procedure_excluded_by_objection, _, _).
test(scope_in_doubt_is_not_available) :-
    fixture(scope_in_doubt_case, Profile),
    simple_cooperation_procedure(Profile, simple_procedure_not_available, _, _).
test(cooperation_need_unclear_goes_to_a_lawyer) :-
    fixture(additional_cooperation_need_unclear_case, Profile),
    simple_cooperation_procedure(Profile, needs_legal_review(open_textured(issues_addressable_without_additional_cooperation, _), _), [], []).
test(missing_statement_is_referred) :-
    fixture(local_case_statement_missing_case, Profile),
    simple_cooperation_procedure(Profile, needs_legal_review(cross_reference_unresolved(_, _), _), [], []).
test(standard_limit_has_no_extension) :-
    fixture(standard_draft_decision_case, Profile),
    draft_decision_time_limit(Profile, draft_decision_limit(15, no_extension), [], _).
test(justified_extension_has_a_ceiling) :-
    fixture(justified_extension_case, Profile),
    draft_decision_time_limit(Profile, draft_decision_limit(15, extension(up_to, 12, months)), [], _).
test(unjustified_extension_is_not_permitted) :-
    fixture(unjustified_extension_with_board_request_case, Profile),
    draft_decision_time_limit(Profile, draft_decision_limit(15, no_extension), Basis, _),
    member(extension_not_permitted, Basis),
    member(suspended_until_board_binding_decision, Basis).
test(complexity_unclear_goes_to_a_lawyer) :-
    fixture(extension_complexity_unclear_case, Profile),
    draft_decision_time_limit(Profile, needs_legal_review(open_textured(extension_justified_by_exceptional_complexity, _), _), [], []).
test(simple_procedure_limit_is_twelve_months) :-
    fixture(simple_procedure_draft_decision_case, Profile),
    draft_decision_time_limit(Profile, draft_decision_limit(12, no_extension), [], _).
test(simple_procedure_justified_extension_is_two_months) :-
    fixture(simple_procedure_justified_extension_case, Profile),
    draft_decision_time_limit(Profile, draft_decision_limit(12, extension(up_to, 2, months)), _, _).
test(simple_procedure_unjustified_extension_is_not_permitted) :-
    fixture(simple_procedure_unjustified_extension_case, Profile),
    draft_decision_time_limit(Profile, draft_decision_limit(12, no_extension), [extension_not_permitted, _], _).
test(missing_national_law_statement_is_referred) :-
    fixture(national_law_statement_missing_case, Profile),
    draft_decision_time_limit(Profile, needs_legal_review(cross_reference_unresolved(_, _), _), [], []).
test(late_step_under_this_regulation_keeps_validity) :-
    fixture(late_step_after_regulation_time_limit, Profile),
    late_step_effect(Profile, legality_and_validity_not_affected, _, _).
test(late_step_under_another_provision_is_not_governed) :-
    fixture(late_step_after_other_time_limit, Profile),
    late_step_effect(Profile, not_governed_by_article_14, _, _).
test(late_step_without_statement_is_referred) :-
    fixture(late_step_statement_missing_case, Profile),
    late_step_effect(Profile, needs_legal_review(cross_reference_unresolved(_, _), _), [], []).
test(comment_period_extends_by_exactly) :-
    procedural_time_limit([], comment_on_summary_of_key_issues, limit(4, weeks, within, _, extension(exactly, 2, weeks)), _).
test(submit_draft_decision_has_a_ceiling) :-
    procedural_time_limit([], submit_draft_decision, limit(15, months, within, _, extension(up_to, 12, months)), _).
test(informing_of_simple_extension_is_before_expiry) :-
    procedural_time_limit([], inform_of_simple_procedure_extension, limit(2, weeks, at_least_before, expiry_of_simple_procedure_time_limit, no_extension), _).
test(complaint_on_the_day_applies) :-
    temporal_application([], complaints_and_early_resolution, date(2027, 4, 2), part_applies, _).
test(complaint_the_day_before_does_not_apply) :-
    temporal_application([], complaints_and_early_resolution, date(2027, 4, 1), part_does_not_apply, _).
test(cooperation_the_day_after_applies) :-
    temporal_application([], cooperation_and_files, date(2027, 4, 3), part_applies, _).
test(dispute_resolution_on_the_day_does_not_apply) :-
    temporal_application([], dispute_resolution_and_urgency, date(2027, 4, 2), part_does_not_apply, _).

test(data_subject_complaint_is_not_inadmissible, fail) :-
    fixture(admissible_data_subject_complaint, Profile),
    complaint_admissibility(Profile, inadmissible, _).
test(complaint_without_description_is_not_admissible, fail) :-
    fixture(data_subject_complaint_without_description, Profile),
    complaint_admissibility(Profile, admissible, _).
test(article_80_1_body_complaint_without_mandate_is_not_admissible, fail) :-
    fixture(article_80_1_body_complaint_without_mandate, Profile),
    complaint_admissibility(Profile, admissible, _).
test(article_80_2_body_complaint_without_constitution_is_not_admissible, fail) :-
    fixture(article_80_2_body_complaint_without_constitution, Profile),
    complaint_admissibility(Profile, admissible, _).
test(complaint_without_lodger_is_not_admissible, fail) :-
    fixture(complaint_without_lodger, Profile),
    complaint_admissibility(Profile, admissible, _).
test(prior_request_made_is_not_not_made, fail) :-
    fixture(prior_request_made_complaint, Profile),
    prior_request_condition(Profile, prior_request_not_made, _).
test(prior_request_not_made_is_not_made_positive_is_rejected, fail) :-
    fixture(prior_request_not_made_complaint, Profile),
    prior_request_condition(Profile, prior_request_made, _).
test(prior_request_unclear_is_not_decided, fail) :-
    fixture(right_exercised_by_request_unclear_complaint, Profile),
    prior_request_condition(Profile, prior_request_made, _).
test(not_devoid_of_purpose_is_not_unavailable, fail) :-
    fixture(complaint_not_devoid_of_purpose_case, Profile),
    early_resolution(Profile, early_resolution_not_available, _).
test(objected_case_is_not_resolved, fail) :-
    fixture(early_resolution_objected_case, Profile),
    early_resolution(Profile, resolution_established_by_receiving_authority, _).
test(receiving_authority_resolution_is_not_objected, fail) :-
    fixture(early_resolution_before_receiving_authority, Profile),
    early_resolution(Profile, early_resolution_objected, _).
test(lead_authority_resolution_is_not_by_receiving_authority, fail) :-
    fixture(early_resolution_before_lead_authority, Profile),
    early_resolution(Profile, resolution_established_by_receiving_authority, _).
test(open_case_is_not_outside_chapter_iii, fail) :-
    fixture(simple_procedure_open_case, Profile),
    simple_cooperation_procedure(Profile, chapter_iii_not_applicable, _, _).
test(open_case_is_not_excluded, fail) :-
    fixture(simple_procedure_open_case, Profile),
    simple_cooperation_procedure(Profile, simple_procedure_excluded_by_objection, _, _).
test(objected_case_is_not_available, fail) :-
    fixture(simple_procedure_objected_case, Profile),
    simple_cooperation_procedure(Profile, simple_procedure_available, _, _).
test(scope_in_doubt_is_not_available_positive_is_rejected, fail) :-
    fixture(scope_in_doubt_case, Profile),
    simple_cooperation_procedure(Profile, simple_procedure_available, _, _).
test(cooperation_need_unclear_is_not_decided, fail) :-
    fixture(additional_cooperation_need_unclear_case, Profile),
    simple_cooperation_procedure(Profile, simple_procedure_available, _, _).
test(missing_statement_is_not_available, fail) :-
    fixture(local_case_statement_missing_case, Profile),
    simple_cooperation_procedure(Profile, simple_procedure_available, _, _).
test(justified_extension_is_not_without_extension, fail) :-
    fixture(justified_extension_case, Profile),
    draft_decision_time_limit(Profile, draft_decision_limit(15, no_extension), _, _).
test(justified_extension_reports_no_refusal, fail) :-
    fixture(justified_extension_case, Profile),
    draft_decision_time_limit(Profile, _, Basis, _),
    member(extension_not_permitted, Basis).
test(complexity_unclear_is_not_decided, fail) :-
    fixture(extension_complexity_unclear_case, Profile),
    draft_decision_time_limit(Profile, draft_decision_limit(_, _), _, _).
test(simple_procedure_limit_is_not_fifteen_months, fail) :-
    fixture(simple_procedure_draft_decision_case, Profile),
    draft_decision_time_limit(Profile, draft_decision_limit(15, _), _, _).
test(simple_procedure_unjustified_extension_has_no_ceiling, fail) :-
    fixture(simple_procedure_unjustified_extension_case, Profile),
    draft_decision_time_limit(Profile, draft_decision_limit(12, extension(_, _, _)), _, _).
test(missing_national_law_statement_is_not_decided, fail) :-
    fixture(national_law_statement_missing_case, Profile),
    draft_decision_time_limit(Profile, draft_decision_limit(_, _), _, _).
test(late_step_under_this_regulation_is_governed, fail) :-
    fixture(late_step_after_regulation_time_limit, Profile),
    late_step_effect(Profile, not_governed_by_article_14, _, _).
test(late_step_under_another_provision_does_not_keep_validity, fail) :-
    fixture(late_step_after_other_time_limit, Profile),
    late_step_effect(Profile, legality_and_validity_not_affected, _, _).
test(late_step_without_statement_is_not_decided, fail) :-
    fixture(late_step_statement_missing_case, Profile),
    late_step_effect(Profile, legality_and_validity_not_affected, _, _).
test(comment_period_has_no_ceiling_extension, fail) :-
    procedural_time_limit([], comment_on_summary_of_key_issues, limit(_, _, _, _, extension(up_to, _, _)), _).
test(submit_draft_decision_is_not_in_weeks, fail) :-
    procedural_time_limit([], submit_draft_decision, limit(_, weeks, _, _, _), _).
test(informing_of_simple_extension_is_not_within, fail) :-
    procedural_time_limit([], inform_of_simple_procedure_extension, limit(_, _, within, _, _), _).
test(complaint_the_day_before_is_not_applied, fail) :-
    temporal_application([], complaints_and_early_resolution, date(2027, 4, 1), part_applies, _).
test(cooperation_on_the_day_is_not_applied, fail) :-
    temporal_application([], cooperation_and_files, date(2027, 4, 2), part_applies, _).
test(dispute_resolution_the_day_after_is_not_refused, fail) :-
    temporal_application([], dispute_resolution_and_urgency, date(2027, 4, 3), part_does_not_apply, _).

cp_test_names([the_status_table_has_a_near_miss_atom, data_subject_complaint_is_admissible, complaint_without_description_is_inadmissible, article_80_1_body_complaint_is_admissible, article_80_1_body_complaint_without_mandate_is_inadmissible, article_80_2_body_complaint_is_admissible, article_80_2_body_complaint_without_constitution_is_inadmissible, complaint_without_lodger_names_the_lodger, prior_request_made_is_made, prior_request_not_made_is_not_made, prior_request_not_required_when_right_is_not_by_request, prior_request_unclear_goes_to_a_lawyer, outside_chapter_iii_rights_is_not_available, not_devoid_of_purpose_case, objected_case_is_objected, receiving_authority_resolution, lead_authority_resolution, local_case_is_outside_chapter_iii, open_case_is_available, objected_case_is_excluded, scope_in_doubt_is_not_available, cooperation_need_unclear_goes_to_a_lawyer, missing_statement_is_referred, standard_limit_has_no_extension, justified_extension_has_a_ceiling, unjustified_extension_is_not_permitted, complexity_unclear_goes_to_a_lawyer, simple_procedure_limit_is_twelve_months, simple_procedure_justified_extension_is_two_months, simple_procedure_unjustified_extension_is_not_permitted, missing_national_law_statement_is_referred, late_step_under_this_regulation_keeps_validity, late_step_under_another_provision_is_not_governed, late_step_without_statement_is_referred, comment_period_extends_by_exactly, submit_draft_decision_has_a_ceiling, informing_of_simple_extension_is_before_expiry, complaint_on_the_day_applies, complaint_the_day_before_does_not_apply, cooperation_the_day_after_applies, dispute_resolution_on_the_day_does_not_apply]).
cp_test_fail_names([data_subject_complaint_is_not_inadmissible, complaint_without_description_is_not_admissible, article_80_1_body_complaint_without_mandate_is_not_admissible, article_80_2_body_complaint_without_constitution_is_not_admissible, complaint_without_lodger_is_not_admissible, prior_request_made_is_not_not_made, prior_request_not_made_is_not_made_positive_is_rejected, prior_request_unclear_is_not_decided, not_devoid_of_purpose_is_not_unavailable, objected_case_is_not_resolved, receiving_authority_resolution_is_not_objected, lead_authority_resolution_is_not_by_receiving_authority, open_case_is_not_outside_chapter_iii, open_case_is_not_excluded, objected_case_is_not_available, scope_in_doubt_is_not_available_positive_is_rejected, cooperation_need_unclear_is_not_decided, missing_statement_is_not_available, justified_extension_is_not_without_extension, justified_extension_reports_no_refusal, complexity_unclear_is_not_decided, simple_procedure_limit_is_not_fifteen_months, simple_procedure_unjustified_extension_has_no_ceiling, missing_national_law_statement_is_not_decided, late_step_under_this_regulation_is_governed, late_step_under_another_provision_does_not_keep_validity, late_step_without_statement_is_not_decided, comment_period_has_no_ceiling_extension, submit_draft_decision_is_not_in_weeks, informing_of_simple_extension_is_not_within, complaint_the_day_before_is_not_applied, cooperation_on_the_day_is_not_applied, dispute_resolution_the_day_after_is_not_refused]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
