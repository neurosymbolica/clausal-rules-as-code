% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_ctpp_designation_kernel, [dora_ctpp_designation_input_problems/2, dora_ctpp_designation_shared_type/3, dora_ctpp_designation_financial_entity_type/2, dora_ctpp_designation_category_synonym/3]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(library(reif), [memberd_t/3]).

dora_ctpp_designation_shared_type(credit_institution, 0, cite(eu_reg_2022_2554_art_2_1)).
dora_ctpp_designation_shared_type(payment_institution, 1, cite(eu_reg_2022_2554_art_2_1)).
dora_ctpp_designation_shared_type(exempted_payment_institution, 2, cite(eu_reg_2022_2554_art_2_1)).
dora_ctpp_designation_shared_type(account_information_service_provider, 3, cite(eu_reg_2022_2554_art_2_1)).
dora_ctpp_designation_shared_type(electronic_money_institution, 4, cite(eu_reg_2022_2554_art_2_1)).
dora_ctpp_designation_shared_type(exempted_electronic_money_institution, 5, cite(eu_reg_2022_2554_art_2_1)).
dora_ctpp_designation_shared_type(investment_firm, 6, cite(eu_reg_2022_2554_art_2_1)).
dora_ctpp_designation_shared_type(crypto_asset_service_provider, 7, cite(eu_reg_2022_2554_art_2_1)).
dora_ctpp_designation_shared_type(issuer_of_asset_referenced_tokens, 8, cite(eu_reg_2022_2554_art_2_1)).
dora_ctpp_designation_shared_type(central_securities_depository, 9, cite(eu_reg_2022_2554_art_2_1)).
dora_ctpp_designation_shared_type(central_counterparty, 10, cite(eu_reg_2022_2554_art_2_1)).
dora_ctpp_designation_shared_type(trading_venue, 11, cite(eu_reg_2022_2554_art_2_1)).
dora_ctpp_designation_shared_type(trade_repository, 12, cite(eu_reg_2022_2554_art_2_1)).
dora_ctpp_designation_shared_type(manager_of_alternative_investment_funds, 13, cite(eu_reg_2022_2554_art_2_1)).
dora_ctpp_designation_shared_type(management_company, 14, cite(eu_reg_2022_2554_art_2_1)).
dora_ctpp_designation_shared_type(data_reporting_service_provider, 15, cite(eu_reg_2022_2554_art_2_1)).
dora_ctpp_designation_shared_type(insurance_undertaking, 16, cite(eu_reg_2022_2554_art_2_1)).
dora_ctpp_designation_shared_type(reinsurance_undertaking, 17, cite(eu_reg_2022_2554_art_2_1)).
dora_ctpp_designation_shared_type(insurance_intermediary, 18, cite(eu_reg_2022_2554_art_2_1)).
dora_ctpp_designation_shared_type(reinsurance_intermediary, 19, cite(eu_reg_2022_2554_art_2_1)).
dora_ctpp_designation_shared_type(ancillary_insurance_intermediary, 20, cite(eu_reg_2022_2554_art_2_1)).
dora_ctpp_designation_shared_type(institution_for_occupational_retirement_provision, 21, cite(eu_reg_2022_2554_art_2_1)).
dora_ctpp_designation_shared_type(credit_rating_agency, 22, cite(eu_reg_2022_2554_art_2_1)).
dora_ctpp_designation_shared_type(administrator_of_critical_benchmarks, 23, cite(eu_reg_2022_2554_art_2_1)).
dora_ctpp_designation_shared_type(crowdfunding_service_provider, 24, cite(eu_reg_2022_2554_art_2_1)).
dora_ctpp_designation_shared_type(securitisation_repository, 25, cite(eu_reg_2022_2554_art_2_1)).
dora_ctpp_designation_shared_type(ict_third_party_service_provider, 26, cite(eu_reg_2022_2554_art_2_1)).

