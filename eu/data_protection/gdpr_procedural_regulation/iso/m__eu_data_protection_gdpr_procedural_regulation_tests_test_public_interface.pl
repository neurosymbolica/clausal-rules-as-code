% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_procedural_regulation_tests_test_public_interface, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_procedural_regulation_gdpr_procedural_regulation, [decide_gdpr_procedural_regulation/2, gdpr_procedural_regulation_status/2, gdpr_procedural_regulation_checklist/2, gdpr_procedural_regulation_decision_resolvable/1, gdpr_procedural_regulation_status_values/1, complaint_admissibility/3, prior_request_condition/3, early_resolution/3, simple_cooperation_procedure/4, draft_decision_time_limit/4, late_step_effect/4, procedural_time_limit/4, temporal_application/5]).
:- use_module(m__eu_data_protection_gdpr_procedural_regulation_fixtures, [gdpr_procedural_regulation_subject/1, gdpr_procedural_regulation_profile_for/2, gdpr_procedural_regulation_assess/2]).
:- use_module(m__eu_data_protection_gdpr_procedural_regulation_kernel, [gdpr_procedural_regulation_input_problems/2]).

answer_of(Query, Subject, Result, Citations) :-
    gdpr_procedural_regulation_profile_for(Subject, Profile),
    findall(Answer - RawCitations, call(Query, Profile, Answer, RawCitations), Answers),
    Answers = [Result - RawCitations],
    sort(RawCitations, Citations).

answer_with_basis(Query, Subject, Result, Basis, Citations) :-
    gdpr_procedural_regulation_profile_for(Subject, Profile),
    findall(Answer - AnswerBasis - RawCitations, call(Query, Profile, Answer, AnswerBasis, RawCitations), Answers),
    Answers = [Result - Basis - RawCitations],
    sort(RawCitations, Citations).

attested_value_of(Subject, ProfileKey, Attested) :-
    gdpr_procedural_regulation_profile_for(Subject, Profile),
    member(attribute(ProfileKey, Attested), Profile).

exactly_one_answer_each(Subject) :-
    gdpr_procedural_regulation_profile_for(Subject, Profile),
    findall(Result, complaint_admissibility(Profile, Result, _), AdmissibilityAnswers),
    length(AdmissibilityAnswers, 1),
    findall(Result, prior_request_condition(Profile, Result, _), PriorRequestAnswers),
    length(PriorRequestAnswers, 1),
    findall(Result, early_resolution(Profile, Result, _), EarlyResolutionAnswers),
    length(EarlyResolutionAnswers, 1),
    findall(Result, simple_cooperation_procedure(Profile, Result, _, _), SimpleAnswers),
    length(SimpleAnswers, 1),
    findall(Result, draft_decision_time_limit(Profile, Result, _, _), DraftAnswers),
    length(DraftAnswers, 1),
    findall(Result, late_step_effect(Profile, Result, _, _), LateAnswers),
    length(LateAnswers, 1),
    findall(Limit, procedural_time_limit(Profile, submit_draft_decision, Limit, _), LimitAnswers),
    length(LimitAnswers, 1),
    findall(Result, temporal_application(Profile, cooperation_and_files, date(2027, 4, 3), Result, _), TemporalAnswers),
    length(TemporalAnswers, 1),
    findall(Problems, gdpr_procedural_regulation_input_problems(Profile, Problems), ProblemAnswers),
    length(ProblemAnswers, 1).

checklist_not_empty(Subject) :-
    gdpr_procedural_regulation_profile_for(Subject, Profile),
    gdpr_procedural_regulation_checklist(Profile, [_|_]).

time_limit_row_holds(row(ProceduralStep, ExpectedLimit, ExpectedCitations)) :-
    findall(Limit - Citations, procedural_time_limit([], ProceduralStep, Limit, Citations), Answers),
    Answers == [ExpectedLimit - ExpectedCitations].

test(every_subject_answers_every_query_exactly_once) :-
    findall(Subject, gdpr_procedural_regulation_subject(Subject), Subjects),
    Subjects = [_|_],
    maplist(exactly_one_answer_each, Subjects).
test(every_subject_has_a_non_empty_checklist) :-
    findall(Subject, gdpr_procedural_regulation_subject(Subject), Subjects),
    maplist(checklist_not_empty, Subjects).
test(the_status_values_are_admissible_and_inadmissible) :-
    gdpr_procedural_regulation_status_values([admissible, inadmissible]).
