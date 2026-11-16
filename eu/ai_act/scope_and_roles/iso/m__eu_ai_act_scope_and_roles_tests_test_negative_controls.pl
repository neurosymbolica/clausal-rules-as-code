% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_ai_act_scope_and_roles_tests_test_negative_controls, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_ai_act_scope_and_roles_queries, [scope_and_roles_what_if/4]).
:- use_module(m__eu_ai_act_scope_and_roles_fixtures, [scope_and_roles_profile_for/2, scope_and_roles_assess/2]).

status_of(Subject, Status) :-
    scope_and_roles_assess(Subject, scope_and_roles_verdict(Status, _Citations)).

base_what_if(Key, Value, Status) :-
    scope_and_roles_profile_for(eu_provider_placing_on_market, Profile),
    scope_and_roles_what_if(case(Profile, date(2026, 8, 1)), Key, Value, Status).

test(the_day_before_chapter_one_is_not_applicable) :-
    status_of(date_before_application, not_applicable_on_date).
test(chapter_one_day_is_the_earlier_text) :-
    status_of(date_in_earlier_text_window, earlier_text_not_formalised).
test(the_last_earlier_day_is_not_formalised) :-
    status_of(date_last_day_of_earlier_text, earlier_text_not_formalised).
test(the_pinned_day_applies) :-
    status_of(date_first_day_of_pinned_text, regulation_applies).
test(not_an_ai_system_is_out_of_scope) :-
    base_what_if(ai_system, false, out_of_scope).
test(an_ai_system_is_covered) :-
    base_what_if(ai_system, true, regulation_applies).
test(a_military_system_is_out_of_scope) :-
    status_of(military_system_excluded, out_of_scope).
test(a_civil_system_is_covered) :-
    base_what_if(exclusively_for_military_defence_or_national_security_purposes, false, regulation_applies).
test(an_authority_with_safeguards_is_out_of_scope) :-
    status_of(third_country_authority_with_safeguards, out_of_scope).
test(an_authority_without_safeguards_is_covered) :-
    status_of(third_country_authority_without_safeguards, regulation_applies).
test(a_research_only_system_is_out_of_scope) :-
    base_what_if(specifically_developed_and_put_into_service_for_the_sole_purpose_of_scientific_research_and_development, true, out_of_scope).
test(pre_market_testing_is_out_of_scope) :-
    status_of(pre_market_testing_excluded, out_of_scope).
test(real_world_testing_is_covered) :-
    status_of(real_world_testing_in_scope, regulation_applies).
test(open_source_not_high_risk_is_out_of_scope) :-
    status_of(open_source_not_high_risk_excluded, out_of_scope).
test(open_source_high_risk_is_covered) :-
    status_of(open_source_high_risk_in_scope, regulation_applies).
test(a_provider_placing_on_the_market_is_covered) :-
    status_of(eu_provider_placing_on_market, regulation_applies).
test(a_provider_not_placing_is_out_of_scope) :-
    status_of(eu_provider_not_placing_on_market, out_of_scope).
test(output_used_in_the_union_brings_the_provider_in) :-
    status_of(third_country_provider_output_in_union, regulation_applies).
test(output_outside_the_union_is_out_of_scope) :-
    status_of(third_country_provider_output_outside_union, out_of_scope).
test(a_professional_deployer_is_covered) :-
    status_of(professional_deployer_in_union, regulation_applies).
test(a_personal_deployer_is_out_of_scope) :-
    status_of(personal_use_deployer, out_of_scope).
test(a_representative_of_a_third_country_provider_is_covered) :-
    status_of(authorised_representative_of_third_country_provider, regulation_applies).
test(a_representative_of_a_union_provider_is_out_of_scope) :-
    status_of(authorised_representative_of_union_provider, out_of_scope).
test(a_section_b_system_gets_the_listed_provisions) :-
    status_of(section_b_high_risk_listed_provisions, only_listed_provisions_apply).
test(the_provider_role_holds) :-
    status_of(provider_role_holds, role_holds).
test(a_developer_alone_is_not_a_provider) :-
    status_of(developer_without_placing_not_provider, role_does_not_hold).
test(the_distributor_role_holds) :-
    status_of(plain_distributor_role_holds, role_holds).
test(an_importer_does_not_hold_the_distributor_role) :-
    status_of(distributor_that_is_importer, role_does_not_hold).
test(a_product_manufacturer_is_an_operator) :-
    status_of(product_manufacturer_is_operator, role_holds).
