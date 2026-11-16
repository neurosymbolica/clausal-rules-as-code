% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_data_subject_rights_portability_and_objection_tests_test_public_interface, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_data_subject_rights_portability_and_objection_queries, [decide_data_subject_request/2, request_basis/2]).
:- use_module(m__eu_data_protection_gdpr_data_subject_rights_portability_and_objection_request_basis, [decide_request_basis/2, request_basis_status/2, request_basis_checklist/2, request_basis_decision_resolvable/1, request_basis_status_values/1]).
:- use_module(m__eu_data_protection_gdpr_data_subject_rights_portability_and_objection_fixtures, [gdpr_data_subject_rights_portability_and_objection_subject/1, gdpr_data_subject_rights_portability_and_objection_profile_for/2, gdpr_data_subject_rights_portability_and_objection_assess/2]).

comply_of(Subject, Comply) :-
    gdpr_data_subject_rights_portability_and_objection_assess(Subject, gdpr_data_subject_request_verdict(Comply, _, _, _, _)).

test(portability_positive_must_comply) :-
    comply_of(portability_positive, must_comply).
test(portability_not_automated_need_not_comply) :-
    comply_of(portability_not_automated, need_not_comply).
test(portability_public_task_need_not_comply) :-
    comply_of(portability_public_task, need_not_comply).
test(portability_public_task_false_must_comply) :-
    comply_of(portability_public_task_false, must_comply).
test(portability_rights_of_others_need_not_comply) :-
    comply_of(portability_rights_of_others, need_not_comply).
test(portability_rights_of_others_false_must_comply) :-
    comply_of(portability_rights_of_others_false, must_comply).
test(portability_suspended) :-
    gdpr_data_subject_rights_portability_and_objection_assess(portability_suspended, gdpr_data_subject_request_verdict(suspended(art12_6_identity_not_confirmed), none, none, [], [])).
test(portability_identity_confirmed_must_comply) :-
    comply_of(portability_identity_confirmed, must_comply).
test(portability_missing_key_indeterminate) :-
    gdpr_data_subject_rights_portability_and_objection_assess(portability_missing_key, gdpr_data_subject_request_verdict(indeterminate([personal_data_provided_by_data_subject]), none, none, [], [])).
test(portability_public_task_unsure_refers) :-
    comply_of(portability_public_task_unsure, needs_legal_review(_, _)).
test(portability_unable_to_identify) :-
    gdpr_data_subject_rights_portability_and_objection_assess(portability_unable_to_identify, gdpr_data_subject_request_verdict(need_not_comply, art20_1, art12_2_unable_to_identify, [], _)).
test(portability_restriction_attested) :-
    gdpr_data_subject_rights_portability_and_objection_assess(portability_restriction_attested, gdpr_data_subject_request_verdict(need_not_comply, art20_1, art23_legislative_restriction, [], _)).
test(portability_restriction_denied_must_comply) :-
    comply_of(portability_restriction_denied, must_comply).
test(objection_art21_1_positive) :-
    gdpr_data_subject_rights_portability_and_objection_assess(objection_art21_1_positive, gdpr_data_subject_request_verdict(must_comply, art21_1, none, [], _)).
test(objection_art21_1_not_art6_e_f) :-
    comply_of(objection_art21_1_not_art6_e_f, need_not_comply).
test(objection_art21_1_compelling) :-
    gdpr_data_subject_rights_portability_and_objection_assess(objection_art21_1_compelling, gdpr_data_subject_request_verdict(need_not_comply, art21_1, art21_1_compelling_legitimate_grounds, [], _)).
test(objection_art21_1_legal_claims) :-
    gdpr_data_subject_rights_portability_and_objection_assess(objection_art21_1_legal_claims, gdpr_data_subject_request_verdict(need_not_comply, art21_1, art21_1_legal_claims, [], _)).
test(objection_art21_1_exceptions_false_must_comply) :-
    comply_of(objection_art21_1_compelling_false, must_comply).
test(objection_missing_ground) :-
    comply_of(objection_missing_ground, indeterminate([objection_ground_claimed])).
test(objection_art21_2_positive) :-
    gdpr_data_subject_rights_portability_and_objection_assess(objection_art21_2_positive, gdpr_data_subject_request_verdict(must_comply, art21_2, none, [], _)).
test(objection_art21_2_not_marketing) :-
    comply_of(objection_art21_2_not_marketing, need_not_comply).
test(objection_art21_2_excessive) :-
    gdpr_data_subject_rights_portability_and_objection_assess(objection_art21_2_excessive, gdpr_data_subject_request_verdict(need_not_comply, art21_2, art12_5_manifestly_unfounded_or_excessive, [reasonable_fee_may_be_charged], _)).
test(objection_art21_2_not_excessive_must_comply) :-
    comply_of(objection_art21_2_not_excessive, must_comply).
test(objection_art21_6_positive) :-
    gdpr_data_subject_rights_portability_and_objection_assess(objection_art21_6_positive, gdpr_data_subject_request_verdict(must_comply, art21_6, none, [], _)).
test(objection_art21_6_not_research) :-
    comply_of(objection_art21_6_not_research, need_not_comply).
test(objection_art21_6_public_task) :-
    gdpr_data_subject_rights_portability_and_objection_assess(objection_art21_6_public_task, gdpr_data_subject_request_verdict(need_not_comply, art21_6, art21_6_public_interest_task, [], _)).
test(absent_request_type) :-
    comply_of(absent_request_type, indeterminate([request_type])).
test(unknown_key_problem) :-
    comply_of(unknown_key_problem, input_problems([unknown_key(no_such_key)])).
