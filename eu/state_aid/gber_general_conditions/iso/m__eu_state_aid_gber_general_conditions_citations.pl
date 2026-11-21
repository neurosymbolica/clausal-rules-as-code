% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_state_aid_gber_general_conditions_citations, [citation/2, implements/1, citation_vocabulary/1, scope_citations/1, transparency_citations/1, incentive_citations/1, chapter_i_met_citations/1, chapter_i_not_met_citations/1, threshold_row_citation/2]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).

implements(Key) :-
    citation(Key, _).

citation(eu_reg_651_2014_art_1_2, [label - 'Regulation (EU) No 651/2014 Art 1(2), lead-in (scope exclusions)', ref - 'CELEX 02014R0651-20230701, unit 02014R0651-20230701-chapter-i#ch1_art1_p2', verbatim - 'This Regulation shall not apply to:']).
citation(eu_reg_651_2014_art_1_2_a, [label - 'Regulation (EU) No 651/2014 Art 1(2)(a) (large schemes after 6 months)', ref - 'CELEX 02014R0651-20230701, unit 02014R0651-20230701-chapter-i#ch1_art1_p2_a', verbatim - 'if the average annual State aid budget per Member State exceeds EUR 150 million, from 6 months after their entry into force']).
citation(eu_reg_651_2014_art_1_2_b, [label - 'Regulation (EU) No 651/2014 Art 1(2)(b) (alterations of excluded schemes)', ref - 'CELEX 02014R0651-20230701, unit 02014R0651-20230701-chapter-i#ch1_art1_p2_b', verbatim - 'any alterations of schemes referred to in Article 1(2)(a), other than modifications which cannot affect the compatibility of the aid scheme under this Regulation']).
citation(eu_reg_651_2014_art_1_2_c, [label - 'Regulation (EU) No 651/2014 Art 1(2)(c) (aid to export-related activities)', ref - 'CELEX 02014R0651-20230701, unit 02014R0651-20230701-chapter-i#ch1_art1_p2_c', verbatim - 'aid to export-related activities towards third countries or Member States, namely aid directly linked to the quantities exported']).
citation(eu_reg_651_2014_art_1_2_d, [label - 'Regulation (EU) No 651/2014 Art 1(2)(d) (aid contingent on domestic goods)', ref - 'CELEX 02014R0651-20230701, unit 02014R0651-20230701-chapter-i#ch1_art1_p2_d', verbatim - 'aid contingent upon the use of domestic over imported goods']).
citation(eu_reg_651_2014_art_1_3, [label - 'Regulation (EU) No 651/2014 Art 1(3), lead-in (sector exclusions)', ref - 'CELEX 02014R0651-20230701, unit 02014R0651-20230701-chapter-i#ch1_art1_p3', verbatim - 'This Regulation shall not apply to:']).
citation(eu_reg_651_2014_art_1_3_a, [label - 'Regulation (EU) No 651/2014 Art 1(3)(a) (fishery and aquaculture sector)', ref - 'CELEX 02014R0651-20230701, unit 02014R0651-20230701-chapter-i#ch1_art1_p3_a', verbatim - 'aid granted in the fishery and aquaculture sector, within the scope of Regulation (EU) No 1379/2013']).
citation(eu_reg_651_2014_art_1_3_b, [label - 'Regulation (EU) No 651/2014 Art 1(3)(b) (primary agricultural production sector)', ref - 'CELEX 02014R0651-20230701, unit 02014R0651-20230701-chapter-i#ch1_art1_p3_b', verbatim - 'aid granted in the primary agricultural production sector, with the exception of regional investment aid in outermost regions']).
citation(eu_reg_651_2014_art_1_3_c, [label - 'Regulation (EU) No 651/2014 Art 1(3)(c) (processing and marketing of agricultural products)', ref - 'CELEX 02014R0651-20230701, unit 02014R0651-20230701-chapter-i#ch1_art1_p3_c', verbatim - 'aid granted in the sector of processing and marketing of agricultural products, in the following cases:']).
citation(eu_reg_651_2014_art_1_3_c_i, [label - 'Regulation (EU) No 651/2014 Art 1(3)(c)(i) (aid fixed on price or quantity)', ref - 'CELEX 02014R0651-20230701, unit 02014R0651-20230701-chapter-i#ch1_art1_p3_c_i', verbatim - 'where the amount of the aid is fixed on the basis of the price or quantity of such products purchased from primary producers or put on the market by the undertakings concerned']).
citation(eu_reg_651_2014_art_1_3_c_ii, [label - 'Regulation (EU) No 651/2014 Art 1(3)(c)(ii) (aid passed on to primary producers)', ref - 'CELEX 02014R0651-20230701, unit 02014R0651-20230701-chapter-i#ch1_art1_p3_c_ii', verbatim - 'where the aid is conditional on being partly or entirely passed on to primary producers']).
citation(eu_reg_651_2014_art_1_3_d, [label - 'Regulation (EU) No 651/2014 Art 1(3)(d) (closure of uncompetitive coal mines)', ref - 'CELEX 02014R0651-20230701, unit 02014R0651-20230701-chapter-i#ch1_art1_p3_d', verbatim - 'aid to facilitate the closure of uncompetitive coal mines, as covered by Council Decision 2010/787/EU']).
citation(eu_reg_651_2014_art_1_3_e, [label - 'Regulation (EU) No 651/2014 Art 1(3)(e) (regional aid categories of Article 13)', ref - 'CELEX 02014R0651-20230701, unit 02014R0651-20230701-chapter-i#ch1_art1_p3_e', verbatim - 'the categories of regional aid referred to in Article 13.']).
citation(eu_reg_651_2014_art_1_t1, [label - 'Regulation (EU) No 651/2014 Art 1(3), second subparagraph (undertakings also active in excluded sectors)', ref - 'CELEX 02014R0651-20230701, unit 02014R0651-20230701-chapter-i#ch1_art1_t1', verbatim - 'provided that Member States ensure by appropriate means, such as separation of activities or distinction of costs, that the activities in the excluded sectors do not benefit from the aid granted in accordance with this Regulation']).
citation(eu_reg_651_2014_art_1_4, [label - 'Regulation (EU) No 651/2014 Art 1(4), lead-in (recovery orders and undertakings in difficulty)', ref - 'CELEX 02014R0651-20230701, unit 02014R0651-20230701-chapter-i#ch1_art1_p4', verbatim - 'This Regulation shall not apply to:']).
citation(eu_reg_651_2014_art_1_4_a, [label - 'Regulation (EU) No 651/2014 Art 1(4)(a) (schemes not excluding outstanding recovery orders)', ref - 'CELEX 02014R0651-20230701, unit 02014R0651-20230701-chapter-i#ch1_art1_p4_a', verbatim - 'aid schemes which do not explicitly exclude the payment of individual aid in favour of an undertaking which is subject to an outstanding recovery order']).
citation(eu_reg_651_2014_art_1_4_b, [label - 'Regulation (EU) No 651/2014 Art 1(4)(b) (ad hoc aid to an undertaking under a recovery order)', ref - 'CELEX 02014R0651-20230701, unit 02014R0651-20230701-chapter-i#ch1_art1_p4_b', verbatim - 'ad hoc aid in favour of an undertaking as referred to in point (a)']).
citation(eu_reg_651_2014_art_1_4_c, [label - 'Regulation (EU) No 651/2014 Art 1(4)(c) (aid to undertakings in difficulty, exceptions and 2020 to 2021 derogation)', ref - 'CELEX 02014R0651-20230701, unit 02014R0651-20230701-chapter-i#ch1_art1_p4_c', verbatim - 'aid to undertakings in difficulty, with the exception of aid schemes to make good the damage caused by certain natural disasters']).
citation(eu_reg_651_2014_art_1_5, [label - 'Regulation (EU) No 651/2014 Art 1(5), lead-in (non-severable violation of Union law)', ref - 'CELEX 02014R0651-20230701, unit 02014R0651-20230701-chapter-i#ch1_art1_p5', verbatim - 'This Regulation shall not apply to State aid measures, which entail, by themselves, by the conditions attached to them or by their financing method a non-severable violation of Union law']).
citation(eu_reg_651_2014_art_1_5_a, [label - 'Regulation (EU) No 651/2014 Art 1(5)(a) (headquarters or establishment obligation)', ref - 'CELEX 02014R0651-20230701, unit 02014R0651-20230701-chapter-i#ch1_art1_p5_a', verbatim - 'aid measures where the grant of aid is subject to the obligation for the beneficiary to have its headquarters in the relevant Member State']).
citation(eu_reg_651_2014_art_1_5_b, [label - 'Regulation (EU) No 651/2014 Art 1(5)(b) (obligation to use national goods or services)', ref - 'CELEX 02014R0651-20230701, unit 02014R0651-20230701-chapter-i#ch1_art1_p5_b', verbatim - 'aid measures where the grant of aid is subject to the obligation for the beneficiary to use nationally produced goods or national services']).
citation(eu_reg_651_2014_art_1_5_c, [label - 'Regulation (EU) No 651/2014 Art 1(5)(c) (restricting exploitation of research results)', ref - 'CELEX 02014R0651-20230701, unit 02014R0651-20230701-chapter-i#ch1_art1_p5_c', verbatim - 'aid measures restricting the possibility for the beneficiaries to exploit the research, development and innovation results in other Member States']).
citation(eu_reg_651_2014_art_2_18, [label - 'Regulation (EU) No 651/2014 Art 2(18), lead-in, definition of undertaking in difficulty', ref - 'CELEX 02014R0651-20230701, unit 02014R0651-20230701-chapter-i#ch1_art2_18', verbatim - 'means an undertaking in respect of which at least one of the following circumstances occurs:']).
citation(eu_reg_651_2014_art_2_2, [label - 'Regulation (EU) No 651/2014 Art 2(2), definition of small and medium-sized enterprises', ref - 'CELEX 02014R0651-20230701, unit 02014R0651-20230701-chapter-i#ch1_art2_2', verbatim - 'means undertakings fulfilling the criteria laid down in Annex I']).
citation(eu_reg_651_2014_art_2_23, [label - 'Regulation (EU) No 651/2014 Art 2(23), definition of start of works', ref - 'CELEX 02014R0651-20230701, unit 02014R0651-20230701-chapter-i#ch1_art2_23', verbatim - 'means the earlier of either the start of construction works relating to the investment']).
citation(eu_reg_651_2014_art_2_24, [label - 'Regulation (EU) No 651/2014 Art 2(24), definition of large enterprises', ref - 'CELEX 02014R0651-20230701, unit 02014R0651-20230701-chapter-i#ch1_art2_24', verbatim - 'means undertakings not fulfilling the criteria laid down in Annex I']).
citation(eu_reg_651_2014_art_2_26, [label - 'Regulation (EU) No 651/2014 Art 2(26), definition of aid intensity', ref - 'CELEX 02014R0651-20230701, unit 02014R0651-20230701-chapter-i#ch1_art2_26', verbatim - 'means the gross aid amount expressed as a percentage of the eligible costs, before any deduction of tax or other charge']).
citation(eu_reg_651_2014_art_2_28, [label - 'Regulation (EU) No 651/2014 Art 2(28), definition of date of granting of the aid', ref - 'CELEX 02014R0651-20230701, unit 02014R0651-20230701-chapter-i#ch1_art2_28', verbatim - 'means the date when the legal right to receive the aid is conferred on the beneficiary under the applicable national legal regime']).
citation(eu_reg_651_2014_art_3_t1, [label - 'Regulation (EU) No 651/2014 Art 3 (conditions for exemption)', ref - 'CELEX 02014R0651-20230701, unit 02014R0651-20230701-chapter-i#ch1_art3_t1', verbatim - 'provided that such aid fulfils all the conditions laid down in Chapter I of this Regulation, as well as the specific conditions for the relevant category of aid laid down in Chapter III of this Regulation']).
citation(eu_reg_651_2014_art_4_1, [label - 'Regulation (EU) No 651/2014 Art 4(1), lead-in (notification thresholds)', ref - 'CELEX 02014R0651-20230701, unit 02014R0651-20230701-chapter-i#ch1_art4_p1', verbatim - 'This Regulation shall not apply to aid which exceeds the following thresholds:']).
citation(eu_reg_651_2014_art_4_1_c, [label - 'Regulation (EU) No 651/2014 Art 4(1)(c) (investment aid to SMEs)', ref - 'CELEX 02014R0651-20230701, unit 02014R0651-20230701-chapter-i#ch1_art4_p1_c', verbatim - 'for investment aid to SMEs: EUR 8.25 million per undertaking per investment project']).
citation(eu_reg_651_2014_art_4_1_d, [label - 'Regulation (EU) No 651/2014 Art 4(1)(d) (aid for consultancy in favour of SMEs)', ref - 'CELEX 02014R0651-20230701, unit 02014R0651-20230701-chapter-i#ch1_art4_p1_d', verbatim - 'for aid for consultancy in favour of SMEs: EUR 2.2 million per undertaking, per project']).
citation(eu_reg_651_2014_art_4_1_e, [label - 'Regulation (EU) No 651/2014 Art 4(1)(e) (aid to SMEs for participation in fairs)', ref - 'CELEX 02014R0651-20230701, unit 02014R0651-20230701-chapter-i#ch1_art4_p1_e', verbatim - 'for aid to SMEs for participation in fairs: EUR 2.2 million per undertaking, per year']).
citation(eu_reg_651_2014_art_4_1_i, [label - 'Regulation (EU) No 651/2014 Art 4(1)(i), lead-in (aid for research and development)', ref - 'CELEX 02014R0651-20230701, unit 02014R0651-20230701-chapter-i#ch1_art4_p1_i', verbatim - 'for aid for research and development:']).
citation(eu_reg_651_2014_art_4_1_i_i, [label - 'Regulation (EU) No 651/2014 Art 4(1)(i)(i) (predominantly fundamental research)', ref - 'CELEX 02014R0651-20230701, unit 02014R0651-20230701-chapter-i#ch1_art4_p1_i_i', verbatim - 'if the project is predominantly fundamental research: EUR 55 million per undertaking, per project']).
citation(eu_reg_651_2014_art_4_1_i_ii, [label - 'Regulation (EU) No 651/2014 Art 4(1)(i)(ii) (predominantly industrial research)', ref - 'CELEX 02014R0651-20230701, unit 02014R0651-20230701-chapter-i#ch1_art4_p1_i_ii', verbatim - 'if the project is predominantly industrial research: EUR 35 million per undertaking, per project']).
citation(eu_reg_651_2014_art_4_1_i_iii, [label - 'Regulation (EU) No 651/2014 Art 4(1)(i)(iii) (predominantly experimental development)', ref - 'CELEX 02014R0651-20230701, unit 02014R0651-20230701-chapter-i#ch1_art4_p1_i_iii', verbatim - 'if the project is predominantly experimental development: EUR 25 million per undertaking, per project']).
citation(eu_reg_651_2014_art_4_1_i_iv, [label - 'Regulation (EU) No 651/2014 Art 4(1)(i)(iv) (doubled research figures)', ref - 'CELEX 02014R0651-20230701, unit 02014R0651-20230701-chapter-i#ch1_art4_p1_i_iv', verbatim - 'the amounts referred to in points (i) to (iii) are doubled']).
citation(eu_reg_651_2014_art_4_1_i_vi, [label - 'Regulation (EU) No 651/2014 Art 4(1)(i)(vi) (feasibility studies for research)', ref - 'CELEX 02014R0651-20230701, unit 02014R0651-20230701-chapter-i#ch1_art4_p1_i_vi', verbatim - 'aid for feasibility studies in preparation for research activities: EUR 8.25 million per study']).
citation(eu_reg_651_2014_art_4_1_l, [label - 'Regulation (EU) No 651/2014 Art 4(1)(l) (innovation aid for SMEs)', ref - 'CELEX 02014R0651-20230701, unit 02014R0651-20230701-chapter-i#ch1_art4_p1_l', verbatim - 'Innovation aid for SMEs: EUR 10 million per undertaking, per project']).
citation(eu_reg_651_2014_art_4_1_m, [label - 'Regulation (EU) No 651/2014 Art 4(1)(m) (process and organisational innovation)', ref - 'CELEX 02014R0651-20230701, unit 02014R0651-20230701-chapter-i#ch1_art4_p1_m', verbatim - 'for aid for process and organisational innovation: EUR 12.5 million per undertaking, per project']).
citation(eu_reg_651_2014_art_4_1_n, [label - 'Regulation (EU) No 651/2014 Art 4(1)(n) (training aid)', ref - 'CELEX 02014R0651-20230701, unit 02014R0651-20230701-chapter-i#ch1_art4_p1_n', verbatim - 'for training aid: EUR 3 million per training project']).
citation(eu_reg_651_2014_art_4_1_s, [label - 'Regulation (EU) No 651/2014 Art 4(1)(s) (investment aid for environmental protection)', ref - 'CELEX 02014R0651-20230701, unit 02014R0651-20230701-chapter-i#ch1_art4_p1_s', verbatim - 'for investment aid for environmental protection, unless otherwise specified: EUR 30 million per undertaking per investment project']).
citation(eu_reg_651_2014_art_5_1, [label - 'Regulation (EU) No 651/2014 Art 5(1) (transparent aid)', ref - 'CELEX 02014R0651-20230701, unit 02014R0651-20230701-chapter-i#ch1_art5_p1', verbatim - 'This Regulation shall apply only to aid in respect of which it is possible to calculate precisely the gross grant equivalent of the aid ex ante without any need to undertake a risk assessment']).
citation(eu_reg_651_2014_art_5_2, [label - 'Regulation (EU) No 651/2014 Art 5(2), lead-in (categories considered transparent)', ref - 'CELEX 02014R0651-20230701, unit 02014R0651-20230701-chapter-i#ch1_art5_p2', verbatim - 'The following categories of aid shall be considered to be transparent:']).
citation(eu_reg_651_2014_art_5_2_a, [label - 'Regulation (EU) No 651/2014 Art 5(2)(a) (grants and interest rate subsidies)', ref - 'CELEX 02014R0651-20230701, unit 02014R0651-20230701-chapter-i#ch1_art5_p2_a', verbatim - 'aid comprised in grants and interest rate subsidies']).
citation(eu_reg_651_2014_art_5_2_b, [label - 'Regulation (EU) No 651/2014 Art 5(2)(b) (loans on the reference rate)', ref - 'CELEX 02014R0651-20230701, unit 02014R0651-20230701-chapter-i#ch1_art5_p2_b', verbatim - 'aid comprised in loans, where the gross grant equivalent has been calculated on the basis of the reference rate prevailing at the time of the grant']).
citation(eu_reg_651_2014_art_5_2_c, [label - 'Regulation (EU) No 651/2014 Art 5(2)(c), lead-in (guarantees)', ref - 'CELEX 02014R0651-20230701, unit 02014R0651-20230701-chapter-i#ch1_art5_p2_c', verbatim - 'aid comprised in guarantees:']).
citation(eu_reg_651_2014_art_5_2_c_i, [label - 'Regulation (EU) No 651/2014 Art 5(2)(c)(i) (guarantees on safe-harbour premiums)', ref - 'CELEX 02014R0651-20230701, unit 02014R0651-20230701-chapter-i#ch1_art5_p2_c_i', verbatim - 'where the gross grant equivalent has been calculated on the basis of safe-harbour premiums laid down in a Commission notice']).
citation(eu_reg_651_2014_art_5_2_c_ii, [label - 'Regulation (EU) No 651/2014 Art 5(2)(c)(ii) (guarantees on an accepted methodology)', ref - 'CELEX 02014R0651-20230701, unit 02014R0651-20230701-chapter-i#ch1_art5_p2_c_ii', verbatim - 'the methodology to calculate the gross grant equivalent of the guarantee has been accepted on the basis of the Commission Notice']).
citation(eu_reg_651_2014_art_5_2_d, [label - 'Regulation (EU) No 651/2014 Art 5(2)(d) (tax advantages with a cap)', ref - 'CELEX 02014R0651-20230701, unit 02014R0651-20230701-chapter-i#ch1_art5_p2_d', verbatim - 'aid in the form of tax advantages, where the measure provides for a cap ensuring that the applicable threshold is not exceeded']).
citation(eu_reg_651_2014_art_5_2_j, [label - 'Regulation (EU) No 651/2014 Art 5(2)(j) (repayable advances)', ref - 'CELEX 02014R0651-20230701, unit 02014R0651-20230701-chapter-i#ch1_art5_p2_j', verbatim - 'aid in the form of repayable advances, if the total nominal amount of the repayable advance does not exceed the thresholds applicable under this Regulation']).
citation(eu_reg_651_2014_art_5_2_k, [label - 'Regulation (EU) No 651/2014 Art 5(2)(k) (sale or lease of tangible assets below market rates)', ref - 'CELEX 02014R0651-20230701, unit 02014R0651-20230701-chapter-i#ch1_art5_p2_k', verbatim - 'aid in the form of the sale or the lease of tangible assets below market rates']).
citation(eu_reg_651_2014_art_6_1, [label - 'Regulation (EU) No 651/2014 Art 6(1) (incentive effect required)', ref - 'CELEX 02014R0651-20230701, unit 02014R0651-20230701-chapter-i#ch1_art6_p1', verbatim - 'This Regulation shall apply only to aid which has an incentive effect.']).
citation(eu_reg_651_2014_art_6_2, [label - 'Regulation (EU) No 651/2014 Art 6(2), lead-in (written application before work starts)', ref - 'CELEX 02014R0651-20230701, unit 02014R0651-20230701-chapter-i#ch1_art6_p2', verbatim - 'Aid shall be considered to have an incentive effect if the beneficiary has submitted a written application for the aid to the Member State concerned before work on the project or activity starts.']).
citation(eu_reg_651_2014_art_6_3, [label - 'Regulation (EU) No 651/2014 Art 6(3), lead-in (ad hoc aid to large enterprises)', ref - 'CELEX 02014R0651-20230701, unit 02014R0651-20230701-chapter-i#ch1_art6_p3', verbatim - 'Ad hoc aid granted to large enterprises shall be considered to have an incentive effect if, in addition to ensuring that the condition laid down in paragraph 2 is fulfilled']).
citation(eu_reg_651_2014_art_6_3_a, [label - 'Regulation (EU) No 651/2014 Art 6(3)(a) (regional investment aid counterfactual)', ref - 'CELEX 02014R0651-20230701, unit 02014R0651-20230701-chapter-i#ch1_art6_p3_a', verbatim - 'in the case of regional investment aid: that a project is carried out, which would not have been carried out in the area concerned']).
citation(eu_reg_651_2014_art_6_3_b, [label - 'Regulation (EU) No 651/2014 Art 6(3)(b), lead-in (material increases in all other cases)', ref - 'CELEX 02014R0651-20230701, unit 02014R0651-20230701-chapter-i#ch1_art6_p3_b', verbatim - 'in all other cases, that there is:']).
citation(eu_reg_651_2014_art_6_4, [label - 'Regulation (EU) No 651/2014 Art 6(4), lead-in (measures in the form of tax advantages)', ref - 'CELEX 02014R0651-20230701, unit 02014R0651-20230701-chapter-i#ch1_art6_p4', verbatim - 'By way of derogation from paragraphs 2 and 3, measures in the form of tax advantages shall be deemed to have an incentive effect if the following conditions are fulfilled:']).
citation(eu_reg_651_2014_art_6_4_a, [label - 'Regulation (EU) No 651/2014 Art 6(4)(a) (right to aid on objective criteria)', ref - 'CELEX 02014R0651-20230701, unit 02014R0651-20230701-chapter-i#ch1_art6_p4_a', verbatim - 'the measure establishes a right to aid in accordance with objective criteria and without further exercise of discretion by the Member State']).
citation(eu_reg_651_2014_art_6_4_b, [label - 'Regulation (EU) No 651/2014 Art 6(4)(b) (measure in force before work started)', ref - 'CELEX 02014R0651-20230701, unit 02014R0651-20230701-chapter-i#ch1_art6_p4_b', verbatim - 'the measure has been adopted and is in force before work on the aided project or activity has started']).
citation(eu_reg_651_2014_art_6_5, [label - 'Regulation (EU) No 651/2014 Art 6(5), lead-in (categories deemed to have an incentive effect)', ref - 'CELEX 02014R0651-20230701, unit 02014R0651-20230701-chapter-i#ch1_art6_p5', verbatim - 'By way of derogation from paragraphs 2, 3 and 4, the following categories of aid are not required to have or shall be deemed to have an incentive effect:']).
citation(eu_reg_651_2014_art_8_1, [label - 'Regulation (EU) No 651/2014 Art 8(1) (total amount of State aid)', ref - 'CELEX 02014R0651-20230701, unit 02014R0651-20230701-chapter-i#ch1_art8_p1', verbatim - 'the total amount of State aid for the aided activity or project or undertaking shall be taken into account']).
citation(eu_reg_651_2014_art_8_3, [label - 'Regulation (EU) No 651/2014 Art 8(3), lead-in (cumulation with other State aid)', ref - 'CELEX 02014R0651-20230701, unit 02014R0651-20230701-chapter-i#ch1_art8_p3', verbatim - 'Aid with identifiable eligible costs exempted by this Regulation may be cumulated with:']).
citation(eu_reg_651_2014_art_8_3_a, [label - 'Regulation (EU) No 651/2014 Art 8(3)(a) (different identifiable eligible costs)', ref - 'CELEX 02014R0651-20230701, unit 02014R0651-20230701-chapter-i#ch1_art8_p3_a', verbatim - 'any other State aid, as long as those measures concern different identifiable eligible costs']).
citation(eu_reg_651_2014_art_8_3_b, [label - 'Regulation (EU) No 651/2014 Art 8(3)(b) (same eligible costs, highest aid intensity)', ref - 'CELEX 02014R0651-20230701, unit 02014R0651-20230701-chapter-i#ch1_art8_p3_b', verbatim - 'only if such cumulation does not result in exceeding the highest aid intensity or aid amount applicable to this aid under this Regulation']).
citation(eu_reg_651_2014_art_8_5, [label - 'Regulation (EU) No 651/2014 Art 8(5) (cumulation with de minimis aid)', ref - 'CELEX 02014R0651-20230701, unit 02014R0651-20230701-chapter-i#ch1_art8_p5', verbatim - 'State aid exempted under this Regulation shall not be cumulated with any de minimis aid in respect of the same eligible costs if such cumulation would result in an aid intensity exceeding those laid down in Chapter III of this Regulation']).

