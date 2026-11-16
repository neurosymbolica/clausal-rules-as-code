% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_records_and_officer_tests_test_negative_controls, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_records_and_officer_gdpr_records_and_officer, [gdpr_records_and_officer_status/2, gdpr_records_and_officer_status_values/1, record_obligation/2, data_protection_officer_designation/2, officer_missing_tasks/2, officer_position_status/5]).
:- use_module(m__eu_data_protection_gdpr_records_and_officer_fixtures, [gdpr_records_and_officer_profile_for/2]).

control_attestation(attestation(control_host, control_moment, control_reason, document(upload_identifier, digest))).

test(record_required_is_a_verdict_atom) :-
    gdpr_records_and_officer_status_values(StatusValues),
    member(record_required, StatusValues).
test(record_not_required_is_a_verdict_atom) :-
    gdpr_records_and_officer_status_values(StatusValues),
    member(record_not_required, StatusValues).
test(record_unresolved_is_a_verdict_atom) :-
    gdpr_records_and_officer_status_values(StatusValues),
    member(record_unresolved, StatusValues).
test(ceiling_positive_249_is_exempt) :-
    gdpr_records_and_officer_profile_for(small_controller_exempt_at_249, Profile),
    gdpr_records_and_officer_status(Profile, record_not_required).
test(trigger_positive_special_categories_owe_the_record) :-
    gdpr_records_and_officer_profile_for(small_processor_special_categories, Profile),
    gdpr_records_and_officer_status(Profile, record_required).
test(roles_positive_neither_is_unresolved) :-
    gdpr_records_and_officer_profile_for(neither_role_entity, Profile),
    gdpr_records_and_officer_status(Profile, record_unresolved).
test(occasional_positive_unsure_is_referred) :-
    gdpr_records_and_officer_profile_for(unsure_occasional_controller, Profile),
    record_obligation(Profile, needs_legal_review(open_textured(processing_is_occasional, cite(eu_reg_2016_679_art_30_5)), _Context)).
test(headcount_positive_absent_is_named) :-
    gdpr_records_and_officer_profile_for(headcount_absent_controller, Profile),
    record_obligation(Profile, indeterminate([persons_employed])).
test(limb_a_positive_public_authority_designates) :-
    gdpr_records_and_officer_profile_for(public_authority_controller, Profile),
    data_protection_officer_designation(Profile, [designate_data_protection_officer(cite(eu_reg_2016_679_art_37_1_a))]).
test(law_positive_requirement_designates) :-
    gdpr_records_and_officer_profile_for(member_state_law_requires_officer, Profile),
    data_protection_officer_designation(Profile, [designate_data_protection_officer(cite(eu_reg_2016_679_art_37_4))]).
test(law_near_miss_answer_is_no_designation_required) :-
    gdpr_records_and_officer_profile_for(member_state_law_does_not_require_officer, Profile),
    data_protection_officer_designation(Profile, [no_designation_required(cite(eu_reg_2016_679_art_37_4))]).
test(tasks_positive_lacking_contact_point_is_listed) :-
    gdpr_records_and_officer_profile_for(officer_mandate_lacks_contact_point, Profile),
    officer_missing_tasks(Profile, [missing_officer_task(acting_as_contact_point, cite(eu_reg_2016_679_art_39_1_e))]).
test(input_positive_duplicate_headcount_is_a_problem) :-
    gdpr_records_and_officer_profile_for(duplicate_headcount_malformed, Profile),
    record_obligation(Profile, input_problems([duplicate_key(persons_employed)])).
test(statement_positive_attested_true_is_met) :-
    control_attestation(Attestation),
    officer_position_status([attribute(officer_free_of_instructions_and_penalty, attested(true, Attestation))], no_instructions_or_penalty, met, _Basis, [cite(eu_reg_2016_679_art_38_3)]).
test(statement_near_miss_answer_is_not_met) :-
    control_attestation(Attestation),
    officer_position_status([attribute(officer_free_of_instructions_and_penalty, attested(false, Attestation))], no_instructions_or_penalty, not_met, _Basis, [cite(eu_reg_2016_679_art_38_3)]).
test(conflict_positive_no_conflict_is_met) :-
    officer_position_status([attribute(officer_other_tasks_result_in_conflict_of_interests, false)], conflict_of_interests, met, [], [cite(eu_reg_2016_679_art_38_6)]).
