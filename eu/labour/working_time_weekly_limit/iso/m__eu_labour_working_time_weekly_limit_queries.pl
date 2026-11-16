% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_labour_working_time_weekly_limit_queries, [working_time_weekly_limit_profile_keys/1, working_time_weekly_limit_what_if/4, working_time_weekly_limit_maximum_counted_minutes/6, reference_period_basis/0, on_call_on_site_counts_as_working_time/0, on_call_standby_counts_as_working_time/0, member_state_uses_article_22_option/0, worker_agreement_to_exceed_obtained_first/0, member_state_reference_period/0, derogation_under_article_17_3_or_article_18/0, collective_agreement_under_article_19/0, offshore_work_under_article_20_2/0, work/0, on_call_on_site/0, on_call_standby/0, paid_annual_leave/0, sick_leave/0, unsure/0, minutes_per_seven_days/2, indeterminate/1, needs_legal_review/2, open_textured/2, inputs_relied_on/1, provenance/2, input_problems/1, unknown_key/1, wrong_type/1, duplicate_key/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(library(reif), [(=)/3]).
:- use_module(clausal_lists_extra, [is_list/1]).
:- use_module(library(clpz)).
:- use_module(library(reif), [if_/3]).
:- use_module(clausal_dates, [days_between/3]).
:- use_module(formalize_lib, [not_member/2]).
:- use_module(m__eu_labour_working_time_weekly_limit_kernel, [working_time_weekly_limit_input_problems/2]).
:- use_module(m__eu_labour_working_time_weekly_limit_citations, [implements/1]).
:- use_module(m__eu_labour_working_time_weekly_limit_working_time_weekly_limit, [decide_working_time_weekly_limit/2, weekly_working_time_average/6]).

reference_period_basis.

on_call_on_site_counts_as_working_time.

on_call_standby_counts_as_working_time.

member_state_uses_article_22_option.

worker_agreement_to_exceed_obtained_first.

member_state_reference_period.

derogation_under_article_17_3_or_article_18.

collective_agreement_under_article_19.

offshore_work_under_article_20_2.

work.

on_call_on_site.

on_call_standby.

paid_annual_leave.

sick_leave.

unsure.

minutes_per_seven_days(Numerator, Denominator) :-
    integer(Numerator),
    integer(Denominator),
    Numerator #>= 0,
    Denominator #>= 1.

indeterminate([MissingKey]) :-
    contract_key_list(ContractKeys),
    member(MissingKey, ContractKeys).

needs_legal_review(open_textured(InputKey, cite(CitationKey)), [inputs_relied_on(Pairs)]) :-
    atom(InputKey),
    atom(CitationKey),
    is_list(Pairs).
needs_legal_review(open_textured(InputKey, cite(CitationKey)), [inputs_relied_on(Pairs), provenance(Clause, Citations)]) :-
    atom(InputKey),
    atom(CitationKey),
    is_list(Pairs),
    provenance(Clause, Citations).

open_textured(InputKey, cite(CitationKey)) :-
    atom(InputKey),
    atom(CitationKey).

inputs_relied_on(Pairs) :-
    is_list(Pairs).

provenance(Clause, Citations) :-
    atom(Clause),
    is_list(Citations).

input_problems([Problem|Problems]) :-
    nonvar(Problem),
    is_list(Problems).

unknown_key(Key) :-
    ground(Key),
    contract_key_list(ContractKeys),
    not_member(Key, ContractKeys).

wrong_type(Key) :-
    member(Key, [reference_period_basis, on_call_on_site_counts_as_working_time, on_call_standby_counts_as_working_time, member_state_uses_article_22_option, worker_agreement_to_exceed_obtained_first, profile, worker, shifts, period_start, period_end]).

duplicate_key(Key) :-
    contract_key_list(ContractKeys),
    member(Key, ContractKeys).

contract_key_list([reference_period_basis, on_call_on_site_counts_as_working_time, on_call_standby_counts_as_working_time, member_state_uses_article_22_option, worker_agreement_to_exceed_obtained_first]).

working_time_weekly_limit_profile_keys([reference_period_basis, on_call_on_site_counts_as_working_time, on_call_standby_counts_as_working_time, member_state_uses_article_22_option, worker_agreement_to_exceed_obtained_first]).

working_time_weekly_limit_what_if(case(Profile, Worker, Shifts, PeriodStart, PeriodEnd), OverriddenKey, NewValue, Verdict) :-
    attributes_without_key(Profile, OverriddenKey, KeptAttributes),
    append(KeptAttributes, [attribute(OverriddenKey, NewValue)], Hypothesis),
    decide_working_time_weekly_limit(case(Hypothesis, Worker, Shifts, PeriodStart, PeriodEnd), Verdict).

attributes_without_key([], _, []).
attributes_without_key([attribute(AttributeKey, AttributeValue)|Attributes], OverriddenKey, KeptAttributes) :-
    if_(AttributeKey = OverriddenKey, KeptAttributes = LaterKept, KeptAttributes = [attribute(AttributeKey, AttributeValue)|LaterKept]),
    attributes_without_key(Attributes, OverriddenKey, LaterKept).

working_time_weekly_limit_maximum_counted_minutes(Profile, Worker, Shifts, PeriodStart, PeriodEnd, Maximum) :-
    weekly_working_time_average(Profile, Worker, Shifts, PeriodStart, PeriodEnd, Average),
    average_standing(Average, Standing),
    maximum_for_standing(Standing, Worker, Shifts, PeriodStart, PeriodEnd, Maximum).

average_standing(input_problems(Problems), refused(Problems)).
average_standing(no_countable_period, empty).
average_standing(indeterminate(_), measurable).
average_standing(needs_legal_review(_, _), measurable).
average_standing(minutes_per_seven_days(_, _), measurable).

maximum_for_standing(refused(Problems), _, _, _, _, input_problems(Problems)).
maximum_for_standing(empty, _, _, _, _, no_countable_period) :-
    implements(eu_dir_2003_88_art_16_b).
maximum_for_standing(measurable, Worker, Shifts, PeriodStart, PeriodEnd, Maximum) :-
    implements(eu_dir_2003_88_art_6_b),
    findall(shift(Worker, ShiftStart, ShiftEnd, work), (member(shift(WorkerIdentifier, ShiftStart, ShiftEnd, ShiftKind), Shifts), WorkerIdentifier == Worker, neutral_kind(ShiftKind)), NeutralAsWork),
    weekly_working_time_average([], Worker, NeutralAsWork, PeriodStart, PeriodEnd, NeutralAverage),
    period_length_minutes(PeriodStart, PeriodEnd, LengthMinutes),
    largest_counted_within(NeutralAverage, LengthMinutes, Maximum).

neutral_kind(paid_annual_leave) :-
    implements(eu_dir_2003_88_art_16_b).
neutral_kind(sick_leave) :-
    implements(eu_dir_2003_88_art_16_b).

period_length_minutes(PeriodStart, PeriodEnd, LengthMinutes) :-
    implements(eu_dir_2003_88_art_16_b),
    days_between(PeriodEnd, PeriodStart, ElapsedDays),
    LengthMinutes #= (ElapsedDays + 1) * 1440.

largest_counted_within(minutes_per_seven_days(Numerator, Denominator), LengthMinutes, Maximum) :-
    implements(eu_dir_2003_88_art_6_b),
    NeutralMinutes #= Numerator * LengthMinutes // (10080 * Denominator),
    CountableMinutes #= LengthMinutes - NeutralMinutes,
    Maximum #= 2880 * CountableMinutes // 10080.

test(the_keys_are_in_contract_order) :-
    working_time_weekly_limit_profile_keys([reference_period_basis|_]).
test(a_full_week_has_the_boundary_2880) :-
    working_time_weekly_limit_maximum_counted_minutes([], w1, [], date(2026, 3, 2), date(2026, 3, 8), 2880).
test(a_day_of_leave_moves_the_boundary_to_2468) :-
    working_time_weekly_limit_maximum_counted_minutes([], w1, [shift(w1, date_time(2026, 3, 2, 0, 0), date_time(2026, 3, 3, 0, 0), paid_annual_leave)], date(2026, 3, 2), date(2026, 3, 8), 2468).
test(another_workers_leave_does_not_move_the_boundary) :-
    working_time_weekly_limit_maximum_counted_minutes([], w1, [shift(w2, date_time(2026, 3, 2, 0, 0), date_time(2026, 3, 3, 0, 0), sick_leave)], date(2026, 3, 2), date(2026, 3, 8), 2880).
test(a_period_of_sick_leave_has_no_boundary) :-
    working_time_weekly_limit_maximum_counted_minutes([], w1, [shift(w1, date_time(2026, 3, 2, 0, 0), date_time(2026, 3, 9, 0, 0), sick_leave)], date(2026, 3, 2), date(2026, 3, 8), no_countable_period).
test(the_boundary_answers_once) :-
    findall(Maximum, working_time_weekly_limit_maximum_counted_minutes([], w1, [], date(2026, 3, 2), date(2026, 3, 8), Maximum), Answers),
    length(Answers, 1).
test(the_boundary_refuses_a_bad_profile) :-
    working_time_weekly_limit_maximum_counted_minutes([attribute(foo, 1)], w1, [], date(2026, 3, 2), date(2026, 3, 8), input_problems([unknown_key(foo)])).
test(what_if_replaces_the_key) :-
    working_time_weekly_limit_what_if(case([attribute(member_state_uses_article_22_option, false)], w1, [shift(w1, date_time(2026, 3, 2, 0, 0), date_time(2026, 3, 4, 0, 1), work)], date(2026, 3, 2), date(2026, 3, 8)), member_state_uses_article_22_option, true, working_time_weekly_limit_verdict(indeterminate([worker_agreement_to_exceed_obtained_first]), [])).
test(the_vocabulary_atoms_are_served) :-
    reference_period_basis,
    unsure,
    work,
    sick_leave.
test(the_average_constructor_holds_two_bare_integers) :-
    minutes_per_seven_days(2880, 1).

test(a_negative_numerator_is_not_an_average, fail) :-
    minutes_per_seven_days(-1, 1).
