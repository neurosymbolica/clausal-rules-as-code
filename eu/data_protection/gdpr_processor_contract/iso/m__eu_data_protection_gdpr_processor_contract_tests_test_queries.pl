% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_processor_contract_tests_test_queries, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_processor_contract_queries, [gdpr_processor_contract_profile_keys/1, gdpr_processor_contract_what_if/4]).
:- use_module(m__eu_data_protection_gdpr_processor_contract_kernel, [gdpr_processor_contract_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_processor_contract_processor_contract_status, [processor_contract_status/2, contract_checklist/2]).
:- use_module(m__eu_data_protection_gdpr_processor_contract_fixtures, [gdpr_processor_contract_profile_for/2]).

test(profile_keys_are_the_contract_keys) :-
    gdpr_processor_contract_profile_keys(ProfileKeys),
    ProfileKeys == [contract_binding_on_processor, contract_governed_by_union_or_member_state_law, contract_in_writing, contract_sets_out_categories_of_data_subjects, contract_sets_out_controller_obligations_and_rights, contract_sets_out_duration, contract_sets_out_nature_of_processing, contract_sets_out_purpose_of_processing, contract_sets_out_subject_matter, contract_sets_out_type_of_personal_data, controller_given_opportunity_to_object, processing_on_behalf_of_controller, processor_determines_purposes_and_means, processor_informed_controller_of_intended_changes, processor_provides_sufficient_guarantees, standard_clauses_adopted, stipulates_assistance_with_articles_32_to_36_obligations, stipulates_assistance_with_data_subject_requests, stipulates_conditions_for_engaging_another_processor, stipulates_confidentiality_commitment, stipulates_deletion_or_return_of_personal_data, stipulates_information_and_audit_rights, stipulates_notice_of_infringing_instruction, stipulates_processing_only_on_documented_instructions, stipulates_security_measures, subprocessor_authorisation, subprocessor_authorisation_given_before_engagement, subprocessor_contract_governed_by_union_or_member_state_law, subprocessor_contract_in_writing, subprocessor_engaged, subprocessor_obligations_same, subprocessor_provides_sufficient_guarantees].
test(there_are_thirtytwo_profile_keys) :-
    gdpr_processor_contract_profile_keys(ProfileKeys),
    length(ProfileKeys, 32).
test(the_input_check_is_served_by_the_query_layer) :-
    gdpr_processor_contract_input_problems([attribute(bogus_key, true)], [unknown_key(bogus_key)]).
test(status_determination_eligible) :-
    gdpr_processor_contract_profile_for(compliant_without_subprocessor, Profile),
    findall(Status, processor_contract_status(Profile, Status), Statuses),
    Statuses == [eligible].
test(status_determination_ineligible) :-
    gdpr_processor_contract_profile_for(audit_clause_missing, Profile),
    findall(Status, processor_contract_status(Profile, Status), Statuses),
    Statuses == [ineligible].
test(status_determination_not_applicable) :-
    gdpr_processor_contract_profile_for(not_a_processor, Profile),
    findall(Status, processor_contract_status(Profile, Status), Statuses),
    Statuses == [not_applicable].
test(justification_every_item_carries_a_cite_term) :-
    gdpr_processor_contract_profile_for(audit_clause_missing, Profile),
    contract_checklist(Profile, [_|_]).
test(justification_the_unmet_item_is_cited_to_its_point) :-
    gdpr_processor_contract_profile_for(audit_clause_missing, Profile),
    contract_checklist(Profile, Items),
    findall(Key - Citation, member(checklist_item(Key, Citation, unmet), Items), Unmet),
    Unmet == [stipulates_information_and_audit_rights - cite(eu_reg_2016_679_art_28_3_h)].
test(justification_two_unmet_items_in_key_order) :-
    gdpr_processor_contract_profile_for(confidentiality_and_security_missing, Profile),
    contract_checklist(Profile, Items),
    findall(Key, member(checklist_item(Key, _, unmet), Items), Unmet),
    Unmet == [stipulates_confidentiality_commitment, stipulates_security_measures].
test(compliance_check_a_change_that_breaks_the_arrangement) :-
    gdpr_processor_contract_profile_for(compliant_without_subprocessor, Profile),
    findall(NewStatus, gdpr_processor_contract_what_if(Profile, stipulates_information_and_audit_rights, false, NewStatus), Statuses),
    Statuses == [ineligible].
test(compliance_check_a_change_that_repairs_the_arrangement) :-
    gdpr_processor_contract_profile_for(audit_clause_missing, Profile),
    findall(NewStatus, gdpr_processor_contract_what_if(Profile, stipulates_information_and_audit_rights, true, NewStatus), Statuses),
    Statuses == [eligible].
test(compliance_check_engaging_a_subprocessor_without_authorisation) :-
    gdpr_processor_contract_profile_for(compliant_without_subprocessor, Profile),
    gdpr_processor_contract_what_if(Profile, subprocessor_engaged, true, indeterminate(_)).
test(compliance_check_the_override_replaces_not_duplicates) :-
    gdpr_processor_contract_profile_for(compliant_without_subprocessor, Profile),
    gdpr_processor_contract_what_if(Profile, contract_in_writing, false, ineligible),
    gdpr_processor_contract_what_if(Profile, contract_in_writing, true, eligible).
test(compliance_check_an_absent_key_can_be_added) :-
    gdpr_processor_contract_profile_for(role_unestablished, Profile),
    gdpr_processor_contract_what_if(Profile, processing_on_behalf_of_controller, true, eligible).
test(compliance_check_an_invalid_override_gives_input_problems) :-
    gdpr_processor_contract_profile_for(compliant_without_subprocessor, Profile),
    gdpr_processor_contract_what_if(Profile, contract_in_writing, maybe, input_problems([wrong_type(contract_in_writing)])).

test(justification_no_item_lacks_a_cite_term, fail) :-
    gdpr_processor_contract_profile_for(audit_clause_missing, Profile),
    contract_checklist(Profile, Items),
    member(checklist_item(_, Citation, _), Items),
    Citation \= cite(_).
test(compliance_check_is_not_a_wrong_status, fail) :-
    gdpr_processor_contract_profile_for(compliant_without_subprocessor, Profile),
    gdpr_processor_contract_what_if(Profile, stipulates_information_and_audit_rights, false, eligible).

cp_test_names([profile_keys_are_the_contract_keys, there_are_thirtytwo_profile_keys, the_input_check_is_served_by_the_query_layer, status_determination_eligible, status_determination_ineligible, status_determination_not_applicable, justification_every_item_carries_a_cite_term, justification_the_unmet_item_is_cited_to_its_point, justification_two_unmet_items_in_key_order, compliance_check_a_change_that_breaks_the_arrangement, compliance_check_a_change_that_repairs_the_arrangement, compliance_check_engaging_a_subprocessor_without_authorisation, compliance_check_the_override_replaces_not_duplicates, compliance_check_an_absent_key_can_be_added, compliance_check_an_invalid_override_gives_input_problems]).
cp_test_fail_names([justification_no_item_lacks_a_cite_term, compliance_check_is_not_a_wrong_status]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
