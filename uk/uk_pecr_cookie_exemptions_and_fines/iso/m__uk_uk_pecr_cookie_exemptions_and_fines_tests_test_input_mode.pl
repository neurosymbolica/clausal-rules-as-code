% SPDX-License-Identifier: EUPL-1.2
:- module(m__uk_uk_pecr_cookie_exemptions_and_fines_tests_test_input_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__uk_uk_pecr_cookie_exemptions_and_fines_uk_pecr_cookie_exemptions_and_fines, [uk_terminal_equipment_storage_or_access/3, eu_terminal_equipment_storage_or_access/3, compare_uk_eu_terminal_equipment_storage_or_access/5, uk_breach_notification_timing/3, uk_penalty_maximum_tier/3, uk_penalty_maximum_amount_in_pence/3, uk_pecr_cookie_exemptions_and_fines_status/2]).
:- use_module(m__uk_uk_pecr_cookie_exemptions_and_fines_kernel, [uk_pecr_cookie_exemptions_and_fines_input_problems/2]).
:- use_module(m__uk_uk_pecr_cookie_exemptions_and_fines_fixtures, [uk_pecr_cookie_exemptions_and_fines_profile_for/2]).

test(uk_permitted_holds_bound) :-
    uk_pecr_cookie_exemptions_and_fines_profile_for(cookie_consent_given, Profile),
    uk_terminal_equipment_storage_or_access(Profile, permitted, _).
test(uk_not_applicable_holds_bound) :-
    uk_pecr_cookie_exemptions_and_fines_profile_for(cookie_outside_regulation_6, Profile),
    uk_terminal_equipment_storage_or_access(Profile, not_applicable, [cite(uk_si_2003_2426_reg_6_1), cite(uk_si_2003_2426_reg_6_2)]).
test(status_projection_holds_bound) :-
    uk_pecr_cookie_exemptions_and_fines_profile_for(cookie_within_regulation_6_no_way, Profile),
    uk_pecr_cookie_exemptions_and_fines_status(Profile, not_permitted).
test(eu_permitted_holds_bound) :-
    eu_terminal_equipment_storage_or_access([attribute(storage_or_access_in_terminal_equipment, true), attribute(storage_or_access_solely_for_transmission, true)], permitted, [cite(eu_dir_2002_58_art_5_3)]).
test(comparison_holds_bound) :-
    uk_pecr_cookie_exemptions_and_fines_profile_for(comparison_differs, Profile),
    compare_uk_eu_terminal_equipment_storage_or_access(Profile, permitted, not_applicable, differs, _).
test(breach_in_time_holds_bound) :-
    uk_pecr_cookie_exemptions_and_fines_profile_for(breach_notified_in_72nd_hour, Profile),
    uk_breach_notification_timing(Profile, notification_in_time, _).
test(tier_higher_holds_bound) :-
    uk_pecr_cookie_exemptions_and_fines_profile_for(penalty_listed_regulation, Profile),
    uk_penalty_maximum_tier(Profile, higher_maximum_amount, _).
test(amount_holds_bound) :-
    uk_pecr_cookie_exemptions_and_fines_profile_for(amount_higher_tie, Profile),
    uk_penalty_maximum_amount_in_pence(Profile, 1750000000, _).
test(unbound_profile_is_wrong_type) :-
    findall(Problems, uk_pecr_cookie_exemptions_and_fines_input_problems(_UnboundProfile, Problems), Answers),
    Answers == [[wrong_type(profile)]].
test(atom_profile_is_wrong_type) :-
    findall(Problems, uk_pecr_cookie_exemptions_and_fines_input_problems(profile, Problems), Answers),
    Answers == [[wrong_type(profile)]].
test(partial_list_is_wrong_type) :-
    findall(Problems, uk_pecr_cookie_exemptions_and_fines_input_problems([attribute(user_consent_given, true)|_Tail], Problems), Answers),
    Answers == [[wrong_type(profile)]].
test(non_attribute_element_is_wrong_type) :-
    findall(Problems, uk_pecr_cookie_exemptions_and_fines_input_problems([attribute(user_consent_given, true), user_consent_given - true], Problems), Answers),
    Answers == [[wrong_type(profile)]].
test(empty_profile_has_no_problem) :-
    findall(Problems, uk_pecr_cookie_exemptions_and_fines_input_problems([], Problems), Answers),
    Answers == [[]].
test(unbound_value_is_wrong_type) :-
    findall(Problems, uk_pecr_cookie_exemptions_and_fines_input_problems([attribute(user_consent_given, _Value)], Problems), Answers),
    Answers == [[wrong_type(user_consent_given)]].
test(unsure_crisp_key_is_wrong_type) :-
    findall(Problems, uk_pecr_cookie_exemptions_and_fines_input_problems([attribute(subscriber_or_user_has_not_objected, unsure)], Problems), Answers),
    Answers == [[wrong_type(subscriber_or_user_has_not_objected)]].
test(float_hours_are_wrong_type) :-
    findall(Problems, uk_pecr_cookie_exemptions_and_fines_input_problems([attribute(hours_elapsed_at_notification, 72.5)], Problems), Answers),
    Answers == [[wrong_type(hours_elapsed_at_notification)]].
