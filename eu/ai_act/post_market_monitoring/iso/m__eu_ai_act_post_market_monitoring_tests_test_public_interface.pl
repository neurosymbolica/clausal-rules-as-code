% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_ai_act_post_market_monitoring_tests_test_public_interface, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_lists_extra, [clausal_msort/2]).
:- use_module(m__eu_ai_act_post_market_monitoring_post_market_monitoring, [post_market_monitoring_duty_status/4, post_market_monitoring_integration_status/3, decide_post_market_monitoring/2, post_market_monitoring_status/2, post_market_monitoring_checklist/2, post_market_monitoring_decision_resolvable/1, post_market_monitoring_status_values/1]).
:- use_module(m__eu_ai_act_post_market_monitoring_kernel, [post_market_monitoring_input_problems/2]).
:- use_module(m__eu_ai_act_post_market_monitoring_queries, [post_market_monitoring_profile_keys/1, post_market_monitoring_what_if/4]).
:- use_module(m__eu_ai_act_post_market_monitoring_fixtures, [post_market_monitoring_subject/1, post_market_monitoring_profile_for/2, post_market_monitoring_assess/2]).

expected(before_the_annex_iii_date, not_applicable_on_date, [cite(eu_reg_2024_1689_art_113_c), cite(eu_reg_2024_1689_art_113_c_i), cite(eu_reg_2024_1689_art_113_c_ii)]).
expected(annex_iii_system_on_its_first_day, duty_applies, [cite(eu_reg_2024_1689_art_72_1), cite(eu_reg_2024_1689_art_72_3)]).
expected(annex_i_only_system_the_day_before, not_applicable_on_date, [cite(eu_reg_2024_1689_art_113_c), cite(eu_reg_2024_1689_art_113_c_ii)]).
expected(annex_i_only_system_on_its_first_day, duty_applies, [cite(eu_reg_2024_1689_art_72_1), cite(eu_reg_2024_1689_art_72_3)]).
expected(actor_not_a_provider, not_a_provider, [cite(eu_reg_2024_1689_art_72_1)]).
expected(provider_of_an_annex_iii_system, duty_applies, [cite(eu_reg_2024_1689_art_72_1), cite(eu_reg_2024_1689_art_72_3)]).
expected(system_not_high_risk, not_a_high_risk_ai_system, [cite(eu_reg_2024_1689_art_72_1)]).
expected(annex_x_component_the_day_before_the_deadline, compliance_required_by_31_december_2030, [cite(eu_reg_2024_1689_art_111_1), cite(eu_reg_2024_1689_art_72_1), cite(eu_reg_2024_1689_art_72_3)]).
expected(annex_x_component_on_the_deadline, duty_applies, [cite(eu_reg_2024_1689_art_72_1), cite(eu_reg_2024_1689_art_72_3)]).
expected(annex_x_component_for_public_authorities, compliance_required_by_31_december_2030, [cite(eu_reg_2024_1689_art_111_1), cite(eu_reg_2024_1689_art_72_1), cite(eu_reg_2024_1689_art_72_3)]).
expected(existing_system_without_changes, existing_system_without_significant_changes_not_covered, [cite(eu_reg_2024_1689_art_111_2)]).
expected(existing_system_with_significant_changes, duty_applies, [cite(eu_reg_2024_1689_art_72_1), cite(eu_reg_2024_1689_art_72_3)]).
expected(existing_public_authority_system_the_day_before_the_deadline, compliance_required_by_2_august_2030, [cite(eu_reg_2024_1689_art_111_2), cite(eu_reg_2024_1689_art_72_1), cite(eu_reg_2024_1689_art_72_3)]).
expected(existing_public_authority_system_on_the_deadline, duty_applies, [cite(eu_reg_2024_1689_art_72_1), cite(eu_reg_2024_1689_art_72_3)]).
expected(existing_changed_public_authority_system, duty_applies, [cite(eu_reg_2024_1689_art_72_1), cite(eu_reg_2024_1689_art_72_3)]).
expected(missing_provider, indeterminate([provider_of_the_system]), []).
expected(referral_on_significant_changes, needs_legal_review(open_textured(significant_changes_in_design_as_from_the_chapter_iii_date, cite(eu_reg_2024_1689_art_111_2)), [inputs_relied_on([significant_changes_in_design_as_from_the_chapter_iii_date - unsure, intended_to_be_used_by_public_authorities - false])]), []).
expected(missing_fact_before_referral, indeterminate([intended_to_be_used_by_public_authorities]), []).
expected(integration_through_annex_i_legislation, integration_available, [cite(eu_reg_2024_1689_art_72_4)]).
expected(integration_without_equivalent_protection, integration_not_available, [cite(eu_reg_2024_1689_art_72_4)]).
expected(integration_for_covered_annex_iii_system, integration_available, [cite(eu_reg_2024_1689_art_72_4)]).
expected(integration_for_financial_institution, integration_available, [cite(eu_reg_2024_1689_art_72_4)]).
expected(integration_for_financial_institution_without_plan, integration_not_available, [cite(eu_reg_2024_1689_art_72_4)]).
expected(integration_without_legislation_route, integration_not_available, [cite(eu_reg_2024_1689_art_72_4)]).
expected(integration_actor_not_a_provider, not_a_provider, [cite(eu_reg_2024_1689_art_72_4)]).
expected(integration_system_not_high_risk, not_a_high_risk_ai_system, [cite(eu_reg_2024_1689_art_72_4)]).
expected(integration_referral_on_equivalence, needs_legal_review(open_textured(integration_achieves_an_equivalent_level_of_protection, cite(eu_reg_2024_1689_art_72_4)), [inputs_relied_on([integration_achieves_an_equivalent_level_of_protection - unsure])]), []).
expected(input_duplicate_key, input_problems([duplicate_key(provider_of_the_system)]), []).
expected(input_crisp_key_given_unsure, input_problems([wrong_type(system_is_a_high_risk_ai_system_listed_in_annex_iii)]), []).
expected(input_unknown_key_given_twice, input_problems([unknown_key(colour)]), []).
expected(input_impossible_date, input_problems([wrong_type(assessment_date)]), []).
expected(input_last_day_of_february, not_applicable_on_date, [cite(eu_reg_2024_1689_art_113_c), cite(eu_reg_2024_1689_art_113_c_i), cite(eu_reg_2024_1689_art_113_c_ii)]).
expected(input_unknown_key_and_impossible_date, input_problems([unknown_key(colour), wrong_type(assessment_date)]), []).
expected(input_not_an_attribute_list, input_problems([wrong_type(profile)]), []).

