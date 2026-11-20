% SPDX-License-Identifier: EUPL-1.2
:- module(m__sg_securities_sfa_offer_exemptions_tests_test_public_interface, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__sg_securities_sfa_offer_exemptions_sfa_offer_exemptions, [sfa_offer_exemption/2, decide_sfa_offer_exemptions/2, sfa_offer_exemptions_status/2, sfa_offer_exemptions_checklist/2, sfa_offer_exemptions_decision_resolvable/1, sfa_offer_exemptions_status_values/1]).
:- use_module(m__sg_securities_sfa_offer_exemptions_queries, [sfa_offer_exemptions_what_if/4, sfa_offer_exemptions_profile_keys/1]).
:- use_module(m__sg_securities_sfa_offer_exemptions_fixtures, [sfa_offer_exemptions_subject/1, sfa_offer_exemptions_profile_for/2, sfa_offer_exemptions_assess/2]).

test(s274_institutional_is_exempt) :-
    sfa_offer_exemptions_assess(s274_institutional_positive, offer_exemption(exempt, [s274], 1000000, 0, [sg_sfa_2001_s274])).
test(s275_1_relevant_is_exempt) :-
    sfa_offer_exemptions_assess(s275_1_relevant_positive, offer_exemption(exempt, [s275_1], 1000000, 0, [sg_sfa_2001_s275_1])).
test(s275_1_relevant_near_miss_requires_prospectus) :-
    sfa_offer_exemptions_assess(s275_1_relevant_near_miss, offer_exemption(prospectus_required, [], 1000000, 2, [sg_sfa_2001_s240])).
test(s275_1a_at_minimum_is_exempt) :-
    sfa_offer_exemptions_assess(s275_1a_principal_at_minimum, offer_exemption(exempt, [s275_1a], 1000000, 51, [sg_sfa_2001_s275_1a])).
test(s275_1a_below_minimum_requires_prospectus) :-
    sfa_offer_exemptions_assess(s275_1a_principal_below_minimum, offer_exemption(prospectus_required, [], 1000000, 51, [sg_sfa_2001_s240])).
test(s272a_at_amount_limit_is_exempt) :-
    sfa_offer_exemptions_assess(s272a_small_at_amount_limit, offer_exemption(exempt, [s272a], 500000000, 51, [sg_sfa_2001_s272a_1])).
test(s272a_over_amount_limit_requires_prospectus) :-
    sfa_offer_exemptions_assess(s272a_small_over_amount_limit, offer_exemption(prospectus_required, [], 500000001, 51, [sg_sfa_2001_s240])).
test(s272b_at_person_limit_is_exempt) :-
    sfa_offer_exemptions_assess(s272b_placement_at_person_limit, offer_exemption(exempt, [s272b], 1000000, 50, [sg_sfa_2001_s272b_1])).
test(s272b_over_person_limit_requires_prospectus) :-
    sfa_offer_exemptions_assess(s272b_placement_over_person_limit, offer_exemption(prospectus_required, [], 1000000, 51, [sg_sfa_2001_s240])).
test(combined_institutional_and_relevant_is_exempt) :-
    sfa_offer_exemptions_assess(s274_and_s275_combined, offer_exemption(exempt, [s274, s275_1], 1000000, 0, [sg_sfa_2001_s274, sg_sfa_2001_s275_1])).
test(missing_prospectus_state_is_indeterminate) :-
    sfa_offer_exemptions_assess(indeterminate_missing_prospectus_state, offer_exemption(indeterminate, [], n_a, n_a, [])).
test(zero_offerees_is_indeterminate) :-
    sfa_offer_exemptions_assess(indeterminate_zero_offerees, offer_exemption(indeterminate, [], n_a, n_a, [])).
test(status_predicate_gives_exempt) :-
    sfa_offer_exemptions_profile_for(s274_institutional_positive, Profile),
    sfa_offer_exemptions_status(Profile, exempt).
test(status_predicate_gives_prospectus_required) :-
    sfa_offer_exemptions_profile_for(s275_1_relevant_near_miss, Profile),
    sfa_offer_exemptions_status(Profile, prospectus_required).
