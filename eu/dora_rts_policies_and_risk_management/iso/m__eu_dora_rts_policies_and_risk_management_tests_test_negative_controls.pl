% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_rts_policies_and_risk_management_tests_test_negative_controls, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(library(reif), [(=)/3]).
:- use_module(m__eu_dora_rts_policies_and_risk_management_dora_rts_policies_and_risk_management, [dora_rts_policies_and_risk_management_status/2, dora_rts_policies_and_risk_management_status_values/1, rts_policies_and_risk_management_duties_required/3, rts_policies_and_risk_management_duties_complete/3, rts_policies_and_risk_management_duties_outstanding/3]).
:- use_module(m__eu_dora_rts_policies_and_risk_management_fixtures, [dora_rts_policies_and_risk_management_profile_for/2]).
:- use_module(library(reif), [if_/3]).

with_value(Profile, ProfileKey, Value, NewProfile) :-
    maplist(replaced_attribute(ProfileKey, Value), Profile, NewProfile).

replaced_attribute(ProfileKey, Value, attribute(OtherKey, OldValue), attribute(OtherKey, NewValue)) :-
    if_(OtherKey = ProfileKey, NewValue = Value, NewValue = OldValue).

test(the_status_table_holds_the_near_miss_atoms) :-
    dora_rts_policies_and_risk_management_status_values(StatusValues),
    member(complete, StatusValues),
    member(incomplete, StatusValues),
    member(simplified_framework_entity, StatusValues).
test(every_duty_performed_is_complete) :-
    dora_rts_policies_and_risk_management_profile_for(all_duties_performed, Profile),
    dora_rts_policies_and_risk_management_status(Profile, complete).
test(one_duty_not_performed_is_incomplete) :-
    dora_rts_policies_and_risk_management_profile_for(one_duty_not_performed, Profile),
    dora_rts_policies_and_risk_management_status(Profile, incomplete).
test(an_article_16_1_entity_is_simplified_framework_entity) :-
    dora_rts_policies_and_risk_management_profile_for(simplified_framework_entity_with_duties_performed, Profile),
    rts_policies_and_risk_management_duties_complete(Profile, simplified_framework_entity, [cite(eu_reg_2022_2554_art_16_1)]).
test(the_gate_absent_is_asked) :-
    dora_rts_policies_and_risk_management_profile_for(gate_unanswered, Profile),
    rts_policies_and_risk_management_duties_outstanding(Profile, indeterminate([financial_entity_is_article_16_1_entity]), []).
test(the_gate_false_requires_the_duties) :-
    dora_rts_policies_and_risk_management_profile_for(all_duties_performed, Profile),
    rts_policies_and_risk_management_duties_required(Profile, required([_|_]), _Citations).
test(an_absent_duty_key_is_asked) :-
    dora_rts_policies_and_risk_management_profile_for(duty_unanswered, Profile),
    rts_policies_and_risk_management_duties_complete(Profile, indeterminate([security_policies_contain_safeguards_against_intrusions_and_data_misuse]), []).
test(an_unsure_duty_is_referred) :-
    dora_rts_policies_and_risk_management_profile_for(duty_judgement_unsure, Profile),
    rts_policies_and_risk_management_duties_complete(Profile, needs_legal_review(open_textured(security_policies_contain_indicators_and_measures_for_implementation_and_exceptions, cite(eu_reg_2024_1774_art_2_2_c)), _Context), []).
test(the_same_duty_false_is_incomplete) :-
    dora_rts_policies_and_risk_management_profile_for(duty_judgement_unsure, Profile),
    with_value(Profile, security_policies_contain_indicators_and_measures_for_implementation_and_exceptions, false, FalseProfile),
    rts_policies_and_risk_management_duties_complete(FalseProfile, incomplete, _Citations).
test(complete_is_settled_by_the_false_duty) :-
    dora_rts_policies_and_risk_management_profile_for(duty_not_performed_and_another_unanswered, Profile),
    rts_policies_and_risk_management_duties_complete(Profile, incomplete, _Citations).
test(outstanding_still_asks_the_absent_key) :-
    dora_rts_policies_and_risk_management_profile_for(duty_not_performed_and_another_unanswered, Profile),
    rts_policies_and_risk_management_duties_outstanding(Profile, indeterminate([size_risk_profile_and_complexity_taken_into_account]), []).
test(a_failing_duty_is_outstanding) :-
    dora_rts_policies_and_risk_management_profile_for(one_duty_not_performed, Profile),
    rts_policies_and_risk_management_duties_outstanding(Profile, outstanding([network_security]), [cite(eu_reg_2024_1774_art_2_1_a)]).
test(every_duty_performed_is_none_outstanding) :-
    dora_rts_policies_and_risk_management_profile_for(all_duties_performed, Profile),
    rts_policies_and_risk_management_duties_outstanding(Profile, none_outstanding, _Citations).
test(an_unknown_key_is_an_input_problem) :-
    dora_rts_policies_and_risk_management_profile_for(unknown_key_present, Profile),
    rts_policies_and_risk_management_duties_complete(Profile, input_problems([unknown_key(colour)]), []).

test(one_duty_not_performed_is_not_complete, fail) :-
    dora_rts_policies_and_risk_management_profile_for(one_duty_not_performed, Profile),
    dora_rts_policies_and_risk_management_status(Profile, complete).
