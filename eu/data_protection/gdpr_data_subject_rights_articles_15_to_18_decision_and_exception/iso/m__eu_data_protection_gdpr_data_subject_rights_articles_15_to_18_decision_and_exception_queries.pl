% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_data_subject_rights_articles_15_to_18_decision_and_exception_queries, [gdpr_data_subject_rights_articles_15_to_18_decision_and_exception_profile_keys/1, gdpr_data_subject_rights_articles_15_to_18_decision_and_exception_what_if/4, indeterminate/1, needs_legal_review/2, open_textured/2, cross_reference_unresolved/2, resolution/2, inputs_relied_on/1, provenance/2, suspended/1, input_problems/1, unknown_key/1, wrong_type/1, duplicate_key/1, attested/2]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_lists_extra, [is_list/1]).
:- use_module(m__eu_data_protection_gdpr_data_subject_rights_articles_15_to_18_decision_and_exception_kernel, [gdpr_data_subject_rights_articles_15_to_18_decision_and_exception_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_data_subject_rights_articles_15_to_18_decision_and_exception_request_exception, [request_exception_status/2]).

gdpr_data_subject_rights_articles_15_to_18_decision_and_exception_profile_keys([request_type, objection_ground_claimed, request_received_on, extension_claimed, controller_demonstrates_unable_to_identify_data_subject, identity_confirmed, personal_data_inaccurate, consent_is_the_basis_of_processing, consent_withdrawn, other_legal_ground_for_processing_exists, objection_under_art21_1_made, objection_under_art21_2_made, collected_in_relation_to_information_society_services_offer, accuracy_contested_by_data_subject, data_subject_opposes_erasure, data_required_by_data_subject_for_legal_claims, verification_of_overriding_grounds_pending, personal_data_provided_by_data_subject, processing_based_on_consent_or_contract, processing_carried_out_by_automated_means, processing_based_on_art6_1_e_or_f, processing_for_direct_marketing, processing_for_research_or_statistics_pursuant_to_art89_1, data_subject_gave_explicit_consent, decision_based_on_special_categories, special_category_condition_and_safeguards_met_for_decision, personal_data_disclosed_to_recipients, data_subject_asks_who_the_recipients_are, extension_necessary_for_complexity_and_number, reasonable_doubts_about_identity, request_manifestly_unfounded_or_excessive, personal_data_incomplete_in_light_of_purposes, data_no_longer_necessary_for_purposes, overriding_legitimate_grounds_exist, personal_data_unlawfully_processed, processing_necessary_for_freedom_of_expression_and_information, processing_necessary_for_public_task_or_official_authority, processing_necessary_for_public_health_in_accordance_with_art9_2_h_and_i, processing_for_archiving_research_or_statistics_in_accordance_with_art89_1, erasure_would_render_impossible_or_seriously_impair_processing_objectives, processing_necessary_for_legal_claims, controller_no_longer_needs_data_for_processing_purposes, transmission_would_adversely_affect_rights_and_freedoms_of_others, objection_grounds_relate_to_particular_situation, controller_demonstrates_compelling_legitimate_grounds, decision_based_solely_on_automated_processing, decision_produces_legal_or_similarly_significant_effects, decision_necessary_for_contract_with_data_subject, recipient_notification_impossible_or_disproportionate_effort, legislative_restriction_applies_to_the_right, erasure_required_by_union_or_member_state_law, processing_required_by_union_or_member_state_law, decision_authorised_by_union_or_member_state_law, public_holidays]).

gdpr_data_subject_rights_articles_15_to_18_decision_and_exception_what_if(Profile, OverriddenKey, NewValue, NewStatus) :-
    override_attribute(Profile, OverriddenKey, NewValue, Hypothesis),
    request_exception_status(Hypothesis, NewStatus).

override_attribute([], Key, Value, [attribute(Key, Value)]).
override_attribute([attribute(ItemKey, _)|Items], Key, Value, [attribute(Key, Value)|Remaining]) :-
    ItemKey == Key,
    remove_attribute(Items, Key, Remaining).
override_attribute([attribute(ItemKey, ItemValue)|Items], Key, Value, [attribute(ItemKey, ItemValue)|Overridden]) :-
    ItemKey \== Key,
    override_attribute(Items, Key, Value, Overridden).

remove_attribute([], _, []).
remove_attribute([attribute(ItemKey, _)|Items], Key, Remaining) :-
    ItemKey == Key,
    remove_attribute(Items, Key, Remaining).
remove_attribute([attribute(ItemKey, ItemValue)|Items], Key, [attribute(ItemKey, ItemValue)|Remaining]) :-
    ItemKey \== Key,
    remove_attribute(Items, Key, Remaining).

indeterminate([_|_]).

needs_legal_review(Reason, Context) :-
    referral_reason(Reason),
    is_list(Context).

referral_reason(open_textured(_, _)).
referral_reason(cross_reference_unresolved(_, _)).

open_textured(Input, cite(_)) :-
    atom(Input).

cross_reference_unresolved(cite(_), cite(_)).

resolution(cite(_), not_attempted).

inputs_relied_on(Pairs) :-
    is_list(Pairs).

provenance(_, Citations) :-
    is_list(Citations).

suspended(art12_6_identity_not_confirmed).

input_problems([_|_]).

unknown_key(Key) :-
    atom(Key).

wrong_type(Key) :-
    atom(Key).

duplicate_key(Key) :-
    atom(Key).

attested(Value, attestation(_, _, _, _)) :-
    nonvar(Value).

test(the_profile_key_schema_has_fifty_four_keys) :-
    gdpr_data_subject_rights_articles_15_to_18_decision_and_exception_profile_keys(ProfileKeys),
    length(ProfileKeys, 54).
test(what_if_a_manifestly_unfounded_access_request_is_relieved) :-
    findall(Status, gdpr_data_subject_rights_articles_15_to_18_decision_and_exception_what_if([attribute(request_type, access)], request_manifestly_unfounded_or_excessive, true, Status), Statuses),
    Statuses == [need_not_comply].
test(what_if_replaces_a_given_value) :-
    findall(Status, gdpr_data_subject_rights_articles_15_to_18_decision_and_exception_what_if([attribute(request_type, access), attribute(request_manifestly_unfounded_or_excessive, true)], request_manifestly_unfounded_or_excessive, false, Status), Statuses),
    Statuses == [must_comply].
test(what_if_unconfirmed_identity_suspends) :-
    gdpr_data_subject_rights_articles_15_to_18_decision_and_exception_what_if([attribute(request_type, access), attribute(reasonable_doubts_about_identity, true)], identity_confirmed, false, suspended(art12_6_identity_not_confirmed)).
test(what_if_drops_a_duplicate_occurrence) :-
    gdpr_data_subject_rights_articles_15_to_18_decision_and_exception_what_if([attribute(request_type, access), attribute(request_type, access)], request_type, access, must_comply).
test(the_input_check_is_reexported) :-
    gdpr_data_subject_rights_articles_15_to_18_decision_and_exception_input_problems([attribute(request_type, access)], []).
test(the_suspension_reason_is_recognised) :-
    suspended(art12_6_identity_not_confirmed).
test(an_open_textured_referral_is_recognised) :-
    needs_legal_review(open_textured(reasonable_doubts_about_identity, cite(eu_reg_2016_679_art_12_6)), [inputs_relied_on([request_type - access])]).

test(what_if_the_replaced_value_is_not_relieved, fail) :-
    gdpr_data_subject_rights_articles_15_to_18_decision_and_exception_what_if([attribute(request_type, access), attribute(request_manifestly_unfounded_or_excessive, true)], request_manifestly_unfounded_or_excessive, false, need_not_comply).
test(another_suspension_reason_is_refused, fail) :-
    suspended(identity_confirmed).
test(an_empty_missing_key_list_is_refused, fail) :-
    indeterminate([]).
