% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_ict_third_party_entity_duties_fixtures, [dora_ict_third_party_entity_duties_subject/1, dora_ict_third_party_entity_duties_profile_for/2, dora_ict_third_party_entity_duties_assess/2]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_dora_ict_third_party_entity_duties_dora_ict_third_party_entity_duties, [decide_dora_ict_third_party_entity_duties/2]).

dora_ict_third_party_entity_duties_subject(plain_arrangement_complete).
dora_ict_third_party_entity_duties_subject(plain_arrangement_supervisory_assessment_not_performed).
dora_ict_third_party_entity_duties_subject(audit_arrangement_complete).
dora_ict_third_party_entity_duties_subject(audit_arrangement_frequency_not_predetermined).
dora_ict_third_party_entity_duties_subject(complex_audit_arrangement_complete).
dora_ict_third_party_entity_duties_subject(complex_audit_arrangement_auditor_skills_not_verified).
dora_ict_third_party_entity_duties_subject(critical_arrangement_complete).
dora_ict_third_party_entity_duties_subject(critical_arrangement_exit_strategy_not_performed).
dora_ict_third_party_entity_duties_subject(critical_arrangement_exit_strategy_not_performed_concentration_unanswered).
dora_ict_third_party_entity_duties_subject(critical_arrangement_exit_strategy_unanswered).
dora_ict_third_party_entity_duties_subject(critical_arrangement_exit_strategy_not_performed_complexity_unanswered).
dora_ict_third_party_entity_duties_subject(critical_arrangement_complexity_unanswered).
dora_ict_third_party_entity_duties_subject(critical_judgement_unsure_dependent_duty_not_performed).
dora_ict_third_party_entity_duties_subject(critical_judgement_true_dependent_duty_not_performed).
dora_ict_third_party_entity_duties_subject(third_country_provider_data_protection_not_considered).
dora_ict_third_party_entity_duties_subject(union_provider_data_protection_not_considered).
dora_ict_third_party_entity_duties_subject(subcontracting_arrangement_chains_not_assessed).
dora_ict_third_party_entity_duties_subject(no_subcontracting_arrangement_chains_not_assessed).
dora_ict_third_party_entity_duties_subject(empty_profile).
dora_ict_third_party_entity_duties_subject(article_16_entity).
dora_ict_third_party_entity_duties_subject(microenterprise_entity).
dora_ict_third_party_entity_duties_subject(entity_exemption_unanswered).
dora_ict_third_party_entity_duties_subject(duplicate_key_profile).
dora_ict_third_party_entity_duties_subject(single_key_profile).
dora_ict_third_party_entity_duties_subject(fact_given_unsure_profile).
dora_ict_third_party_entity_duties_subject(judgement_given_unsure_profile).
dora_ict_third_party_entity_duties_subject(unknown_key_profile).
dora_ict_third_party_entity_duties_subject(numeric_key_profile).
dora_ict_third_party_entity_duties_subject(mixed_problems_profile).
dora_ict_third_party_entity_duties_subject(non_attribute_profile).

dora_ict_third_party_entity_duties_profile_for(Subject, Profile) :-
    subject_pairs(Subject, Pairs),
    pairs_profile(Pairs, Profile).
dora_ict_third_party_entity_duties_profile_for(Subject, Profile) :-
    raw_profile(Subject, Profile).

pairs_profile(Pairs, Profile) :-
    maplist(pair_attribute, Pairs, Profile).

pair_attribute(Key - Value, attribute(Key, Value)).

raw_profile(non_attribute_profile, [not_an_attribute]).

six_duties_performed([assessed_whether_arrangement_supports_critical_or_important_function - true, assessed_supervisory_conditions_for_contracting - true, identified_and_assessed_relevant_risks - true, undertook_due_diligence_on_provider - true, identified_and_assessed_conflicts_of_interest - true, provider_complies_with_appropriate_information_security_standards - true]).

entity_not_exempt([financial_entity_is_article_16_1_entity - false, financial_entity_is_microenterprise - false]).

plain_pairs(Pairs) :-
    six_duties_performed(Duties),
    entity_not_exempt(Entity),
    append([Duties, [entity_exercises_access_inspection_and_audit_rights - false, supports_critical_or_important_function - false], Entity], Pairs).

audit_pairs(Pairs) :-
    six_duties_performed(Duties),
    entity_not_exempt(Entity),
    append([Duties, [entity_exercises_access_inspection_and_audit_rights - true, audit_frequency_and_areas_predetermined - true, arrangement_entails_high_technical_complexity - false, supports_critical_or_important_function - false], Entity], Pairs).

