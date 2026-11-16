% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_information_duties_headline_verdict_tests_test_load, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_information_duties_headline_verdict_kernel, [gdpr_information_duties_headline_verdict_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_information_duties_headline_verdict_citations, [citation/2, implements/1]).

test(the_headline_verdict_atoms_are_distinct) :-
    dif(eligible, ineligible).
test(the_exemption_atoms_are_distinct) :-
    dif(none, impossible_or_disproportionate_effort),
    dif(law_lays_down_obtaining_or_disclosure, professional_secrecy_obligation).
test(the_verdict_term_carries_status_and_citations) :-
    Verdict = information_duty_verdict_verdict(eligible, [cite(eu_reg_2016_679_art_14_1)]),
    Verdict = information_duty_verdict_verdict(Status, Citations),
    Status == eligible,
    Citations == [cite(eu_reg_2016_679_art_14_1)].
test(the_exemption_term_carries_status_and_citations) :-
    Verdict = information_duty_exemption_verdict(none, []),
    Verdict = information_duty_exemption_verdict(Status, Citations),
    Status == none,
    Citations == [].
test(the_non_final_answers_build_and_destructure) :-
    Missing = indeterminate([personal_data_collected_from_data_subject]),
    Missing = indeterminate(Keys),
    Keys == [personal_data_collected_from_data_subject],
    Review = needs_legal_review(open_textured(provision_impossible_or_disproportionate_effort, cite(eu_reg_2016_679_art_14_5_b)), [inputs_relied_on([])]),
    Review = needs_legal_review(open_textured(Key, cite(Citation)), [inputs_relied_on(Pairs)]),
    Key == provision_impossible_or_disproportionate_effort,
    Citation == eu_reg_2016_679_art_14_5_b,
    Pairs == [].
test(a_real_citation_record_resolves) :-
    citation(eu_reg_2016_679_art_14_5_b, _Record).
test(a_real_citation_key_is_implemented) :-
    implements(eu_reg_2016_679_art_13_1).
test(an_empty_profile_has_no_input_problem) :-
    gdpr_information_duties_headline_verdict_input_problems([], []).
test(a_non_list_profile_is_wrong_type_profile) :-
    gdpr_information_duties_headline_verdict_input_problems(not_a_profile, [wrong_type(profile)]).

test(an_unrecorded_citation_key_does_not_resolve, fail) :-
    citation(eu_reg_2016_679_art_14_9_z, _Record).

cp_test_names([the_headline_verdict_atoms_are_distinct, the_exemption_atoms_are_distinct, the_verdict_term_carries_status_and_citations, the_exemption_term_carries_status_and_citations, the_non_final_answers_build_and_destructure, a_real_citation_record_resolves, a_real_citation_key_is_implemented, an_empty_profile_has_no_input_problem, a_non_list_profile_is_wrong_type_profile]).
cp_test_fail_names([an_unrecorded_citation_key_does_not_resolve]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
