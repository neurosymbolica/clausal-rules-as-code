% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_processor_contract_queries, [gdpr_processor_contract_profile_keys/1, gdpr_processor_contract_what_if/4, input_problems/1, wrong_type/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_lists_extra, [clausal_is_list/1]).
:- use_module(m__eu_data_protection_gdpr_processor_contract_kernel, [gdpr_processor_contract_input_problems/2, gdpr_processor_contract_key_order/1]).
:- use_module(m__eu_data_protection_gdpr_processor_contract_processor_contract_status, [processor_contract_status_status/2]).

input_problems(Problems) :-
    clausal_is_list(Problems).

wrong_type(Key) :-
    atom(Key).

gdpr_processor_contract_profile_keys(Keys) :-
    gdpr_processor_contract_key_order(Keys).

gdpr_processor_contract_what_if(Profile, OverriddenKey, NewValue, NewStatus) :-
    proper_list_t(Profile, IsList),
    hypothesis(IsList, Profile, OverriddenKey, NewValue, Hypothesis),
    processor_contract_status_status(Hypothesis, NewStatus).

hypothesis(false, Profile, _, _, Profile).
hypothesis(true, Profile, OverriddenKey, NewValue, Hypothesis) :-
    without_key(Profile, OverriddenKey, Kept),
    append(Kept, [attribute(OverriddenKey, NewValue)], Hypothesis).

proper_list_t(Term, false) :-
    var(Term).
proper_list_t(Term, true) :-
    Term == [].
proper_list_t(Term, Truth) :-
    nonvar(Term),
    Term = [_|Elements],
    proper_list_t(Elements, Truth).
proper_list_t(Term, false) :-
    nonvar(Term),
    Term \== [],
    Term \= [_|_].

without_key([], _, []).
without_key([Element|Elements], OverriddenKey, Kept) :-
    element_matches_t(Element, OverriddenKey, Matches),
    keep_element(Matches, Element, Rest, Kept),
    without_key(Elements, OverriddenKey, Rest).

element_matches_t(Element, _, false) :-
    var(Element).
element_matches_t(Element, OverriddenKey, Truth) :-
    nonvar(Element),
    Element = attribute(ElementKey, _),
    same_key_t(ElementKey, OverriddenKey, Truth).
element_matches_t(Element, _, false) :-
    nonvar(Element),
    Element \= attribute(_, _).

same_key_t(ElementKey, OverriddenKey, true) :-
    ElementKey == OverriddenKey.
same_key_t(ElementKey, OverriddenKey, false) :-
    ElementKey \== OverriddenKey.

keep_element(true, _, Rest, Rest).
keep_element(false, Element, Rest, [Element|Rest]).

base_profile([attribute(processing_on_behalf_of_controller, true), attribute(processor_determines_purposes_and_means, false), attribute(processor_provides_sufficient_guarantees, true), attribute(contract_binding_on_processor, true), attribute(contract_governed_by_union_or_member_state_law, true), attribute(contract_in_writing, true), attribute(contract_sets_out_subject_matter, true), attribute(contract_sets_out_duration, true), attribute(contract_sets_out_nature_of_processing, true), attribute(contract_sets_out_purpose_of_processing, true), attribute(contract_sets_out_type_of_personal_data, true), attribute(contract_sets_out_categories_of_data_subjects, true), attribute(contract_sets_out_controller_obligations_and_rights, true), attribute(stipulates_processing_only_on_documented_instructions, true), attribute(stipulates_confidentiality_commitment, true), attribute(stipulates_security_measures, true), attribute(stipulates_conditions_for_engaging_another_processor, true), attribute(stipulates_assistance_with_data_subject_requests, true), attribute(stipulates_assistance_with_articles_32_to_36_obligations, true), attribute(stipulates_deletion_or_return_of_personal_data, true), attribute(stipulates_information_and_audit_rights, true), attribute(stipulates_notice_of_infringing_instruction, true), attribute(subprocessor_engaged, false)]).

test(profile_keys_are_thirty_two) :-
    gdpr_processor_contract_profile_keys(Keys),
    length(Keys, 32).
test(input_problems_constructor_holds_for_a_list) :-
    input_problems([wrong_type(profile)]).
test(wrong_type_constructor_holds_for_an_atom) :-
    wrong_type(contract_in_writing).
test(what_if_replaces_and_flips_to_ineligible) :-
    base_profile(Profile),
    findall(Status, gdpr_processor_contract_what_if(Profile, stipulates_security_measures, false, Status), Statuses),
    Statuses == [ineligible].
test(what_if_identity_stays_eligible) :-
    base_profile(Profile),
    gdpr_processor_contract_what_if(Profile, stipulates_security_measures, true, eligible).
test(what_if_adds_an_absent_key) :-
    gdpr_processor_contract_what_if([], processing_on_behalf_of_controller, false, not_applicable).
test(what_if_on_a_non_list_reports_input_problems) :-
    gdpr_processor_contract_what_if(profile_text, contract_in_writing, true, input_problems([wrong_type(profile)])).

test(input_problems_constructor_rejects_a_non_list, fail) :-
    input_problems(profile_text).
test(wrong_type_constructor_rejects_a_compound, fail) :-
    wrong_type(attribute(contract_in_writing, true)).
test(what_if_never_creates_a_duplicate_key, fail) :-
    base_profile(Profile),
    gdpr_processor_contract_what_if(Profile, contract_in_writing, true, input_problems(_)).
