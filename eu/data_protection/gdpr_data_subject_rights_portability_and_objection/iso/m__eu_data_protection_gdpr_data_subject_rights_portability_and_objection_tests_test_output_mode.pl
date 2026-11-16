% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_data_subject_rights_portability_and_objection_tests_test_output_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_data_subject_rights_portability_and_objection_queries, [decide_data_subject_request/2, request_basis/2]).
:- use_module(m__eu_data_protection_gdpr_data_subject_rights_portability_and_objection_fixtures, [gdpr_data_subject_rights_portability_and_objection_profile_for/2]).

verdicts_of(Subject, Verdicts) :-
    gdpr_data_subject_rights_portability_and_objection_profile_for(Subject, Profile),
    findall(Verdict, decide_data_subject_request(Profile, Verdict), Verdicts).

test(portability_must_comply) :-
    verdicts_of(portability_positive, Verdicts),
    Verdicts == [gdpr_data_subject_request_verdict(must_comply, art20_1, none, [], [cite(eu_reg_2016_679_art_20_1)])].
test(portability_not_automated) :-
    verdicts_of(portability_not_automated, Verdicts),
    Verdicts == [gdpr_data_subject_request_verdict(need_not_comply, none, none, [], [cite(eu_reg_2016_679_art_20_1)])].
test(portability_public_task) :-
    verdicts_of(portability_public_task, Verdicts),
    Verdicts == [gdpr_data_subject_request_verdict(need_not_comply, art20_1, art20_3_public_task, [], [cite(eu_reg_2016_679_art_20_1), cite(eu_reg_2016_679_art_20_3)])].
test(portability_rights_of_others) :-
    verdicts_of(portability_rights_of_others, Verdicts),
    Verdicts == [gdpr_data_subject_request_verdict(need_not_comply, art20_1, art20_4_rights_of_others, [], [cite(eu_reg_2016_679_art_20_1), cite(eu_reg_2016_679_art_20_4)])].
test(portability_unable_to_identify) :-
    verdicts_of(portability_unable_to_identify, Verdicts),
    Verdicts == [gdpr_data_subject_request_verdict(need_not_comply, art20_1, art12_2_unable_to_identify, [], [cite(eu_reg_2016_679_art_12_2), cite(eu_reg_2016_679_art_20_1)])].
test(portability_restriction_attested) :-
    verdicts_of(portability_restriction_attested, Verdicts),
    Verdicts == [gdpr_data_subject_request_verdict(need_not_comply, art20_1, art23_legislative_restriction, [], [cite(eu_reg_2016_679_art_20_1), cite(eu_reg_2016_679_art_23_1)])].
test(portability_restriction_denied_must_comply) :-
    verdicts_of(portability_restriction_denied, Verdicts),
    Verdicts == [gdpr_data_subject_request_verdict(must_comply, art20_1, none, [], [cite(eu_reg_2016_679_art_20_1)])].
test(portability_identity_confirmed_must_comply) :-
    verdicts_of(portability_identity_confirmed, Verdicts),
    Verdicts == [gdpr_data_subject_request_verdict(must_comply, art20_1, none, [], [cite(eu_reg_2016_679_art_20_1)])].
test(portability_suspended) :-
    verdicts_of(portability_suspended, Verdicts),
    Verdicts == [gdpr_data_subject_request_verdict(suspended(art12_6_identity_not_confirmed), none, none, [], [])].
test(portability_missing_key) :-
    verdicts_of(portability_missing_key, Verdicts),
    Verdicts == [gdpr_data_subject_request_verdict(indeterminate([personal_data_provided_by_data_subject]), none, none, [], [])].
test(portability_unsure_refers) :-
    verdicts_of(portability_public_task_unsure, Verdicts),
    Verdicts == [gdpr_data_subject_request_verdict(needs_legal_review(open_textured(processing_necessary_for_public_task_or_official_authority, cite(eu_reg_2016_679_art_20_3)), [inputs_relied_on([request_type - portability, processing_necessary_for_public_task_or_official_authority - unsure])]), none, none, [], [])].
