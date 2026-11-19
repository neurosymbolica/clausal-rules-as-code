% SPDX-License-Identifier: EUPL-1.2
:- module(m__ind_dpdp_security_retention_tests_test_output_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__ind_dpdp_security_retention_dpdp_security_retention, [security_safeguards_duty/3, accuracy_duty/3, erasure_duty/3, third_schedule_deemed_no_longer_served/3, third_schedule_period_end/2, erasure_notice_latest_day/2, processing_log_retention_minimum_end/2, fixed_lists/2, decide_dpdp_security_retention/2, dpdp_security_retention_status/2, dpdp_security_retention_checklist/2]).
:- use_module(m__ind_dpdp_security_retention_fixtures, [dpdp_security_retention_profile_for/2]).

subject_status(Subject, Statuses) :-
    dpdp_security_retention_profile_for(Subject, Profile),
    findall(Status, dpdp_security_retention_status(Profile, Status), Statuses).

test(empty_profile_security_names_its_in_force_key) :-
    findall(Result - Citations, security_safeguards_duty([], Result, Citations), Answers),
    Answers == [indeterminate([section_8_5_in_force]) - []].
test(empty_profile_accuracy_names_its_in_force_key) :-
    findall(Result - Citations, accuracy_duty([], Result, Citations), Answers),
    Answers == [indeterminate([section_8_3_in_force]) - []].
test(empty_profile_erasure_names_its_in_force_key) :-
    findall(Result - Citations, erasure_duty([], Result, Citations), Answers),
    Answers == [indeterminate([section_8_7_in_force]) - []].
test(empty_profile_deemed_names_its_in_force_key) :-
    findall(Result - Citations, third_schedule_deemed_no_longer_served([], Result, Citations), Answers),
    Answers == [indeterminate([section_8_8_in_force]) - []].
test(security_on_commencement_day_reads_out_rule_6) :-
    dpdp_security_retention_profile_for(safeguards_on_commencement_day, Profile),
    findall(Result, security_safeguards_duty(Profile, Result, _), Results),
    Results == [required_with_rule_6_minimum].
test(security_day_before_reads_out_no_minimum) :-
    dpdp_security_retention_profile_for(safeguards_day_before_commencement, Profile),
    findall(Result, security_safeguards_duty(Profile, Result, _), Results),
    Results == [required_minimum_not_prescribed].
test(accuracy_decision_use_missing_is_named) :-
    findall(Result, accuracy_duty([attribute(section_8_3_in_force, true), attribute(acts_as_data_fiduciary, true), attribute(likely_disclosed_to_another_data_fiduciary, false)], Result, _), Results),
    Results == [indeterminate([likely_used_for_decision_affecting_data_principal])].
test(accuracy_disclosure_missing_is_named) :-
    findall(Result, accuracy_duty([attribute(section_8_3_in_force, true), attribute(acts_as_data_fiduciary, true), attribute(likely_used_for_decision_affecting_data_principal, false)], Result, _), Results),
    Results == [indeterminate([likely_disclosed_to_another_data_fiduciary])].
test(accuracy_disclosure_alone_is_enough) :-
    findall(Result, accuracy_duty([attribute(section_8_3_in_force, true), attribute(acts_as_data_fiduciary, true), attribute(likely_disclosed_to_another_data_fiduciary, true)], Result, _), Results),
    Results == [required].
test(erasure_processing_year_ending_before_commencement_needs_no_day) :-
    findall(Result, erasure_duty([attribute(section_8_7_in_force, true), attribute(acts_as_data_fiduciary, true), attribute(retention_necessary_for_compliance_with_law, false), attribute(consent_withdrawn, true), attribute(last_processing_date, date(2026, 5, 12)), attribute(data_made_available_to_data_processor, false)], Result, _), Results),
    Results == [erase].
test(erasure_processing_year_ending_on_commencement_names_the_day) :-
    findall(Result, erasure_duty([attribute(section_8_7_in_force, true), attribute(acts_as_data_fiduciary, true), attribute(retention_necessary_for_compliance_with_law, false), attribute(consent_withdrawn, true), attribute(last_processing_date, date(2026, 5, 13)), attribute(data_made_available_to_data_processor, false)], Result, _), Results),
    Results == [indeterminate([assessment_date])].
test(erasure_on_last_retention_day_reads_out_the_hold) :-
    dpdp_security_retention_profile_for(electronic_book_on_last_retention_day, Profile),
    findall(Result, erasure_duty(Profile, Result, _), Results),
    Results == [retain_until_minimum_retention_period_end].
