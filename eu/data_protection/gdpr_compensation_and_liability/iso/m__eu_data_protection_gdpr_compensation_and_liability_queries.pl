% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_compensation_and_liability_queries, [gdpr_compensation_and_liability_profile_keys/1, gdpr_compensation_and_liability_what_if/4, right_not_established/0, not_liable_for_damage/0, exempt_from_liability/0, liable_for_damage/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_compensation_and_liability_kernel, [gdpr_compensation_and_liability_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_compensation_and_liability_gdpr_compensation_and_liability, [gdpr_compensation_and_liability_status/2]).

gdpr_compensation_and_liability_profile_keys([party_role, involved_in_the_processing, processor_breached_obligations_directed_to_processors, processor_acted_outside_or_contrary_to_lawful_instructions, damage_suffered, infringement_of_the_regulation_occurred, damage_resulted_from_the_infringement, not_in_any_way_responsible_for_the_event]).

gdpr_compensation_and_liability_what_if(Profile, OverriddenKey, NewValue, NewStatus) :-
    override_attribute(Profile, OverriddenKey, NewValue, Hypothesis),
    gdpr_compensation_and_liability_status(Hypothesis, NewStatus).

override_attribute(Elements, OverriddenKey, NewValue, Hypothesis) :-
    drop_key(Elements, OverriddenKey, Kept),
    append(Kept, [attribute(OverriddenKey, NewValue)], Hypothesis).

drop_key([], _, []).
drop_key([Element|Elements], OverriddenKey, Kept) :-
    nonvar(Element),
    Element = attribute(ElementKey, _),
    ElementKey == OverriddenKey,
    drop_key(Elements, OverriddenKey, Kept).
drop_key([Element|Elements], OverriddenKey, [Element|Kept]) :-
    nonvar(Element),
    Element = attribute(ElementKey, _),
    ElementKey \== OverriddenKey,
    drop_key(Elements, OverriddenKey, Kept).
drop_key([Element|Elements], OverriddenKey, [Element|Kept]) :-
    nonvar(Element),
    Element \= attribute(_, _),
    drop_key(Elements, OverriddenKey, Kept).
drop_key([Element|Elements], OverriddenKey, [Element|Kept]) :-
    var(Element),
    drop_key(Elements, OverriddenKey, Kept).

right_not_established.

not_liable_for_damage.

exempt_from_liability.

liable_for_damage.

test(the_profile_keys_are_the_eight_contract_keys) :-
    gdpr_compensation_and_liability_profile_keys(ProfileKeys),
    length(ProfileKeys, 8).
test(supplying_the_statement_turns_a_referral_into_liability) :-
    gdpr_compensation_and_liability_what_if([attribute(party_role, controller), attribute(involved_in_the_processing, true), attribute(damage_suffered, true), attribute(infringement_of_the_regulation_occurred, true), attribute(damage_resulted_from_the_infringement, true)], not_in_any_way_responsible_for_the_event, attested(false, attestation(host, at, reason, none)), liable_for_damage).
test(overriding_involvement_puts_the_controller_outside) :-
    gdpr_compensation_and_liability_what_if([attribute(party_role, controller), attribute(involved_in_the_processing, true), attribute(damage_suffered, true), attribute(infringement_of_the_regulation_occurred, true), attribute(damage_resulted_from_the_infringement, true), attribute(not_in_any_way_responsible_for_the_event, attested(false, attestation(host, at, reason, none)))], involved_in_the_processing, false, not_liable_for_damage).
test(an_override_with_a_wrong_type_is_an_input_problem) :-
    gdpr_compensation_and_liability_what_if([attribute(damage_suffered, true)], damage_suffered, maybe, input_problems([wrong_type(damage_suffered)])).
test(the_final_result_atoms_have_defining_clauses) :-
    right_not_established,
    not_liable_for_damage,
    exempt_from_liability,
    liable_for_damage.

test(overriding_involvement_is_not_liable_for_damage, fail) :-
    gdpr_compensation_and_liability_what_if([attribute(party_role, controller), attribute(involved_in_the_processing, true), attribute(damage_suffered, true), attribute(infringement_of_the_regulation_occurred, true), attribute(damage_resulted_from_the_infringement, true), attribute(not_in_any_way_responsible_for_the_event, attested(false, attestation(host, at, reason, none)))], involved_in_the_processing, false, liable_for_damage).
