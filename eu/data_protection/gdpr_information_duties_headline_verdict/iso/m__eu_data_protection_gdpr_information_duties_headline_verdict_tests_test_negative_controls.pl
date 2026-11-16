% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_information_duties_headline_verdict_tests_test_negative_controls, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_information_duties_headline_verdict_information_duty_verdict, [information_duty_verdict/3, information_duty_verdict_status_values/1]).
:- use_module(m__eu_data_protection_gdpr_information_duties_headline_verdict_information_duty_exemption, [information_duty_exemption/2, information_duty_exemption_status_values/1]).
:- use_module(m__eu_data_protection_gdpr_information_duties_headline_verdict_queries, [gdpr_information_duties_headline_verdict_what_if/4]).
:- use_module(m__eu_data_protection_gdpr_information_duties_headline_verdict_fixtures, [gdpr_information_duties_headline_verdict_profile_for/2]).

test(verdict_atoms_are_real) :-
    information_duty_verdict_status_values(Values),
    member(eligible, Values),
    member(ineligible, Values).
test(exemption_atoms_are_real) :-
    information_duty_exemption_status_values(Values),
    member(impossible_or_disproportionate_effort, Values),
    member(law_lays_down_obtaining_or_disclosure, Values),
    member(professional_secrecy_obligation, Values),
    member(none, Values).
test(art13_positive_is_eligible) :-
    gdpr_information_duties_headline_verdict_profile_for(art13_on_time, Profile),
    information_duty_verdict(Profile, eligible, _).
test(art13_one_day_late_is_ineligible) :-
    gdpr_information_duties_headline_verdict_profile_for(art13_one_day_late, Profile),
    information_duty_verdict(Profile, ineligible, _).
test(art14_positive_is_eligible) :-
    gdpr_information_duties_headline_verdict_profile_for(art14_on_time_at_boundary, Profile),
    information_duty_verdict(Profile, eligible, _).
test(art14_one_day_over_is_ineligible) :-
    gdpr_information_duties_headline_verdict_profile_for(art14_one_day_late, Profile),
    information_duty_verdict(Profile, ineligible, _).
test(art14_communication_limb_on_time_is_eligible) :-
    gdpr_information_duties_headline_verdict_profile_for(art14_communication_limb_on_time, Profile),
    information_duty_verdict(Profile, eligible, _).
test(holiday_attested_is_eligible) :-
    gdpr_information_duties_headline_verdict_profile_for(art14_holiday_shift_on_time, Profile),
    information_duty_verdict(Profile, eligible, _).
test(effort_with_measures_is_eligible) :-
    gdpr_information_duties_headline_verdict_profile_for(art14_effort_exemption, Profile),
    information_duty_verdict(Profile, eligible, [cite(eu_reg_2016_679_art_14_5_b)]).
test(effort_without_measures_is_ineligible) :-
    gdpr_information_duties_headline_verdict_profile_for(art14_effort_without_measures, Profile),
    information_duty_verdict(Profile, ineligible, _).
test(law_attested_true_is_eligible) :-
    gdpr_information_duties_headline_verdict_profile_for(art14_law_exemption, Profile),
    information_duty_verdict(Profile, eligible, [cite(eu_reg_2016_679_art_14_5_c)]).
test(law_attested_false_is_ineligible) :-
    gdpr_information_duties_headline_verdict_profile_for(art14_law_attested_false, Profile),
    information_duty_verdict(Profile, ineligible, _).
test(secrecy_attested_true_is_eligible) :-
    gdpr_information_duties_headline_verdict_profile_for(art14_secrecy_exemption, Profile),
    information_duty_verdict(Profile, eligible, [cite(eu_reg_2016_679_art_14_5_d)]).
test(secrecy_flipped_to_false_is_ineligible) :-
    gdpr_information_duties_headline_verdict_profile_for(art14_secrecy_exemption, Profile),
    gdpr_information_duties_headline_verdict_what_if(Profile, professional_secrecy_obligation_by_law, attested(false, attestation(host, none, fixture_reason, none)), Status),
    Status == ineligible.
