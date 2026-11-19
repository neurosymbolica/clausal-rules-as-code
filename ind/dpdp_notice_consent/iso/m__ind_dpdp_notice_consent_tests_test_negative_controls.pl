% SPDX-License-Identifier: EUPL-1.2
:- module(m__ind_dpdp_notice_consent_tests_test_negative_controls, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__ind_dpdp_notice_consent_dpdp_notice_consent, [consent_ground/3, legitimate_use_ground/3, consent_notice/3, withdrawal_effect/3, consent_manager_status/3, dpdp_notice_consent_status/2, dpdp_notice_consent_status_values/1]).
:- use_module(m__ind_dpdp_notice_consent_fixtures, [dpdp_notice_consent_profile_for/2]).

answer(Subject, QueryName, Result) :-
    dpdp_notice_consent_profile_for(Subject, Profile),
    query_result(QueryName, Profile, Result).

query_result(consent_ground, Profile, Result) :-
    consent_ground(Profile, Result, _).
query_result(legitimate_use_ground, Profile, Result) :-
    legitimate_use_ground(Profile, Result, _).
query_result(consent_notice, Profile, Result) :-
    consent_notice(Profile, Result, _).
query_result(withdrawal_effect, Profile, Result) :-
    withdrawal_effect(Profile, Result, _).
query_result(consent_manager_status, Profile, Result) :-
    consent_manager_status(Profile, Result, _).

query_vocabulary(consent_ground, [lawful_on_consent, not_lawful_on_consent, not_in_force]).
query_vocabulary(legitimate_use_ground, [lawful_on_legitimate_use, not_lawful_on_legitimate_use, not_in_force]).
query_vocabulary(consent_notice, [notice_with_request_required, notice_with_request_required_before_rule_3, notice_for_earlier_consent_required, notice_for_earlier_consent_required_before_rule_3, not_required, not_in_force]).
query_vocabulary(withdrawal_effect, [cease_processing_required, processing_may_continue_without_consent, not_required, not_in_force]).
query_vocabulary(consent_manager_status, [may_act_as_consent_manager, may_not_act_as_consent_manager, not_in_force]).

in_vocabulary(QueryName, Atom) :-
    query_vocabulary(QueryName, Atoms),
    member(Atom, Atoms).

test(consent_lawful_positive) :-
    answer(consent_lawful, consent_ground, lawful_on_consent).
test(consent_withdrawn_near_miss_positive) :-
    answer(consent_withdrawn, consent_ground, not_lawful_on_consent).
test(consent_not_given_near_miss_positive) :-
    answer(consent_not_given, consent_ground, not_lawful_on_consent).
test(consent_purpose_forbidden_near_miss_positive) :-
    answer(consent_purpose_forbidden, consent_ground, not_lawful_on_consent).
test(consent_fails_section_6_1_near_miss_positive) :-
    answer(consent_fails_section_6_1, consent_ground, not_lawful_on_consent).
test(consent_sections_not_in_force_positive) :-
    answer(consent_sections_not_in_force, consent_ground, not_in_force).
test(consent_in_force_absent_positive) :-
    answer(consent_in_force_absent, consent_ground, indeterminate([sections_4_to_7_in_force])).
test(consent_purpose_unsure_positive) :-
    answer(consent_purpose_unsure, consent_ground, needs_legal_review(_, _)).
test(consent_section_6_1_unsure_positive) :-
    answer(consent_section_6_1_unsure, consent_ground, needs_legal_review(open_textured(consent_meets_section_6_1, _), _)).
test(consent_wrong_type_positive) :-
    answer(consent_wrong_type, consent_ground, input_problems([wrong_type(consent_given)])).
test(legitimate_use_employment_positive) :-
    answer(legitimate_use_employment, legitimate_use_ground, lawful_on_legitimate_use).
test(legitimate_use_conditions_unmet_near_miss_positive) :-
    answer(legitimate_use_conditions_unmet, legitimate_use_ground, not_lawful_on_legitimate_use).