test(a_complete_data_subject_complaint_is_admissible) :-
    answer_of(complaint_admissibility, admissible_data_subject_complaint, admissible, Citations),
    sort([cite(eu_reg_2025_2518_art_4_1), cite(eu_reg_2025_2518_art_4_1_a), cite(eu_reg_2025_2518_art_4_1_d), cite(eu_reg_2025_2518_art_4_1_e), cite(eu_reg_2025_2518_art_4_5)], Citations).
test(a_complaint_without_a_description_is_inadmissible) :-
    answer_of(complaint_admissibility, inadmissible_missing_description, inadmissible, Citations),
    sort([cite(eu_reg_2025_2518_art_4_1), cite(eu_reg_2025_2518_art_4_2), cite(eu_reg_2025_2518_art_4_5)], Citations).
test(a_complete_article_80_1_complaint_is_admissible_with_points_b_and_c) :-
    answer_of(complaint_admissibility, admissible_article_80_1_complaint, admissible, Citations),
    sort([cite(eu_reg_2025_2518_art_4_1), cite(eu_reg_2025_2518_art_4_1_a), cite(eu_reg_2025_2518_art_4_1_b), cite(eu_reg_2025_2518_art_4_1_c), cite(eu_reg_2025_2518_art_4_1_d), cite(eu_reg_2025_2518_art_4_1_e), cite(eu_reg_2025_2518_art_4_5)], Citations).
test(an_article_80_1_complaint_without_the_mandate_is_inadmissible) :-
    answer_of(complaint_admissibility, inadmissible_missing_mandate, inadmissible, _).
test(an_article_80_2_body_needs_no_mandate) :-
    answer_of(complaint_admissibility, admissible_article_80_2_complaint_without_mandate_key, admissible, Citations),
    sort([cite(eu_reg_2025_2518_art_4_1), cite(eu_reg_2025_2518_art_4_1_a), cite(eu_reg_2025_2518_art_4_1_b), cite(eu_reg_2025_2518_art_4_1_d), cite(eu_reg_2025_2518_art_4_1_e), cite(eu_reg_2025_2518_art_4_5)], Citations).
test(an_unstated_lodger_is_named_as_missing) :-
    answer_of(complaint_admissibility, lodger_not_stated, indeterminate([complaint_lodged_by]), []).
test(a_key_admissibility_does_not_read_does_not_change_it) :-
    gdpr_procedural_regulation_profile_for(admissible_data_subject_complaint, Profile),
    findall(Result, complaint_admissibility([attribute(simple_cooperation_procedure_applied, true), attribute(complaint_concerns_right_exercised_by_request, unsure)|Profile], Result, _), Results),
    Results == [admissible].
test(the_facade_assesses_an_admissible_subject) :-
    gdpr_procedural_regulation_assess(admissible_data_subject_complaint, gdpr_procedural_regulation_verdict(admissible, [_|_])).
test(the_facade_assesses_an_inadmissible_subject) :-
    gdpr_procedural_regulation_assess(inadmissible_missing_mandate, gdpr_procedural_regulation_verdict(inadmissible, [_|_])).
test(the_facade_status_of_an_unstated_lodger) :-
    gdpr_procedural_regulation_profile_for(lodger_not_stated, Profile),
    gdpr_procedural_regulation_status(Profile, indeterminate([complaint_lodged_by])).
test(the_facade_decides_like_complaint_admissibility) :-
    gdpr_procedural_regulation_profile_for(inadmissible_missing_description, Profile),
    decide_gdpr_procedural_regulation(Profile, gdpr_procedural_regulation_verdict(Status, Citations)),
    complaint_admissibility(Profile, Status, Citations).
test(an_admissible_subject_is_resolvable) :-
    gdpr_procedural_regulation_profile_for(admissible_data_subject_complaint, Profile),
    gdpr_procedural_regulation_decision_resolvable(Profile).
test(the_checklist_of_a_data_subject_complaint) :-
    gdpr_procedural_regulation_profile_for(admissible_data_subject_complaint, Profile),
    gdpr_procedural_regulation_checklist(Profile, Items),
    length(Items, 5),
    member(item(point_a, met, cite(eu_reg_2025_2518_art_4_1_a)), Items),
    member(item(point_c, inapplicable, cite(eu_reg_2025_2518_art_4_1_c)), Items).
test(the_checklist_marks_the_missing_description_unmet) :-
    gdpr_procedural_regulation_profile_for(inadmissible_missing_description, Profile),
    gdpr_procedural_regulation_checklist(Profile, Items),
    member(item(point_e, unmet(not_included), cite(eu_reg_2025_2518_art_4_1_e)), Items).
