% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_art36_3_consultation_request_tests_test_output_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_art36_3_consultation_request_gdpr_art36_3_consultation_request, [consultation_request_status/4, missing_consultation_request_items/4, decide_gdpr_art36_3_consultation_request/2]).
:- use_module(m__eu_data_protection_gdpr_art36_3_consultation_request_fixtures, [gdpr_art36_3_consultation_request_profile_for/2]).

seven_citations([cite(eu_reg_2016_679_art_36_3), cite(eu_reg_2016_679_art_36_3_a), cite(eu_reg_2016_679_art_36_3_b), cite(eu_reg_2016_679_art_36_3_c), cite(eu_reg_2016_679_art_36_3_d), cite(eu_reg_2016_679_art_36_3_e), cite(eu_reg_2016_679_art_36_3_f)]).

controller_alone_basis([outside_fact(joint_controllers_or_processors_involved, attested(false, attestation(host_user, host_time, stated_by_caller, none)))]).

processor_involved_basis([outside_fact(joint_controllers_or_processors_involved, attested(true, attestation(host_user, host_time, stated_by_caller, none)))]).

roles_referral(needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_36_3_a), cite(controller_and_processor_roles_statement)), [resolution(cite(controller_and_processor_roles_statement), not_attempted), inputs_relied_on([joint_controllers_or_processors_involved - absent])])).

status_answers(Subject, Answers) :-
    gdpr_art36_3_consultation_request_profile_for(Subject, Profile),
    findall(Result - Basis - Citations, consultation_request_status(Profile, Result, Basis, Citations), Answers).

items_answers(Subject, Answers) :-
    gdpr_art36_3_consultation_request_profile_for(Subject, Profile),
    findall(Items - Basis - Citations, missing_consultation_request_items(Profile, Items, Basis, Citations), Answers).

test(controller_alone_complete_answers) :-
    controller_alone_basis(Basis),
    seven_citations(Citations),
    status_answers(controller_alone_complete, StatusAnswers),
    StatusAnswers == [consultation_request_complete - Basis - Citations],
    items_answers(controller_alone_complete, ItemAnswers),
    ItemAnswers == [[] - Basis - Citations].
test(impact_assessment_not_provided_answers) :-
    controller_alone_basis(Basis),
    seven_citations(Citations),
    status_answers(impact_assessment_not_provided, StatusAnswers),
    StatusAnswers == [consultation_request_incomplete - Basis - Citations],
    items_answers(impact_assessment_not_provided, ItemAnswers),
    ItemAnswers == [[data_protection_impact_assessment] - Basis - Citations].
test(consultation_under_member_state_law_answers) :-
    status_answers(consultation_under_member_state_law, StatusAnswers),
    StatusAnswers == [not_governed_by_article_36_3 - [] - [cite(eu_reg_2016_679_art_36_3)]],
    items_answers(consultation_under_member_state_law, ItemAnswers),
    ItemAnswers == [not_governed_by_article_36_3 - [] - [cite(eu_reg_2016_679_art_36_3)]].
test(consultation_footing_not_stated_answers) :-
    status_answers(consultation_footing_not_stated, StatusAnswers),
    StatusAnswers == [indeterminate([consultation_under_article_36_1]) - [] - []],
    items_answers(consultation_footing_not_stated, ItemAnswers),
    ItemAnswers == [indeterminate([consultation_under_article_36_1]) - [] - []].
test(roles_not_attested_answers_are_the_referral) :-
    roles_referral(Referral),
    status_answers(roles_not_attested_responsibilities_not_given, StatusAnswers),
    StatusAnswers == [Referral - [] - []],
    items_answers(roles_not_attested_responsibilities_not_given, ItemAnswers),
    ItemAnswers == [Referral - [] - []].
