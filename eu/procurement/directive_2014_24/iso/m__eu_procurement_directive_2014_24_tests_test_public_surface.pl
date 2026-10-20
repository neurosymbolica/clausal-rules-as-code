:- module(m__eu_procurement_directive_2014_24_tests_test_public_surface, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_procurement_directive_2014_24_vocabulary, [contracting_authority_type/1, contract_type/1, procedure_type/1]).
:- use_module(m__eu_procurement_directive_2014_24_art4_thresholds, [art4_threshold/4, current_art4_threshold/3]).

test('vocabulary predicates work via their own module import') :-
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
    procedure_type(negotiated_procedure_without_prior_publication).
test('threshold predicate resolves via its own module import') :-
    current_art4_threshold(works, central_government_authority, _ThresholdEurCents).
test('art4_threshold resolves for a specific date via its own module import') :-
    art4_threshold(supplies, sub_central_contracting_authority, date(2024, 6, 1), 22100000).
test('the two modules compose: a vocabulary atom keys a threshold row') :-
    contract_type(social_and_other_specific_services),
    contracting_authority_type(sub_central_contracting_authority),
    current_art4_threshold(social_and_other_specific_services, sub_central_contracting_authority, _Cents).

cp_test_names(['vocabulary predicates work via their own module import', 'threshold predicate resolves via its own module import', 'art4_threshold resolves for a specific date via its own module import', 'the two modules compose: a vocabulary atom keys a threshold row']).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
