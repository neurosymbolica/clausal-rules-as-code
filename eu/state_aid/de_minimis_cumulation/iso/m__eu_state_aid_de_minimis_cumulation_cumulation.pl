:- module(m__eu_state_aid_de_minimis_cumulation_cumulation, [de_minimis_ceiling/1, de_minimis_ceiling_amount/1, sum_cents/2, is_feb_29/2, lookback_years/1, de_minimis_aid_in_window/3, de_minimis_verdict/3, de_minimis_input_problem/3]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_dicts, [dict_keys/2]).
:- use_module(clausal_lists_extra, [is_list/1]).
:- use_module(library(clpz)).
:- use_module(clausal_dates, [days_between/3]).
:- use_module(m__eu_state_aid_de_minimis_cumulation_citations, [implements/1]).

de_minimis_ceiling(300000, euro).

de_minimis_ceiling(Cents) :-
    implements(eu_reg_2023_2831_art_3_2),
    de_minimis_ceiling(Euro, euro),
    Cents #= Euro * 100.

de_minimis_ceiling_amount(Amount) :-
    implements(eu_reg_2023_2831_art_3_2),
    de_minimis_ceiling(Amount, euro).

sum_cents(List, Sum) :-
    sum_list(List, Sum).

is_feb_29(2, 29).

lookback_years(3).

de_minimis_input_problem(Grants, ReferenceDate, Problem) :-
    findall(Candidate, input_problem_candidate(Grants, ReferenceDate, Candidate), [Problem|_]).

input_problem_candidate(Grants, _, not_ground(grants)) :-
    term_variables(Grants, [_|_]).
input_problem_candidate(_, ReferenceDate, not_ground(reference_date)) :-
    term_variables(ReferenceDate, [_|_]).
input_problem_candidate(Grants, ReferenceDate, wrong_type(reference_date, expected_date)) :-
    ground(Grants),
    ground(ReferenceDate),
    not_a_date(ReferenceDate).
input_problem_candidate(Grants, ReferenceDate, not_a_list(grants)) :-
    ground(Grants),
    ground(ReferenceDate),
    not_a_proper_list(Grants).
input_problem_candidate(Grants, ReferenceDate, Problem) :-
    ground(Grants),
    ground(ReferenceDate),
    is_list(Grants),
    member(Grant, Grants),
    grant_problem(Grant, Problem).

grant_problem(Grant, malformed_grant(Grant)) :-
    not_a_proper_list(Grant).
grant_problem(Grant, malformed_grant(Grant)) :-
    is_list(Grant),
    length(Grant, Length),
    dif(Length, 2).
grant_problem([GrantDate, _], wrong_type(grant_date, expected_date)) :-
    not_a_date(GrantDate).
grant_problem([_, Amount], wrong_type(grant_amount, expected_integer)) :-
    not_an_integer(Amount).
grant_problem([_, Amount], negative_amount(grant_amount)) :-
    is_integer_amount(Amount),
    Amount #< 0.

is_integer_amount(Amount) :-
    integer(Amount).

not_an_integer(Value) :-
    atom(Value).
not_an_integer(Value) :-
    float(Value).
not_an_integer(Value) :-
    compound(Value).
not_an_integer(Value) :-
    dict_keys(Value, _).

is_date(Value) :-
    Value = date(Year, Month, Day),
    integer(Year),
    integer(Month),
    integer(Day).

not_a_date(Value) :-
    functor(Value, Name, Arity),
    dif(Name/Arity, date/3).
not_a_date(Value) :-
    Value = date(Year, Month, Day),
    findall(Component, (member(Component, [Year, Month, Day]), not_an_integer(Component)), [_|_]).

not_a_proper_list(Term) :-
    functor([cell], CellName, CellArity),
    functor(Term, Name, Arity),
    dif(Name/Arity, CellName/CellArity),
    dif(Term, []).
not_a_proper_list([_|Tail]) :-
    not_a_proper_list(Tail).

de_minimis_aid_in_window(Grants, ReferenceDate, TotalCents) :-
    implements(eu_reg_2023_2831_art_3_2),
    implements(eu_reg_2023_2831_art_3_4),
    findall(Problem, input_problem_candidate(Grants, ReferenceDate, Problem), []),
    is_date(ReferenceDate),
    ReferenceDate = date(RefYear, RefMonth, RefDay),
    window_start_3y(RefYear, RefMonth, RefDay, StartYear, StartMonth, StartDay),
    WindowStartObject = date(StartYear, StartMonth, StartDay),
    findall(Amount, (member([GrantDate, Amount], Grants), days_between(ReferenceDate, GrantDate, DaysBeforeRef), DaysBeforeRef #>= 0, days_between(GrantDate, WindowStartObject, DaysAfterStart), DaysAfterStart #> 0), Amounts),
    sum_cents(Amounts, TotalCents).

window_start_3y(RefYear, 2, 29, StartYear, 2, 28) :-
    implements(eu_reg_2023_2831_art_3_2),
    lookback_years(N),
    StartYear #= RefYear - N.
window_start_3y(RefYear, RefMonth, RefDay, StartYear, RefMonth, RefDay) :-
    implements(eu_reg_2023_2831_art_3_2),
    is_feb_29(FebruaryMonth, FebruaryDay),
    dif(RefMonth - RefDay, FebruaryMonth - FebruaryDay),
    lookback_years(N),
    StartYear #= RefYear - N.

cumulated_aid_within_ceiling(TotalCents) :-
    implements(eu_reg_2023_2831_art_3_2),
    de_minimis_ceiling(Ceiling),
    TotalCents #=< Ceiling.

cumulated_aid_exceeds_ceiling(TotalCents) :-
    implements(eu_reg_2023_2831_art_3_7),
    de_minimis_ceiling(Ceiling),
    TotalCents #> Ceiling.

de_minimis_verdict(Grants, ReferenceDate, eligible) :-
    implements(eu_reg_2023_2831_art_3_1),
    implements(eu_reg_2023_2831_art_3_2),
    de_minimis_aid_in_window(Grants, ReferenceDate, TotalCents),
    cumulated_aid_within_ceiling(TotalCents).
de_minimis_verdict(Grants, ReferenceDate, ineligible) :-
    implements(eu_reg_2023_2831_art_3_1),
    implements(eu_reg_2023_2831_art_3_2),
    de_minimis_aid_in_window(Grants, ReferenceDate, TotalCents),
    cumulated_aid_exceeds_ceiling(TotalCents).
de_minimis_verdict(Grants, ReferenceDate, indeterminate) :-
    de_minimis_input_problem(Grants, ReferenceDate, _).

no_statute("sum_cents", 2, "computation_helper").
no_statute("de_minimis_input_problem", 3, "computation_helper").
no_statute("input_problem_candidate", 3, "computation_helper").
no_statute("grant_problem", 2, "computation_helper").
no_statute("is_integer_amount", 1, "computation_helper").
no_statute("is_date", 1, "computation_helper").
no_statute("not_an_integer", 1, "computation_helper").
no_statute("not_a_date", 1, "computation_helper").
no_statute("not_a_proper_list", 1, "computation_helper").
