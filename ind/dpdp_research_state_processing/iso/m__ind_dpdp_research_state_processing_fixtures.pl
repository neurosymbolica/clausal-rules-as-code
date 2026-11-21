% SPDX-License-Identifier: EUPL-1.2
:- module(m__ind_dpdp_research_state_processing_fixtures, [dpdp_research_state_processing_subject/1, dpdp_research_state_processing_profile_for/2, dpdp_research_state_processing_assess/2]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__ind_dpdp_research_state_processing_dpdp_research_state_processing, [decide_dpdp_research_state_processing/2]).

dpdp_research_state_processing_subject(complete_processing).
dpdp_research_state_processing_subject(reference_day_before_commencement).
dpdp_research_state_processing_subject(reference_day_on_commencement).
dpdp_research_state_processing_subject(reference_day_after_commencement).
dpdp_research_state_processing_subject(section_seventeen_not_in_force).
dpdp_research_state_processing_subject(section_seven_not_in_force).
dpdp_research_state_processing_subject(decision_specific_to_data_principal).
dpdp_research_state_processing_subject(not_research_purpose).
dpdp_research_state_processing_subject(lawful_manner_not_observed).
dpdp_research_state_processing_subject(intimation_not_given).
dpdp_research_state_processing_subject(not_section_seven_b_use).
dpdp_research_state_processing_subject(not_state_or_instrumentality).
dpdp_research_state_processing_subject(purpose_includes_affecting_decision).
dpdp_research_state_processing_subject(research_purpose_unsure).
dpdp_research_state_processing_subject(accountability_unsure).
dpdp_research_state_processing_subject(other_applicable_standards_unsure).
dpdp_research_state_processing_subject(state_use_unsure).
dpdp_research_state_processing_subject(state_use_unsure_with_intimation_not_given).
dpdp_research_state_processing_subject(state_body_unsure).
dpdp_research_state_processing_subject(decision_purpose_unsure).
dpdp_research_state_processing_subject(empty_profile).
dpdp_research_state_processing_subject(reference_date_missing).
dpdp_research_state_processing_subject(lawful_manner_missing_with_research_purpose_unsure).
dpdp_research_state_processing_subject(unknown_key_given).
dpdp_research_state_processing_subject(duplicate_key_given).
dpdp_research_state_processing_subject(february_twenty_ninth_common_year).
dpdp_research_state_processing_subject(february_twenty_ninth_leap_year).
dpdp_research_state_processing_subject(year_zero).
dpdp_research_state_processing_subject(year_ten_thousand).

baseline_profile([attribute(section_7_in_force_on_reference_date, true), attribute(section_17_in_force_on_reference_date, true), attribute(reference_date, date(2027, 6, 1)), attribute(processing_necessary_for_research_archiving_or_statistical_purposes, true), attribute(personal_data_to_be_used_for_decision_specific_to_data_principal, false), attribute(processing_for_section_7_b_use, true), attribute(lawful_manner, true), attribute(limited_to_necessary_personal_data, true), attribute(completeness_accuracy_and_consistency, true), attribute(retention_only_while_required, true), attribute(reasonable_security_safeguards, true), attribute(intimation_to_data_principal, true), attribute(business_contact_for_questions, true), attribute(link_and_means_to_exercise_rights, true), attribute(consistent_with_other_applicable_standards, true), attribute(accountability_for_observance, true), attribute(processing_by_state_or_instrumentality, true), attribute(purpose_includes_decision_affecting_data_principal, false)]).

replaced(Base, Key, Value, [attribute(Key, Value)|Rest]) :-
    select(attribute(Key, _), Base, Rest).

removed(Base, Key, Rest) :-
    select(attribute(Key, _), Base, Rest).

profile_with(Key, Value, Profile) :-
    baseline_profile(Base),
    replaced(Base, Key, Value, Profile).

profile_with_two(FirstKey, FirstValue, SecondKey, SecondValue, Profile) :-
    profile_with(FirstKey, FirstValue, FirstProfile),
    replaced(FirstProfile, SecondKey, SecondValue, Profile).

profile_without(Key, Profile) :-
    baseline_profile(Base),
    removed(Base, Key, Profile).

dpdp_research_state_processing_profile_for(complete_processing, Profile) :-
    baseline_profile(Profile).
dpdp_research_state_processing_profile_for(reference_day_before_commencement, Profile) :-
    profile_with(reference_date, date(2027, 5, 12), Profile).
dpdp_research_state_processing_profile_for(reference_day_on_commencement, Profile) :-
    profile_with(reference_date, date(2027, 5, 13), Profile).
