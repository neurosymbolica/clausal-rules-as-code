% SPDX-License-Identifier: EUPL-1.2
:- module(m__sg_securities_sfa_offer_exemptions_tests_test_output_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__sg_securities_sfa_offer_exemptions_sfa_offer_exemptions, [decide_sfa_offer_exemptions/2, sfa_offer_exemptions_status/2]).
:- use_module(m__sg_securities_sfa_offer_exemptions_fixtures, [sfa_offer_exemptions_profile_for/2]).

test(institutional_profile_yields_exactly_one_status) :-
    sfa_offer_exemptions_profile_for(s274_institutional_positive, Profile),
    findall(Status, sfa_offer_exemptions_status(Profile, Status), Statuses),
    Statuses == [exempt].
test(institutional_profile_full_result) :-
    sfa_offer_exemptions_profile_for(s274_institutional_positive, Profile),
    decide_sfa_offer_exemptions(Profile, offer_exemption(exempt, [s274], 1000000, 0, [sg_sfa_2001_s274])).
test(relevant_person_profile_full_result) :-
    sfa_offer_exemptions_profile_for(s275_1_relevant_positive, Profile),
    decide_sfa_offer_exemptions(Profile, offer_exemption(exempt, [s275_1], 1000000, 0, [sg_sfa_2001_s275_1])).
test(placement_at_limit_yields_exempt_with_s272b) :-
    sfa_offer_exemptions_profile_for(s272b_placement_at_person_limit, Profile),
    decide_sfa_offer_exemptions(Profile, offer_exemption(exempt, [s272b], 1000000, 50, [sg_sfa_2001_s272b_1])).
test(placement_over_limit_yields_prospectus_required) :-
    sfa_offer_exemptions_profile_for(s272b_placement_over_person_limit, Profile),
    decide_sfa_offer_exemptions(Profile, offer_exemption(prospectus_required, [], 1000000, 51, [sg_sfa_2001_s240])).
test(combined_profile_yields_both_citations) :-
    sfa_offer_exemptions_profile_for(s274_and_s275_combined, Profile),
    decide_sfa_offer_exemptions(Profile, offer_exemption(exempt, [s274, s275_1], 1000000, 0, [sg_sfa_2001_s274, sg_sfa_2001_s275_1])).
test(indeterminate_profile_yields_no_aggregates) :-
    sfa_offer_exemptions_profile_for(indeterminate_missing_prospectus_state, Profile),
    decide_sfa_offer_exemptions(Profile, offer_exemption(indeterminate, [], n_a, n_a, [])).

cp_test_names([institutional_profile_yields_exactly_one_status, institutional_profile_full_result, relevant_person_profile_full_result, placement_at_limit_yields_exempt_with_s272b, placement_over_limit_yields_prospectus_required, combined_profile_yields_both_citations, indeterminate_profile_yields_no_aggregates]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
