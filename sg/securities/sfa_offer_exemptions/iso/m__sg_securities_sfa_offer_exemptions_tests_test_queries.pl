% SPDX-License-Identifier: EUPL-1.2
:- module(m__sg_securities_sfa_offer_exemptions_tests_test_queries, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__sg_securities_sfa_offer_exemptions_queries, [sfa_offer_exemptions_profile_keys/1, sfa_offer_exemptions_what_if/4, sfa_offer_exemptions_threshold/5]).
:- use_module(m__sg_securities_sfa_offer_exemptions_fixtures, [sfa_offer_exemptions_profile_for/2]).

test(profile_keys_include_offer_date) :-
    sfa_offer_exemptions_profile_keys(Keys),
    member(offer_date, Keys).
test(profile_keys_include_amount_raised_cents) :-
    sfa_offer_exemptions_profile_keys(Keys),
    member(amount_raised_cents, Keys).
test(profile_keys_include_prospectus_state) :-
    sfa_offer_exemptions_profile_keys(Keys),
    member(prospectus_state, Keys).
test(what_if_overriding_advertisement_to_true_flips_to_prospectus_required) :-
    sfa_offer_exemptions_profile_for(s275_1_relevant_positive, Profile),
    sfa_offer_exemptions_what_if(advertisement, true, Profile, offer_exemption(prospectus_required, _, _, _, _)).
test(what_if_overriding_advertisement_to_false_restores_exempt) :-
    sfa_offer_exemptions_profile_for(s275_1_relevant_positive, Profile),
    sfa_offer_exemptions_what_if(advertisement, false, Profile, offer_exemption(exempt, _, _, _, _)).
test(what_if_overriding_prospectus_state_to_registered_not_notified_flips) :-
    sfa_offer_exemptions_profile_for(s275_1_relevant_positive, Profile),
    sfa_offer_exemptions_what_if(prospectus_state, registered_not_notified, Profile, offer_exemption(prospectus_required, _, _, _, _)).
test(threshold_for_amount_raised_cents_finds_the_boundary) :-
    sfa_offer_exemptions_profile_for(s272a_small_at_amount_limit, Profile),
    sfa_offer_exemptions_threshold(Profile, amount_raised_cents, 499999999, 500000001, Boundary),
    Boundary == 500000000.

cp_test_names([profile_keys_include_offer_date, profile_keys_include_amount_raised_cents, profile_keys_include_prospectus_state, what_if_overriding_advertisement_to_true_flips_to_prospectus_required, what_if_overriding_advertisement_to_false_restores_exempt, what_if_overriding_prospectus_state_to_registered_not_notified_flips, threshold_for_amount_raised_cents_finds_the_boundary]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
