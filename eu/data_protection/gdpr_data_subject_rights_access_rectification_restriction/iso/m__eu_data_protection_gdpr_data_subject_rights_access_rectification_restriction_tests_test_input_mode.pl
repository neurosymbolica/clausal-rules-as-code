% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_data_subject_rights_access_rectification_restriction_tests_test_input_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_data_subject_rights_access_rectification_restriction_request_basis, [request_basis_status/2, request_basis/2, decide_data_subject_request/2]).
:- use_module(m__eu_data_protection_gdpr_data_subject_rights_access_rectification_restriction_kernel, [gdpr_data_subject_rights_access_rectification_restriction_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_data_subject_rights_access_rectification_restriction_fixtures, [gdpr_data_subject_rights_access_rectification_restriction_profile_for/2]).

test(status_holds_with_the_verdict_bound) :-
    gdpr_data_subject_rights_access_rectification_restriction_profile_for(access_plain, Profile),
    request_basis_status(Profile, art15_1).
test(a_well_formed_profile_has_no_problem) :-
    gdpr_data_subject_rights_access_rectification_restriction_profile_for(access_plain, Profile),
    gdpr_data_subject_rights_access_rectification_restriction_input_problems(Profile, []).
test(an_unknown_key_is_named) :-
    gdpr_data_subject_rights_access_rectification_restriction_profile_for(profile_with_unknown_key, Profile),
    gdpr_data_subject_rights_access_rectification_restriction_input_problems(Profile, [unknown_key(not_a_contract_key)]).
test(a_non_list_is_not_a_profile) :-
    gdpr_data_subject_rights_access_rectification_restriction_input_problems(not_a_list, [wrong_type(profile)]).
test(a_request_type_outside_the_enum_is_wrong_type) :-
    gdpr_data_subject_rights_access_rectification_restriction_input_problems([attribute(request_type, bogus)], [wrong_type(request_type)]).
test(a_crisp_key_given_unsure_is_wrong_type) :-
    gdpr_data_subject_rights_access_rectification_restriction_input_problems([attribute(request_type, access), attribute(identity_confirmed, unsure)], [wrong_type(identity_confirmed)]).
test(a_repeated_key_is_a_duplicate) :-
    gdpr_data_subject_rights_access_rectification_restriction_input_problems([attribute(request_type, access), attribute(request_type, access)], [duplicate_key(request_type)]).
test(a_bad_date_is_wrong_type) :-
    gdpr_data_subject_rights_access_rectification_restriction_input_problems([attribute(request_received_on, date(2026, 2, 30))], [wrong_type(request_received_on)]).
test(an_unattested_outside_fact_is_wrong_type) :-
    gdpr_data_subject_rights_access_rectification_restriction_input_problems([attribute(legislative_restriction_applies_to_the_right, true)], [wrong_type(legislative_restriction_applies_to_the_right)]).
test(input_problems_come_first_in_the_verdict) :-
    gdpr_data_subject_rights_access_rectification_restriction_profile_for(profile_with_unknown_key, Profile),
    decide_data_subject_request(Profile, gdpr_data_subject_request_verdict(input_problems([unknown_key(not_a_contract_key)]), none, none, [], [])).
test(input_problems_give_basis_input_problems) :-
    gdpr_data_subject_rights_access_rectification_restriction_profile_for(profile_with_unknown_key, Profile),
    request_basis(Profile, input_problems([unknown_key(not_a_contract_key)])).
test(an_empty_profile_lacks_the_request_type) :-
    decide_data_subject_request([], gdpr_data_subject_request_verdict(indeterminate([request_type]), none, none, [], [])).
test(an_empty_profile_has_basis_none) :-
    request_basis([], none).

test(the_wrong_bound_status_is_rejected, fail) :-
    gdpr_data_subject_rights_access_rectification_restriction_profile_for(access_plain, Profile),
    request_basis_status(Profile, art16_inaccurate_data).

cp_test_names([status_holds_with_the_verdict_bound, a_well_formed_profile_has_no_problem, an_unknown_key_is_named, a_non_list_is_not_a_profile, a_request_type_outside_the_enum_is_wrong_type, a_crisp_key_given_unsure_is_wrong_type, a_repeated_key_is_a_duplicate, a_bad_date_is_wrong_type, an_unattested_outside_fact_is_wrong_type, input_problems_come_first_in_the_verdict, input_problems_give_basis_input_problems, an_empty_profile_lacks_the_request_type, an_empty_profile_has_basis_none]).
cp_test_fail_names([the_wrong_bound_status_is_rejected]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
