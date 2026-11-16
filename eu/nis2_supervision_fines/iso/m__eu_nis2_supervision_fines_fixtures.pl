% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_nis2_supervision_fines_fixtures, [nis2_supervision_fines_subject/1, nis2_supervision_fines_profile_for/2, nis2_supervision_fines_assess/2]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_nis2_supervision_fines_nis2_supervision_fines, [decide_nis2_supervision_fines/2]).

nis2_supervision_fines_subject(escalation_exercisable).
nis2_supervision_fines_subject(escalation_action_taken_within_deadline).
nis2_supervision_fines_subject(escalation_public_administration_entity).
nis2_supervision_fines_subject(escalation_measures_not_ineffective).
nis2_supervision_fines_subject(escalation_no_deadline_set).
nis2_supervision_fines_subject(escalation_measures_unsure).
nis2_supervision_fines_subject(escalation_deadline_keys_missing).
nis2_supervision_fines_subject(entity_class_absent).
nis2_supervision_fines_subject(important_fine_at_tie).
nis2_supervision_fines_subject(important_fine_above_tie).
nis2_supervision_fines_subject(essential_fine_below_tie).
nis2_supervision_fines_subject(essential_fine_at_tie).
nis2_supervision_fines_subject(essential_fine_above_tie).
nis2_supervision_fines_subject(other_infringement).
nis2_supervision_fines_subject(gdpr_fine_barred).
nis2_supervision_fines_subject(gdpr_not_same_conduct).
nis2_supervision_fines_subject(gdpr_same_conduct_unsure).
nis2_supervision_fines_subject(information_other_member_state).
nis2_supervision_fines_subject(information_own_member_state).
nis2_supervision_fines_subject(information_not_aware).
nis2_supervision_fines_subject(duplicate_entity_class).
nis2_supervision_fines_subject(unknown_key_present).

nis2_supervision_fines_profile_for(escalation_exercisable, [attribute(entity_class, essential), attribute(entity_is_public_administration, false), attribute(earlier_measures_ineffective, true), attribute(deadline_set_for_necessary_action, true), attribute(required_action_taken_within_deadline, false)]).
nis2_supervision_fines_profile_for(escalation_action_taken_within_deadline, [attribute(entity_class, essential), attribute(entity_is_public_administration, false), attribute(earlier_measures_ineffective, true), attribute(deadline_set_for_necessary_action, true), attribute(required_action_taken_within_deadline, true)]).
nis2_supervision_fines_profile_for(escalation_public_administration_entity, [attribute(entity_class, essential), attribute(entity_is_public_administration, true), attribute(earlier_measures_ineffective, true), attribute(deadline_set_for_necessary_action, true), attribute(required_action_taken_within_deadline, false)]).
nis2_supervision_fines_profile_for(escalation_measures_not_ineffective, [attribute(entity_class, essential), attribute(entity_is_public_administration, false), attribute(earlier_measures_ineffective, false), attribute(deadline_set_for_necessary_action, true), attribute(required_action_taken_within_deadline, false)]).
nis2_supervision_fines_profile_for(escalation_no_deadline_set, [attribute(entity_class, essential), attribute(entity_is_public_administration, false), attribute(earlier_measures_ineffective, true), attribute(deadline_set_for_necessary_action, false), attribute(required_action_taken_within_deadline, false)]).
nis2_supervision_fines_profile_for(escalation_measures_unsure, [attribute(entity_class, essential), attribute(entity_is_public_administration, false), attribute(earlier_measures_ineffective, unsure), attribute(deadline_set_for_necessary_action, true), attribute(required_action_taken_within_deadline, false)]).
nis2_supervision_fines_profile_for(escalation_deadline_keys_missing, [attribute(entity_class, essential), attribute(entity_is_public_administration, false), attribute(earlier_measures_ineffective, true)]).
nis2_supervision_fines_profile_for(entity_class_absent, []).
nis2_supervision_fines_profile_for(important_fine_at_tie, [attribute(entity_class, important), attribute(infringed_provision, art_21), attribute(worldwide_annual_turnover_eur, 500000000)]).
nis2_supervision_fines_profile_for(important_fine_above_tie, [attribute(entity_class, important), attribute(infringed_provision, art_21), attribute(worldwide_annual_turnover_eur, 500000001)]).
nis2_supervision_fines_profile_for(essential_fine_below_tie, [attribute(entity_class, essential), attribute(infringed_provision, art_23), attribute(worldwide_annual_turnover_eur, 499999999)]).
nis2_supervision_fines_profile_for(essential_fine_at_tie, [attribute(entity_class, essential), attribute(infringed_provision, art_23), attribute(worldwide_annual_turnover_eur, 500000000)]).
nis2_supervision_fines_profile_for(essential_fine_above_tie, [attribute(entity_class, essential), attribute(infringed_provision, art_23), attribute(worldwide_annual_turnover_eur, 500000001)]).
nis2_supervision_fines_profile_for(other_infringement, [attribute(entity_class, important), attribute(infringed_provision, other), attribute(worldwide_annual_turnover_eur, 500000001)]).
nis2_supervision_fines_profile_for(gdpr_fine_barred, [attribute(entity_class, important), attribute(infringed_provision, art_21), attribute(infringement_may_entail_notifiable_personal_data_breach, true), attribute(gdpr_fine_imposed_under_art_58_2_i, true), attribute(gdpr_fine_for_same_conduct, true)]).
nis2_supervision_fines_profile_for(gdpr_not_same_conduct, [attribute(entity_class, important), attribute(infringed_provision, art_21), attribute(infringement_may_entail_notifiable_personal_data_breach, true), attribute(gdpr_fine_imposed_under_art_58_2_i, true), attribute(gdpr_fine_for_same_conduct, false)]).
nis2_supervision_fines_profile_for(gdpr_same_conduct_unsure, [attribute(entity_class, important), attribute(infringed_provision, art_21), attribute(infringement_may_entail_notifiable_personal_data_breach, true), attribute(gdpr_fine_imposed_under_art_58_2_i, true), attribute(gdpr_fine_for_same_conduct, unsure)]).
nis2_supervision_fines_profile_for(information_other_member_state, [attribute(entity_class, important), attribute(infringed_provision, art_23), attribute(infringement_may_entail_notifiable_personal_data_breach, true), attribute(authority_became_aware_in_supervision_or_enforcement, true), attribute(data_protection_authority_in_other_member_state, true)]).
nis2_supervision_fines_profile_for(information_own_member_state, [attribute(entity_class, important), attribute(infringed_provision, art_23), attribute(infringement_may_entail_notifiable_personal_data_breach, true), attribute(authority_became_aware_in_supervision_or_enforcement, true), attribute(data_protection_authority_in_other_member_state, false)]).
nis2_supervision_fines_profile_for(information_not_aware, [attribute(entity_class, important), attribute(infringed_provision, art_21), attribute(infringement_may_entail_notifiable_personal_data_breach, true), attribute(authority_became_aware_in_supervision_or_enforcement, false)]).
nis2_supervision_fines_profile_for(duplicate_entity_class, [attribute(entity_class, essential), attribute(entity_class, important)]).
nis2_supervision_fines_profile_for(unknown_key_present, [attribute(entity_class, important), attribute(sector, energy)]).

nis2_supervision_fines_assess(Subject, Result) :-
    nis2_supervision_fines_profile_for(Subject, Profile),
    decide_nis2_supervision_fines(Profile, Result).
