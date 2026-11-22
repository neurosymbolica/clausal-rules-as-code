% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_impact_assessment_assessment_duty_stated_risk_fixtures, [gdpr_impact_assessment_assessment_duty_stated_risk_subject/1, gdpr_impact_assessment_assessment_duty_stated_risk_profile_for/2, gdpr_impact_assessment_assessment_duty_stated_risk_assess/2]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_impact_assessment_assessment_duty_stated_risk_gdpr_impact_assessment_assessment_duty_stated_risk, [decide_gdpr_impact_assessment_assessment_duty_stated_risk/2]).

gdpr_impact_assessment_assessment_duty_stated_risk_subject(profiling_with_legal_effects_complete).
gdpr_impact_assessment_assessment_duty_stated_risk_subject(profiling_without_legal_effects).
gdpr_impact_assessment_assessment_duty_stated_risk_subject(large_scale_health_data_no_assessment).
gdpr_impact_assessment_assessment_duty_stated_risk_subject(small_scale_health_data).
gdpr_impact_assessment_assessment_duty_stated_risk_subject(public_area_monitoring_missing_measures).
gdpr_impact_assessment_assessment_duty_stated_risk_subject(public_area_monitoring_not_systematic).
gdpr_impact_assessment_assessment_duty_stated_risk_subject(national_list_item_de_dsk).
gdpr_impact_assessment_assessment_duty_stated_risk_subject(national_list_attested_false).
gdpr_impact_assessment_assessment_duty_stated_risk_subject(stated_high_risk).
gdpr_impact_assessment_assessment_duty_stated_risk_subject(high_risk_not_stated).
gdpr_impact_assessment_assessment_duty_stated_risk_subject(exempt_list_fr_cnil).
gdpr_impact_assessment_assessment_duty_stated_risk_subject(exempt_list_attested_false).
gdpr_impact_assessment_assessment_duty_stated_risk_subject(general_assessment_exemption).
gdpr_impact_assessment_assessment_duty_stated_risk_subject(member_state_requires_assessment_anyway).
gdpr_impact_assessment_assessment_duty_stated_risk_subject(member_state_decision_absent).
gdpr_impact_assessment_assessment_duty_stated_risk_subject(member_state_decision_refused).
gdpr_impact_assessment_assessment_duty_stated_risk_subject(missing_profiling_flag).
gdpr_impact_assessment_assessment_duty_stated_risk_subject(profiling_flag_supplied).
gdpr_impact_assessment_assessment_duty_stated_risk_subject(large_scale_unsure).
gdpr_impact_assessment_assessment_duty_stated_risk_subject(large_scale_stated).
gdpr_impact_assessment_assessment_duty_stated_risk_subject(legitimate_interest_unknown).
gdpr_impact_assessment_assessment_duty_stated_risk_subject(legitimate_interest_not_pursued).
gdpr_impact_assessment_assessment_duty_stated_risk_subject(duplicate_and_unknown_keys).
gdpr_impact_assessment_assessment_duty_stated_risk_subject(well_formed_control).
gdpr_impact_assessment_assessment_duty_stated_risk_subject(officer_advice_sought).
gdpr_impact_assessment_assessment_duty_stated_risk_subject(officer_not_consulted).
gdpr_impact_assessment_assessment_duty_stated_risk_subject(no_officer_designated).
gdpr_impact_assessment_assessment_duty_stated_risk_subject(officer_designated_advice_unknown).
gdpr_impact_assessment_assessment_duty_stated_risk_subject(officer_both_absent).
gdpr_impact_assessment_assessment_duty_stated_risk_subject(no_assessment_carried_out).

complete_assessment([attribute(impact_assessment_carried_out, true), attribute(description_of_processing_and_purposes_present, true), attribute(legitimate_interest_pursued, false), attribute(necessity_and_proportionality_assessed, true), attribute(risks_to_data_subjects_assessed, true), attribute(envisaged_measures_described, true)]).

gdpr_impact_assessment_assessment_duty_stated_risk_profile_for(profiling_with_legal_effects_complete, Profile) :-
    complete_assessment(Contents),
    append([attribute(automated_evaluation_including_profiling, true), attribute(decisions_based_on_evaluation, true), attribute(systematic_and_extensive_evaluation, true), attribute(decisions_produce_legal_effects, true), attribute(decisions_similarly_significantly_affect, false), attribute(processing_on_large_scale, false), attribute(likely_high_risk_to_rights_and_freedoms, false)], Contents, Profile).
