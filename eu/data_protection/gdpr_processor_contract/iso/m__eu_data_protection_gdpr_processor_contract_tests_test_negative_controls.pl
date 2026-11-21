% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_processor_contract_tests_test_negative_controls, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_processor_contract_processor_contract_status, [processor_contract_status/2, processor_contract_status_status_values/1]).
:- use_module(m__eu_data_protection_gdpr_processor_contract_fixtures, [gdpr_processor_contract_profile_for/2]).

status_of(Subject, Status) :-
    gdpr_processor_contract_profile_for(Subject, Profile),
    processor_contract_status(Profile, Status).

test(the_near_miss_atoms_are_in_the_status_table) :-
    processor_contract_status_status_values(Values),
    member(eligible, Values),
    member(ineligible, Values),
    member(not_applicable, Values).
test(complete_contract_is_eligible) :-
    status_of(eligible_without_subprocessor, eligible).
test(missing_point_h_is_ineligible) :-
    status_of(near_miss_missing_point_h, ineligible).
test(partial_point_a_is_ineligible) :-
    status_of(near_miss_partial_point_a_recorded_false, ineligible).
test(third_country_law_is_ineligible) :-
    status_of(near_miss_third_country_law, ineligible).
test(insufficient_guarantees_are_ineligible) :-
    status_of(near_miss_insufficient_guarantees, ineligible).
test(not_on_behalf_is_not_applicable) :-
    status_of(not_applicable_not_on_behalf, not_applicable).
test(absent_role_is_indeterminate) :-
    status_of(role_processing_absent, indeterminate([processing_on_behalf_of_controller])).
test(unsure_role_refers) :-
    status_of(role_processing_unsure, needs_legal_review(open_textured(processing_on_behalf_of_controller, cite(eu_reg_2016_679_art_4_8)), _)).
test(controller_by_purposes_and_means_is_deferred) :-
    status_of(role_controller_deferred, needs_legal_review(deferred_provision(cite(eu_reg_2016_679_art_28_10)), _)).
test(unsure_purposes_and_means_is_open_textured) :-
    status_of(role_purposes_and_means_unsure, needs_legal_review(open_textured(processor_determines_purposes_and_means, cite(eu_reg_2016_679_art_28_10)), _)).
test(absent_purposes_and_means_is_indeterminate) :-
    status_of(role_purposes_and_means_absent, indeterminate([processor_determines_purposes_and_means])).
test(every_absent_checklist_key_is_listed) :-
    status_of(absent_keys_list_all, indeterminate([contract_in_writing, stipulates_security_measures])).
test(unmet_beside_absence_is_ineligible) :-
    status_of(near_miss_unmet_dominates_absence, ineligible).
test(unsure_binding_refers) :-
    status_of(checklist_binding_unsure, needs_legal_review(open_textured(contract_binding_on_processor, cite(eu_reg_2016_679_art_28_3)), _)).
test(specific_authorisation_is_eligible) :-
    status_of(eligible_specific_written_authorisation, eligible).
test(unsure_same_obligations_refer) :-
    status_of(subprocessor_obligations_unsure, needs_legal_review(open_textured(subprocessor_obligations_same, cite(eu_reg_2016_679_art_28_4)), _)).
test(no_authorisation_is_ineligible) :-
    status_of(near_miss_authorisation_none, ineligible).
test(general_authorisation_with_notice_is_eligible) :-
    status_of(eligible_general_written_authorisation, eligible).
test(general_authorisation_without_objection_is_ineligible) :-
    status_of(near_miss_general_written_without_objection_opportunity, ineligible).
test(malformed_standard_clauses_are_an_input_problem) :-
    status_of(near_miss_malformed_standard_clauses, input_problems([wrong_type(standard_clauses_adopted)])).
test(attested_standard_clauses_stay_eligible) :-
    status_of(eligible_with_standard_clauses_recorded, eligible).
test(unread_keys_stay_eligible) :-
    status_of(unread_keys_ignored, eligible).
