% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_ai_act_penalties_kernel, [penalties_input_problems/2, penalties_query_input_problems/3, penalties_date_problems/2, penalties_date_relation/3, penalties_first_absent_key/3]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(library(clpz)).
:- use_module(library(reif), [memberd_t/3]).
:- use_module(formalize_lib, [profile_has/2, profile_lacks/2]).
:- use_module(deadline_lib, [month_last_day/3]).

penalties_input_problems(Profile, Problems) :-
    attribute_list_t(Profile, IsAttributeList),
    profile_problems(IsAttributeList, Profile, Problems).

profile_problems(false, _, [wrong_type(profile)]).
profile_problems(true, Profile, Problems) :-
    Keys = [offender_category, infringement, offender_is_general_purpose_ai_model_provider, general_purpose_ai_model_infringement, provider_acted_intentionally_or_negligently, worldwide_annual_turnover_eur],
    unknown_keys(Profile, Keys, UnknownKeyProblems),
    key_problems(Keys, Profile, UnknownKeyProblems, Problems).

key_type(offender_category, enum([micro_small_or_medium_sized_enterprise, small_mid_cap_enterprise, other_undertaking, not_an_undertaking, public_authority_or_body, union_institution_body_office_or_agency])).
key_type(infringement, enum([prohibited_practice, prohibited_practice_under_article_5_1_ba_bb_1a_or_1b, provider_obligations_under_article_16, authorised_representative_obligations_under_article_22, importer_obligations_under_article_23, distributor_obligations_under_article_24, provider_and_operator_obligations_under_article_25_2_or_4, deployer_obligations_under_article_26, notified_body_requirements_and_obligations, transparency_obligations_under_article_50, incorrect_incomplete_or_misleading_information, other_infringement])).
key_type(offender_is_general_purpose_ai_model_provider, boolean).
key_type(general_purpose_ai_model_infringement, enum([infringed_relevant_provisions, information_request_not_complied_with_or_incorrect_information, measure_under_article_93_not_complied_with, access_for_evaluation_under_article_92_not_given, none_of_article_101_1])).
key_type(provider_acted_intentionally_or_negligently, judgement).
key_type(worldwide_annual_turnover_eur, non_negative_integer).

attribute_list_t(Term, false) :-
    var(Term).
attribute_list_t(Term, true) :-
    Term == [].
attribute_list_t(Term, Truth) :-
    nonvar(Term),
    Term = [Element|Elements],
    attribute_t(Element, ElementIsAttribute),
    attribute_list_t(Elements, ElementsAreAttributes),
    truth_and(ElementIsAttribute, ElementsAreAttributes, Truth).
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
    unknown_keys(Elements, [Key|Known], Problems).

identical_member_t(_, [], false).
identical_member_t(Item, [Element|_], true) :-
    Element == Item.
identical_member_t(Item, [Element|Elements], Truth) :-
    Element \== Item,
    identical_member_t(Item, Elements, Truth).

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
values_in_type_t([attribute(ElementKey, Value)|Elements], Key, Type, Truth) :-
    ElementKey == Key,
    value_in_type_t(Type, Value, ValueInType),
    values_in_type_t(Elements, Key, Type, RestInType),
    truth_and(ValueInType, RestInType, Truth).
values_in_type_t([attribute(ElementKey, _)|Elements], Key, Type, Truth) :-
    ElementKey \== Key,
    values_in_type_t(Elements, Key, Type, Truth).

value_in_type_t(Type, Value, Truth) :-
    term_variables(Value, Variables),
    ground_value_in_type_t(Variables, Type, Value, Truth).

ground_value_in_type_t([_|_], _, _, false).
ground_value_in_type_t([], Type, Value, Truth) :-
    in_type_t(Type, Value, Truth).

in_type_t(judgement, Value, Truth) :-
    in_type_t(one_of([boolean, enum([unsure])]), Value, Truth).
in_type_t(boolean, Value, Truth) :-
    memberd_t(Value, [true, false], Truth).
in_type_t(enum(Values), Value, Truth) :-
    memberd_t(Value, Values, Truth).
in_type_t(one_of(Types), Value, Truth) :-
    in_some_type_t(Types, Value, Truth).
in_type_t(non_negative_integer, Value, Truth) :-
    non_negative_integer_t(Value, Truth).

truth_and(true, Truth, Truth).
truth_and(false, _, false).

in_some_type_t([], _, false).
in_some_type_t([Type|Types], Value, Truth) :-
    in_type_t(Type, Value, InType),
    in_some_type_t(Types, Value, InAnother),
    truth_or(InType, InAnother, Truth).

