:- module(m__eu_procurement_shortlisting_tests_test_negative_controls, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(library(clpz)).
:- use_module(m__eu_procurement_shortlisting_shortlisting, [shortlisting_status/2, shortlisting_invitation_floor/4]).
:- use_module(m__eu_procurement_shortlisting_fixtures, [shortlisting_profile_for/2]).
:- use_module(formalize_lib, [not_member/2]).

shortlisting_status_never(Profile, Status) :-
    findall(Found, shortlisting_status(Profile, Found), FoundStatuses),
    not_member(Status, FoundStatuses).

test('negative control: all-clear is NOT limitation_prohibited') :-
    shortlisting_profile_for("restricted_all_clear", Profile),
    shortlisting_status_never(Profile, limitation_prohibited).
test('negative control: below-statutory IS limitation_prohibited') :-
    shortlisting_profile_for("restricted_below_statutory", Profile),
    shortlisting_status(Profile, limitation_prohibited).
test('negative control: below-statutory is NOT limitation_permitted') :-
    shortlisting_profile_for("restricted_below_statutory", Profile),
    shortlisting_status_never(Profile, limitation_permitted).
test('negative control: at-boundary is NOT continuation_permitted') :-
    shortlisting_profile_for("restricted_at_continuation_boundary", Profile),
    shortlisting_status_never(Profile, continuation_permitted).
test('negative control: continuation IS continuation_permitted') :-
    shortlisting_profile_for("restricted_continuation", Profile),
    shortlisting_status(Profile, continuation_permitted).
test('negative control: continuation is NOT limitation_permitted') :-
    shortlisting_profile_for("restricted_continuation", Profile),
    shortlisting_status_never(Profile, limitation_permitted).
test('negative control: max_at_min is NOT limitation_prohibited') :-
    shortlisting_profile_for("restricted_max_at_min", Profile),
    shortlisting_status_never(Profile, limitation_prohibited).
test('negative control: max_below_min IS limitation_prohibited') :-
    shortlisting_profile_for("restricted_max_below_min", Profile),
    shortlisting_status(Profile, limitation_prohibited).
test('negative control: max_below_min is NOT limitation_permitted') :-
    shortlisting_profile_for("restricted_max_below_min", Profile),
    shortlisting_status_never(Profile, limitation_permitted).
test('negative control: open procedure is NOT limitation_permitted') :-
    shortlisting_profile_for("open_procedure", Profile),
    shortlisting_status_never(Profile, limitation_permitted).
test('negative control: open procedure is NOT limitation_prohibited') :-
    shortlisting_profile_for("open_procedure", Profile),
    shortlisting_status_never(Profile, limitation_prohibited).
test('negative control: open procedure IS limitation_not_available') :-
    shortlisting_profile_for("open_procedure", Profile),
    shortlisting_status(Profile, limitation_not_available).
test('negative control: defect_criteria is NOT limitation_permitted') :-
    shortlisting_profile_for("restricted_defect_criteria", Profile),
    shortlisting_status_never(Profile, limitation_permitted).
test('negative control: defect_criteria IS limitation_prohibited') :-
    shortlisting_profile_for("restricted_defect_criteria", Profile),
    shortlisting_status(Profile, limitation_prohibited).
test('negative control: cpwn_all_clear is NOT continuation_permitted') :-
    shortlisting_profile_for("cpwn_all_clear", Profile),
    shortlisting_status_never(Profile, continuation_permitted).
test('negative control: cpwn_continuation IS continuation_permitted') :-
    shortlisting_profile_for("cpwn_continuation", Profile),
    shortlisting_status(Profile, continuation_permitted).
test('negative control: cpwn_continuation is NOT limitation_permitted') :-
    shortlisting_profile_for("cpwn_continuation", Profile),
    shortlisting_status_never(Profile, limitation_permitted).
test('negative control: floor at statutory is 5 not 4') :-
    shortlisting_invitation_floor(restricted_procedure, 5, 10, Floor),
    Floor #= 5.
test('negative control: floor below statutory returns qualified not 5') :-
    shortlisting_invitation_floor(restricted_procedure, 4, 10, Floor),
    Floor #= 10.

cp_test_names(['negative control: all-clear is NOT limitation_prohibited', 'negative control: below-statutory IS limitation_prohibited', 'negative control: below-statutory is NOT limitation_permitted', 'negative control: at-boundary is NOT continuation_permitted', 'negative control: continuation IS continuation_permitted', 'negative control: continuation is NOT limitation_permitted', 'negative control: max_at_min is NOT limitation_prohibited', 'negative control: max_below_min IS limitation_prohibited', 'negative control: max_below_min is NOT limitation_permitted', 'negative control: open procedure is NOT limitation_permitted', 'negative control: open procedure is NOT limitation_prohibited', 'negative control: open procedure IS limitation_not_available', 'negative control: defect_criteria is NOT limitation_permitted', 'negative control: defect_criteria IS limitation_prohibited', 'negative control: cpwn_all_clear is NOT continuation_permitted', 'negative control: cpwn_continuation IS continuation_permitted', 'negative control: cpwn_continuation is NOT limitation_permitted', 'negative control: floor at statutory is 5 not 4', 'negative control: floor below statutory returns qualified not 5']).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
