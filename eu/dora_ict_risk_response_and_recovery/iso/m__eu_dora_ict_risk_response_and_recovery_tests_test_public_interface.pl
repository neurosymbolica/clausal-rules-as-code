% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_ict_risk_response_and_recovery_tests_test_public_interface, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(library(reif), [tfilter/3]).
:- use_module(clausal_lists_extra, [last/2]).
:- use_module(m__eu_dora_ict_risk_response_and_recovery_dora_ict_risk_response_and_recovery, [ict_risk_response_and_recovery_duties_required/3, ict_risk_response_and_recovery_duties_complete/3, ict_risk_response_and_recovery_duties_outstanding/3, decide_dora_ict_risk_response_and_recovery/2, dora_ict_risk_response_and_recovery_status/2, dora_ict_risk_response_and_recovery_checklist/2, dora_ict_risk_response_and_recovery_decision_resolvable/1, dora_ict_risk_response_and_recovery_status_values/1]).
:- use_module(m__eu_dora_ict_risk_response_and_recovery_kernel, [dora_ict_risk_response_and_recovery_input_problems/2]).
:- use_module(m__eu_dora_ict_risk_response_and_recovery_fixtures, [dora_ict_risk_response_and_recovery_subject/1, dora_ict_risk_response_and_recovery_profile_for/2, dora_ict_risk_response_and_recovery_assess/2]).
:- use_module(m__eu_dora_ict_risk_response_and_recovery_queries, [dora_ict_risk_response_and_recovery_what_if/4, dora_ict_risk_response_and_recovery_profile_keys/1]).

verdict_of(Subject, Status) :-
    dora_ict_risk_response_and_recovery_assess(Subject, dora_ict_risk_response_and_recovery_verdict(Status, _Citations)).

profile_of(Subject, Profile) :-
    dora_ict_risk_response_and_recovery_profile_for(Subject, Profile).

answers_once(Subject) :-
    profile_of(Subject, Profile),
    findall(Result - Citations, ict_risk_response_and_recovery_duties_required(Profile, Result, Citations), RequiredAnswers),
    length(RequiredAnswers, 1),
    findall(Result - Citations, ict_risk_response_and_recovery_duties_complete(Profile, Result, Citations), CompleteAnswers),
    length(CompleteAnswers, 1),
    findall(Result - Citations, ict_risk_response_and_recovery_duties_outstanding(Profile, Result, Citations), OutstandingAnswers),
    length(OutstandingAnswers, 1),
    findall(Problems, dora_ict_risk_response_and_recovery_input_problems(Profile, Problems), ProblemAnswers),
    length(ProblemAnswers, 1).

item_carries_citation(item(Duty, _, cite(Key))) :-
    atom(Duty),
    atom(Key).

same_set(Left, Right) :-
    sort(Left, Sorted),
    sort(Right, Sorted).

fixed_citations([cite(eu_reg_2022_2554_art_11_1), cite(eu_reg_2022_2554_art_11_2), cite(eu_reg_2022_2554_art_11_3), cite(eu_reg_2022_2554_art_11_4), cite(eu_reg_2022_2554_art_11_5), cite(eu_reg_2022_2554_art_11_6), cite(eu_reg_2022_2554_art_11_7), cite(eu_reg_2022_2554_art_11_8), cite(eu_reg_2022_2554_art_11_9), cite(eu_reg_2022_2554_art_11_10), cite(eu_reg_2022_2554_art_12_1), cite(eu_reg_2022_2554_art_12_2), cite(eu_reg_2022_2554_art_12_3), cite(eu_reg_2022_2554_art_12_4), cite(eu_reg_2022_2554_art_12_5), cite(eu_reg_2022_2554_art_12_6), cite(eu_reg_2022_2554_art_12_7)]).

provenance_item_t(Item, true) :-
    Item = provenance(_, _).
provenance_item_t(Item, false) :-
    Item \= provenance(_, _).

