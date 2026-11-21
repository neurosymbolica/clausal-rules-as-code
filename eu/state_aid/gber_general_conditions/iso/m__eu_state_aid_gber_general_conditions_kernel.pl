% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_state_aid_gber_general_conditions_kernel, [gber_general_conditions_input_problems/2, gber_general_conditions_query_problems/3, gber_general_conditions_key_order/1, argument_problems/2, date_earlier_t/3, conjunction_state/3, conjunctions_met_t/3, condition_state/4, way_state/3, way_possible_t/3, pick_missing_key/3, pairs_relied_on/3]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(library(error), [must_be/2]).
:- use_module(library(reif), [memberd_t/3]).
:- use_module(library(clpz)).
:- use_module(formalize_lib, [profile_get/3]).
:- use_module(deadline_lib, [month_last_day/3]).

gber_general_conditions_input_problems(Profile, Problems) :-
    attribute_list_t(Profile, IsAttributeList),
    profile_problems(IsAttributeList, Profile, Problems).

profile_problems(false, _, [wrong_type(profile)]).
profile_problems(true, Profile, Problems) :-
    Keys = [scheme_excluded_by_article_1_2_a_or_b, export_or_domestic_goods_aid, aided_sector, sector_exception_applies, price_or_pass_on_condition, article_13_regional_aid_category, also_active_in_excluded_sector, separation_of_activities_or_costs_ensured, recovery_order_exclusion_applies, undertaking_in_difficulty, difficulty_exception_applies, difficulty_2020_2021_derogation, non_severable_violation_of_union_law, article_4_category, research_project_doubled, aid_form, form_transparency_condition_met, category_transparency_condition_met, transparent_under_article_5_1, article_6_5_category_conditions_met, tax_measure_conditions_met, application_contains_required_information, aid_type, size_class, large_enterprise_verification_done, identifiable_eligible_costs],
    unknown_keys(Profile, Keys, UnknownKeyProblems),
    key_problems(Keys, Profile, UnknownKeyProblems, Problems).

key_type(scheme_excluded_by_article_1_2_a_or_b, judgement).
key_type(export_or_domestic_goods_aid, judgement).
key_type(aided_sector, sector).
key_type(sector_exception_applies, boolean).
key_type(price_or_pass_on_condition, boolean).
key_type(article_13_regional_aid_category, boolean).
key_type(also_active_in_excluded_sector, boolean).
key_type(separation_of_activities_or_costs_ensured, judgement).
key_type(recovery_order_exclusion_applies, boolean).
key_type(undertaking_in_difficulty, judgement).
key_type(difficulty_exception_applies, boolean).
key_type(difficulty_2020_2021_derogation, boolean).
key_type(non_severable_violation_of_union_law, judgement).
key_type(article_4_category, category).
key_type(research_project_doubled, boolean).
key_type(aid_form, form).
key_type(form_transparency_condition_met, boolean).
key_type(category_transparency_condition_met, boolean).
key_type(transparent_under_article_5_1, judgement).
key_type(article_6_5_category_conditions_met, boolean).
key_type(tax_measure_conditions_met, boolean).
key_type(application_contains_required_information, boolean).
key_type(aid_type, aid_type).
key_type(size_class, size).
key_type(large_enterprise_verification_done, boolean).
key_type(identifiable_eligible_costs, boolean).

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
in_type_t(sector, Value, T) :-
    in_type_t(enum([other_sector, fishery_and_aquaculture, primary_agricultural_production, processing_and_marketing_of_agricultural_products, closure_of_uncompetitive_coal_mines]), Value, T).
in_type_t(category, Value, T) :-
    in_type_t(enum([sme_investment, sme_consultancy, sme_fair_participation, fundamental_research, industrial_research, experimental_development, feasibility_study, sme_innovation, process_and_organisational_innovation, training, environmental_investment, other_category]), Value, T).
in_type_t(form, Value, T) :-
    in_type_t(enum([grant, interest_rate_subsidy, loan, guarantee, tax_advantage, repayable_advance, sale_or_lease_of_tangible_assets, other_form]), Value, T).
in_type_t(aid_type, Value, T) :-
    in_type_t(enum([scheme, individual_aid_under_scheme, ad_hoc_aid]), Value, T).