truth_or(true, _, true).
truth_or(false, Truth, Truth).

integer_t(Value, true) :-
    integer(Value).
integer_t(Value, false) :-
    float(Value).
integer_t(Value, false) :-
    atom(Value).
integer_t(Value, false) :-
    compound(Value).

non_negative_integer_t(Value, Truth) :-
    integer_t(Value, IsInteger),
    not_below_zero_t(IsInteger, Value, Truth).

not_below_zero_t(false, _, false).
not_below_zero_t(true, Value, true) :-
    Value >= 0.
not_below_zero_t(true, Value, false) :-
    Value < 0.

penalties_query_input_problems(Profile, Date, Problems) :-
    penalties_input_problems(Profile, ProfileProblems),
    penalties_date_problems(Date, DateProblems),
    append(ProfileProblems, DateProblems, Problems).

penalties_date_problems(Date, []) :-
    real_calendar_day_t(Date, true).
penalties_date_problems(Date, [wrong_type(infringement_date)]) :-
    real_calendar_day_t(Date, false).

real_calendar_day_t(Date, false) :-
    var(Date).
real_calendar_day_t(Date, Truth) :-
    nonvar(Date),
    Date = date(Year, Month, DayOfMonth),
    whole_numbers_t([Year, Month, DayOfMonth], AreWhole),
    calendar_fields_t(AreWhole, Year, Month, DayOfMonth, Truth).
real_calendar_day_t(Date, false) :-
    nonvar(Date),
    Date \= date(_, _, _).

whole_numbers_t([], true).
whole_numbers_t([Field|Fields], Truth) :-
    whole_number_t(Field, IsWhole),
    whole_numbers_t(Fields, AreWhole),
    truth_and(IsWhole, AreWhole, Truth).

whole_number_t(Field, false) :-
    var(Field).
whole_number_t(Field, Truth) :-
    nonvar(Field),
    integer_t(Field, Truth).

calendar_fields_t(false, _, _, _, false).
calendar_fields_t(true, Year, Month, DayOfMonth, Truth) :-
    range_t(Year, 1, 9999, YearInRange),
    range_t(Month, 1, 12, MonthInRange),
    truth_and(YearInRange, MonthInRange, FieldsInRange),
    day_in_month_t(FieldsInRange, Year, Month, DayOfMonth, Truth).

day_in_month_t(false, _, _, _, false).
day_in_month_t(true, Year, Month, DayOfMonth, Truth) :-
    month_last_day(Year, Month, LastDay),
    range_t(DayOfMonth, 1, LastDay, Truth).

range_t(Value, Low, High, true) :-
    Value #>= Low,
    Value #=< High.
range_t(Value, Low, _, false) :-
    Value #< Low.
range_t(Value, _, High, false) :-
    Value #> High.

penalties_date_relation(Date, Reference, before) :-
    calendar_day_key(Date, DateKey),
    calendar_day_key(Reference, ReferenceKey),
    DateKey #< ReferenceKey.
penalties_date_relation(Date, Reference, on_or_after) :-
    calendar_day_key(Date, DateKey),
    calendar_day_key(Reference, ReferenceKey),
    DateKey #>= ReferenceKey.

calendar_day_key(date(Year, Month, DayOfMonth), DayKey) :-
    DayKey #= Year * 10000 + Month * 100 + DayOfMonth.

penalties_first_absent_key(_, [], none_absent).
penalties_first_absent_key(Profile, [Key|_], first_absent(Key)) :-
    profile_lacks(Profile, Key).
penalties_first_absent_key(Profile, [Key|Keys], Result) :-
    profile_has(Profile, Key),
    penalties_first_absent_key(Profile, Keys, Result).

test(a_well_formed_profile_has_no_problem) :-
    penalties_input_problems([attribute(offender_category, other_undertaking), attribute(worldwide_annual_turnover_eur, 100)], []).
test(an_empty_profile_has_no_problem) :-
    penalties_input_problems([], []).
test(a_duplicate_key_is_named_once_and_never_also_wrong_type) :-
    penalties_input_problems([attribute(infringement, prohibited_practice), attribute(infringement, nonsense)], Problems),
    Problems == [duplicate_key(infringement)].
