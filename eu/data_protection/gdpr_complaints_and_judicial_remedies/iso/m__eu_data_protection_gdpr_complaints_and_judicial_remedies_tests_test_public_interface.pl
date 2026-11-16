% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_complaints_and_judicial_remedies_tests_test_public_interface, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_complaints_and_judicial_remedies_gdpr_complaints_and_judicial_remedies, [complaint_right/3, authority_decision_remedy_right/3, authority_inaction_remedy_right/4, controller_processor_remedy_right/3, controller_processor_forum/3, decide_gdpr_complaints_and_judicial_remedies/2, gdpr_complaints_and_judicial_remedies_status/2, gdpr_complaints_and_judicial_remedies_checklist/2, gdpr_complaints_and_judicial_remedies_decision_resolvable/1, gdpr_complaints_and_judicial_remedies_status_values/1]).
:- use_module(m__eu_data_protection_gdpr_complaints_and_judicial_remedies_kernel, [gdpr_complaints_and_judicial_remedies_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_complaints_and_judicial_remedies_fixtures, [gdpr_complaints_and_judicial_remedies_subject/1, gdpr_complaints_and_judicial_remedies_profile_for/2, gdpr_complaints_and_judicial_remedies_assess/2]).

answers_once(Subject) :-
    findall(Verdict, gdpr_complaints_and_judicial_remedies_assess(Subject, Verdict), Verdicts),
    length(Verdicts, 1).

has_cited_checklist(Subject) :-
    gdpr_complaints_and_judicial_remedies_profile_for(Subject, Profile),
    gdpr_complaints_and_judicial_remedies_decision_resolvable(Profile),
    gdpr_complaints_and_judicial_remedies_checklist(Profile, [FirstItem|OtherItems]),
    maplist(cited_item, [FirstItem|OtherItems]).

cited_item(item(_, _, cite(_))).

test(every_fixture_subject_has_exactly_one_answer) :-
    findall(Subject, gdpr_complaints_and_judicial_remedies_subject(Subject), Subjects),
    Subjects = [_|_],
    maplist(answers_once, Subjects).
test(a_data_subject_who_considers_has_the_complaint_right) :-
    gdpr_complaints_and_judicial_remedies_assess(complaint_data_subject_who_considers, gdpr_complaints_and_judicial_remedies_verdict(complaint_right_exists, [cite(eu_reg_2016_679_art_77_1)])).
test(the_near_miss_without_the_consideration_has_no_complaint_right) :-
    gdpr_complaints_and_judicial_remedies_assess(complaint_data_subject_who_does_not_consider, gdpr_complaints_and_judicial_remedies_verdict(no_complaint_right, [cite(eu_reg_2016_679_art_77_1)])).
test(the_near_miss_not_a_data_subject_has_no_complaint_right) :-
    gdpr_complaints_and_judicial_remedies_assess(complaint_not_a_data_subject, gdpr_complaints_and_judicial_remedies_verdict(no_complaint_right, [cite(eu_reg_2016_679_art_77_1)])).
test(an_unstated_consideration_is_named_as_missing) :-
    gdpr_complaints_and_judicial_remedies_assess(complaint_consideration_not_stated, gdpr_complaints_and_judicial_remedies_verdict(indeterminate([data_subject_considers_processing_infringes_regulation]), [])).
test(a_settled_false_decides_before_the_missing_data_subject_key) :-
    gdpr_complaints_and_judicial_remedies_assess(complaint_settled_false_before_missing, gdpr_complaints_and_judicial_remedies_verdict(no_complaint_right, [cite(eu_reg_2016_679_art_77_1)])).
test(a_binding_decision_concerning_the_caller_gives_the_remedy) :-
    gdpr_complaints_and_judicial_remedies_assess(decision_binding_and_concerning, gdpr_complaints_and_judicial_remedies_verdict(decision_remedy_right_exists, [cite(eu_reg_2016_679_art_78_1)])).
test(the_near_miss_non_binding_decision_gives_no_remedy) :-
    gdpr_complaints_and_judicial_remedies_assess(decision_not_binding, gdpr_complaints_and_judicial_remedies_verdict(no_decision_remedy_right, [cite(eu_reg_2016_679_art_78_1)])).
test(the_near_miss_decision_not_concerning_gives_no_remedy) :-
    gdpr_complaints_and_judicial_remedies_assess(decision_not_concerning, gdpr_complaints_and_judicial_remedies_verdict(no_decision_remedy_right, [cite(eu_reg_2016_679_art_78_1)])).
test(an_unsure_binding_goes_to_a_lawyer) :-
    gdpr_complaints_and_judicial_remedies_assess(decision_binding_unsure, gdpr_complaints_and_judicial_remedies_verdict(needs_legal_review(open_textured(decision_is_legally_binding, cite(eu_reg_2016_679_art_78_1)), [inputs_relied_on([decision_is_legally_binding - unsure, decision_concerns_the_caller - true])]), [])).
test(an_unsure_concern_goes_to_a_lawyer) :-
    gdpr_complaints_and_judicial_remedies_assess(decision_concerns_unsure, gdpr_complaints_and_judicial_remedies_verdict(needs_legal_review(open_textured(decision_concerns_the_caller, cite(eu_reg_2016_679_art_78_1)), [inputs_relied_on([decision_is_legally_binding - true, decision_concerns_the_caller - unsure])]), [])).
test(an_unsure_judgement_still_names_the_missing_one) :-
    gdpr_complaints_and_judicial_remedies_assess(decision_unsure_with_concern_missing, gdpr_complaints_and_judicial_remedies_verdict(indeterminate([decision_concerns_the_caller]), [])).
test(an_unhandled_complaint_to_a_competent_authority_gives_the_remedy) :-
    gdpr_complaints_and_judicial_remedies_assess(inaction_unhandled_competent, gdpr_complaints_and_judicial_remedies_verdict(inaction_remedy_right_exists, [cite(eu_reg_2016_679_art_78_2)])).
test(the_near_miss_handled_and_informed_gives_no_remedy) :-
    gdpr_complaints_and_judicial_remedies_assess(inaction_handled_and_informed, gdpr_complaints_and_judicial_remedies_verdict(no_inaction_remedy_right, [cite(eu_reg_2016_679_art_78_2)])).
test(no_informing_after_three_months_gives_the_remedy) :-
    gdpr_complaints_and_judicial_remedies_assess(inaction_uninformed_after_three_months, gdpr_complaints_and_judicial_remedies_verdict(inaction_remedy_right_exists, [cite(eu_reg_2016_679_art_78_2)])).
test(the_near_miss_within_three_months_gives_no_remedy) :-
    gdpr_complaints_and_judicial_remedies_assess(inaction_handled_within_three_months, gdpr_complaints_and_judicial_remedies_verdict(no_inaction_remedy_right, [cite(eu_reg_2016_679_art_78_2)])).
test(the_near_miss_attested_not_competent_gives_no_remedy) :-
    gdpr_complaints_and_judicial_remedies_assess(inaction_authority_not_competent, gdpr_complaints_and_judicial_remedies_verdict(no_inaction_remedy_right, [cite(eu_reg_2016_679_art_78_2)])).
test(an_absent_competence_statement_refers) :-
    gdpr_complaints_and_judicial_remedies_assess(inaction_competence_not_stated, gdpr_complaints_and_judicial_remedies_verdict(needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_78_2), cite(competence_statement)), [resolution(cite(competence_statement), not_attempted), inputs_relied_on([authority_competent_under_articles_55_and_56 - absent])]), [])).
