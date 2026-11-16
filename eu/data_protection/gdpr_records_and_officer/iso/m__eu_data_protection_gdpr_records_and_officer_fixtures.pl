% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_records_and_officer_fixtures, [gdpr_records_and_officer_subject/1, gdpr_records_and_officer_profile_for/2, gdpr_records_and_officer_assess/2]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_records_and_officer_gdpr_records_and_officer, [decide_gdpr_records_and_officer/2]).

gdpr_records_and_officer_subject(small_controller_exempt_at_249).
gdpr_records_and_officer_subject(controller_at_ceiling_250).
gdpr_records_and_officer_subject(small_processor_special_categories).
gdpr_records_and_officer_subject(small_processor_without_trigger).
gdpr_records_and_officer_subject(both_roles_large_entity).
gdpr_records_and_officer_subject(neither_role_entity).
gdpr_records_and_officer_subject(controller_role_entity).
gdpr_records_and_officer_subject(unsure_occasional_controller).
gdpr_records_and_officer_subject(not_occasional_controller).
gdpr_records_and_officer_subject(headcount_absent_controller).
gdpr_records_and_officer_subject(public_authority_controller).
gdpr_records_and_officer_subject(court_in_judicial_capacity_controller).
gdpr_records_and_officer_subject(member_state_law_requires_officer).
gdpr_records_and_officer_subject(member_state_law_does_not_require_officer).
gdpr_records_and_officer_subject(officer_mandate_lacks_contact_point).
gdpr_records_and_officer_subject(officer_mandate_complete).
gdpr_records_and_officer_subject(duplicate_headcount_malformed).

fixture_attestation(attestation(fixture_host, fixture_moment, fixture_reason, none)).

small_controller_profile(Persons, [attribute(acts_as_controller, true), attribute(acts_as_processor, false), attribute(persons_employed, Persons), attribute(processing_likely_to_result_in_risk, false), attribute(processing_is_occasional, true), attribute(processing_includes_special_categories, false), attribute(processing_includes_criminal_offence_data, false)]).

small_processor_profile(SpecialCategories, [attribute(acts_as_controller, false), attribute(acts_as_processor, true), attribute(persons_employed, 100), attribute(processing_likely_to_result_in_risk, false), attribute(processing_is_occasional, true), attribute(processing_includes_special_categories, SpecialCategories), attribute(processing_includes_criminal_offence_data, false)]).

occasional_controller_profile(Occasional, [attribute(acts_as_controller, true), attribute(acts_as_processor, false), attribute(persons_employed, 100), attribute(processing_likely_to_result_in_risk, false), attribute(processing_is_occasional, Occasional), attribute(processing_includes_special_categories, false), attribute(processing_includes_criminal_offence_data, false)]).

large_controller_base([attribute(acts_as_controller, true), attribute(acts_as_processor, false), attribute(persons_employed, 300)]).

large_controller_with(Extra, Profile) :-
    large_controller_base(Base),
    append(Base, Extra, Profile).

unmet_limbs_profile(PublicValue, CourtValue, LawValue, Profile) :-
    fixture_attestation(Attestation),
    large_controller_with([attribute(is_public_authority_or_body, attested(PublicValue, Attestation)), attribute(processing_is_by_court_in_judicial_capacity, CourtValue), attribute(monitoring_is_core_activity, false), attribute(processing_includes_special_categories, false), attribute(processing_includes_criminal_offence_data, false), attribute(union_or_member_state_law_requires_data_protection_officer, attested(LawValue, Attestation))], Profile).

officer_tasks_profile(ContactPoint, Profile) :-
    large_controller_with([attribute(officer_tasks_include_informing_and_advising, true), attribute(officer_tasks_include_monitoring_compliance, true), attribute(officer_tasks_include_advising_on_impact_assessment, true), attribute(officer_tasks_include_cooperating_with_supervisory_authority, true), attribute(officer_tasks_include_acting_as_contact_point, ContactPoint)], Profile).

gdpr_records_and_officer_profile_for(small_controller_exempt_at_249, Profile) :-
    small_controller_profile(249, Profile).
gdpr_records_and_officer_profile_for(controller_at_ceiling_250, Profile) :-
    small_controller_profile(250, Profile).
gdpr_records_and_officer_profile_for(small_processor_special_categories, Profile) :-
    small_processor_profile(true, Profile).
gdpr_records_and_officer_profile_for(small_processor_without_trigger, Profile) :-
    small_processor_profile(false, Profile).
gdpr_records_and_officer_profile_for(both_roles_large_entity, [attribute(acts_as_controller, true), attribute(acts_as_processor, true), attribute(persons_employed, 300)]).
gdpr_records_and_officer_profile_for(neither_role_entity, [attribute(acts_as_controller, false), attribute(acts_as_processor, false)]).
gdpr_records_and_officer_profile_for(controller_role_entity, Profile) :-
    large_controller_base(Profile).
gdpr_records_and_officer_profile_for(unsure_occasional_controller, Profile) :-
    occasional_controller_profile(unsure, Profile).
gdpr_records_and_officer_profile_for(not_occasional_controller, Profile) :-
    occasional_controller_profile(false, Profile).
gdpr_records_and_officer_profile_for(headcount_absent_controller, [attribute(acts_as_controller, true), attribute(acts_as_processor, false), attribute(processing_likely_to_result_in_risk, false), attribute(processing_is_occasional, true), attribute(processing_includes_special_categories, false), attribute(processing_includes_criminal_offence_data, false)]).
gdpr_records_and_officer_profile_for(public_authority_controller, Profile) :-
    fixture_attestation(Attestation),
    large_controller_with([attribute(is_public_authority_or_body, attested(true, Attestation)), attribute(processing_is_by_court_in_judicial_capacity, false)], Profile).
gdpr_records_and_officer_profile_for(court_in_judicial_capacity_controller, Profile) :-
    unmet_limbs_profile(true, true, false, Profile).
gdpr_records_and_officer_profile_for(member_state_law_requires_officer, Profile) :-
    fixture_attestation(Attestation),
    large_controller_with([attribute(union_or_member_state_law_requires_data_protection_officer, attested(true, Attestation))], Profile).
gdpr_records_and_officer_profile_for(member_state_law_does_not_require_officer, Profile) :-
    unmet_limbs_profile(false, false, false, Profile).
gdpr_records_and_officer_profile_for(officer_mandate_lacks_contact_point, Profile) :-
    officer_tasks_profile(false, Profile).
gdpr_records_and_officer_profile_for(officer_mandate_complete, Profile) :-
    officer_tasks_profile(true, Profile).
gdpr_records_and_officer_profile_for(duplicate_headcount_malformed, [attribute(acts_as_controller, true), attribute(acts_as_processor, false), attribute(persons_employed, 300), attribute(persons_employed, 300)]).

gdpr_records_and_officer_assess(Subject, Result) :-
    gdpr_records_and_officer_profile_for(Subject, Profile),
    decide_gdpr_records_and_officer(Profile, Result).
