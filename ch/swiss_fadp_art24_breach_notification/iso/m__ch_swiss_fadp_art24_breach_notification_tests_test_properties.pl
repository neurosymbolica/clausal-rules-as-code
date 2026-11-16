% SPDX-License-Identifier: EUPL-1.2
:- module(m__ch_swiss_fadp_art24_breach_notification_tests_test_properties, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__ch_swiss_fadp_art24_breach_notification_swiss_fadp_art24_breach_notification, [decide_swiss_fadp_art24_breach_notification/2, swiss_fadp_art24_breach_notification_status_values/1, swiss_controller_report_to_commissioner/3, swiss_processor_report_to_controller/3, swiss_information_of_data_subject/3, eu_controller_notification_to_supervisory_authority/3, compare_swiss_eu_authority_notification/5]).
:- use_module(m__ch_swiss_fadp_art24_breach_notification_kernel, [swiss_fadp_art24_breach_notification_input_problems/2]).
:- use_module(m__ch_swiss_fadp_art24_breach_notification_fixtures, [swiss_fadp_art24_breach_notification_subject/1, swiss_fadp_art24_breach_notification_profile_for/2]).

subject_classifies(Subject) :-
    swiss_fadp_art24_breach_notification_subject(Subject),
    swiss_fadp_art24_breach_notification_profile_for(Subject, Profile),
    decide_swiss_fadp_art24_breach_notification(Profile, _Verdict).

all_subjects(Subjects) :-
    findall(Subject, swiss_fadp_art24_breach_notification_subject(Subject), Subjects).

test(totality_every_subject_classifies) :-
    all_subjects(Subjects),
    sort(Subjects, SubjectSet),
    findall(Subject, subject_classifies(Subject), ClassifiedSubjects),
    sort(ClassifiedSubjects, SubjectSet).
test(determinism_every_query_has_one_answer_per_subject) :-
    all_subjects(Subjects),
    maplist(subject_has_one_answer_per_query, Subjects).
test(citations_follow_finality_on_every_subject) :-
    all_subjects(Subjects),
    maplist(subject_citations_follow_finality, Subjects).
test(answers_are_in_the_vocabulary_on_every_subject) :-
    all_subjects(Subjects),
    maplist(subject_answers_in_vocabulary, Subjects).
test(comparison_is_consistent_on_every_subject) :-
    all_subjects(Subjects),
    maplist(subject_comparison_consistent, Subjects).
test(input_problems_answer_every_query) :-
    maplist(problem_answers_agree, [duplicate_and_unknown_keys, crisp_key_unsure, not_an_attribute_list]).
test(high_risk_does_not_change_processor_or_information) :-
    swiss_fadp_art24_breach_notification_profile_for(high_risk_breach_all_duties, HighRiskProfile),
    swiss_fadp_art24_breach_notification_profile_for(breach_without_high_risk, LowRiskProfile),
    swiss_processor_report_to_controller(HighRiskProfile, HighRiskProcessor, _),
    swiss_processor_report_to_controller(LowRiskProfile, LowRiskProcessor, _),
    HighRiskProcessor == LowRiskProcessor,
    swiss_information_of_data_subject(HighRiskProfile, HighRiskInformation, _),
    swiss_information_of_data_subject(LowRiskProfile, LowRiskInformation, _),
    HighRiskInformation == LowRiskInformation,
    eu_controller_notification_to_supervisory_authority(HighRiskProfile, HighRiskEuropean, _),
    eu_controller_notification_to_supervisory_authority(LowRiskProfile, LowRiskEuropean, _),
    HighRiskEuropean == LowRiskEuropean.
test(high_risk_changes_the_controller_report) :-
    swiss_fadp_art24_breach_notification_profile_for(high_risk_breach_all_duties, HighRiskProfile),
    swiss_fadp_art24_breach_notification_profile_for(breach_without_high_risk, LowRiskProfile),
    swiss_controller_report_to_commissioner(HighRiskProfile, HighRiskController, _),
    swiss_controller_report_to_commissioner(LowRiskProfile, LowRiskController, _),
    HighRiskController \== LowRiskController.

subject_has_one_answer_per_query(Subject) :-
    swiss_fadp_art24_breach_notification_profile_for(Subject, Profile),
    findall(ControllerResult - ControllerCitations, swiss_controller_report_to_commissioner(Profile, ControllerResult, ControllerCitations), ControllerAnswers),
    length(ControllerAnswers, 1),
    findall(ProcessorResult - ProcessorCitations, swiss_processor_report_to_controller(Profile, ProcessorResult, ProcessorCitations), ProcessorAnswers),
    length(ProcessorAnswers, 1),
    findall(InformationResult - InformationCitations, swiss_information_of_data_subject(Profile, InformationResult, InformationCitations), InformationAnswers),
    length(InformationAnswers, 1),
    findall(EuropeanResult - EuropeanCitations, eu_controller_notification_to_supervisory_authority(Profile, EuropeanResult, EuropeanCitations), EuropeanAnswers),
    length(EuropeanAnswers, 1),
    findall(answer(SwissSide, EuropeanSide, Difference, ChangedBy), compare_swiss_eu_authority_notification(Profile, SwissSide, EuropeanSide, Difference, ChangedBy), ComparisonAnswers),
    length(ComparisonAnswers, 1),
    findall(Problems, swiss_fadp_art24_breach_notification_input_problems(Profile, Problems), ProblemLists),
    length(ProblemLists, 1),
    findall(Verdict, decide_swiss_fadp_art24_breach_notification(Profile, Verdict), Verdicts),
    length(Verdicts, 1).

