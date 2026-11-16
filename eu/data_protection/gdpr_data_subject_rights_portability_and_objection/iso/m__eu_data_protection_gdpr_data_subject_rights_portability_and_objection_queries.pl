% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_data_subject_rights_portability_and_objection_queries, [gdpr_data_subject_rights_portability_and_objection_profile_keys/1, gdpr_data_subject_rights_portability_and_objection_what_if/4, gdpr_data_subject_rights_portability_and_objection_compliance_check/3, gdpr_data_subject_rights_portability_and_objection_justification/2, decide_data_subject_request/2, request_basis/2]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(library(reif), [memberd_t/3]).
:- use_module(formalize_lib, [profile_get/3, profile_lacks/2]).
:- use_module(m__eu_data_protection_gdpr_data_subject_rights_portability_and_objection_kernel, [gdpr_data_subject_rights_portability_and_objection_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_data_subject_rights_portability_and_objection_request_basis, [request_basis_checklist/2]).

gdpr_data_subject_rights_portability_and_objection_profile_keys([request_type, objection_ground_claimed, request_received_on, extension_claimed, controller_demonstrates_unable_to_identify_data_subject, identity_confirmed, personal_data_inaccurate, consent_is_the_basis_of_processing, consent_withdrawn, other_legal_ground_for_processing_exists, objection_under_art21_1_made, objection_under_art21_2_made, collected_in_relation_to_information_society_services_offer, accuracy_contested_by_data_subject, data_subject_opposes_erasure, data_required_by_data_subject_for_legal_claims, verification_of_overriding_grounds_pending, personal_data_provided_by_data_subject, processing_based_on_consent_or_contract, processing_carried_out_by_automated_means, processing_based_on_art6_1_e_or_f, processing_for_direct_marketing, processing_for_research_or_statistics_pursuant_to_art89_1, data_subject_gave_explicit_consent, decision_based_on_special_categories, special_category_condition_and_safeguards_met_for_decision, personal_data_disclosed_to_recipients, data_subject_asks_who_the_recipients_are, extension_necessary_for_complexity_and_number, reasonable_doubts_about_identity, request_manifestly_unfounded_or_excessive, personal_data_incomplete_in_light_of_purposes, data_no_longer_necessary_for_purposes, overriding_legitimate_grounds_exist, personal_data_unlawfully_processed, processing_necessary_for_freedom_of_expression_and_information, processing_necessary_for_public_task_or_official_authority, processing_necessary_for_public_health_in_accordance_with_art9_2_h_and_i, processing_for_archiving_research_or_statistics_in_accordance_with_art89_1, erasure_would_render_impossible_or_seriously_impair_processing_objectives, processing_necessary_for_legal_claims, controller_no_longer_needs_data_for_processing_purposes, transmission_would_adversely_affect_rights_and_freedoms_of_others, objection_grounds_relate_to_particular_situation, controller_demonstrates_compelling_legitimate_grounds, decision_based_solely_on_automated_processing, decision_produces_legal_or_similarly_significant_effects, decision_necessary_for_contract_with_data_subject, recipient_notification_impossible_or_disproportionate_effort, legislative_restriction_applies_to_the_right, erasure_required_by_union_or_member_state_law, processing_required_by_union_or_member_state_law, decision_authorised_by_union_or_member_state_law, public_holidays]).

decide_data_subject_request(Profile, Verdict) :-
    gdpr_data_subject_rights_portability_and_objection_input_problems(Profile, Problems),
    decide_checked(Problems, Profile, Verdict).

decide_checked([Problem|Problems], _, gdpr_data_subject_request_verdict(input_problems([Problem|Problems]), none, none, [], [])).
decide_checked([], Profile, Verdict) :-
    scope_of(Profile, Scope),
    decide_scoped(Scope, Profile, Verdict).

scope_of(Profile, in_scope) :-
    profile_lacks(Profile, request_type).
scope_of(Profile, Scope) :-
    profile_get(Profile, request_type, Type),
    memberd_t(Type, [portability, objection], IsInScope),
    scope_from_truth(IsInScope, Scope).

scope_from_truth(true, in_scope).
scope_from_truth(false, out_of_scope).

decide_scoped(in_scope, Profile, Verdict) :-
    request_basis_verdict(Profile, Verdict).
decide_scoped(out_of_scope, _, gdpr_data_subject_request_verdict(need_not_comply, none, none, [], [])).

request_basis_verdict(Profile, Verdict) :-
    m__eu_data_protection_gdpr_data_subject_rights_portability_and_objection_request_basis : decide_request_basis(Profile, Verdict).

request_basis(Profile, Answer) :-
    gdpr_data_subject_rights_portability_and_objection_input_problems(Profile, Problems),
    basis_checked(Problems, Profile, Answer).

basis_checked([Problem|Problems], _, input_problems([Problem|Problems])).
basis_checked([], Profile, Basis) :-
    decide_data_subject_request(Profile, gdpr_data_subject_request_verdict(_, Basis, _, _, _)).

gdpr_data_subject_rights_portability_and_objection_what_if(Profile, OverriddenKey, NewValue, NewVerdict) :-
    gdpr_data_subject_rights_portability_and_objection_input_problems(Profile, Problems),
    what_if_checked(Problems, Profile, OverriddenKey, NewValue, NewVerdict).

what_if_checked([_|_], Profile, _, _, NewVerdict) :-
    decide_data_subject_request(Profile, NewVerdict).
what_if_checked([], Profile, OverriddenKey, NewValue, NewVerdict) :-
    override_attribute(Profile, OverriddenKey, NewValue, Hypothesis),
    decide_data_subject_request(Hypothesis, NewVerdict).

override_attribute(Profile, Key, Value, [attribute(Key, Value)|Remaining]) :-
    without_key(Profile, Key, Remaining).

without_key([], _, []).
without_key([attribute(StoredKey, StoredValue)|Rest], Key, [attribute(StoredKey, StoredValue)|Remaining]) :-
    dif(StoredKey, Key),
    without_key(Rest, Key, Remaining).
without_key([attribute(StoredKey, _)|Rest], Key, Remaining) :-
    StoredKey = Key,
    without_key(Rest, Key, Remaining).

gdpr_data_subject_rights_portability_and_objection_justification(Profile, Items) :-
    gdpr_data_subject_rights_portability_and_objection_input_problems(Profile, Problems),
    justification_checked(Problems, Profile, Items).

justification_checked([_|_], _, []).
justification_checked([], Profile, Items) :-
    scope_of(Profile, Scope),
    justification_scoped(Scope, Profile, Items).

justification_scoped(in_scope, Profile, Items) :-
    request_basis_checklist(Profile, Items).
justification_scoped(out_of_scope, _, []).

gdpr_data_subject_rights_portability_and_objection_compliance_check(Profile, Action, Standing) :-
    decide_data_subject_request(Profile, gdpr_data_subject_request_verdict(Comply, _, _, _, _)),
    comply_class(Comply, Class),
    action_standing(Class, Action, Standing).

comply_class(must_comply, must_comply).
comply_class(need_not_comply, need_not_comply).
comply_class(indeterminate(_), undetermined).
comply_class(needs_legal_review(_, _), undetermined).
comply_class(suspended(_), undetermined).
comply_class(input_problems(_), undetermined).

action_standing(must_comply, comply_with_request, required).
action_standing(must_comply, refuse_to_act, prohibited).
action_standing(need_not_comply, comply_with_request, permitted).
action_standing(need_not_comply, refuse_to_act, permitted).
action_standing(undetermined, comply_with_request, undetermined).
action_standing(undetermined, refuse_to_act, undetermined).