actual_answers(Answers) :-
    findall(Subject - Status - SortedCitations, (post_market_monitoring_subject(Subject), post_market_monitoring_assess(Subject, post_market_monitoring_verdict(Status, Citations)), clausal_msort(Citations, SortedCitations)), Found),
    clausal_msort(Found, Answers).

expected_answers(Answers) :-
    findall(Subject - Status - SortedCitations, (expected(Subject, Status, Citations), clausal_msort(Citations, SortedCitations)), Found),
    clausal_msort(Found, Answers).

all_have_a_checklist([]).
all_have_a_checklist([Subject|Subjects]) :-
    post_market_monitoring_profile_for(Subject, Request),
    post_market_monitoring_checklist(Request, [_FirstItem|_OtherItems]),
    all_have_a_checklist(Subjects).

all_resolvable([]).
all_resolvable([Subject|Subjects]) :-
    post_market_monitoring_profile_for(Subject, Request),
    post_market_monitoring_decision_resolvable(Request),
    all_resolvable(Subjects).

assessed_status(Subject, Status) :-
    post_market_monitoring_assess(Subject, post_market_monitoring_verdict(Status, _Citations)).

with_provenance(needs_legal_review(Reason, [InputsRelied]), Clause, Citations, needs_legal_review(Reason, [InputsRelied, provenance(Clause, Citations)])).

test(every_subject_resolves_to_its_expected_verdict_exactly_once) :-
    actual_answers(Actual),
    expected_answers(Expected),
    Actual == Expected.
test(every_subject_has_an_expected_verdict) :-
    findall(Subject, post_market_monitoring_subject(Subject), Subjects),
    findall(Subject, expected(Subject, _, _), ExpectedSubjects),
    clausal_msort(Subjects, SortedSubjects),
    clausal_msort(ExpectedSubjects, SortedSubjects).
test(every_subject_has_a_non_empty_checklist) :-
    findall(Subject, post_market_monitoring_subject(Subject), Subjects),
    all_have_a_checklist(Subjects).
test(every_subject_is_resolvable) :-
    findall(Subject, post_market_monitoring_subject(Subject), Subjects),
    all_resolvable(Subjects).
test(a_final_status_is_in_the_status_vocabulary) :-
    assessed_status(provider_of_an_annex_iii_system, Status),
    post_market_monitoring_status_values(StatusValues),
    member(Status, StatusValues).
