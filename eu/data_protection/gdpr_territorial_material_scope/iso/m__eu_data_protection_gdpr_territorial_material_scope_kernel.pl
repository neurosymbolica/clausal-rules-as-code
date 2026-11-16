% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_territorial_material_scope_kernel, [gdpr_territorial_material_scope_input_problems/2, scope_key_order/1, citation_order/1, judgement_citation/2, limb_citation/2, stage_limbs/2, reading/3, role_reading/2, outside_fact_reading/2, negated/2, both_status/3, either_status/3, all_status/2, any_status/2, limb_status/3, stage_status/3, stage_statuses/4, limbs_absent_keys/3, absent_keys/3, present_pairs/3, ordered_members/3, scope_ground/2, checklist_status/2, limb_items/3]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(library(reif), [memberd_t/3]).
:- use_module(formalize_lib, [profile_get/3, profile_has/2, profile_lacks/2]).
:- use_module(m__eu_data_protection_gdpr_territorial_material_scope_citations, [implements/1]).

scope_key_order([personal_data_processed, processing_wholly_or_partly_automated, personal_data_in_filing_system, activity_outside_union_law, member_state_common_foreign_security_activity, processing_by_natural_person, purely_personal_or_household_activity, processing_by_competent_authority, criminal_law_enforcement_purpose, processing_by_union_institution, party_role, established_in_union, processing_in_context_of_establishment_activities, data_subjects_in_union, offering_goods_or_services_to_data_subjects_in_union, monitoring_behaviour_of_data_subjects_in_union, member_state_law_applies_by_public_international_law, public_authority_or_body, occasional_processing, special_or_criminal_data_on_large_scale, unlikely_to_result_in_risk]).

citation_order([cite(eu_reg_2016_679_art_2_1), cite(eu_reg_2016_679_art_2_2_a), cite(eu_reg_2016_679_art_2_2_b), cite(eu_reg_2016_679_art_2_2_c), cite(eu_reg_2016_679_art_2_2_d), cite(eu_reg_2016_679_art_2_3), cite(eu_reg_2016_679_art_3_1), cite(eu_reg_2016_679_art_3_2_a), cite(eu_reg_2016_679_art_3_2_b), cite(eu_reg_2016_679_art_3_3), cite(eu_reg_2016_679_art_27_1), cite(eu_reg_2016_679_art_27_2_a), cite(eu_reg_2016_679_art_27_2_b), cite(public_international_law_member_state_law_applies)]).

judgement_citation(purely_personal_or_household_activity, cite(eu_reg_2016_679_art_2_2_c)).
judgement_citation(processing_in_context_of_establishment_activities, cite(eu_reg_2016_679_art_3_1)).
judgement_citation(offering_goods_or_services_to_data_subjects_in_union, cite(eu_reg_2016_679_art_3_2_a)).
judgement_citation(monitoring_behaviour_of_data_subjects_in_union, cite(eu_reg_2016_679_art_3_2_b)).
judgement_citation(occasional_processing, cite(eu_reg_2016_679_art_27_2_a)).
judgement_citation(special_or_criminal_data_on_large_scale, cite(eu_reg_2016_679_art_27_2_a)).
judgement_citation(unlikely_to_result_in_risk, cite(eu_reg_2016_679_art_27_2_a)).

limb_citation(s1_head, cite(eu_reg_2016_679_art_2_1)).
limb_citation(s1_means, cite(eu_reg_2016_679_art_2_1)).
limb_citation(x_a, cite(eu_reg_2016_679_art_2_2_a)).
limb_citation(x_b, cite(eu_reg_2016_679_art_2_2_b)).
limb_citation(x_c, cite(eu_reg_2016_679_art_2_2_c)).
limb_citation(x_d, cite(eu_reg_2016_679_art_2_2_d)).
limb_citation(x_e, cite(eu_reg_2016_679_art_2_3)).
limb_citation(l31, cite(eu_reg_2016_679_art_3_1)).
limb_citation(l32a, cite(eu_reg_2016_679_art_3_2_a)).
limb_citation(l32b, cite(eu_reg_2016_679_art_3_2_b)).
limb_citation(l33, cite(eu_reg_2016_679_art_3_3)).

stage_limbs(one, [s1_head, s1_means]).
stage_limbs(two, [x_a, x_b, x_c, x_d, x_e]).
stage_limbs(three, [l31, l32a, l32b, l33]).

