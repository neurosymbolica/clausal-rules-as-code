% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_cooperation_with_the_supervisory_authority_tests_test_public_interface, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_lists_extra, [clausal_msort/2]).
:- use_module(m__eu_data_protection_gdpr_cooperation_with_the_supervisory_authority_gdpr_cooperation_with_the_supervisory_authority, [decide_gdpr_cooperation_with_the_supervisory_authority/2, gdpr_cooperation_with_the_supervisory_authority_status/2, gdpr_cooperation_with_the_supervisory_authority_checklist/2, gdpr_cooperation_with_the_supervisory_authority_decision_resolvable/1, gdpr_cooperation_with_the_supervisory_authority_status_values/1, cooperation_duty/4]).
:- use_module(m__eu_data_protection_gdpr_cooperation_with_the_supervisory_authority_fixtures, [gdpr_cooperation_with_the_supervisory_authority_subject/1, gdpr_cooperation_with_the_supervisory_authority_profile_for/2, gdpr_cooperation_with_the_supervisory_authority_assess/2]).

expected_verdict(controller_cooperated, cooperation_met, [cite(eu_reg_2016_679_art_31)]).
expected_verdict(controller_refused, cooperation_not_met, [cite(eu_reg_2016_679_art_31)]).
expected_verdict(representative_cooperated, cooperation_met, [cite(eu_reg_2016_679_art_31)]).
expected_verdict(not_bound, cooperation_not_required, [cite(eu_reg_2016_679_art_31)]).
expected_verdict(no_request, cooperation_not_required, [cite(eu_reg_2016_679_art_31)]).
expected_verdict(no_request_roles_absent, cooperation_not_required, [cite(eu_reg_2016_679_art_31)]).
expected_verdict(request_inside_tasks, cooperation_met, [cite(eu_reg_2016_679_art_31)]).
expected_verdict(request_outside_tasks, cooperation_not_required, [cite(eu_reg_2016_679_art_31)]).
expected_verdict(role_unknown, indeterminate([acts_as_controller]), []).
expected_verdict(role_stated_false, cooperation_not_required, [cite(eu_reg_2016_679_art_31)]).
expected_verdict(two_keys_missing, indeterminate([authority_request_made]), []).
expected_verdict(statement_missing_true, needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_31), cite(cooperation_statement)), [resolution(cite(cooperation_statement), not_attempted), inputs_relied_on([request_is_in_performance_of_authority_tasks - true, cooperation_given - absent])]), []).
expected_verdict(statement_missing_unsure, needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_31), cite(cooperation_statement)), [resolution(cite(cooperation_statement), not_attempted), inputs_relied_on([request_is_in_performance_of_authority_tasks - unsure, cooperation_given - absent])]), []).
expected_verdict(judgement_unsure, needs_legal_review(open_textured(request_is_in_performance_of_authority_tasks, cite(eu_reg_2016_679_art_31)), [inputs_relied_on([request_is_in_performance_of_authority_tasks - unsure])]), []).
expected_verdict(duplicate_and_unknown, input_problems([duplicate_key(acts_as_controller), unknown_key(colour)]), []).
expected_verdict(wrong_types, input_problems([wrong_type(acts_as_processor), wrong_type(cooperation_given)]), []).

subject_resolves_as_expected(Subject) :-
    expected_verdict(Subject, Status, Citations),
    findall(Verdict, gdpr_cooperation_with_the_supervisory_authority_assess(Subject, Verdict), Verdicts),
    Verdicts == [gdpr_cooperation_with_the_supervisory_authority_verdict(Status, Citations)].

subject_has_cited_checklist(Subject) :-
    gdpr_cooperation_with_the_supervisory_authority_profile_for(Subject, Profile),
    gdpr_cooperation_with_the_supervisory_authority_checklist(Profile, [FirstItem|OtherItems]),
    maplist(item_is_cited, [FirstItem|OtherItems]).

item_is_cited(item(_, _, cite(eu_reg_2016_679_art_31))).

