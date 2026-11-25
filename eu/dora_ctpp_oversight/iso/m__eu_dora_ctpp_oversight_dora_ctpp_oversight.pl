% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_ctpp_oversight_dora_ctpp_oversight, [ctpp_oversight_duties_required/3, ctpp_lead_overseer_powers/3, ctpp_response_window_status/3, ctpp_periodic_penalty_payment_status/3, ctpp_periodic_penalty_payment_limits/3, ctpp_competent_authority_measure_condition/3, decide_dora_ctpp_oversight/2, dora_ctpp_oversight_status/2, dora_ctpp_oversight_checklist/2, dora_ctpp_oversight_decision_resolvable/1, dora_ctpp_oversight_status_values/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(library(pairs), [pairs_values/2]).
:- use_module(clausal_lists_extra, [clausal_msort/2]).
:- use_module(library(clpz)).
:- use_module(library(reif), [memberd_t/3]).
:- use_module(clausal_datetime, [timedelta/3, date_add/3]).
:- use_module(clausal_dates, [days_between/3]).
:- use_module(formalize_lib, [profile_get/3, profile_lacks/2]).
:- use_module(deadline_lib, [month_last_day/3]).
:- use_module(m__eu_dora_ctpp_oversight_kernel, [dora_ctpp_oversight_input_problems/2]).
:- use_module(m__eu_dora_ctpp_oversight_citations, [implements/1]).

dora_ctpp_oversight_status_values([subject_to_lead_overseer_oversight, not_designated_as_critical, oversight_indeterminate, oversight_input_problems]).

window_row(oversight_plan_statement, draft_oversight_plan_received_on, cite(eu_reg_2022_2554_art_33_4)).
window_row(recommendation_information, recommendation_information_opportunity_given_on, cite(eu_reg_2022_2554_art_35_3)).

measure_power_row(information_request, penalty_ground, cite(eu_reg_2022_2554_art_35_1_a)).
measure_power_row(general_investigation, penalty_ground, cite(eu_reg_2022_2554_art_35_1_b)).
measure_power_row(inspection, penalty_ground, cite(eu_reg_2022_2554_art_35_1_b)).
measure_power_row(remediation_report_request, penalty_ground, cite(eu_reg_2022_2554_art_35_1_c)).
measure_power_row(recommendation, no_penalty_ground, cite(eu_reg_2022_2554_art_35_1_d)).

compliance_row(full, no_penalty_ground, cite(eu_reg_2022_2554_art_35_6)).
compliance_row(partial, penalty_ground, cite(eu_reg_2022_2554_art_35_6)).
compliance_row(none, penalty_ground, cite(eu_reg_2022_2554_art_35_6)).

key_value(Profile, Key, absent) :-
    profile_lacks(Profile, Key).
key_value(Profile, Key, value(Value)) :-
    profile_get(Profile, Key, Value).

keyed_states([], _, []).
keyed_states([Key|Keys], Profile, [Key - State|States]) :-
    key_value(Profile, Key, State),
    keyed_states(Keys, Profile, States).

ctpp_oversight_duties_required(Profile, Result, Citations) :-
    dora_ctpp_oversight_input_problems(Profile, Problems),
    duties_answer(Problems, Profile, Result, Citations).

duties_answer([Problem|Problems], _, input_problems([Problem|Problems]), []).
duties_answer([], Profile, Result, Citations) :-
    key_value(Profile, provider_designated_as_critical, Designation),
    duties_designation(Designation, Profile, Result, Citations).

duties_designation(value(false), _, not_designated_as_critical, [cite(eu_reg_2022_2554_art_35_5)]) :-
    implements(eu_reg_2022_2554_art_35_5).
duties_designation(absent, _, indeterminate([provider_designated_as_critical]), []).
duties_designation(value(true), Profile, Result, Citations) :-
    key_value(Profile, provider_plans_further_subcontracting_arrangement, Planning),
    duties_planning(Planning, Result, Citations).

duties_planning(absent, indeterminate([provider_plans_further_subcontracting_arrangement]), []).
duties_planning(value(true), required([transmit_subcontracting_information_to_lead_overseer, cooperate_in_good_faith_with_lead_overseer]), [cite(eu_reg_2022_2554_art_35_1_d), cite(eu_reg_2022_2554_art_35_5)]) :-
    implements(eu_reg_2022_2554_art_35_1_d).
duties_planning(value(false), required([cooperate_in_good_faith_with_lead_overseer]), [cite(eu_reg_2022_2554_art_35_5)]) :-
    implements(eu_reg_2022_2554_art_35_5).

ctpp_lead_overseer_powers(Profile, Result, Citations) :-
    dora_ctpp_oversight_input_problems(Profile, Problems),
    powers_answer(Problems, Profile, Result, Citations).

powers_answer([Problem|Problems], _, input_problems([Problem|Problems]), []).
powers_answer([], Profile, Result, Citations) :-
    key_value(Profile, provider_designated_as_critical, Designation),
    powers_designation(Designation, Profile, Result, Citations).

powers_designation(value(false), _, not_designated_as_critical, [cite(eu_reg_2022_2554_art_35_1)]) :-
    implements(eu_reg_2022_2554_art_35_1).
powers_designation(absent, _, indeterminate([provider_designated_as_critical]), []).
powers_designation(value(true), Profile, Result, Citations) :-
    key_value(Profile, oversight_activities_completed, Completion),
    powers_completion(Completion, Profile, Result, Citations).

powers_completion(absent, _, indeterminate([oversight_activities_completed]), []).
powers_completion(value(Completed), Profile, Result, Citations) :-
    point_four_fact_keys(Keys),
    keyed_states(Keys, Profile, KeyedStates),
    point_four_outcome(KeyedStates, Outcome),
    powers_outcome(Outcome, Completed, Result, Citations).

point_four_fact_keys([provider_plans_further_subcontracting_arrangement, envisaged_subcontractor_is_ict_provider_or_subcontractor_in_third_country, subcontracting_concerns_critical_or_important_functions, lead_overseer_deems_clear_and_serious_risk]) :-
    implements(eu_reg_2022_2554_art_35_1_d_iv),
    implements(eu_reg_2022_2554_art_35_1_d_iii).

point_four_outcome(KeyedStates, Outcome) :-
    implements(eu_reg_2022_2554_art_35_1_d_iv),
    pairs_values(KeyedStates, States),
    memberd_t(value(false), States, AnyFalse),
    point_four_after_false(AnyFalse, KeyedStates, Outcome).

point_four_after_false(true, _, refrain_not_listed).
point_four_after_false(false, KeyedStates, Outcome) :-
    first_absent_fact(KeyedStates, Outcome).

first_absent_fact([], refrain_listed).
first_absent_fact([Key - absent|_], missing(Key)).
first_absent_fact([_ - value(true)|KeyedStates], Outcome) :-
    first_absent_fact(KeyedStates, Outcome).

powers_outcome(missing(Key), _, indeterminate([Key]), []).
powers_outcome(refrain_listed, Completed, powers(Powers), Citations) :-
    powers_list(refrain_listed, Completed, Powers, Citations).
powers_outcome(refrain_not_listed, Completed, powers(Powers), Citations) :-
    powers_list(refrain_not_listed, Completed, Powers, Citations).

powers_list(RefrainOutcome, Completed, Powers, Citations) :-
    implements(eu_reg_2022_2554_art_35_1),
    information_power(InformationPowers, InformationCitations),
    investigation_power(InvestigationPowers, InvestigationCitations),
    remediation_power(Completed, RemediationPowers, RemediationCitations),
    recommendation_power(RecommendationPowers, RecommendationCitations),
    refrain_power(RefrainOutcome, RefrainPowers, RefrainCitations),
    append([InformationPowers, InvestigationPowers, RemediationPowers, RecommendationPowers, RefrainPowers], Powers),
    append([[cite(eu_reg_2022_2554_art_35_1)], InformationCitations, InvestigationCitations, RemediationCitations, RecommendationCitations, RefrainCitations], Citations).

information_power([request_information_and_documentation], [cite(eu_reg_2022_2554_art_35_1_a)]) :-
    implements(eu_reg_2022_2554_art_35_1_a).

investigation_power([conduct_general_investigations_and_inspections], [cite(eu_reg_2022_2554_art_35_1_b)]) :-
    implements(eu_reg_2022_2554_art_35_1_b).

remediation_power(true, [request_remediation_reports], [cite(eu_reg_2022_2554_art_35_1_c)]) :-
    implements(eu_reg_2022_2554_art_35_1_c).
remediation_power(false, [], []) :-
    implements(eu_reg_2022_2554_art_35_1_c).

recommendation_power([issue_recommendations], [cite(eu_reg_2022_2554_art_35_1_d)]) :-
    implements(eu_reg_2022_2554_art_35_1_d).

refrain_power(refrain_listed, [recommend_refraining_from_further_subcontracting], [cite(eu_reg_2022_2554_art_35_1_d_iv)]) :-
    implements(eu_reg_2022_2554_art_35_1_d_iv).
refrain_power(refrain_not_listed, [], []) :-
    implements(eu_reg_2022_2554_art_35_1_d_iv).

ctpp_response_window_status(Profile, Result, Citations) :-
    dora_ctpp_oversight_input_problems(Profile, Problems),
    window_answer(Problems, Profile, Result, Citations).

window_answer([Problem|Problems], _, input_problems([Problem|Problems]), []).
window_answer([], Profile, Result, Citations) :-
    key_value(Profile, provider_designated_as_critical, Designation),
    window_designation(Designation, Profile, Result, Citations).

window_designation(value(false), _, not_designated_as_critical, [cite(eu_reg_2022_2554_art_33_4), cite(eu_reg_2022_2554_art_35_3)]) :-
    implements(eu_reg_2022_2554_art_33_4).
window_designation(absent, _, indeterminate([provider_designated_as_critical]), []).
window_designation(value(true), Profile, Result, Citations) :-
    key_value(Profile, response_window, WindowState),
    window_choice(WindowState, Profile, Result, Citations).

window_choice(absent, _, indeterminate([response_window]), []).
window_choice(value(Window), Profile, Result, Citations) :-
    window_row(Window, StartKey, Citation),
    key_value(Profile, StartKey, StartState),
    window_start(StartState, StartKey, Window, Citation, Profile, Result, Citations).

window_start(absent, StartKey, _, _, _, indeterminate([StartKey]), []).
window_start(value(Start), _, Window, Citation, Profile, Result, Citations) :-
    key_value(Profile, assessment_date, AssessmentState),
    window_assessment(AssessmentState, Start, Window, Citation, Result, Citations).

window_assessment(absent, _, _, _, indeterminate([assessment_date]), []).
window_assessment(value(Assessment), Start, Window, Citation, Result, [Citation]) :-
    window_last_day(Window, Start, LastDay),
    calendar_position(Assessment, Start, LastDay, Position),
    window_position_result(Window, Position, LastDay, Result).

window_last_day(oversight_plan_statement, Start, LastDay) :-
    implements(eu_reg_2022_2554_art_33_4),
    PeriodDays #= 15,
    timedelta(PeriodDays, 0, StatementPeriod),
    date_add(Start, StatementPeriod, LastDay).
window_last_day(recommendation_information, Start, LastDay) :-
    implements(eu_reg_2022_2554_art_35_3),
    PeriodDays #= 30,
    timedelta(PeriodDays, 0, InformationPeriod),
    date_add(Start, InformationPeriod, LastDay).

calendar_position(Day, Start, LastDay, Position) :-
    days_between(Day, Start, DaysFromStart),
    days_between(Day, LastDay, DaysFromLastDay),
    position_from_days(DaysFromStart, DaysFromLastDay, Position).

position_from_days(DaysFromStart, _, before) :-
    DaysFromStart #< 0.
position_from_days(DaysFromStart, DaysFromLastDay, within) :-
    DaysFromStart #>= 0,
    DaysFromLastDay #< 1.
position_from_days(_, DaysFromLastDay, after) :-
    DaysFromLastDay #> 0.

window_position_result(oversight_plan_statement, before, LastDay, window_not_yet_open(LastDay)) :-
    implements(eu_reg_2022_2554_art_33_4).
window_position_result(oversight_plan_statement, within, LastDay, window_open(LastDay)) :-
    implements(eu_reg_2022_2554_art_33_4).
window_position_result(oversight_plan_statement, after, LastDay, window_closed(LastDay)) :-
    implements(eu_reg_2022_2554_art_33_4).
window_position_result(recommendation_information, before, LastDay, window_not_yet_open(LastDay)) :-
    implements(eu_reg_2022_2554_art_35_3).
window_position_result(recommendation_information, within, LastDay, window_open(LastDay)) :-
    implements(eu_reg_2022_2554_art_35_3).
window_position_result(recommendation_information, after, LastDay, window_closed(LastDay)) :-
    implements(eu_reg_2022_2554_art_35_3).

ctpp_periodic_penalty_payment_status(Profile, Result, Citations) :-
    dora_ctpp_oversight_input_problems(Profile, Problems),
    penalty_answer(Problems, Profile, Result, Citations).

penalty_answer([Problem|Problems], _, input_problems([Problem|Problems]), []).
penalty_answer([], Profile, Result, Citations) :-
    key_value(Profile, provider_designated_as_critical, Designation),
    penalty_designation(Designation, Profile, Result, Citations).

penalty_designation(value(false), _, not_designated_as_critical, [cite(eu_reg_2022_2554_art_35_6)]) :-
    implements(eu_reg_2022_2554_art_35_6).
penalty_designation(absent, _, indeterminate([provider_designated_as_critical]), []).
penalty_designation(value(true), Profile, Result, Citations) :-
    key_value(Profile, measure_power, PowerState),
    penalty_power(PowerState, Profile, Result, Citations).

penalty_power(absent, _, indeterminate([measure_power]), []).
penalty_power(value(Power), Profile, Result, Citations) :-
    measure_power_row(Power, Ground, _PowerCitation),
    penalty_power_ground(Ground, Profile, Result, Citations).

penalty_power_ground(no_penalty_ground, _, no_penalty_ground_recommendation, [cite(eu_reg_2022_2554_art_35_6)]) :-
    implements(eu_reg_2022_2554_art_35_6).
penalty_power_ground(penalty_ground, Profile, Result, Citations) :-
    key_value(Profile, measure_compliance, ComplianceState),
    penalty_compliance(ComplianceState, Profile, Result, Citations).

penalty_compliance(absent, _, indeterminate([measure_compliance]), []).
penalty_compliance(value(Compliance), Profile, Result, Citations) :-
    compliance_row(Compliance, Ground, _ComplianceCitation),
    penalty_compliance_ground(Ground, Profile, Result, Citations).

penalty_compliance_ground(no_penalty_ground, _, no_penalty_ground_full_compliance, [cite(eu_reg_2022_2554_art_35_6)]) :-
    implements(eu_reg_2022_2554_art_35_6).
penalty_compliance_ground(penalty_ground, Profile, Result, Citations) :-
    key_value(Profile, measure_notification_received_on, NotificationState),
    penalty_notification(NotificationState, Profile, Result, Citations).

penalty_notification(absent, _, indeterminate([measure_notification_received_on]), []).
penalty_notification(value(Received), Profile, Result, Citations) :-
    key_value(Profile, assessment_date, AssessmentState),
    penalty_assessment(AssessmentState, Received, Result, Citations).

penalty_assessment(absent, _, indeterminate([assessment_date]), []).
penalty_assessment(value(Assessment), Received, Result, [cite(eu_reg_2022_2554_art_35_6)]) :-
    implements(eu_reg_2022_2554_art_35_6),
    penalty_first_day(Received, FirstDay),
    days_between(Assessment, FirstDay, DaysFromFirstDay),
    penalty_timing(DaysFromFirstDay, FirstDay, Result).

penalty_first_day(Received, FirstDay) :-
    implements(eu_reg_2022_2554_art_35_6),
    OffsetDays #= 30 + 1,
    timedelta(OffsetDays, 0, WaitingPeriod),
    date_add(Received, WaitingPeriod, FirstDay).

penalty_timing(DaysFromFirstDay, FirstDay, penalty_waiting_period_running(FirstDay)) :-
    implements(eu_reg_2022_2554_art_35_6),
    DaysFromFirstDay #< 0.
penalty_timing(DaysFromFirstDay, _, penalty_decision_required) :-
    implements(eu_reg_2022_2554_art_35_6),
    DaysFromFirstDay #>= 0.

ctpp_periodic_penalty_payment_limits(Profile, Result, Citations) :-
    dora_ctpp_oversight_input_problems(Profile, Problems),
    limits_answer(Problems, Profile, Result, Citations).

limits_answer([Problem|Problems], _, input_problems([Problem|Problems]), []).
limits_answer([], Profile, Result, Citations) :-
    key_value(Profile, provider_designated_as_critical, Designation),
    limits_designation(Designation, Profile, Result, Citations).

limits_designation(value(false), _, not_designated_as_critical, [cite(eu_reg_2022_2554_art_35_7), cite(eu_reg_2022_2554_art_35_8)]) :-
    implements(eu_reg_2022_2554_art_35_7).
limits_designation(absent, _, indeterminate([provider_designated_as_critical]), []).
limits_designation(value(true), Profile, Result, Citations) :-
    key_value(Profile, penalty_decision_notified_on, NotificationState),
    limits_notification(NotificationState, Profile, Result, Citations).

limits_notification(absent, _, indeterminate([penalty_decision_notified_on]), []).
limits_notification(value(Notified), Profile, Result, Citations) :-
    key_value(Profile, preceding_business_year_worldwide_turnover, TurnoverState),
    limits_turnover(TurnoverState, Notified, Profile, Result, Citations).

limits_turnover(absent, _, _, indeterminate([preceding_business_year_worldwide_turnover]), []).
limits_turnover(value(Turnover), Notified, _, penalty_limits(amount(0, 1), LastDay), [cite(eu_reg_2022_2554_art_35_7), cite(eu_reg_2022_2554_art_35_8)]) :-
    implements(eu_reg_2022_2554_art_35_8),
    Turnover #= 0,
    penalty_last_day(Notified, LastDay).
limits_turnover(value(Turnover), Notified, Profile, Result, Citations) :-
    Turnover #> 0,
    key_value(Profile, preceding_business_year_length_in_days, LengthState),
    limits_year_length(LengthState, Turnover, Notified, Result, Citations).

limits_year_length(absent, _, _, indeterminate([preceding_business_year_length_in_days]), []).
limits_year_length(value(YearDays), Turnover, Notified, penalty_limits(amount(Numerator, Denominator), LastDay), [cite(eu_reg_2022_2554_art_35_7), cite(eu_reg_2022_2554_art_35_8)]) :-
    implements(eu_reg_2022_2554_art_35_8),
    daily_ceiling(Turnover, YearDays, Numerator, Denominator),
    penalty_last_day(Notified, LastDay).

daily_ceiling(Turnover, YearDays, Numerator, Denominator) :-
    implements(eu_reg_2022_2554_art_35_8),
    RawNumerator #= Turnover * 1,
    RawDenominator #= 100 * YearDays,
    greatest_common_divisor(RawNumerator, RawDenominator, Divisor),
    Numerator #= RawNumerator // Divisor,
    Denominator #= RawDenominator // Divisor.

greatest_common_divisor(Number, 0, Number).
greatest_common_divisor(Number, Other, Divisor) :-
    Other #> 0,
    Remainder #= Number mod Other,
    greatest_common_divisor(Other, Remainder, Divisor).

penalty_last_day(date(Year, Month, DayNumber), date(LastYear, LastMonth, LastDayNumber)) :-
    implements(eu_reg_2022_2554_art_35_7),
    MonthIndex #= Month - 1 + 6,
    LastYear #= Year + MonthIndex // 12,
    LastMonth #= MonthIndex mod 12 + 1,
    month_last_day(LastYear, LastMonth, MonthLength),
    clamped_day(DayNumber, MonthLength, LastDayNumber).

clamped_day(DayNumber, MonthLength, DayNumber) :-
    DayNumber #=< MonthLength.
clamped_day(DayNumber, MonthLength, MonthLength) :-
    DayNumber #> MonthLength.

ctpp_competent_authority_measure_condition(Profile, Result, Citations) :-
    dora_ctpp_oversight_input_problems(Profile, Problems),
    measure_answer(Problems, Profile, Result, Citations).

measure_answer([Problem|Problems], _, input_problems([Problem|Problems]), []).
measure_answer([], Profile, Result, Citations) :-
    key_value(Profile, provider_designated_as_critical, Designation),
    measure_designation(Designation, Profile, Result, Citations).

measure_designation(value(false), _, not_designated_as_critical, [cite(eu_reg_2022_2554_art_33_5)]) :-
    implements(eu_reg_2022_2554_art_33_5).
measure_designation(absent, _, indeterminate([provider_designated_as_critical]), []).
measure_designation(value(true), Profile, Result, Citations) :-
    key_value(Profile, annual_oversight_plan_adopted_and_notified, PlanState),
    measure_plan(PlanState, Result, Citations).

measure_plan(absent, indeterminate([annual_oversight_plan_adopted_and_notified]), []).
measure_plan(value(true), lead_overseer_agreement_required, [cite(eu_reg_2022_2554_art_33_5)]) :-
    implements(eu_reg_2022_2554_art_33_5).
measure_plan(value(false), no_article_33_5_condition, [cite(eu_reg_2022_2554_art_33_5)]) :-
    implements(eu_reg_2022_2554_art_33_5).

decide_dora_ctpp_oversight(Profile, Verdict) :-
    dora_ctpp_oversight_input_problems(Profile, Problems),
    facade_answer(Problems, Profile, Verdict).

facade_answer([_|_], _, dora_ctpp_oversight_verdict(oversight_input_problems, [])).
facade_answer([], Profile, Verdict) :-
    key_value(Profile, provider_designated_as_critical, Designation),
    facade_designation(Designation, Verdict).

facade_designation(value(true), dora_ctpp_oversight_verdict(subject_to_lead_overseer_oversight, [cite(eu_reg_2022_2554_art_35_1), cite(eu_reg_2022_2554_art_35_5)])) :-
    implements(eu_reg_2022_2554_art_35_1).
facade_designation(value(false), dora_ctpp_oversight_verdict(not_designated_as_critical, [cite(eu_reg_2022_2554_art_35_1)])) :-
    implements(eu_reg_2022_2554_art_35_1).
facade_designation(absent, dora_ctpp_oversight_verdict(oversight_indeterminate, [])).

dora_ctpp_oversight_status(Profile, Status) :-
    decide_dora_ctpp_oversight(Profile, dora_ctpp_oversight_verdict(Status, _Citations)).

dora_ctpp_oversight_checklist(Profile, [item(oversight_duties_required, DutiesResult, DutiesCitations), item(lead_overseer_powers, PowersResult, PowersCitations), item(response_window_status, WindowResult, WindowCitations), item(periodic_penalty_payment_status, PenaltyResult, PenaltyCitations), item(periodic_penalty_payment_limits, LimitsResult, LimitsCitations), item(competent_authority_measure_condition, MeasureResult, MeasureCitations)]) :-
    ctpp_oversight_duties_required(Profile, DutiesResult, DutiesCitations),
    ctpp_lead_overseer_powers(Profile, PowersResult, PowersCitations),
    ctpp_response_window_status(Profile, WindowResult, WindowCitations),
    ctpp_periodic_penalty_payment_status(Profile, PenaltyResult, PenaltyCitations),
    ctpp_periodic_penalty_payment_limits(Profile, LimitsResult, LimitsCitations),
    ctpp_competent_authority_measure_condition(Profile, MeasureResult, MeasureCitations).

dora_ctpp_oversight_decision_resolvable(Profile) :-
    decide_dora_ctpp_oversight(Profile, _Verdict).

test(duties_with_planned_subcontracting) :-
    findall(Result - Citations, ctpp_oversight_duties_required([attribute(provider_designated_as_critical, true), attribute(provider_plans_further_subcontracting_arrangement, true)], Result, Citations), Answers),
    Answers = [required([transmit_subcontracting_information_to_lead_overseer, cooperate_in_good_faith_with_lead_overseer]) - Found],
    clausal_msort(Found, Sorted),
    Sorted == [cite(eu_reg_2022_2554_art_35_1_d), cite(eu_reg_2022_2554_art_35_5)].
test(duties_without_planned_subcontracting) :-
    ctpp_oversight_duties_required([attribute(provider_designated_as_critical, true), attribute(provider_plans_further_subcontracting_arrangement, false)], Result, Citations),
    Result == required([cooperate_in_good_faith_with_lead_overseer]),
    Citations == [cite(eu_reg_2022_2554_art_35_5)].
test(duties_not_designated) :-
    ctpp_oversight_duties_required([attribute(provider_designated_as_critical, false)], Result, Citations),
    Result == not_designated_as_critical,
    Citations == [cite(eu_reg_2022_2554_art_35_5)].
test(duties_designation_named_first) :-
    ctpp_oversight_duties_required([], Result, Citations),
    Result == indeterminate([provider_designated_as_critical]),
    Citations == [].
test(duties_planning_named) :-
    ctpp_oversight_duties_required([attribute(provider_designated_as_critical, true)], Result, Citations),
    Result == indeterminate([provider_plans_further_subcontracting_arrangement]),
    Citations == [].
test(powers_all_listed) :-
    findall(Result, ctpp_lead_overseer_powers([attribute(provider_designated_as_critical, true), attribute(oversight_activities_completed, true), attribute(provider_plans_further_subcontracting_arrangement, true), attribute(envisaged_subcontractor_is_ict_provider_or_subcontractor_in_third_country, true), attribute(subcontracting_concerns_critical_or_important_functions, true), attribute(lead_overseer_deems_clear_and_serious_risk, true)], Result, _), Results),
    Results == [powers([request_information_and_documentation, conduct_general_investigations_and_inspections, request_remediation_reports, issue_recommendations, recommend_refraining_from_further_subcontracting])].
test(powers_false_fact_settles_without_absent_one) :-
    ctpp_lead_overseer_powers([attribute(provider_designated_as_critical, true), attribute(oversight_activities_completed, false), attribute(subcontracting_concerns_critical_or_important_functions, false)], Result, Citations),
    Result == powers([request_information_and_documentation, conduct_general_investigations_and_inspections, issue_recommendations]),
    clausal_msort(Citations, Sorted),
    Sorted == [cite(eu_reg_2022_2554_art_35_1), cite(eu_reg_2022_2554_art_35_1_a), cite(eu_reg_2022_2554_art_35_1_b), cite(eu_reg_2022_2554_art_35_1_d)].
test(powers_first_absent_point_four_fact_named) :-
    ctpp_lead_overseer_powers([attribute(provider_designated_as_critical, true), attribute(oversight_activities_completed, true), attribute(provider_plans_further_subcontracting_arrangement, true)], Result, Citations),
    Result == indeterminate([envisaged_subcontractor_is_ict_provider_or_subcontractor_in_third_country]),
    Citations == [].
test(powers_oversight_activities_named_first) :-
    ctpp_lead_overseer_powers([attribute(provider_designated_as_critical, true)], Result, _),
    Result == indeterminate([oversight_activities_completed]).
test(powers_not_designated) :-
    ctpp_lead_overseer_powers([attribute(provider_designated_as_critical, false)], Result, Citations),
    Result == not_designated_as_critical,
    Citations == [cite(eu_reg_2022_2554_art_35_1)].
test(statement_window_open_on_last_day) :-
    findall(Result - Citations, ctpp_response_window_status([attribute(provider_designated_as_critical, true), attribute(response_window, oversight_plan_statement), attribute(draft_oversight_plan_received_on, date(2026, 1, 1)), attribute(assessment_date, date(2026, 1, 16))], Result, Citations), Answers),
    Answers = [window_open(date(2026, 1, 16)) - [cite(eu_reg_2022_2554_art_33_4)]].
test(statement_window_open_on_start_day) :-
    ctpp_response_window_status([attribute(provider_designated_as_critical, true), attribute(response_window, oversight_plan_statement), attribute(draft_oversight_plan_received_on, date(2026, 1, 1)), attribute(assessment_date, date(2026, 1, 1))], window_open(date(2026, 1, 16)), _).
test(statement_window_closed_after_last_day) :-
    ctpp_response_window_status([attribute(provider_designated_as_critical, true), attribute(response_window, oversight_plan_statement), attribute(draft_oversight_plan_received_on, date(2026, 1, 1)), attribute(assessment_date, date(2026, 1, 17))], window_closed(date(2026, 1, 16)), _).
test(statement_window_not_yet_open) :-
    ctpp_response_window_status([attribute(provider_designated_as_critical, true), attribute(response_window, oversight_plan_statement), attribute(draft_oversight_plan_received_on, date(2026, 1, 1)), attribute(assessment_date, date(2025, 12, 31))], window_not_yet_open(date(2026, 1, 16)), _).
test(information_window_runs_thirty_days) :-
    ctpp_response_window_status([attribute(provider_designated_as_critical, true), attribute(response_window, recommendation_information), attribute(recommendation_information_opportunity_given_on, date(2026, 1, 1)), attribute(assessment_date, date(2026, 1, 31))], window_open(date(2026, 1, 31)), [cite(eu_reg_2022_2554_art_35_3)]).
test(window_start_key_named) :-
    ctpp_response_window_status([attribute(provider_designated_as_critical, true), attribute(response_window, recommendation_information), attribute(draft_oversight_plan_received_on, date(2026, 1, 1))], Result, Citations),
    Result == indeterminate([recommendation_information_opportunity_given_on]),
    Citations == [].
test(window_not_designated_cites_both) :-
    ctpp_response_window_status([attribute(provider_designated_as_critical, false)], Result, Citations),
    Result == not_designated_as_critical,
    clausal_msort(Citations, Sorted),
    Sorted == [cite(eu_reg_2022_2554_art_33_4), cite(eu_reg_2022_2554_art_35_3)].
test(penalty_waiting_period_running_on_day_thirty) :-
    ctpp_periodic_penalty_payment_status([attribute(provider_designated_as_critical, true), attribute(measure_power, information_request), attribute(measure_compliance, partial), attribute(measure_notification_received_on, date(2026, 1, 1)), attribute(assessment_date, date(2026, 1, 31))], penalty_waiting_period_running(date(2026, 2, 1)), [cite(eu_reg_2022_2554_art_35_6)]).
test(penalty_decision_required_on_first_day) :-
    findall(Result, ctpp_periodic_penalty_payment_status([attribute(provider_designated_as_critical, true), attribute(measure_power, inspection), attribute(measure_compliance, none), attribute(measure_notification_received_on, date(2026, 1, 1)), attribute(assessment_date, date(2026, 2, 1))], Result, _), Results),
    Results == [penalty_decision_required].
test(penalty_recommendation_is_no_ground) :-
    ctpp_periodic_penalty_payment_status([attribute(provider_designated_as_critical, true), attribute(measure_power, recommendation)], Result, Citations),
    Result == no_penalty_ground_recommendation,
    Citations == [cite(eu_reg_2022_2554_art_35_6)].
test(penalty_full_compliance_is_no_ground) :-
    ctpp_periodic_penalty_payment_status([attribute(provider_designated_as_critical, true), attribute(measure_power, remediation_report_request), attribute(measure_compliance, full)], Result, _),
    Result == no_penalty_ground_full_compliance.
test(penalty_notification_named_before_assessment_date) :-
    ctpp_periodic_penalty_payment_status([attribute(provider_designated_as_critical, true), attribute(measure_power, general_investigation), attribute(measure_compliance, partial)], Result, Citations),
    Result == indeterminate([measure_notification_received_on]),
    Citations == [].
test(limits_end_of_february) :-
    ctpp_periodic_penalty_payment_limits([attribute(provider_designated_as_critical, true), attribute(penalty_decision_notified_on, date(2026, 8, 31)), attribute(preceding_business_year_worldwide_turnover, 36500000), attribute(preceding_business_year_length_in_days, 365)], Result, Citations),
    Result == penalty_limits(amount(1000, 1), date(2027, 2, 28)),
    clausal_msort(Citations, Sorted),
    Sorted == [cite(eu_reg_2022_2554_art_35_7), cite(eu_reg_2022_2554_art_35_8)].
test(limits_exact_fraction) :-
    ctpp_periodic_penalty_payment_limits([attribute(provider_designated_as_critical, true), attribute(penalty_decision_notified_on, date(2026, 7, 15)), attribute(preceding_business_year_worldwide_turnover, 1), attribute(preceding_business_year_length_in_days, 365)], Result, _),
    Result == penalty_limits(amount(1, 36500), date(2027, 1, 15)).
test(limits_zero_turnover_needs_no_year_length) :-
    ctpp_periodic_penalty_payment_limits([attribute(provider_designated_as_critical, true), attribute(penalty_decision_notified_on, date(2026, 1, 10)), attribute(preceding_business_year_worldwide_turnover, 0)], Result, _),
    Result == penalty_limits(amount(0, 1), date(2026, 7, 10)).
test(limits_year_length_named) :-
    ctpp_periodic_penalty_payment_limits([attribute(provider_designated_as_critical, true), attribute(penalty_decision_notified_on, date(2026, 1, 10)), attribute(preceding_business_year_worldwide_turnover, 5)], Result, Citations),
    Result == indeterminate([preceding_business_year_length_in_days]),
    Citations == [].
test(measure_agreement_required) :-
    ctpp_competent_authority_measure_condition([attribute(provider_designated_as_critical, true), attribute(annual_oversight_plan_adopted_and_notified, true)], Result, Citations),
    Result == lead_overseer_agreement_required,
    Citations == [cite(eu_reg_2022_2554_art_33_5)].
test(measure_no_condition_yet) :-
    ctpp_competent_authority_measure_condition([attribute(provider_designated_as_critical, true), attribute(annual_oversight_plan_adopted_and_notified, false)], no_article_33_5_condition, _).
test(input_problems_come_first) :-
    ctpp_competent_authority_measure_condition([attribute(provider_designated_as_critical, true), attribute(colour, blue)], Result, Citations),
    Result == input_problems([unknown_key(colour)]),
    Citations == [].
test(facade_designated_provider_is_under_oversight) :-
    dora_ctpp_oversight_status([attribute(provider_designated_as_critical, true)], subject_to_lead_overseer_oversight).
test(facade_absent_designation_is_indeterminate) :-
    dora_ctpp_oversight_status([], oversight_indeterminate).
test(facade_checklist_has_six_rows) :-
    dora_ctpp_oversight_checklist([attribute(provider_designated_as_critical, false)], Items),
    length(Items, 6).

test(duties_not_designated_is_not_required, fail) :-
    ctpp_oversight_duties_required([attribute(provider_designated_as_critical, false)], required(_), _).
test(statement_window_closed_is_not_open, fail) :-
    ctpp_response_window_status([attribute(provider_designated_as_critical, true), attribute(response_window, oversight_plan_statement), attribute(draft_oversight_plan_received_on, date(2026, 1, 1)), attribute(assessment_date, date(2026, 1, 17))], window_open(_), _).
test(measure_no_condition_is_not_agreement, fail) :-
    ctpp_competent_authority_measure_condition([attribute(provider_designated_as_critical, true), attribute(annual_oversight_plan_adopted_and_notified, false)], lead_overseer_agreement_required, _).
