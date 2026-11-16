% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_nis2_governance_risk_measures_tests_test_properties, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_nis2_governance_risk_measures_nis2_governance_risk_measures, [decide_nis2_governance_risk_measures/2, nis2_governance_risk_measures_status/2, management_body_duties/2, risk_management_measures/2, proportionality_factors/2, supply_chain_considerations/2, corrective_measures_duty/3]).
:- use_module(m__eu_nis2_governance_risk_measures_citations, [implements/1]).
:- use_module(m__eu_nis2_governance_risk_measures_fixtures, [nis2_governance_risk_measures_subject/1, nis2_governance_risk_measures_profile_for/2]).

subject_classifies(Subject) :-
    nis2_governance_risk_measures_subject(Subject),
    nis2_governance_risk_measures_profile_for(Subject, Profile),
    decide_nis2_governance_risk_measures(Profile, _Verdict).

subject_has_one_verdict(Subject) :-
    nis2_governance_risk_measures_subject(Subject),
    nis2_governance_risk_measures_profile_for(Subject, Profile),
    findall(Verdict, decide_nis2_governance_risk_measures(Profile, Verdict), Verdicts),
    length(Verdicts, 1).

subject_has_one_answer_per_query(Subject) :-
    nis2_governance_risk_measures_subject(Subject),
    nis2_governance_risk_measures_profile_for(Subject, Profile),
    findall(Duties, management_body_duties(Profile, Duties), DutyAnswers),
    length(DutyAnswers, 1),
    findall(Measures, risk_management_measures(Profile, Measures), MeasureAnswers),
    length(MeasureAnswers, 1),
    findall(Factors, proportionality_factors(Profile, Factors), FactorAnswers),
    length(FactorAnswers, 1),
    findall(Considerations, supply_chain_considerations(Profile, Considerations), ConsiderationAnswers),
    length(ConsiderationAnswers, 1),
    findall(Result - Citations, corrective_measures_duty(Profile, Result, Citations), CorrectiveAnswers),
    length(CorrectiveAnswers, 1).

duty_cite_recorded(duty(_, cite(Key))) :-
    implements(Key).

measure_cite_recorded(measure(_, cite(Key))) :-
    implements(Key).

factor_cite_recorded(factor(_, cite(Key))) :-
    implements(Key).

consideration_cite_recorded(consideration(_, cite(Key))) :-
    implements(Key).

test(totality_every_subject_classifies) :-
    findall(Subject, nis2_governance_risk_measures_subject(Subject), Subjects),
    sort(Subjects, SubjectSet),
    findall(Subject, subject_classifies(Subject), ClassifiedSubjects),
    sort(ClassifiedSubjects, SubjectSet).
test(determinism_every_subject_has_exactly_one_verdict) :-
    findall(Subject, nis2_governance_risk_measures_subject(Subject), Subjects),
    findall(Subject, subject_has_one_verdict(Subject), SingleSubjects),
    Subjects == SingleSubjects.
test(determinism_every_query_has_exactly_one_answer_for_every_subject) :-
    findall(Subject, nis2_governance_risk_measures_subject(Subject), Subjects),
    findall(Subject, subject_has_one_answer_per_query(Subject), SingleSubjects),
    Subjects == SingleSubjects.
test(every_duty_citation_is_a_recorded_key) :-
    nis2_governance_risk_measures_profile_for(essential_all_true, Profile),
    management_body_duties(Profile, Duties),
    maplist(duty_cite_recorded, Duties).
test(every_measure_citation_is_a_recorded_key) :-
    nis2_governance_risk_measures_profile_for(essential_all_true, Profile),
    risk_management_measures(Profile, Measures),
    maplist(measure_cite_recorded, Measures).
test(every_factor_citation_is_a_recorded_key) :-
    nis2_governance_risk_measures_profile_for(essential_all_true, Profile),
    proportionality_factors(Profile, Factors),
    maplist(factor_cite_recorded, Factors).
test(every_consideration_citation_is_a_recorded_key) :-
    nis2_governance_risk_measures_profile_for(essential_all_true, Profile),
    supply_chain_considerations(Profile, Considerations),
    maplist(consideration_cite_recorded, Considerations).
test(out_of_scope_entity_has_no_list_answer_in_any_query) :-
    nis2_governance_risk_measures_profile_for(out_of_scope_entity, Profile),
    management_body_duties(Profile, []),
    risk_management_measures(Profile, []),
    proportionality_factors(Profile, []),
    supply_chain_considerations(Profile, []),
    corrective_measures_duty(Profile, no_corrective_measures_duty, [cite(eu_dir_2022_2555_art_21_4)]).
test(point_j_true_measures_extend_point_j_false_measures) :-
    nis2_governance_risk_measures_profile_for(essential_all_true, TrueProfile),
    nis2_governance_risk_measures_profile_for(important_all_false, FalseProfile),
    risk_management_measures(TrueProfile, TrueMeasures),
    risk_management_measures(FalseProfile, FalseMeasures),
    append(FalseMeasures, [_PointJ], TrueMeasures).
test(input_problems_take_precedence_over_a_missing_key) :-
    decide_nis2_governance_risk_measures([attribute(surprise, true)], nis2_governance_risk_measures_verdict(input_problems([unknown_key(surprise)]), [])).

cp_test_names([totality_every_subject_classifies, determinism_every_subject_has_exactly_one_verdict, determinism_every_query_has_exactly_one_answer_for_every_subject, every_duty_citation_is_a_recorded_key, every_measure_citation_is_a_recorded_key, every_factor_citation_is_a_recorded_key, every_consideration_citation_is_a_recorded_key, out_of_scope_entity_has_no_list_answer_in_any_query, point_j_true_measures_extend_point_j_false_measures, input_problems_take_precedence_over_a_missing_key]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
