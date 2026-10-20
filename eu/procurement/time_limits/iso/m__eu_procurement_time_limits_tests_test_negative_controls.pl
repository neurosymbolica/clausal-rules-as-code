:- module(m__eu_procurement_time_limits_tests_test_negative_controls, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_procurement_time_limits_time_limits, [minimum_days/2, time_limits_status/2]).
:- use_module(m__eu_procurement_time_limits_fixtures, [time_limits_profile_for/2]).
:- use_module(m__eu_procurement_time_limits_queries, [time_limits_what_if/4]).
:- use_module(formalize_lib, [not_member/2]).

minimum_days_never(Profile, Days) :-
    findall(Found, minimum_days(Profile, Found), FoundDays),
    not_member(Days, FoundDays).

time_limits_what_if_never(Profile, Key, Value, Days) :-
    findall(Found, time_limits_what_if(Profile, Key, Value, Found), FoundDays),
    not_member(Days, FoundDays).

test('open: notice route positive (15) vs negative control without notice (35)') :-
    time_limits_profile_for("open_tenders_prior_information_notice", Profile),
    minimum_days(Profile, 15),
    time_limits_what_if(Profile, prior_information_notice_published, false, 35).
test('open: electronic route positive (30) vs negative control without it (35)') :-
    time_limits_profile_for("open_tenders_electronic_submission", Profile),
    minimum_days(Profile, 30),
    time_limits_what_if(Profile, electronic_submission_accepted, false, 35).
test('open: urgency route positive (15) vs negative control without urgency (35)') :-
    time_limits_profile_for("open_tenders_urgency", Profile),
    minimum_days(Profile, 15),
    time_limits_what_if(Profile, state_of_urgency_substantiated, false, 35).
test('open: notice + electronic is exactly 15 -- the compounded 10 is rejected') :-
    time_limits_profile_for("open_tenders_prior_notice_and_electronic", Profile),
    minimum_days(Profile, 15),
    minimum_days_never(Profile, 10).
test('restricted: notice + electronic tenders are exactly 10 -- 5 is rejected') :-
    time_limits_profile_for("restricted_tenders_prior_information_notice", Profile),
    time_limits_what_if(Profile, electronic_submission_accepted, true, 10),
    time_limits_what_if_never(Profile, electronic_submission_accepted, true, 5).
test('restricted tenders: electronic route positive (25) rejects 30 and 20') :-
    time_limits_profile_for("restricted_tenders_electronic_submission", Profile),
    minimum_days(Profile, 25),
    minimum_days_never(Profile, 30),
    minimum_days_never(Profile, 20).
test('dialogue requests: urgency claim leaves the minimum at 30 -- 15 is rejected') :-
    time_limits_profile_for("dialogue_requests_urgency_claimed", Profile),
    minimum_days(Profile, 30),
    minimum_days_never(Profile, 15).
test('negotiation requests: the same urgency claim reduces 30 to 15') :-
    time_limits_profile_for("negotiation_requests_urgency", Profile),
    minimum_days(Profile, 15),
    time_limits_what_if(Profile, state_of_urgency_substantiated, false, 30).
test('baseline subjects never leak a reduced figure') :-
    time_limits_profile_for("open_tenders_baseline", OpenProfile),
    minimum_days_never(OpenProfile, 15),
    minimum_days_never(OpenProfile, 30),
    time_limits_profile_for("restricted_tenders_baseline", RestrictedProfile),
    minimum_days_never(RestrictedProfile, 10),
    minimum_days_never(RestrictedProfile, 25),
    time_limits_status(RestrictedProfile, minimum_days_prescribed).

cp_test_names(['open: notice route positive (15) vs negative control without notice (35)', 'open: electronic route positive (30) vs negative control without it (35)', 'open: urgency route positive (15) vs negative control without urgency (35)', 'open: notice + electronic is exactly 15 -- the compounded 10 is rejected', 'restricted: notice + electronic tenders are exactly 10 -- 5 is rejected', 'restricted tenders: electronic route positive (25) rejects 30 and 20', 'dialogue requests: urgency claim leaves the minimum at 30 -- 15 is rejected', 'negotiation requests: the same urgency claim reduces 30 to 15', 'baseline subjects never leak a reduced figure']).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
