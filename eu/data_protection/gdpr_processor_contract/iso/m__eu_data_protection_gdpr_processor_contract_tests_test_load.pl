% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_processor_contract_tests_test_load, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_processor_contract_kernel, [gdpr_processor_contract_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_processor_contract_citations, [citation/2, implements/1]).

test(an_empty_profile_has_no_input_problem) :-
    gdpr_processor_contract_input_problems([], []).
test(a_non_list_profile_is_a_wrong_type) :-
    gdpr_processor_contract_input_problems(not_a_profile, [wrong_type(profile)]).
test(an_unknown_key_is_named) :-
    gdpr_processor_contract_input_problems([attribute(bogus_key, true)], [unknown_key(bogus_key)]).
test(a_duplicate_key_is_named_once) :-
    gdpr_processor_contract_input_problems([attribute(contract_in_writing, true), attribute(contract_in_writing, false)], Problems),
    Problems == [duplicate_key(contract_in_writing)].
test(the_duplicate_key_term_builds_and_destructures) :-
    Problem = duplicate_key(contract_in_writing),
    Problem = duplicate_key(Key),
    Key == contract_in_writing.
test(the_verdict_atoms_are_distinct) :-
    dif(eligible, ineligible),
    dif(ineligible, not_applicable).
test(the_verdict_term_builds_and_destructures) :-
    Verdict = processor_contract_verdict(eligible, [], [cite(eu_reg_2016_679_art_28_3)]),
    Verdict = processor_contract_verdict(Status, Missing, Citations),
    Status == eligible,
    Missing == [],
    Citations == [cite(eu_reg_2016_679_art_28_3)].
test(the_provenance_term_builds_and_destructures) :-
    Context = provenance(stipulates_information_and_audit_rights, [cite(eu_reg_2016_679_art_28_3_h)]),
    Context = provenance(Clause, Citations),
    Clause == stipulates_information_and_audit_rights,
    Citations == [cite(eu_reg_2016_679_art_28_3_h)].
test(the_provenance_term_sits_in_a_context_list) :-
    Context = [inputs_relied_on([standard_clauses_adopted - absent]), provenance(gate, [cite(eu_reg_2016_679_art_28_10)])],
    Context = [_, provenance(gate, [cite(eu_reg_2016_679_art_28_10)])].
test(the_url_evidence_term_builds_and_destructures) :-
    Evidence = url('https://eur-lex.europa.eu/eli/reg/2016/679/oj', retrieved_at_review),
    Evidence = url(Address, RetrievedAt),
    Address == 'https://eur-lex.europa.eu/eli/reg/2016/679/oj',
    RetrievedAt == retrieved_at_review.
test(the_document_evidence_term_builds_and_destructures) :-
    Evidence = document(upload_one, digest_one),
    Evidence = document(UploadIdentifier, Digest),
    UploadIdentifier == upload_one,
    Digest == digest_one.
test(an_attested_value_carries_url_evidence) :-
    Fact = attested(true, attestation(decision_layer, recorded_at_review, user_confirmed, url(address_one, retrieved_one))),
    Fact = attested(Value, attestation(_, _, _, url(_, _))),
    Value == true.
test(an_attested_value_carries_document_evidence) :-
    Fact = attested(false, attestation(decision_layer, recorded_at_review, user_confirmed, document(upload_one, digest_one))),
    Fact = attested(Value, attestation(_, _, _, document(_, _))),
    Value == false.
test(a_real_citation_is_recorded) :-
    citation(eu_reg_2016_679_art_28_3_h, _Record).
test(implements_accepts_a_recorded_key) :-
    implements(eu_reg_2016_679_art_28_10).

test(a_single_key_is_not_a_duplicate, fail) :-
    gdpr_processor_contract_input_problems([attribute(contract_in_writing, true)], [duplicate_key(contract_in_writing)]).
test(implements_rejects_an_unrecorded_key, fail) :-
    implements(eu_reg_2016_679_art_99).

cp_test_names([an_empty_profile_has_no_input_problem, a_non_list_profile_is_a_wrong_type, an_unknown_key_is_named, a_duplicate_key_is_named_once, the_duplicate_key_term_builds_and_destructures, the_verdict_atoms_are_distinct, the_verdict_term_builds_and_destructures, the_provenance_term_builds_and_destructures, the_provenance_term_sits_in_a_context_list, the_url_evidence_term_builds_and_destructures, the_document_evidence_term_builds_and_destructures, an_attested_value_carries_url_evidence, an_attested_value_carries_document_evidence, a_real_citation_is_recorded, implements_accepts_a_recorded_key]).
cp_test_fail_names([a_single_key_is_not_a_duplicate, implements_rejects_an_unrecorded_key]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
