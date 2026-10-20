:- module(m__eu_procurement_directive_2014_24_vocabulary, [contracting_authority_type/1, contract_type/1, procedure_type/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).

contracting_authority_type(central_government_authority).
contracting_authority_type(sub_central_contracting_authority).
contracting_authority_type(body_governed_by_public_law).

contract_type(works).
contract_type(supplies).
contract_type(services).
contract_type(social_and_other_specific_services).

procedure_type(open_procedure).
procedure_type(restricted_procedure).
procedure_type(competitive_procedure_with_negotiation).
procedure_type(competitive_dialogue).
procedure_type(innovation_partnership).
procedure_type(negotiated_procedure_without_prior_publication).
