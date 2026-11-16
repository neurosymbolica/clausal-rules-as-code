% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_cbam_de_minimis_tests_test_output_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_cbam_de_minimis_de_minimis, [decide_de_minimis/2, de_minimis_status/2, de_minimis_exemption/3, de_minimis_goods_status/3]).
:- use_module(m__eu_cbam_de_minimis_fixtures, [de_minimis_profile_for/2]).

applies_citations([cite(eu_reg_2023_956_art_2a_1), cite(eu_reg_2023_956_annex_vii_1), cite(eu_reg_2023_956_art_3_15)]).

does_not_apply_citations([cite(eu_reg_2023_956_art_2a_1), cite(eu_reg_2023_956_art_2a_2), cite(eu_reg_2023_956_annex_vii_1), cite(eu_reg_2023_956_art_3_15)]).

exemption_answers(Subject, Answers) :-
    de_minimis_profile_for(Subject, Profile),
    findall(Result - Citations, de_minimis_exemption(Profile, Result, Citations), Answers).

goods_answers(Subject, Answers) :-
    de_minimis_profile_for(Subject, Profile),
    findall(Result - Citations, de_minimis_goods_status(Profile, Result, Citations), Answers).

acceptance_status_at(Kilograms, Statuses) :-
    Profile = [attribute(single_mass_based_threshold_tonnes, 50), attribute(year_date_basis, acceptance_of_the_customs_declaration), attribute(net_mass_kg_by_acceptance_date, Kilograms)],
    findall(Status, de_minimis_status(Profile, Status), Statuses).

test(at_the_limit_by_acceptance_the_exemption_applies) :-
    applies_citations(Citations),
    exemption_answers(at_limit_by_acceptance, Answers),
    Answers == [de_minimis_exemption_applies - Citations].
test(one_kilogram_above_by_acceptance_the_exemption_does_not_apply) :-
    does_not_apply_citations(Citations),
    exemption_answers(one_kilogram_above_by_acceptance, Answers),
    Answers == [de_minimis_exemption_does_not_apply - Citations].
test(at_the_limit_by_release_the_acceptance_figure_is_not_read) :-
    applies_citations(Citations),
    exemption_answers(at_limit_by_release, Answers),
    Answers == [de_minimis_exemption_applies - Citations].
test(one_kilogram_above_by_release_the_exemption_does_not_apply) :-
    does_not_apply_citations(Citations),
    exemption_answers(one_kilogram_above_by_release, Answers),
    Answers == [de_minimis_exemption_does_not_apply - Citations].
test(an_unsure_basis_with_both_at_the_limit_applies) :-
    applies_citations(Citations),
    exemption_answers(unsure_both_at_limit, Answers),
    Answers == [de_minimis_exemption_applies - Citations].
test(an_unsure_basis_with_both_above_does_not_apply) :-
    does_not_apply_citations(Citations),
    exemption_answers(unsure_both_one_kilogram_above, Answers),
    Answers == [de_minimis_exemption_does_not_apply - Citations].
test(an_unsure_basis_across_the_limit_goes_to_a_lawyer) :-
    exemption_answers(unsure_figures_across_limit, Answers),
    Answers == [needs_legal_review(open_textured(year_date_basis, cite(eu_reg_2023_956_art_2a_1)), [inputs_relied_on([year_date_basis - unsure])]) - []].
test(an_absent_basis_across_the_limit_names_the_basis) :-
    exemption_answers(no_basis_figures_across_limit, Answers),
    Answers == [indeterminate([year_date_basis]) - []].
test(an_absent_basis_with_both_at_the_limit_applies) :-
    applies_citations(Citations),
    exemption_answers(no_basis_both_at_limit, Answers),
    Answers == [de_minimis_exemption_applies - Citations].
test(zero_figures_apply_without_a_threshold) :-
    applies_citations(Citations),
    exemption_answers(zero_figures_without_threshold, Answers),
    Answers == [de_minimis_exemption_applies - Citations].
test(one_kilogram_without_a_threshold_names_the_threshold) :-
    exemption_answers(one_kilogram_without_threshold, Answers),
    Answers == [indeterminate([single_mass_based_threshold_tonnes]) - []].
test(an_absent_acceptance_figure_is_named_first) :-
    exemption_answers(acceptance_figure_absent, Answers),
    Answers == [indeterminate([net_mass_kg_by_acceptance_date]) - []].
test(the_release_basis_names_the_absent_release_figure) :-
    exemption_answers(release_figure_absent_on_release_basis, Answers),
    Answers == [indeterminate([net_mass_kg_by_release_date]) - []].
test(a_fractional_threshold_gives_input_problems) :-
    exemption_answers(fractional_threshold, Answers),
    Answers == [input_problems([wrong_type(single_mass_based_threshold_tonnes)]) - []].
