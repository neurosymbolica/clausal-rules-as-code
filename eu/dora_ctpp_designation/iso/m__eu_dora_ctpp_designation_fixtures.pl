% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_ctpp_designation_fixtures, [dora_ctpp_designation_subject/1, dora_ctpp_designation_profile_for/2, dora_ctpp_designation_assess/2]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_dora_ctpp_designation_dora_ctpp_designation, [decide_dora_ctpp_designation/2]).

dora_ctpp_designation_subject(fixture_step_1_fulfilled_exact_ten_percent).
dora_ctpp_designation_subject(fixture_impact_just_below_ten_percent).
dora_ctpp_designation_subject(fixture_financial_entity_provider).
dora_ctpp_designation_subject(fixture_not_a_provider).
dora_ctpp_designation_subject(fixture_tfeu_oversight_excluded).
dora_ctpp_designation_subject(fixture_intra_group_excluded).
dora_ctpp_designation_subject(fixture_single_member_state_excluded).
dora_ctpp_designation_subject(fixture_point_iv_one_fact_only).
dora_ctpp_designation_subject(fixture_step_1_fails_impact_split_categories).
dora_ctpp_designation_subject(fixture_o_sii_score_exactly_3000).
dora_ctpp_designation_subject(fixture_o_sii_score_3001).
dora_ctpp_designation_subject(fixture_two_o_siis).
dora_ctpp_designation_subject(fixture_three_o_siis).
dora_ctpp_designation_subject(fixture_two_other_systemic_entities).
dora_ctpp_designation_subject(fixture_three_other_systemic_entities).
dora_ctpp_designation_subject(fixture_substitutability_just_below).
dora_ctpp_designation_subject(fixture_migration_share_exactly_ten_percent).
dora_ctpp_designation_subject(fixture_pooled_payment_institutions).
dora_ctpp_designation_subject(fixture_pooled_payment_institutions_below).
dora_ctpp_designation_subject(fixture_synonym_alone).
dora_ctpp_designation_subject(fixture_missing_type).
dora_ctpp_designation_subject(fixture_missing_point_iv).
dora_ctpp_designation_subject(fixture_missing_substitutability).
dora_ctpp_designation_subject(fixture_lead_overseer_eiopa).
dora_ctpp_designation_subject(fixture_lead_overseer_tied_eba_eiopa).
dora_ctpp_designation_subject(fixture_duties_group_third_country).
dora_ctpp_designation_subject(fixture_duties_notification_only).
dora_ctpp_designation_subject(fixture_not_designated).
dora_ctpp_designation_subject(fixture_input_problems_float_and_duplicate).
dora_ctpp_designation_subject(fixture_directive_2013_36_type).
dora_ctpp_designation_subject(fixture_unbound_key).

base_provider_profile([attribute(dora_entity_type, ict_third_party_service_provider), attribute(provider_subject_to_article_127_2_tfeu_oversight_framework, false), attribute(provider_is_ict_intra_group_service_provider, false), attribute(provider_provides_ict_services_solely_in_one_member_state, false), attribute(financial_entities_served_are_active_only_in_that_member_state, false), attribute(systemic_impact_figures, [category_share_figures(credit_institution, 2, 20, 3000, 30000)]), attribute(g_sii_served_count, 1), attribute(o_sii_scores_of_o_siis_served, []), attribute(systemic_infrastructure_entities_served_count, 1), attribute(systemic_other_entities_served_count, 0), attribute(substitutability_figures, [category_substitutability_figures(credit_institution, 2, 0, 20)])]).

provider_with(Overrides, Profile) :-
    base_provider_profile(BaseProfile),
    foldl(override_attribute, Overrides, BaseProfile, Profile).

provider_without(DroppedKeys, Profile) :-
    base_provider_profile(BaseProfile),
    foldl(drop_attribute, DroppedKeys, BaseProfile, Profile).

override_attribute(attribute(ProfileKey, AttributeValue), ProfileIn, ProfileOut) :-
    set_attribute(ProfileIn, ProfileKey, AttributeValue, ProfileOut).

drop_attribute(ProfileKey, ProfileIn, ProfileOut) :-
    remove_attribute(ProfileIn, ProfileKey, ProfileOut).

