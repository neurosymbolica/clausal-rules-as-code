% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_territorial_material_scope_queries, [gdpr_territorial_material_scope_profile_keys/1, gdpr_territorial_material_scope_what_if/4, gdpr_territorial_material_scope_compliance_check/3, decide_gdpr_scope/2]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_territorial_material_scope_citations, [implements/1]).
:- use_module(m__eu_data_protection_gdpr_territorial_material_scope_kernel, [gdpr_territorial_material_scope_input_problems/2, ordered_members/3, citation_order/1]).
:- use_module(m__eu_data_protection_gdpr_territorial_material_scope_gdpr_applies, [decide_gdpr_applies/2, gdpr_applies_status/2]).
:- use_module(m__eu_data_protection_gdpr_territorial_material_scope_gdpr_scope_ground, [decide_gdpr_scope_ground/2]).
:- use_module(m__eu_data_protection_gdpr_territorial_material_scope_representative_requirement, [decide_representative_requirement/2, representative_requirement_status/2]).

gdpr_territorial_material_scope_profile_keys([personal_data_processed, processing_wholly_or_partly_automated, personal_data_in_filing_system, activity_outside_union_law, member_state_common_foreign_security_activity, processing_by_natural_person, purely_personal_or_household_activity, processing_by_competent_authority, criminal_law_enforcement_purpose, processing_by_union_institution, party_role, established_in_union, processing_in_context_of_establishment_activities, data_subjects_in_union, offering_goods_or_services_to_data_subjects_in_union, monitoring_behaviour_of_data_subjects_in_union, member_state_law_applies_by_public_international_law, public_authority_or_body, occasional_processing, special_or_criminal_data_on_large_scale, unlikely_to_result_in_risk]).

decide_gdpr_scope(Profile, gdpr_scope_verdict(Applies, Ground, Representative, Citations)) :-
    decide_gdpr_applies(Profile, gdpr_applies_verdict(Applies, AppliesCitations)),
    decide_gdpr_scope_ground(Profile, gdpr_scope_ground_verdict(Ground, _GroundCitations)),
    decide_representative_requirement(Profile, representative_requirement_verdict(Representative, RepresentativeCitations)),
    append(AppliesCitations, RepresentativeCitations, Collected),
    citation_order(Order),
    ordered_members(Order, Collected, Citations).

gdpr_territorial_material_scope_compliance_check(Profile, proceed_without_representative, Result) :-
    implements(eu_reg_2016_679_art_27_1),
    representative_requirement_status(Profile, Status),
    compliance_for(Status, Result).

compliance_for(required, not_permitted).
compliance_for(not_applicable, permitted).
compliance_for(exempt_art27_2_a, permitted).
compliance_for(exempt_art27_2_b, permitted).
compliance_for(not_reached, undetermined).
compliance_for(indeterminate(_), undetermined).
compliance_for(needs_legal_review(_, _), undetermined).

gdpr_territorial_material_scope_what_if(Profile, OverriddenKey, NewValue, NewStatus) :-
    override_attribute(Profile, OverriddenKey, NewValue, Hypothesis),
    gdpr_applies_status(Hypothesis, NewStatus).

override_attribute([], Key, Value, [attribute(Key, Value)]).
override_attribute([attribute(Key, _)|Rest], Key, Value, Result) :-
    override_attribute(Rest, Key, Value, Result).
override_attribute([attribute(Other, Existing)|Rest], Key, Value, [attribute(Other, Existing)|Result]) :-
    dif(Other, Key),
    override_attribute(Rest, Key, Value, Result).
