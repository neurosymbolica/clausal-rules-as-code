% SPDX-License-Identifier: EUPL-1.2
:- module(m__sg_tax_gst_registration_tests_test_public_interface, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__sg_tax_gst_registration_gst_registration, [gst_registration_status/2, gst_registration_checklist/2, gst_registration_decision_resolvable/1, gst_registration_status_values/1, gst_retrospective_liability/2, gst_prospective_liability/2, gst_retrospective/5, gst_prospective/5]).
:- use_module(m__sg_tax_gst_registration_queries, [gst_registration_profile_keys/1]).
:- use_module(m__sg_tax_gst_registration_fixtures, [gst_registration_subject/1, gst_registration_profile_for/2, gst_registration_assess/2]).

subject_basis(retrospective_liable_just_above_threshold, retrospective).
subject_basis(retrospective_not_liable_at_threshold, retrospective).
subject_basis(retrospective_already_registered_just_above_threshold, retrospective).
subject_basis(retrospective_comptroller_satisfied_just_above_threshold, retrospective).
subject_basis(retrospective_zero_rated_exemption_just_above_threshold, retrospective).
subject_basis(retrospective_indeterminate_missing_taxable_supplies, retrospective).
subject_basis(retrospective_seventh_schedule_year_2022_liable, retrospective).
subject_basis(retrospective_seventh_schedule_year_2021_not_liable, retrospective).
subject_basis(prospective_liable_pre_cutover_just_above_threshold, prospective).
subject_basis(prospective_not_liable_at_threshold_pre_cutover, prospective).
subject_basis(prospective_liable_post_cutover_at_boundary, prospective).
subject_basis(prospective_liable_pre_cutover_just_below_boundary, prospective).
subject_basis(prospective_already_registered_just_above_threshold, prospective).
subject_basis(prospective_zero_rated_exemption_just_above_threshold, prospective).
subject_basis(prospective_indeterminate_missing_forecast_start_date, prospective).
subject_basis(prospective_seventh_schedule_belongs_true_liable, prospective).
subject_basis(prospective_seventh_schedule_belongs_false_not_liable, prospective).

expected_status(retrospective_liable_just_above_threshold, eligible).
expected_status(retrospective_not_liable_at_threshold, ineligible).
expected_status(retrospective_already_registered_just_above_threshold, ineligible).
expected_status(retrospective_comptroller_satisfied_just_above_threshold, ineligible).
expected_status(retrospective_zero_rated_exemption_just_above_threshold, ineligible).
expected_status(retrospective_indeterminate_missing_taxable_supplies, indeterminate).
expected_status(retrospective_seventh_schedule_year_2022_liable, eligible).
expected_status(retrospective_seventh_schedule_year_2021_not_liable, ineligible).
expected_status(prospective_liable_pre_cutover_just_above_threshold, eligible).
expected_status(prospective_not_liable_at_threshold_pre_cutover, ineligible).
expected_status(prospective_liable_post_cutover_at_boundary, eligible).
expected_status(prospective_liable_pre_cutover_just_below_boundary, eligible).
expected_status(prospective_already_registered_just_above_threshold, ineligible).
expected_status(prospective_zero_rated_exemption_just_above_threshold, ineligible).
expected_status(prospective_indeterminate_missing_forecast_start_date, indeterminate).
expected_status(prospective_seventh_schedule_belongs_true_liable, eligible).
expected_status(prospective_seventh_schedule_belongs_false_not_liable, ineligible).

expected_decision(retrospective_liable_just_above_threshold, liable).
expected_decision(retrospective_not_liable_at_threshold, not_liable).
expected_decision(retrospective_already_registered_just_above_threshold, already_registered).
expected_decision(retrospective_comptroller_satisfied_just_above_threshold, not_liable_comptroller_satisfied).
expected_decision(retrospective_zero_rated_exemption_just_above_threshold, exempted_zero_rated).
expected_decision(retrospective_indeterminate_missing_taxable_supplies, indeterminate).
expected_decision(retrospective_seventh_schedule_year_2022_liable, liable).
expected_decision(retrospective_seventh_schedule_year_2021_not_liable, not_liable).
expected_decision(prospective_liable_pre_cutover_just_above_threshold, liable).
expected_decision(prospective_not_liable_at_threshold_pre_cutover, not_liable).
expected_decision(prospective_liable_post_cutover_at_boundary, liable).
expected_decision(prospective_liable_pre_cutover_just_below_boundary, liable).
expected_decision(prospective_already_registered_just_above_threshold, already_registered).
expected_decision(prospective_zero_rated_exemption_just_above_threshold, exempted_zero_rated).
expected_decision(prospective_indeterminate_missing_forecast_start_date, indeterminate).
expected_decision(prospective_seventh_schedule_belongs_true_liable, liable).
expected_decision(prospective_seventh_schedule_belongs_false_not_liable, not_liable).

