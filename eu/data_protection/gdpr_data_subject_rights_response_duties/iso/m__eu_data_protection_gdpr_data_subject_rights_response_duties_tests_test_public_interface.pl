% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_data_subject_rights_response_duties_tests_test_public_interface, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_lists_extra, [clausal_msort/2]).
:- use_module(m__eu_data_protection_gdpr_data_subject_rights_response_duties_gdpr_data_subject_rights_response_duties, [decide_gdpr_data_subject_rights_response_duties/2, gdpr_data_subject_rights_response_duties_status/2, gdpr_data_subject_rights_response_duties_checklist/2, gdpr_data_subject_rights_response_duties_decision_resolvable/1, gdpr_data_subject_rights_response_duties_status_values/1, request_response_deadline/2, response_duties/2, recipient_notification/2, provenance/2, url/2, document/2]).
:- use_module(m__eu_data_protection_gdpr_data_subject_rights_response_duties_fixtures, [gdpr_data_subject_rights_response_duties_subject/1, gdpr_data_subject_rights_response_duties_profile_for/2, gdpr_data_subject_rights_response_duties_assess/2]).
:- use_module(m__eu_data_protection_gdpr_data_subject_rights_response_duties_queries, [gdpr_data_subject_rights_response_duties_what_if/4]).
:- use_module(m__eu_data_protection_gdpr_data_subject_rights_response_duties_kernel, [gdpr_data_subject_rights_response_duties_input_problems/2]).

expected_status(access_plain_must_comply, must_comply).
expected_status(access_manifestly_excessive_refused, need_not_comply).
expected_status(access_public_holiday_shift, must_comply).
expected_status(access_holiday_elsewhere_no_shift, must_comply).
expected_status(access_extension_necessary, must_comply).
expected_status(access_extension_not_necessary, must_comply).
expected_status(access_extension_unsure, must_comply).
expected_status(access_identity_doubts_suspended, suspended).
expected_status(access_identity_confirmed_complies, must_comply).
expected_status(access_legislative_restriction_attested, need_not_comply).
expected_status(access_legislative_restriction_denied, must_comply).
expected_status(access_unable_to_identify_refused, need_not_comply).
expected_status(erasure_legal_claims_exception, need_not_comply).
expected_status(erasure_without_exception_complies, must_comply).
expected_status(erasure_legal_obligation_not_attested, needs_legal_review).
expected_status(erasure_legal_obligation_attested, must_comply).
expected_status(rectification_recipients_informed, must_comply).
expected_status(rectification_recipients_excused, must_comply).
expected_status(rectification_grounds_missing, indeterminate).
expected_status(judgement_given_unsure_refers, needs_legal_review).
expected_status(crisp_key_given_unsure, input_problems).
expected_status(restriction_accuracy_contested, must_comply).
expected_status(restriction_not_engaged, need_not_comply).
expected_status(portability_engaged, must_comply).
expected_status(portability_rights_of_others, need_not_comply).
expected_status(objection_direct_marketing, must_comply).
expected_status(objection_not_direct_marketing, need_not_comply).
expected_status(objection_ground_missing, indeterminate).
expected_status(automated_decision_explicit_consent, need_not_comply).
expected_status(automated_decision_special_category_bar, must_comply).
expected_status(request_type_absent_manifestly_excessive, indeterminate).
expected_status(request_type_absent_not_excessive, indeterminate).
expected_status(duplicate_request_type, input_problems).
expected_status(unknown_key_given, input_problems).
expected_status(profile_not_a_list, input_problems).

