% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_ict_third_party_entity_duties_tests_test_load, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_dora_ict_third_party_entity_duties_kernel, [dora_ict_third_party_entity_duties_input_problems/2]).
:- use_module(m__eu_dora_ict_third_party_entity_duties_citations, [citation/2, implements/1]).

test(an_empty_profile_has_no_problem) :-
    dora_ict_third_party_entity_duties_input_problems([], Problems),
    Problems == [].
test(a_well_formed_profile_has_no_problem) :-
    dora_ict_third_party_entity_duties_input_problems([attribute(supports_critical_or_important_function, unsure), attribute(entity_exercises_access_inspection_and_audit_rights, true), attribute(financial_entity_is_microenterprise, false)], Problems),
    Problems == [].
test(a_term_that_is_not_a_list_is_not_a_profile) :-
    dora_ict_third_party_entity_duties_input_problems(profile, Problems),
    Problems == [wrong_type(profile)].
test(an_unbound_profile_is_not_a_profile) :-
    dora_ict_third_party_entity_duties_input_problems(_Unbound, Problems),
    Problems == [wrong_type(profile)].
test(a_list_with_a_foreign_element_is_not_a_profile) :-
    dora_ict_third_party_entity_duties_input_problems([attribute(supports_critical_or_important_function, true), stray], Problems),
    Problems == [wrong_type(profile)].
test(unsure_is_wrong_type_for_a_fact_key) :-
    dora_ict_third_party_entity_duties_input_problems([attribute(entity_exercises_access_inspection_and_audit_rights, unsure)], Problems),
    Problems == [wrong_type(entity_exercises_access_inspection_and_audit_rights)].
test(unsure_is_in_type_for_a_judgement_key) :-
    dora_ict_third_party_entity_duties_input_problems([attribute(arrangement_entails_high_technical_complexity, unsure)], Problems),
    Problems == [].
test(a_repeated_key_is_a_duplicate_and_never_wrong_type) :-
    dora_ict_third_party_entity_duties_input_problems([attribute(exit_strategy_in_place, maybe), attribute(exit_strategy_in_place, true)], Problems),
    Problems == [duplicate_key(exit_strategy_in_place)].
test(contract_problems_come_before_unknown_keys) :-
    dora_ict_third_party_entity_duties_input_problems([attribute(stray_key, true), attribute(supports_critical_or_important_function, maybe), attribute(stray_key, false)], Problems),
    Problems == [wrong_type(supports_critical_or_important_function), unknown_key(stray_key)].
test(the_input_check_has_exactly_one_answer) :-
    findall(Problems, dora_ict_third_party_entity_duties_input_problems([attribute(considered_concentration_risk, false)], Problems), Answers),
    Answers == [[]].
test(the_required_result_destructures) :-
    Result = required([assessment_of_critical_or_important_function, provider_with_appropriate_information_security_standards]),
    Result = required(Duties),
    Duties == [assessment_of_critical_or_important_function, provider_with_appropriate_information_security_standards].
test(the_outstanding_result_destructures) :-
    Result = outstanding([exit_strategy]),
    Result = outstanding(Duties),
    Duties == [exit_strategy].
test(the_indeterminate_status_carries_one_key) :-
    Status = indeterminate([supports_critical_or_important_function]),
    Status = indeterminate([MissingKey]),
    MissingKey == supports_critical_or_important_function.
test(the_referral_status_destructures) :-
    Status = needs_legal_review(open_textured(supports_critical_or_important_function, cite(eu_reg_2022_2554_art_28_4_a)), [inputs_relied_on([supports_critical_or_important_function - unsure])]),
    Status = needs_legal_review(open_textured(Key, cite(Citation)), [inputs_relied_on(Pairs)]),
    Key == supports_critical_or_important_function,
    Citation == eu_reg_2022_2554_art_28_4_a,
    Pairs == [supports_critical_or_important_function - unsure].
test(the_verdict_term_carries_status_and_citations) :-
    Verdict = dora_ict_third_party_entity_duties_verdict(complete, [cite(eu_reg_2022_2554_art_28_4)]),
    Verdict = dora_ict_third_party_entity_duties_verdict(Status, Citations),
    Status == complete,
    Citations == [cite(eu_reg_2022_2554_art_28_4)].
test(the_completeness_atoms_are_distinct) :-
    dif(complete, incomplete).
test(the_outstanding_atom_differs_from_complete) :-
    dif(none_outstanding, complete).
test(the_strategy_atoms_are_distinct) :-
    dif(strategy_required, strategy_not_required).
test(the_art_28_4_citation_is_recorded) :-
    citation(eu_reg_2022_2554_art_28_4, _Record).
test(the_art_28_2_citation_is_recorded) :-
    citation(eu_reg_2022_2554_art_28_2, [label - _Label, ref - _Reference, verbatim - _Verbatim]).
test(implements_succeeds_for_a_recorded_key) :-
    implements(eu_reg_2022_2554_art_29_2).

test(complete_is_not_incomplete, fail) :-
    complete = incomplete.
test(the_placeholder_citation_is_not_recorded, fail) :-
    citation(eu_todo_primary_source, _Record).
test(implements_fails_for_an_unrecorded_key, fail) :-
    implements(eu_reg_2022_2554_art_28_7).

cp_test_names([an_empty_profile_has_no_problem, a_well_formed_profile_has_no_problem, a_term_that_is_not_a_list_is_not_a_profile, an_unbound_profile_is_not_a_profile, a_list_with_a_foreign_element_is_not_a_profile, unsure_is_wrong_type_for_a_fact_key, unsure_is_in_type_for_a_judgement_key, a_repeated_key_is_a_duplicate_and_never_wrong_type, contract_problems_come_before_unknown_keys, the_input_check_has_exactly_one_answer, the_required_result_destructures, the_outstanding_result_destructures, the_indeterminate_status_carries_one_key, the_referral_status_destructures, the_verdict_term_carries_status_and_citations, the_completeness_atoms_are_distinct, the_outstanding_atom_differs_from_complete, the_strategy_atoms_are_distinct, the_art_28_4_citation_is_recorded, the_art_28_2_citation_is_recorded, implements_succeeds_for_a_recorded_key]).
cp_test_fail_names([complete_is_not_incomplete, the_placeholder_citation_is_not_recorded, implements_fails_for_an_unrecorded_key]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