complex_audit_pairs(Pairs) :-
    six_duties_performed(Duties),
    entity_not_exempt(Entity),
    append([Duties, [entity_exercises_access_inspection_and_audit_rights - true, audit_frequency_and_areas_predetermined - true, arrangement_entails_high_technical_complexity - true, auditor_skills_and_knowledge_verified - true, supports_critical_or_important_function - false], Entity], Pairs).

critical_pairs([assessed_whether_arrangement_supports_critical_or_important_function - true, assessed_supervisory_conditions_for_contracting - true, identified_and_assessed_relevant_risks - true, undertook_due_diligence_on_provider - true, identified_and_assessed_conflicts_of_interest - true, provider_complies_with_appropriate_information_security_standards - true, entity_exercises_access_inspection_and_audit_rights - true, audit_frequency_and_areas_predetermined - true, arrangement_entails_high_technical_complexity - true, auditor_skills_and_knowledge_verified - true, supports_critical_or_important_function - true, considered_most_up_to_date_information_security_standards - true, exit_strategy_in_place - true, able_to_exit_without_business_disruption - true, able_to_exit_without_limiting_regulatory_compliance - true, able_to_exit_without_detriment_to_client_services - true, exit_plans_comprehensive_documented_tested_and_reviewed - true, alternative_solutions_and_transition_plans_in_place - true, contingency_measures_in_place - true, considered_concentration_risk - true, weighed_alternative_solutions - true, considered_insolvency_law_and_data_recovery_constraints - true, arrangement_allows_further_subcontracting - true, weighed_subcontracting_benefits_and_risks - true, assessed_impact_of_subcontracting_chains - true, provider_established_in_third_country - true, considered_third_country_data_protection_and_enforcement - true, financial_entity_is_article_16_1_entity - false, financial_entity_is_microenterprise - false]).

critical_complexity_unanswered_pairs(Pairs) :-
    critical_pairs(All),
    with_value(All, arrangement_allows_further_subcontracting, false, WithoutSubcontracting),
    with_value(WithoutSubcontracting, provider_established_in_third_country, false, WithinUnion),
    without_key(WithinUnion, arrangement_entails_high_technical_complexity, WithoutComplexity),
    without_key(WithoutComplexity, auditor_skills_and_knowledge_verified, Pairs).

critical_unsure_pairs(Pairs) :-
    six_duties_performed(Duties),
    entity_not_exempt(Entity),
    append([Duties, [entity_exercises_access_inspection_and_audit_rights - false, supports_critical_or_important_function - unsure, considered_most_up_to_date_information_security_standards - false], Entity], Pairs).

subject_pairs(plain_arrangement_complete, Pairs) :-
    plain_pairs(Pairs).
subject_pairs(plain_arrangement_supervisory_assessment_not_performed, Pairs) :-
    plain_pairs(Base),
    with_value(Base, assessed_supervisory_conditions_for_contracting, false, Pairs).
subject_pairs(audit_arrangement_complete, Pairs) :-
    audit_pairs(Pairs).
subject_pairs(audit_arrangement_frequency_not_predetermined, Pairs) :-
    audit_pairs(Base),
    with_value(Base, audit_frequency_and_areas_predetermined, false, Pairs).
subject_pairs(complex_audit_arrangement_complete, Pairs) :-
    complex_audit_pairs(Pairs).
subject_pairs(complex_audit_arrangement_auditor_skills_not_verified, Pairs) :-
    complex_audit_pairs(Base),
    with_value(Base, auditor_skills_and_knowledge_verified, false, Pairs).
subject_pairs(critical_arrangement_complete, Pairs) :-
    critical_pairs(Pairs).
subject_pairs(critical_arrangement_exit_strategy_not_performed, Pairs) :-
    critical_pairs(Base),
    with_value(Base, exit_strategy_in_place, false, Pairs).
subject_pairs(critical_arrangement_exit_strategy_not_performed_concentration_unanswered, Pairs) :-
    critical_pairs(Base),
    with_value(Base, exit_strategy_in_place, false, Failed),
    without_key(Failed, considered_concentration_risk, Pairs).
subject_pairs(critical_arrangement_exit_strategy_unanswered, Pairs) :-
    critical_complexity_unanswered_pairs(Base),
    without_key(Base, exit_strategy_in_place, Pairs).
subject_pairs(critical_arrangement_exit_strategy_not_performed_complexity_unanswered, Pairs) :-
    critical_complexity_unanswered_pairs(Base),
    with_value(Base, exit_strategy_in_place, false, Pairs).
