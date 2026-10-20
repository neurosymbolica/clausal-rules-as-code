:- module(m__eu_procurement_time_limits_tests_test_queries, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_procurement_time_limits_queries, [time_limits_profile_keys/1, time_limits_what_if/4, time_limits_enumerate/4, time_limits_floor/3]).
:- use_module(m__eu_procurement_time_limits_fixtures, [time_limits_profile_for/2]).

test('profile keys: all six input keys are declared') :-
    time_limits_profile_keys(ProfileKeys),
    length(ProfileKeys, 6),
    member(procedure_type_key, ProfileKeys),
    member(stage_key, ProfileKeys),
    member(prior_information_notice_published, ProfileKeys),
    member(electronic_submission_accepted, ProfileKeys),
    member(state_of_urgency_substantiated, ProfileKeys),
    member(observed_time_limit_days, ProfileKeys).
test('what_if: turning electronic submission on moves open tenders 35 -> 30') :-
    time_limits_profile_for("open_tenders_baseline", Profile),
    time_limits_what_if(Profile, electronic_submission_accepted, true, 30).
test('what_if: withdrawing the urgency substantiation moves restricted tenders 10 -> 30') :-
    time_limits_profile_for("restricted_tenders_urgency", Profile),
    time_limits_what_if(Profile, state_of_urgency_substantiated, false, 30).
test('enumerate: the published open-procedure rows are all present') :-
    time_limits_enumerate(open_procedure, receipt_of_tenders, baseline_minimum, 35),
    time_limits_enumerate(open_procedure, receipt_of_tenders, with_prior_information_notice, 15),
    time_limits_enumerate(open_procedure, receipt_of_tenders, with_electronic_submission, 30),
    time_limits_enumerate(open_procedure, receipt_of_tenders, under_state_of_urgency, 15).
test('enumerate: the table has exactly 18 published rows') :-
    findall([ProcedureType, Stage, ReductionCondition, Days], time_limits_enumerate(ProcedureType, Stage, ReductionCondition, Days), RowList),
    length(RowList, 18).
test('floor: fully-reduced floors match the published least figures') :-
    time_limits_floor(open_procedure, receipt_of_tenders, 15),
    time_limits_floor(restricted_procedure, receipt_of_tenders, 10),
    time_limits_floor(restricted_procedure, receipt_of_participation_requests, 15),
    time_limits_floor(competitive_dialogue, receipt_of_participation_requests, 30).

cp_test_names(['profile keys: all six input keys are declared', 'what_if: turning electronic submission on moves open tenders 35 -> 30', 'what_if: withdrawing the urgency substantiation moves restricted tenders 10 -> 30', 'enumerate: the published open-procedure rows are all present', 'enumerate: the table has exactly 18 published rows', 'floor: fully-reduced floors match the published least figures']).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
