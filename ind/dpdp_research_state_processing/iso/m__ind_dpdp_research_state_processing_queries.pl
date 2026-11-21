% SPDX-License-Identifier: EUPL-1.2
:- module(m__ind_dpdp_research_state_processing_queries, [dpdp_research_state_processing_profile_keys/1, dpdp_research_state_processing_what_if/4, indeterminate/1, needs_legal_review/2, open_textured/2, inputs_relied_on/1, provenance/2, input_problems/1, unknown_key/1, wrong_type/1, duplicate_key/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_lists_extra, [clausal_is_list/1]).
:- use_module(m__ind_dpdp_research_state_processing_kernel, [dpdp_research_state_processing_input_problems/2]).
:- use_module(m__ind_dpdp_research_state_processing_dpdp_research_state_processing, [dpdp_research_state_processing_status/2]).

dpdp_research_state_processing_profile_keys([section_7_in_force_on_reference_date, section_17_in_force_on_reference_date, reference_date, processing_necessary_for_research_archiving_or_statistical_purposes, personal_data_to_be_used_for_decision_specific_to_data_principal, processing_for_section_7_b_use, lawful_manner, limited_to_necessary_personal_data, completeness_accuracy_and_consistency, retention_only_while_required, reasonable_security_safeguards, intimation_to_data_principal, business_contact_for_questions, link_and_means_to_exercise_rights, consistent_with_other_applicable_standards, accountability_for_observance, processing_by_state_or_instrumentality, purpose_includes_decision_affecting_data_principal]).

dpdp_research_state_processing_what_if(Profile, OverriddenKey, NewValue, NewStatus) :-
    without_key(Profile, OverriddenKey, OtherElements),
    dpdp_research_state_processing_status([attribute(OverriddenKey, NewValue)|OtherElements], NewStatus).

without_key([], _, []).
without_key([attribute(Key, _)|Elements], OverriddenKey, Kept) :-
    Key == OverriddenKey,
    without_key(Elements, OverriddenKey, Kept).
without_key([attribute(Key, Value)|Elements], OverriddenKey, [attribute(Key, Value)|Kept]) :-
    Key \== OverriddenKey,
    without_key(Elements, OverriddenKey, Kept).
without_key([Element|Elements], OverriddenKey, [Element|Kept]) :-
    nonvar(Element),
    Element \= attribute(_, _),
    without_key(Elements, OverriddenKey, Kept).

indeterminate(MissingKeys) :-
    clausal_is_list(MissingKeys).

needs_legal_review(Reason, Context) :-
    compound(Reason),
    clausal_is_list(Context).

open_textured(Key, Citation) :-
    atom(Key),
    compound(Citation).

inputs_relied_on(Pairs) :-
    clausal_is_list(Pairs).

provenance(Clause, Citations) :-
    nonvar(Clause),
    clausal_is_list(Citations).

input_problems(Problems) :-
    clausal_is_list(Problems).

unknown_key(Key) :-
    term_variables(Key, _Variables).

wrong_type(Key) :-
    atom(Key).

duplicate_key(Key) :-
    atom(Key).

test(what_if_replaces_a_present_key) :-
    dpdp_research_state_processing_what_if([attribute(section_17_in_force_on_reference_date, true)], section_17_in_force_on_reference_date, false, determinations(not_in_force, indeterminate([section_7_in_force_on_reference_date]), not_in_force)).
