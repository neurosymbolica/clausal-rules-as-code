% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_rts_physical_hr_identity_and_access_kernel, [dora_rts_physical_hr_identity_and_access_input_problems/2]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(library(reif), [memberd_t/3]).

dora_rts_physical_hr_identity_and_access_input_problems(Profile, Problems) :-
    attribute_list_t(Profile, IsAttributeList),
    profile_problems(IsAttributeList, Profile, Problems).

profile_problems(false, _, [wrong_type(profile)]).
profile_problems(true, Profile, Problems) :-
    Keys = [financial_entity_is_article_16_1_entity, physical_and_environmental_security_policy_specified_documented_and_implemented, physical_security_policy_designed_in_light_of_threat_landscape_classification_and_risk_profile, physical_security_policy_refers_to_section_on_physical_access_controls, physical_security_policy_contains_measures_protecting_premises_data_centres_and_sensitive_areas, physical_security_policy_contains_measures_securing_ict_assets_within_and_outside_premises, physical_security_policy_contains_measures_of_appropriate_maintenance, physical_security_policy_contains_clear_desk_policy_for_papers, physical_security_policy_contains_clear_screen_policy_for_information_processing_facilities, physical_security_policy_contains_measures_protecting_unattended_ict_assets, human_resource_policy_identifies_and_assigns_ict_security_responsibilities, human_resource_policy_requires_staff_to_be_informed_of_and_adhere_to_ict_security_policies, human_resource_policy_requires_staff_to_be_aware_of_reporting_channels, human_resource_policy_requires_staff_to_return_assets_upon_termination_of_employment, identity_management_policies_and_procedures_developed_documented_and_implemented, identity_management_assigns_unique_identity_corresponding_to_unique_user_account, identity_management_contains_lifecycle_management_process_for_identities_and_accounts, records_of_all_identity_assignments_maintained_and_kept, automated_solutions_for_lifecycle_identity_management_deployed_where_feasible_and_appropriate, access_control_policy_developed_documented_and_implemented, access_control_policy_assigns_access_rights_on_need_to_know_need_to_use_and_least_privilege, access_control_policy_contains_segregation_of_duties, access_control_policy_contains_provision_on_user_accountability, access_control_policy_contains_provision_on_restrictions_of_access_to_ict_assets, account_management_procedures_assign_roles_for_granting_reviewing_and_revoking_access_rights, account_management_procedures_assign_privileged_emergency_and_administrator_access_on_need_to_use_or_ad_hoc_basis, account_management_procedures_withdraw_access_rights_without_undue_delay, account_management_procedures_update_access_rights_where_necessary_and_at_the_required_intervals, access_control_policy_uses_authentication_methods_commensurate_to_classification_and_risk_profile, access_control_policy_uses_strong_authentication_methods_where_required, physical_access_controls_identify_and_log_persons_authorised_to_access_premises, physical_access_rights_to_critical_ict_assets_granted_to_authorised_persons_only, physical_access_to_premises_data_centres_and_sensitive_areas_monitored, physical_access_rights_reviewed_and_unnecessary_rights_promptly_revoked, retention_period_for_the_purposes_of_point_e_i_established, dedicated_accounts_used_for_administrative_tasks_where_possible, automated_solutions_for_privileged_access_management_deployed_where_feasible_and_appropriate],
    unknown_keys(Profile, Keys, UnknownKeyProblems),
    key_problems(Keys, Profile, UnknownKeyProblems, Problems).

