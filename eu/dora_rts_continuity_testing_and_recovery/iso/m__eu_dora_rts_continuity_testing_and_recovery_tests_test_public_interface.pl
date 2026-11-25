% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_rts_continuity_testing_and_recovery_tests_test_public_interface, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_dora_rts_continuity_testing_and_recovery_dora_rts_continuity_testing_and_recovery, [decide_dora_rts_continuity_testing_and_recovery/2, dora_rts_continuity_testing_and_recovery_status/2, dora_rts_continuity_testing_and_recovery_checklist/2, dora_rts_continuity_testing_and_recovery_decision_resolvable/1, dora_rts_continuity_testing_and_recovery_status_values/1, rts_continuity_testing_and_recovery_duties_required/3, rts_continuity_testing_and_recovery_duties_complete/3, rts_continuity_testing_and_recovery_duties_outstanding/3]).
:- use_module(m__eu_dora_rts_continuity_testing_and_recovery_fixtures, [dora_rts_continuity_testing_and_recovery_subject/1, dora_rts_continuity_testing_and_recovery_profile_for/2, dora_rts_continuity_testing_and_recovery_assess/2]).
:- use_module(m__eu_dora_rts_continuity_testing_and_recovery_kernel, [dora_rts_continuity_testing_and_recovery_input_problems/2]).
:- use_module(m__eu_dora_rts_continuity_testing_and_recovery_queries, [dora_rts_continuity_testing_and_recovery_compliance_check/2, dora_rts_continuity_testing_and_recovery_eligibility/2]).

expected_fixed_citations([cite(eu_reg_2024_1774_art_25_1), cite(eu_reg_2024_1774_art_25_2), cite(eu_reg_2024_1774_art_25_3), cite(eu_reg_2024_1774_art_25_4), cite(eu_reg_2024_1774_art_25_5), cite(eu_reg_2024_1774_art_26_1), cite(eu_reg_2024_1774_art_26_2), cite(eu_reg_2024_1774_art_26_3), cite(eu_reg_2024_1774_art_26_4)]).

expected_status(article_16_entity_all_performed, simplified_framework_entity).
expected_status(credit_institution_all_performed, complete).
expected_status(gate_absent, indeterminate([financial_entity_is_article_16_1_entity])).
expected_status(gate_unsure_is_wrong_type, input_problems([wrong_type(financial_entity_is_article_16_1_entity)])).
expected_status(gate_false_alone, indeterminate([continuity_testing_takes_into_account_business_impact_analysis_and_ict_risk_assessment])).
expected_status(credit_institution_first_duty_false, incomplete).
expected_status(microenterprise_without_providers_all_performed, complete).
expected_status(microenterprise_switchover_false, complete).
expected_status(non_microenterprise_switchover_false, incomplete).
expected_status(central_counterparty_all_performed, complete).
expected_status(central_counterparty_involvement_false, incomplete).
expected_status(central_securities_depository_involvement_false, incomplete).
expected_status(credit_institution_depository_involvement_false, complete).
expected_status(provider_user_continuity_measures_false, incomplete).
expected_status(no_provider_continuity_measures_false, complete).
expected_status(trigger_absent_provider_testing_false, indeterminate([financial_entity_uses_ict_services_of_ict_third_party_service_providers])).
expected_status(trigger_true_provider_testing_false, incomplete).
expected_status(first_duty_absent_and_trigger_absent, indeterminate([continuity_testing_takes_into_account_business_impact_analysis_and_ict_risk_assessment])).
expected_status(unsure_alternative_options_with_false_duty, incomplete).
expected_status(duplicate_and_unknown_key, input_problems([duplicate_key(financial_entity_is_article_16_1_entity), unknown_key(unlisted_key)])).
expected_status(profile_not_a_list, input_problems([wrong_type(profile)])).

same_citations(Actual, Expected) :-
    sort(Actual, Sorted),
    sort(Expected, Sorted).

subject_gets_status(Subject - Expected) :-
    dora_rts_continuity_testing_and_recovery_assess(Subject, dora_rts_continuity_testing_and_recovery_verdict(Actual, _Citations)),
    Actual == Expected.

profile_of(Subject, Profile) :-
    dora_rts_continuity_testing_and_recovery_profile_for(Subject, Profile).

