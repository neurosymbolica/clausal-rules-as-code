:- module(query_combinators, [diff_checklists/3, changed_deltas/2, enumerate_assess/5, flip_scan/4, bisect_flip/4, parameter_at/4, aggregate_over/3, diff_sets/5, failing_ids/4, not_met/1, override_key/4, what_if/5, what_if2/6, what_if_all/4, what_if_deltas/5, override_nth/4, override_where/4, what_if_nth/5]).

:- use_module(library(lists), [append/3]).
:- use_module(library(lists), [member/2]).
:- use_module(library(lists), [sum_list/2]).
:- use_module(library(dif), [dif/2]).
:- use_module('clausal_profiles', [attrs_put/3]).
:- use_module('clausal_hof', [call_goal/2]).
:- use_module('clausal_hof', [call_goal/3]).
:- use_module('clausal_hof', [call_goal/4]).
:- use_module('clausal_hof', [call_goal/5]).
:- use_module('clausal_hof', [include/3]).
:- use_module('clausal_hof', [max_by/3]).

:- use_module('formalize_lib', [assess/6, eval_requirements/4, not_member/2]).

:- meta_predicate(failing_ids(?, ?, 4, ?)).

:- meta_predicate(enumerate_assess(?, 4, 4, ?, ?)).

:- meta_predicate(flip_scan(?, ?, 2, ?)).

:- meta_predicate(scan_from(?, ?, ?, 2, ?)).

:- meta_predicate(flip_step(?, ?, ?, ?, 2, ?)).

:- meta_predicate(bisect_flip(?, ?, 2, ?)).

:- meta_predicate(bisect_between(?, ?, ?, 2, ?)).

:- meta_predicate(bisect_pick(?, ?, ?, ?, ?, 2, ?)).

:- meta_predicate(aggregate_over(?, 2, ?)).

:- meta_predicate(member_values(?, 2, ?)).

:- meta_predicate(what_if(?, ?, ?, 2, ?)).

:- meta_predicate(what_if2(?, ?, ?, 3, ?, ?)).

:- meta_predicate(what_if_all(?, ?, 2, ?)).

:- meta_predicate(what_if_deltas(?, ?, ?, 2, ?)).

:- meta_predicate(override_where(?, 1, ?, ?)).

:- meta_predicate(matches_elem(1, ?)).

:- meta_predicate(what_if_nth(?, ?, ?, 2, ?)).