near_miss_pair(retrospective_liable_just_above_threshold, retrospective_not_liable_at_threshold).
near_miss_pair(retrospective_already_registered_just_above_threshold, retrospective_liable_just_above_threshold).
near_miss_pair(retrospective_comptroller_satisfied_just_above_threshold, retrospective_liable_just_above_threshold).
near_miss_pair(retrospective_zero_rated_exemption_just_above_threshold, retrospective_liable_just_above_threshold).
near_miss_pair(retrospective_indeterminate_missing_taxable_supplies, retrospective_not_liable_at_threshold).
near_miss_pair(retrospective_seventh_schedule_year_2022_liable, retrospective_seventh_schedule_year_2021_not_liable).
near_miss_pair(prospective_liable_pre_cutover_just_above_threshold, prospective_not_liable_at_threshold_pre_cutover).
near_miss_pair(prospective_already_registered_just_above_threshold, prospective_liable_pre_cutover_just_above_threshold).
near_miss_pair(prospective_zero_rated_exemption_just_above_threshold, prospective_liable_pre_cutover_just_above_threshold).
near_miss_pair(prospective_indeterminate_missing_forecast_start_date, prospective_liable_pre_cutover_just_above_threshold).
near_miss_pair(prospective_seventh_schedule_belongs_true_liable, prospective_seventh_schedule_belongs_false_not_liable).

determination_decision(Subject, Decision) :-
    subject_basis(Subject, retrospective),
    gst_registration_profile_for(Subject, Profile),
    gst_retrospective_liability(Profile, gst_retrospective(Decision, _, _, _, _)).
determination_decision(Subject, Decision) :-
    subject_basis(Subject, prospective),
    gst_registration_profile_for(Subject, Profile),
    gst_prospective_liability(Profile, gst_prospective(Decision, _, _, _, _)).

near_miss_violation(PositiveSubject, NearMissSubject) :-
    near_miss_pair(PositiveSubject, NearMissSubject),
    gst_registration_profile_for(PositiveSubject, PositiveProfile),
    gst_registration_status(PositiveProfile, PositiveStatus),
    gst_registration_profile_for(NearMissSubject, NearMissProfile),
    gst_registration_status(NearMissProfile, NearMissStatus),
    PositiveStatus == NearMissStatus.

test(status_matches_expected_for_every_subject) :-
    findall((Subject, Status), (gst_registration_subject(Subject), gst_registration_profile_for(Subject, Profile), gst_registration_status(Profile, Status)), ActualStatuses),
    findall((Subject, Status), (gst_registration_subject(Subject), expected_status(Subject, Status)), ExpectedStatuses),
    sort(ActualStatuses, SortedActualStatuses),
    sort(ExpectedStatuses, SortedExpectedStatuses),
    SortedActualStatuses == SortedExpectedStatuses.
test(decision_matches_expected_for_every_subject) :-
    findall((Subject, Decision), (gst_registration_subject(Subject), determination_decision(Subject, Decision)), ActualDecisions),
    findall((Subject, Decision), (gst_registration_subject(Subject), expected_decision(Subject, Decision)), ExpectedDecisions),
    sort(ActualDecisions, SortedActualDecisions),
    sort(ExpectedDecisions, SortedExpectedDecisions),
    SortedActualDecisions == SortedExpectedDecisions.
test(checklist_non_empty_for_every_subject) :-
    findall(Subject, (gst_registration_subject(Subject), gst_registration_profile_for(Subject, Profile), gst_registration_checklist(Profile, [_FirstItem|_OtherItems])), CheckedSubjects),
    findall(Subject, gst_registration_subject(Subject), AllSubjects),
    sort(CheckedSubjects, SortedCheckedSubjects),
    sort(AllSubjects, SortedAllSubjects),
    SortedCheckedSubjects == SortedAllSubjects.
