% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_corrective_powers_named_tests_test_properties, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_corrective_powers_named_gdpr_corrective_powers_named, [corrective_powers_named/3, corrective_power_named/4, decide_gdpr_corrective_powers_named/2]).
:- use_module(m__eu_data_protection_gdpr_corrective_powers_named_fixtures, [gdpr_corrective_powers_named_subject/1, gdpr_corrective_powers_named_profile_for/2]).

measure_atom(warning).
measure_atom(reprimand).
measure_atom(order_to_comply_with_data_subject_requests).
measure_atom(order_to_bring_processing_into_compliance).
measure_atom(order_to_communicate_personal_data_breach).
measure_atom(limitation_or_ban_on_processing).
measure_atom(order_of_rectification_erasure_or_restriction).
measure_atom(withdrawal_or_refusal_of_certification).
measure_atom(administrative_fine).
measure_atom(suspension_of_data_flows).

subject_classifies(Subject) :-
    gdpr_corrective_powers_named_subject(Subject),
    gdpr_corrective_powers_named_profile_for(Subject, Profile),
    decide_gdpr_corrective_powers_named(Profile, _Verdict).

list_answer_count(Subject, Count) :-
    gdpr_corrective_powers_named_profile_for(Subject, Profile),
    findall(Result - Citations, corrective_powers_named(Profile, Result, Citations), Answers),
    length(Answers, Count).

point_answer_count(Subject, Measure, Count) :-
    gdpr_corrective_powers_named_profile_for(Subject, Profile),
    findall(Result - Citations, corrective_power_named(Profile, Measure, Result, Citations), Answers),
    length(Answers, Count).

citation_shape(powers_named(_Powers, authority_discretion), Citations) :-
    length(Citations, 11).
citation_shape(indeterminate(_MissingKeys), []).
citation_shape(needs_legal_review(_Reason, _Context), []).
citation_shape(input_problems(_Problems), []).

list_and_lookup_agree(Subject) :-
    gdpr_corrective_powers_named_profile_for(Subject, Profile),
    corrective_powers_named(Profile, powers_named(Powers, authority_discretion), _Citations),
    findall(power(Measure, Addressees), (measure_atom(Measure), corrective_power_named(Profile, Measure, named(Addressees, authority_discretion), _PointCitations)), Named),
    Named == Powers.

test(totality_every_subject_classifies) :-
    findall(Subject, gdpr_corrective_powers_named_subject(Subject), Subjects),
    sort(Subjects, SubjectSet),
    findall(Subject, subject_classifies(Subject), ClassifiedSubjects),
    sort(ClassifiedSubjects, SubjectSet).
test(determinism_the_list_gives_exactly_one_answer_per_subject) :-
    findall(Count, (gdpr_corrective_powers_named_subject(Subject), list_answer_count(Subject, Count)), Counts),
    length(Counts, 17),
    maplist(=(1), Counts).
test(determinism_the_lookup_gives_exactly_one_answer_per_subject_and_measure) :-
    findall(Count, (gdpr_corrective_powers_named_subject(Subject), measure_atom(Measure), point_answer_count(Subject, Measure, Count)), Counts),
    length(Counts, 170),
    maplist(=(1), Counts).
test(every_answer_has_its_citation_shape) :-
    findall(Subject, gdpr_corrective_powers_named_subject(Subject), Subjects),
    findall(Subject, (gdpr_corrective_powers_named_subject(Subject), gdpr_corrective_powers_named_profile_for(Subject, Profile), corrective_powers_named(Profile, Result, Citations), citation_shape(Result, Citations)), Shaped),
    Shaped == Subjects.
test(the_list_agrees_with_the_lookup_on_every_settled_subject) :-
    findall(Subject, (gdpr_corrective_powers_named_subject(Subject), list_and_lookup_agree(Subject)), Agreeing),
    length(Agreeing, 11).
test(an_unread_key_does_not_change_the_warning_answer) :-
    findall(Result - Citations, (member(Other, [true, false, unsure]), corrective_power_named([attribute(intended_processing_likely_to_infringe, true), attribute(processing_has_infringed, Other)], warning, Result, Citations)), Answers),
    length(Answers, 3),
    sort(Answers, [named([controller, processor], authority_discretion) - [cite(eu_reg_2016_679_art_58_2), cite(eu_reg_2016_679_art_58_2_a)]]).
test(an_absent_unread_key_does_not_change_the_fine_answer) :-
    corrective_power_named([attribute(processing_has_infringed, true)], administrative_fine, BareResult, _BareCitations),
    corrective_power_named([attribute(processing_has_infringed, true), attribute(certification_issued_or_applied_for, true)], administrative_fine, FullResult, _FullCitations),
    BareResult == FullResult.
test(a_true_settles_the_limitation_whatever_the_others_are) :-
    findall(Result, (member(Other, [true, false, unsure]), corrective_power_named([attribute(intended_processing_likely_to_infringe, Other), attribute(processing_not_in_compliance, true)], limitation_or_ban_on_processing, Result, _Citations)), Results),
    sort(Results, [named([], authority_discretion)]).
test(a_false_settles_the_certification_whatever_the_other_is) :-
    findall(Result, (member(Other, [true, false, unsure]), corrective_power_named([attribute(certification_issued_or_applied_for, false), attribute(certification_requirements_not_met, Other)], withdrawal_or_refusal_of_certification, Result, _Citations)), Results),
    sort(Results, [not_named]).

cp_test_names([totality_every_subject_classifies, determinism_the_list_gives_exactly_one_answer_per_subject, determinism_the_lookup_gives_exactly_one_answer_per_subject_and_measure, every_answer_has_its_citation_shape, the_list_agrees_with_the_lookup_on_every_settled_subject, an_unread_key_does_not_change_the_warning_answer, an_absent_unread_key_does_not_change_the_fine_answer, a_true_settles_the_limitation_whatever_the_others_are, a_false_settles_the_certification_whatever_the_other_is]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
