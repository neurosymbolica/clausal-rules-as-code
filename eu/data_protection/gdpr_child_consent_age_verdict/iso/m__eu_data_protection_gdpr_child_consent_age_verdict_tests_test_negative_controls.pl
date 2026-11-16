% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_child_consent_age_verdict_tests_test_negative_controls, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_child_consent_age_verdict_child_consent_ground, [child_consent_ground_status/2, child_consent_ground_status_values/1, child_consent_ground/2, decide_child_consent/2]).
:- use_module(m__eu_data_protection_gdpr_child_consent_age_verdict_queries, [gdpr_child_consent_age_verdict_what_if/4]).
:- use_module(m__eu_data_protection_gdpr_child_consent_age_verdict_fixtures, [gdpr_child_consent_age_verdict_profile_for/2]).

test(the_ground_atoms_are_real_ground_atoms) :-
    child_consent_ground_status_values(Values),
    member(child_at_least_16, Values),
    member(parental_consent_given, Values),
    member(child_at_least_national_age, Values),
    member(parental_consent_missing_below_13, Values),
    member(parental_consent_missing_below_national_age, Values),
    member(art8_not_engaged, Values).
test(not_engaged_positive) :-
    gdpr_child_consent_age_verdict_profile_for(consent_not_the_basis, Profile),
    child_consent_ground(Profile, art8_not_engaged).
test(not_engaged_near_miss_consent_is_the_basis) :-
    gdpr_child_consent_age_verdict_profile_for(consent_not_the_basis, Profile),
    gdpr_child_consent_age_verdict_what_if(Profile, processing_rests_on_consent, true, indeterminate([parental_consent_given])).
test(sixteen_positive) :-
    gdpr_child_consent_age_verdict_profile_for(adult_at_sixteen, Profile),
    child_consent_ground(Profile, child_at_least_16).
test(fifteen_near_miss_needs_the_parental_answer) :-
    gdpr_child_consent_age_verdict_profile_for(adult_at_sixteen, Profile),
    gdpr_child_consent_age_verdict_what_if(Profile, child_age_years, 15, indeterminate([parental_consent_given])).
test(parental_consent_positive) :-
    gdpr_child_consent_age_verdict_profile_for(twelve_with_reasonable_verification, Profile),
    child_consent_ground(Profile, parental_consent_given).
test(parental_consent_near_miss_withdrawn) :-
    gdpr_child_consent_age_verdict_profile_for(twelve_with_reasonable_verification, Profile),
    gdpr_child_consent_age_verdict_what_if(Profile, parental_consent_given, false, ineligible).
test(below_thirteen_positive) :-
    gdpr_child_consent_age_verdict_profile_for(twelve_without_parental_consent, Profile),
    child_consent_ground(Profile, parental_consent_missing_below_13).
test(thirteen_near_miss_turns_to_national_law) :-
    gdpr_child_consent_age_verdict_profile_for(twelve_without_parental_consent, Profile),
    gdpr_child_consent_age_verdict_what_if(Profile, child_age_years, 13, indeterminate([member_state, member_state_selection_test, consent_date])).
test(national_age_positive) :-
    gdpr_child_consent_age_verdict_profile_for(fourteen_at_national_age, Profile),
    child_consent_ground(Profile, child_at_least_national_age).
test(national_age_near_miss_one_year_younger) :-
    gdpr_child_consent_age_verdict_profile_for(fourteen_at_national_age, Profile),
    gdpr_child_consent_age_verdict_what_if(Profile, child_age_years, 13, ineligible).
test(below_national_age_positive) :-
    gdpr_child_consent_age_verdict_profile_for(thirteen_below_national_age, Profile),
    child_consent_ground(Profile, parental_consent_missing_below_national_age).
test(below_national_age_near_miss_one_year_older) :-
    gdpr_child_consent_age_verdict_profile_for(thirteen_below_national_age, Profile),
    gdpr_child_consent_age_verdict_what_if(Profile, child_age_years, 14, eligible).
test(other_state_positive) :-
    gdpr_child_consent_age_verdict_profile_for(fourteen_national_age_other_state, Profile),
    child_consent_ground(Profile, none).
