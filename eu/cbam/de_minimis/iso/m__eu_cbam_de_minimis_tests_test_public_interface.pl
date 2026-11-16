% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_cbam_de_minimis_tests_test_public_interface, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_cbam_de_minimis_de_minimis, [de_minimis_exemption/3, de_minimis_goods_status/3, decide_de_minimis/2, de_minimis_status/2, de_minimis_checklist/2, de_minimis_decision_resolvable/1, de_minimis_status_values/1]).
:- use_module(m__eu_cbam_de_minimis_kernel, [de_minimis_input_problems/2]).
:- use_module(m__eu_cbam_de_minimis_fixtures, [de_minimis_subject/1, de_minimis_profile_for/2, de_minimis_assess/2]).

applies_citations([cite(eu_reg_2023_956_art_2a_1), cite(eu_reg_2023_956_annex_vii_1), cite(eu_reg_2023_956_art_3_15)]).

does_not_apply_citations([cite(eu_reg_2023_956_art_2a_1), cite(eu_reg_2023_956_art_2a_2), cite(eu_reg_2023_956_annex_vii_1), cite(eu_reg_2023_956_art_3_15)]).

exemption_answers(Subject, Answers) :-
    de_minimis_profile_for(Subject, Profile),
    findall(Result - Citations, de_minimis_exemption(Profile, Result, Citations), Answers).

goods_answers(Subject, Answers) :-
    de_minimis_profile_for(Subject, Profile),
    findall(Result - Citations, de_minimis_goods_status(Profile, Result, Citations), Answers).

one_verdict(Subject) :-
    findall(Verdict, de_minimis_assess(Subject, Verdict), Verdicts),
    length(Verdicts, 1).

one_goods_status(Subject) :-
    de_minimis_profile_for(Subject, Profile),
    findall(Result, de_minimis_goods_status(Profile, Result, _), Results),
    length(Results, 1).

non_empty_checklist(Subject) :-
    de_minimis_profile_for(Subject, Profile),
    findall(Items, de_minimis_checklist(Profile, Items), [[_FirstItem|_OtherItems]]).

resolvable(Subject) :-
    de_minimis_profile_for(Subject, Profile),
    de_minimis_decision_resolvable(Profile).

test(every_subject_has_exactly_one_verdict) :-
    findall(Subject, de_minimis_subject(Subject), Subjects),
    Subjects = [_|_],
    maplist(one_verdict, Subjects).
test(every_subject_has_exactly_one_goods_status) :-
    findall(Subject, de_minimis_subject(Subject), Subjects),
    maplist(one_goods_status, Subjects).
test(every_subject_has_a_non_empty_checklist) :-
    findall(Subject, de_minimis_subject(Subject), Subjects),
    maplist(non_empty_checklist, Subjects).
test(every_subject_is_resolvable) :-
    findall(Subject, de_minimis_subject(Subject), Subjects),
    maplist(resolvable, Subjects).
test(the_status_values_are_the_two_final_atoms) :-
    de_minimis_status_values(StatusValues),
    StatusValues == [de_minimis_exemption_applies, de_minimis_exemption_does_not_apply].
test(at_limit_by_acceptance_is_exempt) :-
    applies_citations(Citations),
    exemption_answers(at_limit_by_acceptance, Answers),
    Answers == [de_minimis_exemption_applies - Citations].
test(one_kilogram_above_by_acceptance_is_not_exempt) :-
    does_not_apply_citations(Citations),
    exemption_answers(one_kilogram_above_by_acceptance, Answers),
    Answers == [de_minimis_exemption_does_not_apply - Citations].
test(at_limit_by_release_is_exempt) :-
    applies_citations(Citations),
    exemption_answers(at_limit_by_release, Answers),
    Answers == [de_minimis_exemption_applies - Citations].
test(one_kilogram_above_by_release_is_not_exempt) :-
    does_not_apply_citations(Citations),
    exemption_answers(one_kilogram_above_by_release, Answers),
    Answers == [de_minimis_exemption_does_not_apply - Citations].
test(unsure_both_at_limit_is_exempt) :-
    applies_citations(Citations),
    exemption_answers(unsure_both_at_limit, Answers),
    Answers == [de_minimis_exemption_applies - Citations].
test(unsure_both_one_kilogram_above_is_not_exempt) :-
    does_not_apply_citations(Citations),
    exemption_answers(unsure_both_one_kilogram_above, Answers),
    Answers == [de_minimis_exemption_does_not_apply - Citations].
