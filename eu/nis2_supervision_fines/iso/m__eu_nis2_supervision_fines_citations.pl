% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_nis2_supervision_fines_citations, [citation/2, citation_vocabulary/1, implements/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).

implements(Key) :-
    citation(Key, _).

citation(eu_dir_2022_2555_art_32_2, [label - 'Directive (EU) 2022/2555 Art 32(2), first subparagraph (lead-in, the words at least)', ref - 'https://eur-lex.europa.eu/eli/dir/2022/2555/oj (OJ L 333, 27.12.2022), Art 32(2)', verbatim - 'when exercising their supervisory tasks in relation to essential entities, have the power to subject those entities at least to']).
citation(eu_dir_2022_2555_art_32_2_a, [label - 'Directive (EU) 2022/2555 Art 32(2)(a)', ref - 'https://eur-lex.europa.eu/eli/dir/2022/2555/oj (OJ L 333, 27.12.2022), Art 32(2), point (a)', verbatim - 'on-site inspections and off-site supervision, including random checks conducted by trained professionals']).
citation(eu_dir_2022_2555_art_32_2_b, [label - 'Directive (EU) 2022/2555 Art 32(2)(b)', ref - 'https://eur-lex.europa.eu/eli/dir/2022/2555/oj (OJ L 333, 27.12.2022), Art 32(2), point (b)', verbatim - 'regular and targeted security audits carried out by an independent body or a competent authority']).
citation(eu_dir_2022_2555_art_32_2_c, [label - 'Directive (EU) 2022/2555 Art 32(2)(c)', ref - 'https://eur-lex.europa.eu/eli/dir/2022/2555/oj (OJ L 333, 27.12.2022), Art 32(2), point (c)', verbatim - 'ad hoc audits, including where justified on the ground of a significant incident or an infringement of this Directive by the essential entity']).
citation(eu_dir_2022_2555_art_32_2_d, [label - 'Directive (EU) 2022/2555 Art 32(2)(d)', ref - 'https://eur-lex.europa.eu/eli/dir/2022/2555/oj (OJ L 333, 27.12.2022), Art 32(2), point (d)', verbatim - 'security scans based on objective, non-discriminatory, fair and transparent risk assessment criteria']).
citation(eu_dir_2022_2555_art_32_2_e, [label - 'Directive (EU) 2022/2555 Art 32(2)(e)', ref - 'https://eur-lex.europa.eu/eli/dir/2022/2555/oj (OJ L 333, 27.12.2022), Art 32(2), point (e)', verbatim - 'requests for information necessary to assess the cybersecurity risk-management measures adopted by the entity concerned']).
citation(eu_dir_2022_2555_art_32_2_f, [label - 'Directive (EU) 2022/2555 Art 32(2)(f)', ref - 'https://eur-lex.europa.eu/eli/dir/2022/2555/oj (OJ L 333, 27.12.2022), Art 32(2), point (f)', verbatim - 'requests to access data, documents and information necessary to carry out their supervisory tasks']).
citation(eu_dir_2022_2555_art_32_2_g, [label - 'Directive (EU) 2022/2555 Art 32(2)(g)', ref - 'https://eur-lex.europa.eu/eli/dir/2022/2555/oj (OJ L 333, 27.12.2022), Art 32(2), point (g)', verbatim - 'requests for evidence of implementation of cybersecurity policies, such as the results of security audits carried out by a qualified auditor']).
citation(eu_dir_2022_2555_art_32_4, [label - 'Directive (EU) 2022/2555 Art 32(4) (lead-in, the words at least)', ref - 'https://eur-lex.europa.eu/eli/dir/2022/2555/oj (OJ L 333, 27.12.2022), Art 32(4)', verbatim - 'when exercising their enforcement powers in relation to essential entities, have the power at least to']).
citation(eu_dir_2022_2555_art_32_4_a, [label - 'Directive (EU) 2022/2555 Art 32(4)(a)', ref - 'https://eur-lex.europa.eu/eli/dir/2022/2555/oj (OJ L 333, 27.12.2022), Art 32(4), point (a)', verbatim - 'issue warnings about infringements of this Directive by the entities concerned']).
citation(eu_dir_2022_2555_art_32_4_b, [label - 'Directive (EU) 2022/2555 Art 32(4)(b)', ref - 'https://eur-lex.europa.eu/eli/dir/2022/2555/oj (OJ L 333, 27.12.2022), Art 32(4), point (b)', verbatim - 'adopt binding instructions, including with regard to measures necessary to prevent or remedy an incident']).
citation(eu_dir_2022_2555_art_32_4_c, [label - 'Directive (EU) 2022/2555 Art 32(4)(c)', ref - 'https://eur-lex.europa.eu/eli/dir/2022/2555/oj (OJ L 333, 27.12.2022), Art 32(4), point (c)', verbatim - 'order the entities concerned to cease conduct that infringes this Directive and desist from repeating that conduct']).
citation(eu_dir_2022_2555_art_32_4_d, [label - 'Directive (EU) 2022/2555 Art 32(4)(d)', ref - 'https://eur-lex.europa.eu/eli/dir/2022/2555/oj (OJ L 333, 27.12.2022), Art 32(4), point (d)', verbatim - 'order the entities concerned to ensure that their cybersecurity risk-management measures comply with Article 21 or to fulfil the reporting obligations laid down in Article 23']).
citation(eu_dir_2022_2555_art_32_4_e, [label - 'Directive (EU) 2022/2555 Art 32(4)(e)', ref - 'https://eur-lex.europa.eu/eli/dir/2022/2555/oj (OJ L 333, 27.12.2022), Art 32(4), point (e)', verbatim - 'order the entities concerned to inform the natural or legal persons with regard to which they provide services or carry out activities which are potentially affected by a significant cyber threat']).
citation(eu_dir_2022_2555_art_32_4_f, [label - 'Directive (EU) 2022/2555 Art 32(4)(f)', ref - 'https://eur-lex.europa.eu/eli/dir/2022/2555/oj (OJ L 333, 27.12.2022), Art 32(4), point (f)', verbatim - 'order the entities concerned to implement the recommendations provided as a result of a security audit within a reasonable deadline']).
citation(eu_dir_2022_2555_art_32_4_g, [label - 'Directive (EU) 2022/2555 Art 32(4)(g)', ref - 'https://eur-lex.europa.eu/eli/dir/2022/2555/oj (OJ L 333, 27.12.2022), Art 32(4), point (g)', verbatim - 'designate a monitoring officer with well-defined tasks for a determined period of time to oversee the compliance of the entities concerned with Articles 21 and 23']).
citation(eu_dir_2022_2555_art_32_4_h, [label - 'Directive (EU) 2022/2555 Art 32(4)(h)', ref - 'https://eur-lex.europa.eu/eli/dir/2022/2555/oj (OJ L 333, 27.12.2022), Art 32(4), point (h)', verbatim - 'order the entities concerned to make public aspects of infringements of this Directive in a specified manner']).
citation(eu_dir_2022_2555_art_32_4_i, [label - 'Directive (EU) 2022/2555 Art 32(4)(i)', ref - 'https://eur-lex.europa.eu/eli/dir/2022/2555/oj (OJ L 333, 27.12.2022), Art 32(4), point (i)', verbatim - 'in addition to any of the measures referred to in points (a) to (h) of this paragraph']).
citation(eu_dir_2022_2555_art_32_5, [label - 'Directive (EU) 2022/2555 Art 32(5) (conditions of the further powers; public administration entities excluded)', ref - 'https://eur-lex.europa.eu/eli/dir/2022/2555/oj (OJ L 333, 27.12.2022), Art 32(5)', verbatim - 'Where enforcement measures adopted pursuant to paragraph 4, points (a) to (d) and (f), are ineffective']).
citation(eu_dir_2022_2555_art_32_5_a, [label - 'Directive (EU) 2022/2555 Art 32(5)(a)', ref - 'https://eur-lex.europa.eu/eli/dir/2022/2555/oj (OJ L 333, 27.12.2022), Art 32(5), point (a)', verbatim - 'suspend temporarily, or request a certification or authorisation body, or a court or tribunal, in accordance with national law, to suspend temporarily a certification or authorisation']).
citation(eu_dir_2022_2555_art_32_5_b, [label - 'Directive (EU) 2022/2555 Art 32(5)(b)', ref - 'https://eur-lex.europa.eu/eli/dir/2022/2555/oj (OJ L 333, 27.12.2022), Art 32(5), point (b)', verbatim - 'prohibit temporarily any natural person who is responsible for discharging managerial responsibilities at chief executive officer or legal representative level in the essential entity from exercising managerial functions in that entity']).
citation(eu_dir_2022_2555_art_33_2, [label - 'Directive (EU) 2022/2555 Art 33(2), first subparagraph (lead-in, the words at least)', ref - 'https://eur-lex.europa.eu/eli/dir/2022/2555/oj (OJ L 333, 27.12.2022), Art 33(2)', verbatim - 'when exercising their supervisory tasks in relation to important entities, have the power to subject those entities at least to']).
citation(eu_dir_2022_2555_art_33_2_a, [label - 'Directive (EU) 2022/2555 Art 33(2)(a)', ref - 'https://eur-lex.europa.eu/eli/dir/2022/2555/oj (OJ L 333, 27.12.2022), Art 33(2), point (a)', verbatim - 'on-site inspections and off-site ex post supervision conducted by trained professionals']).
citation(eu_dir_2022_2555_art_33_2_b, [label - 'Directive (EU) 2022/2555 Art 33(2)(b)', ref - 'https://eur-lex.europa.eu/eli/dir/2022/2555/oj (OJ L 333, 27.12.2022), Art 33(2), point (b)', verbatim - 'targeted security audits carried out by an independent body or a competent authority']).
citation(eu_dir_2022_2555_art_33_2_c, [label - 'Directive (EU) 2022/2555 Art 33(2)(c)', ref - 'https://eur-lex.europa.eu/eli/dir/2022/2555/oj (OJ L 333, 27.12.2022), Art 33(2), point (c)', verbatim - 'security scans based on objective, non-discriminatory, fair and transparent risk assessment criteria, where necessary with the cooperation of the entity concerned']).
citation(eu_dir_2022_2555_art_33_2_d, [label - 'Directive (EU) 2022/2555 Art 33(2)(d)', ref - 'https://eur-lex.europa.eu/eli/dir/2022/2555/oj (OJ L 333, 27.12.2022), Art 33(2), point (d)', verbatim - 'requests for information necessary to assess, ex post, the cybersecurity risk-management measures adopted by the entity concerned']).
citation(eu_dir_2022_2555_art_33_2_e, [label - 'Directive (EU) 2022/2555 Art 33(2)(e)', ref - 'https://eur-lex.europa.eu/eli/dir/2022/2555/oj (OJ L 333, 27.12.2022), Art 33(2), point (e)', verbatim - 'requests to access data, documents and information necessary to carry out their supervisory tasks']).
citation(eu_dir_2022_2555_art_33_2_f, [label - 'Directive (EU) 2022/2555 Art 33(2)(f)', ref - 'https://eur-lex.europa.eu/eli/dir/2022/2555/oj (OJ L 333, 27.12.2022), Art 33(2), point (f)', verbatim - 'requests for evidence of implementation of cybersecurity policies, such as the results of security audits carried out by a qualified auditor']).
citation(eu_dir_2022_2555_art_33_4, [label - 'Directive (EU) 2022/2555 Art 33(4) (lead-in, the words at least)', ref - 'https://eur-lex.europa.eu/eli/dir/2022/2555/oj (OJ L 333, 27.12.2022), Art 33(4)', verbatim - 'when exercising their enforcement powers in relation to important entities, have the power at least to']).
citation(eu_dir_2022_2555_art_33_4_a, [label - 'Directive (EU) 2022/2555 Art 33(4)(a)', ref - 'https://eur-lex.europa.eu/eli/dir/2022/2555/oj (OJ L 333, 27.12.2022), Art 33(4), point (a)', verbatim - 'issue warnings about infringements of this Directive by the entities concerned']).
citation(eu_dir_2022_2555_art_33_4_b, [label - 'Directive (EU) 2022/2555 Art 33(4)(b)', ref - 'https://eur-lex.europa.eu/eli/dir/2022/2555/oj (OJ L 333, 27.12.2022), Art 33(4), point (b)', verbatim - 'adopt binding instructions or an order requiring the entities concerned to remedy the deficiencies identified or the infringement of this Directive']).
citation(eu_dir_2022_2555_art_33_4_c, [label - 'Directive (EU) 2022/2555 Art 33(4)(c)', ref - 'https://eur-lex.europa.eu/eli/dir/2022/2555/oj (OJ L 333, 27.12.2022), Art 33(4), point (c)', verbatim - 'order the entities concerned to cease conduct that infringes this Directive and desist from repeating that conduct']).
citation(eu_dir_2022_2555_art_33_4_d, [label - 'Directive (EU) 2022/2555 Art 33(4)(d)', ref - 'https://eur-lex.europa.eu/eli/dir/2022/2555/oj (OJ L 333, 27.12.2022), Art 33(4), point (d)', verbatim - 'order the entities concerned to ensure that their cybersecurity risk-management measures comply with Article 21 or to fulfil the reporting obligations laid down in Article 23']).
citation(eu_dir_2022_2555_art_33_4_e, [label - 'Directive (EU) 2022/2555 Art 33(4)(e)', ref - 'https://eur-lex.europa.eu/eli/dir/2022/2555/oj (OJ L 333, 27.12.2022), Art 33(4), point (e)', verbatim - 'order the entities concerned to inform the natural or legal persons with regard to which they provide services or carry out activities which are potentially affected by a significant cyber threat']).
citation(eu_dir_2022_2555_art_33_4_f, [label - 'Directive (EU) 2022/2555 Art 33(4)(f)', ref - 'https://eur-lex.europa.eu/eli/dir/2022/2555/oj (OJ L 333, 27.12.2022), Art 33(4), point (f)', verbatim - 'order the entities concerned to implement the recommendations provided as a result of a security audit within a reasonable deadline']).
citation(eu_dir_2022_2555_art_33_4_g, [label - 'Directive (EU) 2022/2555 Art 33(4)(g)', ref - 'https://eur-lex.europa.eu/eli/dir/2022/2555/oj (OJ L 333, 27.12.2022), Art 33(4), point (g)', verbatim - 'order the entities concerned to make public aspects of infringements of this Directive in a specified manner']).
citation(eu_dir_2022_2555_art_33_4_h, [label - 'Directive (EU) 2022/2555 Art 33(4)(h)', ref - 'https://eur-lex.europa.eu/eli/dir/2022/2555/oj (OJ L 333, 27.12.2022), Art 33(4), point (h)', verbatim - 'in addition to any of the measures referred to in points (a) to (g) of this paragraph']).
citation(eu_dir_2022_2555_art_34_4, [label - 'Directive (EU) 2022/2555 Art 34(4) (least national maximum fine, essential entities: EUR 10 000 000 or 2 % of turnover, whichever is higher)', ref - 'https://eur-lex.europa.eu/eli/dir/2022/2555/oj (OJ L 333, 27.12.2022), Art 34(4)', verbatim - 'of the total worldwide annual turnover in the preceding financial year of the undertaking to which the essential entity belongs, whichever is higher']).
citation(eu_dir_2022_2555_art_34_5, [label - 'Directive (EU) 2022/2555 Art 34(5) (least national maximum fine, important entities: EUR 7 000 000 or 1,4 % of turnover, whichever is higher)', ref - 'https://eur-lex.europa.eu/eli/dir/2022/2555/oj (OJ L 333, 27.12.2022), Art 34(5)', verbatim - 'of the total worldwide annual turnover in the preceding financial year of the undertaking to which the important entity belongs, whichever is higher']).
citation(eu_dir_2022_2555_art_35_1, [label - 'Directive (EU) 2022/2555 Art 35(1) (duty to inform the GDPR supervisory authorities)', ref - 'https://eur-lex.europa.eu/eli/dir/2022/2555/oj (OJ L 333, 27.12.2022), Art 35(1)', verbatim - 'they shall, without undue delay, inform the supervisory authorities as referred to in Article 55 or 56 of that Regulation']).
citation(eu_dir_2022_2555_art_35_2, [label - 'Directive (EU) 2022/2555 Art 35(2) (a GDPR Art 58(2)(i) fine for the same conduct bars the Art 34 fine)', ref - 'https://eur-lex.europa.eu/eli/dir/2022/2555/oj (OJ L 333, 27.12.2022), Art 35(2)', verbatim - 'the competent authorities shall not impose an administrative fine pursuant to Article 34 of this Directive for an infringement referred to in paragraph 1 of this Article arising from the same conduct']).
citation(eu_dir_2022_2555_art_35_3, [label - 'Directive (EU) 2022/2555 Art 35(3) (informing the supervisory authority in the own Member State)', ref - 'https://eur-lex.europa.eu/eli/dir/2022/2555/oj (OJ L 333, 27.12.2022), Art 35(3)', verbatim - 'the competent authority shall inform the supervisory authority established in its own Member State of the potential data breach referred to in paragraph 1']).

