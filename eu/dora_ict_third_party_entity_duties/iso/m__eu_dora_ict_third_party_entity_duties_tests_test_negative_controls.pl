% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_ict_third_party_entity_duties_tests_test_negative_controls, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_dora_ict_third_party_entity_duties_dora_ict_third_party_entity_duties, [entity_duties_required/3, entity_duties_complete/3, entity_duties_outstanding/3, ict_third_party_strategy_required/3, dora_ict_third_party_entity_duties_status_values/1]).
:- use_module(m__eu_dora_ict_third_party_entity_duties_kernel, [dora_ict_third_party_entity_duties_input_problems/2]).
:- use_module(m__eu_dora_ict_third_party_entity_duties_fixtures, [dora_ict_third_party_entity_duties_profile_for/2]).

subject_profile(Subject, Profile) :-
    dora_ict_third_party_entity_duties_profile_for(Subject, Profile).

unsure_function_profile([attribute(entity_exercises_access_inspection_and_audit_rights, false), attribute(supports_critical_or_important_function, unsure), attribute(arrangement_allows_further_subcontracting, false), attribute(provider_established_in_third_country, false)]).

true_function_profile([attribute(entity_exercises_access_inspection_and_audit_rights, false), attribute(supports_critical_or_important_function, true), attribute(arrangement_allows_further_subcontracting, false), attribute(provider_established_in_third_country, false)]).

test(the_status_table_names_complete_and_incomplete) :-
    dora_ict_third_party_entity_duties_status_values(StatusValues),
    member(complete, StatusValues),
    member(incomplete, StatusValues).
test(critical_arrangement_requires_an_exit_strategy) :-
    subject_profile(critical_arrangement_complete, Profile),
    entity_duties_required(Profile, required(Duties), _),
    member(exit_strategy, Duties).
test(plain_arrangement_gets_a_duty_list) :-
    subject_profile(plain_arrangement_complete, Profile),
    entity_duties_required(Profile, required([_|_]), _).
test(empty_profile_asks_for_the_audit_trigger) :-
    entity_duties_required([], indeterminate([entity_exercises_access_inspection_and_audit_rights]), []).
test(unsure_function_is_referred) :-
    unsure_function_profile(Profile),
    entity_duties_required(Profile, needs_legal_review(open_textured(supports_critical_or_important_function, cite(eu_reg_2022_2554_art_28_4_a)), _), []).
test(true_function_gets_its_duty_list) :-
    true_function_profile(Profile),
    entity_duties_required(Profile, required([_|_]), _).
test(plain_arrangement_is_complete) :-
    subject_profile(plain_arrangement_complete, Profile),
    entity_duties_complete(Profile, complete, _).
test(supervisory_assessment_not_performed_is_incomplete) :-
    subject_profile(plain_arrangement_supervisory_assessment_not_performed, Profile),
    entity_duties_complete(Profile, incomplete, _).
test(complex_audit_is_complete) :-
    subject_profile(complex_audit_arrangement_complete, Profile),
    entity_duties_complete(Profile, complete, _).
test(absent_exit_strategy_is_asked_for) :-
    subject_profile(critical_arrangement_exit_strategy_unanswered, Profile),
    entity_duties_complete(Profile, indeterminate([exit_strategy_in_place]), []).
test(false_exit_strategy_decides_before_the_absent_complexity) :-
    subject_profile(critical_arrangement_exit_strategy_not_performed_complexity_unanswered, Profile),
    entity_duties_complete(Profile, incomplete, _).
test(unsure_function_with_a_false_dependent_duty_is_referred) :-
    subject_profile(critical_judgement_unsure_dependent_duty_not_performed, Profile),
    entity_duties_complete(Profile, needs_legal_review(open_textured(supports_critical_or_important_function, cite(eu_reg_2022_2554_art_28_4_a)), _), []).
test(true_function_with_a_false_dependent_duty_is_incomplete) :-
    subject_profile(critical_judgement_true_dependent_duty_not_performed, Profile),
    entity_duties_complete(Profile, incomplete, _).
