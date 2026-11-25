% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_register_of_information_tests_test_load, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_dora_register_of_information_kernel, [dora_register_of_information_input_problems/2, contract_keys/1, present_pairs/2, first_in_key_order/2]).
:- use_module(m__eu_dora_register_of_information_citations, [citation/2, implements/1, paragraph_of/2, fixed_citations/1]).

test(the_complete_query_atoms_are_distinct) :-
    dif(complete, incomplete).
test(the_outstanding_query_atom_is_distinct_from_the_complete_atoms) :-
    dif(none_outstanding, complete),
    dif(none_outstanding, incomplete).
test(the_judgement_value_unsure_is_distinct_from_the_booleans) :-
    dif(unsure, true),
    dif(unsure, false).
test(the_required_term_carries_its_duties) :-
    Result = required([register_at_entity_level, ranking_of_providers]),
    Result = required(Duties),
    Duties == [register_at_entity_level, ranking_of_providers].
test(the_outstanding_term_carries_its_duties) :-
    Result = outstanding([data_quality]),
    Result = outstanding(Duties),
    Duties == [data_quality].
test(the_indeterminate_term_carries_one_key) :-
    Result = indeterminate([register_maintained_and_updated_at_entity_level]),
    Result = indeterminate([Key]),
    Key == register_maintained_and_updated_at_entity_level.
test(the_indeterminate_compound_is_not_the_bare_atom) :-
    Result = indeterminate([competent_authority_requested_register]),
    dif(Result, indeterminate).
test(the_needs_legal_review_term_destructures) :-
    Result = needs_legal_review(open_textured(template_information_meets_data_quality_principles, cite(eu_reg_2024_2956_art_3_3)), [inputs_relied_on([template_information_meets_data_quality_principles - unsure])]),
    Result = needs_legal_review(open_textured(Key, cite(CitationKey)), [inputs_relied_on(Pairs)]),
    Key == template_information_meets_data_quality_principles,
    CitationKey == eu_reg_2024_2956_art_3_3,
    Pairs == [template_information_meets_data_quality_principles - unsure].
test(the_input_problems_term_destructures) :-
    Result = input_problems([wrong_type(profile)]),
    Result = input_problems(Problems),
    Problems == [wrong_type(profile)].
test(the_primary_citation_is_recorded) :-
    citation(eu_reg_2022_2554_art_28_3, _Record).
test(a_point_citation_is_recorded) :-
    citation(eu_reg_2024_2956_art_5_1_n, _Record).
test(the_primary_citation_is_implemented) :-
    implements(eu_reg_2022_2554_art_28_3).
test(a_point_maps_to_its_paragraph) :-
    paragraph_of(eu_reg_2024_2956_art_3_2_b, eu_reg_2024_2956_art_3_2).
test(the_fixed_citations_are_fourteen_recorded_keys) :-
    fixed_citations(Citations),
    length(Citations, 14),
    findall(Key, (member(cite(Key), Citations), citation(Key, _)), Recorded),
    length(Recorded, 14).
test(the_contract_has_forty_two_keys) :-
    contract_keys(Keys),
    length(Keys, 42).
test(an_empty_profile_has_no_input_problem) :-
    dora_register_of_information_input_problems([], Problems),
    Problems == [].
test(a_non_list_profile_is_wrong_type) :-
    dora_register_of_information_input_problems(not_a_profile, Problems),
    Problems == [wrong_type(profile)].
test(present_pairs_keep_contract_order) :-
    present_pairs([attribute(register_maintained_and_updated_at_entity_level, unsure), attribute(competent_authority_requested_register, false)], Pairs),
    Pairs == [competent_authority_requested_register - false, register_maintained_and_updated_at_entity_level - unsure].
test(the_first_key_in_contract_order_is_named) :-
    first_in_key_order([register_includes_terminology_and_closed_lists, register_maintained_and_updated_at_entity_level], Key),
    Key == register_maintained_and_updated_at_entity_level.

test(an_unrecorded_citation_is_not_implemented, fail) :-
    implements(eu_todo_primary_source).

cp_test_names([the_complete_query_atoms_are_distinct, the_outstanding_query_atom_is_distinct_from_the_complete_atoms, the_judgement_value_unsure_is_distinct_from_the_booleans, the_required_term_carries_its_duties, the_outstanding_term_carries_its_duties, the_indeterminate_term_carries_one_key, the_indeterminate_compound_is_not_the_bare_atom, the_needs_legal_review_term_destructures, the_input_problems_term_destructures, the_primary_citation_is_recorded, a_point_citation_is_recorded, the_primary_citation_is_implemented, a_point_maps_to_its_paragraph, the_fixed_citations_are_fourteen_recorded_keys, the_contract_has_forty_two_keys, an_empty_profile_has_no_input_problem, a_non_list_profile_is_wrong_type, present_pairs_keep_contract_order, the_first_key_in_contract_order_is_named]).
cp_test_fail_names([an_unrecorded_citation_is_not_implemented]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