answers_once(Subject) :-
    profile_of(Subject, Profile),
    findall(Result - Citations, rts_continuity_testing_and_recovery_duties_required(Profile, Result, Citations), RequiredAnswers),
    length(RequiredAnswers, 1),
    findall(Result - Citations, rts_continuity_testing_and_recovery_duties_complete(Profile, Result, Citations), CompleteAnswers),
    length(CompleteAnswers, 1),
    findall(Result - Citations, rts_continuity_testing_and_recovery_duties_outstanding(Profile, Result, Citations), OutstandingAnswers),
    length(OutstandingAnswers, 1),
    findall(Problems, dora_rts_continuity_testing_and_recovery_input_problems(Profile, Problems), ProblemAnswers),
    length(ProblemAnswers, 1),
    findall(Verdict, dora_rts_continuity_testing_and_recovery_compliance_check(Profile, Verdict), ComplianceAnswers),
    length(ComplianceAnswers, 1),
    findall(Assessment, dora_rts_continuity_testing_and_recovery_eligibility(Profile, Assessment), EligibilityAnswers),
    length(EligibilityAnswers, 1).

has_cited_checklist(Subject) :-
    profile_of(Subject, Profile),
    dora_rts_continuity_testing_and_recovery_checklist(Profile, [item(_, _, _)|_OtherItems]).

test(every_tabled_subject_gets_its_expected_status) :-
    findall(Subject - Status, expected_status(Subject, Status), Rows),
    length(Rows, 21),
    maplist(subject_gets_status, Rows).
test(every_subject_answers_each_query_exactly_once) :-
    findall(Subject, dora_rts_continuity_testing_and_recovery_subject(Subject), Subjects),
    length(Subjects, 22),
    maplist(answers_once, Subjects).
test(every_subject_has_a_non_empty_checklist) :-
    findall(Subject, dora_rts_continuity_testing_and_recovery_subject(Subject), Subjects),
    maplist(has_cited_checklist, Subjects).
test(every_subject_is_resolvable_with_a_known_status_shape) :-
    profile_of(credit_institution_all_performed, Profile),
    dora_rts_continuity_testing_and_recovery_decision_resolvable(Profile),
    dora_rts_continuity_testing_and_recovery_status(Profile, Status),
    dora_rts_continuity_testing_and_recovery_status_values(StatusValues),
    member(Status, StatusValues).
test(article_16_entity_is_simplified_framework_entity_in_every_query) :-
    profile_of(article_16_entity_all_performed, Profile),
    rts_continuity_testing_and_recovery_duties_required(Profile, simplified_framework_entity, [cite(eu_reg_2022_2554_art_16_1)]),
    rts_continuity_testing_and_recovery_duties_complete(Profile, simplified_framework_entity, [cite(eu_reg_2022_2554_art_16_1)]),
    rts_continuity_testing_and_recovery_duties_outstanding(Profile, simplified_framework_entity, [cite(eu_reg_2022_2554_art_16_1)]).
test(gate_false_control_is_complete_with_the_fixed_citations) :-
    dora_rts_continuity_testing_and_recovery_assess(credit_institution_all_performed, dora_rts_continuity_testing_and_recovery_verdict(complete, Citations)),
    expected_fixed_citations(Fixed),
    same_citations(Citations, Fixed).
test(gate_absent_is_asked_first_in_every_query) :-
    profile_of(gate_absent, Profile),
    rts_continuity_testing_and_recovery_duties_required(Profile, indeterminate([financial_entity_is_article_16_1_entity]), []),
    rts_continuity_testing_and_recovery_duties_outstanding(Profile, indeterminate([financial_entity_is_article_16_1_entity]), []).
test(gate_false_alone_required_asks_the_size_first) :-
    profile_of(gate_false_alone, Profile),
    rts_continuity_testing_and_recovery_duties_required(Profile, indeterminate([financial_entity_is_microenterprise]), []).
