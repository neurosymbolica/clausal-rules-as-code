% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_procedural_regulation_tests_test_negative_controls, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_procedural_regulation_gdpr_procedural_regulation, [complaint_admissibility/3, prior_request_condition/3, early_resolution/3, simple_cooperation_procedure/4, draft_decision_time_limit/4, late_step_effect/4, procedural_time_limit/4, temporal_application/5, gdpr_procedural_regulation_status_values/1]).
:- use_module(m__eu_data_protection_gdpr_procedural_regulation_fixtures, [gdpr_procedural_regulation_profile_for/2]).

test(the_status_table_holds_both_verdicts) :-
    gdpr_procedural_regulation_status_values(StatusValues),
    StatusValues == [admissible, inadmissible].
test(admissibility_positive) :-
    gdpr_procedural_regulation_profile_for(admissible_data_subject_complaint, Profile),
    complaint_admissibility(Profile, admissible, _).
test(admissibility_near_miss_is_inadmissible) :-
    gdpr_procedural_regulation_profile_for(inadmissible_missing_description, Profile),
    complaint_admissibility(Profile, inadmissible, _).
test(mandate_positive) :-
    gdpr_procedural_regulation_profile_for(admissible_article_80_1_complaint, Profile),
    complaint_admissibility(Profile, admissible, _).
test(mandate_near_miss_is_inadmissible) :-
    gdpr_procedural_regulation_profile_for(inadmissible_missing_mandate, Profile),
    complaint_admissibility(Profile, inadmissible, _).
test(lodger_near_miss_is_indeterminate) :-
    gdpr_procedural_regulation_profile_for(lodger_not_stated, Profile),
    complaint_admissibility(Profile, indeterminate([complaint_lodged_by]), []).
test(prior_request_positive) :-
    gdpr_procedural_regulation_profile_for(prior_request_made, Profile),
    prior_request_condition(Profile, prior_request_made, _).
test(prior_request_near_miss_is_not_made) :-
    gdpr_procedural_regulation_profile_for(prior_request_not_made, Profile),
    prior_request_condition(Profile, prior_request_not_made, _).
test(prior_request_not_required_when_no_request_right) :-
    gdpr_procedural_regulation_profile_for(prior_request_not_required, Profile),
    prior_request_condition(Profile, prior_request_not_required, _).
test(early_resolution_positive) :-
    gdpr_procedural_regulation_profile_for(early_resolution_by_receiving_authority, Profile),
    early_resolution(Profile, resolution_established_by_receiving_authority, _).
test(early_resolution_near_miss_is_objected) :-
    gdpr_procedural_regulation_profile_for(early_resolution_objected, Profile),
    early_resolution(Profile, early_resolution_objected, _).
test(early_resolution_lead_authority_positive) :-
    gdpr_procedural_regulation_profile_for(early_resolution_by_lead_authority, Profile),
    early_resolution(Profile, draft_decision_establishing_resolution, _).
test(early_resolution_outside_chapter_iii_is_not_available) :-
    gdpr_procedural_regulation_profile_for(early_resolution_outside_chapter_iii_rights, Profile),
    early_resolution(Profile, early_resolution_not_available, _).
test(early_resolution_infringement_not_ended_is_not_devoid) :-
    gdpr_procedural_regulation_profile_for(early_resolution_infringement_not_ended, Profile),
    early_resolution(Profile, complaint_not_devoid_of_purpose, _).
test(simple_procedure_positive) :-
    gdpr_procedural_regulation_profile_for(simple_procedure_available, Profile),
    simple_cooperation_procedure(Profile, simple_procedure_available, _, _).
test(simple_procedure_objection_near_miss) :-
    gdpr_procedural_regulation_profile_for(simple_procedure_objected, Profile),
    simple_cooperation_procedure(Profile, simple_procedure_excluded_by_objection, _, _).
test(simple_procedure_scope_near_miss) :-
    gdpr_procedural_regulation_profile_for(simple_procedure_scope_doubt, Profile),
    simple_cooperation_procedure(Profile, simple_procedure_not_available, _, _).
test(simple_procedure_local_case_near_miss) :-
    gdpr_procedural_regulation_profile_for(local_case_under_article_56_2, Profile),
    simple_cooperation_procedure(Profile, chapter_iii_not_applicable, _, _).
test(simple_procedure_without_local_statement_is_referred) :-
    gdpr_procedural_regulation_profile_for(simple_procedure_scope_doubt_without_local_statement, Profile),
    simple_cooperation_procedure(Profile, needs_legal_review(cross_reference_unresolved(_, _), _), [], []).
test(draft_extension_positive) :-
    gdpr_procedural_regulation_profile_for(draft_decision_suspended_and_extended, Profile),
    draft_decision_time_limit(Profile, draft_decision_limit(15, extension(up_to, 12, months)), _, _).
test(draft_extension_near_miss_is_not_permitted) :-
    gdpr_procedural_regulation_profile_for(draft_decision_unjustified_extension, Profile),
    draft_decision_time_limit(Profile, draft_decision_limit(15, no_extension), [extension_not_permitted], _).
