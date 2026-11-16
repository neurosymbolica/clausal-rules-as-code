% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_data_subject_rights_articles_15_to_18_decision_and_exception_tests_test_input_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_data_subject_rights_articles_15_to_18_decision_and_exception_request_exception, [request_exception_status/2, request_decision/2, request_exception/2]).
:- use_module(m__eu_data_protection_gdpr_data_subject_rights_articles_15_to_18_decision_and_exception_fixtures, [gdpr_data_subject_rights_articles_15_to_18_decision_and_exception_profile_for/2]).

test(access_must_comply_with_the_status_bound) :-
    gdpr_data_subject_rights_articles_15_to_18_decision_and_exception_profile_for(access_request, Profile),
    request_exception_status(Profile, must_comply).
test(manifestly_unfounded_access_exception_bound) :-
    gdpr_data_subject_rights_articles_15_to_18_decision_and_exception_profile_for(access_request_manifestly_unfounded, Profile),
    request_exception(Profile, art12_5_manifestly_unfounded_or_excessive).
test(unconfirmed_identity_suspension_bound) :-
    gdpr_data_subject_rights_articles_15_to_18_decision_and_exception_profile_for(access_request_identity_unconfirmed, Profile),
    request_decision(Profile, suspended(art12_6_identity_not_confirmed)).
test(erasure_legal_claims_exception_bound) :-
    gdpr_data_subject_rights_articles_15_to_18_decision_and_exception_profile_for(erasure_legal_claims, Profile),
    request_exception(Profile, art17_3_e).
test(an_unknown_key_problem_bound) :-
    gdpr_data_subject_rights_articles_15_to_18_decision_and_exception_profile_for(access_request_unknown_key, Profile),
    request_decision(Profile, input_problems([unknown_key(favourite_colour)])).
test(an_input_problem_exception_is_none_bound) :-
    gdpr_data_subject_rights_articles_15_to_18_decision_and_exception_profile_for(access_request_unknown_key, Profile),
    request_exception(Profile, none).
test(an_absent_request_type_bound) :-
    request_decision([], indeterminate([request_type])).
test(a_request_type_outside_the_enum_is_a_wrong_type) :-
    request_decision([attribute(request_type, deletion)], input_problems([wrong_type(request_type)])).
test(a_judgement_outside_its_three_values_is_a_wrong_type) :-
    request_decision([attribute(request_type, access), attribute(request_manifestly_unfounded_or_excessive, perhaps)], input_problems([wrong_type(request_manifestly_unfounded_or_excessive)])).
test(a_bare_outside_fact_is_a_wrong_type) :-
    request_decision([attribute(request_type, access), attribute(legislative_restriction_applies_to_the_right, true)], input_problems([wrong_type(legislative_restriction_applies_to_the_right)])).
test(a_date_that_is_not_a_calendar_day_is_a_wrong_type) :-
    request_decision([attribute(request_type, access), attribute(request_received_on, date(2026, 2, 30))], input_problems([wrong_type(request_received_on)])).
test(contract_problems_come_before_unknown_keys) :-
    request_decision([attribute(colour, blue), attribute(request_type, deletion)], input_problems([wrong_type(request_type), unknown_key(colour)])).
test(a_term_that_is_not_an_attribute_list_is_refused) :-
    request_decision(not_a_profile, input_problems([wrong_type(profile)])).
test(a_receipt_date_no_limb_reads_leaves_the_answer) :-
    request_decision([attribute(request_type, access), attribute(request_received_on, date(2026, 3, 2))], must_comply).
test(public_holidays_no_limb_reads_leave_the_answer) :-
    request_decision([attribute(request_type, access), attribute(public_holidays, attested([date(2026, 12, 25)], attestation(by, at, reason, none)))], must_comply).

test(access_is_not_need_not_comply_with_the_status_bound, fail) :-
    gdpr_data_subject_rights_articles_15_to_18_decision_and_exception_profile_for(access_request, Profile),
    request_exception_status(Profile, need_not_comply).
test(manifestly_unfounded_access_is_not_unable_to_identify, fail) :-
    gdpr_data_subject_rights_articles_15_to_18_decision_and_exception_profile_for(access_request_manifestly_unfounded, Profile),
    request_exception(Profile, art12_2_unable_to_identify).
test(unconfirmed_identity_is_not_must_comply, fail) :-
    gdpr_data_subject_rights_articles_15_to_18_decision_and_exception_profile_for(access_request_identity_unconfirmed, Profile),
    request_decision(Profile, must_comply).
test(erasure_legal_claims_is_not_freedom_of_expression, fail) :-
    gdpr_data_subject_rights_articles_15_to_18_decision_and_exception_profile_for(erasure_legal_claims, Profile),
    request_exception(Profile, art17_3_a).
test(an_absent_request_type_is_not_must_comply, fail) :-
    request_decision([], must_comply).

cp_test_names([access_must_comply_with_the_status_bound, manifestly_unfounded_access_exception_bound, unconfirmed_identity_suspension_bound, erasure_legal_claims_exception_bound, an_unknown_key_problem_bound, an_input_problem_exception_is_none_bound, an_absent_request_type_bound, a_request_type_outside_the_enum_is_a_wrong_type, a_judgement_outside_its_three_values_is_a_wrong_type, a_bare_outside_fact_is_a_wrong_type, a_date_that_is_not_a_calendar_day_is_a_wrong_type, contract_problems_come_before_unknown_keys, a_term_that_is_not_an_attribute_list_is_refused, a_receipt_date_no_limb_reads_leaves_the_answer, public_holidays_no_limb_reads_leave_the_answer]).
cp_test_fail_names([access_is_not_need_not_comply_with_the_status_bound, manifestly_unfounded_access_is_not_unable_to_identify, unconfirmed_identity_is_not_must_comply, erasure_legal_claims_is_not_freedom_of_expression, an_absent_request_type_is_not_must_comply]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
