% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_ai_act_high_risk_requirements_kernel, [high_risk_requirements_input_problems/2, high_risk_requirements_settle/6, high_risk_requirements_valid_date_t/2, high_risk_requirements_valid_date/1, high_risk_requirements_day_before_t/3, high_risk_requirements_day_before/2]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(library(pairs), [pairs_values/2, group_pairs_by_key/2]).
:- use_module(library(clpz)).
:- use_module(library(reif), [memberd_t/3]).
:- use_module(formalize_lib, [profile_get/3]).
:- use_module(deadline_lib, [month_last_day/3]).

high_risk_requirements_input_problems(Profile, Problems) :-
    attribute_list_t(Profile, IsAttributeList),
    profile_problems(IsAttributeList, Profile, Problems).

profile_problems(false, _, [wrong_type(profile)]).
profile_problems(true, Profile, Problems) :-
    Keys = [system_is_a_high_risk_ai_system_listed_in_annex_iii, system_is_a_high_risk_ai_system_under_article_6_1_and_annex_i, system_listed_under_point_1_a_of_annex_iii, used_for_the_purposes_of_law_enforcement_migration_border_control_or_asylum, union_or_national_law_considers_the_separate_verification_disproportionate, uses_techniques_involving_the_training_of_ai_models_with_data, provider_is_an_sme_including_a_start_up_or_an_smc, component_of_an_annex_x_large_scale_it_system_placed_on_the_market_or_put_into_service_before_2_august_2027, placed_on_the_market_or_put_into_service_before_the_chapter_iii_date, significant_changes_in_design_as_from_the_chapter_iii_date, intended_to_be_used_by_public_authorities, system_is_a_component_of_products, pre_determined_changes_to_the_system_and_its_performance, related_to_a_product_covered_by_annex_i_section_a],
    unknown_keys(Profile, Keys, UnknownKeyProblems),
    key_problems(Keys, Profile, UnknownKeyProblems, Problems).

key_type(system_is_a_high_risk_ai_system_listed_in_annex_iii, boolean).
key_type(system_is_a_high_risk_ai_system_under_article_6_1_and_annex_i, boolean).
key_type(system_listed_under_point_1_a_of_annex_iii, boolean).
key_type(used_for_the_purposes_of_law_enforcement_migration_border_control_or_asylum, boolean).
key_type(union_or_national_law_considers_the_separate_verification_disproportionate, boolean).
key_type(uses_techniques_involving_the_training_of_ai_models_with_data, boolean).
key_type(provider_is_an_sme_including_a_start_up_or_an_smc, boolean).
key_type(component_of_an_annex_x_large_scale_it_system_placed_on_the_market_or_put_into_service_before_2_august_2027, boolean).
key_type(placed_on_the_market_or_put_into_service_before_the_chapter_iii_date, boolean).
key_type(significant_changes_in_design_as_from_the_chapter_iii_date, judgement).
key_type(intended_to_be_used_by_public_authorities, judgement).
key_type(system_is_a_component_of_products, boolean).
key_type(pre_determined_changes_to_the_system_and_its_performance, boolean).
key_type(related_to_a_product_covered_by_annex_i_section_a, boolean).

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

high_risk_requirements_settle(QueryKeys, Profile, Ladder, Referral, Result, Citations) :-
    maplist(key_entry(Profile), QueryKeys, Entries),
    free_entries(Entries, 0, FreeEntries),
    length(FreeEntries, FreeCount),
    findall(Values - Answer, completion_answer(Entries, FreeCount, Ladder, Values, Answer), Rows),
    pairs_values(Rows, Answers),
    sort(Answers, DistinctAnswers),
    settled_status(DistinctAnswers, FreeEntries, Rows, QueryKeys, Profile, Referral, Result, Citations).

key_entry(Profile, Key, entry(Key, State)) :-
    key_occurrences(Profile, Key, Occurrences),
    state_from_occurrences(Occurrences, Profile, Key, State).

