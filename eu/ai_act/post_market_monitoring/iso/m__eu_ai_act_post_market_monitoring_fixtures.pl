% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_ai_act_post_market_monitoring_fixtures, [post_market_monitoring_subject/1, post_market_monitoring_profile_for/2, post_market_monitoring_assess/2]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_ai_act_post_market_monitoring_post_market_monitoring, [decide_post_market_monitoring/2]).

post_market_monitoring_subject(before_the_annex_iii_date).
post_market_monitoring_subject(annex_iii_system_on_its_first_day).
post_market_monitoring_subject(annex_i_only_system_the_day_before).
post_market_monitoring_subject(annex_i_only_system_on_its_first_day).
post_market_monitoring_subject(actor_not_a_provider).
post_market_monitoring_subject(provider_of_an_annex_iii_system).
post_market_monitoring_subject(system_not_high_risk).
post_market_monitoring_subject(annex_x_component_the_day_before_the_deadline).
post_market_monitoring_subject(annex_x_component_on_the_deadline).
post_market_monitoring_subject(annex_x_component_for_public_authorities).
post_market_monitoring_subject(existing_system_without_changes).
post_market_monitoring_subject(existing_system_with_significant_changes).
post_market_monitoring_subject(existing_public_authority_system_the_day_before_the_deadline).
post_market_monitoring_subject(existing_public_authority_system_on_the_deadline).
post_market_monitoring_subject(existing_changed_public_authority_system).
post_market_monitoring_subject(missing_provider).
post_market_monitoring_subject(referral_on_significant_changes).
post_market_monitoring_subject(missing_fact_before_referral).
post_market_monitoring_subject(integration_through_annex_i_legislation).
post_market_monitoring_subject(integration_without_equivalent_protection).
post_market_monitoring_subject(integration_for_covered_annex_iii_system).
post_market_monitoring_subject(integration_for_financial_institution).
post_market_monitoring_subject(integration_for_financial_institution_without_plan).
post_market_monitoring_subject(integration_without_legislation_route).
post_market_monitoring_subject(integration_actor_not_a_provider).
post_market_monitoring_subject(integration_system_not_high_risk).
post_market_monitoring_subject(integration_referral_on_equivalence).
post_market_monitoring_subject(input_duplicate_key).
post_market_monitoring_subject(input_crisp_key_given_unsure).
post_market_monitoring_subject(input_unknown_key_given_twice).
post_market_monitoring_subject(input_impossible_date).
post_market_monitoring_subject(input_last_day_of_february).
post_market_monitoring_subject(input_unknown_key_and_impossible_date).
post_market_monitoring_subject(input_not_an_attribute_list).

duty_profile([Provider, AnnexIii, AnnexI, LargeScaleComponent, PlacedBefore, Significant, Public], [attribute(provider_of_the_system, Provider), attribute(system_is_a_high_risk_ai_system_listed_in_annex_iii, AnnexIii), attribute(system_is_a_high_risk_ai_system_under_article_6_1_and_annex_i, AnnexI), attribute(component_of_an_annex_x_large_scale_it_system_placed_on_the_market_or_put_into_service_before_2_august_2027, LargeScaleComponent), attribute(placed_on_the_market_or_put_into_service_before_the_chapter_iii_date, PlacedBefore), attribute(significant_changes_in_design_as_from_the_chapter_iii_date, Significant), attribute(intended_to_be_used_by_public_authorities, Public)]).

integration_profile([Provider, AnnexIii, AnnexI, Covered, Financial, Established, Equivalent], [attribute(provider_of_the_system, Provider), attribute(system_is_a_high_risk_ai_system_listed_in_annex_iii, AnnexIii), attribute(system_is_a_high_risk_ai_system_under_article_6_1_and_annex_i, AnnexI), attribute(covered_by_union_harmonisation_legislation_listed_in_section_a_of_annex_i, Covered), attribute(point_5_annex_iii_system_of_a_financial_institution_under_union_financial_services_law, Financial), attribute(post_market_monitoring_system_and_plan_already_established_under_that_legislation, Established), attribute(integration_achieves_an_equivalent_level_of_protection, Equivalent)]).

post_market_monitoring_profile_for(before_the_annex_iii_date, duty([], date(2027, 12, 1))).
post_market_monitoring_profile_for(annex_iii_system_on_its_first_day, duty(Profile, date(2027, 12, 2))) :-
    duty_profile([true, true, false, false, false, false, false], Profile).
post_market_monitoring_profile_for(annex_i_only_system_the_day_before, duty(Profile, date(2028, 8, 1))) :-
    duty_profile([true, false, true, false, false, false, false], Profile).
post_market_monitoring_profile_for(annex_i_only_system_on_its_first_day, duty(Profile, date(2028, 8, 2))) :-
    duty_profile([true, false, true, false, false, false, false], Profile).
post_market_monitoring_profile_for(actor_not_a_provider, duty(Profile, date(2029, 1, 1))) :-
    duty_profile([false, true, false, false, false, false, false], Profile).
post_market_monitoring_profile_for(provider_of_an_annex_iii_system, duty(Profile, date(2029, 1, 1))) :-
    duty_profile([true, true, false, false, false, false, false], Profile).
post_market_monitoring_profile_for(system_not_high_risk, duty(Profile, date(2029, 1, 1))) :-
    duty_profile([true, false, false, false, false, false, false], Profile).
