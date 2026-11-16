% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_chapter_v_transfers_kernel, [gdpr_chapter_v_transfers_input_problems/2, gdpr_chapter_v_transfers_cascade/5]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(library(reif), [memberd_t/3]).
:- use_module(formalize_lib, [profile_get/3, profile_lacks/2]).
:- use_module(m__eu_data_protection_gdpr_chapter_v_transfers_citations, [implements/1]).

gdpr_chapter_v_transfers_input_problems(Profile, Problems) :-
    attribute_list_t(Profile, IsAttributeList),
    profile_problems(IsAttributeList, Profile, Problems).

profile_problems(false, _, [wrong_type(profile)]).
profile_problems(true, Profile, Problems) :-
    Keys = [adequacy_decision_in_force, safeguard_in_place, derogation_claimed, public_authority_public_powers, explicit_consent_obtained, contract_necessity, data_subject_interest_contract_necessity, important_public_interest, legal_claims_necessity, vital_interests_necessity, register_public_by_law, register_consultation_conditions_fulfilled, register_not_entire, register_requester_condition_met, legitimate_interests_derogation, transfer_is_onward_transfer, binding_corporate_rules_approved, third_country_judgment_or_decision_requires_transfer, international_agreement_basis_for_judgment_or_decision],
    unknown_keys(Profile, Keys, UnknownKeyProblems),
    key_problems(Keys, Profile, UnknownKeyProblems, Problems).

key_type(adequacy_decision_in_force, outside_fact).
key_type(safeguard_in_place, judgement).
key_type(derogation_claimed, enum([art49_1_a, art49_1_b, art49_1_c, art49_1_d, art49_1_e, art49_1_f, art49_1_g, art49_1_second_subpara])).
key_type(public_authority_public_powers, boolean).
key_type(explicit_consent_obtained, boolean).
key_type(contract_necessity, judgement).
key_type(data_subject_interest_contract_necessity, judgement).
key_type(important_public_interest, judgement).
key_type(legal_claims_necessity, judgement).
key_type(vital_interests_necessity, judgement).
key_type(register_public_by_law, boolean).
key_type(register_consultation_conditions_fulfilled, boolean).
key_type(register_not_entire, boolean).
key_type(register_requester_condition_met, boolean).
key_type(legitimate_interests_derogation, judgement).
key_type(transfer_is_onward_transfer, outside_fact).
key_type(binding_corporate_rules_approved, outside_fact).
key_type(third_country_judgment_or_decision_requires_transfer, outside_fact).
key_type(international_agreement_basis_for_judgment_or_decision, outside_fact).

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

root_key_order([adequacy_decision_in_force, safeguard_in_place, derogation_claimed, public_authority_public_powers, explicit_consent_obtained, contract_necessity, data_subject_interest_contract_necessity, important_public_interest, legal_claims_necessity, vital_interests_necessity, register_public_by_law, register_consultation_conditions_fulfilled, register_not_entire, register_requester_condition_met, legitimate_interests_derogation, transfer_is_onward_transfer, binding_corporate_rules_approved, third_country_judgment_or_decision_requires_transfer, international_agreement_basis_for_judgment_or_decision]).

derogation_citation(art49_1_a, cite(eu_reg_2016_679_art_49_1_a)).
derogation_citation(art49_1_b, cite(eu_reg_2016_679_art_49_1_b)).
derogation_citation(art49_1_c, cite(eu_reg_2016_679_art_49_1_c)).
derogation_citation(art49_1_d, cite(eu_reg_2016_679_art_49_1_d)).
derogation_citation(art49_1_e, cite(eu_reg_2016_679_art_49_1_e)).
derogation_citation(art49_1_f, cite(eu_reg_2016_679_art_49_1_f)).
derogation_citation(art49_1_g, cite(eu_reg_2016_679_art_49_1_g)).
derogation_citation(art49_1_second_subpara, cite(eu_reg_2016_679_art_49_1_second_subpara)).

