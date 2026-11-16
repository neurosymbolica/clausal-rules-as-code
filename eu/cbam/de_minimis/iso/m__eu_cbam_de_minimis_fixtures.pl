% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_cbam_de_minimis_fixtures, [de_minimis_subject/1, de_minimis_profile_for/2, de_minimis_assess/2]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_cbam_de_minimis_de_minimis, [decide_de_minimis/2]).

de_minimis_subject(at_limit_by_acceptance).
de_minimis_subject(one_kilogram_above_by_acceptance).
de_minimis_subject(at_limit_by_release).
de_minimis_subject(one_kilogram_above_by_release).
de_minimis_subject(unsure_both_at_limit).
de_minimis_subject(unsure_both_one_kilogram_above).
de_minimis_subject(unsure_figures_across_limit).
de_minimis_subject(no_basis_figures_across_limit).
de_minimis_subject(no_basis_both_at_limit).
de_minimis_subject(zero_figures_without_threshold).
de_minimis_subject(one_kilogram_without_threshold).
de_minimis_subject(acceptance_figure_absent).
de_minimis_subject(release_figure_absent_on_release_basis).
de_minimis_subject(fractional_threshold).
de_minimis_subject(whole_threshold_control).
de_minimis_subject(negative_figure).
de_minimis_subject(duplicate_threshold).
de_minimis_subject(unknown_key_importer_name).
de_minimis_subject(electricity_import).
de_minimis_subject(hydrogen_import).
de_minimis_subject(other_annex_i_goods_import).
de_minimis_subject(goods_not_listed_import).
de_minimis_subject(goods_kind_absent).
de_minimis_subject(goods_kind_outside_enumeration).
de_minimis_subject(electricity_importer_with_other_goods_at_limit).

de_minimis_profile_for(at_limit_by_acceptance, [attribute(single_mass_based_threshold_tonnes, 50), attribute(year_date_basis, acceptance_of_the_customs_declaration), attribute(net_mass_kg_by_acceptance_date, 50000)]).
de_minimis_profile_for(one_kilogram_above_by_acceptance, [attribute(single_mass_based_threshold_tonnes, 50), attribute(year_date_basis, acceptance_of_the_customs_declaration), attribute(net_mass_kg_by_acceptance_date, 50001)]).
de_minimis_profile_for(at_limit_by_release, [attribute(single_mass_based_threshold_tonnes, 50), attribute(year_date_basis, release_for_free_circulation), attribute(net_mass_kg_by_acceptance_date, 90000), attribute(net_mass_kg_by_release_date, 50000)]).
de_minimis_profile_for(one_kilogram_above_by_release, [attribute(single_mass_based_threshold_tonnes, 50), attribute(year_date_basis, release_for_free_circulation), attribute(net_mass_kg_by_acceptance_date, 10000), attribute(net_mass_kg_by_release_date, 50001)]).
de_minimis_profile_for(unsure_both_at_limit, [attribute(single_mass_based_threshold_tonnes, 50), attribute(year_date_basis, unsure), attribute(net_mass_kg_by_acceptance_date, 50000), attribute(net_mass_kg_by_release_date, 50000)]).
de_minimis_profile_for(unsure_both_one_kilogram_above, [attribute(single_mass_based_threshold_tonnes, 50), attribute(year_date_basis, unsure), attribute(net_mass_kg_by_acceptance_date, 50001), attribute(net_mass_kg_by_release_date, 50001)]).
de_minimis_profile_for(unsure_figures_across_limit, [attribute(single_mass_based_threshold_tonnes, 50), attribute(year_date_basis, unsure), attribute(net_mass_kg_by_acceptance_date, 50000), attribute(net_mass_kg_by_release_date, 50001)]).
de_minimis_profile_for(no_basis_figures_across_limit, [attribute(single_mass_based_threshold_tonnes, 50), attribute(net_mass_kg_by_acceptance_date, 50000), attribute(net_mass_kg_by_release_date, 50001)]).
de_minimis_profile_for(no_basis_both_at_limit, [attribute(single_mass_based_threshold_tonnes, 50), attribute(net_mass_kg_by_acceptance_date, 50000), attribute(net_mass_kg_by_release_date, 50000)]).
de_minimis_profile_for(zero_figures_without_threshold, [attribute(net_mass_kg_by_acceptance_date, 0), attribute(net_mass_kg_by_release_date, 0)]).
de_minimis_profile_for(one_kilogram_without_threshold, [attribute(net_mass_kg_by_acceptance_date, 1), attribute(net_mass_kg_by_release_date, 0)]).
de_minimis_profile_for(acceptance_figure_absent, [attribute(net_mass_kg_by_release_date, 40000)]).
de_minimis_profile_for(release_figure_absent_on_release_basis, [attribute(single_mass_based_threshold_tonnes, 50), attribute(year_date_basis, release_for_free_circulation), attribute(net_mass_kg_by_acceptance_date, 10000)]).
de_minimis_profile_for(fractional_threshold, [attribute(single_mass_based_threshold_tonnes, 101/2), attribute(net_mass_kg_by_acceptance_date, 0), attribute(net_mass_kg_by_release_date, 0)]).
de_minimis_profile_for(whole_threshold_control, [attribute(single_mass_based_threshold_tonnes, 50), attribute(net_mass_kg_by_acceptance_date, 0), attribute(net_mass_kg_by_release_date, 0)]).
de_minimis_profile_for(negative_figure, [attribute(single_mass_based_threshold_tonnes, 50), attribute(year_date_basis, acceptance_of_the_customs_declaration), attribute(net_mass_kg_by_acceptance_date, -1)]).
de_minimis_profile_for(duplicate_threshold, [attribute(single_mass_based_threshold_tonnes, 50), attribute(single_mass_based_threshold_tonnes, 50), attribute(year_date_basis, acceptance_of_the_customs_declaration), attribute(net_mass_kg_by_acceptance_date, 1000)]).
de_minimis_profile_for(unknown_key_importer_name, [attribute(goods_kind, electricity), attribute(importer_name, acme)]).
de_minimis_profile_for(electricity_import, [attribute(goods_kind, electricity)]).
de_minimis_profile_for(hydrogen_import, [attribute(goods_kind, hydrogen)]).
de_minimis_profile_for(other_annex_i_goods_import, [attribute(goods_kind, other_annex_i_goods)]).
de_minimis_profile_for(goods_not_listed_import, [attribute(goods_kind, goods_not_listed_in_annex_i)]).
de_minimis_profile_for(goods_kind_absent, [attribute(year_date_basis, unsure)]).
de_minimis_profile_for(goods_kind_outside_enumeration, [attribute(goods_kind, steel)]).
de_minimis_profile_for(electricity_importer_with_other_goods_at_limit, [attribute(single_mass_based_threshold_tonnes, 50), attribute(year_date_basis, acceptance_of_the_customs_declaration), attribute(net_mass_kg_by_acceptance_date, 50000), attribute(goods_kind, electricity)]).

de_minimis_assess(Subject, Result) :-
    de_minimis_profile_for(Subject, Profile),
    decide_de_minimis(Profile, Result).
