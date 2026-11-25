% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_ict_incident_management_process_tests_test_input_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_dora_ict_incident_management_process_dora_ict_incident_management_process, [ict_incident_management_process_duties_required/3, ict_incident_management_process_duties_complete/3, ict_incident_management_process_duties_outstanding/3, dora_ict_incident_management_process_status/2, dora_ict_incident_management_process_status_values/1]).
:- use_module(m__eu_dora_ict_incident_management_process_kernel, [dora_ict_incident_management_process_input_problems/2]).
:- use_module(m__eu_dora_ict_incident_management_process_fixtures, [dora_ict_incident_management_process_profile_for/2]).

fixed_citations([cite(eu_reg_2022_2554_art_17_1), cite(eu_reg_2022_2554_art_17_2), cite(eu_reg_2022_2554_art_17_3), cite(eu_reg_2022_2554_art_18_2)]).

test(status_holds_with_the_verdict_bound) :-
    dora_ict_incident_management_process_profile_for(all_duties_performed, Profile),
    findall(Status, dora_ict_incident_management_process_status(Profile, Status), [BaselineStatus]),
    dora_ict_incident_management_process_status(Profile, BaselineStatus).
test(complete_holds_bound) :-
    dora_ict_incident_management_process_profile_for(all_duties_performed, Profile),
    fixed_citations(Fixed),
    ict_incident_management_process_duties_complete(Profile, complete, Fixed).
test(incomplete_holds_bound) :-
    dora_ict_incident_management_process_profile_for(early_warning_indicators_not_performed, Profile),
    fixed_citations(Fixed),
    ict_incident_management_process_duties_complete(Profile, incomplete, Fixed).
test(indeterminate_holds_bound) :-
    dora_ict_incident_management_process_profile_for(last_duty_unanswered, Profile),
    ict_incident_management_process_duties_complete(Profile, indeterminate([cyber_threats_classified_as_significant_on_the_article_18_2_criteria]), []).
test(referral_holds_bound) :-
    dora_ict_incident_management_process_profile_for(communication_plans_unsure, Profile),
    ict_incident_management_process_duties_complete(Profile, needs_legal_review(open_textured(communication_notification_escalation_and_counterpart_information_plans_set_out, cite(eu_reg_2022_2554_art_17_3_d)), [inputs_relied_on(_)]), []).
test(required_holds_bound) :-
    fixed_citations(Fixed),
    ict_incident_management_process_duties_required([], required([incident_management_process, recording_of_incidents_and_significant_cyber_threats, monitoring_handling_and_follow_up_procedures, early_warning_indicators, identification_and_classification_procedures, incident_roles_and_responsibilities, communication_and_escalation_plans, reporting_to_senior_management_and_management_body, incident_response_procedures, classification_of_significant_cyber_threats]), Fixed).
test(outstanding_holds_bound) :-
    dora_ict_incident_management_process_profile_for(both_article_17_2_duties_not_performed, Profile),
    ict_incident_management_process_duties_outstanding(Profile, outstanding([recording_of_incidents_and_significant_cyber_threats, monitoring_handling_and_follow_up_procedures]), [cite(eu_reg_2022_2554_art_17_2)]).
test(none_outstanding_holds_bound) :-
    dora_ict_incident_management_process_profile_for(all_duties_performed, Profile),
    fixed_citations(Fixed),
    ict_incident_management_process_duties_outstanding(Profile, none_outstanding, Fixed).
test(an_unbound_value_is_wrong_type) :-
    dora_ict_incident_management_process_input_problems([attribute(early_warning_indicators_put_in_place, _)], [wrong_type(early_warning_indicators_put_in_place)]).
test(a_number_value_is_wrong_type) :-
    dora_ict_incident_management_process_input_problems([attribute(incident_response_procedures_established, 1.0)], [wrong_type(incident_response_procedures_established)]).