in_type_t(size, Value, T) :-
    in_type_t(enum([micro_enterprise, small_enterprise, medium_sized_enterprise, large_enterprise, not_sme_public_control]), Value, T).
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

gber_general_conditions_query_problems(Profile, NamedArguments, Problems) :-
    gber_general_conditions_input_problems(Profile, ProfileProblems),
    argument_problems(NamedArguments, ArgumentProblems),
    append(ProfileProblems, ArgumentProblems, Problems).

argument_problems([], []).
argument_problems([Name - Value|NamedArguments], Problems) :-
    argument_type(Name, Type),
    argument_in_type_t(Type, Value, InType),
    argument_problems(NamedArguments, LaterProblems),
    add_argument_problem(InType, Name, LaterProblems, Problems).

add_argument_problem(true, _, Problems, Problems).
add_argument_problem(false, Name, Problems, [wrong_type(Name)|Problems]).

argument_type(project_aid_cents, non_negative_integer).
argument_type(application_date, application_date).
argument_type(work_start_date, calendar_date).
argument_type(eligible_costs_cents, non_negative_integer).
argument_type(same_costs_aid_cents, non_negative_integer).
argument_type(same_costs_de_minimis_cents, non_negative_integer).
argument_type(max_intensity_basis_points, non_negative_integer).

argument_in_type_t(non_negative_integer, Value, Truth) :-
    non_negative_integer_t(Value, Truth).
argument_in_type_t(application_date, Value, Truth) :-
    application_date_t(Value, Truth).
argument_in_type_t(calendar_date, Value, Truth) :-
    real_calendar_date_t(Value, Truth).

integer_t(Value, Truth) :-
    catch(integer_truth(Value, Truth), error(_, _), Truth = false).

integer_truth(Value, true) :-
    must_be(integer, Value).

non_negative_integer_t(Value, Truth) :-
    integer_t(Value, IsInteger),
    non_negative_truth(IsInteger, Value, Truth).

non_negative_truth(false, _, false).
non_negative_truth(true, Value, true) :-
    Value #>= 0.
non_negative_truth(true, Value, false) :-
    Value #< 0.

in_range_t(Value, Low, High, true) :-
    Value #>= Low,
    Value #=< High.
in_range_t(Value, Low, _, false) :-
    Value #< Low.
in_range_t(Value, _, High, false) :-
    Value #> High.

application_date_t(Term, false) :-
    var(Term).
application_date_t(Term, true) :-
    Term == no_application.
application_date_t(Term, Truth) :-
    nonvar(Term),
    Term \== no_application,
    real_calendar_date_t(Term, Truth).

real_calendar_date_t(Term, false) :-
    var(Term).
real_calendar_date_t(Term, Truth) :-
    nonvar(Term),
    Term = date(Year, Month, Day),
    integer_t(Year, YearIsInteger),
    integer_t(Month, MonthIsInteger),
    integer_t(Day, DayIsInteger),
    truth_and(YearIsInteger, MonthIsInteger, YearAndMonthAreIntegers),
    truth_and(YearAndMonthAreIntegers, DayIsInteger, AllAreIntegers),
    date_parts_truth(AllAreIntegers, Year, Month, Day, Truth).
real_calendar_date_t(Term, false) :-
    nonvar(Term),
    Term \= date(_, _, _).

date_parts_truth(false, _, _, _, false).
date_parts_truth(true, Year, Month, Day, Truth) :-
    in_range_t(Year, 1, 9999, YearInRange),
    in_range_t(Month, 1, 12, MonthInRange),
    truth_and(YearInRange, MonthInRange, YearAndMonthInRange),
    day_in_month_truth(YearAndMonthInRange, Year, Month, Day, Truth).

day_in_month_truth(false, _, _, _, false).
day_in_month_truth(true, Year, Month, Day, Truth) :-
    month_last_day(Year, Month, LastDay),
    in_range_t(Day, 1, LastDay, Truth).

date_earlier_t(date(Year, Month, Day), date(OtherYear, OtherMonth, OtherDay), Truth) :-
    compare(YearOrder, Year, OtherYear),
    compare(MonthOrder, Month, OtherMonth),
    compare(DayOrder, Day, OtherDay),
    lexicographic_earlier(YearOrder, MonthOrder, DayOrder, Truth).

