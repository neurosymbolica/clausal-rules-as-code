% SPDX-License-Identifier: EUPL-1.2
:- module(m__uk_uk_automated_decision_making_tests_test_properties, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__uk_uk_automated_decision_making_uk_automated_decision_making, [decide_uk_automated_decision_making/2, uk_significant_automated_decision/3, uk_automated_decision_restriction/3, uk_automated_decision_safeguards/3, eu_automated_decision/3, compare_uk_eu_automated_decision/5]).
:- use_module(m__uk_uk_automated_decision_making_citations, [citation/2]).
:- use_module(m__uk_uk_automated_decision_making_fixtures, [uk_automated_decision_making_subject/1, uk_automated_decision_making_profile_for/2]).

uk_article_22a_citations([cite(uk_gdpr_art_22a_1), cite(uk_gdpr_art_22a_1_a), cite(uk_gdpr_art_22a_1_b), cite(uk_gdpr_art_22a_1_b_i), cite(uk_gdpr_art_22a_1_b_ii), cite(uk_gdpr_art_22a_2)]).

uk_article_22b_citations([cite(uk_gdpr_art_22b_1), cite(uk_gdpr_art_22b_2), cite(uk_gdpr_art_22b_3), cite(uk_gdpr_art_22b_3_a), cite(uk_gdpr_art_22b_3_a_i), cite(uk_gdpr_art_22b_3_a_ii), cite(uk_gdpr_art_22b_3_b), cite(uk_gdpr_art_22b_4)]).

subject_profile(Subject, Profile) :-
    uk_automated_decision_making_subject(Subject),
    uk_automated_decision_making_profile_for(Subject, Profile).

subject_classifies(Subject) :-
    subject_profile(Subject, Profile),
    decide_uk_automated_decision_making(Profile, _Verdict).

test(totality_every_subject_classifies) :-
    findall(Subject, uk_automated_decision_making_subject(Subject), Subjects),
    sort(Subjects, SubjectSet),
    findall(Subject, subject_classifies(Subject), ClassifiedSubjects),
    sort(ClassifiedSubjects, SubjectSet).
test(determinism_every_subject_every_query_has_exactly_one_answer) :-
    findall(Subject - Query, (uk_automated_decision_making_subject(Subject), query_name(Query)), Pairs),
    findall(Subject - Query, exactly_one_answer(Subject, Query), SinglePairs),
    SinglePairs == Pairs.
test(restriction_citations_are_fixed_per_result) :-
    findall(Subject, uk_automated_decision_making_subject(Subject), Subjects),
    findall(Subject, consistent_subject(Subject), ConsistentSubjects),
    ConsistentSubjects == Subjects.
test(uk_and_eu_agree_on_restrictions_not_engaged) :-
    findall(Subject, uk_automated_decision_making_subject(Subject), Subjects),
    sort(Subjects, SubjectSet),
    findall(Subject, agreeing_subject(Subject), AgreeingSubjects),
    sort(AgreeingSubjects, SubjectSet).
test(final_difference_matches_the_two_results) :-
    findall(Subject, final_subject(Subject), FinalSubjects),
    findall(Subject, matching_subject(Subject), MatchingSubjects),
    FinalSubjects = [_|_],
    MatchingSubjects == FinalSubjects.
test(every_returned_citation_is_recorded) :-
    findall(Key, returned_citation_key(Key), AllKeys),
    sort(AllKeys, Keys),
    Keys = [_|_],
    findall(Key, recorded_key(Keys, Key), RecordedKeys),
    sort(RecordedKeys, RecordedSet),
    RecordedSet == Keys.

query_name(significance).
query_name(restriction).
query_name(safeguards).
query_name(european).
query_name(comparison).
query_name(facade).

answers(significance, Profile, Answers) :-
    findall(Result - Citations, uk_significant_automated_decision(Profile, Result, Citations), Answers).
answers(restriction, Profile, Answers) :-
    findall(Result - Citations, uk_automated_decision_restriction(Profile, Result, Citations), Answers).