citation_vocabulary(eu_dir_2022_2555_art_32_2_a).
citation_vocabulary(eu_dir_2022_2555_art_32_2_b).
citation_vocabulary(eu_dir_2022_2555_art_32_2_c).
citation_vocabulary(eu_dir_2022_2555_art_32_2_d).
citation_vocabulary(eu_dir_2022_2555_art_32_2_e).
citation_vocabulary(eu_dir_2022_2555_art_32_2_f).
citation_vocabulary(eu_dir_2022_2555_art_32_2_g).
citation_vocabulary(eu_dir_2022_2555_art_32_4_a).
citation_vocabulary(eu_dir_2022_2555_art_32_4_b).
citation_vocabulary(eu_dir_2022_2555_art_32_4_c).
citation_vocabulary(eu_dir_2022_2555_art_32_4_d).
citation_vocabulary(eu_dir_2022_2555_art_32_4_e).
citation_vocabulary(eu_dir_2022_2555_art_32_4_f).
citation_vocabulary(eu_dir_2022_2555_art_32_4_g).
citation_vocabulary(eu_dir_2022_2555_art_32_4_h).
citation_vocabulary(eu_dir_2022_2555_art_32_4_i).
citation_vocabulary(eu_dir_2022_2555_art_32_5).
citation_vocabulary(eu_dir_2022_2555_art_32_5_a).
citation_vocabulary(eu_dir_2022_2555_art_32_5_b).
citation_vocabulary(eu_dir_2022_2555_art_33_2_a).
citation_vocabulary(eu_dir_2022_2555_art_33_2_b).
citation_vocabulary(eu_dir_2022_2555_art_33_2_c).
citation_vocabulary(eu_dir_2022_2555_art_33_2_d).
citation_vocabulary(eu_dir_2022_2555_art_33_2_e).
citation_vocabulary(eu_dir_2022_2555_art_33_2_f).
citation_vocabulary(eu_dir_2022_2555_art_33_4_a).
citation_vocabulary(eu_dir_2022_2555_art_33_4_b).
citation_vocabulary(eu_dir_2022_2555_art_33_4_c).
citation_vocabulary(eu_dir_2022_2555_art_33_4_d).
citation_vocabulary(eu_dir_2022_2555_art_33_4_e).
citation_vocabulary(eu_dir_2022_2555_art_33_4_f).
citation_vocabulary(eu_dir_2022_2555_art_33_4_g).
citation_vocabulary(eu_dir_2022_2555_art_33_4_h).
citation_vocabulary(eu_dir_2022_2555_art_34_4).
citation_vocabulary(eu_dir_2022_2555_art_34_5).
citation_vocabulary(eu_dir_2022_2555_art_35_1).
citation_vocabulary(eu_dir_2022_2555_art_35_2).
citation_vocabulary(eu_dir_2022_2555_art_35_3).

test(every_vocabulary_key_is_recorded) :-
    findall(Key, citation_vocabulary(Key), Keys),
    length(Keys, 38),
    maplist(implements, Keys).
test(a_recorded_key_is_implemented) :-
    implements(eu_dir_2022_2555_art_34_4).

test(an_unrecorded_key_is_not_implemented, fail) :-
    implements(eu_dir_2022_2555_art_34_6).