test(out_of_scope_request_type_has_one_answer) :-
    findall(Verdict, decide_data_subject_request([attribute(request_type, access)], Verdict), Verdicts),
    Verdicts == [gdpr_data_subject_request_verdict(need_not_comply, none, none, [], [])].
test(out_of_scope_request_type_basis_is_none) :-
    findall(Basis, request_basis([attribute(request_type, erasure)], Basis), Bases),
    Bases == [none].
test(in_scope_basis_through_public_query) :-
    gdpr_data_subject_rights_portability_and_objection_profile_for(portability_positive, Profile),
    findall(Basis, request_basis(Profile, Basis), Bases),
    Bases == [art20_1].
test(non_list_profile_is_an_input_problem) :-
    decide_data_subject_request(not_a_list, gdpr_data_subject_request_verdict(input_problems([wrong_type(profile)]), none, none, [], [])).
test(provenance_constructor_holds_clause_and_citations) :-
    Marker = provenance(request_basis, [cite(eu_reg_2016_679_art_20_1)]),
    Marker = provenance(Clause, Citations),
    Clause == request_basis,
    Citations == [cite(eu_reg_2016_679_art_20_1)].
test(attested_constructor_wraps_value_and_attestation) :-
    Fact = attested(true, attestation(host, now, statute, none)),
    Fact = attested(Value, Attestation),
    Value == true,
    Attestation = attestation(host, now, statute, none).
test(attested_false_is_a_different_value) :-
    Fact = attested(false, attestation(host, now, statute, none)),
    Fact = attested(Value, _),
    Value == false.
test(attestation_constructor_has_four_fields) :-
    Attestation = attestation(By, At, Reason, Evidence),
    By = host,
    At = now,
    Reason = statute,
    Evidence = none,
    Attestation == attestation(host, now, statute, none).
test(url_constructor_is_evidence) :-
    Evidence = url('https://eur-lex.europa.eu/eli/reg/2016/679/oj', date(2026, 11, 7)),
    Attestation = attestation(host, now, statute, Evidence),
    Attestation = attestation(_, _, _, url(Address, RetrievedAt)),
    Address == 'https://eur-lex.europa.eu/eli/reg/2016/679/oj',
    RetrievedAt == date(2026, 11, 7).
test(document_constructor_is_evidence) :-
    Evidence = document(upload_one, sha256_digest),
    Attestation = attestation(host, now, statute, Evidence),
    Attestation = attestation(_, _, _, document(UploadId, Digest)),
    UploadId == upload_one,
    Digest == sha256_digest.
test(attested_restriction_through_public_query) :-
    Profile = [attribute(request_type, portability), attribute(personal_data_provided_by_data_subject, true), attribute(processing_based_on_consent_or_contract, true), attribute(processing_carried_out_by_automated_means, true), attribute(legislative_restriction_applies_to_the_right, attested(true, attestation(host, now, statute, url(test_address, date(2026, 11, 7)))))],
    decide_data_subject_request(Profile, gdpr_data_subject_request_verdict(need_not_comply, art20_1, art23_legislative_restriction, [], _)).
test(entry_points_agree) :-
    gdpr_data_subject_rights_portability_and_objection_profile_for(objection_art21_2_positive, Profile),
    decide_data_subject_request(Profile, Verdict),
    decide_request_basis(Profile, Verdict),
    request_basis(Profile, art21_2),
    request_basis_status(Profile, art21_2).
test(checklist_non_empty_and_resolvable) :-
    gdpr_data_subject_rights_portability_and_objection_profile_for(portability_positive, Profile),
    request_basis_decision_resolvable(Profile),
    request_basis_checklist(Profile, [_FirstItem|_OtherItems]).
test(status_values_include_art20_1) :-
    request_basis_status_values(Values),
    member(art20_1, Values).
test(every_subject_resolves) :-
    gdpr_data_subject_rights_portability_and_objection_subject(Subject),
    gdpr_data_subject_rights_portability_and_objection_assess(Subject, gdpr_data_subject_request_verdict(_, _, _, _, _)).

test(portability_not_automated_is_not_must_comply, fail) :-
    comply_of(portability_not_automated, must_comply).

cp_test_names([portability_positive_must_comply, portability_not_automated_need_not_comply, portability_public_task_need_not_comply, portability_public_task_false_must_comply, portability_rights_of_others_need_not_comply, portability_rights_of_others_false_must_comply, portability_suspended, portability_identity_confirmed_must_comply, portability_missing_key_indeterminate, portability_public_task_unsure_refers, portability_unable_to_identify, portability_restriction_attested, portability_restriction_denied_must_comply, objection_art21_1_positive, objection_art21_1_not_art6_e_f, objection_art21_1_compelling, objection_art21_1_legal_claims, objection_art21_1_exceptions_false_must_comply, objection_missing_ground, objection_art21_2_positive, objection_art21_2_not_marketing, objection_art21_2_excessive, objection_art21_2_not_excessive_must_comply, objection_art21_6_positive, objection_art21_6_not_research, objection_art21_6_public_task, absent_request_type, unknown_key_problem, out_of_scope_request_type_has_one_answer, out_of_scope_request_type_basis_is_none, in_scope_basis_through_public_query, non_list_profile_is_an_input_problem, provenance_constructor_holds_clause_and_citations, attested_constructor_wraps_value_and_attestation, attested_false_is_a_different_value, attestation_constructor_has_four_fields, url_constructor_is_evidence, document_constructor_is_evidence, attested_restriction_through_public_query, entry_points_agree, checklist_non_empty_and_resolvable, status_values_include_art20_1, every_subject_resolves]).
cp_test_fail_names([portability_not_automated_is_not_must_comply]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
