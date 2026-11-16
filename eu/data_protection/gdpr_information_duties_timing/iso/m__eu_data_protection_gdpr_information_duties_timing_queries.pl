% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_information_duties_timing_queries, [gdpr_information_duties_timing_profile_keys/1, gdpr_information_duties_timing_what_if/4, gdpr_information_duties_timing_obligation/2, indeterminate/1, needs_legal_review/2, open_textured/2, inputs_relied_on/1, provenance/2, input_problems/1, unknown_key/1, wrong_type/1, duplicate_key/1, attested/2, attestation/4, url/2, document/2]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_lists_extra, [is_list/1]).
:- use_module(m__eu_data_protection_gdpr_information_duties_timing_kernel, [gdpr_information_duties_timing_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_information_duties_timing_information_deadline_basis, [decide_information_deadline_basis/2, information_deadline/2]).
:- use_module(m__eu_data_protection_gdpr_information_duties_timing_information_timing_verdict, [information_timing_verdict/3]).

gdpr_information_duties_timing_profile_keys([personal_data_collected_from_data_subject, items_provided, items_data_subject_already_has, data_protection_officer_designated, processing_based_on_legitimate_interests, recipients_exist, transfer_intended, processing_based_on_consent, automated_decision_making_under_article_22, obtaining_date, provision_date, data_used_for_communication_with_data_subject, first_communication_date, disclosure_to_another_recipient_envisaged, first_disclosure_date, provided_within_reasonable_period, provision_impossible_or_disproportionate_effort, protective_measures_taken, obtaining_or_disclosure_laid_down_by_law, professional_secrecy_obligation_by_law, further_processing_for_another_purpose_intended, further_processing_start_date, further_processing_information_date, further_processing_items_provided, paragraph_2_information_relevant_to_further_processing, public_holidays]).

gdpr_information_duties_timing_what_if(Profile, _, _, input_problems([wrong_type(profile)])) :-
    gdpr_information_duties_timing_input_problems(Profile, [wrong_type(profile)]).
gdpr_information_duties_timing_what_if(Profile, OverriddenKey, NewValue, NewVerdict) :-
    gdpr_information_duties_timing_input_problems(Profile, Problems),
    dif(Problems, [wrong_type(profile)]),
    profile_with_value(Profile, OverriddenKey, NewValue, Hypothesis),
    information_timing_verdict(Hypothesis, NewVerdict, _Citations).

profile_with_value(Profile, OverriddenKey, NewValue, Changed) :-
    entries_without_key(Profile, OverriddenKey, RemainingEntries),
    append(RemainingEntries, [attribute(OverriddenKey, NewValue)], Changed).

entries_without_key([], _, []).
entries_without_key([attribute(EntryKey, EntryValue)|Entries], OverriddenKey, [attribute(EntryKey, EntryValue)|RemainingEntries]) :-
    EntryKey \== OverriddenKey,
    entries_without_key(Entries, OverriddenKey, RemainingEntries).
entries_without_key([attribute(EntryKey, _)|Entries], OverriddenKey, RemainingEntries) :-
    EntryKey == OverriddenKey,
    entries_without_key(Entries, OverriddenKey, RemainingEntries).

gdpr_information_duties_timing_obligation(Profile, Obligation) :-
    decide_information_deadline_basis(Profile, information_deadline_basis_verdict(Status, Citations)),
    information_deadline(Profile, Deadline),
    obligation_term(Status, Deadline, Citations, Obligation).

final_basis(art13_1).
final_basis(art14_3_a).
final_basis(art14_3_b).
final_basis(art14_3_c).

obligation_term(Basis, Deadline, Citations, obligation(provide_information, by(Deadline), Basis, Citations)) :-
    final_basis(Basis).
obligation_term(indeterminate(MissingKeys), _, [], indeterminate(MissingKeys)).
obligation_term(input_problems(Problems), _, [], input_problems(Problems)).

indeterminate(MissingKeys) :-
    is_list(MissingKeys).

needs_legal_review(Reason, Context) :-
    compound(Reason),
    is_list(Context).

open_textured(Input, cite(CitationKey)) :-
    atom(Input),
    atom(CitationKey).

inputs_relied_on(Pairs) :-
    is_list(Pairs).

provenance(DecidingClause, Citations) :-
    atom(DecidingClause),
    is_list(Citations).

input_problems(Problems) :-
    is_list(Problems).

unknown_key(ProfileKey) :-
    ground(ProfileKey).

wrong_type(ProfileKey) :-
    atom(ProfileKey).

duplicate_key(ProfileKey) :-
    atom(ProfileKey).

attested(AttestedValue, attestation(Attestor, AttestedMoment, Reason, Evidence)) :-
    ground(AttestedValue),
    attestation(Attestor, AttestedMoment, Reason, Evidence).

attestation(Attestor, AttestedMoment, Reason, Evidence) :-
    ground(Attestor),
    ground(AttestedMoment),
    ground(Reason),
    evidence_form(Evidence).

evidence_form(none).
evidence_form(url(Address, RetrievedMoment)) :-
    url(Address, RetrievedMoment).
evidence_form(document(UploadIdentifier, ContentHash)) :-
    document(UploadIdentifier, ContentHash).

url(Address, RetrievedMoment) :-
    ground(Address),
    ground(RetrievedMoment).

document(UploadIdentifier, ContentHash) :-
    ground(UploadIdentifier),
    ground(ContentHash).

test(what_if_an_earlier_provision_is_timely) :-
    gdpr_information_duties_timing_what_if([attribute(personal_data_collected_from_data_subject, true), attribute(obtaining_date, date(2026, 3, 10)), attribute(provision_date, date(2026, 3, 11))], provision_date, date(2026, 3, 10), timely).
test(what_if_a_later_provision_is_late) :-
    gdpr_information_duties_timing_what_if([attribute(personal_data_collected_from_data_subject, true), attribute(obtaining_date, date(2026, 3, 10)), attribute(provision_date, date(2026, 3, 10))], provision_date, date(2026, 3, 11), late).
test(what_if_adds_an_absent_key) :-
    findall(Verdict, gdpr_information_duties_timing_what_if([attribute(personal_data_collected_from_data_subject, true), attribute(obtaining_date, date(2026, 3, 10))], provision_date, date(2026, 3, 9), Verdict), Verdicts),
    Verdicts == [timely].
test(what_if_on_a_non_list_profile) :-
    gdpr_information_duties_timing_what_if(profile, provision_date, date(2026, 3, 9), input_problems([wrong_type(profile)])).
test(obligation_on_the_article_14_route) :-
    gdpr_information_duties_timing_obligation([attribute(personal_data_collected_from_data_subject, false), attribute(obtaining_date, date(2026, 1, 15)), attribute(data_used_for_communication_with_data_subject, false), attribute(disclosure_to_another_recipient_envisaged, false)], obligation(provide_information, by(date(2026, 2, 16)), art14_3_a, [cite(eu_reg_2016_679_art_14_3_a)])).
test(obligation_while_keys_are_absent) :-
    findall(Obligation, gdpr_information_duties_timing_obligation([], Obligation), Obligations),
    Obligations == [indeterminate([personal_data_collected_from_data_subject, obtaining_date])].
test(a_result_constructor_accepts_its_shape) :-
    indeterminate([obtaining_date]).

test(what_if_a_later_provision_is_not_timely, fail) :-
    gdpr_information_duties_timing_what_if([attribute(personal_data_collected_from_data_subject, true), attribute(obtaining_date, date(2026, 3, 10)), attribute(provision_date, date(2026, 3, 10))], provision_date, date(2026, 3, 11), timely).
test(a_result_constructor_rejects_another_shape, fail) :-
    indeterminate(obtaining_date).
