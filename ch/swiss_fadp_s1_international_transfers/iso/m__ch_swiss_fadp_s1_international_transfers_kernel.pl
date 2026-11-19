% SPDX-License-Identifier: EUPL-1.2
:- module(m__ch_swiss_fadp_s1_international_transfers_kernel, [swiss_fadp_s1_international_transfers_input_problems/2, profile_key/3, key_state/3, inputs_relied_on_pairs/4]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(library(reif), [(=)/3]).
:- use_module(library(reif), [memberd_t/3, if_/3]).
:- use_module(formalize_lib, [profile_get/3, profile_has/2, profile_lacks/2]).

profile_key(1, federal_council_adequacy_listing_covers_disclosure, outside_fact).
profile_key(2, international_treaty_ensures_suitable_protection, judgement).
profile_key(3, contract_clauses_ensure_suitable_protection, judgement).
profile_key(4, contract_clauses_notified_to_commissioner_beforehand, crisp).
profile_key(5, specific_guarantees_ensure_suitable_protection, judgement).
profile_key(6, specific_guarantees_notified_to_commissioner_beforehand, crisp).
profile_key(7, standard_clauses_ensure_suitable_protection, judgement).
profile_key(8, standard_clauses_approved_issued_or_recognised_by_commissioner, outside_fact).
profile_key(9, binding_corporate_rules_ensure_suitable_protection, judgement).
profile_key(10, binding_corporate_rules_approved_beforehand, outside_fact).
profile_key(11, code_of_conduct_ensures_suitable_protection, judgement).
profile_key(12, code_of_conduct_submitted_to_commissioner_for_approval_beforehand, crisp).
profile_key(13, code_of_conduct_backed_by_binding_enforceable_commitment, judgement).
profile_key(14, certification_ensures_suitable_protection, judgement).
profile_key(15, certification_backed_by_binding_enforceable_commitment, judgement).
profile_key(16, data_subject_explicitly_consented, judgement).
profile_key(17, disclosure_directly_connected_with_contract_with_data_subject, judgement).
profile_key(18, disclosure_directly_connected_with_contract_in_interest_of_data_subject, judgement).
profile_key(19, disclosure_necessary_for_overriding_public_interest, judgement).
profile_key(20, disclosure_necessary_for_legal_claims_before_court_or_foreign_authority, judgement).
profile_key(21, disclosure_necessary_to_protect_life_or_physical_integrity_and_consent_not_obtainable, judgement).
profile_key(22, data_made_generally_accessible_and_processing_not_expressly_prohibited, judgement).
profile_key(23, data_from_statutory_register_and_inspection_conditions_met, judgement).
profile_key(24, commissioner_requested_information_on_disclosure, crisp).
profile_key(25, commission_adequacy_decision_covers_transfer, outside_fact).
profile_key(26, appropriate_safeguards_provided, judgement).
profile_key(27, enforceable_rights_and_effective_remedies_available, judgement).

key_state(Profile, Key, open_absent) :-
    profile_key(_, Key, _),
    profile_lacks(Profile, Key).
key_state(Profile, Key, State) :-
    profile_key(_, Key, Kind),
    profile_has(Profile, Key),
    profile_get(Profile, Key, Value),
    value_state(Kind, Value, State).

value_state(outside_fact, attested(true, _), true).
value_state(outside_fact, attested(false, _), false).
value_state(judgement, true, true).
value_state(judgement, false, false).
value_state(judgement, unsure, open_unsure).
value_state(crisp, true, true).
value_state(crisp, false, false).

inputs_relied_on_pairs(Profile, ReadKeys, ReferredKey, Pairs) :-
    findall(Key - Kind, profile_key(_, Key, Kind), Rows),
    pairs_from_rows(Rows, Profile, ReadKeys, ReferredKey, Pairs).

pairs_from_rows([], _, _, _, []).
pairs_from_rows([Key - Kind|Rows], Profile, ReadKeys, ReferredKey, Pairs) :-
    memberd_t(Key, ReadKeys, IsRead),
    row_pair(IsRead, Key, Kind, Profile, ReferredKey, Pair),
    pairs_from_rows(Rows, Profile, ReadKeys, ReferredKey, LaterPairs),
    add_pair(Pair, LaterPairs, Pairs).

row_pair(false, _, _, _, _, no_pair).
row_pair(true, Key, Kind, Profile, ReferredKey, Pair) :-
    if_(Key = ReferredKey, Pair = pair(Key - absent), read_pair(Kind, Key, Profile, Pair)).

read_pair(outside_fact, _, _, no_pair).
read_pair(judgement, Key, Profile, Pair) :-
    present_pair(Profile, Key, Pair).
read_pair(crisp, Key, Profile, Pair) :-
    present_pair(Profile, Key, Pair).

present_pair(Profile, Key, no_pair) :-
    profile_lacks(Profile, Key).
present_pair(Profile, Key, pair(Key - Value)) :-
    profile_has(Profile, Key),
    profile_get(Profile, Key, Value).

add_pair(no_pair, Pairs, Pairs).
add_pair(pair(Pair), Pairs, [Pair|Pairs]).

swiss_fadp_s1_international_transfers_input_problems(Profile, Problems) :-
    attribute_list_t(Profile, IsAttributeList),
    profile_problems(IsAttributeList, Profile, Problems).

profile_problems(false, _, [wrong_type(profile)]).
profile_problems(true, Profile, Problems) :-
    Keys = [federal_council_adequacy_listing_covers_disclosure, international_treaty_ensures_suitable_protection, contract_clauses_ensure_suitable_protection, contract_clauses_notified_to_commissioner_beforehand, specific_guarantees_ensure_suitable_protection, specific_guarantees_notified_to_commissioner_beforehand, standard_clauses_ensure_suitable_protection, standard_clauses_approved_issued_or_recognised_by_commissioner, binding_corporate_rules_ensure_suitable_protection, binding_corporate_rules_approved_beforehand, code_of_conduct_ensures_suitable_protection, code_of_conduct_submitted_to_commissioner_for_approval_beforehand, code_of_conduct_backed_by_binding_enforceable_commitment, certification_ensures_suitable_protection, certification_backed_by_binding_enforceable_commitment, data_subject_explicitly_consented, disclosure_directly_connected_with_contract_with_data_subject, disclosure_directly_connected_with_contract_in_interest_of_data_subject, disclosure_necessary_for_overriding_public_interest, disclosure_necessary_for_legal_claims_before_court_or_foreign_authority, disclosure_necessary_to_protect_life_or_physical_integrity_and_consent_not_obtainable, data_made_generally_accessible_and_processing_not_expressly_prohibited, data_from_statutory_register_and_inspection_conditions_met, commissioner_requested_information_on_disclosure, commission_adequacy_decision_covers_transfer, appropriate_safeguards_provided, enforceable_rights_and_effective_remedies_available],
    unknown_keys(Profile, Keys, UnknownKeyProblems),
    key_problems(Keys, Profile, UnknownKeyProblems, Problems).

key_type(federal_council_adequacy_listing_covers_disclosure, outside_fact).
key_type(international_treaty_ensures_suitable_protection, judgement).
key_type(contract_clauses_ensure_suitable_protection, judgement).
key_type(contract_clauses_notified_to_commissioner_beforehand, boolean).
key_type(specific_guarantees_ensure_suitable_protection, judgement).
key_type(specific_guarantees_notified_to_commissioner_beforehand, boolean).
key_type(standard_clauses_ensure_suitable_protection, judgement).
key_type(standard_clauses_approved_issued_or_recognised_by_commissioner, outside_fact).
key_type(binding_corporate_rules_ensure_suitable_protection, judgement).
key_type(binding_corporate_rules_approved_beforehand, outside_fact).
key_type(code_of_conduct_ensures_suitable_protection, judgement).
key_type(code_of_conduct_submitted_to_commissioner_for_approval_beforehand, boolean).
key_type(code_of_conduct_backed_by_binding_enforceable_commitment, judgement).
key_type(certification_ensures_suitable_protection, judgement).
key_type(certification_backed_by_binding_enforceable_commitment, judgement).
key_type(data_subject_explicitly_consented, judgement).
key_type(disclosure_directly_connected_with_contract_with_data_subject, judgement).
key_type(disclosure_directly_connected_with_contract_in_interest_of_data_subject, judgement).
key_type(disclosure_necessary_for_overriding_public_interest, judgement).
key_type(disclosure_necessary_for_legal_claims_before_court_or_foreign_authority, judgement).
key_type(disclosure_necessary_to_protect_life_or_physical_integrity_and_consent_not_obtainable, judgement).
key_type(data_made_generally_accessible_and_processing_not_expressly_prohibited, judgement).
key_type(data_from_statutory_register_and_inspection_conditions_met, judgement).
key_type(commissioner_requested_information_on_disclosure, boolean).
key_type(commission_adequacy_decision_covers_transfer, outside_fact).
key_type(appropriate_safeguards_provided, judgement).
key_type(enforceable_rights_and_effective_remedies_available, judgement).

attribute_list_t(Term, false) :-
    var(Term).
attribute_list_t(Term, true) :-
    Term == [].
attribute_list_t(Term, T) :-
    nonvar(Term),
    Term = [Element|Elements],
    attribute_t(Element, ElementIsAttribute),
    attribute_list_t(Elements, ElementsAreAttributes),
    truth_and(ElementIsAttribute, ElementsAreAttributes, T).
attribute_list_t(Term, false) :-
    nonvar(Term),
    Term \== [],
    Term \= [_|_].

attribute_t(Element, false) :-
    var(Element).
attribute_t(Element, true) :-
    nonvar(Element),
    Element = attribute(_, _).
attribute_t(Element, false) :-
    nonvar(Element),
    Element \= attribute(_, _).

unknown_keys([], _, []).
unknown_keys([attribute(Key, _)|Elements], Known, Problems) :-
    known_t(Key, Known, IsKnown),
    name_unknown_key(IsKnown, Key, Known, Elements, Problems).

known_t(_, [], false).
known_t(Key, [Known|_], true) :-
    Known == Key.
known_t(Key, [Known|Knowns], T) :-
    Known \== Key,
    known_t(Key, Knowns, T).

name_unknown_key(true, _, Known, Elements, Problems) :-
    unknown_keys(Elements, Known, Problems).
name_unknown_key(false, Key, Known, Elements, [unknown_key(Key)|Problems]) :-
    unknown_keys(Elements, [Key|Known], Problems).

key_problems([], _, Problems, Problems).
key_problems([Key|Keys], Profile, LaterProblems, Problems) :-
    key_type(Key, Type),
    key_occurrences(Profile, Key, Occurrences),
    key_problems(Keys, Profile, LaterProblems, KeyProblems),
    name_key_problem(Occurrences, Key, Type, Profile, KeyProblems, Problems).

key_occurrences([], _, none).
key_occurrences([attribute(ElementKey, _)|Elements], Key, Occurrences) :-
    ElementKey == Key,
    key_occurrences(Elements, Key, RestOccurrences),
    one_more_occurrence(RestOccurrences, Occurrences).
key_occurrences([attribute(ElementKey, _)|Elements], Key, Occurrences) :-
    ElementKey \== Key,
    key_occurrences(Elements, Key, Occurrences).

one_more_occurrence(none, one).
one_more_occurrence(one, many).
one_more_occurrence(many, many).

name_key_problem(none, _, _, _, Problems, Problems).
name_key_problem(many, Key, _, _, Problems, [duplicate_key(Key)|Problems]).
name_key_problem(one, Key, Type, Profile, KeyProblems, Problems) :-
    values_in_type_t(Profile, Key, Type, InType),
    name_wrong_type(InType, Key, KeyProblems, Problems).

name_wrong_type(true, _, Problems, Problems).
name_wrong_type(false, Key, Problems, [wrong_type(Key)|Problems]).

values_in_type_t([], _, _, true).
values_in_type_t([attribute(ElementKey, Value)|Elements], Key, Type, T) :-
    ElementKey == Key,
    value_in_type_t(Type, Value, ValueInType),
    values_in_type_t(Elements, Key, Type, RestInType),
    truth_and(ValueInType, RestInType, T).
values_in_type_t([attribute(ElementKey, _)|Elements], Key, Type, T) :-
    ElementKey \== Key,
    values_in_type_t(Elements, Key, Type, T).

value_in_type_t(Type, Value, T) :-
    term_variables(Value, Variables),
    ground_value_in_type_t(Variables, Type, Value, T).

ground_value_in_type_t([_|_], _, _, false).
ground_value_in_type_t([], Type, Value, T) :-
    in_type_t(Type, Value, T).

in_type_t(outside_fact, Value, T) :-
    in_type_t(attested(boolean), Value, T).
in_type_t(judgement, Value, T) :-
    in_type_t(one_of([boolean, enum([unsure])]), Value, T).
in_type_t(boolean, Value, T) :-
    memberd_t(Value, [true, false], T).
in_type_t(enum(Values), Value, T) :-
    memberd_t(Value, Values, T).
in_type_t(one_of(Types), Value, T) :-
    in_some_type_t(Types, Value, T).
in_type_t(attested(Type), Value, T) :-
    attested_t(Value, Type, T).

truth_and(true, T, T).
truth_and(false, _, false).

in_some_type_t([], _, false).
in_some_type_t([Type|Types], Value, T) :-
    in_type_t(Type, Value, InType),
    in_some_type_t(Types, Value, InAnother),
    truth_or(InType, InAnother, T).

truth_or(true, _, true).
truth_or(false, T, T).

attested_t(attested(AttestedValue, Attestation), Type, T) :-
    attestation_t(Attestation, IsAttestation),
    attested_value_t(IsAttestation, Type, AttestedValue, T).
attested_t(Value, _, false) :-
    Value \= attested(_, _).

attestation_t(attestation(_, _, _, _), true).
attestation_t(Value, false) :-
    Value \= attestation(_, _, _, _).

attested_value_t(false, _, _, false).
attested_value_t(true, Type, AttestedValue, T) :-
    in_type_t(Type, AttestedValue, T).

test(the_contract_has_twenty_seven_keys) :-
    findall(Key, profile_key(_, Key, _), Keys),
    length(Keys, 27).
test(an_absent_key_is_open_absent) :-
    key_state([], data_subject_explicitly_consented, open_absent).
test(an_unsure_judgement_is_open_unsure) :-
    key_state([attribute(data_subject_explicitly_consented, unsure)], data_subject_explicitly_consented, open_unsure).
test(an_attested_false_outside_fact_is_false) :-
    key_state([attribute(federal_council_adequacy_listing_covers_disclosure, attested(false, attestation(by, at, reason, none)))], federal_council_adequacy_listing_covers_disclosure, false).
test(a_key_state_has_one_solution) :-
    findall(State, key_state([attribute(commissioner_requested_information_on_disclosure, true)], commissioner_requested_information_on_disclosure, State), States),
    States == [true].
test(pairs_follow_contract_order_and_name_the_referred_fact) :-
    inputs_relied_on_pairs([attribute(enforceable_rights_and_effective_remedies_available, unsure), attribute(appropriate_safeguards_provided, true)], [commission_adequacy_decision_covers_transfer, appropriate_safeguards_provided, enforceable_rights_and_effective_remedies_available], commission_adequacy_decision_covers_transfer, Pairs),
    Pairs == [commission_adequacy_decision_covers_transfer - absent, appropriate_safeguards_provided - true, enforceable_rights_and_effective_remedies_available - unsure].
test(a_present_outside_fact_is_not_a_pair) :-
    inputs_relied_on_pairs([attribute(commission_adequacy_decision_covers_transfer, attested(false, attestation(by, at, reason, none))), attribute(appropriate_safeguards_provided, unsure)], [commission_adequacy_decision_covers_transfer, appropriate_safeguards_provided, enforceable_rights_and_effective_remedies_available], none, Pairs),
    Pairs == [appropriate_safeguards_provided - unsure].
test(an_unread_key_is_not_a_pair) :-
    inputs_relied_on_pairs([attribute(data_subject_explicitly_consented, true)], [appropriate_safeguards_provided], none, Pairs),
    Pairs == [].
test(a_well_formed_profile_has_no_problem) :-
    swiss_fadp_s1_international_transfers_input_problems([attribute(data_subject_explicitly_consented, unsure), attribute(commission_adequacy_decision_covers_transfer, attested(true, attestation(by, at, reason, none)))], []).
test(problems_come_in_contract_order_then_unknown_keys) :-
    swiss_fadp_s1_international_transfers_input_problems([attribute(stray_key, true), attribute(commissioner_requested_information_on_disclosure, unsure), attribute(international_treaty_ensures_suitable_protection, true), attribute(international_treaty_ensures_suitable_protection, true)], Problems),
    Problems == [duplicate_key(international_treaty_ensures_suitable_protection), wrong_type(commissioner_requested_information_on_disclosure), unknown_key(stray_key)].
test(an_unbound_profile_is_not_an_attribute_list) :-
    swiss_fadp_s1_international_transfers_input_problems(_, [wrong_type(profile)]).
test(a_bare_outside_fact_value_is_wrong_type) :-
    swiss_fadp_s1_international_transfers_input_problems([attribute(federal_council_adequacy_listing_covers_disclosure, true)], [wrong_type(federal_council_adequacy_listing_covers_disclosure)]).

test(an_unsure_judgement_is_not_true, fail) :-
    key_state([attribute(data_subject_explicitly_consented, unsure)], data_subject_explicitly_consented, true).
