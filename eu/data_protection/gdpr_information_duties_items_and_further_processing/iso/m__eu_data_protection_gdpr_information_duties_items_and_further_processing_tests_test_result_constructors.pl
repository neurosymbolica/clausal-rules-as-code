% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_information_duties_items_and_further_processing_tests_test_result_constructors, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_information_duties_items_and_further_processing_kernel, [gdpr_information_duties_items_and_further_processing_input_problems/2]).

test(a_repeated_key_is_duplicate_key) :-
    gdpr_information_duties_items_and_further_processing_input_problems([attribute(items_provided, []), attribute(items_provided, [])], Problems),
    Problems == [duplicate_key(items_provided)].
test(a_single_key_has_no_problem) :-
    gdpr_information_duties_items_and_further_processing_input_problems([attribute(items_provided, [])], []).
test(an_attested_true_outside_fact_is_accepted) :-
    gdpr_information_duties_items_and_further_processing_input_problems([attribute(obtaining_or_disclosure_laid_down_by_law, attested(true, attestation(by, at, reason, none)))], Problems),
    Problems == [].
test(an_attested_false_outside_fact_is_accepted) :-
    gdpr_information_duties_items_and_further_processing_input_problems([attribute(professional_secrecy_obligation_by_law, attested(false, attestation(by, at, reason, none)))], Problems),
    Problems == [].
test(an_attested_value_outside_the_type_is_wrong_type) :-
    gdpr_information_duties_items_and_further_processing_input_problems([attribute(obtaining_or_disclosure_laid_down_by_law, attested(maybe, attestation(by, at, reason, none)))], Problems),
    Problems == [wrong_type(obtaining_or_disclosure_laid_down_by_law)].
test(an_outside_fact_without_attestation_is_wrong_type) :-
    gdpr_information_duties_items_and_further_processing_input_problems([attribute(professional_secrecy_obligation_by_law, attested(true, not_an_attestation))], Problems),
    Problems == [wrong_type(professional_secrecy_obligation_by_law)].
test(attested_public_holidays_are_accepted) :-
    gdpr_information_duties_items_and_further_processing_input_problems([attribute(public_holidays, attested([date(2026, 12, 25)], attestation(by, at, reason, none)))], Problems),
    Problems == [].
test(an_unattested_holiday_list_is_wrong_type) :-
    gdpr_information_duties_items_and_further_processing_input_problems([attribute(public_holidays, [date(2026, 12, 25)])], Problems),
    Problems == [wrong_type(public_holidays)].
test(the_attestation_term_has_four_parts) :-
    Attestation = attestation(operator, date(2026, 11, 7), ruling, none),
    Attestation = attestation(By, At, Reason, Evidence),
    By == operator,
    At == date(2026, 11, 7),
    Reason == ruling,
    Evidence == none.
test(the_attested_term_pairs_a_value_with_its_attestation) :-
    Fact = attested(true, attestation(by, at, reason, none)),
    Fact = attested(Value, Attestation),
    Value == true,
    Attestation = attestation(_, _, _, _).
test(the_provenance_term_marks_the_deciding_clause) :-
    Context = [inputs_relied_on([paragraph_2_information_relevant_to_further_processing - unsure]), provenance(further_processing_relevance, [cite(eu_reg_2016_679_art_13_3)])],
    Context = [_Relied, provenance(Clause, Citations)],
    Clause == further_processing_relevance,
    Citations == [cite(eu_reg_2016_679_art_13_3)].
test(the_url_term_pairs_a_label_with_an_address) :-
    Source = url(eur_lex, 'https://eur-lex.europa.eu/eli/reg/2016/679/oj'),
    Source = url(Label, Address),
    Label == eur_lex,
    Address == 'https://eur-lex.europa.eu/eli/reg/2016/679/oj'.
test(the_document_term_pairs_a_label_with_a_unit) :-
    Source = document(gdpr, '02016R0679-20160504#parag_013.003'),
    Source = document(Label, Unit),
    Label == gdpr,
    Unit == '02016R0679-20160504#parag_013.003'.

test(a_single_key_is_not_duplicate_key, fail) :-
    gdpr_information_duties_items_and_further_processing_input_problems([attribute(items_provided, [])], [duplicate_key(items_provided)]).
test(a_url_is_not_a_document, fail) :-
    url(eur_lex, address) = document(_, _).

cp_test_names([a_repeated_key_is_duplicate_key, a_single_key_has_no_problem, an_attested_true_outside_fact_is_accepted, an_attested_false_outside_fact_is_accepted, an_attested_value_outside_the_type_is_wrong_type, an_outside_fact_without_attestation_is_wrong_type, attested_public_holidays_are_accepted, an_unattested_holiday_list_is_wrong_type, the_attestation_term_has_four_parts, the_attested_term_pairs_a_value_with_its_attestation, the_provenance_term_marks_the_deciding_clause, the_url_term_pairs_a_label_with_an_address, the_document_term_pairs_a_label_with_a_unit]).
cp_test_fail_names([a_single_key_is_not_duplicate_key, a_url_is_not_a_document]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
