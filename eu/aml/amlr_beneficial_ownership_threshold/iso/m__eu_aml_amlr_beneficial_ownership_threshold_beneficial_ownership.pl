:- module(m__eu_aml_amlr_beneficial_ownership_threshold_beneficial_ownership, [bo_threshold/1, amlr_bo_requirement_ids/1, amlr_bo_threshold/1, amlr_bo_effective_holding/2, amlr_bo_status/2, amlr_bo_minimum_holding_bps/1, amlr_bo_effective_holding_bps/2, requirement/4, amlr_bo_checklist/2, amlr_bo_decision/2, assess_amlr_bo/3, amlr_bo_input_problem/2, amlr_bo_input_complete/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_dicts, [dict_keys/2, dict_pairs/2, get/3]).
:- use_module(clausal_lists_extra, [is_list/1]).
:- use_module(library(clpz)).
:- use_module(m__eu_aml_amlr_beneficial_ownership_threshold_citations, [implements/1]).
:- use_module(formalize_lib, [status_gte/4, eval_requirements/4, decide_labeled/3, profile_lacks/2]).

bo_threshold(2500).

amlr_bo_requirement_ids([required_ownership_threshold]).

bo_chain_holding([], 10000/1).
bo_chain_holding([LevelBasisPoints|RemainingLevels], ResultNumerator/ResultDenominator) :-
    implements(eu_reg_2024_1624_art_52_1),
    bo_chain_holding(RemainingLevels, TailNumerator/TailDenominator),
    ResultNumerator #= LevelBasisPoints * TailNumerator,
    ResultDenominator #= TailDenominator * 10000.

bo_chains_total(Chains, TotalBasisPoints) :-
    implements(eu_reg_2024_1624_art_52_1),
    bo_sum_of_chains(Chains, TotalBasisPoints).

bo_sum_of_chains([], 0/1).
bo_sum_of_chains([Chain|Chains], SumNumerator/SumDenominator) :-
    bo_chain_holding(Chain, ChainNumerator/ChainDenominator),
    bo_sum_of_chains(Chains, RestNumerator/RestDenominator),
    SumNumerator #= ChainNumerator * RestDenominator + RestNumerator * ChainDenominator,
    SumDenominator #= ChainDenominator * RestDenominator.

bo_effective_holding(Chains, TotalBasisPoints) :-
    implements(eu_reg_2024_1624_art_52_1),
    bo_chains_total(Chains, Numerator/Denominator),
    exact_basis_points(Numerator, Denominator, TotalBasisPoints).

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

effective_holding_reaches_threshold(Chains) :-
    implements(eu_reg_2024_1624_art_52_1),
    bo_effective_holding(Chains, TotalBasisPoints),
    bo_threshold(ThresholdBasisPoints),
    holding_whole_basis_points(TotalBasisPoints, WholeBasisPoints),
    WholeBasisPoints #>= ThresholdBasisPoints.

effective_holding_below_threshold(Chains) :-
    implements(eu_reg_2024_1624_art_52_1),
    bo_effective_holding(Chains, TotalBasisPoints),
    bo_threshold(ThresholdBasisPoints),
    holding_whole_basis_points(TotalBasisPoints, WholeBasisPoints),
    WholeBasisPoints #< ThresholdBasisPoints.

bo_status(Chains, eligible) :-
    implements(eu_reg_2024_1624_art_51_chapeau),
    implements(eu_reg_2024_1624_art_51_a),
    effective_holding_reaches_threshold(Chains).
bo_status(Chains, ineligible) :-
    implements(eu_reg_2024_1624_art_51_chapeau),
    implements(eu_reg_2024_1624_art_51_a),
    effective_holding_below_threshold(Chains).

amlr_bo_threshold(ThresholdBasisPoints) :-
    bo_threshold(ThresholdBasisPoints).

amlr_bo_effective_holding(Chains, TotalBasisPoints) :-
    dict_pairs(Profile, [ownership_chains - Chains]),
    amlr_bo_input_complete(Profile),
    bo_effective_holding(Chains, TotalBasisPoints).

amlr_bo_status(Chains, Status) :-
    dict_pairs(Profile, [ownership_chains - Chains]),
    amlr_bo_input_complete(Profile),
    bo_status(Chains, Status).
amlr_bo_status(Chains, indeterminate) :-
    dict_pairs(Profile, [ownership_chains - Chains]),
    amlr_bo_input_problem(Profile, _).

amlr_bo_minimum_holding_bps(ThresholdBps) :-
    bo_threshold(ThresholdBps).

amlr_bo_effective_holding_bps(Chains, TotalBps) :-
    dict_pairs(Profile, [ownership_chains - Chains]),
    amlr_bo_input_complete(Profile),
    bo_effective_holding(Chains, TotalBps).

ownership_threshold_eff(Profile, value(WholeBps)) :-
    amlr_bo_input_complete(Profile),
    get(Profile, ownership_chains, Chains),
    bo_effective_holding(Chains, TotalBps),
    holding_whole_basis_points(TotalBps, WholeBps).
ownership_threshold_eff(Profile, absent([Reason])) :-
    amlr_bo_input_problem(Profile, Problem),
    input_problem_reason(Problem, Reason).

input_problem_reason(missing_key(ownership_chains), ownership_chains).
input_problem_reason(Problem, Problem) :-
    dif(Problem, missing_key(ownership_chains)).

requirement(required_ownership_threshold, Profile, Status, cite(eu_reg_2024_1624_art_52_1)) :-
    implements(eu_reg_2024_1624_art_52_1),
    ownership_threshold_eff(Profile, Eff),
    bo_threshold(ThresholdBps),
    status_gte(Eff, ThresholdBps, effective_holding_below_25_percent_threshold, Status).

amlr_bo_checklist(Profile, Checklist) :-
    amlr_bo_requirement_ids(Ids),
    eval_requirements(Ids, Profile, requirement, Checklist).

amlr_bo_decision(Profile, Decision) :-
    amlr_bo_checklist(Profile, Checklist),
    decide_labeled(Checklist, labels(eligible, indeterminate, ineligible), Decision).

assess_amlr_bo(Subject, Profile, assessment(Subject, Decision, Checklist)) :-
    amlr_bo_checklist(Profile, Checklist),
    amlr_bo_decision(Profile, Decision).

no_statute("amlr_bo_threshold", 1, "interface_shape").
no_statute("amlr_bo_effective_holding", 2, "interface_shape").
no_statute("amlr_bo_status", 2, "interface_shape").
no_statute("amlr_bo_minimum_holding_bps", 1, "interface_shape").
no_statute("amlr_bo_effective_holding_bps", 2, "interface_shape").
no_statute("ownership_threshold_eff", 2, "computation_helper").
no_statute("amlr_bo_checklist", 2, "projection_of_verdict").
no_statute("amlr_bo_decision", 2, "projection_of_verdict").
no_statute("assess_amlr_bo", 3, "projection_of_verdict").
no_statute("amlr_bo_input_problem", 2, "interface_shape").
no_statute("amlr_bo_input_complete", 1, "interface_shape").
no_statute("bo_sum_of_chains", 2, "computation_helper").
no_statute("exact_basis_points", 3, "computation_helper").
no_statute("holding_whole_basis_points", 2, "computation_helper").
no_statute("not_a_proper_list", 1, "computation_helper").
no_statute("not_an_integer", 1, "computation_helper").

amlr_bo_input_problem(Profile, Problem) :-
    findall(Candidate, input_problem_candidate(Profile, Candidate), [Problem|_]).

amlr_bo_input_complete(Profile) :-
    findall(Candidate, input_problem_candidate(Profile, Candidate), []).

input_problem_candidate(Profile, not_ground) :-
    term_variables(Profile, [_|_]).
input_problem_candidate(Profile, not_a_profile) :-
    ground(Profile),
    \+ dict_keys(Profile, _).
input_problem_candidate(Profile, missing_key(ownership_chains)) :-
    ground(Profile),
    dict_keys(Profile, _),
    profile_lacks(Profile, ownership_chains).
input_problem_candidate(Profile, Problem) :-
    ground(Profile),
    dict_keys(Profile, _),
    get(Profile, ownership_chains, Chains),
    chains_problem(Chains, Problem).

chains_problem(Chains, not_a_list(ownership_chains)) :-
    not_a_proper_list(Chains).
chains_problem(Chains, Problem) :-
    is_list(Chains),
    member(Chain, Chains),
    chain_problem(Chain, Problem).

chain_problem(Chain, not_a_list(Chain)) :-
    not_a_proper_list(Chain).
chain_problem(Chain, empty_chain) :-
    Chain = [].
chain_problem(Chain, Problem) :-
    is_list(Chain),
    member(Level, Chain),
    level_problem(Level, Problem).

level_problem(Level, wrong_type(Level, expected_integer)) :-
    not_an_integer(Level).
level_problem(Level, out_of_range(Level)) :-
    integer(Level),
    Level #< 0.
level_problem(Level, out_of_range(Level)) :-
    integer(Level),
    Level #> 10000.

not_a_proper_list(Term) :-
    atomic(Term),
    dif(Term, []).
not_a_proper_list([_|Tail]) :-
    not_a_proper_list(Tail).
not_a_proper_list(Term) :-
    compound(Term),
    functor(Term, Name, Arity),
    functor([_], ListName, ListArity),
    dif(Name/Arity, ListName/ListArity).
not_a_proper_list(Term) :-
    dif(Term, []),
    dict_keys(Term, _).

not_an_integer(Value) :-
    atom(Value).
not_an_integer(Value) :-
    float(Value).
not_an_integer(Value) :-
    compound(Value).
not_an_integer(Value) :-
    dict_keys(Value, _).
