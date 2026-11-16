% SPDX-License-Identifier: EUPL-1.2
:- module(m__ch_swiss_fadp_art24_breach_notification_queries, [swiss_fadp_art24_breach_notification_profile_keys/1, swiss_fadp_art24_breach_notification_what_if/4, swiss_fadp_art24_breach_notification_obligations/2, breach_of_data_security/0, breach_likely_to_lead_to_high_risk_to_personality_or_fundamental_rights/0, information_necessary_for_protection_of_data_subject/0, commissioner_requested_information_of_data_subject/0, article_26_ground_or_statutory_secrecy_obligation_applies/0, information_impossible_or_requires_disproportionate_effort/0, information_ensured_comparably_by_public_announcement/0, personal_data_breach/0, breach_unlikely_to_result_in_risk/0, unsure/0, authority_notification_required/0, authority_notification_not_required/0, report_to_controller_required/0, report_to_controller_not_required/0, information_of_data_subject_required/0, information_of_data_subject_not_required/0, information_of_data_subject_may_be_restricted_deferred_or_omitted/0, same/0, differs/0, not_comparable/0, indeterminate/1, needs_legal_review/2, inputs_relied_on/1, input_problems/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_lists_extra, [is_list/1]).
:- use_module(m__ch_swiss_fadp_art24_breach_notification_kernel, [swiss_fadp_art24_breach_notification_input_problems/2]).
:- use_module(m__ch_swiss_fadp_art24_breach_notification_swiss_fadp_art24_breach_notification, [swiss_fadp_art24_breach_notification_status/2, swiss_controller_report_to_commissioner/3, swiss_processor_report_to_controller/3, swiss_information_of_data_subject/3, eu_controller_notification_to_supervisory_authority/3]).

swiss_fadp_art24_breach_notification_profile_keys([breach_of_data_security, breach_likely_to_lead_to_high_risk_to_personality_or_fundamental_rights, information_necessary_for_protection_of_data_subject, commissioner_requested_information_of_data_subject, article_26_ground_or_statutory_secrecy_obligation_applies, information_impossible_or_requires_disproportionate_effort, information_ensured_comparably_by_public_announcement, personal_data_breach, breach_unlikely_to_result_in_risk]).

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

indeterminate(MissingKeys) :-
    is_list(MissingKeys).

needs_legal_review(_Reason, Context) :-
    is_list(Context).

inputs_relied_on(Pairs) :-
    is_list(Pairs).

input_problems(Problems) :-
    is_list(Problems).

swiss_fadp_art24_breach_notification_what_if(Profile, OverriddenKey, NewValue, NewStatus) :-
    override_attribute(Profile, OverriddenKey, NewValue, Hypothesis),
    swiss_fadp_art24_breach_notification_status(Hypothesis, NewStatus).

override_attribute(RemainingProfile, _, _, RemainingProfile) :-
    var(RemainingProfile).
override_attribute(RemainingProfile, OverriddenKey, NewValue, [attribute(OverriddenKey, NewValue)]) :-
    RemainingProfile == [].
override_attribute(RemainingProfile, OverriddenKey, NewValue, Hypothesis) :-
    nonvar(RemainingProfile),
    RemainingProfile = [Element|Elements],
    element_kept(Element, OverriddenKey, KeptElements),
    override_attribute(Elements, OverriddenKey, NewValue, LaterElements),
    append(KeptElements, LaterElements, Hypothesis).
override_attribute(RemainingProfile, _, _, RemainingProfile) :-
    nonvar(RemainingProfile),
    RemainingProfile \== [],
    RemainingProfile \= [_|_].

element_kept(Element, _, [Element]) :-
    var(Element).
element_kept(Element, OverriddenKey, []) :-
    nonvar(Element),
    Element = attribute(ElementKey, _),
    ElementKey == OverriddenKey.
element_kept(Element, OverriddenKey, [Element]) :-
    nonvar(Element),
    Element = attribute(ElementKey, _),
    ElementKey \== OverriddenKey.
element_kept(Element, _, [Element]) :-
    nonvar(Element),
    Element \= attribute(_, _).

swiss_fadp_art24_breach_notification_obligations(Profile, [duty(controller, report_to_commissioner, ControllerResult, ControllerCitations), duty(processor, report_to_controller, ProcessorResult, ProcessorCitations), duty(controller, inform_data_subject, InformationResult, InformationCitations), duty(controller, notify_eu_supervisory_authority, EuropeanResult, EuropeanCitations)]) :-
    swiss_controller_report_to_commissioner(Profile, ControllerResult, ControllerCitations),
    swiss_processor_report_to_controller(Profile, ProcessorResult, ProcessorCitations),
    swiss_information_of_data_subject(Profile, InformationResult, InformationCitations),
    eu_controller_notification_to_supervisory_authority(Profile, EuropeanResult, EuropeanCitations).
