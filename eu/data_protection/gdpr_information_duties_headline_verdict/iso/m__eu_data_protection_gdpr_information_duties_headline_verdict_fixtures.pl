% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_information_duties_headline_verdict_fixtures, [gdpr_information_duties_headline_verdict_subject/1, gdpr_information_duties_headline_verdict_profile_for/2, gdpr_information_duties_headline_verdict_assess/2]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_information_duties_headline_verdict_information_duty_verdict, [decide_information_duty_verdict/2]).

gdpr_information_duties_headline_verdict_subject(article_13_complete_on_obtaining_day).
gdpr_information_duties_headline_verdict_subject(article_13_complete_one_day_after_obtaining).
gdpr_information_duties_headline_verdict_subject(article_13_requirement_item_missing).
gdpr_information_duties_headline_verdict_subject(article_13_automated_decision_unsure).
gdpr_information_duties_headline_verdict_subject(article_13_automated_decision_item_missing).
gdpr_information_duties_headline_verdict_subject(article_13_further_processing_informed_day_before).
gdpr_information_duties_headline_verdict_subject(article_13_further_processing_informed_same_day).
gdpr_information_duties_headline_verdict_subject(article_14_on_last_day_of_month).
gdpr_information_duties_headline_verdict_subject(article_14_day_after_last_day_of_month).
gdpr_information_duties_headline_verdict_subject(article_14_month_end_shifted_past_weekend).
gdpr_information_duties_headline_verdict_subject(article_14_day_after_shifted_month_end).
gdpr_information_duties_headline_verdict_subject(article_14_holiday_shifted_last_day).
gdpr_information_duties_headline_verdict_subject(article_14_day_after_holiday_shifted_last_day).
gdpr_information_duties_headline_verdict_subject(article_14_first_communication_on_the_day).
gdpr_information_duties_headline_verdict_subject(article_14_first_communication_day_after).
gdpr_information_duties_headline_verdict_subject(article_14_source_missing_law_attested_false).
gdpr_information_duties_headline_verdict_subject(article_14_source_missing_law_attested_true).
gdpr_information_duties_headline_verdict_subject(article_14_effort_unsure_with_measures).
gdpr_information_duties_headline_verdict_subject(article_14_effort_with_measures).
gdpr_information_duties_headline_verdict_subject(article_14_only_the_route).
gdpr_information_duties_headline_verdict_subject(route_not_supplied).
gdpr_information_duties_headline_verdict_subject(input_problems_mix).
gdpr_information_duties_headline_verdict_subject(not_a_profile).

article_13_items_complete([controller_identity_and_contact_details, purposes_and_legal_basis, storage_period_or_criteria, data_subject_rights, right_to_lodge_complaint, statutory_or_contractual_requirement]).

article_13_profile(ItemsProvided, Decision, ProvisionDate, FurtherAttributes, Profile) :-
    append([attribute(personal_data_collected_from_data_subject, true), attribute(items_provided, ItemsProvided), attribute(items_data_subject_already_has, []), attribute(data_protection_officer_designated, false), attribute(processing_based_on_legitimate_interests, false), attribute(recipients_exist, false), attribute(transfer_intended, false), attribute(processing_based_on_consent, false), attribute(automated_decision_making_under_article_22, Decision), attribute(obtaining_date, date(2026, 3, 2)), attribute(provision_date, ProvisionDate)], FurtherAttributes, Profile).

no_further_processing([attribute(further_processing_for_another_purpose_intended, false)]).

further_processing_informed_on(InformationDate, [attribute(further_processing_for_another_purpose_intended, true), attribute(further_processing_start_date, date(2026, 4, 10)), attribute(further_processing_information_date, InformationDate), attribute(further_processing_items_provided, [other_purpose_information]), attribute(paragraph_2_information_relevant_to_further_processing, false)]).

article_14_items_complete([controller_identity_and_contact_details, purposes_and_legal_basis, categories_of_personal_data, storage_period_or_criteria, data_subject_rights, right_to_lodge_complaint, source_of_personal_data]).

article_14_items_without_source([controller_identity_and_contact_details, purposes_and_legal_basis, categories_of_personal_data, storage_period_or_criteria, data_subject_rights, right_to_lodge_complaint]).

