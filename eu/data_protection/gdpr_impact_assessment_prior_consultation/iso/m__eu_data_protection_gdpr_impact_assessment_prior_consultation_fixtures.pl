% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_impact_assessment_prior_consultation_fixtures, [gdpr_impact_assessment_prior_consultation_subject/1, gdpr_impact_assessment_prior_consultation_profile_for/2, gdpr_impact_assessment_prior_consultation_assess/2]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_impact_assessment_prior_consultation_prior_consultation_duty, [decide_prior_consultation_duty/2]).

gdpr_impact_assessment_prior_consultation_subject(residual_high_risk_no_measures).
gdpr_impact_assessment_prior_consultation_subject(measures_bring_risk_below_high).
gdpr_impact_assessment_prior_consultation_subject(residual_high_risk_measures_insufficient).
gdpr_impact_assessment_prior_consultation_subject(no_high_risk_indicated).
gdpr_impact_assessment_prior_consultation_subject(member_state_prior_authorisation).
gdpr_impact_assessment_prior_consultation_subject(member_state_law_does_not_require_authorisation).
gdpr_impact_assessment_prior_consultation_subject(both_ways_met).
gdpr_impact_assessment_prior_consultation_subject(no_assessment_public_interest_unmet).
gdpr_impact_assessment_prior_consultation_subject(no_assessment_member_state_authorisation).
gdpr_impact_assessment_prior_consultation_subject(no_assessment_member_state_fact_absent).
gdpr_impact_assessment_prior_consultation_subject(assessment_status_absent_no_way_open).
gdpr_impact_assessment_prior_consultation_subject(assessment_status_absent_way_open).
gdpr_impact_assessment_prior_consultation_subject(two_keys_missing).
gdpr_impact_assessment_prior_consultation_subject(residual_risk_unsure).
gdpr_impact_assessment_prior_consultation_subject(high_risk_unsure).
gdpr_impact_assessment_prior_consultation_subject(duplicate_and_unknown_keys).
gdpr_impact_assessment_prior_consultation_subject(criteria_and_item_keys_ignored).

