% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_impact_assessment_prior_consultation_kernel, [gdpr_impact_assessment_prior_consultation_input_problems/2, gdpr_impact_assessment_prior_consultation_outside_fact_reading/3]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(library(reif), [memberd_t/3]).
:- use_module(formalize_lib, [profile_get/3, profile_has/2, profile_lacks/2]).

gdpr_impact_assessment_prior_consultation_outside_fact_reading(Profile, Key, Attested) :-
    profile_has(Profile, Key),
    profile_get(Profile, Key, Attested).
gdpr_impact_assessment_prior_consultation_outside_fact_reading(Profile, Key, absent) :-
    profile_lacks(Profile, Key).

gdpr_impact_assessment_prior_consultation_input_problems(Profile, Problems) :-
    attribute_list_t(Profile, IsAttributeList),
    profile_problems(IsAttributeList, Profile, Problems).

profile_problems(false, _, [wrong_type(profile)]).
profile_problems(true, Profile, Problems) :-
    Keys = [assessment_indicates_high_risk_absent_mitigation, automated_evaluation_including_profiling, criminal_offence_data_processed, datasets_matched_or_combined, decisions_based_on_evaluation, decisions_produce_legal_effects, decisions_similarly_significantly_affect, description_of_processing_and_purposes_present, envisaged_measures_described, highly_personal_data_processed, impact_assessment_carried_out, lawful_basis_is_legal_obligation_or_public_task, legal_basis_with_general_impact_assessment, legitimate_interest_described, legitimate_interest_pursued, likely_high_risk_to_rights_and_freedoms, measures_reduce_residual_risk_below_high, member_state_requires_assessment_despite_general_one, member_state_requires_prior_authorisation, mitigating_measures_taken, monitoring_is_systematic, national_list_exempts_assessment, national_list_exempts_item, national_list_requires_assessment, national_list_requires_item, necessity_and_proportionality_assessed, processing_for_public_interest_task, processing_on_large_scale, processing_prevents_exercise_of_right_or_service, publicly_accessible_area_monitored, risks_to_data_subjects_assessed, route_approvals, special_category_data_processed, systematic_and_extensive_evaluation, uses_new_technologies, vulnerable_data_subjects],
    unknown_keys(Profile, Keys, UnknownKeyProblems),
    key_problems(Keys, Profile, UnknownKeyProblems, Problems).

key_type(assessment_indicates_high_risk_absent_mitigation, judgement).
key_type(automated_evaluation_including_profiling, boolean).
key_type(criminal_offence_data_processed, boolean).
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
attribute_t(Element, T) :-
    nonvar(Element),
    Element = attribute(Key, _),
    term_variables(Key, Variables),
    no_variables_t(Variables, T).
attribute_t(Element, false) :-
    nonvar(Element),
    Element \= attribute(_, _).

no_variables_t([], true).
no_variables_t([_|_], false).

unknown_keys([], _, []).
unknown_keys([attribute(Key, _)|Elements], Known, Problems) :-
    memberd_t(Key, Known, IsKnown),
    name_unknown_key(IsKnown, Key, Known, Elements, Problems).

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

in_type_t(judgement, Value, T) :-
    in_type_t(one_of([boolean, enum([unsure])]), Value, T).
in_type_t(outside_fact, Value, T) :-
    in_type_t(attested(boolean), Value, T).
in_type_t(national_list_exempts_item_value, Value, T) :-
    in_type_t(attested(exempts_item), Value, T).
in_type_t(national_list_requires_item_value, Value, T) :-
    in_type_t(attested(requires_item), Value, T).
in_type_t(route_approvals_value, Value, T) :-
    route_approvals_t(Value, T).
in_type_t(requires_item, Value, T) :-
    findall(national_list_item(Authority, ItemId), national_list_requires_item_identifier(Authority, ItemId), Items),
    memberd_t(Value, Items, T).
in_type_t(exempts_item, Value, T) :-
    findall(national_list_item(Authority, ItemId), national_list_exempts_item_identifier(Authority, ItemId), Items),
    memberd_t(Value, Items, T).