test(a_prior_request_was_made) :-
    answer_of(prior_request_condition, prior_request_made, prior_request_made, [cite(eu_reg_2025_2518_art_4_3)]).
test(a_prior_request_was_not_made) :-
    answer_of(prior_request_condition, prior_request_not_made, prior_request_not_made, [cite(eu_reg_2025_2518_art_4_3)]).
test(no_prior_request_is_required) :-
    answer_of(prior_request_condition, prior_request_not_required, prior_request_not_required, [cite(eu_reg_2025_2518_art_4_3)]).
test(an_unsure_right_goes_to_a_lawyer) :-
    answer_of(prior_request_condition, prior_request_unsure, needs_legal_review(open_textured(complaint_concerns_right_exercised_by_request, cite(eu_reg_2025_2518_art_4_3)), [inputs_relied_on([complaint_concerns_right_exercised_by_request - unsure])]), []).
test(the_receiving_authority_establishes_the_resolution) :-
    answer_of(early_resolution, early_resolution_by_receiving_authority, resolution_established_by_receiving_authority, Citations),
    sort([cite(eu_reg_2025_2518_art_5_1_a), cite(eu_reg_2025_2518_art_5_2), cite(eu_reg_2025_2518_art_5_2_c), cite(eu_reg_2025_2518_art_5_3), cite(eu_reg_2025_2518_art_5_6)], Citations).
test(the_lead_authority_submits_a_draft_decision) :-
    answer_of(early_resolution, early_resolution_by_lead_authority, draft_decision_establishing_resolution, Citations),
    sort([cite(eu_reg_2025_2518_art_5_1_b), cite(eu_reg_2025_2518_art_5_2), cite(eu_reg_2025_2518_art_5_2_c), cite(eu_reg_2025_2518_art_5_4), cite(eu_reg_2025_2518_art_5_6)], Citations).
test(an_objection_in_time_stops_the_resolution) :-
    answer_of(early_resolution, early_resolution_objected, early_resolution_objected, Citations),
    sort([cite(eu_reg_2025_2518_art_5_2), cite(eu_reg_2025_2518_art_5_2_c)], Citations).
test(early_resolution_needs_chapter_iii_rights) :-
    answer_of(early_resolution, early_resolution_outside_chapter_iii_rights, early_resolution_not_available, [cite(eu_reg_2025_2518_art_5_1)]).
test(an_infringement_not_ended_leaves_the_complaint_with_purpose) :-
    answer_of(early_resolution, early_resolution_infringement_not_ended, complaint_not_devoid_of_purpose, [cite(eu_reg_2025_2518_art_5_2)]).
test(a_local_case_is_outside_chapter_iii) :-
    attested_value_of(local_case_under_article_56_2, case_handled_under_article_56_2, Attested),
    answer_with_basis(simple_cooperation_procedure, local_case_under_article_56_2, chapter_iii_not_applicable, [outside_fact(case_handled_under_article_56_2, Attested)], [cite(eu_reg_2025_2518_art_6_5)]).
test(the_simple_procedure_is_available) :-
    attested_value_of(simple_procedure_available, case_handled_under_article_56_2, Attested),
    answer_with_basis(simple_cooperation_procedure, simple_procedure_available, simple_procedure_available, [outside_fact(case_handled_under_article_56_2, Attested)], Citations),
    sort([cite(eu_reg_2025_2518_art_6_1), cite(eu_reg_2025_2518_art_6_1_a), cite(eu_reg_2025_2518_art_6_1_b), cite(eu_reg_2025_2518_art_6_3)], Citations).
test(an_objection_excludes_the_simple_procedure) :-
    attested_value_of(simple_procedure_objected, case_handled_under_article_56_2, Attested),
    answer_with_basis(simple_cooperation_procedure, simple_procedure_objected, simple_procedure_excluded_by_objection, [outside_fact(case_handled_under_article_56_2, Attested)], [cite(eu_reg_2025_2518_art_6_3)]).
test(a_scope_doubt_makes_the_simple_procedure_unavailable) :-
    attested_value_of(simple_procedure_scope_doubt, case_handled_under_article_56_2, Attested),
    answer_with_basis(simple_cooperation_procedure, simple_procedure_scope_doubt, simple_procedure_not_available, [outside_fact(case_handled_under_article_56_2, Attested)], Citations),
    sort([cite(eu_reg_2025_2518_art_6_1), cite(eu_reg_2025_2518_art_6_1_a), cite(eu_reg_2025_2518_art_6_1_b)], Citations).
