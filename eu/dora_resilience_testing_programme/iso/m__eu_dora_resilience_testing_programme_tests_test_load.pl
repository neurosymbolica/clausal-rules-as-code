% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_resilience_testing_programme_tests_test_load, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_dora_resilience_testing_programme_kernel, [dora_resilience_testing_programme_input_problems/2, contract_key/2, present_pairs/2]).
:- use_module(m__eu_dora_resilience_testing_programme_citations, [citation/2, implements/1]).

test(the_article_24_1_citation_is_recorded) :-
    citation(eu_reg_2022_2554_art_24_1, Record),
    Record = [label - _, ref - _, verbatim - _].
test(the_article_25_3_citation_is_recorded) :-
    citation(eu_reg_2022_2554_art_25_3, _Record).
test(the_provenance_marker_holds_for_a_recorded_key) :-
    implements(eu_reg_2022_2554_art_25_2).
test(nine_citation_keys_are_recorded) :-
    findall(Key, citation(Key, _), Keys),
    sort(Keys, SortedKeys),
    length(SortedKeys, 9).
test(the_final_answers_of_complete_are_distinct) :-
    dif(complete, incomplete).
test(none_outstanding_is_distinct_from_complete) :-
    dif(none_outstanding, complete),
    dif(none_outstanding, incomplete).
test(the_duty_atoms_are_distinct) :-
    Duties = [resilience_testing_programme, range_of_assessments_and_tests, risk_based_testing_approach, independent_testers, internal_tester_resources_and_conflicts_of_interest, issue_prioritisation_classification_and_remedy, internal_validation_methodologies, yearly_testing_of_critical_ict_systems, execution_of_appropriate_tests, vulnerability_assessments_before_deployment, microenterprise_risk_based_planned_testing],
    sort(Duties, SortedDuties),
    length(SortedDuties, 11).
test(unsure_is_distinct_from_the_booleans) :-
    dif(unsure, true),
    dif(unsure, false).
test(the_verdict_term_carries_status_and_citations) :-
    Verdict = dora_resilience_testing_programme_verdict(complete, [cite(eu_reg_2022_2554_art_24_1)]),
    Verdict = dora_resilience_testing_programme_verdict(Status, Citations),
    Status == complete,
    Citations == [cite(eu_reg_2022_2554_art_24_1)].
test(the_required_term_destructures) :-
    Result = required([microenterprise_risk_based_planned_testing]),
    Result = required(Duties),
    Duties == [microenterprise_risk_based_planned_testing].
test(the_outstanding_term_destructures) :-
    Result = outstanding([independent_testers]),
    Result = outstanding([Duty]),
    Duty == independent_testers.
test(the_indeterminate_term_holds_one_key) :-
    Result = indeterminate([financial_entity_is_microenterprise]),
    Result = indeterminate([Key]),
    Key == financial_entity_is_microenterprise.
test(the_needs_legal_review_term_destructures) :-
    Result = needs_legal_review(open_textured(microenterprise_tests_risk_based_and_planned, cite(eu_reg_2022_2554_art_25_3)), [inputs_relied_on([financial_entity_is_microenterprise - true, microenterprise_tests_risk_based_and_planned - unsure])]),
    Result = needs_legal_review(open_textured(Key, cite(Citation)), [inputs_relied_on(Pairs)]),
    Key == microenterprise_tests_risk_based_and_planned,
    citation(Citation, _Record),
    Pairs == [financial_entity_is_microenterprise - true, microenterprise_tests_risk_based_and_planned - unsure].
test(the_input_problems_term_destructures) :-
    Result = input_problems([wrong_type(profile)]),
    Result = input_problems(Problems),
    Problems == [wrong_type(profile)].
test(the_input_check_accepts_a_well_formed_profile) :-
    dora_resilience_testing_programme_input_problems([attribute(financial_entity_is_microenterprise, true), attribute(microenterprise_tests_risk_based_and_planned, true)], Problems),
    Problems == [].
test(the_input_check_refuses_a_non_list) :-
    dora_resilience_testing_programme_input_problems(not_a_profile, Problems),
    Problems == [wrong_type(profile)].
test(the_input_check_gives_one_answer) :-
    findall(Problems, dora_resilience_testing_programme_input_problems([attribute(dora_entity_type, central_securities_depository)], Problems), Answers),
    Answers == [[]].
test(the_last_contract_key) :-
    contract_key(14, microenterprise_tests_risk_based_and_planned).
test(the_contract_has_fourteen_keys) :-
    findall(Key, contract_key(_, Key), Keys),
    length(Keys, 14).
test(present_pairs_keep_the_value_as_given) :-
    present_pairs([attribute(dora_entity_type, central_counterparty)], Pairs),
    Pairs == [dora_entity_type - central_counterparty].

test(the_placeholder_citation_is_gone, fail) :-
    citation(eu_todo_primary_source, _Record).

cp_test_names([the_article_24_1_citation_is_recorded, the_article_25_3_citation_is_recorded, the_provenance_marker_holds_for_a_recorded_key, nine_citation_keys_are_recorded, the_final_answers_of_complete_are_distinct, none_outstanding_is_distinct_from_complete, the_duty_atoms_are_distinct, unsure_is_distinct_from_the_booleans, the_verdict_term_carries_status_and_citations, the_required_term_destructures, the_outstanding_term_destructures, the_indeterminate_term_holds_one_key, the_needs_legal_review_term_destructures, the_input_problems_term_destructures, the_input_check_accepts_a_well_formed_profile, the_input_check_refuses_a_non_list, the_input_check_gives_one_answer, the_last_contract_key, the_contract_has_fourteen_keys, present_pairs_keep_the_value_as_given]).
cp_test_fail_names([the_placeholder_citation_is_gone]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
