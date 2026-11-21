% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_resilience_testing_programme_tests_test_queries, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_dora_resilience_testing_programme_queries, [dora_resilience_testing_programme_profile_keys/1, dora_resilience_testing_programme_what_if/4, dora_resilience_testing_programme_compliance_check/3, complete/0, incomplete/0, none_outstanding/0, unsure/0, central_counterparty/0, central_securities_depository/0]).
:- use_module(m__eu_dora_resilience_testing_programme_kernel, [dora_resilience_testing_programme_input_problems/2]).
:- use_module(m__eu_dora_resilience_testing_programme_dora_resilience_testing_programme, [dora_resilience_testing_programme_status/2, dora_resilience_testing_programme_checklist/2]).
:- use_module(m__eu_dora_resilience_testing_programme_fixtures, [dora_resilience_testing_programme_profile_for/2, dora_resilience_testing_programme_assess/2]).

test(profile_keys_are_the_contract_keys) :-
    dora_resilience_testing_programme_profile_keys(ProfileKeys),
    ProfileKeys == [financial_entity_is_microenterprise, dora_entity_type, tests_undertaken_by_internal_tester, resilience_testing_programme_established_maintained_and_reviewed, programme_includes_range_of_assessments_and_tests, programme_conducted_on_risk_based_approach, tests_undertaken_by_independent_parties, internal_tester_resourced_and_conflicts_of_interest_avoided, procedures_to_prioritise_classify_and_remedy_issues_established, internal_validation_methodologies_established, critical_ict_systems_tested_at_least_yearly, programme_provides_for_appropriate_tests, vulnerability_assessments_performed_before_deployment, microenterprise_tests_risk_based_and_planned].
test(the_reexported_input_check_accepts_a_fixture) :-
    dora_resilience_testing_programme_profile_for(credit_institution_every_duty_performed, Profile),
    dora_resilience_testing_programme_input_problems(Profile, []).
test(the_reexported_input_check_names_a_problem) :-
    dora_resilience_testing_programme_profile_for(fact_key_given_unsure, Profile),
    dora_resilience_testing_programme_input_problems(Profile, Problems),
    Problems == [wrong_type(tests_undertaken_by_internal_tester)].
test(status_of_a_fixture) :-
    dora_resilience_testing_programme_profile_for(internal_tester_resourced, Profile),
    findall(Status, dora_resilience_testing_programme_status(Profile, Status), Statuses),
    Statuses == [complete].
test(the_assess_wrapper_returns_the_verdict) :-
    dora_resilience_testing_programme_assess(microenterprise_testing_not_planned, Verdict),
    Verdict = dora_resilience_testing_programme_verdict(incomplete, [_|_]).
test(what_if_performing_the_missing_duty_completes_the_duties) :-
    dora_resilience_testing_programme_profile_for(credit_institution_yearly_testing_not_performed, Profile),
    findall(Status, dora_resilience_testing_programme_what_if(Profile, critical_ict_systems_tested_at_least_yearly, true, Status), Statuses),
    Statuses == [complete].
test(what_if_dropping_a_duty_makes_the_duties_incomplete) :-
    dora_resilience_testing_programme_profile_for(credit_institution_every_duty_performed, Profile),
    dora_resilience_testing_programme_what_if(Profile, tests_undertaken_by_independent_parties, false, incomplete).
test(what_if_an_unsure_judgement_is_referred) :-
    dora_resilience_testing_programme_profile_for(credit_institution_yearly_testing_not_performed, Profile),
    dora_resilience_testing_programme_what_if(Profile, critical_ict_systems_tested_at_least_yearly, unsure, Status),
    Status = needs_legal_review(Reason, _),
    Reason == open_textured(critical_ict_systems_tested_at_least_yearly, cite(eu_reg_2022_2554_art_24_6)).
test(compliance_omitting_a_central_counterparty_duty_is_forbidden) :-
    dora_resilience_testing_programme_profile_for(central_counterparty_vulnerability_assessments_performed, Profile),
    findall(Verdict, dora_resilience_testing_programme_compliance_check(Profile, omit(vulnerability_assessments_before_deployment), Verdict), [compliance_verdict(forbidden, Citations)]),
    member(cite(eu_reg_2022_2554_art_25_2), Citations).