test(draft_base_limit_positive) :-
    gdpr_procedural_regulation_profile_for(draft_decision_base_limit, Profile),
    draft_decision_time_limit(Profile, draft_decision_limit(15, no_extension), [], _).
test(simple_draft_extension_positive) :-
    gdpr_procedural_regulation_profile_for(simple_procedure_extension_with_national_statement, Profile),
    draft_decision_time_limit(Profile, draft_decision_limit(12, extension(up_to, 2, months)), _, _).
test(simple_draft_extension_near_miss) :-
    gdpr_procedural_regulation_profile_for(simple_procedure_extension_refused_by_national_law, Profile),
    draft_decision_time_limit(Profile, draft_decision_limit(12, no_extension), [extension_not_permitted|_], _).
test(draft_unsure_complexity_is_referred) :-
    gdpr_procedural_regulation_profile_for(draft_decision_complexity_unsure, Profile),
    draft_decision_time_limit(Profile, needs_legal_review(open_textured(extension_justified_by_exceptional_complexity, _), _), [], []).
test(late_step_positive) :-
    gdpr_procedural_regulation_profile_for(late_step_under_this_regulation, Profile),
    late_step_effect(Profile, legality_and_validity_not_affected, _, _).
test(late_step_near_miss) :-
    gdpr_procedural_regulation_profile_for(late_step_under_national_law, Profile),
    late_step_effect(Profile, not_governed_by_article_14, _, _).
test(time_limit_positive) :-
    procedural_time_limit([], submit_draft_decision, limit(15, months, within, _, _), _).
test(time_limit_near_miss_simple_procedure) :-
    procedural_time_limit([], submit_draft_decision_in_simple_procedure, limit(12, months, within, _, _), _).
test(temporal_chapter_two_positive_on_the_day) :-
    temporal_application([], complaints_and_early_resolution, date(2027, 4, 2), part_applies, _).
test(temporal_chapter_two_near_miss_the_day_before) :-
    temporal_application([], complaints_and_early_resolution, date(2027, 4, 1), part_does_not_apply, _).
test(temporal_chapter_three_positive_the_day_after) :-
    temporal_application([], cooperation_and_files, date(2027, 4, 3), part_applies, _).
test(temporal_chapter_three_near_miss_on_the_day) :-
    temporal_application([], cooperation_and_files, date(2027, 4, 2), part_does_not_apply, _).
test(input_check_malformed_profile_gets_input_problems) :-
    gdpr_procedural_regulation_profile_for(malformed_profile_duplicates_and_unknown, Profile),
    complaint_admissibility(Profile, input_problems([_|_]), []).

test(admissibility_near_miss_is_not_admissible, fail) :-
    gdpr_procedural_regulation_profile_for(inadmissible_missing_description, Profile),
    complaint_admissibility(Profile, admissible, _).
test(mandate_near_miss_is_not_admissible, fail) :-
    gdpr_procedural_regulation_profile_for(inadmissible_missing_mandate, Profile),
    complaint_admissibility(Profile, admissible, _).
test(lodger_near_miss_is_not_admissible, fail) :-
    gdpr_procedural_regulation_profile_for(lodger_not_stated, Profile),
    complaint_admissibility(Profile, admissible, _).
test(prior_request_near_miss_is_not_made_not_made, fail) :-
    gdpr_procedural_regulation_profile_for(prior_request_not_made, Profile),
    prior_request_condition(Profile, prior_request_made, _).
test(prior_request_unsure_is_not_decided, fail) :-
    gdpr_procedural_regulation_profile_for(prior_request_unsure, Profile),
    prior_request_condition(Profile, prior_request_not_made, _).
test(early_resolution_near_miss_is_not_resolved, fail) :-
    gdpr_procedural_regulation_profile_for(early_resolution_objected, Profile),
    early_resolution(Profile, resolution_established_by_receiving_authority, _).
test(early_resolution_conductor_flips_the_result, fail) :-
    gdpr_procedural_regulation_profile_for(early_resolution_by_lead_authority, Profile),
    early_resolution(Profile, resolution_established_by_receiving_authority, _).
test(simple_procedure_objection_near_miss_is_not_available, fail) :-
    gdpr_procedural_regulation_profile_for(simple_procedure_objected, Profile),
    simple_cooperation_procedure(Profile, simple_procedure_available, _, _).
test(simple_procedure_scope_near_miss_is_not_available, fail) :-
    gdpr_procedural_regulation_profile_for(simple_procedure_scope_doubt, Profile),
    simple_cooperation_procedure(Profile, simple_procedure_available, _, _).
test(simple_procedure_local_case_is_not_available, fail) :-
    gdpr_procedural_regulation_profile_for(local_case_under_article_56_2, Profile),
    simple_cooperation_procedure(Profile, simple_procedure_available, _, _).
test(simple_procedure_without_local_statement_is_not_decided, fail) :-
    gdpr_procedural_regulation_profile_for(simple_procedure_scope_doubt_without_local_statement, Profile),
    simple_cooperation_procedure(Profile, simple_procedure_not_available, _, _).
