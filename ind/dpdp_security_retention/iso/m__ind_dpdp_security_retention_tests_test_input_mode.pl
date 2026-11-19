% SPDX-License-Identifier: EUPL-1.2
:- module(m__ind_dpdp_security_retention_tests_test_input_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__ind_dpdp_security_retention_dpdp_security_retention, [security_safeguards_duty/3, accuracy_duty/3, erasure_duty/3, third_schedule_deemed_no_longer_served/3, third_schedule_period_end/2, erasure_notice_latest_day/2, processing_log_retention_minimum_end/2, dpdp_security_retention_status/2]).
:- use_module(m__ind_dpdp_security_retention_kernel, [dpdp_security_retention_input_problems/2]).
:- use_module(m__ind_dpdp_security_retention_fixtures, [dpdp_security_retention_profile_for/2]).

test(security_rule_6_minimum_holds_bound) :-
    dpdp_security_retention_profile_for(safeguards_on_commencement_day, Profile),
    security_safeguards_duty(Profile, required_with_rule_6_minimum, [cite(in_dpdp_act_2023_s_8_5), cite(in_dpdp_rules_2025_r_6_1)]).
test(security_minimum_not_prescribed_holds_bound) :-
    dpdp_security_retention_profile_for(safeguards_day_before_commencement, Profile),
    security_safeguards_duty(Profile, required_minimum_not_prescribed, [cite(in_dpdp_act_2023_s_8_5), cite(in_dpdp_rules_2025_r_1_4)]).
test(security_not_required_holds_bound) :-
    dpdp_security_retention_profile_for(processor_not_fiduciary, Profile),
    security_safeguards_duty(Profile, not_required, [cite(in_dpdp_act_2023_s_8_5), cite(in_dpdp_act_2023_s_2_i)]).
test(security_not_in_force_holds_bound) :-
    dpdp_security_retention_profile_for(nothing_in_force, Profile),
    security_safeguards_duty(Profile, not_in_force, [cite(in_dpdp_act_2023_s_8_5)]).
test(security_referral_holds_bound) :-
    dpdp_security_retention_profile_for(fiduciary_unsure_with_day, Profile),
    security_safeguards_duty(Profile, needs_legal_review(open_textured(acts_as_data_fiduciary, cite(in_dpdp_act_2023_s_2_i)), [inputs_relied_on([acts_as_data_fiduciary - unsure])]), []).
test(security_missing_day_holds_bound) :-
    dpdp_security_retention_profile_for(fiduciary_unsure_without_day, Profile),
    security_safeguards_duty(Profile, indeterminate([assessment_date]), []).
test(accuracy_required_holds_bound) :-
    dpdp_security_retention_profile_for(accuracy_decision_use, Profile),
    accuracy_duty(Profile, required, [cite(in_dpdp_act_2023_s_8_3), cite(in_dpdp_act_2023_s_8_3_a), cite(in_dpdp_act_2023_s_8_3_b)]).
test(accuracy_not_required_holds_bound) :-
    dpdp_security_retention_profile_for(accuracy_neither_likely, Profile),
    accuracy_duty(Profile, not_required, [cite(in_dpdp_act_2023_s_8_3), cite(in_dpdp_act_2023_s_8_3_a), cite(in_dpdp_act_2023_s_8_3_b), cite(in_dpdp_act_2023_s_2_i)]).
test(accuracy_not_in_force_holds_bound) :-
    dpdp_security_retention_profile_for(nothing_in_force, Profile),
    accuracy_duty(Profile, not_in_force, [cite(in_dpdp_act_2023_s_8_3)]).
test(erasure_other_law_holds_bound) :-
    dpdp_security_retention_profile_for(bank_account_closed, Profile),
    erasure_duty(Profile, retain_as_required_by_other_law, [cite(in_dpdp_act_2023_s_8_7)]).
test(erasure_not_yet_required_holds_bound) :-
    dpdp_security_retention_profile_for(bank_no_other_law, Profile),
    erasure_duty(Profile, not_yet_required, [cite(in_dpdp_act_2023_s_8_7_a)]).
test(erasure_hold_holds_bound) :-
    dpdp_security_retention_profile_for(electronic_book_on_last_retention_day, Profile),
    erasure_duty(Profile, retain_until_minimum_retention_period_end, [cite(in_dpdp_act_2023_s_8_7_a), cite(in_dpdp_rules_2025_r_8_3)]).
test(erasure_with_processor_holds_bound) :-
    dpdp_security_retention_profile_for(cloud_processor_day_after_retention, Profile),
    erasure_duty(Profile, erase_and_cause_data_processor_to_erase, [cite(in_dpdp_act_2023_s_8_7_a), cite(in_dpdp_act_2023_s_8_7_b)]).
