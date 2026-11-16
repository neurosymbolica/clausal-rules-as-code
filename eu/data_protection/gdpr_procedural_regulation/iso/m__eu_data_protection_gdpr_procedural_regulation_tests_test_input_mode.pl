% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_procedural_regulation_tests_test_input_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_procedural_regulation_gdpr_procedural_regulation, [complaint_admissibility/3, prior_request_condition/3, early_resolution/3, simple_cooperation_procedure/4, draft_decision_time_limit/4, late_step_effect/4, procedural_time_limit/4, temporal_application/5, gdpr_procedural_regulation_status/2]).
:- use_module(m__eu_data_protection_gdpr_procedural_regulation_kernel, [gdpr_procedural_regulation_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_procedural_regulation_fixtures, [gdpr_procedural_regulation_profile_for/2]).

test(admissibility_holds_with_the_verdict_bound) :-
    gdpr_procedural_regulation_profile_for(admissible_data_subject_complaint, Profile),
    complaint_admissibility(Profile, admissible, [cite(eu_reg_2025_2518_art_4_1), cite(eu_reg_2025_2518_art_4_1_a), cite(eu_reg_2025_2518_art_4_1_d), cite(eu_reg_2025_2518_art_4_1_e), cite(eu_reg_2025_2518_art_4_5)]).
test(status_holds_with_the_verdict_bound) :-
    gdpr_procedural_regulation_profile_for(inadmissible_missing_description, Profile),
    gdpr_procedural_regulation_status(Profile, inadmissible).
test(prior_request_holds_with_the_verdict_bound) :-
    gdpr_procedural_regulation_profile_for(prior_request_not_made, Profile),
    prior_request_condition(Profile, prior_request_not_made, [cite(eu_reg_2025_2518_art_4_3)]).
test(early_resolution_holds_with_the_verdict_bound) :-
    gdpr_procedural_regulation_profile_for(early_resolution_objected, Profile),
    early_resolution(Profile, early_resolution_objected, [cite(eu_reg_2025_2518_art_5_2), cite(eu_reg_2025_2518_art_5_2_c)]).
test(simple_procedure_holds_with_the_verdict_bound) :-
    gdpr_procedural_regulation_profile_for(simple_procedure_objected, Profile),
    simple_cooperation_procedure(Profile, simple_procedure_excluded_by_objection, [outside_fact(case_handled_under_article_56_2, _)], [cite(eu_reg_2025_2518_art_6_3)]).
test(draft_decision_limit_holds_with_the_result_bound) :-
    gdpr_procedural_regulation_profile_for(draft_decision_base_limit, Profile),
    draft_decision_time_limit(Profile, draft_decision_limit(15, no_extension), [], [cite(eu_reg_2025_2518_art_12_1)]).
test(late_step_holds_with_the_verdict_bound) :-
    gdpr_procedural_regulation_profile_for(late_step_under_national_law, Profile),
    late_step_effect(Profile, not_governed_by_article_14, [outside_fact(time_limit_set_by_this_regulation_or_article_65_6, _)], [cite(eu_reg_2025_2518_art_14)]).
test(time_limit_holds_with_the_limit_bound) :-
    procedural_time_limit([], object_to_simple_cooperation_procedure, limit(2, weeks, within, notification_of_simple_cooperation_procedure, no_extension), [cite(eu_reg_2025_2518_art_6_3)]).
test(temporal_application_holds_with_the_result_bound) :-
    temporal_application([], dispute_resolution_and_urgency, date(2027, 4, 3), part_applies, [cite(eu_reg_2025_2518_art_36), cite(eu_reg_2025_2518_art_37_2)]).
test(a_well_formed_empty_profile_has_no_problem) :-
    gdpr_procedural_regulation_input_problems([], []).
test(a_list_with_a_foreign_element_is_not_an_attribute_list) :-
    gdpr_procedural_regulation_input_problems([attribute(complaint_lodged_by, data_subject), complaint_lodged_by - data_subject], [wrong_type(profile)]).
test(a_dictionary_like_atom_is_not_an_attribute_list) :-
    gdpr_procedural_regulation_input_problems(profile, [wrong_type(profile)]).
test(a_number_key_is_an_unknown_key) :-
    gdpr_procedural_regulation_input_problems([attribute(42, true)], [unknown_key(42)]).
test(a_repeated_unknown_key_is_named_once) :-
    gdpr_procedural_regulation_input_problems([attribute(colour, blue), attribute(colour, red)], [unknown_key(colour)]).
test(a_duplicate_key_is_never_also_a_wrong_type) :-
    gdpr_procedural_regulation_input_problems([attribute(complaint_lodged_by, nobody), attribute(complaint_lodged_by, data_subject)], [duplicate_key(complaint_lodged_by)]).
test(unsure_is_a_wrong_type_for_a_crisp_key) :-
    gdpr_procedural_regulation_input_problems([attribute(request_made_to_controller_before_complaint, unsure)], [wrong_type(request_made_to_controller_before_complaint)]).
test(unsure_is_accepted_for_a_judgement) :-
    gdpr_procedural_regulation_input_problems([attribute(complaint_concerns_right_exercised_by_request, unsure)], []).
test(an_attested_term_is_a_wrong_type_for_a_judgement) :-
    gdpr_procedural_regulation_input_problems([attribute(extension_justified_by_exceptional_complexity, attested(true, attestation(by, at, reason, none)))], [wrong_type(extension_justified_by_exceptional_complexity)]).
test(a_bare_true_is_a_wrong_type_for_an_outside_fact) :-
    gdpr_procedural_regulation_input_problems([attribute(case_handled_under_article_56_2, true)], [wrong_type(case_handled_under_article_56_2)]).
test(an_attested_unsure_is_a_wrong_type_for_an_outside_fact) :-
    gdpr_procedural_regulation_input_problems([attribute(case_handled_under_article_56_2, attested(unsure, attestation(by, at, reason, none)))], [wrong_type(case_handled_under_article_56_2)]).
test(every_evidence_form_is_accepted_for_an_outside_fact) :-
    gdpr_procedural_regulation_input_problems([attribute(case_handled_under_article_56_2, attested(true, attestation(by, at, reason, url(address, retrieved_at)))), attribute(national_law_requires_domestic_proceedings_after_time_limit, attested(false, attestation(by, at, reason, document(upload, digest)))), attribute(time_limit_set_by_this_regulation_or_article_65_6, attested(true, attestation(by, at, reason, none)))], []).
test(the_problems_come_in_contract_order_then_unknown_keys) :-
    gdpr_procedural_regulation_profile_for(malformed_profile_duplicates_and_unknown, Profile),
    gdpr_procedural_regulation_input_problems(Profile, [duplicate_key(complaint_lodged_by), wrong_type(lodging_person_name_and_contact_details_included), unknown_key(colour)]).
test(a_malformed_profile_gets_input_problems_from_every_query) :-
    gdpr_procedural_regulation_profile_for(malformed_profile_duplicates_and_unknown, Profile),
    Problems = [duplicate_key(complaint_lodged_by), wrong_type(lodging_person_name_and_contact_details_included), unknown_key(colour)],
    complaint_admissibility(Profile, input_problems(Problems), []),
    prior_request_condition(Profile, input_problems(Problems), []),
    early_resolution(Profile, input_problems(Problems), []),
    simple_cooperation_procedure(Profile, input_problems(Problems), [], []),
    draft_decision_time_limit(Profile, input_problems(Problems), [], []),
    late_step_effect(Profile, input_problems(Problems), [], []),
    procedural_time_limit(Profile, submit_draft_decision, input_problems(Problems), []),
    temporal_application(Profile, cooperation_and_files, date(2028, 1, 1), input_problems(Problems), []).
test(the_argument_problems_follow_the_profile_problems) :-
    temporal_application([attribute(colour, blue)], chapter_seven, today, input_problems([unknown_key(colour), wrong_type(part), wrong_type(event_date)]), []).
test(a_century_year_not_divisible_by_400_has_no_february_29) :-
    temporal_application([], complaints_and_early_resolution, date(2100, 2, 29), input_problems([wrong_type(event_date)]), []).
test(a_year_divisible_by_400_has_february_29) :-
    temporal_application([], complaints_and_early_resolution, date(2000, 2, 29), part_does_not_apply, [cite(eu_reg_2025_2518_art_37_2)]).
test(a_date_of_non_integers_is_a_wrong_type) :-
    temporal_application([], complaints_and_early_resolution, date(2028, april, 1), input_problems([wrong_type(event_date)]), []).

test(admissibility_rejects_the_other_verdict_bound, fail) :-
    gdpr_procedural_regulation_profile_for(admissible_data_subject_complaint, Profile),
    complaint_admissibility(Profile, inadmissible, _).
test(status_rejects_the_other_verdict_bound, fail) :-
    gdpr_procedural_regulation_profile_for(inadmissible_missing_description, Profile),
    gdpr_procedural_regulation_status(Profile, admissible).
test(prior_request_rejects_made_when_not_made, fail) :-
    gdpr_procedural_regulation_profile_for(prior_request_not_made, Profile),
    prior_request_condition(Profile, prior_request_made, _).
test(early_resolution_rejects_resolution_after_an_objection, fail) :-
    gdpr_procedural_regulation_profile_for(early_resolution_objected, Profile),
    early_resolution(Profile, resolution_established_by_receiving_authority, _).
test(simple_procedure_rejects_available_after_an_objection, fail) :-
    gdpr_procedural_regulation_profile_for(simple_procedure_objected, Profile),
    simple_cooperation_procedure(Profile, simple_procedure_available, _, _).
test(draft_decision_limit_rejects_the_simple_procedure_months, fail) :-
    gdpr_procedural_regulation_profile_for(draft_decision_base_limit, Profile),
    draft_decision_time_limit(Profile, draft_decision_limit(12, _), _, _).
test(late_step_rejects_article_14_protection_under_national_law, fail) :-
    gdpr_procedural_regulation_profile_for(late_step_under_national_law, Profile),
    late_step_effect(Profile, legality_and_validity_not_affected, _, _).
test(time_limit_rejects_a_wrong_length, fail) :-
    procedural_time_limit([], object_to_simple_cooperation_procedure, limit(4, weeks, _, _, _), _).
test(temporal_application_rejects_the_other_result, fail) :-
    temporal_application([], dispute_resolution_and_urgency, date(2027, 4, 3), part_does_not_apply, _).

cp_test_names([admissibility_holds_with_the_verdict_bound, status_holds_with_the_verdict_bound, prior_request_holds_with_the_verdict_bound, early_resolution_holds_with_the_verdict_bound, simple_procedure_holds_with_the_verdict_bound, draft_decision_limit_holds_with_the_result_bound, late_step_holds_with_the_verdict_bound, time_limit_holds_with_the_limit_bound, temporal_application_holds_with_the_result_bound, a_well_formed_empty_profile_has_no_problem, a_list_with_a_foreign_element_is_not_an_attribute_list, a_dictionary_like_atom_is_not_an_attribute_list, a_number_key_is_an_unknown_key, a_repeated_unknown_key_is_named_once, a_duplicate_key_is_never_also_a_wrong_type, unsure_is_a_wrong_type_for_a_crisp_key, unsure_is_accepted_for_a_judgement, an_attested_term_is_a_wrong_type_for_a_judgement, a_bare_true_is_a_wrong_type_for_an_outside_fact, an_attested_unsure_is_a_wrong_type_for_an_outside_fact, every_evidence_form_is_accepted_for_an_outside_fact, the_problems_come_in_contract_order_then_unknown_keys, a_malformed_profile_gets_input_problems_from_every_query, the_argument_problems_follow_the_profile_problems, a_century_year_not_divisible_by_400_has_no_february_29, a_year_divisible_by_400_has_february_29, a_date_of_non_integers_is_a_wrong_type]).
cp_test_fail_names([admissibility_rejects_the_other_verdict_bound, status_rejects_the_other_verdict_bound, prior_request_rejects_made_when_not_made, early_resolution_rejects_resolution_after_an_objection, simple_procedure_rejects_available_after_an_objection, draft_decision_limit_rejects_the_simple_procedure_months, late_step_rejects_article_14_protection_under_national_law, time_limit_rejects_a_wrong_length, temporal_application_rejects_the_other_result]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