gdpr_impact_assessment_prior_consultation_profile_for(residual_high_risk_no_measures, [attribute(impact_assessment_carried_out, true), attribute(assessment_indicates_high_risk_absent_mitigation, true), attribute(mitigating_measures_taken, false), attribute(processing_for_public_interest_task, false)]).
gdpr_impact_assessment_prior_consultation_profile_for(measures_bring_risk_below_high, [attribute(impact_assessment_carried_out, true), attribute(assessment_indicates_high_risk_absent_mitigation, true), attribute(mitigating_measures_taken, true), attribute(measures_reduce_residual_risk_below_high, true), attribute(processing_for_public_interest_task, false)]).
gdpr_impact_assessment_prior_consultation_profile_for(residual_high_risk_measures_insufficient, [attribute(impact_assessment_carried_out, true), attribute(assessment_indicates_high_risk_absent_mitigation, true), attribute(mitigating_measures_taken, true), attribute(measures_reduce_residual_risk_below_high, false), attribute(processing_for_public_interest_task, false)]).
gdpr_impact_assessment_prior_consultation_profile_for(no_high_risk_indicated, [attribute(impact_assessment_carried_out, true), attribute(assessment_indicates_high_risk_absent_mitigation, false), attribute(mitigating_measures_taken, false), attribute(processing_for_public_interest_task, false)]).
gdpr_impact_assessment_prior_consultation_profile_for(member_state_prior_authorisation, [attribute(impact_assessment_carried_out, true), attribute(assessment_indicates_high_risk_absent_mitigation, false), attribute(processing_for_public_interest_task, true), attribute(member_state_requires_prior_authorisation, attested(true, attestation(by, at, reason, none)))]).
gdpr_impact_assessment_prior_consultation_profile_for(member_state_law_does_not_require_authorisation, [attribute(impact_assessment_carried_out, true), attribute(assessment_indicates_high_risk_absent_mitigation, false), attribute(processing_for_public_interest_task, true), attribute(member_state_requires_prior_authorisation, attested(false, attestation(by, at, reason, none)))]).
gdpr_impact_assessment_prior_consultation_profile_for(both_ways_met, [attribute(impact_assessment_carried_out, true), attribute(assessment_indicates_high_risk_absent_mitigation, true), attribute(mitigating_measures_taken, false), attribute(processing_for_public_interest_task, true), attribute(member_state_requires_prior_authorisation, attested(true, attestation(by, at, reason, none)))]).
gdpr_impact_assessment_prior_consultation_profile_for(no_assessment_public_interest_unmet, [attribute(impact_assessment_carried_out, false), attribute(assessment_indicates_high_risk_absent_mitigation, true), attribute(mitigating_measures_taken, false), attribute(processing_for_public_interest_task, false)]).
gdpr_impact_assessment_prior_consultation_profile_for(no_assessment_member_state_authorisation, [attribute(impact_assessment_carried_out, false), attribute(processing_for_public_interest_task, true), attribute(member_state_requires_prior_authorisation, attested(true, attestation(by, at, reason, none)))]).
gdpr_impact_assessment_prior_consultation_profile_for(no_assessment_member_state_fact_absent, [attribute(impact_assessment_carried_out, false), attribute(processing_for_public_interest_task, true)]).
gdpr_impact_assessment_prior_consultation_profile_for(assessment_status_absent_no_way_open, [attribute(assessment_indicates_high_risk_absent_mitigation, false), attribute(processing_for_public_interest_task, false)]).
gdpr_impact_assessment_prior_consultation_profile_for(assessment_status_absent_way_open, [attribute(assessment_indicates_high_risk_absent_mitigation, true), attribute(mitigating_measures_taken, false), attribute(processing_for_public_interest_task, false)]).
gdpr_impact_assessment_prior_consultation_profile_for(two_keys_missing, [attribute(impact_assessment_carried_out, true), attribute(assessment_indicates_high_risk_absent_mitigation, true), attribute(processing_for_public_interest_task, false)]).
gdpr_impact_assessment_prior_consultation_profile_for(residual_risk_unsure, [attribute(impact_assessment_carried_out, true), attribute(assessment_indicates_high_risk_absent_mitigation, true), attribute(mitigating_measures_taken, true), attribute(measures_reduce_residual_risk_below_high, unsure), attribute(processing_for_public_interest_task, false)]).
gdpr_impact_assessment_prior_consultation_profile_for(high_risk_unsure, [attribute(impact_assessment_carried_out, true), attribute(assessment_indicates_high_risk_absent_mitigation, unsure), attribute(mitigating_measures_taken, false), attribute(processing_for_public_interest_task, false)]).
gdpr_impact_assessment_prior_consultation_profile_for(duplicate_and_unknown_keys, [attribute(impact_assessment_carried_out, true), attribute(impact_assessment_carried_out, false), attribute(mitigating_measures_taken, unsure), attribute(stray_flag, true)]).
gdpr_impact_assessment_prior_consultation_profile_for(criteria_and_item_keys_ignored, [attribute(impact_assessment_carried_out, true), attribute(assessment_indicates_high_risk_absent_mitigation, true), attribute(mitigating_measures_taken, false), attribute(processing_for_public_interest_task, false), attribute(highly_personal_data_processed, unsure), attribute(vulnerable_data_subjects, false), attribute(uses_new_technologies, true), attribute(likely_high_risk_to_rights_and_freedoms, true), attribute(national_list_requires_assessment, attested(true, attestation(by, at, reason, none))), attribute(national_list_requires_item, attested(national_list_item(ie_dpc, ie_dpc_35_4_nr_1), attestation(by, at, reason, none))), attribute(route_approvals, approvals(viewer(account), []))]).

gdpr_impact_assessment_prior_consultation_assess(Subject, Result) :-
    gdpr_impact_assessment_prior_consultation_profile_for(Subject, Profile),
    decide_prior_consultation_duty(Profile, Result).