test(every_subject_answers_exactly_once_in_every_query) :-
    findall(Subject, dora_ict_risk_response_and_recovery_subject(Subject), Subjects),
    length(Subjects, Count),
    Count >= 20,
    maplist(answers_once, Subjects).
test(the_schema_has_forty_five_keys) :-
    dora_ict_risk_response_and_recovery_profile_keys(Keys),
    length(Keys, 45).
test(large_credit_institution_all_performed_is_complete) :-
    verdict_of(large_credit_institution_all_performed, Status),
    Status == complete.
test(large_credit_institution_all_performed_cites_the_fixed_paragraphs) :-
    profile_of(large_credit_institution_all_performed, Profile),
    ict_risk_response_and_recovery_duties_complete(Profile, complete, Citations),
    fixed_citations(Fixed),
    same_set(Citations, Fixed).
test(large_credit_institution_all_performed_has_none_outstanding) :-
    profile_of(large_credit_institution_all_performed, Profile),
    ict_risk_response_and_recovery_duties_outstanding(Profile, none_outstanding, Citations),
    fixed_citations(Fixed),
    same_set(Citations, Fixed).
test(large_credit_institution_has_twenty_four_duties) :-
    profile_of(large_credit_institution_all_performed, Profile),
    ict_risk_response_and_recovery_duties_required(Profile, required(Duties), Citations),
    length(Duties, 24),
    Duties = [ict_business_continuity_policy|_],
    last(Duties, recovery_time_and_recovery_point_objectives),
    same_set(Citations, [cite(eu_reg_2022_2554_art_11_1), cite(eu_reg_2022_2554_art_11_2), cite(eu_reg_2022_2554_art_11_3), cite(eu_reg_2022_2554_art_11_4), cite(eu_reg_2022_2554_art_11_5), cite(eu_reg_2022_2554_art_11_6), cite(eu_reg_2022_2554_art_11_7), cite(eu_reg_2022_2554_art_12_1), cite(eu_reg_2022_2554_art_12_2), cite(eu_reg_2022_2554_art_12_4), cite(eu_reg_2022_2554_art_12_6)]).
test(large_credit_institution_policy_not_performed_is_incomplete) :-
    verdict_of(large_credit_institution_policy_not_performed, Status),
    Status == incomplete.
test(large_credit_institution_policy_not_performed_is_outstanding) :-
    profile_of(large_credit_institution_policy_not_performed, Profile),
    ict_risk_response_and_recovery_duties_outstanding(Profile, outstanding([ict_business_continuity_policy]), [cite(eu_reg_2022_2554_art_11_1)]).
test(article_16_1_entity_is_simplified_framework_entity) :-
    verdict_of(article_16_1_entity, Status),
    Status == simplified_framework_entity.
test(article_16_1_entity_in_every_query) :-
    profile_of(article_16_1_entity, Profile),
    ict_risk_response_and_recovery_duties_required(Profile, simplified_framework_entity, [cite(eu_reg_2022_2554_art_16_1)]),
    ict_risk_response_and_recovery_duties_outstanding(Profile, simplified_framework_entity, [cite(eu_reg_2022_2554_art_16_1)]).
test(article_16_1_status_not_stated_is_asked_first) :-
    verdict_of(article_16_1_status_not_stated, Status),
    Status == indeterminate([financial_entity_is_article_16_1_entity]).
test(article_16_1_status_not_stated_has_no_citations) :-
    profile_of(article_16_1_status_not_stated, Profile),
    ict_risk_response_and_recovery_duties_required(Profile, indeterminate([financial_entity_is_article_16_1_entity]), []).
test(microenterprise_all_performed_is_complete) :-
    verdict_of(microenterprise_all_performed, Status),
    Status == complete.
test(microenterprise_has_twenty_one_duties) :-
    profile_of(microenterprise_all_performed, Profile),
    ict_risk_response_and_recovery_duties_required(Profile, required(Duties), _),
    length(Duties, 21),
    memberchk(assessment_of_need_for_redundant_ict_capacities, Duties).
