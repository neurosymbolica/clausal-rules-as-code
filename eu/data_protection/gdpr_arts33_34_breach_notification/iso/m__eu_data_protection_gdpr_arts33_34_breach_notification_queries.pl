% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_arts33_34_breach_notification_queries, [gdpr_arts33_34_breach_notification_profile_keys/1, gdpr_arts33_34_breach_notification_what_if/4]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_lists_extra, [is_list/1]).
:- use_module(m__eu_data_protection_gdpr_arts33_34_breach_notification_kernel, [gdpr_arts33_34_breach_notification_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_arts33_34_breach_notification_breach_notification_verdict, [breach_notification_verdict_status/2]).

gdpr_arts33_34_breach_notification_profile_keys([breach_unlikely_to_result_in_risk, breach_likely_to_result_in_high_risk, delay_justified_by_reasons, party_role, notification_made_without_undue_delay, notification_accompanied_by_reasons_for_delay, supervisory_authority_decision_on_communication, appropriate_protection_measures_applied_to_affected_data, subsequent_measures_ensure_high_risk_no_longer_likely, communication_would_involve_disproportionate_effort, notification_describes_nature_of_breach, notification_gives_categories_and_approximate_numbers, categories_and_approximate_numbers_possible, notification_gives_contact_point, notification_describes_likely_consequences, notification_describes_measures_taken_or_proposed, notification_describes_mitigation_measures, mitigation_measures_appropriate, information_not_possible_to_provide_at_the_same_time, communication_made_without_undue_delay, communication_describes_nature_in_clear_and_plain_language, communication_gives_contact_point, communication_describes_likely_consequences, communication_describes_measures_taken_or_proposed, communication_describes_mitigation_measures]).

gdpr_arts33_34_breach_notification_what_if(case(Profile, _), hours_elapsed, NewHoursElapsed, NewStatus) :-
    breach_notification_verdict_status(case(Profile, NewHoursElapsed), NewStatus).
gdpr_arts33_34_breach_notification_what_if(case(Profile, HoursElapsed), OverriddenKey, NewValue, NewStatus) :-
    dif(OverriddenKey, hours_elapsed),
    override_attribute(Profile, OverriddenKey, NewValue, Hypothesis),
    breach_notification_verdict_status(case(Hypothesis, HoursElapsed), NewStatus).

override_attribute(Profile, Key, Value, Hypothesis) :-
    is_list(Profile),
    replace_attribute_items(Profile, Key, Value, Hypothesis).

replace_attribute_items([], Key, Value, [attribute(Key, Value)]).
replace_attribute_items([attribute(ElementKey, _)|Elements], Key, Value, Hypothesis) :-
    ElementKey == Key,
    replace_attribute_items(Elements, Key, Value, Hypothesis).
replace_attribute_items([attribute(ElementKey, ElementValue)|Elements], Key, Value, [attribute(ElementKey, ElementValue)|Hypothesis]) :-
    ElementKey \== Key,
    replace_attribute_items(Elements, Key, Value, Hypothesis).
replace_attribute_items([Element|Elements], Key, Value, [Element|Hypothesis]) :-
    nonvar(Element),
    Element \= attribute(_, _),
    replace_attribute_items(Elements, Key, Value, Hypothesis).

test(an_override_replaces_the_stated_value) :-
    override_attribute([attribute(party_role, controller), attribute(breach_unlikely_to_result_in_risk, false)], breach_unlikely_to_result_in_risk, true, Hypothesis),
    Hypothesis == [attribute(party_role, controller), attribute(breach_unlikely_to_result_in_risk, true)].
test(an_override_adds_an_absent_key) :-
    override_attribute([], party_role, processor, Hypothesis),
    Hypothesis == [attribute(party_role, processor)].
test(what_if_the_risk_were_unlikely) :-
    gdpr_arts33_34_breach_notification_what_if(case([attribute(breach_unlikely_to_result_in_risk, false), attribute(notification_made_without_undue_delay, true)], 10), breach_unlikely_to_result_in_risk, true, ineligible).
test(what_if_one_hour_later) :-
    gdpr_arts33_34_breach_notification_what_if(case([attribute(breach_unlikely_to_result_in_risk, false), attribute(notification_made_without_undue_delay, true)], 72), hours_elapsed, 73, indeterminate([notification_accompanied_by_reasons_for_delay])).
test(what_if_has_one_solution) :-
    findall(Status, gdpr_arts33_34_breach_notification_what_if(case([attribute(breach_unlikely_to_result_in_risk, false)], 10), notification_made_without_undue_delay, false, Status), Statuses),
    Statuses == [notification_requirement_not_met(without_undue_delay)].
test(what_if_a_mistyped_value_is_refused) :-
    gdpr_arts33_34_breach_notification_what_if(case([attribute(breach_unlikely_to_result_in_risk, false)], 10), breach_unlikely_to_result_in_risk, maybe, input_problems([wrong_type(breach_unlikely_to_result_in_risk)])).
test(the_schema_has_twenty_five_keys) :-
    gdpr_arts33_34_breach_notification_profile_keys(Keys),
    length(Keys, 25).
