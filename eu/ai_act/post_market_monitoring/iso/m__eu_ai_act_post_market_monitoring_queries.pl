% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_ai_act_post_market_monitoring_queries, [post_market_monitoring_profile_keys/1, post_market_monitoring_what_if/4, not_applicable_on_date/0, not_a_provider/0, not_a_high_risk_ai_system/0, compliance_required_by_31_december_2030/0, existing_system_without_significant_changes_not_covered/0, compliance_required_by_2_august_2030/0, duty_applies/0, integration_not_available/0, integration_available/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_ai_act_post_market_monitoring_kernel, [post_market_monitoring_input_problems/2]).
:- use_module(m__eu_ai_act_post_market_monitoring_post_market_monitoring, [post_market_monitoring_status/2]).

post_market_monitoring_profile_keys([provider_of_the_system, system_is_a_high_risk_ai_system_listed_in_annex_iii, system_is_a_high_risk_ai_system_under_article_6_1_and_annex_i, component_of_an_annex_x_large_scale_it_system_placed_on_the_market_or_put_into_service_before_2_august_2027, placed_on_the_market_or_put_into_service_before_the_chapter_iii_date, significant_changes_in_design_as_from_the_chapter_iii_date, intended_to_be_used_by_public_authorities, covered_by_union_harmonisation_legislation_listed_in_section_a_of_annex_i, point_5_annex_iii_system_of_a_financial_institution_under_union_financial_services_law, post_market_monitoring_system_and_plan_already_established_under_that_legislation, integration_achieves_an_equivalent_level_of_protection]).

not_applicable_on_date.

not_a_provider.

not_a_high_risk_ai_system.

compliance_required_by_31_december_2030.

existing_system_without_significant_changes_not_covered.

compliance_required_by_2_august_2030.

duty_applies.

integration_not_available.

integration_available.

post_market_monitoring_what_if(Request, OverriddenKey, NewValue, NewStatus) :-
    request_with_override(Request, OverriddenKey, NewValue, Hypothesis),
    post_market_monitoring_status(Hypothesis, NewStatus).

request_with_override(Request, _, _, Request) :-
    var(Request).
request_with_override(Request, OverriddenKey, NewValue, duty(NewProfile, AssessmentDate)) :-
    nonvar(Request),
    Request = duty(Profile, AssessmentDate),
    profile_with_override(Profile, OverriddenKey, NewValue, NewProfile).
request_with_override(Request, OverriddenKey, NewValue, integration(NewProfile)) :-
    nonvar(Request),
    Request = integration(Profile),
    profile_with_override(Profile, OverriddenKey, NewValue, NewProfile).
request_with_override(Request, OverriddenKey, NewValue, NewProfile) :-
    nonvar(Request),
    Request \= duty(_, _),
    Request \= integration(_),
    profile_with_override(Request, OverriddenKey, NewValue, NewProfile).

profile_with_override(Profile, OverriddenKey, NewValue, NewProfile) :-
    proper_list_t(Profile, IsList),
    override_when_list(IsList, Profile, OverriddenKey, NewValue, NewProfile).

override_when_list(false, Profile, _, _, Profile).
override_when_list(true, Profile, OverriddenKey, NewValue, NewProfile) :-
    without_key(Profile, OverriddenKey, Remaining),
    append(Remaining, [attribute(OverriddenKey, NewValue)], NewProfile).

proper_list_t(Term, false) :-
    var(Term).
proper_list_t(Term, true) :-
    Term == [].
proper_list_t(Term, Truth) :-
    nonvar(Term),
    Term = [_|Tail],
    proper_list_t(Tail, Truth).
proper_list_t(Term, false) :-
    nonvar(Term),
    Term \== [],
    Term \= [_|_].

without_key([], _, []).
without_key([Element|Elements], OverriddenKey, Remaining) :-
    nonvar(Element),
    Element = attribute(ElementKey, _),
    ElementKey == OverriddenKey,
    without_key(Elements, OverriddenKey, Remaining).
without_key([Element|Elements], OverriddenKey, [Element|Remaining]) :-
    nonvar(Element),
    Element = attribute(ElementKey, _),
    ElementKey \== OverriddenKey,
    without_key(Elements, OverriddenKey, Remaining).
without_key([Element|Elements], OverriddenKey, [Element|Remaining]) :-
    nonvar(Element),
    Element \= attribute(_, _),
    without_key(Elements, OverriddenKey, Remaining).
without_key([Element|Elements], OverriddenKey, [Element|Remaining]) :-
    var(Element),
    without_key(Elements, OverriddenKey, Remaining).
