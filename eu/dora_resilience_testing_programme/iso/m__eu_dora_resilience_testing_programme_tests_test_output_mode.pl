% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_resilience_testing_programme_tests_test_output_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_dora_resilience_testing_programme_dora_resilience_testing_programme, [resilience_testing_duties_required/3, resilience_testing_duties_complete/3, resilience_testing_duties_outstanding/3, decide_dora_resilience_testing_programme/2, dora_resilience_testing_programme_status/2]).
:- use_module(m__eu_dora_resilience_testing_programme_fixtures, [dora_resilience_testing_programme_profile_for/2]).

pair_attribute(ProfileKey - Value, attribute(ProfileKey, Value)).

test_profile(Pairs, Profile) :-
    maplist(pair_attribute, Pairs, Profile).

checked_citations([cite(eu_reg_2022_2554_art_24_1), cite(eu_reg_2022_2554_art_24_2), cite(eu_reg_2022_2554_art_24_3), cite(eu_reg_2022_2554_art_24_4), cite(eu_reg_2022_2554_art_24_5), cite(eu_reg_2022_2554_art_24_6), cite(eu_reg_2022_2554_art_25_1), cite(eu_reg_2022_2554_art_25_2), cite(eu_reg_2022_2554_art_25_3)]).

always_duties([resilience_testing_programme, range_of_assessments_and_tests, risk_based_testing_approach, independent_testers, issue_prioritisation_classification_and_remedy, internal_validation_methodologies, yearly_testing_of_critical_ict_systems, execution_of_appropriate_tests]).

expected_complete(credit_institution_every_duty_performed, complete).
expected_complete(credit_institution_yearly_testing_not_performed, incomplete).
expected_complete(central_counterparty_vulnerability_assessments_performed, complete).
expected_complete(central_counterparty_vulnerability_assessments_not_performed, incomplete).
expected_complete(trading_venue_vulnerability_assessments_not_performed, complete).
expected_complete(central_securities_depository_vulnerability_assessments_unstated, indeterminate([vulnerability_assessments_performed_before_deployment])).
expected_complete(internal_tester_resourced, complete).
expected_complete(internal_tester_not_resourced, incomplete).
expected_complete(external_testers_only_resources_not_dedicated, complete).
expected_complete(internal_tester_unstated_but_resourced, complete).
expected_complete(internal_tester_unstated_and_not_resourced, indeterminate([tests_undertaken_by_internal_tester])).
expected_complete(microenterprise_testing_risk_based_and_planned, complete).
expected_complete(microenterprise_testing_not_planned, incomplete).
expected_complete(microenterprise_testing_unstated, indeterminate([microenterprise_tests_risk_based_and_planned])).
expected_complete(microenterprise_given_as_central_securities_depository, complete).
expected_complete(size_unstated_both_routes_performed, complete).
expected_complete(size_unstated_branch_open, indeterminate([financial_entity_is_microenterprise])).
expected_complete(programme_judgement_unstated, indeterminate([resilience_testing_programme_established_maintained_and_reviewed])).
expected_complete(fact_key_given_unsure, input_problems([wrong_type(tests_undertaken_by_internal_tester)])).

expected_outstanding(credit_institution_every_duty_performed, none_outstanding).
expected_outstanding(credit_institution_yearly_testing_not_performed, outstanding([yearly_testing_of_critical_ict_systems])).
expected_outstanding(central_counterparty_vulnerability_assessments_performed, none_outstanding).
expected_outstanding(central_counterparty_vulnerability_assessments_not_performed, outstanding([vulnerability_assessments_before_deployment])).
expected_outstanding(trading_venue_vulnerability_assessments_not_performed, none_outstanding).
expected_outstanding(central_securities_depository_vulnerability_assessments_unstated, indeterminate([vulnerability_assessments_performed_before_deployment])).
expected_outstanding(internal_tester_resourced, none_outstanding).
expected_outstanding(internal_tester_not_resourced, outstanding([internal_tester_resources_and_conflicts_of_interest])).
expected_outstanding(external_testers_only_resources_not_dedicated, none_outstanding).
expected_outstanding(internal_tester_unstated_but_resourced, none_outstanding).
expected_outstanding(internal_tester_unstated_and_not_resourced, indeterminate([tests_undertaken_by_internal_tester])).
expected_outstanding(microenterprise_testing_risk_based_and_planned, none_outstanding).
expected_outstanding(microenterprise_testing_not_planned, outstanding([microenterprise_risk_based_planned_testing])).
expected_outstanding(microenterprise_testing_unstated, indeterminate([microenterprise_tests_risk_based_and_planned])).
expected_outstanding(microenterprise_given_as_central_securities_depository, none_outstanding).
expected_outstanding(size_unstated_both_routes_performed, none_outstanding).
expected_outstanding(size_unstated_branch_open, indeterminate([financial_entity_is_microenterprise])).
expected_outstanding(programme_judgement_unstated, indeterminate([resilience_testing_programme_established_maintained_and_reviewed])).
expected_outstanding(fact_key_given_unsure, input_problems([wrong_type(tests_undertaken_by_internal_tester)])).