referral_citation(safeguard_in_place, cite(eu_reg_2016_679_art_46)).
referral_citation(contract_necessity, cite(eu_reg_2016_679_art_49_1_b)).
referral_citation(data_subject_interest_contract_necessity, cite(eu_reg_2016_679_art_49_1_c)).
referral_citation(important_public_interest, cite(eu_reg_2016_679_art_49_1_d)).
referral_citation(legal_claims_necessity, cite(eu_reg_2016_679_art_49_1_e)).
referral_citation(vital_interests_necessity, cite(eu_reg_2016_679_art_49_1_f)).
referral_citation(legitimate_interests_derogation, cite(eu_reg_2016_679_art_49_1_second_subpara)).

point_judgement_keys(art49_1_a, []).
point_judgement_keys(art49_1_b, [contract_necessity]).
point_judgement_keys(art49_1_c, [data_subject_interest_contract_necessity]).
point_judgement_keys(art49_1_d, [important_public_interest]).
point_judgement_keys(art49_1_e, [legal_claims_necessity]).
point_judgement_keys(art49_1_f, [vital_interests_necessity]).
point_judgement_keys(art49_1_g, []).
point_judgement_keys(art49_1_second_subpara, [contract_necessity, data_subject_interest_contract_necessity, important_public_interest, legal_claims_necessity, vital_interests_necessity, legitimate_interests_derogation]).

first_subparagraph_points([art49_1_a, art49_1_b, art49_1_c, art49_1_d, art49_1_e, art49_1_f, art49_1_g]).

gdpr_chapter_v_transfers_cascade(Profile, RequirementId, Outcome, JudgementPairs, Citation) :-
    implements(eu_reg_2016_679_art_44),
    adequacy_world(Profile, AdequacyWorld),
    cascade_from(AdequacyWorld, Profile, RequirementId, Outcome, JudgementPairs, Citation).

adequacy_world(Profile, attested_true) :-
    profile_get(Profile, adequacy_decision_in_force, attested(true, _)).
adequacy_world(Profile, attested_false) :-
    profile_get(Profile, adequacy_decision_in_force, attested(false, _)).
adequacy_world(Profile, absent) :-
    profile_lacks(Profile, adequacy_decision_in_force).

binding_rules_world(Profile, approved) :-
    profile_get(Profile, binding_corporate_rules_approved, attested(true, _)).
binding_rules_world(Profile, not_claimed) :-
    profile_get(Profile, binding_corporate_rules_approved, attested(false, _)).
binding_rules_world(Profile, not_claimed) :-
    profile_lacks(Profile, binding_corporate_rules_approved).

safeguard_world(Profile, SafeguardValue) :-
    profile_get(Profile, safeguard_in_place, SafeguardValue).
safeguard_world(Profile, absent) :-
    profile_lacks(Profile, safeguard_in_place).

claim_world(Profile, claimed(Point)) :-
    profile_get(Profile, derogation_claimed, Point).
claim_world(Profile, none) :-
    profile_lacks(Profile, derogation_claimed).

cascade_from(attested_true, _, art45_adequacy, met, [], cite(eu_reg_2016_679_art_45_1)) :-
    implements(eu_reg_2016_679_art_45_1).
cascade_from(attested_false, Profile, RequirementId, Outcome, JudgementPairs, Citation) :-
    implements(eu_reg_2016_679_art_46_1),
    binding_rules_world(Profile, BindingRulesWorld),
    stage_two(BindingRulesWorld, attested_false, Profile, RequirementId, Outcome, JudgementPairs, Citation).
cascade_from(absent, Profile, RequirementId, Outcome, JudgementPairs, Citation) :-
    implements(eu_reg_2016_679_art_46_1),
    binding_rules_world(Profile, BindingRulesWorld),
    stage_two(BindingRulesWorld, absent, Profile, RequirementId, Outcome, JudgementPairs, Citation).

