% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_cbam_de_minimis_de_minimis, [de_minimis_exemption/3, de_minimis_goods_status/3, decide_de_minimis/2, de_minimis_status/2, de_minimis_checklist/2, de_minimis_decision_resolvable/1, de_minimis_status_values/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(library(clpz)).
:- use_module(library(reif), [memberd_t/3]).
:- use_module(formalize_lib, [profile_get/3, profile_lacks/2]).
:- use_module(m__eu_cbam_de_minimis_kernel, [de_minimis_input_problems/2]).
:- use_module(m__eu_cbam_de_minimis_citations, [implements/1]).

de_minimis_pinned_threshold_tonnes(50, cite(eu_reg_2023_956_annex_vii_1)).

de_minimis_status_values([de_minimis_exemption_applies, de_minimis_exemption_does_not_apply]).

limit_kilograms(ThresholdTonnes, LimitKilograms) :-
    implements(eu_reg_2023_956_annex_vii_1),
    implements(eu_reg_2023_956_art_2a_3),
    LimitKilograms #= ThresholdTonnes * 1000.

threshold_comparison(Kilograms, LimitKilograms, within) :-
    implements(eu_reg_2023_956_art_2a_1),
    Kilograms #=< LimitKilograms.
threshold_comparison(Kilograms, LimitKilograms, above) :-
    implements(eu_reg_2023_956_art_2a_1),
    Kilograms #> LimitKilograms.

relevant_figures(Profile, [net_mass_kg_by_acceptance_date]) :-
    implements(eu_reg_2023_956_art_2a_1),
    profile_get(Profile, year_date_basis, acceptance_of_the_customs_declaration).
relevant_figures(Profile, [net_mass_kg_by_release_date]) :-
    implements(eu_reg_2023_956_art_2a_1),
    profile_get(Profile, year_date_basis, release_for_free_circulation).
relevant_figures(Profile, [net_mass_kg_by_acceptance_date, net_mass_kg_by_release_date]) :-
    implements(eu_reg_2023_956_art_2a_1),
    profile_get(Profile, year_date_basis, unsure).
relevant_figures(Profile, [net_mass_kg_by_acceptance_date, net_mass_kg_by_release_date]) :-
    implements(eu_reg_2023_956_art_2a_1),
    profile_lacks(Profile, year_date_basis).

figure_state(Profile, Key, absent) :-
    profile_lacks(Profile, Key).
figure_state(Profile, Key, State) :-
    profile_get(Profile, Key, Kilograms),
    present_figure_state(Profile, Kilograms, State).

present_figure_state(_, Kilograms, within) :-
    implements(eu_reg_2023_956_art_2a_1),
    Kilograms #= 0.
present_figure_state(Profile, Kilograms, not_comparable) :-
    Kilograms #> 0,
    profile_lacks(Profile, single_mass_based_threshold_tonnes).
present_figure_state(Profile, Kilograms, State) :-
    implements(eu_reg_2023_956_annex_vii_1),
    Kilograms #> 0,
    profile_get(Profile, single_mass_based_threshold_tonnes, ThresholdTonnes),
    limit_kilograms(ThresholdTonnes, LimitKilograms),
    threshold_comparison(Kilograms, LimitKilograms, State).

first_absent_key([Key|_], [absent|_], Key).
first_absent_key([_|Keys], [State|States], Key) :-
    dif(State, absent),
    first_absent_key(Keys, States, Key).

de_minimis_exemption(Profile, Result, Citations) :-
    decide_de_minimis(Profile, de_minimis_verdict(Result, Citations)).

decide_de_minimis(Profile, Verdict) :-
    de_minimis_input_problems(Profile, Problems),
    verdict_for_problems(Problems, Profile, Verdict).

verdict_for_problems([Problem|Problems], _, de_minimis_verdict(input_problems([Problem|Problems]), [])).
verdict_for_problems([], Profile, Verdict) :-
    exemption_verdict(Profile, Verdict).

exemption_verdict(Profile, Verdict) :-
    relevant_figures(Profile, Keys),
    maplist(figure_state(Profile), Keys, States),
    memberd_t(absent, States, HasAbsent),
    memberd_t(not_comparable, States, HasNotComparable),
    memberd_t(within, States, HasWithin),
    memberd_t(above, States, HasAbove),
    exemption_route(HasAbsent, HasNotComparable, HasWithin, HasAbove, Profile, Keys, States, Verdict).

exemption_route(false, false, true, false, _, _, _, de_minimis_verdict(de_minimis_exemption_applies, [cite(eu_reg_2023_956_art_2a_1), cite(eu_reg_2023_956_annex_vii_1), cite(eu_reg_2023_956_art_3_15)])) :-
    implements(eu_reg_2023_956_art_2a_1).
exemption_route(false, false, false, true, _, _, _, de_minimis_verdict(de_minimis_exemption_does_not_apply, [cite(eu_reg_2023_956_art_2a_1), cite(eu_reg_2023_956_art_2a_2), cite(eu_reg_2023_956_annex_vii_1), cite(eu_reg_2023_956_art_3_15)])) :-
    implements(eu_reg_2023_956_art_2a_2).
exemption_route(true, _, _, _, _, Keys, States, de_minimis_verdict(indeterminate([Key]), [])) :-
    first_absent_key(Keys, States, Key).
exemption_route(false, true, _, _, _, _, _, de_minimis_verdict(indeterminate([single_mass_based_threshold_tonnes]), [])).
exemption_route(false, false, true, true, Profile, _, _, Verdict) :-
    date_basis_verdict(Profile, Verdict).

date_basis_verdict(Profile, de_minimis_verdict(indeterminate([year_date_basis]), [])) :-
    profile_lacks(Profile, year_date_basis).
date_basis_verdict(Profile, de_minimis_verdict(needs_legal_review(open_textured(year_date_basis, cite(eu_reg_2023_956_art_2a_1)), [inputs_relied_on([year_date_basis - unsure])]), [])) :-
    implements(eu_reg_2023_956_art_2a_1),
    profile_get(Profile, year_date_basis, unsure).

de_minimis_goods_status(Profile, Result, Citations) :-
    de_minimis_input_problems(Profile, Problems),
    goods_status_for_problems(Problems, Profile, Result, Citations).

goods_status_for_problems([Problem|Problems], _, input_problems([Problem|Problems]), []).
goods_status_for_problems([], Profile, Result, Citations) :-
    goods_kind_status(Profile, Result, Citations).

goods_kind_status(Profile, outside_de_minimis_exemption, [cite(eu_reg_2023_956_art_2a_4), cite(eu_reg_2023_956_annex_i_electricity)]) :-
    implements(eu_reg_2023_956_art_2a_4),
    profile_get(Profile, goods_kind, electricity).
goods_kind_status(Profile, outside_de_minimis_exemption, [cite(eu_reg_2023_956_art_2a_4)]) :-
    implements(eu_reg_2023_956_art_2a_4),
    implements(eu_reg_2023_956_annex_i_chemicals),
    profile_get(Profile, goods_kind, hydrogen).
goods_kind_status(Profile, counted_toward_threshold, [cite(eu_reg_2023_956_art_2a_1), cite(eu_reg_2023_956_annex_i_1)]) :-
    implements(eu_reg_2023_956_art_2a_1),
    profile_get(Profile, goods_kind, other_annex_i_goods).
goods_kind_status(Profile, not_goods_of_this_regulation, [cite(eu_reg_2023_956_art_2_1), cite(eu_reg_2023_956_annex_i_1)]) :-
    implements(eu_reg_2023_956_art_2_1),
    profile_get(Profile, goods_kind, goods_not_listed_in_annex_i).
goods_kind_status(Profile, indeterminate([goods_kind]), []) :-
    profile_lacks(Profile, goods_kind).

de_minimis_status(Profile, Status) :-
    decide_de_minimis(Profile, de_minimis_verdict(Status, _Citations)).

de_minimis_checklist(Profile, Items) :-
    de_minimis_input_problems(Profile, Problems),
    checklist_for_problems(Problems, Profile, Items).

checklist_for_problems([Problem|Problems], _, [item(profile, unmet(input_problems([Problem|Problems])), cite(eu_reg_2023_956_art_2a_1))]).
checklist_for_problems([], Profile, Items) :-
    relevant_figures(Profile, Keys),
    maplist(figure_item(Profile), Keys, Items).

figure_item(Profile, Key, item(Key, Status, cite(eu_reg_2023_956_art_2a_1))) :-
    figure_state(Profile, Key, State),
    state_item_status(State, Key, Status).

state_item_status(within, _, met).
state_item_status(above, _, unmet(exceeds_single_mass_based_threshold)).
state_item_status(absent, Key, unknown([Key])).
state_item_status(not_comparable, _, unknown([single_mass_based_threshold_tonnes])).

de_minimis_decision_resolvable(Profile) :-
    decide_de_minimis(Profile, _Verdict).

test(the_pinned_threshold_is_fifty_tonnes) :-
    de_minimis_pinned_threshold_tonnes(50, cite(eu_reg_2023_956_annex_vii_1)).
test(the_limit_is_fifty_thousand_kilograms) :-
    limit_kilograms(50, LimitKilograms),
    LimitKilograms =:= 50000.
test(a_figure_equal_to_the_limit_is_within) :-
    Profile = [attribute(single_mass_based_threshold_tonnes, 50), attribute(year_date_basis, acceptance_of_the_customs_declaration), attribute(net_mass_kg_by_acceptance_date, 50000)],
    findall(Result - Citations, de_minimis_exemption(Profile, Result, Citations), Answers),
    Answers == [de_minimis_exemption_applies - [cite(eu_reg_2023_956_art_2a_1), cite(eu_reg_2023_956_annex_vii_1), cite(eu_reg_2023_956_art_3_15)]].
test(a_figure_one_kilogram_above_the_limit_exceeds) :-
    Profile = [attribute(single_mass_based_threshold_tonnes, 50), attribute(year_date_basis, acceptance_of_the_customs_declaration), attribute(net_mass_kg_by_acceptance_date, 50001)],
    findall(Result - Citations, de_minimis_exemption(Profile, Result, Citations), Answers),
    Answers == [de_minimis_exemption_does_not_apply - [cite(eu_reg_2023_956_art_2a_1), cite(eu_reg_2023_956_art_2a_2), cite(eu_reg_2023_956_annex_vii_1), cite(eu_reg_2023_956_art_3_15)]].
test(the_release_basis_reads_the_release_figure_only) :-
    Profile = [attribute(single_mass_based_threshold_tonnes, 50), attribute(year_date_basis, release_for_free_circulation), attribute(net_mass_kg_by_acceptance_date, 90000), attribute(net_mass_kg_by_release_date, 10000)],
    findall(Result, de_minimis_exemption(Profile, Result, _), Results),
    Results == [de_minimis_exemption_applies].
test(zero_figures_need_no_threshold_and_no_date_basis) :-
    Profile = [attribute(net_mass_kg_by_acceptance_date, 0), attribute(net_mass_kg_by_release_date, 0)],
    findall(Result, de_minimis_exemption(Profile, Result, _), Results),
    Results == [de_minimis_exemption_applies].
test(both_figures_above_with_an_unsure_basis_exceed) :-
    Profile = [attribute(single_mass_based_threshold_tonnes, 50), attribute(year_date_basis, unsure), attribute(net_mass_kg_by_acceptance_date, 60000), attribute(net_mass_kg_by_release_date, 70000)],
    findall(Result, de_minimis_exemption(Profile, Result, _), Results),
    Results == [de_minimis_exemption_does_not_apply].
test(figures_across_the_limit_with_an_unsure_basis_go_to_a_lawyer) :-
    Profile = [attribute(single_mass_based_threshold_tonnes, 50), attribute(year_date_basis, unsure), attribute(net_mass_kg_by_acceptance_date, 40000), attribute(net_mass_kg_by_release_date, 60000)],
    findall(Result - Citations, de_minimis_exemption(Profile, Result, Citations), Answers),
    Answers == [needs_legal_review(open_textured(year_date_basis, cite(eu_reg_2023_956_art_2a_1)), [inputs_relied_on([year_date_basis - unsure])]) - []].
test(figures_across_the_limit_without_a_basis_name_the_basis) :-
    Profile = [attribute(single_mass_based_threshold_tonnes, 50), attribute(net_mass_kg_by_acceptance_date, 40000), attribute(net_mass_kg_by_release_date, 60000)],
    findall(Result - Citations, de_minimis_exemption(Profile, Result, Citations), Answers),
    Answers == [indeterminate([year_date_basis]) - []].
test(figures_above_zero_without_a_threshold_name_the_threshold) :-
    Profile = [attribute(year_date_basis, unsure), attribute(net_mass_kg_by_acceptance_date, 40000), attribute(net_mass_kg_by_release_date, 0)],
    findall(Result, de_minimis_exemption(Profile, Result, _), Results),
    Results == [indeterminate([single_mass_based_threshold_tonnes])].
test(an_absent_figure_is_named_before_the_threshold) :-
    Profile = [attribute(net_mass_kg_by_release_date, 40000)],
    findall(Result, de_minimis_exemption(Profile, Result, _), Results),
    Results == [indeterminate([net_mass_kg_by_acceptance_date])].
test(the_release_basis_names_the_absent_release_figure) :-
    Profile = [attribute(single_mass_based_threshold_tonnes, 50), attribute(year_date_basis, release_for_free_circulation), attribute(net_mass_kg_by_acceptance_date, 10000)],
    findall(Result, de_minimis_exemption(Profile, Result, _), Results),
    Results == [indeterminate([net_mass_kg_by_release_date])].
test(a_fractional_threshold_is_an_input_problem) :-
    Profile = [attribute(single_mass_based_threshold_tonnes, 101/2), attribute(net_mass_kg_by_acceptance_date, 0), attribute(net_mass_kg_by_release_date, 0)],
    findall(Result - Citations, de_minimis_exemption(Profile, Result, Citations), Answers),
    Answers == [input_problems([wrong_type(single_mass_based_threshold_tonnes)]) - []].
test(electricity_is_outside_the_exemption) :-
    findall(Result - Citations, de_minimis_goods_status([attribute(goods_kind, electricity)], Result, Citations), Answers),
    Answers == [outside_de_minimis_exemption - [cite(eu_reg_2023_956_art_2a_4), cite(eu_reg_2023_956_annex_i_electricity)]].
test(hydrogen_is_outside_the_exemption) :-
    findall(Result - Citations, de_minimis_goods_status([attribute(goods_kind, hydrogen)], Result, Citations), Answers),
    Answers == [outside_de_minimis_exemption - [cite(eu_reg_2023_956_art_2a_4)]].
test(other_annex_i_goods_are_counted) :-
    findall(Result - Citations, de_minimis_goods_status([attribute(goods_kind, other_annex_i_goods)], Result, Citations), Answers),
    Answers == [counted_toward_threshold - [cite(eu_reg_2023_956_art_2a_1), cite(eu_reg_2023_956_annex_i_1)]].
test(goods_not_listed_are_not_goods_of_this_regulation) :-
    findall(Result - Citations, de_minimis_goods_status([attribute(goods_kind, goods_not_listed_in_annex_i)], Result, Citations), Answers),
    Answers == [not_goods_of_this_regulation - [cite(eu_reg_2023_956_art_2_1), cite(eu_reg_2023_956_annex_i_1)]].
test(an_absent_goods_kind_is_named) :-
    findall(Result - Citations, de_minimis_goods_status([attribute(year_date_basis, unsure)], Result, Citations), Answers),
    Answers == [indeterminate([goods_kind]) - []].
test(an_unknown_key_blocks_the_goods_status) :-
    findall(Result, de_minimis_goods_status([attribute(goods_kind, electricity), attribute(importer_name, acme)], Result, _), Results),
    Results == [input_problems([unknown_key(importer_name)])].
test(the_checklist_rows_follow_the_relevant_figures) :-
    Profile = [attribute(single_mass_based_threshold_tonnes, 50), attribute(year_date_basis, unsure), attribute(net_mass_kg_by_acceptance_date, 40000)],
    findall(Items, de_minimis_checklist(Profile, Items), Checklists),
    Checklists == [[item(net_mass_kg_by_acceptance_date, met, cite(eu_reg_2023_956_art_2a_1)), item(net_mass_kg_by_release_date, unknown([net_mass_kg_by_release_date]), cite(eu_reg_2023_956_art_2a_1))]].
test(the_status_projection_gives_the_verdict_atom) :-
    Profile = [attribute(single_mass_based_threshold_tonnes, 50), attribute(year_date_basis, acceptance_of_the_customs_declaration), attribute(net_mass_kg_by_acceptance_date, 120000)],
    findall(Status, de_minimis_status(Profile, Status), Statuses),
    Statuses == [de_minimis_exemption_does_not_apply].

test(a_figure_above_the_limit_is_not_exempt, fail) :-
    Profile = [attribute(single_mass_based_threshold_tonnes, 50), attribute(year_date_basis, acceptance_of_the_customs_declaration), attribute(net_mass_kg_by_acceptance_date, 50001)],
    de_minimis_exemption(Profile, de_minimis_exemption_applies, _).
test(a_profile_with_a_problem_is_not_exempt, fail) :-
    Profile = [attribute(single_mass_based_threshold_tonnes, 101/2), attribute(net_mass_kg_by_acceptance_date, 0), attribute(net_mass_kg_by_release_date, 0)],
    de_minimis_exemption(Profile, de_minimis_exemption_applies, _).
test(hydrogen_is_not_counted, fail) :-
    de_minimis_goods_status([attribute(goods_kind, hydrogen)], counted_toward_threshold, _).
