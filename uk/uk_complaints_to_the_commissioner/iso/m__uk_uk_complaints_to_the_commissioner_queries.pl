% SPDX-License-Identifier: EUPL-1.2
:- module(m__uk_uk_complaints_to_the_commissioner_queries, [uk_complaints_to_the_commissioner_profile_keys/1, uk_complaints_to_the_commissioner_what_if/4, complaint_under_section_164a/0, not_a_complaint_under_section_164a/0, complaint_under_section_165_2/0, not_a_complaint_under_section_165_2/0, acknowledgement_duty_does_not_apply/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__uk_uk_complaints_to_the_commissioner_kernel, [uk_complaints_to_the_commissioner_input_problems/2]).
:- use_module(m__uk_uk_complaints_to_the_commissioner_uk_complaints_to_the_commissioner, [uk_complaints_to_the_commissioner_status/2]).

uk_complaints_to_the_commissioner_profile_keys([complaint_by_data_subject_about_own_personal_data, infringement_considered, complaint_made_to_the_controller]).

complaint_under_section_164a.

not_a_complaint_under_section_164a.

complaint_under_section_165_2.

not_a_complaint_under_section_165_2.

acknowledgement_duty_does_not_apply.

uk_complaints_to_the_commissioner_what_if(Profile, OverriddenKey, NewValue, NewStatus) :-
    hypothesis_profile(Profile, OverriddenKey, NewValue, Hypothesis),
    uk_complaints_to_the_commissioner_status(Hypothesis, NewStatus).

hypothesis_profile(Profile, _, _, Profile) :-
    uk_complaints_to_the_commissioner_input_problems(Profile, [wrong_type(profile)]).
hypothesis_profile(Profile, OverriddenKey, NewValue, Hypothesis) :-
    uk_complaints_to_the_commissioner_input_problems(Profile, Problems),
    dif(Problems, [wrong_type(profile)]),
    replace_attribute(Profile, OverriddenKey, NewValue, Hypothesis).

replace_attribute([], OverriddenKey, NewValue, [attribute(OverriddenKey, NewValue)]).
replace_attribute([attribute(ElementKey, _)|Elements], OverriddenKey, NewValue, Replaced) :-
    ElementKey == OverriddenKey,
    replace_attribute(Elements, OverriddenKey, NewValue, Replaced).
replace_attribute([attribute(ElementKey, ElementValue)|Elements], OverriddenKey, NewValue, [attribute(ElementKey, ElementValue)|Replaced]) :-
    ElementKey \== OverriddenKey,
    replace_attribute(Elements, OverriddenKey, NewValue, Replaced).
