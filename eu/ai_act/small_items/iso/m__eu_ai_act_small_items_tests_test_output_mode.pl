% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_ai_act_small_items_tests_test_output_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_ai_act_small_items_small_items, [decide_small_items/2, small_items_status/2, small_items_status_values/1, bias_data_processing_status/4, real_world_testing_status/4, explanation_right_status/4]).
:- use_module(m__eu_ai_act_small_items_fixtures, [small_items_subject/1, small_items_profile_for/2]).

subject_verdicts(Subject, Verdicts) :-
    small_items_profile_for(Subject, Request),
    findall(Verdict, decide_small_items(Request, Verdict), Verdicts).

subject_status(Subject, Status) :-
    small_items_profile_for(Subject, Request),
    small_items_status(Request, Status).

same_citations(Citations, Expected) :-
    sort(Citations, Sorted),
    sort(Expected, Sorted).

single_verdict(Subject, Status, Expected) :-
    subject_verdicts(Subject, [small_items_verdict(Status, Citations)]),
    same_citations(Citations, Expected).

paragraph_one_citations([cite(eu_reg_2024_1689_art_4a_1), cite(eu_reg_2024_1689_art_4a_1_a), cite(eu_reg_2024_1689_art_4a_1_b), cite(eu_reg_2024_1689_art_4a_1_c), cite(eu_reg_2024_1689_art_4a_1_d), cite(eu_reg_2024_1689_art_4a_1_e), cite(eu_reg_2024_1689_art_4a_1_f)]).

paragraph_two_citations([cite(eu_reg_2024_1689_art_4a_2), cite(eu_reg_2024_1689_art_4a_2_a), cite(eu_reg_2024_1689_art_4a_2_b), cite(eu_reg_2024_1689_art_4a_1), cite(eu_reg_2024_1689_art_4a_1_a), cite(eu_reg_2024_1689_art_4a_1_b), cite(eu_reg_2024_1689_art_4a_1_c), cite(eu_reg_2024_1689_art_4a_1_d), cite(eu_reg_2024_1689_art_4a_1_e), cite(eu_reg_2024_1689_art_4a_1_f)]).

consent_citations([cite(eu_reg_2024_1689_art_61_1), cite(eu_reg_2024_1689_art_61_1_a), cite(eu_reg_2024_1689_art_61_1_b), cite(eu_reg_2024_1689_art_61_1_c), cite(eu_reg_2024_1689_art_61_1_d), cite(eu_reg_2024_1689_art_61_1_e), cite(eu_reg_2024_1689_art_61_2)]).

test(bias_provider_on_the_first_day_is_permitted) :-
    paragraph_one_citations(Expected),
    single_verdict(bias_provider_all_conditions_met, bias_processing_permitted, Expected).
test(bias_provider_the_day_before_is_not_applicable) :-
    single_verdict(bias_provider_on_twenty_sixth_july, not_applicable_on_date, [cite(eu_reg_2024_1689_art_113_a)]).
test(bias_provider_without_records_is_not_permitted) :-
    paragraph_one_citations(Expected),
    single_verdict(bias_provider_without_records_of_reasons, bias_processing_not_permitted, Expected).
test(bias_other_deployer_cites_both_paragraphs) :-
    paragraph_two_citations(Expected),
    single_verdict(bias_other_deployer_all_conditions_met, bias_processing_permitted, Expected).
test(bias_unsure_safeguards_go_to_a_lawyer) :-
    subject_verdicts(bias_other_deployer_safeguards_unsure, Verdicts),
    Verdicts == [small_items_verdict(needs_legal_review(open_textured(appropriate_safeguards_for_fundamental_rights_and_freedoms, cite(eu_reg_2024_1689_art_4a_1)), [inputs_relied_on([strictly_necessary_for_bias_detection_and_correction_of_biases_affecting_health_safety_or_fundamental_rights - true, appropriate_safeguards_for_fundamental_rights_and_freedoms - unsure, bias_detection_cannot_be_effectively_fulfilled_by_processing_other_data - true, technical_limitations_on_reuse_and_state_of_the_art_security_and_privacy_preserving_measures - true, measures_securing_and_protecting_the_data_with_strict_access_controls_and_documentation - true])]), [])].
