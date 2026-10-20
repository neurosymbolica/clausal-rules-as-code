:- module(m__eu_procurement_framework_agreements_parameters, [parameter_source/2]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_procurement_framework_agreements_framework_agreements, [framework_term_limit_years/1]).

parameter_source(framework_term_limit_years, [label - 'Directive 2014/24/EU Art 33(1) -- maximum term of a framework agreement (four years)', ref - 'https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:32014L0024', verbatim - 'The term of a framework agreement shall not exceed four years, save in exceptional cases duly justified, in particular by the subject of the framework agreement.']).
