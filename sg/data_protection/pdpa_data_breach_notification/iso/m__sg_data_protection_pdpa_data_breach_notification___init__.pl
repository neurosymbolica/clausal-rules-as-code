% SPDX-License-Identifier: EUPL-1.2
:- module(m__sg_data_protection_pdpa_data_breach_notification___init__, [root_export/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__sg_data_protection_pdpa_data_breach_notification_kernel, [pdpa_data_breach_notification_input_problems/2]).
:- use_module(m__sg_data_protection_pdpa_data_breach_notification_citations, [citation/2, implements/1]).
:- use_module(m__sg_data_protection_pdpa_data_breach_notification_pdpa_data_breach_notification, [breach_response_duty/3, commission_notification_period_end/2, data_breach_notifiability/3, decide_pdpa_data_breach_notification/2, individual_notification/3, notification_contents/2, pdpa_breach_assessment/2, pdpa_data_breach_notification_checklist/2, pdpa_data_breach_notification_decision_resolvable/1, pdpa_data_breach_notification_status/2, pdpa_data_breach_notification_status_values/1]).
:- use_module(m__sg_data_protection_pdpa_data_breach_notification_queries, [additional_item/3, assessment_required/0, content_item/2, duplicate_key/1, indeterminate/1, n_a/0, needs_legal_review/2, no_duty_triggered/0, no_significant_harm/0, no_significant_scale/0, not_applicable/0, not_notifiable/0, not_required/0, notifiable/0, notify_organisation_without_undue_delay/0, notify_public_agency_without_undue_delay/0, pdpa_breach/5, pdpa_data_breach_notification_profile_keys/1, pdpa_data_breach_notification_what_if/4, prohibited/0, provenance/2, required/0, significant_harm/0, significant_harm/3, significant_scale/0, significant_scale/3, unknown_key/1, waived/0]).
:- use_module(m__sg_data_protection_pdpa_data_breach_notification_fixtures, [pdpa_data_breach_notification_assess/2, pdpa_data_breach_notification_profile_for/2, pdpa_data_breach_notification_subject/1]).

root_export(account_access_credential).
root_export(account_identifier).
root_export(actions_to_mitigate_harm_and_remedy_failures).
root_export(adoption_information).
root_export(affected_individual).
root_export(affected_individuals_count).
root_export(affected_individuals_not_to_be_notified).
root_export(assessed_likely_significant_harm).
root_export(assessed_likely_significant_scale).
root_export(assessment_date).
root_export(assessment_required).
root_export(authorised_representative_contact).
root_export(bank_or_finance_company_account_number).
root_export(breach_kinds).
root_export(breach_occurred_date).
root_export(breached_data).
root_export(caller_role).
root_export(capital_markets_investment).
root_export(child_or_young_person_information).
root_export(chronology_of_steps_including_assessment).
root_export(circumstances_of_first_awareness).
root_export(commission).
root_export(commission_additional).
root_export(commission_waiver_granted).
root_export(credit_facilities).
root_export(creditworthiness).
root_export(data_intermediary_for_organisation).
root_export(data_intermediary_for_public_agency).
root_export(date_and_circumstances_of_first_awareness).
root_export(debts).
root_export(deposit_of_moneys).
root_export(domestic_child_or_sexual_abuse).
root_export(full_name_or_alias).
root_export(grounds_for_not_notifying_affected_individuals).
root_export(how_breach_occurred).
root_export(identification_number).
root_export(income_from_sale_of_goods_or_property).
root_export(input_problems).
root_export(inputs_relied_on).
root_export(insurance_policy_information).
root_export(is_data_breach).
root_export(late_notification_reasons_and_evidence).
root_export(loss_of_storage_medium).
root_export(n_a).
root_export(net_worth).
root_export(no_duty_triggered).
root_export(no_significant_harm).
root_export(no_significant_scale).
root_export(not_applicable).
root_export(not_notifiable).
root_export(not_required).
root_export(notifiable).
root_export(notified_after_period).
root_export(notified_by_data_intermediary).
root_export(notify_organisation_without_undue_delay).
root_export(notify_public_agency_without_undue_delay).
root_export(number_of_affected_individuals).
root_export(open_textured).
root_export(organ_donation_or_transplant).
root_export(organisation).
root_export(other_liabilities_incurred).
root_export(other_personal_data).
root_export(payment_card_number).
root_export(payments_or_property_received).
root_export(personal_data_affected).
root_export(personal_data_in_possession_or_control).
root_export(place_of_safety_resident_identification).
root_export(plan_to_inform_individuals_or_public).
root_export(potential_harm).
root_export(prior_technological_measure_renders_harm_unlikely).
root_export(private_key).
root_export(prohibited).
root_export(prohibited_by_commission_direction).
root_export(prohibited_by_law_enforcement_agency).
root_export(publicly_available_or_lawfully_disclosed).
root_export(reason_to_believe_breach_occurred).
root_export(remedial_action_renders_harm_unlikely).
root_export(remuneration).
root_export(reproductive_or_contraceptive_treatment).
root_export(required).
root_export(significant_harm).
root_export(significant_scale).
root_export(specified_medical_condition_treatment).
root_export(specified_offence_victim_identification).
root_export(steps_individual_may_take).
root_export(suicide_or_attempted_suicide).
root_export(unauthorised_access).
root_export(unauthorised_collection).
root_export(unauthorised_copying).
root_export(unauthorised_disclosure).
root_export(unauthorised_disposal).
root_export(unauthorised_modification).
root_export(unauthorised_use).
root_export(unsure).
root_export(vulnerable_adult_information).
root_export(waived).
root_export(withdrawal_of_moneys).
root_export(within_organisation_only).
root_export(wrong_type).
