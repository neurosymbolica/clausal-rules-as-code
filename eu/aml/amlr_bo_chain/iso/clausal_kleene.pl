% tools/iso_export/companion/clausal_kleene.pl
% Generated-companion of clausal.stdlib.kleene (source:
% clausal/clausal/stdlib/kleene.clausal). Pure, cut-free, ->-free.
% Strong-Kleene three-valued (K3) connectives ported row-for-row from the
% Clausal source: True->true, False->false, Undefined->undefined. The 9-row
% and3/or3 tables are copied verbatim (deliberately no wildcard short-circuit
% rows -- overlapping clauses would break disjointness). and4/and5/or4/or5
% fold the binary table left-to-right through fresh intermediates, exactly as
% kleene.clausal's and4..and9/or4..or9 do. and3_list/or3_list fold with the
% empty list as unit (true for and, false for or), also exactly as the
% Clausal source defines them.
:- module(clausal_kleene, [and3/3, and4/4, and5/5, or3/3, or4/4, or5/5,
                           and3_list/2, or3_list/2]).

and3(true, true, true).
and3(true, false, false).
and3(true, undefined, undefined).
and3(false, true, false).
and3(false, false, false).
and3(false, undefined, false).
and3(undefined, true, undefined).
and3(undefined, false, false).
and3(undefined, undefined, undefined).

or3(true, true, true).
or3(true, false, true).
or3(true, undefined, true).
or3(false, true, true).
or3(false, false, false).
or3(false, undefined, undefined).
or3(undefined, true, true).
or3(undefined, false, undefined).
or3(undefined, undefined, undefined).

and4(A, B, C, R) :- and3(A, B, AB), and3(AB, C, R).
and5(A, B, C, D, R) :- and3(A, B, AB), and3(AB, C, ABC), and3(ABC, D, R).

or4(A, B, C, R) :- or3(A, B, AB), or3(AB, C, R).
or5(A, B, C, D, R) :- or3(A, B, AB), or3(AB, C, ABC), or3(ABC, D, R).

and3_list([], true).
and3_list([X|Xs], R) :- and3_list(Xs, R1), and3(X, R1, R).

or3_list([], false).
or3_list([X|Xs], R) :- or3_list(Xs, R1), or3(X, R1, R).
