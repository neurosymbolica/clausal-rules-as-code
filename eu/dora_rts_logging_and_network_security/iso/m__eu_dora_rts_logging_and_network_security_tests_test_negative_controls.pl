% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_rts_logging_and_network_security_tests_test_negative_controls, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_dora_rts_logging_and_network_security_dora_rts_logging_and_network_security, [dora_rts_logging_and_network_security_status_values/1, rts_logging_and_network_security_duties_required/3, rts_logging_and_network_security_duties_outstanding/3]).
:- use_module(m__eu_dora_rts_logging_and_network_security_fixtures, [dora_rts_logging_and_network_security_profile_for/2, dora_rts_logging_and_network_security_assess/2]).

verdict_of(Subject, Status) :-
    dora_rts_logging_and_network_security_assess(Subject, dora_rts_logging_and_network_security_verdict(Status, _)).

test(the_status_table_holds_every_near_miss_atom) :-
    dora_rts_logging_and_network_security_status_values(StatusValues),
    member(complete, StatusValues),
    member(incomplete, StatusValues),
    member(simplified_framework_entity, StatusValues),
    member(indeterminate, StatusValues),
    member(needs_legal_review, StatusValues),
    member(input_problems, StatusValues).
test(all_performed_is_complete) :-
    verdict_of(all_performed_larger_entity_with_critical_systems, complete).
test(one_always_duty_false_is_incomplete) :-
    verdict_of(encryption_not_performed_larger_entity, incomplete).
test(a_microenterprise_with_every_duty_performed_is_complete) :-
    verdict_of(all_performed_microenterprise_without_critical_systems, complete).
test(a_microenterprise_without_the_periodic_review_is_incomplete) :-
    verdict_of(periodic_review_not_performed_microenterprise, incomplete).
test(a_microenterprise_without_a_yearly_review_is_complete) :-
    verdict_of(yearly_review_not_performed_microenterprise, complete).
test(a_larger_entity_without_a_yearly_review_is_incomplete) :-
    verdict_of(yearly_review_not_performed_larger_entity, incomplete).
test(no_verification_without_critical_systems_is_complete) :-
    verdict_of(verification_not_performed_without_critical_systems, complete).
test(no_verification_with_critical_systems_is_incomplete) :-
    verdict_of(verification_not_performed_with_critical_systems, incomplete).
test(an_article_16_1_entity_is_a_simplified_framework_entity) :-
    verdict_of(article_16_1_entity, simplified_framework_entity).
test(the_gate_not_stated_is_asked_first) :-
    verdict_of(gate_not_stated, indeterminate([financial_entity_is_article_16_1_entity])).
test(both_reviews_false_is_incomplete_without_the_size_class) :-
    verdict_of(both_reviews_not_performed_size_not_stated, incomplete).
test(only_the_yearly_review_false_asks_the_size_class) :-
    verdict_of(yearly_review_not_performed_size_not_stated, indeterminate([financial_entity_is_microenterprise])).
test(an_absent_always_duty_is_named_before_the_size_class) :-
    verdict_of(logging_duty_and_size_not_stated, indeterminate([logging_procedures_protocols_and_tools_developed_documented_and_implemented])).
test(the_size_class_is_named_once_the_duty_is_given) :-
    verdict_of(size_not_stated_logging_duty_performed, indeterminate([financial_entity_is_microenterprise])).
test(the_critical_question_is_skipped_when_the_verification_is_performed) :-
    verdict_of(verification_performed_critical_not_stated, complete).
test(the_critical_question_is_asked_when_the_verification_is_not_performed) :-
    verdict_of(verification_not_performed_critical_not_stated, indeterminate([financial_entity_has_ict_systems_supporting_critical_or_important_functions])).
test(an_unsure_judgement_needs_legal_review) :-
    verdict_of(encryption_unsure, needs_legal_review(open_textured(network_connections_encrypted, cite(eu_reg_2024_1774_art_13_e)), [inputs_relied_on(_)])).
