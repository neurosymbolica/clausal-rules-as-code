% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_cra_art14_manufacturer_reporting_cra_art14_manufacturer_reporting, [decide_cra_art14_manufacturer_reporting/2, cra_art14_manufacturer_reporting_status/2, cra_art14_manufacturer_reporting_checklist/2, cra_art14_manufacturer_reporting_decision_resolvable/1, cra_art14_manufacturer_reporting_status_values/1, severe_incident_status/3, manufacturer_reporting_steps/4, manufacturer_reporting_step_timeliness/5, severe/0, not_severe/0, on_time/0, unsure/0, affects_protection_of_sensitive_or_important_data_or_functions/0, leads_to_malicious_code_in_product_or_user_systems/0, early_warning_without_undue_delay/0, notification_without_undue_delay/0, actively_exploited_vulnerability/0, incident_impacting_product_security/0, early_warning/0, notification/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(library(error), [must_be/2]).
:- use_module(library(clpz)).
:- use_module(library(reif), [memberd_t/3]).
:- use_module(clausal_dates, [days_between/3]).
:- use_module(formalize_lib, [profile_get/3, profile_has/2, profile_lacks/2]).
:- use_module(deadline_lib, [month_last_day/3]).
:- use_module(m__eu_cra_art14_manufacturer_reporting_kernel, [cra_art14_manufacturer_reporting_input_problems/2]).
:- use_module(m__eu_cra_art14_manufacturer_reporting_citations, [implements/1]).

severe.

not_severe.

on_time.

unsure.

affects_protection_of_sensitive_or_important_data_or_functions.

leads_to_malicious_code_in_product_or_user_systems.

early_warning_without_undue_delay.

notification_without_undue_delay.

actively_exploited_vulnerability.

incident_impacting_product_security.

early_warning.

notification.

cra_art14_manufacturer_reporting_status_values([severe, not_severe]).

article_14_application_date(date(2026, 9, 11), cite(eu_reg_2024_2847_art_71_2)).

reporting_step_row(actively_exploited_vulnerability, early_warning, hours_after_awareness(24), cite(eu_reg_2024_2847_art_14_2_a)).
reporting_step_row(actively_exploited_vulnerability, notification, hours_after_awareness(72), cite(eu_reg_2024_2847_art_14_2_b)).
reporting_step_row(actively_exploited_vulnerability, final_report, days_after_measure_available(14), cite(eu_reg_2024_2847_art_14_2_c)).
reporting_step_row(actively_exploited_vulnerability, intermediate_report, on_request_of_coordinator_csirt, cite(eu_reg_2024_2847_art_14_6)).
reporting_step_row(incident_impacting_product_security, early_warning, hours_after_awareness(24), cite(eu_reg_2024_2847_art_14_4_a)).
reporting_step_row(incident_impacting_product_security, notification, hours_after_awareness(72), cite(eu_reg_2024_2847_art_14_4_b)).
reporting_step_row(incident_impacting_product_security, final_report, months_after_notification(1), cite(eu_reg_2024_2847_art_14_4_c)).
reporting_step_row(incident_impacting_product_security, intermediate_report, on_request_of_coordinator_csirt, cite(eu_reg_2024_2847_art_14_6)).

undue_delay_key(early_warning, early_warning_without_undue_delay).
undue_delay_key(notification, notification_without_undue_delay).

judgement_reading(Profile, JudgementKey, absent) :-
    profile_lacks(Profile, JudgementKey).
judgement_reading(Profile, JudgementKey, KeyValue) :-
    profile_has(Profile, JudgementKey),
    profile_get(Profile, JudgementKey, KeyValue).

severity_readings(Profile, ProtectionValue, MaliciousCodeValue) :-
    judgement_reading(Profile, affects_protection_of_sensitive_or_important_data_or_functions, ProtectionValue),
    judgement_reading(Profile, leads_to_malicious_code_in_product_or_user_systems, MaliciousCodeValue).

severity_route(true, _, severe, [cite(eu_reg_2024_2847_art_14_5)]) :-
    implements(eu_reg_2024_2847_art_14_5).
severity_route(ProtectionValue, true, severe, [cite(eu_reg_2024_2847_art_14_5)]) :-
    implements(eu_reg_2024_2847_art_14_5),
    member(ProtectionValue, [false, unsure, absent]).
severity_route(absent, MaliciousCodeValue, indeterminate([affects_protection_of_sensitive_or_important_data_or_functions]), []) :-
    implements(eu_reg_2024_2847_art_14_5_a),
    member(MaliciousCodeValue, [false, unsure, absent]).
severity_route(ProtectionValue, absent, indeterminate([leads_to_malicious_code_in_product_or_user_systems]), []) :-
    implements(eu_reg_2024_2847_art_14_5_b),
    member(ProtectionValue, [false, unsure]).
severity_route(unsure, MaliciousCodeValue, needs_legal_review(open_textured(affects_protection_of_sensitive_or_important_data_or_functions, cite(eu_reg_2024_2847_art_14_5_a)), [inputs_relied_on([affects_protection_of_sensitive_or_important_data_or_functions - unsure, leads_to_malicious_code_in_product_or_user_systems - MaliciousCodeValue])]), []) :-
    implements(eu_reg_2024_2847_art_14_5_a),
    member(MaliciousCodeValue, [false, unsure]).
severity_route(false, unsure, needs_legal_review(open_textured(leads_to_malicious_code_in_product_or_user_systems, cite(eu_reg_2024_2847_art_14_5_b)), [inputs_relied_on([affects_protection_of_sensitive_or_important_data_or_functions - false, leads_to_malicious_code_in_product_or_user_systems - unsure])]), []) :-
    implements(eu_reg_2024_2847_art_14_5_b).
severity_route(false, false, not_severe, [cite(eu_reg_2024_2847_art_14_5_a), cite(eu_reg_2024_2847_art_14_5_b)]) :-
    implements(eu_reg_2024_2847_art_14_5).

severe_incident_status(Profile, input_problems([Problem|Problems]), []) :-
    cra_art14_manufacturer_reporting_input_problems(Profile, [Problem|Problems]).
severe_incident_status(Profile, Status, Citations) :-
    cra_art14_manufacturer_reporting_input_problems(Profile, []),
    severity_readings(Profile, ProtectionValue, MaliciousCodeValue),
    severity_route(ProtectionValue, MaliciousCodeValue, Status, Citations).

application_status(AwarenessDate, not_yet_applicable) :-
    implements(eu_reg_2024_2847_art_71_2),
    article_14_application_date(ApplicationDate, _Citation),
    days_between(AwarenessDate, ApplicationDate, DaysFromApplication),
    DaysFromApplication #< 0.
application_status(AwarenessDate, applicable) :-
    implements(eu_reg_2024_2847_art_71_2),
    article_14_application_date(ApplicationDate, _Citation),
    days_between(AwarenessDate, ApplicationDate, DaysFromApplication),
    DaysFromApplication #>= 0.

event_steps(actively_exploited_vulnerability, Steps) :-
    implements(eu_reg_2024_2847_art_14_1),
    implements(eu_reg_2024_2847_art_3_1),
    implements(eu_reg_2024_2847_art_3_13),
    implements(eu_reg_2024_2847_art_3_40),
    implements(eu_reg_2024_2847_art_3_42),
    findall(step_due(ReportingStep, Limit, Citation), reporting_step_row(actively_exploited_vulnerability, ReportingStep, Limit, Citation), Steps).
event_steps(incident_impacting_product_security, Steps) :-
    implements(eu_reg_2024_2847_art_14_3),
    implements(eu_reg_2024_2847_art_3_1),
    implements(eu_reg_2024_2847_art_3_13),
    implements(eu_reg_2024_2847_art_3_43),
    implements(eu_reg_2024_2847_art_3_44),
    findall(step_due(ReportingStep, Limit, Citation), reporting_step_row(incident_impacting_product_security, ReportingStep, Limit, Citation), Steps).

incident_steps(severe, Steps) :-
    implements(eu_reg_2024_2847_art_14_3),
    event_steps(incident_impacting_product_security, Steps).
incident_steps(not_severe, []) :-
    implements(eu_reg_2024_2847_art_14_3).
incident_steps(indeterminate(MissingKeys), indeterminate(MissingKeys)).
incident_steps(needs_legal_review(Reason, Context), needs_legal_review(Reason, Context)).

reporting_steps_route(_Profile, _Event, AwarenessDate, []) :-
    implements(eu_reg_2024_2847_art_71_2),
    application_status(AwarenessDate, not_yet_applicable).
reporting_steps_route(_Profile, actively_exploited_vulnerability, AwarenessDate, Steps) :-
    implements(eu_reg_2024_2847_art_14_1),
    application_status(AwarenessDate, applicable),
    event_steps(actively_exploited_vulnerability, Steps).
reporting_steps_route(Profile, incident_impacting_product_security, AwarenessDate, Steps) :-
    implements(eu_reg_2024_2847_art_14_3),
    application_status(AwarenessDate, applicable),
    severity_readings(Profile, ProtectionValue, MaliciousCodeValue),
    severity_route(ProtectionValue, MaliciousCodeValue, Status, _Citations),
    incident_steps(Status, Steps).

manufacturer_reporting_steps(Profile, Event, AwarenessDate, input_problems([Problem|Problems])) :-
    steps_input_problems(Profile, Event, AwarenessDate, [Problem|Problems]).
manufacturer_reporting_steps(Profile, Event, AwarenessDate, Steps) :-
    steps_input_problems(Profile, Event, AwarenessDate, []),
    reporting_steps_route(Profile, Event, AwarenessDate, Steps).

step_hour_limit(actively_exploited_vulnerability, early_warning, HoursLimit, Citation) :-
    implements(eu_reg_2024_2847_art_14_2_a),
    reporting_step_row(actively_exploited_vulnerability, early_warning, hours_after_awareness(HoursLimit), Citation).
step_hour_limit(actively_exploited_vulnerability, notification, HoursLimit, Citation) :-
    implements(eu_reg_2024_2847_art_14_2_b),
    reporting_step_row(actively_exploited_vulnerability, notification, hours_after_awareness(HoursLimit), Citation).
step_hour_limit(incident_impacting_product_security, early_warning, HoursLimit, Citation) :-
    implements(eu_reg_2024_2847_art_14_4_a),
    reporting_step_row(incident_impacting_product_security, early_warning, hours_after_awareness(HoursLimit), Citation).
step_hour_limit(incident_impacting_product_security, notification, HoursLimit, Citation) :-
    implements(eu_reg_2024_2847_art_14_4_b),
    reporting_step_row(incident_impacting_product_security, notification, hours_after_awareness(HoursLimit), Citation).

undue_delay_result(absent, JudgementKey, _Citation, indeterminate([JudgementKey])).
undue_delay_result(true, _JudgementKey, _Citation, on_time).
undue_delay_result(false, _JudgementKey, _Citation, late(without_undue_delay)).
undue_delay_result(unsure, JudgementKey, Citation, needs_legal_review(open_textured(JudgementKey, Citation), [inputs_relied_on([JudgementKey - unsure])])).

timeliness_route(_Profile, actively_exploited_vulnerability, ReportingStep, HoursElapsed, late(hour_limit)) :-
    implements(eu_reg_2024_2847_art_14_1),
    step_hour_limit(actively_exploited_vulnerability, ReportingStep, HoursLimit, _Citation),
    HoursElapsed #> HoursLimit.
timeliness_route(Profile, actively_exploited_vulnerability, ReportingStep, HoursElapsed, Result) :-
    implements(eu_reg_2024_2847_art_14_1),
    step_hour_limit(actively_exploited_vulnerability, ReportingStep, HoursLimit, Citation),
    HoursElapsed #=< HoursLimit,
    undue_delay_key(ReportingStep, JudgementKey),
    judgement_reading(Profile, JudgementKey, KeyValue),
    undue_delay_result(KeyValue, JudgementKey, Citation, Result).
timeliness_route(_Profile, incident_impacting_product_security, ReportingStep, HoursElapsed, late(hour_limit)) :-
    implements(eu_reg_2024_2847_art_14_3),
    step_hour_limit(incident_impacting_product_security, ReportingStep, HoursLimit, _Citation),
    HoursElapsed #> HoursLimit.
timeliness_route(Profile, incident_impacting_product_security, ReportingStep, HoursElapsed, Result) :-
    implements(eu_reg_2024_2847_art_14_3),
    step_hour_limit(incident_impacting_product_security, ReportingStep, HoursLimit, Citation),
    HoursElapsed #=< HoursLimit,
    undue_delay_key(ReportingStep, JudgementKey),
    judgement_reading(Profile, JudgementKey, KeyValue),
    undue_delay_result(KeyValue, JudgementKey, Citation, Result).

manufacturer_reporting_step_timeliness(Profile, Event, ReportingStep, HoursElapsed, input_problems([Problem|Problems])) :-
    timeliness_input_problems(Profile, Event, ReportingStep, HoursElapsed, [Problem|Problems]).
manufacturer_reporting_step_timeliness(Profile, Event, ReportingStep, HoursElapsed, Result) :-
    timeliness_input_problems(Profile, Event, ReportingStep, HoursElapsed, []),
    timeliness_route(Profile, Event, ReportingStep, HoursElapsed, Result).

steps_input_problems(Profile, Event, AwarenessDate, Problems) :-
    cra_art14_manufacturer_reporting_input_problems(Profile, ProfileProblems),
    event_problems(Event, EventProblems),
    awareness_date_problems(AwarenessDate, DateProblems),
    append([ProfileProblems, EventProblems, DateProblems], Problems).

timeliness_input_problems(Profile, Event, ReportingStep, HoursElapsed, Problems) :-
    cra_art14_manufacturer_reporting_input_problems(Profile, ProfileProblems),
    event_problems(Event, EventProblems),
    step_problems(ReportingStep, StepProblems),
    hours_problems(HoursElapsed, HoursProblems),
    append([ProfileProblems, EventProblems, StepProblems, HoursProblems], Problems).

event_problems(Event, []) :-
    atom_in_set_t(Event, [actively_exploited_vulnerability, incident_impacting_product_security], true).
event_problems(Event, [wrong_type(event)]) :-
    atom_in_set_t(Event, [actively_exploited_vulnerability, incident_impacting_product_security], false).

step_problems(ReportingStep, []) :-
    atom_in_set_t(ReportingStep, [early_warning, notification], true).
step_problems(ReportingStep, [wrong_type(step)]) :-
    atom_in_set_t(ReportingStep, [early_warning, notification], false).

hours_problems(HoursElapsed, []) :-
    non_negative_integer_t(HoursElapsed, true).
hours_problems(HoursElapsed, [wrong_type(hours_elapsed)]) :-
    non_negative_integer_t(HoursElapsed, false).

awareness_date_problems(AwarenessDate, []) :-
    calendar_date_t(AwarenessDate, true).
awareness_date_problems(AwarenessDate, [wrong_type(awareness_date)]) :-
    calendar_date_t(AwarenessDate, false).

atom_in_set_t(Argument, _Allowed, false) :-
    var(Argument).
atom_in_set_t(Argument, Allowed, Truth) :-
    term_variables(Argument, []),
    memberd_t(Argument, Allowed, Truth).
atom_in_set_t(Argument, _Allowed, false) :-
    nonvar(Argument),
    term_variables(Argument, [_|_]).

integer_t(Candidate, Truth) :-
    catch(integer_truth(Candidate, Truth), _Error, Truth = false).

integer_truth(Candidate, true) :-
    must_be(integer, Candidate).

non_negative_integer_t(Candidate, false) :-
    term_variables(Candidate, [_|_]).
non_negative_integer_t(Candidate, Truth) :-
    term_variables(Candidate, []),
    integer_t(Candidate, IsInteger),
    non_negative_t(IsInteger, Candidate, Truth).

non_negative_t(false, _Candidate, false).
non_negative_t(true, Candidate, true) :-
    Candidate #>= 0.
non_negative_t(true, Candidate, false) :-
    Candidate #< 0.

truth_conjunction(true, Truth, Truth).
truth_conjunction(false, _Truth, false).

calendar_date_t(DateTerm, false) :-
    term_variables(DateTerm, [_|_]).
calendar_date_t(DateTerm, Truth) :-
    term_variables(DateTerm, []),
    date_shape_t(DateTerm, Truth).

date_shape_t(DateTerm, false) :-
    DateTerm \= date(_, _, _).
date_shape_t(date(YearNumber, MonthNumber, DayNumber), Truth) :-
    integer_t(YearNumber, YearIsInteger),
    integer_t(MonthNumber, MonthIsInteger),
    integer_t(DayNumber, DayIsInteger),
    truth_conjunction(YearIsInteger, MonthIsInteger, YearAndMonth),
    truth_conjunction(YearAndMonth, DayIsInteger, AllIntegers),
    calendar_month_t(AllIntegers, YearNumber, MonthNumber, DayNumber, Truth).

calendar_month_t(false, _YearNumber, _MonthNumber, _DayNumber, false).
calendar_month_t(true, YearNumber, MonthNumber, DayNumber, Truth) :-
    month_in_range_t(MonthNumber, InRange),
    calendar_day_t(InRange, YearNumber, MonthNumber, DayNumber, Truth).

month_in_range_t(MonthNumber, true) :-
    MonthNumber #>= 1,
    MonthNumber #< 13.
month_in_range_t(MonthNumber, false) :-
    MonthNumber #< 1.
month_in_range_t(MonthNumber, false) :-
    MonthNumber #> 12.

calendar_day_t(false, _YearNumber, _MonthNumber, _DayNumber, false).
calendar_day_t(true, YearNumber, MonthNumber, DayNumber, Truth) :-
    month_last_day(YearNumber, MonthNumber, LastDay),
    day_in_range_t(DayNumber, LastDay, Truth).

day_in_range_t(DayNumber, LastDay, true) :-
    DayNumber #>= 1,
    DayNumber #=< LastDay.
day_in_range_t(DayNumber, _LastDay, false) :-
    DayNumber #< 1.
day_in_range_t(DayNumber, LastDay, false) :-
    DayNumber #> LastDay.

decide_cra_art14_manufacturer_reporting(Profile, cra_art14_manufacturer_reporting_verdict(Status, Citations)) :-
    severe_incident_status(Profile, Status, Citations).

cra_art14_manufacturer_reporting_status(Profile, Status) :-
    decide_cra_art14_manufacturer_reporting(Profile, cra_art14_manufacturer_reporting_verdict(Status, _Citations)).

limb_status(true, _JudgementKey, met).
limb_status(false, _JudgementKey, unmet(limb_not_met)).
limb_status(unsure, JudgementKey, unknown([JudgementKey])).
limb_status(absent, JudgementKey, unknown([JudgementKey])).

cra_art14_manufacturer_reporting_checklist(Profile, [item(input_check, unmet(input_problems([Problem|Problems])), cite(eu_reg_2024_2847_art_14_5))]) :-
    cra_art14_manufacturer_reporting_input_problems(Profile, [Problem|Problems]).
cra_art14_manufacturer_reporting_checklist(Profile, [item(severity_protection_of_data_or_functions, ProtectionStatus, cite(eu_reg_2024_2847_art_14_5_a)), item(severity_malicious_code, MaliciousCodeStatus, cite(eu_reg_2024_2847_art_14_5_b))]) :-
    cra_art14_manufacturer_reporting_input_problems(Profile, []),
    severity_readings(Profile, ProtectionValue, MaliciousCodeValue),
    limb_status(ProtectionValue, affects_protection_of_sensitive_or_important_data_or_functions, ProtectionStatus),
    limb_status(MaliciousCodeValue, leads_to_malicious_code_in_product_or_user_systems, MaliciousCodeStatus).

cra_art14_manufacturer_reporting_decision_resolvable(Profile) :-
    decide_cra_art14_manufacturer_reporting(Profile, _Verdict).

test(protection_limb_true_is_severe) :-
    severe_incident_status([attribute(affects_protection_of_sensitive_or_important_data_or_functions, true)], severe, [cite(eu_reg_2024_2847_art_14_5)]).
test(malicious_code_limb_true_is_severe) :-
    severe_incident_status([attribute(affects_protection_of_sensitive_or_important_data_or_functions, unsure), attribute(leads_to_malicious_code_in_product_or_user_systems, true)], severe, [cite(eu_reg_2024_2847_art_14_5)]).
test(both_limbs_true_answer_once) :-
    findall(Status, severe_incident_status([attribute(affects_protection_of_sensitive_or_important_data_or_functions, true), attribute(leads_to_malicious_code_in_product_or_user_systems, true)], Status, _Citations), Statuses),
    Statuses == [severe].
test(both_limbs_false_is_not_severe) :-
    severe_incident_status([attribute(affects_protection_of_sensitive_or_important_data_or_functions, false), attribute(leads_to_malicious_code_in_product_or_user_systems, false)], not_severe, [cite(eu_reg_2024_2847_art_14_5_a), cite(eu_reg_2024_2847_art_14_5_b)]).
test(unsure_protection_and_absent_code_names_the_code_key) :-
    severe_incident_status([attribute(affects_protection_of_sensitive_or_important_data_or_functions, unsure)], indeterminate([leads_to_malicious_code_in_product_or_user_systems]), []).
test(absent_protection_and_false_code_names_the_protection_key) :-
    severe_incident_status([attribute(leads_to_malicious_code_in_product_or_user_systems, false)], indeterminate([affects_protection_of_sensitive_or_important_data_or_functions]), []).
test(unsure_protection_refers) :-
    severe_incident_status([attribute(affects_protection_of_sensitive_or_important_data_or_functions, unsure), attribute(leads_to_malicious_code_in_product_or_user_systems, false)], needs_legal_review(open_textured(affects_protection_of_sensitive_or_important_data_or_functions, cite(eu_reg_2024_2847_art_14_5_a)), [inputs_relied_on([affects_protection_of_sensitive_or_important_data_or_functions - unsure, leads_to_malicious_code_in_product_or_user_systems - false])]), []).
test(duplicate_key_is_an_input_problem) :-
    severe_incident_status([attribute(affects_protection_of_sensitive_or_important_data_or_functions, true), attribute(affects_protection_of_sensitive_or_important_data_or_functions, true)], input_problems([duplicate_key(affects_protection_of_sensitive_or_important_data_or_functions)]), []).
test(before_application_no_step) :-
    manufacturer_reporting_steps([], actively_exploited_vulnerability, date(2026, 9, 10), []).
test(application_day_lists_vulnerability_steps) :-
    findall(Steps, manufacturer_reporting_steps([], actively_exploited_vulnerability, date(2026, 9, 11), Steps), Solutions),
    Solutions == [[step_due(early_warning, hours_after_awareness(24), cite(eu_reg_2024_2847_art_14_2_a)), step_due(notification, hours_after_awareness(72), cite(eu_reg_2024_2847_art_14_2_b)), step_due(final_report, days_after_measure_available(14), cite(eu_reg_2024_2847_art_14_2_c)), step_due(intermediate_report, on_request_of_coordinator_csirt, cite(eu_reg_2024_2847_art_14_6))]].
test(severe_incident_lists_incident_steps) :-
    findall(Steps, manufacturer_reporting_steps([attribute(leads_to_malicious_code_in_product_or_user_systems, true)], incident_impacting_product_security, date(2027, 1, 5), Steps), Solutions),
    Solutions == [[step_due(early_warning, hours_after_awareness(24), cite(eu_reg_2024_2847_art_14_4_a)), step_due(notification, hours_after_awareness(72), cite(eu_reg_2024_2847_art_14_4_b)), step_due(final_report, months_after_notification(1), cite(eu_reg_2024_2847_art_14_4_c)), step_due(intermediate_report, on_request_of_coordinator_csirt, cite(eu_reg_2024_2847_art_14_6))]].
test(not_severe_incident_lists_no_step) :-
    manufacturer_reporting_steps([attribute(affects_protection_of_sensitive_or_important_data_or_functions, false), attribute(leads_to_malicious_code_in_product_or_user_systems, false)], incident_impacting_product_security, date(2027, 1, 5), []).
test(open_severity_is_passed_on) :-
    manufacturer_reporting_steps([], incident_impacting_product_security, date(2027, 1, 5), indeterminate([affects_protection_of_sensitive_or_important_data_or_functions])).
test(bad_event_and_impossible_date_are_named) :-
    manufacturer_reporting_steps([], breach, date(2026, 2, 29), input_problems([wrong_type(event), wrong_type(awareness_date)])).
test(leap_day_is_a_real_date) :-
    manufacturer_reporting_steps([], actively_exploited_vulnerability, date(2028, 2, 29), [_|_]).
test(early_warning_at_24_hours_without_undue_delay_is_on_time) :-
    manufacturer_reporting_step_timeliness([attribute(early_warning_without_undue_delay, true)], actively_exploited_vulnerability, early_warning, 24, on_time).
test(early_warning_at_25_hours_is_late) :-
    manufacturer_reporting_step_timeliness([attribute(early_warning_without_undue_delay, true)], actively_exploited_vulnerability, early_warning, 25, late(hour_limit)).
test(notification_with_undue_delay_is_late) :-
    manufacturer_reporting_step_timeliness([attribute(notification_without_undue_delay, false)], incident_impacting_product_security, notification, 72, late(without_undue_delay)).
test(unsure_undue_delay_refers_with_incident_citation) :-
    manufacturer_reporting_step_timeliness([attribute(early_warning_without_undue_delay, unsure)], incident_impacting_product_security, early_warning, 3, needs_legal_review(open_textured(early_warning_without_undue_delay, cite(eu_reg_2024_2847_art_14_4_a)), [inputs_relied_on([early_warning_without_undue_delay - unsure])])).
test(absent_undue_delay_key_is_named) :-
    manufacturer_reporting_step_timeliness([], actively_exploited_vulnerability, notification, 10, indeterminate([notification_without_undue_delay])).
test(negative_hours_is_wrong_type) :-
    manufacturer_reporting_step_timeliness([], actively_exploited_vulnerability, final_report, -1, input_problems([wrong_type(step), wrong_type(hours_elapsed)])).

test(both_limbs_false_is_not_severe_as_severe, fail) :-
    severe_incident_status([attribute(affects_protection_of_sensitive_or_important_data_or_functions, false), attribute(leads_to_malicious_code_in_product_or_user_systems, false)], severe, _Citations).
test(early_warning_at_25_hours_is_not_on_time, fail) :-
    manufacturer_reporting_step_timeliness([attribute(early_warning_without_undue_delay, true)], actively_exploited_vulnerability, early_warning, 25, on_time).
