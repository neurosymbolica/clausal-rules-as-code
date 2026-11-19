% SPDX-License-Identifier: EUPL-1.2
:- module(m__ind_dpdp_security_retention___init__, [root_export/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__ind_dpdp_security_retention_kernel, [dpdp_security_retention_input_problems/2, leap_year_t/2, month_length/3, real_calendar_date_t/2]).
:- use_module(m__ind_dpdp_security_retention_citations, [citation/2, implements/1]).
:- use_module(m__ind_dpdp_security_retention_dpdp_security_retention, [accuracy_duty/3, decide_dpdp_security_retention/2, dpdp_security_retention_checklist/2, dpdp_security_retention_decision_resolvable/1, dpdp_security_retention_status/2, dpdp_security_retention_status_values/1, erasure_duty/3, erasure_notice_latest_day/2, fixed_lists/2, processing_log_retention_minimum_end/2, security_safeguards_duty/3, third_schedule_deemed_no_longer_served/3, third_schedule_period_end/2]).
:- use_module(m__ind_dpdp_security_retention_queries, [deemed_no_longer_served/0, dpdp_security_retention_profile_keys/1, dpdp_security_retention_what_if/4, erase/0, erase_and_cause_data_processor_to_erase/0, not_in_force/0, not_listed/0, not_required/0, not_yet_deemed/0, not_yet_required/0, required/0, required_minimum_not_prescribed/0, required_with_rule_6_minimum/0, retain_as_required_by_other_law/0, retain_until_minimum_retention_period_end/0]).
:- use_module(m__ind_dpdp_security_retention_fixtures, [dpdp_security_retention_assess/2, dpdp_security_retention_profile_for/2, dpdp_security_retention_subject/1]).

root_export(access_control_measures_for_computer_resources).
root_export(acts_as_data_fiduciary).
root_export(assessment_date).
root_export(assessment_for_notifying_significant_data_fiduciary).
root_export(consent_withdrawn).
root_export(content_item).
root_export(continued_processing_measures_such_as_data_backups).
root_export(data_made_available_to_data_processor).
root_export(data_processor_contract_provision_for_security_safeguards).
root_export(data_security_measures_such_as_encryption_obfuscation_masking_or_virtual_tokens).
root_export(deemed_no_longer_served).
root_export(duplicate_key).
root_export(e_commerce_entity).
root_export(erase).
root_export(erase_and_cause_data_processor_to_erase).
root_export(indeterminate).
root_export(input_problems).
root_export(inputs_relied_on).
root_export(last_approached_date).
root_export(last_processing_date).
root_export(likely_disclosed_to_another_data_fiduciary).
root_export(likely_used_for_decision_affecting_data_principal).
root_export(needs_legal_review).
root_export(no_listed_class).
root_export(not_in_force).
root_export(not_listed).
root_export(not_required).
root_export(not_yet_deemed).
root_export(not_yet_required).
root_export(one_year_retention_of_logs_and_personal_data).
root_export(online_gaming_intermediary).
root_export(open_textured).
root_export(provenance).
root_export(registered_users_in_india).
root_export(required).
root_export(required_minimum_not_prescribed).
root_export(required_with_rule_6_minimum).
root_export(retain_as_required_by_other_law).
root_export(retain_until_minimum_retention_period_end).
root_export(retention_necessary_for_compliance_with_law).
root_export(section_8_3_in_force).
root_export(section_8_5_in_force).
root_export(section_8_7_in_force).
root_export(section_8_8_in_force).
root_export(security_safeguard_minimum).
root_export(seventh_schedule_purposes).
root_export(social_media_intermediary).
root_export(specified_purpose_no_longer_served).
root_export(state_use_for_disclosure_to_fulfil_obligation_under_law).
root_export(state_use_for_performance_of_function_under_law).
root_export(state_use_for_sovereignty_integrity_or_security).
root_export(technical_and_organisational_measures_for_security_safeguards).
root_export(third_schedule_class).
root_export(third_schedule_purpose_excepted).
root_export(unknown_key).
root_export(unsure).
root_export(visibility_through_logs_monitoring_and_review).
root_export(wrong_type).
