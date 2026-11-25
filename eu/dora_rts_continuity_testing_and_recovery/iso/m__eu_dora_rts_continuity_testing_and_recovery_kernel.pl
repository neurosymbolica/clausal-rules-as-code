% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_rts_continuity_testing_and_recovery_kernel, [dora_rts_continuity_testing_and_recovery_input_problems/2]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(library(reif), [memberd_t/3]).

dora_rts_continuity_testing_and_recovery_input_problems(Profile, Problems) :-
    attribute_list_t(Profile, IsAttributeList),
    profile_problems(IsAttributeList, Profile, Problems).

profile_problems(false, _, [wrong_type(profile)]).
profile_problems(true, Profile, Problems) :-
    Keys = [financial_entity_is_article_16_1_entity, financial_entity_is_microenterprise, dora_entity_type, financial_entity_uses_ict_services_of_ict_third_party_service_providers, continuity_testing_takes_into_account_business_impact_analysis_and_ict_risk_assessment, continuity_testing_assesses_continuity_of_critical_or_important_functions, continuity_testing_based_on_scenarios_including_severe_but_plausible_scenarios, continuity_testing_contains_testing_of_ict_services_of_ict_third_party_service_providers, continuity_testing_contains_switchover_scenarios, continuity_testing_challenges_assumptions_of_business_continuity_plans, continuity_testing_contains_procedures_to_verify_ability_to_respond, continuity_testing_involves_clearing_members_external_providers_and_interdependent_institutions, continuity_testing_involves_users_utilities_market_infrastructures_and_interdependent_institutions, continuity_test_results_documented, continuity_test_deficiencies_analysed_addressed_and_reported_to_management_body, response_and_recovery_plans_take_into_account_business_impact_analysis, response_and_recovery_plans_specify_activation_and_deactivation_conditions_and_exceptions, response_and_recovery_plans_describe_actions_for_ict_systems_and_services_supporting_critical_or_important_functions, response_and_recovery_plans_designed_to_meet_recovery_objectives, response_and_recovery_plans_documented_available_and_accessible_with_roles_and_responsibilities, response_and_recovery_plans_provide_short_term_and_long_term_recovery_options, response_and_recovery_plans_lay_down_objectives_and_conditions_of_successful_execution, response_and_recovery_plans_identify_relevant_scenarios, response_and_recovery_plans_develop_scenarios_on_current_threat_information_and_lessons_learned, listed_disruption_scenarios_duly_taken_into_account, response_and_recovery_plans_consider_alternative_options_where_primary_recovery_measures_may_not_be_feasible, continuity_measures_for_ict_third_party_service_provider_failures_considered_and_implemented],
    unknown_keys(Profile, Keys, UnknownKeyProblems),
    key_problems(Keys, Profile, UnknownKeyProblems, Problems).

key_type(financial_entity_is_article_16_1_entity, fact).
key_type(financial_entity_is_microenterprise, fact).
key_type(dora_entity_type, entity_type).
key_type(financial_entity_uses_ict_services_of_ict_third_party_service_providers, fact).
key_type(continuity_testing_takes_into_account_business_impact_analysis_and_ict_risk_assessment, judgement).
key_type(continuity_testing_assesses_continuity_of_critical_or_important_functions, judgement).
key_type(continuity_testing_based_on_scenarios_including_severe_but_plausible_scenarios, judgement).
key_type(continuity_testing_contains_testing_of_ict_services_of_ict_third_party_service_providers, judgement).
key_type(continuity_testing_contains_switchover_scenarios, judgement).
key_type(continuity_testing_challenges_assumptions_of_business_continuity_plans, judgement).
key_type(continuity_testing_contains_procedures_to_verify_ability_to_respond, judgement).
key_type(continuity_testing_involves_clearing_members_external_providers_and_interdependent_institutions, judgement).
key_type(continuity_testing_involves_users_utilities_market_infrastructures_and_interdependent_institutions, judgement).
key_type(continuity_test_results_documented, judgement).
key_type(continuity_test_deficiencies_analysed_addressed_and_reported_to_management_body, judgement).
key_type(response_and_recovery_plans_take_into_account_business_impact_analysis, judgement).
key_type(response_and_recovery_plans_specify_activation_and_deactivation_conditions_and_exceptions, judgement).
key_type(response_and_recovery_plans_describe_actions_for_ict_systems_and_services_supporting_critical_or_important_functions, judgement).
key_type(response_and_recovery_plans_designed_to_meet_recovery_objectives, judgement).
key_type(response_and_recovery_plans_documented_available_and_accessible_with_roles_and_responsibilities, judgement).
key_type(response_and_recovery_plans_provide_short_term_and_long_term_recovery_options, judgement).
key_type(response_and_recovery_plans_lay_down_objectives_and_conditions_of_successful_execution, judgement).
key_type(response_and_recovery_plans_identify_relevant_scenarios, judgement).
key_type(response_and_recovery_plans_develop_scenarios_on_current_threat_information_and_lessons_learned, judgement).
key_type(listed_disruption_scenarios_duly_taken_into_account, judgement).
key_type(response_and_recovery_plans_consider_alternative_options_where_primary_recovery_measures_may_not_be_feasible, judgement).
key_type(continuity_measures_for_ict_third_party_service_provider_failures_considered_and_implemented, judgement).

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

in_type_t(fact, Value, T) :-
    in_type_t(boolean, Value, T).
in_type_t(entity_type, Value, T) :-
    in_type_t(enum([credit_institution, institution_exempted_pursuant_to_directive_2013_36, payment_institution, exempted_payment_institution, account_information_service_provider, electronic_money_institution, exempted_electronic_money_institution, investment_firm, crypto_asset_service_provider, issuer_of_asset_referenced_tokens, central_securities_depository, central_counterparty, trading_venue, trade_repository, manager_of_alternative_investment_funds, management_company, data_reporting_service_provider, insurance_undertaking, reinsurance_undertaking, insurance_intermediary, reinsurance_intermediary, ancillary_insurance_intermediary, institution_for_occupational_retirement_provision, credit_rating_agency, administrator_of_critical_benchmarks, crowdfunding_service_provider, securitisation_repository, ict_third_party_service_provider, none_of_the_listed_types]), Value, T).
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
