% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_transfer_dpf_fixtures, [gdpr_transfer_dpf_subject/1, gdpr_transfer_dpf_profile_for/2, gdpr_transfer_dpf_assess/2]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_transfer_dpf_gdpr_transfer_dpf, [decide_gdpr_transfer_dpf/2]).

affirming_statement(attested(true, attestation(host_user, host_time, stated_from_published_record, url('https://www.dataprivacyframework.gov/list', '2026-11-01')))).

denying_statement(attested(false, attestation(host_user, host_time, stated_from_published_record, none))).

gdpr_transfer_dpf_subject(all_conditions_hold).
gdpr_transfer_dpf_subject(not_from_union).
gdpr_transfer_dpf_subject(recipient_outside_united_states).
gdpr_transfer_dpf_subject(decision_not_in_force).
gdpr_transfer_dpf_subject(recipient_off_list).
gdpr_transfer_dpf_subject(human_resources_data_not_declared).
gdpr_transfer_dpf_subject(two_facts_denied).
gdpr_transfer_dpf_subject(crisp_false_with_facts_absent).
gdpr_transfer_dpf_subject(decision_statement_absent).
gdpr_transfer_dpf_subject(list_statement_absent_union_absent).
gdpr_transfer_dpf_subject(coverage_statement_absent).
gdpr_transfer_dpf_subject(union_absent).
gdpr_transfer_dpf_subject(recipient_absent).
gdpr_transfer_dpf_subject(bare_boolean_outside_fact).
gdpr_transfer_dpf_subject(duplicate_and_unknown).
gdpr_transfer_dpf_subject(unbound_attestation_argument).
gdpr_transfer_dpf_subject(partial_list_profile).

gdpr_transfer_dpf_profile_for(all_conditions_hold, Profile) :-
    affirming_statement(Affirmed),
    Profile = [attribute(transfer_from_union, true), attribute(recipient_is_organisation_in_united_states, true), attribute(data_privacy_framework_decision_in_force, Affirmed), attribute(recipient_on_data_privacy_framework_list, Affirmed), attribute(certification_covers_transferred_data, Affirmed)].
gdpr_transfer_dpf_profile_for(not_from_union, Profile) :-
    affirming_statement(Affirmed),
    Profile = [attribute(transfer_from_union, false), attribute(recipient_is_organisation_in_united_states, true), attribute(data_privacy_framework_decision_in_force, Affirmed), attribute(recipient_on_data_privacy_framework_list, Affirmed), attribute(certification_covers_transferred_data, Affirmed)].
gdpr_transfer_dpf_profile_for(recipient_outside_united_states, Profile) :-
    affirming_statement(Affirmed),
    Profile = [attribute(transfer_from_union, true), attribute(recipient_is_organisation_in_united_states, false), attribute(data_privacy_framework_decision_in_force, Affirmed), attribute(recipient_on_data_privacy_framework_list, Affirmed), attribute(certification_covers_transferred_data, Affirmed)].
gdpr_transfer_dpf_profile_for(decision_not_in_force, Profile) :-
    affirming_statement(Affirmed),
    denying_statement(Denied),
    Profile = [attribute(transfer_from_union, true), attribute(recipient_is_organisation_in_united_states, true), attribute(data_privacy_framework_decision_in_force, Denied), attribute(recipient_on_data_privacy_framework_list, Affirmed), attribute(certification_covers_transferred_data, Affirmed)].
gdpr_transfer_dpf_profile_for(recipient_off_list, Profile) :-
    affirming_statement(Affirmed),
    denying_statement(Denied),
    Profile = [attribute(transfer_from_union, true), attribute(recipient_is_organisation_in_united_states, true), attribute(data_privacy_framework_decision_in_force, Affirmed), attribute(recipient_on_data_privacy_framework_list, Denied), attribute(certification_covers_transferred_data, Affirmed)].
gdpr_transfer_dpf_profile_for(human_resources_data_not_declared, Profile) :-
    affirming_statement(Affirmed),
    denying_statement(Denied),
    Profile = [attribute(transfer_from_union, true), attribute(recipient_is_organisation_in_united_states, true), attribute(data_privacy_framework_decision_in_force, Affirmed), attribute(recipient_on_data_privacy_framework_list, Affirmed), attribute(certification_covers_transferred_data, Denied)].
