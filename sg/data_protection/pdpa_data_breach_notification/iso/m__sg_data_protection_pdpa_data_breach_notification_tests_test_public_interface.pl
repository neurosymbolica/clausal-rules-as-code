% SPDX-License-Identifier: EUPL-1.2
:- module(m__sg_data_protection_pdpa_data_breach_notification_tests_test_public_interface, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__sg_data_protection_pdpa_data_breach_notification_pdpa_data_breach_notification, [decide_pdpa_data_breach_notification/2, pdpa_data_breach_notification_status/2, pdpa_data_breach_notification_checklist/2, pdpa_data_breach_notification_decision_resolvable/1, pdpa_data_breach_notification_status_values/1, data_breach_notifiability/3, individual_notification/3, breach_response_duty/3, commission_notification_period_end/2, notification_contents/2, pdpa_breach_assessment/2]).
:- use_module(m__sg_data_protection_pdpa_data_breach_notification_fixtures, [pdpa_data_breach_notification_subject/1, pdpa_data_breach_notification_profile_for/2, pdpa_data_breach_notification_assess/2]).
:- use_module(m__sg_data_protection_pdpa_data_breach_notification_queries, [significant_harm/3, significant_scale/3, additional_item/3, content_item/2, duplicate_key/1, indeterminate/1, needs_legal_review/2, pdpa_breach/5, provenance/2, unknown_key/1]).
:- use_module(m__sg_data_protection_pdpa_data_breach_notification_kernel, [pdpa_data_breach_notification_input_problems/2]).

expected_status(pre_commencement_breach, not_applicable).
expected_status(commencement_day_breach, notifiable).
expected_status(account_pair_breach, notifiable).
expected_status(credential_only_breach, not_notifiable).
expected_status(bank_account_number_breach, notifiable).
expected_status(identity_with_schedule_data, notifiable).
expected_status(schedule_data_publicly_available, not_notifiable).
expected_status(affected_count_at_prescribed_number, notifiable).
expected_status(affected_count_below_prescribed_number, not_notifiable).
expected_status(within_organisation_access_excluded, not_notifiable).
expected_status(within_organisation_with_disposal, notifiable).
expected_status(law_enforcement_and_waiver, notifiable).
expected_status(waiver_only, notifiable).
expected_status(remedial_action_taken, notifiable).
expected_status(no_exception_applies, notifiable).
expected_status(exception_settles_with_harm_unsure, indeterminate([breached_data])).
expected_status(unsure_data_breach_judgement, needs_legal_review(open_textured(is_data_breach, cite(sg_pdpa_2012_s26a_def_databreach)), [inputs_relied_on([is_data_breach - unsure])])).
expected_status(missing_breach_date, indeterminate([breach_occurred_date])).
expected_status(not_a_data_breach, not_notifiable).
expected_status(public_agency_intermediary_without_date, indeterminate([breach_occurred_date])).
expected_status(intermediary_for_organisation, indeterminate([breached_data])).
expected_status(intermediary_before_commencement, not_applicable).
expected_status(organisation_notified_by_intermediary, indeterminate([breached_data])).
expected_status(organisation_without_possession, indeterminate([breached_data])).
expected_status(duplicate_key_profile, input_problems([duplicate_key(is_data_breach)])).
expected_status(numeric_key_profile, input_problems([unknown_key(42)])).
expected_status(impossible_date_profile, input_problems([wrong_type(breach_occurred_date)])).
expected_status(malformed_element_profile, input_problems([wrong_type(profile)])).
expected_status(full_notifiable_with_deadline, notifiable).

subject_status(Subject, Status) :-
    pdpa_data_breach_notification_assess(Subject, pdpa_data_breach_notification_verdict(Status, _)).

single_answer(Subject) :-
    findall(Verdict, pdpa_data_breach_notification_assess(Subject, Verdict), Verdicts),
    length(Verdicts, 1).

