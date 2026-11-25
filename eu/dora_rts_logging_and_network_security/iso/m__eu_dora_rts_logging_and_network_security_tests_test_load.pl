% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_rts_logging_and_network_security_tests_test_load, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_dora_rts_logging_and_network_security_kernel, [dora_rts_logging_and_network_security_input_problems/2]).
:- use_module(m__eu_dora_rts_logging_and_network_security_citations, [citation/2, implements/1]).

test(the_completeness_atoms_are_distinct) :-
    dif(complete, incomplete),
    dif(complete, simplified_framework_entity),
    dif(incomplete, simplified_framework_entity).
test(the_outstanding_atoms_are_distinct) :-
    dif(none_outstanding, simplified_framework_entity),
    dif(none_outstanding, complete).
test(the_judgement_values_are_distinct) :-
    dif(true, false),
    dif(true, unsure),
    dif(false, unsure).
test(the_required_term_carries_its_duties) :-
    Result = required([logging_procedures_protocols_and_tools, log_retention_period]),
    Result = required(Duties),
    Duties == [logging_procedures_protocols_and_tools, log_retention_period].
test(the_outstanding_term_carries_its_duties) :-
    Result = outstanding([network_design]),
    Result = outstanding(Duties),
    Duties == [network_design].
test(the_indeterminate_term_names_one_key) :-
    Result = indeterminate([financial_entity_is_article_16_1_entity]),
    Result = indeterminate([Key]),
    Key == financial_entity_is_article_16_1_entity.
test(the_referral_term_carries_reason_and_context) :-
    Result = needs_legal_review(open_textured(network_connections_encrypted, cite(eu_reg_2024_1774_art_13_e)), [inputs_relied_on([financial_entity_is_article_16_1_entity - false, network_connections_encrypted - unsure])]),
    Result = needs_legal_review(open_textured(Key, cite(CitationKey)), [inputs_relied_on(Pairs)]),
    Key == network_connections_encrypted,
    CitationKey == eu_reg_2024_1774_art_13_e,
    Pairs == [financial_entity_is_article_16_1_entity - false, network_connections_encrypted - unsure].
test(the_input_problems_term_carries_its_list) :-
    Result = input_problems([wrong_type(profile)]),
    Result = input_problems([Problem]),
    Problem == wrong_type(profile).
test(the_input_check_accepts_an_empty_profile) :-
    dora_rts_logging_and_network_security_input_problems([], []).
test(the_input_check_refuses_a_non_list_profile) :-
    dora_rts_logging_and_network_security_input_problems(profile, [wrong_type(profile)]).
test(the_input_check_names_an_unknown_key) :-
    dora_rts_logging_and_network_security_input_problems([attribute(colour, blue)], [unknown_key(colour)]).
test(the_input_check_accepts_unsure_for_a_judgement) :-
    dora_rts_logging_and_network_security_input_problems([attribute(network_connections_encrypted, unsure)], []).
test(the_gate_citation_is_recorded) :-
    citation(eu_reg_2022_2554_art_16_1, _Record).
test(the_logging_citation_is_recorded) :-
    citation(eu_reg_2024_1774_art_12_1, Record),
    Record = [label - _, ref - _, verbatim - _].
test(the_network_security_citation_is_implemented) :-
    implements(eu_reg_2024_1774_art_13).
test(the_information_in_transit_citation_is_implemented) :-
    implements(eu_reg_2024_1774_art_14_2).

test(the_input_check_does_not_accept_unsure_for_a_judgement_as_wrong, fail) :-
    dora_rts_logging_and_network_security_input_problems([attribute(network_connections_encrypted, unsure)], [wrong_type(network_connections_encrypted)]).
test(a_shortened_citation_is_not_recorded, fail) :-
    citation(art_13, _Record).

cp_test_names([the_completeness_atoms_are_distinct, the_outstanding_atoms_are_distinct, the_judgement_values_are_distinct, the_required_term_carries_its_duties, the_outstanding_term_carries_its_duties, the_indeterminate_term_names_one_key, the_referral_term_carries_reason_and_context, the_input_problems_term_carries_its_list, the_input_check_accepts_an_empty_profile, the_input_check_refuses_a_non_list_profile, the_input_check_names_an_unknown_key, the_input_check_accepts_unsure_for_a_judgement, the_gate_citation_is_recorded, the_logging_citation_is_recorded, the_network_security_citation_is_implemented, the_information_in_transit_citation_is_implemented]).
cp_test_fail_names([the_input_check_does_not_accept_unsure_for_a_judgement_as_wrong, a_shortened_citation_is_not_recorded]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
