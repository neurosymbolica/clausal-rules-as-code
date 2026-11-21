% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_scope_and_entity_types_tests_test_negative_controls, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_dora_scope_and_entity_types_dora_scope_and_entity_types, [dora_scope_decision/3, dora_entity_category/3, dora_scope_and_entity_types_status/2, dora_scope_and_entity_types_status_values/1]).
:- use_module(m__eu_dora_scope_and_entity_types_fixtures, [dora_scope_and_entity_types_profile_for/2]).

scope_of(Subject, Result, Citations) :-
    dora_scope_and_entity_types_profile_for(Subject, Profile),
    dora_scope_decision(Profile, Result, Citations).

category_of(Subject, Result, Citations) :-
    dora_scope_and_entity_types_profile_for(Subject, Profile),
    dora_entity_category(Profile, Result, Citations).

test(the_status_table_has_a_near_miss_atom) :-
    dora_scope_and_entity_types_status_values(StatusValues),
    StatusValues = [_, _|_].
test(unsure_crisp_value_is_an_input_problem) :-
    scope_of(unsure_crisp_value_wrong_type, input_problems([wrong_type(post_office_giro_institution_under_article_2_5_3_of_directive_2013_36)]), []).
test(false_crisp_value_is_in_scope) :-
    scope_of(credit_institution_not_giro_in_scope, in_scope(credit_institution), [cite(eu_reg_2022_2554_art_2_1_a)]).
test(absent_type_is_indeterminate) :-
    scope_of(type_absent_indeterminate, indeterminate([dora_entity_type]), []).
test(present_type_without_row_is_in_scope) :-
    scope_of(payment_institution_in_scope, in_scope(payment_institution), [cite(eu_reg_2022_2554_art_2_1_b)]).
test(unlisted_entity_is_out_of_scope) :-
    scope_of(none_of_the_listed_types_out_of_scope, out_of_scope, [cite(eu_reg_2022_2554_art_2_1)]).
test(giro_absent_is_indeterminate) :-
    scope_of(credit_institution_giro_absent_indeterminate, indeterminate([post_office_giro_institution_under_article_2_5_3_of_directive_2013_36]), []).
test(member_count_absent_is_indeterminate) :-
    scope_of(occupational_retirement_members_absent_indeterminate, indeterminate([iorp_pension_scheme_members_total]), []).
test(giro_institution_is_out_of_scope) :-
    scope_of(credit_institution_giro_out_of_scope, out_of_scope, [cite(eu_reg_2022_2554_art_2_3_f)]).
test(member_state_exclusion_is_out_of_scope) :-
    scope_of(exempted_institution_member_state_excluded, out_of_scope, [cite(eu_reg_2022_2554_art_2_4)]).
test(no_member_state_exclusion_is_in_scope) :-
    scope_of(exempted_institution_member_state_not_excluded, in_scope(institution_exempted_pursuant_to_directive_2013_36), [cite(eu_reg_2022_2554_art_2_1_a), cite(eu_reg_2022_2554_art_3_32)]).
test(exempted_investment_firm_is_out_of_scope) :-
    scope_of(investment_firm_exempted_out_of_scope, out_of_scope, [cite(eu_reg_2022_2554_art_2_3_d)]).
test(not_exempted_investment_firm_is_in_scope) :-
    scope_of(investment_firm_not_exempted_in_scope, in_scope(investment_firm), [cite(eu_reg_2022_2554_art_2_1_e)]).
test(small_fund_manager_is_out_of_scope) :-
    scope_of(small_fund_manager_out_of_scope, out_of_scope, [cite(eu_reg_2022_2554_art_2_3_a)]).
test(small_insurer_is_out_of_scope) :-
    scope_of(small_insurance_undertaking_out_of_scope, out_of_scope, [cite(eu_reg_2022_2554_art_2_3_b)]).
test(small_reinsurer_is_out_of_scope) :-
    scope_of(small_reinsurance_undertaking_out_of_scope, out_of_scope, [cite(eu_reg_2022_2554_art_2_3_b)]).