dora_ctpp_designation_financial_entity_type(credit_institution, cite(eu_reg_2022_2554_art_2_2)).
dora_ctpp_designation_financial_entity_type(payment_institution, cite(eu_reg_2022_2554_art_2_2)).
dora_ctpp_designation_financial_entity_type(exempted_payment_institution, cite(eu_reg_2022_2554_art_2_2)).
dora_ctpp_designation_financial_entity_type(account_information_service_provider, cite(eu_reg_2022_2554_art_2_2)).
dora_ctpp_designation_financial_entity_type(electronic_money_institution, cite(eu_reg_2022_2554_art_2_2)).
dora_ctpp_designation_financial_entity_type(exempted_electronic_money_institution, cite(eu_reg_2022_2554_art_2_2)).
dora_ctpp_designation_financial_entity_type(investment_firm, cite(eu_reg_2022_2554_art_2_2)).
dora_ctpp_designation_financial_entity_type(crypto_asset_service_provider, cite(eu_reg_2022_2554_art_2_2)).
dora_ctpp_designation_financial_entity_type(issuer_of_asset_referenced_tokens, cite(eu_reg_2022_2554_art_2_2)).
dora_ctpp_designation_financial_entity_type(central_securities_depository, cite(eu_reg_2022_2554_art_2_2)).
dora_ctpp_designation_financial_entity_type(central_counterparty, cite(eu_reg_2022_2554_art_2_2)).
dora_ctpp_designation_financial_entity_type(trading_venue, cite(eu_reg_2022_2554_art_2_2)).
dora_ctpp_designation_financial_entity_type(trade_repository, cite(eu_reg_2022_2554_art_2_2)).
dora_ctpp_designation_financial_entity_type(manager_of_alternative_investment_funds, cite(eu_reg_2022_2554_art_2_2)).
dora_ctpp_designation_financial_entity_type(management_company, cite(eu_reg_2022_2554_art_2_2)).
dora_ctpp_designation_financial_entity_type(data_reporting_service_provider, cite(eu_reg_2022_2554_art_2_2)).
dora_ctpp_designation_financial_entity_type(insurance_undertaking, cite(eu_reg_2022_2554_art_2_2)).
dora_ctpp_designation_financial_entity_type(reinsurance_undertaking, cite(eu_reg_2022_2554_art_2_2)).
dora_ctpp_designation_financial_entity_type(insurance_intermediary, cite(eu_reg_2022_2554_art_2_2)).
dora_ctpp_designation_financial_entity_type(reinsurance_intermediary, cite(eu_reg_2022_2554_art_2_2)).
dora_ctpp_designation_financial_entity_type(ancillary_insurance_intermediary, cite(eu_reg_2022_2554_art_2_2)).
dora_ctpp_designation_financial_entity_type(institution_for_occupational_retirement_provision, cite(eu_reg_2022_2554_art_2_2)).
dora_ctpp_designation_financial_entity_type(credit_rating_agency, cite(eu_reg_2022_2554_art_2_2)).
dora_ctpp_designation_financial_entity_type(administrator_of_critical_benchmarks, cite(eu_reg_2022_2554_art_2_2)).
dora_ctpp_designation_financial_entity_type(crowdfunding_service_provider, cite(eu_reg_2022_2554_art_2_2)).
dora_ctpp_designation_financial_entity_type(securitisation_repository, cite(eu_reg_2022_2554_art_2_2)).

dora_ctpp_designation_category_synonym(exempted_payment_institution, payment_institution, cite(eu_reg_2022_2554_art_2_1)).
dora_ctpp_designation_category_synonym(exempted_electronic_money_institution, electronic_money_institution, cite(eu_reg_2022_2554_art_2_1)).

dora_ctpp_designation_input_problems(Profile, Problems) :-
    attribute_list_t(Profile, IsAttributeList),
    profile_problems(IsAttributeList, Profile, Problems).