test(microenterprise_need_for_redundancy_not_assessed_is_incomplete) :-
    verdict_of(microenterprise_need_for_redundancy_not_assessed, Status),
    Status == incomplete.
test(microenterprise_need_for_redundancy_not_assessed_is_outstanding) :-
    profile_of(microenterprise_need_for_redundancy_not_assessed, Profile),
    ict_risk_response_and_recovery_duties_outstanding(Profile, outstanding([assessment_of_need_for_redundant_ict_capacities]), [cite(eu_reg_2022_2554_art_12_4)]).
test(microenterprise_without_audit_review_is_complete) :-
    verdict_of(microenterprise_without_audit_review, Status),
    Status == complete.
test(large_credit_institution_without_audit_review_is_incomplete) :-
    verdict_of(large_credit_institution_without_audit_review, Status),
    Status == incomplete.
test(large_credit_institution_without_audit_review_is_outstanding) :-
    profile_of(large_credit_institution_without_audit_review, Profile),
    ict_risk_response_and_recovery_duties_outstanding(Profile, outstanding([independent_internal_audit_review_of_response_and_recovery_plans]), [cite(eu_reg_2022_2554_art_11_3)]).
test(central_securities_depository_all_performed_is_complete) :-
    verdict_of(central_securities_depository_all_performed, Status),
    Status == complete.
test(central_securities_depository_has_twenty_nine_duties) :-
    profile_of(central_securities_depository_all_performed, Profile),
    ict_risk_response_and_recovery_duties_required(Profile, required(Duties), _),
    length(Duties, 29),
    memberchk(secondary_site_immediately_accessible, Duties).
test(central_securities_depository_without_secondary_site_is_incomplete) :-
    verdict_of(central_securities_depository_without_secondary_site, Status),
    Status == incomplete.
test(central_securities_depository_without_secondary_site_is_outstanding) :-
    profile_of(central_securities_depository_without_secondary_site, Profile),
    ict_risk_response_and_recovery_duties_outstanding(Profile, outstanding([secondary_processing_site]), [cite(eu_reg_2022_2554_art_12_5)]).
test(credit_institution_without_secondary_site_is_complete) :-
    verdict_of(credit_institution_without_secondary_site, Status),
    Status == complete.
test(central_counterparty_recovery_unsure_is_referred) :-
    verdict_of(central_counterparty_recovery_unsure, Status),
    Status = needs_legal_review(open_textured(recovery_plans_enable_recovery_of_all_transactions, cite(eu_reg_2022_2554_art_12_3)), [inputs_relied_on(Pairs)]),
    length(Pairs, 45),
    Pairs = [financial_entity_is_article_16_1_entity - false|_],
    memberchk(recovery_plans_enable_recovery_of_all_transactions - unsure, Pairs).
test(central_counterparty_recovery_unsure_is_referred_in_outstanding) :-
    profile_of(central_counterparty_recovery_unsure, Profile),
    ict_risk_response_and_recovery_duties_outstanding(Profile, needs_legal_review(open_textured(recovery_plans_enable_recovery_of_all_transactions, cite(eu_reg_2022_2554_art_12_3)), [inputs_relied_on(_)]), []).
test(central_counterparty_recovery_performed_is_complete) :-
    verdict_of(central_counterparty_recovery_performed, Status),
    Status == complete.
test(central_counterparty_has_twenty_five_duties) :-
    profile_of(central_counterparty_recovery_performed, Profile),
    ict_risk_response_and_recovery_duties_required(Profile, required(Duties), _),
    length(Duties, 25),
    memberchk(recovery_of_all_transactions, Duties).
test(the_referral_context_carries_no_provenance_item) :-
    verdict_of(central_counterparty_recovery_unsure, needs_legal_review(_, Context)),
    Context = [inputs_relied_on(_)],
    tfilter(provenance_item_t, Context, ProvenanceItems),
    ProvenanceItems == [].