test(status_predicate_gives_indeterminate) :-
    sfa_offer_exemptions_profile_for(indeterminate_zero_offerees, Profile),
    sfa_offer_exemptions_status(Profile, indeterminate).
test(checklist_is_nonempty_on_exempt) :-
    sfa_offer_exemptions_profile_for(s274_institutional_positive, Profile),
    sfa_offer_exemptions_checklist(Profile, [_FirstItem|_OtherItems]).
test(checklist_is_nonempty_on_prospectus_required) :-
    sfa_offer_exemptions_profile_for(s275_1_relevant_near_miss, Profile),
    sfa_offer_exemptions_checklist(Profile, [_FirstItem|_OtherItems]).
test(checklist_is_nonempty_on_indeterminate) :-
    sfa_offer_exemptions_profile_for(indeterminate_zero_offerees, Profile),
    sfa_offer_exemptions_checklist(Profile, [_FirstItem|_OtherItems]).
test(decision_resolvable_on_all_fixtures) :-
    sfa_offer_exemptions_subject(Subject),
    sfa_offer_exemptions_profile_for(Subject, Profile),
    sfa_offer_exemptions_decision_resolvable(Profile).
test(status_values_are_the_three_verdicts) :-
    sfa_offer_exemptions_status_values(StatusValues),
    sort(StatusValues, [exempt, indeterminate, prospectus_required]).
test(what_if_overriding_prospectus_state_flips_to_prospectus_required) :-
    sfa_offer_exemptions_profile_for(s274_institutional_positive, Profile),
    sfa_offer_exemptions_what_if(advertisement, true, Profile, offer_exemption(exempt, [s274], 1000000, 0, [sg_sfa_2001_s274])).
test(what_if_overriding_advertisement_on_relevant_flips_verdict) :-
    sfa_offer_exemptions_profile_for(s275_1_relevant_positive, Profile),
    sfa_offer_exemptions_what_if(advertisement, true, Profile, offer_exemption(prospectus_required, [], 1000000, 2, [sg_sfa_2001_s240])).
test(profile_keys_contains_all_required) :-
    sfa_offer_exemptions_profile_keys(Keys),
    member(offer_date, Keys),
    member(institutional_offerees, Keys),
    member(relevant_person_offerees, Keys),
    member(other_offerees, Keys),
    member(amount_raised_cents, Keys),
    member(advertisement, Keys),
    member(non_permitted_selling_expenses, Keys),
    member(prospectus_state, Keys).
test(called_contract_gives_exempt_on_s274) :-
    sfa_offer_exemptions_profile_for(s274_institutional_positive, Profile),
    sfa_offer_exemption(Profile, offer_exemption(exempt, [s274], 1000000, 0, [sg_sfa_2001_s274])).
test(called_contract_gives_prospectus_required_on_near_miss) :-
    sfa_offer_exemptions_profile_for(s272b_placement_over_person_limit, Profile),
    sfa_offer_exemption(Profile, offer_exemption(prospectus_required, [], 1000000, 51, [sg_sfa_2001_s240])).

cp_test_names([s274_institutional_is_exempt, s275_1_relevant_is_exempt, s275_1_relevant_near_miss_requires_prospectus, s275_1a_at_minimum_is_exempt, s275_1a_below_minimum_requires_prospectus, s272a_at_amount_limit_is_exempt, s272a_over_amount_limit_requires_prospectus, s272b_at_person_limit_is_exempt, s272b_over_person_limit_requires_prospectus, combined_institutional_and_relevant_is_exempt, missing_prospectus_state_is_indeterminate, zero_offerees_is_indeterminate, status_predicate_gives_exempt, status_predicate_gives_prospectus_required, status_predicate_gives_indeterminate, checklist_is_nonempty_on_exempt, checklist_is_nonempty_on_prospectus_required, checklist_is_nonempty_on_indeterminate, decision_resolvable_on_all_fixtures, status_values_are_the_three_verdicts, what_if_overriding_prospectus_state_flips_to_prospectus_required, what_if_overriding_advertisement_on_relevant_flips_verdict, profile_keys_contains_all_required, called_contract_gives_exempt_on_s274, called_contract_gives_prospectus_required_on_near_miss]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
