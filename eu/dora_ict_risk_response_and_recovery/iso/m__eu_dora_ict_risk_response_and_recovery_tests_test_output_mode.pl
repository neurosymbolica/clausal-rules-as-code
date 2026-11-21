% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_ict_risk_response_and_recovery_tests_test_output_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_lists_extra, [last/2]).
:- use_module(m__eu_dora_ict_risk_response_and_recovery_dora_ict_risk_response_and_recovery, [ict_risk_response_and_recovery_duties_required/3, ict_risk_response_and_recovery_duties_complete/3, ict_risk_response_and_recovery_duties_outstanding/3, decide_dora_ict_risk_response_and_recovery/2, dora_ict_risk_response_and_recovery_status/2, dora_ict_risk_response_and_recovery_checklist/2]).
:- use_module(m__eu_dora_ict_risk_response_and_recovery_kernel, [dora_ict_risk_response_and_recovery_input_problems/2]).
:- use_module(m__eu_dora_ict_risk_response_and_recovery_fixtures, [dora_ict_risk_response_and_recovery_profile_for/2]).

test(the_baseline_profile_yields_exactly_one_status) :-
    dora_ict_risk_response_and_recovery_profile_for(large_credit_institution_all_performed, Profile),
    findall(Status, dora_ict_risk_response_and_recovery_status(Profile, Status), Statuses),
    Statuses == [complete].
test(the_verdict_carries_the_seventeen_citations) :-
    dora_ict_risk_response_and_recovery_profile_for(large_credit_institution_all_performed, Profile),
    decide_dora_ict_risk_response_and_recovery(Profile, dora_ict_risk_response_and_recovery_verdict(complete, Citations)),
    sort(Citations, CitationSet),
    length(CitationSet, 17).
test(a_central_securities_depository_reads_out_twenty_nine_duties) :-
    dora_ict_risk_response_and_recovery_profile_for(central_securities_depository_all_performed, Profile),
    findall(Result - Citations, ict_risk_response_and_recovery_duties_required(Profile, Result, Citations), [required(Duties) - Citations]),
    length(Duties, 29),
    Duties = [ict_business_continuity_policy|_],
    last(Duties, recovery_time_and_recovery_point_objectives),
    member(secondary_site_immediately_accessible, Duties),
    length(Citations, 13).
test(a_large_credit_institution_reads_out_no_secondary_site) :-
    dora_ict_risk_response_and_recovery_profile_for(large_credit_institution_all_performed, Profile),
    ict_risk_response_and_recovery_duties_required(Profile, required(Duties), _),
    length(Duties, 24).
test(the_referral_reads_out_its_key_citation_and_pairs) :-
    dora_ict_risk_response_and_recovery_profile_for(central_counterparty_recovery_unsure, Profile),
    findall(Result - Citations, ict_risk_response_and_recovery_duties_complete(Profile, Result, Citations), [needs_legal_review(open_textured(Key, Citation), [inputs_relied_on(Pairs)]) - []]),
    Key == recovery_plans_enable_recovery_of_all_transactions,
    Citation == cite(eu_reg_2022_2554_art_12_3),
    length(Pairs, 45),
    Pairs = [financial_entity_is_article_16_1_entity - false|_],
    member(recovery_plans_enable_recovery_of_all_transactions - unsure, Pairs).
test(the_outstanding_list_reads_out) :-
    dora_ict_risk_response_and_recovery_profile_for(microenterprise_need_for_redundancy_not_assessed, Profile),
    findall(Result - Citations, ict_risk_response_and_recovery_duties_outstanding(Profile, Result, Citations), Answers),
    Answers == [outstanding([assessment_of_need_for_redundant_ict_capacities]) - [cite(eu_reg_2022_2554_art_12_4)]].
test(the_size_is_named_when_one_redundancy_duty_fails) :-
    dora_ict_risk_response_and_recovery_profile_for(size_not_stated_one_redundancy_duty_failing, Profile),
    findall(Result, ict_risk_response_and_recovery_duties_complete(Profile, Result, _), Results),
    Results == [indeterminate([financial_entity_is_microenterprise])].
