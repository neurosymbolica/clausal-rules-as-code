% SPDX-License-Identifier: EUPL-1.2
:- module(m__ind_dpdp_transfer_tests_test_public_interface, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__ind_dpdp_transfer_dpdp_transfer, [decide_dpdp_transfer/2, dpdp_transfer_status/2, dpdp_transfer_checklist/2, dpdp_transfer_decision_resolvable/1, dpdp_transfer_status_values/1]).
:- use_module(m__ind_dpdp_transfer_fixtures, [dpdp_transfer_subject/1, dpdp_transfer_profile_for/2, dpdp_transfer_assess/2]).
:- use_module(m__ind_dpdp_transfer_queries, [restriction_status/4]).
:- use_module(m__ind_dpdp_transfer_kernel, [dpdp_transfer_input_problems/2]).

expected_answer(notified_destination_restricted, restricted_see_notification, [cite(in_dpdp_act_2023_s_16_1)]).
expected_answer(notified_destination_no_notification, not_restricted, [cite(in_dpdp_act_2023_s_16_1), cite(in_dpdp_act_2023_s_16_2)]).
expected_answer(notified_destination_section_16_not_in_force, not_in_force, [cite(in_dpdp_act_2023_s_16_1)]).
expected_answer(notified_destination_section_16_unstated, indeterminate([section_16_in_force_on_reference_date]), []).
expected_answer(notified_destination_notification_unstated, indeterminate([destination_restricted_by_notification]), []).
expected_answer(notified_destination_notification_unclear, needs_legal_review(open_textured(destination_restricted_by_notification, cite(in_dpdp_act_2023_s_16_1)), [inputs_relied_on([destination_restricted_by_notification - unsure])]), []).
expected_answer(foreign_state_requirements_apply_on_commencement_day, requirements_apply_see_order, [cite(in_dpdp_rules_2025_r_15)]).
expected_answer(foreign_state_day_before_commencement, not_in_force, [cite(in_dpdp_rules_2025_r_15), cite(in_dpdp_rules_2025_r_1_4), cite(in_dpdp_act_2023_s_16_1)]).
expected_answer(foreign_state_section_16_not_in_force, not_in_force, [cite(in_dpdp_rules_2025_r_15), cite(in_dpdp_rules_2025_r_1_4), cite(in_dpdp_act_2023_s_16_1)]).
expected_answer(foreign_state_section_16_unstated, indeterminate([section_16_in_force_on_reference_date]), []).
expected_answer(foreign_state_section_16_unstated_day_before_commencement, not_in_force, [cite(in_dpdp_rules_2025_r_15), cite(in_dpdp_rules_2025_r_1_4), cite(in_dpdp_act_2023_s_16_1)]).
expected_answer(foreign_state_reference_date_unstated, indeterminate([reference_date]), []).
expected_answer(foreign_state_recipient_not_foreign_state, not_restricted, [cite(in_dpdp_rules_2025_r_15)]).
expected_answer(foreign_state_no_order_specified, not_restricted, [cite(in_dpdp_rules_2025_r_15)]).
expected_answer(foreign_state_recipient_unstated, indeterminate([recipient_is_foreign_state_or_its_entity]), []).
expected_answer(foreign_state_order_unstated, indeterminate([foreign_state_requirements_specified]), []).
expected_answer(foreign_state_order_unstated_recipient_unsure, indeterminate([foreign_state_requirements_specified]), []).
expected_answer(foreign_state_recipient_unclear, needs_legal_review(open_textured(recipient_is_foreign_state_or_its_entity, cite(in_dpdp_rules_2025_r_15)), [inputs_relied_on([recipient_is_foreign_state_or_its_entity - unsure])]), []).
expected_answer(input_crisp_key_given_unsure, input_problems([wrong_type(section_16_in_force_on_reference_date)]), []).
expected_answer(input_duplicate_key, input_problems([duplicate_key(section_16_in_force_on_reference_date)]), []).
expected_answer(input_unknown_key, input_problems([unknown_key(colour)]), []).
expected_answer(input_not_a_real_day, input_problems([wrong_type(reference_date)]), []).
expected_answer(input_real_leap_day, requirements_apply_see_order, [cite(in_dpdp_rules_2025_r_15)]).
expected_answer(input_not_an_attribute_list, input_problems([wrong_type(profile)]), []).

