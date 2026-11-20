% SPDX-License-Identifier: EUPL-1.2
:- module(m__sg_data_protection_pdpa_data_breach_notification_fixtures, [pdpa_data_breach_notification_subject/1, pdpa_data_breach_notification_profile_for/2, pdpa_data_breach_notification_assess/2]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__sg_data_protection_pdpa_data_breach_notification_pdpa_data_breach_notification, [decide_pdpa_data_breach_notification/2]).

pdpa_data_breach_notification_subject(pre_commencement_breach).
pdpa_data_breach_notification_subject(commencement_day_breach).
pdpa_data_breach_notification_subject(account_pair_breach).
pdpa_data_breach_notification_subject(credential_only_breach).
pdpa_data_breach_notification_subject(bank_account_number_breach).
pdpa_data_breach_notification_subject(identity_with_schedule_data).
pdpa_data_breach_notification_subject(schedule_data_publicly_available).
pdpa_data_breach_notification_subject(affected_count_at_prescribed_number).
pdpa_data_breach_notification_subject(affected_count_below_prescribed_number).
pdpa_data_breach_notification_subject(within_organisation_access_excluded).
pdpa_data_breach_notification_subject(within_organisation_with_disposal).
pdpa_data_breach_notification_subject(law_enforcement_and_waiver).
pdpa_data_breach_notification_subject(waiver_only).
pdpa_data_breach_notification_subject(remedial_action_taken).
pdpa_data_breach_notification_subject(no_exception_applies).
pdpa_data_breach_notification_subject(exception_settles_with_harm_unsure).
pdpa_data_breach_notification_subject(unsure_data_breach_judgement).
pdpa_data_breach_notification_subject(missing_breach_date).
pdpa_data_breach_notification_subject(not_a_data_breach).
pdpa_data_breach_notification_subject(public_agency_intermediary_without_date).
pdpa_data_breach_notification_subject(intermediary_for_organisation).
pdpa_data_breach_notification_subject(intermediary_before_commencement).
pdpa_data_breach_notification_subject(organisation_notified_by_intermediary).
pdpa_data_breach_notification_subject(organisation_without_possession).
pdpa_data_breach_notification_subject(duplicate_key_profile).
pdpa_data_breach_notification_subject(numeric_key_profile).
pdpa_data_breach_notification_subject(impossible_date_profile).
pdpa_data_breach_notification_subject(malformed_element_profile).
pdpa_data_breach_notification_subject(full_notifiable_with_deadline).

incident_attributes([attribute(breach_occurred_date, date(2025, 3, 10)), attribute(within_organisation_only, false), attribute(breach_kinds, [unauthorised_disclosure]), attribute(is_data_breach, true)]).

schedule_harm_attributes([attribute(breached_data, [full_name_or_alias, payment_card_number]), attribute(publicly_available_or_lawfully_disclosed, [])]).

small_scale_attributes([attribute(affected_individuals_count, 10), attribute(assessed_likely_significant_scale, false)]).

no_exception_attributes([attribute(prohibited_by_law_enforcement_agency, false), attribute(prohibited_by_commission_direction, false), attribute(commission_waiver_granted, false), attribute(remedial_action_renders_harm_unlikely, false), attribute(prior_technological_measure_renders_harm_unlikely, false)]).

pdpa_data_breach_notification_profile_for(pre_commencement_breach, [attribute(breach_occurred_date, date(2021, 1, 31)), attribute(within_organisation_only, false), attribute(breach_kinds, [unauthorised_access]), attribute(is_data_breach, true), attribute(breached_data, [account_identifier, account_access_credential])]).
pdpa_data_breach_notification_profile_for(commencement_day_breach, [attribute(breach_occurred_date, date(2021, 2, 1)), attribute(within_organisation_only, false), attribute(breach_kinds, [unauthorised_access]), attribute(is_data_breach, true), attribute(breached_data, [account_identifier, account_access_credential])]).
pdpa_data_breach_notification_profile_for(account_pair_breach, Profile) :-
    incident_attributes(Incident),
    append(Incident, [attribute(breached_data, [account_identifier, account_access_credential])], Profile).
