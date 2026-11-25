% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_ctpp_designation_tests_test_load, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_dora_ctpp_designation_kernel, [dora_ctpp_designation_input_problems/2, dora_ctpp_designation_shared_type/3, dora_ctpp_designation_financial_entity_type/2, dora_ctpp_designation_category_synonym/3]).
:- use_module(m__eu_dora_ctpp_designation_citations, [citation/2, implements/1]).

test(the_designation_result_term_destructures) :-
    Result = designation_not_applicable(financial_entity),
    Result = designation_not_applicable(Ground),
    Ground == financial_entity.
test(the_indicators_result_term_destructures) :-
    Result = step_1_indicators([sub_criteria_1_1_and_1_2([credit_institution]), sub_criterion_2_1, sub_criterion_2_2, sub_criterion_4_1([payment_institution]), sub_criterion_4_2([insurance_undertaking])]),
    Result = step_1_indicators([sub_criteria_1_1_and_1_2(ImpactCategories), FirstItem, SecondItem, sub_criterion_4_1(AlternativeCategories), sub_criterion_4_2(MigrationCategories)]),
    ImpactCategories == [credit_institution],
    FirstItem == sub_criterion_2_1,
    SecondItem == sub_criterion_2_2,
    AlternativeCategories == [payment_institution],
    MigrationCategories == [insurance_undertaking].
test(the_lead_overseer_result_terms_destructure) :-
    Single = lead_overseer(eba),
    Single = lead_overseer(Authority),
    Authority == eba,
    Tied = lead_overseer_tied([eiopa, esma]),
    Tied = lead_overseer_tied(Authorities),
    Authorities == [eiopa, esma].
test(the_duties_result_term_destructures) :-
    Result = required([designate_coordination_point, notify_financial_entities_of_designation, notify_lead_overseer_of_subsidiary_management_changes]),
    Result = required(Duties),
    length(Duties, DutyCount),
    DutyCount =:= 3.
test(the_status_compounds_destructure) :-
    Missing = indeterminate([dora_entity_type]),
    Missing = indeterminate([MissingKey]),
    MissingKey == dora_entity_type,
    Problems = input_problems([duplicate_key(g_sii_served_count), wrong_type(dora_entity_type), unknown_key(surplus)]),
    Problems = input_problems(ProblemList),
    length(ProblemList, ProblemCount),
    ProblemCount =:= 3.
test(the_facade_verdict_term_carries_status_and_citations) :-
    Verdict = dora_ctpp_designation_verdict(step_1_sub_criteria_fulfilled, [cite(eu_reg_2022_2554_art_31_1_a)]),
    Verdict = dora_ctpp_designation_verdict(Status, Citations),
    Status == step_1_sub_criteria_fulfilled,
    Citations == [cite(eu_reg_2022_2554_art_31_1_a)].
test(the_criteria_status_atoms_are_distinct) :-
    dif(not_an_ict_third_party_service_provider, step_1_sub_criteria_not_fulfilled),
    dif(not_an_ict_third_party_service_provider, step_1_sub_criteria_fulfilled),
    dif(step_1_sub_criteria_not_fulfilled, step_1_sub_criteria_fulfilled).
test(the_grounds_are_distinct) :-
    dif(financial_entity, article_127_2_tfeu_oversight_framework),
    dif(financial_entity, ict_intra_group_service_provider),
    dif(financial_entity, single_member_state_provider),
    dif(article_127_2_tfeu_oversight_framework, ict_intra_group_service_provider),
    dif(article_127_2_tfeu_oversight_framework, single_member_state_provider),
    dif(ict_intra_group_service_provider, single_member_state_provider).
test(the_authority_and_duty_atoms_are_distinct) :-
    dif(eba, eiopa),
    dif(eba, esma),
    dif(eiopa, esma),
    dif(designate_coordination_point, notify_financial_entities_of_designation),
    dif(designate_coordination_point, notify_lead_overseer_of_subsidiary_management_changes),
    dif(notify_financial_entities_of_designation, notify_lead_overseer_of_subsidiary_management_changes),
    dif(not_designated_as_critical, sub_criterion_2_1),
    dif(sub_criterion_2_1, sub_criterion_2_2).