lexicographic_earlier(<, _, _, true).
lexicographic_earlier(>, _, _, false).
lexicographic_earlier(=, <, _, true).
lexicographic_earlier(=, >, _, false).
lexicographic_earlier(=, =, <, true).
lexicographic_earlier(=, =, =, false).
lexicographic_earlier(=, =, >, false).

gber_general_conditions_key_order([scheme_excluded_by_article_1_2_a_or_b, export_or_domestic_goods_aid, aided_sector, sector_exception_applies, price_or_pass_on_condition, article_13_regional_aid_category, also_active_in_excluded_sector, separation_of_activities_or_costs_ensured, recovery_order_exclusion_applies, undertaking_in_difficulty, difficulty_exception_applies, difficulty_2020_2021_derogation, non_severable_violation_of_union_law, article_4_category, research_project_doubled, aid_form, form_transparency_condition_met, category_transparency_condition_met, transparent_under_article_5_1, article_6_5_category_conditions_met, tax_measure_conditions_met, application_contains_required_information, aid_type, size_class, large_enterprise_verification_done, identifiable_eligible_costs]).

keys_in_order([], _, []).
keys_in_order([Key|Keys], Selected, Ordered) :-
    memberd_t(Key, Selected, IsSelected),
    keep_key(IsSelected, Key, LaterOrdered, Ordered),
    keys_in_order(Keys, Selected, LaterOrdered).

keep_key(true, Key, Keys, [Key|Keys]).
keep_key(false, _, Keys, Keys).

key_state(Profile, key_allows(Key, Allowed), State) :-
    findall(Value, profile_get(Profile, Key, Value), Values),
    values_state(Values, Allowed, State).

values_state([], _, absent).
values_state([Value|_], Allowed, State) :-
    memberd_t(Value, Allowed, IsAllowed),
    present_state(IsAllowed, Value, State).

present_state(true, _, allowed).
present_state(false, Value, unsure) :-
    Value == unsure.
present_state(false, Value, refused) :-
    Value \== unsure.

conjunction_state(Profile, Conjunction, State) :-
    maplist(key_state(Profile), Conjunction, KeyStates),
    memberd_t(refused, KeyStates, HasRefused),
    conjunction_summary(HasRefused, KeyStates, Conjunction, State).

conjunction_summary(true, _, _, impossible).
conjunction_summary(false, KeyStates, Conjunction, possible(Cost, UnsureCount, AbsentKeys)) :-
    tally_key_states(KeyStates, Conjunction, Cost, UnsureCount, UnorderedKeys),
    gber_general_conditions_key_order(Order),
    keys_in_order(Order, UnorderedKeys, AbsentKeys).

tally_key_states([], [], 0, 0, []).
tally_key_states([absent|States], [key_allows(Key, _)|Elements], Cost, UnsureCount, [Key|Keys]) :-
    tally_key_states(States, Elements, LaterCost, UnsureCount, Keys),
    Cost #= LaterCost + 1.
tally_key_states([unsure|States], [_|Elements], Cost, UnsureCount, Keys) :-
    tally_key_states(States, Elements, Cost, LaterUnsureCount, Keys),
    UnsureCount #= LaterUnsureCount + 1.
tally_key_states([allowed|States], [_|Elements], Cost, UnsureCount, Keys) :-
    tally_key_states(States, Elements, Cost, UnsureCount, Keys).
tally_key_states([refused|States], [_|Elements], Cost, UnsureCount, Keys) :-
    tally_key_states(States, Elements, Cost, UnsureCount, Keys).

state_met_t(impossible, false).
state_met_t(possible(Cost, _, _), false) :-
    Cost #> 0.
state_met_t(possible(Cost, UnsureCount, _), true) :-
    Cost #= 0,
    UnsureCount #= 0.
state_met_t(possible(Cost, UnsureCount, _), false) :-
    Cost #= 0,
    UnsureCount #> 0.

conjunctions_met_t(_, [], false).
conjunctions_met_t(Profile, [Conjunction|Conjunctions], Truth) :-
    conjunction_state(Profile, Conjunction, State),
    state_met_t(State, IsMet),
    later_conjunctions_met(IsMet, Profile, Conjunctions, Truth).

