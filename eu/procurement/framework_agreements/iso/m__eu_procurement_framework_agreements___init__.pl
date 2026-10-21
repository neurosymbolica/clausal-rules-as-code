:- module(m__eu_procurement_framework_agreements___init__, [root_export/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_procurement_framework_agreements_citations, [citation/2]).
:- use_module(m__eu_procurement_framework_agreements_framework_agreements, [framework_term_limit_years/1]).
:- use_module(m__eu_procurement_framework_agreements_framework_agreements, [call_off_award_window_status/4, call_off_defect_id/1, call_off_method/1, call_off_route/2, call_off_route_id/1, decide_call_off/2, decide_framework_agreements/2, decide_framework_term/2, framework_agreements_checklist/2, framework_agreements_decision_resolvable/1, framework_agreements_status/2, framework_agreements_status_values/1, framework_term_defect_id/1, framework_term_limit_date/2, framework_term_within_limit/3]).
:- use_module(m__eu_procurement_framework_agreements_queries, [framework_agreements_enumerate_defects/2, framework_agreements_profile_keys/1, framework_agreements_route_status/2, framework_agreements_term_boundary/2, framework_agreements_threshold_status/3, framework_agreements_what_if/4]).
:- use_module(m__eu_procurement_framework_agreements_fixtures, [framework_agreements_assess/2, framework_agreements_profile_for/2, framework_agreements_subject/1]).

root_export(award_made_on_framework_award_criteria).
root_export(call_off_award_date).
root_export(call_off_entails_substantial_modification).
root_export(call_off_method_key).
root_export(call_off_verdict).
root_export(call_off_within_limits_of_framework_terms).
root_export(capable_operators_consulted_in_writing).
root_export(contracting_authority_identified_in_call_for_competition).
root_export(economic_operator_party_to_framework).
root_export(exceptional_case_duly_justified).
root_export(framework_end_date).
root_export(framework_operator_count).
root_export(framework_sets_out_all_terms).
root_export(framework_start_date).
root_export(framework_term_verdict).
root_export(objective_conditions_for_determining_performer_indicated).
root_export(objective_criteria_for_choice_of_route_stated).
root_export(partly_with_partly_without_reopening_stipulated).
root_export(reopened_competition_based_on_framework_terms).
root_export(tender_contents_confidential_until_time_limit_expired).
root_export(tenders_submitted_in_writing).
root_export(terms_subject_to_reopening_specified).
root_export(time_limit_sufficiently_long).
root_export(with_reopening_competition).
root_export(without_reopening_competition).
