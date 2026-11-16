% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_cooperation_with_the_supervisory_authority_tests_test_public_interface, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_cooperation_with_the_supervisory_authority_gdpr_cooperation_with_the_supervisory_authority, [cooperation_duty/4, decide_gdpr_cooperation_with_the_supervisory_authority/2, gdpr_cooperation_with_the_supervisory_authority_status/2, gdpr_cooperation_with_the_supervisory_authority_checklist/2, gdpr_cooperation_with_the_supervisory_authority_decision_resolvable/1, gdpr_cooperation_with_the_supervisory_authority_status_values/1, provenance/2, attested/2, document/2, duplicate_key/1, indeterminate/1, input_problems/1, needs_legal_review/2, outside_fact/2, unknown_key/1, url/2, wrong_type/1]).
:- use_module(m__eu_data_protection_gdpr_cooperation_with_the_supervisory_authority_kernel, [gdpr_cooperation_with_the_supervisory_authority_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_cooperation_with_the_supervisory_authority_queries, [gdpr_cooperation_with_the_supervisory_authority_what_if/4]).
:- use_module(m__eu_data_protection_gdpr_cooperation_with_the_supervisory_authority_fixtures, [gdpr_cooperation_with_the_supervisory_authority_subject/1, gdpr_cooperation_with_the_supervisory_authority_profile_for/2, gdpr_cooperation_with_the_supervisory_authority_assess/2]).

expected_status(wrong_type_role_key, input_problems([wrong_type(acts_as_controller)])).
expected_status(wrong_type_control, cooperation_not_required).
expected_status(duplicate_role_key, input_problems([duplicate_key(acts_as_controller)])).
expected_status(duplicate_control, cooperation_not_required).
expected_status(unknown_key_given, input_problems([unknown_key(as_of_date)])).
expected_status(unknown_key_control, cooperation_not_required).
expected_status(no_request_made, cooperation_not_required).
expected_status(request_made_and_cooperated, cooperation_met).
expected_status(request_outside_authority_tasks, cooperation_not_required).
expected_status(request_within_authority_tasks, cooperation_met).
expected_status(caller_not_bound, cooperation_not_required).
expected_status(representative_alone_bound, cooperation_met).
expected_status(processor_key_missing, indeterminate([acts_as_processor])).
expected_status(processor_key_given, cooperation_met).
expected_status(request_key_missing, indeterminate([authority_request_made])).
expected_status(request_key_given, cooperation_not_required).
expected_status(cooperation_statement_absent, needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_31), cite(cooperation_statement)), [resolution(cite(cooperation_statement), not_attempted), inputs_relied_on([request_is_in_performance_of_authority_tasks - true, cooperation_given - absent])])).
expected_status(cooperation_statement_attested_false, cooperation_not_met).
expected_status(unsure_and_statement_absent, needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_31), cite(cooperation_statement)), [resolution(cite(cooperation_statement), not_attempted), inputs_relied_on([request_is_in_performance_of_authority_tasks - unsure, cooperation_given - absent])])).
expected_status(unsure_and_statement_given, needs_legal_review(open_textured(request_is_in_performance_of_authority_tasks, cite(eu_reg_2016_679_art_31)), [inputs_relied_on([request_is_in_performance_of_authority_tasks - unsure])])).
expected_status(tasks_judgement_unsure, needs_legal_review(open_textured(request_is_in_performance_of_authority_tasks, cite(eu_reg_2016_679_art_31)), [inputs_relied_on([request_is_in_performance_of_authority_tasks - unsure])])).
expected_status(tasks_judgement_true, cooperation_met).

near_miss(wrong_type_role_key, wrong_type_control).
near_miss(duplicate_role_key, duplicate_control).
near_miss(unknown_key_given, unknown_key_control).
near_miss(no_request_made, request_made_and_cooperated).
near_miss(request_outside_authority_tasks, request_within_authority_tasks).
near_miss(caller_not_bound, representative_alone_bound).
near_miss(processor_key_missing, processor_key_given).
near_miss(request_key_missing, request_key_given).
near_miss(cooperation_statement_absent, cooperation_statement_attested_false).
near_miss(unsure_and_statement_absent, unsure_and_statement_given).
near_miss(tasks_judgement_unsure, tasks_judgement_true).
near_miss(request_made_and_cooperated, cooperation_statement_attested_false).

subject_status(Subject, Status) :-
    gdpr_cooperation_with_the_supervisory_authority_assess(Subject, gdpr_cooperation_with_the_supervisory_authority_verdict(Status, _Citations)).

