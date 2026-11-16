% SPDX-License-Identifier: EUPL-1.2
:- module(m__uk_uk_recognised_legitimate_interests_tests_test_properties, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__uk_uk_recognised_legitimate_interests_uk_recognised_legitimate_interests, [decide_uk_recognised_legitimate_interests/2, recognised_legitimate_interest/3, uk_legitimate_interests/3, uk_legitimate_interest_basis/3, eu_legitimate_interests/3, compare_uk_eu_legitimate_interest_basis/5, uk_right_to_object/3]).
:- use_module(m__uk_uk_recognised_legitimate_interests_kernel, [uk_recognised_legitimate_interests_input_problems/2]).
:- use_module(m__uk_uk_recognised_legitimate_interests_citations, [citation/2]).
:- use_module(m__uk_uk_recognised_legitimate_interests_fixtures, [uk_recognised_legitimate_interests_subject/1, uk_recognised_legitimate_interests_profile_for/2]).

all_subjects(SubjectSet) :-
    findall(Subject, uk_recognised_legitimate_interests_subject(Subject), Subjects),
    sort(Subjects, SubjectSet).

subject_classifies(Subject) :-
    uk_recognised_legitimate_interests_subject(Subject),
    uk_recognised_legitimate_interests_profile_for(Subject, Profile),
    decide_uk_recognised_legitimate_interests(Profile, _Verdict).

exactly_one_answer_each(Subject) :-
    findall(Profile, uk_recognised_legitimate_interests_profile_for(Subject, Profile), Profiles),
    Profiles = [Profile],
    findall(Problems, uk_recognised_legitimate_interests_input_problems(Profile, Problems), ProblemAnswers),
    length(ProblemAnswers, 1),
    findall(Result - Citations, recognised_legitimate_interest(Profile, Result, Citations), RecognisedAnswers),
    length(RecognisedAnswers, 1),
    findall(Result - Citations, uk_legitimate_interests(Profile, Result, Citations), UkAnswers),
    length(UkAnswers, 1),
    findall(Result - Citations, uk_legitimate_interest_basis(Profile, Result, Citations), BasisAnswers),
    length(BasisAnswers, 1),
    findall(Result - Citations, eu_legitimate_interests(Profile, Result, Citations), EuAnswers),
    length(EuAnswers, 1),
    findall(answer(Uk, Eu, Difference, ChangedBy), compare_uk_eu_legitimate_interest_basis(Profile, Uk, Eu, Difference, ChangedBy), CompareAnswers),
    length(CompareAnswers, 1),
    findall(Result - Citations, uk_right_to_object(Profile, Result, Citations), ObjectionAnswers),
    length(ObjectionAnswers, 1),
    findall(Verdict, decide_uk_recognised_legitimate_interests(Profile, Verdict), Verdicts),
    length(Verdicts, 1).

citation_shape(Result, [_|_]) :-
    atom(Result).
citation_shape(Result, []) :-
    compound(Result).

recorded_citation(cite(Key)) :-
    atom(Key),
    citation(Key, _).

answer_well_shaped(Result, Citations) :-
    citation_shape(Result, Citations),
    maplist(recorded_citation, Citations).

subject_shapes_hold(Subject) :-
    uk_recognised_legitimate_interests_profile_for(Subject, Profile),
    recognised_legitimate_interest(Profile, RecognisedResult, RecognisedCitations),
    answer_well_shaped(RecognisedResult, RecognisedCitations),
    uk_legitimate_interests(Profile, UkResult, UkCitations),
    answer_well_shaped(UkResult, UkCitations),
    uk_legitimate_interest_basis(Profile, BasisResult, BasisCitations),
    answer_well_shaped(BasisResult, BasisCitations),
    eu_legitimate_interests(Profile, EuResult, EuCitations),
    answer_well_shaped(EuResult, EuCitations),
    uk_right_to_object(Profile, ObjectionResult, ObjectionCitations),
    answer_well_shaped(ObjectionResult, ObjectionCitations).

difference_shape(differs, legitimate_interest_basis_available, legitimate_interest_basis_not_available, ChangedBy) :-
    member(cite(uk_gdpr_art_6_1_ea), ChangedBy).
difference_shape(same, UkResult, EuResult, []) :-
    atom(UkResult),
    UkResult == EuResult.
difference_shape(not_comparable, _, _, []).

subject_difference_holds(Subject) :-
    uk_recognised_legitimate_interests_profile_for(Subject, Profile),
    compare_uk_eu_legitimate_interest_basis(Profile, UkResult, EuResult, Difference, ChangedBy),
    difference_shape(Difference, UkResult, EuResult, ChangedBy).

