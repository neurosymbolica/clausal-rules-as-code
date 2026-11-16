% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_nis2_jurisdiction_registration_tests_test_properties, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_nis2_jurisdiction_registration_nis2_jurisdiction_registration, [decide_nis2_jurisdiction_registration/2, jurisdiction_basis/3, registry_submission_items/2, entity_list_submission_items/2, change_notification_limits/2]).
:- use_module(m__eu_nis2_jurisdiction_registration_fixtures, [nis2_jurisdiction_registration_subject/1, nis2_jurisdiction_registration_profile_for/2]).

subject_classifies(Subject) :-
    nis2_jurisdiction_registration_subject(Subject),
    nis2_jurisdiction_registration_profile_for(Subject, Profile),
    decide_nis2_jurisdiction_registration(Profile, _Verdict).

verdict_count(Subject, Count) :-
    nis2_jurisdiction_registration_subject(Subject),
    nis2_jurisdiction_registration_profile_for(Subject, Profile),
    findall(Verdict, decide_nis2_jurisdiction_registration(Profile, Verdict), Verdicts),
    length(Verdicts, Count).

query_count(Subject, Count) :-
    nis2_jurisdiction_registration_subject(Subject),
    nis2_jurisdiction_registration_profile_for(Subject, Profile),
    findall(Basis - Citations, jurisdiction_basis(Profile, Basis, Citations), Bases),
    findall(Items, registry_submission_items(Profile, Items), RegistryAnswers),
    findall(Items, entity_list_submission_items(Profile, Items), ListAnswers),
    findall(Limits, change_notification_limits(Profile, Limits), LimitAnswers),
    length(Bases, BasisCount),
    length(RegistryAnswers, RegistryCount),
    length(ListAnswers, ListCount),
    length(LimitAnswers, LimitCount),
    Count = [BasisCount, RegistryCount, ListCount, LimitCount].

test(totality_every_subject_classifies) :-
    findall(Subject, nis2_jurisdiction_registration_subject(Subject), Subjects),
    sort(Subjects, SubjectSet),
    findall(Subject, subject_classifies(Subject), ClassifiedSubjects),
    sort(ClassifiedSubjects, SubjectSet).
test(determinism_exactly_one_verdict_per_subject) :-
    findall(Count, verdict_count(_, Count), Counts),
    sort(Counts, [1]).
test(determinism_exactly_one_answer_per_query) :-
    findall(Count, query_count(_, Count), Counts),
    sort(Counts, [[1, 1, 1, 1]]).
test(the_subject_set_is_not_empty) :-
    nis2_jurisdiction_registration_subject(general_entity_established).
test(eligible_verdict_has_a_citation) :-
    nis2_jurisdiction_registration_profile_for(provider_established_in_union, Profile),
    decide_nis2_jurisdiction_registration(Profile, nis2_jurisdiction_registration_verdict(eligible, [_|_])).
test(ineligible_verdict_has_a_citation) :-
    nis2_jurisdiction_registration_profile_for(provider_non_union_no_services, Profile),
    decide_nis2_jurisdiction_registration(Profile, nis2_jurisdiction_registration_verdict(ineligible, [_|_])).
test(indeterminate_carries_no_citation) :-
    nis2_jurisdiction_registration_profile_for(category_missing, Profile),
    decide_nis2_jurisdiction_registration(Profile, nis2_jurisdiction_registration_verdict(indeterminate([entity_category]), [])).

test(no_eligible_verdict_lacks_a_citation, fail) :-
    nis2_jurisdiction_registration_subject(Subject),
    nis2_jurisdiction_registration_profile_for(Subject, Profile),
    decide_nis2_jurisdiction_registration(Profile, nis2_jurisdiction_registration_verdict(eligible, [])).
test(no_ineligible_verdict_lacks_a_citation, fail) :-
    nis2_jurisdiction_registration_subject(Subject),
    nis2_jurisdiction_registration_profile_for(Subject, Profile),
    decide_nis2_jurisdiction_registration(Profile, nis2_jurisdiction_registration_verdict(ineligible, [])).

cp_test_names([totality_every_subject_classifies, determinism_exactly_one_verdict_per_subject, determinism_exactly_one_answer_per_query, the_subject_set_is_not_empty, eligible_verdict_has_a_citation, ineligible_verdict_has_a_citation, indeterminate_carries_no_citation]).
cp_test_fail_names([no_eligible_verdict_lacks_a_citation, no_ineligible_verdict_lacks_a_citation]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
