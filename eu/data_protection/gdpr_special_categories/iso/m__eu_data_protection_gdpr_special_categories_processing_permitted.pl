% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_special_categories_processing_permitted, [decide_processing_permitted/2, processing_permitted_status/2, processing_permitted_checklist/2, processing_permitted_decision_resolvable/1, processing_permitted_status_values/1, decide_special_category_processing/2, processing_permitted/2, special_category_scope/2, special_category_outside_facts/2]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(library(pairs), [pairs_keys/2, pairs_values/2]).
:- use_module(m__eu_data_protection_gdpr_special_categories_kernel, [gdpr_special_categories_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_special_categories_citations, [implements/1]).
:- use_module(formalize_lib, [profile_get/3, profile_lacks/2]).

processing_permitted_status_values([eligible, ineligible]).

special_category(racial_or_ethnic_origin, judgement(reveals_racial_or_ethnic_origin), cite(eu_reg_2016_679_art_9_1)).
special_category(political_opinions, judgement(reveals_political_opinions), cite(eu_reg_2016_679_art_9_1)).
special_category(religious_or_philosophical_beliefs, judgement(reveals_religious_or_philosophical_beliefs), cite(eu_reg_2016_679_art_9_1)).
special_category(trade_union_membership, judgement(reveals_trade_union_membership), cite(eu_reg_2016_679_art_9_1)).
special_category(genetic_data, crisp(genetic_data_present), cite(eu_reg_2016_679_art_4_13)).
special_category(biometric_data, both(crisp(biometric_data_present), crisp(biometric_used_for_unique_identification)), cite(eu_reg_2016_679_art_4_14)).
special_category(health_data, judgement(concerns_health), cite(eu_reg_2016_679_art_4_15)).
special_category(sex_life_or_sexual_orientation, judgement(concerns_sex_life_or_sexual_orientation), cite(eu_reg_2016_679_art_9_1)).

exception_condition(art9_2_a, explicit_consent, crisp(explicit_consent_given), cite(eu_reg_2016_679_art_9_2_a)).
exception_condition(art9_2_a, specified_purposes, crisp(consent_purposes_specified), cite(eu_reg_2016_679_art_9_2_a)).
exception_condition(art9_2_a, consent_definition, judgement(consent_satisfies_definition), cite(eu_reg_2016_679_art_4_11)).
exception_condition(art9_2_a, no_legal_bar, blocking(prohibition_lifting_barred_by_law), cite(eu_reg_2016_679_art_9_2_a)).
exception_condition(art9_2_b, necessity, judgement(processing_necessary), cite(eu_reg_2016_679_art_9_2_b)).
exception_condition(art9_2_b, employment_social_security_field, crisp(employment_social_security_or_social_protection_field), cite(eu_reg_2016_679_art_9_2_b)).
exception_condition(art9_2_b, authorising_law, enabling(employment_law_or_collective_agreement_authorises), cite(eu_reg_2016_679_art_9_2_b)).
exception_condition(art9_2_b, appropriate_safeguards, judgement(appropriate_safeguards), cite(eu_reg_2016_679_art_9_2_b)).
exception_condition(art9_2_c, necessity, judgement(processing_necessary), cite(eu_reg_2016_679_art_9_2_c)).
exception_condition(art9_2_c, vital_interest, crisp(vital_interest_at_stake), cite(eu_reg_2016_679_art_9_2_c)).
exception_condition(art9_2_c, incapacity, crisp(data_subject_incapable_of_giving_consent), cite(eu_reg_2016_679_art_9_2_c)).
exception_condition(art9_2_d, not_for_profit_body, crisp(not_for_profit_body_with_specified_aim), cite(eu_reg_2016_679_art_9_2_d)).
exception_condition(art9_2_d, legitimate_activities, crisp(processing_in_course_of_legitimate_activities), cite(eu_reg_2016_679_art_9_2_d)).
exception_condition(art9_2_d, members_only, crisp(processing_relates_solely_to_members_or_regular_contacts), cite(eu_reg_2016_679_art_9_2_d)).
exception_condition(art9_2_d, no_external_disclosure, crisp(data_not_disclosed_outside_body_without_consent), cite(eu_reg_2016_679_art_9_2_d)).
exception_condition(art9_2_d, appropriate_safeguards, judgement(appropriate_safeguards), cite(eu_reg_2016_679_art_9_2_d)).
exception_condition(art9_2_e, manifestly_made_public, judgement(manifestly_made_public_by_data_subject), cite(eu_reg_2016_679_art_9_2_e)).
exception_condition(art9_2_f, necessity, judgement(processing_necessary), cite(eu_reg_2016_679_art_9_2_f)).
exception_condition(art9_2_f, legal_claims_purpose, crisp(purpose_is_legal_claims_or_judicial_capacity), cite(eu_reg_2016_679_art_9_2_f)).
exception_condition(art9_2_g, necessity, judgement(processing_necessary), cite(eu_reg_2016_679_art_9_2_g)).
exception_condition(art9_2_g, substantial_public_interest, judgement(substantial_public_interest), cite(eu_reg_2016_679_art_9_2_g)).
exception_condition(art9_2_g, authorising_law, enabling(substantial_public_interest_law_exists), cite(eu_reg_2016_679_art_9_2_g)).
exception_condition(art9_2_g, proportionate_law, judgement(authorising_law_proportionate_and_respects_essence), cite(eu_reg_2016_679_art_9_2_g)).
exception_condition(art9_2_g, suitable_measures, judgement(suitable_and_specific_measures), cite(eu_reg_2016_679_art_9_2_g)).
exception_condition(art9_2_h, necessity, judgement(processing_necessary), cite(eu_reg_2016_679_art_9_2_h)).
exception_condition(art9_2_h, health_care_purpose, crisp(purpose_is_health_or_social_care), cite(eu_reg_2016_679_art_9_2_h)).
exception_condition(art9_2_h, law_or_contract, either(enabling(health_care_law_basis_exists), crisp(pursuant_to_contract_with_health_professional)), cite(eu_reg_2016_679_art_9_2_h)).
exception_condition(art9_2_h, professional_secrecy, crisp(processed_under_professional_secrecy), cite(eu_reg_2016_679_art_9_3)).
exception_condition(art9_2_i, necessity, judgement(processing_necessary), cite(eu_reg_2016_679_art_9_2_i)).
exception_condition(art9_2_i, public_health_interest, judgement(public_health_public_interest), cite(eu_reg_2016_679_art_9_2_i)).
exception_condition(art9_2_i, authorising_law, enabling(public_health_law_basis_exists), cite(eu_reg_2016_679_art_9_2_i)).
exception_condition(art9_2_i, suitable_measures, judgement(suitable_and_specific_measures), cite(eu_reg_2016_679_art_9_2_i)).
exception_condition(art9_2_j, necessity, judgement(processing_necessary), cite(eu_reg_2016_679_art_9_2_j)).
exception_condition(art9_2_j, archiving_research_statistics_purpose, crisp(purpose_is_archiving_research_or_statistics), cite(eu_reg_2016_679_art_9_2_j)).
exception_condition(art9_2_j, article_89_1, judgement(accordance_with_article_89_1), cite(eu_reg_2016_679_art_9_2_j)).
exception_condition(art9_2_j, authorising_law, enabling(research_archiving_statistics_law_basis_exists), cite(eu_reg_2016_679_art_9_2_j)).
exception_condition(art9_2_j, proportionate_law, judgement(authorising_law_proportionate_and_respects_essence), cite(eu_reg_2016_679_art_9_2_j)).
exception_condition(art9_2_j, suitable_measures, judgement(suitable_and_specific_measures), cite(eu_reg_2016_679_art_9_2_j)).

exception_point(art9_2_a, [cite(eu_reg_2016_679_art_9_2_a)]).
exception_point(art9_2_b, [cite(eu_reg_2016_679_art_9_2_b)]).
exception_point(art9_2_c, [cite(eu_reg_2016_679_art_9_2_c)]).
exception_point(art9_2_d, [cite(eu_reg_2016_679_art_9_2_d)]).
exception_point(art9_2_e, [cite(eu_reg_2016_679_art_9_2_e)]).
exception_point(art9_2_f, [cite(eu_reg_2016_679_art_9_2_f)]).
exception_point(art9_2_g, [cite(eu_reg_2016_679_art_9_2_g)]).
exception_point(art9_2_h, [cite(eu_reg_2016_679_art_9_2_h), cite(eu_reg_2016_679_art_9_3)]).
exception_point(art9_2_i, [cite(eu_reg_2016_679_art_9_2_i)]).
exception_point(art9_2_j, [cite(eu_reg_2016_679_art_9_2_j)]).

outside_fact_row(prohibition_lifting_barred_by_law, cite(eu_reg_2016_679_art_9_2_a), cite(eu_reg_2016_679_art_9_2_a)).
outside_fact_row(employment_law_or_collective_agreement_authorises, cite(eu_reg_2016_679_art_9_2_b), cite(eu_reg_2016_679_art_9_2_b)).
outside_fact_row(substantial_public_interest_law_exists, cite(eu_reg_2016_679_art_9_2_g), cite(eu_reg_2016_679_art_9_2_g)).
outside_fact_row(health_care_law_basis_exists, cite(eu_reg_2016_679_art_9_2_h), cite(eu_reg_2016_679_art_9_2_h)).
outside_fact_row(public_health_law_basis_exists, cite(eu_reg_2016_679_art_9_2_i), cite(eu_reg_2016_679_art_9_2_i)).
outside_fact_row(research_archiving_statistics_law_basis_exists, cite(eu_reg_2016_679_art_9_2_j), cite(eu_reg_2016_679_art_9_2_j)).
outside_fact_row(criminal_data_authorising_law_exists, cite(eu_reg_2016_679_art_10), cite(eu_reg_2016_679_art_10)).
outside_fact_row(member_state_further_conditions_exist, cite(eu_reg_2016_679_art_9_1), cite(eu_reg_2016_679_art_9_4)).

cross_referral_row(employment_law_or_collective_agreement_authorises, [appropriate_safeguards, processing_necessary], not_attempted).
cross_referral_row(substantial_public_interest_law_exists, [authorising_law_proportionate_and_respects_essence, processing_necessary, substantial_public_interest, suitable_and_specific_measures], not_attempted).
cross_referral_row(health_care_law_basis_exists, [processing_necessary], not_attempted).
cross_referral_row(public_health_law_basis_exists, [processing_necessary, public_health_public_interest, suitable_and_specific_measures], not_attempted).
cross_referral_row(research_archiving_statistics_law_basis_exists, [accordance_with_article_89_1, authorising_law_proportionate_and_respects_essence, processing_necessary, suitable_and_specific_measures], not_attempted).
cross_referral_row(criminal_data_authorising_law_exists, [criminal_data_law_safeguards_appropriate], not_attempted).
cross_referral_row(member_state_further_conditions_exist, [concerns_health], attested_not_modelled).

scope_judgement(reveals_racial_or_ethnic_origin, cite(eu_reg_2016_679_art_9_1)).
scope_judgement(reveals_political_opinions, cite(eu_reg_2016_679_art_9_1)).
scope_judgement(reveals_religious_or_philosophical_beliefs, cite(eu_reg_2016_679_art_9_1)).
scope_judgement(reveals_trade_union_membership, cite(eu_reg_2016_679_art_9_1)).
scope_judgement(concerns_health, cite(eu_reg_2016_679_art_4_15)).
scope_judgement(concerns_sex_life_or_sexual_orientation, cite(eu_reg_2016_679_art_9_1)).

scope_referral_inputs([concerns_health, concerns_sex_life_or_sexual_orientation, reveals_political_opinions, reveals_racial_or_ethnic_origin, reveals_religious_or_philosophical_beliefs, reveals_trade_union_membership]).

judgement_row(scope, Key, Citation, Inputs) :-
    scope_judgement(Key, Citation),
    scope_referral_inputs(Inputs).
judgement_row(art9_2_a, consent_satisfies_definition, cite(eu_reg_2016_679_art_4_11), [consent_satisfies_definition]).
judgement_row(art9_2_b, appropriate_safeguards, cite(eu_reg_2016_679_art_9_2_b), [appropriate_safeguards, processing_necessary]).
judgement_row(art9_2_b, processing_necessary, cite(eu_reg_2016_679_art_9_2_b), [appropriate_safeguards, processing_necessary]).
judgement_row(art9_2_c, processing_necessary, cite(eu_reg_2016_679_art_9_2_c), [processing_necessary]).
judgement_row(art9_2_d, appropriate_safeguards, cite(eu_reg_2016_679_art_9_2_d), [appropriate_safeguards]).
judgement_row(art9_2_e, manifestly_made_public_by_data_subject, cite(eu_reg_2016_679_art_9_2_e), [manifestly_made_public_by_data_subject]).
judgement_row(art9_2_f, processing_necessary, cite(eu_reg_2016_679_art_9_2_f), [processing_necessary]).
judgement_row(art9_2_g, authorising_law_proportionate_and_respects_essence, cite(eu_reg_2016_679_art_9_2_g), [authorising_law_proportionate_and_respects_essence, processing_necessary, substantial_public_interest, suitable_and_specific_measures]).
judgement_row(art9_2_g, processing_necessary, cite(eu_reg_2016_679_art_9_2_g), [authorising_law_proportionate_and_respects_essence, processing_necessary, substantial_public_interest, suitable_and_specific_measures]).
judgement_row(art9_2_g, substantial_public_interest, cite(eu_reg_2016_679_art_9_2_g), [authorising_law_proportionate_and_respects_essence, processing_necessary, substantial_public_interest, suitable_and_specific_measures]).
judgement_row(art9_2_g, suitable_and_specific_measures, cite(eu_reg_2016_679_art_9_2_g), [authorising_law_proportionate_and_respects_essence, processing_necessary, substantial_public_interest, suitable_and_specific_measures]).
judgement_row(art9_2_h, processing_necessary, cite(eu_reg_2016_679_art_9_2_h), [processing_necessary]).
judgement_row(art9_2_i, processing_necessary, cite(eu_reg_2016_679_art_9_2_i), [processing_necessary, public_health_public_interest, suitable_and_specific_measures]).
judgement_row(art9_2_i, public_health_public_interest, cite(eu_reg_2016_679_art_9_2_i), [processing_necessary, public_health_public_interest, suitable_and_specific_measures]).
judgement_row(art9_2_i, suitable_and_specific_measures, cite(eu_reg_2016_679_art_9_2_i), [processing_necessary, public_health_public_interest, suitable_and_specific_measures]).
judgement_row(art9_2_j, accordance_with_article_89_1, cite(eu_reg_2016_679_art_9_2_j), [accordance_with_article_89_1, authorising_law_proportionate_and_respects_essence, processing_necessary, suitable_and_specific_measures]).
judgement_row(art9_2_j, authorising_law_proportionate_and_respects_essence, cite(eu_reg_2016_679_art_9_2_j), [accordance_with_article_89_1, authorising_law_proportionate_and_respects_essence, processing_necessary, suitable_and_specific_measures]).
judgement_row(art9_2_j, processing_necessary, cite(eu_reg_2016_679_art_9_2_j), [accordance_with_article_89_1, authorising_law_proportionate_and_respects_essence, processing_necessary, suitable_and_specific_measures]).
judgement_row(art9_2_j, suitable_and_specific_measures, cite(eu_reg_2016_679_art_9_2_j), [accordance_with_article_89_1, authorising_law_proportionate_and_respects_essence, processing_necessary, suitable_and_specific_measures]).
judgement_row(article_10, criminal_data_law_safeguards_appropriate, cite(eu_reg_2016_679_art_10), [criminal_data_law_safeguards_appropriate]).
judgement_row(article_9_4, concerns_health, cite(eu_reg_2016_679_art_4_15), [concerns_health]).

read_key(Profile, Key, Value) :-
    profile_get(Profile, Key, Value).
read_key(Profile, Key, absent) :-
    profile_lacks(Profile, Key).

test_outcome(Profile, crisp(Key), Outcome) :-
    read_key(Profile, Key, Value),
    crisp_outcome(Value, Key, Outcome).
test_outcome(Profile, judgement(Key), Outcome) :-
    read_key(Profile, Key, Value),
    judgement_outcome(Value, Key, Outcome).
test_outcome(Profile, enabling(Key), Outcome) :-
    read_key(Profile, Key, Value),
    enabling_outcome(Value, Key, Outcome).
test_outcome(Profile, blocking(Key), Outcome) :-
    read_key(Profile, Key, Value),
    blocking_outcome(Value, Outcome).
test_outcome(Profile, either(FirstTest, SecondTest), Outcome) :-
    test_outcome(Profile, FirstTest, FirstOutcome),
    test_outcome(Profile, SecondTest, SecondOutcome),
    or_outcomes([FirstOutcome, SecondOutcome], Outcome).
test_outcome(Profile, both(FirstTest, SecondTest), Outcome) :-
    test_outcome(Profile, FirstTest, FirstOutcome),
    test_outcome(Profile, SecondTest, SecondOutcome),
    and_outcomes([FirstOutcome, SecondOutcome], Outcome).

crisp_outcome(true, _, met).
crisp_outcome(false, _, unmet).
crisp_outcome(absent, Key, open([Key], [], [])).

judgement_outcome(true, _, met).
judgement_outcome(false, _, unmet).
judgement_outcome(unsure, Key, open([], [], [Key])).
judgement_outcome(absent, Key, open([Key], [], [])).

enabling_outcome(attested(true, _), _, met).
enabling_outcome(attested(false, _), _, unmet).
enabling_outcome(absent, Key, open([], [Key], [])).

blocking_outcome(attested(false, _), met).
blocking_outcome(attested(true, _), unmet).
blocking_outcome(absent, met).

and_outcomes(Outcomes, Outcome) :-
    foldl(and_step, Outcomes, conjunction(false, [], [], []), Accumulated),
    conjunction_outcome(Accumulated, Outcome).

and_step(met, Accumulated, Accumulated).
and_step(unmet, conjunction(_, Absent, Cross, Unsure), conjunction(true, Absent, Cross, Unsure)).
and_step(open(MoreAbsent, MoreCross, MoreUnsure), conjunction(Flag, Absent, Cross, Unsure), conjunction(Flag, AllAbsent, AllCross, AllUnsure)) :-
    append(Absent, MoreAbsent, AllAbsent),
    append(Cross, MoreCross, AllCross),
    append(Unsure, MoreUnsure, AllUnsure).

conjunction_outcome(conjunction(true, _, _, _), unmet).
conjunction_outcome(conjunction(false, Absent, Cross, Unsure), Outcome) :-
    open_outcome(Absent, Cross, Unsure, met, Outcome).

or_outcomes(Outcomes, Outcome) :-
    foldl(or_step, Outcomes, disjunction(false, [], [], []), Accumulated),
    disjunction_outcome(Accumulated, Outcome).

or_step(met, disjunction(_, Absent, Cross, Unsure), disjunction(true, Absent, Cross, Unsure)).
or_step(unmet, Accumulated, Accumulated).
or_step(open(MoreAbsent, MoreCross, MoreUnsure), disjunction(Flag, Absent, Cross, Unsure), disjunction(Flag, AllAbsent, AllCross, AllUnsure)) :-
    append(Absent, MoreAbsent, AllAbsent),
    append(Cross, MoreCross, AllCross),
    append(Unsure, MoreUnsure, AllUnsure).

disjunction_outcome(disjunction(true, _, _, _), met).
disjunction_outcome(disjunction(false, Absent, Cross, Unsure), Outcome) :-
    open_outcome(Absent, Cross, Unsure, unmet, Outcome).

open_outcome(Absent, Cross, Unsure, Empty, Outcome) :-
    sort(Absent, SortedAbsent),
    sort(Cross, SortedCross),
    sort(Unsure, SortedUnsure),
    append(SortedAbsent, SortedCross, Partial),
    append(Partial, SortedUnsure, Everything),
    open_or_empty(Everything, SortedAbsent, SortedCross, SortedUnsure, Empty, Outcome).

open_or_empty([], _, _, _, Empty, Empty).
open_or_empty([_|_], Absent, Cross, Unsure, _, open(Absent, Cross, Unsure)).

limb_contribution(met, [], [], []).
limb_contribution(unmet, [], [], []).
limb_contribution(open(Absent, Cross, Unsure), Absent, Cross, Unsure).

tag_keys(Keys, Source, Tagged) :-
    maplist(tagged_key(Source), Keys, Tagged).

tagged_key(Source, Key, Key - Source).

scope_evaluation(Profile, Outcome, TrueCategories) :-
    implements(eu_reg_2016_679_art_9_1),
    findall(Category - CategoryOutcome, category_outcome(Profile, Category, CategoryOutcome), Pairs),
    pairs_values(Pairs, Outcomes),
    or_outcomes(Outcomes, Outcome),
    findall(Category, member(Category - met, Pairs), TrueCategories).

category_outcome(Profile, Category, Outcome) :-
    special_category(Category, Test, _),
    test_outcome(Profile, Test, Outcome).

article_9_limb(Profile, art9_2_a, Outcome) :-
    implements(eu_reg_2016_679_art_9_2_a),
    conditions_outcome(Profile, art9_2_a, Outcome).
article_9_limb(Profile, art9_2_b, Outcome) :-
    implements(eu_reg_2016_679_art_9_2_b),
    conditions_outcome(Profile, art9_2_b, Outcome).
article_9_limb(Profile, art9_2_c, Outcome) :-
    implements(eu_reg_2016_679_art_9_2_c),
    conditions_outcome(Profile, art9_2_c, Outcome).
article_9_limb(Profile, art9_2_d, Outcome) :-
    implements(eu_reg_2016_679_art_9_2_d),
    conditions_outcome(Profile, art9_2_d, Outcome).
article_9_limb(Profile, art9_2_e, Outcome) :-
    implements(eu_reg_2016_679_art_9_2_e),
    conditions_outcome(Profile, art9_2_e, Outcome).
article_9_limb(Profile, art9_2_f, Outcome) :-
    implements(eu_reg_2016_679_art_9_2_f),
    conditions_outcome(Profile, art9_2_f, Outcome).
article_9_limb(Profile, art9_2_g, Outcome) :-
    implements(eu_reg_2016_679_art_9_2_g),
    conditions_outcome(Profile, art9_2_g, Outcome).
article_9_limb(Profile, art9_2_h, Outcome) :-
    implements(eu_reg_2016_679_art_9_2_h),
    implements(eu_reg_2016_679_art_9_3),
    conditions_outcome(Profile, art9_2_h, Outcome).
article_9_limb(Profile, art9_2_i, Outcome) :-
    implements(eu_reg_2016_679_art_9_2_i),
    conditions_outcome(Profile, art9_2_i, Outcome).
article_9_limb(Profile, art9_2_j, Outcome) :-
    implements(eu_reg_2016_679_art_9_2_j),
    conditions_outcome(Profile, art9_2_j, Outcome).

exception_conditions(Exception, Conditions) :-
    findall(Condition, exception_condition(Exception, Condition, _, _), Conditions).

conditions_outcome(Profile, Exception, Outcome) :-
    exception_conditions(Exception, Conditions),
    maplist(condition_outcome(Profile, Exception), Conditions, Outcomes),
    and_outcomes(Outcomes, Outcome).

condition_outcome(Profile, Exception, Condition, Outcome) :-
    exception_condition(Exception, Condition, Test, _),
    test_outcome(Profile, Test, Outcome).

article_9_part(unmet, _, _, na).
article_9_part(met, absent, _, unmet([cite(eu_reg_2016_679_art_9_1)])) :-
    implements(eu_reg_2016_679_art_9_1).
article_9_part(met, Claim, Profile, Part) :-
    exception_point(Claim, _),
    article_9_limb(Profile, Claim, Limb),
    article_9_in_scope(Limb, Claim, Part).
article_9_part(open(Absent, Cross, Unsure), absent, _, open(Absent, Cross, Tagged)) :-
    tag_keys(Unsure, scope, Tagged).
article_9_part(open(ScopeAbsent, ScopeCross, ScopeUnsure), Claim, Profile, open(Absent, Cross, Tagged)) :-
    exception_point(Claim, _),
    article_9_limb(Profile, Claim, Limb),
    limb_contribution(Limb, LimbAbsent, LimbCross, LimbUnsure),
    append(ScopeAbsent, LimbAbsent, AllAbsent),
    sort(AllAbsent, Absent),
    append(ScopeCross, LimbCross, Cross),
    tag_keys(ScopeUnsure, scope, ScopeTagged),
    tag_keys(LimbUnsure, Claim, LimbTagged),
    append(ScopeTagged, LimbTagged, Tagged).

article_9_in_scope(met, Claim, met([Claim], Conditions, [cite(eu_reg_2016_679_art_9_1)|PointCitations])) :-
    exception_conditions(Claim, Conditions),
    exception_point(Claim, PointCitations).
article_9_in_scope(unmet, _, unmet([cite(eu_reg_2016_679_art_9_1)])).
article_9_in_scope(open(Absent, Cross, Unsure), Claim, open(Absent, Cross, Tagged)) :-
    tag_keys(Unsure, Claim, Tagged).

article_9_4_part(_, na, na).
article_9_4_part(_, unmet(_), na).
article_9_4_part(_, open(_, _, _), na).
article_9_4_part(Profile, met(_, _, _), Part) :-
    implements(eu_reg_2016_679_art_9_4),
    read_key(Profile, member_state_further_conditions_exist, Fact),
    fact_state(Fact, State),
    genetic_biometric_health_outcome(Profile, Applicability),
    further_conditions(State, Applicability, Part).

fact_state(absent, absent).
fact_state(attested(Value, _), Value).

genetic_biometric_health_outcome(Profile, Outcome) :-
    implements(eu_reg_2016_679_art_9_4),
    test_outcome(Profile, crisp(genetic_data_present), GeneticOutcome),
    test_outcome(Profile, crisp(biometric_data_present), BiometricOutcome),
    test_outcome(Profile, judgement(concerns_health), HealthOutcome),
    or_outcomes([GeneticOutcome, BiometricOutcome, HealthOutcome], Outcome).

further_conditions(absent, _, na).
further_conditions(true, met, open([], [member_state_further_conditions_exist], [])).
further_conditions(false, met, met([], [no_further_conditions], [cite(eu_reg_2016_679_art_9_4)])).
further_conditions(true, unmet, na).
further_conditions(false, unmet, na).
further_conditions(true, open(Absent, Cross, Unsure), open(Absent, Cross, Tagged)) :-
    tag_keys(Unsure, article_9_4, Tagged).
further_conditions(false, open(Absent, Cross, Unsure), open(Absent, Cross, Tagged)) :-
    tag_keys(Unsure, article_9_4, Tagged).

article_10_route_a(Profile, Outcome) :-
    implements(eu_reg_2016_679_art_10),
    test_outcome(Profile, crisp(processing_under_official_authority_control), Outcome).

article_10_route_b(Profile, Outcome) :-
    implements(eu_reg_2016_679_art_10),
    read_key(Profile, comprehensive_register_of_criminal_convictions, Register),
    register_defeater(Register, Profile, Outcome).

register_defeater(true, _, unmet).
register_defeater(false, Profile, Outcome) :-
    authorised_by_law_outcome(Profile, Outcome).
register_defeater(absent, Profile, Outcome) :-
    authorised_by_law_outcome(Profile, Outcome).

authorised_by_law_outcome(Profile, Outcome) :-
    implements(eu_reg_2016_679_art_10),
    test_outcome(Profile, enabling(criminal_data_authorising_law_exists), LawOutcome),
    test_outcome(Profile, judgement(criminal_data_law_safeguards_appropriate), SafeguardsOutcome),
    and_outcomes([LawOutcome, SafeguardsOutcome], Outcome).

article_10_part(Profile, Part) :-
    implements(eu_reg_2016_679_art_10),
    test_outcome(Profile, crisp(criminal_offence_data_present), ScopeOutcome),
    article_10_route_a(Profile, RouteOutcome),
    article_10_route_b(Profile, LawRouteOutcome),
    or_outcomes([RouteOutcome, LawRouteOutcome], LimbOutcome),
    article_10_part_from(ScopeOutcome, LimbOutcome, RouteOutcome, Part).

article_10_part_from(unmet, _, _, na).
article_10_part_from(met, met, RouteOutcome, met([Basis], Conditions, [cite(eu_reg_2016_679_art_10)])) :-
    article_10_route_basis(RouteOutcome, Basis, Conditions).
article_10_part_from(met, unmet, _, unmet([cite(eu_reg_2016_679_art_10)])).
article_10_part_from(met, open(Absent, Cross, Unsure), _, open(Absent, Cross, Tagged)) :-
    tag_keys(Unsure, article_10, Tagged).
article_10_part_from(open(ScopeAbsent, ScopeCross, ScopeUnsure), Limb, _, open(Absent, Cross, Tagged)) :-
    limb_contribution(Limb, LimbAbsent, LimbCross, LimbUnsure),
    append(ScopeAbsent, LimbAbsent, AllAbsent),
    sort(AllAbsent, Absent),
    append(ScopeCross, LimbCross, Cross),
    append(ScopeUnsure, LimbUnsure, Unsure),
    tag_keys(Unsure, article_10, Tagged).

article_10_route_basis(met, art10_official_authority, [official_authority]).
article_10_route_basis(unmet, art10_authorised_by_law, [authorising_law, appropriate_safeguards]).
article_10_route_basis(open(_, _, _), art10_authorised_by_law, [authorising_law, appropriate_safeguards]).

evaluation(Profile, Claim, ScopeOutcome, ArticleNinePart, FurtherConditionsPart, ArticleTenPart) :-
    read_key(Profile, exception_claimed, Claim),
    scope_evaluation(Profile, ScopeOutcome, _),
    article_9_part(ScopeOutcome, Claim, Profile, ArticleNinePart),
    article_9_4_part(Profile, ArticleNinePart, FurtherConditionsPart),
    article_10_part(Profile, ArticleTenPart).

part_unmet_citations(na, []).
part_unmet_citations(met(_, _, _), []).
part_unmet_citations(unmet(Citations), Citations).
part_unmet_citations(open(_, _, _), []).

part_absent(na, []).
part_absent(met(_, _, _), []).
part_absent(unmet(_), []).
part_absent(open(Absent, _, _), Absent).

part_cross(na, []).
part_cross(met(_, _, _), []).
part_cross(unmet(_), []).
part_cross(open(_, Cross, _), Cross).

part_unsure(na, []).
part_unsure(met(_, _, _), []).
part_unsure(unmet(_), []).
part_unsure(open(_, _, Unsure), Unsure).

part_bases(na, []).
part_bases(met(Bases, _, _), Bases).

part_conditions(na, []).
part_conditions(met(_, Conditions, _), Conditions).

part_citations(na, []).
part_citations(met(_, _, Citations), Citations).

assemble(Profile, Claim, ArticleNinePart, FurtherConditionsPart, ArticleTenPart, Verdict) :-
    maplist(part_unmet_citations, [ArticleNinePart, ArticleTenPart], UnmetLists),
    append(UnmetLists, UnmetCitations),
    after_unmet(UnmetCitations, Profile, Claim, ArticleNinePart, FurtherConditionsPart, ArticleTenPart, Verdict).

after_unmet([Citation|Citations], _, _, _, _, _, special_category_verdict(ineligible, [], [], SortedCitations)) :-
    implements(eu_reg_2016_679_art_9_1),
    sort([Citation|Citations], SortedCitations).
after_unmet([], Profile, Claim, ArticleNinePart, FurtherConditionsPart, ArticleTenPart, Verdict) :-
    maplist(part_absent, [ArticleNinePart, ArticleTenPart, FurtherConditionsPart], AbsentLists),
    append(AbsentLists, AllAbsent),
    sort(AllAbsent, Absent),
    after_absence(Absent, Profile, Claim, ArticleNinePart, FurtherConditionsPart, ArticleTenPart, Verdict).

after_absence([Key|Keys], _, _, _, _, _, special_category_verdict(indeterminate([Key|Keys]), [], [], [])).
after_absence([], Profile, Claim, ArticleNinePart, FurtherConditionsPart, ArticleTenPart, Verdict) :-
    maplist(part_cross, [ArticleNinePart, ArticleTenPart, FurtherConditionsPart], CrossLists),
    append(CrossLists, Cross),
    after_cross(Cross, Profile, Claim, ArticleNinePart, FurtherConditionsPart, ArticleTenPart, Verdict).

after_cross([FactKey|_], Profile, Claim, _, _, _, special_category_verdict(needs_legal_review(Reason, Context), [], [], [])) :-
    cross_referral(Profile, Claim, FactKey, Reason, Context).
after_cross([], Profile, Claim, ArticleNinePart, FurtherConditionsPart, ArticleTenPart, Verdict) :-
    maplist(part_unsure, [ArticleNinePart, ArticleTenPart, FurtherConditionsPart], UnsureLists),
    append(UnsureLists, Unsure),
    keysort(Unsure, SortedUnsure),
    after_unsure(SortedUnsure, Profile, Claim, ArticleNinePart, FurtherConditionsPart, ArticleTenPart, Verdict).

after_unsure([Key - Source|_], Profile, Claim, _, _, _, special_category_verdict(needs_legal_review(Reason, Context), [], [], [])) :-
    judgement_referral(Profile, Claim, Key - Source, Reason, Context).
after_unsure([], _, _, ArticleNinePart, FurtherConditionsPart, ArticleTenPart, Verdict) :-
    maplist(part_bases, [ArticleNinePart, FurtherConditionsPart, ArticleTenPart], BasesLists),
    append(BasesLists, Bases),
    maplist(part_conditions, [ArticleNinePart, FurtherConditionsPart, ArticleTenPart], ConditionLists),
    append(ConditionLists, Conditions),
    maplist(part_citations, [ArticleNinePart, FurtherConditionsPart, ArticleTenPart], CitationLists),
    append(CitationLists, Citations),
    eligible_verdict(Bases, Conditions, Citations, Verdict).

eligible_verdict([], _, _, special_category_verdict(eligible, [not_special_category_data], [], Citations)) :-
    implements(eu_reg_2016_679_art_9_1),
    implements(eu_reg_2016_679_art_10),
    sort([cite(eu_reg_2016_679_art_9_1), cite(eu_reg_2016_679_art_10)], Citations).
eligible_verdict([Basis|Bases], Conditions, Citations, special_category_verdict(eligible, [Basis|Bases], Conditions, SortedCitations)) :-
    sort(Citations, SortedCitations).

cross_referral(Profile, Claim, FactKey, cross_reference_unresolved(Citation, Target), [resolution(Target, Status), inputs_relied_on([exception_claimed - Claim|Pairs])]) :-
    outside_fact_row(FactKey, Citation, Target),
    cross_referral_row(FactKey, Inputs, Status),
    present_pairs(Profile, Inputs, InputPairs),
    absent_fact_pair(Status, FactKey, InputPairs, AllPairs),
    keysort(AllPairs, Pairs).

absent_fact_pair(not_attempted, FactKey, Pairs, [FactKey - absent|Pairs]).
absent_fact_pair(attested_not_modelled, _, Pairs, Pairs).

judgement_referral(Profile, Claim, Key - Source, open_textured(Key, Citation), [inputs_relied_on([exception_claimed - Claim|Pairs])]) :-
    judgement_row(Source, Key, Citation, Inputs),
    present_pairs(Profile, Inputs, InputPairs),
    keysort(InputPairs, Pairs).

present_pairs(_, [], []).
present_pairs(Profile, [Key|Keys], Pairs) :-
    read_key(Profile, Key, Value),
    present_pairs(Profile, Keys, LaterPairs),
    add_pair(Value, Key, LaterPairs, Pairs).

add_pair(absent, _, Pairs, Pairs).
add_pair(Value, Key, Pairs, [Key - Value|Pairs]) :-
    dif(Value, absent).

decide_special_category_processing(Profile, special_category_verdict(input_problems([Problem|Problems]), [], [], [])) :-
    gdpr_special_categories_input_problems(Profile, [Problem|Problems]).
decide_special_category_processing(Profile, Verdict) :-
    gdpr_special_categories_input_problems(Profile, []),
    evaluation(Profile, Claim, _, ArticleNinePart, FurtherConditionsPart, ArticleTenPart),
    assemble(Profile, Claim, ArticleNinePart, FurtherConditionsPart, ArticleTenPart, Verdict).

processing_permitted(Profile, Status) :-
    decide_special_category_processing(Profile, special_category_verdict(Status, _, _, _)).

special_category_scope(Profile, input_problems([Problem|Problems])) :-
    gdpr_special_categories_input_problems(Profile, [Problem|Problems]).
special_category_scope(Profile, Scope) :-
    gdpr_special_categories_input_problems(Profile, []),
    scope_evaluation(Profile, Outcome, TrueCategories),
    read_key(Profile, exception_claimed, Claim),
    scope_answer(Outcome, TrueCategories, Profile, Claim, Scope).

scope_answer(met, TrueCategories, _, _, TrueCategories).
scope_answer(unmet, _, _, _, []).
scope_answer(open([Key|Keys], _, _), _, _, _, indeterminate([Key|Keys])).
scope_answer(open([], _, [Key|_]), _, Profile, Claim, needs_legal_review(Reason, Context)) :-
    judgement_referral(Profile, Claim, Key - scope, Reason, Context).

special_category_outside_facts(Profile, input_problems([Problem|Problems])) :-
    gdpr_special_categories_input_problems(Profile, [Problem|Problems]).
special_category_outside_facts(Profile, Items) :-
    gdpr_special_categories_input_problems(Profile, []),
    findall(outside_fact(Key, Attested), outside_fact_item(Profile, Key, Attested), Items).

outside_fact_item(Profile, Key, Attested) :-
    outside_fact_row(Key, _, _),
    read_key(Profile, Key, Attested).

decide_processing_permitted(Profile, processing_permitted_verdict(Status, Citations)) :-
    decide_special_category_processing(Profile, special_category_verdict(Status, _, _, Citations)).

processing_permitted_status(Profile, Status) :-
    decide_processing_permitted(Profile, processing_permitted_verdict(Status, _)).

processing_permitted_decision_resolvable(Profile) :-
    decide_special_category_processing(Profile, _).

processing_permitted_checklist(Profile, []) :-
    gdpr_special_categories_input_problems(Profile, [_|_]).
processing_permitted_checklist(Profile, Items) :-
    gdpr_special_categories_input_problems(Profile, []),
    evaluation(Profile, Claim, ScopeOutcome, _, FurtherConditionsPart, ArticleTenPart),
    outcome_item(ScopeOutcome, article_9_1_scope, ScopeItemOutcome),
    condition_items(Profile, Claim, ConditionItems),
    part_item(article_9_4, FurtherConditionsPart, cite(eu_reg_2016_679_art_9_4), FurtherConditionsItem),
    part_item(article_10, ArticleTenPart, cite(eu_reg_2016_679_art_10), ArticleTenItem),
    append([[item(article_9_1_scope, ScopeItemOutcome, cite(eu_reg_2016_679_art_9_1))], ConditionItems, [FurtherConditionsItem, ArticleTenItem]], Items).

condition_items(_, absent, []).
condition_items(Profile, Claim, Items) :-
    exception_point(Claim, _),
    findall(item(Condition, ItemOutcome, Citation), condition_item(Profile, Claim, Condition, ItemOutcome, Citation), Items).

condition_item(Profile, Claim, Condition, ItemOutcome, Citation) :-
    exception_condition(Claim, Condition, Test, Citation),
    test_outcome(Profile, Test, Outcome),
    outcome_item(Outcome, Condition, ItemOutcome).

outcome_item(met, _, met).
outcome_item(unmet, Name, unmet(Name)).
outcome_item(open([Key|Keys], _, _), _, open_by_absence([Key|Keys])).
outcome_item(open([], [Key|_], _), _, open_by_cross_reference(Key)).
outcome_item(open([], [], [Key|_]), _, open_by_judgement(Key)).

part_item(Identifier, na, Citation, item(Identifier, not_applicable, Citation)).
part_item(Identifier, met(_, _, _), Citation, item(Identifier, met, Citation)).
part_item(Identifier, unmet(_), Citation, item(Identifier, unmet(Identifier), Citation)).
part_item(Identifier, open(Absent, Cross, Unsure), Citation, item(Identifier, ItemOutcome, Citation)) :-
    pairs_keys(Unsure, UnsureKeys),
    outcome_item(open(Absent, Cross, UnsureKeys), Identifier, ItemOutcome).

no_category_profile([attribute(reveals_racial_or_ethnic_origin, false), attribute(reveals_political_opinions, false), attribute(reveals_religious_or_philosophical_beliefs, false), attribute(reveals_trade_union_membership, false), attribute(genetic_data_present, false), attribute(biometric_data_present, false), attribute(concerns_health, false), attribute(concerns_sex_life_or_sexual_orientation, false), attribute(criminal_offence_data_present, false)]).

consent_profile([attribute(exception_claimed, art9_2_a), attribute(concerns_health, true), attribute(criminal_offence_data_present, false), attribute(explicit_consent_given, true), attribute(consent_purposes_specified, true), attribute(consent_satisfies_definition, true)]).

test(no_special_category_data_is_eligible_once) :-
    no_category_profile(Profile),
    findall(Verdict, decide_special_category_processing(Profile, Verdict), Verdicts),
    Verdicts == [special_category_verdict(eligible, [not_special_category_data], [], [cite(eu_reg_2016_679_art_10), cite(eu_reg_2016_679_art_9_1)])].
test(health_with_explicit_consent_is_eligible) :-
    consent_profile(Profile),
    findall(Verdict, decide_special_category_processing(Profile, Verdict), Verdicts),
    Verdicts == [special_category_verdict(eligible, [art9_2_a], [explicit_consent, specified_purposes, consent_definition, no_legal_bar], [cite(eu_reg_2016_679_art_9_1), cite(eu_reg_2016_679_art_9_2_a)])].
test(health_without_a_claim_is_ineligible) :-
    processing_permitted([attribute(concerns_health, true), attribute(criminal_offence_data_present, false)], ineligible).
test(further_conditions_attested_false_are_applied) :-
    consent_profile(Base),
    Profile = [attribute(member_state_further_conditions_exist, attested(false, attestation(host, now, reason, none)))|Base],
    decide_special_category_processing(Profile, special_category_verdict(eligible, [art9_2_a], [explicit_consent, specified_purposes, consent_definition, no_legal_bar, no_further_conditions], [cite(eu_reg_2016_679_art_9_1), cite(eu_reg_2016_679_art_9_2_a), cite(eu_reg_2016_679_art_9_4)])).
test(further_conditions_attested_true_are_referred) :-
    consent_profile(Base),
    Profile = [attribute(member_state_further_conditions_exist, attested(true, attestation(host, now, reason, none)))|Base],
    processing_permitted(Profile, needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_9_1), cite(eu_reg_2016_679_art_9_4)), [resolution(cite(eu_reg_2016_679_art_9_4), attested_not_modelled), inputs_relied_on([exception_claimed - art9_2_a, concerns_health - true])])).
