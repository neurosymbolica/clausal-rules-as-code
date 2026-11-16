% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_data_subject_rights_articles_15_to_18_decision_and_exception_tests_test_negative_controls, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_data_subject_rights_articles_15_to_18_decision_and_exception_request_exception, [decide_request_exception/2, request_exception_status/2, request_exception_status_values/1, request_decision/2, request_exception/2]).
:- use_module(m__eu_data_protection_gdpr_data_subject_rights_articles_15_to_18_decision_and_exception_fixtures, [gdpr_data_subject_rights_articles_15_to_18_decision_and_exception_profile_for/2]).

decision_of(Subject, Comply) :-
    gdpr_data_subject_rights_articles_15_to_18_decision_and_exception_profile_for(Subject, Profile),
    request_decision(Profile, Comply).

exception_of(Subject, Exception) :-
    gdpr_data_subject_rights_articles_15_to_18_decision_and_exception_profile_for(Subject, Profile),
    request_exception(Profile, Exception).

verdict_of(Subject, Verdict) :-
    gdpr_data_subject_rights_articles_15_to_18_decision_and_exception_profile_for(Subject, Profile),
    decide_request_exception(Profile, Verdict).

test(the_exception_atoms_are_vocabulary_atoms) :-
    request_exception_status_values(Vocabulary),
    member(art17_3_a, Vocabulary),
    member(art17_3_b, Vocabulary),
    member(art17_3_c, Vocabulary),
    member(art17_3_d, Vocabulary),
    member(art17_3_e, Vocabulary),
    member(art12_5_manifestly_unfounded_or_excessive, Vocabulary),
    member(art12_2_unable_to_identify, Vocabulary),
    member(art23_legislative_restriction, Vocabulary),
    member(none, Vocabulary).
test(access_must_comply) :-
    decision_of(access_request, must_comply).
test(access_restricted_by_law_is_relieved) :-
    exception_of(access_request_legislative_restriction, art23_legislative_restriction).
test(access_not_restricted_by_law_must_comply) :-
    decision_of(access_request_no_legislative_restriction, must_comply).
test(manifestly_unfounded_access_need_not_comply) :-
    decision_of(access_request_manifestly_unfounded, need_not_comply).
test(well_founded_access_must_comply) :-
    decision_of(access_request_not_manifestly_unfounded, must_comply).
test(unidentifiable_data_subject_is_relieved) :-
    exception_of(access_request_controller_cannot_identify, art12_2_unable_to_identify).
test(identifiable_data_subject_has_no_exception) :-
    exception_of(access_request_controller_can_identify, none).
test(unconfirmed_identity_suspends) :-
    decision_of(access_request_identity_unconfirmed, suspended(art12_6_identity_not_confirmed)).
test(confirmed_identity_must_comply) :-
    decision_of(access_request_identity_confirmed, must_comply).
test(unsure_doubts_are_referred) :-
    decision_of(access_request_identity_doubts_unsure, needs_legal_review(open_textured(reasonable_doubts_about_identity, cite(eu_reg_2016_679_art_12_6)), _Context)).
test(inaccurate_data_must_be_rectified) :-
    verdict_of(rectification_inaccurate_data, request_exception_verdict(must_comply, [cite(eu_reg_2016_679_art_16)])).
test(accurate_complete_data_need_not_be_rectified) :-
    decision_of(rectification_accurate_and_complete_data, need_not_comply).
test(unsure_completeness_is_referred) :-
    decision_of(rectification_completeness_unsure, needs_legal_review(open_textured(personal_data_incomplete_in_light_of_purposes, cite(eu_reg_2016_679_art_16)), _Context)).
test(bare_erasure_is_indeterminate) :-
    decision_of(erasure_facts_missing, indeterminate([_|_])).
test(erasure_with_a_met_ground_must_comply) :-
    verdict_of(erasure_data_no_longer_necessary, request_exception_verdict(must_comply, [cite(eu_reg_2016_679_art_17_1_a)])).
test(unattested_erasure_law_is_referred) :-
    decision_of(erasure_no_ground_law_not_attested, needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_17_1_e), cite(union_or_member_state_law_requiring_erasure)), _Context)).
test(attested_absence_of_erasure_law_need_not_comply) :-
    decision_of(erasure_no_ground, need_not_comply).
test(attested_erasure_law_must_comply) :-
    verdict_of(erasure_required_by_law, request_exception_verdict(must_comply, [cite(eu_reg_2016_679_art_17_1_e)])).
test(withdrawn_consent_must_erase) :-
    verdict_of(erasure_consent_withdrawn, request_exception_verdict(must_comply, [cite(eu_reg_2016_679_art_17_1_b)])).
