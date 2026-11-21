% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_resilience_testing_programme_tests_test_negative_controls, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_dora_resilience_testing_programme_dora_resilience_testing_programme, [resilience_testing_duties_required/3, resilience_testing_duties_complete/3, resilience_testing_duties_outstanding/3, dora_resilience_testing_programme_status_values/1]).
:- use_module(m__eu_dora_resilience_testing_programme_queries, [dora_resilience_testing_programme_compliance_check/3]).
:- use_module(m__eu_dora_resilience_testing_programme_fixtures, [dora_resilience_testing_programme_profile_for/2]).

pair_attribute(ProfileKey - Value, attribute(ProfileKey, Value)).

test_profile(Pairs, Profile) :-
    maplist(pair_attribute, Pairs, Profile).

subject_complete(Subject, Result) :-
    dora_resilience_testing_programme_profile_for(Subject, Profile),
    resilience_testing_duties_complete(Profile, Result, _).

subject_outstanding(Subject, Result) :-
    dora_resilience_testing_programme_profile_for(Subject, Profile),
    resilience_testing_duties_outstanding(Profile, Result, _).

subject_required(Subject, Result) :-
    dora_resilience_testing_programme_profile_for(Subject, Profile),
    resilience_testing_duties_required(Profile, Result, _).

test(the_status_table_holds_the_final_atoms) :-
    dora_resilience_testing_programme_status_values(StatusValues),
    member(complete, StatusValues),
    member(incomplete, StatusValues).
test(r2_a_microenterprise_has_only_the_article_25_3_duty) :-
    test_profile([financial_entity_is_microenterprise - true], Profile),
    resilience_testing_duties_required(Profile, required([microenterprise_risk_based_planned_testing]), [cite(eu_reg_2022_2554_art_25_3)]).
test(r2_near_miss_gets_the_eight_always_duties) :-
    test_profile([financial_entity_is_microenterprise - false, dora_entity_type - credit_institution, tests_undertaken_by_internal_tester - false], Profile),
    resilience_testing_duties_required(Profile, required(Duties), _),
    length(Duties, 8).
test(r1_an_empty_profile_asks_the_size_question) :-
    resilience_testing_duties_required([], indeterminate([financial_entity_is_microenterprise]), []).
test(r5_a_central_securities_depository_has_the_article_25_2_duty) :-
    test_profile([financial_entity_is_microenterprise - false, dora_entity_type - central_securities_depository, tests_undertaken_by_internal_tester - false], Profile),
    resilience_testing_duties_required(Profile, required(Duties), Citations),
    member(vulnerability_assessments_before_deployment, Duties),
    member(cite(eu_reg_2022_2554_art_25_2), Citations).
test(r5_an_internal_tester_brings_its_duty) :-
    test_profile([financial_entity_is_microenterprise - false, dora_entity_type - credit_institution, tests_undertaken_by_internal_tester - true], Profile),
    resilience_testing_duties_required(Profile, required(Duties), _),
    member(internal_tester_resources_and_conflicts_of_interest, Duties).
test(s2_every_duty_performed_is_complete) :-
    subject_complete(credit_institution_every_duty_performed, complete).
test(s1_near_miss_yearly_testing_not_performed_is_incomplete) :-
    subject_complete(credit_institution_yearly_testing_not_performed, incomplete).
test(s1_a_central_counterparty_not_assessing_is_incomplete) :-
    subject_complete(central_counterparty_vulnerability_assessments_not_performed, incomplete).
test(s2_near_miss_a_trading_venue_not_assessing_is_complete) :-
    subject_complete(trading_venue_vulnerability_assessments_not_performed, complete).
test(s1_an_internal_tester_not_resourced_is_incomplete) :-
    subject_complete(internal_tester_not_resourced, incomplete).
test(s2_near_miss_external_testers_only_is_complete) :-
    subject_complete(external_testers_only_resources_not_dedicated, complete).
