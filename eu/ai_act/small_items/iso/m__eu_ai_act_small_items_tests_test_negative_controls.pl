% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_ai_act_small_items_tests_test_negative_controls, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_ai_act_small_items_small_items, [small_items_status/2, small_items_status_values/1, sme_simplified_compliance_status/4]).
:- use_module(m__eu_ai_act_small_items_fixtures, [small_items_profile_for/2]).

subject_status(Subject, Status) :-
    small_items_profile_for(Subject, Request),
    small_items_status(Request, Status).

status_atom(Status) :-
    small_items_status_values(StatusValues),
    member(Status, StatusValues).

test(the_status_table_has_a_near_miss_atom) :-
    small_items_status_values(StatusValues),
    StatusValues = [_, _|_].
test(the_near_miss_atoms_are_table_atoms) :-
    maplist(status_atom, [bias_processing_not_permitted, sandbox_processing_not_permitted, testing_not_provided_for_by_the_member_state, real_world_testing_not_permitted, consent_does_not_meet_article_61, no_simplified_compliance, no_right_to_explanation_under_article_86, not_applicable_on_date]).
test(bias_provider_positive) :-
    subject_status(bias_provider_all_conditions_met, bias_processing_permitted).
test(bias_provider_near_miss_gets_not_permitted) :-
    subject_status(bias_provider_without_records_of_reasons, bias_processing_not_permitted).
test(bias_date_positive) :-
    subject_status(bias_provider_all_conditions_met, bias_processing_permitted).
test(bias_date_near_miss_gets_not_applicable) :-
    subject_status(bias_provider_on_twenty_sixth_july, not_applicable_on_date).
test(bias_other_positive) :-
    subject_status(bias_other_deployer_all_conditions_met, bias_processing_permitted).
test(bias_other_near_miss_goes_to_a_lawyer) :-
    subject_status(bias_other_deployer_safeguards_unsure, needs_legal_review(open_textured(appropriate_safeguards_for_fundamental_rights_and_freedoms, cite(eu_reg_2024_1689_art_4a_1)), _)).
test(sandbox_area_positive) :-
    subject_status(sandbox_outside_law_enforcement, sandbox_processing_permitted).
test(sandbox_area_near_miss_gets_not_permitted) :-
    subject_status(sandbox_none_of_the_listed_areas, sandbox_processing_not_permitted).
test(sandbox_law_enforcement_positive) :-
    subject_status(sandbox_law_enforcement_with_specific_law, sandbox_processing_permitted).
test(sandbox_law_enforcement_near_miss_gets_not_permitted) :-
    subject_status(sandbox_law_enforcement_without_specific_law, sandbox_processing_not_permitted).
test(sandbox_date_near_miss_gets_not_applicable) :-
    subject_status(sandbox_on_first_august, not_applicable_on_date).
test(framework_positive) :-
    subject_status(testing_section_b_with_framework, subject_to_the_member_state_framework).
test(framework_near_miss_gets_not_provided_for) :-
    subject_status(testing_section_b_without_framework, testing_not_provided_for_by_the_member_state).
test(tacit_approval_positive) :-
    subject_status(testing_tacit_approval_allowed, real_world_testing_permitted).
test(tacit_approval_near_miss_gets_not_permitted) :-
    subject_status(testing_tacit_approval_not_in_national_law, real_world_testing_not_permitted).
test(duration_positive) :-
    subject_status(testing_extension_notified, real_world_testing_permitted).
test(duration_near_miss_gets_not_permitted) :-
    subject_status(testing_extension_not_notified, real_world_testing_not_permitted).
test(law_enforcement_positive) :-
    subject_status(testing_law_enforcement_without_consent, real_world_testing_permitted).
test(law_enforcement_near_miss_gets_not_permitted) :-
    subject_status(testing_law_enforcement_with_negative_effect, real_world_testing_not_permitted).
test(deployers_positive) :-
    subject_status(testing_deployers_bound_by_agreement, real_world_testing_permitted).
test(deployers_near_miss_gets_not_permitted) :-
    subject_status(testing_deployers_without_agreement, real_world_testing_not_permitted).
test(consent_positive) :-
    subject_status(consent_meets_all_conditions, consent_meets_article_61).
test(consent_near_miss_gets_does_not_meet) :-
    subject_status(consent_without_copy, consent_does_not_meet_article_61).
test(sme_positive) :-
    subject_status(sme_independent, may_comply_in_a_simplified_manner).
test(sme_near_miss_gets_no_simplified_compliance) :-
    subject_status(sme_with_linked_enterprises, no_simplified_compliance).
test(explanation_positive) :-
    subject_status(explanation_all_conditions_met, right_to_explanation_under_article_86).
test(explanation_point_2_near_miss_gets_no_right) :-
    subject_status(explanation_point_2_system, no_right_to_explanation_under_article_86).
test(input_positive) :-
    sme_simplified_compliance_status([attribute(is_an_sme_including_a_start_up, true), attribute(has_partner_or_linked_enterprises, false)], date(2026, 8, 2), may_comply_in_a_simplified_manner, _).
test(input_near_miss_gets_input_problems) :-
    subject_status(input_unsure_for_a_crisp_key, input_problems([wrong_type(has_partner_or_linked_enterprises)])).

test(bias_provider_near_miss_is_not_permitted, fail) :-
    subject_status(bias_provider_without_records_of_reasons, bias_processing_permitted).