test(withdrawn_consent_with_another_ground_need_not_comply) :-
    decision_of(erasure_consent_withdrawn_other_ground, need_not_comply).
test(direct_marketing_objection_must_erase) :-
    verdict_of(erasure_objection_direct_marketing, request_exception_verdict(must_comply, [cite(eu_reg_2016_679_art_17_1_c)])).
test(freedom_of_expression_relieves) :-
    exception_of(erasure_freedom_of_expression, art17_3_a).
test(unnecessary_freedom_of_expression_must_comply) :-
    decision_of(erasure_freedom_of_expression_not_necessary, must_comply).
test(public_task_relieves) :-
    exception_of(erasure_public_task, art17_3_b).
test(law_requiring_processing_relieves) :-
    exception_of(erasure_law_requires_processing, art17_3_b).
test(law_not_requiring_processing_must_comply) :-
    decision_of(erasure_law_does_not_require_processing, must_comply).
test(public_health_relieves) :-
    exception_of(erasure_public_health, art17_3_c).
test(archiving_with_impairment_relieves) :-
    exception_of(erasure_archiving_impairs_objectives, art17_3_d).
test(archiving_without_impairment_must_comply) :-
    decision_of(erasure_archiving_without_impairment, must_comply).
test(legal_claims_relieve) :-
    exception_of(erasure_legal_claims, art17_3_e).
test(contested_accuracy_must_restrict) :-
    verdict_of(restriction_accuracy_contested, request_exception_verdict(must_comply, [cite(eu_reg_2016_679_art_18_1_a)])).
test(no_situation_need_not_comply) :-
    decision_of(restriction_no_situation, need_not_comply).
test(legal_claims_must_restrict) :-
    verdict_of(restriction_legal_claims, request_exception_verdict(must_comply, [cite(eu_reg_2016_679_art_18_1_c)])).
test(pending_verification_must_restrict) :-
    decision_of(restriction_objection_pending_verification, must_comply).
test(unsure_unlawfulness_is_referred) :-
    decision_of(restriction_unlawfulness_unsure, needs_legal_review(open_textured(personal_data_unlawfully_processed, cite(eu_reg_2016_679_art_18_1_b)), _Context)).
test(lawful_processing_need_not_comply) :-
    decision_of(restriction_lawful_processing, need_not_comply).
test(an_unknown_key_is_an_input_problem) :-
    decision_of(access_request_unknown_key, input_problems([unknown_key(favourite_colour)])).
test(a_duplicate_key_is_an_input_problem) :-
    decision_of(access_request_duplicate_key, input_problems([duplicate_key(request_type)])).
test(an_absent_request_type_is_indeterminate) :-
    decision_of(request_type_not_given, indeterminate([request_type])).
test(the_status_projection_follows_the_decision) :-
    gdpr_data_subject_rights_articles_15_to_18_decision_and_exception_profile_for(access_request_manifestly_unfounded, Profile),
    request_exception_status(Profile, need_not_comply).

test(access_restricted_by_law_is_not_must_comply, fail) :-
    decision_of(access_request_legislative_restriction, must_comply).
test(access_not_restricted_by_law_is_not_relieved, fail) :-
    exception_of(access_request_no_legislative_restriction, art23_legislative_restriction).
test(well_founded_access_is_not_need_not_comply, fail) :-
    decision_of(access_request_not_manifestly_unfounded, need_not_comply).
test(identifiable_data_subject_is_not_relieved, fail) :-
    exception_of(access_request_controller_can_identify, art12_2_unable_to_identify).
test(confirmed_identity_does_not_suspend, fail) :-
    decision_of(access_request_identity_confirmed, suspended(_)).
test(unconfirmed_identity_without_doubts_does_not_suspend, fail) :-
    decision_of(access_request_identity_not_confirmed_without_doubts, suspended(_)).
test(certain_doubts_are_not_referred, fail) :-
    decision_of(access_request_identity_unconfirmed, needs_legal_review(_, _)).
test(accurate_complete_data_is_not_must_comply, fail) :-
    decision_of(rectification_accurate_and_complete_data, must_comply).
test(incomplete_data_is_not_referred, fail) :-
    decision_of(rectification_incomplete_data, needs_legal_review(_, _)).
test(erasure_with_a_met_ground_is_not_indeterminate, fail) :-
    decision_of(erasure_data_no_longer_necessary, indeterminate(_)).
test(attested_absence_of_erasure_law_is_not_referred, fail) :-
    decision_of(erasure_no_ground, needs_legal_review(_, _)).
test(withdrawn_consent_with_another_ground_is_not_must_comply, fail) :-
    decision_of(erasure_consent_withdrawn_other_ground, must_comply).
