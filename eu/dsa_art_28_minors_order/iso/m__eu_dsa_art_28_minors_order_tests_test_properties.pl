% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dsa_art_28_minors_order_tests_test_properties, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_dsa_art_28_minors_order_dsa_art_28_minors_order, [decide_dsa_art_28_minors_order/2, section_3_application_status/4, art_28_1_obligation_status/4, art_28_1_compliance_status/4, art_28_2_advertising_status/4, dsa_art_28_minors_order_checklist/2]).
:- use_module(m__eu_dsa_art_28_minors_order_kernel, [dsa_art_28_minors_order_input_problems/2]).
:- use_module(m__eu_dsa_art_28_minors_order_fixtures, [dsa_art_28_minors_order_subject/1, dsa_art_28_minors_order_profile_for/2]).

question(section_3_application).
question(art_28_1_obligation).
question(art_28_1_compliance).
question(art_28_2_advertising).

question_answer(section_3_application, Profile, Result, Basis, Citations) :-
    section_3_application_status(Profile, Result, Basis, Citations).
question_answer(art_28_1_obligation, Profile, Result, Basis, Citations) :-
    art_28_1_obligation_status(Profile, Result, Basis, Citations).
question_answer(art_28_1_compliance, Profile, Result, Basis, Citations) :-
    art_28_1_compliance_status(Profile, Result, Basis, Citations).
question_answer(art_28_2_advertising, Profile, Result, Basis, Citations) :-
    art_28_2_advertising_status(Profile, Result, Basis, Citations).

subject_question(Subject, Question) :-
    dsa_art_28_minors_order_subject(Subject),
    question(Question).

subject_question_answer(Subject, Question, Result, Basis, Citations) :-
    subject_question(Subject, Question),
    dsa_art_28_minors_order_profile_for(Subject, Profile),
    question_answer(Question, Profile, Result, Basis, Citations).

answer_count(Subject, Question, AnswerCount) :-
    dsa_art_28_minors_order_profile_for(Subject, Profile),
    findall(Result, question_answer(Question, Profile, Result, _Basis, _Citations), Results),
    length(Results, AnswerCount).

verdict_count(Subject, VerdictCount) :-
    dsa_art_28_minors_order_profile_for(Subject, Profile),
    findall(Verdict, decide_dsa_art_28_minors_order(Profile, Verdict), Verdicts),
    length(Verdicts, VerdictCount).

problems_count(Subject, ProblemsCount) :-
    dsa_art_28_minors_order_profile_for(Subject, Profile),
    findall(Problems, dsa_art_28_minors_order_input_problems(Profile, Problems), ProblemLists),
    length(ProblemLists, ProblemsCount).

subject_classifies(Subject) :-
    dsa_art_28_minors_order_subject(Subject),
    dsa_art_28_minors_order_profile_for(Subject, Profile),
    decide_dsa_art_28_minors_order(Profile, _Verdict).

fixed_citations(section_3_applies, [cite(eu_reg_2022_2065_art_19_1), cite(eu_reg_2022_2065_art_19_2)]).
fixed_citations(section_3_not_applicable, [cite(eu_reg_2022_2065_art_19_1), cite(eu_reg_2022_2065_art_19_2)]).
fixed_citations(art_28_1_obligation_applies, [cite(eu_reg_2022_2065_art_19_1), cite(eu_reg_2022_2065_art_19_2), cite(eu_reg_2022_2065_art_28_1)]).
fixed_citations(art_28_1_obligation_not_applicable, [cite(eu_reg_2022_2065_art_19_1), cite(eu_reg_2022_2065_art_19_2), cite(eu_reg_2022_2065_art_28_1)]).
fixed_citations(art_28_1_measures_compliant, [cite(eu_reg_2022_2065_art_19_1), cite(eu_reg_2022_2065_art_19_2), cite(eu_reg_2022_2065_art_28_1)]).
fixed_citations(art_28_1_measures_not_compliant, [cite(eu_reg_2022_2065_art_19_1), cite(eu_reg_2022_2065_art_19_2), cite(eu_reg_2022_2065_art_28_1)]).
fixed_citations(art_28_1_measures_not_required, [cite(eu_reg_2022_2065_art_19_1), cite(eu_reg_2022_2065_art_19_2), cite(eu_reg_2022_2065_art_28_1)]).
fixed_citations(art_28_2_presentation_prohibited, [cite(eu_reg_2022_2065_art_19_1), cite(eu_reg_2022_2065_art_19_2), cite(eu_reg_2022_2065_art_28_2)]).
fixed_citations(art_28_2_presentation_not_prohibited, [cite(eu_reg_2022_2065_art_19_1), cite(eu_reg_2022_2065_art_19_2), cite(eu_reg_2022_2065_art_28_2)]).