test(an_unbound_key_is_named_as_given) :-
    dora_ict_incident_management_process_input_problems([attribute(GivenKey, red)], Problems),
    Problems = [unknown_key(NamedKey)],
    NamedKey == GivenKey.
test(two_distinct_unbound_keys_are_two_keys) :-
    dora_ict_incident_management_process_input_problems([attribute(FirstKey, red), attribute(SecondKey, blue)], Problems),
    Problems = [unknown_key(FirstNamed), unknown_key(SecondNamed)],
    FirstNamed == FirstKey,
    SecondNamed == SecondKey.
test(the_same_unbound_key_twice_is_one_key) :-
    dora_ict_incident_management_process_input_problems([attribute(GivenKey, red), attribute(GivenKey, blue)], Problems),
    Problems = [unknown_key(NamedKey)],
    NamedKey == GivenKey.
test(a_number_key_is_unknown) :-
    dora_ict_incident_management_process_input_problems([attribute(7, true)], [unknown_key(7)]).
test(an_unknown_key_value_is_not_checked) :-
    dora_ict_incident_management_process_input_problems([attribute(colour, _), attribute(colour, 3)], [unknown_key(colour)]).
test(a_partial_list_is_wrong_type_profile) :-
    dora_ict_incident_management_process_input_problems([attribute(early_warning_indicators_put_in_place, true)|_], [wrong_type(profile)]).
test(a_non_attribute_element_is_wrong_type_profile) :-
    dora_ict_incident_management_process_input_problems([attribute(colour, red), pair(colour, red)], [wrong_type(profile)]).
test(problems_come_in_contract_order_then_unknown_keys) :-
    dora_ict_incident_management_process_input_problems([attribute(colour, red), attribute(incident_response_procedures_established, yes), attribute(early_warning_indicators_put_in_place, true), attribute(early_warning_indicators_put_in_place, true)], Problems),
    Problems == [duplicate_key(early_warning_indicators_put_in_place), wrong_type(incident_response_procedures_established), unknown_key(colour)].
test(the_input_check_yields_one_answer) :-
    findall(Problems, dora_ict_incident_management_process_input_problems([attribute(colour, red)], Problems), Answers),
    Answers == [[unknown_key(colour)]].
test(an_input_problem_is_refused_by_every_query) :-
    ict_incident_management_process_duties_required([attribute(colour, red)], input_problems([unknown_key(colour)]), []),
    ict_incident_management_process_duties_complete([attribute(colour, red)], input_problems([unknown_key(colour)]), []),
    ict_incident_management_process_duties_outstanding([attribute(colour, red)], input_problems([unknown_key(colour)]), []).

test(every_other_bound_status_is_rejected, fail) :-
    dora_ict_incident_management_process_profile_for(all_duties_performed, Profile),
    findall(Status, dora_ict_incident_management_process_status(Profile, Status), [BaselineStatus]),
    dora_ict_incident_management_process_status_values(StatusValues),
    member(Other, StatusValues),
    dif(Other, BaselineStatus),
    dora_ict_incident_management_process_status(Profile, Other).

cp_test_names([status_holds_with_the_verdict_bound, complete_holds_bound, incomplete_holds_bound, indeterminate_holds_bound, referral_holds_bound, required_holds_bound, outstanding_holds_bound, none_outstanding_holds_bound, an_unbound_value_is_wrong_type, a_number_value_is_wrong_type, an_unbound_key_is_named_as_given, two_distinct_unbound_keys_are_two_keys, the_same_unbound_key_twice_is_one_key, a_number_key_is_unknown, an_unknown_key_value_is_not_checked, a_partial_list_is_wrong_type_profile, a_non_attribute_element_is_wrong_type_profile, problems_come_in_contract_order_then_unknown_keys, the_input_check_yields_one_answer, an_input_problem_is_refused_by_every_query]).
cp_test_fail_names([every_other_bound_status_is_rejected]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