test(the_size_split_reads_out_incomplete) :-
    dora_ict_risk_response_and_recovery_profile_for(size_not_stated_both_redundancy_duties_failing, Profile),
    findall(Result, ict_risk_response_and_recovery_duties_complete(Profile, Result, _), Results),
    Results == [incomplete].
test(an_applying_duty_is_named_before_a_trigger_behind_it) :-
    dora_ict_risk_response_and_recovery_profile_for(policy_and_activation_not_stated, Profile),
    findall(Result, ict_risk_response_and_recovery_duties_complete(Profile, Result, _), Results),
    Results == [indeterminate([has_ict_business_continuity_policy])].
test(the_outstanding_query_names_the_trigger_first) :-
    dora_ict_risk_response_and_recovery_profile_for(policy_and_activation_not_stated, Profile),
    findall(Result, ict_risk_response_and_recovery_duties_outstanding(Profile, Result, _), Results),
    Results == [indeterminate([business_continuity_or_response_and_recovery_plans_activated])].
test(the_trigger_is_named_once_every_applying_duty_is_known) :-
    dora_ict_risk_response_and_recovery_profile_for(activation_not_stated, Profile),
    findall(Result, ict_risk_response_and_recovery_duties_complete(Profile, Result, _), Results),
    Results == [indeterminate([business_continuity_or_response_and_recovery_plans_activated])].
test(an_unbound_key_is_named_as_that_same_variable) :-
    dora_ict_risk_response_and_recovery_profile_for(variable_key_profile, Profile),
    last(Profile, attribute(Variable, _)),
    dora_ict_risk_response_and_recovery_input_problems(Profile, [unknown_key(Key)]),
    Key == Variable.
test(a_term_that_is_not_an_attribute_list_reads_out_one_problem) :-
    dora_ict_risk_response_and_recovery_profile_for(not_an_attribute_list_profile, Profile),
    findall(Problems, dora_ict_risk_response_and_recovery_input_problems(Profile, Problems), Answers),
    Answers == [[wrong_type(profile)]].
test(a_duplicate_key_reads_out_once) :-
    dora_ict_risk_response_and_recovery_profile_for(duplicate_key_profile, Profile),
    dora_ict_risk_response_and_recovery_input_problems(Profile, Problems),
    Problems == [duplicate_key(has_ict_business_continuity_policy)].
test(a_numeric_entity_type_reads_out_a_wrong_type) :-
    dora_ict_risk_response_and_recovery_profile_for(numeric_entity_type_profile, Profile),
    dora_ict_risk_response_and_recovery_input_problems(Profile, Problems),
    Problems == [wrong_type(dora_entity_type)].
test(the_checklist_reads_out_a_cited_row_per_duty) :-
    dora_ict_risk_response_and_recovery_profile_for(large_credit_institution_all_performed, Profile),
    dora_ict_risk_response_and_recovery_checklist(Profile, Items),
    length(Items, 37),
    Items = [item(ict_business_continuity_policy, met, cite(eu_reg_2022_2554_art_11_1))|_].

cp_test_names([the_baseline_profile_yields_exactly_one_status, the_verdict_carries_the_seventeen_citations, a_central_securities_depository_reads_out_twenty_nine_duties, a_large_credit_institution_reads_out_no_secondary_site, the_referral_reads_out_its_key_citation_and_pairs, the_outstanding_list_reads_out, the_size_is_named_when_one_redundancy_duty_fails, the_size_split_reads_out_incomplete, an_applying_duty_is_named_before_a_trigger_behind_it, the_outstanding_query_names_the_trigger_first, the_trigger_is_named_once_every_applying_duty_is_known, an_unbound_key_is_named_as_that_same_variable, a_term_that_is_not_an_attribute_list_reads_out_one_problem, a_duplicate_key_reads_out_once, a_numeric_entity_type_reads_out_a_wrong_type, the_checklist_reads_out_a_cited_row_per_duty]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
