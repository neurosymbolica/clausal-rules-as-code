% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_penalties___init__, [root_export/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_dora_penalties_kernel, [dora_penalties_input_problems/2]).
:- use_module(m__eu_dora_penalties_citations, [citation/2, implements/1]).
:- use_module(m__eu_dora_penalties_dora_penalties, [administrative_penalty_rules_required/3, circumstances_to_take_into_account/2, criminal_penalty_liaison_duties/2, decide_dora_penalties/2, dora_penalties_checklist/2, dora_penalties_decision_resolvable/1, dora_penalties_status/2, dora_penalties_status_values/1, minimum_powers/2, penalty_decision_safeguards/2]).
:- use_module(m__eu_dora_penalties_queries, [access_to_documents_and_data/0, cease_and_desist_order/0, cessation_of_practice_or_conduct/0, cooperation_with_competent_authority/0, degree_of_responsibility/0, dora_penalties_profile_keys/1, dora_penalties_what_if/4, extension/0, financial_strength/0, intent_or_negligence/0, losses_for_third_parties/0, management_body_and_responsible_individuals/0, materiality_gravity_and_duration/0, measures_to_ensure_continued_compliance/0, not_required_criminal_penalties/0, on_site_inspections_and_investigations/0, penalty/0, previous_breaches/0, profits_gained_or_losses_avoided/0, public_notice/0, require_corrective_and_remedial_measures/0, require_data_traffic_records/0, required/0, supervisory/0]).
:- use_module(m__eu_dora_penalties_fixtures, [dora_penalties_assess/2, dora_penalties_profile_for/2, dora_penalties_subject/1]).

root_export(access_to_documents_and_data).
root_export(breach_materiality_gravity_duration_relevant).
root_export(breach_subject_to_criminal_penalties_under_national_law).
root_export(cease_and_desist_order).
root_export(cessation_of_practice_or_conduct).
root_export(circumstance).
root_export(cooperation_with_authority_relevant).
root_export(cooperation_with_competent_authority).
root_export(decision_imposes_art_50_2_c_measure).
root_export(degree_of_responsibility).
root_export(degree_of_responsibility_relevant).
root_export(duplicate_key).
root_export(extension).
root_export(financial_strength).
root_export(financial_strength_relevant).
root_export(indeterminate).
root_export(input_problems).
root_export(inputs_relied_on).
root_export(intent_or_negligence).
root_export(losses_for_third_parties).
root_export(management_body_and_responsible_individuals).
root_export(materiality_gravity_and_duration).
root_export(measures_applied_to_legal_person).
root_export(measures_to_ensure_continued_compliance).
root_export(member_state_chose_no_administrative_rules_for_criminally_penalised_breaches).
root_export(member_state_laid_down_criminal_penalties_for_breaches).
root_export(national_law_permits_requiring_data_traffic_records).
root_export(needs_legal_review).
root_export(not_required_criminal_penalties).
root_export(on_site_inspections_and_investigations).
root_export(open_textured).
root_export(penalty).
root_export(power).
root_export(previous_breaches).
root_export(previous_breaches_relevant).
root_export(profits_gained_or_losses_avoided).
root_export(profits_gained_or_losses_avoided_relevant).
root_export(properly_reasoned).
root_export(provenance).
root_export(provide_information_to_authorities_and_esas).
root_export(public_notice).
root_export(receive_criminal_proceedings_information).
root_export(require_corrective_and_remedial_measures).
root_export(require_data_traffic_records).
root_export(required).
root_export(right_of_appeal).
root_export(supervisory).
root_export(third_party_losses_relevant).
root_export(unknown_key).
root_export(unsure).
root_export(wrong_type).
