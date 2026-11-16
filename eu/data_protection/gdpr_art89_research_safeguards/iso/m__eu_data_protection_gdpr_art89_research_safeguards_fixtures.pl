% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_art89_research_safeguards_fixtures, [gdpr_art89_research_safeguards_subject/1, gdpr_art89_research_safeguards_profile_for/2, gdpr_art89_research_safeguards_assess/2]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_art89_research_safeguards_safeguards_status, [decide_safeguards/2]).

gdpr_art89_research_safeguards_subject(compliant_research).
gdpr_art89_research_safeguards_subject(no_measures).
gdpr_art89_research_safeguards_subject(no_minimisation).
gdpr_art89_research_safeguards_subject(identifiable_and_sufficient).
gdpr_art89_research_safeguards_subject(identifiable_not_sufficient).
gdpr_art89_research_safeguards_subject(inappropriate_safeguards).
gdpr_art89_research_safeguards_subject(measures_and_minimisation_unmet).
gdpr_art89_research_safeguards_subject(purpose_absent).
gdpr_art89_research_safeguards_subject(other_purpose_case).
gdpr_art89_research_safeguards_subject(measures_key_absent).
gdpr_art89_research_safeguards_subject(identification_keys_absent).
gdpr_art89_research_safeguards_subject(sufficiency_unsure).
gdpr_art89_research_safeguards_subject(appropriateness_unsure).
gdpr_art89_research_safeguards_subject(unknown_key_given).
gdpr_art89_research_safeguards_subject(unmet_dominates_absence).
gdpr_art89_research_safeguards_subject(both_judgements_unsure).

gdpr_art89_research_safeguards_profile_for(compliant_research, [attribute(purpose, scientific_research), attribute(technical_organisational_measures_in_place, true), attribute(minimisation_measures_in_place, true), attribute(identifiable_data_processed, false), attribute(safeguards_appropriate, true)]).
gdpr_art89_research_safeguards_profile_for(no_measures, [attribute(purpose, scientific_research), attribute(technical_organisational_measures_in_place, false), attribute(minimisation_measures_in_place, true), attribute(identifiable_data_processed, false), attribute(safeguards_appropriate, true)]).
gdpr_art89_research_safeguards_profile_for(no_minimisation, [attribute(purpose, historical_research), attribute(technical_organisational_measures_in_place, true), attribute(minimisation_measures_in_place, false), attribute(identifiable_data_processed, false), attribute(safeguards_appropriate, true)]).
gdpr_art89_research_safeguards_profile_for(identifiable_and_sufficient, [attribute(purpose, statistical), attribute(technical_organisational_measures_in_place, true), attribute(minimisation_measures_in_place, true), attribute(identifiable_data_processed, true), attribute(non_identifying_processing_sufficient, true), attribute(safeguards_appropriate, true)]).
gdpr_art89_research_safeguards_profile_for(identifiable_not_sufficient, [attribute(purpose, statistical), attribute(technical_organisational_measures_in_place, true), attribute(minimisation_measures_in_place, true), attribute(identifiable_data_processed, true), attribute(non_identifying_processing_sufficient, false), attribute(safeguards_appropriate, true)]).
gdpr_art89_research_safeguards_profile_for(inappropriate_safeguards, [attribute(purpose, archiving_public_interest), attribute(technical_organisational_measures_in_place, true), attribute(minimisation_measures_in_place, true), attribute(identifiable_data_processed, false), attribute(safeguards_appropriate, false)]).
gdpr_art89_research_safeguards_profile_for(measures_and_minimisation_unmet, [attribute(purpose, scientific_research), attribute(technical_organisational_measures_in_place, false), attribute(minimisation_measures_in_place, false), attribute(identifiable_data_processed, false), attribute(safeguards_appropriate, true)]).
gdpr_art89_research_safeguards_profile_for(purpose_absent, [attribute(technical_organisational_measures_in_place, true)]).
gdpr_art89_research_safeguards_profile_for(other_purpose_case, [attribute(purpose, other_purpose), attribute(technical_organisational_measures_in_place, false)]).
gdpr_art89_research_safeguards_profile_for(measures_key_absent, [attribute(purpose, scientific_research), attribute(minimisation_measures_in_place, true), attribute(identifiable_data_processed, false), attribute(safeguards_appropriate, true)]).
gdpr_art89_research_safeguards_profile_for(identification_keys_absent, [attribute(purpose, scientific_research), attribute(technical_organisational_measures_in_place, true), attribute(minimisation_measures_in_place, true), attribute(safeguards_appropriate, true)]).
gdpr_art89_research_safeguards_profile_for(sufficiency_unsure, [attribute(purpose, scientific_research), attribute(technical_organisational_measures_in_place, true), attribute(minimisation_measures_in_place, true), attribute(identifiable_data_processed, true), attribute(non_identifying_processing_sufficient, unsure), attribute(safeguards_appropriate, true)]).
gdpr_art89_research_safeguards_profile_for(appropriateness_unsure, [attribute(purpose, scientific_research), attribute(technical_organisational_measures_in_place, true), attribute(minimisation_measures_in_place, true), attribute(identifiable_data_processed, false), attribute(safeguards_appropriate, unsure)]).
gdpr_art89_research_safeguards_profile_for(unknown_key_given, [attribute(purpose, scientific_research), attribute(extra_note, true)]).
gdpr_art89_research_safeguards_profile_for(unmet_dominates_absence, [attribute(purpose, scientific_research), attribute(technical_organisational_measures_in_place, false), attribute(identifiable_data_processed, false), attribute(safeguards_appropriate, true)]).
gdpr_art89_research_safeguards_profile_for(both_judgements_unsure, [attribute(purpose, scientific_research), attribute(technical_organisational_measures_in_place, true), attribute(minimisation_measures_in_place, true), attribute(identifiable_data_processed, true), attribute(non_identifying_processing_sufficient, unsure), attribute(safeguards_appropriate, unsure)]).

gdpr_art89_research_safeguards_assess(Subject, Verdict) :-
    gdpr_art89_research_safeguards_profile_for(Subject, Profile),
    decide_safeguards(Profile, Verdict).
