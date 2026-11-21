% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_representation_and_suspension_fixtures, [gdpr_representation_and_suspension_subject/1, gdpr_representation_and_suspension_profile_for/2, gdpr_representation_and_suspension_assess/2]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_representation_and_suspension_gdpr_representation_and_suspension, [decide_gdpr_representation_and_suspension/2]).

subject_query(mandated_complaint_qualified, mandated(lodge_complaint_under_article_77)).
subject_query(mandated_complaint_not_mandated, mandated(lodge_complaint_under_article_77)).
subject_query(mandated_complaint_mandate_missing, mandated(exercise_rights_under_article_78)).
subject_query(mandated_complaint_public_interest_unsure, mandated(exercise_right_under_article_79)).
subject_query(mandated_complaint_public_interest_false, mandated(exercise_right_under_article_79)).
subject_query(mandated_compensation_law_attested, mandated(receive_compensation_under_article_82)).
subject_query(mandated_compensation_law_refused, mandated(receive_compensation_under_article_82)).
subject_query(mandated_compensation_law_absent, mandated(receive_compensation_under_article_82)).
subject_query(mandated_compensation_law_and_mandate_absent, mandated(receive_compensation_under_article_82)).
subject_query(without_mandate_complaint_provided, without_mandate(lodge_complaint_under_article_77)).
subject_query(without_mandate_complaint_not_considered, without_mandate(lodge_complaint_under_article_77)).
subject_query(without_mandate_complaint_law_refused, without_mandate(exercise_rights_under_article_78)).
subject_query(without_mandate_complaint_law_absent, without_mandate(lodge_complaint_under_article_77)).
subject_query(without_mandate_complaint_law_and_view_absent, without_mandate(exercise_right_under_article_79)).
subject_query(without_mandate_compensation_refused, without_mandate(receive_compensation_under_article_82)).
subject_query(without_mandate_activity_unsure, without_mandate(exercise_rights_under_article_78)).
subject_query(court_contact_related, contact).
subject_query(court_contact_without_information, contact).
subject_query(court_contact_information_missing, contact).
subject_query(court_contact_subject_matter_unsure, contact).
subject_query(court_suspension_second_court, suspension).
subject_query(court_suspension_court_first_seized, suspension).
subject_query(court_suspension_first_seized_missing, suspension).
subject_query(court_suspension_subject_matter_unsure, suspension).
subject_query(court_declining_consolidation_permitted, declining).
subject_query(court_declining_consolidation_refused, declining).
subject_query(court_declining_jurisdiction_absent, declining).
subject_query(court_declining_consolidation_absent, declining).
subject_query(court_declining_application_missing, declining).
subject_query(court_declining_not_first_instance, declining).
subject_query(court_declining_subject_matter_unsure, declining).
subject_query(court_declining_incompetent_court, declining).
subject_query(input_unsure_crisp_key, contact).
subject_query(input_duplicate_key, suspension).
subject_query(input_unknown_action, mandated(appeal_to_the_moon)).
subject_query(input_bare_outside_fact, declining).
subject_query(input_unknown_key, contact).

gdpr_representation_and_suspension_subject(Subject) :-
    subject_query(Subject, _).

qualified_body([attribute(body_is_not_for_profit, true), attribute(body_properly_constituted_under_member_state_law, true), attribute(body_statutory_objectives_in_public_interest, true), attribute(body_active_in_protection_of_data_subjects_rights_and_freedoms, true)]).

related_proceedings([attribute(court_is_competent_court, true), attribute(court_has_information_on_proceedings_pending_in_another_member_state, true), attribute(other_proceedings_pending_in_court_of_another_member_state, true), attribute(other_proceedings_concern_same_controller_or_processor, true), attribute(other_proceedings_concern_same_subject_matter, true), attribute(court_is_court_first_seized, false), attribute(other_proceedings_pending_at_first_instance, true), attribute(party_applied_for_court_to_decline_jurisdiction, true)]).

declining_core([attribute(other_proceedings_pending_in_court_of_another_member_state, true), attribute(other_proceedings_concern_same_controller_or_processor, true), attribute(other_proceedings_concern_same_subject_matter, true), attribute(court_is_court_first_seized, false)]).

