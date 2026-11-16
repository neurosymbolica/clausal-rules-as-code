% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_common_definitions_roles_and_establishments_tests_test_result_terms, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_common_definitions_roles_and_establishments_kernel, [gdpr_common_definitions_roles_and_establishments_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_common_definitions_roles_and_establishments_gdpr_common_definitions_roles_and_establishments, [roles_and_establishments_outside_facts/2, enterprise/2]).

test(duplicate_key_is_named_for_a_repeated_key) :-
    gdpr_common_definitions_roles_and_establishments_input_problems([attribute(party_role, controller), attribute(party_role, processor)], Problems),
    Problems == [duplicate_key(party_role)].
test(duplicate_key_with_equal_values_is_still_named) :-
    gdpr_common_definitions_roles_and_establishments_input_problems([attribute(complaint_lodged_with_authority, true), attribute(complaint_lodged_with_authority, true)], Problems),
    Problems == [duplicate_key(complaint_lodged_with_authority)].
test(duplicate_key_reaches_every_relation) :-
    enterprise([attribute(entity_engaged_in_economic_activity, true), attribute(entity_engaged_in_economic_activity, false)], Answer),
    Answer == definition_answer(input_problems([duplicate_key(entity_engaged_in_economic_activity)]), none, []).
test(a_single_key_is_not_a_duplicate) :-
    gdpr_common_definitions_roles_and_establishments_input_problems([attribute(party_role, controller)], Problems),
    Problems == [].
test(url_evidence_is_accepted_and_copied) :-
    Attested = attested(true, attestation(host_layer, attested_2026_11_07, operator_ruling, url('https://example.org/law', retrieved_2026_11_07))),
    roles_and_establishments_outside_facts([attribute(party_provided_for_as_controller_by_law, Attested)], Facts),
    Facts == [outside_fact(party_provided_for_as_controller_by_law, Attested)],
    Attested = attested(_, attestation(_, _, _, Evidence)),
    Evidence = url(Address, RetrievedAt),
    Address == 'https://example.org/law',
    RetrievedAt == retrieved_2026_11_07.
test(document_evidence_is_accepted_and_copied) :-
    Attested = attested(false, attestation(host_layer, attested_2026_11_07, operator_ruling, document(upload_one, sha_digest_one))),
    roles_and_establishments_outside_facts([attribute(party_provided_for_as_controller_by_law, Attested)], Facts),
    Facts == [outside_fact(party_provided_for_as_controller_by_law, Attested)],
    Attested = attested(_, attestation(_, _, _, Evidence)),
    Evidence = document(UploadId, Digest),
    UploadId == upload_one,
    Digest == sha_digest_one.
test(evidence_none_is_accepted) :-
    Attested = attested(true, attestation(host_layer, attested_2026_11_07, operator_ruling, none)),
    roles_and_establishments_outside_facts([attribute(party_provided_for_as_controller_by_law, Attested)], [outside_fact(party_provided_for_as_controller_by_law, Attested)]).
test(provenance_term_builds_and_destructures) :-
    Context = [inputs_relied_on([party_determines_purposes_and_means - unsure]), provenance(clause_one, [cite(eu_reg_2016_679_art_4_7)])],
    Context = [_Relied, provenance(Clause, Citations)],
    Clause == clause_one,
    Citations == [cite(eu_reg_2016_679_art_4_7)].
test(provenance_differs_from_inputs_relied_on) :-
    dif(provenance(clause_one, []), inputs_relied_on([])).

cp_test_names([duplicate_key_is_named_for_a_repeated_key, duplicate_key_with_equal_values_is_still_named, duplicate_key_reaches_every_relation, a_single_key_is_not_a_duplicate, url_evidence_is_accepted_and_copied, document_evidence_is_accepted_and_copied, evidence_none_is_accepted, provenance_term_builds_and_destructures, provenance_differs_from_inputs_relied_on]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
