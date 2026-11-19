% SPDX-License-Identifier: EUPL-1.2
:- module(m__uk_uk_pecr_cookie_exemptions_and_fines_tests_test_negative_controls, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__uk_uk_pecr_cookie_exemptions_and_fines_uk_pecr_cookie_exemptions_and_fines, [uk_terminal_equipment_storage_or_access/3, eu_terminal_equipment_storage_or_access/3, compare_uk_eu_terminal_equipment_storage_or_access/5, uk_breach_notification_timing/3, uk_penalty_maximum_tier/3, uk_penalty_maximum_amount_in_pence/3]).
:- use_module(m__uk_uk_pecr_cookie_exemptions_and_fines_fixtures, [uk_pecr_cookie_exemptions_and_fines_profile_for/2]).

uk_answer(Subject, Result) :-
    uk_pecr_cookie_exemptions_and_fines_profile_for(Subject, Profile),
    uk_terminal_equipment_storage_or_access(Profile, Result, _).

breach_answer(Subject, Result) :-
    uk_pecr_cookie_exemptions_and_fines_profile_for(Subject, Profile),
    uk_breach_notification_timing(Profile, Result, _).

test(consent_way_permits) :-
    uk_answer(cookie_consent_given, permitted).
test(consent_withheld_is_not_permitted) :-
    uk_answer(cookie_consent_withheld, not_permitted).
test(transmission_way_permits) :-
    uk_answer(cookie_transmission_only, permitted).
test(transmission_absent_is_not_permitted) :-
    uk_answer(cookie_transmission_absent, not_permitted).
test(strictly_necessary_way_permits) :-
    uk_answer(cookie_strictly_necessary, permitted).
test(not_strictly_necessary_is_not_permitted) :-
    uk_answer(cookie_not_strictly_necessary, not_permitted).
test(statistics_way_permits) :-
    uk_answer(cookie_statistics, permitted).
test(statistics_on_emitted_signals_is_not_permitted) :-
    uk_answer(cookie_statistics_emitted_signals, not_permitted).
test(website_enhancement_way_permits) :-
    uk_answer(cookie_website_enhancement, permitted).
test(website_enhancement_objected_is_not_permitted) :-
    uk_answer(cookie_website_enhancement_objected, not_permitted).
test(emergency_location_way_permits) :-
    uk_answer(cookie_emergency_location, permitted).
test(emergency_without_location_purpose_is_not_permitted) :-
    uk_answer(cookie_emergency_without_location_purpose, not_permitted).
test(outside_regulation_6_is_not_applicable) :-
    uk_answer(cookie_outside_regulation_6, not_applicable).
test(within_regulation_6_no_way_is_not_permitted) :-
    uk_answer(cookie_within_regulation_6_no_way, not_permitted).
test(eu_transmission_permits) :-
    eu_terminal_equipment_storage_or_access([attribute(storage_or_access_in_terminal_equipment, true), attribute(storage_or_access_solely_for_transmission, true)], permitted, _).
test(eu_without_a_way_is_not_permitted) :-
    eu_terminal_equipment_storage_or_access([attribute(storage_or_access_in_terminal_equipment, true), attribute(storage_or_access_solely_for_transmission, false), attribute(service_explicitly_requested_by_user, false), attribute(user_consent_given, false)], not_permitted, _).
test(comparison_same) :-
    uk_pecr_cookie_exemptions_and_fines_profile_for(comparison_same, Profile),
    compare_uk_eu_terminal_equipment_storage_or_access(Profile, _, _, same, []).
test(comparison_differs) :-
    uk_pecr_cookie_exemptions_and_fines_profile_for(comparison_differs, Profile),
    compare_uk_eu_terminal_equipment_storage_or_access(Profile, _, _, differs, [_|_]).
test(breach_72nd_hour_in_time) :-
    breach_answer(breach_notified_in_72nd_hour, notification_in_time).
