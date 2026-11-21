% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_scope_and_entity_types_tests_test_public_interface, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_dora_scope_and_entity_types_dora_scope_and_entity_types, [dora_scope_decision/3, dora_entity_category/3, decide_dora_scope_and_entity_types/2, dora_scope_and_entity_types_status/2, dora_scope_and_entity_types_checklist/2, dora_scope_and_entity_types_decision_resolvable/1, dora_scope_and_entity_types_status_values/1]).
:- use_module(m__eu_dora_scope_and_entity_types_kernel, [dora_scope_and_entity_types_input_problems/2]).
:- use_module(m__eu_dora_scope_and_entity_types_queries, [dora_scope_and_entity_types_what_if/4]).
:- use_module(m__eu_dora_scope_and_entity_types_fixtures, [dora_scope_and_entity_types_subject/1, dora_scope_and_entity_types_profile_for/2, dora_scope_and_entity_types_assess/2]).

sole_verdict(Subject, Status, Citations) :-
    findall(Verdict, dora_scope_and_entity_types_assess(Subject, Verdict), Verdicts),
    Verdicts == [dora_scope_and_entity_types_verdict(Status, Citations)].

sole_category(Subject, Category, Citations) :-
    dora_scope_and_entity_types_profile_for(Subject, Profile),
    findall(Result - ResultCitations, dora_entity_category(Profile, Result, ResultCitations), Answers),
    Answers == [Category - Citations].

every_subject_well_behaved([]).
every_subject_well_behaved([Subject|Subjects]) :-
    findall(Verdict, dora_scope_and_entity_types_assess(Subject, Verdict), Verdicts),
    length(Verdicts, 1),
    dora_scope_and_entity_types_assess(Subject, dora_scope_and_entity_types_verdict(Status, _Citations)),
    dora_scope_and_entity_types_status_values(StatusValues),
    member(Status, StatusValues),
    dora_scope_and_entity_types_profile_for(Subject, Profile),
    findall(Checklist, dora_scope_and_entity_types_checklist(Profile, Checklist), Checklists),
    Checklists = [[_FirstItem|_OtherItems]],
    findall(CategoryResult, dora_entity_category(Profile, CategoryResult, _CategoryCitations), CategoryResults),
    length(CategoryResults, 1),
    every_subject_well_behaved(Subjects).

test(every_subject_has_one_verdict_and_a_checklist) :-
    findall(Subject, dora_scope_and_entity_types_subject(Subject), Subjects),
    length(Subjects, 33),
    every_subject_well_behaved(Subjects).
test(credit_institution_not_giro_in_scope) :-
    sole_verdict(credit_institution_not_giro_in_scope, in_scope(credit_institution), [cite(eu_reg_2022_2554_art_2_1_a)]).
test(credit_institution_giro_out_of_scope) :-
    sole_verdict(credit_institution_giro_out_of_scope, out_of_scope, [cite(eu_reg_2022_2554_art_2_3_f)]).
test(credit_institution_giro_absent_indeterminate) :-
    sole_verdict(credit_institution_giro_absent_indeterminate, indeterminate([post_office_giro_institution_under_article_2_5_3_of_directive_2013_36]), []).
test(exempted_institution_member_state_excluded) :-
    sole_verdict(exempted_institution_member_state_excluded, out_of_scope, [cite(eu_reg_2022_2554_art_2_4)]).
test(exempted_institution_member_state_not_excluded) :-
    sole_verdict(exempted_institution_member_state_not_excluded, in_scope(institution_exempted_pursuant_to_directive_2013_36), [cite(eu_reg_2022_2554_art_2_1_a), cite(eu_reg_2022_2554_art_3_32)]).
test(exempted_institution_not_excluded_is_a_financial_entity) :-
    sole_category(exempted_institution_member_state_not_excluded, financial_entity, [cite(eu_reg_2022_2554_art_2_1_a), cite(eu_reg_2022_2554_art_3_32), cite(eu_reg_2022_2554_art_2_2)]).
test(payment_institution_in_scope) :-
    sole_verdict(payment_institution_in_scope, in_scope(payment_institution), [cite(eu_reg_2022_2554_art_2_1_b)]).
test(exempted_payment_institution_in_scope) :-
    sole_verdict(exempted_payment_institution_in_scope, in_scope(exempted_payment_institution), [cite(eu_reg_2022_2554_art_2_1_b), cite(eu_reg_2022_2554_art_3_36)]).
