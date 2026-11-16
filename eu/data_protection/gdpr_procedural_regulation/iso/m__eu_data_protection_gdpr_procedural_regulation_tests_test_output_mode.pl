% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_procedural_regulation_tests_test_output_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_procedural_regulation_gdpr_procedural_regulation, [complaint_admissibility/3, prior_request_condition/3, early_resolution/3, simple_cooperation_procedure/4, draft_decision_time_limit/4, late_step_effect/4, procedural_time_limit/4, temporal_application/5, decide_gdpr_procedural_regulation/2]).
:- use_module(m__eu_data_protection_gdpr_procedural_regulation_fixtures, [gdpr_procedural_regulation_profile_for/2]).

admissibility_answers(Subject, Answers) :-
    gdpr_procedural_regulation_profile_for(Subject, Profile),
    findall(Result - Citations, complaint_admissibility(Profile, Result, Citations), Answers).

prior_request_answers(Subject, Answers) :-
    gdpr_procedural_regulation_profile_for(Subject, Profile),
    findall(Result - Citations, prior_request_condition(Profile, Result, Citations), Answers).

early_resolution_answers(Subject, Answers) :-
    gdpr_procedural_regulation_profile_for(Subject, Profile),
    findall(Result - Citations, early_resolution(Profile, Result, Citations), Answers).

simple_answers(Subject, Answers) :-
    gdpr_procedural_regulation_profile_for(Subject, Profile),
    findall(answer(Result, Basis, Citations), simple_cooperation_procedure(Profile, Result, Basis, Citations), Answers).

draft_answers(Subject, Answers) :-
    gdpr_procedural_regulation_profile_for(Subject, Profile),
    findall(answer(Result, Basis, Citations), draft_decision_time_limit(Profile, Result, Basis, Citations), Answers).

late_answers(Subject, Answers) :-
    gdpr_procedural_regulation_profile_for(Subject, Profile),
    findall(answer(Result, Basis, Citations), late_step_effect(Profile, Result, Basis, Citations), Answers).

test(a_data_subject_complaint_reads_out_admissible) :-
    admissibility_answers(admissible_data_subject_complaint, Answers),
    Answers == [admissible - [cite(eu_reg_2025_2518_art_4_1), cite(eu_reg_2025_2518_art_4_1_a), cite(eu_reg_2025_2518_art_4_1_d), cite(eu_reg_2025_2518_art_4_1_e), cite(eu_reg_2025_2518_art_4_5)]].
test(a_mandated_body_complaint_reads_out_admissible_with_points_b_and_c) :-
    admissibility_answers(admissible_article_80_1_complaint, Answers),
    Answers == [admissible - [cite(eu_reg_2025_2518_art_4_1), cite(eu_reg_2025_2518_art_4_1_a), cite(eu_reg_2025_2518_art_4_1_b), cite(eu_reg_2025_2518_art_4_1_c), cite(eu_reg_2025_2518_art_4_1_d), cite(eu_reg_2025_2518_art_4_1_e), cite(eu_reg_2025_2518_art_4_5)]].
test(an_independent_body_complaint_does_not_read_the_mandate) :-
    admissibility_answers(admissible_article_80_2_complaint_without_mandate_key, Answers),
    Answers == [admissible - [cite(eu_reg_2025_2518_art_4_1), cite(eu_reg_2025_2518_art_4_1_a), cite(eu_reg_2025_2518_art_4_1_b), cite(eu_reg_2025_2518_art_4_1_d), cite(eu_reg_2025_2518_art_4_1_e), cite(eu_reg_2025_2518_art_4_5)]].
test(a_missing_mandate_reads_out_inadmissible) :-
    admissibility_answers(inadmissible_missing_mandate, Answers),
    Answers == [inadmissible - [cite(eu_reg_2025_2518_art_4_1), cite(eu_reg_2025_2518_art_4_2), cite(eu_reg_2025_2518_art_4_5)]].