test(duty_positive_known_duty_answers) :-
    officer_position_status([], involvement, needs_legal_review(_Reason, _Context), [], []).

test(ceiling_near_miss_250_is_not_exempt, fail) :-
    gdpr_records_and_officer_profile_for(controller_at_ceiling_250, Profile),
    gdpr_records_and_officer_status(Profile, record_not_required).
test(trigger_near_miss_without_trigger_owes_nothing, fail) :-
    gdpr_records_and_officer_profile_for(small_processor_without_trigger, Profile),
    gdpr_records_and_officer_status(Profile, record_required).
test(roles_near_miss_controller_is_resolved, fail) :-
    gdpr_records_and_officer_profile_for(controller_role_entity, Profile),
    gdpr_records_and_officer_status(Profile, record_unresolved).
test(occasional_near_miss_false_is_not_referred, fail) :-
    gdpr_records_and_officer_profile_for(not_occasional_controller, Profile),
    record_obligation(Profile, needs_legal_review(_Reason, _Context)).
test(headcount_near_miss_present_is_not_indeterminate, fail) :-
    gdpr_records_and_officer_profile_for(controller_at_ceiling_250, Profile),
    record_obligation(Profile, indeterminate(_MissingKeys)).
test(limb_a_near_miss_court_does_not_designate, fail) :-
    gdpr_records_and_officer_profile_for(court_in_judicial_capacity_controller, Profile),
    data_protection_officer_designation(Profile, [designate_data_protection_officer(_Citation)]).
test(law_near_miss_no_requirement_does_not_designate, fail) :-
    gdpr_records_and_officer_profile_for(member_state_law_does_not_require_officer, Profile),
    data_protection_officer_designation(Profile, [designate_data_protection_officer(_Citation)]).
test(tasks_near_miss_complete_mandate_lists_nothing, fail) :-
    gdpr_records_and_officer_profile_for(officer_mandate_complete, Profile),
    officer_missing_tasks(Profile, [_|_]).
test(input_near_miss_single_headcount_is_no_problem, fail) :-
    gdpr_records_and_officer_profile_for(controller_role_entity, Profile),
    record_obligation(Profile, input_problems(_Problems)).
test(statement_near_miss_attested_false_is_not_met, fail) :-
    control_attestation(Attestation),
    officer_position_status([attribute(officer_free_of_instructions_and_penalty, attested(false, Attestation))], no_instructions_or_penalty, met, _Basis, _Citations).
test(conflict_near_miss_a_conflict_is_not_met, fail) :-
    officer_position_status([attribute(officer_other_tasks_result_in_conflict_of_interests, true)], conflict_of_interests, met, _Basis, _Citations).
test(duty_near_miss_unknown_duty_has_no_solution, fail) :-
    officer_position_status([], publication_of_contact_details, _Result, _Basis, _Citations).

cp_test_names([record_required_is_a_verdict_atom, record_not_required_is_a_verdict_atom, record_unresolved_is_a_verdict_atom, ceiling_positive_249_is_exempt, trigger_positive_special_categories_owe_the_record, roles_positive_neither_is_unresolved, occasional_positive_unsure_is_referred, headcount_positive_absent_is_named, limb_a_positive_public_authority_designates, law_positive_requirement_designates, law_near_miss_answer_is_no_designation_required, tasks_positive_lacking_contact_point_is_listed, input_positive_duplicate_headcount_is_a_problem, statement_positive_attested_true_is_met, statement_near_miss_answer_is_not_met, conflict_positive_no_conflict_is_met, duty_positive_known_duty_answers]).
cp_test_fail_names([ceiling_near_miss_250_is_not_exempt, trigger_near_miss_without_trigger_owes_nothing, roles_near_miss_controller_is_resolved, occasional_near_miss_false_is_not_referred, headcount_near_miss_present_is_not_indeterminate, limb_a_near_miss_court_does_not_designate, law_near_miss_no_requirement_does_not_designate, tasks_near_miss_complete_mandate_lists_nothing, input_near_miss_single_headcount_is_no_problem, statement_near_miss_attested_false_is_not_met, conflict_near_miss_a_conflict_is_not_met, duty_near_miss_unknown_duty_has_no_solution]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
