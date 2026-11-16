% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_ai_act_deployer_duties_fria_tests_test_output_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_ai_act_deployer_duties_fria_deployer_duties_fria, [deployer_obligation_status/5, log_retention_period_status/5, decide_deployer_duties_fria/2]).
:- use_module(m__eu_ai_act_deployer_duties_fria_fixtures, [deployer_duties_fria_profile_for/2]).

subject_answer(Subject, Result, SortedCitations) :-
    deployer_duties_fria_profile_for(Subject, Request),
    findall(Answer - Citations, decide_deployer_duties_fria(Request, deployer_duties_fria_verdict(Answer, Citations)), [Result - OnlyCitations]),
    sort(OnlyCitations, SortedCitations).

test(on_2_december_2027_log_retention_applies) :-
    subject_answer(first_chapter_iii_day, obligation_applies, [cite(eu_reg_2024_1689_art_26_6)]).
test(on_1_december_2027_nothing_applies) :-
    subject_answer(day_before_first_chapter_iii_day, not_applicable_on_date, [cite(eu_reg_2024_1689_art_113_c), cite(eu_reg_2024_1689_art_113_c_i), cite(eu_reg_2024_1689_art_113_c_ii)]).
test(an_annex_i_system_on_2_august_2028) :-
    subject_answer(product_legislation_system_on_its_date, obligation_applies, [cite(eu_reg_2024_1689_art_26_6)]).
test(an_annex_i_system_on_1_august_2028) :-
    subject_answer(product_legislation_system_day_before, not_applicable_on_date, [cite(eu_reg_2024_1689_art_113_c), cite(eu_reg_2024_1689_art_113_c_ii)]).
test(the_actor_that_is_not_the_deployer) :-
    subject_answer(actor_not_the_deployer, not_a_deployer, [cite(eu_reg_2024_1689_art_3_4)]).
test(a_system_that_is_not_high_risk) :-
    subject_answer(system_not_high_risk, not_a_high_risk_ai_system, [cite(eu_reg_2024_1689_art_26_6)]).
test(no_logs_under_control) :-
    subject_answer(logs_not_under_control, obligation_does_not_apply, [cite(eu_reg_2024_1689_art_26_6)]).
test(the_employer_informs_the_workers) :-
    subject_answer(employer_informs_workers, obligation_applies, [cite(eu_reg_2024_1689_art_26_7)]).
test(a_deployer_that_is_not_an_employer) :-
    subject_answer(deployer_not_an_employer, obligation_does_not_apply, [cite(eu_reg_2024_1689_art_26_7)]).
test(natural_persons_are_informed) :-
    subject_answer(decisions_about_natural_persons, obligation_applies, [cite(eu_reg_2024_1689_art_26_11)]).
test(law_enforcement_takes_the_directive_rule) :-
    subject_answer(law_enforcement_decisions, information_under_article_13_of_directive_2016_680, [cite(eu_reg_2024_1689_art_26_11)]).
test(no_decisions_about_natural_persons) :-
    subject_answer(no_decisions_about_natural_persons, obligation_does_not_apply, [cite(eu_reg_2024_1689_art_26_11)]).
test(a_public_body_performs_the_assessment) :-
    subject_answer(public_body_impact_assessment, obligation_applies, [cite(eu_reg_2024_1689_art_27_1), cite(eu_reg_2024_1689_art_27_2)]).
test(critical_infrastructure_is_excepted) :-
    subject_answer(critical_infrastructure_impact_assessment, obligation_does_not_apply, [cite(eu_reg_2024_1689_art_27_1)]).
test(a_credit_scoring_deployer_performs_the_assessment) :-
    subject_answer(credit_scoring_impact_assessment, obligation_applies, [cite(eu_reg_2024_1689_art_27_1), cite(eu_reg_2024_1689_art_27_2)]).
test(the_results_are_notified) :-
    subject_answer(public_body_notification, obligation_applies, [cite(eu_reg_2024_1689_art_27_3)]).
test(an_exempt_deployer_does_not_notify) :-
    subject_answer(exempt_notification, obligation_does_not_apply, [cite(eu_reg_2024_1689_art_27_1), cite(eu_reg_2024_1689_art_27_3)]).
test(an_annex_x_component_on_30_december_2030) :-
    subject_answer(annex_x_component_day_before_compliance, compliance_required_by_31_december_2030, [cite(eu_reg_2024_1689_art_111_1), cite(eu_reg_2024_1689_art_26_6)]).
test(an_annex_x_component_on_31_december_2030) :-
    subject_answer(annex_x_component_on_compliance_day, obligation_applies, [cite(eu_reg_2024_1689_art_26_6)]).
test(an_unchanged_existing_system_is_not_covered) :-
    subject_answer(existing_system_unchanged, existing_system_without_significant_changes_not_covered, [cite(eu_reg_2024_1689_art_111_2)]).
