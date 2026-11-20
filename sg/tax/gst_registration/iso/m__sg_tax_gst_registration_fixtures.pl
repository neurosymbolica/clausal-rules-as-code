% SPDX-License-Identifier: EUPL-1.2
:- module(m__sg_tax_gst_registration_fixtures, [gst_registration_subject/1, gst_registration_profile_for/2, gst_registration_assess/2]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_dicts, [dict_pairs/2]).
:- use_module(m__sg_tax_gst_registration_gst_registration, [decide_gst_registration/2]).

gst_registration_subject(retrospective_liable_just_above_threshold).
gst_registration_subject(retrospective_not_liable_at_threshold).
gst_registration_subject(retrospective_already_registered_just_above_threshold).
gst_registration_subject(retrospective_comptroller_satisfied_just_above_threshold).
gst_registration_subject(retrospective_zero_rated_exemption_just_above_threshold).
gst_registration_subject(retrospective_indeterminate_missing_taxable_supplies).
gst_registration_subject(retrospective_seventh_schedule_year_2022_liable).
gst_registration_subject(retrospective_seventh_schedule_year_2021_not_liable).
gst_registration_subject(prospective_liable_pre_cutover_just_above_threshold).
gst_registration_subject(prospective_not_liable_at_threshold_pre_cutover).
gst_registration_subject(prospective_liable_post_cutover_at_boundary).
gst_registration_subject(prospective_liable_pre_cutover_just_below_boundary).
gst_registration_subject(prospective_already_registered_just_above_threshold).
gst_registration_subject(prospective_zero_rated_exemption_just_above_threshold).
gst_registration_subject(prospective_indeterminate_missing_forecast_start_date).
gst_registration_subject(prospective_seventh_schedule_belongs_true_liable).
gst_registration_subject(prospective_seventh_schedule_belongs_false_not_liable).

gst_registration_profile_for(retrospective_liable_just_above_threshold, Profile) :-
    dict_pairs(Profile, [is_registered - false, belongs_in_singapore - true, calendar_year - 2022, taxable_supplies_cents - 100000001]).
gst_registration_profile_for(retrospective_not_liable_at_threshold, Profile) :-
    dict_pairs(Profile, [is_registered - false, belongs_in_singapore - true, calendar_year - 2022, taxable_supplies_cents - 100000000]).
gst_registration_profile_for(retrospective_already_registered_just_above_threshold, Profile) :-
    dict_pairs(Profile, [is_registered - true, belongs_in_singapore - true, calendar_year - 2022, taxable_supplies_cents - 100000001]).
gst_registration_profile_for(retrospective_comptroller_satisfied_just_above_threshold, Profile) :-
    dict_pairs(Profile, [is_registered - false, belongs_in_singapore - true, calendar_year - 2022, taxable_supplies_cents - 100000001, comptroller_satisfied_next_year_not_exceeding - true]).
gst_registration_profile_for(retrospective_zero_rated_exemption_just_above_threshold, Profile) :-
    dict_pairs(Profile, [is_registered - false, belongs_in_singapore - true, calendar_year - 2022, taxable_supplies_cents - 100000001, zero_rated_exemption_granted - true]).
gst_registration_profile_for(retrospective_indeterminate_missing_taxable_supplies, Profile) :-
    dict_pairs(Profile, [is_registered - false, belongs_in_singapore - true, calendar_year - 2022]).
gst_registration_profile_for(retrospective_seventh_schedule_year_2022_liable, Profile) :-
    dict_pairs(Profile, [is_registered - false, belongs_in_singapore - true, calendar_year - 2022, taxable_supplies_cents - 100000000, seventh_schedule_supplies_cents - 1]).
gst_registration_profile_for(retrospective_seventh_schedule_year_2021_not_liable, Profile) :-
    dict_pairs(Profile, [is_registered - false, belongs_in_singapore - true, calendar_year - 2021, taxable_supplies_cents - 100000000, seventh_schedule_supplies_cents - 1]).
gst_registration_profile_for(prospective_liable_pre_cutover_just_above_threshold, Profile) :-
    dict_pairs(Profile, [is_registered - false, belongs_in_singapore - true, forecast_start_date - date(2022, 1, 15), forecast_taxable_supplies_cents - 100000001]).
gst_registration_profile_for(prospective_not_liable_at_threshold_pre_cutover, Profile) :-
    dict_pairs(Profile, [is_registered - false, belongs_in_singapore - true, forecast_start_date - date(2022, 1, 15), forecast_taxable_supplies_cents - 100000000]).
gst_registration_profile_for(prospective_liable_post_cutover_at_boundary, Profile) :-
    dict_pairs(Profile, [is_registered - false, belongs_in_singapore - true, forecast_start_date - date(2025, 7, 1), forecast_taxable_supplies_cents - 100000001]).
gst_registration_profile_for(prospective_liable_pre_cutover_just_below_boundary, Profile) :-
    dict_pairs(Profile, [is_registered - false, belongs_in_singapore - true, forecast_start_date - date(2025, 6, 30), forecast_taxable_supplies_cents - 100000001]).
gst_registration_profile_for(prospective_already_registered_just_above_threshold, Profile) :-
    dict_pairs(Profile, [is_registered - true, belongs_in_singapore - true, forecast_start_date - date(2022, 1, 15), forecast_taxable_supplies_cents - 100000001]).
gst_registration_profile_for(prospective_zero_rated_exemption_just_above_threshold, Profile) :-
    dict_pairs(Profile, [is_registered - false, belongs_in_singapore - true, forecast_start_date - date(2022, 1, 15), forecast_taxable_supplies_cents - 100000001, zero_rated_exemption_granted - true]).
gst_registration_profile_for(prospective_indeterminate_missing_forecast_start_date, Profile) :-
    dict_pairs(Profile, [is_registered - false, belongs_in_singapore - true, forecast_taxable_supplies_cents - 100000001]).
gst_registration_profile_for(prospective_seventh_schedule_belongs_true_liable, Profile) :-
    dict_pairs(Profile, [is_registered - false, belongs_in_singapore - true, forecast_start_date - date(2022, 1, 15), forecast_taxable_supplies_cents - 100000000, forecast_seventh_schedule_supplies_cents - 1]).
gst_registration_profile_for(prospective_seventh_schedule_belongs_false_not_liable, Profile) :-
    dict_pairs(Profile, [is_registered - false, belongs_in_singapore - false, forecast_start_date - date(2022, 1, 15), forecast_taxable_supplies_cents - 100000000, forecast_seventh_schedule_supplies_cents - 1]).

gst_registration_assess(Subject, Result) :-
    gst_registration_profile_for(Subject, Profile),
    decide_gst_registration(Profile, Result).