state_from_occurrences(none, _, _, absent).
state_from_occurrences(one, Profile, Key, State) :-
    profile_get(Profile, Key, Value),
    key_type(Key, Type),
    value_state(Type, Value, State).

value_state(boolean, Value, fixed(Value)).
value_state(judgement, Value, State) :-
    memberd_t(Value, [unsure], IsUnsure),
    judgement_state(IsUnsure, Value, State).

judgement_state(true, _, unsure).
judgement_state(false, Value, fixed(Value)).

free_entries([], _, []).
free_entries([entry(_, fixed(_))|Entries], Index, FreeEntries) :-
    free_entries(Entries, Index, FreeEntries).
free_entries([entry(Key, absent)|Entries], Index, [free(Key, absent, Index)|FreeEntries]) :-
    NextIndex #= Index + 1,
    free_entries(Entries, NextIndex, FreeEntries).
free_entries([entry(Key, unsure)|Entries], Index, [free(Key, unsure, Index)|FreeEntries]) :-
    NextIndex #= Index + 1,
    free_entries(Entries, NextIndex, FreeEntries).

completion_answer(Entries, FreeCount, Ladder, Values, answer(Result, SortedCitations)) :-
    length(Values, FreeCount),
    maplist(boolean_value, Values),
    completion(Entries, Values, CompleteProfile),
    call(Ladder, CompleteProfile, Result, Citations),
    sort(Citations, SortedCitations).

boolean_value(true).
boolean_value(false).

completion([], [], []).
completion([entry(Key, fixed(Value))|Entries], Values, [attribute(Key, Value)|Attributes]) :-
    completion(Entries, Values, Attributes).
completion([entry(Key, absent)|Entries], [Value|Values], [attribute(Key, Value)|Attributes]) :-
    completion(Entries, Values, Attributes).
completion([entry(Key, unsure)|Entries], [Value|Values], [attribute(Key, Value)|Attributes]) :-
    completion(Entries, Values, Attributes).

settled_status([answer(Result, Citations)], _, _, _, _, _, Result, Citations).
settled_status([_, _|_], FreeEntries, Rows, QueryKeys, Profile, Referral, Result, Citations) :-
    maplist(free_information(Rows), FreeEntries, Informations),
    open_status(Informations, QueryKeys, Profile, Referral, Result, Citations).

free_information(Rows, free(Key, Kind, Index), information(Key, Kind, Index, Matters, Witnesses)) :-
    witnesses(Index, Rows, Witnesses),
    matters_t(Witnesses, Matters).

witnesses(Index, Rows, Witnesses) :-
    findall(OtherValues - (Value - Answer), (member(Values - Answer, Rows), remove_at(Index, Values, Value, OtherValues)), Keyed),
    keysort(Keyed, Sorted),
    group_pairs_by_key(Sorted, Groups),
    findall(WitnessValues, (member(WitnessValues - Group, Groups), member(true - AnswerTrue, Group), member(false - AnswerFalse, Group), AnswerTrue \== AnswerFalse), Found),
    sort(Found, Witnesses).

remove_at(0, [Value|Values], Value, Values).
remove_at(Index, [Item|Items], Value, [Item|Rest]) :-
    Index #> 0,
    PreviousIndex #= Index - 1,
    remove_at(PreviousIndex, Items, Value, Rest).

matters_t([], false).
matters_t([_|_], true).

open_status(Informations, QueryKeys, Profile, Referral, Result, Citations) :-
    absent_informations(Informations, AbsentInformations),
    maplist(missing_candidate(AbsentInformations), AbsentInformations, Candidates),
    first_missing(Candidates, Found),
    missing_status(Found, Informations, AbsentInformations, QueryKeys, Profile, Referral, Result, Citations).

