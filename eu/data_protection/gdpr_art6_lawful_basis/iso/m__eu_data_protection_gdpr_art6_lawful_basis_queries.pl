% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_art6_lawful_basis_queries, [gdpr_art6_lawful_basis_profile_keys/1, gdpr_art6_lawful_basis_what_if/4, eligible/0, ineligible/0, purpose_compatible/0, purpose_not_compatible/0, compatibility_test_not_engaged/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_hof, [exclude/3]).
:- use_module(m__eu_data_protection_gdpr_art6_lawful_basis_kernel, [gdpr_art6_lawful_basis_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_art6_lawful_basis_gdpr_art6_lawful_basis, [gdpr_art6_lawful_basis_status/2]).

eligible.

ineligible.

purpose_compatible.

purpose_not_compatible.

compatibility_test_not_engaged.

gdpr_art6_lawful_basis_profile_keys([basis_claimed, consent_given_and_conditions_met, contract_necessary, legal_obligation_necessary, legal_obligation_laid_down_by_law, vital_interests_necessary, public_interest_task_necessary, public_interest_task_laid_down_by_law, processing_by_public_authority_in_its_tasks, legitimate_interests_pursued, interests_overridden, child_data_subject, special_category, new_purpose_processing, compatible_purpose]).

gdpr_art6_lawful_basis_what_if(Profile, OverriddenKey, NewValue, NewStatus) :-
    proper_list_t(Profile, IsProperList),
    hypothesis(IsProperList, Profile, OverriddenKey, NewValue, Hypothesis),
    gdpr_art6_lawful_basis_status(Hypothesis, NewStatus).

hypothesis(false, Profile, _, _, Profile).
hypothesis(true, Profile, OverriddenKey, NewValue, Hypothesis) :-
    exclude(attribute_for_key(OverriddenKey), Profile, Remaining),
    append(Remaining, [attribute(OverriddenKey, NewValue)], Hypothesis).

attribute_for_key(OverriddenKey, attribute(ElementKey, _)) :-
    ElementKey == OverriddenKey.

proper_list_t(Term, false) :-
    var(Term).
proper_list_t(Term, true) :-
    Term == [].
proper_list_t(Term, Truth) :-
    nonvar(Term),
    Term = [_|Tail],
    proper_list_t(Tail, Truth).
proper_list_t(Term, false) :-
    nonvar(Term),
    Term \== [],
    Term \= [_|_].

test(profile_keys_are_the_fifteen_contract_keys) :-
    gdpr_art6_lawful_basis_profile_keys(ProfileKeys),
    length(ProfileKeys, 15).
test(what_if_supplies_a_missing_judgement) :-
    findall(Status, gdpr_art6_lawful_basis_what_if([], contract_necessary, true, Status), Answers),
    Answers == [eligible].
test(what_if_replaces_a_stated_judgement) :-
    gdpr_art6_lawful_basis_what_if([attribute(basis_claimed, contract), attribute(contract_necessary, false)], contract_necessary, true, eligible).
test(what_if_can_turn_eligible_into_ineligible) :-
    gdpr_art6_lawful_basis_what_if([attribute(basis_claimed, contract), attribute(contract_necessary, true)], contract_necessary, false, ineligible).
test(what_if_leaves_an_improper_list_refused) :-
    gdpr_art6_lawful_basis_what_if([attribute(contract_necessary, false)|not_a_list], contract_necessary, true, input_problems([wrong_type(profile)])).
test(result_atoms_are_served) :-
    eligible,
    ineligible,
    purpose_compatible,
    purpose_not_compatible,
    compatibility_test_not_engaged.

test(what_if_replaced_judgement_is_not_ineligible, fail) :-
    gdpr_art6_lawful_basis_what_if([attribute(basis_claimed, contract), attribute(contract_necessary, false)], contract_necessary, true, ineligible).
