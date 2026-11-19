% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_procedural_regulation_tests_test_public_interface, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_lists_extra, [clausal_is_list/1, clausal_msort/2]).
:- use_module(m__eu_data_protection_gdpr_procedural_regulation_gdpr_procedural_regulation, [complaint_admissibility/3, prior_request_condition/3, early_resolution/3, simple_cooperation_procedure/4, draft_decision_time_limit/4, late_step_effect/4, procedural_time_limit/4, temporal_application/5, decide_gdpr_procedural_regulation/2, gdpr_procedural_regulation_status/2, gdpr_procedural_regulation_checklist/2, gdpr_procedural_regulation_decision_resolvable/1, gdpr_procedural_regulation_status_values/1]).
:- use_module(m__eu_data_protection_gdpr_procedural_regulation_fixtures, [gdpr_procedural_regulation_subject/1, gdpr_procedural_regulation_profile_for/2]).

fixture(Subject, Profile) :-
    gdpr_procedural_regulation_profile_for(Subject, Profile).

baseline_profile(Profile) :-
    gdpr_procedural_regulation_profile_for(todo_baseline_subject, Profile).

query_result(admissibility, Profile, Result) :-
    complaint_admissibility(Profile, Result, _).
query_result(prior_request, Profile, Result) :-
    prior_request_condition(Profile, Result, _).
query_result(early, Profile, Result) :-
    early_resolution(Profile, Result, _).
query_result(simple, Profile, Result) :-
    simple_cooperation_procedure(Profile, Result, _, _).
query_result(draft, Profile, Result) :-
    draft_decision_time_limit(Profile, Result, _, _).
query_result(late, Profile, Result) :-
    late_step_effect(Profile, Result, _, _).

query_kind(admissibility).
query_kind(prior_request).
query_kind(early).
query_kind(simple).
query_kind(draft).
query_kind(late).

expected(admissible_data_subject_complaint, admissibility, admissible).
expected(data_subject_complaint_without_description, admissibility, inadmissible).
expected(admissible_article_80_1_body_complaint, admissibility, admissible).
expected(article_80_1_body_complaint_without_mandate, admissibility, inadmissible).
expected(admissible_article_80_2_body_complaint, admissibility, admissible).
expected(article_80_2_body_complaint_without_constitution, admissibility, inadmissible).
expected(complaint_without_lodger, admissibility, indeterminate([complaint_lodged_by])).
expected(malformed_profile_case, admissibility, input_problems([duplicate_key(complaint_lodged_by), unknown_key(complaint_reference)])).
expected(prior_request_made_complaint, prior_request, prior_request_made).
expected(prior_request_not_made_complaint, prior_request, prior_request_not_made).
expected(right_not_exercised_by_request_complaint, prior_request, prior_request_not_required).
expected(right_exercised_by_request_unclear_complaint, prior_request, needs_legal_review(open_textured(complaint_concerns_right_exercised_by_request, cite(eu_reg_2025_2518_art_4_3)), [inputs_relied_on([complaint_concerns_right_exercised_by_request - unsure])])).
expected(complaint_outside_chapter_iii_rights, early, early_resolution_not_available).
expected(complaint_not_devoid_of_purpose_case, early, complaint_not_devoid_of_purpose).
expected(early_resolution_objected_case, early, early_resolution_objected).
expected(early_resolution_before_receiving_authority, early, resolution_established_by_receiving_authority).
expected(early_resolution_before_lead_authority, early, draft_decision_establishing_resolution).
expected(local_case_under_article_56_2, simple, chapter_iii_not_applicable).
expected(scope_in_doubt_case, simple, simple_procedure_not_available).
expected(simple_procedure_objected_case, simple, simple_procedure_excluded_by_objection).
expected(simple_procedure_open_case, simple, simple_procedure_available).
expected(additional_cooperation_need_unclear_case, simple, needs_legal_review(open_textured(issues_addressable_without_additional_cooperation, cite(eu_reg_2025_2518_art_6_1_b)), [inputs_relied_on([issues_addressable_without_additional_cooperation - unsure])])).
expected(local_case_statement_missing_case, simple, needs_legal_review(cross_reference_unresolved(cite(eu_reg_2025_2518_art_6_5), cite(article_56_2_local_case_statement)), [resolution(cite(article_56_2_local_case_statement), not_attempted), inputs_relied_on([case_handled_under_article_56_2 - absent])])).
expected(standard_draft_decision_case, draft, draft_decision_limit(15, no_extension)).
expected(justified_extension_case, draft, draft_decision_limit(15, extension(up_to, 12, months))).
expected(unjustified_extension_with_board_request_case, draft, draft_decision_limit(15, no_extension)).
expected(extension_complexity_unclear_case, draft, needs_legal_review(open_textured(extension_justified_by_exceptional_complexity, cite(eu_reg_2025_2518_art_12_3)), [inputs_relied_on([extension_justified_by_exceptional_complexity - unsure])])).
expected(simple_procedure_draft_decision_case, draft, draft_decision_limit(12, no_extension)).
expected(simple_procedure_justified_extension_case, draft, draft_decision_limit(12, extension(up_to, 2, months))).
expected(simple_procedure_unjustified_extension_case, draft, draft_decision_limit(12, no_extension)).
expected(national_law_statement_missing_case, draft, needs_legal_review(cross_reference_unresolved(cite(eu_reg_2025_2518_art_12_6), cite(national_domestic_proceedings_statement)), [resolution(cite(national_domestic_proceedings_statement), not_attempted), inputs_relied_on([national_law_requires_domestic_proceedings_after_time_limit - absent])])).
expected(late_step_after_regulation_time_limit, late, legality_and_validity_not_affected).
expected(late_step_after_other_time_limit, late, not_governed_by_article_14).
expected(late_step_statement_missing_case, late, needs_legal_review(cross_reference_unresolved(cite(eu_reg_2025_2518_art_14), cite(time_limit_source_statement)), [resolution(cite(time_limit_source_statement), not_attempted), inputs_relied_on([time_limit_set_by_this_regulation_or_article_65_6 - absent])])).