test(s1_a_false_duty_decides_before_absent_keys) :-
    test_profile([financial_entity_is_microenterprise - false, procedures_to_prioritise_classify_and_remedy_issues_established - false], Profile),
    resilience_testing_duties_complete(Profile, incomplete, _).
test(s5_near_miss_the_same_duty_true_names_the_first_strong_key) :-
    test_profile([financial_entity_is_microenterprise - false, procedures_to_prioritise_classify_and_remedy_issues_established - true], Profile),
    resilience_testing_duties_complete(Profile, indeterminate([resilience_testing_programme_established_maintained_and_reviewed]), []).
test(s2_size_absent_and_both_routes_performed_is_complete) :-
    subject_complete(size_unstated_both_routes_performed, complete).
test(s3_near_miss_size_absent_and_the_branch_open_names_the_size_key) :-
    subject_complete(size_unstated_branch_open, indeterminate([financial_entity_is_microenterprise])).
test(s1_size_absent_and_both_routes_failing_is_incomplete) :-
    test_profile([microenterprise_tests_risk_based_and_planned - false, tests_undertaken_by_independent_parties - false], Profile),
    resilience_testing_duties_complete(Profile, incomplete, _).
test(s3_near_miss_size_absent_and_only_the_branch_failing_names_the_size_key) :-
    test_profile([microenterprise_tests_risk_based_and_planned - true, tests_undertaken_by_independent_parties - false], Profile),
    resilience_testing_duties_complete(Profile, indeterminate([financial_entity_is_microenterprise]), []).
test(s2_a_microenterprise_testing_on_plan_is_complete) :-
    subject_complete(microenterprise_testing_risk_based_and_planned, complete).
test(s1_near_miss_a_microenterprise_not_planning_is_incomplete) :-
    subject_complete(microenterprise_testing_not_planned, incomplete).
test(s4_an_unsure_microenterprise_judgement_is_referred) :-
    test_profile([financial_entity_is_microenterprise - true, microenterprise_tests_risk_based_and_planned - unsure], Profile),
    resilience_testing_duties_complete(Profile, needs_legal_review(open_textured(microenterprise_tests_risk_based_and_planned, cite(eu_reg_2022_2554_art_25_3)), [inputs_relied_on([financial_entity_is_microenterprise - true, microenterprise_tests_risk_based_and_planned - unsure])]), []).
test(s4_near_miss_an_absent_microenterprise_judgement_is_named) :-
    subject_complete(microenterprise_testing_unstated, indeterminate([microenterprise_tests_risk_based_and_planned])).
test(s6_an_unsure_judgement_that_decides_is_referred) :-
    subject_complete(programme_judgement_unsure, needs_legal_review(open_textured(resilience_testing_programme_established_maintained_and_reviewed, cite(eu_reg_2022_2554_art_24_1)), _)).
test(s5_near_miss_the_same_judgement_absent_is_named) :-
    subject_complete(programme_judgement_unstated, indeterminate([resilience_testing_programme_established_maintained_and_reviewed])).
test(s6_an_unsure_internal_tester_judgement_with_an_internal_tester_is_referred) :-
    dora_resilience_testing_programme_profile_for(internal_tester_resourced, BaseProfile),
    select(attribute(internal_tester_resourced_and_conflicts_of_interest_avoided, true), BaseProfile, Rest),
    Profile = [attribute(internal_tester_resourced_and_conflicts_of_interest_avoided, unsure)|Rest],
    resilience_testing_duties_complete(Profile, needs_legal_review(open_textured(internal_tester_resourced_and_conflicts_of_interest_avoided, cite(eu_reg_2022_2554_art_24_4)), _), []).
test(s5_near_miss_with_the_tester_unstated_the_tester_is_named_first) :-
    dora_resilience_testing_programme_profile_for(internal_tester_unstated_but_resourced, BaseProfile),
    select(attribute(internal_tester_resourced_and_conflicts_of_interest_avoided, true), BaseProfile, Rest),
    Profile = [attribute(internal_tester_resourced_and_conflicts_of_interest_avoided, unsure)|Rest],
    resilience_testing_duties_complete(Profile, indeterminate([tests_undertaken_by_internal_tester]), []).
