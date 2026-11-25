% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_rts_policies_and_risk_management_fixtures, [dora_rts_policies_and_risk_management_subject/1, dora_rts_policies_and_risk_management_profile_for/2, dora_rts_policies_and_risk_management_assess/2]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(library(reif), [tfilter/3, (=)/3]).
:- use_module(m__eu_dora_rts_policies_and_risk_management_dora_rts_policies_and_risk_management, [decide_dora_rts_policies_and_risk_management/2]).
:- use_module(library(reif), [if_/3]).

dora_rts_policies_and_risk_management_subject(all_duties_performed).
dora_rts_policies_and_risk_management_subject(one_duty_not_performed).
dora_rts_policies_and_risk_management_subject(simplified_framework_entity_with_duties_performed).
dora_rts_policies_and_risk_management_subject(gate_unanswered).
dora_rts_policies_and_risk_management_subject(duty_unanswered).
dora_rts_policies_and_risk_management_subject(duty_judgement_unsure).
dora_rts_policies_and_risk_management_subject(second_paragraph_duty_not_performed).
dora_rts_policies_and_risk_management_subject(duty_not_performed_and_another_unanswered).
dora_rts_policies_and_risk_management_subject(unknown_key_present).

dora_rts_policies_and_risk_management_profile_for(all_duties_performed, Profile) :-
    performed_profile(Profile).
dora_rts_policies_and_risk_management_profile_for(one_duty_not_performed, Profile) :-
    performed_profile(Base),
    with_value(Base, security_policies_ensure_security_of_networks, false, Profile).
dora_rts_policies_and_risk_management_profile_for(simplified_framework_entity_with_duties_performed, Profile) :-
    performed_profile(Base),
    with_value(Base, financial_entity_is_article_16_1_entity, true, Profile).
dora_rts_policies_and_risk_management_profile_for(gate_unanswered, Profile) :-
    performed_profile(Base),
    without_key(Base, financial_entity_is_article_16_1_entity, Profile).
dora_rts_policies_and_risk_management_profile_for(duty_unanswered, Profile) :-
    performed_profile(Base),
    without_key(Base, security_policies_contain_safeguards_against_intrusions_and_data_misuse, Profile).
dora_rts_policies_and_risk_management_profile_for(duty_judgement_unsure, Profile) :-
    performed_profile(Base),
    with_value(Base, security_policies_contain_indicators_and_measures_for_implementation_and_exceptions, unsure, Profile).
dora_rts_policies_and_risk_management_profile_for(second_paragraph_duty_not_performed, Profile) :-
    performed_profile(Base),
    with_value(Base, risk_treatment_procedure_ensures_monitoring_of_treatment_effectiveness, false, Profile).
dora_rts_policies_and_risk_management_profile_for(duty_not_performed_and_another_unanswered, Profile) :-
    performed_profile(Base),
    without_key(Base, size_risk_profile_and_complexity_taken_into_account, ShortProfile),
    with_value(ShortProfile, security_policies_ensure_security_of_networks, false, Profile).
dora_rts_policies_and_risk_management_profile_for(unknown_key_present, Profile) :-
    performed_profile(Base),
    append(Base, [attribute(colour, red)], Profile).

dora_rts_policies_and_risk_management_assess(Subject, Result) :-
    dora_rts_policies_and_risk_management_profile_for(Subject, Profile),
    decide_dora_rts_policies_and_risk_management(Profile, Result).

duty_keys([size_risk_profile_and_complexity_taken_into_account, ict_security_policies_embedded_in_ict_risk_management_framework, security_policies_ensure_security_of_networks, security_policies_contain_safeguards_against_intrusions_and_data_misuse, security_policies_preserve_availability_authenticity_integrity_and_confidentiality_of_data, security_policies_guarantee_accurate_and_prompt_data_transmission, security_policies_aligned_to_information_security_objectives, security_policies_indicate_date_of_management_body_approval, security_policies_contain_indicators_and_measures_for_implementation_and_exceptions, security_policies_specify_staff_responsibilities_for_ict_security, security_policies_specify_consequences_of_staff_non_compliance, security_policies_list_documentation_to_be_maintained, security_policies_specify_segregation_of_duties_arrangements, security_policies_consider_leading_practices_and_standards, security_policies_identify_roles_for_development_implementation_and_maintenance, security_policies_reviewed_in_accordance_with_article_6_5, security_policies_take_material_changes_into_account, ict_risk_management_policies_and_procedures_developed_documented_and_implemented, risk_management_policies_indicate_approval_of_risk_tolerance_level, risk_management_policies_contain_risk_assessment_procedure_and_methodology, risk_management_policies_contain_risk_treatment_procedure, risk_management_policies_contain_residual_risk_provisions, risk_management_policies_contain_risk_monitoring_provisions, risk_management_policies_contain_process_for_strategy_changes, risk_treatment_procedure_ensures_monitoring_of_treatment_effectiveness, risk_treatment_procedure_ensures_assessment_of_risk_tolerance_attainment, risk_treatment_procedure_ensures_assessment_of_corrective_actions]).

performed_profile([attribute(financial_entity_is_article_16_1_entity, false)|DutyAttributes]) :-
    duty_keys(DutyKeys),
    maplist(true_attribute, DutyKeys, DutyAttributes).

true_attribute(ProfileKey, attribute(ProfileKey, true)).

with_value(Profile, ProfileKey, Value, NewProfile) :-
    maplist(replaced_attribute(ProfileKey, Value), Profile, NewProfile).

replaced_attribute(ProfileKey, Value, attribute(OtherKey, OldValue), attribute(OtherKey, NewValue)) :-
    if_(OtherKey = ProfileKey, NewValue = Value, NewValue = OldValue).

without_key(Profile, ProfileKey, NewProfile) :-
    tfilter(attribute_kept_t(ProfileKey), Profile, NewProfile).

attribute_kept_t(ProfileKey, attribute(OtherKey, _), Truth) :-
    if_(OtherKey = ProfileKey, Truth = false, Truth = true).
