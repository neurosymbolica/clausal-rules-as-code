% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_art36_3_consultation_request_tests_test_public_interface, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_art36_3_consultation_request_gdpr_art36_3_consultation_request, [decide_gdpr_art36_3_consultation_request/2, gdpr_art36_3_consultation_request_status/2, gdpr_art36_3_consultation_request_checklist/2, gdpr_art36_3_consultation_request_decision_resolvable/1, gdpr_art36_3_consultation_request_status_values/1]).
:- use_module(m__eu_data_protection_gdpr_art36_3_consultation_request_fixtures, [gdpr_art36_3_consultation_request_subject/1, gdpr_art36_3_consultation_request_profile_for/2, gdpr_art36_3_consultation_request_assess/2]).
:- use_module(m__eu_data_protection_gdpr_art36_3_consultation_request_gdpr_art36_3_consultation_request, [consultation_request_status/4, missing_consultation_request_items/4]).

attested_statement(Value, attested(Value, attestation(host_user, host_time, stated_by_caller, none))).

seven_citations([cite(eu_reg_2016_679_art_36_3), cite(eu_reg_2016_679_art_36_3_a), cite(eu_reg_2016_679_art_36_3_b), cite(eu_reg_2016_679_art_36_3_c), cite(eu_reg_2016_679_art_36_3_d), cite(eu_reg_2016_679_art_36_3_e), cite(eu_reg_2016_679_art_36_3_f)]).

roles_referral(needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_36_3_a), cite(controller_and_processor_roles_statement)), [resolution(cite(controller_and_processor_roles_statement), not_attempted), inputs_relied_on([joint_controllers_or_processors_involved - absent])])).

subject_status(Subject, Status) :-
    gdpr_art36_3_consultation_request_assess(Subject, gdpr_art36_3_consultation_request_verdict(Status, _Citations)).

subject_answer(Subject, Result, Basis, Citations) :-
    gdpr_art36_3_consultation_request_profile_for(Subject, Profile),
    consultation_request_status(Profile, Result, Basis, Citations).

subject_items(Subject, Items, Basis, Citations) :-
    gdpr_art36_3_consultation_request_profile_for(Subject, Profile),
    missing_consultation_request_items(Profile, Items, Basis, Citations).

answers_once(Subject) :-
    gdpr_art36_3_consultation_request_profile_for(Subject, Profile),
    findall(Result - Basis - Citations, consultation_request_status(Profile, Result, Basis, Citations), StatusAnswers),
    length(StatusAnswers, 1),
    findall(Items - ItemsBasis - ItemsCitations, missing_consultation_request_items(Profile, Items, ItemsBasis, ItemsCitations), ItemAnswers),
    length(ItemAnswers, 1),
    findall(Verdict, gdpr_art36_3_consultation_request_assess(Subject, Verdict), Verdicts),
    length(Verdicts, 1).

checklist_has_rows(Subject) :-
    gdpr_art36_3_consultation_request_profile_for(Subject, Profile),
    gdpr_art36_3_consultation_request_checklist(Profile, [_FirstItem|_OtherItems]).

resolvable(Subject) :-
    gdpr_art36_3_consultation_request_profile_for(Subject, Profile),
    gdpr_art36_3_consultation_request_decision_resolvable(Profile).

with_roles_statement(Subject, Attested, [attribute(joint_controllers_or_processors_involved, Attested)|Rest]) :-
    gdpr_art36_3_consultation_request_profile_for(Subject, Base),
    select(attribute(joint_controllers_or_processors_involved, _Old), Base, Rest).

test(every_subject_answers_exactly_once) :-
    findall(Subject, gdpr_art36_3_consultation_request_subject(Subject), Subjects),
    length(Subjects, 21),
    maplist(answers_once, Subjects).
test(every_subject_is_resolvable) :-
    findall(Subject, gdpr_art36_3_consultation_request_subject(Subject), Subjects),
    maplist(resolvable, Subjects).