test(compliance_omitting_the_microenterprise_duty_is_permitted_for_a_credit_institution) :-
    dora_resilience_testing_programme_profile_for(credit_institution_every_duty_performed, Profile),
    dora_resilience_testing_programme_compliance_check(Profile, omit(microenterprise_risk_based_planned_testing), compliance_verdict(permitted, _)).
test(compliance_an_unstated_tester_is_indeterminate) :-
    dora_resilience_testing_programme_profile_for(internal_tester_unstated_but_resourced, Profile),
    dora_resilience_testing_programme_compliance_check(Profile, omit(independent_testers), Verdict),
    Verdict == indeterminate([tests_undertaken_by_internal_tester]).
test(compliance_a_badly_formed_profile_gives_its_problems) :-
    dora_resilience_testing_programme_profile_for(fact_key_given_unsure, Profile),
    dora_resilience_testing_programme_compliance_check(Profile, omit(independent_testers), Verdict),
    Verdict == input_problems([wrong_type(tests_undertaken_by_internal_tester)]).
test(checklist_items_each_carry_a_citation) :-
    dora_resilience_testing_programme_profile_for(internal_tester_not_resourced, Profile),
    dora_resilience_testing_programme_checklist(Profile, Items),
    length(Items, 11),
    maplist(item_has_citation, Items),
    member(item(internal_tester_resources_and_conflicts_of_interest, unmet(internal_tester_resourced_and_conflicts_of_interest_avoided), cite(eu_reg_2022_2554_art_24_4)), Items).
test(checklist_marks_the_inapplicable_duties) :-
    dora_resilience_testing_programme_profile_for(microenterprise_testing_risk_based_and_planned, Profile),
    dora_resilience_testing_programme_checklist(Profile, Items),
    member(item(microenterprise_risk_based_planned_testing, met, cite(eu_reg_2022_2554_art_25_3)), Items),
    member(item(resilience_testing_programme, inapplicable, cite(eu_reg_2022_2554_art_24_1)), Items).
test(the_root_atoms_are_defined) :-
    complete,
    incomplete,
    none_outstanding,
    unsure,
    central_counterparty,
    central_securities_depository.
test(the_result_constructors_build_as_data) :-
    Result = needs_legal_review(open_textured(dora_entity_type, cite(eu_reg_2022_2554_art_25_2)), [inputs_relied_on([])]),
    Result = needs_legal_review(open_textured(Key, cite(Citation)), [inputs_relied_on(Pairs)]),
    Key == dora_entity_type,
    Citation == eu_reg_2022_2554_art_25_2,
    Pairs == [].

test(what_if_the_type_becomes_a_central_counterparty, fail) :-
    dora_resilience_testing_programme_profile_for(trading_venue_vulnerability_assessments_not_performed, Profile),
    dora_resilience_testing_programme_what_if(Profile, dora_entity_type, central_counterparty, complete).

item_has_citation(item(_, _, cite(Key))) :-
    atom(Key).

cp_test_names([profile_keys_are_the_contract_keys, the_reexported_input_check_accepts_a_fixture, the_reexported_input_check_names_a_problem, status_of_a_fixture, the_assess_wrapper_returns_the_verdict, what_if_performing_the_missing_duty_completes_the_duties, what_if_dropping_a_duty_makes_the_duties_incomplete, what_if_an_unsure_judgement_is_referred, compliance_omitting_a_central_counterparty_duty_is_forbidden, compliance_omitting_the_microenterprise_duty_is_permitted_for_a_credit_institution, compliance_an_unstated_tester_is_indeterminate, compliance_a_badly_formed_profile_gives_its_problems, checklist_items_each_carry_a_citation, checklist_marks_the_inapplicable_duties, the_root_atoms_are_defined, the_result_constructors_build_as_data]).
cp_test_fail_names([what_if_the_type_becomes_a_central_counterparty]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