test(a_provenance_item_is_recognised_in_a_context) :-
    Context = [inputs_relied_on([]), provenance(referral, [cite(eu_reg_2022_2554_art_12_3)])],
    tfilter(provenance_item_t, Context, ProvenanceItems),
    ProvenanceItems == [provenance(referral, [cite(eu_reg_2022_2554_art_12_3)])].
test(size_not_stated_both_redundancy_duties_failing_is_incomplete) :-
    verdict_of(size_not_stated_both_redundancy_duties_failing, Status),
    Status == incomplete.
test(size_not_stated_one_redundancy_duty_failing_asks_the_size) :-
    verdict_of(size_not_stated_one_redundancy_duty_failing, Status),
    Status == indeterminate([financial_entity_is_microenterprise]).
test(plans_activated_records_not_kept_is_incomplete) :-
    verdict_of(plans_activated_records_not_kept, Status),
    Status == incomplete.
test(plans_activated_records_not_kept_is_outstanding) :-
    profile_of(plans_activated_records_not_kept, Profile),
    ict_risk_response_and_recovery_duties_outstanding(Profile, outstanding([records_of_activities_during_disruption_events]), [cite(eu_reg_2022_2554_art_11_8)]).
test(plans_not_activated_records_not_kept_is_complete) :-
    verdict_of(plans_not_activated_records_not_kept, Status),
    Status == complete.
test(policy_and_activation_not_stated_asks_the_applying_duty_first) :-
    verdict_of(policy_and_activation_not_stated, Status),
    Status == indeterminate([has_ict_business_continuity_policy]).
test(activation_not_stated_asks_the_trigger) :-
    verdict_of(activation_not_stated, Status),
    Status == indeterminate([business_continuity_or_response_and_recovery_plans_activated]).
test(microenterprise_cost_request_not_stated_is_not_asked) :-
    profile_of(microenterprise_cost_request_not_stated, Profile),
    ict_risk_response_and_recovery_duties_required(Profile, required(Duties), _),
    length(Duties, 21).
test(microenterprise_cost_request_not_stated_is_complete) :-
    verdict_of(microenterprise_cost_request_not_stated, Status),
    Status == complete.
test(large_entity_cost_request_not_stated_is_asked) :-
    profile_of(large_entity_cost_request_not_stated, Profile),
    ict_risk_response_and_recovery_duties_required(Profile, indeterminate([authority_requested_estimate_of_annual_ict_incident_costs_and_losses]), []).
test(large_entity_cost_request_not_stated_is_complete) :-
    verdict_of(large_entity_cost_request_not_stated, Status),
    Status == complete.
test(duplicate_key_profile_is_refused) :-
    verdict_of(duplicate_key_profile, Status),
    Status == input_problems([duplicate_key(has_ict_business_continuity_policy)]).
test(unsure_gate_profile_is_refused) :-
    verdict_of(unsure_gate_profile, Status),
    Status == input_problems([wrong_type(financial_entity_is_article_16_1_entity)]).
test(numeric_entity_type_profile_is_refused) :-
    verdict_of(numeric_entity_type_profile, Status),
    Status == input_problems([wrong_type(dora_entity_type)]).
test(unknown_key_profile_is_refused) :-
    profile_of(unknown_key_profile, Profile),
    dora_ict_risk_response_and_recovery_input_problems(Profile, [unknown_key(no_such_key)]),
    ict_risk_response_and_recovery_duties_required(Profile, input_problems([unknown_key(no_such_key)]), []).
test(variable_key_profile_names_the_variable) :-
    profile_of(variable_key_profile, Profile),
    ict_risk_response_and_recovery_duties_outstanding(Profile, input_problems([unknown_key(Key)]), []),
    var(Key).
test(not_an_attribute_list_profile_is_refused) :-
    verdict_of(not_an_attribute_list_profile, Status),
    Status == input_problems([wrong_type(profile)]).
test(the_baseline_has_no_input_problem) :-
    profile_of(large_credit_institution_all_performed, Profile),
    dora_ict_risk_response_and_recovery_input_problems(Profile, []).
