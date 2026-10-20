:- module(deadline_lib, [deadline/4, date_before/2, date_after/2, date_on_or_before/2, date_on_or_after/2, within_deadline/2, deadline_status/6, days_until_deadline/5, next_day/2, prev_day/2, month_last_day/3, add_business_days/3, business_day_step/3, deadline_months_after/3, deadline_months_result/5]).
:- use_module(library(dif), [dif/2]).

:- use_module('clausal_dates', [timedelta/3, date_add/3, date_sub/3, date_diff/3, weekday/2]).

:- use_module('date_guard', [must_be_date/1]).

:- use_module(library(clpz), [(#=)/2]).

:- set_prolog_flag(double_quotes, chars).

deadline(_NORM_ID, PERIOD_DAYS, TRIGGER_DATE, DEADLINE_DATE) :-
    timedelta(PERIOD_DAYS, 0, DURATION),
    date_add(TRIGGER_DATE, DURATION, DEADLINE_DATE).

date_before(EARLIER, LATER) :-
    must_be_date(EARLIER),
    must_be_date(LATER),
    EARLIER @< LATER.

date_after(LATER, EARLIER) :-
    must_be_date(LATER),
    must_be_date(EARLIER),
    EARLIER @< LATER.

date_on_or_before(EARLIER, LATER) :-
    must_be_date(EARLIER),
    must_be_date(LATER),
    EARLIER @=< LATER.

date_on_or_after(LATER, EARLIER) :-
    must_be_date(LATER),
    must_be_date(EARLIER),
    EARLIER @=< LATER.

within_deadline(EVENT_DATE, DEADLINE_DATE) :-
    date_on_or_before(EVENT_DATE, DEADLINE_DATE).

deadline_status(NORM_ID, PERIOD_DAYS, TRIGGER_DATE, COMPLETION_DATE, _REF, STATUS) :-
    dif(COMPLETION_DATE, "pending"),
    deadline(NORM_ID, PERIOD_DAYS, TRIGGER_DATE, DEADLINE_DATE),
    date_on_or_before(COMPLETION_DATE, DEADLINE_DATE),
    STATUS = "met".

deadline_status(NORM_ID, PERIOD_DAYS, TRIGGER_DATE, COMPLETION_DATE, _REF, STATUS) :-
    dif(COMPLETION_DATE, "pending"),
    deadline(NORM_ID, PERIOD_DAYS, TRIGGER_DATE, DEADLINE_DATE),
    date_after(COMPLETION_DATE, DEADLINE_DATE),
    STATUS = "overdue".

deadline_status(NORM_ID, PERIOD_DAYS, TRIGGER_DATE, "pending", REF_DATE, STATUS) :-
    deadline(NORM_ID, PERIOD_DAYS, TRIGGER_DATE, DEADLINE_DATE),
    date_on_or_before(REF_DATE, DEADLINE_DATE),
    STATUS = "upcoming".

deadline_status(NORM_ID, PERIOD_DAYS, TRIGGER_DATE, "pending", REF_DATE, STATUS) :-
    deadline(NORM_ID, PERIOD_DAYS, TRIGGER_DATE, DEADLINE_DATE),
    date_after(REF_DATE, DEADLINE_DATE),
    STATUS = "overdue".

days_until_deadline(NORM_ID, PERIOD_DAYS, TRIGGER_DATE, REF_DATE, DAYS) :-
    deadline(NORM_ID, PERIOD_DAYS, TRIGGER_DATE, DEADLINE_DATE),
    date_diff(DEADLINE_DATE, REF_DATE, DELTA),
    timedelta(DAYS, _, DELTA).

next_day(DATE, NEXT_DATE) :-
    timedelta(1, 0, ONE_DAY),
    date_add(DATE, ONE_DAY, NEXT_DATE).

prev_day(DATE, PREVIOUS_DATE) :-
    timedelta(1, 0, ONE_DAY),
    date_sub(DATE, ONE_DAY, PREVIOUS_DATE).

month_last_day(YEAR, MONTH, LAST_DAY) :-
    #=(NEXT_MONTH, MONTH mod 12 + 1),
    #=(NEXT_YEAR, YEAR + div(MONTH, 12)),
    FIRST_OF_NEXT = date(NEXT_YEAR, NEXT_MONTH, 1),
    prev_day(FIRST_OF_NEXT, LAST_OF_THIS),
    date(_, _, LAST_DAY) = LAST_OF_THIS.

add_business_days(DATE, 0, DATE).

add_business_days(DATE, DAYS, RESULT) :-
    DAYS > 0,
    next_day(DATE, NEXT_DATE),
    business_day_step(NEXT_DATE, DAYS, RESULT).

business_day_step(DATE, DAYS, RESULT) :-
    weekday(DATE, W),
    W =< 4,
    #=(REMAINING, DAYS - 1),
    add_business_days(DATE, REMAINING, RESULT).

business_day_step(DATE, DAYS, RESULT) :-
    weekday(DATE, W),
    W >= 5,
    add_business_days(DATE, DAYS, RESULT).

deadline_months_after(ANCHOR_DATE, MONTHS, DEADLINE_DATE) :-
    next_day(ANCHOR_DATE, START),
    date(START_YEAR, START_MONTH, START_DAY) = START,
    #=(TOTAL, START_MONTH - 1 + MONTHS),
    #=(TARGET_YEAR, START_YEAR + div(TOTAL, 12)),
    #=(TARGET_MONTH, TOTAL mod 12 + 1),
    month_last_day(TARGET_YEAR, TARGET_MONTH, LAST_DAY),
    deadline_months_result(TARGET_YEAR, TARGET_MONTH, START_DAY, LAST_DAY, DEADLINE_DATE).

deadline_months_result(YEAR, MONTH, DAY, LAST_DAY, RESULT) :-
    DAY =< LAST_DAY,
    CORRESPONDING = date(YEAR, MONTH, DAY),
    prev_day(CORRESPONDING, RESULT).

deadline_months_result(YEAR, MONTH, DAY, LAST_DAY, RESULT) :-
    DAY > LAST_DAY,
    RESULT = date(YEAR, MONTH, LAST_DAY).