attested_true_term(attested(true, attestation(host_service, attestation_moment, caller_statement, none))).

attested_false_term(attested(false, attestation(host_service, attestation_moment, caller_statement, none))).

gdpr_representation_and_suspension_profile_for(mandated_complaint_qualified, Profile) :-
    qualified_body(BodyAttributes),
    append(BodyAttributes, [attribute(data_subject_mandated_the_body, true)], Profile).
gdpr_representation_and_suspension_profile_for(mandated_complaint_not_mandated, Profile) :-
    qualified_body(BodyAttributes),
    append(BodyAttributes, [attribute(data_subject_mandated_the_body, false)], Profile).
gdpr_representation_and_suspension_profile_for(mandated_complaint_mandate_missing, Profile) :-
    qualified_body(Profile).
gdpr_representation_and_suspension_profile_for(mandated_complaint_public_interest_unsure, [attribute(body_is_not_for_profit, true), attribute(body_properly_constituted_under_member_state_law, true), attribute(body_statutory_objectives_in_public_interest, unsure), attribute(body_active_in_protection_of_data_subjects_rights_and_freedoms, true), attribute(data_subject_mandated_the_body, true)]).
gdpr_representation_and_suspension_profile_for(mandated_complaint_public_interest_false, [attribute(body_is_not_for_profit, true), attribute(body_properly_constituted_under_member_state_law, true), attribute(body_statutory_objectives_in_public_interest, false), attribute(body_active_in_protection_of_data_subjects_rights_and_freedoms, true), attribute(data_subject_mandated_the_body, true)]).
gdpr_representation_and_suspension_profile_for(mandated_compensation_law_attested, Profile) :-
    qualified_body(BodyAttributes),
    attested_true_term(AttestedTrue),
    append(BodyAttributes, [attribute(data_subject_mandated_the_body, true), attribute(member_state_law_provides_for_mandated_compensation_claims, AttestedTrue)], Profile).
gdpr_representation_and_suspension_profile_for(mandated_compensation_law_refused, Profile) :-
    qualified_body(BodyAttributes),
    attested_false_term(AttestedFalse),
    append(BodyAttributes, [attribute(data_subject_mandated_the_body, true), attribute(member_state_law_provides_for_mandated_compensation_claims, AttestedFalse)], Profile).
gdpr_representation_and_suspension_profile_for(mandated_compensation_law_absent, Profile) :-
    qualified_body(BodyAttributes),
    append(BodyAttributes, [attribute(data_subject_mandated_the_body, true)], Profile).
gdpr_representation_and_suspension_profile_for(mandated_compensation_law_and_mandate_absent, Profile) :-
    qualified_body(Profile).
gdpr_representation_and_suspension_profile_for(without_mandate_complaint_provided, Profile) :-
    qualified_body(BodyAttributes),
    attested_true_term(AttestedTrue),
    append(BodyAttributes, [attribute(member_state_law_provides_for_the_action_without_mandate, AttestedTrue), attribute(body_considers_data_subject_rights_infringed_by_processing, true)], Profile).
gdpr_representation_and_suspension_profile_for(without_mandate_complaint_not_considered, Profile) :-
    qualified_body(BodyAttributes),
    attested_true_term(AttestedTrue),
    append(BodyAttributes, [attribute(member_state_law_provides_for_the_action_without_mandate, AttestedTrue), attribute(body_considers_data_subject_rights_infringed_by_processing, false)], Profile).
gdpr_representation_and_suspension_profile_for(without_mandate_complaint_law_refused, Profile) :-
    qualified_body(BodyAttributes),
    attested_false_term(AttestedFalse),
    append(BodyAttributes, [attribute(member_state_law_provides_for_the_action_without_mandate, AttestedFalse), attribute(body_considers_data_subject_rights_infringed_by_processing, true)], Profile).
gdpr_representation_and_suspension_profile_for(without_mandate_complaint_law_absent, Profile) :-
    qualified_body(BodyAttributes),
    append(BodyAttributes, [attribute(body_considers_data_subject_rights_infringed_by_processing, true)], Profile).
