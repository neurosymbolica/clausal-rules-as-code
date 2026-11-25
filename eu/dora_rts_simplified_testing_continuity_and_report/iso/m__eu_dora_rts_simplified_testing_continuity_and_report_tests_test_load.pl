% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_rts_simplified_testing_continuity_and_report_tests_test_load, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_dora_rts_simplified_testing_continuity_and_report_kernel, [dora_rts_simplified_testing_continuity_and_report_input_problems/2]).
:- use_module(m__eu_dora_rts_simplified_testing_continuity_and_report_citations, [citation/2, implements/1]).

test(the_complete_query_atoms_are_distinct) :-
    dif(complete, incomplete),
    dif(complete, not_article_16_1_entity),
    dif(incomplete, not_article_16_1_entity).
test(the_outstanding_query_atoms_are_distinct) :-
    dif(none_outstanding, not_article_16_1_entity),
    dif(none_outstanding, complete).
test(the_judgement_value_is_not_a_boolean) :-
    dif(unsure, true),
    dif(unsure, false).
test(the_required_term_carries_its_duties) :-
    Result = required([ict_security_testing_plan, review_and_testing_of_security_measures]),
    Result = required(Duties),
    Duties == [ict_security_testing_plan, review_and_testing_of_security_measures].
test(the_outstanding_term_carries_its_duties) :-
    Result = outstanding([report_overall_conclusions]),
    Result = outstanding(Duties),
    Duties == [report_overall_conclusions].
test(the_indeterminate_term_names_one_key) :-
    Result = indeterminate([financial_entity_is_article_16_1_entity]),
    Result = indeterminate([Key]),
    Key == financial_entity_is_article_16_1_entity.
test(the_referral_term_carries_reason_and_context) :-
    Result = needs_legal_review(open_textured(ict_security_testing_plan_established_and_implemented, cite(eu_reg_2024_1774_art_36_1)), [inputs_relied_on([financial_entity_is_article_16_1_entity - true, ict_security_testing_plan_established_and_implemented - unsure])]),
    Result = needs_legal_review(open_textured(Key, Citation), [inputs_relied_on(Pairs)]),
    Key == ict_security_testing_plan_established_and_implemented,
    Citation == cite(eu_reg_2024_1774_art_36_1),
    Pairs == [financial_entity_is_article_16_1_entity - true, ict_security_testing_plan_established_and_implemented - unsure].
test(the_input_problems_term_carries_its_problems) :-
    Result = input_problems([wrong_type(financial_entity_is_article_16_1_entity)]),
    Result = input_problems([Problem]),
    Problem == wrong_type(financial_entity_is_article_16_1_entity).
test(the_verdict_term_carries_status_and_citations) :-
    Verdict = dora_rts_simplified_testing_continuity_and_report_verdict(complete, [cite(eu_reg_2022_2554_art_16_1)]),
    Verdict = dora_rts_simplified_testing_continuity_and_report_verdict(Status, Citations),
    Status == complete,
    Citations == [cite(eu_reg_2022_2554_art_16_1)].
test(the_gate_citation_is_recorded) :-
    citation(eu_reg_2022_2554_art_16_1, _Record).
test(the_report_content_citation_is_recorded) :-
    citation(eu_reg_2024_1774_art_41_2, _Record).
test(the_testing_plan_citation_is_recorded) :-
    implements(eu_reg_2024_1774_art_36_1).
test(an_empty_profile_has_no_problem) :-
    dora_rts_simplified_testing_continuity_and_report_input_problems([], []).
test(an_unsure_trigger_is_wrong_type) :-
    dora_rts_simplified_testing_continuity_and_report_input_problems([attribute(authority_requested_framework_review_report, unsure)], [wrong_type(authority_requested_framework_review_report)]).
test(an_unsure_judgement_is_well_formed) :-
    dora_rts_simplified_testing_continuity_and_report_input_problems([attribute(financial_entity_is_article_16_1_entity, true), attribute(review_report_states_overall_conclusions, unsure)], []).

test(the_required_term_is_not_the_bare_atom, fail) :-
    required([ict_security_testing_plan]) = required.
test(the_placeholder_citation_is_gone, fail) :-
    citation(eu_todo_primary_source, _Record).
test(a_well_formed_profile_is_not_refused, fail) :-
    dora_rts_simplified_testing_continuity_and_report_input_problems([attribute(financial_entity_is_article_16_1_entity, false)], [_|_]).

cp_test_names([the_complete_query_atoms_are_distinct, the_outstanding_query_atoms_are_distinct, the_judgement_value_is_not_a_boolean, the_required_term_carries_its_duties, the_outstanding_term_carries_its_duties, the_indeterminate_term_names_one_key, the_referral_term_carries_reason_and_context, the_input_problems_term_carries_its_problems, the_verdict_term_carries_status_and_citations, the_gate_citation_is_recorded, the_report_content_citation_is_recorded, the_testing_plan_citation_is_recorded, an_empty_profile_has_no_problem, an_unsure_trigger_is_wrong_type, an_unsure_judgement_is_well_formed]).
cp_test_fail_names([the_required_term_is_not_the_bare_atom, the_placeholder_citation_is_gone, a_well_formed_profile_is_not_refused]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
