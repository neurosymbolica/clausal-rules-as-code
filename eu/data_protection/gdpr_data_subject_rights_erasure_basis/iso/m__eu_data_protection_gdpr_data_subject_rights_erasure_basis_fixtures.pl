% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_data_subject_rights_erasure_basis_fixtures, [gdpr_data_subject_rights_erasure_basis_subject/1, gdpr_data_subject_rights_erasure_basis_profile_for/2, gdpr_data_subject_rights_erasure_basis_assess/2]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_data_subject_rights_erasure_basis_request_basis, [decide_request_basis/2]).

gdpr_data_subject_rights_erasure_basis_subject(no_ground_engaged).
gdpr_data_subject_rights_erasure_basis_subject(necessity_no_longer).
gdpr_data_subject_rights_erasure_basis_subject(necessity_unsure).
gdpr_data_subject_rights_erasure_basis_subject(consent_withdrawn_no_other_ground).
gdpr_data_subject_rights_erasure_basis_subject(consent_withdrawn_other_ground_exists).
gdpr_data_subject_rights_erasure_basis_subject(objection_21_1_without_overriding).
gdpr_data_subject_rights_erasure_basis_subject(objection_21_1_with_overriding).
gdpr_data_subject_rights_erasure_basis_subject(objection_21_2).
gdpr_data_subject_rights_erasure_basis_subject(unlawfully_processed).
gdpr_data_subject_rights_erasure_basis_subject(law_requires_erasure).
gdpr_data_subject_rights_erasure_basis_subject(law_requires_erasure_unattested).
gdpr_data_subject_rights_erasure_basis_subject(information_society_offer).
gdpr_data_subject_rights_erasure_basis_subject(freedom_of_expression_exception).
gdpr_data_subject_rights_erasure_basis_subject(freedom_of_expression_not_necessary).
gdpr_data_subject_rights_erasure_basis_subject(manifestly_excessive_request).
gdpr_data_subject_rights_erasure_basis_subject(request_not_excessive).
gdpr_data_subject_rights_erasure_basis_subject(identity_doubts_unconfirmed).
gdpr_data_subject_rights_erasure_basis_subject(identity_doubts_confirmed).
gdpr_data_subject_rights_erasure_basis_subject(unable_to_identify).
gdpr_data_subject_rights_erasure_basis_subject(legislative_restriction).
gdpr_data_subject_rights_erasure_basis_subject(request_type_only).
gdpr_data_subject_rights_erasure_basis_subject(unknown_key_present).

gdpr_data_subject_rights_erasure_basis_profile_for(Subject, Profile) :-
    subject_pairs(Subject, Pairs),
    attributes(Pairs, Profile).

attributes([], []).
attributes([Key - Value|Pairs], [attribute(Key, Value)|Attributes]) :-
    attributes(Pairs, Attributes).

attested_value(Truth, attested(Truth, attestation(test_host, date(2026, 11, 9), fixture_attestation, none))).

base_pairs([request_type - erasure, data_no_longer_necessary_for_purposes - false, consent_is_the_basis_of_processing - false, objection_under_art21_1_made - false, objection_under_art21_2_made - false, personal_data_unlawfully_processed - false, erasure_required_by_union_or_member_state_law - Fact, collected_in_relation_to_information_society_services_offer - false]) :-
    attested_value(false, Fact).

replace_pair([Key - _|Pairs], Key, Value, [Key - Value|Pairs]).
replace_pair([OtherKey - OtherValue|Pairs], Key, Value, [OtherKey - OtherValue|NewPairs]) :-
    dif(OtherKey, Key),
    replace_pair(Pairs, Key, Value, NewPairs).

drop_pair([Key - _|Pairs], Key, Pairs).
drop_pair([OtherKey - OtherValue|Pairs], Key, [OtherKey - OtherValue|NewPairs]) :-
    dif(OtherKey, Key),
    drop_pair(Pairs, Key, NewPairs).

subject_pairs(no_ground_engaged, Pairs) :-
    base_pairs(Pairs).
subject_pairs(necessity_no_longer, Pairs) :-
    base_pairs(Base),
    replace_pair(Base, data_no_longer_necessary_for_purposes, true, Pairs).
subject_pairs(necessity_unsure, Pairs) :-
    base_pairs(Base),
    replace_pair(Base, data_no_longer_necessary_for_purposes, unsure, Pairs).
