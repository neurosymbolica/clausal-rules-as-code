% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_ai_act_deployer_duties_fria_tests_test_public_interface, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_lists, [msort/2]).
:- use_module(m__eu_ai_act_deployer_duties_fria_deployer_duties_fria, [decide_deployer_duties_fria/2, deployer_duties_fria_status/2, deployer_duties_fria_checklist/2, deployer_duties_fria_decision_resolvable/1, deployer_duties_fria_status_values/1, deployer_obligation_status/5, log_retention_period_status/5, provenance/2]).
:- use_module(m__eu_ai_act_deployer_duties_fria_fixtures, [deployer_duties_fria_subject/1, deployer_duties_fria_profile_for/2, deployer_duties_fria_assess/2]).

expected_verdict(log_retention_applies, obligation_applies, [cite(eu_reg_2024_1689_art_26_6)]).
expected_verdict(first_chapter_iii_day, obligation_applies, [cite(eu_reg_2024_1689_art_26_6)]).
expected_verdict(day_before_first_chapter_iii_day, not_applicable_on_date, [cite(eu_reg_2024_1689_art_113_c), cite(eu_reg_2024_1689_art_113_c_i), cite(eu_reg_2024_1689_art_113_c_ii)]).
expected_verdict(actor_not_the_deployer, not_a_deployer, [cite(eu_reg_2024_1689_art_3_4)]).
expected_verdict(system_not_high_risk, not_a_high_risk_ai_system, [cite(eu_reg_2024_1689_art_26_6)]).
expected_verdict(product_legislation_system_on_its_date, obligation_applies, [cite(eu_reg_2024_1689_art_26_6)]).
expected_verdict(product_legislation_system_day_before, not_applicable_on_date, [cite(eu_reg_2024_1689_art_113_c), cite(eu_reg_2024_1689_art_113_c_ii)]).
expected_verdict(logs_not_under_control, obligation_does_not_apply, [cite(eu_reg_2024_1689_art_26_6)]).
expected_verdict(employer_informs_workers, obligation_applies, [cite(eu_reg_2024_1689_art_26_7)]).
expected_verdict(deployer_not_an_employer, obligation_does_not_apply, [cite(eu_reg_2024_1689_art_26_7)]).
expected_verdict(decisions_about_natural_persons, obligation_applies, [cite(eu_reg_2024_1689_art_26_11)]).
expected_verdict(law_enforcement_decisions, information_under_article_13_of_directive_2016_680, [cite(eu_reg_2024_1689_art_26_11)]).
expected_verdict(no_decisions_about_natural_persons, obligation_does_not_apply, [cite(eu_reg_2024_1689_art_26_11)]).
expected_verdict(public_body_impact_assessment, obligation_applies, [cite(eu_reg_2024_1689_art_27_1), cite(eu_reg_2024_1689_art_27_2)]).
expected_verdict(critical_infrastructure_impact_assessment, obligation_does_not_apply, [cite(eu_reg_2024_1689_art_27_1)]).
expected_verdict(credit_scoring_impact_assessment, obligation_applies, [cite(eu_reg_2024_1689_art_27_1), cite(eu_reg_2024_1689_art_27_2)]).
expected_verdict(missing_critical_infrastructure_key, indeterminate([system_listed_under_point_2_of_annex_iii]), []).
expected_verdict(unsure_public_body, needs_legal_review(open_textured(body_governed_by_public_law, cite(eu_reg_2024_1689_art_27_1)), [inputs_relied_on([makes_or_assists_in_making_decisions_related_to_natural_persons - true, body_governed_by_public_law - unsure, private_entity_providing_public_services - false, significant_changes_in_design_as_from_the_chapter_iii_date - false, intended_to_be_used_by_public_authorities - false])]), []).
expected_verdict(public_body_notification, obligation_applies, [cite(eu_reg_2024_1689_art_27_3)]).
expected_verdict(exempt_notification, obligation_does_not_apply, [cite(eu_reg_2024_1689_art_27_1), cite(eu_reg_2024_1689_art_27_3)]).
expected_verdict(annex_x_component_day_before_compliance, compliance_required_by_31_december_2030, [cite(eu_reg_2024_1689_art_111_1), cite(eu_reg_2024_1689_art_26_6)]).
expected_verdict(annex_x_component_on_compliance_day, obligation_applies, [cite(eu_reg_2024_1689_art_26_6)]).
expected_verdict(existing_system_unchanged, existing_system_without_significant_changes_not_covered, [cite(eu_reg_2024_1689_art_111_2)]).
expected_verdict(existing_system_significantly_changed, obligation_applies, [cite(eu_reg_2024_1689_art_26_6)]).
expected_verdict(public_authority_system_day_before, compliance_required_by_2_august_2030, [cite(eu_reg_2024_1689_art_111_2), cite(eu_reg_2024_1689_art_26_6)]).
expected_verdict(public_authority_system_on_compliance_day, obligation_applies, [cite(eu_reg_2024_1689_art_26_6)]).
expected_verdict(retention_of_six_months, retention_period_of_at_least_six_months, [cite(eu_reg_2024_1689_art_26_6)]).
expected_verdict(retention_of_five_months, retention_period_shorter_than_six_months, [cite(eu_reg_2024_1689_art_26_6)]).
expected_verdict(retention_of_no_months, retention_period_shorter_than_six_months, [cite(eu_reg_2024_1689_art_26_6)]).
expected_verdict(retention_set_by_other_law, period_set_by_other_union_or_national_law, [cite(eu_reg_2024_1689_art_26_6)]).
expected_verdict(empty_profile, indeterminate([deployer_of_the_system]), []).
expected_verdict(negative_retention_period, input_problems([wrong_type(retention_months)]), []).
expected_verdict(unknown_profile_key, input_problems([unknown_key(colour)]), []).
expected_verdict(impossible_assessment_date, input_problems([wrong_type(assessment_date)]), []).

