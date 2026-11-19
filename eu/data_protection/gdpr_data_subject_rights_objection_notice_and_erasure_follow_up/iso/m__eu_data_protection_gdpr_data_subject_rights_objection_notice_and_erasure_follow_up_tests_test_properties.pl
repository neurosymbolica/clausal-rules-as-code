% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_data_subject_rights_objection_notice_and_erasure_follow_up_tests_test_properties, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_lists_extra, [subtract/3, clausal_is_list/1]).
:- use_module(clausal_hof, [include/3]).
:- use_module(library(reif), [memberd_t/3]).
:- use_module(m__eu_data_protection_gdpr_data_subject_rights_objection_notice_and_erasure_follow_up_gdpr_data_subject_rights_objection_notice_and_erasure_follow_up, [objection_right_notice/4, erasure_follow_up_duty/4, decide_gdpr_data_subject_rights_objection_notice_and_erasure_follow_up/2, gdpr_data_subject_rights_objection_notice_and_erasure_follow_up_status_values/1]).
:- use_module(m__eu_data_protection_gdpr_data_subject_rights_objection_notice_and_erasure_follow_up_fixtures, [gdpr_data_subject_rights_objection_notice_and_erasure_follow_up_subject/1, gdpr_data_subject_rights_objection_notice_and_erasure_follow_up_profile_for/2]).
:- use_module(m__eu_data_protection_gdpr_data_subject_rights_objection_notice_and_erasure_follow_up_kernel, [gdpr_data_subject_rights_objection_notice_and_erasure_follow_up_input_problems/2]).

all_subjects(Subjects) :-
    findall(Subject, gdpr_data_subject_rights_objection_notice_and_erasure_follow_up_subject(Subject), Subjects).

subject_classifies(Subject) :-
    gdpr_data_subject_rights_objection_notice_and_erasure_follow_up_subject(Subject),
    gdpr_data_subject_rights_objection_notice_and_erasure_follow_up_profile_for(Subject, Profile),
    decide_gdpr_data_subject_rights_objection_notice_and_erasure_follow_up(Profile, _Verdict).

subject_has_one_answer_per_query(Subject) :-
    gdpr_data_subject_rights_objection_notice_and_erasure_follow_up_profile_for(Subject, Profile),
    findall(Verdict, decide_gdpr_data_subject_rights_objection_notice_and_erasure_follow_up(Profile, Verdict), Verdicts),
    length(Verdicts, 1),
    findall(Result - Basis - Citations, objection_right_notice(Profile, Result, Basis, Citations), NoticeAnswers),
    length(NoticeAnswers, 1),
    findall(Result - Basis - Citations, erasure_follow_up_duty(Profile, Result, Basis, Citations), FollowUpAnswers),
    length(FollowUpAnswers, 1).

answer_shape(Values, Citation, Result, Basis, Citations) :-
    memberd_t(Result, Values, IsFinal),
    shape_for(IsFinal, Citation, Basis, Citations).

shape_for(true, Citation, Basis, Citations) :-
    clausal_is_list(Basis),
    Citations == [Citation].
shape_for(false, _, Basis, Citations) :-
    Basis == [],
    Citations == [].

subject_answers_well_shaped(Subject) :-
    gdpr_data_subject_rights_objection_notice_and_erasure_follow_up_profile_for(Subject, Profile),
    gdpr_data_subject_rights_objection_notice_and_erasure_follow_up_status_values(Values),
    objection_right_notice(Profile, NoticeResult, NoticeBasis, NoticeCitations),
    answer_shape(Values, cite(eu_reg_2016_679_art_21_4), NoticeResult, NoticeBasis, NoticeCitations),
    erasure_follow_up_duty(Profile, FollowUpResult, FollowUpBasis, FollowUpCitations),
    answer_shape(Values, cite(eu_reg_2016_679_art_17_2), FollowUpResult, FollowUpBasis, FollowUpCitations).