test(exempted_electronic_money_institution_in_scope) :-
    sole_verdict(exempted_electronic_money_institution_in_scope, in_scope(exempted_electronic_money_institution), [cite(eu_reg_2022_2554_art_2_1_d), cite(eu_reg_2022_2554_art_3_39)]).
test(investment_firm_exempted_out_of_scope) :-
    sole_verdict(investment_firm_exempted_out_of_scope, out_of_scope, [cite(eu_reg_2022_2554_art_2_3_d)]).
test(investment_firm_not_exempted_in_scope) :-
    sole_verdict(investment_firm_not_exempted_in_scope, in_scope(investment_firm), [cite(eu_reg_2022_2554_art_2_1_e)]).
test(small_fund_manager_out_of_scope) :-
    sole_verdict(small_fund_manager_out_of_scope, out_of_scope, [cite(eu_reg_2022_2554_art_2_3_a)]).
test(fund_manager_not_small_in_scope) :-
    sole_verdict(fund_manager_not_small_in_scope, in_scope(manager_of_alternative_investment_funds), [cite(eu_reg_2022_2554_art_2_1_k)]).
test(small_insurance_undertaking_out_of_scope) :-
    sole_verdict(small_insurance_undertaking_out_of_scope, out_of_scope, [cite(eu_reg_2022_2554_art_2_3_b)]).
test(insurance_undertaking_not_small_in_scope) :-
    sole_verdict(insurance_undertaking_not_small_in_scope, in_scope(insurance_undertaking), [cite(eu_reg_2022_2554_art_2_1_n)]).
test(small_reinsurance_undertaking_out_of_scope) :-
    sole_verdict(small_reinsurance_undertaking_out_of_scope, out_of_scope, [cite(eu_reg_2022_2554_art_2_3_b)]).
test(occupational_retirement_fifteen_members_out_of_scope) :-
    sole_verdict(occupational_retirement_fifteen_members_out_of_scope, out_of_scope, [cite(eu_reg_2022_2554_art_2_3_c)]).
test(occupational_retirement_sixteen_members_in_scope) :-
    sole_verdict(occupational_retirement_sixteen_members_in_scope, in_scope(institution_for_occupational_retirement_provision), [cite(eu_reg_2022_2554_art_2_1_p)]).
test(occupational_retirement_members_absent_indeterminate) :-
    sole_verdict(occupational_retirement_members_absent_indeterminate, indeterminate([iorp_pension_scheme_members_total]), []).
test(intermediary_microenterprise_out_of_scope) :-
    sole_verdict(intermediary_microenterprise_out_of_scope, out_of_scope, [cite(eu_reg_2022_2554_art_2_3_e), cite(eu_reg_2022_2554_art_3_60), cite(eu_reg_2022_2554_art_3_63), cite(eu_reg_2022_2554_art_3_64)]).
test(intermediary_small_or_medium_out_of_scope) :-
    sole_verdict(intermediary_small_or_medium_out_of_scope, out_of_scope, [cite(eu_reg_2022_2554_art_2_3_e), cite(eu_reg_2022_2554_art_3_60), cite(eu_reg_2022_2554_art_3_63), cite(eu_reg_2022_2554_art_3_64)]).
test(intermediary_large_in_scope) :-
    sole_verdict(intermediary_large_in_scope, in_scope(ancillary_insurance_intermediary), [cite(eu_reg_2022_2554_art_2_1_o)]).
test(intermediary_large_is_a_financial_entity) :-
    sole_category(intermediary_large_in_scope, financial_entity, [cite(eu_reg_2022_2554_art_2_1_o), cite(eu_reg_2022_2554_art_2_2)]).
test(intermediary_size_absent_indeterminate) :-
    sole_verdict(intermediary_size_absent_indeterminate, indeterminate([financial_entity_is_microenterprise]), []).
test(intermediary_not_microenterprise_size_absent_indeterminate) :-
    sole_verdict(intermediary_not_microenterprise_size_absent_indeterminate, indeterminate([financial_entity_is_small_or_medium_sized_enterprise]), []).
test(third_party_service_provider_in_scope) :-
    sole_verdict(third_party_service_provider_in_scope, in_scope(ict_third_party_service_provider), [cite(eu_reg_2022_2554_art_2_1_u), cite(eu_reg_2022_2554_art_3_19)]).