test(union_provider_is_complete) :-
    subject_profile(union_provider_data_protection_not_considered, Profile),
    entity_duties_complete(Profile, complete, _).
test(third_country_provider_is_incomplete) :-
    subject_profile(third_country_provider_data_protection_not_considered, Profile),
    entity_duties_complete(Profile, incomplete, _).
test(no_subcontracting_is_complete) :-
    subject_profile(no_subcontracting_arrangement_chains_not_assessed, Profile),
    entity_duties_complete(Profile, complete, _).
test(near_miss_has_an_outstanding_duty) :-
    subject_profile(audit_arrangement_frequency_not_predetermined, Profile),
    entity_duties_outstanding(Profile, outstanding([predetermined_audit_frequency_and_areas]), _).
test(audit_arrangement_has_none_outstanding) :-
    subject_profile(audit_arrangement_complete, Profile),
    entity_duties_outstanding(Profile, none_outstanding, _).
test(outstanding_waits_for_an_absent_key) :-
    subject_profile(critical_arrangement_exit_strategy_not_performed_concentration_unanswered, Profile),
    entity_duties_outstanding(Profile, indeterminate([considered_concentration_risk]), []).
test(other_entity_needs_a_strategy) :-
    subject_profile(plain_arrangement_complete, Profile),
    ict_third_party_strategy_required(Profile, strategy_required, _).
test(article_16_entity_needs_no_strategy) :-
    subject_profile(article_16_entity, Profile),
    ict_third_party_strategy_required(Profile, strategy_not_required, _).
test(microenterprise_needs_no_strategy) :-
    subject_profile(microenterprise_entity, Profile),
    ict_third_party_strategy_required(Profile, strategy_not_required, _).
test(unanswered_microenterprise_is_asked_for) :-
    subject_profile(entity_exemption_unanswered, Profile),
    ict_third_party_strategy_required(Profile, indeterminate([financial_entity_is_microenterprise]), []).
test(unsure_on_a_fact_is_wrong_type) :-
    subject_profile(fact_given_unsure_profile, Profile),
    dora_ict_third_party_entity_duties_input_problems(Profile, [wrong_type(arrangement_allows_further_subcontracting)]).
test(unsure_on_a_judgement_has_no_problem) :-
    subject_profile(judgement_given_unsure_profile, Profile),
    dora_ict_third_party_entity_duties_input_problems(Profile, []).
test(a_duplicate_key_is_refused) :-
    subject_profile(duplicate_key_profile, Profile),
    entity_duties_outstanding(Profile, input_problems([duplicate_key(exit_strategy_in_place)]), []).
test(an_unknown_key_is_refused_by_the_strategy_query) :-
    subject_profile(unknown_key_profile, Profile),
    ict_third_party_strategy_required(Profile, input_problems([unknown_key(unexpected_key)]), []).

test(plain_arrangement_requires_no_exit_strategy, fail) :-
    subject_profile(plain_arrangement_complete, Profile),
    entity_duties_required(Profile, required(Duties), _),
    member(exit_strategy, Duties).
test(answered_triggers_give_no_indeterminate, fail) :-
    subject_profile(plain_arrangement_complete, Profile),
    entity_duties_required(Profile, indeterminate(_), _).
test(true_function_is_not_referred, fail) :-
    true_function_profile(Profile),
    entity_duties_required(Profile, needs_legal_review(_, _), _).
test(plain_arrangement_is_not_incomplete, fail) :-
    subject_profile(plain_arrangement_complete, Profile),
    entity_duties_complete(Profile, incomplete, _).
test(supervisory_assessment_not_performed_is_not_complete, fail) :-
    subject_profile(plain_arrangement_supervisory_assessment_not_performed, Profile),
    entity_duties_complete(Profile, complete, _).
test(auditor_skills_not_verified_is_not_complete, fail) :-
    subject_profile(complex_audit_arrangement_auditor_skills_not_verified, Profile),
    entity_duties_complete(Profile, complete, _).