test(an_unstated_lodger_reads_out_indeterminate) :-
    admissibility_answers(lodger_not_stated, Answers),
    Answers == [indeterminate([complaint_lodged_by]) - []].
test(prior_request_answers_read_out) :-
    prior_request_answers(prior_request_made, Made),
    Made == [prior_request_made - [cite(eu_reg_2025_2518_art_4_3)]],
    prior_request_answers(prior_request_not_required, NotRequired),
    NotRequired == [prior_request_not_required - [cite(eu_reg_2025_2518_art_4_3)]].
test(an_unsure_right_reads_out_a_referral) :-
    prior_request_answers(prior_request_unsure, Answers),
    Answers == [needs_legal_review(open_textured(complaint_concerns_right_exercised_by_request, cite(eu_reg_2025_2518_art_4_3)), [inputs_relied_on([complaint_concerns_right_exercised_by_request - unsure])]) - []].
test(early_resolution_before_the_receiving_authority_reads_out) :-
    early_resolution_answers(early_resolution_by_receiving_authority, Answers),
    Answers == [resolution_established_by_receiving_authority - [cite(eu_reg_2025_2518_art_5_1_a), cite(eu_reg_2025_2518_art_5_2), cite(eu_reg_2025_2518_art_5_2_c), cite(eu_reg_2025_2518_art_5_3), cite(eu_reg_2025_2518_art_5_6)]].
test(early_resolution_before_the_lead_authority_reads_out) :-
    early_resolution_answers(early_resolution_by_lead_authority, Answers),
    Answers == [draft_decision_establishing_resolution - [cite(eu_reg_2025_2518_art_5_1_b), cite(eu_reg_2025_2518_art_5_2), cite(eu_reg_2025_2518_art_5_2_c), cite(eu_reg_2025_2518_art_5_4), cite(eu_reg_2025_2518_art_5_6)]].
test(early_resolution_gates_read_out) :-
    early_resolution_answers(early_resolution_outside_chapter_iii_rights, Outside),
    Outside == [early_resolution_not_available - [cite(eu_reg_2025_2518_art_5_1)]],
    early_resolution_answers(early_resolution_infringement_not_ended, NotEnded),
    NotEnded == [complaint_not_devoid_of_purpose - [cite(eu_reg_2025_2518_art_5_2)]].
test(a_local_case_reads_out_with_its_basis) :-
    simple_answers(local_case_under_article_56_2, Answers),
    Answers == [answer(chapter_iii_not_applicable, [outside_fact(case_handled_under_article_56_2, attested(true, attestation(supervisory_authority_officer, attested_at, reason_stated, none)))], [cite(eu_reg_2025_2518_art_6_5)])].
test(an_available_simple_procedure_reads_out_with_its_basis) :-
    simple_answers(simple_procedure_available, Answers),
    Answers == [answer(simple_procedure_available, [outside_fact(case_handled_under_article_56_2, attested(false, attestation(supervisory_authority_officer, attested_at, reason_stated, none)))], [cite(eu_reg_2025_2518_art_6_1), cite(eu_reg_2025_2518_art_6_1_a), cite(eu_reg_2025_2518_art_6_1_b), cite(eu_reg_2025_2518_art_6_3)])].
test(a_scope_doubt_reads_out_not_available) :-
    simple_answers(simple_procedure_scope_doubt, Answers),
    Answers == [answer(simple_procedure_not_available, [outside_fact(case_handled_under_article_56_2, attested(false, attestation(supervisory_authority_officer, attested_at, reason_stated, none)))], [cite(eu_reg_2025_2518_art_6_1), cite(eu_reg_2025_2518_art_6_1_a), cite(eu_reg_2025_2518_art_6_1_b)])].