near_miss_pair(log_retention_applies, actor_not_the_deployer).
near_miss_pair(first_chapter_iii_day, day_before_first_chapter_iii_day).
near_miss_pair(product_legislation_system_on_its_date, system_not_high_risk).
near_miss_pair(product_legislation_system_on_its_date, product_legislation_system_day_before).
near_miss_pair(log_retention_applies, logs_not_under_control).
near_miss_pair(employer_informs_workers, deployer_not_an_employer).
near_miss_pair(decisions_about_natural_persons, law_enforcement_decisions).
near_miss_pair(decisions_about_natural_persons, no_decisions_about_natural_persons).
near_miss_pair(public_body_impact_assessment, critical_infrastructure_impact_assessment).
near_miss_pair(public_body_impact_assessment, unsure_public_body).
near_miss_pair(credit_scoring_impact_assessment, missing_critical_infrastructure_key).
near_miss_pair(public_body_notification, exempt_notification).
near_miss_pair(annex_x_component_on_compliance_day, annex_x_component_day_before_compliance).
near_miss_pair(existing_system_significantly_changed, existing_system_unchanged).
near_miss_pair(public_authority_system_on_compliance_day, public_authority_system_day_before).
near_miss_pair(retention_of_six_months, retention_of_five_months).
near_miss_pair(retention_of_six_months, retention_set_by_other_law).
near_miss_pair(retention_of_six_months, negative_retention_period).
near_miss_pair(log_retention_applies, unknown_profile_key).
near_miss_pair(log_retention_applies, impossible_assessment_date).
near_miss_pair(log_retention_applies, empty_profile).

verdict_is(Subject, ExpectedResult, ExpectedCitations) :-
    findall(Result - Citations, deployer_duties_fria_assess(Subject, deployer_duties_fria_verdict(Result, Citations)), Answers),
    Answers = [ActualResult - ActualCitations],
    ActualResult == ExpectedResult,
    sort(ActualCitations, SortedActual),
    sort(ExpectedCitations, SortedExpected),
    SortedActual == SortedExpected.

resolves_as_expected(Subject) :-
    expected_verdict(Subject, ExpectedResult, ExpectedCitations),
    verdict_is(Subject, ExpectedResult, ExpectedCitations).

direct_answer(deployer_obligation_request(Profile, Obligation, AssessmentDate), Result, Citations) :-
    deployer_obligation_status(Profile, Obligation, AssessmentDate, Result, Citations).
direct_answer(log_retention_period_request(Profile, RetentionMonths, AssessmentDate), Result, Citations) :-
    log_retention_period_status(Profile, RetentionMonths, AssessmentDate, Result, Citations).

direct_query_matches(Subject) :-
    deployer_duties_fria_profile_for(Subject, Request),
    expected_verdict(Subject, ExpectedResult, ExpectedCitations),
    findall(Result - Citations, direct_answer(Request, Result, Citations), Answers),
    Answers = [ActualResult - ActualCitations],
    ActualResult == ExpectedResult,
    sort(ActualCitations, SortedActual),
    sort(ExpectedCitations, SortedExpected),
    SortedActual == SortedExpected.