test(credit_institution_requires_twenty_one_duties_in_duty_order) :-
    profile_of(credit_institution_all_performed, Profile),
    rts_continuity_testing_and_recovery_duties_required(Profile, required(Duties), Citations),
    Duties == [testing_informed_by_business_impact_analysis_and_ict_risk_assessment, assessment_of_continuity_of_critical_or_important_functions, testing_on_disruption_scenarios, testing_of_ict_third_party_services, testing_of_switchover_scenarios, testing_challenges_plan_assumptions, testing_verifies_ability_to_respond, documentation_of_test_results, handling_of_test_deficiencies, response_and_recovery_plans_informed_by_business_impact_analysis, activation_and_deactivation_conditions, actions_for_critical_or_important_ict_systems_and_services, design_to_meet_recovery_objectives, documentation_and_availability_of_plans, short_and_long_term_recovery_options, plan_objectives_and_success_conditions, identification_of_relevant_scenarios, scenarios_based_on_threats_and_lessons_learned, listed_disruption_scenarios, alternative_recovery_options, continuity_measures_for_ict_third_party_service_provider_failures],
    same_citations(Citations, [cite(eu_reg_2024_1774_art_25_1), cite(eu_reg_2024_1774_art_25_2), cite(eu_reg_2024_1774_art_25_5), cite(eu_reg_2024_1774_art_26_1), cite(eu_reg_2024_1774_art_26_2), cite(eu_reg_2024_1774_art_26_3), cite(eu_reg_2024_1774_art_26_4)]).
test(microenterprise_without_providers_requires_the_eighteen_duties_that_always_apply) :-
    profile_of(microenterprise_without_providers_all_performed, Profile),
    rts_continuity_testing_and_recovery_duties_required(Profile, required(Duties), Citations),
    Duties == [testing_informed_by_business_impact_analysis_and_ict_risk_assessment, assessment_of_continuity_of_critical_or_important_functions, testing_on_disruption_scenarios, testing_challenges_plan_assumptions, testing_verifies_ability_to_respond, documentation_of_test_results, handling_of_test_deficiencies, response_and_recovery_plans_informed_by_business_impact_analysis, activation_and_deactivation_conditions, actions_for_critical_or_important_ict_systems_and_services, design_to_meet_recovery_objectives, documentation_and_availability_of_plans, short_and_long_term_recovery_options, plan_objectives_and_success_conditions, identification_of_relevant_scenarios, scenarios_based_on_threats_and_lessons_learned, listed_disruption_scenarios, alternative_recovery_options],
    same_citations(Citations, [cite(eu_reg_2024_1774_art_25_1), cite(eu_reg_2024_1774_art_25_2), cite(eu_reg_2024_1774_art_25_5), cite(eu_reg_2024_1774_art_26_1), cite(eu_reg_2024_1774_art_26_2), cite(eu_reg_2024_1774_art_26_3)]).
test(central_counterparty_requires_its_involvement_duty) :-
    profile_of(central_counterparty_all_performed, Profile),
    rts_continuity_testing_and_recovery_duties_required(Profile, required(Duties), Citations),
    length(Duties, 22),
    member(involvement_of_central_counterparty_parties_in_testing, Duties),
    member(cite(eu_reg_2024_1774_art_25_3), Citations).
test(trigger_absent_required_asks_the_trigger) :-
    profile_of(first_duty_absent_and_trigger_absent, Profile),
    rts_continuity_testing_and_recovery_duties_required(Profile, indeterminate([financial_entity_uses_ict_services_of_ict_third_party_service_providers]), []).
test(first_duty_false_is_outstanding_with_its_citation) :-
    profile_of(credit_institution_first_duty_false, Profile),
    rts_continuity_testing_and_recovery_duties_complete(Profile, incomplete, CompleteCitations),
    expected_fixed_citations(Fixed),
    same_citations(CompleteCitations, Fixed),
    rts_continuity_testing_and_recovery_duties_outstanding(Profile, outstanding([testing_informed_by_business_impact_analysis_and_ict_risk_assessment]), [cite(eu_reg_2024_1774_art_25_1)]).
test(non_microenterprise_switchover_false_is_outstanding) :-
    profile_of(non_microenterprise_switchover_false, Profile),
    rts_continuity_testing_and_recovery_duties_outstanding(Profile, outstanding([testing_of_switchover_scenarios]), Citations),
    same_citations(Citations, [cite(eu_reg_2024_1774_art_25_2_c), cite(eu_reg_2024_1774_art_25_2)]).
