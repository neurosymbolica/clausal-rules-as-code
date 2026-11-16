% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_processor_contract_queries, [gdpr_processor_contract_profile_keys/1, gdpr_processor_contract_what_if/4]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(library(reif), [(=)/3]).
:- use_module(library(reif), [if_/3]).
:- use_module(m__eu_data_protection_gdpr_processor_contract_kernel, [gdpr_processor_contract_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_processor_contract_citations, [implements/1]).
:- use_module(m__eu_data_protection_gdpr_processor_contract_processor_contract_status, [processor_contract_status/2]).

gdpr_processor_contract_profile_keys([contract_binding_on_processor, contract_governed_by_union_or_member_state_law, contract_in_writing, contract_sets_out_categories_of_data_subjects, contract_sets_out_controller_obligations_and_rights, contract_sets_out_duration, contract_sets_out_nature_of_processing, contract_sets_out_purpose_of_processing, contract_sets_out_subject_matter, contract_sets_out_type_of_personal_data, controller_given_opportunity_to_object, processing_on_behalf_of_controller, processor_determines_purposes_and_means, processor_informed_controller_of_intended_changes, processor_provides_sufficient_guarantees, standard_clauses_adopted, stipulates_assistance_with_articles_32_to_36_obligations, stipulates_assistance_with_data_subject_requests, stipulates_conditions_for_engaging_another_processor, stipulates_confidentiality_commitment, stipulates_deletion_or_return_of_personal_data, stipulates_information_and_audit_rights, stipulates_notice_of_infringing_instruction, stipulates_processing_only_on_documented_instructions, stipulates_security_measures, subprocessor_authorisation, subprocessor_authorisation_given_before_engagement, subprocessor_contract_governed_by_union_or_member_state_law, subprocessor_contract_in_writing, subprocessor_engaged, subprocessor_obligations_same, subprocessor_provides_sufficient_guarantees]).

gdpr_processor_contract_what_if(Profile, OverriddenKey, NewValue, NewStatus) :-
    recorded_provisions,
    override_attribute(Profile, OverriddenKey, NewValue, Hypothesis),
    processor_contract_status(Hypothesis, NewStatus).

recorded_provisions :-
    implements(eu_reg_2016_679_art_4_1),
    implements(eu_reg_2016_679_art_4_2),
    implements(eu_reg_2016_679_art_4_7),
    implements(eu_reg_2016_679_art_28_5),
    implements(eu_reg_2016_679_art_28_6),
    implements(eu_reg_2016_679_art_28_7),
    implements(eu_reg_2016_679_art_28_8),
    implements(eu_reg_2016_679_art_29).

override_attribute([], Key, Value, [attribute(Key, Value)]).
override_attribute([attribute(OtherKey, OtherValue)|Attributes], Key, Value, Result) :-
    override_attribute(Attributes, Key, Value, LaterResult),
    if_(OtherKey = Key, Result = LaterResult, Result = [attribute(OtherKey, OtherValue)|LaterResult]).
