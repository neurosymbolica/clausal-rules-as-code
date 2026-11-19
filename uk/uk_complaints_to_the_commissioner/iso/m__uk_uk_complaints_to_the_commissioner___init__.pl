% SPDX-License-Identifier: EUPL-1.2
:- module(m__uk_uk_complaints_to_the_commissioner___init__, [root_export/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__uk_uk_complaints_to_the_commissioner_kernel, [uk_complaints_to_the_commissioner_input_problems/2]).
:- use_module(m__uk_uk_complaints_to_the_commissioner_citations, [citation/2, implements/1]).
:- use_module(m__uk_uk_complaints_to_the_commissioner_uk_complaints_to_the_commissioner, [acknowledgement_last_day/3, commission_complaint_right/3, controller_complaint_right/3, decide_uk_complaints_to_the_commissioner/2, uk_complaints_to_the_commissioner_checklist/2, uk_complaints_to_the_commissioner_decision_resolvable/1, uk_complaints_to_the_commissioner_status/2, uk_complaints_to_the_commissioner_status_values/1]).
:- use_module(m__uk_uk_complaints_to_the_commissioner_queries, [acknowledgement_duty_does_not_apply/0, complaint_under_section_164a/0, complaint_under_section_165_2/0, not_a_complaint_under_section_164a/0, not_a_complaint_under_section_165_2/0, uk_complaints_to_the_commissioner_profile_keys/1, uk_complaints_to_the_commissioner_what_if/4]).
:- use_module(m__uk_uk_complaints_to_the_commissioner_fixtures, [uk_complaints_to_the_commissioner_assess/2, uk_complaints_to_the_commissioner_profile_for/2, uk_complaints_to_the_commissioner_subject/1]).

root_export(acknowledgement_duty_does_not_apply).
root_export(complaint_by_data_subject_about_own_personal_data).
root_export(complaint_made_to_the_controller).
root_export(complaint_under_section_164a).
root_export(complaint_under_section_165_2).
root_export(dpa_2018_part_3).
root_export(dpa_2018_part_4).
root_export(duplicate_key).
root_export(indeterminate).
root_export(infringement_considered).
root_export(input_problems).
root_export(none_of_the_three).
root_export(not_a_complaint_under_section_164a).
root_export(not_a_complaint_under_section_165_2).
root_export(uk_gdpr).
root_export(unknown_key).
root_export(wrong_type).