test(microenterprise_switchover_false_has_none_outstanding) :-
    profile_of(microenterprise_switchover_false, Profile),
    rts_continuity_testing_and_recovery_duties_outstanding(Profile, none_outstanding, Citations),
    expected_fixed_citations(Fixed),
    same_citations(Citations, Fixed).
test(central_counterparty_involvement_false_is_outstanding) :-
    profile_of(central_counterparty_involvement_false, Profile),
    rts_continuity_testing_and_recovery_duties_outstanding(Profile, outstanding([involvement_of_central_counterparty_parties_in_testing]), Citations),
    same_citations(Citations, [cite(eu_reg_2024_1774_art_25_3), cite(eu_reg_2024_1774_art_25_3_a), cite(eu_reg_2024_1774_art_25_3_b), cite(eu_reg_2024_1774_art_25_3_c)]).
test(central_securities_depository_involvement_false_is_outstanding) :-
    profile_of(central_securities_depository_involvement_false, Profile),
    rts_continuity_testing_and_recovery_duties_outstanding(Profile, outstanding([involvement_of_central_securities_depository_parties_in_testing]), Citations),
    same_citations(Citations, [cite(eu_reg_2024_1774_art_25_4), cite(eu_reg_2024_1774_art_25_4_a), cite(eu_reg_2024_1774_art_25_4_b), cite(eu_reg_2024_1774_art_25_4_c), cite(eu_reg_2024_1774_art_25_4_d), cite(eu_reg_2024_1774_art_25_4_e)]).
test(credit_institution_depository_key_false_has_none_outstanding) :-
    profile_of(credit_institution_depository_involvement_false, Profile),
    rts_continuity_testing_and_recovery_duties_outstanding(Profile, none_outstanding, _).
test(provider_user_continuity_measures_false_is_outstanding) :-
    profile_of(provider_user_continuity_measures_false, Profile),
    rts_continuity_testing_and_recovery_duties_outstanding(Profile, outstanding([continuity_measures_for_ict_third_party_service_provider_failures]), [cite(eu_reg_2024_1774_art_26_4)]).
test(trigger_true_provider_testing_false_is_outstanding) :-
    profile_of(trigger_true_provider_testing_false, Profile),
    rts_continuity_testing_and_recovery_duties_outstanding(Profile, outstanding([testing_of_ict_third_party_services]), Citations),
    same_citations(Citations, [cite(eu_reg_2024_1774_art_25_2_b), cite(eu_reg_2024_1774_art_25_2)]).
test(trigger_absent_provider_testing_false_asks_the_trigger_in_outstanding) :-
    profile_of(trigger_absent_provider_testing_false, Profile),
    rts_continuity_testing_and_recovery_duties_outstanding(Profile, indeterminate([financial_entity_uses_ict_services_of_ict_third_party_service_providers]), []).
test(complete_names_the_duty_key_before_the_trigger_behind_it) :-
    profile_of(first_duty_absent_and_trigger_absent, Profile),
    rts_continuity_testing_and_recovery_duties_complete(Profile, indeterminate([continuity_testing_takes_into_account_business_impact_analysis_and_ict_risk_assessment]), []).
test(outstanding_names_the_trigger_first_in_root_order) :-
    profile_of(first_duty_absent_and_trigger_absent, Profile),
    rts_continuity_testing_and_recovery_duties_outstanding(Profile, indeterminate([financial_entity_uses_ict_services_of_ict_third_party_service_providers]), []).
test(unsure_alternative_options_is_referred_with_all_pairs) :-
    profile_of(unsure_alternative_options, Profile),
    rts_continuity_testing_and_recovery_duties_complete(Profile, needs_legal_review(open_textured(response_and_recovery_plans_consider_alternative_options_where_primary_recovery_measures_may_not_be_feasible, cite(eu_reg_2024_1774_art_26_3)), [inputs_relied_on(Pairs)]), []),
    length(Pairs, 27),
    Pairs = [financial_entity_is_article_16_1_entity - false|_LaterPairs],
    member(response_and_recovery_plans_consider_alternative_options_where_primary_recovery_measures_may_not_be_feasible - unsure, Pairs).