test(bias_capacity_absent_is_named) :-
    subject_verdicts(bias_capacity_absent, Verdicts),
    Verdicts == [small_items_verdict(indeterminate([bias_processing_capacity]), [])].
test(bias_first_day_with_an_empty_profile_asks_the_capacity) :-
    findall(Result - Citations, bias_data_processing_status([], date(2026, 7, 27), Result, Citations), Answers),
    Answers == [indeterminate([bias_processing_capacity]) - []].
test(sandbox_outside_law_enforcement_is_permitted) :-
    single_verdict(sandbox_outside_law_enforcement, sandbox_processing_permitted, [cite(eu_reg_2024_1689_art_59_1), cite(eu_reg_2024_1689_art_59_2)]).
test(sandbox_the_day_before_is_not_applicable) :-
    single_verdict(sandbox_on_first_august, not_applicable_on_date, [cite(eu_reg_2024_1689_art_113)]).
test(sandbox_law_enforcement_with_specific_law_is_permitted) :-
    single_verdict(sandbox_law_enforcement_with_specific_law, sandbox_processing_permitted, [cite(eu_reg_2024_1689_art_59_1), cite(eu_reg_2024_1689_art_59_2)]).
test(sandbox_law_enforcement_without_specific_law_is_not_permitted) :-
    single_verdict(sandbox_law_enforcement_without_specific_law, sandbox_processing_not_permitted, [cite(eu_reg_2024_1689_art_59_1), cite(eu_reg_2024_1689_art_59_2)]).
test(sandbox_unlisted_area_is_not_permitted) :-
    single_verdict(sandbox_none_of_the_listed_areas, sandbox_processing_not_permitted, [cite(eu_reg_2024_1689_art_59_1), cite(eu_reg_2024_1689_art_59_2)]).
test(sandbox_nothing_known_names_the_first_key) :-
    subject_verdicts(sandbox_nothing_known, Verdicts),
    Verdicts == [small_items_verdict(indeterminate([sandbox_processing_of_data_collected_for_other_purposes_solely_for_developing_training_and_testing]), [])].
test(section_b_without_framework_is_not_provided_for) :-
    single_verdict(testing_section_b_without_framework, testing_not_provided_for_by_the_member_state, [cite(eu_reg_2024_1689_art_60a_1), cite(eu_reg_2024_1689_art_60a_2)]).
test(section_b_with_framework_is_subject_to_it) :-
    single_verdict(testing_section_b_with_framework, subject_to_the_member_state_framework, [cite(eu_reg_2024_1689_art_60a_1), cite(eu_reg_2024_1689_art_60a_5)]).
test(section_b_without_framework_key_names_it) :-
    findall(Result - Citations, real_world_testing_status([attribute(testing_route, annex_i_section_b)], date(2026, 8, 2), Result, Citations), Answers),
    Answers == [indeterminate([member_state_has_adopted_a_real_world_testing_framework]) - []].
test(annex_iii_testing_is_permitted) :-
    single_verdict(testing_annex_iii_all_conditions_met, real_world_testing_permitted, [cite(eu_reg_2024_1689_art_60_1), cite(eu_reg_2024_1689_art_60_4)]).
test(testing_the_day_before_is_not_applicable) :-
    single_verdict(testing_on_first_august, not_applicable_on_date, [cite(eu_reg_2024_1689_art_113)]).
test(tacit_approval_in_national_law_is_permitted) :-
    single_verdict(testing_tacit_approval_allowed, real_world_testing_permitted, [cite(eu_reg_2024_1689_art_60_1), cite(eu_reg_2024_1689_art_60_4)]).
test(tacit_approval_without_national_law_is_not_permitted) :-
    single_verdict(testing_tacit_approval_not_in_national_law, real_world_testing_not_permitted, [cite(eu_reg_2024_1689_art_60_1), cite(eu_reg_2024_1689_art_60_4)]).
test(notified_extension_is_permitted) :-
    single_verdict(testing_extension_notified, real_world_testing_permitted, [cite(eu_reg_2024_1689_art_60_1), cite(eu_reg_2024_1689_art_60_4)]).
test(unnotified_extension_is_not_permitted) :-
    single_verdict(testing_extension_not_notified, real_world_testing_not_permitted, [cite(eu_reg_2024_1689_art_60_1), cite(eu_reg_2024_1689_art_60_4)]).
