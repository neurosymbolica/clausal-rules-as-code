% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_cra_art14_manufacturer_reporting_queries, [cra_art14_manufacturer_reporting_profile_keys/1, cra_art14_manufacturer_reporting_what_if/4, severe/0, not_severe/0, on_time/0, date/3, step_due/3, hours_after_awareness/1, days_after_measure_available/1, months_after_notification/1, late/1, indeterminate/1, needs_legal_review/2, open_textured/2, inputs_relied_on/1, provenance/2, input_problems/1, unknown_key/1, wrong_type/1, duplicate_key/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_cra_art14_manufacturer_reporting_kernel, [cra_art14_manufacturer_reporting_input_problems/2]).
:- use_module(m__eu_cra_art14_manufacturer_reporting_cra_art14_manufacturer_reporting, [cra_art14_manufacturer_reporting_status/2]).

cra_art14_manufacturer_reporting_profile_keys([affects_protection_of_sensitive_or_important_data_or_functions, leads_to_malicious_code_in_product_or_user_systems, early_warning_without_undue_delay, notification_without_undue_delay]).

cra_art14_manufacturer_reporting_what_if(Profile, OverriddenKey, NewValue, NewStatus) :-
    cra_art14_manufacturer_reporting_input_problems(Profile, Problems),
    hypothesis(Problems, Profile, OverriddenKey, NewValue, Hypothesis),
    cra_art14_manufacturer_reporting_status(Hypothesis, NewStatus).

hypothesis([wrong_type(profile)], Profile, _, _, Profile).
hypothesis([], Profile, OverriddenKey, NewValue, Hypothesis) :-
    attribute_override(Profile, OverriddenKey, NewValue, Hypothesis).
hypothesis([Problem|Problems], Profile, OverriddenKey, NewValue, Hypothesis) :-
    dif([Problem|Problems], [wrong_type(profile)]),
    attribute_override(Profile, OverriddenKey, NewValue, Hypothesis).

attribute_override([], OverriddenKey, NewValue, [attribute(OverriddenKey, NewValue)]).
attribute_override([attribute(ElementKey, ElementValue)|Elements], OverriddenKey, NewValue, [attribute(ElementKey, ElementValue)|Overridden]) :-
    ElementKey \== OverriddenKey,
    attribute_override(Elements, OverriddenKey, NewValue, Overridden).
attribute_override([attribute(ElementKey, _)|Elements], OverriddenKey, NewValue, Overridden) :-
    ElementKey == OverriddenKey,
    attribute_override(Elements, OverriddenKey, NewValue, Overridden).

severe.

not_severe.

on_time.

date(2026, 9, 11).

step_due(early_warning, hours_after_awareness(24), cite(eu_reg_2024_2847_art_14_2_a)).

hours_after_awareness(24).

days_after_measure_available(14).

months_after_notification(1).

late(hour_limit).

indeterminate([notification_without_undue_delay]).

needs_legal_review(open_textured(notification_without_undue_delay, cite(eu_reg_2024_2847_art_14_2_b)), [inputs_relied_on([notification_without_undue_delay - unsure])]).

open_textured(notification_without_undue_delay, cite(eu_reg_2024_2847_art_14_2_b)).

inputs_relied_on([notification_without_undue_delay - unsure]).

provenance(undue_delay_result, [cite(eu_reg_2024_2847_art_14_2_b)]).

input_problems([wrong_type(profile)]).

unknown_key(severity_score).

wrong_type(profile).

duplicate_key(affects_protection_of_sensitive_or_important_data_or_functions).
