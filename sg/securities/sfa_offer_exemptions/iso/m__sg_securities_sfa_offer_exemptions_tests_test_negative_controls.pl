% SPDX-License-Identifier: EUPL-1.2
:- module(m__sg_securities_sfa_offer_exemptions_tests_test_negative_controls, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__sg_securities_sfa_offer_exemptions_sfa_offer_exemptions, [sfa_offer_exemptions_status/2, sfa_offer_exemptions_status_values/1]).
:- use_module(m__sg_securities_sfa_offer_exemptions_fixtures, [sfa_offer_exemptions_profile_for/2]).

test(s274_positive_is_exempt) :-
    sfa_offer_exemptions_profile_for(s274_institutional_positive, Profile),
    sfa_offer_exemptions_status(Profile, exempt).
test(s274_near_miss_is_prospectus_required) :-
    sfa_offer_exemptions_profile_for(s274_institutional_near_miss, Profile),
    sfa_offer_exemptions_status(Profile, prospectus_required).
test(s275_1_positive_is_exempt) :-
    sfa_offer_exemptions_profile_for(s275_1_relevant_positive, Profile),
    sfa_offer_exemptions_status(Profile, exempt).
test(s275_1_near_miss_is_prospectus_required) :-
    sfa_offer_exemptions_profile_for(s275_1_relevant_near_miss, Profile),
    sfa_offer_exemptions_status(Profile, prospectus_required).
test(s275_1a_at_minimum_is_exempt) :-
    sfa_offer_exemptions_profile_for(s275_1a_principal_at_minimum, Profile),
    sfa_offer_exemptions_status(Profile, exempt).
test(s275_1a_below_minimum_is_prospectus_required) :-
    sfa_offer_exemptions_profile_for(s275_1a_principal_below_minimum, Profile),
    sfa_offer_exemptions_status(Profile, prospectus_required).
test(s272a_at_amount_limit_is_exempt) :-
    sfa_offer_exemptions_profile_for(s272a_small_at_amount_limit, Profile),
    sfa_offer_exemptions_status(Profile, exempt).
test(s272a_over_amount_limit_is_prospectus_required) :-
    sfa_offer_exemptions_profile_for(s272a_small_over_amount_limit, Profile),
    sfa_offer_exemptions_status(Profile, prospectus_required).
test(s272b_at_person_limit_is_exempt) :-
    sfa_offer_exemptions_profile_for(s272b_placement_at_person_limit, Profile),
    sfa_offer_exemptions_status(Profile, exempt).
test(s272b_over_person_limit_is_prospectus_required) :-
    sfa_offer_exemptions_profile_for(s272b_placement_over_person_limit, Profile),
    sfa_offer_exemptions_status(Profile, prospectus_required).
test(status_values_are_the_three_expected_atoms) :-
    sfa_offer_exemptions_status_values(StatusValues),
    StatusValues == [exempt, prospectus_required, indeterminate].

test(s274_near_miss_is_not_exempt, fail) :-
    sfa_offer_exemptions_profile_for(s274_institutional_near_miss, Profile),
    sfa_offer_exemptions_status(Profile, exempt).
test(s275_1_near_miss_is_not_exempt, fail) :-
    sfa_offer_exemptions_profile_for(s275_1_relevant_near_miss, Profile),
    sfa_offer_exemptions_status(Profile, exempt).
test(s275_1a_below_minimum_is_not_exempt, fail) :-
    sfa_offer_exemptions_profile_for(s275_1a_principal_below_minimum, Profile),
    sfa_offer_exemptions_status(Profile, exempt).
test(s272a_over_amount_limit_is_not_exempt, fail) :-
    sfa_offer_exemptions_profile_for(s272a_small_over_amount_limit, Profile),
    sfa_offer_exemptions_status(Profile, exempt).
test(s272b_over_person_limit_is_not_exempt, fail) :-
    sfa_offer_exemptions_profile_for(s272b_placement_over_person_limit, Profile),
    sfa_offer_exemptions_status(Profile, exempt).

cp_test_names([s274_positive_is_exempt, s274_near_miss_is_prospectus_required, s275_1_positive_is_exempt, s275_1_near_miss_is_prospectus_required, s275_1a_at_minimum_is_exempt, s275_1a_below_minimum_is_prospectus_required, s272a_at_amount_limit_is_exempt, s272a_over_amount_limit_is_prospectus_required, s272b_at_person_limit_is_exempt, s272b_over_person_limit_is_prospectus_required, status_values_are_the_three_expected_atoms]).
cp_test_fail_names([s274_near_miss_is_not_exempt, s275_1_near_miss_is_not_exempt, s275_1a_below_minimum_is_not_exempt, s272a_over_amount_limit_is_not_exempt, s272b_over_person_limit_is_not_exempt]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
