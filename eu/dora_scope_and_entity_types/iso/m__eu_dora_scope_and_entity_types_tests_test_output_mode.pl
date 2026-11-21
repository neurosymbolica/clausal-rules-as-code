% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_scope_and_entity_types_tests_test_output_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_dora_scope_and_entity_types_dora_scope_and_entity_types, [dora_scope_decision/3, dora_entity_category/3, decide_dora_scope_and_entity_types/2, dora_scope_and_entity_types_status/2, dora_scope_and_entity_types_checklist/2]).
:- use_module(m__eu_dora_scope_and_entity_types_fixtures, [dora_scope_and_entity_types_profile_for/2]).

scope_answers(Subject, Answers) :-
    dora_scope_and_entity_types_profile_for(Subject, Profile),
    findall(Result - Citations, dora_scope_decision(Profile, Result, Citations), Answers).

category_answers(Subject, Answers) :-
    dora_scope_and_entity_types_profile_for(Subject, Profile),
    findall(Result - Citations, dora_entity_category(Profile, Result, Citations), Answers).

test(input_problems_route) :-
    scope_answers(negative_member_count_wrong_type, Answers),
    Answers == [input_problems([wrong_type(iorp_pension_scheme_members_total)]) - []].
test(profile_not_a_list_route) :-
    scope_answers(profile_not_an_attribute_list, Answers),
    Answers == [input_problems([wrong_type(profile)]) - []].
test(type_absent_route) :-
    scope_answers(type_absent_indeterminate, Answers),
    Answers == [indeterminate([dora_entity_type]) - []].
test(none_of_the_listed_types_route) :-
    scope_answers(none_of_the_listed_types_out_of_scope, Answers),
    Answers == [out_of_scope - [cite(eu_reg_2022_2554_art_2_1)]].
test(giro_excluded_route) :-
    scope_answers(credit_institution_giro_out_of_scope, Answers),
    Answers == [out_of_scope - [cite(eu_reg_2022_2554_art_2_3_f)]].
test(giro_missing_route) :-
    scope_answers(credit_institution_giro_absent_indeterminate, Answers),
    Answers == [indeterminate([post_office_giro_institution_under_article_2_5_3_of_directive_2013_36]) - []].
test(member_state_excluded_route) :-
    scope_answers(exempted_institution_member_state_excluded, Answers),
    Answers == [out_of_scope - [cite(eu_reg_2022_2554_art_2_4)]].
test(exempted_institution_in_scope_route) :-
    scope_answers(exempted_institution_member_state_not_excluded, Answers),
    Answers == [in_scope(institution_exempted_pursuant_to_directive_2013_36) - [cite(eu_reg_2022_2554_art_2_1_a), cite(eu_reg_2022_2554_art_3_32)]].
test(exempted_payment_institution_route) :-
    scope_answers(exempted_payment_institution_in_scope, Answers),
    Answers == [in_scope(exempted_payment_institution) - [cite(eu_reg_2022_2554_art_2_1_b), cite(eu_reg_2022_2554_art_3_36)]].
test(exempted_electronic_money_institution_route) :-
    scope_answers(exempted_electronic_money_institution_in_scope, Answers),
    Answers == [in_scope(exempted_electronic_money_institution) - [cite(eu_reg_2022_2554_art_2_1_d), cite(eu_reg_2022_2554_art_3_39)]].
test(investment_firm_excluded_route) :-
    scope_answers(investment_firm_exempted_out_of_scope, Answers),
    Answers == [out_of_scope - [cite(eu_reg_2022_2554_art_2_3_d)]].
test(fund_manager_excluded_route) :-
    scope_answers(small_fund_manager_out_of_scope, Answers),
    Answers == [out_of_scope - [cite(eu_reg_2022_2554_art_2_3_a)]].
test(fund_manager_in_scope_route) :-
    scope_answers(fund_manager_not_small_in_scope, Answers),
    Answers == [in_scope(manager_of_alternative_investment_funds) - [cite(eu_reg_2022_2554_art_2_1_k)]].
test(insurance_undertaking_excluded_route) :-
    scope_answers(small_insurance_undertaking_out_of_scope, Answers),
    Answers == [out_of_scope - [cite(eu_reg_2022_2554_art_2_3_b)]].
test(insurance_undertaking_in_scope_route) :-
    scope_answers(insurance_undertaking_not_small_in_scope, Answers),
    Answers == [in_scope(insurance_undertaking) - [cite(eu_reg_2022_2554_art_2_1_n)]].
test(at_the_member_ceiling_is_out_of_scope) :-
    scope_answers(occupational_retirement_fifteen_members_out_of_scope, Answers),
    Answers == [out_of_scope - [cite(eu_reg_2022_2554_art_2_3_c)]].
test(one_member_above_the_ceiling_is_in_scope) :-
    scope_answers(occupational_retirement_sixteen_members_in_scope, Answers),
    Answers == [in_scope(institution_for_occupational_retirement_provision) - [cite(eu_reg_2022_2554_art_2_1_p)]].
test(member_count_missing_route) :-
    scope_answers(occupational_retirement_members_absent_indeterminate, Answers),
    Answers == [indeterminate([iorp_pension_scheme_members_total]) - []].
test(intermediary_microenterprise_route) :-
    scope_answers(intermediary_microenterprise_out_of_scope, Answers),
    Answers == [out_of_scope - [cite(eu_reg_2022_2554_art_2_3_e), cite(eu_reg_2022_2554_art_3_60), cite(eu_reg_2022_2554_art_3_63), cite(eu_reg_2022_2554_art_3_64)]].