basis_consistent(legitimate_interest_basis_available, RecognisedResult, InterestsResult) :-
    available_side(RecognisedResult, InterestsResult).
basis_consistent(legitimate_interest_basis_not_available, recognised_legitimate_interest_does_not_apply, legitimate_interests_does_not_apply).
basis_consistent(BasisResult, _, _) :-
    compound(BasisResult).

available_side(recognised_legitimate_interest_applies, _).
available_side(RecognisedResult, legitimate_interests_applies) :-
    dif(RecognisedResult, recognised_legitimate_interest_applies).

subject_basis_consistent(Subject) :-
    uk_recognised_legitimate_interests_profile_for(Subject, Profile),
    uk_legitimate_interest_basis(Profile, BasisResult, _BasisCitations),
    recognised_legitimate_interest(Profile, RecognisedResult, _RecognisedCitations),
    uk_legitimate_interests(Profile, InterestsResult, _InterestsCitations),
    basis_consistent(BasisResult, RecognisedResult, InterestsResult).

same_polarity(legitimate_interests_applies, legitimate_interests_applies).
same_polarity(legitimate_interests_does_not_apply, legitimate_interests_does_not_apply).
same_polarity(UkResult, EuResult) :-
    compound(UkResult),
    compound(EuResult).

subject_polarity_agrees(Subject) :-
    uk_recognised_legitimate_interests_profile_for(Subject, Profile),
    uk_legitimate_interests(Profile, UkResult, _UkCitations),
    eu_legitimate_interests(Profile, EuResult, _EuCitations),
    same_polarity(UkResult, EuResult).

test(totality_every_subject_classifies) :-
    all_subjects(SubjectSet),
    findall(Subject, subject_classifies(Subject), ClassifiedSubjects),
    sort(ClassifiedSubjects, SubjectSet).
test(determinism_every_query_yields_exactly_one_solution) :-
    all_subjects(SubjectSet),
    maplist(exactly_one_answer_each, SubjectSet).
test(citations_follow_the_answer_shape_and_are_recorded) :-
    all_subjects(SubjectSet),
    maplist(subject_shapes_hold, SubjectSet).
test(comparison_differs_only_through_ea) :-
    all_subjects(SubjectSet),
    maplist(subject_difference_holds, SubjectSet).
test(basis_available_exactly_when_a_side_applies) :-
    all_subjects(SubjectSet),
    maplist(subject_basis_consistent, SubjectSet).
test(uk_and_eu_legitimate_interests_agree) :-
    all_subjects(SubjectSet),
    maplist(subject_polarity_agrees, SubjectSet).
test(public_authority_bars_every_basis) :-
    uk_recognised_legitimate_interests_profile_for(public_authority_bar, Profile),
    recognised_legitimate_interest(Profile, recognised_legitimate_interest_does_not_apply, _RecognisedCitations),
    uk_legitimate_interests(Profile, legitimate_interests_does_not_apply, _UkCitations),
    eu_legitimate_interests(Profile, legitimate_interests_does_not_apply, _EuCitations).

test(citation_shape_rejects_final_without_citations, fail) :-
    citation_shape(recognised_legitimate_interest_applies, []).
test(citation_shape_rejects_open_with_citations, fail) :-
    citation_shape(indeterminate([basis_relied_on]), [cite(uk_gdpr_art_21_1)]).
test(recorded_citation_rejects_an_invented_key, fail) :-
    recorded_citation(cite(uk_gdpr_article_6)).
test(difference_shape_rejects_eu_only_basis, fail) :-
    difference_shape(differs, legitimate_interest_basis_not_available, legitimate_interest_basis_available, [cite(uk_gdpr_art_6_1_ea)]).
test(basis_consistent_rejects_available_with_no_side, fail) :-
    basis_consistent(legitimate_interest_basis_available, recognised_legitimate_interest_does_not_apply, legitimate_interests_does_not_apply).
test(same_polarity_rejects_disagreement, fail) :-
    same_polarity(legitimate_interests_applies, legitimate_interests_does_not_apply).

cp_test_names([totality_every_subject_classifies, determinism_every_query_yields_exactly_one_solution, citations_follow_the_answer_shape_and_are_recorded, comparison_differs_only_through_ea, basis_available_exactly_when_a_side_applies, uk_and_eu_legitimate_interests_agree, public_authority_bars_every_basis]).
cp_test_fail_names([citation_shape_rejects_final_without_citations, citation_shape_rejects_open_with_citations, recorded_citation_rejects_an_invented_key, difference_shape_rejects_eu_only_basis, basis_consistent_rejects_available_with_no_side, same_polarity_rejects_disagreement]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
