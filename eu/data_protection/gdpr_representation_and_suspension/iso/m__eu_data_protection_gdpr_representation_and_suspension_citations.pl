% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_representation_and_suspension_citations, [citation/2, implements/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).

citation(eu_reg_2016_679_art_80_1, [label - 'Regulation (EU) 2016/679 (GDPR) Art 80(1), representation of a data subject by a mandated body', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:02016R0679-20160504#parag_080.001', verbatim - 'The data subject shall have the right to mandate a not-for-profit body, organisation or association which has been properly constituted in accordance with the law of a Member State']).
citation(eu_reg_2016_679_art_80_2, [label - 'Regulation (EU) 2016/679 (GDPR) Art 80(2), action of a body independently of a data subject mandate', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:02016R0679-20160504#parag_080.002', verbatim - 'Member States may provide that any body, organisation or association referred to in paragraph 1 of this Article, independently of a data subject']).
citation(eu_reg_2016_679_art_81_1, [label - 'Regulation (EU) 2016/679 (GDPR) Art 81(1), duty of a competent court to contact the court in another Member State', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:02016R0679-20160504#parag_081.001', verbatim - 'it shall contact that court in the other Member State to confirm the existence of such proceedings']).
citation(eu_reg_2016_679_art_81_2, [label - 'Regulation (EU) 2016/679 (GDPR) Art 81(2), option to suspend proceedings', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:02016R0679-20160504#parag_081.002', verbatim - 'any competent court other than the court first seized may suspend its proceedings']).
citation(eu_reg_2016_679_art_81_3, [label - 'Regulation (EU) 2016/679 (GDPR) Art 81(3), option to decline jurisdiction in favour of the court first seized', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:02016R0679-20160504#parag_081.003', verbatim - 'any court other than the court first seized may also, on the application of one of the parties, decline jurisdiction if the court first seized has jurisdiction over the actions in question and its law permits the consolidation thereof']).
citation(member_state_law_on_mandated_compensation_claims_statement, [label - 'Regulation (EU) 2016/679 (GDPR) Art 80(1), the words where provided for by Member State law (mandated exercise of the Art 82 right to compensation)', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:02016R0679-20160504#parag_080.001', verbatim - 'to exercise the right to receive compensation referred to in Article 82 on his or her behalf where provided for by Member State law']).
citation(member_state_law_on_action_without_mandate_statement, [label - 'Regulation (EU) 2016/679 (GDPR) Art 80(2), the words Member States may provide (action of a body independently of a mandate)', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:02016R0679-20160504#parag_080.002', verbatim - 'Member States may provide that any body, organisation or association referred to in paragraph 1 of this Article']).
citation(court_first_seized_jurisdiction_statement, [label - 'Regulation (EU) 2016/679 (GDPR) Art 81(3), the condition that the court first seized has jurisdiction over the actions in question', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:02016R0679-20160504#parag_081.003', verbatim - 'if the court first seized has jurisdiction over the actions in question']).
citation(consolidation_under_law_of_court_first_seized_statement, [label - 'Regulation (EU) 2016/679 (GDPR) Art 81(3), the condition that the law of the court first seized permits the consolidation of the actions', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:02016R0679-20160504#parag_081.003', verbatim - 'its law permits the consolidation thereof']).

implements(Key) :-
    citation(Key, _).

test(every_query_key_is_recorded) :-
    implements(eu_reg_2016_679_art_80_1),
    implements(eu_reg_2016_679_art_80_2),
    implements(eu_reg_2016_679_art_81_1),
    implements(eu_reg_2016_679_art_81_2),
    implements(eu_reg_2016_679_art_81_3).
test(every_referral_target_is_recorded) :-
    implements(member_state_law_on_mandated_compensation_claims_statement),
    implements(member_state_law_on_action_without_mandate_statement),
    implements(court_first_seized_jurisdiction_statement),
    implements(consolidation_under_law_of_court_first_seized_statement).
test(a_recorded_key_is_implemented) :-
    implements(eu_reg_2016_679_art_81_3).
test(nine_records) :-
    findall(Key, citation(Key, _), Keys),
    length(Keys, 9).

test(an_unrecorded_key_is_not_implemented, fail) :-
    implements(eu_todo_primary_source).