test(the_day_before_the_annex_iii_date_is_not_applicable) :-
    assessed_status(before_the_annex_iii_date, not_applicable_on_date).
test(the_annex_iii_date_itself_gives_the_duty) :-
    assessed_status(annex_iii_system_on_its_first_day, duty_applies).
test(an_annex_i_only_system_waits_until_2_august_2028) :-
    assessed_status(annex_i_only_system_the_day_before, not_applicable_on_date),
    assessed_status(annex_i_only_system_on_its_first_day, duty_applies).
test(the_provider_flip_changes_the_answer) :-
    assessed_status(actor_not_a_provider, not_a_provider),
    assessed_status(provider_of_an_annex_iii_system, duty_applies).
test(a_system_that_is_not_high_risk_has_no_duty) :-
    assessed_status(system_not_high_risk, not_a_high_risk_ai_system).
test(an_annex_x_component_is_due_on_31_december_2030) :-
    assessed_status(annex_x_component_the_day_before_the_deadline, compliance_required_by_31_december_2030),
    assessed_status(annex_x_component_on_the_deadline, duty_applies).
test(in_any_case_does_not_reach_an_annex_x_component) :-
    assessed_status(annex_x_component_for_public_authorities, compliance_required_by_31_december_2030).
test(a_significant_change_brings_an_existing_system_in) :-
    assessed_status(existing_system_without_changes, existing_system_without_significant_changes_not_covered),
    assessed_status(existing_system_with_significant_changes, duty_applies).
test(a_public_authority_system_is_due_on_2_august_2030) :-
    assessed_status(existing_public_authority_system_the_day_before_the_deadline, compliance_required_by_2_august_2030),
    assessed_status(existing_public_authority_system_on_the_deadline, duty_applies).
test(a_changed_public_authority_system_has_the_duty_now) :-
    assessed_status(existing_changed_public_authority_system, duty_applies).
test(a_missing_provider_is_asked_for) :-
    post_market_monitoring_profile_for(missing_provider, duty(Profile, AssessmentDate)),
    post_market_monitoring_duty_status(Profile, AssessmentDate, Result, Citations),
    Result == indeterminate([provider_of_the_system]),
    Citations == [].
test(an_unsure_significant_change_is_referred) :-
    post_market_monitoring_profile_for(referral_on_significant_changes, duty(Profile, AssessmentDate)),
    post_market_monitoring_duty_status(Profile, AssessmentDate, Result, []),
    Result == needs_legal_review(open_textured(significant_changes_in_design_as_from_the_chapter_iii_date, cite(eu_reg_2024_1689_art_111_2)), [inputs_relied_on([significant_changes_in_design_as_from_the_chapter_iii_date - unsure, intended_to_be_used_by_public_authorities - false])]).
test(a_duty_referral_with_optional_provenance_keeps_its_scored_part) :-
    post_market_monitoring_profile_for(referral_on_significant_changes, duty(Profile, AssessmentDate)),
    post_market_monitoring_duty_status(Profile, AssessmentDate, Result, []),
    with_provenance(Result, duty_existing_system_step, [cite(eu_reg_2024_1689_art_111_2)], WithProvenance),
    WithProvenance == needs_legal_review(open_textured(significant_changes_in_design_as_from_the_chapter_iii_date, cite(eu_reg_2024_1689_art_111_2)), [inputs_relied_on([significant_changes_in_design_as_from_the_chapter_iii_date - unsure, intended_to_be_used_by_public_authorities - false]), provenance(duty_existing_system_step, [cite(eu_reg_2024_1689_art_111_2)])]).
test(a_missing_fact_is_named_before_the_referral) :-
    assessed_status(missing_fact_before_referral, indeterminate([intended_to_be_used_by_public_authorities])).
test(the_duty_query_yields_one_solution) :-
    post_market_monitoring_profile_for(missing_fact_before_referral, duty(Profile, AssessmentDate)),
    findall(Result - Citations, post_market_monitoring_duty_status(Profile, AssessmentDate, Result, Citations), Answers),
    length(Answers, 1).
test(equivalent_protection_decides_the_choice) :-
    assessed_status(integration_through_annex_i_legislation, integration_available),
    assessed_status(integration_without_equivalent_protection, integration_not_available).
test(a_covered_annex_iii_system_has_the_choice) :-
    assessed_status(integration_for_covered_annex_iii_system, integration_available).