stage_two(approved, _, _, art46_safeguards, met, [], cite(eu_reg_2016_679_art_46_2_b)) :-
    implements(eu_reg_2016_679_art_46_2),
    implements(eu_reg_2016_679_art_46_2_b),
    implements(eu_reg_2016_679_art_47_1).
stage_two(not_claimed, AdequacyWorld, Profile, RequirementId, Outcome, JudgementPairs, Citation) :-
    implements(eu_reg_2016_679_art_46_2_b),
    safeguard_world(Profile, SafeguardWorld),
    safeguard_stage(SafeguardWorld, AdequacyWorld, Profile, RequirementId, Outcome, JudgementPairs, Citation).

safeguard_stage(true, _, _, art46_safeguards, met, [], cite(eu_reg_2016_679_art_46_1)) :-
    implements(eu_reg_2016_679_art_46_1).
safeguard_stage(absent, _, _, art46_safeguards, open_by_absence([safeguard_in_place]), [], cite(eu_reg_2016_679_art_46_1)) :-
    implements(eu_reg_2016_679_art_46_1).
safeguard_stage(false, absent, _, art46_safeguards, open_by_outside_fact(adequacy_decision_in_force), [safeguard_in_place - false], cite(eu_reg_2016_679_art_45)) :-
    implements(eu_reg_2016_679_art_45_3).
safeguard_stage(unsure, absent, _, art46_safeguards, open_by_outside_fact(adequacy_decision_in_force), [safeguard_in_place - unsure], cite(eu_reg_2016_679_art_45)) :-
    implements(eu_reg_2016_679_art_45_3).
safeguard_stage(unsure, attested_false, Profile, art46_safeguards, Outcome, JudgementPairs, Citation) :-
    implements(eu_reg_2016_679_art_46_1),
    claim_world(Profile, ClaimWorld),
    hypothetical_stage_three(ClaimWorld, Profile, HypotheticalOutcome),
    safeguard_judgement_result(HypotheticalOutcome, Outcome, JudgementPairs, Citation).
safeguard_stage(false, attested_false, Profile, art49_derogation, Outcome, JudgementPairs, Citation) :-
    implements(eu_reg_2016_679_art_49_1),
    claim_world(Profile, ClaimWorld),
    stage_three(ClaimWorld, Profile, Outcome, JudgementPairs, Citation).

hypothetical_stage_three(none, _, no_claim).
hypothetical_stage_three(claimed(Point), Profile, Outcome) :-
    point_outcome(Point, Profile, Outcome).

safeguard_judgement_result(open_by_absence(MissingKeys), open_by_absence(MissingKeys), [], cite(eu_reg_2016_679_art_46_1)).
safeguard_judgement_result(met, open_by_judgement(safeguard_in_place), [safeguard_in_place - unsure], cite(eu_reg_2016_679_art_46)).
safeguard_judgement_result(unmet, open_by_judgement(safeguard_in_place), [safeguard_in_place - unsure], cite(eu_reg_2016_679_art_46)).
safeguard_judgement_result(open_by_judgement(_), open_by_judgement(safeguard_in_place), [safeguard_in_place - unsure], cite(eu_reg_2016_679_art_46)).
safeguard_judgement_result(no_claim, open_by_judgement(safeguard_in_place), [safeguard_in_place - unsure], cite(eu_reg_2016_679_art_46)).

stage_three(none, _, unmet, [], cite(eu_reg_2016_679_art_49_1)) :-
    implements(eu_reg_2016_679_art_49_1).
stage_three(claimed(Point), Profile, Outcome, JudgementPairs, Citation) :-
    implements(eu_reg_2016_679_art_49_1),
    point_outcome(Point, Profile, PointOutcome),
    point_judgement_keys(Point, JudgementKeys),
    present_pairs(JudgementKeys, Profile, JudgementPairs),
    stage_three_result(PointOutcome, Point, Outcome, Citation).

