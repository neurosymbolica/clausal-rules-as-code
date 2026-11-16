% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_impact_assessment_prior_consultation_citations, [citation/2, implements/1, basis_citation/2]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).

citation(eu_reg_2016_679_art_36_1, [label - 'Regulation (EU) 2016/679 Art 36(1) (prior consultation of the supervisory authority where the impact assessment indicates a high risk in the absence of mitigating measures)', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:02016R0679-20160504', verbatim - 'The controller shall consult the supervisory authority prior to processing where a data protection impact assessment under Article 35 indicates that the processing would result in a high risk in the absence of measures taken by the controller to mitigate the risk.']).
citation(eu_reg_2016_679_art_36_5, [label - 'Regulation (EU) 2016/679 Art 36(5) (Member State law may require consultation with, and prior authorisation from, the supervisory authority for processing for a task carried out in the public interest)', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:02016R0679-20160504', verbatim - 'Notwithstanding paragraph 1, Member State law may require controllers to consult with, and obtain prior authorisation from, the supervisory authority in relation to processing by a controller for the performance of a task carried out by the controller in the public interest, including processing in relation to social protection and public health.']).
citation(eu_reg_2016_679_art_35_1, [label - 'Regulation (EU) 2016/679 Art 35(1) (duty to carry out a data protection impact assessment; cited only in the not_governed_here referral)', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:02016R0679-20160504']).
citation(member_state_law_requiring_prior_consultation_and_authorisation, [label - 'Member State law referred to in Regulation (EU) 2016/679 Art 36(5) requiring the controller to consult with, and obtain prior authorisation from, the supervisory authority (referral target of the cross_reference_unresolved referral; an attested outside fact, fetcher none)', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:02016R0679-20160504']).

implements(Key) :-
    citation(Key, _).

basis_citation(art36_1_residual_high_risk, cite(eu_reg_2016_679_art_36_1)).
basis_citation(art36_1_condition_not_met, cite(eu_reg_2016_679_art_36_1)).
basis_citation(art36_5_member_state_prior_authorisation, cite(eu_reg_2016_679_art_36_5)).

test(the_residual_risk_provision_is_implemented) :-
    implements(eu_reg_2016_679_art_36_1).
test(the_member_state_provision_is_implemented) :-
    implements(eu_reg_2016_679_art_36_5).
test(every_basis_cites_a_recorded_key) :-
    findall(Key, basis_citation(_, cite(Key)), Keys),
    length(Keys, 3),
    maplist(implements, Keys).
test(the_member_state_basis_cites_article_36_5) :-
    findall(Citation, basis_citation(art36_5_member_state_prior_authorisation, Citation), Citations),
    Citations == [cite(eu_reg_2016_679_art_36_5)].

test(an_unrecorded_key_is_not_implemented, fail) :-
    implements(eu_todo_primary_source).
test(the_member_state_basis_does_not_cite_article_36_1, fail) :-
    basis_citation(art36_5_member_state_prior_authorisation, cite(eu_reg_2016_679_art_36_1)).