test(bias_date_near_miss_is_not_permitted, fail) :-
    subject_status(bias_provider_on_twenty_sixth_july, bias_processing_permitted).
test(bias_other_near_miss_is_not_permitted, fail) :-
    subject_status(bias_other_deployer_safeguards_unsure, bias_processing_permitted).
test(sandbox_area_near_miss_is_not_permitted, fail) :-
    subject_status(sandbox_none_of_the_listed_areas, sandbox_processing_permitted).
test(sandbox_law_enforcement_near_miss_is_not_permitted, fail) :-
    subject_status(sandbox_law_enforcement_without_specific_law, sandbox_processing_permitted).
test(sandbox_date_near_miss_is_not_permitted, fail) :-
    subject_status(sandbox_on_first_august, sandbox_processing_permitted).
test(framework_near_miss_is_not_subject_to_a_framework, fail) :-
    subject_status(testing_section_b_without_framework, subject_to_the_member_state_framework).
test(section_b_never_takes_the_article_60_route, fail) :-
    subject_status(testing_section_b_with_framework, real_world_testing_permitted).
test(tacit_approval_near_miss_is_not_permitted, fail) :-
    subject_status(testing_tacit_approval_not_in_national_law, real_world_testing_permitted).
test(duration_near_miss_is_not_permitted, fail) :-
    subject_status(testing_extension_not_notified, real_world_testing_permitted).
test(duration_longer_is_not_permitted, fail) :-
    subject_status(testing_longer_than_twelve_months, real_world_testing_permitted).
test(law_enforcement_near_miss_is_not_permitted, fail) :-
    subject_status(testing_law_enforcement_with_negative_effect, real_world_testing_permitted).
test(deployers_near_miss_is_not_permitted, fail) :-
    subject_status(testing_deployers_without_agreement, real_world_testing_permitted).
test(consent_near_miss_does_not_meet, fail) :-
    subject_status(consent_without_copy, consent_meets_article_61).
test(consent_unsure_is_never_decided, fail) :-
    subject_status(consent_freely_given_unsure, consent_meets_article_61).
test(sme_near_miss_may_not_simplify, fail) :-
    subject_status(sme_with_linked_enterprises, may_comply_in_a_simplified_manner).
test(non_sme_may_not_simplify, fail) :-
    subject_status(sme_not_an_sme, may_comply_in_a_simplified_manner).
test(explanation_point_2_near_miss_has_no_right, fail) :-
    subject_status(explanation_point_2_system, right_to_explanation_under_article_86).
test(explanation_exception_near_miss_has_no_right, fail) :-
    subject_status(explanation_exception_in_union_or_national_law, right_to_explanation_under_article_86).
test(explanation_otherwise_provided_near_miss_has_no_right, fail) :-
    subject_status(explanation_otherwise_provided_for, right_to_explanation_under_article_86).
test(explanation_date_near_miss_has_no_right, fail) :-
    subject_status(explanation_on_first_august, right_to_explanation_under_article_86).
test(input_near_miss_gets_no_verdict, fail) :-
    subject_status(input_unsure_for_a_crisp_key, may_comply_in_a_simplified_manner).
test(impossible_date_gets_no_verdict, fail) :-
    subject_status(input_impossible_date, may_comply_in_a_simplified_manner).

cp_test_names([the_status_table_has_a_near_miss_atom, the_near_miss_atoms_are_table_atoms, bias_provider_positive, bias_provider_near_miss_gets_not_permitted, bias_date_positive, bias_date_near_miss_gets_not_applicable, bias_other_positive, bias_other_near_miss_goes_to_a_lawyer, sandbox_area_positive, sandbox_area_near_miss_gets_not_permitted, sandbox_law_enforcement_positive, sandbox_law_enforcement_near_miss_gets_not_permitted, sandbox_date_near_miss_gets_not_applicable, framework_positive, framework_near_miss_gets_not_provided_for, tacit_approval_positive, tacit_approval_near_miss_gets_not_permitted, duration_positive, duration_near_miss_gets_not_permitted, law_enforcement_positive, law_enforcement_near_miss_gets_not_permitted, deployers_positive, deployers_near_miss_gets_not_permitted, consent_positive, consent_near_miss_gets_does_not_meet, sme_positive, sme_near_miss_gets_no_simplified_compliance, explanation_positive, explanation_point_2_near_miss_gets_no_right, input_positive, input_near_miss_gets_input_problems]).
cp_test_fail_names([bias_provider_near_miss_is_not_permitted, bias_date_near_miss_is_not_permitted, bias_other_near_miss_is_not_permitted, sandbox_area_near_miss_is_not_permitted, sandbox_law_enforcement_near_miss_is_not_permitted, sandbox_date_near_miss_is_not_permitted, framework_near_miss_is_not_subject_to_a_framework, section_b_never_takes_the_article_60_route, tacit_approval_near_miss_is_not_permitted, duration_near_miss_is_not_permitted, duration_longer_is_not_permitted, law_enforcement_near_miss_is_not_permitted, deployers_near_miss_is_not_permitted, consent_near_miss_does_not_meet, consent_unsure_is_never_decided, sme_near_miss_may_not_simplify, non_sme_may_not_simplify, explanation_point_2_near_miss_has_no_right, explanation_exception_near_miss_has_no_right, explanation_otherwise_provided_near_miss_has_no_right, explanation_date_near_miss_has_no_right, input_near_miss_gets_no_verdict, impossible_date_gets_no_verdict]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