test(every_subject_resolves_to_its_expected_status) :-
    findall(Subject - Status, (pdpa_data_breach_notification_subject(Subject), subject_status(Subject, Status)), Actual),
    findall(Subject - Status, (pdpa_data_breach_notification_subject(Subject), expected_status(Subject, Status)), Expected),
    Actual == Expected.
test(every_subject_has_exactly_one_verdict) :-
    findall(Subject, pdpa_data_breach_notification_subject(Subject), Subjects),
    maplist(single_answer, Subjects).
test(every_subject_has_an_expected_status) :-
    findall(Subject, pdpa_data_breach_notification_subject(Subject), Subjects),
    findall(Subject, expected_status(Subject, _), ExpectedSubjects),
    Subjects == ExpectedSubjects.
test(every_final_status_is_in_the_status_vocabulary) :-
    pdpa_data_breach_notification_status_values(StatusValues),
    subject_status(commencement_day_breach, NotifiableStatus),
    subject_status(not_a_data_breach, NotNotifiableStatus),
    subject_status(pre_commencement_breach, NotApplicableStatus),
    member(NotifiableStatus, StatusValues),
    member(NotNotifiableStatus, StatusValues),
    member(NotApplicableStatus, StatusValues).
test(pre_commencement_breach_is_not_applicable) :-
    pdpa_data_breach_notification_profile_for(pre_commencement_breach, Profile),
    data_breach_notifiability(Profile, not_applicable, Citations),
    Citations == [cite(sg_pdpa_2012_s26c_1)].
test(commencement_day_breach_is_notifiable) :-
    subject_status(commencement_day_breach, notifiable).
test(account_pair_is_deemed_harm) :-
    pdpa_data_breach_notification_profile_for(account_pair_breach, Profile),
    significant_harm(Profile, Result, Citations),
    Result == significant_harm,
    Citations == [cite(sg_pdpa_2012_s26b_2_a), cite(sg_pdpa_2012_s64_2021_reg_3_1_b)].
test(credential_only_is_no_significant_harm) :-
    pdpa_data_breach_notification_profile_for(credential_only_breach, Profile),
    significant_harm(Profile, no_significant_harm, Citations),
    member(cite(sg_pdpa_2012_s26b_1_a), Citations).
test(bank_account_number_counts_as_account_identifier) :-
    pdpa_data_breach_notification_profile_for(bank_account_number_breach, Profile),
    significant_harm(Profile, significant_harm, Citations),
    member(cite(sg_pdpa_2012_s64_2021_reg_3_2), Citations).
test(identity_with_schedule_data_cites_its_schedule_item) :-
    pdpa_data_breach_notification_profile_for(identity_with_schedule_data, Profile),
    significant_harm(Profile, significant_harm, Citations),
    member(cite(sg_pdpa_2012_s64_2021_reg_3_1_a), Citations),
    member(cite(sg_pdpa_2012_s64_2021_sched_1_item_3), Citations),
    member(cite(sg_pdpa_2012_s64_2021_sched_2_item_1), Citations).
test(publicly_available_schedule_data_is_no_significant_harm) :-
    pdpa_data_breach_notification_profile_for(schedule_data_publicly_available, Profile),
    significant_harm(Profile, no_significant_harm, _).
test(five_hundred_affected_individuals_is_significant_scale) :-
    pdpa_data_breach_notification_profile_for(affected_count_at_prescribed_number, Profile),
    significant_scale(Profile, significant_scale, Citations),
    Citations == [cite(sg_pdpa_2012_s26b_3_a), cite(sg_pdpa_2012_s64_2021_reg_4)].
test(four_hundred_ninety_nine_is_no_significant_scale) :-
    pdpa_data_breach_notification_profile_for(affected_count_below_prescribed_number, Profile),
    significant_scale(Profile, no_significant_scale, _).
