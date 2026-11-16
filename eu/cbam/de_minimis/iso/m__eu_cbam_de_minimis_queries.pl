% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_cbam_de_minimis_queries, [de_minimis_profile_keys/1, de_minimis_what_if/4, de_minimis_exemption_applies/0, de_minimis_exemption_does_not_apply/0, outside_de_minimis_exemption/0, counted_toward_threshold/0, not_goods_of_this_regulation/0, indeterminate/1, needs_legal_review/2, open_textured/2, inputs_relied_on/1, provenance/2, input_problems/1, unknown_key/1, wrong_type/1, duplicate_key/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_lists_extra, [is_list/1]).
:- use_module(m__eu_cbam_de_minimis_kernel, [de_minimis_input_problems/2]).
:- use_module(m__eu_cbam_de_minimis_de_minimis, [de_minimis_status/2]).

de_minimis_profile_keys([single_mass_based_threshold_tonnes, year_date_basis, net_mass_kg_by_acceptance_date, net_mass_kg_by_release_date, goods_kind]).

de_minimis_what_if(Profile, OverriddenKey, NewValue, NewStatus) :-
    override_attribute(Profile, OverriddenKey, NewValue, Hypothesis),
    de_minimis_status(Hypothesis, NewStatus).

override_attribute([], Key, Value, [attribute(Key, Value)]).
override_attribute([attribute(ElementKey, _)|Elements], Key, Value, [attribute(Key, Value)|Remaining]) :-
    ElementKey == Key,
    remove_attribute(Elements, Key, Remaining).
override_attribute([attribute(ElementKey, ElementValue)|Elements], Key, Value, [attribute(ElementKey, ElementValue)|Overridden]) :-
    ElementKey \== Key,
    override_attribute(Elements, Key, Value, Overridden).

remove_attribute([], _, []).
remove_attribute([attribute(ElementKey, _)|Elements], Key, Remaining) :-
    ElementKey == Key,
    remove_attribute(Elements, Key, Remaining).
remove_attribute([attribute(ElementKey, ElementValue)|Elements], Key, [attribute(ElementKey, ElementValue)|Remaining]) :-
    ElementKey \== Key,
    remove_attribute(Elements, Key, Remaining).

de_minimis_exemption_applies.

de_minimis_exemption_does_not_apply.

outside_de_minimis_exemption.

counted_toward_threshold.

not_goods_of_this_regulation.

indeterminate([MissingKey]) :-
    atom(MissingKey).

needs_legal_review(open_textured(year_date_basis, cite(eu_reg_2023_956_art_2a_1)), [inputs_relied_on([year_date_basis - unsure])]).

open_textured(InputKey, cite(CitationKey)) :-
    atom(InputKey),
    atom(CitationKey).

inputs_relied_on(Pairs) :-
    is_list(Pairs).

provenance(_Clause, Citations) :-
    is_list(Citations).

input_problems([_FirstProblem|_OtherProblems]).

unknown_key(GivenKey) :-
    ground(GivenKey).

wrong_type(GivenKey) :-
    atom(GivenKey).

duplicate_key(GivenKey) :-
    atom(GivenKey).
