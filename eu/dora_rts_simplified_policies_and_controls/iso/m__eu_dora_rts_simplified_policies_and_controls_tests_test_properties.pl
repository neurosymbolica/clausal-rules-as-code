% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_rts_simplified_policies_and_controls_tests_test_properties, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_lists_extra, [subtract/3]).
:- use_module(m__eu_dora_rts_simplified_policies_and_controls_dora_rts_simplified_policies_and_controls, [simplified_policies_and_controls_duties_required/3, simplified_policies_and_controls_duties_complete/3, simplified_policies_and_controls_duties_outstanding/3, decide_dora_rts_simplified_policies_and_controls/2]).
:- use_module(m__eu_dora_rts_simplified_policies_and_controls_kernel, [dora_rts_simplified_policies_and_controls_input_problems/2]).
:- use_module(m__eu_dora_rts_simplified_policies_and_controls_fixtures, [dora_rts_simplified_policies_and_controls_subject/1, dora_rts_simplified_policies_and_controls_profile_for/2]).

expected_fixed_citations([cite(eu_reg_2022_2554_art_16_1), cite(eu_reg_2024_1774_art_28_1), cite(eu_reg_2024_1774_art_28_2), cite(eu_reg_2024_1774_art_28_4), cite(eu_reg_2024_1774_art_28_5), cite(eu_reg_2024_1774_art_28_6), cite(eu_reg_2024_1774_art_29_1), cite(eu_reg_2024_1774_art_29_2), cite(eu_reg_2024_1774_art_30_1), cite(eu_reg_2024_1774_art_30_2), cite(eu_reg_2024_1774_art_31_1), cite(eu_reg_2024_1774_art_31_2), cite(eu_reg_2024_1774_art_31_3), cite(eu_reg_2024_1774_art_31_4), cite(eu_reg_2024_1774_art_32_1), cite(eu_reg_2024_1774_art_32_2), cite(eu_reg_2024_1774_art_32_3), cite(eu_reg_2024_1774_art_33), cite(eu_reg_2024_1774_art_34), cite(eu_reg_2024_1774_art_35)]).

all_subjects(Subjects) :-
    findall(Subject, dora_rts_simplified_policies_and_controls_subject(Subject), Found),
    sort(Found, Subjects).

subject_classifies(Subject) :-
    dora_rts_simplified_policies_and_controls_subject(Subject),
    dora_rts_simplified_policies_and_controls_profile_for(Subject, Profile),
    decide_dora_rts_simplified_policies_and_controls(Profile, _Verdict).

single_query_answer(Query, Subject) :-
    dora_rts_simplified_policies_and_controls_subject(Subject),
    dora_rts_simplified_policies_and_controls_profile_for(Subject, Profile),
    findall(Result - Citations, call(Query, Profile, Result, Citations), [_]).

subjects_with_one_answer(Query, Subjects) :-
    findall(Subject, single_query_answer(Query, Subject), Found),
    sort(Found, Subjects).

single_input_answer(Subject) :-
    dora_rts_simplified_policies_and_controls_subject(Subject),
    dora_rts_simplified_policies_and_controls_profile_for(Subject, Profile),
    findall(Problems, dora_rts_simplified_policies_and_controls_input_problems(Profile, Problems), [_]).

single_verdict(Subject) :-
    dora_rts_simplified_policies_and_controls_subject(Subject),
    dora_rts_simplified_policies_and_controls_profile_for(Subject, Profile),
    findall(Verdict, decide_dora_rts_simplified_policies_and_controls(Profile, Verdict), [_]).

test(totality_every_subject_classifies) :-
    all_subjects(SubjectSet),
    findall(Subject, subject_classifies(Subject), ClassifiedSubjects),
    sort(ClassifiedSubjects, SubjectSet).
test(determinism_required) :-
    all_subjects(Subjects),
    subjects_with_one_answer(simplified_policies_and_controls_duties_required, Subjects).
test(determinism_complete) :-
    all_subjects(Subjects),
    subjects_with_one_answer(simplified_policies_and_controls_duties_complete, Subjects).
test(determinism_outstanding) :-
    all_subjects(Subjects),
    subjects_with_one_answer(simplified_policies_and_controls_duties_outstanding, Subjects).
test(determinism_input_check) :-
    all_subjects(Subjects),
    findall(Subject, single_input_answer(Subject), Found),
    sort(Found, Subjects).
test(determinism_verdict) :-
    all_subjects(Subjects),
    findall(Subject, single_verdict(Subject), Found),
    sort(Found, Subjects).
test(the_input_check_answers_every_odd_term_once) :-
    odd_profile_terms(Terms),
    findall(Term, (member(Term, Terms), odd_term_answers_once(Term)), Answered),
    length(Terms, Count),
    length(Answered, Count).