test(scale_only_breach_owes_no_notice_to_individuals) :-
    pdpa_data_breach_notification_profile_for(affected_count_at_prescribed_number, Profile),
    individual_notification(Profile, not_required, Citations),
    Citations == [cite(sg_pdpa_2012_s26d_2), cite(sg_pdpa_2012_s26b_1_a)].
test(within_organisation_access_is_excluded) :-
    pdpa_data_breach_notification_profile_for(within_organisation_access_excluded, Profile),
    data_breach_notifiability(Profile, not_notifiable, Citations),
    Citations == [cite(sg_pdpa_2012_s26b_4)].
test(within_organisation_with_disposal_is_notifiable) :-
    subject_status(within_organisation_with_disposal, notifiable).
test(law_enforcement_prohibition_wins_over_waiver) :-
    pdpa_data_breach_notification_profile_for(law_enforcement_and_waiver, Profile),
    individual_notification(Profile, prohibited, Citations),
    Citations == [cite(sg_pdpa_2012_s26d_6_a)].
test(waiver_alone_is_waived) :-
    pdpa_data_breach_notification_profile_for(waiver_only, Profile),
    individual_notification(Profile, waived, Citations),
    Citations == [cite(sg_pdpa_2012_s26d_7)].
test(remedial_action_makes_notice_not_required) :-
    pdpa_data_breach_notification_profile_for(remedial_action_taken, Profile),
    individual_notification(Profile, not_required, Citations),
    Citations == [cite(sg_pdpa_2012_s26d_5_a)].
test(no_exception_requires_notice) :-
    pdpa_data_breach_notification_profile_for(no_exception_applies, Profile),
    individual_notification(Profile, required, Citations),
    Citations == [cite(sg_pdpa_2012_s26d_2)].
test(settled_exception_answers_beside_unsure_judgements) :-
    pdpa_data_breach_notification_profile_for(exception_settles_with_harm_unsure, Profile),
    individual_notification(Profile, not_required, Citations),
    Citations == [cite(sg_pdpa_2012_s26d_5_a)].
test(unsure_data_breach_judgement_is_referred_with_no_citations) :-
    pdpa_data_breach_notification_profile_for(unsure_data_breach_judgement, Profile),
    data_breach_notifiability(Profile, Result, Citations),
    Result == needs_legal_review(open_textured(is_data_breach, cite(sg_pdpa_2012_s26a_def_databreach)), [inputs_relied_on([is_data_breach - unsure])]),
    Citations == [].
test(missing_breach_date_is_named_first) :-
    pdpa_data_breach_notification_profile_for(missing_breach_date, Profile),
    data_breach_notifiability(Profile, indeterminate([breach_occurred_date]), []).
test(dated_false_judgement_is_not_a_data_breach) :-
    pdpa_data_breach_notification_profile_for(not_a_data_breach, Profile),
    data_breach_notifiability(Profile, not_notifiable, Citations),
    Citations == [cite(sg_pdpa_2012_s26a_def_databreach)].
test(provenance_is_a_constructor_of_an_optional_context_item) :-
    Context = [inputs_relied_on([is_data_breach - unsure]), provenance(is_data_breach, cite(sg_pdpa_2012_s26a_def_databreach))],
    member(provenance(Input, Citation), Context),
    Input == is_data_breach,
    Citation == cite(sg_pdpa_2012_s26a_def_databreach).
test(the_referral_context_carries_inputs_relied_on) :-
    pdpa_data_breach_notification_profile_for(unsure_data_breach_judgement, Profile),
    data_breach_notifiability(Profile, needs_legal_review(_, Context), []),
    member(inputs_relied_on(_), Context).
test(public_agency_intermediary_needs_no_date) :-
    pdpa_data_breach_notification_profile_for(public_agency_intermediary_without_date, Profile),
    breach_response_duty(Profile, notify_public_agency_without_undue_delay, Citations),
    Citations == [cite(sg_pdpa_2012_s26e_a), cite(sg_pdpa_2012_s26e_b)].
