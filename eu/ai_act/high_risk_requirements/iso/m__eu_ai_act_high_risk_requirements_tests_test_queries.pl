% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_ai_act_high_risk_requirements_tests_test_queries, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_ai_act_high_risk_requirements_queries, [high_risk_requirements_profile_keys/1, high_risk_requirements_what_if/4, high_risk_requirements_obligations/3, high_risk_requirements_compliance_date/4]).
:- use_module(m__eu_ai_act_high_risk_requirements_kernel, [high_risk_requirements_input_problems/2]).
:- use_module(m__eu_ai_act_high_risk_requirements_fixtures, [high_risk_requirements_profile_for/2]).

obligation_requirements(Obligations, Requirements) :-
    findall(Requirement, member(item(Requirement, _, _), Obligations), Requirements).

obligation_results(Obligations, Results) :-
    findall(Result, member(item(_, Result, _), Obligations), Found),
    sort(Found, Results).

test(profile_keys_are_the_contract_keys) :-
    high_risk_requirements_profile_keys(ProfileKeys),
    ProfileKeys == [system_is_a_high_risk_ai_system_listed_in_annex_iii, system_is_a_high_risk_ai_system_under_article_6_1_and_annex_i, system_listed_under_point_1_a_of_annex_iii, used_for_the_purposes_of_law_enforcement_migration_border_control_or_asylum, union_or_national_law_considers_the_separate_verification_disproportionate, uses_techniques_involving_the_training_of_ai_models_with_data, provider_is_an_sme_including_a_start_up_or_an_smc, component_of_an_annex_x_large_scale_it_system_placed_on_the_market_or_put_into_service_before_2_august_2027, placed_on_the_market_or_put_into_service_before_the_chapter_iii_date, significant_changes_in_design_as_from_the_chapter_iii_date, intended_to_be_used_by_public_authorities, system_is_a_component_of_products, pre_determined_changes_to_the_system_and_its_performance, related_to_a_product_covered_by_annex_i_section_a].
test(the_reexported_input_check_accepts_a_fixture_profile) :-
    high_risk_requirements_profile_for(annex_iii_on_application_date, Profile),
    high_risk_requirements_input_problems(Profile, []).
test(what_if_the_system_is_not_listed_in_annex_iii) :-
    high_risk_requirements_profile_for(annex_iii_on_application_date, Profile),
    high_risk_requirements_what_if(requirement_case(Profile, risk_management_system, date(2028, 1, 1)), system_is_a_high_risk_ai_system_listed_in_annex_iii, false, Verdict),
    Verdict == high_risk_requirements_verdict(not_a_high_risk_ai_system, [cite(eu_reg_2024_1689_art_8_1)]).
test(what_if_supplies_a_missing_key) :-
    high_risk_requirements_profile_for(missing_annex_iii_classification, Profile),
    high_risk_requirements_what_if(requirement_case(Profile, risk_management_system, date(2028, 1, 1)), system_is_a_high_risk_ai_system_listed_in_annex_iii, true, high_risk_requirements_verdict(requirement_applies, _)).
test(what_if_settles_an_unsure_judgement) :-
    high_risk_requirements_profile_for(unsure_design_changes, Profile),
    high_risk_requirements_what_if(requirement_case(Profile, risk_management_system, date(2028, 1, 1)), significant_changes_in_design_as_from_the_chapter_iii_date, true, high_risk_requirements_verdict(requirement_applies, _)).
test(what_if_on_an_element) :-
    high_risk_requirements_profile_for(component_photographs_component, Profile),
    high_risk_requirements_what_if(element_case(Profile, annex_iv_point_1_f), system_is_a_component_of_products, false, high_risk_requirements_verdict(element_not_required, _)).
test(what_if_with_a_bad_value_is_an_input_problem) :-
    high_risk_requirements_profile_for(annex_iii_on_application_date, Profile),
    high_risk_requirements_what_if(requirement_case(Profile, risk_management_system, date(2028, 1, 1)), system_is_a_component_of_products, maybe, Verdict),
    Verdict == high_risk_requirements_verdict(input_problems([wrong_type(system_is_a_component_of_products)]), []).
test(what_if_passes_a_non_list_profile_to_the_input_check) :-
    high_risk_requirements_what_if(requirement_case(not_a_list, risk_management_system, date(2028, 1, 1)), system_is_a_component_of_products, true, Verdict),
    Verdict == high_risk_requirements_verdict(input_problems([wrong_type(profile)]), []).
test(obligations_of_an_ordinary_annex_iii_system) :-
    high_risk_requirements_profile_for(annex_iii_on_application_date, Profile),
    high_risk_requirements_obligations(Profile, date(2028, 1, 1), Obligations),
    obligation_requirements(Obligations, Requirements),
    Requirements == [risk_management_system, data_and_data_governance, technical_documentation, record_keeping, transparency_and_instructions_for_use, human_oversight, accuracy_robustness_and_cybersecurity].
test(obligations_of_a_point_one_a_system_under_the_exception) :-
    high_risk_requirements_profile_for(verification_exception_both_conditions, Profile),
    high_risk_requirements_obligations(Profile, date(2028, 1, 1), Obligations),
    obligation_requirements(Obligations, Requirements),
    Requirements == [risk_management_system, data_and_data_governance, technical_documentation, record_keeping, minimum_logging_capabilities_for_point_1_a_systems, transparency_and_instructions_for_use, human_oversight, accuracy_robustness_and_cybersecurity].
