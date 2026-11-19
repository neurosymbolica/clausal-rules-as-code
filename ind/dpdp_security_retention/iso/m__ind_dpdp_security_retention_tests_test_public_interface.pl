% SPDX-License-Identifier: EUPL-1.2
:- module(m__ind_dpdp_security_retention_tests_test_public_interface, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_lists_extra, [clausal_msort/2]).
:- use_module(m__ind_dpdp_security_retention_dpdp_security_retention, [decide_dpdp_security_retention/2, dpdp_security_retention_status/2, dpdp_security_retention_checklist/2, dpdp_security_retention_decision_resolvable/1, dpdp_security_retention_status_values/1, security_safeguards_duty/3, accuracy_duty/3, erasure_duty/3, third_schedule_deemed_no_longer_served/3, third_schedule_period_end/2, erasure_notice_latest_day/2, processing_log_retention_minimum_end/2, fixed_lists/2]).
:- use_module(m__ind_dpdp_security_retention_fixtures, [dpdp_security_retention_subject/1, dpdp_security_retention_profile_for/2, dpdp_security_retention_assess/2]).
:- use_module(m__ind_dpdp_security_retention_queries, [dpdp_security_retention_what_if/4]).
:- use_module(m__ind_dpdp_security_retention_kernel, [dpdp_security_retention_input_problems/2]).
:- use_module(m__ind_dpdp_security_retention_citations, [citation/2]).

expected_status(safeguards_on_commencement_day, section_8_duty_owed).
expected_status(safeguards_day_before_commencement, section_8_duty_owed).
expected_status(processor_not_fiduciary, no_section_8_duty_owed).
expected_status(processor_now_fiduciary, section_8_duty_owed).
expected_status(nothing_in_force, no_section_8_duty_owed).
expected_status(safeguards_only_in_force, section_8_duty_owed).
expected_status(marketplace_after_sale, section_8_duty_owed).
expected_status(bank_account_closed, section_8_duty_owed).
expected_status(bank_no_other_law, section_8_duty_undetermined).
expected_status(electronic_book_on_last_retention_day, section_8_duty_owed).
expected_status(cloud_processor_day_after_retention, section_8_duty_owed).
expected_status(social_media_on_period_end, no_section_8_duty_owed).
expected_status(social_media_day_after_period_end, no_section_8_duty_owed).
expected_status(gaming_at_threshold, no_section_8_duty_owed).
expected_status(gaming_below_threshold, no_section_8_duty_owed).
expected_status(e_commerce_on_deeming_floor, no_section_8_duty_owed).
expected_status(e_commerce_day_after_deeming_floor, section_8_duty_undetermined).
expected_status(e_commerce_below_threshold, no_section_8_duty_owed).
expected_status(accuracy_decision_use, section_8_duty_owed).
expected_status(accuracy_neither_likely, section_8_duty_undetermined).
expected_status(fiduciary_unsure_with_day, section_8_duty_undetermined).
expected_status(fiduciary_unsure_without_day, section_8_duty_undetermined).
expected_status(empty_profile, section_8_duty_undetermined).
expected_status(malformed_profile, profile_rejected).

subject_has_expected_status(Subject) :-
    expected_status(Subject, ExpectedStatus),
    dpdp_security_retention_profile_for(Subject, Profile),
    findall(Status, dpdp_security_retention_status(Profile, Status), Statuses),
    Statuses == [ExpectedStatus].

subject_has_checklist(Subject) :-
    dpdp_security_retention_profile_for(Subject, Profile),
    dpdp_security_retention_decision_resolvable(Profile),
    dpdp_security_retention_checklist(Profile, Items),
    length(Items, 4).

subject_answers(Subject, QueryName, Answers) :-
    dpdp_security_retention_profile_for(Subject, Profile),
    findall(Result - Citations, call(QueryName, Profile, Result, Citations), Answers).

status_in_vocabulary(StatusValues, Status) :-
    member(Status, StatusValues).

test(every_subject_has_an_expected_status) :-
    findall(Subject, dpdp_security_retention_subject(Subject), Subjects),
    findall(Subject, expected_status(Subject, _), ExpectedSubjects),
    clausal_msort(Subjects, SortedSubjects),
    clausal_msort(ExpectedSubjects, SortedExpectedSubjects),
    SortedSubjects == SortedExpectedSubjects.
test(every_subject_resolves_to_its_expected_status) :-
    findall(Subject, dpdp_security_retention_subject(Subject), Subjects),
    maplist(subject_has_expected_status, Subjects).
