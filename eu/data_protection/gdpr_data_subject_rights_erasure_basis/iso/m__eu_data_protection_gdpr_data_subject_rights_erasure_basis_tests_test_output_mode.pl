% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_data_subject_rights_erasure_basis_tests_test_output_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_data_subject_rights_erasure_basis_request_basis, [decide_request_basis/2, request_basis_status/2, request_basis/2]).
:- use_module(m__eu_data_protection_gdpr_data_subject_rights_erasure_basis_fixtures, [gdpr_data_subject_rights_erasure_basis_subject/1, gdpr_data_subject_rights_erasure_basis_profile_for/2]).

test(the_necessity_profile_yields_exactly_one_status) :-
    gdpr_data_subject_rights_erasure_basis_profile_for(necessity_no_longer, Profile),
    findall(Status, request_basis_status(Profile, Status), Statuses),
    Statuses == [art17_1_a].
test(the_verdict_carries_a_citation) :-
    gdpr_data_subject_rights_erasure_basis_profile_for(necessity_no_longer, Profile),
    decide_request_basis(Profile, request_basis_verdict(_Status, [_FirstCitation|_OtherCitations])).
test(every_subject_has_its_expected_basis_exactly_once) :-
    findall(Subject - Basis, (gdpr_data_subject_rights_erasure_basis_subject(Subject), gdpr_data_subject_rights_erasure_basis_profile_for(Subject, Profile), request_basis(Profile, Basis)), Pairs),
    Pairs == [no_ground_engaged - none, necessity_no_longer - art17_1_a, necessity_unsure - none, consent_withdrawn_no_other_ground - art17_1_b, consent_withdrawn_other_ground_exists - none, objection_21_1_without_overriding - art17_1_c, objection_21_1_with_overriding - none, objection_21_2 - art17_1_c, unlawfully_processed - art17_1_d, law_requires_erasure - art17_1_e, law_requires_erasure_unattested - none, information_society_offer - art17_1_f, freedom_of_expression_exception - art17_1_a, freedom_of_expression_not_necessary - art17_1_a, manifestly_excessive_request - art17_1_a, request_not_excessive - art17_1_a, identity_doubts_unconfirmed - none, identity_doubts_confirmed - art17_1_a, unable_to_identify - art17_1_a, legislative_restriction - art17_1_a, request_type_only - none, unknown_key_present - none].

cp_test_names([the_necessity_profile_yields_exactly_one_status, the_verdict_carries_a_citation, every_subject_has_its_expected_basis_exactly_once]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