test(an_unknown_key_is_an_input_problem) :-
    verdict_of(unknown_key_present, input_problems([unknown_key(colour)])).
test(a_fact_given_unsure_is_wrong_type) :-
    verdict_of(fact_given_unsure, input_problems([wrong_type(financial_entity_is_microenterprise)])).
test(a_duplicate_gate_is_a_duplicate_key) :-
    verdict_of(duplicate_gate_key, input_problems([duplicate_key(financial_entity_is_article_16_1_entity)])).
test(the_gate_alone_is_well_formed_and_asks_the_first_duty) :-
    verdict_of(gate_only_stated, indeterminate([logging_procedures_protocols_and_tools_developed_documented_and_implemented])).
test(several_failed_duties_are_outstanding) :-
    dora_rts_logging_and_network_security_profile_for(several_duties_not_performed, Profile),
    rts_logging_and_network_security_duties_outstanding(Profile, outstanding([log_retention_period, encryption_of_network_connections, six_monthly_firewall_rule_verification]), _).
test(every_duty_performed_is_none_outstanding) :-
    dora_rts_logging_and_network_security_profile_for(all_performed_larger_entity_with_critical_systems, Profile),
    rts_logging_and_network_security_duties_outstanding(Profile, none_outstanding, _).
test(a_false_duty_does_not_end_the_outstanding_query) :-
    dora_rts_logging_and_network_security_profile_for(both_reviews_not_performed_size_not_stated, Profile),
    rts_logging_and_network_security_duties_outstanding(Profile, indeterminate([financial_entity_is_microenterprise]), []).
test(critical_systems_require_the_six_monthly_verification) :-
    dora_rts_logging_and_network_security_profile_for(all_performed_larger_entity_with_critical_systems, Profile),
    rts_logging_and_network_security_duties_required(Profile, required(Duties), _),
    member(six_monthly_firewall_rule_verification, Duties).

test(one_always_duty_false_is_not_complete, fail) :-
    verdict_of(encryption_not_performed_larger_entity, complete).
test(a_microenterprise_without_the_periodic_review_is_not_complete, fail) :-
    verdict_of(periodic_review_not_performed_microenterprise, complete).
test(a_microenterprise_without_a_yearly_review_is_not_incomplete, fail) :-
    verdict_of(yearly_review_not_performed_microenterprise, incomplete).
test(a_larger_entity_without_a_yearly_review_is_not_complete, fail) :-
    verdict_of(yearly_review_not_performed_larger_entity, complete).
test(no_verification_with_critical_systems_is_not_complete, fail) :-
    verdict_of(verification_not_performed_with_critical_systems, complete).
test(an_article_16_1_entity_is_not_complete, fail) :-
    verdict_of(article_16_1_entity, complete).
test(the_gate_false_is_not_a_simplified_framework_entity, fail) :-
    verdict_of(all_performed_larger_entity_with_critical_systems, simplified_framework_entity).
test(the_gate_not_stated_is_not_complete, fail) :-
    verdict_of(gate_not_stated, complete).
test(only_the_yearly_review_false_is_not_incomplete, fail) :-
    verdict_of(yearly_review_not_performed_size_not_stated, incomplete).
test(an_absent_always_duty_is_not_behind_the_size_class, fail) :-
    verdict_of(logging_duty_and_size_not_stated, indeterminate([financial_entity_is_microenterprise])).
test(the_unperformed_verification_is_not_complete_without_the_critical_question, fail) :-
    verdict_of(verification_not_performed_critical_not_stated, complete).
test(an_unsure_judgement_is_not_complete, fail) :-
    verdict_of(encryption_unsure, complete).
test(an_unknown_key_is_not_complete, fail) :-
    verdict_of(unknown_key_present, complete).
test(a_duplicate_gate_is_not_a_simplified_framework_entity, fail) :-
    verdict_of(duplicate_gate_key, simplified_framework_entity).
