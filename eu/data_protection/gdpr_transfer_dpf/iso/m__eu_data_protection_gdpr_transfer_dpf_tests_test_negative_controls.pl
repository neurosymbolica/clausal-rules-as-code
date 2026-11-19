% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_transfer_dpf_tests_test_negative_controls, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_transfer_dpf_gdpr_transfer_dpf, [data_privacy_framework_adequacy/4, gdpr_transfer_dpf_status/2, gdpr_transfer_dpf_status_values/1]).
:- use_module(m__eu_data_protection_gdpr_transfer_dpf_fixtures, [gdpr_transfer_dpf_profile_for/2]).

status_of(Subject, Status) :-
    gdpr_transfer_dpf_profile_for(Subject, Profile),
    gdpr_transfer_dpf_status(Profile, Status).

test(both_result_atoms_are_in_the_status_table) :-
    gdpr_transfer_dpf_status_values(StatusValues),
    StatusValues == [covered_by_data_privacy_framework_adequacy, not_covered_by_data_privacy_framework_adequacy].
test(route_covered_positive) :-
    status_of(all_conditions_hold, covered_by_data_privacy_framework_adequacy).
test(near_miss_not_from_union_is_not_covered) :-
    status_of(not_from_union, not_covered_by_data_privacy_framework_adequacy).
test(near_miss_recipient_outside_united_states_is_not_covered) :-
    status_of(recipient_outside_united_states, not_covered_by_data_privacy_framework_adequacy).
test(near_miss_decision_not_in_force_is_not_covered) :-
    status_of(decision_not_in_force, not_covered_by_data_privacy_framework_adequacy).
test(near_miss_recipient_off_list_is_not_covered) :-
    status_of(recipient_off_list, not_covered_by_data_privacy_framework_adequacy).
test(near_miss_human_resources_data_not_declared_is_not_covered) :-
    status_of(human_resources_data_not_declared, not_covered_by_data_privacy_framework_adequacy).
test(a_false_crisp_key_decides_while_outside_facts_are_absent) :-
    status_of(crisp_false_with_facts_absent, not_covered_by_data_privacy_framework_adequacy).
test(a_false_crisp_key_has_an_empty_basis) :-
    gdpr_transfer_dpf_profile_for(not_from_union, Profile),
    data_privacy_framework_adequacy(Profile, not_covered_by_data_privacy_framework_adequacy, [], _).
test(route_referral_decision_statement_positive) :-
    status_of(decision_statement_absent, needs_legal_review(cross_reference_unresolved(cite(eu_dec_2023_1795_art_1), cite(data_privacy_framework_decision_in_force_statement)), _)).
test(route_referral_near_miss_denied_decision_decides) :-
    status_of(decision_not_in_force, not_covered_by_data_privacy_framework_adequacy).
test(route_referral_coverage_statement_positive) :-
    status_of(coverage_statement_absent, needs_legal_review(cross_reference_unresolved(cite(eu_dec_2023_1795_art_1), cite(data_privacy_framework_certification_coverage_statement)), _)).
test(route_referral_list_statement_with_union_absent_is_referred) :-
    status_of(list_statement_absent_union_absent, needs_legal_review(cross_reference_unresolved(cite(eu_dec_2023_1795_art_1), cite(data_privacy_framework_list_entry_statement)), _)).
test(route_indeterminate_union_positive) :-
    status_of(union_absent, indeterminate([transfer_from_union])).
test(route_indeterminate_recipient_positive) :-
    status_of(recipient_absent, indeterminate([recipient_is_organisation_in_united_states])).
test(route_input_problems_positive) :-
    status_of(bare_boolean_outside_fact, input_problems([wrong_type(recipient_on_data_privacy_framework_list)])).
test(route_input_problems_unbound_attestation_positive) :-
    status_of(unbound_attestation_argument, input_problems([wrong_type(certification_covers_transferred_data)])).

test(route_covered_is_not_not_covered, fail) :-
    status_of(all_conditions_hold, not_covered_by_data_privacy_framework_adequacy).
test(near_miss_not_from_union_is_not_covered_by_the_decision, fail) :-
    status_of(not_from_union, covered_by_data_privacy_framework_adequacy).
