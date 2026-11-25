% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_ai_act_serious_incident_reporting_serious_incident_reporting, [serious_incident_report_duty/4, serious_incident_report_timeliness/5, decide_serious_incident_reporting/2, serious_incident_reporting_status/2, serious_incident_reporting_checklist/2, serious_incident_reporting_decision_resolvable/1, serious_incident_reporting_status_values/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(library(error), [must_be/2]).
:- use_module(clausal_lists_extra, [subtract/3]).
:- use_module(library(clpz)).
:- use_module(library(reif), [memberd_t/3]).
:- use_module(clausal_datetime, [timedelta/3, date_add/3]).
:- use_module(formalize_lib, [profile_get/3, profile_has/2, profile_lacks/2]).
:- use_module(m__eu_ai_act_serious_incident_reporting_kernel, [serious_incident_reporting_input_problems/2]).
:- use_module(m__eu_ai_act_serious_incident_reporting_citations, [implements/1]).

chapter_iii_application_date(annex_iii_high_risk, date(2027, 12, 2), cite(eu_reg_2024_1689_art_113_c_i)).
chapter_iii_application_date(annex_i_high_risk, date(2028, 8, 2), cite(eu_reg_2024_1689_art_113_c_ii)).

public_authorities_compliance_date(date(2030, 8, 2), cite(eu_reg_2024_1689_art_111_2)).

reporting_period(critical_infrastructure_or_widespread_infringement, 2, cite(eu_reg_2024_1689_art_73_3)).
reporting_period(death_of_a_person, 10, cite(eu_reg_2024_1689_art_73_4)).
reporting_period(other_serious_incident, 15, cite(eu_reg_2024_1689_art_73_2)).

follow_up_duties([perform_necessary_investigations_without_delay, risk_assessment_of_the_incident, corrective_action, cooperate_with_competent_authorities, inform_authorities_before_altering_the_system], cite(eu_reg_2024_1689_art_73_6)).

referral_row(significant_change_in_design_since_that_date, cite(eu_reg_2024_1689_art_111_2)).
referral_row(intended_to_be_used_by_public_authorities, cite(eu_reg_2024_1689_art_111_2)).
referral_row(provider_subject_to_equivalent_union_reporting_obligations, cite(eu_reg_2024_1689_art_73_9)).
referral_row(widespread_infringement, cite(eu_reg_2024_1689_art_3_61)).
referral_row(report_made_immediately, cite(eu_reg_2024_1689_art_73_2)).

root_key_order([high_risk_classification, placed_before_chapter_iii_application_date, significant_change_in_design_since_that_date, intended_to_be_used_by_public_authorities, medical_device_or_safety_component_of_one, provider_subject_to_equivalent_union_reporting_obligations, harm_to_health, critical_infrastructure_disruption, fundamental_rights_obligations_infringed, serious_harm_to_property_or_environment, widespread_infringement, report_made_immediately, system_under_the_exclusive_competence_of_the_ai_office]).

query_judgement_keys(duty(_), [significant_change_in_design_since_that_date, intended_to_be_used_by_public_authorities, provider_subject_to_equivalent_union_reporting_obligations, widespread_infringement]).
query_judgement_keys(timeliness(_, _), [significant_change_in_design_since_that_date, intended_to_be_used_by_public_authorities, provider_subject_to_equivalent_union_reporting_obligations, widespread_infringement, report_made_immediately]).

no_duty_answer(not_applicable_on_date).
no_duty_answer(not_a_high_risk_ai_system).
no_duty_answer(not_covered_placed_before_application_date).
no_duty_answer(not_a_serious_incident).
no_duty_answer(not_a_reportable_incident).

serious_incident_reporting_status_values([not_applicable_on_date, not_a_high_risk_ai_system, not_covered_placed_before_application_date, not_a_serious_incident, not_a_reportable_incident, report_in_time, report_after_time_limit, report_not_immediate]).

serious_incident_report_duty(Profile, AwarenessDate, Duty, Citations) :-
    serious_incident_reporting_input_problems(Profile, ProfileProblems),
    date_valid_t(AwarenessDate, AwarenessValid),
    date_problems(AwarenessValid, awareness_date, AwarenessProblems),
    append(ProfileProblems, AwarenessProblems, Problems),
    answer_after_check(Problems, duty(AwarenessDate), Profile, Duty, Citations).

serious_incident_report_timeliness(Profile, AwarenessDate, ReportDate, Verdict, Citations) :-
    serious_incident_reporting_input_problems(Profile, ProfileProblems),
    date_valid_t(AwarenessDate, AwarenessValid),
    date_problems(AwarenessValid, awareness_date, AwarenessProblems),
    date_valid_t(ReportDate, ReportValid),
    date_problems(ReportValid, report_date, ReportProblems),
    append([ProfileProblems, AwarenessProblems, ReportProblems], Problems),
    answer_after_check(Problems, timeliness(AwarenessDate, ReportDate), Profile, Verdict, Citations).

answer_after_check([Problem|Problems], _, _, input_problems([Problem|Problems]), []).
answer_after_check([], Query, Profile, Answer, Citations) :-
    unsure_rule(Query, Profile, Answer, Citations).

date_problems(true, _, []).
date_problems(false, Name, [wrong_type(Name)]).

date_valid_t(Term, false) :-
    var(Term).
date_valid_t(Term, false) :-
    nonvar(Term),
    Term \= date(_, _, _).
date_valid_t(Term, Truth) :-
    nonvar(Term),
    Term = date(Year, Month, Day),
    integer_t(Year, YearInteger),
    integer_t(Month, MonthInteger),
    integer_t(Day, DayInteger),
    truth_and(YearInteger, MonthInteger, YearMonthInteger),
    truth_and(YearMonthInteger, DayInteger, AllIntegers),
    calendar_day_t(AllIntegers, Year, Month, Day, Truth).

integer_t(Value, Truth) :-
    catch(integer_truth(Value, Truth), _, Truth = false).

integer_truth(Value, true) :-
    must_be(integer, Value).

calendar_day_t(false, _, _, _, false).
calendar_day_t(true, Year, Month, Day, Truth) :-
    in_range_t(Year, 1, 9999, YearInRange),
    in_range_t(Month, 1, 12, MonthInRange),
    truth_and(YearInRange, MonthInRange, YearMonthInRange),
    day_in_month_t(YearMonthInRange, Year, Month, Day, Truth).

day_in_month_t(false, _, _, _, false).
day_in_month_t(true, Year, Month, Day, Truth) :-
    leap_year_t(Year, Leap),
    month_length(Month, Leap, MonthDays),
    in_range_t(Day, 1, MonthDays, Truth).

in_range_t(Value, Low, High, true) :-
    Value #>= Low,
    Value #=< High.
in_range_t(Value, Low, _, false) :-
    Value #< Low.
in_range_t(Value, _, High, false) :-
    Value #> High.

leap_year_t(Year, true) :-
    Year mod 400 #= 0.
leap_year_t(Year, true) :-
    Year mod 4 #= 0,
    Year mod 100 #\= 0.
leap_year_t(Year, false) :-
    Year mod 4 #\= 0.
leap_year_t(Year, false) :-
    Year mod 100 #= 0,
    Year mod 400 #\= 0.

month_length(1, _, 31).
month_length(2, true, 29).
month_length(2, false, 28).
month_length(3, _, 31).
month_length(4, _, 30).
month_length(5, _, 31).
month_length(6, _, 30).
month_length(7, _, 31).
month_length(8, _, 31).
month_length(9, _, 30).
month_length(10, _, 31).
month_length(11, _, 30).
month_length(12, _, 31).

date_key(date(Year, Month, Day), Key) :-
    Key #= Year * 10000 + Month * 100 + Day.

date_reached_t(Date, Threshold, Truth) :-
    date_key(Date, DateKey),
    date_key(Threshold, ThresholdKey),
    key_reached_t(DateKey, ThresholdKey, Truth).

key_reached_t(DateKey, ThresholdKey, true) :-
    DateKey #>= ThresholdKey.
key_reached_t(DateKey, ThresholdKey, false) :-
    DateKey #< ThresholdKey.

date_later_t(Date, Threshold, Truth) :-
    date_key(Date, DateKey),
    date_key(Threshold, ThresholdKey),
    key_later_t(DateKey, ThresholdKey, Truth).

key_later_t(DateKey, ThresholdKey, true) :-
    DateKey #> ThresholdKey.
key_later_t(DateKey, ThresholdKey, false) :-
    DateKey #=< ThresholdKey.

last_day(AwarenessDate, Days, LastDay) :-
    implements(eu_reg_2024_1689_art_73_2),
    timedelta(Days, 0, ReportingPeriod),
    date_add(AwarenessDate, ReportingPeriod, LastDay).

key_value(Profile, Key, Value) :-
    profile_has(Profile, Key),
    profile_get(Profile, Key, Value).
key_value(Profile, Key, absent) :-
    profile_lacks(Profile, Key).

key_pairs(Profile, Keys, Pairs) :-
    maplist(key_pair(Profile), Keys, Pairs).

key_pair(Profile, Key, Key - Value) :-
    key_value(Profile, Key, Value).

same_value_t(Left, Right, true) :-
    Left == Right.
same_value_t(Left, Right, false) :-
    Left \== Right.

truth_and(true, Truth, Truth).
truth_and(false, _, false).

truth_or(true, _, true).
truth_or(false, Truth, Truth).

first_absent([Key - absent|_], Key).
first_absent([_ - Value|Pairs], Key) :-
    dif(Value, absent),
    first_absent(Pairs, Key).

absent_among_t([], false).
absent_among_t([_ - Value|Pairs], Truth) :-
    same_value_t(Value, absent, Here),
    absent_among_t(Pairs, Later),
    truth_or(Here, Later, Truth).

first_in_order([Candidate|Candidates], Keys, Key) :-
    memberd_t(Candidate, Keys, Found),
    first_pick(Found, Candidate, Candidates, Keys, Key).

first_pick(true, Candidate, _, _, Candidate).
first_pick(false, _, Candidates, Keys, Key) :-
    first_in_order(Candidates, Keys, Key).

ladder(Profile, AwarenessDate, Duty, Citations) :-
    implements(eu_reg_2024_1689_art_113_c),
    implements(eu_reg_2024_1689_art_113),
    chapter_iii_application_date(annex_iii_high_risk, EarliestDate, EarliestCite),
    date_reached_t(AwarenessDate, EarliestDate, Reached),
    ladder_from_date(Reached, EarliestCite, Profile, AwarenessDate, Duty, Citations).

ladder_from_date(false, EarliestCite, _, _, not_applicable_on_date, [cite(eu_reg_2024_1689_art_113_c), EarliestCite]) :-
    implements(eu_reg_2024_1689_art_113_c_i).
ladder_from_date(true, _, Profile, AwarenessDate, Duty, Citations) :-
    key_value(Profile, high_risk_classification, Classification),
    classification_step(Classification, Profile, AwarenessDate, Duty, Citations).

classification_step(absent, _, _, indeterminate([high_risk_classification]), []).
classification_step(not_high_risk, _, _, not_a_high_risk_ai_system, [cite(eu_reg_2024_1689_art_73_1)]) :-
    implements(eu_reg_2024_1689_art_73_1).
classification_step(annex_i_high_risk, Profile, AwarenessDate, Duty, Citations) :-
    implements(eu_reg_2024_1689_art_113_c_ii),
    chapter_iii_application_date(annex_i_high_risk, ApplicationDate, ApplicationCite),
    date_reached_t(AwarenessDate, ApplicationDate, Reached),
    annex_i_step(Reached, ApplicationCite, Profile, AwarenessDate, Duty, Citations).
classification_step(annex_iii_high_risk, Profile, AwarenessDate, Duty, Citations) :-
    implements(eu_reg_2024_1689_art_113_c_i),
    coverage_step(annex_iii_high_risk, Profile, AwarenessDate, Duty, Citations).

annex_i_step(false, ApplicationCite, _, _, not_applicable_on_date, [cite(eu_reg_2024_1689_art_113_c), ApplicationCite]) :-
    implements(eu_reg_2024_1689_art_113_c_ii).
annex_i_step(true, _, Profile, AwarenessDate, Duty, Citations) :-
    coverage_step(annex_i_high_risk, Profile, AwarenessDate, Duty, Citations).

coverage_step(Classification, Profile, AwarenessDate, Duty, Citations) :-
    implements(eu_reg_2024_1689_art_111_2),
    key_value(Profile, placed_before_chapter_iii_application_date, Placed),
    key_value(Profile, significant_change_in_design_since_that_date, Changed),
    key_value(Profile, intended_to_be_used_by_public_authorities, Intended),
    public_authorities_compliance_date(ComplianceDate, _),
    date_reached_t(AwarenessDate, ComplianceDate, ComplianceReached),
    coverage(Placed, Changed, ComplianceReached, Intended, Coverage),
    coverage_route(Coverage, Classification, Profile, AwarenessDate, Duty, Citations).

coverage(Placed, Changed, ComplianceReached, Intended, Coverage) :-
    implements(eu_reg_2024_1689_art_111_2),
    covered_t(Placed, Changed, ComplianceReached, Intended, Covered),
    not_covered_t(Placed, Changed, ComplianceReached, Intended, NotCovered),
    coverage_from(Covered, NotCovered, Placed, Changed, ComplianceReached, Intended, Coverage).

covered_t(Placed, Changed, ComplianceReached, Intended, Truth) :-
    implements(eu_reg_2024_1689_art_111_2),
    same_value_t(Placed, false, PlacedLater),
    same_value_t(Changed, true, ChangedSignificantly),
    same_value_t(ComplianceReached, true, AfterCompliance),
    same_value_t(Intended, true, ForPublicAuthorities),
    truth_and(AfterCompliance, ForPublicAuthorities, PublicAuthorityRoute),
    truth_or(PlacedLater, ChangedSignificantly, EarlyRoutes),
    truth_or(EarlyRoutes, PublicAuthorityRoute, Truth).

not_covered_t(Placed, Changed, ComplianceReached, Intended, Truth) :-
    implements(eu_reg_2024_1689_art_111_2),
    same_value_t(Placed, true, PlacedEarly),
    same_value_t(Changed, false, Unchanged),
    same_value_t(ComplianceReached, false, BeforeCompliance),
    same_value_t(Intended, false, NotForPublicAuthorities),
    truth_or(BeforeCompliance, NotForPublicAuthorities, NoPublicAuthorityRoute),
    truth_and(PlacedEarly, Unchanged, EarlyUnchanged),
    truth_and(EarlyUnchanged, NoPublicAuthorityRoute, Truth).

coverage_from(true, false, _, _, _, _, covered).
coverage_from(false, true, _, _, _, _, not_covered).
coverage_from(false, false, Placed, Changed, ComplianceReached, Intended, missing(Key)) :-
    coverage_candidates(ComplianceReached, Placed, Changed, Intended, Candidates),
    first_absent(Candidates, Key).

coverage_candidates(true, Placed, Changed, Intended, [placed_before_chapter_iii_application_date - Placed, significant_change_in_design_since_that_date - Changed, intended_to_be_used_by_public_authorities - Intended]).
coverage_candidates(false, Placed, Changed, _, [placed_before_chapter_iii_application_date - Placed, significant_change_in_design_since_that_date - Changed]).

coverage_route(missing(Key), _, _, _, indeterminate([Key]), []).
coverage_route(not_covered, _, _, _, not_covered_placed_before_application_date, [cite(eu_reg_2024_1689_art_111_2)]) :-
    implements(eu_reg_2024_1689_art_111_2).
coverage_route(covered, Classification, Profile, AwarenessDate, Duty, Citations) :-
    key_value(Profile, medical_device_or_safety_component_of_one, Device),
    device_route(Device, Classification, Profile, AwarenessDate, Duty, Citations).

device_route(absent, _, _, _, indeterminate([medical_device_or_safety_component_of_one]), []).
device_route(true, _, Profile, AwarenessDate, Duty, Citations) :-
    implements(eu_reg_2024_1689_art_73_10),
    limited_regime_step(true, Profile, AwarenessDate, Duty, Citations).
device_route(false, Classification, Profile, AwarenessDate, Duty, Citations) :-
    equivalent_regime(Classification, Profile, Regime),
    regime_route(Regime, Profile, AwarenessDate, Duty, Citations).

equivalent_regime(annex_i_high_risk, _, ordinary) :-
    implements(eu_reg_2024_1689_art_73_9).
equivalent_regime(annex_iii_high_risk, Profile, Regime) :-
    implements(eu_reg_2024_1689_art_73_9),
    key_value(Profile, provider_subject_to_equivalent_union_reporting_obligations, Equivalent),
    key_value(Profile, fundamental_rights_obligations_infringed, FundamentalRights),
    other_harm_serious_t(Profile, OtherSerious),
    annex_iii_regime(Equivalent, FundamentalRights, OtherSerious, Regime).

annex_iii_regime(true, _, _, limited).
annex_iii_regime(false, _, _, ordinary).
annex_iii_regime(absent, false, _, missing(provider_subject_to_equivalent_union_reporting_obligations)).
annex_iii_regime(absent, absent, true, missing(provider_subject_to_equivalent_union_reporting_obligations)).
annex_iii_regime(absent, absent, false, ordinary).
annex_iii_regime(absent, true, _, ordinary).

regime_route(missing(Key), _, _, indeterminate([Key]), []).
regime_route(limited, Profile, AwarenessDate, Duty, Citations) :-
    limited_regime_step(false, Profile, AwarenessDate, Duty, Citations).
regime_route(ordinary, Profile, AwarenessDate, Duty, Citations) :-
    ordinary_step(Profile, AwarenessDate, Duty, Citations).

limited_regime_step(Device, Profile, AwarenessDate, Duty, Citations) :-
    implements(eu_reg_2024_1689_art_3_49_c),
    key_value(Profile, fundamental_rights_obligations_infringed, FundamentalRights),
    limited_route(FundamentalRights, Device, Profile, AwarenessDate, Duty, Citations).

limited_route(absent, _, _, _, indeterminate([fundamental_rights_obligations_infringed]), []).
limited_route(false, true, _, _, not_a_reportable_incident, [cite(eu_reg_2024_1689_art_73_10), cite(eu_reg_2024_1689_art_3_49_c)]) :-
    implements(eu_reg_2024_1689_art_73_10).
limited_route(false, false, _, _, not_a_reportable_incident, [cite(eu_reg_2024_1689_art_73_9), cite(eu_reg_2024_1689_art_3_49_c)]) :-
    implements(eu_reg_2024_1689_art_73_9).
limited_route(true, Device, Profile, AwarenessDate, Duty, Citations) :-
    implements(eu_reg_2024_1689_art_3_49_c),
    limit_step(Device, Profile, AwarenessDate, Duty, Citations).

health_harm_serious_t(death_of_a_person, true) :-
    implements(eu_reg_2024_1689_art_3_49_a).
health_harm_serious_t(serious_harm_to_health_without_death, true) :-
    implements(eu_reg_2024_1689_art_3_49_a).
health_harm_serious_t(no_death_or_serious_harm_to_health, false) :-
    implements(eu_reg_2024_1689_art_3_49_a).
health_harm_serious_t(absent, false).

other_harm_serious_t(Profile, Truth) :-
    implements(eu_reg_2024_1689_art_3_49),
    implements(eu_reg_2024_1689_art_3_49_b),
    implements(eu_reg_2024_1689_art_3_49_d),
    key_value(Profile, harm_to_health, Health),
    key_value(Profile, critical_infrastructure_disruption, Infrastructure),
    key_value(Profile, serious_harm_to_property_or_environment, Property),
    health_harm_serious_t(Health, HealthSerious),
    same_value_t(Infrastructure, true, InfrastructureSerious),
    same_value_t(Property, true, PropertySerious),
    truth_or(HealthSerious, InfrastructureSerious, HealthOrInfrastructure),
    truth_or(HealthOrInfrastructure, PropertySerious, Truth).

serious_incident_t(Profile, Truth) :-
    implements(eu_reg_2024_1689_art_3_49),
    other_harm_serious_t(Profile, OtherSerious),
    key_value(Profile, fundamental_rights_obligations_infringed, FundamentalRights),
    same_value_t(FundamentalRights, true, FundamentalRightsSerious),
    truth_or(OtherSerious, FundamentalRightsSerious, Truth).

ordinary_step(Profile, AwarenessDate, Duty, Citations) :-
    implements(eu_reg_2024_1689_art_3_49),
    serious_incident_t(Profile, Serious),
    ordinary_route(Serious, Profile, AwarenessDate, Duty, Citations).

ordinary_route(true, Profile, AwarenessDate, Duty, Citations) :-
    limit_step(false, Profile, AwarenessDate, Duty, Citations).
ordinary_route(false, Profile, _, Duty, Citations) :-
    implements(eu_reg_2024_1689_art_3_49),
    harm_key_order_for(Profile, Keys),
    key_pairs(Profile, Keys, Pairs),
    absent_among_t(Pairs, AnyAbsent),
    not_serious_route(AnyAbsent, Pairs, Duty, Citations).

not_serious_route(true, Pairs, indeterminate([Key]), []) :-
    first_absent(Pairs, Key).
not_serious_route(false, _, not_a_serious_incident, [cite(eu_reg_2024_1689_art_3_49)]) :-
    implements(eu_reg_2024_1689_art_3_49).

harm_key_order_for(Profile, Keys) :-
    key_value(Profile, widespread_infringement, Widespread),
    key_value(Profile, high_risk_classification, Classification),
    key_value(Profile, provider_subject_to_equivalent_union_reporting_obligations, Equivalent),
    same_value_t(Widespread, true, WidespreadTrue),
    same_value_t(Classification, annex_iii_high_risk, AnnexThree),
    same_value_t(Equivalent, absent, EquivalentAbsent),
    truth_and(AnnexThree, EquivalentAbsent, FundamentalRightsFirst),
    harm_key_order(WidespreadTrue, FundamentalRightsFirst, Keys).

harm_key_order(true, true, [fundamental_rights_obligations_infringed, harm_to_health, critical_infrastructure_disruption, fundamental_rights_obligations_infringed, serious_harm_to_property_or_environment]).
harm_key_order(true, false, [harm_to_health, critical_infrastructure_disruption, fundamental_rights_obligations_infringed, serious_harm_to_property_or_environment]).
harm_key_order(false, _, [critical_infrastructure_disruption, harm_to_health, fundamental_rights_obligations_infringed, serious_harm_to_property_or_environment]).

limit_step(Device, Profile, AwarenessDate, Duty, Citations) :-
    implements(eu_reg_2024_1689_art_73_3),
    key_value(Profile, critical_infrastructure_disruption, Infrastructure),
    key_value(Profile, widespread_infringement, Widespread),
    same_value_t(Infrastructure, true, InfrastructureTrue),
    same_value_t(Widespread, true, WidespreadTrue),
    truth_or(InfrastructureTrue, WidespreadTrue, TwoDays),
    limit_route(TwoDays, Device, Profile, AwarenessDate, Duty, Citations).

limit_route(true, Device, Profile, AwarenessDate, Duty, Citations) :-
    implements(eu_reg_2024_1689_art_73_3),
    reporting_period(critical_infrastructure_or_widespread_infringement, Days, LimitCite),
    report_step(Device, Profile, AwarenessDate, Days, LimitCite, Duty, Citations).
limit_route(false, Device, Profile, AwarenessDate, Duty, Citations) :-
    key_pairs(Profile, [critical_infrastructure_disruption, widespread_infringement, harm_to_health], Pairs),
    absent_among_t(Pairs, AnyAbsent),
    longer_limit_route(AnyAbsent, Pairs, Device, Profile, AwarenessDate, Duty, Citations).

longer_limit_route(true, Pairs, _, _, _, indeterminate([Key]), []) :-
    first_absent(Pairs, Key).
longer_limit_route(false, _, Device, Profile, AwarenessDate, Duty, Citations) :-
    key_value(Profile, harm_to_health, Health),
    health_period(Health, Period),
    reporting_period(Period, Days, LimitCite),
    report_step(Device, Profile, AwarenessDate, Days, LimitCite, Duty, Citations).

health_period(death_of_a_person, death_of_a_person) :-
    implements(eu_reg_2024_1689_art_73_4).
health_period(serious_harm_to_health_without_death, other_serious_incident) :-
    implements(eu_reg_2024_1689_art_73_2).
health_period(no_death_or_serious_harm_to_health, other_serious_incident) :-
    implements(eu_reg_2024_1689_art_73_2).

report_step(Device, Profile, AwarenessDate, Days, LimitCite, report_due(Recipient, Days, LastDay, FollowUp), Citations) :-
    implements(eu_reg_2024_1689_art_73_1),
    key_value(Profile, system_under_the_exclusive_competence_of_the_ai_office, OutsideFact),
    ai_office_t(OutsideFact, AiOffice),
    recipient(AiOffice, Device, Recipient, FirstCite),
    last_day(AwarenessDate, Days, LastDay),
    follow_up_duties(FollowUp, FollowUpCite),
    device_citations(Device, DeviceCitations),
    append([FirstCite, LimitCite, FollowUpCite], DeviceCitations, Citations).

ai_office_t(attested(true, _), true) :-
    implements(eu_reg_2024_1689_art_75_1).
ai_office_t(attested(false, _), false) :-
    implements(eu_reg_2024_1689_art_75_1).
ai_office_t(absent, false).

recipient(true, _, ai_office, cite(eu_reg_2024_1689_art_75_1a)) :-
    implements(eu_reg_2024_1689_art_75_1a).
recipient(false, true, national_competent_authority_chosen_by_member_state_where_incident_occurred, cite(eu_reg_2024_1689_art_73_1)) :-
    implements(eu_reg_2024_1689_art_73_10).
recipient(false, false, market_surveillance_authority_of_member_state_where_incident_occurred, cite(eu_reg_2024_1689_art_73_1)) :-
    implements(eu_reg_2024_1689_art_73_1).

device_citations(true, [cite(eu_reg_2024_1689_art_73_10)]).
device_citations(false, []).

duty_kind(report_due(_, _, _, _), report_due).
duty_kind(indeterminate(_), pass_through).
duty_kind(Duty, pass_through) :-
    no_duty_answer(Duty).

timeliness_from_duty(Duty, DutyCitations, Profile, ReportDate, Verdict, Citations) :-
    duty_kind(Duty, Kind),
    timeliness_route(Kind, Duty, DutyCitations, Profile, ReportDate, Verdict, Citations).

timeliness_route(pass_through, Duty, DutyCitations, _, _, Duty, DutyCitations).
timeliness_route(report_due, report_due(_, _, LastDay, _), DutyCitations, Profile, ReportDate, Verdict, Citations) :-
    implements(eu_reg_2024_1689_art_73_2),
    date_later_t(ReportDate, LastDay, Late),
    lateness_route(Late, DutyCitations, Profile, Verdict, Citations).

lateness_route(true, DutyCitations, _, report_after_time_limit, DutyCitations) :-
    implements(eu_reg_2024_1689_art_73_2).
lateness_route(false, DutyCitations, Profile, Verdict, Citations) :-
    implements(eu_reg_2024_1689_art_73_5),
    key_value(Profile, report_made_immediately, Immediately),
    immediacy_route(Immediately, DutyCitations, Verdict, Citations).

immediacy_route(absent, _, indeterminate([report_made_immediately]), []).
immediacy_route(false, DutyCitations, report_not_immediate, DutyCitations) :-
    implements(eu_reg_2024_1689_art_73_2).
immediacy_route(true, DutyCitations, report_in_time, DutyCitations) :-
    implements(eu_reg_2024_1689_art_73_2).

query_ladder(duty(AwarenessDate), Profile, Answer, Citations) :-
    ladder(Profile, AwarenessDate, Answer, Citations).
query_ladder(timeliness(AwarenessDate, ReportDate), Profile, Answer, Citations) :-
    ladder(Profile, AwarenessDate, Duty, DutyCitations),
    timeliness_from_duty(Duty, DutyCitations, Profile, ReportDate, Answer, Citations).

unsure_rule(Query, Profile, Answer, Citations) :-
    query_judgement_keys(Query, Readable),
    findall(Key, (member(Key, Readable), key_value(Profile, Key, unsure)), Unsure),
    findall(Assignment, assignment(Unsure, Assignment), Assignments),
    maplist(run_for(Query, Profile), Assignments, Runs),
    findall(RunAnswer - RunCitations, member(run(_, RunAnswer, RunCitations), Runs), Results),
    sort(Results, Distinct),
    unsure_decision(Distinct, Runs, Unsure, Readable, Profile, Answer, Citations).

assignment([], []).
assignment([Key|Keys], [Key - Value|Rest]) :-
    member(Value, [true, false]),
    assignment(Keys, Rest).

run_for(Query, Profile, Assignment, run(Assignment, Answer, SortedCitations)) :-
    maplist(substitute_attribute(Assignment), Profile, RunProfile),
    query_ladder(Query, RunProfile, Answer, Citations),
    sort(Citations, SortedCitations).

substitute_attribute(Assignment, attribute(Key, Value), attribute(Key, RunValue)) :-
    assigned_value(Assignment, Key, Value, RunValue).

assigned_value([], _, Value, Value).
assigned_value([Assigned - RunValue|_], Key, _, RunValue) :-
    Assigned == Key.
assigned_value([Assigned - _|Rest], Key, Value, RunValue) :-
    Assigned \== Key,
    assigned_value(Rest, Key, Value, RunValue).

unsure_decision([Answer - Citations], _, _, _, _, Answer, Citations).
unsure_decision([_, _|_], Runs, Unsure, Readable, Profile, Answer, Citations) :-
    named_keys(Runs, NamedWithRepeats),
    sort(NamedWithRepeats, NamedSorted),
    adjust_named(Unsure, Profile, NamedSorted, Named),
    missing_or_referral(Named, Runs, Readable, Profile, Answer, Citations).

named_keys([], []).
named_keys([run(_, Answer, _)|Runs], Keys) :-
    duty_kind_or_verdict(Answer, Kind),
    named_from(Kind, Answer, Runs, Keys).

duty_kind_or_verdict(indeterminate(_), indeterminate).
duty_kind_or_verdict(report_due(_, _, _, _), final).
duty_kind_or_verdict(Answer, final) :-
    no_duty_answer(Answer).
duty_kind_or_verdict(report_in_time, final).
duty_kind_or_verdict(report_after_time_limit, final).
duty_kind_or_verdict(report_not_immediate, final).

named_from(indeterminate, indeterminate([Key]), Runs, [Key|Keys]) :-
    named_keys(Runs, Keys).
named_from(final, _, Runs, Keys) :-
    named_keys(Runs, Keys).

adjust_named(Unsure, Profile, NamedSorted, Named) :-
    memberd_t(widespread_infringement, Unsure, WidespreadUnsure),
    memberd_t(critical_infrastructure_disruption, NamedSorted, InfrastructureNamed),
    memberd_t(harm_to_health, NamedSorted, HealthNamed),
    truth_and(WidespreadUnsure, InfrastructureNamed, FirstPart),
    truth_and(FirstPart, HealthNamed, DropHealth),
    drop_health(DropHealth, NamedSorted, NamedAfterFirst),
    memberd_t(provider_subject_to_equivalent_union_reporting_obligations, Unsure, EquivalentUnsure),
    key_value(Profile, widespread_infringement, Widespread),
    same_value_t(Widespread, true, WidespreadTrue),
    memberd_t(fundamental_rights_obligations_infringed, NamedAfterFirst, FundamentalNamed),
    all_in_t(NamedAfterFirst, [fundamental_rights_obligations_infringed, harm_to_health, critical_infrastructure_disruption, serious_harm_to_property_or_environment], OnlyHarms),
    truth_and(EquivalentUnsure, WidespreadTrue, SecondPart),
    truth_and(SecondPart, FundamentalNamed, ThirdPart),
    truth_and(ThirdPart, OnlyHarms, PickFundamental),
    pick_fundamental(PickFundamental, NamedAfterFirst, Named).

drop_health(true, NamedSorted, Named) :-
    subtract(NamedSorted, [harm_to_health], Named).
drop_health(false, Named, Named).

pick_fundamental(true, _, [fundamental_rights_obligations_infringed]).
pick_fundamental(false, Named, Named).

all_in_t([], _, true).
all_in_t([Element|Elements], Allowed, Truth) :-
    memberd_t(Element, Allowed, Here),
    all_in_t(Elements, Allowed, Later),
    truth_and(Here, Later, Truth).

missing_or_referral([Key|Keys], _, _, _, indeterminate([First]), []) :-
    root_key_order(Order),
    first_in_order(Order, [Key|Keys], First).
missing_or_referral([], Runs, Readable, Profile, needs_legal_review(open_textured(Judgement, ReferralCite), [inputs_relied_on(Pairs)]), []) :-
    findall(Turning, turning_key(Runs, Turning), TurningKeys),
    root_key_order(Order),
    first_in_order(Order, TurningKeys, Judgement),
    referral_row(Judgement, ReferralCite),
    findall(Key - Value, (member(Key, Readable), profile_has(Profile, Key), profile_get(Profile, Key, Value)), Pairs).

turning_key(Runs, Key) :-
    member(run(FirstAssignment, FirstAnswer, FirstCitations), Runs),
    member(Key - true, FirstAssignment),
    maplist(flip_entry(Key), FirstAssignment, SecondAssignment),
    member(run(SecondAssignment, SecondAnswer, SecondCitations), Runs),
    dif(FirstAnswer - FirstCitations, SecondAnswer - SecondCitations).

flip_entry(Key, Entry - Value, Entry - Value) :-
    Entry \== Key.
flip_entry(Key, Entry - true, Entry - false) :-
    Entry == Key.

decide_serious_incident_reporting(duty(Profile, AwarenessDate), serious_incident_reporting_verdict(Duty, Citations)) :-
    serious_incident_report_duty(Profile, AwarenessDate, Duty, Citations).
decide_serious_incident_reporting(timeliness(Profile, AwarenessDate, ReportDate), serious_incident_reporting_verdict(Verdict, Citations)) :-
    serious_incident_report_timeliness(Profile, AwarenessDate, ReportDate, Verdict, Citations).

serious_incident_reporting_status(Case, Status) :-
    decide_serious_incident_reporting(Case, serious_incident_reporting_verdict(Status, _Citations)).

serious_incident_reporting_checklist(duty(Profile, AwarenessDate), [item(report_duty, Duty, Citations)]) :-
    serious_incident_report_duty(Profile, AwarenessDate, Duty, Citations).
serious_incident_reporting_checklist(timeliness(Profile, AwarenessDate, ReportDate), [item(report_duty, Duty, DutyCitations), item(report_timeliness, Verdict, Citations)]) :-
    serious_incident_report_duty(Profile, AwarenessDate, Duty, DutyCitations),
    serious_incident_report_timeliness(Profile, AwarenessDate, ReportDate, Verdict, Citations).

serious_incident_reporting_decision_resolvable(Case) :-
    decide_serious_incident_reporting(Case, _Verdict).

base_profile([attribute(high_risk_classification, annex_iii_high_risk), attribute(placed_before_chapter_iii_application_date, false), attribute(medical_device_or_safety_component_of_one, false), attribute(provider_subject_to_equivalent_union_reporting_obligations, false), attribute(harm_to_health, death_of_a_person), attribute(critical_infrastructure_disruption, false), attribute(fundamental_rights_obligations_infringed, false), attribute(serious_harm_to_property_or_environment, false), attribute(widespread_infringement, false)]).

test(before_the_earliest_date_is_not_applicable) :-
    serious_incident_report_duty([], date(2027, 1, 1), not_applicable_on_date, Citations),
    member(cite(eu_reg_2024_1689_art_113_c_i), Citations).
test(a_death_gives_ten_days_once) :-
    base_profile(Profile),
    findall(Duty - Citations, serious_incident_report_duty(Profile, date(2028, 1, 10), Duty, Citations), [OnlyDuty - OnlyCitations]),
    OnlyDuty = report_due(market_surveillance_authority_of_member_state_where_incident_occurred, 10, date(2028, 1, 20), [perform_necessary_investigations_without_delay, risk_assessment_of_the_incident, corrective_action, cooperate_with_competent_authorities, inform_authorities_before_altering_the_system]),
    member(cite(eu_reg_2024_1689_art_73_4), OnlyCitations).
test(critical_infrastructure_gives_two_days) :-
    serious_incident_report_duty([attribute(high_risk_classification, annex_iii_high_risk), attribute(placed_before_chapter_iii_application_date, false), attribute(medical_device_or_safety_component_of_one, false), attribute(provider_subject_to_equivalent_union_reporting_obligations, false), attribute(critical_infrastructure_disruption, true)], date(2028, 1, 10), report_due(_, 2, date(2028, 1, 12), _), _).
test(an_absent_classification_is_named) :-
    serious_incident_report_duty([], date(2028, 1, 10), indeterminate([high_risk_classification]), []).
test(a_device_without_point_c_is_not_reportable) :-
    serious_incident_report_duty([attribute(high_risk_classification, annex_i_high_risk), attribute(placed_before_chapter_iii_application_date, false), attribute(medical_device_or_safety_component_of_one, true), attribute(fundamental_rights_obligations_infringed, false)], date(2029, 1, 1), not_a_reportable_incident, Citations),
    member(cite(eu_reg_2024_1689_art_73_10), Citations).
test(the_ai_office_receives_the_report) :-
    serious_incident_report_duty([attribute(high_risk_classification, annex_iii_high_risk), attribute(placed_before_chapter_iii_application_date, false), attribute(medical_device_or_safety_component_of_one, false), attribute(provider_subject_to_equivalent_union_reporting_obligations, false), attribute(critical_infrastructure_disruption, true), attribute(system_under_the_exclusive_competence_of_the_ai_office, attested(true, attestation(host, stamp, reason, none)))], date(2028, 1, 10), report_due(ai_office, 2, _, _), Citations),
    member(cite(eu_reg_2024_1689_art_75_1a), Citations).
test(an_unsure_widespread_infringement_is_referred) :-
    serious_incident_report_duty([attribute(high_risk_classification, annex_iii_high_risk), attribute(placed_before_chapter_iii_application_date, false), attribute(medical_device_or_safety_component_of_one, false), attribute(provider_subject_to_equivalent_union_reporting_obligations, false), attribute(harm_to_health, serious_harm_to_health_without_death), attribute(critical_infrastructure_disruption, false), attribute(widespread_infringement, unsure)], date(2028, 1, 10), needs_legal_review(open_textured(widespread_infringement, cite(eu_reg_2024_1689_art_3_61)), [inputs_relied_on([provider_subject_to_equivalent_union_reporting_obligations - false, widespread_infringement - unsure])]), []).
test(a_missing_fact_comes_before_a_referral) :-
    serious_incident_report_duty([attribute(high_risk_classification, annex_iii_high_risk), attribute(placed_before_chapter_iii_application_date, true), attribute(significant_change_in_design_since_that_date, unsure)], date(2028, 1, 10), indeterminate([medical_device_or_safety_component_of_one]), []).
test(a_late_report_is_late) :-
    base_profile(Profile),
    serious_incident_report_timeliness(Profile, date(2028, 1, 10), date(2028, 1, 21), report_after_time_limit, _).
test(a_report_on_the_last_day_made_immediately_is_in_time) :-
    base_profile(Profile),
    append(Profile, [attribute(report_made_immediately, true)], TimedProfile),
    serious_incident_report_timeliness(TimedProfile, date(2028, 1, 10), date(2028, 1, 20), report_in_time, _).
test(a_day_that_does_not_exist_is_wrong_type) :-
    serious_incident_report_duty([], date(2027, 2, 30), input_problems([wrong_type(awareness_date)]), []).
test(a_leap_day_is_a_real_day) :-
    serious_incident_report_duty([], date(2028, 2, 29), indeterminate([high_risk_classification]), []).
test(a_profile_that_is_not_a_list_is_wrong_type) :-
    serious_incident_report_duty(foo, date(2028, 1, 1), input_problems([wrong_type(profile)]), []).

test(before_the_earliest_date_is_not_a_report, fail) :-
    serious_incident_report_duty([], date(2027, 1, 1), report_due(_, _, _, _), _).
test(a_report_on_the_last_day_is_not_late, fail) :-
    base_profile(Profile),
    serious_incident_report_timeliness(Profile, date(2028, 1, 10), date(2028, 1, 20), report_after_time_limit, _).
