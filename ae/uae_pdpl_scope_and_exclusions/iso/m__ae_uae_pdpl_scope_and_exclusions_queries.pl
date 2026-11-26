% SPDX-License-Identifier: EUPL-1.2
:- module(m__ae_uae_pdpl_scope_and_exclusions_queries, [uae_pdpl_scope_and_exclusions_profile_keys/1, uae_pdpl_scope_and_exclusions_what_if/4, indeterminate/1, needs_legal_review/2, open_textured/2, inputs_relied_on/1, provenance/2, input_problems/1, wrong_type/1, duplicate_key/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_lists_extra, [clausal_is_list/1]).
:- use_module(clausal_hof, [exclude/3]).
:- use_module(m__ae_uae_pdpl_scope_and_exclusions_kernel, [uae_pdpl_scope_and_exclusions_input_problems/2]).
:- use_module(m__ae_uae_pdpl_scope_and_exclusions_uae_pdpl_scope_and_exclusions, [pdpl_applies/3, pdpl_in_force/3, uae_pdpl_scope_and_exclusions_status/2]).

uae_pdpl_scope_and_exclusions_profile_keys([processing_date, activity_is_processing_of_personal_data, personal_data_is_government_data, governmental_entity_controls_or_processes, personal_data_held_by_security_or_judicial_authorities, data_subject_processing_own_data_for_personal_purposes, personal_health_data_with_own_protection_legislation, personal_banking_or_credit_data_with_own_protection_legislation, free_zone_company_or_establishment_with_own_data_protection_legislation, data_subject_resides_or_has_place_of_business_in_state, controller_or_processor_resides_in_state, data_subject_inside_state]).

uae_pdpl_scope_and_exclusions_what_if(Profile, OverriddenKey, NewValue, NewStatus) :-
    hypothesis_profile(Profile, OverriddenKey, NewValue, Hypothesis),
    uae_pdpl_scope_and_exclusions_status(Hypothesis, NewStatus).

hypothesis_profile(Profile, OverriddenKey, NewValue, Hypothesis) :-
    exclude(attribute_has_key(OverriddenKey), Profile, OtherAttributes),
    append(OtherAttributes, [attribute(OverriddenKey, NewValue)], Hypothesis).

attribute_has_key(AttributeKey, attribute(OtherKey, _)) :-
    OtherKey == AttributeKey.

indeterminate([MissingKey]) :-
    atom(MissingKey).

needs_legal_review(open_textured(ReferredKey, cite(CitationKey)), [inputs_relied_on(ReliedPairs)|_]) :-
    atom(ReferredKey),
    atom(CitationKey),
    clausal_is_list(ReliedPairs).

open_textured(ReferredKey, cite(CitationKey)) :-
    atom(ReferredKey),
    atom(CitationKey).

inputs_relied_on(ReliedPairs) :-
    clausal_is_list(ReliedPairs).

provenance(ClauseName, ProvenanceCitations) :-
    nonvar(ClauseName),
    clausal_is_list(ProvenanceCitations).

input_problems(ProblemList) :-
    clausal_is_list(ProblemList).

wrong_type(WrongTypeKey) :-
    atom(WrongTypeKey).

duplicate_key(DuplicateKey) :-
    atom(DuplicateKey).

query_test_profile([attribute(processing_date, date(2022, 1, 2)), attribute(activity_is_processing_of_personal_data, true), attribute(personal_data_is_government_data, false), attribute(governmental_entity_controls_or_processes, false), attribute(personal_data_held_by_security_or_judicial_authorities, false), attribute(data_subject_processing_own_data_for_personal_purposes, false), attribute(personal_health_data_with_own_protection_legislation, false), attribute(personal_banking_or_credit_data_with_own_protection_legislation, false), attribute(free_zone_company_or_establishment_with_own_data_protection_legislation, false), attribute(data_subject_resides_or_has_place_of_business_in_state, true), attribute(controller_or_processor_resides_in_state, false), attribute(data_subject_inside_state, false)]).

test(the_unchanged_profile_applies) :-
    query_test_profile(Profile),
    uae_pdpl_scope_and_exclusions_what_if(Profile, data_subject_resides_or_has_place_of_business_in_state, true, applies).
test(what_if_an_exclusion_holds) :-
    query_test_profile(Profile),
    findall(Status, uae_pdpl_scope_and_exclusions_what_if(Profile, personal_data_is_government_data, true, Status), Statuses),
    Statuses == [does_not_apply].
test(what_if_the_day_before_commencement) :-
    query_test_profile(Profile),
    uae_pdpl_scope_and_exclusions_what_if(Profile, processing_date, date(2022, 1, 1), not_in_force).
test(what_if_adds_a_missing_key) :-
    uae_pdpl_scope_and_exclusions_what_if([], processing_date, date(2021, 6, 1), not_in_force).
test(the_key_schema_has_twelve_keys) :-
    uae_pdpl_scope_and_exclusions_profile_keys(Keys),
    length(Keys, 12).
test(an_indeterminate_answer_is_recognised) :-
    pdpl_applies([attribute(processing_date, date(2023, 5, 1))], indeterminate(MissingKeys), []),
    indeterminate(MissingKeys).
test(a_problem_answer_is_recognised) :-
    pdpl_in_force(profile, input_problems(ProblemList), []),
    input_problems(ProblemList),
    ProblemList == [wrong_type(profile)],
    wrong_type(profile).
test(a_referral_is_recognised) :-
    query_test_profile(BaseProfile),
    hypothesis_profile(BaseProfile, activity_is_processing_of_personal_data, unsure, Profile),
    pdpl_applies(Profile, needs_legal_review(Reason, Context), []),
    needs_legal_review(Reason, Context),
    Reason = open_textured(ReferredKey, CitationTerm),
    open_textured(ReferredKey, CitationTerm),
    Context = [inputs_relied_on(ReliedPairs)],
    inputs_relied_on(ReliedPairs).

test(what_if_the_day_before_does_not_apply, fail) :-
    query_test_profile(Profile),
    uae_pdpl_scope_and_exclusions_what_if(Profile, processing_date, date(2022, 1, 1), applies).
test(a_bare_key_list_is_not_an_indeterminate_shape, fail) :-
    indeterminate([processing_date, data_subject_inside_state]).
