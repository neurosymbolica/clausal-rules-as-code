% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_state_aid_single_undertaking_citations, [citation/2, implements/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).

citation(eu_reg_2023_2831_art_2_2, [label - 'Commission Regulation (EU) 2023/2831 Art 2(2) lead-in, definition of single undertaking', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:32023R2831 (unit art2_p2)', verbatim - '‘Single undertaking’ means, for the purposes of this Regulation, all enterprises having at least one of the following relationships with each other:']).
citation(eu_reg_2023_2831_art_2_2_a, [label - 'Commission Regulation (EU) 2023/2831 Art 2(2)(a) majority of the shareholders’ or members’ voting rights', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:32023R2831 (unit art2_p2_a)', verbatim - 'one enterprise has a majority of the shareholders’ or members’ voting rights in another enterprise;']).
citation(eu_reg_2023_2831_art_2_2_b, [label - 'Commission Regulation (EU) 2023/2831 Art 2(2)(b) right to appoint or remove a majority of the administrative, management or supervisory body', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:32023R2831 (unit art2_p2_b)', verbatim - 'one enterprise has the right to appoint or remove a majority of the members of the administrative, management or supervisory body of another enterprise;']).
citation(eu_reg_2023_2831_art_2_2_c, [label - 'Commission Regulation (EU) 2023/2831 Art 2(2)(c) right to exercise a dominant influence pursuant to a contract or the memorandum or articles of association', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:32023R2831 (unit art2_p2_c)', verbatim - 'one enterprise has the right to exercise a dominant influence over another enterprise pursuant to a contract entered into with that enterprise or pursuant to a provision in its memorandum or articles of association;']).
citation(eu_reg_2023_2831_art_2_2_d, [label - 'Commission Regulation (EU) 2023/2831 Art 2(2)(d) sole control of a majority of voting rights pursuant to an agreement with other shareholders or members', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:32023R2831 (unit art2_p2_d)', verbatim - 'one enterprise, which is a shareholder in or member of another enterprise, controls alone, pursuant to an agreement with other shareholders in or members of that enterprise, a majority of shareholders’ or members’ voting rights in that enterprise.']).
citation(eu_reg_2023_2831_art_2_t1, [label - 'Commission Regulation (EU) 2023/2831 Art 2(2) closing sentence, relationships through one or more other enterprises', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:32023R2831 (unit art2_t1)', verbatim - 'Enterprises having any of the relationships referred to in points (a) to (d) through one or more other enterprises shall also be considered to be a single undertaking.']).

implements(Key) :-
    citation(Key, _).

test(the_lead_in_is_recorded) :-
    implements(eu_reg_2023_2831_art_2_2).
test(the_closing_sentence_is_recorded) :-
    implements(eu_reg_2023_2831_art_2_t1).
test(every_point_is_recorded) :-
    implements(eu_reg_2023_2831_art_2_2_a),
    implements(eu_reg_2023_2831_art_2_2_b),
    implements(eu_reg_2023_2831_art_2_2_c),
    implements(eu_reg_2023_2831_art_2_2_d).
test(six_keys_are_recorded) :-
    findall(Key, citation(Key, _), Keys),
    length(Keys, 6).

test(an_unrecorded_key_is_not_implemented, fail) :-
    implements(eu_reg_2023_2831_art_2_2_e).
