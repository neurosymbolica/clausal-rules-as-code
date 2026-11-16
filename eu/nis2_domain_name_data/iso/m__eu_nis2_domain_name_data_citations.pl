% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_nis2_domain_name_data_citations, [citation/2, implements/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).

implements(Key) :-
    citation(Key, _).

citation(eu_dir_2022_2555_art_28_1, [label - 'Directive (EU) 2022/2555 (NIS 2) Art 28(1)', ref - '32022L2555#parag_028.001', verbatim - 'For the purpose of contributing to the security, stability and resilience of the DNS, Member States shall require TLD name registries and entities providing domain name registration services to collect and maintain accurate and complete domain name registration data in a dedicated database with due diligence in accordance with Union data protection law as regards data which are personal data.']).
citation(eu_dir_2022_2555_art_28_2, [label - 'Directive (EU) 2022/2555 (NIS 2) Art 28(2)', ref - '32022L2555#parag_028.002', verbatim - 'For the purposes of paragraph 1, Member States shall require the database of domain name registration data to contain the necessary information to identify and contact the holders of the domain names and the points of contact administering the domain names under the TLDs.']).
citation(eu_dir_2022_2555_art_28_2_a, [label - 'Directive (EU) 2022/2555 (NIS 2) Art 28(2)(a)', ref - '32022L2555#point_028.002_a', verbatim - 'the domain name']).
citation(eu_dir_2022_2555_art_28_2_b, [label - 'Directive (EU) 2022/2555 (NIS 2) Art 28(2)(b)', ref - '32022L2555#point_028.002_b', verbatim - 'the date of registration']).
citation(eu_dir_2022_2555_art_28_2_c, [label - 'Directive (EU) 2022/2555 (NIS 2) Art 28(2)(c)', ref - '32022L2555#point_028.002_c', verbatim - 'name, contact email address and telephone number']).
citation(eu_dir_2022_2555_art_28_2_d, [label - 'Directive (EU) 2022/2555 (NIS 2) Art 28(2)(d)', ref - '32022L2555#point_028.002_d', verbatim - 'the contact email address and telephone number of the point of contact administering the domain name in the event that they are different from those of the registrant']).
citation(eu_dir_2022_2555_art_28_3, [label - 'Directive (EU) 2022/2555 (NIS 2) Art 28(3)', ref - '32022L2555#parag_028.003', verbatim - 'Member States shall require the TLD name registries and the entities providing domain name registration services to have policies and procedures, including verification procedures, in place to ensure that the databases referred to in paragraph 1 include accurate and complete information. Member States shall require such policies and procedures to be made publicly available.']).
citation(eu_dir_2022_2555_art_28_4, [label - 'Directive (EU) 2022/2555 (NIS 2) Art 28(4)', ref - '32022L2555#parag_028.004', verbatim - 'Member States shall require the TLD name registries and the entities providing domain name registration services to make publicly available, without undue delay after the registration of a domain name, the domain name registration data which are not personal data.']).
citation(eu_dir_2022_2555_art_28_5, [label - 'Directive (EU) 2022/2555 (NIS 2) Art 28(5)', ref - '32022L2555#parag_028.005', verbatim - 'Member States shall require the TLD name registries and the entities providing domain name registration services to reply without undue delay and in any event within 72 hours of receipt of any requests for access.']).
citation(eu_dir_2022_2555_art_28_6, [label - 'Directive (EU) 2022/2555 (NIS 2) Art 28(6)', ref - '32022L2555#parag_028.006', verbatim - 'Compliance with the obligations laid down in paragraphs 1 to 5 shall not result in a duplication of collecting domain name registration data.']).