test(legitimate_use_no_listed_use_near_miss_positive) :-
    answer(legitimate_use_no_listed_use, legitimate_use_ground, not_lawful_on_legitimate_use).
test(legitimate_use_conditions_unsure_positive) :-
    answer(legitimate_use_conditions_unsure, legitimate_use_ground, needs_legal_review(_, _)).
test(notice_request_on_rule_3_day_positive) :-
    answer(notice_request_on_rule_3_day, consent_notice, notice_with_request_required).
test(notice_request_before_rule_3_near_miss_positive) :-
    answer(notice_request_before_rule_3, consent_notice, notice_with_request_required_before_rule_3).
test(notice_earlier_consent_on_rule_3_day_positive) :-
    answer(notice_earlier_consent_on_rule_3_day, consent_notice, notice_for_earlier_consent_required).
test(notice_earlier_consent_before_rule_3_near_miss_positive) :-
    answer(notice_earlier_consent_before_rule_3, consent_notice, notice_for_earlier_consent_required_before_rule_3).
test(notice_processor_near_miss_positive) :-
    answer(notice_processor, consent_notice, not_required).
test(notice_no_occasion_near_miss_positive) :-
    answer(notice_no_occasion, consent_notice, not_required).
test(notice_fiduciary_unsure_positive) :-
    answer(notice_fiduciary_unsure, consent_notice, needs_legal_review(_, _)).
test(withdrawal_cease_positive) :-
    answer(withdrawal_cease, withdrawal_effect, cease_processing_required).
test(withdrawal_may_continue_near_miss_positive) :-
    answer(withdrawal_may_continue, withdrawal_effect, processing_may_continue_without_consent).
test(withdrawal_not_withdrawn_near_miss_positive) :-
    answer(withdrawal_not_withdrawn, withdrawal_effect, not_required).
test(withdrawal_law_unsure_positive) :-
    answer(withdrawal_law_unsure, withdrawal_effect, needs_legal_review(_, _)).
test(manager_registered_positive) :-
    answer(manager_registered, consent_manager_status, may_act_as_consent_manager).
test(manager_suspended_near_miss_positive) :-
    answer(manager_suspended, consent_manager_status, may_not_act_as_consent_manager).
test(manager_unregistered_near_miss_positive) :-
    answer(manager_unregistered, consent_manager_status, may_not_act_as_consent_manager).
test(manager_section_not_in_force_positive) :-
    answer(manager_section_not_in_force, consent_manager_status, not_in_force).
test(facade_lawful_positive) :-
    dpdp_notice_consent_profile_for(consent_lawful, Profile),
    dpdp_notice_consent_status(Profile, eligible).
test(facade_withdrawn_near_miss_positive) :-
    dpdp_notice_consent_profile_for(consent_withdrawn, Profile),
    dpdp_notice_consent_status(Profile, ineligible).
test(the_near_miss_atoms_are_vocabulary_atoms) :-
    in_vocabulary(consent_ground, lawful_on_consent),
    in_vocabulary(consent_ground, not_lawful_on_consent),
    in_vocabulary(consent_ground, not_in_force),
    in_vocabulary(legitimate_use_ground, lawful_on_legitimate_use),
    in_vocabulary(legitimate_use_ground, not_lawful_on_legitimate_use),
    in_vocabulary(consent_notice, notice_with_request_required),
    in_vocabulary(consent_notice, notice_with_request_required_before_rule_3),
    in_vocabulary(consent_notice, notice_for_earlier_consent_required),
    in_vocabulary(consent_notice, notice_for_earlier_consent_required_before_rule_3),
    in_vocabulary(consent_notice, not_required),
    in_vocabulary(withdrawal_effect, cease_processing_required),
    in_vocabulary(withdrawal_effect, processing_may_continue_without_consent),
    in_vocabulary(withdrawal_effect, not_required),
    in_vocabulary(consent_manager_status, may_act_as_consent_manager),
    in_vocabulary(consent_manager_status, may_not_act_as_consent_manager),
    in_vocabulary(consent_manager_status, not_in_force).
