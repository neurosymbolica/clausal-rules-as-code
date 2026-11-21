% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_labour_night_work_kernel, [night_work_input_problems/2]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(library(clpz)).
:- use_module(library(reif), [memberd_t/3]).

night_work_input_problems(Profile, Problems) :-
    attribute_list_t(Profile, IsAttributeList),
    profile_problems(IsAttributeList, Profile, Problems).

profile_problems(false, _, [wrong_type(profile)]).
profile_problems(true, Profile, Problems) :-
    Keys = [on_call_on_site_counts_as_working_time, on_call_standby_counts_as_working_time, night_time_start, night_time_end, night_work_reference_period_days, worker_category, night_worker, special_hazards_or_heavy_strain, derogation_from_article_8],
    unknown_keys(Profile, Keys, UnknownKeyProblems),
    key_problems(Keys, Profile, UnknownKeyProblems, Problems).

key_type(on_call_on_site_counts_as_working_time, judgement).
key_type(on_call_standby_counts_as_working_time, judgement).
key_type(night_time_start, night_time_start_minute).
key_type(night_time_end, night_time_end_minute).
key_type(night_work_reference_period_days, reference_period_days).
key_type(worker_category, worker_category_atom).
key_type(night_worker, judgement).
key_type(special_hazards_or_heavy_strain, judgement).
key_type(derogation_from_article_8, derogation_from_article_8_atom).

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
    known_t(Key, Known, IsKnown),
    name_unknown_key(IsKnown, Key, Known, Elements, Problems).

known_t(_, [], false).
known_t(Key, [Known|_], true) :-
    Known == Key.
known_t(Key, [Known|Knowns], T) :-
    Known \== Key,
    known_t(Key, Knowns, T).

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
    cross_key_rule_t(InType, Key, Profile, Kept),
    name_wrong_type(Kept, Key, KeyProblems, Problems).

name_wrong_type(true, _, Problems, Problems).
name_wrong_type(false, Key, Problems, [wrong_type(Key)|Problems]).

cross_key_rule_t(false, _, _, false).
cross_key_rule_t(true, Key, Profile, T) :-
    cross_key_rule_for_t(Key, Profile, T).

cross_key_rule_for_t(night_time_end, Profile, T) :-
    key_occurrences(Profile, night_time_start, StartOccurrences),
    night_time_rule_t(StartOccurrences, Profile, T).
cross_key_rule_for_t(Key, _, true) :-
    dif(Key, night_time_end).

night_time_rule_t(none, _, true).
night_time_rule_t(many, _, true).
night_time_rule_t(one, Profile, T) :-
    key_value(Profile, night_time_start, Start),
    value_in_type_t(night_time_start_minute, Start, StartInType),
    night_time_start_rule_t(StartInType, Profile, Start, T).

night_time_start_rule_t(false, _, _, true).
night_time_start_rule_t(true, Profile, Start, T) :-
    key_value(Profile, night_time_end, End),
    night_time_pair_t(Start, End, T).

night_time_pair_t(Start, End, true) :-
    Start #= 0,
    End #>= 420.
night_time_pair_t(Start, End, false) :-
    Start #= 0,
    End #< 420.
night_time_pair_t(Start, End, true) :-
    Start #>= 301,
    End #< Start,
    1440 - Start + End #>= 420.
night_time_pair_t(Start, End, false) :-
    Start #>= 301,
    End #< Start,
    1440 - Start + End #< 420.
night_time_pair_t(Start, End, false) :-
    Start #>= 301,
    End #>= Start.

key_value([attribute(ElementKey, Value)|_], Key, Value) :-
    ElementKey == Key.
key_value([attribute(ElementKey, _)|Elements], Key, Value) :-
    ElementKey \== Key,
    key_value(Elements, Key, Value).

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
in_type_t(worker_category_atom, Value, T) :-
    in_type_t(enum([other_worker, mobile_worker, seagoing_fishing_vessel_worker]), Value, T).
in_type_t(derogation_from_article_8_atom, Value, T) :-
    in_type_t(enum([no_derogation, derogation_under_article_17_1, derogation_under_article_17_3, derogation_under_article_18]), Value, T).
in_type_t(boolean, Value, T) :-
    memberd_t(Value, [true, false], T).
in_type_t(enum(Values), Value, T) :-
    memberd_t(Value, Values, T).
in_type_t(one_of(Types), Value, T) :-
    in_some_type_t(Types, Value, T).
