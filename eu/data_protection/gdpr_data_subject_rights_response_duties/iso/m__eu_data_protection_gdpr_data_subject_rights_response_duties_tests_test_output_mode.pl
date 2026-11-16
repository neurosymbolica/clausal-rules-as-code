% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_data_subject_rights_response_duties_tests_test_output_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_data_subject_rights_response_duties_gdpr_data_subject_rights_response_duties, [decide_gdpr_data_subject_rights_response_duties/2, gdpr_data_subject_rights_response_duties_status/2, gdpr_data_subject_rights_response_duties_checklist/2, request_response_deadline/2, response_duties/2, recipient_notification/2]).
:- use_module(m__eu_data_protection_gdpr_data_subject_rights_response_duties_fixtures, [gdpr_data_subject_rights_response_duties_profile_for/2]).

test(the_baseline_profile_yields_exactly_one_status) :-
    gdpr_data_subject_rights_response_duties_profile_for(access_basic, Profile),
    findall(Status, gdpr_data_subject_rights_response_duties_status(Profile, Status), Statuses),
    Statuses == [must_comply].
test(the_verdict_carries_a_citation) :-
    gdpr_data_subject_rights_response_duties_profile_for(access_basic, Profile),
    decide_gdpr_data_subject_rights_response_duties(Profile, gdpr_data_subject_request_verdict(must_comply, art15_1, none, [], [_FirstCitation|_OtherCitations])).
test(excessive_request_carries_exception_and_fee_condition) :-
    gdpr_data_subject_rights_response_duties_profile_for(access_excessive, Profile),
    decide_gdpr_data_subject_rights_response_duties(Profile, gdpr_data_subject_request_verdict(need_not_comply, art15_1, art12_5_manifestly_unfounded_or_excessive, [reasonable_fee_may_be_charged], _)).
test(erasure_ground_is_the_first_met_point) :-
    gdpr_data_subject_rights_response_duties_profile_for(erasure_no_longer_necessary, Profile),
    decide_gdpr_data_subject_rights_response_duties(Profile, gdpr_data_subject_request_verdict(must_comply, art17_1_a, none, [], _)).
test(erasure_exception_is_named) :-
    gdpr_data_subject_rights_response_duties_profile_for(erasure_legal_claims_exception, Profile),
    decide_gdpr_data_subject_rights_response_duties(Profile, gdpr_data_subject_request_verdict(need_not_comply, art17_1_a, art17_3_e, [], _)).
test(art22_consent_carries_the_safeguards) :-
    gdpr_data_subject_rights_response_duties_profile_for(automated_decision_consent, Profile),
    decide_gdpr_data_subject_rights_response_duties(Profile, gdpr_data_subject_request_verdict(need_not_comply, art22_1, art22_2_c, [human_intervention, express_point_of_view, contest_decision], _)).
test(restriction_by_law_is_the_art23_exception) :-
    gdpr_data_subject_rights_response_duties_profile_for(access_restricted_by_law, Profile),
    decide_gdpr_data_subject_rights_response_duties(Profile, gdpr_data_subject_request_verdict(need_not_comply, art15_1, art23_legislative_restriction, [], _)).
test(rectification_with_no_keys_names_the_missing_keys) :-
    gdpr_data_subject_rights_response_duties_profile_for(rectification_keys_absent, Profile),
    gdpr_data_subject_rights_response_duties_status(Profile, indeterminate([personal_data_inaccurate, personal_data_incomplete_in_light_of_purposes])).
test(objection_without_ground_names_the_ground) :-
    gdpr_data_subject_rights_response_duties_profile_for(objection_without_ground, Profile),
    gdpr_data_subject_rights_response_duties_status(Profile, indeterminate([objection_ground_claimed])).
test(unknown_and_duplicate_keys_are_input_problems) :-
    gdpr_data_subject_rights_response_duties_profile_for(unknown_key_profile, UnknownProfile),
    gdpr_data_subject_rights_response_duties_status(UnknownProfile, input_problems([unknown_key(bogus_key)])),
    gdpr_data_subject_rights_response_duties_profile_for(duplicate_key_profile, DuplicateProfile),
    gdpr_data_subject_rights_response_duties_status(DuplicateProfile, input_problems([duplicate_key(request_type)])).
test(checklist_of_an_access_request_has_five_rows) :-
    gdpr_data_subject_rights_response_duties_profile_for(access_basic, Profile),
    gdpr_data_subject_rights_response_duties_checklist(Profile, Rows),
    length(Rows, 5).
test(checklist_of_a_bad_profile_is_empty) :-
    gdpr_data_subject_rights_response_duties_profile_for(unknown_key_profile, Profile),
    gdpr_data_subject_rights_response_duties_checklist(Profile, []).
test(deadline_boundaries_at_month_ends) :-
    gdpr_data_subject_rights_response_duties_profile_for(leap_year, LeapProfile),
    request_response_deadline(LeapProfile, date(2028, 2, 29)),
    gdpr_data_subject_rights_response_duties_profile_for(year_end, YearEndProfile),
    request_response_deadline(YearEndProfile, date(2027, 2, 1)).
test(deadline_with_and_without_a_holiday) :-
    gdpr_data_subject_rights_response_duties_profile_for(holiday_shift, HolidayProfile),
    request_response_deadline(HolidayProfile, date(2026, 12, 1)),
    gdpr_data_subject_rights_response_duties_profile_for(no_holiday_shift, PlainProfile),
    request_response_deadline(PlainProfile, date(2026, 11, 30)).
test(extended_deadline_and_duties) :-
    gdpr_data_subject_rights_response_duties_profile_for(extension_necessary, Profile),
    request_response_deadline(Profile, date(2026, 4, 30)),
    response_duties(Profile, [inform_of_extension_with_reasons(first_period, cite(eu_reg_2016_679_art_12_3)), respond_with_action_taken(extended_period, cite(eu_reg_2016_679_art_12_3))]).
test(missing_receipt_date_is_indeterminate) :-
    gdpr_data_subject_rights_response_duties_profile_for(missing_request_type, Profile),
    request_response_deadline(Profile, indeterminate([request_received_on])).
test(recipient_duties_with_the_data_subject_asking) :-
    gdpr_data_subject_rights_response_duties_profile_for(erasure_no_longer_necessary, Profile),
    recipient_notification(Profile, [communicate_to_each_recipient(cite(eu_reg_2016_679_art_19)), inform_data_subject_of_recipients(cite(eu_reg_2016_679_art_19))]).
test(recipient_duties_for_access_not_applicable) :-
    gdpr_data_subject_rights_response_duties_profile_for(access_basic, Profile),
    recipient_notification(Profile, [recipient_notification_not_applicable(cite(eu_reg_2016_679_art_19))]).

cp_test_names([the_baseline_profile_yields_exactly_one_status, the_verdict_carries_a_citation, excessive_request_carries_exception_and_fee_condition, erasure_ground_is_the_first_met_point, erasure_exception_is_named, art22_consent_carries_the_safeguards, restriction_by_law_is_the_art23_exception, rectification_with_no_keys_names_the_missing_keys, objection_without_ground_names_the_ground, unknown_and_duplicate_keys_are_input_problems, checklist_of_an_access_request_has_five_rows, checklist_of_a_bad_profile_is_empty, deadline_boundaries_at_month_ends, deadline_with_and_without_a_holiday, extended_deadline_and_duties, missing_receipt_date_is_indeterminate, recipient_duties_with_the_data_subject_asking, recipient_duties_for_access_not_applicable]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