all_subjects(SubjectSet) :-
    findall(Subject, gdpr_procedural_regulation_subject(Subject), Subjects),
    sort(Subjects, SubjectSet).

subject_meets_expectation(Subject) :-
    expected(Subject, Query, Expected),
    fixture(Subject, Profile),
    findall(Result, query_result(Query, Profile, Result), Results),
    Results == [Expected].

step_atom(declare_complaint_inadmissible).
step_atom(transmit_complaint_to_presumed_lead_authority).
step_atom(confirm_competence_or_refer_to_board).
step_atom(object_to_early_resolution).
step_atom(establish_early_resolution).
step_atom(submit_early_resolution_draft_decision).
step_atom(notify_simple_cooperation_procedure).
step_atom(object_to_simple_cooperation_procedure).
step_atom(provide_summary_of_key_issues).
step_atom(comment_on_summary_of_key_issues).
step_atom(respond_to_comments_on_summary_of_key_issues).
step_atom(submit_draft_decision).
step_atom(inform_of_draft_decision_extension).
step_atom(object_to_draft_decision_extension).
step_atom(submit_draft_decision_in_simple_procedure).
step_atom(inform_of_simple_procedure_extension).

test(every_subject_has_a_profile) :-
    all_subjects(SubjectSet),
    findall(Subject, (gdpr_procedural_regulation_subject(Subject), fixture(Subject, Profile), clausal_is_list(Profile)), WithProfiles),
    sort(WithProfiles, SubjectSet).
test(every_subject_has_an_expectation) :-
    all_subjects(SubjectSet),
    findall(Subject, expected(Subject, _, _), ExpectedSubjects),
    clausal_msort(ExpectedSubjects, SortedExpected),
    SortedExpected == SubjectSet.
test(every_fixture_gets_its_expected_result) :-
    all_subjects(SubjectSet),
    findall(Subject, subject_meets_expectation(Subject), Passed),
    sort(Passed, SubjectSet).
