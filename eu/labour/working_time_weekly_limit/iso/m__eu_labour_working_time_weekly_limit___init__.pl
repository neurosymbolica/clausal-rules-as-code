% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_labour_working_time_weekly_limit___init__, [root_export/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_labour_working_time_weekly_limit_kernel, [working_time_weekly_limit_input_problems/2]).
:- use_module(m__eu_labour_working_time_weekly_limit_citations, [citation/2, implements/1]).
:- use_module(m__eu_labour_working_time_weekly_limit_working_time_weekly_limit, [decide_working_time_weekly_limit/2, no_countable_period/0, over_weekly_limit/0, reference_period_longer_than_allowed/0, required_reduction_minutes/6, weekly_limit_not_applied_by_agreement/0, weekly_limit_status/7, weekly_working_time_average/6, within_weekly_limit/0, working_time_weekly_limit_checklist/2, working_time_weekly_limit_decision_resolvable/1, working_time_weekly_limit_status/2, working_time_weekly_limit_status_values/1]).
:- use_module(m__eu_labour_working_time_weekly_limit_queries, [collective_agreement_under_article_19/0, derogation_under_article_17_3_or_article_18/0, duplicate_key/1, indeterminate/1, input_problems/1, inputs_relied_on/1, member_state_reference_period/0, member_state_uses_article_22_option/0, minutes_per_seven_days/2, needs_legal_review/2, offshore_work_under_article_20_2/0, on_call_on_site/0, on_call_on_site_counts_as_working_time/0, on_call_standby/0, on_call_standby_counts_as_working_time/0, open_textured/2, paid_annual_leave/0, provenance/2, reference_period_basis/0, sick_leave/0, unknown_key/1, unsure/0, work/0, worker_agreement_to_exceed_obtained_first/0, working_time_weekly_limit_maximum_counted_minutes/6, working_time_weekly_limit_profile_keys/1, working_time_weekly_limit_what_if/4, wrong_type/1]).
:- use_module(m__eu_labour_working_time_weekly_limit_fixtures, [working_time_weekly_limit_assess/2, working_time_weekly_limit_profile_for/2, working_time_weekly_limit_subject/1]).

root_export(collective_agreement_under_article_19).
root_export(derogation_under_article_17_3_or_article_18).
root_export(member_state_reference_period).
root_export(member_state_uses_article_22_option).
root_export(no_countable_period).
root_export(offshore_work_under_article_20_2).
root_export(on_call_on_site).
root_export(on_call_on_site_counts_as_working_time).
root_export(on_call_standby).
root_export(on_call_standby_counts_as_working_time).
root_export(over_weekly_limit).
root_export(paid_annual_leave).
root_export(reference_period_basis).
root_export(reference_period_longer_than_allowed).
root_export(sick_leave).
root_export(unsure).
root_export(weekly_limit_not_applied_by_agreement).
root_export(within_weekly_limit).
root_export(work).
root_export(worker_agreement_to_exceed_obtained_first).
