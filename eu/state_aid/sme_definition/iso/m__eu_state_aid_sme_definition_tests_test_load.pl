% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_state_aid_sme_definition_tests_test_load, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_state_aid_sme_definition_kernel, [sme_definition_input_problems/2]).
:- use_module(m__eu_state_aid_sme_definition_citations, [citation/2, implements/1]).

test(an_empty_profile_has_no_problem) :-
    sme_definition_input_problems([], Problems),
    Problems == [].
test(a_well_formed_profile_has_no_problem) :-
    sme_definition_input_problems([attribute(is_enterprise, true), attribute(public_bodies_control_25_percent_or_more, false), attribute(accounting_basis, approved_accounts), attribute(own_staff_annual_work_units_hundredths, 500), attribute(own_annual_turnover_cents, 100000000), attribute(own_annual_balance_sheet_total_cents, 100000000), attribute(partner_enterprises, []), attribute(linked_enterprises, []), attribute(previous_period_size_class, no_previous_period), attribute(size_class_held, micro_enterprise)], Problems),
    Problems == [].
test(the_input_check_answers_once) :-
    findall(Problems, sme_definition_input_problems([attribute(is_enterprise, unsure)], Problems), Answers),
    Answers == [[]].
test(a_float_holding_is_wrong_type) :-
    sme_definition_input_problems([attribute(holding_basis_points, 25.0)], Problems),
    Problems == [wrong_type(holding_basis_points)].
test(an_unknown_enumeration_atom_is_wrong_type) :-
    sme_definition_input_problems([attribute(investor_category, bank)], Problems),
    Problems == [wrong_type(investor_category)].
test(a_partner_item_of_two_arguments_is_wrong_type) :-
    sme_definition_input_problems([attribute(partner_enterprises, [partner_enterprise_data(2500, 100)])], Problems),
    Problems == [wrong_type(partner_enterprises)].
test(a_duplicate_comes_before_an_unknown_key) :-
    sme_definition_input_problems([attribute(colour, red), attribute(is_enterprise, true), attribute(is_enterprise, true)], Problems),
    Problems == [duplicate_key(is_enterprise), unknown_key(colour)].
test(a_list_holding_a_non_attribute_is_not_a_profile) :-
    sme_definition_input_problems([attribute(is_enterprise, true), colour], Problems),
    Problems == [wrong_type(profile)].
test(an_atom_is_not_a_profile) :-
    sme_definition_input_problems(profile, Problems),
    Problems == [wrong_type(profile)].
test(a_compound_judgement_value_is_wrong_type) :-
    sme_definition_input_problems([attribute(is_enterprise, maybe(true))], Problems),
    Problems == [wrong_type(is_enterprise)].
test(the_verdict_term_carries_result_and_citations) :-
    Verdict = sme_definition_verdict(micro_enterprise, [cite(eu_rec_2003_361_annex_art_2_3), cite(eu_rec_2003_361_annex_art_5)]),
    Verdict = sme_definition_verdict(Result, Citations),
    Result == micro_enterprise,
    Citations == [cite(eu_rec_2003_361_annex_art_2_3), cite(eu_rec_2003_361_annex_art_5)].
test(the_indeterminate_term_names_one_key) :-
    Result = indeterminate([accounting_basis]),
    Result = indeterminate([Key]),
    Key == accounting_basis.
test(the_referral_term_destructures) :-
    Result = needs_legal_review(open_textured(is_enterprise, cite(eu_reg_651_2014_annex_i_art_1_t1)), [inputs_relied_on([is_enterprise - unsure])]),
    Result = needs_legal_review(open_textured(Judgement, cite(Key)), [inputs_relied_on(Pairs)]),
    Judgement == is_enterprise,
    Key == eu_reg_651_2014_annex_i_art_1_t1,
    Pairs == [is_enterprise - unsure].
