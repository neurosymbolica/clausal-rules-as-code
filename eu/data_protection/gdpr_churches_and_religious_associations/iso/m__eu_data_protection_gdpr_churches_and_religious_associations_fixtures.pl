% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_churches_and_religious_associations_fixtures, [gdpr_churches_and_religious_associations_subject/1, gdpr_churches_and_religious_associations_profile_for/2, gdpr_churches_and_religious_associations_assess/2]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_churches_and_religious_associations_gdpr_churches_and_religious_associations, [decide_gdpr_churches_and_religious_associations/2]).

gdpr_churches_and_religious_associations_subject(rules_continue_authority_not_specific).
gdpr_churches_and_religious_associations_subject(body_not_a_church).
gdpr_churches_and_religious_associations_subject(rules_not_applied_in_a_member_state).
gdpr_churches_and_religious_associations_subject(rules_not_comprehensive).
gdpr_churches_and_religious_associations_subject(rules_not_applied_at_entry_into_force).
gdpr_churches_and_religious_associations_subject(rules_not_brought_into_line).
gdpr_churches_and_religious_associations_subject(specific_authority_fulfils_chapter_vi).
gdpr_churches_and_religious_associations_subject(specific_authority_fails_chapter_vi).
gdpr_churches_and_religious_associations_subject(specific_authority_chapter_vi_not_stated).
gdpr_churches_and_religious_associations_subject(authority_specificity_not_stated).
gdpr_churches_and_religious_associations_subject(entry_into_force_not_attested).
gdpr_churches_and_religious_associations_subject(comprehensive_rules_unsure).
gdpr_churches_and_religious_associations_subject(bringing_into_line_unsure).
gdpr_churches_and_religious_associations_subject(body_status_not_stated).
gdpr_churches_and_religious_associations_subject(chapter_vi_stated_for_authority_not_specific).
gdpr_churches_and_religious_associations_subject(two_conditions_false).
gdpr_churches_and_religious_associations_subject(crisp_key_given_unsure).

entry_attested(Value, attested(Value, attestation(host, moment_of_the_question, statement_of_the_body, none))).

chapter_attested(Value, attested(Value, attestation(host, moment_of_the_question, statement_on_the_authority, none))).

gdpr_churches_and_religious_associations_profile_for(rules_continue_authority_not_specific, Profile) :-
    entry_attested(true, Entry),
    Profile = [attribute(body_is_church_or_religious_association_or_community, true), attribute(rules_applied_in_a_member_state, true), attribute(comprehensive_rules_relating_to_protection_with_regard_to_processing, true), attribute(rules_applied_at_entry_into_force_of_the_regulation, Entry), attribute(rules_brought_into_line_with_the_regulation, true), attribute(supervisory_authority_is_specific, false)].
gdpr_churches_and_religious_associations_profile_for(body_not_a_church, Profile) :-
    entry_attested(true, Entry),
    Profile = [attribute(body_is_church_or_religious_association_or_community, false), attribute(rules_applied_in_a_member_state, true), attribute(comprehensive_rules_relating_to_protection_with_regard_to_processing, true), attribute(rules_applied_at_entry_into_force_of_the_regulation, Entry), attribute(rules_brought_into_line_with_the_regulation, true), attribute(supervisory_authority_is_specific, false)].
gdpr_churches_and_religious_associations_profile_for(rules_not_applied_in_a_member_state, Profile) :-
    entry_attested(true, Entry),
    Profile = [attribute(body_is_church_or_religious_association_or_community, true), attribute(rules_applied_in_a_member_state, false), attribute(comprehensive_rules_relating_to_protection_with_regard_to_processing, true), attribute(rules_applied_at_entry_into_force_of_the_regulation, Entry), attribute(rules_brought_into_line_with_the_regulation, true), attribute(supervisory_authority_is_specific, false)].
