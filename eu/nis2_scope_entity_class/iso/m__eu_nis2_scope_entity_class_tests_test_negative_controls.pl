% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_nis2_scope_entity_class_tests_test_negative_controls, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_nis2_scope_entity_class_nis2_scope_entity_class, [size_class/3, scope_decision/3, entity_class/3, nis2_scope_entity_class_status_values/1]).
:- use_module(m__eu_nis2_scope_entity_class_fixtures, [nis2_scope_entity_class_profile_for/2]).

size_of(Subject, Size) :-
    nis2_scope_entity_class_profile_for(Subject, Profile),
    size_class(Profile, Size, _).

scope_of(Subject, Result) :-
    nis2_scope_entity_class_profile_for(Subject, Profile),
    scope_decision(Profile, Result, _).

class_of(Subject, Class) :-
    nis2_scope_entity_class_profile_for(Subject, Profile),
    entity_class(Profile, Class, _).

test(the_near_miss_atoms_are_verdict_atoms) :-
    nis2_scope_entity_class_status_values(StatusValues),
    StatusValues == [essential_entity, important_entity, out_of_scope].
test(size_micro_positive) :-
    size_of(size_micro_at_ceilings, microenterprise).
test(size_micro_near_miss_is_small) :-
    size_of(size_micro_turnover_one_euro_over, small_enterprise).
test(size_medium_positive) :-
    size_of(size_medium_at_turnover_ceiling, medium_sized_enterprise).
test(size_medium_near_miss_is_large) :-
    size_of(size_medium_staff_one_over, large_enterprise).
test(exclusion_national_security_positive) :-
    scope_of(national_security_administration_critical_entity, out_of_scope).
test(exclusion_national_security_trust_service_near_miss) :-
    scope_of(national_security_trust_service_critical_entity, in_scope).
test(exclusion_dora_positive) :-
    scope_of(resilience_exempted_critical_entity, out_of_scope).
test(exclusion_dora_near_miss) :-
    scope_of(critical_entity, in_scope).
test(scope_critical_entity_positive) :-
    scope_of(critical_entity, in_scope).
test(scope_domain_name_registration_positive) :-
    scope_of(domain_name_registration, in_scope).
test(scope_baseline_near_miss) :-
    scope_of(baseline_micro_outside_annexes, out_of_scope).
test(scope_electronic_communications_positive) :-
    scope_of(electronic_communications_micro_annex_one, in_scope).
test(scope_electronic_communications_near_miss) :-
    scope_of(electronic_communications_outside_annexes, out_of_scope).
test(scope_trust_service_positive) :-
    scope_of(non_qualified_trust_service_annex_two, in_scope).
test(scope_trust_service_near_miss) :-
    scope_of(qualified_trust_service_outside_annexes, out_of_scope).
test(scope_top_level_domain_registry_positive) :-
    scope_of(top_level_domain_registry_annex_one, in_scope).
test(scope_domain_name_system_positive) :-
    scope_of(domain_name_system_annex_two, in_scope).
test(scope_sole_provider_positive) :-
    scope_of(sole_provider_annex_one, in_scope).
test(scope_public_safety_impact_positive) :-
    scope_of(public_safety_impact_annex_two, in_scope).
test(scope_systemic_risk_positive) :-
    scope_of(systemic_risk_annex_one, in_scope).
test(scope_specific_importance_positive) :-
    scope_of(specific_importance_annex_two, in_scope).
test(scope_annex_type_without_a_point_near_miss) :-
    scope_of(sole_provider_denied_annex_one, out_of_scope).
test(scope_central_government_positive) :-
    scope_of(central_government_annex_one, in_scope).
test(scope_regional_administration_positive) :-
    scope_of(regional_administration_annex_one, in_scope).
test(scope_other_public_administration_near_miss) :-
    scope_of(other_public_administration_annex_one, out_of_scope).
test(scope_size_rule_positive) :-
    scope_of(size_rule_medium_annex_one, in_scope).
test(scope_size_rule_small_near_miss) :-
    scope_of(size_rule_small_annex_one, out_of_scope).
