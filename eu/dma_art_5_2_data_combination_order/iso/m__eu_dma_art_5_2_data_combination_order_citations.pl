% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dma_art_5_2_data_combination_order_citations, [citation/2, implements/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).

citation(eu_reg_2022_1925_art_5_1, [label - 'Regulation (EU) 2022/1925 (Digital Markets Act) Art 5(1), scope of the Article 5 obligations: core platform services listed in the designation decision pursuant to Article 3(9)', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:32022R1925 (unit parag_005.001)', verbatim - 'The gatekeeper shall comply with all obligations set out in this Article with respect to each of its core platform services listed in the designation decision pursuant to Article 3(9).']).
citation(eu_reg_2022_1925_art_5_2, [label - 'Regulation (EU) 2022/1925 (Digital Markets Act) Art 5(2), first subparagraph (prohibition unless specific choice and consent), second subparagraph (repeated request for consent at most once within one year) and last sentence (Article 6(1), points (c), (d) and (e), of Regulation (EU) 2016/679)', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:32022R1925 (unit parag_005.002)', verbatim - 'unless the end user has been presented with the specific choice and has given consent within the meaning of Article 4, point (11), and Article 7 of Regulation (EU) 2016/679']).
citation(eu_reg_2022_1925_art_5_2_a, [label - 'Regulation (EU) 2022/1925 (Digital Markets Act) Art 5(2)(a), processing personal data of end users of third-party services for online advertising services', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:32022R1925 (unit point_005.002_a)', verbatim - 'process, for the purpose of providing online advertising services, personal data of end users using services of third parties that make use of core platform services of the gatekeeper']).
citation(eu_reg_2022_1925_art_5_2_b, [label - 'Regulation (EU) 2022/1925 (Digital Markets Act) Art 5(2)(b), combining personal data from the relevant core platform service with other personal data', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:32022R1925 (unit point_005.002_b)', verbatim - 'combine personal data from the relevant core platform service with personal data from any further core platform services or from any other services provided by the gatekeeper or with personal data from third-party services']).
citation(eu_reg_2022_1925_art_5_2_c, [label - 'Regulation (EU) 2022/1925 (Digital Markets Act) Art 5(2)(c), cross-using personal data from the relevant core platform service in other services provided separately by the gatekeeper, and vice versa', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:32022R1925 (unit point_005.002_c)', verbatim - 'cross-use personal data from the relevant core platform service in other services provided separately by the gatekeeper, including other core platform services, and vice versa']).
citation(eu_reg_2022_1925_art_5_2_d, [label - 'Regulation (EU) 2022/1925 (Digital Markets Act) Art 5(2)(d), signing in end users to other services of the gatekeeper in order to combine personal data', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:32022R1925 (unit point_005.002_d)', verbatim - 'sign in end users to other services of the gatekeeper in order to combine personal data']).
citation(eu_reg_2022_1925_art_2_32, [label - 'Regulation (EU) 2022/1925 (Digital Markets Act) Art 2(32), definition of consent', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:32022R1925 (unit point_002_32)', verbatim - 'means consent as defined in Article 4, point (11), of Regulation (EU) 2016/679']).
citation(commission_designation_decision, [label - 'Outside-fact target: a Commission designation decision under Article 3(9) of Regulation (EU) 2022/1925 listing the core platform service (designated_as_gatekeeper_for_core_platform_service)', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:32022R1925 (Art 3(9), not pinned)']).
citation(digital_markets_end_user_consent_statement, [label - 'Outside-fact target: a statement that the end user gave consent within the meaning of Article 4, point (11), and Article 7 of Regulation (EU) 2016/679 (end_user_consent_given)', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:32016R0679 (Art 4(11) and Art 7, not pinned)']).
citation(digital_markets_article_6_1_c_d_e_basis_statement, [label - 'Outside-fact target: a statement that the gatekeeper may rely on Article 6(1), point (c), (d) or (e), of Regulation (EU) 2016/679 for the practice (gatekeeper_may_rely_on_article_6_1_c_d_or_e)', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:32016R0679 (Art 6(1)(c), (d) and (e), not pinned)']).

implements(Key) :-
    citation(Key, _).

test(every_lexicon_key_is_recorded) :-
    implements(eu_reg_2022_1925_art_5_1),
    implements(eu_reg_2022_1925_art_5_2),
    implements(eu_reg_2022_1925_art_5_2_a),
    implements(eu_reg_2022_1925_art_5_2_b),
    implements(eu_reg_2022_1925_art_5_2_c),
    implements(eu_reg_2022_1925_art_5_2_d),
    implements(eu_reg_2022_1925_art_2_32).
test(every_target_is_recorded) :-
    implements(commission_designation_decision),
    implements(digital_markets_end_user_consent_statement),
    implements(digital_markets_article_6_1_c_d_e_basis_statement).

test(a_shortened_key_is_not_recorded, fail) :-
    implements(dma_art_5_2).