test(the_designation_citation_is_recorded) :-
    citation(eu_reg_2022_2554_art_31_1_a, Record),
    Record = [label - _, ref - _, verbatim - _].
test(the_lead_overseer_citation_is_recorded) :-
    citation(eu_reg_2022_2554_art_31_1_b, _).
test(every_returned_citation_key_is_recorded) :-
    maplist(implements, [eu_reg_2022_2554_art_31_1_a, eu_reg_2022_2554_art_31_1_b, eu_reg_2022_2554_art_31_2, eu_reg_2022_2554_art_31_3, eu_reg_2022_2554_art_31_4, eu_reg_2022_2554_art_31_5, eu_reg_2022_2554_art_31_8, eu_reg_2022_2554_art_31_8_i, eu_reg_2022_2554_art_31_8_ii, eu_reg_2022_2554_art_31_8_iii, eu_reg_2022_2554_art_31_8_iv, eu_reg_2022_2554_art_31_13, eu_reg_2024_1502_art_1_1, eu_reg_2024_1502_art_1_2, eu_reg_2024_1502_art_2_1, eu_reg_2024_1502_art_2_2, eu_reg_2024_1502_art_2_3, eu_reg_2024_1502_art_2_4, eu_reg_2024_1502_art_3_1, eu_reg_2024_1502_art_3_2, eu_reg_2024_1502_art_3_3, eu_reg_2024_1502_art_5_1, eu_reg_2024_1502_art_5_2, eu_reg_2024_1502_art_5_3, eu_reg_2024_1502_art_5_4]).
test(the_shared_type_set_has_twenty_seven_atoms) :-
    findall(Atom, dora_ctpp_designation_shared_type(Atom, _, _), Atoms),
    length(Atoms, AtomCount),
    AtomCount =:= 27.
test(the_financial_entity_atoms_are_twenty_six) :-
    findall(Atom, dora_ctpp_designation_financial_entity_type(Atom, _), Atoms),
    length(Atoms, AtomCount),
    AtomCount =:= 26.
test(the_ict_provider_is_in_the_shared_type_set) :-
    dora_ctpp_designation_shared_type(ict_third_party_service_provider, Position, _),
    Position =:= 26.
test(the_two_synonyms_name_their_main_atoms) :-
    findall(Synonym - Main, dora_ctpp_designation_category_synonym(Synonym, Main, _), Pairs),
    Pairs == [exempted_payment_institution - payment_institution, exempted_electronic_money_institution - electronic_money_institution].
test(an_empty_profile_has_no_problem) :-
    findall(Problems, dora_ctpp_designation_input_problems([], Problems), Answers),
    Answers == [[]].
test(a_non_list_profile_is_wrong_type) :-
    dora_ctpp_designation_input_problems(surplus, Problems),
    Problems == [wrong_type(profile)].

test(an_unrecorded_citation_key_does_not_resolve, fail) :-
    implements(eu_todo_primary_source).
test(the_ict_provider_is_no_financial_entity, fail) :-
    dora_ctpp_designation_financial_entity_type(ict_third_party_service_provider, _).

cp_test_names([the_designation_result_term_destructures, the_indicators_result_term_destructures, the_lead_overseer_result_terms_destructure, the_duties_result_term_destructures, the_status_compounds_destructure, the_facade_verdict_term_carries_status_and_citations, the_criteria_status_atoms_are_distinct, the_grounds_are_distinct, the_authority_and_duty_atoms_are_distinct, the_designation_citation_is_recorded, the_lead_overseer_citation_is_recorded, every_returned_citation_key_is_recorded, the_shared_type_set_has_twenty_seven_atoms, the_financial_entity_atoms_are_twenty_six, the_ict_provider_is_in_the_shared_type_set, the_two_synonyms_name_their_main_atoms, an_empty_profile_has_no_problem, a_non_list_profile_is_wrong_type]).
cp_test_fail_names([an_unrecorded_citation_key_does_not_resolve, the_ict_provider_is_no_financial_entity]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
