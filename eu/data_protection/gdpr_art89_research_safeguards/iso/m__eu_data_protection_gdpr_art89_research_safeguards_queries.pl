% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_art89_research_safeguards_queries, [gdpr_art89_research_safeguards_profile_keys/1, gdpr_art89_research_safeguards_what_if/4, gdpr_art89_research_safeguards_justification/2, gdpr_art89_research_safeguards_compliance_check/2, gdpr_art89_verdict/3, indeterminate/1, needs_legal_review/2, open_textured/2, inputs_relied_on/1, input_problems/1, unknown_key/1, wrong_type/1, duplicate_key/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_lists_extra, [is_list/1]).
:- use_module(m__eu_data_protection_gdpr_art89_research_safeguards_kernel, [gdpr_art89_research_safeguards_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_art89_research_safeguards_safeguards_status, [safeguards_status/2, safeguards_status_checklist/2]).

gdpr_art89_research_safeguards_profile_keys([identifiable_data_processed, minimisation_measures_in_place, non_identifying_processing_sufficient, purpose, safeguards_appropriate, technical_organisational_measures_in_place]).

gdpr_art89_research_safeguards_what_if(Profile, OverriddenKey, NewValue, NewStatus) :-
    override_attribute(Profile, OverriddenKey, NewValue, Hypothesis),
    safeguards_status(Hypothesis, NewStatus).

override_attribute([], Key, Value, [attribute(Key, Value)]).
override_attribute([attribute(ElementKey, _)|Elements], Key, Value, Overridden) :-
    ElementKey = Key,
    override_attribute(Elements, Key, Value, Overridden).
override_attribute([attribute(ElementKey, ElementValue)|Elements], Key, Value, [attribute(ElementKey, ElementValue)|Overridden]) :-
    dif(ElementKey, Key),
    override_attribute(Elements, Key, Value, Overridden).

gdpr_art89_research_safeguards_justification(Profile, Items) :-
    safeguards_status_checklist(Profile, Items).

gdpr_art89_research_safeguards_compliance_check(Profile, Result) :-
    safeguards_status(Profile, Status),
    compliance_result(Status, Result).

compliance_result(in_accordance, permitted).
compliance_result(not_applicable, permitted).
compliance_result(not_in_accordance, prohibited).
compliance_result(indeterminate(_), undetermined).
compliance_result(needs_legal_review(_, _), undetermined).
compliance_result(input_problems(_), undetermined).

gdpr_art89_verdict(Status, Unmet, Citations) :-
    verdict_status(Status),
    is_list(Unmet),
    is_list(Citations).

verdict_status(in_accordance).
verdict_status(not_in_accordance).
verdict_status(not_applicable).
verdict_status(indeterminate(MissingKeys)) :-
    indeterminate(MissingKeys).
verdict_status(needs_legal_review(Reason, Context)) :-
    needs_legal_review(Reason, Context).
verdict_status(input_problems(Problems)) :-
    input_problems(Problems).

indeterminate(MissingKeys) :-
    MissingKeys = [_|_].

needs_legal_review(open_textured(non_identifying_processing_sufficient, Citation), [inputs_relied_on([identifiable_data_processed - true, non_identifying_processing_sufficient - unsure])]) :-
    open_textured(non_identifying_processing_sufficient, Citation).
needs_legal_review(open_textured(safeguards_appropriate, Citation), [inputs_relied_on([safeguards_appropriate - unsure])]) :-
    open_textured(safeguards_appropriate, Citation).

open_textured(Input, Citation) :-
    atom(Input),
    Citation = cite(_).

inputs_relied_on(Pairs) :-
    Pairs = [_|_].

input_problems(Problems) :-
    Problems = [_|_].

unknown_key(Key) :-
    atom(Key).

wrong_type(Key) :-
    atom(Key).

duplicate_key(Key) :-
    atom(Key).