base_obligation_profile(Profile) :-
    deployer_duties_fria_profile_for(log_retention_applies, deployer_obligation_request(Profile, _, _)).

control_differs(PositiveSubject - ControlSubject) :-
    deployer_duties_fria_assess(PositiveSubject, deployer_duties_fria_verdict(PositiveResult, _)),
    deployer_duties_fria_assess(ControlSubject, deployer_duties_fria_verdict(ControlResult, _)),
    dif(PositiveResult, ControlResult).

checklist_is_justified(Subject) :-
    deployer_duties_fria_profile_for(Subject, Request),
    deployer_duties_fria_checklist(Request, [FirstItem|OtherItems]),
    maplist(checklist_item, [FirstItem|OtherItems]).

checklist_item(item(_, _, _)).

final_result_in_vocabulary(Subject) :-
    expected_verdict(Subject, Result, [_|_]),
    deployer_duties_fria_status_values(StatusValues),
    member(Result, StatusValues).

test(every_subject_has_an_expected_verdict) :-
    findall(Subject, deployer_duties_fria_subject(Subject), Subjects),
    findall(Subject, expected_verdict(Subject, _, _), ExpectedSubjects),
    msort(Subjects, SortedSubjects),
    msort(ExpectedSubjects, SortedExpected),
    SortedSubjects == SortedExpected.
test(every_subject_resolves_to_its_expected_verdict_once) :-
    findall(Subject, deployer_duties_fria_subject(Subject), Subjects),
    Subjects = [_|_],
    maplist(resolves_as_expected, Subjects).
test(every_subject_resolves_the_same_through_the_contracted_queries) :-
    findall(Subject, deployer_duties_fria_subject(Subject), Subjects),
    Subjects = [_|_],
    maplist(direct_query_matches, Subjects).
test(every_final_result_is_in_the_vocabulary) :-
    findall(Subject, expected_verdict(Subject, _, [_|_]), Subjects),
    Subjects = [_|_],
    maplist(final_result_in_vocabulary, Subjects).
test(every_checklist_is_non_empty) :-
    findall(Subject, deployer_duties_fria_subject(Subject), Subjects),
    maplist(checklist_is_justified, Subjects).
test(every_near_miss_control_gets_another_verdict) :-
    findall(PositiveSubject - ControlSubject, near_miss_pair(PositiveSubject, ControlSubject), Pairs),
    Pairs = [_|_],
    maplist(control_differs, Pairs).
test(deployer_obligation_status_applies_to_the_base_deployer) :-
    base_obligation_profile(Profile),
    findall(Result - Citations, deployer_obligation_status(Profile, log_retention, date(2028, 1, 1), Result, Citations), Answers),
    Answers == [obligation_applies - [cite(eu_reg_2024_1689_art_26_6)]].
test(deployer_obligation_status_before_the_first_date) :-
    base_obligation_profile(Profile),
    deployer_obligation_status(Profile, notification_of_assessment_results, date(2027, 12, 1), Result, _),
    Result == not_applicable_on_date.
test(deployer_obligation_status_refuses_an_unbound_obligation) :-
    findall(Result - Citations, deployer_obligation_status([], _, date(2028, 1, 1), Result, Citations), Answers),
    Answers == [input_problems([wrong_type(obligation)]) - []].
test(deployer_obligation_status_names_the_missing_deployer) :-
    deployer_obligation_status([], fundamental_rights_impact_assessment, date(2028, 1, 1), Result, Citations),
    Result == indeterminate([deployer_of_the_system]),
    Citations == [].
test(log_retention_period_status_six_months_meet_the_minimum) :-
    base_obligation_profile(Profile),
    findall(Result - Citations, log_retention_period_status(Profile, 6, date(2028, 1, 1), Result, Citations), Answers),
    Answers == [retention_period_of_at_least_six_months - [cite(eu_reg_2024_1689_art_26_6)]].
test(log_retention_period_status_five_months_fall_short) :-
    base_obligation_profile(Profile),
    log_retention_period_status(Profile, 5, date(2028, 1, 1), Result, _),
    Result == retention_period_shorter_than_six_months.
