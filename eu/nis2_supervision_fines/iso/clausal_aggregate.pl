% SPDX-License-Identifier: EUPL-1.2
% clausal_aggregate.pl -- aggregate_all/3 for the .clausal export path.
%
% The native engine has aggregate_all/3 built in; Scryer has no
% library(aggregate), and Trealla 2.92.3's does not load. Added 2026-11-13 for
% a package using aggregate_all(count, ...), to the
% native semantics measured that day and confirmed by the engine maintainers:
%   count, sum(E), max(E), min(E), bag(T), set(T); nothing else.
%   The goal's solutions are collected with findall/3, in order.
%   sum, max and min EVALUATE E (even a single solution); sum starts from the
%   integer 0; max and min fold with the evaluable max/2 and min/2, so an
%   integer/float tie gives the float, as natively.
%   An empty goal: count 0, sum 0, bag and set []; max and min FAIL.
%   An unbound spec: instantiation_error. Any other spec (count(X), max(X, W),
%   min(X, W), ...): type_error(aggregate, Spec).
% Only the error context differs from native (here the ISO builtin that raised,
% natively aggregate_all/3), which matters only to a catch/3 that matches it.
:- module(clausal_aggregate, [aggregate_all/3]).
:- use_module(library(lists), [length/2]).
:- meta_predicate(aggregate_all(?, 0, ?)).

aggregate_all(Spec, _, _) :- var(Spec), !, throw(error(instantiation_error, aggregate_all/3)).
aggregate_all(count, Goal, Count) :- !,
    findall(x, Goal, Xs), length(Xs, Count0), Count = Count0.
aggregate_all(sum(E), Goal, Sum) :- !,
    findall(E, Goal, Es), clausal_aggregate_sum(Es, 0, Sum0), Sum = Sum0.
aggregate_all(max(E), Goal, Max) :- !,
    findall(E, Goal, [E0|Es]), V0 is E0, clausal_aggregate_max(Es, V0, Max0), Max = Max0.
aggregate_all(min(E), Goal, Min) :- !,
    findall(E, Goal, [E0|Es]), V0 is E0, clausal_aggregate_min(Es, V0, Min0), Min = Min0.
aggregate_all(bag(T), Goal, Bag) :- !,
    findall(T, Goal, Bag0), Bag = Bag0.
aggregate_all(set(T), Goal, Set) :- !,
    findall(T, Goal, Bag), sort(Bag, Set0), Set = Set0.
aggregate_all(Spec, _, _) :- throw(error(type_error(aggregate, Spec), aggregate_all/3)).

clausal_aggregate_sum([], Sum, Sum).
clausal_aggregate_sum([E|Es], Acc, Sum) :- Acc1 is Acc + E, clausal_aggregate_sum(Es, Acc1, Sum).

clausal_aggregate_max([], Max, Max).
clausal_aggregate_max([E|Es], Max0, Max) :- Max1 is max(Max0, E), clausal_aggregate_max(Es, Max1, Max).

clausal_aggregate_min([], Min, Min).
clausal_aggregate_min([E|Es], Min0, Min) :- Min1 is min(Min0, E), clausal_aggregate_min(Es, Min1, Min).