expected_deadline(access_plain_must_comply, date(2026, 11, 30)).
expected_deadline(access_manifestly_excessive_refused, date(2026, 11, 30)).
expected_deadline(access_public_holiday_shift, date(2026, 12, 1)).
expected_deadline(access_holiday_elsewhere_no_shift, date(2026, 11, 30)).
expected_deadline(access_extension_necessary, date(2026, 4, 30)).
expected_deadline(access_extension_not_necessary, date(2026, 3, 2)).
expected_deadline(access_extension_unsure, needs_legal_review(open_textured(extension_necessary_for_complexity_and_number, cite(eu_reg_2016_679_art_12_3)), [inputs_relied_on([extension_necessary_for_complexity_and_number - unsure])])).
expected_deadline(access_identity_doubts_suspended, suspended(art12_6_identity_not_confirmed)).
expected_deadline(access_identity_confirmed_complies, date(2026, 11, 30)).
expected_deadline(request_type_absent_manifestly_excessive, date(2026, 11, 30)).
expected_deadline(duplicate_request_type, input_problems([duplicate_key(request_type)])).

expected_duties(access_plain_must_comply, [respond_with_action_taken(first_period, cite(eu_reg_2016_679_art_12_3))]).
expected_duties(access_manifestly_excessive_refused, [inform_of_reasons_and_remedies(first_period, cite(eu_reg_2016_679_art_12_4))]).
expected_duties(access_extension_necessary, [inform_of_extension_with_reasons(first_period, cite(eu_reg_2016_679_art_12_3)), respond_with_action_taken(extended_period, cite(eu_reg_2016_679_art_12_3))]).
expected_duties(access_extension_not_necessary, [respond_with_action_taken(first_period, cite(eu_reg_2016_679_art_12_3))]).
expected_duties(access_extension_unsure, needs_legal_review(open_textured(extension_necessary_for_complexity_and_number, cite(eu_reg_2016_679_art_12_3)), [inputs_relied_on([extension_necessary_for_complexity_and_number - unsure])])).
expected_duties(access_identity_doubts_suspended, suspended(art12_6_identity_not_confirmed)).
expected_duties(erasure_legal_claims_exception, [inform_of_reasons_and_remedies(first_period, cite(eu_reg_2016_679_art_12_4))]).
expected_duties(erasure_without_exception_complies, [respond_with_action_taken(first_period, cite(eu_reg_2016_679_art_12_3))]).
expected_duties(rectification_grounds_missing, indeterminate([personal_data_inaccurate, personal_data_incomplete_in_light_of_purposes])).
expected_duties(restriction_not_engaged, [inform_of_reasons_and_remedies(first_period, cite(eu_reg_2016_679_art_12_4))]).
expected_duties(portability_rights_of_others, [inform_of_reasons_and_remedies(first_period, cite(eu_reg_2016_679_art_12_4))]).
expected_duties(objection_direct_marketing, [respond_with_action_taken(first_period, cite(eu_reg_2016_679_art_12_3))]).
expected_duties(automated_decision_explicit_consent, [inform_of_reasons_and_remedies(first_period, cite(eu_reg_2016_679_art_12_4))]).
expected_duties(request_type_absent_manifestly_excessive, [inform_of_reasons_and_remedies(first_period, cite(eu_reg_2016_679_art_12_4))]).
expected_duties(request_type_absent_not_excessive, indeterminate([request_type])).
expected_duties(duplicate_request_type, input_problems([duplicate_key(request_type)])).
expected_duties(profile_not_a_list, input_problems([wrong_type(profile)])).

expected_recipients(access_plain_must_comply, [recipient_notification_not_applicable(cite(eu_reg_2016_679_art_19))]).
expected_recipients(erasure_legal_claims_exception, [recipient_notification_not_applicable(cite(eu_reg_2016_679_art_19))]).
expected_recipients(erasure_without_exception_complies, [communicate_to_each_recipient(cite(eu_reg_2016_679_art_19))]).
expected_recipients(rectification_recipients_informed, [communicate_to_each_recipient(cite(eu_reg_2016_679_art_19)), inform_data_subject_of_recipients(cite(eu_reg_2016_679_art_19))]).
expected_recipients(rectification_recipients_excused, [recipient_notification_excused(cite(eu_reg_2016_679_art_19))]).
expected_recipients(restriction_accuracy_contested, [recipient_notification_not_applicable(cite(eu_reg_2016_679_art_19))]).
expected_recipients(access_identity_doubts_suspended, suspended(art12_6_identity_not_confirmed)).
expected_recipients(request_type_absent_manifestly_excessive, [recipient_notification_not_applicable(cite(eu_reg_2016_679_art_19))]).
expected_recipients(unknown_key_given, input_problems([unknown_key(favourite_colour)])).

