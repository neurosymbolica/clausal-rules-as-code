% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_proportionality_and_simplified_framework_fixtures, [dora_proportionality_and_simplified_framework_subject/1, dora_proportionality_and_simplified_framework_profile_for/2, dora_proportionality_and_simplified_framework_assess/2]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_dora_proportionality_and_simplified_framework_dora_proportionality_and_simplified_framework, [decide_dora_proportionality_and_simplified_framework/2]).

dora_proportionality_and_simplified_framework_subject(exempted_payment_institution_all_duties_performed).
dora_proportionality_and_simplified_framework_subject(exempted_payment_institution_framework_not_performed).
dora_proportionality_and_simplified_framework_subject(exempted_payment_institution_framework_unsure).
dora_proportionality_and_simplified_framework_subject(exempted_electronic_money_institution_all_duties_performed).
dora_proportionality_and_simplified_framework_subject(small_investment_firm_all_duties_performed).
dora_proportionality_and_simplified_framework_subject(investment_firm_not_small).
dora_proportionality_and_simplified_framework_subject(occupational_retirement_fifteen_members).
dora_proportionality_and_simplified_framework_subject(occupational_retirement_sixteen_members).
dora_proportionality_and_simplified_framework_subject(occupational_retirement_ninety_nine_members).
dora_proportionality_and_simplified_framework_subject(occupational_retirement_one_hundred_members).
dora_proportionality_and_simplified_framework_subject(directive_institution_not_excluded_by_member_state).
dora_proportionality_and_simplified_framework_subject(directive_institution_excluded_by_member_state).
dora_proportionality_and_simplified_framework_subject(third_party_service_provider).
dora_proportionality_and_simplified_framework_subject(unlisted_entity_type).
dora_proportionality_and_simplified_framework_subject(credit_institution_subject).
dora_proportionality_and_simplified_framework_subject(requested_report_submitted).
dora_proportionality_and_simplified_framework_subject(requested_report_not_submitted).
dora_proportionality_and_simplified_framework_subject(entity_type_not_given).
dora_proportionality_and_simplified_framework_subject(entity_type_misspelt).
dora_proportionality_and_simplified_framework_subject(entity_type_given_twice).

duty_attributes(FrameworkValue, [attribute(simplified_framework_in_place_and_maintained, FrameworkValue), attribute(ict_systems_continuously_monitored, true), attribute(ict_risk_impact_minimised_with_sound_systems, true), attribute(risk_sources_detected_and_incidents_handled, true), attribute(key_ict_third_party_dependencies_identified, true), attribute(continuity_of_critical_functions_ensured, true), attribute(plans_and_controls_tested_regularly, true), attribute(test_and_incident_conclusions_implemented, true), attribute(awareness_and_training_programmes_developed, true), attribute(simplified_framework_documented_and_reviewed, true), attribute(simplified_framework_continuously_improved, true)]).

subject_profile(QualificationAttributes, ReportAttributes, FrameworkValue, Profile) :-
    duty_attributes(FrameworkValue, DutyAttributes),
    append(QualificationAttributes, ReportAttributes, LeadingAttributes),
    append(LeadingAttributes, DutyAttributes, Profile).

no_report_request([attribute(authority_requested_framework_review_report, false)]).

performed_profile(QualificationAttributes, Profile) :-
    no_report_request(ReportAttributes),
    subject_profile(QualificationAttributes, ReportAttributes, true, Profile).

dora_proportionality_and_simplified_framework_profile_for(exempted_payment_institution_all_duties_performed, Profile) :-
    performed_profile([attribute(dora_entity_type, exempted_payment_institution)], Profile).
dora_proportionality_and_simplified_framework_profile_for(exempted_payment_institution_framework_not_performed, Profile) :-
    no_report_request(ReportAttributes),
    subject_profile([attribute(dora_entity_type, exempted_payment_institution)], ReportAttributes, false, Profile).
dora_proportionality_and_simplified_framework_profile_for(exempted_payment_institution_framework_unsure, Profile) :-
    no_report_request(ReportAttributes),
    subject_profile([attribute(dora_entity_type, exempted_payment_institution)], ReportAttributes, unsure, Profile).
