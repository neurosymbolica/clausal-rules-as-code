% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_ai_act_serious_incident_reporting_kernel, [serious_incident_reporting_input_problems/2, serious_incident_reporting_root_key/2, serious_incident_reporting_key_type/2, calendar_date_t/2]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_aggregate, [aggregate_all/3]).
:- use_module(library(reif), [memberd_t/3]).
:- use_module(deadline_lib, [month_last_day/3]).

serious_incident_reporting_root_key(high_risk_classification, 0).
serious_incident_reporting_root_key(placed_before_chapter_iii_application_date, 1).
serious_incident_reporting_root_key(significant_change_in_design_since_that_date, 2).
serious_incident_reporting_root_key(intended_to_be_used_by_public_authorities, 3).
serious_incident_reporting_root_key(medical_device_or_safety_component_of_one, 4).
serious_incident_reporting_root_key(provider_subject_to_equivalent_union_reporting_obligations, 5).
serious_incident_reporting_root_key(harm_to_health, 6).
serious_incident_reporting_root_key(critical_infrastructure_disruption, 7).
serious_incident_reporting_root_key(fundamental_rights_obligations_infringed, 8).
serious_incident_reporting_root_key(serious_harm_to_property_or_environment, 9).
serious_incident_reporting_root_key(widespread_infringement, 10).
serious_incident_reporting_root_key(report_made_immediately, 11).

serious_incident_reporting_key_type(Key, Type) :-
    key_type(Key, Type).

serious_incident_reporting_input_problems(Profile, Problems) :-
    attribute_list_t(Profile, IsAttributeList),
    profile_problems(IsAttributeList, Profile, Problems).

profile_problems(false, _, [wrong_type(profile)]).
profile_problems(true, Profile, Problems) :-
    Keys = [high_risk_classification, placed_before_chapter_iii_application_date, significant_change_in_design_since_that_date, intended_to_be_used_by_public_authorities, medical_device_or_safety_component_of_one, provider_subject_to_equivalent_union_reporting_obligations, harm_to_health, critical_infrastructure_disruption, fundamental_rights_obligations_infringed, serious_harm_to_property_or_environment, widespread_infringement, report_made_immediately],
    unknown_keys(Profile, Keys, UnknownKeyProblems),
    key_problems(Keys, Profile, UnknownKeyProblems, Problems).

key_type(high_risk_classification, enum([annex_iii_high_risk, annex_i_high_risk, not_high_risk])).
key_type(placed_before_chapter_iii_application_date, boolean).
key_type(significant_change_in_design_since_that_date, judgement).
key_type(intended_to_be_used_by_public_authorities, boolean).
key_type(medical_device_or_safety_component_of_one, boolean).
key_type(provider_subject_to_equivalent_union_reporting_obligations, judgement).
key_type(harm_to_health, enum([death_of_a_person, serious_harm_to_health_without_death, no_death_or_serious_harm_to_health])).
key_type(critical_infrastructure_disruption, boolean).
key_type(fundamental_rights_obligations_infringed, boolean).
key_type(serious_harm_to_property_or_environment, boolean).
key_type(widespread_infringement, judgement).
key_type(report_made_immediately, judgement).

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

unknown_keys([], _, []).
unknown_keys([attribute(Key, _)|Elements], Known, Problems) :-
    identical_member_t(Key, Known, IsKnown),
    name_unknown_key(IsKnown, Key, Known, Elements, Problems).

name_unknown_key(true, _, Known, Elements, Problems) :-
    unknown_keys(Elements, Known, Problems).
name_unknown_key(false, Key, Known, Elements, [unknown_key(Key)|Problems]) :-
    term_variables(Key, KeyVariables),
    maplist(=(unbound_key), KeyVariables),
    unknown_keys(Elements, [Key|Known], Problems).

identical_member_t(_, [], false).
identical_member_t(Term, [Item|_], true) :-
    Term == Item.
identical_member_t(Term, [Item|Items], T) :-
    Term \== Item,
    identical_member_t(Term, Items, T).

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

in_type_t(judgement, Value, T) :-
    in_type_t(one_of([boolean, enum([unsure])]), Value, T).
in_type_t(boolean, Value, T) :-
    memberd_t(Value, [true, false], T).
in_type_t(enum(Values), Value, T) :-
    memberd_t(Value, Values, T).
in_type_t(one_of(Types), Value, T) :-
    in_some_type_t(Types, Value, T).

truth_and(true, T, T).
truth_and(false, _, false).

in_some_type_t([], _, false).
in_some_type_t([Type|Types], Value, T) :-
    in_type_t(Type, Value, InType),
    in_some_type_t(Types, Value, InAnother),
    truth_or(InType, InAnother, T).

truth_or(true, _, true).
truth_or(false, T, T).

calendar_date_t(Term, false) :-
    var(Term).
calendar_date_t(Term, false) :-
    nonvar(Term),
    Term \= date(_, _, _).
calendar_date_t(Term, T) :-
    nonvar(Term),
    Term = date(Year, Month, Day),
    integer_t(Year, YearIsInteger),
    integer_t(Month, MonthIsInteger),
    integer_t(Day, DayIsInteger),
    truth_and(YearIsInteger, MonthIsInteger, YearAndMonthAreIntegers),
    truth_and(YearAndMonthAreIntegers, DayIsInteger, FieldsAreIntegers),
    integer_fields_date_t(FieldsAreIntegers, Year, Month, Day, T).

integer_t(Value, T) :-
    aggregate_all(count, integer(Value), Count),
    count_truth(Count, T).

count_truth(0, false).
count_truth(1, true).

integer_fields_date_t(false, _, _, _, false).
integer_fields_date_t(true, Year, Month, Day, T) :-
    range_t(Year, 1, 9999, YearInRange),
    range_t(Month, 1, 12, MonthInRange),
    truth_and(YearInRange, MonthInRange, YearAndMonthInRange),
    month_day_t(YearAndMonthInRange, Year, Month, Day, T).

month_day_t(false, _, _, _, false).
month_day_t(true, Year, Month, Day, T) :-
    month_last_day(Year, Month, LastDay),
    range_t(Day, 1, LastDay, T).

range_t(Value, Low, High, true) :-
    Value >= Low,
    Value =< High.
range_t(Value, Low, _, false) :-
    Value < Low.
range_t(Value, Low, High, false) :-
    Value >= Low,
    Value > High.
