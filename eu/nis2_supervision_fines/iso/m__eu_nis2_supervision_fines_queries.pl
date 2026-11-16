% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_nis2_supervision_fines_queries, [nis2_supervision_fines_profile_keys/1, nis2_supervision_fines_what_if/4, entity_class/0, infringed_provision/0, worldwide_annual_turnover_eur/0, entity_is_public_administration/0, earlier_measures_ineffective/0, deadline_set_for_necessary_action/0, required_action_taken_within_deadline/0, infringement_may_entail_notifiable_personal_data_breach/0, authority_became_aware_in_supervision_or_enforcement/0, data_protection_authority_in_other_member_state/0, gdpr_fine_imposed_under_art_58_2_i/0, gdpr_fine_for_same_conduct/0, essential/0, important/0, art_21/0, art_23/0, other/0, unsure/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_nis2_supervision_fines_kernel, [nis2_supervision_fines_input_problems/2]).
:- use_module(m__eu_nis2_supervision_fines_nis2_supervision_fines, [nis2_supervision_fines_status/2]).

nis2_supervision_fines_profile_keys([entity_class, infringed_provision, worldwide_annual_turnover_eur, entity_is_public_administration, earlier_measures_ineffective, deadline_set_for_necessary_action, required_action_taken_within_deadline, infringement_may_entail_notifiable_personal_data_breach, authority_became_aware_in_supervision_or_enforcement, data_protection_authority_in_other_member_state, gdpr_fine_imposed_under_art_58_2_i, gdpr_fine_for_same_conduct]).

nis2_supervision_fines_what_if(Profile, OverriddenKey, NewValue, NewStatus) :-
    without_key(Profile, OverriddenKey, RemainingAttributes),
    nis2_supervision_fines_status([attribute(OverriddenKey, NewValue)|RemainingAttributes], NewStatus).

without_key([], _, []).
without_key([attribute(ElementKey, _)|Elements], OverriddenKey, RemainingAttributes) :-
    ElementKey == OverriddenKey,
    without_key(Elements, OverriddenKey, RemainingAttributes).
without_key([attribute(ElementKey, ElementValue)|Elements], OverriddenKey, [attribute(ElementKey, ElementValue)|RemainingAttributes]) :-
    ElementKey \== OverriddenKey,
    without_key(Elements, OverriddenKey, RemainingAttributes).

entity_class.

infringed_provision.

worldwide_annual_turnover_eur.

entity_is_public_administration.

earlier_measures_ineffective.

deadline_set_for_necessary_action.

required_action_taken_within_deadline.

infringement_may_entail_notifiable_personal_data_breach.

authority_became_aware_in_supervision_or_enforcement.

data_protection_authority_in_other_member_state.

gdpr_fine_imposed_under_art_58_2_i.

gdpr_fine_for_same_conduct.

essential.

important.

art_21.

art_23.

other.

unsure.

test(twelve_profile_keys) :-
    nis2_supervision_fines_profile_keys(Keys),
    length(Keys, 12).
test(what_if_flips_the_last_condition) :-
    nis2_supervision_fines_what_if([attribute(entity_class, essential), attribute(entity_is_public_administration, false), attribute(earlier_measures_ineffective, true), attribute(deadline_set_for_necessary_action, true), attribute(required_action_taken_within_deadline, true)], required_action_taken_within_deadline, false, eligible).
test(root_atoms_are_callable) :-
    entity_class,
    unsure,
    other.