test(no_complaint_lodged_gives_no_inaction_remedy) :-
    gdpr_complaints_and_judicial_remedies_assess(inaction_no_complaint_lodged, gdpr_complaints_and_judicial_remedies_verdict(no_inaction_remedy_right, [cite(eu_reg_2016_679_art_78_2)])).
test(an_unstated_handling_is_named_as_missing) :-
    gdpr_complaints_and_judicial_remedies_assess(inaction_handling_not_stated, gdpr_complaints_and_judicial_remedies_verdict(indeterminate([authority_handled_the_complaint]), [])).
test(a_data_subject_who_considers_rights_infringed_has_the_remedy) :-
    gdpr_complaints_and_judicial_remedies_assess(judicial_data_subject_who_considers, gdpr_complaints_and_judicial_remedies_verdict(judicial_remedy_right_exists, [cite(eu_reg_2016_679_art_79_1)])).
test(the_near_miss_without_the_consideration_has_no_judicial_remedy) :-
    gdpr_complaints_and_judicial_remedies_assess(judicial_data_subject_who_does_not_consider, gdpr_complaints_and_judicial_remedies_verdict(no_judicial_remedy_right, [cite(eu_reg_2016_679_art_79_1)])).
test(the_near_miss_not_a_data_subject_has_no_judicial_remedy) :-
    gdpr_complaints_and_judicial_remedies_assess(judicial_not_a_data_subject, gdpr_complaints_and_judicial_remedies_verdict(no_judicial_remedy_right, [cite(eu_reg_2016_679_art_79_1)])).
