% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_data_subject_rights_erasure_tests_test_output_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_data_subject_rights_erasure_queries, [decide_data_subject_request/2]).
:- use_module(m__eu_data_protection_gdpr_data_subject_rights_erasure_fixtures, [gdpr_data_subject_rights_erasure_fixture/3, gdpr_data_subject_rights_erasure_profile_for/2]).

fixture_answers(Name, Verdicts) :-
    gdpr_data_subject_rights_erasure_fixture(Name, Profile, _),
    findall(Verdict, decide_data_subject_request(Profile, Verdict), Verdicts).

test(every_fixture_yields_exactly_its_expected_verdict) :-
    findall(Name - [ExpectedVerdict], gdpr_data_subject_rights_erasure_fixture(Name, _, ExpectedVerdict), ExpectedRows),
    findall(Name - Verdicts, fixture_answers(Name, Verdicts), ActualRows),
    ActualRows == ExpectedRows.
test(a_bare_erasure_request_names_every_missing_key) :-
    findall(Verdict, decide_data_subject_request([attribute(request_type, erasure)], Verdict), Verdicts),
    Verdicts == [gdpr_data_subject_request_verdict(indeterminate([consent_is_the_basis_of_processing, consent_withdrawn, other_legal_ground_for_processing_exists, objection_under_art21_1_made, objection_under_art21_2_made, collected_in_relation_to_information_society_services_offer, data_no_longer_necessary_for_purposes, overriding_legitimate_grounds_exist, personal_data_unlawfully_processed]), none, none, [], [])].
test(an_unsure_identity_doubt_refers_on_article_12_6) :-
    findall(Verdict, decide_data_subject_request([attribute(request_type, erasure), attribute(data_no_longer_necessary_for_purposes, true), attribute(reasonable_doubts_about_identity, unsure), attribute(identity_confirmed, false)], Verdict), Verdicts),
    Verdicts == [gdpr_data_subject_request_verdict(needs_legal_review(open_textured(reasonable_doubts_about_identity, cite(eu_reg_2016_679_art_12_6)), [inputs_relied_on([request_type - erasure, reasonable_doubts_about_identity - unsure])]), none, none, [], [])].
test(an_unsure_doubt_with_an_absent_confirmation_names_the_missing_key) :-
    findall(Verdict, decide_data_subject_request([attribute(request_type, erasure), attribute(data_no_longer_necessary_for_purposes, true), attribute(reasonable_doubts_about_identity, unsure)], Verdict), Verdicts),
    Verdicts == [gdpr_data_subject_request_verdict(indeterminate([identity_confirmed]), none, none, [], [])].
test(an_unsure_manifest_character_refers_on_article_12_5) :-
    findall(Verdict, decide_data_subject_request([attribute(request_type, erasure), attribute(data_no_longer_necessary_for_purposes, true), attribute(request_manifestly_unfounded_or_excessive, unsure)], Verdict), Verdicts),
    Verdicts == [gdpr_data_subject_request_verdict(needs_legal_review(open_textured(request_manifestly_unfounded_or_excessive, cite(eu_reg_2016_679_art_12_5)), [inputs_relied_on([request_type - erasure, request_manifestly_unfounded_or_excessive - unsure])]), none, none, [], [])].
test(the_cross_reference_carries_its_resolution_first) :-
    gdpr_data_subject_rights_erasure_profile_for(needs_legal_review_erasure_law_unattested, Profile),
    decide_data_subject_request(Profile, gdpr_data_subject_request_verdict(needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_17_1_e), cite(union_or_member_state_law_requiring_erasure)), [resolution(cite(union_or_member_state_law_requiring_erasure), not_attempted)|_]), none, none, [], [])).
test(a_must_comply_verdict_cites_the_article_and_the_point) :-
    gdpr_data_subject_rights_erasure_profile_for(must_comply_marketing_objection, Profile),
    decide_data_subject_request(Profile, gdpr_data_subject_request_verdict(must_comply, art17_1_c, none, [], Citations)),
    Citations == [cite(eu_reg_2016_679_art_17_1), cite(eu_reg_2016_679_art_17_1_c)].
test(an_absent_legislative_restriction_does_not_stop_must_comply) :-
    findall(Comply, decide_data_subject_request([attribute(request_type, erasure), attribute(data_no_longer_necessary_for_purposes, true)], gdpr_data_subject_request_verdict(Comply, _, _, _, _)), Complies),
    Complies == [must_comply].

cp_test_names([every_fixture_yields_exactly_its_expected_verdict, a_bare_erasure_request_names_every_missing_key, an_unsure_identity_doubt_refers_on_article_12_6, an_unsure_doubt_with_an_absent_confirmation_names_the_missing_key, an_unsure_manifest_character_refers_on_article_12_5, the_cross_reference_carries_its_resolution_first, a_must_comply_verdict_cites_the_article_and_the_point, an_absent_legislative_restriction_does_not_stop_must_comply]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
