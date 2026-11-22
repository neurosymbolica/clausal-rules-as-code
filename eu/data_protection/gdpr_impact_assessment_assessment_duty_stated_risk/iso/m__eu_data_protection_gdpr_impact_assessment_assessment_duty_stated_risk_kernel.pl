% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_impact_assessment_assessment_duty_stated_risk_kernel, [gdpr_impact_assessment_assessment_duty_stated_risk_input_problems/2, strong_and/2, strong_or/2, strong_not/2, leaf_crisp/3, leaf_judgement/3, leaf_outside_blocking/3, leaf_outside_enabling/3]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(formalize_lib, [profile_get/3, profile_has/2, profile_lacks/2]).

gdpr_impact_assessment_assessment_duty_stated_risk_input_problems(Profile, Problems) :-
    attribute_list_t(Profile, IsAttributeList),
    profile_problems(IsAttributeList, Profile, Problems).

profile_problems(false, _, [wrong_type(profile)]).
profile_problems(true, Profile, Problems) :-
    ContractKeys = [assessment_indicates_high_risk_absent_mitigation, automated_evaluation_including_profiling, criminal_offence_data_processed, data_protection_officer_advice_sought, data_protection_officer_designated, datasets_matched_or_combined, decisions_based_on_evaluation, decisions_produce_legal_effects, decisions_similarly_significantly_affect, description_of_processing_and_purposes_present, envisaged_measures_described, highly_personal_data_processed, impact_assessment_carried_out, lawful_basis_is_legal_obligation_or_public_task, legal_basis_with_general_impact_assessment, legitimate_interest_described, legitimate_interest_pursued, likely_high_risk_to_rights_and_freedoms, measures_reduce_residual_risk_below_high, member_state_requires_assessment_despite_general_one, member_state_requires_prior_authorisation, mitigating_measures_taken, monitoring_is_systematic, national_list_exempts_assessment, national_list_exempts_item, national_list_requires_assessment, national_list_requires_item, necessity_and_proportionality_assessed, processing_for_public_interest_task, processing_on_large_scale, processing_prevents_exercise_of_right_or_service, publicly_accessible_area_monitored, risks_to_data_subjects_assessed, route_approvals, special_category_data_processed, systematic_and_extensive_evaluation, uses_new_technologies, vulnerable_data_subjects],
    unknown_keys(Profile, ContractKeys, UnknownKeyProblems),
    key_problems(ContractKeys, Profile, UnknownKeyProblems, Problems).

key_type(assessment_indicates_high_risk_absent_mitigation, judgement).
key_type(automated_evaluation_including_profiling, boolean).
key_type(criminal_offence_data_processed, boolean).
key_type(data_protection_officer_advice_sought, boolean).
key_type(data_protection_officer_designated, boolean).
key_type(datasets_matched_or_combined, judgement).
key_type(decisions_based_on_evaluation, boolean).
key_type(decisions_produce_legal_effects, boolean).
key_type(decisions_similarly_significantly_affect, judgement).
key_type(description_of_processing_and_purposes_present, boolean).
key_type(envisaged_measures_described, boolean).
key_type(highly_personal_data_processed, judgement).
key_type(impact_assessment_carried_out, boolean).
key_type(lawful_basis_is_legal_obligation_or_public_task, boolean).
key_type(legal_basis_with_general_impact_assessment, outside_fact).
key_type(legitimate_interest_described, boolean).
key_type(legitimate_interest_pursued, boolean).
key_type(likely_high_risk_to_rights_and_freedoms, judgement).
key_type(measures_reduce_residual_risk_below_high, judgement).
key_type(member_state_requires_assessment_despite_general_one, outside_fact).
key_type(member_state_requires_prior_authorisation, outside_fact).
key_type(mitigating_measures_taken, boolean).
key_type(monitoring_is_systematic, judgement).
key_type(national_list_exempts_assessment, outside_fact).
key_type(national_list_exempts_item, national_list_exempts_item_value).
key_type(national_list_requires_assessment, outside_fact).
key_type(national_list_requires_item, national_list_requires_item_value).
key_type(necessity_and_proportionality_assessed, boolean).
key_type(processing_for_public_interest_task, boolean).
key_type(processing_on_large_scale, judgement).
key_type(processing_prevents_exercise_of_right_or_service, judgement).
key_type(publicly_accessible_area_monitored, boolean).
key_type(risks_to_data_subjects_assessed, boolean).
key_type(route_approvals, route_approvals_value).
key_type(special_category_data_processed, boolean).
key_type(systematic_and_extensive_evaluation, judgement).
key_type(uses_new_technologies, boolean).
key_type(vulnerable_data_subjects, judgement).

