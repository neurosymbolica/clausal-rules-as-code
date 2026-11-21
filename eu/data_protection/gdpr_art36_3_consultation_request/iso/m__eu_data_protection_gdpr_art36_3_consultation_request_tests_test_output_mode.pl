% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_art36_3_consultation_request_tests_test_output_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_art36_3_consultation_request_gdpr_art36_3_consultation_request, [consultation_request_status/4, missing_consultation_request_items/4, decide_gdpr_art36_3_consultation_request/2, gdpr_art36_3_consultation_request_checklist/2]).
:- use_module(m__eu_data_protection_gdpr_art36_3_consultation_request_fixtures, [gdpr_art36_3_consultation_request_profile_for/2]).

sole_controller_statement(attested(false, attestation(privacy_counsel, attestation_moment, role_review, none))).

joint_controllers_statement(attested(true, attestation(privacy_counsel, attestation_moment, role_review, none))).

seven_citations([cite(eu_reg_2016_679_art_36_3), cite(eu_reg_2016_679_art_36_3_a), cite(eu_reg_2016_679_art_36_3_b), cite(eu_reg_2016_679_art_36_3_c), cite(eu_reg_2016_679_art_36_3_d), cite(eu_reg_2016_679_art_36_3_e), cite(eu_reg_2016_679_art_36_3_f)]).

status_answers(Subject, Answers) :-
    gdpr_art36_3_consultation_request_profile_for(Subject, Profile),
    findall(Result - Basis, consultation_request_status(Profile, Result, Basis, _Citations), Answers).

items_answers(Subject, Answers) :-
    gdpr_art36_3_consultation_request_profile_for(Subject, Profile),
    findall(Items - Basis, missing_consultation_request_items(Profile, Items, Basis, _Citations), Answers).

test(complete_sole_controller_answers) :-
    sole_controller_statement(Statement),
    status_answers(complete_sole_controller, StatusAnswers),
    StatusAnswers == [consultation_request_complete - [outside_fact(joint_controllers_or_processors_involved, Statement)]],
    items_answers(complete_sole_controller, ItemAnswers),
    ItemAnswers == [[] - [outside_fact(joint_controllers_or_processors_involved, Statement)]].
test(missing_assessment_answers) :-
    sole_controller_statement(Statement),
    status_answers(incomplete_missing_assessment, StatusAnswers),
    StatusAnswers == [consultation_request_incomplete - [outside_fact(joint_controllers_or_processors_involved, Statement)]],
    items_answers(incomplete_missing_assessment, ItemAnswers),
    ItemAnswers == [[data_protection_impact_assessment] - [outside_fact(joint_controllers_or_processors_involved, Statement)]].
test(complete_joint_controllers_answers_copy_no_unread_fact) :-
    status_answers(complete_joint_controllers, StatusAnswers),
    StatusAnswers == [consultation_request_complete - []],
    items_answers(complete_joint_controllers, ItemAnswers),
    ItemAnswers == [[] - []].
test(responsibilities_missing_answers_copy_the_read_fact) :-
    joint_controllers_statement(Statement),
    status_answers(joint_controllers_responsibilities_missing, StatusAnswers),
    StatusAnswers == [consultation_request_incomplete - [outside_fact(joint_controllers_or_processors_involved, Statement)]],
    items_answers(joint_controllers_responsibilities_missing, ItemAnswers),
    ItemAnswers == [[respective_responsibilities] - [outside_fact(joint_controllers_or_processors_involved, Statement)]].
test(officer_contact_details_missing_answers) :-
    items_answers(officer_contact_details_missing, ItemAnswers),
    ItemAnswers == [[data_protection_officer_contact_details] - []].
test(other_information_missing_answers) :-
    items_answers(other_information_missing, ItemAnswers),
    ItemAnswers == [[other_requested_information] - []].
test(member_state_law_answers) :-
    gdpr_art36_3_consultation_request_profile_for(member_state_law_consultation, Profile),
    findall(Result - Basis - Citations, consultation_request_status(Profile, Result, Basis, Citations), StatusAnswers),
    StatusAnswers == [not_governed_by_article_36_3 - [] - [cite(eu_reg_2016_679_art_36_3)]],
    findall(Items - Basis - Citations, missing_consultation_request_items(Profile, Items, Basis, Citations), ItemAnswers),
    ItemAnswers == [not_governed_by_article_36_3 - [] - [cite(eu_reg_2016_679_art_36_3)]].