set_attribute([], ProfileKey, AttributeValue, [attribute(ProfileKey, AttributeValue)]).
set_attribute([attribute(OtherKey, OtherValue)|RemainingAttributes], ProfileKey, AttributeValue, [attribute(OtherKey, OtherValue)|RevisedAttributes]) :-
    OtherKey \== ProfileKey,
    set_attribute(RemainingAttributes, ProfileKey, AttributeValue, RevisedAttributes).
set_attribute([attribute(OtherKey, _)|RemainingAttributes], ProfileKey, AttributeValue, [attribute(ProfileKey, AttributeValue)|RemainingAttributes]) :-
    OtherKey == ProfileKey.

remove_attribute([], _, []).
remove_attribute([attribute(OtherKey, OtherValue)|RemainingAttributes], ProfileKey, [attribute(OtherKey, OtherValue)|RevisedAttributes]) :-
    OtherKey \== ProfileKey,
    remove_attribute(RemainingAttributes, ProfileKey, RevisedAttributes).
remove_attribute([attribute(OtherKey, _)|RemainingAttributes], ProfileKey, RevisedAttributes) :-
    OtherKey == ProfileKey,
    remove_attribute(RemainingAttributes, ProfileKey, RevisedAttributes).

dora_ctpp_designation_profile_for(fixture_step_1_fulfilled_exact_ten_percent, Profile) :-
    provider_with([], Profile).
dora_ctpp_designation_profile_for(fixture_impact_just_below_ten_percent, Profile) :-
    provider_with([attribute(systemic_impact_figures, [category_share_figures(credit_institution, 2, 21, 3000, 30000)])], Profile).
dora_ctpp_designation_profile_for(fixture_financial_entity_provider, Profile) :-
    provider_with([attribute(dora_entity_type, credit_institution)], Profile).
dora_ctpp_designation_profile_for(fixture_not_a_provider, Profile) :-
    provider_with([attribute(dora_entity_type, none_of_the_listed_types)], Profile).
dora_ctpp_designation_profile_for(fixture_tfeu_oversight_excluded, Profile) :-
    provider_with([attribute(provider_subject_to_article_127_2_tfeu_oversight_framework, true)], Profile).
dora_ctpp_designation_profile_for(fixture_intra_group_excluded, Profile) :-
    provider_with([attribute(provider_is_ict_intra_group_service_provider, true)], Profile).
dora_ctpp_designation_profile_for(fixture_single_member_state_excluded, Profile) :-
    provider_with([attribute(provider_provides_ict_services_solely_in_one_member_state, true), attribute(financial_entities_served_are_active_only_in_that_member_state, true)], Profile).
dora_ctpp_designation_profile_for(fixture_point_iv_one_fact_only, Profile) :-
    provider_with([attribute(provider_provides_ict_services_solely_in_one_member_state, true)], Profile).
dora_ctpp_designation_profile_for(fixture_step_1_fails_impact_split_categories, Profile) :-
    provider_with([attribute(systemic_impact_figures, [category_share_figures(credit_institution, 2, 20, 1, 30000), category_share_figures(insurance_undertaking, 1, 20, 3000, 30000)])], Profile).
dora_ctpp_designation_profile_for(fixture_o_sii_score_exactly_3000, Profile) :-
    provider_with([attribute(g_sii_served_count, 0), attribute(o_sii_scores_of_o_siis_served, [3000])], Profile).
dora_ctpp_designation_profile_for(fixture_o_sii_score_3001, Profile) :-
    provider_with([attribute(g_sii_served_count, 0), attribute(o_sii_scores_of_o_siis_served, [3001])], Profile).
dora_ctpp_designation_profile_for(fixture_two_o_siis, Profile) :-
    provider_with([attribute(g_sii_served_count, 0), attribute(o_sii_scores_of_o_siis_served, [100, 200])], Profile).
dora_ctpp_designation_profile_for(fixture_three_o_siis, Profile) :-
    provider_with([attribute(g_sii_served_count, 0), attribute(o_sii_scores_of_o_siis_served, [100, 200, 300])], Profile).