test(erasure_erase_holds_bound) :-
    dpdp_security_retention_profile_for(marketplace_after_sale, Profile),
    erasure_duty(Profile, erase, [cite(in_dpdp_act_2023_s_8_7_a)]).
test(erasure_not_required_holds_bound) :-
    dpdp_security_retention_profile_for(processor_not_fiduciary, Profile),
    erasure_duty(Profile, not_required, [cite(in_dpdp_act_2023_s_8_7), cite(in_dpdp_act_2023_s_2_i)]).
test(erasure_not_in_force_holds_bound) :-
    dpdp_security_retention_profile_for(nothing_in_force, Profile),
    erasure_duty(Profile, not_in_force, [cite(in_dpdp_act_2023_s_8_7)]).
test(deemed_holds_bound) :-
    dpdp_security_retention_profile_for(social_media_day_after_period_end, Profile),
    third_schedule_deemed_no_longer_served(Profile, deemed_no_longer_served, [cite(in_dpdp_act_2023_s_8_8), cite(in_dpdp_act_2023_s_8_8_a), cite(in_dpdp_act_2023_s_8_8_b), cite(in_dpdp_act_2023_s_8_11), cite(in_dpdp_rules_2025_r_8_1), cite(in_dpdp_rules_2025_sch_3_3), cite(in_dpdp_rules_2025_sch_3_3_a), cite(in_dpdp_rules_2025_sch_3_3_b)]).
test(not_yet_deemed_holds_bound) :-
    dpdp_security_retention_profile_for(social_media_on_period_end, Profile),
    third_schedule_deemed_no_longer_served(Profile, not_yet_deemed, [cite(in_dpdp_rules_2025_r_8_1), cite(in_dpdp_rules_2025_r_8_2), cite(in_dpdp_rules_2025_sch_3_3), cite(in_dpdp_rules_2025_sch_3_3_a), cite(in_dpdp_rules_2025_sch_3_3_b)]).
test(not_listed_holds_bound) :-
    dpdp_security_retention_profile_for(gaming_below_threshold, Profile),
    third_schedule_deemed_no_longer_served(Profile, not_listed, [cite(in_dpdp_rules_2025_r_8_1), cite(in_dpdp_rules_2025_sch_3)]).
test(deemed_not_in_force_holds_bound) :-
    dpdp_security_retention_profile_for(nothing_in_force, Profile),
    third_schedule_deemed_no_longer_served(Profile, not_in_force, [cite(in_dpdp_act_2023_s_8_8), cite(in_dpdp_rules_2025_r_1_4), cite(in_dpdp_rules_2025_r_8_1)]).
test(status_owed_holds_bound) :-
    dpdp_security_retention_profile_for(processor_now_fiduciary, Profile),
    dpdp_security_retention_status(Profile, section_8_duty_owed).
test(status_not_owed_holds_bound) :-
    dpdp_security_retention_profile_for(processor_not_fiduciary, Profile),
    dpdp_security_retention_status(Profile, no_section_8_duty_owed).
test(period_end_holds_bound) :-
    third_schedule_period_end(date(2026, 1, 1), date(2030, 5, 13)).
test(notice_day_holds_bound) :-
    erasure_notice_latest_day(date(2027, 6, 1), date(2030, 5, 30)).
test(retention_end_holds_bound) :-
    processing_log_retention_minimum_end(date(2027, 1, 1), date(2028, 1, 1)).
test(an_unbound_profile_is_not_an_attribute_list) :-
    findall(Problems, dpdp_security_retention_input_problems(_UnboundProfile, Problems), Answers),
    Answers == [[wrong_type(profile)]].
test(a_partial_list_is_not_an_attribute_list) :-
    findall(Problems, dpdp_security_retention_input_problems([attribute(consent_withdrawn, true)|_RestOfProfile], Problems), Answers),
    Answers == [[wrong_type(profile)]].
test(an_unbound_element_is_not_an_attribute) :-
    findall(Problems, dpdp_security_retention_input_problems([attribute(consent_withdrawn, true), _UnboundElement], Problems), Answers),
    Answers == [[wrong_type(profile)]].
test(a_pair_element_is_not_an_attribute) :-
    dpdp_security_retention_input_problems([consent_withdrawn - true], Problems),
    Problems == [wrong_type(profile)].
test(an_atom_is_not_an_attribute_list) :-
    dpdp_security_retention_input_problems(not_a_list, Problems),
    Problems == [wrong_type(profile)].
test(an_unbound_key_is_named_as_given) :-
    findall(UnboundKey - Problems, dpdp_security_retention_input_problems([attribute(UnboundKey, true)], Problems), [NamedKey - NamedProblems]),
    NamedProblems == [unknown_key(NamedKey)],
    var(NamedKey).
