% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_information_duties_headline_verdict_tests_test_input_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_information_duties_headline_verdict_information_duty_verdict, [information_duty_verdict/3, information_outside_facts/2]).
:- use_module(m__eu_data_protection_gdpr_information_duties_headline_verdict_information_duty_exemption, [information_duty_exemption/2]).
:- use_module(m__eu_data_protection_gdpr_information_duties_headline_verdict_kernel, [gdpr_information_duties_headline_verdict_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_information_duties_headline_verdict_fixtures, [gdpr_information_duties_headline_verdict_profile_for/2]).

test(verdict_holds_with_eligible_bound) :-
    gdpr_information_duties_headline_verdict_profile_for(art13_on_time, Profile),
    information_duty_verdict(Profile, eligible, [cite(eu_reg_2016_679_art_13_1)]).
test(verdict_holds_with_ineligible_bound) :-
    gdpr_information_duties_headline_verdict_profile_for(art13_one_day_late, Profile),
    information_duty_verdict(Profile, ineligible, [cite(eu_reg_2016_679_art_13_1)]).
test(a_good_profile_has_no_input_problem) :-
    gdpr_information_duties_headline_verdict_profile_for(art13_on_time, Profile),
    gdpr_information_duties_headline_verdict_input_problems(Profile, []).
test(unknown_key_is_named) :-
    gdpr_information_duties_headline_verdict_profile_for(input_unknown_key, Profile),
    gdpr_information_duties_headline_verdict_input_problems(Profile, [unknown_key(no_such_key)]).
test(wrong_type_is_named) :-
    gdpr_information_duties_headline_verdict_profile_for(input_wrong_type, Profile),
    gdpr_information_duties_headline_verdict_input_problems(Profile, [wrong_type(items_provided)]).
test(duplicate_key_is_named) :-
    gdpr_information_duties_headline_verdict_profile_for(input_duplicate_key, Profile),
    gdpr_information_duties_headline_verdict_input_problems(Profile, [duplicate_key(personal_data_collected_from_data_subject)]).
test(not_a_profile_is_named) :-
    gdpr_information_duties_headline_verdict_profile_for(input_not_a_profile, Profile),
    gdpr_information_duties_headline_verdict_input_problems(Profile, [wrong_type(profile)]).
test(input_problems_come_first_in_the_verdict) :-
    gdpr_information_duties_headline_verdict_profile_for(input_unknown_key, Profile),
    information_duty_verdict(Profile, input_problems([unknown_key(no_such_key)]), []).
test(input_problems_come_first_in_the_exemption) :-
    gdpr_information_duties_headline_verdict_profile_for(input_wrong_type, Profile),
    information_duty_exemption(Profile, input_problems([wrong_type(items_provided)])).
test(input_problems_come_first_in_the_outside_facts) :-
    gdpr_information_duties_headline_verdict_profile_for(input_duplicate_key, Profile),
    information_outside_facts(Profile, input_problems([duplicate_key(personal_data_collected_from_data_subject)])).
test(empty_profile_names_the_absent_keys) :-
    information_duty_verdict([], indeterminate([personal_data_collected_from_data_subject, items_provided, items_data_subject_already_has, obtaining_date, provision_date, further_processing_for_another_purpose_intended]), []).
test(exemption_effort_bound) :-
    gdpr_information_duties_headline_verdict_profile_for(art14_effort_exemption, Profile),
    information_duty_exemption(Profile, impossible_or_disproportionate_effort).
test(exemption_law_bound) :-
    gdpr_information_duties_headline_verdict_profile_for(art14_law_exemption, Profile),
    information_duty_exemption(Profile, law_lays_down_obtaining_or_disclosure).
test(exemption_secrecy_bound) :-
    gdpr_information_duties_headline_verdict_profile_for(art14_secrecy_exemption, Profile),
    information_duty_exemption(Profile, professional_secrecy_obligation).
test(art13_has_no_exemption) :-
    gdpr_information_duties_headline_verdict_profile_for(art13_on_time, Profile),
    information_duty_exemption(Profile, none).
test(outside_facts_report_the_attested_holidays) :-
    gdpr_information_duties_headline_verdict_profile_for(art14_holiday_shift_on_time, Profile),
    information_outside_facts(Profile, [outside_fact(obtaining_or_disclosure_laid_down_by_law, absent), outside_fact(professional_secrecy_obligation_by_law, absent), outside_fact(public_holidays, attested([date(2027, 2, 1)], attestation(host, none, fixture_reason, none)))]).

test(the_wrong_bound_verdict_is_rejected, fail) :-
    gdpr_information_duties_headline_verdict_profile_for(art13_one_day_late, Profile),
    information_duty_verdict(Profile, eligible, _).
test(exemption_wrong_bound_is_rejected, fail) :-
    gdpr_information_duties_headline_verdict_profile_for(art14_law_exemption, Profile),
    information_duty_exemption(Profile, professional_secrecy_obligation).

cp_test_names([verdict_holds_with_eligible_bound, verdict_holds_with_ineligible_bound, a_good_profile_has_no_input_problem, unknown_key_is_named, wrong_type_is_named, duplicate_key_is_named, not_a_profile_is_named, input_problems_come_first_in_the_verdict, input_problems_come_first_in_the_exemption, input_problems_come_first_in_the_outside_facts, empty_profile_names_the_absent_keys, exemption_effort_bound, exemption_law_bound, exemption_secrecy_bound, art13_has_no_exemption, outside_facts_report_the_attested_holidays]).
cp_test_fail_names([the_wrong_bound_verdict_is_rejected, exemption_wrong_bound_is_rejected]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
