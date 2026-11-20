% SPDX-License-Identifier: EUPL-1.2
:- module(m__sg_securities_sfa_offer_exemptions_tests_test_input_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__sg_securities_sfa_offer_exemptions_sfa_offer_exemptions, [sfa_offer_exemptions_status/2]).
:- use_module(m__sg_securities_sfa_offer_exemptions_fixtures, [sfa_offer_exemptions_profile_for/2]).

test(institutional_profile_status_is_exempt) :-
    sfa_offer_exemptions_profile_for(s274_institutional_positive, Profile),
    sfa_offer_exemptions_status(Profile, exempt).
test(relevant_failure_status_is_prospectus_required) :-
    sfa_offer_exemptions_profile_for(s275_1_relevant_near_miss, Profile),
    sfa_offer_exemptions_status(Profile, prospectus_required).
test(indeterminate_profile_status_is_indeterminate) :-
    sfa_offer_exemptions_profile_for(indeterminate_missing_prospectus_state, Profile),
    sfa_offer_exemptions_status(Profile, indeterminate).
test(zero_offerees_status_is_indeterminate) :-
    sfa_offer_exemptions_profile_for(indeterminate_zero_offerees, Profile),
    sfa_offer_exemptions_status(Profile, indeterminate).

test(institutional_profile_status_is_not_prospectus_required, fail) :-
    sfa_offer_exemptions_profile_for(s274_institutional_positive, Profile),
    sfa_offer_exemptions_status(Profile, prospectus_required).
test(relevant_failure_status_is_not_exempt, fail) :-
    sfa_offer_exemptions_profile_for(s275_1_relevant_near_miss, Profile),
    sfa_offer_exemptions_status(Profile, exempt).
test(indeterminate_profile_status_is_not_exempt, fail) :-
    sfa_offer_exemptions_profile_for(indeterminate_missing_prospectus_state, Profile),
    sfa_offer_exemptions_status(Profile, exempt).
test(zero_offerees_status_is_not_prospectus_required, fail) :-
    sfa_offer_exemptions_profile_for(indeterminate_zero_offerees, Profile),
    sfa_offer_exemptions_status(Profile, prospectus_required).

cp_test_names([institutional_profile_status_is_exempt, relevant_failure_status_is_prospectus_required, indeterminate_profile_status_is_indeterminate, zero_offerees_status_is_indeterminate]).
cp_test_fail_names([institutional_profile_status_is_not_prospectus_required, relevant_failure_status_is_not_exempt, indeterminate_profile_status_is_not_exempt, zero_offerees_status_is_not_prospectus_required]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