attribute_list_t(Term, false) :-
    var(Term).
attribute_list_t(Term, true) :-
    Term == [].
attribute_list_t(Term, Truth) :-
    nonvar(Term),
    Term = [Element|Elements],
    attribute_t(Element, ElementIsAttribute),
    attribute_list_t(Elements, ElementsAreAttributes),
    truth_and(ElementIsAttribute, ElementsAreAttributes, Truth).
attribute_list_t(Term, false) :-
    nonvar(Term),
    Term \== [],
    Term \= [_|_].

attribute_t(Element, false) :-
    var(Element).
attribute_t(Element, Truth) :-
    nonvar(Element),
    Element = attribute(Key, _),
    key_shape_t(Key, Truth).
attribute_t(Element, false) :-
    nonvar(Element),
    Element \= attribute(_, _).

key_shape_t(Key, true) :-
    var(Key).
key_shape_t(Key, Truth) :-
    nonvar(Key),
    term_variables(Key, Variables),
    no_variables_t(Variables, Truth).

no_variables_t([], true).
no_variables_t([_|_], false).

identity_member_t(_, [], false).
identity_member_t(Term, [Item|_], true) :-
    Term == Item.
identity_member_t(Term, [Item|Items], Truth) :-
    Term \== Item,
    identity_member_t(Term, Items, Truth).

unknown_keys([], _, []).
unknown_keys([attribute(Key, _)|Elements], Known, Problems) :-
    identity_member_t(Key, Known, IsKnown),
    name_unknown_key(IsKnown, Key, Known, Elements, Problems).

name_unknown_key(true, _, Known, Elements, Problems) :-
    unknown_keys(Elements, Known, Problems).
name_unknown_key(false, Key, Known, Elements, [unknown_key(Key)|Problems]) :-
    unknown_keys(Elements, [Key|Known], Problems).

key_problems([], _, Problems, Problems).
key_problems([Key|ContractKeys], Profile, LaterProblems, Problems) :-
    key_type(Key, ValueType),
    key_occurrences(Profile, Key, Occurrences),
    key_problems(ContractKeys, Profile, LaterProblems, KeyProblems),
    name_key_problem(Occurrences, Key, ValueType, Profile, KeyProblems, Problems).

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
name_key_problem(one, Key, ValueType, Profile, KeyProblems, Problems) :-
    values_in_type_t(Profile, Key, ValueType, InType),
    name_wrong_type(InType, Key, KeyProblems, Problems).

name_wrong_type(true, _, Problems, Problems).
name_wrong_type(false, Key, Problems, [wrong_type(Key)|Problems]).

values_in_type_t([], _, _, true).
values_in_type_t([attribute(ElementKey, Value)|Elements], Key, ValueType, Truth) :-
    ElementKey == Key,
    in_type_t(ValueType, Value, ValueInType),
    values_in_type_t(Elements, Key, ValueType, RestInType),
    truth_and(ValueInType, RestInType, Truth).
values_in_type_t([attribute(ElementKey, _)|Elements], Key, ValueType, Truth) :-
    ElementKey \== Key,
    values_in_type_t(Elements, Key, ValueType, Truth).

in_type_t(boolean, Value, Truth) :-
    identity_member_t(Value, [true, false], Truth).
in_type_t(judgement, Value, Truth) :-
    identity_member_t(Value, [true, false, unsure], Truth).
in_type_t(outside_fact, Value, Truth) :-
    attested_t(Value, boolean, Truth).
in_type_t(national_list_requires_item_value, Value, Truth) :-
    attested_t(Value, national_list_item(requires), Truth).
in_type_t(national_list_exempts_item_value, Value, Truth) :-
    attested_t(Value, national_list_item(exempts), Truth).
in_type_t(national_list_item(Side), Value, Truth) :-
    national_list_item_t(Side, Value, Truth).
in_type_t(route_approvals_value, Value, Truth) :-
    approvals_t(Value, Truth).

truth_and(true, Truth, Truth).
truth_and(false, _, false).

attested_t(Value, _, false) :-
    var(Value).
