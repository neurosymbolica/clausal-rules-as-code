% SPDX-License-Identifier: EUPL-1.2
:- module(m__sg_companies_csp_registration_citations, [citation/2, implements/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).

citation(sg_cspa_2024_s2_1_corporate_service, [label - 'Corporate Service Providers Act 2024 s 2(1) definition of corporate service', ref - 'https://sso.agc.gov.sg/Act/CSPA2024?ProvIds=pr2-']).
citation(sg_cspa_2024_s2_1_nominee_director, [label - 'Corporate Service Providers Act 2024 s 2(1) definition of nominee director', ref - 'https://sso.agc.gov.sg/Act/CSPA2024?ProvIds=pr2-']).
citation(sg_cspa_2024_s7_1, [label - 'Corporate Service Providers Act 2024 s 7(1) registration requirement', ref - 'https://sso.agc.gov.sg/Act/CSPA2024?ProvIds=pr7-']).
citation(sg_cspa_2024_s7_2, [label - 'Corporate Service Providers Act 2024 s 7(2) deemed registration for accounting entities', ref - 'https://sso.agc.gov.sg/Act/CSPA2024?ProvIds=pr7-']).
citation(sg_cspa_2024_s16_1, [label - 'Corporate Service Providers Act 2024 s 16(1) nominee director fit-and-proper duty', ref - 'https://sso.agc.gov.sg/Act/CSPA2024?ProvIds=pr16-']).
citation(sg_cspa_2024_s16_2, [label - 'Corporate Service Providers Act 2024 s 16(2) reasonable steps and prescribed factors', ref - 'https://sso.agc.gov.sg/Act/CSPA2024?ProvIds=pr16-']).

implements(Key) :-
    citation(Key, _).