test(draft_extension_near_miss_has_no_extension, fail) :-
    gdpr_procedural_regulation_profile_for(draft_decision_unjustified_extension, Profile),
    draft_decision_time_limit(Profile, draft_decision_limit(_, extension(_, _, _)), _, _).
test(draft_suspension_is_reported_only_with_a_board_request, fail) :-
    gdpr_procedural_regulation_profile_for(draft_decision_base_limit, Profile),
    draft_decision_time_limit(Profile, _, [suspended_until_board_binding_decision|_], _).
test(simple_draft_extension_near_miss_has_no_extension, fail) :-
    gdpr_procedural_regulation_profile_for(simple_procedure_extension_refused_by_national_law, Profile),
    draft_decision_time_limit(Profile, draft_decision_limit(_, extension(_, _, _)), _, _).
test(draft_unsure_complexity_is_not_decided, fail) :-
    gdpr_procedural_regulation_profile_for(draft_decision_complexity_unsure, Profile),
    draft_decision_time_limit(Profile, draft_decision_limit(_, _), _, _).
test(late_step_near_miss_is_not_protected, fail) :-
    gdpr_procedural_regulation_profile_for(late_step_under_national_law, Profile),
    late_step_effect(Profile, legality_and_validity_not_affected, _, _).
test(late_step_without_statement_is_not_decided, fail) :-
    gdpr_procedural_regulation_profile_for(late_step_without_source_statement, Profile),
    late_step_effect(Profile, legality_and_validity_not_affected, _, _).
test(time_limit_near_miss_is_not_fifteen_months, fail) :-
    procedural_time_limit([], submit_draft_decision_in_simple_procedure, limit(15, _, _, _, _), _).
test(time_limit_unknown_step_gets_no_limit, fail) :-
    procedural_time_limit([], file_appeal, limit(_, _, _, _, _), _).
test(temporal_chapter_two_the_day_before_does_not_apply, fail) :-
    temporal_application([], complaints_and_early_resolution, date(2027, 4, 1), part_applies, _).
test(temporal_chapter_three_on_the_day_does_not_apply, fail) :-
    temporal_application([], cooperation_and_files, date(2027, 4, 2), part_applies, _).
test(temporal_chapter_five_on_the_day_does_not_apply, fail) :-
    temporal_application([], dispute_resolution_and_urgency, date(2027, 4, 2), part_applies, _).
test(input_check_malformed_profile_gets_no_verdict, fail) :-
    gdpr_procedural_regulation_profile_for(malformed_profile_duplicates_and_unknown, Profile),
    complaint_admissibility(Profile, admissible, _).

cp_test_names([the_status_table_holds_both_verdicts, admissibility_positive, admissibility_near_miss_is_inadmissible, mandate_positive, mandate_near_miss_is_inadmissible, lodger_near_miss_is_indeterminate, prior_request_positive, prior_request_near_miss_is_not_made, prior_request_not_required_when_no_request_right, early_resolution_positive, early_resolution_near_miss_is_objected, early_resolution_lead_authority_positive, early_resolution_outside_chapter_iii_is_not_available, early_resolution_infringement_not_ended_is_not_devoid, simple_procedure_positive, simple_procedure_objection_near_miss, simple_procedure_scope_near_miss, simple_procedure_local_case_near_miss, simple_procedure_without_local_statement_is_referred, draft_extension_positive, draft_extension_near_miss_is_not_permitted, draft_base_limit_positive, simple_draft_extension_positive, simple_draft_extension_near_miss, draft_unsure_complexity_is_referred, late_step_positive, late_step_near_miss, time_limit_positive, time_limit_near_miss_simple_procedure, temporal_chapter_two_positive_on_the_day, temporal_chapter_two_near_miss_the_day_before, temporal_chapter_three_positive_the_day_after, temporal_chapter_three_near_miss_on_the_day, input_check_malformed_profile_gets_input_problems]).
cp_test_fail_names([admissibility_near_miss_is_not_admissible, mandate_near_miss_is_not_admissible, lodger_near_miss_is_not_admissible, prior_request_near_miss_is_not_made_not_made, prior_request_unsure_is_not_decided, early_resolution_near_miss_is_not_resolved, early_resolution_conductor_flips_the_result, simple_procedure_objection_near_miss_is_not_available, simple_procedure_scope_near_miss_is_not_available, simple_procedure_local_case_is_not_available, simple_procedure_without_local_statement_is_not_decided, draft_extension_near_miss_has_no_extension, draft_suspension_is_reported_only_with_a_board_request, simple_draft_extension_near_miss_has_no_extension, draft_unsure_complexity_is_not_decided, late_step_near_miss_is_not_protected, late_step_without_statement_is_not_decided, time_limit_near_miss_is_not_fifteen_months, time_limit_unknown_step_gets_no_limit, temporal_chapter_two_the_day_before_does_not_apply, temporal_chapter_three_on_the_day_does_not_apply, temporal_chapter_five_on_the_day_does_not_apply, input_check_malformed_profile_gets_no_verdict]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
