% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_nis2_supervision_fines_fixtures, [nis2_supervision_fines_subject/1, nis2_supervision_fines_profile_for/2, nis2_supervision_fines_assess/2]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_nis2_supervision_fines_nis2_supervision_fines, [decide_nis2_supervision_fines/2]).

nis2_supervision_fines_subject(escalation_exercisable).
nis2_supervision_fines_subject(escalation_action_taken_within_deadline).
nis2_supervision_fines_subject(escalation_no_deadline_set).
nis2_supervision_fines_subject(escalation_measures_not_ineffective).
nis2_supervision_fines_subject(escalation_public_administration_entity).
nis2_supervision_fines_subject(escalation_important_entity).
nis2_supervision_fines_subject(escalation_measures_unsure).
nis2_supervision_fines_subject(escalation_class_absent).
nis2_supervision_fines_subject(escalation_class_absent_action_taken).
nis2_supervision_fines_subject(escalation_deadline_absent).
nis2_supervision_fines_subject(fine_floor_essential_at_tie).
nis2_supervision_fines_subject(fine_floor_essential_one_euro_above_tie).
nis2_supervision_fines_subject(fine_floor_important_at_tie).
nis2_supervision_fines_subject(fine_floor_important_one_euro_above_tie).
nis2_supervision_fines_subject(fine_floor_other_provision).
nis2_supervision_fines_subject(gdpr_fine_bars_nis2_fine).
nis2_supervision_fines_subject(gdpr_fine_for_other_conduct).
nis2_supervision_fines_subject(information_duty_two_authorities).
nis2_supervision_fines_subject(invalid_crisp_key_unsure).
nis2_supervision_fines_subject(invalid_not_a_list).

baseline_profile([attribute(entity_class, essential), attribute(infringed_provision, art_21), attribute(worldwide_annual_turnover_eur, 600000000), attribute(entity_is_public_administration, false), attribute(earlier_measures_ineffective, true), attribute(deadline_set_for_necessary_action, true), attribute(required_action_taken_within_deadline, false), attribute(infringement_may_entail_notifiable_personal_data_breach, true), attribute(authority_became_aware_in_supervision_or_enforcement, true), attribute(data_protection_authority_in_other_member_state, false), attribute(gdpr_fine_imposed_under_art_58_2_i, false), attribute(gdpr_fine_for_same_conduct, false)]).

subject_edits(escalation_exercisable, []).
subject_edits(escalation_action_taken_within_deadline, [set(required_action_taken_within_deadline, true)]).
subject_edits(escalation_no_deadline_set, [set(deadline_set_for_necessary_action, false)]).
subject_edits(escalation_measures_not_ineffective, [set(earlier_measures_ineffective, false)]).
subject_edits(escalation_public_administration_entity, [set(entity_is_public_administration, true)]).
subject_edits(escalation_important_entity, [set(entity_class, important)]).
subject_edits(escalation_measures_unsure, [set(earlier_measures_ineffective, unsure)]).
subject_edits(escalation_class_absent, [drop(entity_class)]).
subject_edits(escalation_class_absent_action_taken, [drop(entity_class), set(required_action_taken_within_deadline, true)]).
subject_edits(escalation_deadline_absent, [drop(deadline_set_for_necessary_action)]).
subject_edits(fine_floor_essential_at_tie, [set(worldwide_annual_turnover_eur, 500000000)]).
subject_edits(fine_floor_essential_one_euro_above_tie, [set(worldwide_annual_turnover_eur, 500000001)]).
subject_edits(fine_floor_important_at_tie, [set(entity_class, important), set(worldwide_annual_turnover_eur, 500000000)]).
subject_edits(fine_floor_important_one_euro_above_tie, [set(entity_class, important), set(worldwide_annual_turnover_eur, 500000001)]).
subject_edits(fine_floor_other_provision, [set(infringed_provision, other)]).
subject_edits(gdpr_fine_bars_nis2_fine, [set(gdpr_fine_imposed_under_art_58_2_i, true), set(gdpr_fine_for_same_conduct, true)]).
subject_edits(gdpr_fine_for_other_conduct, [set(gdpr_fine_imposed_under_art_58_2_i, true), set(gdpr_fine_for_same_conduct, false)]).
subject_edits(information_duty_two_authorities, [set(data_protection_authority_in_other_member_state, true)]).
subject_edits(invalid_crisp_key_unsure, [set(entity_is_public_administration, unsure)]).

nis2_supervision_fines_profile_for(invalid_not_a_list, not_a_list).
nis2_supervision_fines_profile_for(Subject, Profile) :-
    subject_edits(Subject, Edits),
    baseline_profile(Baseline),
    foldl(apply_edit, Edits, Baseline, Profile).

apply_edit(set(ProfileKey, NewValue), Elements, Edited) :-
    replace_attribute(Elements, ProfileKey, NewValue, Edited).
apply_edit(drop(ProfileKey), Elements, Edited) :-
    drop_attribute(Elements, ProfileKey, Edited).

replace_attribute([], _, _, []).
replace_attribute([attribute(ElementKey, _)|Elements], ProfileKey, NewValue, [attribute(ProfileKey, NewValue)|Elements]) :-
    ElementKey == ProfileKey.
replace_attribute([attribute(ElementKey, GivenValue)|Elements], ProfileKey, NewValue, [attribute(ElementKey, GivenValue)|Edited]) :-
    ElementKey \== ProfileKey,
    replace_attribute(Elements, ProfileKey, NewValue, Edited).

drop_attribute([], _, []).
drop_attribute([attribute(ElementKey, _)|Elements], ProfileKey, Edited) :-
    ElementKey == ProfileKey,
    drop_attribute(Elements, ProfileKey, Edited).
drop_attribute([attribute(ElementKey, GivenValue)|Elements], ProfileKey, [attribute(ElementKey, GivenValue)|Edited]) :-
    ElementKey \== ProfileKey,
    drop_attribute(Elements, ProfileKey, Edited).

nis2_supervision_fines_assess(Subject, Result) :-
    nis2_supervision_fines_profile_for(Subject, Profile),
    decide_nis2_supervision_fines(Profile, Result).
