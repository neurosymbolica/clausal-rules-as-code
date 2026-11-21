% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_labour_night_work_night_work, [night_work_average_status/7, hazardous_night_work_status/7, average_night_hours_kept/0, average_night_hours_exceeded/0, hazardous_night_work_hours_kept/0, hazardous_night_work_hours_exceeded/0, night_work_limits_not_applied_to_worker/0, not_a_night_worker/0, no_special_hazards_or_heavy_strain/0, night_work_derogation_applies/0, decide_night_work/2, night_work_status/2, night_work_checklist/2, night_work_decision_resolvable/1, night_work_status_values/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(library(pairs), [group_pairs_by_key/2]).
:- use_module(clausal_lists_extra, [clausal_msort/2]).
:- use_module(library(clpz)).
:- use_module(library(reif), [memberd_t/3]).
:- use_module(formalize_lib, [profile_get/3, profile_lacks/2]).
:- use_module(m__eu_labour_night_work_kernel, [night_work_input_problems/2]).
:- use_module(m__eu_labour_night_work_citations, [implements/1]).

average_night_hours_kept.

average_night_hours_exceeded.

hazardous_night_work_hours_kept.

hazardous_night_work_hours_exceeded.

night_work_limits_not_applied_to_worker.

not_a_night_worker.

no_special_hazards_or_heavy_strain.

night_work_derogation_applies.

night_work_status_values([average_night_hours_kept, average_night_hours_exceeded, hazardous_night_work_hours_kept, hazardous_night_work_hours_exceeded, night_work_limits_not_applied_to_worker, not_a_night_worker, no_special_hazards_or_heavy_strain, night_work_derogation_applies]).

night_work_average_status(Profile, Worker, Shifts, PeriodStart, PeriodEnd, Result, Citations) :-
    all_input_problems(Profile, Worker, Shifts, PeriodStart, PeriodEnd, Problems),
    average_answer(Problems, Profile, Worker, Shifts, PeriodStart, PeriodEnd, Result, Citations).

average_answer([Problem|Problems], _, _, _, _, _, input_problems([Problem|Problems]), []).
average_answer([], Profile, Worker, Shifts, PeriodStart, PeriodEnd, Result, Citations) :-
    implements(eu_dir_2003_88_art_8_a),
    rota_rows(Worker, Shifts, Rows),
    period_figures(PeriodStart, PeriodEnd, Period),
    on_call_choices(Profile, SiteChoice, StandbyChoice),
    SiteChoice = choice(_, SiteDomain, _),
    StandbyChoice = choice(_, StandbyDomain, _),
    daily_combinations(SiteDomain, StandbyDomain, Rows, Period, Combinations),
    key_state(Profile, night_work_reference_period_days, ReferenceState),
    reference_choice(ReferenceState, Combinations, Period, ReferenceChoice),
    ReferenceChoice = choice(_, ReferenceDomain, _),
    average_limit_table(ReferenceDomain, Combinations, Table),
    category_choice(Profile, CategoryChoice),
    key_state(Profile, night_worker, NightWorkerState),
    judgement_choice(night_worker, NightWorkerState, NightWorkerChoice),
    derogation_choice(Profile, DerogationChoice),
    completion_status([SiteChoice, StandbyChoice, ReferenceChoice, CategoryChoice, NightWorkerChoice, DerogationChoice], average_completion_value(Table), Profile, [on_call_on_site_counts_as_working_time, on_call_standby_counts_as_working_time, night_worker], Result, Citations).

hazardous_night_work_status(Profile, Worker, Shifts, PeriodStart, PeriodEnd, Result, Citations) :-
    all_input_problems(Profile, Worker, Shifts, PeriodStart, PeriodEnd, Problems),
    hazardous_answer(Problems, Profile, Worker, Shifts, PeriodStart, PeriodEnd, Result, Citations).

hazardous_answer([Problem|Problems], _, _, _, _, _, input_problems([Problem|Problems]), []).
hazardous_answer([], Profile, Worker, Shifts, PeriodStart, PeriodEnd, Result, Citations) :-
    implements(eu_dir_2003_88_art_8_b),
    rota_rows(Worker, Shifts, Rows),
    period_figures(PeriodStart, PeriodEnd, Period),
    on_call_choices(Profile, SiteChoice, StandbyChoice),
    SiteChoice = choice(_, SiteDomain, _),
    StandbyChoice = choice(_, StandbyDomain, _),
    window_combinations(SiteDomain, StandbyDomain, Rows, Period, Combinations),
    key_state(Profile, night_time_start, NightStartState),
    key_state(Profile, night_time_end, NightEndState),
    night_choice(NightStartState, NightEndState, Combinations, NightChoice),
    NightChoice = choice(_, NightDomain, _),
    hazardous_limit_table(NightDomain, Combinations, Table),
    category_choice(Profile, CategoryChoice),
    key_state(Profile, night_worker, NightWorkerState),
    judgement_choice(night_worker, NightWorkerState, NightWorkerChoice),
    key_state(Profile, special_hazards_or_heavy_strain, SpecialState),
    judgement_choice(special_hazards_or_heavy_strain, SpecialState, SpecialChoice),
    derogation_choice(Profile, DerogationChoice),
    completion_status([SiteChoice, StandbyChoice, NightChoice, CategoryChoice, NightWorkerChoice, SpecialChoice, DerogationChoice], hazardous_completion_value(Table), Profile, [on_call_on_site_counts_as_working_time, on_call_standby_counts_as_working_time, night_worker, special_hazards_or_heavy_strain], Result, Citations).

average_completion_value(Table, [_ - Site, _ - Standby, _ - Length, _ - Category, _ - NightWorker, _ - Derogation], value(Result, Citations)) :-
    member(limit(Site, Standby, Length, Kept), Table),
    average_outcome(Kept, Category, NightWorker, Derogation, Result, Citations).

average_outcome(true, _, _, _, average_night_hours_kept, [cite(eu_dir_2003_88_art_2_1), cite(eu_dir_2003_88_art_2_4), cite(eu_dir_2003_88_art_8), cite(eu_dir_2003_88_art_8_a), cite(eu_dir_2003_88_art_16_c), cite(eu_dir_2003_88_art_16_final_subpara)]) :-
    implements(eu_dir_2003_88_art_8_a).
average_outcome(false, mobile_worker, _, _, night_work_limits_not_applied_to_worker, [cite(eu_dir_2003_88_art_2_7), cite(eu_dir_2003_88_art_20_1)]) :-
    implements(eu_dir_2003_88_art_20_1).
average_outcome(false, seagoing_fishing_vessel_worker, _, _, night_work_limits_not_applied_to_worker, [cite(eu_dir_2003_88_art_21_1)]) :-
    implements(eu_dir_2003_88_art_21_1).
average_outcome(false, other_worker, false, _, not_a_night_worker, [cite(eu_dir_2003_88_art_2_4), cite(eu_dir_2003_88_art_8_a)]) :-
    implements(eu_dir_2003_88_art_2_4).
average_outcome(false, other_worker, true, derogation_under_article_17_1, night_work_derogation_applies, [cite(eu_dir_2003_88_art_8_a), cite(eu_dir_2003_88_art_17_1)]) :-
    implements(eu_dir_2003_88_art_17_1).
average_outcome(false, other_worker, true, derogation_under_article_17_3, night_work_derogation_applies, [cite(eu_dir_2003_88_art_8_a), cite(eu_dir_2003_88_art_17_3)]) :-
    implements(eu_dir_2003_88_art_17_3).
average_outcome(false, other_worker, true, derogation_under_article_18, night_work_derogation_applies, [cite(eu_dir_2003_88_art_8_a), cite(eu_dir_2003_88_art_18_first_subpara), cite(eu_dir_2003_88_art_18_second_subpara)]) :-
    implements(eu_dir_2003_88_art_18_first_subpara).
average_outcome(false, other_worker, true, no_derogation, average_night_hours_exceeded, [cite(eu_dir_2003_88_art_2_1), cite(eu_dir_2003_88_art_2_4), cite(eu_dir_2003_88_art_8), cite(eu_dir_2003_88_art_8_a), cite(eu_dir_2003_88_art_16_c), cite(eu_dir_2003_88_art_16_final_subpara)]) :-
    implements(eu_dir_2003_88_art_8_a).

hazardous_completion_value(Table, [_ - Site, _ - Standby, _ - Night, _ - Category, _ - NightWorker, _ - Special, _ - Derogation], value(Result, Citations)) :-
    member(limit(Site, Standby, Night, LongNightWork), Table),
    hazardous_outcome(LongNightWork, Category, NightWorker, Special, Derogation, Result, Citations).

hazardous_outcome(false, _, _, _, _, hazardous_night_work_hours_kept, [cite(eu_dir_2003_88_art_2_1), cite(eu_dir_2003_88_art_2_3), cite(eu_dir_2003_88_art_2_4), cite(eu_dir_2003_88_art_8), cite(eu_dir_2003_88_art_8_b), cite(eu_dir_2003_88_art_8_final_subpara)]) :-
    implements(eu_dir_2003_88_art_8_b).
hazardous_outcome(true, mobile_worker, _, _, _, night_work_limits_not_applied_to_worker, [cite(eu_dir_2003_88_art_2_7), cite(eu_dir_2003_88_art_20_1)]) :-
    implements(eu_dir_2003_88_art_20_1).
hazardous_outcome(true, seagoing_fishing_vessel_worker, _, _, _, night_work_limits_not_applied_to_worker, [cite(eu_dir_2003_88_art_21_1)]) :-
    implements(eu_dir_2003_88_art_21_1).
hazardous_outcome(true, other_worker, false, _, _, not_a_night_worker, [cite(eu_dir_2003_88_art_2_4), cite(eu_dir_2003_88_art_8_b)]) :-
    implements(eu_dir_2003_88_art_2_4).
hazardous_outcome(true, other_worker, true, false, _, no_special_hazards_or_heavy_strain, [cite(eu_dir_2003_88_art_8_b), cite(eu_dir_2003_88_art_8_final_subpara)]) :-
    implements(eu_dir_2003_88_art_8_final_subpara).
hazardous_outcome(true, other_worker, true, true, derogation_under_article_17_1, night_work_derogation_applies, [cite(eu_dir_2003_88_art_8_b), cite(eu_dir_2003_88_art_17_1)]) :-
    implements(eu_dir_2003_88_art_17_1).
hazardous_outcome(true, other_worker, true, true, derogation_under_article_17_3, night_work_derogation_applies, [cite(eu_dir_2003_88_art_8_b), cite(eu_dir_2003_88_art_17_3)]) :-
    implements(eu_dir_2003_88_art_17_3).
hazardous_outcome(true, other_worker, true, true, derogation_under_article_18, night_work_derogation_applies, [cite(eu_dir_2003_88_art_8_b), cite(eu_dir_2003_88_art_18_first_subpara), cite(eu_dir_2003_88_art_18_second_subpara)]) :-
    implements(eu_dir_2003_88_art_18_first_subpara).
hazardous_outcome(true, other_worker, true, true, no_derogation, hazardous_night_work_hours_exceeded, [cite(eu_dir_2003_88_art_2_1), cite(eu_dir_2003_88_art_2_3), cite(eu_dir_2003_88_art_2_4), cite(eu_dir_2003_88_art_8), cite(eu_dir_2003_88_art_8_b), cite(eu_dir_2003_88_art_8_final_subpara)]) :-
    implements(eu_dir_2003_88_art_8_b).

referral_citation(on_call_on_site_counts_as_working_time, cite(eu_dir_2003_88_art_2_1)).
referral_citation(on_call_standby_counts_as_working_time, cite(eu_dir_2003_88_art_2_1)).
referral_citation(night_worker, cite(eu_dir_2003_88_art_2_4)).
referral_citation(special_hazards_or_heavy_strain, cite(eu_dir_2003_88_art_8_final_subpara)).

key_state(Profile, Key, present(Value)) :-
    profile_get(Profile, Key, Value).
key_state(Profile, Key, absent) :-
    profile_lacks(Profile, Key).

judgement_choice(Key, present(true), choice(Key, [true], fixed)).
judgement_choice(Key, present(false), choice(Key, [false], fixed)).
judgement_choice(Key, present(unsure), choice(Key, [true, false], unsure)).
judgement_choice(Key, absent, choice(Key, [true, false], absent)).

enumeration_choice(Key, present(Value), _, choice(Key, [Value], fixed)).
enumeration_choice(Key, absent, Atoms, choice(Key, Atoms, absent)).

on_call_choices(Profile, SiteChoice, StandbyChoice) :-
    key_state(Profile, on_call_on_site_counts_as_working_time, SiteState),
    judgement_choice(on_call_on_site_counts_as_working_time, SiteState, SiteChoice),
    key_state(Profile, on_call_standby_counts_as_working_time, StandbyState),
    judgement_choice(on_call_standby_counts_as_working_time, StandbyState, StandbyChoice).

category_choice(Profile, Choice) :-
    implements(eu_dir_2003_88_art_20_1),
    key_state(Profile, worker_category, State),
    enumeration_choice(worker_category, State, [other_worker, mobile_worker, seagoing_fishing_vessel_worker], Choice).

derogation_choice(Profile, Choice) :-
    implements(eu_dir_2003_88_art_17_1),
    key_state(Profile, derogation_from_article_8, State),
    enumeration_choice(derogation_from_article_8, State, [no_derogation, derogation_under_article_17_1, derogation_under_article_17_3, derogation_under_article_18], Choice).

reference_choice(present(Length), _, _, choice(night_work_reference_period_days, [Length], fixed)).
reference_choice(absent, Combinations, period(_, _, Days), choice(night_work_reference_period_days, Representatives, absent)) :-
    implements(eu_dir_2003_88_art_16_c),
    findall(Vector - Length, (between(1, Days, Length), kept_vector(Combinations, Length, Vector)), Pairs),
    representatives_by_vector(Pairs, Representatives).

kept_vector(Combinations, Length, Vector) :-
    findall(Kept, (member(combination(_, _, Daily), Combinations), blocks_kept_t(Daily, Length, Kept)), Vector).

representatives_by_vector(Pairs, Representatives) :-
    keysort(Pairs, Sorted),
    group_pairs_by_key(Sorted, Groups),
    findall(First, member(_ - [First|_], Groups), Representatives).

night_choice(present(Start), present(End), _, choice(night_time_start, [night(Start, End)], fixed)).
night_choice(absent, EndState, Combinations, choice(night_time_start, Representatives, absent)) :-
    open_nights(absent, EndState, Candidates),
    compress_nights(Candidates, Combinations, Representatives).
night_choice(present(Start), absent, Combinations, choice(night_time_end, Representatives, absent)) :-
    open_nights(present(Start), absent, Candidates),
    compress_nights(Candidates, Combinations, Representatives).

compress_nights(Candidates, Combinations, Representatives) :-
    findall(Vector - Night, (member(Night, Candidates), night_vector(Combinations, Night, Vector)), Pairs),
    representatives_by_vector(Pairs, Representatives).

night_vector(Combinations, Night, Vector) :-
    findall(LongNightWork, (member(combination(_, _, Pieces), Combinations), long_night_work_t(Pieces, Night, LongNightWork)), Vector).

open_nights(absent, absent, Nights) :-
    implements(eu_dir_2003_88_art_2_3),
    Lowest #= 1440 + 300 - 420,
    Highest #= 1439,
    Gap #= 1440 - 420,
    findall(night(Start, End), (between(Lowest, Highest, Start), End #= Start - Gap), SevenHourNights),
    MidnightStart #= 0,
    MidnightEnd #= 420,
    LargestStart #= 301,
    LargestEnd #= 300,
    append([[night(MidnightStart, MidnightEnd)], SevenHourNights, [night(LargestStart, LargestEnd)]], Nights).
open_nights(absent, present(End), Nights) :-
    implements(eu_dir_2003_88_art_2_3),
    end_given_smallest_start(End, SmallStart),
    end_given_largest_start(End, LargeStart),
    sort([night(SmallStart, End), night(LargeStart, End)], Nights).
open_nights(present(Start), absent, Nights) :-
    implements(eu_dir_2003_88_art_2_3),
    start_given_nights(Start, Nights).

start_given_nights(Start, [night(Start, Smallest), night(Start, Largest)]) :-
    implements(eu_dir_2003_88_art_2_3),
    Start #= 0,
    Smallest #= 420,
    Largest #= 1439.
start_given_nights(Start, Nights) :-
    implements(eu_dir_2003_88_art_2_3),
    Start #> 0,
    Smallest #= max(300, Start - 1440 + 420),
    Largest #= Start - 1,
    sort([night(Start, Smallest), night(Start, Largest)], Nights).

end_given_smallest_start(End, Start) :-
    implements(eu_dir_2003_88_art_2_3),
    End #>= 420,
    Start #= 0.
end_given_smallest_start(End, Start) :-
    implements(eu_dir_2003_88_art_2_3),
    End #< 420,
    Start #= End + 1440 - 420.

end_given_largest_start(End, Start) :-
    implements(eu_dir_2003_88_art_2_3),
    End #< 1439,
    Start #= End + 1.
end_given_largest_start(End, Start) :-
    implements(eu_dir_2003_88_art_2_3),
    End #= 1439,
    Start #= 0.

completion_status(Choices, ValueGoal, Profile, JudgementKeys, Result, Citations) :-
    findall(Assignment, completion(Choices, Assignment), Completions),
    findall(Assignment - Value, (member(Assignment, Completions), call(ValueGoal, Assignment, Value)), Valued),
    findall(Value, member(_ - Value, Valued), Values),
    sort(Values, Distinct),
    status_by_values(Distinct, Choices, Valued, Profile, JudgementKeys, Result, Citations).

completion([], []).
completion([choice(Key, Domain, _)|Choices], [Key - Value|Assignment]) :-
    member(Value, Domain),
    completion(Choices, Assignment).

status_by_values([value(Result, Citations)], _, _, _, _, Result, Citations).
status_by_values([_, _|_], Choices, Valued, Profile, JudgementKeys, Result, []) :-
    mattering_keys(Choices, absent, Valued, Candidates),
    open_status(Candidates, Choices, Valued, Profile, JudgementKeys, Result).

mattering_keys(Choices, Mode, Valued, Keys) :-
    findall(Key, (member(choice(Key, _, Mode), Choices), matters_t(Key, Valued, true)), Keys).

open_status([Candidate|Candidates], Choices, Valued, _, _, indeterminate([Key])) :-
    key_to_name([Candidate|Candidates], Choices, Valued, Key).
open_status([], Choices, Valued, Profile, JudgementKeys, needs_legal_review(open_textured(Key, Citation), [inputs_relied_on(Pairs)])) :-
    mattering_keys(Choices, unsure, Valued, UnsureKeys),
    UnsureKeys = [Key|_],
    referral_citation(Key, Citation),
    relied_pairs(Profile, JudgementKeys, Pairs).

key_to_name(Candidates, Choices, Valued, Key) :-
    findall(Candidate, (member(Candidate, Candidates), strictly_behind_any_t(Candidate, Candidates, Choices, Valued, false)), Remaining),
    first_remaining(Remaining, Candidates, Key).

first_remaining([Key|_], _, Key).
first_remaining([], [Key|_], Key).

strictly_behind_any_t(Key, Candidates, Choices, Valued, Truth) :-
    findall(Behind, (member(Other, Candidates), dif(Other, Key), strictly_behind_t(Key, Other, Choices, Valued, Behind)), Truths),
    memberd_t(true, Truths, Truth).

strictly_behind_t(Key, Other, Choices, Valued, Truth) :-
    behind_t(Key, Other, Choices, Valued, KeyBehind),
    behind_t(Other, Key, Choices, Valued, OtherBehind),
    strict_truth(KeyBehind, OtherBehind, Truth).

strict_truth(true, false, true).
strict_truth(true, true, false).
strict_truth(false, _, false).

behind_t(Key, Other, Choices, Valued, Truth) :-
    member(choice(Other, Domain, _), Choices),
    findall(Matters, (member(OtherValue, Domain), findall(Assignment - Value, (member(Assignment - Value, Valued), member(Other - OtherValue, Assignment)), Restricted), matters_t(Key, Restricted, Matters)), MattersList),
    memberd_t(false, MattersList, Truth).

matters_t(Key, Valued, Truth) :-
    findall(Rest - Value, (member(Assignment - Value, Valued), select(Key - _, Assignment, Rest)), Pairs),
    sort(Pairs, Sorted),
    adjacent_conflict_t(Sorted, Truth).

adjacent_conflict_t([], false).
adjacent_conflict_t([_], false).
adjacent_conflict_t([Rest - _, Next - _|_], true) :-
    Rest == Next.
adjacent_conflict_t([Rest - _, Next - Value|Pairs], Truth) :-
    Rest \== Next,
    adjacent_conflict_t([Next - Value|Pairs], Truth).

relied_pairs(Profile, Keys, Pairs) :-
    findall(Key - Value, (member(Key, Keys), key_state(Profile, Key, present(Value))), Pairs).

kind_counted(work, _, _, true) :-
    implements(eu_dir_2003_88_art_2_1).
kind_counted(on_call_on_site, Site, _, Site) :-
    implements(eu_dir_2003_88_art_2_1).
kind_counted(on_call_standby, _, Standby, Standby) :-
    implements(eu_dir_2003_88_art_2_1).
kind_counted(paid_annual_leave, _, _, false) :-
    implements(eu_dir_2003_88_art_2_1).
kind_counted(sick_leave, _, _, false) :-
    implements(eu_dir_2003_88_art_2_1).

rota_rows(Worker, Shifts, Rows) :-
    findall(row(Start, End, Kind), (member(shift(Identity, StartTime, EndTime, Kind), Shifts), Identity == Worker, absolute_minute(StartTime, Start), absolute_minute(EndTime, End)), Rows).

period_figures(PeriodStart, PeriodEnd, period(First, Last, Days)) :-
    date_day_number(PeriodStart, FirstDay),
    date_day_number(PeriodEnd, LastDay),
    First #= FirstDay * 1440,
    Last #= (LastDay + 1) * 1440,
    Days #= LastDay - FirstDay + 1.

working_runs(Rows, Site, Standby, Runs) :-
    implements(eu_dir_2003_88_art_2_1),
    findall(Start - End, (member(row(Start, End, Kind), Rows), kind_counted(Kind, Site, Standby, true)), Intervals),
    clausal_msort(Intervals, Sorted),
    merge_runs(Sorted, Runs).

merge_runs([], []).
merge_runs([Start - End], [Start - End]).
merge_runs([FirstStart - FirstEnd, SecondStart - SecondEnd|Intervals], Runs) :-
    FirstEnd #>= SecondStart,
    MergedEnd #= max(FirstEnd, SecondEnd),
    merge_runs([FirstStart - MergedEnd|Intervals], Runs).
merge_runs([FirstStart - FirstEnd, SecondStart - SecondEnd|Intervals], [FirstStart - FirstEnd|Runs]) :-
    FirstEnd #< SecondStart,
    merge_runs([SecondStart - SecondEnd|Intervals], Runs).

daily_combinations(SiteDomain, StandbyDomain, Rows, Period, Combinations) :-
    findall(combination(Site, Standby, Daily), (member(Site, SiteDomain), member(Standby, StandbyDomain), working_runs(Rows, Site, Standby, Runs), daily_working_minutes(Runs, Period, Daily)), Combinations).

daily_working_minutes(Runs, period(First, Last, Days), daily(Days, Entries)) :-
    implements(eu_dir_2003_88_art_2_1),
    findall(Index - Minutes, (member(RunStart - RunEnd, Runs), run_day_piece(RunStart, RunEnd, First, Last, Index, Minutes)), Pieces),
    keysort(Pieces, Sorted),
    merge_day_pieces(Sorted, Entries).

run_day_piece(RunStart, RunEnd, First, Last, Index, Minutes) :-
    Low #= max(RunStart, First),
    High #= min(RunEnd, Last),
    Low #< High,
    FirstIndex #= (Low - First) // 1440,
    LastIndex #= (High - 1 - First) // 1440,
    between(FirstIndex, LastIndex, Index),
    DayStart #= First + Index * 1440,
    DayEnd #= DayStart + 1440,
    Minutes #= min(High, DayEnd) - max(Low, DayStart).

merge_day_pieces([], []).
merge_day_pieces([Index - Minutes], [Index - Minutes]).
merge_day_pieces([Index - FirstMinutes, NextIndex - NextMinutes|Pieces], Entries) :-
    Index == NextIndex,
    Minutes #= FirstMinutes + NextMinutes,
    merge_day_pieces([Index - Minutes|Pieces], Entries).
merge_day_pieces([Index - FirstMinutes, NextIndex - NextMinutes|Pieces], [Index - FirstMinutes|Entries]) :-
    Index \== NextIndex,
    merge_day_pieces([NextIndex - NextMinutes|Pieces], Entries).

average_limit_table(ReferenceDomain, Combinations, Table) :-
    findall(limit(Site, Standby, Length, Kept), (member(Length, ReferenceDomain), member(combination(Site, Standby, Daily), Combinations), blocks_kept_t(Daily, Length, Kept)), Table).

blocks_kept_t(daily(Days, Entries), Length, Truth) :-
    implements(eu_dir_2003_88_art_16_c),
    block_walk_t(Entries, Days, Length, Truth).

block_walk_t([], _, _, true).
block_walk_t([Index - Minutes|Entries], Days, Length, Truth) :-
    implements(eu_dir_2003_88_art_16_c),
    Block #= Index // Length,
    block_sum(Entries, Block, Length, Minutes, Work, Rest),
    block_kept_t(Block, Days, Length, Work, BlockTruth),
    block_walk_t(Rest, Days, Length, RestTruth),
    truth_and(BlockTruth, RestTruth, Truth).

block_sum([], _, _, Work, Work, []).
block_sum([Index - Minutes|Entries], Block, Length, Accumulated, Work, Rest) :-
    Index // Length #= Block,
    Next #= Accumulated + Minutes,
    block_sum(Entries, Block, Length, Next, Work, Rest).
block_sum([Index - Minutes|Entries], Block, Length, Work, Work, [Index - Minutes|Entries]) :-
    Index // Length #\= Block.

block_kept_t(Block, Days, Length, Work, Truth) :-
    implements(eu_dir_2003_88_art_8_a),
    BlockStart #= Block * Length,
    BlockDays #= min(Length, Days - BlockStart),
    reference_divisor(BlockDays, Divisor),
    average_kept_t(Work, Divisor, Truth).

reference_divisor(Length, Divisor) :-
    implements(eu_dir_2003_88_art_16_final_subpara),
    Divisor #= Length - Length // 7.

average_kept_t(Work, Divisor, true) :-
    implements(eu_dir_2003_88_art_8_a),
    Work #=< 480 * Divisor.
average_kept_t(Work, Divisor, false) :-
    implements(eu_dir_2003_88_art_8_a),
    Work #> 480 * Divisor.

window_combinations(SiteDomain, StandbyDomain, Rows, Period, Combinations) :-
    findall(combination(Site, Standby, Pieces), (member(Site, SiteDomain), member(Standby, StandbyDomain), working_runs(Rows, Site, Standby, Runs), long_window_pieces(Runs, Period, Pieces)), Combinations).

long_window_pieces(Runs, period(First, Last, _), Pieces) :-
    implements(eu_dir_2003_88_art_8_b),
    findall(Start, (member(RunStart - RunEnd, Runs), start_of_work(RunStart, RunEnd, First, Last, Start)), Starts),
    findall(WindowPieces, (member(Start, Starts), long_window(Runs, Start, WindowPieces)), Nested),
    append(Nested, Pieces).

start_of_work(RunStart, _, First, Last, RunStart) :-
    implements(eu_dir_2003_88_art_8_b),
    RunStart #>= First,
    RunStart #< Last.
start_of_work(RunStart, RunEnd, First, _, First) :-
    implements(eu_dir_2003_88_art_8_b),
    RunStart #< First,
    RunEnd #> First.

long_window(Runs, Start, Pieces) :-
    implements(eu_dir_2003_88_art_8_b),
    WindowEnd #= Start + 1440,
    findall(Low - High, (member(RunStart - RunEnd, Runs), Low #= max(RunStart, Start), High #= min(RunEnd, WindowEnd), Low #< High), Pieces),
    findall(Length, (member(Low - High, Pieces), Length #= High - Low), Lengths),
    sum_list(Lengths, Work),
    Work #> 480.

hazardous_limit_table(NightDomain, Combinations, Table) :-
    findall(limit(Site, Standby, Night, LongNightWork), (member(Night, NightDomain), member(combination(Site, Standby, Pieces), Combinations), long_night_work_t(Pieces, Night, LongNightWork)), Table).

long_night_work_t(Pieces, night(Start, End), Truth) :-
    implements(eu_dir_2003_88_art_2_3),
    findall(PieceTruth, (member(Piece, Pieces), piece_night_t(Piece, Start, End, PieceTruth)), Truths),
    memberd_t(true, Truths, Truth).

piece_night_t(Low - High, _, _, true) :-
    implements(eu_dir_2003_88_art_2_3),
    High - Low #>= 1440.
piece_night_t(Low - High, Start, End, Truth) :-
    implements(eu_dir_2003_88_art_2_3),
    Length #= High - Low,
    Length #< 1440,
    ClockStart #= Low mod 1440,
    ClockEnd #= ClockStart + Length,
    night_clock_pieces(Start, End, NightPieces),
    findall(OverlapTruth, (member(NightStart - NightEnd, NightPieces), overlap_t(ClockStart, ClockEnd, NightStart, NightEnd, OverlapTruth)), Truths),
    memberd_t(true, Truths, Truth).

night_clock_pieces(Start, End, [Midnight - End, NextMidnight - NextEnd]) :-
    implements(eu_dir_2003_88_art_2_3),
    Start #= 0,
    Midnight #= 0,
    NextMidnight #= 1440,
    NextEnd #= NextMidnight + End.
night_clock_pieces(Start, End, [Midnight - End, Start - NextEnd, NextStart - SecondMidnight]) :-
    implements(eu_dir_2003_88_art_2_3),
    Start #> 0,
    Midnight #= 0,
    NextEnd #= 1440 + End,
    NextStart #= 1440 + Start,
    SecondMidnight #= 2 * 1440.

overlap_t(FirstStart, FirstEnd, SecondStart, SecondEnd, true) :-
    max(FirstStart, SecondStart) #< min(FirstEnd, SecondEnd).
overlap_t(FirstStart, FirstEnd, SecondStart, SecondEnd, false) :-
    max(FirstStart, SecondStart) #>= min(FirstEnd, SecondEnd).

all_input_problems(Profile, Worker, Shifts, PeriodStart, PeriodEnd, Problems) :-
    night_work_input_problems(Profile, ProfileProblems),
    argument_problems(Worker, Shifts, PeriodStart, PeriodEnd, ArgumentProblems),
    append(ProfileProblems, ArgumentProblems, Problems).

argument_problems(Worker, Shifts, PeriodStart, PeriodEnd, Problems) :-
    atom_or_integer_t(Worker, WorkerTruth),
    shifts_well_formed_t(WorkerTruth, Worker, Shifts, ShiftsTruth),
    real_date_t(PeriodStart, StartTruth),
    real_date_t(PeriodEnd, EndTruth),
    period_end_truth(StartTruth, EndTruth, PeriodStart, PeriodEnd, PeriodEndTruth),
    flag_problems([WorkerTruth - wrong_type(worker), ShiftsTruth - wrong_type(shifts), StartTruth - wrong_type(period_start), PeriodEndTruth - wrong_type(period_end)], Problems).

flag_problems([], []).
flag_problems([true - _|Flags], Problems) :-
    flag_problems(Flags, Problems).
flag_problems([false - Problem|Flags], [Problem|Problems]) :-
    flag_problems(Flags, Problems).

period_end_truth(_, false, _, _, false).
period_end_truth(false, true, _, _, true).
period_end_truth(true, true, PeriodStart, PeriodEnd, Truth) :-
    date_day_number(PeriodStart, FirstDay),
    date_day_number(PeriodEnd, LastDay),
    not_before_t(LastDay, FirstDay, Truth).

not_before_t(Later, Earlier, true) :-
    Later #>= Earlier.
not_before_t(Later, Earlier, false) :-
    Later #< Earlier.

atom_or_integer_t(Value, false) :-
    var(Value).
atom_or_integer_t(Value, true) :-
    atom(Value).
atom_or_integer_t(Value, true) :-
    integer(Value).
atom_or_integer_t(Value, false) :-
    float(Value).
atom_or_integer_t(Value, false) :-
    compound(Value).

shifts_well_formed_t(WorkerTruth, Worker, Shifts, Truth) :-
    proper_shift_list_t(Shifts, ListTruth),
    overlap_check_t(ListTruth, WorkerTruth, Worker, Shifts, Truth).

overlap_check_t(false, _, _, _, false).
overlap_check_t(true, false, _, _, true).
overlap_check_t(true, true, Worker, Shifts, Truth) :-
    findall(Start - End, (member(shift(Identity, StartTime, EndTime, _), Shifts), Identity == Worker, absolute_minute(StartTime, Start), absolute_minute(EndTime, End)), Intervals),
    clausal_msort(Intervals, Sorted),
    no_overlap_t(Sorted, Truth).

no_overlap_t([], true).
no_overlap_t([_], true).
no_overlap_t([_ - FirstEnd, SecondStart - SecondEnd|Intervals], Truth) :-
    FirstEnd #=< SecondStart,
    no_overlap_t([SecondStart - SecondEnd|Intervals], Truth).
no_overlap_t([_ - FirstEnd, SecondStart - _|_], false) :-
    FirstEnd #> SecondStart.

proper_shift_list_t(Shifts, false) :-
    var(Shifts).
proper_shift_list_t(Shifts, true) :-
    Shifts == [].
proper_shift_list_t(Shifts, Truth) :-
    nonvar(Shifts),
    Shifts = [Shift|Rest],
    shift_well_formed_t(Shift, ShiftTruth),
    proper_shift_list_t(Rest, RestTruth),
    truth_and(ShiftTruth, RestTruth, Truth).
proper_shift_list_t(Shifts, false) :-
    nonvar(Shifts),
    Shifts \== [],
    Shifts \= [_|_].

shift_well_formed_t(Shift, false) :-
    var(Shift).
shift_well_formed_t(Shift, Truth) :-
    nonvar(Shift),
    Shift = shift(Identity, StartTime, EndTime, Kind),
    atom_or_integer_t(Identity, IdentityTruth),
    shift_kind_t(Kind, KindTruth),
    real_date_time_t(StartTime, StartTruth),
    real_date_time_t(EndTime, EndTruth),
    truth_and(StartTruth, EndTruth, TimesTruth),
    times_ordered_t(TimesTruth, StartTime, EndTime, OrderTruth),
    truth_and(IdentityTruth, KindTruth, LabelTruth),
    truth_and(LabelTruth, OrderTruth, Truth).
shift_well_formed_t(Shift, false) :-
    nonvar(Shift),
    Shift \= shift(_, _, _, _).

shift_kind_t(Kind, false) :-
    var(Kind).
shift_kind_t(Kind, Truth) :-
    nonvar(Kind),
    memberd_t(Kind, [work, on_call_on_site, on_call_standby, paid_annual_leave, sick_leave], Truth).

times_ordered_t(false, _, _, false).
times_ordered_t(true, StartTime, EndTime, Truth) :-
    absolute_minute(StartTime, Start),
    absolute_minute(EndTime, End),
    before_t(Start, End, Truth).

before_t(Earlier, Later, true) :-
    Earlier #< Later.
before_t(Earlier, Later, false) :-
    Earlier #>= Later.

real_date_time_t(Time, false) :-
    var(Time).
real_date_time_t(Time, Truth) :-
    nonvar(Time),
    Time = date_time(Year, Month, Day, Hour, MinuteOfHour),
    real_day_t(Year, Month, Day, DayTruth),
    integer_in_t(Hour, 0, 23, HourTruth),
    integer_in_t(MinuteOfHour, 0, 59, MinuteTruth),
    truth_and(DayTruth, HourTruth, PartTruth),
    truth_and(PartTruth, MinuteTruth, Truth).
real_date_time_t(Time, false) :-
    nonvar(Time),
    Time \= date_time(_, _, _, _, _).

real_date_t(Date, false) :-
    var(Date).
real_date_t(Date, Truth) :-
    nonvar(Date),
    Date = date(Year, Month, Day),
    real_day_t(Year, Month, Day, Truth).
real_date_t(Date, false) :-
    nonvar(Date),
    Date \= date(_, _, _).

real_day_t(Year, Month, Day, Truth) :-
    integer_in_t(Year, 1, 9999, YearTruth),
    integer_in_t(Month, 1, 12, MonthTruth),
    truth_and(YearTruth, MonthTruth, CalendarTruth),
    day_in_month_t(CalendarTruth, Year, Month, Day, Truth).

day_in_month_t(false, _, _, _, false).
day_in_month_t(true, Year, Month, Day, Truth) :-
    month_length(Year, Month, Length),
    integer_in_t(Day, 1, Length, Truth).

month_length(Year, Month, Length) :-
    Month #= 2,
    leap_year_t(Year, Leap),
    february_length(Leap, Length).
month_length(_, Month, Length) :-
    Month #\= 2,
    month_days(Month, Length).

february_length(true, 29).
february_length(false, 28).

month_days(1, 31).
month_days(3, 31).
month_days(4, 30).
month_days(5, 31).
month_days(6, 30).
month_days(7, 31).
month_days(8, 31).
month_days(9, 30).
month_days(10, 31).
month_days(11, 30).
month_days(12, 31).

leap_year_t(Year, false) :-
    Year mod 4 #\= 0.
leap_year_t(Year, true) :-
    Year mod 4 #= 0,
    Year mod 100 #\= 0.
leap_year_t(Year, false) :-
    Year mod 100 #= 0,
    Year mod 400 #\= 0.
leap_year_t(Year, true) :-
    Year mod 400 #= 0.

integer_in_t(Value, Low, High, Truth) :-
    integer_value_t(Value, IsInteger),
    integer_between_t(IsInteger, Value, Low, High, Truth).

integer_value_t(Value, false) :-
    var(Value).
integer_value_t(Value, true) :-
    integer(Value).
integer_value_t(Value, false) :-
    float(Value).
integer_value_t(Value, false) :-
    atom(Value).
integer_value_t(Value, false) :-
    compound(Value).

integer_between_t(false, _, _, _, false).
integer_between_t(true, Value, Low, High, true) :-
    Value #>= Low,
    Value #=< High.
integer_between_t(true, Value, Low, _, false) :-
    Value #< Low.
integer_between_t(true, Value, _, High, false) :-
    Value #> High.

truth_and(true, Truth, Truth).
truth_and(false, _, false).

gregorian_day_number(Year, Month, Day, DayNumber) :-
    Month #> 2,
    ShiftedMonth #= Month - 3,
    era_day_number(Year, ShiftedMonth, Day, DayNumber).
gregorian_day_number(Year, Month, Day, DayNumber) :-
    Month #< 3,
    ShiftedYear #= Year - 1,
    ShiftedMonth #= Month + 9,
    era_day_number(ShiftedYear, ShiftedMonth, Day, DayNumber).

era_day_number(ShiftedYear, ShiftedMonth, Day, DayNumber) :-
    Era #= ShiftedYear // 400,
    YearOfEra #= ShiftedYear - Era * 400,
    DayOfYear #= (153 * ShiftedMonth + 2) // 5 + Day - 1,
    DayOfEra #= YearOfEra * 365 + YearOfEra // 4 - YearOfEra // 100 + DayOfYear,
    DayNumber #= Era * 146097 + DayOfEra.

date_day_number(date(Year, Month, Day), DayNumber) :-
    gregorian_day_number(Year, Month, Day, DayNumber).

absolute_minute(date_time(Year, Month, Day, Hour, MinuteOfHour), Minute) :-
    gregorian_day_number(Year, Month, Day, DayNumber),
    Minute #= DayNumber * 1440 + Hour * 60 + MinuteOfHour.

decide_night_work(average_case(Profile, Worker, Shifts, PeriodStart, PeriodEnd), night_work_verdict(Status, Citations)) :-
    night_work_average_status(Profile, Worker, Shifts, PeriodStart, PeriodEnd, Status, Citations).
decide_night_work(hazardous_case(Profile, Worker, Shifts, PeriodStart, PeriodEnd), night_work_verdict(Status, Citations)) :-
    hazardous_night_work_status(Profile, Worker, Shifts, PeriodStart, PeriodEnd, Status, Citations).

night_work_status(Case, Status) :-
    decide_night_work(Case, night_work_verdict(Status, _)).

night_work_checklist(Case, [item(RowIdentity, Status, Citations)]) :-
    case_row(Case, RowIdentity),
    decide_night_work(Case, night_work_verdict(Status, Citations)).

case_row(average_case(_, _, _, _, _), average_night_hours_limit).
case_row(hazardous_case(_, _, _, _, _), hazardous_night_work_limit).

night_work_decision_resolvable(Case) :-
    decide_night_work(Case, _).

sample_profile(Site, Standby, Category, NightWorker, Special, Derogation, [attribute(on_call_on_site_counts_as_working_time, Site), attribute(on_call_standby_counts_as_working_time, Standby), attribute(night_time_start, 1320), attribute(night_time_end, 300), attribute(night_work_reference_period_days, 7), attribute(worker_category, Category), attribute(night_worker, NightWorker), attribute(special_hazards_or_heavy_strain, Special), attribute(derogation_from_article_8, Derogation)]).

six_night_shifts([shift(worker_1, date_time(2026, 3, 2, 22, 0), date_time(2026, 3, 3, 6, 0), work), shift(worker_1, date_time(2026, 3, 3, 22, 0), date_time(2026, 3, 4, 6, 0), work), shift(worker_1, date_time(2026, 3, 4, 22, 0), date_time(2026, 3, 5, 6, 0), work), shift(worker_1, date_time(2026, 3, 5, 22, 0), date_time(2026, 3, 6, 6, 0), work), shift(worker_1, date_time(2026, 3, 6, 22, 0), date_time(2026, 3, 7, 6, 0), work), shift(worker_1, date_time(2026, 3, 7, 22, 0), date_time(2026, 3, 8, 6, 0), work)]).

seven_night_shifts(Shifts) :-
    six_night_shifts(Six),
    append(Six, [shift(worker_1, date_time(2026, 3, 8, 22, 0), date_time(2026, 3, 9, 6, 0), work)], Shifts).

test(six_nights_keep_the_average_at_exactly_2880) :-
    sample_profile(true, false, other_worker, true, true, no_derogation, Profile),
    six_night_shifts(Shifts),
    night_work_average_status(Profile, worker_1, Shifts, date(2026, 3, 2), date(2026, 3, 8), Result, Citations),
    Result == average_night_hours_kept,
    Citations == [cite(eu_dir_2003_88_art_2_1), cite(eu_dir_2003_88_art_2_4), cite(eu_dir_2003_88_art_8), cite(eu_dir_2003_88_art_8_a), cite(eu_dir_2003_88_art_16_c), cite(eu_dir_2003_88_art_16_final_subpara)].
test(seven_nights_exceed_the_average) :-
    sample_profile(true, false, other_worker, true, true, no_derogation, Profile),
    seven_night_shifts(Shifts),
    night_work_average_status(Profile, worker_1, Shifts, date(2026, 3, 2), date(2026, 3, 8), average_night_hours_exceeded, _).
test(the_average_query_yields_exactly_one_solution) :-
    sample_profile(true, false, other_worker, true, true, no_derogation, Profile),
    seven_night_shifts(Shifts),
    findall(Result - Citations, night_work_average_status(Profile, worker_1, Shifts, date(2026, 3, 2), date(2026, 3, 8), Result, Citations), Answers),
    length(Answers, 1).
test(a_mobile_worker_is_outside_article_8) :-
    sample_profile(true, false, mobile_worker, true, true, no_derogation, Profile),
    seven_night_shifts(Shifts),
    night_work_average_status(Profile, worker_1, Shifts, date(2026, 3, 2), date(2026, 3, 8), night_work_limits_not_applied_to_worker, Citations),
    Citations == [cite(eu_dir_2003_88_art_2_7), cite(eu_dir_2003_88_art_20_1)].
test(an_absent_reference_period_that_decides_is_asked_for) :-
    Profile = [attribute(on_call_on_site_counts_as_working_time, true), attribute(on_call_standby_counts_as_working_time, false), attribute(worker_category, other_worker), attribute(night_worker, true), attribute(derogation_from_article_8, no_derogation)],
    seven_night_shifts(Shifts),
    night_work_average_status(Profile, worker_1, Shifts, date(2026, 3, 2), date(2026, 3, 8), indeterminate([night_work_reference_period_days]), []).
test(a_long_period_with_an_absent_reference_period_answers) :-
    Profile = [attribute(on_call_on_site_counts_as_working_time, unsure), attribute(on_call_standby_counts_as_working_time, false), attribute(worker_category, seagoing_fishing_vessel_worker), attribute(night_worker, true), attribute(derogation_from_article_8, no_derogation)],
    Shifts = [shift(worker_1, date_time(2026, 3, 2, 22, 0), date_time(2026, 3, 3, 6, 0), work)],
    findall(Result, night_work_average_status(Profile, 5, Shifts, date(2024, 2, 29), date(2026, 11, 30), Result, _), Results),
    Results == [average_night_hours_kept].
test(a_derogation_behind_the_category_is_not_named) :-
    Profile = [attribute(on_call_on_site_counts_as_working_time, true), attribute(on_call_standby_counts_as_working_time, false), attribute(night_work_reference_period_days, 7), attribute(night_worker, true)],
    seven_night_shifts(Shifts),
    night_work_average_status(Profile, worker_1, Shifts, date(2026, 3, 2), date(2026, 3, 8), indeterminate([worker_category]), []).
test(an_unsure_night_worker_goes_to_a_lawyer) :-
    sample_profile(true, false, other_worker, unsure, true, no_derogation, Profile),
    seven_night_shifts(Shifts),
    night_work_average_status(Profile, worker_1, Shifts, date(2026, 3, 2), date(2026, 3, 8), Result, []),
    Result == needs_legal_review(open_textured(night_worker, cite(eu_dir_2003_88_art_2_4)), [inputs_relied_on([on_call_on_site_counts_as_working_time - true, on_call_standby_counts_as_working_time - false, night_worker - unsure])]).
test(an_empty_profile_and_rota_keep_the_average) :-
    night_work_average_status([], worker_1, [], date(2026, 3, 2), date(2026, 3, 8), average_night_hours_kept, _).
test(an_empty_profile_and_rota_keep_the_hazardous_limit) :-
    hazardous_night_work_status([], worker_1, [], date(2026, 3, 2), date(2026, 3, 8), hazardous_night_work_hours_kept, _).
test(eight_hour_nights_keep_the_hazardous_limit) :-
    sample_profile(true, false, other_worker, true, true, no_derogation, Profile),
    seven_night_shifts(Shifts),
    hazardous_night_work_status(Profile, worker_1, Shifts, date(2026, 3, 2), date(2026, 3, 8), hazardous_night_work_hours_kept, _).
test(a_nine_hour_night_exceeds_the_hazardous_limit) :-
    sample_profile(true, false, other_worker, true, true, no_derogation, Profile),
    Shifts = [shift(worker_1, date_time(2026, 3, 2, 21, 0), date_time(2026, 3, 3, 6, 0), work)],
    hazardous_night_work_status(Profile, worker_1, Shifts, date(2026, 3, 2), date(2026, 3, 2), Result, Citations),
    Result == hazardous_night_work_hours_exceeded,
    Citations == [cite(eu_dir_2003_88_art_2_1), cite(eu_dir_2003_88_art_2_3), cite(eu_dir_2003_88_art_2_4), cite(eu_dir_2003_88_art_8), cite(eu_dir_2003_88_art_8_b), cite(eu_dir_2003_88_art_8_final_subpara)].
test(a_nine_hour_night_without_special_hazards) :-
    sample_profile(true, false, other_worker, true, false, no_derogation, Profile),
    Shifts = [shift(worker_1, date_time(2026, 3, 2, 21, 0), date_time(2026, 3, 3, 6, 0), work)],
    hazardous_night_work_status(Profile, worker_1, Shifts, date(2026, 3, 2), date(2026, 3, 2), no_special_hazards_or_heavy_strain, _).
test(a_long_day_shift_without_night_minutes_is_kept) :-
    sample_profile(true, false, other_worker, true, true, no_derogation, Profile),
    Shifts = [shift(worker_1, date_time(2026, 3, 2, 8, 0), date_time(2026, 3, 2, 18, 0), work)],
    hazardous_night_work_status(Profile, worker_1, Shifts, date(2026, 3, 2), date(2026, 3, 2), hazardous_night_work_hours_kept, _).
test(an_absent_night_time_that_decides_is_asked_for) :-
    Profile = [attribute(on_call_on_site_counts_as_working_time, true), attribute(on_call_standby_counts_as_working_time, false), attribute(worker_category, other_worker), attribute(night_worker, true), attribute(special_hazards_or_heavy_strain, true), attribute(derogation_from_article_8, no_derogation)],
    Shifts = [shift(worker_1, date_time(2026, 3, 2, 6, 0), date_time(2026, 3, 2, 17, 0), work)],
    hazardous_night_work_status(Profile, worker_1, Shifts, date(2026, 3, 2), date(2026, 3, 2), indeterminate([night_time_start]), []).
test(an_unsure_standby_key_goes_to_a_lawyer) :-
    sample_profile(true, unsure, other_worker, true, true, no_derogation, Profile),
    Shifts = [shift(worker_1, date_time(2026, 3, 2, 22, 0), date_time(2026, 3, 3, 2, 0), work), shift(worker_1, date_time(2026, 3, 3, 2, 0), date_time(2026, 3, 3, 8, 0), on_call_standby)],
    hazardous_night_work_status(Profile, worker_1, Shifts, date(2026, 3, 2), date(2026, 3, 2), Result, []),
    Result == needs_legal_review(open_textured(on_call_standby_counts_as_working_time, cite(eu_dir_2003_88_art_2_1)), [inputs_relied_on([on_call_on_site_counts_as_working_time - true, on_call_standby_counts_as_working_time - unsure, night_worker - true, special_hazards_or_heavy_strain - true])]).
test(an_unbound_worker_is_an_input_problem) :-
    night_work_average_status([], _, [], date(2026, 3, 2), date(2026, 3, 8), input_problems([wrong_type(worker)]), []).
test(a_period_end_before_its_start_is_an_input_problem) :-
    hazardous_night_work_status([], worker_1, [], date(2026, 3, 8), date(2026, 3, 2), input_problems([wrong_type(period_end)]), []).
test(overlapping_shifts_are_an_input_problem) :-
    Shifts = [shift(worker_1, date_time(2026, 3, 2, 20, 0), date_time(2026, 3, 2, 23, 0), work), shift(worker_1, date_time(2026, 3, 2, 22, 0), date_time(2026, 3, 3, 2, 0), work)],
    night_work_average_status([], worker_1, Shifts, date(2026, 3, 2), date(2026, 3, 2), input_problems([wrong_type(shifts)]), []).
test(profile_problems_come_before_argument_problems) :-
    night_work_average_status([attribute(colour, red)], worker(3), [], date(2026, 3, 2), date(2026, 3, 2), input_problems([unknown_key(colour), wrong_type(worker)]), []).
test(the_facade_projects_the_status) :-
    sample_profile(true, false, other_worker, true, true, no_derogation, Profile),
    six_night_shifts(Shifts),
    night_work_status(average_case(Profile, worker_1, Shifts, date(2026, 3, 2), date(2026, 3, 8)), average_night_hours_kept).

test(seven_nights_are_not_kept, fail) :-
    sample_profile(true, false, other_worker, true, true, no_derogation, Profile),
    seven_night_shifts(Shifts),
    night_work_average_status(Profile, worker_1, Shifts, date(2026, 3, 2), date(2026, 3, 8), average_night_hours_kept, _).