subject_complete_result(Subject, Subject - Result) :-
    dora_resilience_testing_programme_profile_for(Subject, Profile),
    resilience_testing_duties_complete(Profile, Result, _).

subject_outstanding_result(Subject, Subject - Result) :-
    dora_resilience_testing_programme_profile_for(Subject, Profile),
    resilience_testing_duties_outstanding(Profile, Result, _).

test(every_fixture_gets_its_one_complete_result) :-
    findall(Subject - Expected, expected_complete(Subject, Expected), Wanted),
    findall(Got, (expected_complete(Subject, _), subject_complete_result(Subject, Got)), Answers),
    Answers == Wanted.
test(every_fixture_gets_its_one_outstanding_result) :-
    findall(Subject - Expected, expected_outstanding(Subject, Expected), Wanted),
    findall(Got, (expected_outstanding(Subject, _), subject_outstanding_result(Subject, Got)), Answers),
    Answers == Wanted.
test(the_baseline_profile_yields_exactly_one_status) :-
    dora_resilience_testing_programme_profile_for(credit_institution_every_duty_performed, Profile),
    findall(Status, dora_resilience_testing_programme_status(Profile, Status), Statuses),
    Statuses == [complete].
test(the_verdict_carries_the_nine_checked_citations) :-
    dora_resilience_testing_programme_profile_for(credit_institution_every_duty_performed, Profile),
    checked_citations(Checked),
    findall(Verdict, decide_dora_resilience_testing_programme(Profile, Verdict), Verdicts),
    Verdicts == [dora_resilience_testing_programme_verdict(complete, Checked)].
test(the_referral_is_read_out_whole) :-
    dora_resilience_testing_programme_profile_for(programme_judgement_unsure, Profile),
    findall(Result - Citations, resilience_testing_duties_complete(Profile, Result, Citations), Answers),
    Answers = [needs_legal_review(Reason, [inputs_relied_on(Pairs)]) - []],
    Reason == open_textured(resilience_testing_programme_established_maintained_and_reviewed, cite(eu_reg_2022_2554_art_24_1)),
    length(Pairs, 11).
test(a_microenterprise_required_answer_is_read_out_whole) :-
    dora_resilience_testing_programme_profile_for(microenterprise_given_as_central_securities_depository, Profile),
    findall(Result - Citations, resilience_testing_duties_required(Profile, Result, Citations), Answers),
    Answers == [required([microenterprise_risk_based_planned_testing]) - [cite(eu_reg_2022_2554_art_25_3)]].
test(an_other_type_without_internal_tester_has_the_eight_always_duties) :-
    dora_resilience_testing_programme_profile_for(credit_institution_every_duty_performed, Profile),
    always_duties(AlwaysDuties),
    findall(Result - Citations, resilience_testing_duties_required(Profile, Result, Citations), [required(Duties) - Citations]),
    Duties == AlwaysDuties,
    sort(Citations, SortedCitations),
    SortedCitations == [cite(eu_reg_2022_2554_art_24_1), cite(eu_reg_2022_2554_art_24_2), cite(eu_reg_2022_2554_art_24_3), cite(eu_reg_2022_2554_art_24_4), cite(eu_reg_2022_2554_art_24_5), cite(eu_reg_2022_2554_art_24_6), cite(eu_reg_2022_2554_art_25_1)].
test(a_central_securities_depository_with_an_internal_tester_has_ten_duties_in_order) :-
    test_profile([financial_entity_is_microenterprise - false, dora_entity_type - central_securities_depository, tests_undertaken_by_internal_tester - true], Profile),
    findall(Result - Citations, resilience_testing_duties_required(Profile, Result, Citations), [required(Duties) - Citations]),
    Duties == [resilience_testing_programme, range_of_assessments_and_tests, risk_based_testing_approach, independent_testers, internal_tester_resources_and_conflicts_of_interest, issue_prioritisation_classification_and_remedy, internal_validation_methodologies, yearly_testing_of_critical_ict_systems, execution_of_appropriate_tests, vulnerability_assessments_before_deployment],
    sort(Citations, SortedCitations),
    length(SortedCitations, 8),
    member(cite(eu_reg_2022_2554_art_25_2), SortedCitations).
test(required_names_the_tester_after_the_type) :-
    dora_resilience_testing_programme_profile_for(internal_tester_unstated_but_resourced, Profile),
    findall(Result - Citations, resilience_testing_duties_required(Profile, Result, Citations), Answers),
    Answers == [indeterminate([tests_undertaken_by_internal_tester]) - []].
