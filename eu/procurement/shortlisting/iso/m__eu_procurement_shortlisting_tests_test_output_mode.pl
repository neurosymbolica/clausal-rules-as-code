:- module(m__eu_procurement_shortlisting_tests_test_output_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_procurement_shortlisting_shortlisting, [decide_shortlisting/2, shortlisting_status/2, statutory_minimum_candidates/2, shortlisting_invitation_floor/4, shortlisting_limitation_modality/4, shortlisting_inclusion_modality/2]).
:- use_module(m__eu_procurement_shortlisting_fixtures, [shortlisting_profile_for/2]).

test('output mode: restricted all-clear yields limitation_permitted') :-
    shortlisting_profile_for("restricted_all_clear", Profile),
    findall(Status, shortlisting_status(Profile, Status), StatusList),
    StatusList = [limitation_permitted].
test('output mode: restricted defect yields limitation_prohibited') :-
    shortlisting_profile_for("restricted_defect_criteria", Profile),
    findall(Status, shortlisting_status(Profile, Status), StatusList),
    StatusList = [limitation_prohibited].
test('output mode: restricted continuation yields continuation_permitted') :-
    shortlisting_profile_for("restricted_continuation", Profile),
    findall(Status, shortlisting_status(Profile, Status), StatusList),
    StatusList = [continuation_permitted].
test('output mode: open procedure yields limitation_not_available') :-
    shortlisting_profile_for("open_procedure", Profile),
    findall(Status, shortlisting_status(Profile, Status), StatusList),
    StatusList = [limitation_not_available].
test('output mode: verdict carries a citation list for defects') :-
    shortlisting_profile_for("restricted_defect_criteria", Profile),
    decide_shortlisting(Profile, shortlisting_verdict(_, DefectIds, _NumberToInvite, Citations)),
    DefectIds = [_|_],
    Citations = [_|_].
test('output mode: statutory minimum for restricted is 5') :-
    findall(Min, statutory_minimum_candidates(restricted_procedure, Min), MinList),
    MinList = [5].
test('output mode: statutory minimum for CPWN is 3') :-
    findall(Min, statutory_minimum_candidates(competitive_procedure_with_negotiation, Min), MinList),
    MinList = [3].
test('output mode: invitation floor for restricted at statutory boundary') :-
    findall(Floor, shortlisting_invitation_floor(restricted_procedure, 5, 10, Floor), FloorList),
    FloorList = [5].
test('output mode: invitation floor for restricted continuation') :-
    findall(Floor, shortlisting_invitation_floor(restricted_procedure, 5, 4, Floor), FloorList),
    FloorList = [4].
test('output mode: inclusion modality enumerates all three statuses') :-
    findall(Mod, shortlisting_inclusion_modality(requested_and_has_required_capabilities, Mod), ModList),
    ModList = [inclusion_permitted].
test('output mode: inclusion modality for non-requesting') :-
    findall(Mod, shortlisting_inclusion_modality(did_not_request_to_participate, Mod), ModList),
    ModList = [inclusion_prohibited].

cp_test_names(['output mode: restricted all-clear yields limitation_permitted', 'output mode: restricted defect yields limitation_prohibited', 'output mode: restricted continuation yields continuation_permitted', 'output mode: open procedure yields limitation_not_available', 'output mode: verdict carries a citation list for defects', 'output mode: statutory minimum for restricted is 5', 'output mode: statutory minimum for CPWN is 3', 'output mode: invitation floor for restricted at statutory boundary', 'output mode: invitation floor for restricted continuation', 'output mode: inclusion modality enumerates all three statuses', 'output mode: inclusion modality for non-requesting']).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