gdpr_representation_and_suspension_profile_for(without_mandate_complaint_law_and_view_absent, Profile) :-
    qualified_body(Profile).
gdpr_representation_and_suspension_profile_for(without_mandate_compensation_refused, Profile) :-
    qualified_body(BodyAttributes),
    attested_true_term(AttestedTrue),
    append(BodyAttributes, [attribute(member_state_law_provides_for_the_action_without_mandate, AttestedTrue), attribute(body_considers_data_subject_rights_infringed_by_processing, true)], Profile).
gdpr_representation_and_suspension_profile_for(without_mandate_activity_unsure, Profile) :-
    attested_true_term(AttestedTrue),
    Profile = [attribute(body_is_not_for_profit, true), attribute(body_properly_constituted_under_member_state_law, true), attribute(body_statutory_objectives_in_public_interest, true), attribute(body_active_in_protection_of_data_subjects_rights_and_freedoms, unsure), attribute(member_state_law_provides_for_the_action_without_mandate, AttestedTrue), attribute(body_considers_data_subject_rights_infringed_by_processing, true)].
gdpr_representation_and_suspension_profile_for(court_contact_related, Profile) :-
    related_proceedings(Profile).
gdpr_representation_and_suspension_profile_for(court_contact_without_information, [attribute(court_is_competent_court, true), attribute(court_has_information_on_proceedings_pending_in_another_member_state, false), attribute(other_proceedings_concern_same_controller_or_processor, true), attribute(other_proceedings_concern_same_subject_matter, true)]).
gdpr_representation_and_suspension_profile_for(court_contact_information_missing, [attribute(court_is_competent_court, true), attribute(other_proceedings_concern_same_controller_or_processor, true), attribute(other_proceedings_concern_same_subject_matter, true)]).
gdpr_representation_and_suspension_profile_for(court_contact_subject_matter_unsure, [attribute(court_is_competent_court, true), attribute(court_has_information_on_proceedings_pending_in_another_member_state, true), attribute(other_proceedings_concern_same_controller_or_processor, true), attribute(other_proceedings_concern_same_subject_matter, unsure)]).
gdpr_representation_and_suspension_profile_for(court_suspension_second_court, Profile) :-
    related_proceedings(Profile).
gdpr_representation_and_suspension_profile_for(court_suspension_court_first_seized, [attribute(court_is_competent_court, true), attribute(other_proceedings_pending_in_court_of_another_member_state, true), attribute(other_proceedings_concern_same_controller_or_processor, true), attribute(other_proceedings_concern_same_subject_matter, true), attribute(court_is_court_first_seized, true)]).
gdpr_representation_and_suspension_profile_for(court_suspension_first_seized_missing, [attribute(court_is_competent_court, true), attribute(other_proceedings_pending_in_court_of_another_member_state, true), attribute(other_proceedings_concern_same_controller_or_processor, true), attribute(other_proceedings_concern_same_subject_matter, true)]).
gdpr_representation_and_suspension_profile_for(court_suspension_subject_matter_unsure, [attribute(court_is_competent_court, true), attribute(other_proceedings_pending_in_court_of_another_member_state, true), attribute(other_proceedings_concern_same_controller_or_processor, true), attribute(other_proceedings_concern_same_subject_matter, unsure), attribute(court_is_court_first_seized, false)]).
gdpr_representation_and_suspension_profile_for(court_declining_consolidation_permitted, Profile) :-
    related_proceedings(RelatedProceedings),
    attested_true_term(AttestedTrue),
    append(RelatedProceedings, [attribute(court_first_seized_has_jurisdiction_over_the_actions, AttestedTrue), attribute(law_of_court_first_seized_permits_consolidation, AttestedTrue)], Profile).
gdpr_representation_and_suspension_profile_for(court_declining_consolidation_refused, Profile) :-
    related_proceedings(RelatedProceedings),
    attested_true_term(AttestedTrue),
    attested_false_term(AttestedFalse),
    append(RelatedProceedings, [attribute(court_first_seized_has_jurisdiction_over_the_actions, AttestedTrue), attribute(law_of_court_first_seized_permits_consolidation, AttestedFalse)], Profile).
