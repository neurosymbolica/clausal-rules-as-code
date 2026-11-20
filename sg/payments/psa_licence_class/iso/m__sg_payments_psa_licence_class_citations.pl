% SPDX-License-Identifier: EUPL-1.2
:- module(m__sg_payments_psa_licence_class_citations, [citation/2, implements/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).

citation(sg_psa_2019_s5_1_b, [label - 'Payment Services Act 2019 s 5(1)(b)', ref - 'https://sso.agc.gov.sg/Act/PSA2019?ProvIds=pr5-']).
citation(sg_psa_2019_s6_3, [label - 'Payment Services Act 2019 s 6(3)', ref - 'https://sso.agc.gov.sg/Act/PSA2019?ProvIds=pr6-']).
citation(sg_psa_2019_s6_4, [label - 'Payment Services Act 2019 s 6(4)', ref - 'https://sso.agc.gov.sg/Act/PSA2019?ProvIds=pr6-']).
citation(sg_psa_2019_s6_5_a_ii_a, [label - 'Payment Services Act 2019 s 6(5)(a)(i)', ref - 'https://sso.agc.gov.sg/Act/PSA2019?ProvIds=pr6-']).
citation(sg_psa_2019_s6_5_a_ii_b, [label - 'Payment Services Act 2019 s 6(5)(a)(ii)', ref - 'https://sso.agc.gov.sg/Act/PSA2019?ProvIds=pr6-']).
citation(sg_psa_2019_s6_5_b, [label - 'Payment Services Act 2019 s 6(5)(b)', ref - 'https://sso.agc.gov.sg/Act/PSA2019?ProvIds=pr6-']).
citation(sg_psa_2019_s6_5_c, [label - 'Payment Services Act 2019 s 6(5)(c)', ref - 'https://sso.agc.gov.sg/Act/PSA2019?ProvIds=pr6-']).
citation(sg_psa_2019_s5_1_a, [label - 'Payment Services Act 2019 s 5(1)(a)', ref - 'https://sso.agc.gov.sg/Act/PSA2019?ProvIds=pr5-']).
citation(sg_psa_2019_s6_2, [label - 'Payment Services Act 2019 s 6(2)', ref - 'https://sso.agc.gov.sg/Act/PSA2019?ProvIds=pr6-']).
citation(sg_psa_2019_s6_17, [label - 'Payment Services Act 2019 s 6(17)', ref - 'https://sso.agc.gov.sg/Act/PSA2019?ProvIds=pr6-']).
citation(sg_psa_2019_first_schedule_part_1, [label - 'Payment Services Act 2019 First Schedule Part 1', ref - 'https://sso.agc.gov.sg/Act/PSA2019']).

implements(Key) :-
    citation(Key, _).
