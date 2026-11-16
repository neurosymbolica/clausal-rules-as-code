% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_ai_act_deployer_duties_fria_fixtures, [deployer_duties_fria_subject/1, deployer_duties_fria_profile_for/2, deployer_duties_fria_assess/2]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_ai_act_deployer_duties_fria_deployer_duties_fria, [decide_deployer_duties_fria/2]).

base_profile([attribute(deployer_of_the_system, true), attribute(system_is_a_high_risk_ai_system_listed_in_annex_iii, true), attribute(system_is_a_high_risk_ai_system_under_article_6_1_and_annex_i, false), attribute(logs_automatically_generated_by_the_system_under_the_deployers_control, true), attribute(union_or_national_law_provides_otherwise_on_the_log_retention_period, false), attribute(deployer_is_an_employer, true), attribute(put_into_service_or_used_at_the_workplace, true), attribute(makes_or_assists_in_making_decisions_related_to_natural_persons, true), attribute(used_for_law_enforcement_purposes, false), attribute(system_listed_under_point_2_of_annex_iii, false), attribute(body_governed_by_public_law, true), attribute(private_entity_providing_public_services, false), attribute(system_listed_under_point_5_b_of_annex_iii, false), attribute(system_listed_under_point_5_c_of_annex_iii, false), attribute(exempt_from_notification_in_the_case_of_article_46_1, false), attribute(component_of_an_annex_x_large_scale_it_system_placed_on_the_market_or_put_into_service_before_2_august_2027, false), attribute(placed_on_the_market_or_put_into_service_before_the_chapter_iii_date, false), attribute(significant_changes_in_design_as_from_the_chapter_iii_date, false), attribute(intended_to_be_used_by_public_authorities, false)]).

changed_profile(Changes, Profile) :-
    base_profile(BaseProfile),
    foldl(apply_change, Changes, BaseProfile, Profile).

apply_change(set(ProfileKey, NewValue), ProfileIn, ProfileOut) :-
    without_key(ProfileIn, ProfileKey, RemainingProfile),
    append(RemainingProfile, [attribute(ProfileKey, NewValue)], ProfileOut).
apply_change(drop(ProfileKey), ProfileIn, ProfileOut) :-
    without_key(ProfileIn, ProfileKey, ProfileOut).

without_key([], _, []).
without_key([attribute(ElementKey, ElementValue)|Elements], ProfileKey, [attribute(ElementKey, ElementValue)|Remaining]) :-
    ElementKey \== ProfileKey,
    without_key(Elements, ProfileKey, Remaining).
without_key([attribute(ElementKey, _)|Elements], ProfileKey, Remaining) :-
    ElementKey == ProfileKey,
    without_key(Elements, ProfileKey, Remaining).

fixture_request(log_retention_applies, deployer_obligation_request(Profile, log_retention, date(2028, 1, 1))) :-
    changed_profile([], Profile).
fixture_request(first_chapter_iii_day, deployer_obligation_request(Profile, log_retention, date(2027, 12, 2))) :-
    changed_profile([], Profile).
fixture_request(day_before_first_chapter_iii_day, deployer_obligation_request(Profile, log_retention, date(2027, 12, 1))) :-
    changed_profile([], Profile).
fixture_request(actor_not_the_deployer, deployer_obligation_request(Profile, log_retention, date(2028, 1, 1))) :-
    changed_profile([set(deployer_of_the_system, false)], Profile).
fixture_request(system_not_high_risk, deployer_obligation_request(Profile, log_retention, date(2028, 1, 1))) :-
    changed_profile([set(system_is_a_high_risk_ai_system_listed_in_annex_iii, false), set(system_is_a_high_risk_ai_system_under_article_6_1_and_annex_i, false)], Profile).
fixture_request(product_legislation_system_on_its_date, deployer_obligation_request(Profile, log_retention, date(2028, 8, 2))) :-
    changed_profile([set(system_is_a_high_risk_ai_system_listed_in_annex_iii, false), set(system_is_a_high_risk_ai_system_under_article_6_1_and_annex_i, true)], Profile).
fixture_request(product_legislation_system_day_before, deployer_obligation_request(Profile, log_retention, date(2028, 8, 1))) :-
    changed_profile([set(system_is_a_high_risk_ai_system_listed_in_annex_iii, false), set(system_is_a_high_risk_ai_system_under_article_6_1_and_annex_i, true)], Profile).
fixture_request(logs_not_under_control, deployer_obligation_request(Profile, log_retention, date(2028, 1, 1))) :-
    changed_profile([set(logs_automatically_generated_by_the_system_under_the_deployers_control, false)], Profile).
fixture_request(employer_informs_workers, deployer_obligation_request(Profile, information_of_workers_and_their_representatives, date(2028, 1, 1))) :-
    changed_profile([], Profile).
fixture_request(deployer_not_an_employer, deployer_obligation_request(Profile, information_of_workers_and_their_representatives, date(2028, 1, 1))) :-
    changed_profile([set(deployer_is_an_employer, false)], Profile).
fixture_request(decisions_about_natural_persons, deployer_obligation_request(Profile, information_of_natural_persons_subject_to_decisions, date(2028, 1, 1))) :-
    changed_profile([], Profile).
fixture_request(law_enforcement_decisions, deployer_obligation_request(Profile, information_of_natural_persons_subject_to_decisions, date(2028, 1, 1))) :-
    changed_profile([set(used_for_law_enforcement_purposes, true)], Profile).
