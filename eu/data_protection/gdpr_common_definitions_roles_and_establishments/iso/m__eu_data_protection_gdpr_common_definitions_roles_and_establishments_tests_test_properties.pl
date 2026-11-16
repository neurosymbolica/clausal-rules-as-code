% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_common_definitions_roles_and_establishments_tests_test_properties, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(library(reif), [memberd_t/3]).
:- use_module(m__eu_data_protection_gdpr_common_definitions_roles_and_establishments_gdpr_common_definitions_roles_and_establishments, [party_is_controller/2, party_is_processor/2, genetic_data/2, biometric_data/2, data_concerning_health/2, main_establishment/2, enterprise/2, group_of_undertakings/2, supervisory_authority_concerned/2, cross_border_processing/2, relevant_and_reasoned_objection/2, decide_gdpr_common_definitions_roles_and_establishments/2, gdpr_common_definitions_roles_and_establishments_status_values/1]).
:- use_module(m__eu_data_protection_gdpr_common_definitions_roles_and_establishments_fixtures, [gdpr_common_definitions_roles_and_establishments_subject/1, gdpr_common_definitions_roles_and_establishments_profile_for/2]).

relation_name(party_is_controller).
relation_name(party_is_processor).
relation_name(genetic_data).
relation_name(biometric_data).
relation_name(data_concerning_health).
relation_name(main_establishment).
relation_name(enterprise).
relation_name(group_of_undertakings).
relation_name(supervisory_authority_concerned).
relation_name(cross_border_processing).
relation_name(relevant_and_reasoned_objection).

solution_count(Relation, Subject, Count) :-
    gdpr_common_definitions_roles_and_establishments_profile_for(Subject, Profile),
    findall(Answer, call(Relation, Profile, Answer), Answers),
    length(Answers, Count).

uncited_answer(Relation, Subject) :-
    gdpr_common_definitions_roles_and_establishments_subject(Subject),
    relation_name(Relation),
    gdpr_common_definitions_roles_and_establishments_profile_for(Subject, Profile),
    call(Relation, Profile, definition_answer(Status, _, [])),
    status_functor(Status, Functor),
    dif(Functor, input_problems).

unlisted_status(Relation, Subject) :-
    gdpr_common_definitions_roles_and_establishments_subject(Subject),
    relation_name(Relation),
    gdpr_common_definitions_roles_and_establishments_profile_for(Subject, Profile),
    call(Relation, Profile, definition_answer(Status, _, _)),
    status_functor(Status, Functor),
    gdpr_common_definitions_roles_and_establishments_status_values(Values),
    memberd_t(Functor, Values, false).

status_functor(Status, Functor) :-
    functor(Status, Functor, _).

subject_classifies(Subject) :-
    gdpr_common_definitions_roles_and_establishments_subject(Subject),
    gdpr_common_definitions_roles_and_establishments_profile_for(Subject, Profile),
    decide_gdpr_common_definitions_roles_and_establishments(Profile, _Verdict).

test(totality_every_subject_classifies) :-
    findall(Subject, gdpr_common_definitions_roles_and_establishments_subject(Subject), Subjects),
    sort(Subjects, SubjectSet),
    findall(Subject, subject_classifies(Subject), ClassifiedSubjects),
    sort(ClassifiedSubjects, SubjectSet).
test(headline_verdict_is_exactly_one_per_subject) :-
    findall(Count, (gdpr_common_definitions_roles_and_establishments_subject(Subject), gdpr_common_definitions_roles_and_establishments_profile_for(Subject, Profile), findall(Verdict, decide_gdpr_common_definitions_roles_and_establishments(Profile, Verdict), Verdicts), length(Verdicts, Count)), Counts),
    sort(Counts, [1]).
test(every_relation_yields_exactly_one_answer_on_every_subject) :-
    findall(Count, (gdpr_common_definitions_roles_and_establishments_subject(Subject), relation_name(Relation), solution_count(Relation, Subject, Count)), Counts),
    sort(Counts, [1]).
test(the_single_solution_count_is_one) :-
    solution_count(party_is_controller, controller_determines, 1).
test(a_listed_status_is_not_flagged_unlisted) :-
    gdpr_common_definitions_roles_and_establishments_status_values(Values),
    memberd_t(met, Values, true).

test(every_answer_other_than_input_problems_carries_a_citation, fail) :-
    uncited_answer(_, _).
test(the_uncited_detector_is_not_vacuous, fail) :-
    solution_count(party_is_controller, controller_determines, 2).

cp_test_names([totality_every_subject_classifies, headline_verdict_is_exactly_one_per_subject, every_relation_yields_exactly_one_answer_on_every_subject, the_single_solution_count_is_one, a_listed_status_is_not_flagged_unlisted]).
cp_test_fail_names([every_answer_other_than_input_problems_carries_a_citation, the_uncited_detector_is_not_vacuous]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
