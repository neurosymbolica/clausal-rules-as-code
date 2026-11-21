% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_scope_and_entity_types_tests_test_queries, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_dora_scope_and_entity_types_queries, [dora_scope_and_entity_types_profile_keys/1, dora_scope_and_entity_types_what_if/4, out_of_scope/0, financial_entity/0, dora_entity_type/0, none_of_the_listed_types/0, ict_third_party_service_provider/0, credit_institution/0]).
:- use_module(m__eu_dora_scope_and_entity_types_kernel, [dora_scope_and_entity_types_input_problems/2]).
:- use_module(m__eu_dora_scope_and_entity_types_dora_scope_and_entity_types, [dora_scope_decision/3, dora_scope_and_entity_types_checklist/2]).

test(profile_keys_are_the_contract_keys) :-
    dora_scope_and_entity_types_profile_keys(ProfileKeys),
    ProfileKeys == [dora_entity_type, aifm_under_article_3_2_of_directive_2011_61, undertaking_under_article_4_of_directive_2009_138, iorp_pension_scheme_members_total, exempted_under_articles_2_and_3_of_directive_2014_65, financial_entity_is_microenterprise, financial_entity_is_small_or_medium_sized_enterprise, post_office_giro_institution_under_article_2_5_3_of_directive_2013_36, exempted_from_dora_scope_by_member_state].
test(eligibility_query_answers_once) :-
    findall(Result - Citations, dora_scope_decision([attribute(dora_entity_type, crowdfunding_service_provider)], Result, Citations), Answers),
    Answers == [in_scope(crowdfunding_service_provider) - [cite(eu_reg_2022_2554_art_2_1_s)]].
test(justification_checklist_carries_citations) :-
    findall(Items, dora_scope_and_entity_types_checklist([attribute(dora_entity_type, ict_third_party_service_provider)], Items), Checklists),
    Checklists == [[item(listed_type, met, [cite(eu_reg_2022_2554_art_2_1_u), cite(eu_reg_2022_2554_art_3_19)]), item(no_exclusion, met, [cite(eu_reg_2022_2554_art_2_1)])]].
test(justification_checklist_of_an_input_problem) :-
    dora_scope_and_entity_types_checklist([attribute(colour, blue)], [item(input_check, unmet(input_problems([unknown_key(colour)])), [cite(eu_reg_2022_2554_art_2_1)])]).
test(what_if_supplies_the_type) :-
    findall(NewStatus, dora_scope_and_entity_types_what_if([], dora_entity_type, trading_venue, NewStatus), Statuses),
    Statuses == [in_scope(trading_venue)].
test(what_if_flips_an_exclusion) :-
    findall(NewStatus, dora_scope_and_entity_types_what_if([attribute(dora_entity_type, investment_firm), attribute(exempted_under_articles_2_and_3_of_directive_2014_65, true)], exempted_under_articles_2_and_3_of_directive_2014_65, false, NewStatus), Statuses),
    Statuses == [in_scope(investment_firm)].
test(what_if_replaces_every_duplicate) :-
    findall(NewStatus, dora_scope_and_entity_types_what_if([attribute(dora_entity_type, trading_venue), attribute(dora_entity_type, credit_institution)], dora_entity_type, payment_institution, NewStatus), Statuses),
    Statuses == [in_scope(payment_institution)].
test(what_if_with_a_bad_value_is_an_input_problem) :-
    findall(NewStatus, dora_scope_and_entity_types_what_if([attribute(dora_entity_type, trading_venue)], dora_entity_type, bank, NewStatus), Statuses),
    Statuses == [input_problems([wrong_type(dora_entity_type)])].
test(what_if_on_a_non_list_keeps_the_input_problem) :-
    findall(NewStatus, dora_scope_and_entity_types_what_if(not_an_attribute_list, dora_entity_type, trading_venue, NewStatus), Statuses),
    Statuses == [input_problems([wrong_type(profile)])].
test(re_exported_input_check_answers_once) :-
    findall(Problems, dora_scope_and_entity_types_input_problems([attribute(dora_entity_type, trading_venue)], Problems), Answers),
    Answers == [[]].
test(root_atoms_are_served) :-
    out_of_scope,
    financial_entity,
    dora_entity_type,
    none_of_the_listed_types,
    ict_third_party_service_provider,
    credit_institution.

test(what_if_does_not_reach_the_wrong_answer, fail) :-
    dora_scope_and_entity_types_what_if([attribute(dora_entity_type, credit_institution)], post_office_giro_institution_under_article_2_5_3_of_directive_2013_36, false, out_of_scope).

cp_test_names([profile_keys_are_the_contract_keys, eligibility_query_answers_once, justification_checklist_carries_citations, justification_checklist_of_an_input_problem, what_if_supplies_the_type, what_if_flips_an_exclusion, what_if_replaces_every_duplicate, what_if_with_a_bad_value_is_an_input_problem, what_if_on_a_non_list_keeps_the_input_problem, re_exported_input_check_answers_once, root_atoms_are_served]).
cp_test_fail_names([what_if_does_not_reach_the_wrong_answer]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