test(decision_resolvable_for_every_subject) :-
    findall(Subject, (gst_registration_subject(Subject), gst_registration_profile_for(Subject, Profile), gst_registration_decision_resolvable(Profile)), ResolvableSubjects),
    findall(Subject, gst_registration_subject(Subject), AllSubjects),
    sort(ResolvableSubjects, SortedResolvableSubjects),
    sort(AllSubjects, SortedAllSubjects),
    SortedResolvableSubjects == SortedAllSubjects.
test(status_values_are_the_contract_atoms) :-
    gst_registration_status_values(StatusValues),
    sort(StatusValues, SortedStatusValues),
    sort([eligible, ineligible, indeterminate], SortedExpectedStatusValues),
    SortedStatusValues == SortedExpectedStatusValues.
test(near_miss_controls_get_opposite_status) :-
    findall((PositiveSubject, NearMissSubject), near_miss_violation(PositiveSubject, NearMissSubject), Violations),
    Violations == [].
test(profile_keys_include_retrospective_required_keys) :-
    gst_registration_profile_keys(Keys),
    member(is_registered, Keys),
    member(belongs_in_singapore, Keys),
    member(calendar_year, Keys),
    member(taxable_supplies_cents, Keys).
test(profile_keys_include_prospective_required_keys) :-
    gst_registration_profile_keys(Keys),
    member(forecast_start_date, Keys),
    member(forecast_taxable_supplies_cents, Keys).
test(assess_returns_a_verdict_for_every_subject) :-
    findall(Subject, (gst_registration_subject(Subject), gst_registration_assess(Subject, gst_registration_verdict(_, _))), AssessedSubjects),
    findall(Subject, gst_registration_subject(Subject), AllSubjects),
    sort(AssessedSubjects, SortedAssessedSubjects),
    sort(AllSubjects, SortedAllSubjects),
    SortedAssessedSubjects == SortedAllSubjects.
test(retrospective_liable_fixture_has_statutory_dates) :-
    gst_registration_profile_for(retrospective_liable_just_above_threshold, Profile),
    gst_retrospective_liability(Profile, gst_retrospective(liable, 100000001, date(2023, 1, 30), date(2023, 3, 1), [sg_gsta_1993_sch1_para_1_1_a_ii, sg_gsta_1993_sch1_para_4_1a, sg_gsta_1993_sch1_para_4_2_a])).
test(prospective_liable_pre_cutover_fixture_has_statutory_dates) :-
    gst_registration_profile_for(prospective_liable_pre_cutover_just_above_threshold, Profile),
    gst_prospective_liability(Profile, gst_prospective(liable, 100000001, date(2022, 2, 14), date(2022, 2, 15), [sg_gsta_1993_sch1_para_1_1_b, sg_gsta_1993_sch1_para_5_1, sg_gsta_1993_sch1_para_5_2_a_i])).
test(prospective_liable_post_cutover_fixture_has_statutory_dates) :-
    gst_registration_profile_for(prospective_liable_post_cutover_at_boundary, Profile),
    gst_prospective_liability(Profile, gst_prospective(liable, 100000001, date(2025, 7, 31), date(2025, 9, 1), [sg_gsta_1993_sch1_para_1_1_b, sg_gsta_1993_sch1_para_5_1, sg_gsta_1993_sch1_para_5_2_a_ii])).
test(retrospective_record_predicate_accepts_liable_shape) :-
    gst_retrospective(liable, 100000001, date(2023, 1, 30), date(2023, 3, 1), [sg_gsta_1993_sch1_para_1_1_a_ii, sg_gsta_1993_sch1_para_4_1a, sg_gsta_1993_sch1_para_4_2_a]).
test(prospective_record_predicate_accepts_pre_cutover_shape) :-
    gst_prospective(liable, 100000001, date(2022, 2, 14), date(2022, 2, 15), [sg_gsta_1993_sch1_para_1_1_b, sg_gsta_1993_sch1_para_5_1, sg_gsta_1993_sch1_para_5_2_a_i]).

cp_test_names([status_matches_expected_for_every_subject, decision_matches_expected_for_every_subject, checklist_non_empty_for_every_subject, decision_resolvable_for_every_subject, status_values_are_the_contract_atoms, near_miss_controls_get_opposite_status, profile_keys_include_retrospective_required_keys, profile_keys_include_prospective_required_keys, assess_returns_a_verdict_for_every_subject, retrospective_liable_fixture_has_statutory_dates, prospective_liable_pre_cutover_fixture_has_statutory_dates, prospective_liable_post_cutover_fixture_has_statutory_dates, retrospective_record_predicate_accepts_liable_shape, prospective_record_predicate_accepts_pre_cutover_shape]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