test(the_facade_status_table_holds_the_near_miss_statuses) :-
    dpdp_notice_consent_status_values(StatusValues),
    member(eligible, StatusValues),
    member(ineligible, StatusValues),
    member(indeterminate, StatusValues).

test(consent_withdrawn_near_miss_is_not_lawful, fail) :-
    answer(consent_withdrawn, consent_ground, lawful_on_consent).
test(consent_not_given_near_miss_is_not_lawful, fail) :-
    answer(consent_not_given, consent_ground, lawful_on_consent).
test(consent_purpose_forbidden_near_miss_is_not_lawful, fail) :-
    answer(consent_purpose_forbidden, consent_ground, lawful_on_consent).
test(consent_fails_section_6_1_near_miss_is_not_lawful, fail) :-
    answer(consent_fails_section_6_1, consent_ground, lawful_on_consent).
test(consent_sections_not_in_force_is_not_lawful, fail) :-
    answer(consent_sections_not_in_force, consent_ground, lawful_on_consent).
test(consent_lawful_is_not_in_force_refused, fail) :-
    answer(consent_lawful, consent_ground, not_in_force).
test(consent_in_force_absent_is_not_lawful, fail) :-
    answer(consent_in_force_absent, consent_ground, lawful_on_consent).
test(consent_purpose_unsure_is_not_decided, fail) :-
    answer(consent_purpose_unsure, consent_ground, lawful_on_consent).
test(consent_lawful_is_not_referred, fail) :-
    answer(consent_lawful, consent_ground, needs_legal_review(_, _)).
test(consent_section_6_1_unsure_is_not_decided, fail) :-
    answer(consent_section_6_1_unsure, consent_ground, lawful_on_consent).
test(consent_wrong_type_is_not_decided, fail) :-
    answer(consent_wrong_type, consent_ground, not_lawful_on_consent).
test(legitimate_use_conditions_unmet_is_not_lawful, fail) :-
    answer(legitimate_use_conditions_unmet, legitimate_use_ground, lawful_on_legitimate_use).
test(legitimate_use_no_listed_use_is_not_lawful, fail) :-
    answer(legitimate_use_no_listed_use, legitimate_use_ground, lawful_on_legitimate_use).
test(legitimate_use_conditions_unsure_is_not_decided, fail) :-
    answer(legitimate_use_conditions_unsure, legitimate_use_ground, lawful_on_legitimate_use).
test(notice_request_before_rule_3_is_not_under_rule_3, fail) :-
    answer(notice_request_before_rule_3, consent_notice, notice_with_request_required).
test(notice_request_on_rule_3_day_is_not_before_rule_3, fail) :-
    answer(notice_request_on_rule_3_day, consent_notice, notice_with_request_required_before_rule_3).
test(notice_earlier_consent_before_rule_3_is_not_under_rule_3, fail) :-
    answer(notice_earlier_consent_before_rule_3, consent_notice, notice_for_earlier_consent_required).
test(notice_earlier_consent_is_not_a_request_notice, fail) :-
    answer(notice_earlier_consent_on_rule_3_day, consent_notice, notice_with_request_required).
test(notice_processor_owes_no_notice, fail) :-
    answer(notice_processor, consent_notice, notice_with_request_required).
test(notice_no_occasion_owes_no_notice, fail) :-
    answer(notice_no_occasion, consent_notice, notice_with_request_required).
test(notice_fiduciary_unsure_is_not_decided, fail) :-
    answer(notice_fiduciary_unsure, consent_notice, notice_with_request_required).
test(withdrawal_may_continue_need_not_cease, fail) :-
    answer(withdrawal_may_continue, withdrawal_effect, cease_processing_required).
