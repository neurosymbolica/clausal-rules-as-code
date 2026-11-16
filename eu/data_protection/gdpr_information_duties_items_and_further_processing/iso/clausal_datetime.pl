% SPDX-License-Identifier: EUPL-1.2
% tools/iso_export/companion/clausal_datetime.pl
% The datetime half of library(datetime) for the Clausal Prolog (.clausal) ISO
% export. Added 2026-11-12 for a package whose
% tests build instants with datetime/7 and the package adds and subtracts
% timedeltas in seconds, and the export had no datetime/7, so the import was
% dropped and every call raised existence_error on Scryer and Trealla.
%
% A SEPARATE companion from clausal_dates.pl on purpose, as clausal_lists_extra
% is from clausal_lists: the seam exporter vendors clausal_dates.pl verbatim
% into every domain, so changing it would move the bytes of every seam export.
% cp_lower.LIBRARY_REMAP sends each library(datetime) name to the first of
% clausal_datetime, clausal_dates that exports it.
%
% Semantics follow the engine (clausal/modules/py/datetime.py, Python's
% datetime), measured on it:
% - The VALUE of a datetime is the arity-6 compound datetime(Y, Mo, D, H, Mi, S);
%   datetime/7 is the CALLABLE, as timedelta(Days, Seconds) is the value for
%   timedelta/3. Whole seconds only: datetime/7 builds no microseconds.
% - A timedelta is normalised as Python's is: 0 =< Seconds < 86400, the days
%   carry the rest. timedelta(0, 259200, T) gives timedelta(3, 0); the negative
%   difference of 3 days 1 second is timedelta(-4, 86399).
% - date_add/3, date_sub/3, date_diff/3 take two datetimes with second
%   resolution, and two dates exactly as clausal_dates does (they delegate).
% - An impossible instant, or a date mixed with a datetime, FAILS where the
%   engine raises: clausal_dates' fail-on-bad-input policy.
% Pure and cut-free. Only exported clausal_dates predicates are used, called
% module-qualified; days_between/3 is imported (Scryer rejects an empty
% import list here) and not redefined.
:- module(clausal_datetime, [datetime/7, timedelta/3, date_add/3, date_sub/3,
                             date_diff/3]).
:- use_module(clausal_dates, [days_between/3]).

datetime(Y, Mo, D, H, Mi, S, DtObj) :-
    var(DtObj),
    clausal_datetime_valid(Y, Mo, D, H, Mi, S),
    DtObj = datetime(Y, Mo, D, H, Mi, S).
datetime(Y, Mo, D, H, Mi, S, DtObj) :-
    nonvar(DtObj),
    DtObj = datetime(Y, Mo, D, H, Mi, S).

% Construct with integer components: normalised. Otherwise plain unification,
% as clausal_dates' timedelta/3: decompose a bound value, or build from
% non-integer components unchanged.
timedelta(Days, Seconds, TdObj) :-
    var(TdObj), integer(Days), integer(Seconds),
    Total is Days * 86400 + Seconds,
    D is Total div 86400,
    S is Total mod 86400,
    TdObj = timedelta(D, S).
timedelta(Days, Seconds, TdObj) :-
    var(TdObj), \+ (integer(Days), integer(Seconds)),
    TdObj = timedelta(Days, Seconds).
timedelta(Days, Seconds, TdObj) :-
    nonvar(TdObj),
    TdObj = timedelta(Days, Seconds).

date_add(Date, TdObj, Result) :-
    clausal_datetime_is_date(Date),
    clausal_dates:date_add(Date, TdObj, Result).
date_add(Datetime, TdObj, Result) :-
    clausal_datetime_seconds(Datetime, T0),
    clausal_datetime_td_seconds(TdObj, Delta),
    T is T0 + Delta,
    clausal_datetime_from_seconds(T, Result).

date_sub(Date, TdObj, Result) :-
    clausal_datetime_is_date(Date),
    clausal_dates:date_sub(Date, TdObj, Result).
date_sub(Datetime, TdObj, Result) :-
    clausal_datetime_seconds(Datetime, T0),
    clausal_datetime_td_seconds(TdObj, Delta),
    T is T0 - Delta,
    clausal_datetime_from_seconds(T, Result).

date_diff(DateA, DateB, TdObj) :-
    clausal_datetime_is_date(DateA), clausal_datetime_is_date(DateB),
    clausal_dates:date_diff(DateA, DateB, TdObj).
date_diff(DatetimeA, DatetimeB, TdObj) :-
    clausal_datetime_seconds(DatetimeA, TA),
    clausal_datetime_seconds(DatetimeB, TB),
    Diff is TA - TB,
    timedelta(0, Diff, TdObj).

% ── private ──────────────────────────────────────────────────────────

clausal_datetime_is_date(X) :- nonvar(X), X = date(_, _, _).

clausal_datetime_valid(Y, Mo, D, H, Mi, S) :-
    integer(H), integer(Mi), integer(S),
    H >= 0, H =< 23, Mi >= 0, Mi =< 59, S >= 0, S =< 59,
    days_between(date(Y, Mo, D), date(1, 1, 1), _).

% Seconds since 0001-01-01T00:00:00. days_between/3 fails on an invalid date.
clausal_datetime_seconds(Dt, T) :-
    nonvar(Dt), Dt = datetime(Y, Mo, D, H, Mi, S),
    clausal_datetime_valid(Y, Mo, D, H, Mi, S),
    days_between(date(Y, Mo, D), date(1, 1, 1), N),
    T is N * 86400 + H * 3600 + Mi * 60 + S.

clausal_datetime_from_seconds(T, datetime(Y, Mo, D, H, Mi, S)) :-
    N is T div 86400,
    R is T mod 86400,
    clausal_dates:date_add(date(1, 1, 1), timedelta(N, 0), date(Y, Mo, D)),
    H is R // 3600,
    Mi is R mod 3600 // 60,
    S is R mod 60.

clausal_datetime_td_seconds(TdObj, T) :-
    nonvar(TdObj), TdObj = timedelta(Days, Seconds),
    integer(Days), integer(Seconds),
    T is Days * 86400 + Seconds.