test(roles_attested_controller_alone_answers) :-
    controller_alone_basis(Basis),
    seven_citations(Citations),
    status_answers(roles_attested_controller_alone, StatusAnswers),
    StatusAnswers == [consultation_request_complete - Basis - Citations],
    items_answers(roles_attested_controller_alone, ItemAnswers),
    ItemAnswers == [[] - Basis - Citations].
test(processor_involved_responsibilities_missing_answers) :-
    processor_involved_basis(Basis),
    seven_citations(Citations),
    status_answers(processor_involved_responsibilities_missing, StatusAnswers),
    StatusAnswers == [consultation_request_incomplete - Basis - Citations],
    items_answers(processor_involved_responsibilities_missing, ItemAnswers),
    ItemAnswers == [[respective_responsibilities] - Basis - Citations].
test(processor_involved_responsibilities_given_answers_copy_no_basis) :-
    seven_citations(Citations),
    status_answers(processor_involved_responsibilities_given, StatusAnswers),
    StatusAnswers == [consultation_request_complete - [] - Citations],
    items_answers(processor_involved_responsibilities_given, ItemAnswers),
    ItemAnswers == [[] - [] - Citations].
test(officer_designated_contact_missing_answers) :-
    seven_citations(Citations),
    status_answers(officer_designated_contact_missing, StatusAnswers),
    StatusAnswers == [consultation_request_incomplete - [] - Citations],
    items_answers(officer_designated_contact_missing, ItemAnswers),
    ItemAnswers == [[data_protection_officer_contact_details] - [] - Citations].
test(officer_designated_contact_given_answers) :-
    seven_citations(Citations),
    status_answers(officer_designated_contact_given, StatusAnswers),
    StatusAnswers == [consultation_request_complete - [] - Citations],
    items_answers(officer_designated_contact_given, ItemAnswers),
    ItemAnswers == [[] - [] - Citations].
test(contact_given_designation_unstated_answers) :-
    seven_citations(Citations),
    status_answers(contact_given_designation_unstated, StatusAnswers),
    StatusAnswers == [consultation_request_complete - [] - Citations],
    items_answers(contact_given_designation_unstated, ItemAnswers),
    ItemAnswers == [[] - [] - Citations].
test(authority_request_answer_unstated_answers) :-
    status_answers(authority_request_answer_unstated, StatusAnswers),
    StatusAnswers == [indeterminate([requested_other_information_provided]) - [] - []],
    items_answers(authority_request_answer_unstated, ItemAnswers),
    ItemAnswers == [indeterminate([requested_other_information_provided]) - [] - []].
test(authority_request_answered_answers) :-
    seven_citations(Citations),
    status_answers(authority_request_answered, StatusAnswers),
    StatusAnswers == [consultation_request_complete - [] - Citations],
    items_answers(authority_request_answered, ItemAnswers),
    ItemAnswers == [[] - [] - Citations].
test(authority_request_not_answered_answers) :-
    seven_citations(Citations),
    status_answers(authority_request_not_answered, StatusAnswers),
    StatusAnswers == [consultation_request_incomplete - [] - Citations],
    items_answers(authority_request_not_answered, ItemAnswers),
    ItemAnswers == [[other_requested_information] - [] - Citations].
test(missing_item_and_officer_unknown_answers) :-
    seven_citations(Citations),
    status_answers(missing_item_and_officer_unknown, StatusAnswers),
    StatusAnswers == [consultation_request_incomplete - [] - Citations],
    items_answers(missing_item_and_officer_unknown, ItemAnswers),
    ItemAnswers == [indeterminate([data_protection_officer_designated]) - [] - []].
test(missing_item_and_officer_not_designated_answers) :-
    seven_citations(Citations),
    status_answers(missing_item_and_officer_not_designated, StatusAnswers),
    StatusAnswers == [consultation_request_incomplete - [] - Citations],
    items_answers(missing_item_and_officer_not_designated, ItemAnswers),
    ItemAnswers == [[purposes_and_means] - [] - Citations].