test(final_verdicts_are_in_the_status_vocabulary) :-
    dora_ict_risk_response_and_recovery_status_values(StatusValues),
    verdict_of(large_credit_institution_all_performed, Complete),
    memberchk(Complete, StatusValues),
    verdict_of(large_credit_institution_policy_not_performed, Incomplete),
    memberchk(Incomplete, StatusValues),
    verdict_of(article_16_1_entity, Simplified),
    memberchk(Simplified, StatusValues).
test(status_projects_the_verdict) :-
    profile_of(large_credit_institution_policy_not_performed, Profile),
    dora_ict_risk_response_and_recovery_status(Profile, incomplete),
    dora_ict_risk_response_and_recovery_decision_resolvable(Profile).
test(the_checklist_cites_every_duty) :-
    profile_of(large_credit_institution_all_performed, Profile),
    dora_ict_risk_response_and_recovery_checklist(Profile, Items),
    length(Items, 37),
    maplist(item_carries_citation, Items),
    findall(Duty, member(item(Duty, met, _), Items), Met),
    length(Met, 24).
test(the_checklist_marks_the_unperformed_duty) :-
    profile_of(large_credit_institution_policy_not_performed, Profile),
    dora_ict_risk_response_and_recovery_checklist(Profile, [item(ict_business_continuity_policy, unmet(_), cite(eu_reg_2022_2554_art_11_1))|_]).
test(the_checklist_of_an_article_16_1_entity_is_inapplicable) :-
    profile_of(article_16_1_entity, Profile),
    dora_ict_risk_response_and_recovery_checklist(Profile, Items),
    findall(Status, member(item(_, Status, _), Items), Statuses),
    sort(Statuses, [inapplicable]).
test(a_good_profile_has_a_checklist) :-
    profile_of(microenterprise_all_performed, Profile),
    dora_ict_risk_response_and_recovery_checklist(Profile, [_|_]).
test(what_if_the_policy_is_not_performed) :-
    profile_of(large_credit_institution_all_performed, Profile),
    dora_ict_risk_response_and_recovery_what_if(Profile, has_ict_business_continuity_policy, false, incomplete).
test(what_if_the_policy_is_performed) :-
    profile_of(large_credit_institution_policy_not_performed, Profile),
    dora_ict_risk_response_and_recovery_what_if(Profile, has_ict_business_continuity_policy, true, complete).
test(what_if_the_entity_is_an_article_16_1_entity) :-
    profile_of(large_credit_institution_all_performed, Profile),
    dora_ict_risk_response_and_recovery_what_if(Profile, financial_entity_is_article_16_1_entity, true, simplified_framework_entity).
test(what_if_the_gate_is_stated) :-
    profile_of(article_16_1_status_not_stated, Profile),
    dora_ict_risk_response_and_recovery_what_if(Profile, financial_entity_is_article_16_1_entity, false, complete).

test(large_credit_institution_policy_not_performed_is_not_complete, fail) :-
    verdict_of(large_credit_institution_policy_not_performed, complete).
test(article_16_1_entity_is_not_complete, fail) :-
    verdict_of(article_16_1_entity, complete).
test(large_credit_institution_without_audit_review_is_not_complete, fail) :-
    verdict_of(large_credit_institution_without_audit_review, complete).
test(credit_institution_without_secondary_site_is_not_incomplete, fail) :-
    verdict_of(credit_institution_without_secondary_site, incomplete).
test(the_referral_context_is_not_followed_by_provenance, fail) :-
    verdict_of(central_counterparty_recovery_unsure, needs_legal_review(_, [_, provenance(_, _)])).
test(size_not_stated_one_redundancy_duty_failing_is_not_incomplete, fail) :-
    verdict_of(size_not_stated_one_redundancy_duty_failing, incomplete).
test(plans_not_activated_records_not_kept_is_not_incomplete, fail) :-
    verdict_of(plans_not_activated_records_not_kept, incomplete).
