% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_ctpp_oversight_tests_test_queries, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_dora_ctpp_oversight_queries, [dora_ctpp_oversight_profile_keys/1, dora_ctpp_oversight_what_if/4, not_designated_as_critical/0, penalty_decision_required/0, lead_overseer_agreement_required/0]).
:- use_module(m__eu_dora_ctpp_oversight_kernel, [dora_ctpp_oversight_input_problems/2]).
:- use_module(m__eu_dora_ctpp_oversight_dora_ctpp_oversight, [dora_ctpp_oversight_status/2, dora_ctpp_oversight_checklist/2, ctpp_response_window_status/3]).
:- use_module(m__eu_dora_ctpp_oversight_fixtures, [dora_ctpp_oversight_profile_for/2]).

contract_key(Key) :-
    dora_ctpp_oversight_input_problems([attribute(Key, odd_value_marker)], [wrong_type(Key)]).

cited_item(item(_, _, [_|_])).

item_identifier(item(Identifier, _, _), Identifier).

not_designated_item(item(_, not_designated_as_critical, _)).

test(profile_keys_are_the_contract_keys) :-
    dora_ctpp_oversight_profile_keys(ProfileKeys),
    ProfileKeys == [provider_designated_as_critical, response_window, draft_oversight_plan_received_on, annual_oversight_plan_adopted_and_notified, oversight_activities_completed, provider_plans_further_subcontracting_arrangement, envisaged_subcontractor_is_ict_provider_or_subcontractor_in_third_country, subcontracting_concerns_critical_or_important_functions, lead_overseer_deems_clear_and_serious_risk, recommendation_information_opportunity_given_on, measure_power, measure_compliance, measure_notification_received_on, penalty_decision_notified_on, preceding_business_year_worldwide_turnover, preceding_business_year_length_in_days, assessment_date].
test(every_schema_key_is_checked_by_the_input_check) :-
    dora_ctpp_oversight_profile_keys(ProfileKeys),
    maplist(contract_key, ProfileKeys).
test(the_re_exported_input_check_names_an_unknown_key) :-
    dora_ctpp_oversight_input_problems([attribute(colour, blue)], Problems),
    Problems == [unknown_key(colour)].
test(eligibility_full_profile_is_under_oversight) :-
    dora_ctpp_oversight_profile_for(designated_provider_full_profile, Profile),
    findall(Status, dora_ctpp_oversight_status(Profile, Status), Statuses),
    Statuses == [subject_to_lead_overseer_oversight].
test(justification_every_checklist_item_is_cited) :-
    dora_ctpp_oversight_profile_for(designated_provider_full_profile, Profile),
    dora_ctpp_oversight_checklist(Profile, Items),
    maplist(cited_item, Items),
    maplist(item_identifier, Items, Identifiers),
    Identifiers == [oversight_duties_required, lead_overseer_powers, response_window_status, periodic_penalty_payment_status, periodic_penalty_payment_limits, competent_authority_measure_condition].
test(justification_not_designated_items_all_say_so) :-
    dora_ctpp_oversight_profile_for(not_designated_provider, Profile),
    dora_ctpp_oversight_checklist(Profile, Items),
    length(Items, 6),
    maplist(not_designated_item, Items).
test(deadline_statement_window_gives_its_last_day) :-
    dora_ctpp_oversight_profile_for(statement_window_last_day, Profile),
    findall(Result, ctpp_response_window_status(Profile, Result, _), Results),
    Results == [window_open(date(2026, 3, 17))].
test(what_if_designation_flips_the_status) :-
    dora_ctpp_oversight_profile_for(not_designated_provider, Profile),
    findall(Status, dora_ctpp_oversight_what_if(Profile, provider_designated_as_critical, true, Status), Statuses),
    Statuses == [subject_to_lead_overseer_oversight].
test(what_if_a_float_year_length_gives_input_problems) :-
    FloatDays is float(365),
    dora_ctpp_oversight_what_if([attribute(provider_designated_as_critical, true)], preceding_business_year_length_in_days, FloatDays, oversight_input_problems).
test(what_if_an_integer_year_length_keeps_oversight) :-
    dora_ctpp_oversight_what_if([attribute(provider_designated_as_critical, true)], preceding_business_year_length_in_days, 365, subject_to_lead_overseer_oversight).
test(final_answer_atoms_are_served) :-
    not_designated_as_critical,
    penalty_decision_required,
    lead_overseer_agreement_required.

cp_test_names([profile_keys_are_the_contract_keys, every_schema_key_is_checked_by_the_input_check, the_re_exported_input_check_names_an_unknown_key, eligibility_full_profile_is_under_oversight, justification_every_checklist_item_is_cited, justification_not_designated_items_all_say_so, deadline_statement_window_gives_its_last_day, what_if_designation_flips_the_status, what_if_a_float_year_length_gives_input_problems, what_if_an_integer_year_length_keeps_oversight, final_answer_atoms_are_served]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
