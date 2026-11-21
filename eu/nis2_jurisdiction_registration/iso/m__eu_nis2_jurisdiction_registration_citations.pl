% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_nis2_jurisdiction_registration_citations, [citation/2, citation_vocabulary/1, implements/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).

citation(eu_dir_2022_2555_art_26_1, [label - 'Directive (EU) 2022/2555 Art 26(1), opening words (general rule: Member State of establishment)', ref - 'https://eur-lex.europa.eu/eli/dir/2022/2555/oj', verbatim - 'Entities falling within the scope of this Directive shall be considered to fall under the jurisdiction of the Member State in which they are established']).
citation(eu_dir_2022_2555_art_26_1_a, [label - 'Directive (EU) 2022/2555 Art 26(1)(a) (public electronic communications providers: Member State where services are provided)', ref - 'https://eur-lex.europa.eu/eli/dir/2022/2555/oj', verbatim - 'providers of public electronic communications networks or providers of publicly available electronic communications services, which shall be considered to fall under the jurisdiction of the Member State in which they provide their services']).
citation(eu_dir_2022_2555_art_26_1_b, [label - 'Directive (EU) 2022/2555 Art 26(1)(b) (DNS, TLD, registration, cloud, data centre, CDN, managed and managed security service providers, online marketplaces, search engines, social networks: Member State of main establishment)', ref - 'https://eur-lex.europa.eu/eli/dir/2022/2555/oj', verbatim - 'which shall be considered to fall under the jurisdiction of the Member State in which they have their main establishment in the Union under paragraph 2']).
citation(eu_dir_2022_2555_art_26_1_c, [label - 'Directive (EU) 2022/2555 Art 26(1)(c) (public administration entities: Member State which established them)', ref - 'https://eur-lex.europa.eu/eli/dir/2022/2555/oj', verbatim - 'public administration entities, which shall be considered to fall under the jurisdiction of the Member State which established them']).
citation(eu_dir_2022_2555_art_26_2, [label - 'Directive (EU) 2022/2555 Art 26(2) (main establishment: decisions, then cybersecurity operations, then most employees)', ref - 'https://eur-lex.europa.eu/eli/dir/2022/2555/oj', verbatim - 'shall be considered to have its main establishment in the Union in the Member State where the decisions related to the cybersecurity risk-management measures are predominantly taken']).
citation(eu_dir_2022_2555_art_26_3, [label - 'Directive (EU) 2022/2555 Art 26(3) (entity of Art 26(1)(b) not established in the Union: representative)', ref - 'https://eur-lex.europa.eu/eli/dir/2022/2555/oj', verbatim - 'Such an entity shall be considered to fall under the jurisdiction of the Member State where the representative is established']).
citation(eu_dir_2022_2555_art_27_1, [label - 'Directive (EU) 2022/2555 Art 27(1) (list of entity types of the registry, read only for that list)', ref - 'https://eur-lex.europa.eu/eli/dir/2022/2555/oj', verbatim - 'a registry of DNS service providers, TLD name registries, entities providing domain name registration services']).
citation(eu_dir_2022_2555_art_27_2, [label - 'Directive (EU) 2022/2555 Art 27(2), chapeau (information the entities of Art 27(1) submit)', ref - 'https://eur-lex.europa.eu/eli/dir/2022/2555/oj', verbatim - 'Member States shall require entities referred to in paragraph 1 to submit the following information to the competent authorities']).
citation(eu_dir_2022_2555_art_27_2_a, [label - 'Directive (EU) 2022/2555 Art 27(2)(a) (name of the entity)', ref - 'https://eur-lex.europa.eu/eli/dir/2022/2555/oj', verbatim - 'the name of the entity']).
citation(eu_dir_2022_2555_art_27_2_b, [label - 'Directive (EU) 2022/2555 Art 27(2)(b) (sector, subsector and type of entity, where applicable)', ref - 'https://eur-lex.europa.eu/eli/dir/2022/2555/oj', verbatim - 'the relevant sector, subsector and type of entity referred to in Annex I or II, where applicable']).
citation(eu_dir_2022_2555_art_27_2_c, [label - 'Directive (EU) 2022/2555 Art 27(2)(c) (address of main and other Union establishments, or of the representative)', ref - 'https://eur-lex.europa.eu/eli/dir/2022/2555/oj', verbatim - 'and its other legal establishments in the Union or, if not established in the Union, of its representative designated pursuant to Article 26(3)']).
citation(eu_dir_2022_2555_art_27_2_d, [label - 'Directive (EU) 2022/2555 Art 27(2)(d) (contact details of the entity and of its representative)', ref - 'https://eur-lex.europa.eu/eli/dir/2022/2555/oj', verbatim - 'up-to-date contact details, including email addresses and telephone numbers of the entity']).
citation(eu_dir_2022_2555_art_27_2_e, [label - 'Directive (EU) 2022/2555 Art 27(2)(e) (Member States where the entity provides services)', ref - 'https://eur-lex.europa.eu/eli/dir/2022/2555/oj', verbatim - 'the Member States where the entity provides services']).
citation(eu_dir_2022_2555_art_27_2_f, [label - 'Directive (EU) 2022/2555 Art 27(2)(f) (IP ranges of the entity)', ref - 'https://eur-lex.europa.eu/eli/dir/2022/2555/oj', verbatim - 'IP ranges']).
citation(eu_dir_2022_2555_art_27_3, [label - 'Directive (EU) 2022/2555 Art 27(3) (notification of changes to registry information: three months)', ref - 'https://eur-lex.europa.eu/eli/dir/2022/2555/oj', verbatim - 'without delay and in any event within three months of the date of the change']).
citation(eu_dir_2022_2555_art_3_3, [label - 'Directive (EU) 2022/2555 Art 3(3) (list of essential and important entities and domain name registration entities)', ref - 'https://eur-lex.europa.eu/eli/dir/2022/2555/oj', verbatim - 'Member States shall establish a list of essential and important entities as well as entities providing domain name registration services']).
citation(eu_dir_2022_2555_art_3_4, [label - 'Directive (EU) 2022/2555 Art 3(4) second subparagraph (notification of changes to list details: two weeks)', ref - 'https://eur-lex.europa.eu/eli/dir/2022/2555/oj', verbatim - 'shall notify any changes to the details submitted pursuant to the first subparagraph of this paragraph without delay, and, in any event, within two weeks of the date of the change']).
citation(eu_dir_2022_2555_art_3_4_a, [label - 'Directive (EU) 2022/2555 Art 3(4)(a) (name of the entity)', ref - 'https://eur-lex.europa.eu/eli/dir/2022/2555/oj', verbatim - 'the name of the entity']).
citation(eu_dir_2022_2555_art_3_4_b, [label - 'Directive (EU) 2022/2555 Art 3(4)(b) (address and contact details, including email addresses, IP ranges and telephone numbers)', ref - 'https://eur-lex.europa.eu/eli/dir/2022/2555/oj', verbatim - 'the address and up-to-date contact details, including email addresses, IP ranges and telephone numbers']).
citation(eu_dir_2022_2555_art_3_4_c, [label - 'Directive (EU) 2022/2555 Art 3(4)(c) (sector and subsector, where applicable)', ref - 'https://eur-lex.europa.eu/eli/dir/2022/2555/oj', verbatim - 'where applicable, the relevant sector and subsector referred to in Annex I or II']).
citation(eu_dir_2022_2555_art_3_4_d, [label - 'Directive (EU) 2022/2555 Art 3(4)(d) (Member States where services in scope are provided, where applicable)', ref - 'https://eur-lex.europa.eu/eli/dir/2022/2555/oj', verbatim - 'where applicable, a list of the Member States where they provide services falling within the scope of this Directive']).

