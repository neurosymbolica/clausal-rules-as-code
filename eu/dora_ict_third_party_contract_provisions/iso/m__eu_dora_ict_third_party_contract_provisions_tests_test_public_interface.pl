% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_ict_third_party_contract_provisions_tests_test_public_interface, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_dora_ict_third_party_contract_provisions_dora_ict_third_party_contract_provisions, [decide_dora_ict_third_party_contract_provisions/2, dora_ict_third_party_contract_provisions_status/2, dora_ict_third_party_contract_provisions_checklist/2, dora_ict_third_party_contract_provisions_decision_resolvable/1, dora_ict_third_party_contract_provisions_status_values/1, contract_provisions_required/3, contract_provisions_sufficient/3, contract_provisions_missing/3]).
:- use_module(m__eu_dora_ict_third_party_contract_provisions_fixtures, [dora_ict_third_party_contract_provisions_subject/1, dora_ict_third_party_contract_provisions_profile_for/2, dora_ict_third_party_contract_provisions_assess/2]).
:- use_module(m__eu_dora_ict_third_party_contract_provisions_kernel, [dora_ict_third_party_contract_provisions_input_problems/2]).

sufficiency_of(Subject, Result, Citations) :-
    dora_ict_third_party_contract_provisions_profile_for(Subject, Profile),
    findall(Found - Cited, contract_provisions_sufficient(Profile, Found, Cited), Answers),
    Answers = [Answer],
    Answer = Result - Citations.

required_of(Subject, Result, Citations) :-
    dora_ict_third_party_contract_provisions_profile_for(Subject, Profile),
    findall(Found - Cited, contract_provisions_required(Profile, Found, Cited), Answers),
    Answers = [Answer],
    Answer = Result - Citations.

missing_of(Subject, Result, Citations) :-
    dora_ict_third_party_contract_provisions_profile_for(Subject, Profile),
    findall(Found - Cited, contract_provisions_missing(Profile, Found, Cited), Answers),
    Answers = [Answer],
    Answer = Result - Citations.

checked_citations(Citations) :-
    sort(Citations, Sorted),
    Sorted == [cite(eu_reg_2022_2554_art_28_7), cite(eu_reg_2022_2554_art_30_1), cite(eu_reg_2022_2554_art_30_2), cite(eu_reg_2022_2554_art_30_3)].

base_citations(Citations) :-
    sort(Citations, Sorted),
    Sorted == [cite(eu_reg_2022_2554_art_28_7), cite(eu_reg_2022_2554_art_30_1), cite(eu_reg_2022_2554_art_30_2)].

test(every_subject_has_exactly_one_verdict) :-
    findall(Subject, dora_ict_third_party_contract_provisions_subject(Subject), Subjects),
    length(Subjects, 16),
    maplist(one_verdict, Subjects).
test(every_subject_has_a_non_empty_checklist) :-
    findall(Subject, dora_ict_third_party_contract_provisions_subject(Subject), Subjects),
    maplist(non_empty_checklist, Subjects).
test(the_final_verdict_vocabulary) :-
    dora_ict_third_party_contract_provisions_status_values(StatusValues),
    StatusValues == [sufficient, insufficient].
test(critical_all_met_is_sufficient) :-
    sufficiency_of(critical_all_met, Result, Citations),
    Result == sufficient,
    checked_citations(Citations).
test(critical_all_met_verdict_through_assess) :-
    dora_ict_third_party_contract_provisions_assess(critical_all_met, dora_ict_third_party_contract_provisions_verdict(Status, Citations)),
    Status == sufficient,
    checked_citations(Citations).
test(critical_all_met_misses_nothing) :-
    missing_of(critical_all_met, Result, Citations),
    Result == none_missing,
    checked_citations(Citations).
test(critical_all_met_requires_twenty_one) :-
    required_of(critical_all_met, required(Elements), Citations),
    length(Elements, 21),
    nth1(19, Elements, Position),
    Position == monitoring_rights_of_the_financial_entity,
    checked_citations(Citations).
