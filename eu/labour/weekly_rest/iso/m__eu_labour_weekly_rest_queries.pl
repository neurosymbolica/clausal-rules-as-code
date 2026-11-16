% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_labour_weekly_rest_queries, [weekly_rest_profile_keys/1, weekly_rest_what_if/4, date/3, indeterminate/1, needs_legal_review/2, open_textured/2, inputs_relied_on/1, provenance/2, input_problems/1, unknown_key/1, wrong_type/1, duplicate_key/1, weekly_rest_given/0, weekly_rest_not_given/0, weekly_rest_not_applied_to_worker/0, weekly_rest_derogation_applies/0, no_period_without_weekly_rest/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_lists_extra, [is_list/1]).
:- use_module(clausal_hof, [exclude/3]).
:- use_module(m__eu_labour_weekly_rest_kernel, [weekly_rest_input_problems/2]).
:- use_module(m__eu_labour_weekly_rest_weekly_rest, [weekly_rest_status/2]).

weekly_rest_given.

weekly_rest_not_given.

weekly_rest_not_applied_to_worker.

weekly_rest_derogation_applies.

no_period_without_weekly_rest.

date(Year, Month, Day) :-
    integer(Year),
    integer(Month),
    integer(Day).

indeterminate(MissingKeys) :-
    is_list(MissingKeys).

needs_legal_review(Reason, Context) :-
    compound(Reason),
    is_list(Context).

open_textured(Input, Citation) :-
    atom(Input),
    compound(Citation).

inputs_relied_on(Pairs) :-
    is_list(Pairs).

provenance(Clause, Citations) :-
    nonvar(Clause),
    is_list(Citations).

input_problems(Problems) :-
    is_list(Problems).

unknown_key(Key) :-
    term_variables(Key, _Variables).

wrong_type(Key) :-
    nonvar(Key).

duplicate_key(Key) :-
    atom(Key).

weekly_rest_profile_keys([on_call_on_site_counts_as_working_time, on_call_standby_counts_as_working_time, weekly_rest_minimum, weekly_rest_reference_period, worker_category, derogation_from_article_5]).

weekly_rest_what_if(weekly_rest_case(Profile, Worker, Shifts, PeriodStart, PeriodEnd), OverriddenKey, NewValue, NewStatus) :-
    weekly_rest_input_problems(Profile, Problems),
    override_for(Problems, Profile, OverriddenKey, NewValue, Hypothesis),
    weekly_rest_status(weekly_rest_case(Hypothesis, Worker, Shifts, PeriodStart, PeriodEnd), NewStatus).

override_for([wrong_type(profile)], Profile, _, _, Profile).
override_for([], Profile, OverriddenKey, NewValue, Hypothesis) :-
    replace_attribute(Profile, OverriddenKey, NewValue, Hypothesis).
override_for([FirstProblem|OtherProblems], Profile, OverriddenKey, NewValue, Hypothesis) :-
    dif([FirstProblem|OtherProblems], [wrong_type(profile)]),
    replace_attribute(Profile, OverriddenKey, NewValue, Hypothesis).

replace_attribute(Profile, OverriddenKey, NewValue, Hypothesis) :-
    exclude(attribute_with_key(OverriddenKey), Profile, OtherItems),
    append(OtherItems, [attribute(OverriddenKey, NewValue)], Hypothesis).

attribute_with_key(OverriddenKey, attribute(ElementKey, _)) :-
    ElementKey == OverriddenKey.
