% SPDX-License-Identifier: EUPL-1.2
:- module(m__ch_swiss_fadp_s1_international_transfers_queries, [swiss_fadp_s1_international_transfers_profile_keys/1, swiss_fadp_s1_international_transfers_what_if/4, permitted_by_adequacy_decision/0, permitted_by_safeguards/0, no_adequacy_decision_or_safeguards/0, permitted_by_derogation/0, disclosure_abroad_not_permitted/0, information_of_commissioner_required/0, information_of_commissioner_not_required/0, same/0, differs/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(library(reif), [(=)/3]).
:- use_module(library(reif), [if_/3]).
:- use_module(m__ch_swiss_fadp_s1_international_transfers_kernel, [swiss_fadp_s1_international_transfers_input_problems/2]).
:- use_module(m__ch_swiss_fadp_s1_international_transfers_swiss_fadp_s1_international_transfers, [swiss_fadp_s1_international_transfers_status/2]).

permitted_by_adequacy_decision.

permitted_by_safeguards.

no_adequacy_decision_or_safeguards.

permitted_by_derogation.

disclosure_abroad_not_permitted.

information_of_commissioner_required.

information_of_commissioner_not_required.

same.

differs.

swiss_fadp_s1_international_transfers_profile_keys([federal_council_adequacy_listing_covers_disclosure, international_treaty_ensures_suitable_protection, contract_clauses_ensure_suitable_protection, contract_clauses_notified_to_commissioner_beforehand, specific_guarantees_ensure_suitable_protection, specific_guarantees_notified_to_commissioner_beforehand, standard_clauses_ensure_suitable_protection, standard_clauses_approved_issued_or_recognised_by_commissioner, binding_corporate_rules_ensure_suitable_protection, binding_corporate_rules_approved_beforehand, code_of_conduct_ensures_suitable_protection, code_of_conduct_submitted_to_commissioner_for_approval_beforehand, code_of_conduct_backed_by_binding_enforceable_commitment, certification_ensures_suitable_protection, certification_backed_by_binding_enforceable_commitment, data_subject_explicitly_consented, disclosure_directly_connected_with_contract_with_data_subject, disclosure_directly_connected_with_contract_in_interest_of_data_subject, disclosure_necessary_for_overriding_public_interest, disclosure_necessary_for_legal_claims_before_court_or_foreign_authority, disclosure_necessary_to_protect_life_or_physical_integrity_and_consent_not_obtainable, data_made_generally_accessible_and_processing_not_expressly_prohibited, data_from_statutory_register_and_inspection_conditions_met, commissioner_requested_information_on_disclosure, commission_adequacy_decision_covers_transfer, appropriate_safeguards_provided, enforceable_rights_and_effective_remedies_available]).

swiss_fadp_s1_international_transfers_what_if(Profile, OverriddenKey, NewValue, NewStatus) :-
    swiss_fadp_s1_international_transfers_input_problems(Profile, Problems),
    what_if_status(Problems, Profile, OverriddenKey, NewValue, NewStatus).

what_if_status([_|_], Profile, _, _, NewStatus) :-
    swiss_fadp_s1_international_transfers_status(Profile, NewStatus).
what_if_status([], Profile, OverriddenKey, NewValue, NewStatus) :-
    override_attribute(Profile, OverriddenKey, NewValue, Hypothesis),
    swiss_fadp_s1_international_transfers_status(Hypothesis, NewStatus).

override_attribute(Profile, Key, Value, Hypothesis) :-
    drop_key(Profile, Key, Kept),
    append(Kept, [attribute(Key, Value)], Hypothesis).

drop_key([], _, []).
drop_key([attribute(ElementKey, ElementValue)|Elements], Key, Kept) :-
    if_(ElementKey = Key, Kept = LaterKept, Kept = [attribute(ElementKey, ElementValue)|LaterKept]),
    drop_key(Elements, Key, LaterKept).

test(the_schema_has_twenty_seven_keys) :-
    swiss_fadp_s1_international_transfers_profile_keys(Keys),
    length(Keys, 27).
test(adding_a_finding_permits_by_adequacy) :-
    findall(Status, swiss_fadp_s1_international_transfers_what_if([], federal_council_adequacy_listing_covers_disclosure, attested(true, attestation(by, at, reason, none)), Status), Statuses),
    Statuses == [permitted_by_adequacy_decision].
test(replacing_a_finding_reopens_the_safeguards) :-
    swiss_fadp_s1_international_transfers_what_if([attribute(federal_council_adequacy_listing_covers_disclosure, attested(true, attestation(by, at, reason, none)))], federal_council_adequacy_listing_covers_disclosure, attested(false, attestation(by, at, reason, none)), Status),
    Status == indeterminate([international_treaty_ensures_suitable_protection]).
test(a_malformed_profile_keeps_its_input_problems) :-
    swiss_fadp_s1_international_transfers_what_if(not_a_list, data_subject_explicitly_consented, true, Status),
    Status == input_problems([wrong_type(profile)]).
test(the_result_atoms_are_defined) :-
    permitted_by_adequacy_decision,
    disclosure_abroad_not_permitted,
    same,
    differs.

test(replacing_a_finding_is_not_adequacy, fail) :-
    swiss_fadp_s1_international_transfers_what_if([attribute(federal_council_adequacy_listing_covers_disclosure, attested(true, attestation(by, at, reason, none)))], federal_council_adequacy_listing_covers_disclosure, attested(false, attestation(by, at, reason, none)), permitted_by_adequacy_decision).
