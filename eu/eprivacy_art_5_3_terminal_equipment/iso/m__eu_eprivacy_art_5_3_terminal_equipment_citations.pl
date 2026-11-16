% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_eprivacy_art_5_3_terminal_equipment_citations, [citation/2, implements/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).

citation(eu_dir_2002_58_art_5_3, [label - 'Directive 2002/58/EC (ePrivacy Directive) Art 5(3), first and second sentences read together (unit 02002L0058-20091219#art5_p3_s1 and #art5_p3_s2)', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:02002L0058-20091219', verbatim - 'is only allowed on condition that the subscriber or user concerned has given his or her consent']).
citation(eu_dir_2002_58_art_5_3_s1, [label - 'Directive 2002/58/EC (ePrivacy Directive) Art 5(3), first sentence (unit 02002L0058-20091219#art5_p3_s1)', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:02002L0058-20091219', verbatim - '3. Member States shall ensure that the storing of information, or the gaining of access to information already stored, in the terminal equipment of a subscriber or user is only allowed on condition that the subscriber or user concerned has given his or her consent, having been provided with clear and comprehensive information, in accordance with Directive 95/46/EC, inter alia, about the purposes of the processing.']).
citation(eu_dir_2002_58_art_5_3_s2, [label - 'Directive 2002/58/EC (ePrivacy Directive) Art 5(3), second sentence (unit 02002L0058-20091219#art5_p3_s2)', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:02002L0058-20091219', verbatim - 'This shall not prevent any technical storage or access for the sole purpose of carrying out the transmission of a communication over an electronic communications network, or as strictly necessary in order for the provider of an information society service explicitly requested by the subscriber or user to provide the service.']).
citation(eu_dir_2002_58_art_2_f, [label - 'Directive 2002/58/EC (ePrivacy Directive) Art 2, second paragraph, point (f), definition of consent (unit 02002L0058-20091219#art2_f)', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:02002L0058-20091219', verbatim - 'corresponds to the data subject\'s consent in Directive 95/46/EC']).
citation(eu_dir_2002_58_art_2_a, [label - 'Directive 2002/58/EC (ePrivacy Directive) Art 2, second paragraph, point (a), definition of user (unit 02002L0058-20091219#art2_a)', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:02002L0058-20091219', verbatim - 'means any natural person using a publicly available electronic communications service, for private or business purposes, without necessarily having subscribed to this service']).
citation(eu_dir_2002_58_art_5, [label - 'Directive 2002/58/EC (ePrivacy Directive) Article 5 heading (unit 02002L0058-20091219#art5; deferred, context only)', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:02002L0058-20091219', verbatim - 'Confidentiality of the communications']).

implements(Key) :-
    citation(Key, _).

test(every_result_key_is_recorded) :-
    implements(eu_dir_2002_58_art_5_3),
    implements(eu_dir_2002_58_art_5_3_s1),
    implements(eu_dir_2002_58_art_5_3_s2),
    implements(eu_dir_2002_58_art_2_f),
    implements(eu_dir_2002_58_art_2_a).

test(an_unrecorded_key_fails, fail) :-
    implements(eu_dir_2002_58_art_5_3_s3).
