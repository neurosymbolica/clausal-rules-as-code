% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_rts_continuity_testing_and_recovery_tests_test_queries, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_dora_rts_continuity_testing_and_recovery_queries, [dora_rts_continuity_testing_and_recovery_profile_keys/1, dora_rts_continuity_testing_and_recovery_what_if/4, dora_rts_continuity_testing_and_recovery_compliance_check/2, dora_rts_continuity_testing_and_recovery_eligibility/2]).
:- use_module(m__eu_dora_rts_continuity_testing_and_recovery_kernel, [dora_rts_continuity_testing_and_recovery_input_problems/2]).
:- use_module(m__eu_dora_rts_continuity_testing_and_recovery_fixtures, [dora_rts_continuity_testing_and_recovery_profile_for/2]).

test(profile_keys_are_the_contract_keys) :-
    dora_rts_continuity_testing_and_recovery_profile_keys(ProfileKeys),
    ProfileKeys == [financial_entity_is_article_16_1_entity, financial_entity_is_microenterprise, dora_entity_type, financial_entity_uses_ict_services_of_ict_third_party_service_providers, continuity_testing_takes_into_account_business_impact_analysis_and_ict_risk_assessment, continuity_testing_assesses_continuity_of_critical_or_important_functions, continuity_testing_based_on_scenarios_including_severe_but_plausible_scenarios, continuity_testing_contains_testing_of_ict_services_of_ict_third_party_service_providers, continuity_testing_contains_switchover_scenarios, continuity_testing_challenges_assumptions_of_business_continuity_plans, continuity_testing_contains_procedures_to_verify_ability_to_respond, continuity_testing_involves_clearing_members_external_providers_and_interdependent_institutions, continuity_testing_involves_users_utilities_market_infrastructures_and_interdependent_institutions, continuity_test_results_documented, continuity_test_deficiencies_analysed_addressed_and_reported_to_management_body, response_and_recovery_plans_take_into_account_business_impact_analysis, response_and_recovery_plans_specify_activation_and_deactivation_conditions_and_exceptions, response_and_recovery_plans_describe_actions_for_ict_systems_and_services_supporting_critical_or_important_functions, response_and_recovery_plans_designed_to_meet_recovery_objectives, response_and_recovery_plans_documented_available_and_accessible_with_roles_and_responsibilities, response_and_recovery_plans_provide_short_term_and_long_term_recovery_options, response_and_recovery_plans_lay_down_objectives_and_conditions_of_successful_execution, response_and_recovery_plans_identify_relevant_scenarios, response_and_recovery_plans_develop_scenarios_on_current_threat_information_and_lessons_learned, listed_disruption_scenarios_duly_taken_into_account, response_and_recovery_plans_consider_alternative_options_where_primary_recovery_measures_may_not_be_feasible, continuity_measures_for_ict_third_party_service_provider_failures_considered_and_implemented].
test(the_reexported_input_check_finds_an_unknown_key) :-
    dora_rts_continuity_testing_and_recovery_input_problems([attribute(unlisted_key, 1)], [unknown_key(unlisted_key)]).
test(what_if_performing_the_false_duty_makes_it_complete) :-
    dora_rts_continuity_testing_and_recovery_profile_for(credit_institution_first_duty_false, Profile),
    findall(NewStatus, dora_rts_continuity_testing_and_recovery_what_if(Profile, continuity_testing_takes_into_account_business_impact_analysis_and_ict_risk_assessment, true, NewStatus), NewStatuses),
    NewStatuses == [complete].
test(what_if_the_entity_were_an_article_16_entity) :-
    dora_rts_continuity_testing_and_recovery_profile_for(credit_institution_first_duty_false, Profile),
    dora_rts_continuity_testing_and_recovery_what_if(Profile, financial_entity_is_article_16_1_entity, true, simplified_framework_entity).
test(a_fully_performed_entity_is_compliant) :-
    dora_rts_continuity_testing_and_recovery_profile_for(credit_institution_all_performed, Profile),
    findall(Verdict, dora_rts_continuity_testing_and_recovery_compliance_check(Profile, Verdict), [compliance_verdict(compliant, [], Citations)]),
    length(Citations, 9).
test(a_false_duty_is_non_compliant_with_its_citation) :-
    dora_rts_continuity_testing_and_recovery_profile_for(credit_institution_first_duty_false, Profile),
    dora_rts_continuity_testing_and_recovery_compliance_check(Profile, Verdict),
    Verdict == compliance_verdict(non_compliant, [testing_informed_by_business_impact_analysis_and_ict_risk_assessment], [cite(eu_reg_2024_1774_art_25_1)]).
