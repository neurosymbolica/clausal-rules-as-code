% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_ai_act_conformity_marking_registration_kernel, [conformity_marking_registration_input_problems/2, real_calendar_day_t/2]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(library(error), [must_be/2]).
:- use_module(library(reif), [memberd_t/3]).
:- use_module(deadline_lib, [month_last_day/3]).

conformity_marking_registration_input_problems(Profile, Problems) :-
    attribute_list_t(Profile, IsAttributeList),
    profile_problems(IsAttributeList, Profile, Problems).

profile_problems(false, _, [wrong_type(profile)]).
profile_problems(true, Profile, Problems) :-
    Keys = [annex_iii_point, provider_concluded_under_article_6_3_that_the_system_is_not_high_risk, covered_by_union_harmonisation_legislation_listed_in_section_a_of_annex_i, component_of_an_annex_x_large_scale_it_system_placed_on_the_market_or_put_into_service_before_2_august_2027, placed_on_the_market_or_put_into_service_before_the_application_day, significant_changes_in_design_from_the_application_day, intended_to_be_used_by_public_authorities, harmonised_standards_or_common_specifications_applied_in_full, applied_harmonised_standard_published_with_a_restriction, harmonisation_legislation_offers_an_option_without_third_party_conformity_assessment, intended_to_be_put_into_service_by_law_enforcement_immigration_or_asylum_authorities_or_union_institutions_bodies_offices_or_agencies, already_subject_to_a_conformity_assessment_procedure, change_pre_determined_for_a_system_that_continues_to_learn, substantial_modification, other_union_harmonisation_legislation_requires_an_eu_declaration_of_conformity, provided_digitally, affixing_to_the_system_possible_and_warranted, notified_body_involved_in_the_conformity_assessment, other_union_law_provides_for_affixing_the_ce_marking, deployer_is_a_public_authority_or_union_institution_body_office_or_agency_or_acts_on_their_behalf],
    unknown_keys(Profile, Keys, UnknownKeyProblems),
    key_problems(Keys, Profile, UnknownKeyProblems, Problems).

key_type(annex_iii_point, annex_iii_point).
key_type(provider_concluded_under_article_6_3_that_the_system_is_not_high_risk, boolean).
key_type(covered_by_union_harmonisation_legislation_listed_in_section_a_of_annex_i, boolean).
key_type(component_of_an_annex_x_large_scale_it_system_placed_on_the_market_or_put_into_service_before_2_august_2027, boolean).
key_type(placed_on_the_market_or_put_into_service_before_the_application_day, boolean).
key_type(significant_changes_in_design_from_the_application_day, judgement).
key_type(intended_to_be_used_by_public_authorities, judgement).
key_type(harmonised_standards_or_common_specifications_applied_in_full, boolean).
key_type(applied_harmonised_standard_published_with_a_restriction, boolean).
key_type(harmonisation_legislation_offers_an_option_without_third_party_conformity_assessment, boolean).
key_type(intended_to_be_put_into_service_by_law_enforcement_immigration_or_asylum_authorities_or_union_institutions_bodies_offices_or_agencies, judgement).
key_type(already_subject_to_a_conformity_assessment_procedure, boolean).
key_type(change_pre_determined_for_a_system_that_continues_to_learn, boolean).
key_type(substantial_modification, judgement).
key_type(other_union_harmonisation_legislation_requires_an_eu_declaration_of_conformity, boolean).
key_type(provided_digitally, boolean).
key_type(affixing_to_the_system_possible_and_warranted, judgement).
key_type(notified_body_involved_in_the_conformity_assessment, boolean).
key_type(other_union_law_provides_for_affixing_the_ce_marking, boolean).
key_type(deployer_is_a_public_authority_or_union_institution_body_office_or_agency_or_acts_on_their_behalf, boolean).

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

in_type_t(annex_iii_point, Value, T) :-
    in_type_t(enum([not_listed_in_annex_iii, annex_iii_point_1, annex_iii_point_2, annex_iii_point_3, annex_iii_point_4, annex_iii_point_5, annex_iii_point_6, annex_iii_point_7, annex_iii_point_8]), Value, T).
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

real_calendar_day_t(Term, false) :-
    var(Term).
real_calendar_day_t(Term, T) :-
    nonvar(Term),
    Term = date(Year, Month, Day),
    integer_t(Year, YearIsInteger),
    integer_t(Month, MonthIsInteger),
    integer_t(Day, DayIsInteger),
    truth_and(YearIsInteger, MonthIsInteger, YearAndMonthAreIntegers),
    truth_and(YearAndMonthAreIntegers, DayIsInteger, FieldsAreIntegers),
    calendar_fields_t(FieldsAreIntegers, Year, Month, Day, T).
real_calendar_day_t(Term, false) :-
    nonvar(Term),
    Term \= date(_, _, _).

integer_t(Term, T) :-
    catch(integer_check(Term, T), error(_, _), T = false).

integer_check(Term, true) :-
    must_be(integer, Term).

calendar_fields_t(false, _, _, _, false).
calendar_fields_t(true, Year, Month, Day, T) :-
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
range_t(Value, _, High, false) :-
    Value > High.

test(an_empty_profile_has_no_problem) :-
    conformity_marking_registration_input_problems([], []).
test(a_well_typed_profile_has_no_problem) :-
    conformity_marking_registration_input_problems([attribute(annex_iii_point, annex_iii_point_2), attribute(substantial_modification, unsure)], []).
test(a_crisp_key_given_unsure_is_a_wrong_type) :-
    conformity_marking_registration_input_problems([attribute(provided_digitally, unsure)], [wrong_type(provided_digitally)]).
test(a_repeated_key_is_a_duplicate_only) :-
    conformity_marking_registration_input_problems([attribute(provided_digitally, true), attribute(provided_digitally, maybe)], [duplicate_key(provided_digitally)]).
test(a_key_outside_the_contract_is_unknown) :-
    conformity_marking_registration_input_problems([attribute(colour, red)], [unknown_key(colour)]).
test(a_term_that_is_not_a_list_is_not_a_profile) :-
    conformity_marking_registration_input_problems(colour, [wrong_type(profile)]).
test(an_unbound_profile_is_not_a_profile) :-
    conformity_marking_registration_input_problems(_, [wrong_type(profile)]).
test(the_input_check_has_one_answer) :-
    findall(Problems, conformity_marking_registration_input_problems([attribute(annex_iii_point, point_nine)], Problems), Answers),
    Answers == [[wrong_type(annex_iii_point)]].
test(a_leap_day_is_a_real_day) :-
    real_calendar_day_t(date(2028, 2, 29), true).
test(a_leap_day_in_a_common_year_is_not_a_real_day) :-
    real_calendar_day_t(date(2027, 2, 29), false).
test(an_ordinary_day_is_a_real_day) :-
    real_calendar_day_t(date(2027, 12, 2), true).
test(month_thirteen_is_not_a_real_day) :-
    real_calendar_day_t(date(2027, 13, 1), false).
test(an_atom_is_not_a_date) :-
    real_calendar_day_t(tomorrow, false).
test(an_unbound_date_is_not_a_date) :-
    real_calendar_day_t(_, false).
test(a_date_with_an_unbound_field_is_not_a_date) :-
    real_calendar_day_t(date(2027, _, 1), false).
test(the_calendar_check_has_one_answer) :-
    findall(Truth, real_calendar_day_t(date(2030, 12, 31), Truth), Answers),
    Answers == [true].