test(several_outstanding_duties_come_in_duty_order_with_each_citation_once) :-
    test_profile([financial_entity_is_microenterprise - false, dora_entity_type - central_counterparty, tests_undertaken_by_internal_tester - true, resilience_testing_programme_established_maintained_and_reviewed - false, programme_includes_range_of_assessments_and_tests - true, programme_conducted_on_risk_based_approach - true, tests_undertaken_by_independent_parties - true, internal_tester_resourced_and_conflicts_of_interest_avoided - false, procedures_to_prioritise_classify_and_remedy_issues_established - false, internal_validation_methodologies_established - false, critical_ict_systems_tested_at_least_yearly - true, programme_provides_for_appropriate_tests - true, vulnerability_assessments_performed_before_deployment - false], Profile),
    findall(Result - Citations, resilience_testing_duties_outstanding(Profile, Result, Citations), [Result - Citations]),
    Result == outstanding([resilience_testing_programme, internal_tester_resources_and_conflicts_of_interest, issue_prioritisation_classification_and_remedy, internal_validation_methodologies, vulnerability_assessments_before_deployment]),
    sort(Citations, SortedCitations),
    SortedCitations == Citations,
    SortedCitations == [cite(eu_reg_2022_2554_art_24_1), cite(eu_reg_2022_2554_art_24_4), cite(eu_reg_2022_2554_art_24_5), cite(eu_reg_2022_2554_art_25_2)].
test(complete_names_a_strong_key_before_an_earlier_weak_one) :-
    test_profile([financial_entity_is_microenterprise - false, tests_undertaken_by_internal_tester - false, resilience_testing_programme_established_maintained_and_reviewed - true, programme_includes_range_of_assessments_and_tests - true, programme_conducted_on_risk_based_approach - true, tests_undertaken_by_independent_parties - true, procedures_to_prioritise_classify_and_remedy_issues_established - true, internal_validation_methodologies_established - true, critical_ict_systems_tested_at_least_yearly - true], Profile),
    findall(Result - Citations, resilience_testing_duties_complete(Profile, Result, Citations), Answers),
    Answers == [indeterminate([programme_provides_for_appropriate_tests]) - []].
test(outstanding_names_the_first_absent_key_in_root_order) :-
    test_profile([financial_entity_is_microenterprise - false, tests_undertaken_by_internal_tester - false, resilience_testing_programme_established_maintained_and_reviewed - true, programme_includes_range_of_assessments_and_tests - true, programme_conducted_on_risk_based_approach - true, tests_undertaken_by_independent_parties - true, procedures_to_prioritise_classify_and_remedy_issues_established - true, internal_validation_methodologies_established - true, critical_ict_systems_tested_at_least_yearly - true], Profile),
    findall(Result - Citations, resilience_testing_duties_outstanding(Profile, Result, Citations), Answers),
    Answers == [indeterminate([dora_entity_type]) - []].
test(an_absent_key_is_named_before_an_unsure_judgement_is_referred) :-
    test_profile([financial_entity_is_microenterprise - false, dora_entity_type - credit_institution, resilience_testing_programme_established_maintained_and_reviewed - true, programme_includes_range_of_assessments_and_tests - true, programme_conducted_on_risk_based_approach - true, tests_undertaken_by_independent_parties - true, internal_tester_resourced_and_conflicts_of_interest_avoided - unsure, procedures_to_prioritise_classify_and_remedy_issues_established - true, internal_validation_methodologies_established - true, critical_ict_systems_tested_at_least_yearly - true, programme_provides_for_appropriate_tests - true], Profile),
    findall(Result - Citations, resilience_testing_duties_complete(Profile, Result, Citations), Answers),
    Answers == [indeterminate([tests_undertaken_by_internal_tester]) - []].
test(an_absent_size_key_with_both_values_agreeing_is_none_outstanding) :-
    dora_resilience_testing_programme_profile_for(size_unstated_both_routes_performed, Profile),
    checked_citations(Checked),
    findall(Result - Citations, resilience_testing_duties_outstanding(Profile, Result, Citations), Answers),
    Answers == [none_outstanding - Checked].

cp_test_names([every_fixture_gets_its_one_complete_result, every_fixture_gets_its_one_outstanding_result, the_baseline_profile_yields_exactly_one_status, the_verdict_carries_the_nine_checked_citations, the_referral_is_read_out_whole, a_microenterprise_required_answer_is_read_out_whole, an_other_type_without_internal_tester_has_the_eight_always_duties, a_central_securities_depository_with_an_internal_tester_has_ten_duties_in_order, required_names_the_tester_after_the_type, several_outstanding_duties_come_in_duty_order_with_each_citation_once, complete_names_a_strong_key_before_an_earlier_weak_one, outstanding_names_the_first_absent_key_in_root_order, an_absent_key_is_named_before_an_unsure_judgement_is_referred, an_absent_size_key_with_both_values_agreeing_is_none_outstanding]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