test(m5_a_false_duty_is_outstanding) :-
    subject_outstanding(credit_institution_yearly_testing_not_performed, outstanding([yearly_testing_of_critical_ict_systems])).
test(m5_near_miss_every_duty_performed_is_none_outstanding) :-
    subject_outstanding(credit_institution_every_duty_performed, none_outstanding).
test(m3_a_false_duty_does_not_end_the_outstanding_query) :-
    test_profile([financial_entity_is_microenterprise - false, tests_undertaken_by_independent_parties - false], Profile),
    resilience_testing_duties_outstanding(Profile, indeterminate([dora_entity_type]), []).
test(m1_size_absent_and_both_routes_performed_is_none_outstanding) :-
    subject_outstanding(size_unstated_both_routes_performed, none_outstanding).
test(m1_near_miss_size_absent_and_the_microenterprise_duty_false_names_the_size_key) :-
    dora_resilience_testing_programme_profile_for(size_unstated_both_routes_performed, BaseProfile),
    select(attribute(microenterprise_tests_risk_based_and_planned, true), BaseProfile, Rest),
    Profile = [attribute(microenterprise_tests_risk_based_and_planned, false)|Rest],
    resilience_testing_duties_outstanding(Profile, indeterminate([financial_entity_is_microenterprise]), []).
test(m2_a_microenterprise_not_planning_has_its_duty_outstanding) :-
    subject_outstanding(microenterprise_testing_not_planned, outstanding([microenterprise_risk_based_planned_testing])).
test(s0_unsure_for_a_fact_key_is_an_input_problem) :-
    subject_complete(fact_key_given_unsure, input_problems([wrong_type(tests_undertaken_by_internal_tester)])).
test(s0_near_miss_false_for_the_fact_key_asks_the_next_key) :-
    test_profile([financial_entity_is_microenterprise - false, tests_undertaken_by_internal_tester - false], Profile),
    resilience_testing_duties_complete(Profile, indeterminate([resilience_testing_programme_established_maintained_and_reviewed]), []).
test(c13_omitting_an_applying_duty_is_forbidden) :-
    dora_resilience_testing_programme_profile_for(internal_tester_resourced, Profile),
    dora_resilience_testing_programme_compliance_check(Profile, omit(internal_tester_resources_and_conflicts_of_interest), compliance_verdict(forbidden, _)).
test(c13_near_miss_without_an_internal_tester_it_is_permitted) :-
    dora_resilience_testing_programme_profile_for(external_testers_only_resources_not_dedicated, Profile),
    dora_resilience_testing_programme_compliance_check(Profile, omit(internal_tester_resources_and_conflicts_of_interest), compliance_verdict(permitted, _)).

test(r2_near_miss_an_entity_not_a_microenterprise_does_not_get_it, fail) :-
    test_profile([financial_entity_is_microenterprise - false, dora_entity_type - credit_institution, tests_undertaken_by_internal_tester - false], Profile),
    resilience_testing_duties_required(Profile, required([microenterprise_risk_based_planned_testing]), _).
test(r1_near_miss_a_stated_size_is_not_indeterminate, fail) :-
    test_profile([financial_entity_is_microenterprise - true], Profile),
    resilience_testing_duties_required(Profile, indeterminate(_), _).
test(r5_near_miss_an_insurance_undertaking_does_not_have_it, fail) :-
    test_profile([financial_entity_is_microenterprise - false, dora_entity_type - insurance_undertaking, tests_undertaken_by_internal_tester - false], Profile),
    resilience_testing_duties_required(Profile, required(Duties), _),
    member(vulnerability_assessments_before_deployment, Duties).
test(r5_near_miss_a_microenterprise_central_securities_depository_does_not_have_it, fail) :-
    subject_required(microenterprise_given_as_central_securities_depository, required(Duties)),
    member(vulnerability_assessments_before_deployment, Duties).
