% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_resilience_testing_programme_fixtures, [dora_resilience_testing_programme_subject/1, dora_resilience_testing_programme_profile_for/2, dora_resilience_testing_programme_assess/2]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_dora_resilience_testing_programme_dora_resilience_testing_programme, [decide_dora_resilience_testing_programme/2]).

dora_resilience_testing_programme_subject(credit_institution_every_duty_performed).
dora_resilience_testing_programme_subject(credit_institution_yearly_testing_not_performed).
dora_resilience_testing_programme_subject(central_counterparty_vulnerability_assessments_performed).
dora_resilience_testing_programme_subject(central_counterparty_vulnerability_assessments_not_performed).
dora_resilience_testing_programme_subject(trading_venue_vulnerability_assessments_not_performed).
dora_resilience_testing_programme_subject(central_securities_depository_vulnerability_assessments_unstated).
dora_resilience_testing_programme_subject(internal_tester_resourced).
dora_resilience_testing_programme_subject(internal_tester_not_resourced).
dora_resilience_testing_programme_subject(external_testers_only_resources_not_dedicated).
dora_resilience_testing_programme_subject(internal_tester_unstated_but_resourced).
dora_resilience_testing_programme_subject(internal_tester_unstated_and_not_resourced).
dora_resilience_testing_programme_subject(microenterprise_testing_risk_based_and_planned).
dora_resilience_testing_programme_subject(microenterprise_testing_not_planned).
dora_resilience_testing_programme_subject(microenterprise_testing_unstated).
dora_resilience_testing_programme_subject(microenterprise_given_as_central_securities_depository).
dora_resilience_testing_programme_subject(size_unstated_both_routes_performed).
dora_resilience_testing_programme_subject(size_unstated_branch_open).
dora_resilience_testing_programme_subject(programme_judgement_unsure).
dora_resilience_testing_programme_subject(programme_judgement_unstated).
dora_resilience_testing_programme_subject(fact_key_given_unsure).

dora_resilience_testing_programme_profile_for(Subject, Profile) :-
    subject_pairs(Subject, Pairs),
    maplist(pair_attribute, Pairs, Profile).

pair_attribute(ProfileKey - Value, attribute(ProfileKey, Value)).

always_duty_keys([resilience_testing_programme_established_maintained_and_reviewed, programme_includes_range_of_assessments_and_tests, programme_conducted_on_risk_based_approach, tests_undertaken_by_independent_parties, procedures_to_prioritise_classify_and_remedy_issues_established, internal_validation_methodologies_established, critical_ict_systems_tested_at_least_yearly, programme_provides_for_appropriate_tests]).

always_pairs(Override, Pairs) :-
    always_duty_keys(ProfileKeys),
    maplist(always_pair(Override), ProfileKeys, Pairs).

always_pair(none, ProfileKey, ProfileKey - true).
always_pair(ProfileKey - Value, ProfileKey, ProfileKey - Value).
always_pair(OverrideKey - _, ProfileKey, ProfileKey - true) :-
    dif(OverrideKey, ProfileKey).

branch_pairs(EntityType, TesterValue, Override, Extra, Pairs) :-
    always_pairs(Override, AlwaysPairs),
    append([financial_entity_is_microenterprise - false, dora_entity_type - EntityType, tests_undertaken_by_internal_tester - TesterValue|AlwaysPairs], Extra, Pairs).

subject_pairs(credit_institution_every_duty_performed, Pairs) :-
    branch_pairs(credit_institution, false, none, [], Pairs).
subject_pairs(credit_institution_yearly_testing_not_performed, Pairs) :-
    branch_pairs(credit_institution, false, critical_ict_systems_tested_at_least_yearly - false, [], Pairs).
subject_pairs(central_counterparty_vulnerability_assessments_performed, Pairs) :-
    branch_pairs(central_counterparty, false, none, [vulnerability_assessments_performed_before_deployment - true], Pairs).
