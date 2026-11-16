% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_common_definitions_data_and_processing_tests_test_result_constructors, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).

test(provenance_marks_the_deciding_clause) :-
    Context = [inputs_relied_on([indication_specific - false]), provenance(consent_elements, [cite(eu_reg_2016_679_art_4_11)])],
    Context = [_, provenance(Clause, Citations)],
    Clause == consent_elements,
    Citations == [cite(eu_reg_2016_679_art_4_11)].
test(provenance_may_follow_the_inputs_relied_on) :-
    Context = [resolution(cite(eu_dir_2015_1535_art_1_1_b), not_attempted), inputs_relied_on([]), provenance(information_society_service, [cite(eu_reg_2016_679_art_4_25)])],
    Context = [_, _, Provenance],
    Provenance = provenance(information_society_service, _).
test(url_evidence_carries_address_and_retrieval_time) :-
    Evidence = url('https://example.org/directive', retrieved_at_fixture_clock),
    Evidence = url(Address, RetrievedAt),
    Address == 'https://example.org/directive',
    RetrievedAt == retrieved_at_fixture_clock.
test(document_evidence_carries_upload_and_digest) :-
    Evidence = document(upload_one, digest_fixture),
    Evidence = document(UploadIdentifier, Digest),
    UploadIdentifier == upload_one,
    Digest == digest_fixture.
test(an_attestation_takes_url_evidence) :-
    Attested = attested(true, attestation(fixture_host, fixture_clock, fixture_reason, url('https://example.org/x', fixture_clock))),
    Attested = attested(Value, attestation(_, _, _, Evidence)),
    Value == true,
    Evidence = url(_, _).
test(an_attestation_takes_document_evidence) :-
    Attested = attested(false, attestation(fixture_host, fixture_clock, fixture_reason, document(upload_two, digest_two))),
    Attested = attested(Value, attestation(_, _, _, Evidence)),
    Value == false,
    Evidence = document(upload_two, digest_two).
test(an_attestation_takes_no_evidence) :-
    Attested = attested(true, attestation(fixture_host, fixture_clock, fixture_reason, none)),
    Attested = attested(_, attestation(_, _, _, Evidence)),
    Evidence == none.

test(provenance_with_a_different_clause_is_a_different_term, fail) :-
    provenance(consent_elements, [cite(eu_reg_2016_679_art_4_11)]) = provenance(personal_data, [cite(eu_reg_2016_679_art_4_11)]).
test(url_and_document_are_distinct_evidence_kinds, fail) :-
    url(a, b) = document(a, b).

cp_test_names([provenance_marks_the_deciding_clause, provenance_may_follow_the_inputs_relied_on, url_evidence_carries_address_and_retrieval_time, document_evidence_carries_upload_and_digest, an_attestation_takes_url_evidence, an_attestation_takes_document_evidence, an_attestation_takes_no_evidence]).
cp_test_fail_names([provenance_with_a_different_clause_is_a_different_term, url_and_document_are_distinct_evidence_kinds]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
