% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_art6_lawful_basis_queries, [gdpr_art6_lawful_basis_profile_keys/1, gdpr_art6_lawful_basis_what_if/4, eligible/0, ineligible/0, purpose_compatible/0, purpose_not_compatible/0, compatibility_test_not_engaged/0, compatibility_not_ascertained/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_art6_lawful_basis_kernel, [gdpr_art6_lawful_basis_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_art6_lawful_basis_gdpr_art6_lawful_basis, [gdpr_art6_lawful_basis_status/2]).

gdpr_art6_lawful_basis_profile_keys([basis_claimed, consent_given_and_conditions_met, contract_necessary, legal_obligation_necessary, legal_obligation_laid_down_by_law, vital_interests_necessary, public_interest_task_necessary, public_interest_task_laid_down_by_law, processing_by_public_authority_in_its_tasks, legitimate_interests_pursued, interests_overridden, child_data_subject, special_category, new_purpose_processing, compatible_purpose, link_between_purposes_taken_into_account, collection_context_taken_into_account, nature_of_data_taken_into_account, possible_consequences_taken_into_account, appropriate_safeguards_taken_into_account]).

gdpr_art6_lawful_basis_what_if(Profile, OverriddenKey, NewValue, NewStatus) :-
    gdpr_art6_lawful_basis_input_problems(Profile, Problems),
    what_if_by_shape(Problems, Profile, OverriddenKey, NewValue, NewStatus).

what_if_by_shape([wrong_type(profile)], Profile, _, _, NewStatus) :-
    gdpr_art6_lawful_basis_status(Profile, NewStatus).
what_if_by_shape(Problems, Profile, OverriddenKey, NewValue, NewStatus) :-
    dif(Problems, [wrong_type(profile)]),
    without_key(Profile, OverriddenKey, Remaining),
    with_value(NewValue, OverriddenKey, Remaining, Hypothesis),
    gdpr_art6_lawful_basis_status(Hypothesis, NewStatus).

without_key([], _, []).
without_key([attribute(ElementKey, _)|Elements], OverriddenKey, Remaining) :-
    ElementKey == OverriddenKey,
    without_key(Elements, OverriddenKey, Remaining).
without_key([attribute(ElementKey, ElementValue)|Elements], OverriddenKey, [attribute(ElementKey, ElementValue)|Remaining]) :-
    ElementKey \== OverriddenKey,
    without_key(Elements, OverriddenKey, Remaining).

with_value(NewValue, _, Remaining, Remaining) :-
    NewValue == absent.
with_value(NewValue, OverriddenKey, Remaining, Hypothesis) :-
    NewValue \== absent,
    append(Remaining, [attribute(OverriddenKey, NewValue)], Hypothesis).

eligible.

ineligible.

purpose_compatible.

purpose_not_compatible.

compatibility_test_not_engaged.

compatibility_not_ascertained.

test(profile_keys_are_twenty) :-
    gdpr_art6_lawful_basis_profile_keys(ProfileKeys),
    length(ProfileKeys, 20).
test(what_if_makes_contract_necessary) :-
    gdpr_art6_lawful_basis_what_if([attribute(basis_claimed, contract), attribute(contract_necessary, false)], contract_necessary, true, eligible).
test(what_if_absent_removes_the_key) :-
    gdpr_art6_lawful_basis_what_if([attribute(basis_claimed, contract), attribute(contract_necessary, true)], contract_necessary, absent, indeterminate([contract_necessary])).
test(what_if_replaces_a_duplicated_key) :-
    gdpr_art6_lawful_basis_what_if([attribute(contract_necessary, true), attribute(contract_necessary, false)], contract_necessary, true, eligible).
test(what_if_on_a_partial_list_reports_the_profile) :-
    gdpr_art6_lawful_basis_what_if([attribute(contract_necessary, true)|_], contract_necessary, true, input_problems([wrong_type(profile)])).
test(what_if_gives_exactly_one_solution) :-
    findall(NewStatus, gdpr_art6_lawful_basis_what_if([], vital_interests_necessary, true, NewStatus), Statuses),
    Statuses == [eligible].
test(result_atoms_are_defined) :-
    eligible,
    ineligible,
    purpose_compatible,
    purpose_not_compatible,
    compatibility_test_not_engaged,
    compatibility_not_ascertained.