test(a_financial_institution_needs_an_existing_system_and_plan) :-
    assessed_status(integration_for_financial_institution, integration_available),
    assessed_status(integration_for_financial_institution_without_plan, integration_not_available).
test(no_legislation_route_closes_the_choice) :-
    assessed_status(integration_without_legislation_route, integration_not_available).
test(the_integration_query_answers_directly) :-
    post_market_monitoring_profile_for(integration_actor_not_a_provider, integration(Profile)),
    post_market_monitoring_integration_status(Profile, not_a_provider, [cite(eu_reg_2024_1689_art_72_4)]).
test(the_integration_query_yields_one_solution) :-
    post_market_monitoring_profile_for(integration_referral_on_equivalence, integration(Profile)),
    findall(Result - Citations, post_market_monitoring_integration_status(Profile, Result, Citations), Answers),
    length(Answers, 1).
test(an_unsure_equivalence_is_referred) :-
    post_market_monitoring_profile_for(integration_referral_on_equivalence, integration(Profile)),
    post_market_monitoring_integration_status(Profile, Result, []),
    Result == needs_legal_review(open_textured(integration_achieves_an_equivalent_level_of_protection, cite(eu_reg_2024_1689_art_72_4)), [inputs_relied_on([integration_achieves_an_equivalent_level_of_protection - unsure])]).
test(an_integration_referral_with_optional_provenance_keeps_its_scored_part) :-
    post_market_monitoring_profile_for(integration_referral_on_equivalence, integration(Profile)),
    post_market_monitoring_integration_status(Profile, Result, []),
    with_provenance(Result, integration_choice_step, [cite(eu_reg_2024_1689_art_72_4)], WithProvenance),
    WithProvenance = needs_legal_review(open_textured(integration_achieves_an_equivalent_level_of_protection, cite(eu_reg_2024_1689_art_72_4)), [inputs_relied_on([integration_achieves_an_equivalent_level_of_protection - unsure]), provenance(Clause, ProvenanceCitations)]),
    Clause == integration_choice_step,
    ProvenanceCitations == [cite(eu_reg_2024_1689_art_72_4)].
test(the_input_check_gives_a_bare_list) :-
    post_market_monitoring_input_problems([attribute(colour, red)], Problems),
    Problems == [unknown_key(colour)].
test(a_well_formed_profile_has_no_problem) :-
    post_market_monitoring_input_problems([attribute(provider_of_the_system, true)], []).
test(an_impossible_date_against_the_last_day_of_february) :-
    assessed_status(input_impossible_date, input_problems([wrong_type(assessment_date)])),
    assessed_status(input_last_day_of_february, not_applicable_on_date).
test(profile_problems_come_before_the_date_problem) :-
    post_market_monitoring_duty_status([attribute(colour, red)], date(2027, 2, 30), Result, Citations),
    Result == input_problems([unknown_key(colour), wrong_type(assessment_date)]),
    Citations == [].
test(the_facade_status_projection) :-
    post_market_monitoring_profile_for(provider_of_an_annex_iii_system, Request),
    post_market_monitoring_status(Request, duty_applies),
    decide_post_market_monitoring(Request, post_market_monitoring_verdict(duty_applies, [_|_])).
test(what_if_the_actor_were_not_the_provider) :-
    post_market_monitoring_profile_for(provider_of_an_annex_iii_system, Request),
    post_market_monitoring_what_if(Request, provider_of_the_system, false, not_a_provider).
test(what_if_the_system_were_not_listed_in_annex_iii) :-
    post_market_monitoring_profile_for(provider_of_an_annex_iii_system, Request),
    post_market_monitoring_what_if(Request, system_is_a_high_risk_ai_system_listed_in_annex_iii, false, not_a_high_risk_ai_system).
test(what_if_protection_were_equivalent) :-
    post_market_monitoring_profile_for(integration_without_equivalent_protection, Request),
    post_market_monitoring_what_if(Request, integration_achieves_an_equivalent_level_of_protection, true, integration_available).
test(the_profile_schema_has_eleven_keys) :-
    post_market_monitoring_profile_keys(Keys),
    length(Keys, 11).
test(the_checklist_carries_a_cite_per_item) :-
    post_market_monitoring_profile_for(integration_through_annex_i_legislation, Request),
    post_market_monitoring_checklist(Request, Items),
    member(item(equivalent_level_of_protection, met, cite(eu_reg_2024_1689_art_72_4)), Items).

test(the_day_before_the_annex_iii_date_is_not_duty_applies, fail) :-
    assessed_status(before_the_annex_iii_date, duty_applies).
