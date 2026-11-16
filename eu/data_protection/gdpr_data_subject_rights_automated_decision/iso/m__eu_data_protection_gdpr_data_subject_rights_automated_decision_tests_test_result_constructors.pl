% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_data_subject_rights_automated_decision_tests_test_result_constructors, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_data_subject_rights_automated_decision_request_basis, [decide_data_subject_request/2, request_basis/2]).
:- use_module(m__eu_data_protection_gdpr_data_subject_rights_automated_decision_kernel, [gdpr_data_subject_rights_automated_decision_input_problems/2]).

engaged_with(Extra, [attribute(request_type, automated_decision), attribute(decision_based_solely_on_automated_processing, true), attribute(decision_produces_legal_or_similarly_significant_effects, true)|Extra]).

test(provenance_builds_and_destructures) :-
    Marker = provenance(engagement, [cite(eu_reg_2016_679_art_22_1)]),
    Marker = provenance(Clause, Citations),
    Clause == engagement,
    Citations == [cite(eu_reg_2016_679_art_22_1)].
test(provenance_rides_in_a_review_context) :-
    Context = [inputs_relied_on([request_type - automated_decision]), provenance(engagement, [cite(eu_reg_2016_679_art_22_1)])],
    Context = [inputs_relied_on(Pairs), provenance(_, _)],
    Pairs == [request_type - automated_decision].
test(duplicate_key_is_named_by_the_input_check) :-
    gdpr_data_subject_rights_automated_decision_input_problems([attribute(request_type, automated_decision), attribute(request_type, access)], [duplicate_key(request_type)]).
test(duplicate_key_gives_an_input_problem_verdict) :-
    findall(Verdict, decide_data_subject_request([attribute(request_type, automated_decision), attribute(request_type, access)], Verdict), Verdicts),
    Verdicts == [gdpr_data_subject_request_verdict(input_problems([duplicate_key(request_type)]), none, none, [], [])].
test(attested_with_url_evidence_is_well_formed) :-
    Fact = attested(true, attestation(decision_layer, date(2026, 11, 1), checked, url('https://eur-lex.europa.eu', date(2026, 11, 1)))),
    engaged_with([attribute(legislative_restriction_applies_to_the_right, Fact)], Profile),
    gdpr_data_subject_rights_automated_decision_input_problems(Profile, []).
test(attested_with_document_evidence_is_well_formed) :-
    Fact = attested(false, attestation(decision_layer, date(2026, 11, 1), checked, document(upload_one, digest_one))),
    engaged_with([attribute(decision_authorised_by_union_or_member_state_law, Fact)], Profile),
    gdpr_data_subject_rights_automated_decision_input_problems(Profile, []).
test(attested_true_restriction_relieves_the_controller) :-
    Fact = attested(true, attestation(decision_layer, date(2026, 11, 1), checked, none)),
    engaged_with([attribute(legislative_restriction_applies_to_the_right, Fact)], Profile),
    findall(Verdict, decide_data_subject_request(Profile, Verdict), Verdicts),
    Verdicts == [gdpr_data_subject_request_verdict(need_not_comply, art22_1, art23_legislative_restriction, [], [cite(eu_reg_2016_679_art_22_1), cite(eu_reg_2016_679_art_23_1)])].
test(a_bare_atom_is_not_an_attested_value) :-
    gdpr_data_subject_rights_automated_decision_input_problems([attribute(legislative_restriction_applies_to_the_right, true)], [wrong_type(legislative_restriction_applies_to_the_right)]).
test(request_basis_reports_a_profile_that_is_not_a_list) :-
    findall(Basis, request_basis(not_a_list, Basis), Answers),
    Answers == [input_problems([wrong_type(profile)])].
test(request_basis_reports_an_unknown_key) :-
    findall(Basis, request_basis([attribute(not_a_contract_key, true)], Basis), Answers),
    Answers == [input_problems([unknown_key(not_a_contract_key)])].
test(request_basis_reports_a_duplicate_key) :-
    findall(Basis, request_basis([attribute(extension_claimed, true), attribute(extension_claimed, false)], Basis), Answers),
    Answers == [input_problems([duplicate_key(extension_claimed)])].
test(request_basis_still_answers_a_good_profile) :-
    engaged_with([], Profile),
    findall(Basis, request_basis(Profile, Basis), Answers),
    Answers == [art22_1].

cp_test_names([provenance_builds_and_destructures, provenance_rides_in_a_review_context, duplicate_key_is_named_by_the_input_check, duplicate_key_gives_an_input_problem_verdict, attested_with_url_evidence_is_well_formed, attested_with_document_evidence_is_well_formed, attested_true_restriction_relieves_the_controller, a_bare_atom_is_not_an_attested_value, request_basis_reports_a_profile_that_is_not_a_list, request_basis_reports_an_unknown_key, request_basis_reports_a_duplicate_key, request_basis_still_answers_a_good_profile]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
