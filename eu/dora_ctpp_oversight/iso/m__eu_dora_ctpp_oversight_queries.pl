% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_ctpp_oversight_queries, [dora_ctpp_oversight_profile_keys/1, dora_ctpp_oversight_what_if/4, not_designated_as_critical/0, no_penalty_ground_recommendation/0, no_penalty_ground_full_compliance/0, penalty_decision_required/0, lead_overseer_agreement_required/0, no_article_33_5_condition/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_dora_ctpp_oversight_kernel, [dora_ctpp_oversight_input_problems/2]).
:- use_module(m__eu_dora_ctpp_oversight_dora_ctpp_oversight, [dora_ctpp_oversight_status/2]).

dora_ctpp_oversight_profile_keys([provider_designated_as_critical, response_window, draft_oversight_plan_received_on, annual_oversight_plan_adopted_and_notified, oversight_activities_completed, provider_plans_further_subcontracting_arrangement, envisaged_subcontractor_is_ict_provider_or_subcontractor_in_third_country, subcontracting_concerns_critical_or_important_functions, lead_overseer_deems_clear_and_serious_risk, recommendation_information_opportunity_given_on, measure_power, measure_compliance, measure_notification_received_on, penalty_decision_notified_on, preceding_business_year_worldwide_turnover, preceding_business_year_length_in_days, assessment_date]).

dora_ctpp_oversight_what_if(Profile, OverriddenKey, NewValue, NewStatus) :-
    override_attributes(Profile, OverriddenKey, NewValue, Hypothesis),
    dora_ctpp_oversight_status(Hypothesis, NewStatus).

override_attributes(Profile, _, _, Profile) :-
    var(Profile).
override_attributes(Profile, Key, Value, [attribute(Key, Value)]) :-
    Profile == [].
override_attributes(Profile, Key, Value, Hypothesis) :-
    nonvar(Profile),
    Profile = [Element|Elements],
    element_role(Element, Key, ElementRole),
    override_element(ElementRole, Element, Elements, Key, Value, Hypothesis).
override_attributes(Profile, _, _, Profile) :-
    nonvar(Profile),
    Profile \== [],
    Profile \= [_|_].

element_role(Element, _, other) :-
    var(Element).
element_role(Element, Key, overridden) :-
    nonvar(Element),
    Element = attribute(ElementKey, _),
    ElementKey == Key.
element_role(Element, Key, kept) :-
    nonvar(Element),
    Element = attribute(ElementKey, _),
    ElementKey \== Key.
element_role(Element, _, other) :-
    nonvar(Element),
    Element \= attribute(_, _).

override_element(overridden, _, Elements, Key, Value, Hypothesis) :-
    override_attributes(Elements, Key, Value, Hypothesis).
override_element(kept, Element, Elements, Key, Value, [Element|Hypothesis]) :-
    override_attributes(Elements, Key, Value, Hypothesis).
override_element(other, Element, Elements, Key, Value, [Element|Hypothesis]) :-
    override_attributes(Elements, Key, Value, Hypothesis).

not_designated_as_critical.

no_penalty_ground_recommendation.

no_penalty_ground_full_compliance.

penalty_decision_required.

lead_overseer_agreement_required.

no_article_33_5_condition.

test(what_if_designation_true_puts_provider_under_oversight) :-
    findall(Status, dora_ctpp_oversight_what_if([attribute(provider_designated_as_critical, false)], provider_designated_as_critical, true, Status), Statuses),
    Statuses == [subject_to_lead_overseer_oversight].
test(what_if_designation_false_is_not_designated) :-
    dora_ctpp_oversight_what_if([attribute(provider_designated_as_critical, true)], provider_designated_as_critical, false, not_designated_as_critical).
test(what_if_adds_an_absent_key) :-
    dora_ctpp_oversight_what_if([], provider_designated_as_critical, true, subject_to_lead_overseer_oversight).
test(what_if_keeps_the_absent_designation_indeterminate) :-
    dora_ctpp_oversight_what_if([], assessment_date, date(2026, 1, 1), oversight_indeterminate).
test(what_if_on_a_non_list_reports_input_problems) :-
    dora_ctpp_oversight_what_if(profile, provider_designated_as_critical, true, oversight_input_problems).
test(what_if_removes_a_duplicate) :-
    dora_ctpp_oversight_what_if([attribute(provider_designated_as_critical, true), attribute(provider_designated_as_critical, false)], provider_designated_as_critical, true, subject_to_lead_overseer_oversight).
test(profile_keys_are_seventeen) :-
    dora_ctpp_oversight_profile_keys(Keys),
    length(Keys, 17).
test(final_answer_atoms_are_served) :-
    not_designated_as_critical,
    penalty_decision_required,
    lead_overseer_agreement_required,
    no_article_33_5_condition.