test(third_party_service_provider_category) :-
    sole_category(third_party_service_provider_in_scope, ict_third_party_service_provider, [cite(eu_reg_2022_2554_art_2_1_u), cite(eu_reg_2022_2554_art_3_19)]).
test(none_of_the_listed_types_out_of_scope) :-
    sole_verdict(none_of_the_listed_types_out_of_scope, out_of_scope, [cite(eu_reg_2022_2554_art_2_1)]).
test(none_of_the_listed_types_category_is_out_of_scope) :-
    sole_category(none_of_the_listed_types_out_of_scope, out_of_scope, [cite(eu_reg_2022_2554_art_2_1)]).
test(type_absent_indeterminate) :-
    sole_verdict(type_absent_indeterminate, indeterminate([dora_entity_type]), []).
test(type_absent_category_is_indeterminate) :-
    sole_category(type_absent_indeterminate, indeterminate([dora_entity_type]), []).
test(other_type_exclusion_key_not_read) :-
    sole_verdict(other_type_exclusion_key_not_read, in_scope(trading_venue), [cite(eu_reg_2022_2554_art_2_1_i)]).
test(fractional_member_count_wrong_type) :-
    sole_verdict(fractional_member_count_wrong_type, input_problems([wrong_type(iorp_pension_scheme_members_total)]), []).
test(negative_member_count_wrong_type) :-
    sole_verdict(negative_member_count_wrong_type, input_problems([wrong_type(iorp_pension_scheme_members_total)]), []).
test(duplicate_type_key_problem) :-
    sole_verdict(duplicate_type_key_problem, input_problems([duplicate_key(dora_entity_type)]), []).
test(unknown_key_problem) :-
    sole_verdict(unknown_key_problem, input_problems([unknown_key(colour)]), []).
test(unsure_crisp_value_wrong_type) :-
    sole_verdict(unsure_crisp_value_wrong_type, input_problems([wrong_type(post_office_giro_institution_under_article_2_5_3_of_directive_2013_36)]), []).
test(profile_not_an_attribute_list) :-
    sole_verdict(profile_not_an_attribute_list, input_problems([wrong_type(profile)]), []).
test(input_problem_category_has_no_citations) :-
    sole_category(unknown_key_problem, input_problems([unknown_key(colour)]), []).
test(a_well_formed_fixture_has_no_problem) :-
    dora_scope_and_entity_types_profile_for(intermediary_large_in_scope, Profile),
    findall(Problems, dora_scope_and_entity_types_input_problems(Profile, Problems), AllProblems),
    AllProblems == [[]].
test(problems_follow_contract_order_then_unknown_keys) :-
    dora_scope_and_entity_types_input_problems([attribute(zeta, 1), attribute(iorp_pension_scheme_members_total, -1), attribute(dora_entity_type, banana), attribute(zeta, 2)], Problems),
    Problems == [wrong_type(dora_entity_type), wrong_type(iorp_pension_scheme_members_total), unknown_key(zeta)].
test(a_duplicate_key_is_never_also_wrong_type) :-
    dora_scope_and_entity_types_input_problems([attribute(financial_entity_is_microenterprise, maybe), attribute(financial_entity_is_microenterprise, true)], Problems),
    Problems == [duplicate_key(financial_entity_is_microenterprise)].
test(an_unbound_profile_is_not_an_attribute_list) :-
    findall(Result - Citations, dora_scope_decision(_UnboundProfile, Result, Citations), Answers),
    Answers == [input_problems([wrong_type(profile)]) - []].
test(a_partial_list_is_not_an_attribute_list) :-
    findall(Result - Citations, dora_scope_decision([attribute(dora_entity_type, trading_venue)|_UnboundTail], Result, Citations), Answers),
    Answers == [input_problems([wrong_type(profile)]) - []].
test(an_unbound_key_is_named_as_given) :-
    dora_scope_and_entity_types_input_problems([attribute(UnboundKey, blue)], Problems),
    Problems = [unknown_key(NamedKey)],
    NamedKey == UnboundKey.
test(two_unbound_keys_are_two_keys) :-
    dora_scope_and_entity_types_input_problems([attribute(FirstKey, 1), attribute(SecondKey, 2)], Problems),
    Problems = [unknown_key(FirstNamed), unknown_key(SecondNamed)],
    FirstNamed == FirstKey,
    SecondNamed == SecondKey.
test(a_number_key_is_unknown) :-
    dora_scope_and_entity_types_input_problems([attribute(7, true)], [unknown_key(7)]).
