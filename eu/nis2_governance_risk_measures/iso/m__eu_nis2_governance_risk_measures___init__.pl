% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_nis2_governance_risk_measures___init__, [root_export/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_nis2_governance_risk_measures_kernel, [nis2_governance_risk_measures_input_problems/2]).
:- use_module(m__eu_nis2_governance_risk_measures_citations, [citation/2, implements/1]).
:- use_module(m__eu_nis2_governance_risk_measures_nis2_governance_risk_measures, [corrective_measures_duty/3, decide_nis2_governance_risk_measures/2, essential_entity/0, important_entity/0, management_body_duties/2, must_take_corrective_measures_without_undue_delay/0, nis2_governance_risk_measures_checklist/2, nis2_governance_risk_measures_decision_resolvable/1, nis2_governance_risk_measures_status/2, nis2_governance_risk_measures_status_values/1, no_corrective_measures_duty/0, out_of_scope/0, proportionality_factors/2, risk_management_measures/2, supply_chain_considerations/2]).
:- use_module(m__eu_nis2_governance_risk_measures_queries, [nis2_governance_risk_measures_profile_keys/1, nis2_governance_risk_measures_what_if/4]).
:- use_module(m__eu_nis2_governance_risk_measures_fixtures, [nis2_governance_risk_measures_assess/2, nis2_governance_risk_measures_profile_for/2, nis2_governance_risk_measures_subject/1]).

root_export(consideration).
root_export(coordinated_supply_chain_risk_assessment_carried_out).
root_export(duplicate_key).
root_export(duty).
root_export(entity_class).
root_export(essential_entity).
root_export(factor).
root_export(important_entity).
root_export(indeterminate).
root_export(input_problems).
root_export(inputs_relied_on).
root_export(measure).
root_export(multi_factor_authentication_and_secured_communications_appropriate).
root_export(must_take_corrective_measures_without_undue_delay).
root_export(needs_legal_review).
root_export(no_corrective_measures_duty).
root_export(non_compliance_with_the_art_21_2_measures_found).
root_export(open_textured).
root_export(out_of_scope).
root_export(provenance).
root_export(relevant_european_or_international_standards_apply).
root_export(unknown_key).
root_export(unsure).
root_export(wrong_type).
