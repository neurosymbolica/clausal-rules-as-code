% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_ict_third_party_entity_duties_tests_test_queries, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_dora_ict_third_party_entity_duties_queries, [dora_ict_third_party_entity_duties_profile_keys/1, dora_ict_third_party_entity_duties_what_if/4, supports_critical_or_important_function/0, financial_entity_is_article_16_1_entity/0, assessment_of_critical_or_important_function/0, consideration_of_third_country_data_protection_and_enforcement/0, unsure/0]).
:- use_module(m__eu_dora_ict_third_party_entity_duties_kernel, [dora_ict_third_party_entity_duties_input_problems/2]).
:- use_module(m__eu_dora_ict_third_party_entity_duties_fixtures, [dora_ict_third_party_entity_duties_profile_for/2]).

subject_profile(Subject, Profile) :-
    dora_ict_third_party_entity_duties_profile_for(Subject, Profile).

test(profile_keys_are_the_contract_keys) :-
    dora_ict_third_party_entity_duties_profile_keys(ProfileKeys),
    ProfileKeys == [assessed_whether_arrangement_supports_critical_or_important_function, assessed_supervisory_conditions_for_contracting, identified_and_assessed_relevant_risks, undertook_due_diligence_on_provider, identified_and_assessed_conflicts_of_interest, provider_complies_with_appropriate_information_security_standards, entity_exercises_access_inspection_and_audit_rights, audit_frequency_and_areas_predetermined, arrangement_entails_high_technical_complexity, auditor_skills_and_knowledge_verified, supports_critical_or_important_function, considered_most_up_to_date_information_security_standards, exit_strategy_in_place, able_to_exit_without_business_disruption, able_to_exit_without_limiting_regulatory_compliance, able_to_exit_without_detriment_to_client_services, exit_plans_comprehensive_documented_tested_and_reviewed, alternative_solutions_and_transition_plans_in_place, contingency_measures_in_place, considered_concentration_risk, weighed_alternative_solutions, considered_insolvency_law_and_data_recovery_constraints, arrangement_allows_further_subcontracting, weighed_subcontracting_benefits_and_risks, assessed_impact_of_subcontracting_chains, provider_established_in_third_country, considered_third_country_data_protection_and_enforcement, financial_entity_is_article_16_1_entity, financial_entity_is_microenterprise].
test(what_if_a_union_provider_moves_to_a_third_country) :-
    subject_profile(union_provider_data_protection_not_considered, Profile),
    findall(Status, dora_ict_third_party_entity_duties_what_if(Profile, provider_established_in_third_country, true, Status), Statuses),
    Statuses == [incomplete].
test(what_if_the_provider_stays_in_the_union) :-
    subject_profile(union_provider_data_protection_not_considered, Profile),
    findall(Status, dora_ict_third_party_entity_duties_what_if(Profile, provider_established_in_third_country, false, Status), Statuses),
    Statuses == [complete].
test(what_if_the_plain_arrangement_supports_a_critical_function) :-
    subject_profile(plain_arrangement_complete, Profile),
    findall(Status, dora_ict_third_party_entity_duties_what_if(Profile, supports_critical_or_important_function, true, Status), Statuses),
    Statuses == [indeterminate([considered_most_up_to_date_information_security_standards])].
test(what_if_the_exit_strategy_is_performed) :-
    subject_profile(critical_arrangement_exit_strategy_not_performed, Profile),
    findall(Status, dora_ict_third_party_entity_duties_what_if(Profile, exit_strategy_in_place, true, Status), Statuses),
    Statuses == [complete].
test(what_if_resolves_a_duplicate_key) :-
    subject_profile(duplicate_key_profile, Profile),
    findall(Status, dora_ict_third_party_entity_duties_what_if(Profile, exit_strategy_in_place, true, Status), Statuses),
    Statuses == [indeterminate([assessed_whether_arrangement_supports_critical_or_important_function])].
test(what_if_keeps_a_malformed_profile_refused) :-
    subject_profile(non_attribute_profile, Profile),
    findall(Status, dora_ict_third_party_entity_duties_what_if(Profile, exit_strategy_in_place, true, Status), Statuses),
    Statuses == [input_problems([wrong_type(profile)])].
test(input_check_is_re_exported) :-
    subject_profile(numeric_key_profile, Profile),
    dora_ict_third_party_entity_duties_input_problems(Profile, [unknown_key(42)]).
test(root_export_atoms_are_served) :-
    supports_critical_or_important_function,
    financial_entity_is_article_16_1_entity,
    assessment_of_critical_or_important_function,
    consideration_of_third_country_data_protection_and_enforcement,
    unsure.

test(what_if_the_exit_strategy_stays_unperformed_is_not_complete, fail) :-
    subject_profile(critical_arrangement_exit_strategy_not_performed, Profile),
    dora_ict_third_party_entity_duties_what_if(Profile, exit_strategy_in_place, false, complete).

cp_test_names([profile_keys_are_the_contract_keys, what_if_a_union_provider_moves_to_a_third_country, what_if_the_provider_stays_in_the_union, what_if_the_plain_arrangement_supports_a_critical_function, what_if_the_exit_strategy_is_performed, what_if_resolves_a_duplicate_key, what_if_keeps_a_malformed_profile_refused, input_check_is_re_exported, root_export_atoms_are_served]).
cp_test_fail_names([what_if_the_exit_strategy_stays_unperformed_is_not_complete]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