test(obligations_before_the_application_date_are_none) :-
    high_risk_requirements_profile_for(annex_iii_on_application_date, Profile),
    high_risk_requirements_obligations(Profile, date(2027, 12, 1), []).
test(obligations_of_an_unchanged_existing_system_are_none) :-
    high_risk_requirements_profile_for(existing_system_without_changes, Profile),
    high_risk_requirements_obligations(Profile, date(2028, 1, 1), []).
test(obligations_of_a_public_authority_system_carry_their_deadline) :-
    high_risk_requirements_profile_for(public_authority_system_day_before_deadline, Profile),
    high_risk_requirements_obligations(Profile, date(2030, 8, 1), Obligations),
    length(Obligations, 7),
    obligation_results(Obligations, Results),
    Results == [compliance_required_by_2_august_2030].
test(obligations_name_the_first_open_answer) :-
    high_risk_requirements_profile_for(missing_annex_iii_classification, Profile),
    high_risk_requirements_obligations(Profile, date(2028, 1, 1), Obligations),
    Obligations == [item(risk_management_system, indeterminate([system_is_a_high_risk_ai_system_listed_in_annex_iii]), [])].
test(obligations_report_input_problems) :-
    high_risk_requirements_obligations(not_a_list, date(2028, 1, 1), Obligations),
    Obligations == [item(input_check, input_problems([wrong_type(profile)]), [])].
test(compliance_date_of_an_annex_iii_system) :-
    high_risk_requirements_profile_for(annex_iii_on_application_date, Profile),
    high_risk_requirements_compliance_date(Profile, risk_management_system, ComplianceDate, Citations),
    ComplianceDate == date(2027, 12, 2),
    sort(Citations, Got),
    sort([cite(eu_reg_2024_1689_art_8_1), cite(eu_reg_2024_1689_art_9_1)], Want),
    Got == Want.
test(compliance_date_of_an_annex_i_only_system) :-
    high_risk_requirements_profile_for(annex_i_only_on_application_date, Profile),
    high_risk_requirements_compliance_date(Profile, human_oversight, ComplianceDate, _),
    ComplianceDate == date(2028, 8, 2).
test(compliance_date_of_a_public_authority_system) :-
    high_risk_requirements_profile_for(public_authority_system_on_deadline, Profile),
    high_risk_requirements_compliance_date(Profile, record_keeping, ComplianceDate, _),
    ComplianceDate == date(2030, 8, 2).
test(compliance_date_of_an_annex_x_component) :-
    high_risk_requirements_profile_for(annex_x_component_on_deadline, Profile),
    high_risk_requirements_compliance_date(Profile, risk_management_system, ComplianceDate, _),
    ComplianceDate == date(2030, 12, 31).
test(compliance_date_for_a_requirement_that_does_not_apply) :-
    high_risk_requirements_profile_for(other_annex_iii_system_logging, Profile),
    high_risk_requirements_compliance_date(Profile, minimum_logging_capabilities_for_point_1_a_systems, Result, Citations),
    Result == requirement_does_not_apply,
    Citations == [cite(eu_reg_2024_1689_art_12_3)].
test(compliance_date_for_a_system_that_is_not_high_risk) :-
    high_risk_requirements_profile_for(not_a_high_risk_system, Profile),
    high_risk_requirements_compliance_date(Profile, human_oversight, Result, Citations),
    Result == not_a_high_risk_ai_system,
    Citations == [cite(eu_reg_2024_1689_art_8_1)].
test(compliance_date_refers_an_unsure_judgement) :-
    high_risk_requirements_profile_for(unsure_design_changes, Profile),
    high_risk_requirements_compliance_date(Profile, risk_management_system, Result, Citations),
    Result = needs_legal_review(open_textured(significant_changes_in_design_as_from_the_chapter_iii_date, cite(eu_reg_2024_1689_art_111_2)), _),
    Citations == [].

cp_test_names([profile_keys_are_the_contract_keys, the_reexported_input_check_accepts_a_fixture_profile, what_if_the_system_is_not_listed_in_annex_iii, what_if_supplies_a_missing_key, what_if_settles_an_unsure_judgement, what_if_on_an_element, what_if_with_a_bad_value_is_an_input_problem, what_if_passes_a_non_list_profile_to_the_input_check, obligations_of_an_ordinary_annex_iii_system, obligations_of_a_point_one_a_system_under_the_exception, obligations_before_the_application_date_are_none, obligations_of_an_unchanged_existing_system_are_none, obligations_of_a_public_authority_system_carry_their_deadline, obligations_name_the_first_open_answer, obligations_report_input_problems, compliance_date_of_an_annex_iii_system, compliance_date_of_an_annex_i_only_system, compliance_date_of_a_public_authority_system, compliance_date_of_an_annex_x_component, compliance_date_for_a_requirement_that_does_not_apply, compliance_date_for_a_system_that_is_not_high_risk, compliance_date_refers_an_unsure_judgement]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