test(a_scope_doubt_without_the_local_statement_is_referred) :-
    answer_with_basis(simple_cooperation_procedure, simple_procedure_scope_doubt_without_local_statement, needs_legal_review(cross_reference_unresolved(cite(eu_reg_2025_2518_art_6_5), cite(article_56_2_local_case_statement)), [resolution(cite(article_56_2_local_case_statement), not_attempted), inputs_relied_on([case_handled_under_article_56_2 - absent])]), [], []).
test(an_unsure_cooperation_need_goes_to_a_lawyer) :-
    answer_with_basis(simple_cooperation_procedure, simple_procedure_cooperation_unsure, needs_legal_review(open_textured(issues_addressable_without_additional_cooperation, cite(eu_reg_2025_2518_art_6_1_b)), [inputs_relied_on([issues_addressable_without_additional_cooperation - unsure])]), [], []).
test(a_document_evidence_local_case_statement_is_copied_into_basis) :-
    Attested = attested(true, attestation(host_user, host_time, stated_reason, document(upload_identifier, content_hash))),
    findall(Result - Basis - Citations, simple_cooperation_procedure([attribute(case_handled_under_article_56_2, Attested)], Result, Basis, Citations), Answers),
    Answers == [chapter_iii_not_applicable - [outside_fact(case_handled_under_article_56_2, Attested)] - [cite(eu_reg_2025_2518_art_6_5)]].
test(the_base_draft_decision_limit_is_fifteen_months) :-
    answer_with_basis(draft_decision_time_limit, draft_decision_base_limit, draft_decision_limit(15, no_extension), [], [cite(eu_reg_2025_2518_art_12_1)]).
test(a_suspended_and_justified_extension) :-
    answer_with_basis(draft_decision_time_limit, draft_decision_suspended_and_extended, draft_decision_limit(15, extension(up_to, 12, months)), [suspended_until_board_binding_decision], Citations),
    sort([cite(eu_reg_2025_2518_art_12_1), cite(eu_reg_2025_2518_art_12_2), cite(eu_reg_2025_2518_art_12_3)], Citations).
test(an_unjustified_extension_is_not_permitted) :-
    answer_with_basis(draft_decision_time_limit, draft_decision_unjustified_extension, draft_decision_limit(15, no_extension), [extension_not_permitted], Citations),
    sort([cite(eu_reg_2025_2518_art_12_1), cite(eu_reg_2025_2518_art_12_3)], Citations).
test(an_unsure_complexity_goes_to_a_lawyer) :-
    answer_with_basis(draft_decision_time_limit, draft_decision_complexity_unsure, needs_legal_review(open_textured(extension_justified_by_exceptional_complexity, cite(eu_reg_2025_2518_art_12_3)), [inputs_relied_on([extension_justified_by_exceptional_complexity - unsure])]), [], []).
test(the_simple_procedure_limit_is_twelve_months) :-
    answer_with_basis(draft_decision_time_limit, simple_procedure_draft_decision_without_extension, draft_decision_limit(12, no_extension), [], Citations),
    sort([cite(eu_reg_2025_2518_art_6_1), cite(eu_reg_2025_2518_art_12_6)], Citations).
test(national_law_permits_a_two_month_extension) :-
    attested_value_of(simple_procedure_extension_with_national_statement, national_law_requires_domestic_proceedings_after_time_limit, Attested),
    answer_with_basis(draft_decision_time_limit, simple_procedure_extension_with_national_statement, draft_decision_limit(12, extension(up_to, 2, months)), [outside_fact(national_law_requires_domestic_proceedings_after_time_limit, Attested)], Citations),
    sort([cite(eu_reg_2025_2518_art_6_1), cite(eu_reg_2025_2518_art_12_6)], Citations).
test(without_the_national_need_the_extension_is_not_permitted) :-
    attested_value_of(simple_procedure_extension_refused_by_national_law, national_law_requires_domestic_proceedings_after_time_limit, Attested),
    answer_with_basis(draft_decision_time_limit, simple_procedure_extension_refused_by_national_law, draft_decision_limit(12, no_extension), [extension_not_permitted, outside_fact(national_law_requires_domestic_proceedings_after_time_limit, Attested)], _).
test(an_absent_national_statement_is_referred) :-
    answer_with_basis(draft_decision_time_limit, simple_procedure_extension_without_national_statement, needs_legal_review(cross_reference_unresolved(cite(eu_reg_2025_2518_art_12_6), cite(national_domestic_proceedings_statement)), [resolution(cite(national_domestic_proceedings_statement), not_attempted), inputs_relied_on([national_law_requires_domestic_proceedings_after_time_limit - absent])]), [], []).
