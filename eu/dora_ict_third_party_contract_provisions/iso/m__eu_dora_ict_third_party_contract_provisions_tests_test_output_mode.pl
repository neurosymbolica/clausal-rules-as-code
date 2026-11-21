% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_ict_third_party_contract_provisions_tests_test_output_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(library(pairs), [pairs_keys/2]).
:- use_module(m__eu_dora_ict_third_party_contract_provisions_dora_ict_third_party_contract_provisions, [decide_dora_ict_third_party_contract_provisions/2, dora_ict_third_party_contract_provisions_status/2, dora_ict_third_party_contract_provisions_checklist/2, contract_provisions_required/3, contract_provisions_sufficient/3, contract_provisions_missing/3]).
:- use_module(m__eu_dora_ict_third_party_contract_provisions_queries, [dora_ict_third_party_contract_provisions_profile_keys/1]).
:- use_module(m__eu_dora_ict_third_party_contract_provisions_fixtures, [dora_ict_third_party_contract_provisions_profile_for/2]).

base_element_list([termination_for_significant_breach, termination_for_circumstances_altering_performance, termination_for_risk_management_weaknesses, termination_where_supervision_impeded, single_written_document, description_of_functions_services_and_subcontracting, service_and_data_locations, data_protection_provisions, data_access_recovery_and_return, service_level_descriptions, incident_assistance, cooperation_with_authorities, termination_rights_and_notice_periods, security_awareness_and_training_participation]).

critical_element_list(Elements) :-
    base_element_list(BaseElements),
    append(BaseElements, [full_service_levels_with_performance_targets, notice_periods_and_reporting_obligations, contingency_plans_and_security_measures, threat_led_penetration_testing_participation, monitoring_rights_of_the_financial_entity, monitoring_rights_of_the_authorities, exit_strategy_and_transition_period], Elements).

microenterprise_element_list(Elements) :-
    base_element_list(BaseElements),
    append(BaseElements, [full_service_levels_with_performance_targets, notice_periods_and_reporting_obligations, contingency_plans_and_security_measures, threat_led_penetration_testing_participation, monitoring_rights_of_the_financial_entity_or_delegated_assurance, monitoring_rights_of_the_authorities, exit_strategy_and_transition_period], Elements).

four_paragraphs([cite(eu_reg_2022_2554_art_28_7), cite(eu_reg_2022_2554_art_30_1), cite(eu_reg_2022_2554_art_30_2), cite(eu_reg_2022_2554_art_30_3)]).

same_citation_set(Citations, Expected) :-
    sort(Citations, SortedCitations),
    sort(Expected, SortedExpected),
    SortedCitations == SortedExpected.

only_answer(Query, Subject, Result, Citations) :-
    dora_ict_third_party_contract_provisions_profile_for(Subject, Profile),
    findall(OneResult - OneCitations, call(Query, Profile, OneResult, OneCitations), Answers),
    Answers = [Result - Citations].

met_item(item(_, met, cite(_))).

inapplicable_item(item(_, inapplicable, cite(_))).

test(required_for_a_critical_arrangement_is_all_twenty_one) :-
    only_answer(contract_provisions_required, critical_all_met, Result, Citations),
    critical_element_list(Elements),
    Result == required(Elements),
    four_paragraphs(Expected),
    same_citation_set(Citations, Expected).
test(required_for_a_microenterprise_names_the_delegated_assurance) :-
    only_answer(contract_provisions_required, microenterprise_delegation, Result, _),
    microenterprise_element_list(Elements),
    Result == required(Elements).
test(required_for_a_non_critical_arrangement_is_the_base_list) :-
    only_answer(contract_provisions_required, not_critical_all_met, Result, Citations),
    base_element_list(Elements),
    Result == required(Elements),
    same_citation_set(Citations, [cite(eu_reg_2022_2554_art_28_7), cite(eu_reg_2022_2554_art_30_1), cite(eu_reg_2022_2554_art_30_2)]).
test(required_asks_for_the_absent_critical_function) :-
    only_answer(contract_provisions_required, critical_absent_art_30_3_met, Result, Citations),
    Result == indeterminate([supports_critical_or_important_function]),
    Citations == [].
test(required_asks_for_the_microenterprise_before_referring) :-
    only_answer(contract_provisions_required, critical_unsure_microenterprise_absent, Result, Citations),
    Result == indeterminate([financial_entity_is_microenterprise]),
    Citations == [].
test(required_refers_an_unsure_critical_function_with_two_pairs) :-
    only_answer(contract_provisions_required, critical_unsure, Result, Citations),
    Result == needs_legal_review(open_textured(supports_critical_or_important_function, cite(eu_reg_2022_2554_art_30_3)), [inputs_relied_on([supports_critical_or_important_function - unsure, financial_entity_is_microenterprise - false])]),
    Citations == [].
test(sufficient_carries_the_four_paragraphs) :-
    only_answer(contract_provisions_sufficient, critical_all_met, Result, Citations),
    Result == sufficient,
    four_paragraphs(Expected),
    same_citation_set(Citations, Expected).
test(insufficient_carries_the_four_paragraphs) :-
    only_answer(contract_provisions_sufficient, not_critical_incident_assistance_false, Result, Citations),
    Result == insufficient,
    four_paragraphs(Expected),
    same_citation_set(Citations, Expected).
