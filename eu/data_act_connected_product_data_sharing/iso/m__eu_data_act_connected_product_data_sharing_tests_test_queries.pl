% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_act_connected_product_data_sharing_tests_test_queries, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_act_connected_product_data_sharing_queries, [data_act_connected_product_data_sharing_profile_keys/1, data_act_connected_product_data_sharing_what_if/4]).
:- use_module(m__eu_data_act_connected_product_data_sharing_kernel, [data_act_connected_product_data_sharing_input_problems/2]).
:- use_module(m__eu_data_act_connected_product_data_sharing_data_act_connected_product_data_sharing, [decide_data_act_connected_product_data_sharing/2, data_act_connected_product_data_sharing_checklist/2, data_act_connected_product_data_sharing_decision_resolvable/1, data_act_connected_product_data_sharing_status_values/1]).
:- use_module(m__eu_data_act_connected_product_data_sharing_fixtures, [data_act_connected_product_data_sharing_profile_for/2, data_act_connected_product_data_sharing_assess/2]).

fixture(Subject, Profile) :-
    data_act_connected_product_data_sharing_profile_for(Subject, Profile).

test(profile_keys_are_the_contract_keys) :-
    data_act_connected_product_data_sharing_profile_keys(ProfileKeys),
    ProfileKeys == [connected_product_or_related_service, small_enterprise_exemption_applies, placed_on_market_after_12_september_2026, data_accessible_by_default_as_required, directly_accessible_where_relevant_and_feasible, pre_contract_contract_kind, required_information_provided_before_contract, requester_is_user, request_by_or_on_behalf_of_user, addressee_is_data_holder, requested_data_readily_available, data_directly_accessible_by_user, security_restriction_agreed_applies, testing_data_not_yet_on_market, third_party_use_contractually_permitted, third_party_is_designated_gatekeeper, other_persons_personal_data_requested, gdpr_conditions_for_making_available_met, requested_data_identified_as_trade_secrets, trade_secret_disclosure_strictly_necessary, trade_secret_measures_agreed_and_kept, exceptional_trade_secret_refusal_invoked].
test(eligibility_verdict_with_citation) :-
    fixture(thermostat_access_due, Profile),
    decide_data_act_connected_product_data_sharing(Profile, data_act_connected_product_data_sharing_verdict(eligible, [cite(eu_reg_2023_2854_art_4_1)])).
test(eligibility_verdict_for_a_refusal) :-
    fixture(thermostat_security_restriction, Profile),
    decide_data_act_connected_product_data_sharing(Profile, data_act_connected_product_data_sharing_verdict(ineligible, [cite(eu_reg_2023_2854_art_4_2)])).
test(eligibility_through_the_fixture_wrapper) :-
    data_act_connected_product_data_sharing_assess(tractor_trade_secret_measures_breached, data_act_connected_product_data_sharing_verdict(ineligible, [cite(eu_reg_2023_2854_art_4_7)])).
test(eligibility_status_values) :-
    data_act_connected_product_data_sharing_status_values(Values),
    Values == [eligible, ineligible].
test(eligibility_is_resolvable_on_a_bad_profile) :-
    fixture(input_not_a_list, Profile),
    data_act_connected_product_data_sharing_decision_resolvable(Profile).
test(checklist_marks_the_security_restriction_unmet) :-
    fixture(thermostat_security_restriction, Profile),
    data_act_connected_product_data_sharing_checklist(Profile, Items),
    length(Items, 10),
    member(item(no_security_restriction, unmet(security_restriction_agreed), cite(eu_reg_2023_2854_art_4_2)), Items).
test(checklist_marks_an_unsure_judgement_unknown) :-
    fixture(access_data_holder_unsure, Profile),
    data_act_connected_product_data_sharing_checklist(Profile, Items),
    member(item(addressee_data_holder, unknown([addressee_is_data_holder]), cite(eu_reg_2023_2854_art_2_13)), Items).
test(checklist_accepts_a_clean_profile) :-
    fixture(thermostat_access_due, Profile),
    data_act_connected_product_data_sharing_checklist(Profile, [_|_]).
