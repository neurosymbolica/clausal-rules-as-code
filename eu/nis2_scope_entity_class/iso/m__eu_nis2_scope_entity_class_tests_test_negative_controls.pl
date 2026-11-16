% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_nis2_scope_entity_class_tests_test_negative_controls, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_nis2_scope_entity_class_nis2_scope_entity_class, [nis2_scope_entity_class_status/2, nis2_scope_entity_class_status_values/1, scope_decision/3, entity_class/3]).
:- use_module(m__eu_nis2_scope_entity_class_fixtures, [nis2_scope_entity_class_profile_for/2]).

scope_of(Subject, Result) :-
    nis2_scope_entity_class_profile_for(Subject, Profile),
    scope_decision(Profile, Result, _).

class_of(Subject, Class) :-
    nis2_scope_entity_class_profile_for(Subject, Profile),
    entity_class(Profile, Class, _).

test(the_near_miss_verdict_is_a_real_verdict_atom) :-
    nis2_scope_entity_class_status_values(StatusValues),
    member(ineligible, StatusValues),
    member(eligible, StatusValues).
test(the_baseline_profile_is_ineligible) :-
    nis2_scope_entity_class_profile_for(baseline_out_of_scope, Profile),
    nis2_scope_entity_class_status(Profile, ineligible).
test(g1_critical_entity_in_scope) :-
    scope_of(critical_entity, in_scope).
test(g1_without_it_out_of_scope) :-
    scope_of(baseline_out_of_scope, out_of_scope).
test(g2_registrar_in_scope) :-
    scope_of(domain_registrar, in_scope).
test(g3_communications_provider_in_scope) :-
    scope_of(electronic_communications_micro, in_scope).
test(g3_non_provider_out_of_scope) :-
    scope_of(electronic_communications_not_provider, out_of_scope).
test(g4_non_qualified_trust_in_scope) :-
    scope_of(non_qualified_trust_provider, in_scope).
test(g5_tld_registry_in_scope) :-
    scope_of(tld_registry, in_scope).
test(g6_dns_provider_in_scope) :-
    scope_of(dns_provider, in_scope).
test(g456_without_annex_type_out_of_scope) :-
    scope_of(micro_at_ceiling, out_of_scope).
test(g7_sole_provider_in_scope) :-
    scope_of(sole_provider, in_scope).
test(g7_without_annex_type_out_of_scope) :-
    scope_of(sole_provider_without_annex_type, out_of_scope).
test(g8_safety_disruption_in_scope) :-
    scope_of(safety_disruption, in_scope).
test(g9_systemic_risk_in_scope) :-
    scope_of(systemic_risk, in_scope).
test(g10_national_importance_in_scope) :-
    scope_of(national_importance, in_scope).
test(g11_central_government_in_scope) :-
    scope_of(central_government, in_scope).
test(g12_regional_government_in_scope) :-
    scope_of(regional_government, in_scope).
test(g11_other_public_administration_out_of_scope) :-
    scope_of(other_public_administration, out_of_scope).
test(g13_staff_fifty_in_scope) :-
    scope_of(medium_annex_at_staff_floor, in_scope).
test(g13_staff_forty_nine_out_of_scope) :-
    scope_of(small_annex_just_below, out_of_scope).
test(g13_both_financials_over_in_scope) :-
    scope_of(small_annex_one_euro_over_both, in_scope).
test(g13_one_financial_over_out_of_scope) :-
    scope_of(small_annex_one_figure_over, out_of_scope).
test(x1_national_security_out_of_scope) :-
    scope_of(national_security_exclusion, out_of_scope).
test(x1_trust_provider_is_not_excluded) :-
    scope_of(national_security_trust_provider, in_scope).
test(x2_dora_exemption_out_of_scope) :-
    scope_of(dora_exemption, out_of_scope).
test(x2_without_exemption_in_scope) :-
    scope_of(critical_entity, in_scope).
test(e1_large_annex_i_essential) :-
    class_of(large_annex_by_staff, essential_entity).
test(e1_medium_annex_i_important) :-
    class_of(medium_annex_staff_just_below_large, important_entity).
test(e1_large_by_financials_essential) :-
    class_of(large_annex_by_financials, essential_entity).
test(e1_one_financial_at_ceiling_important) :-
    class_of(medium_annex_one_figure_at_ceiling, important_entity).
test(e2_qualified_essential) :-
    class_of(qualified_trust_provider, essential_entity).
test(e2_non_qualified_important) :-
    class_of(non_qualified_trust_provider, important_entity).
test(e3_tld_essential) :-
    class_of(tld_registry, essential_entity).
test(e4_dns_essential) :-
    class_of(dns_provider, essential_entity).
test(e5_medium_communications_essential) :-
    class_of(electronic_communications_medium, essential_entity).
test(e5_micro_communications_important) :-
    class_of(electronic_communications_micro, important_entity).
test(e6_central_government_essential) :-
    class_of(central_government, essential_entity).
test(e6_regional_government_important) :-
    class_of(regional_government, important_entity).
test(e7_identified_essential) :-
    class_of(identified_essential, essential_entity).
test(e7_not_identified_important) :-
    class_of(sole_provider, important_entity).
test(e8_critical_essential) :-
    class_of(critical_entity, essential_entity).
test(e8_registrar_important) :-
    class_of(domain_registrar, important_entity).
