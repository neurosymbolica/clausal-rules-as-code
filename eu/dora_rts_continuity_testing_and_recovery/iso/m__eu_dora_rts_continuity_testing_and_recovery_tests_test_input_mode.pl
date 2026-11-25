% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_rts_continuity_testing_and_recovery_tests_test_input_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_lists_extra, [clausal_msort/2]).
:- use_module(m__eu_dora_rts_continuity_testing_and_recovery_dora_rts_continuity_testing_and_recovery, [rts_continuity_testing_and_recovery_duties_required/3, rts_continuity_testing_and_recovery_duties_complete/3, rts_continuity_testing_and_recovery_duties_outstanding/3, dora_rts_continuity_testing_and_recovery_status/2, dora_rts_continuity_testing_and_recovery_status_values/1]).
:- use_module(m__eu_dora_rts_continuity_testing_and_recovery_kernel, [dora_rts_continuity_testing_and_recovery_input_problems/2]).
:- use_module(m__eu_dora_rts_continuity_testing_and_recovery_fixtures, [dora_rts_continuity_testing_and_recovery_profile_for/2]).

fixed_citations([cite(eu_reg_2024_1774_art_25_1), cite(eu_reg_2024_1774_art_25_2), cite(eu_reg_2024_1774_art_25_3), cite(eu_reg_2024_1774_art_25_4), cite(eu_reg_2024_1774_art_25_5), cite(eu_reg_2024_1774_art_26_1), cite(eu_reg_2024_1774_art_26_2), cite(eu_reg_2024_1774_art_26_3), cite(eu_reg_2024_1774_art_26_4)]).

test(complete_holds_with_the_answer_bound) :-
    dora_rts_continuity_testing_and_recovery_profile_for(credit_institution_all_performed, Profile),
    fixed_citations(FixedCitations),
    rts_continuity_testing_and_recovery_duties_complete(Profile, complete, FixedCitations).
test(incomplete_holds_with_the_answer_bound) :-
    dora_rts_continuity_testing_and_recovery_profile_for(credit_institution_first_duty_false, Profile),
    fixed_citations(FixedCitations),
    rts_continuity_testing_and_recovery_duties_complete(Profile, incomplete, FixedCitations).
test(the_gate_holds_bound_in_every_query) :-
    dora_rts_continuity_testing_and_recovery_profile_for(article_16_entity_all_performed, Profile),
    rts_continuity_testing_and_recovery_duties_required(Profile, simplified_framework_entity, [cite(eu_reg_2022_2554_art_16_1)]),
    rts_continuity_testing_and_recovery_duties_complete(Profile, simplified_framework_entity, [cite(eu_reg_2022_2554_art_16_1)]),
    rts_continuity_testing_and_recovery_duties_outstanding(Profile, simplified_framework_entity, [cite(eu_reg_2022_2554_art_16_1)]).
test(the_absent_gate_holds_bound) :-
    dora_rts_continuity_testing_and_recovery_profile_for(gate_absent, Profile),
    rts_continuity_testing_and_recovery_duties_complete(Profile, indeterminate([financial_entity_is_article_16_1_entity]), []).
test(the_referral_holds_bound) :-
    dora_rts_continuity_testing_and_recovery_profile_for(unsure_alternative_options, Profile),
    rts_continuity_testing_and_recovery_duties_complete(Profile, needs_legal_review(open_textured(response_and_recovery_plans_consider_alternative_options_where_primary_recovery_measures_may_not_be_feasible, cite(eu_reg_2024_1774_art_26_3)), [inputs_relied_on(Pairs)]), []),
    length(Pairs, 27).
test(the_outstanding_referral_holds_bound) :-
    dora_rts_continuity_testing_and_recovery_profile_for(unsure_alternative_options, Profile),
    rts_continuity_testing_and_recovery_duties_outstanding(Profile, needs_legal_review(open_textured(response_and_recovery_plans_consider_alternative_options_where_primary_recovery_measures_may_not_be_feasible, cite(eu_reg_2024_1774_art_26_3)), [inputs_relied_on(_Pairs)]), []).