gdpr_impact_assessment_assessment_duty_stated_risk_profile_for(profiling_without_legal_effects, Profile) :-
    complete_assessment(Contents),
    append([attribute(automated_evaluation_including_profiling, true), attribute(decisions_based_on_evaluation, true), attribute(systematic_and_extensive_evaluation, true), attribute(decisions_produce_legal_effects, false), attribute(decisions_similarly_significantly_affect, false), attribute(processing_on_large_scale, false), attribute(likely_high_risk_to_rights_and_freedoms, false)], Contents, Profile).
gdpr_impact_assessment_assessment_duty_stated_risk_profile_for(large_scale_health_data_no_assessment, [attribute(processing_on_large_scale, true), attribute(special_category_data_processed, true), attribute(automated_evaluation_including_profiling, false), attribute(likely_high_risk_to_rights_and_freedoms, false), attribute(impact_assessment_carried_out, false)]).
gdpr_impact_assessment_assessment_duty_stated_risk_profile_for(small_scale_health_data, [attribute(processing_on_large_scale, false), attribute(special_category_data_processed, true), attribute(automated_evaluation_including_profiling, false), attribute(likely_high_risk_to_rights_and_freedoms, false), attribute(impact_assessment_carried_out, false)]).
gdpr_impact_assessment_assessment_duty_stated_risk_profile_for(public_area_monitoring_missing_measures, [attribute(publicly_accessible_area_monitored, true), attribute(monitoring_is_systematic, true), attribute(processing_on_large_scale, true), attribute(special_category_data_processed, false), attribute(criminal_offence_data_processed, false), attribute(automated_evaluation_including_profiling, false), attribute(likely_high_risk_to_rights_and_freedoms, false), attribute(impact_assessment_carried_out, true), attribute(description_of_processing_and_purposes_present, true), attribute(legitimate_interest_pursued, false), attribute(necessity_and_proportionality_assessed, true), attribute(risks_to_data_subjects_assessed, true), attribute(envisaged_measures_described, false)]).
gdpr_impact_assessment_assessment_duty_stated_risk_profile_for(public_area_monitoring_not_systematic, [attribute(publicly_accessible_area_monitored, true), attribute(monitoring_is_systematic, false), attribute(processing_on_large_scale, true), attribute(special_category_data_processed, false), attribute(criminal_offence_data_processed, false), attribute(automated_evaluation_including_profiling, false), attribute(likely_high_risk_to_rights_and_freedoms, false), attribute(impact_assessment_carried_out, true), attribute(description_of_processing_and_purposes_present, true), attribute(legitimate_interest_pursued, false), attribute(necessity_and_proportionality_assessed, true), attribute(risks_to_data_subjects_assessed, true), attribute(envisaged_measures_described, false)]).
gdpr_impact_assessment_assessment_duty_stated_risk_profile_for(national_list_item_de_dsk, Profile) :-
    complete_assessment(Contents),
    append([attribute(national_list_requires_assessment, attested(true, attestation(host, at_time, reason, none))), attribute(national_list_requires_item, attested(national_list_item(de_dsk, de_dsk_35_4_nr_1), attestation(host, at_time, reason, none))), attribute(likely_high_risk_to_rights_and_freedoms, false), attribute(automated_evaluation_including_profiling, false), attribute(processing_on_large_scale, false)], Contents, Profile).
gdpr_impact_assessment_assessment_duty_stated_risk_profile_for(national_list_attested_false, Profile) :-
    complete_assessment(Contents),
    append([attribute(national_list_requires_assessment, attested(false, attestation(host, at_time, reason, none))), attribute(national_list_requires_item, attested(national_list_item(de_dsk, de_dsk_35_4_nr_1), attestation(host, at_time, reason, none))), attribute(likely_high_risk_to_rights_and_freedoms, false), attribute(automated_evaluation_including_profiling, false), attribute(processing_on_large_scale, false)], Contents, Profile).
gdpr_impact_assessment_assessment_duty_stated_risk_profile_for(stated_high_risk, Profile) :-
    complete_assessment(Contents),
    append([attribute(likely_high_risk_to_rights_and_freedoms, true), attribute(automated_evaluation_including_profiling, false), attribute(processing_on_large_scale, false)], Contents, Profile).