subject_pairs(critical_arrangement_complexity_unanswered, Pairs) :-
    critical_complexity_unanswered_pairs(Pairs).
subject_pairs(critical_judgement_unsure_dependent_duty_not_performed, Pairs) :-
    critical_unsure_pairs(Pairs).
subject_pairs(critical_judgement_true_dependent_duty_not_performed, Pairs) :-
    critical_unsure_pairs(Base),
    with_value(Base, supports_critical_or_important_function, true, Pairs).
subject_pairs(third_country_provider_data_protection_not_considered, Pairs) :-
    critical_pairs(Base),
    with_value(Base, considered_third_country_data_protection_and_enforcement, false, Pairs).
subject_pairs(union_provider_data_protection_not_considered, Pairs) :-
    critical_pairs(Base),
    with_value(Base, considered_third_country_data_protection_and_enforcement, false, NotConsidered),
    with_value(NotConsidered, provider_established_in_third_country, false, Pairs).
subject_pairs(subcontracting_arrangement_chains_not_assessed, Pairs) :-
    critical_pairs(Base),
    with_value(Base, assessed_impact_of_subcontracting_chains, false, Pairs).
subject_pairs(no_subcontracting_arrangement_chains_not_assessed, Pairs) :-
    critical_pairs(Base),
    with_value(Base, assessed_impact_of_subcontracting_chains, false, NotAssessed),
    with_value(NotAssessed, arrangement_allows_further_subcontracting, false, Pairs).
subject_pairs(empty_profile, []).
subject_pairs(article_16_entity, Pairs) :-
    plain_pairs(Base),
    with_value(Base, financial_entity_is_article_16_1_entity, true, Pairs).
subject_pairs(microenterprise_entity, Pairs) :-
    plain_pairs(Base),
    with_value(Base, financial_entity_is_microenterprise, true, Pairs).
subject_pairs(entity_exemption_unanswered, Pairs) :-
    plain_pairs(Base),
    without_key(Base, financial_entity_is_microenterprise, Pairs).
subject_pairs(duplicate_key_profile, [exit_strategy_in_place - true, exit_strategy_in_place - false]).
subject_pairs(single_key_profile, [exit_strategy_in_place - true]).
subject_pairs(fact_given_unsure_profile, [arrangement_allows_further_subcontracting - unsure]).
subject_pairs(judgement_given_unsure_profile, [supports_critical_or_important_function - unsure]).
subject_pairs(unknown_key_profile, Pairs) :-
    plain_pairs(Base),
    append(Base, [unexpected_key - true], Pairs).
subject_pairs(numeric_key_profile, [42 - true]).
subject_pairs(mixed_problems_profile, [unexpected_key - true, supports_critical_or_important_function - maybe]).

with_value([], _, _, []).
with_value([Key - _|Pairs], Key, Value, [Key - Value|Rest]) :-
    with_value(Pairs, Key, Value, Rest).
with_value([Other - OtherValue|Pairs], Key, Value, [Other - OtherValue|Rest]) :-
    dif(Other, Key),
    with_value(Pairs, Key, Value, Rest).

without_key([], _, []).
without_key([Key - _|Pairs], Key, Rest) :-
    without_key(Pairs, Key, Rest).
without_key([Other - OtherValue|Pairs], Key, [Other - OtherValue|Rest]) :-
    dif(Other, Key),
    without_key(Pairs, Key, Rest).

dora_ict_third_party_entity_duties_assess(Subject, Result) :-
    dora_ict_third_party_entity_duties_profile_for(Subject, Profile),
    decide_dora_ict_third_party_entity_duties(Profile, Result).

test(every_subject_has_exactly_one_profile) :-
    findall(Subject, dora_ict_third_party_entity_duties_subject(Subject), Subjects),
    findall(Subject, (dora_ict_third_party_entity_duties_subject(Subject), dora_ict_third_party_entity_duties_profile_for(Subject, _)), Profiled),
    Profiled == Subjects.
test(plain_subject_is_complete) :-
    dora_ict_third_party_entity_duties_assess(plain_arrangement_complete, dora_ict_third_party_entity_duties_verdict(complete, _)).
test(plain_near_miss_is_incomplete) :-
    dora_ict_third_party_entity_duties_assess(plain_arrangement_supervisory_assessment_not_performed, dora_ict_third_party_entity_duties_verdict(incomplete, _)).

test(plain_near_miss_is_not_complete, fail) :-
    dora_ict_third_party_entity_duties_assess(plain_arrangement_supervisory_assessment_not_performed, dora_ict_third_party_entity_duties_verdict(complete, _)).