test(unsure_figures_across_limit_need_legal_review) :-
    exemption_answers(unsure_figures_across_limit, Answers),
    Answers == [needs_legal_review(open_textured(year_date_basis, cite(eu_reg_2023_956_art_2a_1)), [inputs_relied_on([year_date_basis - unsure])]) - []].
test(a_trailing_provenance_element_keeps_the_referral_shape) :-
    exemption_answers(unsure_figures_across_limit, [needs_legal_review(Reason, [InputsReliedOn]) - []]),
    Context = [InputsReliedOn, provenance(date_basis_verdict, [cite(eu_reg_2023_956_art_2a_1)])],
    Context = [inputs_relied_on(Pairs), provenance(Clause, ProvenanceCitations)],
    Reason == open_textured(year_date_basis, cite(eu_reg_2023_956_art_2a_1)),
    Pairs == [year_date_basis - unsure],
    Clause == date_basis_verdict,
    ProvenanceCitations == [cite(eu_reg_2023_956_art_2a_1)].
test(no_basis_figures_across_limit_name_the_basis) :-
    exemption_answers(no_basis_figures_across_limit, Answers),
    Answers == [indeterminate([year_date_basis]) - []].
test(no_basis_both_at_limit_is_exempt) :-
    applies_citations(Citations),
    exemption_answers(no_basis_both_at_limit, Answers),
    Answers == [de_minimis_exemption_applies - Citations].
test(zero_figures_without_threshold_are_exempt) :-
    applies_citations(Citations),
    exemption_answers(zero_figures_without_threshold, Answers),
    Answers == [de_minimis_exemption_applies - Citations].
test(one_kilogram_without_threshold_names_the_threshold) :-
    exemption_answers(one_kilogram_without_threshold, Answers),
    Answers == [indeterminate([single_mass_based_threshold_tonnes]) - []].
test(acceptance_figure_absent_is_named_before_the_threshold) :-
    exemption_answers(acceptance_figure_absent, Answers),
    Answers == [indeterminate([net_mass_kg_by_acceptance_date]) - []].
test(release_figure_absent_on_release_basis_is_named) :-
    exemption_answers(release_figure_absent_on_release_basis, Answers),
    Answers == [indeterminate([net_mass_kg_by_release_date]) - []].
test(fractional_threshold_is_an_input_problem) :-
    exemption_answers(fractional_threshold, Answers),
    Answers == [input_problems([wrong_type(single_mass_based_threshold_tonnes)]) - []].
test(whole_threshold_control_is_exempt) :-
    applies_citations(Citations),
    exemption_answers(whole_threshold_control, Answers),
    Answers == [de_minimis_exemption_applies - Citations].
test(whole_threshold_control_has_no_input_problem) :-
    de_minimis_profile_for(whole_threshold_control, Profile),
    findall(Problems, de_minimis_input_problems(Profile, Problems), Answers),
    Answers == [[]].
test(negative_figure_is_wrong_type) :-
    exemption_answers(negative_figure, Answers),
    Answers == [input_problems([wrong_type(net_mass_kg_by_acceptance_date)]) - []].
test(duplicate_threshold_is_a_duplicate_key) :-
    de_minimis_profile_for(duplicate_threshold, Profile),
    findall(Problems, de_minimis_input_problems(Profile, Problems), Answers),
    Answers == [[duplicate_key(single_mass_based_threshold_tonnes)]].
test(duplicate_threshold_blocks_the_exemption) :-
    exemption_answers(duplicate_threshold, Answers),
    Answers == [input_problems([duplicate_key(single_mass_based_threshold_tonnes)]) - []].
test(unknown_key_blocks_the_goods_status) :-
    goods_answers(unknown_key_importer_name, Answers),
    Answers == [input_problems([unknown_key(importer_name)]) - []].
test(goods_kind_outside_enumeration_is_wrong_type) :-
    goods_answers(goods_kind_outside_enumeration, Answers),
    Answers == [input_problems([wrong_type(goods_kind)]) - []].
test(an_unbound_profile_is_wrong_type_profile) :-
    findall(Problems, de_minimis_input_problems(_Profile, Problems), Answers),
    Answers == [[wrong_type(profile)]].