test(intermediary_small_or_medium_route) :-
    scope_answers(intermediary_small_or_medium_out_of_scope, Answers),
    Answers == [out_of_scope - [cite(eu_reg_2022_2554_art_2_3_e), cite(eu_reg_2022_2554_art_3_60), cite(eu_reg_2022_2554_art_3_63), cite(eu_reg_2022_2554_art_3_64)]].
test(intermediary_large_route) :-
    scope_answers(intermediary_large_in_scope, Answers),
    Answers == [in_scope(ancillary_insurance_intermediary) - [cite(eu_reg_2022_2554_art_2_1_o)]].
test(intermediary_size_absent_names_microenterprise) :-
    scope_answers(intermediary_size_absent_indeterminate, Answers),
    Answers == [indeterminate([financial_entity_is_microenterprise]) - []].
test(intermediary_not_microenterprise_names_small_or_medium) :-
    scope_answers(intermediary_not_microenterprise_size_absent_indeterminate, Answers),
    Answers == [indeterminate([financial_entity_is_small_or_medium_sized_enterprise]) - []].
test(provider_route) :-
    scope_answers(third_party_service_provider_in_scope, Answers),
    Answers == [in_scope(ict_third_party_service_provider) - [cite(eu_reg_2022_2554_art_2_1_u), cite(eu_reg_2022_2554_art_3_19)]].
test(other_type_key_route) :-
    scope_answers(other_type_exclusion_key_not_read, Answers),
    Answers == [in_scope(trading_venue) - [cite(eu_reg_2022_2554_art_2_1_i)]].
test(category_financial_entity_route) :-
    category_answers(exempted_institution_member_state_not_excluded, Answers),
    Answers == [financial_entity - [cite(eu_reg_2022_2554_art_2_1_a), cite(eu_reg_2022_2554_art_3_32), cite(eu_reg_2022_2554_art_2_2)]].
test(category_provider_route) :-
    category_answers(third_party_service_provider_in_scope, Answers),
    Answers == [ict_third_party_service_provider - [cite(eu_reg_2022_2554_art_2_1_u), cite(eu_reg_2022_2554_art_3_19)]].
test(category_out_of_scope_route) :-
    category_answers(small_reinsurance_undertaking_out_of_scope, Answers),
    Answers == [out_of_scope - [cite(eu_reg_2022_2554_art_2_3_b)]].
test(category_indeterminate_route) :-
    category_answers(type_absent_indeterminate, Answers),
    Answers == [indeterminate([dora_entity_type]) - []].
test(category_input_problems_route) :-
    category_answers(duplicate_type_key_problem, Answers),
    Answers == [input_problems([duplicate_key(dora_entity_type)]) - []].
test(the_verdict_is_read_out_once_with_its_citation) :-
    dora_scope_and_entity_types_profile_for(payment_institution_in_scope, Profile),
    findall(Verdict, decide_dora_scope_and_entity_types(Profile, Verdict), Verdicts),
    Verdicts == [dora_scope_and_entity_types_verdict(in_scope(payment_institution), [cite(eu_reg_2022_2554_art_2_1_b)])].
test(the_status_is_read_out_once) :-
    dora_scope_and_entity_types_profile_for(unknown_key_problem, Profile),
    findall(Status, dora_scope_and_entity_types_status(Profile, Status), Statuses),
    Statuses == [input_problems([unknown_key(colour)])].
test(the_checklist_of_an_excluded_entity) :-
    dora_scope_and_entity_types_profile_for(credit_institution_giro_out_of_scope, Profile),
    findall(Items, dora_scope_and_entity_types_checklist(Profile, Items), Checklists),
    Checklists == [[item(listed_type, met, [cite(eu_reg_2022_2554_art_2_1)]), item(no_exclusion, unmet(excluded), [cite(eu_reg_2022_2554_art_2_3_f)])]].
test(the_checklist_of_an_unlisted_entity) :-
    dora_scope_and_entity_types_profile_for(none_of_the_listed_types_out_of_scope, Profile),
    findall(Items, dora_scope_and_entity_types_checklist(Profile, Items), Checklists),
    Checklists == [[item(listed_type, unmet(none_of_the_listed_types), [cite(eu_reg_2022_2554_art_2_1)]), item(no_exclusion, unknown([dora_entity_type]), [cite(eu_reg_2022_2554_art_2_1)])]].

cp_test_names([input_problems_route, profile_not_a_list_route, type_absent_route, none_of_the_listed_types_route, giro_excluded_route, giro_missing_route, member_state_excluded_route, exempted_institution_in_scope_route, exempted_payment_institution_route, exempted_electronic_money_institution_route, investment_firm_excluded_route, fund_manager_excluded_route, fund_manager_in_scope_route, insurance_undertaking_excluded_route, insurance_undertaking_in_scope_route, at_the_member_ceiling_is_out_of_scope, one_member_above_the_ceiling_is_in_scope, member_count_missing_route, intermediary_microenterprise_route, intermediary_small_or_medium_route, intermediary_large_route, intermediary_size_absent_names_microenterprise, intermediary_not_microenterprise_names_small_or_medium, provider_route, other_type_key_route, category_financial_entity_route, category_provider_route, category_out_of_scope_route, category_indeterminate_route, category_input_problems_route, the_verdict_is_read_out_once_with_its_citation, the_status_is_read_out_once, the_checklist_of_an_excluded_entity, the_checklist_of_an_unlisted_entity]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
