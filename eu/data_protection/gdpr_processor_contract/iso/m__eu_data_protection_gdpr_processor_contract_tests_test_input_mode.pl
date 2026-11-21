% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_processor_contract_tests_test_input_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_processor_contract_processor_contract_status, [decide_processor_contract/2, processor_contract_status/2, contract_missing_stipulations/2, contract_checklist/2, processor_contract_outside_facts/2]).
:- use_module(m__eu_data_protection_gdpr_processor_contract_kernel, [gdpr_processor_contract_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_processor_contract_fixtures, [gdpr_processor_contract_profile_for/2]).

test(eligible_holds_with_the_status_bound) :-
    gdpr_processor_contract_profile_for(eligible_without_subprocessor, Profile),
    processor_contract_status(Profile, eligible).
test(ineligible_holds_with_the_whole_verdict_bound) :-
    gdpr_processor_contract_profile_for(near_miss_missing_point_h, Profile),
    decide_processor_contract(Profile, processor_contract_verdict(ineligible, [stipulates_information_and_audit_rights], [cite(eu_reg_2016_679_art_28_3_h)])).
test(missing_stipulations_hold_bound) :-
    gdpr_processor_contract_profile_for(near_miss_partial_point_a_recorded_false, Profile),
    contract_missing_stipulations(Profile, [stipulates_processing_only_on_documented_instructions]).
test(missing_stipulations_are_empty_for_eligible) :-
    gdpr_processor_contract_profile_for(eligible_without_subprocessor, Profile),
    contract_missing_stipulations(Profile, []).
test(not_applicable_holds_bound) :-
    gdpr_processor_contract_profile_for(not_applicable_not_on_behalf, Profile),
    decide_processor_contract(Profile, processor_contract_verdict(not_applicable, [], [cite(eu_reg_2016_679_art_4_8)])).
test(indeterminate_holds_bound_with_every_absent_key) :-
    gdpr_processor_contract_profile_for(absent_keys_list_all, Profile),
    processor_contract_status(Profile, indeterminate([contract_in_writing, stipulates_security_measures])).
test(open_textured_referral_holds_bound) :-
    gdpr_processor_contract_profile_for(checklist_binding_unsure, Profile),
    processor_contract_status(Profile, needs_legal_review(open_textured(contract_binding_on_processor, cite(eu_reg_2016_679_art_28_3)), [inputs_relied_on([contract_binding_on_processor - unsure, contract_governed_by_union_or_member_state_law - true, processing_on_behalf_of_controller - true, processor_determines_purposes_and_means - false, processor_provides_sufficient_guarantees - true, standard_clauses_adopted - absent])])).
test(deferred_referral_holds_bound) :-
    gdpr_processor_contract_profile_for(role_controller_deferred, Profile),
    processor_contract_status(Profile, needs_legal_review(deferred_provision(cite(eu_reg_2016_679_art_28_10)), [inputs_relied_on([processing_on_behalf_of_controller - true, processor_determines_purposes_and_means - true, standard_clauses_adopted - absent])])).
test(input_problems_hold_bound) :-
    gdpr_processor_contract_profile_for(input_problems_mixed, Profile),
    processor_contract_status(Profile, input_problems([wrong_type(contract_in_writing), duplicate_key(subprocessor_engaged), unknown_key(stray_key)])).
test(a_checklist_item_holds_bound) :-
    gdpr_processor_contract_profile_for(near_miss_missing_point_h, Profile),
    contract_checklist(Profile, Items),
    member(checklist_item(stipulates_information_and_audit_rights, cite(eu_reg_2016_679_art_28_3_h), unmet), Items).
test(an_outside_fact_holds_bound) :-
    gdpr_processor_contract_profile_for(eligible_with_standard_clauses_recorded, Profile),
    processor_contract_outside_facts(Profile, [outside_fact(standard_clauses_adopted, attested(true, attestation(host, moment, reason, none)))]).
test(a_non_list_profile_is_wrong_type) :-
    decide_processor_contract(not_an_attribute_list, processor_contract_verdict(input_problems([wrong_type(profile)]), [], [])).
test(a_partial_list_is_wrong_type) :-
    gdpr_processor_contract_input_problems([attribute(contract_in_writing, true)|_], [wrong_type(profile)]).
test(an_item_that_is_not_an_attribute_is_wrong_type) :-
    gdpr_processor_contract_input_problems([contract_in_writing], [wrong_type(profile)]).
test(an_unbound_key_is_wrong_type_of_the_profile) :-
    gdpr_processor_contract_input_problems([attribute(_, true)], [wrong_type(profile)]).
test(an_unbound_value_is_wrong_type_never_absent) :-
    gdpr_processor_contract_input_problems([attribute(contract_in_writing, _)], [wrong_type(contract_in_writing)]).
test(a_quoted_boolean_is_wrong_type) :-
    gdpr_processor_contract_input_problems([attribute(contract_in_writing, "true")], [wrong_type(contract_in_writing)]).
test(an_unknown_judgement_value_is_wrong_type) :-
    gdpr_processor_contract_input_problems([attribute(contract_binding_on_processor, yes)], [wrong_type(contract_binding_on_processor)]).
test(equal_duplicates_are_a_duplicate_key) :-
    gdpr_processor_contract_input_problems([attribute(contract_in_writing, true), attribute(contract_in_writing, true)], [duplicate_key(contract_in_writing)]).
test(an_unknown_key_is_named) :-
    gdpr_processor_contract_input_problems([attribute(stray_key, true)], [unknown_key(stray_key)]).
test(an_attested_fact_with_url_evidence_is_well_typed) :-
    gdpr_processor_contract_input_problems([attribute(standard_clauses_adopted, attested(false, attestation(host, moment, reason, url(address, retrieved))))], []).
test(an_attested_fact_with_a_bad_value_is_wrong_type) :-
    gdpr_processor_contract_input_problems([attribute(standard_clauses_adopted, attested(maybe, attestation(host, moment, reason, none)))], [wrong_type(standard_clauses_adopted)]).
test(absence_is_not_an_input_problem) :-
    gdpr_processor_contract_input_problems([], []),
    processor_contract_status([], indeterminate([processing_on_behalf_of_controller])).
test(a_malformed_profile_gets_no_checklist) :-
    contract_checklist(profile_text, []),
    contract_missing_stipulations(profile_text, []),
    processor_contract_outside_facts(profile_text, input_problems([wrong_type(profile)])).

test(eligible_rejects_a_bound_ineligible, fail) :-
    gdpr_processor_contract_profile_for(eligible_without_subprocessor, Profile),
    processor_contract_status(Profile, ineligible).
test(ineligible_rejects_a_wrong_bound_citation, fail) :-
    gdpr_processor_contract_profile_for(near_miss_missing_point_h, Profile),
    decide_processor_contract(Profile, processor_contract_verdict(ineligible, [stipulates_information_and_audit_rights], [cite(eu_reg_2016_679_art_28_3)])).
test(indeterminate_rejects_a_list_of_the_first_key_only, fail) :-
    gdpr_processor_contract_profile_for(absent_keys_list_all, Profile),
    processor_contract_status(Profile, indeterminate([contract_in_writing])).

cp_test_names([eligible_holds_with_the_status_bound, ineligible_holds_with_the_whole_verdict_bound, missing_stipulations_hold_bound, missing_stipulations_are_empty_for_eligible, not_applicable_holds_bound, indeterminate_holds_bound_with_every_absent_key, open_textured_referral_holds_bound, deferred_referral_holds_bound, input_problems_hold_bound, a_checklist_item_holds_bound, an_outside_fact_holds_bound, a_non_list_profile_is_wrong_type, a_partial_list_is_wrong_type, an_item_that_is_not_an_attribute_is_wrong_type, an_unbound_key_is_wrong_type_of_the_profile, an_unbound_value_is_wrong_type_never_absent, a_quoted_boolean_is_wrong_type, an_unknown_judgement_value_is_wrong_type, equal_duplicates_are_a_duplicate_key, an_unknown_key_is_named, an_attested_fact_with_url_evidence_is_well_typed, an_attested_fact_with_a_bad_value_is_wrong_type, absence_is_not_an_input_problem, a_malformed_profile_gets_no_checklist]).
cp_test_fail_names([eligible_rejects_a_bound_ineligible, ineligible_rejects_a_wrong_bound_citation, indeterminate_rejects_a_list_of_the_first_key_only]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