test(a_partial_list_is_wrong_type_profile) :-
    findall(Problems, de_minimis_input_problems([attribute(goods_kind, electricity)|_Rest], Problems), Answers),
    Answers == [[wrong_type(profile)]].
test(a_non_attribute_element_is_wrong_type_profile) :-
    findall(Problems, de_minimis_input_problems([goods_kind - electricity], Problems), Answers),
    Answers == [[wrong_type(profile)]].
test(an_unbound_value_is_wrong_type) :-
    findall(Problems, de_minimis_input_problems([attribute(goods_kind, _Value)], Problems), Answers),
    Answers == [[wrong_type(goods_kind)]].
test(a_number_key_is_an_unknown_key) :-
    findall(Problems, de_minimis_input_problems([attribute(42, electricity)], Problems), Answers),
    Answers == [[unknown_key(42)]].
test(electricity_import_is_outside_the_exemption) :-
    goods_answers(electricity_import, Answers),
    Answers == [outside_de_minimis_exemption - [cite(eu_reg_2023_956_art_2a_4), cite(eu_reg_2023_956_annex_i_electricity)]].
test(hydrogen_import_is_outside_the_exemption) :-
    goods_answers(hydrogen_import, Answers),
    Answers == [outside_de_minimis_exemption - [cite(eu_reg_2023_956_art_2a_4)]].
test(other_annex_i_goods_import_is_counted) :-
    goods_answers(other_annex_i_goods_import, Answers),
    Answers == [counted_toward_threshold - [cite(eu_reg_2023_956_art_2a_1), cite(eu_reg_2023_956_annex_i_1)]].
test(goods_not_listed_import_is_not_goods_of_this_regulation) :-
    goods_answers(goods_not_listed_import, Answers),
    Answers == [not_goods_of_this_regulation - [cite(eu_reg_2023_956_art_2_1), cite(eu_reg_2023_956_annex_i_1)]].
test(goods_kind_absent_is_named) :-
    goods_answers(goods_kind_absent, Answers),
    Answers == [indeterminate([goods_kind]) - []].
test(electricity_importer_keeps_the_exemption_for_other_goods) :-
    applies_citations(Citations),
    exemption_answers(electricity_importer_with_other_goods_at_limit, Answers),
    Answers == [de_minimis_exemption_applies - Citations].
test(electricity_importer_electricity_stays_outside) :-
    goods_answers(electricity_importer_with_other_goods_at_limit, Answers),
    Answers == [outside_de_minimis_exemption - [cite(eu_reg_2023_956_art_2a_4), cite(eu_reg_2023_956_annex_i_electricity)]].
test(assess_gives_the_verdict_term) :-
    applies_citations(Citations),
    findall(Verdict, de_minimis_assess(at_limit_by_acceptance, Verdict), Verdicts),
    Verdicts == [de_minimis_verdict(de_minimis_exemption_applies, Citations)].
test(decide_agrees_with_the_exemption_query) :-
    de_minimis_profile_for(one_kilogram_above_by_release, Profile),
    findall(Verdict, decide_de_minimis(Profile, Verdict), Verdicts),
    does_not_apply_citations(Citations),
    Verdicts == [de_minimis_verdict(de_minimis_exemption_does_not_apply, Citations)].
test(status_projection_gives_the_bare_atom) :-
    de_minimis_profile_for(one_kilogram_above_by_acceptance, Profile),
    findall(Status, de_minimis_status(Profile, Status), Statuses),
    Statuses == [de_minimis_exemption_does_not_apply].
test(status_projection_gives_the_bare_compound) :-
    de_minimis_profile_for(no_basis_figures_across_limit, Profile),
    findall(Status, de_minimis_status(Profile, Status), Statuses),
    Statuses == [indeterminate([year_date_basis])].
test(checklist_at_limit_is_met_and_cited) :-
    de_minimis_profile_for(at_limit_by_acceptance, Profile),
    findall(Items, de_minimis_checklist(Profile, Items), Checklists),
    Checklists == [[item(net_mass_kg_by_acceptance_date, met, cite(eu_reg_2023_956_art_2a_1))]].
test(checklist_one_kilogram_above_is_unmet_and_cited) :-
    de_minimis_profile_for(one_kilogram_above_by_acceptance, Profile),
    findall(Items, de_minimis_checklist(Profile, Items), Checklists),
    Checklists == [[item(net_mass_kg_by_acceptance_date, unmet(exceeds_single_mass_based_threshold), cite(eu_reg_2023_956_art_2a_1))]].
