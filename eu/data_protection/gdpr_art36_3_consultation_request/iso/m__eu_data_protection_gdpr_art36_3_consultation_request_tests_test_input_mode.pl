% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_art36_3_consultation_request_tests_test_input_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_art36_3_consultation_request_gdpr_art36_3_consultation_request, [consultation_request_status/4, missing_consultation_request_items/4, gdpr_art36_3_consultation_request_status/2]).
:- use_module(m__eu_data_protection_gdpr_art36_3_consultation_request_kernel, [gdpr_art36_3_consultation_request_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_art36_3_consultation_request_fixtures, [gdpr_art36_3_consultation_request_profile_for/2]).

seven_citations([cite(eu_reg_2016_679_art_36_3), cite(eu_reg_2016_679_art_36_3_a), cite(eu_reg_2016_679_art_36_3_b), cite(eu_reg_2016_679_art_36_3_c), cite(eu_reg_2016_679_art_36_3_d), cite(eu_reg_2016_679_art_36_3_e), cite(eu_reg_2016_679_art_36_3_f)]).

controller_alone_statement(attested(false, attestation(host_user, host_time, stated_by_caller, none))).

problem_answers(Term, Answers) :-
    findall(Problems, gdpr_art36_3_consultation_request_input_problems(Term, Problems), Answers).

test(complete_status_holds_bound) :-
    gdpr_art36_3_consultation_request_profile_for(controller_alone_complete, Profile),
    controller_alone_statement(Statement),
    seven_citations(Citations),
    consultation_request_status(Profile, consultation_request_complete, [outside_fact(joint_controllers_or_processors_involved, Statement)], Citations).
test(incomplete_status_holds_bound) :-
    gdpr_art36_3_consultation_request_profile_for(officer_designated_contact_missing, Profile),
    seven_citations(Citations),
    consultation_request_status(Profile, consultation_request_incomplete, [], Citations).
test(missing_items_hold_bound) :-
    gdpr_art36_3_consultation_request_profile_for(officer_designated_contact_missing, Profile),
    seven_citations(Citations),
    missing_consultation_request_items(Profile, [data_protection_officer_contact_details], [], Citations).
test(not_governed_holds_bound) :-
    gdpr_art36_3_consultation_request_profile_for(consultation_under_member_state_law, Profile),
    consultation_request_status(Profile, not_governed_by_article_36_3, [], [cite(eu_reg_2016_679_art_36_3)]),
    missing_consultation_request_items(Profile, not_governed_by_article_36_3, [], [cite(eu_reg_2016_679_art_36_3)]).
test(indeterminate_holds_bound) :-
    gdpr_art36_3_consultation_request_profile_for(authority_request_answer_unstated, Profile),
    consultation_request_status(Profile, indeterminate([requested_other_information_provided]), [], []).
test(facade_status_holds_bound) :-
    gdpr_art36_3_consultation_request_profile_for(processor_involved_responsibilities_given, Profile),
    gdpr_art36_3_consultation_request_status(Profile, consultation_request_complete).
test(an_empty_profile_has_no_problem) :-
    problem_answers([], Answers),
    Answers == [[]].
test(an_unbound_profile_is_not_an_attribute_list) :-
    problem_answers(_Unbound, Answers),
    Answers == [[wrong_type(profile)]].
test(a_partial_list_is_not_an_attribute_list) :-
    problem_answers([attribute(consultation_under_article_36_1, true)|_Tail], Answers),
    Answers == [[wrong_type(profile)]].
test(a_list_with_an_unbound_element_is_not_an_attribute_list) :-
    problem_answers([attribute(consultation_under_article_36_1, true), _Element], Answers),
    Answers == [[wrong_type(profile)]].
test(a_list_with_a_foreign_element_is_not_an_attribute_list) :-
    problem_answers([attribute(consultation_under_article_36_1, true), consultation_under_article_36_1], Answers),
    Answers == [[wrong_type(profile)]].
test(an_atom_is_not_an_attribute_list) :-
    problem_answers(profile, Answers),
    Answers == [[wrong_type(profile)]].
test(a_number_key_is_unknown) :-
    problem_answers([attribute(42, true)], Answers),
    Answers == [[unknown_key(42)]].
test(an_unbound_key_is_unknown_as_given) :-
    problem_answers([attribute(_Fresh, true)], Answers),
    Answers = [[unknown_key(Named)]],
    var(Named).
test(an_unbound_value_is_wrong_type) :-
    problem_answers([attribute(consultation_under_article_36_1, _Value)], Answers),
    Answers == [[wrong_type(consultation_under_article_36_1)]].
test(unsure_on_a_crisp_key_is_wrong_type) :-
    problem_answers([attribute(measures_and_safeguards_provided, unsure)], Answers),
    Answers == [[wrong_type(measures_and_safeguards_provided)]].
test(an_attested_term_on_a_crisp_key_is_wrong_type) :-
    gdpr_art36_3_consultation_request_profile_for(attested_value_on_crisp_key, Profile),
    problem_answers(Profile, Answers),
    Answers == [[wrong_type(purposes_and_means_provided)]].
test(a_bare_value_on_the_outside_fact_is_wrong_type) :-
    gdpr_art36_3_consultation_request_profile_for(bare_roles_value, Profile),
    problem_answers(Profile, Answers),
    Answers == [[wrong_type(joint_controllers_or_processors_involved)]].
test(an_attested_unsure_is_wrong_type) :-
    problem_answers([attribute(joint_controllers_or_processors_involved, attested(unsure, attestation(host_user, host_time, stated_by_caller, none)))], Answers),
    Answers == [[wrong_type(joint_controllers_or_processors_involved)]].
test(a_three_part_attestation_is_wrong_type) :-
    problem_answers([attribute(joint_controllers_or_processors_involved, attested(true, attestation(host_user, host_time, stated_by_caller)))], Answers),
    Answers == [[wrong_type(joint_controllers_or_processors_involved)]].
test(url_and_document_evidence_are_accepted) :-
    problem_answers([attribute(joint_controllers_or_processors_involved, attested(true, attestation(host_user, host_time, stated_by_caller, url(address, retrieved_at))))], UrlAnswers),
    UrlAnswers == [[]],
    problem_answers([attribute(joint_controllers_or_processors_involved, attested(false, attestation(host_user, host_time, stated_by_caller, document(upload, content_hash))))], DocumentAnswers),
    DocumentAnswers == [[]].
test(a_duplicate_key_is_named_once_and_never_wrong_type) :-
    problem_answers([attribute(impact_assessment_provided, true), attribute(impact_assessment_provided, unsure), attribute(impact_assessment_provided, false)], Answers),
    Answers == [[duplicate_key(impact_assessment_provided)]].
test(problems_follow_contract_order_then_unknown_keys) :-
    problem_answers([attribute(controller_name, acme), attribute(requested_other_information_provided, unsure), attribute(controller_name, other), attribute(consultation_under_article_36_1, yes), attribute(group_name, acme)], Answers),
    Answers == [[wrong_type(consultation_under_article_36_1), wrong_type(requested_other_information_provided), unknown_key(controller_name), unknown_key(group_name)]].
test(a_content_key_beside_a_false_applicability_key_is_no_problem) :-
    problem_answers([attribute(data_protection_officer_designated, false), attribute(data_protection_officer_contact_details_provided, true)], Answers),
    Answers == [[]].
test(input_problems_come_first_in_both_queries) :-
    findall(Result - Basis - Citations, consultation_request_status(profile, Result, Basis, Citations), StatusAnswers),
    StatusAnswers == [input_problems([wrong_type(profile)]) - [] - []],
    findall(Items - ItemsBasis - ItemsCitations, missing_consultation_request_items(profile, Items, ItemsBasis, ItemsCitations), ItemAnswers),
    ItemAnswers == [input_problems([wrong_type(profile)]) - [] - []].

test(complete_status_rejects_incomplete_bound, fail) :-
    gdpr_art36_3_consultation_request_profile_for(controller_alone_complete, Profile),
    consultation_request_status(Profile, consultation_request_incomplete, _, _).
test(complete_status_rejects_an_empty_basis_bound, fail) :-
    gdpr_art36_3_consultation_request_profile_for(controller_alone_complete, Profile),
    consultation_request_status(Profile, consultation_request_complete, [], _).
test(missing_items_reject_a_wrong_list_bound, fail) :-
    gdpr_art36_3_consultation_request_profile_for(officer_designated_contact_missing, Profile),
    missing_consultation_request_items(Profile, [], _, _).
test(facade_status_rejects_another_atom_bound, fail) :-
    gdpr_art36_3_consultation_request_profile_for(processor_involved_responsibilities_given, Profile),
    gdpr_art36_3_consultation_request_status(Profile, not_governed_by_article_36_3).

cp_test_names([complete_status_holds_bound, incomplete_status_holds_bound, missing_items_hold_bound, not_governed_holds_bound, indeterminate_holds_bound, facade_status_holds_bound, an_empty_profile_has_no_problem, an_unbound_profile_is_not_an_attribute_list, a_partial_list_is_not_an_attribute_list, a_list_with_an_unbound_element_is_not_an_attribute_list, a_list_with_a_foreign_element_is_not_an_attribute_list, an_atom_is_not_an_attribute_list, a_number_key_is_unknown, an_unbound_key_is_unknown_as_given, an_unbound_value_is_wrong_type, unsure_on_a_crisp_key_is_wrong_type, an_attested_term_on_a_crisp_key_is_wrong_type, a_bare_value_on_the_outside_fact_is_wrong_type, an_attested_unsure_is_wrong_type, a_three_part_attestation_is_wrong_type, url_and_document_evidence_are_accepted, a_duplicate_key_is_named_once_and_never_wrong_type, problems_follow_contract_order_then_unknown_keys, a_content_key_beside_a_false_applicability_key_is_no_problem, input_problems_come_first_in_both_queries]).
cp_test_fail_names([complete_status_rejects_incomplete_bound, complete_status_rejects_an_empty_basis_bound, missing_items_reject_a_wrong_list_bound, facade_status_rejects_another_atom_bound]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
