% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_nis2_lex_specialis_and_definitions_tests_test_load, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_nis2_lex_specialis_and_definitions_kernel, [nis2_lex_specialis_and_definitions_input_problems/2]).
:- use_module(m__eu_nis2_lex_specialis_and_definitions_citations, [citation/2, implements/1]).

test(the_final_answer_atoms_are_distinct) :-
    dif(nis2_provisions_disapplied, nis2_provisions_apply),
    dif(nis2_provisions_disapplied, out_of_scope),
    dif(nis2_provisions_apply, out_of_scope).
test(the_entity_class_atoms_are_distinct) :-
    dif(essential_entity, important_entity),
    dif(essential_entity, out_of_scope),
    dif(important_entity, out_of_scope).
test(the_judgement_atoms_are_distinct) :-
    dif(true, false),
    dif(true, unsure),
    dif(false, unsure).
test(the_verdict_term_carries_status_and_citations) :-
    Verdict = nis2_lex_specialis_and_definitions_verdict(nis2_groups(nis2_provisions_disapplied, nis2_provisions_apply), [cite(eu_dir_2022_2555_art_4_1)]),
    Verdict = nis2_lex_specialis_and_definitions_verdict(nis2_groups(RiskResult, NotificationResult), Citations),
    RiskResult == nis2_provisions_disapplied,
    NotificationResult == nis2_provisions_apply,
    Citations == [cite(eu_dir_2022_2555_art_4_1)].
test(the_indeterminate_status_holds_one_bare_key) :-
    Status = indeterminate([entity_class]),
    Status = indeterminate([MissingKey]),
    MissingKey == entity_class.
test(the_referral_status_builds_and_destructures) :-
    Status = needs_legal_review(open_textured(dora_risk_management_measures_at_least_equivalent_in_effect, cite(eu_dir_2022_2555_art_4_2_a)), [inputs_relied_on([entity_class - essential_entity, dora_risk_management_measures_at_least_equivalent_in_effect - unsure])]),
    Status = needs_legal_review(open_textured(Input, cite(CitationKey)), [inputs_relied_on(Pairs)]),
    Input == dora_risk_management_measures_at_least_equivalent_in_effect,
    CitationKey == eu_dir_2022_2555_art_4_2_a,
    Pairs == [entity_class - essential_entity, dora_risk_management_measures_at_least_equivalent_in_effect - unsure].
test(the_input_problems_status_builds_and_destructures) :-
    Status = input_problems([duplicate_key(entity_class), unknown_key(colour)]),
    Status = input_problems(Problems),
    Problems == [duplicate_key(entity_class), unknown_key(colour)].
test(the_article_4_1_citation_is_recorded) :-
    citation(eu_dir_2022_2555_art_4_1, _Record).
test(the_article_4_2_citation_is_recorded) :-
    citation(eu_dir_2022_2555_art_4_2, _Record).
test(the_article_4_2_a_citation_is_recorded) :-
    citation(eu_dir_2022_2555_art_4_2_a, _Record).
test(the_article_4_2_b_citation_is_recorded) :-
    citation(eu_dir_2022_2555_art_4_2_b, _Record).
test(the_dora_article_1_2_citation_is_recorded) :-
    citation(eu_reg_2022_2554_art_1_2, _Record).
test(the_citation_record_has_label_reference_and_verbatim) :-
    citation(eu_dir_2022_2555_art_4_2_a, [label - _Label, ref - _Reference, verbatim - _Verbatim]).
test(the_provenance_marker_succeeds_for_a_recorded_key) :-
    implements(eu_dir_2022_2555_art_4_1).
test(a_well_formed_profile_has_no_problem) :-
    findall(Problems, nis2_lex_specialis_and_definitions_input_problems([attribute(entity_class, essential_entity), attribute(dora_risk_management_measures_at_least_equivalent_in_effect, unsure)], Problems), Solutions),
    Solutions == [[]].
test(an_empty_profile_has_no_problem) :-
    findall(Problems, nis2_lex_specialis_and_definitions_input_problems([], Problems), Solutions),
    Solutions == [[]].
test(a_term_that_is_not_a_list_is_wrong_type_profile) :-
    findall(Problems, nis2_lex_specialis_and_definitions_input_problems(something_else, Problems), Solutions),
    Solutions == [[wrong_type(profile)]].
test(an_entity_class_outside_its_atoms_is_wrong_type) :-
    findall(Problems, nis2_lex_specialis_and_definitions_input_problems([attribute(entity_class, maybe)], Problems), Solutions),
    Solutions == [[wrong_type(entity_class)]].
test(a_repeated_contract_key_is_duplicate_key_and_then_unknown_keys) :-
    findall(Problems, nis2_lex_specialis_and_definitions_input_problems([attribute(colour, red), attribute(entity_class, essential_entity), attribute(entity_class, maybe)], Problems), Solutions),
    Solutions == [[duplicate_key(entity_class), unknown_key(colour)]].

test(the_provenance_marker_fails_for_an_unrecorded_key, fail) :-
    implements(eu_todo_primary_source).

cp_test_names([the_final_answer_atoms_are_distinct, the_entity_class_atoms_are_distinct, the_judgement_atoms_are_distinct, the_verdict_term_carries_status_and_citations, the_indeterminate_status_holds_one_bare_key, the_referral_status_builds_and_destructures, the_input_problems_status_builds_and_destructures, the_article_4_1_citation_is_recorded, the_article_4_2_citation_is_recorded, the_article_4_2_a_citation_is_recorded, the_article_4_2_b_citation_is_recorded, the_dora_article_1_2_citation_is_recorded, the_citation_record_has_label_reference_and_verbatim, the_provenance_marker_succeeds_for_a_recorded_key, a_well_formed_profile_has_no_problem, an_empty_profile_has_no_problem, a_term_that_is_not_a_list_is_wrong_type_profile, an_entity_class_outside_its_atoms_is_wrong_type, a_repeated_contract_key_is_duplicate_key_and_then_unknown_keys]).
cp_test_fail_names([the_provenance_marker_fails_for_an_unrecorded_key]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