test(a_public_authority_defendant_gives_the_establishment_courts_only) :-
    gdpr_complaints_and_judicial_remedies_assess(forum_public_authority_defendant, gdpr_complaints_and_judicial_remedies_verdict(forum_establishment_state_only, [cite(eu_reg_2016_679_art_79_2)])).
test(the_near_miss_private_defendant_gives_both_courts) :-
    gdpr_complaints_and_judicial_remedies_assess(forum_private_defendant, gdpr_complaints_and_judicial_remedies_verdict(forum_establishment_or_habitual_residence_state, [cite(eu_reg_2016_679_art_79_2)])).
test(an_unstated_exception_is_named_as_missing) :-
    gdpr_complaints_and_judicial_remedies_assess(forum_exception_not_stated, gdpr_complaints_and_judicial_remedies_verdict(indeterminate([defendant_is_member_state_public_authority_acting_in_public_powers]), [])).
test(an_unknown_key_is_an_input_problem) :-
    gdpr_complaints_and_judicial_remedies_assess(input_unknown_key, gdpr_complaints_and_judicial_remedies_verdict(input_problems([unknown_key(colour)]), [])).
test(a_crisp_key_given_unsure_is_wrong_type) :-
    gdpr_complaints_and_judicial_remedies_assess(input_crisp_key_unsure, gdpr_complaints_and_judicial_remedies_verdict(input_problems([wrong_type(is_data_subject)]), [])).
test(a_repeated_key_is_a_duplicate) :-
    gdpr_complaints_and_judicial_remedies_assess(input_duplicate_key, gdpr_complaints_and_judicial_remedies_verdict(input_problems([duplicate_key(is_data_subject)]), [])).
test(a_term_that_is_not_an_attribute_list_is_wrong_type_profile) :-
    gdpr_complaints_and_judicial_remedies_assess(input_not_a_profile, gdpr_complaints_and_judicial_remedies_verdict(input_problems([wrong_type(profile)]), [])).
test(contract_problems_come_before_unknown_keys) :-
    gdpr_complaints_and_judicial_remedies_assess(input_mixed_problems, gdpr_complaints_and_judicial_remedies_verdict(input_problems([duplicate_key(is_data_subject), unknown_key(colour)]), [])).
test(direct_complaint_right_exists) :-
    complaint_right([attribute(is_data_subject, true), attribute(data_subject_considers_processing_infringes_regulation, true)], complaint_right_exists, [cite(eu_reg_2016_679_art_77_1)]).
test(direct_complaint_right_refused_for_a_non_data_subject) :-
    complaint_right([attribute(is_data_subject, false)], no_complaint_right, [cite(eu_reg_2016_679_art_77_1)]).
test(direct_complaint_right_names_the_first_missing_key) :-
    complaint_right([], indeterminate([is_data_subject]), []).
test(direct_complaint_right_reports_input_problems) :-
    complaint_right([attribute(colour, blue)], input_problems([unknown_key(colour)]), []).
