% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_ai_act_provider_side_duties_kernel, [provider_side_duties_input_problems/2, provider_side_duties_calendar_date_t/2, provider_side_duties_leap_year_t/2, provider_side_duties_month_length/3, provider_side_duties_day_key/2, provider_side_duties_date_before_t/3]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(library(reif), [memberd_t/3]).
:- use_module(library(clpz)).

provider_side_duties_input_problems(Profile, Problems) :-
    attribute_list_t(Profile, IsAttributeList),
    profile_problems(IsAttributeList, Profile, Problems).

profile_problems(false, _, [wrong_type(profile)]).
profile_problems(true, Profile, Problems) :-
    Keys = [ai_system, high_risk_ai_system, high_risk_route, actor_role, component_of_a_large_scale_it_system_listed_in_annex_x, placed_on_the_market_or_put_into_service_before_2_august_2027, placed_on_the_market_or_put_into_service_before_the_date_of_application_of_chapter_iii, significant_change_in_design_as_from_the_date_of_application_of_chapter_iii, intended_to_be_used_by_public_authorities, provider_established_in_a_third_country, logs_under_the_providers_control, reasoned_request_from_a_competent_authority, request_from_a_market_surveillance_authority_for_a_copy_of_the_mandate, competent_authority_action_in_relation_to_the_system, system_under_the_operators_responsibility, provider_considers_or_has_reason_to_consider_the_system_not_in_conformity, presents_a_risk_within_the_meaning_of_article_79_1, provider_aware_of_the_risk, representative_considers_or_has_reason_to_consider_the_provider_acting_contrary_to_its_obligations, importer_has_sufficient_reason_to_consider_the_system_not_in_conformity_or_falsified, distributor_considers_or_has_reason_to_consider_the_system_not_in_conformity, distributor_has_made_the_system_available_on_the_market],
    unknown_keys(Profile, Keys, UnknownKeyProblems),
    key_problems(Keys, Profile, UnknownKeyProblems, Problems).

key_type(ai_system, judgement).
key_type(high_risk_ai_system, boolean).
key_type(high_risk_route, high_risk_route).
key_type(actor_role, actor_role).
key_type(component_of_a_large_scale_it_system_listed_in_annex_x, boolean).
key_type(placed_on_the_market_or_put_into_service_before_2_august_2027, boolean).
key_type(placed_on_the_market_or_put_into_service_before_the_date_of_application_of_chapter_iii, boolean).
key_type(significant_change_in_design_as_from_the_date_of_application_of_chapter_iii, judgement).
key_type(intended_to_be_used_by_public_authorities, judgement).
key_type(provider_established_in_a_third_country, boolean).
key_type(logs_under_the_providers_control, boolean).
key_type(reasoned_request_from_a_competent_authority, boolean).
key_type(request_from_a_market_surveillance_authority_for_a_copy_of_the_mandate, boolean).
key_type(competent_authority_action_in_relation_to_the_system, boolean).
key_type(system_under_the_operators_responsibility, boolean).
key_type(provider_considers_or_has_reason_to_consider_the_system_not_in_conformity, judgement).
key_type(presents_a_risk_within_the_meaning_of_article_79_1, judgement).
key_type(provider_aware_of_the_risk, boolean).
key_type(representative_considers_or_has_reason_to_consider_the_provider_acting_contrary_to_its_obligations, judgement).
key_type(importer_has_sufficient_reason_to_consider_the_system_not_in_conformity_or_falsified, judgement).
key_type(distributor_considers_or_has_reason_to_consider_the_system_not_in_conformity, judgement).
key_type(distributor_has_made_the_system_available_on_the_market, boolean).

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
in_type_t(high_risk_route, Value, T) :-
    in_type_t(enum([annex_iii, annex_i]), Value, T).
in_type_t(actor_role, Value, T) :-
    in_type_t(enum([provider, deployer, importer, distributor, product_manufacturer, authorised_representative, affected_person]), Value, T).
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

provider_side_duties_calendar_date_t(Term, false) :-
    var(Term).
provider_side_duties_calendar_date_t(Term, Truth) :-
    nonvar(Term),
    Term = date(YearNumber, MonthNumber, DayNumber),
    integers_t([YearNumber, MonthNumber, DayNumber], AllIntegers),
    integer_date_t(AllIntegers, YearNumber, MonthNumber, DayNumber, Truth).
provider_side_duties_calendar_date_t(Term, false) :-
    nonvar(Term),
    Term \= date(_, _, _).

integers_t([], true).
integers_t([Term|Terms], Truth) :-
    term_kind(Term, Kind),
    integer_kind_t(Kind, Terms, Truth).

integer_kind_t(integer, Terms, Truth) :-
    integers_t(Terms, Truth).
integer_kind_t(variable, _, false).
integer_kind_t(other, _, false).

term_kind(Term, variable) :-
    var(Term).
term_kind(Term, integer) :-
    integer(Term).
term_kind(Term, other) :-
    float(Term).
term_kind(Term, other) :-
    atom(Term).
term_kind(Term, other) :-
    compound(Term).

integer_date_t(false, _, _, _, false).
integer_date_t(true, YearNumber, MonthNumber, DayNumber, Truth) :-
    within_range_t(YearNumber, 1, 9999, YearInRange),
    within_range_t(MonthNumber, 1, 12, MonthInRange),
    truth_and(YearInRange, MonthInRange, YearAndMonthInRange),
    day_in_month_t(YearAndMonthInRange, YearNumber, MonthNumber, DayNumber, Truth).

