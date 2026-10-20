:- module(m__eu_procurement_framework_agreements_queries, [framework_agreements_profile_keys/1, framework_agreements_what_if/4, framework_agreements_route_status/2, framework_agreements_enumerate_defects/2, framework_agreements_term_boundary/2, framework_agreements_threshold_status/3]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(query_combinators, [override_key/4]).
:- use_module(m__eu_procurement_framework_agreements_framework_agreements, [decide_framework_agreements/2, decide_call_off/2, call_off_route/2, framework_term_limit_date/2, framework_term_within_limit/3]).

framework_agreements_profile_keys([framework_start_date, framework_end_date, call_off_award_date, framework_operator_count, call_off_method_key, exceptional_case_duly_justified, contracting_authority_identified_in_call_for_competition, economic_operator_party_to_framework, call_off_entails_substantial_modification, call_off_within_limits_of_framework_terms, framework_sets_out_all_terms, objective_conditions_for_determining_performer_indicated, partly_with_partly_without_reopening_stipulated, objective_criteria_for_choice_of_route_stated, terms_subject_to_reopening_specified, reopened_competition_based_on_framework_terms, capable_operators_consulted_in_writing, time_limit_sufficiently_long, tenders_submitted_in_writing, tender_contents_confidential_until_time_limit_expired, award_made_on_framework_award_criteria]).

framework_agreements_what_if(Profile, OverriddenKey, NewValue, Result) :-
    override_key(Profile, OverriddenKey, NewValue, Hypothesis),
    decide_framework_agreements(Hypothesis, Result).

framework_agreements_route_status(Profile, Route) :-
    call_off_route(Profile, Route).

framework_agreements_enumerate_defects(Profile, DefectIds) :-
    decide_call_off(Profile, call_off_verdict(_, _, DefectIds, _)).

framework_agreements_term_boundary(StartDate, LimitDate) :-
    framework_term_limit_date(StartDate, LimitDate).

framework_agreements_threshold_status(StartDate, EndDate, Status) :-
    framework_term_within_limit(StartDate, EndDate, Status).