post_market_monitoring_profile_for(annex_x_component_the_day_before_the_deadline, duty(Profile, date(2030, 12, 30))) :-
    duty_profile([true, true, false, true, false, false, false], Profile).
post_market_monitoring_profile_for(annex_x_component_on_the_deadline, duty(Profile, date(2030, 12, 31))) :-
    duty_profile([true, true, false, true, false, false, false], Profile).
post_market_monitoring_profile_for(annex_x_component_for_public_authorities, duty(Profile, date(2030, 9, 1))) :-
    duty_profile([true, true, false, true, false, false, true], Profile).
post_market_monitoring_profile_for(existing_system_without_changes, duty(Profile, date(2029, 1, 1))) :-
    duty_profile([true, true, false, false, true, false, false], Profile).
post_market_monitoring_profile_for(existing_system_with_significant_changes, duty(Profile, date(2029, 1, 1))) :-
    duty_profile([true, true, false, false, true, true, false], Profile).
post_market_monitoring_profile_for(existing_public_authority_system_the_day_before_the_deadline, duty(Profile, date(2030, 8, 1))) :-
    duty_profile([true, true, false, false, true, false, true], Profile).
post_market_monitoring_profile_for(existing_public_authority_system_on_the_deadline, duty(Profile, date(2030, 8, 2))) :-
    duty_profile([true, true, false, false, true, false, true], Profile).
post_market_monitoring_profile_for(existing_changed_public_authority_system, duty(Profile, date(2029, 1, 1))) :-
    duty_profile([true, true, false, false, true, true, true], Profile).
post_market_monitoring_profile_for(missing_provider, duty([attribute(system_is_a_high_risk_ai_system_listed_in_annex_iii, true), attribute(system_is_a_high_risk_ai_system_under_article_6_1_and_annex_i, false), attribute(component_of_an_annex_x_large_scale_it_system_placed_on_the_market_or_put_into_service_before_2_august_2027, false), attribute(placed_on_the_market_or_put_into_service_before_the_chapter_iii_date, false), attribute(significant_changes_in_design_as_from_the_chapter_iii_date, false), attribute(intended_to_be_used_by_public_authorities, false)], date(2029, 1, 1))).
post_market_monitoring_profile_for(referral_on_significant_changes, duty(Profile, date(2029, 1, 1))) :-
    duty_profile([true, true, false, false, true, unsure, false], Profile).
post_market_monitoring_profile_for(missing_fact_before_referral, duty([attribute(provider_of_the_system, true), attribute(system_is_a_high_risk_ai_system_listed_in_annex_iii, true), attribute(system_is_a_high_risk_ai_system_under_article_6_1_and_annex_i, false), attribute(component_of_an_annex_x_large_scale_it_system_placed_on_the_market_or_put_into_service_before_2_august_2027, false), attribute(placed_on_the_market_or_put_into_service_before_the_chapter_iii_date, true), attribute(significant_changes_in_design_as_from_the_chapter_iii_date, unsure)], date(2029, 1, 1))).
post_market_monitoring_profile_for(integration_through_annex_i_legislation, integration(Profile)) :-
    integration_profile([true, false, true, true, false, true, true], Profile).
post_market_monitoring_profile_for(integration_without_equivalent_protection, integration(Profile)) :-
    integration_profile([true, false, true, true, false, true, false], Profile).
post_market_monitoring_profile_for(integration_for_covered_annex_iii_system, integration(Profile)) :-
    integration_profile([true, true, false, true, false, true, true], Profile).
post_market_monitoring_profile_for(integration_for_financial_institution, integration(Profile)) :-
    integration_profile([true, true, false, false, true, true, true], Profile).
post_market_monitoring_profile_for(integration_for_financial_institution_without_plan, integration(Profile)) :-
    integration_profile([true, true, false, false, true, false, true], Profile).
post_market_monitoring_profile_for(integration_without_legislation_route, integration(Profile)) :-
    integration_profile([true, true, false, false, false, true, true], Profile).
post_market_monitoring_profile_for(integration_actor_not_a_provider, integration(Profile)) :-
    integration_profile([false, false, true, true, false, true, true], Profile).
post_market_monitoring_profile_for(integration_system_not_high_risk, integration(Profile)) :-
    integration_profile([true, false, false, true, false, true, true], Profile).
post_market_monitoring_profile_for(integration_referral_on_equivalence, integration(Profile)) :-
    integration_profile([true, false, true, true, false, true, unsure], Profile).
post_market_monitoring_profile_for(input_duplicate_key, integration([attribute(provider_of_the_system, true), attribute(provider_of_the_system, maybe)])).
post_market_monitoring_profile_for(input_crisp_key_given_unsure, integration([attribute(system_is_a_high_risk_ai_system_listed_in_annex_iii, unsure)])).
post_market_monitoring_profile_for(input_unknown_key_given_twice, integration([attribute(colour, red), attribute(colour, blue)])).
post_market_monitoring_profile_for(input_impossible_date, duty([], date(2027, 2, 30))).
post_market_monitoring_profile_for(input_last_day_of_february, duty([], date(2027, 2, 28))).
post_market_monitoring_profile_for(input_unknown_key_and_impossible_date, duty([attribute(colour, red)], date(2027, 2, 30))).
post_market_monitoring_profile_for(input_not_an_attribute_list, integration([foo])).

post_market_monitoring_assess(Subject, Result) :-
    post_market_monitoring_profile_for(Subject, Request),
    decide_post_market_monitoring(Request, Result).
