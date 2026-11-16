% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_information_duties_timing_tests_test_properties, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(formalize_lib, [profile_get/3]).
:- use_module(m__eu_data_protection_gdpr_information_duties_timing_kernel, [gdpr_information_duties_timing_date_order/3]).
:- use_module(m__eu_data_protection_gdpr_information_duties_timing_information_deadline_basis, [information_deadline/2, information_deadline_basis/2, information_deadline_basis_status_values/1]).
:- use_module(m__eu_data_protection_gdpr_information_duties_timing_information_timing_verdict, [information_timing_verdict/3]).
:- use_module(m__eu_data_protection_gdpr_information_duties_timing_fixtures, [gdpr_information_duties_timing_subject/1, gdpr_information_duties_timing_profile_for/2]).

subject_classifies(Subject) :-
    gdpr_information_duties_timing_subject(Subject),
    gdpr_information_duties_timing_profile_for(Subject, Profile),
    information_timing_verdict(Profile, _Verdict, _Citations).

answer_counts(Subject, VerdictCount, DeadlineCount, BasisCount) :-
    gdpr_information_duties_timing_profile_for(Subject, Profile),
    findall(Verdict - Citations, information_timing_verdict(Profile, Verdict, Citations), Verdicts),
    length(Verdicts, VerdictCount),
    findall(Deadline, information_deadline(Profile, Deadline), Deadlines),
    length(Deadlines, DeadlineCount),
    findall(Basis, information_deadline_basis(Profile, Basis), Bases),
    length(Bases, BasisCount).

canonical_citation(cite(eu_reg_2016_679_art_13_1)).
canonical_citation(cite(eu_reg_2016_679_art_14_3_a)).
canonical_citation(cite(eu_reg_2016_679_art_14_3_b)).
canonical_citation(cite(eu_reg_2016_679_art_14_3_c)).

verdict_cites_consistent(timely, [Citation]) :-
    canonical_citation(Citation).
verdict_cites_consistent(late, [Citation]) :-
    canonical_citation(Citation).
verdict_cites_consistent(indeterminate([_|_]), []).
verdict_cites_consistent(needs_legal_review(open_textured(_, cite(_)), [inputs_relied_on(_)|_]), []).
verdict_cites_consistent(input_problems([_|_]), []).

deadline_well_formed(date(Year, Month, DayNumber)) :-
    integer(Year),
    integer(Month),
    integer(DayNumber).
deadline_well_formed(indeterminate([_|_])).
deadline_well_formed(input_problems([_|_])).

basis_well_formed(Basis) :-
    information_deadline_basis_status_values(BasisValues),
    member(Basis, BasisValues).
basis_well_formed(indeterminate([_|_])).
basis_well_formed(input_problems([_|_])).

subject_consistent(Subject) :-
    gdpr_information_duties_timing_profile_for(Subject, Profile),
    information_timing_verdict(Profile, Verdict, Citations),
    verdict_cites_consistent(Verdict, Citations),
    information_deadline(Profile, Deadline),
    deadline_well_formed(Deadline),
    information_deadline_basis(Profile, Basis),
    basis_well_formed(Basis).

unread_key_is_inert(Subject) :-
    gdpr_information_duties_timing_profile_for(Subject, Profile),
    information_timing_verdict(Profile, Verdict, Citations),
    append(Profile, [attribute(items_data_subject_already_has, [source_of_personal_data])], ExtendedProfile),
    information_timing_verdict(ExtendedProfile, Verdict, Citations).

timely_subject(Subject) :-
    gdpr_information_duties_timing_profile_for(Subject, Profile),
    information_timing_verdict(Profile, timely, _Citations).

timely_within_deadline(Subject) :-
    gdpr_information_duties_timing_profile_for(Subject, Profile),
    information_timing_verdict(Profile, timely, _Citations),
    information_deadline(Profile, Deadline),
    profile_get(Profile, provision_date, ProvisionDate),
    gdpr_information_duties_timing_date_order(ProvisionDate, Deadline, Order),
    on_or_before(Order).

on_or_before(before).
on_or_before(same).

test(totality_every_subject_classifies) :-
    findall(Subject, gdpr_information_duties_timing_subject(Subject), Subjects),
    sort(Subjects, SubjectSet),
    findall(Subject, subject_classifies(Subject), ClassifiedSubjects),
    sort(ClassifiedSubjects, SubjectSet).
test(determinism_every_relation_has_exactly_one_answer_per_subject) :-
    findall(Subject - 1 - 1 - 1, gdpr_information_duties_timing_subject(Subject), Expected),
    findall(Subject - VerdictCount - DeadlineCount - BasisCount, (gdpr_information_duties_timing_subject(Subject), answer_counts(Subject, VerdictCount, DeadlineCount, BasisCount)), Actual),
    Actual == Expected.
test(every_answer_is_well_formed_and_consistently_cited) :-
    findall(Subject, gdpr_information_duties_timing_subject(Subject), Subjects),
    findall(Subject, (gdpr_information_duties_timing_subject(Subject), subject_consistent(Subject)), ConsistentSubjects),
    ConsistentSubjects == Subjects.
test(an_unread_key_never_changes_the_verdict) :-
    findall(Subject, gdpr_information_duties_timing_subject(Subject), Subjects),
    findall(Subject, (gdpr_information_duties_timing_subject(Subject), unread_key_is_inert(Subject)), InertSubjects),
    InertSubjects == Subjects.
test(timely_means_provided_on_or_before_the_deadline) :-
    findall(Subject, (gdpr_information_duties_timing_subject(Subject), timely_subject(Subject)), TimelySubjects),
    TimelySubjects = [_|_],
    findall(Subject, (gdpr_information_duties_timing_subject(Subject), timely_within_deadline(Subject)), WithinSubjects),
    WithinSubjects == TimelySubjects.
test(consistency_accepts_a_cited_late) :-
    verdict_cites_consistent(late, [cite(eu_reg_2016_679_art_14_3_c)]).

test(consistency_rejects_a_cited_indeterminate, fail) :-
    verdict_cites_consistent(indeterminate([obtaining_date]), [cite(eu_reg_2016_679_art_13_1)]).
test(consistency_rejects_an_uncited_timely, fail) :-
    verdict_cites_consistent(timely, []).
test(consistency_rejects_a_shortened_citation, fail) :-
    verdict_cites_consistent(late, [cite(art_13_1)]).

cp_test_names([totality_every_subject_classifies, determinism_every_relation_has_exactly_one_answer_per_subject, every_answer_is_well_formed_and_consistently_cited, an_unread_key_never_changes_the_verdict, timely_means_provided_on_or_before_the_deadline, consistency_accepts_a_cited_late]).
cp_test_fail_names([consistency_rejects_a_cited_indeterminate, consistency_rejects_an_uncited_timely, consistency_rejects_a_shortened_citation]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
