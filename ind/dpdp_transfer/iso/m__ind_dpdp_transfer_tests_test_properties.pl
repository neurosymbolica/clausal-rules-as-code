% SPDX-License-Identifier: EUPL-1.2
:- module(m__ind_dpdp_transfer_tests_test_properties, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_lists_extra, [clausal_is_list/1]).
:- use_module(library(reif), [memberd_t/3]).
:- use_module(m__ind_dpdp_transfer_queries, [restriction_status/4]).
:- use_module(m__ind_dpdp_transfer_dpdp_transfer, [decide_dpdp_transfer/2, dpdp_transfer_status_values/1]).
:- use_module(m__ind_dpdp_transfer_fixtures, [dpdp_transfer_subject/1, dpdp_transfer_profile_for/2]).

all_subjects(SubjectSet) :-
    findall(Subject, dpdp_transfer_subject(Subject), Subjects),
    sort(Subjects, SubjectSet).

subject_classifies(Subject) :-
    dpdp_transfer_subject(Subject),
    dpdp_transfer_profile_for(Subject, Request),
    decide_dpdp_transfer(Request, _Verdict).

answer_count(Subject, Count) :-
    dpdp_transfer_profile_for(Subject, restriction_request(Restriction, Profile)),
    findall(Result - Citations, restriction_status(Restriction, Profile, Result, Citations), Answers),
    length(Answers, Count).

well_cited(Subject) :-
    dpdp_transfer_profile_for(Subject, restriction_request(Restriction, Profile)),
    restriction_status(Restriction, Profile, Result, Citations),
    dpdp_transfer_status_values(StatusValues),
    memberd_t(Result, StatusValues, IsFinal),
    citations_fit(IsFinal, Citations).

citations_fit(false, []).
citations_fit(true, [Citation|Citations]) :-
    all_vocabulary_citations([Citation|Citations]).

all_vocabulary_citations([]).
all_vocabulary_citations([cite(Key)|Citations]) :-
    member(Key, [in_dpdp_act_2023_s_16_1, in_dpdp_act_2023_s_16_2, in_dpdp_rules_2025_r_15, in_dpdp_rules_2025_r_1_4]),
    all_vocabulary_citations(Citations).

list_subject_of(Restriction, Subject) :-
    dpdp_transfer_subject(Subject),
    dpdp_transfer_profile_for(Subject, restriction_request(Restriction, Profile)),
    clausal_is_list(Profile).

answer_unchanged_by(Restriction, Extra, Subject) :-
    list_subject_of(Restriction, Subject),
    dpdp_transfer_profile_for(Subject, restriction_request(Restriction, Profile)),
    restriction_status(Restriction, Profile, Result, Citations),
    append(Profile, Extra, Extended),
    findall(ExtendedResult - ExtendedCitations, restriction_status(Restriction, Extended, ExtendedResult, ExtendedCitations), ExtendedAnswers),
    ExtendedAnswers == [Result - Citations].

test(totality_every_subject_classifies) :-
    all_subjects(SubjectSet),
    findall(Subject, subject_classifies(Subject), ClassifiedSubjects),
    sort(ClassifiedSubjects, SubjectSet).
test(determinism_every_subject_one_answer) :-
    all_subjects(SubjectSet),
    findall(Subject, (member(Subject, SubjectSet), answer_count(Subject, 1)), OneAnswerSubjects),
    OneAnswerSubjects == SubjectSet.
test(citation_completeness_every_subject) :-
    all_subjects(SubjectSet),
    findall(Subject, (member(Subject, SubjectSet), well_cited(Subject)), WellCited),
    WellCited == SubjectSet.
test(restricted_see_notification_only_for_notified_destination) :-
    findall(Restriction, (dpdp_transfer_subject(Subject), dpdp_transfer_profile_for(Subject, restriction_request(Restriction, Profile)), restriction_status(Restriction, Profile, restricted_see_notification, _)), Restrictions),
    sort(Restrictions, [notified_destination]).
test(requirements_apply_see_order_only_for_foreign_state_requirements) :-
    findall(Restriction, (dpdp_transfer_subject(Subject), dpdp_transfer_profile_for(Subject, restriction_request(Restriction, Profile)), restriction_status(Restriction, Profile, requirements_apply_see_order, _)), Restrictions),
    sort(Restrictions, [foreign_state_requirements]).
test(notified_destination_never_reads_the_rule_15_keys) :-
    findall(Subject, list_subject_of(notified_destination, Subject), Subjects),
    Subjects = [_|_],
    findall(Subject, answer_unchanged_by(notified_destination, [attribute(reference_date, date(2020, 1, 1)), attribute(recipient_is_foreign_state_or_its_entity, true), attribute(foreign_state_requirements_specified, false)], Subject), Unchanged),
    Unchanged == Subjects.
test(foreign_state_requirements_never_reads_the_notification) :-
    findall(Subject, list_subject_of(foreign_state_requirements, Subject), Subjects),
    Subjects = [_|_],
    findall(Subject, answer_unchanged_by(foreign_state_requirements, [attribute(destination_restricted_by_notification, unsure)], Subject), Unchanged),
    Unchanged == Subjects.
test(settled_not_in_force_survives_filling_section_16) :-
    findall(Result - Citations, restriction_status(foreign_state_requirements, [attribute(reference_date, date(2027, 5, 12)), attribute(section_16_in_force_on_reference_date, true)], Result, Citations), Answers),
    Answers == [not_in_force - [cite(in_dpdp_rules_2025_r_15), cite(in_dpdp_rules_2025_r_1_4), cite(in_dpdp_act_2023_s_16_1)]].
test(settled_not_in_force_survives_filling_reference_date) :-
    findall(Result - Citations, restriction_status(foreign_state_requirements, [attribute(section_16_in_force_on_reference_date, false), attribute(reference_date, date(2030, 1, 1))], Result, Citations), Answers),
    Answers == [not_in_force - [cite(in_dpdp_rules_2025_r_15), cite(in_dpdp_rules_2025_r_1_4), cite(in_dpdp_act_2023_s_16_1)]].

cp_test_names([totality_every_subject_classifies, determinism_every_subject_one_answer, citation_completeness_every_subject, restricted_see_notification_only_for_notified_destination, requirements_apply_see_order_only_for_foreign_state_requirements, notified_destination_never_reads_the_rule_15_keys, foreign_state_requirements_never_reads_the_notification, settled_not_in_force_survives_filling_section_16, settled_not_in_force_survives_filling_reference_date]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