test(a_document_evidence_national_statement_refusing_the_extension) :-
    Attested = attested(false, attestation(host_user, host_time, stated_reason, document(upload_identifier, content_hash))),
    findall(Result - Basis, draft_decision_time_limit([attribute(simple_cooperation_procedure_applied, true), attribute(draft_decision_time_limit_extended, true), attribute(national_law_requires_domestic_proceedings_after_time_limit, Attested)], Result, Basis, _), Answers),
    Answers == [draft_decision_limit(12, no_extension) - [extension_not_permitted, outside_fact(national_law_requires_domestic_proceedings_after_time_limit, Attested)]].
test(a_late_step_under_this_regulation_stays_valid) :-
    attested_value_of(late_step_under_this_regulation, time_limit_set_by_this_regulation_or_article_65_6, Attested),
    answer_with_basis(late_step_effect, late_step_under_this_regulation, legality_and_validity_not_affected, [outside_fact(time_limit_set_by_this_regulation_or_article_65_6, Attested)], [cite(eu_reg_2025_2518_art_14)]).
test(a_late_step_under_another_provision_is_not_governed) :-
    attested_value_of(late_step_under_national_law, time_limit_set_by_this_regulation_or_article_65_6, Attested),
    answer_with_basis(late_step_effect, late_step_under_national_law, not_governed_by_article_14, [outside_fact(time_limit_set_by_this_regulation_or_article_65_6, Attested)], [cite(eu_reg_2025_2518_art_14)]).
test(a_late_step_without_a_source_statement_is_referred) :-
    answer_with_basis(late_step_effect, late_step_without_source_statement, needs_legal_review(cross_reference_unresolved(cite(eu_reg_2025_2518_art_14), cite(time_limit_source_statement)), [resolution(cite(time_limit_source_statement), not_attempted), inputs_relied_on([time_limit_set_by_this_regulation_or_article_65_6 - absent])]), [], []).
test(a_document_evidence_source_statement_true_keeps_the_step_valid) :-
    Attested = attested(true, attestation(host_user, host_time, stated_reason, document(upload_identifier, content_hash))),
    findall(Result - Basis - Citations, late_step_effect([attribute(time_limit_set_by_this_regulation_or_article_65_6, Attested)], Result, Basis, Citations), Answers),
    Answers == [legality_and_validity_not_affected - [outside_fact(time_limit_set_by_this_regulation_or_article_65_6, Attested)] - [cite(eu_reg_2025_2518_art_14)]].
test(a_document_evidence_source_statement_false_is_not_governed) :-
    Attested = attested(false, attestation(host_user, host_time, stated_reason, document(upload_identifier, content_hash))),
    findall(Result - Basis - Citations, late_step_effect([attribute(time_limit_set_by_this_regulation_or_article_65_6, Attested)], Result, Basis, Citations), Answers),
    Answers == [not_governed_by_article_14 - [outside_fact(time_limit_set_by_this_regulation_or_article_65_6, Attested)] - [cite(eu_reg_2025_2518_art_14)]].
test(a_malformed_profile_gets_only_its_problems) :-
    answer_of(complaint_admissibility, malformed_profile_duplicates_and_unknown, input_problems([duplicate_key(complaint_lodged_by), wrong_type(lodging_person_name_and_contact_details_included), unknown_key(colour)]), []).
test(a_malformed_profile_gives_basis_and_citations_empty) :-
    answer_with_basis(simple_cooperation_procedure, malformed_profile_duplicates_and_unknown, input_problems([_|_]), [], []).
test(a_well_formed_profile_has_no_problems) :-
    gdpr_procedural_regulation_profile_for(simple_procedure_available, Profile),
    gdpr_procedural_regulation_input_problems(Profile, []).
test(a_document_evidence_outside_fact_is_well_formed) :-
    findall(Problems, gdpr_procedural_regulation_input_problems([attribute(time_limit_set_by_this_regulation_or_article_65_6, attested(true, attestation(host_user, host_time, stated_reason, document(upload_identifier, content_hash))))], Problems), Answers),
    Answers == [[]].
test(a_document_term_alone_is_not_an_outside_fact) :-
    gdpr_procedural_regulation_input_problems([attribute(time_limit_set_by_this_regulation_or_article_65_6, document(upload_identifier, content_hash))], [wrong_type(time_limit_set_by_this_regulation_or_article_65_6)]).