attested_t(Value, ValueType, Truth) :-
    nonvar(Value),
    Value = attested(AttestedValue, Attestation),
    attestation_t(Attestation, IsAttestation),
    attested_value_t(IsAttestation, ValueType, AttestedValue, Truth).
attested_t(Value, _, false) :-
    nonvar(Value),
    Value \= attested(_, _).

attestation_t(Attestation, false) :-
    var(Attestation).
attestation_t(Attestation, true) :-
    nonvar(Attestation),
    Attestation = attestation(_, _, _, _).
attestation_t(Attestation, false) :-
    nonvar(Attestation),
    Attestation \= attestation(_, _, _, _).

attested_value_t(false, _, _, false).
attested_value_t(true, ValueType, AttestedValue, Truth) :-
    in_type_t(ValueType, AttestedValue, Truth).

national_list_item_t(_, Item, false) :-
    var(Item).
national_list_item_t(Side, Item, Truth) :-
    nonvar(Item),
    Item = national_list_item(Authority, ItemIdentifier),
    national_list_pairs(Side, Pairs),
    identity_member_t(Authority - ItemIdentifier, Pairs, Truth).
national_list_item_t(_, Item, false) :-
    nonvar(Item),
    Item \= national_list_item(_, _).

national_list_pairs(Side, Pairs) :-
    findall(Authority - ItemIdentifier, national_list_item_identifier(Side, Authority, ItemIdentifier, _), Pairs).

national_list_item_identifier(requires, de_dsk, de_dsk_35_4_nr_1, cite(de_dsk_35_4_nr_1)).
national_list_item_identifier(requires, de_dsk, de_dsk_35_4_nr_2, cite(de_dsk_35_4_nr_2)).
national_list_item_identifier(requires, de_dsk, de_dsk_35_4_nr_3, cite(de_dsk_35_4_nr_3)).
national_list_item_identifier(requires, de_dsk, de_dsk_35_4_nr_4, cite(de_dsk_35_4_nr_4)).
national_list_item_identifier(requires, de_dsk, de_dsk_35_4_nr_5, cite(de_dsk_35_4_nr_5)).
national_list_item_identifier(requires, de_dsk, de_dsk_35_4_nr_6, cite(de_dsk_35_4_nr_6)).
national_list_item_identifier(requires, de_dsk, de_dsk_35_4_nr_7, cite(de_dsk_35_4_nr_7)).
national_list_item_identifier(requires, de_dsk, de_dsk_35_4_nr_8, cite(de_dsk_35_4_nr_8)).
national_list_item_identifier(requires, de_dsk, de_dsk_35_4_nr_9, cite(de_dsk_35_4_nr_9)).
national_list_item_identifier(requires, de_dsk, de_dsk_35_4_nr_10, cite(de_dsk_35_4_nr_10)).
national_list_item_identifier(requires, de_dsk, de_dsk_35_4_nr_11, cite(de_dsk_35_4_nr_11)).
national_list_item_identifier(requires, de_dsk, de_dsk_35_4_nr_12, cite(de_dsk_35_4_nr_12)).
national_list_item_identifier(requires, de_dsk, de_dsk_35_4_nr_13, cite(de_dsk_35_4_nr_13)).
national_list_item_identifier(requires, de_dsk, de_dsk_35_4_nr_14, cite(de_dsk_35_4_nr_14)).
national_list_item_identifier(requires, de_dsk, de_dsk_35_4_nr_15, cite(de_dsk_35_4_nr_15)).
national_list_item_identifier(requires, de_dsk, de_dsk_35_4_nr_16, cite(de_dsk_35_4_nr_16)).
national_list_item_identifier(requires, de_dsk, de_dsk_35_4_nr_17, cite(de_dsk_35_4_nr_17)).
national_list_item_identifier(requires, ie_dpc, ie_dpc_35_4_nr_1, cite(ie_dpc_35_4_nr_1)).
national_list_item_identifier(requires, ie_dpc, ie_dpc_35_4_nr_2, cite(ie_dpc_35_4_nr_2)).
national_list_item_identifier(requires, ie_dpc, ie_dpc_35_4_nr_3, cite(ie_dpc_35_4_nr_3)).
national_list_item_identifier(requires, ie_dpc, ie_dpc_35_4_nr_4, cite(ie_dpc_35_4_nr_4)).
national_list_item_identifier(requires, ie_dpc, ie_dpc_35_4_nr_5, cite(ie_dpc_35_4_nr_5)).
national_list_item_identifier(requires, ie_dpc, ie_dpc_35_4_nr_6, cite(ie_dpc_35_4_nr_6)).
national_list_item_identifier(requires, ie_dpc, ie_dpc_35_4_nr_7, cite(ie_dpc_35_4_nr_7)).
national_list_item_identifier(requires, ie_dpc, ie_dpc_35_4_nr_8, cite(ie_dpc_35_4_nr_8)).
national_list_item_identifier(requires, ie_dpc, ie_dpc_35_4_nr_9, cite(ie_dpc_35_4_nr_9)).
national_list_item_identifier(requires, ie_dpc, ie_dpc_35_4_nr_10, cite(ie_dpc_35_4_nr_10)).
national_list_item_identifier(requires, fr_cnil, fr_cnil_35_4_list, cite(fr_cnil_35_4_list)).
national_list_item_identifier(exempts, fr_cnil, fr_cnil_35_5_list, cite(fr_cnil_35_5_list)).