test(a_significantly_changed_existing_system_is_covered) :-
    subject_answer(existing_system_significantly_changed, obligation_applies, [cite(eu_reg_2024_1689_art_26_6)]).
test(a_public_authority_system_on_1_august_2030) :-
    subject_answer(public_authority_system_day_before, compliance_required_by_2_august_2030, [cite(eu_reg_2024_1689_art_111_2), cite(eu_reg_2024_1689_art_26_6)]).
test(a_public_authority_system_on_2_august_2030) :-
    subject_answer(public_authority_system_on_compliance_day, obligation_applies, [cite(eu_reg_2024_1689_art_26_6)]).
test(six_months_meet_the_minimum) :-
    subject_answer(retention_of_six_months, retention_period_of_at_least_six_months, [cite(eu_reg_2024_1689_art_26_6)]).
test(five_months_fall_short) :-
    subject_answer(retention_of_five_months, retention_period_shorter_than_six_months, [cite(eu_reg_2024_1689_art_26_6)]).
test(no_months_fall_short) :-
    subject_answer(retention_of_no_months, retention_period_shorter_than_six_months, [cite(eu_reg_2024_1689_art_26_6)]).
test(another_law_sets_the_period) :-
    subject_answer(retention_set_by_other_law, period_set_by_other_union_or_national_law, [cite(eu_reg_2024_1689_art_26_6)]).
test(the_retention_flip_point_is_six_months) :-
    deployer_duties_fria_profile_for(retention_of_six_months, log_retention_period_request(Profile, _, AssessmentDate)),
    findall(RetentionMonths, (between(0, 12, RetentionMonths), log_retention_period_status(Profile, RetentionMonths, AssessmentDate, retention_period_of_at_least_six_months, _)), MeetingMonths),
    MeetingMonths == [6, 7, 8, 9, 10, 11, 12].
test(the_empty_profile_names_the_deployer_key) :-
    subject_answer(empty_profile, indeterminate([deployer_of_the_system]), []).
test(the_point_2_key_is_asked_of_a_credit_scoring_deployer) :-
    subject_answer(missing_critical_infrastructure_key, indeterminate([system_listed_under_point_2_of_annex_iii]), []).
test(an_unsure_public_body_is_referred_with_its_pairs) :-
    subject_answer(unsure_public_body, Result, []),
    Result == needs_legal_review(open_textured(body_governed_by_public_law, cite(eu_reg_2024_1689_art_27_1)), [inputs_relied_on([makes_or_assists_in_making_decisions_related_to_natural_persons - true, body_governed_by_public_law - unsure, private_entity_providing_public_services - false, significant_changes_in_design_as_from_the_chapter_iii_date - false, intended_to_be_used_by_public_authorities - false])]).
test(input_problem_subjects_read_out) :-
    subject_answer(negative_retention_period, input_problems([wrong_type(retention_months)]), []),
    subject_answer(unknown_profile_key, input_problems([unknown_key(colour)]), []),
    subject_answer(impossible_assessment_date, input_problems([wrong_type(assessment_date)]), []).
test(the_obligation_atoms_are_never_enumerated) :-
    findall(Obligation - Result, deployer_obligation_status([], Obligation, date(2028, 1, 1), Result, _), Answers),
    Answers = [_ - OnlyResult],
    OnlyResult == input_problems([wrong_type(obligation)]).

cp_test_names([on_2_december_2027_log_retention_applies, on_1_december_2027_nothing_applies, an_annex_i_system_on_2_august_2028, an_annex_i_system_on_1_august_2028, the_actor_that_is_not_the_deployer, a_system_that_is_not_high_risk, no_logs_under_control, the_employer_informs_the_workers, a_deployer_that_is_not_an_employer, natural_persons_are_informed, law_enforcement_takes_the_directive_rule, no_decisions_about_natural_persons, a_public_body_performs_the_assessment, critical_infrastructure_is_excepted, a_credit_scoring_deployer_performs_the_assessment, the_results_are_notified, an_exempt_deployer_does_not_notify, an_annex_x_component_on_30_december_2030, an_annex_x_component_on_31_december_2030, an_unchanged_existing_system_is_not_covered, a_significantly_changed_existing_system_is_covered, a_public_authority_system_on_1_august_2030, a_public_authority_system_on_2_august_2030, six_months_meet_the_minimum, five_months_fall_short, no_months_fall_short, another_law_sets_the_period, the_retention_flip_point_is_six_months, the_empty_profile_names_the_deployer_key, the_point_2_key_is_asked_of_a_credit_scoring_deployer, an_unsure_public_body_is_referred_with_its_pairs, input_problem_subjects_read_out, the_obligation_atoms_are_never_enumerated]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