test(every_query_answers_once_on_every_fixture) :-
    findall(Count, (gdpr_procedural_regulation_subject(Subject), fixture(Subject, Profile), query_kind(Query), findall(Result, query_result(Query, Profile, Result), Results), length(Results, Count)), Counts),
    length(Counts, 204),
    sort(Counts, [1]).
test(checklist_is_non_empty_on_every_fixture) :-
    all_subjects(SubjectSet),
    findall(Subject, (gdpr_procedural_regulation_subject(Subject), fixture(Subject, Profile), gdpr_procedural_regulation_checklist(Profile, [_|_])), WithChecklists),
    sort(WithChecklists, SubjectSet).
test(decision_resolvable_on_every_fixture) :-
    all_subjects(SubjectSet),
    findall(Subject, (gdpr_procedural_regulation_subject(Subject), fixture(Subject, Profile), gdpr_procedural_regulation_decision_resolvable(Profile)), Resolvable),
    sort(Resolvable, SubjectSet).
test(every_step_has_one_limit) :-
    findall(Count, (step_atom(Step), findall(Limit, procedural_time_limit([], Step, Limit, _), Limits), length(Limits, Count)), Counts),
    length(Counts, 16),
    sort(Counts, [1]).
test(the_baseline_profile_is_admissible) :-
    baseline_profile(Profile),
    gdpr_procedural_regulation_status(Profile, admissible).
test(the_status_values_are_the_two_verdicts) :-
    gdpr_procedural_regulation_status_values(StatusValues),
    StatusValues == [admissible, inadmissible].
test(the_baseline_profile_yields_exactly_one_status) :-
    baseline_profile(Profile),
    findall(Status, gdpr_procedural_regulation_status(Profile, Status), Statuses),
    Statuses == [admissible].
test(facade_article_80_1_body_cites_points_b_and_c) :-
    fixture(admissible_article_80_1_body_complaint, Profile),
    decide_gdpr_procedural_regulation(Profile, gdpr_procedural_regulation_verdict(admissible, Citations)),
    member(cite(eu_reg_2025_2518_art_4_1_b), Citations),
    member(cite(eu_reg_2025_2518_art_4_1_c), Citations).
test(early_resolution_before_receiving_authority_citations) :-
    fixture(early_resolution_before_receiving_authority, Profile),
    early_resolution(Profile, resolution_established_by_receiving_authority, Citations),
    Citations == [cite(eu_reg_2025_2518_art_5_1_a), cite(eu_reg_2025_2518_art_5_2), cite(eu_reg_2025_2518_art_5_2_c), cite(eu_reg_2025_2518_art_5_3), cite(eu_reg_2025_2518_art_5_6)].
test(early_resolution_objection_decides_before_authority) :-
    fixture(early_resolution_objected_case, Profile),
    findall(Result, early_resolution(Profile, Result, _), Results),
    Results == [early_resolution_objected].
test(draft_standard_limit_basis_and_citations) :-
    fixture(standard_draft_decision_case, Profile),
    draft_decision_time_limit(Profile, draft_decision_limit(15, no_extension), Basis, Citations),
    Basis == [],
    Citations == [cite(eu_reg_2025_2518_art_12_1)].
test(draft_justified_extension_citations) :-
    fixture(justified_extension_case, Profile),
    draft_decision_time_limit(Profile, draft_decision_limit(15, extension(up_to, 12, months)), [], Citations),
    Citations == [cite(eu_reg_2025_2518_art_12_1), cite(eu_reg_2025_2518_art_12_3)].
test(draft_unjustified_extension_with_suspension_basis) :-
    fixture(unjustified_extension_with_board_request_case, Profile),
    draft_decision_time_limit(Profile, draft_decision_limit(15, no_extension), Basis, _),
    Basis == [suspended_until_board_binding_decision, extension_not_permitted].
test(draft_simple_procedure_limit) :-
    fixture(simple_procedure_draft_decision_case, Profile),
    draft_decision_time_limit(Profile, draft_decision_limit(12, no_extension), [], Citations),
    Citations == [cite(eu_reg_2025_2518_art_6_1), cite(eu_reg_2025_2518_art_12_6)].
