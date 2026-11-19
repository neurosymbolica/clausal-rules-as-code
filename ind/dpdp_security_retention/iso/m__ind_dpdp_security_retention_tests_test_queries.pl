% SPDX-License-Identifier: EUPL-1.2
:- module(m__ind_dpdp_security_retention_tests_test_queries, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__ind_dpdp_security_retention_queries, [dpdp_security_retention_profile_keys/1, dpdp_security_retention_what_if/4, not_in_force/0, erase/0, deemed_no_longer_served/0]).
:- use_module(m__ind_dpdp_security_retention_kernel, [dpdp_security_retention_input_problems/2]).
:- use_module(m__ind_dpdp_security_retention_dpdp_security_retention, [dpdp_security_retention_status/2, dpdp_security_retention_checklist/2]).
:- use_module(m__ind_dpdp_security_retention_fixtures, [dpdp_security_retention_profile_for/2]).

test(profile_keys_are_the_contract_keys) :-
    dpdp_security_retention_profile_keys(ProfileKeys),
    ProfileKeys == [section_8_3_in_force, section_8_5_in_force, section_8_7_in_force, section_8_8_in_force, acts_as_data_fiduciary, likely_used_for_decision_affecting_data_principal, likely_disclosed_to_another_data_fiduciary, retention_necessary_for_compliance_with_law, consent_withdrawn, specified_purpose_no_longer_served, assessment_date, last_processing_date, data_made_available_to_data_processor, third_schedule_class, registered_users_in_india, third_schedule_purpose_excepted, last_approached_date].
test(profile_keys_are_seventeen_and_distinct) :-
    dpdp_security_retention_profile_keys(ProfileKeys),
    length(ProfileKeys, KeyCount),
    KeyCount =:= 17,
    sort(ProfileKeys, KeySet),
    length(KeySet, KeyCount).
test(input_problems_reexported_from_queries) :-
    findall(Problems, dpdp_security_retention_input_problems([attribute(colour, blue)], Problems), Answers),
    Answers == [[unknown_key(colour)]].
test(input_problems_reexported_accepts_a_good_profile) :-
    dpdp_security_retention_profile_for(processor_now_fiduciary, Profile),
    dpdp_security_retention_input_problems(Profile, []).
test(what_if_turns_a_processor_into_a_fiduciary) :-
    dpdp_security_retention_profile_for(processor_not_fiduciary, Profile),
    findall(Status, dpdp_security_retention_what_if(Profile, acts_as_data_fiduciary, true, Status), Statuses),
    Statuses == [section_8_duty_owed].
test(what_if_unchanged_value_keeps_the_status) :-
    dpdp_security_retention_profile_for(processor_not_fiduciary, Profile),
    dpdp_security_retention_status(Profile, BaselineStatus),
    dpdp_security_retention_what_if(Profile, acts_as_data_fiduciary, false, WhatIfStatus),
    WhatIfStatus == BaselineStatus.
test(what_if_other_law_settles_the_bank) :-
    dpdp_security_retention_profile_for(bank_no_other_law, Profile),
    dpdp_security_retention_what_if(Profile, retention_necessary_for_compliance_with_law, true, Status),
    Status == section_8_duty_owed.
test(what_if_adds_a_last_approach_on_the_day_after_the_floor) :-
    dpdp_security_retention_profile_for(e_commerce_day_after_deeming_floor, Profile),
    dpdp_security_retention_what_if(Profile, last_approached_date, date(2027, 6, 1), Status),
    Status == no_section_8_duty_owed.
test(what_if_moves_the_floor_assessment_a_day_on) :-
    dpdp_security_retention_profile_for(e_commerce_on_deeming_floor, Profile),
    dpdp_security_retention_what_if(Profile, assessment_date, date(2030, 5, 14), Status),
    Status == section_8_duty_undetermined.
test(what_if_with_a_bad_value_is_rejected) :-
    dpdp_security_retention_what_if([], section_8_5_in_force, maybe, Status),
    Status == profile_rejected.
test(what_if_clears_a_duplicate_key) :-
    dpdp_security_retention_status([attribute(consent_withdrawn, true), attribute(consent_withdrawn, false)], profile_rejected),
    dpdp_security_retention_what_if([attribute(consent_withdrawn, true), attribute(consent_withdrawn, false)], consent_withdrawn, true, Status),
    Status == section_8_duty_undetermined.
test(status_query_answers_once) :-
    dpdp_security_retention_profile_for(gaming_at_threshold, Profile),
    findall(Status, dpdp_security_retention_status(Profile, Status), Statuses),
    Statuses == [no_section_8_duty_owed].
test(checklist_query_names_the_four_profile_queries) :-
    dpdp_security_retention_profile_for(empty_profile, Profile),
    dpdp_security_retention_checklist(Profile, Items),
    findall(Name, member(item(Name, _, _), Items), Names),
    Names == [security_safeguards_duty, accuracy_duty, erasure_duty, third_schedule_deemed_no_longer_served].
test(root_result_atoms_resolve) :-
    not_in_force,
    erase,
    deemed_no_longer_served.

test(what_if_on_an_unbound_profile_has_no_answer, fail) :-
    dpdp_security_retention_what_if(_UnboundProfile, consent_withdrawn, true, _).

cp_test_names([profile_keys_are_the_contract_keys, profile_keys_are_seventeen_and_distinct, input_problems_reexported_from_queries, input_problems_reexported_accepts_a_good_profile, what_if_turns_a_processor_into_a_fiduciary, what_if_unchanged_value_keeps_the_status, what_if_other_law_settles_the_bank, what_if_adds_a_last_approach_on_the_day_after_the_floor, what_if_moves_the_floor_assessment_a_day_on, what_if_with_a_bad_value_is_rejected, what_if_clears_a_duplicate_key, status_query_answers_once, checklist_query_names_the_four_profile_queries, root_result_atoms_resolve]).
cp_test_fail_names([what_if_on_an_unbound_profile_has_no_answer]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