test(the_whole_threshold_control_applies) :-
    applies_citations(Citations),
    exemption_answers(whole_threshold_control, Answers),
    Answers == [de_minimis_exemption_applies - Citations].
test(a_duplicate_threshold_gives_input_problems) :-
    exemption_answers(duplicate_threshold, Answers),
    Answers == [input_problems([duplicate_key(single_mass_based_threshold_tonnes)]) - []].
test(an_electricity_import_alone_names_the_first_figure) :-
    exemption_answers(electricity_import, Answers),
    Answers == [indeterminate([net_mass_kg_by_acceptance_date]) - []].
test(an_importer_of_electricity_keeps_the_exemption_for_other_goods) :-
    applies_citations(Citations),
    exemption_answers(electricity_importer_with_other_goods_at_limit, Answers),
    Answers == [de_minimis_exemption_applies - Citations].
test(the_boundary_flips_exactly_above_the_limit) :-
    acceptance_status_at(49999, BelowStatuses),
    acceptance_status_at(50000, AtStatuses),
    acceptance_status_at(50001, AboveStatuses),
    BelowStatuses == [de_minimis_exemption_applies],
    AtStatuses == [de_minimis_exemption_applies],
    AboveStatuses == [de_minimis_exemption_does_not_apply].
test(the_verdict_carries_a_citation) :-
    de_minimis_profile_for(at_limit_by_acceptance, Profile),
    decide_de_minimis(Profile, de_minimis_verdict(_Status, [_FirstCitation|_OtherCitations])).
test(electricity_is_outside_the_exemption) :-
    goods_answers(electricity_import, Answers),
    Answers == [outside_de_minimis_exemption - [cite(eu_reg_2023_956_art_2a_4), cite(eu_reg_2023_956_annex_i_electricity)]].
test(hydrogen_is_outside_the_exemption_on_article_2a_4_alone) :-
    goods_answers(hydrogen_import, Answers),
    Answers == [outside_de_minimis_exemption - [cite(eu_reg_2023_956_art_2a_4)]].
test(other_annex_i_goods_are_counted) :-
    goods_answers(other_annex_i_goods_import, Answers),
    Answers == [counted_toward_threshold - [cite(eu_reg_2023_956_art_2a_1), cite(eu_reg_2023_956_annex_i_1)]].
test(goods_not_listed_are_not_goods_of_this_regulation) :-
    goods_answers(goods_not_listed_import, Answers),
    Answers == [not_goods_of_this_regulation - [cite(eu_reg_2023_956_art_2_1), cite(eu_reg_2023_956_annex_i_1)]].
test(an_absent_goods_kind_is_named) :-
    goods_answers(goods_kind_absent, Answers),
    Answers == [indeterminate([goods_kind]) - []].
test(a_goods_kind_outside_the_enumeration_gives_input_problems) :-
    goods_answers(goods_kind_outside_enumeration, Answers),
    Answers == [input_problems([wrong_type(goods_kind)]) - []].
test(an_unknown_key_blocks_the_goods_status) :-
    goods_answers(unknown_key_importer_name, Answers),
    Answers == [input_problems([unknown_key(importer_name)]) - []].
test(an_unknown_key_blocks_the_exemption_too) :-
    exemption_answers(unknown_key_importer_name, Answers),
    Answers == [input_problems([unknown_key(importer_name)]) - []].

cp_test_names([at_the_limit_by_acceptance_the_exemption_applies, one_kilogram_above_by_acceptance_the_exemption_does_not_apply, at_the_limit_by_release_the_acceptance_figure_is_not_read, one_kilogram_above_by_release_the_exemption_does_not_apply, an_unsure_basis_with_both_at_the_limit_applies, an_unsure_basis_with_both_above_does_not_apply, an_unsure_basis_across_the_limit_goes_to_a_lawyer, an_absent_basis_across_the_limit_names_the_basis, an_absent_basis_with_both_at_the_limit_applies, zero_figures_apply_without_a_threshold, one_kilogram_without_a_threshold_names_the_threshold, an_absent_acceptance_figure_is_named_first, the_release_basis_names_the_absent_release_figure, a_fractional_threshold_gives_input_problems, the_whole_threshold_control_applies, a_duplicate_threshold_gives_input_problems, an_electricity_import_alone_names_the_first_figure, an_importer_of_electricity_keeps_the_exemption_for_other_goods, the_boundary_flips_exactly_above_the_limit, the_verdict_carries_a_citation, electricity_is_outside_the_exemption, hydrogen_is_outside_the_exemption_on_article_2a_4_alone, other_annex_i_goods_are_counted, goods_not_listed_are_not_goods_of_this_regulation, an_absent_goods_kind_is_named, a_goods_kind_outside_the_enumeration_gives_input_problems, an_unknown_key_blocks_the_goods_status, an_unknown_key_blocks_the_exemption_too]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