test(every_subject_has_a_four_item_checklist) :-
    findall(Subject, dpdp_security_retention_subject(Subject), Subjects),
    maplist(subject_has_checklist, Subjects).
test(every_status_is_in_the_vocabulary) :-
    dpdp_security_retention_status_values(StatusValues),
    findall(Status, expected_status(_, Status), Statuses),
    maplist(status_in_vocabulary(StatusValues), Statuses).
test(provenance_pairs_a_cited_key_with_its_source_record) :-
    findall(provenance(in_dpdp_act_2023_s_8_7_a, SourceRecord), citation(in_dpdp_act_2023_s_8_7_a, SourceRecord), Provenances),
    Provenances = [provenance(in_dpdp_act_2023_s_8_7_a, [label - _, ref - Reference, verbatim - _])],
    Reference == 'in-dpdp-act-2023-meity-pdf#s8_7_a'.
test(processor_not_fiduciary_owes_nothing) :-
    dpdp_security_retention_assess(processor_not_fiduciary, dpdp_security_retention_verdict(no_section_8_duty_owed, [_|_])).
test(processor_now_fiduciary_owes_a_duty) :-
    dpdp_security_retention_assess(processor_now_fiduciary, dpdp_security_retention_verdict(section_8_duty_owed, _)).
test(nothing_in_force_cites_every_in_force_provision) :-
    findall(Verdict, dpdp_security_retention_assess(nothing_in_force, Verdict), Verdicts),
    Verdicts == [dpdp_security_retention_verdict(no_section_8_duty_owed, [cite(in_dpdp_act_2023_s_8_3), cite(in_dpdp_act_2023_s_8_5), cite(in_dpdp_act_2023_s_8_7), cite(in_dpdp_act_2023_s_8_8), cite(in_dpdp_rules_2025_r_1_4), cite(in_dpdp_rules_2025_r_8_1)])].
test(safeguards_only_in_force_owes_a_duty) :-
    dpdp_security_retention_assess(safeguards_only_in_force, dpdp_security_retention_verdict(section_8_duty_owed, _)).
test(malformed_profile_is_rejected_without_citations) :-
    dpdp_security_retention_assess(malformed_profile, dpdp_security_retention_verdict(profile_rejected, [])).
test(empty_profile_is_undetermined) :-
    dpdp_security_retention_assess(empty_profile, dpdp_security_retention_verdict(section_8_duty_undetermined, [])).
test(what_if_turns_the_processor_into_a_fiduciary) :-
    dpdp_security_retention_profile_for(processor_not_fiduciary, Profile),
    findall(Status, dpdp_security_retention_what_if(Profile, acts_as_data_fiduciary, true, Status), Statuses),
    Statuses == [section_8_duty_owed].
test(safeguards_on_commencement_day_have_the_rule_6_minimum) :-
    subject_answers(safeguards_on_commencement_day, security_safeguards_duty, Answers),
    Answers == [required_with_rule_6_minimum - [cite(in_dpdp_act_2023_s_8_5), cite(in_dpdp_rules_2025_r_6_1)]].
test(safeguards_day_before_commencement_have_no_minimum) :-
    subject_answers(safeguards_day_before_commencement, security_safeguards_duty, Answers),
    Answers == [required_minimum_not_prescribed - [cite(in_dpdp_act_2023_s_8_5), cite(in_dpdp_rules_2025_r_1_4)]].
test(processor_owes_no_safeguards) :-
    subject_answers(processor_not_fiduciary, security_safeguards_duty, Answers),
    Answers == [not_required - [cite(in_dpdp_act_2023_s_8_5), cite(in_dpdp_act_2023_s_2_i)]].
test(nothing_in_force_safeguards_not_in_force) :-
    subject_answers(nothing_in_force, security_safeguards_duty, Answers),
    Answers == [not_in_force - [cite(in_dpdp_act_2023_s_8_5)]].
test(unsure_fiduciary_with_day_is_referred) :-
    subject_answers(fiduciary_unsure_with_day, security_safeguards_duty, Answers),
    Answers == [needs_legal_review(open_textured(acts_as_data_fiduciary, cite(in_dpdp_act_2023_s_2_i)), [inputs_relied_on([acts_as_data_fiduciary - unsure])]) - []].
test(unsure_fiduciary_without_day_names_the_day) :-
    subject_answers(fiduciary_unsure_without_day, security_safeguards_duty, Answers),
    Answers == [indeterminate([assessment_date]) - []].
test(malformed_profile_gives_its_input_problems) :-
    subject_answers(malformed_profile, security_safeguards_duty, Answers),
    Answers == [input_problems([wrong_type(section_8_5_in_force), unknown_key(colour)]) - []].
