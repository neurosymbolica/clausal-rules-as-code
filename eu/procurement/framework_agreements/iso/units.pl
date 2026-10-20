% units — vendored so an exported domain's `-import_from(units, [percent])`
% resolves, and (since 2026-09-17) so that `quantity_number/2` has a definition
% on the Prolog side.
%
% TWO DIFFERENT THINGS CROSS INTO THE EXPORT, and only one of them needs code.
%
% 1. A unit as a TAG. The export is LOSSY BY RULING: a unit is discarded at
%    emission and recorded in a `% Clausal units:` comment, and dimensional
%    checking stays in Clausal. So ratio units (percent, basis_point) survive
%    only as ATOMS in data positions — a tag inside an answer term, never a
%    callable and never an arithmetic operand. A Prolog atom needs no
%    definition, which is why this module's export list was empty until now.
%    What it was for is the PATH: the import emits a use_module naming this
%    file at the staging root, and with no file there the CONSUMING module does
%    not load at all. Measured 2026-09-13: that was the failure, not anything
%    about the atoms.
%
% 2. A quantity as a TRANSFER TERM. `quantity(Magnitude, unit(Ratio, Dims))`,
%    per the engine lane's transfer-form design (2026-09-16 §4). That is a
%    compound term a predicate CAN unpack, so this half is real code.
%
% REFERENCE SEMANTICS, handed over verbatim by the engine lane because this
% file is outside their information barrier: "For a Prolog with no units,
% Number is the magnitude scaled to the standard unit for those dimensions,
% i.e. Magnitude x Ratio with the unit discarded."
%
% `is/2` IS CORRECT HERE, and that is not an oversight. The pure `.clausal`
% dialect excludes `is/2` because it is one-directional and compares by
% unification; this file is not that dialect — it is plain ISO Prolog vendored
% into an export, where `is/2` is the right evaluator. Do not "fix" it to `#=`:
% that would pull `library(clpz)` into every domain that mentions a unit, and
% clpz is integers-only while a Ratio is routinely rational.
%
% MEASURED IN BOTH ENGINES, 2026-09-17 — and they AGREE, which is why this is
% one portable file rather than the per-dialect pair the constants prelude
% needs:
%
%     300 * (1 rdiv 10000)        -> 3 rdiv 100     exact, both
%     25000 * (1 rdiv 100)        -> 250            normalises to integer, both
%     rdiv(1,10000) == 1 rdiv 10000                 same term, both
%     300 * 1 / 10000             -> 0.03           the FLOAT TRAP, avoided
%
% The last line is why the arithmetic is `Magnitude * Ratio` and never a
% division: `/` returns a float in both engines and silently destroys
% exactness, which is the whole property a statutory computation needs.
%
% CUT-FREE AND `->`-FREE, as every companion in this directory is. The mode and
% shape guards below are mutually exclusive by construction (`var`/`nonvar`
% plus a negated shape test), so no cut is needed to stop a spurious second
% solution on backtracking.
%
% KNOWN GAP, deliberately loud rather than handled: a Magnitude that arrives as
% a `decimal(Mantissa, Scale)` transfer term is not evaluable, so `is/2` raises
% `type_error(evaluable, decimal/2)`. That is the right direction — a wrong
% number would be far worse — but it is a refusal, not support. Close it when
% the decimal transfer form actually reaches the export; no corpus site emits
% one today.
:- module(units, [quantity_number/2]).

%% quantity_number(?Term, ?Number)
%
%  True when Number is Term's magnitude scaled to the standard unit for its
%  dimensions. Modes: (+,-) computes; (+,+) checks NUMERICALLY (so a written
%  `300 basis_point` and a written `3 percent` both relate to the same Number);
%  (-,-) raises instantiation_error; a bound but malformed Term raises
%  type_error(quantity, Term) — RAISED, never a quiet failure, because a
%  malformed term that failed silently is the "goal just stops holding" shape.
%  A bound Number that simply does not match FAILS, without an error: the
%  relation does not hold, which is not an error.
quantity_number(Term, Number) :-
    quantity_parts_(Term, Magnitude, Ratio),
    Value is Magnitude * Ratio,
    quantity_match_(Number, Value).

quantity_parts_(Term, _, _) :-
    var(Term),
    throw(error(instantiation_error, quantity_number/2)).
quantity_parts_(quantity(Magnitude, Unit), Magnitude, Ratio) :-
    quantity_ratio_(Unit, Ratio, quantity(Magnitude, Unit)).
quantity_parts_(Term, _, _) :-
    nonvar(Term),
    \+ Term = quantity(_, _),
    throw(error(type_error(quantity, Term), quantity_number/2)).

quantity_ratio_(Unit, _, _) :-
    var(Unit),
    throw(error(instantiation_error, quantity_number/2)).
quantity_ratio_(unit(Ratio, _Dimensions), Ratio, _).
quantity_ratio_(Unit, _, Term) :-
    nonvar(Unit),
    \+ Unit = unit(_, _),
    throw(error(type_error(quantity, Term), quantity_number/2)).

quantity_match_(Number, Value) :-
    var(Number),
    Number = Value.
quantity_match_(Number, Value) :-
    nonvar(Number),
    Number =:= Value.