limb_keys(s1_head, [personal_data_processed]).
limb_keys(s1_means, [processing_wholly_or_partly_automated, personal_data_in_filing_system]).
limb_keys(x_a, [activity_outside_union_law]).
limb_keys(x_b, [member_state_common_foreign_security_activity]).
limb_keys(x_c, [processing_by_natural_person, purely_personal_or_household_activity]).
limb_keys(x_d, [processing_by_competent_authority, criminal_law_enforcement_purpose]).
limb_keys(x_e, [processing_by_union_institution]).
limb_keys(l31, [established_in_union, processing_in_context_of_establishment_activities]).
limb_keys(l32a, [established_in_union, data_subjects_in_union, offering_goods_or_services_to_data_subjects_in_union]).
limb_keys(l32b, [established_in_union, data_subjects_in_union, monitoring_behaviour_of_data_subjects_in_union]).
limb_keys(l33, [party_role, established_in_union]).

open_rank(met, 0).
open_rank(unmet, 0).
open_rank(judgement, 1).
open_rank(fact, 2).
open_rank(absent, 3).

negated(met, unmet).
negated(unmet, met).
negated(judgement, judgement).
negated(fact, fact).
negated(absent, absent).

both_status(unmet, _, unmet).
both_status(First, unmet, unmet) :-
    dif(First, unmet).
both_status(First, Second, Result) :-
    dif(First, unmet),
    dif(Second, unmet),
    open_rank(First, FirstRank),
    open_rank(Second, SecondRank),
    higher_status(FirstRank, SecondRank, First, Second, Result).

either_status(met, _, met).
either_status(First, met, met) :-
    dif(First, met).
either_status(First, Second, Result) :-
    dif(First, met),
    dif(Second, met),
    open_rank(First, FirstRank),
    open_rank(Second, SecondRank),
    higher_status(FirstRank, SecondRank, First, Second, Result).

higher_status(FirstRank, SecondRank, First, _, First) :-
    FirstRank >= SecondRank.
higher_status(FirstRank, SecondRank, _, Second, Second) :-
    FirstRank < SecondRank.

all_status([], met).
all_status([Status|Statuses], Result) :-
    all_status(Statuses, Rest),
    both_status(Status, Rest, Result).

any_status([], unmet).
any_status([Status|Statuses], Result) :-
    any_status(Statuses, Rest),
    either_status(Status, Rest, Result).

reading(Profile, Key, met) :-
    profile_get(Profile, Key, true).
reading(Profile, Key, unmet) :-
    profile_get(Profile, Key, false).
reading(Profile, Key, judgement) :-
    profile_get(Profile, Key, unsure).
reading(Profile, Key, absent) :-
    profile_lacks(Profile, Key).

role_reading(Profile, met) :-
    profile_get(Profile, party_role, controller).
role_reading(Profile, unmet) :-
    profile_get(Profile, party_role, processor).
role_reading(Profile, absent) :-
    profile_lacks(Profile, party_role).

outside_fact_reading(Profile, met) :-
    profile_get(Profile, member_state_law_applies_by_public_international_law, attested(true, _)).
outside_fact_reading(Profile, unmet) :-
    profile_get(Profile, member_state_law_applies_by_public_international_law, attested(false, _)).
outside_fact_reading(Profile, fact) :-
    profile_lacks(Profile, member_state_law_applies_by_public_international_law).

limb_status(Profile, s1_head, Status) :-
    implements(eu_reg_2016_679_art_2_1),
    reading(Profile, personal_data_processed, Status).
limb_status(Profile, s1_means, Status) :-
    implements(eu_reg_2016_679_art_2_1),
    reading(Profile, processing_wholly_or_partly_automated, Automated),
    reading(Profile, personal_data_in_filing_system, Filing),
    either_status(Automated, Filing, Status).
limb_status(Profile, x_a, Status) :-
    implements(eu_reg_2016_679_art_2_2_a),
    reading(Profile, activity_outside_union_law, Status).
limb_status(Profile, x_b, Status) :-
    implements(eu_reg_2016_679_art_2_2_b),
    reading(Profile, member_state_common_foreign_security_activity, Status).
limb_status(Profile, x_c, Status) :-
    implements(eu_reg_2016_679_art_2_2_c),
    reading(Profile, processing_by_natural_person, Natural),
    reading(Profile, purely_personal_or_household_activity, Household),
    both_status(Natural, Household, Status).
limb_status(Profile, x_d, Status) :-
    implements(eu_reg_2016_679_art_2_2_d),
    reading(Profile, processing_by_competent_authority, Competent),
    reading(Profile, criminal_law_enforcement_purpose, Purpose),
    both_status(Competent, Purpose, Status).
