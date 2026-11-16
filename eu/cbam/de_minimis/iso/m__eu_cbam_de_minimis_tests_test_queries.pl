% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_cbam_de_minimis_tests_test_queries, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_cbam_de_minimis_queries, [de_minimis_profile_keys/1, de_minimis_what_if/4, de_minimis_exemption_applies/0, outside_de_minimis_exemption/0, indeterminate/1, needs_legal_review/2, provenance/2, input_problems/1, unknown_key/1, wrong_type/1, duplicate_key/1]).
:- use_module(m__eu_cbam_de_minimis_kernel, [de_minimis_input_problems/2]).
:- use_module(m__eu_cbam_de_minimis_de_minimis, [de_minimis_exemption/3, de_minimis_checklist/2]).
:- use_module(m__eu_cbam_de_minimis_fixtures, [de_minimis_profile_for/2]).

test(profile_keys_are_the_contract_keys) :-
    de_minimis_profile_keys(ProfileKeys),
    ProfileKeys == [single_mass_based_threshold_tonnes, year_date_basis, net_mass_kg_by_acceptance_date, net_mass_kg_by_release_date, goods_kind].
test(the_eligibility_query_gives_one_cited_verdict) :-
    de_minimis_profile_for(at_limit_by_acceptance, Profile),
    findall(Result, de_minimis_exemption(Profile, Result, [_|_]), Results),
    Results == [de_minimis_exemption_applies].
test(the_checklist_cites_a_met_row) :-
    de_minimis_profile_for(at_limit_by_acceptance, Profile),
    findall(Items, de_minimis_checklist(Profile, Items), Checklists),
    Checklists == [[item(net_mass_kg_by_acceptance_date, met, cite(eu_reg_2023_956_art_2a_1))]].
test(the_checklist_cites_an_unmet_row) :-
    de_minimis_profile_for(one_kilogram_above_by_acceptance, Profile),
    findall(Items, de_minimis_checklist(Profile, Items), Checklists),
    Checklists == [[item(net_mass_kg_by_acceptance_date, unmet(exceeds_single_mass_based_threshold), cite(eu_reg_2023_956_art_2a_1))]].
test(the_checklist_has_one_row_per_relevant_figure) :-
    de_minimis_profile_for(unsure_figures_across_limit, Profile),
    findall(Items, de_minimis_checklist(Profile, Items), Checklists),
    Checklists == [[item(net_mass_kg_by_acceptance_date, met, cite(eu_reg_2023_956_art_2a_1)), item(net_mass_kg_by_release_date, unmet(exceeds_single_mass_based_threshold), cite(eu_reg_2023_956_art_2a_1))]].
test(what_if_one_kilogram_more_flips_the_exemption) :-
    de_minimis_profile_for(at_limit_by_acceptance, Profile),
    findall(NewStatus, de_minimis_what_if(Profile, net_mass_kg_by_acceptance_date, 50001, NewStatus), Statuses),
    Statuses == [de_minimis_exemption_does_not_apply].
test(what_if_adds_an_absent_threshold) :-
    de_minimis_profile_for(one_kilogram_without_threshold, Profile),
    findall(NewStatus, de_minimis_what_if(Profile, single_mass_based_threshold_tonnes, 50, NewStatus), Statuses),
    Statuses == [de_minimis_exemption_applies].
test(what_if_a_settled_date_basis_settles_the_referral) :-
    de_minimis_profile_for(unsure_figures_across_limit, Profile),
    findall(NewStatus, de_minimis_what_if(Profile, year_date_basis, acceptance_of_the_customs_declaration, NewStatus), Statuses),
    Statuses == [de_minimis_exemption_applies].
test(what_if_collapses_a_duplicate_key) :-
    de_minimis_profile_for(duplicate_threshold, Profile),
    findall(NewStatus, de_minimis_what_if(Profile, single_mass_based_threshold_tonnes, 50, NewStatus), Statuses),
    Statuses == [de_minimis_exemption_applies].
test(what_if_a_bad_value_gives_input_problems) :-
    de_minimis_profile_for(at_limit_by_acceptance, Profile),
    findall(NewStatus, de_minimis_what_if(Profile, single_mass_based_threshold_tonnes, 50.5, NewStatus), Statuses),
    Statuses == [input_problems([wrong_type(single_mass_based_threshold_tonnes)])].
test(the_reexported_input_check_reads_a_good_profile) :-
    de_minimis_profile_for(at_limit_by_acceptance, Profile),
    findall(Problems, de_minimis_input_problems(Profile, Problems), Answers),
    Answers == [[]].
test(the_reexported_input_check_called_directly_gives_no_problem) :-
    de_minimis_input_problems([attribute(goods_kind, electricity)], []).
test(the_reexported_input_check_called_directly_names_a_wrong_type) :-
    de_minimis_input_problems([attribute(goods_kind, steel)], [wrong_type(goods_kind)]).
test(the_reexported_input_check_called_directly_names_an_unknown_key) :-
    de_minimis_input_problems([attribute(importer_name, acme)], [unknown_key(importer_name)]).
test(the_result_atoms_are_served) :-
    de_minimis_exemption_applies,
    outside_de_minimis_exemption.
test(the_result_constructors_accept_their_shapes) :-
    indeterminate([goods_kind]),
    needs_legal_review(open_textured(year_date_basis, cite(eu_reg_2023_956_art_2a_1)), [inputs_relied_on([year_date_basis - unsure])]),
    input_problems([duplicate_key(goods_kind)]),
    duplicate_key(goods_kind).
test(the_provenance_constructor_accepts_its_shape) :-
    provenance(date_basis_verdict, [cite(eu_reg_2023_956_art_2a_1)]).
test(the_unknown_key_constructor_accepts_a_given_key) :-
    unknown_key(importer_name).
test(the_unknown_key_constructor_accepts_a_number_key) :-
    unknown_key(42).
test(the_wrong_type_constructor_accepts_a_contract_key) :-
    wrong_type(goods_kind).
test(the_wrong_type_constructor_accepts_the_profile) :-
    wrong_type(profile).

test(the_wrong_type_constructor_rejects_a_number, fail) :-
    wrong_type(42).

cp_test_names([profile_keys_are_the_contract_keys, the_eligibility_query_gives_one_cited_verdict, the_checklist_cites_a_met_row, the_checklist_cites_an_unmet_row, the_checklist_has_one_row_per_relevant_figure, what_if_one_kilogram_more_flips_the_exemption, what_if_adds_an_absent_threshold, what_if_a_settled_date_basis_settles_the_referral, what_if_collapses_a_duplicate_key, what_if_a_bad_value_gives_input_problems, the_reexported_input_check_reads_a_good_profile, the_reexported_input_check_called_directly_gives_no_problem, the_reexported_input_check_called_directly_names_a_wrong_type, the_reexported_input_check_called_directly_names_an_unknown_key, the_result_atoms_are_served, the_result_constructors_accept_their_shapes, the_provenance_constructor_accepts_its_shape, the_unknown_key_constructor_accepts_a_given_key, the_unknown_key_constructor_accepts_a_number_key, the_wrong_type_constructor_accepts_a_contract_key, the_wrong_type_constructor_accepts_the_profile]).
cp_test_fail_names([the_wrong_type_constructor_rejects_a_number]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