test(no_ground_is_not_must_comply, fail) :-
    decision_of(erasure_no_ground, must_comply).
test(unnecessary_freedom_of_expression_does_not_relieve, fail) :-
    exception_of(erasure_freedom_of_expression_not_necessary, art17_3_a).
test(unnecessary_public_task_does_not_relieve, fail) :-
    exception_of(erasure_public_task_not_necessary, art17_3_b).
test(law_not_requiring_processing_does_not_relieve, fail) :-
    exception_of(erasure_law_does_not_require_processing, art17_3_b).
test(unnecessary_public_health_does_not_relieve, fail) :-
    exception_of(erasure_public_health_not_necessary, art17_3_c).
test(archiving_without_impairment_does_not_relieve, fail) :-
    exception_of(erasure_archiving_without_impairment, art17_3_d).
test(unnecessary_legal_claims_do_not_relieve, fail) :-
    exception_of(erasure_legal_claims_not_necessary, art17_3_e).
test(no_situation_is_not_must_comply, fail) :-
    decision_of(restriction_no_situation, must_comply).
test(legal_claims_not_required_is_not_must_comply, fail) :-
    decision_of(restriction_legal_claims_not_required, must_comply).
test(finished_verification_is_not_must_comply, fail) :-
    decision_of(restriction_objection_verification_done, must_comply).
test(lawful_processing_is_not_referred, fail) :-
    decision_of(restriction_lawful_processing, needs_legal_review(_, _)).
test(a_clean_profile_has_no_input_problem, fail) :-
    decision_of(access_request, input_problems(_)).
test(a_duplicate_key_is_not_also_a_wrong_type, fail) :-
    decision_of(access_request_duplicate_key, input_problems([duplicate_key(request_type), wrong_type(request_type)])).
test(a_given_request_type_is_not_indeterminate, fail) :-
    decision_of(access_request, indeterminate(_)).

cp_test_names([the_exception_atoms_are_vocabulary_atoms, access_must_comply, access_restricted_by_law_is_relieved, access_not_restricted_by_law_must_comply, manifestly_unfounded_access_need_not_comply, well_founded_access_must_comply, unidentifiable_data_subject_is_relieved, identifiable_data_subject_has_no_exception, unconfirmed_identity_suspends, confirmed_identity_must_comply, unsure_doubts_are_referred, inaccurate_data_must_be_rectified, accurate_complete_data_need_not_be_rectified, unsure_completeness_is_referred, bare_erasure_is_indeterminate, erasure_with_a_met_ground_must_comply, unattested_erasure_law_is_referred, attested_absence_of_erasure_law_need_not_comply, attested_erasure_law_must_comply, withdrawn_consent_must_erase, withdrawn_consent_with_another_ground_need_not_comply, direct_marketing_objection_must_erase, freedom_of_expression_relieves, unnecessary_freedom_of_expression_must_comply, public_task_relieves, law_requiring_processing_relieves, law_not_requiring_processing_must_comply, public_health_relieves, archiving_with_impairment_relieves, archiving_without_impairment_must_comply, legal_claims_relieve, contested_accuracy_must_restrict, no_situation_need_not_comply, legal_claims_must_restrict, pending_verification_must_restrict, unsure_unlawfulness_is_referred, lawful_processing_need_not_comply, an_unknown_key_is_an_input_problem, a_duplicate_key_is_an_input_problem, an_absent_request_type_is_indeterminate, the_status_projection_follows_the_decision]).
cp_test_fail_names([access_restricted_by_law_is_not_must_comply, access_not_restricted_by_law_is_not_relieved, well_founded_access_is_not_need_not_comply, identifiable_data_subject_is_not_relieved, confirmed_identity_does_not_suspend, unconfirmed_identity_without_doubts_does_not_suspend, certain_doubts_are_not_referred, accurate_complete_data_is_not_must_comply, incomplete_data_is_not_referred, erasure_with_a_met_ground_is_not_indeterminate, attested_absence_of_erasure_law_is_not_referred, withdrawn_consent_with_another_ground_is_not_must_comply, no_ground_is_not_must_comply, unnecessary_freedom_of_expression_does_not_relieve, unnecessary_public_task_does_not_relieve, law_not_requiring_processing_does_not_relieve, unnecessary_public_health_does_not_relieve, archiving_without_impairment_does_not_relieve, unnecessary_legal_claims_do_not_relieve, no_situation_is_not_must_comply, legal_claims_not_required_is_not_must_comply, finished_verification_is_not_must_comply, lawful_processing_is_not_referred, a_clean_profile_has_no_input_problem, a_duplicate_key_is_not_also_a_wrong_type, a_given_request_type_is_not_indeterminate]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