citations_fit(Result, Citations) :-
    fixed_citations(Result, Citations).
citations_fit(indeterminate(_), []).
citations_fit(needs_legal_review(_, _), []).
citations_fit(input_problems(_), []).

basis_fits(section_3_not_applicable, [outside_fact(designated_as_very_large_online_platform, attested(false, attestation(_, _, _, _)))]).
basis_fits(Result, []) :-
    dif(Result, section_3_not_applicable).

set_like(Citations) :-
    sort(Citations, SortedCitations),
    same_length(Citations, SortedCitations).

test(totality_every_subject_classifies) :-
    findall(Subject, dsa_art_28_minors_order_subject(Subject), Subjects),
    sort(Subjects, SubjectSet),
    findall(Subject, subject_classifies(Subject), ClassifiedSubjects),
    sort(ClassifiedSubjects, SubjectSet).
test(determinism_every_subject_has_exactly_one_verdict) :-
    findall(Subject, dsa_art_28_minors_order_subject(Subject), Subjects),
    findall(Subject, (dsa_art_28_minors_order_subject(Subject), verdict_count(Subject, 1)), SingleSubjects),
    SingleSubjects == Subjects.
test(determinism_every_question_has_exactly_one_answer) :-
    findall(Subject - Question, subject_question(Subject, Question), Pairs),
    findall(Subject - Question, (subject_question(Subject, Question), answer_count(Subject, Question, 1)), SinglePairs),
    SinglePairs == Pairs.
test(determinism_the_input_check_has_exactly_one_answer) :-
    findall(Subject, dsa_art_28_minors_order_subject(Subject), Subjects),
    findall(Subject, (dsa_art_28_minors_order_subject(Subject), problems_count(Subject, 1)), SingleSubjects),
    SingleSubjects == Subjects.
test(the_basis_is_fixed_per_result) :-
    findall(Subject - Question, subject_question_answer(Subject, Question, _, _, _), Answered),
    findall(Subject - Question, (subject_question_answer(Subject, Question, Result, Basis, _), basis_fits(Result, Basis)), Fitting),
    Fitting == Answered.
test(the_citations_are_fixed_per_result) :-
    findall(Subject - Question, subject_question_answer(Subject, Question, _, _, _), Answered),
    findall(Subject - Question, (subject_question_answer(Subject, Question, Result, _, Citations), citations_fit(Result, Citations)), Fitting),
    Fitting == Answered.
test(every_citation_list_is_set_like) :-
    findall(Subject - Question, subject_question_answer(Subject, Question, _, _, _), Answered),
    findall(Subject - Question, (subject_question_answer(Subject, Question, _, _, Citations), set_like(Citations)), SetLike),
    SetLike == Answered.
test(the_basis_invariant_is_not_vacuous) :-
    findall(Subject, subject_question_answer(Subject, section_3_application, section_3_not_applicable, _, _), NotApplicableSubjects),
    NotApplicableSubjects = [_|_].
test(each_checklist_row_is_the_answer_of_its_question) :-
    findall(Subject - Question, subject_question(Subject, Question), Pairs),
    findall(Subject - Question, (subject_question(Subject, Question), row_agrees(Subject, Question)), AgreeingPairs),
    AgreeingPairs == Pairs.

row_agrees(Subject, Question) :-
    subject_question_answer(Subject, Question, Result, _, Citations),
    dsa_art_28_minors_order_profile_for(Subject, Profile),
    dsa_art_28_minors_order_checklist(Profile, Rows),
    member(item(Question, Result, Citations), Rows).

cp_test_names([totality_every_subject_classifies, determinism_every_subject_has_exactly_one_verdict, determinism_every_question_has_exactly_one_answer, determinism_the_input_check_has_exactly_one_answer, the_basis_is_fixed_per_result, the_citations_are_fixed_per_result, every_citation_list_is_set_like, the_basis_invariant_is_not_vacuous, each_checklist_row_is_the_answer_of_its_question]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
