% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_binding_corporate_rules_fixtures, [gdpr_binding_corporate_rules_subject/1, gdpr_binding_corporate_rules_profile_for/2, gdpr_binding_corporate_rules_assess/2]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(library(reif), [memberd_t/3]).
:- use_module(m__eu_data_protection_gdpr_binding_corporate_rules_gdpr_binding_corporate_rules, [decide_gdpr_binding_corporate_rules/2]).

gdpr_binding_corporate_rules_subject(all_elements_and_points_hold).
gdpr_binding_corporate_rules_subject(transfers_inside_union_only).
gdpr_binding_corporate_rules_subject(adhering_party_not_established).
gdpr_binding_corporate_rules_subject(false_element_beats_absent_keys).
gdpr_binding_corporate_rules_subject(first_absent_element_named_while_role_unsure).
gdpr_binding_corporate_rules_subject(adhering_party_role_unsure).
gdpr_binding_corporate_rules_subject(adhering_party_role_denied).
gdpr_binding_corporate_rules_subject(recipient_role_unsure).
gdpr_binding_corporate_rules_subject(recipient_role_denied).
gdpr_binding_corporate_rules_subject(group_membership_unsure).
gdpr_binding_corporate_rules_subject(group_membership_denied).
gdpr_binding_corporate_rules_subject(two_judgements_unsure).
gdpr_binding_corporate_rules_subject(principles_point_covered_in_part).
gdpr_binding_corporate_rules_subject(false_point_beats_absent_points).
gdpr_binding_corporate_rules_subject(first_absent_point_named_while_training_unsure).
gdpr_binding_corporate_rules_subject(training_appropriateness_unsure).
gdpr_binding_corporate_rules_subject(training_not_appropriate).
gdpr_binding_corporate_rules_subject(definition_keys_only).
gdpr_binding_corporate_rules_subject(content_keys_only).
gdpr_binding_corporate_rules_subject(empty_profile).
gdpr_binding_corporate_rules_subject(input_well_formed_single_key).
gdpr_binding_corporate_rules_subject(input_crisp_key_unsure).
gdpr_binding_corporate_rules_subject(input_attested_judgement).
gdpr_binding_corporate_rules_subject(input_duplicate_key).
gdpr_binding_corporate_rules_subject(input_unknown_key_twice).
gdpr_binding_corporate_rules_subject(input_not_a_list).
gdpr_binding_corporate_rules_subject(input_element_not_attribute).
gdpr_binding_corporate_rules_subject(input_partial_list).
gdpr_binding_corporate_rules_subject(input_unbound_value).
gdpr_binding_corporate_rules_subject(input_mixed_problems).

built_subject(all_elements_and_points_hold, all, []).
built_subject(transfers_inside_union_only, all, [policies_cover_transfers_to_third_countries - false]).
built_subject(adhering_party_not_established, all, [adhering_party_established_on_territory_of_member_state - false]).
built_subject(false_element_beats_absent_keys, none, [policies_adhered_to_by_adhering_party - false]).
built_subject(first_absent_element_named_while_role_unsure, none, [policies_are_personal_data_protection_policies - true, policies_adhered_to_by_adhering_party - true, adhering_party_is_controller_or_processor - unsure, policies_cover_transfers_to_third_countries - true]).
built_subject(adhering_party_role_unsure, definition, [adhering_party_is_controller_or_processor - unsure]).
built_subject(adhering_party_role_denied, definition, [adhering_party_is_controller_or_processor - false]).
built_subject(recipient_role_unsure, definition, [recipients_are_controllers_or_processors - unsure]).
built_subject(recipient_role_denied, definition, [recipients_are_controllers_or_processors - false]).
built_subject(group_membership_unsure, definition, [transfers_within_group_of_undertakings_or_group_of_enterprises - unsure]).
built_subject(group_membership_denied, definition, [transfers_within_group_of_undertakings_or_group_of_enterprises - false]).
built_subject(two_judgements_unsure, definition, [adhering_party_is_controller_or_processor - unsure, transfers_within_group_of_undertakings_or_group_of_enterprises - unsure]).
built_subject(principles_point_covered_in_part, all, [rules_specify_application_of_general_data_protection_principles - false]).
built_subject(false_point_beats_absent_points, all, [rules_specify_acceptance_of_liability_for_members_outside_union - false, rules_specify_group_structure_and_contact_details - absent, rules_specify_data_transfers - absent]).
built_subject(first_absent_point_named_while_training_unsure, all, [rules_specify_legally_binding_nature - absent, rules_specify_appropriate_data_protection_training - unsure]).
built_subject(training_appropriateness_unsure, all, [rules_specify_appropriate_data_protection_training - unsure]).
built_subject(training_not_appropriate, all, [rules_specify_appropriate_data_protection_training - false]).
built_subject(definition_keys_only, definition, []).
built_subject(content_keys_only, content, []).
built_subject(empty_profile, none, []).
built_subject(input_well_formed_single_key, none, [policies_are_personal_data_protection_policies - true]).

gdpr_binding_corporate_rules_profile_for(Subject, Profile) :-
    built_subject(Subject, Base, Changes),
    profile_from(Base, Changes, Profile).
