% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_data_subject_rights_erasure_basis_queries, [gdpr_data_subject_rights_erasure_basis_profile_keys/1, gdpr_data_subject_rights_erasure_basis_what_if/4, gdpr_data_subject_rights_erasure_basis_justification/2, gdpr_data_subject_rights_erasure_basis_compliance_check/3]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_data_subject_rights_erasure_basis_kernel, [gdpr_data_subject_rights_erasure_basis_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_data_subject_rights_erasure_basis_request_basis, [request_basis/2, request_basis_status/2, request_basis_checklist/2]).

gdpr_data_subject_rights_erasure_basis_profile_keys([request_type, objection_ground_claimed, request_received_on, extension_claimed, controller_demonstrates_unable_to_identify_data_subject, identity_confirmed, personal_data_inaccurate, consent_is_the_basis_of_processing, consent_withdrawn, other_legal_ground_for_processing_exists, objection_under_art21_1_made, objection_under_art21_2_made, collected_in_relation_to_information_society_services_offer, accuracy_contested_by_data_subject, data_subject_opposes_erasure, data_required_by_data_subject_for_legal_claims, verification_of_overriding_grounds_pending, personal_data_provided_by_data_subject, processing_based_on_consent_or_contract, processing_carried_out_by_automated_means, processing_based_on_art6_1_e_or_f, processing_for_direct_marketing, processing_for_research_or_statistics_pursuant_to_art89_1, data_subject_gave_explicit_consent, decision_based_on_special_categories, special_category_condition_and_safeguards_met_for_decision, personal_data_disclosed_to_recipients, data_subject_asks_who_the_recipients_are, extension_necessary_for_complexity_and_number, reasonable_doubts_about_identity, request_manifestly_unfounded_or_excessive, personal_data_incomplete_in_light_of_purposes, data_no_longer_necessary_for_purposes, overriding_legitimate_grounds_exist, personal_data_unlawfully_processed, processing_necessary_for_freedom_of_expression_and_information, processing_necessary_for_public_task_or_official_authority, processing_necessary_for_public_health_in_accordance_with_art9_2_h_and_i, processing_for_archiving_research_or_statistics_in_accordance_with_art89_1, erasure_would_render_impossible_or_seriously_impair_processing_objectives, processing_necessary_for_legal_claims, controller_no_longer_needs_data_for_processing_purposes, transmission_would_adversely_affect_rights_and_freedoms_of_others, objection_grounds_relate_to_particular_situation, controller_demonstrates_compelling_legitimate_grounds, decision_based_solely_on_automated_processing, decision_produces_legal_or_similarly_significant_effects, decision_necessary_for_contract_with_data_subject, recipient_notification_impossible_or_disproportionate_effort, legislative_restriction_applies_to_the_right, erasure_required_by_union_or_member_state_law, processing_required_by_union_or_member_state_law, decision_authorised_by_union_or_member_state_law, public_holidays]).

gdpr_data_subject_rights_erasure_basis_what_if(Profile, OverriddenKey, NewValue, NewStatus) :-
    override_attribute(Profile, OverriddenKey, NewValue, Hypothesis),
    request_basis_status(Hypothesis, NewStatus).

override_attribute([], Key, Value, [attribute(Key, Value)]).
override_attribute([attribute(Key, _)|Attributes], Key, Value, [attribute(Key, Value)|Attributes]).
override_attribute([attribute(OtherKey, OtherValue)|Attributes], Key, Value, [attribute(OtherKey, OtherValue)|NewAttributes]) :-
    dif(OtherKey, Key),
    override_attribute(Attributes, Key, Value, NewAttributes).

gdpr_data_subject_rights_erasure_basis_justification(Profile, Items) :-
    request_basis_checklist(Profile, Items).

gdpr_data_subject_rights_erasure_basis_compliance_check(Profile, retain_data, Result) :-
    request_basis_checklist(Profile, Items),
    checklist_flags(Items, Unusable, Engaged, ExceptionMet, SuspensionMet, Undecided),
    compliance_state(Unusable, Engaged, ExceptionMet, SuspensionMet, Undecided, State),
    retain_result(State, Result).

ground_identifiers([art17_1_a, art17_1_b, art17_1_c, art17_1_d, art17_1_e, art17_1_f]).

exception_identifiers([art17_3_a, art17_3_b, art17_3_c, art17_3_d, art17_3_e, art12_5_manifestly_unfounded_or_excessive, art12_2_unable_to_identify, art23_legislative_restriction]).

checklist_flags(Items, Unusable, Engaged, ExceptionMet, SuspensionMet, Undecided) :-
    ground_identifiers(Grounds),
    exception_identifiers(Exceptions),
    present_flag(Items, [input_check, request_type], _, Unusable),
    present_flag(Items, Grounds, met, GroundsMet),
    present_flag(Items, Grounds, open, GroundsOpen),
    present_flag(Items, Exceptions, met, ExceptionMet),
    present_flag(Items, Exceptions, open, ExceptionsOpen),
    present_flag(Items, [art12_6_identity_not_confirmed], met, SuspensionMet),
    present_flag(Items, [art12_6_identity_not_confirmed], open, SuspensionOpen),
    flag_or(GroundsMet, GroundsOpen, Engaged),
    ground_pending(GroundsMet, GroundsOpen, GroundPending),
    flag_or(ExceptionsOpen, SuspensionOpen, OtherOpen),
    flag_or(GroundPending, OtherOpen, Undecided).

present_flag(Items, Identifiers, Truth, Flag) :-
    findall(Identifier, (member(item(Identifier, Truth, _), Items), member(Identifier, Identifiers)), Found),
    found_flag(Found, Flag).

found_flag([], false).
found_flag([_|_], true).

flag_or(true, _, true).
flag_or(false, Other, Other).

ground_pending(true, _, false).
ground_pending(false, GroundsOpen, GroundsOpen).

compliance_state(true, _, _, _, _, undetermined).
compliance_state(false, false, _, _, _, not_engaged).
compliance_state(false, true, true, _, _, relieved).
compliance_state(false, true, false, true, _, suspended).
compliance_state(false, true, false, false, true, undetermined).
compliance_state(false, true, false, false, false, owed).

retain_result(owed, prohibited).
retain_result(not_engaged, permitted).
retain_result(relieved, permitted).
retain_result(suspended, undetermined).
retain_result(undetermined, undetermined).