test(a_false_key_settles_sufficiency_before_an_absent_one) :-
    only_answer(contract_provisions_sufficient, base_false_and_absent, Result, _),
    Result == insufficient.
test(sufficiency_asks_for_the_critical_function_when_art_30_3_is_open) :-
    only_answer(contract_provisions_sufficient, critical_absent_art_30_3_open, Result, Citations),
    Result == indeterminate([supports_critical_or_important_function]),
    Citations == [].
test(an_unsure_document_is_referred_with_every_pair_in_key_order) :-
    only_answer(contract_provisions_sufficient, document_unsure, Result, Citations),
    Result = needs_legal_review(open_textured(contract_is_single_written_document, Citation), [inputs_relied_on(Pairs)]),
    Citation == cite(eu_reg_2022_2554_art_30_1),
    Citations == [],
    pairs_keys(Pairs, PairKeys),
    dora_ict_third_party_contract_provisions_profile_keys(ProfileKeys),
    PairKeys == ProfileKeys,
    member(contract_is_single_written_document - DocumentValue, Pairs),
    DocumentValue == unsure.
test(missing_names_the_failed_delegation_with_both_citations) :-
    only_answer(contract_provisions_missing, microenterprise_delegation_refused, Result, Citations),
    Result == missing([monitoring_rights_of_the_financial_entity_or_delegated_assurance]),
    same_citation_set(Citations, [cite(eu_reg_2022_2554_art_30_3_e), cite(eu_reg_2022_2554_art_30_3)]).
test(missing_names_the_entity_rights_outside_a_microenterprise) :-
    only_answer(contract_provisions_missing, not_microenterprise_delegation, Result, Citations),
    Result == missing([monitoring_rights_of_the_financial_entity]),
    Citations == [cite(eu_reg_2022_2554_art_30_3_e)].
test(missing_waits_for_every_element) :-
    only_answer(contract_provisions_missing, base_false_and_absent, Result, Citations),
    Result == indeterminate([contract_provides_termination_for_significant_breach]),
    Citations == [].
test(none_missing_carries_the_four_paragraphs) :-
    only_answer(contract_provisions_missing, not_critical_art_30_3_false, Result, Citations),
    Result == none_missing,
    four_paragraphs(Expected),
    same_citation_set(Citations, Expected).
test(every_query_reports_duplicate_and_unknown_keys) :-
    only_answer(contract_provisions_required, duplicate_and_unknown_keys, RequiredResult, []),
    RequiredResult == input_problems([duplicate_key(supports_critical_or_important_function), unknown_key(colour)]),
    only_answer(contract_provisions_sufficient, duplicate_and_unknown_keys, SufficientResult, []),
    SufficientResult == RequiredResult,
    only_answer(contract_provisions_missing, duplicate_and_unknown_keys, MissingResult, []),
    MissingResult == RequiredResult.
test(the_baseline_profile_yields_exactly_one_status) :-
    dora_ict_third_party_contract_provisions_profile_for(critical_all_met, Profile),
    findall(Status, dora_ict_third_party_contract_provisions_status(Profile, Status), Statuses),
    Statuses == [sufficient].
test(the_verdict_carries_a_citation) :-
    dora_ict_third_party_contract_provisions_profile_for(critical_all_met, Profile),
    decide_dora_ict_third_party_contract_provisions(Profile, dora_ict_third_party_contract_provisions_verdict(sufficient, [_FirstCitation|_OtherCitations])).
test(the_checklist_of_a_complete_contract_is_all_met) :-
    dora_ict_third_party_contract_provisions_profile_for(critical_all_met, Profile),
    dora_ict_third_party_contract_provisions_checklist(Profile, Items),
    length(Items, 21),
    maplist(met_item, Items).
test(the_checklist_marks_art_30_3_inapplicable_without_a_critical_function) :-
    dora_ict_third_party_contract_provisions_profile_for(not_critical_all_met, Profile),
    dora_ict_third_party_contract_provisions_checklist(Profile, Items),
    length(BaseItems, 14),
    append(BaseItems, CriticalItems, Items),
    maplist(met_item, BaseItems),
    length(CriticalItems, 7),
    maplist(inapplicable_item, CriticalItems).

cp_test_names([required_for_a_critical_arrangement_is_all_twenty_one, required_for_a_microenterprise_names_the_delegated_assurance, required_for_a_non_critical_arrangement_is_the_base_list, required_asks_for_the_absent_critical_function, required_asks_for_the_microenterprise_before_referring, required_refers_an_unsure_critical_function_with_two_pairs, sufficient_carries_the_four_paragraphs, insufficient_carries_the_four_paragraphs, a_false_key_settles_sufficiency_before_an_absent_one, sufficiency_asks_for_the_critical_function_when_art_30_3_is_open, an_unsure_document_is_referred_with_every_pair_in_key_order, missing_names_the_failed_delegation_with_both_citations, missing_names_the_entity_rights_outside_a_microenterprise, missing_waits_for_every_element, none_missing_carries_the_four_paragraphs, every_query_reports_duplicate_and_unknown_keys, the_baseline_profile_yields_exactly_one_status, the_verdict_carries_a_citation, the_checklist_of_a_complete_contract_is_all_met, the_checklist_marks_art_30_3_inapplicable_without_a_critical_function]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
