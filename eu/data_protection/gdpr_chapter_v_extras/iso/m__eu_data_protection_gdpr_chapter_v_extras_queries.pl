% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_chapter_v_extras_queries, [gdpr_chapter_v_extras_profile_keys/1, gdpr_chapter_v_extras_what_if/4, no_second_subparagraph_transfer/0, not_a_processor_duty/0, duty_met/0, duty_not_met/0, article_48_not_engaged/0, not_barred_by_article_48/0, not_recognisable_or_enforceable/0, not_an_onward_transfer/0, onward_transfer_may_take_place/0, onward_transfer_may_not_take_place/0, inform_supervisory_authority/0, inform_data_subject/0, document_assessment_and_safeguards/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_hof, [exclude/3]).
:- use_module(m__eu_data_protection_gdpr_chapter_v_extras_kernel, [gdpr_chapter_v_extras_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_chapter_v_extras_gdpr_chapter_v_extras, [second_subparagraph_duty/5, foreign_judgment_or_decision_recognition/4, onward_transfer_condition/4, gdpr_chapter_v_extras_status/2]).

gdpr_chapter_v_extras_profile_keys([transfer_relies_on_article_49_1_second_subparagraph, party_role, supervisory_authority_informed_of_transfer, data_subject_informed_of_transfer, data_subject_informed_of_compelling_legitimate_interests, assessment_documented_in_records, suitable_safeguards_documented_in_records, third_country_judgment_or_decision_requires_transfer, international_agreement_basis_for_judgment_or_decision, transfer_is_onward_transfer, onward_transfer_has_chapter_v_basis]).

gdpr_chapter_v_extras_what_if(Profile, OverriddenKey, NewValue, NewStatus) :-
    gdpr_chapter_v_extras_input_problems(Profile, Problems),
    what_if_status(Problems, Profile, OverriddenKey, NewValue, NewStatus).

what_if_status([], Profile, OverriddenKey, NewValue, NewStatus) :-
    override_attribute(Profile, OverriddenKey, NewValue, Hypothesis),
    gdpr_chapter_v_extras_status(Hypothesis, NewStatus).
what_if_status([_|_], Profile, _, _, NewStatus) :-
    gdpr_chapter_v_extras_status(Profile, NewStatus).

override_attribute(Profile, OverriddenKey, NewValue, Hypothesis) :-
    exclude(attribute_with_key(OverriddenKey), Profile, OtherAttributes),
    append(OtherAttributes, [attribute(OverriddenKey, NewValue)], Hypothesis).

attribute_with_key(OverriddenKey, attribute(ElementKey, _)) :-
    ElementKey == OverriddenKey.

no_second_subparagraph_transfer.

not_a_processor_duty.

duty_met.

duty_not_met.

article_48_not_engaged.

not_barred_by_article_48.

not_recognisable_or_enforceable.

not_an_onward_transfer.

onward_transfer_may_take_place.

onward_transfer_may_not_take_place.

inform_supervisory_authority.

inform_data_subject.

document_assessment_and_safeguards.

test(profile_keys_are_the_eleven_contract_keys) :-
    gdpr_chapter_v_extras_profile_keys(ProfileKeys),
    length(ProfileKeys, 11).
test(what_if_flips_the_onward_basis) :-
    findall(Status, gdpr_chapter_v_extras_what_if([attribute(transfer_is_onward_transfer, attested(true, attestation(by, at, reason, none))), attribute(onward_transfer_has_chapter_v_basis, attested(false, attestation(by, at, reason, none)))], onward_transfer_has_chapter_v_basis, attested(true, attestation(by, at, reason, none)), Status), Statuses),
    Statuses == [onward_transfer_may_take_place].
test(what_if_adds_an_absent_key) :-
    findall(Status, gdpr_chapter_v_extras_what_if([], transfer_is_onward_transfer, attested(false, attestation(by, at, reason, none)), Status), Statuses),
    Statuses == [not_an_onward_transfer].
test(what_if_keeps_input_problems) :-
    findall(Status, gdpr_chapter_v_extras_what_if(not_a_list, transfer_is_onward_transfer, attested(true, attestation(by, at, reason, none)), Status), Statuses),
    Statuses == [input_problems([wrong_type(profile)])].
test(re_exported_duty_query_answers_once) :-
    findall(Result, second_subparagraph_duty([attribute(party_role, processor)], inform_supervisory_authority, Result, _, _), Results),
    Results == [not_a_processor_duty].
test(re_exported_article_48_query_answers_once) :-
    findall(Result, foreign_judgment_or_decision_recognition([attribute(third_country_judgment_or_decision_requires_transfer, attested(false, attestation(by, at, reason, none)))], Result, _, _), Results),
    Results == [article_48_not_engaged].
test(re_exported_input_check_answers_once) :-
    findall(Problems, gdpr_chapter_v_extras_input_problems([attribute(party_role, controller), attribute(party_role, controller)], Problems), Answers),
    Answers == [[duplicate_key(party_role)]].
test(re_exported_input_check_called_directly) :-
    gdpr_chapter_v_extras_input_problems([attribute(party_role, controller)], Problems),
    Problems == [].
test(result_constructor_atoms_resolve) :-
    duty_met,
    not_a_processor_duty,
    inform_data_subject.