answers_exactly(Subject) :-
    expected_answer(Subject, ExpectedResult, ExpectedCitations),
    findall(Result - Citations, dpdp_transfer_assess(Subject, dpdp_transfer_verdict(Result, Citations)), Answers),
    Answers == [ExpectedResult - ExpectedCitations].

subject_answers_once(Subject) :-
    findall(Verdict, dpdp_transfer_assess(Subject, Verdict), Verdicts),
    length(Verdicts, 1).

subject_has_expected_row(Subject) :-
    expected_answer(Subject, _, _).

subject_checklist_is_cited(Subject) :-
    dpdp_transfer_profile_for(Subject, Request),
    findall(Items, dpdp_transfer_checklist(Request, Items), Checklists),
    Checklists = [[FirstItem|OtherItems]],
    maplist(item_is_cited, [FirstItem|OtherItems]).

item_is_cited(item(_, _, cite(CitationKey))) :-
    atom(CitationKey).

subject_decide_agrees(Subject) :-
    dpdp_transfer_profile_for(Subject, Request),
    findall(Verdict, decide_dpdp_transfer(Request, Verdict), DecidedVerdicts),
    findall(Verdict, dpdp_transfer_assess(Subject, Verdict), AssessedVerdicts),
    DecidedVerdicts == AssessedVerdicts.

subject_is_resolvable(Subject) :-
    dpdp_transfer_profile_for(Subject, Request),
    dpdp_transfer_decision_resolvable(Request).

subject_restriction_status_agrees(Subject) :-
    expected_answer(Subject, ExpectedResult, ExpectedCitations),
    dpdp_transfer_profile_for(Subject, restriction_request(Restriction, Profile)),
    findall(Result - Citations, restriction_status(Restriction, Profile, Result, Citations), Answers),
    Answers == [ExpectedResult - ExpectedCitations].

test(notified_destination_restricted) :-
    answers_exactly(notified_destination_restricted).
test(notified_destination_no_notification) :-
    answers_exactly(notified_destination_no_notification).
test(notified_destination_section_16_not_in_force) :-
    answers_exactly(notified_destination_section_16_not_in_force).
test(notified_destination_section_16_unstated) :-
    answers_exactly(notified_destination_section_16_unstated).
test(notified_destination_notification_unstated) :-
    answers_exactly(notified_destination_notification_unstated).
test(notified_destination_notification_unclear) :-
    answers_exactly(notified_destination_notification_unclear).
test(foreign_state_requirements_apply_on_commencement_day) :-
    answers_exactly(foreign_state_requirements_apply_on_commencement_day).
test(foreign_state_day_before_commencement) :-
    answers_exactly(foreign_state_day_before_commencement).
test(foreign_state_section_16_not_in_force) :-
    answers_exactly(foreign_state_section_16_not_in_force).
test(foreign_state_section_16_unstated) :-
    answers_exactly(foreign_state_section_16_unstated).
test(foreign_state_section_16_unstated_day_before_commencement) :-
    answers_exactly(foreign_state_section_16_unstated_day_before_commencement).
test(foreign_state_reference_date_unstated) :-
    answers_exactly(foreign_state_reference_date_unstated).
test(foreign_state_recipient_not_foreign_state) :-
    answers_exactly(foreign_state_recipient_not_foreign_state).
test(foreign_state_no_order_specified) :-
    answers_exactly(foreign_state_no_order_specified).
test(foreign_state_recipient_unstated) :-
    answers_exactly(foreign_state_recipient_unstated).
test(foreign_state_order_unstated) :-
    answers_exactly(foreign_state_order_unstated).
test(foreign_state_order_unstated_recipient_unsure) :-
    answers_exactly(foreign_state_order_unstated_recipient_unsure).
test(foreign_state_recipient_unclear) :-
    answers_exactly(foreign_state_recipient_unclear).
test(input_crisp_key_given_unsure) :-
    answers_exactly(input_crisp_key_given_unsure).