test(accuracy_decision_use_is_required) :-
    subject_answers(accuracy_decision_use, accuracy_duty, Answers),
    Answers == [required - [cite(in_dpdp_act_2023_s_8_3), cite(in_dpdp_act_2023_s_8_3_a), cite(in_dpdp_act_2023_s_8_3_b)]].
test(accuracy_neither_likely_is_not_required) :-
    subject_answers(accuracy_neither_likely, accuracy_duty, Answers),
    Answers == [not_required - [cite(in_dpdp_act_2023_s_8_3), cite(in_dpdp_act_2023_s_8_3_a), cite(in_dpdp_act_2023_s_8_3_b), cite(in_dpdp_act_2023_s_2_i)]].
test(accuracy_fiduciary_without_likelihoods_names_decision_use) :-
    subject_answers(processor_now_fiduciary, accuracy_duty, Answers),
    Answers == [indeterminate([likely_used_for_decision_affecting_data_principal]) - []].
test(marketplace_after_sale_erases) :-
    subject_answers(marketplace_after_sale, erasure_duty, Answers),
    Answers == [erase - [cite(in_dpdp_act_2023_s_8_7_a)]].
test(bank_account_closed_retains_for_other_law) :-
    subject_answers(bank_account_closed, erasure_duty, Answers),
    Answers == [retain_as_required_by_other_law - [cite(in_dpdp_act_2023_s_8_7)]].
test(bank_no_other_law_is_not_yet_required) :-
    subject_answers(bank_no_other_law, erasure_duty, Answers),
    Answers == [not_yet_required - [cite(in_dpdp_act_2023_s_8_7_a)]].
test(electronic_book_on_last_retention_day_is_held) :-
    subject_answers(electronic_book_on_last_retention_day, erasure_duty, Answers),
    Answers == [retain_until_minimum_retention_period_end - [cite(in_dpdp_act_2023_s_8_7_a), cite(in_dpdp_rules_2025_r_8_3)]].
test(cloud_processor_day_after_retention_erases_with_processor) :-
    subject_answers(cloud_processor_day_after_retention, erasure_duty, Answers),
    Answers == [erase_and_cause_data_processor_to_erase - [cite(in_dpdp_act_2023_s_8_7_a), cite(in_dpdp_act_2023_s_8_7_b)]].
test(processor_owes_no_erasure) :-
    subject_answers(processor_not_fiduciary, erasure_duty, Answers),
    Answers == [not_required - [cite(in_dpdp_act_2023_s_8_7), cite(in_dpdp_act_2023_s_2_i)]].
test(social_media_on_period_end_is_not_yet_deemed) :-
    subject_answers(social_media_on_period_end, third_schedule_deemed_no_longer_served, Answers),
    Answers == [not_yet_deemed - [cite(in_dpdp_rules_2025_r_8_1), cite(in_dpdp_rules_2025_r_8_2), cite(in_dpdp_rules_2025_sch_3_3), cite(in_dpdp_rules_2025_sch_3_3_a), cite(in_dpdp_rules_2025_sch_3_3_b)]].
test(social_media_day_after_period_end_is_deemed) :-
    subject_answers(social_media_day_after_period_end, third_schedule_deemed_no_longer_served, Answers),
    Answers == [deemed_no_longer_served - [cite(in_dpdp_act_2023_s_8_8), cite(in_dpdp_act_2023_s_8_8_a), cite(in_dpdp_act_2023_s_8_8_b), cite(in_dpdp_act_2023_s_8_11), cite(in_dpdp_rules_2025_r_8_1), cite(in_dpdp_rules_2025_sch_3_3), cite(in_dpdp_rules_2025_sch_3_3_a), cite(in_dpdp_rules_2025_sch_3_3_b)]].
test(gaming_at_threshold_is_deemed) :-
    subject_answers(gaming_at_threshold, third_schedule_deemed_no_longer_served, Answers),
    Answers == [deemed_no_longer_served - [cite(in_dpdp_act_2023_s_8_8), cite(in_dpdp_act_2023_s_8_8_a), cite(in_dpdp_act_2023_s_8_8_b), cite(in_dpdp_act_2023_s_8_11), cite(in_dpdp_rules_2025_r_8_1), cite(in_dpdp_rules_2025_sch_3_2), cite(in_dpdp_rules_2025_sch_3_2_a), cite(in_dpdp_rules_2025_sch_3_2_b)]].