in_type_t(night_time_start_minute, Value, T) :-
    integer_t(Value, IsInteger),
    integer_in_range_t(IsInteger, night_time_start_minute, Value, T).
in_type_t(night_time_end_minute, Value, T) :-
    integer_t(Value, IsInteger),
    integer_in_range_t(IsInteger, night_time_end_minute, Value, T).
in_type_t(reference_period_days, Value, T) :-
    integer_t(Value, IsInteger),
    integer_in_range_t(IsInteger, reference_period_days, Value, T).

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

integer_in_range_t(false, _, _, false).
integer_in_range_t(true, Range, Value, T) :-
    range_t(Range, Value, T).

range_t(night_time_start_minute, Value, true) :-
    Value #= 0.
range_t(night_time_start_minute, Value, true) :-
    Value #>= 301,
    Value #< 1440.
range_t(night_time_start_minute, Value, false) :-
    Value #\= 0,
    Value #< 301.
range_t(night_time_start_minute, Value, false) :-
    Value #> 1439.
range_t(night_time_end_minute, Value, true) :-
    Value #>= 300,
    Value #< 1440.
range_t(night_time_end_minute, Value, false) :-
    Value #< 300.
range_t(night_time_end_minute, Value, false) :-
    Value #> 1439.
range_t(reference_period_days, Value, true) :-
    Value #>= 1.
range_t(reference_period_days, Value, false) :-
    Value #< 1.

test(an_empty_profile_has_no_problem) :-
    night_work_input_problems([], []).
test(a_full_good_profile_has_no_problem) :-
    night_work_input_problems([attribute(on_call_on_site_counts_as_working_time, true), attribute(on_call_standby_counts_as_working_time, unsure), attribute(night_time_start, 1320), attribute(night_time_end, 300), attribute(night_work_reference_period_days, 7), attribute(worker_category, other_worker), attribute(night_worker, true), attribute(special_hazards_or_heavy_strain, false), attribute(derogation_from_article_8, no_derogation)], []).
test(a_term_that_is_not_a_list_is_not_a_profile) :-
    night_work_input_problems(profile, [wrong_type(profile)]).
test(an_unbound_profile_is_not_a_profile) :-
    night_work_input_problems(_, [wrong_type(profile)]).
test(midnight_start_with_seven_hours_is_kept) :-
    night_work_input_problems([attribute(night_time_start, 0), attribute(night_time_end, 420)], []).
test(midnight_start_with_less_than_seven_hours_breaks_the_rule) :-
    night_work_input_problems([attribute(night_time_start, 0), attribute(night_time_end, 419)], [wrong_type(night_time_end)]).
test(a_night_time_of_six_hours_breaks_the_rule) :-
    night_work_input_problems([attribute(night_time_start, 1380), attribute(night_time_end, 300)], [wrong_type(night_time_end)]).
test(an_end_after_the_start_breaks_the_rule) :-
    night_work_input_problems([attribute(night_time_start, 400), attribute(night_time_end, 1000)], [wrong_type(night_time_end)]).
test(a_start_out_of_range_is_its_own_problem_only) :-
    night_work_input_problems([attribute(night_time_start, 200), attribute(night_time_end, 300)], [wrong_type(night_time_start)]).
test(an_end_out_of_range_is_named_once) :-
    night_work_input_problems([attribute(night_time_start, 1320), attribute(night_time_end, 200)], [wrong_type(night_time_end)]).
test(a_zero_reference_period_is_out_of_range) :-
    night_work_input_problems([attribute(night_work_reference_period_days, 0)], [wrong_type(night_work_reference_period_days)]).
test(a_compound_reference_period_is_wrong_type) :-
    night_work_input_problems([attribute(night_work_reference_period_days, days(7))], [wrong_type(night_work_reference_period_days)]).
test(a_repeated_key_is_a_duplicate_only) :-
    night_work_input_problems([attribute(worker_category, other_worker), attribute(worker_category, bad)], [duplicate_key(worker_category)]).
test(problems_come_in_contract_order_then_unknown_keys) :-
    night_work_input_problems([attribute(colour, red), attribute(derogation_from_article_8, maybe), attribute(night_worker, yes), attribute(colour, blue)], [wrong_type(night_worker), wrong_type(derogation_from_article_8), unknown_key(colour)]).
test(an_unbound_value_is_wrong_type) :-
    night_work_input_problems([attribute(night_worker, _)], [wrong_type(night_worker)]).

test(an_absent_key_is_not_a_problem, fail) :-
    night_work_input_problems([attribute(night_worker, true)], [_|_]).