key_type(financial_entity_is_article_16_1_entity, fact).
key_type(physical_and_environmental_security_policy_specified_documented_and_implemented, judgement).
key_type(physical_security_policy_designed_in_light_of_threat_landscape_classification_and_risk_profile, judgement).
key_type(physical_security_policy_refers_to_section_on_physical_access_controls, judgement).
key_type(physical_security_policy_contains_measures_protecting_premises_data_centres_and_sensitive_areas, judgement).
key_type(physical_security_policy_contains_measures_securing_ict_assets_within_and_outside_premises, judgement).
key_type(physical_security_policy_contains_measures_of_appropriate_maintenance, judgement).
key_type(physical_security_policy_contains_clear_desk_policy_for_papers, judgement).
key_type(physical_security_policy_contains_clear_screen_policy_for_information_processing_facilities, judgement).
key_type(physical_security_policy_contains_measures_protecting_unattended_ict_assets, judgement).
key_type(human_resource_policy_identifies_and_assigns_ict_security_responsibilities, judgement).
key_type(human_resource_policy_requires_staff_to_be_informed_of_and_adhere_to_ict_security_policies, judgement).
key_type(human_resource_policy_requires_staff_to_be_aware_of_reporting_channels, judgement).
key_type(human_resource_policy_requires_staff_to_return_assets_upon_termination_of_employment, judgement).
key_type(identity_management_policies_and_procedures_developed_documented_and_implemented, judgement).
key_type(identity_management_assigns_unique_identity_corresponding_to_unique_user_account, judgement).
key_type(identity_management_contains_lifecycle_management_process_for_identities_and_accounts, judgement).
key_type(records_of_all_identity_assignments_maintained_and_kept, judgement).
key_type(automated_solutions_for_lifecycle_identity_management_deployed_where_feasible_and_appropriate, judgement).
key_type(access_control_policy_developed_documented_and_implemented, judgement).
key_type(access_control_policy_assigns_access_rights_on_need_to_know_need_to_use_and_least_privilege, judgement).
key_type(access_control_policy_contains_segregation_of_duties, judgement).
key_type(access_control_policy_contains_provision_on_user_accountability, judgement).
key_type(access_control_policy_contains_provision_on_restrictions_of_access_to_ict_assets, judgement).
key_type(account_management_procedures_assign_roles_for_granting_reviewing_and_revoking_access_rights, judgement).
key_type(account_management_procedures_assign_privileged_emergency_and_administrator_access_on_need_to_use_or_ad_hoc_basis, judgement).
key_type(account_management_procedures_withdraw_access_rights_without_undue_delay, judgement).
key_type(account_management_procedures_update_access_rights_where_necessary_and_at_the_required_intervals, judgement).
key_type(access_control_policy_uses_authentication_methods_commensurate_to_classification_and_risk_profile, judgement).
key_type(access_control_policy_uses_strong_authentication_methods_where_required, judgement).
key_type(physical_access_controls_identify_and_log_persons_authorised_to_access_premises, judgement).
key_type(physical_access_rights_to_critical_ict_assets_granted_to_authorised_persons_only, judgement).
key_type(physical_access_to_premises_data_centres_and_sensitive_areas_monitored, judgement).
key_type(physical_access_rights_reviewed_and_unnecessary_rights_promptly_revoked, judgement).
key_type(retention_period_for_the_purposes_of_point_e_i_established, judgement).
key_type(dedicated_accounts_used_for_administrative_tasks_where_possible, judgement).
key_type(automated_solutions_for_privileged_access_management_deployed_where_feasible_and_appropriate, judgement).

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

test(an_empty_profile_has_no_problem) :-
    dora_rts_physical_hr_identity_and_access_input_problems([], []).
test(an_unbound_profile_is_not_an_attribute_list) :-
    dora_rts_physical_hr_identity_and_access_input_problems(_, [wrong_type(profile)]).
test(the_gate_does_not_take_unsure) :-
    dora_rts_physical_hr_identity_and_access_input_problems([attribute(financial_entity_is_article_16_1_entity, unsure)], [wrong_type(financial_entity_is_article_16_1_entity)]).
test(the_gate_takes_false) :-
    dora_rts_physical_hr_identity_and_access_input_problems([attribute(financial_entity_is_article_16_1_entity, false)], []).
test(a_judgement_takes_unsure) :-
    dora_rts_physical_hr_identity_and_access_input_problems([attribute(access_control_policy_contains_segregation_of_duties, unsure)], []).
test(a_repeated_key_is_a_duplicate_only) :-
    dora_rts_physical_hr_identity_and_access_input_problems([attribute(financial_entity_is_article_16_1_entity, true), attribute(financial_entity_is_article_16_1_entity, 7)], [duplicate_key(financial_entity_is_article_16_1_entity)]).
test(an_unknown_key_is_named) :-
    dora_rts_physical_hr_identity_and_access_input_problems([attribute(colour, blue)], [unknown_key(colour)]).

test(a_known_key_is_not_unknown, fail) :-
    dora_rts_physical_hr_identity_and_access_input_problems([attribute(access_control_policy_contains_segregation_of_duties, true)], [unknown_key(access_control_policy_contains_segregation_of_duties)]).
