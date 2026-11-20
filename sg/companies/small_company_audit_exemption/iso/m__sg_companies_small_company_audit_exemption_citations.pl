% SPDX-License-Identifier: EUPL-1.2
:- module(m__sg_companies_small_company_audit_exemption_citations, [citation/2, implements/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).

citation(ca1967_s205c_1, [label - 'Companies Act 1967 s 205C(1) -- small company exempt from audit requirements', ref - 'https://sso.agc.gov.sg/Act/CoA1967?ProvIds=pr205C-']).
citation(ca1967_s205c_3, [label - 'Companies Act 1967 s 205C(3) -- parent company must be small company and part of small group', ref - 'https://sso.agc.gov.sg/Act/CoA1967?ProvIds=pr205C-']).
citation(ca1967_s205c_4, [label - 'Companies Act 1967 s 205C(4) -- subsidiary company must be small company and part of small group', ref - 'https://sso.agc.gov.sg/Act/CoA1967?ProvIds=pr205C-']).
citation(ca1967_s205c_6, [label - 'Companies Act 1967 s 205C(6) -- exemption does not apply to financial years commencing before 1 July 2015', ref - 'https://sso.agc.gov.sg/Act/CoA1967?ProvIds=pr205C-']).
citation(ca1967_s205b_6, [label - 'Companies Act 1967 s 205B(6) -- members holding not less than 5 per cent may require an audit by written notice', ref - 'https://sso.agc.gov.sg/Act/CoA1967?ProvIds=pr205B-']).
citation(ca1967_s205b_7, [label - 'Companies Act 1967 s 205B(7)', ref - 'https://sso.agc.gov.sg/Act/CoA1967?ProvIds=pr205B-']).
citation(ca1967_sc13_para_2, [label - 'Companies Act 1967 Thirteenth Schedule para 2', ref - 'https://sso.agc.gov.sg/Act/CoA1967?ProvIds=Sc13-']).
citation(ca1967_sc13_para_3, [label - 'Companies Act 1967 Thirteenth Schedule para 3', ref - 'https://sso.agc.gov.sg/Act/CoA1967?ProvIds=Sc13-']).
citation(ca1967_sc13_para_4, [label - 'Companies Act 1967 Thirteenth Schedule para 4 -- same as para 3 for a company incorporated before 1 July 2015 counting from the first and second financial years commencing on or after that date', ref - 'https://sso.agc.gov.sg/Act/CoA1967?ProvIds=Sc13-']).
citation(ca1967_sc13_para_5, [label - 'Companies Act 1967 Thirteenth Schedule para 5', ref - 'https://sso.agc.gov.sg/Act/CoA1967?ProvIds=Sc13-']).
citation(ca1967_sc13_para_6, [label - 'Companies Act 1967 Thirteenth Schedule para 6', ref - 'https://sso.agc.gov.sg/Act/CoA1967?ProvIds=Sc13-']).
citation(ca1967_sc13_para_7, [label - 'Companies Act 1967 Thirteenth Schedule para 7', ref - 'https://sso.agc.gov.sg/Act/CoA1967?ProvIds=Sc13-']).
citation(ca1967_sc13_para_8, [label - 'Companies Act 1967 Thirteenth Schedule para 8', ref - 'https://sso.agc.gov.sg/Act/CoA1967?ProvIds=Sc13-']).
citation(ca1967_sc13_para_9, [label - 'Companies Act 1967 Thirteenth Schedule para 9 -- same as para 8 for a group formed before 1 July 2015 counting from the first and second financial years commencing on or after that date', ref - 'https://sso.agc.gov.sg/Act/CoA1967?ProvIds=Sc13-']).
citation(ca1967_sc13_para_10, [label - 'Companies Act 1967 Thirteenth Schedule para 10', ref - 'https://sso.agc.gov.sg/Act/CoA1967?ProvIds=Sc13-']).
citation(ca1967_sc13_para_11, [label - 'Companies Act 1967 Thirteenth Schedule para 11', ref - 'https://sso.agc.gov.sg/Act/CoA1967?ProvIds=Sc13-']).
citation(ca1967_sc13_para_12, [label - 'Companies Act 1967 Thirteenth Schedule para 12 -- group membership and consolidation follow the Accounting Standards', ref - 'https://sso.agc.gov.sg/Act/CoA1967?ProvIds=Sc13-']).
citation(ca1967_sc13_para_13, [label - 'Companies Act 1967 Thirteenth Schedule para 13 -- small from a financial year means small for that year and every subsequent year until it ceases under para 5', ref - 'https://sso.agc.gov.sg/Act/CoA1967?ProvIds=Sc13-']).
citation(ca1967_sc13_para_14, [label - 'Companies Act 1967 Thirteenth Schedule para 14 -- a company that has ceased to be small may become small again by qualifying under para 2', ref - 'https://sso.agc.gov.sg/Act/CoA1967?ProvIds=Sc13-']).

implements(Key) :-
    citation(Key, _).
