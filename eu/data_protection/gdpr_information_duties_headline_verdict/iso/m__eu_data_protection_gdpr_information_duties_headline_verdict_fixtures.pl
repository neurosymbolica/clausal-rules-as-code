% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_information_duties_headline_verdict_fixtures, [gdpr_information_duties_headline_verdict_subject/1, gdpr_information_duties_headline_verdict_profile_for/2, gdpr_information_duties_headline_verdict_assess/2]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_information_duties_headline_verdict_information_duty_verdict, [information_duty_verdict/3]).

gdpr_information_duties_headline_verdict_subject(art13_on_time).
gdpr_information_duties_headline_verdict_subject(art13_one_day_late).
gdpr_information_duties_headline_verdict_subject(art13_missing_statutory_item).
gdpr_information_duties_headline_verdict_subject(art13_unsure_automated_decision).
gdpr_information_duties_headline_verdict_subject(art13_automated_decision_false).
gdpr_information_duties_headline_verdict_subject(art13_further_processing_prior).
gdpr_information_duties_headline_verdict_subject(art13_further_processing_same_day).
gdpr_information_duties_headline_verdict_subject(art14_on_time_at_boundary).
gdpr_information_duties_headline_verdict_subject(art14_one_day_late).
gdpr_information_duties_headline_verdict_subject(art14_communication_limb_on_time).
gdpr_information_duties_headline_verdict_subject(art14_communication_limb_late).
gdpr_information_duties_headline_verdict_subject(art14_month_end_on_time).
gdpr_information_duties_headline_verdict_subject(art14_month_end_late).
gdpr_information_duties_headline_verdict_subject(art14_holiday_shift_on_time).
gdpr_information_duties_headline_verdict_subject(art14_holiday_absent_late).
gdpr_information_duties_headline_verdict_subject(art14_effort_exemption).
gdpr_information_duties_headline_verdict_subject(art14_effort_without_measures).
gdpr_information_duties_headline_verdict_subject(art14_effort_unsure).
gdpr_information_duties_headline_verdict_subject(art14_law_exemption).
gdpr_information_duties_headline_verdict_subject(art14_law_attested_false).
gdpr_information_duties_headline_verdict_subject(art14_secrecy_exemption).
gdpr_information_duties_headline_verdict_subject(empty_profile).
gdpr_information_duties_headline_verdict_subject(input_unknown_key).
gdpr_information_duties_headline_verdict_subject(input_wrong_type).
gdpr_information_duties_headline_verdict_subject(input_duplicate_key).
gdpr_information_duties_headline_verdict_subject(input_not_a_profile).

art13_complete_items([controller_identity_and_contact_details, purposes_and_legal_basis, storage_period_or_criteria, data_subject_rights, right_to_lodge_complaint, statutory_or_contractual_requirement]).

art14_complete_items([controller_identity_and_contact_details, purposes_and_legal_basis, categories_of_personal_data, storage_period_or_criteria, data_subject_rights, right_to_lodge_complaint, source_of_personal_data]).

art13_profile(Provided, ObtainingDate, ProvisionDate, Extra, Profile) :-
    append([[attribute(personal_data_collected_from_data_subject, true), attribute(items_provided, Provided), attribute(items_data_subject_already_has, []), attribute(data_protection_officer_designated, false), attribute(processing_based_on_legitimate_interests, false), attribute(recipients_exist, false), attribute(transfer_intended, false), attribute(processing_based_on_consent, false), attribute(obtaining_date, ObtainingDate), attribute(provision_date, ProvisionDate)], Extra], Profile).

art13_plain_extra([attribute(automated_decision_making_under_article_22, false), attribute(further_processing_for_another_purpose_intended, false)]).

communication_attributes(none, [attribute(data_used_for_communication_with_data_subject, false)]).
communication_attributes(at(Date), [attribute(data_used_for_communication_with_data_subject, true), attribute(first_communication_date, Date)]).