dora_proportionality_and_simplified_framework_profile_for(exempted_electronic_money_institution_all_duties_performed, Profile) :-
    performed_profile([attribute(dora_entity_type, exempted_electronic_money_institution)], Profile).
dora_proportionality_and_simplified_framework_profile_for(small_investment_firm_all_duties_performed, Profile) :-
    performed_profile([attribute(dora_entity_type, investment_firm), attribute(investment_firm_is_small_and_non_interconnected, true)], Profile).
dora_proportionality_and_simplified_framework_profile_for(investment_firm_not_small, Profile) :-
    performed_profile([attribute(dora_entity_type, investment_firm), attribute(investment_firm_is_small_and_non_interconnected, false)], Profile).
dora_proportionality_and_simplified_framework_profile_for(occupational_retirement_fifteen_members, Profile) :-
    performed_profile([attribute(dora_entity_type, institution_for_occupational_retirement_provision), attribute(iorp_pension_scheme_members_total, 15)], Profile).
dora_proportionality_and_simplified_framework_profile_for(occupational_retirement_sixteen_members, Profile) :-
    performed_profile([attribute(dora_entity_type, institution_for_occupational_retirement_provision), attribute(iorp_pension_scheme_members_total, 16)], Profile).
dora_proportionality_and_simplified_framework_profile_for(occupational_retirement_ninety_nine_members, Profile) :-
    performed_profile([attribute(dora_entity_type, institution_for_occupational_retirement_provision), attribute(iorp_pension_scheme_members_total, 99)], Profile).
dora_proportionality_and_simplified_framework_profile_for(occupational_retirement_one_hundred_members, Profile) :-
    performed_profile([attribute(dora_entity_type, institution_for_occupational_retirement_provision), attribute(iorp_pension_scheme_members_total, 100)], Profile).
dora_proportionality_and_simplified_framework_profile_for(directive_institution_not_excluded_by_member_state, Profile) :-
    performed_profile([attribute(dora_entity_type, institution_exempted_pursuant_to_directive_2013_36), attribute(exempted_from_dora_scope_by_member_state, false)], Profile).
dora_proportionality_and_simplified_framework_profile_for(directive_institution_excluded_by_member_state, Profile) :-
    performed_profile([attribute(dora_entity_type, institution_exempted_pursuant_to_directive_2013_36), attribute(exempted_from_dora_scope_by_member_state, true)], Profile).
dora_proportionality_and_simplified_framework_profile_for(third_party_service_provider, Profile) :-
    performed_profile([attribute(dora_entity_type, ict_third_party_service_provider)], Profile).
dora_proportionality_and_simplified_framework_profile_for(unlisted_entity_type, Profile) :-
    performed_profile([attribute(dora_entity_type, none_of_the_listed_types)], Profile).
dora_proportionality_and_simplified_framework_profile_for(credit_institution_subject, Profile) :-
    performed_profile([attribute(dora_entity_type, credit_institution)], Profile).
dora_proportionality_and_simplified_framework_profile_for(requested_report_submitted, Profile) :-
    subject_profile([attribute(dora_entity_type, exempted_payment_institution)], [attribute(authority_requested_framework_review_report, true), attribute(simplified_framework_review_report_submitted, true)], true, Profile).
dora_proportionality_and_simplified_framework_profile_for(requested_report_not_submitted, Profile) :-
    subject_profile([attribute(dora_entity_type, exempted_payment_institution)], [attribute(authority_requested_framework_review_report, true), attribute(simplified_framework_review_report_submitted, false)], true, Profile).
dora_proportionality_and_simplified_framework_profile_for(entity_type_not_given, Profile) :-
    performed_profile([], Profile).
dora_proportionality_and_simplified_framework_profile_for(entity_type_misspelt, Profile) :-
    performed_profile([attribute(dora_entity_type, credit_institutions)], Profile).
dora_proportionality_and_simplified_framework_profile_for(entity_type_given_twice, Profile) :-
    performed_profile([attribute(dora_entity_type, exempted_payment_institution), attribute(dora_entity_type, credit_institution)], Profile).

dora_proportionality_and_simplified_framework_assess(Subject, Result) :-
    dora_proportionality_and_simplified_framework_profile_for(Subject, Profile),
    decide_dora_proportionality_and_simplified_framework(Profile, Result).