dpdp_research_state_processing_profile_for(reference_day_after_commencement, Profile) :-
    profile_with(reference_date, date(2027, 5, 14), Profile).
dpdp_research_state_processing_profile_for(section_seventeen_not_in_force, Profile) :-
    profile_with(section_17_in_force_on_reference_date, false, Profile).
dpdp_research_state_processing_profile_for(section_seven_not_in_force, Profile) :-
    profile_with(section_7_in_force_on_reference_date, false, Profile).
dpdp_research_state_processing_profile_for(decision_specific_to_data_principal, Profile) :-
    profile_with(personal_data_to_be_used_for_decision_specific_to_data_principal, true, Profile).
dpdp_research_state_processing_profile_for(not_research_purpose, Profile) :-
    profile_with(processing_necessary_for_research_archiving_or_statistical_purposes, false, Profile).
dpdp_research_state_processing_profile_for(lawful_manner_not_observed, Profile) :-
    profile_with(lawful_manner, false, Profile).
dpdp_research_state_processing_profile_for(intimation_not_given, Profile) :-
    profile_with(intimation_to_data_principal, false, Profile).
dpdp_research_state_processing_profile_for(not_section_seven_b_use, Profile) :-
    profile_with(processing_for_section_7_b_use, false, Profile).
dpdp_research_state_processing_profile_for(not_state_or_instrumentality, Profile) :-
    profile_with(processing_by_state_or_instrumentality, false, Profile).
dpdp_research_state_processing_profile_for(purpose_includes_affecting_decision, Profile) :-
    profile_with(purpose_includes_decision_affecting_data_principal, true, Profile).
dpdp_research_state_processing_profile_for(research_purpose_unsure, Profile) :-
    profile_with(processing_necessary_for_research_archiving_or_statistical_purposes, unsure, Profile).
dpdp_research_state_processing_profile_for(accountability_unsure, Profile) :-
    profile_with(accountability_for_observance, unsure, Profile).
dpdp_research_state_processing_profile_for(other_applicable_standards_unsure, Profile) :-
    profile_with(consistent_with_other_applicable_standards, unsure, Profile).
dpdp_research_state_processing_profile_for(state_use_unsure, Profile) :-
    profile_with(processing_for_section_7_b_use, unsure, Profile).
dpdp_research_state_processing_profile_for(state_use_unsure_with_intimation_not_given, Profile) :-
    profile_with_two(processing_for_section_7_b_use, unsure, intimation_to_data_principal, false, Profile).
dpdp_research_state_processing_profile_for(state_body_unsure, Profile) :-
    profile_with(processing_by_state_or_instrumentality, unsure, Profile).
dpdp_research_state_processing_profile_for(decision_purpose_unsure, Profile) :-
    profile_with(purpose_includes_decision_affecting_data_principal, unsure, Profile).
dpdp_research_state_processing_profile_for(empty_profile, []).
dpdp_research_state_processing_profile_for(reference_date_missing, Profile) :-
    profile_without(reference_date, Profile).
dpdp_research_state_processing_profile_for(lawful_manner_missing_with_research_purpose_unsure, Profile) :-
    profile_with(processing_necessary_for_research_archiving_or_statistical_purposes, unsure, UnsureProfile),
    removed(UnsureProfile, lawful_manner, Profile).
dpdp_research_state_processing_profile_for(unknown_key_given, Profile) :-
    baseline_profile(Base),
    append(Base, [attribute(colour, red)], Profile).
dpdp_research_state_processing_profile_for(duplicate_key_given, Profile) :-
    baseline_profile(Base),
    append(Base, [attribute(lawful_manner, true)], Profile).
dpdp_research_state_processing_profile_for(february_twenty_ninth_common_year, Profile) :-
    profile_with(reference_date, date(2027, 2, 29), Profile).
dpdp_research_state_processing_profile_for(february_twenty_ninth_leap_year, Profile) :-
    profile_with(reference_date, date(2028, 2, 29), Profile).
dpdp_research_state_processing_profile_for(year_zero, Profile) :-
    profile_with(reference_date, date(0, 1, 1), Profile).
dpdp_research_state_processing_profile_for(year_ten_thousand, Profile) :-
    profile_with(reference_date, date(10000, 1, 1), Profile).

dpdp_research_state_processing_assess(Subject, Result) :-
    dpdp_research_state_processing_profile_for(Subject, Profile),
    decide_dpdp_research_state_processing(Profile, Result).
