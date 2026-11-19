% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_transfer_scc_queries, [gdpr_transfer_scc_profile_keys/1, gdpr_transfer_scc_what_if/4, gdpr_transfer_scc_reliance_check/2, indeterminate/1, open_textured/2, cross_reference_unresolved/2, resolution/2, outside_fact/2, attested/2, input_problems/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_transfer_scc_kernel, [gdpr_transfer_scc_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_transfer_scc_gdpr_transfer_scc, [gdpr_transfer_scc_status/2]).
:- use_module(m__eu_data_protection_gdpr_transfer_scc_citations, [implements/1]).

gdpr_transfer_scc_profile_keys([standard_contractual_clauses_decision_in_force, exporter_processing_subject_to_gdpr, importer_processing_subject_to_gdpr, no_reason_to_believe_local_laws_prevent_compliance, exporter_role, importer_role, standard_contractual_clauses_concluded, module_selected, clauses_modified, added_clauses_contradict_clauses, local_laws_assessment_documented, processor_combines_received_data_with_data_collected_in_union, annex_i_a_list_of_parties_completed, annex_i_b_description_of_transfer_completed, annex_i_c_competent_supervisory_authority_identified, annex_ii_measures_described_in_specific_terms, sub_processor_authorisation_option, annex_iii_list_of_sub_processors_completed]).

gdpr_transfer_scc_what_if(Profile, OverriddenKey, NewValue, NewStatus) :-
    gdpr_transfer_scc_input_problems(Profile, Problems),
    what_if_status(Problems, Profile, OverriddenKey, NewValue, NewStatus).

what_if_status([Problem|Problems], _, _, _, input_problems([Problem|Problems])).
what_if_status([], Profile, OverriddenKey, NewValue, NewStatus) :-
    override_attribute(Profile, OverriddenKey, NewValue, Hypothesis),
    gdpr_transfer_scc_status(Hypothesis, NewStatus).

override_attribute([], OverriddenKey, NewValue, [attribute(OverriddenKey, NewValue)]).
override_attribute([attribute(OverriddenKey, _)|Elements], OverriddenKey, NewValue, [attribute(OverriddenKey, NewValue)|RemainingElements]) :-
    without_key(Elements, OverriddenKey, RemainingElements).
override_attribute([attribute(OtherKey, OtherValue)|Elements], OverriddenKey, NewValue, [attribute(OtherKey, OtherValue)|RemainingElements]) :-
    dif(OtherKey, OverriddenKey),
    override_attribute(Elements, OverriddenKey, NewValue, RemainingElements).

without_key([], _, []).
without_key([attribute(OverriddenKey, _)|Elements], OverriddenKey, RemainingElements) :-
    without_key(Elements, OverriddenKey, RemainingElements).
without_key([attribute(OtherKey, OtherValue)|Elements], OverriddenKey, [attribute(OtherKey, OtherValue)|RemainingElements]) :-
    dif(OtherKey, OverriddenKey),
    without_key(Elements, OverriddenKey, RemainingElements).

gdpr_transfer_scc_reliance_check(Profile, Verdict) :-
    gdpr_transfer_scc_status(Profile, Status),
    reliance_verdict(Status, Verdict).

reliance_verdict(appropriate_safeguards_provided, may_rely_on_clauses) :-
    implements(eu_reg_2016_679_art_46_2_c).
reliance_verdict(appropriate_safeguards_not_provided, may_not_rely_on_clauses) :-
    implements(eu_reg_2016_679_art_46_2_c).
reliance_verdict(indeterminate(MissingKeys), indeterminate(MissingKeys)).
reliance_verdict(needs_legal_review(Reason, Context), needs_legal_review(Reason, Context)).
reliance_verdict(input_problems(Problems), input_problems(Problems)).

indeterminate([_MissingProfileKey]).

open_textured(_JudgementKey, cite(_CitationKey)).

cross_reference_unresolved(cite(_CitationKey), cite(_TargetKey)).

resolution(cite(_TargetKey), not_attempted).

outside_fact(_OutsideFactKey, attested(_AttestedValue, _AttestationRecord)).

attested(_AttestedValue, attestation(_AttestedBy, _AttestedAt, _AttestedReason, _AttestedEvidence)).

input_problems([_FirstProblem|_OtherProblems]).
