% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_resilience_testing_programme_queries, [dora_resilience_testing_programme_profile_keys/1, dora_resilience_testing_programme_what_if/4, dora_resilience_testing_programme_compliance_check/3, complete/0, incomplete/0, none_outstanding/0, financial_entity_is_microenterprise/0, dora_entity_type/0, tests_undertaken_by_internal_tester/0, resilience_testing_programme_established_maintained_and_reviewed/0, programme_includes_range_of_assessments_and_tests/0, programme_conducted_on_risk_based_approach/0, tests_undertaken_by_independent_parties/0, internal_tester_resourced_and_conflicts_of_interest_avoided/0, procedures_to_prioritise_classify_and_remedy_issues_established/0, internal_validation_methodologies_established/0, critical_ict_systems_tested_at_least_yearly/0, programme_provides_for_appropriate_tests/0, vulnerability_assessments_performed_before_deployment/0, microenterprise_tests_risk_based_and_planned/0, resilience_testing_programme/0, range_of_assessments_and_tests/0, risk_based_testing_approach/0, independent_testers/0, internal_tester_resources_and_conflicts_of_interest/0, issue_prioritisation_classification_and_remedy/0, internal_validation_methodologies/0, yearly_testing_of_critical_ict_systems/0, execution_of_appropriate_tests/0, vulnerability_assessments_before_deployment/0, microenterprise_risk_based_planned_testing/0, central_securities_depository/0, central_counterparty/0, unsure/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_lists_extra, [clausal_is_list/1]).
:- use_module(library(reif), [memberd_t/3]).
:- use_module(m__eu_dora_resilience_testing_programme_kernel, [dora_resilience_testing_programme_input_problems/2]).
:- use_module(m__eu_dora_resilience_testing_programme_citations, [implements/1]).
:- use_module(m__eu_dora_resilience_testing_programme_dora_resilience_testing_programme, [dora_resilience_testing_programme_status/2, resilience_testing_duties_required/3]).

dora_resilience_testing_programme_profile_keys([financial_entity_is_microenterprise, dora_entity_type, tests_undertaken_by_internal_tester, resilience_testing_programme_established_maintained_and_reviewed, programme_includes_range_of_assessments_and_tests, programme_conducted_on_risk_based_approach, tests_undertaken_by_independent_parties, internal_tester_resourced_and_conflicts_of_interest_avoided, procedures_to_prioritise_classify_and_remedy_issues_established, internal_validation_methodologies_established, critical_ict_systems_tested_at_least_yearly, programme_provides_for_appropriate_tests, vulnerability_assessments_performed_before_deployment, microenterprise_tests_risk_based_and_planned]).

dora_resilience_testing_programme_what_if(Profile, OverriddenKey, NewValue, NewStatus) :-
    clausal_is_list(Profile),
    replace_attribute(Profile, OverriddenKey, NewValue, Hypothesis),
    dora_resilience_testing_programme_status(Hypothesis, NewStatus).

replace_attribute([], Key, Value, [attribute(Key, Value)]).
replace_attribute([Element|Elements], Key, Value, Replaced) :-
    nonvar(Element),
    Element = attribute(ElementKey, _),
    ElementKey == Key,
    replace_attribute(Elements, Key, Value, Replaced).
replace_attribute([Element|Elements], Key, Value, [Element|Replaced]) :-
    nonvar(Element),
    Element = attribute(ElementKey, _),
    ElementKey \== Key,
    replace_attribute(Elements, Key, Value, Replaced).
replace_attribute([Element|Elements], Key, Value, [Element|Replaced]) :-
    var(Element),
    replace_attribute(Elements, Key, Value, Replaced).
replace_attribute([Element|Elements], Key, Value, [Element|Replaced]) :-
    nonvar(Element),
    Element \= attribute(_, _),
    replace_attribute(Elements, Key, Value, Replaced).

dora_resilience_testing_programme_compliance_check(Profile, omit(Duty), Verdict) :-
    resilience_testing_duties_required(Profile, Result, Citations),
    omission_verdict(Result, Citations, Duty, Verdict).

omission_verdict(required(Duties), Citations, Duty, Verdict) :-
    implements(eu_reg_2022_2554_art_24_1),
    memberd_t(Duty, Duties, Applies),
    omission_modality(Applies, Citations, Verdict).
omission_verdict(indeterminate(MissingKeys), _, _, indeterminate(MissingKeys)).
omission_verdict(input_problems(Problems), _, _, input_problems(Problems)).
omission_verdict(needs_legal_review(open_textured(Key, Citation), [inputs_relied_on(Pairs)|Provenance]), _, _, needs_legal_review(open_textured(Key, Citation), [inputs_relied_on(Pairs)|Provenance])).

