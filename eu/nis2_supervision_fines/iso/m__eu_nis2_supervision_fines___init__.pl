% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_nis2_supervision_fines___init__, [root_export/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_nis2_supervision_fines_kernel, [nis2_supervision_fines_input_problems/2, nis2_supervision_fines_relied_pairs/3]).
:- use_module(m__eu_nis2_supervision_fines_citations, [citation/2, citation_vocabulary/1, implements/1]).
:- use_module(m__eu_nis2_supervision_fines_nis2_supervision_fines, [data_protection_authority_information/2, decide_nis2_supervision_fines/2, duplicate_key/1, escalation_powers_exercisable/3, exercisable/0, fine_barred/0, fine_barred_by_gdpr_fine/3, fine_ceiling_floor/3, fine_not_barred/0, fixed_amount/0, indeterminate/1, inform_gdpr_supervisory_authorities/1, inform_supervisory_authority_in_own_member_state/1, input_problems/1, inputs_relied_on/1, minimum_national_maximum/2, minimum_powers/2, needs_legal_review/2, nis2_supervision_fines_checklist/2, nis2_supervision_fines_decision_resolvable/1, nis2_supervision_fines_status/2, nis2_supervision_fines_status_values/1, no_union_minimum/0, not_exercisable/1, open_textured/2, power/3, provenance/2, turnover_percentage/0, unknown_key/1, wrong_type/1]).
:- use_module(m__eu_nis2_supervision_fines_queries, [art_21/0, art_23/0, authority_became_aware_in_supervision_or_enforcement/0, data_protection_authority_in_other_member_state/0, deadline_set_for_necessary_action/0, earlier_measures_ineffective/0, entity_class/0, entity_is_public_administration/0, essential/0, gdpr_fine_for_same_conduct/0, gdpr_fine_imposed_under_art_58_2_i/0, important/0, infringed_provision/0, infringement_may_entail_notifiable_personal_data_breach/0, nis2_supervision_fines_profile_keys/1, nis2_supervision_fines_what_if/4, other/0, required_action_taken_within_deadline/0, unsure/0, worldwide_annual_turnover_eur/0]).
:- use_module(m__eu_nis2_supervision_fines_fixtures, [nis2_supervision_fines_assess/2, nis2_supervision_fines_profile_for/2, nis2_supervision_fines_subject/1]).

root_export(art_21).
root_export(art_23).
root_export(authority_became_aware_in_supervision_or_enforcement).
root_export(data_protection_authority_in_other_member_state).
root_export(deadline_set_for_necessary_action).
root_export(earlier_measures_ineffective).
root_export(entity_class).
root_export(entity_is_public_administration).
root_export(essential).
root_export(exercisable).
root_export(fine_barred).
root_export(fine_not_barred).
root_export(fixed_amount).
root_export(gdpr_fine_for_same_conduct).
root_export(gdpr_fine_imposed_under_art_58_2_i).
root_export(important).
root_export(infringed_provision).
root_export(infringement_may_entail_notifiable_personal_data_breach).
root_export(no_union_minimum).
root_export(other).
root_export(required_action_taken_within_deadline).
root_export(turnover_percentage).
root_export(unsure).
root_export(worldwide_annual_turnover_eur).