gdpr_impact_assessment_assessment_duty_stated_risk_profile_for(high_risk_not_stated, Profile) :-
    complete_assessment(Contents),
    append([attribute(likely_high_risk_to_rights_and_freedoms, false), attribute(automated_evaluation_including_profiling, false), attribute(processing_on_large_scale, false)], Contents, Profile).
gdpr_impact_assessment_assessment_duty_stated_risk_profile_for(exempt_list_fr_cnil, Profile) :-
    complete_assessment(Contents),
    append([attribute(national_list_exempts_assessment, attested(true, attestation(host, at_time, reason, none))), attribute(national_list_exempts_item, attested(national_list_item(fr_cnil, fr_cnil_35_5_list), attestation(host, at_time, reason, none))), attribute(likely_high_risk_to_rights_and_freedoms, true), attribute(automated_evaluation_including_profiling, false), attribute(processing_on_large_scale, false)], Contents, Profile).
gdpr_impact_assessment_assessment_duty_stated_risk_profile_for(exempt_list_attested_false, Profile) :-
    complete_assessment(Contents),
    append([attribute(national_list_exempts_assessment, attested(false, attestation(host, at_time, reason, none))), attribute(national_list_exempts_item, attested(national_list_item(fr_cnil, fr_cnil_35_5_list), attestation(host, at_time, reason, none))), attribute(likely_high_risk_to_rights_and_freedoms, true), attribute(automated_evaluation_including_profiling, false), attribute(processing_on_large_scale, false)], Contents, Profile).
gdpr_impact_assessment_assessment_duty_stated_risk_profile_for(general_assessment_exemption, Profile) :-
    complete_assessment(Contents),
    append([attribute(lawful_basis_is_legal_obligation_or_public_task, true), attribute(legal_basis_with_general_impact_assessment, attested(true, attestation(host, at_time, reason, none))), attribute(member_state_requires_assessment_despite_general_one, attested(false, attestation(host, at_time, reason, none))), attribute(automated_evaluation_including_profiling, true), attribute(decisions_based_on_evaluation, true), attribute(systematic_and_extensive_evaluation, true), attribute(decisions_produce_legal_effects, true), attribute(likely_high_risk_to_rights_and_freedoms, false)], Contents, Profile).
gdpr_impact_assessment_assessment_duty_stated_risk_profile_for(member_state_requires_assessment_anyway, Profile) :-
    complete_assessment(Contents),
    append([attribute(lawful_basis_is_legal_obligation_or_public_task, true), attribute(legal_basis_with_general_impact_assessment, attested(true, attestation(host, at_time, reason, none))), attribute(member_state_requires_assessment_despite_general_one, attested(true, attestation(host, at_time, reason, none))), attribute(automated_evaluation_including_profiling, true), attribute(decisions_based_on_evaluation, true), attribute(systematic_and_extensive_evaluation, true), attribute(decisions_produce_legal_effects, true), attribute(likely_high_risk_to_rights_and_freedoms, false)], Contents, Profile).
