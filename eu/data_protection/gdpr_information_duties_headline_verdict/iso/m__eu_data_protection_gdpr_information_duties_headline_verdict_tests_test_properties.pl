% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_information_duties_headline_verdict_tests_test_properties, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_information_duties_headline_verdict_information_duty_verdict, [information_duty_verdict/3]).
:- use_module(m__eu_data_protection_gdpr_information_duties_headline_verdict_information_duty_exemption, [information_duty_exemption/2]).
:- use_module(m__eu_data_protection_gdpr_information_duties_headline_verdict_fixtures, [gdpr_information_duties_headline_verdict_subject/1, gdpr_information_duties_headline_verdict_profile_for/2]).

exactly_one_verdict(Subject) :-
    gdpr_information_duties_headline_verdict_subject(Subject),
    gdpr_information_duties_headline_verdict_profile_for(Subject, Profile),
    findall(Verdict - Citations, information_duty_verdict(Profile, Verdict, Citations), Answers),
    length(Answers, 1).

exactly_one_exemption(Subject) :-
    gdpr_information_duties_headline_verdict_subject(Subject),
    gdpr_information_duties_headline_verdict_profile_for(Subject, Profile),
    findall(Exemption, information_duty_exemption(Profile, Exemption), Answers),
    length(Answers, 1).

subject_set(SubjectSet) :-
    findall(Subject, gdpr_information_duties_headline_verdict_subject(Subject), Subjects),
    sort(Subjects, SubjectSet).

test(totality_and_determinism_of_the_headline) :-
    subject_set(SubjectSet),
    findall(Subject, exactly_one_verdict(Subject), Counted),
    sort(Counted, SubjectSet).
test(totality_and_determinism_of_the_exemption) :-
    subject_set(SubjectSet),
    findall(Subject, exactly_one_exemption(Subject), Counted),
    sort(Counted, SubjectSet).
test(subject_registry_has_no_duplicates) :-
    findall(Subject, gdpr_information_duties_headline_verdict_subject(Subject), Subjects),
    sort(Subjects, SubjectSet),
    length(Subjects, Count),
    length(SubjectSet, Count).
test(input_problems_carry_no_citation) :-
    gdpr_information_duties_headline_verdict_profile_for(input_unknown_key, Profile),
    information_duty_verdict(Profile, input_problems(_), Citations),
    Citations == [].
test(ineligible_carries_a_citation) :-
    gdpr_information_duties_headline_verdict_profile_for(art14_one_day_late, Profile),
    information_duty_verdict(Profile, ineligible, [_First|_Others]).
test(eligible_carries_a_citation) :-
    gdpr_information_duties_headline_verdict_profile_for(art14_secrecy_exemption, Profile),
    information_duty_verdict(Profile, eligible, [_First|_Others]).
test(a_key_no_stage_reads_does_not_change_the_answer) :-
    gdpr_information_duties_headline_verdict_profile_for(art13_on_time, Profile),
    information_duty_verdict([attribute(protective_measures_taken, true)|Profile], eligible, [cite(eu_reg_2016_679_art_13_1)]).

cp_test_names([totality_and_determinism_of_the_headline, totality_and_determinism_of_the_exemption, subject_registry_has_no_duplicates, input_problems_carry_no_citation, ineligible_carries_a_citation, eligible_carries_a_citation, a_key_no_stage_reads_does_not_change_the_answer]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