test(unstated_footing_answers) :-
    status_answers(consultation_footing_unstated, StatusAnswers),
    StatusAnswers == [indeterminate([consultation_under_article_36_1]) - []],
    items_answers(consultation_footing_unstated, ItemAnswers),
    ItemAnswers == [indeterminate([consultation_under_article_36_1]) - []].
test(referral_answers) :-
    status_answers(roles_unattested_referral, StatusAnswers),
    StatusAnswers == [needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_36_3_a), cite(controller_and_processor_roles_statement)), [resolution(cite(controller_and_processor_roles_statement), not_attempted), inputs_relied_on([joint_controllers_or_processors_involved - absent])]) - []].
test(attested_sole_controller_answers) :-
    sole_controller_statement(Statement),
    items_answers(roles_attested_sole_controller, ItemAnswers),
    ItemAnswers == [[] - [outside_fact(joint_controllers_or_processors_involved, Statement)]].
test(designation_unknown_answers) :-
    status_answers(officer_designation_unknown, StatusAnswers),
    StatusAnswers == [indeterminate([data_protection_officer_designated]) - []],
    items_answers(officer_designation_unknown, ItemAnswers),
    ItemAnswers == [indeterminate([data_protection_officer_designated]) - []].
test(officer_not_designated_answers) :-
    status_answers(officer_not_designated, StatusAnswers),
    StatusAnswers == [consultation_request_complete - []].
test(open_responsibilities_status_is_incomplete_items_ask) :-
    status_answers(missing_item_with_open_responsibilities, StatusAnswers),
    StatusAnswers == [consultation_request_incomplete - []],
    items_answers(missing_item_with_open_responsibilities, ItemAnswers),
    ItemAnswers == [indeterminate([respective_responsibilities_provided]) - []].
test(settled_responsibilities_items_list) :-
    items_answers(missing_item_with_settled_responsibilities, ItemAnswers),
    ItemAnswers == [[purposes_and_means] - []].
test(malformed_answers) :-
    status_answers(malformed_attested_crisp_key, StatusAnswers),
    StatusAnswers == [input_problems([wrong_type(purposes_and_means_provided)]) - []].
test(the_verdict_carries_the_seven_citations) :-
    gdpr_art36_3_consultation_request_profile_for(complete_joint_controllers, Profile),
    seven_citations(Citations),
    findall(Verdict, decide_gdpr_art36_3_consultation_request(Profile, Verdict), Verdicts),
    Verdicts == [gdpr_art36_3_consultation_request_verdict(consultation_request_complete, Citations)].
test(the_checklist_names_each_point_with_its_cite) :-
    gdpr_art36_3_consultation_request_profile_for(officer_contact_details_missing, Profile),
    findall(Items, gdpr_art36_3_consultation_request_checklist(Profile, Items), Checklists),
    Checklists == [[item(respective_responsibilities, satisfied, cite(eu_reg_2016_679_art_36_3_a)), item(purposes_and_means, satisfied, cite(eu_reg_2016_679_art_36_3_b)), item(measures_and_safeguards, satisfied, cite(eu_reg_2016_679_art_36_3_c)), item(data_protection_officer_contact_details, missing, cite(eu_reg_2016_679_art_36_3_d)), item(data_protection_impact_assessment, satisfied, cite(eu_reg_2016_679_art_36_3_e)), item(other_requested_information, satisfied, cite(eu_reg_2016_679_art_36_3_f))]].

cp_test_names([complete_sole_controller_answers, missing_assessment_answers, complete_joint_controllers_answers_copy_no_unread_fact, responsibilities_missing_answers_copy_the_read_fact, officer_contact_details_missing_answers, other_information_missing_answers, member_state_law_answers, unstated_footing_answers, referral_answers, attested_sole_controller_answers, designation_unknown_answers, officer_not_designated_answers, open_responsibilities_status_is_incomplete_items_ask, settled_responsibilities_items_list, malformed_answers, the_verdict_carries_the_seven_citations, the_checklist_names_each_point_with_its_cite]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