test(input_duplicate_key) :-
    answers_exactly(input_duplicate_key).
test(input_unknown_key) :-
    answers_exactly(input_unknown_key).
test(input_not_a_real_day) :-
    answers_exactly(input_not_a_real_day).
test(input_real_leap_day) :-
    answers_exactly(input_real_leap_day).
test(input_not_an_attribute_list) :-
    answers_exactly(input_not_an_attribute_list).
test(restriction_status_restricted_see_notification) :-
    findall(Result - Citations, restriction_status(notified_destination, [attribute(section_16_in_force_on_reference_date, true), attribute(destination_restricted_by_notification, true)], Result, Citations), Answers),
    Answers == [restricted_see_notification - [cite(in_dpdp_act_2023_s_16_1)]].
test(restriction_status_requirements_apply_see_order) :-
    findall(Result - Citations, restriction_status(foreign_state_requirements, [attribute(section_16_in_force_on_reference_date, true), attribute(reference_date, date(2027, 5, 13)), attribute(recipient_is_foreign_state_or_its_entity, true), attribute(foreign_state_requirements_specified, true)], Result, Citations), Answers),
    Answers == [requirements_apply_see_order - [cite(in_dpdp_rules_2025_r_15)]].
test(restriction_status_not_restricted_notified) :-
    findall(Result - Citations, restriction_status(notified_destination, [attribute(section_16_in_force_on_reference_date, true), attribute(destination_restricted_by_notification, false)], Result, Citations), Answers),
    Answers == [not_restricted - [cite(in_dpdp_act_2023_s_16_1), cite(in_dpdp_act_2023_s_16_2)]].
test(restriction_status_not_restricted_foreign_state) :-
    findall(Result - Citations, restriction_status(foreign_state_requirements, [attribute(section_16_in_force_on_reference_date, true), attribute(reference_date, date(2027, 5, 13)), attribute(recipient_is_foreign_state_or_its_entity, false)], Result, Citations), Answers),
    Answers == [not_restricted - [cite(in_dpdp_rules_2025_r_15)]].
test(restriction_status_not_in_force_notified) :-
    findall(Result - Citations, restriction_status(notified_destination, [attribute(section_16_in_force_on_reference_date, false)], Result, Citations), Answers),
    Answers == [not_in_force - [cite(in_dpdp_act_2023_s_16_1)]].
test(restriction_status_not_in_force_day_before_commencement) :-
    findall(Result - Citations, restriction_status(foreign_state_requirements, [attribute(section_16_in_force_on_reference_date, true), attribute(reference_date, date(2027, 5, 12)), attribute(recipient_is_foreign_state_or_its_entity, true), attribute(foreign_state_requirements_specified, true)], Result, Citations), Answers),
    Answers == [not_in_force - [cite(in_dpdp_rules_2025_r_15), cite(in_dpdp_rules_2025_r_1_4), cite(in_dpdp_act_2023_s_16_1)]].
test(restriction_status_indeterminate) :-
    findall(Result - Citations, restriction_status(foreign_state_requirements, [], Result, Citations), Answers),
    Answers == [indeterminate([section_16_in_force_on_reference_date]) - []].
test(restriction_status_needs_legal_review) :-
    findall(Result - Citations, restriction_status(notified_destination, [attribute(section_16_in_force_on_reference_date, true), attribute(destination_restricted_by_notification, unsure)], Result, Citations), Answers),
    Answers == [needs_legal_review(open_textured(destination_restricted_by_notification, cite(in_dpdp_act_2023_s_16_1)), [inputs_relied_on([destination_restricted_by_notification - unsure])]) - []].
test(restriction_status_input_problems) :-
    findall(Result - Citations, restriction_status(notified_destination, [attribute(section_16_in_force_on_reference_date, maybe), attribute(colour, blue)], Result, Citations), Answers),
    Answers == [input_problems([wrong_type(section_16_in_force_on_reference_date), unknown_key(colour)]) - []].
test(restriction_status_agrees_with_every_fixture) :-
    findall(Subject, dpdp_transfer_subject(Subject), Subjects),
    Subjects = [_|_],
    maplist(subject_restriction_status_agrees, Subjects).