test(critical_all_met_checklist_cites_every_item) :-
    dora_ict_third_party_contract_provisions_profile_for(critical_all_met, Profile),
    dora_ict_third_party_contract_provisions_checklist(Profile, Items),
    length(Items, 21),
    maplist(met_cited_item, Items).
test(critical_exit_strategy_false_is_insufficient) :-
    sufficiency_of(critical_exit_strategy_false, Result, Citations),
    Result == insufficient,
    checked_citations(Citations).
test(critical_exit_strategy_false_lists_the_exit_strategy) :-
    missing_of(critical_exit_strategy_false, Result, Citations),
    Result == missing([exit_strategy_and_transition_period]),
    Citations == [cite(eu_reg_2022_2554_art_30_3_f)].
test(not_critical_all_met_is_sufficient) :-
    dora_ict_third_party_contract_provisions_profile_for(not_critical_all_met, Profile),
    dora_ict_third_party_contract_provisions_status(Profile, Status),
    Status == sufficient.
test(not_critical_all_met_requires_the_base_list) :-
    required_of(not_critical_all_met, Result, Citations),
    Result == required([termination_for_significant_breach, termination_for_circumstances_altering_performance, termination_for_risk_management_weaknesses, termination_where_supervision_impeded, single_written_document, description_of_functions_services_and_subcontracting, service_and_data_locations, data_protection_provisions, data_access_recovery_and_return, service_level_descriptions, incident_assistance, cooperation_with_authorities, termination_rights_and_notice_periods, security_awareness_and_training_participation]),
    base_citations(Citations).
test(not_critical_all_met_misses_nothing) :-
    missing_of(not_critical_all_met, none_missing, _).
test(not_critical_incident_assistance_false_is_insufficient) :-
    sufficiency_of(not_critical_incident_assistance_false, Result, Citations),
    Result == insufficient,
    checked_citations(Citations).
test(not_critical_incident_assistance_false_lists_it) :-
    missing_of(not_critical_incident_assistance_false, Result, Citations),
    Result == missing([incident_assistance]),
    Citations == [cite(eu_reg_2022_2554_art_30_2_f)].
test(not_critical_art_30_3_false_is_still_sufficient) :-
    sufficiency_of(not_critical_art_30_3_false, Result, _),
    Result == sufficient.
test(not_critical_art_30_3_false_misses_nothing) :-
    missing_of(not_critical_art_30_3_false, Result, _),
    Result == none_missing.
test(microenterprise_delegation_is_sufficient) :-
    sufficiency_of(microenterprise_delegation, Result, _),
    Result == sufficient.
test(microenterprise_delegation_names_the_substitute) :-
    required_of(microenterprise_delegation, required(Elements), Citations),
    length(Elements, 21),
    nth1(19, Elements, Position),
    Position == monitoring_rights_of_the_financial_entity_or_delegated_assurance,
    checked_citations(Citations).
test(microenterprise_delegation_misses_nothing) :-
    missing_of(microenterprise_delegation, none_missing, _).
test(microenterprise_delegation_refused_is_insufficient) :-
    sufficiency_of(microenterprise_delegation_refused, Result, _),
    Result == insufficient.
test(microenterprise_delegation_refused_lists_the_substitute) :-
    missing_of(microenterprise_delegation_refused, Result, Citations),
    Result == missing([monitoring_rights_of_the_financial_entity_or_delegated_assurance]),
    sort(Citations, Sorted),
    Sorted == [cite(eu_reg_2022_2554_art_30_3), cite(eu_reg_2022_2554_art_30_3_e)].
test(not_microenterprise_delegation_is_insufficient) :-
    sufficiency_of(not_microenterprise_delegation, Result, _),
    Result == insufficient.
test(not_microenterprise_delegation_lists_the_own_rights) :-
    missing_of(not_microenterprise_delegation, Result, Citations),
    Result == missing([monitoring_rights_of_the_financial_entity]),
    Citations == [cite(eu_reg_2022_2554_art_30_3_e)].
test(critical_absent_art_30_3_open_asks_for_the_judgement) :-
    sufficiency_of(critical_absent_art_30_3_open, Result, Citations),
    Result == indeterminate([supports_critical_or_important_function]),
    Citations == [].
