% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_churches_and_religious_associations_citations, [citation/2, implements/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).

citation(eu_reg_2016_679_art_91_1, [label - 'Regulation (EU) 2016/679 (GDPR) Art 91(1), existing comprehensive rules of churches and religious associations or communities', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:02016R0679-20160504 (unit 02016R0679-20160504#parag_091.001)', verbatim - 'Where in a Member State, churches and religious associations or communities apply, at the time of entry into force of this Regulation, comprehensive rules relating to the protection of natural persons with regard to processing, such rules may continue to apply, provided that they are brought into line with this Regulation.']).
citation(eu_reg_2016_679_art_91_2, [label - 'Regulation (EU) 2016/679 (GDPR) Art 91(2), supervision of churches and religious associations by an independent supervisory authority, which may be specific', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:02016R0679-20160504 (unit 02016R0679-20160504#parag_091.002)', verbatim - 'Churches and religious associations which apply comprehensive rules in accordance with paragraph 1 of this Article shall be subject to the supervision of an independent supervisory authority, which may be specific, provided that it fulfils the conditions laid down in Chapter VI of this Regulation.']).
citation(rules_applied_at_entry_into_force_statement, [label - 'Attested outside statement for Regulation (EU) 2016/679 (GDPR) Art 91(1): the body applied the rules at the time of entry into force of the Regulation (Art 99 not pinned)', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:02016R0679-20160504 (unit 02016R0679-20160504#parag_091.001; referral target of the outside fact rules_applied_at_entry_into_force_of_the_regulation)']).
citation(chapter_vi_conditions_statement, [label - 'Attested outside statement for Regulation (EU) 2016/679 (GDPR) Art 91(2): the specific supervisory authority fulfils the conditions laid down in Chapter VI (Arts 51 to 59, not pinned)', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:02016R0679-20160504 (unit 02016R0679-20160504#parag_091.002; referral target of the outside fact specific_authority_fulfils_chapter_vi_conditions)']).

implements(Key) :-
    citation(Key, _).

test(article_91_1_is_recorded) :-
    implements(eu_reg_2016_679_art_91_1).
test(article_91_2_is_recorded) :-
    implements(eu_reg_2016_679_art_91_2).
test(the_referral_targets_are_recorded) :-
    citation(rules_applied_at_entry_into_force_statement, [label - _, ref - _]),
    citation(chapter_vi_conditions_statement, [label - _, ref - _]).

test(a_shortened_key_is_not_recorded, fail) :-
    implements(gdpr_art_91_1).