gdpr_transfer_dpf_profile_for(two_facts_denied, Profile) :-
    affirming_statement(Affirmed),
    denying_statement(Denied),
    Profile = [attribute(transfer_from_union, true), attribute(recipient_is_organisation_in_united_states, true), attribute(data_privacy_framework_decision_in_force, Denied), attribute(recipient_on_data_privacy_framework_list, Affirmed), attribute(certification_covers_transferred_data, Denied)].
gdpr_transfer_dpf_profile_for(crisp_false_with_facts_absent, Profile) :-
    Profile = [attribute(transfer_from_union, false)].
gdpr_transfer_dpf_profile_for(decision_statement_absent, Profile) :-
    affirming_statement(Affirmed),
    Profile = [attribute(transfer_from_union, true), attribute(recipient_is_organisation_in_united_states, true), attribute(recipient_on_data_privacy_framework_list, Affirmed), attribute(certification_covers_transferred_data, Affirmed)].
gdpr_transfer_dpf_profile_for(list_statement_absent_union_absent, Profile) :-
    affirming_statement(Affirmed),
    Profile = [attribute(recipient_is_organisation_in_united_states, true), attribute(data_privacy_framework_decision_in_force, Affirmed), attribute(certification_covers_transferred_data, Affirmed)].
gdpr_transfer_dpf_profile_for(coverage_statement_absent, Profile) :-
    affirming_statement(Affirmed),
    Profile = [attribute(transfer_from_union, true), attribute(recipient_is_organisation_in_united_states, true), attribute(data_privacy_framework_decision_in_force, Affirmed), attribute(recipient_on_data_privacy_framework_list, Affirmed)].
gdpr_transfer_dpf_profile_for(union_absent, Profile) :-
    affirming_statement(Affirmed),
    Profile = [attribute(recipient_is_organisation_in_united_states, true), attribute(data_privacy_framework_decision_in_force, Affirmed), attribute(recipient_on_data_privacy_framework_list, Affirmed), attribute(certification_covers_transferred_data, Affirmed)].
gdpr_transfer_dpf_profile_for(recipient_absent, Profile) :-
    affirming_statement(Affirmed),
    Profile = [attribute(transfer_from_union, true), attribute(data_privacy_framework_decision_in_force, Affirmed), attribute(recipient_on_data_privacy_framework_list, Affirmed), attribute(certification_covers_transferred_data, Affirmed)].
gdpr_transfer_dpf_profile_for(bare_boolean_outside_fact, Profile) :-
    affirming_statement(Affirmed),
    Profile = [attribute(transfer_from_union, true), attribute(recipient_is_organisation_in_united_states, true), attribute(data_privacy_framework_decision_in_force, Affirmed), attribute(recipient_on_data_privacy_framework_list, true), attribute(certification_covers_transferred_data, Affirmed)].
gdpr_transfer_dpf_profile_for(duplicate_and_unknown, Profile) :-
    Profile = [attribute(colour, red), attribute(transfer_from_union, true), attribute(transfer_from_union, false), attribute(colour, blue)].
gdpr_transfer_dpf_profile_for(unbound_attestation_argument, Profile) :-
    affirming_statement(Affirmed),
    Profile = [attribute(transfer_from_union, true), attribute(recipient_is_organisation_in_united_states, true), attribute(data_privacy_framework_decision_in_force, Affirmed), attribute(recipient_on_data_privacy_framework_list, Affirmed), attribute(certification_covers_transferred_data, attested(true, attestation(host_user, _HostTime, stated_from_published_record, none)))].
gdpr_transfer_dpf_profile_for(partial_list_profile, Profile) :-
    Profile = [attribute(transfer_from_union, true)|_Remaining].

gdpr_transfer_dpf_assess(Subject, Result) :-
    gdpr_transfer_dpf_profile_for(Subject, Profile),
    decide_gdpr_transfer_dpf(Profile, Result).