subject_status(Subject, Status) :-
    gdpr_data_subject_rights_response_duties_profile_for(Subject, Profile),
    gdpr_data_subject_rights_response_duties_status(Profile, Status).

subject_answer(QueryName, Subject, Answer) :-
    gdpr_data_subject_rights_response_duties_profile_for(Subject, Profile),
    call(QueryName, Profile, Answer).

all_subjects(Subjects) :-
    findall(Subject, gdpr_data_subject_rights_response_duties_subject(Subject), Subjects).

single_answer_subjects(QueryName, Subjects) :-
    findall(Subject, single_answer_subject(QueryName, Subject), Subjects).

single_answer_subject(QueryName, Subject) :-
    gdpr_data_subject_rights_response_duties_subject(Subject),
    findall(Answer, subject_answer(QueryName, Subject, Answer), Answers),
    length(Answers, 1).

matched_expectations(deadline, Matched) :-
    findall(Subject, (expected_deadline(Subject, Wanted), subject_answer(request_response_deadline, Subject, Got), Got == Wanted), Matched).
matched_expectations(duties, Matched) :-
    findall(Subject, (expected_duties(Subject, Wanted), subject_answer(response_duties, Subject, Got), Got == Wanted), Matched).
matched_expectations(recipients, Matched) :-
    findall(Subject, (expected_recipients(Subject, Wanted), subject_answer(recipient_notification, Subject, Got), Got == Wanted), Matched).

test(every_subject_resolves_to_its_expected_status) :-
    findall(Subject - Status, (gdpr_data_subject_rights_response_duties_subject(Subject), subject_status(Subject, Status)), Got),
    findall(Subject - Status, expected_status(Subject, Status), Expected),
    clausal_msort(Got, SortedGot),
    clausal_msort(Expected, SortedExpected),
    SortedGot == SortedExpected.
test(every_status_is_a_declared_status_value) :-
    gdpr_data_subject_rights_response_duties_status_values(StatusValues),
    findall(Subject, (gdpr_data_subject_rights_response_duties_subject(Subject), subject_status(Subject, Status), member(Status, StatusValues)), Declared),
    all_subjects(Subjects),
    Declared == Subjects.
test(every_subject_has_a_non_empty_checklist_and_is_resolvable) :-
    findall(Subject, (gdpr_data_subject_rights_response_duties_profile_for(Subject, Profile), gdpr_data_subject_rights_response_duties_decision_resolvable(Profile), gdpr_data_subject_rights_response_duties_checklist(Profile, [_|_])), Checked),
    all_subjects(Subjects),
    clausal_msort(Checked, SortedChecked),
    clausal_msort(Subjects, SortedSubjects),
    SortedChecked == SortedSubjects.
test(every_subject_gets_exactly_one_deadline_answer) :-
    single_answer_subjects(request_response_deadline, Single),
    all_subjects(Subjects),
    Single == Subjects.
test(every_subject_gets_exactly_one_duties_answer) :-
    single_answer_subjects(response_duties, Single),
    all_subjects(Subjects),
    Single == Subjects.
test(every_subject_gets_exactly_one_recipient_answer) :-
    single_answer_subjects(recipient_notification, Single),
    all_subjects(Subjects),
    Single == Subjects.
test(deadlines_match_their_expectations) :-
    matched_expectations(deadline, Matched),
    findall(Subject, expected_deadline(Subject, _), Expected),
    Matched == Expected.
test(response_duties_match_their_expectations) :-
    matched_expectations(duties, Matched),
    findall(Subject, expected_duties(Subject, _), Expected),
    Matched == Expected.
test(recipient_notifications_match_their_expectations) :-
    matched_expectations(recipients, Matched),
    findall(Subject, expected_recipients(Subject, _), Expected),
    Matched == Expected.
test(deadline_is_read_element_wise) :-
    subject_answer(request_response_deadline, access_plain_must_comply, date(Year, Month, Day)),
    Year =:= 2026,
    Month =:= 11,
    Day =:= 30.
