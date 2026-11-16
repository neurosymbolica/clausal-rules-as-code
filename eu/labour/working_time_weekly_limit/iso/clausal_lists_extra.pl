% SPDX-License-Identifier: EUPL-1.2
% tools/iso_export/companion/clausal_lists_extra.pl
% List predicates the Clausal Prolog (.clausal) ISO export needs that Scryer's
% library(lists) lacks (Trealla has them built in): sizing doc 2026-10-07, step 9.
% A SEPARATE companion from clausal_lists.pl on purpose: the seam exporter
% vendors clausal_lists.pl verbatim into every domain, so extending it moved
% 75 seam staged files (A/B 2026-10-07). Only the .clausal path ships this one.
% Cut-free.
:- module(clausal_lists_extra, [last/2, subtract/3, intersection/3, is_list/1,
                                min_list/2, max_list/2, drop/3]).
:- use_module(library(lists), [memberchk/2]).

last([X], X).
last([_|T], X) :- last(T, X).

subtract([], _, []).
subtract([X|T], L, R) :- memberchk(X, L), subtract(T, L, R).
subtract([X|T], L, [X|R]) :- \+ memberchk(X, L), subtract(T, L, R).

intersection([], _, []).
intersection([X|T], L, [X|R]) :- memberchk(X, L), intersection(T, L, R).
intersection([X|T], L, R) :- \+ memberchk(X, L), intersection(T, L, R).

is_list(X) :- nonvar(X), clausal_lists_extra_proper(X).

clausal_lists_extra_proper([]).
clausal_lists_extra_proper([_|T]) :- nonvar(T), clausal_lists_extra_proper(T).

% min_list/2, max_list/2: Scryer's library(lists) lacks them (existence_error,
% measured 2026-10-20 on the time_limits pilot); ISO min/max evaluables, cut-free.
min_list([X|Xs], M) :- clausal_lists_extra_min(Xs, X, M).
clausal_lists_extra_min([], M, M).
clausal_lists_extra_min([X|Xs], M0, M) :- M1 is min(M0, X), clausal_lists_extra_min(Xs, M1, M).

max_list([X|Xs], M) :- clausal_lists_extra_max(Xs, X, M).
clausal_lists_extra_max([], M, M).
clausal_lists_extra_max([X|Xs], M0, M) :- M1 is max(M0, X), clausal_lists_extra_max(Xs, M1, M).

% drop/3: the engine's _drop__3 (clausal/logic/builtins/lists.py). Rest is List
% without its first N elements; N =< 0 keeps the whole list, N past the end
% gives []. Fails unless N is an integer and List a proper list. Neither
% Scryer nor Trealla has it: existence_error on both, measured 2026-11-12.
drop(N, List, Rest) :-
    integer(N), is_list(List),
    clausal_lists_extra_drop(N, List, Rest0),
    Rest = Rest0.
clausal_lists_extra_drop(N, L, L) :- N =< 0.
clausal_lists_extra_drop(N, [], []) :- N > 0.
clausal_lists_extra_drop(N, [_|T], R) :- N > 0, N1 is N - 1, clausal_lists_extra_drop(N1, T, R).