in_type_t(boolean, Value, T) :-
    memberd_t(Value, [true, false], T).
in_type_t(enum(Values), Value, T) :-
    memberd_t(Value, Values, T).
in_type_t(one_of(Types), Value, T) :-
    in_some_type_t(Types, Value, T).
in_type_t(attested(Type), Value, T) :-
    attested_t(Value, Type, T).

national_list_requires_item_identifier(de_dsk, de_dsk_35_4_nr_1).
national_list_requires_item_identifier(de_dsk, de_dsk_35_4_nr_2).
national_list_requires_item_identifier(de_dsk, de_dsk_35_4_nr_3).
national_list_requires_item_identifier(de_dsk, de_dsk_35_4_nr_4).
national_list_requires_item_identifier(de_dsk, de_dsk_35_4_nr_5).
national_list_requires_item_identifier(de_dsk, de_dsk_35_4_nr_6).
national_list_requires_item_identifier(de_dsk, de_dsk_35_4_nr_7).
national_list_requires_item_identifier(de_dsk, de_dsk_35_4_nr_8).
national_list_requires_item_identifier(de_dsk, de_dsk_35_4_nr_9).
national_list_requires_item_identifier(de_dsk, de_dsk_35_4_nr_10).
national_list_requires_item_identifier(de_dsk, de_dsk_35_4_nr_11).
national_list_requires_item_identifier(de_dsk, de_dsk_35_4_nr_12).
national_list_requires_item_identifier(de_dsk, de_dsk_35_4_nr_13).
national_list_requires_item_identifier(de_dsk, de_dsk_35_4_nr_14).
national_list_requires_item_identifier(de_dsk, de_dsk_35_4_nr_15).
national_list_requires_item_identifier(de_dsk, de_dsk_35_4_nr_16).
national_list_requires_item_identifier(de_dsk, de_dsk_35_4_nr_17).
national_list_requires_item_identifier(ie_dpc, ie_dpc_35_4_nr_1).
national_list_requires_item_identifier(ie_dpc, ie_dpc_35_4_nr_2).
national_list_requires_item_identifier(ie_dpc, ie_dpc_35_4_nr_3).
national_list_requires_item_identifier(ie_dpc, ie_dpc_35_4_nr_4).
national_list_requires_item_identifier(ie_dpc, ie_dpc_35_4_nr_5).
national_list_requires_item_identifier(ie_dpc, ie_dpc_35_4_nr_6).
national_list_requires_item_identifier(ie_dpc, ie_dpc_35_4_nr_7).
national_list_requires_item_identifier(ie_dpc, ie_dpc_35_4_nr_8).
national_list_requires_item_identifier(ie_dpc, ie_dpc_35_4_nr_9).
national_list_requires_item_identifier(ie_dpc, ie_dpc_35_4_nr_10).
national_list_requires_item_identifier(fr_cnil, fr_cnil_35_4_list).

national_list_exempts_item_identifier(fr_cnil, fr_cnil_35_5_list).

route_approvals_t(approvals(Viewer, Approvals), T) :-
    viewer_t(Viewer, ViewerIsWellFormed),
    approval_list_t(Approvals, ApprovalsAreWellFormed),
    truth_and(ViewerIsWellFormed, ApprovalsAreWellFormed, T).
route_approvals_t(Value, false) :-
    Value \= approvals(_, _).

viewer_t(viewer(_), true).
viewer_t(Value, false) :-
    Value \= viewer(_).

approval_list_t([], true).
approval_list_t([Approval|Approvals], T) :-
    approval_t(Approval, ApprovalIsWellFormed),
    approval_list_t(Approvals, RestAreWellFormed),
    truth_and(ApprovalIsWellFormed, RestAreWellFormed, T).
approval_list_t(Value, false) :-
    Value \== [],
    Value \= [_|_].

