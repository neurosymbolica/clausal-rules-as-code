% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_accountability_security_queries, [gdpr_accountability_security_profile_keys/1, gdpr_accountability_security_what_if/4, met/0, not_met/0, not_joint_controllers/0, arrangement_not_required/0, arrangement_in_place/0, arrangement_missing/0, content_requirements_met/0, content_requirements_not_met/0, accountability_demonstrated/0, controller_measures_implemented_and_reviewed/0, data_protection_policies_implemented/0, by_design_measures_implemented/0, by_default_only_necessary_data_processed/0, security_level_appropriate_to_risk/0, authorised_persons_process_only_on_instructions/0, controllers_jointly_determine_purposes_and_means/0, responsibilities_set_by_union_or_member_state_law/0, arrangement_between_controllers_exists/0, arrangement_reflects_roles_and_relationships/0, essence_of_arrangement_made_available/0, by_default_amount_collected_limited_to_necessary/0, by_default_extent_of_processing_limited_to_necessary/0, by_default_storage_period_limited_to_necessary/0, by_default_accessibility_limited_to_necessary/0, by_default_not_accessible_to_indefinite_number_without_intervention/0, accountability/0, controller_measures/0, data_protection_policies/0, data_protection_by_design/0, data_protection_by_default/0, security_of_processing/0, processing_on_instructions/0, accountability_principles/0, security_measures/0, unsure/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_accountability_security_kernel, [gdpr_accountability_security_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_accountability_security_gdpr_accountability_security, [gdpr_accountability_security_status/2]).

gdpr_accountability_security_profile_keys([accountability_demonstrated, controller_measures_implemented_and_reviewed, data_protection_policies_implemented, by_design_measures_implemented, by_default_only_necessary_data_processed, security_level_appropriate_to_risk, authorised_persons_process_only_on_instructions, controllers_jointly_determine_purposes_and_means, responsibilities_set_by_union_or_member_state_law, arrangement_between_controllers_exists, arrangement_reflects_roles_and_relationships, essence_of_arrangement_made_available, by_default_amount_collected_limited_to_necessary, by_default_extent_of_processing_limited_to_necessary, by_default_storage_period_limited_to_necessary, by_default_accessibility_limited_to_necessary, by_default_not_accessible_to_indefinite_number_without_intervention]).

gdpr_accountability_security_what_if(Profile, OverriddenKey, NewValue, NewStatus) :-
    override_attribute(Profile, OverriddenKey, NewValue, Hypothesis),
    gdpr_accountability_security_status(Hypothesis, NewStatus).

override_attribute(Profile, Key, Value, Hypothesis) :-
    remove_key(Profile, Key, Kept),
    append(Kept, [attribute(Key, Value)], Hypothesis).

remove_key([], _, []).
remove_key([Element|Elements], Key, Kept) :-
    nonvar(Element),
    Element = attribute(ElementKey, _),
    ElementKey == Key,
    remove_key(Elements, Key, Kept).
remove_key([Element|Elements], Key, [Element|Kept]) :-
    nonvar(Element),
    Element = attribute(ElementKey, _),
    ElementKey \== Key,
    remove_key(Elements, Key, Kept).
remove_key([Element|Elements], Key, [Element|Kept]) :-
    nonvar(Element),
    Element \= attribute(_, _),
    remove_key(Elements, Key, Kept).
remove_key([Element|Elements], Key, [Element|Kept]) :-
    var(Element),
    remove_key(Elements, Key, Kept).

met.

not_met.

not_joint_controllers.

arrangement_not_required.

arrangement_in_place.

arrangement_missing.

content_requirements_met.

content_requirements_not_met.

accountability_demonstrated.

controller_measures_implemented_and_reviewed.

data_protection_policies_implemented.

by_design_measures_implemented.

by_default_only_necessary_data_processed.

security_level_appropriate_to_risk.

authorised_persons_process_only_on_instructions.

controllers_jointly_determine_purposes_and_means.

responsibilities_set_by_union_or_member_state_law.

arrangement_between_controllers_exists.

arrangement_reflects_roles_and_relationships.

essence_of_arrangement_made_available.

by_default_amount_collected_limited_to_necessary.

by_default_extent_of_processing_limited_to_necessary.

by_default_storage_period_limited_to_necessary.

by_default_accessibility_limited_to_necessary.

by_default_not_accessible_to_indefinite_number_without_intervention.

accountability.

controller_measures.

data_protection_policies.

data_protection_by_design.

data_protection_by_default.

security_of_processing.

processing_on_instructions.

accountability_principles.

security_measures.

unsure.