test(scope_size_rule_outside_union_near_miss) :-
    scope_of(size_rule_outside_union, out_of_scope).
test(class_large_annex_one_positive) :-
    class_of(large_annex_one_essential, essential_entity).
test(class_medium_annex_one_near_miss) :-
    class_of(medium_annex_one_at_turnover_ceiling, important_entity).
test(class_large_annex_two_near_miss) :-
    class_of(large_annex_two_important, important_entity).
test(class_qualified_trust_service_positive) :-
    class_of(qualified_trust_service_annex_two, essential_entity).
test(class_non_qualified_trust_service_near_miss) :-
    class_of(non_qualified_trust_service_annex_two, important_entity).
test(class_top_level_domain_registry_positive) :-
    class_of(top_level_domain_registry_annex_one, essential_entity).
test(class_domain_name_system_positive) :-
    class_of(domain_name_system_annex_two, essential_entity).
test(class_former_operator_positive) :-
    class_of(former_operator_kept_essential_annex_one, essential_entity).
test(class_sole_provider_near_miss) :-
    class_of(sole_provider_annex_one, important_entity).
test(class_medium_electronic_communications_positive) :-
    class_of(electronic_communications_medium_annex_two, essential_entity).
test(class_small_electronic_communications_near_miss) :-
    class_of(electronic_communications_small_annex_two, important_entity).
test(class_central_government_positive) :-
    class_of(central_government_annex_one, essential_entity).
test(class_regional_administration_near_miss) :-
    class_of(regional_administration_annex_one, important_entity).
test(class_member_state_identified_positive) :-
    class_of(member_state_identified_essential_annex_one, essential_entity).
test(class_identified_outside_annexes_near_miss) :-
    class_of(identified_outside_annexes_registration, important_entity).
test(class_critical_entity_positive) :-
    class_of(critical_entity, essential_entity).
test(class_domain_name_registration_near_miss) :-
    class_of(domain_name_registration, important_entity).
test(referral_positive) :-
    scope_of(unsure_annex_one_communications, needs_legal_review(open_textured(annex_i_type, cite(eu_dir_2022_2555_art_2_1)), _)).
test(referral_near_miss_decided_annex_type) :-
    scope_of(electronic_communications_micro_annex_one, in_scope).
test(missing_key_positive) :-
    scope_of(partial_annex_one_only, indeterminate([exempted_from_dora_scope_by_member_state])).
test(input_problem_positive) :-
    class_of(input_unknown_key, input_problems([unknown_key(colour)])).

test(size_micro_near_miss_is_not_micro, fail) :-
    size_of(size_micro_turnover_one_euro_over, microenterprise).
test(size_medium_near_miss_is_not_medium, fail) :-
    size_of(size_medium_staff_one_over, medium_sized_enterprise).
test(exclusion_national_security_trust_service_is_not_excluded, fail) :-
    scope_of(national_security_trust_service_critical_entity, out_of_scope).
test(exclusion_dora_near_miss_is_not_excluded, fail) :-
    scope_of(critical_entity, out_of_scope).
test(scope_baseline_is_not_in_scope, fail) :-
    scope_of(baseline_micro_outside_annexes, in_scope).
test(scope_electronic_communications_near_miss_is_not_in_scope, fail) :-
    scope_of(electronic_communications_outside_annexes, in_scope).
test(scope_trust_service_near_miss_is_not_in_scope, fail) :-
    scope_of(qualified_trust_service_outside_annexes, in_scope).
test(scope_annex_type_without_a_point_is_not_in_scope, fail) :-
    scope_of(sole_provider_denied_annex_one, in_scope).
test(scope_other_public_administration_is_not_in_scope, fail) :-
    scope_of(other_public_administration_annex_one, in_scope).
test(scope_size_rule_small_is_not_in_scope, fail) :-
    scope_of(size_rule_small_annex_one, in_scope).
test(scope_size_rule_outside_union_is_not_in_scope, fail) :-
    scope_of(size_rule_outside_union, in_scope).
