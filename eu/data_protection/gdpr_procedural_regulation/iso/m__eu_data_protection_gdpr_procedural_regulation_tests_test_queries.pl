% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_procedural_regulation_tests_test_queries, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_procedural_regulation_queries, [gdpr_procedural_regulation_profile_keys/1, gdpr_procedural_regulation_what_if/4]).
:- use_module(m__eu_data_protection_gdpr_procedural_regulation_kernel, [gdpr_procedural_regulation_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_procedural_regulation_gdpr_procedural_regulation, [complaint_admissibility/3, simple_cooperation_procedure/4, procedural_time_limit/4, late_step_effect/4]).
:- use_module(m__eu_data_protection_gdpr_procedural_regulation_fixtures, [gdpr_procedural_regulation_profile_for/2]).

fixture(Subject, Profile) :-
    gdpr_procedural_regulation_profile_for(Subject, Profile).

test(profile_keys_are_the_contract_keys) :-
    gdpr_procedural_regulation_profile_keys(ProfileKeys),
    ProfileKeys == [complaint_lodged_by, lodging_person_name_and_contact_details_included, proof_of_proper_constitution_included, proof_of_data_subject_mandate_included, controller_or_processor_identification_information_included, alleged_infringement_description_included, complaint_concerns_right_exercised_by_request, request_made_to_controller_before_complaint, complaint_concerns_chapter_iii_rights, end_of_infringement_established_on_supporting_evidence, complainant_objected_to_early_resolution_in_time, early_resolution_procedure_before, case_handled_under_article_56_2, lead_authority_considers_no_reasonable_doubt_as_to_scope, issues_addressable_without_additional_cooperation, concerned_authority_objected_to_simple_procedure_in_time, simple_cooperation_procedure_applied, draft_decision_time_limit_extended, board_request_under_article_11_6_made, extension_justified_by_exceptional_complexity, national_law_requires_domestic_proceedings_after_time_limit, time_limit_set_by_this_regulation_or_article_65_6].
test(every_schema_key_is_known_to_the_input_check) :-
    gdpr_procedural_regulation_profile_keys(ProfileKeys),
    findall(Key, (member(Key, ProfileKeys), gdpr_procedural_regulation_input_problems([attribute(Key, not_a_value)], [wrong_type(Key)])), CheckedKeys),
    CheckedKeys == ProfileKeys.
test(a_key_outside_the_schema_is_unknown) :-
    gdpr_procedural_regulation_input_problems([attribute(complaint_colour, red)], [unknown_key(complaint_colour)]).
test(what_if_adding_the_mandate_makes_the_complaint_admissible) :-
    fixture(article_80_1_body_complaint_without_mandate, Profile),
    complaint_admissibility(Profile, inadmissible, _),
    findall(Status, gdpr_procedural_regulation_what_if(Profile, proof_of_data_subject_mandate_included, true, Status), Statuses),
    Statuses == [admissible].
test(what_if_a_body_lodges_asks_for_its_constitution) :-
    fixture(admissible_data_subject_complaint, Profile),
    gdpr_procedural_regulation_what_if(Profile, complaint_lodged_by, article_80_1_body, indeterminate([proof_of_proper_constitution_included])).
test(what_if_replaces_a_duplicated_key) :-
    fixture(malformed_profile_case, Profile),
    gdpr_procedural_regulation_what_if(Profile, complaint_lodged_by, data_subject, input_problems([unknown_key(complaint_reference)])).
test(what_if_on_a_non_list_profile_reports_it) :-
    gdpr_procedural_regulation_what_if(nonsense, complaint_lodged_by, data_subject, input_problems([wrong_type(profile)])).
test(status_determination_on_an_article_80_2_body_complaint) :-
    fixture(admissible_article_80_2_body_complaint, Profile),
    findall(Result, complaint_admissibility(Profile, Result, _), Results),
    Results == [admissible].
test(compliance_check_the_lead_authority_may_use_the_simple_procedure) :-
    fixture(simple_procedure_open_case, Profile),
    findall(Result, simple_cooperation_procedure(Profile, Result, _, _), Results),
    Results == [simple_procedure_available].
test(compliance_check_an_objection_excludes_it) :-
    fixture(simple_procedure_objected_case, Profile),
    findall(Result, simple_cooperation_procedure(Profile, Result, _, _), Results),
    Results == [simple_procedure_excluded_by_objection].
test(deadline_transmission_within_six_weeks_of_receipt) :-
    findall(Limit, procedural_time_limit([], transmit_complaint_to_presumed_lead_authority, Limit, _), Limits),
    Limits == [limit(6, weeks, within, receipt_of_complaint, no_extension)].
test(deadline_consequence_of_missing_a_limit_of_this_regulation) :-
    fixture(late_step_after_regulation_time_limit, Profile),
    findall(Result, late_step_effect(Profile, Result, _, _), Results),
    Results == [legality_and_validity_not_affected].

test(what_if_does_not_keep_the_old_value, fail) :-
    fixture(admissible_data_subject_complaint, Profile),
    gdpr_procedural_regulation_what_if(Profile, lodging_person_name_and_contact_details_included, false, admissible).

cp_test_names([profile_keys_are_the_contract_keys, every_schema_key_is_known_to_the_input_check, a_key_outside_the_schema_is_unknown, what_if_adding_the_mandate_makes_the_complaint_admissible, what_if_a_body_lodges_asks_for_its_constitution, what_if_replaces_a_duplicated_key, what_if_on_a_non_list_profile_reports_it, status_determination_on_an_article_80_2_body_complaint, compliance_check_the_lead_authority_may_use_the_simple_procedure, compliance_check_an_objection_excludes_it, deadline_transmission_within_six_weeks_of_receipt, deadline_consequence_of_missing_a_limit_of_this_regulation]).
cp_test_fail_names([what_if_does_not_keep_the_old_value]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
