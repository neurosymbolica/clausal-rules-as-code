% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_data_subject_rights_automated_decision_tests_test_negative_controls, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_data_subject_rights_automated_decision_request_basis, [request_basis_status/2, request_basis_status_values/1, decide_data_subject_request/2]).
:- use_module(m__eu_data_protection_gdpr_data_subject_rights_automated_decision_fixtures, [gdpr_data_subject_rights_automated_decision_profile_for/2]).

comply_of(Subject, Comply, Exception) :-
    gdpr_data_subject_rights_automated_decision_profile_for(Subject, Profile),
    decide_data_subject_request(Profile, gdpr_data_subject_request_verdict(Comply, _, Exception, _, _)).

test(the_near_miss_verdict_is_a_real_verdict_atom) :-
    request_basis_status_values(StatusValues),
    member(none, StatusValues),
    member(art22_1, StatusValues).
test(contract_positive) :-
    comply_of(contract_exception, need_not_comply, art22_2_a).
test(contract_near_miss_must_comply) :-
    comply_of(contract_near_miss, must_comply, none).
test(law_positive) :-
    comply_of(law_authorised_exception, need_not_comply, art22_2_b).
test(law_near_miss_must_comply) :-
    comply_of(law_authorised_near_miss, must_comply, none).
test(consent_positive) :-
    comply_of(explicit_consent_exception, need_not_comply, art22_2_c).
test(consent_near_miss_must_comply) :-
    comply_of(explicit_consent_near_miss, must_comply, none).
test(bar_blocks_contract) :-
    comply_of(special_categories_bar_blocks_contract, must_comply, none).
test(safeguards_lift_the_bar) :-
    comply_of(special_categories_safeguards_allow_contract, need_not_comply, art22_2_a).
test(bar_with_missing_safeguard_key_is_indeterminate) :-
    gdpr_data_subject_rights_automated_decision_profile_for(special_categories_safeguards_missing, Profile),
    decide_data_subject_request(Profile, gdpr_data_subject_request_verdict(indeterminate([special_category_condition_and_safeguards_met_for_decision]), _, _, _, _)).
test(excessive_positive) :-
    comply_of(manifestly_excessive_fee, need_not_comply, art12_5_manifestly_unfounded_or_excessive).
test(excessive_near_miss_must_comply) :-
    comply_of(manifestly_excessive_near_miss, must_comply, none).
test(unable_positive) :-
    comply_of(unable_to_identify, need_not_comply, art12_2_unable_to_identify).
test(unable_near_miss_must_comply) :-
    comply_of(unable_to_identify_near_miss, must_comply, none).
test(restriction_positive) :-
    comply_of(legislative_restriction, need_not_comply, art23_legislative_restriction).
test(restriction_near_miss_must_comply) :-
    comply_of(legislative_restriction_near_miss, must_comply, none).
test(suspension_positive) :-
    gdpr_data_subject_rights_automated_decision_profile_for(identity_suspended, Profile),
    decide_data_subject_request(Profile, gdpr_data_subject_request_verdict(suspended(art12_6_identity_not_confirmed), _, _, _, _)).
test(suspension_near_miss_must_comply) :-
    comply_of(identity_confirmed_near_miss, must_comply, none).
test(not_engaged_positive) :-
    comply_of(not_solely_automated, need_not_comply, none).
test(not_engaged_beats_exception) :-
    comply_of(not_engaged_beats_exception, need_not_comply, none).
test(contract_comes_first) :-
    comply_of(exception_order_contract_first, need_not_comply, art22_2_a).
test(exception_beats_suspension) :-
    comply_of(exception_beats_suspension, need_not_comply, art22_2_c).
test(unsure_referral_positive) :-
    gdpr_data_subject_rights_automated_decision_profile_for(solely_unsure_referral, Profile),
    decide_data_subject_request(Profile, gdpr_data_subject_request_verdict(needs_legal_review(_, _), _, _, _, _)).

test(the_baseline_profile_is_not_none, fail) :-
    gdpr_data_subject_rights_automated_decision_profile_for(baseline_must_comply, Profile),
    request_basis_status(Profile, none).
test(contract_near_miss_not_exception, fail) :-
    comply_of(contract_near_miss, _, art22_2_a).
test(bar_not_a_contract_exception, fail) :-
    comply_of(special_categories_bar_blocks_contract, _, art22_2_a).
test(suspension_near_miss_not_suspended, fail) :-
    gdpr_data_subject_rights_automated_decision_profile_for(identity_confirmed_near_miss, Profile),
    decide_data_subject_request(Profile, gdpr_data_subject_request_verdict(suspended(_), _, _, _, _)).
test(contract_first_not_consent, fail) :-
    comply_of(exception_order_contract_first, _, art22_2_c).

cp_test_names([the_near_miss_verdict_is_a_real_verdict_atom, contract_positive, contract_near_miss_must_comply, law_positive, law_near_miss_must_comply, consent_positive, consent_near_miss_must_comply, bar_blocks_contract, safeguards_lift_the_bar, bar_with_missing_safeguard_key_is_indeterminate, excessive_positive, excessive_near_miss_must_comply, unable_positive, unable_near_miss_must_comply, restriction_positive, restriction_near_miss_must_comply, suspension_positive, suspension_near_miss_must_comply, not_engaged_positive, not_engaged_beats_exception, contract_comes_first, exception_beats_suspension, unsure_referral_positive]).
cp_test_fail_names([the_baseline_profile_is_not_none, contract_near_miss_not_exception, bar_not_a_contract_exception, suspension_near_miss_not_suspended, contract_first_not_consent]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
