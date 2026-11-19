% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_transfer_dpf_tests_test_input_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_transfer_dpf_gdpr_transfer_dpf, [data_privacy_framework_adequacy/4, gdpr_transfer_dpf_status/2]).
:- use_module(m__eu_data_protection_gdpr_transfer_dpf_kernel, [gdpr_transfer_dpf_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_transfer_dpf_fixtures, [gdpr_transfer_dpf_profile_for/2]).

test(covered_holds_with_the_result_bound) :-
    gdpr_transfer_dpf_profile_for(all_conditions_hold, Profile),
    data_privacy_framework_adequacy(Profile, covered_by_data_privacy_framework_adequacy, _Basis, [cite(eu_dec_2023_1795_art_1), cite(eu_reg_2016_679_art_45_1)]).
test(not_covered_holds_with_the_result_bound) :-
    gdpr_transfer_dpf_profile_for(recipient_outside_united_states, Profile),
    data_privacy_framework_adequacy(Profile, not_covered_by_data_privacy_framework_adequacy, [], [cite(eu_dec_2023_1795_art_1)]).
test(referral_holds_with_the_result_bound) :-
    gdpr_transfer_dpf_profile_for(coverage_statement_absent, Profile),
    data_privacy_framework_adequacy(Profile, needs_legal_review(cross_reference_unresolved(cite(eu_dec_2023_1795_art_1), cite(data_privacy_framework_certification_coverage_statement)), [resolution(cite(data_privacy_framework_certification_coverage_statement), not_attempted), inputs_relied_on([certification_covers_transferred_data - absent])]), [], []).
test(indeterminate_holds_with_the_result_bound) :-
    gdpr_transfer_dpf_profile_for(recipient_absent, Profile),
    data_privacy_framework_adequacy(Profile, indeterminate([recipient_is_organisation_in_united_states]), [], []).
test(input_problems_hold_with_the_result_bound) :-
    gdpr_transfer_dpf_profile_for(bare_boolean_outside_fact, Profile),
    data_privacy_framework_adequacy(Profile, input_problems([wrong_type(recipient_on_data_privacy_framework_list)]), [], []).
test(the_key_order_of_the_profile_does_not_change_the_answer) :-
    gdpr_transfer_dpf_profile_for(all_conditions_hold, Profile),
    reverse(Profile, Reversed),
    data_privacy_framework_adequacy(Profile, Result, Basis, Citations),
    data_privacy_framework_adequacy(Reversed, Result, Basis, Citations).
test(keys_not_read_on_the_way_do_not_change_the_answer) :-
    gdpr_transfer_dpf_profile_for(not_from_union, Stated),
    gdpr_transfer_dpf_profile_for(crisp_false_with_facts_absent, Sparse),
    data_privacy_framework_adequacy(Stated, Result, Basis, Citations),
    data_privacy_framework_adequacy(Sparse, Result, Basis, Citations).
test(an_unbound_profile_is_wrong_type_profile) :-
    findall(Problems, gdpr_transfer_dpf_input_problems(_, Problems), Answers),
    Answers == [[wrong_type(profile)]].
test(a_list_with_a_non_attribute_element_is_wrong_type_profile) :-
    gdpr_transfer_dpf_input_problems([attribute(transfer_from_union, true), colour], [wrong_type(profile)]).
test(a_non_atom_key_is_an_unknown_key) :-
    gdpr_transfer_dpf_input_problems([attribute(7, true)], [unknown_key(7)]).
test(an_unbound_value_is_wrong_type) :-
    findall(Problems, gdpr_transfer_dpf_input_problems([attribute(transfer_from_union, _)], Problems), Answers),
    Answers == [[wrong_type(transfer_from_union)]].
test(document_evidence_is_accepted) :-
    gdpr_transfer_dpf_input_problems([attribute(recipient_on_data_privacy_framework_list, attested(false, attestation(by, at, reason, document(upload_one, digest_one))))], []).
test(url_evidence_is_accepted) :-
    gdpr_transfer_dpf_input_problems([attribute(data_privacy_framework_decision_in_force, attested(true, attestation(by, at, reason, url(address_one, retrieved_one))))], []).
test(an_attested_value_outside_true_and_false_is_wrong_type) :-
    gdpr_transfer_dpf_input_problems([attribute(data_privacy_framework_decision_in_force, attested(unsure, attestation(by, at, reason, none)))], [wrong_type(data_privacy_framework_decision_in_force)]).
test(an_absent_key_is_never_a_problem) :-
    gdpr_transfer_dpf_input_problems([attribute(recipient_is_organisation_in_united_states, true)], []).

test(covered_profile_rejects_not_covered_bound, fail) :-
    gdpr_transfer_dpf_profile_for(all_conditions_hold, Profile),
    gdpr_transfer_dpf_status(Profile, not_covered_by_data_privacy_framework_adequacy).
test(not_covered_profile_rejects_covered_bound, fail) :-
    gdpr_transfer_dpf_profile_for(recipient_outside_united_states, Profile),
    gdpr_transfer_dpf_status(Profile, covered_by_data_privacy_framework_adequacy).
test(referral_profile_rejects_a_wrong_target_bound, fail) :-
    gdpr_transfer_dpf_profile_for(coverage_statement_absent, Profile),
    gdpr_transfer_dpf_status(Profile, needs_legal_review(cross_reference_unresolved(_, cite(data_privacy_framework_list_entry_statement)), _)).
test(indeterminate_profile_rejects_another_key_bound, fail) :-
    gdpr_transfer_dpf_profile_for(recipient_absent, Profile),
    gdpr_transfer_dpf_status(Profile, indeterminate([transfer_from_union])).
test(input_problem_profile_rejects_a_verdict_bound, fail) :-
    gdpr_transfer_dpf_profile_for(bare_boolean_outside_fact, Profile),
    gdpr_transfer_dpf_status(Profile, covered_by_data_privacy_framework_adequacy).

cp_test_names([covered_holds_with_the_result_bound, not_covered_holds_with_the_result_bound, referral_holds_with_the_result_bound, indeterminate_holds_with_the_result_bound, input_problems_hold_with_the_result_bound, the_key_order_of_the_profile_does_not_change_the_answer, keys_not_read_on_the_way_do_not_change_the_answer, an_unbound_profile_is_wrong_type_profile, a_list_with_a_non_attribute_element_is_wrong_type_profile, a_non_atom_key_is_an_unknown_key, an_unbound_value_is_wrong_type, document_evidence_is_accepted, url_evidence_is_accepted, an_attested_value_outside_true_and_false_is_wrong_type, an_absent_key_is_never_a_problem]).
cp_test_fail_names([covered_profile_rejects_not_covered_bound, not_covered_profile_rejects_covered_bound, referral_profile_rejects_a_wrong_target_bound, indeterminate_profile_rejects_another_key_bound, input_problem_profile_rejects_a_verdict_bound]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
