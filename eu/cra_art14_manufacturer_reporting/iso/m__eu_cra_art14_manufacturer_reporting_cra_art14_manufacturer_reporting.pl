% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_cra_art14_manufacturer_reporting_cra_art14_manufacturer_reporting, [severe_incident_status/3, manufacturer_reporting_steps/4, manufacturer_reporting_step_timeliness/5, decide_cra_art14_manufacturer_reporting/2, cra_art14_manufacturer_reporting_status/2, cra_art14_manufacturer_reporting_checklist/2, cra_art14_manufacturer_reporting_decision_resolvable/1, cra_art14_manufacturer_reporting_status_values/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(library(error), [must_be/2]).
:- use_module(library(clpz)).
:- use_module(library(reif), [memberd_t/3]).
:- use_module(formalize_lib, [profile_get/3, profile_has/2, profile_lacks/2]).
:- use_module(m__eu_cra_art14_manufacturer_reporting_kernel, [cra_art14_manufacturer_reporting_input_problems/2]).
:- use_module(m__eu_cra_art14_manufacturer_reporting_citations, [implements/1]).

cra_art14_manufacturer_reporting_status_values([severe, not_severe]).

reporting_step_row(actively_exploited_vulnerability, early_warning, hours_after_awareness(Hours), cite(eu_reg_2024_2847_art_14_2_a)) :-
    implements(eu_reg_2024_2847_art_14_2_a),
    Hours #= 24.
reporting_step_row(actively_exploited_vulnerability, notification, hours_after_awareness(Hours), cite(eu_reg_2024_2847_art_14_2_b)) :-
    implements(eu_reg_2024_2847_art_14_2_b),
    Hours #= 72.
reporting_step_row(actively_exploited_vulnerability, final_report, days_after_measure_available(Days), cite(eu_reg_2024_2847_art_14_2_c)) :-
    implements(eu_reg_2024_2847_art_14_2_c),
    Days #= 14.
reporting_step_row(incident_impacting_product_security, early_warning, hours_after_awareness(Hours), cite(eu_reg_2024_2847_art_14_4_a)) :-
    implements(eu_reg_2024_2847_art_14_4_a),
    Hours #= 24.
reporting_step_row(incident_impacting_product_security, notification, hours_after_awareness(Hours), cite(eu_reg_2024_2847_art_14_4_b)) :-
    implements(eu_reg_2024_2847_art_14_4_b),
    Hours #= 72.
reporting_step_row(incident_impacting_product_security, final_report, months_after_notification(Months), cite(eu_reg_2024_2847_art_14_4_c)) :-
    implements(eu_reg_2024_2847_art_14_4_c),
    Months #= 1.
reporting_step_row(Event, intermediate_report, on_request_of_coordinator_csirt, cite(eu_reg_2024_2847_art_14_6)) :-
    implements(eu_reg_2024_2847_art_14_6),
    reporting_event(Event).

reporting_event(actively_exploited_vulnerability).
reporting_event(incident_impacting_product_security).

listed_steps(Event, Steps) :-
    findall(step_due(Step, Limit, Citation), reporting_step_row(Event, Step, Limit, Citation), Steps).

judgement_state(Profile, Key, absent) :-
    profile_lacks(Profile, Key).
judgement_state(Profile, Key, Value) :-
    profile_has(Profile, Key),
    profile_get(Profile, Key, Value).

not_true_judgement(false).
not_true_judgement(unsure).
not_true_judgement(absent).

given_not_true_judgement(false).
given_not_true_judgement(unsure).

severity_route(true, _, severe) :-
    implements(eu_reg_2024_2847_art_14_5).
severity_route(Protection, true, severe) :-
    implements(eu_reg_2024_2847_art_14_5),
    not_true_judgement(Protection).
severity_route(absent, MaliciousCode, missing(affects_protection_of_sensitive_or_important_data_or_functions)) :-
    implements(eu_reg_2024_2847_art_14_5),
    not_true_judgement(MaliciousCode).
severity_route(Protection, absent, missing(leads_to_malicious_code_in_product_or_user_systems)) :-
    implements(eu_reg_2024_2847_art_14_5),
    given_not_true_judgement(Protection).
severity_route(unsure, MaliciousCode, refer(affects_protection_of_sensitive_or_important_data_or_functions)) :-
    implements(eu_reg_2024_2847_art_14_5_a),
    given_not_true_judgement(MaliciousCode).
severity_route(false, unsure, refer(leads_to_malicious_code_in_product_or_user_systems)) :-
    implements(eu_reg_2024_2847_art_14_5_b).
severity_route(false, false, not_severe) :-
    implements(eu_reg_2024_2847_art_14_5_a),
    implements(eu_reg_2024_2847_art_14_5_b).

severity_limb_citation(affects_protection_of_sensitive_or_important_data_or_functions, cite(eu_reg_2024_2847_art_14_5_a)).
severity_limb_citation(leads_to_malicious_code_in_product_or_user_systems, cite(eu_reg_2024_2847_art_14_5_b)).

severity_status(severe, _, _, severe, [cite(eu_reg_2024_2847_art_14_5)]).
severity_status(not_severe, _, _, not_severe, [cite(eu_reg_2024_2847_art_14_5_a), cite(eu_reg_2024_2847_art_14_5_b)]).
severity_status(missing(Key), _, _, indeterminate([Key]), []).
severity_status(refer(Key), Protection, MaliciousCode, needs_legal_review(open_textured(Key, Citation), [inputs_relied_on([affects_protection_of_sensitive_or_important_data_or_functions - Protection, leads_to_malicious_code_in_product_or_user_systems - MaliciousCode])]), []) :-
    severity_limb_citation(Key, Citation).

profile_severity(Profile, Status, Citations) :-
    judgement_state(Profile, affects_protection_of_sensitive_or_important_data_or_functions, Protection),
    judgement_state(Profile, leads_to_malicious_code_in_product_or_user_systems, MaliciousCode),
    severity_route(Protection, MaliciousCode, Route),
    severity_status(Route, Protection, MaliciousCode, Status, Citations).

severe_incident_status(Profile, Status, Citations) :-
    cra_art14_manufacturer_reporting_input_problems(Profile, Problems),
    severity_answer(Problems, Profile, Status, Citations).

severity_answer([], Profile, Status, Citations) :-
    profile_severity(Profile, Status, Citations).
severity_answer([Problem|Problems], _, input_problems([Problem|Problems]), []).

argument_problem(true, _, []).
argument_problem(false, Name, [wrong_type(Name)]).

event_problems(Event, [wrong_type(event)]) :-
    var(Event).
event_problems(Event, Problems) :-
    nonvar(Event),
    memberd_t(Event, [actively_exploited_vulnerability, incident_impacting_product_security], Known),
    argument_problem(Known, event, Problems).

step_problems(Step, [wrong_type(step)]) :-
    var(Step).
step_problems(Step, Problems) :-
    nonvar(Step),
    memberd_t(Step, [early_warning, notification], Known),
    argument_problem(Known, step, Problems).

hours_elapsed_problems(HoursElapsed, [wrong_type(hours_elapsed)]) :-
    var(HoursElapsed).
hours_elapsed_problems(HoursElapsed, Problems) :-
    nonvar(HoursElapsed),
    integer_t(HoursElapsed, IsInteger),
    non_negative_integer_t(IsInteger, HoursElapsed, Valid),
    argument_problem(Valid, hours_elapsed, Problems).

non_negative_integer_t(false, _, false).
non_negative_integer_t(true, HoursElapsed, Valid) :-
    NonNegativeBit #<==> HoursElapsed #>= 0,
    bit_truth(NonNegativeBit, Valid).

integer_t(Term, Truth) :-
    catch((must_be(integer, Term), Truth = true), error(_, _), Truth = false).

bit_truth(1, true).
bit_truth(0, false).

truth_and(true, Truth, Truth).
truth_and(false, _, false).

awareness_date_problems(AwarenessDate, Problems) :-
    calendar_date_t(AwarenessDate, Valid),
    argument_problem(Valid, awareness_date, Problems).

calendar_date_t(Date, false) :-
    term_variables(Date, [_|_]).
calendar_date_t(Date, Valid) :-
    term_variables(Date, []),
    date_term_t(Date, Valid).

date_term_t(Date, false) :-
    Date \= date(_, _, _).
date_term_t(date(Year, Month, Day), Valid) :-
    integer_t(Year, YearInteger),
    integer_t(Month, MonthInteger),
    integer_t(Day, DayInteger),
    truth_and(YearInteger, MonthInteger, YearMonthIntegers),
    truth_and(YearMonthIntegers, DayInteger, Integers),
    calendar_day_t(Integers, Year, Month, Day, Valid).

calendar_day_t(false, _, _, _, false).
calendar_day_t(true, Year, Month, Day, Valid) :-
    MonthBit #<==> Month #>= 1 #/\ Month #=< 12,
    bit_truth(MonthBit, MonthValid),
    day_of_month_t(MonthValid, Year, Month, Day, Valid).

day_of_month_t(false, _, _, _, false).
day_of_month_t(true, Year, Month, Day, Valid) :-
    month_length(Year, Month, Length),
    DayBit #<==> Day #>= 1 #/\ Day #=< Length,
    bit_truth(DayBit, Valid).

month_length(_, 1, 31).
month_length(Year, 2, Length) :-
    leap_year_t(Year, Leap),
    february_length(Leap, Length).
month_length(_, 3, 31).
month_length(_, 4, 30).
month_length(_, 5, 31).
month_length(_, 6, 30).
month_length(_, 7, 31).
month_length(_, 8, 31).
month_length(_, 9, 30).
month_length(_, 10, 31).
month_length(_, 11, 30).
month_length(_, 12, 31).

leap_year_t(Year, Leap) :-
    LeapBit #<==> Year mod 4 #= 0 #/\ Year mod 100 #> 0 #\/ Year mod 400 #= 0,
    bit_truth(LeapBit, Leap).

february_length(true, 29).
february_length(false, 28).

application_of_article_14(date(Year, Month, Day), not_yet_applicable) :-
    implements(eu_reg_2024_2847_art_71_2),
    DateOrder #= Year * 10000 + Month * 100 + Day,
    DateOrder #< 2026 * 10000 + 9 * 100 + 11.
application_of_article_14(date(Year, Month, Day), applicable) :-
    implements(eu_reg_2024_2847_art_71_2),
    DateOrder #= Year * 10000 + Month * 100 + Day,
    DateOrder #>= 2026 * 10000 + 9 * 100 + 11.

manufacturer_reporting_steps(Profile, Event, AwarenessDate, Steps) :-
    cra_art14_manufacturer_reporting_input_problems(Profile, ProfileProblems),
    event_problems(Event, EventProblems),
    awareness_date_problems(AwarenessDate, DateProblems),
    append(EventProblems, DateProblems, ArgumentProblems),
    append(ProfileProblems, ArgumentProblems, Problems),
    steps_answer(Problems, Profile, Event, AwarenessDate, Steps).

steps_answer([], Profile, Event, AwarenessDate, Steps) :-
    application_of_article_14(AwarenessDate, Application),
    steps_in_application(Application, Profile, Event, Steps).
steps_answer([Problem|Problems], _, _, _, input_problems([Problem|Problems])).

steps_in_application(not_yet_applicable, _, _, []).
steps_in_application(applicable, Profile, Event, Steps) :-
    event_steps(Event, Profile, Steps).

event_steps(actively_exploited_vulnerability, _, Steps) :-
    implements(eu_reg_2024_2847_art_14_1),
    implements(eu_reg_2024_2847_art_3_1),
    implements(eu_reg_2024_2847_art_3_13),
    implements(eu_reg_2024_2847_art_3_40),
    implements(eu_reg_2024_2847_art_3_42),
    listed_steps(actively_exploited_vulnerability, Steps).
event_steps(incident_impacting_product_security, Profile, Steps) :-
    implements(eu_reg_2024_2847_art_14_3),
    implements(eu_reg_2024_2847_art_3_1),
    implements(eu_reg_2024_2847_art_3_13),
    implements(eu_reg_2024_2847_art_3_43),
    implements(eu_reg_2024_2847_art_3_44),
    profile_severity(Profile, Status, _),
    incident_steps(Status, Steps).

incident_steps(severe, Steps) :-
    implements(eu_reg_2024_2847_art_14_3),
    listed_steps(incident_impacting_product_security, Steps).
incident_steps(not_severe, []) :-
    implements(eu_reg_2024_2847_art_14_3).
incident_steps(indeterminate(MissingKeys), indeterminate(MissingKeys)).
incident_steps(needs_legal_review(Reason, Context), needs_legal_review(Reason, Context)).

manufacturer_reporting_step_timeliness(Profile, Event, Step, HoursElapsed, Result) :-
    cra_art14_manufacturer_reporting_input_problems(Profile, ProfileProblems),
    event_problems(Event, EventProblems),
    step_problems(Step, StepProblems),
    hours_elapsed_problems(HoursElapsed, HoursProblems),
    append(StepProblems, HoursProblems, StepHoursProblems),
    append(EventProblems, StepHoursProblems, ArgumentProblems),
    append(ProfileProblems, ArgumentProblems, Problems),
    timeliness_answer(Problems, Profile, Event, Step, HoursElapsed, Result).

timeliness_answer([], Profile, Event, Step, HoursElapsed, Result) :-
    hour_limit_route(Event, Step, HoursElapsed, Route),
    timeliness_result(Route, Profile, Event, Step, Result).
timeliness_answer([Problem|Problems], _, _, _, _, input_problems([Problem|Problems])).

hour_limit_route(Event, early_warning, HoursElapsed, beyond_hour_limit) :-
    implements(eu_reg_2024_2847_art_14_2_a),
    implements(eu_reg_2024_2847_art_14_4_a),
    reporting_step_row(Event, early_warning, hours_after_awareness(LimitHours), _),
    HoursElapsed #> LimitHours.
hour_limit_route(Event, early_warning, HoursElapsed, within_hour_limit) :-
    implements(eu_reg_2024_2847_art_14_2_a),
    implements(eu_reg_2024_2847_art_14_4_a),
    reporting_step_row(Event, early_warning, hours_after_awareness(LimitHours), _),
    HoursElapsed #=< LimitHours.
hour_limit_route(Event, notification, HoursElapsed, beyond_hour_limit) :-
    implements(eu_reg_2024_2847_art_14_2_b),
    implements(eu_reg_2024_2847_art_14_4_b),
    reporting_step_row(Event, notification, hours_after_awareness(LimitHours), _),
    HoursElapsed #> LimitHours.
hour_limit_route(Event, notification, HoursElapsed, within_hour_limit) :-
    implements(eu_reg_2024_2847_art_14_2_b),
    implements(eu_reg_2024_2847_art_14_4_b),
    reporting_step_row(Event, notification, hours_after_awareness(LimitHours), _),
    HoursElapsed #=< LimitHours.

timeliness_result(beyond_hour_limit, _, _, _, late(hour_limit)).
timeliness_result(within_hour_limit, Profile, Event, early_warning, Result) :-
    implements(eu_reg_2024_2847_art_14_2_a),
    implements(eu_reg_2024_2847_art_14_4_a),
    judgement_state(Profile, early_warning_without_undue_delay, State),
    reporting_step_row(Event, early_warning, _, Citation),
    undue_delay_result(State, early_warning_without_undue_delay, Citation, Result).
timeliness_result(within_hour_limit, Profile, Event, notification, Result) :-
    implements(eu_reg_2024_2847_art_14_2_b),
    implements(eu_reg_2024_2847_art_14_4_b),
    judgement_state(Profile, notification_without_undue_delay, State),
    reporting_step_row(Event, notification, _, Citation),
    undue_delay_result(State, notification_without_undue_delay, Citation, Result).

undue_delay_result(absent, Key, _, indeterminate([Key])).
undue_delay_result(true, _, _, on_time).
undue_delay_result(false, _, _, late(without_undue_delay)).
undue_delay_result(unsure, Key, Citation, needs_legal_review(open_textured(Key, Citation), [inputs_relied_on([Key - unsure])])).

decide_cra_art14_manufacturer_reporting(Profile, cra_art14_manufacturer_reporting_verdict(Status, Citations)) :-
    severe_incident_status(Profile, Status, Citations).

cra_art14_manufacturer_reporting_status(Profile, Status) :-
    decide_cra_art14_manufacturer_reporting(Profile, cra_art14_manufacturer_reporting_verdict(Status, _Citations)).

cra_art14_manufacturer_reporting_checklist(Profile, Items) :-
    cra_art14_manufacturer_reporting_input_problems(Profile, Problems),
    checklist_items(Problems, Profile, Items).

checklist_items([Problem|Problems], _, [item(input_check, unmet(input_problems([Problem|Problems])), cite(eu_reg_2024_2847_art_14_5))]).
checklist_items([], Profile, [item(severity_protection_of_data_or_functions, ProtectionStatus, cite(eu_reg_2024_2847_art_14_5_a)), item(severity_malicious_code, MaliciousCodeStatus, cite(eu_reg_2024_2847_art_14_5_b))]) :-
    judgement_state(Profile, affects_protection_of_sensitive_or_important_data_or_functions, Protection),
    judgement_state(Profile, leads_to_malicious_code_in_product_or_user_systems, MaliciousCode),
    limb_item_status(Protection, affects_protection_of_sensitive_or_important_data_or_functions, ProtectionStatus),
    limb_item_status(MaliciousCode, leads_to_malicious_code_in_product_or_user_systems, MaliciousCodeStatus).

limb_item_status(true, _, met) :-
    implements(eu_reg_2024_2847_art_14_5).
limb_item_status(false, _, unmet(limb_not_met)) :-
    implements(eu_reg_2024_2847_art_14_5).
limb_item_status(unsure, Key, unknown([Key])).
limb_item_status(absent, Key, unknown([Key])).

cra_art14_manufacturer_reporting_decision_resolvable(Profile) :-
    decide_cra_art14_manufacturer_reporting(Profile, _Verdict).

test(protection_limb_true_is_severe_once) :-
    findall(Status - Citations, severe_incident_status([attribute(affects_protection_of_sensitive_or_important_data_or_functions, true)], Status, Citations), Answers),
    Answers == [severe - [cite(eu_reg_2024_2847_art_14_5)]].
test(malicious_code_true_beside_unsure_is_severe) :-
    severe_incident_status([attribute(affects_protection_of_sensitive_or_important_data_or_functions, unsure), attribute(leads_to_malicious_code_in_product_or_user_systems, true)], severe, [cite(eu_reg_2024_2847_art_14_5)]).
test(unsure_beside_absent_names_the_absent_key) :-
    findall(Status, severe_incident_status([attribute(affects_protection_of_sensitive_or_important_data_or_functions, unsure)], Status, []), Statuses),
    Statuses == [indeterminate([leads_to_malicious_code_in_product_or_user_systems])].
test(absent_protection_beside_false_names_protection) :-
    severe_incident_status([attribute(leads_to_malicious_code_in_product_or_user_systems, false)], indeterminate([affects_protection_of_sensitive_or_important_data_or_functions]), []).
test(unsure_protection_refers_with_both_pairs) :-
    severe_incident_status([attribute(affects_protection_of_sensitive_or_important_data_or_functions, unsure), attribute(leads_to_malicious_code_in_product_or_user_systems, false)], Status, []),
    Status == needs_legal_review(open_textured(affects_protection_of_sensitive_or_important_data_or_functions, cite(eu_reg_2024_2847_art_14_5_a)), [inputs_relied_on([affects_protection_of_sensitive_or_important_data_or_functions - unsure, leads_to_malicious_code_in_product_or_user_systems - false])]).
test(unsure_malicious_code_refers_on_point_b) :-
    severe_incident_status([attribute(affects_protection_of_sensitive_or_important_data_or_functions, false), attribute(leads_to_malicious_code_in_product_or_user_systems, unsure)], needs_legal_review(open_textured(leads_to_malicious_code_in_product_or_user_systems, cite(eu_reg_2024_2847_art_14_5_b)), _), []).
test(both_limbs_false_is_not_severe) :-
    severe_incident_status([attribute(affects_protection_of_sensitive_or_important_data_or_functions, false), attribute(leads_to_malicious_code_in_product_or_user_systems, false)], not_severe, [cite(eu_reg_2024_2847_art_14_5_a), cite(eu_reg_2024_2847_art_14_5_b)]).
test(unknown_key_is_an_input_problem) :-
    severe_incident_status([attribute(colour, red)], input_problems([unknown_key(colour)]), []).
test(vulnerability_before_application_has_no_step) :-
    findall(Steps, manufacturer_reporting_steps([], actively_exploited_vulnerability, date(2026, 9, 10), Steps), Answers),
    Answers == [[]].
test(vulnerability_on_application_day_has_four_steps) :-
    findall(Steps, manufacturer_reporting_steps([], actively_exploited_vulnerability, date(2026, 9, 11), Steps), Answers),
    Answers == [[step_due(early_warning, hours_after_awareness(24), cite(eu_reg_2024_2847_art_14_2_a)), step_due(notification, hours_after_awareness(72), cite(eu_reg_2024_2847_art_14_2_b)), step_due(final_report, days_after_measure_available(14), cite(eu_reg_2024_2847_art_14_2_c)), step_due(intermediate_report, on_request_of_coordinator_csirt, cite(eu_reg_2024_2847_art_14_6))]].
test(severe_incident_has_four_steps) :-
    manufacturer_reporting_steps([attribute(leads_to_malicious_code_in_product_or_user_systems, true)], incident_impacting_product_security, date(2027, 1, 5), [step_due(early_warning, hours_after_awareness(24), cite(eu_reg_2024_2847_art_14_4_a)), step_due(notification, hours_after_awareness(72), cite(eu_reg_2024_2847_art_14_4_b)), step_due(final_report, months_after_notification(1), cite(eu_reg_2024_2847_art_14_4_c)), step_due(intermediate_report, on_request_of_coordinator_csirt, cite(eu_reg_2024_2847_art_14_6))]).
test(incident_not_severe_has_no_step) :-
    manufacturer_reporting_steps([attribute(affects_protection_of_sensitive_or_important_data_or_functions, false), attribute(leads_to_malicious_code_in_product_or_user_systems, false)], incident_impacting_product_security, date(2027, 1, 5), []).
test(incident_with_no_judgement_is_indeterminate) :-
    manufacturer_reporting_steps([], incident_impacting_product_security, date(2027, 1, 5), indeterminate([affects_protection_of_sensitive_or_important_data_or_functions])).
test(february_29_in_a_common_year_is_wrong) :-
    manufacturer_reporting_steps([], actively_exploited_vulnerability, date(2027, 2, 29), input_problems([wrong_type(awareness_date)])).
test(february_29_in_a_leap_year_is_a_day) :-
    manufacturer_reporting_steps([], actively_exploited_vulnerability, date(2028, 2, 29), [_, _, _, _]).
test(bad_event_and_date_follow_profile_problem) :-
    manufacturer_reporting_steps(oops, breach, date(2027, 13, 1), input_problems([wrong_type(profile), wrong_type(event), wrong_type(awareness_date)])).
test(early_warning_at_25_hours_is_late) :-
    findall(Result, manufacturer_reporting_step_timeliness([], actively_exploited_vulnerability, early_warning, 25, Result), Results),
    Results == [late(hour_limit)].
test(early_warning_at_24_hours_without_delay_is_on_time) :-
    manufacturer_reporting_step_timeliness([attribute(early_warning_without_undue_delay, true)], incident_impacting_product_security, early_warning, 24, on_time).
test(notification_within_limit_with_undue_delay_is_late) :-
    manufacturer_reporting_step_timeliness([attribute(notification_without_undue_delay, false)], actively_exploited_vulnerability, notification, 72, late(without_undue_delay)).
test(notification_without_key_is_indeterminate) :-
    manufacturer_reporting_step_timeliness([attribute(early_warning_without_undue_delay, true)], actively_exploited_vulnerability, notification, 30, indeterminate([notification_without_undue_delay])).
test(unsure_notification_refers_on_incident_point_b) :-
    manufacturer_reporting_step_timeliness([attribute(notification_without_undue_delay, unsure)], incident_impacting_product_security, notification, 10, Result),
    Result == needs_legal_review(open_textured(notification_without_undue_delay, cite(eu_reg_2024_2847_art_14_4_b)), [inputs_relied_on([notification_without_undue_delay - unsure])]).
test(bad_step_and_negative_hours_are_problems) :-
    manufacturer_reporting_step_timeliness([], actively_exploited_vulnerability, final_report, -1, input_problems([wrong_type(step), wrong_type(hours_elapsed)])).
test(checklist_has_one_row_per_limb) :-
    cra_art14_manufacturer_reporting_checklist([attribute(affects_protection_of_sensitive_or_important_data_or_functions, true)], [item(severity_protection_of_data_or_functions, met, _), item(severity_malicious_code, unknown([leads_to_malicious_code_in_product_or_user_systems]), _)]).

test(both_limbs_false_is_not_severe_as_severe, fail) :-
    severe_incident_status([attribute(affects_protection_of_sensitive_or_important_data_or_functions, false), attribute(leads_to_malicious_code_in_product_or_user_systems, false)], severe, _).
test(early_warning_at_24_hours_is_not_late, fail) :-
    manufacturer_reporting_step_timeliness([attribute(early_warning_without_undue_delay, true)], incident_impacting_product_security, early_warning, 24, late(_)).
