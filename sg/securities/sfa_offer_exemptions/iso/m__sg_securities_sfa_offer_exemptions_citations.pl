% SPDX-License-Identifier: EUPL-1.2
:- module(m__sg_securities_sfa_offer_exemptions_citations, [citation/2, implements/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).

citation(sg_sfa_2001_s274, [label - 'SFA 2001 s 274 -- institutional investor exemption', ref - 'https://sso.agc.gov.sg/Act/SFA2001?ProvIds=pr274-']).
citation(sg_sfa_2001_s275_1, [label - 'SFA 2001 s 275(1) -- relevant person exemption', ref - 'https://sso.agc.gov.sg/Act/SFA2001?ProvIds=pr275-']).
citation(sg_sfa_2001_s275_1a, [label - 'SFA 2001 s 275(1A) -- principal acquisition exemption', ref - 'https://sso.agc.gov.sg/Act/SFA2001?ProvIds=pr275-']).
citation(sg_sfa_2001_s272a_1, [label - 'SFA 2001 s 272A(1) -- small personal offer exemption', ref - 'https://sso.agc.gov.sg/Act/SFA2001?ProvIds=pr272A-']).
citation(sg_sfa_2001_s272b_1, [label - 'SFA 2001 s 272B(1) -- private placement exemption', ref - 'https://sso.agc.gov.sg/Act/SFA2001?ProvIds=pr272B-']).
citation(sg_sfa_2001_s240, [label - 'SFA 2001 s 240 -- prospectus requirement', ref - 'https://sso.agc.gov.sg/Act/SFA2001?ProvIds=pr240-']).

implements(Key) :-
    citation(Key, _).