limb_status(Profile, x_e, Status) :-
    implements(eu_reg_2016_679_art_2_3),
    reading(Profile, processing_by_union_institution, Status).
limb_status(Profile, l31, Status) :-
    implements(eu_reg_2016_679_art_3_1),
    reading(Profile, established_in_union, Established),
    reading(Profile, processing_in_context_of_establishment_activities, Context),
    both_status(Established, Context, Status).
limb_status(Profile, l32a, Status) :-
    implements(eu_reg_2016_679_art_3_2_a),
    reading(Profile, established_in_union, Established),
    negated(Established, NotEstablished),
    reading(Profile, data_subjects_in_union, Subjects),
    reading(Profile, offering_goods_or_services_to_data_subjects_in_union, Offering),
    all_status([NotEstablished, Subjects, Offering], Status).
limb_status(Profile, l32b, Status) :-
    implements(eu_reg_2016_679_art_3_2_b),
    reading(Profile, established_in_union, Established),
    negated(Established, NotEstablished),
    reading(Profile, data_subjects_in_union, Subjects),
    reading(Profile, monitoring_behaviour_of_data_subjects_in_union, Monitoring),
    all_status([NotEstablished, Subjects, Monitoring], Status).
limb_status(Profile, l33, Status) :-
    implements(eu_reg_2016_679_art_3_3),
    role_reading(Profile, Role),
    reading(Profile, established_in_union, Established),
    negated(Established, NotEstablished),
    outside_fact_reading(Profile, Fact),
    all_status([Role, NotEstablished, Fact], Status).

stage_status(Profile, one, Status) :-
    implements(eu_reg_2016_679_art_2_1),
    stage_limbs(one, Limbs),
    maplist(limb_status(Profile), Limbs, Statuses),
    all_status(Statuses, Status).
stage_status(Profile, two, Status) :-
    implements(eu_reg_2016_679_art_2_2_a),
    stage_limbs(two, Limbs),
    maplist(limb_status(Profile), Limbs, Statuses),
    any_status(Statuses, Exclusion),
    negated(Exclusion, Status).
stage_status(Profile, three, Status) :-
    implements(eu_reg_2016_679_art_3_1),
    stage_limbs(three, Limbs),
    maplist(limb_status(Profile), Limbs, Statuses),
    any_status(Statuses, Status).

stage_statuses(Profile, One, Two, Three) :-
    stage_status(Profile, one, One),
    stage_status(Profile, two, Two),
    stage_status(Profile, three, Three).

limbs_absent_keys([], _, []).
limbs_absent_keys([Limb|Limbs], Profile, Keys) :-
    limb_status(Profile, Limb, Status),
    limb_keys(Limb, LimbKeys),
    limb_missing(Status, Profile, LimbKeys, Mine),
    limbs_absent_keys(Limbs, Profile, Rest),
    append(Mine, Rest, Keys).

limb_missing(absent, Profile, LimbKeys, Mine) :-
    absent_keys(Profile, LimbKeys, Mine).
limb_missing(Status, _, _, []) :-
    dif(Status, absent).

absent_keys(_, [], []).
absent_keys(Profile, [Key|Keys], Absent) :-
    absent_keys(Profile, Keys, Rest),
    key_presence(Profile, Key, Presence),
    absent_step(Presence, Key, Rest, Absent).

key_presence(Profile, Key, absent) :-
    profile_lacks(Profile, Key).
key_presence(Profile, Key, present) :-
    profile_has(Profile, Key).

absent_step(absent, Key, Rest, [Key|Rest]).
absent_step(present, _, Rest, Rest).

present_pairs(_, [], []).
present_pairs(Profile, [Key|Keys], Pairs) :-
    present_pair(Profile, Key, Mine),
    present_pairs(Profile, Keys, Rest),
    append(Mine, Rest, Pairs).

present_pair(Profile, Key, [Key - Value]) :-
    profile_get(Profile, Key, Value).
present_pair(Profile, Key, []) :-
    profile_lacks(Profile, Key).

ordered_members([], _, []).
ordered_members([Member|Members], Collected, Ordered) :-
    memberd_t(Member, Collected, Truth),
    ordered_step(Truth, Member, Members, Collected, Ordered).

ordered_step(true, Member, Members, Collected, [Member|Rest]) :-
    ordered_members(Members, Collected, Rest).
ordered_step(false, _, Members, Collected, Rest) :-
    ordered_members(Members, Collected, Rest).