test(an_attested_value_for_a_crisp_key_is_wrong_type) :-
    gdpr_procedural_regulation_input_problems([attribute(complaint_concerns_chapter_iii_rights, attested(true, attestation(by, at, reason, none)))], [wrong_type(complaint_concerns_chapter_iii_rights)]).
test(a_bare_value_for_an_outside_fact_is_wrong_type) :-
    gdpr_procedural_regulation_input_problems([attribute(case_handled_under_article_56_2, true)], [wrong_type(case_handled_under_article_56_2)]).
test(a_term_that_is_not_an_attribute_list_is_wrong_type_profile) :-
    gdpr_procedural_regulation_input_problems(not_a_profile, [wrong_type(profile)]).
test(the_sixteen_time_limit_rows) :-
    Rows = [row(declare_complaint_inadmissible, limit(2, weeks, within, receipt_of_complaint, no_extension), [cite(eu_reg_2025_2518_art_4_2)]), row(transmit_complaint_to_presumed_lead_authority, limit(6, weeks, within, receipt_of_complaint, no_extension), [cite(eu_reg_2025_2518_art_4_5)]), row(confirm_competence_or_refer_to_board, limit(6, weeks, within, receipt_of_complaint, no_extension), [cite(eu_reg_2025_2518_art_4_6)]), row(object_to_early_resolution, limit(4, weeks, within, complainant_receiving_early_resolution_information, no_extension), [cite(eu_reg_2025_2518_art_5_2_c)]), row(establish_early_resolution, limit(2, weeks, within, expiry_of_objection_time_limit, no_extension), [cite(eu_reg_2025_2518_art_5_3)]), row(submit_early_resolution_draft_decision, limit(4, weeks, within, expiry_of_objection_time_limit, no_extension), [cite(eu_reg_2025_2518_art_5_4)]), row(notify_simple_cooperation_procedure, limit(6, weeks, within, confirmation_of_competence_or_board_binding_decision, no_extension), [cite(eu_reg_2025_2518_art_6_2)]), row(object_to_simple_cooperation_procedure, limit(2, weeks, within, notification_of_simple_cooperation_procedure, no_extension), [cite(eu_reg_2025_2518_art_6_3)]), row(provide_summary_of_key_issues, limit(3, months, within, confirmation_of_competence_or_board_binding_decision, no_extension), [cite(eu_reg_2025_2518_art_10_3)]), row(comment_on_summary_of_key_issues, limit(4, weeks, within, receipt_of_summary_of_key_issues, extension(exactly, 2, weeks)), [cite(eu_reg_2025_2518_art_10_4)]), row(respond_to_comments_on_summary_of_key_issues, limit(4, weeks, within, expiry_of_comment_period, extension(exactly, 2, weeks)), [cite(eu_reg_2025_2518_art_10_5)]), row(submit_draft_decision, limit(15, months, within, confirmation_of_competence_or_board_binding_decision, extension(up_to, 12, months)), [cite(eu_reg_2025_2518_art_12_1), cite(eu_reg_2025_2518_art_12_3)]), row(inform_of_draft_decision_extension, limit(4, weeks, at_least_before, expiry_of_draft_decision_time_limit, no_extension), [cite(eu_reg_2025_2518_art_12_3)]), row(object_to_draft_decision_extension, limit(2, weeks, within, being_informed_of_extension, no_extension), [cite(eu_reg_2025_2518_art_12_4)]), row(submit_draft_decision_in_simple_procedure, limit(12, months, within, confirmation_of_competence_or_board_binding_decision, extension(up_to, 2, months)), [cite(eu_reg_2025_2518_art_12_6)]), row(inform_of_simple_procedure_extension, limit(2, weeks, at_least_before, expiry_of_simple_procedure_time_limit, no_extension), [cite(eu_reg_2025_2518_art_12_6)])],
    length(Rows, 16),
    maplist(time_limit_row_holds, Rows).
test(an_unknown_step_is_an_input_problem) :-
    findall(Limit - Citations, procedural_time_limit([], appeal_to_court, Limit, Citations), Answers),
    Answers == [input_problems([wrong_type(step)]) - []].
test(a_malformed_profile_and_an_unknown_step_are_both_named) :-
    procedural_time_limit(not_a_profile, appeal_to_court, input_problems([wrong_type(profile), wrong_type(step)]), []).
test(chapter_ii_does_not_apply_the_day_before) :-
    findall(Result - Citations, temporal_application([], complaints_and_early_resolution, date(2027, 4, 1), Result, Citations), Answers),
    Answers == [part_does_not_apply - [cite(eu_reg_2025_2518_art_37_2)]].
