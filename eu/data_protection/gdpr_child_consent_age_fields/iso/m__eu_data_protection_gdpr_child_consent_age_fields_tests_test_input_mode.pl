% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_child_consent_age_fields_tests_test_input_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_child_consent_age_fields_child_consent_status, [child_consent_status/2, child_consent_status_status/2, child_consent_outside_facts/2]).
:- use_module(m__eu_data_protection_gdpr_child_consent_age_fields_parental_verification, [parental_verification/2]).
:- use_module(m__eu_data_protection_gdpr_child_consent_age_fields_kernel, [gdpr_child_consent_age_fields_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_child_consent_age_fields_fixtures, [gdpr_child_consent_age_fields_profile_for/2]).

test(not_engaged_holds_eligible) :-
    gdpr_child_consent_age_fields_profile_for(not_engaged_not_directed, Profile),
    child_consent_status_status(Profile, eligible).
test(age_16_holds_eligible) :-
    gdpr_child_consent_age_fields_profile_for(age_16_own_consent, Profile),
    child_consent_status_status(Profile, eligible).
test(age_15_national_16_holds_ineligible) :-
    gdpr_child_consent_age_fields_profile_for(age_15_national_16, Profile),
    child_consent_status(Profile, ineligible).
test(age_15_national_15_holds_eligible) :-
    gdpr_child_consent_age_fields_profile_for(age_15_national_15, Profile),
    child_consent_status(Profile, eligible).
test(age_14_national_15_holds_ineligible) :-
    gdpr_child_consent_age_fields_profile_for(age_14_national_15, Profile),
    child_consent_status(Profile, ineligible).
test(age_13_national_13_holds_eligible) :-
    gdpr_child_consent_age_fields_profile_for(age_13_national_13, Profile),
    child_consent_status(Profile, eligible).
test(age_12_parent_given_holds_eligible) :-
    gdpr_child_consent_age_fields_profile_for(age_12_parent_given, Profile),
    child_consent_status(Profile, eligible).
test(age_12_no_parent_holds_ineligible) :-
    gdpr_child_consent_age_fields_profile_for(age_12_no_parent, Profile),
    child_consent_status(Profile, ineligible).
test(age_missing_holds_indeterminate) :-
    gdpr_child_consent_age_fields_profile_for(age_missing, Profile),
    child_consent_status(Profile, indeterminate([child_age_years])).
test(member_state_missing_holds_indeterminate) :-
    gdpr_child_consent_age_fields_profile_for(age_14_member_state_missing, Profile),
    child_consent_status(Profile, indeterminate([member_state])).
test(invalid_age_holds_input_problems) :-
    gdpr_child_consent_age_fields_profile_for(invalid_age, Profile),
    child_consent_status(Profile, input_problems([wrong_type(child_age_years)])).
test(invalid_age_verification_is_not_reached) :-
    gdpr_child_consent_age_fields_profile_for(invalid_age, Profile),
    parental_verification(Profile, not_reached).
test(invalid_age_outside_facts_are_input_problems) :-
    gdpr_child_consent_age_fields_profile_for(invalid_age, Profile),
    child_consent_outside_facts(Profile, input_problems([wrong_type(child_age_years)])).
test(service_unsure_holds_referral) :-
    gdpr_child_consent_age_fields_profile_for(service_unsure, Profile),
    child_consent_status(Profile, needs_legal_review(open_textured(information_society_service, cite(eu_reg_2016_679_art_4_25)), [inputs_relied_on(_Pairs)])).
test(efforts_not_reasonable_holds) :-
    gdpr_child_consent_age_fields_profile_for(parent_given_efforts_not_reasonable, Profile),
    parental_verification(Profile, efforts_not_reasonable).
test(empty_profile_has_no_problem) :-
    gdpr_child_consent_age_fields_input_problems([], []).
test(empty_profile_is_indeterminate_on_engagement) :-
    child_consent_status([], indeterminate([processing_rests_on_consent, information_society_service, offered_directly_to_child])).
test(a_non_list_is_a_wrong_profile) :-
    gdpr_child_consent_age_fields_input_problems(not_a_list, [wrong_type(profile)]).
test(a_non_list_profile_gives_input_problems) :-
    child_consent_status(not_a_list, input_problems([wrong_type(profile)])).
test(an_unknown_key_is_named) :-
    gdpr_child_consent_age_fields_input_problems([attribute(favourite_colour, blue)], [unknown_key(favourite_colour)]).
test(a_duplicate_key_is_named_once) :-
    gdpr_child_consent_age_fields_input_problems([attribute(child_age_years, 1), attribute(child_age_years, 2)], [duplicate_key(child_age_years)]).
test(a_float_age_is_wrong_type) :-
    gdpr_child_consent_age_fields_input_problems([attribute(child_age_years, 15.0)], [wrong_type(child_age_years)]).
test(a_negative_age_is_wrong_type) :-
    gdpr_child_consent_age_fields_input_problems([attribute(child_age_years, -3)], [wrong_type(child_age_years)]).
test(unsure_is_wrong_for_a_crisp_key) :-
    gdpr_child_consent_age_fields_input_problems([attribute(parental_consent_given, unsure)], [wrong_type(parental_consent_given)]).
test(unsure_is_right_for_a_judgement) :-
    gdpr_child_consent_age_fields_input_problems([attribute(information_society_service, unsure)], []).
test(an_unknown_member_state_is_wrong_type) :-
    gdpr_child_consent_age_fields_input_problems([attribute(member_state, norway)], [wrong_type(member_state)]).
test(a_bad_selection_test_is_wrong_type) :-
    gdpr_child_consent_age_fields_input_problems([attribute(member_state_selection_test, both)], [wrong_type(member_state_selection_test)]).
test(an_unreal_day_is_wrong_type) :-
    gdpr_child_consent_age_fields_input_problems([attribute(consent_date, date(2026, 2, 30))], [wrong_type(consent_date)]).
test(a_leap_day_is_a_real_day) :-
    gdpr_child_consent_age_fields_input_problems([attribute(consent_date, date(2028, 2, 29))], []).
test(a_national_age_of_seventeen_is_wrong_type) :-
    gdpr_child_consent_age_fields_input_problems([attribute(member_state_digital_consent_age, attested(national_digital_consent_age(france, 17, act_one), attestation(by, at, reason, none)))], [wrong_type(member_state_digital_consent_age)]).
test(a_national_age_of_twelve_is_wrong_type) :-
    gdpr_child_consent_age_fields_input_problems([attribute(member_state_digital_consent_age, attested(national_digital_consent_age(france, 12, act_one), attestation(by, at, reason, none)))], [wrong_type(member_state_digital_consent_age)]).
test(a_good_national_age_has_no_problem) :-
    gdpr_child_consent_age_fields_input_problems([attribute(member_state_digital_consent_age, attested(national_digital_consent_age(france, 15, act_one), attestation(by, at, reason, none)))], []).
test(a_fetched_value_is_wrong_type) :-
    gdpr_child_consent_age_fields_input_problems([attribute(member_state_digital_consent_age, fetched(national_digital_consent_age(france, 15, act_one), source(url_one, at, hash)))], [wrong_type(member_state_digital_consent_age)]).
test(problems_follow_contract_order_then_unknown_keys) :-
    gdpr_child_consent_age_fields_input_problems([attribute(zebra, 1), attribute(verification_efforts_reasonable, maybe), attribute(child_age_years, a)], [wrong_type(child_age_years), wrong_type(verification_efforts_reasonable), unknown_key(zebra)]).
test(an_unread_malformed_key_is_still_checked) :-
    child_consent_status([attribute(processing_rests_on_consent, true), attribute(information_society_service, true), attribute(offered_directly_to_child, true), attribute(child_age_years, 16), attribute(parental_consent_given, yes)], input_problems([wrong_type(parental_consent_given)])).
test(an_unread_wellformed_key_does_not_change_the_answer) :-
    child_consent_status([attribute(processing_rests_on_consent, true), attribute(information_society_service, true), attribute(offered_directly_to_child, true), attribute(child_age_years, 16), attribute(parental_consent_given, false)], eligible).

test(age_16_is_not_ineligible, fail) :-
    gdpr_child_consent_age_fields_profile_for(age_16_own_consent, Profile),
    child_consent_status_status(Profile, ineligible).
test(age_15_national_16_is_not_eligible, fail) :-
    gdpr_child_consent_age_fields_profile_for(age_15_national_16, Profile),
    child_consent_status(Profile, eligible).
test(efforts_reasonable_is_not_efforts_not_reasonable, fail) :-
    gdpr_child_consent_age_fields_profile_for(age_12_parent_given, Profile),
    parental_verification(Profile, efforts_not_reasonable).

cp_test_names([not_engaged_holds_eligible, age_16_holds_eligible, age_15_national_16_holds_ineligible, age_15_national_15_holds_eligible, age_14_national_15_holds_ineligible, age_13_national_13_holds_eligible, age_12_parent_given_holds_eligible, age_12_no_parent_holds_ineligible, age_missing_holds_indeterminate, member_state_missing_holds_indeterminate, invalid_age_holds_input_problems, invalid_age_verification_is_not_reached, invalid_age_outside_facts_are_input_problems, service_unsure_holds_referral, efforts_not_reasonable_holds, empty_profile_has_no_problem, empty_profile_is_indeterminate_on_engagement, a_non_list_is_a_wrong_profile, a_non_list_profile_gives_input_problems, an_unknown_key_is_named, a_duplicate_key_is_named_once, a_float_age_is_wrong_type, a_negative_age_is_wrong_type, unsure_is_wrong_for_a_crisp_key, unsure_is_right_for_a_judgement, an_unknown_member_state_is_wrong_type, a_bad_selection_test_is_wrong_type, an_unreal_day_is_wrong_type, a_leap_day_is_a_real_day, a_national_age_of_seventeen_is_wrong_type, a_national_age_of_twelve_is_wrong_type, a_good_national_age_has_no_problem, a_fetched_value_is_wrong_type, problems_follow_contract_order_then_unknown_keys, an_unread_malformed_key_is_still_checked, an_unread_wellformed_key_does_not_change_the_answer]).
cp_test_fail_names([age_16_is_not_ineligible, age_15_national_16_is_not_eligible, efforts_reasonable_is_not_efforts_not_reasonable]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