approvals_t(Value, false) :-
    var(Value).
approvals_t(Value, Truth) :-
    nonvar(Value),
    Value = approvals(Viewer, Approvals),
    viewer_t(Viewer, ViewerTruth),
    approval_list_t(Approvals, ApprovalsTruth),
    truth_and(ViewerTruth, ApprovalsTruth, Truth).
approvals_t(Value, false) :-
    nonvar(Value),
    Value \= approvals(_, _).

viewer_t(Viewer, false) :-
    var(Viewer).
viewer_t(Viewer, true) :-
    nonvar(Viewer),
    Viewer = viewer(_).
viewer_t(Viewer, false) :-
    nonvar(Viewer),
    Viewer \= viewer(_).

approval_list_t(Approvals, false) :-
    var(Approvals).
approval_list_t(Approvals, true) :-
    Approvals == [].
approval_list_t(Approvals, Truth) :-
    nonvar(Approvals),
    Approvals = [Approval|Remaining],
    approval_t(Approval, ApprovalTruth),
    approval_list_t(Remaining, RemainingTruth),
    truth_and(ApprovalTruth, RemainingTruth, Truth).
approval_list_t(Approvals, false) :-
    nonvar(Approvals),
    Approvals \== [],
    Approvals \= [_|_].

approval_t(Approval, false) :-
    var(Approval).
approval_t(Approval, Truth) :-
    nonvar(Approval),
    Approval = approval(RouteIdentifier, RouteDigest, ApprovalStatus, _, _),
    atom_t(RouteIdentifier, IdentifierTruth),
    route_digest_t(RouteDigest, DigestTruth),
    identity_member_t(ApprovalStatus, [approved, rejected], StatusTruth),
    truth_and(IdentifierTruth, DigestTruth, IdentifierAndDigestTruth),
    truth_and(IdentifierAndDigestTruth, StatusTruth, Truth).
approval_t(Approval, false) :-
    nonvar(Approval),
    Approval \= approval(_, _, _, _, _).

atom_t(Term, false) :-
    var(Term).
atom_t(Term, true) :-
    atom(Term).
atom_t(Term, false) :-
    number(Term).
atom_t(Term, false) :-
    compound(Term).

route_digest_t(RouteDigest, Truth) :-
    atom_t(RouteDigest, IsAtom),
    digest_characters_t(IsAtom, RouteDigest, Truth).

digest_characters_t(false, _, false).
digest_characters_t(true, RouteDigest, Truth) :-
    atom_chars(RouteDigest, Characters),
    length(Characters, Length),
    digest_length_t(Length, LengthTruth),
    hexadecimal_characters_t(Characters, CharactersTruth),
    truth_and(LengthTruth, CharactersTruth, Truth).

digest_length_t(64, true).
digest_length_t(Length, false) :-
    dif(Length, 64).

