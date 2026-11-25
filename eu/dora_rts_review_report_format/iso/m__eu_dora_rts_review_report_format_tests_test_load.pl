% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_rts_review_report_format_tests_test_load, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_dora_rts_review_report_format_kernel, [dora_rts_review_report_format_input_problems/2]).
:- use_module(m__eu_dora_rts_review_report_format_citations, [citation/2, implements/1]).

test(the_input_check_accepts_an_empty_profile) :-
    dora_rts_review_report_format_input_problems([], Problems),
    Problems == [].
test(the_input_check_refuses_a_non_list_profile) :-
    dora_rts_review_report_format_input_problems(not_a_profile, Problems),
    Problems == [wrong_type(profile)].
test(the_input_check_names_an_unknown_key) :-
    dora_rts_review_report_format_input_problems([attribute(entity_colour, blue)], Problems),
    Problems == [unknown_key(entity_colour)].
test(the_input_check_gives_exactly_one_answer) :-
    findall(Problems, dora_rts_review_report_format_input_problems([attribute(financial_entity_is_article_16_1_entity, false), attribute(authority_requested_framework_review_report, true)], Problems), AllProblems),
    AllProblems == [[]].
test(the_required_term_carries_its_duties) :-
    Result = required([report_in_searchable_electronic_format, report_uses_external_sources]),
    Result = required(Duties),
    Duties == [report_in_searchable_electronic_format, report_uses_external_sources].
test(the_outstanding_term_carries_its_duties) :-
    Result = outstanding([report_states_approval_date]),
    Result = outstanding(Duties),
    Duties == [report_states_approval_date].
test(the_indeterminate_term_carries_one_key) :-
    Result = indeterminate([financial_entity_is_article_16_1_entity]),
    Result = indeterminate([MissingKey]),
    MissingKey == financial_entity_is_article_16_1_entity.
test(the_referral_term_carries_reason_and_context) :-
    Result = needs_legal_review(open_textured(review_report_describes_context, cite(eu_reg_2024_1774_art_27_2_a_ii)), [inputs_relied_on([financial_entity_is_article_16_1_entity - false, review_report_describes_context - unsure])]),
    Result = needs_legal_review(open_textured(Key, cite(CitationKey)), [inputs_relied_on(Pairs)]),
    Key == review_report_describes_context,
    CitationKey == eu_reg_2024_1774_art_27_2_a_ii,
    Pairs == [financial_entity_is_article_16_1_entity - false, review_report_describes_context - unsure].
test(the_input_problems_term_carries_its_problems) :-
    Result = input_problems([duplicate_key(financial_entity_is_microenterprise), unknown_key(colour)]),
    Result = input_problems(Problems),
    Problems == [duplicate_key(financial_entity_is_microenterprise), unknown_key(colour)].
test(the_verdict_term_carries_status_and_citations) :-
    Verdict = dora_rts_review_report_format_verdict(complete, [cite(eu_reg_2024_1774_art_27_1), cite(eu_reg_2024_1774_art_27_2)]),
    Verdict = dora_rts_review_report_format_verdict(Status, Citations),
    Status == complete,
    Citations == [cite(eu_reg_2024_1774_art_27_1), cite(eu_reg_2024_1774_art_27_2)].
test(the_completeness_atoms_are_distinct) :-
    dif(complete, incomplete),
    dif(complete, none_outstanding),
    dif(incomplete, none_outstanding).
test(the_gate_and_request_atoms_are_distinct) :-
    dif(simplified_framework_entity, framework_review_report_not_requested),
    dif(simplified_framework_entity, complete),
    dif(framework_review_report_not_requested, incomplete).
test(the_judgement_value_is_not_a_boolean) :-
    dif(unsure, true),
    dif(unsure, false).
test(the_format_citation_is_recorded) :-
    citation(eu_reg_2024_1774_art_27_1, Record),
    member(ref - Reference, Record),
    Reference == '32024R1774#parag_027.001'.
test(the_content_citation_is_recorded) :-
    citation(eu_reg_2024_1774_art_27_2, _Record).
test(the_gate_citation_is_recorded) :-
    citation(eu_reg_2022_2554_art_16_1, _Record).
test(the_request_marker_resolves) :-
    implements(eu_reg_2022_2554_art_6_5).

test(a_well_formed_profile_is_not_refused, fail) :-
    dora_rts_review_report_format_input_problems([attribute(authority_requested_framework_review_report, true)], [_|_]).
test(a_final_atom_is_not_a_status_compound, fail) :-
    complete = indeterminate(_).
test(a_shortened_citation_is_not_recorded, fail) :-
    citation(art_27_1, _Record).

cp_test_names([the_input_check_accepts_an_empty_profile, the_input_check_refuses_a_non_list_profile, the_input_check_names_an_unknown_key, the_input_check_gives_exactly_one_answer, the_required_term_carries_its_duties, the_outstanding_term_carries_its_duties, the_indeterminate_term_carries_one_key, the_referral_term_carries_reason_and_context, the_input_problems_term_carries_its_problems, the_verdict_term_carries_status_and_citations, the_completeness_atoms_are_distinct, the_gate_and_request_atoms_are_distinct, the_judgement_value_is_not_a_boolean, the_format_citation_is_recorded, the_content_citation_is_recorded, the_gate_citation_is_recorded, the_request_marker_resolves]).
cp_test_fail_names([a_well_formed_profile_is_not_refused, a_final_atom_is_not_a_status_compound, a_shortened_citation_is_not_recorded]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
