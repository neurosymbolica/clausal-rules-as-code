% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_child_consent_age_verdict_tests_test_constructors, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_child_consent_age_verdict_kernel, [gdpr_child_consent_age_verdict_input_problems/2]).

test(provenance_builds_and_destructures) :-
    Term = provenance(deciding_clause, [cite(eu_reg_2016_679_art_8_1)]),
    Term = provenance(Clause, Citations),
    Clause == deciding_clause,
    Citations == [cite(eu_reg_2016_679_art_8_1)].
test(source_builds_and_destructures) :-
    Term = source(url('https://example.org/law', date(2026, 11, 1)), date(2026, 11, 1), sha_value),
    Term = source(Address, RetrievedAt, Checksum),
    Address = url(_, _),
    RetrievedAt == date(2026, 11, 1),
    Checksum == sha_value.
test(url_builds_and_destructures) :-
    Term = url('https://example.org/law', date(2026, 11, 1)),
    Term = url(Address, RetrievedAt),
    Address == 'https://example.org/law',
    RetrievedAt == date(2026, 11, 1).
test(document_builds_and_destructures) :-
    Term = document(upload_one, sha_value),
    Term = document(UploadId, Checksum),
    UploadId == upload_one,
    Checksum == sha_value.
test(fetched_builds_and_destructures) :-
    Term = fetched(national_digital_consent_age(austria, 14, national_provision(act, article)), source(url('https://example.org/law', date(2026, 11, 1)), date(2026, 11, 1), sha_value)),
    Term = fetched(Value, Source),
    Value = national_digital_consent_age(austria, 14, _),
    Source = source(_, _, _).
test(a_fetched_value_is_an_input_problem_while_no_fetcher_exists) :-
    gdpr_child_consent_age_verdict_input_problems([attribute(member_state_digital_consent_age, fetched(national_digital_consent_age(austria, 14, national_provision(act, article)), source(url('https://example.org/law', date(2026, 11, 1)), date(2026, 11, 1), sha_value)))], [wrong_type(member_state_digital_consent_age)]).
test(an_attested_value_with_url_evidence_has_no_problem) :-
    gdpr_child_consent_age_verdict_input_problems([attribute(member_state_digital_consent_age, attested(national_digital_consent_age(austria, 14, national_provision(act, article)), attestation(host, stamp, reason, url('https://example.org/law', date(2026, 11, 1)))))], []).
test(an_attested_value_with_document_evidence_has_no_problem) :-
    gdpr_child_consent_age_verdict_input_problems([attribute(member_state_digital_consent_age, attested(national_digital_consent_age(austria, 14, national_provision(act, article)), attestation(host, stamp, reason, document(upload_one, sha_value))))], []).
test(a_repeated_key_is_a_duplicate_key_problem) :-
    findall(Problems, gdpr_child_consent_age_verdict_input_problems([attribute(child_age_years, 12), attribute(child_age_years, 13)], Problems), Answers),
    Answers == [[duplicate_key(child_age_years)]].
test(a_repeated_key_with_equal_values_is_still_a_duplicate_key) :-
    gdpr_child_consent_age_verdict_input_problems([attribute(parental_consent_given, true), attribute(parental_consent_given, true)], [duplicate_key(parental_consent_given)]).
test(a_single_key_has_no_problem) :-
    gdpr_child_consent_age_verdict_input_problems([attribute(child_age_years, 12)], []).

test(provenance_is_not_a_bare_atom, fail) :-
    provenance = provenance(_, _).
test(a_single_key_is_not_a_duplicate_key, fail) :-
    gdpr_child_consent_age_verdict_input_problems([attribute(child_age_years, 12)], [duplicate_key(child_age_years)]).

cp_test_names([provenance_builds_and_destructures, source_builds_and_destructures, url_builds_and_destructures, document_builds_and_destructures, fetched_builds_and_destructures, a_fetched_value_is_an_input_problem_while_no_fetcher_exists, an_attested_value_with_url_evidence_has_no_problem, an_attested_value_with_document_evidence_has_no_problem, a_repeated_key_is_a_duplicate_key_problem, a_repeated_key_with_equal_values_is_still_a_duplicate_key, a_single_key_has_no_problem]).
cp_test_fail_names([provenance_is_not_a_bare_atom, a_single_key_is_not_a_duplicate_key]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