test(near_miss_recipient_outside_united_states_is_not_covered_by_the_decision, fail) :-
    status_of(recipient_outside_united_states, covered_by_data_privacy_framework_adequacy).
test(near_miss_decision_not_in_force_is_not_covered_by_the_decision, fail) :-
    status_of(decision_not_in_force, covered_by_data_privacy_framework_adequacy).
test(near_miss_recipient_off_list_is_not_covered_by_the_decision, fail) :-
    status_of(recipient_off_list, covered_by_data_privacy_framework_adequacy).
test(near_miss_human_resources_data_not_declared_is_not_covered_by_the_decision, fail) :-
    status_of(human_resources_data_not_declared, covered_by_data_privacy_framework_adequacy).
test(a_false_crisp_key_with_absent_facts_is_not_referred, fail) :-
    status_of(crisp_false_with_facts_absent, needs_legal_review(_, _)).
test(a_denied_outside_fact_does_not_have_an_empty_basis, fail) :-
    gdpr_transfer_dpf_profile_for(recipient_off_list, Profile),
    data_privacy_framework_adequacy(Profile, not_covered_by_data_privacy_framework_adequacy, [], _).
test(route_referral_near_miss_denied_decision_is_not_referred, fail) :-
    status_of(decision_not_in_force, needs_legal_review(_, _)).
test(route_referral_near_miss_stated_coverage_is_not_referred, fail) :-
    status_of(all_conditions_hold, needs_legal_review(_, _)).
test(route_referral_list_statement_with_union_absent_is_not_indeterminate, fail) :-
    status_of(list_statement_absent_union_absent, indeterminate(_)).
test(route_indeterminate_near_miss_union_stated_is_not_indeterminate, fail) :-
    status_of(all_conditions_hold, indeterminate(_)).
test(route_indeterminate_recipient_does_not_name_the_union_key, fail) :-
    status_of(recipient_absent, indeterminate([transfer_from_union])).
test(route_input_problems_bare_boolean_gets_no_verdict, fail) :-
    status_of(bare_boolean_outside_fact, covered_by_data_privacy_framework_adequacy).
test(route_input_problems_near_miss_attested_value_has_none, fail) :-
    status_of(all_conditions_hold, input_problems(_)).
test(route_input_problems_unbound_attestation_gets_no_verdict, fail) :-
    status_of(unbound_attestation_argument, covered_by_data_privacy_framework_adequacy).

cp_test_names([both_result_atoms_are_in_the_status_table, route_covered_positive, near_miss_not_from_union_is_not_covered, near_miss_recipient_outside_united_states_is_not_covered, near_miss_decision_not_in_force_is_not_covered, near_miss_recipient_off_list_is_not_covered, near_miss_human_resources_data_not_declared_is_not_covered, a_false_crisp_key_decides_while_outside_facts_are_absent, a_false_crisp_key_has_an_empty_basis, route_referral_decision_statement_positive, route_referral_near_miss_denied_decision_decides, route_referral_coverage_statement_positive, route_referral_list_statement_with_union_absent_is_referred, route_indeterminate_union_positive, route_indeterminate_recipient_positive, route_input_problems_positive, route_input_problems_unbound_attestation_positive]).
cp_test_fail_names([route_covered_is_not_not_covered, near_miss_not_from_union_is_not_covered_by_the_decision, near_miss_recipient_outside_united_states_is_not_covered_by_the_decision, near_miss_decision_not_in_force_is_not_covered_by_the_decision, near_miss_recipient_off_list_is_not_covered_by_the_decision, near_miss_human_resources_data_not_declared_is_not_covered_by_the_decision, a_false_crisp_key_with_absent_facts_is_not_referred, a_denied_outside_fact_does_not_have_an_empty_basis, route_referral_near_miss_denied_decision_is_not_referred, route_referral_near_miss_stated_coverage_is_not_referred, route_referral_list_statement_with_union_absent_is_not_indeterminate, route_indeterminate_near_miss_union_stated_is_not_indeterminate, route_indeterminate_recipient_does_not_name_the_union_key, route_input_problems_bare_boolean_gets_no_verdict, route_input_problems_near_miss_attested_value_has_none, route_input_problems_unbound_attestation_gets_no_verdict]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
