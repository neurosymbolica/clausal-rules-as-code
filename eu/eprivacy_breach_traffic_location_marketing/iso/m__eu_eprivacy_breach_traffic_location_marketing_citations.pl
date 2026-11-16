% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_eprivacy_breach_traffic_location_marketing_citations, [citation/2, implements/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).

citation(eu_dir_2002_58_art_2_b, [label - 'Directive 2002/58/EC (ePrivacy Directive) Art 2, second paragraph, point (b), definition of traffic data', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:02002L0058-20091219 (unit 02002L0058-20091219#art2_b)', verbatim - 'means any data processed for the purpose of the conveyance of a communication on an electronic communications network or for the billing thereof']).
citation(eu_dir_2002_58_art_2_c, [label - 'Directive 2002/58/EC (ePrivacy Directive) Art 2, second paragraph, point (c), definition of location data', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:02002L0058-20091219 (unit 02002L0058-20091219#art2_c)', verbatim - 'means any data processed in an electronic communications network or by an electronic communications service, indicating the geographic position of the terminal equipment of a user of a publicly available electronic communications service']).
citation(eu_dir_2002_58_art_2_f, [label - 'Directive 2002/58/EC (ePrivacy Directive) Art 2, second paragraph, point (f), definition of consent', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:02002L0058-20091219 (unit 02002L0058-20091219#art2_f)', verbatim - 'by a user or subscriber corresponds to the data subject']).
citation(eu_dir_2002_58_art_2_g, [label - 'Directive 2002/58/EC (ePrivacy Directive) Art 2, second paragraph, point (g), definition of value added service', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:02002L0058-20091219 (unit 02002L0058-20091219#art2_g)', verbatim - 'means any service which requires the processing of traffic data or location data other than traffic data beyond what is necessary for the transmission of a communication or the billing thereof']).
citation(eu_dir_2002_58_art_2_h, [label - 'Directive 2002/58/EC (ePrivacy Directive) Art 2, second paragraph, point (h), definition of electronic mail', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:02002L0058-20091219 (unit 02002L0058-20091219#art2_h)', verbatim - 'means any text, voice, sound or image message sent over a public communications network which can be stored in the network or in the recipient']).
citation(eu_dir_2002_58_art_2_i, [label - 'Directive 2002/58/EC (ePrivacy Directive) Art 2, second paragraph, point (i), definition of personal data breach', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:02002L0058-20091219 (unit 02002L0058-20091219#art2_i)', verbatim - 'means a breach of security leading to the accidental or unlawful destruction, loss, alteration, unauthorised disclosure of, or access to, personal data transmitted, stored or otherwise processed in connection with the provision of a publicly available electronic communications service in the Community']).
citation(eu_dir_2002_58_art_4_3, [label - 'Directive 2002/58/EC (ePrivacy Directive) Art 4(3), notification of a personal data breach to the competent national authority and to the subscriber or individual', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:02002L0058-20091219 (unit 02002L0058-20091219#art4_p3)', verbatim - 'In the case of a personal data breach, the provider of publicly available electronic communications services shall, without undue delay, notify the personal data breach to the competent national authority.']).
citation(eu_dir_2002_58_art_6_1, [label - 'Directive 2002/58/EC (ePrivacy Directive) Art 6(1), erasure or anonymisation of traffic data no longer needed for transmission', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:02002L0058-20091219 (unit 02002L0058-20091219#art6_p1)', verbatim - 'Traffic data relating to subscribers and users processed and stored by the provider of a public communications network or publicly available electronic communications service must be erased or made anonymous when it is no longer needed for the purpose of the transmission of a communication']).
citation(eu_dir_2002_58_art_6_2, [label - 'Directive 2002/58/EC (ePrivacy Directive) Art 6(2), traffic data for subscriber billing and interconnection payments', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:02002L0058-20091219 (unit 02002L0058-20091219#art6_p2)', verbatim - 'Traffic data necessary for the purposes of subscriber billing and interconnection payments may be processed. Such processing is permissible only up to the end of the period during which the bill may lawfully be challenged or payment pursued.']).
citation(eu_dir_2002_58_art_6_3, [label - 'Directive 2002/58/EC (ePrivacy Directive) Art 6(3), traffic data for marketing electronic communications services or value added services with prior consent', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:02002L0058-20091219 (unit 02002L0058-20091219#art6_p3)', verbatim - 'For the purpose of marketing electronic communications services or for the provision of value added services, the provider of a publicly available electronic communications service may process the data referred to in paragraph 1 to the extent and for the duration necessary for such services or marketing, if the subscriber or user to whom the data relate has given his or her prior consent.']).
citation(eu_dir_2002_58_art_9_1, [label - 'Directive 2002/58/EC (ePrivacy Directive) Art 9(1), first sentence, processing of location data other than traffic data when made anonymous or with consent', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:02002L0058-20091219 (unit 02002L0058-20091219#art9_p1)', verbatim - 'such data may only be processed when they are made anonymous, or with the consent of the users or subscribers to the extent and for the duration necessary for the provision of a value added service.']).
citation(eu_dir_2002_58_art_9_2, [label - 'Directive 2002/58/EC (ePrivacy Directive) Art 9(2), temporary refusal of the processing of location data other than traffic data', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:02002L0058-20091219 (unit 02002L0058-20091219#art9_p2)', verbatim - 'the user or subscriber must continue to have the possibility, using a simple means and free of charge, of temporarily refusing the processing of such data for each connection to the network or for each transmission of a communication.']).
citation(eu_dir_2002_58_art_13_1, [label - 'Directive 2002/58/EC (ePrivacy Directive) Art 13(1), prior consent for direct marketing by automatic calling machines, fax or electronic mail', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:02002L0058-20091219 (unit 02002L0058-20091219#art13_p1)', verbatim - 'The use of automated calling and communication systems without human intervention (automatic calling machines), facsimile machines (fax) or electronic mail for the purposes of direct marketing may be allowed only in respect of subscribers or users who have given their prior consent.']).
citation(eu_dir_2002_58_art_13_2, [label - 'Directive 2002/58/EC (ePrivacy Directive) Art 13(2), the customer exception for electronic mail marketing of own similar products or services', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:02002L0058-20091219 (unit 02002L0058-20091219#art13_p2)', verbatim - 'the same natural or legal person may use these electronic contact details for direct marketing of its own similar products or services provided that customers clearly and distinctly are given the opportunity to object, free of charge and in an easy manner, to such use of electronic contact details at the time of their collection and on the occasion of each message in case the customer has not initially refused such use.']).
citation(eu_dir_2002_58_art_13_3, [label - 'Directive 2002/58/EC (ePrivacy Directive) Art 13(3), other unsolicited direct marketing communications, choice of opt-in or opt-out left to national legislation', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:02002L0058-20091219 (unit 02002L0058-20091219#art13_p3)', verbatim - 'the choice between these options to be determined by national legislation, taking into account that both options must be free of charge for the subscriber or user.']).
citation(eu_dir_2002_58_art_13_4, [label - 'Directive 2002/58/EC (ePrivacy Directive) Art 13(4), prohibited practices of direct marketing electronic mail', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:02002L0058-20091219 (unit 02002L0058-20091219#art13_p4)', verbatim - 'In any event, the practice of sending electronic mail for the purposes of direct marketing which disguise or conceal the identity of the sender on whose behalf the communication is made, which contravene Article 6 of Directive 2000/31/EC, which do not have a valid address to which the recipient may send a request that such communications cease or which encourage recipients to visit websites that contravene that Article shall be prohibited.']).
citation(eu_dir_2002_58_art_13_5, [label - 'Directive 2002/58/EC (ePrivacy Directive) Art 13(5), paragraphs 1 and 3 apply to subscribers who are natural persons; other subscribers protected under national legislation', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:02002L0058-20091219 (unit 02002L0058-20091219#art13_p5)', verbatim - 'Paragraphs 1 and 3 shall apply to subscribers who are natural persons.']).

implements(Key) :-
    citation(Key, _).

test(every_answer_key_is_recorded) :-
    implements(eu_dir_2002_58_art_4_3),
    implements(eu_dir_2002_58_art_6_1),
    implements(eu_dir_2002_58_art_6_2),
    implements(eu_dir_2002_58_art_6_3),
    implements(eu_dir_2002_58_art_9_1),
    implements(eu_dir_2002_58_art_13_1),
    implements(eu_dir_2002_58_art_13_2),
    implements(eu_dir_2002_58_art_13_3),
    implements(eu_dir_2002_58_art_13_4),
    implements(eu_dir_2002_58_art_13_5).
test(every_referral_and_marker_key_is_recorded) :-
    implements(eu_dir_2002_58_art_2_b),
    implements(eu_dir_2002_58_art_2_c),
    implements(eu_dir_2002_58_art_2_f),
    implements(eu_dir_2002_58_art_2_g),
    implements(eu_dir_2002_58_art_2_h),
    implements(eu_dir_2002_58_art_2_i),
    implements(eu_dir_2002_58_art_9_2).
test(seventeen_keys_each_once) :-
    findall(Key, citation(Key, _), Keys),
    length(Keys, 17),
    sort(Keys, SortedKeys),
    length(SortedKeys, 17).

test(an_unrecorded_key_fails, fail) :-
    implements(eu_dir_2002_58_art_13_6).
