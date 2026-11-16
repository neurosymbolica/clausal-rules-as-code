% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_data_subject_rights_articles_15_to_18_decision_and_exception_tests_test_output_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_data_subject_rights_articles_15_to_18_decision_and_exception_request_exception, [decide_request_exception/2, request_exception_status/2, request_decision/2, request_exception/2]).
:- use_module(m__eu_data_protection_gdpr_data_subject_rights_articles_15_to_18_decision_and_exception_fixtures, [gdpr_data_subject_rights_articles_15_to_18_decision_and_exception_profile_for/2]).

subject_decisions(Subject, Decisions) :-
    gdpr_data_subject_rights_articles_15_to_18_decision_and_exception_profile_for(Subject, Profile),
    findall(Comply, request_decision(Profile, Comply), Decisions).

subject_exceptions(Subject, Exceptions) :-
    gdpr_data_subject_rights_articles_15_to_18_decision_and_exception_profile_for(Subject, Profile),
    findall(Exception, request_exception(Profile, Exception), Exceptions).

subject_verdicts(Subject, Verdicts) :-
    gdpr_data_subject_rights_articles_15_to_18_decision_and_exception_profile_for(Subject, Profile),
    findall(Verdict, decide_request_exception(Profile, Verdict), Verdicts).

test(access_request_reads_out_must_comply_once) :-
    subject_decisions(access_request, Decisions),
    Decisions == [must_comply].
test(access_request_status_reads_out_once) :-
    gdpr_data_subject_rights_articles_15_to_18_decision_and_exception_profile_for(access_request, Profile),
    findall(Status, request_exception_status(Profile, Status), Statuses),
    Statuses == [must_comply].
test(access_request_verdict_cites_article_15_1) :-
    subject_verdicts(access_request, Verdicts),
    Verdicts == [request_exception_verdict(must_comply, [cite(eu_reg_2016_679_art_15_1)])].
test(manifestly_unfounded_verdict_cites_article_12_5_and_point_a) :-
    subject_verdicts(access_request_manifestly_unfounded, Verdicts),
    Verdicts == [request_exception_verdict(need_not_comply, [cite(eu_reg_2016_679_art_12_5), cite(eu_reg_2016_679_art_12_5_a)])].
test(unable_to_identify_exception_reads_out_once) :-
    subject_exceptions(access_request_controller_cannot_identify, Exceptions),
    Exceptions == [art12_2_unable_to_identify].
test(legislative_restriction_exception_reads_out_once) :-
    subject_exceptions(access_request_legislative_restriction, Exceptions),
    Exceptions == [art23_legislative_restriction].
test(suspension_verdict_has_no_citations) :-
    subject_verdicts(access_request_identity_unconfirmed, Verdicts),
    Verdicts == [request_exception_verdict(suspended(art12_6_identity_not_confirmed), [])].
test(suspension_has_no_exception) :-
    subject_exceptions(access_request_identity_unconfirmed, Exceptions),
    Exceptions == [none].
test(unsure_identity_doubts_are_referred_with_their_pairs) :-
    subject_decisions(access_request_identity_doubts_unsure, Decisions),
    Decisions == [needs_legal_review(open_textured(reasonable_doubts_about_identity, cite(eu_reg_2016_679_art_12_6)), [inputs_relied_on([request_type - access, reasonable_doubts_about_identity - unsure])])].
test(unsure_completeness_is_referred_to_article_16) :-
    subject_decisions(rectification_completeness_unsure, Decisions),
    Decisions == [needs_legal_review(open_textured(personal_data_incomplete_in_light_of_purposes, cite(eu_reg_2016_679_art_16)), [inputs_relied_on([request_type - rectification, personal_data_incomplete_in_light_of_purposes - unsure])])].
test(rectification_not_engaged_cites_article_16) :-
    subject_verdicts(rectification_accurate_and_complete_data, Verdicts),
    Verdicts == [request_exception_verdict(need_not_comply, [cite(eu_reg_2016_679_art_16)])].
test(rectification_incomplete_data_basis_cites_article_16) :-
    subject_verdicts(rectification_incomplete_data, Verdicts),
    Verdicts == [request_exception_verdict(must_comply, [cite(eu_reg_2016_679_art_16)])].
test(bare_erasure_lists_every_missing_key_once) :-
    subject_decisions(erasure_facts_missing, Decisions),
    Decisions == [indeterminate([consent_is_the_basis_of_processing, consent_withdrawn, other_legal_ground_for_processing_exists, objection_under_art21_1_made, objection_under_art21_2_made, collected_in_relation_to_information_society_services_offer, data_no_longer_necessary_for_purposes, overriding_legitimate_grounds_exist, personal_data_unlawfully_processed])].
test(unattested_erasure_law_is_an_unresolved_cross_reference) :-
    subject_decisions(erasure_no_ground_law_not_attested, Decisions),
    Decisions == [needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_17_1_e), cite(union_or_member_state_law_requiring_erasure)), [resolution(cite(union_or_member_state_law_requiring_erasure), not_attempted), inputs_relied_on([request_type - erasure, data_no_longer_necessary_for_purposes - false, personal_data_unlawfully_processed - false, erasure_required_by_union_or_member_state_law - absent])])].