test(a_person_with_no_role_does_not_hold_the_operator_role) :-
    status_of(no_role_is_not_operator, role_does_not_hold).
test(a_rebranding_distributor_is_considered_provider) :-
    status_of(rebranding_distributor_considered_provider, considered_provider).
test(a_distributor_without_change_is_not_the_provider) :-
    status_of(distributor_without_change_not_provider, not_considered_provider).
test(the_day_before_article_25_is_not_applicable) :-
    status_of(annex_iii_before_article_25_applies, not_applicable_on_date).
test(article_25_day_applies_for_annex_iii) :-
    status_of(annex_iii_on_article_25_day, considered_provider).
test(annex_i_in_the_window_is_not_applicable) :-
    status_of(annex_i_in_window_not_applicable, not_applicable_on_date).
test(annex_i_on_its_day_applies) :-
    status_of(annex_i_on_application_day, considered_provider).
test(a_clear_specification_does_not_apply_paragraph_2) :-
    status_of(initial_provider_clearly_specified, paragraph_2_not_applied).
test(without_a_specification_the_initial_provider_must_cooperate) :-
    status_of(initial_provider_must_cooperate, no_longer_provider_must_cooperate).
test(without_a_new_provider_the_initial_provider_is_unaffected) :-
    status_of(initial_provider_unaffected_case, initial_provider_unaffected).
test(open_source_items_need_no_agreement) :-
    status_of(open_source_supplier_no_agreement, no_written_agreement_duty).
test(a_general_purpose_model_supplier_needs_an_agreement) :-
    status_of(general_purpose_model_supplier_agreement_required, written_agreement_required).
test(a_missing_actor_role_is_named) :-
    status_of(missing_actor_role_indeterminate, indeterminate([actor_role])).
test(an_unsure_ai_system_goes_to_a_lawyer) :-
    status_of(unsure_ai_system_referral, needs_legal_review(open_textured(ai_system, cite(eu_reg_2024_1689_art_3_1)), [inputs_relied_on(_)])).
test(a_malformed_judgement_is_an_input_problem) :-
    status_of(malformed_judgement_input_problem, input_problems([wrong_type(ai_system)])).

test(chapter_one_day_is_not_not_applicable, fail) :-
    status_of(date_in_earlier_text_window, not_applicable_on_date).
test(the_pinned_day_is_not_the_earlier_text, fail) :-
    status_of(date_first_day_of_pinned_text, earlier_text_not_formalised).
test(an_ai_system_is_not_out_of_scope, fail) :-
    base_what_if(ai_system, true, out_of_scope).
test(a_civil_system_is_not_out_of_scope, fail) :-
    base_what_if(exclusively_for_military_defence_or_national_security_purposes, false, out_of_scope).
test(an_authority_without_safeguards_is_not_out_of_scope, fail) :-
    status_of(third_country_authority_without_safeguards, out_of_scope).
test(a_system_not_research_only_is_not_out_of_scope, fail) :-
    base_what_if(specifically_developed_and_put_into_service_for_the_sole_purpose_of_scientific_research_and_development, false, out_of_scope).
test(real_world_testing_is_not_out_of_scope, fail) :-
    status_of(real_world_testing_in_scope, out_of_scope).
test(open_source_high_risk_is_not_out_of_scope, fail) :-
    status_of(open_source_high_risk_in_scope, out_of_scope).
test(a_provider_not_placing_is_not_covered, fail) :-
    status_of(eu_provider_not_placing_on_market, regulation_applies).
test(output_outside_the_union_does_not, fail) :-
    status_of(third_country_provider_output_outside_union, regulation_applies).
test(a_personal_deployer_is_not_covered, fail) :-
    status_of(personal_use_deployer, regulation_applies).
test(a_representative_of_a_union_provider_is_not_covered, fail) :-
    status_of(authorised_representative_of_union_provider, regulation_applies).
test(the_base_system_does_not_get_only_the_listed_provisions, fail) :-
    status_of(eu_provider_placing_on_market, only_listed_provisions_apply).
test(a_developer_alone_does_not_hold_the_provider_role, fail) :-
    status_of(developer_without_placing_not_provider, role_holds).
test(an_importer_is_not_a_distributor, fail) :-
    status_of(distributor_that_is_importer, role_holds).
test(a_person_with_no_role_is_not_an_operator, fail) :-
    status_of(no_role_is_not_operator, role_holds).
test(a_distributor_without_change_is_not_considered_provider, fail) :-
    status_of(distributor_without_change_not_provider, considered_provider).
