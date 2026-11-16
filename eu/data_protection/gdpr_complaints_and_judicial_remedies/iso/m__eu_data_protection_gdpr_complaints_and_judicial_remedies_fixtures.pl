% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_complaints_and_judicial_remedies_fixtures, [gdpr_complaints_and_judicial_remedies_subject/1, gdpr_complaints_and_judicial_remedies_profile_for/2, gdpr_complaints_and_judicial_remedies_assess/2]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_complaints_and_judicial_remedies_gdpr_complaints_and_judicial_remedies, [complaint_right/3, authority_decision_remedy_right/3, authority_inaction_remedy_right/4, controller_processor_remedy_right/3, controller_processor_forum/3]).

fixture(complaint_data_subject_who_considers, complaint_right, [attribute(is_data_subject, true), attribute(data_subject_considers_processing_infringes_regulation, true)]).
fixture(complaint_data_subject_who_does_not_consider, complaint_right, [attribute(is_data_subject, true), attribute(data_subject_considers_processing_infringes_regulation, false)]).
fixture(complaint_not_a_data_subject, complaint_right, [attribute(is_data_subject, false), attribute(data_subject_considers_processing_infringes_regulation, true)]).
fixture(complaint_consideration_not_stated, complaint_right, [attribute(is_data_subject, true)]).
fixture(complaint_settled_false_before_missing, complaint_right, [attribute(data_subject_considers_processing_infringes_regulation, false)]).
fixture(decision_binding_and_concerning, authority_decision_remedy_right, [attribute(decision_is_legally_binding, true), attribute(decision_concerns_the_caller, true)]).
fixture(decision_not_binding, authority_decision_remedy_right, [attribute(decision_is_legally_binding, false), attribute(decision_concerns_the_caller, true)]).
fixture(decision_not_concerning, authority_decision_remedy_right, [attribute(decision_is_legally_binding, true), attribute(decision_concerns_the_caller, false)]).
fixture(decision_binding_unsure, authority_decision_remedy_right, [attribute(decision_is_legally_binding, unsure), attribute(decision_concerns_the_caller, true)]).
fixture(decision_concerns_unsure, authority_decision_remedy_right, [attribute(decision_is_legally_binding, true), attribute(decision_concerns_the_caller, unsure)]).
fixture(decision_unsure_with_concern_missing, authority_decision_remedy_right, [attribute(decision_is_legally_binding, unsure)]).
fixture(inaction_unhandled_competent, authority_inaction_remedy_right, [attribute(is_data_subject, true), attribute(complaint_lodged_under_article_77, true), attribute(authority_competent_under_articles_55_and_56, attested(true, attestation(host_attestation_service, '2026-11-12T09:00:00Z', competence_attested_by_host, none))), attribute(authority_handled_the_complaint, false)]).
fixture(inaction_handled_and_informed, authority_inaction_remedy_right, [attribute(is_data_subject, true), attribute(complaint_lodged_under_article_77, true), attribute(authority_competent_under_articles_55_and_56, attested(true, attestation(host_attestation_service, '2026-11-12T09:00:00Z', competence_attested_by_host, none))), attribute(authority_handled_the_complaint, true), attribute(three_months_from_the_complaint_have_passed, true), attribute(authority_informed_on_progress_or_outcome, true)]).
fixture(inaction_uninformed_after_three_months, authority_inaction_remedy_right, [attribute(is_data_subject, true), attribute(complaint_lodged_under_article_77, true), attribute(authority_competent_under_articles_55_and_56, attested(true, attestation(host_attestation_service, '2026-11-12T09:00:00Z', competence_attested_by_host, url('https://example.org/competence', '2026-11-12')))), attribute(authority_handled_the_complaint, true), attribute(three_months_from_the_complaint_have_passed, true), attribute(authority_informed_on_progress_or_outcome, false)]).
fixture(inaction_handled_within_three_months, authority_inaction_remedy_right, [attribute(is_data_subject, true), attribute(complaint_lodged_under_article_77, true), attribute(authority_competent_under_articles_55_and_56, attested(true, attestation(host_attestation_service, '2026-11-12T09:00:00Z', competence_attested_by_host, none))), attribute(authority_handled_the_complaint, true), attribute(three_months_from_the_complaint_have_passed, false)]).
fixture(inaction_authority_not_competent, authority_inaction_remedy_right, [attribute(is_data_subject, true), attribute(complaint_lodged_under_article_77, true), attribute(authority_competent_under_articles_55_and_56, attested(false, attestation(host_attestation_service, '2026-11-12T09:00:00Z', competence_attested_by_host, none))), attribute(authority_handled_the_complaint, false)]).
fixture(inaction_competence_not_stated, authority_inaction_remedy_right, [attribute(is_data_subject, true), attribute(complaint_lodged_under_article_77, true), attribute(authority_handled_the_complaint, false)]).
fixture(inaction_no_complaint_lodged, authority_inaction_remedy_right, [attribute(is_data_subject, true), attribute(complaint_lodged_under_article_77, false)]).
fixture(inaction_handling_not_stated, authority_inaction_remedy_right, [attribute(is_data_subject, true), attribute(complaint_lodged_under_article_77, true), attribute(authority_competent_under_articles_55_and_56, attested(true, attestation(host_attestation_service, '2026-11-12T09:00:00Z', competence_attested_by_host, none)))]).
fixture(judicial_data_subject_who_considers, controller_processor_remedy_right, [attribute(is_data_subject, true), attribute(data_subject_considers_rights_infringed_by_processing, true)]).
fixture(judicial_data_subject_who_does_not_consider, controller_processor_remedy_right, [attribute(is_data_subject, true), attribute(data_subject_considers_rights_infringed_by_processing, false)]).
fixture(judicial_not_a_data_subject, controller_processor_remedy_right, [attribute(is_data_subject, false), attribute(data_subject_considers_rights_infringed_by_processing, true)]).
fixture(forum_public_authority_defendant, controller_processor_forum, [attribute(defendant_is_member_state_public_authority_acting_in_public_powers, true)]).
fixture(forum_private_defendant, controller_processor_forum, [attribute(defendant_is_member_state_public_authority_acting_in_public_powers, false)]).
fixture(forum_exception_not_stated, controller_processor_forum, []).
fixture(input_unknown_key, complaint_right, [attribute(colour, blue)]).
fixture(input_crisp_key_unsure, controller_processor_remedy_right, [attribute(is_data_subject, unsure)]).
fixture(input_duplicate_key, authority_inaction_remedy_right, [attribute(is_data_subject, true), attribute(is_data_subject, false)]).
fixture(input_not_a_profile, authority_decision_remedy_right, not_a_profile).
fixture(input_mixed_problems, controller_processor_forum, [attribute(colour, blue), attribute(is_data_subject, true), attribute(is_data_subject, true)]).

gdpr_complaints_and_judicial_remedies_subject(Subject) :-
    fixture(Subject, _, _).

gdpr_complaints_and_judicial_remedies_profile_for(Subject, Profile) :-
    fixture(Subject, _, Profile).

gdpr_complaints_and_judicial_remedies_assess(Subject, gdpr_complaints_and_judicial_remedies_verdict(Result, Citations)) :-
    fixture(Subject, Query, Profile),
    query_answer(Query, Profile, Result, Citations).

query_answer(complaint_right, Profile, Result, Citations) :-
    complaint_right(Profile, Result, Citations).
query_answer(authority_decision_remedy_right, Profile, Result, Citations) :-
    authority_decision_remedy_right(Profile, Result, Citations).
query_answer(authority_inaction_remedy_right, Profile, Result, Citations) :-
    authority_inaction_remedy_right(Profile, Result, _Basis, Citations).
query_answer(controller_processor_remedy_right, Profile, Result, Citations) :-
    controller_processor_remedy_right(Profile, Result, Citations).
query_answer(controller_processor_forum, Profile, Result, Citations) :-
    controller_processor_forum(Profile, Result, Citations).
