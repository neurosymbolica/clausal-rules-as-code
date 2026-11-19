% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_administrative_fine_maximum_citations, [citation/2, implements/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).

citation(eu_reg_2016_679_art_83_3, [label - 'Regulation (EU) 2016/679 (GDPR) Art 83(3) several infringements, limit to the amount for the gravest infringement', ref - '02016R0679-20160504#parag_083.003', verbatim - 'If a controller or processor intentionally or negligently, for the same or linked processing operations, infringes several provisions of this Regulation, the total amount of the administrative fine shall not exceed the amount specified for the gravest infringement.']).
citation(eu_reg_2016_679_art_83_4, [label - 'Regulation (EU) 2016/679 (GDPR) Art 83(4) chapeau, lower maximum: EUR 10000000 or, for an undertaking, 2 % of total worldwide annual turnover, whichever is higher', ref - '02016R0679-20160504#parag_083.004', verbatim - 'be subject to administrative fines up to 10000000 EUR, or in the case of an undertaking, up to 2 % of the total worldwide annual turnover of the preceding financial year, whichever is higher']).
citation(eu_reg_2016_679_art_83_4_a, [label - 'Regulation (EU) 2016/679 (GDPR) Art 83(4)(a) obligations of the controller and the processor under Articles 8, 11, 25 to 39, 42 and 43', ref - '02016R0679-20160504#point_083.004_a', verbatim - 'the obligations of the controller and the processor pursuant to Articles 8, 11, 25 to 39 and 42 and 43']).
citation(eu_reg_2016_679_art_83_4_b, [label - 'Regulation (EU) 2016/679 (GDPR) Art 83(4)(b) obligations of the certification body under Articles 42 and 43', ref - '02016R0679-20160504#point_083.004_b', verbatim - 'the obligations of the certification body pursuant to Articles 42 and 43']).
citation(eu_reg_2016_679_art_83_4_c, [label - 'Regulation (EU) 2016/679 (GDPR) Art 83(4)(c) obligations of the monitoring body under Article 41(4)', ref - '02016R0679-20160504#point_083.004_c', verbatim - 'the obligations of the monitoring body pursuant to Article 41(4)']).
citation(eu_reg_2016_679_art_83_5, [label - 'Regulation (EU) 2016/679 (GDPR) Art 83(5) chapeau, higher maximum: EUR 20000000 or, for an undertaking, 4 % of total worldwide annual turnover, whichever is higher', ref - '02016R0679-20160504#parag_083.005', verbatim - 'be subject to administrative fines up to 20000000 EUR, or in the case of an undertaking, up to 4 % of the total worldwide annual turnover of the preceding financial year, whichever is higher']).
citation(eu_reg_2016_679_art_83_5_a, [label - 'Regulation (EU) 2016/679 (GDPR) Art 83(5)(a) basic principles for processing, including conditions for consent, under Articles 5, 6, 7 and 9', ref - '02016R0679-20160504#point_083.005_a', verbatim - 'the basic principles for processing, including conditions for consent, pursuant to Articles 5, 6, 7 and 9']).
citation(eu_reg_2016_679_art_83_5_b, [label - 'Regulation (EU) 2016/679 (GDPR) Art 83(5)(b) data subjects\' rights under Articles 12 to 22', ref - '02016R0679-20160504#point_083.005_b', verbatim - 'rights pursuant to Articles 12 to 22']).
citation(eu_reg_2016_679_art_83_5_c, [label - 'Regulation (EU) 2016/679 (GDPR) Art 83(5)(c) transfers of personal data to a third country or an international organisation under Articles 44 to 49', ref - '02016R0679-20160504#point_083.005_c', verbatim - 'the transfers of personal data to a recipient in a third country or an international organisation pursuant to Articles 44 to 49']).
citation(eu_reg_2016_679_art_83_5_d, [label - 'Regulation (EU) 2016/679 (GDPR) Art 83(5)(d) obligations under Member State law adopted under Chapter IX', ref - '02016R0679-20160504#point_083.005_d', verbatim - 'any obligations pursuant to Member State law adopted under Chapter IX']).
citation(eu_reg_2016_679_art_83_5_e, [label - 'Regulation (EU) 2016/679 (GDPR) Art 83(5)(e) non-compliance with a supervisory authority order, limitation or suspension under Article 58(2), or failure to provide access under Article 58(1)', ref - '02016R0679-20160504#point_083.005_e', verbatim - 'non-compliance with an order or a temporary or definitive limitation on processing or the suspension of data flows by the supervisory authority pursuant to Article 58(2) or failure to provide access in violation of Article 58(1)']).
citation(eu_reg_2016_679_art_83_6, [label - 'Regulation (EU) 2016/679 (GDPR) Art 83(6) non-compliance with an order of the supervisory authority under Article 58(2), higher maximum', ref - '02016R0679-20160504#parag_083.006', verbatim - 'Non-compliance with an order by the supervisory authority as referred to in Article 58(2) shall, in accordance with paragraph 2 of this Article, be subject to administrative fines up to 20000000 EUR, or in the case of an undertaking, up to 4 % of the total worldwide annual turnover of the preceding financial year, whichever is higher.']).
citation(eu_reg_2016_679_art_83_7, [label - 'Regulation (EU) 2016/679 (GDPR) Art 83(7) Member State rules on administrative fines for public authorities and bodies (deferred)', ref - '02016R0679-20160504#parag_083.007', verbatim - 'each Member State may lay down the rules on whether and to what extent administrative fines may be imposed on public authorities and bodies established in that Member State']).
citation(eu_reg_2016_679_art_4_18, [label - 'Regulation (EU) 2016/679 (GDPR) Art 4(18) definition of enterprise', ref - '02016R0679-20160504#point_004_18', verbatim - 'a natural or legal person engaged in an economic activity, irrespective of its legal form']).
citation(eu_reg_2016_679_art_4_19, [label - 'Regulation (EU) 2016/679 (GDPR) Art 4(19) definition of group of undertakings', ref - '02016R0679-20160504#point_004_19', verbatim - 'a controlling undertaking and its controlled undertakings']).

implements(Key) :-
    citation(Key, _).

test(every_load_bearing_key_is_recorded) :-
    implements(eu_reg_2016_679_art_83_3),
    implements(eu_reg_2016_679_art_83_4),
    implements(eu_reg_2016_679_art_83_4_a),
    implements(eu_reg_2016_679_art_83_4_b),
    implements(eu_reg_2016_679_art_83_4_c),
    implements(eu_reg_2016_679_art_83_5),
    implements(eu_reg_2016_679_art_83_5_a),
    implements(eu_reg_2016_679_art_83_5_b),
    implements(eu_reg_2016_679_art_83_5_c),
    implements(eu_reg_2016_679_art_83_5_d),
    implements(eu_reg_2016_679_art_83_5_e),
    implements(eu_reg_2016_679_art_83_6).
test(documentary_keys_are_recorded) :-
    implements(eu_reg_2016_679_art_83_7),
    implements(eu_reg_2016_679_art_4_18),
    implements(eu_reg_2016_679_art_4_19).
test(each_key_has_one_record) :-
    findall(Key, citation(Key, _), Keys),
    length(Keys, Count),
    sort(Keys, DistinctKeys),
    length(DistinctKeys, Count).

test(a_shortened_key_is_not_recorded, fail) :-
    implements(gdpr_art_83_4).