test(intermediary_must_notify_the_organisation) :-
    pdpa_data_breach_notification_profile_for(intermediary_for_organisation, Profile),
    breach_response_duty(Profile, notify_organisation_without_undue_delay, Citations),
    Citations == [cite(sg_pdpa_2012_s26c_3), cite(sg_pdpa_2012_s26c_3_a)].
test(intermediary_before_commencement_is_not_applicable) :-
    pdpa_data_breach_notification_profile_for(intermediary_before_commencement, Profile),
    breach_response_duty(Profile, not_applicable, Citations),
    Citations == [cite(sg_pdpa_2012_s26c_1)].
test(organisation_notified_by_intermediary_must_assess) :-
    pdpa_data_breach_notification_profile_for(organisation_notified_by_intermediary, Profile),
    breach_response_duty(Profile, assessment_required, Citations),
    Citations == [cite(sg_pdpa_2012_s26c_3_b)].
test(organisation_without_possession_has_no_duty) :-
    pdpa_data_breach_notification_profile_for(organisation_without_possession, Profile),
    breach_response_duty(Profile, no_duty_triggered, Citations),
    Citations == [cite(sg_pdpa_2012_s26c_2)].
test(duplicate_key_is_reported_alone) :-
    pdpa_data_breach_notification_profile_for(duplicate_key_profile, Profile),
    pdpa_data_breach_notification_input_problems(Profile, Problems),
    Problems == [duplicate_key(is_data_breach)].
test(numeric_key_is_unknown_as_given) :-
    pdpa_data_breach_notification_profile_for(numeric_key_profile, Profile),
    pdpa_data_breach_notification_input_problems(Profile, Problems),
    Problems == [unknown_key(42)].
test(impossible_date_is_wrong_type) :-
    pdpa_data_breach_notification_profile_for(impossible_date_profile, Profile),
    significant_harm(Profile, Result, Citations),
    Result == input_problems([wrong_type(breach_occurred_date)]),
    Citations == [].
test(malformed_element_is_not_a_profile) :-
    pdpa_data_breach_notification_profile_for(malformed_element_profile, Profile),
    pdpa_breach_assessment(Profile, Result),
    Result == pdpa_breach(input_problems([wrong_type(profile)]), [], n_a, n_a, []).
test(well_formed_fixture_has_no_input_problem) :-
    pdpa_data_breach_notification_profile_for(full_notifiable_with_deadline, Profile),
    pdpa_data_breach_notification_input_problems(Profile, Problems),
    Problems == [].
test(period_end_adds_three_calendar_days) :-
    commission_notification_period_end(date(2026, 1, 1), date(2026, 1, 4)).
test(period_end_carries_into_the_next_month) :-
    commission_notification_period_end(date(2026, 2, 27), date(2026, 3, 2)).
test(period_end_in_a_leap_year) :-
    commission_notification_period_end(date(2028, 2, 27), date(2028, 3, 1)).
test(period_end_carries_into_the_next_year) :-
    commission_notification_period_end(date(2026, 12, 30), date(2027, 1, 2)).
test(period_end_is_not_moved_for_a_weekend) :-
    commission_notification_period_end(date(2026, 1, 2), date(2026, 1, 5)).
test(period_end_refuses_an_unreal_day) :-
    commission_notification_period_end(date(2026, 2, 30), End),
    End == input_problems([wrong_type(assessed_date)]).
test(commission_contents_are_one_list_of_nine) :-
    findall(Items, notification_contents(commission, Items), Answers),
    length(Answers, 1),
    Answers = [CommissionItems],
    length(CommissionItems, 9).
test(individual_contents_are_one_list_of_six) :-
    findall(Items, notification_contents(affected_individual, Items), Answers),
    Answers = [IndividualItems],
    length(IndividualItems, 6),
    IndividualItems = [content_item(circumstances_of_first_awareness, cite(sg_pdpa_2012_s64_2021_reg_6_a))|_].
