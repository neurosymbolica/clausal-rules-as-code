% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_complaints_and_judicial_remedies_queries, [gdpr_complaints_and_judicial_remedies_profile_keys/1, gdpr_complaints_and_judicial_remedies_what_if/4]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_complaints_and_judicial_remedies_kernel, [gdpr_complaints_and_judicial_remedies_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_complaints_and_judicial_remedies_gdpr_complaints_and_judicial_remedies, [gdpr_complaints_and_judicial_remedies_status/2]).

gdpr_complaints_and_judicial_remedies_profile_keys([is_data_subject, data_subject_considers_processing_infringes_regulation, decision_is_legally_binding, decision_concerns_the_caller, complaint_lodged_under_article_77, authority_competent_under_articles_55_and_56, authority_handled_the_complaint, three_months_from_the_complaint_have_passed, authority_informed_on_progress_or_outcome, data_subject_considers_rights_infringed_by_processing, defendant_is_member_state_public_authority_acting_in_public_powers]).

gdpr_complaints_and_judicial_remedies_what_if(Profile, OverriddenKey, NewValue, NewStatus) :-
    attribute_list_override(Profile, OverriddenKey, NewValue, Hypothesis),
    gdpr_complaints_and_judicial_remedies_status(Hypothesis, NewStatus).

attribute_list_override([], Key, Value, [attribute(Key, Value)]).
attribute_list_override([attribute(ElementKey, ElementValue)|Elements], Key, Value, [attribute(ElementKey, ElementValue)|Overridden]) :-
    ElementKey \== Key,
    attribute_list_override(Elements, Key, Value, Overridden).
attribute_list_override([attribute(ElementKey, _)|Elements], Key, Value, [attribute(Key, Value)|Remaining]) :-
    ElementKey == Key,
    attribute_list_without_key(Elements, Key, Remaining).

attribute_list_without_key([], _, []).
attribute_list_without_key([attribute(ElementKey, ElementValue)|Elements], Key, [attribute(ElementKey, ElementValue)|Remaining]) :-
    ElementKey \== Key,
    attribute_list_without_key(Elements, Key, Remaining).
attribute_list_without_key([attribute(ElementKey, _)|Elements], Key, Remaining) :-
    ElementKey == Key,
    attribute_list_without_key(Elements, Key, Remaining).

test(profile_keys_are_the_eleven_contract_keys) :-
    gdpr_complaints_and_judicial_remedies_profile_keys(ProfileKeys),
    length(ProfileKeys, 11).
test(what_if_replaces_a_present_key) :-
    gdpr_complaints_and_judicial_remedies_what_if([attribute(is_data_subject, false), attribute(data_subject_considers_processing_infringes_regulation, true)], is_data_subject, true, answer(complaint_right, Result)),
    Result == complaint_right_exists.
test(what_if_adds_an_absent_key) :-
    gdpr_complaints_and_judicial_remedies_what_if([], defendant_is_member_state_public_authority_acting_in_public_powers, true, answer(controller_processor_forum, Result)),
    Result == forum_establishment_state_only.
test(what_if_collapses_a_duplicate_key) :-
    gdpr_complaints_and_judicial_remedies_what_if([attribute(is_data_subject, true), attribute(is_data_subject, false)], is_data_subject, false, answer(complaint_right, Result)),
    Result == no_complaint_right.
test(what_if_gives_five_statuses) :-
    findall(Status, gdpr_complaints_and_judicial_remedies_what_if([], is_data_subject, false, Status), Statuses),
    length(Statuses, 5).
test(input_problems_reexported) :-
    gdpr_complaints_and_judicial_remedies_input_problems([attribute(colour, red)], Problems),
    Problems == [unknown_key(colour)].

test(what_if_replaced_key_is_not_the_old_answer, fail) :-
    gdpr_complaints_and_judicial_remedies_what_if([attribute(is_data_subject, false), attribute(data_subject_considers_processing_infringes_regulation, true)], is_data_subject, true, answer(complaint_right, no_complaint_right)).
test(what_if_on_a_non_list_has_no_answer, fail) :-
    gdpr_complaints_and_judicial_remedies_what_if(not_a_profile, is_data_subject, true, _).