article_14_profile(ItemsProvided, ObtainingDate, ProvisionDate, ExtraAttributes, Profile) :-
    append([attribute(personal_data_collected_from_data_subject, false), attribute(items_provided, ItemsProvided), attribute(items_data_subject_already_has, []), attribute(data_protection_officer_designated, false), attribute(processing_based_on_legitimate_interests, false), attribute(recipients_exist, false), attribute(transfer_intended, false), attribute(processing_based_on_consent, false), attribute(automated_decision_making_under_article_22, false), attribute(obtaining_date, ObtainingDate), attribute(provision_date, ProvisionDate), attribute(provided_within_reasonable_period, true), attribute(provision_impossible_or_disproportionate_effort, false), attribute(further_processing_for_another_purpose_intended, false)], ExtraAttributes, Profile).

no_later_limbs([attribute(data_used_for_communication_with_data_subject, false), attribute(disclosure_to_another_recipient_envisaged, false)]).

holiday_attestation(attested([date(2027, 2, 1)], attestation(by, at, reason, none))).

gdpr_information_duties_headline_verdict_profile_for(article_13_complete_on_obtaining_day, Profile) :-
    article_13_items_complete(Items),
    no_further_processing(Further),
    article_13_profile(Items, false, date(2026, 3, 2), Further, Profile).
gdpr_information_duties_headline_verdict_profile_for(article_13_complete_one_day_after_obtaining, Profile) :-
    article_13_items_complete(Items),
    no_further_processing(Further),
    article_13_profile(Items, false, date(2026, 3, 3), Further, Profile).
gdpr_information_duties_headline_verdict_profile_for(article_13_requirement_item_missing, Profile) :-
    no_further_processing(Further),
    article_13_profile([controller_identity_and_contact_details, purposes_and_legal_basis, storage_period_or_criteria, data_subject_rights, right_to_lodge_complaint], false, date(2026, 3, 2), Further, Profile).
gdpr_information_duties_headline_verdict_profile_for(article_13_automated_decision_unsure, Profile) :-
    article_13_items_complete(Items),
    no_further_processing(Further),
    article_13_profile(Items, unsure, date(2026, 3, 2), Further, Profile).
gdpr_information_duties_headline_verdict_profile_for(article_13_automated_decision_item_missing, Profile) :-
    article_13_items_complete(Items),
    no_further_processing(Further),
    article_13_profile(Items, true, date(2026, 3, 2), Further, Profile).
gdpr_information_duties_headline_verdict_profile_for(article_13_further_processing_informed_day_before, Profile) :-
    article_13_items_complete(Items),
    further_processing_informed_on(date(2026, 4, 9), Further),
    article_13_profile(Items, false, date(2026, 3, 2), Further, Profile).
gdpr_information_duties_headline_verdict_profile_for(article_13_further_processing_informed_same_day, Profile) :-
    article_13_items_complete(Items),
    further_processing_informed_on(date(2026, 4, 10), Further),
    article_13_profile(Items, false, date(2026, 3, 2), Further, Profile).
gdpr_information_duties_headline_verdict_profile_for(article_14_on_last_day_of_month, Profile) :-
    article_14_items_complete(Items),
    no_later_limbs(Limbs),
    article_14_profile(Items, date(2026, 1, 15), date(2026, 2, 16), Limbs, Profile).
gdpr_information_duties_headline_verdict_profile_for(article_14_day_after_last_day_of_month, Profile) :-
    article_14_items_complete(Items),
    no_later_limbs(Limbs),
    article_14_profile(Items, date(2026, 1, 15), date(2026, 2, 17), Limbs, Profile).
gdpr_information_duties_headline_verdict_profile_for(article_14_month_end_shifted_past_weekend, Profile) :-
    article_14_items_complete(Items),
    no_later_limbs(Limbs),
    article_14_profile(Items, date(2026, 1, 31), date(2026, 3, 2), Limbs, Profile).
gdpr_information_duties_headline_verdict_profile_for(article_14_day_after_shifted_month_end, Profile) :-
    article_14_items_complete(Items),
    no_later_limbs(Limbs),
    article_14_profile(Items, date(2026, 1, 31), date(2026, 3, 3), Limbs, Profile).