test(additional_contents_are_two_conditional_items) :-
    notification_contents(commission_additional, Items),
    Items == [additional_item(late_notification_reasons_and_evidence, notified_after_period, cite(sg_pdpa_2012_s64_2021_reg_5_2)), additional_item(grounds_for_not_notifying_affected_individuals, affected_individuals_not_to_be_notified, cite(sg_pdpa_2012_s64_2021_reg_5_3))].
test(the_content_item_recogniser_reads_out_its_citation) :-
    findall(Citation, content_item(how_breach_occurred, Citation), Citations),
    ground(Citations),
    Citations == [cite(sg_pdpa_2012_s64_2021_reg_5_1_c)].
test(the_additional_item_recogniser_reads_out_its_condition) :-
    findall(Condition - Citation, additional_item(late_notification_reasons_and_evidence, Condition, Citation), Answers),
    ground(Answers),
    Answers == [notified_after_period - cite(sg_pdpa_2012_s64_2021_reg_5_2)].
test(the_duplicate_key_recogniser_reads_out_the_contract_keys) :-
    findall(ProblemKey, duplicate_key(ProblemKey), ProblemKeys),
    ground(ProblemKeys),
    length(ProblemKeys, 19),
    ProblemKeys = [breach_occurred_date|_].
test(the_indeterminate_recogniser_reads_out_the_contract_keys) :-
    findall(MissingKey, indeterminate([MissingKey]), MissingKeys),
    ground(MissingKeys),
    length(MissingKeys, 19),
    MissingKeys = [breach_occurred_date|_].
test(the_referral_recogniser_reads_out_the_judgement_keys) :-
    findall(Input, needs_legal_review(open_textured(Input, cite(sg_pdpa_2012_s26a_def_databreach)), [inputs_relied_on([])]), Inputs),
    ground(Inputs),
    Inputs == [is_data_breach, assessed_likely_significant_harm, assessed_likely_significant_scale, remedial_action_renders_harm_unlikely, prior_technological_measure_renders_harm_unlikely, reason_to_believe_breach_occurred].
test(the_provenance_recogniser_reads_out_the_contract_keys) :-
    findall(Input, provenance(Input, cite(sg_pdpa_2012_s26c_1)), Inputs),
    ground(Inputs),
    length(Inputs, 19),
    Inputs = [breach_occurred_date|_].
test(the_combined_answer_recogniser_reads_out_the_grounds) :-
    findall(Grounds, pdpa_breach(notifiable, Grounds, n_a, n_a, []), GroundLists),
    ground(GroundLists),
    GroundLists == [[], [significant_harm], [significant_scale], [significant_harm, significant_scale]].
test(the_unknown_key_recogniser_accepts_the_key_the_input_check_names) :-
    pdpa_data_breach_notification_input_problems([attribute(colour, red)], [unknown_key(ProblemKey)]),
    findall(ProblemKey, unknown_key(ProblemKey), ProblemKeys),
    ground(ProblemKeys),
    ProblemKeys == [colour].
test(full_assessment_of_a_notifiable_breach) :-
    pdpa_data_breach_notification_profile_for(full_notifiable_with_deadline, Profile),
    pdpa_breach_assessment(Profile, pdpa_breach(Decision, Grounds, Deadline, Individuals, Citations)),
    Decision == notifiable,
    Grounds == [significant_harm, significant_scale],
    Deadline = date(2026, 1, 5),
    Individuals == required,
    member(cite(sg_pdpa_2012_s26d_1), Citations),
    member(cite(sg_pdpa_2012_s26d_2), Citations),
    member(cite(sg_pdpa_2012_s64_2021_sched_1_item_3), Citations),
    member(cite(sg_pdpa_2012_s64_2021_reg_4), Citations).