subject_status(Subject, Status) :-
    gdpr_cooperation_with_the_supervisory_authority_profile_for(Subject, Profile),
    gdpr_cooperation_with_the_supervisory_authority_status(Profile, Status).

subject_duty(Subject, Result, Basis, Citations) :-
    gdpr_cooperation_with_the_supervisory_authority_profile_for(Subject, Profile),
    cooperation_duty(Profile, Result, Basis, Citations).

test(every_subject_has_an_expected_row) :-
    findall(Subject, gdpr_cooperation_with_the_supervisory_authority_subject(Subject), Subjects),
    findall(Subject, expected_verdict(Subject, _, _), ExpectedSubjects),
    clausal_msort(Subjects, Sorted),
    clausal_msort(ExpectedSubjects, Sorted).
test(every_subject_resolves_to_its_expected_verdict_once) :-
    findall(Subject, gdpr_cooperation_with_the_supervisory_authority_subject(Subject), Subjects),
    maplist(subject_resolves_as_expected, Subjects).
test(every_subject_has_a_non_empty_cited_checklist) :-
    findall(Subject, gdpr_cooperation_with_the_supervisory_authority_subject(Subject), Subjects),
    maplist(subject_has_cited_checklist, Subjects).
test(every_subject_is_resolvable) :-
    findall(Profile, (gdpr_cooperation_with_the_supervisory_authority_subject(Subject), gdpr_cooperation_with_the_supervisory_authority_profile_for(Subject, Profile)), Profiles),
    maplist(gdpr_cooperation_with_the_supervisory_authority_decision_resolvable, Profiles).
test(final_statuses_are_in_the_status_vocabulary) :-
    gdpr_cooperation_with_the_supervisory_authority_status_values(StatusValues),
    clausal_msort(StatusValues, [cooperation_met, cooperation_not_met, cooperation_not_required]).
test(cooperation_duty_met_copies_the_attested_statement) :-
    gdpr_cooperation_with_the_supervisory_authority_profile_for(controller_cooperated, Profile),
    Statement = attested(true, attestation(compliance_officer, recorded_on_twelfth_november, response_sent, none)),
    findall(Result - Basis - Citations, cooperation_duty(Profile, Result, Basis, Citations), Answers),
    Answers == [cooperation_met - [outside_fact(cooperation_given, Statement)] - [cite(eu_reg_2016_679_art_31)]].
test(cooperation_duty_not_met_copies_the_attested_statement) :-
    gdpr_cooperation_with_the_supervisory_authority_profile_for(controller_refused, Profile),
    Statement = attested(false, attestation(compliance_officer, recorded_on_twelfth_november, no_response_sent, none)),
    findall(Result - Basis - Citations, cooperation_duty(Profile, Result, Basis, Citations), Answers),
    Answers == [cooperation_not_met - [outside_fact(cooperation_given, Statement)] - [cite(eu_reg_2016_679_art_31)]].
test(cooperation_duty_document_evidence_is_copied) :-
    subject_duty(representative_cooperated, cooperation_met, [outside_fact(cooperation_given, attested(true, attestation(_, _, _, document(UploadId, Digest))))], [cite(eu_reg_2016_679_art_31)]),
    UploadId == upload_identifier_one,
    Digest == digest_value_one.
test(cooperation_duty_url_evidence_is_copied) :-
    subject_duty(request_inside_tasks, cooperation_met, [outside_fact(cooperation_given, attested(true, attestation(_, _, _, url(Address, RetrievedAt))))], [cite(eu_reg_2016_679_art_31)]),
    Address == address_of_record,
    RetrievedAt == retrieved_on_twelfth_november.
test(cooperation_duty_no_request_is_not_required) :-
    subject_duty(no_request_roles_absent, cooperation_not_required, [], [cite(eu_reg_2016_679_art_31)]).
test(cooperation_duty_outside_tasks_is_not_required) :-
    subject_duty(request_outside_tasks, cooperation_not_required, [], [cite(eu_reg_2016_679_art_31)]).
test(cooperation_duty_not_bound_is_not_required) :-
    subject_duty(not_bound, cooperation_not_required, [], [cite(eu_reg_2016_679_art_31)]).