test(mixed_problems_are_reported) :-
    status_of(input_problems_mixed, input_problems([wrong_type(contract_in_writing), duplicate_key(subprocessor_engaged), unknown_key(stray_key)])).

test(missing_point_h_is_not_eligible, fail) :-
    status_of(near_miss_missing_point_h, eligible).
test(complete_contract_is_not_ineligible, fail) :-
    status_of(eligible_without_subprocessor, ineligible).
test(third_country_law_is_not_eligible, fail) :-
    status_of(near_miss_third_country_law, eligible).
test(insufficient_guarantees_are_not_eligible, fail) :-
    status_of(near_miss_insufficient_guarantees, eligible).
test(not_on_behalf_is_not_eligible, fail) :-
    status_of(not_applicable_not_on_behalf, eligible).
test(complete_contract_is_not_not_applicable, fail) :-
    status_of(eligible_without_subprocessor, not_applicable).
test(complete_contract_is_not_indeterminate, fail) :-
    status_of(eligible_without_subprocessor, indeterminate(_)).
test(complete_contract_does_not_refer, fail) :-
    status_of(eligible_without_subprocessor, needs_legal_review(_, _)).
test(unsure_purposes_and_means_is_not_deferred, fail) :-
    status_of(role_purposes_and_means_unsure, needs_legal_review(deferred_provision(_), _)).
test(absent_purposes_and_means_is_not_eligible, fail) :-
    status_of(role_purposes_and_means_absent, eligible).
test(unmet_beside_absence_is_not_indeterminate, fail) :-
    status_of(near_miss_unmet_dominates_absence, indeterminate(_)).
test(unsure_binding_is_not_eligible, fail) :-
    status_of(checklist_binding_unsure, eligible).
test(specific_authorisation_does_not_refer, fail) :-
    status_of(eligible_specific_written_authorisation, needs_legal_review(_, _)).
test(specific_authorisation_is_not_ineligible, fail) :-
    status_of(eligible_specific_written_authorisation, ineligible).
test(general_authorisation_with_notice_is_not_ineligible, fail) :-
    status_of(eligible_general_written_authorisation, ineligible).
test(attested_standard_clauses_are_not_an_input_problem, fail) :-
    status_of(eligible_with_standard_clauses_recorded, input_problems(_)).
test(unread_keys_are_not_an_input_problem, fail) :-
    status_of(unread_keys_ignored, input_problems(_)).

cp_test_names([the_near_miss_atoms_are_in_the_status_table, complete_contract_is_eligible, missing_point_h_is_ineligible, partial_point_a_is_ineligible, third_country_law_is_ineligible, insufficient_guarantees_are_ineligible, not_on_behalf_is_not_applicable, absent_role_is_indeterminate, unsure_role_refers, controller_by_purposes_and_means_is_deferred, unsure_purposes_and_means_is_open_textured, absent_purposes_and_means_is_indeterminate, every_absent_checklist_key_is_listed, unmet_beside_absence_is_ineligible, unsure_binding_refers, specific_authorisation_is_eligible, unsure_same_obligations_refer, no_authorisation_is_ineligible, general_authorisation_with_notice_is_eligible, general_authorisation_without_objection_is_ineligible, malformed_standard_clauses_are_an_input_problem, attested_standard_clauses_stay_eligible, unread_keys_stay_eligible, mixed_problems_are_reported]).
cp_test_fail_names([missing_point_h_is_not_eligible, complete_contract_is_not_ineligible, third_country_law_is_not_eligible, insufficient_guarantees_are_not_eligible, not_on_behalf_is_not_eligible, complete_contract_is_not_not_applicable, complete_contract_is_not_indeterminate, complete_contract_does_not_refer, unsure_purposes_and_means_is_not_deferred, absent_purposes_and_means_is_not_eligible, unmet_beside_absence_is_not_indeterminate, unsure_binding_is_not_eligible, specific_authorisation_does_not_refer, specific_authorisation_is_not_ineligible, general_authorisation_with_notice_is_not_ineligible, attested_standard_clauses_are_not_an_input_problem, unread_keys_are_not_an_input_problem]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