test(unsure_no_longer_necessary_is_referred_to_article_17_1_a) :-
    gdpr_data_subject_rights_articles_15_to_18_decision_and_exception_profile_for(erasure_ground_unsure, Profile),
    request_decision(Profile, needs_legal_review(open_textured(data_no_longer_necessary_for_purposes, cite(eu_reg_2016_679_art_17_1_a)), _Context)).
test(erasure_required_by_law_basis_cites_article_17_1_e) :-
    subject_verdicts(erasure_required_by_law, Verdicts),
    Verdicts == [request_exception_verdict(must_comply, [cite(eu_reg_2016_679_art_17_1_e)])].
test(erasure_consent_withdrawn_basis_cites_article_17_1_b) :-
    subject_verdicts(erasure_consent_withdrawn, Verdicts),
    Verdicts == [request_exception_verdict(must_comply, [cite(eu_reg_2016_679_art_17_1_b)])].
test(erasure_direct_marketing_objection_basis_cites_article_17_1_c) :-
    subject_verdicts(erasure_objection_direct_marketing, Verdicts),
    Verdicts == [request_exception_verdict(must_comply, [cite(eu_reg_2016_679_art_17_1_c)])].
test(erasure_public_task_exception_once) :-
    subject_exceptions(erasure_public_task, Exceptions),
    Exceptions == [art17_3_b].
test(erasure_law_requiring_processing_exception_once) :-
    subject_exceptions(erasure_law_requires_processing, Exceptions),
    Exceptions == [art17_3_b].
test(erasure_public_health_exception_once) :-
    subject_exceptions(erasure_public_health, Exceptions),
    Exceptions == [art17_3_c].
test(erasure_archiving_exception_once) :-
    subject_exceptions(erasure_archiving_impairs_objectives, Exceptions),
    Exceptions == [art17_3_d].
test(erasure_freedom_of_expression_verdict_cites_article_17_3_a) :-
    subject_verdicts(erasure_freedom_of_expression, Verdicts),
    Verdicts == [request_exception_verdict(need_not_comply, [cite(eu_reg_2016_679_art_17_3_a)])].
test(restriction_objection_pending_basis_cites_article_18_1_d) :-
    subject_verdicts(restriction_objection_pending_verification, Verdicts),
    Verdicts == [request_exception_verdict(must_comply, [cite(eu_reg_2016_679_art_18_1_d)])].
test(restriction_unsure_unlawfulness_is_referred_to_article_18_1_b) :-
    subject_decisions(restriction_unlawfulness_unsure, Decisions),
    Decisions == [needs_legal_review(open_textured(personal_data_unlawfully_processed, cite(eu_reg_2016_679_art_18_1_b)), [inputs_relied_on([request_type - restriction, personal_data_unlawfully_processed - unsure, controller_no_longer_needs_data_for_processing_purposes - false])])].
test(restriction_without_a_situation_cites_article_18_1) :-
    subject_verdicts(restriction_no_situation, Verdicts),
    Verdicts == [request_exception_verdict(need_not_comply, [cite(eu_reg_2016_679_art_18_1)])].
test(a_duplicate_key_reads_out_once) :-
    subject_decisions(access_request_duplicate_key, Decisions),
    Decisions == [input_problems([duplicate_key(request_type)])].
test(a_wrong_type_reads_out_once) :-
    subject_decisions(access_request_wrong_type, Decisions),
    Decisions == [input_problems([wrong_type(identity_confirmed)])].
test(a_term_that_is_not_a_profile_reads_out_once) :-
    subject_decisions(profile_not_an_attribute_list, Decisions),
    Decisions == [input_problems([wrong_type(profile)])].
test(an_absent_request_type_reads_out_once) :-
    subject_decisions(request_type_not_given, Decisions),
    Decisions == [indeterminate([request_type])].

cp_test_names([access_request_reads_out_must_comply_once, access_request_status_reads_out_once, access_request_verdict_cites_article_15_1, manifestly_unfounded_verdict_cites_article_12_5_and_point_a, unable_to_identify_exception_reads_out_once, legislative_restriction_exception_reads_out_once, suspension_verdict_has_no_citations, suspension_has_no_exception, unsure_identity_doubts_are_referred_with_their_pairs, unsure_completeness_is_referred_to_article_16, rectification_not_engaged_cites_article_16, rectification_incomplete_data_basis_cites_article_16, bare_erasure_lists_every_missing_key_once, unattested_erasure_law_is_an_unresolved_cross_reference, unsure_no_longer_necessary_is_referred_to_article_17_1_a, erasure_required_by_law_basis_cites_article_17_1_e, erasure_consent_withdrawn_basis_cites_article_17_1_b, erasure_direct_marketing_objection_basis_cites_article_17_1_c, erasure_public_task_exception_once, erasure_law_requiring_processing_exception_once, erasure_public_health_exception_once, erasure_archiving_exception_once, erasure_freedom_of_expression_verdict_cites_article_17_3_a, restriction_objection_pending_basis_cites_article_18_1_d, restriction_unsure_unlawfulness_is_referred_to_article_18_1_b, restriction_without_a_situation_cites_article_18_1, a_duplicate_key_reads_out_once, a_wrong_type_reads_out_once, a_term_that_is_not_a_profile_reads_out_once, an_absent_request_type_reads_out_once]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
