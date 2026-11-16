% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_records_and_officer_tests_test_input_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_records_and_officer_kernel, [gdpr_records_and_officer_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_records_and_officer_gdpr_records_and_officer, [gdpr_records_and_officer_status/2, record_obligation/2, record_missing_items/2, data_protection_officer_designation/2, officer_missing_tasks/2, officer_position_status/5]).
:- use_module(m__eu_data_protection_gdpr_records_and_officer_fixtures, [gdpr_records_and_officer_profile_for/2]).

input_attestation(attestation(input_host, input_moment, input_reason, none)).

test(exempt_status_holds_with_the_status_bound) :-
    gdpr_records_and_officer_profile_for(small_controller_exempt_at_249, Profile),
    gdpr_records_and_officer_status(Profile, record_not_required).
test(ceiling_profile_owes_the_bound_controller_record) :-
    gdpr_records_and_officer_profile_for(controller_at_ceiling_250, Profile),
    record_obligation(Profile, [keep_controller_record(cite(eu_reg_2016_679_art_30_1))]).
test(exempt_profile_misses_no_bound_item) :-
    gdpr_records_and_officer_profile_for(small_controller_exempt_at_249, Profile),
    record_missing_items(Profile, []).
test(public_authority_designation_is_bound) :-
    gdpr_records_and_officer_profile_for(public_authority_controller, Profile),
    data_protection_officer_designation(Profile, [designate_data_protection_officer(cite(eu_reg_2016_679_art_37_1_a))]).
test(missing_contact_point_is_bound) :-
    gdpr_records_and_officer_profile_for(officer_mandate_lacks_contact_point, Profile),
    officer_missing_tasks(Profile, [missing_officer_task(acting_as_contact_point, cite(eu_reg_2016_679_art_39_1_e))]).
test(attested_reporting_line_is_met_with_the_result_bound) :-
    input_attestation(Attestation),
    officer_position_status([attribute(officer_reports_to_highest_management_level, attested(true, Attestation))], direct_reporting, met, [outside_fact(officer_reports_to_highest_management_level, attested(true, Attestation))], [cite(eu_reg_2016_679_art_38_3)]).
test(a_well_formed_profile_has_no_problem) :-
    gdpr_records_and_officer_profile_for(controller_at_ceiling_250, Profile),
    gdpr_records_and_officer_input_problems(Profile, []).
test(a_non_attribute_element_is_wrong_type) :-
    gdpr_records_and_officer_input_problems([attribute(acts_as_controller, true), colour], Problems),
    Problems == [wrong_type(profile)].
test(a_negative_headcount_is_wrong_type) :-
    gdpr_records_and_officer_input_problems([attribute(persons_employed, -1)], Problems),
    Problems == [wrong_type(persons_employed)].
test(a_float_headcount_is_wrong_type) :-
    gdpr_records_and_officer_input_problems([attribute(persons_employed, 10.0)], Problems),
    Problems == [wrong_type(persons_employed)].
test(unsure_for_a_crisp_flag_is_wrong_type) :-
    gdpr_records_and_officer_input_problems([attribute(acts_as_controller, unsure)], Problems),
    Problems == [wrong_type(acts_as_controller)].
test(unsure_for_a_judgement_is_well_typed) :-
    gdpr_records_and_officer_input_problems([attribute(processing_is_occasional, unsure)], []).
test(a_bare_boolean_outside_fact_is_wrong_type) :-
    gdpr_records_and_officer_input_problems([attribute(is_public_authority_or_body, true)], Problems),
    Problems == [wrong_type(is_public_authority_or_body)].
test(an_unsure_attested_value_is_wrong_type) :-
    input_attestation(Attestation),
    gdpr_records_and_officer_input_problems([attribute(is_public_authority_or_body, attested(unsure, Attestation))], Problems),
    Problems == [wrong_type(is_public_authority_or_body)].
test(a_duplicate_key_is_named_once_without_wrong_type) :-
    gdpr_records_and_officer_input_problems([attribute(acts_as_controller, true), attribute(acts_as_controller, banana)], Problems),
    Problems == [duplicate_key(acts_as_controller)].
test(an_unknown_key_is_named_once) :-
    gdpr_records_and_officer_input_problems([attribute(colour, red), attribute(colour, blue)], Problems),
    Problems == [unknown_key(colour)].
test(a_numeric_key_is_an_unknown_key) :-
    gdpr_records_and_officer_input_problems([attribute(42, value)], Problems),
    Problems == [unknown_key(42)].
test(problems_follow_contract_order_then_unknown_keys) :-
    gdpr_records_and_officer_input_problems([attribute(colour, red), attribute(persons_employed, -3), attribute(acts_as_controller, maybe)], Problems),
    Problems == [wrong_type(acts_as_controller), wrong_type(persons_employed), unknown_key(colour)].
test(a_query_on_a_non_list_gives_input_problems) :-
    record_obligation(not_a_list, input_problems([wrong_type(profile)])).
test(the_position_query_reports_input_problems_in_its_result) :-
    officer_position_status([attribute(colour, red)], involvement, input_problems([unknown_key(colour)]), [], []).

test(exempt_profile_rejects_record_required, fail) :-
    gdpr_records_and_officer_profile_for(small_controller_exempt_at_249, Profile),
    gdpr_records_and_officer_status(Profile, record_required).
test(ceiling_profile_rejects_the_exemption, fail) :-
    gdpr_records_and_officer_profile_for(controller_at_ceiling_250, Profile),
    record_obligation(Profile, [no_record_required(_)]).
test(public_authority_is_not_bound_to_article_37_4, fail) :-
    gdpr_records_and_officer_profile_for(public_authority_controller, Profile),
    data_protection_officer_designation(Profile, [designate_data_protection_officer(cite(eu_reg_2016_679_art_37_4))]).
test(complete_mandate_rejects_a_missing_task, fail) :-
    gdpr_records_and_officer_profile_for(officer_mandate_complete, Profile),
    officer_missing_tasks(Profile, [_|_]).
test(attested_reporting_line_is_not_not_met, fail) :-
    input_attestation(Attestation),
    officer_position_status([attribute(officer_reports_to_highest_management_level, attested(true, Attestation))], direct_reporting, not_met, _, _).

cp_test_names([exempt_status_holds_with_the_status_bound, ceiling_profile_owes_the_bound_controller_record, exempt_profile_misses_no_bound_item, public_authority_designation_is_bound, missing_contact_point_is_bound, attested_reporting_line_is_met_with_the_result_bound, a_well_formed_profile_has_no_problem, a_non_attribute_element_is_wrong_type, a_negative_headcount_is_wrong_type, a_float_headcount_is_wrong_type, unsure_for_a_crisp_flag_is_wrong_type, unsure_for_a_judgement_is_well_typed, a_bare_boolean_outside_fact_is_wrong_type, an_unsure_attested_value_is_wrong_type, a_duplicate_key_is_named_once_without_wrong_type, an_unknown_key_is_named_once, a_numeric_key_is_an_unknown_key, problems_follow_contract_order_then_unknown_keys, a_query_on_a_non_list_gives_input_problems, the_position_query_reports_input_problems_in_its_result]).
cp_test_fail_names([exempt_profile_rejects_record_required, ceiling_profile_rejects_the_exemption, public_authority_is_not_bound_to_article_37_4, complete_mandate_rejects_a_missing_task, attested_reporting_line_is_not_not_met]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