art14_profile(Provided, ObtainingDate, ProvisionDate, Communication, Effort, Measures, Extra, Profile) :-
    communication_attributes(Communication, CommunicationAttributes),
    append([[attribute(personal_data_collected_from_data_subject, false), attribute(items_provided, Provided), attribute(items_data_subject_already_has, []), attribute(data_protection_officer_designated, false), attribute(processing_based_on_legitimate_interests, false), attribute(recipients_exist, false), attribute(transfer_intended, false), attribute(processing_based_on_consent, false), attribute(obtaining_date, ObtainingDate), attribute(provision_date, ProvisionDate)], CommunicationAttributes, [attribute(disclosure_to_another_recipient_envisaged, false), attribute(provided_within_reasonable_period, true), attribute(provision_impossible_or_disproportionate_effort, Effort), attribute(protective_measures_taken, Measures), attribute(automated_decision_making_under_article_22, false), attribute(further_processing_for_another_purpose_intended, false)], Extra], Profile).

attested_fact(Value, attested(Value, attestation(host, none, fixture_reason, none))).

gdpr_information_duties_headline_verdict_profile_for(art13_on_time, Profile) :-
    art13_complete_items(Items),
    art13_plain_extra(Extra),
    art13_profile(Items, date(2026, 3, 2), date(2026, 3, 2), Extra, Profile).
gdpr_information_duties_headline_verdict_profile_for(art13_one_day_late, Profile) :-
    art13_complete_items(Items),
    art13_plain_extra(Extra),
    art13_profile(Items, date(2026, 3, 2), date(2026, 3, 3), Extra, Profile).
gdpr_information_duties_headline_verdict_profile_for(art13_missing_statutory_item, Profile) :-
    art13_plain_extra(Extra),
    art13_profile([controller_identity_and_contact_details, purposes_and_legal_basis, storage_period_or_criteria, data_subject_rights, right_to_lodge_complaint], date(2026, 3, 2), date(2026, 3, 2), Extra, Profile).
gdpr_information_duties_headline_verdict_profile_for(art13_unsure_automated_decision, Profile) :-
    art13_complete_items(Items),
    art13_profile(Items, date(2026, 3, 2), date(2026, 3, 2), [attribute(automated_decision_making_under_article_22, unsure), attribute(further_processing_for_another_purpose_intended, false)], Profile).
gdpr_information_duties_headline_verdict_profile_for(art13_automated_decision_false, Profile) :-
    art13_complete_items(Items),
    art13_plain_extra(Extra),
    art13_profile(Items, date(2026, 3, 2), date(2026, 3, 2), Extra, Profile).
gdpr_information_duties_headline_verdict_profile_for(art13_further_processing_prior, Profile) :-
    art13_complete_items(Items),
    art13_profile(Items, date(2026, 3, 2), date(2026, 3, 2), [attribute(automated_decision_making_under_article_22, false), attribute(further_processing_for_another_purpose_intended, true), attribute(further_processing_start_date, date(2026, 4, 1)), attribute(further_processing_information_date, date(2026, 3, 31)), attribute(further_processing_items_provided, [other_purpose_information]), attribute(paragraph_2_information_relevant_to_further_processing, false)], Profile).
gdpr_information_duties_headline_verdict_profile_for(art13_further_processing_same_day, Profile) :-
    art13_complete_items(Items),
    art13_profile(Items, date(2026, 3, 2), date(2026, 3, 2), [attribute(automated_decision_making_under_article_22, false), attribute(further_processing_for_another_purpose_intended, true), attribute(further_processing_start_date, date(2026, 4, 1)), attribute(further_processing_information_date, date(2026, 4, 1)), attribute(further_processing_items_provided, [other_purpose_information]), attribute(paragraph_2_information_relevant_to_further_processing, false)], Profile).
gdpr_information_duties_headline_verdict_profile_for(art14_on_time_at_boundary, Profile) :-
    art14_complete_items(Items),
    art14_profile(Items, date(2026, 1, 15), date(2026, 2, 16), none, false, false, [], Profile).
gdpr_information_duties_headline_verdict_profile_for(art14_one_day_late, Profile) :-
    art14_complete_items(Items),
    art14_profile(Items, date(2026, 1, 15), date(2026, 2, 17), none, false, false, [], Profile).
gdpr_information_duties_headline_verdict_profile_for(art14_communication_limb_on_time, Profile) :-
    art14_complete_items(Items),
    art14_profile(Items, date(2026, 1, 15), date(2026, 1, 20), at(date(2026, 1, 20)), false, false, [], Profile).