test(class_medium_annex_one_is_not_essential, fail) :-
    class_of(medium_annex_one_at_turnover_ceiling, essential_entity).
test(class_large_annex_two_is_not_essential, fail) :-
    class_of(large_annex_two_important, essential_entity).
test(class_non_qualified_trust_service_is_not_essential, fail) :-
    class_of(non_qualified_trust_service_annex_two, essential_entity).
test(class_sole_provider_is_not_essential, fail) :-
    class_of(sole_provider_annex_one, essential_entity).
test(class_small_electronic_communications_is_not_essential, fail) :-
    class_of(electronic_communications_small_annex_two, essential_entity).
test(class_regional_administration_is_not_essential, fail) :-
    class_of(regional_administration_annex_one, essential_entity).
test(class_identified_outside_annexes_is_not_essential, fail) :-
    class_of(identified_outside_annexes_registration, essential_entity).
test(class_domain_name_registration_is_not_essential, fail) :-
    class_of(domain_name_registration, essential_entity).
test(referral_is_not_in_scope, fail) :-
    scope_of(unsure_annex_one_communications, in_scope).
test(missing_key_is_not_in_scope, fail) :-
    scope_of(partial_annex_one_only, in_scope).
test(input_problem_is_not_out_of_scope, fail) :-
    class_of(input_unknown_key, out_of_scope).

cp_test_names([the_near_miss_atoms_are_verdict_atoms, size_micro_positive, size_micro_near_miss_is_small, size_medium_positive, size_medium_near_miss_is_large, exclusion_national_security_positive, exclusion_national_security_trust_service_near_miss, exclusion_dora_positive, exclusion_dora_near_miss, scope_critical_entity_positive, scope_domain_name_registration_positive, scope_baseline_near_miss, scope_electronic_communications_positive, scope_electronic_communications_near_miss, scope_trust_service_positive, scope_trust_service_near_miss, scope_top_level_domain_registry_positive, scope_domain_name_system_positive, scope_sole_provider_positive, scope_public_safety_impact_positive, scope_systemic_risk_positive, scope_specific_importance_positive, scope_annex_type_without_a_point_near_miss, scope_central_government_positive, scope_regional_administration_positive, scope_other_public_administration_near_miss, scope_size_rule_positive, scope_size_rule_small_near_miss, scope_size_rule_outside_union_near_miss, class_large_annex_one_positive, class_medium_annex_one_near_miss, class_large_annex_two_near_miss, class_qualified_trust_service_positive, class_non_qualified_trust_service_near_miss, class_top_level_domain_registry_positive, class_domain_name_system_positive, class_former_operator_positive, class_sole_provider_near_miss, class_medium_electronic_communications_positive, class_small_electronic_communications_near_miss, class_central_government_positive, class_regional_administration_near_miss, class_member_state_identified_positive, class_identified_outside_annexes_near_miss, class_critical_entity_positive, class_domain_name_registration_near_miss, referral_positive, referral_near_miss_decided_annex_type, missing_key_positive, input_problem_positive]).
cp_test_fail_names([size_micro_near_miss_is_not_micro, size_medium_near_miss_is_not_medium, exclusion_national_security_trust_service_is_not_excluded, exclusion_dora_near_miss_is_not_excluded, scope_baseline_is_not_in_scope, scope_electronic_communications_near_miss_is_not_in_scope, scope_trust_service_near_miss_is_not_in_scope, scope_annex_type_without_a_point_is_not_in_scope, scope_other_public_administration_is_not_in_scope, scope_size_rule_small_is_not_in_scope, scope_size_rule_outside_union_is_not_in_scope, class_medium_annex_one_is_not_essential, class_large_annex_two_is_not_essential, class_non_qualified_trust_service_is_not_essential, class_sole_provider_is_not_essential, class_small_electronic_communications_is_not_essential, class_regional_administration_is_not_essential, class_identified_outside_annexes_is_not_essential, class_domain_name_registration_is_not_essential, referral_is_not_in_scope, missing_key_is_not_in_scope, input_problem_is_not_out_of_scope]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
