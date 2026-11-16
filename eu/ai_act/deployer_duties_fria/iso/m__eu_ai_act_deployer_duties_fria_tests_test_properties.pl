% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_ai_act_deployer_duties_fria_tests_test_properties, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_lists_extra, [is_list/1]).
:- use_module(m__eu_ai_act_deployer_duties_fria_deployer_duties_fria, [decide_deployer_duties_fria/2, deployer_obligation_status/5, log_retention_period_status/5, deployer_duties_fria_status_values/1]).
:- use_module(m__eu_ai_act_deployer_duties_fria_citations, [citation/2]).
:- use_module(m__eu_ai_act_deployer_duties_fria_fixtures, [deployer_duties_fria_subject/1, deployer_duties_fria_profile_for/2]).

obligations([log_retention, information_of_workers_and_their_representatives, information_of_natural_persons_subject_to_decisions, fundamental_rights_impact_assessment, notification_of_assessment_results]).

all_subjects(Subjects) :-
    findall(Subject, deployer_duties_fria_subject(Subject), AllSubjects),
    sort(AllSubjects, Subjects).

subject_verdicts(Subject, Verdicts) :-
    deployer_duties_fria_profile_for(Subject, Request),
    findall(Verdict, decide_deployer_duties_fria(Request, Verdict), Verdicts).

exactly_one_verdict(Subject) :-
    subject_verdicts(Subject, [_]).

subject_well_formed(Subject) :-
    subject_verdicts(Subject, [deployer_duties_fria_verdict(Result, Citations)]),
    result_well_formed(Result, Citations).

result_well_formed(Result, [Citation|Citations]) :-
    atom(Result),
    deployer_duties_fria_status_values(StatusValues),
    member(Result, StatusValues),
    maplist(recorded_citation, [Citation|Citations]),
    sort([Citation|Citations], SortedCitations),
    length([Citation|Citations], Count),
    length(SortedCitations, Count).
result_well_formed(input_problems([Problem|Problems]), []) :-
    is_list([Problem|Problems]).
result_well_formed(indeterminate([MissingKey]), []) :-
    atom(MissingKey).
result_well_formed(needs_legal_review(open_textured(Judgement, cite(CitationKey)), [inputs_relied_on(Pairs)]), []) :-
    atom(Judgement),
    citation(CitationKey, _),
    is_list(Pairs).

recorded_citation(cite(CitationKey)) :-
    citation(CitationKey, _).

obligation_case(Profile - AssessmentDate) :-
    deployer_duties_fria_subject(Subject),
    deployer_duties_fria_profile_for(Subject, deployer_obligation_request(Profile, _, AssessmentDate)).

every_obligation_answers_once(Profile - AssessmentDate) :-
    obligations(Obligations),
    maplist(obligation_answers_once(Profile, AssessmentDate), Obligations).

obligation_answers_once(Profile, AssessmentDate, Obligation) :-
    findall(Result - Citations, deployer_obligation_status(Profile, Obligation, AssessmentDate, Result, Citations), [Result0 - Citations0]),
    result_well_formed(Result0, Citations0).

retention_answers_once(Profile, AssessmentDate, RetentionMonths) :-
    findall(Result - Citations, log_retention_period_status(Profile, RetentionMonths, AssessmentDate, Result, Citations), [Result0 - Citations0]),
    result_well_formed(Result0, Citations0).

not_applicable_before_the_general_date(Profile, Obligation) :-
    deployer_obligation_status(Profile, Obligation, date(2027, 12, 1), not_applicable_on_date, _).

meets_the_minimum(Profile, AssessmentDate, RetentionMonths) :-
    log_retention_period_status(Profile, RetentionMonths, AssessmentDate, retention_period_of_at_least_six_months, _).

test(totality_and_determinism_every_subject_yields_exactly_one_verdict) :-
    all_subjects(Subjects),
    Subjects = [_|_],
    maplist(exactly_one_verdict, Subjects).
test(every_verdict_is_well_formed) :-
    all_subjects(Subjects),
    maplist(subject_well_formed, Subjects).
test(every_obligation_answers_once_on_every_obligation_profile) :-
    findall(Case, obligation_case(Case), Cases),
    Cases = [_|_],
    maplist(every_obligation_answers_once, Cases).
test(every_retention_period_answers_once) :-
    deployer_duties_fria_profile_for(retention_of_six_months, log_retention_period_request(Profile, _, AssessmentDate)),
    numlist(0, 24, Months),
    maplist(retention_answers_once(Profile, AssessmentDate), Months).
test(the_empty_profile_answers_once_for_every_obligation) :-
    every_obligation_answers_once([] - date(2029, 6, 1)).
test(before_the_general_date_no_obligation_applies_to_the_base_deployer) :-
    deployer_duties_fria_profile_for(log_retention_applies, deployer_obligation_request(Profile, _, _)),
    obligations(Obligations),
    maplist(not_applicable_before_the_general_date(Profile), Obligations).
test(before_the_general_date_no_obligation_applies_even_on_an_empty_profile) :-
    obligations(Obligations),
    maplist(not_applicable_before_the_general_date([]), Obligations).
test(every_period_from_six_months_meets_the_minimum) :-
    deployer_duties_fria_profile_for(retention_of_six_months, log_retention_period_request(Profile, _, AssessmentDate)),
    numlist(6, 36, Months),
    maplist(meets_the_minimum(Profile, AssessmentDate), Months).
test(the_status_table_lists_each_atom_once) :-
    deployer_duties_fria_status_values(StatusValues),
    sort(StatusValues, SortedValues),
    length(StatusValues, Count),
    length(SortedValues, Count).

cp_test_names([totality_and_determinism_every_subject_yields_exactly_one_verdict, every_verdict_is_well_formed, every_obligation_answers_once_on_every_obligation_profile, every_retention_period_answers_once, the_empty_profile_answers_once_for_every_obligation, before_the_general_date_no_obligation_applies_to_the_base_deployer, before_the_general_date_no_obligation_applies_even_on_an_empty_profile, every_period_from_six_months_meets_the_minimum, the_status_table_lists_each_atom_once]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
