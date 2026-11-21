% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_complaints_and_judicial_remedies_tests_test_properties, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_lists_extra, [subtract/3]).
:- use_module(m__eu_data_protection_gdpr_complaints_and_judicial_remedies_gdpr_complaints_and_judicial_remedies, [decide_gdpr_complaints_and_judicial_remedies/2, gdpr_complaints_and_judicial_remedies_status_values/1, complaint_right/3, authority_decision_remedy_right/3, authority_inaction_remedy_right/4, controller_processor_remedy_right/3, controller_processor_forum/3]).
:- use_module(m__eu_data_protection_gdpr_complaints_and_judicial_remedies_kernel, [gdpr_complaints_and_judicial_remedies_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_complaints_and_judicial_remedies_queries, [gdpr_complaints_and_judicial_remedies_what_if/4]).
:- use_module(m__eu_data_protection_gdpr_complaints_and_judicial_remedies_fixtures, [gdpr_complaints_and_judicial_remedies_subject/1, gdpr_complaints_and_judicial_remedies_profile_for/2]).

query_name(complaint_right).
query_name(authority_decision_remedy_right).
query_name(authority_inaction_remedy_right).
query_name(controller_processor_remedy_right).
query_name(controller_processor_forum).

query_answer(complaint_right, Profile, Result, Citations) :-
    complaint_right(Profile, Result, Citations).
query_answer(authority_decision_remedy_right, Profile, Result, Citations) :-
    authority_decision_remedy_right(Profile, Result, Citations).
query_answer(authority_inaction_remedy_right, Profile, Result, Citations) :-
    authority_inaction_remedy_right(Profile, Result, _Basis, Citations).
query_answer(controller_processor_remedy_right, Profile, Result, Citations) :-
    controller_processor_remedy_right(Profile, Result, Citations).
query_answer(controller_processor_forum, Profile, Result, Citations) :-
    controller_processor_forum(Profile, Result, Citations).

subject_answer(Subject, Query, Result, Citations) :-
    gdpr_complaints_and_judicial_remedies_subject(Subject),
    gdpr_complaints_and_judicial_remedies_profile_for(Subject, Profile),
    query_name(Query),
    query_answer(Query, Profile, Result, Citations).

subject_query_answer_count(Subject, Query, Count) :-
    gdpr_complaints_and_judicial_remedies_subject(Subject),
    gdpr_complaints_and_judicial_remedies_profile_for(Subject, Profile),
    query_name(Query),
    findall(Result, query_answer(Query, Profile, Result, _), Results),
    length(Results, Count).

subject_problem_list_count(Subject, Count) :-
    gdpr_complaints_and_judicial_remedies_subject(Subject),
    gdpr_complaints_and_judicial_remedies_profile_for(Subject, Profile),
    findall(Problems, gdpr_complaints_and_judicial_remedies_input_problems(Profile, Problems), ProblemLists),
    length(ProblemLists, Count).

citation_shape(Result, [cite(_)], well_formed) :-
    atom(Result).
citation_shape(Result, [], ill_formed) :-
    atom(Result).
citation_shape(Result, [_, _|_], ill_formed) :-
    atom(Result).
citation_shape(Result, [], well_formed) :-
    compound(Result).
citation_shape(Result, [_|_], ill_formed) :-
    compound(Result).

input_problems_result(input_problems([_|_])).

well_formed_subject_profile(Profile) :-
    gdpr_complaints_and_judicial_remedies_subject(Subject),
    gdpr_complaints_and_judicial_remedies_profile_for(Subject, Profile),
    gdpr_complaints_and_judicial_remedies_input_problems(Profile, []).

denied_without_data_subject(Profile, Query, Result) :-
    well_formed_subject_profile(Profile),
    gdpr_complaints_and_judicial_remedies_what_if(Profile, is_data_subject, false, answer(Query, Result)),
    member(Query, [complaint_right, authority_inaction_remedy_right, controller_processor_remedy_right]).

test(totality_and_determinism_one_result_per_subject_and_query) :-
    findall(Count, subject_query_answer_count(_, _, Count), Counts),
    sort(Counts, DistinctCounts),
    DistinctCounts == [1].
test(totality_every_subject_classifies_under_the_facade) :-
    findall(Subject, gdpr_complaints_and_judicial_remedies_subject(Subject), Subjects),
    sort(Subjects, SubjectSet),
    findall(Subject, (gdpr_complaints_and_judicial_remedies_subject(Subject), gdpr_complaints_and_judicial_remedies_profile_for(Subject, Profile), decide_gdpr_complaints_and_judicial_remedies(Profile, _)), ClassifiedSubjects),
    sort(ClassifiedSubjects, SubjectSet).
test(the_input_check_gives_exactly_one_problem_list) :-
    findall(Count, subject_problem_list_count(_, Count), Counts),
    sort(Counts, DistinctCounts),
    DistinctCounts == [1].
test(citations_are_complete_and_only_on_final_results) :-
    findall(Shape, (subject_answer(_, _, Result, Citations), citation_shape(Result, Citations, Shape)), Shapes),
    sort(Shapes, DistinctShapes),
    DistinctShapes == [well_formed].
test(every_final_result_is_in_the_status_table) :-
    gdpr_complaints_and_judicial_remedies_status_values(StatusValues),
    findall(Result, (subject_answer(_, _, Result, _), atom(Result)), FinalResults),
    sort(FinalResults, DistinctFinalResults),
    subtract(DistinctFinalResults, StatusValues, OutsideTheTable),
    OutsideTheTable == [].
test(input_problems_answer_every_query_first) :-
    findall(Result, (member(Subject, [malformed_duplicate_and_unknown, malformed_unbound_attestation]), gdpr_complaints_and_judicial_remedies_profile_for(Subject, Profile), query_name(Query), query_answer(Query, Profile, Result, _)), Results),
    length(Results, 10),
    maplist(input_problems_result, Results).
test(not_a_data_subject_denies_the_three_data_subject_rights) :-
    findall(Query - Result, denied_without_data_subject(_, Query, Result), Denials),
    sort(Denials, DistinctDenials),
    DistinctDenials == [authority_inaction_remedy_right - no_inaction_remedy_right, complaint_right - no_complaint_right, controller_processor_remedy_right - no_judicial_remedy_right].

cp_test_names([totality_and_determinism_one_result_per_subject_and_query, totality_every_subject_classifies_under_the_facade, the_input_check_gives_exactly_one_problem_list, citations_are_complete_and_only_on_final_results, every_final_result_is_in_the_status_table, input_problems_answer_every_query_first, not_a_data_subject_denies_the_three_data_subject_rights]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
