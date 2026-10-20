:- module(m__eu_procurement_utilities_negotiated_without_prior_call_tests_test_properties, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_procurement_utilities_negotiated_without_prior_call_utilities_negotiated_without_prior_call, [decide_utilities_negotiated_without_prior_call/2]).
:- use_module(m__eu_procurement_utilities_negotiated_without_prior_call_fixtures, [utilities_negotiated_without_prior_call_subject/1, utilities_negotiated_without_prior_call_profile_for/2]).

test('P1 totality: every subject yields exactly one verdict') :-
    findall(Subject, utilities_negotiated_without_prior_call_subject(Subject), SubjectList),
    length(SubjectList, SubjectCount),
    findall(Subject, (utilities_negotiated_without_prior_call_subject(Subject), utilities_negotiated_without_prior_call_profile_for(Subject, Profile), findall(Verdict, decide_utilities_negotiated_without_prior_call(Profile, Verdict), VerdictList), length(VerdictList, 1)), ClassifiedList),
    length(ClassifiedList, SubjectCount).
test('P2 determinism: same profile gives same verdict on repeated calls') :-
    findall(Subject, (utilities_negotiated_without_prior_call_subject(Subject), utilities_negotiated_without_prior_call_profile_for(Subject, Profile), findall(V1, decide_utilities_negotiated_without_prior_call(Profile, V1), List1), findall(V2, decide_utilities_negotiated_without_prior_call(Profile, V2), List2), List1 = List2), DeterministicList),
    findall(Subject, utilities_negotiated_without_prior_call_subject(Subject), AllSubjects),
    length(DeterministicList, AllCount),
    length(AllSubjects, AllCount).
test('P3 structure: every verdict is a utilities_negotiated_verdict/3 term') :-
    findall(Subject, (utilities_negotiated_without_prior_call_subject(Subject), utilities_negotiated_without_prior_call_profile_for(Subject, Profile), findall(Verdict, decide_utilities_negotiated_without_prior_call(Profile, Verdict), VerdictList), length(VerdictList, 1), member(utilities_negotiated_verdict(_, _, _), VerdictList)), StructuredList),
    findall(Subject, utilities_negotiated_without_prior_call_subject(Subject), AllSubjects),
    length(StructuredList, AllCount),
    length(AllSubjects, AllCount).

cp_test_names(['P1 totality: every subject yields exactly one verdict', 'P2 determinism: same profile gives same verdict on repeated calls', 'P3 structure: every verdict is a utilities_negotiated_verdict/3 term']).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