missing_status(found(Key), _, _, _, _, _, indeterminate([Key]), []).
missing_status(none, Informations, AbsentInformations, QueryKeys, Profile, Referral, Result, Citations) :-
    first_mattering(AbsentInformations, Found),
    fallback_status(Found, Informations, QueryKeys, Profile, Referral, Result, Citations).

fallback_status(found(Key), _, _, _, _, indeterminate([Key]), []).
fallback_status(none, Informations, QueryKeys, Profile, Referral, needs_legal_review(open_textured(Judgement, cite(CitationKey)), [inputs_relied_on(Pairs)]), []) :-
    unsure_informations(Informations, UnsureInformations),
    first_mattering(UnsureInformations, found(Judgement)),
    call(Referral, Judgement, CitationKey),
    judgement_pairs(QueryKeys, Profile, Pairs).

absent_informations([], []).
absent_informations([information(Key, absent, Index, Matters, Witnesses)|Informations], [information(Key, absent, Index, Matters, Witnesses)|AbsentInformations]) :-
    absent_informations(Informations, AbsentInformations).
absent_informations([information(_, unsure, _, _, _)|Informations], AbsentInformations) :-
    absent_informations(Informations, AbsentInformations).

unsure_informations([], []).
unsure_informations([information(Key, unsure, Index, Matters, Witnesses)|Informations], [information(Key, unsure, Index, Matters, Witnesses)|UnsureInformations]) :-
    unsure_informations(Informations, UnsureInformations).
unsure_informations([information(_, absent, _, _, _)|Informations], UnsureInformations) :-
    unsure_informations(Informations, UnsureInformations).

missing_candidate(AbsentInformations, information(Key, Kind, Index, Matters, Witnesses), candidate(Key, Matters, Behind)) :-
    behind_any_t(information(Key, Kind, Index, Matters, Witnesses), AbsentInformations, Behind).

first_missing([], none).
first_missing([candidate(Key, true, false)|_], found(Key)).
first_missing([candidate(_, true, true)|Candidates], Found) :-
    first_missing(Candidates, Found).
first_missing([candidate(_, false, _)|Candidates], Found) :-
    first_missing(Candidates, Found).

first_mattering([], none).
first_mattering([information(Key, _, _, true, _)|_], found(Key)).
first_mattering([information(_, _, _, false, _)|Informations], Found) :-
    first_mattering(Informations, Found).

behind_any_t(_, [], false).
behind_any_t(Information, [Other|Others], Truth) :-
    pair_behind_t(Information, Other, PairTruth),
    behind_any_t(Information, Others, RestTruth),
    truth_or(PairTruth, RestTruth, Truth).

pair_behind_t(information(_, _, Index, _, _), information(_, _, OtherIndex, _, _), false) :-
    Index =:= OtherIndex.
pair_behind_t(information(_, _, Index, _, Witnesses), information(_, _, OtherIndex, _, OtherWitnesses), Truth) :-
    Index =\= OtherIndex,
    other_position(Index, OtherIndex, OtherPosition),
    other_position(OtherIndex, Index, OwnPosition),
    values_at(OtherPosition, Witnesses, OtherValues),
    values_at(OwnPosition, OtherWitnesses, OwnValues),
    sort(OtherValues, OtherValueSet),
    sort(OwnValues, OwnValueSet),
    one_value_t(OtherValueSet, OneValue),
    both_values_t(OwnValueSet, BothValues),
    truth_and(OneValue, BothValues, Truth).

other_position(Removed, Index, Index) :-
    Index #< Removed.
other_position(Removed, Index, Position) :-
    Index #> Removed,
    Position #= Index - 1.

values_at(Position, Witnesses, Values) :-
    findall(Value, (member(Witness, Witnesses), nth0(Position, Witness, Value)), Values).

one_value_t([], false).
one_value_t([_], true).
one_value_t([_, _|_], false).

both_values_t([], false).
both_values_t([_], false).
both_values_t([false, true], true).

