% thailand — vendored so an exported domain's `-import_from(thailand, [baht, satang])` resolves.
%
% EMPTY EXPORT LIST, ON PURPOSE, and following currency_vocab.pl, which the
% export already vendors in exactly this shape.
%
% The export is LOSSY BY RULING: a unit is discarded at emission and recorded
% in a `% Clausal units:` comment, and dimensional checking stays in Clausal.
% So currency tags (baht, satang) survive into the exported program only as ATOMS in data
% positions — a tag inside an answer term, never a callable and never an
% arithmetic operand. A Prolog atom needs no definition, so there is nothing
% for this module to export.
%
% What it IS for: `-import_from(thailand, [baht, satang])` emits
% a use_module directive naming this file at the staging root, and without a file at that path the
% consuming module does not load at all. Measured 2026-09-13: that was the
% failure, not anything about the atoms themselves.
%
% If a unit ever needs to be COMPUTED with in exported Prolog, this file is
% the wrong answer — arithmetic does not dispatch to predicates and ISO
% evaluable functors are a closed set. The fold in clausal_to_prolog is where
% that is handled.
:- module(thailand, []).
