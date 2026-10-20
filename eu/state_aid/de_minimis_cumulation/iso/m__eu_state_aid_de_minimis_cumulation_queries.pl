:- module(m__eu_state_aid_de_minimis_cumulation_queries, [de_minimis_compare_refs/4, de_minimis_gap_to_ineligible/3, de_minimis_headroom/3, de_minimis_qualifying_grants/3, de_minimis_what_if/4]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(library(clpz)).
:- use_module(m__eu_state_aid_de_minimis_cumulation_cumulation, [de_minimis_aid_in_window/3, de_minimis_ceiling/1, de_minimis_verdict/3]).

de_minimis_qualifying_grants(Grants, Ref, Qualifying) :-
    de_minimis_aid_in_window(Grants, Ref, _),
    qualifying_sublist(Grants, Ref, Qualifying).

qualifying_sublist([], _, []).
qualifying_sublist([Grant|Grants], Ref, [Grant|Qualifying]) :-
    Grant = [D, _],
    de_minimis_aid_in_window([[D, 1]], Ref, 1),
    qualifying_sublist(Grants, Ref, Qualifying).
qualifying_sublist([Grant|Grants], Ref, Qualifying) :-
    Grant = [D, _],
    de_minimis_aid_in_window([[D, 1]], Ref, 0),
    qualifying_sublist(Grants, Ref, Qualifying).

de_minimis_compare_refs(Grants, RefA, RefB, Result) :-
    de_minimis_aid_in_window(Grants, RefA, TotalA),
    de_minimis_verdict(Grants, RefA, VerdictA),
    de_minimis_aid_in_window(Grants, RefB, TotalB),
    de_minimis_verdict(Grants, RefB, VerdictB),
    Result = ref_comparison(TotalA, VerdictA, TotalB, VerdictB).

de_minimis_headroom(Grants, Ref, HeadroomCents) :-
    de_minimis_aid_in_window(Grants, Ref, Total),
    de_minimis_ceiling(Ceiling),
    Total #=< Ceiling,
    HeadroomCents #= Ceiling - Total.
de_minimis_headroom(Grants, Ref, HeadroomCents) :-
    de_minimis_aid_in_window(Grants, Ref, Total),
    de_minimis_ceiling(Ceiling),
    Total #> Ceiling,
    HeadroomCents #= 0.

de_minimis_gap_to_ineligible(Grants, Ref, GapCents) :-
    de_minimis_verdict(Grants, Ref, V),
    V = eligible,
    de_minimis_headroom(Grants, Ref, Headroom),
    GapCents #= Headroom + 1.
de_minimis_gap_to_ineligible(Grants, Ref, GapCents) :-
    de_minimis_verdict(Grants, Ref, V),
    V = ineligible,
    GapCents #= 0.

de_minimis_what_if(Grants, Ref, NewAmountCents, Verdict) :-
    de_minimis_verdict([[Ref, NewAmountCents]|Grants], Ref, Verdict).
