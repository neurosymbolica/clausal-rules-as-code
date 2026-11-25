% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_ctpp_designation_queries, [dora_ctpp_designation_profile_keys/1, dora_ctpp_designation_what_if/4]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_dora_ctpp_designation_kernel, [dora_ctpp_designation_input_problems/2]).
:- use_module(m__eu_dora_ctpp_designation_dora_ctpp_designation, [dora_ctpp_designation_status/2]).

dora_ctpp_designation_profile_keys([dora_entity_type, provider_subject_to_article_127_2_tfeu_oversight_framework, provider_is_ict_intra_group_service_provider, provider_provides_ict_services_solely_in_one_member_state, financial_entities_served_are_active_only_in_that_member_state, systemic_impact_figures, g_sii_served_count, o_sii_scores_of_o_siis_served, systemic_infrastructure_entities_served_count, systemic_other_entities_served_count, substitutability_figures, total_assets_of_users_within_eba_responsibility, total_assets_of_users_within_eiopa_responsibility, total_assets_of_users_within_esma_responsibility, provider_designated_as_critical, provider_is_part_of_a_group, provider_established_in_third_country]).

dora_ctpp_designation_what_if(Profile, OverriddenKey, NewValue, NewStatus) :-
    replace_or_add_attribute(Profile, OverriddenKey, NewValue, Hypothesis),
    dora_ctpp_designation_status(Hypothesis, NewStatus).

replace_or_add_attribute([], ProfileKey, NewValue, [attribute(ProfileKey, NewValue)]).
replace_or_add_attribute([attribute(OtherKey, OtherValue)|RemainingAttributes], ProfileKey, NewValue, [attribute(OtherKey, OtherValue)|RevisedAttributes]) :-
    OtherKey \== ProfileKey,
    replace_or_add_attribute(RemainingAttributes, ProfileKey, NewValue, RevisedAttributes).
replace_or_add_attribute([attribute(OtherKey, _)|RemainingAttributes], ProfileKey, NewValue, [attribute(ProfileKey, NewValue)|RemainingAttributes]) :-
    OtherKey == ProfileKey.

test(the_profile_schema_has_seventeen_keys) :-
    dora_ctpp_designation_profile_keys(ProfileKeys),
    length(ProfileKeys, 17).
test(what_if_replaces_a_present_key_in_place) :-
    replace_or_add_attribute([attribute(g_sii_served_count, 0), attribute(provider_is_part_of_a_group, true)], g_sii_served_count, 1, Revised),
    Revised == [attribute(g_sii_served_count, 1), attribute(provider_is_part_of_a_group, true)].
test(what_if_adds_an_absent_key) :-
    replace_or_add_attribute([], dora_entity_type, credit_institution, Revised),
    Revised == [attribute(dora_entity_type, credit_institution)].
test(what_if_re_evaluates_the_status) :-
    dora_ctpp_designation_what_if([], dora_entity_type, credit_institution, Status),
    Status == designation_not_applicable(financial_entity).

test(what_if_does_not_keep_the_old_status, fail) :-
    dora_ctpp_designation_what_if([], dora_entity_type, credit_institution, indeterminate(_)).