gdpr_churches_and_religious_associations_profile_for(rules_not_comprehensive, Profile) :-
    entry_attested(true, Entry),
    Profile = [attribute(body_is_church_or_religious_association_or_community, true), attribute(rules_applied_in_a_member_state, true), attribute(comprehensive_rules_relating_to_protection_with_regard_to_processing, false), attribute(rules_applied_at_entry_into_force_of_the_regulation, Entry), attribute(rules_brought_into_line_with_the_regulation, true), attribute(supervisory_authority_is_specific, false)].
gdpr_churches_and_religious_associations_profile_for(rules_not_applied_at_entry_into_force, Profile) :-
    entry_attested(false, Entry),
    Profile = [attribute(body_is_church_or_religious_association_or_community, true), attribute(rules_applied_in_a_member_state, true), attribute(comprehensive_rules_relating_to_protection_with_regard_to_processing, true), attribute(rules_applied_at_entry_into_force_of_the_regulation, Entry), attribute(rules_brought_into_line_with_the_regulation, true), attribute(supervisory_authority_is_specific, false)].
gdpr_churches_and_religious_associations_profile_for(rules_not_brought_into_line, Profile) :-
    entry_attested(true, Entry),
    Profile = [attribute(body_is_church_or_religious_association_or_community, true), attribute(rules_applied_in_a_member_state, true), attribute(comprehensive_rules_relating_to_protection_with_regard_to_processing, true), attribute(rules_applied_at_entry_into_force_of_the_regulation, Entry), attribute(rules_brought_into_line_with_the_regulation, false), attribute(supervisory_authority_is_specific, false)].
gdpr_churches_and_religious_associations_profile_for(specific_authority_fulfils_chapter_vi, Profile) :-
    entry_attested(true, Entry),
    chapter_attested(true, Chapter),
    Profile = [attribute(body_is_church_or_religious_association_or_community, true), attribute(rules_applied_in_a_member_state, true), attribute(comprehensive_rules_relating_to_protection_with_regard_to_processing, true), attribute(rules_applied_at_entry_into_force_of_the_regulation, Entry), attribute(rules_brought_into_line_with_the_regulation, true), attribute(supervisory_authority_is_specific, true), attribute(specific_authority_fulfils_chapter_vi_conditions, Chapter)].
gdpr_churches_and_religious_associations_profile_for(specific_authority_fails_chapter_vi, Profile) :-
    entry_attested(true, Entry),
    chapter_attested(false, Chapter),
    Profile = [attribute(body_is_church_or_religious_association_or_community, true), attribute(rules_applied_in_a_member_state, true), attribute(comprehensive_rules_relating_to_protection_with_regard_to_processing, true), attribute(rules_applied_at_entry_into_force_of_the_regulation, Entry), attribute(rules_brought_into_line_with_the_regulation, true), attribute(supervisory_authority_is_specific, true), attribute(specific_authority_fulfils_chapter_vi_conditions, Chapter)].
gdpr_churches_and_religious_associations_profile_for(specific_authority_chapter_vi_not_stated, Profile) :-
    entry_attested(true, Entry),
    Profile = [attribute(body_is_church_or_religious_association_or_community, true), attribute(rules_applied_in_a_member_state, true), attribute(comprehensive_rules_relating_to_protection_with_regard_to_processing, true), attribute(rules_applied_at_entry_into_force_of_the_regulation, Entry), attribute(rules_brought_into_line_with_the_regulation, true), attribute(supervisory_authority_is_specific, true)].
gdpr_churches_and_religious_associations_profile_for(authority_specificity_not_stated, Profile) :-
    entry_attested(true, Entry),
    Profile = [attribute(body_is_church_or_religious_association_or_community, true), attribute(rules_applied_in_a_member_state, true), attribute(comprehensive_rules_relating_to_protection_with_regard_to_processing, true), attribute(rules_applied_at_entry_into_force_of_the_regulation, Entry), attribute(rules_brought_into_line_with_the_regulation, true)].
