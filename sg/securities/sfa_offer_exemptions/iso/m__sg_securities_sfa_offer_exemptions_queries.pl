% SPDX-License-Identifier: EUPL-1.2
:- module(m__sg_securities_sfa_offer_exemptions_queries, [sfa_offer_exemptions_profile_keys/1, sfa_offer_exemptions_what_if/4, sfa_offer_exemptions_threshold/5]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(query_combinators, [override_key/4, flip_scan/4]).
:- use_module(m__sg_securities_sfa_offer_exemptions_sfa_offer_exemptions, [decide_sfa_offer_exemptions/2, sfa_offer_exemptions_status/2]).

sfa_offer_exemptions_profile_keys([offer_date, institutional_offerees, relevant_person_offerees, other_offerees, amount_raised_cents, advertisement, non_permitted_selling_expenses, prospectus_state, personal_offer, statement_and_resale_notification_given, acquires_as_principal, minimum_consideration_per_transaction_cents, prior_small_offers, prior_private_placement_offerees]).

sfa_offer_exemptions_what_if(ProfileKey, NewValue, Profile, Result) :-
    override_key(Profile, ProfileKey, NewValue, Hypothesis),
    decide_sfa_offer_exemptions(Hypothesis, Result).

threshold_verdict_at(Profile, ProfileKey, ProbeValue, ProbeVerdict) :-
    override_key(Profile, ProfileKey, ProbeValue, NewProfile),
    sfa_offer_exemptions_status(NewProfile, ProbeVerdict).

sfa_offer_exemptions_threshold(Profile, ProfileKey, LowerBound, UpperBound, Boundary) :-
    integer(LowerBound),
    integer(UpperBound),
    LowerBound < UpperBound,
    threshold_verdict_at(Profile, ProfileKey, LowerBound, LowerVerdict),
    threshold_verdict_at(Profile, ProfileKey, UpperBound, UpperVerdict),
    dif(LowerVerdict, UpperVerdict),
    flip_scan(LowerBound, UpperBound, threshold_verdict_at(Profile, ProfileKey), FlipPoint),
    threshold_verdict_at(Profile, ProfileKey, FlipPoint, FlipVerdict),
    boundary_from_flip(FlipPoint, FlipVerdict, LowerVerdict, UpperVerdict, Boundary).

boundary_from_flip(FlipPoint, FlipVerdict, LowerVerdict, _UpperVerdict, Boundary) :-
    FlipVerdict == LowerVerdict,
    Boundary is FlipPoint.
boundary_from_flip(FlipPoint, FlipVerdict, _LowerVerdict, UpperVerdict, Boundary) :-
    FlipVerdict == UpperVerdict,
    Boundary is FlipPoint - 1.