test(r5_near_miss_no_internal_tester_no_such_duty, fail) :-
    test_profile([financial_entity_is_microenterprise - false, dora_entity_type - credit_institution, tests_undertaken_by_internal_tester - false], Profile),
    resilience_testing_duties_required(Profile, required(Duties), _),
    member(internal_tester_resources_and_conflicts_of_interest, Duties).
test(s1_near_miss_yearly_testing_not_performed_is_not_complete, fail) :-
    subject_complete(credit_institution_yearly_testing_not_performed, complete).
test(s1_near_miss_a_trading_venue_not_assessing_is_not_incomplete, fail) :-
    subject_complete(trading_venue_vulnerability_assessments_not_performed, incomplete).
test(s1_near_miss_external_testers_only_is_not_incomplete, fail) :-
    subject_complete(external_testers_only_resources_not_dedicated, incomplete).
test(s1_near_miss_the_same_duty_true_is_not_incomplete, fail) :-
    test_profile([financial_entity_is_microenterprise - false, procedures_to_prioritise_classify_and_remedy_issues_established - true], Profile),
    resilience_testing_duties_complete(Profile, incomplete, _).
test(s3_near_miss_size_absent_and_the_branch_open_is_not_complete, fail) :-
    subject_complete(size_unstated_branch_open, complete).
test(s3_near_miss_size_absent_and_only_the_branch_failing_is_not_incomplete, fail) :-
    test_profile([microenterprise_tests_risk_based_and_planned - true, tests_undertaken_by_independent_parties - false], Profile),
    resilience_testing_duties_complete(Profile, incomplete, _).
test(s1_near_miss_a_microenterprise_not_planning_is_not_complete, fail) :-
    subject_complete(microenterprise_testing_not_planned, complete).
test(s4_near_miss_an_absent_microenterprise_judgement_is_not_referred, fail) :-
    subject_complete(microenterprise_testing_unstated, needs_legal_review(_, _)).
test(s5_near_miss_the_same_judgement_absent_is_not_referred, fail) :-
    subject_complete(programme_judgement_unstated, needs_legal_review(_, _)).
test(s5_near_miss_with_the_tester_unstated_there_is_no_referral, fail) :-
    dora_resilience_testing_programme_profile_for(internal_tester_unstated_but_resourced, BaseProfile),
    select(attribute(internal_tester_resourced_and_conflicts_of_interest_avoided, true), BaseProfile, Rest),
    Profile = [attribute(internal_tester_resourced_and_conflicts_of_interest_avoided, unsure)|Rest],
    resilience_testing_duties_complete(Profile, needs_legal_review(_, _), _).
test(m5_near_miss_every_duty_performed_has_no_outstanding_list, fail) :-
    subject_outstanding(credit_institution_every_duty_performed, outstanding(_)).
test(m3_near_miss_the_partial_list_is_not_given, fail) :-
    test_profile([financial_entity_is_microenterprise - false, tests_undertaken_by_independent_parties - false], Profile),
    resilience_testing_duties_outstanding(Profile, outstanding(_), _).
test(m1_near_miss_size_absent_and_the_microenterprise_duty_false_is_not_none_outstanding, fail) :-
    dora_resilience_testing_programme_profile_for(size_unstated_both_routes_performed, BaseProfile),
    select(attribute(microenterprise_tests_risk_based_and_planned, true), BaseProfile, Rest),
    Profile = [attribute(microenterprise_tests_risk_based_and_planned, false)|Rest],
    resilience_testing_duties_outstanding(Profile, none_outstanding, _).
test(m2_near_miss_a_microenterprise_planning_has_nothing_outstanding, fail) :-
    subject_outstanding(microenterprise_testing_risk_based_and_planned, outstanding(_)).
test(s0_near_miss_false_for_the_fact_key_is_no_input_problem, fail) :-
    test_profile([financial_entity_is_microenterprise - false, tests_undertaken_by_internal_tester - false], Profile),
    resilience_testing_duties_complete(Profile, input_problems(_), _).
