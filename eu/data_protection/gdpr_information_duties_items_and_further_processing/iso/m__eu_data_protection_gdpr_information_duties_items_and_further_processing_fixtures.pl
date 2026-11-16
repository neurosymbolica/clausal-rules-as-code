% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_information_duties_items_and_further_processing_fixtures, [gdpr_information_duties_items_and_further_processing_subject/1, gdpr_information_duties_items_and_further_processing_profile_for/2, gdpr_information_duties_items_and_further_processing_assess/2]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_information_duties_items_and_further_processing_information_route, [decide_information_route/2]).

gdpr_information_duties_items_and_further_processing_subject(art13_complete).
gdpr_information_duties_items_and_further_processing_subject(art13_missing_requirement).
gdpr_information_duties_items_and_further_processing_subject(art14_complete).
gdpr_information_duties_items_and_further_processing_subject(art14_categories_missing).
gdpr_information_duties_items_and_further_processing_subject(art14_categories_already_known).
gdpr_information_duties_items_and_further_processing_subject(art13_automated_unsure).
gdpr_information_duties_items_and_further_processing_subject(art13_automated_unsure_covered).
gdpr_information_duties_items_and_further_processing_subject(art13_further_in_time).
gdpr_information_duties_items_and_further_processing_subject(art13_further_same_day).
gdpr_information_duties_items_and_further_processing_subject(art13_further_item_missing).
gdpr_information_duties_items_and_further_processing_subject(art13_further_not_intended).
gdpr_information_duties_items_and_further_processing_subject(art13_further_relevance_unsure).
gdpr_information_duties_items_and_further_processing_subject(art14_further_in_time).
gdpr_information_duties_items_and_further_processing_subject(art13_further_without_start_date).

art13_items([controller_identity_and_contact_details, data_protection_officer_contact_details, purposes_and_legal_basis, recipients_or_categories_of_recipients, storage_period_or_criteria, data_subject_rights, right_to_lodge_complaint, statutory_or_contractual_requirement]).

art13_items_without_requirement([controller_identity_and_contact_details, data_protection_officer_contact_details, purposes_and_legal_basis, recipients_or_categories_of_recipients, storage_period_or_criteria, data_subject_rights, right_to_lodge_complaint]).

art14_items([controller_identity_and_contact_details, data_protection_officer_contact_details, purposes_and_legal_basis, recipients_or_categories_of_recipients, categories_of_personal_data, storage_period_or_criteria, data_subject_rights, right_to_lodge_complaint, source_of_personal_data]).

art14_items_without_categories([controller_identity_and_contact_details, data_protection_officer_contact_details, purposes_and_legal_basis, recipients_or_categories_of_recipients, storage_period_or_criteria, data_subject_rights, right_to_lodge_complaint, source_of_personal_data]).

art13_further_items([other_purpose_information, storage_period_or_criteria, data_subject_rights, right_to_lodge_complaint, statutory_or_contractual_requirement]).

art13_further_items_without_complaint([other_purpose_information, storage_period_or_criteria, data_subject_rights, statutory_or_contractual_requirement]).

art14_further_items([other_purpose_information, storage_period_or_criteria, data_subject_rights, right_to_lodge_complaint, source_of_personal_data]).

base_attributes(Collected, Provided, AlreadyHas, Decision, [attribute(personal_data_collected_from_data_subject, Collected), attribute(items_provided, Provided), attribute(items_data_subject_already_has, AlreadyHas), attribute(data_protection_officer_designated, true), attribute(processing_based_on_legitimate_interests, false), attribute(recipients_exist, true), attribute(transfer_intended, false), attribute(processing_based_on_consent, false), attribute(automated_decision_making_under_article_22, Decision)]).

not_intended([attribute(further_processing_for_another_purpose_intended, false)]).

intended(Start, Information, Items, Relevance, [attribute(further_processing_for_another_purpose_intended, true), attribute(further_processing_start_date, Start), attribute(further_processing_information_date, Information), attribute(further_processing_items_provided, Items), attribute(paragraph_2_information_relevant_to_further_processing, Relevance)]).

profile_of(Collected, Provided, AlreadyHas, Decision, FurtherAttributes, Profile) :-
    base_attributes(Collected, Provided, AlreadyHas, Decision, Base),
    append(Base, FurtherAttributes, Profile).

