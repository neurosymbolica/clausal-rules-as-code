% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_nis2_supervision_fines_queries, [nis2_supervision_fines_profile_keys/1, nis2_supervision_fines_what_if/4, entity_class/0, infringed_provision/0, worldwide_annual_turnover_eur/0, entity_is_public_administration/0, earlier_measures_ineffective/0, deadline_set_for_necessary_action/0, required_action_taken_within_deadline/0, infringement_may_entail_notifiable_personal_data_breach/0, authority_became_aware_in_supervision_or_enforcement/0, data_protection_authority_in_other_member_state/0, gdpr_fine_imposed_under_art_58_2_i/0, gdpr_fine_for_same_conduct/0, essential/0, important/0, art_21/0, art_23/0, other/0, unsure/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_nis2_supervision_fines_kernel, [nis2_supervision_fines_input_problems/2]).
:- use_module(m__eu_nis2_supervision_fines_nis2_supervision_fines, [nis2_supervision_fines_status/2]).

nis2_supervision_fines_profile_keys([entity_class, infringed_provision, worldwide_annual_turnover_eur, entity_is_public_administration, earlier_measures_ineffective, deadline_set_for_necessary_action, required_action_taken_within_deadline, infringement_may_entail_notifiable_personal_data_breach, authority_became_aware_in_supervision_or_enforcement, data_protection_authority_in_other_member_state, gdpr_fine_imposed_under_art_58_2_i, gdpr_fine_for_same_conduct]).

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

nis2_supervision_fines_what_if(Profile, OverriddenKey, NewValue, NewStatus) :-
    nis2_supervision_fines_input_problems(Profile, Problems),
    what_if_checked(Problems, Profile, OverriddenKey, NewValue, NewStatus).

what_if_checked([wrong_type(profile)], Profile, _, _, NewStatus) :-
    nis2_supervision_fines_status(Profile, NewStatus).
what_if_checked(Problems, Profile, OverriddenKey, NewValue, NewStatus) :-
    dif(Problems, [wrong_type(profile)]),
    override_attribute(Profile, OverriddenKey, NewValue, Hypothesis),
    nis2_supervision_fines_status(Hypothesis, NewStatus).

override_attribute([], ProfileKey, NewValue, [attribute(ProfileKey, NewValue)]).
override_attribute([attribute(ElementKey, _)|Elements], ProfileKey, NewValue, [attribute(ProfileKey, NewValue)|Remaining]) :-
    ElementKey == ProfileKey,
    drop_attribute(Elements, ProfileKey, Remaining).
override_attribute([attribute(ElementKey, GivenValue)|Elements], ProfileKey, NewValue, [attribute(ElementKey, GivenValue)|Edited]) :-
    ElementKey \== ProfileKey,
    override_attribute(Elements, ProfileKey, NewValue, Edited).

drop_attribute([], _, []).
drop_attribute([attribute(ElementKey, _)|Elements], ProfileKey, Remaining) :-
    ElementKey == ProfileKey,
    drop_attribute(Elements, ProfileKey, Remaining).
drop_attribute([attribute(ElementKey, GivenValue)|Elements], ProfileKey, [attribute(ElementKey, GivenValue)|Remaining]) :-
    ElementKey \== ProfileKey,
    drop_attribute(Elements, ProfileKey, Remaining).

test(what_if_taking_the_action_in_time_flips_to_ineligible) :-
    findall(Status, nis2_supervision_fines_what_if([attribute(entity_class, essential), attribute(entity_is_public_administration, false), attribute(earlier_measures_ineffective, true), attribute(deadline_set_for_necessary_action, true), attribute(required_action_taken_within_deadline, false)], required_action_taken_within_deadline, true, Status), Statuses),
    Statuses == [ineligible].
test(what_if_adding_the_absent_class_resolves_to_eligible) :-
    findall(Status, nis2_supervision_fines_what_if([attribute(entity_is_public_administration, false), attribute(earlier_measures_ineffective, true), attribute(deadline_set_for_necessary_action, true), attribute(required_action_taken_within_deadline, false)], entity_class, essential, Status), Statuses),
    Statuses == [eligible].
test(what_if_on_a_non_list_is_invalid_profile) :-
    findall(Status, nis2_supervision_fines_what_if(not_a_list, entity_class, essential, Status), Statuses),
    Statuses == [invalid_profile].
test(profile_keys_are_the_twelve_contract_keys) :-
    nis2_supervision_fines_profile_keys(ProfileKeys),
    length(ProfileKeys, 12).
test(root_export_atoms_are_served) :-
    entity_class,
    infringed_provision,
    worldwide_annual_turnover_eur,
    entity_is_public_administration,
    earlier_measures_ineffective,
    deadline_set_for_necessary_action,
    required_action_taken_within_deadline,
    infringement_may_entail_notifiable_personal_data_breach,
    authority_became_aware_in_supervision_or_enforcement,
    data_protection_authority_in_other_member_state,
    gdpr_fine_imposed_under_art_58_2_i,
    gdpr_fine_for_same_conduct,
    essential,
    important,
    art_21,
    art_23,
    other,
    unsure.

test(what_if_adding_the_absent_class_is_not_indeterminate, fail) :-
    nis2_supervision_fines_what_if([attribute(entity_is_public_administration, false), attribute(earlier_measures_ineffective, true), attribute(deadline_set_for_necessary_action, true), attribute(required_action_taken_within_deadline, false)], entity_class, essential, indeterminate).
