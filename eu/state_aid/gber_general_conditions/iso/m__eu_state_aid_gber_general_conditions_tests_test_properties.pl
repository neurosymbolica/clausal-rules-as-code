% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_state_aid_gber_general_conditions_tests_test_properties, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_lists_extra, [clausal_is_list/1]).
:- use_module(library(clpz)).
:- use_module(m__eu_state_aid_gber_general_conditions_gber_general_conditions, [decide_gber_general_conditions/2, gber_general_conditions_checklist/2, gber_general_conditions_status_values/1, gber_notification_threshold/4, gber_cumulation/7]).
:- use_module(m__eu_state_aid_gber_general_conditions_fixtures, [gber_general_conditions_subject/1, gber_general_conditions_profile_for/2]).

subject_classifies(Subject) :-
    gber_general_conditions_subject(Subject),
    gber_general_conditions_profile_for(Subject, SubjectCase),
    decide_gber_general_conditions(SubjectCase, _Verdict).

subject_decides_exactly_once(Subject) :-
    gber_general_conditions_profile_for(Subject, SubjectCase),
    findall(Verdict, decide_gber_general_conditions(SubjectCase, Verdict), Verdicts),
    length(Verdicts, 1).

subject_checklist_exactly_once(Subject) :-
    gber_general_conditions_profile_for(Subject, SubjectCase),
    findall(Checklist, gber_general_conditions_checklist(SubjectCase, Checklist), Checklists),
    length(Checklists, 1).

subject_checklist_has_five_items(Subject) :-
    gber_general_conditions_profile_for(Subject, SubjectCase),
    gber_general_conditions_checklist(SubjectCase, Checklist),
    length(Checklist, 5).

subject_verdict_well_formed(Subject) :-
    gber_general_conditions_profile_for(Subject, SubjectCase),
    decide_gber_general_conditions(SubjectCase, Verdict),
    verdict_well_formed(Verdict).

final_status(Status) :-
    gber_general_conditions_status_values(StatusValues),
    member(Status, StatusValues).

verdict_well_formed(gber_general_conditions_verdict(Status, [Citation|Citations])) :-
    final_status(Status),
    maplist(citation_term, [Citation|Citations]),
    citations_are_a_set([Citation|Citations]).
verdict_well_formed(gber_general_conditions_verdict(indeterminate([MissingKey]), [])) :-
    atom(MissingKey).
verdict_well_formed(gber_general_conditions_verdict(needs_legal_review(open_textured(InputKey, cite(CitationKey)), [inputs_relied_on(Pairs)]), [])) :-
    atom(InputKey),
    atom(CitationKey),
    clausal_is_list(Pairs).
verdict_well_formed(gber_general_conditions_verdict(input_problems([_|_]), [])).

citation_term(cite(CitationKey)) :-
    atom(CitationKey).

citations_are_a_set(Citations) :-
    sort(Citations, Sorted),
    length(Citations, Count),
    length(Sorted, Count).

all_subjects(Subjects) :-
    findall(Subject, gber_general_conditions_subject(Subject), Subjects).

test(totality_every_subject_classifies) :-
    all_subjects(Subjects),
    sort(Subjects, SubjectSet),
    findall(Subject, subject_classifies(Subject), ClassifiedSubjects),
    sort(ClassifiedSubjects, SubjectSet).
test(determinism_every_subject_decides_exactly_once) :-
    all_subjects(Subjects),
    maplist(subject_decides_exactly_once, Subjects).
test(determinism_every_checklist_is_unique) :-
    all_subjects(Subjects),
    maplist(subject_checklist_exactly_once, Subjects).
test(every_checklist_has_the_five_tests) :-
    all_subjects(Subjects),
    maplist(subject_checklist_has_five_items, Subjects).
test(every_verdict_is_well_formed) :-
    all_subjects(Subjects),
    maplist(subject_verdict_well_formed, Subjects).
test(the_status_table_has_three_distinct_atoms) :-
    gber_general_conditions_status_values(StatusValues),
    sort(StatusValues, Sorted),
    length(Sorted, 3).
test(the_threshold_is_within_up_to_the_figure) :-
    maplist(within_at, [0, 1, 412500000, 824999999, 825000000]).
test(the_threshold_is_exceeded_above_the_figure) :-
    maplist(exceeded_at, [825000001, 900000000, 100000000000]).
test(the_cumulation_is_allowed_up_to_the_intensity) :-
    maplist(allowed_at, [0, 1, 199999999, 200000000]).
test(the_cumulation_is_not_allowed_above_the_intensity) :-
    maplist(not_allowed_at, [200000001, 300000000]).
test(the_cumulation_answers_once_at_every_point) :-
    findall(Result, cumulation_result_at(200000000, Result), Results),
    length(Results, 1).

threshold_result_at(ProjectAidCents, Result) :-
    gber_notification_threshold([attribute(article_4_category, sme_investment)], ProjectAidCents, Result, _).

within_at(ProjectAidCents) :-
    threshold_result_at(ProjectAidCents, within_threshold).

exceeded_at(ProjectAidCents) :-
    threshold_result_at(ProjectAidCents, threshold_exceeded).

cumulation_result_at(SameCostsDeMinimisCents, Result) :-
    gber_cumulation([attribute(identifiable_eligible_costs, true)], 2000000000, 800000000, SameCostsDeMinimisCents, 5000, Result, _).

allowed_at(SameCostsDeMinimisCents) :-
    cumulation_result_at(SameCostsDeMinimisCents, cumulation_allowed).

not_allowed_at(SameCostsDeMinimisCents) :-
    cumulation_result_at(SameCostsDeMinimisCents, cumulation_not_allowed).

cp_test_names([totality_every_subject_classifies, determinism_every_subject_decides_exactly_once, determinism_every_checklist_is_unique, every_checklist_has_the_five_tests, every_verdict_is_well_formed, the_status_table_has_three_distinct_atoms, the_threshold_is_within_up_to_the_figure, the_threshold_is_exceeded_above_the_figure, the_cumulation_is_allowed_up_to_the_intensity, the_cumulation_is_not_allowed_above_the_intensity, the_cumulation_answers_once_at_every_point]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