test(longer_than_twelve_months_is_not_permitted) :-
    single_verdict(testing_longer_than_twelve_months, real_world_testing_not_permitted, [cite(eu_reg_2024_1689_art_60_1), cite(eu_reg_2024_1689_art_60_4)]).
test(law_enforcement_without_consent_and_no_negative_effect_is_permitted) :-
    single_verdict(testing_law_enforcement_without_consent, real_world_testing_permitted, [cite(eu_reg_2024_1689_art_60_1), cite(eu_reg_2024_1689_art_60_4)]).
test(law_enforcement_with_negative_effect_is_not_permitted) :-
    single_verdict(testing_law_enforcement_with_negative_effect, real_world_testing_not_permitted, [cite(eu_reg_2024_1689_art_60_1), cite(eu_reg_2024_1689_art_60_4)]).
test(deployers_with_agreement_is_permitted) :-
    single_verdict(testing_deployers_bound_by_agreement, real_world_testing_permitted, [cite(eu_reg_2024_1689_art_60_1), cite(eu_reg_2024_1689_art_60_4)]).
test(deployers_without_agreement_is_not_permitted) :-
    single_verdict(testing_deployers_without_agreement, real_world_testing_not_permitted, [cite(eu_reg_2024_1689_art_60_1), cite(eu_reg_2024_1689_art_60_4)]).
test(consent_facts_absent_names_the_consent_key_not_the_one_behind_it) :-
    subject_verdicts(testing_consent_facts_absent, Verdicts),
    Verdicts == [small_items_verdict(indeterminate([informed_consent_given_in_accordance_with_article_61]), [])].
test(empty_testing_profile_asks_the_route) :-
    findall(Result - Citations, real_world_testing_status([], date(2026, 8, 2), Result, Citations), Answers),
    Answers == [indeterminate([testing_route]) - []].
test(consent_meeting_all_conditions) :-
    consent_citations(Expected),
    single_verdict(consent_meets_all_conditions, consent_meets_article_61, Expected).
test(consent_without_copy_does_not_meet) :-
    consent_citations(Expected),
    single_verdict(consent_without_copy, consent_does_not_meet_article_61, Expected).
test(consent_freely_given_unsure_goes_to_a_lawyer) :-
    subject_verdicts(consent_freely_given_unsure, Verdicts),
    Verdicts == [small_items_verdict(needs_legal_review(open_textured(consent_freely_given, cite(eu_reg_2024_1689_art_61_1)), [inputs_relied_on([consent_freely_given - unsure, information_concise_clear_relevant_and_understandable - true])]), [])].
test(independent_sme_may_simplify) :-
    single_verdict(sme_independent, may_comply_in_a_simplified_manner, [cite(eu_reg_2024_1689_art_63_1), cite(eu_reg_2024_1689_art_63_2)]).
test(sme_with_linked_enterprises_may_not_simplify) :-
    single_verdict(sme_with_linked_enterprises, no_simplified_compliance, [cite(eu_reg_2024_1689_art_63_1), cite(eu_reg_2024_1689_art_63_2)]).
test(a_non_sme_may_not_simplify) :-
    single_verdict(sme_not_an_sme, no_simplified_compliance, [cite(eu_reg_2024_1689_art_63_1), cite(eu_reg_2024_1689_art_63_2)]).
test(explanation_right_when_all_conditions_are_met) :-
    single_verdict(explanation_all_conditions_met, right_to_explanation_under_article_86, [cite(eu_reg_2024_1689_art_86_1), cite(eu_reg_2024_1689_art_86_2), cite(eu_reg_2024_1689_art_86_3)]).
test(explanation_the_day_before_is_not_applicable) :-
    single_verdict(explanation_on_first_august, not_applicable_on_date, [cite(eu_reg_2024_1689_art_113)]).
test(explanation_point_2_system_gives_no_right) :-
    single_verdict(explanation_point_2_system, no_right_to_explanation_under_article_86, [cite(eu_reg_2024_1689_art_86_1), cite(eu_reg_2024_1689_art_86_2), cite(eu_reg_2024_1689_art_86_3)]).