test(direct_decision_remedy_exists) :-
    authority_decision_remedy_right([attribute(decision_is_legally_binding, true), attribute(decision_concerns_the_caller, true)], decision_remedy_right_exists, [cite(eu_reg_2016_679_art_78_1)]).
test(direct_decision_remedy_refused_when_both_judgements_are_false) :-
    findall(Result - Citations, authority_decision_remedy_right([attribute(decision_is_legally_binding, false), attribute(decision_concerns_the_caller, false)], Result, Citations), Answers),
    Answers == [no_decision_remedy_right - [cite(eu_reg_2016_679_art_78_1)]].
test(direct_decision_remedy_names_the_missing_binding_judgement) :-
    authority_decision_remedy_right([attribute(decision_concerns_the_caller, unsure)], indeterminate([decision_is_legally_binding]), []).
test(direct_decision_remedy_refers_both_unsure_on_the_first) :-
    authority_decision_remedy_right([attribute(decision_is_legally_binding, unsure), attribute(decision_concerns_the_caller, unsure)], needs_legal_review(open_textured(decision_is_legally_binding, cite(eu_reg_2016_679_art_78_1)), [inputs_relied_on([decision_is_legally_binding - unsure, decision_concerns_the_caller - unsure])]), []).
test(direct_decision_remedy_refers_an_unsure_concern) :-
    authority_decision_remedy_right([attribute(decision_is_legally_binding, true), attribute(decision_concerns_the_caller, unsure)], needs_legal_review(open_textured(decision_concerns_the_caller, cite(eu_reg_2016_679_art_78_1)), [inputs_relied_on([decision_is_legally_binding - true, decision_concerns_the_caller - unsure])]), []).
test(direct_decision_remedy_reports_input_problems) :-
    authority_decision_remedy_right([attribute(decision_is_legally_binding, maybe)], input_problems([wrong_type(decision_is_legally_binding)]), []).
test(direct_inaction_remedy_exists_with_url_evidence_copied) :-
    Attested = attested(true, attestation(host_attestation_service, '2026-11-12T09:00:00Z', competence_attested_by_host, url('https://example.org/competence', '2026-11-12'))),
    authority_inaction_remedy_right([attribute(is_data_subject, true), attribute(complaint_lodged_under_article_77, true), attribute(authority_competent_under_articles_55_and_56, Attested), attribute(authority_handled_the_complaint, false)], inaction_remedy_right_exists, [outside_fact(authority_competent_under_articles_55_and_56, Copied)], [cite(eu_reg_2016_679_art_78_2)]),
    Copied == Attested.
test(direct_inaction_remedy_exists_with_document_evidence_and_provenance_reason) :-
    Attested = attested(true, attestation(host_attestation_service, '2026-11-12T09:00:00Z', provenance(host_attestation_service, register_lookup), document(upload_0001, 'e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855'))),
    authority_inaction_remedy_right([attribute(is_data_subject, true), attribute(complaint_lodged_under_article_77, true), attribute(authority_competent_under_articles_55_and_56, Attested), attribute(authority_handled_the_complaint, true), attribute(three_months_from_the_complaint_have_passed, true), attribute(authority_informed_on_progress_or_outcome, false)], inaction_remedy_right_exists, [outside_fact(authority_competent_under_articles_55_and_56, Copied)], [cite(eu_reg_2016_679_art_78_2)]),
    Copied == Attested.
test(direct_inaction_remedy_refused_for_a_non_data_subject) :-
    authority_inaction_remedy_right([attribute(is_data_subject, false)], no_inaction_remedy_right, [], [cite(eu_reg_2016_679_art_78_2)]).
test(direct_inaction_attested_not_competent_decides_with_keys_absent) :-
    Attested = attested(false, attestation(host, at, reason, url('https://example.org/competence', '2026-11-12'))),
    authority_inaction_remedy_right([attribute(authority_competent_under_articles_55_and_56, Attested)], no_inaction_remedy_right, [outside_fact(authority_competent_under_articles_55_and_56, Copied)], [cite(eu_reg_2016_679_art_78_2)]),
    Copied == Attested.
