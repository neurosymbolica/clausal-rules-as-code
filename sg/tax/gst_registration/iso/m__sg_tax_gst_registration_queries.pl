% SPDX-License-Identifier: EUPL-1.2
:- module(m__sg_tax_gst_registration_queries, [gst_registration_profile_keys/1, gst_registration_eligibility/2, gst_registration_deadline/3, gst_registration_threshold/2]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(formalize_lib, [missing_keys/3]).
:- use_module(m__sg_tax_gst_registration_gst_registration, [decide_gst_registration/2, gst_registration_checklist/2, gst_retrospective_liability/2, gst_prospective_liability/2]).

gst_registration_profile_keys([is_registered, belongs_in_singapore, zero_rated_exemption_granted, comptroller_satisfied_next_year_not_exceeding, calendar_year, taxable_supplies_cents, capital_asset_supplies_cents, reverse_charge_supplies_cents, seventh_schedule_supplies_cents, forecast_start_date, forecast_taxable_supplies_cents, forecast_capital_asset_supplies_cents, forecast_reverse_charge_supplies_cents, forecast_seventh_schedule_supplies_cents]).

gst_registration_eligibility(Profile, eligibility(eligible, Checklist)) :-
    decide_gst_registration(Profile, gst_registration_verdict(eligible, _Citations)),
    gst_registration_checklist(Profile, Checklist).
gst_registration_eligibility(Profile, eligibility(ineligible, Checklist)) :-
    decide_gst_registration(Profile, gst_registration_verdict(ineligible, _Citations)),
    gst_registration_checklist(Profile, Checklist).
gst_registration_eligibility(Profile, eligibility(indeterminate, Checklist)) :-
    decide_gst_registration(Profile, gst_registration_verdict(indeterminate, _Citations)),
    gst_registration_checklist(Profile, Checklist).

retro_inputs_present(Profile) :-
    missing_keys(Profile, [is_registered, belongs_in_singapore, calendar_year, taxable_supplies_cents], []).

retro_inputs_absent(Profile) :-
    missing_keys(Profile, [is_registered, belongs_in_singapore, calendar_year, taxable_supplies_cents], MissingKeys),
    MissingKeys \= [].

prospective_inputs_present(Profile) :-
    missing_keys(Profile, [is_registered, belongs_in_singapore, forecast_start_date, forecast_taxable_supplies_cents], []).

prospective_inputs_absent(Profile) :-
    missing_keys(Profile, [is_registered, belongs_in_singapore, forecast_start_date, forecast_taxable_supplies_cents], MissingKeys),
    MissingKeys \= [].

gst_registration_deadline(Profile, deadline(NotifyBy, RegisteredFrom), registration_required) :-
    retro_inputs_present(Profile),
    gst_retrospective_liability(Profile, gst_retrospective(liable, _ValueCents, NotifyBy, RegisteredFrom, _Citations)).
gst_registration_deadline(Profile, deadline(n_a, n_a), no_consequence) :-
    retro_inputs_present(Profile),
    gst_retrospective_liability(Profile, gst_retrospective(Decision, _ValueCents, _NotifyBy, _RegisteredFrom, _Citations)),
    Decision \= liable.
gst_registration_deadline(Profile, deadline(NotifyBy, RegisteredFrom), registration_required) :-
    retro_inputs_absent(Profile),
    prospective_inputs_present(Profile),
    gst_prospective_liability(Profile, gst_prospective(liable, _ValueCents, NotifyBy, RegisteredFrom, _Citations)).
gst_registration_deadline(Profile, deadline(n_a, n_a), no_consequence) :-
    retro_inputs_absent(Profile),
    prospective_inputs_present(Profile),
    gst_prospective_liability(Profile, gst_prospective(Decision, _ValueCents, _NotifyBy, _RegisteredFrom, _Citations)),
    Decision \= liable.
gst_registration_deadline(Profile, deadline(n_a, n_a), indeterminate) :-
    retro_inputs_absent(Profile),
    prospective_inputs_absent(Profile).

gst_registration_threshold(retrospective, threshold(100000000, [cite(sg_gsta_1993_sch1_para_1_1_a_ii)])).
gst_registration_threshold(prospective, threshold(100000000, [cite(sg_gsta_1993_sch1_para_1_1_b)])).
