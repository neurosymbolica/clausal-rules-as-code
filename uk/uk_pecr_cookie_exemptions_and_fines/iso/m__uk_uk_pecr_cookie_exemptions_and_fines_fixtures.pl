% SPDX-License-Identifier: EUPL-1.2
:- module(m__uk_uk_pecr_cookie_exemptions_and_fines_fixtures, [uk_pecr_cookie_exemptions_and_fines_subject/1, uk_pecr_cookie_exemptions_and_fines_profile_for/2, uk_pecr_cookie_exemptions_and_fines_assess/2]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(library(reif), [memberd_t/3]).
:- use_module(m__uk_uk_pecr_cookie_exemptions_and_fines_uk_pecr_cookie_exemptions_and_fines, [decide_uk_pecr_cookie_exemptions_and_fines/2]).

uk_pecr_cookie_exemptions_and_fines_subject(cookie_consent_given).
uk_pecr_cookie_exemptions_and_fines_subject(cookie_consent_withheld).
uk_pecr_cookie_exemptions_and_fines_subject(cookie_transmission_only).
uk_pecr_cookie_exemptions_and_fines_subject(cookie_transmission_absent).
uk_pecr_cookie_exemptions_and_fines_subject(cookie_strictly_necessary).
uk_pecr_cookie_exemptions_and_fines_subject(cookie_not_strictly_necessary).
uk_pecr_cookie_exemptions_and_fines_subject(cookie_statistics).
uk_pecr_cookie_exemptions_and_fines_subject(cookie_statistics_emitted_signals).
uk_pecr_cookie_exemptions_and_fines_subject(cookie_website_enhancement).
uk_pecr_cookie_exemptions_and_fines_subject(cookie_website_enhancement_objected).
uk_pecr_cookie_exemptions_and_fines_subject(cookie_emergency_location).
uk_pecr_cookie_exemptions_and_fines_subject(cookie_emergency_without_location_purpose).
uk_pecr_cookie_exemptions_and_fines_subject(cookie_outside_regulation_6).
uk_pecr_cookie_exemptions_and_fines_subject(cookie_within_regulation_6_no_way).
uk_pecr_cookie_exemptions_and_fines_subject(comparison_same).
uk_pecr_cookie_exemptions_and_fines_subject(comparison_differs).
uk_pecr_cookie_exemptions_and_fines_subject(breach_notified_in_72nd_hour).
uk_pecr_cookie_exemptions_and_fines_subject(breach_notified_in_73rd_hour).
uk_pecr_cookie_exemptions_and_fines_subject(breach_late_with_reasons).
uk_pecr_cookie_exemptions_and_fines_subject(breach_late_without_reasons).
uk_pecr_cookie_exemptions_and_fines_subject(breach_undue_delay).
uk_pecr_cookie_exemptions_and_fines_subject(breach_awareness_before_amendment).
uk_pecr_cookie_exemptions_and_fines_subject(breach_not_a_service_provider).
uk_pecr_cookie_exemptions_and_fines_subject(penalty_listed_regulation).
uk_pecr_cookie_exemptions_and_fines_subject(penalty_other_provision).
uk_pecr_cookie_exemptions_and_fines_subject(penalty_act_before_5_february_2026).
uk_pecr_cookie_exemptions_and_fines_subject(amount_higher_tie).
uk_pecr_cookie_exemptions_and_fines_subject(amount_higher_above_tie).
uk_pecr_cookie_exemptions_and_fines_subject(amount_standard_tie).
uk_pecr_cookie_exemptions_and_fines_subject(amount_standard_above_tie).
uk_pecr_cookie_exemptions_and_fines_subject(amount_not_an_undertaking).
uk_pecr_cookie_exemptions_and_fines_subject(input_problem_unknown_key).

united_kingdom_cookie_keys([storage_or_access_within_regulation_6, clear_and_comprehensive_information_about_the_purpose_provided, consent_to_the_storage_or_access_given, technical_storage_or_access_solely_for_transmission_of_a_communication, information_society_service_requested_by_the_subscriber_or_user, storage_or_access_strictly_necessary_for_the_requested_service, person_provides_an_information_society_service, sole_purpose_is_statistical_information_to_improve_the_service_or_website, collected_information_shared_only_to_assist_with_improvements, access_does_not_collect_or_monitor_automatically_emitted_information, simple_free_means_of_objecting_given, subscriber_or_user_has_not_objected, person_provides_an_information_society_service_by_means_of_a_website, sole_purpose_is_adapting_or_enhancing_website_appearance_or_functionality, communication_received_requests_or_indicates_need_of_emergency_assistance, sole_purpose_is_ascertaining_geographical_position_for_emergency_assistance]).

union_cookie_keys([storage_or_access_in_terminal_equipment, storage_or_access_solely_for_transmission, service_explicitly_requested_by_user, strictly_necessary_to_provide_requested_service, user_consent_given, clear_and_comprehensive_information_provided]).

truth_attributes(KeyList, TrueKeyList, Attributes) :-
    maplist(truth_attribute(TrueKeyList), KeyList, Attributes).

truth_attribute(TrueKeyList, KeyName, attribute(KeyName, Truth)) :-
    memberd_t(KeyName, TrueKeyList, Truth).

united_kingdom_cookie_profile(TrueKeyList, Profile) :-
    united_kingdom_cookie_keys(KeyList),
    truth_attributes(KeyList, TrueKeyList, Profile).

comparison_profile(UnitedKingdomTrueKeys, UnionTrueKeys, Profile) :-
    united_kingdom_cookie_profile(UnitedKingdomTrueKeys, UnitedKingdomPart),
    union_cookie_keys(UnionKeyList),
    truth_attributes(UnionKeyList, UnionTrueKeys, UnionPart),
    append(UnitedKingdomPart, UnionPart, Profile).

breach_profile(Provider, Breach, Aware, Undue, HoursElapsed, Feasible, Reasons, [attribute(provider_of_a_public_electronic_communications_service, Provider), attribute(personal_data_breach_occurred, Breach), attribute(became_aware_on_or_after_20_august_2025, Aware), attribute(notification_made_without_undue_delay, Undue), attribute(hours_elapsed_at_notification, HoursElapsed), attribute(notification_within_72_hours_was_feasible, Feasible), attribute(notification_accompanied_by_reasons_for_the_delay, Reasons)]).

penalty_profile(Dated, Provision, Undertaking, TurnoverPounds, [attribute(act_or_omission_on_or_after_5_february_2026, Dated), attribute(provision_infringed, Provision), attribute(penalised_person_is_an_undertaking, Undertaking), attribute(total_annual_worldwide_turnover_in_preceding_financial_year_in_pounds, TurnoverPounds)]).

uk_pecr_cookie_exemptions_and_fines_profile_for(cookie_consent_given, Profile) :-
    united_kingdom_cookie_profile([storage_or_access_within_regulation_6, clear_and_comprehensive_information_about_the_purpose_provided, consent_to_the_storage_or_access_given], Profile).
uk_pecr_cookie_exemptions_and_fines_profile_for(cookie_consent_withheld, Profile) :-
    united_kingdom_cookie_profile([storage_or_access_within_regulation_6, clear_and_comprehensive_information_about_the_purpose_provided], Profile).
uk_pecr_cookie_exemptions_and_fines_profile_for(cookie_transmission_only, Profile) :-
    united_kingdom_cookie_profile([storage_or_access_within_regulation_6, technical_storage_or_access_solely_for_transmission_of_a_communication], Profile).
uk_pecr_cookie_exemptions_and_fines_profile_for(cookie_transmission_absent, Profile) :-
    united_kingdom_cookie_profile([storage_or_access_within_regulation_6], Profile).
uk_pecr_cookie_exemptions_and_fines_profile_for(cookie_strictly_necessary, Profile) :-
    united_kingdom_cookie_profile([storage_or_access_within_regulation_6, information_society_service_requested_by_the_subscriber_or_user, storage_or_access_strictly_necessary_for_the_requested_service], Profile).
uk_pecr_cookie_exemptions_and_fines_profile_for(cookie_not_strictly_necessary, Profile) :-
    united_kingdom_cookie_profile([storage_or_access_within_regulation_6, information_society_service_requested_by_the_subscriber_or_user], Profile).
uk_pecr_cookie_exemptions_and_fines_profile_for(cookie_statistics, Profile) :-
    united_kingdom_cookie_profile([storage_or_access_within_regulation_6, clear_and_comprehensive_information_about_the_purpose_provided, person_provides_an_information_society_service, sole_purpose_is_statistical_information_to_improve_the_service_or_website, collected_information_shared_only_to_assist_with_improvements, access_does_not_collect_or_monitor_automatically_emitted_information, simple_free_means_of_objecting_given, subscriber_or_user_has_not_objected], Profile).
uk_pecr_cookie_exemptions_and_fines_profile_for(cookie_statistics_emitted_signals, Profile) :-
    united_kingdom_cookie_profile([storage_or_access_within_regulation_6, clear_and_comprehensive_information_about_the_purpose_provided, person_provides_an_information_society_service, sole_purpose_is_statistical_information_to_improve_the_service_or_website, collected_information_shared_only_to_assist_with_improvements, simple_free_means_of_objecting_given, subscriber_or_user_has_not_objected], Profile).
uk_pecr_cookie_exemptions_and_fines_profile_for(cookie_website_enhancement, Profile) :-
    united_kingdom_cookie_profile([storage_or_access_within_regulation_6, clear_and_comprehensive_information_about_the_purpose_provided, simple_free_means_of_objecting_given, subscriber_or_user_has_not_objected, person_provides_an_information_society_service_by_means_of_a_website, sole_purpose_is_adapting_or_enhancing_website_appearance_or_functionality], Profile).
uk_pecr_cookie_exemptions_and_fines_profile_for(cookie_website_enhancement_objected, Profile) :-
    united_kingdom_cookie_profile([storage_or_access_within_regulation_6, clear_and_comprehensive_information_about_the_purpose_provided, simple_free_means_of_objecting_given, person_provides_an_information_society_service_by_means_of_a_website, sole_purpose_is_adapting_or_enhancing_website_appearance_or_functionality], Profile).
uk_pecr_cookie_exemptions_and_fines_profile_for(cookie_emergency_location, Profile) :-
    united_kingdom_cookie_profile([storage_or_access_within_regulation_6, communication_received_requests_or_indicates_need_of_emergency_assistance, sole_purpose_is_ascertaining_geographical_position_for_emergency_assistance], Profile).
uk_pecr_cookie_exemptions_and_fines_profile_for(cookie_emergency_without_location_purpose, Profile) :-
    united_kingdom_cookie_profile([storage_or_access_within_regulation_6, communication_received_requests_or_indicates_need_of_emergency_assistance], Profile).
uk_pecr_cookie_exemptions_and_fines_profile_for(cookie_outside_regulation_6, Profile) :-
    united_kingdom_cookie_profile([], Profile).
uk_pecr_cookie_exemptions_and_fines_profile_for(cookie_within_regulation_6_no_way, Profile) :-
    united_kingdom_cookie_profile([storage_or_access_within_regulation_6], Profile).
uk_pecr_cookie_exemptions_and_fines_profile_for(comparison_same, Profile) :-
    comparison_profile([storage_or_access_within_regulation_6, technical_storage_or_access_solely_for_transmission_of_a_communication], [storage_or_access_in_terminal_equipment, storage_or_access_solely_for_transmission], Profile).
uk_pecr_cookie_exemptions_and_fines_profile_for(comparison_differs, Profile) :-
    comparison_profile([storage_or_access_within_regulation_6, technical_storage_or_access_solely_for_transmission_of_a_communication], [], Profile).
uk_pecr_cookie_exemptions_and_fines_profile_for(breach_notified_in_72nd_hour, Profile) :-
    breach_profile(true, true, true, true, 72, true, false, Profile).
uk_pecr_cookie_exemptions_and_fines_profile_for(breach_notified_in_73rd_hour, Profile) :-
    breach_profile(true, true, true, true, 73, true, false, Profile).
uk_pecr_cookie_exemptions_and_fines_profile_for(breach_late_with_reasons, Profile) :-
    breach_profile(true, true, true, true, 73, false, true, Profile).
uk_pecr_cookie_exemptions_and_fines_profile_for(breach_late_without_reasons, Profile) :-
    breach_profile(true, true, true, true, 73, false, false, Profile).
uk_pecr_cookie_exemptions_and_fines_profile_for(breach_undue_delay, Profile) :-
    breach_profile(true, true, true, false, 5, true, false, Profile).
uk_pecr_cookie_exemptions_and_fines_profile_for(breach_awareness_before_amendment, Profile) :-
    Profile = [attribute(provider_of_a_public_electronic_communications_service, true), attribute(personal_data_breach_occurred, true), attribute(became_aware_on_or_after_20_august_2025, false)].
uk_pecr_cookie_exemptions_and_fines_profile_for(breach_not_a_service_provider, Profile) :-
    breach_profile(false, true, true, true, 72, true, false, Profile).
uk_pecr_cookie_exemptions_and_fines_profile_for(penalty_listed_regulation, Profile) :-
    Profile = [attribute(act_or_omission_on_or_after_5_february_2026, true), attribute(provision_infringed, regulation_6)].
uk_pecr_cookie_exemptions_and_fines_profile_for(penalty_other_provision, Profile) :-
    Profile = [attribute(act_or_omission_on_or_after_5_february_2026, true), attribute(provision_infringed, other_provision_of_the_pec_regulations)].
uk_pecr_cookie_exemptions_and_fines_profile_for(penalty_act_before_5_february_2026, Profile) :-
    Profile = [attribute(act_or_omission_on_or_after_5_february_2026, false), attribute(provision_infringed, regulation_6)].
uk_pecr_cookie_exemptions_and_fines_profile_for(amount_higher_tie, Profile) :-
    penalty_profile(true, regulation_6, true, 437500000, Profile).
uk_pecr_cookie_exemptions_and_fines_profile_for(amount_higher_above_tie, Profile) :-
    penalty_profile(true, regulation_6, true, 437500001, Profile).
uk_pecr_cookie_exemptions_and_fines_profile_for(amount_standard_tie, Profile) :-
    penalty_profile(true, other_provision_of_the_pec_regulations, true, 435000000, Profile).
uk_pecr_cookie_exemptions_and_fines_profile_for(amount_standard_above_tie, Profile) :-
    penalty_profile(true, other_provision_of_the_pec_regulations, true, 435000001, Profile).
uk_pecr_cookie_exemptions_and_fines_profile_for(amount_not_an_undertaking, Profile) :-
    penalty_profile(true, regulation_6, false, 437500001, Profile).
uk_pecr_cookie_exemptions_and_fines_profile_for(input_problem_unknown_key, [attribute(colour, true)]).

uk_pecr_cookie_exemptions_and_fines_assess(Subject, Result) :-
    uk_pecr_cookie_exemptions_and_fines_profile_for(Subject, Profile),
    decide_uk_pecr_cookie_exemptions_and_fines(Profile, Result).