pdpa_data_breach_notification_profile_for(credential_only_breach, Profile) :-
    incident_attributes(Incident),
    small_scale_attributes(Scale),
    append([Incident, [attribute(breached_data, [account_access_credential]), attribute(assessed_likely_significant_harm, false)], Scale], Profile).
pdpa_data_breach_notification_profile_for(bank_account_number_breach, Profile) :-
    incident_attributes(Incident),
    append(Incident, [attribute(breached_data, [bank_or_finance_company_account_number, account_access_credential])], Profile).
pdpa_data_breach_notification_profile_for(identity_with_schedule_data, Profile) :-
    incident_attributes(Incident),
    schedule_harm_attributes(Harm),
    small_scale_attributes(Scale),
    append([Incident, Harm, Scale], Profile).
pdpa_data_breach_notification_profile_for(schedule_data_publicly_available, Profile) :-
    incident_attributes(Incident),
    small_scale_attributes(Scale),
    append([Incident, [attribute(breached_data, [full_name_or_alias, payment_card_number]), attribute(publicly_available_or_lawfully_disclosed, [payment_card_number]), attribute(assessed_likely_significant_harm, false)], Scale], Profile).
pdpa_data_breach_notification_profile_for(affected_count_at_prescribed_number, Profile) :-
    incident_attributes(Incident),
    append(Incident, [attribute(breached_data, [other_personal_data]), attribute(assessed_likely_significant_harm, false), attribute(affected_individuals_count, 500)], Profile).
pdpa_data_breach_notification_profile_for(affected_count_below_prescribed_number, Profile) :-
    incident_attributes(Incident),
    append(Incident, [attribute(breached_data, [other_personal_data]), attribute(assessed_likely_significant_harm, false), attribute(affected_individuals_count, 499), attribute(assessed_likely_significant_scale, false)], Profile).
pdpa_data_breach_notification_profile_for(within_organisation_access_excluded, [attribute(breach_occurred_date, date(2025, 3, 10)), attribute(within_organisation_only, true), attribute(breach_kinds, [unauthorised_access, unauthorised_use]), attribute(is_data_breach, true), attribute(breached_data, [account_identifier, account_access_credential])]).
pdpa_data_breach_notification_profile_for(within_organisation_with_disposal, [attribute(breach_occurred_date, date(2025, 3, 10)), attribute(within_organisation_only, true), attribute(breach_kinds, [unauthorised_access, unauthorised_disposal]), attribute(is_data_breach, true), attribute(breached_data, [account_identifier, account_access_credential])]).
pdpa_data_breach_notification_profile_for(law_enforcement_and_waiver, Profile) :-
    incident_attributes(Incident),
    schedule_harm_attributes(Harm),
    small_scale_attributes(Scale),
    append([Incident, Harm, Scale, [attribute(prohibited_by_law_enforcement_agency, true), attribute(commission_waiver_granted, true)]], Profile).
pdpa_data_breach_notification_profile_for(waiver_only, Profile) :-
    incident_attributes(Incident),
    schedule_harm_attributes(Harm),
    small_scale_attributes(Scale),
    append([Incident, Harm, Scale, [attribute(prohibited_by_law_enforcement_agency, false), attribute(prohibited_by_commission_direction, false), attribute(commission_waiver_granted, true)]], Profile).
pdpa_data_breach_notification_profile_for(remedial_action_taken, Profile) :-
    incident_attributes(Incident),
    schedule_harm_attributes(Harm),
    small_scale_attributes(Scale),
    append([Incident, Harm, Scale, [attribute(prohibited_by_law_enforcement_agency, false), attribute(prohibited_by_commission_direction, false), attribute(commission_waiver_granted, false), attribute(remedial_action_renders_harm_unlikely, true)]], Profile).
