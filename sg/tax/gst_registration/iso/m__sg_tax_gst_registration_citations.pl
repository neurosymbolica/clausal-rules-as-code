% SPDX-License-Identifier: EUPL-1.2
:- module(m__sg_tax_gst_registration_citations, [citation/2, implements/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).

citation(sg_gsta_1993_sch1_para_1_1, [label - 'Goods and Services Tax Act 1993, First Schedule, paragraph 1(1)', ref - 'https://sso.agc.gov.sg/Act/GSTA1993']).
citation(sg_gsta_1993_sch1_para_1_1_a_ii, [label - 'Goods and Services Tax Act 1993, First Schedule, paragraph 1(1)(a)(ii)', ref - 'https://sso.agc.gov.sg/Act/GSTA1993']).
citation(sg_gsta_1993_sch1_para_1_1_b, [label - 'Goods and Services Tax Act 1993, First Schedule, paragraph 1(1)(b)', ref - 'https://sso.agc.gov.sg/Act/GSTA1993']).
citation(sg_gsta_1993_sch1_para_1_3_b, [label - 'Goods and Services Tax Act 1993, First Schedule, paragraph 1(3)(b)', ref - 'https://sso.agc.gov.sg/Act/GSTA1993']).
citation(sg_gsta_1993_sch1_para_1_4, [label - 'Goods and Services Tax Act 1993, First Schedule, paragraph 1(4)', ref - 'https://sso.agc.gov.sg/Act/GSTA1993']).
citation(sg_gsta_1993_sch1_para_1c_2, [label - 'Goods and Services Tax Act 1993, First Schedule, paragraph 1C(2)', ref - 'https://sso.agc.gov.sg/Act/GSTA1993']).
citation(sg_gsta_1993_sch1_para_4_1a, [label - 'Goods and Services Tax Act 1993, First Schedule, paragraph 4(1A)', ref - 'https://sso.agc.gov.sg/Act/GSTA1993']).
citation(sg_gsta_1993_sch1_para_4_2_a, [label - 'Goods and Services Tax Act 1993, First Schedule, paragraph 4(2)(a)', ref - 'https://sso.agc.gov.sg/Act/GSTA1993']).
citation(sg_gsta_1993_sch1_para_5_1, [label - 'Goods and Services Tax Act 1993, First Schedule, paragraph 5(1)', ref - 'https://sso.agc.gov.sg/Act/GSTA1993']).
citation(sg_gsta_1993_sch1_para_5_2_a_i, [label - 'Goods and Services Tax Act 1993, First Schedule, paragraph 5(2)(a)(i)', ref - 'https://sso.agc.gov.sg/Act/GSTA1993']).
citation(sg_gsta_1993_sch1_para_5_2_a_ii, [label - 'Goods and Services Tax Act 1993, First Schedule, paragraph 5(2)(a)(ii)', ref - 'https://sso.agc.gov.sg/Act/GSTA1993']).
citation(sg_gsta_1993_sch1_para_15_1, [label - 'Goods and Services Tax Act 1993, First Schedule, paragraph 15(1)', ref - 'https://sso.agc.gov.sg/Act/GSTA1993']).
citation(sg_interpretation_act_1965_s_50_a, [label - 'Interpretation Act 1965, section 50(a)', ref - 'https://sso.agc.gov.sg/Act/IA1965']).
citation(sg_gsta_1993_s443_2025, [label - 'Statutory Instrument 443/2025, amending First Schedule paragraph 5(2)(a)', ref - 'https://sso.agc.gov.sg/Act/GSTA1993']).

implements(Key) :-
    citation(Key, _).
