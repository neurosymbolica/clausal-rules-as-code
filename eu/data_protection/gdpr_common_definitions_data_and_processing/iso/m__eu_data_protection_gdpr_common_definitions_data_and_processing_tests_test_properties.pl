% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_common_definitions_data_and_processing_tests_test_properties, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_common_definitions_data_and_processing_gdpr_common_definitions_data_and_processing, [decide_gdpr_common_definitions_data_and_processing/2, gdpr_common_definitions_data_and_processing_status_values/1, personal_data/2, processing/2, restriction_of_processing/2, profiling/2, pseudonymisation/2, filing_system/2, receiving_body_is_recipient/2, receiving_body_is_third_party/2, consent_elements/2, personal_data_breach/2, information_society_service/2, international_organisation/2]).
:- use_module(m__eu_data_protection_gdpr_common_definitions_data_and_processing_fixtures, [gdpr_common_definitions_data_and_processing_subject/1, gdpr_common_definitions_data_and_processing_profile_for/2]).
:- use_module(formalize_lib, [not_member/2]).

relation_answer(personal_data, Profile, Answer) :-
    personal_data(Profile, Answer).
relation_answer(processing, Profile, Answer) :-
    processing(Profile, Answer).
relation_answer(restriction_of_processing, Profile, Answer) :-
    restriction_of_processing(Profile, Answer).
relation_answer(profiling, Profile, Answer) :-
    profiling(Profile, Answer).
relation_answer(pseudonymisation, Profile, Answer) :-
    pseudonymisation(Profile, Answer).
relation_answer(filing_system, Profile, Answer) :-
    filing_system(Profile, Answer).
relation_answer(receiving_body_is_recipient, Profile, Answer) :-
    receiving_body_is_recipient(Profile, Answer).
relation_answer(receiving_body_is_third_party, Profile, Answer) :-
    receiving_body_is_third_party(Profile, Answer).
relation_answer(consent_elements, Profile, Answer) :-
    consent_elements(Profile, Answer).
relation_answer(personal_data_breach, Profile, Answer) :-
    personal_data_breach(Profile, Answer).
relation_answer(information_society_service, Profile, Answer) :-
    information_society_service(Profile, Answer).
relation_answer(international_organisation, Profile, Answer) :-
    international_organisation(Profile, Answer).

relation_point(personal_data, eu_reg_2016_679_art_4_1).
relation_point(processing, eu_reg_2016_679_art_4_2).
relation_point(restriction_of_processing, eu_reg_2016_679_art_4_3).
relation_point(profiling, eu_reg_2016_679_art_4_4).
relation_point(pseudonymisation, eu_reg_2016_679_art_4_5).
relation_point(filing_system, eu_reg_2016_679_art_4_6).
relation_point(receiving_body_is_recipient, eu_reg_2016_679_art_4_9).
relation_point(receiving_body_is_third_party, eu_reg_2016_679_art_4_10).
relation_point(consent_elements, eu_reg_2016_679_art_4_11).
relation_point(personal_data_breach, eu_reg_2016_679_art_4_12).
relation_point(information_society_service, eu_reg_2016_679_art_4_25).
relation_point(international_organisation, eu_reg_2016_679_art_4_26).

subject_profile(Subject, Profile) :-
    gdpr_common_definitions_data_and_processing_subject(Subject),
    gdpr_common_definitions_data_and_processing_profile_for(Subject, Profile).

answer_on_subject(Subject, RelationName, Answer) :-
    subject_profile(Subject, Profile),
    relation_point(RelationName, _),
    relation_answer(RelationName, Profile, Answer).

subject_classifies(Subject) :-
    subject_profile(Subject, Profile),
    decide_gdpr_common_definitions_data_and_processing(Profile, _Verdict).

not_exactly_one([]).
not_exactly_one([_, _|_]).

subject_without_one_verdict(Subject) :-
    subject_profile(Subject, Profile),
    findall(Verdict, decide_gdpr_common_definitions_data_and_processing(Profile, Verdict), Verdicts),
    not_exactly_one(Verdicts).

relation_without_one_answer(Subject, RelationName) :-
    subject_profile(Subject, Profile),
    relation_point(RelationName, _),
    findall(Answer, relation_answer(RelationName, Profile, Answer), Answers),
    not_exactly_one(Answers).

point_cited_status(met).
point_cited_status(not_met).
point_cited_status(indeterminate(_)).

