% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_arts33_34_breach_notification_queries, [gdpr_arts33_34_breach_notification_profile_keys/1, gdpr_arts33_34_breach_notification_what_if/4]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_arts33_34_breach_notification_kernel, [gdpr_arts33_34_breach_notification_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_arts33_34_breach_notification_breach_notification_verdict, [breach_notification_verdict_status/2]).

gdpr_arts33_34_breach_notification_profile_keys([breach_unlikely_to_result_in_risk, breach_likely_to_result_in_high_risk, delay_justified_by_reasons, party_role, notification_made_without_undue_delay, notification_accompanied_by_reasons_for_delay, supervisory_authority_decision_on_communication, appropriate_protection_measures_applied_to_affected_data, subsequent_measures_ensure_high_risk_no_longer_likely, communication_would_involve_disproportionate_effort, notification_describes_nature_of_breach, notification_gives_categories_and_approximate_numbers, categories_and_approximate_numbers_possible, notification_gives_contact_point, notification_describes_likely_consequences, notification_describes_measures_taken_or_proposed, notification_describes_mitigation_measures, mitigation_measures_appropriate, information_not_possible_to_provide_at_the_same_time, communication_made_without_undue_delay, communication_describes_nature_in_clear_and_plain_language, communication_gives_contact_point, communication_describes_likely_consequences, communication_describes_measures_taken_or_proposed, communication_describes_mitigation_measures]).

gdpr_arts33_34_breach_notification_what_if(breach_notification_request(Profile, HoursElapsed), OverriddenKey, NewValue, NewStatus) :-
    hypothesis(OverriddenKey, NewValue, Profile, HoursElapsed, Hypothesis),
    breach_notification_verdict_status(Hypothesis, NewStatus).

hypothesis(OverriddenKey, NewValue, Profile, _, breach_notification_request(Profile, NewValue)) :-
    OverriddenKey == hours_elapsed.
hypothesis(OverriddenKey, NewValue, Profile, HoursElapsed, breach_notification_request(NewProfile, HoursElapsed)) :-
    OverriddenKey \== hours_elapsed,
    proper_list_t(Profile, IsList),
    profile_hypothesis(IsList, Profile, OverriddenKey, NewValue, NewProfile).

profile_hypothesis(false, Profile, _, _, Profile).
profile_hypothesis(true, Profile, OverriddenKey, NewValue, NewProfile) :-
    profile_without_key(Profile, OverriddenKey, Remaining),
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

profile_without_key([], _, []).
profile_without_key([Element|Elements], Key, Remaining) :-
    element_has_key_t(Element, Key, HasKey),
    keep_element(HasKey, Element, Elements, Key, Remaining).

keep_element(true, _, Elements, Key, Remaining) :-
    profile_without_key(Elements, Key, Remaining).
keep_element(false, Element, Elements, Key, [Element|Remaining]) :-
    profile_without_key(Elements, Key, Remaining).

element_has_key_t(Element, _, false) :-
    var(Element).
element_has_key_t(Element, Key, Truth) :-
    nonvar(Element),
    Element = attribute(ElementKey, _),
    identical_t(ElementKey, Key, Truth).
element_has_key_t(Element, _, false) :-
    nonvar(Element),
    Element \= attribute(_, _).

identical_t(Left, Right, true) :-
    Left == Right.
identical_t(Left, Right, false) :-
    Left \== Right.

test(the_schema_has_the_twenty_five_contract_keys) :-
    gdpr_arts33_34_breach_notification_profile_keys(ProfileKeys),
    length(ProfileKeys, 25).
test(what_if_a_likely_risk_turns_ineligible_into_eligible) :-
    gdpr_arts33_34_breach_notification_what_if(breach_notification_request([attribute(breach_unlikely_to_result_in_risk, true), attribute(notification_made_without_undue_delay, true)], 10), breach_unlikely_to_result_in_risk, false, Status),
    Status == eligible.
test(what_if_the_unchanged_request_stays_ineligible) :-
    gdpr_arts33_34_breach_notification_what_if(breach_notification_request([attribute(breach_unlikely_to_result_in_risk, true), attribute(notification_made_without_undue_delay, true)], 10), breach_unlikely_to_result_in_risk, true, Status),
    Status == ineligible.
test(what_if_one_hour_later_reads_the_reasons_key) :-
    gdpr_arts33_34_breach_notification_what_if(breach_notification_request([attribute(breach_unlikely_to_result_in_risk, false), attribute(notification_made_without_undue_delay, true)], 72), hours_elapsed, 73, Status),
    Status == indeterminate([notification_accompanied_by_reasons_for_delay]).
test(what_if_at_the_72nd_hour_stays_eligible) :-
    gdpr_arts33_34_breach_notification_what_if(breach_notification_request([attribute(breach_unlikely_to_result_in_risk, false), attribute(notification_made_without_undue_delay, true)], 40), hours_elapsed, 72, Status),
    Status == eligible.
test(what_if_a_non_list_profile_is_an_input_problem) :-
    gdpr_arts33_34_breach_notification_what_if(breach_notification_request(controller, 10), breach_unlikely_to_result_in_risk, false, Status),
    Status == input_problems([wrong_type(profile)]).
test(what_if_an_ill_typed_value_is_an_input_problem) :-
    gdpr_arts33_34_breach_notification_what_if(breach_notification_request([attribute(breach_unlikely_to_result_in_risk, false)], 10), breach_unlikely_to_result_in_risk, maybe, Status),
    Status == input_problems([wrong_type(breach_unlikely_to_result_in_risk)]).
test(what_if_has_exactly_one_solution) :-
    findall(Status, gdpr_arts33_34_breach_notification_what_if(breach_notification_request([attribute(breach_unlikely_to_result_in_risk, true), attribute(breach_unlikely_to_result_in_risk, true)], 10), breach_unlikely_to_result_in_risk, false, Status), Statuses),
    Statuses == [indeterminate([notification_made_without_undue_delay])].
