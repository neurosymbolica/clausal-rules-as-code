:- module(m__eu_aml_amlr_bo_chain_ownership_interest, [effective_ownership/4, ubo_status/4, ubo_threshold_bps/1, bo_chain_input_problem/4, bo_chain_input_complete/3, holding_whole_basis_points/2, holding_difference/3]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_lists_extra, [is_list/1]).
:- use_module(library(clpz)).
:- use_module(m__eu_aml_amlr_bo_chain_citations, [implements/1]).

ubo_threshold_bps(V) :-
    implements(eu_reg_2024_1624_art_52_1),
    V #= 2500.

effective_ownership(Holdings, Person, Entity, EffBps) :-
    bo_chain_input_complete(Holdings, Person, Entity),
    implements(eu_reg_2024_1624_art_52_1_indirect),
    implements(eu_reg_2024_1624_art_52_1_every_level),
    effective_ownership_fraction(Holdings, Person, Entity, Numerator, Denominator),
    exact_basis_points(Numerator, Denominator, EffBps).

effective_ownership_fraction(Holdings, Person, Entity, Numerator, Denominator) :-
    findall(C, (member([H, Entity, Pct], Holdings), bo_contribution(Holdings, Person, H, Pct, C)), Cs),
    fraction_sum(Cs, Numerator, Denominator).

bo_contribution(_Holdings, Person, Person, Pct, C) :-
    implements(eu_reg_2024_1624_art_52_1_indirect),
    C = fraction(Pct, 1).
bo_contribution(Holdings, Person, H, Pct, C) :-
    implements(eu_reg_2024_1624_art_52_1_indirect),
    dif(H, Person),
    effective_ownership_fraction(Holdings, Person, H, SubNumerator, SubDenominator),
    Numerator #= Pct * SubNumerator,
    Denominator #= SubDenominator * 10000,
    C = fraction(Numerator, Denominator).

fraction_sum([], 0, 1).
fraction_sum([fraction(N, D)|Fractions], Numerator, Denominator) :-
    fraction_sum(Fractions, RestNumerator, RestDenominator),
    Numerator #= N * RestDenominator + RestNumerator * D,
    Denominator #= D * RestDenominator.

exact_basis_points(Numerator, Denominator, TotalBasisPoints) :-
    0 #= Numerator mod Denominator,
    TotalBasisPoints #= Numerator // Denominator.
exact_basis_points(Numerator, Denominator, ReducedNumerator/ReducedDenominator) :-
    Remainder #= Numerator mod Denominator,
    Remainder #\= 0,
    Divisor is gcd(Numerator, Denominator),
    ReducedNumerator #= Numerator // Divisor,
    ReducedDenominator #= Denominator // Divisor.

holding_whole_basis_points(TotalBasisPoints, TotalBasisPoints) :-
    integer(TotalBasisPoints).
holding_whole_basis_points(Numerator/Denominator, WholeBasisPoints) :-
    WholeBasisPoints #= Numerator // Denominator.

holding_difference(Minuend, Subtrahend, Difference) :-
    holding_fraction(Minuend, MinuendNumerator, MinuendDenominator),
    holding_fraction(Subtrahend, SubtrahendNumerator, SubtrahendDenominator),
    Numerator #= MinuendNumerator * SubtrahendDenominator - SubtrahendNumerator * MinuendDenominator,
    Denominator #= MinuendDenominator * SubtrahendDenominator,
    exact_basis_points(Numerator, Denominator, Difference).

holding_fraction(TotalBasisPoints, TotalBasisPoints, 1) :-
    integer(TotalBasisPoints).
holding_fraction(Numerator/Denominator, Numerator, Denominator).

ownership_interest_reaches_threshold(Holdings, Person, Entity) :-
    implements(eu_reg_2024_1624_art_52_1),
    effective_ownership(Holdings, Person, Entity, Eff),
    ubo_threshold_bps(Thr),
    holding_whole_basis_points(Eff, WholeEff),
    WholeEff #>= Thr.

ownership_interest_below_threshold(Holdings, Person, Entity) :-
    implements(eu_reg_2024_1624_art_52_1),
    effective_ownership(Holdings, Person, Entity, Eff),
    ubo_threshold_bps(Thr),
    holding_whole_basis_points(Eff, WholeEff),
    WholeEff #< Thr.

ubo_status(Holdings, Person, Entity, eligible) :-
    bo_chain_input_complete(Holdings, Person, Entity),
    implements(eu_reg_2024_1624_art_51_chapeau),
    implements(eu_reg_2024_1624_art_51_a),
    ownership_interest_reaches_threshold(Holdings, Person, Entity).
ubo_status(Holdings, Person, Entity, ineligible) :-
    bo_chain_input_complete(Holdings, Person, Entity),
    implements(eu_reg_2024_1624_art_51_chapeau),
    implements(eu_reg_2024_1624_art_51_a),
    ownership_interest_below_threshold(Holdings, Person, Entity).

bo_chain_input_problem(Holdings, Person, Entity, Problem) :-
    findall(Candidate, input_problem_candidate(Holdings, Person, Entity, Candidate), [Problem|_]).

bo_chain_input_complete(Holdings, Person, Entity) :-
    findall(Candidate, input_problem_candidate(Holdings, Person, Entity, Candidate), []).

