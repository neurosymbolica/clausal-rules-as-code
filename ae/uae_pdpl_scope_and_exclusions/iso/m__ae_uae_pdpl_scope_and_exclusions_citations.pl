% SPDX-License-Identifier: EUPL-1.2
:- module(m__ae_uae_pdpl_scope_and_exclusions_citations, [citation/2, implements/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).

implements(Key) :-
    citation(Key, _).

citation(uae_pdpl_art_1_personal_data, [label - 'UAE PDPL (Federal Decree by Law No. (45) of 2021) Art 1 definition of Personal Data', ref - 'https://uaelegislation.gov.ae/en/legislations/1972/download']).
citation(uae_pdpl_art_1_processing, [label - 'UAE PDPL (Federal Decree by Law No. (45) of 2021) Art 1 definition of Processing', ref - 'https://uaelegislation.gov.ae/en/legislations/1972/download']).
citation(uae_pdpl_art_2_1, [label - 'UAE PDPL (Federal Decree by Law No. (45) of 2021) Art 2(1) scope of application (lead-in)', ref - 'https://uaelegislation.gov.ae/en/legislations/1972/download']).
citation(uae_pdpl_art_2_1_a, [label - 'UAE PDPL (Federal Decree by Law No. (45) of 2021) Art 2(1)(a) data subject residing or having a place of business in the State (printed as item 2.)', ref - 'https://uaelegislation.gov.ae/en/legislations/1972/download']).
citation(uae_pdpl_art_2_1_b, [label - 'UAE PDPL (Federal Decree by Law No. (45) of 2021) Art 2(1)(b) controller or processor residing in the State', ref - 'https://uaelegislation.gov.ae/en/legislations/1972/download']).
citation(uae_pdpl_art_2_1_c, [label - 'UAE PDPL (Federal Decree by Law No. (45) of 2021) Art 2(1)(c) controller or processor residing outside the State', ref - 'https://uaelegislation.gov.ae/en/legislations/1972/download']).
citation(uae_pdpl_art_2_2, [label - 'UAE PDPL (Federal Decree by Law No. (45) of 2021) Art 2(2) exclusions (lead-in)', ref - 'https://uaelegislation.gov.ae/en/legislations/1972/download']).
citation(uae_pdpl_art_2_2_a, [label - 'UAE PDPL (Federal Decree by Law No. (45) of 2021) Art 2(2)(a) exclusion of Government Data', ref - 'https://uaelegislation.gov.ae/en/legislations/1972/download']).
citation(uae_pdpl_art_2_2_b, [label - 'UAE PDPL (Federal Decree by Law No. (45) of 2021) Art 2(2)(b) exclusion of [quotation omitted]', ref - 'https://uaelegislation.gov.ae/en/legislations/1972/download']).
citation(uae_pdpl_art_2_2_c, [label - 'UAE PDPL (Federal Decree by Law No. (45) of 2021) Art 2(2)(c) exclusion of [quotation omitted]', ref - 'https://uaelegislation.gov.ae/en/legislations/1972/download']).
citation(uae_pdpl_art_2_2_d, [label - 'UAE PDPL (Federal Decree by Law No. (45) of 2021) Art 2(2)(d) exclusion of a Data Subject processing his or her data for personal purposes', ref - 'https://uaelegislation.gov.ae/en/legislations/1972/download']).
citation(uae_pdpl_art_2_2_e, [label - 'UAE PDPL (Federal Decree by Law No. (45) of 2021) Art 2(2)(e) exclusion of Personal Health Data that has its own protection legislation', ref - 'https://uaelegislation.gov.ae/en/legislations/1972/download']).
citation(uae_pdpl_art_2_2_f, [label - 'UAE PDPL (Federal Decree by Law No. (45) of 2021) Art 2(2)(f) exclusion of personal banking and credit data that have their own protection legislation', ref - 'https://uaelegislation.gov.ae/en/legislations/1972/download']).
citation(uae_pdpl_art_2_2_g, [label - 'UAE PDPL (Federal Decree by Law No. (45) of 2021) Art 2(2)(g) exclusion of free-zone companies and establishments with special data protection legislation', ref - 'https://uaelegislation.gov.ae/en/legislations/1972/download']).
citation(uae_pdpl_art_31, [label - 'UAE PDPL (Federal Decree by Law No. (45) of 2021) Art 31 publication and enforcement (in force as of 02 January 2022)', ref - 'https://uaelegislation.gov.ae/en/legislations/1972/download']).
citation(uae_pdpl_art_1_state, [label - 'UAE PDPL (Federal Decree by Law No. (45) of 2021) Art 1 definition of State (gloss of readings (5) and (6))', ref - 'https://uaelegislation.gov.ae/en/legislations/1972/download']).
citation(uae_pdpl_art_1_data_subject, [label - 'UAE PDPL (Federal Decree by Law No. (45) of 2021) Art 1 definition of Data Subject (gloss of readings (5) and (6))', ref - 'https://uaelegislation.gov.ae/en/legislations/1972/download']).
citation(uae_pdpl_art_1_establishment, [label - 'UAE PDPL (Federal Decree by Law No. (45) of 2021) Art 1 definition of Establishment (gloss of readings (8) and (11))', ref - 'https://uaelegislation.gov.ae/en/legislations/1972/download']).
citation(uae_pdpl_art_1_controller, [label - 'UAE PDPL (Federal Decree by Law No. (45) of 2021) Art 1 definition of Controller (gloss of reading (6))', ref - 'https://uaelegislation.gov.ae/en/legislations/1972/download']).
citation(uae_pdpl_art_1_processor, [label - 'UAE PDPL (Federal Decree by Law No. (45) of 2021) Art 1 definition of Processor (gloss of reading (6))', ref - 'https://uaelegislation.gov.ae/en/legislations/1972/download']).

test(a_recorded_key_is_implemented) :-
    implements(uae_pdpl_art_31).
test(every_load_bearing_key_is_recorded) :-
    implements(uae_pdpl_art_1_personal_data),
    implements(uae_pdpl_art_1_processing),
    implements(uae_pdpl_art_2_1),
    implements(uae_pdpl_art_2_1_a),
    implements(uae_pdpl_art_2_1_b),
    implements(uae_pdpl_art_2_1_c),
    implements(uae_pdpl_art_2_2),
    implements(uae_pdpl_art_2_2_a),
    implements(uae_pdpl_art_2_2_b),
    implements(uae_pdpl_art_2_2_c),
    implements(uae_pdpl_art_2_2_d),
    implements(uae_pdpl_art_2_2_e),
    implements(uae_pdpl_art_2_2_f),
    implements(uae_pdpl_art_2_2_g),
    implements(uae_pdpl_art_31).

test(a_shortened_key_is_not_implemented, fail) :-
    implements(pdpl_art_31).