subject_resolves_as_expected(Subject) :-
    expected_status(Subject, Expected),
    findall(Status, subject_status(Subject, Status), Statuses),
    Statuses == [Expected].

subject_has_cited_checklist(Subject) :-
    gdpr_cooperation_with_the_supervisory_authority_profile_for(Subject, Profile),
    gdpr_cooperation_with_the_supervisory_authority_decision_resolvable(Profile),
    gdpr_cooperation_with_the_supervisory_authority_checklist(Profile, [FirstItem|OtherItems]),
    maplist(cited_item, [FirstItem|OtherItems]).

cited_item(item(_, _, cite(eu_reg_2016_679_art_31))).

control_differs(Positive - Control) :-
    subject_status(Positive, PositiveStatus),
    subject_status(Control, ControlStatus),
    dif(PositiveStatus, ControlStatus).

test(every_subject_has_an_expected_status) :-
    findall(Subject, gdpr_cooperation_with_the_supervisory_authority_subject(Subject), Subjects),
    length(Subjects, 22),
    maplist(expected_status_known, Subjects).
test(every_subject_resolves_to_its_expected_status) :-
    findall(Subject, gdpr_cooperation_with_the_supervisory_authority_subject(Subject), Subjects),
    maplist(subject_resolves_as_expected, Subjects).
test(every_subject_has_a_non_empty_cited_checklist) :-
    findall(Subject, gdpr_cooperation_with_the_supervisory_authority_subject(Subject), Subjects),
    maplist(subject_has_cited_checklist, Subjects).
test(every_near_miss_control_gets_another_verdict) :-
    findall(Positive - Control, near_miss(Positive, Control), Pairs),
    length(Pairs, 12),
    maplist(control_differs, Pairs).
test(final_statuses_are_in_the_status_values) :-
    gdpr_cooperation_with_the_supervisory_authority_status_values(StatusValues),
    subject_status(no_request_made, NotRequired),
    subject_status(request_made_and_cooperated, Met),
    subject_status(cooperation_statement_attested_false, NotMet),
    member(NotRequired, StatusValues),
    member(Met, StatusValues),
    member(NotMet, StatusValues).
test(wrong_type_role_key_is_an_input_problem) :-
    subject_status(wrong_type_role_key, Status),
    Status == input_problems([wrong_type(acts_as_controller)]).
test(wrong_type_control_is_not_required) :-
    subject_status(wrong_type_control, Status),
    Status == cooperation_not_required.
test(duplicate_role_key_is_an_input_problem) :-
    subject_status(duplicate_role_key, Status),
    Status == input_problems([duplicate_key(acts_as_controller)]).
test(unknown_key_is_named_once) :-
    subject_status(unknown_key_given, Status),
    Status == input_problems([unknown_key(as_of_date)]).
test(input_problems_carry_no_basis_and_no_citations) :-
    gdpr_cooperation_with_the_supervisory_authority_profile_for(duplicate_role_key, Profile),
    cooperation_duty(Profile, Result, Basis, Citations),
    Result == input_problems([duplicate_key(acts_as_controller)]),
    Basis == [],
    Citations == [].
test(a_non_list_profile_is_not_an_attribute_list) :-
    gdpr_cooperation_with_the_supervisory_authority_input_problems(not_a_profile, Problems),
    Problems == [wrong_type(profile)].
test(a_well_formed_profile_has_no_problem) :-
    gdpr_cooperation_with_the_supervisory_authority_profile_for(request_made_and_cooperated, Profile),
    gdpr_cooperation_with_the_supervisory_authority_input_problems(Profile, Problems),
    Problems == [].
test(no_request_is_not_required) :-
    subject_status(no_request_made, Status),
    Status == cooperation_not_required.
test(request_outside_tasks_is_not_required) :-
    subject_status(request_outside_authority_tasks, Status),
    Status == cooperation_not_required.
test(request_within_tasks_is_met) :-
    subject_status(request_within_authority_tasks, Status),
    Status == cooperation_met.
test(caller_not_bound_is_not_required) :-
    subject_status(caller_not_bound, Status),
    Status == cooperation_not_required.
test(representative_alone_is_bound_and_met) :-
    subject_status(representative_alone_bound, Status),
    Status == cooperation_met.