test(erasure_rules_in_force_names_processing_date) :-
    findall(Result, erasure_duty([attribute(section_8_7_in_force, true), attribute(acts_as_data_fiduciary, true), attribute(retention_necessary_for_compliance_with_law, false), attribute(consent_withdrawn, true), attribute(assessment_date, date(2027, 5, 13))], Result, _), Results),
    Results == [indeterminate([last_processing_date])].
test(deemed_day_before_rules_is_not_in_force_without_section_key) :-
    findall(Result, third_schedule_deemed_no_longer_served([attribute(assessment_date, date(2027, 5, 12))], Result, _), Results),
    Results == [not_in_force].
test(deemed_on_floor_reads_out_not_yet) :-
    dpdp_security_retention_profile_for(e_commerce_on_deeming_floor, Profile),
    findall(Result - Citations, third_schedule_deemed_no_longer_served(Profile, Result, Citations), Answers),
    Answers == [not_yet_deemed - [cite(in_dpdp_rules_2025_r_8_1), cite(in_dpdp_rules_2025_r_8_2), cite(in_dpdp_rules_2025_sch_3_1), cite(in_dpdp_rules_2025_sch_3_1_a), cite(in_dpdp_rules_2025_sch_3_1_b)]].
test(deemed_day_after_floor_names_last_approach) :-
    dpdp_security_retention_profile_for(e_commerce_day_after_deeming_floor, Profile),
    findall(Result, third_schedule_deemed_no_longer_served(Profile, Result, _), Results),
    Results == [indeterminate([last_approached_date])].
test(deemed_gaming_at_threshold_reads_out_deemed) :-
    dpdp_security_retention_profile_for(gaming_at_threshold, Profile),
    findall(Result - Citations, third_schedule_deemed_no_longer_served(Profile, Result, Citations), Answers),
    Answers == [deemed_no_longer_served - [cite(in_dpdp_act_2023_s_8_8), cite(in_dpdp_act_2023_s_8_8_a), cite(in_dpdp_act_2023_s_8_8_b), cite(in_dpdp_act_2023_s_8_11), cite(in_dpdp_rules_2025_r_8_1), cite(in_dpdp_rules_2025_sch_3_2), cite(in_dpdp_rules_2025_sch_3_2_a), cite(in_dpdp_rules_2025_sch_3_2_b)]].
test(deemed_e_commerce_below_two_crore_is_not_listed) :-
    dpdp_security_retention_profile_for(e_commerce_below_threshold, Profile),
    findall(Result, third_schedule_deemed_no_longer_served(Profile, Result, _), Results),
    Results == [not_listed].
test(period_end_from_an_early_approach_is_commencement_plus_three_years) :-
    findall(date(YearNumber, MonthNumber, DayNumber), third_schedule_period_end(date(2026, 1, 1), date(YearNumber, MonthNumber, DayNumber)), Answers),
    Answers == [date(2030, 5, 13)],
    third_schedule_period_end(date(2026, 1, 1), date(EndYear, EndMonth, EndDayNumber)),
    integer(EndYear),
    integer(EndMonth),
    integer(EndDayNumber).
test(period_end_from_commencement_day) :-
    third_schedule_period_end(date(2027, 5, 13), date(YearNumber, MonthNumber, DayNumber)),
    YearNumber == 2030,
    MonthNumber == 5,
    DayNumber == 13.
test(period_end_from_the_day_after_commencement) :-
    third_schedule_period_end(date(2027, 5, 14), date(YearNumber, MonthNumber, DayNumber)),
    YearNumber == 2030,
    MonthNumber == 5,
    DayNumber == 14.
test(period_end_from_a_later_approach) :-
    third_schedule_period_end(date(2027, 6, 1), PeriodEnd),
    PeriodEnd == date(2030, 6, 1).
test(period_end_from_a_leap_day_is_28_february) :-
    third_schedule_period_end(date(2028, 2, 29), PeriodEnd),
    PeriodEnd == date(2031, 2, 28).
test(notice_day_from_an_early_approach) :-
    findall(NoticeDay, erasure_notice_latest_day(date(2026, 1, 1), NoticeDay), Answers),
    Answers == [date(2030, 5, 11)].
test(notice_day_crosses_a_month) :-
    erasure_notice_latest_day(date(2027, 6, 1), NoticeDay),
    NoticeDay == date(2030, 5, 30).
test(notice_day_crosses_a_year) :-
    erasure_notice_latest_day(date(2028, 1, 1), NoticeDay),
    NoticeDay == date(2030, 12, 30).
