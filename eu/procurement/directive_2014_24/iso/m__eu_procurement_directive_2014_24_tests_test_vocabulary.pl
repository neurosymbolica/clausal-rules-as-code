:- module(m__eu_procurement_directive_2014_24_tests_test_vocabulary, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_procurement_directive_2014_24_vocabulary, [contracting_authority_type/1, contract_type/1, procedure_type/1]).

test('membership predicates accept intended atoms, reject others') :-
    contracting_authority_type(central_government_authority),
    contracting_authority_type(sub_central_contracting_authority),
    contracting_authority_type(body_governed_by_public_law),
    contract_type(works),
    contract_type(supplies),
    contract_type(services),
    contract_type(social_and_other_specific_services),
    procedure_type(open_procedure),
    procedure_type(restricted_procedure),
    procedure_type(competitive_procedure_with_negotiation),
    procedure_type(competitive_dialogue),
    procedure_type(innovation_partnership),
    procedure_type(negotiated_procedure_without_prior_publication),
    findall(true, contract_type(open_procedure), []),
    findall(true, procedure_type(works), []),
    findall(true, contracting_authority_type(works), []).

cp_test_names(['membership predicates accept intended atoms, reject others']).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