test(chapter_ii_applies_on_the_day) :-
    findall(Result - Citations, temporal_application([], complaints_and_early_resolution, date(2027, 4, 2), Result, Citations), Answers),
    Answers == [part_applies - [cite(eu_reg_2025_2518_art_37_2)]].
test(chapters_iii_and_iv_do_not_apply_on_the_day) :-
    temporal_application([], cooperation_and_files, date(2027, 4, 2), part_does_not_apply, Citations),
    sort([cite(eu_reg_2025_2518_art_36), cite(eu_reg_2025_2518_art_37_2)], SortedExpected),
    sort(Citations, SortedExpected).
test(chapters_iii_and_iv_apply_the_day_after) :-
    temporal_application([], cooperation_and_files, date(2027, 4, 3), part_applies, _).
test(chapters_v_and_vi_do_not_apply_on_the_day) :-
    temporal_application([], dispute_resolution_and_urgency, date(2027, 4, 2), part_does_not_apply, _).
test(chapters_v_and_vi_apply_the_day_after) :-
    temporal_application([], dispute_resolution_and_urgency, date(2027, 4, 3), part_applies, _).
test(a_non_leap_february_29_is_an_input_problem) :-
    temporal_application([], cooperation_and_files, date(2027, 2, 29), input_problems([wrong_type(event_date)]), []).
test(a_leap_february_29_is_a_real_day) :-
    temporal_application([], cooperation_and_files, date(2028, 2, 29), part_applies, _).
test(a_century_february_29_is_an_input_problem) :-
    temporal_application([], complaints_and_early_resolution, date(1900, 2, 29), input_problems([wrong_type(event_date)]), []).
test(a_four_hundred_year_february_29_is_a_real_day) :-
    temporal_application([], complaints_and_early_resolution, date(2000, 2, 29), part_does_not_apply, _).
test(an_unknown_part_is_an_input_problem) :-
    temporal_application([], chapter_seven, date(2028, 1, 1), input_problems([wrong_type(part)]), []).

test(a_complaint_without_a_description_is_not_admissible, fail) :-
    answer_of(complaint_admissibility, inadmissible_missing_description, admissible, _).
test(an_article_80_1_complaint_without_the_mandate_is_not_admissible, fail) :-
    answer_of(complaint_admissibility, inadmissible_missing_mandate, admissible, _).
test(an_unstated_lodger_is_not_admissible, fail) :-
    answer_of(complaint_admissibility, lodger_not_stated, admissible, _).
test(an_unstated_lodger_is_not_resolvable, fail) :-
    gdpr_procedural_regulation_profile_for(lodger_not_stated, Profile),
    gdpr_procedural_regulation_decision_resolvable(Profile).
test(a_prior_request_not_made_is_not_made_is_not_made, fail) :-
    answer_of(prior_request_condition, prior_request_not_made, prior_request_made, _).
test(an_objected_resolution_is_not_established, fail) :-
    answer_of(early_resolution, early_resolution_objected, resolution_established_by_receiving_authority, _).
test(an_objected_simple_procedure_is_not_available, fail) :-
    answer_with_basis(simple_cooperation_procedure, simple_procedure_objected, simple_procedure_available, _, _).
test(an_unjustified_extension_gives_no_extension, fail) :-
    answer_with_basis(draft_decision_time_limit, draft_decision_unjustified_extension, draft_decision_limit(15, extension(up_to, 12, months)), _, _).
test(without_the_national_need_there_is_no_two_month_extension, fail) :-
    answer_with_basis(draft_decision_time_limit, simple_procedure_extension_refused_by_national_law, draft_decision_limit(12, extension(up_to, 2, months)), _, _).
test(a_late_step_under_another_provision_is_not_saved, fail) :-
    answer_with_basis(late_step_effect, late_step_under_national_law, legality_and_validity_not_affected, _, _).
test(a_document_evidence_source_statement_false_is_not_saved, fail) :-
    late_step_effect([attribute(time_limit_set_by_this_regulation_or_article_65_6, attested(false, attestation(host_user, host_time, stated_reason, document(upload_identifier, content_hash))))], legality_and_validity_not_affected, _, _).
test(a_malformed_profile_is_not_admissible, fail) :-
    answer_of(complaint_admissibility, malformed_profile_duplicates_and_unknown, admissible, _).
test(chapter_ii_on_the_day_is_not_excluded, fail) :-
    temporal_application([], complaints_and_early_resolution, date(2027, 4, 2), part_does_not_apply, _).
