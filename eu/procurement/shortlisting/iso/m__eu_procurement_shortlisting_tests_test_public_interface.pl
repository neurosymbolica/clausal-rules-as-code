:- module(m__eu_procurement_shortlisting_tests_test_public_interface, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(library(clpz)).
:- use_module(m__eu_procurement_shortlisting_shortlisting, [decide_shortlisting/2, shortlisting_status/2, shortlisting_checklist/2, shortlisting_decision_resolvable/1, shortlisting_status_values/1, statutory_minimum_candidates/2, shortlisting_limitation_modality/4, shortlisting_invitation_floor/4, shortlisting_inclusion_modality/2]).
:- use_module(m__eu_procurement_shortlisting_fixtures, [shortlisting_subject/1, shortlisting_profile_for/2, shortlisting_assess/2]).

test('restricted_all_clear resolves to limitation_permitted') :-
    shortlisting_assess("restricted_all_clear", shortlisting_verdict(limitation_permitted, Defects, Floor, _Citations)),
    Defects = [],
    Floor #= 5.
test('restricted_below_statutory resolves to limitation_prohibited') :-
    shortlisting_assess("restricted_below_statutory", shortlisting_verdict(limitation_prohibited, Defects, Floor, _Citations)),
    Defects = [_|_],
    Floor #= 10.
test('restricted_at_continuation_boundary resolves to limitation_permitted') :-
    shortlisting_assess("restricted_at_continuation_boundary", shortlisting_verdict(limitation_permitted, Defects, Floor, _Citations)),
    Defects = [],
    Floor #= 5.
test('restricted_continuation resolves to continuation_permitted') :-
    shortlisting_assess("restricted_continuation", shortlisting_verdict(continuation_permitted, Defects, Floor, _Citations)),
    Defects = [],
    Floor #= 4.
test('restricted_max_at_min resolves to limitation_permitted') :-
    shortlisting_assess("restricted_max_at_min", shortlisting_verdict(limitation_permitted, Defects, Floor, _Citations)),
    Defects = [],
    Floor #= 5.
test('restricted_max_below_min resolves to limitation_prohibited') :-
    shortlisting_assess("restricted_max_below_min", shortlisting_verdict(limitation_prohibited, Defects, Floor, _Citations)),
    Defects = [_|_],
    Floor #= 5.
test('open_procedure resolves to limitation_not_available') :-
    shortlisting_assess("open_procedure", shortlisting_verdict(limitation_not_available, Defects, Floor, _Citations)),
    Defects = [],
    Floor #= 0.
test('restricted_defect_criteria resolves to limitation_prohibited') :-
    shortlisting_assess("restricted_defect_criteria", shortlisting_verdict(limitation_prohibited, Defects, Floor, _Citations)),
    Defects = [_|_],
    Floor #= 5.
test('cpwn_all_clear resolves to limitation_permitted') :-
    shortlisting_assess("cpwn_all_clear", shortlisting_verdict(limitation_permitted, Defects, Floor, _Citations)),
    Defects = [],
    Floor #= 3.
test('cpwn_continuation resolves to continuation_permitted') :-
    shortlisting_assess("cpwn_continuation", shortlisting_verdict(continuation_permitted, Defects, Floor, _Citations)),
    Defects = [],
    Floor #= 2.
test('checklist non-empty for restricted_all_clear') :-
    shortlisting_profile_for("restricted_all_clear", Profile),
    shortlisting_checklist(Profile, Checklist),
    Checklist = [_|_].
test('checklist non-empty for restricted_below_statutory') :-
    shortlisting_profile_for("restricted_below_statutory", Profile),
    shortlisting_checklist(Profile, Checklist),
    Checklist = [_|_].
test('checklist non-empty for open_procedure') :-
    shortlisting_profile_for("open_procedure", Profile),
    shortlisting_checklist(Profile, Checklist),
    Checklist = [_|_].
test('near-miss statutory: at-boundary is permitted, just-below is prohibited') :-
    shortlisting_assess("restricted_all_clear", shortlisting_verdict(limitation_permitted, _, _, _)),
    shortlisting_assess("restricted_below_statutory", shortlisting_verdict(limitation_prohibited, _, _, _)).
test('near-miss continuation: at-boundary is permitted, just-below is continuation') :-
    shortlisting_assess("restricted_at_continuation_boundary", shortlisting_verdict(limitation_permitted, _, _, _)),
    shortlisting_assess("restricted_continuation", shortlisting_verdict(continuation_permitted, _, _, _)).
test('near-miss max-vs-min: at-boundary is permitted, just-below is prohibited') :-
    shortlisting_assess("restricted_max_at_min", shortlisting_verdict(limitation_permitted, _, _, _)),
    shortlisting_assess("restricted_max_below_min", shortlisting_verdict(limitation_prohibited, _, _, _)).
test('status_values enumerates all four modal atoms') :-
    shortlisting_status_values(Values),
    member(limitation_not_available, Values),
    member(limitation_prohibited, Values),
    member(continuation_permitted, Values),
    member(limitation_permitted, Values).
test('decision resolvable for restricted_all_clear') :-
    shortlisting_profile_for("restricted_all_clear", Profile),
    shortlisting_decision_resolvable(Profile).
test('decision resolvable for open_procedure') :-
    shortlisting_profile_for("open_procedure", Profile),
    shortlisting_decision_resolvable(Profile).
test('statutory_minimum_candidates: restricted is 5') :-
    statutory_minimum_candidates(restricted_procedure, 5).
test('statutory_minimum_candidates: CPWN is 3') :-
    statutory_minimum_candidates(competitive_procedure_with_negotiation, 3).
test('inclusion_modality: requested_and_has_required_capabilities is permitted') :-
    shortlisting_inclusion_modality(requested_and_has_required_capabilities, inclusion_permitted).
test('inclusion_modality: did_not_request_to_participate is prohibited') :-
    shortlisting_inclusion_modality(did_not_request_to_participate, inclusion_prohibited).
test('inclusion_modality: requested_without_required_capabilities is prohibited') :-
    shortlisting_inclusion_modality(requested_without_required_capabilities, inclusion_prohibited).
test('invitation_floor: open_procedure yields 0') :-
    shortlisting_invitation_floor(open_procedure, 5, 10, 0).
test('invitation_floor: restricted at declared_min yields declared_min') :-
    shortlisting_invitation_floor(restricted_procedure, 5, 10, 5).
test('invitation_floor: restricted continuation yields qualified') :-
    shortlisting_invitation_floor(restricted_procedure, 5, 3, 3).
test('invitation_floor: restricted below statutory yields qualified') :-
    shortlisting_invitation_floor(restricted_procedure, 4, 10, 10).
test('limitation_modality: open_procedure is not_available') :-
    shortlisting_limitation_modality(open_procedure, 5, 10, limitation_not_available).
test('limitation_modality: restricted at floor is permitted') :-
    shortlisting_limitation_modality(restricted_procedure, 5, 10, limitation_permitted).
test('limitation_modality: restricted below statutory is prohibited') :-
    shortlisting_limitation_modality(restricted_procedure, 4, 10, limitation_prohibited).
test('limitation_modality: restricted continuation is permitted') :-
    shortlisting_limitation_modality(restricted_procedure, 5, 3, continuation_permitted).

cp_test_names(['restricted_all_clear resolves to limitation_permitted', 'restricted_below_statutory resolves to limitation_prohibited', 'restricted_at_continuation_boundary resolves to limitation_permitted', 'restricted_continuation resolves to continuation_permitted', 'restricted_max_at_min resolves to limitation_permitted', 'restricted_max_below_min resolves to limitation_prohibited', 'open_procedure resolves to limitation_not_available', 'restricted_defect_criteria resolves to limitation_prohibited', 'cpwn_all_clear resolves to limitation_permitted', 'cpwn_continuation resolves to continuation_permitted', 'checklist non-empty for restricted_all_clear', 'checklist non-empty for restricted_below_statutory', 'checklist non-empty for open_procedure', 'near-miss statutory: at-boundary is permitted, just-below is prohibited', 'near-miss continuation: at-boundary is permitted, just-below is continuation', 'near-miss max-vs-min: at-boundary is permitted, just-below is prohibited', 'status_values enumerates all four modal atoms', 'decision resolvable for restricted_all_clear', 'decision resolvable for open_procedure', 'statutory_minimum_candidates: restricted is 5', 'statutory_minimum_candidates: CPWN is 3', 'inclusion_modality: requested_and_has_required_capabilities is permitted', 'inclusion_modality: did_not_request_to_participate is prohibited', 'inclusion_modality: requested_without_required_capabilities is prohibited', 'invitation_floor: open_procedure yields 0', 'invitation_floor: restricted at declared_min yields declared_min', 'invitation_floor: restricted continuation yields qualified', 'invitation_floor: restricted below statutory yields qualified', 'limitation_modality: open_procedure is not_available', 'limitation_modality: restricted at floor is permitted', 'limitation_modality: restricted below statutory is prohibited', 'limitation_modality: restricted continuation is permitted']).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
