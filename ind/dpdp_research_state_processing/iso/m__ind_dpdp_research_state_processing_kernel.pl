% SPDX-License-Identifier: EUPL-1.2
:- module(m__ind_dpdp_research_state_processing_kernel, [dpdp_research_state_processing_input_problems/2, dpdp_research_state_processing_key_state/3, dpdp_research_state_processing_day_before/3, dpdp_research_state_processing_first_step/4, dpdp_research_state_processing_referral/3]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(library(reif), [memberd_t/3]).
:- use_module(formalize_lib, [profile_get/3, profile_has/2, profile_lacks/2]).

dpdp_research_state_processing_input_problems(Profile, Problems) :-
    attribute_list_t(Profile, IsAttributeList),
    profile_problems(IsAttributeList, Profile, Problems).

profile_problems(false, _, [wrong_type(profile)]).
profile_problems(true, Profile, Problems) :-
    Keys = [section_7_in_force_on_reference_date, section_17_in_force_on_reference_date, reference_date, processing_necessary_for_research_archiving_or_statistical_purposes, personal_data_to_be_used_for_decision_specific_to_data_principal, processing_for_section_7_b_use, lawful_manner, limited_to_necessary_personal_data, completeness_accuracy_and_consistency, retention_only_while_required, reasonable_security_safeguards, intimation_to_data_principal, business_contact_for_questions, link_and_means_to_exercise_rights, consistent_with_other_applicable_standards, accountability_for_observance, processing_by_state_or_instrumentality, purpose_includes_decision_affecting_data_principal],
    unknown_keys(Profile, Keys, UnknownKeyProblems),
    key_problems(Keys, Profile, UnknownKeyProblems, Problems).

key_type(section_7_in_force_on_reference_date, boolean).
key_type(section_17_in_force_on_reference_date, boolean).
key_type(reference_date, date).
key_type(processing_necessary_for_research_archiving_or_statistical_purposes, judgement).
key_type(personal_data_to_be_used_for_decision_specific_to_data_principal, boolean).
key_type(processing_for_section_7_b_use, judgement).
key_type(lawful_manner, judgement).
key_type(limited_to_necessary_personal_data, judgement).
key_type(completeness_accuracy_and_consistency, judgement).
key_type(retention_only_while_required, judgement).
key_type(reasonable_security_safeguards, judgement).
key_type(intimation_to_data_principal, boolean).
key_type(business_contact_for_questions, boolean).
key_type(link_and_means_to_exercise_rights, boolean).
key_type(consistent_with_other_applicable_standards, judgement).
key_type(accountability_for_observance, judgement).
key_type(processing_by_state_or_instrumentality, judgement).
key_type(purpose_includes_decision_affecting_data_principal, judgement).

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
in_type_t(date, Value, T) :-
    calendar_date_t(Value, T).
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

integer_t(Value, true) :-
    integer(Value).
integer_t(Value, false) :-
    float(Value).
integer_t(Value, false) :-
    atom(Value).
integer_t(Value, false) :-
    compound(Value).

calendar_date_t(date(Year, Month, DayNumber), T) :-
    integer_t(Year, YearIsInteger),
    integer_t(Month, MonthIsInteger),
    integer_t(DayNumber, DayNumberIsInteger),
    truth_and(YearIsInteger, MonthIsInteger, YearAndMonthAreIntegers),
    truth_and(YearAndMonthAreIntegers, DayNumberIsInteger, AllAreIntegers),
    calendar_day_t(AllAreIntegers, Year, Month, DayNumber, T).
calendar_date_t(Value, false) :-
    Value \= date(_, _, _).

calendar_day_t(false, _, _, _, false).
calendar_day_t(true, Year, Month, DayNumber, T) :-
    year_from_one_t(Year, IsYear),
    month_of_year_t(IsYear, Month, IsMonth),
    day_of_month_t(IsMonth, Year, Month, DayNumber, T).

year_from_one_t(Year, true) :-
    Year >= 1.
year_from_one_t(Year, false) :-
    Year < 1.

month_of_year_t(false, _, false).
month_of_year_t(true, Month, IsMonth) :-
    between_t(1, 12, Month, IsMonth).

day_of_month_t(false, _, _, _, false).
day_of_month_t(true, Year, Month, DayNumber, T) :-
    month_length(Year, Month, Length),
    between_t(1, Length, DayNumber, T).

between_t(Lowest, Highest, Number, true) :-
    Number >= Lowest,
    Number =< Highest.
between_t(Lowest, _, Number, false) :-
    Number < Lowest.
between_t(_, Highest, Number, false) :-
    Number > Highest.

month_length(_, 1, 31).
month_length(Year, 2, Length) :-
    leap_year_t(Year, IsLeapYear),
    february_length(IsLeapYear, Length).
month_length(_, 3, 31).
month_length(_, 4, 30).
month_length(_, 5, 31).
month_length(_, 6, 30).
month_length(_, 7, 31).
month_length(_, 8, 31).
month_length(_, 9, 30).
month_length(_, 10, 31).
month_length(_, 11, 30).
month_length(_, 12, 31).

february_length(true, 29).
february_length(false, 28).

leap_year_t(Year, IsLeapYear) :-
    FourYearRemainder is Year mod 4,
    CenturyRemainder is Year mod 100,
    FourCenturyRemainder is Year mod 400,
    gregorian_leap_year_t(FourYearRemainder, CenturyRemainder, FourCenturyRemainder, IsLeapYear).

gregorian_leap_year_t(_, _, 0, true).
gregorian_leap_year_t(0, CenturyRemainder, _, true) :-
    CenturyRemainder =\= 0.
gregorian_leap_year_t(_, 0, FourCenturyRemainder, false) :-
    FourCenturyRemainder =\= 0.
gregorian_leap_year_t(FourYearRemainder, _, _, false) :-
    FourYearRemainder =\= 0.

dpdp_research_state_processing_key_state(Profile, Key, absent) :-
    profile_lacks(Profile, Key).
dpdp_research_state_processing_key_state(Profile, Key, State) :-
    profile_has(Profile, Key),
    profile_get(Profile, Key, State).

dpdp_research_state_processing_day_before(date(FirstYear, FirstMonth, FirstDayNumber), date(SecondYear, SecondMonth, SecondDayNumber), Verdict) :-
    integer_order(FirstYear, SecondYear, YearOrder),
    integer_order(FirstMonth, SecondMonth, MonthOrder),
    integer_order(FirstDayNumber, SecondDayNumber, DayOrder),
    day_order(YearOrder, MonthOrder, DayOrder, Verdict).

integer_order(First, Second, earlier) :-
    First < Second.
integer_order(First, Second, same) :-
    First =:= Second.
integer_order(First, Second, later) :-
    First > Second.

day_order(earlier, _, _, before).
day_order(later, _, _, not_before).
day_order(same, earlier, _, before).
day_order(same, later, _, not_before).
day_order(same, same, earlier, before).
day_order(same, same, same, not_before).
day_order(same, same, later, not_before).

dpdp_research_state_processing_first_step([step(Test, StepResult, StepCitations)|Steps], Profile, Result, Citations) :-
    call(Test, Profile, Verdict),
    take_step(Verdict, StepResult, StepCitations, Steps, Profile, Result, Citations).

take_step(holds, Result, Citations, _, _, Result, Citations).
take_step(does_not_hold, _, _, Steps, Profile, Result, Citations) :-
    dpdp_research_state_processing_first_step(Steps, Profile, Result, Citations).

dpdp_research_state_processing_referral(Key, CitationKey, needs_legal_review(open_textured(Key, cite(CitationKey)), [inputs_relied_on([Key - unsure])])).

test(a_well_formed_profile_has_no_problem) :-
    dpdp_research_state_processing_input_problems([attribute(lawful_manner, unsure)], []).
test(a_judgement_outside_its_type_is_wrong_type) :-
    dpdp_research_state_processing_input_problems([attribute(lawful_manner, maybe)], [wrong_type(lawful_manner)]).
test(a_crisp_key_given_unsure_is_wrong_type) :-
    dpdp_research_state_processing_input_problems([attribute(intimation_to_data_principal, unsure)], [wrong_type(intimation_to_data_principal)]).
test(a_repeated_key_is_a_duplicate_only) :-
    dpdp_research_state_processing_input_problems([attribute(lawful_manner, maybe), attribute(lawful_manner, true)], [duplicate_key(lawful_manner)]).
test(an_unknown_key_is_named_once) :-
    dpdp_research_state_processing_input_problems([attribute(colour, red), attribute(colour, blue)], [unknown_key(colour)]).
test(a_non_list_is_wrong_type_profile) :-
    dpdp_research_state_processing_input_problems(nothing, [wrong_type(profile)]).
test(an_absent_key_reads_as_absent) :-
    dpdp_research_state_processing_key_state([], lawful_manner, absent).
test(a_present_key_reads_its_value) :-
    dpdp_research_state_processing_key_state([attribute(lawful_manner, unsure)], lawful_manner, unsure).
test(the_day_before_commencement_is_before) :-
    dpdp_research_state_processing_day_before(date(2027, 5, 12), date(2027, 5, 13), before).
test(the_commencement_day_is_not_before) :-
    dpdp_research_state_processing_day_before(date(2027, 5, 13), date(2027, 5, 13), not_before).
test(a_later_year_is_not_before) :-
    dpdp_research_state_processing_day_before(date(10000, 1, 1), date(2027, 5, 13), not_before).
test(the_referral_carries_one_pair) :-
    dpdp_research_state_processing_referral(lawful_manner, in_dpdp_rules_2025_sch_2_a, needs_legal_review(open_textured(lawful_manner, cite(in_dpdp_rules_2025_sch_2_a)), [inputs_relied_on([lawful_manner - unsure])])).

test(a_present_key_is_not_absent, fail) :-
    dpdp_research_state_processing_key_state([attribute(lawful_manner, true)], lawful_manner, absent).
test(the_commencement_day_is_not_before_itself, fail) :-
    dpdp_research_state_processing_day_before(date(2027, 5, 13), date(2027, 5, 13), before).
