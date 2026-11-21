% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_nis2_jurisdiction_registration_tests_test_load, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_nis2_jurisdiction_registration_kernel, [nis2_jurisdiction_registration_input_problems/2]).
:- use_module(m__eu_nis2_jurisdiction_registration_citations, [citation/2, citation_vocabulary/1, implements/1]).

test(an_empty_profile_has_no_problem) :-
    nis2_jurisdiction_registration_input_problems([], []).
test(a_well_formed_profile_has_no_problem) :-
    nis2_jurisdiction_registration_input_problems([attribute(entity_category, main_establishment_provider), attribute(established_in_union, true), attribute(decisions_predominantly_taken_in_one_union_member_state, unsure), attribute(sector_and_subsector_applicable, false)], []).
test(the_input_check_answers_exactly_once) :-
    findall(Problems, nis2_jurisdiction_registration_input_problems([attribute(entity_category, general_entity)], Problems), AllProblems),
    AllProblems == [[]].
test(a_term_that_is_not_a_list_is_the_wrong_type) :-
    nis2_jurisdiction_registration_input_problems(not_a_profile, [wrong_type(profile)]).
test(a_list_with_a_stray_element_is_the_wrong_type) :-
    nis2_jurisdiction_registration_input_problems([attribute(entity_category, general_entity), stray], [wrong_type(profile)]).
test(a_crisp_key_given_unsure_is_the_wrong_type) :-
    nis2_jurisdiction_registration_input_problems([attribute(established_in_union, unsure)], [wrong_type(established_in_union)]).
test(a_judgement_key_given_unsure_is_well_formed) :-
    nis2_jurisdiction_registration_input_problems([attribute(cybersecurity_operations_carried_out_in_one_union_member_state, unsure)], []).
test(an_unlisted_category_is_the_wrong_type) :-
    nis2_jurisdiction_registration_input_problems([attribute(entity_category, bank)], [wrong_type(entity_category)]).
test(a_repeated_key_is_a_duplicate_and_not_the_wrong_type) :-
    nis2_jurisdiction_registration_input_problems([attribute(entity_category, general_entity), attribute(entity_category, bank)], [duplicate_key(entity_category)]).
test(a_key_outside_the_contract_is_unknown_once) :-
    nis2_jurisdiction_registration_input_problems([attribute(colour, red), attribute(colour, blue)], [unknown_key(colour)]).
test(contract_key_problems_come_before_unknown_keys) :-
    nis2_jurisdiction_registration_input_problems([attribute(colour, red), attribute(member_states_list_applicable, maybe), attribute(entity_category, bank)], [wrong_type(entity_category), wrong_type(member_states_list_applicable), unknown_key(colour)]).
test(the_verdict_atoms_are_distinct) :-
    dif(registration_position_settled, registration_position_open),
    dif(registration_position_settled, no_single_member_state_jurisdiction),
    dif(registration_position_settled, profile_rejected),
    dif(registration_position_open, no_single_member_state_jurisdiction),
    dif(registration_position_open, profile_rejected),
    dif(no_single_member_state_jurisdiction, profile_rejected).
test(the_basis_atoms_are_distinct) :-
    dif(state_of_establishment, state_of_main_establishment),
    dif(state_of_representative, no_rule_in_article_26),
    dif(state_where_services_are_provided, state_that_established_the_entity).
test(the_verdict_term_carries_status_and_citations) :-
    Verdict = nis2_jurisdiction_registration_verdict(registration_position_settled, [cite(eu_dir_2022_2555_art_26_1)]),
    Verdict = nis2_jurisdiction_registration_verdict(Status, Citations),
    Status == registration_position_settled,
    Citations == [cite(eu_dir_2022_2555_art_26_1)].
test(the_referral_term_builds_and_destructures) :-
    Referral = needs_legal_review(open_textured(decisions_predominantly_taken_in_one_union_member_state, cite(eu_dir_2022_2555_art_26_2)), [inputs_relied_on([decisions_predominantly_taken_in_one_union_member_state - unsure])]),
    Referral = needs_legal_review(open_textured(Key, cite(Citation)), [inputs_relied_on(Pairs)]),
    Key == decisions_predominantly_taken_in_one_union_member_state,
    Citation == eu_dir_2022_2555_art_26_2,
    Pairs == [decisions_predominantly_taken_in_one_union_member_state - unsure].
test(the_item_and_limit_terms_destructure) :-
    item(Name, cite(ItemKey)) = item(entity_name, cite(eu_dir_2022_2555_art_27_2_a)),
    Name == entity_name,
    ItemKey == eu_dir_2022_2555_art_27_2_a,
    limit(Regime, months_after_change(Months), cite(LimitKey)) = limit(registry_information, months_after_change(3), cite(eu_dir_2022_2555_art_27_3)),
    Regime == registry_information,
    Months == 3,
    LimitKey == eu_dir_2022_2555_art_27_3.
test(the_indeterminate_status_names_one_key) :-
    indeterminate([Key]) = indeterminate([entity_category]),
    Key == entity_category.
test(the_main_establishment_citation_is_recorded) :-
    citation(eu_dir_2022_2555_art_26_2, _Record).
test(the_main_establishment_citation_is_result_vocabulary) :-
    citation_vocabulary(eu_dir_2022_2555_art_26_2),
    implements(eu_dir_2022_2555_art_26_2).

test(a_judgement_key_given_unsure_is_not_the_wrong_type, fail) :-
    nis2_jurisdiction_registration_input_problems([attribute(cybersecurity_operations_carried_out_in_one_union_member_state, unsure)], [wrong_type(cybersecurity_operations_carried_out_in_one_union_member_state)]).
test(an_absent_key_is_not_a_problem, fail) :-
    nis2_jurisdiction_registration_input_problems([attribute(entity_category, general_entity)], [_|_]).
test(a_shortened_citation_is_not_recorded, fail) :-
    citation(eu_dir_2022_2555_art_26, _Record).

cp_test_names([an_empty_profile_has_no_problem, a_well_formed_profile_has_no_problem, the_input_check_answers_exactly_once, a_term_that_is_not_a_list_is_the_wrong_type, a_list_with_a_stray_element_is_the_wrong_type, a_crisp_key_given_unsure_is_the_wrong_type, a_judgement_key_given_unsure_is_well_formed, an_unlisted_category_is_the_wrong_type, a_repeated_key_is_a_duplicate_and_not_the_wrong_type, a_key_outside_the_contract_is_unknown_once, contract_key_problems_come_before_unknown_keys, the_verdict_atoms_are_distinct, the_basis_atoms_are_distinct, the_verdict_term_carries_status_and_citations, the_referral_term_builds_and_destructures, the_item_and_limit_terms_destructure, the_indeterminate_status_names_one_key, the_main_establishment_citation_is_recorded, the_main_establishment_citation_is_result_vocabulary]).
cp_test_fail_names([a_judgement_key_given_unsure_is_not_the_wrong_type, an_absent_key_is_not_a_problem, a_shortened_citation_is_not_recorded]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
