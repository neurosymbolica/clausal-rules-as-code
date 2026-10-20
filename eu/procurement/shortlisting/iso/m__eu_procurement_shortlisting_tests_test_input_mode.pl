:- module(m__eu_procurement_shortlisting_tests_test_input_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_procurement_shortlisting_shortlisting, [shortlisting_status/2, statutory_minimum_candidates/2, shortlisting_inclusion_modality/2]).
:- use_module(m__eu_procurement_shortlisting_fixtures, [shortlisting_profile_for/2]).
:- use_module(formalize_lib, [not_member/2]).

shortlisting_status_never(Profile, Status) :-
    findall(Found, shortlisting_status(Profile, Found), FoundStatuses),
    not_member(Status, FoundStatuses).

test('input mode: status holds with the verdict bound') :-
    shortlisting_profile_for("restricted_all_clear", Profile),
    shortlisting_status(Profile, limitation_permitted).
test('input mode: the wrong bound status is rejected') :-
    shortlisting_profile_for("restricted_all_clear", Profile),
    shortlisting_status_never(Profile, limitation_prohibited).
test('input mode: statutory minimum for restricted is 5') :-
    statutory_minimum_candidates(restricted_procedure, 5).
test('input mode: statutory minimum for CPWN is 3') :-
    statutory_minimum_candidates(competitive_procedure_with_negotiation, 3).
test('input mode: statutory minimum has no solution for open procedure') :-
    findall(Minimum, statutory_minimum_candidates(open_procedure, Minimum), []).
test('input mode: inclusion modality for requested and capable is permitted') :-
    shortlisting_inclusion_modality(requested_and_has_required_capabilities, inclusion_permitted).
test('input mode: inclusion modality for non-requesting is prohibited') :-
    shortlisting_inclusion_modality(did_not_request_to_participate, inclusion_prohibited).
test('input mode: open procedure status is limitation_not_available') :-
    shortlisting_profile_for("open_procedure", Profile),
    shortlisting_status(Profile, limitation_not_available).
test('input mode: continuation profile yields continuation_permitted') :-
    shortlisting_profile_for("restricted_continuation", Profile),
    shortlisting_status(Profile, continuation_permitted).

cp_test_names(['input mode: status holds with the verdict bound', 'input mode: the wrong bound status is rejected', 'input mode: statutory minimum for restricted is 5', 'input mode: statutory minimum for CPWN is 3', 'input mode: statutory minimum has no solution for open procedure', 'input mode: inclusion modality for requested and capable is permitted', 'input mode: inclusion modality for non-requesting is prohibited', 'input mode: open procedure status is limitation_not_available', 'input mode: continuation profile yields continuation_permitted']).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