day_in_month_t(false, _, _, _, false).
day_in_month_t(true, YearNumber, MonthNumber, DayNumber, Truth) :-
    provider_side_duties_month_length(YearNumber, MonthNumber, LastDayNumber),
    within_range_t(DayNumber, 1, LastDayNumber, Truth).

within_range_t(Value, Lowest, Highest, true) :-
    Lowest #=< Value,
    Value #=< Highest.
within_range_t(Value, Lowest, _, false) :-
    Value #< Lowest.
within_range_t(Value, _, Highest, false) :-
    Value #> Highest.

provider_side_duties_leap_year_t(YearNumber, false) :-
    YearNumber mod 4 #\= 0.
provider_side_duties_leap_year_t(YearNumber, true) :-
    YearNumber mod 4 #= 0,
    YearNumber mod 100 #\= 0.
provider_side_duties_leap_year_t(YearNumber, false) :-
    YearNumber mod 100 #= 0,
    YearNumber mod 400 #\= 0.
provider_side_duties_leap_year_t(YearNumber, true) :-
    YearNumber mod 400 #= 0.

provider_side_duties_month_length(YearNumber, 2, LastDayNumber) :-
    provider_side_duties_leap_year_t(YearNumber, IsLeapYear),
    february_length(IsLeapYear, LastDayNumber).
provider_side_duties_month_length(_, MonthNumber, LastDayNumber) :-
    fixed_month_length(MonthNumber, LastDayNumber).

february_length(true, 29).
february_length(false, 28).

fixed_month_length(1, 31).
fixed_month_length(3, 31).
fixed_month_length(4, 30).
fixed_month_length(5, 31).
fixed_month_length(6, 30).
fixed_month_length(7, 31).
fixed_month_length(8, 31).
fixed_month_length(9, 30).
fixed_month_length(10, 31).
fixed_month_length(11, 30).
fixed_month_length(12, 31).

provider_side_duties_day_key(date(YearNumber, MonthNumber, DayNumber), DayKey) :-
    DayKey #= YearNumber * 10000 + MonthNumber * 100 + DayNumber.

provider_side_duties_date_before_t(EarlierDate, LaterDate, true) :-
    provider_side_duties_day_key(EarlierDate, EarlierKey),
    provider_side_duties_day_key(LaterDate, LaterKey),
    EarlierKey #< LaterKey.
provider_side_duties_date_before_t(EarlierDate, LaterDate, false) :-
    provider_side_duties_day_key(EarlierDate, EarlierKey),
    provider_side_duties_day_key(LaterDate, LaterKey),
    EarlierKey #>= LaterKey.

test(a_well_formed_profile_has_no_problem) :-
    provider_side_duties_input_problems([attribute(ai_system, unsure), attribute(actor_role, provider)], []).
test(a_wrong_value_and_an_unknown_key) :-
    provider_side_duties_input_problems([attribute(ai_system, maybe), attribute(colour, blue)], [wrong_type(ai_system), unknown_key(colour)]).
test(a_duplicate_key_is_never_also_wrong_type) :-
    provider_side_duties_input_problems([attribute(high_risk_ai_system, unsure), attribute(high_risk_ai_system, true)], [duplicate_key(high_risk_ai_system)]).
test(a_crisp_key_is_not_unsure) :-
    provider_side_duties_input_problems([attribute(high_risk_ai_system, unsure)], [wrong_type(high_risk_ai_system)]).
test(a_non_list_profile) :-
    provider_side_duties_input_problems(profile, [wrong_type(profile)]).
test(a_partial_list_profile) :-
    provider_side_duties_input_problems([attribute(ai_system, true)|_], [wrong_type(profile)]).
test(an_unbound_value_is_wrong_type) :-
    provider_side_duties_input_problems([attribute(actor_role, _)], [wrong_type(actor_role)]).
test(an_attested_value_is_wrong_type) :-
    provider_side_duties_input_problems([attribute(ai_system, attested(true, attestation(_, _, _, _)))], [wrong_type(ai_system)]).
test(the_input_check_has_one_answer) :-
    findall(Problems, provider_side_duties_input_problems([attribute(ai_system, true)], Problems), AllProblems),
    AllProblems == [[]].
test(leap_years) :-
    provider_side_duties_leap_year_t(2028, true),
    provider_side_duties_leap_year_t(2000, true),
    provider_side_duties_leap_year_t(10000, true).
test(common_years) :-
    provider_side_duties_leap_year_t(2038, false),
    provider_side_duties_leap_year_t(2100, false).
test(february_in_a_common_year) :-
    provider_side_duties_month_length(2038, 2, 28).
test(a_real_leap_day) :-
    provider_side_duties_calendar_date_t(date(2028, 2, 29), true).
test(an_impossible_leap_day) :-
    provider_side_duties_calendar_date_t(date(2026, 2, 29), false).
test(a_year_above_the_contract) :-
    provider_side_duties_calendar_date_t(date(10000, 1, 1), false).
test(an_unbound_day) :-
    provider_side_duties_calendar_date_t(date(2026, 1, _), false).
test(an_atom_is_not_a_date) :-
    provider_side_duties_calendar_date_t(today, false).
test(an_unbound_date) :-
    provider_side_duties_calendar_date_t(_, false).
test(the_day_before_is_before) :-
    provider_side_duties_date_before_t(date(2027, 12, 1), date(2027, 12, 2), true).
test(the_day_itself_is_not_before) :-
    provider_side_duties_date_before_t(date(2027, 12, 2), date(2027, 12, 2), false).

test(the_day_itself_is_never_true, fail) :-
    provider_side_duties_date_before_t(date(2027, 12, 2), date(2027, 12, 2), true).