test(reinsurer_not_small_is_in_scope) :-
    dora_scope_decision([attribute(dora_entity_type, reinsurance_undertaking), attribute(undertaking_under_article_4_of_directive_2009_138, false)], in_scope(reinsurance_undertaking), [cite(eu_reg_2022_2554_art_2_1_n)]).
test(fifteen_members_is_out_of_scope) :-
    scope_of(occupational_retirement_fifteen_members_out_of_scope, out_of_scope, [cite(eu_reg_2022_2554_art_2_3_c)]).
test(sixteen_members_is_in_scope) :-
    scope_of(occupational_retirement_sixteen_members_in_scope, in_scope(institution_for_occupational_retirement_provision), [cite(eu_reg_2022_2554_art_2_1_p)]).
test(microenterprise_intermediary_is_out_of_scope) :-
    scope_of(intermediary_microenterprise_out_of_scope, out_of_scope, [cite(eu_reg_2022_2554_art_2_3_e), cite(eu_reg_2022_2554_art_3_60), cite(eu_reg_2022_2554_art_3_63), cite(eu_reg_2022_2554_art_3_64)]).
test(small_or_medium_intermediary_is_out_of_scope) :-
    scope_of(intermediary_small_or_medium_out_of_scope, out_of_scope, [cite(eu_reg_2022_2554_art_2_3_e), cite(eu_reg_2022_2554_art_3_60), cite(eu_reg_2022_2554_art_3_63), cite(eu_reg_2022_2554_art_3_64)]).
test(large_intermediary_is_in_scope) :-
    scope_of(intermediary_large_in_scope, in_scope(ancillary_insurance_intermediary), [cite(eu_reg_2022_2554_art_2_1_o)]).
test(not_microenterprise_without_second_fact_names_it) :-
    scope_of(intermediary_not_microenterprise_size_absent_indeterminate, indeterminate([financial_entity_is_small_or_medium_sized_enterprise]), []).
test(provider_is_a_provider) :-
    category_of(third_party_service_provider_in_scope, ict_third_party_service_provider, [cite(eu_reg_2022_2554_art_2_1_u), cite(eu_reg_2022_2554_art_3_19)]).
test(credit_institution_is_a_financial_entity) :-
    category_of(credit_institution_not_giro_in_scope, financial_entity, [cite(eu_reg_2022_2554_art_2_1_a), cite(eu_reg_2022_2554_art_2_2)]).
test(excluded_entity_category_is_out_of_scope) :-
    category_of(credit_institution_giro_out_of_scope, out_of_scope, [cite(eu_reg_2022_2554_art_2_3_f)]).
test(the_giro_profile_yields_exactly_one_status) :-
    dora_scope_and_entity_types_profile_for(credit_institution_giro_out_of_scope, Profile),
    findall(Status, dora_scope_and_entity_types_status(Profile, Status), Statuses),
    Statuses == [out_of_scope].

test(false_crisp_value_is_no_input_problem, fail) :-
    scope_of(credit_institution_not_giro_in_scope, input_problems(_), _).
test(present_type_is_not_indeterminate, fail) :-
    scope_of(payment_institution_in_scope, indeterminate(_), _).
test(unlisted_entity_is_not_in_scope, fail) :-
    scope_of(none_of_the_listed_types_out_of_scope, in_scope(_), _).
test(listed_entity_is_not_out_of_scope, fail) :-
    scope_of(payment_institution_in_scope, out_of_scope, _).
test(giro_false_is_not_indeterminate, fail) :-
    scope_of(credit_institution_not_giro_in_scope, indeterminate(_), _).
test(member_count_present_is_not_indeterminate, fail) :-
    scope_of(occupational_retirement_sixteen_members_in_scope, indeterminate(_), _).
test(not_giro_institution_is_not_out_of_scope, fail) :-
    scope_of(credit_institution_not_giro_in_scope, out_of_scope, _).
test(no_member_state_exclusion_is_not_out_of_scope, fail) :-
    scope_of(exempted_institution_member_state_not_excluded, out_of_scope, _).
test(not_exempted_investment_firm_is_not_out_of_scope, fail) :-
    scope_of(investment_firm_not_exempted_in_scope, out_of_scope, _).