test(deciding_key_before_responsibilities_answers) :-
    status_answers(deciding_key_before_responsibilities, StatusAnswers),
    StatusAnswers == [indeterminate([measures_and_safeguards_provided]) - [] - []],
    items_answers(deciding_key_before_responsibilities, ItemAnswers),
    ItemAnswers == [indeterminate([respective_responsibilities_provided]) - [] - []].
test(responsibilities_unstated_roles_unstated_answers) :-
    status_answers(responsibilities_unstated_roles_unstated, StatusAnswers),
    StatusAnswers == [indeterminate([respective_responsibilities_provided]) - [] - []],
    items_answers(responsibilities_unstated_roles_unstated, ItemAnswers),
    ItemAnswers == [indeterminate([respective_responsibilities_provided]) - [] - []].
test(attested_value_on_crisp_key_answers) :-
    status_answers(attested_value_on_crisp_key, StatusAnswers),
    StatusAnswers == [input_problems([wrong_type(purposes_and_means_provided)]) - [] - []],
    items_answers(attested_value_on_crisp_key, ItemAnswers),
    ItemAnswers == [input_problems([wrong_type(purposes_and_means_provided)]) - [] - []].
test(bare_roles_value_answers) :-
    status_answers(bare_roles_value, StatusAnswers),
    StatusAnswers == [input_problems([wrong_type(joint_controllers_or_processors_involved)]) - [] - []].
test(duplicate_and_unknown_keys_answers) :-
    status_answers(duplicate_and_unknown_keys, StatusAnswers),
    StatusAnswers == [input_problems([duplicate_key(impact_assessment_provided), unknown_key(controller_name)]) - [] - []],
    items_answers(duplicate_and_unknown_keys, ItemAnswers),
    ItemAnswers == [input_problems([duplicate_key(impact_assessment_provided), unknown_key(controller_name)]) - [] - []].
test(several_missing_items_listed_in_point_order) :-
    Profile = [attribute(consultation_under_article_36_1, true), attribute(respective_responsibilities_provided, true), attribute(purposes_and_means_provided, false), attribute(measures_and_safeguards_provided, true), attribute(data_protection_officer_designated, true), attribute(data_protection_officer_contact_details_provided, false), attribute(impact_assessment_provided, false), attribute(other_information_requested_by_supervisory_authority, true), attribute(requested_other_information_provided, false)],
    findall(Items, missing_consultation_request_items(Profile, Items, _, _), Answers),
    Answers == [[purposes_and_means, data_protection_officer_contact_details, data_protection_impact_assessment, other_requested_information]].
test(the_verdict_carries_its_citations) :-
    gdpr_art36_3_consultation_request_profile_for(controller_alone_complete, Profile),
    seven_citations(Citations),
    findall(Verdict, decide_gdpr_art36_3_consultation_request(Profile, Verdict), Verdicts),
    Verdicts == [gdpr_art36_3_consultation_request_verdict(consultation_request_complete, Citations)].

cp_test_names([controller_alone_complete_answers, impact_assessment_not_provided_answers, consultation_under_member_state_law_answers, consultation_footing_not_stated_answers, roles_not_attested_answers_are_the_referral, roles_attested_controller_alone_answers, processor_involved_responsibilities_missing_answers, processor_involved_responsibilities_given_answers_copy_no_basis, officer_designated_contact_missing_answers, officer_designated_contact_given_answers, contact_given_designation_unstated_answers, authority_request_answer_unstated_answers, authority_request_answered_answers, authority_request_not_answered_answers, missing_item_and_officer_unknown_answers, missing_item_and_officer_not_designated_answers, deciding_key_before_responsibilities_answers, responsibilities_unstated_roles_unstated_answers, attested_value_on_crisp_key_answers, bare_roles_value_answers, duplicate_and_unknown_keys_answers, several_missing_items_listed_in_point_order, the_verdict_carries_its_citations]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