test(assessment_without_date_names_the_assessment_date) :-
    pdpa_data_breach_notification_profile_for(account_pair_breach, Profile),
    pdpa_breach_assessment(Profile, pdpa_breach(notifiable, [significant_harm], Deadline, _, _)),
    Deadline == indeterminate([assessment_date]).
test(not_notifiable_assessment_has_no_deadline) :-
    pdpa_data_breach_notification_profile_for(credential_only_breach, Profile),
    pdpa_breach_assessment(Profile, pdpa_breach(not_notifiable, Grounds, Deadline, Individuals, _)),
    Grounds == [],
    Deadline == n_a,
    Individuals == n_a.
test(the_verdict_carries_citations) :-
    pdpa_data_breach_notification_profile_for(no_exception_applies, Profile),
    decide_pdpa_data_breach_notification(Profile, pdpa_data_breach_notification_verdict(notifiable, [_|_])).
test(the_status_projects_the_decision) :-
    pdpa_data_breach_notification_profile_for(no_exception_applies, Profile),
    pdpa_data_breach_notification_status(Profile, notifiable).
test(the_checklist_is_non_empty_and_cited) :-
    pdpa_data_breach_notification_profile_for(no_exception_applies, Profile),
    pdpa_data_breach_notification_decision_resolvable(Profile),
    pdpa_data_breach_notification_checklist(Profile, Items),
    length(Items, 5),
    member(item(data_breach_notifiability, notifiable, [_|_]), Items),
    member(item(individual_notification, required, [cite(sg_pdpa_2012_s26d_2)]), Items).
test(the_checklist_of_an_excluded_breach_is_not_notifiable) :-
    pdpa_data_breach_notification_profile_for(within_organisation_access_excluded, Profile),
    pdpa_data_breach_notification_checklist(Profile, Items),
    member(item(data_breach_notifiability, not_notifiable, [cite(sg_pdpa_2012_s26b_4)]), Items).

test(pre_commencement_breach_is_not_notifiable_status, fail) :-
    subject_status(pre_commencement_breach, notifiable).
test(commencement_day_breach_is_not_not_applicable, fail) :-
    subject_status(commencement_day_breach, not_applicable).
test(credential_only_is_not_significant_harm, fail) :-
    pdpa_data_breach_notification_profile_for(credential_only_breach, Profile),
    significant_harm(Profile, significant_harm, _).
test(publicly_available_schedule_data_is_not_notifiable_status, fail) :-
    subject_status(schedule_data_publicly_available, notifiable).
test(four_hundred_ninety_nine_is_not_significant_scale, fail) :-
    pdpa_data_breach_notification_profile_for(affected_count_below_prescribed_number, Profile),
    significant_scale(Profile, significant_scale, _).
test(below_prescribed_number_is_not_notifiable_status, fail) :-
    subject_status(affected_count_below_prescribed_number, notifiable).
test(within_organisation_with_disposal_is_not_excluded, fail) :-
    subject_status(within_organisation_with_disposal, not_notifiable).
test(law_enforcement_and_waiver_is_not_waived, fail) :-
    pdpa_data_breach_notification_profile_for(law_enforcement_and_waiver, Profile),
    individual_notification(Profile, waived, _).
test(no_exception_is_not_not_required, fail) :-
    pdpa_data_breach_notification_profile_for(no_exception_applies, Profile),
    individual_notification(Profile, not_required, _).
test(the_referral_context_carries_no_provenance_item, fail) :-
    pdpa_data_breach_notification_profile_for(unsure_data_breach_judgement, Profile),
    data_breach_notifiability(Profile, needs_legal_review(_, Context), []),
    member(provenance(_, _), Context).
test(intermediary_before_commencement_owes_no_notice, fail) :-
    pdpa_data_breach_notification_profile_for(intermediary_before_commencement, Profile),
    breach_response_duty(Profile, notify_organisation_without_undue_delay, _).