test(a_number_key_is_unknown) :-
    dpdp_security_retention_input_problems([attribute(42, true)], Problems),
    Problems == [unknown_key(42)].
test(an_unbound_value_is_wrong_type) :-
    findall(Problems, dpdp_security_retention_input_problems([attribute(assessment_date, _UnboundValue)], Problems), Answers),
    Answers == [[wrong_type(assessment_date)]].
test(a_float_user_count_is_wrong_type) :-
    dpdp_security_retention_input_problems([attribute(registered_users_in_india, 5000000.0)], Problems),
    Problems == [wrong_type(registered_users_in_india)].
test(a_negative_user_count_is_wrong_type) :-
    dpdp_security_retention_input_problems([attribute(registered_users_in_india, -1)], Problems),
    Problems == [wrong_type(registered_users_in_india)].
test(a_zero_user_count_is_well_formed) :-
    dpdp_security_retention_input_problems([attribute(registered_users_in_india, 0)], Problems),
    Problems == [].
test(an_impossible_day_is_wrong_type) :-
    dpdp_security_retention_input_problems([attribute(assessment_date, date(2027, 2, 29))], Problems),
    Problems == [wrong_type(assessment_date)].
test(a_leap_day_is_well_formed) :-
    dpdp_security_retention_input_problems([attribute(last_processing_date, date(2028, 2, 29))], Problems),
    Problems == [].
test(year_zero_is_wrong_type) :-
    dpdp_security_retention_input_problems([attribute(last_approached_date, date(0, 1, 1))], Problems),
    Problems == [wrong_type(last_approached_date)].
test(a_crisp_key_given_unsure_is_wrong_type) :-
    dpdp_security_retention_input_problems([attribute(consent_withdrawn, unsure)], Problems),
    Problems == [wrong_type(consent_withdrawn)].
test(a_judgement_given_unsure_is_well_formed) :-
    dpdp_security_retention_input_problems([attribute(acts_as_data_fiduciary, unsure)], Problems),
    Problems == [].
test(an_unlisted_class_atom_is_wrong_type) :-
    dpdp_security_retention_input_problems([attribute(third_schedule_class, marketplace)], Problems),
    Problems == [wrong_type(third_schedule_class)].
test(a_duplicate_key_is_named_once_and_its_values_unread) :-
    dpdp_security_retention_input_problems([attribute(acts_as_data_fiduciary, true), attribute(acts_as_data_fiduciary, maybe)], Problems),
    Problems == [duplicate_key(acts_as_data_fiduciary)].
test(problems_come_in_contract_order_then_unknown_keys) :-
    dpdp_security_retention_input_problems([attribute(registered_users_in_india, -1), attribute(zeta, 1), attribute(consent_withdrawn, true), attribute(consent_withdrawn, false)], Problems),
    Problems == [duplicate_key(consent_withdrawn), wrong_type(registered_users_in_india), unknown_key(zeta)].
test(a_repeated_unknown_key_is_named_once) :-
    dpdp_security_retention_input_problems([attribute(colour, blue), attribute(colour, red)], Problems),
    Problems == [unknown_key(colour)].
test(the_malformed_fixture_has_two_problems) :-
    dpdp_security_retention_profile_for(malformed_profile, Profile),
    dpdp_security_retention_input_problems(Profile, Problems),
    Problems == [wrong_type(section_8_5_in_force), unknown_key(colour)].
test(every_profile_query_answers_the_input_problems) :-
    dpdp_security_retention_profile_for(malformed_profile, Profile),
    security_safeguards_duty(Profile, input_problems([wrong_type(section_8_5_in_force), unknown_key(colour)]), []),
    accuracy_duty(Profile, input_problems([wrong_type(section_8_5_in_force), unknown_key(colour)]), []),
    erasure_duty(Profile, input_problems([wrong_type(section_8_5_in_force), unknown_key(colour)]), []),
    third_schedule_deemed_no_longer_served(Profile, input_problems([wrong_type(section_8_5_in_force), unknown_key(colour)]), []).
test(a_non_list_profile_gets_input_problems_in_every_query) :-
    security_safeguards_duty(not_a_list, input_problems([wrong_type(profile)]), []),
    accuracy_duty(not_a_list, input_problems([wrong_type(profile)]), []),
    erasure_duty(not_a_list, input_problems([wrong_type(profile)]), []),
    third_schedule_deemed_no_longer_served(not_a_list, input_problems([wrong_type(profile)]), []).
test(an_unbound_approach_date_is_wrong_type) :-
    findall(PeriodEnd, third_schedule_period_end(_UnboundApproach, PeriodEnd), Answers),
    Answers == [input_problems([wrong_type(approach_date)])].