test(fund_manager_not_small_is_not_out_of_scope, fail) :-
    scope_of(fund_manager_not_small_in_scope, out_of_scope, _).
test(insurer_not_small_is_not_out_of_scope, fail) :-
    scope_of(insurance_undertaking_not_small_in_scope, out_of_scope, _).
test(reinsurer_not_small_is_not_out_of_scope, fail) :-
    dora_scope_decision([attribute(dora_entity_type, reinsurance_undertaking), attribute(undertaking_under_article_4_of_directive_2009_138, false)], out_of_scope, _).
test(fifteen_members_is_not_in_scope, fail) :-
    scope_of(occupational_retirement_fifteen_members_out_of_scope, in_scope(_), _).
test(sixteen_members_is_not_out_of_scope, fail) :-
    scope_of(occupational_retirement_sixteen_members_in_scope, out_of_scope, _).
test(large_intermediary_is_not_out_of_scope, fail) :-
    scope_of(intermediary_large_in_scope, out_of_scope, _).
test(not_microenterprise_without_second_fact_is_not_out_of_scope, fail) :-
    scope_of(intermediary_not_microenterprise_size_absent_indeterminate, out_of_scope, _).
test(provider_is_not_a_financial_entity, fail) :-
    category_of(third_party_service_provider_in_scope, financial_entity, _).
test(credit_institution_is_not_a_provider, fail) :-
    category_of(credit_institution_not_giro_in_scope, ict_third_party_service_provider, _).
test(excluded_entity_is_not_a_financial_entity, fail) :-
    category_of(credit_institution_giro_out_of_scope, financial_entity, _).
test(the_giro_profile_yields_no_other_table_status, fail) :-
    dora_scope_and_entity_types_profile_for(credit_institution_giro_out_of_scope, Profile),
    dora_scope_and_entity_types_status_values(StatusValues),
    member(Other, StatusValues),
    dif(Other, out_of_scope),
    dora_scope_and_entity_types_status(Profile, Other).

cp_test_names([the_status_table_has_a_near_miss_atom, unsure_crisp_value_is_an_input_problem, false_crisp_value_is_in_scope, absent_type_is_indeterminate, present_type_without_row_is_in_scope, unlisted_entity_is_out_of_scope, giro_absent_is_indeterminate, member_count_absent_is_indeterminate, giro_institution_is_out_of_scope, member_state_exclusion_is_out_of_scope, no_member_state_exclusion_is_in_scope, exempted_investment_firm_is_out_of_scope, not_exempted_investment_firm_is_in_scope, small_fund_manager_is_out_of_scope, small_insurer_is_out_of_scope, small_reinsurer_is_out_of_scope, reinsurer_not_small_is_in_scope, fifteen_members_is_out_of_scope, sixteen_members_is_in_scope, microenterprise_intermediary_is_out_of_scope, small_or_medium_intermediary_is_out_of_scope, large_intermediary_is_in_scope, not_microenterprise_without_second_fact_names_it, provider_is_a_provider, credit_institution_is_a_financial_entity, excluded_entity_category_is_out_of_scope, the_giro_profile_yields_exactly_one_status]).
cp_test_fail_names([false_crisp_value_is_no_input_problem, present_type_is_not_indeterminate, unlisted_entity_is_not_in_scope, listed_entity_is_not_out_of_scope, giro_false_is_not_indeterminate, member_count_present_is_not_indeterminate, not_giro_institution_is_not_out_of_scope, no_member_state_exclusion_is_not_out_of_scope, not_exempted_investment_firm_is_not_out_of_scope, fund_manager_not_small_is_not_out_of_scope, insurer_not_small_is_not_out_of_scope, reinsurer_not_small_is_not_out_of_scope, fifteen_members_is_not_in_scope, sixteen_members_is_not_out_of_scope, large_intermediary_is_not_out_of_scope, not_microenterprise_without_second_fact_is_not_out_of_scope, provider_is_not_a_financial_entity, credit_institution_is_not_a_provider, excluded_entity_is_not_a_financial_entity, the_giro_profile_yields_no_other_table_status]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
