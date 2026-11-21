% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_nis2_scope_entity_class_fixtures, [nis2_scope_entity_class_subject/1, nis2_scope_entity_class_profile_for/2, nis2_scope_entity_class_assess/2]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(library(reif), [tfilter/3, (=)/3]).
:- use_module(clausal_lists_extra, [subtract/3]).
:- use_module(library(reif), [if_/3, memberd_t/3]).
:- use_module(m__eu_nis2_scope_entity_class_kernel, [nis2_scope_entity_class_input_problems/2, nis2_scope_entity_class_profile_key_order/1]).
:- use_module(m__eu_nis2_scope_entity_class_nis2_scope_entity_class, [decide_nis2_scope_entity_class/2]).

nis2_scope_entity_class_subject(Subject) :-
    complete_subject(Subject, _).
nis2_scope_entity_class_subject(Subject) :-
    partial_subject(Subject, _, _).
nis2_scope_entity_class_subject(Subject) :-
    partial_profile(Subject, _).

nis2_scope_entity_class_profile_for(Subject, Profile) :-
    complete_subject(Subject, Overrides),
    baseline_profile(Baseline),
    maplist(overridden_item(Overrides), Baseline, Profile).
nis2_scope_entity_class_profile_for(Subject, Profile) :-
    partial_subject(Subject, Overrides, DroppedKeys),
    baseline_profile(Baseline),
    maplist(overridden_item(Overrides), Baseline, Overridden),
    tfilter(kept_item_t(DroppedKeys), Overridden, Profile).
nis2_scope_entity_class_profile_for(Subject, Profile) :-
    partial_profile(Subject, Profile).

baseline_profile([attribute(annex_i_type, false), attribute(annex_ii_type, false), attribute(services_or_activities_in_union, true), attribute(staff_headcount, 5), attribute(annual_turnover_eur, 1000000), attribute(annual_balance_sheet_total_eur, 1000000), attribute(public_electronic_communications_provider, false), attribute(trust_service_provider_status, not_a_trust_service_provider), attribute(tld_name_registry, false), attribute(dns_service_provider, false), attribute(sole_provider_of_an_essential_service_in_a_member_state, false), attribute(disruption_could_significantly_impact_public_safety_security_or_health, false), attribute(disruption_could_induce_a_significant_systemic_risk, false), attribute(critical_by_specific_national_or_regional_importance, false), attribute(public_administration_kind, not_public_administration), attribute(public_administration_in_national_security_defence_or_law_enforcement, false), attribute(critical_entity_under_directive_2022_2557, false), attribute(domain_name_registration_service_entity, false), attribute(exempted_from_dora_scope_by_member_state, false), attribute(identified_by_member_state_as_essential_entity, false), attribute(former_operator_of_essential_services_kept_essential_by_member_state, false)]).

overridden_item(Overrides, attribute(Key, Value), attribute(Key, NewValue)) :-
    override_value(Overrides, Key, Value, NewValue).

override_value([], _, Value, Value).
override_value([OverrideKey - OverrideValue|Overrides], Key, Value, NewValue) :-
    if_(OverrideKey = Key, NewValue = OverrideValue, override_value(Overrides, Key, Value, NewValue)).

kept_item_t(DroppedKeys, attribute(Key, _), Kept) :-
    memberd_t(Key, DroppedKeys, Dropped),
    kept_from_dropped(Dropped, Kept).

kept_from_dropped(true, false).
kept_from_dropped(false, true).