test(cooperation_duty_names_the_first_missing_key) :-
    subject_duty(two_keys_missing, indeterminate([authority_request_made]), [], []).
test(cooperation_duty_absent_statement_is_a_cross_reference) :-
    subject_duty(statement_missing_true, needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_31), cite(cooperation_statement)), [resolution(cite(cooperation_statement), not_attempted), inputs_relied_on([request_is_in_performance_of_authority_tasks - true, cooperation_given - absent])]), [], []).
test(cooperation_duty_unsure_judgement_is_open_textured) :-
    subject_duty(judgement_unsure, needs_legal_review(open_textured(request_is_in_performance_of_authority_tasks, cite(eu_reg_2016_679_art_31)), [inputs_relied_on([request_is_in_performance_of_authority_tasks - unsure])]), [], []).
test(cooperation_duty_input_problems_come_first) :-
    subject_duty(wrong_types, input_problems([wrong_type(acts_as_processor), wrong_type(cooperation_given)]), [], []).
test(cooperation_duty_unbound_profile_is_wrong_type) :-
    findall(Result, cooperation_duty(_, Result, _, _), Results),
    Results == [input_problems([wrong_type(profile)])].
test(url_evidence_is_a_data_term) :-
    Evidence = url(address_of_record, retrieved_on_twelfth_november),
    Evidence = url(Address, RetrievedAt),
    Address == address_of_record,
    RetrievedAt == retrieved_on_twelfth_november.
test(document_evidence_is_a_data_term) :-
    Evidence = document(upload_identifier_one, digest_value_one),
    Evidence = document(UploadId, Digest),
    UploadId == upload_identifier_one,
    Digest == digest_value_one.
test(controller_cooperated_is_met) :-
    subject_status(controller_cooperated, cooperation_met).
test(controller_refused_is_not_met) :-
    subject_status(controller_refused, cooperation_not_met).
test(representative_cooperated_is_met) :-
    subject_status(representative_cooperated, cooperation_met).
test(not_bound_needs_no_cooperation) :-
    subject_status(not_bound, cooperation_not_required).
test(no_request_needs_no_cooperation) :-
    subject_status(no_request, cooperation_not_required).
test(no_request_decides_without_the_role_keys) :-
    subject_status(no_request_roles_absent, cooperation_not_required).
test(request_inside_tasks_is_met) :-
    subject_status(request_inside_tasks, cooperation_met).
test(request_outside_tasks_needs_no_cooperation) :-
    subject_status(request_outside_tasks, cooperation_not_required).
test(role_unknown_names_the_controller_key) :-
    subject_status(role_unknown, indeterminate([acts_as_controller])).
test(role_stated_false_is_not_required) :-
    subject_status(role_stated_false, cooperation_not_required).
test(two_keys_missing_names_only_the_first) :-
    subject_status(two_keys_missing, indeterminate([authority_request_made])).
test(an_absent_statement_is_a_cross_reference) :-
    subject_status(statement_missing_true, needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_31), cite(cooperation_statement)), _)).
test(an_absent_statement_refers_before_the_unsure_judgement) :-
    subject_status(statement_missing_unsure, needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_31), cite(cooperation_statement)), _)).
test(an_unsure_judgement_goes_to_a_lawyer) :-
    subject_status(judgement_unsure, needs_legal_review(open_textured(request_is_in_performance_of_authority_tasks, cite(eu_reg_2016_679_art_31)), _)).
test(duplicate_and_unknown_are_input_problems) :-
    subject_status(duplicate_and_unknown, input_problems([duplicate_key(acts_as_controller), unknown_key(colour)])).
test(wrong_types_are_input_problems) :-
    subject_status(wrong_types, input_problems([wrong_type(acts_as_processor), wrong_type(cooperation_given)])).
test(a_non_list_profile_is_wrong_type) :-
    decide_gdpr_cooperation_with_the_supervisory_authority(not_a_profile, gdpr_cooperation_with_the_supervisory_authority_verdict(input_problems([wrong_type(profile)]), [])).
