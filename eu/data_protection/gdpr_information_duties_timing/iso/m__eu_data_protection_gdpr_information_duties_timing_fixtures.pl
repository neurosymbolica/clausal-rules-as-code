% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_information_duties_timing_fixtures, [gdpr_information_duties_timing_subject/1, gdpr_information_duties_timing_profile_for/2, gdpr_information_duties_timing_assess/2]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_information_duties_timing_information_timing_verdict, [decide_information_timing_verdict/2]).

gdpr_information_duties_timing_subject(art13_provided_on_obtaining_day).
gdpr_information_duties_timing_subject(art13_provided_day_after_obtaining).
gdpr_information_duties_timing_subject(art14_one_month_last_day).
gdpr_information_duties_timing_subject(art14_one_month_day_after).
gdpr_information_duties_timing_subject(art14_leap_day_last_day).
gdpr_information_duties_timing_subject(art14_leap_day_day_after).
gdpr_information_duties_timing_subject(art14_holiday_shift_last_day).
gdpr_information_duties_timing_subject(art14_holiday_shift_day_after).
gdpr_information_duties_timing_subject(art14_tie_with_communication_last_day).
gdpr_information_duties_timing_subject(art14_first_communication_on_day).
gdpr_information_duties_timing_subject(art14_first_communication_day_after).
gdpr_information_duties_timing_subject(art14_first_disclosure_on_day).
gdpr_information_duties_timing_subject(art14_first_disclosure_day_after).
gdpr_information_duties_timing_subject(art14_reasonable_period_unsure).
gdpr_information_duties_timing_subject(art14_reasonable_period_false).
gdpr_information_duties_timing_subject(art14_reasonable_period_absent).
gdpr_information_duties_timing_subject(route_unknown).
gdpr_information_duties_timing_subject(crisp_flag_given_unsure).

