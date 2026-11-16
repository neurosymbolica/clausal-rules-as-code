% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_nis2_implementing_regulation_significant_incidents_kernel, [nis2_implementing_regulation_significant_incidents_input_problems/2, significant/0, not_significant/0, indeterminate/1, needs_legal_review/2, open_textured/2, inputs_relied_on/1, provenance/2, input_problems/1, unknown_key/1, wrong_type/1, duplicate_key/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(library(reif), [memberd_t/3]).

significant.

not_significant.

indeterminate([_|_]).

needs_legal_review(_Reason, Context) :-
    nonvar(Context).
needs_legal_review(_Reason, Context) :-
    var(Context),
    Context = [].

open_textured(Key, cite(Cite)) :-
    atom(Key),
    atom(Cite).

inputs_relied_on([]).
inputs_relied_on([_|_]).

provenance(_Source, Detail) :-
    nonvar(Detail).
provenance(_Source, Detail) :-
    var(Detail),
    Detail = [].

input_problems([_|_]).

unknown_key(Key) :-
    nonvar(Key).

wrong_type(Key) :-
    atom(Key).

duplicate_key(Key) :-
    atom(Key).

nis2_implementing_regulation_significant_incidents_input_problems(Profile, Problems) :-
    attribute_list_t(Profile, IsAttributeList),
    profile_problems(IsAttributeList, Profile, Problems).

profile_problems(false, _, [wrong_type(profile)]).
profile_problems(true, Profile, Problems) :-
    Keys = [scheduled_interruption_or_maintenance, relevant_entity_type, direct_financial_loss_euro_cents, annual_turnover_preceding_financial_year_euro_cents, trade_secret_exfiltration, death_of_natural_person, considerable_damage_to_natural_person_health, suspectedly_malicious_unauthorised_access_capable_of_severe_operational_disruption, recurring_incidents_within_six_months, same_apparent_root_cause, recurring_collective_direct_financial_loss_euro_cents, complete_unavailability_seconds, average_response_time_above_ten_seconds_seconds, limited_availability_seconds, weekly_unavailability_seconds, complete_unavailability_users, limited_availability_users, data_compromise_users, service_users_in_union, data_compromised, data_compromise_suspectedly_malicious, physical_access_compromised, incorrect_data_only_by_misconfiguration, incorrect_domain_names, managed_domain_names],
    unknown_keys(Profile, Keys, UnknownKeyProblems),
    key_problems(Keys, Profile, UnknownKeyProblems, Problems).

key_type(scheduled_interruption_or_maintenance, boolean).
key_type(relevant_entity_type, relevant_entity_type).
key_type(direct_financial_loss_euro_cents, non_negative_integer).
key_type(annual_turnover_preceding_financial_year_euro_cents, non_negative_integer).
key_type(trade_secret_exfiltration, judgement).
key_type(death_of_natural_person, judgement).
key_type(considerable_damage_to_natural_person_health, judgement).
key_type(suspectedly_malicious_unauthorised_access_capable_of_severe_operational_disruption, judgement).
key_type(recurring_incidents_within_six_months, non_negative_integer).
key_type(same_apparent_root_cause, judgement).
key_type(recurring_collective_direct_financial_loss_euro_cents, non_negative_integer).
key_type(complete_unavailability_seconds, non_negative_integer).
key_type(average_response_time_above_ten_seconds_seconds, non_negative_integer).
key_type(limited_availability_seconds, non_negative_integer).
key_type(weekly_unavailability_seconds, non_negative_integer).
key_type(complete_unavailability_users, non_negative_integer).
key_type(limited_availability_users, non_negative_integer).
key_type(data_compromise_users, non_negative_integer).
key_type(service_users_in_union, non_negative_integer).
key_type(data_compromised, judgement).
key_type(data_compromise_suspectedly_malicious, judgement).
key_type(physical_access_compromised, judgement).
key_type(incorrect_data_only_by_misconfiguration, boolean).
key_type(incorrect_domain_names, non_negative_integer).
key_type(managed_domain_names, non_negative_integer).

attribute_list_t(Term, false) :-
    var(Term).
attribute_list_t(Term, true) :-
    Term == [].
attribute_list_t(Term, T) :-
    nonvar(Term),
    Term = [Element|Elements],
    attribute_t(Element, ElementIsAttribute),
    attribute_list_t(Elements, ElementsAreAttributes),
    truth_and(ElementIsAttribute, ElementsAreAttributes, T).
attribute_list_t(Term, false) :-
    nonvar(Term),
    Term \== [],
    Term \= [_|_].

attribute_t(Element, false) :-
    var(Element).
attribute_t(Element, true) :-
    nonvar(Element),
    Element = attribute(_, _).
attribute_t(Element, false) :-
    nonvar(Element),
    Element \= attribute(_, _).

identical_member_t(_, [], false).
identical_member_t(Key, [Known|_], true) :-
    Key == Known.
identical_member_t(Key, [Known|Knowns], Truth) :-
    Key \== Known,
    identical_member_t(Key, Knowns, Truth).

unknown_keys([], _, []).
unknown_keys([attribute(Key, _)|Elements], Known, Problems) :-
    identical_member_t(Key, Known, IsKnown),
    name_unknown_key(IsKnown, Key, Known, Elements, Problems).

name_unknown_key(true, _, Known, Elements, Problems) :-
    unknown_keys(Elements, Known, Problems).
name_unknown_key(false, Key, Known, Elements, [unknown_key(Key)|Problems]) :-
    unknown_keys(Elements, [Key|Known], Problems).

key_problems([], _, Problems, Problems).
key_problems([Key|Keys], Profile, LaterProblems, Problems) :-
    key_type(Key, Type),
    key_occurrences(Profile, Key, Occurrences),
    key_problems(Keys, Profile, LaterProblems, KeyProblems),
    name_key_problem(Occurrences, Key, Type, Profile, KeyProblems, Problems).

key_occurrences([], _, none).
key_occurrences([attribute(ElementKey, _)|Elements], Key, Occurrences) :-
    ElementKey == Key,
    key_occurrences(Elements, Key, RestOccurrences),
    one_more_occurrence(RestOccurrences, Occurrences).
key_occurrences([attribute(ElementKey, _)|Elements], Key, Occurrences) :-
    ElementKey \== Key,
    key_occurrences(Elements, Key, Occurrences).

one_more_occurrence(none, one).
one_more_occurrence(one, many).
one_more_occurrence(many, many).

name_key_problem(none, _, _, _, Problems, Problems).
name_key_problem(many, Key, _, _, Problems, [duplicate_key(Key)|Problems]).
name_key_problem(one, Key, Type, Profile, KeyProblems, Problems) :-
    values_in_type_t(Profile, Key, Type, InType),
    name_wrong_type(InType, Key, KeyProblems, Problems).

name_wrong_type(true, _, Problems, Problems).
name_wrong_type(false, Key, Problems, [wrong_type(Key)|Problems]).

values_in_type_t([], _, _, true).
values_in_type_t([attribute(ElementKey, Value)|Elements], Key, Type, T) :-
    ElementKey == Key,
    value_in_type_t(Type, Value, ValueInType),
    values_in_type_t(Elements, Key, Type, RestInType),
    truth_and(ValueInType, RestInType, T).
values_in_type_t([attribute(ElementKey, _)|Elements], Key, Type, T) :-
    ElementKey \== Key,
    values_in_type_t(Elements, Key, Type, T).

value_in_type_t(Type, Value, T) :-
    term_variables(Value, Variables),
    ground_value_in_type_t(Variables, Type, Value, T).

ground_value_in_type_t([_|_], _, _, false).
ground_value_in_type_t([], Type, Value, T) :-
    in_type_t(Type, Value, T).

in_type_t(relevant_entity_type, Value, T) :-
    in_type_t(enum([dns_service_provider, tld_name_registry, cloud_computing_service_provider, data_centre_service_provider, content_delivery_network_provider, managed_service_provider, managed_security_service_provider, online_marketplace_provider, online_search_engine_provider, social_networking_services_platform_provider, trust_service_provider]), Value, T).
in_type_t(judgement, Value, T) :-
    in_type_t(one_of([boolean, enum([unsure])]), Value, T).
in_type_t(boolean, Value, T) :-
    memberd_t(Value, [true, false], T).
in_type_t(enum(Values), Value, T) :-
    memberd_t(Value, Values, T).
in_type_t(one_of(Types), Value, T) :-
    in_some_type_t(Types, Value, T).
in_type_t(non_negative_integer, Value, T) :-
    non_negative_integer_t(Value, T).

truth_and(true, T, T).
truth_and(false, _, false).

in_some_type_t([], _, false).
in_some_type_t([Type|Types], Value, T) :-
    in_type_t(Type, Value, InType),
    in_some_type_t(Types, Value, InAnother),
    truth_or(InType, InAnother, T).

truth_or(true, _, true).
truth_or(false, T, T).

integer_t(Value, true) :-
    integer(Value).
integer_t(Value, false) :-
    float(Value).
integer_t(Value, false) :-
    atom(Value).
integer_t(Value, false) :-
    compound(Value).

non_negative_integer_t(Value, T) :-
    integer_t(Value, IsInteger),
    not_below_zero_t(IsInteger, Value, T).

not_below_zero_t(false, _, false).
not_below_zero_t(true, Value, true) :-
    Value >= 0.
not_below_zero_t(true, Value, false) :-
    Value < 0.
