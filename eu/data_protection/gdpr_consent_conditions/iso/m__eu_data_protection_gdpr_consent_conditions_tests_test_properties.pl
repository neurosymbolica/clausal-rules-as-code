% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_consent_conditions_tests_test_properties, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_consent_conditions_gdpr_consent_conditions, [decide_gdpr_consent_conditions/2, consent_conditions_status/4, consent_declaration_effect/3, consent_assessment_factors/2, identification_obligation/4, identification_information_duty/4, identification_rights_effect/4]).
:- use_module(m__eu_data_protection_gdpr_consent_conditions_fixtures, [gdpr_consent_conditions_subject/1, gdpr_consent_conditions_profile_for/2]).

subject_classifies(Subject) :-
    gdpr_consent_conditions_subject(Subject),
    gdpr_consent_conditions_profile_for(Subject, Profile),
    decide_gdpr_consent_conditions(Profile, _Verdict).

subject_set(SubjectSet) :-
    findall(Subject, gdpr_consent_conditions_subject(Subject), Subjects),
    sort(Subjects, SubjectSet).

subject_conditions_once(Subject) :-
    gdpr_consent_conditions_subject(Subject),
    gdpr_consent_conditions_profile_for(Subject, Profile),
    findall(Status, consent_conditions_status(Profile, Status, _, _), Statuses),
    length(Statuses, 1).

subject_effect_once(Subject) :-
    gdpr_consent_conditions_subject(Subject),
    gdpr_consent_conditions_profile_for(Subject, Profile),
    findall(Status, consent_declaration_effect(Profile, Status, _), Statuses),
    length(Statuses, 1).

subject_factors_once(Subject) :-
    gdpr_consent_conditions_subject(Subject),
    gdpr_consent_conditions_profile_for(Subject, Profile),
    findall(Factors, consent_assessment_factors(Profile, Factors), FactorLists),
    length(FactorLists, 1).

subject_obligation_once(Subject) :-
    gdpr_consent_conditions_subject(Subject),
    gdpr_consent_conditions_profile_for(Subject, Profile),
    findall(Status, identification_obligation(Profile, Status, _, _), Statuses),
    length(Statuses, 1).

subject_duty_once(Subject) :-
    gdpr_consent_conditions_subject(Subject),
    gdpr_consent_conditions_profile_for(Subject, Profile),
    findall(Status, identification_information_duty(Profile, Status, _, _), Statuses),
    length(Statuses, 1).

subject_rights_once(Subject) :-
    gdpr_consent_conditions_subject(Subject),
    gdpr_consent_conditions_profile_for(Subject, Profile),
    findall(Status, identification_rights_effect(Profile, Status, _, _), Statuses),
    length(Statuses, 1).

test(totality_every_subject_classifies) :-
    subject_set(SubjectSet),
    findall(Subject, subject_classifies(Subject), ClassifiedSubjects),
    sort(ClassifiedSubjects, SubjectSet).
test(determinism_conditions_status_exactly_one_solution) :-
    subject_set(SubjectSet),
    findall(Subject, subject_conditions_once(Subject), Subjects),
    sort(Subjects, SubjectSet).
test(determinism_declaration_effect_exactly_one_solution) :-
    subject_set(SubjectSet),
    findall(Subject, subject_effect_once(Subject), Subjects),
    sort(Subjects, SubjectSet).
test(determinism_factors_exactly_one_solution) :-
    subject_set(SubjectSet),
    findall(Subject, subject_factors_once(Subject), Subjects),
    sort(Subjects, SubjectSet).
test(determinism_obligation_exactly_one_solution) :-
    subject_set(SubjectSet),
    findall(Subject, subject_obligation_once(Subject), Subjects),
    sort(Subjects, SubjectSet).
test(determinism_duty_exactly_one_solution) :-
    subject_set(SubjectSet),
    findall(Subject, subject_duty_once(Subject), Subjects),
    sort(Subjects, SubjectSet).
test(determinism_rights_exactly_one_solution) :-
    subject_set(SubjectSet),
    findall(Subject, subject_rights_once(Subject), Subjects),
    sort(Subjects, SubjectSet).
test(invariant_met_has_basis_and_citations) :-
    gdpr_consent_conditions_profile_for(consent_met_plain, Profile),
    consent_conditions_status(Profile, conditions_met, [_|_], [_|_]).
test(invariant_not_applicable_has_empty_basis) :-
    gdpr_consent_conditions_profile_for(processing_not_on_consent, Profile),
    consent_conditions_status(Profile, not_applicable, [], []).

cp_test_names([totality_every_subject_classifies, determinism_conditions_status_exactly_one_solution, determinism_declaration_effect_exactly_one_solution, determinism_factors_exactly_one_solution, determinism_obligation_exactly_one_solution, determinism_duty_exactly_one_solution, determinism_rights_exactly_one_solution, invariant_met_has_basis_and_citations, invariant_not_applicable_has_empty_basis]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