test(attested_holiday_on_the_last_day_moves_the_deadline) :-
    subject_answer(request_response_deadline, access_public_holiday_shift, Deadline),
    Deadline == date(2026, 12, 1).
test(extension_is_three_months_from_receipt) :-
    subject_answer(request_response_deadline, access_extension_necessary, Deadline),
    Deadline == date(2026, 4, 30).
test(refusal_owes_reasons_and_remedies) :-
    subject_answer(response_duties, access_manifestly_excessive_refused, Duties),
    Duties == [inform_of_reasons_and_remedies(first_period, cite(eu_reg_2016_679_art_12_4))].
test(excused_communication_gives_no_duty_to_inform_about_recipients) :-
    subject_answer(recipient_notification, rectification_recipients_excused, Duties),
    Duties == [recipient_notification_excused(cite(eu_reg_2016_679_art_19))].
test(access_plain_must_comply) :-
    subject_status(access_plain_must_comply, must_comply).
test(access_manifestly_excessive_is_refused) :-
    subject_status(access_manifestly_excessive_refused, need_not_comply).
test(identity_doubts_suspend) :-
    subject_status(access_identity_doubts_suspended, suspended).
test(identity_confirmed_complies) :-
    subject_status(access_identity_confirmed_complies, must_comply).
test(legislative_restriction_attested_relieves) :-
    subject_status(access_legislative_restriction_attested, need_not_comply).
test(legislative_restriction_denied_complies) :-
    subject_status(access_legislative_restriction_denied, must_comply).
test(erasure_legal_claims_relieves) :-
    subject_status(erasure_legal_claims_exception, need_not_comply).
test(erasure_without_exception_complies) :-
    subject_status(erasure_without_exception_complies, must_comply).
test(erasure_ground_e_not_attested_refers_as_cross_reference) :-
    gdpr_data_subject_rights_response_duties_profile_for(erasure_legal_obligation_not_attested, Profile),
    decide_gdpr_data_subject_rights_response_duties(Profile, gdpr_data_subject_rights_response_duties_verdict(needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_17_1_e), Target), _), _)),
    Target == cite(union_or_member_state_law_requiring_erasure).
test(erasure_ground_e_attested_complies) :-
    subject_status(erasure_legal_obligation_attested, must_comply).
test(unsure_judgement_refers_on_article_16) :-
    gdpr_data_subject_rights_response_duties_profile_for(judgement_given_unsure_refers, Profile),
    decide_gdpr_data_subject_rights_response_duties(Profile, gdpr_data_subject_rights_response_duties_verdict(Comply, _)),
    Comply == needs_legal_review(open_textured(personal_data_incomplete_in_light_of_purposes, cite(eu_reg_2016_679_art_16)), [inputs_relied_on([request_type - rectification, personal_data_incomplete_in_light_of_purposes - unsure])]).
test(unsure_crisp_key_is_an_input_problem) :-
    gdpr_data_subject_rights_response_duties_profile_for(crisp_key_given_unsure, Profile),
    gdpr_data_subject_rights_response_duties_input_problems(Profile, Problems),
    Problems == [wrong_type(personal_data_inaccurate)].
test(restriction_accuracy_contested_complies) :-
    subject_status(restriction_accuracy_contested, must_comply).
test(restriction_not_engaged_is_refused) :-
    subject_status(restriction_not_engaged, need_not_comply).
test(portability_engaged_complies) :-
    subject_status(portability_engaged, must_comply).
test(portability_rights_of_others_is_refused) :-
    subject_status(portability_rights_of_others, need_not_comply).
test(objection_to_direct_marketing_complies) :-
    subject_status(objection_direct_marketing, must_comply).
test(objection_without_direct_marketing_is_refused) :-
    subject_status(objection_not_direct_marketing, need_not_comply).
test(objection_ground_missing_is_indeterminate) :-
    gdpr_data_subject_rights_response_duties_profile_for(objection_ground_missing, Profile),
    decide_gdpr_data_subject_rights_response_duties(Profile, gdpr_data_subject_rights_response_duties_verdict(Comply, _)),
    Comply == indeterminate([objection_ground_claimed]).