test(direct_inaction_settled_failure_decides_with_competence_absent) :-
    authority_inaction_remedy_right([attribute(is_data_subject, true), attribute(complaint_lodged_under_article_77, true), attribute(authority_handled_the_complaint, true), attribute(three_months_from_the_complaint_have_passed, false)], no_inaction_remedy_right, [], [cite(eu_reg_2016_679_art_78_2)]).
test(direct_inaction_names_the_first_missing_key) :-
    authority_inaction_remedy_right([attribute(is_data_subject, true)], indeterminate([complaint_lodged_under_article_77]), [], []).
test(direct_inaction_period_not_needed_when_not_handled) :-
    authority_inaction_remedy_right([attribute(is_data_subject, true), attribute(complaint_lodged_under_article_77, true), attribute(authority_handled_the_complaint, false)], needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_78_2), cite(competence_statement)), [resolution(cite(competence_statement), not_attempted), inputs_relied_on([authority_competent_under_articles_55_and_56 - absent])]), [], []).
test(direct_inaction_reports_input_problems) :-
    authority_inaction_remedy_right([attribute(authority_competent_under_articles_55_and_56, true)], input_problems([wrong_type(authority_competent_under_articles_55_and_56)]), [], []).
test(direct_inaction_has_one_answer) :-
    findall(Result, authority_inaction_remedy_right([attribute(is_data_subject, true), attribute(complaint_lodged_under_article_77, false)], Result, _, _), Results),
    Results == [no_inaction_remedy_right].
test(direct_judicial_remedy_exists) :-
    controller_processor_remedy_right([attribute(is_data_subject, true), attribute(data_subject_considers_rights_infringed_by_processing, true)], judicial_remedy_right_exists, [cite(eu_reg_2016_679_art_79_1)]).
test(direct_judicial_remedy_refused_without_the_consideration) :-
    controller_processor_remedy_right([attribute(is_data_subject, true), attribute(data_subject_considers_rights_infringed_by_processing, false)], no_judicial_remedy_right, [cite(eu_reg_2016_679_art_79_1)]).
test(direct_judicial_remedy_names_the_missing_data_subject_key) :-
    controller_processor_remedy_right([attribute(data_subject_considers_rights_infringed_by_processing, true)], indeterminate([is_data_subject]), []).
test(direct_judicial_remedy_reports_input_problems) :-
    controller_processor_remedy_right([attribute(is_data_subject, unsure)], input_problems([wrong_type(is_data_subject)]), []).
test(direct_forum_establishment_state_only) :-
    controller_processor_forum([attribute(defendant_is_member_state_public_authority_acting_in_public_powers, true)], forum_establishment_state_only, [cite(eu_reg_2016_679_art_79_2)]).
test(direct_forum_establishment_or_habitual_residence_state) :-
    controller_processor_forum([attribute(defendant_is_member_state_public_authority_acting_in_public_powers, false)], forum_establishment_or_habitual_residence_state, [cite(eu_reg_2016_679_art_79_2)]).
test(direct_forum_names_the_missing_exception_key) :-
    controller_processor_forum([attribute(is_data_subject, true)], indeterminate([defendant_is_member_state_public_authority_acting_in_public_powers]), []).
test(direct_forum_reports_input_problems) :-
    controller_processor_forum([attribute(defendant_is_member_state_public_authority_acting_in_public_powers, true), attribute(defendant_is_member_state_public_authority_acting_in_public_powers, false)], input_problems([duplicate_key(defendant_is_member_state_public_authority_acting_in_public_powers)]), []).
test(direct_input_check_accepts_attestations_with_any_evidence) :-
    gdpr_complaints_and_judicial_remedies_input_problems([attribute(authority_competent_under_articles_55_and_56, attested(true, attestation(host, at, provenance(host, register_lookup), document(upload_0001, sha256_digest))))], []).