test(explanation_exception_gives_no_right) :-
    single_verdict(explanation_exception_in_union_or_national_law, no_right_to_explanation_under_article_86, [cite(eu_reg_2024_1689_art_86_1), cite(eu_reg_2024_1689_art_86_2), cite(eu_reg_2024_1689_art_86_3)]).
test(explanation_otherwise_provided_gives_no_right) :-
    single_verdict(explanation_otherwise_provided_for, no_right_to_explanation_under_article_86, [cite(eu_reg_2024_1689_art_86_1), cite(eu_reg_2024_1689_art_86_2), cite(eu_reg_2024_1689_art_86_3)]).
test(explanation_legal_effects_need_the_adverse_impact) :-
    findall(Result, explanation_right_status([attribute(affected_person_subject_to_a_deployer_decision_based_on_the_system_output, true), attribute(system_is_a_high_risk_ai_system_listed_in_annex_iii, true), attribute(system_listed_under_point_2_of_annex_iii, false), attribute(decision_produces_legal_effects_or_similarly_significantly_affects_the_person, true), attribute(person_considers_an_adverse_impact_on_health_safety_or_fundamental_rights, false), attribute(union_or_national_law_provides_an_exception_or_restriction, false), attribute(right_otherwise_provided_for_under_union_law, false)], date(2026, 8, 2), Result, _), Results),
    Results == [no_right_to_explanation_under_article_86].
test(duplicate_and_unknown_keys_are_input_problems) :-
    subject_verdicts(input_duplicate_and_unknown_key, Verdicts),
    Verdicts == [small_items_verdict(input_problems([duplicate_key(is_an_sme_including_a_start_up), unknown_key(unlisted_key)]), [])].
test(an_impossible_date_is_an_input_problem) :-
    subject_verdicts(input_impossible_date, Verdicts),
    Verdicts == [small_items_verdict(input_problems([wrong_type(assessment_date)]), [])].
test(every_final_status_atom_is_reached_by_a_fixture) :-
    small_items_status_values(StatusValues),
    findall(Status, (small_items_subject(Subject), subject_status(Subject, Status), member(Status, StatusValues)), Reached),
    sort(Reached, ReachedSet),
    sort(StatusValues, ReachedSet).

cp_test_names([bias_provider_on_the_first_day_is_permitted, bias_provider_the_day_before_is_not_applicable, bias_provider_without_records_is_not_permitted, bias_other_deployer_cites_both_paragraphs, bias_unsure_safeguards_go_to_a_lawyer, bias_capacity_absent_is_named, bias_first_day_with_an_empty_profile_asks_the_capacity, sandbox_outside_law_enforcement_is_permitted, sandbox_the_day_before_is_not_applicable, sandbox_law_enforcement_with_specific_law_is_permitted, sandbox_law_enforcement_without_specific_law_is_not_permitted, sandbox_unlisted_area_is_not_permitted, sandbox_nothing_known_names_the_first_key, section_b_without_framework_is_not_provided_for, section_b_with_framework_is_subject_to_it, section_b_without_framework_key_names_it, annex_iii_testing_is_permitted, testing_the_day_before_is_not_applicable, tacit_approval_in_national_law_is_permitted, tacit_approval_without_national_law_is_not_permitted, notified_extension_is_permitted, unnotified_extension_is_not_permitted, longer_than_twelve_months_is_not_permitted, law_enforcement_without_consent_and_no_negative_effect_is_permitted, law_enforcement_with_negative_effect_is_not_permitted, deployers_with_agreement_is_permitted, deployers_without_agreement_is_not_permitted, consent_facts_absent_names_the_consent_key_not_the_one_behind_it, empty_testing_profile_asks_the_route, consent_meeting_all_conditions, consent_without_copy_does_not_meet, consent_freely_given_unsure_goes_to_a_lawyer, independent_sme_may_simplify, sme_with_linked_enterprises_may_not_simplify, a_non_sme_may_not_simplify, explanation_right_when_all_conditions_are_met, explanation_the_day_before_is_not_applicable, explanation_point_2_system_gives_no_right, explanation_exception_gives_no_right, explanation_otherwise_provided_gives_no_right, explanation_legal_effects_need_the_adverse_impact, duplicate_and_unknown_keys_are_input_problems, an_impossible_date_is_an_input_problem, every_final_status_atom_is_reached_by_a_fixture]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
