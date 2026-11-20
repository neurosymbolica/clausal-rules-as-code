% SPDX-License-Identifier: EUPL-1.2
:- module(m__sg_securities_sfa_offer_exemptions___init__, []).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__sg_securities_sfa_offer_exemptions_citations, [citation/2, implements/1]).
:- use_module(m__sg_securities_sfa_offer_exemptions_sfa_offer_exemptions, [decide_sfa_offer_exemptions/2, sfa_offer_exemption/2, sfa_offer_exemptions_checklist/2, sfa_offer_exemptions_decision_resolvable/1, sfa_offer_exemptions_status/2, sfa_offer_exemptions_status_values/1]).
:- use_module(m__sg_securities_sfa_offer_exemptions_queries, [sfa_offer_exemptions_profile_keys/1, sfa_offer_exemptions_threshold/5, sfa_offer_exemptions_what_if/4]).
:- use_module(m__sg_securities_sfa_offer_exemptions_fixtures, [sfa_offer_exemptions_assess/2, sfa_offer_exemptions_profile_for/2, sfa_offer_exemptions_subject/1]).