test(withdrawal_cease_may_not_continue, fail) :-
    answer(withdrawal_cease, withdrawal_effect, processing_may_continue_without_consent).
test(withdrawal_not_withdrawn_need_not_cease, fail) :-
    answer(withdrawal_not_withdrawn, withdrawal_effect, cease_processing_required).
test(withdrawal_law_unsure_is_not_decided, fail) :-
    answer(withdrawal_law_unsure, withdrawal_effect, cease_processing_required).
test(manager_suspended_may_not_act, fail) :-
    answer(manager_suspended, consent_manager_status, may_act_as_consent_manager).
test(manager_unregistered_may_not_act, fail) :-
    answer(manager_unregistered, consent_manager_status, may_act_as_consent_manager).
test(manager_section_not_in_force_may_not_act, fail) :-
    answer(manager_section_not_in_force, consent_manager_status, may_act_as_consent_manager).
test(facade_withdrawn_is_not_eligible, fail) :-
    dpdp_notice_consent_profile_for(consent_withdrawn, Profile),
    dpdp_notice_consent_status(Profile, eligible).

cp_test_names([consent_lawful_positive, consent_withdrawn_near_miss_positive, consent_not_given_near_miss_positive, consent_purpose_forbidden_near_miss_positive, consent_fails_section_6_1_near_miss_positive, consent_sections_not_in_force_positive, consent_in_force_absent_positive, consent_purpose_unsure_positive, consent_section_6_1_unsure_positive, consent_wrong_type_positive, legitimate_use_employment_positive, legitimate_use_conditions_unmet_near_miss_positive, legitimate_use_no_listed_use_near_miss_positive, legitimate_use_conditions_unsure_positive, notice_request_on_rule_3_day_positive, notice_request_before_rule_3_near_miss_positive, notice_earlier_consent_on_rule_3_day_positive, notice_earlier_consent_before_rule_3_near_miss_positive, notice_processor_near_miss_positive, notice_no_occasion_near_miss_positive, notice_fiduciary_unsure_positive, withdrawal_cease_positive, withdrawal_may_continue_near_miss_positive, withdrawal_not_withdrawn_near_miss_positive, withdrawal_law_unsure_positive, manager_registered_positive, manager_suspended_near_miss_positive, manager_unregistered_near_miss_positive, manager_section_not_in_force_positive, facade_lawful_positive, facade_withdrawn_near_miss_positive, the_near_miss_atoms_are_vocabulary_atoms, the_facade_status_table_holds_the_near_miss_statuses]).
cp_test_fail_names([consent_withdrawn_near_miss_is_not_lawful, consent_not_given_near_miss_is_not_lawful, consent_purpose_forbidden_near_miss_is_not_lawful, consent_fails_section_6_1_near_miss_is_not_lawful, consent_sections_not_in_force_is_not_lawful, consent_lawful_is_not_in_force_refused, consent_in_force_absent_is_not_lawful, consent_purpose_unsure_is_not_decided, consent_lawful_is_not_referred, consent_section_6_1_unsure_is_not_decided, consent_wrong_type_is_not_decided, legitimate_use_conditions_unmet_is_not_lawful, legitimate_use_no_listed_use_is_not_lawful, legitimate_use_conditions_unsure_is_not_decided, notice_request_before_rule_3_is_not_under_rule_3, notice_request_on_rule_3_day_is_not_before_rule_3, notice_earlier_consent_before_rule_3_is_not_under_rule_3, notice_earlier_consent_is_not_a_request_notice, notice_processor_owes_no_notice, notice_no_occasion_owes_no_notice, notice_fiduciary_unsure_is_not_decided, withdrawal_may_continue_need_not_cease, withdrawal_cease_may_not_continue, withdrawal_not_withdrawn_need_not_cease, withdrawal_law_unsure_is_not_decided, manager_suspended_may_not_act, manager_unregistered_may_not_act, manager_section_not_in_force_may_not_act, facade_withdrawn_is_not_eligible]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