test(several_failed_duties_are_not_none_outstanding, fail) :-
    dora_rts_logging_and_network_security_profile_for(several_duties_not_performed, Profile),
    rts_logging_and_network_security_duties_outstanding(Profile, none_outstanding, _).
test(every_duty_performed_has_no_outstanding_list, fail) :-
    dora_rts_logging_and_network_security_profile_for(all_performed_larger_entity_with_critical_systems, Profile),
    rts_logging_and_network_security_duties_outstanding(Profile, outstanding(_), _).
test(no_critical_systems_do_not_require_the_six_monthly_verification, fail) :-
    dora_rts_logging_and_network_security_profile_for(all_performed_microenterprise_without_critical_systems, Profile),
    rts_logging_and_network_security_duties_required(Profile, required(Duties), _),
    member(six_monthly_firewall_rule_verification, Duties).
test(a_microenterprise_does_not_require_the_yearly_review, fail) :-
    dora_rts_logging_and_network_security_profile_for(all_performed_microenterprise_without_critical_systems, Profile),
    rts_logging_and_network_security_duties_required(Profile, required(Duties), _),
    member(yearly_network_architecture_review, Duties).
test(an_article_16_1_entity_has_no_required_list, fail) :-
    dora_rts_logging_and_network_security_profile_for(article_16_1_entity, Profile),
    rts_logging_and_network_security_duties_required(Profile, required(_), _).

cp_test_names([the_status_table_holds_every_near_miss_atom, all_performed_is_complete, one_always_duty_false_is_incomplete, a_microenterprise_with_every_duty_performed_is_complete, a_microenterprise_without_the_periodic_review_is_incomplete, a_microenterprise_without_a_yearly_review_is_complete, a_larger_entity_without_a_yearly_review_is_incomplete, no_verification_without_critical_systems_is_complete, no_verification_with_critical_systems_is_incomplete, an_article_16_1_entity_is_a_simplified_framework_entity, the_gate_not_stated_is_asked_first, both_reviews_false_is_incomplete_without_the_size_class, only_the_yearly_review_false_asks_the_size_class, an_absent_always_duty_is_named_before_the_size_class, the_size_class_is_named_once_the_duty_is_given, the_critical_question_is_skipped_when_the_verification_is_performed, the_critical_question_is_asked_when_the_verification_is_not_performed, an_unsure_judgement_needs_legal_review, an_unknown_key_is_an_input_problem, a_fact_given_unsure_is_wrong_type, a_duplicate_gate_is_a_duplicate_key, the_gate_alone_is_well_formed_and_asks_the_first_duty, several_failed_duties_are_outstanding, every_duty_performed_is_none_outstanding, a_false_duty_does_not_end_the_outstanding_query, critical_systems_require_the_six_monthly_verification]).
cp_test_fail_names([one_always_duty_false_is_not_complete, a_microenterprise_without_the_periodic_review_is_not_complete, a_microenterprise_without_a_yearly_review_is_not_incomplete, a_larger_entity_without_a_yearly_review_is_not_complete, no_verification_with_critical_systems_is_not_complete, an_article_16_1_entity_is_not_complete, the_gate_false_is_not_a_simplified_framework_entity, the_gate_not_stated_is_not_complete, only_the_yearly_review_false_is_not_incomplete, an_absent_always_duty_is_not_behind_the_size_class, the_unperformed_verification_is_not_complete_without_the_critical_question, an_unsure_judgement_is_not_complete, an_unknown_key_is_not_complete, a_duplicate_gate_is_not_a_simplified_framework_entity, several_failed_duties_are_not_none_outstanding, every_duty_performed_has_no_outstanding_list, no_critical_systems_do_not_require_the_six_monthly_verification, a_microenterprise_does_not_require_the_yearly_review, an_article_16_1_entity_has_no_required_list]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