test(log_retention_period_status_refuses_a_float_period) :-
    log_retention_period_status([], 6.0, date(2028, 1, 1), Result, Citations),
    Result == input_problems([wrong_type(retention_months)]),
    Citations == [].
test(log_retention_period_status_not_a_deployer) :-
    log_retention_period_status([attribute(deployer_of_the_system, false)], 6, date(2028, 1, 1), Result, Citations),
    Result == not_a_deployer,
    Citations == [cite(eu_reg_2024_1689_art_3_4)].
test(provenance_takes_a_clause_and_a_citation_list) :-
    provenance(obligation_applies, [cite(eu_reg_2024_1689_art_26_6)]).
test(provenance_with_no_citations_is_a_list) :-
    provenance(input_check, []).
test(log_retention_applies_to_the_base_deployer) :-
    verdict_is(log_retention_applies, obligation_applies, [cite(eu_reg_2024_1689_art_26_6)]).
test(the_first_chapter_iii_day_applies) :-
    deployer_duties_fria_assess(first_chapter_iii_day, deployer_duties_fria_verdict(obligation_applies, _)).
test(the_day_before_is_too_early) :-
    deployer_duties_fria_assess(day_before_first_chapter_iii_day, deployer_duties_fria_verdict(not_applicable_on_date, _)).
test(an_annex_i_system_waits_for_august_2028) :-
    deployer_duties_fria_assess(product_legislation_system_day_before, deployer_duties_fria_verdict(not_applicable_on_date, _)).
test(law_enforcement_uses_the_directive_rule) :-
    deployer_duties_fria_assess(law_enforcement_decisions, deployer_duties_fria_verdict(information_under_article_13_of_directive_2016_680, _)).
test(critical_infrastructure_needs_no_impact_assessment) :-
    deployer_duties_fria_assess(critical_infrastructure_impact_assessment, deployer_duties_fria_verdict(obligation_does_not_apply, _)).
test(an_annex_x_component_has_until_the_end_of_2030) :-
    deployer_duties_fria_assess(annex_x_component_day_before_compliance, deployer_duties_fria_verdict(compliance_required_by_31_december_2030, _)).
test(a_public_authority_system_has_until_2_august_2030) :-
    deployer_duties_fria_assess(public_authority_system_day_before, deployer_duties_fria_verdict(compliance_required_by_2_august_2030, _)).
test(six_months_meet_the_minimum) :-
    deployer_duties_fria_assess(retention_of_six_months, deployer_duties_fria_verdict(retention_period_of_at_least_six_months, _)).
test(the_missing_point_2_key_is_named) :-
    verdict_is(missing_critical_infrastructure_key, indeterminate([system_listed_under_point_2_of_annex_iii]), []).
test(the_unsure_public_body_is_referred) :-
    deployer_duties_fria_assess(unsure_public_body, deployer_duties_fria_verdict(needs_legal_review(open_textured(body_governed_by_public_law, cite(eu_reg_2024_1689_art_27_1)), _), [])).
test(the_status_is_the_verdict_result) :-
    deployer_duties_fria_profile_for(exempt_notification, Request),
    deployer_duties_fria_status(Request, Status),
    Status == obligation_does_not_apply.
test(every_fixture_request_is_resolvable) :-
    findall(Request, deployer_duties_fria_profile_for(_, Request), Requests),
    Requests = [_|_],
    maplist(deployer_duties_fria_decision_resolvable, Requests).
test(the_decision_answers_the_request_directly) :-
    decide_deployer_duties_fria(log_retention_period_request([attribute(deployer_of_the_system, false)], 6, date(2028, 1, 1)), Verdict),
    Verdict == deployer_duties_fria_verdict(not_a_deployer, [cite(eu_reg_2024_1689_art_3_4)]).
test(the_checklist_carries_cited_rows) :-
    deployer_duties_fria_profile_for(log_retention_applies, Request),
    deployer_duties_fria_checklist(Request, Checklist),
    member(item(deployer_role, met, cite(eu_reg_2024_1689_art_3_4)), Checklist),
    member(item(chapter_iii_application, met, cite(eu_reg_2024_1689_art_113_c)), Checklist).
test(a_refused_request_has_one_input_check_row) :-
    deployer_duties_fria_profile_for(unknown_profile_key, Request),
    deployer_duties_fria_checklist(Request, Checklist),
    Checklist == [item(input_check, input_problems([unknown_key(colour)]), [])].