test(critical_absent_art_30_3_open_required_asks) :-
    required_of(critical_absent_art_30_3_open, Result, []),
    Result == indeterminate([supports_critical_or_important_function]).
test(critical_absent_art_30_3_open_missing_asks) :-
    missing_of(critical_absent_art_30_3_open, Result, []),
    Result == indeterminate([supports_critical_or_important_function]).
test(critical_absent_art_30_3_met_is_sufficient) :-
    sufficiency_of(critical_absent_art_30_3_met, Result, Citations),
    Result == sufficient,
    checked_citations(Citations).
test(critical_absent_art_30_3_met_misses_nothing) :-
    missing_of(critical_absent_art_30_3_met, none_missing, _).
test(critical_absent_art_30_3_met_required_still_asks) :-
    required_of(critical_absent_art_30_3_met, Result, []),
    Result == indeterminate([supports_critical_or_important_function]).
test(critical_unsure_required_is_referred) :-
    required_of(critical_unsure, Result, Citations),
    Result == needs_legal_review(open_textured(supports_critical_or_important_function, cite(eu_reg_2022_2554_art_30_3)), [inputs_relied_on([supports_critical_or_important_function - unsure, financial_entity_is_microenterprise - false])]),
    Citations == [].
test(critical_unsure_sufficiency_is_settled) :-
    sufficiency_of(critical_unsure, Result, _),
    Result == sufficient.
test(critical_unsure_microenterprise_absent_asks_first) :-
    required_of(critical_unsure_microenterprise_absent, Result, Citations),
    Result == indeterminate([financial_entity_is_microenterprise]),
    Citations == [].
test(document_unsure_is_referred_with_all_pairs) :-
    sufficiency_of(document_unsure, Result, Citations),
    Result = needs_legal_review(open_textured(ProfileKey, Citation), [inputs_relied_on(Pairs)]),
    ProfileKey == contract_is_single_written_document,
    Citation == cite(eu_reg_2022_2554_art_30_1),
    length(Pairs, 24),
    Citations == [].
test(document_unsure_missing_is_referred) :-
    missing_of(document_unsure, needs_legal_review(open_textured(contract_is_single_written_document, _), _), []).
test(base_false_and_absent_is_insufficient) :-
    sufficiency_of(base_false_and_absent, Result, Citations),
    Result == insufficient,
    checked_citations(Citations).
test(base_false_and_absent_missing_waits_for_the_absent_key) :-
    missing_of(base_false_and_absent, Result, Citations),
    Result == indeterminate([contract_provides_termination_for_significant_breach]),
    Citations == [].
test(duplicate_and_unknown_keys_are_refused) :-
    sufficiency_of(duplicate_and_unknown_keys, Result, Citations),
    Result == input_problems([duplicate_key(supports_critical_or_important_function), unknown_key(colour)]),
    Citations == [].
test(duplicate_and_unknown_keys_are_refused_by_every_query) :-
    required_of(duplicate_and_unknown_keys, input_problems(_), []),
    missing_of(duplicate_and_unknown_keys, input_problems(_), []).
test(duplicate_and_unknown_keys_input_check) :-
    dora_ict_third_party_contract_provisions_profile_for(duplicate_and_unknown_keys, Profile),
    dora_ict_third_party_contract_provisions_input_problems(Profile, Problems),
    Problems == [duplicate_key(supports_critical_or_important_function), unknown_key(colour)].
test(microenterprise_unsure_is_a_wrong_type) :-
    sufficiency_of(microenterprise_unsure, Result, []),
    Result == input_problems([wrong_type(financial_entity_is_microenterprise)]).
test(a_well_formed_fixture_has_no_input_problem) :-
    dora_ict_third_party_contract_provisions_profile_for(critical_all_met, Profile),
    dora_ict_third_party_contract_provisions_input_problems(Profile, Problems),
    Problems == [].
test(a_non_list_profile_is_a_wrong_type) :-
    dora_ict_third_party_contract_provisions_input_problems(not_a_profile, Problems),
    Problems == [wrong_type(profile)].

