% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_representation_and_suspension_queries, [gdpr_representation_and_suspension_profile_keys/1, gdpr_representation_and_suspension_what_if/4, may_act_on_mandate/0, may_not_act_on_mandate/0, may_act_without_mandate/0, may_not_act_without_mandate/0, contact_duty_applies/0, contact_duty_does_not_apply/0, may_suspend_proceedings/0, suspension_not_available/0, may_decline_jurisdiction/0, declining_jurisdiction_not_available/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_lists_extra, [clausal_is_list/1]).
:- use_module(m__eu_data_protection_gdpr_representation_and_suspension_kernel, [gdpr_representation_and_suspension_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_representation_and_suspension_gdpr_representation_and_suspension, [gdpr_representation_and_suspension_status/2]).

gdpr_representation_and_suspension_profile_keys([body_is_not_for_profit, body_properly_constituted_under_member_state_law, body_statutory_objectives_in_public_interest, body_active_in_protection_of_data_subjects_rights_and_freedoms, data_subject_mandated_the_body, member_state_law_provides_for_mandated_compensation_claims, member_state_law_provides_for_the_action_without_mandate, body_considers_data_subject_rights_infringed_by_processing, court_is_competent_court, court_has_information_on_proceedings_pending_in_another_member_state, other_proceedings_pending_in_court_of_another_member_state, other_proceedings_concern_same_controller_or_processor, other_proceedings_concern_same_subject_matter, court_is_court_first_seized, other_proceedings_pending_at_first_instance, party_applied_for_court_to_decline_jurisdiction, court_first_seized_has_jurisdiction_over_the_actions, law_of_court_first_seized_permits_consolidation]).

gdpr_representation_and_suspension_what_if(Request, OverriddenKey, NewValue, NewStatus) :-
    request_profile(Request, Profile, Hypothesis, HypotheticalRequest),
    clausal_is_list(Profile),
    replace_attribute(Profile, OverriddenKey, NewValue, Hypothesis),
    gdpr_representation_and_suspension_status(HypotheticalRequest, NewStatus).

request_profile(mandated_representation(Profile, Action), Profile, NewProfile, mandated_representation(NewProfile, Action)).
request_profile(representation_without_mandate(Profile, Action), Profile, NewProfile, representation_without_mandate(NewProfile, Action)).
request_profile(court_contact_duty(Profile), Profile, NewProfile, court_contact_duty(NewProfile)).
request_profile(court_suspension_option(Profile), Profile, NewProfile, court_suspension_option(NewProfile)).
request_profile(court_declining_jurisdiction_option(Profile), Profile, NewProfile, court_declining_jurisdiction_option(NewProfile)).

replace_attribute([], OverriddenKey, NewValue, [attribute(OverriddenKey, NewValue)]).
replace_attribute([attribute(ElementKey, _)|Elements], OverriddenKey, NewValue, Replaced) :-
    ElementKey == OverriddenKey,
    replace_attribute(Elements, OverriddenKey, NewValue, Replaced).
replace_attribute([attribute(ElementKey, ElementValue)|Elements], OverriddenKey, NewValue, [attribute(ElementKey, ElementValue)|Replaced]) :-
    ElementKey \== OverriddenKey,
    replace_attribute(Elements, OverriddenKey, NewValue, Replaced).

may_act_on_mandate.

may_not_act_on_mandate.

may_act_without_mandate.

may_not_act_without_mandate.

contact_duty_applies.

contact_duty_does_not_apply.

may_suspend_proceedings.

suspension_not_available.

may_decline_jurisdiction.

declining_jurisdiction_not_available.

test(eighteen_profile_keys) :-
    gdpr_representation_and_suspension_profile_keys(Keys),
    length(Keys, 18).
test(the_input_check_is_reexported) :-
    gdpr_representation_and_suspension_input_problems([], Problems),
    Problems == [].
test(what_if_supplies_the_mandate) :-
    findall(Status, gdpr_representation_and_suspension_what_if(mandated_representation([attribute(body_is_not_for_profit, true), attribute(body_properly_constituted_under_member_state_law, true), attribute(body_statutory_objectives_in_public_interest, true), attribute(body_active_in_protection_of_data_subjects_rights_and_freedoms, true), attribute(data_subject_mandated_the_body, false)], lodge_complaint_under_article_77), data_subject_mandated_the_body, true, Status), Statuses),
    Statuses == [may_act_on_mandate].
test(what_if_replaces_and_never_duplicates) :-
    findall(Status, gdpr_representation_and_suspension_what_if(court_suspension_option([attribute(court_is_competent_court, true), attribute(other_proceedings_pending_in_court_of_another_member_state, true), attribute(other_proceedings_concern_same_controller_or_processor, true), attribute(other_proceedings_concern_same_subject_matter, true), attribute(court_is_court_first_seized, true)]), court_is_court_first_seized, false, Status), Statuses),
    Statuses == [may_suspend_proceedings].
test(what_if_adds_an_absent_key) :-
    gdpr_representation_and_suspension_what_if(court_contact_duty([attribute(court_is_competent_court, true), attribute(other_proceedings_concern_same_controller_or_processor, true), attribute(other_proceedings_concern_same_subject_matter, true)]), court_has_information_on_proceedings_pending_in_another_member_state, true, contact_duty_applies).
test(the_result_atoms_are_served) :-
    may_act_on_mandate,
    declining_jurisdiction_not_available.

test(what_if_with_the_mandate_is_not_refused, fail) :-
    gdpr_representation_and_suspension_what_if(mandated_representation([attribute(body_is_not_for_profit, true), attribute(body_properly_constituted_under_member_state_law, true), attribute(body_statutory_objectives_in_public_interest, true), attribute(body_active_in_protection_of_data_subjects_rights_and_freedoms, true), attribute(data_subject_mandated_the_body, false)], lodge_complaint_under_article_77), data_subject_mandated_the_body, true, may_not_act_on_mandate).
