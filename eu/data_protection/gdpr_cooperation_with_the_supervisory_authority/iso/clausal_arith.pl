% SPDX-License-Identifier: EUPL-1.2
% clausal_arith.pl -- arithmetic builtins of the native engine that no ISO
% target supplies, for the .clausal export path.
%
% gcd/3, added 2026-11-13 for the labour working-time weekly limit package
% (rules and tests), to the native semantics measured that day:
%   gcd(A, B, G): A and B integers (big integers included); G is their greatest
%   common divisor, never negative; gcd(0, 0, 0). Anything else FAILS, with no
%   error: a float, an atom, an unbound argument, an unevaluated expression
%   (gcd(6 * 2, 18, G) fails). A bound G must equal the result: gcd(12, 18, 6.0)
%   fails. Not the evaluable gcd/2: Trealla's gives -6 for gcd(-12, -18) and
%   evaluates expressions, which the native builtin does not.
:- module(clausal_arith, [gcd/3]).

gcd(A, B, G) :-
    integer(A), integer(B),
    A1 is abs(A), B1 is abs(B),
    clausal_arith_gcd(A1, B1, G0),
    G = G0.

clausal_arith_gcd(A, 0, A) :- !.
clausal_arith_gcd(A, B, G) :- R is A rem B, clausal_arith_gcd(B, R, G).
