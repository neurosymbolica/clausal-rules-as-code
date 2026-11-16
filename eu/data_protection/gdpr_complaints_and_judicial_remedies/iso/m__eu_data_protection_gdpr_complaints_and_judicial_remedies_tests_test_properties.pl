% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_complaints_and_judicial_remedies_tests_test_properties, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_complaints_and_judicial_remedies_gdpr_complaints_and_judicial_remedies, [decide_gdpr_complaints_and_judicial_remedies/2]).
:- use_module(m__eu_data_protection_gdpr_complaints_and_judicial_remedies_kernel, [gdpr_complaints_and_judicial_remedies_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_complaints_and_judicial_remedies_fixtures, [gdpr_complaints_and_judicial_remedies_subject/1, gdpr_complaints_and_judicial_remedies_profile_for/2, gdpr_complaints_and_judicial_remedies_assess/2]).

subject_classifies(Subject) :-
    gdpr_complaints_and_judicial_remedies_subject(Subject),
    gdpr_complaints_and_judicial_remedies_profile_for(Subject, Profile),
    decide_gdpr_complaints_and_judicial_remedies(Profile, _Verdict).

subject_answers(Subject, Count) :-
    findall(Verdict, gdpr_complaints_and_judicial_remedies_assess(Subject, Verdict), Verdicts),
    length(Verdicts, Count).

all_answer_once([]).
all_answer_once([Subject|Subjects]) :-
    subject_answers(Subject, 1),
    all_answer_once(Subjects).

final_result(complaint_right_exists).
final_result(no_complaint_right).
final_result(decision_remedy_right_exists).
final_result(no_decision_remedy_right).
final_result(inaction_remedy_right_exists).
final_result(no_inaction_remedy_right).
final_result(judicial_remedy_right_exists).
final_result(no_judicial_remedy_right).
final_result(forum_establishment_state_only).
final_result(forum_establishment_or_habitual_residence_state).

non_final_result(indeterminate(_)).
non_final_result(needs_legal_review(_, _)).
non_final_result(input_problems(_)).

citation_in_vocabulary(cite(eu_reg_2016_679_art_77_1)).
citation_in_vocabulary(cite(eu_reg_2016_679_art_78_1)).
citation_in_vocabulary(cite(eu_reg_2016_679_art_78_2)).
citation_in_vocabulary(cite(eu_reg_2016_679_art_79_1)).
citation_in_vocabulary(cite(eu_reg_2016_679_art_79_2)).

all_cited([]).
all_cited([[_|_]|CitationLists]) :-
    all_cited(CitationLists).

all_uncited([]).
all_uncited([[]|CitationLists]) :-
    all_uncited(CitationLists).

all_in_vocabulary([]).
all_in_vocabulary([Citation|Citations]) :-
    citation_in_vocabulary(Citation),
    all_in_vocabulary(Citations).

single_input_answer(Term) :-
    findall(Problems, gdpr_complaints_and_judicial_remedies_input_problems(Term, Problems), Answers),
    length(Answers, 1).

test(totality_every_subject_classifies) :-
    findall(Subject, gdpr_complaints_and_judicial_remedies_subject(Subject), Subjects),
    sort(Subjects, SubjectSet),
    findall(Subject, subject_classifies(Subject), ClassifiedSubjects),
    sort(ClassifiedSubjects, SubjectSet).
test(determinism_every_subject_answers_exactly_once) :-
    findall(Subject, gdpr_complaints_and_judicial_remedies_subject(Subject), Subjects),
    sort(Subjects, SubjectSet),
    SubjectSet = [_|_],
    all_answer_once(SubjectSet).
test(every_final_result_is_cited) :-
    findall(Citations, (gdpr_complaints_and_judicial_remedies_assess(_, gdpr_complaints_and_judicial_remedies_verdict(Result, Citations)), final_result(Result)), CitationLists),
    CitationLists = [_|_],
    all_cited(CitationLists).
test(every_non_final_result_has_no_citation) :-
    findall(Citations, (gdpr_complaints_and_judicial_remedies_assess(_, gdpr_complaints_and_judicial_remedies_verdict(Result, Citations)), non_final_result(Result)), CitationLists),
    CitationLists = [_|_],
    all_uncited(CitationLists).
test(every_citation_is_in_the_vocabulary) :-
    findall(Citation, (gdpr_complaints_and_judicial_remedies_assess(_, gdpr_complaints_and_judicial_remedies_verdict(_, Citations)), member(Citation, Citations)), AllCitations),
    AllCitations = [_|_],
    all_in_vocabulary(AllCitations).
test(the_input_check_has_one_solution_for_every_term) :-
    single_input_answer(_),
    single_input_answer([_|_]),
    single_input_answer(not_a_profile),
    single_input_answer([stray]),
    single_input_answer([attribute(is_data_subject, _)]),
    single_input_answer([attribute(1, true)]),
    single_input_answer([attribute(is_data_subject, true), attribute(is_data_subject, true)]).

cp_test_names([totality_every_subject_classifies, determinism_every_subject_answers_exactly_once, every_final_result_is_cited, every_non_final_result_has_no_citation, every_citation_is_in_the_vocabulary, the_input_check_has_one_solution_for_every_term]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