test(breach_73rd_hour_out_of_time) :-
    breach_answer(breach_notified_in_73rd_hour, notification_out_of_time).
test(breach_late_with_reasons) :-
    breach_answer(breach_late_with_reasons, notification_late_with_reasons).
test(breach_late_without_reasons_missing) :-
    breach_answer(breach_late_without_reasons, notification_reasons_for_delay_missing).
test(breach_undue_delay_out_of_time_within_72_hours) :-
    breach_answer(breach_undue_delay, notification_out_of_time).
test(breach_not_provider_not_applicable) :-
    breach_answer(breach_not_a_service_provider, not_applicable).
test(breach_earlier_awareness_refers) :-
    breach_answer(breach_awareness_before_amendment, needs_legal_review(cross_reference_unresolved(cite(uk_si_2025_904_reg_2_p), cite(uk_si_2003_2426_reg_5a_as_in_effect_before_20_august_2025)), _)).
test(listed_regulation_higher_tier) :-
    uk_pecr_cookie_exemptions_and_fines_profile_for(penalty_listed_regulation, Profile),
    uk_penalty_maximum_tier(Profile, higher_maximum_amount, _).
test(other_provision_standard_tier) :-
    uk_pecr_cookie_exemptions_and_fines_profile_for(penalty_other_provision, Profile),
    uk_penalty_maximum_tier(Profile, standard_maximum_amount, _).
test(earlier_act_refers) :-
    uk_pecr_cookie_exemptions_and_fines_profile_for(penalty_act_before_5_february_2026, Profile),
    uk_penalty_maximum_tier(Profile, needs_legal_review(cross_reference_unresolved(cite(uk_si_2026_82_reg_11_1), cite(uk_si_2003_2426_as_in_effect_before_5_february_2026)), _), []).
test(higher_tie_is_fixed_amount) :-
    uk_pecr_cookie_exemptions_and_fines_profile_for(amount_higher_tie, Profile),
    uk_penalty_maximum_amount_in_pence(Profile, Amount, _),
    Amount =:= 1750000000.
test(not_an_undertaking_gets_fixed_amount) :-
    uk_pecr_cookie_exemptions_and_fines_profile_for(amount_not_an_undertaking, Profile),
    uk_penalty_maximum_amount_in_pence(Profile, Amount, _),
    Amount =:= 1750000000.
test(unknown_key_is_input_problem) :-
    uk_pecr_cookie_exemptions_and_fines_profile_for(input_problem_unknown_key, Profile),
    uk_terminal_equipment_storage_or_access(Profile, input_problems([unknown_key(colour)]), []).

test(consent_withheld_does_not_permit, fail) :-
    uk_answer(cookie_consent_withheld, permitted).
test(transmission_absent_does_not_permit, fail) :-
    uk_answer(cookie_transmission_absent, permitted).
test(not_strictly_necessary_does_not_permit, fail) :-
    uk_answer(cookie_not_strictly_necessary, permitted).
test(statistics_on_emitted_signals_does_not_permit, fail) :-
    uk_answer(cookie_statistics_emitted_signals, permitted).
test(website_enhancement_objected_does_not_permit, fail) :-
    uk_answer(cookie_website_enhancement_objected, permitted).
test(emergency_without_location_purpose_does_not_permit, fail) :-
    uk_answer(cookie_emergency_without_location_purpose, permitted).
test(within_regulation_6_is_not_not_applicable, fail) :-
    uk_answer(cookie_within_regulation_6_no_way, not_applicable).
test(eu_without_a_way_does_not_permit, fail) :-
    eu_terminal_equipment_storage_or_access([attribute(storage_or_access_in_terminal_equipment, true), attribute(storage_or_access_solely_for_transmission, false), attribute(service_explicitly_requested_by_user, false), attribute(user_consent_given, false)], permitted, _).
test(comparison_differs_is_not_same, fail) :-
    uk_pecr_cookie_exemptions_and_fines_profile_for(comparison_differs, Profile),
    compare_uk_eu_terminal_equipment_storage_or_access(Profile, _, _, same, _).