judgement_pairs([], _, []).
judgement_pairs([Key|Keys], Profile, Pairs) :-
    key_type(Key, Type),
    key_occurrences(Profile, Key, Occurrences),
    judgement_pairs(Keys, Profile, LaterPairs),
    judgement_pair(Type, Occurrences, Profile, Key, LaterPairs, Pairs).

judgement_pair(boolean, _, _, _, Pairs, Pairs).
judgement_pair(judgement, none, _, _, Pairs, Pairs).
judgement_pair(judgement, one, Profile, Key, Pairs, [Key - Value|Pairs]) :-
    profile_get(Profile, Key, Value).

high_risk_requirements_valid_date_t(Term, false) :-
    var(Term).
high_risk_requirements_valid_date_t(Term, Truth) :-
    nonvar(Term),
    functor(Term, Name, Arity),
    date_shape_t(Name, Arity, Term, Truth).

high_risk_requirements_valid_date(Term) :-
    high_risk_requirements_valid_date_t(Term, true).

date_shape_t(date, 3, date(Year, Month, Day), Truth) :-
    integers_t([Year, Month, Day], AreIntegers),
    date_range_t(AreIntegers, Year, Month, Day, Truth).
date_shape_t(Name, Arity, _, false) :-
    dif(Name - Arity, date - 3).

integers_t([], true).
integers_t([Item|Items], Truth) :-
    integer_t(Item, ItemTruth),
    integers_t(Items, ItemsTruth),
    truth_and(ItemTruth, ItemsTruth, Truth).

integer_t(Item, true) :-
    integer(Item).
integer_t(Item, false) :-
    var(Item).
integer_t(Item, false) :-
    float(Item).
integer_t(Item, false) :-
    atom(Item).
integer_t(Item, false) :-
    compound(Item).

date_range_t(false, _, _, _, false).
date_range_t(true, Year, Month, Day, Truth) :-
    InRange #<==> Year #>= 1 #/\ Year #=< 9999 #/\ Month #>= 1 #/\ Month #=< 12,
    month_in_range(InRange, Year, Month, Day, Truth).

month_in_range(0, _, _, _, false).
month_in_range(1, Year, Month, Day, Truth) :-
    month_last_day(Year, Month, LastDay),
    DayInRange #<==> Day #>= 1 #/\ Day #=< LastDay,
    bit_truth(DayInRange, Truth).

bit_truth(1, true).
bit_truth(0, false).

high_risk_requirements_day_before_t(date(EarlierYear, EarlierMonth, EarlierDay), date(LaterYear, LaterMonth, LaterDay), Truth) :-
    Before #<==> EarlierYear #< LaterYear #\/ EarlierYear #= LaterYear #/\ (EarlierMonth #< LaterMonth #\/ EarlierMonth #= LaterMonth #/\ EarlierDay #< LaterDay),
    bit_truth(Before, Truth).

high_risk_requirements_day_before(Earlier, Later) :-
    high_risk_requirements_day_before_t(Earlier, Later, true).

annex_iii_ladder(Profile, Result, [cite(eu_reg_2024_1689_art_8_1)]) :-
    profile_get(Profile, system_is_a_high_risk_ai_system_listed_in_annex_iii, Value),
    annex_iii_result(Value, Result).

annex_iii_result(true, requirement_applies).
annex_iii_result(false, not_a_high_risk_ai_system).

changes_ladder(Profile, Result, []) :-
    profile_get(Profile, significant_changes_in_design_as_from_the_chapter_iii_date, Changes),
    profile_get(Profile, intended_to_be_used_by_public_authorities, Public),
    changes_result(Changes, Public, Result).

changes_result(true, _, requirement_applies).
changes_result(false, true, compliance_required_by_2_august_2030).
changes_result(false, false, existing_system_without_significant_changes_not_covered).

test_referral(_, eu_reg_2024_1689_art_111_2).

test(a_well_formed_profile_has_no_problem) :-
    high_risk_requirements_input_problems([attribute(intended_to_be_used_by_public_authorities, unsure)], []).
