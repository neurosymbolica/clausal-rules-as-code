% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_data_subject_rights_response_duties_tests_test_input_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_data_subject_rights_response_duties_gdpr_data_subject_rights_response_duties, [gdpr_data_subject_rights_response_duties_status/2, request_response_deadline/2, response_duties/2, recipient_notification/2]).
:- use_module(m__eu_data_protection_gdpr_data_subject_rights_response_duties_fixtures, [gdpr_data_subject_rights_response_duties_profile_for/2]).

test(status_holds_with_the_verdict_bound) :-
    gdpr_data_subject_rights_response_duties_profile_for(access_basic, Profile),
    gdpr_data_subject_rights_response_duties_status(Profile, must_comply).
test(excessive_request_status_bound) :-
    gdpr_data_subject_rights_response_duties_profile_for(access_excessive, Profile),
    gdpr_data_subject_rights_response_duties_status(Profile, need_not_comply).
test(missing_request_type_status_bound) :-
    gdpr_data_subject_rights_response_duties_profile_for(missing_request_type, Profile),
    gdpr_data_subject_rights_response_duties_status(Profile, indeterminate([request_type])).
test(identity_suspension_status_bound) :-
    gdpr_data_subject_rights_response_duties_profile_for(access_identity_suspended, Profile),
    gdpr_data_subject_rights_response_duties_status(Profile, suspended(art12_6_identity_not_confirmed)).
test(invalid_request_type_status_bound) :-
    gdpr_data_subject_rights_response_duties_profile_for(request_type_invalid, Profile),
    gdpr_data_subject_rights_response_duties_status(Profile, input_problems([wrong_type(request_type)])).
test(deadline_holds_with_the_date_bound) :-
    gdpr_data_subject_rights_response_duties_profile_for(access_basic, Profile),
    request_response_deadline(Profile, date(2026, 11, 30)).
test(duties_hold_with_the_list_bound) :-
    gdpr_data_subject_rights_response_duties_profile_for(access_basic, Profile),
    response_duties(Profile, [respond_with_action_taken(first_period, cite(eu_reg_2016_679_art_12_3))]).
test(refusal_duties_bound) :-
    gdpr_data_subject_rights_response_duties_profile_for(access_unable_to_identify, Profile),
    response_duties(Profile, [inform_of_reasons_and_remedies(first_period, cite(eu_reg_2016_679_art_12_4))]).
test(recipient_duties_with_the_list_bound) :-
    gdpr_data_subject_rights_response_duties_profile_for(erasure_effort_excused, Profile),
    recipient_notification(Profile, [recipient_notification_excused(cite(eu_reg_2016_679_art_19))]).

test(the_wrong_bound_status_is_rejected, fail) :-
    gdpr_data_subject_rights_response_duties_profile_for(access_basic, Profile),
    gdpr_data_subject_rights_response_duties_status(Profile, need_not_comply).
test(the_sunday_is_not_the_deadline, fail) :-
    gdpr_data_subject_rights_response_duties_profile_for(access_basic, Profile),
    request_response_deadline(Profile, date(2026, 11, 29)).

cp_test_names([status_holds_with_the_verdict_bound, excessive_request_status_bound, missing_request_type_status_bound, identity_suspension_status_bound, invalid_request_type_status_bound, deadline_holds_with_the_date_bound, duties_hold_with_the_list_bound, refusal_duties_bound, recipient_duties_with_the_list_bound]).
cp_test_fail_names([the_wrong_bound_status_is_rejected, the_sunday_is_not_the_deadline]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
