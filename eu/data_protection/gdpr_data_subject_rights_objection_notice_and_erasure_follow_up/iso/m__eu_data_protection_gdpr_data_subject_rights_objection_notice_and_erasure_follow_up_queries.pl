% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_data_subject_rights_objection_notice_and_erasure_follow_up_queries, [gdpr_data_subject_rights_objection_notice_and_erasure_follow_up_profile_keys/1, gdpr_data_subject_rights_objection_notice_and_erasure_follow_up_what_if/4, gdpr_data_subject_rights_objection_notice_and_erasure_follow_up_action_compliance/3, notice_not_owed/0, notice_not_yet_due/0, notice_complies/0, notice_does_not_comply/0, follow_up_duty_does_not_apply/0, follow_up_duty_met/0, follow_up_duty_not_met/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_hof, [exclude/3]).
:- use_module(formalize_lib, [profile_get/3, profile_has/2, profile_lacks/2]).
:- use_module(m__eu_data_protection_gdpr_data_subject_rights_objection_notice_and_erasure_follow_up_citations, [implements/1]).
:- use_module(m__eu_data_protection_gdpr_data_subject_rights_objection_notice_and_erasure_follow_up_kernel, [gdpr_data_subject_rights_objection_notice_and_erasure_follow_up_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_data_subject_rights_objection_notice_and_erasure_follow_up_gdpr_data_subject_rights_objection_notice_and_erasure_follow_up, [gdpr_data_subject_rights_objection_notice_and_erasure_follow_up_status/2]).

gdpr_data_subject_rights_objection_notice_and_erasure_follow_up_profile_keys([right_to_object_applies, first_communication_with_data_subject_has_taken_place, right_explicitly_brought_to_attention_by_first_communication, right_presented_separately_from_other_information, right_presented_clearly, controller_made_personal_data_public, controller_obliged_to_erase_under_article_17_1, reasonable_steps_taken_to_inform_other_controllers]).

gdpr_data_subject_rights_objection_notice_and_erasure_follow_up_what_if(Profile, OverriddenKey, NewValue, NewStatus) :-
    override_attribute(Profile, OverriddenKey, NewValue, Hypothesis),
    gdpr_data_subject_rights_objection_notice_and_erasure_follow_up_status(Hypothesis, NewStatus).

override_attribute(Profile, Key, Value, Hypothesis) :-
    exclude(attribute_has_key(Key), Profile, Others),
    append(Others, [attribute(Key, Value)], Hypothesis).

attribute_has_key(Key, attribute(ElementKey, _Value)) :-
    ElementKey == Key.

proposed_action(first_communication_without_objection_notice).
proposed_action(first_communication_with_objection_notice).
proposed_action(conclude_erasure_without_informing_other_controllers).
proposed_action(conclude_erasure_after_informing_other_controllers).

gdpr_data_subject_rights_objection_notice_and_erasure_follow_up_action_compliance(Profile, Action, input_problems([Problem|Problems])) :-
    proposed_action(Action),
    gdpr_data_subject_rights_objection_notice_and_erasure_follow_up_input_problems(Profile, [Problem|Problems]).
gdpr_data_subject_rights_objection_notice_and_erasure_follow_up_action_compliance(Profile, Action, Verdict) :-
    proposed_action(Action),
    gdpr_data_subject_rights_objection_notice_and_erasure_follow_up_input_problems(Profile, []),
    action_verdict(Action, Profile, Verdict).

crisp_state(Profile, Key, absent) :-
    profile_lacks(Profile, Key).
crisp_state(Profile, Key, Value) :-
    profile_has(Profile, Key),
    profile_get(Profile, Key, Value).

outside_state(Profile, Key, absent) :-
    profile_lacks(Profile, Key).
outside_state(Profile, Key, State) :-
    profile_has(Profile, Key),
    profile_get(Profile, Key, attested(Value, _)),
    attested_state(Value, State).

attested_state(true, attested_true).
attested_state(false, attested_false).

action_verdict(first_communication_without_objection_notice, Profile, Verdict) :-
    outside_state(Profile, right_to_object_applies, RightState),
    notice_omission_verdict(RightState, Verdict).
action_verdict(first_communication_with_objection_notice, _, permitted) :-
    implements(eu_reg_2016_679_art_21_4).
action_verdict(conclude_erasure_without_informing_other_controllers, Profile, Verdict) :-
    crisp_state(Profile, controller_made_personal_data_public, Public),
    outside_state(Profile, controller_obliged_to_erase_under_article_17_1, ObligedState),
    inform_omission_verdict(Public, ObligedState, Verdict).
action_verdict(conclude_erasure_after_informing_other_controllers, _, permitted) :-
    implements(eu_reg_2016_679_art_17_2).

notice_omission_verdict(attested_true, forbidden) :-
    implements(eu_reg_2016_679_art_21_4).
notice_omission_verdict(attested_false, permitted) :-
    implements(eu_reg_2016_679_art_21_4).
notice_omission_verdict(absent, needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_21_4), cite(article_21_right_to_object_statement)), [resolution(cite(article_21_right_to_object_statement), not_attempted), inputs_relied_on([right_to_object_applies - absent])])) :-
    implements(eu_reg_2016_679_art_21_4).

inform_omission_verdict(false, _, permitted) :-
    implements(eu_reg_2016_679_art_17_2).
inform_omission_verdict(Public, attested_false, permitted) :-
    implements(eu_reg_2016_679_art_17_2),
    dif(Public, false).
inform_omission_verdict(absent, ObligedState, indeterminate([controller_made_personal_data_public])) :-
    implements(eu_reg_2016_679_art_17_2),
    dif(ObligedState, attested_false).
inform_omission_verdict(true, absent, needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_17_2), cite(article_17_1_erasure_obligation_statement)), [resolution(cite(article_17_1_erasure_obligation_statement), not_attempted), inputs_relied_on([controller_obliged_to_erase_under_article_17_1 - absent])])) :-
    implements(eu_reg_2016_679_art_17_2).
inform_omission_verdict(true, attested_true, forbidden) :-
    implements(eu_reg_2016_679_art_17_2).

notice_not_owed.

notice_not_yet_due.

notice_complies.

notice_does_not_comply.

follow_up_duty_does_not_apply.

follow_up_duty_met.

follow_up_duty_not_met.