test(objection_art21_1_must_comply) :-
    verdicts_of(objection_art21_1_positive, Verdicts),
    Verdicts == [gdpr_data_subject_request_verdict(must_comply, art21_1, none, [], [cite(eu_reg_2016_679_art_21_1)])].
test(objection_art21_1_not_engaged) :-
    verdicts_of(objection_art21_1_not_art6_e_f, Verdicts),
    Verdicts == [gdpr_data_subject_request_verdict(need_not_comply, none, none, [], [cite(eu_reg_2016_679_art_21_1)])].
test(objection_art21_1_compelling) :-
    verdicts_of(objection_art21_1_compelling, Verdicts),
    Verdicts == [gdpr_data_subject_request_verdict(need_not_comply, art21_1, art21_1_compelling_legitimate_grounds, [], [cite(eu_reg_2016_679_art_21_1)])].
test(objection_art21_1_legal_claims) :-
    verdicts_of(objection_art21_1_legal_claims, Verdicts),
    Verdicts == [gdpr_data_subject_request_verdict(need_not_comply, art21_1, art21_1_legal_claims, [], [cite(eu_reg_2016_679_art_21_1)])].
test(objection_art21_2_must_comply) :-
    verdicts_of(objection_art21_2_positive, Verdicts),
    Verdicts == [gdpr_data_subject_request_verdict(must_comply, art21_2, none, [], [cite(eu_reg_2016_679_art_21_2), cite(eu_reg_2016_679_art_21_3)])].
test(objection_art21_2_not_marketing) :-
    verdicts_of(objection_art21_2_not_marketing, Verdicts),
    Verdicts == [gdpr_data_subject_request_verdict(need_not_comply, none, none, [], [cite(eu_reg_2016_679_art_21_2), cite(eu_reg_2016_679_art_21_3)])].
test(objection_art21_6_must_comply) :-
    verdicts_of(objection_art21_6_positive, Verdicts),
    Verdicts == [gdpr_data_subject_request_verdict(must_comply, art21_6, none, [], [cite(eu_reg_2016_679_art_21_6)])].
test(objection_art21_6_public_task) :-
    verdicts_of(objection_art21_6_public_task, Verdicts),
    Verdicts == [gdpr_data_subject_request_verdict(need_not_comply, art21_6, art21_6_public_interest_task, [], [cite(eu_reg_2016_679_art_21_6)])].
test(objection_missing_ground) :-
    verdicts_of(objection_missing_ground, Verdicts),
    Verdicts == [gdpr_data_subject_request_verdict(indeterminate([objection_ground_claimed]), none, none, [], [])].
test(absent_request_type) :-
    verdicts_of(absent_request_type, Verdicts),
    Verdicts == [gdpr_data_subject_request_verdict(indeterminate([request_type]), none, none, [], [])].
test(unknown_key_problem) :-
    verdicts_of(unknown_key_problem, Verdicts),
    Verdicts == [gdpr_data_subject_request_verdict(input_problems([unknown_key(no_such_key)]), none, none, [], [])].
test(basis_is_yielded_once) :-
    gdpr_data_subject_rights_portability_and_objection_profile_for(portability_public_task, Profile),
    findall(Basis, request_basis(Profile, Basis), Bases),
    Bases == [art20_1].

cp_test_names([portability_must_comply, portability_not_automated, portability_public_task, portability_rights_of_others, portability_unable_to_identify, portability_restriction_attested, portability_restriction_denied_must_comply, portability_identity_confirmed_must_comply, portability_suspended, portability_missing_key, portability_unsure_refers, objection_art21_1_must_comply, objection_art21_1_not_engaged, objection_art21_1_compelling, objection_art21_1_legal_claims, objection_art21_2_must_comply, objection_art21_2_not_marketing, objection_art21_6_must_comply, objection_art21_6_public_task, objection_missing_ground, absent_request_type, unknown_key_problem, basis_is_yielded_once]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