subject_pairs(central_counterparty_vulnerability_assessments_not_performed, Pairs) :-
    branch_pairs(central_counterparty, false, none, [vulnerability_assessments_performed_before_deployment - false], Pairs).
subject_pairs(trading_venue_vulnerability_assessments_not_performed, Pairs) :-
    branch_pairs(trading_venue, false, none, [vulnerability_assessments_performed_before_deployment - false], Pairs).
subject_pairs(central_securities_depository_vulnerability_assessments_unstated, Pairs) :-
    branch_pairs(central_securities_depository, false, none, [], Pairs).
subject_pairs(internal_tester_resourced, Pairs) :-
    branch_pairs(credit_institution, true, none, [internal_tester_resourced_and_conflicts_of_interest_avoided - true], Pairs).
subject_pairs(internal_tester_not_resourced, Pairs) :-
    branch_pairs(credit_institution, true, none, [internal_tester_resourced_and_conflicts_of_interest_avoided - false], Pairs).
subject_pairs(external_testers_only_resources_not_dedicated, Pairs) :-
    branch_pairs(credit_institution, false, none, [internal_tester_resourced_and_conflicts_of_interest_avoided - false], Pairs).
subject_pairs(internal_tester_unstated_but_resourced, Pairs) :-
    always_pairs(none, AlwaysPairs),
    append([financial_entity_is_microenterprise - false, dora_entity_type - credit_institution, internal_tester_resourced_and_conflicts_of_interest_avoided - true], AlwaysPairs, Pairs).
subject_pairs(internal_tester_unstated_and_not_resourced, Pairs) :-
    always_pairs(none, AlwaysPairs),
    append([financial_entity_is_microenterprise - false, dora_entity_type - credit_institution, internal_tester_resourced_and_conflicts_of_interest_avoided - false], AlwaysPairs, Pairs).
subject_pairs(microenterprise_testing_risk_based_and_planned, [financial_entity_is_microenterprise - true, microenterprise_tests_risk_based_and_planned - true]).
subject_pairs(microenterprise_testing_not_planned, [financial_entity_is_microenterprise - true, microenterprise_tests_risk_based_and_planned - false]).
subject_pairs(microenterprise_testing_unstated, [financial_entity_is_microenterprise - true]).
subject_pairs(microenterprise_given_as_central_securities_depository, [financial_entity_is_microenterprise - true, dora_entity_type - central_securities_depository, microenterprise_tests_risk_based_and_planned - true]).
subject_pairs(size_unstated_both_routes_performed, Pairs) :-
    always_pairs(none, AlwaysPairs),
    append([dora_entity_type - credit_institution, tests_undertaken_by_internal_tester - false, microenterprise_tests_risk_based_and_planned - true], AlwaysPairs, Pairs).
subject_pairs(size_unstated_branch_open, Pairs) :-
    always_pairs(none, AlwaysPairs),
    select(resilience_testing_programme_established_maintained_and_reviewed - true, AlwaysPairs, OpenPairs),
    append([dora_entity_type - credit_institution, tests_undertaken_by_internal_tester - false, microenterprise_tests_risk_based_and_planned - true], OpenPairs, Pairs).
subject_pairs(programme_judgement_unsure, Pairs) :-
    branch_pairs(credit_institution, false, resilience_testing_programme_established_maintained_and_reviewed - unsure, [], Pairs).
subject_pairs(programme_judgement_unstated, Pairs) :-
    always_pairs(none, AlwaysPairs),
    select(resilience_testing_programme_established_maintained_and_reviewed - true, AlwaysPairs, OpenPairs),
    append([financial_entity_is_microenterprise - false, dora_entity_type - credit_institution, tests_undertaken_by_internal_tester - false], OpenPairs, Pairs).
subject_pairs(fact_key_given_unsure, [financial_entity_is_microenterprise - false, tests_undertaken_by_internal_tester - unsure]).

dora_resilience_testing_programme_assess(Subject, Result) :-
    dora_resilience_testing_programme_profile_for(Subject, Profile),
    decide_dora_resilience_testing_programme(Profile, Result).