test(draft_simple_procedure_justified_extension_basis) :-
    fixture(simple_procedure_justified_extension_case, Profile),
    member(attribute(national_law_requires_domestic_proceedings_after_time_limit, Attested), Profile),
    draft_decision_time_limit(Profile, draft_decision_limit(12, extension(up_to, 2, months)), Basis, _),
    Basis == [outside_fact(national_law_requires_domestic_proceedings_after_time_limit, Attested)].
test(draft_simple_procedure_unjustified_extension_basis) :-
    fixture(simple_procedure_unjustified_extension_case, Profile),
    member(attribute(national_law_requires_domestic_proceedings_after_time_limit, Attested), Profile),
    draft_decision_time_limit(Profile, draft_decision_limit(12, no_extension), Basis, _),
    Basis == [extension_not_permitted, outside_fact(national_law_requires_domestic_proceedings_after_time_limit, Attested)].
test(temporal_application_on_the_day_for_chapter_ii) :-
    findall(Result, temporal_application([], complaints_and_early_resolution, date(2027, 4, 2), Result, _), Results),
    Results == [part_applies].
test(a_number_key_blocks_the_admissibility_query) :-
    findall(Result - Citations, complaint_admissibility([attribute(42, true)], Result, Citations), Answers),
    Answers == [input_problems([unknown_key(42)]) - []].

test(every_other_bound_status_is_rejected, fail) :-
    baseline_profile(Profile),
    gdpr_procedural_regulation_status(Profile, inadmissible).
test(facade_data_subject_does_not_cite_point_c, fail) :-
    fixture(admissible_data_subject_complaint, Profile),
    decide_gdpr_procedural_regulation(Profile, gdpr_procedural_regulation_verdict(_, Citations)),
    member(cite(eu_reg_2025_2518_art_4_1_c), Citations).
test(early_resolution_lead_authority_is_not_receiving_authority, fail) :-
    fixture(early_resolution_before_lead_authority, Profile),
    early_resolution(Profile, resolution_established_by_receiving_authority, _).
test(early_resolution_objected_is_not_resolved, fail) :-
    fixture(early_resolution_objected_case, Profile),
    early_resolution(Profile, resolution_established_by_receiving_authority, _).
test(draft_near_miss_unjustified_extension_is_not_extended, fail) :-
    fixture(unjustified_extension_with_board_request_case, Profile),
    draft_decision_time_limit(Profile, draft_decision_limit(15, extension(_, _, _)), _, _).
test(draft_near_miss_simple_unjustified_is_not_extended, fail) :-
    fixture(simple_procedure_unjustified_extension_case, Profile),
    draft_decision_time_limit(Profile, draft_decision_limit(12, extension(_, _, _)), _, _).
test(temporal_application_on_the_day_for_chapter_iii_is_not_applied, fail) :-
    temporal_application([], cooperation_and_files, date(2027, 4, 2), part_applies, _).

cp_test_names([every_subject_has_a_profile, every_subject_has_an_expectation, every_fixture_gets_its_expected_result, every_query_answers_once_on_every_fixture, checklist_is_non_empty_on_every_fixture, decision_resolvable_on_every_fixture, every_step_has_one_limit, the_baseline_profile_is_admissible, the_status_values_are_the_two_verdicts, the_baseline_profile_yields_exactly_one_status, facade_article_80_1_body_cites_points_b_and_c, early_resolution_before_receiving_authority_citations, early_resolution_objection_decides_before_authority, draft_standard_limit_basis_and_citations, draft_justified_extension_citations, draft_unjustified_extension_with_suspension_basis, draft_simple_procedure_limit, draft_simple_procedure_justified_extension_basis, draft_simple_procedure_unjustified_extension_basis, temporal_application_on_the_day_for_chapter_ii, a_number_key_blocks_the_admissibility_query]).
cp_test_fail_names([every_other_bound_status_is_rejected, facade_data_subject_does_not_cite_point_c, early_resolution_lead_authority_is_not_receiving_authority, early_resolution_objected_is_not_resolved, draft_near_miss_unjustified_extension_is_not_extended, draft_near_miss_simple_unjustified_is_not_extended, temporal_application_on_the_day_for_chapter_iii_is_not_applied]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