one_verdict(Subject) :-
    findall(Verdict, dora_ict_third_party_contract_provisions_assess(Subject, Verdict), Verdicts),
    length(Verdicts, 1).

non_empty_checklist(Subject) :-
    dora_ict_third_party_contract_provisions_profile_for(Subject, Profile),
    dora_ict_third_party_contract_provisions_decision_resolvable(Profile),
    dora_ict_third_party_contract_provisions_checklist(Profile, [_FirstItem|_OtherItems]).

met_cited_item(item(_, met, cite(_))).

test(critical_exit_strategy_false_is_not_sufficient, fail) :-
    sufficiency_of(critical_exit_strategy_false, sufficient, _).
test(not_critical_incident_assistance_false_is_not_sufficient, fail) :-
    sufficiency_of(not_critical_incident_assistance_false, sufficient, _).
test(not_critical_art_30_3_false_is_not_insufficient, fail) :-
    sufficiency_of(not_critical_art_30_3_false, insufficient, _).
test(microenterprise_delegation_refused_is_not_sufficient, fail) :-
    sufficiency_of(microenterprise_delegation_refused, sufficient, _).
test(critical_absent_art_30_3_met_is_not_indeterminate, fail) :-
    sufficiency_of(critical_absent_art_30_3_met, indeterminate(_), _).
test(critical_unsure_microenterprise_absent_is_not_referred, fail) :-
    required_of(critical_unsure_microenterprise_absent, needs_legal_review(_, _), _).
test(document_unsure_is_not_sufficient, fail) :-
    sufficiency_of(document_unsure, sufficient, _).

cp_test_names([every_subject_has_exactly_one_verdict, every_subject_has_a_non_empty_checklist, the_final_verdict_vocabulary, critical_all_met_is_sufficient, critical_all_met_verdict_through_assess, critical_all_met_misses_nothing, critical_all_met_requires_twenty_one, critical_all_met_checklist_cites_every_item, critical_exit_strategy_false_is_insufficient, critical_exit_strategy_false_lists_the_exit_strategy, not_critical_all_met_is_sufficient, not_critical_all_met_requires_the_base_list, not_critical_all_met_misses_nothing, not_critical_incident_assistance_false_is_insufficient, not_critical_incident_assistance_false_lists_it, not_critical_art_30_3_false_is_still_sufficient, not_critical_art_30_3_false_misses_nothing, microenterprise_delegation_is_sufficient, microenterprise_delegation_names_the_substitute, microenterprise_delegation_misses_nothing, microenterprise_delegation_refused_is_insufficient, microenterprise_delegation_refused_lists_the_substitute, not_microenterprise_delegation_is_insufficient, not_microenterprise_delegation_lists_the_own_rights, critical_absent_art_30_3_open_asks_for_the_judgement, critical_absent_art_30_3_open_required_asks, critical_absent_art_30_3_open_missing_asks, critical_absent_art_30_3_met_is_sufficient, critical_absent_art_30_3_met_misses_nothing, critical_absent_art_30_3_met_required_still_asks, critical_unsure_required_is_referred, critical_unsure_sufficiency_is_settled, critical_unsure_microenterprise_absent_asks_first, document_unsure_is_referred_with_all_pairs, document_unsure_missing_is_referred, base_false_and_absent_is_insufficient, base_false_and_absent_missing_waits_for_the_absent_key, duplicate_and_unknown_keys_are_refused, duplicate_and_unknown_keys_are_refused_by_every_query, duplicate_and_unknown_keys_input_check, microenterprise_unsure_is_a_wrong_type, a_well_formed_fixture_has_no_input_problem, a_non_list_profile_is_a_wrong_type]).
cp_test_fail_names([critical_exit_strategy_false_is_not_sufficient, not_critical_incident_assistance_false_is_not_sufficient, not_critical_art_30_3_false_is_not_insufficient, microenterprise_delegation_refused_is_not_sufficient, critical_absent_art_30_3_met_is_not_indeterminate, critical_unsure_microenterprise_absent_is_not_referred, document_unsure_is_not_sufficient]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
