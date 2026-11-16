% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_data_subject_rights_automated_decision_fixtures, [gdpr_data_subject_rights_automated_decision_subject/1, gdpr_data_subject_rights_automated_decision_profile_for/2, gdpr_data_subject_rights_automated_decision_assess/2]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_data_subject_rights_automated_decision_request_basis, [decide_request_basis/2]).

gdpr_data_subject_rights_automated_decision_subject(baseline_must_comply).
gdpr_data_subject_rights_automated_decision_subject(not_solely_automated).
gdpr_data_subject_rights_automated_decision_subject(contract_exception).
gdpr_data_subject_rights_automated_decision_subject(contract_near_miss).
gdpr_data_subject_rights_automated_decision_subject(law_authorised_exception).
gdpr_data_subject_rights_automated_decision_subject(law_authorised_near_miss).
gdpr_data_subject_rights_automated_decision_subject(explicit_consent_exception).
gdpr_data_subject_rights_automated_decision_subject(explicit_consent_near_miss).
gdpr_data_subject_rights_automated_decision_subject(special_categories_bar_blocks_contract).
gdpr_data_subject_rights_automated_decision_subject(special_categories_safeguards_allow_contract).
gdpr_data_subject_rights_automated_decision_subject(special_categories_safeguards_missing).
gdpr_data_subject_rights_automated_decision_subject(manifestly_excessive_fee).
gdpr_data_subject_rights_automated_decision_subject(manifestly_excessive_near_miss).
gdpr_data_subject_rights_automated_decision_subject(unable_to_identify).
gdpr_data_subject_rights_automated_decision_subject(unable_to_identify_near_miss).
gdpr_data_subject_rights_automated_decision_subject(legislative_restriction).
gdpr_data_subject_rights_automated_decision_subject(legislative_restriction_near_miss).
gdpr_data_subject_rights_automated_decision_subject(identity_suspended).
gdpr_data_subject_rights_automated_decision_subject(identity_confirmed_near_miss).
gdpr_data_subject_rights_automated_decision_subject(identity_confirmation_missing).
gdpr_data_subject_rights_automated_decision_subject(solely_unsure_referral).
gdpr_data_subject_rights_automated_decision_subject(manifestly_unsure_referral).
gdpr_data_subject_rights_automated_decision_subject(solely_missing_indeterminate).
gdpr_data_subject_rights_automated_decision_subject(request_type_missing).
gdpr_data_subject_rights_automated_decision_subject(unknown_key_input_problem).
gdpr_data_subject_rights_automated_decision_subject(wrong_type_input_problem).
gdpr_data_subject_rights_automated_decision_subject(exception_order_contract_first).
gdpr_data_subject_rights_automated_decision_subject(not_engaged_beats_exception).
gdpr_data_subject_rights_automated_decision_subject(exception_beats_suspension).

engaged_profile(Extra, [attribute(request_type, automated_decision), attribute(decision_based_solely_on_automated_processing, true), attribute(decision_produces_legal_or_similarly_significant_effects, true)|Extra]).

attested_fact(Value, attested(Value, attestation(decision_layer, date(2026, 11, 1), statute_checked, none))).

gdpr_data_subject_rights_automated_decision_profile_for(baseline_must_comply, Profile) :-
    engaged_profile([], Profile).
gdpr_data_subject_rights_automated_decision_profile_for(not_solely_automated, [attribute(request_type, automated_decision), attribute(decision_based_solely_on_automated_processing, false), attribute(decision_produces_legal_or_similarly_significant_effects, true)]).
gdpr_data_subject_rights_automated_decision_profile_for(contract_exception, Profile) :-
    engaged_profile([attribute(decision_necessary_for_contract_with_data_subject, true)], Profile).
gdpr_data_subject_rights_automated_decision_profile_for(contract_near_miss, Profile) :-
    engaged_profile([attribute(decision_necessary_for_contract_with_data_subject, false)], Profile).
gdpr_data_subject_rights_automated_decision_profile_for(law_authorised_exception, Profile) :-
    attested_fact(true, Fact),
    engaged_profile([attribute(decision_authorised_by_union_or_member_state_law, Fact)], Profile).
gdpr_data_subject_rights_automated_decision_profile_for(law_authorised_near_miss, Profile) :-
    attested_fact(false, Fact),
    engaged_profile([attribute(decision_authorised_by_union_or_member_state_law, Fact)], Profile).
gdpr_data_subject_rights_automated_decision_profile_for(explicit_consent_exception, Profile) :-
    engaged_profile([attribute(data_subject_gave_explicit_consent, true)], Profile).
gdpr_data_subject_rights_automated_decision_profile_for(explicit_consent_near_miss, Profile) :-
    engaged_profile([attribute(data_subject_gave_explicit_consent, false)], Profile).
