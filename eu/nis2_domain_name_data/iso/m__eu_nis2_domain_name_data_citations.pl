% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_nis2_domain_name_data_citations, [citation/2, implements/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).

citation(eu_dir_2022_2555_art_28_1, [label - 'Directive (EU) 2022/2555 (NIS 2) Art 28(1)', ref - 'https://eur-lex.europa.eu/eli/dir/2022/2555/oj', verbatim - 'collect and maintain accurate and complete domain name registration data in a dedicated database with due diligence']).
citation(eu_dir_2022_2555_art_28_2, [label - 'Directive (EU) 2022/2555 (NIS 2) Art 28(2), first subparagraph (chapeau)', ref - 'https://eur-lex.europa.eu/eli/dir/2022/2555/oj', verbatim - 'contain the necessary information to identify and contact the holders of the domain names and the points of contact administering the domain names under the TLDs']).
citation(eu_dir_2022_2555_art_28_2_a, [label - 'Directive (EU) 2022/2555 (NIS 2) Art 28(2)(a) the domain name', ref - 'https://eur-lex.europa.eu/eli/dir/2022/2555/oj', verbatim - 'the domain name']).
citation(eu_dir_2022_2555_art_28_2_b, [label - 'Directive (EU) 2022/2555 (NIS 2) Art 28(2)(b) the date of registration', ref - 'https://eur-lex.europa.eu/eli/dir/2022/2555/oj', verbatim - 'the date of registration']).
citation(eu_dir_2022_2555_art_28_2_c, [label - 'Directive (EU) 2022/2555 (NIS 2) Art 28(2)(c) registrant name, contact email address and telephone number', ref - 'https://eur-lex.europa.eu/eli/dir/2022/2555/oj', verbatim - 'name, contact email address and telephone number']).
citation(eu_dir_2022_2555_art_28_2_d, [label - 'Directive (EU) 2022/2555 (NIS 2) Art 28(2)(d) point of contact administering the domain name', ref - 'https://eur-lex.europa.eu/eli/dir/2022/2555/oj', verbatim - 'the contact email address and telephone number of the point of contact administering the domain name in the event that they are different from those of the registrant']).
citation(eu_dir_2022_2555_art_28_3, [label - 'Directive (EU) 2022/2555 (NIS 2) Art 28(3) policies and verification procedures; publication of them', ref - 'https://eur-lex.europa.eu/eli/dir/2022/2555/oj', verbatim - 'to have policies and procedures, including verification procedures, in place to ensure that the databases referred to in paragraph 1 include accurate and complete information']).
citation(eu_dir_2022_2555_art_28_4, [label - 'Directive (EU) 2022/2555 (NIS 2) Art 28(4) publication of non-personal registration data', ref - 'https://eur-lex.europa.eu/eli/dir/2022/2555/oj', verbatim - 'to make publicly available, without undue delay after the registration of a domain name, the domain name registration data which are not personal data']).
citation(eu_dir_2022_2555_art_28_5, [label - 'Directive (EU) 2022/2555 (NIS 2) Art 28(5) access to data, 72-hour reply and disclosure policies', ref - 'https://eur-lex.europa.eu/eli/dir/2022/2555/oj', verbatim - 'to reply without undue delay and in any event within 72 hours of receipt of any requests for access']).
citation(eu_dir_2022_2555_art_28_6, [label - 'Directive (EU) 2022/2555 (NIS 2) Art 28(6) no duplication of collection; cooperation', ref - 'https://eur-lex.europa.eu/eli/dir/2022/2555/oj', verbatim - 'Compliance with the obligations laid down in paragraphs 1 to 5 shall not result in a duplication of collecting domain name registration data']).

implements(Key) :-
    citation(Key, _).

test(every_canonical_key_is_recorded) :-
    implements(eu_dir_2022_2555_art_28_1),
    implements(eu_dir_2022_2555_art_28_2),
    implements(eu_dir_2022_2555_art_28_2_a),
    implements(eu_dir_2022_2555_art_28_2_b),
    implements(eu_dir_2022_2555_art_28_2_c),
    implements(eu_dir_2022_2555_art_28_2_d),
    implements(eu_dir_2022_2555_art_28_3),
    implements(eu_dir_2022_2555_art_28_4),
    implements(eu_dir_2022_2555_art_28_5),
    implements(eu_dir_2022_2555_art_28_6).
test(a_recorded_key_has_one_record) :-
    findall(Record, citation(eu_dir_2022_2555_art_28_5, Record), Records),
    length(Records, 1).

test(an_unrecorded_key_fails, fail) :-
    implements(eu_dir_2022_2555_art_28).
