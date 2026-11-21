% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_representation_and_suspension_tests_test_properties, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(library(reif), [memberd_t/3]).
:- use_module(m__eu_data_protection_gdpr_representation_and_suspension_gdpr_representation_and_suspension, [decide_gdpr_representation_and_suspension/2, gdpr_representation_and_suspension_status_values/1]).
:- use_module(m__eu_data_protection_gdpr_representation_and_suspension_fixtures, [gdpr_representation_and_suspension_subject/1, gdpr_representation_and_suspension_profile_for/2, gdpr_representation_and_suspension_assess/2]).

subject_classifies(Subject) :-
    gdpr_representation_and_suspension_subject(Subject),
    gdpr_representation_and_suspension_assess(Subject, _Verdict).

classifies_once(Subject) :-
    findall(Verdict, gdpr_representation_and_suspension_assess(Subject, Verdict), Verdicts),
    length(Verdicts, 1).

verdict_well_formed(Subject) :-
    gdpr_representation_and_suspension_subject(Subject),
    gdpr_representation_and_suspension_assess(Subject, gdpr_representation_and_suspension_verdict(Result, Basis, Citations)),
    gdpr_representation_and_suspension_status_values(StatusValues),
    memberd_t(Result, StatusValues, IsFinal),
    shape_holds(IsFinal, Result, Basis, Citations).

shape_holds(true, _, _, [cite(_)]).
shape_holds(false, indeterminate([_]), [], []).
shape_holds(false, needs_legal_review(_, _), [], []).
shape_holds(false, input_problems([_|_]), [], []).

test(totality_every_subject_classifies) :-
    findall(Subject, gdpr_representation_and_suspension_subject(Subject), Subjects),
    sort(Subjects, SubjectSet),
    findall(Subject, subject_classifies(Subject), ClassifiedSubjects),
    sort(ClassifiedSubjects, SubjectSet).
test(determinism_every_subject_classifies_once) :-
    findall(Subject, gdpr_representation_and_suspension_subject(Subject), Subjects),
    maplist(classifies_once, Subjects).
test(every_verdict_is_well_formed) :-
    findall(Subject, gdpr_representation_and_suspension_subject(Subject), Subjects),
    sort(Subjects, SubjectSet),
    findall(Subject, verdict_well_formed(Subject), WellFormed),
    sort(WellFormed, SubjectSet).
test(a_key_the_contact_duty_does_not_read_leaves_its_answer) :-
    gdpr_representation_and_suspension_profile_for(court_contact_related, Profile),
    append(Profile, [attribute(data_subject_mandated_the_body, false)], Extended),
    decide_gdpr_representation_and_suspension(court_contact_duty(Profile), Verdict),
    decide_gdpr_representation_and_suspension(court_contact_duty(Extended), ExtendedVerdict),
    Verdict == ExtendedVerdict.
test(the_mandate_is_not_read_without_a_mandate) :-
    gdpr_representation_and_suspension_profile_for(without_mandate_complaint_provided, Profile),
    append(Profile, [attribute(data_subject_mandated_the_body, false)], Extended),
    decide_gdpr_representation_and_suspension(representation_without_mandate(Profile, lodge_complaint_under_article_77), Verdict),
    decide_gdpr_representation_and_suspension(representation_without_mandate(Extended, lodge_complaint_under_article_77), ExtendedVerdict),
    Verdict == ExtendedVerdict.
test(court_keys_are_not_read_on_a_mandate) :-
    gdpr_representation_and_suspension_profile_for(mandated_complaint_qualified, Profile),
    append(Profile, [attribute(court_is_competent_court, false)], Extended),
    decide_gdpr_representation_and_suspension(mandated_representation(Profile, lodge_complaint_under_article_77), Verdict),
    decide_gdpr_representation_and_suspension(mandated_representation(Extended, lodge_complaint_under_article_77), ExtendedVerdict),
    Verdict == ExtendedVerdict.
test(the_first_instance_is_not_read_on_suspension) :-
    gdpr_representation_and_suspension_profile_for(court_suspension_first_seized_missing, Profile),
    append(Profile, [attribute(other_proceedings_pending_at_first_instance, false)], Extended),
    decide_gdpr_representation_and_suspension(court_suspension_option(Extended), gdpr_representation_and_suspension_verdict(indeterminate([court_is_court_first_seized]), [], [])).
test(a_settled_answer_is_given_whatever_keys_are_absent) :-
    decide_gdpr_representation_and_suspension(court_declining_jurisdiction_option([attribute(court_is_court_first_seized, true)]), gdpr_representation_and_suspension_verdict(declining_jurisdiction_not_available, [], [cite(eu_reg_2016_679_art_81_3)])).

cp_test_names([totality_every_subject_classifies, determinism_every_subject_classifies_once, every_verdict_is_well_formed, a_key_the_contact_duty_does_not_read_leaves_its_answer, the_mandate_is_not_read_without_a_mandate, court_keys_are_not_read_on_a_mandate, the_first_instance_is_not_read_on_suspension, a_settled_answer_is_given_whatever_keys_are_absent]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