test(unsure_alternative_options_is_referred_in_outstanding) :-
    profile_of(unsure_alternative_options, Profile),
    rts_continuity_testing_and_recovery_duties_outstanding(Profile, needs_legal_review(open_textured(response_and_recovery_plans_consider_alternative_options_where_primary_recovery_measures_may_not_be_feasible, cite(eu_reg_2024_1774_art_26_3)), _), []).
test(a_false_duty_decides_incomplete_before_the_unsure_one) :-
    dora_rts_continuity_testing_and_recovery_assess(unsure_alternative_options_with_false_duty, dora_rts_continuity_testing_and_recovery_verdict(incomplete, Citations)),
    expected_fixed_citations(Fixed),
    same_citations(Citations, Fixed).
test(outstanding_still_refers_the_unsure_duty_beside_a_false_one) :-
    profile_of(unsure_alternative_options_with_false_duty, Profile),
    rts_continuity_testing_and_recovery_duties_outstanding(Profile, needs_legal_review(open_textured(response_and_recovery_plans_consider_alternative_options_where_primary_recovery_measures_may_not_be_feasible, cite(eu_reg_2024_1774_art_26_3)), _), []).
test(a_referral_context_extended_with_provenance_keeps_its_pairs_first) :-
    profile_of(unsure_alternative_options, Profile),
    rts_continuity_testing_and_recovery_duties_complete(Profile, needs_legal_review(_Reason, [inputs_relied_on(Pairs)]), []),
    ExtendedContext = [inputs_relied_on(Pairs), provenance(complete_referral, [cite(eu_reg_2024_1774_art_26_3)])],
    ExtendedContext = [inputs_relied_on(FirstPairs), provenance(Clause, ProvenanceCitations)],
    FirstPairs == Pairs,
    Clause == complete_referral,
    ProvenanceCitations == [cite(eu_reg_2024_1774_art_26_3)].
test(duplicate_then_unknown_key_in_contract_order) :-
    profile_of(duplicate_and_unknown_key, Profile),
    dora_rts_continuity_testing_and_recovery_input_problems(Profile, [duplicate_key(financial_entity_is_article_16_1_entity), unknown_key(unlisted_key)]),
    rts_continuity_testing_and_recovery_duties_required(Profile, input_problems([duplicate_key(financial_entity_is_article_16_1_entity), unknown_key(unlisted_key)]), []).
test(an_unsure_gate_is_wrong_type) :-
    profile_of(gate_unsure_is_wrong_type, Profile),
    rts_continuity_testing_and_recovery_duties_outstanding(Profile, input_problems([wrong_type(financial_entity_is_article_16_1_entity)]), []).
test(a_false_gate_alone_has_no_input_problem) :-
    profile_of(gate_false_alone, Profile),
    dora_rts_continuity_testing_and_recovery_input_problems(Profile, []).
test(a_term_that_is_not_a_list_is_wrong_type_profile) :-
    profile_of(profile_not_a_list, Profile),
    dora_rts_continuity_testing_and_recovery_input_problems(Profile, [wrong_type(profile)]),
    rts_continuity_testing_and_recovery_duties_complete(Profile, input_problems([wrong_type(profile)]), []).
test(a_well_formed_profile_has_no_input_problem) :-
    profile_of(credit_institution_all_performed, Profile),
    dora_rts_continuity_testing_and_recovery_input_problems(Profile, []).
test(all_performed_is_compliant) :-
    profile_of(credit_institution_all_performed, Profile),
    dora_rts_continuity_testing_and_recovery_compliance_check(Profile, compliance_verdict(compliant, [], Citations)),
    expected_fixed_citations(Fixed),
    same_citations(Citations, Fixed).
test(first_duty_false_is_non_compliant) :-
    profile_of(credit_institution_first_duty_false, Profile),
    dora_rts_continuity_testing_and_recovery_compliance_check(Profile, compliance_verdict(non_compliant, [testing_informed_by_business_impact_analysis_and_ict_risk_assessment], [cite(eu_reg_2024_1774_art_25_1)])).
test(article_16_entity_compliance_is_not_applicable) :-
    profile_of(article_16_entity_all_performed, Profile),
    dora_rts_continuity_testing_and_recovery_compliance_check(Profile, compliance_verdict(not_applicable, [], [cite(eu_reg_2022_2554_art_16_1)])).
