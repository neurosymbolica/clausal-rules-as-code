% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_ai_act_deployer_duties_fria_queries, [deployer_duties_fria_profile_keys/1, deployer_duties_fria_what_if/4, deployer_duties_fria_obligation_status/2, deployer_duties_fria_compliance_check/2, deployer_duties_fria_chapter_iii_date/2]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(formalize_lib, [profile_get/3]).
:- use_module(m__eu_ai_act_deployer_duties_fria_kernel, [deployer_duties_fria_input_problems/2]).
:- use_module(m__eu_ai_act_deployer_duties_fria_citations, [implements/1]).
:- use_module(m__eu_ai_act_deployer_duties_fria_deployer_duties_fria, [deployer_duties_fria_status/2]).

deployer_duties_fria_profile_keys([deployer_of_the_system, system_is_a_high_risk_ai_system_listed_in_annex_iii, system_is_a_high_risk_ai_system_under_article_6_1_and_annex_i, logs_automatically_generated_by_the_system_under_the_deployers_control, union_or_national_law_provides_otherwise_on_the_log_retention_period, deployer_is_an_employer, put_into_service_or_used_at_the_workplace, makes_or_assists_in_making_decisions_related_to_natural_persons, used_for_law_enforcement_purposes, system_listed_under_point_2_of_annex_iii, body_governed_by_public_law, private_entity_providing_public_services, system_listed_under_point_5_b_of_annex_iii, system_listed_under_point_5_c_of_annex_iii, exempt_from_notification_in_the_case_of_article_46_1, component_of_an_annex_x_large_scale_it_system_placed_on_the_market_or_put_into_service_before_2_august_2027, placed_on_the_market_or_put_into_service_before_the_chapter_iii_date, significant_changes_in_design_as_from_the_chapter_iii_date, intended_to_be_used_by_public_authorities]).

deployer_duties_fria_what_if(deployer_obligation_request(Profile, Obligation, AssessmentDate), OverriddenKey, NewValue, NewStatus) :-
    overridden_profile(Profile, OverriddenKey, NewValue, Hypothesis),
    deployer_duties_fria_status(deployer_obligation_request(Hypothesis, Obligation, AssessmentDate), NewStatus).
deployer_duties_fria_what_if(log_retention_period_request(Profile, RetentionMonths, AssessmentDate), OverriddenKey, NewValue, NewStatus) :-
    overridden_profile(Profile, OverriddenKey, NewValue, Hypothesis),
    deployer_duties_fria_status(log_retention_period_request(Hypothesis, RetentionMonths, AssessmentDate), NewStatus).

overridden_profile(Profile, OverriddenKey, NewValue, Hypothesis) :-
    without_key(Profile, OverriddenKey, RemainingProfile),
    append(RemainingProfile, [attribute(OverriddenKey, NewValue)], Hypothesis).

without_key([], _, []).
without_key([attribute(ElementKey, ElementValue)|Elements], ProfileKey, [attribute(ElementKey, ElementValue)|Remaining]) :-
    ElementKey \== ProfileKey,
    without_key(Elements, ProfileKey, Remaining).
without_key([attribute(ElementKey, _)|Elements], ProfileKey, Remaining) :-
    ElementKey == ProfileKey,
    without_key(Elements, ProfileKey, Remaining).

deployer_duties_fria_obligation_status(deployer_obligation_request(Profile, Obligation, AssessmentDate), Result) :-
    deployer_duties_fria_status(deployer_obligation_request(Profile, Obligation, AssessmentDate), Result).

deployer_duties_fria_compliance_check(log_retention_period_request(Profile, RetentionMonths, AssessmentDate), Result) :-
    deployer_duties_fria_status(log_retention_period_request(Profile, RetentionMonths, AssessmentDate), Result).

chapter_iii_date_row(true, date(2027, 12, 2), cite(eu_reg_2024_1689_art_113_c_i)).
chapter_iii_date_row(false, date(2028, 8, 2), cite(eu_reg_2024_1689_art_113_c_ii)).

deployer_duties_fria_chapter_iii_date(Profile, ChapterThreeDate) :-
    implements(eu_reg_2024_1689_art_113_c),
    deployer_duties_fria_input_problems(Profile, []),
    profile_get(Profile, system_is_a_high_risk_ai_system_listed_in_annex_iii, ListedInAnnexThree),
    chapter_iii_date_row(ListedInAnnexThree, ChapterThreeDate, _).

test(what_if_the_actor_is_not_the_deployer) :-
    deployer_duties_fria_what_if(deployer_obligation_request([attribute(deployer_of_the_system, true)], log_retention, date(2028, 1, 1)), deployer_of_the_system, false, Status),
    Status == not_a_deployer.
test(an_ill_typed_override_is_an_input_problem) :-
    deployer_duties_fria_what_if(log_retention_period_request([], 6, date(2028, 1, 1)), deployer_of_the_system, maybe, Status),
    Status == input_problems([wrong_type(deployer_of_the_system)]).
test(an_annex_iii_system_takes_the_december_2027_date) :-
    deployer_duties_fria_chapter_iii_date([attribute(system_is_a_high_risk_ai_system_listed_in_annex_iii, true)], ChapterThreeDate),
    ChapterThreeDate == date(2027, 12, 2).
test(another_system_takes_the_august_2028_date) :-
    deployer_duties_fria_chapter_iii_date([attribute(system_is_a_high_risk_ai_system_listed_in_annex_iii, false)], ChapterThreeDate),
    ChapterThreeDate == date(2028, 8, 2).
test(the_compliance_check_answers_the_retention_query) :-
    deployer_duties_fria_compliance_check(log_retention_period_request([attribute(deployer_of_the_system, false)], 6, date(2028, 1, 1)), Result),
    Result == not_a_deployer.
test(the_obligation_status_answers_before_the_first_date) :-
    deployer_duties_fria_obligation_status(deployer_obligation_request([], fundamental_rights_impact_assessment, date(2027, 12, 1)), Result),
    Result == not_applicable_on_date.

test(the_unchanged_deployer_is_not_answered_not_a_deployer, fail) :-
    deployer_duties_fria_status(deployer_obligation_request([attribute(deployer_of_the_system, true)], log_retention, date(2028, 1, 1)), not_a_deployer).
test(an_unclassified_system_has_no_chapter_iii_date, fail) :-
    deployer_duties_fria_chapter_iii_date([], _).