test(deployer_obligation_status_before_the_first_date_does_not_apply, fail) :-
    base_obligation_profile(Profile),
    deployer_obligation_status(Profile, notification_of_assessment_results, date(2027, 12, 1), obligation_applies, _).
test(log_retention_period_status_five_months_do_not_meet_the_minimum, fail) :-
    base_obligation_profile(Profile),
    log_retention_period_status(Profile, 5, date(2028, 1, 1), retention_period_of_at_least_six_months, _).
test(provenance_refuses_citations_that_are_not_a_list, fail) :-
    provenance(obligation_applies, cite(eu_reg_2024_1689_art_26_6)).
test(the_first_chapter_iii_day_is_not_too_early, fail) :-
    deployer_duties_fria_assess(first_chapter_iii_day, deployer_duties_fria_verdict(not_applicable_on_date, _)).
test(the_day_before_does_not_apply_the_obligation, fail) :-
    deployer_duties_fria_assess(day_before_first_chapter_iii_day, deployer_duties_fria_verdict(obligation_applies, _)).
test(an_annex_i_system_on_its_date_is_not_waiting, fail) :-
    deployer_duties_fria_assess(product_legislation_system_on_its_date, deployer_duties_fria_verdict(not_applicable_on_date, _)).
test(ordinary_decisions_do_not_use_the_directive_rule, fail) :-
    deployer_duties_fria_assess(decisions_about_natural_persons, deployer_duties_fria_verdict(information_under_article_13_of_directive_2016_680, _)).
test(a_public_body_outside_critical_infrastructure_is_not_excused, fail) :-
    deployer_duties_fria_assess(public_body_impact_assessment, deployer_duties_fria_verdict(obligation_does_not_apply, _)).
test(an_annex_x_component_on_31_december_2030_is_bound, fail) :-
    deployer_duties_fria_assess(annex_x_component_on_compliance_day, deployer_duties_fria_verdict(compliance_required_by_31_december_2030, _)).
test(a_public_authority_system_on_2_august_2030_is_bound, fail) :-
    deployer_duties_fria_assess(public_authority_system_on_compliance_day, deployer_duties_fria_verdict(compliance_required_by_2_august_2030, _)).
test(five_months_do_not_meet_the_minimum, fail) :-
    deployer_duties_fria_assess(retention_of_five_months, deployer_duties_fria_verdict(retention_period_of_at_least_six_months, _)).

cp_test_names([every_subject_has_an_expected_verdict, every_subject_resolves_to_its_expected_verdict_once, every_subject_resolves_the_same_through_the_contracted_queries, every_final_result_is_in_the_vocabulary, every_checklist_is_non_empty, every_near_miss_control_gets_another_verdict, deployer_obligation_status_applies_to_the_base_deployer, deployer_obligation_status_before_the_first_date, deployer_obligation_status_refuses_an_unbound_obligation, deployer_obligation_status_names_the_missing_deployer, log_retention_period_status_six_months_meet_the_minimum, log_retention_period_status_five_months_fall_short, log_retention_period_status_refuses_a_float_period, log_retention_period_status_not_a_deployer, provenance_takes_a_clause_and_a_citation_list, provenance_with_no_citations_is_a_list, log_retention_applies_to_the_base_deployer, the_first_chapter_iii_day_applies, the_day_before_is_too_early, an_annex_i_system_waits_for_august_2028, law_enforcement_uses_the_directive_rule, critical_infrastructure_needs_no_impact_assessment, an_annex_x_component_has_until_the_end_of_2030, a_public_authority_system_has_until_2_august_2030, six_months_meet_the_minimum, the_missing_point_2_key_is_named, the_unsure_public_body_is_referred, the_status_is_the_verdict_result, every_fixture_request_is_resolvable, the_decision_answers_the_request_directly, the_checklist_carries_cited_rows, a_refused_request_has_one_input_check_row]).
cp_test_fail_names([deployer_obligation_status_before_the_first_date_does_not_apply, log_retention_period_status_five_months_do_not_meet_the_minimum, provenance_refuses_citations_that_are_not_a_list, the_first_chapter_iii_day_is_not_too_early, the_day_before_does_not_apply_the_obligation, an_annex_i_system_on_its_date_is_not_waiting, ordinary_decisions_do_not_use_the_directive_rule, a_public_body_outside_critical_infrastructure_is_not_excused, an_annex_x_component_on_31_december_2030_is_bound, a_public_authority_system_on_2_august_2030_is_bound, five_months_do_not_meet_the_minimum]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
