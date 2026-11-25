% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_register_of_information_tests_test_negative_controls, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_dora_register_of_information_dora_register_of_information, [register_of_information_duties_required/3, register_of_information_duties_complete/3, register_of_information_duties_outstanding/3, dora_register_of_information_status_values/1]).
:- use_module(m__eu_dora_register_of_information_fixtures, [dora_register_of_information_profile_for/2]).

subject_complete(Subject, Result) :-
    dora_register_of_information_profile_for(Subject, Profile),
    register_of_information_duties_complete(Profile, Result, _).

with_value([], Key, Value, [attribute(Key, Value)]).
with_value([attribute(ElementKey, _)|Elements], Key, Value, [attribute(Key, Value)|Elements]) :-
    ElementKey == Key.
with_value([attribute(ElementKey, ElementValue)|Elements], Key, Value, [attribute(ElementKey, ElementValue)|Rest]) :-
    ElementKey \== Key,
    with_value(Elements, Key, Value, Rest).

planned_not_informed_triggers_open(Profile) :-
    dora_register_of_information_profile_for(triggers_unanswered, Base),
    append(Base, [attribute(competent_authority_informed_of_planned_arrangement, false)], Profile).

test(the_status_table_names_every_status) :-
    dora_register_of_information_status_values(StatusValues),
    StatusValues == [complete, incomplete, indeterminate, needs_legal_review, input_problems].
test(solo_all_performed_is_complete) :-
    subject_complete(solo_entity_all_performed, complete).
test(solo_missed_report_is_incomplete) :-
    subject_complete(solo_entity_yearly_report_missed, incomplete).
test(group_parent_all_performed_is_complete) :-
    subject_complete(group_parent_all_performed, complete).
test(group_parent_consistency_missed_is_incomplete) :-
    subject_complete(group_parent_consolidated_consistency_missed, incomplete).
test(critical_function_all_performed_is_complete) :-
    subject_complete(critical_function_entity_all_performed, complete).
test(critical_function_identifiers_missed_is_incomplete) :-
    subject_complete(critical_function_subcontractor_identifiers_missed, incomplete).
test(false_trigger_leaves_the_false_key_unread) :-
    subject_complete(false_trigger_with_unread_duty_key, complete).
test(planned_arrangement_informed_is_complete) :-
    subject_complete(planned_arrangement_informed, complete).
test(planned_arrangement_not_informed_is_incomplete) :-
    subject_complete(planned_arrangement_not_informed, incomplete).
test(branches_answered_is_complete) :-
    subject_complete(branches_and_intra_group_all_performed, complete).
test(branches_unanswered_is_indeterminate) :-
    subject_complete(branches_template_unanswered, indeterminate([register_includes_identification_of_branches_outside_home_country])).
test(a_trigger_that_decides_alone_is_named_first) :-
    planned_not_informed_triggers_open(Profile),
    register_of_information_duties_complete(Profile, indeterminate([entity_plans_arrangement_supporting_critical_or_important_function]), []).
test(the_deciding_trigger_true_gives_incomplete) :-
    planned_not_informed_triggers_open(Base),
    append(Base, [attribute(entity_plans_arrangement_supporting_critical_or_important_function, true)], Profile),
    register_of_information_duties_complete(Profile, incomplete, _).
test(the_deciding_trigger_false_names_the_next_trigger) :-
    planned_not_informed_triggers_open(Base),
    append(Base, [attribute(entity_plans_arrangement_supporting_critical_or_important_function, false)], Profile),
    register_of_information_duties_complete(Profile, indeterminate([financial_entity_responsible_for_sub_consolidated_register]), []).
test(data_quality_unsure_is_referred) :-
    subject_complete(data_quality_unsure, needs_legal_review(open_textured(template_information_meets_data_quality_principles, cite(eu_reg_2024_2956_art_3_3)), _)).
test(a_false_duty_decides_before_the_referral) :-
    subject_complete(data_quality_unsure_with_missed_report, incomplete).
test(a_key_of_another_order_is_an_input_problem) :-
    subject_complete(microenterprise_key_given, input_problems([unknown_key(financial_entity_is_microenterprise)])).
test(the_same_profile_without_it_is_complete) :-
    subject_complete(solo_entity_all_performed, complete).
test(required_with_a_request_adds_the_request_duty) :-
    dora_register_of_information_profile_for(solo_entity_all_performed, Solo),
    with_value(Solo, competent_authority_requested_register, true, Profile),
    register_of_information_duties_required(Profile, required(Duties), _),
    member(register_made_available_on_request, Duties),
    length(Duties, 23).