gdpr_information_duties_headline_verdict_profile_for(art14_communication_limb_late, Profile) :-
    art14_complete_items(Items),
    art14_profile(Items, date(2026, 1, 15), date(2026, 1, 21), at(date(2026, 1, 20)), false, false, [], Profile).
gdpr_information_duties_headline_verdict_profile_for(art14_month_end_on_time, Profile) :-
    art14_complete_items(Items),
    art14_profile(Items, date(2026, 1, 31), date(2026, 3, 2), none, false, false, [], Profile).
gdpr_information_duties_headline_verdict_profile_for(art14_month_end_late, Profile) :-
    art14_complete_items(Items),
    art14_profile(Items, date(2026, 1, 31), date(2026, 3, 3), none, false, false, [], Profile).
gdpr_information_duties_headline_verdict_profile_for(art14_holiday_shift_on_time, Profile) :-
    art14_complete_items(Items),
    attested_fact([date(2027, 2, 1)], Holidays),
    art14_profile(Items, date(2026, 12, 31), date(2027, 2, 2), none, false, false, [attribute(public_holidays, Holidays)], Profile).
gdpr_information_duties_headline_verdict_profile_for(art14_holiday_absent_late, Profile) :-
    art14_complete_items(Items),
    art14_profile(Items, date(2026, 12, 31), date(2027, 2, 2), none, false, false, [], Profile).
gdpr_information_duties_headline_verdict_profile_for(art14_effort_exemption, Profile) :-
    art14_profile([], date(2026, 1, 15), date(2026, 1, 16), none, true, true, [], Profile).
gdpr_information_duties_headline_verdict_profile_for(art14_effort_without_measures, Profile) :-
    art14_profile([], date(2026, 1, 15), date(2026, 1, 16), none, true, false, [], Profile).
gdpr_information_duties_headline_verdict_profile_for(art14_effort_unsure, Profile) :-
    art14_profile([], date(2026, 1, 15), date(2026, 1, 16), none, unsure, true, [], Profile).
gdpr_information_duties_headline_verdict_profile_for(art14_law_exemption, Profile) :-
    attested_fact(true, Law),
    art14_profile([], date(2026, 1, 15), date(2026, 1, 16), none, false, false, [attribute(obtaining_or_disclosure_laid_down_by_law, Law)], Profile).
gdpr_information_duties_headline_verdict_profile_for(art14_law_attested_false, Profile) :-
    attested_fact(false, Law),
    art14_profile([], date(2026, 1, 15), date(2026, 1, 16), none, false, false, [attribute(obtaining_or_disclosure_laid_down_by_law, Law)], Profile).
gdpr_information_duties_headline_verdict_profile_for(art14_secrecy_exemption, Profile) :-
    attested_fact(true, Secrecy),
    art14_profile([], date(2026, 1, 15), date(2026, 1, 16), none, false, false, [attribute(professional_secrecy_obligation_by_law, Secrecy)], Profile).
gdpr_information_duties_headline_verdict_profile_for(empty_profile, []).
gdpr_information_duties_headline_verdict_profile_for(input_unknown_key, Profile) :-
    art13_complete_items(Items),
    art13_profile(Items, date(2026, 3, 2), date(2026, 3, 2), [attribute(automated_decision_making_under_article_22, false), attribute(further_processing_for_another_purpose_intended, false), attribute(no_such_key, true)], Profile).
gdpr_information_duties_headline_verdict_profile_for(input_wrong_type, Profile) :-
    art13_plain_extra(Extra),
    art13_profile([other_purpose_information], date(2026, 3, 2), date(2026, 3, 2), Extra, Profile).
gdpr_information_duties_headline_verdict_profile_for(input_duplicate_key, Profile) :-
    art13_complete_items(Items),
    art13_profile(Items, date(2026, 3, 2), date(2026, 3, 2), [attribute(automated_decision_making_under_article_22, false), attribute(further_processing_for_another_purpose_intended, false), attribute(personal_data_collected_from_data_subject, true)], Profile).
gdpr_information_duties_headline_verdict_profile_for(input_not_a_profile, not_an_attribute_list).

gdpr_information_duties_headline_verdict_assess(Subject, verdict(Status, Citations)) :-
    gdpr_information_duties_headline_verdict_profile_for(Subject, Profile),
    information_duty_verdict(Profile, Status, Citations).