test(a_scope_doubt_without_a_local_statement_reads_out_the_absent_referral) :-
    simple_answers(simple_procedure_scope_doubt_without_local_statement, Answers),
    Answers == [answer(needs_legal_review(cross_reference_unresolved(cite(eu_reg_2025_2518_art_6_5), cite(article_56_2_local_case_statement)), [resolution(cite(article_56_2_local_case_statement), not_attempted), inputs_relied_on([case_handled_under_article_56_2 - absent])]), [], [])].
test(an_unsure_cooperation_need_reads_out_a_referral) :-
    simple_answers(simple_procedure_cooperation_unsure, Answers),
    Answers == [answer(needs_legal_review(open_textured(issues_addressable_without_additional_cooperation, cite(eu_reg_2025_2518_art_6_1_b)), [inputs_relied_on([issues_addressable_without_additional_cooperation - unsure])]), [], [])].
test(a_suspended_and_justified_extension_reads_out) :-
    draft_answers(draft_decision_suspended_and_extended, Answers),
    Answers == [answer(draft_decision_limit(15, extension(up_to, 12, months)), [suspended_until_board_binding_decision], [cite(eu_reg_2025_2518_art_12_1), cite(eu_reg_2025_2518_art_12_2), cite(eu_reg_2025_2518_art_12_3)])].
test(an_unjustified_extension_reads_out_not_permitted) :-
    draft_answers(draft_decision_unjustified_extension, Answers),
    Answers == [answer(draft_decision_limit(15, no_extension), [extension_not_permitted], [cite(eu_reg_2025_2518_art_12_1), cite(eu_reg_2025_2518_art_12_3)])].
test(an_unsure_complexity_reads_out_a_referral) :-
    draft_answers(draft_decision_complexity_unsure, Answers),
    Answers == [answer(needs_legal_review(open_textured(extension_justified_by_exceptional_complexity, cite(eu_reg_2025_2518_art_12_3)), [inputs_relied_on([extension_justified_by_exceptional_complexity - unsure])]), [], [])].
test(the_simple_procedure_limit_reads_out) :-
    draft_answers(simple_procedure_draft_decision_without_extension, Answers),
    Answers == [answer(draft_decision_limit(12, no_extension), [], [cite(eu_reg_2025_2518_art_6_1), cite(eu_reg_2025_2518_art_12_6)])].
test(a_refused_national_extension_reads_out_with_its_basis) :-
    draft_answers(simple_procedure_extension_refused_by_national_law, Answers),
    Answers == [answer(draft_decision_limit(12, no_extension), [extension_not_permitted, outside_fact(national_law_requires_domestic_proceedings_after_time_limit, attested(false, attestation(supervisory_authority_officer, attested_at, reason_stated, none)))], [cite(eu_reg_2025_2518_art_6_1), cite(eu_reg_2025_2518_art_12_6)])].
test(a_missing_national_statement_reads_out_the_absent_referral) :-
    draft_answers(simple_procedure_extension_without_national_statement, Answers),
    Answers == [answer(needs_legal_review(cross_reference_unresolved(cite(eu_reg_2025_2518_art_12_6), cite(national_domestic_proceedings_statement)), [resolution(cite(national_domestic_proceedings_statement), not_attempted), inputs_relied_on([national_law_requires_domestic_proceedings_after_time_limit - absent])]), [], [])].
test(a_late_step_under_this_regulation_reads_out) :-
    late_answers(late_step_under_this_regulation, Answers),
    Answers == [answer(legality_and_validity_not_affected, [outside_fact(time_limit_set_by_this_regulation_or_article_65_6, attested(true, attestation(supervisory_authority_officer, attested_at, reason_stated, none)))], [cite(eu_reg_2025_2518_art_14)])].
test(a_late_step_without_a_statement_reads_out_the_absent_referral) :-
    late_answers(late_step_without_source_statement, Answers),
    Answers == [answer(needs_legal_review(cross_reference_unresolved(cite(eu_reg_2025_2518_art_14), cite(time_limit_source_statement)), [resolution(cite(time_limit_source_statement), not_attempted), inputs_relied_on([time_limit_set_by_this_regulation_or_article_65_6 - absent])]), [], [])].