stage_three_result(met, Point, met, Citation) :-
    derogation_citation(Point, Citation).
stage_three_result(unmet, Point, unmet, Citation) :-
    derogation_citation(Point, Citation).
stage_three_result(open_by_absence(MissingKeys), Point, open_by_absence(MissingKeys), Citation) :-
    derogation_citation(Point, Citation).
stage_three_result(open_by_judgement([InputKey|_]), _, open_by_judgement(InputKey), Citation) :-
    referral_citation(InputKey, Citation).

present_pairs([], _, []).
present_pairs([Key|Keys], Profile, [Key - Value|Pairs]) :-
    profile_get(Profile, Key, Value),
    present_pairs(Keys, Profile, Pairs).
present_pairs([Key|Keys], Profile, Pairs) :-
    profile_lacks(Profile, Key),
    present_pairs(Keys, Profile, Pairs).

point_outcome(art49_1_a, Profile, Outcome) :-
    implements(eu_reg_2016_679_art_49_1_a),
    carve_out_outcome(Profile, CarveOut),
    required_key_outcome(Profile, explicit_consent_obtained, Consent),
    conjoin_outcomes([CarveOut, Consent], Outcome).
point_outcome(art49_1_b, Profile, Outcome) :-
    implements(eu_reg_2016_679_art_49_1_b),
    carve_out_outcome(Profile, CarveOut),
    required_key_outcome(Profile, contract_necessity, Necessity),
    conjoin_outcomes([CarveOut, Necessity], Outcome).
point_outcome(art49_1_c, Profile, Outcome) :-
    implements(eu_reg_2016_679_art_49_1_c),
    carve_out_outcome(Profile, CarveOut),
    required_key_outcome(Profile, data_subject_interest_contract_necessity, Necessity),
    conjoin_outcomes([CarveOut, Necessity], Outcome).
point_outcome(art49_1_d, Profile, Outcome) :-
    implements(eu_reg_2016_679_art_49_1_d),
    implements(eu_reg_2016_679_art_49_4),
    required_key_outcome(Profile, important_public_interest, Outcome).
point_outcome(art49_1_e, Profile, Outcome) :-
    implements(eu_reg_2016_679_art_49_1_e),
    required_key_outcome(Profile, legal_claims_necessity, Outcome).
point_outcome(art49_1_f, Profile, Outcome) :-
    implements(eu_reg_2016_679_art_49_1_f),
    required_key_outcome(Profile, vital_interests_necessity, Outcome).
point_outcome(art49_1_g, Profile, Outcome) :-
    implements(eu_reg_2016_679_art_49_1_g),
    implements(eu_reg_2016_679_art_49_2),
    required_key_outcome(Profile, register_public_by_law, PublicByLaw),
    required_key_outcome(Profile, register_consultation_conditions_fulfilled, ConsultationConditions),
    required_key_outcome(Profile, register_not_entire, NotEntire),
    requester_outcome(Profile, Requester),
    conjoin_outcomes([PublicByLaw, ConsultationConditions, NotEntire, Requester], Outcome).
point_outcome(art49_1_second_subpara, Profile, Outcome) :-
    implements(eu_reg_2016_679_art_49_1_second_subpara),
    carve_out_outcome(Profile, CarveOut),
    required_key_outcome(Profile, legitimate_interests_derogation, Interests),
    first_subparagraph_points(Points),
    maplist(negated_point_outcome(Profile), Points, NegatedOutcomes),
    conjoin_outcomes([CarveOut, Interests|NegatedOutcomes], Outcome).

negated_point_outcome(Profile, Point, NegatedOutcome) :-
    implements(eu_reg_2016_679_art_49_1_second_subpara),
    point_outcome(Point, Profile, Outcome),
    negated_outcome(Outcome, NegatedOutcome).

negated_outcome(met, unmet).
negated_outcome(unmet, met).
negated_outcome(open_by_absence(MissingKeys), open_by_absence(MissingKeys)).
negated_outcome(open_by_judgement(UnsureKeys), open_by_judgement(UnsureKeys)).