test(direct_input_check_refuses_a_three_argument_attestation) :-
    gdpr_complaints_and_judicial_remedies_input_problems([attribute(authority_competent_under_articles_55_and_56, attested(true, attestation(host, at, url('https://example.org', '2026-11-12'))))], [wrong_type(authority_competent_under_articles_55_and_56)]).
test(every_well_formed_profile_has_a_cited_checklist) :-
    maplist(has_cited_checklist, [complaint_data_subject_who_considers, decision_binding_unsure, inaction_competence_not_stated, inaction_unhandled_competent, judicial_not_a_data_subject, forum_exception_not_stated]).
test(a_met_right_is_cited_in_the_checklist) :-
    gdpr_complaints_and_judicial_remedies_profile_for(complaint_data_subject_who_considers, Profile),
    gdpr_complaints_and_judicial_remedies_checklist(Profile, Items),
    member(item(complaint_right, met, cite(eu_reg_2016_679_art_77_1)), Items).
test(a_complaint_right_makes_a_remedy_available) :-
    gdpr_complaints_and_judicial_remedies_profile_for(complaint_data_subject_who_considers, Profile),
    decide_gdpr_complaints_and_judicial_remedies(Profile, gdpr_complaints_and_judicial_remedies_verdict(remedy_available, [cite(eu_reg_2016_679_art_77_1)])).
test(the_facade_status_is_in_the_status_vocabulary) :-
    gdpr_complaints_and_judicial_remedies_profile_for(inaction_unhandled_competent, Profile),
    gdpr_complaints_and_judicial_remedies_status(Profile, Status),
    gdpr_complaints_and_judicial_remedies_status_values(StatusValues),
    member(Status, StatusValues).
test(an_inaction_remedy_makes_a_remedy_available) :-
    gdpr_complaints_and_judicial_remedies_profile_for(inaction_unhandled_competent, Profile),
    gdpr_complaints_and_judicial_remedies_status(Profile, remedy_available).

test(a_data_subject_who_considers_is_not_refused, fail) :-
    gdpr_complaints_and_judicial_remedies_assess(complaint_data_subject_who_considers, gdpr_complaints_and_judicial_remedies_verdict(no_complaint_right, _)).
test(the_near_miss_without_the_consideration_is_not_granted, fail) :-
    gdpr_complaints_and_judicial_remedies_assess(complaint_data_subject_who_does_not_consider, gdpr_complaints_and_judicial_remedies_verdict(complaint_right_exists, _)).
test(the_near_miss_not_a_data_subject_is_not_granted, fail) :-
    gdpr_complaints_and_judicial_remedies_assess(complaint_not_a_data_subject, gdpr_complaints_and_judicial_remedies_verdict(complaint_right_exists, _)).
test(a_settled_false_is_not_indeterminate, fail) :-
    gdpr_complaints_and_judicial_remedies_assess(complaint_settled_false_before_missing, gdpr_complaints_and_judicial_remedies_verdict(indeterminate(_), _)).
test(a_binding_decision_concerning_the_caller_is_not_refused, fail) :-
    gdpr_complaints_and_judicial_remedies_assess(decision_binding_and_concerning, gdpr_complaints_and_judicial_remedies_verdict(no_decision_remedy_right, _)).
test(the_near_miss_non_binding_decision_is_not_a_remedy, fail) :-
    gdpr_complaints_and_judicial_remedies_assess(decision_not_binding, gdpr_complaints_and_judicial_remedies_verdict(decision_remedy_right_exists, _)).
test(an_unsure_binding_is_not_a_remedy, fail) :-
    gdpr_complaints_and_judicial_remedies_assess(decision_binding_unsure, gdpr_complaints_and_judicial_remedies_verdict(decision_remedy_right_exists, _)).
test(an_unsure_judgement_with_a_missing_one_is_not_referred, fail) :-
    gdpr_complaints_and_judicial_remedies_assess(decision_unsure_with_concern_missing, gdpr_complaints_and_judicial_remedies_verdict(needs_legal_review(_, _), _)).