test(a_duplicate_key_and_an_unknown_key_are_named) :-
    high_risk_requirements_input_problems([attribute(system_is_a_component_of_products, true), attribute(system_is_a_component_of_products, true), attribute(colour, red)], Problems),
    Problems == [duplicate_key(system_is_a_component_of_products), unknown_key(colour)].
test(a_crisp_key_given_unsure_is_a_wrong_type) :-
    high_risk_requirements_input_problems([attribute(system_is_a_component_of_products, unsure)], [wrong_type(system_is_a_component_of_products)]).
test(an_unbound_profile_is_not_an_attribute_list) :-
    high_risk_requirements_input_problems(_, [wrong_type(profile)]).
test(a_leap_day_is_a_real_day) :-
    high_risk_requirements_valid_date_t(date(2028, 2, 29), true).
test(february_29_of_2027_is_not_a_day) :-
    high_risk_requirements_valid_date_t(date(2027, 2, 29), false).
test(month_thirteen_is_not_a_day) :-
    high_risk_requirements_valid_date_t(date(2027, 13, 1), false).
test(year_ten_thousand_is_out_of_range) :-
    high_risk_requirements_valid_date_t(date(10000, 1, 1), false).
test(a_word_day_is_not_a_bare_integer) :-
    high_risk_requirements_valid_date_t(date(2027, 12, second), false).
test(an_unbound_date_is_not_a_date) :-
    high_risk_requirements_valid_date_t(_, false).
test(the_day_before_is_before) :-
    high_risk_requirements_day_before_t(date(2027, 12, 1), date(2027, 12, 2), true).
test(the_day_itself_is_not_before) :-
    high_risk_requirements_day_before_t(date(2027, 12, 2), date(2027, 12, 2), false).
test(a_later_year_is_not_before_an_earlier_one) :-
    high_risk_requirements_day_before_t(date(2028, 1, 1), date(2027, 12, 31), false).
test(settle_answers_a_complete_profile) :-
    high_risk_requirements_settle([system_is_a_high_risk_ai_system_listed_in_annex_iii], [attribute(system_is_a_high_risk_ai_system_listed_in_annex_iii, true)], annex_iii_ladder, test_referral, requirement_applies, [cite(eu_reg_2024_1689_art_8_1)]).
test(settle_names_the_missing_key) :-
    high_risk_requirements_settle([system_is_a_high_risk_ai_system_listed_in_annex_iii], [], annex_iii_ladder, test_referral, indeterminate([system_is_a_high_risk_ai_system_listed_in_annex_iii]), []).
test(settle_refers_an_unsure_judgement_that_matters) :-
    high_risk_requirements_settle([significant_changes_in_design_as_from_the_chapter_iii_date, intended_to_be_used_by_public_authorities], [attribute(significant_changes_in_design_as_from_the_chapter_iii_date, unsure), attribute(intended_to_be_used_by_public_authorities, false)], changes_ladder, test_referral, Result, Citations),
    Result == needs_legal_review(open_textured(significant_changes_in_design_as_from_the_chapter_iii_date, cite(eu_reg_2024_1689_art_111_2)), [inputs_relied_on([significant_changes_in_design_as_from_the_chapter_iii_date - unsure, intended_to_be_used_by_public_authorities - false])]),
    Citations == [].
test(settle_never_names_a_key_behind_another) :-
    high_risk_requirements_settle([intended_to_be_used_by_public_authorities, significant_changes_in_design_as_from_the_chapter_iii_date], [], changes_ladder, test_referral, Result, []),
    Result == indeterminate([significant_changes_in_design_as_from_the_chapter_iii_date]).

test(settle_does_not_name_the_behind_key, fail) :-
    high_risk_requirements_settle([intended_to_be_used_by_public_authorities, significant_changes_in_design_as_from_the_chapter_iii_date], [], changes_ladder, test_referral, indeterminate([intended_to_be_used_by_public_authorities]), []).
