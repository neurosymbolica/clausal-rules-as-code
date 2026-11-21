% SPDX-License-Identifier: EUPL-1.2
:- module(m__us_texas_tdpsa_tests_test_properties, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(library(clpz)).
:- use_module(m__us_texas_tdpsa_texas_tdpsa, [decide_texas_tdpsa/2, applicability_status/4, response_deadline/4, extended_response_deadline/4, appeal_response_deadline/4, cure_period_last_day/4, attorney_general_action_status/5, civil_penalty_maximum/3, texas_tdpsa_checklist/2]).
:- use_module(m__us_texas_tdpsa_kernel, [texas_tdpsa_input_problems/2]).
:- use_module(m__us_texas_tdpsa_fixtures, [texas_tdpsa_subject/1, texas_tdpsa_profile_for/2]).

subject_classifies(Subject) :-
    texas_tdpsa_subject(Subject),
    texas_tdpsa_profile_for(Subject, Profile),
    decide_texas_tdpsa(Profile, _Verdict).

test(totality_every_subject_classifies) :-
    findall(Subject, texas_tdpsa_subject(Subject), Subjects),
    sort(Subjects, SubjectSet),
    findall(Subject, subject_classifies(Subject), ClassifiedSubjects),
    sort(ClassifiedSubjects, SubjectSet).
test(determinism_every_query_answers_every_subject_once) :-
    findall(Subject - QueryName - Count, (texas_tdpsa_subject(Subject), query_name(QueryName), subject_answer_count(Subject, QueryName, Count)), Observed),
    findall(Subject - QueryName - 1, (texas_tdpsa_subject(Subject), query_name(QueryName)), Expected),
    Observed == Expected.
test(citation_completeness_every_applicability_answer_has_its_shape) :-
    findall(Subject, texas_tdpsa_subject(Subject), Subjects),
    findall(Subject, subject_has_applicability_shape(Subject), ShapedSubjects),
    ShapedSubjects == Subjects.
test(justification_every_checklist_item_carries_a_citation) :-
    findall(Subject, texas_tdpsa_subject(Subject), Subjects),
    findall(Subject, subject_checklist_cited(Subject), CitedSubjects),
    CitedSubjects == Subjects.
test(invariant_response_deadline_reads_no_profile_key) :-
    findall(Pair, well_formed_response(Pair), Pairs),
    length(Pairs, 20),
    maplist(result_is(date(2026, 2, 15)), Pairs).
test(invariant_cure_period_running_reads_no_profile_key) :-
    findall(Pair, well_formed_running(Pair), Pairs),
    length(Pairs, 20),
    maplist(result_is(cure_period_running), Pairs).
test(invariant_penalty_grows_by_7500_per_violation) :-
    maplist(penalty_for, [0, 1, 2, 3, 4], Results),
    Results == [0, 7500, 15000, 22500, 30000].
test(invariant_large_count_stays_an_integer) :-
    penalty_for(1000000, Result),
    integer(Result),
    Result #= 7500000000.

query_name(verdict).
query_name(applicability).
query_name(response).
query_name(extension).
query_name(appeal).
query_name(cure).
query_name(action_running).
query_name(action_passed).
query_name(penalty).
query_name(checklist).
query_name(input_check).

query_answers(verdict, Profile, Answers) :-
    findall(Verdict, decide_texas_tdpsa(Profile, Verdict), Answers).
query_answers(applicability, Profile, Answers) :-
    findall(Result - Basis - Citations, applicability_status(Profile, Result, Basis, Citations), Answers).
query_answers(response, Profile, Answers) :-
    findall(Result - Citations, response_deadline(Profile, date(2026, 1, 1), Result, Citations), Answers).
query_answers(extension, Profile, Answers) :-
    findall(Result - Citations, extended_response_deadline(Profile, date(2026, 1, 1), Result, Citations), Answers).
query_answers(appeal, Profile, Answers) :-
    findall(Result - Citations, appeal_response_deadline(Profile, date(2026, 1, 1), Result, Citations), Answers).
query_answers(cure, Profile, Answers) :-
    findall(Result - Citations, cure_period_last_day(Profile, date(2026, 3, 1), Result, Citations), Answers).
query_answers(action_running, Profile, Answers) :-
    findall(Result - Citations, attorney_general_action_status(Profile, date(2026, 3, 1), date(2026, 3, 31), Result, Citations), Answers).
query_answers(action_passed, Profile, Answers) :-
    findall(Result - Citations, attorney_general_action_status(Profile, date(2026, 3, 1), date(2026, 4, 1), Result, Citations), Answers).
query_answers(penalty, Profile, Answers) :-
    findall(Result - Citations, civil_penalty_maximum(Profile, Result, Citations), Answers).
query_answers(checklist, Profile, Answers) :-
    findall(Checklist, texas_tdpsa_checklist(Profile, Checklist), Answers).
query_answers(input_check, Profile, Answers) :-
    findall(Problems, texas_tdpsa_input_problems(Profile, Problems), Answers).

subject_answer_count(Subject, QueryName, Count) :-
    texas_tdpsa_profile_for(Subject, Profile),
    query_answers(QueryName, Profile, Answers),
    length(Answers, Count).

all_cite_terms([]).
all_cite_terms([cite(CitationKey)|Citations]) :-
    atom(CitationKey),
    all_cite_terms(Citations).

applicability_shape(in_scope, [outside_fact(small_business_as_defined_by_sba, attested(false, _))], Citations) :-
    length(Citations, 11),
    all_cite_terms(Citations).
applicability_shape(out_of_scope, _, Citations) :-
    length(Citations, 11),
    all_cite_terms(Citations).
applicability_shape(indeterminate([MissingKey]), [], []) :-
    atom(MissingKey).
applicability_shape(needs_legal_review(_, [_|_]), [], []).
applicability_shape(input_problems([_|_]), [], []).

subject_has_applicability_shape(Subject) :-
    texas_tdpsa_subject(Subject),
    texas_tdpsa_profile_for(Subject, Profile),
    applicability_status(Profile, Result, Basis, Citations),
    applicability_shape(Result, Basis, Citations).

item_cited(item(_, _, cite(CitationKey))) :-
    atom(CitationKey).

subject_checklist_cited(Subject) :-
    texas_tdpsa_subject(Subject),
    texas_tdpsa_profile_for(Subject, Profile),
    texas_tdpsa_checklist(Profile, Checklist),
    maplist(item_cited, Checklist).

result_is(Expected, _ - Result) :-
    Result == Expected.

well_formed_response(Subject - Result) :-
    texas_tdpsa_subject(Subject),
    texas_tdpsa_profile_for(Subject, Profile),
    texas_tdpsa_input_problems(Profile, []),
    response_deadline(Profile, date(2026, 1, 1), Result, _).

well_formed_running(Subject - Result) :-
    texas_tdpsa_subject(Subject),
    texas_tdpsa_profile_for(Subject, Profile),
    texas_tdpsa_input_problems(Profile, []),
    attorney_general_action_status(Profile, date(2026, 3, 1), date(2026, 3, 31), Result, _).

penalty_for(ViolationCount, Result) :-
    civil_penalty_maximum([attribute(violation_after_cure_period_or_statement_breach, true), attribute(violation_count, ViolationCount)], Result, _).

cp_test_names([totality_every_subject_classifies, determinism_every_query_answers_every_subject_once, citation_completeness_every_applicability_answer_has_its_shape, justification_every_checklist_item_carries_a_citation, invariant_response_deadline_reads_no_profile_key, invariant_cure_period_running_reads_no_profile_key, invariant_penalty_grows_by_7500_per_violation, invariant_large_count_stays_an_integer]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