test(input_problems_through_the_facade) :-
    findall(Problems, dpdp_transfer_input_problems([attribute(reference_date, date(2025, 2, 29))], Problems), Answers),
    Answers == [[wrong_type(reference_date)]].
test(input_check_direct_well_formed_profile) :-
    dpdp_transfer_input_problems([attribute(section_16_in_force_on_reference_date, true), attribute(destination_restricted_by_notification, unsure), attribute(reference_date, date(2027, 5, 13)), attribute(recipient_is_foreign_state_or_its_entity, false), attribute(foreign_state_requirements_specified, false)], Problems),
    Problems == [].
test(input_check_direct_unknown_key) :-
    dpdp_transfer_input_problems([attribute(colour, blue)], Problems),
    Problems == [unknown_key(colour)].
test(input_check_direct_wrong_type) :-
    dpdp_transfer_input_problems([attribute(reference_date, date(2027, 2, 29))], Problems),
    Problems == [wrong_type(reference_date)].
test(input_check_direct_not_an_attribute_list) :-
    dpdp_transfer_input_problems(not_a_list, Problems),
    Problems == [wrong_type(profile)].
test(provenance_constructor_is_data) :-
    Term = provenance(restriction_status, [cite(in_dpdp_act_2023_s_16_1)]),
    Term = provenance(Clause, Citations),
    Clause == restriction_status,
    Citations == [cite(in_dpdp_act_2023_s_16_1)].
test(status_constructors_are_data) :-
    Missing = indeterminate([reference_date]),
    Missing = indeterminate([MissingKey]),
    MissingKey == reference_date,
    Referral = needs_legal_review(open_textured(recipient_is_foreign_state_or_its_entity, cite(in_dpdp_rules_2025_r_15)), [inputs_relied_on([recipient_is_foreign_state_or_its_entity - unsure])]),
    Referral = needs_legal_review(open_textured(Input, cite(CitationKey)), [inputs_relied_on(Pairs)]),
    Input == recipient_is_foreign_state_or_its_entity,
    CitationKey == in_dpdp_rules_2025_r_15,
    Pairs == [recipient_is_foreign_state_or_its_entity - unsure],
    Problems = input_problems([unknown_key(colour), wrong_type(reference_date), duplicate_key(reference_date)]),
    Problems = input_problems([unknown_key(Unknown), wrong_type(Wrong), duplicate_key(Duplicate)]),
    Unknown == colour,
    Wrong == reference_date,
    Duplicate == reference_date.
test(no_notification_is_not_restricted) :-
    dpdp_transfer_status(restriction_request(notified_destination, [attribute(section_16_in_force_on_reference_date, true), attribute(destination_restricted_by_notification, false)]), not_restricted).
test(commencement_day_requirements_apply) :-
    dpdp_transfer_assess(foreign_state_requirements_apply_on_commencement_day, dpdp_transfer_verdict(requirements_apply_see_order, _)).
test(real_leap_day_is_decided) :-
    dpdp_transfer_assess(input_real_leap_day, dpdp_transfer_verdict(requirements_apply_see_order, _)).
test(every_subject_has_an_expected_row) :-
    findall(Subject, dpdp_transfer_subject(Subject), Subjects),
    Subjects = [_|_],
    maplist(subject_has_expected_row, Subjects).
test(every_subject_answers_exactly_once) :-
    findall(Subject, dpdp_transfer_subject(Subject), Subjects),
    maplist(subject_answers_once, Subjects).
test(every_subject_checklist_is_non_empty_and_cited) :-
    findall(Subject, dpdp_transfer_subject(Subject), Subjects),
    maplist(subject_checklist_is_cited, Subjects).
test(decide_agrees_with_the_called_contract) :-
    findall(Subject, dpdp_transfer_subject(Subject), Subjects),
    maplist(subject_decide_agrees, Subjects).
test(every_subject_is_resolvable) :-
    findall(Subject, dpdp_transfer_subject(Subject), Subjects),
    maplist(subject_is_resolvable, Subjects).