test(breach_73rd_hour_not_in_time, fail) :-
    breach_answer(breach_notified_in_73rd_hour, notification_in_time).
test(breach_late_without_reasons_not_lawful, fail) :-
    breach_answer(breach_late_without_reasons, notification_late_with_reasons).
test(breach_undue_delay_not_in_time, fail) :-
    breach_answer(breach_undue_delay, notification_in_time).
test(breach_provider_is_applicable, fail) :-
    breach_answer(breach_notified_in_72nd_hour, not_applicable).
test(breach_later_awareness_does_not_refer, fail) :-
    breach_answer(breach_notified_in_72nd_hour, needs_legal_review(_, _)).
test(other_provision_not_higher_tier, fail) :-
    uk_pecr_cookie_exemptions_and_fines_profile_for(penalty_other_provision, Profile),
    uk_penalty_maximum_tier(Profile, higher_maximum_amount, _).
test(earlier_act_gets_no_tier, fail) :-
    uk_pecr_cookie_exemptions_and_fines_profile_for(penalty_act_before_5_february_2026, Profile),
    uk_penalty_maximum_tier(Profile, higher_maximum_amount, _).
test(above_higher_tie_is_not_fixed_amount, fail) :-
    uk_pecr_cookie_exemptions_and_fines_profile_for(amount_higher_above_tie, Profile),
    uk_penalty_maximum_amount_in_pence(Profile, 1750000000, _).
test(not_an_undertaking_gets_no_percentage, fail) :-
    uk_pecr_cookie_exemptions_and_fines_profile_for(amount_not_an_undertaking, Profile),
    uk_penalty_maximum_amount_in_pence(Profile, 1750000004, _).
test(clean_profile_is_no_input_problem, fail) :-
    uk_pecr_cookie_exemptions_and_fines_profile_for(cookie_consent_given, Profile),
    uk_terminal_equipment_storage_or_access(Profile, input_problems(_), _).

cp_test_names([consent_way_permits, consent_withheld_is_not_permitted, transmission_way_permits, transmission_absent_is_not_permitted, strictly_necessary_way_permits, not_strictly_necessary_is_not_permitted, statistics_way_permits, statistics_on_emitted_signals_is_not_permitted, website_enhancement_way_permits, website_enhancement_objected_is_not_permitted, emergency_location_way_permits, emergency_without_location_purpose_is_not_permitted, outside_regulation_6_is_not_applicable, within_regulation_6_no_way_is_not_permitted, eu_transmission_permits, eu_without_a_way_is_not_permitted, comparison_same, comparison_differs, breach_72nd_hour_in_time, breach_73rd_hour_out_of_time, breach_late_with_reasons, breach_late_without_reasons_missing, breach_undue_delay_out_of_time_within_72_hours, breach_not_provider_not_applicable, breach_earlier_awareness_refers, listed_regulation_higher_tier, other_provision_standard_tier, earlier_act_refers, higher_tie_is_fixed_amount, not_an_undertaking_gets_fixed_amount, unknown_key_is_input_problem]).
cp_test_fail_names([consent_withheld_does_not_permit, transmission_absent_does_not_permit, not_strictly_necessary_does_not_permit, statistics_on_emitted_signals_does_not_permit, website_enhancement_objected_does_not_permit, emergency_without_location_purpose_does_not_permit, within_regulation_6_is_not_not_applicable, eu_without_a_way_does_not_permit, comparison_differs_is_not_same, breach_73rd_hour_not_in_time, breach_late_without_reasons_not_lawful, breach_undue_delay_not_in_time, breach_provider_is_applicable, breach_later_awareness_does_not_refer, other_provision_not_higher_tier, earlier_act_gets_no_tier, above_higher_tie_is_not_fixed_amount, not_an_undertaking_gets_no_percentage, clean_profile_is_no_input_problem]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