gdpr_representation_and_suspension_profile_for(court_declining_jurisdiction_absent, Profile) :-
    related_proceedings(Profile).
gdpr_representation_and_suspension_profile_for(court_declining_consolidation_absent, Profile) :-
    related_proceedings(RelatedProceedings),
    attested_true_term(AttestedTrue),
    append(RelatedProceedings, [attribute(court_first_seized_has_jurisdiction_over_the_actions, AttestedTrue)], Profile).
gdpr_representation_and_suspension_profile_for(court_declining_application_missing, Profile) :-
    declining_core(DecliningCore),
    attested_true_term(AttestedTrue),
    append(DecliningCore, [attribute(other_proceedings_pending_at_first_instance, true), attribute(court_first_seized_has_jurisdiction_over_the_actions, AttestedTrue), attribute(law_of_court_first_seized_permits_consolidation, AttestedTrue)], Profile).
gdpr_representation_and_suspension_profile_for(court_declining_not_first_instance, Profile) :-
    declining_core(DecliningCore),
    attested_true_term(AttestedTrue),
    append(DecliningCore, [attribute(other_proceedings_pending_at_first_instance, false), attribute(party_applied_for_court_to_decline_jurisdiction, true), attribute(court_first_seized_has_jurisdiction_over_the_actions, AttestedTrue), attribute(law_of_court_first_seized_permits_consolidation, AttestedTrue)], Profile).
gdpr_representation_and_suspension_profile_for(court_declining_subject_matter_unsure, Profile) :-
    attested_true_term(AttestedTrue),
    Profile = [attribute(other_proceedings_pending_in_court_of_another_member_state, true), attribute(other_proceedings_concern_same_controller_or_processor, true), attribute(other_proceedings_concern_same_subject_matter, unsure), attribute(court_is_court_first_seized, false), attribute(other_proceedings_pending_at_first_instance, true), attribute(party_applied_for_court_to_decline_jurisdiction, true), attribute(court_first_seized_has_jurisdiction_over_the_actions, AttestedTrue), attribute(law_of_court_first_seized_permits_consolidation, AttestedTrue)].
gdpr_representation_and_suspension_profile_for(court_declining_incompetent_court, Profile) :-
    declining_core(DecliningCore),
    attested_true_term(AttestedTrue),
    append(DecliningCore, [attribute(court_is_competent_court, false), attribute(other_proceedings_pending_at_first_instance, true), attribute(party_applied_for_court_to_decline_jurisdiction, true), attribute(court_first_seized_has_jurisdiction_over_the_actions, AttestedTrue), attribute(law_of_court_first_seized_permits_consolidation, AttestedTrue)], Profile).
gdpr_representation_and_suspension_profile_for(input_unsure_crisp_key, [attribute(court_is_competent_court, unsure)]).
gdpr_representation_and_suspension_profile_for(input_duplicate_key, [attribute(court_is_competent_court, true), attribute(court_is_competent_court, true)]).
gdpr_representation_and_suspension_profile_for(input_unknown_action, Profile) :-
    qualified_body(BodyAttributes),
    append(BodyAttributes, [attribute(data_subject_mandated_the_body, true)], Profile).
gdpr_representation_and_suspension_profile_for(input_bare_outside_fact, [attribute(law_of_court_first_seized_permits_consolidation, true)]).
gdpr_representation_and_suspension_profile_for(input_unknown_key, [attribute(body_is_for_profit, true)]).

request_of(mandated(Action), Profile, mandated_representation(Profile, Action)).
request_of(without_mandate(Action), Profile, representation_without_mandate(Profile, Action)).
request_of(contact, Profile, court_contact_duty(Profile)).
request_of(suspension, Profile, court_suspension_option(Profile)).
request_of(declining, Profile, court_declining_jurisdiction_option(Profile)).

gdpr_representation_and_suspension_assess(Subject, Verdict) :-
    subject_query(Subject, Query),
    gdpr_representation_and_suspension_profile_for(Subject, Profile),
    request_of(Query, Profile, Request),
    decide_gdpr_representation_and_suspension(Request, Verdict).