test(the_simple_procedure_draft_decision_row_reads_out) :-
    findall(Limit - Citations, procedural_time_limit([], submit_draft_decision_in_simple_procedure, Limit, Citations), Answers),
    Answers == [limit(12, months, within, confirmation_of_competence_or_board_binding_decision, extension(up_to, 2, months)) - [cite(eu_reg_2025_2518_art_12_6)]].
test(the_comment_period_row_reads_out_an_exact_extension) :-
    findall(Limit - Citations, procedural_time_limit([], comment_on_summary_of_key_issues, Limit, Citations), Answers),
    Answers == [limit(4, weeks, within, receipt_of_summary_of_key_issues, extension(exactly, 2, weeks)) - [cite(eu_reg_2025_2518_art_10_4)]].
test(the_inform_row_reads_out_at_least_before) :-
    findall(Limit, procedural_time_limit([], inform_of_draft_decision_extension, Limit, _), Answers),
    Answers == [limit(4, weeks, at_least_before, expiry_of_draft_decision_time_limit, no_extension)].
test(chapter_two_boundary_reads_out) :-
    findall(Result, temporal_application([], complaints_and_early_resolution, date(2027, 4, 1), Result, _), Before),
    Before == [part_does_not_apply],
    findall(Result, temporal_application([], complaints_and_early_resolution, date(2027, 4, 2), Result, _), OnTheDay),
    OnTheDay == [part_applies].
test(chapters_three_to_six_boundary_reads_out) :-
    findall(Result, temporal_application([], cooperation_and_files, date(2027, 4, 2), Result, _), OnTheDay),
    OnTheDay == [part_does_not_apply],
    findall(Result, temporal_application([], cooperation_and_files, date(2027, 4, 3), Result, _), DayAfter),
    DayAfter == [part_applies].
test(the_facade_verdict_carries_the_admissibility_citations) :-
    gdpr_procedural_regulation_profile_for(inadmissible_missing_description, Profile),
    findall(Verdict, decide_gdpr_procedural_regulation(Profile, Verdict), Verdicts),
    Verdicts == [gdpr_procedural_regulation_verdict(inadmissible, [cite(eu_reg_2025_2518_art_4_1), cite(eu_reg_2025_2518_art_4_2), cite(eu_reg_2025_2518_art_4_5)])].

cp_test_names([a_data_subject_complaint_reads_out_admissible, a_mandated_body_complaint_reads_out_admissible_with_points_b_and_c, an_independent_body_complaint_does_not_read_the_mandate, a_missing_mandate_reads_out_inadmissible, an_unstated_lodger_reads_out_indeterminate, prior_request_answers_read_out, an_unsure_right_reads_out_a_referral, early_resolution_before_the_receiving_authority_reads_out, early_resolution_before_the_lead_authority_reads_out, early_resolution_gates_read_out, a_local_case_reads_out_with_its_basis, an_available_simple_procedure_reads_out_with_its_basis, a_scope_doubt_reads_out_not_available, a_scope_doubt_without_a_local_statement_reads_out_the_absent_referral, an_unsure_cooperation_need_reads_out_a_referral, a_suspended_and_justified_extension_reads_out, an_unjustified_extension_reads_out_not_permitted, an_unsure_complexity_reads_out_a_referral, the_simple_procedure_limit_reads_out, a_refused_national_extension_reads_out_with_its_basis, a_missing_national_statement_reads_out_the_absent_referral, a_late_step_under_this_regulation_reads_out, a_late_step_without_a_statement_reads_out_the_absent_referral, the_simple_procedure_draft_decision_row_reads_out, the_comment_period_row_reads_out_an_exact_extension, the_inform_row_reads_out_at_least_before, chapter_two_boundary_reads_out, chapters_three_to_six_boundary_reads_out, the_facade_verdict_carries_the_admissibility_citations]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
