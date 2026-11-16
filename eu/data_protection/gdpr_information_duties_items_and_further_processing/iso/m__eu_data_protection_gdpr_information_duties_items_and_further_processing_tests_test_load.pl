% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_information_duties_items_and_further_processing_tests_test_load, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_information_duties_items_and_further_processing_kernel, [gdpr_information_duties_items_and_further_processing_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_information_duties_items_and_further_processing_citations, [citation/2, implements/1]).

test(an_empty_attribute_list_has_no_problem) :-
    gdpr_information_duties_items_and_further_processing_input_problems([], []).
test(a_non_list_profile_is_wrong_type) :-
    gdpr_information_duties_items_and_further_processing_input_problems(not_a_profile, [wrong_type(profile)]).
test(other_purpose_information_is_not_an_item_provided) :-
    gdpr_information_duties_items_and_further_processing_input_problems([attribute(items_provided, [other_purpose_information])], [wrong_type(items_provided)]).
test(an_unknown_key_is_named) :-
    gdpr_information_duties_items_and_further_processing_input_problems([attribute(bogus_key, true)], [unknown_key(bogus_key)]).
test(the_verdict_atoms_are_distinct) :-
    dif(art13, art14),
    dif(eligible, ineligible),
    dif(eligible, not_applicable).
test(the_verdict_term_carries_status_and_citations) :-
    Verdict = information_route_verdict(art13, [cite(eu_reg_2016_679_art_13_1)]),
    Verdict = information_route_verdict(Status, Citations),
    Status == art13,
    Citations == [cite(eu_reg_2016_679_art_13_1)].
test(a_real_citation_is_recorded) :-
    citation(eu_reg_2016_679_art_13_1_a, _Record).
test(implements_accepts_a_recorded_key) :-
    implements(eu_reg_2016_679_art_14_4).

test(implements_refuses_an_unrecorded_key, fail) :-
    implements(eu_reg_2016_679_art_99_9).

cp_test_names([an_empty_attribute_list_has_no_problem, a_non_list_profile_is_wrong_type, other_purpose_information_is_not_an_item_provided, an_unknown_key_is_named, the_verdict_atoms_are_distinct, the_verdict_term_carries_status_and_citations, a_real_citation_is_recorded, implements_accepts_a_recorded_key]).
cp_test_fail_names([implements_refuses_an_unrecorded_key]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
