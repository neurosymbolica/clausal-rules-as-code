% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_nis2_lex_specialis_and_definitions_tests_test_properties, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_nis2_lex_specialis_and_definitions_nis2_lex_specialis_and_definitions, [nis2_risk_management_provisions_status/3, nis2_incident_notification_provisions_status/3, decide_nis2_lex_specialis_and_definitions/2, nis2_lex_specialis_and_definitions_status/2]).
:- use_module(m__eu_nis2_lex_specialis_and_definitions_queries, [nis2_lex_specialis_and_definitions_what_if/4]).
:- use_module(m__eu_nis2_lex_specialis_and_definitions_fixtures, [nis2_lex_specialis_and_definitions_subject/1, nis2_lex_specialis_and_definitions_profile_for/2]).

risk_citations([cite(eu_dir_2022_2555_art_4_1), cite(eu_dir_2022_2555_art_4_2), cite(eu_dir_2022_2555_art_4_2_a), cite(eu_reg_2022_2554_art_1_2)]).

notification_citations([cite(eu_dir_2022_2555_art_4_1), cite(eu_dir_2022_2555_art_4_2), cite(eu_dir_2022_2555_art_4_2_b), cite(eu_reg_2022_2554_art_1_2)]).

subject_classifies(Subject) :-
    nis2_lex_specialis_and_definitions_subject(Subject),
    nis2_lex_specialis_and_definitions_profile_for(Subject, Profile),
    decide_nis2_lex_specialis_and_definitions(Profile, _Verdict).

test(totality_every_subject_classifies) :-
    findall(Subject, nis2_lex_specialis_and_definitions_subject(Subject), Subjects),
    sort(Subjects, SubjectSet),
    findall(Subject, subject_classifies(Subject), ClassifiedSubjects),
    sort(ClassifiedSubjects, SubjectSet).
test(determinism_every_subject_has_exactly_one_status) :-
    findall(Subject - Count, (nis2_lex_specialis_and_definitions_subject(Subject), status_count(Subject, Count)), Counts),
    Counts = [_|_],
    maplist(exactly_one, Counts).
test(determinism_risk_query_answers_once) :-
    findall(Subject - Count, (nis2_lex_specialis_and_definitions_subject(Subject), risk_count(Subject, Count)), Counts),
    Counts = [_|_],
    maplist(exactly_one, Counts).
test(determinism_notification_query_answers_once) :-
    findall(Subject - Count, (nis2_lex_specialis_and_definitions_subject(Subject), notification_count(Subject, Count)), Counts),
    Counts = [_|_],
    maplist(exactly_one, Counts).
test(citation_completeness_risk) :-
    findall(Result - Citations, (nis2_lex_specialis_and_definitions_subject(Subject), nis2_lex_specialis_and_definitions_profile_for(Subject, Profile), nis2_risk_management_provisions_status(Profile, Result, Citations)), Answers),
    Answers = [_|_],
    risk_citations(Fixed),
    maplist(shape_holds(Fixed), Answers).
test(citation_completeness_notification) :-
    findall(Result - Citations, (nis2_lex_specialis_and_definitions_subject(Subject), nis2_lex_specialis_and_definitions_profile_for(Subject, Profile), nis2_incident_notification_provisions_status(Profile, Result, Citations)), Answers),
    Answers = [_|_],
    notification_citations(Fixed),
    maplist(shape_holds(Fixed), Answers).
test(risk_answer_ignores_the_access_judgement) :-
    findall(Original - Hypothetical, (nis2_lex_specialis_and_definitions_subject(Subject), nis2_lex_specialis_and_definitions_profile_for(Subject, Profile), member(Value, [true, false, unsure]), nis2_risk_management_provisions_status(Profile, Original, _), nis2_lex_specialis_and_definitions_what_if(Profile, dora_gives_immediate_access_to_incident_notifications, Value, nis2_groups(Hypothetical, _))), Pairs),
    Pairs = [_|_],
    maplist(same_result, Pairs).
test(notification_answer_ignores_the_risk_judgement) :-
    findall(Original - Hypothetical, (nis2_lex_specialis_and_definitions_subject(Subject), nis2_lex_specialis_and_definitions_profile_for(Subject, Profile), member(Value, [true, false, unsure]), nis2_incident_notification_provisions_status(Profile, Original, _), nis2_lex_specialis_and_definitions_what_if(Profile, dora_risk_management_measures_at_least_equivalent_in_effect, Value, nis2_groups(_, Hypothetical))), Pairs),
    Pairs = [_|_],
    maplist(same_result, Pairs).
test(out_of_scope_decides_alone) :-
    nis2_lex_specialis_and_definitions_profile_for(out_of_scope_entity, Profile),
    findall(Status, (member(JudgementKey, [dora_risk_management_measures_at_least_equivalent_in_effect, dora_gives_immediate_access_to_incident_notifications, dora_incident_notification_requirements_at_least_equivalent_in_effect]), member(Value, [true, false, unsure]), nis2_lex_specialis_and_definitions_what_if(Profile, JudgementKey, Value, Status)), Statuses),
    length(Statuses, 9),
    maplist(out_of_scope_both, Statuses).

exactly_one(_ - 1).

status_count(Subject, Count) :-
    nis2_lex_specialis_and_definitions_profile_for(Subject, Profile),
    findall(Status, nis2_lex_specialis_and_definitions_status(Profile, Status), Statuses),
    length(Statuses, Count).

risk_count(Subject, Count) :-
    nis2_lex_specialis_and_definitions_profile_for(Subject, Profile),
    findall(Result - Citations, nis2_risk_management_provisions_status(Profile, Result, Citations), Answers),
    length(Answers, Count).

notification_count(Subject, Count) :-
    nis2_lex_specialis_and_definitions_profile_for(Subject, Profile),
    findall(Result - Citations, nis2_incident_notification_provisions_status(Profile, Result, Citations), Answers),
    length(Answers, Count).

answer_shape(nis2_provisions_disapplied, Citations, Citations).
answer_shape(nis2_provisions_apply, Citations, Citations).
answer_shape(out_of_scope, Citations, Citations).
answer_shape(indeterminate([_]), [], _).
answer_shape(needs_legal_review(open_textured(_, cite(_)), [inputs_relied_on(_)]), [], _).
answer_shape(input_problems([_|_]), [], _).

shape_holds(Fixed, Result - Citations) :-
    answer_shape(Result, Citations, Fixed).

same_result(Result - Result).

out_of_scope_both(nis2_groups(out_of_scope, out_of_scope)).

cp_test_names([totality_every_subject_classifies, determinism_every_subject_has_exactly_one_status, determinism_risk_query_answers_once, determinism_notification_query_answers_once, citation_completeness_risk, citation_completeness_notification, risk_answer_ignores_the_access_judgement, notification_answer_ignores_the_risk_judgement, out_of_scope_decides_alone]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