test(final_statuses_are_in_the_vocabulary) :-
    gdpr_art36_3_consultation_request_status_values(StatusValues),
    subject_status(controller_alone_complete, Complete),
    subject_status(impact_assessment_not_provided, Incomplete),
    subject_status(consultation_under_member_state_law, NotGoverned),
    member(Complete, StatusValues),
    member(Incomplete, StatusValues),
    member(NotGoverned, StatusValues).
test(governed_subjects_have_a_non_empty_checklist) :-
    maplist(checklist_has_rows, [controller_alone_complete, impact_assessment_not_provided, roles_not_attested_responsibilities_not_given, processor_involved_responsibilities_missing, officer_designated_contact_missing, authority_request_answer_unstated, missing_item_and_officer_unknown, deciding_key_before_responsibilities]).
test(controller_alone_complete_is_complete) :-
    attested_statement(false, Attested),
    seven_citations(Seven),
    subject_answer(controller_alone_complete, Result, Basis, Citations),
    Result == consultation_request_complete,
    Basis == [outside_fact(joint_controllers_or_processors_involved, Attested)],
    Citations == Seven.
test(controller_alone_complete_has_no_missing_items) :-
    attested_statement(false, Attested),
    subject_items(controller_alone_complete, Items, Basis, _),
    Items == [],
    Basis == [outside_fact(joint_controllers_or_processors_involved, Attested)].
test(controller_alone_complete_checklist_is_all_met) :-
    gdpr_art36_3_consultation_request_profile_for(controller_alone_complete, Profile),
    gdpr_art36_3_consultation_request_checklist(Profile, Items),
    Items == [item(respective_responsibilities, met, cite(eu_reg_2016_679_art_36_3_a)), item(purposes_and_means, met, cite(eu_reg_2016_679_art_36_3_b)), item(measures_and_safeguards, met, cite(eu_reg_2016_679_art_36_3_c)), item(data_protection_officer_contact_details, met, cite(eu_reg_2016_679_art_36_3_d)), item(data_protection_impact_assessment, met, cite(eu_reg_2016_679_art_36_3_e)), item(other_requested_information, met, cite(eu_reg_2016_679_art_36_3_f))].
test(controller_alone_complete_facade_status) :-
    gdpr_art36_3_consultation_request_profile_for(controller_alone_complete, Profile),
    gdpr_art36_3_consultation_request_status(Profile, Status),
    Status == consultation_request_complete.
test(impact_assessment_not_provided_is_incomplete) :-
    seven_citations(Seven),
    gdpr_art36_3_consultation_request_assess(impact_assessment_not_provided, gdpr_art36_3_consultation_request_verdict(Status, Citations)),
    Status == consultation_request_incomplete,
    Citations == Seven.
test(impact_assessment_not_provided_lists_the_assessment) :-
    subject_items(impact_assessment_not_provided, Items, _, _),
    Items == [data_protection_impact_assessment].
test(impact_assessment_not_provided_checklist_row) :-
    gdpr_art36_3_consultation_request_profile_for(impact_assessment_not_provided, Profile),
    gdpr_art36_3_consultation_request_checklist(Profile, Items),
    member(item(data_protection_impact_assessment, unmet(not_provided(impact_assessment_provided)), cite(eu_reg_2016_679_art_36_3_e)), Items).
test(url_evidence_is_accepted_and_copied_into_the_basis) :-
    Attested = attested(true, attestation(host_user, host_time, stated_by_caller, url('https://example.org/roles', host_time))),
    with_roles_statement(processor_involved_responsibilities_missing, Attested, Profile),
    consultation_request_status(Profile, Result, Basis, _),
    Result == consultation_request_incomplete,
    Basis == [outside_fact(joint_controllers_or_processors_involved, Attested)],
    missing_consultation_request_items(Profile, Items, ItemsBasis, _),
    Items == [respective_responsibilities],
    ItemsBasis == Basis.
