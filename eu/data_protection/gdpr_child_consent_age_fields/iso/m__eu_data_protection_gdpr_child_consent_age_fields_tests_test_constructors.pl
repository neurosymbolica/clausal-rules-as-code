% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_child_consent_age_fields_tests_test_constructors, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_child_consent_age_fields_kernel, [gdpr_child_consent_age_fields_input_problems/2]).

test(provenance_builds_and_destructures) :-
    Item = provenance(national_age_stage, [cite(eu_reg_2016_679_art_8_1_second_subpara)]),
    Item = provenance(Clause, Citations),
    Clause == national_age_stage,
    Citations == [cite(eu_reg_2016_679_art_8_1_second_subpara)].
test(provenance_follows_inputs_relied_on_in_a_context) :-
    Context = [inputs_relied_on([child_age_years - 14]), provenance(national_age_stage, [cite(eu_reg_2016_679_art_8_1_second_subpara)])],
    Context = [inputs_relied_on(Pairs), provenance(_Clause, _Citations)],
    Pairs == [child_age_years - 14].
test(url_builds_and_destructures) :-
    Evidence = url('https://example.org/act', date(2026, 11, 9)),
    Evidence = url(Address, RetrievedAt),
    Address == 'https://example.org/act',
    RetrievedAt == date(2026, 11, 9).
test(document_builds_and_destructures) :-
    Evidence = document(upload_one, sha_one),
    Evidence = document(UploadId, Sha),
    UploadId == upload_one,
    Sha == sha_one.
test(an_attested_age_with_url_evidence_is_no_problem) :-
    gdpr_child_consent_age_fields_input_problems([attribute(member_state_digital_consent_age, attested(national_digital_consent_age(france, 15, national_act(some_act, article_one)), attestation(decision_layer, date(2026, 11, 9), user_declared, url('https://example.org/act', date(2026, 11, 9)))))], []).
test(an_attested_age_with_document_evidence_is_no_problem) :-
    gdpr_child_consent_age_fields_input_problems([attribute(member_state_digital_consent_age, attested(national_digital_consent_age(france, 15, national_act(some_act, article_one)), attestation(decision_layer, date(2026, 11, 9), user_declared, document(upload_one, sha_one))))], []).

test(provenance_with_a_different_clause_is_a_different_term, fail) :-
    provenance(engagement, []) = provenance(national_age_stage, []).
test(url_and_document_are_different_terms, fail) :-
    url(a, b) = document(a, b).

cp_test_names([provenance_builds_and_destructures, provenance_follows_inputs_relied_on_in_a_context, url_builds_and_destructures, document_builds_and_destructures, an_attested_age_with_url_evidence_is_no_problem, an_attested_age_with_document_evidence_is_no_problem]).
cp_test_fail_names([provenance_with_a_different_clause_is_a_different_term, url_and_document_are_different_terms]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