test(the_input_problems_term_destructures) :-
    Result = input_problems([wrong_type(text), unknown_key(colour)]),
    Result = input_problems([First|Rest]),
    First == wrong_type(text),
    Rest == [unknown_key(colour)].
test(the_list_items_destructure) :-
    Partner = partner_enterprise_data(2500, 100, 1000, 2000),
    Partner = partner_enterprise_data(Share, Staff, Turnover, Balance),
    Share == 2500,
    Staff == 100,
    Turnover == 1000,
    Balance == 2000,
    Linked = linked_enterprise_data(10, 20, 30),
    Linked = linked_enterprise_data(LinkedStaff, LinkedTurnover, LinkedBalance),
    LinkedStaff == 10,
    LinkedTurnover == 20,
    LinkedBalance == 30.
test(the_size_classes_are_distinct) :-
    all_distinct_atoms([micro_enterprise, small_enterprise, medium_sized_enterprise, large_enterprise, not_sme_public_control, not_an_enterprise]).
test(the_status_atoms_are_distinct) :-
    all_distinct_atoms([sme, not_sme, not_an_enterprise]),
    all_distinct_atoms([at_least_medium, below_medium, not_an_enterprise]).
test(the_relationship_atoms_are_distinct) :-
    all_distinct_atoms([linked_enterprise, partner_enterprise, neither_partner_nor_linked]).
test(the_text_atoms_are_distinct) :-
    dif(recommendation_2003_361_annex, gber_annex_i).
test(the_recommendation_micro_citation_is_recorded) :-
    citation(eu_rec_2003_361_annex_art_2_3, Record),
    member(verbatim - Verbatim, Record),
    atom(Verbatim).
test(the_gber_presumption_citation_is_recorded) :-
    citation(eu_reg_651_2014_annex_i_art_3_t2, Record),
    member(label - Label, Record),
    atom(Label).
test(a_recorded_key_is_implemented) :-
    implements(eu_reg_651_2014_annex_i_art_6_t1).

test(a_well_formed_profile_is_not_refused, fail) :-
    sme_definition_input_problems([attribute(is_enterprise, unsure)], [_|_]).
test(a_float_holding_is_not_accepted, fail) :-
    sme_definition_input_problems([attribute(holding_basis_points, 25.0)], []).
test(the_indeterminate_term_is_not_the_bare_atom, fail) :-
    indeterminate([accounting_basis]) = indeterminate.
test(two_equal_atoms_are_not_distinct, fail) :-
    all_distinct_atoms([sme, sme]).
test(a_shortened_key_is_not_recorded, fail) :-
    citation(eu_rec_2003_361_art_2_3, _).

all_distinct_atoms([]).
all_distinct_atoms([Atom|Atoms]) :-
    maplist(dif(Atom), Atoms),
    all_distinct_atoms(Atoms).

cp_test_names([an_empty_profile_has_no_problem, a_well_formed_profile_has_no_problem, the_input_check_answers_once, a_float_holding_is_wrong_type, an_unknown_enumeration_atom_is_wrong_type, a_partner_item_of_two_arguments_is_wrong_type, a_duplicate_comes_before_an_unknown_key, a_list_holding_a_non_attribute_is_not_a_profile, an_atom_is_not_a_profile, a_compound_judgement_value_is_wrong_type, the_verdict_term_carries_result_and_citations, the_indeterminate_term_names_one_key, the_referral_term_destructures, the_input_problems_term_destructures, the_list_items_destructure, the_size_classes_are_distinct, the_status_atoms_are_distinct, the_relationship_atoms_are_distinct, the_text_atoms_are_distinct, the_recommendation_micro_citation_is_recorded, the_gber_presumption_citation_is_recorded, a_recorded_key_is_implemented]).
cp_test_fail_names([a_well_formed_profile_is_not_refused, a_float_holding_is_not_accepted, the_indeterminate_term_is_not_the_bare_atom, two_equal_atoms_are_not_distinct, a_shortened_key_is_not_recorded]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
