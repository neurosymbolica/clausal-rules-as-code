% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_ict_risk_protection_and_detection_kernel, [dora_ict_risk_protection_and_detection_input_problems/2]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(library(reif), [memberd_t/3]).

dora_ict_risk_protection_and_detection_input_problems(Profile, Problems) :-
    attribute_list_t(Profile, IsAttributeList),
    profile_problems(IsAttributeList, Profile, Problems).

profile_problems(false, _, [wrong_type(profile)]).
profile_problems(true, Profile, Problems) :-
    Keys = [financial_entity_is_article_16_1_entity, dora_entity_type, monitors_and_controls_security_and_functioning_of_ict_systems, deploys_ict_security_tools_policies_and_procedures, ict_security_policies_procedures_protocols_and_tools_implemented, uses_appropriate_ict_solutions_and_processes, ict_solutions_ensure_security_of_data_transfer, ict_solutions_minimise_data_corruption_loss_unauthorised_access_and_flaws, ict_solutions_prevent_unavailability_impairment_breaches_and_data_loss, ict_solutions_protect_data_from_data_management_risks, information_security_policy_developed_and_documented, network_and_infrastructure_management_structure_established, access_limiting_policies_and_access_rights_controls_implemented, strong_authentication_and_cryptographic_key_protection_implemented, ict_change_management_policies_procedures_and_controls_implemented, patch_and_update_policies_documented, network_connection_infrastructure_can_be_severed_or_segmented, ict_change_management_process_approved_with_specific_protocols, anomaly_detection_mechanisms_in_place, mechanisms_to_identify_single_points_of_failure_in_place, detection_mechanisms_regularly_tested, detection_mechanisms_enable_control_layers_alert_thresholds_and_automatic_alerts, sufficient_resources_devoted_to_monitoring_user_activity_anomalies_and_incidents, trade_report_checking_systems_in_place],
    unknown_keys(Profile, Keys, UnknownKeyProblems),
    key_problems(Keys, Profile, UnknownKeyProblems, Problems).

key_type(financial_entity_is_article_16_1_entity, fact).
key_type(dora_entity_type, entity_type).
key_type(monitors_and_controls_security_and_functioning_of_ict_systems, judgement).
key_type(deploys_ict_security_tools_policies_and_procedures, judgement).
key_type(ict_security_policies_procedures_protocols_and_tools_implemented, judgement).
key_type(uses_appropriate_ict_solutions_and_processes, judgement).
key_type(ict_solutions_ensure_security_of_data_transfer, judgement).
key_type(ict_solutions_minimise_data_corruption_loss_unauthorised_access_and_flaws, judgement).
key_type(ict_solutions_prevent_unavailability_impairment_breaches_and_data_loss, judgement).
key_type(ict_solutions_protect_data_from_data_management_risks, judgement).
key_type(information_security_policy_developed_and_documented, judgement).
key_type(network_and_infrastructure_management_structure_established, judgement).
key_type(access_limiting_policies_and_access_rights_controls_implemented, judgement).
key_type(strong_authentication_and_cryptographic_key_protection_implemented, judgement).
key_type(ict_change_management_policies_procedures_and_controls_implemented, judgement).
key_type(patch_and_update_policies_documented, judgement).
key_type(network_connection_infrastructure_can_be_severed_or_segmented, judgement).
key_type(ict_change_management_process_approved_with_specific_protocols, judgement).
key_type(anomaly_detection_mechanisms_in_place, judgement).
key_type(mechanisms_to_identify_single_points_of_failure_in_place, judgement).
key_type(detection_mechanisms_regularly_tested, judgement).
key_type(detection_mechanisms_enable_control_layers_alert_thresholds_and_automatic_alerts, judgement).
key_type(sufficient_resources_devoted_to_monitoring_user_activity_anomalies_and_incidents, judgement).
key_type(trade_report_checking_systems_in_place, judgement).

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