scope_ground(Profile, Ground) :-
    stage_statuses(Profile, One, Two, Three),
    all_status([One, Two, Three], Combined),
    ground_for(Combined, One, Two, Profile, Ground).

ground_for(unmet, One, Two, Profile, Ground) :-
    unmet_ground(One, Two, Profile, Ground).
ground_for(met, _, _, Profile, Ground) :-
    met_ground(Profile, Ground).
ground_for(absent, _, _, _, none).
ground_for(fact, _, _, _, none).
ground_for(judgement, _, _, _, none).

unmet_ground(unmet, _, _, art2_1_not_met).
unmet_ground(One, unmet, Profile, Ground) :-
    dif(One, unmet),
    exclusion_ground(Profile, Ground).
unmet_ground(One, Two, _, art3_not_met) :-
    dif(One, unmet),
    dif(Two, unmet).

exclusion_ground(Profile, Ground) :-
    implements(eu_reg_2016_679_art_2_2_a),
    maplist(limb_status(Profile), [x_a, x_b, x_c, x_d, x_e], Statuses),
    first_met_ground(Statuses, [art2_2_a, art2_2_b, art2_2_c, art2_2_d, art2_3], Ground).

met_ground(Profile, Ground) :-
    implements(eu_reg_2016_679_art_3_1),
    maplist(limb_status(Profile), [l31, l32a, l32b, l33], Statuses),
    first_met_ground(Statuses, [art3_1, art3_2_a, art3_2_b, art3_3], Ground).

first_met_ground([met|_], [Ground|_], Ground).
first_met_ground([Status|Statuses], [_|Grounds], Ground) :-
    dif(Status, met),
    first_met_ground(Statuses, Grounds, Ground).

checklist_status(met, met).
checklist_status(unmet, unmet).
checklist_status(absent, unknown).
checklist_status(fact, unknown).
checklist_status(judgement, unknown).

limb_items([], _, []).
limb_items([Limb|Limbs], Profile, [item(Limb, Status, Citation)|Items]) :-
    limb_status(Profile, Limb, LimbStatus),
    checklist_status(LimbStatus, Status),
    limb_citation(Limb, Citation),
    limb_items(Limbs, Profile, Items).

gdpr_territorial_material_scope_input_problems(Profile, Problems) :-
    attribute_list_t(Profile, IsAttributeList),
    profile_problems(IsAttributeList, Profile, Problems).

profile_problems(false, _, [wrong_type(profile)]).
profile_problems(true, Profile, Problems) :-
    Keys = [personal_data_processed, processing_wholly_or_partly_automated, personal_data_in_filing_system, activity_outside_union_law, member_state_common_foreign_security_activity, processing_by_natural_person, purely_personal_or_household_activity, processing_by_competent_authority, criminal_law_enforcement_purpose, processing_by_union_institution, party_role, established_in_union, processing_in_context_of_establishment_activities, data_subjects_in_union, offering_goods_or_services_to_data_subjects_in_union, monitoring_behaviour_of_data_subjects_in_union, member_state_law_applies_by_public_international_law, public_authority_or_body, occasional_processing, special_or_criminal_data_on_large_scale, unlikely_to_result_in_risk],
    unknown_keys(Profile, Keys, UnknownKeyProblems),
    key_problems(Keys, Profile, UnknownKeyProblems, Problems).

key_type(personal_data_processed, boolean).
key_type(processing_wholly_or_partly_automated, boolean).
key_type(personal_data_in_filing_system, boolean).
key_type(activity_outside_union_law, boolean).
key_type(member_state_common_foreign_security_activity, boolean).
key_type(processing_by_natural_person, boolean).
key_type(purely_personal_or_household_activity, judgement).
key_type(processing_by_competent_authority, boolean).
key_type(criminal_law_enforcement_purpose, boolean).
key_type(processing_by_union_institution, boolean).
key_type(party_role, enum([controller, processor])).
key_type(established_in_union, boolean).
key_type(processing_in_context_of_establishment_activities, judgement).
key_type(data_subjects_in_union, boolean).
key_type(offering_goods_or_services_to_data_subjects_in_union, judgement).
key_type(monitoring_behaviour_of_data_subjects_in_union, judgement).
key_type(member_state_law_applies_by_public_international_law, outside_fact).
key_type(public_authority_or_body, boolean).
key_type(occasional_processing, judgement).
key_type(special_or_criminal_data_on_large_scale, judgement).
key_type(unlikely_to_result_in_risk, judgement).

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