test(citations_fit_every_required_answer) :-
    all_subjects(Subjects),
    citation_shape_subjects(simplified_policies_and_controls_duties_required, Subjects).
test(citations_fit_every_complete_answer) :-
    all_subjects(Subjects),
    citation_shape_subjects(simplified_policies_and_controls_duties_complete, Subjects).
test(citations_fit_every_outstanding_answer) :-
    all_subjects(Subjects),
    citation_shape_subjects(simplified_policies_and_controls_duties_outstanding, Subjects).
test(complete_exactly_when_none_outstanding) :-
    findall(Subject, complete_subject(Subject), CompleteFound),
    sort(CompleteFound, CompleteSubjects),
    findall(Subject, none_outstanding_subject(Subject), NoneFound),
    sort(NoneFound, NoneSubjects),
    CompleteSubjects == NoneSubjects,
    CompleteSubjects = [_|_].
test(required_reads_the_gate_only) :-
    findall(Subject, full_duty_list_subject(Subject), Found),
    sort(Found, Subjects),
    sort([all_duties_performed, one_duty_not_performed, one_duty_absent, one_duty_unsure, false_and_absent, false_and_unsure, absent_before_unsure, several_duties_not_performed], Expected),
    Subjects == Expected.
test(outstanding_duties_are_required_duties) :-
    findall(Subject, outstanding_subset_of_required(Subject), Found),
    sort(Found, Subjects),
    Subjects == [one_duty_not_performed, several_duties_not_performed].

odd_profile_terms([_, widget, [widget], [attribute(user_accountability_ensured, true)|_], [attribute(_, _)], [_], [attribute(7, true), attribute(7.0, true)], "profile"]).

odd_term_answers_once(Term) :-
    findall(Problems, dora_rts_simplified_policies_and_controls_input_problems(Term, Problems), [_]).

fixed_citation_set(Citations) :-
    expected_fixed_citations(Fixed),
    sort(Fixed, FixedSet),
    sort(Citations, CitationSet),
    CitationSet == FixedSet,
    length(Citations, 20).

citations_fit(required(_), Citations) :-
    fixed_citation_set(Citations).
citations_fit(complete, Citations) :-
    fixed_citation_set(Citations).
citations_fit(incomplete, Citations) :-
    fixed_citation_set(Citations).
citations_fit(none_outstanding, Citations) :-
    fixed_citation_set(Citations).
citations_fit(not_article_16_1_entity, [cite(eu_reg_2022_2554_art_16_1)]).
citations_fit(outstanding([_|_]), [_|_]).
citations_fit(indeterminate([_]), []).
citations_fit(needs_legal_review(open_textured(_, cite(_)), [inputs_relied_on(_)]), []).
citations_fit(input_problems([_|_]), []).

citation_shape_holds(Query, Subject) :-
    dora_rts_simplified_policies_and_controls_subject(Subject),
    dora_rts_simplified_policies_and_controls_profile_for(Subject, Profile),
    call(Query, Profile, Result, Citations),
    citations_fit(Result, Citations).

citation_shape_subjects(Query, Subjects) :-
    findall(Subject, citation_shape_holds(Query, Subject), Found),
    sort(Found, Subjects).

complete_subject(Subject) :-
    dora_rts_simplified_policies_and_controls_subject(Subject),
    dora_rts_simplified_policies_and_controls_profile_for(Subject, Profile),
    simplified_policies_and_controls_duties_complete(Profile, complete, _).

none_outstanding_subject(Subject) :-
    dora_rts_simplified_policies_and_controls_subject(Subject),
    dora_rts_simplified_policies_and_controls_profile_for(Subject, Profile),
    simplified_policies_and_controls_duties_outstanding(Profile, none_outstanding, _).

full_duty_list_subject(Subject) :-
    dora_rts_simplified_policies_and_controls_subject(Subject),
    dora_rts_simplified_policies_and_controls_profile_for(Subject, Profile),
    simplified_policies_and_controls_duties_required(Profile, required(Duties), _),
    length(Duties, 51).

outstanding_subset_of_required(Subject) :-
    dora_rts_simplified_policies_and_controls_subject(Subject),
    dora_rts_simplified_policies_and_controls_profile_for(Subject, Profile),
    simplified_policies_and_controls_duties_outstanding(Profile, outstanding(Outstanding), _),
    simplified_policies_and_controls_duties_required(Profile, required(Duties), _),
    subtract(Outstanding, Duties, Stray),
    Stray == [].

cp_test_names([totality_every_subject_classifies, determinism_required, determinism_complete, determinism_outstanding, determinism_input_check, determinism_verdict, the_input_check_answers_every_odd_term_once, citations_fit_every_required_answer, citations_fit_every_complete_answer, citations_fit_every_outstanding_answer, complete_exactly_when_none_outstanding, required_reads_the_gate_only, outstanding_duties_are_required_duties]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
