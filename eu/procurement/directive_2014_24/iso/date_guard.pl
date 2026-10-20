:- module(date_guard, [must_be_date/1]).

:- set_prolog_flag(double_quotes, chars).

must_be_date(X) :-
    \+ ground(X),
    throw(error(instantiation_error, must_be_date(X))).

must_be_date(X) :-
    ground(X),
    date(Y, M, D) = X,
    integer(Y),
    integer(M),
    integer(D).

must_be_date(X) :-
    ground(X),
    \+ (date(Y, M, D) = X, integer(Y), integer(M), integer(D)),
    throw(error(type_error(date, X), must_be_date(X))).