test(e9_former_operator_essential) :-
    class_of(former_operator_essential, essential_entity).
test(e9_without_it_important) :-
    class_of(sole_provider, important_entity).
test(unsure_sole_provider_needs_review) :-
    scope_of(unsure_sole_provider, needs_legal_review(_, _)).
test(sure_sole_provider_is_a_final_answer) :-
    scope_of(sole_provider, in_scope).
test(missing_exclusion_keys_are_indeterminate) :-
    scope_of(empty_profile, indeterminate(_)).

test(the_baseline_profile_is_not_eligible, fail) :-
    nis2_scope_entity_class_profile_for(baseline_out_of_scope, Profile),
    nis2_scope_entity_class_status(Profile, eligible).
test(g1_without_it_not_in_scope, fail) :-
    scope_of(baseline_out_of_scope, in_scope).
test(g2_registrar_is_not_out_of_scope, fail) :-
    scope_of(domain_registrar, out_of_scope).
test(g3_non_provider_not_in_scope, fail) :-
    scope_of(electronic_communications_not_provider, in_scope).
test(g7_without_annex_type_not_in_scope, fail) :-
    scope_of(sole_provider_without_annex_type, in_scope).
test(g11_other_public_administration_not_in_scope, fail) :-
    scope_of(other_public_administration, in_scope).
test(g13_staff_forty_nine_not_in_scope, fail) :-
    scope_of(small_annex_just_below, in_scope).
test(g13_one_financial_over_not_in_scope, fail) :-
    scope_of(small_annex_one_figure_over, in_scope).
test(x1_trust_provider_not_out_of_scope, fail) :-
    scope_of(national_security_trust_provider, out_of_scope).
test(x1_exclusion_not_in_scope, fail) :-
    scope_of(national_security_exclusion, in_scope).
test(x2_exemption_not_in_scope, fail) :-
    scope_of(dora_exemption, in_scope).
test(e1_medium_not_essential, fail) :-
    class_of(medium_annex_staff_just_below_large, essential_entity).
test(e2_non_qualified_not_essential, fail) :-
    class_of(non_qualified_trust_provider, essential_entity).
test(e5_micro_not_essential, fail) :-
    class_of(electronic_communications_micro, essential_entity).
test(e6_regional_not_essential, fail) :-
    class_of(regional_government, essential_entity).
test(e7_not_identified_not_essential, fail) :-
    class_of(sole_provider, essential_entity).
test(e8_registrar_not_essential, fail) :-
    class_of(domain_registrar, essential_entity).
test(unsure_sole_provider_is_not_in_scope, fail) :-
    scope_of(unsure_sole_provider, in_scope).
test(unsure_sole_provider_is_not_out_of_scope, fail) :-
    scope_of(unsure_sole_provider, out_of_scope).
test(missing_exclusion_keys_are_not_in_scope, fail) :-
    scope_of(empty_profile, in_scope).

cp_test_names([the_near_miss_verdict_is_a_real_verdict_atom, the_baseline_profile_is_ineligible, g1_critical_entity_in_scope, g1_without_it_out_of_scope, g2_registrar_in_scope, g3_communications_provider_in_scope, g3_non_provider_out_of_scope, g4_non_qualified_trust_in_scope, g5_tld_registry_in_scope, g6_dns_provider_in_scope, g456_without_annex_type_out_of_scope, g7_sole_provider_in_scope, g7_without_annex_type_out_of_scope, g8_safety_disruption_in_scope, g9_systemic_risk_in_scope, g10_national_importance_in_scope, g11_central_government_in_scope, g12_regional_government_in_scope, g11_other_public_administration_out_of_scope, g13_staff_fifty_in_scope, g13_staff_forty_nine_out_of_scope, g13_both_financials_over_in_scope, g13_one_financial_over_out_of_scope, x1_national_security_out_of_scope, x1_trust_provider_is_not_excluded, x2_dora_exemption_out_of_scope, x2_without_exemption_in_scope, e1_large_annex_i_essential, e1_medium_annex_i_important, e1_large_by_financials_essential, e1_one_financial_at_ceiling_important, e2_qualified_essential, e2_non_qualified_important, e3_tld_essential, e4_dns_essential, e5_medium_communications_essential, e5_micro_communications_important, e6_central_government_essential, e6_regional_government_important, e7_identified_essential, e7_not_identified_important, e8_critical_essential, e8_registrar_important, e9_former_operator_essential, e9_without_it_important, unsure_sole_provider_needs_review, sure_sole_provider_is_a_final_answer, missing_exclusion_keys_are_indeterminate]).
cp_test_fail_names([the_baseline_profile_is_not_eligible, g1_without_it_not_in_scope, g2_registrar_is_not_out_of_scope, g3_non_provider_not_in_scope, g7_without_annex_type_not_in_scope, g11_other_public_administration_not_in_scope, g13_staff_forty_nine_not_in_scope, g13_one_financial_over_not_in_scope, x1_trust_provider_not_out_of_scope, x1_exclusion_not_in_scope, x2_exemption_not_in_scope, e1_medium_not_essential, e2_non_qualified_not_essential, e5_micro_not_essential, e6_regional_not_essential, e7_not_identified_not_essential, e8_registrar_not_essential, unsure_sole_provider_is_not_in_scope, unsure_sole_provider_is_not_out_of_scope, missing_exclusion_keys_are_not_in_scope]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
