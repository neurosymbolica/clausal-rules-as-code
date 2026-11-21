% SPDX-License-Identifier: EUPL-1.2
:- module(m__us_texas_tdpsa_fixtures, [texas_tdpsa_subject/1, texas_tdpsa_profile_for/2, texas_tdpsa_assess/2]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__us_texas_tdpsa_texas_tdpsa, [decide_texas_tdpsa/2]).

texas_tdpsa_subject(in_scope_controller).
texas_tdpsa_subject(small_business_attested).
texas_tdpsa_subject(nonprofit_excluded).
texas_tdpsa_subject(not_processing_personal_data).
texas_tdpsa_subject(not_conducting_business).
texas_tdpsa_subject(entity_category_missing).
texas_tdpsa_subject(sba_absent_referral).
texas_tdpsa_subject(conducts_business_unsure).
texas_tdpsa_subject(malformed_duplicate_key).
texas_tdpsa_subject(extension_granted).
texas_tdpsa_subject(extension_notice_late).
texas_tdpsa_subject(extension_necessity_unsure).
texas_tdpsa_subject(extension_notice_missing).
texas_tdpsa_subject(cure_completed).
texas_tdpsa_subject(statement_breached).
texas_tdpsa_subject(cure_not_achieved).
texas_tdpsa_subject(cure_keys_missing).
texas_tdpsa_subject(penalty_three_violations).
texas_tdpsa_subject(penalty_zero_violations).
texas_tdpsa_subject(penalty_no_ground).
texas_tdpsa_subject(penalty_count_missing).

texas_tdpsa_profile_for(in_scope_controller, [attribute(entity_category, none_of_the_excluded_categories), attribute(processes_or_sells_personal_data, true), attribute(conducts_business_in_texas_or_serves_texas_residents, true), attribute(small_business_as_defined_by_sba, attested(false, attestation(host_user, host_time, size_review, none)))]).
texas_tdpsa_profile_for(small_business_attested, [attribute(entity_category, none_of_the_excluded_categories), attribute(processes_or_sells_personal_data, true), attribute(conducts_business_in_texas_or_serves_texas_residents, true), attribute(small_business_as_defined_by_sba, attested(true, attestation(host_user, host_time, size_review, none)))]).
texas_tdpsa_profile_for(nonprofit_excluded, [attribute(entity_category, nonprofit_organization), attribute(processes_or_sells_personal_data, true), attribute(conducts_business_in_texas_or_serves_texas_residents, true), attribute(small_business_as_defined_by_sba, attested(false, attestation(host_user, host_time, size_review, none)))]).
texas_tdpsa_profile_for(not_processing_personal_data, [attribute(entity_category, none_of_the_excluded_categories), attribute(processes_or_sells_personal_data, false), attribute(conducts_business_in_texas_or_serves_texas_residents, true), attribute(small_business_as_defined_by_sba, attested(false, attestation(host_user, host_time, size_review, none)))]).
texas_tdpsa_profile_for(not_conducting_business, [attribute(entity_category, none_of_the_excluded_categories), attribute(processes_or_sells_personal_data, true), attribute(conducts_business_in_texas_or_serves_texas_residents, false), attribute(small_business_as_defined_by_sba, attested(false, attestation(host_user, host_time, size_review, none)))]).
texas_tdpsa_profile_for(entity_category_missing, [attribute(processes_or_sells_personal_data, true), attribute(conducts_business_in_texas_or_serves_texas_residents, true), attribute(small_business_as_defined_by_sba, attested(false, attestation(host_user, host_time, size_review, none)))]).
texas_tdpsa_profile_for(sba_absent_referral, [attribute(entity_category, none_of_the_excluded_categories), attribute(processes_or_sells_personal_data, true), attribute(conducts_business_in_texas_or_serves_texas_residents, true)]).
texas_tdpsa_profile_for(conducts_business_unsure, [attribute(entity_category, none_of_the_excluded_categories), attribute(processes_or_sells_personal_data, true), attribute(conducts_business_in_texas_or_serves_texas_residents, unsure), attribute(small_business_as_defined_by_sba, attested(false, attestation(host_user, host_time, size_review, none)))]).
texas_tdpsa_profile_for(malformed_duplicate_key, [attribute(entity_category, none_of_the_excluded_categories), attribute(entity_category, nonprofit_organization), attribute(processes_or_sells_personal_data, true)]).
texas_tdpsa_profile_for(extension_granted, [attribute(extension_reasonably_necessary, true), attribute(extension_notice_given_within_initial_period, true)]).
texas_tdpsa_profile_for(extension_notice_late, [attribute(extension_reasonably_necessary, true), attribute(extension_notice_given_within_initial_period, false)]).
texas_tdpsa_profile_for(extension_necessity_unsure, [attribute(extension_reasonably_necessary, unsure), attribute(extension_notice_given_within_initial_period, true)]).
texas_tdpsa_profile_for(extension_notice_missing, [attribute(extension_reasonably_necessary, true)]).
texas_tdpsa_profile_for(cure_completed, [attribute(cured_within_cure_period, true), attribute(written_statement_provided, true), attribute(written_statement_breached, false)]).
texas_tdpsa_profile_for(statement_breached, [attribute(cured_within_cure_period, true), attribute(written_statement_provided, true), attribute(written_statement_breached, true)]).
texas_tdpsa_profile_for(cure_not_achieved, [attribute(cured_within_cure_period, false)]).
texas_tdpsa_profile_for(cure_keys_missing, []).
texas_tdpsa_profile_for(penalty_three_violations, [attribute(violation_after_cure_period_or_statement_breach, true), attribute(violation_count, 3)]).
texas_tdpsa_profile_for(penalty_zero_violations, [attribute(violation_after_cure_period_or_statement_breach, true), attribute(violation_count, 0)]).
texas_tdpsa_profile_for(penalty_no_ground, [attribute(violation_after_cure_period_or_statement_breach, false), attribute(violation_count, 3)]).
texas_tdpsa_profile_for(penalty_count_missing, [attribute(violation_after_cure_period_or_statement_breach, true)]).

texas_tdpsa_assess(Subject, Result) :-
    texas_tdpsa_profile_for(Subject, Profile),
    decide_texas_tdpsa(Profile, Result).