test(required_with_triggers_unanswered_is_indeterminate) :-
    dora_register_of_information_profile_for(triggers_unanswered, Profile),
    register_of_information_duties_required(Profile, indeterminate([financial_entity_responsible_for_sub_consolidated_register]), []).
test(outstanding_lists_the_missed_report) :-
    dora_register_of_information_profile_for(solo_entity_yearly_report_missed, Profile),
    register_of_information_duties_outstanding(Profile, outstanding([yearly_report_to_competent_authorities]), _).
test(outstanding_none_for_the_performing_entity) :-
    dora_register_of_information_profile_for(solo_entity_all_performed, Profile),
    register_of_information_duties_outstanding(Profile, none_outstanding, _).
test(outstanding_a_false_duty_does_not_end_the_query) :-
    dora_register_of_information_profile_for(triggers_unanswered, Base),
    with_value(Base, reported_to_competent_authorities_at_least_yearly, false, Profile),
    register_of_information_duties_outstanding(Profile, indeterminate([financial_entity_responsible_for_sub_consolidated_register]), []).

test(solo_missed_report_is_not_complete, fail) :-
    subject_complete(solo_entity_yearly_report_missed, complete).
test(group_parent_consistency_missed_is_not_complete, fail) :-
    subject_complete(group_parent_consolidated_consistency_missed, complete).
test(false_trigger_is_not_incomplete, fail) :-
    subject_complete(false_trigger_with_unread_duty_key, incomplete).
test(planned_arrangement_not_informed_is_not_complete, fail) :-
    subject_complete(planned_arrangement_not_informed, complete).
test(branches_unanswered_is_not_complete, fail) :-
    subject_complete(branches_template_unanswered, complete).
test(the_first_trigger_is_not_named_while_a_deciding_one_is_absent, fail) :-
    planned_not_informed_triggers_open(Profile),
    register_of_information_duties_complete(Profile, indeterminate([financial_entity_responsible_for_sub_consolidated_register]), _).
test(a_false_duty_is_not_referred, fail) :-
    subject_complete(data_quality_unsure_with_missed_report, needs_legal_review(_, _)).
test(a_key_of_another_order_is_not_complete, fail) :-
    subject_complete(microenterprise_key_given, complete).
test(required_without_a_request_omits_the_request_duty, fail) :-
    dora_register_of_information_profile_for(solo_entity_all_performed, Profile),
    register_of_information_duties_required(Profile, required(Duties), _),
    member(register_made_available_on_request, Duties).
test(required_with_triggers_unanswered_lists_no_duties, fail) :-
    dora_register_of_information_profile_for(triggers_unanswered, Profile),
    register_of_information_duties_required(Profile, required(_), _).
test(outstanding_lists_nothing_for_the_performing_entity, fail) :-
    dora_register_of_information_profile_for(solo_entity_all_performed, Profile),
    register_of_information_duties_outstanding(Profile, outstanding(_), _).

cp_test_names([the_status_table_names_every_status, solo_all_performed_is_complete, solo_missed_report_is_incomplete, group_parent_all_performed_is_complete, group_parent_consistency_missed_is_incomplete, critical_function_all_performed_is_complete, critical_function_identifiers_missed_is_incomplete, false_trigger_leaves_the_false_key_unread, planned_arrangement_informed_is_complete, planned_arrangement_not_informed_is_incomplete, branches_answered_is_complete, branches_unanswered_is_indeterminate, a_trigger_that_decides_alone_is_named_first, the_deciding_trigger_true_gives_incomplete, the_deciding_trigger_false_names_the_next_trigger, data_quality_unsure_is_referred, a_false_duty_decides_before_the_referral, a_key_of_another_order_is_an_input_problem, the_same_profile_without_it_is_complete, required_with_a_request_adds_the_request_duty, required_with_triggers_unanswered_is_indeterminate, outstanding_lists_the_missed_report, outstanding_none_for_the_performing_entity, outstanding_a_false_duty_does_not_end_the_query]).
cp_test_fail_names([solo_missed_report_is_not_complete, group_parent_consistency_missed_is_not_complete, false_trigger_is_not_incomplete, planned_arrangement_not_informed_is_not_complete, branches_unanswered_is_not_complete, the_first_trigger_is_not_named_while_a_deciding_one_is_absent, a_false_duty_is_not_referred, a_key_of_another_order_is_not_complete, required_without_a_request_omits_the_request_duty, required_with_triggers_unanswered_lists_no_duties, outstanding_lists_nothing_for_the_performing_entity]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
