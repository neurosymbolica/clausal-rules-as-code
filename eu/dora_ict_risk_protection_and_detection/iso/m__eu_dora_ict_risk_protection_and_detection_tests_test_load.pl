% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_ict_risk_protection_and_detection_tests_test_load, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_dora_ict_risk_protection_and_detection_kernel, [dora_ict_risk_protection_and_detection_input_problems/2]).
:- use_module(m__eu_dora_ict_risk_protection_and_detection_citations, [citation/2, implements/1]).

test(the_completeness_atoms_are_distinct) :-
    dif(complete, incomplete),
    dif(complete, simplified_framework_entity),
    dif(incomplete, simplified_framework_entity).
test(the_outstanding_atoms_are_distinct) :-
    dif(none_outstanding, simplified_framework_entity),
    dif(none_outstanding, complete).
test(the_judgement_values_are_distinct) :-
    dif(true, unsure),
    dif(false, unsure),
    dif(true, false).
test(the_verdict_term_carries_status_and_citations) :-
    Verdict = dora_ict_risk_protection_and_detection_verdict(complete, [cite(eu_reg_2022_2554_art_9_1)]),
    Verdict = dora_ict_risk_protection_and_detection_verdict(Status, Citations),
    Status == complete,
    Citations == [cite(eu_reg_2022_2554_art_9_1)].
test(the_required_term_carries_its_duties) :-
    Result = required([monitoring_and_control_of_ict_systems, trade_report_checking_systems]),
    Result = required(Duties),
    Duties == [monitoring_and_control_of_ict_systems, trade_report_checking_systems].
test(the_outstanding_term_carries_its_duties) :-
    Result = outstanding([information_security_policy]),
    Result = outstanding(Duties),
    Duties == [information_security_policy].
test(the_indeterminate_term_names_one_key) :-
    Result = indeterminate([financial_entity_is_article_16_1_entity]),
    Result = indeterminate([MissingKey]),
    MissingKey == financial_entity_is_article_16_1_entity.
test(the_review_term_carries_reason_and_context) :-
    Result = needs_legal_review(open_textured(detection_mechanisms_regularly_tested, cite(eu_reg_2022_2554_art_10_1)), [inputs_relied_on([financial_entity_is_article_16_1_entity - false, detection_mechanisms_regularly_tested - unsure])]),
    Result = needs_legal_review(open_textured(Key, Citation), [inputs_relied_on(Pairs)]),
    Key == detection_mechanisms_regularly_tested,
    Citation == cite(eu_reg_2022_2554_art_10_1),
    Pairs == [financial_entity_is_article_16_1_entity - false, detection_mechanisms_regularly_tested - unsure].
test(the_article_9_1_citation_is_recorded) :-
    citation(eu_reg_2022_2554_art_9_1, Record),
    Record = [label - _, ref - _, verbatim - _].
test(the_article_10_4_citation_is_recorded) :-
    citation(eu_reg_2022_2554_art_10_4, _Record).
test(the_article_16_1_citation_is_implemented) :-
    implements(eu_reg_2022_2554_art_16_1).
test(the_article_9_4_paragraph_citation_is_implemented) :-
    implements(eu_reg_2022_2554_art_9_4).
test(an_empty_profile_has_no_problem) :-
    findall(Problems, dora_ict_risk_protection_and_detection_input_problems([], Problems), Answers),
    Answers == [[]].
test(a_well_formed_profile_has_no_problem) :-
    Profile = [attribute(financial_entity_is_article_16_1_entity, false), attribute(dora_entity_type, data_reporting_service_provider), attribute(trade_report_checking_systems_in_place, unsure)],
    findall(Problems, dora_ict_risk_protection_and_detection_input_problems(Profile, Problems), Answers),
    Answers == [[]].
test(a_term_that_is_not_a_list_is_wrong_type_profile) :-
    findall(Problems, dora_ict_risk_protection_and_detection_input_problems(not_a_profile, Problems), Answers),
    Answers == [[wrong_type(profile)]].
test(an_unsure_gate_is_wrong_type) :-
    findall(Problems, dora_ict_risk_protection_and_detection_input_problems([attribute(financial_entity_is_article_16_1_entity, unsure)], Problems), Answers),
    Answers == [[wrong_type(financial_entity_is_article_16_1_entity)]].
test(a_repeated_key_is_duplicate_key) :-
    Profile = [attribute(dora_entity_type, credit_institution), attribute(dora_entity_type, trading_venue)],
    findall(Problems, dora_ict_risk_protection_and_detection_input_problems(Profile, Problems), Answers),
    Answers == [[duplicate_key(dora_entity_type)]].
test(key_problems_come_before_unknown_keys) :-
    Profile = [attribute(outside_the_contract, true), attribute(dora_entity_type, unsure)],
    findall(Problems, dora_ict_risk_protection_and_detection_input_problems(Profile, Problems), Answers),
    Answers == [[wrong_type(dora_entity_type), unknown_key(outside_the_contract)]].

test(a_status_term_is_not_a_final_atom, fail) :-
    indeterminate([dora_entity_type]) = complete.
test(an_unrecorded_citation_is_not_implemented, fail) :-
    implements(eu_reg_2022_2554_art_17).

cp_test_names([the_completeness_atoms_are_distinct, the_outstanding_atoms_are_distinct, the_judgement_values_are_distinct, the_verdict_term_carries_status_and_citations, the_required_term_carries_its_duties, the_outstanding_term_carries_its_duties, the_indeterminate_term_names_one_key, the_review_term_carries_reason_and_context, the_article_9_1_citation_is_recorded, the_article_10_4_citation_is_recorded, the_article_16_1_citation_is_implemented, the_article_9_4_paragraph_citation_is_implemented, an_empty_profile_has_no_problem, a_well_formed_profile_has_no_problem, a_term_that_is_not_a_list_is_wrong_type_profile, an_unsure_gate_is_wrong_type, a_repeated_key_is_duplicate_key, key_problems_come_before_unknown_keys]).
cp_test_fail_names([a_status_term_is_not_a_final_atom, an_unrecorded_citation_is_not_implemented]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