dora_ctpp_designation_profile_for(fixture_two_other_systemic_entities, Profile) :-
    provider_with([attribute(systemic_infrastructure_entities_served_count, 0), attribute(systemic_other_entities_served_count, 2)], Profile).
dora_ctpp_designation_profile_for(fixture_three_other_systemic_entities, Profile) :-
    provider_with([attribute(systemic_infrastructure_entities_served_count, 0), attribute(systemic_other_entities_served_count, 3)], Profile).
dora_ctpp_designation_profile_for(fixture_substitutability_just_below, Profile) :-
    provider_with([attribute(substitutability_figures, [category_substitutability_figures(credit_institution, 1, 1, 11)])], Profile).
dora_ctpp_designation_profile_for(fixture_migration_share_exactly_ten_percent, Profile) :-
    provider_with([attribute(substitutability_figures, [category_substitutability_figures(credit_institution, 0, 2, 20)])], Profile).
dora_ctpp_designation_profile_for(fixture_pooled_payment_institutions, Profile) :-
    provider_with([attribute(systemic_impact_figures, [category_share_figures(payment_institution, 1, 10, 1, 10), category_share_figures(exempted_payment_institution, 1, 10, 1, 10)])], Profile).
dora_ctpp_designation_profile_for(fixture_pooled_payment_institutions_below, Profile) :-
    provider_with([attribute(systemic_impact_figures, [category_share_figures(payment_institution, 0, 10, 0, 10), category_share_figures(exempted_payment_institution, 1, 2, 1, 2)])], Profile).
dora_ctpp_designation_profile_for(fixture_synonym_alone, Profile) :-
    provider_with([attribute(systemic_impact_figures, [category_share_figures(exempted_payment_institution, 1, 2, 1, 2)])], Profile).
dora_ctpp_designation_profile_for(fixture_missing_type, []).
dora_ctpp_designation_profile_for(fixture_missing_point_iv, Profile) :-
    provider_without([provider_provides_ict_services_solely_in_one_member_state, financial_entities_served_are_active_only_in_that_member_state], Profile).
dora_ctpp_designation_profile_for(fixture_missing_substitutability, Profile) :-
    provider_without([substitutability_figures], Profile).
dora_ctpp_designation_profile_for(fixture_lead_overseer_eiopa, [attribute(total_assets_of_users_within_eba_responsibility, 100), attribute(total_assets_of_users_within_eiopa_responsibility, 101), attribute(total_assets_of_users_within_esma_responsibility, 100)]).
dora_ctpp_designation_profile_for(fixture_lead_overseer_tied_eba_eiopa, [attribute(total_assets_of_users_within_eba_responsibility, 101), attribute(total_assets_of_users_within_eiopa_responsibility, 101), attribute(total_assets_of_users_within_esma_responsibility, 100)]).
dora_ctpp_designation_profile_for(fixture_duties_group_third_country, [attribute(provider_designated_as_critical, true), attribute(provider_is_part_of_a_group, true), attribute(provider_established_in_third_country, true)]).
dora_ctpp_designation_profile_for(fixture_duties_notification_only, [attribute(provider_designated_as_critical, true), attribute(provider_is_part_of_a_group, false), attribute(provider_established_in_third_country, false)]).
dora_ctpp_designation_profile_for(fixture_not_designated, [attribute(provider_designated_as_critical, false), attribute(provider_is_part_of_a_group, true), attribute(provider_established_in_third_country, true)]).
dora_ctpp_designation_profile_for(fixture_input_problems_float_and_duplicate, [attribute(g_sii_served_count, FloatCount), attribute(provider_is_part_of_a_group, true), attribute(provider_is_part_of_a_group, false)]) :-
    FloatCount is float(1).
dora_ctpp_designation_profile_for(fixture_directive_2013_36_type, Profile) :-
    provider_with([attribute(dora_entity_type, institution_exempted_pursuant_to_directive_2013_36)], Profile).
dora_ctpp_designation_profile_for(fixture_unbound_key, [attribute(_UnboundKey, 1)]).

dora_ctpp_designation_assess(Subject, Result) :-
    dora_ctpp_designation_profile_for(Subject, Profile),
    decide_dora_ctpp_designation(Profile, Result).