later_conjunctions_met(true, _, _, true).
later_conjunctions_met(false, Profile, Conjunctions, Truth) :-
    conjunctions_met_t(Profile, Conjunctions, Truth).

condition_state(Profile, HoldsConjunctions, FailsConjunctions, State) :-
    conjunctions_met_t(Profile, HoldsConjunctions, HoldsMet),
    conjunctions_met_t(Profile, FailsConjunctions, FailsMet),
    condition_from_truths(HoldsMet, FailsMet, State).

condition_from_truths(true, _, holds).
condition_from_truths(false, true, fails).
condition_from_truths(false, false, open).

rank_lower_t(Cost, _, OtherCost, _, true) :-
    Cost #< OtherCost.
rank_lower_t(Cost, _, OtherCost, _, false) :-
    Cost #> OtherCost.
rank_lower_t(Cost, UnsureCount, OtherCost, OtherUnsureCount, true) :-
    Cost #= OtherCost,
    UnsureCount #< OtherUnsureCount.
rank_lower_t(Cost, UnsureCount, OtherCost, OtherUnsureCount, false) :-
    Cost #= OtherCost,
    UnsureCount #>= OtherUnsureCount.

best_state([], Best, Best).
best_state([State|States], Current, Best) :-
    better_state(State, Current, Next),
    best_state(States, Next, Best).

better_state(impossible, Current, Current).
better_state(possible(Cost, UnsureCount, Keys), impossible, possible(Cost, UnsureCount, Keys)).
better_state(possible(Cost, UnsureCount, Keys), possible(OtherCost, OtherUnsureCount, OtherKeys), Next) :-
    rank_lower_t(Cost, UnsureCount, OtherCost, OtherUnsureCount, IsLower),
    choose_state(IsLower, possible(Cost, UnsureCount, Keys), possible(OtherCost, OtherUnsureCount, OtherKeys), Next).

choose_state(true, New, _, New).
choose_state(false, _, Old, Old).

way_state(Profile, conjunction_way(Conjunctions), State) :-
    maplist(conjunction_state(Profile), Conjunctions, States),
    best_state(States, impossible, State).
way_state(Profile, all_fail_way(FailsLists), State) :-
    maplist(conjunction_way_of, FailsLists, Parts),
    way_state(Profile, sum_way(Parts), State).
way_state(Profile, sum_way(Parts), State) :-
    maplist(way_state(Profile), Parts, States),
    sum_states(States, possible(0, 0, []), State).

conjunction_way_of(Conjunctions, conjunction_way(Conjunctions)).

sum_states([], impossible, impossible).
sum_states([], possible(Cost, UnsureCount, Keys), possible(Cost, UnsureCount, OrderedKeys)) :-
    gber_general_conditions_key_order(Order),
    keys_in_order(Order, Keys, OrderedKeys).
sum_states([State|States], Accumulated, Sum) :-
    add_state(State, Accumulated, Next),
    sum_states(States, Next, Sum).

add_state(impossible, _, impossible).
add_state(possible(_, _, _), impossible, impossible).
add_state(possible(Cost, UnsureCount, Keys), possible(AccumulatedCost, AccumulatedUnsureCount, AccumulatedKeys), possible(TotalCost, TotalUnsureCount, TotalKeys)) :-
    TotalCost #= AccumulatedCost + Cost,
    TotalUnsureCount #= AccumulatedUnsureCount + UnsureCount,
    append(AccumulatedKeys, Keys, TotalKeys).

way_possible_t(Profile, Way, Truth) :-
    way_state(Profile, Way, State),
    state_possible_t(State, Truth).

state_possible_t(impossible, false).
state_possible_t(possible(_, _, _), true).

pick_missing_key(Profile, Ways, Result) :-
    maplist(way_state(Profile), Ways, States),
    maplist(pickable_state, States, PickableStates),
    best_state(PickableStates, impossible, Best),
    picked_key(Best, Result).

pickable_state(impossible, impossible).
pickable_state(possible(Cost, UnsureCount, Keys), possible(Cost, UnsureCount, Keys)) :-
    Cost #>= 1.
