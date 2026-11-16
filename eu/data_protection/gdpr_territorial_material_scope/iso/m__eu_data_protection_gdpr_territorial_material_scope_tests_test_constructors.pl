% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_territorial_material_scope_tests_test_constructors, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_territorial_material_scope_kernel, [gdpr_territorial_material_scope_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_territorial_material_scope_gdpr_applies, [scope_outside_facts/2]).

test(provenance_builds_and_destructures) :-
    Term = provenance(deciding_clause, [cite(eu_reg_2016_679_art_3_1)]),
    Term = provenance(Clause, Citations),
    Clause == deciding_clause,
    Citations == [cite(eu_reg_2016_679_art_3_1)].
test(provenance_can_close_an_inputs_relied_on_list) :-
    Context = [inputs_relied_on([occasional_processing - unsure, provenance(deciding_clause, [cite(eu_reg_2016_679_art_27_2_a)])])],
    Context = [inputs_relied_on([_Pair, provenance(_Clause, [cite(eu_reg_2016_679_art_27_2_a)])])].
test(url_evidence_is_copied_as_given) :-
    Evidence = url('https://example.org/register', retrieved_at_time),
    Profile = [attribute(member_state_law_applies_by_public_international_law, attested(true, attestation(decision_layer, at_time, reason_text, Evidence)))],
    scope_outside_facts(Profile, Facts),
    Facts == [outside_fact(member_state_law_applies_by_public_international_law, attested(true, attestation(decision_layer, at_time, reason_text, url('https://example.org/register', retrieved_at_time))))].
test(document_evidence_is_copied_as_given) :-
    Evidence = document(upload_one, digest_one),
    Profile = [attribute(member_state_law_applies_by_public_international_law, attested(false, attestation(decision_layer, at_time, reason_text, Evidence)))],
    scope_outside_facts(Profile, Facts),
    Facts == [outside_fact(member_state_law_applies_by_public_international_law, attested(false, attestation(decision_layer, at_time, reason_text, document(upload_one, digest_one))))].
test(url_and_document_evidence_pass_the_input_check) :-
    ProfileUrl = [attribute(member_state_law_applies_by_public_international_law, attested(true, attestation(by, at, reason, url(address, retrieved))))],
    ProfileDocument = [attribute(member_state_law_applies_by_public_international_law, attested(true, attestation(by, at, reason, document(upload, digest))))],
    gdpr_territorial_material_scope_input_problems(ProfileUrl, []),
    gdpr_territorial_material_scope_input_problems(ProfileDocument, []).
test(a_repeated_key_is_a_duplicate_key_problem) :-
    Profile = [attribute(established_in_union, true), attribute(established_in_union, false)],
    findall(Problems, gdpr_territorial_material_scope_input_problems(Profile, Problems), Answers),
    Answers == [[duplicate_key(established_in_union)]].
test(a_repeated_key_with_equal_values_is_still_a_duplicate_key) :-
    Profile = [attribute(party_role, controller), attribute(party_role, controller)],
    findall(Problems, gdpr_territorial_material_scope_input_problems(Profile, Problems), Answers),
    Answers == [[duplicate_key(party_role)]].

test(a_single_key_is_not_a_duplicate_key, fail) :-
    gdpr_territorial_material_scope_input_problems([attribute(party_role, controller)], [duplicate_key(party_role)]).

cp_test_names([provenance_builds_and_destructures, provenance_can_close_an_inputs_relied_on_list, url_evidence_is_copied_as_given, document_evidence_is_copied_as_given, url_and_document_evidence_pass_the_input_check, a_repeated_key_is_a_duplicate_key_problem, a_repeated_key_with_equal_values_is_still_a_duplicate_key]).
cp_test_fail_names([a_single_key_is_not_a_duplicate_key]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