test(an_unbound_value_is_wrong_type) :-
    dora_scope_and_entity_types_input_problems([attribute(dora_entity_type, _UnboundValue)], [wrong_type(dora_entity_type)]).
test(status_projection) :-
    dora_scope_and_entity_types_profile_for(payment_institution_in_scope, Profile),
    dora_scope_and_entity_types_status(Profile, in_scope(payment_institution)).
test(decide_matches_the_contract_query) :-
    dora_scope_and_entity_types_profile_for(small_fund_manager_out_of_scope, Profile),
    decide_dora_scope_and_entity_types(Profile, dora_scope_and_entity_types_verdict(Status, Citations)),
    dora_scope_decision(Profile, Status, Citations).
test(a_final_answer_is_resolvable) :-
    dora_scope_and_entity_types_profile_for(credit_institution_not_giro_in_scope, Profile),
    dora_scope_and_entity_types_decision_resolvable(Profile).
test(checklist_of_an_in_scope_entity) :-
    dora_scope_and_entity_types_profile_for(credit_institution_not_giro_in_scope, Profile),
    dora_scope_and_entity_types_checklist(Profile, [item(listed_type, met, [cite(eu_reg_2022_2554_art_2_1_a)]), item(no_exclusion, met, [cite(eu_reg_2022_2554_art_2_1)])]).
test(checklist_of_an_excluded_entity) :-
    dora_scope_and_entity_types_profile_for(credit_institution_giro_out_of_scope, Profile),
    dora_scope_and_entity_types_checklist(Profile, [item(listed_type, met, [cite(eu_reg_2022_2554_art_2_1)]), item(no_exclusion, unmet(excluded), [cite(eu_reg_2022_2554_art_2_3_f)])]).
test(checklist_of_a_badly_formed_profile) :-
    dora_scope_and_entity_types_profile_for(profile_not_an_attribute_list, Profile),
    dora_scope_and_entity_types_checklist(Profile, [item(input_check, unmet(input_problems([wrong_type(profile)])), [cite(eu_reg_2022_2554_art_2_1)])]).
test(what_if_settles_the_missing_giro_fact) :-
    dora_scope_and_entity_types_profile_for(credit_institution_giro_absent_indeterminate, Profile),
    findall(NewStatus, dora_scope_and_entity_types_what_if(Profile, post_office_giro_institution_under_article_2_5_3_of_directive_2013_36, true, NewStatus), Statuses),
    Statuses == [out_of_scope].
test(what_if_the_giro_fact_is_false) :-
    dora_scope_and_entity_types_profile_for(credit_institution_giro_absent_indeterminate, Profile),
    findall(NewStatus, dora_scope_and_entity_types_what_if(Profile, post_office_giro_institution_under_article_2_5_3_of_directive_2013_36, false, NewStatus), Statuses),
    Statuses == [in_scope(credit_institution)].
test(what_if_moves_the_member_count_to_the_ceiling) :-
    dora_scope_and_entity_types_profile_for(occupational_retirement_sixteen_members_in_scope, Profile),
    findall(NewStatus, dora_scope_and_entity_types_what_if(Profile, iorp_pension_scheme_members_total, 15, NewStatus), Statuses),
    Statuses == [out_of_scope].
test(what_if_replaces_a_duplicated_key) :-
    dora_scope_and_entity_types_profile_for(duplicate_type_key_problem, Profile),
    findall(NewStatus, dora_scope_and_entity_types_what_if(Profile, dora_entity_type, management_company, NewStatus), Statuses),
    Statuses == [in_scope(management_company)].
test(what_if_on_a_non_list_keeps_the_input_problem) :-
    dora_scope_and_entity_types_profile_for(profile_not_an_attribute_list, Profile),
    findall(NewStatus, dora_scope_and_entity_types_what_if(Profile, dora_entity_type, trading_venue, NewStatus), Statuses),
    Statuses == [input_problems([wrong_type(profile)])].

test(credit_institution_not_giro_is_not_out_of_scope, fail) :-
    dora_scope_and_entity_types_assess(credit_institution_not_giro_in_scope, dora_scope_and_entity_types_verdict(out_of_scope, _)).
test(credit_institution_giro_is_not_in_scope, fail) :-
    dora_scope_and_entity_types_assess(credit_institution_giro_out_of_scope, dora_scope_and_entity_types_verdict(in_scope(_), _)).
