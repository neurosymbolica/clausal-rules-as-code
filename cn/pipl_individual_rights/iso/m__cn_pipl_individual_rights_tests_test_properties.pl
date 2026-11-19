% SPDX-License-Identifier: EUPL-1.2
:- module(m__cn_pipl_individual_rights_tests_test_properties, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(library(clpz)).
:- use_module(m__cn_pipl_individual_rights_pipl_individual_rights, [restriction_or_refusal_right/3, access_and_copy_duty/3, portability_duty/3, correction_duty/3, deletion_duty/3, explanation_duty/3, deceased_person_rights/3, request_mechanism/3, refusal_status/3, decide_pipl_individual_rights/2, pipl_individual_rights_status_values/1]).
:- use_module(m__cn_pipl_individual_rights_fixtures, [pipl_individual_rights_subject/1, pipl_individual_rights_profile_for/2]).

query_name(restriction_or_refusal_right).
query_name(access_and_copy_duty).
query_name(portability_duty).
query_name(correction_duty).
query_name(deletion_duty).
query_name(explanation_duty).
query_name(deceased_person_rights).
query_name(request_mechanism).
query_name(refusal_status).

allowed_citation(restriction_or_refusal_right, cn_pipl_art_44_p1).
allowed_citation(access_and_copy_duty, cn_pipl_art_45_p1).
allowed_citation(access_and_copy_duty, cn_pipl_art_45_p2).
allowed_citation(portability_duty, cn_pipl_art_45_p3).
allowed_citation(correction_duty, cn_pipl_art_46_p1).
allowed_citation(correction_duty, cn_pipl_art_46_p2).
allowed_citation(deletion_duty, cn_pipl_art_47_p1).
allowed_citation(deletion_duty, cn_pipl_art_47_p1_i1).
allowed_citation(deletion_duty, cn_pipl_art_47_p1_i2).
allowed_citation(deletion_duty, cn_pipl_art_47_p1_i3).
allowed_citation(deletion_duty, cn_pipl_art_47_p1_i4).
allowed_citation(deletion_duty, cn_pipl_art_47_p1_i5).
allowed_citation(deletion_duty, cn_pipl_art_47_p2).
allowed_citation(explanation_duty, cn_pipl_art_48_p1).
allowed_citation(deceased_person_rights, cn_pipl_art_49_p1).
allowed_citation(request_mechanism, cn_pipl_art_50_p1).
allowed_citation(refusal_status, cn_pipl_art_50_p1).
allowed_citation(refusal_status, cn_pipl_art_50_p2).

final_answer(right_available).
final_answer(excluded_by_other_law).
final_answer(not_owed).
final_answer(provide_in_time).
final_answer(provide_transfer_route).
final_answer(correct_or_supplement_in_time).
final_answer(no_correction_owed).
final_answer(delete_personal_information).
final_answer(stop_processing_except_storage_and_security).
final_answer(explain_processing_rules).
final_answer(near_relative_may_exercise).
final_answer(near_relative_may_not_exercise).
final_answer(requirement_met).
final_answer(requirement_not_met).
final_answer(not_refused).
final_answer(refused_with_reasons).
final_answer(refused_without_reasons).

all_subjects(SubjectSet) :-
    findall(Subject, pipl_individual_rights_subject(Subject), Subjects),
    sort(Subjects, SubjectSet).

all_queries(QueryNames) :-
    findall(Query, query_name(Query), QueryNames).

subject_classifies(Subject) :-
    pipl_individual_rights_subject(Subject),
    pipl_individual_rights_profile_for(Subject, Profile),
    decide_pipl_individual_rights(Profile, _Verdict).

test(totality_every_subject_classifies) :-
    all_subjects(SubjectSet),
    findall(Subject, subject_classifies(Subject), ClassifiedSubjects),
    sort(ClassifiedSubjects, SubjectSet).
test(determinism_every_subject_has_exactly_one_verdict_in_the_table) :-
    all_subjects(SubjectSet),
    maplist(one_verdict, SubjectSet).
test(determinism_every_query_on_every_subject) :-
    all_subjects(SubjectSet),
    all_queries(QueryNames),
    maplist(one_answer_in_every_query(QueryNames), SubjectSet).
test(citations_follow_the_general_rule_on_every_answer) :-
    findall(Query - Result - Citations, (pipl_individual_rights_subject(Subject), query_name(Query), pipl_individual_rights_profile_for(Subject, Profile), call(Query, Profile, Result, Citations)), Answers),
    length(Answers, AnswerCount),
    AnswerCount #> 0,
    maplist(consistent_answer, Answers).
test(an_empty_profile_names_the_in_force_key_in_all_nine_queries) :-
    all_queries(QueryNames),
    maplist(names_in_force_key, QueryNames).
test(text_not_in_force_is_not_applicable_in_all_nine_queries) :-
    pipl_individual_rights_profile_for(text_not_in_force, Profile),
    all_queries(QueryNames),
    maplist(not_applicable_in(Profile), QueryNames).
test(input_problems_come_first_in_all_nine_queries) :-
    pipl_individual_rights_profile_for(input_duplicate_key, Profile),
    all_queries(QueryNames),
    maplist(rejected_in(Profile, [duplicate_key(consent_withdrawn)]), QueryNames).

one_verdict(Subject) :-
    pipl_individual_rights_profile_for(Subject, Profile),
    findall(Verdict, decide_pipl_individual_rights(Profile, Verdict), [pipl_individual_rights_verdict(Status, _Items)]),
    pipl_individual_rights_status_values(StatusValues),
    member(Status, StatusValues).

one_answer(Subject, Query) :-
    pipl_individual_rights_profile_for(Subject, Profile),
    findall(Result - Citations, call(Query, Profile, Result, Citations), Answers),
    length(Answers, 1).

one_answer_in_every_query(QueryNames, Subject) :-
    maplist(one_answer(Subject), QueryNames).

citations_consistent(_, indeterminate([_]), []).
citations_consistent(_, needs_legal_review(open_textured(_, cite(_)), [inputs_relied_on(_)]), []).
citations_consistent(_, input_problems([_|_]), []).
citations_consistent(_, pinned_text_not_applicable, []).
citations_consistent(Query, Final, [Citation|Citations]) :-
    final_answer(Final),
    sort([Citation|Citations], CitationSet),
    length([Citation|Citations], CitationCount),
    length(CitationSet, CitationCount),
    maplist(citation_of_query(Query), [Citation|Citations]).

citation_of_query(Query, cite(CitationKey)) :-
    allowed_citation(Query, CitationKey).

consistent_answer(Query - Result - Citations) :-
    citations_consistent(Query, Result, Citations).

names_in_force_key(Query) :-
    findall(Result - Citations, call(Query, [], Result, Citations), Answers),
    Answers == [indeterminate([pinned_text_in_force_on_reference_day]) - []].

not_applicable_in(Profile, Query) :-
    findall(Result - Citations, call(Query, Profile, Result, Citations), Answers),
    Answers == [pinned_text_not_applicable - []].

rejected_in(Profile, Problems, Query) :-
    findall(Result - Citations, call(Query, Profile, Result, Citations), Answers),
    Answers == [input_problems(Problems) - []].

cp_test_names([totality_every_subject_classifies, determinism_every_subject_has_exactly_one_verdict_in_the_table, determinism_every_query_on_every_subject, citations_follow_the_general_rule_on_every_answer, an_empty_profile_names_the_in_force_key_in_all_nine_queries, text_not_in_force_is_not_applicable_in_all_nine_queries, input_problems_come_first_in_all_nine_queries]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