complete_subject(baseline_micro_outside_annexes, []).
complete_subject(size_micro_at_ceilings, [staff_headcount - 9, annual_turnover_eur - 2000000, annual_balance_sheet_total_eur - 2000000]).
complete_subject(size_micro_turnover_one_euro_over, [staff_headcount - 9, annual_turnover_eur - 2000001, annual_balance_sheet_total_eur - 2000001]).
complete_subject(size_micro_staff_one_over, [staff_headcount - 10, annual_turnover_eur - 2000000, annual_balance_sheet_total_eur - 2000000]).
complete_subject(size_small_at_ceiling, [staff_headcount - 49, annual_turnover_eur - 10000000, annual_balance_sheet_total_eur - 20000000]).
complete_subject(size_small_turnover_one_euro_over, [staff_headcount - 49, annual_turnover_eur - 10000001, annual_balance_sheet_total_eur - 20000000]).
complete_subject(size_small_staff_one_over, [staff_headcount - 50, annual_turnover_eur - 10000000, annual_balance_sheet_total_eur - 20000000]).
complete_subject(size_medium_at_turnover_ceiling, [staff_headcount - 249, annual_turnover_eur - 50000000, annual_balance_sheet_total_eur - 43000001]).
complete_subject(size_medium_turnover_one_euro_over, [staff_headcount - 249, annual_turnover_eur - 50000001, annual_balance_sheet_total_eur - 43000001]).
complete_subject(size_medium_at_balance_sheet_ceiling, [staff_headcount - 249, annual_turnover_eur - 50000001, annual_balance_sheet_total_eur - 43000000]).
complete_subject(size_medium_staff_one_over, [staff_headcount - 250, annual_turnover_eur - 50000000, annual_balance_sheet_total_eur - 43000001]).
complete_subject(size_rule_medium_annex_one, [annex_i_type - true, staff_headcount - 49, annual_turnover_eur - 10000001, annual_balance_sheet_total_eur - 20000000]).
complete_subject(size_rule_small_annex_one, [annex_i_type - true, staff_headcount - 49, annual_turnover_eur - 10000000, annual_balance_sheet_total_eur - 20000000]).
complete_subject(size_rule_outside_union, [annex_i_type - true, services_or_activities_in_union - false, staff_headcount - 49, annual_turnover_eur - 10000001, annual_balance_sheet_total_eur - 20000000]).
complete_subject(large_annex_one_essential, [annex_i_type - true, staff_headcount - 100, annual_turnover_eur - 50000001, annual_balance_sheet_total_eur - 43000001]).
complete_subject(medium_annex_one_at_turnover_ceiling, [annex_i_type - true, staff_headcount - 100, annual_turnover_eur - 50000000, annual_balance_sheet_total_eur - 43000001]).
complete_subject(large_annex_two_important, [annex_ii_type - true, staff_headcount - 100, annual_turnover_eur - 50000001, annual_balance_sheet_total_eur - 43000001]).
complete_subject(critical_entity, [critical_entity_under_directive_2022_2557 - true]).
complete_subject(domain_name_registration, [domain_name_registration_service_entity - true]).
complete_subject(electronic_communications_micro_annex_one, [annex_i_type - true, public_electronic_communications_provider - true]).
complete_subject(electronic_communications_outside_annexes, [public_electronic_communications_provider - true]).
complete_subject(electronic_communications_medium_annex_two, [annex_ii_type - true, public_electronic_communications_provider - true, staff_headcount - 49, annual_turnover_eur - 10000001, annual_balance_sheet_total_eur - 20000000]).
complete_subject(electronic_communications_small_annex_two, [annex_ii_type - true, public_electronic_communications_provider - true, staff_headcount - 49, annual_turnover_eur - 10000000, annual_balance_sheet_total_eur - 20000000]).
complete_subject(unsure_annex_one_communications, [annex_i_type - unsure, public_electronic_communications_provider - true]).
complete_subject(qualified_trust_service_annex_two, [annex_ii_type - true, trust_service_provider_status - qualified_trust_service_provider]).
complete_subject(non_qualified_trust_service_annex_two, [annex_ii_type - true, trust_service_provider_status - non_qualified_trust_service_provider]).
complete_subject(qualified_trust_service_outside_annexes, [trust_service_provider_status - qualified_trust_service_provider]).
complete_subject(top_level_domain_registry_annex_one, [annex_i_type - true, tld_name_registry - true]).
complete_subject(domain_name_system_annex_two, [annex_ii_type - true, dns_service_provider - true]).
complete_subject(sole_provider_annex_one, [annex_i_type - true, sole_provider_of_an_essential_service_in_a_member_state - true]).
complete_subject(sole_provider_denied_annex_one, [annex_i_type - true]).
complete_subject(public_safety_impact_annex_two, [annex_ii_type - true, disruption_could_significantly_impact_public_safety_security_or_health - true]).
complete_subject(systemic_risk_annex_one, [annex_i_type - true, disruption_could_induce_a_significant_systemic_risk - true]).
complete_subject(specific_importance_annex_two, [annex_ii_type - true, critical_by_specific_national_or_regional_importance - true]).
complete_subject(central_government_annex_one, [annex_i_type - true, public_administration_kind - central_government]).
complete_subject(regional_administration_annex_one, [annex_i_type - true, public_administration_kind - regional_with_risk_assessed_services]).
complete_subject(other_public_administration_annex_one, [annex_i_type - true, public_administration_kind - other_public_administration]).
complete_subject(national_security_administration_critical_entity, [public_administration_in_national_security_defence_or_law_enforcement - true, critical_entity_under_directive_2022_2557 - true]).
complete_subject(national_security_trust_service_critical_entity, [public_administration_in_national_security_defence_or_law_enforcement - true, trust_service_provider_status - non_qualified_trust_service_provider, critical_entity_under_directive_2022_2557 - true]).
complete_subject(resilience_exempted_critical_entity, [exempted_from_dora_scope_by_member_state - true, critical_entity_under_directive_2022_2557 - true]).
complete_subject(member_state_identified_essential_annex_one, [annex_i_type - true, sole_provider_of_an_essential_service_in_a_member_state - true, identified_by_member_state_as_essential_entity - true]).
complete_subject(former_operator_kept_essential_annex_one, [annex_i_type - true, sole_provider_of_an_essential_service_in_a_member_state - true, former_operator_of_essential_services_kept_essential_by_member_state - true]).
complete_subject(identified_outside_annexes_registration, [domain_name_registration_service_entity - true, identified_by_member_state_as_essential_entity - true]).

