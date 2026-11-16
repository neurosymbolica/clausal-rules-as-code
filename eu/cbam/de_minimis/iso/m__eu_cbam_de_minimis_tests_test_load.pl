% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_cbam_de_minimis_tests_test_load, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_cbam_de_minimis_kernel, [de_minimis_input_problems/2]).
:- use_module(m__eu_cbam_de_minimis_citations, [citation/2, implements/1]).

test(the_exemption_atoms_are_distinct) :-
    dif(de_minimis_exemption_applies, de_minimis_exemption_does_not_apply).
test(the_goods_status_atoms_are_distinct) :-
    dif(outside_de_minimis_exemption, counted_toward_threshold),
    dif(outside_de_minimis_exemption, not_goods_of_this_regulation),
    dif(counted_toward_threshold, not_goods_of_this_regulation).
test(the_exemption_atoms_are_not_goods_status_atoms) :-
    dif(de_minimis_exemption_applies, outside_de_minimis_exemption),
    dif(de_minimis_exemption_does_not_apply, outside_de_minimis_exemption).
test(the_verdict_term_carries_status_and_citations) :-
    Verdict = de_minimis_verdict(de_minimis_exemption_applies, [cite(eu_reg_2023_956_art_2a_1), cite(eu_reg_2023_956_annex_vii_1), cite(eu_reg_2023_956_art_3_15)]),
    Verdict = de_minimis_verdict(Status, Citations),
    Status == de_minimis_exemption_applies,
    Citations == [cite(eu_reg_2023_956_art_2a_1), cite(eu_reg_2023_956_annex_vii_1), cite(eu_reg_2023_956_art_3_15)].
test(the_indeterminate_status_names_one_key) :-
    Status = indeterminate([net_mass_kg_by_acceptance_date]),
    Status = indeterminate(MissingKeys),
    MissingKeys == [net_mass_kg_by_acceptance_date].
test(the_referral_status_destructures) :-
    Status = needs_legal_review(open_textured(year_date_basis, cite(eu_reg_2023_956_art_2a_1)), [inputs_relied_on([year_date_basis - unsure])]),
    Status = needs_legal_review(open_textured(Input, cite(CitationKey)), [inputs_relied_on(Pairs)]),
    Input == year_date_basis,
    CitationKey == eu_reg_2023_956_art_2a_1,
    Pairs == [year_date_basis - unsure].
test(the_input_problems_status_destructures) :-
    Status = input_problems([wrong_type(goods_kind)]),
    Status = input_problems(Problems),
    Problems == [wrong_type(goods_kind)].
test(the_exemption_citation_is_recorded) :-
    citation(eu_reg_2023_956_art_2a_1, _Record).
test(the_threshold_citation_is_recorded) :-
    citation(eu_reg_2023_956_annex_vii_1, _Record).
test(the_electricity_citation_is_recorded) :-
    implements(eu_reg_2023_956_annex_i_electricity).
test(an_empty_profile_has_no_problem) :-
    findall(Problems, de_minimis_input_problems([], Problems), Answers),
    Answers == [[]].
test(a_well_formed_profile_has_no_problem) :-
    findall(Problems, de_minimis_input_problems([attribute(single_mass_based_threshold_tonnes, 50), attribute(year_date_basis, unsure), attribute(net_mass_kg_by_acceptance_date, 50000), attribute(net_mass_kg_by_release_date, 0), attribute(goods_kind, hydrogen)], Problems), Answers),
    Answers == [[]].
test(a_term_that_is_not_an_attribute_list_is_wrong_type) :-
    findall(Problems, de_minimis_input_problems(profile_text, Problems), Answers),
    Answers == [[wrong_type(profile)]].
test(an_unbound_profile_is_wrong_type) :-
    findall(Problems, de_minimis_input_problems(_Unbound, Problems), Answers),
    Answers == [[wrong_type(profile)]].
test(a_fractional_threshold_is_wrong_type) :-
    findall(Problems, de_minimis_input_problems([attribute(single_mass_based_threshold_tonnes, 50.5)], Problems), Answers),
    Answers == [[wrong_type(single_mass_based_threshold_tonnes)]].
test(a_repeated_key_is_a_duplicate) :-
    findall(Problems, de_minimis_input_problems([attribute(goods_kind, hydrogen), attribute(goods_kind, hydrogen)], Problems), Answers),
    Answers == [[duplicate_key(goods_kind)]].
test(a_key_outside_the_contract_is_unknown) :-
    findall(Problems, de_minimis_input_problems([attribute(colour, red)], Problems), Answers),
    Answers == [[unknown_key(colour)]].

test(an_unrecorded_citation_is_not_resolved, fail) :-
    citation(eu_todo_primary_source, _Record).
test(a_well_formed_profile_is_not_wrong_type, fail) :-
    de_minimis_input_problems([attribute(goods_kind, electricity)], [wrong_type(goods_kind)]).

cp_test_names([the_exemption_atoms_are_distinct, the_goods_status_atoms_are_distinct, the_exemption_atoms_are_not_goods_status_atoms, the_verdict_term_carries_status_and_citations, the_indeterminate_status_names_one_key, the_referral_status_destructures, the_input_problems_status_destructures, the_exemption_citation_is_recorded, the_threshold_citation_is_recorded, the_electricity_citation_is_recorded, an_empty_profile_has_no_problem, a_well_formed_profile_has_no_problem, a_term_that_is_not_an_attribute_list_is_wrong_type, an_unbound_profile_is_wrong_type, a_fractional_threshold_is_wrong_type, a_repeated_key_is_a_duplicate, a_key_outside_the_contract_is_unknown]).
cp_test_fail_names([an_unrecorded_citation_is_not_resolved, a_well_formed_profile_is_not_wrong_type]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
