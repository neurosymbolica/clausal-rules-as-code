% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_rts_ict_operations_and_capacity_tests_test_load, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_dora_rts_ict_operations_and_capacity_kernel, [dora_rts_ict_operations_and_capacity_input_problems/2]).
:- use_module(m__eu_dora_rts_ict_operations_and_capacity_citations, [citation/2, implements/1]).

test(the_complete_query_atoms_are_distinct) :-
    dif(complete, incomplete),
    dif(complete, simplified_framework_entity),
    dif(incomplete, simplified_framework_entity).
test(the_outstanding_query_atom_is_distinct_from_the_gate_atom) :-
    dif(none_outstanding, simplified_framework_entity),
    dif(none_outstanding, complete).
test(the_judgement_value_unsure_is_not_a_boolean) :-
    dif(unsure, true),
    dif(unsure, false).
test(the_required_term_carries_its_duties) :-
    Result = required([ict_operations_policies_and_procedures, measures_for_long_procurement_or_resource_intensive_systems]),
    Result = required(Duties),
    Duties == [ict_operations_policies_and_procedures, measures_for_long_procurement_or_resource_intensive_systems].
test(the_outstanding_term_carries_its_duties) :-
    Result = outstanding([security_during_production_testing]),
    Result = outstanding(Duties),
    Duties == [security_during_production_testing].
test(the_indeterminate_term_names_one_key) :-
    Result = indeterminate([financial_entity_is_article_16_1_entity]),
    Result = indeterminate(MissingKeys),
    MissingKeys == [financial_entity_is_article_16_1_entity].
test(the_needs_legal_review_term_destructures) :-
    Result = needs_legal_review(open_textured(capacity_procedures_apply_resource_optimisation, cite(eu_reg_2024_1774_art_9_1_b)), [inputs_relied_on([financial_entity_is_article_16_1_entity - false, capacity_procedures_apply_resource_optimisation - unsure])]),
    Result = needs_legal_review(open_textured(Key, cite(CitationKey)), [inputs_relied_on(Pairs)]),
    Key == capacity_procedures_apply_resource_optimisation,
    CitationKey == eu_reg_2024_1774_art_9_1_b,
    Pairs == [financial_entity_is_article_16_1_entity - false, capacity_procedures_apply_resource_optimisation - unsure].
test(the_input_problems_term_destructures) :-
    Result = input_problems([duplicate_key(financial_entity_is_article_16_1_entity), unknown_key(colour)]),
    Result = input_problems([duplicate_key(DuplicateKey), unknown_key(UnknownKey)]),
    DuplicateKey == financial_entity_is_article_16_1_entity,
    UnknownKey == colour.
test(the_gate_citation_is_recorded) :-
    citation(eu_reg_2022_2554_art_16_1, _Record).
test(the_fixed_citations_are_recorded) :-
    citation(eu_reg_2024_1774_art_8_1, _RecordEightOne),
    citation(eu_reg_2024_1774_art_8_2, _RecordEightTwo),
    citation(eu_reg_2024_1774_art_9_1, _RecordNineOne),
    citation(eu_reg_2024_1774_art_9_2, _RecordNineTwo).
test(a_point_citation_is_recorded) :-
    citation(eu_reg_2024_1774_art_8_2_b_vii, [label - _Label, ref - _Reference, verbatim - Verbatim]),
    Verbatim == 'requirements to conduct the development and testing in production environments'.
test(the_provenance_marker_holds_for_a_recorded_key) :-
    implements(eu_reg_2024_1774_art_9_1_c_iii).
test(an_empty_profile_has_no_problem) :-
    dora_rts_ict_operations_and_capacity_input_problems([], Problems),
    Problems == [].
test(a_well_formed_profile_has_no_problem) :-
    dora_rts_ict_operations_and_capacity_input_problems([attribute(financial_entity_is_article_16_1_entity, false), attribute(capacity_procedures_apply_resource_optimisation, unsure)], Problems),
    Problems == [].
test(a_term_that_is_not_an_attribute_list_is_wrong_type_profile) :-
    dora_rts_ict_operations_and_capacity_input_problems(not_a_list, Problems),
    Problems == [wrong_type(profile)].
test(unsure_for_a_fact_key_is_wrong_type) :-
    dora_rts_ict_operations_and_capacity_input_problems([attribute(financial_entity_is_article_16_1_entity, unsure)], Problems),
    Problems == [wrong_type(financial_entity_is_article_16_1_entity)].
test(a_key_outside_the_contract_is_unknown) :-
    dora_rts_ict_operations_and_capacity_input_problems([attribute(colour, blue)], Problems),
    Problems == [unknown_key(colour)].

test(the_indeterminate_term_is_not_the_bare_atom, fail) :-
    indeterminate([financial_entity_is_article_16_1_entity]) = indeterminate.
test(the_provenance_marker_fails_for_an_unrecorded_key, fail) :-
    implements(eu_todo_primary_source).

cp_test_names([the_complete_query_atoms_are_distinct, the_outstanding_query_atom_is_distinct_from_the_gate_atom, the_judgement_value_unsure_is_not_a_boolean, the_required_term_carries_its_duties, the_outstanding_term_carries_its_duties, the_indeterminate_term_names_one_key, the_needs_legal_review_term_destructures, the_input_problems_term_destructures, the_gate_citation_is_recorded, the_fixed_citations_are_recorded, a_point_citation_is_recorded, the_provenance_marker_holds_for_a_recorded_key, an_empty_profile_has_no_problem, a_well_formed_profile_has_no_problem, a_term_that_is_not_an_attribute_list_is_wrong_type_profile, unsure_for_a_fact_key_is_wrong_type, a_key_outside_the_contract_is_unknown]).
cp_test_fail_names([the_indeterminate_term_is_not_the_bare_atom, the_provenance_marker_fails_for_an_unrecorded_key]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