test(gaming_below_threshold_is_not_listed) :-
    subject_answers(gaming_below_threshold, third_schedule_deemed_no_longer_served, Answers),
    Answers == [not_listed - [cite(in_dpdp_rules_2025_r_8_1), cite(in_dpdp_rules_2025_sch_3)]].
test(e_commerce_on_deeming_floor_is_not_yet_deemed) :-
    subject_answers(e_commerce_on_deeming_floor, third_schedule_deemed_no_longer_served, Answers),
    Answers == [not_yet_deemed - [cite(in_dpdp_rules_2025_r_8_1), cite(in_dpdp_rules_2025_r_8_2), cite(in_dpdp_rules_2025_sch_3_1), cite(in_dpdp_rules_2025_sch_3_1_a), cite(in_dpdp_rules_2025_sch_3_1_b)]].
test(e_commerce_day_after_deeming_floor_names_the_last_approach) :-
    subject_answers(e_commerce_day_after_deeming_floor, third_schedule_deemed_no_longer_served, Answers),
    Answers == [indeterminate([last_approached_date]) - []].
test(e_commerce_below_threshold_is_not_listed) :-
    subject_answers(e_commerce_below_threshold, third_schedule_deemed_no_longer_served, Answers),
    Answers == [not_listed - [cite(in_dpdp_rules_2025_r_8_1), cite(in_dpdp_rules_2025_sch_3)]].
test(deeming_day_before_commencement_is_not_in_force) :-
    subject_answers(safeguards_day_before_commencement, third_schedule_deemed_no_longer_served, Answers),
    Answers == [not_in_force - [cite(in_dpdp_act_2023_s_8_8), cite(in_dpdp_rules_2025_r_1_4), cite(in_dpdp_rules_2025_r_8_1)]].
test(deeming_on_commencement_day_names_the_class) :-
    subject_answers(safeguards_on_commencement_day, third_schedule_deemed_no_longer_served, Answers),
    Answers == [indeterminate([third_schedule_class]) - []].
test(period_end_runs_from_commencement) :-
    findall(EndDate, third_schedule_period_end(date(2020, 1, 1), EndDate), EndDates),
    EndDates == [date(2030, 5, 13)].
test(period_end_leap_day_goes_to_28_february) :-
    third_schedule_period_end(date(2028, 2, 29), date(2031, 2, 28)).
test(period_end_rejects_a_non_date) :-
    third_schedule_period_end(date(2027, 2, 29), input_problems([wrong_type(approach_date)])).
test(notice_day_from_a_leap_day) :-
    erasure_notice_latest_day(date(2028, 2, 29), date(2031, 2, 26)).
test(notice_day_borrows_a_month) :-
    erasure_notice_latest_day(date(2028, 3, 1), date(2031, 2, 27)).
test(notice_day_rejects_a_non_date) :-
    erasure_notice_latest_day(not_a_date, input_problems([wrong_type(approach_date)])).
test(retention_end_from_a_leap_day) :-
    processing_log_retention_minimum_end(date(2028, 2, 29), date(2029, 2, 28)).
test(retention_end_one_year_later) :-
    findall(EndDate, processing_log_retention_minimum_end(date(2026, 5, 12), EndDate), EndDates),
    EndDates == [date(2027, 5, 12)].
test(retention_end_rejects_a_non_date) :-
    processing_log_retention_minimum_end(date(2025, 13, 1), input_problems([wrong_type(processing_date)])).
test(safeguard_minimum_is_one_list_of_seven) :-
    findall(Items, fixed_lists(security_safeguard_minimum, Items), [Items]),
    length(Items, 7),
    Items = [content_item(data_security_measures_such_as_encryption_obfuscation_masking_or_virtual_tokens, cite(in_dpdp_rules_2025_r_6_1_a))|_].
test(seventh_schedule_purposes_is_one_list_of_four) :-
    findall(Items, fixed_lists(seventh_schedule_purposes, Items), [Items]),
    Items == [content_item(state_use_for_sovereignty_integrity_or_security, cite(in_dpdp_rules_2025_sch_7_1)), content_item(state_use_for_performance_of_function_under_law, cite(in_dpdp_rules_2025_sch_7_2_i)), content_item(state_use_for_disclosure_to_fulfil_obligation_under_law, cite(in_dpdp_rules_2025_sch_7_2_ii)), content_item(assessment_for_notifying_significant_data_fiduciary, cite(in_dpdp_rules_2025_sch_7_3))].
test(input_check_accepts_a_good_profile) :-
    dpdp_security_retention_profile_for(cloud_processor_day_after_retention, Profile),
    findall(Problems, dpdp_security_retention_input_problems(Profile, Problems), Answers),
    Answers == [[]].