test(article_25_day_is_not_not_applicable, fail) :-
    status_of(annex_iii_on_article_25_day, not_applicable_on_date).
test(annex_i_on_its_day_is_not_not_applicable, fail) :-
    status_of(annex_i_on_application_day, not_applicable_on_date).
test(without_a_specification_paragraph_2_is_applied, fail) :-
    status_of(initial_provider_must_cooperate, paragraph_2_not_applied).
test(without_a_new_provider_there_is_no_cooperation_duty, fail) :-
    status_of(initial_provider_unaffected_case, no_longer_provider_must_cooperate).
test(a_general_purpose_model_is_not_in_the_exception, fail) :-
    status_of(general_purpose_model_supplier_agreement_required, no_written_agreement_duty).
test(the_complete_base_is_not_indeterminate, fail) :-
    status_of(eu_provider_placing_on_market, indeterminate(_)).
test(a_settled_ai_system_does_not_go_to_a_lawyer, fail) :-
    status_of(eu_provider_placing_on_market, needs_legal_review(_, _)).
test(a_well_formed_base_has_no_input_problem, fail) :-
    status_of(eu_provider_placing_on_market, input_problems(_)).

cp_test_names([the_day_before_chapter_one_is_not_applicable, chapter_one_day_is_the_earlier_text, the_last_earlier_day_is_not_formalised, the_pinned_day_applies, not_an_ai_system_is_out_of_scope, an_ai_system_is_covered, a_military_system_is_out_of_scope, a_civil_system_is_covered, an_authority_with_safeguards_is_out_of_scope, an_authority_without_safeguards_is_covered, a_research_only_system_is_out_of_scope, pre_market_testing_is_out_of_scope, real_world_testing_is_covered, open_source_not_high_risk_is_out_of_scope, open_source_high_risk_is_covered, a_provider_placing_on_the_market_is_covered, a_provider_not_placing_is_out_of_scope, output_used_in_the_union_brings_the_provider_in, output_outside_the_union_is_out_of_scope, a_professional_deployer_is_covered, a_personal_deployer_is_out_of_scope, a_representative_of_a_third_country_provider_is_covered, a_representative_of_a_union_provider_is_out_of_scope, a_section_b_system_gets_the_listed_provisions, the_provider_role_holds, a_developer_alone_is_not_a_provider, the_distributor_role_holds, an_importer_does_not_hold_the_distributor_role, a_product_manufacturer_is_an_operator, a_person_with_no_role_does_not_hold_the_operator_role, a_rebranding_distributor_is_considered_provider, a_distributor_without_change_is_not_the_provider, the_day_before_article_25_is_not_applicable, article_25_day_applies_for_annex_iii, annex_i_in_the_window_is_not_applicable, annex_i_on_its_day_applies, a_clear_specification_does_not_apply_paragraph_2, without_a_specification_the_initial_provider_must_cooperate, without_a_new_provider_the_initial_provider_is_unaffected, open_source_items_need_no_agreement, a_general_purpose_model_supplier_needs_an_agreement, a_missing_actor_role_is_named, an_unsure_ai_system_goes_to_a_lawyer, a_malformed_judgement_is_an_input_problem]).
cp_test_fail_names([chapter_one_day_is_not_not_applicable, the_pinned_day_is_not_the_earlier_text, an_ai_system_is_not_out_of_scope, a_civil_system_is_not_out_of_scope, an_authority_without_safeguards_is_not_out_of_scope, a_system_not_research_only_is_not_out_of_scope, real_world_testing_is_not_out_of_scope, open_source_high_risk_is_not_out_of_scope, a_provider_not_placing_is_not_covered, output_outside_the_union_does_not, a_personal_deployer_is_not_covered, a_representative_of_a_union_provider_is_not_covered, the_base_system_does_not_get_only_the_listed_provisions, a_developer_alone_does_not_hold_the_provider_role, an_importer_is_not_a_distributor, a_person_with_no_role_is_not_an_operator, a_distributor_without_change_is_not_considered_provider, article_25_day_is_not_not_applicable, annex_i_on_its_day_is_not_not_applicable, without_a_specification_paragraph_2_is_applied, without_a_new_provider_there_is_no_cooperation_duty, a_general_purpose_model_is_not_in_the_exception, the_complete_base_is_not_indeterminate, a_settled_ai_system_does_not_go_to_a_lawyer, a_well_formed_base_has_no_input_problem]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