omission_modality(true, Citations, compliance_verdict(forbidden, Citations)).
omission_modality(false, Citations, compliance_verdict(permitted, Citations)).

complete.

incomplete.

none_outstanding.

financial_entity_is_microenterprise.

dora_entity_type.

tests_undertaken_by_internal_tester.

resilience_testing_programme_established_maintained_and_reviewed.

programme_includes_range_of_assessments_and_tests.

programme_conducted_on_risk_based_approach.

tests_undertaken_by_independent_parties.

internal_tester_resourced_and_conflicts_of_interest_avoided.

procedures_to_prioritise_classify_and_remedy_issues_established.

internal_validation_methodologies_established.

critical_ict_systems_tested_at_least_yearly.

programme_provides_for_appropriate_tests.

vulnerability_assessments_performed_before_deployment.

microenterprise_tests_risk_based_and_planned.

resilience_testing_programme.

range_of_assessments_and_tests.

risk_based_testing_approach.

independent_testers.

internal_tester_resources_and_conflicts_of_interest.

issue_prioritisation_classification_and_remedy.

internal_validation_methodologies.

yearly_testing_of_critical_ict_systems.

execution_of_appropriate_tests.

vulnerability_assessments_before_deployment.

microenterprise_risk_based_planned_testing.

central_securities_depository.

central_counterparty.

unsure.

test(omitting_the_microenterprise_duty_is_forbidden_for_a_microenterprise) :-
    dora_resilience_testing_programme_compliance_check([attribute(financial_entity_is_microenterprise, true)], omit(microenterprise_risk_based_planned_testing), Verdict),
    Verdict == compliance_verdict(forbidden, [cite(eu_reg_2022_2554_art_25_3)]).
test(omitting_the_programme_is_permitted_for_a_microenterprise) :-
    dora_resilience_testing_programme_compliance_check([attribute(financial_entity_is_microenterprise, true)], omit(resilience_testing_programme), compliance_verdict(permitted, _)).
test(omitting_vulnerability_assessments_is_forbidden_for_a_central_counterparty) :-
    dora_resilience_testing_programme_compliance_check([attribute(financial_entity_is_microenterprise, false), attribute(dora_entity_type, central_counterparty), attribute(tests_undertaken_by_internal_tester, false)], omit(vulnerability_assessments_before_deployment), compliance_verdict(forbidden, _)).
test(omitting_vulnerability_assessments_is_permitted_for_a_credit_institution) :-
    dora_resilience_testing_programme_compliance_check([attribute(financial_entity_is_microenterprise, false), attribute(dora_entity_type, credit_institution), attribute(tests_undertaken_by_internal_tester, false)], omit(vulnerability_assessments_before_deployment), compliance_verdict(permitted, _)).
test(an_unstated_size_leaves_the_compliance_check_indeterminate) :-
    findall(Verdict, dora_resilience_testing_programme_compliance_check([], omit(independent_testers), Verdict), Verdicts),
    Verdicts == [indeterminate([financial_entity_is_microenterprise])].
test(a_badly_formed_profile_gives_its_input_problems_to_the_compliance_check) :-
    dora_resilience_testing_programme_compliance_check([attribute(financial_entity_is_microenterprise, unsure)], omit(independent_testers), Verdict),
    Verdict == input_problems([wrong_type(financial_entity_is_microenterprise)]).
test(the_what_if_override_replaces_the_one_attribute) :-
    replace_attribute([attribute(dora_entity_type, trading_venue), attribute(financial_entity_is_microenterprise, false)], dora_entity_type, central_counterparty, Replaced),
    Replaced == [attribute(financial_entity_is_microenterprise, false), attribute(dora_entity_type, central_counterparty)].
test(the_what_if_refers_an_unsure_microenterprise_judgement) :-
    dora_resilience_testing_programme_what_if([attribute(financial_entity_is_microenterprise, true), attribute(microenterprise_tests_risk_based_and_planned, true)], microenterprise_tests_risk_based_and_planned, unsure, Status),
    Status = needs_legal_review(open_textured(Key, _), [inputs_relied_on(_)|_]),
    Key == microenterprise_tests_risk_based_and_planned.
test(the_profile_keys_are_fourteen) :-
    dora_resilience_testing_programme_profile_keys(ProfileKeys),
    length(ProfileKeys, 14).
test(the_root_atoms_are_defined) :-
    complete,
    incomplete,
    none_outstanding,
    unsure.
test(the_result_constructors_build_as_data) :-
    Result = indeterminate([dora_entity_type]),
    Result = indeterminate([Key]),
    Key == dora_entity_type.

test(omitting_the_programme_is_not_forbidden_for_a_microenterprise, fail) :-
    dora_resilience_testing_programme_compliance_check([attribute(financial_entity_is_microenterprise, true)], omit(resilience_testing_programme), compliance_verdict(forbidden, _)).