test(every_duty_performed_is_not_incomplete, fail) :-
    dora_rts_policies_and_risk_management_profile_for(all_duties_performed, Profile),
    dora_rts_policies_and_risk_management_status(Profile, incomplete).
test(the_gate_false_is_not_simplified_framework_entity, fail) :-
    dora_rts_policies_and_risk_management_profile_for(all_duties_performed, Profile),
    rts_policies_and_risk_management_duties_complete(Profile, simplified_framework_entity, _Citations).
test(an_article_16_1_entity_is_not_complete, fail) :-
    dora_rts_policies_and_risk_management_profile_for(simplified_framework_entity_with_duties_performed, Profile),
    rts_policies_and_risk_management_duties_complete(Profile, complete, _Citations).
test(the_gate_given_is_not_asked, fail) :-
    dora_rts_policies_and_risk_management_profile_for(all_duties_performed, Profile),
    rts_policies_and_risk_management_duties_outstanding(Profile, indeterminate(_), _Citations).
test(the_gate_true_requires_no_duty, fail) :-
    dora_rts_policies_and_risk_management_profile_for(simplified_framework_entity_with_duties_performed, Profile),
    rts_policies_and_risk_management_duties_required(Profile, required(_), _Citations).
test(an_absent_duty_key_is_not_complete, fail) :-
    dora_rts_policies_and_risk_management_profile_for(duty_unanswered, Profile),
    rts_policies_and_risk_management_duties_complete(Profile, complete, _Citations).
test(every_key_present_is_not_indeterminate, fail) :-
    dora_rts_policies_and_risk_management_profile_for(all_duties_performed, Profile),
    rts_policies_and_risk_management_duties_complete(Profile, indeterminate(_), _Citations).
test(the_same_duty_false_is_not_referred, fail) :-
    dora_rts_policies_and_risk_management_profile_for(duty_judgement_unsure, Profile),
    with_value(Profile, security_policies_contain_indicators_and_measures_for_implementation_and_exceptions, false, FalseProfile),
    rts_policies_and_risk_management_duties_complete(FalseProfile, needs_legal_review(_, _), _Citations).
test(an_unsure_duty_is_not_outstanding_yet, fail) :-
    dora_rts_policies_and_risk_management_profile_for(duty_judgement_unsure, Profile),
    rts_policies_and_risk_management_duties_outstanding(Profile, outstanding(_), _Citations).
test(outstanding_does_not_list_before_the_absent_key_is_answered, fail) :-
    dora_rts_policies_and_risk_management_profile_for(duty_not_performed_and_another_unanswered, Profile),
    rts_policies_and_risk_management_duties_outstanding(Profile, outstanding(_), _Citations).
test(complete_does_not_ask_the_absent_key, fail) :-
    dora_rts_policies_and_risk_management_profile_for(duty_not_performed_and_another_unanswered, Profile),
    rts_policies_and_risk_management_duties_complete(Profile, indeterminate(_), _Citations).
test(every_duty_performed_has_nothing_outstanding, fail) :-
    dora_rts_policies_and_risk_management_profile_for(all_duties_performed, Profile),
    rts_policies_and_risk_management_duties_outstanding(Profile, outstanding(_), _Citations).
test(a_failing_duty_is_not_none_outstanding, fail) :-
    dora_rts_policies_and_risk_management_profile_for(one_duty_not_performed, Profile),
    rts_policies_and_risk_management_duties_outstanding(Profile, none_outstanding, _Citations).
test(an_unknown_key_gets_no_final_answer, fail) :-
    dora_rts_policies_and_risk_management_profile_for(unknown_key_present, Profile),
    rts_policies_and_risk_management_duties_complete(Profile, complete, _Citations).
test(a_clean_profile_has_no_input_problem, fail) :-
    dora_rts_policies_and_risk_management_profile_for(all_duties_performed, Profile),
    rts_policies_and_risk_management_duties_complete(Profile, input_problems(_), _Citations).

cp_test_names([the_status_table_holds_the_near_miss_atoms, every_duty_performed_is_complete, one_duty_not_performed_is_incomplete, an_article_16_1_entity_is_simplified_framework_entity, the_gate_absent_is_asked, the_gate_false_requires_the_duties, an_absent_duty_key_is_asked, an_unsure_duty_is_referred, the_same_duty_false_is_incomplete, complete_is_settled_by_the_false_duty, outstanding_still_asks_the_absent_key, a_failing_duty_is_outstanding, every_duty_performed_is_none_outstanding, an_unknown_key_is_an_input_problem]).
cp_test_fail_names([one_duty_not_performed_is_not_complete, every_duty_performed_is_not_incomplete, the_gate_false_is_not_simplified_framework_entity, an_article_16_1_entity_is_not_complete, the_gate_given_is_not_asked, the_gate_true_requires_no_duty, an_absent_duty_key_is_not_complete, every_key_present_is_not_indeterminate, the_same_duty_false_is_not_referred, an_unsure_duty_is_not_outstanding_yet, outstanding_does_not_list_before_the_absent_key_is_answered, complete_does_not_ask_the_absent_key, every_duty_performed_has_nothing_outstanding, a_failing_duty_is_not_none_outstanding, an_unknown_key_gets_no_final_answer, a_clean_profile_has_no_input_problem]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