profile_problems(false, _, [wrong_type(profile)]).
profile_problems(true, Profile, Problems) :-
    Keys = [dora_entity_type, provider_subject_to_article_127_2_tfeu_oversight_framework, provider_is_ict_intra_group_service_provider, provider_provides_ict_services_solely_in_one_member_state, financial_entities_served_are_active_only_in_that_member_state, systemic_impact_figures, g_sii_served_count, o_sii_scores_of_o_siis_served, systemic_infrastructure_entities_served_count, systemic_other_entities_served_count, substitutability_figures, total_assets_of_users_within_eba_responsibility, total_assets_of_users_within_eiopa_responsibility, total_assets_of_users_within_esma_responsibility, provider_designated_as_critical, provider_is_part_of_a_group, provider_established_in_third_country],
    unknown_keys(Profile, Keys, UnknownKeyProblems),
    key_problems(Keys, Profile, UnknownKeyProblems, Problems).

key_type(dora_entity_type, entity_type).
key_type(provider_subject_to_article_127_2_tfeu_oversight_framework, boolean).
key_type(provider_is_ict_intra_group_service_provider, boolean).
key_type(provider_provides_ict_services_solely_in_one_member_state, boolean).
key_type(financial_entities_served_are_active_only_in_that_member_state, boolean).
key_type(systemic_impact_figures, records(category_share_figures)).
key_type(g_sii_served_count, non_negative_integer).
key_type(o_sii_scores_of_o_siis_served, list(non_negative_integer)).
key_type(systemic_infrastructure_entities_served_count, non_negative_integer).
key_type(systemic_other_entities_served_count, non_negative_integer).
key_type(substitutability_figures, records(category_substitutability_figures)).
key_type(total_assets_of_users_within_eba_responsibility, non_negative_integer).
key_type(total_assets_of_users_within_eiopa_responsibility, non_negative_integer).
key_type(total_assets_of_users_within_esma_responsibility, non_negative_integer).
key_type(provider_designated_as_critical, boolean).
key_type(provider_is_part_of_a_group, boolean).
key_type(provider_established_in_third_country, boolean).

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

in_type_t(entity_type, Value, T) :-
    in_type_t(enum([credit_institution, payment_institution, exempted_payment_institution, account_information_service_provider, electronic_money_institution, exempted_electronic_money_institution, investment_firm, crypto_asset_service_provider, issuer_of_asset_referenced_tokens, central_securities_depository, central_counterparty, trading_venue, trade_repository, manager_of_alternative_investment_funds, management_company, data_reporting_service_provider, insurance_undertaking, reinsurance_undertaking, insurance_intermediary, reinsurance_intermediary, ancillary_insurance_intermediary, institution_for_occupational_retirement_provision, credit_rating_agency, administrator_of_critical_benchmarks, crowdfunding_service_provider, securitisation_repository, ict_third_party_service_provider, none_of_the_listed_types]), Value, T).
in_type_t(category_share_figures, Value, T) :-
    share_record_t(Value, T).
in_type_t(category_substitutability_figures, Value, T) :-
    substitutability_record_t(Value, T).
in_type_t(boolean, Value, T) :-
    memberd_t(Value, [true, false], T).
in_type_t(enum(Values), Value, T) :-
    memberd_t(Value, Values, T).
in_type_t(list(Type), Value, T) :-
    list_in_type_t(Value, Type, T).
in_type_t(records(Type), Value, T) :-
    list_in_type_t(Value, Type, ListInType),
    records_distinct_t(ListInType, Value, T).
in_type_t(non_negative_integer, Value, T) :-
    non_negative_integer_t(Value, T).

truth_and(true, T, T).
truth_and(false, _, false).

list_in_type_t(Value, _, true) :-
    Value == [].
list_in_type_t([Element|Elements], Type, T) :-
    in_type_t(Type, Element, ElementInType),
    list_in_type_t(Elements, Type, ElementsInType),
    truth_and(ElementInType, ElementsInType, T).
list_in_type_t(Value, _, false) :-
    Value \== [],
    Value \= [_|_].