pickable_state(possible(Cost, _, _), impossible) :-
    Cost #= 0.

picked_key(impossible, no_key).
picked_key(possible(_, _, [Key|_]), key(Key)).

pairs_relied_on(Profile, Keys, Pairs) :-
    gber_general_conditions_key_order(Order),
    keys_in_order(Order, Keys, OrderedKeys),
    key_pairs(OrderedKeys, Profile, Pairs).

key_pairs([], _, []).
key_pairs([Key|Keys], Profile, Pairs) :-
    findall(Value, profile_get(Profile, Key, Value), Values),
    pair_for(Values, Key, LaterPairs, Pairs),
    key_pairs(Keys, Profile, LaterPairs).

pair_for([], _, Pairs, Pairs).
pair_for([Value|_], Key, Pairs, [Key - Value|Pairs]).

test(an_empty_profile_has_no_problem) :-
    gber_general_conditions_input_problems([], []).
test(an_absent_key_costs_one) :-
    conjunction_state([], [key_allows(aid_form, [grant])], possible(1, 0, [aid_form])).
test(an_unsure_judgement_counts_as_unsure) :-
    conjunction_state([attribute(undertaking_in_difficulty, unsure)], [key_allows(undertaking_in_difficulty, [true])], possible(0, 1, [])).
test(a_refused_value_makes_the_conjunction_impossible) :-
    conjunction_state([attribute(aid_form, loan)], [key_allows(aid_form, [grant])], impossible).
test(the_empty_conjunction_is_met) :-
    conjunctions_met_t([], [[]], true).
test(a_condition_holds) :-
    condition_state([attribute(recovery_order_exclusion_applies, true)], [[key_allows(recovery_order_exclusion_applies, [true])]], [[key_allows(recovery_order_exclusion_applies, [false])]], holds).
test(an_absent_condition_is_open) :-
    condition_state([], [[key_allows(recovery_order_exclusion_applies, [true])]], [[key_allows(recovery_order_exclusion_applies, [false])]], open).
test(the_same_day_is_not_earlier) :-
    date_earlier_t(date(2024, 2, 1), date(2024, 2, 1), false).
test(the_day_before_is_earlier) :-
    date_earlier_t(date(2024, 1, 31), date(2024, 2, 1), true).
test(a_leap_day_is_a_real_date) :-
    argument_problems([work_start_date - date(2024, 2, 29)], []).
test(a_non_leap_day_is_not_a_real_date) :-
    argument_problems([work_start_date - date(2023, 2, 29)], [wrong_type(work_start_date)]).
test(an_unbound_amount_is_not_an_amount) :-
    argument_problems([project_aid_cents - _], [wrong_type(project_aid_cents)]).
test(no_application_is_an_application_date) :-
    argument_problems([application_date - no_application], []).
test(a_negative_amount_is_refused) :-
    argument_problems([eligible_costs_cents - -1], [wrong_type(eligible_costs_cents)]).
test(the_pick_names_the_first_absent_key) :-
    pick_missing_key([], [conjunction_way([[key_allows(scheme_excluded_by_article_1_2_a_or_b, [true])]])], key(scheme_excluded_by_article_1_2_a_or_b)).
test(a_cost_zero_way_is_never_picked) :-
    pick_missing_key([attribute(transparent_under_article_5_1, unsure)], [conjunction_way([[key_allows(transparent_under_article_5_1, [true])]])], no_key).
test(an_all_fail_way_sums_its_parts) :-
    way_state([], all_fail_way([[[key_allows(aid_form, [other_form])]], [[key_allows(category_transparency_condition_met, [false])]]]), possible(2, 0, [aid_form, category_transparency_condition_met])).
test(pairs_come_in_key_order) :-
    pairs_relied_on([attribute(difficulty_exception_applies, false), attribute(undertaking_in_difficulty, unsure)], [undertaking_in_difficulty, difficulty_exception_applies, difficulty_2020_2021_derogation], [undertaking_in_difficulty - unsure, difficulty_exception_applies - false]).

test(the_same_day_is_never_earlier, fail) :-
    date_earlier_t(date(2024, 2, 1), date(2024, 2, 1), true).
