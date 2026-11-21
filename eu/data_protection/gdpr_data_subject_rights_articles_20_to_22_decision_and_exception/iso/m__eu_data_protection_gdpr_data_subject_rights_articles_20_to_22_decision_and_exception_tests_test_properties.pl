% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_data_subject_rights_articles_20_to_22_decision_and_exception_tests_test_properties, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_data_subject_rights_articles_20_to_22_decision_and_exception_request_exception, [decide_request_exception/2, request_exception_verdict/2, request_exception_checklist/2, request_exception_status_values/1]).
:- use_module(m__eu_data_protection_gdpr_data_subject_rights_articles_20_to_22_decision_and_exception_request_exception, [request_decision/2, request_exception/2]).
:- use_module(m__eu_data_protection_gdpr_data_subject_rights_articles_20_to_22_decision_and_exception_fixtures, [gdpr_data_subject_rights_articles_20_to_22_decision_and_exception_subject/1, gdpr_data_subject_rights_articles_20_to_22_decision_and_exception_profile_for/2]).

subject_profile(Subject, Profile) :-
    gdpr_data_subject_rights_articles_20_to_22_decision_and_exception_profile_for(Subject, Profile).

all_subjects(SubjectSet) :-
    findall(Subject, gdpr_data_subject_rights_articles_20_to_22_decision_and_exception_subject(Subject), Subjects),
    sort(Subjects, SubjectSet).

subject_classifies(Subject) :-
    gdpr_data_subject_rights_articles_20_to_22_decision_and_exception_subject(Subject),
    subject_profile(Subject, Profile),
    decide_request_exception(Profile, _Verdict).

single_decision(Subject) :-
    subject_profile(Subject, Profile),
    findall(Comply, request_decision(Profile, Comply), Answers),
    length(Answers, 1).

single_exception(Subject) :-
    subject_profile(Subject, Profile),
    findall(Exception, request_exception(Profile, Exception), Answers),
    length(Answers, 1).

single_verdict(Subject) :-
    subject_profile(Subject, Profile),
    findall(Verdict, request_exception_verdict(Profile, Verdict), Verdicts),
    length(Verdicts, 1).

exception_in_table(Subject) :-
    subject_profile(Subject, Profile),
    request_exception(Profile, Exception),
    request_exception_status_values(StatusValues),
    member(Exception, StatusValues).

relief_consistent(need_not_comply, _).
relief_consistent(Comply, none) :-
    dif(Comply, need_not_comply).

conditions_expected(art22_2_a, [human_intervention, express_point_of_view, contest_decision]).
conditions_expected(art22_2_c, [human_intervention, express_point_of_view, contest_decision]).
conditions_expected(art12_5_manifestly_unfounded_or_excessive, [reasonable_fee_may_be_charged]).
conditions_expected(Exception, []) :-
    maplist(dif(Exception), [art22_2_a, art22_2_c, art12_5_manifestly_unfounded_or_excessive]).

verdict_consistent(Subject) :-
    subject_profile(Subject, Profile),
    request_exception_verdict(Profile, gdpr_data_subject_request_verdict(Comply, _, Exception, Conditions, Citations)),
    Citations == [],
    relief_consistent(Comply, Exception),
    conditions_expected(Exception, Expected),
    Conditions == Expected.

cited_item(item(_, _, cite(_))).

checklist_cited(Subject) :-
    subject_profile(Subject, Profile),
    request_exception_checklist(Profile, ChecklistItems),
    maplist(cited_item, ChecklistItems).

unread_key_invariant(Subject) :-
    subject_profile(Subject, Profile),
    request_decision(Profile, Comply),
    append(Profile, [attribute(consent_withdrawn, true)], Extended),
    request_decision(Extended, ExtendedComply),
    ExtendedComply == Comply.

test(totality_every_subject_classifies) :-
    all_subjects(SubjectSet),
    findall(Subject, subject_classifies(Subject), ClassifiedSubjects),
    sort(ClassifiedSubjects, SubjectSet).
test(determinism_one_decision_per_subject) :-
    all_subjects(SubjectSet),
    maplist(single_decision, SubjectSet).
test(determinism_one_exception_per_subject) :-
    all_subjects(SubjectSet),
    maplist(single_exception, SubjectSet).
test(determinism_one_verdict_per_subject) :-
    all_subjects(SubjectSet),
    maplist(single_verdict, SubjectSet).
test(every_exception_is_in_the_status_table) :-
    all_subjects(SubjectSet),
    maplist(exception_in_table, SubjectSet).
test(every_verdict_is_consistent) :-
    all_subjects(SubjectSet),
    maplist(verdict_consistent, SubjectSet).
test(every_checklist_item_is_cited) :-
    all_subjects(SubjectSet),
    maplist(checklist_cited, SubjectSet).
test(an_unread_key_never_changes_the_answer) :-
    all_subjects(SubjectSet),
    maplist(unread_key_invariant, SubjectSet).
test(the_subject_set_is_not_empty) :-
    all_subjects([_, _|_]).

test(relief_consistency_rejects_must_comply_with_an_exception, fail) :-
    relief_consistent(must_comply, art20_3_public_task).
test(relief_consistency_rejects_a_suspension_with_an_exception, fail) :-
    relief_consistent(suspended(art12_6_identity_not_confirmed), art23_legislative_restriction).
test(conditions_table_rejects_a_missing_fee, fail) :-
    conditions_expected(art12_5_manifestly_unfounded_or_excessive, []).
test(an_uncited_item_is_rejected, fail) :-
    cited_item(item(engagement(portability), met, eu_reg_2016_679_art_20_1)).

cp_test_names([totality_every_subject_classifies, determinism_one_decision_per_subject, determinism_one_exception_per_subject, determinism_one_verdict_per_subject, every_exception_is_in_the_status_table, every_verdict_is_consistent, every_checklist_item_is_cited, an_unread_key_never_changes_the_answer, the_subject_set_is_not_empty]).
cp_test_fail_names([relief_consistency_rejects_must_comply_with_an_exception, relief_consistency_rejects_a_suspension_with_an_exception, conditions_table_rejects_a_missing_fee, an_uncited_item_is_rejected]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