share_record_t(Value, false) :-
    Value \= category_share_figures(_, _, _, _, _).
share_record_t(category_share_figures(Category, EntitiesServed, EntitiesTotal, AssetsServed, AssetsTotal), T) :-
    financial_entity_atom_t(Category, CategoryInType),
    non_negative_integers_t([EntitiesServed, EntitiesTotal, AssetsServed, AssetsTotal], FiguresInType),
    share_bounds_t(FiguresInType, EntitiesServed, EntitiesTotal, AssetsServed, AssetsTotal, BoundsHold),
    truth_and(CategoryInType, BoundsHold, T).

share_bounds_t(false, _, _, _, _, false).
share_bounds_t(true, EntitiesServed, EntitiesTotal, AssetsServed, AssetsTotal, T) :-
    at_least_one_t(EntitiesTotal, EntitiesTotalHolds),
    at_least_one_t(AssetsTotal, AssetsTotalHolds),
    not_above_t(EntitiesServed, EntitiesTotal, EntitiesServedHolds),
    not_above_t(AssetsServed, AssetsTotal, AssetsServedHolds),
    truth_and(EntitiesTotalHolds, AssetsTotalHolds, TotalsHold),
    truth_and(EntitiesServedHolds, AssetsServedHolds, ServedHold),
    truth_and(TotalsHold, ServedHold, T).

substitutability_record_t(Value, false) :-
    Value \= category_substitutability_figures(_, _, _, _).
substitutability_record_t(category_substitutability_figures(Category, EntitiesWithoutAlternative, EntitiesHighlyDifficultToMigrate, EntitiesTotal), T) :-
    financial_entity_atom_t(Category, CategoryInType),
    non_negative_integers_t([EntitiesWithoutAlternative, EntitiesHighlyDifficultToMigrate, EntitiesTotal], FiguresInType),
    substitutability_bounds_t(FiguresInType, EntitiesWithoutAlternative, EntitiesHighlyDifficultToMigrate, EntitiesTotal, BoundsHold),
    truth_and(CategoryInType, BoundsHold, T).

substitutability_bounds_t(false, _, _, _, false).
substitutability_bounds_t(true, EntitiesWithoutAlternative, EntitiesHighlyDifficultToMigrate, EntitiesTotal, T) :-
    at_least_one_t(EntitiesTotal, TotalHolds),
    not_above_t(EntitiesWithoutAlternative, EntitiesTotal, WithoutAlternativeHolds),
    not_above_t(EntitiesHighlyDifficultToMigrate, EntitiesTotal, HighlyDifficultHolds),
    truth_and(WithoutAlternativeHolds, HighlyDifficultHolds, PartsHold),
    truth_and(TotalHolds, PartsHold, T).

financial_entity_atom_t(Category, T) :-
    findall(Atom, dora_ctpp_designation_financial_entity_type(Atom, _), Atoms),
    memberd_t(Category, Atoms, T).

non_negative_integers_t([], true).
non_negative_integers_t([Value|Values], T) :-
    non_negative_integer_t(Value, ValueInType),
    non_negative_integers_t(Values, ValuesInType),
    truth_and(ValueInType, ValuesInType, T).

at_least_one_t(Value, true) :-
    Value >= 1.
at_least_one_t(Value, false) :-
    Value < 1.

not_above_t(Part, Total, true) :-
    Part =< Total.
not_above_t(Part, Total, false) :-
    Part > Total.

records_distinct_t(false, _, false).
records_distinct_t(true, Records, T) :-
    maplist(record_category, Records, Categories),
    distinct_categories_t(Categories, T).

record_category(category_share_figures(Category, _, _, _, _), Category).
record_category(category_substitutability_figures(Category, _, _, _), Category).

distinct_categories_t(Categories, T) :-
    sort(Categories, DistinctCategories),
    length(Categories, CategoryCount),
    length(DistinctCategories, DistinctCount),
    same_count_t(CategoryCount, DistinctCount, T).

