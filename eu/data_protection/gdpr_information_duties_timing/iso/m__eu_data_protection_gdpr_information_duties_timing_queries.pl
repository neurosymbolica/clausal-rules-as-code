% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_information_duties_timing_queries, [information_deadline/2, information_deadline_basis/2, information_timing_verdict/3, gdpr_information_duties_timing_profile_keys/1, gdpr_information_duties_timing_what_if/4, gdpr_information_duties_timing_compliance_check/3, gdpr_information_duties_timing_obligation/2, input_problems/1, unknown_key/1, wrong_type/1, duplicate_key/1, indeterminate/1, needs_legal_review/2, open_textured/2, cross_reference_unresolved/2, resolution/2, inputs_relied_on/1, provenance/2, attested/2, attestation/4, url/2, document/2]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_lists_extra, [clausal_is_list/1]).
:- use_module(library(reif), [memberd_t/3]).
:- use_module(m__eu_data_protection_gdpr_information_duties_timing_kernel, [gdpr_information_duties_timing_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_information_duties_timing_information_deadline_basis, [decide_information_deadline/2, decide_information_deadline_basis/2, information_deadline_basis_status/2]).
:- use_module(m__eu_data_protection_gdpr_information_duties_timing_information_timing_verdict, [decide_information_timing_verdict/2, information_timing_verdict_status/2]).

information_deadline(Profile, Deadline) :-
    decide_information_deadline(Profile, Deadline).

information_deadline_basis(Profile, Basis) :-
    information_deadline_basis_status(Profile, Basis).

information_timing_verdict(Profile, Verdict, Citations) :-
    decide_information_timing_verdict(Profile, information_timing_verdict_verdict(Verdict, Citations)).

gdpr_information_duties_timing_profile_keys([personal_data_collected_from_data_subject, items_provided, items_data_subject_already_has, data_protection_officer_designated, processing_based_on_legitimate_interests, recipients_exist, transfer_intended, processing_based_on_consent, automated_decision_making_under_article_22, obtaining_date, provision_date, data_used_for_communication_with_data_subject, first_communication_date, disclosure_to_another_recipient_envisaged, first_disclosure_date, provided_within_reasonable_period, provision_impossible_or_disproportionate_effort, protective_measures_taken, obtaining_or_disclosure_laid_down_by_law, professional_secrecy_obligation_by_law, further_processing_for_another_purpose_intended, further_processing_start_date, further_processing_information_date, further_processing_items_provided, paragraph_2_information_relevant_to_further_processing, public_holidays]).

profile_with_value([], Key, Value, [attribute(Key, Value)]).
profile_with_value([attribute(ElementKey, ElementValue)|Elements], Key, Value, [attribute(ElementKey, ElementValue)|Rest]) :-
    dif(ElementKey, Key),
    profile_with_value(Elements, Key, Value, Rest).
profile_with_value([attribute(Key, _)|Elements], Key, Value, Rest) :-
    profile_with_value(Elements, Key, Value, Rest).
profile_with_value([Element|Elements], Key, Value, [Element|Rest]) :-
    nonvar(Element),
    Element \= attribute(_, _),
    profile_with_value(Elements, Key, Value, Rest).
profile_with_value(Profile, _, _, Profile) :-
    nonvar(Profile),
    Profile \= [],
    Profile \= [_|_].

gdpr_information_duties_timing_what_if(Profile, OverriddenKey, NewValue, NewVerdict) :-
    profile_with_value(Profile, OverriddenKey, NewValue, Hypothesis),
    information_timing_verdict_status(Hypothesis, NewVerdict).

gdpr_information_duties_timing_compliance_check(Profile, ProposedProvisionDate, Verdict) :-
    profile_with_value(Profile, provision_date, ProposedProvisionDate, Proposal),
    information_timing_verdict_status(Proposal, Verdict).

gdpr_information_duties_timing_obligation(Profile, Obligation) :-
    decide_information_deadline(Profile, Deadline),
    decide_information_deadline_basis(Profile, information_deadline_basis_verdict(Basis, Citations)),
    deadline_kind(Deadline, DeadlineKind),
    basis_kind(Basis, BasisKind),
    obligation_answer(DeadlineKind, BasisKind, Deadline, Basis, Citations, Obligation).

obligation_answer(final, final, Deadline, Basis, Citations, obligation(provide_information, by(Deadline), basis(Basis), consequence(late), Citations)).
obligation_answer(pending, _, Deadline, _, _, Deadline).
obligation_answer(final, pending, _, Basis, _, Basis).

deadline_kind(date(_, _, _), final).
deadline_kind(Deadline, pending) :-
    Deadline \= date(_, _, _).

basis_kind(Basis, Kind) :-
    memberd_t(Basis, [art13_1, art14_3_a, art14_3_b, art14_3_c], IsFinal),
    final_kind(IsFinal, Kind).

final_kind(true, final).
final_kind(false, pending).

input_problems([Problem|Problems]) :-
    clausal_is_list([Problem|Problems]).

unknown_key(Key) :-
    ground(Key).

wrong_type(Key) :-
    atom(Key).

duplicate_key(Key) :-
    atom(Key).

indeterminate([MissingKey|MissingKeys]) :-
    clausal_is_list([MissingKey|MissingKeys]).

needs_legal_review(Reason, Context) :-
    compound(Reason),
    clausal_is_list(Context).

open_textured(Input, cite(Citation)) :-
    atom(Input),
    atom(Citation).

cross_reference_unresolved(cite(Citation), cite(Target)) :-
    atom(Citation),
    atom(Target).

resolution(cite(Target), Status) :-
    atom(Target),
    atom(Status).

inputs_relied_on(Pairs) :-
    clausal_is_list(Pairs).

provenance(Clause, Citations) :-
    ground(Clause),
    clausal_is_list(Citations).

attested(Value, attestation(AttestedBy, AttestedAt, Reason, Evidence)) :-
    ground(Value),
    ground(AttestedBy),
    ground(AttestedAt),
    ground(Reason),
    ground(Evidence).

attestation(AttestedBy, AttestedAt, Reason, Evidence) :-
    ground(AttestedBy),
    ground(AttestedAt),
    ground(Reason),
    ground(Evidence).

url(Address, RetrievedAt) :-
    atomic(Address),
    ground(RetrievedAt).

document(UploadIdentifier, Sha256Digest) :-
    ground(UploadIdentifier),
    atomic(Sha256Digest).

test(the_deadline_relation_gives_one_date) :-
    findall(Deadline, information_deadline([attribute(personal_data_collected_from_data_subject, true), attribute(obtaining_date, date(2026, 3, 10))], Deadline), Deadlines),
    Deadlines == [date(2026, 3, 10)].
test(the_verdict_relation_gives_one_answer) :-
    findall(Verdict - Citations, information_timing_verdict([attribute(personal_data_collected_from_data_subject, true), attribute(obtaining_date, date(2026, 3, 10)), attribute(provision_date, date(2026, 3, 10))], Verdict, Citations), Answers),
    Answers == [timely - [cite(eu_reg_2016_679_art_13_1)]].
test(a_replaced_key_is_given_once) :-
    profile_with_value([attribute(provision_date, date(2026, 3, 10)), attribute(obtaining_date, date(2026, 3, 10))], provision_date, date(2026, 3, 11), Hypothesis),
    Hypothesis == [attribute(obtaining_date, date(2026, 3, 10)), attribute(provision_date, date(2026, 3, 11))].
test(the_compliance_check_refuses_a_late_date) :-
    gdpr_information_duties_timing_compliance_check([attribute(personal_data_collected_from_data_subject, true), attribute(obtaining_date, date(2026, 3, 10))], date(2026, 3, 11), late).
test(the_compliance_check_allows_the_obtaining_day) :-
    gdpr_information_duties_timing_compliance_check([attribute(personal_data_collected_from_data_subject, true), attribute(obtaining_date, date(2026, 3, 10))], date(2026, 3, 10), timely).
test(the_obligation_names_its_deadline_and_basis) :-
    findall(Obligation, gdpr_information_duties_timing_obligation([attribute(personal_data_collected_from_data_subject, true), attribute(obtaining_date, date(2026, 3, 10))], Obligation), Obligations),
    Obligations == [obligation(provide_information, by(date(2026, 3, 10)), basis(art13_1), consequence(late), [cite(eu_reg_2016_679_art_13_1)])].
test(the_obligation_with_the_route_unknown_is_indeterminate) :-
    gdpr_information_duties_timing_obligation([], indeterminate([personal_data_collected_from_data_subject, obtaining_date])).
