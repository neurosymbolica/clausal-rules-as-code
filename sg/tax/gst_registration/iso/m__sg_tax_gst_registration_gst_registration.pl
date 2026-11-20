% SPDX-License-Identifier: EUPL-1.2
:- module(m__sg_tax_gst_registration_gst_registration, [gst_retrospective_liability/2, gst_prospective_liability/2, gst_retrospective/5, gst_prospective/5, decide_gst_registration/2, gst_registration_status/2, gst_registration_checklist/2, gst_registration_decision_resolvable/1, gst_registration_status_values/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_dicts, [get/3]).
:- use_module(library(clpz)).
:- use_module(clausal_datetime, [timedelta/3, date_add/3]).
:- use_module(deadline_lib, [month_last_day/3]).
:- use_module(formalize_lib, [missing_keys/3]).
:- use_module(m__sg_tax_gst_registration_citations, [implements/1]).

gst_registration_threshold_record(100000000, [cite(sg_gsta_1993_sch1_para_1_1_a_ii), cite(sg_gsta_1993_sch1_para_1_1_b)]).

gst_registration_notification_days_record(30, [cite(sg_gsta_1993_sch1_para_4_1a), cite(sg_gsta_1993_sch1_para_5_1)]).

gst_registration_prospective_cutover_date(date(2025, 7, 1), cite(sg_gsta_1993_s443_2025)).

gst_retrospective(already_registered, _ValueCents, n_a, n_a, [sg_gsta_1993_sch1_para_1_1]).
gst_retrospective(not_liable, _ValueCents, n_a, n_a, [sg_gsta_1993_sch1_para_1_1_a_ii]).
gst_retrospective(not_liable_comptroller_satisfied, _ValueCents, n_a, n_a, [sg_gsta_1993_sch1_para_1_1_a_ii, sg_gsta_1993_sch1_para_1_3_b]).
gst_retrospective(exempted_zero_rated, _ValueCents, n_a, n_a, [sg_gsta_1993_sch1_para_1_1_a_ii, sg_gsta_1993_sch1_para_15_1]).
gst_retrospective(liable, _ValueCents, _NotifyBy, _RegisteredFrom, [sg_gsta_1993_sch1_para_1_1_a_ii, sg_gsta_1993_sch1_para_4_1a, sg_gsta_1993_sch1_para_4_2_a]).
gst_retrospective(indeterminate, n_a, n_a, n_a, []).

gst_prospective(already_registered, _ValueCents, n_a, n_a, [sg_gsta_1993_sch1_para_1_1]).
gst_prospective(not_liable, _ValueCents, n_a, n_a, [sg_gsta_1993_sch1_para_1_1_b]).
gst_prospective(exempted_zero_rated, _ValueCents, n_a, n_a, [sg_gsta_1993_sch1_para_1_1_b, sg_gsta_1993_sch1_para_15_1]).
gst_prospective(liable, _ValueCents, _NotifyBy, _RegisteredFrom, [sg_gsta_1993_sch1_para_1_1_b, sg_gsta_1993_sch1_para_5_1, sg_gsta_1993_sch1_para_5_2_a_i]).
gst_prospective(liable, _ValueCents, _NotifyBy, _RegisteredFrom, [sg_gsta_1993_sch1_para_1_1_b, sg_gsta_1993_sch1_para_5_1, sg_gsta_1993_sch1_para_5_2_a_ii]).
gst_prospective(indeterminate, n_a, n_a, n_a, []).

retro_required_present(Profile) :-
    missing_keys(Profile, [is_registered, belongs_in_singapore, calendar_year, taxable_supplies_cents], []).

retro_required_absent(Profile) :-
    missing_keys(Profile, [is_registered, belongs_in_singapore, calendar_year, taxable_supplies_cents], Missing),
    Missing \= [].

prospective_required_present(Profile) :-
    missing_keys(Profile, [is_registered, belongs_in_singapore, forecast_start_date, forecast_taxable_supplies_cents], []).

prospective_required_absent(Profile) :-
    missing_keys(Profile, [is_registered, belongs_in_singapore, forecast_start_date, forecast_taxable_supplies_cents], Missing),
    Missing \= [].

optional_bool(Profile, ProfileKey, false) :-
    missing_keys(Profile, [ProfileKey], [ProfileKey]).
optional_bool(Profile, ProfileKey, ProfileValue) :-
    missing_keys(Profile, [ProfileKey], []),
    get(Profile, ProfileKey, ProfileValue).

optional_cents(Profile, ProfileKey, 0) :-
    missing_keys(Profile, [ProfileKey], [ProfileKey]).
optional_cents(Profile, ProfileKey, ProfileValue) :-
    missing_keys(Profile, [ProfileKey], []),
    get(Profile, ProfileKey, ProfileValue).

retro_value_cents(Profile, ValueCents) :-
    implements(sg_gsta_1993_sch1_para_1_1_a_ii),
    get(Profile, belongs_in_singapore, BelongsInSingapore),
    get(Profile, calendar_year, CalendarYear),
    retro_value_cents(Profile, BelongsInSingapore, CalendarYear, ValueCents).

retro_value_cents(Profile, true, CalendarYear, ValueCents) :-
    CalendarYear #>= 2022,
    retro_adjusted_cents(Profile, AdjustedCents),
    optional_cents(Profile, seventh_schedule_supplies_cents, SeventhCents),
    ValueCents #= AdjustedCents + SeventhCents.
retro_value_cents(Profile, true, CalendarYear, ValueCents) :-
    CalendarYear #< 2022,
    retro_adjusted_cents(Profile, ValueCents).
retro_value_cents(Profile, false, _CalendarYear, ValueCents) :-
    retro_adjusted_cents(Profile, ValueCents).

retro_adjusted_cents(Profile, AdjustedCents) :-
    retro_after_reverse_charge(Profile, AfterReverseCents),
    retro_after_capital_disregard(Profile, AfterReverseCents, AdjustedCents).

retro_after_reverse_charge(Profile, AfterReverseCents) :-
    implements(sg_gsta_1993_sch1_para_1_4),
    get(Profile, taxable_supplies_cents, TaxableCents),
    optional_cents(Profile, reverse_charge_supplies_cents, ReverseChargeCents),
    AfterReverseCents #= TaxableCents - ReverseChargeCents.

retro_after_capital_disregard(Profile, AfterReverseCents, AdjustedCents) :-
    implements(sg_gsta_1993_sch1_para_1c_2),
    optional_cents(Profile, capital_asset_supplies_cents, CapitalAssetCents),
    AdjustedCents #= AfterReverseCents - CapitalAssetCents.

prospective_value_cents(Profile, ValueCents) :-
    implements(sg_gsta_1993_sch1_para_1_1_b),
    get(Profile, belongs_in_singapore, BelongsInSingapore),
    prospective_value_cents(Profile, BelongsInSingapore, ValueCents).

prospective_value_cents(Profile, true, ValueCents) :-
    prospective_adjusted_cents(Profile, AdjustedCents),
    optional_cents(Profile, forecast_seventh_schedule_supplies_cents, SeventhCents),
    ValueCents #= AdjustedCents + SeventhCents.
prospective_value_cents(Profile, false, ValueCents) :-
    prospective_adjusted_cents(Profile, ValueCents).

prospective_adjusted_cents(Profile, AdjustedCents) :-
    prospective_after_reverse_charge(Profile, AfterReverseCents),
    prospective_after_capital_disregard(Profile, AfterReverseCents, AdjustedCents).

prospective_after_reverse_charge(Profile, AfterReverseCents) :-
    implements(sg_gsta_1993_sch1_para_1_4),
    get(Profile, forecast_taxable_supplies_cents, TaxableCents),
    optional_cents(Profile, forecast_reverse_charge_supplies_cents, ReverseChargeCents),
    AfterReverseCents #= TaxableCents - ReverseChargeCents.

prospective_after_capital_disregard(Profile, AfterReverseCents, AdjustedCents) :-
    implements(sg_gsta_1993_sch1_para_1c_2),
    optional_cents(Profile, forecast_capital_asset_supplies_cents, CapitalAssetCents),
    AdjustedCents #= AfterReverseCents - CapitalAssetCents.

retro_notify_by(CalendarYear, NotifyBy) :-
    implements(sg_gsta_1993_sch1_para_4_1a),
    implements(sg_interpretation_act_1965_s_50_a),
    AnchorDate = date(CalendarYear, 12, 31),
    timedelta(30, 0, NotifyDelta),
    date_add(AnchorDate, NotifyDelta, NotifyBy).

retro_registered_from(CalendarYear, RegisteredFrom) :-
    implements(sg_gsta_1993_sch1_para_4_2_a),
    NextYear #= CalendarYear + 1,
    RegisteredFrom = date(NextYear, 3, 1).

prospective_notify_by(ForecastStartDate, NotifyBy) :-
    implements(sg_gsta_1993_sch1_para_5_1),
    implements(sg_interpretation_act_1965_s_50_a),
    timedelta(30, 0, NotifyDelta),
    date_add(ForecastStartDate, NotifyDelta, NotifyBy).

prospective_pre_cutover(ForecastStartDate) :-
    implements(sg_gsta_1993_sch1_para_5_2_a_i),
    gst_registration_prospective_cutover_date(CutoverDate, _Cite),
    ForecastStartDate @< CutoverDate.

prospective_post_cutover(ForecastStartDate) :-
    implements(sg_gsta_1993_s443_2025),
    gst_registration_prospective_cutover_date(CutoverDate, _Cite),
    ForecastStartDate @>= CutoverDate.

prospective_registered_from_pre_cutover(ForecastStartDate, RegisteredFrom) :-
    implements(sg_gsta_1993_sch1_para_5_2_a_i),
    ThirtyOneDays #= 30 + 1,
    timedelta(ThirtyOneDays, 0, RegisteredDelta),
    date_add(ForecastStartDate, RegisteredDelta, RegisteredFrom).

prospective_registered_from_post_cutover(ForecastStartDate, RegisteredFrom) :-
    implements(sg_gsta_1993_sch1_para_5_2_a_ii),
    prospective_month_plus_two(ForecastStartDate, RegisteredFrom).

prospective_month_plus_two(date(SourceYear, SourceMonth, SourceDay), ResultDate) :-
    implements(sg_gsta_1993_sch1_para_5_2_a_ii),
    TargetMonth #= SourceMonth + 2,
    TargetMonth #> 12,
    TargetYear #= SourceYear + 1,
    AdjustedMonth #= TargetMonth - 12,
    month_last_day(TargetYear, AdjustedMonth, LastDay),
    day_clamped(SourceDay, LastDay, ClampedDay),
    ResultDate = date(TargetYear, AdjustedMonth, ClampedDay).
prospective_month_plus_two(date(SourceYear, SourceMonth, SourceDay), ResultDate) :-
    implements(sg_gsta_1993_sch1_para_5_2_a_ii),
    TargetMonth #= SourceMonth + 2,
    TargetMonth #< 13,
    TargetYear = SourceYear,
    month_last_day(TargetYear, TargetMonth, LastDay),
    day_clamped(SourceDay, LastDay, ClampedDay),
    ResultDate = date(TargetYear, TargetMonth, ClampedDay).

day_clamped(SourceDay, LastDay, SourceDay) :-
    SourceDay #=< LastDay.
day_clamped(_SourceDay, LastDay, LastDay) :-
    _SourceDay #> LastDay.

gst_retrospective_liability(Profile, gst_retrospective(indeterminate, n_a, n_a, n_a, [])) :-
    retro_required_absent(Profile).
gst_retrospective_liability(Profile, gst_retrospective(already_registered, ValueCents, n_a, n_a, [sg_gsta_1993_sch1_para_1_1])) :-
    implements(sg_gsta_1993_sch1_para_1_1),
    retro_required_present(Profile),
    get(Profile, is_registered, true),
    retro_value_cents(Profile, ValueCents).
gst_retrospective_liability(Profile, gst_retrospective(not_liable, ValueCents, n_a, n_a, [sg_gsta_1993_sch1_para_1_1_a_ii])) :-
    implements(sg_gsta_1993_sch1_para_1_1_a_ii),
    retro_required_present(Profile),
    get(Profile, is_registered, false),
    retro_value_cents(Profile, ValueCents),
    ValueCents #< 100000001.
gst_retrospective_liability(Profile, gst_retrospective(not_liable_comptroller_satisfied, ValueCents, n_a, n_a, [sg_gsta_1993_sch1_para_1_1_a_ii, sg_gsta_1993_sch1_para_1_3_b])) :-
    implements(sg_gsta_1993_sch1_para_1_3_b),
    retro_required_present(Profile),
    get(Profile, is_registered, false),
    retro_value_cents(Profile, ValueCents),
    ValueCents #> 100000000,
    optional_bool(Profile, comptroller_satisfied_next_year_not_exceeding, true).
gst_retrospective_liability(Profile, gst_retrospective(exempted_zero_rated, ValueCents, n_a, n_a, [sg_gsta_1993_sch1_para_1_1_a_ii, sg_gsta_1993_sch1_para_15_1])) :-
    implements(sg_gsta_1993_sch1_para_15_1),
    retro_required_present(Profile),
    get(Profile, is_registered, false),
    retro_value_cents(Profile, ValueCents),
    ValueCents #> 100000000,
    optional_bool(Profile, comptroller_satisfied_next_year_not_exceeding, false),
    optional_bool(Profile, zero_rated_exemption_granted, true).
gst_retrospective_liability(Profile, gst_retrospective(liable, ValueCents, NotifyBy, RegisteredFrom, [sg_gsta_1993_sch1_para_1_1_a_ii, sg_gsta_1993_sch1_para_4_1a, sg_gsta_1993_sch1_para_4_2_a])) :-
    implements(sg_gsta_1993_sch1_para_1_1_a_ii),
    retro_required_present(Profile),
    get(Profile, is_registered, false),
    retro_value_cents(Profile, ValueCents),
    ValueCents #> 100000000,
    optional_bool(Profile, comptroller_satisfied_next_year_not_exceeding, false),
    optional_bool(Profile, zero_rated_exemption_granted, false),
    get(Profile, calendar_year, CalendarYear),
    retro_notify_by(CalendarYear, NotifyBy),
    retro_registered_from(CalendarYear, RegisteredFrom).

gst_prospective_liability(Profile, gst_prospective(indeterminate, n_a, n_a, n_a, [])) :-
    prospective_required_absent(Profile).
gst_prospective_liability(Profile, gst_prospective(already_registered, ValueCents, n_a, n_a, [sg_gsta_1993_sch1_para_1_1])) :-
    implements(sg_gsta_1993_sch1_para_1_1),
    prospective_required_present(Profile),
    get(Profile, is_registered, true),
    prospective_value_cents(Profile, ValueCents).
gst_prospective_liability(Profile, gst_prospective(not_liable, ValueCents, n_a, n_a, [sg_gsta_1993_sch1_para_1_1_b])) :-
    implements(sg_gsta_1993_sch1_para_1_1_b),
    prospective_required_present(Profile),
    get(Profile, is_registered, false),
    prospective_value_cents(Profile, ValueCents),
    ValueCents #< 100000001.
gst_prospective_liability(Profile, gst_prospective(exempted_zero_rated, ValueCents, n_a, n_a, [sg_gsta_1993_sch1_para_1_1_b, sg_gsta_1993_sch1_para_15_1])) :-
    implements(sg_gsta_1993_sch1_para_15_1),
    prospective_required_present(Profile),
    get(Profile, is_registered, false),
    prospective_value_cents(Profile, ValueCents),
    ValueCents #> 100000000,
    optional_bool(Profile, zero_rated_exemption_granted, true).
gst_prospective_liability(Profile, gst_prospective(liable, ValueCents, NotifyBy, RegisteredFrom, [sg_gsta_1993_sch1_para_1_1_b, sg_gsta_1993_sch1_para_5_1, sg_gsta_1993_sch1_para_5_2_a_i])) :-
    implements(sg_gsta_1993_sch1_para_1_1_b),
    prospective_required_present(Profile),
    get(Profile, is_registered, false),
    prospective_value_cents(Profile, ValueCents),
    ValueCents #> 100000000,
    optional_bool(Profile, zero_rated_exemption_granted, false),
    get(Profile, forecast_start_date, ForecastStartDate),
    prospective_pre_cutover(ForecastStartDate),
    prospective_notify_by(ForecastStartDate, NotifyBy),
    prospective_registered_from_pre_cutover(ForecastStartDate, RegisteredFrom).
gst_prospective_liability(Profile, gst_prospective(liable, ValueCents, NotifyBy, RegisteredFrom, [sg_gsta_1993_sch1_para_1_1_b, sg_gsta_1993_sch1_para_5_1, sg_gsta_1993_sch1_para_5_2_a_ii])) :-
    implements(sg_gsta_1993_sch1_para_1_1_b),
    prospective_required_present(Profile),
    get(Profile, is_registered, false),
    prospective_value_cents(Profile, ValueCents),
    ValueCents #> 100000000,
    optional_bool(Profile, zero_rated_exemption_granted, false),
    get(Profile, forecast_start_date, ForecastStartDate),
    prospective_post_cutover(ForecastStartDate),
    prospective_notify_by(ForecastStartDate, NotifyBy),
    prospective_registered_from_post_cutover(ForecastStartDate, RegisteredFrom).

decide_gst_registration(Profile, gst_registration_verdict(eligible, Citations)) :-
    retro_required_present(Profile),
    gst_retrospective_liability(Profile, gst_retrospective(liable, _ValueCents, _NotifyBy, _RegisteredFrom, Citations)).
decide_gst_registration(Profile, gst_registration_verdict(ineligible, Citations)) :-
    retro_required_present(Profile),
    gst_retrospective_liability(Profile, gst_retrospective(Decision, _ValueCents, _NotifyBy, _RegisteredFrom, Citations)),
    Decision \= liable.
decide_gst_registration(Profile, gst_registration_verdict(eligible, Citations)) :-
    retro_required_absent(Profile),
    prospective_required_present(Profile),
    gst_prospective_liability(Profile, gst_prospective(liable, _ValueCents, _NotifyBy, _RegisteredFrom, Citations)).
decide_gst_registration(Profile, gst_registration_verdict(ineligible, Citations)) :-
    retro_required_absent(Profile),
    prospective_required_present(Profile),
    gst_prospective_liability(Profile, gst_prospective(Decision, _ValueCents, _NotifyBy, _RegisteredFrom, Citations)),
    Decision \= liable.
decide_gst_registration(Profile, gst_registration_verdict(indeterminate, [])) :-
    retro_required_absent(Profile),
    prospective_required_absent(Profile).

gst_registration_status(Profile, Status) :-
    decide_gst_registration(Profile, gst_registration_verdict(Status, _Citations)).

gst_registration_status_values([eligible, ineligible, indeterminate]).

gst_registration_decision_resolvable(Profile) :-
    decide_gst_registration(Profile, _Verdict).

gst_registration_checklist(Profile, Checklist) :-
    retro_required_present(Profile),
    retro_checklist(Profile, Checklist).
gst_registration_checklist(Profile, Checklist) :-
    retro_required_absent(Profile),
    prospective_required_present(Profile),
    prospective_checklist(Profile, Checklist).
gst_registration_checklist(Profile, [item(gst_registration_required_inputs, unknown, cite(sg_gsta_1993_sch1_para_1_1))]) :-
    retro_required_absent(Profile),
    prospective_required_absent(Profile).

retro_checklist(Profile, Checklist) :-
    gst_retrospective_liability(Profile, gst_retrospective(Decision, _ValueCents, _NotifyBy, _RegisteredFrom, _Citations)),
    retro_checklist_items(Decision, Checklist).

retro_checklist_items(already_registered, [item(gst_registration_not_registered, unmet, cite(sg_gsta_1993_sch1_para_1_1))]).
retro_checklist_items(not_liable, [item(gst_registration_value_threshold, unmet, cite(sg_gsta_1993_sch1_para_1_1_a_ii))]).
retro_checklist_items(not_liable_comptroller_satisfied, [item(gst_registration_comptroller_relief, unmet, cite(sg_gsta_1993_sch1_para_1_3_b))]).
retro_checklist_items(exempted_zero_rated, [item(gst_registration_zero_rated_exemption, unmet, cite(sg_gsta_1993_sch1_para_15_1))]).
retro_checklist_items(liable, [item(gst_registration_value_threshold, met, cite(sg_gsta_1993_sch1_para_1_1_a_ii)), item(gst_registration_notification_deadline, met, cite(sg_gsta_1993_sch1_para_4_1a)), item(gst_registration_registration_effective, met, cite(sg_gsta_1993_sch1_para_4_2_a))]).

prospective_checklist(Profile, Checklist) :-
    gst_prospective_liability(Profile, gst_prospective(Decision, _ValueCents, _NotifyBy, _RegisteredFrom, Citations)),
    prospective_checklist_items(Decision, Citations, Checklist).

prospective_checklist_items(already_registered, _Citations, [item(gst_registration_not_registered, unmet, cite(sg_gsta_1993_sch1_para_1_1))]).
prospective_checklist_items(not_liable, _Citations, [item(gst_registration_value_threshold, unmet, cite(sg_gsta_1993_sch1_para_1_1_b))]).
prospective_checklist_items(exempted_zero_rated, _Citations, [item(gst_registration_zero_rated_exemption, unmet, cite(sg_gsta_1993_sch1_para_15_1))]).
prospective_checklist_items(liable, Citations, Checklist) :-
    nth0(2, Citations, EffectiveKey),
    Checklist = [item(gst_registration_value_threshold, met, cite(sg_gsta_1993_sch1_para_1_1_b)), item(gst_registration_notification_deadline, met, cite(sg_gsta_1993_sch1_para_5_1)), item(gst_registration_registration_effective, met, cite(EffectiveKey))].
