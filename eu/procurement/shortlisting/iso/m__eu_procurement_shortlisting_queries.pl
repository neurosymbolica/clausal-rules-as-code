:- module(m__eu_procurement_shortlisting_queries, [shortlisting_profile_keys/1, shortlisting_what_if/4, shortlisting_threshold_flip/5, shortlisting_floor_comparison/7]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_procurement_shortlisting_shortlisting, [shortlisting_status/2, shortlisting_input_acceptable/1, shortlisting_invitation_floor/4]).
:- use_module(query_combinators, [override_key/4, flip_scan/4]).

shortlisting_profile_keys([procedure_type_key, objective_and_non_discriminatory_criteria_indicated, minimum_number_indicated, declared_minimum_candidates, declared_maximum_candidates, qualified_candidates, invited_candidates, number_invited_sufficient_for_genuine_competition, invited_include_non_requesting_economic_operators, invited_include_candidates_without_required_capabilities]).

shortlisting_what_if(Profile, OverriddenKey, NewValue, NewStatus) :-
    shortlisting_input_acceptable(Profile),
    ground(OverriddenKey),
    override_key(Profile, OverriddenKey, NewValue, Hypothesis),
    shortlisting_status(Hypothesis, NewStatus).

threshold_probe(Profile, Key, X, Status) :-
    override_key(Profile, Key, X, Modified),
    shortlisting_status(Modified, Status).

shortlisting_threshold_flip(Profile, Key, Lo, Hi, Boundary) :-
    shortlisting_input_acceptable(Profile),
    ground(Key),
    flip_scan(Lo, Hi, threshold_probe(Profile, Key), Boundary).

shortlisting_floor_comparison(ProcedureType, DeclaredMinA, QualifiedA, DeclaredMinB, QualifiedB, FloorA, FloorB) :-
    shortlisting_invitation_floor(ProcedureType, DeclaredMinA, QualifiedA, FloorA),
    shortlisting_invitation_floor(ProcedureType, DeclaredMinB, QualifiedB, FloorB).