gdpr_information_duties_headline_verdict_profile_for(article_14_holiday_shifted_last_day, Profile) :-
    article_14_items_complete(Items),
    no_later_limbs(Limbs),
    holiday_attestation(Holidays),
    append(Limbs, [attribute(public_holidays, Holidays)], Extra),
    article_14_profile(Items, date(2026, 12, 31), date(2027, 2, 2), Extra, Profile).
gdpr_information_duties_headline_verdict_profile_for(article_14_day_after_holiday_shifted_last_day, Profile) :-
    article_14_items_complete(Items),
    no_later_limbs(Limbs),
    holiday_attestation(Holidays),
    append(Limbs, [attribute(public_holidays, Holidays)], Extra),
    article_14_profile(Items, date(2026, 12, 31), date(2027, 2, 3), Extra, Profile).
gdpr_information_duties_headline_verdict_profile_for(article_14_first_communication_on_the_day, Profile) :-
    article_14_items_complete(Items),
    article_14_profile(Items, date(2026, 1, 15), date(2026, 1, 20), [attribute(data_used_for_communication_with_data_subject, true), attribute(first_communication_date, date(2026, 1, 20)), attribute(disclosure_to_another_recipient_envisaged, false)], Profile).
gdpr_information_duties_headline_verdict_profile_for(article_14_first_communication_day_after, Profile) :-
    article_14_items_complete(Items),
    article_14_profile(Items, date(2026, 1, 15), date(2026, 1, 21), [attribute(data_used_for_communication_with_data_subject, true), attribute(first_communication_date, date(2026, 1, 20)), attribute(disclosure_to_another_recipient_envisaged, false)], Profile).
gdpr_information_duties_headline_verdict_profile_for(article_14_source_missing_law_attested_false, Profile) :-
    article_14_items_without_source(Items),
    no_later_limbs(Limbs),
    append(Limbs, [attribute(obtaining_or_disclosure_laid_down_by_law, attested(false, attestation(by, at, reason, none)))], Extra),
    article_14_profile(Items, date(2026, 1, 15), date(2026, 1, 20), Extra, Profile).
gdpr_information_duties_headline_verdict_profile_for(article_14_source_missing_law_attested_true, Profile) :-
    article_14_items_without_source(Items),
    no_later_limbs(Limbs),
    append(Limbs, [attribute(obtaining_or_disclosure_laid_down_by_law, attested(true, attestation(by, at, reason, none)))], Extra),
    article_14_profile(Items, date(2026, 1, 15), date(2026, 1, 20), Extra, Profile).
gdpr_information_duties_headline_verdict_profile_for(article_14_effort_unsure_with_measures, [attribute(personal_data_collected_from_data_subject, false), attribute(items_provided, []), attribute(items_data_subject_already_has, []), attribute(provision_impossible_or_disproportionate_effort, unsure), attribute(protective_measures_taken, true)]).
gdpr_information_duties_headline_verdict_profile_for(article_14_effort_with_measures, [attribute(personal_data_collected_from_data_subject, false), attribute(items_provided, []), attribute(items_data_subject_already_has, []), attribute(provision_impossible_or_disproportionate_effort, true), attribute(protective_measures_taken, true)]).
gdpr_information_duties_headline_verdict_profile_for(article_14_only_the_route, [attribute(personal_data_collected_from_data_subject, false)]).
gdpr_information_duties_headline_verdict_profile_for(route_not_supplied, []).
gdpr_information_duties_headline_verdict_profile_for(input_problems_mix, [attribute(personal_data_collected_from_data_subject, false), attribute(items_provided, []), attribute(obtaining_date, date(2026, 2, 30)), attribute(items_provided, [not_an_item]), attribute(colour, red)]).
gdpr_information_duties_headline_verdict_profile_for(not_a_profile, foo).

gdpr_information_duties_headline_verdict_assess(Subject, Result) :-
    gdpr_information_duties_headline_verdict_profile_for(Subject, Profile),
    decide_information_duty_verdict(Profile, Result).