test(worked_example_of_the_pairs_rule) :-
    Profile = [attribute(genetic_data_present, false), attribute(biometric_data_present, false), attribute(criminal_offence_data_present, false), attribute(concerns_health, false), attribute(concerns_sex_life_or_sexual_orientation, unsure), attribute(reveals_political_opinions, false), attribute(reveals_racial_or_ethnic_origin, false), attribute(reveals_religious_or_philosophical_beliefs, unsure), attribute(reveals_trade_union_membership, unsure)],
    processing_permitted(Profile, needs_legal_review(open_textured(concerns_sex_life_or_sexual_orientation, cite(eu_reg_2016_679_art_9_1)), [inputs_relied_on([exception_claimed - absent, concerns_health - false, concerns_sex_life_or_sexual_orientation - unsure, reveals_political_opinions - false, reveals_racial_or_ethnic_origin - false, reveals_religious_or_philosophical_beliefs - unsure, reveals_trade_union_membership - unsure])])).
test(official_authority_route_for_offence_data) :-
    no_category_profile(Base),
    select(attribute(criminal_offence_data_present, false), Base, Rest),
    Profile = [attribute(criminal_offence_data_present, true), attribute(processing_under_official_authority_control, true)|Rest],
    decide_special_category_processing(Profile, special_category_verdict(eligible, [art10_official_authority], [official_authority], [cite(eu_reg_2016_679_art_10)])).
test(an_empty_profile_is_indeterminate) :-
    processing_permitted([], indeterminate(Missing)),
    member(genetic_data_present, Missing),
    member(criminal_offence_data_present, Missing).
test(scope_lists_the_true_categories) :-
    special_category_scope([attribute(concerns_health, true), attribute(reveals_political_opinions, true)], [political_opinions, health_data]).
test(outside_facts_follow_the_block_order) :-
    special_category_outside_facts([], [outside_fact(prohibition_lifting_barred_by_law, absent)|Rest]),
    length(Rest, 7).
test(an_unknown_key_is_an_input_problem) :-
    special_category_scope([attribute(colour, red)], input_problems([unknown_key(colour)])).

test(health_without_a_claim_is_not_eligible, fail) :-
    processing_permitted([attribute(concerns_health, true), attribute(criminal_offence_data_present, false)], eligible).