same_count_t(CategoryCount, DistinctCount, true) :-
    CategoryCount =:= DistinctCount.
same_count_t(CategoryCount, DistinctCount, false) :-
    CategoryCount =\= DistinctCount.

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

test(a_well_formed_profile_has_no_problem) :-
    dora_ctpp_designation_input_problems([attribute(dora_entity_type, ict_third_party_service_provider), attribute(systemic_impact_figures, [category_share_figures(credit_institution, 3, 20, 4000, 30000)]), attribute(substitutability_figures, [category_substitutability_figures(credit_institution, 1, 2, 20)])], Problems),
    Problems == [].
test(an_empty_profile_has_no_problem) :-
    dora_ctpp_designation_input_problems([], Problems),
    Problems == [].
test(a_float_count_is_wrong_type) :-
    FloatCount is float(1),
    dora_ctpp_designation_input_problems([attribute(g_sii_served_count, FloatCount)], Problems),
    Problems == [wrong_type(g_sii_served_count)].
test(a_repeated_key_is_a_duplicate_and_never_wrong_type) :-
    FloatCount is float(1),
    dora_ctpp_designation_input_problems([attribute(g_sii_served_count, FloatCount), attribute(g_sii_served_count, 2)], Problems),
    Problems == [duplicate_key(g_sii_served_count)].
test(a_main_atom_beside_its_synonym_is_allowed) :-
    dora_ctpp_designation_input_problems([attribute(systemic_impact_figures, [category_share_figures(payment_institution, 1, 10, 1, 10), category_share_figures(exempted_payment_institution, 1, 10, 1, 10)])], Problems),
    Problems == [].
test(a_repeated_category_is_wrong_type) :-
    dora_ctpp_designation_input_problems([attribute(systemic_impact_figures, [category_share_figures(payment_institution, 1, 10, 1, 10), category_share_figures(payment_institution, 2, 10, 1, 10)])], Problems),
    Problems == [wrong_type(systemic_impact_figures)].
test(a_served_count_above_its_total_is_wrong_type) :-
    dora_ctpp_designation_input_problems([attribute(substitutability_figures, [category_substitutability_figures(credit_institution, 21, 2, 20)])], Problems),
    Problems == [wrong_type(substitutability_figures)].
test(a_zero_total_is_wrong_type) :-
    dora_ctpp_designation_input_problems([attribute(systemic_impact_figures, [category_share_figures(credit_institution, 0, 0, 0, 10)])], Problems),
    Problems == [wrong_type(systemic_impact_figures)].
test(the_directive_2013_36_atom_is_wrong_type) :-
    dora_ctpp_designation_input_problems([attribute(dora_entity_type, institution_exempted_pursuant_to_directive_2013_36)], Problems),
    Problems == [wrong_type(dora_entity_type)].
test(an_ict_provider_category_is_wrong_type) :-
    dora_ctpp_designation_input_problems([attribute(systemic_impact_figures, [category_share_figures(ict_third_party_service_provider, 1, 10, 1, 10)])], Problems),
    Problems == [wrong_type(systemic_impact_figures)].
test(contract_problems_come_before_unknown_keys) :-
    dora_ctpp_designation_input_problems([attribute(surplus, 1), attribute(provider_is_part_of_a_group, unsure)], Problems),
    Problems == [wrong_type(provider_is_part_of_a_group), unknown_key(surplus)].
test(a_non_attribute_element_is_not_a_profile) :-
    dora_ctpp_designation_input_problems([attribute(g_sii_served_count, 1), surplus], Problems),
    Problems == [wrong_type(profile)].
test(the_input_check_has_one_answer) :-
    findall(Problems, dora_ctpp_designation_input_problems([attribute(g_sii_served_count, 1)], Problems), Answers),
    Answers == [[]].

test(a_float_count_is_not_accepted, fail) :-
    FloatCount is float(1),
    dora_ctpp_designation_input_problems([attribute(g_sii_served_count, FloatCount)], []).
