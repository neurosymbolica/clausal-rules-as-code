% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_administrative_fine_maximum_parameters, []).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).

parameter_source(lower_maximum_tier_fixed_amount_in_euro_cents, [label - 'Regulation (EU) 2016/679 (GDPR) Art 83(4) fixed maximum of the lower tier, EUR 10000000 (held as 1000000000 euro cents)', ref - '02016R0679-20160504#parag_083.004', verbatim - 'subject to administrative fines up to 10000000 EUR']).
parameter_source(lower_maximum_tier_turnover_percentage, [label - 'Regulation (EU) 2016/679 (GDPR) Art 83(4) turnover percentage of the lower tier for an undertaking, 2 %', ref - '02016R0679-20160504#parag_083.004', verbatim - 'in the case of an undertaking, up to 2 % of the total worldwide annual turnover of the preceding financial year']).
parameter_source(higher_maximum_tier_fixed_amount_in_euro_cents, [label - 'Regulation (EU) 2016/679 (GDPR) Art 83(5) and (6) fixed maximum of the higher tier, EUR 20000000 (held as 2000000000 euro cents)', ref - '02016R0679-20160504#parag_083.005', verbatim - 'subject to administrative fines up to 20000000 EUR']).
parameter_source(higher_maximum_tier_turnover_percentage, [label - 'Regulation (EU) 2016/679 (GDPR) Art 83(5) and (6) turnover percentage of the higher tier for an undertaking, 4 %', ref - '02016R0679-20160504#parag_083.005', verbatim - 'in the case of an undertaking, up to 4 % of the total worldwide annual turnover of the preceding financial year']).