fixture_request(no_decisions_about_natural_persons, deployer_obligation_request(Profile, information_of_natural_persons_subject_to_decisions, date(2028, 1, 1))) :-
    changed_profile([set(makes_or_assists_in_making_decisions_related_to_natural_persons, false)], Profile).
fixture_request(public_body_impact_assessment, deployer_obligation_request(Profile, fundamental_rights_impact_assessment, date(2028, 1, 1))) :-
    changed_profile([], Profile).
fixture_request(critical_infrastructure_impact_assessment, deployer_obligation_request(Profile, fundamental_rights_impact_assessment, date(2028, 1, 1))) :-
    changed_profile([set(system_listed_under_point_2_of_annex_iii, true)], Profile).
fixture_request(credit_scoring_impact_assessment, deployer_obligation_request(Profile, fundamental_rights_impact_assessment, date(2028, 1, 1))) :-
    changed_profile([set(body_governed_by_public_law, false), set(system_listed_under_point_5_b_of_annex_iii, true)], Profile).
fixture_request(missing_critical_infrastructure_key, deployer_obligation_request(Profile, fundamental_rights_impact_assessment, date(2028, 1, 1))) :-
    changed_profile([set(body_governed_by_public_law, false), set(system_listed_under_point_5_b_of_annex_iii, true), drop(system_listed_under_point_2_of_annex_iii)], Profile).
fixture_request(unsure_public_body, deployer_obligation_request(Profile, fundamental_rights_impact_assessment, date(2028, 1, 1))) :-
    changed_profile([set(body_governed_by_public_law, unsure)], Profile).
fixture_request(public_body_notification, deployer_obligation_request(Profile, notification_of_assessment_results, date(2028, 1, 1))) :-
    changed_profile([], Profile).
fixture_request(exempt_notification, deployer_obligation_request(Profile, notification_of_assessment_results, date(2028, 1, 1))) :-
    changed_profile([set(exempt_from_notification_in_the_case_of_article_46_1, true)], Profile).
fixture_request(annex_x_component_day_before_compliance, deployer_obligation_request(Profile, log_retention, date(2030, 12, 30))) :-
    changed_profile([set(component_of_an_annex_x_large_scale_it_system_placed_on_the_market_or_put_into_service_before_2_august_2027, true)], Profile).
fixture_request(annex_x_component_on_compliance_day, deployer_obligation_request(Profile, log_retention, date(2030, 12, 31))) :-
    changed_profile([set(component_of_an_annex_x_large_scale_it_system_placed_on_the_market_or_put_into_service_before_2_august_2027, true)], Profile).
fixture_request(existing_system_unchanged, deployer_obligation_request(Profile, log_retention, date(2028, 1, 1))) :-
    changed_profile([set(placed_on_the_market_or_put_into_service_before_the_chapter_iii_date, true)], Profile).
fixture_request(existing_system_significantly_changed, deployer_obligation_request(Profile, log_retention, date(2028, 1, 1))) :-
    changed_profile([set(placed_on_the_market_or_put_into_service_before_the_chapter_iii_date, true), set(significant_changes_in_design_as_from_the_chapter_iii_date, true)], Profile).
fixture_request(public_authority_system_day_before, deployer_obligation_request(Profile, log_retention, date(2030, 8, 1))) :-
    changed_profile([set(placed_on_the_market_or_put_into_service_before_the_chapter_iii_date, true), set(intended_to_be_used_by_public_authorities, true)], Profile).
fixture_request(public_authority_system_on_compliance_day, deployer_obligation_request(Profile, log_retention, date(2030, 8, 2))) :-
    changed_profile([set(placed_on_the_market_or_put_into_service_before_the_chapter_iii_date, true), set(intended_to_be_used_by_public_authorities, true)], Profile).
fixture_request(retention_of_six_months, log_retention_period_request(Profile, 6, date(2028, 1, 1))) :-
    changed_profile([], Profile).
fixture_request(retention_of_five_months, log_retention_period_request(Profile, 5, date(2028, 1, 1))) :-
    changed_profile([], Profile).
fixture_request(retention_of_no_months, log_retention_period_request(Profile, 0, date(2028, 1, 1))) :-
    changed_profile([], Profile).
fixture_request(retention_set_by_other_law, log_retention_period_request(Profile, 5, date(2028, 1, 1))) :-
    changed_profile([set(union_or_national_law_provides_otherwise_on_the_log_retention_period, true)], Profile).
fixture_request(empty_profile, deployer_obligation_request([], log_retention, date(2028, 1, 1))).
fixture_request(negative_retention_period, log_retention_period_request(Profile, -1, date(2028, 1, 1))) :-
    changed_profile([], Profile).
fixture_request(unknown_profile_key, deployer_obligation_request(Profile, log_retention, date(2028, 1, 1))) :-
    changed_profile([set(colour, blue)], Profile).
fixture_request(impossible_assessment_date, deployer_obligation_request(Profile, log_retention, date(2027, 2, 30))) :-
    changed_profile([], Profile).

deployer_duties_fria_subject(Subject) :-
    fixture_request(Subject, _).

deployer_duties_fria_profile_for(Subject, Request) :-
    fixture_request(Subject, Request).

deployer_duties_fria_assess(Subject, Verdict) :-
    fixture_request(Subject, Request),
    decide_deployer_duties_fria(Request, Verdict).
