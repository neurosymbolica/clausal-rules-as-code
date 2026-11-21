% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_nis2_jurisdiction_registration_tests_test_properties, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_hof, [exclude/3]).
:- use_module(m__eu_nis2_jurisdiction_registration_nis2_jurisdiction_registration, [decide_nis2_jurisdiction_registration/2, nis2_jurisdiction_registration_status/2, nis2_jurisdiction_registration_status_values/1, jurisdiction_basis/3, main_establishment_rule/3, registry_submission_items/2, entity_list_submission_items/2, change_notification_limits/2]).
:- use_module(m__eu_nis2_jurisdiction_registration_kernel, [nis2_jurisdiction_registration_input_problems/2]).
:- use_module(m__eu_nis2_jurisdiction_registration_fixtures, [nis2_jurisdiction_registration_subject/1, nis2_jurisdiction_registration_profile_for/2]).

all_subjects(Subjects) :-
    findall(Subject, nis2_jurisdiction_registration_subject(Subject), Subjects).

well_formed_subjects(Subjects) :-
    findall(Subject, well_formed_subject(Subject), Subjects).

well_formed_subject(Subject) :-
    nis2_jurisdiction_registration_subject(Subject),
    nis2_jurisdiction_registration_profile_for(Subject, Profile),
    nis2_jurisdiction_registration_input_problems(Profile, []).

subject_classifies(Subject) :-
    nis2_jurisdiction_registration_subject(Subject),
    nis2_jurisdiction_registration_profile_for(Subject, Profile),
    decide_nis2_jurisdiction_registration(Profile, _Verdict).

one_verdict(Subject) :-
    nis2_jurisdiction_registration_profile_for(Subject, Profile),
    findall(Verdict, decide_nis2_jurisdiction_registration(Profile, Verdict), Verdicts),
    length(Verdicts, 1).

one_answer_per_query(Subject) :-
    nis2_jurisdiction_registration_profile_for(Subject, Profile),
    findall(Basis - BasisCitations, jurisdiction_basis(Profile, Basis, BasisCitations), BasisAnswers),
    length(BasisAnswers, 1),
    findall(Result - ResultCitations, main_establishment_rule(Profile, Result, ResultCitations), ResultAnswers),
    length(ResultAnswers, 1),
    findall(RegistryItems, registry_submission_items(Profile, RegistryItems), RegistryAnswers),
    length(RegistryAnswers, 1),
    findall(ListItems, entity_list_submission_items(Profile, ListItems), ListAnswers),
    length(ListAnswers, 1),
    findall(Limits, change_notification_limits(Profile, Limits), LimitAnswers),
    length(LimitAnswers, 1),
    findall(Problems, nis2_jurisdiction_registration_input_problems(Profile, Problems), ProblemAnswers),
    length(ProblemAnswers, 1).

status_in_table(Subject) :-
    nis2_jurisdiction_registration_profile_for(Subject, Profile),
    nis2_jurisdiction_registration_status(Profile, Status),
    nis2_jurisdiction_registration_status_values(StatusValues),
    member(Status, StatusValues).

is_citation(cite(Key)) :-
    atom(Key).

citations_well_formed(Subject) :-
    nis2_jurisdiction_registration_profile_for(Subject, Profile),
    decide_nis2_jurisdiction_registration(Profile, nis2_jurisdiction_registration_verdict(_, Citations)),
    sort(Citations, Citations),
    maplist(is_citation, Citations).

rejection_consistent(Subject) :-
    nis2_jurisdiction_registration_profile_for(Subject, Profile),
    nis2_jurisdiction_registration_input_problems(Profile, Problems),
    rejection_matches(Problems, Profile).

rejection_matches([], Profile) :-
    nis2_jurisdiction_registration_status(Profile, Status),
    dif(Status, profile_rejected).
rejection_matches([_|_], Profile) :-
    nis2_jurisdiction_registration_status(Profile, profile_rejected).

is_category_attribute(attribute(entity_category, _)).

entity_list_ignores_category(Subject) :-
    nis2_jurisdiction_registration_profile_for(Subject, Profile),
    exclude(is_category_attribute, Profile, Stripped),
    entity_list_submission_items(Profile, Items),
    entity_list_submission_items(Stripped, StrippedItems),
    Items == StrippedItems.

referral_rests_on_unsure(Subject) :-
    nis2_jurisdiction_registration_profile_for(Subject, Profile),
    main_establishment_rule(Profile, Result, _),
    referral_check(Result, Profile).

referral_check(needs_legal_review(open_textured(Key, cite(eu_dir_2022_2555_art_26_2)), [inputs_relied_on(_)]), Profile) :-
    member(attribute(Key, unsure), Profile).
referral_check(Result, _) :-
    Result \= needs_legal_review(_, _).

non_final_basis_has_no_citation(Subject) :-
    nis2_jurisdiction_registration_profile_for(Subject, Profile),
    jurisdiction_basis(Profile, Basis, Citations),
    basis_citation_check(Basis, Citations).

basis_citation_check(indeterminate([Key]), []) :-
    atom(Key).
basis_citation_check(input_problems([_|_]), []).
basis_citation_check(Basis, [_|_]) :-
    atom(Basis).

test(totality_every_subject_classifies) :-
    all_subjects(Subjects),
    sort(Subjects, SubjectSet),
    findall(Subject, subject_classifies(Subject), ClassifiedSubjects),
    sort(ClassifiedSubjects, SubjectSet).
test(determinism_every_subject_has_one_verdict) :-
    all_subjects(Subjects),
    maplist(one_verdict, Subjects).
test(determinism_every_query_has_one_answer) :-
    all_subjects(Subjects),
    maplist(one_answer_per_query, Subjects).
test(every_status_is_in_the_table) :-
    all_subjects(Subjects),
    maplist(status_in_table, Subjects).
test(verdict_citations_are_sorted_cite_terms) :-
    all_subjects(Subjects),
    maplist(citations_well_formed, Subjects).
test(rejection_iff_input_problems) :-
    all_subjects(Subjects),
    maplist(rejection_consistent, Subjects).
test(entity_list_does_not_read_the_category) :-
    well_formed_subjects(Subjects),
    maplist(entity_list_ignores_category, Subjects).
test(a_referral_rests_on_an_unsure_judgement) :-
    well_formed_subjects(Subjects),
    maplist(referral_rests_on_unsure, Subjects).
test(a_non_final_basis_has_no_citation) :-
    all_subjects(Subjects),
    maplist(non_final_basis_has_no_citation, Subjects).
test(the_well_formed_set_is_not_vacuous) :-
    well_formed_subjects(Subjects),
    length(Subjects, Count),
    Count >= 10.

cp_test_names([totality_every_subject_classifies, determinism_every_subject_has_one_verdict, determinism_every_query_has_one_answer, every_status_is_in_the_table, verdict_citations_are_sorted_cite_terms, rejection_iff_input_problems, entity_list_does_not_read_the_category, a_referral_rests_on_an_unsure_judgement, a_non_final_basis_has_no_citation, the_well_formed_set_is_not_vacuous]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