carve_out_outcome(Profile, unmet) :-
    implements(eu_reg_2016_679_art_49_3),
    profile_get(Profile, public_authority_public_powers, true).
carve_out_outcome(Profile, met) :-
    implements(eu_reg_2016_679_art_49_3),
    profile_get(Profile, public_authority_public_powers, false).
carve_out_outcome(Profile, met) :-
    implements(eu_reg_2016_679_art_49_3),
    profile_lacks(Profile, public_authority_public_powers).

requester_outcome(Profile, unmet) :-
    implements(eu_reg_2016_679_art_49_2),
    profile_get(Profile, register_requester_condition_met, false).
requester_outcome(Profile, met) :-
    implements(eu_reg_2016_679_art_49_2),
    profile_get(Profile, register_requester_condition_met, true).
requester_outcome(Profile, met) :-
    implements(eu_reg_2016_679_art_49_2),
    profile_lacks(Profile, register_requester_condition_met).

required_key_outcome(Profile, Key, met) :-
    profile_get(Profile, Key, true).
required_key_outcome(Profile, Key, unmet) :-
    profile_get(Profile, Key, false).
required_key_outcome(Profile, Key, open_by_judgement([Key])) :-
    profile_get(Profile, Key, unsure).
required_key_outcome(Profile, Key, open_by_absence([Key])) :-
    profile_lacks(Profile, Key).

conjoin_outcomes(Outcomes, Outcome) :-
    outcome_summary(Outcomes, Summary),
    summary_outcome(Summary, Outcome).

outcome_summary([], summary(false, [], [])).
outcome_summary([Outcome|Outcomes], Summary) :-
    outcome_summary(Outcomes, LaterSummary),
    add_outcome(Outcome, LaterSummary, Summary).

add_outcome(met, Summary, Summary).
add_outcome(unmet, summary(_, MissingKeys, UnsureKeys), summary(true, MissingKeys, UnsureKeys)).
add_outcome(open_by_absence(NewMissing), summary(HasUnmet, MissingKeys, UnsureKeys), summary(HasUnmet, AllMissing, UnsureKeys)) :-
    append(NewMissing, MissingKeys, AllMissing).
add_outcome(open_by_judgement(NewUnsure), summary(HasUnmet, MissingKeys, UnsureKeys), summary(HasUnmet, MissingKeys, AllUnsure)) :-
    append(NewUnsure, UnsureKeys, AllUnsure).

summary_outcome(summary(true, _, _), unmet).
summary_outcome(summary(false, [Missing|MoreMissing], _), open_by_absence(OrderedMissing)) :-
    root_key_order(RootKeys),
    keys_in_order(RootKeys, [Missing|MoreMissing], OrderedMissing).
summary_outcome(summary(false, [], [Unsure|MoreUnsure]), open_by_judgement(OrderedUnsure)) :-
    root_key_order(RootKeys),
    keys_in_order(RootKeys, [Unsure|MoreUnsure], OrderedUnsure).
summary_outcome(summary(false, [], []), met).

keys_in_order([], _, []).
keys_in_order([Key|Keys], Wanted, Ordered) :-
    memberd_t(Key, Wanted, IsWanted),
    keep_key(IsWanted, Key, Keys, Wanted, Ordered).

keep_key(true, Key, Keys, Wanted, [Key|Ordered]) :-
    keys_in_order(Keys, Wanted, Ordered).
keep_key(false, _, Keys, Wanted, Ordered) :-
    keys_in_order(Keys, Wanted, Ordered).

test(an_attested_adequacy_decision_is_stage_one_met) :-
    findall(RequirementId - Outcome, gdpr_chapter_v_transfers_cascade([attribute(adequacy_decision_in_force, attested(true, attestation(test_host, test_time, test_reason, none)))], RequirementId, Outcome, _, _), Answers),
    Answers == [art45_adequacy - met].