test(url_evidence_controller_alone_is_complete) :-
    Attested = attested(false, attestation(host_user, host_time, stated_by_caller, url('https://example.org/roles', host_time))),
    with_roles_statement(controller_alone_complete, Attested, Profile),
    consultation_request_status(Profile, Result, Basis, _),
    Result == consultation_request_complete,
    Basis == [outside_fact(joint_controllers_or_processors_involved, Attested)].
test(document_evidence_controller_alone_is_complete) :-
    Attested = attested(false, attestation(host_user, host_time, stated_by_caller, document(upload_one, sha_value))),
    with_roles_statement(controller_alone_complete, Attested, Profile),
    consultation_request_status(Profile, Result, Basis, _),
    Result == consultation_request_complete,
    Basis == [outside_fact(joint_controllers_or_processors_involved, Attested)],
    missing_consultation_request_items(Profile, Items, ItemsBasis, _),
    Items == [],
    ItemsBasis == Basis.
test(document_evidence_processor_involved_is_incomplete) :-
    Attested = attested(true, attestation(host_user, host_time, stated_by_caller, document(upload_one, sha_value))),
    with_roles_statement(processor_involved_responsibilities_missing, Attested, Profile),
    consultation_request_status(Profile, Result, Basis, _),
    Result == consultation_request_incomplete,
    Basis == [outside_fact(joint_controllers_or_processors_involved, Attested)].
test(member_state_law_consultation_is_not_governed) :-
    subject_answer(consultation_under_member_state_law, Result, Basis, Citations),
    Result == not_governed_by_article_36_3,
    Basis == [],
    Citations == [cite(eu_reg_2016_679_art_36_3)].
test(member_state_law_consultation_items_not_governed) :-
    subject_items(consultation_under_member_state_law, Items, [], [cite(eu_reg_2016_679_art_36_3)]),
    Items == not_governed_by_article_36_3.
test(footing_not_stated_asks_for_the_footing) :-
    subject_answer(consultation_footing_not_stated, Result, [], []),
    Result == indeterminate([consultation_under_article_36_1]),
    subject_items(consultation_footing_not_stated, Items, [], []),
    Items == indeterminate([consultation_under_article_36_1]).
test(roles_not_attested_is_referred) :-
    roles_referral(Review),
    subject_answer(roles_not_attested_responsibilities_not_given, Result, [], []),
    Result == Review,
    subject_items(roles_not_attested_responsibilities_not_given, Items, [], []),
    Items == Review.
test(roles_attested_controller_alone_is_complete) :-
    attested_statement(false, Attested),
    subject_answer(roles_attested_controller_alone, Result, Basis, _),
    Result == consultation_request_complete,
    Basis == [outside_fact(joint_controllers_or_processors_involved, Attested)].
test(processor_involved_responsibilities_missing_is_incomplete) :-
    attested_statement(true, Attested),
    subject_answer(processor_involved_responsibilities_missing, Result, Basis, _),
    Result == consultation_request_incomplete,
    Basis == [outside_fact(joint_controllers_or_processors_involved, Attested)],
    subject_items(processor_involved_responsibilities_missing, Items, ItemsBasis, _),
    Items == [respective_responsibilities],
    ItemsBasis == Basis.
test(processor_involved_responsibilities_given_is_complete) :-
    subject_answer(processor_involved_responsibilities_given, Result, Basis, _),
    Result == consultation_request_complete,
    Basis == [].
test(officer_contact_missing_is_incomplete) :-
    subject_status(officer_designated_contact_missing, Status),
    Status == consultation_request_incomplete,
    subject_items(officer_designated_contact_missing, Items, [], _),
    Items == [data_protection_officer_contact_details].
test(officer_contact_given_is_complete) :-
    subject_status(officer_designated_contact_given, Status),
    Status == consultation_request_complete.
