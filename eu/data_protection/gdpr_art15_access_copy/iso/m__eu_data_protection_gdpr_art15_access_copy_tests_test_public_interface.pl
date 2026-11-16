% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_art15_access_copy_tests_test_public_interface, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_art15_access_copy_gdpr_art15_access_copy, [access_answer_items/4, access_answer_items_missing/4, copy_scope/3, copy_fee/3, information_form/3]).
:- use_module(m__eu_data_protection_gdpr_art15_access_copy_kernel, [gdpr_art15_access_copy_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_art15_access_copy_fixtures, [gdpr_art15_access_copy_subject/1, gdpr_art15_access_copy_profile_for/2]).
:- use_module(m__eu_data_protection_gdpr_art15_access_copy_queries, [confirmation_of_processing/0, no_personal_data_to_copy/0, no_fee_under_article_15_3/0, no_electronic_request/0]).

evidence_profile(AutomatedEvidence, SafeguardsEvidence, [attribute(items_provided, []), attribute(personal_data_concerning_data_subject_processed, true), attribute(disclosure_to_recipients_made_or_envisaged, false), attribute(some_personal_data_not_collected_from_data_subject, false), attribute(source_information_available, false), attribute(automated_decision_making_referred_to_in_article_22, attested(true, attestation(host, recorded_at, attested_by_caller, AutomatedEvidence))), attribute(transfer_to_third_country_or_international_organisation, true), attribute(transfer_subject_to_article_46_safeguards, attested(true, attestation(host, recorded_at, attested_by_caller, SafeguardsEvidence)))]).

answer_count(Subject, Count) :-
    gdpr_art15_access_copy_subject(Subject),
    gdpr_art15_access_copy_profile_for(Subject, Profile),
    findall(Answer, query_answer(Profile, Answer), Answers),
    length(Answers, Count).

query_answer(Profile, items(Result, Basis, Citations)) :-
    access_answer_items(Profile, Result, Basis, Citations).
query_answer(Profile, missing(Result, Basis, Citations)) :-
    access_answer_items_missing(Profile, Result, Basis, Citations).
query_answer(Profile, scope(Result, Citations)) :-
    copy_scope(Profile, Result, Citations).
query_answer(Profile, fee(Result, Citations)) :-
    copy_fee(Profile, Result, Citations).
query_answer(Profile, form(Result, Citations)) :-
    information_form(Profile, Result, Citations).

test(the_five_queries_answer_each_fixture_once_each) :-
    findall(Count, answer_count(_Subject, Count), Counts),
    Counts = [_|_],
    sort(Counts, [5]).
test(url_evidence_is_well_formed_and_copied_into_basis) :-
    Evidence = url(policy_page_address, retrieved_on_2026_11_15),
    evidence_profile(Evidence, none, Profile),
    gdpr_art15_access_copy_input_problems(Profile, []),
    access_answer_items(Profile, Result, Basis, _Citations),
    member(automated_decision_making_information, Result),
    Basis == [outside_fact(automated_decision_making_referred_to_in_article_22, attested(true, attestation(host, recorded_at, attested_by_caller, url(policy_page_address, retrieved_on_2026_11_15)))), outside_fact(transfer_subject_to_article_46_safeguards, attested(true, attestation(host, recorded_at, attested_by_caller, none)))].
test(document_evidence_is_well_formed_and_copied_into_basis) :-
    evidence_profile(none, document(upload_identifier_one, content_digest_one), Profile),
    gdpr_art15_access_copy_input_problems(Profile, []),
    access_answer_items(Profile, Result, Basis, _Citations),
    member(transfer_safeguards_information, Result),
    Basis == [outside_fact(automated_decision_making_referred_to_in_article_22, attested(true, attestation(host, recorded_at, attested_by_caller, none))), outside_fact(transfer_subject_to_article_46_safeguards, attested(true, attestation(host, recorded_at, attested_by_caller, document(upload_identifier_one, content_digest_one))))].
test(url_and_document_evidence_shown_in_missing_basis) :-
    evidence_profile(url(policy_page_address, retrieved_on_2026_11_15), document(upload_identifier_one, content_digest_one), Profile),
    access_answer_items_missing(Profile, [_|_], Basis, _Citations),
    Basis == [outside_fact(automated_decision_making_referred_to_in_article_22, attested(true, attestation(host, recorded_at, attested_by_caller, url(policy_page_address, retrieved_on_2026_11_15)))), outside_fact(transfer_subject_to_article_46_safeguards, attested(true, attestation(host, recorded_at, attested_by_caller, document(upload_identifier_one, content_digest_one))))].
test(evidence_with_three_attestation_arguments_is_wrong_type) :-
    Profile = [attribute(automated_decision_making_referred_to_in_article_22, attested(true, attestation(host, recorded_at, url(policy_page_address, retrieved_on_2026_11_15))))],
    gdpr_art15_access_copy_input_problems(Profile, [wrong_type(automated_decision_making_referred_to_in_article_22)]).
test(the_root_atoms_resolve) :-
    confirmation_of_processing,
    no_personal_data_to_copy,
    no_fee_under_article_15_3,
    no_electronic_request.

test(evidence_with_three_attestation_arguments_is_not_accepted, fail) :-
    Profile = [attribute(automated_decision_making_referred_to_in_article_22, attested(true, attestation(host, recorded_at, url(policy_page_address, retrieved_on_2026_11_15))))],
    gdpr_art15_access_copy_input_problems(Profile, []).

cp_test_names([the_five_queries_answer_each_fixture_once_each, url_evidence_is_well_formed_and_copied_into_basis, document_evidence_is_well_formed_and_copied_into_basis, url_and_document_evidence_shown_in_missing_basis, evidence_with_three_attestation_arguments_is_wrong_type, the_root_atoms_resolve]).
cp_test_fail_names([evidence_with_three_attestation_arguments_is_not_accepted]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