gdpr_impact_assessment_assessment_duty_stated_risk_profile_for(member_state_decision_absent, [attribute(lawful_basis_is_legal_obligation_or_public_task, true), attribute(legal_basis_with_general_impact_assessment, attested(true, attestation(host, at_time, reason, none))), attribute(automated_evaluation_including_profiling, true), attribute(decisions_based_on_evaluation, true), attribute(systematic_and_extensive_evaluation, true), attribute(decisions_produce_legal_effects, true), attribute(likely_high_risk_to_rights_and_freedoms, false), attribute(impact_assessment_carried_out, false)]).
gdpr_impact_assessment_assessment_duty_stated_risk_profile_for(member_state_decision_refused, [attribute(lawful_basis_is_legal_obligation_or_public_task, true), attribute(legal_basis_with_general_impact_assessment, attested(true, attestation(host, at_time, reason, none))), attribute(member_state_requires_assessment_despite_general_one, attested(false, attestation(host, at_time, reason, none))), attribute(automated_evaluation_including_profiling, true), attribute(decisions_based_on_evaluation, true), attribute(systematic_and_extensive_evaluation, true), attribute(decisions_produce_legal_effects, true), attribute(likely_high_risk_to_rights_and_freedoms, false), attribute(impact_assessment_carried_out, false)]).
gdpr_impact_assessment_assessment_duty_stated_risk_profile_for(missing_profiling_flag, [attribute(decisions_based_on_evaluation, true), attribute(systematic_and_extensive_evaluation, true), attribute(decisions_produce_legal_effects, true), attribute(processing_on_large_scale, false), attribute(likely_high_risk_to_rights_and_freedoms, false), attribute(impact_assessment_carried_out, false)]).
gdpr_impact_assessment_assessment_duty_stated_risk_profile_for(profiling_flag_supplied, [attribute(automated_evaluation_including_profiling, true), attribute(decisions_based_on_evaluation, true), attribute(systematic_and_extensive_evaluation, true), attribute(decisions_produce_legal_effects, true), attribute(processing_on_large_scale, false), attribute(likely_high_risk_to_rights_and_freedoms, false), attribute(impact_assessment_carried_out, false)]).
gdpr_impact_assessment_assessment_duty_stated_risk_profile_for(large_scale_unsure, [attribute(processing_on_large_scale, unsure), attribute(special_category_data_processed, true), attribute(automated_evaluation_including_profiling, false), attribute(likely_high_risk_to_rights_and_freedoms, false), attribute(impact_assessment_carried_out, false)]).
gdpr_impact_assessment_assessment_duty_stated_risk_profile_for(large_scale_stated, [attribute(processing_on_large_scale, true), attribute(special_category_data_processed, true), attribute(automated_evaluation_including_profiling, false), attribute(likely_high_risk_to_rights_and_freedoms, false), attribute(impact_assessment_carried_out, false)]).
gdpr_impact_assessment_assessment_duty_stated_risk_profile_for(legitimate_interest_unknown, [attribute(national_list_requires_assessment, attested(true, attestation(host, at_time, reason, none))), attribute(likely_high_risk_to_rights_and_freedoms, false), attribute(impact_assessment_carried_out, true), attribute(description_of_processing_and_purposes_present, true), attribute(necessity_and_proportionality_assessed, true), attribute(risks_to_data_subjects_assessed, true), attribute(envisaged_measures_described, true)]).
gdpr_impact_assessment_assessment_duty_stated_risk_profile_for(legitimate_interest_not_pursued, [attribute(national_list_requires_assessment, attested(true, attestation(host, at_time, reason, none))), attribute(likely_high_risk_to_rights_and_freedoms, false), attribute(impact_assessment_carried_out, true), attribute(description_of_processing_and_purposes_present, true), attribute(legitimate_interest_pursued, false), attribute(necessity_and_proportionality_assessed, true), attribute(risks_to_data_subjects_assessed, true), attribute(envisaged_measures_described, true)]).
gdpr_impact_assessment_assessment_duty_stated_risk_profile_for(duplicate_and_unknown_keys, [attribute(automated_evaluation_including_profiling, false), attribute(processing_on_large_scale, false), attribute(processing_on_large_scale, false), attribute(likely_high_risk_to_rights_and_freedoms, false), attribute(colour, red)]).
gdpr_impact_assessment_assessment_duty_stated_risk_profile_for(well_formed_control, [attribute(automated_evaluation_including_profiling, false), attribute(processing_on_large_scale, false), attribute(likely_high_risk_to_rights_and_freedoms, false)]).
gdpr_impact_assessment_assessment_duty_stated_risk_profile_for(officer_advice_sought, [attribute(impact_assessment_carried_out, true), attribute(data_protection_officer_designated, true), attribute(data_protection_officer_advice_sought, true)]).
gdpr_impact_assessment_assessment_duty_stated_risk_profile_for(officer_not_consulted, [attribute(impact_assessment_carried_out, true), attribute(data_protection_officer_designated, true), attribute(data_protection_officer_advice_sought, false)]).
gdpr_impact_assessment_assessment_duty_stated_risk_profile_for(no_officer_designated, [attribute(impact_assessment_carried_out, true), attribute(data_protection_officer_designated, false)]).
gdpr_impact_assessment_assessment_duty_stated_risk_profile_for(officer_designated_advice_unknown, [attribute(impact_assessment_carried_out, true), attribute(data_protection_officer_designated, true)]).
gdpr_impact_assessment_assessment_duty_stated_risk_profile_for(officer_both_absent, []).
gdpr_impact_assessment_assessment_duty_stated_risk_profile_for(no_assessment_carried_out, [attribute(impact_assessment_carried_out, false)]).

gdpr_impact_assessment_assessment_duty_stated_risk_assess(Subject, Result) :-
    gdpr_impact_assessment_assessment_duty_stated_risk_profile_for(Subject, Profile),
    decide_gdpr_impact_assessment_assessment_duty_stated_risk(Profile, Result).
