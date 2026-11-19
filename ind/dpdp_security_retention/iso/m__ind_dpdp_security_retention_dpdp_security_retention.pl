% SPDX-License-Identifier: EUPL-1.2
:- module(m__ind_dpdp_security_retention_dpdp_security_retention, [security_safeguards_duty/3, accuracy_duty/3, erasure_duty/3, third_schedule_deemed_no_longer_served/3, third_schedule_period_end/2, erasure_notice_latest_day/2, processing_log_retention_minimum_end/2, fixed_lists/2, decide_dpdp_security_retention/2, dpdp_security_retention_status/2, dpdp_security_retention_checklist/2, dpdp_security_retention_decision_resolvable/1, dpdp_security_retention_status_values/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_lists_extra, [min_list/2]).
:- use_module(library(clpz)).
:- use_module(library(reif), [memberd_t/3]).
:- use_module(clausal_datetime, [timedelta/3, date_sub/3]).
:- use_module(formalize_lib, [profile_get/3, profile_lacks/2]).
:- use_module(m__ind_dpdp_security_retention_kernel, [dpdp_security_retention_input_problems/2, real_calendar_date_t/2, month_length/3]).
:- use_module(m__ind_dpdp_security_retention_citations, [implements/1]).

rules_six_and_eight_commencement(date(2027, 5, 13), cite(in_dpdp_rules_2025_r_1_4)).

third_schedule_item(e_commerce_entity, 20000000, cite(in_dpdp_rules_2025_sch_3_1), cite(in_dpdp_rules_2025_sch_3_1_a), cite(in_dpdp_rules_2025_sch_3_1_b)).
third_schedule_item(online_gaming_intermediary, 5000000, cite(in_dpdp_rules_2025_sch_3_2), cite(in_dpdp_rules_2025_sch_3_2_a), cite(in_dpdp_rules_2025_sch_3_2_b)).
third_schedule_item(social_media_intermediary, 20000000, cite(in_dpdp_rules_2025_sch_3_3), cite(in_dpdp_rules_2025_sch_3_3_a), cite(in_dpdp_rules_2025_sch_3_3_b)).

security_safeguard_minimum_item(data_security_measures_such_as_encryption_obfuscation_masking_or_virtual_tokens, cite(in_dpdp_rules_2025_r_6_1_a)).
security_safeguard_minimum_item(access_control_measures_for_computer_resources, cite(in_dpdp_rules_2025_r_6_1_b)).
security_safeguard_minimum_item(visibility_through_logs_monitoring_and_review, cite(in_dpdp_rules_2025_r_6_1_c)).
security_safeguard_minimum_item(continued_processing_measures_such_as_data_backups, cite(in_dpdp_rules_2025_r_6_1_d)).
security_safeguard_minimum_item(one_year_retention_of_logs_and_personal_data, cite(in_dpdp_rules_2025_r_6_1_e)).
security_safeguard_minimum_item(data_processor_contract_provision_for_security_safeguards, cite(in_dpdp_rules_2025_r_6_1_f)).
security_safeguard_minimum_item(technical_and_organisational_measures_for_security_safeguards, cite(in_dpdp_rules_2025_r_6_1_g)).

seventh_schedule_purpose_item(state_use_for_sovereignty_integrity_or_security, cite(in_dpdp_rules_2025_sch_7_1)).
seventh_schedule_purpose_item(state_use_for_performance_of_function_under_law, cite(in_dpdp_rules_2025_sch_7_2_i)).
seventh_schedule_purpose_item(state_use_for_disclosure_to_fulfil_obligation_under_law, cite(in_dpdp_rules_2025_sch_7_2_ii)).
seventh_schedule_purpose_item(assessment_for_notifying_significant_data_fiduciary, cite(in_dpdp_rules_2025_sch_7_3)).

accuracy_referral(fiduciary, acts_as_data_fiduciary, cite(in_dpdp_act_2023_s_2_i)).
accuracy_referral(decision_use, likely_used_for_decision_affecting_data_principal, cite(in_dpdp_act_2023_s_8_3_a)).
accuracy_referral(disclosure, likely_disclosed_to_another_data_fiduciary, cite(in_dpdp_act_2023_s_8_3_b)).

erasure_referral(fiduciary, acts_as_data_fiduciary, cite(in_dpdp_act_2023_s_2_i)).
erasure_referral(retention, retention_necessary_for_compliance_with_law, cite(in_dpdp_act_2023_s_8_7)).
erasure_referral(purpose, specified_purpose_no_longer_served, cite(in_dpdp_act_2023_s_8_7_a)).

dpdp_security_retention_status_values([section_8_duty_owed, no_section_8_duty_owed, section_8_duty_undetermined, profile_rejected]).

profile_key_state(Profile, ProfileKey, absent) :-
    profile_lacks(Profile, ProfileKey).
profile_key_state(Profile, ProfileKey, present(Value)) :-
    profile_get(Profile, ProfileKey, Value).

present_pairs(_, [], []).
present_pairs(Profile, [ProfileKey|ProfileKeys], Pairs) :-
    profile_key_state(Profile, ProfileKey, State),
    present_pairs(Profile, ProfileKeys, LaterPairs),
    add_pair(State, ProfileKey, LaterPairs, Pairs).

add_pair(absent, _, LaterPairs, LaterPairs).
add_pair(present(Value), ProfileKey, LaterPairs, [ProfileKey - Value|LaterPairs]).

calendar_day_number(date(YearNumber, MonthNumber, DayNumber), Ordering) :-
    Ordering #= YearNumber * 10000 + MonthNumber * 100 + DayNumber.

calendar_day_before(EarlierDate, LaterDate) :-
    calendar_day_number(EarlierDate, EarlierNumber),
    calendar_day_number(LaterDate, LaterNumber),
    EarlierNumber #< LaterNumber.

calendar_day_on_or_before(EarlierDate, LaterDate) :-
    calendar_day_number(EarlierDate, EarlierNumber),
    calendar_day_number(LaterDate, LaterNumber),
    EarlierNumber #=< LaterNumber.

later_day(FirstDate, SecondDate, SecondDate) :-
    calendar_day_on_or_before(FirstDate, SecondDate).
later_day(FirstDate, SecondDate, FirstDate) :-
    calendar_day_before(SecondDate, FirstDate).

commencement_date(CommencementDate) :-
    implements(in_dpdp_rules_2025_r_1_4),
    rules_six_and_eight_commencement(CommencementDate, _).

year_rule_add(date(YearNumber, MonthNumber, DayNumber), Years, date(TargetYear, MonthNumber, TargetDayNumber)) :-
    TargetYear #= YearNumber + Years,
    month_length(TargetYear, MonthNumber, MonthDays),
    year_rule_day(DayNumber, MonthDays, TargetDayNumber).

year_rule_day(DayNumber, MonthDays, DayNumber) :-
    DayNumber #=< MonthDays.
year_rule_day(DayNumber, MonthDays, MonthDays) :-
    DayNumber #> MonthDays.

period_end_date(ApproachDate, PeriodEndDate) :-
    implements(in_dpdp_rules_2025_sch_3),
    commencement_date(CommencementDate),
    later_day(ApproachDate, CommencementDate, StartDate),
    PeriodYears #= 3,
    year_rule_add(StartDate, PeriodYears, PeriodEndDate).

earliest_period_end_date(EarliestEndDate) :-
    implements(in_dpdp_rules_2025_sch_3),
    commencement_date(CommencementDate),
    period_end_date(CommencementDate, EarliestEndDate).

erasure_notice_day(ApproachDate, date(NoticeYear, NoticeMonth, NoticeDayNumber)) :-
    implements(in_dpdp_rules_2025_r_8_2),
    period_end_date(ApproachDate, PeriodEndDate),
    LeadDays #= 2,
    timedelta(LeadDays, 0, NoticeLead),
    date_sub(PeriodEndDate, NoticeLead, date(NoticeYear, NoticeMonth, NoticeDayNumber)).

retention_minimum_end_date(ProcessingDate, RetentionEndDate) :-
    implements(in_dpdp_rules_2025_r_8_3),
    RetentionYears #= 1,
    year_rule_add(ProcessingDate, RetentionYears, RetentionEndDate).

lowest_third_schedule_threshold(LowestThreshold) :-
    implements(in_dpdp_rules_2025_sch_3),
    findall(Threshold, third_schedule_item(_, Threshold, _, _, _), Thresholds),
    min_list(Thresholds, LowestThreshold).

third_schedule_period_end(ApproachDate, PeriodEnd) :-
    real_calendar_date_t(ApproachDate, IsRealDate),
    period_end_answer(IsRealDate, ApproachDate, PeriodEnd).

period_end_answer(false, _, input_problems([wrong_type(approach_date)])).
period_end_answer(true, ApproachDate, PeriodEndDate) :-
    period_end_date(ApproachDate, PeriodEndDate).

erasure_notice_latest_day(ApproachDate, NoticeDay) :-
    real_calendar_date_t(ApproachDate, IsRealDate),
    notice_day_answer(IsRealDate, ApproachDate, NoticeDay).

notice_day_answer(false, _, input_problems([wrong_type(approach_date)])).
notice_day_answer(true, ApproachDate, NoticeDate) :-
    erasure_notice_day(ApproachDate, NoticeDate).

processing_log_retention_minimum_end(ProcessingDate, RetentionEnd) :-
    real_calendar_date_t(ProcessingDate, IsRealDate),
    retention_end_answer(IsRealDate, ProcessingDate, RetentionEnd).

retention_end_answer(false, _, input_problems([wrong_type(processing_date)])).
retention_end_answer(true, ProcessingDate, RetentionEndDate) :-
    retention_minimum_end_date(ProcessingDate, RetentionEndDate).

fixed_lists(security_safeguard_minimum, Items) :-
    implements(in_dpdp_rules_2025_r_6_1),
    findall(content_item(Name, Citation), security_safeguard_minimum_item(Name, Citation), Items).
fixed_lists(seventh_schedule_purposes, Items) :-
    implements(in_dpdp_rules_2025_r_8_3),
    findall(content_item(Name, Citation), seventh_schedule_purpose_item(Name, Citation), Items).

fiduciary_affirmed_or_unsure(present(true)).
fiduciary_affirmed_or_unsure(present(unsure)).

fiduciary_not_denied(absent).
fiduciary_not_denied(present(true)).
fiduciary_not_denied(present(unsure)).

security_safeguards_duty(Profile, input_problems([Problem|Problems]), []) :-
    dpdp_security_retention_input_problems(Profile, [Problem|Problems]).
security_safeguards_duty(Profile, Result, Citations) :-
    dpdp_security_retention_input_problems(Profile, []),
    profile_key_state(Profile, section_8_5_in_force, InForce),
    profile_key_state(Profile, acts_as_data_fiduciary, Fiduciary),
    profile_key_state(Profile, assessment_date, Assessment),
    security_route(InForce, Fiduciary, Assessment, Profile, Result, Citations).

security_route(absent, _, _, _, indeterminate([section_8_5_in_force]), []).
security_route(present(false), _, _, _, not_in_force, [cite(in_dpdp_act_2023_s_8_5)]) :-
    implements(in_dpdp_act_2023_s_8_5).
security_route(present(true), present(false), _, _, not_required, [cite(in_dpdp_act_2023_s_8_5), cite(in_dpdp_act_2023_s_2_i)]) :-
    implements(in_dpdp_act_2023_s_2_i).
security_route(present(true), absent, _, _, indeterminate([acts_as_data_fiduciary]), []).
security_route(present(true), Fiduciary, absent, _, indeterminate([assessment_date]), []) :-
    fiduciary_affirmed_or_unsure(Fiduciary).
security_route(present(true), present(unsure), present(_), Profile, needs_legal_review(open_textured(acts_as_data_fiduciary, cite(in_dpdp_act_2023_s_2_i)), [inputs_relied_on(Pairs)]), []) :-
    implements(in_dpdp_act_2023_s_2_i),
    present_pairs(Profile, [acts_as_data_fiduciary], Pairs).
security_route(present(true), present(true), present(AssessmentDate), _, required_minimum_not_prescribed, [cite(in_dpdp_act_2023_s_8_5), cite(in_dpdp_rules_2025_r_1_4)]) :-
    implements(in_dpdp_rules_2025_r_1_4),
    commencement_date(CommencementDate),
    calendar_day_before(AssessmentDate, CommencementDate).
security_route(present(true), present(true), present(AssessmentDate), _, required_with_rule_6_minimum, [cite(in_dpdp_act_2023_s_8_5), cite(in_dpdp_rules_2025_r_6_1)]) :-
    implements(in_dpdp_rules_2025_r_6_1),
    commencement_date(CommencementDate),
    calendar_day_on_or_before(CommencementDate, AssessmentDate).

accuracy_duty(Profile, input_problems([Problem|Problems]), []) :-
    dpdp_security_retention_input_problems(Profile, [Problem|Problems]).
accuracy_duty(Profile, Result, Citations) :-
    dpdp_security_retention_input_problems(Profile, []),
    profile_key_state(Profile, section_8_3_in_force, InForce),
    accuracy_after_in_force(InForce, Profile, Result, Citations).

accuracy_after_in_force(absent, _, indeterminate([section_8_3_in_force]), []).
accuracy_after_in_force(present(false), _, not_in_force, [cite(in_dpdp_act_2023_s_8_3)]) :-
    implements(in_dpdp_act_2023_s_8_3).
accuracy_after_in_force(present(true), Profile, Result, Citations) :-
    profile_key_state(Profile, acts_as_data_fiduciary, Fiduciary),
    profile_key_state(Profile, likely_used_for_decision_affecting_data_principal, DecisionUse),
    profile_key_state(Profile, likely_disclosed_to_another_data_fiduciary, Disclosure),
    likelihood_class(DecisionUse, Disclosure, Class),
    accuracy_route(Fiduciary, Class, Profile, Result, Citations).

likelihood_class(present(true), _, some_true).
likelihood_class(absent, present(true), some_true).
likelihood_class(absent, present(false), used_missing).
likelihood_class(absent, present(unsure), used_missing).
likelihood_class(absent, absent, used_missing).
likelihood_class(present(false), present(true), some_true).
likelihood_class(present(false), present(false), both_false).
likelihood_class(present(false), absent, disclosed_missing).
likelihood_class(present(false), present(unsure), disclosed_unsure).
likelihood_class(present(unsure), present(true), some_true).
likelihood_class(present(unsure), absent, disclosed_missing).
likelihood_class(present(unsure), present(false), used_unsure).
likelihood_class(present(unsure), present(unsure), used_unsure).

fiduciary_referable_class(some_true).
fiduciary_referable_class(used_unsure).
fiduciary_referable_class(disclosed_unsure).

accuracy_route(present(false), _, _, not_required, [cite(in_dpdp_act_2023_s_8_3), cite(in_dpdp_act_2023_s_8_3_a), cite(in_dpdp_act_2023_s_8_3_b), cite(in_dpdp_act_2023_s_2_i)]) :-
    implements(in_dpdp_act_2023_s_2_i).
accuracy_route(Fiduciary, both_false, _, not_required, [cite(in_dpdp_act_2023_s_8_3), cite(in_dpdp_act_2023_s_8_3_a), cite(in_dpdp_act_2023_s_8_3_b), cite(in_dpdp_act_2023_s_2_i)]) :-
    implements(in_dpdp_act_2023_s_8_3),
    fiduciary_not_denied(Fiduciary).
accuracy_route(absent, Class, _, indeterminate([acts_as_data_fiduciary]), []) :-
    dif(Class, both_false).
accuracy_route(present(true), some_true, _, required, [cite(in_dpdp_act_2023_s_8_3), cite(in_dpdp_act_2023_s_8_3_a), cite(in_dpdp_act_2023_s_8_3_b)]) :-
    implements(in_dpdp_act_2023_s_8_3).
accuracy_route(Fiduciary, used_missing, _, indeterminate([likely_used_for_decision_affecting_data_principal]), []) :-
    fiduciary_affirmed_or_unsure(Fiduciary).
accuracy_route(Fiduciary, disclosed_missing, _, indeterminate([likely_disclosed_to_another_data_fiduciary]), []) :-
    fiduciary_affirmed_or_unsure(Fiduciary).
accuracy_route(present(unsure), Class, Profile, Result, []) :-
    implements(in_dpdp_act_2023_s_2_i),
    fiduciary_referable_class(Class),
    accuracy_referral_answer(fiduciary, Profile, Result).
accuracy_route(present(true), used_unsure, Profile, Result, []) :-
    implements(in_dpdp_act_2023_s_8_3_a),
    accuracy_referral_answer(decision_use, Profile, Result).
accuracy_route(present(true), disclosed_unsure, Profile, Result, []) :-
    implements(in_dpdp_act_2023_s_8_3_b),
    accuracy_referral_answer(disclosure, Profile, Result).

accuracy_referral_answer(Referral, Profile, needs_legal_review(open_textured(InputKey, Citation), [inputs_relied_on(Pairs)])) :-
    accuracy_referral(Referral, InputKey, Citation),
    present_pairs(Profile, [acts_as_data_fiduciary, likely_used_for_decision_affecting_data_principal, likely_disclosed_to_another_data_fiduciary], Pairs).

erasure_duty(Profile, input_problems([Problem|Problems]), []) :-
    dpdp_security_retention_input_problems(Profile, [Problem|Problems]).
erasure_duty(Profile, Result, Citations) :-
    dpdp_security_retention_input_problems(Profile, []),
    profile_key_state(Profile, section_8_7_in_force, InForce),
    erasure_after_in_force(InForce, Profile, Result, Citations).

erasure_after_in_force(absent, _, indeterminate([section_8_7_in_force]), []).
erasure_after_in_force(present(false), _, not_in_force, [cite(in_dpdp_act_2023_s_8_7)]) :-
    implements(in_dpdp_act_2023_s_8_7).
erasure_after_in_force(present(true), Profile, Result, Citations) :-
    profile_key_state(Profile, acts_as_data_fiduciary, Fiduciary),
    erasure_after_fiduciary(Fiduciary, Profile, Result, Citations).

erasure_after_fiduciary(present(false), _, not_required, [cite(in_dpdp_act_2023_s_8_7), cite(in_dpdp_act_2023_s_2_i)]) :-
    implements(in_dpdp_act_2023_s_2_i).
erasure_after_fiduciary(absent, _, indeterminate([acts_as_data_fiduciary]), []).
erasure_after_fiduciary(present(true), Profile, Result, Citations) :-
    profile_key_state(Profile, retention_necessary_for_compliance_with_law, Retention),
    erasure_after_retention(Retention, true, Profile, Result, Citations).
erasure_after_fiduciary(present(unsure), Profile, Result, Citations) :-
    profile_key_state(Profile, retention_necessary_for_compliance_with_law, Retention),
    erasure_after_retention(Retention, unsure, Profile, Result, Citations).

erasure_after_retention(present(true), true, _, retain_as_required_by_other_law, [cite(in_dpdp_act_2023_s_8_7)]) :-
    implements(in_dpdp_act_2023_s_8_7).
erasure_after_retention(present(true), unsure, Profile, Result, []) :-
    erasure_referral_answer(fiduciary, Profile, Result).
erasure_after_retention(absent, _, _, indeterminate([retention_necessary_for_compliance_with_law]), []).
erasure_after_retention(present(false), Fiduciary, Profile, Result, Citations) :-
    erasure_triggers(Fiduciary, false, Profile, Result, Citations).
erasure_after_retention(present(unsure), Fiduciary, Profile, Result, Citations) :-
    erasure_triggers(Fiduciary, unsure, Profile, Result, Citations).

erasure_triggers(Fiduciary, Retention, Profile, Result, Citations) :-
    implements(in_dpdp_act_2023_s_8_7_a),
    profile_key_state(Profile, consent_withdrawn, Consent),
    profile_key_state(Profile, specified_purpose_no_longer_served, Purpose),
    trigger_class(Consent, Purpose, TriggerClass),
    referral_class(Fiduciary, Retention, Consent, Purpose, Referral),
    erasure_after_triggers(TriggerClass, Referral, Profile, Result, Citations).

trigger_class(absent, absent, consent_missing).
trigger_class(absent, present(false), consent_missing).
trigger_class(absent, present(unsure), consent_missing).
trigger_class(absent, present(true), open).
trigger_class(present(true), _, open).
trigger_class(present(false), absent, purpose_missing).
trigger_class(present(false), present(false), closed).
trigger_class(present(false), present(unsure), open).
trigger_class(present(false), present(true), open).

referral_class(unsure, _, _, _, fiduciary).
referral_class(true, unsure, _, _, retention).
referral_class(true, false, Consent, Purpose, Referral) :-
    purpose_referral(Consent, Purpose, Referral).

purpose_referral(present(true), _, none).
purpose_referral(absent, _, none).
purpose_referral(present(false), Purpose, Referral) :-
    purpose_referral_without_withdrawal(Purpose, Referral).

purpose_referral_without_withdrawal(present(unsure), purpose).
purpose_referral_without_withdrawal(present(true), none).
purpose_referral_without_withdrawal(present(false), none).
purpose_referral_without_withdrawal(absent, none).

erasure_after_triggers(consent_missing, _, _, indeterminate([consent_withdrawn]), []).
erasure_after_triggers(purpose_missing, _, _, indeterminate([specified_purpose_no_longer_served]), []).
erasure_after_triggers(closed, Referral, Profile, Result, Citations) :-
    erasure_after_referrals(Referral, not_yet, Profile, Result, Citations).
erasure_after_triggers(open, Referral, Profile, Result, Citations) :-
    profile_key_state(Profile, assessment_date, Assessment),
    profile_key_state(Profile, last_processing_date, Processing),
    profile_key_state(Profile, data_made_available_to_data_processor, Available),
    hold_class(Assessment, Processing, HoldClass),
    hold_route(HoldClass, HoldRoute),
    erasure_open_route(HoldRoute, Available, Referral, Profile, Result, Citations).

hold_class(absent, absent, assessment_missing).
hold_class(absent, present(ProcessingDate), assessment_missing) :-
    implements(in_dpdp_rules_2025_r_8_3),
    retention_minimum_end_date(ProcessingDate, RetentionEndDate),
    commencement_date(CommencementDate),
    calendar_day_on_or_before(CommencementDate, RetentionEndDate).
hold_class(absent, present(ProcessingDate), hold_ruled_out) :-
    implements(in_dpdp_rules_2025_r_8_3),
    retention_minimum_end_date(ProcessingDate, RetentionEndDate),
    commencement_date(CommencementDate),
    calendar_day_before(RetentionEndDate, CommencementDate).
hold_class(present(AssessmentDate), _, before_rules) :-
    implements(in_dpdp_rules_2025_r_1_4),
    commencement_date(CommencementDate),
    calendar_day_before(AssessmentDate, CommencementDate).
hold_class(present(AssessmentDate), absent, processing_missing) :-
    implements(in_dpdp_rules_2025_r_1_4),
    commencement_date(CommencementDate),
    calendar_day_on_or_before(CommencementDate, AssessmentDate).
hold_class(present(AssessmentDate), present(ProcessingDate), in_window) :-
    implements(in_dpdp_rules_2025_r_8_3),
    commencement_date(CommencementDate),
    calendar_day_on_or_before(CommencementDate, AssessmentDate),
    retention_minimum_end_date(ProcessingDate, RetentionEndDate),
    calendar_day_on_or_before(AssessmentDate, RetentionEndDate).
hold_class(present(AssessmentDate), present(ProcessingDate), window_passed) :-
    implements(in_dpdp_rules_2025_r_8_3),
    commencement_date(CommencementDate),
    calendar_day_on_or_before(CommencementDate, AssessmentDate),
    retention_minimum_end_date(ProcessingDate, RetentionEndDate),
    calendar_day_before(RetentionEndDate, AssessmentDate).

hold_route(assessment_missing, ask_assessment).
hold_route(processing_missing, ask_processing).
hold_route(in_window, hold).
hold_route(hold_ruled_out, erasure).
hold_route(before_rules, erasure).
hold_route(window_passed, erasure).

erasure_open_route(ask_assessment, _, _, _, indeterminate([assessment_date]), []).
erasure_open_route(ask_processing, _, _, _, indeterminate([last_processing_date]), []).
erasure_open_route(erasure, absent, _, _, indeterminate([data_made_available_to_data_processor]), []).
erasure_open_route(erasure, present(true), Referral, Profile, Result, Citations) :-
    erasure_after_referrals(Referral, erase_with_processor, Profile, Result, Citations).
erasure_open_route(erasure, present(false), Referral, Profile, Result, Citations) :-
    erasure_after_referrals(Referral, erase_only, Profile, Result, Citations).
erasure_open_route(hold, _, Referral, Profile, Result, Citations) :-
    erasure_after_referrals(Referral, hold, Profile, Result, Citations).

erasure_after_referrals(none, Outcome, _, Result, Citations) :-
    erasure_outcome(Outcome, Result, Citations).
erasure_after_referrals(Referral, _, Profile, Result, []) :-
    erasure_referral_answer(Referral, Profile, Result).

erasure_outcome(not_yet, not_yet_required, [cite(in_dpdp_act_2023_s_8_7_a)]) :-
    implements(in_dpdp_act_2023_s_8_7_a).
erasure_outcome(hold, retain_until_minimum_retention_period_end, [cite(in_dpdp_act_2023_s_8_7_a), cite(in_dpdp_rules_2025_r_8_3)]) :-
    implements(in_dpdp_rules_2025_r_8_3).
erasure_outcome(erase_with_processor, erase_and_cause_data_processor_to_erase, [cite(in_dpdp_act_2023_s_8_7_a), cite(in_dpdp_act_2023_s_8_7_b)]) :-
    implements(in_dpdp_act_2023_s_8_7_b).
erasure_outcome(erase_only, erase, [cite(in_dpdp_act_2023_s_8_7_a)]) :-
    implements(in_dpdp_act_2023_s_8_7_a).

erasure_referral_answer(Referral, Profile, needs_legal_review(open_textured(InputKey, Citation), [inputs_relied_on(Pairs)])) :-
    erasure_referral(Referral, InputKey, Citation),
    present_pairs(Profile, [acts_as_data_fiduciary, retention_necessary_for_compliance_with_law, specified_purpose_no_longer_served], Pairs).

third_schedule_deemed_no_longer_served(Profile, input_problems([Problem|Problems]), []) :-
    dpdp_security_retention_input_problems(Profile, [Problem|Problems]).
third_schedule_deemed_no_longer_served(Profile, Result, Citations) :-
    dpdp_security_retention_input_problems(Profile, []),
    profile_key_state(Profile, assessment_date, Assessment),
    deemed_date_class(Assessment, DateClass),
    deemed_after_date(DateClass, Profile, Result, Citations).

deemed_date_class(absent, assessment_missing).
deemed_date_class(present(AssessmentDate), before_rules) :-
    implements(in_dpdp_rules_2025_r_1_4),
    commencement_date(CommencementDate),
    calendar_day_before(AssessmentDate, CommencementDate).
deemed_date_class(present(AssessmentDate), rules_in_force(AssessmentDate)) :-
    implements(in_dpdp_rules_2025_r_1_4),
    commencement_date(CommencementDate),
    calendar_day_on_or_before(CommencementDate, AssessmentDate).

deemed_after_date(before_rules, _, not_in_force, [cite(in_dpdp_act_2023_s_8_8), cite(in_dpdp_rules_2025_r_1_4), cite(in_dpdp_rules_2025_r_8_1)]) :-
    implements(in_dpdp_rules_2025_r_8_1).
deemed_after_date(assessment_missing, Profile, Result, Citations) :-
    profile_key_state(Profile, section_8_8_in_force, InForce),
    deemed_after_section(InForce, assessment_missing, Profile, Result, Citations).
deemed_after_date(rules_in_force(AssessmentDate), Profile, Result, Citations) :-
    profile_key_state(Profile, section_8_8_in_force, InForce),
    deemed_after_section(InForce, rules_in_force(AssessmentDate), Profile, Result, Citations).

deemed_after_section(absent, _, _, indeterminate([section_8_8_in_force]), []).
deemed_after_section(present(false), _, _, not_in_force, [cite(in_dpdp_act_2023_s_8_8), cite(in_dpdp_rules_2025_r_1_4), cite(in_dpdp_rules_2025_r_8_1)]) :-
    implements(in_dpdp_act_2023_s_8_8).
deemed_after_section(present(true), assessment_missing, _, indeterminate([assessment_date]), []).
deemed_after_section(present(true), rules_in_force(AssessmentDate), Profile, Result, Citations) :-
    profile_key_state(Profile, third_schedule_purpose_excepted, Exception),
    profile_key_state(Profile, registered_users_in_india, Users),
    deemed_listing(Exception, Users, AssessmentDate, Profile, Result, Citations).

exception_not_affirmed(absent).
exception_not_affirmed(present(false)).

deemed_listing(present(true), _, _, _, not_listed, [cite(in_dpdp_rules_2025_r_8_1), cite(in_dpdp_rules_2025_sch_3)]) :-
    implements(in_dpdp_rules_2025_sch_3).
deemed_listing(Exception, Users, AssessmentDate, Profile, Result, Citations) :-
    exception_not_affirmed(Exception),
    user_band(Users, Band),
    deemed_after_band(Band, Exception, AssessmentDate, Profile, Result, Citations).

user_band(absent, absent).
user_band(present(UserCount), below_every_threshold) :-
    implements(in_dpdp_rules_2025_sch_3),
    lowest_third_schedule_threshold(LowestThreshold),
    UserCount #< LowestThreshold.
user_band(present(UserCount), counted(UserCount)) :-
    implements(in_dpdp_rules_2025_sch_3),
    lowest_third_schedule_threshold(LowestThreshold),
    UserCount #>= LowestThreshold.

deemed_after_band(below_every_threshold, _, _, _, not_listed, [cite(in_dpdp_rules_2025_r_8_1), cite(in_dpdp_rules_2025_sch_3)]) :-
    implements(in_dpdp_rules_2025_sch_3).
deemed_after_band(absent, Exception, AssessmentDate, Profile, Result, Citations) :-
    profile_key_state(Profile, third_schedule_class, Class),
    deemed_after_class(Class, absent, Exception, AssessmentDate, Profile, Result, Citations).
deemed_after_band(counted(UserCount), Exception, AssessmentDate, Profile, Result, Citations) :-
    profile_key_state(Profile, third_schedule_class, Class),
    deemed_after_class(Class, counted(UserCount), Exception, AssessmentDate, Profile, Result, Citations).

deemed_after_class(absent, _, _, _, _, indeterminate([third_schedule_class]), []).
deemed_after_class(present(no_listed_class), _, _, _, _, not_listed, [cite(in_dpdp_rules_2025_r_8_1), cite(in_dpdp_rules_2025_sch_3)]) :-
    implements(in_dpdp_rules_2025_r_8_1).
deemed_after_class(present(Class), Band, Exception, AssessmentDate, Profile, Result, Citations) :-
    implements(in_dpdp_rules_2025_sch_3),
    third_schedule_item(Class, Threshold, ItemCitation, ClauseACitation, ClauseBCitation),
    deemed_after_threshold(Band, Threshold, schedule_item(ItemCitation, ClauseACitation, ClauseBCitation), Exception, AssessmentDate, Profile, Result, Citations).

deemed_after_threshold(absent, _, _, _, _, _, indeterminate([registered_users_in_india]), []).
deemed_after_threshold(counted(UserCount), Threshold, _, _, _, _, not_listed, [cite(in_dpdp_rules_2025_r_8_1), cite(in_dpdp_rules_2025_sch_3)]) :-
    implements(in_dpdp_rules_2025_sch_3),
    UserCount #< Threshold.
deemed_after_threshold(counted(UserCount), Threshold, ScheduleItem, Exception, AssessmentDate, Profile, Result, Citations) :-
    implements(in_dpdp_rules_2025_sch_3),
    UserCount #>= Threshold,
    deemed_after_exception(Exception, ScheduleItem, AssessmentDate, Profile, Result, Citations).

deemed_after_exception(absent, _, _, _, indeterminate([third_schedule_purpose_excepted]), []).
deemed_after_exception(present(false), ScheduleItem, AssessmentDate, Profile, Result, Citations) :-
    deemed_period(ScheduleItem, AssessmentDate, Profile, Result, Citations).

deemed_period(schedule_item(ItemCitation, ClauseACitation, ClauseBCitation), AssessmentDate, _, not_yet_deemed, [cite(in_dpdp_rules_2025_r_8_1), cite(in_dpdp_rules_2025_r_8_2), ItemCitation, ClauseACitation, ClauseBCitation]) :-
    implements(in_dpdp_rules_2025_r_8_1),
    earliest_period_end_date(EarliestEndDate),
    calendar_day_on_or_before(AssessmentDate, EarliestEndDate).
deemed_period(ScheduleItem, AssessmentDate, Profile, Result, Citations) :-
    implements(in_dpdp_rules_2025_r_8_1),
    earliest_period_end_date(EarliestEndDate),
    calendar_day_before(EarliestEndDate, AssessmentDate),
    profile_key_state(Profile, last_approached_date, Approach),
    deemed_after_approach(Approach, ScheduleItem, AssessmentDate, Result, Citations).

deemed_after_approach(absent, _, _, indeterminate([last_approached_date]), []).
deemed_after_approach(present(ApproachDate), schedule_item(ItemCitation, ClauseACitation, ClauseBCitation), AssessmentDate, deemed_no_longer_served, [cite(in_dpdp_act_2023_s_8_8), cite(in_dpdp_act_2023_s_8_8_a), cite(in_dpdp_act_2023_s_8_8_b), cite(in_dpdp_act_2023_s_8_11), cite(in_dpdp_rules_2025_r_8_1), ItemCitation, ClauseACitation, ClauseBCitation]) :-
    implements(in_dpdp_act_2023_s_8_11),
    period_end_date(ApproachDate, PeriodEndDate),
    calendar_day_before(PeriodEndDate, AssessmentDate).
deemed_after_approach(present(ApproachDate), schedule_item(ItemCitation, ClauseACitation, ClauseBCitation), AssessmentDate, not_yet_deemed, [cite(in_dpdp_rules_2025_r_8_1), cite(in_dpdp_rules_2025_r_8_2), ItemCitation, ClauseACitation, ClauseBCitation]) :-
    implements(in_dpdp_rules_2025_r_8_1),
    period_end_date(ApproachDate, PeriodEndDate),
    calendar_day_on_or_before(AssessmentDate, PeriodEndDate).

dpdp_security_retention_checklist(Profile, [item(security_safeguards_duty, SecurityResult, SecurityCitations), item(accuracy_duty, AccuracyResult, AccuracyCitations), item(erasure_duty, ErasureResult, ErasureCitations), item(third_schedule_deemed_no_longer_served, DeemedResult, DeemedCitations)]) :-
    security_safeguards_duty(Profile, SecurityResult, SecurityCitations),
    accuracy_duty(Profile, AccuracyResult, AccuracyCitations),
    erasure_duty(Profile, ErasureResult, ErasureCitations),
    third_schedule_deemed_no_longer_served(Profile, DeemedResult, DeemedCitations).

result_kind(required_with_rule_6_minimum, owed).
result_kind(required_minimum_not_prescribed, owed).
result_kind(required, owed).
result_kind(erase, owed).
result_kind(erase_and_cause_data_processor_to_erase, owed).
result_kind(retain_until_minimum_retention_period_end, owed).
result_kind(retain_as_required_by_other_law, owed).
result_kind(not_required, settled).
result_kind(not_in_force, settled).
result_kind(not_yet_required, settled).
result_kind(deemed_no_longer_served, settled).
result_kind(not_yet_deemed, settled).
result_kind(not_listed, settled).
result_kind(indeterminate(_), undetermined).
result_kind(needs_legal_review(_, _), undetermined).
result_kind(input_problems(_), undetermined).

checklist_kinds([], []).
checklist_kinds([item(_, Result, _)|Items], [Kind|Kinds]) :-
    result_kind(Result, Kind),
    checklist_kinds(Items, Kinds).

checklist_citations([], []).
checklist_citations([item(_, _, Citations)|Items], AllCitations) :-
    checklist_citations(Items, LaterCitations),
    append(Citations, LaterCitations, AllCitations).

status_from_kinds(true, _, section_8_duty_owed).
status_from_kinds(false, true, section_8_duty_undetermined).
status_from_kinds(false, false, no_section_8_duty_owed).

decide_dpdp_security_retention(Profile, dpdp_security_retention_verdict(profile_rejected, [])) :-
    dpdp_security_retention_input_problems(Profile, [_|_]).
decide_dpdp_security_retention(Profile, dpdp_security_retention_verdict(Status, Citations)) :-
    dpdp_security_retention_input_problems(Profile, []),
    dpdp_security_retention_checklist(Profile, Items),
    checklist_kinds(Items, Kinds),
    checklist_citations(Items, AllCitations),
    sort(AllCitations, Citations),
    memberd_t(owed, Kinds, HasOwed),
    memberd_t(undetermined, Kinds, HasUndetermined),
    status_from_kinds(HasOwed, HasUndetermined, Status).

dpdp_security_retention_status(Profile, Status) :-
    decide_dpdp_security_retention(Profile, dpdp_security_retention_verdict(Status, _Citations)).

dpdp_security_retention_decision_resolvable(Profile) :-
    decide_dpdp_security_retention(Profile, _Verdict).

test(security_on_commencement_day_has_rule_6_minimum) :-
    findall(Result - Citations, security_safeguards_duty([attribute(section_8_5_in_force, true), attribute(acts_as_data_fiduciary, true), attribute(assessment_date, date(2027, 5, 13))], Result, Citations), Answers),
    Answers == [required_with_rule_6_minimum - [cite(in_dpdp_act_2023_s_8_5), cite(in_dpdp_rules_2025_r_6_1)]].
test(security_day_before_commencement_has_no_minimum) :-
    findall(Result, security_safeguards_duty([attribute(section_8_5_in_force, true), attribute(acts_as_data_fiduciary, true), attribute(assessment_date, date(2027, 5, 12))], Result, _), Results),
    Results == [required_minimum_not_prescribed].
test(security_names_in_force_key_first) :-
    security_safeguards_duty([], indeterminate([section_8_5_in_force]), []).
test(security_not_fiduciary_is_not_required) :-
    security_safeguards_duty([attribute(section_8_5_in_force, true), attribute(acts_as_data_fiduciary, false)], not_required, [cite(in_dpdp_act_2023_s_8_5), cite(in_dpdp_act_2023_s_2_i)]).
test(security_unsure_without_day_names_the_day) :-
    security_safeguards_duty([attribute(section_8_5_in_force, true), attribute(acts_as_data_fiduciary, unsure)], indeterminate([assessment_date]), []).
test(security_unsure_with_day_is_referred) :-
    security_safeguards_duty([attribute(section_8_5_in_force, true), attribute(acts_as_data_fiduciary, unsure), attribute(assessment_date, date(2028, 1, 1))], needs_legal_review(open_textured(acts_as_data_fiduciary, cite(in_dpdp_act_2023_s_2_i)), [inputs_relied_on([acts_as_data_fiduciary - unsure])]), []).
test(security_wrong_type_is_an_input_problem) :-
    security_safeguards_duty([attribute(section_8_5_in_force, maybe)], input_problems([wrong_type(section_8_5_in_force)]), []).
test(accuracy_use_for_decision_is_required) :-
    findall(Result, accuracy_duty([attribute(section_8_3_in_force, true), attribute(acts_as_data_fiduciary, true), attribute(likely_used_for_decision_affecting_data_principal, true)], Result, _), Results),
    Results == [required].
test(accuracy_both_false_without_fiduciary_is_not_required) :-
    accuracy_duty([attribute(section_8_3_in_force, true), attribute(likely_used_for_decision_affecting_data_principal, false), attribute(likely_disclosed_to_another_data_fiduciary, false)], not_required, [cite(in_dpdp_act_2023_s_8_3), cite(in_dpdp_act_2023_s_8_3_a), cite(in_dpdp_act_2023_s_8_3_b), cite(in_dpdp_act_2023_s_2_i)]).
test(accuracy_unsure_fiduciary_with_disclosure_is_referred) :-
    accuracy_duty([attribute(section_8_3_in_force, true), attribute(acts_as_data_fiduciary, unsure), attribute(likely_disclosed_to_another_data_fiduciary, true)], needs_legal_review(open_textured(acts_as_data_fiduciary, cite(in_dpdp_act_2023_s_2_i)), [inputs_relied_on([acts_as_data_fiduciary - unsure, likely_disclosed_to_another_data_fiduciary - true])]), []).
test(accuracy_both_unsure_refers_decision_use_first) :-
    accuracy_duty([attribute(section_8_3_in_force, true), attribute(acts_as_data_fiduciary, true), attribute(likely_used_for_decision_affecting_data_principal, unsure), attribute(likely_disclosed_to_another_data_fiduciary, unsure)], needs_legal_review(open_textured(likely_used_for_decision_affecting_data_principal, cite(in_dpdp_act_2023_s_8_3_a)), _), []).
test(erasure_before_rules_erases) :-
    findall(Result - Citations, erasure_duty([attribute(section_8_7_in_force, true), attribute(acts_as_data_fiduciary, true), attribute(retention_necessary_for_compliance_with_law, false), attribute(consent_withdrawn, true), attribute(assessment_date, date(2026, 11, 16)), attribute(data_made_available_to_data_processor, false)], Result, Citations), Answers),
    Answers == [erase - [cite(in_dpdp_act_2023_s_8_7_a)]].
test(erasure_inside_year_is_held) :-
    findall(Result, erasure_duty([attribute(section_8_7_in_force, true), attribute(acts_as_data_fiduciary, true), attribute(retention_necessary_for_compliance_with_law, false), attribute(consent_withdrawn, true), attribute(assessment_date, date(2027, 6, 1)), attribute(last_processing_date, date(2027, 1, 1))], Result, _), Results),
    Results == [retain_until_minimum_retention_period_end].
test(erasure_after_year_with_processor) :-
    erasure_duty([attribute(section_8_7_in_force, true), attribute(acts_as_data_fiduciary, true), attribute(retention_necessary_for_compliance_with_law, false), attribute(consent_withdrawn, true), attribute(assessment_date, date(2028, 1, 2)), attribute(last_processing_date, date(2027, 1, 1)), attribute(data_made_available_to_data_processor, true)], erase_and_cause_data_processor_to_erase, [cite(in_dpdp_act_2023_s_8_7_a), cite(in_dpdp_act_2023_s_8_7_b)]).
test(erasure_early_processing_needs_no_day) :-
    erasure_duty([attribute(section_8_7_in_force, true), attribute(acts_as_data_fiduciary, true), attribute(retention_necessary_for_compliance_with_law, false), attribute(consent_withdrawn, true), attribute(last_processing_date, date(2025, 1, 1)), attribute(data_made_available_to_data_processor, false)], erase, _).
test(erasure_open_trigger_names_the_day) :-
    erasure_duty([attribute(section_8_7_in_force, true), attribute(acts_as_data_fiduciary, true), attribute(retention_necessary_for_compliance_with_law, false), attribute(consent_withdrawn, true)], indeterminate([assessment_date]), []).
test(erasure_other_law_retains) :-
    erasure_duty([attribute(section_8_7_in_force, true), attribute(acts_as_data_fiduciary, true), attribute(retention_necessary_for_compliance_with_law, true)], retain_as_required_by_other_law, [cite(in_dpdp_act_2023_s_8_7)]).
test(erasure_unsure_fiduciary_with_other_law_is_referred) :-
    erasure_duty([attribute(section_8_7_in_force, true), attribute(acts_as_data_fiduciary, unsure), attribute(retention_necessary_for_compliance_with_law, true)], needs_legal_review(open_textured(acts_as_data_fiduciary, cite(in_dpdp_act_2023_s_2_i)), [inputs_relied_on([acts_as_data_fiduciary - unsure, retention_necessary_for_compliance_with_law - true])]), []).
test(erasure_no_trigger_is_not_yet_required) :-
    erasure_duty([attribute(section_8_7_in_force, true), attribute(acts_as_data_fiduciary, true), attribute(retention_necessary_for_compliance_with_law, false), attribute(consent_withdrawn, false), attribute(specified_purpose_no_longer_served, false)], not_yet_required, [cite(in_dpdp_act_2023_s_8_7_a)]).
test(erasure_names_consent_when_purpose_false) :-
    erasure_duty([attribute(section_8_7_in_force, true), attribute(acts_as_data_fiduciary, true), attribute(retention_necessary_for_compliance_with_law, false), attribute(specified_purpose_no_longer_served, false)], indeterminate([consent_withdrawn]), []).
test(deemed_before_rules_is_not_in_force) :-
    third_schedule_deemed_no_longer_served([attribute(assessment_date, date(2026, 1, 1))], not_in_force, [cite(in_dpdp_act_2023_s_8_8), cite(in_dpdp_rules_2025_r_1_4), cite(in_dpdp_rules_2025_r_8_1)]).
test(deemed_after_period_end) :-
    findall(Result - Citations, third_schedule_deemed_no_longer_served([attribute(section_8_8_in_force, true), attribute(assessment_date, date(2031, 1, 1)), attribute(third_schedule_class, e_commerce_entity), attribute(registered_users_in_india, 20000000), attribute(third_schedule_purpose_excepted, false), attribute(last_approached_date, date(2027, 6, 1))], Result, Citations), Answers),
    Answers == [deemed_no_longer_served - [cite(in_dpdp_act_2023_s_8_8), cite(in_dpdp_act_2023_s_8_8_a), cite(in_dpdp_act_2023_s_8_8_b), cite(in_dpdp_act_2023_s_8_11), cite(in_dpdp_rules_2025_r_8_1), cite(in_dpdp_rules_2025_sch_3_1), cite(in_dpdp_rules_2025_sch_3_1_a), cite(in_dpdp_rules_2025_sch_3_1_b)]].
test(deemed_inside_period_is_not_yet) :-
    third_schedule_deemed_no_longer_served([attribute(section_8_8_in_force, true), attribute(assessment_date, date(2031, 1, 1)), attribute(third_schedule_class, e_commerce_entity), attribute(registered_users_in_india, 20000000), attribute(third_schedule_purpose_excepted, false), attribute(last_approached_date, date(2028, 6, 1))], not_yet_deemed, _).
test(deemed_few_users_is_not_listed_without_class) :-
    third_schedule_deemed_no_longer_served([attribute(section_8_8_in_force, true), attribute(assessment_date, date(2031, 1, 1)), attribute(registered_users_in_india, 4999999)], not_listed, [cite(in_dpdp_rules_2025_r_8_1), cite(in_dpdp_rules_2025_sch_3)]).
test(deemed_gaming_at_threshold_before_2030_is_not_yet) :-
    third_schedule_deemed_no_longer_served([attribute(section_8_8_in_force, true), attribute(assessment_date, date(2030, 5, 13)), attribute(third_schedule_class, online_gaming_intermediary), attribute(registered_users_in_india, 5000000), attribute(third_schedule_purpose_excepted, false)], not_yet_deemed, [cite(in_dpdp_rules_2025_r_8_1), cite(in_dpdp_rules_2025_r_8_2), cite(in_dpdp_rules_2025_sch_3_2), cite(in_dpdp_rules_2025_sch_3_2_a), cite(in_dpdp_rules_2025_sch_3_2_b)]).
test(deemed_social_media_below_threshold_is_not_listed) :-
    third_schedule_deemed_no_longer_served([attribute(section_8_8_in_force, true), attribute(assessment_date, date(2031, 1, 1)), attribute(third_schedule_class, social_media_intermediary), attribute(registered_users_in_india, 19999999)], not_listed, _).
test(period_end_from_commencement) :-
    third_schedule_period_end(date(2026, 1, 1), date(2030, 5, 13)).
test(period_end_leap_day_goes_to_28_february) :-
    third_schedule_period_end(date(2028, 2, 29), date(2031, 2, 28)).
test(period_end_bad_input) :-
    findall(PeriodEnd, third_schedule_period_end(not_a_date, PeriodEnd), Answers),
    Answers == [input_problems([wrong_type(approach_date)])].
test(notice_day_two_days_before_end) :-
    erasure_notice_latest_day(date(2026, 1, 1), NoticeDay),
    NoticeDay = date(2030, 5, 11).
test(notice_day_borrows_from_february) :-
    erasure_notice_latest_day(date(2028, 3, 1), NoticeDay),
    NoticeDay = date(2031, 2, 27).
test(retention_end_leap_day) :-
    processing_log_retention_minimum_end(date(2024, 2, 29), date(2025, 2, 28)).
test(retention_end_bad_input) :-
    processing_log_retention_minimum_end(date(2025, 2, 29), input_problems([wrong_type(processing_date)])).
test(fixed_lists_have_seven_and_four_items) :-
    findall(Items, fixed_lists(security_safeguard_minimum, Items), [SafeguardItems]),
    length(SafeguardItems, 7),
    findall(Items, fixed_lists(seventh_schedule_purposes, Items), [PurposeItems]),
    length(PurposeItems, 4).
test(facade_rejects_a_non_list) :-
    decide_dpdp_security_retention(not_a_list, dpdp_security_retention_verdict(profile_rejected, [])).
test(facade_owed_when_safeguards_required) :-
    findall(Status, dpdp_security_retention_status([attribute(section_8_5_in_force, true), attribute(acts_as_data_fiduciary, true), attribute(assessment_date, date(2027, 6, 1))], Status), Statuses),
    Statuses == [section_8_duty_owed].
test(facade_undetermined_on_empty_profile) :-
    dpdp_security_retention_status([], section_8_duty_undetermined).

test(security_day_before_commencement_is_not_rule_6, fail) :-
    security_safeguards_duty([attribute(section_8_5_in_force, true), attribute(acts_as_data_fiduciary, true), attribute(assessment_date, date(2027, 5, 12))], required_with_rule_6_minimum, _).
test(erasure_inside_year_is_not_erase, fail) :-
    erasure_duty([attribute(section_8_7_in_force, true), attribute(acts_as_data_fiduciary, true), attribute(retention_necessary_for_compliance_with_law, false), attribute(consent_withdrawn, true), attribute(assessment_date, date(2027, 6, 1)), attribute(last_processing_date, date(2027, 1, 1))], erase, _).
test(deemed_inside_period_is_not_deemed, fail) :-
    third_schedule_deemed_no_longer_served([attribute(section_8_8_in_force, true), attribute(assessment_date, date(2031, 1, 1)), attribute(third_schedule_class, e_commerce_entity), attribute(registered_users_in_india, 20000000), attribute(third_schedule_purpose_excepted, false), attribute(last_approached_date, date(2028, 6, 1))], deemed_no_longer_served, _).
