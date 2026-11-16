% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_administrative_fine_maximum_tests_test_load, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_administrative_fine_maximum_kernel, [gdpr_administrative_fine_maximum_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_administrative_fine_maximum_citations, [citation/2]).

test(an_empty_attribute_list_has_no_problem) :-
    gdpr_administrative_fine_maximum_input_problems([], []).
test(a_well_formed_profile_has_no_problem) :-
    gdpr_administrative_fine_maximum_input_problems([attribute(infringed_provisions, [article_5]), attribute(infringer_is_undertaking, unsure), attribute(total_worldwide_annual_turnover_in_euros, 0)], []).
test(a_negative_turnover_is_a_wrong_type) :-
    gdpr_administrative_fine_maximum_input_problems([attribute(total_worldwide_annual_turnover_in_euros, -1)], [wrong_type(total_worldwide_annual_turnover_in_euros)]).
test(a_key_outside_the_contract_is_unknown) :-
    gdpr_administrative_fine_maximum_input_problems([attribute(surprise_key, 1)], [unknown_key(surprise_key)]).
test(a_repeated_key_is_a_duplicate) :-
    gdpr_administrative_fine_maximum_input_problems([attribute(infringer_is_undertaking, true), attribute(infringer_is_undertaking, false)], [duplicate_key(infringer_is_undertaking)]).
test(a_non_list_is_not_a_profile) :-
    gdpr_administrative_fine_maximum_input_problems(not_a_profile, [wrong_type(profile)]).
test(the_final_verdict_atoms_are_distinct) :-
    dif(fine_maximum, separate_fine_maxima).
test(the_verdict_term_carries_status_and_citations) :-
    Verdict = gdpr_administrative_fine_maximum_verdict(fine_maximum(lower_maximum_tier, fixed_amount, 1000000000), []),
    Verdict = gdpr_administrative_fine_maximum_verdict(Status, Citations),
    Status == fine_maximum(lower_maximum_tier, fixed_amount, 1000000000),
    Citations == [].
test(a_real_citation_record_resolves) :-
    citation(eu_reg_2016_679_art_83_4, _Record).

cp_test_names([an_empty_attribute_list_has_no_problem, a_well_formed_profile_has_no_problem, a_negative_turnover_is_a_wrong_type, a_key_outside_the_contract_is_unknown, a_repeated_key_is_a_duplicate, a_non_list_is_not_a_profile, the_final_verdict_atoms_are_distinct, the_verdict_term_carries_status_and_citations, a_real_citation_record_resolves]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