subject_pairs(consent_withdrawn_no_other_ground, [consent_withdrawn - true, other_legal_ground_for_processing_exists - false|Changed]) :-
    base_pairs(Base),
    replace_pair(Base, consent_is_the_basis_of_processing, true, Changed).
subject_pairs(consent_withdrawn_other_ground_exists, [consent_withdrawn - true, other_legal_ground_for_processing_exists - true|Changed]) :-
    base_pairs(Base),
    replace_pair(Base, consent_is_the_basis_of_processing, true, Changed).
subject_pairs(objection_21_1_without_overriding, [overriding_legitimate_grounds_exist - false|Changed]) :-
    base_pairs(Base),
    replace_pair(Base, objection_under_art21_1_made, true, Changed).
subject_pairs(objection_21_1_with_overriding, [overriding_legitimate_grounds_exist - true|Changed]) :-
    base_pairs(Base),
    replace_pair(Base, objection_under_art21_1_made, true, Changed).
subject_pairs(objection_21_2, Pairs) :-
    base_pairs(Base),
    replace_pair(Base, objection_under_art21_2_made, true, Pairs).
subject_pairs(unlawfully_processed, Pairs) :-
    base_pairs(Base),
    replace_pair(Base, personal_data_unlawfully_processed, true, Pairs).
subject_pairs(law_requires_erasure, Pairs) :-
    base_pairs(Base),
    attested_value(true, Fact),
    replace_pair(Base, erasure_required_by_union_or_member_state_law, Fact, Pairs).
subject_pairs(law_requires_erasure_unattested, Pairs) :-
    base_pairs(Base),
    drop_pair(Base, erasure_required_by_union_or_member_state_law, Pairs).
subject_pairs(information_society_offer, Pairs) :-
    base_pairs(Base),
    replace_pair(Base, collected_in_relation_to_information_society_services_offer, true, Pairs).
subject_pairs(freedom_of_expression_exception, [processing_necessary_for_freedom_of_expression_and_information - true|Changed]) :-
    base_pairs(Base),
    replace_pair(Base, data_no_longer_necessary_for_purposes, true, Changed).
subject_pairs(freedom_of_expression_not_necessary, [processing_necessary_for_freedom_of_expression_and_information - false|Changed]) :-
    base_pairs(Base),
    replace_pair(Base, data_no_longer_necessary_for_purposes, true, Changed).
subject_pairs(manifestly_excessive_request, [request_manifestly_unfounded_or_excessive - true|Changed]) :-
    base_pairs(Base),
    replace_pair(Base, data_no_longer_necessary_for_purposes, true, Changed).
subject_pairs(request_not_excessive, [request_manifestly_unfounded_or_excessive - false|Changed]) :-
    base_pairs(Base),
    replace_pair(Base, data_no_longer_necessary_for_purposes, true, Changed).
subject_pairs(identity_doubts_unconfirmed, [reasonable_doubts_about_identity - true, identity_confirmed - false|Changed]) :-
    base_pairs(Base),
    replace_pair(Base, data_no_longer_necessary_for_purposes, true, Changed).
subject_pairs(identity_doubts_confirmed, [reasonable_doubts_about_identity - true, identity_confirmed - true|Changed]) :-
    base_pairs(Base),
    replace_pair(Base, data_no_longer_necessary_for_purposes, true, Changed).
subject_pairs(unable_to_identify, [controller_demonstrates_unable_to_identify_data_subject - true|Changed]) :-
    base_pairs(Base),
    replace_pair(Base, data_no_longer_necessary_for_purposes, true, Changed).
subject_pairs(legislative_restriction, [legislative_restriction_applies_to_the_right - Fact|Changed]) :-
    attested_value(true, Fact),
    base_pairs(Base),
    replace_pair(Base, data_no_longer_necessary_for_purposes, true, Changed).
subject_pairs(request_type_only, [request_type - erasure]).
subject_pairs(unknown_key_present, [no_such_key - true|Changed]) :-
    base_pairs(Base),
    replace_pair(Base, data_no_longer_necessary_for_purposes, true, Changed).

gdpr_data_subject_rights_erasure_basis_assess(Subject, Result) :-
    gdpr_data_subject_rights_erasure_basis_profile_for(Subject, Profile),
    decide_request_basis(Profile, Result).
