% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_arts33_34_breach_notification_queries, [gdpr_arts33_34_breach_notification_profile_keys/1, gdpr_arts33_34_breach_notification_what_if/4]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_arts33_34_breach_notification_kernel, [gdpr_arts33_34_breach_notification_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_arts33_34_breach_notification_breach_notification_verdict, [breach_notification_verdict_status/2]).

gdpr_arts33_34_breach_notification_profile_keys([breach_unlikely_to_result_in_risk, breach_likely_to_result_in_high_risk, delay_justified_by_reasons, party_role, notification_made_without_undue_delay, notification_accompanied_by_reasons_for_delay, supervisory_authority_decision_on_communication, appropriate_protection_measures_applied_to_affected_data, subsequent_measures_ensure_high_risk_no_longer_likely, communication_would_involve_disproportionate_effort, notification_describes_nature_of_breach, notification_gives_categories_and_approximate_numbers, categories_and_approximate_numbers_possible, notification_gives_contact_point, notification_describes_likely_consequences, notification_describes_measures_taken_or_proposed, notification_describes_mitigation_measures, mitigation_measures_appropriate, information_not_possible_to_provide_at_the_same_time, communication_made_without_undue_delay, communication_describes_nature_in_clear_and_plain_language, communication_gives_contact_point, communication_describes_likely_consequences, communication_describes_measures_taken_or_proposed, communication_describes_mitigation_measures]).

gdpr_arts33_34_breach_notification_what_if(case(Profile, _), hours_elapsed, NewHoursElapsed, NewStatus) :-
    breach_notification_verdict_status(case(Profile, NewHoursElapsed), NewStatus).
gdpr_arts33_34_breach_notification_what_if(case(Profile, HoursElapsed), OverriddenKey, NewValue, NewStatus) :-
    dif(OverriddenKey, hours_elapsed),
    replace_attribute(Profile, OverriddenKey, NewValue, Hypothesis),
    breach_notification_verdict_status(case(Hypothesis, HoursElapsed), NewStatus).

replace_attribute([], OverriddenKey, NewValue, [attribute(OverriddenKey, NewValue)]).
replace_attribute([attribute(ElementKey, _)|Elements], OverriddenKey, NewValue, Replaced) :-
    ElementKey == OverriddenKey,
    replace_attribute(Elements, OverriddenKey, NewValue, Replaced).
replace_attribute([attribute(ElementKey, ElementValue)|Elements], OverriddenKey, NewValue, [attribute(ElementKey, ElementValue)|Replaced]) :-
    ElementKey \== OverriddenKey,
    replace_attribute(Elements, OverriddenKey, NewValue, Replaced).

test(the_schema_has_twenty_five_keys) :-
    gdpr_arts33_34_breach_notification_profile_keys(Keys),
    length(Keys, 25).
test(a_later_notification_needs_the_reasons_key) :-
    gdpr_arts33_34_breach_notification_what_if(case([attribute(breach_unlikely_to_result_in_risk, false), attribute(notification_made_without_undue_delay, true)], 72), hours_elapsed, 73, Status),
    Status == indeterminate([notification_accompanied_by_reasons_for_delay]).
test(an_unlikely_risk_override_is_ineligible) :-
    gdpr_arts33_34_breach_notification_what_if(case([attribute(breach_unlikely_to_result_in_risk, false), attribute(notification_made_without_undue_delay, true)], 72), breach_unlikely_to_result_in_risk, true, Status),
    Status == ineligible.
test(the_override_has_one_answer) :-
    findall(Status, gdpr_arts33_34_breach_notification_what_if(case([attribute(breach_unlikely_to_result_in_risk, false), attribute(notification_made_without_undue_delay, true)], 72), notification_made_without_undue_delay, false, Status), Statuses),
    Statuses == [notification_requirement_not_met(without_undue_delay)].
test(an_override_adds_an_absent_key) :-
    gdpr_arts33_34_breach_notification_what_if(case([attribute(breach_unlikely_to_result_in_risk, false)], 10), notification_made_without_undue_delay, true, Status),
    Status == eligible.