test(final_results_are_in_the_status_values) :-
    dpdp_transfer_status_values(StatusValues),
    dpdp_transfer_assess(notified_destination_restricted, dpdp_transfer_verdict(Restricted, _)),
    member(Restricted, StatusValues),
    dpdp_transfer_assess(foreign_state_requirements_apply_on_commencement_day, dpdp_transfer_verdict(Applies, _)),
    member(Applies, StatusValues).
test(checklist_names_the_rule_15_start) :-
    dpdp_transfer_profile_for(foreign_state_day_before_commencement, Request),
    dpdp_transfer_checklist(Request, Items),
    member(item(rule_15_in_force, unmet(reference_date_before_rule_15_commencement), cite(in_dpdp_rules_2025_r_1_4)), Items).

test(restriction_status_restricted_is_not_not_restricted, fail) :-
    restriction_status(notified_destination, [attribute(section_16_in_force_on_reference_date, true), attribute(destination_restricted_by_notification, true)], not_restricted, _).
test(no_notification_is_not_restricted_see_notification, fail) :-
    dpdp_transfer_assess(notified_destination_no_notification, dpdp_transfer_verdict(restricted_see_notification, _)).
test(day_before_commencement_requirements_do_not_apply, fail) :-
    dpdp_transfer_assess(foreign_state_day_before_commencement, dpdp_transfer_verdict(requirements_apply_see_order, _)).
test(no_order_is_not_requirements_apply, fail) :-
    dpdp_transfer_assess(foreign_state_no_order_specified, dpdp_transfer_verdict(requirements_apply_see_order, _)).
test(recipient_not_foreign_state_is_not_requirements_apply, fail) :-
    dpdp_transfer_assess(foreign_state_recipient_not_foreign_state, dpdp_transfer_verdict(requirements_apply_see_order, _)).
test(unreal_day_is_not_decided, fail) :-
    dpdp_transfer_assess(input_not_a_real_day, dpdp_transfer_verdict(requirements_apply_see_order, _)).

cp_test_names([notified_destination_restricted, notified_destination_no_notification, notified_destination_section_16_not_in_force, notified_destination_section_16_unstated, notified_destination_notification_unstated, notified_destination_notification_unclear, foreign_state_requirements_apply_on_commencement_day, foreign_state_day_before_commencement, foreign_state_section_16_not_in_force, foreign_state_section_16_unstated, foreign_state_section_16_unstated_day_before_commencement, foreign_state_reference_date_unstated, foreign_state_recipient_not_foreign_state, foreign_state_no_order_specified, foreign_state_recipient_unstated, foreign_state_order_unstated, foreign_state_order_unstated_recipient_unsure, foreign_state_recipient_unclear, input_crisp_key_given_unsure, input_duplicate_key, input_unknown_key, input_not_a_real_day, input_real_leap_day, input_not_an_attribute_list, restriction_status_restricted_see_notification, restriction_status_requirements_apply_see_order, restriction_status_not_restricted_notified, restriction_status_not_restricted_foreign_state, restriction_status_not_in_force_notified, restriction_status_not_in_force_day_before_commencement, restriction_status_indeterminate, restriction_status_needs_legal_review, restriction_status_input_problems, restriction_status_agrees_with_every_fixture, input_problems_through_the_facade, input_check_direct_well_formed_profile, input_check_direct_unknown_key, input_check_direct_wrong_type, input_check_direct_not_an_attribute_list, provenance_constructor_is_data, status_constructors_are_data, no_notification_is_not_restricted, commencement_day_requirements_apply, real_leap_day_is_decided, every_subject_has_an_expected_row, every_subject_answers_exactly_once, every_subject_checklist_is_non_empty_and_cited, decide_agrees_with_the_called_contract, every_subject_is_resolvable, final_results_are_in_the_status_values, checklist_names_the_rule_15_start]).
cp_test_fail_names([restriction_status_restricted_is_not_not_restricted, no_notification_is_not_restricted_see_notification, day_before_commencement_requirements_do_not_apply, no_order_is_not_requirements_apply, recipient_not_foreign_state_is_not_requirements_apply, unreal_day_is_not_decided]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
