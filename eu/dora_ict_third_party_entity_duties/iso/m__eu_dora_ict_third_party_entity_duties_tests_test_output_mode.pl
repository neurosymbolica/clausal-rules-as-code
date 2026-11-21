% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_ict_third_party_entity_duties_tests_test_output_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_dora_ict_third_party_entity_duties_dora_ict_third_party_entity_duties, [entity_duties_required/3, entity_duties_complete/3, entity_duties_outstanding/3, ict_third_party_strategy_required/3, decide_dora_ict_third_party_entity_duties/2, dora_ict_third_party_entity_duties_checklist/2]).
:- use_module(m__eu_dora_ict_third_party_entity_duties_kernel, [dora_ict_third_party_entity_duties_input_problems/2]).
:- use_module(m__eu_dora_ict_third_party_entity_duties_fixtures, [dora_ict_third_party_entity_duties_profile_for/2]).

subject_profile(Subject, Profile) :-
    dora_ict_third_party_entity_duties_profile_for(Subject, Profile).

checked_citations([cite(eu_reg_2022_2554_art_28_4), cite(eu_reg_2022_2554_art_28_5), cite(eu_reg_2022_2554_art_28_6), cite(eu_reg_2022_2554_art_28_8), cite(eu_reg_2022_2554_art_29_1), cite(eu_reg_2022_2554_art_29_2)]).

complete_answers(Subject, Answers) :-
    subject_profile(Subject, Profile),
    findall(Result - Citations, entity_duties_complete(Profile, Result, Citations), Answers).

required_answers(Subject, Answers) :-
    subject_profile(Subject, Profile),
    findall(Result - Citations, entity_duties_required(Profile, Result, Citations), Answers).

outstanding_answers(Subject, Answers) :-
    subject_profile(Subject, Profile),
    findall(Result - Citations, entity_duties_outstanding(Profile, Result, Citations), Answers).

strategy_answers(Subject, Answers) :-
    subject_profile(Subject, Profile),
    findall(Result - Citations, ict_third_party_strategy_required(Profile, Result, Citations), Answers).

met_item(item(_, met, cite(_))).

test(complete_plain_arrangement) :-
    checked_citations(Citations),
    complete_answers(plain_arrangement_complete, Answers),
    Answers == [complete - Citations].
test(complete_critical_arrangement) :-
    checked_citations(Citations),
    complete_answers(critical_arrangement_complete, Answers),
    Answers == [complete - Citations].
test(incomplete_keeps_the_fixed_citations) :-
    checked_citations(Citations),
    complete_answers(critical_arrangement_exit_strategy_not_performed_concentration_unanswered, Answers),
    Answers == [incomplete - Citations].
test(complete_empty_profile_names_the_first_key) :-
    complete_answers(empty_profile, Answers),
    Answers == [indeterminate([assessed_whether_arrangement_supports_critical_or_important_function]) - []].
test(complete_names_the_key_that_decides_alone) :-
    complete_answers(critical_arrangement_exit_strategy_unanswered, Answers),
    Answers == [indeterminate([exit_strategy_in_place]) - []].
test(complete_names_the_complexity_judgement) :-
    complete_answers(critical_arrangement_complexity_unanswered, Answers),
    Answers == [indeterminate([arrangement_entails_high_technical_complexity]) - []].
test(complete_refers_the_unsure_function_judgement) :-
    complete_answers(critical_judgement_unsure_dependent_duty_not_performed, Answers),
    Answers == [needs_legal_review(open_textured(supports_critical_or_important_function, cite(eu_reg_2022_2554_art_28_4_a)), [inputs_relied_on([assessed_whether_arrangement_supports_critical_or_important_function - true, assessed_supervisory_conditions_for_contracting - true, identified_and_assessed_relevant_risks - true, undertook_due_diligence_on_provider - true, identified_and_assessed_conflicts_of_interest - true, provider_complies_with_appropriate_information_security_standards - true, entity_exercises_access_inspection_and_audit_rights - false, supports_critical_or_important_function - unsure, considered_most_up_to_date_information_security_standards - false])]) - []].
test(complete_mixed_problems_in_contract_order) :-
    complete_answers(mixed_problems_profile, Answers),
    Answers == [input_problems([wrong_type(supports_critical_or_important_function), unknown_key(unexpected_key)]) - []].
test(required_audit_arrangement) :-
    required_answers(audit_arrangement_complete, Answers),
    Answers == [required([assessment_of_critical_or_important_function, assessment_of_supervisory_conditions, risk_identification_and_assessment, due_diligence_on_provider, conflicts_of_interest_assessment, provider_with_appropriate_information_security_standards, predetermined_audit_frequency_and_areas]) - [cite(eu_reg_2022_2554_art_28_4), cite(eu_reg_2022_2554_art_28_5), cite(eu_reg_2022_2554_art_28_6)]].
test(required_complex_audit_arrangement) :-
    required_answers(complex_audit_arrangement_complete, Answers),
    Answers == [required([assessment_of_critical_or_important_function, assessment_of_supervisory_conditions, risk_identification_and_assessment, due_diligence_on_provider, conflicts_of_interest_assessment, provider_with_appropriate_information_security_standards, predetermined_audit_frequency_and_areas, verification_of_auditor_skills]) - [cite(eu_reg_2022_2554_art_28_4), cite(eu_reg_2022_2554_art_28_5), cite(eu_reg_2022_2554_art_28_6)]].