test(not_required_cites_article_31) :-
    decide_gdpr_cooperation_with_the_supervisory_authority([attribute(acts_as_controller, false), attribute(acts_as_processor, false), attribute(acts_as_representative_of_controller_or_processor, false), attribute(authority_request_made, true), attribute(request_is_in_performance_of_authority_tasks, true)], gdpr_cooperation_with_the_supervisory_authority_verdict(Status, Citations)),
    Status == cooperation_not_required,
    Citations == [cite(eu_reg_2016_679_art_31)].
test(missing_processor_is_named) :-
    subject_status(processor_key_missing, Status),
    Status == indeterminate([acts_as_processor]).
test(given_processor_is_met) :-
    subject_status(processor_key_given, Status),
    Status == cooperation_met.
test(missing_request_key_is_named) :-
    subject_status(request_key_missing, Status),
    Status == indeterminate([authority_request_made]).
test(absent_statement_refers_as_a_cross_reference) :-
    gdpr_cooperation_with_the_supervisory_authority_profile_for(cooperation_statement_absent, Profile),
    cooperation_duty(Profile, Result, Basis, Citations),
    Result == needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_31), cite(cooperation_statement)), [resolution(cite(cooperation_statement), not_attempted), inputs_relied_on([request_is_in_performance_of_authority_tasks - true, cooperation_given - absent])]),
    Basis == [],
    Citations == [].
test(absent_statement_refers_before_the_unsure_judgement) :-
    subject_status(unsure_and_statement_absent, Status),
    Status = needs_legal_review(Reason, _Context),
    Reason == cross_reference_unresolved(cite(eu_reg_2016_679_art_31), cite(cooperation_statement)).
test(unsure_judgement_is_open_textured) :-
    gdpr_cooperation_with_the_supervisory_authority_profile_for(tasks_judgement_unsure, Profile),
    cooperation_duty(Profile, Result, Basis, Citations),
    Result == needs_legal_review(open_textured(request_is_in_performance_of_authority_tasks, cite(eu_reg_2016_679_art_31)), [inputs_relied_on([request_is_in_performance_of_authority_tasks - unsure])]),
    Basis == [],
    Citations == [].
test(true_judgement_is_met) :-
    subject_status(tasks_judgement_true, Status),
    Status == cooperation_met.
test(attested_true_is_met_and_copied) :-
    gdpr_cooperation_with_the_supervisory_authority_profile_for(request_made_and_cooperated, Profile),
    cooperation_duty(Profile, Result, Basis, Citations),
    Result == cooperation_met,
    Basis == [outside_fact(cooperation_given, attested(true, attestation(compliance_desk, received_2026_11_12, reply_sent, none)))],
    Citations == [cite(eu_reg_2016_679_art_31)].
test(attested_false_is_not_met_and_copied) :-
    gdpr_cooperation_with_the_supervisory_authority_profile_for(cooperation_statement_attested_false, Profile),
    cooperation_duty(Profile, Result, Basis, Citations),
    Result == cooperation_not_met,
    Basis == [outside_fact(cooperation_given, attested(false, attestation(compliance_desk, received_2026_11_12, no_reply_sent, document(upload_seven, digest_seven))))],
    Citations == [cite(eu_reg_2016_679_art_31)].
test(evidence_url_is_copied_exactly) :-
    gdpr_cooperation_with_the_supervisory_authority_profile_for(tasks_judgement_true, Profile),
    cooperation_duty(Profile, cooperation_met, Basis, _Citations),
    Basis == [outside_fact(cooperation_given, attested(true, attestation(compliance_desk, received_2026_11_12, reply_sent, url(address_seven, retrieved_2026_11_12))))].
test(provenance_constructor_holds_for_any_source_and_detail) :-
    provenance(cite(eu_reg_2016_679_art_31), attested),
    provenance(cite(cooperation_statement), not_attempted).
test(provenance_item_builds_and_destructures) :-
    Item = provenance(cite(eu_reg_2016_679_art_31), attested),
    provenance(cite(eu_reg_2016_679_art_31), attested),
    Item = provenance(Source, Detail),
    Source == cite(eu_reg_2016_679_art_31),
    Detail == attested.
test(attested_constructor_answers_once) :-
    findall(given, attested(true, attestation(compliance_desk, received_2026_11_12, reply_sent, none)), Answers),
    Answers == [given].
test(document_constructor_answers_once) :-
    findall(given, document(upload_seven, digest_seven), Answers),
    Answers == [given].
test(duplicate_key_constructor_answers_once) :-
    findall(given, duplicate_key(acts_as_controller), Answers),
    Answers == [given].
