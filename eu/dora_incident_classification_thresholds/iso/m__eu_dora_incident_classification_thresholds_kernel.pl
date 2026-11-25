% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_incident_classification_thresholds_kernel, [dora_incident_classification_thresholds_input_problems/2]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(library(reif), [memberd_t/3]).

dora_incident_classification_thresholds_input_problems(Profile, Problems) :-
    attribute_list_t(Profile, IsAttributeList),
    profile_problems(IsAttributeList, Profile, Problems).

profile_problems(false, _, [wrong_type(profile)]).
profile_problems(true, Profile, Problems) :-
    Keys = [affects_ict_services_supporting_critical_or_important_functions, affects_authorised_registered_or_supervised_financial_services, successful_malicious_unauthorised_access, access_may_result_in_data_losses, affected_clients, clients_using_affected_service, affected_financial_counterparts, financial_counterparts_of_affected_service, affected_transactions_number, affected_transactions_amount, reference_period_transactions_number, reference_period_transactions_amount, reference_period_days, relevant_clients_or_financial_counterparts_affected, incident_reflected_in_media, repetitive_complaints_from_different_clients_or_counterparts, regulatory_requirements_likely_not_met, material_loss_of_clients_or_counterparts_likely, incident_duration_seconds, critical_or_important_function_service_downtime_seconds, member_states_with_impact, data_impact_adverse_to_business_objectives_or_regulatory_requirements, data_availability_impact, data_authenticity_impact, data_integrity_impact, data_confidentiality_impact, expropriated_funds_and_assets_cents, replacement_and_relocation_costs_cents, staff_costs_cents, contractual_non_compliance_fees_cents, redress_and_compensation_costs_cents, forgone_revenue_losses_cents, communication_costs_cents, advisory_costs_cents, costs_and_losses_likely_to_exceed_threshold, final_report_weekend_extension],
    unknown_keys(Profile, Keys, UnknownKeyProblems),
    key_problems(Keys, Profile, UnknownKeyProblems, Problems).

key_type(affects_ict_services_supporting_critical_or_important_functions, judgement).
key_type(affects_authorised_registered_or_supervised_financial_services, judgement).
key_type(successful_malicious_unauthorised_access, judgement).
key_type(access_may_result_in_data_losses, judgement).
key_type(affected_clients, non_negative_integer).
key_type(clients_using_affected_service, non_negative_integer).
key_type(affected_financial_counterparts, non_negative_integer).
key_type(financial_counterparts_of_affected_service, non_negative_integer).
key_type(affected_transactions_number, non_negative_integer).
key_type(affected_transactions_amount, non_negative_integer).
key_type(reference_period_transactions_number, non_negative_integer).
key_type(reference_period_transactions_amount, non_negative_integer).
key_type(reference_period_days, non_negative_integer).
key_type(relevant_clients_or_financial_counterparts_affected, judgement).
key_type(incident_reflected_in_media, judgement).
key_type(repetitive_complaints_from_different_clients_or_counterparts, judgement).
key_type(regulatory_requirements_likely_not_met, judgement).
key_type(material_loss_of_clients_or_counterparts_likely, judgement).
key_type(incident_duration_seconds, non_negative_integer).
key_type(critical_or_important_function_service_downtime_seconds, non_negative_integer).
key_type(member_states_with_impact, non_negative_integer).
key_type(data_impact_adverse_to_business_objectives_or_regulatory_requirements, judgement).
key_type(data_availability_impact, judgement).
key_type(data_authenticity_impact, judgement).
key_type(data_integrity_impact, judgement).
key_type(data_confidentiality_impact, judgement).
key_type(expropriated_funds_and_assets_cents, non_negative_integer).
key_type(replacement_and_relocation_costs_cents, non_negative_integer).
key_type(staff_costs_cents, non_negative_integer).
key_type(contractual_non_compliance_fees_cents, non_negative_integer).
key_type(redress_and_compensation_costs_cents, non_negative_integer).
key_type(forgone_revenue_losses_cents, non_negative_integer).
key_type(communication_costs_cents, non_negative_integer).
key_type(advisory_costs_cents, non_negative_integer).
key_type(costs_and_losses_likely_to_exceed_threshold, judgement).
key_type(final_report_weekend_extension, fact).

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
in_type_t(fact, Value, T) :-
    in_type_t(boolean, Value, T).
in_type_t(boolean, Value, T) :-
    memberd_t(Value, [true, false], T).
in_type_t(enum(Values), Value, T) :-
    memberd_t(Value, Values, T).
in_type_t(one_of(Types), Value, T) :-
    in_some_type_t(Types, Value, T).
in_type_t(non_negative_integer, Value, T) :-
    non_negative_integer_t(Value, T).

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

non_negative_integer_t(Value, T) :-
    integer_t(Value, IsInteger),
    not_below_zero_t(IsInteger, Value, T).

not_below_zero_t(false, _, false).
not_below_zero_t(true, Value, true) :-
    Value >= 0.
not_below_zero_t(true, Value, false) :-
    Value < 0.
