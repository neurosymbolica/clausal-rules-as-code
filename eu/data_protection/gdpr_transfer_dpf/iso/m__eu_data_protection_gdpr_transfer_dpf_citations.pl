% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_transfer_dpf_citations, [citation/2, implements/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).

citation(eu_dec_2023_1795_art_1, [label - 'Commission Implementing Decision (EU) 2023/1795 (EU-US Data Privacy Framework) Art 1', ref - 'https://eur-lex.europa.eu/eli/dec_impl/2023/1795/oj', verbatim - 'the United States ensures an adequate level of protection for personal data transferred from the Union to organisations in the United States']).
citation(eu_reg_2016_679_art_45_1, [label - 'Regulation (EU) 2016/679 (GDPR) Art 45(1)', ref - 'https://eur-lex.europa.eu/eli/reg/2016/679/oj', verbatim - 'Such a transfer shall not require any specific authorisation.']).
citation(data_privacy_framework_decision_in_force_statement, [label - 'Commission Implementing Decision (EU) 2023/1795 Art 1 read with Art 3(5): attested statement that the decision is in force for the transfer (not repealed, suspended, amended or limited so as to exclude it, and not declared invalid)', ref - 'https://eur-lex.europa.eu/eli/dec_impl/2023/1795/oj']).
citation(data_privacy_framework_list_entry_statement, [label - 'Commission Implementing Decision (EU) 2023/1795 Art 1 read with Annex I Section I.3: attested statement that the recipient is included in the Data Privacy Framework List at the time of the transfer', ref - 'https://eur-lex.europa.eu/eli/dec_impl/2023/1795/oj']).
citation(data_privacy_framework_certification_coverage_statement, [label - 'Commission Implementing Decision (EU) 2023/1795 Art 1 read with Annex I Section I.6 and recital (10): attested statement that the data of the transfer fall within what the recipient certification covers', ref - 'https://eur-lex.europa.eu/eli/dec_impl/2023/1795/oj']).

implements(Key) :-
    citation(Key, _).

test(the_operative_rule_is_recorded) :-
    implements(eu_dec_2023_1795_art_1).
test(the_effect_is_recorded) :-
    implements(eu_reg_2016_679_art_45_1).
test(each_referral_target_is_recorded) :-
    implements(data_privacy_framework_decision_in_force_statement),
    implements(data_privacy_framework_list_entry_statement),
    implements(data_privacy_framework_certification_coverage_statement).

test(a_shortened_key_is_not_recorded, fail) :-
    implements(eu_dec_2023_1795).
