% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_child_consent_age_fields_tests_test_properties, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(library(clpz)).
:- use_module(m__eu_data_protection_gdpr_child_consent_age_fields_child_consent_status, [child_consent_status/2, child_consent_outside_facts/2]).
:- use_module(m__eu_data_protection_gdpr_child_consent_age_fields_parental_verification, [parental_verification/2]).
:- use_module(m__eu_data_protection_gdpr_child_consent_age_fields_fixtures, [gdpr_child_consent_age_fields_subject/1, gdpr_child_consent_age_fields_profile_for/2]).

subject_has_one_status(Subject) :-
    gdpr_child_consent_age_fields_subject(Subject),
    gdpr_child_consent_age_fields_profile_for(Subject, Profile),
    findall(Status, child_consent_status(Profile, Status), Statuses),
    length(Statuses, 1).

subject_has_one_verification(Subject) :-
    gdpr_child_consent_age_fields_subject(Subject),
    gdpr_child_consent_age_fields_profile_for(Subject, Profile),
    findall(Verification, parental_verification(Profile, Verification), Verifications),
    length(Verifications, 1).

subject_has_one_outside_record(Subject) :-
    gdpr_child_consent_age_fields_subject(Subject),
    gdpr_child_consent_age_fields_profile_for(Subject, Profile),
    findall(Facts, child_consent_outside_facts(Profile, Facts), FactLists),
    length(FactLists, 1).

subject_is_coherent(Subject) :-
    gdpr_child_consent_age_fields_subject(Subject),
    gdpr_child_consent_age_fields_profile_for(Subject, Profile),
    child_consent_status(Profile, Status),
    parental_verification(Profile, Verification),
    coherent(Status, Verification).

coherent(indeterminate(_), not_reached).
coherent(needs_legal_review(_, _), not_reached).
coherent(input_problems(_), not_reached).
coherent(ineligible, not_applicable).
coherent(eligible, efforts_reasonable).
coherent(eligible, efforts_not_reasonable).
coherent(eligible, not_applicable).
coherent(eligible, indeterminate(_)).
coherent(eligible, needs_legal_review(_, _)).

all_subjects(Subjects) :-
    findall(Subject, gdpr_child_consent_age_fields_subject(Subject), AllSubjects),
    sort(AllSubjects, Subjects).

age_without_parent_is_eligible(AgeYears) :-
    between(16, 25, AgeYears),
    age_profile(AgeYears, Profile),
    child_consent_status(Profile, eligible).

age_profile(AgeYears, [attribute(processing_rests_on_consent, true), attribute(information_society_service, true), attribute(offered_directly_to_child, true), attribute(child_age_years, AgeYears), attribute(parental_consent_given, false)]).

age_below_13_without_parent_is_ineligible(AgeYears) :-
    between(0, 12, AgeYears),
    age_profile(AgeYears, Profile),
    child_consent_status(Profile, ineligible).

test(totality_every_subject_has_one_status) :-
    all_subjects(Subjects),
    findall(Subject, subject_has_one_status(Subject), Answered),
    sort(Answered, Subjects).
test(totality_every_subject_has_one_verification) :-
    all_subjects(Subjects),
    findall(Subject, subject_has_one_verification(Subject), Answered),
    sort(Answered, Subjects).
test(totality_every_subject_has_one_outside_record) :-
    all_subjects(Subjects),
    findall(Subject, subject_has_one_outside_record(Subject), Answered),
    sort(Answered, Subjects).
test(the_two_fields_are_coherent_for_every_subject) :-
    all_subjects(Subjects),
    findall(Subject, subject_is_coherent(Subject), Coherent),
    sort(Coherent, Subjects).
test(the_subject_set_is_not_empty) :-
    all_subjects([_|_]).
test(every_age_from_16_is_eligible_by_own_consent) :-
    findall(AgeYears, age_without_parent_is_eligible(AgeYears), Ages),
    Ages == [16, 17, 18, 19, 20, 21, 22, 23, 24, 25].
test(every_age_below_13_without_parent_is_ineligible) :-
    findall(AgeYears, age_below_13_without_parent_is_ineligible(AgeYears), Ages),
    Ages == [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12].

cp_test_names([totality_every_subject_has_one_status, totality_every_subject_has_one_verification, totality_every_subject_has_one_outside_record, the_two_fields_are_coherent_for_every_subject, the_subject_set_is_not_empty, every_age_from_16_is_eligible_by_own_consent, every_age_below_13_without_parent_is_ineligible]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
