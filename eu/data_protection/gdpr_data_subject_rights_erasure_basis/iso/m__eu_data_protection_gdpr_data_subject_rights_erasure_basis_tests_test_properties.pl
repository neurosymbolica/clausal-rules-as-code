% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_data_subject_rights_erasure_basis_tests_test_properties, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_data_subject_rights_erasure_basis_request_basis, [decide_request_basis/2, request_basis_status_values/1, request_basis/2]).
:- use_module(m__eu_data_protection_gdpr_data_subject_rights_erasure_basis_queries, [gdpr_data_subject_rights_erasure_basis_compliance_check/3, gdpr_data_subject_rights_erasure_basis_justification/2]).
:- use_module(m__eu_data_protection_gdpr_data_subject_rights_erasure_basis_fixtures, [gdpr_data_subject_rights_erasure_basis_subject/1, gdpr_data_subject_rights_erasure_basis_profile_for/2]).

subject_classifies(Subject) :-
    gdpr_data_subject_rights_erasure_basis_subject(Subject),
    gdpr_data_subject_rights_erasure_basis_profile_for(Subject, Profile),
    decide_request_basis(Profile, _Verdict).

basis_cited(none, _).
basis_cited(Basis, [_FirstCitation|_OtherCitations]) :-
    dif(Basis, none).

all_items_cited([]).
all_items_cited([item(_, _, cite(_))|Items]) :-
    all_items_cited(Items).

test(totality_every_subject_classifies) :-
    findall(Subject, gdpr_data_subject_rights_erasure_basis_subject(Subject), Subjects),
    sort(Subjects, SubjectSet),
    findall(Subject, subject_classifies(Subject), ClassifiedSubjects),
    sort(ClassifiedSubjects, SubjectSet).
test(determinism_every_subject_has_exactly_one_verdict) :-
    findall(Subject, (gdpr_data_subject_rights_erasure_basis_subject(Subject), gdpr_data_subject_rights_erasure_basis_profile_for(Subject, Profile), findall(Verdict, decide_request_basis(Profile, Verdict), [_Only])), Singles),
    findall(Subject, gdpr_data_subject_rights_erasure_basis_subject(Subject), Subjects),
    Singles == Subjects.
test(determinism_every_subject_has_exactly_one_compliance_result) :-
    findall(Subject, (gdpr_data_subject_rights_erasure_basis_subject(Subject), gdpr_data_subject_rights_erasure_basis_profile_for(Subject, Profile), findall(Result, gdpr_data_subject_rights_erasure_basis_compliance_check(Profile, retain_data, Result), [_Only])), Singles),
    findall(Subject, gdpr_data_subject_rights_erasure_basis_subject(Subject), Subjects),
    Singles == Subjects.
test(every_basis_is_in_the_pinned_vocabulary) :-
    request_basis_status_values(Values),
    findall(Subject, (gdpr_data_subject_rights_erasure_basis_subject(Subject), gdpr_data_subject_rights_erasure_basis_profile_for(Subject, Profile), request_basis(Profile, Basis), member(Basis, Values)), Inside),
    findall(Subject, gdpr_data_subject_rights_erasure_basis_subject(Subject), Subjects),
    Inside == Subjects.
test(a_named_basis_always_carries_a_citation) :-
    findall(Subject, (gdpr_data_subject_rights_erasure_basis_subject(Subject), gdpr_data_subject_rights_erasure_basis_profile_for(Subject, Profile), decide_request_basis(Profile, request_basis_verdict(Basis, Citations)), basis_cited(Basis, Citations)), Cited),
    findall(Subject, gdpr_data_subject_rights_erasure_basis_subject(Subject), Subjects),
    Cited == Subjects.
test(every_checklist_item_carries_a_cite) :-
    findall(Subject, (gdpr_data_subject_rights_erasure_basis_subject(Subject), gdpr_data_subject_rights_erasure_basis_profile_for(Subject, Profile), gdpr_data_subject_rights_erasure_basis_justification(Profile, Items), all_items_cited(Items)), Cited),
    findall(Subject, gdpr_data_subject_rights_erasure_basis_subject(Subject), Subjects),
    Cited == Subjects.
test(a_blocking_fact_left_absent_does_not_change_the_basis) :-
    gdpr_data_subject_rights_erasure_basis_profile_for(necessity_no_longer, Profile),
    request_basis(Profile, art17_1_a).

cp_test_names([totality_every_subject_classifies, determinism_every_subject_has_exactly_one_verdict, determinism_every_subject_has_exactly_one_compliance_result, every_basis_is_in_the_pinned_vocabulary, a_named_basis_always_carries_a_citation, every_checklist_item_carries_a_cite, a_blocking_fact_left_absent_does_not_change_the_basis]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