test(an_empty_profile_names_the_safeguard_judgement) :-
    findall(RequirementId - Outcome, gdpr_chapter_v_transfers_cascade([], RequirementId, Outcome, _, _), Answers),
    Answers == [art46_safeguards - open_by_absence([safeguard_in_place])].
test(approved_binding_corporate_rules_meet_stage_two) :-
    findall(RequirementId - Outcome - Citation, gdpr_chapter_v_transfers_cascade([attribute(safeguard_in_place, false), attribute(binding_corporate_rules_approved, attested(true, attestation(test_host, test_time, test_reason, none)))], RequirementId, Outcome, _, Citation), Answers),
    Answers == [art46_safeguards - met - cite(eu_reg_2016_679_art_46_2_b)].
test(public_powers_defeat_explicit_consent) :-
    findall(RequirementId - Outcome, gdpr_chapter_v_transfers_cascade([attribute(adequacy_decision_in_force, attested(false, attestation(test_host, test_time, test_reason, none))), attribute(safeguard_in_place, false), attribute(derogation_claimed, art49_1_a), attribute(explicit_consent_obtained, true), attribute(public_authority_public_powers, true)], RequirementId, Outcome, _, _), Answers),
    Answers == [art49_derogation - unmet].
test(explicit_consent_without_public_powers_is_met) :-
    findall(RequirementId - Outcome, gdpr_chapter_v_transfers_cascade([attribute(adequacy_decision_in_force, attested(false, attestation(test_host, test_time, test_reason, none))), attribute(safeguard_in_place, false), attribute(derogation_claimed, art49_1_a), attribute(explicit_consent_obtained, true)], RequirementId, Outcome, _, _), Answers),
    Answers == [art49_derogation - met].
test(an_unsure_safeguard_names_the_missing_key_of_the_claim_first) :-
    findall(RequirementId - Outcome, gdpr_chapter_v_transfers_cascade([attribute(adequacy_decision_in_force, attested(false, attestation(test_host, test_time, test_reason, none))), attribute(safeguard_in_place, unsure), attribute(derogation_claimed, art49_1_b)], RequirementId, Outcome, _, _), Answers),
    Answers == [art46_safeguards - open_by_absence([contract_necessity])].
test(the_second_subparagraph_refers_on_the_first_unsure_point) :-
    findall(RequirementId - Outcome - Pairs - Citation, gdpr_chapter_v_transfers_cascade([attribute(adequacy_decision_in_force, attested(false, attestation(test_host, test_time, test_reason, none))), attribute(safeguard_in_place, false), attribute(derogation_claimed, art49_1_second_subpara), attribute(explicit_consent_obtained, false), attribute(contract_necessity, unsure), attribute(data_subject_interest_contract_necessity, false), attribute(important_public_interest, false), attribute(legal_claims_necessity, false), attribute(vital_interests_necessity, false), attribute(register_public_by_law, false), attribute(legitimate_interests_derogation, true)], RequirementId, Outcome, Pairs, Citation), Answers),
    Answers == [art49_derogation - open_by_judgement(contract_necessity) - [contract_necessity - unsure, data_subject_interest_contract_necessity - false, important_public_interest - false, legal_claims_necessity - false, vital_interests_necessity - false, legitimate_interests_derogation - true] - cite(eu_reg_2016_679_art_49_1_b)].
test(a_term_that_is_not_a_list_is_a_wrong_profile) :-
    gdpr_chapter_v_transfers_input_problems(not_a_list, [wrong_type(profile)]).
test(a_well_formed_profile_has_no_problem) :-
    gdpr_chapter_v_transfers_input_problems([attribute(safeguard_in_place, true)], []).

test(an_absent_adequacy_fact_is_not_a_stage_one_outcome, fail) :-
    gdpr_chapter_v_transfers_cascade([], art45_adequacy, _, _, _).
