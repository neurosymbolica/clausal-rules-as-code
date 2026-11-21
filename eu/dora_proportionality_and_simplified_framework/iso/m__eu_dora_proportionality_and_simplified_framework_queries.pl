% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_proportionality_and_simplified_framework_queries, [dora_proportionality_and_simplified_framework_profile_keys/1, dora_proportionality_and_simplified_framework_what_if/4]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_dora_proportionality_and_simplified_framework_kernel, [dora_proportionality_and_simplified_framework_input_problems/2]).
:- use_module(m__eu_dora_proportionality_and_simplified_framework_dora_proportionality_and_simplified_framework, [dora_proportionality_and_simplified_framework_status/2]).

dora_proportionality_and_simplified_framework_profile_keys([dora_entity_type, investment_firm_is_small_and_non_interconnected, iorp_pension_scheme_members_total, exempted_from_dora_scope_by_member_state, authority_requested_framework_review_report, simplified_framework_in_place_and_maintained, ict_systems_continuously_monitored, ict_risk_impact_minimised_with_sound_systems, risk_sources_detected_and_incidents_handled, key_ict_third_party_dependencies_identified, continuity_of_critical_functions_ensured, plans_and_controls_tested_regularly, test_and_incident_conclusions_implemented, awareness_and_training_programmes_developed, simplified_framework_documented_and_reviewed, simplified_framework_continuously_improved, simplified_framework_review_report_submitted]).

dora_proportionality_and_simplified_framework_what_if(Profile, OverriddenKey, NewValue, NewStatus) :-
    dora_proportionality_and_simplified_framework_input_problems(Profile, Problems),
    what_if_step(Problems, Profile, OverriddenKey, NewValue, NewStatus).

what_if_step([], Profile, OverriddenKey, NewValue, NewStatus) :-
    attributes_without_key(Profile, OverriddenKey, RemainingAttributes),
    dora_proportionality_and_simplified_framework_status([attribute(OverriddenKey, NewValue)|RemainingAttributes], NewStatus).
what_if_step([Problem|Problems], _, _, _, input_problems([Problem|Problems])).

attributes_without_key([], _, []).
attributes_without_key([attribute(ElementKey, _)|Elements], Key, Remaining) :-
    ElementKey == Key,
    attributes_without_key(Elements, Key, Remaining).
attributes_without_key([attribute(ElementKey, ElementValue)|Elements], Key, [attribute(ElementKey, ElementValue)|Remaining]) :-
    ElementKey \== Key,
    attributes_without_key(Elements, Key, Remaining).

test(the_schema_has_seventeen_keys) :-
    dora_proportionality_and_simplified_framework_profile_keys(Keys),
    length(Keys, 17).
test(an_override_replaces_the_key) :-
    attributes_without_key([attribute(dora_entity_type, credit_institution), attribute(authority_requested_framework_review_report, false)], dora_entity_type, Remaining),
    Remaining == [attribute(authority_requested_framework_review_report, false)].
test(a_refused_profile_is_refused_by_the_what_if) :-
    dora_proportionality_and_simplified_framework_what_if(not_a_list, dora_entity_type, credit_institution, input_problems([wrong_type(profile)])).
test(the_what_if_moves_a_credit_institution_into_article_16) :-
    dora_proportionality_and_simplified_framework_what_if([attribute(dora_entity_type, credit_institution)], dora_entity_type, exempted_payment_institution, indeterminate([simplified_framework_in_place_and_maintained])).
test(the_what_if_has_exactly_one_answer) :-
    findall(Status, dora_proportionality_and_simplified_framework_what_if([attribute(dora_entity_type, credit_institution)], dora_entity_type, investment_firm, Status), Answers),
    Answers == [indeterminate([investment_firm_is_small_and_non_interconnected])].
