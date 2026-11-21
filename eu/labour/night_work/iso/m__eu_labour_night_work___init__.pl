% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_labour_night_work___init__, [root_export/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_labour_night_work_kernel, [night_work_input_problems/2]).
:- use_module(m__eu_labour_night_work_citations, [citation/2, implements/1]).
:- use_module(m__eu_labour_night_work_night_work, [average_night_hours_exceeded/0, average_night_hours_kept/0, decide_night_work/2, hazardous_night_work_hours_exceeded/0, hazardous_night_work_hours_kept/0, hazardous_night_work_status/7, night_work_average_status/7, night_work_checklist/2, night_work_decision_resolvable/1, night_work_derogation_applies/0, night_work_limits_not_applied_to_worker/0, night_work_status/2, night_work_status_values/1, no_special_hazards_or_heavy_strain/0, not_a_night_worker/0]).
:- use_module(m__eu_labour_night_work_queries, [derogation_from_article_8/0, derogation_under_article_17_1/0, derogation_under_article_17_3/0, derogation_under_article_18/0, mobile_worker/0, night_time_end/0, night_time_start/0, night_work_block_limit_minutes/2, night_work_profile_keys/1, night_work_reference_period_days/0, night_work_span_working_minutes/6, night_work_what_if/4, night_worker/0, no_derogation/0, on_call_on_site/0, on_call_on_site_counts_as_working_time/0, on_call_standby/0, on_call_standby_counts_as_working_time/0, other_worker/0, paid_annual_leave/0, seagoing_fishing_vessel_worker/0, sick_leave/0, special_hazards_or_heavy_strain/0, unsure/0, work/0, worker_category/0]).
:- use_module(m__eu_labour_night_work_fixtures, [night_work_assess/2, night_work_profile_for/2, night_work_subject/1]).

root_export(average_night_hours_exceeded).
root_export(average_night_hours_kept).
root_export(cite).
root_export(date).
root_export(date_time).
root_export(derogation_from_article_8).
root_export(derogation_under_article_17_1).
root_export(derogation_under_article_17_3).
root_export(derogation_under_article_18).
root_export(duplicate_key).
root_export(hazardous_night_work_hours_exceeded).
root_export(hazardous_night_work_hours_kept).
root_export(indeterminate).
root_export(input_problems).
root_export(inputs_relied_on).
root_export(mobile_worker).
root_export(needs_legal_review).
root_export(night_time_end).
root_export(night_time_start).
root_export(night_work_derogation_applies).
root_export(night_work_limits_not_applied_to_worker).
root_export(night_work_reference_period_days).
root_export(night_worker).
root_export(no_derogation).
root_export(no_special_hazards_or_heavy_strain).
root_export(not_a_night_worker).
root_export(on_call_on_site).
root_export(on_call_on_site_counts_as_working_time).
root_export(on_call_standby).
root_export(on_call_standby_counts_as_working_time).
root_export(open_textured).
root_export(other_worker).
root_export(paid_annual_leave).
root_export(provenance).
root_export(seagoing_fishing_vessel_worker).
root_export(shift).
root_export(sick_leave).
root_export(special_hazards_or_heavy_strain).
root_export(unknown_key).
root_export(unsure).
root_export(work).
root_export(worker_category).
root_export(wrong_type).
