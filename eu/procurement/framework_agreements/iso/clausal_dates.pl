% tools/iso_export/companion/clausal_dates.pl
% Generated-companion for the `date_time` seam: 22 corpus domains
% import predicates from
% `-import_from(date_time, [...])`, and `date_time` is a Clausal ENGINE
% module (clausal/modules/py/datetime.py wrapping real Python
% datetime.date), not a kit `.clausal` -- so there is nothing for the
% translator to vendor by translation. This file is handwritten, ported
% from that module's semantics, and exports exactly the SURVEYED subset:
% grep -rn "import_from(date_time" over the 22 domains' .clausal (source
% and tests) requests exactly these eight names -- date, timedelta,
% date_add, date_sub, date_diff, days_between, weekday, date_between.
% date_min and date_max were added 2026-10-02 (eu/procurement/
% remedies_ineffectiveness imports date_min; they RAISE on a non-date -- see
% their own comment below).
% Pure, cut-free, ->-free (`;` and `\+` are used -- see purity note below).
%
% date/3 IS NOT EXPORTED. In the Clausal engine, `date` is a plain Python
% function (clausal/modules/py/datetime.py, `def date(year, month, day)`)
% -- it is never registered as a ModulePredicate, so it can never appear as
% a CALLED goal in Clausal source; it exists only inside `is`/expression
% position, e.g. `OBJ is date(Y, M, D)`. The translator maps Clausal's `is`
% to ISO `=` (clausal_to_prolog.py:_convert_compare, the `Is` case) -- so
% every one of those sites becomes a plain ISO unification against the bare
% compound term `date(Y, M, D)`, never a predicate call. Measured on all 91
% corpus .clausal files that import date_time: zero call sites of the shape
% `date(...)` outside `is`/argument position. A bare compound term needs no
% import to construct or pattern-match in ISO Prolog, so `date` is safe to
% drop from the export list entirely -- the exporter's own signature
% filtering already turns a `[date]`-only import into a no-op comment (see
% export.py's `_import_list`: a requested name absent from the signature
% set contributes nothing, and an import list that fully empties out is
% rendered as `% skipped: ...` rather than a use_module line), and silently
% drops `date` from any COMBINED request (`[date, timedelta, ...]`) without
% touching the other names. Both behaviours were exercised in this task's
% RED/GREEN run.
%
% DIVERGENCE FROM CLAUSAL (documented per task-6 NOTE): constructing a real
% `datetime.date` in Clausal validates the calendar (`date(2025, 2, 29)`
% RAISES `domain_error(date, ...)` -- see clausal/modules/py/datetime.py's
% `date()`, and the standing ruling that bad dates raise, fail fast). A
% bare ISO compound `date(Y, M, D) = ...` cannot be intercepted by this
% file -- the translator emits a plain `=`, not a call this module could
% guard -- so THAT construction site never validates in the exported
% program; this is an accepted, unavoidable gap (the brief's "if the survey
% shows a predicate whose Clausal semantics cannot be purely reproduced,
% document the divergence" case). What this file DOES control is every
% predicate below: each one that consumes a `date(Y, M, D)` argument routes
% it through `to_ordinal/2`, which calls `valid_date/3` first -- an
% out-of-range or non-integer component makes the whole goal FAIL (no
% solutions), never raise and never silently compute a wrong answer. That
% is the ISO-safe half of "fail (not succeed wrongly) on bad dates" the
% brief asks for; the other half (the bare `=` site) is out of reach by
% construction, not by omission.
%
% Timedelta representation: `timedelta(Days, Seconds)` (arity 2) is the
% VALUE -- a plain compound, since ISO has no foreign timedelta object --
% distinct from `timedelta/3` (arity 3) below, the CALLABLE the corpus
% imports. Every construct call the survey found passes `Seconds = 0`
% literally (`timedelta(N, 0, TD)`); every decompose call discards it
% (`timedelta(DAYS, _, TD)`). `date_add/3` and `date_sub/3` only use the
% Days component, matching Python (`date + timedelta` uses `timedelta.days`
% only -- a plain `date` has no sub-day resolution).
%
% Ordinal arithmetic: `to_ordinal/2` and `from_ordinal/2` implement the
% same proleptic-Gregorian ordinal CPython's `datetime` module uses
% internally (`_ord2ymd`/`_ymd2ord`) -- ordinal 1 is 0001-01-01, a Monday,
% which is why `weekday/2` is `(Ordinal - 1) mod 7`. Both directions were
% cross-checked against Python's own `datetime.date.toordinal()` /
% `.weekday()` for the leap-year and end-of-month cases exercised in
% companion_tests.pl (see that file's comments for the checked values).
% `//` and `mod` are only ever applied to non-negative operands here (every
% corpus year is >= 1), so the ISO-implementation-defined rounding
% direction of `//` cannot matter -- floor and truncate agree when both
% operands are non-negative.
:- module(clausal_dates, [timedelta/3, date_add/3, date_sub/3, date_diff/3,
                          days_between/3, weekday/2, date_between/3,
                          date_min/3, date_max/3]).

% ── calendar helpers (private) ───────────────────────────────────────

is_leap(Y) :-
    0 is Y mod 4,
    ( 0 =\= Y mod 100 ; 0 is Y mod 400 ).

days_in_month(_, 1, 31).
days_in_month(Y, 2, 29) :- is_leap(Y).
days_in_month(Y, 2, 28) :- \+ is_leap(Y).
days_in_month(_, 3, 31).
days_in_month(_, 4, 30).
days_in_month(_, 5, 31).
days_in_month(_, 6, 30).
days_in_month(_, 7, 31).
days_in_month(_, 8, 31).
days_in_month(_, 9, 30).
days_in_month(_, 10, 31).
days_in_month(_, 11, 30).
days_in_month(_, 12, 31).

valid_date(Y, M, D) :-
    integer(Y), integer(M), integer(D),
    M >= 1, M =< 12,
    D >= 1,
    days_in_month(Y, M, DaysInM),
    D =< DaysInM.

% ── date(Y, M, D) <-> proleptic-Gregorian ordinal (private) ─────────

days_before_year(Y, N) :-
    Y1 is Y - 1,
    N is Y1 * 365 + Y1 // 4 - Y1 // 100 + Y1 // 400.

days_before_month(_, 1, 0).
days_before_month(Y, M, N) :-
    M > 1, M =< 12,
    M1 is M - 1,
    days_before_month(Y, M1, N1),
    days_in_month(Y, M1, DaysInM1),
    N is N1 + DaysInM1.

to_ordinal(date(Y, M, D), N) :-
    valid_date(Y, M, D),
    days_before_year(Y, YearDays),
    days_before_month(Y, M, MonthDays),
    N is YearDays + MonthDays + D.

% doy_to_md(Y, DayOfYear, M, D): 1-based day-of-year -> month/day, seeding
% the walk at January (doy_to_md_from/5 does the actual recursion).
doy_to_md(Y, DayOfYear, M, D) :-
    doy_to_md_from(Y, DayOfYear, 1, M, D).

% doy_to_md_from(Y, DayOfYear, Mo0, M, D): walk months from Mo0. Two
% disjoint clauses (DayOfYear inside/outside the current month), cut-free,
% terminating because DayOfYear strictly decreases and Mo0 strictly
% increases each recursive step.
doy_to_md_from(Y, DayOfYear, Mo, Mo, DayOfYear) :-
    days_in_month(Y, Mo, DaysInMo),
    DayOfYear =< DaysInMo.
doy_to_md_from(Y, DayOfYear, Mo0, M, D) :-
    days_in_month(Y, Mo0, DaysInMo0),
    DayOfYear > DaysInMo0,
    Mo0 < 12,
    Rest is DayOfYear - DaysInMo0,
    Mo1 is Mo0 + 1,
    doy_to_md_from(Y, Rest, Mo1, M, D).

% from_ordinal(N, date(Y, M, D)): the block-reduction algorithm CPython's
% `_ord2ymd` uses (400/100/4/1-year blocks), restated in ISO arithmetic.
% Two disjoint clauses on the "century/4-year block boundary" case, cut-free
% by construction. N is always produced by this module as a valid ordinal
% (an offset from a `to_ordinal/2` result), so no separate validity check
% is needed on the way back.
from_ordinal(N, date(Y, M, D)) :-
    integer(N),
    N0 is N - 1,
    N400 is N0 // 146097,
    R1 is N0 mod 146097,
    N100 is R1 // 36524,
    R2 is R1 mod 36524,
    N4 is R2 // 1461,
    R3 is R2 mod 1461,
    N1 is R3 // 365,
    ( N1 =:= 4 ; N100 =:= 4 ),
    Y is N400 * 400 + N100 * 100 + N4 * 4 + N1,
    M = 12, D = 31.
from_ordinal(N, date(Y, M, D)) :-
    integer(N),
    N0 is N - 1,
    N400 is N0 // 146097,
    R1 is N0 mod 146097,
    N100 is R1 // 36524,
    R2 is R1 mod 36524,
    N4 is R2 // 1461,
    R3 is R2 mod 1461,
    N1 is R3 // 365,
    R4 is R3 mod 365,
    \+ (N1 =:= 4 ; N100 =:= 4),
    Y is N400 * 400 + N100 * 100 + N4 * 4 + N1 + 1,
    DayOfYear is R4 + 1,
    doy_to_md(Y, DayOfYear, M, D).

% ── exported predicates ──────────────────────────────────────────────

% timedelta/3: bidirectional by plain unification against the arity-2
% VALUE term -- construct when TdObj is unbound, decompose when it is
% bound. See the file header for why one fact suffices.
timedelta(Days, Seconds, timedelta(Days, Seconds)).

% date_add/3: Result = Date + Timedelta (days component only, matching
% Python's `date.__add__`).
date_add(Date, TdObj, Result) :-
    to_ordinal(Date, N0),
    timedelta(Days, _Seconds, TdObj),
    N is N0 + Days,
    from_ordinal(N, Result).

% date_sub/3: Result = Date - Timedelta (days component only).
date_sub(Date, TdObj, Result) :-
    to_ordinal(Date, N0),
    timedelta(Days, _Seconds, TdObj),
    N is N0 - Days,
    from_ordinal(N, Result).

% date_diff/3: Timedelta = DateA - DateB, in whole days (Seconds always 0
% -- both operands are dates, never a sub-day value).
date_diff(DateA, DateB, timedelta(Days, 0)) :-
    to_ordinal(DateA, NA),
    to_ordinal(DateB, NB),
    Days is NA - NB.

% days_between/3: N = whole days in DateA - DateB. The one-goal form of
% `date_diff(A, B, TD), timedelta(N, _, TD)`, matching the engine doc.
days_between(DateA, DateB, N) :-
    to_ordinal(DateA, NA),
    to_ordinal(DateB, NB),
    N is NA - NB.

% weekday/2: Weekday = Date.weekday() (0 = Monday .. 6 = Sunday). Ordinal 1
% (0001-01-01) is a Monday in the proleptic Gregorian calendar.
weekday(Date, Weekday) :-
    to_ordinal(Date, N),
    Weekday is (N - 1) mod 7.

% date_between/3: nondeterministic -- one solution per date in [Start, End]
% inclusive, walking the ordinal range. Fails outright (no solutions) when
% Start is after End, matching the engine's zero-iteration `while` loop.
date_between(Start, End, D) :-
    to_ordinal(Start, OrdStart),
    to_ordinal(End, OrdEnd),
    ordinal_between(OrdStart, OrdEnd, OrdD),
    from_ordinal(OrdD, D).

% date_min/3, date_max/3: Min/Max = the earlier/later of two dates. Added
% 2026-10-02 when eu/procurement/remedies_ineffectiveness's G3 raised
% existence_error(procedure, date_min/3): the corpus imports date_min from
% date_time, this file did not export it, and the signature filter dropped
% the name from the import list WITHOUT a G1 finding.
%
% These two RAISE on a non-date, unlike the FAIL-on-bad-date predicates
% above (the same rule as kit/date_guard's
% must_be_date/1): a guard that fails turns `\+ date_min(...)` into a silent
% verdict. Standard order is chronological on date(Y, M, D) with integer
% components, and only there -- hence the guard on BOTH operands BEFORE the
% comparison. The result is unified LAST: a head like `date_min(A, B, A)`
% would let a bound Min bind an unbound operand and pass the guard.
% Calendar validity is not checked (date(2025, 2, 30) orders as its
% components say), as in kit/date_guard.
date_min(A, B, Min) :-
    dates_must_be_date(A), dates_must_be_date(B),
    A @=< B, Min = A.
date_min(A, B, Min) :-
    dates_must_be_date(A), dates_must_be_date(B),
    B @< A, Min = B.

date_max(A, B, Max) :-
    dates_must_be_date(A), dates_must_be_date(B),
    B @=< A, Max = A.
date_max(A, B, Max) :-
    dates_must_be_date(A), dates_must_be_date(B),
    A @< B, Max = B.

% dates_must_be_date/1 (private): kit/date_guard's must_be_date/1, restated
% here because this companion is handwritten, not vendored from the kit. ISO
% must_be/2 convention: not ground -> instantiation_error; ground but not
% date(Y, M, D) with integer components -> type_error(date, X). `ground` is
% tested first so the date(_, _, _) match can never bind an unbound X.
% Three disjoint, cut-free clauses.
dates_must_be_date(X) :-
    \+ ground(X),
    throw(error(instantiation_error, must_be_date(X))).
dates_must_be_date(X) :-
    ground(X),
    dates_is_date(X).
dates_must_be_date(X) :-
    ground(X),
    \+ dates_is_date(X),
    throw(error(type_error(date, X), must_be_date(X))).

dates_is_date(date(Y, M, D)) :- integer(Y), integer(M), integer(D).

ordinal_between(N, End, N) :- N =< End.
ordinal_between(N, End, D) :-
    N < End,
    N1 is N + 1,
    ordinal_between(N1, End, D).