test(further_processing_prior_is_eligible) :-
    gdpr_information_duties_headline_verdict_profile_for(art13_further_processing_prior, Profile),
    information_duty_verdict(Profile, eligible, _).
test(further_processing_same_day_is_ineligible) :-
    gdpr_information_duties_headline_verdict_profile_for(art13_further_processing_same_day, Profile),
    information_duty_verdict(Profile, ineligible, _).
test(art13_exemption_is_none) :-
    gdpr_information_duties_headline_verdict_profile_for(art13_on_time, Profile),
    information_duty_exemption(Profile, none).

test(art13_one_day_late_is_not_eligible, fail) :-
    gdpr_information_duties_headline_verdict_profile_for(art13_one_day_late, Profile),
    information_duty_verdict(Profile, eligible, _).
test(art13_missing_item_is_not_eligible, fail) :-
    gdpr_information_duties_headline_verdict_profile_for(art13_missing_statutory_item, Profile),
    information_duty_verdict(Profile, eligible, _).
test(art14_one_day_over_is_not_eligible, fail) :-
    gdpr_information_duties_headline_verdict_profile_for(art14_one_day_late, Profile),
    information_duty_verdict(Profile, eligible, _).
test(art14_communication_limb_late_is_not_eligible, fail) :-
    gdpr_information_duties_headline_verdict_profile_for(art14_communication_limb_late, Profile),
    information_duty_verdict(Profile, eligible, _).
test(holiday_absent_is_not_eligible, fail) :-
    gdpr_information_duties_headline_verdict_profile_for(art14_holiday_absent_late, Profile),
    information_duty_verdict(Profile, eligible, _).
test(effort_without_measures_is_not_eligible, fail) :-
    gdpr_information_duties_headline_verdict_profile_for(art14_effort_without_measures, Profile),
    information_duty_verdict(Profile, eligible, _).
test(law_attested_false_is_not_eligible, fail) :-
    gdpr_information_duties_headline_verdict_profile_for(art14_law_attested_false, Profile),
    information_duty_verdict(Profile, eligible, _).
test(secrecy_flipped_to_false_is_not_eligible, fail) :-
    gdpr_information_duties_headline_verdict_profile_for(art14_secrecy_exemption, Profile),
    gdpr_information_duties_headline_verdict_what_if(Profile, professional_secrecy_obligation_by_law, attested(false, attestation(host, none, fixture_reason, none)), eligible).
test(further_processing_same_day_is_not_eligible, fail) :-
    gdpr_information_duties_headline_verdict_profile_for(art13_further_processing_same_day, Profile),
    information_duty_verdict(Profile, eligible, _).
test(art13_has_no_effort_exemption, fail) :-
    gdpr_information_duties_headline_verdict_profile_for(art13_on_time, Profile),
    information_duty_exemption(Profile, impossible_or_disproportionate_effort).

cp_test_names([verdict_atoms_are_real, exemption_atoms_are_real, art13_positive_is_eligible, art13_one_day_late_is_ineligible, art14_positive_is_eligible, art14_one_day_over_is_ineligible, art14_communication_limb_on_time_is_eligible, holiday_attested_is_eligible, effort_with_measures_is_eligible, effort_without_measures_is_ineligible, law_attested_true_is_eligible, law_attested_false_is_ineligible, secrecy_attested_true_is_eligible, secrecy_flipped_to_false_is_ineligible, further_processing_prior_is_eligible, further_processing_same_day_is_ineligible, art13_exemption_is_none]).
cp_test_fail_names([art13_one_day_late_is_not_eligible, art13_missing_item_is_not_eligible, art14_one_day_over_is_not_eligible, art14_communication_limb_late_is_not_eligible, holiday_absent_is_not_eligible, effort_without_measures_is_not_eligible, law_attested_false_is_not_eligible, secrecy_flipped_to_false_is_not_eligible, further_processing_same_day_is_not_eligible, art13_has_no_effort_exemption]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
