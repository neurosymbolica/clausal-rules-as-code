% SPDX-License-Identifier: EUPL-1.2
:- module(m__uk_uk_pecr_cookie_exemptions_and_fines_tests_test_queries, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__uk_uk_pecr_cookie_exemptions_and_fines_queries, [uk_pecr_cookie_exemptions_and_fines_profile_keys/1, uk_pecr_cookie_exemptions_and_fines_what_if/4, uk_pecr_cookie_exemptions_and_fines_obligations/2, permitted/0, unsure/0, not_attempted/0]).
:- use_module(m__uk_uk_pecr_cookie_exemptions_and_fines_kernel, [uk_pecr_cookie_exemptions_and_fines_input_problems/2]).
:- use_module(m__uk_uk_pecr_cookie_exemptions_and_fines_uk_pecr_cookie_exemptions_and_fines, [decide_uk_pecr_cookie_exemptions_and_fines/2, compare_uk_eu_terminal_equipment_storage_or_access/5]).
:- use_module(m__uk_uk_pecr_cookie_exemptions_and_fines_fixtures, [uk_pecr_cookie_exemptions_and_fines_profile_for/2, uk_pecr_cookie_exemptions_and_fines_assess/2]).

test(profile_keys_are_the_contract_keys) :-
    uk_pecr_cookie_exemptions_and_fines_profile_keys(ProfileKeys),
    ProfileKeys == [storage_or_access_within_regulation_6, clear_and_comprehensive_information_about_the_purpose_provided, consent_to_the_storage_or_access_given, technical_storage_or_access_solely_for_transmission_of_a_communication, information_society_service_requested_by_the_subscriber_or_user, storage_or_access_strictly_necessary_for_the_requested_service, person_provides_an_information_society_service, sole_purpose_is_statistical_information_to_improve_the_service_or_website, collected_information_shared_only_to_assist_with_improvements, access_does_not_collect_or_monitor_automatically_emitted_information, simple_free_means_of_objecting_given, subscriber_or_user_has_not_objected, person_provides_an_information_society_service_by_means_of_a_website, sole_purpose_is_adapting_or_enhancing_website_appearance_or_functionality, communication_received_requests_or_indicates_need_of_emergency_assistance, sole_purpose_is_ascertaining_geographical_position_for_emergency_assistance, storage_or_access_in_terminal_equipment, storage_or_access_solely_for_transmission, service_explicitly_requested_by_user, strictly_necessary_to_provide_requested_service, user_consent_given, clear_and_comprehensive_information_provided, provider_of_a_public_electronic_communications_service, personal_data_breach_occurred, became_aware_on_or_after_20_august_2025, notification_made_without_undue_delay, hours_elapsed_at_notification, notification_within_72_hours_was_feasible, notification_accompanied_by_reasons_for_the_delay, act_or_omission_on_or_after_5_february_2026, provision_infringed, penalised_person_is_an_undertaking, total_annual_worldwide_turnover_in_preceding_financial_year_in_pounds].
test(profile_keys_count_thirty_three) :-
    uk_pecr_cookie_exemptions_and_fines_profile_keys(ProfileKeys),
    length(ProfileKeys, 33).
test(eligibility_verdict_through_the_assess_wrapper) :-
    findall(Verdict, uk_pecr_cookie_exemptions_and_fines_assess(cookie_strictly_necessary, Verdict), Verdicts),
    Verdicts = [uk_pecr_cookie_exemptions_and_fines_verdict(permitted, [_|_])].
test(eligibility_verdict_for_an_empty_profile_is_indeterminate) :-
    decide_uk_pecr_cookie_exemptions_and_fines([], uk_pecr_cookie_exemptions_and_fines_verdict(Status, Citations)),
    Status == indeterminate([storage_or_access_within_regulation_6]),
    Citations == [].
test(comparison_yields_one_answer) :-
    uk_pecr_cookie_exemptions_and_fines_profile_for(comparison_same, Profile),
    findall(Difference, compare_uk_eu_terminal_equipment_storage_or_access(Profile, _, _, Difference, _), Differences),
    Differences == [same].
test(what_if_flips_withheld_consent_to_permitted) :-
    uk_pecr_cookie_exemptions_and_fines_profile_for(cookie_consent_withheld, Profile),
    findall(Status, uk_pecr_cookie_exemptions_and_fines_what_if(Profile, consent_to_the_storage_or_access_given, true, Status), Statuses),
    Statuses == [permitted].
test(what_if_unsure_gate_on_no_way_profile_is_referred) :-
    uk_pecr_cookie_exemptions_and_fines_profile_for(cookie_within_regulation_6_no_way, Profile),
    uk_pecr_cookie_exemptions_and_fines_what_if(Profile, storage_or_access_within_regulation_6, unsure, Status),
    Status = needs_legal_review(open_textured(storage_or_access_within_regulation_6, cite(uk_si_2003_2426_reg_6_1)), _).
test(obligations_for_late_notification_with_reasons) :-
    uk_pecr_cookie_exemptions_and_fines_profile_for(breach_late_with_reasons, Profile),
    uk_pecr_cookie_exemptions_and_fines_obligations(Profile, Obligations),
    Obligations == [obligation(notify_personal_data_breach_to_the_information_commission_without_undue_delay_and_where_feasible_within_72_hours, cite(uk_si_2003_2426_reg_5a_2)), obligation(accompany_notification_with_reasons_for_the_delay, cite(uk_si_2003_2426_reg_5a_3a))].
test(obligations_for_refused_cookie) :-
    uk_pecr_cookie_exemptions_and_fines_profile_for(cookie_consent_withheld, Profile),
    uk_pecr_cookie_exemptions_and_fines_obligations(Profile, Obligations),
    Obligations == [obligation(do_not_store_or_access_information_in_terminal_equipment, cite(uk_si_2003_2426_reg_6_1))].
test(no_obligations_for_permitted_cookie) :-
    uk_pecr_cookie_exemptions_and_fines_profile_for(cookie_consent_given, Profile),
    uk_pecr_cookie_exemptions_and_fines_obligations(Profile, Obligations),
    Obligations == [].
test(no_obligations_for_earlier_awareness) :-
    uk_pecr_cookie_exemptions_and_fines_profile_for(breach_awareness_before_amendment, Profile),
    uk_pecr_cookie_exemptions_and_fines_obligations(Profile, Obligations),
    Obligations == [].
test(query_layer_input_check) :-
    uk_pecr_cookie_exemptions_and_fines_input_problems([attribute(colour, true)], Problems),
    Problems == [unknown_key(colour)].
test(vocabulary_is_callable) :-
    permitted,
    unsure,
    not_attempted.

cp_test_names([profile_keys_are_the_contract_keys, profile_keys_count_thirty_three, eligibility_verdict_through_the_assess_wrapper, eligibility_verdict_for_an_empty_profile_is_indeterminate, comparison_yields_one_answer, what_if_flips_withheld_consent_to_permitted, what_if_unsure_gate_on_no_way_profile_is_referred, obligations_for_late_notification_with_reasons, obligations_for_refused_cookie, no_obligations_for_permitted_cookie, no_obligations_for_earlier_awareness, query_layer_input_check, vocabulary_is_callable]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
