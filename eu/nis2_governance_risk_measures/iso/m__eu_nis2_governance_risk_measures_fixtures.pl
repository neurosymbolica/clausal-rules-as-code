% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_nis2_governance_risk_measures_fixtures, [nis2_governance_risk_measures_subject/1, nis2_governance_risk_measures_profile_for/2, nis2_governance_risk_measures_assess/2]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_nis2_governance_risk_measures_nis2_governance_risk_measures, [decide_nis2_governance_risk_measures/2]).

nis2_governance_risk_measures_subject(essential_all_true).
nis2_governance_risk_measures_subject(important_all_false).
nis2_governance_risk_measures_subject(out_of_scope_entity).
nis2_governance_risk_measures_subject(entity_class_absent).
nis2_governance_risk_measures_subject(important_point_j_unsure).
nis2_governance_risk_measures_subject(essential_unknown_key).
nis2_governance_risk_measures_subject(essential_wrong_type).

nis2_governance_risk_measures_profile_for(essential_all_true, [attribute(entity_class, essential_entity), attribute(multi_factor_authentication_and_secured_communications_appropriate, true), attribute(relevant_european_or_international_standards_apply, true), attribute(coordinated_supply_chain_risk_assessment_carried_out, true), attribute(non_compliance_with_the_art_21_2_measures_found, true)]).
nis2_governance_risk_measures_profile_for(important_all_false, [attribute(entity_class, important_entity), attribute(multi_factor_authentication_and_secured_communications_appropriate, false), attribute(relevant_european_or_international_standards_apply, false), attribute(coordinated_supply_chain_risk_assessment_carried_out, false), attribute(non_compliance_with_the_art_21_2_measures_found, false)]).
nis2_governance_risk_measures_profile_for(out_of_scope_entity, [attribute(entity_class, out_of_scope), attribute(multi_factor_authentication_and_secured_communications_appropriate, true), attribute(relevant_european_or_international_standards_apply, true), attribute(coordinated_supply_chain_risk_assessment_carried_out, true), attribute(non_compliance_with_the_art_21_2_measures_found, true)]).
nis2_governance_risk_measures_profile_for(entity_class_absent, [attribute(relevant_european_or_international_standards_apply, true)]).
nis2_governance_risk_measures_profile_for(important_point_j_unsure, [attribute(entity_class, important_entity), attribute(multi_factor_authentication_and_secured_communications_appropriate, unsure)]).
nis2_governance_risk_measures_profile_for(essential_unknown_key, [attribute(entity_class, essential_entity), attribute(surprise, true)]).
nis2_governance_risk_measures_profile_for(essential_wrong_type, [attribute(entity_class, essential_entity), attribute(relevant_european_or_international_standards_apply, unsure)]).

nis2_governance_risk_measures_assess(Subject, Result) :-
    nis2_governance_risk_measures_profile_for(Subject, Profile),
    decide_nis2_governance_risk_measures(Profile, Result).