test(required_union_provider_drops_the_third_country_duty) :-
    checked_citations(Citations),
    required_answers(union_provider_data_protection_not_considered, Answers),
    Answers == [required([assessment_of_critical_or_important_function, assessment_of_supervisory_conditions, risk_identification_and_assessment, due_diligence_on_provider, conflicts_of_interest_assessment, provider_with_appropriate_information_security_standards, consideration_of_most_up_to_date_information_security_standards, predetermined_audit_frequency_and_areas, verification_of_auditor_skills, exit_strategy, exit_without_business_disruption, exit_without_limiting_regulatory_compliance, exit_without_detriment_to_client_services, tested_and_reviewed_exit_plans, alternative_solutions_and_transition_plans, contingency_measures, concentration_risk_consideration, weighing_of_alternative_solutions, weighing_of_subcontracting_benefits_and_risks, consideration_of_insolvency_law_and_data_recovery, assessment_of_subcontracting_chains]) - Citations].
test(required_asks_for_subcontracting_under_an_unsure_function) :-
    required_answers(critical_judgement_unsure_dependent_duty_not_performed, Answers),
    Answers == [indeterminate([arrangement_allows_further_subcontracting]) - []].
test(required_asks_for_complexity_when_audit_rights_are_exercised) :-
    required_answers(critical_arrangement_complexity_unanswered, Answers),
    Answers == [indeterminate([arrangement_entails_high_technical_complexity]) - []].
test(outstanding_exit_strategy) :-
    outstanding_answers(critical_arrangement_exit_strategy_not_performed, Answers),
    Answers == [outstanding([exit_strategy]) - [cite(eu_reg_2022_2554_art_28_8)]].
test(outstanding_third_country_consideration) :-
    outstanding_answers(third_country_provider_data_protection_not_considered, Answers),
    Answers == [outstanding([consideration_of_third_country_data_protection_and_enforcement]) - [cite(eu_reg_2022_2554_art_29_2)]].
test(outstanding_does_not_stop_at_a_false_key) :-
    outstanding_answers(critical_arrangement_exit_strategy_not_performed_concentration_unanswered, Answers),
    Answers == [indeterminate([considered_concentration_risk]) - []].
test(none_outstanding_keeps_the_fixed_citations) :-
    checked_citations(Citations),
    outstanding_answers(union_provider_data_protection_not_considered, Answers),
    Answers == [none_outstanding - Citations].
test(strategy_article_16_entity) :-
    strategy_answers(article_16_entity, Answers),
    Answers == [strategy_not_required - [cite(eu_reg_2022_2554_art_28_2)]].
test(strategy_microenterprise_unanswered) :-
    strategy_answers(entity_exemption_unanswered, Answers),
    Answers == [indeterminate([financial_entity_is_microenterprise]) - []].
test(strategy_empty_profile) :-
    strategy_answers(empty_profile, Answers),
    Answers == [indeterminate([financial_entity_is_article_16_1_entity]) - []].
test(input_check_duplicate_key) :-
    subject_profile(duplicate_key_profile, Profile),
    findall(Problems, dora_ict_third_party_entity_duties_input_problems(Profile, Problems), AllProblems),
    AllProblems == [[duplicate_key(exit_strategy_in_place)]].
test(the_verdict_carries_the_fixed_citations) :-
    subject_profile(plain_arrangement_complete, Profile),
    checked_citations(Citations),
    findall(Verdict, decide_dora_ict_third_party_entity_duties(Profile, Verdict), Verdicts),
    Verdicts == [dora_ict_third_party_entity_duties_verdict(complete, Citations)].
test(checklist_has_one_cited_met_item_per_applying_duty) :-
    subject_profile(plain_arrangement_complete, Profile),
    findall(Items, dora_ict_third_party_entity_duties_checklist(Profile, Items), [Items]),
    length(Items, 6),
    maplist(met_item, Items).
test(checklist_marks_the_unperformed_duty) :-
    subject_profile(audit_arrangement_frequency_not_predetermined, Profile),
    dora_ict_third_party_entity_duties_checklist(Profile, Items),
    member(item(predetermined_audit_frequency_and_areas, unmet(not_performed), cite(eu_reg_2022_2554_art_28_6)), Items).

cp_test_names([complete_plain_arrangement, complete_critical_arrangement, incomplete_keeps_the_fixed_citations, complete_empty_profile_names_the_first_key, complete_names_the_key_that_decides_alone, complete_names_the_complexity_judgement, complete_refers_the_unsure_function_judgement, complete_mixed_problems_in_contract_order, required_audit_arrangement, required_complex_audit_arrangement, required_union_provider_drops_the_third_country_duty, required_asks_for_subcontracting_under_an_unsure_function, required_asks_for_complexity_when_audit_rights_are_exercised, outstanding_exit_strategy, outstanding_third_country_consideration, outstanding_does_not_stop_at_a_false_key, none_outstanding_keeps_the_fixed_citations, strategy_article_16_entity, strategy_microenterprise_unanswered, strategy_empty_profile, input_check_duplicate_key, the_verdict_carries_the_fixed_citations, checklist_has_one_cited_met_item_per_applying_duty, checklist_marks_the_unperformed_duty]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