citation_vocabulary(eu_reg_651_2014_art_1_2).
citation_vocabulary(eu_reg_651_2014_art_1_2_a).
citation_vocabulary(eu_reg_651_2014_art_1_2_b).
citation_vocabulary(eu_reg_651_2014_art_1_2_c).
citation_vocabulary(eu_reg_651_2014_art_1_2_d).
citation_vocabulary(eu_reg_651_2014_art_1_3).
citation_vocabulary(eu_reg_651_2014_art_1_3_a).
citation_vocabulary(eu_reg_651_2014_art_1_3_b).
citation_vocabulary(eu_reg_651_2014_art_1_3_c).
citation_vocabulary(eu_reg_651_2014_art_1_3_c_i).
citation_vocabulary(eu_reg_651_2014_art_1_3_c_ii).
citation_vocabulary(eu_reg_651_2014_art_1_3_d).
citation_vocabulary(eu_reg_651_2014_art_1_3_e).
citation_vocabulary(eu_reg_651_2014_art_1_t1).
citation_vocabulary(eu_reg_651_2014_art_1_4).
citation_vocabulary(eu_reg_651_2014_art_1_4_a).
citation_vocabulary(eu_reg_651_2014_art_1_4_b).
citation_vocabulary(eu_reg_651_2014_art_1_4_c).
citation_vocabulary(eu_reg_651_2014_art_1_5).
citation_vocabulary(eu_reg_651_2014_art_1_5_a).
citation_vocabulary(eu_reg_651_2014_art_1_5_b).
citation_vocabulary(eu_reg_651_2014_art_1_5_c).
citation_vocabulary(eu_reg_651_2014_art_2_18).
citation_vocabulary(eu_reg_651_2014_art_3_t1).
citation_vocabulary(eu_reg_651_2014_art_4_1).
citation_vocabulary(eu_reg_651_2014_art_4_1_c).
citation_vocabulary(eu_reg_651_2014_art_4_1_d).
citation_vocabulary(eu_reg_651_2014_art_4_1_e).
citation_vocabulary(eu_reg_651_2014_art_4_1_i).
citation_vocabulary(eu_reg_651_2014_art_4_1_i_i).
citation_vocabulary(eu_reg_651_2014_art_4_1_i_ii).
citation_vocabulary(eu_reg_651_2014_art_4_1_i_iii).
citation_vocabulary(eu_reg_651_2014_art_4_1_i_iv).
citation_vocabulary(eu_reg_651_2014_art_4_1_i_vi).
citation_vocabulary(eu_reg_651_2014_art_4_1_l).
citation_vocabulary(eu_reg_651_2014_art_4_1_m).
citation_vocabulary(eu_reg_651_2014_art_4_1_n).
citation_vocabulary(eu_reg_651_2014_art_4_1_s).
citation_vocabulary(eu_reg_651_2014_art_5_1).
citation_vocabulary(eu_reg_651_2014_art_5_2).
citation_vocabulary(eu_reg_651_2014_art_5_2_a).
citation_vocabulary(eu_reg_651_2014_art_5_2_b).
citation_vocabulary(eu_reg_651_2014_art_5_2_c).
citation_vocabulary(eu_reg_651_2014_art_5_2_c_i).
citation_vocabulary(eu_reg_651_2014_art_5_2_c_ii).
citation_vocabulary(eu_reg_651_2014_art_5_2_d).
citation_vocabulary(eu_reg_651_2014_art_5_2_j).
citation_vocabulary(eu_reg_651_2014_art_5_2_k).
citation_vocabulary(eu_reg_651_2014_art_6_1).
citation_vocabulary(eu_reg_651_2014_art_6_2).
citation_vocabulary(eu_reg_651_2014_art_6_3).
citation_vocabulary(eu_reg_651_2014_art_6_3_a).
citation_vocabulary(eu_reg_651_2014_art_6_3_b).
citation_vocabulary(eu_reg_651_2014_art_6_4).
citation_vocabulary(eu_reg_651_2014_art_6_4_a).
citation_vocabulary(eu_reg_651_2014_art_6_4_b).
citation_vocabulary(eu_reg_651_2014_art_6_5).
citation_vocabulary(eu_reg_651_2014_art_8_1).
citation_vocabulary(eu_reg_651_2014_art_8_3).
citation_vocabulary(eu_reg_651_2014_art_8_3_a).
citation_vocabulary(eu_reg_651_2014_art_8_3_b).
citation_vocabulary(eu_reg_651_2014_art_8_5).

