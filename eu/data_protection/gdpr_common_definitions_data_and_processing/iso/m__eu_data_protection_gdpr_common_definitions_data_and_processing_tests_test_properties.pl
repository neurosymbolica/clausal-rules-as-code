% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_common_definitions_data_and_processing_tests_test_properties, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_common_definitions_data_and_processing_gdpr_common_definitions_data_and_processing, [decide_gdpr_common_definitions_data_and_processing/2, personal_data/2, processing/2, restriction_of_processing/2, profiling/2, pseudonymisation/2, filing_system/2, receiving_body_is_recipient/2, receiving_body_is_third_party/2, consent_elements/2, personal_data_breach/2, information_society_service/2, international_organisation/2]).
:- use_module(m__eu_data_protection_gdpr_common_definitions_data_and_processing_fixtures, [gdpr_common_definitions_data_and_processing_subject/1, gdpr_common_definitions_data_and_processing_profile_for/2]).

relation_name(personal_data).
relation_name(processing).
relation_name(restriction_of_processing).
relation_name(profiling).
relation_name(pseudonymisation).
relation_name(filing_system).
relation_name(receiving_body_is_recipient).
relation_name(receiving_body_is_third_party).
relation_name(consent_elements).
relation_name(personal_data_breach).
relation_name(information_society_service).
relation_name(international_organisation).

subject_classifies(Subject) :-
    gdpr_common_definitions_data_and_processing_subject(Subject),
    gdpr_common_definitions_data_and_processing_profile_for(Subject, Profile),
    decide_gdpr_common_definitions_data_and_processing(Profile, _Verdict).

single_answer(Subject - Relation) :-
    gdpr_common_definitions_data_and_processing_subject(Subject),
    gdpr_common_definitions_data_and_processing_profile_for(Subject, Profile),
    relation_name(Relation),
    findall(Answer, call(Relation, Profile, Answer), [_]).

empty_citations(Subject) :-
    gdpr_common_definitions_data_and_processing_subject(Subject),
    gdpr_common_definitions_data_and_processing_profile_for(Subject, Profile),
    relation_name(Relation),
    call(Relation, Profile, definition_answer(_, _, [])).

test(totality_every_subject_classifies) :-
    findall(Subject, gdpr_common_definitions_data_and_processing_subject(Subject), Subjects),
    sort(Subjects, SubjectSet),
    findall(Subject, subject_classifies(Subject), ClassifiedSubjects),
    sort(ClassifiedSubjects, SubjectSet).
test(determinism_every_relation_gives_exactly_one_answer_for_every_subject) :-
    findall(Subject, gdpr_common_definitions_data_and_processing_subject(Subject), Subjects),
    length(Subjects, SubjectCount),
    findall(Pair, single_answer(Pair), Pairs),
    length(Pairs, PairCount),
    PairCount =:= SubjectCount * 12.
test(every_answer_is_cited_except_input_problems) :-
    findall(Subject, empty_citations(Subject), Subjects),
    sort(Subjects, [malformed_profile]).
test(an_unread_key_does_not_change_the_answer) :-
    gdpr_common_definitions_data_and_processing_profile_for(person_identified, Profile),
    append(Profile, [attribute(indication_freely_given, false), attribute(breach_of_security, unsure)], Widened),
    personal_data(Profile, Answer),
    personal_data(Widened, Answer).
test(an_unread_outside_fact_does_not_change_personal_data) :-
    gdpr_common_definitions_data_and_processing_profile_for(person_identified, Profile),
    gdpr_common_definitions_data_and_processing_profile_for(attested_service, ServiceProfile),
    append(Profile, ServiceProfile, Widened),
    personal_data(Profile, Answer),
    personal_data(Widened, Answer).

test(absent_is_not_false_for_processing, fail) :-
    gdpr_common_definitions_data_and_processing_profile_for(operation_missing, Profile),
    processing(Profile, definition_answer(not_met, _, _)).

cp_test_names([totality_every_subject_classifies, determinism_every_relation_gives_exactly_one_answer_for_every_subject, every_answer_is_cited_except_input_problems, an_unread_key_does_not_change_the_answer, an_unread_outside_fact_does_not_change_personal_data]).
cp_test_fail_names([absent_is_not_false_for_processing]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