answers(safeguards, Profile, Answers) :-
    findall(Result - Citations, uk_automated_decision_safeguards(Profile, Result, Citations), Answers).
answers(european, Profile, Answers) :-
    findall(Result - Citations, eu_automated_decision(Profile, Result, Citations), Answers).
answers(comparison, Profile, Answers) :-
    findall(UkResult - EuResult - Difference - ChangedBy, compare_uk_eu_automated_decision(Profile, UkResult, EuResult, Difference, ChangedBy), Answers).
answers(facade, Profile, Answers) :-
    findall(Verdict, decide_uk_automated_decision_making(Profile, Verdict), Answers).

exactly_one_answer(Subject, Query) :-
    subject_profile(Subject, Profile),
    query_name(Query),
    answers(Query, Profile, [_]).

restriction_citations_consistent(restrictions_not_engaged, Citations) :-
    uk_article_22a_citations(Expected),
    Citations == Expected.
restriction_citations_consistent(decision_permitted, Citations) :-
    uk_article_22b_citations(Expected),
    Citations == Expected.
restriction_citations_consistent(decision_prohibited, Citations) :-
    uk_article_22b_citations(Expected),
    Citations == Expected.
restriction_citations_consistent(indeterminate(_), []).
restriction_citations_consistent(needs_legal_review(_, _), []).
restriction_citations_consistent(input_problems(_), []).

consistent_subject(Subject) :-
    subject_profile(Subject, Profile),
    uk_automated_decision_restriction(Profile, Result, Citations),
    restriction_citations_consistent(Result, Citations).

engagement(restrictions_not_engaged, not_engaged).
engagement(decision_permitted, engaged).
engagement(decision_prohibited, engaged).
engagement(indeterminate(_), open).
engagement(needs_legal_review(_, _), open).
engagement(input_problems(_), open).

engagement_agrees(not_engaged, not_engaged).
engagement_agrees(engaged, engaged).
engagement_agrees(open, _).
engagement_agrees(engaged, open).
engagement_agrees(not_engaged, open).

agreeing_subject(Subject) :-
    subject_profile(Subject, Profile),
    compare_uk_eu_automated_decision(Profile, UkResult, EuResult, _, _),
    engagement(UkResult, UkEngagement),
    engagement(EuResult, EuEngagement),
    engagement_agrees(UkEngagement, EuEngagement).

final_result(restrictions_not_engaged).
final_result(decision_permitted).
final_result(decision_prohibited).

difference_matches(UkResult, EuResult, same) :-
    UkResult == EuResult.
difference_matches(UkResult, EuResult, differs) :-
    UkResult \== EuResult.

final_subject(Subject) :-
    subject_profile(Subject, Profile),
    compare_uk_eu_automated_decision(Profile, UkResult, EuResult, _, _),
    final_result(UkResult),
    final_result(EuResult).

matching_subject(Subject) :-
    subject_profile(Subject, Profile),
    compare_uk_eu_automated_decision(Profile, UkResult, EuResult, Difference, _),
    final_result(UkResult),
    final_result(EuResult),
    difference_matches(UkResult, EuResult, Difference).

returned_citation_key(Key) :-
    subject_profile(_, Profile),
    query_name(Query),
    answers(Query, Profile, Answers),
    member(Answer, Answers),
    answer_citations(Query, Answer, Citations),
    member(cite(Key), Citations).

answer_citations(significance, _ - Citations, Citations).
answer_citations(restriction, _ - Citations, Citations).
answer_citations(safeguards, _ - Citations, Citations).
answer_citations(european, _ - Citations, Citations).
answer_citations(comparison, _ - _ - _ - Citations, Citations).
answer_citations(facade, uk_automated_decision_making_verdict(_, Citations), Citations).

recorded_key(Keys, Key) :-
    member(Key, Keys),
    citation(Key, _).

cp_test_names([totality_every_subject_classifies, determinism_every_subject_every_query_has_exactly_one_answer, restriction_citations_are_fixed_per_result, uk_and_eu_agree_on_restrictions_not_engaged, final_difference_matches_the_two_results, every_returned_citation_is_recorded]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