test(an_unhandled_complaint_is_not_refused, fail) :-
    gdpr_complaints_and_judicial_remedies_assess(inaction_unhandled_competent, gdpr_complaints_and_judicial_remedies_verdict(no_inaction_remedy_right, _)).
test(the_near_miss_handled_and_informed_is_not_a_remedy, fail) :-
    gdpr_complaints_and_judicial_remedies_assess(inaction_handled_and_informed, gdpr_complaints_and_judicial_remedies_verdict(inaction_remedy_right_exists, _)).
test(the_near_miss_within_three_months_is_not_a_remedy, fail) :-
    gdpr_complaints_and_judicial_remedies_assess(inaction_handled_within_three_months, gdpr_complaints_and_judicial_remedies_verdict(inaction_remedy_right_exists, _)).
test(the_near_miss_attested_not_competent_is_not_a_remedy, fail) :-
    gdpr_complaints_and_judicial_remedies_assess(inaction_authority_not_competent, gdpr_complaints_and_judicial_remedies_verdict(inaction_remedy_right_exists, _)).
test(an_absent_competence_statement_is_never_a_missing_key, fail) :-
    gdpr_complaints_and_judicial_remedies_assess(inaction_competence_not_stated, gdpr_complaints_and_judicial_remedies_verdict(indeterminate(_), _)).
test(a_data_subject_who_considers_rights_infringed_is_not_refused, fail) :-
    gdpr_complaints_and_judicial_remedies_assess(judicial_data_subject_who_considers, gdpr_complaints_and_judicial_remedies_verdict(no_judicial_remedy_right, _)).
test(the_near_miss_without_the_consideration_is_not_a_judicial_remedy, fail) :-
    gdpr_complaints_and_judicial_remedies_assess(judicial_data_subject_who_does_not_consider, gdpr_complaints_and_judicial_remedies_verdict(judicial_remedy_right_exists, _)).
test(a_public_authority_defendant_does_not_open_the_residence_courts, fail) :-
    gdpr_complaints_and_judicial_remedies_assess(forum_public_authority_defendant, gdpr_complaints_and_judicial_remedies_verdict(forum_establishment_or_habitual_residence_state, _)).
test(the_near_miss_private_defendant_is_not_establishment_only, fail) :-
    gdpr_complaints_and_judicial_remedies_assess(forum_private_defendant, gdpr_complaints_and_judicial_remedies_verdict(forum_establishment_state_only, _)).
test(a_repeated_key_gets_no_inaction_answer, fail) :-
    gdpr_complaints_and_judicial_remedies_assess(input_duplicate_key, gdpr_complaints_and_judicial_remedies_verdict(no_inaction_remedy_right, _)).
test(direct_inaction_remedy_with_document_evidence_is_not_refused, fail) :-
    authority_inaction_remedy_right([attribute(is_data_subject, true), attribute(complaint_lodged_under_article_77, true), attribute(authority_competent_under_articles_55_and_56, attested(true, attestation(host, at, provenance(host, register_lookup), document(upload_0001, sha256_digest)))), attribute(authority_handled_the_complaint, false)], no_inaction_remedy_right, _, _).
test(an_ill_formed_profile_has_no_checklist, fail) :-
    gdpr_complaints_and_judicial_remedies_profile_for(input_unknown_key, Profile),
    gdpr_complaints_and_judicial_remedies_checklist(Profile, _).

