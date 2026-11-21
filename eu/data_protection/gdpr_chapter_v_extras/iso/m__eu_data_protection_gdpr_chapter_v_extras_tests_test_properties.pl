% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_chapter_v_extras_tests_test_properties, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_hof, [exclude/3]).
:- use_module(m__eu_data_protection_gdpr_chapter_v_extras_gdpr_chapter_v_extras, [second_subparagraph_duty/5, foreign_judgment_or_decision_recognition/4, onward_transfer_condition/4, decide_gdpr_chapter_v_extras/2]).
:- use_module(m__eu_data_protection_gdpr_chapter_v_extras_fixtures, [gdpr_chapter_v_extras_subject/1, gdpr_chapter_v_extras_profile_for/2]).

query_name(duty(inform_supervisory_authority)).
query_name(duty(inform_data_subject)).
query_name(duty(document_assessment_and_safeguards)).
query_name(article_48).
query_name(onward_transfer).

full_answer(Profile, duty(AskedDuty), answer(Result, Basis, Citations)) :-
    second_subparagraph_duty(Profile, AskedDuty, Result, Basis, Citations).
full_answer(Profile, article_48, answer(Result, Basis, Citations)) :-
    foreign_judgment_or_decision_recognition(Profile, Result, Basis, Citations).
full_answer(Profile, onward_transfer, answer(Result, Basis, Citations)) :-
    onward_transfer_condition(Profile, Result, Basis, Citations).

subject_query_answers(Subject - Query - Answers) :-
    gdpr_chapter_v_extras_subject(Subject),
    gdpr_chapter_v_extras_profile_for(Subject, Profile),
    query_name(Query),
    findall(Answer, full_answer(Profile, Query, Answer), Answers).

exactly_one_answer(_Subject - _Query - [_]).

answer_shape(_Subject - _Query - [Answer]) :-
    shape_ok(Answer).

shape_ok(answer(input_problems([_|_]), [], [])).
shape_ok(answer(indeterminate([_]), [], [])).
shape_ok(answer(needs_legal_review(cross_reference_unresolved(_, _), [resolution(_, not_attempted), inputs_relied_on([_ - absent])]), [], [])).
shape_ok(answer(not_a_processor_duty, [], [cite(eu_reg_2016_679_art_49_1_second_subpara)])).
shape_ok(answer(Result, [outside_fact(_, attested(_, attestation(_, _, _, _)))|_], [cite(_)])) :-
    atom(Result).

subject_classifies(Subject) :-
    gdpr_chapter_v_extras_subject(Subject),
    gdpr_chapter_v_extras_profile_for(Subject, Profile),
    decide_gdpr_chapter_v_extras(Profile, _Verdict).

test(totality_every_subject_classifies) :-
    findall(Subject, gdpr_chapter_v_extras_subject(Subject), Subjects),
    sort(Subjects, SubjectSet),
    findall(Subject, subject_classifies(Subject), ClassifiedSubjects),
    sort(ClassifiedSubjects, SubjectSet).
test(determinism_every_subject_and_query_answers_once) :-
    findall(Entry, subject_query_answers(Entry), Entries),
    Entries = [_|_],
    maplist(exactly_one_answer, Entries).
test(every_answer_has_the_contract_shape) :-
    findall(Entry, subject_query_answers(Entry), Entries),
    maplist(answer_shape, Entries).
test(unread_keys_never_change_article_48_or_onward_answers) :-
    maplist(unread_keys_leave_limbs_unchanged, [judgment_not_requiring_transfer, judgment_with_international_agreement, judgment_without_international_agreement, judgment_agreement_unstated, judgment_unstated_agreement_stated, onward_transfer_with_chapter_v_basis, onward_transfer_without_chapter_v_basis, onward_transfer_basis_unstated, transfer_not_onward, onward_status_unstated_basis_stated, empty_profile]).
test(other_duties_keys_never_change_a_duty_answer) :-
    gdpr_chapter_v_extras_profile_for(supervisory_authority_informed, Profile),
    append(Profile, [attribute(assessment_documented_in_records, false), attribute(data_subject_informed_of_transfer, false)], Extended),
    findall(Result, second_subparagraph_duty(Extended, inform_supervisory_authority, Result, _, _), Results),
    Results == [duty_met].
test(documentation_duty_does_not_read_party_role) :-
    gdpr_chapter_v_extras_profile_for(records_complete_for_processor, Profile),
    full_answer(Profile, duty(document_assessment_and_safeguards), ProcessorAnswer),
    exclude(party_role_attribute, Profile, WithoutRole),
    full_answer(WithoutRole, duty(document_assessment_and_safeguards), RolelessAnswer),
    ProcessorAnswer == RolelessAnswer.

unread_keys_leave_limbs_unchanged(Subject) :-
    gdpr_chapter_v_extras_profile_for(Subject, Profile),
    append(Profile, [attribute(party_role, processor), attribute(supervisory_authority_informed_of_transfer, false)], Extended),
    full_answer(Profile, article_48, JudgmentAnswer),
    full_answer(Extended, article_48, ExtendedJudgmentAnswer),
    JudgmentAnswer == ExtendedJudgmentAnswer,
    full_answer(Profile, onward_transfer, OnwardAnswer),
    full_answer(Extended, onward_transfer, ExtendedOnwardAnswer),
    OnwardAnswer == ExtendedOnwardAnswer.

party_role_attribute(attribute(party_role, _)).

cp_test_names([totality_every_subject_classifies, determinism_every_subject_and_query_answers_once, every_answer_has_the_contract_shape, unread_keys_never_change_article_48_or_onward_answers, other_duties_keys_never_change_a_duty_answer, documentation_duty_does_not_read_party_role]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