test(checklist_across_limit_shows_both_figures) :-
    de_minimis_profile_for(unsure_figures_across_limit, Profile),
    findall(Items, de_minimis_checklist(Profile, Items), Checklists),
    Checklists == [[item(net_mass_kg_by_acceptance_date, met, cite(eu_reg_2023_956_art_2a_1)), item(net_mass_kg_by_release_date, unmet(exceeds_single_mass_based_threshold), cite(eu_reg_2023_956_art_2a_1))]].

test(one_kilogram_above_by_acceptance_does_not_get_the_exemption, fail) :-
    de_minimis_profile_for(one_kilogram_above_by_acceptance, Profile),
    de_minimis_exemption(Profile, de_minimis_exemption_applies, _).
test(at_limit_by_acceptance_is_not_refused_the_exemption, fail) :-
    de_minimis_profile_for(at_limit_by_acceptance, Profile),
    de_minimis_exemption(Profile, de_minimis_exemption_does_not_apply, _).
test(unsure_figures_across_limit_get_no_final_answer, fail) :-
    de_minimis_profile_for(unsure_figures_across_limit, Profile),
    de_minimis_exemption(Profile, de_minimis_exemption_applies, _).
test(fractional_threshold_gets_no_exemption, fail) :-
    de_minimis_profile_for(fractional_threshold, Profile),
    de_minimis_exemption(Profile, de_minimis_exemption_applies, _).
test(hydrogen_import_is_not_counted, fail) :-
    de_minimis_profile_for(hydrogen_import, Profile),
    de_minimis_goods_status(Profile, counted_toward_threshold, _).
test(other_annex_i_goods_import_is_not_outside, fail) :-
    de_minimis_profile_for(other_annex_i_goods_import, Profile),
    de_minimis_goods_status(Profile, outside_de_minimis_exemption, _).

cp_test_names([every_subject_has_exactly_one_verdict, every_subject_has_exactly_one_goods_status, every_subject_has_a_non_empty_checklist, every_subject_is_resolvable, the_status_values_are_the_two_final_atoms, at_limit_by_acceptance_is_exempt, one_kilogram_above_by_acceptance_is_not_exempt, at_limit_by_release_is_exempt, one_kilogram_above_by_release_is_not_exempt, unsure_both_at_limit_is_exempt, unsure_both_one_kilogram_above_is_not_exempt, unsure_figures_across_limit_need_legal_review, a_trailing_provenance_element_keeps_the_referral_shape, no_basis_figures_across_limit_name_the_basis, no_basis_both_at_limit_is_exempt, zero_figures_without_threshold_are_exempt, one_kilogram_without_threshold_names_the_threshold, acceptance_figure_absent_is_named_before_the_threshold, release_figure_absent_on_release_basis_is_named, fractional_threshold_is_an_input_problem, whole_threshold_control_is_exempt, whole_threshold_control_has_no_input_problem, negative_figure_is_wrong_type, duplicate_threshold_is_a_duplicate_key, duplicate_threshold_blocks_the_exemption, unknown_key_blocks_the_goods_status, goods_kind_outside_enumeration_is_wrong_type, an_unbound_profile_is_wrong_type_profile, a_partial_list_is_wrong_type_profile, a_non_attribute_element_is_wrong_type_profile, an_unbound_value_is_wrong_type, a_number_key_is_an_unknown_key, electricity_import_is_outside_the_exemption, hydrogen_import_is_outside_the_exemption, other_annex_i_goods_import_is_counted, goods_not_listed_import_is_not_goods_of_this_regulation, goods_kind_absent_is_named, electricity_importer_keeps_the_exemption_for_other_goods, electricity_importer_electricity_stays_outside, assess_gives_the_verdict_term, decide_agrees_with_the_exemption_query, status_projection_gives_the_bare_atom, status_projection_gives_the_bare_compound, checklist_at_limit_is_met_and_cited, checklist_one_kilogram_above_is_unmet_and_cited, checklist_across_limit_shows_both_figures]).
cp_test_fail_names([one_kilogram_above_by_acceptance_does_not_get_the_exemption, at_limit_by_acceptance_is_not_refused_the_exemption, unsure_figures_across_limit_get_no_final_answer, fractional_threshold_gets_no_exemption, hydrogen_import_is_not_counted, other_annex_i_goods_import_is_not_outside]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