hexadecimal_characters_t([], true).
hexadecimal_characters_t([Character|Characters], Truth) :-
    identity_member_t(Character, ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9', a, b, c, d, e, f], CharacterTruth),
    hexadecimal_characters_t(Characters, RestTruth),
    truth_and(CharacterTruth, RestTruth, Truth).

strong_and([], met).
strong_and([Value|Values], Combined) :-
    strong_and(Values, RestValue),
    and_pair(Value, RestValue, Combined).

and_pair(unmet, _, unmet).
and_pair(met, RestValue, RestValue).
and_pair(open(_Kind, _Key), unmet, unmet).
and_pair(open(Kind, Key), met, open(Kind, Key)).
and_pair(open(Kind, Key), open(_, _), open(Kind, Key)).

strong_or([], unmet).
strong_or([Value|Values], Combined) :-
    strong_or(Values, RestValue),
    or_pair(Value, RestValue, Combined).

or_pair(met, _, met).
or_pair(unmet, RestValue, RestValue).
or_pair(open(_Kind, _Key), met, met).
or_pair(open(Kind, Key), unmet, open(Kind, Key)).
or_pair(open(Kind, Key), open(_, _), open(Kind, Key)).

strong_not(met, unmet).
strong_not(unmet, met).
strong_not(open(Kind, Key), open(Kind, Key)).

leaf_crisp(Profile, Key, open(absence, Key)) :-
    profile_lacks(Profile, Key).
leaf_crisp(Profile, Key, met) :-
    profile_has(Profile, Key),
    profile_get(Profile, Key, true).
leaf_crisp(Profile, Key, unmet) :-
    profile_has(Profile, Key),
    profile_get(Profile, Key, false).

leaf_judgement(Profile, Key, open(absence, Key)) :-
    profile_lacks(Profile, Key).
leaf_judgement(Profile, Key, met) :-
    profile_has(Profile, Key),
    profile_get(Profile, Key, true).
leaf_judgement(Profile, Key, unmet) :-
    profile_has(Profile, Key),
    profile_get(Profile, Key, false).
leaf_judgement(Profile, Key, open(judgement, Key)) :-
    profile_has(Profile, Key),
    profile_get(Profile, Key, unsure).

leaf_outside_blocking(Profile, Key, unmet) :-
    profile_lacks(Profile, Key).
leaf_outside_blocking(Profile, Key, met) :-
    profile_has(Profile, Key),
    profile_get(Profile, Key, attested(true, _)).
leaf_outside_blocking(Profile, Key, unmet) :-
    profile_has(Profile, Key),
    profile_get(Profile, Key, attested(false, _)).

leaf_outside_enabling(Profile, Key, open(cross_reference, Key)) :-
    profile_lacks(Profile, Key).
leaf_outside_enabling(Profile, Key, met) :-
    profile_has(Profile, Key),
    profile_get(Profile, Key, attested(true, _)).
leaf_outside_enabling(Profile, Key, unmet) :-
    profile_has(Profile, Key),
    profile_get(Profile, Key, attested(false, _)).

test(an_empty_profile_has_no_problem) :-
    gdpr_impact_assessment_assessment_duty_stated_risk_input_problems([], []).
test(a_non_list_is_not_a_profile) :-
    gdpr_impact_assessment_assessment_duty_stated_risk_input_problems(profile, [wrong_type(profile)]).
test(an_unbound_profile_is_not_a_profile) :-
    gdpr_impact_assessment_assessment_duty_stated_risk_input_problems(_, [wrong_type(profile)]).
test(a_compound_key_with_a_variable_is_not_an_attribute_list) :-
    gdpr_impact_assessment_assessment_duty_stated_risk_input_problems([attribute(foo(_), true)], [wrong_type(profile)]).
test(an_unbound_key_is_named_as_itself_once) :-
    gdpr_impact_assessment_assessment_duty_stated_risk_input_problems([attribute(Free, true), attribute(Free, false)], Problems),
    Problems = [unknown_key(Named)],
    Named == Free.
test(an_unknown_key_comes_after_the_contract_problems) :-
    gdpr_impact_assessment_assessment_duty_stated_risk_input_problems([attribute(colour, red), attribute(uses_new_technologies, unsure)], [wrong_type(uses_new_technologies), unknown_key(colour)]).
test(a_duplicate_key_is_not_also_wrong_type) :-
    gdpr_impact_assessment_assessment_duty_stated_risk_input_problems([attribute(processing_on_large_scale, maybe), attribute(processing_on_large_scale, true)], [duplicate_key(processing_on_large_scale)]).
test(an_unbound_value_is_wrong_type) :-
    gdpr_impact_assessment_assessment_duty_stated_risk_input_problems([attribute(uses_new_technologies, _)], [wrong_type(uses_new_technologies)]).
test(a_judgement_may_be_unsure) :-
    gdpr_impact_assessment_assessment_duty_stated_risk_input_problems([attribute(vulnerable_data_subjects, unsure)], []).
test(the_attestation_arguments_are_not_inspected) :-
    gdpr_impact_assessment_assessment_duty_stated_risk_input_problems([attribute(national_list_requires_assessment, attested(true, attestation(_, _, _, _)))], []).
test(an_outside_fact_needs_four_attestation_arguments) :-
    gdpr_impact_assessment_assessment_duty_stated_risk_input_problems([attribute(national_list_requires_assessment, attested(true, attestation(by, at, reason)))], [wrong_type(national_list_requires_assessment)]).
test(a_matching_item_passes) :-
    gdpr_impact_assessment_assessment_duty_stated_risk_input_problems([attribute(national_list_requires_item, attested(national_list_item(ie_dpc, ie_dpc_35_4_nr_10), attestation(by, at, reason, none)))], []).
test(a_mismatched_authority_is_wrong_type) :-
    gdpr_impact_assessment_assessment_duty_stated_risk_input_problems([attribute(national_list_requires_item, attested(national_list_item(ie_dpc, de_dsk_35_4_nr_1), attestation(by, at, reason, none)))], [wrong_type(national_list_requires_item)]).
test(the_exempt_list_on_the_requires_side_is_wrong_type) :-
    gdpr_impact_assessment_assessment_duty_stated_risk_input_problems([attribute(national_list_requires_item, attested(national_list_item(fr_cnil, fr_cnil_35_5_list), attestation(by, at, reason, none)))], [wrong_type(national_list_requires_item)]).
test(the_exempt_side_takes_only_the_cnil_exempt_list) :-
    gdpr_impact_assessment_assessment_duty_stated_risk_input_problems([attribute(national_list_exempts_item, attested(national_list_item(fr_cnil, fr_cnil_35_5_list), attestation(by, at, reason, none)))], []).
test(the_requires_list_on_the_exempt_side_is_wrong_type) :-
    gdpr_impact_assessment_assessment_duty_stated_risk_input_problems([attribute(national_list_exempts_item, attested(national_list_item(fr_cnil, fr_cnil_35_4_list), attestation(by, at, reason, none)))], [wrong_type(national_list_exempts_item)]).
test(well_formed_route_approvals_pass) :-
    gdpr_impact_assessment_assessment_duty_stated_risk_input_problems([attribute(route_approvals, approvals(viewer(account), [approval(route_profiling_with_legal_effects, '710c9afd08677bc4582523143a02ce5dad02d58e7d3255be19b48aceb3b35a55', approved, at, reason)]))], []).
test(a_short_route_digest_is_wrong_type) :-
    gdpr_impact_assessment_assessment_duty_stated_risk_input_problems([attribute(route_approvals, approvals(viewer(account), [approval(route_profiling_with_legal_effects, '710c9afd', approved, at, reason)]))], [wrong_type(route_approvals)]).
test(an_approval_status_outside_the_enum_is_wrong_type) :-
    gdpr_impact_assessment_assessment_duty_stated_risk_input_problems([attribute(route_approvals, approvals(viewer(account), [approval(route_profiling_with_legal_effects, '710c9afd08677bc4582523143a02ce5dad02d58e7d3255be19b48aceb3b35a55', pending, at, reason)]))], [wrong_type(route_approvals)]).
test(and_unmet_dominates) :-
    strong_and([met, open(absence, processing_on_large_scale), unmet], unmet).
test(and_keeps_the_first_open) :-
    strong_and([met, open(judgement, monitoring_is_systematic), open(absence, processing_on_large_scale)], open(judgement, monitoring_is_systematic)).
test(or_met_dominates) :-
    strong_or([open(absence, special_category_data_processed), met], met).
test(or_with_no_met_is_open) :-
    strong_or([unmet, open(judgement, processing_on_large_scale)], open(judgement, processing_on_large_scale)).
test(not_keeps_open) :-
    strong_not(open(cross_reference, member_state_requires_assessment_despite_general_one), open(cross_reference, member_state_requires_assessment_despite_general_one)).
test(not_swaps_met) :-
    strong_not(met, unmet).

test(a_mismatched_authority_does_not_pass, fail) :-
    gdpr_impact_assessment_assessment_duty_stated_risk_input_problems([attribute(national_list_requires_item, attested(national_list_item(ie_dpc, de_dsk_35_4_nr_1), attestation(by, at, reason, none)))], []).