test(what_if_measures_breached_flips_to_ineligible) :-
    fixture(tractor_trade_secret_measures_kept, Profile),
    findall(Status, data_act_connected_product_data_sharing_what_if(Profile, trade_secret_measures_agreed_and_kept, false, Status), Statuses),
    Statuses == [ineligible].
test(what_if_an_unsure_judgement_that_does_not_matter_stays_settled) :-
    fixture(thermostat_access_due, Profile),
    findall(Status, data_act_connected_product_data_sharing_what_if(Profile, trade_secret_measures_agreed_and_kept, unsure, Status), Statuses),
    Statuses == [eligible].
test(what_if_an_unsure_judgement_that_matters_is_referred) :-
    fixture(thermostat_access_due, Profile),
    data_act_connected_product_data_sharing_what_if(Profile, security_restriction_agreed_applies, unsure, needs_legal_review(open_textured(security_restriction_agreed_applies, cite(eu_reg_2023_2854_art_4_2)), [inputs_relied_on(_)])).
test(what_if_a_wrong_type_is_an_input_problem) :-
    fixture(thermostat_access_due, Profile),
    findall(Status, data_act_connected_product_data_sharing_what_if(Profile, requester_is_user, maybe, Status), Statuses),
    Statuses == [input_problems([wrong_type(requester_is_user)])].
test(what_if_replaces_every_duplicate_occurrence) :-
    fixture(input_duplicate_key, Profile),
    findall(Status, data_act_connected_product_data_sharing_what_if(Profile, requester_is_user, true, Status), Statuses),
    Statuses == [indeterminate([connected_product_or_related_service])].
test(what_if_on_a_non_list_reports_the_profile) :-
    fixture(input_not_a_list, Profile),
    findall(Status, data_act_connected_product_data_sharing_what_if(Profile, requester_is_user, true, Status), Statuses),
    Statuses == [input_problems([wrong_type(profile)])].
test(input_check_re_exported) :-
    data_act_connected_product_data_sharing_input_problems([attribute(colour, red)], [unknown_key(colour)]).
test(input_check_clean_profile) :-
    fixture(sharing_due_clean, Profile),
    data_act_connected_product_data_sharing_input_problems(Profile, []).
test(result_terms_destructure) :-
    Referral = needs_legal_review(open_textured(requester_is_user, cite(eu_reg_2023_2854_art_2_12)), [inputs_relied_on([requester_is_user - unsure])]),
    Referral = needs_legal_review(open_textured(Key, cite(CitationKey)), [inputs_relied_on(Pairs)]),
    Key == requester_is_user,
    CitationKey == eu_reg_2023_2854_art_2_12,
    Pairs == [requester_is_user - unsure].

test(checklist_refuses_a_profile_with_input_problems, fail) :-
    fixture(input_unknown_key, Profile),
    data_act_connected_product_data_sharing_checklist(Profile, _).
test(what_if_same_value_is_not_ineligible, fail) :-
    fixture(thermostat_access_due, Profile),
    data_act_connected_product_data_sharing_what_if(Profile, data_directly_accessible_by_user, false, ineligible).

cp_test_names([profile_keys_are_the_contract_keys, eligibility_verdict_with_citation, eligibility_verdict_for_a_refusal, eligibility_through_the_fixture_wrapper, eligibility_status_values, eligibility_is_resolvable_on_a_bad_profile, checklist_marks_the_security_restriction_unmet, checklist_marks_an_unsure_judgement_unknown, checklist_accepts_a_clean_profile, what_if_measures_breached_flips_to_ineligible, what_if_an_unsure_judgement_that_does_not_matter_stays_settled, what_if_an_unsure_judgement_that_matters_is_referred, what_if_a_wrong_type_is_an_input_problem, what_if_replaces_every_duplicate_occurrence, what_if_on_a_non_list_reports_the_profile, input_check_re_exported, input_check_clean_profile, result_terms_destructure]).
cp_test_fail_names([checklist_refuses_a_profile_with_input_problems, what_if_same_value_is_not_ineligible]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