test(negative_turnover_is_wrong_type) :-
    findall(Problems, uk_pecr_cookie_exemptions_and_fines_input_problems([attribute(total_annual_worldwide_turnover_in_preceding_financial_year_in_pounds, -1)], Problems), Answers),
    Answers == [[wrong_type(total_annual_worldwide_turnover_in_preceding_financial_year_in_pounds)]].
test(attested_value_is_wrong_type) :-
    findall(Problems, uk_pecr_cookie_exemptions_and_fines_input_problems([attribute(user_consent_given, attested(true))], Problems), Answers),
    Answers == [[wrong_type(user_consent_given)]].
test(provision_outside_the_list_is_wrong_type) :-
    findall(Problems, uk_pecr_cookie_exemptions_and_fines_input_problems([attribute(provision_infringed, regulation_99)], Problems), Answers),
    Answers == [[wrong_type(provision_infringed)]].
test(numeric_key_is_unknown) :-
    findall(Problems, uk_pecr_cookie_exemptions_and_fines_input_problems([attribute(42, true)], Problems), Answers),
    Answers == [[unknown_key(42)]].
test(duplicate_key_is_named_once_and_not_typed) :-
    findall(Problems, uk_pecr_cookie_exemptions_and_fines_input_problems([attribute(user_consent_given, true), attribute(user_consent_given, maybe)], Problems), Answers),
    Answers == [[duplicate_key(user_consent_given)]].
test(contract_problems_come_before_unknown_keys) :-
    findall(Problems, uk_pecr_cookie_exemptions_and_fines_input_problems([attribute(colour, red), attribute(colour, blue), attribute(hours_elapsed_at_notification, -1), attribute(storage_or_access_within_regulation_6, maybe)], Problems), Answers),
    Answers == [[wrong_type(storage_or_access_within_regulation_6), wrong_type(hours_elapsed_at_notification), unknown_key(colour)]].
test(queries_answer_input_problems_first) :-
    Profile = [attribute(colour, true), attribute(storage_or_access_within_regulation_6, false)],
    uk_terminal_equipment_storage_or_access(Profile, UnitedKingdomResult, UnitedKingdomCitations),
    UnitedKingdomResult == input_problems([unknown_key(colour)]),
    UnitedKingdomCitations == [],
    uk_breach_notification_timing(Profile, BreachResult, []),
    BreachResult == input_problems([unknown_key(colour)]),
    uk_penalty_maximum_amount_in_pence(Profile, AmountResult, []),
    AmountResult == input_problems([unknown_key(colour)]).
test(comparison_carries_input_problems_in_three_positions) :-
    compare_uk_eu_terminal_equipment_storage_or_access([attribute(user_consent_given, yes)], UnitedKingdomResult, UnionResult, Difference, ChangedBy),
    UnitedKingdomResult == input_problems([wrong_type(user_consent_given)]),
    UnionResult == input_problems([wrong_type(user_consent_given)]),
    Difference == input_problems([wrong_type(user_consent_given)]),
    ChangedBy == [].

test(uk_not_permitted_rejected_when_bound_for_consent, fail) :-
    uk_pecr_cookie_exemptions_and_fines_profile_for(cookie_consent_given, Profile),
    uk_terminal_equipment_storage_or_access(Profile, not_permitted, _).
test(comparison_same_rejected_when_bound_for_differs, fail) :-
    uk_pecr_cookie_exemptions_and_fines_profile_for(comparison_differs, Profile),
    compare_uk_eu_terminal_equipment_storage_or_access(Profile, _, _, same, _).
test(breach_out_of_time_rejected_when_bound_for_72nd_hour, fail) :-
    uk_pecr_cookie_exemptions_and_fines_profile_for(breach_notified_in_72nd_hour, Profile),
    uk_breach_notification_timing(Profile, notification_out_of_time, _).
test(tier_standard_rejected_when_bound_for_listed_regulation, fail) :-
    uk_pecr_cookie_exemptions_and_fines_profile_for(penalty_listed_regulation, Profile),
    uk_penalty_maximum_tier(Profile, standard_maximum_amount, _).
test(wrong_amount_rejected_when_bound, fail) :-
    uk_pecr_cookie_exemptions_and_fines_profile_for(amount_higher_tie, Profile),
    uk_penalty_maximum_amount_in_pence(Profile, 1750000001, _).

cp_test_names([uk_permitted_holds_bound, uk_not_applicable_holds_bound, status_projection_holds_bound, eu_permitted_holds_bound, comparison_holds_bound, breach_in_time_holds_bound, tier_higher_holds_bound, amount_holds_bound, unbound_profile_is_wrong_type, atom_profile_is_wrong_type, partial_list_is_wrong_type, non_attribute_element_is_wrong_type, empty_profile_has_no_problem, unbound_value_is_wrong_type, unsure_crisp_key_is_wrong_type, float_hours_are_wrong_type, negative_turnover_is_wrong_type, attested_value_is_wrong_type, provision_outside_the_list_is_wrong_type, numeric_key_is_unknown, duplicate_key_is_named_once_and_not_typed, contract_problems_come_before_unknown_keys, queries_answer_input_problems_first, comparison_carries_input_problems_in_three_positions]).
cp_test_fail_names([uk_not_permitted_rejected_when_bound_for_consent, comparison_same_rejected_when_bound_for_differs, breach_out_of_time_rejected_when_bound_for_72nd_hour, tier_standard_rejected_when_bound_for_listed_regulation, wrong_amount_rejected_when_bound]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