test(wrong_types_come_in_contract_order_before_unknown_keys) :-
    penalties_input_problems([attribute(colour, red), attribute(worldwide_annual_turnover_eur, -1), attribute(offender_is_general_purpose_ai_model_provider, unsure), attribute(colour, blue)], Problems),
    Problems == [wrong_type(offender_is_general_purpose_ai_model_provider), wrong_type(worldwide_annual_turnover_eur), unknown_key(colour)].
test(the_judgement_takes_unsure) :-
    penalties_input_problems([attribute(provider_acted_intentionally_or_negligently, unsure)], []).
test(a_fractional_turnover_is_wrong_type) :-
    penalties_input_problems([attribute(worldwide_annual_turnover_eur, 201/2)], Problems),
    Problems == [wrong_type(worldwide_annual_turnover_eur)].
test(an_unbound_value_is_wrong_type) :-
    penalties_input_problems([attribute(provider_acted_intentionally_or_negligently, _)], Problems),
    Problems == [wrong_type(provider_acted_intentionally_or_negligently)].
test(an_unbound_key_is_an_unknown_key_as_given) :-
    penalties_input_problems([attribute(Key, true)], Problems),
    Problems == [unknown_key(Key)].
test(a_number_key_is_an_unknown_key) :-
    penalties_input_problems([attribute(42, true)], Problems),
    Problems == [unknown_key(42)].
test(a_partial_list_is_not_a_profile) :-
    penalties_input_problems([attribute(infringement, prohibited_practice)|_], Problems),
    Problems == [wrong_type(profile)].
test(a_non_attribute_element_is_not_a_profile) :-
    penalties_input_problems([attribute(infringement, prohibited_practice), infringement - prohibited_practice], Problems),
    Problems == [wrong_type(profile)].
test(an_unbound_profile_gives_one_answer) :-
    findall(Problems, penalties_input_problems(_, Problems), Answers),
    Answers == [[wrong_type(profile)]].
test(the_input_check_gives_one_answer) :-
    findall(Problems, penalties_input_problems([attribute(offender_category, other_undertaking), attribute(colour, red)], Problems), Answers),
    Answers == [[unknown_key(colour)]].
test(a_leap_day_is_a_real_day) :-
    penalties_date_problems(date(2028, 2, 29), []).
test(a_non_leap_february_twenty_ninth_is_not_a_real_day) :-
    penalties_date_problems(date(2026, 2, 29), [wrong_type(infringement_date)]).
test(february_thirtieth_is_not_a_real_day) :-
    penalties_date_problems(date(2026, 2, 30), [wrong_type(infringement_date)]).
test(an_unbound_date_is_wrong_type) :-
    findall(Problems, penalties_date_problems(_, Problems), Answers),
    Answers == [[wrong_type(infringement_date)]].
test(a_date_with_an_atom_day_is_wrong_type) :-
    penalties_date_problems(date(2026, 7, first), [wrong_type(infringement_date)]).
test(a_date_list_is_wrong_type) :-
    penalties_date_problems([2026, 7, 27], [wrong_type(infringement_date)]).
test(profile_problems_come_before_the_date_problem) :-
    penalties_query_input_problems([attribute(colour, red)], date(2026, 13, 1), Problems),
    Problems == [unknown_key(colour), wrong_type(infringement_date)].
test(the_day_before_is_before) :-
    penalties_date_relation(date(2026, 7, 26), date(2026, 7, 27), before).
test(the_stated_day_is_on_or_after) :-
    penalties_date_relation(date(2026, 7, 27), date(2026, 7, 27), on_or_after).
test(a_later_month_with_a_smaller_day_is_on_or_after) :-
    penalties_date_relation(date(2026, 12, 1), date(2026, 8, 2), on_or_after).
test(the_first_absent_key_is_named) :-
    penalties_first_absent_key([attribute(offender_category, other_undertaking)], [offender_category, infringement], first_absent(infringement)).
test(no_key_is_absent) :-
    penalties_first_absent_key([attribute(offender_category, other_undertaking), attribute(infringement, prohibited_practice)], [offender_category, infringement], none_absent).

test(a_well_formed_profile_is_not_rejected, fail) :-
    penalties_input_problems([attribute(offender_category, other_undertaking)], [_|_]).
test(a_real_day_is_not_rejected, fail) :-
    penalties_date_problems(date(2026, 7, 27), [wrong_type(infringement_date)]).
test(the_stated_day_is_not_before, fail) :-
    penalties_date_relation(date(2026, 7, 27), date(2026, 7, 27), before).
test(a_present_key_is_not_named, fail) :-
    penalties_first_absent_key([attribute(offender_category, other_undertaking)], [offender_category, infringement], first_absent(offender_category)).
