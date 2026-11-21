% SPDX-License-Identifier: EUPL-1.2
:- module(m__ind_dpdp_research_state_processing_tests_test_properties, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_lists_extra, [clausal_msort/2]).
:- use_module(m__ind_dpdp_research_state_processing_dpdp_research_state_processing, [decide_dpdp_research_state_processing/2, research_exemption/3, state_processing_standards/3, state_processing_disapplied_provisions/3, dpdp_research_state_processing_checklist/2]).
:- use_module(m__ind_dpdp_research_state_processing_kernel, [dpdp_research_state_processing_input_problems/2]).
:- use_module(m__ind_dpdp_research_state_processing_citations, [citation/2]).
:- use_module(m__ind_dpdp_research_state_processing_fixtures, [dpdp_research_state_processing_subject/1, dpdp_research_state_processing_profile_for/2]).

subject_classifies(Subject) :-
    dpdp_research_state_processing_subject(Subject),
    dpdp_research_state_processing_profile_for(Subject, Profile),
    decide_dpdp_research_state_processing(Profile, _Verdict).

all_subjects(Subjects) :-
    findall(Subject, dpdp_research_state_processing_subject(Subject), Subjects).

test(totality_every_subject_classifies) :-
    all_subjects(Subjects),
    sort(Subjects, SubjectSet),
    findall(Subject, subject_classifies(Subject), ClassifiedSubjects),
    sort(ClassifiedSubjects, SubjectSet).
test(determinism_every_subject_yields_exactly_one_verdict) :-
    all_subjects(Subjects),
    one_verdict_each(Subjects).
test(determinism_every_query_and_the_input_check_yield_one_answer) :-
    all_subjects(Subjects),
    one_answer_per_query(Subjects).
test(every_final_result_carries_recorded_citations_and_every_status_none) :-
    all_subjects(Subjects),
    checklists_shape(Subjects).
test(research_exemption_does_not_read_the_intimation) :-
    query_answer(research, complete_processing, Answer),
    query_answer(research, intimation_not_given, Answer).
test(research_exemption_does_not_read_the_state_use) :-
    query_answer(research, complete_processing, Answer),
    query_answer(research, not_section_seven_b_use, Answer).
test(state_standards_do_not_read_the_research_purpose) :-
    query_answer(standards, complete_processing, Answer),
    query_answer(standards, not_research_purpose, Answer).
test(state_standards_do_not_read_section_seventeen) :-
    query_answer(standards, complete_processing, Answer),
    query_answer(standards, section_seventeen_not_in_force, Answer).
test(disapplied_provisions_do_not_read_the_standards) :-
    query_answer(disapplied, complete_processing, Answer),
    query_answer(disapplied, lawful_manner_not_observed, Answer).
test(disapplied_provisions_do_not_read_the_reference_day) :-
    query_answer(disapplied, complete_processing, Answer),
    query_answer(disapplied, reference_day_before_commencement, Answer).
test(research_not_in_force_has_the_same_citations_by_either_route) :-
    query_answer(research, section_seventeen_not_in_force, not_in_force - Citations),
    query_answer(research, reference_day_before_commencement, not_in_force - Citations).
test(standards_not_in_force_has_the_same_citations_by_either_route) :-
    query_answer(standards, section_seven_not_in_force, not_in_force - Citations),
    query_answer(standards, reference_day_before_commencement, not_in_force - Citations).
test(research_not_exempt_has_the_same_citations_by_every_route) :-
    query_answer(research, not_research_purpose, not_exempt - Citations),
    query_answer(research, decision_specific_to_data_principal, not_exempt - Citations),
    query_answer(research, lawful_manner_not_observed, not_exempt - Citations).
test(standards_does_not_follow_has_the_same_citations_for_any_standard) :-
    query_answer(standards, intimation_not_given, does_not_follow_second_schedule - Citations),
    query_answer(standards, lawful_manner_not_observed, does_not_follow_second_schedule - Citations).

one_verdict_each([]).
one_verdict_each([Subject|Subjects]) :-
    dpdp_research_state_processing_profile_for(Subject, Profile),
    findall(Verdict, decide_dpdp_research_state_processing(Profile, Verdict), [_]),
    one_verdict_each(Subjects).

one_answer_per_query([]).
one_answer_per_query([Subject|Subjects]) :-
    dpdp_research_state_processing_profile_for(Subject, Profile),
    findall(Result - Citations, research_exemption(Profile, Result, Citations), [_]),
    findall(Result - Citations, state_processing_standards(Profile, Result, Citations), [_]),
    findall(Result - Citations, state_processing_disapplied_provisions(Profile, Result, Citations), [_]),
    findall(Problems, dpdp_research_state_processing_input_problems(Profile, Problems), [_]),
    one_answer_per_query(Subjects).

all_recorded([]).
all_recorded([cite(Key)|Citations]) :-
    citation(Key, _),
    all_recorded(Citations).

written_once(Citations) :-
    clausal_msort(Citations, Ordered),
    sort(Citations, Set),
    Ordered == Set.

row_shape(item(_, Result, Citations)) :-
    atom(Result),
    Citations = [_|_],
    all_recorded(Citations),
    written_once(Citations).
row_shape(item(_, Result, [])) :-
    compound(Result).

rows_shape([]).
rows_shape([Row|Rows]) :-
    row_shape(Row),
    rows_shape(Rows).

checklists_shape([]).
checklists_shape([Subject|Subjects]) :-
    dpdp_research_state_processing_profile_for(Subject, Profile),
    dpdp_research_state_processing_checklist(Profile, Rows),
    rows_shape(Rows),
    checklists_shape(Subjects).

query_answer(research, Subject, Result - Citations) :-
    dpdp_research_state_processing_profile_for(Subject, Profile),
    research_exemption(Profile, Result, Citations).
query_answer(standards, Subject, Result - Citations) :-
    dpdp_research_state_processing_profile_for(Subject, Profile),
    state_processing_standards(Profile, Result, Citations).
query_answer(disapplied, Subject, Result - Citations) :-
    dpdp_research_state_processing_profile_for(Subject, Profile),
    state_processing_disapplied_provisions(Profile, Result, Citations).

cp_test_names([totality_every_subject_classifies, determinism_every_subject_yields_exactly_one_verdict, determinism_every_query_and_the_input_check_yield_one_answer, every_final_result_carries_recorded_citations_and_every_status_none, research_exemption_does_not_read_the_intimation, research_exemption_does_not_read_the_state_use, state_standards_do_not_read_the_research_purpose, state_standards_do_not_read_section_seventeen, disapplied_provisions_do_not_read_the_standards, disapplied_provisions_do_not_read_the_reference_day, research_not_in_force_has_the_same_citations_by_either_route, standards_not_in_force_has_the_same_citations_by_either_route, research_not_exempt_has_the_same_citations_by_every_route, standards_does_not_follow_has_the_same_citations_for_any_standard]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