settled_answer_with_wrong_citation(Subject, RelationName) :-
    answer_on_subject(Subject, RelationName, definition_answer(Status, _, Citations)),
    point_cited_status(Status),
    relation_point(RelationName, PointKey),
    Citations \== [cite(PointKey)].

referral_with_wrong_citation(Subject, RelationName) :-
    answer_on_subject(Subject, RelationName, definition_answer(needs_legal_review(open_textured(_, Citation), _), _, Citations)),
    Citations \== [Citation].
referral_with_wrong_citation(Subject, RelationName) :-
    answer_on_subject(Subject, RelationName, definition_answer(needs_legal_review(cross_reference_unresolved(Citation, Target), _), _, Citations)),
    Citations \== [Citation, Target].

open_status(indeterminate(_)).
open_status(needs_legal_review(_, _)).
open_status(input_problems(_)).

open_answer_with_a_ground(Subject, RelationName) :-
    answer_on_subject(Subject, RelationName, definition_answer(Status, Ground, _)),
    open_status(Status),
    Ground \== none.

input_problem_answer_with_citations(Subject, RelationName) :-
    answer_on_subject(Subject, RelationName, definition_answer(input_problems(_), _, Citations)),
    Citations \== [].

missing_keys_naming_an_outside_fact(Subject, RelationName) :-
    answer_on_subject(Subject, RelationName, definition_answer(indeterminate(MissingKeys), _, _)),
    member(MissingKey, MissingKeys),
    member(MissingKey, [service_is_information_society_service, organisation_governed_by_public_international_law]).

status_outside_the_vocabulary(Subject, RelationName) :-
    answer_on_subject(Subject, RelationName, definition_answer(Status, _, _)),
    functor(Status, StatusName, _),
    gdpr_common_definitions_data_and_processing_status_values(StatusValues),
    not_member(StatusName, StatusValues).

test(totality_every_subject_classifies) :-
    findall(Subject, gdpr_common_definitions_data_and_processing_subject(Subject), Subjects),
    sort(Subjects, SubjectSet),
    findall(Subject, subject_classifies(Subject), ClassifiedSubjects),
    sort(ClassifiedSubjects, SubjectSet).
test(some_fixture_is_met) :-
    answer_on_subject(_, _, definition_answer(met, _, _)).
test(some_fixture_is_not_met) :-
    answer_on_subject(_, _, definition_answer(not_met, _, _)).
test(some_fixture_is_indeterminate) :-
    answer_on_subject(_, _, definition_answer(indeterminate([_|_]), _, _)).
test(some_fixture_is_open_textured) :-
    answer_on_subject(_, _, definition_answer(needs_legal_review(open_textured(_, _), _), _, _)).
test(some_fixture_is_a_cross_reference) :-
    answer_on_subject(_, _, definition_answer(needs_legal_review(cross_reference_unresolved(_, _), _), _, _)).
test(some_fixture_has_input_problems) :-
    answer_on_subject(_, _, definition_answer(input_problems([_|_]), none, [])).

test(determinism_no_subject_lacks_exactly_one_verdict, fail) :-
    subject_without_one_verdict(_).
test(determinism_no_relation_lacks_exactly_one_answer, fail) :-
    relation_without_one_answer(_, _).
test(settled_answers_cite_only_the_point_answered, fail) :-
    settled_answer_with_wrong_citation(_, _).
test(referrals_cite_their_referral_row, fail) :-
    referral_with_wrong_citation(_, _).
test(input_problem_answers_carry_no_citation, fail) :-
    input_problem_answer_with_citations(_, _).
test(open_answers_carry_no_ground, fail) :-
    open_answer_with_a_ground(_, _).
test(missing_keys_never_name_an_outside_fact, fail) :-
    missing_keys_naming_an_outside_fact(_, _).
test(every_status_is_in_the_vocabulary, fail) :-
    status_outside_the_vocabulary(_, _).

cp_test_names([totality_every_subject_classifies, some_fixture_is_met, some_fixture_is_not_met, some_fixture_is_indeterminate, some_fixture_is_open_textured, some_fixture_is_a_cross_reference, some_fixture_has_input_problems]).
cp_test_fail_names([determinism_no_subject_lacks_exactly_one_verdict, determinism_no_relation_lacks_exactly_one_answer, settled_answers_cite_only_the_point_answered, referrals_cite_their_referral_row, input_problem_answers_carry_no_citation, open_answers_carry_no_ground, missing_keys_never_name_an_outside_fact, every_status_is_in_the_vocabulary]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
