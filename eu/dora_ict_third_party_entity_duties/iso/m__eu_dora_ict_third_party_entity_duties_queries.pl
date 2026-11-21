% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_ict_third_party_entity_duties_queries, [dora_ict_third_party_entity_duties_profile_keys/1, dora_ict_third_party_entity_duties_what_if/4, assessed_whether_arrangement_supports_critical_or_important_function/0, assessed_supervisory_conditions_for_contracting/0, identified_and_assessed_relevant_risks/0, undertook_due_diligence_on_provider/0, identified_and_assessed_conflicts_of_interest/0, provider_complies_with_appropriate_information_security_standards/0, entity_exercises_access_inspection_and_audit_rights/0, audit_frequency_and_areas_predetermined/0, arrangement_entails_high_technical_complexity/0, auditor_skills_and_knowledge_verified/0, supports_critical_or_important_function/0, considered_most_up_to_date_information_security_standards/0, exit_strategy_in_place/0, able_to_exit_without_business_disruption/0, able_to_exit_without_limiting_regulatory_compliance/0, able_to_exit_without_detriment_to_client_services/0, exit_plans_comprehensive_documented_tested_and_reviewed/0, alternative_solutions_and_transition_plans_in_place/0, contingency_measures_in_place/0, considered_concentration_risk/0, weighed_alternative_solutions/0, considered_insolvency_law_and_data_recovery_constraints/0, arrangement_allows_further_subcontracting/0, weighed_subcontracting_benefits_and_risks/0, assessed_impact_of_subcontracting_chains/0, provider_established_in_third_country/0, considered_third_country_data_protection_and_enforcement/0, financial_entity_is_article_16_1_entity/0, financial_entity_is_microenterprise/0, assessment_of_critical_or_important_function/0, assessment_of_supervisory_conditions/0, risk_identification_and_assessment/0, due_diligence_on_provider/0, conflicts_of_interest_assessment/0, provider_with_appropriate_information_security_standards/0, consideration_of_most_up_to_date_information_security_standards/0, predetermined_audit_frequency_and_areas/0, verification_of_auditor_skills/0, exit_strategy/0, exit_without_business_disruption/0, exit_without_limiting_regulatory_compliance/0, exit_without_detriment_to_client_services/0, tested_and_reviewed_exit_plans/0, alternative_solutions_and_transition_plans/0, contingency_measures/0, concentration_risk_consideration/0, weighing_of_alternative_solutions/0, weighing_of_subcontracting_benefits_and_risks/0, consideration_of_insolvency_law_and_data_recovery/0, consideration_of_third_country_data_protection_and_enforcement/0, assessment_of_subcontracting_chains/0, unsure/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_dora_ict_third_party_entity_duties_kernel, [dora_ict_third_party_entity_duties_input_problems/2]).
:- use_module(m__eu_dora_ict_third_party_entity_duties_dora_ict_third_party_entity_duties, [dora_ict_third_party_entity_duties_status/2]).

assessed_whether_arrangement_supports_critical_or_important_function.

assessed_supervisory_conditions_for_contracting.

identified_and_assessed_relevant_risks.

undertook_due_diligence_on_provider.

identified_and_assessed_conflicts_of_interest.

provider_complies_with_appropriate_information_security_standards.

entity_exercises_access_inspection_and_audit_rights.

audit_frequency_and_areas_predetermined.

arrangement_entails_high_technical_complexity.

auditor_skills_and_knowledge_verified.

supports_critical_or_important_function.

considered_most_up_to_date_information_security_standards.

exit_strategy_in_place.

able_to_exit_without_business_disruption.

able_to_exit_without_limiting_regulatory_compliance.

able_to_exit_without_detriment_to_client_services.

exit_plans_comprehensive_documented_tested_and_reviewed.

alternative_solutions_and_transition_plans_in_place.

contingency_measures_in_place.

considered_concentration_risk.

weighed_alternative_solutions.

considered_insolvency_law_and_data_recovery_constraints.

arrangement_allows_further_subcontracting.

weighed_subcontracting_benefits_and_risks.

assessed_impact_of_subcontracting_chains.

provider_established_in_third_country.

considered_third_country_data_protection_and_enforcement.

financial_entity_is_article_16_1_entity.

financial_entity_is_microenterprise.

assessment_of_critical_or_important_function.

assessment_of_supervisory_conditions.

risk_identification_and_assessment.

due_diligence_on_provider.

conflicts_of_interest_assessment.

provider_with_appropriate_information_security_standards.

consideration_of_most_up_to_date_information_security_standards.

predetermined_audit_frequency_and_areas.

verification_of_auditor_skills.

exit_strategy.

exit_without_business_disruption.

exit_without_limiting_regulatory_compliance.

exit_without_detriment_to_client_services.

tested_and_reviewed_exit_plans.

alternative_solutions_and_transition_plans.

contingency_measures.

concentration_risk_consideration.

weighing_of_alternative_solutions.

weighing_of_subcontracting_benefits_and_risks.

consideration_of_insolvency_law_and_data_recovery.

consideration_of_third_country_data_protection_and_enforcement.

assessment_of_subcontracting_chains.

unsure.