test(automated_decision_with_explicit_consent_is_refused) :-
    subject_status(automated_decision_explicit_consent, need_not_comply).
test(special_category_bar_restores_the_duty) :-
    subject_status(automated_decision_special_category_bar, must_comply).
test(well_formed_profile_has_no_problem) :-
    gdpr_data_subject_rights_response_duties_profile_for(access_plain_must_comply, Profile),
    gdpr_data_subject_rights_response_duties_input_problems(Profile, Problems),
    Problems == [].
test(duplicate_key_is_named_once) :-
    gdpr_data_subject_rights_response_duties_profile_for(duplicate_request_type, Profile),
    gdpr_data_subject_rights_response_duties_input_problems(Profile, Problems),
    Problems == [duplicate_key(request_type)].
test(unknown_key_is_named) :-
    gdpr_data_subject_rights_response_duties_profile_for(unknown_key_given, Profile),
    gdpr_data_subject_rights_response_duties_input_problems(Profile, Problems),
    Problems == [unknown_key(favourite_colour)].
test(non_list_profile_is_wrong_type) :-
    gdpr_data_subject_rights_response_duties_profile_for(profile_not_a_list, Profile),
    gdpr_data_subject_rights_response_duties_input_problems(Profile, Problems),
    Problems == [wrong_type(profile)].
test(provenance_accepts_a_clause_and_a_citation_list) :-
    provenance(open_comply, [cite(eu_reg_2016_679_art_17_1_e)]).
test(url_accepts_a_location_and_a_retrieval_time) :-
    url('https://eur-lex.europa.eu/eli/reg/2016/679/oj', retrieved_at).
test(document_accepts_an_upload_and_a_checksum) :-
    document(upload_identifier, checksum).
test(attested_fact_with_url_evidence_is_read_like_bare_evidence) :-
    request_response_deadline([attribute(request_type, access), attribute(request_received_on, date(2026, 10, 29)), attribute(public_holidays, attested([date(2026, 11, 30)], attestation(by, at, reason, url('https://eur-lex.europa.eu', retrieved_at))))], Deadline),
    Deadline == date(2026, 12, 1).
test(attested_fact_with_document_evidence_is_read_like_bare_evidence) :-
    request_response_deadline([attribute(request_type, access), attribute(request_received_on, date(2026, 10, 29)), attribute(public_holidays, attested([date(2026, 11, 30)], attestation(by, at, reason, document(upload_identifier, checksum))))], Deadline),
    Deadline == date(2026, 12, 1).
test(facade_verdict_cites_the_article_15_basis) :-
    gdpr_data_subject_rights_response_duties_assess(access_plain_must_comply, Verdict),
    Verdict == gdpr_data_subject_rights_response_duties_verdict(must_comply, [eu_reg_2016_679_art_15_1]).
test(facade_verdict_of_a_refusal_is_need_not_comply) :-
    gdpr_data_subject_rights_response_duties_assess(access_manifestly_excessive_refused, gdpr_data_subject_rights_response_duties_verdict(need_not_comply, _)).
test(what_if_manifestly_excessive_refuses) :-
    gdpr_data_subject_rights_response_duties_profile_for(access_plain_must_comply, Profile),
    gdpr_data_subject_rights_response_duties_what_if(Profile, request_manifestly_unfounded_or_excessive, true, Status),
    Status == need_not_comply.
test(what_if_identity_confirmed_lifts_the_suspension) :-
    gdpr_data_subject_rights_response_duties_profile_for(access_identity_doubts_suspended, Profile),
    gdpr_data_subject_rights_response_duties_what_if(Profile, identity_confirmed, true, Status),
    Status == must_comply.

test(holiday_elsewhere_does_not_move_the_deadline, fail) :-
    subject_answer(request_response_deadline, access_holiday_elsewhere_no_shift, date(2026, 12, 1)).