test(required_holds_bound_for_a_microenterprise_without_providers) :-
    dora_rts_continuity_testing_and_recovery_profile_for(microenterprise_without_providers_all_performed, Profile),
    rts_continuity_testing_and_recovery_duties_required(Profile, required([testing_informed_by_business_impact_analysis_and_ict_risk_assessment, assessment_of_continuity_of_critical_or_important_functions, testing_on_disruption_scenarios, testing_challenges_plan_assumptions, testing_verifies_ability_to_respond, documentation_of_test_results, handling_of_test_deficiencies, response_and_recovery_plans_informed_by_business_impact_analysis, activation_and_deactivation_conditions, actions_for_critical_or_important_ict_systems_and_services, design_to_meet_recovery_objectives, documentation_and_availability_of_plans, short_and_long_term_recovery_options, plan_objectives_and_success_conditions, identification_of_relevant_scenarios, scenarios_based_on_threats_and_lessons_learned, listed_disruption_scenarios, alternative_recovery_options]), Citations),
    clausal_msort(Citations, SortedCitations),
    SortedCitations == [cite(eu_reg_2024_1774_art_25_1), cite(eu_reg_2024_1774_art_25_2), cite(eu_reg_2024_1774_art_25_5), cite(eu_reg_2024_1774_art_26_1), cite(eu_reg_2024_1774_art_26_2), cite(eu_reg_2024_1774_art_26_3)].
test(outstanding_holds_bound_for_a_missing_switchover_scenario) :-
    dora_rts_continuity_testing_and_recovery_profile_for(non_microenterprise_switchover_false, Profile),
    rts_continuity_testing_and_recovery_duties_outstanding(Profile, outstanding([testing_of_switchover_scenarios]), Citations),
    clausal_msort(Citations, SortedCitations),
    SortedCitations == [cite(eu_reg_2024_1774_art_25_2), cite(eu_reg_2024_1774_art_25_2_c)].
test(none_outstanding_holds_bound) :-
    dora_rts_continuity_testing_and_recovery_profile_for(credit_institution_all_performed, Profile),
    fixed_citations(FixedCitations),
    rts_continuity_testing_and_recovery_duties_outstanding(Profile, none_outstanding, FixedCitations).
test(input_problems_hold_bound) :-
    dora_rts_continuity_testing_and_recovery_profile_for(duplicate_and_unknown_key, Profile),
    rts_continuity_testing_and_recovery_duties_complete(Profile, input_problems([duplicate_key(financial_entity_is_article_16_1_entity), unknown_key(unlisted_key)]), []).
test(status_holds_with_the_verdict_bound) :-
    dora_rts_continuity_testing_and_recovery_profile_for(credit_institution_all_performed, Profile),
    dora_rts_continuity_testing_and_recovery_status(Profile, complete).
test(a_well_formed_empty_profile_has_no_problem) :-
    dora_rts_continuity_testing_and_recovery_input_problems([], []).
test(a_profile_that_is_not_a_list_is_wrong_type) :-
    dora_rts_continuity_testing_and_recovery_input_problems(not_an_attribute_list, [wrong_type(profile)]).
test(an_unbound_profile_is_wrong_type) :-
    dora_rts_continuity_testing_and_recovery_input_problems(_UnboundProfile, [wrong_type(profile)]).
test(a_partial_list_is_wrong_type) :-
    dora_rts_continuity_testing_and_recovery_input_problems([attribute(financial_entity_is_article_16_1_entity, false)|_LaterAttributes], [wrong_type(profile)]).
test(a_list_with_a_foreign_element_is_wrong_type) :-
    dora_rts_continuity_testing_and_recovery_input_problems([attribute(financial_entity_is_article_16_1_entity, false), stray_element], [wrong_type(profile)]).
test(unsure_is_wrong_type_for_a_fact) :-
    dora_rts_continuity_testing_and_recovery_input_problems([attribute(financial_entity_is_microenterprise, unsure)], [wrong_type(financial_entity_is_microenterprise)]).
