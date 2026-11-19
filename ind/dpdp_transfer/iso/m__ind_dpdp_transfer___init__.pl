% SPDX-License-Identifier: EUPL-1.2
:- module(m__ind_dpdp_transfer___init__, [root_export/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__ind_dpdp_transfer_kernel, [dpdp_transfer_input_problems/2]).
:- use_module(m__ind_dpdp_transfer_citations, [citation/2, implements/1]).
:- use_module(m__ind_dpdp_transfer_dpdp_transfer, [decide_dpdp_transfer/2, dpdp_transfer_checklist/2, dpdp_transfer_decision_resolvable/1, dpdp_transfer_status/2, dpdp_transfer_status_values/1]).
:- use_module(m__ind_dpdp_transfer_queries, [destination_restricted_by_notification/0, dpdp_transfer_profile_keys/1, dpdp_transfer_what_if/4, foreign_state_requirements/0, foreign_state_requirements_specified/0, not_in_force/0, not_restricted/0, notified_destination/0, recipient_is_foreign_state_or_its_entity/0, reference_date/0, requirements_apply_see_order/0, restricted_see_notification/0, restriction_status/4, section_16_in_force_on_reference_date/0, unsure/0]).
:- use_module(m__ind_dpdp_transfer_fixtures, [dpdp_transfer_assess/2, dpdp_transfer_profile_for/2, dpdp_transfer_subject/1]).

root_export(destination_restricted_by_notification).
root_export(duplicate_key).
root_export(foreign_state_requirements).
root_export(foreign_state_requirements_specified).
root_export(indeterminate).
root_export(input_problems).
root_export(inputs_relied_on).
root_export(needs_legal_review).
root_export(not_in_force).
root_export(not_restricted).
root_export(notified_destination).
root_export(open_textured).
root_export(provenance).
root_export(recipient_is_foreign_state_or_its_entity).
root_export(reference_date).
root_export(requirements_apply_see_order).
root_export(restricted_see_notification).
root_export(section_16_in_force_on_reference_date).
root_export(unknown_key).
root_export(unsure).
root_export(wrong_type).