test(input_check_names_a_duplicate_once) :-
    dpdp_security_retention_input_problems([attribute(consent_withdrawn, true), attribute(consent_withdrawn, true)], Problems),
    Problems == [duplicate_key(consent_withdrawn)].
test(input_check_rejects_a_non_list) :-
    dpdp_security_retention_input_problems(not_a_list, [wrong_type(profile)]).
test(input_check_rejects_a_float_count) :-
    dpdp_security_retention_input_problems([attribute(registered_users_in_india, 5000000.0)], [wrong_type(registered_users_in_india)]).

test(provenance_for_an_unrecorded_key_has_no_record, fail) :-
    citation(in_dpdp_act_2023_s_8_6, SourceRecord),
    provenance(in_dpdp_act_2023_s_8_6, SourceRecord) = provenance(_, _).
test(processor_now_fiduciary_is_not_clear, fail) :-
    dpdp_security_retention_assess(processor_now_fiduciary, dpdp_security_retention_verdict(no_section_8_duty_owed, _)).
test(empty_profile_is_not_rejected, fail) :-
    dpdp_security_retention_assess(empty_profile, dpdp_security_retention_verdict(profile_rejected, _)).
test(accuracy_neither_likely_is_not_required_duty, fail) :-
    dpdp_security_retention_profile_for(accuracy_neither_likely, Profile),
    accuracy_duty(Profile, required, _).
test(electronic_book_on_last_retention_day_is_not_erased, fail) :-
    dpdp_security_retention_profile_for(electronic_book_on_last_retention_day, Profile),
    erasure_duty(Profile, erase, _).
test(social_media_on_period_end_is_not_deemed, fail) :-
    dpdp_security_retention_profile_for(social_media_on_period_end, Profile),
    third_schedule_deemed_no_longer_served(Profile, deemed_no_longer_served, _).

cp_test_names([every_subject_has_an_expected_status, every_subject_resolves_to_its_expected_status, every_subject_has_a_four_item_checklist, every_status_is_in_the_vocabulary, provenance_pairs_a_cited_key_with_its_source_record, processor_not_fiduciary_owes_nothing, processor_now_fiduciary_owes_a_duty, nothing_in_force_cites_every_in_force_provision, safeguards_only_in_force_owes_a_duty, malformed_profile_is_rejected_without_citations, empty_profile_is_undetermined, what_if_turns_the_processor_into_a_fiduciary, safeguards_on_commencement_day_have_the_rule_6_minimum, safeguards_day_before_commencement_have_no_minimum, processor_owes_no_safeguards, nothing_in_force_safeguards_not_in_force, unsure_fiduciary_with_day_is_referred, unsure_fiduciary_without_day_names_the_day, malformed_profile_gives_its_input_problems, accuracy_decision_use_is_required, accuracy_neither_likely_is_not_required, accuracy_fiduciary_without_likelihoods_names_decision_use, marketplace_after_sale_erases, bank_account_closed_retains_for_other_law, bank_no_other_law_is_not_yet_required, electronic_book_on_last_retention_day_is_held, cloud_processor_day_after_retention_erases_with_processor, processor_owes_no_erasure, social_media_on_period_end_is_not_yet_deemed, social_media_day_after_period_end_is_deemed, gaming_at_threshold_is_deemed, gaming_below_threshold_is_not_listed, e_commerce_on_deeming_floor_is_not_yet_deemed, e_commerce_day_after_deeming_floor_names_the_last_approach, e_commerce_below_threshold_is_not_listed, deeming_day_before_commencement_is_not_in_force, deeming_on_commencement_day_names_the_class, period_end_runs_from_commencement, period_end_leap_day_goes_to_28_february, period_end_rejects_a_non_date, notice_day_from_a_leap_day, notice_day_borrows_a_month, notice_day_rejects_a_non_date, retention_end_from_a_leap_day, retention_end_one_year_later, retention_end_rejects_a_non_date, safeguard_minimum_is_one_list_of_seven, seventh_schedule_purposes_is_one_list_of_four, input_check_accepts_a_good_profile, input_check_names_a_duplicate_once, input_check_rejects_a_non_list, input_check_rejects_a_float_count]).
cp_test_fail_names([provenance_for_an_unrecorded_key_has_no_record, processor_now_fiduciary_is_not_clear, empty_profile_is_not_rejected, accuracy_neither_likely_is_not_required_duty, electronic_book_on_last_retention_day_is_not_erased, social_media_on_period_end_is_not_deemed]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