test(absent_exit_strategy_is_not_incomplete, fail) :-
    subject_profile(critical_arrangement_exit_strategy_unanswered, Profile),
    entity_duties_complete(Profile, incomplete, _).
test(unsure_function_is_not_incomplete, fail) :-
    subject_profile(critical_judgement_unsure_dependent_duty_not_performed, Profile),
    entity_duties_complete(Profile, incomplete, _).
test(union_provider_is_not_incomplete, fail) :-
    subject_profile(union_provider_data_protection_not_considered, Profile),
    entity_duties_complete(Profile, incomplete, _).
test(subcontracting_is_not_complete, fail) :-
    subject_profile(subcontracting_arrangement_chains_not_assessed, Profile),
    entity_duties_complete(Profile, complete, _).
test(near_miss_is_not_none_outstanding, fail) :-
    subject_profile(audit_arrangement_frequency_not_predetermined, Profile),
    entity_duties_outstanding(Profile, none_outstanding, _).
test(outstanding_gives_no_list_while_a_key_is_absent, fail) :-
    subject_profile(critical_arrangement_exit_strategy_not_performed_concentration_unanswered, Profile),
    entity_duties_outstanding(Profile, outstanding(_), _).
test(other_entity_is_not_exempt, fail) :-
    subject_profile(plain_arrangement_complete, Profile),
    ict_third_party_strategy_required(Profile, strategy_not_required, _).
test(article_16_entity_is_not_required, fail) :-
    subject_profile(article_16_entity, Profile),
    ict_third_party_strategy_required(Profile, strategy_required, _).
test(unsure_on_a_judgement_is_not_wrong_type, fail) :-
    subject_profile(judgement_given_unsure_profile, Profile),
    dora_ict_third_party_entity_duties_input_problems(Profile, [wrong_type(_)|_]).
test(a_single_key_is_not_refused, fail) :-
    subject_profile(single_key_profile, Profile),
    entity_duties_outstanding(Profile, input_problems(_), _).

cp_test_names([the_status_table_names_complete_and_incomplete, critical_arrangement_requires_an_exit_strategy, plain_arrangement_gets_a_duty_list, empty_profile_asks_for_the_audit_trigger, unsure_function_is_referred, true_function_gets_its_duty_list, plain_arrangement_is_complete, supervisory_assessment_not_performed_is_incomplete, complex_audit_is_complete, absent_exit_strategy_is_asked_for, false_exit_strategy_decides_before_the_absent_complexity, unsure_function_with_a_false_dependent_duty_is_referred, true_function_with_a_false_dependent_duty_is_incomplete, union_provider_is_complete, third_country_provider_is_incomplete, no_subcontracting_is_complete, near_miss_has_an_outstanding_duty, audit_arrangement_has_none_outstanding, outstanding_waits_for_an_absent_key, other_entity_needs_a_strategy, article_16_entity_needs_no_strategy, microenterprise_needs_no_strategy, unanswered_microenterprise_is_asked_for, unsure_on_a_fact_is_wrong_type, unsure_on_a_judgement_has_no_problem, a_duplicate_key_is_refused, an_unknown_key_is_refused_by_the_strategy_query]).
cp_test_fail_names([plain_arrangement_requires_no_exit_strategy, answered_triggers_give_no_indeterminate, true_function_is_not_referred, plain_arrangement_is_not_incomplete, supervisory_assessment_not_performed_is_not_complete, auditor_skills_not_verified_is_not_complete, absent_exit_strategy_is_not_incomplete, unsure_function_is_not_incomplete, union_provider_is_not_incomplete, subcontracting_is_not_complete, near_miss_is_not_none_outstanding, outstanding_gives_no_list_while_a_key_is_absent, other_entity_is_not_exempt, article_16_entity_is_not_required, unsure_on_a_judgement_is_not_wrong_type, a_single_key_is_not_refused]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