input_problem_candidate(Holdings, Person, Entity, not_ground) :-
    term_variables([Holdings, Person, Entity], [_|_]).
input_problem_candidate(Holdings, Person, Entity, Problem) :-
    ground([Holdings, Person, Entity]),
    holdings_problem(Holdings, Problem).
input_problem_candidate(Holdings, Person, Entity, wrong_type(person, expected_name)) :-
    ground([Holdings, Person, Entity]),
    not_holding_name(Person).
input_problem_candidate(Holdings, Person, Entity, wrong_type(entity, expected_name)) :-
    ground([Holdings, Person, Entity]),
    not_holding_name(Entity).

holdings_problem(Holdings, not_a_list(holdings)) :-
    not_a_proper_list(Holdings).
holdings_problem(Holdings, Problem) :-
    is_list(Holdings),
    member(Edge, Holdings),
    edge_problem(Edge, Problem).
holdings_problem(Holdings, cyclic_holdings(Node)) :-
    is_list(Holdings),
    findall(N, (member([N, Next, _], Holdings), reaches(Holdings, Next, N, [Next])), Cyclic),
    Cyclic = [Node|_].

not_a_proper_list(X) :-
    not_a_list_cell(X),
    dif(X, []).
not_a_proper_list([_|Tail]) :-
    not_a_proper_list(Tail).

not_a_list_cell(X) :-
    atomic(X).
not_a_list_cell(X) :-
    compound(X),
    functor(X, Name, Arity),
    functor([_|_], CellName, CellArity),
    dif(Name/Arity, CellName/CellArity).

edge_problem(Edge, malformed_edge(Edge)) :-
    not_three_element_list(Edge).
edge_problem(Edge, wrong_type(Edge, expected_name)) :-
    Edge = [Holder, _, _],
    not_holding_name(Holder).
edge_problem(Edge, wrong_type(Edge, expected_name)) :-
    Edge = [Holder, Held, _],
    holding_name(Holder),
    not_holding_name(Held).
edge_problem(Edge, wrong_type(Edge, expected_integer)) :-
    Edge = [_, _, Percentage],
    not_an_integer(Percentage).
edge_problem(Edge, out_of_range(Edge)) :-
    Edge = [_, _, Percentage],
    integer(Percentage),
    Percentage #< 0.
edge_problem(Edge, out_of_range(Edge)) :-
    Edge = [_, _, Percentage],
    integer(Percentage),
    Percentage #> 10000.
edge_problem(Edge, self_holding(Edge)) :-
    Edge = [Node, Node, _].

three_element_list([_, _, _]).

not_three_element_list(Edge) :-
    not_a_list_cell(Edge).
not_three_element_list([_|Tail]) :-
    not_a_list_cell(Tail).
not_three_element_list([_, _|Tail]) :-
    not_a_list_cell(Tail).
not_three_element_list([_, _, _|Tail]) :-
    dif(Tail, []).

not_an_integer(X) :-
    atom(X).
not_an_integer(X) :-
    float(X).
not_an_integer(X) :-
    compound(X).

holding_name(X) :-
    atom(X),
    dif(X, []).
holding_name(X) :-
    X = [_|_],
    character_list(X).

not_holding_name(X) :-
    X = [].
not_holding_name(X) :-
    number(X).
not_holding_name(X) :-
    compound(X),
    not_a_list_cell(X).
not_holding_name(X) :-
    X = [_|_],
    not_character_list(X).

character_list([C]) :-
    single_character(C).
character_list([C, D|Rest]) :-
    single_character(C),
    character_list([D|Rest]).

not_character_list([C|_]) :-
    not_single_character(C).
not_character_list([C|Tail]) :-
    single_character(C),
    not_a_list_cell(Tail),
    dif(Tail, []).
not_character_list([C, D|Rest]) :-
    single_character(C),
    not_character_list([D|Rest]).

single_character(C) :-
    atom(C),
    atom_length(C, 1).

not_single_character(C) :-
    atom(C),
    atom_length(C, Length),
    dif(Length, 1).
not_single_character(C) :-
    number(C).
not_single_character(C) :-
    compound(C).

reaches(Holdings, From, To, _) :-
    member([From, To, _], Holdings).
reaches(Holdings, From, To, Visited) :-
    member([From, Next, _], Holdings),
    maplist(dif(Next), Visited),
    reaches(Holdings, Next, To, [Next|Visited]).

no_statute("effective_ownership_fraction", 5, "computation_helper").
no_statute("fraction_sum", 3, "computation_helper").
no_statute("exact_basis_points", 3, "computation_helper").
no_statute("holding_whole_basis_points", 2, "computation_helper").
no_statute("holding_difference", 3, "computation_helper").
no_statute("holding_fraction", 3, "computation_helper").
no_statute("not_a_proper_list", 1, "computation_helper").
no_statute("not_a_list_cell", 1, "computation_helper").
no_statute("not_three_element_list", 1, "computation_helper").
no_statute("not_an_integer", 1, "computation_helper").
no_statute("not_holding_name", 1, "computation_helper").
no_statute("character_list", 1, "computation_helper").
no_statute("not_character_list", 1, "computation_helper").
no_statute("single_character", 1, "computation_helper").
no_statute("not_single_character", 1, "computation_helper").