test(investment_firm_not_exempted_is_not_out_of_scope, fail) :-
    dora_scope_and_entity_types_assess(investment_firm_not_exempted_in_scope, dora_scope_and_entity_types_verdict(out_of_scope, _)).
test(occupational_retirement_fifteen_members_is_not_in_scope, fail) :-
    dora_scope_and_entity_types_assess(occupational_retirement_fifteen_members_out_of_scope, dora_scope_and_entity_types_verdict(in_scope(_), _)).
test(occupational_retirement_sixteen_members_is_not_out_of_scope, fail) :-
    dora_scope_and_entity_types_assess(occupational_retirement_sixteen_members_in_scope, dora_scope_and_entity_types_verdict(out_of_scope, _)).
test(intermediary_large_is_not_out_of_scope, fail) :-
    dora_scope_and_entity_types_assess(intermediary_large_in_scope, dora_scope_and_entity_types_verdict(out_of_scope, _)).
test(third_party_service_provider_is_not_a_financial_entity, fail) :-
    dora_scope_and_entity_types_profile_for(third_party_service_provider_in_scope, Profile),
    dora_entity_category(Profile, financial_entity, _).
test(an_indeterminate_answer_is_not_resolvable, fail) :-
    dora_scope_and_entity_types_profile_for(credit_institution_giro_absent_indeterminate, Profile),
    dora_scope_and_entity_types_decision_resolvable(Profile).

cp_test_names([every_subject_has_one_verdict_and_a_checklist, credit_institution_not_giro_in_scope, credit_institution_giro_out_of_scope, credit_institution_giro_absent_indeterminate, exempted_institution_member_state_excluded, exempted_institution_member_state_not_excluded, exempted_institution_not_excluded_is_a_financial_entity, payment_institution_in_scope, exempted_payment_institution_in_scope, exempted_electronic_money_institution_in_scope, investment_firm_exempted_out_of_scope, investment_firm_not_exempted_in_scope, small_fund_manager_out_of_scope, fund_manager_not_small_in_scope, small_insurance_undertaking_out_of_scope, insurance_undertaking_not_small_in_scope, small_reinsurance_undertaking_out_of_scope, occupational_retirement_fifteen_members_out_of_scope, occupational_retirement_sixteen_members_in_scope, occupational_retirement_members_absent_indeterminate, intermediary_microenterprise_out_of_scope, intermediary_small_or_medium_out_of_scope, intermediary_large_in_scope, intermediary_large_is_a_financial_entity, intermediary_size_absent_indeterminate, intermediary_not_microenterprise_size_absent_indeterminate, third_party_service_provider_in_scope, third_party_service_provider_category, none_of_the_listed_types_out_of_scope, none_of_the_listed_types_category_is_out_of_scope, type_absent_indeterminate, type_absent_category_is_indeterminate, other_type_exclusion_key_not_read, fractional_member_count_wrong_type, negative_member_count_wrong_type, duplicate_type_key_problem, unknown_key_problem, unsure_crisp_value_wrong_type, profile_not_an_attribute_list, input_problem_category_has_no_citations, a_well_formed_fixture_has_no_problem, problems_follow_contract_order_then_unknown_keys, a_duplicate_key_is_never_also_wrong_type, an_unbound_profile_is_not_an_attribute_list, a_partial_list_is_not_an_attribute_list, an_unbound_key_is_named_as_given, two_unbound_keys_are_two_keys, a_number_key_is_unknown, an_unbound_value_is_wrong_type, status_projection, decide_matches_the_contract_query, a_final_answer_is_resolvable, checklist_of_an_in_scope_entity, checklist_of_an_excluded_entity, checklist_of_a_badly_formed_profile, what_if_settles_the_missing_giro_fact, what_if_the_giro_fact_is_false, what_if_moves_the_member_count_to_the_ceiling, what_if_replaces_a_duplicated_key, what_if_on_a_non_list_keeps_the_input_problem]).
cp_test_fail_names([credit_institution_not_giro_is_not_out_of_scope, credit_institution_giro_is_not_in_scope, investment_firm_not_exempted_is_not_out_of_scope, occupational_retirement_fifteen_members_is_not_in_scope, occupational_retirement_sixteen_members_is_not_out_of_scope, intermediary_large_is_not_out_of_scope, third_party_service_provider_is_not_a_financial_entity, an_indeterminate_answer_is_not_resolvable]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
