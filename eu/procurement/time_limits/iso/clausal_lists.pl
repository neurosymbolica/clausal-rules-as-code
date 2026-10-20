% tools/iso_export/companion/clausal_lists.pl
% Generated-companion supplying the list ENGINE builtins that Scryer has no
% library for at all. Trealla has them built in, so the failure is
% engine-asymmetric and shows up at CALL time (G3), never at consult time
% (G2) -- the same class as export.py's LIBRARY_INJECTIONS, one step further
% out: there is no library(...) to import from on the Scryer side, so a
% companion has to carry the definition. Measured 2026-09-06 (Phase D
% residue "missing ISO/library builtin"):
%
%   Scryer  msort([b,a,a],X)              -> existence_error(procedure, msort/2)
%   Scryer  use_module(library(lists)), msort(...) -> the same error
%   Trealla msort([b,a,a],X)              -> X = [a,a,b]
%
% Pure, cut-free, ->-free, same style as clausal_profiles.pl. No .clausal
% source ever -import_from's this module (the builtins are globally available
% in Clausal); it is reached only through export.py's COMPANION_INJECTIONS,
% and export.py's COMPANION_SIGNATURES entry is kept in step with the export
% list below.
%
% msort/2 mirrors the engine's _msort__2 (clausal/logic/builtins/lists.py):
% Sorted is List in standard order of terms, DUPLICATES PRESERVED -- that is
% the one thing separating it from ISO sort/2 (8.4.3), which drops them. The
% definition delegates the ordering itself to ISO keysort/2 (8.4.4): each
% element is paired with itself as its own key, keysort orders the pairs by
% key in standard order and is STABLE, and the pairs are unwrapped again.
% Ordering therefore comes from the host engine's standard order, exactly as
% sort/2's would, and nothing here re-implements term comparison.
:- module(clausal_lists, [msort/2]).

msort(List, Sorted) :-
    msort_self_keyed(List, Keyed),
    keysort(Keyed, SortedKeyed),
    msort_unkeyed(SortedKeyed, Sorted).

msort_self_keyed([], []).
msort_self_keyed([X|Xs], [X-X|Ks]) :- msort_self_keyed(Xs, Ks).

msort_unkeyed([], []).
msort_unkeyed([_-X|Ks], [X|Xs]) :- msort_unkeyed(Ks, Xs).