approval_t(approval(RouteId, RouteDigest, Status, _, _), T) :-
    atom_t(RouteId, RouteIdIsAtom),
    digest_t(RouteDigest, DigestIsWellFormed),
    memberd_t(Status, [approved, rejected], StatusIsKnown),
    truth_and(RouteIdIsAtom, DigestIsWellFormed, RouteAndDigest),
    truth_and(RouteAndDigest, StatusIsKnown, T).
approval_t(Value, false) :-
    Value \= approval(_, _, _, _, _).

atom_t(Term, true) :-
    atom(Term).
atom_t(Term, false) :-
    compound(Term).
atom_t(Term, false) :-
    number(Term).

digest_t(Term, T) :-
    atom_t(Term, IsAtom),
    atom_digest_t(IsAtom, Term, T).

atom_digest_t(false, _, false).
atom_digest_t(true, Term, T) :-
    atom_chars(Term, Characters),
    length(Characters, Length),
    memberd_t(Length, [64], LengthIsRight),
    hexadecimal_characters_t(Characters, CharactersAreHexadecimal),
    truth_and(LengthIsRight, CharactersAreHexadecimal, T).

hexadecimal_characters_t([], true).
hexadecimal_characters_t([Character|Characters], T) :-
    memberd_t(Character, ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9', a, b, c, d, e, f], CharacterIsHexadecimal),
    hexadecimal_characters_t(Characters, RestAreHexadecimal),
    truth_and(CharacterIsHexadecimal, RestAreHexadecimal, T).

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

test(an_empty_profile_has_no_problem) :-
    gdpr_impact_assessment_prior_consultation_input_problems([], []).
test(the_input_check_answers_exactly_once) :-
    findall(Problems, gdpr_impact_assessment_prior_consultation_input_problems([attribute(impact_assessment_carried_out, true)], Problems), Answers),
    Answers == [[]].
test(a_term_that_is_not_an_attribute_list_is_wrong_type_profile) :-
    gdpr_impact_assessment_prior_consultation_input_problems(profile, [wrong_type(profile)]).
test(an_unsure_crisp_key_is_wrong_type) :-
    gdpr_impact_assessment_prior_consultation_input_problems([attribute(impact_assessment_carried_out, unsure)], [wrong_type(impact_assessment_carried_out)]).
test(an_unsure_judgement_is_no_problem) :-
    gdpr_impact_assessment_prior_consultation_input_problems([attribute(measures_reduce_residual_risk_below_high, unsure)], []).
test(a_duplicate_key_is_not_also_wrong_type) :-
    gdpr_impact_assessment_prior_consultation_input_problems([attribute(mitigating_measures_taken, maybe), attribute(mitigating_measures_taken, true)], [duplicate_key(mitigating_measures_taken)]).
test(unknown_keys_follow_contract_problems_once_each) :-
    gdpr_impact_assessment_prior_consultation_input_problems([attribute(foreign_key, 1), attribute(impact_assessment_carried_out, unsure), attribute(foreign_key, 2)], [wrong_type(impact_assessment_carried_out), unknown_key(foreign_key)]).
test(an_attested_outside_fact_is_no_problem) :-
    gdpr_impact_assessment_prior_consultation_input_problems([attribute(member_state_requires_prior_authorisation, attested(true, attestation(by, at, reason, none)))], []).
test(an_outside_fact_with_a_non_boolean_value_is_wrong_type) :-
    gdpr_impact_assessment_prior_consultation_input_problems([attribute(member_state_requires_prior_authorisation, attested(maybe, attestation(by, at, reason, none)))], [wrong_type(member_state_requires_prior_authorisation)]).
test(a_listed_requires_item_is_no_problem) :-
    gdpr_impact_assessment_prior_consultation_input_problems([attribute(national_list_requires_item, attested(national_list_item(ie_dpc, ie_dpc_35_4_nr_10), attestation(by, at, reason, none)))], []).
test(the_whole_french_list_is_a_requires_item) :-
    gdpr_impact_assessment_prior_consultation_input_problems([attribute(national_list_requires_item, attested(national_list_item(fr_cnil, fr_cnil_35_4_list), attestation(by, at, reason, none)))], []).
test(a_mismatched_authority_is_wrong_type) :-
    gdpr_impact_assessment_prior_consultation_input_problems([attribute(national_list_requires_item, attested(national_list_item(de_dsk, ie_dpc_35_4_nr_1), attestation(by, at, reason, none)))], [wrong_type(national_list_requires_item)]).
test(an_item_beyond_the_closed_set_is_wrong_type) :-
    gdpr_impact_assessment_prior_consultation_input_problems([attribute(national_list_requires_item, attested(national_list_item(de_dsk, de_dsk_35_4_nr_18), attestation(by, at, reason, none)))], [wrong_type(national_list_requires_item)]).
test(the_exempts_list_is_not_a_requires_item) :-
    gdpr_impact_assessment_prior_consultation_input_problems([attribute(national_list_requires_item, attested(national_list_item(fr_cnil, fr_cnil_35_5_list), attestation(by, at, reason, none)))], [wrong_type(national_list_requires_item)]).
test(the_exempts_list_is_the_exempts_item) :-
    gdpr_impact_assessment_prior_consultation_input_problems([attribute(national_list_exempts_item, attested(national_list_item(fr_cnil, fr_cnil_35_5_list), attestation(by, at, reason, none)))], []).
test(a_requires_list_is_not_an_exempts_item) :-
    gdpr_impact_assessment_prior_consultation_input_problems([attribute(national_list_exempts_item, attested(national_list_item(fr_cnil, fr_cnil_35_4_list), attestation(by, at, reason, none)))], [wrong_type(national_list_exempts_item)]).
test(empty_route_approvals_are_no_problem) :-
    gdpr_impact_assessment_prior_consultation_input_problems([attribute(route_approvals, approvals(viewer(account), []))], []).
test(a_well_formed_approval_is_no_problem) :-
    gdpr_impact_assessment_prior_consultation_input_problems([attribute(route_approvals, approvals(viewer(account), [approval(some_other_route, '710c9afd08677bc4582523143a02ce5dad02d58e7d3255be19b48aceb3b35a55', approved, at, reason)]))], []).
test(an_uppercase_digest_is_wrong_type) :-
    gdpr_impact_assessment_prior_consultation_input_problems([attribute(route_approvals, approvals(viewer(account), [approval(route_profiling_with_legal_effects, '710C9AFD08677BC4582523143A02CE5DAD02D58E7D3255BE19B48ACEB3B35A55', approved, at, reason)]))], [wrong_type(route_approvals)]).
test(an_unknown_approval_status_is_wrong_type) :-
    gdpr_impact_assessment_prior_consultation_input_problems([attribute(route_approvals, approvals(viewer(account), [approval(route_profiling_with_legal_effects, '710c9afd08677bc4582523143a02ce5dad02d58e7d3255be19b48aceb3b35a55', pending, at, reason)]))], [wrong_type(route_approvals)]).
test(a_route_id_that_is_not_an_atom_is_wrong_type) :-
    gdpr_impact_assessment_prior_consultation_input_problems([attribute(route_approvals, approvals(viewer(account), [approval(route(1), '710c9afd08677bc4582523143a02ce5dad02d58e7d3255be19b48aceb3b35a55', rejected, at, reason)]))], [wrong_type(route_approvals)]).
test(an_absent_outside_fact_reads_absent) :-
    gdpr_impact_assessment_prior_consultation_outside_fact_reading([], member_state_requires_prior_authorisation, absent).
test(a_present_outside_fact_reads_as_given) :-
    gdpr_impact_assessment_prior_consultation_outside_fact_reading([attribute(member_state_requires_prior_authorisation, attested(false, attestation(by, at, reason, none)))], member_state_requires_prior_authorisation, attested(false, attestation(by, at, reason, none))).

test(a_present_outside_fact_does_not_read_absent, fail) :-
    gdpr_impact_assessment_prior_consultation_outside_fact_reading([attribute(member_state_requires_prior_authorisation, attested(false, attestation(by, at, reason, none)))], member_state_requires_prior_authorisation, absent).