test(other_state_near_miss_same_state) :-
    gdpr_child_consent_age_verdict_profile_for(fourteen_national_age_other_state, Profile),
    gdpr_child_consent_age_verdict_what_if(Profile, member_state, germany, ineligible).
test(verification_positive) :-
    gdpr_child_consent_age_verdict_profile_for(twelve_with_reasonable_verification, Profile),
    decide_child_consent(Profile, gdpr_child_consent_verdict(eligible, parental_consent_given, efforts_reasonable, _)).
test(verification_near_miss_not_reasonable) :-
    gdpr_child_consent_age_verdict_profile_for(twelve_with_unreasonable_verification, Profile),
    decide_child_consent(Profile, gdpr_child_consent_verdict(eligible, parental_consent_given, efforts_not_reasonable, _)).
test(verification_is_not_applicable_when_the_child_is_16) :-
    gdpr_child_consent_age_verdict_profile_for(adult_at_sixteen, Profile),
    decide_child_consent(Profile, gdpr_child_consent_verdict(eligible, child_at_least_16, not_applicable, _)).
test(engagement_unsure_positive) :-
    gdpr_child_consent_age_verdict_profile_for(service_judgement_unsure, Profile),
    child_consent_ground_status(Profile, needs_legal_review(open_textured(information_society_service, _), _)).
test(engagement_unsure_near_miss_answered_false) :-
    gdpr_child_consent_age_verdict_profile_for(service_judgement_unsure, Profile),
    gdpr_child_consent_age_verdict_what_if(Profile, information_society_service, false, eligible).

test(not_engaged_near_miss_keeps_no_engagement_ground, fail) :-
    gdpr_child_consent_age_verdict_profile_for(consent_not_the_basis, Profile),
    gdpr_child_consent_age_verdict_what_if(Profile, processing_rests_on_consent, true, eligible).
test(fifteen_near_miss_is_not_eligible_on_its_own, fail) :-
    gdpr_child_consent_age_verdict_profile_for(adult_at_sixteen, Profile),
    gdpr_child_consent_age_verdict_what_if(Profile, child_age_years, 15, eligible).
test(parental_consent_near_miss_is_not_eligible, fail) :-
    gdpr_child_consent_age_verdict_profile_for(twelve_with_reasonable_verification, Profile),
    gdpr_child_consent_age_verdict_what_if(Profile, parental_consent_given, false, eligible).
test(thirteen_near_miss_is_not_the_below_thirteen_ground, fail) :-
    gdpr_child_consent_age_verdict_profile_for(twelve_without_parental_consent, Profile),
    gdpr_child_consent_age_verdict_what_if(Profile, child_age_years, 13, ineligible).
test(national_age_near_miss_child_is_not_eligible, fail) :-
    gdpr_child_consent_age_verdict_profile_for(fourteen_at_national_age, Profile),
    gdpr_child_consent_age_verdict_what_if(Profile, child_age_years, 13, eligible).
test(verification_near_miss_is_not_reasonable, fail) :-
    gdpr_child_consent_age_verdict_profile_for(twelve_with_unreasonable_verification, Profile),
    decide_child_consent(Profile, gdpr_child_consent_verdict(_, _, efforts_reasonable, _)).

cp_test_names([the_ground_atoms_are_real_ground_atoms, not_engaged_positive, not_engaged_near_miss_consent_is_the_basis, sixteen_positive, fifteen_near_miss_needs_the_parental_answer, parental_consent_positive, parental_consent_near_miss_withdrawn, below_thirteen_positive, thirteen_near_miss_turns_to_national_law, national_age_positive, national_age_near_miss_one_year_younger, below_national_age_positive, below_national_age_near_miss_one_year_older, other_state_positive, other_state_near_miss_same_state, verification_positive, verification_near_miss_not_reasonable, verification_is_not_applicable_when_the_child_is_16, engagement_unsure_positive, engagement_unsure_near_miss_answered_false]).
cp_test_fail_names([not_engaged_near_miss_keeps_no_engagement_ground, fifteen_near_miss_is_not_eligible_on_its_own, parental_consent_near_miss_is_not_eligible, thirteen_near_miss_is_not_the_below_thirteen_ground, national_age_near_miss_child_is_not_eligible, verification_near_miss_is_not_reasonable]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
