% SPDX-License-Identifier: EUPL-1.2
% tools/iso_export/companion/clausal_lists_extra.pl
% List predicates the Clausal Prolog (.clausal) ISO export needs that Scryer's
% library(lists) lacks (Trealla has them built in): sizing doc 2026-10-07, step 9.
% A SEPARATE companion from clausal_lists.pl on purpose: the seam exporter
% vendors clausal_lists.pl verbatim into every domain, so extending it moved
% 75 seam staged files (A/B 2026-10-07). Only the .clausal path ships this one.
% Cut-free.
%
% clausal_is_list/1 and clausal_msort/2 carry the engine's is_list/1 and
% msort/2 under names of this module's own: the export respells each goal and
% closure call to them (cp_lower.COMPANION_RENAMES). Under the builtin names,
% upstream Trealla (v3.15.20, 9ac861d) prints "Warning: overwriting
% 'is_list'/1" and "'msort'/2" on loading a file that defines them, which the
% consult gate reads as a finding, while Scryer (-137 and -369) supplies
% neither, in no library, and has no conditional loading (:- if/1 is a
% domain_error), so one file cannot import them on one target and define them
% on another. The same clauses run on every target, as before (measured
% 2026-11-16: Trealla ran this module's definitions under the old names too).
:- module(clausal_lists_extra, [last/2, subtract/3, intersection/3, clausal_is_list/1,
                                clausal_msort/2, min_list/2, max_list/2, drop/3]).
:- use_module(library(lists), [memberchk/2]).

last([X], X).
last([_|T], X) :- last(T, X).

subtract([], _, []).
subtract([X|T], L, R) :- memberchk(X, L), subtract(T, L, R).
subtract([X|T], L, [X|R]) :- \+ memberchk(X, L), subtract(T, L, R).

intersection([], _, []).
intersection([X|T], L, [X|R]) :- memberchk(X, L), intersection(T, L, R).
intersection([X|T], L, R) :- \+ memberchk(X, L), intersection(T, L, R).

clausal_is_list(X) :- nonvar(X), clausal_lists_extra_proper(X).

clausal_lists_extra_proper([]).
clausal_lists_extra_proper([_|T]) :- nonvar(T), clausal_lists_extra_proper(T).

% clausal_msort/2: clausal_lists.pl's msort/2 (the engine's _msort__2:
% standard order, DUPLICATES PRESERVED), by the same stable ISO keysort/2 on
% self-keyed pairs. Copied, not imported: loading clausal_lists.pl defines
% msort/2 under its builtin name. clausal_lists.pl itself is unchanged, as the
% seam exporter vendors it verbatim.
clausal_msort(List, Sorted) :-
    clausal_lists_extra_self_keyed(List, Keyed),
    keysort(Keyed, SortedKeyed),
    clausal_lists_extra_unkeyed(SortedKeyed, Sorted).
clausal_lists_extra_self_keyed([], []).
clausal_lists_extra_self_keyed([X|Xs], [X-X|Ks]) :- clausal_lists_extra_self_keyed(Xs, Ks).
clausal_lists_extra_unkeyed([], []).
clausal_lists_extra_unkeyed([_-X|Ks], [X|Xs]) :- clausal_lists_extra_unkeyed(Ks, Xs).

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
% Scryer nor Trealla has it: existence_error on both, measured 2026-11-12
% (a NIS2 supervision fines package, test_output_mode).
drop(N, List, Rest) :-
    integer(N), clausal_is_list(List),
    clausal_lists_extra_drop(N, List, Rest0),
    Rest = Rest0.
clausal_lists_extra_drop(N, L, L) :- N =< 0.
clausal_lists_extra_drop(N, [], []) :- N > 0.
clausal_lists_extra_drop(N, [_|T], R) :- N > 0, N1 is N - 1, clausal_lists_extra_drop(N1, T, R).