cp_test_names([every_fixture_subject_has_exactly_one_answer, a_data_subject_who_considers_has_the_complaint_right, the_near_miss_without_the_consideration_has_no_complaint_right, the_near_miss_not_a_data_subject_has_no_complaint_right, an_unstated_consideration_is_named_as_missing, a_settled_false_decides_before_the_missing_data_subject_key, a_binding_decision_concerning_the_caller_gives_the_remedy, the_near_miss_non_binding_decision_gives_no_remedy, the_near_miss_decision_not_concerning_gives_no_remedy, an_unsure_binding_goes_to_a_lawyer, an_unsure_concern_goes_to_a_lawyer, an_unsure_judgement_still_names_the_missing_one, an_unhandled_complaint_to_a_competent_authority_gives_the_remedy, the_near_miss_handled_and_informed_gives_no_remedy, no_informing_after_three_months_gives_the_remedy, the_near_miss_within_three_months_gives_no_remedy, the_near_miss_attested_not_competent_gives_no_remedy, an_absent_competence_statement_refers, no_complaint_lodged_gives_no_inaction_remedy, an_unstated_handling_is_named_as_missing, a_data_subject_who_considers_rights_infringed_has_the_remedy, the_near_miss_without_the_consideration_has_no_judicial_remedy, the_near_miss_not_a_data_subject_has_no_judicial_remedy, a_public_authority_defendant_gives_the_establishment_courts_only, the_near_miss_private_defendant_gives_both_courts, an_unstated_exception_is_named_as_missing, an_unknown_key_is_an_input_problem, a_crisp_key_given_unsure_is_wrong_type, a_repeated_key_is_a_duplicate, a_term_that_is_not_an_attribute_list_is_wrong_type_profile, contract_problems_come_before_unknown_keys, direct_complaint_right_exists, direct_complaint_right_refused_for_a_non_data_subject, direct_complaint_right_names_the_first_missing_key, direct_complaint_right_reports_input_problems, direct_decision_remedy_exists, direct_decision_remedy_refused_when_both_judgements_are_false, direct_decision_remedy_names_the_missing_binding_judgement, direct_decision_remedy_refers_both_unsure_on_the_first, direct_decision_remedy_refers_an_unsure_concern, direct_decision_remedy_reports_input_problems, direct_inaction_remedy_exists_with_url_evidence_copied, direct_inaction_remedy_exists_with_document_evidence_and_provenance_reason, direct_inaction_remedy_refused_for_a_non_data_subject, direct_inaction_attested_not_competent_decides_with_keys_absent, direct_inaction_settled_failure_decides_with_competence_absent, direct_inaction_names_the_first_missing_key, direct_inaction_period_not_needed_when_not_handled, direct_inaction_reports_input_problems, direct_inaction_has_one_answer, direct_judicial_remedy_exists, direct_judicial_remedy_refused_without_the_consideration, direct_judicial_remedy_names_the_missing_data_subject_key, direct_judicial_remedy_reports_input_problems, direct_forum_establishment_state_only, direct_forum_establishment_or_habitual_residence_state, direct_forum_names_the_missing_exception_key, direct_forum_reports_input_problems, direct_input_check_accepts_attestations_with_any_evidence, direct_input_check_refuses_a_three_argument_attestation, every_well_formed_profile_has_a_cited_checklist, a_met_right_is_cited_in_the_checklist, a_complaint_right_makes_a_remedy_available, the_facade_status_is_in_the_status_vocabulary, an_inaction_remedy_makes_a_remedy_available]).
cp_test_fail_names([a_data_subject_who_considers_is_not_refused, the_near_miss_without_the_consideration_is_not_granted, the_near_miss_not_a_data_subject_is_not_granted, a_settled_false_is_not_indeterminate, a_binding_decision_concerning_the_caller_is_not_refused, the_near_miss_non_binding_decision_is_not_a_remedy, an_unsure_binding_is_not_a_remedy, an_unsure_judgement_with_a_missing_one_is_not_referred, an_unhandled_complaint_is_not_refused, the_near_miss_handled_and_informed_is_not_a_remedy, the_near_miss_within_three_months_is_not_a_remedy, the_near_miss_attested_not_competent_is_not_a_remedy, an_absent_competence_statement_is_never_a_missing_key, a_data_subject_who_considers_rights_infringed_is_not_refused, the_near_miss_without_the_consideration_is_not_a_judicial_remedy, a_public_authority_defendant_does_not_open_the_residence_courts, the_near_miss_private_defendant_is_not_establishment_only, a_repeated_key_gets_no_inaction_answer, direct_inaction_remedy_with_document_evidence_is_not_refused, an_ill_formed_profile_has_no_checklist]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