test(contact_given_designation_unstated_is_complete) :-
    subject_status(contact_given_designation_unstated, Status),
    Status == consultation_request_complete,
    subject_items(contact_given_designation_unstated, Items, [], _),
    Items == [].
test(authority_request_answer_unstated_asks_for_it) :-
    subject_answer(authority_request_answer_unstated, Result, [], []),
    Result == indeterminate([requested_other_information_provided]),
    subject_items(authority_request_answer_unstated, Items, [], []),
    Items == indeterminate([requested_other_information_provided]).
test(authority_request_answered_is_complete) :-
    subject_status(authority_request_answered, Status),
    Status == consultation_request_complete.
test(authority_request_not_answered_is_incomplete) :-
    subject_status(authority_request_not_answered, Status),
    Status == consultation_request_incomplete,
    subject_items(authority_request_not_answered, Items, _, _),
    Items == [other_requested_information].
test(missing_item_decides_status_while_officer_unknown) :-
    subject_answer(missing_item_and_officer_unknown, Result, Basis, _),
    Result == consultation_request_incomplete,
    Basis == [].
test(missing_item_items_query_asks_whether_an_officer_is_designated) :-
    subject_items(missing_item_and_officer_unknown, Items, [], []),
    Items == indeterminate([data_protection_officer_designated]).
test(missing_item_and_officer_not_designated_lists_the_item) :-
    subject_status(missing_item_and_officer_not_designated, Status),
    Status == consultation_request_incomplete,
    subject_items(missing_item_and_officer_not_designated, Items, [], _),
    Items == [purposes_and_means].
test(deciding_key_goes_before_responsibilities) :-
    subject_answer(deciding_key_before_responsibilities, Result, [], []),
    Result == indeterminate([measures_and_safeguards_provided]),
    subject_items(deciding_key_before_responsibilities, Items, [], []),
    Items == indeterminate([respective_responsibilities_provided]).
test(responsibilities_named_once_measures_given) :-
    subject_answer(responsibilities_unstated_roles_unstated, Result, [], []),
    Result == indeterminate([respective_responsibilities_provided]).
test(attested_value_on_crisp_key_is_wrong_type) :-
    subject_answer(attested_value_on_crisp_key, Result, [], []),
    Result == input_problems([wrong_type(purposes_and_means_provided)]),
    subject_items(attested_value_on_crisp_key, Items, [], []),
    Items == input_problems([wrong_type(purposes_and_means_provided)]).
test(bare_roles_value_is_wrong_type) :-
    subject_answer(bare_roles_value, Result, [], []),
    Result == input_problems([wrong_type(joint_controllers_or_processors_involved)]).
test(duplicate_and_unknown_keys_are_named) :-
    subject_answer(duplicate_and_unknown_keys, Result, [], []),
    Result == input_problems([duplicate_key(impact_assessment_provided), unknown_key(controller_name)]).
test(input_problems_give_no_checklist_rows) :-
    gdpr_art36_3_consultation_request_profile_for(bare_roles_value, Profile),
    gdpr_art36_3_consultation_request_checklist(Profile, Items),
    Items == [].

test(controller_alone_complete_is_not_incomplete, fail) :-
    subject_status(controller_alone_complete, consultation_request_incomplete).
test(impact_assessment_not_provided_is_not_complete, fail) :-
    subject_status(impact_assessment_not_provided, consultation_request_complete).
test(url_evidence_controller_alone_is_not_incomplete, fail) :-
    Attested = attested(false, attestation(host_user, host_time, stated_by_caller, url('https://example.org/roles', host_time))),
    with_roles_statement(controller_alone_complete, Attested, Profile),
    consultation_request_status(Profile, consultation_request_incomplete, _, _).
test(document_evidence_processor_involved_is_not_complete, fail) :-
    Attested = attested(true, attestation(host_user, host_time, stated_by_caller, document(upload_one, sha_value))),
    with_roles_statement(processor_involved_responsibilities_missing, Attested, Profile),
    consultation_request_status(Profile, consultation_request_complete, _, _).