test(extension_is_not_the_step_by_step_date, fail) :-
    subject_answer(request_response_deadline, access_extension_necessary, date(2026, 4, 28)).
test(refusal_owes_no_response_with_action_taken, fail) :-
    subject_answer(response_duties, access_manifestly_excessive_refused, [respond_with_action_taken(_, _)]).
test(excused_communication_is_not_the_communicate_list, fail) :-
    subject_answer(recipient_notification, rectification_recipients_excused, [communicate_to_each_recipient(_)|_]).
test(access_plain_is_not_refused, fail) :-
    subject_status(access_plain_must_comply, need_not_comply).
test(access_manifestly_excessive_is_not_must_comply, fail) :-
    subject_status(access_manifestly_excessive_refused, must_comply).
test(identity_confirmed_is_not_suspended, fail) :-
    subject_status(access_identity_confirmed_complies, suspended).
test(erasure_without_exception_is_not_refused, fail) :-
    subject_status(erasure_without_exception_complies, need_not_comply).
test(special_category_bar_is_not_refused, fail) :-
    subject_status(automated_decision_special_category_bar, need_not_comply).
test(provenance_rejects_a_citation_that_is_not_a_list, fail) :-
    provenance(open_comply, cite(eu_reg_2016_679_art_17_1_e)).
test(url_rejects_an_unbound_location, fail) :-
    url(_, retrieved_at).
test(document_rejects_an_unbound_checksum, fail) :-
    document(upload_identifier, _).

cp_test_names([every_subject_resolves_to_its_expected_status, every_status_is_a_declared_status_value, every_subject_has_a_non_empty_checklist_and_is_resolvable, every_subject_gets_exactly_one_deadline_answer, every_subject_gets_exactly_one_duties_answer, every_subject_gets_exactly_one_recipient_answer, deadlines_match_their_expectations, response_duties_match_their_expectations, recipient_notifications_match_their_expectations, deadline_is_read_element_wise, attested_holiday_on_the_last_day_moves_the_deadline, extension_is_three_months_from_receipt, refusal_owes_reasons_and_remedies, excused_communication_gives_no_duty_to_inform_about_recipients, access_plain_must_comply, access_manifestly_excessive_is_refused, identity_doubts_suspend, identity_confirmed_complies, legislative_restriction_attested_relieves, legislative_restriction_denied_complies, erasure_legal_claims_relieves, erasure_without_exception_complies, erasure_ground_e_not_attested_refers_as_cross_reference, erasure_ground_e_attested_complies, unsure_judgement_refers_on_article_16, unsure_crisp_key_is_an_input_problem, restriction_accuracy_contested_complies, restriction_not_engaged_is_refused, portability_engaged_complies, portability_rights_of_others_is_refused, objection_to_direct_marketing_complies, objection_without_direct_marketing_is_refused, objection_ground_missing_is_indeterminate, automated_decision_with_explicit_consent_is_refused, special_category_bar_restores_the_duty, well_formed_profile_has_no_problem, duplicate_key_is_named_once, unknown_key_is_named, non_list_profile_is_wrong_type, provenance_accepts_a_clause_and_a_citation_list, url_accepts_a_location_and_a_retrieval_time, document_accepts_an_upload_and_a_checksum, attested_fact_with_url_evidence_is_read_like_bare_evidence, attested_fact_with_document_evidence_is_read_like_bare_evidence, facade_verdict_cites_the_article_15_basis, facade_verdict_of_a_refusal_is_need_not_comply, what_if_manifestly_excessive_refuses, what_if_identity_confirmed_lifts_the_suspension]).
cp_test_fail_names([holiday_elsewhere_does_not_move_the_deadline, extension_is_not_the_step_by_step_date, refusal_owes_no_response_with_action_taken, excused_communication_is_not_the_communicate_list, access_plain_is_not_refused, access_manifestly_excessive_is_not_must_comply, identity_confirmed_is_not_suspended, erasure_without_exception_is_not_refused, special_category_bar_is_not_refused, provenance_rejects_a_citation_that_is_not_a_list, url_rejects_an_unbound_location, document_rejects_an_unbound_checksum]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
