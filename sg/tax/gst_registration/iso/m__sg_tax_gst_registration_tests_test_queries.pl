% SPDX-License-Identifier: EUPL-1.2
:- module(m__sg_tax_gst_registration_tests_test_queries, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__sg_tax_gst_registration_queries, [gst_registration_profile_keys/1, gst_registration_eligibility/2, gst_registration_deadline/3, gst_registration_threshold/2]).
:- use_module(m__sg_tax_gst_registration_fixtures, [gst_registration_profile_for/2]).

test(profile_keys_include_required_keys) :-
    gst_registration_profile_keys(ProfileKeys),
    member(is_registered, ProfileKeys),
    member(calendar_year, ProfileKeys),
    member(forecast_start_date, ProfileKeys).
test(eligibility_liable_profile_is_eligible) :-
    gst_registration_profile_for(retrospective_liable_just_above_threshold, Profile),
    gst_registration_eligibility(Profile, eligibility(eligible, _Checklist)).
test(eligibility_at_threshold_profile_is_ineligible) :-
    gst_registration_profile_for(retrospective_not_liable_at_threshold, Profile),
    gst_registration_eligibility(Profile, eligibility(ineligible, _Checklist)).
test(eligibility_missing_inputs_is_indeterminate) :-
    gst_registration_profile_for(retrospective_indeterminate_missing_taxable_supplies, Profile),
    gst_registration_eligibility(Profile, eligibility(indeterminate, _Checklist)).
test(deadline_retrospective_liable_has_dates) :-
    gst_registration_profile_for(retrospective_liable_just_above_threshold, Profile),
    gst_registration_deadline(Profile, deadline(date(2023, 1, 30), date(2023, 3, 1)), registration_required).
test(deadline_retrospective_not_liable_has_no_dates) :-
    gst_registration_profile_for(retrospective_not_liable_at_threshold, Profile),
    gst_registration_deadline(Profile, deadline(n_a, n_a), no_consequence).
test(deadline_missing_inputs_is_indeterminate) :-
    gst_registration_profile_for(retrospective_indeterminate_missing_taxable_supplies, Profile),
    gst_registration_deadline(Profile, deadline(n_a, n_a), indeterminate).
test(threshold_retrospective_is_one_million_cents) :-
    gst_registration_threshold(retrospective, threshold(100000000, _Citations)).
test(threshold_prospective_is_one_million_cents) :-
    gst_registration_threshold(prospective, threshold(100000000, _Citations)).

cp_test_names([profile_keys_include_required_keys, eligibility_liable_profile_is_eligible, eligibility_at_threshold_profile_is_ineligible, eligibility_missing_inputs_is_indeterminate, deadline_retrospective_liable_has_dates, deadline_retrospective_not_liable_has_no_dates, deadline_missing_inputs_is_indeterminate, threshold_retrospective_is_one_million_cents, threshold_prospective_is_one_million_cents]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
