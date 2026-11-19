% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_data_subject_rights_response_duties_tests_test_input_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_data_subject_rights_response_duties_gdpr_data_subject_rights_response_duties, [request_response_deadline/2, response_duties/2, recipient_notification/2, gdpr_data_subject_rights_response_duties_status/2]).
:- use_module(m__eu_data_protection_gdpr_data_subject_rights_response_duties_kernel, [gdpr_data_subject_rights_response_duties_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_data_subject_rights_response_duties_fixtures, [gdpr_data_subject_rights_response_duties_profile_for/2]).

profile(Subject, Profile) :-
    gdpr_data_subject_rights_response_duties_profile_for(Subject, Profile).

test(the_deadline_holds_with_the_date_bound) :-
    profile(access_plain_must_comply, Profile),
    request_response_deadline(Profile, date(2026, 11, 30)).
test(the_refusal_duties_hold_bound) :-
    profile(access_manifestly_excessive_refused, Profile),
    response_duties(Profile, [inform_of_reasons_and_remedies(first_period, cite(eu_reg_2016_679_art_12_4))]).
test(the_recipient_duties_hold_bound) :-
    profile(rectification_recipients_informed, Profile),
    recipient_notification(Profile, [communicate_to_each_recipient(cite(eu_reg_2016_679_art_19)), inform_data_subject_of_recipients(cite(eu_reg_2016_679_art_19))]).
test(the_status_holds_bound) :-
    profile(access_plain_must_comply, Profile),
    gdpr_data_subject_rights_response_duties_status(Profile, must_comply).
test(a_well_formed_profile_has_no_input_problems) :-
    profile(access_plain_must_comply, Profile),
    gdpr_data_subject_rights_response_duties_input_problems(Profile, []).
test(an_absent_key_is_not_an_input_problem) :-
    gdpr_data_subject_rights_response_duties_input_problems([], []).
test(a_repeated_key_is_a_duplicate_key) :-
    profile(duplicate_request_type, Profile),
    gdpr_data_subject_rights_response_duties_input_problems(Profile, [duplicate_key(request_type)]).
test(a_key_outside_the_contract_is_an_unknown_key) :-
    profile(unknown_key_given, Profile),
    gdpr_data_subject_rights_response_duties_input_problems(Profile, [unknown_key(favourite_colour)]).
test(a_term_that_is_not_an_attribute_list_is_the_wrong_type) :-
    profile(profile_not_a_list, Profile),
    gdpr_data_subject_rights_response_duties_input_problems(Profile, [wrong_type(profile)]).
test(a_crisp_key_given_unsure_is_the_wrong_type) :-
    profile(crisp_key_given_unsure, Profile),
    gdpr_data_subject_rights_response_duties_input_problems(Profile, [wrong_type(personal_data_inaccurate)]).
test(a_judgement_given_unsure_is_accepted) :-
    profile(judgement_given_unsure_refers, Profile),
    gdpr_data_subject_rights_response_duties_input_problems(Profile, []).
test(a_request_type_outside_the_enum_is_the_wrong_type) :-
    gdpr_data_subject_rights_response_duties_input_problems([attribute(request_type, banana)], [wrong_type(request_type)]).
test(a_date_that_is_not_a_calendar_day_is_the_wrong_type) :-
    gdpr_data_subject_rights_response_duties_input_problems([attribute(request_type, access), attribute(request_received_on, date(2026, 2, 30))], [wrong_type(request_received_on)]).
test(a_bare_outside_fact_is_the_wrong_type) :-
    gdpr_data_subject_rights_response_duties_input_problems([attribute(request_type, access), attribute(legislative_restriction_applies_to_the_right, true)], [wrong_type(legislative_restriction_applies_to_the_right)]).
test(a_holiday_list_of_non_dates_is_the_wrong_type) :-
    gdpr_data_subject_rights_response_duties_input_problems([attribute(request_type, access), attribute(public_holidays, attested([christmas], attestation(by, at, reason, none)))], [wrong_type(public_holidays)]).
test(input_problems_reach_every_query) :-
    profile(duplicate_request_type, Profile),
    request_response_deadline(Profile, input_problems([duplicate_key(request_type)])),
    response_duties(Profile, input_problems([duplicate_key(request_type)])),
    recipient_notification(Profile, input_problems([duplicate_key(request_type)])).
test(a_term_that_is_not_a_profile_reaches_the_queries_as_input_problems) :-
    profile(profile_not_a_list, Profile),
    response_duties(Profile, input_problems([wrong_type(profile)])).

test(the_unshifted_sunday_is_rejected_as_the_deadline, fail) :-
    profile(access_plain_must_comply, Profile),
    request_response_deadline(Profile, date(2026, 11, 29)).
test(the_compliance_duties_are_rejected_for_a_refusal, fail) :-
    profile(access_manifestly_excessive_refused, Profile),
    response_duties(Profile, [respond_with_action_taken(first_period, cite(eu_reg_2016_679_art_12_3))]).
test(the_excused_answer_is_rejected_when_not_excused, fail) :-
    profile(rectification_recipients_informed, Profile),
    recipient_notification(Profile, [recipient_notification_excused(cite(eu_reg_2016_679_art_19))]).
test(another_status_is_rejected_bound, fail) :-
    profile(access_plain_must_comply, Profile),
    gdpr_data_subject_rights_response_duties_status(Profile, need_not_comply).

cp_test_names([the_deadline_holds_with_the_date_bound, the_refusal_duties_hold_bound, the_recipient_duties_hold_bound, the_status_holds_bound, a_well_formed_profile_has_no_input_problems, an_absent_key_is_not_an_input_problem, a_repeated_key_is_a_duplicate_key, a_key_outside_the_contract_is_an_unknown_key, a_term_that_is_not_an_attribute_list_is_the_wrong_type, a_crisp_key_given_unsure_is_the_wrong_type, a_judgement_given_unsure_is_accepted, a_request_type_outside_the_enum_is_the_wrong_type, a_date_that_is_not_a_calendar_day_is_the_wrong_type, a_bare_outside_fact_is_the_wrong_type, a_holiday_list_of_non_dates_is_the_wrong_type, input_problems_reach_every_query, a_term_that_is_not_a_profile_reaches_the_queries_as_input_problems]).
cp_test_fail_names([the_unshifted_sunday_is_rejected_as_the_deadline, the_compliance_duties_are_rejected_for_a_refusal, the_excused_answer_is_rejected_when_not_excused, another_status_is_rejected_bound]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