test(an_annex_i_only_system_on_its_first_day_is_not_waiting, fail) :-
    assessed_status(annex_i_only_system_on_its_first_day, not_applicable_on_date).
test(the_provider_is_not_answered_not_a_provider, fail) :-
    assessed_status(provider_of_an_annex_iii_system, not_a_provider).
test(a_system_that_is_not_high_risk_is_not_duty_applies, fail) :-
    assessed_status(system_not_high_risk, duty_applies).
test(an_annex_x_component_on_the_deadline_is_no_longer_transitional, fail) :-
    assessed_status(annex_x_component_on_the_deadline, compliance_required_by_31_december_2030).
test(an_annex_x_component_for_public_authorities_is_not_due_in_august, fail) :-
    assessed_status(annex_x_component_for_public_authorities, compliance_required_by_2_august_2030).
test(a_changed_existing_system_is_covered, fail) :-
    assessed_status(existing_system_with_significant_changes, existing_system_without_significant_changes_not_covered).
test(a_public_authority_system_on_the_deadline_is_no_longer_transitional, fail) :-
    assessed_status(existing_public_authority_system_on_the_deadline, compliance_required_by_2_august_2030).
test(without_equivalent_protection_the_choice_is_closed, fail) :-
    assessed_status(integration_without_equivalent_protection, integration_available).
test(a_financial_institution_without_a_plan_has_no_choice, fail) :-
    assessed_status(integration_for_financial_institution_without_plan, integration_available).
test(a_final_answer_has_no_referral_to_carry_provenance, fail) :-
    post_market_monitoring_profile_for(integration_through_annex_i_legislation, integration(Profile)),
    post_market_monitoring_integration_status(Profile, Result, _),
    with_provenance(Result, integration_choice_step, [cite(eu_reg_2024_1689_art_72_4)], _).
test(the_last_day_of_february_is_not_an_input_problem, fail) :-
    assessed_status(input_last_day_of_february, input_problems(_)).

cp_test_names([every_subject_resolves_to_its_expected_verdict_exactly_once, every_subject_has_an_expected_verdict, every_subject_has_a_non_empty_checklist, every_subject_is_resolvable, a_final_status_is_in_the_status_vocabulary, the_day_before_the_annex_iii_date_is_not_applicable, the_annex_iii_date_itself_gives_the_duty, an_annex_i_only_system_waits_until_2_august_2028, the_provider_flip_changes_the_answer, a_system_that_is_not_high_risk_has_no_duty, an_annex_x_component_is_due_on_31_december_2030, in_any_case_does_not_reach_an_annex_x_component, a_significant_change_brings_an_existing_system_in, a_public_authority_system_is_due_on_2_august_2030, a_changed_public_authority_system_has_the_duty_now, a_missing_provider_is_asked_for, an_unsure_significant_change_is_referred, a_duty_referral_with_optional_provenance_keeps_its_scored_part, a_missing_fact_is_named_before_the_referral, the_duty_query_yields_one_solution, equivalent_protection_decides_the_choice, a_covered_annex_iii_system_has_the_choice, a_financial_institution_needs_an_existing_system_and_plan, no_legislation_route_closes_the_choice, the_integration_query_answers_directly, the_integration_query_yields_one_solution, an_unsure_equivalence_is_referred, an_integration_referral_with_optional_provenance_keeps_its_scored_part, the_input_check_gives_a_bare_list, a_well_formed_profile_has_no_problem, an_impossible_date_against_the_last_day_of_february, profile_problems_come_before_the_date_problem, the_facade_status_projection, what_if_the_actor_were_not_the_provider, what_if_the_system_were_not_listed_in_annex_iii, what_if_protection_were_equivalent, the_profile_schema_has_eleven_keys, the_checklist_carries_a_cite_per_item]).
cp_test_fail_names([the_day_before_the_annex_iii_date_is_not_duty_applies, an_annex_i_only_system_on_its_first_day_is_not_waiting, the_provider_is_not_answered_not_a_provider, a_system_that_is_not_high_risk_is_not_duty_applies, an_annex_x_component_on_the_deadline_is_no_longer_transitional, an_annex_x_component_for_public_authorities_is_not_due_in_august, a_changed_existing_system_is_covered, a_public_authority_system_on_the_deadline_is_no_longer_transitional, without_equivalent_protection_the_choice_is_closed, a_financial_institution_without_a_plan_has_no_choice, a_final_answer_has_no_referral_to_carry_provenance, the_last_day_of_february_is_not_an_input_problem]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
