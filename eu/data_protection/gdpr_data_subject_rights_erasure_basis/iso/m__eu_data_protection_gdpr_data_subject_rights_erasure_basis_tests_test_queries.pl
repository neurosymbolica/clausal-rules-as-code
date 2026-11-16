% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_data_subject_rights_erasure_basis_tests_test_queries, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_data_subject_rights_erasure_basis_queries, [gdpr_data_subject_rights_erasure_basis_profile_keys/1, gdpr_data_subject_rights_erasure_basis_what_if/4, gdpr_data_subject_rights_erasure_basis_justification/2, gdpr_data_subject_rights_erasure_basis_compliance_check/3]).
:- use_module(m__eu_data_protection_gdpr_data_subject_rights_erasure_basis_request_basis, [request_basis/2]).
:- use_module(m__eu_data_protection_gdpr_data_subject_rights_erasure_basis_request_basis, [request_basis_status/2]).
:- use_module(m__eu_data_protection_gdpr_data_subject_rights_erasure_basis_fixtures, [gdpr_data_subject_rights_erasure_basis_profile_for/2]).

test(profile_keys_are_the_fifty_four_contract_keys) :-
    gdpr_data_subject_rights_erasure_basis_profile_keys(ProfileKeys),
    length(ProfileKeys, 54),
    ProfileKeys = [request_type|_].
test(request_basis_is_served) :-
    gdpr_data_subject_rights_erasure_basis_profile_for(unlawfully_processed, Profile),
    request_basis(Profile, art17_1_d).
test(status_query_agrees_with_request_basis) :-
    gdpr_data_subject_rights_erasure_basis_profile_for(unlawfully_processed, Profile),
    request_basis_status(Profile, art17_1_d).
test(what_if_switching_the_necessity_off_removes_the_basis) :-
    gdpr_data_subject_rights_erasure_basis_profile_for(necessity_no_longer, Profile),
    gdpr_data_subject_rights_erasure_basis_what_if(Profile, data_no_longer_necessary_for_purposes, false, none).
test(what_if_switching_the_necessity_on_gives_art17_1_a) :-
    gdpr_data_subject_rights_erasure_basis_profile_for(necessity_unsure, Profile),
    gdpr_data_subject_rights_erasure_basis_what_if(Profile, data_no_longer_necessary_for_purposes, true, art17_1_a).
test(what_if_adds_an_absent_key) :-
    gdpr_data_subject_rights_erasure_basis_what_if([attribute(request_type, erasure)], data_no_longer_necessary_for_purposes, true, Status),
    Status == art17_1_a.
test(what_if_yields_one_answer) :-
    gdpr_data_subject_rights_erasure_basis_profile_for(necessity_no_longer, Profile),
    findall(Status, gdpr_data_subject_rights_erasure_basis_what_if(Profile, data_no_longer_necessary_for_purposes, false, Status), Statuses),
    Statuses == [none].
test(justification_items_carry_cite_provenance) :-
    gdpr_data_subject_rights_erasure_basis_profile_for(necessity_no_longer, Profile),
    gdpr_data_subject_rights_erasure_basis_justification(Profile, Items),
    member(item(art17_1_a, met, cite(eu_reg_2016_679_art_17_1_a)), Items).
test(justification_lists_the_suspension_row) :-
    gdpr_data_subject_rights_erasure_basis_profile_for(identity_doubts_unconfirmed, Profile),
    gdpr_data_subject_rights_erasure_basis_justification(Profile, Items),
    member(item(art12_6_identity_not_confirmed, met, cite(eu_reg_2016_679_art_12_6)), Items).
test(compliance_check_prohibits_retention_when_erasure_is_owed) :-
    gdpr_data_subject_rights_erasure_basis_profile_for(necessity_no_longer, Profile),
    gdpr_data_subject_rights_erasure_basis_compliance_check(Profile, retain_data, prohibited).
test(compliance_check_permits_retention_under_an_exception) :-
    gdpr_data_subject_rights_erasure_basis_profile_for(freedom_of_expression_exception, Profile),
    gdpr_data_subject_rights_erasure_basis_compliance_check(Profile, retain_data, permitted).
test(compliance_check_permits_retention_when_no_ground_is_engaged) :-
    gdpr_data_subject_rights_erasure_basis_profile_for(no_ground_engaged, Profile),
    gdpr_data_subject_rights_erasure_basis_compliance_check(Profile, retain_data, permitted).
test(compliance_check_is_undetermined_while_identity_is_unconfirmed) :-
    gdpr_data_subject_rights_erasure_basis_profile_for(identity_doubts_unconfirmed, Profile),
    gdpr_data_subject_rights_erasure_basis_compliance_check(Profile, retain_data, undetermined).

test(compliance_check_never_prohibits_when_permitted, fail) :-
    gdpr_data_subject_rights_erasure_basis_profile_for(no_ground_engaged, Profile),
    gdpr_data_subject_rights_erasure_basis_compliance_check(Profile, retain_data, prohibited).

cp_test_names([profile_keys_are_the_fifty_four_contract_keys, request_basis_is_served, status_query_agrees_with_request_basis, what_if_switching_the_necessity_off_removes_the_basis, what_if_switching_the_necessity_on_gives_art17_1_a, what_if_adds_an_absent_key, what_if_yields_one_answer, justification_items_carry_cite_provenance, justification_lists_the_suspension_row, compliance_check_prohibits_retention_when_erasure_is_owed, compliance_check_permits_retention_under_an_exception, compliance_check_permits_retention_when_no_ground_is_engaged, compliance_check_is_undetermined_while_identity_is_unconfirmed]).
cp_test_fail_names([compliance_check_never_prohibits_when_permitted]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