test(chapters_iii_and_iv_on_the_day_do_not_apply, fail) :-
    temporal_application([], cooperation_and_files, date(2027, 4, 2), part_applies, _).

cp_test_names([every_subject_answers_every_query_exactly_once, every_subject_has_a_non_empty_checklist, the_status_values_are_admissible_and_inadmissible, a_complete_data_subject_complaint_is_admissible, a_complaint_without_a_description_is_inadmissible, a_complete_article_80_1_complaint_is_admissible_with_points_b_and_c, an_article_80_1_complaint_without_the_mandate_is_inadmissible, an_article_80_2_body_needs_no_mandate, an_unstated_lodger_is_named_as_missing, a_key_admissibility_does_not_read_does_not_change_it, the_facade_assesses_an_admissible_subject, the_facade_assesses_an_inadmissible_subject, the_facade_status_of_an_unstated_lodger, the_facade_decides_like_complaint_admissibility, an_admissible_subject_is_resolvable, the_checklist_of_a_data_subject_complaint, the_checklist_marks_the_missing_description_unmet, a_prior_request_was_made, a_prior_request_was_not_made, no_prior_request_is_required, an_unsure_right_goes_to_a_lawyer, the_receiving_authority_establishes_the_resolution, the_lead_authority_submits_a_draft_decision, an_objection_in_time_stops_the_resolution, early_resolution_needs_chapter_iii_rights, an_infringement_not_ended_leaves_the_complaint_with_purpose, a_local_case_is_outside_chapter_iii, the_simple_procedure_is_available, an_objection_excludes_the_simple_procedure, a_scope_doubt_makes_the_simple_procedure_unavailable, a_scope_doubt_without_the_local_statement_is_referred, an_unsure_cooperation_need_goes_to_a_lawyer, a_document_evidence_local_case_statement_is_copied_into_basis, the_base_draft_decision_limit_is_fifteen_months, a_suspended_and_justified_extension, an_unjustified_extension_is_not_permitted, an_unsure_complexity_goes_to_a_lawyer, the_simple_procedure_limit_is_twelve_months, national_law_permits_a_two_month_extension, without_the_national_need_the_extension_is_not_permitted, an_absent_national_statement_is_referred, a_document_evidence_national_statement_refusing_the_extension, a_late_step_under_this_regulation_stays_valid, a_late_step_under_another_provision_is_not_governed, a_late_step_without_a_source_statement_is_referred, a_document_evidence_source_statement_true_keeps_the_step_valid, a_document_evidence_source_statement_false_is_not_governed, a_malformed_profile_gets_only_its_problems, a_malformed_profile_gives_basis_and_citations_empty, a_well_formed_profile_has_no_problems, a_document_evidence_outside_fact_is_well_formed, a_document_term_alone_is_not_an_outside_fact, an_attested_value_for_a_crisp_key_is_wrong_type, a_bare_value_for_an_outside_fact_is_wrong_type, a_term_that_is_not_an_attribute_list_is_wrong_type_profile, the_sixteen_time_limit_rows, an_unknown_step_is_an_input_problem, a_malformed_profile_and_an_unknown_step_are_both_named, chapter_ii_does_not_apply_the_day_before, chapter_ii_applies_on_the_day, chapters_iii_and_iv_do_not_apply_on_the_day, chapters_iii_and_iv_apply_the_day_after, chapters_v_and_vi_do_not_apply_on_the_day, chapters_v_and_vi_apply_the_day_after, a_non_leap_february_29_is_an_input_problem, a_leap_february_29_is_a_real_day, a_century_february_29_is_an_input_problem, a_four_hundred_year_february_29_is_a_real_day, an_unknown_part_is_an_input_problem]).
cp_test_fail_names([a_complaint_without_a_description_is_not_admissible, an_article_80_1_complaint_without_the_mandate_is_not_admissible, an_unstated_lodger_is_not_admissible, an_unstated_lodger_is_not_resolvable, a_prior_request_not_made_is_not_made_is_not_made, an_objected_resolution_is_not_established, an_objected_simple_procedure_is_not_available, an_unjustified_extension_gives_no_extension, without_the_national_need_there_is_no_two_month_extension, a_late_step_under_another_provision_is_not_saved, a_document_evidence_source_statement_false_is_not_saved, a_malformed_profile_is_not_admissible, chapter_ii_on_the_day_is_not_excluded, chapters_iii_and_iv_on_the_day_do_not_apply]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