gdpr_information_duties_items_and_further_processing_profile_for(art13_complete, Profile) :-
    art13_items(Provided),
    not_intended(Further),
    profile_of(true, Provided, [], false, Further, Profile).
gdpr_information_duties_items_and_further_processing_profile_for(art13_missing_requirement, Profile) :-
    art13_items_without_requirement(Provided),
    not_intended(Further),
    profile_of(true, Provided, [], false, Further, Profile).
gdpr_information_duties_items_and_further_processing_profile_for(art14_complete, Profile) :-
    art14_items(Provided),
    not_intended(Further),
    profile_of(false, Provided, [], false, Further, Profile).
gdpr_information_duties_items_and_further_processing_profile_for(art14_categories_missing, Profile) :-
    art14_items_without_categories(Provided),
    not_intended(Further),
    profile_of(false, Provided, [], false, Further, Profile).
gdpr_information_duties_items_and_further_processing_profile_for(art14_categories_already_known, Profile) :-
    art14_items_without_categories(Provided),
    not_intended(Further),
    profile_of(false, Provided, [categories_of_personal_data], false, Further, Profile).
gdpr_information_duties_items_and_further_processing_profile_for(art13_automated_unsure, Profile) :-
    art13_items(Provided),
    not_intended(Further),
    profile_of(true, Provided, [], unsure, Further, Profile).
gdpr_information_duties_items_and_further_processing_profile_for(art13_automated_unsure_covered, Profile) :-
    art13_items(Items),
    append(Items, [automated_decision_making_information], Provided),
    not_intended(Further),
    profile_of(true, Provided, [], unsure, Further, Profile).
gdpr_information_duties_items_and_further_processing_profile_for(art13_further_in_time, Profile) :-
    art13_items(Provided),
    art13_further_items(FurtherItems),
    intended(date(2026, 6, 1), date(2026, 5, 31), FurtherItems, true, Further),
    profile_of(true, Provided, [], false, Further, Profile).
gdpr_information_duties_items_and_further_processing_profile_for(art13_further_same_day, Profile) :-
    art13_items(Provided),
    art13_further_items(FurtherItems),
    intended(date(2026, 6, 1), date(2026, 6, 1), FurtherItems, true, Further),
    profile_of(true, Provided, [], false, Further, Profile).
gdpr_information_duties_items_and_further_processing_profile_for(art13_further_item_missing, Profile) :-
    art13_items(Provided),
    art13_further_items_without_complaint(FurtherItems),
    intended(date(2026, 6, 1), date(2026, 5, 31), FurtherItems, true, Further),
    profile_of(true, Provided, [], false, Further, Profile).
gdpr_information_duties_items_and_further_processing_profile_for(art13_further_not_intended, Profile) :-
    art13_items(Provided),
    not_intended(Further),
    profile_of(true, Provided, [], false, Further, Profile).
gdpr_information_duties_items_and_further_processing_profile_for(art13_further_relevance_unsure, Profile) :-
    art13_items(Provided),
    intended(date(2026, 6, 1), date(2026, 5, 31), [other_purpose_information], unsure, Further),
    profile_of(true, Provided, [], false, Further, Profile).
gdpr_information_duties_items_and_further_processing_profile_for(art14_further_in_time, Profile) :-
    art14_items(Provided),
    art14_further_items(FurtherItems),
    intended(date(2026, 6, 1), date(2026, 5, 31), FurtherItems, true, Further),
    profile_of(false, Provided, [], false, Further, Profile).
gdpr_information_duties_items_and_further_processing_profile_for(art13_further_without_start_date, Profile) :-
    art13_items(Provided),
    art13_further_items(FurtherItems),
    profile_of(true, Provided, [], false, [attribute(further_processing_for_another_purpose_intended, true), attribute(further_processing_information_date, date(2026, 5, 31)), attribute(further_processing_items_provided, FurtherItems), attribute(paragraph_2_information_relevant_to_further_processing, true)], Profile).

gdpr_information_duties_items_and_further_processing_assess(Subject, Result) :-
    gdpr_information_duties_items_and_further_processing_profile_for(Subject, Profile),
    decide_information_route(Profile, Result).