gdpr_binding_corporate_rules_profile_for(input_crisp_key_unsure, [attribute(policies_are_personal_data_protection_policies, unsure)]).
gdpr_binding_corporate_rules_profile_for(input_attested_judgement, [attribute(adhering_party_is_controller_or_processor, attested(true))]).
gdpr_binding_corporate_rules_profile_for(input_duplicate_key, [attribute(rules_specify_complaint_procedures, true), attribute(rules_specify_complaint_procedures, false)]).
gdpr_binding_corporate_rules_profile_for(input_unknown_key_twice, [attribute(colour, red), attribute(colour, blue)]).
gdpr_binding_corporate_rules_profile_for(input_not_a_list, not_an_attribute_list).
gdpr_binding_corporate_rules_profile_for(input_element_not_attribute, [attribute(policies_are_personal_data_protection_policies, true), foo]).
gdpr_binding_corporate_rules_profile_for(input_partial_list, [attribute(policies_are_personal_data_protection_policies, true)|_Tail]).
gdpr_binding_corporate_rules_profile_for(input_unbound_value, [attribute(rules_specify_complaint_procedures, _Value)]).
gdpr_binding_corporate_rules_profile_for(input_mixed_problems, [attribute(colour, red), attribute(rules_specify_data_transfers, unsure), attribute(policies_are_personal_data_protection_policies, 1), attribute(shade, dark), attribute(adhering_party_is_controller_or_processor, true), attribute(adhering_party_is_controller_or_processor, true)]).

definition_key(policies_are_personal_data_protection_policies).
definition_key(policies_adhered_to_by_adhering_party).
definition_key(adhering_party_is_controller_or_processor).
definition_key(adhering_party_established_on_territory_of_member_state).
definition_key(policies_cover_transfers_to_third_countries).
definition_key(recipients_are_controllers_or_processors).
definition_key(transfers_within_group_of_undertakings_or_group_of_enterprises).

point_key(rules_specify_group_structure_and_contact_details).
point_key(rules_specify_data_transfers).
point_key(rules_specify_legally_binding_nature).
point_key(rules_specify_application_of_general_data_protection_principles).
point_key(rules_specify_data_subject_rights_and_means_to_exercise_them).
point_key(rules_specify_acceptance_of_liability_for_members_outside_union).
point_key(rules_specify_how_information_is_provided_to_data_subjects).
point_key(rules_specify_tasks_of_compliance_monitoring_persons).
point_key(rules_specify_complaint_procedures).
point_key(rules_specify_compliance_verification_mechanisms).
point_key(rules_specify_change_reporting_and_recording_mechanisms).
point_key(rules_specify_cooperation_mechanism_with_supervisory_authority).
point_key(rules_specify_reporting_of_third_country_legal_requirements).
point_key(rules_specify_appropriate_data_protection_training).

base_keys(all, Keys) :-
    findall(Key, definition_key(Key), DefinitionKeys),
    findall(Key, point_key(Key), PointKeys),
    append(DefinitionKeys, PointKeys, Keys).
base_keys(definition, Keys) :-
    findall(Key, definition_key(Key), Keys).
base_keys(content, Keys) :-
    findall(Key, point_key(Key), Keys).
base_keys(none, []).

profile_from(Base, Changes, Profile) :-
    base_keys(all, AllKeys),
    base_keys(Base, BaseKeys),
    build_entries(AllKeys, BaseKeys, Changes, Profile).

build_entries([], _, _, []).
build_entries([Key|Keys], BaseKeys, Changes, Profile) :-
    memberd_t(Key, BaseKeys, InBase),
    default_value(InBase, Default),
    findall(Value, member(Key - Value, Changes), Found),
    chosen_value(Found, Default, Chosen),
    build_entries(Keys, BaseKeys, Changes, Rest),
    add_entry(Chosen, Key, Rest, Profile).

default_value(true, true).
default_value(false, absent).

chosen_value([], Default, Default).
chosen_value([Value], _, Value).

add_entry(absent, _, Rest, Rest).
add_entry(Value, Key, Rest, [attribute(Key, Value)|Rest]) :-
    dif(Value, absent).

gdpr_binding_corporate_rules_assess(Subject, Result) :-
    gdpr_binding_corporate_rules_profile_for(Subject, Profile),
    decide_gdpr_binding_corporate_rules(Profile, Result).

test(every_subject_has_exactly_one_profile) :-
    findall(Subject, gdpr_binding_corporate_rules_subject(Subject), Subjects),
    maplist(one_profile, Subjects).
test(the_full_base_gives_twenty_one_attributes) :-
    gdpr_binding_corporate_rules_profile_for(all_elements_and_points_hold, Profile),
    length(Profile, 21).
test(an_absent_change_drops_its_key) :-
    gdpr_binding_corporate_rules_profile_for(false_point_beats_absent_points, Profile),
    length(Profile, 19).

one_profile(Subject) :-
    findall(Profile, gdpr_binding_corporate_rules_profile_for(Subject, Profile), Profiles),
    length(Profiles, 1).