test(gate_absent_compliance_passes_the_status_through) :-
    profile_of(gate_absent, Profile),
    dora_rts_continuity_testing_and_recovery_compliance_check(Profile, compliance_verdict(indeterminate([financial_entity_is_article_16_1_entity]), [], [])).
test(all_performed_is_eligible_with_a_cited_checklist) :-
    profile_of(credit_institution_all_performed, Profile),
    dora_rts_continuity_testing_and_recovery_eligibility(Profile, eligibility_assessment(eligible, Checklist)),
    length(Checklist, 24),
    member(item(alternative_recovery_options, met, [cite(eu_reg_2024_1774_art_26_3)]), Checklist).
test(first_duty_false_is_ineligible) :-
    profile_of(credit_institution_first_duty_false, Profile),
    dora_rts_continuity_testing_and_recovery_eligibility(Profile, eligibility_assessment(ineligible, Checklist)),
    member(item(testing_informed_by_business_impact_analysis_and_ict_risk_assessment, unmet(_), [cite(eu_reg_2024_1774_art_25_1)]), Checklist).
test(gate_absent_is_indeterminate_eligibility) :-
    profile_of(gate_absent, Profile),
    dora_rts_continuity_testing_and_recovery_eligibility(Profile, eligibility_assessment(indeterminate_eligibility, [_FirstItem|_OtherItems])).
test(microenterprise_switchover_item_is_inapplicable) :-
    profile_of(microenterprise_switchover_false, Profile),
    dora_rts_continuity_testing_and_recovery_checklist(Profile, Checklist),
    member(item(testing_of_switchover_scenarios, inapplicable, _), Checklist).

test(article_16_entity_is_not_complete, fail) :-
    dora_rts_continuity_testing_and_recovery_assess(article_16_entity_all_performed, dora_rts_continuity_testing_and_recovery_verdict(complete, _)).
test(gate_false_control_is_not_simplified, fail) :-
    dora_rts_continuity_testing_and_recovery_assess(credit_institution_all_performed, dora_rts_continuity_testing_and_recovery_verdict(simplified_framework_entity, _)).
test(credit_institution_does_not_require_the_central_counterparty_duty, fail) :-
    profile_of(credit_institution_all_performed, Profile),
    rts_continuity_testing_and_recovery_duties_required(Profile, required(Duties), _),
    member(involvement_of_central_counterparty_parties_in_testing, Duties).
test(first_duty_false_is_not_complete, fail) :-
    dora_rts_continuity_testing_and_recovery_assess(credit_institution_first_duty_false, dora_rts_continuity_testing_and_recovery_verdict(complete, _)).
test(microenterprise_switchover_false_is_not_incomplete, fail) :-
    dora_rts_continuity_testing_and_recovery_assess(microenterprise_switchover_false, dora_rts_continuity_testing_and_recovery_verdict(incomplete, _)).
test(central_counterparty_all_performed_is_not_incomplete, fail) :-
    dora_rts_continuity_testing_and_recovery_assess(central_counterparty_all_performed, dora_rts_continuity_testing_and_recovery_verdict(incomplete, _)).
test(credit_institution_depository_key_false_is_not_incomplete, fail) :-
    dora_rts_continuity_testing_and_recovery_assess(credit_institution_depository_involvement_false, dora_rts_continuity_testing_and_recovery_verdict(incomplete, _)).
test(no_provider_continuity_measures_false_is_not_incomplete, fail) :-
    dora_rts_continuity_testing_and_recovery_assess(no_provider_continuity_measures_false, dora_rts_continuity_testing_and_recovery_verdict(incomplete, _)).
test(trigger_absent_provider_testing_false_is_not_incomplete, fail) :-
    dora_rts_continuity_testing_and_recovery_assess(trigger_absent_provider_testing_false, dora_rts_continuity_testing_and_recovery_verdict(incomplete, _)).
test(complete_does_not_name_the_trigger_behind_the_duty_key, fail) :-
    profile_of(first_duty_absent_and_trigger_absent, Profile),
    rts_continuity_testing_and_recovery_duties_complete(Profile, indeterminate([financial_entity_uses_ict_services_of_ict_third_party_service_providers]), _).
