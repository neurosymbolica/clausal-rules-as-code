% SPDX-License-Identifier: EUPL-1.2
:- module(m__sg_tax_gst_registration___init__, []).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__sg_tax_gst_registration_citations, [citation/2, implements/1]).
:- use_module(m__sg_tax_gst_registration_gst_registration, [decide_gst_registration/2, gst_prospective/5, gst_prospective_liability/2, gst_registration_checklist/2, gst_registration_decision_resolvable/1, gst_registration_status/2, gst_registration_status_values/1, gst_retrospective/5, gst_retrospective_liability/2]).
:- use_module(m__sg_tax_gst_registration_queries, [gst_registration_deadline/3, gst_registration_eligibility/2, gst_registration_profile_keys/1, gst_registration_threshold/2]).
:- use_module(m__sg_tax_gst_registration_fixtures, [gst_registration_assess/2, gst_registration_profile_for/2, gst_registration_subject/1]).
