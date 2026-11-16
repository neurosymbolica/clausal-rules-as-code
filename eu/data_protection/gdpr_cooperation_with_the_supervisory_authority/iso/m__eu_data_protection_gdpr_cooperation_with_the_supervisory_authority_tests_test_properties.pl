% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_cooperation_with_the_supervisory_authority_tests_test_properties, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_cooperation_with_the_supervisory_authority_gdpr_cooperation_with_the_supervisory_authority, [cooperation_duty/4, decide_gdpr_cooperation_with_the_supervisory_authority/2, gdpr_cooperation_with_the_supervisory_authority_checklist/2, gdpr_cooperation_with_the_supervisory_authority_status_values/1]).
:- use_module(m__eu_data_protection_gdpr_cooperation_with_the_supervisory_authority_fixtures, [gdpr_cooperation_with_the_supervisory_authority_subject/1, gdpr_cooperation_with_the_supervisory_authority_profile_for/2]).

subject_classifies(Subject) :-
    gdpr_cooperation_with_the_supervisory_authority_subject(Subject),
    gdpr_cooperation_with_the_supervisory_authority_profile_for(Subject, Profile),
    decide_gdpr_cooperation_with_the_supervisory_authority(Profile, _Verdict).

subject_answers_once(Subject) :-
    gdpr_cooperation_with_the_supervisory_authority_profile_for(Subject, Profile),
    findall(Result - Basis - Citations, cooperation_duty(Profile, Result, Basis, Citations), Answers),
    length(Answers, 1).

subject_answer_well_formed(Subject) :-
    gdpr_cooperation_with_the_supervisory_authority_profile_for(Subject, Profile),
    cooperation_duty(Profile, Result, Basis, Citations),
    answer_well_formed(Result, Basis, Citations).

answer_well_formed(cooperation_not_required, [], [cite(eu_reg_2016_679_art_31)]).
answer_well_formed(cooperation_met, [outside_fact(cooperation_given, attested(true, _))], [cite(eu_reg_2016_679_art_31)]).
answer_well_formed(cooperation_not_met, [outside_fact(cooperation_given, attested(false, _))], [cite(eu_reg_2016_679_art_31)]).
answer_well_formed(indeterminate([Key]), [], []) :-
    atom(Key).
answer_well_formed(needs_legal_review(open_textured(request_is_in_performance_of_authority_tasks, cite(eu_reg_2016_679_art_31)), [inputs_relied_on(_)]), [], []).
answer_well_formed(needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_31), cite(cooperation_statement)), [resolution(cite(cooperation_statement), not_attempted), inputs_relied_on(_)]), [], []).
answer_well_formed(input_problems([_|_]), [], []).

subject_checklist_cited(Subject) :-
    gdpr_cooperation_with_the_supervisory_authority_profile_for(Subject, Profile),
    gdpr_cooperation_with_the_supervisory_authority_checklist(Profile, [Item|Items]),
    maplist(item_cited, [Item|Items]).

item_cited(item(_, _, cite(eu_reg_2016_679_art_31))).

test(totality_every_subject_classifies) :-
    findall(Subject, gdpr_cooperation_with_the_supervisory_authority_subject(Subject), Subjects),
    sort(Subjects, SubjectSet),
    findall(Subject, subject_classifies(Subject), ClassifiedSubjects),
    sort(ClassifiedSubjects, SubjectSet).
test(determinism_every_subject_answers_once) :-
    findall(Subject, gdpr_cooperation_with_the_supervisory_authority_subject(Subject), Subjects),
    maplist(subject_answers_once, Subjects).
test(every_answer_has_the_order_shape) :-
    findall(Subject, gdpr_cooperation_with_the_supervisory_authority_subject(Subject), Subjects),
    maplist(subject_answer_well_formed, Subjects).
test(every_checklist_item_is_cited) :-
    findall(Subject, gdpr_cooperation_with_the_supervisory_authority_subject(Subject), Subjects),
    maplist(subject_checklist_cited, Subjects).
test(the_final_vocabulary_is_three_atoms) :-
    gdpr_cooperation_with_the_supervisory_authority_status_values(Values),
    Values == [cooperation_not_required, cooperation_met, cooperation_not_met].
test(no_request_ignores_the_statement) :-
    cooperation_duty([attribute(acts_as_controller, true), attribute(authority_request_made, false), attribute(cooperation_given, attested(false, attestation(by, at, reason, none)))], Result, _, _),
    Result == cooperation_not_required.

test(a_final_answer_without_citation_is_malformed, fail) :-
    answer_well_formed(cooperation_met, [outside_fact(cooperation_given, attested(true, none))], []).

cp_test_names([totality_every_subject_classifies, determinism_every_subject_answers_once, every_answer_has_the_order_shape, every_checklist_item_is_cited, the_final_vocabulary_is_three_atoms, no_request_ignores_the_statement]).
cp_test_fail_names([a_final_answer_without_citation_is_malformed]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
