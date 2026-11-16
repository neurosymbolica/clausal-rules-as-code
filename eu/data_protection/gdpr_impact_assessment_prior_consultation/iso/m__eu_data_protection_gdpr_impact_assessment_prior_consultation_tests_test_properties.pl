% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_impact_assessment_prior_consultation_tests_test_properties, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_impact_assessment_prior_consultation_prior_consultation_duty, [decide_prior_consultation_duty/2]).
:- use_module(m__eu_data_protection_gdpr_impact_assessment_prior_consultation_queries, [decide_prior_consultation/2, prior_consultation_duty/2, impact_assessment_outside_facts/2]).
:- use_module(m__eu_data_protection_gdpr_impact_assessment_prior_consultation_fixtures, [gdpr_impact_assessment_prior_consultation_subject/1, gdpr_impact_assessment_prior_consultation_profile_for/2]).

subject_classifies(Subject) :-
    gdpr_impact_assessment_prior_consultation_subject(Subject),
    gdpr_impact_assessment_prior_consultation_profile_for(Subject, Profile),
    decide_prior_consultation_duty(Profile, _Verdict).

registered_subjects(SubjectSet) :-
    findall(Subject, gdpr_impact_assessment_prior_consultation_subject(Subject), Subjects),
    sort(Subjects, SubjectSet).

answer_counts(Subject, Subject - counts(VerdictCount, StatusCount, FactListCount)) :-
    gdpr_impact_assessment_prior_consultation_profile_for(Subject, Profile),
    findall(Verdict, decide_prior_consultation(Profile, Verdict), Verdicts),
    length(Verdicts, VerdictCount),
    findall(Status, prior_consultation_duty(Profile, Status), Statuses),
    length(Statuses, StatusCount),
    findall(OutsideFacts, impact_assessment_outside_facts(Profile, OutsideFacts), FactLists),
    length(FactLists, FactListCount).

exactly_one_each(_ - counts(1, 1, 1)).

subject_verdict(Subject, Verdict) :-
    gdpr_impact_assessment_prior_consultation_profile_for(Subject, Profile),
    decide_prior_consultation(Profile, Verdict).

verdict_shape_holds(prior_consultation_verdict(required, [_], [_|_], [_])).
verdict_shape_holds(prior_consultation_verdict(not_required, [_], [_|_], [_])).
verdict_shape_holds(prior_consultation_verdict(indeterminate([_|_]), [], [], [])).
verdict_shape_holds(prior_consultation_verdict(needs_legal_review(_, _), [], [], [])).
verdict_shape_holds(prior_consultation_verdict(input_problems([_|_]), [], [], [])).

allowed_citation(cite(eu_reg_2016_679_art_36_1)).
allowed_citation(cite(eu_reg_2016_679_art_36_5)).

verdict_citations_allowed(prior_consultation_verdict(_, _, _, Citations)) :-
    maplist(allowed_citation, Citations).

status_agrees(Subject) :-
    gdpr_impact_assessment_prior_consultation_profile_for(Subject, Profile),
    decide_prior_consultation(Profile, prior_consultation_verdict(VerdictStatus, _, _, _)),
    prior_consultation_duty(Profile, DutyStatus),
    VerdictStatus == DutyStatus.

unread_keys_change_nothing(Subject) :-
    gdpr_impact_assessment_prior_consultation_profile_for(Subject, Profile),
    append(Profile, [attribute(datasets_matched_or_combined, unsure), attribute(processing_prevents_exercise_of_right_or_service, true), attribute(national_list_exempts_item, attested(national_list_item(fr_cnil, fr_cnil_35_5_list), attestation(by, at, reason, none)))], ExtendedProfile),
    decide_prior_consultation(Profile, Verdict),
    decide_prior_consultation(ExtendedProfile, ExtendedVerdict),
    Verdict == ExtendedVerdict.

test(totality_every_subject_classifies) :-
    registered_subjects(SubjectSet),
    findall(Subject, subject_classifies(Subject), ClassifiedSubjects),
    sort(ClassifiedSubjects, SubjectSet).
test(the_registry_names_each_subject_once) :-
    findall(Subject, gdpr_impact_assessment_prior_consultation_subject(Subject), Subjects),
    registered_subjects(SubjectSet),
    length(Subjects, SubjectCount),
    length(SubjectSet, SubjectCount).
test(determinism_every_query_answers_exactly_once) :-
    registered_subjects(SubjectSet),
    maplist(answer_counts, SubjectSet, CountPairs),
    maplist(exactly_one_each, CountPairs).
test(every_verdict_has_the_shape_of_its_status) :-
    findall(Verdict, subject_verdict(_, Verdict), Verdicts),
    maplist(verdict_shape_holds, Verdicts).
test(only_the_order_citations_are_returned) :-
    findall(Verdict, subject_verdict(_, Verdict), Verdicts),
    maplist(verdict_citations_allowed, Verdicts).
test(the_status_relation_agrees_with_the_verdict) :-
    registered_subjects(SubjectSet),
    maplist(status_agrees, SubjectSet).
test(keys_entry_b_never_reads_change_no_answer) :-
    registered_subjects(SubjectSet),
    maplist(unread_keys_change_nothing, SubjectSet).

test(a_shape_falsifier_is_rejected, fail) :-
    verdict_shape_holds(prior_consultation_verdict(required, [], [], [])).
test(a_citation_falsifier_is_rejected, fail) :-
    verdict_citations_allowed(prior_consultation_verdict(required, [art36_1_residual_high_risk], [], [cite(eu_reg_2016_679_art_35_1)])).

cp_test_names([totality_every_subject_classifies, the_registry_names_each_subject_once, determinism_every_query_answers_exactly_once, every_verdict_has_the_shape_of_its_status, only_the_order_citations_are_returned, the_status_relation_agrees_with_the_verdict, keys_entry_b_never_reads_change_no_answer]).
cp_test_fail_names([a_shape_falsifier_is_rejected, a_citation_falsifier_is_rejected]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