citation_vocabulary(eu_dir_2022_2555_art_26_1).
citation_vocabulary(eu_dir_2022_2555_art_26_1_a).
citation_vocabulary(eu_dir_2022_2555_art_26_1_b).
citation_vocabulary(eu_dir_2022_2555_art_26_1_c).
citation_vocabulary(eu_dir_2022_2555_art_26_2).
citation_vocabulary(eu_dir_2022_2555_art_26_3).
citation_vocabulary(eu_dir_2022_2555_art_27_2_a).
citation_vocabulary(eu_dir_2022_2555_art_27_2_b).
citation_vocabulary(eu_dir_2022_2555_art_27_2_c).
citation_vocabulary(eu_dir_2022_2555_art_27_2_d).
citation_vocabulary(eu_dir_2022_2555_art_27_2_e).
citation_vocabulary(eu_dir_2022_2555_art_27_2_f).
citation_vocabulary(eu_dir_2022_2555_art_27_3).
citation_vocabulary(eu_dir_2022_2555_art_3_4).
citation_vocabulary(eu_dir_2022_2555_art_3_4_a).
citation_vocabulary(eu_dir_2022_2555_art_3_4_b).
citation_vocabulary(eu_dir_2022_2555_art_3_4_c).
citation_vocabulary(eu_dir_2022_2555_art_3_4_d).

implements(Key) :-
    citation(Key, _).

test(every_vocabulary_key_is_recorded) :-
    findall(Key, citation_vocabulary(Key), Keys),
    length(Keys, 18),
    maplist(implements, Keys).
test(implements_a_recorded_key) :-
    implements(eu_dir_2022_2555_art_26_2).
test(the_marker_only_keys_are_recorded) :-
    implements(eu_dir_2022_2555_art_27_1),
    implements(eu_dir_2022_2555_art_27_2),
    implements(eu_dir_2022_2555_art_3_3).

test(implements_refuses_an_unrecorded_key, fail) :-
    implements(eu_dir_2022_2555_art_26).
test(the_marker_only_keys_are_not_result_vocabulary, fail) :-
    citation_vocabulary(eu_dir_2022_2555_art_27_1).
