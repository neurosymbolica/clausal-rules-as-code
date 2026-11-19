% SPDX-License-Identifier: EUPL-1.2
:- module(m__cn_pipl_individual_rights_citations, [citation/2, implements/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).

citation(cn_pipl_art_44_p1, [label - 'Personal Information Protection Law of the PRC (2021) art 44 (right to restrict or refuse processing; except where laws or administrative regulations provide otherwise)', ref - 'cn-pipl-2021#art_44_p1, npc.gov.cn page text, 2021 adoption text']).
citation(cn_pipl_art_45_p1, [label - 'Personal Information Protection Law of the PRC (2021) art 45(1) (right to consult and copy; except the cases of art 18(1) and art 35)', ref - 'cn-pipl-2021#art_45_p1, npc.gov.cn page text, 2021 adoption text']).
citation(cn_pipl_art_45_p2, [label - 'Personal Information Protection Law of the PRC (2021) art 45(2) (handler shall provide in time on a request to consult or copy)', ref - 'cn-pipl-2021#art_45_p2, npc.gov.cn page text, 2021 adoption text']).
citation(cn_pipl_art_45_p3, [label - 'Personal Information Protection Law of the PRC (2021) art 45(3) (way to transfer to a designated handler where the national cyberspace department conditions are met)', ref - 'cn-pipl-2021#art_45_p3, npc.gov.cn page text, 2021 adoption text']).
citation(cn_pipl_art_46_p1, [label - 'Personal Information Protection Law of the PRC (2021) art 46(1) (right to request correction or supplementing of inaccurate or incomplete information)', ref - 'cn-pipl-2021#art_46_p1, npc.gov.cn page text, 2021 adoption text']).
citation(cn_pipl_art_46_p2, [label - 'Personal Information Protection Law of the PRC (2021) art 46(2) (handler shall verify and correct or supplement in time)', ref - 'cn-pipl-2021#art_46_p2, npc.gov.cn page text, 2021 adoption text']).
citation(cn_pipl_art_47_p1, [label - 'Personal Information Protection Law of the PRC (2021) art 47(1) chapeau (handler shall delete on its own initiative in any of the listed cases; individual may request deletion)', ref - 'cn-pipl-2021#art_47_p1, npc.gov.cn page text, 2021 adoption text']).
citation(cn_pipl_art_47_p1_i1, [label - 'Personal Information Protection Law of the PRC (2021) art 47(1) item (1) (purpose achieved, cannot be achieved, or no longer necessary)', ref - 'cn-pipl-2021#art_47_p1_i1, npc.gov.cn page text, 2021 adoption text']).
citation(cn_pipl_art_47_p1_i2, [label - 'Personal Information Protection Law of the PRC (2021) art 47(1) item (2) (products or services stopped, or retention period expired)', ref - 'cn-pipl-2021#art_47_p1_i2, npc.gov.cn page text, 2021 adoption text']).
citation(cn_pipl_art_47_p1_i3, [label - 'Personal Information Protection Law of the PRC (2021) art 47(1) item (3) (individual withdraws consent)', ref - 'cn-pipl-2021#art_47_p1_i3, npc.gov.cn page text, 2021 adoption text']).
citation(cn_pipl_art_47_p1_i4, [label - 'Personal Information Protection Law of the PRC (2021) art 47(1) item (4) (processing in violation of laws, administrative regulations or an agreement)', ref - 'cn-pipl-2021#art_47_p1_i4, npc.gov.cn page text, 2021 adoption text']).
citation(cn_pipl_art_47_p1_i5, [label - 'Personal Information Protection Law of the PRC (2021) art 47(1) item (5) (other cases prescribed by laws or administrative regulations)', ref - 'cn-pipl-2021#art_47_p1_i5, npc.gov.cn page text, 2021 adoption text']).
citation(cn_pipl_art_47_p2, [label - 'Personal Information Protection Law of the PRC (2021) art 47(2) (legal retention period unexpired or deletion technically difficult: stop processing other than storage and necessary security measures)', ref - 'cn-pipl-2021#art_47_p2, npc.gov.cn page text, 2021 adoption text']).
citation(cn_pipl_art_48_p1, [label - 'Personal Information Protection Law of the PRC (2021) art 48 (right to request explanation of the processing rules)', ref - 'cn-pipl-2021#art_48_p1, npc.gov.cn page text, 2021 adoption text']).
citation(cn_pipl_art_49_p1, [label - 'Personal Information Protection Law of the PRC (2021) art 49 (near relatives of a deceased person, for their own lawful and legitimate interests; except where the deceased arranged otherwise)', ref - 'cn-pipl-2021#art_49_p1, npc.gov.cn page text, 2021 adoption text']).
citation(cn_pipl_art_50_p1, [label - 'Personal Information Protection Law of the PRC (2021) art 50(1) (convenient mechanism for accepting and handling requests; reasons for a refusal)', ref - 'cn-pipl-2021#art_50_p1, npc.gov.cn page text, 2021 adoption text']).
citation(cn_pipl_art_50_p2, [label - 'Personal Information Protection Law of the PRC (2021) art 50(2) (individual may sue in a people\'s court where a request is refused)', ref - 'cn-pipl-2021#art_50_p2, npc.gov.cn page text, 2021 adoption text']).

implements(Key) :-
    citation(Key, _).

test(a_recorded_key_is_implemented) :-
    implements(cn_pipl_art_47_p1_i3).
test(seventeen_keys_are_recorded) :-
    findall(Key, citation(Key, _), Keys),
    length(Keys, 17).

test(a_shortened_key_is_not_implemented, fail) :-
    implements(pipl_art_47).