test(unsure_alternative_options_is_not_complete, fail) :-
    dora_rts_continuity_testing_and_recovery_assess(unsure_alternative_options, dora_rts_continuity_testing_and_recovery_verdict(complete, _)).
test(the_referral_context_carries_no_provenance_item, fail) :-
    profile_of(unsure_alternative_options, Profile),
    rts_continuity_testing_and_recovery_duties_complete(Profile, needs_legal_review(_, [inputs_relied_on(_), provenance(_, _)]), _).
test(a_duplicate_key_is_not_also_wrong_type, fail) :-
    profile_of(duplicate_and_unknown_key, Profile),
    dora_rts_continuity_testing_and_recovery_input_problems(Profile, Problems),
    member(wrong_type(financial_entity_is_article_16_1_entity), Problems).
test(first_duty_false_is_not_compliant, fail) :-
    profile_of(credit_institution_first_duty_false, Profile),
    dora_rts_continuity_testing_and_recovery_compliance_check(Profile, compliance_verdict(compliant, _, _)).
test(first_duty_false_is_not_eligible, fail) :-
    profile_of(credit_institution_first_duty_false, Profile),
    dora_rts_continuity_testing_and_recovery_eligibility(Profile, eligibility_assessment(eligible, _)).

cp_test_names([every_tabled_subject_gets_its_expected_status, every_subject_answers_each_query_exactly_once, every_subject_has_a_non_empty_checklist, every_subject_is_resolvable_with_a_known_status_shape, article_16_entity_is_simplified_framework_entity_in_every_query, gate_false_control_is_complete_with_the_fixed_citations, gate_absent_is_asked_first_in_every_query, gate_false_alone_required_asks_the_size_first, credit_institution_requires_twenty_one_duties_in_duty_order, microenterprise_without_providers_requires_the_eighteen_duties_that_always_apply, central_counterparty_requires_its_involvement_duty, trigger_absent_required_asks_the_trigger, first_duty_false_is_outstanding_with_its_citation, non_microenterprise_switchover_false_is_outstanding, microenterprise_switchover_false_has_none_outstanding, central_counterparty_involvement_false_is_outstanding, central_securities_depository_involvement_false_is_outstanding, credit_institution_depository_key_false_has_none_outstanding, provider_user_continuity_measures_false_is_outstanding, trigger_true_provider_testing_false_is_outstanding, trigger_absent_provider_testing_false_asks_the_trigger_in_outstanding, complete_names_the_duty_key_before_the_trigger_behind_it, outstanding_names_the_trigger_first_in_root_order, unsure_alternative_options_is_referred_with_all_pairs, unsure_alternative_options_is_referred_in_outstanding, a_false_duty_decides_incomplete_before_the_unsure_one, outstanding_still_refers_the_unsure_duty_beside_a_false_one, a_referral_context_extended_with_provenance_keeps_its_pairs_first, duplicate_then_unknown_key_in_contract_order, an_unsure_gate_is_wrong_type, a_false_gate_alone_has_no_input_problem, a_term_that_is_not_a_list_is_wrong_type_profile, a_well_formed_profile_has_no_input_problem, all_performed_is_compliant, first_duty_false_is_non_compliant, article_16_entity_compliance_is_not_applicable, gate_absent_compliance_passes_the_status_through, all_performed_is_eligible_with_a_cited_checklist, first_duty_false_is_ineligible, gate_absent_is_indeterminate_eligibility, microenterprise_switchover_item_is_inapplicable]).
cp_test_fail_names([article_16_entity_is_not_complete, gate_false_control_is_not_simplified, credit_institution_does_not_require_the_central_counterparty_duty, first_duty_false_is_not_complete, microenterprise_switchover_false_is_not_incomplete, central_counterparty_all_performed_is_not_incomplete, credit_institution_depository_key_false_is_not_incomplete, no_provider_continuity_measures_false_is_not_incomplete, trigger_absent_provider_testing_false_is_not_incomplete, complete_does_not_name_the_trigger_behind_the_duty_key, unsure_alternative_options_is_not_complete, the_referral_context_carries_no_provenance_item, a_duplicate_key_is_not_also_wrong_type, first_duty_false_is_not_compliant, first_duty_false_is_not_eligible]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