test(member_state_law_consultation_is_not_complete, fail) :-
    subject_status(consultation_under_member_state_law, consultation_request_complete).
test(footing_not_stated_is_not_complete, fail) :-
    subject_status(consultation_footing_not_stated, consultation_request_complete).
test(roles_not_attested_is_not_complete, fail) :-
    subject_status(roles_not_attested_responsibilities_not_given, consultation_request_complete).
test(processor_involved_responsibilities_missing_is_not_complete, fail) :-
    subject_status(processor_involved_responsibilities_missing, consultation_request_complete).
test(processor_involved_responsibilities_given_is_not_incomplete, fail) :-
    subject_status(processor_involved_responsibilities_given, consultation_request_incomplete).
test(officer_contact_missing_is_not_complete, fail) :-
    subject_status(officer_designated_contact_missing, consultation_request_complete).
test(officer_contact_given_is_not_incomplete, fail) :-
    subject_status(officer_designated_contact_given, consultation_request_incomplete).
test(authority_request_answer_unstated_is_not_complete, fail) :-
    subject_status(authority_request_answer_unstated, consultation_request_complete).
test(authority_request_not_answered_is_not_complete, fail) :-
    subject_status(authority_request_not_answered, consultation_request_complete).
test(responsibilities_unstated_is_not_complete, fail) :-
    subject_status(responsibilities_unstated_roles_unstated, consultation_request_complete).
test(input_problems_are_not_complete, fail) :-
    subject_status(duplicate_and_unknown_keys, consultation_request_complete).

cp_test_names([every_subject_answers_exactly_once, every_subject_is_resolvable, final_statuses_are_in_the_vocabulary, governed_subjects_have_a_non_empty_checklist, controller_alone_complete_is_complete, controller_alone_complete_has_no_missing_items, controller_alone_complete_checklist_is_all_met, controller_alone_complete_facade_status, impact_assessment_not_provided_is_incomplete, impact_assessment_not_provided_lists_the_assessment, impact_assessment_not_provided_checklist_row, url_evidence_is_accepted_and_copied_into_the_basis, url_evidence_controller_alone_is_complete, document_evidence_controller_alone_is_complete, document_evidence_processor_involved_is_incomplete, member_state_law_consultation_is_not_governed, member_state_law_consultation_items_not_governed, footing_not_stated_asks_for_the_footing, roles_not_attested_is_referred, roles_attested_controller_alone_is_complete, processor_involved_responsibilities_missing_is_incomplete, processor_involved_responsibilities_given_is_complete, officer_contact_missing_is_incomplete, officer_contact_given_is_complete, contact_given_designation_unstated_is_complete, authority_request_answer_unstated_asks_for_it, authority_request_answered_is_complete, authority_request_not_answered_is_incomplete, missing_item_decides_status_while_officer_unknown, missing_item_items_query_asks_whether_an_officer_is_designated, missing_item_and_officer_not_designated_lists_the_item, deciding_key_goes_before_responsibilities, responsibilities_named_once_measures_given, attested_value_on_crisp_key_is_wrong_type, bare_roles_value_is_wrong_type, duplicate_and_unknown_keys_are_named, input_problems_give_no_checklist_rows]).
cp_test_fail_names([controller_alone_complete_is_not_incomplete, impact_assessment_not_provided_is_not_complete, url_evidence_controller_alone_is_not_incomplete, document_evidence_processor_involved_is_not_complete, member_state_law_consultation_is_not_complete, footing_not_stated_is_not_complete, roles_not_attested_is_not_complete, processor_involved_responsibilities_missing_is_not_complete, processor_involved_responsibilities_given_is_not_incomplete, officer_contact_missing_is_not_complete, officer_contact_given_is_not_incomplete, authority_request_answer_unstated_is_not_complete, authority_request_not_answered_is_not_complete, responsibilities_unstated_is_not_complete, input_problems_are_not_complete]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