test(a_missing_key_passes_through_compliance) :-
    dora_rts_continuity_testing_and_recovery_profile_for(gate_absent, Profile),
    dora_rts_continuity_testing_and_recovery_compliance_check(Profile, compliance_verdict(indeterminate([financial_entity_is_article_16_1_entity]), [], [])).
test(a_referral_passes_through_compliance) :-
    dora_rts_continuity_testing_and_recovery_profile_for(unsure_alternative_options, Profile),
    dora_rts_continuity_testing_and_recovery_compliance_check(Profile, compliance_verdict(needs_legal_review(open_textured(_, cite(eu_reg_2024_1774_art_26_3)), _), [], [])).
test(input_problems_pass_through_compliance) :-
    dora_rts_continuity_testing_and_recovery_profile_for(profile_not_a_list, Profile),
    dora_rts_continuity_testing_and_recovery_compliance_check(Profile, compliance_verdict(input_problems([wrong_type(profile)]), [], [])).
test(a_fully_performed_entity_is_eligible_with_a_full_checklist) :-
    dora_rts_continuity_testing_and_recovery_profile_for(credit_institution_all_performed, Profile),
    findall(Assessment, dora_rts_continuity_testing_and_recovery_eligibility(Profile, Assessment), [eligibility_assessment(eligible, Checklist)]),
    length(Checklist, 24).
test(a_false_duty_is_ineligible) :-
    dora_rts_continuity_testing_and_recovery_profile_for(credit_institution_first_duty_false, Profile),
    dora_rts_continuity_testing_and_recovery_eligibility(Profile, eligibility_assessment(ineligible, Checklist)),
    member(item(testing_informed_by_business_impact_analysis_and_ict_risk_assessment, unmet(not_performed), [cite(eu_reg_2024_1774_art_25_1)]), Checklist).
test(an_article_16_entity_is_not_applicable_for_eligibility) :-
    dora_rts_continuity_testing_and_recovery_profile_for(article_16_entity_all_performed, Profile),
    dora_rts_continuity_testing_and_recovery_eligibility(Profile, eligibility_assessment(not_applicable, [item(article_16_1_entity, unmet(simplified_framework_entity), [cite(eu_reg_2022_2554_art_16_1)])])).
test(an_inapplicable_duty_is_marked_in_the_checklist) :-
    dora_rts_continuity_testing_and_recovery_profile_for(microenterprise_switchover_false, Profile),
    dora_rts_continuity_testing_and_recovery_eligibility(Profile, eligibility_assessment(eligible, Checklist)),
    member(item(testing_of_switchover_scenarios, inapplicable, [cite(eu_reg_2024_1774_art_25_2_c), cite(eu_reg_2024_1774_art_25_2)]), Checklist).

test(what_if_does_not_keep_the_old_answer, fail) :-
    dora_rts_continuity_testing_and_recovery_profile_for(credit_institution_first_duty_false, Profile),
    dora_rts_continuity_testing_and_recovery_what_if(Profile, continuity_testing_takes_into_account_business_impact_analysis_and_ict_risk_assessment, true, incomplete).
test(a_false_duty_is_not_compliant, fail) :-
    dora_rts_continuity_testing_and_recovery_profile_for(credit_institution_first_duty_false, Profile),
    dora_rts_continuity_testing_and_recovery_compliance_check(Profile, compliance_verdict(compliant, _, _)).
test(a_false_duty_is_not_eligible, fail) :-
    dora_rts_continuity_testing_and_recovery_profile_for(credit_institution_first_duty_false, Profile),
    dora_rts_continuity_testing_and_recovery_eligibility(Profile, eligibility_assessment(eligible, _)).
test(no_checklist_item_lacks_a_citation, fail) :-
    dora_rts_continuity_testing_and_recovery_profile_for(credit_institution_all_performed, Profile),
    dora_rts_continuity_testing_and_recovery_eligibility(Profile, eligibility_assessment(_, Checklist)),
    member(item(_, _, []), Checklist).

cp_test_names([profile_keys_are_the_contract_keys, the_reexported_input_check_finds_an_unknown_key, what_if_performing_the_false_duty_makes_it_complete, what_if_the_entity_were_an_article_16_entity, a_fully_performed_entity_is_compliant, a_false_duty_is_non_compliant_with_its_citation, a_missing_key_passes_through_compliance, a_referral_passes_through_compliance, input_problems_pass_through_compliance, a_fully_performed_entity_is_eligible_with_a_full_checklist, a_false_duty_is_ineligible, an_article_16_entity_is_not_applicable_for_eligibility, an_inapplicable_duty_is_marked_in_the_checklist]).
cp_test_fail_names([what_if_does_not_keep_the_old_answer, a_false_duty_is_not_compliant, a_false_duty_is_not_eligible, no_checklist_item_lacks_a_citation]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