gdpr_data_subject_rights_automated_decision_profile_for(special_categories_bar_blocks_contract, Profile) :-
    engaged_profile([attribute(decision_necessary_for_contract_with_data_subject, true), attribute(decision_based_on_special_categories, true), attribute(special_category_condition_and_safeguards_met_for_decision, false)], Profile).
gdpr_data_subject_rights_automated_decision_profile_for(special_categories_safeguards_allow_contract, Profile) :-
    engaged_profile([attribute(decision_necessary_for_contract_with_data_subject, true), attribute(decision_based_on_special_categories, true), attribute(special_category_condition_and_safeguards_met_for_decision, true)], Profile).
gdpr_data_subject_rights_automated_decision_profile_for(special_categories_safeguards_missing, Profile) :-
    engaged_profile([attribute(decision_necessary_for_contract_with_data_subject, true), attribute(decision_based_on_special_categories, true)], Profile).
gdpr_data_subject_rights_automated_decision_profile_for(manifestly_excessive_fee, Profile) :-
    engaged_profile([attribute(request_manifestly_unfounded_or_excessive, true)], Profile).
gdpr_data_subject_rights_automated_decision_profile_for(manifestly_excessive_near_miss, Profile) :-
    engaged_profile([attribute(request_manifestly_unfounded_or_excessive, false)], Profile).
gdpr_data_subject_rights_automated_decision_profile_for(unable_to_identify, Profile) :-
    engaged_profile([attribute(controller_demonstrates_unable_to_identify_data_subject, true)], Profile).
gdpr_data_subject_rights_automated_decision_profile_for(unable_to_identify_near_miss, Profile) :-
    engaged_profile([attribute(controller_demonstrates_unable_to_identify_data_subject, false)], Profile).
gdpr_data_subject_rights_automated_decision_profile_for(legislative_restriction, Profile) :-
    attested_fact(true, Fact),
    engaged_profile([attribute(legislative_restriction_applies_to_the_right, Fact)], Profile).
gdpr_data_subject_rights_automated_decision_profile_for(legislative_restriction_near_miss, Profile) :-
    attested_fact(false, Fact),
    engaged_profile([attribute(legislative_restriction_applies_to_the_right, Fact)], Profile).
gdpr_data_subject_rights_automated_decision_profile_for(identity_suspended, Profile) :-
    engaged_profile([attribute(reasonable_doubts_about_identity, true), attribute(identity_confirmed, false)], Profile).
gdpr_data_subject_rights_automated_decision_profile_for(identity_confirmed_near_miss, Profile) :-
    engaged_profile([attribute(reasonable_doubts_about_identity, true), attribute(identity_confirmed, true)], Profile).
gdpr_data_subject_rights_automated_decision_profile_for(identity_confirmation_missing, Profile) :-
    engaged_profile([attribute(reasonable_doubts_about_identity, true)], Profile).
gdpr_data_subject_rights_automated_decision_profile_for(solely_unsure_referral, [attribute(request_type, automated_decision), attribute(decision_based_solely_on_automated_processing, unsure), attribute(decision_produces_legal_or_similarly_significant_effects, true)]).
gdpr_data_subject_rights_automated_decision_profile_for(manifestly_unsure_referral, Profile) :-
    engaged_profile([attribute(request_manifestly_unfounded_or_excessive, unsure)], Profile).
gdpr_data_subject_rights_automated_decision_profile_for(solely_missing_indeterminate, [attribute(request_type, automated_decision), attribute(decision_produces_legal_or_similarly_significant_effects, true)]).
gdpr_data_subject_rights_automated_decision_profile_for(request_type_missing, []).
gdpr_data_subject_rights_automated_decision_profile_for(unknown_key_input_problem, [attribute(request_type, automated_decision), attribute(bogus_key, true)]).
gdpr_data_subject_rights_automated_decision_profile_for(wrong_type_input_problem, [attribute(request_type, automated_decision), attribute(decision_based_solely_on_automated_processing, maybe)]).
gdpr_data_subject_rights_automated_decision_profile_for(exception_order_contract_first, Profile) :-
    engaged_profile([attribute(decision_necessary_for_contract_with_data_subject, true), attribute(data_subject_gave_explicit_consent, true), attribute(request_manifestly_unfounded_or_excessive, true)], Profile).
gdpr_data_subject_rights_automated_decision_profile_for(not_engaged_beats_exception, [attribute(request_type, automated_decision), attribute(decision_based_solely_on_automated_processing, true), attribute(decision_produces_legal_or_similarly_significant_effects, false), attribute(request_manifestly_unfounded_or_excessive, true)]).
gdpr_data_subject_rights_automated_decision_profile_for(exception_beats_suspension, Profile) :-
    engaged_profile([attribute(reasonable_doubts_about_identity, true), attribute(identity_confirmed, false), attribute(data_subject_gave_explicit_consent, true)], Profile).

gdpr_data_subject_rights_automated_decision_assess(Subject, Result) :-
    gdpr_data_subject_rights_automated_decision_profile_for(Subject, Profile),
    decide_request_basis(Profile, Result).