gdpr_information_duties_timing_profile_for(art13_provided_on_obtaining_day, [attribute(personal_data_collected_from_data_subject, true), attribute(obtaining_date, date(2026, 3, 10)), attribute(provision_date, date(2026, 3, 10))]).
gdpr_information_duties_timing_profile_for(art13_provided_day_after_obtaining, [attribute(personal_data_collected_from_data_subject, true), attribute(obtaining_date, date(2026, 3, 10)), attribute(provision_date, date(2026, 3, 11))]).
gdpr_information_duties_timing_profile_for(art14_one_month_last_day, [attribute(personal_data_collected_from_data_subject, false), attribute(obtaining_date, date(2026, 1, 15)), attribute(provision_date, date(2026, 2, 16)), attribute(data_used_for_communication_with_data_subject, false), attribute(disclosure_to_another_recipient_envisaged, false), attribute(provided_within_reasonable_period, true)]).
gdpr_information_duties_timing_profile_for(art14_one_month_day_after, [attribute(personal_data_collected_from_data_subject, false), attribute(obtaining_date, date(2026, 1, 15)), attribute(provision_date, date(2026, 2, 17)), attribute(data_used_for_communication_with_data_subject, false), attribute(disclosure_to_another_recipient_envisaged, false), attribute(provided_within_reasonable_period, true)]).
gdpr_information_duties_timing_profile_for(art14_leap_day_last_day, [attribute(personal_data_collected_from_data_subject, false), attribute(obtaining_date, date(2028, 1, 31)), attribute(provision_date, date(2028, 2, 29)), attribute(data_used_for_communication_with_data_subject, false), attribute(disclosure_to_another_recipient_envisaged, false), attribute(provided_within_reasonable_period, true)]).
gdpr_information_duties_timing_profile_for(art14_leap_day_day_after, [attribute(personal_data_collected_from_data_subject, false), attribute(obtaining_date, date(2028, 1, 31)), attribute(provision_date, date(2028, 3, 1)), attribute(data_used_for_communication_with_data_subject, false), attribute(disclosure_to_another_recipient_envisaged, false), attribute(provided_within_reasonable_period, true)]).
gdpr_information_duties_timing_profile_for(art14_holiday_shift_last_day, [attribute(personal_data_collected_from_data_subject, false), attribute(obtaining_date, date(2026, 12, 31)), attribute(provision_date, date(2027, 2, 2)), attribute(data_used_for_communication_with_data_subject, false), attribute(disclosure_to_another_recipient_envisaged, false), attribute(provided_within_reasonable_period, true), attribute(public_holidays, attested([date(2027, 2, 1)], attestation(host, moment, reason, none)))]).
gdpr_information_duties_timing_profile_for(art14_holiday_shift_day_after, [attribute(personal_data_collected_from_data_subject, false), attribute(obtaining_date, date(2026, 12, 31)), attribute(provision_date, date(2027, 2, 3)), attribute(data_used_for_communication_with_data_subject, false), attribute(disclosure_to_another_recipient_envisaged, false), attribute(provided_within_reasonable_period, true), attribute(public_holidays, attested([date(2027, 2, 1)], attestation(host, moment, reason, none)))]).
gdpr_information_duties_timing_profile_for(art14_tie_with_communication_last_day, [attribute(personal_data_collected_from_data_subject, false), attribute(obtaining_date, date(2026, 1, 15)), attribute(provision_date, date(2026, 2, 16)), attribute(data_used_for_communication_with_data_subject, true), attribute(first_communication_date, date(2026, 2, 16)), attribute(disclosure_to_another_recipient_envisaged, false), attribute(provided_within_reasonable_period, true)]).
gdpr_information_duties_timing_profile_for(art14_first_communication_on_day, [attribute(personal_data_collected_from_data_subject, false), attribute(obtaining_date, date(2026, 1, 15)), attribute(provision_date, date(2026, 1, 20)), attribute(data_used_for_communication_with_data_subject, true), attribute(first_communication_date, date(2026, 1, 20)), attribute(disclosure_to_another_recipient_envisaged, false), attribute(provided_within_reasonable_period, true)]).
gdpr_information_duties_timing_profile_for(art14_first_communication_day_after, [attribute(personal_data_collected_from_data_subject, false), attribute(obtaining_date, date(2026, 1, 15)), attribute(provision_date, date(2026, 1, 21)), attribute(data_used_for_communication_with_data_subject, true), attribute(first_communication_date, date(2026, 1, 20)), attribute(disclosure_to_another_recipient_envisaged, false), attribute(provided_within_reasonable_period, true)]).
gdpr_information_duties_timing_profile_for(art14_first_disclosure_on_day, [attribute(personal_data_collected_from_data_subject, false), attribute(obtaining_date, date(2026, 1, 15)), attribute(provision_date, date(2026, 1, 30)), attribute(data_used_for_communication_with_data_subject, false), attribute(disclosure_to_another_recipient_envisaged, true), attribute(first_disclosure_date, date(2026, 1, 30)), attribute(provided_within_reasonable_period, true)]).
gdpr_information_duties_timing_profile_for(art14_first_disclosure_day_after, [attribute(personal_data_collected_from_data_subject, false), attribute(obtaining_date, date(2026, 1, 15)), attribute(provision_date, date(2026, 1, 31)), attribute(data_used_for_communication_with_data_subject, false), attribute(disclosure_to_another_recipient_envisaged, true), attribute(first_disclosure_date, date(2026, 1, 30)), attribute(provided_within_reasonable_period, true)]).
gdpr_information_duties_timing_profile_for(art14_reasonable_period_unsure, [attribute(personal_data_collected_from_data_subject, false), attribute(obtaining_date, date(2026, 1, 15)), attribute(provision_date, date(2026, 2, 10)), attribute(data_used_for_communication_with_data_subject, false), attribute(disclosure_to_another_recipient_envisaged, false), attribute(provided_within_reasonable_period, unsure)]).
gdpr_information_duties_timing_profile_for(art14_reasonable_period_false, [attribute(personal_data_collected_from_data_subject, false), attribute(obtaining_date, date(2026, 1, 15)), attribute(provision_date, date(2026, 2, 10)), attribute(data_used_for_communication_with_data_subject, false), attribute(disclosure_to_another_recipient_envisaged, false), attribute(provided_within_reasonable_period, false)]).
gdpr_information_duties_timing_profile_for(art14_reasonable_period_absent, [attribute(personal_data_collected_from_data_subject, false), attribute(obtaining_date, date(2026, 1, 15)), attribute(provision_date, date(2026, 2, 10)), attribute(data_used_for_communication_with_data_subject, false), attribute(disclosure_to_another_recipient_envisaged, false)]).
gdpr_information_duties_timing_profile_for(route_unknown, []).
gdpr_information_duties_timing_profile_for(crisp_flag_given_unsure, [attribute(personal_data_collected_from_data_subject, unsure), attribute(obtaining_date, date(2026, 3, 10)), attribute(provision_date, date(2026, 3, 10))]).

gdpr_information_duties_timing_assess(Subject, Result) :-
    gdpr_information_duties_timing_profile_for(Subject, Profile),
    decide_information_timing_verdict(Profile, Result).