test(indeterminate_constructor_answers_once) :-
    findall(given, indeterminate([authority_request_made]), Answers),
    Answers == [given].
test(input_problems_constructor_answers_once) :-
    findall(given, input_problems([wrong_type(acts_as_controller), unknown_key(as_of_date)]), Answers),
    Answers == [given].
test(needs_legal_review_constructor_answers_once) :-
    findall(given, needs_legal_review(open_textured(request_is_in_performance_of_authority_tasks, cite(eu_reg_2016_679_art_31)), [inputs_relied_on([request_is_in_performance_of_authority_tasks - unsure])]), Answers),
    Answers == [given].
test(outside_fact_constructor_answers_once) :-
    findall(given, outside_fact(cooperation_given, attested(false, attestation(compliance_desk, received_2026_11_12, no_reply_sent, document(upload_seven, digest_seven)))), Answers),
    Answers == [given].
test(unknown_key_constructor_answers_once) :-
    findall(given, unknown_key(as_of_date), Answers),
    Answers == [given].
test(url_constructor_answers_once) :-
    findall(given, url(address_seven, retrieved_2026_11_12), Answers),
    Answers == [given].
test(wrong_type_constructor_answers_once) :-
    findall(given, wrong_type(acts_as_controller), Answers),
    Answers == [given].
test(attested_holds_when_called_directly) :-
    attested(true, attestation(compliance_desk, received_2026_11_12, reply_sent, none)).
test(document_holds_when_called_directly) :-
    document(upload_seven, digest_seven).
test(duplicate_key_holds_when_called_directly) :-
    duplicate_key(acts_as_controller).
test(indeterminate_holds_when_called_directly) :-
    indeterminate([authority_request_made]).
test(input_problems_holds_when_called_directly) :-
    input_problems([duplicate_key(acts_as_controller), wrong_type(acts_as_processor), unknown_key(as_of_date)]).
test(needs_legal_review_holds_when_called_directly) :-
    needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_31), cite(cooperation_statement)), [resolution(cite(cooperation_statement), not_attempted), inputs_relied_on([request_is_in_performance_of_authority_tasks - true, cooperation_given - absent])]).
test(outside_fact_holds_when_called_directly) :-
    outside_fact(cooperation_given, attested(true, attestation(compliance_desk, received_2026_11_12, reply_sent, url(address_seven, retrieved_2026_11_12)))).
test(unknown_key_holds_when_called_directly) :-
    unknown_key(as_of_date).
test(url_holds_when_called_directly) :-
    url(address_seven, retrieved_2026_11_12).
test(wrong_type_holds_when_called_directly) :-
    wrong_type(cooperation_given).
test(status_facade_gives_the_result) :-
    gdpr_cooperation_with_the_supervisory_authority_profile_for(no_request_made, Profile),
    gdpr_cooperation_with_the_supervisory_authority_status(Profile, Status),
    Status == cooperation_not_required.
test(checklist_of_met_case_is_all_met_and_cited) :-
    gdpr_cooperation_with_the_supervisory_authority_profile_for(request_made_and_cooperated, Profile),
    gdpr_cooperation_with_the_supervisory_authority_checklist(Profile, Items),
    Items == [item(party_bound, met, cite(eu_reg_2016_679_art_31)), item(request_made, met, cite(eu_reg_2016_679_art_31)), item(request_in_performance_of_tasks, met, cite(eu_reg_2016_679_art_31)), item(cooperation_given, met, cite(eu_reg_2016_679_art_31))].
test(checklist_of_unbound_caller_marks_party_unmet) :-
    gdpr_cooperation_with_the_supervisory_authority_profile_for(caller_not_bound, Profile),
    gdpr_cooperation_with_the_supervisory_authority_checklist(Profile, [item(party_bound, Status, Citation)|_]),
    Status == unmet(not_controller_processor_or_representative),
    Citation == cite(eu_reg_2016_679_art_31).
test(what_if_a_request_is_made_asks_for_nothing_more) :-
    gdpr_cooperation_with_the_supervisory_authority_profile_for(no_request_made, Profile),
    gdpr_cooperation_with_the_supervisory_authority_what_if(Profile, authority_request_made, true, Status),
    Status == cooperation_met.
test(what_if_the_judgement_turns_unsure_refers) :-
    gdpr_cooperation_with_the_supervisory_authority_profile_for(request_made_and_cooperated, Profile),
    gdpr_cooperation_with_the_supervisory_authority_what_if(Profile, request_is_in_performance_of_authority_tasks, unsure, Status),
    Status == needs_legal_review(open_textured(request_is_in_performance_of_authority_tasks, cite(eu_reg_2016_679_art_31)), [inputs_relied_on([request_is_in_performance_of_authority_tasks - unsure])]).