canonical_citation(cite(ch_fadp_art_5_h)).
canonical_citation(cite(ch_fadp_art_24_1)).
canonical_citation(cite(ch_fadp_art_24_3)).
canonical_citation(cite(ch_fadp_art_24_4)).
canonical_citation(cite(ch_fadp_art_24_5)).
canonical_citation(cite(eu_reg_2016_679_art_33_1)).

finality_citations(Result, Citations) :-
    atom(Result),
    Citations = [_|_],
    maplist(canonical_citation, Citations).
finality_citations(Result, []) :-
    compound(Result).

subject_citations_follow_finality(Subject) :-
    swiss_fadp_art24_breach_notification_profile_for(Subject, Profile),
    swiss_controller_report_to_commissioner(Profile, ControllerResult, ControllerCitations),
    finality_citations(ControllerResult, ControllerCitations),
    swiss_processor_report_to_controller(Profile, ProcessorResult, ProcessorCitations),
    finality_citations(ProcessorResult, ProcessorCitations),
    swiss_information_of_data_subject(Profile, InformationResult, InformationCitations),
    finality_citations(InformationResult, InformationCitations),
    eu_controller_notification_to_supervisory_authority(Profile, EuropeanResult, EuropeanCitations),
    finality_citations(EuropeanResult, EuropeanCitations).

result_in_vocabulary(Result) :-
    atom(Result),
    swiss_fadp_art24_breach_notification_status_values(StatusValues),
    member(Result, StatusValues).
result_in_vocabulary(Result) :-
    compound(Result),
    functor(Result, Name, Arity),
    member(Name/Arity, [indeterminate/1, needs_legal_review/2, input_problems/1]).

subject_answers_in_vocabulary(Subject) :-
    swiss_fadp_art24_breach_notification_profile_for(Subject, Profile),
    swiss_controller_report_to_commissioner(Profile, ControllerResult, _),
    result_in_vocabulary(ControllerResult),
    swiss_processor_report_to_controller(Profile, ProcessorResult, _),
    result_in_vocabulary(ProcessorResult),
    swiss_information_of_data_subject(Profile, InformationResult, _),
    result_in_vocabulary(InformationResult),
    eu_controller_notification_to_supervisory_authority(Profile, EuropeanResult, _),
    result_in_vocabulary(EuropeanResult).

comparison_consistent(SwissResult, EuropeanResult, same, []) :-
    atom(SwissResult),
    atom(EuropeanResult),
    SwissResult == EuropeanResult.
comparison_consistent(SwissResult, EuropeanResult, differs, [cite(ch_fadp_art_24_1), cite(eu_reg_2016_679_art_33_1)]) :-
    atom(SwissResult),
    atom(EuropeanResult),
    SwissResult \== EuropeanResult.
comparison_consistent(SwissResult, _, not_comparable, []) :-
    compound(SwissResult).
comparison_consistent(SwissResult, EuropeanResult, not_comparable, []) :-
    atom(SwissResult),
    compound(EuropeanResult).

subject_comparison_consistent(Subject) :-
    swiss_fadp_art24_breach_notification_profile_for(Subject, Profile),
    compare_swiss_eu_authority_notification(Profile, SwissSide, EuropeanSide, Difference, ChangedBy),
    swiss_controller_report_to_commissioner(Profile, SwissResult, _),
    eu_controller_notification_to_supervisory_authority(Profile, EuropeanResult, _),
    SwissSide == SwissResult,
    EuropeanSide == EuropeanResult,
    comparison_consistent(SwissSide, EuropeanSide, Difference, ChangedBy).

problem_answers_agree(Subject) :-
    swiss_fadp_art24_breach_notification_profile_for(Subject, Profile),
    swiss_fadp_art24_breach_notification_input_problems(Profile, [Problem|Problems]),
    swiss_controller_report_to_commissioner(Profile, input_problems([Problem|Problems]), []),
    swiss_processor_report_to_controller(Profile, input_problems([Problem|Problems]), []),
    swiss_information_of_data_subject(Profile, input_problems([Problem|Problems]), []),
    eu_controller_notification_to_supervisory_authority(Profile, input_problems([Problem|Problems]), []),
    compare_swiss_eu_authority_notification(Profile, input_problems([Problem|Problems]), input_problems([Problem|Problems]), not_comparable, []).

cp_test_names([totality_every_subject_classifies, determinism_every_query_has_one_answer_per_subject, citations_follow_finality_on_every_subject, answers_are_in_the_vocabulary_on_every_subject, comparison_is_consistent_on_every_subject, input_problems_answer_every_query, high_risk_does_not_change_processor_or_information, high_risk_changes_the_controller_report]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