test(notice_day_from_a_leap_day) :-
    erasure_notice_latest_day(date(2028, 2, 29), NoticeDay),
    NoticeDay == date(2031, 2, 26).
test(retention_end_one_year_on) :-
    findall(RetentionEnd, processing_log_retention_minimum_end(date(2027, 1, 1), RetentionEnd), Answers),
    Answers == [date(2028, 1, 1)].
test(retention_end_from_a_leap_day) :-
    processing_log_retention_minimum_end(date(2024, 2, 29), RetentionEnd),
    RetentionEnd == date(2025, 2, 28).
test(retention_end_on_new_year_eve) :-
    processing_log_retention_minimum_end(date(2027, 12, 31), RetentionEnd),
    RetentionEnd == date(2028, 12, 31).
test(security_safeguard_minimum_is_one_list_of_seven) :-
    findall(Items, fixed_lists(security_safeguard_minimum, Items), Answers),
    Answers == [[content_item(data_security_measures_such_as_encryption_obfuscation_masking_or_virtual_tokens, cite(in_dpdp_rules_2025_r_6_1_a)), content_item(access_control_measures_for_computer_resources, cite(in_dpdp_rules_2025_r_6_1_b)), content_item(visibility_through_logs_monitoring_and_review, cite(in_dpdp_rules_2025_r_6_1_c)), content_item(continued_processing_measures_such_as_data_backups, cite(in_dpdp_rules_2025_r_6_1_d)), content_item(one_year_retention_of_logs_and_personal_data, cite(in_dpdp_rules_2025_r_6_1_e)), content_item(data_processor_contract_provision_for_security_safeguards, cite(in_dpdp_rules_2025_r_6_1_f)), content_item(technical_and_organisational_measures_for_security_safeguards, cite(in_dpdp_rules_2025_r_6_1_g))]].
test(seventh_schedule_purposes_is_one_list_of_four) :-
    findall(Items, fixed_lists(seventh_schedule_purposes, Items), Answers),
    Answers == [[content_item(state_use_for_sovereignty_integrity_or_security, cite(in_dpdp_rules_2025_sch_7_1)), content_item(state_use_for_performance_of_function_under_law, cite(in_dpdp_rules_2025_sch_7_2_i)), content_item(state_use_for_disclosure_to_fulfil_obligation_under_law, cite(in_dpdp_rules_2025_sch_7_2_ii)), content_item(assessment_for_notifying_significant_data_fiduciary, cite(in_dpdp_rules_2025_sch_7_3))]].
test(security_safeguard_minimum_read_out_directly) :-
    fixed_lists(security_safeguard_minimum, Items),
    ground(Items),
    Items == [content_item(data_security_measures_such_as_encryption_obfuscation_masking_or_virtual_tokens, cite(in_dpdp_rules_2025_r_6_1_a)), content_item(access_control_measures_for_computer_resources, cite(in_dpdp_rules_2025_r_6_1_b)), content_item(visibility_through_logs_monitoring_and_review, cite(in_dpdp_rules_2025_r_6_1_c)), content_item(continued_processing_measures_such_as_data_backups, cite(in_dpdp_rules_2025_r_6_1_d)), content_item(one_year_retention_of_logs_and_personal_data, cite(in_dpdp_rules_2025_r_6_1_e)), content_item(data_processor_contract_provision_for_security_safeguards, cite(in_dpdp_rules_2025_r_6_1_f)), content_item(technical_and_organisational_measures_for_security_safeguards, cite(in_dpdp_rules_2025_r_6_1_g))].
test(seventh_schedule_purposes_read_out_directly) :-
    fixed_lists(seventh_schedule_purposes, Items),
    ground(Items),
    Items == [content_item(state_use_for_sovereignty_integrity_or_security, cite(in_dpdp_rules_2025_sch_7_1)), content_item(state_use_for_performance_of_function_under_law, cite(in_dpdp_rules_2025_sch_7_2_i)), content_item(state_use_for_disclosure_to_fulfil_obligation_under_law, cite(in_dpdp_rules_2025_sch_7_2_ii)), content_item(assessment_for_notifying_significant_data_fiduciary, cite(in_dpdp_rules_2025_sch_7_3))].