dora_ict_third_party_entity_duties_profile_keys([assessed_whether_arrangement_supports_critical_or_important_function, assessed_supervisory_conditions_for_contracting, identified_and_assessed_relevant_risks, undertook_due_diligence_on_provider, identified_and_assessed_conflicts_of_interest, provider_complies_with_appropriate_information_security_standards, entity_exercises_access_inspection_and_audit_rights, audit_frequency_and_areas_predetermined, arrangement_entails_high_technical_complexity, auditor_skills_and_knowledge_verified, supports_critical_or_important_function, considered_most_up_to_date_information_security_standards, exit_strategy_in_place, able_to_exit_without_business_disruption, able_to_exit_without_limiting_regulatory_compliance, able_to_exit_without_detriment_to_client_services, exit_plans_comprehensive_documented_tested_and_reviewed, alternative_solutions_and_transition_plans_in_place, contingency_measures_in_place, considered_concentration_risk, weighed_alternative_solutions, considered_insolvency_law_and_data_recovery_constraints, arrangement_allows_further_subcontracting, weighed_subcontracting_benefits_and_risks, assessed_impact_of_subcontracting_chains, provider_established_in_third_country, considered_third_country_data_protection_and_enforcement, financial_entity_is_article_16_1_entity, financial_entity_is_microenterprise]).

dora_ict_third_party_entity_duties_what_if(Profile, OverriddenKey, NewValue, NewStatus) :-
    dora_ict_third_party_entity_duties_input_problems(Profile, Problems),
    hypothesis_profile(Problems, Profile, OverriddenKey, NewValue, Hypothesis),
    dora_ict_third_party_entity_duties_status(Hypothesis, NewStatus).

hypothesis_profile([wrong_type(profile)], Profile, _, _, Profile).
hypothesis_profile(Problems, Profile, OverriddenKey, NewValue, Hypothesis) :-
    dif(Problems, [wrong_type(profile)]),
    override_attribute(Profile, OverriddenKey, NewValue, Hypothesis).

override_attribute([], Key, Value, [attribute(Key, Value)]).
override_attribute([attribute(ElementKey, _)|Elements], Key, Value, Overridden) :-
    ElementKey == Key,
    override_attribute(Elements, Key, Value, Overridden).
override_attribute([attribute(ElementKey, ElementValue)|Elements], Key, Value, [attribute(ElementKey, ElementValue)|Overridden]) :-
    ElementKey \== Key,
    override_attribute(Elements, Key, Value, Overridden).

plain_profile([attribute(assessed_whether_arrangement_supports_critical_or_important_function, true), attribute(assessed_supervisory_conditions_for_contracting, true), attribute(identified_and_assessed_relevant_risks, true), attribute(undertook_due_diligence_on_provider, true), attribute(identified_and_assessed_conflicts_of_interest, true), attribute(provider_complies_with_appropriate_information_security_standards, true), attribute(entity_exercises_access_inspection_and_audit_rights, false), attribute(supports_critical_or_important_function, false)]).

test(profile_keys_are_the_twenty_nine_contract_keys) :-
    dora_ict_third_party_entity_duties_profile_keys(Keys),
    length(Keys, 29).
test(override_replaces_a_present_key) :-
    override_attribute([attribute(exit_strategy_in_place, true)], exit_strategy_in_place, false, Overridden),
    Overridden == [attribute(exit_strategy_in_place, false)].
test(override_adds_an_absent_key) :-
    override_attribute([attribute(exit_strategy_in_place, true)], contingency_measures_in_place, true, Overridden),
    Overridden == [attribute(exit_strategy_in_place, true), attribute(contingency_measures_in_place, true)].
test(override_replaces_every_occurrence) :-
    override_attribute([attribute(exit_strategy_in_place, true), attribute(exit_strategy_in_place, false)], exit_strategy_in_place, unsure, Overridden),
    Overridden == [attribute(exit_strategy_in_place, unsure)].
test(what_if_a_duty_is_not_performed_gives_incomplete) :-
    plain_profile(Profile),
    findall(Status, dora_ict_third_party_entity_duties_what_if(Profile, assessed_supervisory_conditions_for_contracting, false, Status), Statuses),
    Statuses == [incomplete].
test(what_if_the_duty_stays_performed_gives_complete) :-
    plain_profile(Profile),
    findall(Status, dora_ict_third_party_entity_duties_what_if(Profile, assessed_supervisory_conditions_for_contracting, true, Status), Statuses),
    Statuses == [complete].
test(what_if_keeps_a_malformed_profile_refused) :-
    findall(Status, dora_ict_third_party_entity_duties_what_if(not_a_list, exit_strategy_in_place, true, Status), Statuses),
    Statuses == [input_problems([wrong_type(profile)])].
test(input_check_is_re_exported) :-
    dora_ict_third_party_entity_duties_input_problems([], []).
test(root_atoms_are_declared) :-
    supports_critical_or_important_function,
    financial_entity_is_microenterprise,
    exit_strategy,
    assessment_of_subcontracting_chains,
    unsure.

test(what_if_not_performed_is_not_complete, fail) :-
    plain_profile(Profile),
    dora_ict_third_party_entity_duties_what_if(Profile, assessed_supervisory_conditions_for_contracting, false, complete).
