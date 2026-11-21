% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_ict_risk_response_and_recovery_tests_test_properties, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_lists_extra, [clausal_is_list/1]).
:- use_module(m__eu_dora_ict_risk_response_and_recovery_dora_ict_risk_response_and_recovery, [ict_risk_response_and_recovery_duties_required/3, ict_risk_response_and_recovery_duties_complete/3, ict_risk_response_and_recovery_duties_outstanding/3, decide_dora_ict_risk_response_and_recovery/2]).
:- use_module(m__eu_dora_ict_risk_response_and_recovery_kernel, [dora_ict_risk_response_and_recovery_input_problems/2]).
:- use_module(m__eu_dora_ict_risk_response_and_recovery_citations, [citation/2]).
:- use_module(m__eu_dora_ict_risk_response_and_recovery_fixtures, [dora_ict_risk_response_and_recovery_subject/1, dora_ict_risk_response_and_recovery_profile_for/2]).

subject_classifies(Subject) :-
    dora_ict_risk_response_and_recovery_subject(Subject),
    dora_ict_risk_response_and_recovery_profile_for(Subject, Profile),
    decide_dora_ict_risk_response_and_recovery(Profile, _Verdict).

query_name(required).
query_name(complete).
query_name(outstanding).
query_name(input_check).

subject_query_answer(Profile, required, Result, Citations) :-
    ict_risk_response_and_recovery_duties_required(Profile, Result, Citations).
subject_query_answer(Profile, complete, Result, Citations) :-
    ict_risk_response_and_recovery_duties_complete(Profile, Result, Citations).
subject_query_answer(Profile, outstanding, Result, Citations) :-
    ict_risk_response_and_recovery_duties_outstanding(Profile, Result, Citations).
subject_query_answer(Profile, input_check, Problems, []) :-
    dora_ict_risk_response_and_recovery_input_problems(Profile, Problems).

answer_count(Subject, Query, Count) :-
    dora_ict_risk_response_and_recovery_profile_for(Subject, Profile),
    findall(Result - Citations, subject_query_answer(Profile, Query, Result, Citations), Answers),
    length(Answers, Count).

well_shaped(complete, Citations) :-
    length(Citations, 17).
well_shaped(incomplete, Citations) :-
    length(Citations, 17).
well_shaped(none_outstanding, Citations) :-
    length(Citations, 17).
well_shaped(simplified_framework_entity, [cite(eu_reg_2022_2554_art_16_1)]).
well_shaped(required([_|_]), [_|_]).
well_shaped(outstanding([_|_]), [_|_]).
well_shaped(indeterminate([Key]), []) :-
    atom(Key).
well_shaped(needs_legal_review(open_textured(Key, cite(CitationKey)), [inputs_relied_on(Pairs)]), []) :-
    atom(Key),
    atom(CitationKey),
    clausal_is_list(Pairs).
well_shaped(input_problems([_|_]), []).

subject_well_shaped(Subject) :-
    dora_ict_risk_response_and_recovery_subject(Subject),
    dora_ict_risk_response_and_recovery_profile_for(Subject, Profile),
    ict_risk_response_and_recovery_duties_required(Profile, RequiredResult, RequiredCitations),
    well_shaped(RequiredResult, RequiredCitations),
    ict_risk_response_and_recovery_duties_complete(Profile, CompleteResult, CompleteCitations),
    well_shaped(CompleteResult, CompleteCitations),
    ict_risk_response_and_recovery_duties_outstanding(Profile, OutstandingResult, OutstandingCitations),
    well_shaped(OutstandingResult, OutstandingCitations).

citations_once(Citations) :-
    sort(Citations, CitationSet),
    length(CitationSet, Length),
    length(Citations, Length).

subject_cites_once(Subject) :-
    dora_ict_risk_response_and_recovery_subject(Subject),
    dora_ict_risk_response_and_recovery_profile_for(Subject, Profile),
    ict_risk_response_and_recovery_duties_required(Profile, _, RequiredCitations),
    citations_once(RequiredCitations),
    ict_risk_response_and_recovery_duties_complete(Profile, _, CompleteCitations),
    citations_once(CompleteCitations),
    ict_risk_response_and_recovery_duties_outstanding(Profile, _, OutstandingCitations),
    citations_once(OutstandingCitations).

cited_key(Key) :-
    dora_ict_risk_response_and_recovery_subject(Subject),
    dora_ict_risk_response_and_recovery_profile_for(Subject, Profile),
    query_name(Query),
    subject_query_answer(Profile, Query, _, Citations),
    member(cite(Key), Citations).

recorded_citation(Key) :-
    citation(Key, _).

complete_subject(Subject) :-
    dora_ict_risk_response_and_recovery_subject(Subject),
    dora_ict_risk_response_and_recovery_profile_for(Subject, Profile),
    ict_risk_response_and_recovery_duties_complete(Profile, complete, _).

none_outstanding_subject(Subject) :-
    dora_ict_risk_response_and_recovery_subject(Subject),
    dora_ict_risk_response_and_recovery_profile_for(Subject, Profile),
    ict_risk_response_and_recovery_duties_outstanding(Profile, none_outstanding, _).

test(totality_every_subject_classifies) :-
    findall(Subject, dora_ict_risk_response_and_recovery_subject(Subject), Subjects),
    sort(Subjects, SubjectSet),
    findall(Subject, subject_classifies(Subject), ClassifiedSubjects),
    sort(ClassifiedSubjects, SubjectSet).
test(determinism_every_query_answers_exactly_once) :-
    findall(Subject - Query - Count, (dora_ict_risk_response_and_recovery_subject(Subject), query_name(Query), answer_count(Subject, Query, Count)), Counts),
    findall(Subject - Query - 1, (dora_ict_risk_response_and_recovery_subject(Subject), query_name(Query)), Expected),
    Counts == Expected.
test(every_answer_has_a_contract_shape) :-
    findall(Subject, dora_ict_risk_response_and_recovery_subject(Subject), Subjects),
    findall(Subject, subject_well_shaped(Subject), ShapedSubjects),
    ShapedSubjects == Subjects.
test(every_citation_is_written_once) :-
    findall(Subject, dora_ict_risk_response_and_recovery_subject(Subject), Subjects),
    findall(Subject, subject_cites_once(Subject), CitingSubjects),
    CitingSubjects == Subjects.
test(every_cited_key_is_recorded) :-
    findall(Key, cited_key(Key), Keys),
    sort(Keys, KeySet),
    KeySet = [_|_],
    maplist(recorded_citation, KeySet).
test(complete_exactly_where_none_outstanding) :-
    findall(Subject, complete_subject(Subject), CompleteSubjects),
    findall(Subject, none_outstanding_subject(Subject), NoneOutstandingSubjects),
    CompleteSubjects = [_|_],
    CompleteSubjects == NoneOutstandingSubjects.

cp_test_names([totality_every_subject_classifies, determinism_every_query_answers_exactly_once, every_answer_has_a_contract_shape, every_citation_is_written_once, every_cited_key_is_recorded, complete_exactly_where_none_outstanding]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
