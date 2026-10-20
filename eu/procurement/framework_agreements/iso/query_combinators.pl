:- module(query_combinators, [diff_checklists/3, changed_deltas/2, flip_scan/4, bisect_flip/4, override_key/4, what_if/5, override_where/4]).

:- use_module(library(lists), [append/3]).
:- use_module(library(dif), [dif/2]).
:- use_module('clausal_kit_dicts', [attrs_put/3]).
:- use_module('clausal_hof', [call_goal/2]).
:- use_module('clausal_hof', [call_goal/3]).
:- use_module('clausal_hof', [include/3]).

:- meta_predicate(what_if(?, ?, ?, 2, ?)).

:- meta_predicate(flip_scan(?, ?, 2, ?)).

:- meta_predicate(scan_from(?, ?, ?, 2, ?)).

:- meta_predicate(flip_step(?, ?, ?, ?, 2, ?)).

:- meta_predicate(bisect_flip(?, ?, 2, ?)).

:- meta_predicate(bisect_between(?, ?, ?, 2, ?)).

:- meta_predicate(bisect_pick(?, ?, ?, ?, ?, 2, ?)).

:- meta_predicate(override_where(?, 1, ?, ?)).

:- meta_predicate(matches_elem(1, ?)).

:- use_module(library(clpz), [(#=)/2]).

:- set_prolog_flag(double_quotes, chars).

diff_checklists(CL_A, CL_B, DELTAS) :-
    checklist_ids(CL_A, IDS_A),
    checklist_ids(CL_B, IDS_B),
    append(IDS_A, IDS_B, IDS_RAW),
    sort(IDS_RAW, IDS),
    deltas_for_ids(IDS, CL_A, CL_B, DELTAS).

checklist_ids([], []).

checklist_ids([ITEM|TAIL], [ID|REST]) :-
    functor(ITEM, _, 3),
    arg(1, ITEM, ID),
    checklist_ids(TAIL, REST).

deltas_for_ids([], _, _, []).

deltas_for_ids([ID|IDS], CL_A, CL_B, [DELTA|DELTAS]) :-
    status_in(CL_A, ID, STATUS_A),
    status_in(CL_B, ID, STATUS_B),
    DELTA = delta(ID, STATUS_A, STATUS_B),
    deltas_for_ids(IDS, CL_A, CL_B, DELTAS).

status_in(CL, ID, STATUS) :-
    row_status_first(CL, ID, S),
    STATUS = S.

status_in(CL, ID, STATUS) :-
    no_row_with_id(CL, ID),
    STATUS = "absent".

row_status_first([ITEM|_], ID, S) :-
    functor(ITEM, _, 3),
    arg(1, ITEM, ID),
    arg(2, ITEM, S).

row_status_first([ITEM|TAIL], ID, S) :-
    row_id_differs(ITEM, ID),
    row_status_first(TAIL, ID, S).

row_id_differs(ITEM, _) :-
    functor(ITEM, _, N),
    dif(N, 3).

row_id_differs(ITEM, ID) :-
    functor(ITEM, _, 3),
    arg(1, ITEM, ROW_ID),
    dif(ROW_ID, ID).

no_row_with_id([], _).

no_row_with_id([ITEM|TAIL], ID) :-
    row_id_differs(ITEM, ID),
    no_row_with_id(TAIL, ID).

delta_changed(D) :-
    D = delta(_, SA, SB),
    dif(SA, SB).

changed_deltas(DELTAS, CHANGED) :-
    include(delta_changed, DELTAS, CHANGED).

flip_scan(LO, HI, PROBE, BOUNDARY) :-
    call_goal(PROBE, LO, V0),
    scan_from(LO, HI, V0, PROBE, BOUNDARY).

scan_from(X, HI, V_PREV, PROBE, BOUNDARY) :-
    X < HI,
    #=(X1, X + 1),
    call_goal(PROBE, X1, V1),
    flip_step(X1, V_PREV, V1, HI, PROBE, BOUNDARY).

flip_step(X1, V_PREV, V1, _, _, X1) :-
    dif(V_PREV, V1).

flip_step(X1, V_PREV, V1, HI, PROBE, BOUNDARY) :-
    V_PREV = V1,
    scan_from(X1, HI, V1, PROBE, BOUNDARY).

bisect_flip(LO, HI, PROBE, BOUNDARY) :-
    call_goal(PROBE, LO, V_LO),
    call_goal(PROBE, HI, V_HI),
    dif(V_LO, V_HI),
    bisect_between(LO, HI, V_LO, PROBE, BOUNDARY).

bisect_between(LO, HI, _, _, HI) :-
    #=(HI, LO + 1).

bisect_between(LO, HI, V_LO, PROBE, BOUNDARY) :-
    HI > LO + 1,
    #=(MID, (LO + HI) div 2),
    call_goal(PROBE, MID, V_MID),
    bisect_pick(LO, MID, HI, V_LO, V_MID, PROBE, BOUNDARY).

bisect_pick(_, MID, HI, V_LO, V_MID, PROBE, BOUNDARY) :-
    V_MID = V_LO,
    bisect_between(MID, HI, V_LO, PROBE, BOUNDARY).

bisect_pick(LO, MID, _, V_LO, V_MID, PROBE, BOUNDARY) :-
    dif(V_MID, V_LO),
    bisect_between(LO, MID, V_LO, PROBE, BOUNDARY).

override_key(DICT, KEY, VALUE, NEW_DICT) :-
    attrs_put(DICT, [attribute(KEY, VALUE)], NEW_DICT).

what_if(PROFILE, KEY, VALUE, DECIDE, RESULT) :-
    override_key(PROFILE, KEY, VALUE, HYP),
    call_goal(DECIDE, HYP, RESULT).

override_where([H|T], MATCH, VALUE, [VALUE|T]) :-
    matches_elem(MATCH, H).

override_where([H|T], MATCH, VALUE, [H|T2]) :-
    \+ matches_elem(MATCH, H),
    override_where(T, MATCH, VALUE, T2).

matches_elem(MATCH, X) :-
    once(call_goal(MATCH, X)).