test(organisation_without_possession_need_not_assess, fail) :-
    pdpa_data_breach_notification_profile_for(organisation_without_possession, Profile),
    breach_response_duty(Profile, assessment_required, _).
test(period_end_is_not_the_interpretation_act_reading, fail) :-
    commission_notification_period_end(date(2026, 1, 2), date(2026, 1, 6)).
test(the_unknown_key_recogniser_refuses_a_contract_key, fail) :-
    unknown_key(caller_role).

cp_test_names([every_subject_resolves_to_its_expected_status, every_subject_has_exactly_one_verdict, every_subject_has_an_expected_status, every_final_status_is_in_the_status_vocabulary, pre_commencement_breach_is_not_applicable, commencement_day_breach_is_notifiable, account_pair_is_deemed_harm, credential_only_is_no_significant_harm, bank_account_number_counts_as_account_identifier, identity_with_schedule_data_cites_its_schedule_item, publicly_available_schedule_data_is_no_significant_harm, five_hundred_affected_individuals_is_significant_scale, four_hundred_ninety_nine_is_no_significant_scale, scale_only_breach_owes_no_notice_to_individuals, within_organisation_access_is_excluded, within_organisation_with_disposal_is_notifiable, law_enforcement_prohibition_wins_over_waiver, waiver_alone_is_waived, remedial_action_makes_notice_not_required, no_exception_requires_notice, settled_exception_answers_beside_unsure_judgements, unsure_data_breach_judgement_is_referred_with_no_citations, missing_breach_date_is_named_first, dated_false_judgement_is_not_a_data_breach, provenance_is_a_constructor_of_an_optional_context_item, the_referral_context_carries_inputs_relied_on, public_agency_intermediary_needs_no_date, intermediary_must_notify_the_organisation, intermediary_before_commencement_is_not_applicable, organisation_notified_by_intermediary_must_assess, organisation_without_possession_has_no_duty, duplicate_key_is_reported_alone, numeric_key_is_unknown_as_given, impossible_date_is_wrong_type, malformed_element_is_not_a_profile, well_formed_fixture_has_no_input_problem, period_end_adds_three_calendar_days, period_end_carries_into_the_next_month, period_end_in_a_leap_year, period_end_carries_into_the_next_year, period_end_is_not_moved_for_a_weekend, period_end_refuses_an_unreal_day, commission_contents_are_one_list_of_nine, individual_contents_are_one_list_of_six, additional_contents_are_two_conditional_items, the_content_item_recogniser_reads_out_its_citation, the_additional_item_recogniser_reads_out_its_condition, the_duplicate_key_recogniser_reads_out_the_contract_keys, the_indeterminate_recogniser_reads_out_the_contract_keys, the_referral_recogniser_reads_out_the_judgement_keys, the_provenance_recogniser_reads_out_the_contract_keys, the_combined_answer_recogniser_reads_out_the_grounds, the_unknown_key_recogniser_accepts_the_key_the_input_check_names, full_assessment_of_a_notifiable_breach, assessment_without_date_names_the_assessment_date, not_notifiable_assessment_has_no_deadline, the_verdict_carries_citations, the_status_projects_the_decision, the_checklist_is_non_empty_and_cited, the_checklist_of_an_excluded_breach_is_not_notifiable]).
cp_test_fail_names([pre_commencement_breach_is_not_notifiable_status, commencement_day_breach_is_not_not_applicable, credential_only_is_not_significant_harm, publicly_available_schedule_data_is_not_notifiable_status, four_hundred_ninety_nine_is_not_significant_scale, below_prescribed_number_is_not_notifiable_status, within_organisation_with_disposal_is_not_excluded, law_enforcement_and_waiver_is_not_waived, no_exception_is_not_not_required, the_referral_context_carries_no_provenance_item, intermediary_before_commencement_owes_no_notice, organisation_without_possession_need_not_assess, period_end_is_not_the_interpretation_act_reading, the_unknown_key_recogniser_refuses_a_contract_key]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