test(a_partial_approach_date_is_wrong_type) :-
    findall(NoticeDay, erasure_notice_latest_day(date(2027, _UnboundMonth, 1), NoticeDay), Answers),
    Answers == [input_problems([wrong_type(approach_date)])].
test(an_atom_processing_date_is_wrong_type) :-
    findall(RetentionEnd, processing_log_retention_minimum_end(yesterday, RetentionEnd), Answers),
    Answers == [input_problems([wrong_type(processing_date)])].
test(an_impossible_processing_date_is_wrong_type) :-
    processing_log_retention_minimum_end(date(2025, 2, 29), input_problems([wrong_type(processing_date)])).

test(security_day_before_is_not_rule_6_minimum, fail) :-
    dpdp_security_retention_profile_for(safeguards_day_before_commencement, Profile),
    security_safeguards_duty(Profile, required_with_rule_6_minimum, _).
test(security_commencement_day_is_not_minimum_not_prescribed, fail) :-
    dpdp_security_retention_profile_for(safeguards_on_commencement_day, Profile),
    security_safeguards_duty(Profile, required_minimum_not_prescribed, _).
test(accuracy_neither_likely_is_not_required_duty, fail) :-
    dpdp_security_retention_profile_for(accuracy_neither_likely, Profile),
    accuracy_duty(Profile, required, _).
test(erasure_last_retention_day_is_not_erase, fail) :-
    dpdp_security_retention_profile_for(electronic_book_on_last_retention_day, Profile),
    erasure_duty(Profile, erase, _).
test(period_end_day_is_not_deemed, fail) :-
    dpdp_security_retention_profile_for(social_media_on_period_end, Profile),
    third_schedule_deemed_no_longer_served(Profile, deemed_no_longer_served, _).
test(status_processor_is_not_owed, fail) :-
    dpdp_security_retention_profile_for(processor_not_fiduciary, Profile),
    dpdp_security_retention_status(Profile, section_8_duty_owed).
test(period_end_a_day_late_is_rejected, fail) :-
    third_schedule_period_end(date(2026, 1, 1), date(2030, 5, 14)).
test(a_malformed_profile_gets_no_duty, fail) :-
    dpdp_security_retention_profile_for(malformed_profile, Profile),
    security_safeguards_duty(Profile, not_in_force, _).

cp_test_names([security_rule_6_minimum_holds_bound, security_minimum_not_prescribed_holds_bound, security_not_required_holds_bound, security_not_in_force_holds_bound, security_referral_holds_bound, security_missing_day_holds_bound, accuracy_required_holds_bound, accuracy_not_required_holds_bound, accuracy_not_in_force_holds_bound, erasure_other_law_holds_bound, erasure_not_yet_required_holds_bound, erasure_hold_holds_bound, erasure_with_processor_holds_bound, erasure_erase_holds_bound, erasure_not_required_holds_bound, erasure_not_in_force_holds_bound, deemed_holds_bound, not_yet_deemed_holds_bound, not_listed_holds_bound, deemed_not_in_force_holds_bound, status_owed_holds_bound, status_not_owed_holds_bound, period_end_holds_bound, notice_day_holds_bound, retention_end_holds_bound, an_unbound_profile_is_not_an_attribute_list, a_partial_list_is_not_an_attribute_list, an_unbound_element_is_not_an_attribute, a_pair_element_is_not_an_attribute, an_atom_is_not_an_attribute_list, an_unbound_key_is_named_as_given, a_number_key_is_unknown, an_unbound_value_is_wrong_type, a_float_user_count_is_wrong_type, a_negative_user_count_is_wrong_type, a_zero_user_count_is_well_formed, an_impossible_day_is_wrong_type, a_leap_day_is_well_formed, year_zero_is_wrong_type, a_crisp_key_given_unsure_is_wrong_type, a_judgement_given_unsure_is_well_formed, an_unlisted_class_atom_is_wrong_type, a_duplicate_key_is_named_once_and_its_values_unread, problems_come_in_contract_order_then_unknown_keys, a_repeated_unknown_key_is_named_once, the_malformed_fixture_has_two_problems, every_profile_query_answers_the_input_problems, a_non_list_profile_gets_input_problems_in_every_query, an_unbound_approach_date_is_wrong_type, a_partial_approach_date_is_wrong_type, an_atom_processing_date_is_wrong_type, an_impossible_processing_date_is_wrong_type]).
cp_test_fail_names([security_day_before_is_not_rule_6_minimum, security_commencement_day_is_not_minimum_not_prescribed, accuracy_neither_likely_is_not_required_duty, erasure_last_retention_day_is_not_erase, period_end_day_is_not_deemed, status_processor_is_not_owed, period_end_a_day_late_is_rejected, a_malformed_profile_gets_no_duty]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