test(seventh_schedule_purposes_hold_bound) :-
    fixed_lists(seventh_schedule_purposes, [content_item(state_use_for_sovereignty_integrity_or_security, cite(in_dpdp_rules_2025_sch_7_1)), content_item(state_use_for_performance_of_function_under_law, cite(in_dpdp_rules_2025_sch_7_2_i)), content_item(state_use_for_disclosure_to_fulfil_obligation_under_law, cite(in_dpdp_rules_2025_sch_7_2_ii)), content_item(assessment_for_notifying_significant_data_fiduciary, cite(in_dpdp_rules_2025_sch_7_3))]).
test(the_baseline_profile_yields_exactly_one_status) :-
    subject_status(processor_not_fiduciary, Statuses),
    Statuses == [no_section_8_duty_owed].
test(the_verdict_carries_a_citation) :-
    dpdp_security_retention_profile_for(processor_not_fiduciary, Profile),
    decide_dpdp_security_retention(Profile, dpdp_security_retention_verdict(_Status, [_FirstCitation|_OtherCitations])).
test(a_rejected_profile_carries_no_citation) :-
    dpdp_security_retention_profile_for(malformed_profile, Profile),
    findall(Verdict, decide_dpdp_security_retention(Profile, Verdict), Verdicts),
    Verdicts == [dpdp_security_retention_verdict(profile_rejected, [])].
test(deeming_floor_pair_statuses) :-
    subject_status(e_commerce_on_deeming_floor, FloorStatuses),
    FloorStatuses == [no_section_8_duty_owed],
    subject_status(e_commerce_day_after_deeming_floor, AfterStatuses),
    AfterStatuses == [section_8_duty_undetermined].
test(other_law_pair_statuses) :-
    subject_status(bank_account_closed, RetainStatuses),
    RetainStatuses == [section_8_duty_owed],
    subject_status(bank_no_other_law, NoLawStatuses),
    NoLawStatuses == [section_8_duty_undetermined].
test(the_checklist_cites_each_item) :-
    dpdp_security_retention_profile_for(processor_not_fiduciary, Profile),
    findall(Items, dpdp_security_retention_checklist(Profile, Items), Answers),
    Answers == [[item(security_safeguards_duty, not_required, [cite(in_dpdp_act_2023_s_8_5), cite(in_dpdp_act_2023_s_2_i)]), item(accuracy_duty, not_required, [cite(in_dpdp_act_2023_s_8_3), cite(in_dpdp_act_2023_s_8_3_a), cite(in_dpdp_act_2023_s_8_3_b), cite(in_dpdp_act_2023_s_2_i)]), item(erasure_duty, not_required, [cite(in_dpdp_act_2023_s_8_7), cite(in_dpdp_act_2023_s_2_i)]), item(third_schedule_deemed_no_longer_served, not_listed, [cite(in_dpdp_rules_2025_r_8_1), cite(in_dpdp_rules_2025_sch_3)])]].

cp_test_names([empty_profile_security_names_its_in_force_key, empty_profile_accuracy_names_its_in_force_key, empty_profile_erasure_names_its_in_force_key, empty_profile_deemed_names_its_in_force_key, security_on_commencement_day_reads_out_rule_6, security_day_before_reads_out_no_minimum, accuracy_decision_use_missing_is_named, accuracy_disclosure_missing_is_named, accuracy_disclosure_alone_is_enough, erasure_processing_year_ending_before_commencement_needs_no_day, erasure_processing_year_ending_on_commencement_names_the_day, erasure_on_last_retention_day_reads_out_the_hold, erasure_rules_in_force_names_processing_date, deemed_day_before_rules_is_not_in_force_without_section_key, deemed_on_floor_reads_out_not_yet, deemed_day_after_floor_names_last_approach, deemed_gaming_at_threshold_reads_out_deemed, deemed_e_commerce_below_two_crore_is_not_listed, period_end_from_an_early_approach_is_commencement_plus_three_years, period_end_from_commencement_day, period_end_from_the_day_after_commencement, period_end_from_a_later_approach, period_end_from_a_leap_day_is_28_february, notice_day_from_an_early_approach, notice_day_crosses_a_month, notice_day_crosses_a_year, notice_day_from_a_leap_day, retention_end_one_year_on, retention_end_from_a_leap_day, retention_end_on_new_year_eve, security_safeguard_minimum_is_one_list_of_seven, seventh_schedule_purposes_is_one_list_of_four, security_safeguard_minimum_read_out_directly, seventh_schedule_purposes_read_out_directly, seventh_schedule_purposes_hold_bound, the_baseline_profile_yields_exactly_one_status, the_verdict_carries_a_citation, a_rejected_profile_carries_no_citation, deeming_floor_pair_statuses, other_law_pair_statuses, the_checklist_cites_each_item]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