test(the_checklist_of_a_met_case_is_all_met_and_cited) :-
    gdpr_cooperation_with_the_supervisory_authority_profile_for(controller_cooperated, Profile),
    gdpr_cooperation_with_the_supervisory_authority_checklist(Profile, Items),
    Items == [item(bound_by_article_31, met, cite(eu_reg_2016_679_art_31)), item(request_made, met, cite(eu_reg_2016_679_art_31)), item(request_in_performance_of_tasks, met, cite(eu_reg_2016_679_art_31)), item(cooperation_given, met, cite(eu_reg_2016_679_art_31))].

test(cooperation_duty_not_met_is_not_met_as_met, fail) :-
    subject_duty(controller_refused, cooperation_met, _, _).
test(controller_refused_is_not_met_as_met, fail) :-
    subject_status(controller_refused, cooperation_met).
test(controller_cooperated_is_not_not_met, fail) :-
    subject_status(controller_cooperated, cooperation_not_met).
test(not_bound_is_not_met, fail) :-
    subject_status(not_bound, cooperation_met).
test(no_request_is_not_met, fail) :-
    subject_status(no_request, cooperation_met).
test(request_outside_tasks_is_not_met, fail) :-
    subject_status(request_outside_tasks, cooperation_met).
test(role_stated_false_is_not_indeterminate, fail) :-
    subject_status(role_stated_false, indeterminate(_)).
test(the_outside_fact_is_never_a_missing_key, fail) :-
    subject_status(statement_missing_true, indeterminate(_)).
test(an_absent_statement_is_not_open_textured, fail) :-
    subject_status(statement_missing_unsure, needs_legal_review(open_textured(_, _), _)).
test(an_unsure_judgement_is_not_met, fail) :-
    subject_status(judgement_unsure, cooperation_met).
test(an_input_problem_profile_gets_no_final_verdict, fail) :-
    subject_status(wrong_types, cooperation_met).

cp_test_names([every_subject_has_an_expected_row, every_subject_resolves_to_its_expected_verdict_once, every_subject_has_a_non_empty_cited_checklist, every_subject_is_resolvable, final_statuses_are_in_the_status_vocabulary, cooperation_duty_met_copies_the_attested_statement, cooperation_duty_not_met_copies_the_attested_statement, cooperation_duty_document_evidence_is_copied, cooperation_duty_url_evidence_is_copied, cooperation_duty_no_request_is_not_required, cooperation_duty_outside_tasks_is_not_required, cooperation_duty_not_bound_is_not_required, cooperation_duty_names_the_first_missing_key, cooperation_duty_absent_statement_is_a_cross_reference, cooperation_duty_unsure_judgement_is_open_textured, cooperation_duty_input_problems_come_first, cooperation_duty_unbound_profile_is_wrong_type, url_evidence_is_a_data_term, document_evidence_is_a_data_term, controller_cooperated_is_met, controller_refused_is_not_met, representative_cooperated_is_met, not_bound_needs_no_cooperation, no_request_needs_no_cooperation, no_request_decides_without_the_role_keys, request_inside_tasks_is_met, request_outside_tasks_needs_no_cooperation, role_unknown_names_the_controller_key, role_stated_false_is_not_required, two_keys_missing_names_only_the_first, an_absent_statement_is_a_cross_reference, an_absent_statement_refers_before_the_unsure_judgement, an_unsure_judgement_goes_to_a_lawyer, duplicate_and_unknown_are_input_problems, wrong_types_are_input_problems, a_non_list_profile_is_wrong_type, the_checklist_of_a_met_case_is_all_met_and_cited]).
cp_test_fail_names([cooperation_duty_not_met_is_not_met_as_met, controller_refused_is_not_met_as_met, controller_cooperated_is_not_not_met, not_bound_is_not_met, no_request_is_not_met, request_outside_tasks_is_not_met, role_stated_false_is_not_indeterminate, the_outside_fact_is_never_a_missing_key, an_absent_statement_is_not_open_textured, an_unsure_judgement_is_not_met, an_input_problem_profile_gets_no_final_verdict]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
