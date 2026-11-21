% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_ai_act_high_risk_requirements_tests_test_load, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_ai_act_high_risk_requirements_kernel, [high_risk_requirements_input_problems/2, high_risk_requirements_valid_date_t/2, high_risk_requirements_day_before_t/3]).
:- use_module(m__eu_ai_act_high_risk_requirements_citations, [citation/2, implements/1, citation_vocabulary/1]).

test(the_kernel_input_check_loads_and_accepts_an_empty_profile) :-
    high_risk_requirements_input_problems([], Problems),
    Problems == [].
test(the_kernel_input_check_names_an_unknown_key) :-
    high_risk_requirements_input_problems([attribute(colour, red)], Problems),
    Problems == [unknown_key(colour)].
test(the_kernel_input_check_refuses_a_non_list_profile) :-
    high_risk_requirements_input_problems(not_a_list, Problems),
    Problems == [wrong_type(profile)].
test(the_kernel_date_check_accepts_the_chapter_iii_date) :-
    high_risk_requirements_valid_date_t(date(2027, 12, 2), true).
test(the_kernel_date_literal_is_strict) :-
    high_risk_requirements_day_before_t(date(2027, 12, 1), date(2027, 12, 2), true),
    high_risk_requirements_day_before_t(date(2027, 12, 2), date(2027, 12, 2), false).
test(the_verdict_term_carries_result_and_citations) :-
    Verdict = high_risk_requirements_verdict(requirement_applies, [cite(eu_reg_2024_1689_art_8_1), cite(eu_reg_2024_1689_art_9_1)]),
    Verdict = high_risk_requirements_verdict(Result, Citations),
    Result == requirement_applies,
    Citations == [cite(eu_reg_2024_1689_art_8_1), cite(eu_reg_2024_1689_art_9_1)].
test(the_indeterminate_status_holds_one_bare_key) :-
    Status = indeterminate([system_is_a_high_risk_ai_system_listed_in_annex_iii]),
    Status = indeterminate([Key]),
    Key == system_is_a_high_risk_ai_system_listed_in_annex_iii.
test(the_referral_status_destructures) :-
    Status = needs_legal_review(open_textured(intended_to_be_used_by_public_authorities, cite(eu_reg_2024_1689_art_111_2)), [inputs_relied_on([intended_to_be_used_by_public_authorities - unsure])]),
    Status = needs_legal_review(open_textured(Judgement, cite(CitationKey)), [inputs_relied_on(Pairs)]),
    Judgement == intended_to_be_used_by_public_authorities,
    CitationKey == eu_reg_2024_1689_art_111_2,
    Pairs == [intended_to_be_used_by_public_authorities - unsure].
test(the_input_problems_status_destructures) :-
    Status = input_problems([duplicate_key(system_is_a_component_of_products), wrong_type(requirement), unknown_key(colour)]),
    Status = input_problems([First|Rest]),
    First == duplicate_key(system_is_a_component_of_products),
    Rest == [wrong_type(requirement), unknown_key(colour)].
test(the_requirement_result_atoms_are_distinct) :-
    Atoms = [not_applicable_on_date, not_a_high_risk_ai_system, requirement_does_not_apply, compliance_required_by_31_december_2030, existing_system_without_significant_changes_not_covered, compliance_required_by_2_august_2030, requirement_applies_to_testing_data_sets_only, requirement_applies_and_the_simplified_form_may_be_used, requirement_applies],
    sort(Atoms, Sorted),
    length(Sorted, 9).
test(the_element_result_atoms_are_distinct) :-
    dif(element_not_required, element_required),
    dif(element_required_subject_to_an_open_condition, element_required),
    dif(element_not_required, element_required_subject_to_an_open_condition).
test(the_applies_atom_is_not_the_does_not_apply_atom) :-
    dif(requirement_applies, requirement_does_not_apply).
test(the_article_8_1_citation_is_recorded) :-
    citation(eu_reg_2024_1689_art_8_1, Record),
    Record = [label - _, ref - Reference, verbatim - _],
    Reference == '02024R1689-20260727#parag_008.001'.
test(the_article_113_c_i_citation_is_in_the_vocabulary) :-
    citation_vocabulary(eu_reg_2024_1689_art_113_c_i),
    implements(eu_reg_2024_1689_art_113_c_i).
test(a_provenance_only_key_implements_but_is_not_returnable) :-
    implements(eu_reg_2024_1689_art_3_8).

test(a_provenance_only_key_is_not_in_the_vocabulary, fail) :-
    citation_vocabulary(eu_reg_2024_1689_art_3_8).
test(the_placeholder_citation_is_gone, fail) :-
    citation(eu_todo_primary_source, _).

cp_test_names([the_kernel_input_check_loads_and_accepts_an_empty_profile, the_kernel_input_check_names_an_unknown_key, the_kernel_input_check_refuses_a_non_list_profile, the_kernel_date_check_accepts_the_chapter_iii_date, the_kernel_date_literal_is_strict, the_verdict_term_carries_result_and_citations, the_indeterminate_status_holds_one_bare_key, the_referral_status_destructures, the_input_problems_status_destructures, the_requirement_result_atoms_are_distinct, the_element_result_atoms_are_distinct, the_applies_atom_is_not_the_does_not_apply_atom, the_article_8_1_citation_is_recorded, the_article_113_c_i_citation_is_in_the_vocabulary, a_provenance_only_key_implements_but_is_not_returnable]).
cp_test_fail_names([a_provenance_only_key_is_not_in_the_vocabulary, the_placeholder_citation_is_gone]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