expected_status_known(Subject) :-
    expected_status(Subject, _).

test(wrong_type_control_is_not_an_input_problem, fail) :-
    subject_status(wrong_type_control, input_problems(_)).
test(duplicate_role_key_is_not_also_wrong_type, fail) :-
    subject_status(duplicate_role_key, input_problems([wrong_type(acts_as_controller)])).
test(no_request_is_not_met, fail) :-
    subject_status(no_request_made, cooperation_met).
test(request_within_tasks_is_not_not_required, fail) :-
    subject_status(request_within_authority_tasks, cooperation_not_required).
test(given_processor_is_not_indeterminate, fail) :-
    subject_status(processor_key_given, indeterminate(_)).
test(cooperation_given_is_never_a_missing_key, fail) :-
    subject_status(cooperation_statement_absent, indeterminate(_)).
test(absent_statement_with_unsure_is_not_open_textured, fail) :-
    subject_status(unsure_and_statement_absent, needs_legal_review(open_textured(_, _), _)).
test(true_judgement_does_not_refer, fail) :-
    subject_status(tasks_judgement_true, needs_legal_review(_, _)).
test(attested_false_is_not_met_not_met, fail) :-
    subject_status(cooperation_statement_attested_false, cooperation_met).
test(attested_constructor_refuses_a_non_boolean, fail) :-
    attested(maybe, attestation(compliance_desk, received_2026_11_12, reply_sent, none)).
test(indeterminate_constructor_refuses_two_keys, fail) :-
    indeterminate([acts_as_controller, authority_request_made]).

cp_test_names([every_subject_has_an_expected_status, every_subject_resolves_to_its_expected_status, every_subject_has_a_non_empty_cited_checklist, every_near_miss_control_gets_another_verdict, final_statuses_are_in_the_status_values, wrong_type_role_key_is_an_input_problem, wrong_type_control_is_not_required, duplicate_role_key_is_an_input_problem, unknown_key_is_named_once, input_problems_carry_no_basis_and_no_citations, a_non_list_profile_is_not_an_attribute_list, a_well_formed_profile_has_no_problem, no_request_is_not_required, request_outside_tasks_is_not_required, request_within_tasks_is_met, caller_not_bound_is_not_required, representative_alone_is_bound_and_met, not_required_cites_article_31, missing_processor_is_named, given_processor_is_met, missing_request_key_is_named, absent_statement_refers_as_a_cross_reference, absent_statement_refers_before_the_unsure_judgement, unsure_judgement_is_open_textured, true_judgement_is_met, attested_true_is_met_and_copied, attested_false_is_not_met_and_copied, evidence_url_is_copied_exactly, provenance_constructor_holds_for_any_source_and_detail, provenance_item_builds_and_destructures, attested_constructor_answers_once, document_constructor_answers_once, duplicate_key_constructor_answers_once, indeterminate_constructor_answers_once, input_problems_constructor_answers_once, needs_legal_review_constructor_answers_once, outside_fact_constructor_answers_once, unknown_key_constructor_answers_once, url_constructor_answers_once, wrong_type_constructor_answers_once, attested_holds_when_called_directly, document_holds_when_called_directly, duplicate_key_holds_when_called_directly, indeterminate_holds_when_called_directly, input_problems_holds_when_called_directly, needs_legal_review_holds_when_called_directly, outside_fact_holds_when_called_directly, unknown_key_holds_when_called_directly, url_holds_when_called_directly, wrong_type_holds_when_called_directly, status_facade_gives_the_result, checklist_of_met_case_is_all_met_and_cited, checklist_of_unbound_caller_marks_party_unmet, what_if_a_request_is_made_asks_for_nothing_more, what_if_the_judgement_turns_unsure_refers]).
cp_test_fail_names([wrong_type_control_is_not_an_input_problem, duplicate_role_key_is_not_also_wrong_type, no_request_is_not_met, request_within_tasks_is_not_not_required, given_processor_is_not_indeterminate, cooperation_given_is_never_a_missing_key, absent_statement_with_unsure_is_not_open_textured, true_judgement_does_not_refer, attested_false_is_not_met_not_met, attested_constructor_refuses_a_non_boolean, indeterminate_constructor_refuses_two_keys]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