:- use_module(library(clpz), [(#=)/2]).

:- set_prolog_flag(double_quotes, chars).

diff_checklists(CL_A, CL_B, DELTAS) :-
    checklist_ids(CL_A, IDS_A),
    checklist_ids(CL_B, IDS_B),
    append(IDS_A, IDS_B, IDS_RAW),
    sort(IDS_RAW, IDS),
    deltas_for_ids(IDS, CL_A, CL_B, DELTAS).

item_fields(CL, ID, STATUS) :-
    member(ITEM, CL),
    functor(ITEM, _, 3),
    arg(1, ITEM, ID),
    arg(2, ITEM, STATUS).

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

failing_ids(REQ_IDS, PROFILE, REQ_PRED, FAILING) :-
    eval_requirements(REQ_IDS, PROFILE, REQ_PRED, CL),
    findall(FID, (item_fields(CL, FID, ST), not_met(ST)), FAILING).

not_met(STATUS) :-
    compound(STATUS).

enumerate_assess(MEMBERS, REQ_PRED, PROFILE_OF, STATUS_FILTER, RESULTS) :-
    findall(assessment(MEMBER, DECISION, CHECKLIST), (member(MEMBER, MEMBERS), call_goal(PROFILE_OF, MEMBER, REQ_IDS, PROFILE, LABELS), assess(MEMBER, REQ_IDS, PROFILE, REQ_PRED, LABELS, assessment(MEMBER, DECISION, CHECKLIST)), DECISION = STATUS_FILTER), RESULTS).

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
    #=(MID, div(LO + HI, 2)),
    call_goal(PROBE, MID, V_MID),
    bisect_pick(LO, MID, HI, V_LO, V_MID, PROBE, BOUNDARY).

bisect_pick(_, MID, HI, V_LO, V_MID, PROBE, BOUNDARY) :-
    V_MID = V_LO,
    bisect_between(MID, HI, V_LO, PROBE, BOUNDARY).

bisect_pick(LO, MID, _, V_LO, V_MID, PROBE, BOUNDARY) :-
    dif(V_MID, V_LO),
    bisect_between(LO, MID, V_LO, PROBE, BOUNDARY).

diff_sets(LIST_A, LIST_B, ONLY_A, ONLY_B, SHARED) :-
    findall(X, (member(X, LIST_A), not_member(X, LIST_B)), OA0),
    sort(OA0, ONLY_A),
    findall(X, (member(X, LIST_B), not_member(X, LIST_A)), OB0),
    sort(OB0, ONLY_B),
    findall(X, (member(X, LIST_A), member(X, LIST_B)), SH0),
    sort(SH0, SHARED).

parameter_at(ENTRIES, QUERY_DATE, VALUE, CITE) :-
    findall([D, V, C], (member([D, V, C], ENTRIES), D =< QUERY_DATE), CANDIDATES),
    dif(CANDIDATES, []),
    max_by(entry_date_key, CANDIDATES, [_, VALUE, CITE]).

entry_date_key(E, K) :-
    E = [D2, _, _],
    K = D2.

aggregate_over(MEMBERS, COMPUTE, TOTAL) :-
    is_list(MEMBERS),
    member_values(MEMBERS, COMPUTE, VALUES),
    sum_list(VALUES, TOTAL).

member_values([], _, []).

member_values([MEMBER|REST], COMPUTE, [V|VALUES]) :-
    once(call_goal(COMPUTE, MEMBER, V)),
    member_values(REST, COMPUTE, VALUES).

override_key(DICT, KEY, VALUE, NEW_DICT) :-
    attrs_put(DICT, [attribute(KEY, VALUE)], NEW_DICT).

what_if(PROFILE, KEY, VALUE, DECIDE, RESULT) :-
    override_key(PROFILE, KEY, VALUE, HYP),
    call_goal(DECIDE, HYP, RESULT).

what_if2(PROFILE, KEY, VALUE, DECIDE, OUT1, OUT2) :-
    override_key(PROFILE, KEY, VALUE, HYP),
    call_goal(DECIDE, HYP, OUT1, OUT2).

what_if_all(PROFILE, OVERRIDES, DECIDE, RESULT) :-
    apply_overrides(OVERRIDES, PROFILE, HYP),
    call_goal(DECIDE, HYP, RESULT).

apply_overrides([], PROFILE, PROFILE).

apply_overrides([[KEY, VALUE]|REST], PROFILE, OUT) :-
    override_key(PROFILE, KEY, VALUE, MID),
    apply_overrides(REST, MID, OUT).

what_if_deltas(PROFILE, KEY, VALUE, CHECKLIST_OF, CHANGED) :-
    call_goal(CHECKLIST_OF, PROFILE, CL_A),
    what_if(PROFILE, KEY, VALUE, CHECKLIST_OF, CL_B),
    diff_checklists(CL_A, CL_B, DELTAS),
    changed_deltas(DELTAS, CHANGED).

override_nth([_|T], N, VALUE, [VALUE|T]) :-
    #=(N, 1).

override_nth([H|T], N, VALUE, [H|T2]) :-
    N > 1,
    #=(N1, N - 1),
    override_nth(T, N1, VALUE, T2).

override_where([H|T], MATCH, VALUE, [VALUE|T]) :-
    matches_elem(MATCH, H).

override_where([H|T], MATCH, VALUE, [H|T2]) :-
    \+ matches_elem(MATCH, H),
    override_where(T, MATCH, VALUE, T2).

matches_elem(MATCH, X) :-
    once(call_goal(MATCH, X)).

what_if_nth(LIST, N, VALUE, DECIDE, RESULT) :-
    override_nth(LIST, N, VALUE, NEW_LIST),
    call_goal(DECIDE, NEW_LIST, RESULT).