gdpr_churches_and_religious_associations_profile_for(entry_into_force_not_attested, Profile) :-
    Profile = [attribute(body_is_church_or_religious_association_or_community, true), attribute(rules_applied_in_a_member_state, true), attribute(comprehensive_rules_relating_to_protection_with_regard_to_processing, true), attribute(rules_brought_into_line_with_the_regulation, true), attribute(supervisory_authority_is_specific, false)].
gdpr_churches_and_religious_associations_profile_for(comprehensive_rules_unsure, Profile) :-
    entry_attested(true, Entry),
    Profile = [attribute(body_is_church_or_religious_association_or_community, true), attribute(rules_applied_in_a_member_state, true), attribute(comprehensive_rules_relating_to_protection_with_regard_to_processing, unsure), attribute(rules_applied_at_entry_into_force_of_the_regulation, Entry), attribute(rules_brought_into_line_with_the_regulation, true), attribute(supervisory_authority_is_specific, false)].
gdpr_churches_and_religious_associations_profile_for(bringing_into_line_unsure, Profile) :-
    entry_attested(true, Entry),
    Profile = [attribute(body_is_church_or_religious_association_or_community, true), attribute(rules_applied_in_a_member_state, true), attribute(comprehensive_rules_relating_to_protection_with_regard_to_processing, true), attribute(rules_applied_at_entry_into_force_of_the_regulation, Entry), attribute(rules_brought_into_line_with_the_regulation, unsure), attribute(supervisory_authority_is_specific, false)].
gdpr_churches_and_religious_associations_profile_for(body_status_not_stated, Profile) :-
    entry_attested(true, Entry),
    Profile = [attribute(rules_applied_in_a_member_state, true), attribute(comprehensive_rules_relating_to_protection_with_regard_to_processing, true), attribute(rules_applied_at_entry_into_force_of_the_regulation, Entry), attribute(rules_brought_into_line_with_the_regulation, true), attribute(supervisory_authority_is_specific, false)].
gdpr_churches_and_religious_associations_profile_for(chapter_vi_stated_for_authority_not_specific, Profile) :-
    entry_attested(true, Entry),
    chapter_attested(false, Chapter),
    Profile = [attribute(body_is_church_or_religious_association_or_community, true), attribute(rules_applied_in_a_member_state, true), attribute(comprehensive_rules_relating_to_protection_with_regard_to_processing, true), attribute(rules_applied_at_entry_into_force_of_the_regulation, Entry), attribute(rules_brought_into_line_with_the_regulation, true), attribute(supervisory_authority_is_specific, false), attribute(specific_authority_fulfils_chapter_vi_conditions, Chapter)].
gdpr_churches_and_religious_associations_profile_for(two_conditions_false, Profile) :-
    entry_attested(true, Entry),
    Profile = [attribute(body_is_church_or_religious_association_or_community, false), attribute(rules_applied_in_a_member_state, true), attribute(comprehensive_rules_relating_to_protection_with_regard_to_processing, true), attribute(rules_applied_at_entry_into_force_of_the_regulation, Entry), attribute(rules_brought_into_line_with_the_regulation, false), attribute(supervisory_authority_is_specific, false)].
gdpr_churches_and_religious_associations_profile_for(crisp_key_given_unsure, Profile) :-
    entry_attested(true, Entry),
    Profile = [attribute(body_is_church_or_religious_association_or_community, true), attribute(rules_applied_in_a_member_state, unsure), attribute(comprehensive_rules_relating_to_protection_with_regard_to_processing, true), attribute(rules_applied_at_entry_into_force_of_the_regulation, Entry), attribute(rules_brought_into_line_with_the_regulation, true), attribute(supervisory_authority_is_specific, false)].

gdpr_churches_and_religious_associations_assess(Subject, Result) :-
    gdpr_churches_and_religious_associations_profile_for(Subject, Profile),
    decide_gdpr_churches_and_religious_associations(Profile, Result).