scope_citations([cite(eu_reg_651_2014_art_1_2), cite(eu_reg_651_2014_art_1_2_a), cite(eu_reg_651_2014_art_1_2_b), cite(eu_reg_651_2014_art_1_2_c), cite(eu_reg_651_2014_art_1_2_d), cite(eu_reg_651_2014_art_1_3), cite(eu_reg_651_2014_art_1_3_a), cite(eu_reg_651_2014_art_1_3_b), cite(eu_reg_651_2014_art_1_3_c), cite(eu_reg_651_2014_art_1_3_c_i), cite(eu_reg_651_2014_art_1_3_c_ii), cite(eu_reg_651_2014_art_1_3_d), cite(eu_reg_651_2014_art_1_3_e), cite(eu_reg_651_2014_art_1_t1), cite(eu_reg_651_2014_art_1_4), cite(eu_reg_651_2014_art_1_4_a), cite(eu_reg_651_2014_art_1_4_b), cite(eu_reg_651_2014_art_1_4_c), cite(eu_reg_651_2014_art_1_5), cite(eu_reg_651_2014_art_1_5_a), cite(eu_reg_651_2014_art_1_5_b), cite(eu_reg_651_2014_art_1_5_c), cite(eu_reg_651_2014_art_2_18)]).

transparency_citations([cite(eu_reg_651_2014_art_5_1), cite(eu_reg_651_2014_art_5_2), cite(eu_reg_651_2014_art_5_2_a), cite(eu_reg_651_2014_art_5_2_b), cite(eu_reg_651_2014_art_5_2_c), cite(eu_reg_651_2014_art_5_2_c_i), cite(eu_reg_651_2014_art_5_2_c_ii), cite(eu_reg_651_2014_art_5_2_d), cite(eu_reg_651_2014_art_5_2_j), cite(eu_reg_651_2014_art_5_2_k)]).