test(unsure_is_allowed_for_a_judgement) :-
    dora_rts_continuity_testing_and_recovery_input_problems([attribute(continuity_test_results_documented, unsure)], []).
test(a_float_is_wrong_type_for_a_judgement) :-
    dora_rts_continuity_testing_and_recovery_input_problems([attribute(continuity_test_results_documented, 1.0)], [wrong_type(continuity_test_results_documented)]).
test(an_unbound_value_is_wrong_type) :-
    dora_rts_continuity_testing_and_recovery_input_problems([attribute(dora_entity_type, _UnboundValue)], [wrong_type(dora_entity_type)]).
test(an_atom_outside_the_entity_types_is_wrong_type) :-
    dora_rts_continuity_testing_and_recovery_input_problems([attribute(dora_entity_type, bank)], [wrong_type(dora_entity_type)]).
test(an_unbound_key_is_reported_as_given) :-
    dora_rts_continuity_testing_and_recovery_input_problems([attribute(UnboundKey, 1)], [unknown_key(ReportedKey)]),
    ReportedKey == UnboundKey.
test(the_same_unbound_key_twice_is_one_key) :-
    dora_rts_continuity_testing_and_recovery_input_problems([attribute(UnboundKey, 1), attribute(UnboundKey, 2)], Problems),
    length(Problems, 1).
test(two_distinct_unbound_keys_are_two_keys) :-
    dora_rts_continuity_testing_and_recovery_input_problems([attribute(_FirstKey, 1), attribute(_SecondKey, 2)], Problems),
    length(Problems, 2).
test(a_duplicate_key_is_never_also_wrong_type) :-
    dora_rts_continuity_testing_and_recovery_input_problems([attribute(dora_entity_type, bank), attribute(dora_entity_type, credit_institution)], [duplicate_key(dora_entity_type)]).
test(contract_problems_come_before_unknown_keys) :-
    dora_rts_continuity_testing_and_recovery_input_problems([attribute(unlisted_key, 1), attribute(financial_entity_is_microenterprise, 7)], [wrong_type(financial_entity_is_microenterprise), unknown_key(unlisted_key)]).

test(a_bound_wrong_answer_is_rejected, fail) :-
    dora_rts_continuity_testing_and_recovery_profile_for(credit_institution_all_performed, Profile),
    rts_continuity_testing_and_recovery_duties_complete(Profile, incomplete, _).
test(every_other_bound_status_is_rejected, fail) :-
    dora_rts_continuity_testing_and_recovery_profile_for(credit_institution_all_performed, Profile),
    dora_rts_continuity_testing_and_recovery_status_values(StatusValues),
    member(OtherStatus, StatusValues),
    dif(OtherStatus, complete),
    dora_rts_continuity_testing_and_recovery_status(Profile, OtherStatus).

cp_test_names([complete_holds_with_the_answer_bound, incomplete_holds_with_the_answer_bound, the_gate_holds_bound_in_every_query, the_absent_gate_holds_bound, the_referral_holds_bound, the_outstanding_referral_holds_bound, required_holds_bound_for_a_microenterprise_without_providers, outstanding_holds_bound_for_a_missing_switchover_scenario, none_outstanding_holds_bound, input_problems_hold_bound, status_holds_with_the_verdict_bound, a_well_formed_empty_profile_has_no_problem, a_profile_that_is_not_a_list_is_wrong_type, an_unbound_profile_is_wrong_type, a_partial_list_is_wrong_type, a_list_with_a_foreign_element_is_wrong_type, unsure_is_wrong_type_for_a_fact, unsure_is_allowed_for_a_judgement, a_float_is_wrong_type_for_a_judgement, an_unbound_value_is_wrong_type, an_atom_outside_the_entity_types_is_wrong_type, an_unbound_key_is_reported_as_given, the_same_unbound_key_twice_is_one_key, two_distinct_unbound_keys_are_two_keys, a_duplicate_key_is_never_also_wrong_type, contract_problems_come_before_unknown_keys]).
cp_test_fail_names([a_bound_wrong_answer_is_rejected, every_other_bound_status_is_rejected]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
