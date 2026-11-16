% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_art89_research_safeguards___init__, [root_export/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_art89_research_safeguards_kernel, [gdpr_art89_research_safeguards_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_art89_research_safeguards_citations, [citation/2, implements/1]).
:- use_module(m__eu_data_protection_gdpr_art89_research_safeguards_safeguards_status, [decide_safeguards/2, decide_safeguards_status/2, safeguards_status/2, safeguards_status_checklist/2, safeguards_status_decision_resolvable/1, safeguards_status_status/2, safeguards_status_status_values/1, unmet_requirements/2]).
:- use_module(m__eu_data_protection_gdpr_art89_research_safeguards_queries, [duplicate_key/1, gdpr_art89_research_safeguards_compliance_check/2, gdpr_art89_research_safeguards_justification/2, gdpr_art89_research_safeguards_profile_keys/1, gdpr_art89_research_safeguards_what_if/4, gdpr_art89_verdict/3, indeterminate/1, input_problems/1, inputs_relied_on/1, needs_legal_review/2, open_textured/2, unknown_key/1, wrong_type/1]).
:- use_module(m__eu_data_protection_gdpr_art89_research_safeguards_fixtures, [gdpr_art89_research_safeguards_assess/2, gdpr_art89_research_safeguards_profile_for/2, gdpr_art89_research_safeguards_subject/1]).

root_export(archiving_public_interest).
root_export(historical_research).
root_export(identifiable_data_processed).
root_export(minimisation_measures_in_place).
root_export(non_identifying_processing_sufficient).
root_export(other_purpose).
root_export(purpose).
root_export(safeguards_appropriate).
root_export(scientific_research).
root_export(statistical).
root_export(technical_organisational_measures_in_place).
root_export(unsure).