incentive_citations([cite(eu_reg_651_2014_art_6_1), cite(eu_reg_651_2014_art_6_2), cite(eu_reg_651_2014_art_6_3), cite(eu_reg_651_2014_art_6_3_a), cite(eu_reg_651_2014_art_6_3_b), cite(eu_reg_651_2014_art_6_4), cite(eu_reg_651_2014_art_6_4_a), cite(eu_reg_651_2014_art_6_4_b), cite(eu_reg_651_2014_art_6_5)]).

chapter_i_met_citations([cite(eu_reg_651_2014_art_3_t1)]).

chapter_i_not_met_citations([cite(eu_reg_651_2014_art_3_t1), cite(eu_reg_651_2014_art_1_2), cite(eu_reg_651_2014_art_1_3), cite(eu_reg_651_2014_art_1_4), cite(eu_reg_651_2014_art_1_5), cite(eu_reg_651_2014_art_4_1), cite(eu_reg_651_2014_art_5_1), cite(eu_reg_651_2014_art_6_1), cite(eu_reg_651_2014_art_8_3), cite(eu_reg_651_2014_art_8_5)]).

threshold_row_citation(sme_investment, cite(eu_reg_651_2014_art_4_1_c)).
threshold_row_citation(sme_consultancy, cite(eu_reg_651_2014_art_4_1_d)).
threshold_row_citation(sme_fair_participation, cite(eu_reg_651_2014_art_4_1_e)).
threshold_row_citation(fundamental_research, cite(eu_reg_651_2014_art_4_1_i_i)).
threshold_row_citation(industrial_research, cite(eu_reg_651_2014_art_4_1_i_ii)).
threshold_row_citation(experimental_development, cite(eu_reg_651_2014_art_4_1_i_iii)).
threshold_row_citation(feasibility_study, cite(eu_reg_651_2014_art_4_1_i_vi)).
threshold_row_citation(sme_innovation, cite(eu_reg_651_2014_art_4_1_l)).
threshold_row_citation(process_and_organisational_innovation, cite(eu_reg_651_2014_art_4_1_m)).
threshold_row_citation(training, cite(eu_reg_651_2014_art_4_1_n)).
threshold_row_citation(environmental_investment, cite(eu_reg_651_2014_art_4_1_s)).