pdpa_data_breach_notification_profile_for(no_exception_applies, Profile) :-
    incident_attributes(Incident),
    schedule_harm_attributes(Harm),
    small_scale_attributes(Scale),
    no_exception_attributes(Exceptions),
    append([Incident, Harm, Scale, Exceptions], Profile).
pdpa_data_breach_notification_profile_for(exception_settles_with_harm_unsure, [attribute(breach_occurred_date, date(2025, 6, 1)), attribute(is_data_breach, unsure), attribute(assessed_likely_significant_harm, unsure), attribute(prohibited_by_law_enforcement_agency, false), attribute(prohibited_by_commission_direction, false), attribute(commission_waiver_granted, false), attribute(remedial_action_renders_harm_unlikely, true)]).
pdpa_data_breach_notification_profile_for(unsure_data_breach_judgement, [attribute(breach_occurred_date, date(2025, 3, 10)), attribute(within_organisation_only, false), attribute(breach_kinds, [unauthorised_disclosure]), attribute(is_data_breach, unsure), attribute(breached_data, [account_identifier, account_access_credential])]).
pdpa_data_breach_notification_profile_for(missing_breach_date, [attribute(is_data_breach, false)]).
pdpa_data_breach_notification_profile_for(not_a_data_breach, [attribute(breach_occurred_date, date(2025, 3, 10)), attribute(is_data_breach, false)]).
pdpa_data_breach_notification_profile_for(public_agency_intermediary_without_date, [attribute(caller_role, data_intermediary_for_public_agency), attribute(reason_to_believe_breach_occurred, true)]).
pdpa_data_breach_notification_profile_for(intermediary_for_organisation, [attribute(breach_occurred_date, date(2025, 3, 10)), attribute(caller_role, data_intermediary_for_organisation), attribute(reason_to_believe_breach_occurred, true)]).
pdpa_data_breach_notification_profile_for(intermediary_before_commencement, [attribute(breach_occurred_date, date(2021, 1, 31)), attribute(caller_role, data_intermediary_for_organisation), attribute(reason_to_believe_breach_occurred, true)]).
pdpa_data_breach_notification_profile_for(organisation_notified_by_intermediary, [attribute(breach_occurred_date, date(2024, 4, 4)), attribute(caller_role, organisation), attribute(notified_by_data_intermediary, true)]).
pdpa_data_breach_notification_profile_for(organisation_without_possession, [attribute(breach_occurred_date, date(2024, 4, 4)), attribute(caller_role, organisation), attribute(notified_by_data_intermediary, false), attribute(personal_data_in_possession_or_control, false), attribute(reason_to_believe_breach_occurred, true)]).
pdpa_data_breach_notification_profile_for(duplicate_key_profile, [attribute(is_data_breach, true), attribute(is_data_breach, false)]).
pdpa_data_breach_notification_profile_for(numeric_key_profile, [attribute(42, true)]).
pdpa_data_breach_notification_profile_for(impossible_date_profile, [attribute(breach_occurred_date, date(2026, 2, 30))]).
pdpa_data_breach_notification_profile_for(malformed_element_profile, [attribute(is_data_breach, true), not_an_attribute]).
pdpa_data_breach_notification_profile_for(full_notifiable_with_deadline, Profile) :-
    incident_attributes(Incident),
    schedule_harm_attributes(Harm),
    no_exception_attributes(Exceptions),
    append([Incident, Harm, [attribute(affected_individuals_count, 1200)], Exceptions, [attribute(assessment_date, date(2026, 1, 2))]], Profile).

pdpa_data_breach_notification_assess(Subject, Result) :-
    pdpa_data_breach_notification_profile_for(Subject, Profile),
    decide_pdpa_data_breach_notification(Profile, Result).