well_formed_subject(Subject) :-
    gdpr_data_subject_rights_objection_notice_and_erasure_follow_up_subject(Subject),
    gdpr_data_subject_rights_objection_notice_and_erasure_follow_up_profile_for(Subject, Profile),
    gdpr_data_subject_rights_objection_notice_and_erasure_follow_up_input_problems(Profile, []).

notice_attribute(attribute(Key, _Value)) :-
    member(Key, [right_to_object_applies, first_communication_with_data_subject_has_taken_place, right_explicitly_brought_to_attention_by_first_communication, right_presented_separately_from_other_information, right_presented_clearly]).

follow_up_attribute(attribute(Key, _Value)) :-
    member(Key, [controller_made_personal_data_public, controller_obliged_to_erase_under_article_17_1, reasonable_steps_taken_to_inform_other_controllers]).

notice_independent_of_follow_up_keys(Subject) :-
    gdpr_data_subject_rights_objection_notice_and_erasure_follow_up_profile_for(Subject, Profile),
    include(notice_attribute, Profile, NoticeOnly),
    findall(Result - Basis - Citations, objection_right_notice(Profile, Result, Basis, Citations), FullAnswers),
    findall(Result - Basis - Citations, objection_right_notice(NoticeOnly, Result, Basis, Citations), ReducedAnswers),
    FullAnswers == ReducedAnswers.

follow_up_independent_of_notice_keys(Subject) :-
    gdpr_data_subject_rights_objection_notice_and_erasure_follow_up_profile_for(Subject, Profile),
    include(follow_up_attribute, Profile, FollowUpOnly),
    findall(Result - Basis - Citations, erasure_follow_up_duty(Profile, Result, Basis, Citations), FullAnswers),
    findall(Result - Basis - Citations, erasure_follow_up_duty(FollowUpOnly, Result, Basis, Citations), ReducedAnswers),
    FullAnswers == ReducedAnswers.

test(totality_every_subject_classifies) :-
    all_subjects(Subjects),
    sort(Subjects, SubjectSet),
    findall(Subject, subject_classifies(Subject), ClassifiedSubjects),
    sort(ClassifiedSubjects, SubjectSet).
test(determinism_every_subject_yields_one_answer_per_query) :-
    all_subjects(Subjects),
    maplist(subject_has_one_answer_per_query, Subjects).
test(every_answer_has_the_contract_shape) :-
    all_subjects(Subjects),
    maplist(subject_answers_well_shaped, Subjects).
test(the_notice_answer_ignores_follow_up_keys) :-
    findall(Subject, well_formed_subject(Subject), Subjects),
    Subjects = [_|_],
    maplist(notice_independent_of_follow_up_keys, Subjects).
test(the_follow_up_answer_ignores_notice_keys) :-
    findall(Subject, well_formed_subject(Subject), Subjects),
    Subjects = [_|_],
    maplist(follow_up_independent_of_notice_keys, Subjects).
test(every_final_atom_is_reached_by_some_fixture) :-
    gdpr_data_subject_rights_objection_notice_and_erasure_follow_up_status_values(Values),
    all_subjects(Subjects),
    findall(Result, (member(Subject, Subjects), gdpr_data_subject_rights_objection_notice_and_erasure_follow_up_profile_for(Subject, Profile), objection_right_notice(Profile, Result, _NoticeBasis, _NoticeCitations)), NoticeResults),
    findall(Result, (member(Subject, Subjects), gdpr_data_subject_rights_objection_notice_and_erasure_follow_up_profile_for(Subject, Profile), erasure_follow_up_duty(Profile, Result, _FollowUpBasis, _FollowUpCitations)), FollowUpResults),
    append(NoticeResults, FollowUpResults, AllResults),
    subtract(Values, AllResults, Unreached),
    Unreached == [].

cp_test_names([totality_every_subject_classifies, determinism_every_subject_yields_one_answer_per_query, every_answer_has_the_contract_shape, the_notice_answer_ignores_follow_up_keys, the_follow_up_answer_ignores_notice_keys, every_final_atom_is_reached_by_some_fixture]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