cited_key_recorded(cite(Key)) :-
    citation_vocabulary(Key),
    implements(Key).

test(every_vocabulary_key_is_recorded) :-
    findall(Key, citation_vocabulary(Key), Keys),
    maplist(implements, Keys).
test(the_vocabulary_has_sixty_two_keys) :-
    findall(Key, citation_vocabulary(Key), Keys),
    length(Keys, 62).
test(the_scope_list_is_recorded) :-
    scope_citations(Citations),
    length(Citations, 23),
    maplist(cited_key_recorded, Citations).
test(the_transparency_list_is_recorded) :-
    transparency_citations(Citations),
    length(Citations, 10),
    maplist(cited_key_recorded, Citations).
test(the_incentive_list_is_recorded) :-
    incentive_citations(Citations),
    length(Citations, 9),
    maplist(cited_key_recorded, Citations).
test(the_not_met_list_is_recorded) :-
    chapter_i_not_met_citations(Citations),
    length(Citations, 10),
    maplist(cited_key_recorded, Citations).
test(every_threshold_row_is_recorded) :-
    findall(Citation, threshold_row_citation(_, Citation), Citations),
    length(Citations, 11),
    maplist(cited_key_recorded, Citations).
test(a_definition_key_is_recorded) :-
    implements(eu_reg_651_2014_art_2_24).

test(a_definition_key_is_not_returnable, fail) :-
    citation_vocabulary(eu_reg_651_2014_art_2_24).
test(an_unrecorded_key_does_not_implement, fail) :-
    implements(eu_reg_651_2014_art_9_4).