test(c13_near_miss_without_an_internal_tester_it_is_not_forbidden, fail) :-
    dora_resilience_testing_programme_profile_for(external_testers_only_resources_not_dedicated, Profile),
    dora_resilience_testing_programme_compliance_check(Profile, omit(internal_tester_resources_and_conflicts_of_interest), compliance_verdict(forbidden, _)).

cp_test_names([the_status_table_holds_the_final_atoms, r2_a_microenterprise_has_only_the_article_25_3_duty, r2_near_miss_gets_the_eight_always_duties, r1_an_empty_profile_asks_the_size_question, r5_a_central_securities_depository_has_the_article_25_2_duty, r5_an_internal_tester_brings_its_duty, s2_every_duty_performed_is_complete, s1_near_miss_yearly_testing_not_performed_is_incomplete, s1_a_central_counterparty_not_assessing_is_incomplete, s2_near_miss_a_trading_venue_not_assessing_is_complete, s1_an_internal_tester_not_resourced_is_incomplete, s2_near_miss_external_testers_only_is_complete, s1_a_false_duty_decides_before_absent_keys, s5_near_miss_the_same_duty_true_names_the_first_strong_key, s2_size_absent_and_both_routes_performed_is_complete, s3_near_miss_size_absent_and_the_branch_open_names_the_size_key, s1_size_absent_and_both_routes_failing_is_incomplete, s3_near_miss_size_absent_and_only_the_branch_failing_names_the_size_key, s2_a_microenterprise_testing_on_plan_is_complete, s1_near_miss_a_microenterprise_not_planning_is_incomplete, s4_an_unsure_microenterprise_judgement_is_referred, s4_near_miss_an_absent_microenterprise_judgement_is_named, s6_an_unsure_judgement_that_decides_is_referred, s5_near_miss_the_same_judgement_absent_is_named, s6_an_unsure_internal_tester_judgement_with_an_internal_tester_is_referred, s5_near_miss_with_the_tester_unstated_the_tester_is_named_first, m5_a_false_duty_is_outstanding, m5_near_miss_every_duty_performed_is_none_outstanding, m3_a_false_duty_does_not_end_the_outstanding_query, m1_size_absent_and_both_routes_performed_is_none_outstanding, m1_near_miss_size_absent_and_the_microenterprise_duty_false_names_the_size_key, m2_a_microenterprise_not_planning_has_its_duty_outstanding, s0_unsure_for_a_fact_key_is_an_input_problem, s0_near_miss_false_for_the_fact_key_asks_the_next_key, c13_omitting_an_applying_duty_is_forbidden, c13_near_miss_without_an_internal_tester_it_is_permitted]).
cp_test_fail_names([r2_near_miss_an_entity_not_a_microenterprise_does_not_get_it, r1_near_miss_a_stated_size_is_not_indeterminate, r5_near_miss_an_insurance_undertaking_does_not_have_it, r5_near_miss_a_microenterprise_central_securities_depository_does_not_have_it, r5_near_miss_no_internal_tester_no_such_duty, s1_near_miss_yearly_testing_not_performed_is_not_complete, s1_near_miss_a_trading_venue_not_assessing_is_not_incomplete, s1_near_miss_external_testers_only_is_not_incomplete, s1_near_miss_the_same_duty_true_is_not_incomplete, s3_near_miss_size_absent_and_the_branch_open_is_not_complete, s3_near_miss_size_absent_and_only_the_branch_failing_is_not_incomplete, s1_near_miss_a_microenterprise_not_planning_is_not_complete, s4_near_miss_an_absent_microenterprise_judgement_is_not_referred, s5_near_miss_the_same_judgement_absent_is_not_referred, s5_near_miss_with_the_tester_unstated_there_is_no_referral, m5_near_miss_every_duty_performed_has_no_outstanding_list, m3_near_miss_the_partial_list_is_not_given, m1_near_miss_size_absent_and_the_microenterprise_duty_false_is_not_none_outstanding, m2_near_miss_a_microenterprise_planning_has_nothing_outstanding, s0_near_miss_false_for_the_fact_key_is_no_input_problem, c13_near_miss_without_an_internal_tester_it_is_not_forbidden]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