test(a_refused_profile_has_no_checklist, fail) :-
    profile_of(duplicate_key_profile, Profile),
    dora_ict_risk_response_and_recovery_checklist(Profile, _).
test(what_if_the_gate_is_stated_is_not_indeterminate, fail) :-
    profile_of(article_16_1_status_not_stated, Profile),
    dora_ict_risk_response_and_recovery_what_if(Profile, financial_entity_is_article_16_1_entity, false, indeterminate(_)).

cp_test_names([every_subject_answers_exactly_once_in_every_query, the_schema_has_forty_five_keys, large_credit_institution_all_performed_is_complete, large_credit_institution_all_performed_cites_the_fixed_paragraphs, large_credit_institution_all_performed_has_none_outstanding, large_credit_institution_has_twenty_four_duties, large_credit_institution_policy_not_performed_is_incomplete, large_credit_institution_policy_not_performed_is_outstanding, article_16_1_entity_is_simplified_framework_entity, article_16_1_entity_in_every_query, article_16_1_status_not_stated_is_asked_first, article_16_1_status_not_stated_has_no_citations, microenterprise_all_performed_is_complete, microenterprise_has_twenty_one_duties, microenterprise_need_for_redundancy_not_assessed_is_incomplete, microenterprise_need_for_redundancy_not_assessed_is_outstanding, microenterprise_without_audit_review_is_complete, large_credit_institution_without_audit_review_is_incomplete, large_credit_institution_without_audit_review_is_outstanding, central_securities_depository_all_performed_is_complete, central_securities_depository_has_twenty_nine_duties, central_securities_depository_without_secondary_site_is_incomplete, central_securities_depository_without_secondary_site_is_outstanding, credit_institution_without_secondary_site_is_complete, central_counterparty_recovery_unsure_is_referred, central_counterparty_recovery_unsure_is_referred_in_outstanding, central_counterparty_recovery_performed_is_complete, central_counterparty_has_twenty_five_duties, the_referral_context_carries_no_provenance_item, a_provenance_item_is_recognised_in_a_context, size_not_stated_both_redundancy_duties_failing_is_incomplete, size_not_stated_one_redundancy_duty_failing_asks_the_size, plans_activated_records_not_kept_is_incomplete, plans_activated_records_not_kept_is_outstanding, plans_not_activated_records_not_kept_is_complete, policy_and_activation_not_stated_asks_the_applying_duty_first, activation_not_stated_asks_the_trigger, microenterprise_cost_request_not_stated_is_not_asked, microenterprise_cost_request_not_stated_is_complete, large_entity_cost_request_not_stated_is_asked, large_entity_cost_request_not_stated_is_complete, duplicate_key_profile_is_refused, unsure_gate_profile_is_refused, numeric_entity_type_profile_is_refused, unknown_key_profile_is_refused, variable_key_profile_names_the_variable, not_an_attribute_list_profile_is_refused, the_baseline_has_no_input_problem, final_verdicts_are_in_the_status_vocabulary, status_projects_the_verdict, the_checklist_cites_every_duty, the_checklist_marks_the_unperformed_duty, the_checklist_of_an_article_16_1_entity_is_inapplicable, a_good_profile_has_a_checklist, what_if_the_policy_is_not_performed, what_if_the_policy_is_performed, what_if_the_entity_is_an_article_16_1_entity, what_if_the_gate_is_stated]).
cp_test_fail_names([large_credit_institution_policy_not_performed_is_not_complete, article_16_1_entity_is_not_complete, large_credit_institution_without_audit_review_is_not_complete, credit_institution_without_secondary_site_is_not_incomplete, the_referral_context_is_not_followed_by_provenance, size_not_stated_one_redundancy_duty_failing_is_not_incomplete, plans_not_activated_records_not_kept_is_not_incomplete, a_refused_profile_has_no_checklist, what_if_the_gate_is_stated_is_not_indeterminate]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
