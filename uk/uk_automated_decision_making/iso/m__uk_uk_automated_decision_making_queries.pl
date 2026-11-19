% SPDX-License-Identifier: EUPL-1.2
:- module(m__uk_uk_automated_decision_making_queries, [uk_automated_decision_making_profile_keys/1, uk_automated_decision_making_what_if/4, decision_based_entirely_or_partly_on_personal_data/0, meaningful_human_involvement_in_the_decision/0, decision_produces_a_legal_effect_for_the_data_subject/0, decision_has_a_similarly_significant_effect_for_the_data_subject/0, processing_for_the_decision_relies_on_article_6_1_ea/0, decision_based_entirely_or_partly_on_special_category_data/0, decision_based_entirely_on_processing_with_explicit_consent/0, uk_article_9_2_g_applies/0, decision_necessary_for_a_contract_with_the_data_subject/0, decision_required_or_authorised_by_law/0, decision_authorised_by_union_or_member_state_law_laying_down_suitable_measures/0, decision_based_on_explicit_consent/0, article_9_2_a_applies/0, eu_article_9_2_g_applies/0, suitable_measures_for_special_category_data_in_place/0, safeguards_provide_information_about_decisions/0, safeguards_enable_representations/0, safeguards_enable_human_intervention/0, safeguards_enable_contesting/0, unsure/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(formalize_lib, [profile_has/2, profile_lacks/2]).
:- use_module(m__uk_uk_automated_decision_making_kernel, [uk_automated_decision_making_input_problems/2]).
:- use_module(m__uk_uk_automated_decision_making_uk_automated_decision_making, [uk_automated_decision_making_status/2]).

decision_based_entirely_or_partly_on_personal_data.

meaningful_human_involvement_in_the_decision.

decision_produces_a_legal_effect_for_the_data_subject.

decision_has_a_similarly_significant_effect_for_the_data_subject.

processing_for_the_decision_relies_on_article_6_1_ea.

decision_based_entirely_or_partly_on_special_category_data.

decision_based_entirely_on_processing_with_explicit_consent.

uk_article_9_2_g_applies.

decision_necessary_for_a_contract_with_the_data_subject.

decision_required_or_authorised_by_law.

decision_authorised_by_union_or_member_state_law_laying_down_suitable_measures.

decision_based_on_explicit_consent.

article_9_2_a_applies.

eu_article_9_2_g_applies.

suitable_measures_for_special_category_data_in_place.

safeguards_provide_information_about_decisions.

safeguards_enable_representations.

safeguards_enable_human_intervention.

safeguards_enable_contesting.

unsure.

uk_automated_decision_making_profile_keys([decision_based_entirely_or_partly_on_personal_data, meaningful_human_involvement_in_the_decision, decision_produces_a_legal_effect_for_the_data_subject, decision_has_a_similarly_significant_effect_for_the_data_subject, processing_for_the_decision_relies_on_article_6_1_ea, decision_based_entirely_or_partly_on_special_category_data, decision_based_entirely_on_processing_with_explicit_consent, uk_article_9_2_g_applies, decision_necessary_for_a_contract_with_the_data_subject, decision_required_or_authorised_by_law, decision_authorised_by_union_or_member_state_law_laying_down_suitable_measures, decision_based_on_explicit_consent, article_9_2_a_applies, eu_article_9_2_g_applies, suitable_measures_for_special_category_data_in_place, safeguards_provide_information_about_decisions, safeguards_enable_representations, safeguards_enable_human_intervention, safeguards_enable_contesting]).

uk_automated_decision_making_what_if(Profile, OverriddenKey, NewValue, NewStatus) :-
    attribute_override(Profile, OverriddenKey, NewValue, Hypothesis),
    uk_automated_decision_making_status(Hypothesis, NewStatus).

attribute_override(Profile, Key, Value, Hypothesis) :-
    profile_has(Profile, Key),
    replace_attribute(Profile, Key, Value, Hypothesis).
attribute_override(Profile, Key, Value, Hypothesis) :-
    profile_lacks(Profile, Key),
    append(Profile, [attribute(Key, Value)], Hypothesis).

replace_attribute([], _, _, []).
replace_attribute([attribute(Key, _)|Attributes], Key, Value, [attribute(Key, Value)|NewAttributes]) :-
    replace_attribute(Attributes, Key, Value, NewAttributes).
replace_attribute([attribute(Other, OldValue)|Attributes], Key, Value, [attribute(Other, OldValue)|NewAttributes]) :-
    dif(Other, Key),
    replace_attribute(Attributes, Key, Value, NewAttributes).