partial_subject(partial_exempted_only, [exempted_from_dora_scope_by_member_state - true], [staff_headcount]).
partial_subject(partial_figures_above_ceilings, [annual_turnover_eur - 60000000, annual_balance_sheet_total_eur - 50000000], [staff_headcount]).
partial_subject(partial_balance_sheet_only, [annual_balance_sheet_total_eur - 5000000], [staff_headcount, annual_turnover_eur]).
partial_subject(partial_annex_one_only, [annex_i_type - true, sole_provider_of_an_essential_service_in_a_member_state - true], [exempted_from_dora_scope_by_member_state]).
partial_subject(partial_critical_entity_without_exclusions, [critical_entity_under_directive_2022_2557 - true], [services_or_activities_in_union]).

partial_profile(input_unknown_key, [attribute(colour, red)]).
partial_profile(input_negative_headcount, [attribute(staff_headcount, -1)]).

nis2_scope_entity_class_assess(Subject, Result) :-
    nis2_scope_entity_class_profile_for(Subject, Profile),
    decide_nis2_scope_entity_class(Profile, Result).

test(every_override_names_a_contract_key) :-
    nis2_scope_entity_class_profile_key_order(ContractKeys),
    findall(Key, (complete_subject(_, Overrides), member(Key - _, Overrides)), OverrideKeys),
    subtract(OverrideKeys, ContractKeys, Strangers),
    Strangers == [].
test(every_partial_override_and_drop_names_a_contract_key) :-
    nis2_scope_entity_class_profile_key_order(ContractKeys),
    findall(Key, (partial_subject(_, Overrides, _), member(Key - _, Overrides)), OverrideKeys),
    findall(Key, (partial_subject(_, _, Dropped), member(Key, Dropped)), DroppedKeys),
    append(OverrideKeys, DroppedKeys, NamedKeys),
    subtract(NamedKeys, ContractKeys, Strangers),
    Strangers == [].
test(every_complete_subject_is_well_formed) :-
    findall(Profile, (complete_subject(Subject, _), nis2_scope_entity_class_profile_for(Subject, Profile)), Profiles),
    Profiles = [_|_],
    maplist(well_formed_complete, Profiles).
test(every_partial_subject_is_well_formed) :-
    findall(Profile, (partial_subject(Subject, _, _), nis2_scope_entity_class_profile_for(Subject, Profile)), Profiles),
    Profiles = [_|_],
    maplist(well_formed_partial, Profiles).
test(subject_names_are_unique) :-
    findall(Subject, nis2_scope_entity_class_subject(Subject), Subjects),
    sort(Subjects, Unique),
    same_length(Subjects, Unique).

well_formed_complete(Profile) :-
    length(Profile, 21),
    nis2_scope_entity_class_input_problems(Profile, []).

well_formed_partial(Profile) :-
    length(Profile, Length),
    Length >= 19,
    nis2_scope_entity_class_input_problems(Profile, []).
