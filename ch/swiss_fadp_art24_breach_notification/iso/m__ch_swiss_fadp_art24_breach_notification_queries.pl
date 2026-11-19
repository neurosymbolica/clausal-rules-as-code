% SPDX-License-Identifier: EUPL-1.2
:- module(m__ch_swiss_fadp_art24_breach_notification_queries, [swiss_fadp_art24_breach_notification_profile_keys/1, swiss_fadp_art24_breach_notification_what_if/4, authority_notification_required/0, authority_notification_not_required/0, report_to_controller_required/0, report_to_controller_not_required/0, information_of_data_subject_required/0, information_of_data_subject_not_required/0, information_of_data_subject_may_be_restricted_deferred_or_omitted/0, same/0, differs/0, not_comparable/0, breach_of_data_security/0, breach_likely_to_lead_to_high_risk_to_personality_or_fundamental_rights/0, information_necessary_for_protection_of_data_subject/0, commissioner_requested_information_of_data_subject/0, article_26_ground_or_statutory_secrecy_obligation_applies/0, information_impossible_or_requires_disproportionate_effort/0, information_ensured_comparably_by_public_announcement/0, personal_data_breach/0, breach_unlikely_to_result_in_risk/0, unsure/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__ch_swiss_fadp_art24_breach_notification_kernel, [swiss_fadp_art24_breach_notification_input_problems/2]).
:- use_module(m__ch_swiss_fadp_art24_breach_notification_swiss_fadp_art24_breach_notification, [swiss_controller_report_to_commissioner/3, swiss_processor_report_to_controller/3, swiss_information_of_data_subject/3, eu_controller_notification_to_supervisory_authority/3, compare_swiss_eu_authority_notification/5, swiss_fadp_art24_breach_notification_status/2]).

swiss_fadp_art24_breach_notification_profile_keys([breach_of_data_security, breach_likely_to_lead_to_high_risk_to_personality_or_fundamental_rights, information_necessary_for_protection_of_data_subject, commissioner_requested_information_of_data_subject, article_26_ground_or_statutory_secrecy_obligation_applies, information_impossible_or_requires_disproportionate_effort, information_ensured_comparably_by_public_announcement, personal_data_breach, breach_unlikely_to_result_in_risk]).

authority_notification_required.

authority_notification_not_required.

report_to_controller_required.

report_to_controller_not_required.

information_of_data_subject_required.

information_of_data_subject_not_required.

information_of_data_subject_may_be_restricted_deferred_or_omitted.

same.

differs.

not_comparable.

breach_of_data_security.

breach_likely_to_lead_to_high_risk_to_personality_or_fundamental_rights.

information_necessary_for_protection_of_data_subject.

commissioner_requested_information_of_data_subject.

article_26_ground_or_statutory_secrecy_obligation_applies.

information_impossible_or_requires_disproportionate_effort.

information_ensured_comparably_by_public_announcement.

personal_data_breach.

breach_unlikely_to_result_in_risk.

unsure.

swiss_fadp_art24_breach_notification_what_if(Profile, OverriddenKey, NewValue, NewStatus) :-
    attribute_override(Profile, OverriddenKey, NewValue, Hypothesis),
    swiss_fadp_art24_breach_notification_status(Hypothesis, NewStatus).

attribute_override(Profile, _, _, Profile) :-
    var(Profile).
attribute_override(Profile, OverriddenKey, NewValue, [attribute(OverriddenKey, NewValue)]) :-
    Profile == [].
attribute_override(Profile, OverriddenKey, NewValue, Hypothesis) :-
    nonvar(Profile),
    Profile = [Element|Elements],
    attribute_override(Elements, OverriddenKey, NewValue, LaterElements),
    keep_element(Element, OverriddenKey, LaterElements, Hypothesis).
attribute_override(Profile, _, _, Profile) :-
    nonvar(Profile),
    Profile \== [],
    Profile \= [_|_].

keep_element(Element, _, LaterElements, [Element|LaterElements]) :-
    var(Element).
keep_element(Element, OverriddenKey, LaterElements, LaterElements) :-
    nonvar(Element),
    Element = attribute(ElementKey, _),
    ElementKey == OverriddenKey.
keep_element(Element, OverriddenKey, LaterElements, [Element|LaterElements]) :-
    nonvar(Element),
    Element = attribute(ElementKey, _),
    ElementKey \== OverriddenKey.
keep_element(Element, _, LaterElements, [Element|LaterElements]) :-
    nonvar(Element),
    Element \= attribute(_, _).

test(what_if_turns_a_false_high_risk_into_a_required_report) :-
    findall(Status, swiss_fadp_art24_breach_notification_what_if([attribute(breach_of_data_security, true), attribute(breach_likely_to_lead_to_high_risk_to_personality_or_fundamental_rights, false)], breach_likely_to_lead_to_high_risk_to_personality_or_fundamental_rights, true, Status), Statuses),
    Statuses == [authority_notification_required].
test(what_if_adds_an_absent_key) :-
    findall(Status, swiss_fadp_art24_breach_notification_what_if([attribute(breach_of_data_security, true)], breach_likely_to_lead_to_high_risk_to_personality_or_fundamental_rights, false, Status), Statuses),
    Statuses == [authority_notification_not_required].
test(the_profile_schema_has_nine_keys) :-
    swiss_fadp_art24_breach_notification_profile_keys(ProfileKeys),
    length(ProfileKeys, 9).
test(the_answer_atoms_are_served) :-
    authority_notification_required,
    information_of_data_subject_may_be_restricted_deferred_or_omitted,
    not_comparable,
    unsure.

test(what_if_override_is_not_the_old_answer, fail) :-
    swiss_fadp_art24_breach_notification_what_if([attribute(breach_of_data_security, true), attribute(breach_likely_to_lead_to_high_risk_to_personality_or_fundamental_rights, false)], breach_likely_to_lead_to_high_risk_to_personality_or_fundamental_rights, true, authority_notification_not_required).
